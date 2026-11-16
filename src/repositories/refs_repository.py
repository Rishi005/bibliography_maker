from config import db
from sqlalchemy import text

from entities.reference import Reference

def get_references():
    result = db.session.execute(text(
        "SELECT id, citekey, entry_type, author, title, year, publisher FROM refs"
    ))
    refs = result.fetchall()
    return [Reference(*ref) for ref in refs]

def create_reference(citekey, entry_type, author, title, year, publisher):
    sql = text(
        "INSERT INTO refs (citekey, entry_type, author, title, year, publisher) "
        "VALUES (:citekey, :entry_type, :author, :title, :year, :publisher)"
    )
    db.session.execute(sql, {
        "citekey": citekey,
        "entry_type": entry_type,
        "author": author,
        "title": title,
        "year": year,
        "publisher": publisher,
    })
    db.session.commit()
