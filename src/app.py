from flask import jsonify, redirect, render_template, request, abort

from config import app, test_env
from db_helper import reset_db
from repositories.refs_repository import create_reference as save_reference
from repositories.refs_repository import get_reference, get_references, delete_reference


@app.route("/")
def index():
    return render_template("index.html", references=get_references())


@app.route("/add_reference")
def add_reference():
    return render_template("new_reference.html")


@app.route("/create_reference", methods=["POST"])
def create_reference():
    save_reference(
        citekey=request.form["citekey"],
        entry_type=request.form["entry_type"],
        title=request.form["title"],
        author=request.form["author"],
        year=request.form["year"],
        publisher=request.form["publisher"],
    )
    return redirect("/")

@app.route("/edit_reference/<int:refs_id>", methods=["GET", "POST"])
def edit_reference(refs_id):
    reference = get_reference(refs_id)
    if reference is None:
        abort(404)

    if request.method == "POST":
        update_reference(
            refs_id,
            citekey=request.form["citekey"],
            entry_type=request.form["entry_type"],
            title=request.form["title"],
            author=request.form["author"],
            year=request.form["year"],
            publisher=request.form["publisher"],
        )
        return redirect("/")

    return render_template("edit_reference.html", reference=reference)

@app.route("/delete_reference/<int:refs_id>",methods=["GET", "POST"])
def remove_reference(refs_id):
    if request.method=="POST":
        if "remove" in request.form:
            delete_reference(refs_id)
        return redirect("/")

    reference=get_reference(refs_id)
    if reference is None:
        abort(404)
    return render_template("delete_reference.html",reference=reference)


# testausta varten oleva reitti
if test_env:

    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({"message": "db reset"})
