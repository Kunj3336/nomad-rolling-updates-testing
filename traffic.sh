#!/bin/bash
echo "Starting continuous traffic test to acumen-web..."
while true; do
  PORTS=$(curl -s http://127.0.0.1:8500/v1/health/service/acumen-web?passing=true | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
    ports = [str(item["Service"]["Port"]) for item in data if "Service" in item and "Port" in item["Service"]]
    print(" ".join(ports))
except Exception:
    pass
')

  if [ -n "$PORTS" ]; then
    PORT_ARRAY=($PORTS)
    RANDOM_PORT=${PORT_ARRAY[$RANDOM % ${#PORT_ARRAY[@]}]}
    RESPONSE=$(curl -s --connect-timeout 1 "http://127.0.0.1:${RANDOM_PORT}/")
    TIME=$(date +"%H:%M:%S")
    echo "[$TIME] [Port: $RANDOM_PORT] -> $RESPONSE"
  else
    TIME=$(date +"%H:%M:%S")
    echo "[$TIME] -> Waiting for healthy instance in Consul..."
  fi
  sleep 0.5
done