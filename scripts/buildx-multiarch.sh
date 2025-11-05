#!/usr/bin/env bash
set -euo pipefail

# Build and push a multi-arch image using buildx
# Usage:
#   ./scripts/buildx-multiarch.sh <repo/image> <tag> [path]
# Example:
#   ./scripts/buildx-multiarch.sh ghcr.io/user/app v1 .

IMAGE=${1:-}
TAG=${2:-latest}
CTX=${3:-.}

if [[ -z "${IMAGE}" ]]; then
  echo "Usage: $0 <repo/image> <tag> [context]" >&2
  exit 1
fi

# Ensure a builder exists
if ! docker buildx inspect mybuilder >/dev/null 2>&1; then
  docker buildx create --name mybuilder --use
else
  docker buildx use mybuilder
fi

# Optional local cache directory
CACHE_DIR=.buildcache
mkdir -p "${CACHE_DIR}"

export DOCKER_BUILDKIT=1

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --cache-to=type=local,dest=${CACHE_DIR},mode=max \
  --cache-from=type=local,src=${CACHE_DIR} \
  -t ${IMAGE}:${TAG} \
  --push \
  ${CTX}

echo "Pushed ${IMAGE}:${TAG} for amd64 and arm64"
