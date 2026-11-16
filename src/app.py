from flask import redirect, render_template, request, jsonify, flash
from db_helper import reset_db
from repositories.refs_repository import create_reference as save_reference
from config import app, test_env

@app.route("/")
def index():
    return redirect("/add_reference")

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
    

# testausta varten oleva reitti
if test_env:
    @app.route("/reset_db")
    def reset_database():
        reset_db()
        return jsonify({ 'message': "db reset" })
