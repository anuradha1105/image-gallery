#!/usr/bin/env bash
set -euo pipefail

# Usage: bash scripts/vm_run.sh [HOST_PORT]
# HOST_PORT = forwarded port on your host (from `vagrant port`). Default 5001.
HOST_PORT="${1:-5001}"

REPORTS_DIR="reports"
mkdir -p "$REPORTS_DIR"
OUTFILE="$REPORTS_DIR/vm_run_$(date +%Y%m%d_%H%M%S).txt"

echo "=== VM measurement (host port $HOST_PORT) ===" | tee "$OUTFILE"

# Make sure VM is up; do NOT reprovision here
(
  cd vagrant
  vagrant up
) | tee -a "$OUTFILE"

# Restart the service and measure time until HTTP OK
if date +%s%3N >/dev/null 2>&1; then
  START_MS=$(date +%s%3N)
else
  START_MS=$(python - <<'PY'
import time; print(int(time.time()*1000))
PY
)
fi

(
  cd vagrant
  vagrant ssh -c "sudo systemctl restart flaskapp" >/dev/null
)

# Wait for app to respond on the forwarded host port
until curl -sf "http://127.0.0.1:${HOST_PORT}/" >/dev/null; do
  sleep 0.1
done

if date +%s%3N >/dev/null 2>&1; then
  END_MS=$(date +%s%3N)
else
  END_MS=$(python - <<'PY'
import time; print(int(time.time()*1000))
PY
)
fi

STARTUP_MS=$((END_MS - START_MS))
echo "Startup time: ${STARTUP_MS} ms" | tee -a "$OUTFILE"

echo -e "\n=== VM resource snapshot (inside guest) ===" | tee -a "$OUTFILE"
(
  cd vagrant
  vagrant ssh -c "echo '--- ps gunicorn ---'; ps -C gunicorn -o pid,pcpu,pmem,rss,comm --no-headers || true"
  vagrant ssh -c "echo '--- top (one-shot) ---'; top -b -n1 | head -n 15"
  vagrant ssh -c "echo '--- free -m ---'; free -m"
) | tee -a "$OUTFILE"

echo -e "\n=== HTTP check ===" | tee -a "$OUTFILE"
curl -s -o /dev/null -w "HTTP %{http_code}\n" "http://127.0.0.1:${HOST_PORT}/" | tee -a "$OUTFILE"

echo -e "\n=== Done. Results saved to $OUTFILE ==="
