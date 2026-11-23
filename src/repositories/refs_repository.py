from sqlalchemy import text

from config import db
from entities.reference import Reference

ALL_COLUMNS = ("id, citekey, entry_type, author, title, year, "
               "publisher, journal, volume, pages")


def get_references():
    sql = f"SELECT {ALL_COLUMNS} FROM refs"
    params = {}
    sql += " ORDER BY id"
    rows = db.session.execute(text(sql), params).fetchall()
    return [Reference(**row._mapping) for row in rows]


def get_reference(refs_id):
    row = db.session.execute(
        text(f"SELECT {ALL_COLUMNS} FROM refs WHERE id = :id"), {"id": refs_id}
    ).fetchone()
    return Reference(**row._mapping) if row else None


def create_reference(entry_type, values):
    columns = ["entry_type"] + list(values.keys())
    placeholders = ", ".join(f":{c}" for c in columns)
    db.session.execute(
        text(f"INSERT INTO refs ({', '.join(columns)}) VALUES ({placeholders})"),
        {"entry_type": entry_type, **values},
    )
    db.session.commit()


def update_reference(refs_id, values):
    assignments = ", ".join(f"{c} = :{c}" for c in values.keys())
    db.session.execute(
        text(f"UPDATE refs SET {assignments} WHERE id = :id"),
        {**values, "id": refs_id},
    )
    db.session.commit()