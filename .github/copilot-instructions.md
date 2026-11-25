# Copilot Instructions

## Build and run

- The project requires Python 3.12 or newer and uses `uv` for dependencies.
- Install the development environment with `uv sync`.
- Set `DATABASE_URL` and `SECRET_KEY` for local runs. CI uses:
  - `DATABASE_URL=sqlite:///test.db`
  - `TEST_ENV=true`
  - `SECRET_KEY=sekret`
- Initialize or recreate the SQLite schema with `uv run python src/db_helper.py`. This drops existing application tables before recreating them, so do not run it against data that must be preserved.
- Start the application with `uv run python src/index.py`. It listens on `0.0.0.0:5001` with Flask debug mode enabled.
- Build the container with `docker build -t bibliography-maker .`.
- Deploy Kubernetes/OpenShift resources with `kubectl kustomize kustomization.yaml` for a rendered preview or `kubectl apply -k .` to apply them. The manifests require `secret.env` for Kustomize secret generation.

## Tests and lint

- Run all pytest unit tests: `uv run pytest src/tests`.
- Run one pytest test file: `uv run pytest src/tests/validate_todo_test.py`.
- Run one pytest test method: `uv run pytest src/tests/validate_todo_test.py::TestTodoValidation::test_too_short_or_long_raises_error`.
- Install Chromium for browser tests: `uv run rfbrowser install --with-deps chromium`.
- Run the complete Robot Framework suite with database initialization and a live Flask server: `bash run_robot_tests.sh`.
- Run one Robot test suite: initialize the database and start the server as `run_robot_tests.sh` does, then run `uv run robot --variable HEADLESS:true src/story_tests/reference.robot`.
- Run one Robot test case by name: `uv run robot --variable HEADLESS:true --test "Submitting a reference saves and displays it" src/story_tests/reference.robot`.
- Check linting with `uv run ruff check .`.
- Check formatting with `uv run ruff format --check .`.
- Ruff is a development dependency, but the current CI workflow runs pytest and Robot Framework only; it does not run the Ruff commands.

## Architecture

- `src/index.py` is the executable entry point and starts `src/app.py`.
- `src/app.py` owns Flask routes, request/form extraction, required-field validation, template selection, redirects, and test-only database reset routing.
- `src/config.py` creates the Flask application and Flask-SQLAlchemy database using `DATABASE_URL`, `SECRET_KEY`, and `TEST_ENV` environment variables.
- `src/entry_types.py` is the entry-type schema. `COMMON` fields are shared by books and articles; each entry type contributes its own labels and optional fields.
- `src/entities/reference.py` is a plain `Reference` model object rather than an SQLAlchemy mapped model.
- `src/repositories/refs_repository.py` is the database boundary. Routes call its create/get/update functions instead of issuing SQL directly.
- `src/db_helper.py` recreates or clears the SQLite schema. `src/schema.sql` contains the sole `refs` table definition.
- `src/templates/` contains server-rendered Jinja pages. Form fields and detail fields are generated from `entry_types.py`.
- `src/story_tests/resource.robot` supplies shared Robot variables and setup keywords used by `reference.robot`.

The request flow is:

1. A route in `src/app.py` reads query or form values.
2. Entry-type field metadata determines the fields and required validation.
3. The repository module performs SQLAlchemy `text()` queries.
4. Rows are mapped into `Reference` objects.
5. Jinja templates render the list or form.

Deployment uses the same Flask process and SQLite database. The OpenShift deployment mounts a persistent volume at `/app/data`, and `DATABASE_URL` points to `sqlite:////app/data/database.db`.

## Repository conventions

- Run Python modules and tests through `uv run`; the project is not a packaged Python distribution (`package = false`).
- Flask routes are implemented in [src/app.py](/C:/Users/rishi/bibliography_maker/src/app.py), while database operations belong in [src/repositories/refs_repository.py](/C:/Users/rishi/bibliography_maker/src/repositories/refs_repository.py).
- Add or change user-entered fields in `src/entry_types.py`, then ensure the database table in `src/schema.sql` has the matching column.
- Keep required-field rules in `entry_types.py`; `app.validate()` derives required-field errors from that metadata.
- Strip submitted form text and convert empty strings to `None` in `app.read_form()`/the route flow. Preserve that behavior for new fields.
- Repository functions return `Reference` objects rather than raw SQLAlchemy rows.
- SQL placeholders and column names are generated from application field names. When changing repository SQL or entry fields, keep values and table column names aligned.
- The `citekey` database column is unique and citekey validation is database-backed in addition to the required-field form check.
- `TEST_ENV=true` enables `/reset_db` and is required by the Robot test setup. Production/configuration manifests set `TEST_ENV=false`.
- Robot tests reset references through `/reset_db` before each test and use `localhost:5001` as `HOME_URL`.
- Browser test scripts require a browser and a server. The local script initializes the database, starts the server, waits for an HTTP 200 response, runs headless Chromium, and stops the server.
