"""Start the local API with automatic reload."""

import uvicorn


def main() -> None:
    uvicorn.run("shakestir.app:app", reload=True)


if __name__ == "__main__":
    main()
