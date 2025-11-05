#!/usr/bin/env bash
set -euo pipefail

# Exec into a container with sh (or bash if present)
# Usage: ./scripts/exec-into.sh <container>

CTR=${1:-}
if [[ -z "${CTR}" ]]; then
  echo "Usage: $0 <container-name-or-id>" >&2
  exit 1
fi

if docker exec ${CTR} bash -lc 'exit' >/dev/null 2>&1; then
  docker exec -it ${CTR} bash
else
  docker exec -it ${CTR} sh
fi
