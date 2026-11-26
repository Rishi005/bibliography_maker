from entry_types import fields_for


def to_bibtex(reference):
    lines = ["@"+reference.entry_type + "{" + reference.citekey+","]
    for field in fields_for(reference.entry_type):
        value = getattr(reference, field.name)
        if field.name != "citekey" and value:
            lines.append(f"  {field.name} = {{{value}}},")
    lines.append("}")
    return "\n".join(lines)
