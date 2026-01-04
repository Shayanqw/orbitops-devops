from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_healthz():
    r = client.get("/healthz")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"

def test_readyz():
    r = client.get("/readyz")
    assert r.status_code == 200
    assert r.json()["ready"] is True

def test_echo():
    r = client.get("/api/v1/echo", params={"msg": "hi"})
    assert r.status_code == 200
    body = r.json()
    assert body["msg"] == "hi"
    assert "env" in body
