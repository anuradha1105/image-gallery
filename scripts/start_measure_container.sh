#!/bin/bash
set -e

# pick host port dynamically (default 5001)
HOST_PORT=${1:-5001}

REPORTS_DIR="reports"
mkdir -p $REPORTS_DIR

OUTFILE="$REPORTS_DIR/container_run_$(date +%Y%m%d_%H%M%S).txt"

echo "=== Measuring Docker startup time ===" | tee $OUTFILE

# stop old container if exists
docker rm -f flask-app-measure >/dev/null 2>&1 || true

# run new container
START_TIME=$(date +%s%3N)
docker run -d -p $HOST_PORT:5000 --name flask-app-measure upload-app >/dev/null
END_TIME=$(date +%s%3N)

STARTUP_MS=$((END_TIME - START_TIME))
echo "Startup time: ${STARTUP_MS} ms" | tee -a $OUTFILE

echo "=== Container Resource Usage ===" | tee -a $OUTFILE
docker stats --no-stream flask-app-measure | tee -a $OUTFILE

echo "=== Test HTTP Response ===" | tee -a $OUTFILE
curl -s -o /dev/null -w "HTTP %{http_code}\n" http://127.0.0.1:$HOST_PORT/ | tee -a $OUTFILE

echo "=== Done. Results saved to $OUTFILE ==="
