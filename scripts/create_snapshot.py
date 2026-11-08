#!/usr/bin/env python3
"""Create a source-only ZIP from the current Git working tree."""

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path, PurePosixPath
import subprocess
import shutil
import sys
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIRS = {"shakestir-fastapi", "shakestir-react", "db", "scripts"}
ROOT_FILES = {
    "README.md", "PRODUCT.md", "PRODUCT_VISION.md", "GLOSSARY.md",
    "LICENSE", "THIRD_PARTY_LICENSES.md", ".gitignore", "package.json",
}
EXCLUDED_DIRS = {
    ".git", ".agents", ".claude", ".codex", ".impeccable", ".github", ".kamal",
    ".venv", "venv", "node_modules", "dist", "build", "__pycache__",
    ".pytest_cache", ".ruff_cache", ".mypy_cache", ".vite", "coverage",
    "htmlcov", "data", "storage", "log", "logs", "tmp", "artifacts",
    "test-results", "playwright-report", "snapshots",
}
EXCLUDED_FILES = {"AGENTS.md", "CLAUDE.md", "SKILL.md", ".DS_Store", "DESIGN.md"}
EXCLUDED_SUFFIXES = {".pyc", ".pyo", ".log", ".db", ".sqlite", ".sqlite3", ".pem", ".key", ".tsbuildinfo", ".zip"}
MAX_BYTES = 100_000_000


def included(name):
    path = PurePosixPath(name)
    if len(path.parts) == 1:
        return name in ROOT_FILES
    if path.parts[0] not in SOURCE_DIRS:
        return False
    if any(part in EXCLUDED_DIRS or part.endswith(".egg-info") for part in path.parts[:-1]):
        return False
    if path.name in EXCLUDED_FILES or path.suffix in EXCLUDED_SUFFIXES:
        return False
    if path.name.startswith(".env") and path.name != ".env.example":
        return False
    if path.name.endswith(".local") or "credentials" in path.name.lower():
        return False
    return True


def source_files():
    # Includes nonignored new files and reads current disk contents, not HEAD.
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=ROOT, check=True, capture_output=True,
    )
    files = []
    for name in sorted(set(result.stdout.decode().split("\0"))):
        if not name or not included(name):
            continue
        path = ROOT / name
        # Reject linked files/directories rather than following them out of the repo.
        if any(parent.is_symlink() for parent in (path, *path.parents) if parent != ROOT.parent):
            raise ValueError(f"Refusing symlink: {name}")
        if path.is_file():
            files.append(name)
    required = {"LICENSE", "README.md", "shakestir-fastapi/pyproject.toml",
                "shakestir-react/package.json", "db/seeds/demo/ingredients.json"}
    missing = required.difference(files)
    if missing:
        raise ValueError(f"Missing required source files: {', '.join(sorted(missing))}")
    return files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="ZIP destination; defaults to snapshots/shakestir-<UTC timestamp>.zip")
    args = parser.parse_args()
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    output = (args.output or ROOT / "snapshots" / f"shakestir-{stamp}.zip").resolve()
    if output.suffix.lower() != ".zip":
        raise ValueError("Output must have a .zip extension")
    manifest_path = output.with_suffix(".manifest.json")
    if output.exists() or manifest_path.exists():
        raise ValueError(f"Output already exists: {output}")
    files = source_files()
    total = sum((ROOT / name).stat().st_size for name in files)
    if total > MAX_BYTES:
        raise ValueError(f"Source exceeds the 100 MB limit: {total / 1_000_000:.2f} MB")
    output.parent.mkdir(parents=True, exist_ok=True)
    # Build and verify before publishing the archive.
    with tempfile.TemporaryDirectory(prefix="shakestir-snapshot-") as temporary:
        archive = Path(temporary) / "snapshot.zip"
        with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zipped:
            for name in files:
                zipped.write(ROOT / name, name)
        size = archive.stat().st_size
        if size > MAX_BYTES:
            raise ValueError(f"ZIP exceeds the 100 MB limit: {size / 1_000_000:.2f} MB")
        with zipfile.ZipFile(archive) as zipped:
            if zipped.testzip() is not None:
                raise ValueError("ZIP integrity check failed")
        # Exclusive creation prevents overwriting an existing destination.
        with output.open("xb") as destination, archive.open("rb") as source:
            shutil.copyfileobj(source, destination)
    manifest = {"archive": output.name, "files": files, "source_bytes": total, "zip_bytes": size}
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Created {output}")
    print(f"{len(files)} files; source {total / 1_000_000:.2f} MB; ZIP {size / 1_000_000:.2f} MB")
    print(f"Review file list: {manifest_path}")
    print("Includes current working files, including uncommitted changes. No upload was performed.")
    print("Review contents for sensitive data and third-party permissions before uploading.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Snapshot failed: {error}", file=sys.stderr)
        sys.exit(1)
