#!/usr/bin/env python3
"""Trim catalog PNG padding without resampling the artwork.

Ignore alpha below 1% when finding bounds, then retain a 2% safety margin
for soft edges and shadows. Save a checksum manifest for refreshing existing
local Rails attachments with the matching, normalized seed image.
"""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
DIRECTORIES = ("db/seeds/demo/images/cocktails", "db/seeds/demo/images/ingredients", "db/seeds/utensils/images")


def run(*args):
    return subprocess.check_output(["magick", *map(str, args)], text=True).strip()


def normalize(path):
    width, height = map(int, run(path, "-format", "%w %h", "info:").split())
    bounds = run(path, "-alpha", "extract", "-threshold", "1%", "-format", "%@", "info:")
    match = re.fullmatch(r"(\d+)x(\d+)\+(\d+)\+(\d+)", bounds)
    if not match:
        raise ValueError(f"Cannot determine artwork bounds: {path}: {bounds}")
    w, h, x, y = map(int, match.groups())
    if not w or not h:
        raise ValueError(f"Empty artwork: {path}")
    margin = max(2, round(max(w, h) * .02))
    left, top = max(0, x - margin), max(0, y - margin)
    right, bottom = min(width, x + w + margin), min(height, y + h + margin)
    if (left, top, right, bottom) == (0, 0, width, height):
        return None
    checksum = base64.b64encode(hashlib.md5(path.read_bytes()).digest()).decode()
    with tempfile.TemporaryDirectory() as directory:
        output = Path(directory) / path.name
        run(path, "-crop", f"{right-left}x{bottom-top}+{left}+{top}", "+repage", output)
        path.write_bytes(output.read_bytes())
    return {"path": str(path.relative_to(ROOT)), "old_checksum": checksum}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    args = parser.parse_args()
    entries = []
    for directory in DIRECTORIES:
        for path in sorted((ROOT / directory).glob("*.png")):
            entry = normalize(path)
            if entry:
                entries.append(entry)
    args.manifest.write_text(json.dumps(entries, indent=2) + "\n")
    print(f"Normalized {len(entries)} images; manifest: {args.manifest}")


if __name__ == "__main__":
    main()
