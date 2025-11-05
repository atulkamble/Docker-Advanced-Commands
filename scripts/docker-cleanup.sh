#!/usr/bin/env bash
set -euo pipefail

# Safe Docker cleanup script
# Usage: ./scripts/docker-cleanup.sh [--with-volumes]

WITH_VOLS=${1:-}

echo "Pruning stopped containers, dangling images, and unused networks..."
docker container prune -f || true
docker image prune -f || true
docker network prune -f || true

if [[ "${WITH_VOLS}" == "--with-volumes" ]]; then
  echo "Pruning unused volumes (CAUTION) ..."
  docker volume prune -f || true
fi

echo "Done. For full cleanup including all images and volumes, consider:"
echo "  docker system prune -a --volumes"
