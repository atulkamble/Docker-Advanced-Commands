## 🐳 Docker Advanced Commands, Theory, Scripts, and Examples

Level up your Docker skills with concise theory, battle-tested commands, interview notes, and runnable examples. This repo now includes scripts and multiple Dockerfile patterns you can try locally.

— Updated: 5 Nov 2025

---

## 🧠 Theory in Short (What to remember)

- Images are layered, immutable filesystems; containers add a thin writable layer (copy-on-write).
- BuildKit is the modern builder: parallel builds, cache export/import, secrets/SSH mounts, frontends (e.g., Dockerfile v1.5+ features).
- Networking: bridge (default), host, none, overlay (Swarm/K8s), MACVLAN; attach containers to multiple networks.
- Storage: bind mounts (host path) vs named volumes (managed by Docker); tmpfs for in-memory data.
- Isolation: Linux namespaces + cgroups enforce process, network, mount, UTS, IPC, PID isolation and resource quotas.
- Security: run as non-root, drop capabilities, read-only FS, seccomp/apparmor, scan images (Docker Scout), sign with Notary/GitHub OIDC.
- Multi-arch: buildx builds images for linux/amd64, linux/arm64, etc.; QEMU emulation when building on a single host.

---

## 🧩 Interview Pointers (Quick bullets)

- Difference: docker export/import (container FS only) vs docker save/load (image with history and tags).
- Image size reduction: multi-stage builds, .dockerignore, minimal base (alpine/distroless), cache busting control, avoid package managers in final stage.
- Caching: order COPY/RUN, use build args, mount=type=cache for package caches, cache-from/to for CI.
- Entrypoint vs Cmd: ENTRYPOINT defines executable; CMD provides default args. Prefer exec form; handle signals; use tini.
- Healthchecks: periodic exit code; unhealthy containers can be restarted by orchestrators.
- Debugging: docker logs, exec, cp, diff, events, inspect with --format; enable shell only in debug stages.
- Security best practices: non-root USER, least privileges (--cap-drop all, --cap-add as needed), read-only root filesystem, secrets via mounts not ENV.
- Networking: user-defined bridge gives embedded DNS; service discovery by container name; publish vs expose.
- Compose vs Swarm vs K8s: local dev/multi-container (Compose), orchestrators for prod (K8s widespread; Swarm legacy).

---

## 🛠️ Advanced Commands Cheat Sheet

Images & Build

- BuildKit on: export DOCKER_BUILDKIT=1; docker buildx create/use for builders
- docker buildx build -t repo/app:prod --platform linux/amd64,linux/arm64 --push .
- Cache: docker buildx build --cache-to=type=local,dest=.buildcache --cache-from=type=local,src=.buildcache .
- Secrets: docker buildx build --secret id=gh_token,src=token.txt . and in Dockerfile: RUN --mount=type=secret,id=gh_token cat /run/secrets/gh_token
- SSH: docker buildx build --ssh default . and in Dockerfile: RUN --mount=type=ssh git clone git@github.com:org/private.git

Inspect & Filter

- docker image history --no-trunc <img>
- docker inspect <obj> --format '{{json .Config.Env}}' | jq
- docker ps --filter 'status=running' --format '{{.ID}} {{.Names}} {{.Ports}}'
- docker events --since 1h --filter type=container

Runtime & Debug

- Exec TTY: docker exec -it <ctr> sh (or bash)
- Copy FS: docker cp <ctr>:/path ./local_path; docker diff <ctr>
- Logs: docker logs -f --since=10m <ctr>
- Resource limits: docker run -m 512m --cpus=1.0 --pids-limit 200 ...

Distribution & Backup

- Save/load image: docker save repo/app:tag | gzip > image.tgz; docker load -i image.tgz
- Export/import container: docker export <ctr> > fs.tar; cat fs.tar | docker import - repo/app:flat
- Volumes backup: docker run --rm -v vol:/v -v "$PWD":/b alpine tar czf /b/backup.tgz -C /v .

Cleanup (safe-ish)

- Remove stopped stuff: docker container prune; docker image prune; docker volume prune; docker network prune
- All-in: docker system prune -a --volumes (CAUTION)

Security & SBOM

- Scan: docker scout cves repo/app:tag
- SBOM: docker sbom repo/app:tag

---

## 📦 Steps: Common Tasks

Build and run locally

1) docker build -t demo:dev .
2) docker run --rm -p 8080:8080 demo:dev

Debug a failing container

1) docker logs <ctr>
2) docker inspect <ctr> --format '{{.State.Status}}'
3) docker exec -it <ctr> sh
4) docker cp <ctr>:/var/log/app ./logs

Transfer image between hosts

1) docker save repo/app:tag | gzip > image.tgz
2) scp image.tgz host:~/
3) ssh host 'docker load -i image.tgz'

---

## 🧾 Dockerfile Patterns (with runnable examples)

This repo includes multiple examples under `examples/`. Highlights below:

1) Node.js multi-stage, non-root, minimal runtime: `examples/node-multistage/`
2) Python app with HEALTHCHECK and slim base: `examples/python-healthcheck/`
3) Minimal non-root image pattern: `examples/nonroot-minimal/`
4) A handy `.dockerignore` example: `examples/.dockerignore`

See "How to run" in each folder or follow the quickstart below.

---

## 🔧 Scripts (helpers in `scripts/`)

- docker-cleanup.sh: prune stopped containers, dangling images, networks, and optional volumes.
- buildx-multiarch.sh: template to build and push multi-arch images with cache.
- exec-into.sh: quick exec into a container by name/id (defaults to sh).
- tail-logs.sh: tail logs for one or more containers (with since filter).

Mark scripts executable once:

```bash
chmod +x scripts/*.sh
```

---

## ▶️ Try the Examples

Node multi-stage

```bash
cd examples/node-multistage
docker build -t node-multi:dev .
docker run --rm -p 3000:3000 node-multi:dev
```

Python with HEALTHCHECK

```bash
cd examples/python-healthcheck
docker build -t py-health:dev .
docker run --rm -p 5000:5000 py-health:dev
```

Non-root minimal

```bash
cd examples/nonroot-minimal
docker build -t nonroot:dev .
docker run --rm nonroot:dev
```

---

## 📋 `.dockerignore` Template

See `examples/.dockerignore` for a practical template to keep images small and builds fast.

---

## � Extra: Compose override (dev vs prod)

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml up
```

---

## Appendix: Original Cheatsheet (kept for reference)

### 🧱 Multi-Stage Build (Optimize Image Size)

```Dockerfile
# Stage 1: Build (Go example)
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o app

# Stage 2: Run
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .
CMD ["./app"]
```

```bash
docker build -t go-multi-stage-app .
```

### 📜 View Image History

```bash
docker history --no-trunc <image-name>
```

### 📦 Export & Import Containers

```bash
docker export <container_id> > container.tar
docker import container.tar
```

### 💾 Backup & Restore Volumes

```bash
docker run --rm -v volume_name:/volume -v $(pwd):/backup alpine \
  tar czf /backup/backup.tar.gz -C /volume .

docker run --rm -v volume_name:/volume -v $(pwd):/backup alpine \
  tar xzf /backup/backup.tar.gz -C /volume
```

### 🧪 Execute Commands in Containers

```bash
docker exec -it <container_name> bash
docker exec <container_name> ls /app
```

### 🌐 Custom Networks

```bash
docker network create my-bridge-network
docker run -d --name db --network my-bridge-network postgres
docker run -d --name app --network my-bridge-network myapp
```

### ❤️‍🩹 Health Check

```Dockerfile
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
```

### ⚙️ Limit Resources

```bash
docker run -m 512m --cpus="1.0" mycontainer
```

### 📊 Live Metrics

```bash
docker stats
```

### 🔐 Secrets & Envs with Compose

```yaml
environment:
  - DB_PASSWORD=${DB_PASSWORD}
```

### 🧹 System Cleanup

```bash
docker system prune -a --volumes
```

### 🚀 BuildKit Quick Enable

```bash
export DOCKER_BUILDKIT=1
docker build -t mybuildkitapp .
```

### 📁 Sample Project Structure

```bash
project/
├── Dockerfile
├── docker-compose.yml
└── app/
    └── main.py
```

```Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app/main.py"]
```

