"""Local, content-addressed storage for public catalog images."""

import hashlib
import os
import re
import tempfile
from pathlib import Path

from shakestir.settings import settings

IMAGE_KEY = re.compile(r"ingredients/[a-f0-9]{64}\.(png|jpg|jpeg|webp)\Z")


def image_path(key: str) -> Path:
    if not IMAGE_KEY.fullmatch(key):
        raise ValueError("Invalid ingredient image key")
    return settings.local_storage_path() / key


def store_image(source: Path) -> str:
    extension = source.suffix.lower()
    if extension not in {".png", ".jpg", ".jpeg", ".webp"}:
        raise ValueError("Unsupported ingredient image format")
    content = source.read_bytes()
    key = f"ingredients/{hashlib.sha256(content).hexdigest()}{extension}"
    destination = image_path(key)
    if destination.is_file():
        return key
    destination.parent.mkdir(parents=True, exist_ok=True)
    # Publish complete files only, including when seed processes run concurrently.
    with tempfile.NamedTemporaryFile(dir=destination.parent, delete=False) as temporary:
        temporary_path = Path(temporary.name)
        try:
            temporary.write(content)
            temporary.close()
            os.replace(temporary_path, destination)
        finally:
            temporary_path.unlink(missing_ok=True)
    return key
