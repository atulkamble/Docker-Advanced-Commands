# 🐳 Advanced Docker Commands, Concepts, Scripts, and Examples

A practical Docker study repository containing advanced concepts, production-focused commands, Dockerfile patterns, troubleshooting techniques, security practices, helper scripts, and runnable examples.

This repository is useful for:

* Docker and DevOps interview preparation
* Cloud and DevOps engineers
* Docker certification preparation
* CI/CD pipeline implementation
* Container troubleshooting practice
* Production Docker best practices
* Hands-on classroom and self-study labs

> **Last updated:** 22 July 2026

---

## 📑 Table of Contents

1. [Core Docker Concepts](#-core-docker-concepts)
2. [Docker Architecture](#-docker-architecture)
3. [Interview Points](#-important-interview-points)
4. [Advanced Command Cheat Sheet](#️-advanced-command-cheat-sheet)
5. [Docker Image Management](#-docker-image-management)
6. [Container Management](#-docker-container-management)
7. [Docker Networking](#-docker-networking)
8. [Docker Storage](#-docker-storage)
9. [Dockerfile Best Practices](#-dockerfile-best-practices)
10. [Multi-Stage Builds](#-multi-stage-builds)
11. [BuildKit and Buildx](#️-buildkit-and-buildx)
12. [Security Best Practices](#-docker-security-best-practices)
13. [Monitoring and Troubleshooting](#-monitoring-and-troubleshooting)
14. [Common Practical Tasks](#-common-practical-tasks)
15. [Project Examples](#-dockerfile-patterns-and-examples)
16. [Helper Scripts](#-helper-scripts)
17. [Docker Compose](#-docker-compose)
18. [Quick Revision](#-quick-revision-notes)
19. [Interview Questions](#-docker-interview-questions)

---

# 🧠 Core Docker Concepts

## Docker Image

A Docker image is a read-only template used to create containers.

An image contains:

* Application source code
* Runtime
* Libraries
* Dependencies
* Environment configuration
* Startup instructions

Example:

```bash
docker pull nginx:latest
```

---

## Docker Container

A container is a running instance of a Docker image.

```text
Docker Image
     │
     ▼
Docker Container
```

A container adds a thin writable layer on top of immutable image layers.

Example:

```bash
docker run -d --name web-server nginx:latest
```

---

## Image Layers

Docker images consist of multiple read-only layers.

```text
Application files
Dependency layer
Runtime layer
Operating-system layer
```

Docker reuses unchanged layers through build caching.

Benefits:

* Faster image builds
* Reduced storage usage
* Efficient image distribution
* Reusable base images

---

## Copy-on-Write

Docker uses a copy-on-write filesystem model.

Containers share the read-only image layers. When a container changes a file, Docker copies that file into the container's writable layer.

```text
Shared image layers
        │
        ├── Container 1 writable layer
        └── Container 2 writable layer
```

Changes made inside a container do not modify the original image.

---

## PID 1 in Containers

Every container has one main process running as PID 1.

Examples:

```text
nginx
python app.py
java -jar app.jar
node server.js
```

When PID 1 exits, the container stops.

Example:

```bash
docker run ubuntu:24.04
```

The container exits immediately because no long-running process was specified.

Run it interactively instead:

```bash
docker run --rm -it ubuntu:24.04 bash
```

---

# 🏗️ Docker Architecture

Docker follows a client-server architecture.

```text
Docker Client
     │
     │ Docker API
     ▼
Docker Daemon
     │
     ├── Images
     ├── Containers
     ├── Networks
     └── Volumes
```

## Main Components

### Docker Client

The Docker CLI sends commands to the Docker daemon.

```bash
docker build
docker pull
docker run
docker ps
```

### Docker Daemon

The Docker daemon manages:

* Containers
* Images
* Networks
* Volumes
* Build operations

### Docker Registry

A registry stores Docker images.

Examples:

* Docker Hub
* Azure Container Registry
* Amazon Elastic Container Registry
* Google Artifact Registry
* GitHub Container Registry

### containerd

`containerd` manages the container lifecycle, including image transfer, storage and runtime execution.

### runc

`runc` is a low-level runtime responsible for creating and running containers according to OCI specifications.

---

# 🎯 Important Interview Points

## Image versus Container

| Docker image                 | Docker container             |
| ---------------------------- | ---------------------------- |
| Read-only template           | Running instance of an image |
| Used to create containers    | Executes an application      |
| Stored in a registry or host | Runs on a Docker host        |
| Immutable layers             | Adds a writable layer        |
| Built using a Dockerfile     | Started using `docker run`   |

---

## `docker save` versus `docker export`

| Command         | Purpose                                             |
| --------------- | --------------------------------------------------- |
| `docker save`   | Exports one or more images with tags and layers     |
| `docker load`   | Restores an image archive                           |
| `docker export` | Exports a container filesystem                      |
| `docker import` | Creates a flattened image from a filesystem archive |

### Save and load an image

```bash
docker save nginx:latest | gzip > nginx-image.tar.gz
docker load -i nginx-image.tar.gz
```

### Export and import a container

```bash
docker export web-server > web-filesystem.tar
docker import web-filesystem.tar custom-nginx:flat
```

`docker export` does not preserve image history, tags, environment configuration, volumes or Dockerfile metadata.

---

## `CMD` versus `ENTRYPOINT`

| `CMD`                                   | `ENTRYPOINT`                            |
| --------------------------------------- | --------------------------------------- |
| Provides a default command or arguments | Defines the main executable             |
| Easily overridden during `docker run`   | Requires `--entrypoint` to replace      |
| Only the last `CMD` is effective        | Only the last `ENTRYPOINT` is effective |

Recommended combination:

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

Default execution:

```text
python app.py
```

Override the argument:

```bash
docker run my-python-image test.py
```

Result:

```text
python test.py
```

---

## Shell Form versus Exec Form

### Shell form

```dockerfile
ENTRYPOINT python app.py
```

This normally executes through a shell:

```text
/bin/sh -c "python app.py"
```

### Exec form

```dockerfile
ENTRYPOINT ["python", "app.py"]
```

The exec form is recommended because:

* The application can become PID 1
* Unix signals are delivered more reliably
* Graceful shutdown works better
* An unnecessary shell process is avoided

---

## `COPY` versus `ADD`

### COPY

Copies local files and directories into the image.

```dockerfile
COPY . /app
```

### ADD

Supports additional behaviours such as automatic extraction of local tar archives.

```dockerfile
ADD application.tar.gz /app
```

Prefer `COPY` unless the extra functionality of `ADD` is specifically required.

---

## `EXPOSE` versus Published Ports

`EXPOSE` documents the port the application listens on.

```dockerfile
EXPOSE 8080
```

It does not make the port publicly accessible.

Publish a port using:

```bash
docker run -p 8080:8080 myapp
```

Syntax:

```text
Host port : Container port
```

---

# 🛠️ Advanced Command Cheat Sheet

## Check Docker Installation

```bash
docker version
docker info
docker system info
```

---

## List Docker Objects

```bash
docker images
docker image ls

docker ps
docker ps -a

docker volume ls
docker network ls
```

---

## Formatted Container Output

```bash
docker ps \
  --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
```

---

## Filter Containers

```bash
docker ps --filter "status=running"
docker ps --filter "name=web"
docker ps --filter "ancestor=nginx"
docker ps --filter "label=environment=production"
```

---

## Docker Events

```bash
docker events
```

Show events from the previous hour:

```bash
docker events --since 1h
```

Filter container events:

```bash
docker events --filter type=container
```

Filter a specific event:

```bash
docker events --filter event=die
```

---

# 🖼️ Docker Image Management

## Pull an Image

```bash
docker pull nginx:latest
```

---

## Build an Image

```bash
docker build -t myapp:1.0 .
```

Build without cache:

```bash
docker build --no-cache -t myapp:1.0 .
```

Build using a specific Dockerfile:

```bash
docker build -f Dockerfile.production -t myapp:production .
```

---

## Tag an Image

```bash
docker tag myapp:1.0 username/myapp:1.0
```

---

## Push an Image

```bash
docker login
docker push username/myapp:1.0
```

---

## View Image History

```bash
docker image history nginx:latest
```

Show complete commands:

```bash
docker image history --no-trunc nginx:latest
```

---

## Inspect Image Configuration

```bash
docker image inspect nginx:latest
```

Display environment variables:

```bash
docker inspect nginx:latest \
  --format '{{json .Config.Env}}'
```

When `jq` is installed:

```bash
docker inspect nginx:latest \
  --format '{{json .Config.Env}}' | jq
```

---

## Remove Images

```bash
docker image rm myapp:1.0
```

Force removal:

```bash
docker image rm -f myapp:1.0
```

Remove dangling images:

```bash
docker image prune
```

Remove all unused images:

```bash
docker image prune -a
```

---

# 📦 Docker Container Management

## Run a Container

```bash
docker run nginx:latest
```

Run in detached mode:

```bash
docker run -d nginx:latest
```

Run with a custom name:

```bash
docker run -d --name web-server nginx:latest
```

Run and publish a port:

```bash
docker run -d \
  --name web-server \
  -p 8080:80 \
  nginx:latest
```

---

## Interactive Container

```bash
docker run --rm -it ubuntu:24.04 bash
```

Options:

| Option | Meaning                          |
| ------ | -------------------------------- |
| `-i`   | Keeps standard input open        |
| `-t`   | Allocates a pseudo-terminal      |
| `--rm` | Removes the container after exit |

---

## Start, Stop and Restart

```bash
docker start web-server
docker stop web-server
docker restart web-server
```

---

## Pause and Unpause

```bash
docker pause web-server
docker unpause web-server
```

---

## Rename a Container

```bash
docker rename old-name new-name
```

---

## Remove Containers

```bash
docker rm web-server
```

Force removal:

```bash
docker rm -f web-server
```

Remove all stopped containers:

```bash
docker container prune
```

---

## Execute Commands Inside a Container

```bash
docker exec web-server ls /usr/share/nginx/html
```

Interactive shell:

```bash
docker exec -it web-server sh
```

When Bash is available:

```bash
docker exec -it web-server bash
```

---

## View Processes Inside a Container

```bash
docker top web-server
```

---

## Copy Files

Copy from a container:

```bash
docker cp web-server:/var/log/nginx ./nginx-logs
```

Copy into a container:

```bash
docker cp index.html web-server:/usr/share/nginx/html/index.html
```

---

## View Filesystem Changes

```bash
docker diff web-server
```

Indicators:

| Symbol | Meaning |
| ------ | ------- |
| `A`    | Added   |
| `C`    | Changed |
| `D`    | Deleted |

---

# 🌐 Docker Networking

## Network Drivers

### Bridge

Default network driver for standalone containers.

```text
Container A ─┐
             ├── Docker bridge ── Host network
Container B ─┘
```

The default bridge network provides basic networking, but user-defined bridge networks provide better DNS-based service discovery.

---

### Host

The container shares the host network stack.

```bash
docker run --network host nginx
```

The container does not receive a separate network namespace in normal host-network operation.

---

### None

Disables external network connectivity.

```bash
docker run --network none alpine
```

---

### Overlay

Creates distributed networks across multiple Docker hosts, commonly with Docker Swarm.

```bash
docker network create \
  --driver overlay \
  application-overlay
```

---

### Macvlan

Assigns a MAC address to a container and makes it appear as a physical device on the external network.

---

## Create a User-Defined Bridge Network

```bash
docker network create application-network
```

Run a database container:

```bash
docker run -d \
  --name database \
  --network application-network \
  -e POSTGRES_PASSWORD=Password123 \
  postgres:latest
```

Run an application container:

```bash
docker run -d \
  --name backend \
  --network application-network \
  myapp:latest
```

The backend can connect to the database using:

```text
database
```

Docker provides embedded DNS for user-defined networks.

---

## Inspect a Network

```bash
docker network inspect application-network
```

---

## Connect a Container to Another Network

```bash
docker network connect second-network backend
```

A container can be attached to multiple networks.

---

## Disconnect a Container

```bash
docker network disconnect second-network backend
```

---

## Remove a Network

```bash
docker network rm application-network
```

Remove unused networks:

```bash
docker network prune
```

---

# 💾 Docker Storage

## Container Writable Layer

Files written inside a container are stored in its writable layer.

This data is normally removed when the container is deleted.

Do not use the writable layer for important persistent application data.

---

## Named Volumes

Docker manages named volumes.

Create a volume:

```bash
docker volume create mysql-data
```

Use it:

```bash
docker run -d \
  --name mysql-database \
  -e MYSQL_ROOT_PASSWORD=Password123 \
  -v mysql-data:/var/lib/mysql \
  mysql:latest
```

Inspect the volume:

```bash
docker volume inspect mysql-data
```

---

## Bind Mounts

Bind mounts map a host path directly into a container.

```bash
docker run --rm \
  -v "$PWD":/app \
  python:3.13-slim
```

Recommended `--mount` syntax:

```bash
docker run --rm \
  --mount type=bind,source="$PWD",target=/app \
  python:3.13-slim
```

Use cases:

* Local development
* Source-code mounting
* Configuration files
* Hot reload
* Sharing host-generated files

---

## Named Volume versus Bind Mount

| Named volume                                | Bind mount                          |
| ------------------------------------------- | ----------------------------------- |
| Managed by Docker                           | Managed through the host filesystem |
| Portable between container configurations   | Depends on a specific host path     |
| Recommended for persistent application data | Commonly used for development       |
| Stored in Docker-managed directories        | Uses any specified host directory   |

---

## tmpfs Mount

A `tmpfs` mount stores data in memory.

```bash
docker run --rm \
  --tmpfs /tmp \
  myapp:latest
```

Data disappears when the container stops.

Use cases:

* Temporary files
* Sensitive runtime files
* High-speed ephemeral storage

---

## Back Up a Volume

```bash
docker run --rm \
  -v mysql-data:/volume \
  -v "$PWD":/backup \
  alpine \
  tar czf /backup/mysql-data-backup.tar.gz -C /volume .
```

---

## Restore a Volume

```bash
docker run --rm \
  -v mysql-data:/volume \
  -v "$PWD":/backup \
  alpine \
  tar xzf /backup/mysql-data-backup.tar.gz -C /volume
```

---

# 🧾 Dockerfile Best Practices

## Basic Dockerfile Structure

```dockerfile
FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

## Use Specific Base Image Versions

Avoid:

```dockerfile
FROM python:latest
```

Prefer:

```dockerfile
FROM python:3.13-slim
```

Version pinning improves:

* Reproducibility
* Stability
* Troubleshooting
* Rollback capability

For highly controlled production builds, consider pinning image digests.

---

## Use `.dockerignore`

Example:

```text
.git
.github
.env
*.log
__pycache__
node_modules
dist
build
coverage
Dockerfile*
docker-compose*.yml
README.md
```

Benefits:

* Smaller build context
* Faster builds
* Fewer cache invalidations
* Lower risk of copying secrets
* Smaller final images

---

## Optimize Build Cache

Poor ordering:

```dockerfile
COPY . .
RUN npm install
```

Better ordering:

```dockerfile
COPY package*.json ./
RUN npm ci
COPY . .
```

Dependencies are reinstalled only when dependency files change.

---

## Combine Related Commands

Instead of:

```dockerfile
RUN apt-get update
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*
```

Use:

```dockerfile
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
```

This prevents package cache data from remaining in a separate layer.

---

## Run as a Non-Root User

```dockerfile
FROM python:3.13-slim

WORKDIR /app

RUN useradd --create-home --uid 10001 appuser

COPY --chown=appuser:appuser . .

USER appuser

CMD ["python", "app.py"]
```

---

## Use Exec Form

Recommended:

```dockerfile
CMD ["python", "app.py"]
```

Avoid when possible:

```dockerfile
CMD python app.py
```

---

## Avoid Secrets in Dockerfiles

Do not use:

```dockerfile
ENV DATABASE_PASSWORD=Password123
```

Do not copy secrets into images:

```dockerfile
COPY .env /app/.env
```

Use instead:

* Runtime secret mounts
* Docker Compose secrets
* CI/CD secret stores
* Azure Key Vault
* AWS Secrets Manager
* HashiCorp Vault
* Kubernetes Secrets with appropriate security controls

---

# 🧱 Multi-Stage Builds

Multi-stage builds use multiple `FROM` instructions in one Dockerfile.

They separate compilation from runtime execution.

Benefits:

* Smaller final image
* Reduced attack surface
* No compilers in production images
* Faster image transfer
* Cleaner runtime environment

---

## Go Multi-Stage Example

```dockerfile
FROM golang:1.24 AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /out/app .

FROM gcr.io/distroless/static-debian12

COPY --from=builder /out/app /app

USER nonroot:nonroot

ENTRYPOINT ["/app"]
```

Build:

```bash
docker build -t go-multistage-app:1.0 .
```

Run:

```bash
docker run --rm go-multistage-app:1.0
```

---

## Node.js Multi-Stage Example

```dockerfile
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:22-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --from=builder /app/dist ./dist

USER node

EXPOSE 3000

CMD ["node", "dist/server.js"]
```

---

# ⚡ BuildKit and Buildx

BuildKit is Docker's modern build engine.

Capabilities include:

* Parallel build execution
* Advanced cache management
* Multi-platform builds
* Secret mounts
* SSH forwarding
* Improved build output
* Remote and registry cache support

Modern Docker installations normally use BuildKit by default.

---

## Check Buildx

```bash
docker buildx version
docker buildx ls
```

---

## Create a Builder

```bash
docker buildx create \
  --name multiarch-builder \
  --driver docker-container \
  --use
```

Initialize it:

```bash
docker buildx inspect --bootstrap
```

---

## Multi-Architecture Build

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t username/myapp:1.0 \
  --push \
  .
```

`--push` is normally required when creating a multi-platform manifest and publishing it to a registry.

For a single local platform:

```bash
docker buildx build \
  --platform linux/amd64 \
  -t myapp:local \
  --load \
  .
```

---

## Build Cache

Local cache example:

```bash
docker buildx build \
  --cache-from type=local,src=.buildcache \
  --cache-to type=local,dest=.buildcache-new,mode=max \
  -t myapp:1.0 \
  .
```

Registry cache example:

```bash
docker buildx build \
  --cache-from type=registry,ref=username/myapp:buildcache \
  --cache-to type=registry,ref=username/myapp:buildcache,mode=max \
  -t username/myapp:1.0 \
  --push \
  .
```

---

## Build Secrets

Build command:

```bash
docker buildx build \
  --secret id=github_token,src=github-token.txt \
  -t private-app:1.0 \
  .
```

Dockerfile:

```dockerfile
# syntax=docker/dockerfile:1

FROM alpine:latest

RUN --mount=type=secret,id=github_token \
    TOKEN="$(cat /run/secrets/github_token)" \
    && echo "Secret available only during this command"
```

The secret is mounted temporarily and is not automatically stored in the final image.

---

## SSH Mount

Build command:

```bash
docker buildx build \
  --ssh default \
  -t private-repository-app:1.0 \
  .
```

Dockerfile:

```dockerfile
# syntax=docker/dockerfile:1

FROM alpine:latest

RUN apk add --no-cache git openssh-client

RUN --mount=type=ssh \
    git clone git@github.com:organization/private-repository.git
```

---

## Cache Mount

Python example:

```dockerfile
# syntax=docker/dockerfile:1

FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
```

Node.js example:

```dockerfile
# syntax=docker/dockerfile:1

FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN --mount=type=cache,target=/root/.npm \
    npm ci
```

---

# 🔐 Docker Security Best Practices

## Run as Non-Root

```dockerfile
USER appuser
```

---

## Drop Linux Capabilities

```bash
docker run \
  --cap-drop ALL \
  myapp:latest
```

Add only a required capability:

```bash
docker run \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  myapp:latest
```

---

## Read-Only Root Filesystem

```bash
docker run \
  --read-only \
  --tmpfs /tmp \
  myapp:latest
```

---

## Prevent Privilege Escalation

```bash
docker run \
  --security-opt no-new-privileges:true \
  myapp:latest
```

---

## Limit Processes

```bash
docker run \
  --pids-limit 200 \
  myapp:latest
```

---

## Apply Resource Limits

```bash
docker run \
  --memory="512m" \
  --cpus="1.0" \
  --pids-limit=200 \
  myapp:latest
```

---

## Avoid Privileged Containers

Avoid:

```bash
docker run --privileged myapp
```

The `--privileged` option grants extensive access to host devices and Linux capabilities.

Use the minimum permissions required by the application.

---

## Image Scanning

Using Docker Scout:

```bash
docker scout cves myapp:1.0
```

Using Trivy:

```bash
trivy image myapp:1.0
```

---

## Generate an SBOM

```bash
docker scout sbom myapp:1.0
```

Depending on the installed Docker tooling, an alternative may also be available:

```bash
docker sbom myapp:1.0
```

---

## Additional Security Recommendations

* Use official or trusted base images.
* Use minimal runtime images.
* Pin image versions.
* Regularly rebuild images.
* Remove unused packages.
* Never embed credentials in images.
* Protect the Docker socket.
* Avoid mounting `/var/run/docker.sock` unnecessarily.
* Use read-only filesystems where possible.
* Sign and verify trusted release images.
* Scan both images and dependencies.
* Keep Docker Engine and host packages patched.

---

# ❤️ Container Health Checks

A health check determines whether an application inside a running container is working correctly.

```dockerfile
HEALTHCHECK \
  --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD curl --fail http://localhost:8080/health || exit 1
```

Possible health states:

```text
starting
healthy
unhealthy
```

Inspect health status:

```bash
docker inspect \
  --format='{{json .State.Health}}' \
  container-name
```

View a simple health value:

```bash
docker inspect \
  --format='{{.State.Health.Status}}' \
  container-name
```

A Docker health check reports health status. Docker Engine does not automatically restart every unhealthy standalone container solely because it is unhealthy. Restart or replacement behaviour depends on the surrounding orchestration or monitoring system.

---

# ♻️ Restart Policies

## No Automatic Restart

```bash
docker run --restart=no nginx
```

---

## Restart on Failure

```bash
docker run --restart=on-failure nginx
```

Limit retries:

```bash
docker run --restart=on-failure:5 nginx
```

---

## Always Restart

```bash
docker run --restart=always nginx
```

---

## Restart Unless Manually Stopped

```bash
docker run --restart=unless-stopped nginx
```

---

# 📊 Monitoring and Troubleshooting

## Container Logs

```bash
docker logs container-name
```

Follow logs:

```bash
docker logs -f container-name
```

Show logs from the previous 10 minutes:

```bash
docker logs --since=10m container-name
```

Show timestamps:

```bash
docker logs --timestamps container-name
```

Show the last 100 lines:

```bash
docker logs --tail=100 container-name
```

---

## Live Resource Metrics

```bash
docker stats
```

For one container:

```bash
docker stats container-name
```

One-time output:

```bash
docker stats --no-stream
```

---

## Inspect Container State

```bash
docker inspect container-name
```

Get status:

```bash
docker inspect \
  --format '{{.State.Status}}' \
  container-name
```

Get exit code:

```bash
docker inspect \
  --format '{{.State.ExitCode}}' \
  container-name
```

Get IP address:

```bash
docker inspect \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
  container-name
```

Get restart count:

```bash
docker inspect \
  --format '{{.RestartCount}}' \
  container-name
```

---

## View Container Processes

```bash
docker top container-name
```

---

## Check Port Mapping

```bash
docker port container-name
```

---

## View Disk Usage

```bash
docker system df
```

Detailed output:

```bash
docker system df -v
```

---

## Debug a Failing Container

```bash
docker ps -a
docker logs container-name
docker inspect container-name
docker inspect container-name --format '{{.State.ExitCode}}'
docker inspect container-name --format '{{.State.Error}}'
docker diff container-name
```

When the container is running:

```bash
docker exec -it container-name sh
```

When the production image has no shell, create a separate debug image or use an appropriate debugging workflow rather than adding unnecessary utilities to the production image.

---

# 📋 Common Practical Tasks

## Build and Run an Application

```bash
docker build -t demo-app:dev .
```

```bash
docker run --rm \
  --name demo-app \
  -p 8080:8080 \
  demo-app:dev
```

---

## Run with Environment Variables

```bash
docker run --rm \
  -e APP_ENV=development \
  -e LOG_LEVEL=debug \
  myapp:latest
```

Use an environment file:

```bash
docker run --rm \
  --env-file .env \
  myapp:latest
```

Do not commit sensitive `.env` files to source control.

---

## Transfer an Image Between Hosts

Save the image:

```bash
docker save myapp:1.0 | gzip > myapp-1.0.tar.gz
```

Transfer it:

```bash
scp myapp-1.0.tar.gz user@server:~/
```

Load it remotely:

```bash
ssh user@server \
  'gunzip -c ~/myapp-1.0.tar.gz | docker load'
```

---

## Debug a Port Issue

Check published ports:

```bash
docker ps
docker port container-name
```

Inspect configuration:

```bash
docker inspect container-name
```

Test from inside the container:

```bash
docker exec container-name \
  curl -v http://localhost:8080
```

Check whether the application listens on all interfaces:

```text
0.0.0.0
```

An application listening only on `127.0.0.1` inside the container may not be reachable through normal Docker port publishing.

---

## Check DNS Resolution

```bash
docker exec backend getent hosts database
```

Alternative:

```bash
docker exec backend ping -c 3 database
```

The required utility must be installed in the container image.

---

## Resource-Constrained Container

```bash
docker run -d \
  --name limited-app \
  --memory="512m" \
  --cpus="1.0" \
  --pids-limit=200 \
  myapp:latest
```

---

## Read-Only Production Container

```bash
docker run -d \
  --name secure-app \
  --read-only \
  --tmpfs /tmp \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  myapp:latest
```

The application must be designed to write only to explicitly writable locations.

---

# 🧹 Docker Cleanup

## Remove Stopped Containers

```bash
docker container prune
```

---

## Remove Dangling Images

```bash
docker image prune
```

---

## Remove Unused Images

```bash
docker image prune -a
```

---

## Remove Unused Networks

```bash
docker network prune
```

---

## Remove Unused Volumes

```bash
docker volume prune
```

Be careful: unused volumes may still contain important data.

---

## Remove Multiple Unused Resources

```bash
docker system prune
```

Remove all unused images as well:

```bash
docker system prune -a
```

Remove unused volumes too:

```bash
docker system prune -a --volumes
```

> ⚠️ Review the resources carefully before running aggressive cleanup commands.

---

# 🧾 Dockerfile Patterns and Examples

Suggested repository structure:

```text
.
├── README.md
├── examples
│   ├── node-multistage
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── src
│   ├── python-healthcheck
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   ├── nonroot-minimal
│   │   ├── Dockerfile
│   │   └── app
│   └── docker-compose
│       ├── compose.yaml
│       └── app
├── scripts
│   ├── buildx-multiarch.sh
│   ├── docker-cleanup.sh
│   ├── exec-into.sh
│   └── tail-logs.sh
└── .dockerignore
```

---

## Example 1: Node.js Multi-Stage Application

Directory:

```text
examples/node-multistage/
```

Build:

```bash
cd examples/node-multistage
docker build -t node-multistage:dev .
```

Run:

```bash
docker run --rm \
  -p 3000:3000 \
  node-multistage:dev
```

---

## Example 2: Python Application with Health Check

Directory:

```text
examples/python-healthcheck/
```

Build:

```bash
cd examples/python-healthcheck
docker build -t python-healthcheck:dev .
```

Run:

```bash
docker run --rm \
  --name python-healthcheck \
  -p 5000:5000 \
  python-healthcheck:dev
```

Check health:

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  python-healthcheck
```

---

## Example 3: Non-Root Minimal Image

Directory:

```text
examples/nonroot-minimal/
```

Build:

```bash
cd examples/nonroot-minimal
docker build -t nonroot-app:dev .
```

Run:

```bash
docker run --rm nonroot-app:dev
```

Verify the user:

```bash
docker run --rm nonroot-app:dev id
```

---

# 🔧 Helper Scripts

## Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

---

## `docker-cleanup.sh`

Purpose:

* Remove stopped containers
* Remove dangling images
* Remove unused networks
* Optionally remove unused volumes

Usage:

```bash
./scripts/docker-cleanup.sh
```

---

## `buildx-multiarch.sh`

Purpose:

* Build multi-platform images
* Push images to a registry
* Use build cache
* Create `amd64` and `arm64` images

Usage:

```bash
./scripts/buildx-multiarch.sh username/myapp 1.0
```

---

## `exec-into.sh`

Purpose:

* Open a shell in a running container
* Use `sh` by default
* Allow an alternative shell

Usage:

```bash
./scripts/exec-into.sh container-name
```

Use Bash:

```bash
./scripts/exec-into.sh container-name bash
```

---

## `tail-logs.sh`

Purpose:

* Follow logs from one or more containers
* Apply a `--since` filter
* Simplify troubleshooting

Usage:

```bash
./scripts/tail-logs.sh container-name
```

---

# 🧩 Docker Compose

Docker Compose defines and manages multi-container applications using YAML.

Example:

```yaml
services:
  application:
    build:
      context: .
    ports:
      - "8080:8080"
    environment:
      DATABASE_HOST: database
    depends_on:
      database:
        condition: service_healthy
    networks:
      - application-network

  database:
    image: postgres:latest
    environment:
      POSTGRES_DB: application
      POSTGRES_USER: application_user
      POSTGRES_PASSWORD: change-me
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test:
        - CMD-SHELL
        - pg_isready -U application_user -d application
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - application-network

volumes:
  postgres-data:

networks:
  application-network:
```

Start services:

```bash
docker compose up -d
```

View services:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Stop services:

```bash
docker compose down
```

Remove volumes:

```bash
docker compose down -v
```

---

## Compose Override Files

Run development configuration:

```bash
docker compose \
  -f compose.yaml \
  -f compose.override.yaml \
  up -d
```

Run production configuration:

```bash
docker compose \
  -f compose.yaml \
  -f compose.production.yaml \
  up -d
```

Compose combines the files in the order supplied, with later configuration overriding or extending earlier configuration.

---

## Compose Secrets

Example:

```yaml
services:
  application:
    image: myapp:latest
    secrets:
      - database_password

secrets:
  database_password:
    file: ./secrets/database-password.txt
```

The application can normally access the secret at:

```text
/run/secrets/database_password
```

Do not store real secret files in source control.

---

# 📁 `.dockerignore` Template

```text
# Git
.git
.gitignore

# Environment and secrets
.env
.env.*
secrets/
*.pem
*.key

# Dependencies
node_modules/
venv/
.venv/
__pycache__/

# Build output
dist/
build/
target/
coverage/

# Logs
*.log
logs/

# IDE
.vscode/
.idea/

# Operating system
.DS_Store
Thumbs.db

# Docker-related files not required in build context
compose*.yaml
docker-compose*.yml
README.md
```

Review the exclusions based on the requirements of each application.

---

# 🧠 Quick Revision Notes

* Images are immutable and layered.
* Containers add a writable layer.
* Container data is lost when the container is removed unless persistent storage is used.
* Named volumes are preferred for persistent application data.
* Bind mounts are useful during development.
* `tmpfs` stores temporary data in memory.
* PID 1 controls the container lifecycle.
* Use exec-form `CMD` and `ENTRYPOINT`.
* `ENTRYPOINT` defines the executable.
* `CMD` provides default commands or arguments.
* Prefer `COPY` over `ADD`.
* Use `.dockerignore`.
* Use multi-stage builds.
* Run applications as non-root.
* Drop unnecessary Linux capabilities.
* Avoid privileged containers.
* Use a read-only root filesystem when possible.
* Set CPU, memory and PID limits.
* Use user-defined networks for name-based communication.
* `EXPOSE` documents a port; `-p` publishes it.
* Use `docker save/load` for images.
* Use `docker export/import` for container filesystems.
* Use BuildKit secrets instead of copying credentials.
* Health checks report application health.
* Use logs, inspect, stats, top, events and diff for debugging.
* Avoid using the `latest` tag for controlled production deployments.
* Scan images before deployment.
* Regularly rebuild and patch base images.

---

# 🎤 Docker Interview Questions

1. What is the difference between a Docker image and a container?
2. Explain Docker's layered filesystem.
3. What is copy-on-write?
4. What happens when PID 1 exits?
5. Why does a container exit immediately after startup?
6. What is the difference between `CMD` and `ENTRYPOINT`?
7. What is the difference between shell form and exec form?
8. What is the difference between `COPY` and `ADD`?
9. What is the difference between `EXPOSE` and `-p`?
10. What is a multi-stage Docker build?
11. How do multi-stage builds reduce image size?
12. How does Docker build caching work?
13. How can you optimize a Dockerfile for caching?
14. What is `.dockerignore`?
15. What is the difference between a named volume and a bind mount?
16. What is a `tmpfs` mount?
17. What is the difference between `docker save` and `docker export`?
18. What is the difference between bridge, host, none and overlay networking?
19. Why should applications run as non-root?
20. What is a Linux capability?
21. What does `--cap-drop ALL` do?
22. What is the risk of `--privileged`?
23. What does `--read-only` do?
24. What is a Docker health check?
25. Does Docker automatically restart an unhealthy standalone container?
26. What are Docker restart policies?
27. How do you limit container memory and CPU?
28. What is BuildKit?
29. What is Docker Buildx?
30. How do you build multi-architecture images?
31. How do you pass secrets securely during an image build?
32. How do you troubleshoot a container that keeps restarting?
33. How do you inspect a container's exit code?
34. How do containers communicate using a user-defined network?
35. How do you back up and restore a Docker volume?
36. What is the purpose of `docker diff`?
37. How do you check live container resource usage?
38. Why should production images be minimal?
39. Why should image tags or digests be pinned?
40. What security checks should be performed before deploying an image?

---

# ✅ Recommended Study Sequence

```text
1. Images and containers
2. Dockerfile instructions
3. Image layers and caching
4. Volumes and bind mounts
5. Docker networking
6. Docker Compose
7. Multi-stage builds
8. BuildKit and Buildx
9. Container security
10. Monitoring and troubleshooting
11. CI/CD image build and publishing
12. Production optimization
```

---

# 📌 Useful Commands Summary

```bash
# Build
docker build -t myapp:1.0 .

# Run
docker run -d --name myapp -p 8080:8080 myapp:1.0

# List
docker ps
docker ps -a
docker images

# Logs
docker logs -f myapp

# Shell
docker exec -it myapp sh

# Inspect
docker inspect myapp

# Metrics
docker stats

# Processes
docker top myapp

# Networks
docker network ls

# Volumes
docker volume ls

# Buildx
docker buildx ls

# Save image
docker save myapp:1.0 | gzip > myapp.tar.gz

# Load image
docker load -i myapp.tar.gz

# Cleanup
docker system prune
```

---

## ⚠️ Disclaimer

Some commands in this repository remove containers, images, networks or volumes.

Before running cleanup commands, verify that the resources are not required:

```bash
docker system df
docker ps -a
docker image ls
docker volume ls
docker network ls
```

Use aggressive cleanup commands such as the following only after careful review:

```bash
docker system prune -a --volumes
```

---

## 🤝 Contributing

Contributions are welcome.

Suggested contribution areas:

* Additional Dockerfile examples
* Docker Compose labs
* BuildKit caching examples
* Security-hardening examples
* CI/CD pipelines
* Docker interview questions
* Troubleshooting scenarios
* Kubernetes migration examples

---

## ⭐ Support

If this repository helps you learn Docker, consider starring it and sharing it with other DevOps learners.
