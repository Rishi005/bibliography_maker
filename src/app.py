from flask import jsonify, redirect, render_template, request, abort

from bibtex import to_bibtex
from config import app, test_env
from db_helper import reset_db
from entry_types import ENTRY_TYPES, fields_for, detail_fields
from repositories.refs_repository import (
    create_reference as save_reference,
    get_references,
    get_reference,
    update_reference as save_update,
)

app.jinja_env.globals["detail_fields"] = detail_fields


def read_form(entry_type):
    return {
        f.name: (request.form.get(f.name, "").strip() or None)
        for f in fields_for(entry_type)
    }


def validate(fields, values):
    return [f"{f.label} is required" for f in fields
            if f.required and not values.get(f.name)]


def render_form(entry_type, action, values, reference=None, errors=None, status=200):
    return render_template(
        "form.html",
        entry_type=entry_type,
        fields=fields_for(entry_type),
        action=action,
        values=values,
        reference=reference,
        errors=errors or [],
    ), status


@app.route("/")
def index():
    return render_template("index.html",
        references=get_references())



@app.route("/add_reference")
def add_reference():
    entry_type = request.args.get("entry_type")
    if entry_type is None:
        return render_template("choose_type.html", entry_types=ENTRY_TYPES)
    if entry_type not in ENTRY_TYPES:
        abort(404)
    values = {f.name: None for f in fields_for(entry_type)}
    return render_form(entry_type, "/create_reference", values)


@app.route("/create_reference", methods=["POST"])
def create_reference():
    entry_type = request.form.get("entry_type")
    if entry_type not in ENTRY_TYPES:
        abort(400)
    values = read_form(entry_type)
    errors = validate(fields_for(entry_type), values)
    if errors:
        return render_form(entry_type, "/create_reference", values,
                errors=errors, status=400)
    save_reference(entry_type, values)
    return redirect("/")


@app.route("/edit_reference/<int:refs_id>", methods=["GET", "POST"])
def edit_reference(refs_id):
    reference = get_reference(refs_id)
    if reference is None:
        abort(404)
    entry_type = reference.entry_type
    action = f"/edit_reference/{refs_id}"

    if request.method == "POST":
        values = read_form(entry_type)
        errors = validate(fields_for(entry_type), values)
        if errors:
            return render_form(entry_type, action, values,
                reference=reference, errors=errors, status=400)
        save_update(refs_id, values)
        return redirect("/")

    values = {f.name: getattr(reference, f.name)
              for f in fields_for(entry_type)}
    return render_form(entry_type, action, values, reference=reference)


@app.route("/bibtex")
def bibtex():
    entries = [to_bibtex(reference) for reference in get_references()]
    return render_template("bibtex.html", entries=entries)


if test_env:
    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({"message": "db reset"})