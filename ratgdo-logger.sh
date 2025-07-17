#!/bin/bash

# HOST from argument 1
HOST="$1"

# Check if a host is provided
if [ -z "$HOST" ]; then
  echo "Usage: $0 <ratgdo_hostname_or_ip>"
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

# Check if http://HOST/events returns HTTP 200 (ESPHome detected)
URL="http://$HOST/events"
echo "Checking firmware type..."

STATUS_CODE=$(curl --head -s -o /dev/null -w "%{http_code}" "$URL")

# TO DO: add case for homekit firmware
if [ "$STATUS_CODE" -eq 200 ]; then
  echo "✅ ratgdo-esphome detected"
else
  echo "❌ unknown firmware type"
  exit 1
fi

# Begin log capture
curl -s --no-buffer $URL | while IFS= read -r line; do
  clean_line=$(printf "%s" "$line" | tr -d '\r')
  if [[ "$clean_line" == "event: log" ]]; then
    read -r next_line
    next_line_clean=$(printf "%s" "$next_line" | tr -d '\r')
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$timestamp $next_line_clean"
  fi
done