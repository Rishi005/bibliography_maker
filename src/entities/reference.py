class Reference:
    def __init__(self, id, citekey, entry_type, author, title, year, publisher):
        self.id = id
        self.citekey = citekey
        self.entry_type = entry_type
        self.author = author
        self.title = title
        self.year = year
        self.publisher = publisher

    def __str__(self):
        return f"{self.author}: {self.title} ({self.year})"
