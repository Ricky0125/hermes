# syntax=docker/dockerfile:1
FROM python:3.11-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git ffmpeg gcc python3-dev tini && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip install --no-cache-dir --timeout 120 hermes-agent && \
    pip install --no-cache-dir --timeout 120 "hermes-agent[gateway]"

ENV HERMES_HOME=/data
VOLUME [ "/data" ]
EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["hermes", "gateway", "run"]
