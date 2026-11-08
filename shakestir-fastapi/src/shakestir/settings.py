from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy.engine import make_url

PROJECT_DIR = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=PROJECT_DIR / ".env", extra="ignore")
    database_url: str = "sqlite:///data/shakestir.db"

    storage_path: Path = Path("data/storage")

    def local_storage_path(self) -> Path:
        path = self.storage_path.expanduser()
        return path if path.is_absolute() else PROJECT_DIR / path

    def normalized_database_url(self) -> str:
        url = make_url(self.database_url)
        if url.drivername.startswith("sqlite") and url.database not in (
            None,
            "",
            ":memory:",
        ):
            path = Path(url.database).expanduser()
            if not path.is_absolute():
                path = PROJECT_DIR / path
            url = url.set(database=str(path))
        return url.render_as_string(hide_password=False)


settings = Settings()
