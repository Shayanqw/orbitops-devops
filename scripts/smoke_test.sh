#!/usr/bin/env bash
set -euo pipefail

NS="orbitops"
SVC="orbitops-api"

echo "Waiting for deployment rollout..."
kubectl -n "${NS}" rollout status deploy/orbitops-api --timeout=120s

echo "Port-forwarding service..."
kubectl -n "${NS}" port-forward "svc/${SVC}" 8000:8000 >/tmp/orbitops_pf.log 2>&1 &
PF_PID=$!

cleanup() {
  kill "${PF_PID}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

sleep 2

echo "Smoke: /healthz"
curl -fsS http://127.0.0.1:8000/healthz | grep -q '"status":"ok"'

echo "Smoke: /api/v1/echo"
curl -fsS "http://127.0.0.1:8000/api/v1/echo?msg=hi" | grep -q '"msg":"hi"'

echo "✅ Smoke tests passed"
