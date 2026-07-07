#!/usr/bin/env python3
"""Repair mojibake and normalize marketing page icons to HTML entities."""
from __future__ import annotations

import re
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent

ICON_REPLACEMENTS = {
    "📁": "&#128193;",
    "🔒": "&#128274;",
    "📊": "&#128202;",
    "⚡": "&#9889;",
    "☁️": "&#9729;",
    "📣": "&#128227;",
}

# Common double-encoded UTF-8 sequences seen after Windows tooling rewrote files.
MOJIBAKE_REPLACEMENTS = [
    ("Ã¢â‚¬â€", "—"),
    ("Ã¢â‚¬â€œ", "–"),
    ("Ã¢â‚¬Â¦", "…"),
    ("Ã¢â€ â€™", "→"),
    ("Ã‚Â·", "·"),
    ("Ã¢â‚¬Ëœ", "'"),
    ("Ã¢â‚¬Ëœ", "'"),
    ("Ã¢â‚¬Å“", '"'),
    ("Ã¢â‚¬\u009d", '"'),
    ("Ã¢â‚¬\u009c", '"'),
    ("Ã¢â‚¬Â", '"'),
    ("â€”", "—"),
    ("â€“", "–"),
    ("â€¦", "…"),
    ("â€˜", "'"),
    ("â€™", "'"),
    ("â€œ", '"'),
    ("â€\u009d", '"'),
    ("Â·", "·"),
]

# Corrupted emoji literals currently in HTML.
CORRUPTED_ICON_REPLACEMENTS = [
    ("Ã°Å¸â€œÂ\x81", "&#128193;"),
    ("Ã°Å¸â€â€™", "&#128274;"),
    ("Ã°Å¸â€œÅ\xa0", "&#128202;"),
    ("Ã¢Å¡Â¡", "&#9889;"),
    ("Ã¢ËœÂ\x81Ã¯Â¸Â\x8f", "&#9729;"),
    ("Ã°Å¸â€œÂ£", "&#128227;"),
]


def fix_text(text: str) -> str:
    for old, new in MOJIBAKE_REPLACEMENTS + CORRUPTED_ICON_REPLACEMENTS:
        text = text.replace(old, new)

    for emoji, entity in ICON_REPLACEMENTS.items():
        text = text.replace(f'<div class="icon">{emoji}</div>', f'<div class="icon" aria-hidden="true">{entity}</div>')

    return text


def iter_target_files() -> list[Path]:
    files = [
        REPO / "index.html",
        REPO / "features.html",
        REPO / "contact.html",
        REPO / "js" / "i18n-legal.js",
        REPO / "js" / "i18n-legal-suite.js",
    ]
    files.extend(sorted((REPO / "legal").glob("*.html")))
    return [p for p in files if p.is_file()]


def main() -> None:
    changed = 0
    for path in iter_target_files():
        original = path.read_text(encoding="utf-8")
        updated = fix_text(original)
        if updated != original:
            path.write_text(updated, encoding="utf-8", newline="\n")
            print(f"fixed {path.relative_to(REPO)}")
            changed += 1
    print(f"Done. {changed} file(s) updated.")


if __name__ == "__main__":
    main()
