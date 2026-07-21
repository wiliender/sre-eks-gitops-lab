import random
import time

from flask import Flask, jsonify, request
from prometheus_client import (
    CONTENT_TYPE_LATEST,
    Counter,
    Histogram,
    generate_latest,
)

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Quantidade total de requisições HTTP",
    ["method", "endpoint", "status"],
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "Tempo de processamento das requisições HTTP",
    ["method", "endpoint"],
)


@app.before_request
def start_request_timer() -> None:
    """Registra o momento em que a requisição começou."""
    request.start_time = time.time()


@app.after_request
def record_request_metrics(response):
    """Registra quantidade e duração das requisições."""
    endpoint = request.path
    duration = time.time() - request.start_time

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=endpoint,
        status=response.status_code,
    ).inc()

    REQUEST_LATENCY.labels(
        method=request.method,
        endpoint=endpoint,
    ).observe(duration)

    return response


@app.route("/", methods=["GET"])
def home():
    return jsonify(
        {
            "message": "SRE EKS GitOps Lab",
            "status": "running",
            "version": "1.0.0",
        }
    )


@app.route("/health", methods=["GET"])
def health():
    return jsonify(
        {
            "status": "healthy",
            "service": "sre-eks-gitops-lab",
        }
    )


@app.route("/metrics", methods=["GET"])
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


@app.route("/simulate-latency", methods=["GET"])
def simulate_latency():
    delay = random.uniform(0.5, 2.0)
    time.sleep(delay)

    return jsonify(
        {
            "message": "Latência simulada",
            "delay_seconds": round(delay, 2),
        }
    )


@app.route("/simulate-error", methods=["GET"])
def simulate_error():
    return (
        jsonify(
            {
                "status": "error",
                "message": "Erro simulado para observabilidade",
            }
        ),
        500,
    )


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=8080,
        debug=False,
    )