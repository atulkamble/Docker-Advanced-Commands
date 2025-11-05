#!/usr/bin/env bash
set -euo pipefail

# Tail logs for containers
# Usage: ./scripts/tail-logs.sh <container> [--since 10m]

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <container> [--since 10m]" >&2
  exit 1
fi

CTR=$1
shift || true

docker logs -f "$CTR" "$@"
