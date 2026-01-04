# syntax=docker/dockerfile:1.7
FROM python:3.11-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.11-slim AS runtime

# Security: run as non-root
RUN useradd -m -u 10001 appuser
WORKDIR /app

COPY --from=builder /wheels /wheels
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r /tmp/requirements.txt \
 && rm -rf /wheels /tmp/requirements.txt

COPY app ./app
ENV PYTHONUNBUFFERED=1
ENV APP_ENV=container

USER 10001
EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
