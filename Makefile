.PHONY: lint test docker-build k8s-up k8s-deploy k8s-smoke k8s-down

lint:
	ruff check .

test:
	pytest -q

docker-build:
	docker build -t orbitops-api:local .

k8s-up:
	./scripts/kind_create.sh

k8s-deploy:
	kubectl apply -f k8s/base/namespace.yaml
	kubectl apply -f k8s/base/

k8s-smoke:
	./scripts/smoke_test.sh

k8s-down:
	./scripts/kind_delete.sh
