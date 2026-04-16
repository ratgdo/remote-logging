FROM debian:testing

LABEL org.opencontainers.image.title="ratgdo-remote-logging"
LABEL org.opencontainers.image.source="https://github.com/ratgdo/remote-logging"
LABEL org.opencontainers.image.description="Stream RATGDO ESPHome events to a log file"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"

ENV HOST=""
ENV LOG_FILE="/log/ratgdo.log"

RUN mkdir -p /log

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      iputils-ping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --chmod=755 ratgdo-logger.sh .
ENTRYPOINT ["./ratgdo-logger.sh"]
