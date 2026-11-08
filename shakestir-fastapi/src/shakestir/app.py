from fastapi import FastAPI

from shakestir.routers.api.ingredients import router

app = FastAPI(title="ShakeStir API", version="0.1.0")
app.include_router(router)
