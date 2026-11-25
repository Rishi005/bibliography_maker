class Reference:
    def __init__(self, id, citekey, entry_type, author, title, year,
                 publisher=None, journal=None, volume=None, pages=None,
                 booktitle=None, editor=None,
                ):
        self.id = id
        self.citekey = citekey
        self.entry_type = entry_type
        self.author = author
        self.title = title
        self.year = year
        self.publisher = publisher
        self.journal = journal
        self.volume = volume
        self.pages = pages
        self.booktitle = booktitle
        self.editor = editor

    def __str__(self):
        return f"{self.author}: {self.title} ({self.year})"