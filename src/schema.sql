CREATE TABLE refs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  citekey TEXT NOT NULL UNIQUE,
  entry_type TEXT NOT NULL,
  author TEXT NOT NULL,
  title TEXT NOT NULL,
  year INTEGER NOT NULL,
  publisher TEXT,
  journal TEXT,
  volume TEXT,
  pages TEXT,
  booktitle TEXT,
  editor TEXT
);