from dataclasses import dataclass


@dataclass(frozen=True)
class Field:
    name: str
    label: str
    kind: str = "text"
    required: bool = True


COMMON = [
    Field("citekey", "Citekey"),
    Field("author", "Author"),
    Field("title", "Title"),
    Field("year", "Year", kind="number"),
]

ENTRY_TYPES = {
    "book": {
        "label": "Book",
        "fields": COMMON + [Field("publisher", "Publisher", required=False)],
    },
    "article": {
        "label": "Article",
        "fields": COMMON + [
            Field("journal", "Journal"),
            Field("volume", "Volume", required=False),
            Field("pages", "Pages", required=False),
        ],
    },
}

SUMMARY_FIELDS = {"citekey", "author", "title", "year"}


def fields_for(entry_type):
    return ENTRY_TYPES[entry_type]["fields"]


def detail_fields(reference):
    """(label, value) pairs of the type-specific fields to show in the list."""
    return [
        (f.label, getattr(reference, f.name))
        for f in fields_for(reference.entry_type)
        if f.name not in SUMMARY_FIELDS and getattr(reference, f.name)
    ]