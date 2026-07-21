import sys
from pathlib import Path

APPLICATION_PATH = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(APPLICATION_PATH))

from app import app


def test_home_endpoint():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.json["status"] == "running"


def test_health_endpoint():
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "healthy"


def test_metrics_endpoint():
    client = app.test_client()

    response = client.get("/metrics")

    assert response.status_code == 200
    assert b"http_requests_total" in response.data


def test_simulated_error_endpoint():
    client = app.test_client()

    response = client.get("/simulate-error")

    assert response.status_code == 500
    assert response.json["status"] == "error"