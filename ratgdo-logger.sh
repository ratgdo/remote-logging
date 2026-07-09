#!/bin/bash

# HOST from argument 1 with environment var fallback
# LOG_FILE from optional argument 2 with environment var fallback
HOST="${1:-${HOST:-}}"
LOG_FILE="${2:-${LOG_FILE:-/dev/null}}"

# Check if a host is provided
if [ -z "$HOST" ]; then
  echo "Usage: $0 <ratgdo_hostname_or_ip> [log_file]"
  echo "Alternatively set HOST and LOG_FILE environment variables."
  exit 1
fi

# Check if the host is reachable
echo "Pinging $HOST..."
ping -c 1 -W 2 "$HOST" > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "❌ Host $HOST is unreachable."
  exit 1
else
  echo "✅ Host $HOST is reachable."
fi

echo "Checking firmware type..."

# ESPHome exposes a fixed /events SSE endpoint - test for that first, using
# GET with a time limit of 2 seconds since HEAD is not implemented.
STATUS_CODE=$(curl -m 2 -s -o /dev/null -w "%{http_code}" "http://$HOST/events")

if [ "$STATUS_CODE" -eq 200 ]; then
  echo "✅ ratgdo-esphome detected"
  URL="http://$HOST/events"
  MATCH_EVENT="event: log"
else
  # The homekit firmware has no fixed /events path - you subscribe first and
  # it hands back a per-connection channel URL to stream from. The ID just
  # needs to be reasonably unique, not a real UUID: the firmware stores and
  # compares it as a plain string.
  ID="$(date +%s)-$RANDOM"
  SUB_PATH=$(curl -m 2 -s "http://$HOST/rest/events/subscribe?id=${ID}&log=1&heartbeat=0")
  case "$SUB_PATH" in
    /*)
      echo "✅ ratgdo-homekit detected"
      URL="http://$HOST${SUB_PATH}?id=${ID}"
      MATCH_EVENT="event: logger"
      ;;
    *)
      echo "❌ unknown firmware type"
      exit 1
      ;;
  esac
fi

# Begin log capture
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") Logging started" >>"$LOG_FILE"
curl -s --no-buffer "$URL" | while IFS= read -r line; do
  clean_line=$(printf "%s" "$line" | tr -d '\r')
  if [[ "$clean_line" == "$MATCH_EVENT" ]]; then
    read -r next_line
    next_line_clean=$(printf "%s" "$next_line" | tr -d '\r')
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$timestamp $next_line_clean"
  fi
done  | tee -a "$LOG_FILE"
