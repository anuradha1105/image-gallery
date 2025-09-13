#!/usr/bin/env bash
set -euo pipefail

# Usage: bash scripts/vm_load_inside.sh [HOST_PORT] [N] [C]
HOST_PORT="${1:-5001}"   # your VM's forwarded port on the host
N="${2:-5000}"           # total requests
C="${3:-50}"             # concurrency

REPORTS_DIR="reports"
mkdir -p "$REPORTS_DIR"
OUTFILE="$REPORTS_DIR/vm_ab_inside_$(date +%Y%m%d_%H%M%S).txt"

echo "=== VM load test (ab inside VM) N=$N C=$C ===" | tee "$OUTFILE"

# ensure ab is installed in the VM, then run it against 127.0.0.1:5000 (inside guest)
(
  cd vagrant
  vagrant ssh -c "which ab >/dev/null || (sudo apt-get update -y && sudo apt-get install -y apache2-utils)"
  vagrant ssh -c "ab -n $N -c $C http://127.0.0.1:5000/"
) | tee -a "$OUTFILE"

echo -e "\n=== Saved to $OUTFILE ==="
