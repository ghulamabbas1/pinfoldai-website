#!/usr/bin/env python3
"""Build js/i18n-legal-suite.js from English JSON, locale parts, and hub overlay."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
JS = ROOT / "js"
OUT = JS / "i18n-legal-suite.js"
EN_PATH = JS / "i18n-legal-suite-en.json"
HUB_PATH = JS / "i18n-legal-hub.json"


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def escape_js(s: str) -> str:
    return (
        s.replace("\\", "\\\\")
        .replace("'", "\\'")
        .replace("\r", "")
        .replace("\n", "\\n")
    )


def main() -> None:
    locales: dict[str, dict[str, str]] = {
        "en": dict(load_json(EN_PATH)),
        "ar": {},
        "fr": {},
        "zh": {},
    }

    for lang in ("ar", "fr", "zh"):
        merged: dict[str, str] = {}
        for part in ("part1", "part2", "part3"):
            part_path = JS / f"i18n-legal-suite-{lang}-{part}.json"
            if part_path.exists():
                merged.update(load_json(part_path))
        locales[lang] = merged
        print(f"Merged {lang}: {len(merged)} keys")

    hub = load_json(HUB_PATH)
    for lang in ("en", "ar", "fr", "zh"):
        locales[lang].update(hub.get(lang, {}))

    for lang in ("ar", "fr", "zh"):
        for key, val in locales["en"].items():
            if key not in locales[lang]:
                locales[lang][key] = val

    lines = [
        "(function () {",
        "  if (!window.PINFOLD_I18N) window.PINFOLD_I18N = { en: {}, ar: {}, fr: {}, zh: {} };",
        "  var suite = {",
    ]
    for i, lang in enumerate(("en", "ar", "fr", "zh")):
        lines.append(f"    {lang}: {{")
        for j, key in enumerate(sorted(locales[lang])):
            val = escape_js(locales[lang][key])
            comma = "," if j < len(locales[lang]) - 1 else ""
            lines.append(f"      '{key}': '{val}'{comma}")
        lines.append("    }" + ("," if i < 3 else ""))
    lines.extend(
        [
            "  };",
            "  ['en','ar','fr','zh'].forEach(function (lang) {",
            "    Object.assign(window.PINFOLD_I18N[lang], suite[lang]);",
            "  });",
            "})();",
            "",
        ]
    )
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT}")
    for lang in locales:
        print(f"  {lang}: {len(locales[lang])} keys")


if __name__ == "__main__":
    main()
