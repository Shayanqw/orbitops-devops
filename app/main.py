from fastapi import FastAPI
from pydantic import BaseModel
import os

app = FastAPI(title="OrbitOps API", version="1.0.0")

class EchoResponse(BaseModel):
    msg: str
    env: str

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.get("/readyz")
def readyz():
    # Example: check DB/redis connectivity here in a real service
    return {"ready": True}

@app.get("/api/v1/echo", response_model=EchoResponse)
def echo(msg: str = "hello"):
    env = os.getenv("APP_ENV", "dev")
    return EchoResponse(msg=msg, env=env)
