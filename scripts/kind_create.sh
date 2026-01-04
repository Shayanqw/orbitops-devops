#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-orbitops}"
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "kind cluster '${CLUSTER_NAME}' already exists"
  exit 0
fi

cat <<'EOF' > /tmp/orbitops-kind.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
EOF

kind create cluster --name "${CLUSTER_NAME}" --config /tmp/orbitops-kind.yaml
echo "Cluster ready: ${CLUSTER_NAME}"
