# syntax=docker/dockerfile:1
FROM python:3.11-slim-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install hermes-agent from GitHub directly
RUN pip install --no-cache-dir "hermes-agent[gateway] @ git+https://github.com/NousResearch/hermes-agent.git"

# Runtime stage
FROM python:3.11-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git tini && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

ENV HERMES_HOME=/data
ENV TELEGRAM_WEBHOOK_URL=https://baa.zeabur.app/telegram
ENV TELEGRAM_WEBHOOK_PORT=8080
ENV API_SERVER_PORT=8080
VOLUME [ "/data" ]
EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["hermes", "gateway", "run"]
