import unittest

from bibtex import to_bibtex
from entities.reference import Reference


class TestToBibtex(unittest.TestCase):
    def test_book_is_formatted_and_empty_fields_are_skipped(self):
        reference = Reference(1, "Martin2008", "book", "Robert Martin",
                              "Clean Code", 2008)

        self.assertEqual(
            to_bibtex(reference),
            "@book{Martin2008,\n"
            "  author = {Robert Martin},\n"
            "  title = {Clean Code},\n"
            "  year = {2008},\n"
            "}",
        )
