FROM alpine:latest

LABEL org.opencontainers.image.title="ratgdo-remote-logging"
LABEL org.opencontainers.image.source="https://github.com/ratgdo/remote-logging"
LABEL org.opencontainers.image.description="Stream RATGDO ESPHome events to a log file"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"

ENV HOST=""
ENV LOG_FILE="/log/ratgdo.log"

RUN mkdir -p /log && \
    apk add --no-cache bash curl ca-certificates

WORKDIR /app
COPY --chmod=755 ratgdo-logger.sh .
ENTRYPOINT ["./ratgdo-logger.sh"]
