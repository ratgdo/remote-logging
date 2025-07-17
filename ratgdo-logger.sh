#!/bin/bash

HOST="$1"

// check if HOST was provided
if [ -z "$HOST" ]; then
  echo "Usage: $0 <ratgdo IP>"
  exit 1
fi

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$HOST/events")

if [ "$STATUS_CODE" -eq 200 ]; then
  echo "✅ $HOST is reachable (200 OK), esphome detected"
  exit 0
else
  echo "❌ $HOST returned HTTP status code $STATUS_CODE"
  exit 1
fi


curl -s --no-buffer $HOST/events | while IFS= read -r line; do
  clean_line=$(printf "%s" "$line" | tr -d '\r')
  if [[ "$clean_line" == "event: log" ]]; then
    read -r next_line
    next_line_clean=$(printf "%s" "$next_line" | tr -d '\r')
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$timestamp $next_line_clean"
  fi
done