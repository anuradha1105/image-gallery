#!/usr/bin/env bash
set -euo pipefail
# Run ab inside a container to avoid local installs
docker run --rm jordi/ab -n "${1:-5000}" -c "${2:-50}" http://host.docker.internal:5000/
