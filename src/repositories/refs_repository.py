from sqlalchemy import text

from config import db
from entities.reference import Reference


def get_references():
    result = db.session.execute(
        text("SELECT id, citekey, entry_type, author, title, year, publisher FROM refs")
    )
    refs = result.fetchall()
    return [Reference(*ref) for ref in refs]

def get_reference(refs_id):
    result = db.session.execute(
        text("SELECT id, citekey, entry_type, author, title, year, publisher"
        "FROM refs WHERE id = :id" {"id": refs_id})
    )
    row = result.fetchone()
    return Reference(*row) if row else None


def create_reference(citekey, entry_type, author, title, year, publisher):
    sql = text(
        "INSERT INTO refs (citekey, entry_type, author, title, year, publisher) "
        "VALUES (:citekey, :entry_type, :author, :title, :year, :publisher)"
    )
    db.session.execute(
        sql,
        {
            "citekey": citekey,
            "entry_type": entry_type,
            "author": author,
            "title": title,
            "year": year,
            "publisher": publisher,
        },
    )
    db.session.commit()

def update_reference(refs_id, citekey, entry_type, author, title, year, publisher):
    sql = text(
        "UPDATE refs SET citekey = :citekey, entry_type = :entry_type, "
        "author = :author, title = :title, year = :year, publisher = :publisher "
        "WHERE id = :id"
    )
    db.session.execute(sql, {
        "id": refs_id,
        "citekey": citekey,
        "entry_type": entry_type,
        "author": author,
        "title": title,
        "year": year,
        "publisher": publisher,
    })
    db.session.commit()
