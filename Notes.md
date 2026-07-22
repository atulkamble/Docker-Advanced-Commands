# Advanced Docker Notes (Interview + Certification Study Guide)

---

# 1. Multi-Stage Docker Builds

## Definition

A Multi-Stage Build uses multiple `FROM` instructions in a single Dockerfile.

Purpose:

* Reduce image size
* Remove build dependencies
* Improve security
* Faster deployments

Example

```dockerfile
# Build Stage
FROM node:22 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Runtime Stage
FROM nginx:latest

COPY --from=builder /app/dist /usr/share/nginx/html
```

### Advantages

✔ Small images

✔ Faster downloads

✔ Fewer vulnerabilities

✔ No compilers in production

---

# 2. Docker Image Layers

Every Docker instruction creates a layer.

```
FROM Ubuntu
↓

RUN apt install nginx
↓

COPY .
↓

RUN npm install
↓

CMD nginx
```

Each layer is immutable.

Docker reuses cached layers whenever possible.

---

## Which commands create layers?

Creates Layer

```
FROM
RUN
COPY
ADD
```

Metadata Layer

```
ENV
LABEL
WORKDIR
USER
EXPOSE
CMD
ENTRYPOINT
```

---

# 3. Docker Layer Cache

Docker executes Dockerfile from top to bottom.

If a layer changes:

```
Layer 1
↓

Layer 2

↓

Layer 3 ← changed

↓

Layer 4 rebuilt

↓

Layer 5 rebuilt
```

Everything below must rebuild.

---

## Best Practice

Instead of

```dockerfile
COPY . .

RUN npm install
```

Use

```dockerfile
COPY package*.json ./

RUN npm install

COPY . .
```

Only dependency changes reinstall packages.

---

# 4. PID 1 inside Container

Every container has one main process.

```
PID 1
```

Examples

```
nginx

python app.py

java -jar app.jar
```

If PID 1 exits

↓

Container stops.

---

## Interview Question

Why does container exit immediately?

Because the main process finished.

Example

```bash
docker run ubuntu
```

Ubuntu starts

↓

No running process

↓

Container exits.

---

# 5. CMD vs ENTRYPOINT

## CMD

Provides default command.

```dockerfile
CMD ["python","app.py"]
```

Can be overridden

```
docker run image bash
```

---

## ENTRYPOINT

Defines the main executable.

```dockerfile
ENTRYPOINT ["python","app.py"]
```

Cannot be replaced easily.

---

## Combined

```dockerfile
ENTRYPOINT ["python"]

CMD ["app.py"]
```

Execution

```
python app.py
```

Override

```
docker run image test.py

↓

python test.py
```

---

# 6. Shell Form vs Exec Form

### Shell Form

```dockerfile
ENTRYPOINT python app.py
```

Actually runs

```
/bin/sh -c "python app.py"
```

Extra shell process.

Signals may not reach application.

---

### Exec Form

```dockerfile
ENTRYPOINT ["python","app.py"]
```

Application becomes PID 1.

Better signal handling.

Recommended.

---

# 7. Docker COPY vs ADD

COPY

Only copies files.

```dockerfile
COPY . .
```

---

ADD

Can

* Copy files
* Extract tar archives
* Download URLs (not recommended)

---

Interview

Which should be preferred?

COPY

---

# 8. Docker Volumes

Container storage

```
Container

↓

Writable Layer

↓

Deleted when container deleted
```

---

Docker Volume

```
Container

↓

Volume

↓

Data survives
```

Create

```bash
docker volume create mysql-data
```

Run

```bash
docker run \
-v mysql-data:/var/lib/mysql mysql
```

---

Advantages

Persistent

Fast

Managed by Docker

---

# 9. Bind Mounts

Maps host directory.

```
Host

↓

Container
```

Example

```bash
docker run \
-v $(pwd):/app
```

Use cases

Development

VS Code

Hot Reload

---

Difference

Volume

Docker manages.

Bind Mount

Host manages.

---

# 10. Read Only Containers

```
docker run --read-only
```

Application cannot modify filesystem.

Need writable directories?

Use tmpfs.

Example

```bash
docker run \
--read-only \
--tmpfs /tmp
```

---

# 11. Docker Networks

Default

Bridge

```
Container A

↓

Bridge

↓

Container B
```

Same host only.

---

Host Network

Shares host network.

No NAT.

---

Overlay

Multiple Docker Hosts.

Used by

Docker Swarm

---

None

No networking.

---

# 12. User Defined Network

Instead of

Default bridge

Create

```bash
docker network create app-network
```

Run

```bash
docker run \
--network app-network \
--name mysql
```

Another

```bash
docker run \
--network app-network \
backend
```

Backend connects using

```
mysql
```

Automatic DNS.

---

# 13. Copy-On-Write

Images are shared.

```
Image

↓

Container1

↓

Writable Layer

Container2

↓

Writable Layer
```

Only modified files are copied.

Benefits

Less storage

Faster

Efficient

---

# 14. .dockerignore

Like `.gitignore`.

Prevents unnecessary files.

Example

```
.git

node_modules

.env

*.log
```

Benefits

Smaller build context

Faster builds

No secrets

---

# 15. Docker Security

Never run

```
root
```

Instead

```dockerfile
RUN adduser appuser

USER appuser
```

Benefits

Less privilege

Safer

Better compliance

---

Also

Avoid

```
latest
```

Pin versions

```
node:22

ubuntu:24.04
```

---

# 16. HEALTHCHECK

Checks application health.

Example

```dockerfile
HEALTHCHECK \
CMD curl -f http://localhost || exit 1
```

States

```
Starting

Healthy

Unhealthy
```

View

```bash
docker inspect container
```

---

# 17. Docker Cleanup

Containers

```bash
docker container prune
```

Images

```bash
docker image prune
```

Volumes

```bash
docker volume prune
```

Networks

```bash
docker network prune
```

Everything

```bash
docker system prune
```

Everything including images

```bash
docker system prune -a
```

---

# 18. Restart Policies

No restart

```bash
--restart=no
```

Restart on failure

```bash
--restart=on-failure
```

Always

```bash
--restart=always
```

Unless manually stopped

```bash
--restart=unless-stopped
```

---

# 19. Resource Limits

CPU

```bash
docker run --cpus=2
```

Memory

```bash
docker run --memory=512m
```

Memory + CPU

```bash
docker run \
--cpus=2 \
--memory=1g
```

Benefits

Prevents one container from consuming all host resources.

---

# 20. Docker Best Practices

### Image

* Use official base images.
* Keep images small.
* Pin image versions.
* Use multi-stage builds.
* Avoid unnecessary packages.

### Dockerfile

* Prefer `COPY` over `ADD`.
* Use `.dockerignore`.
* Combine related `RUN` commands.
* Place frequently changing instructions near the end to maximize cache reuse.

### Security

* Run as a non-root user.
* Avoid storing secrets in images or environment variables.
* Scan images regularly (e.g., Docker Scout, Trivy, Grype).

### Performance

* Reuse build cache effectively.
* Use Docker volumes for persistent data.
* Limit CPU and memory usage.
* Keep containers stateless whenever possible.

---

# Frequently Asked Interview Questions

1. What is the difference between a container and an image?
2. Explain Docker's layered filesystem.
3. What is Copy-on-Write?
4. Why use multi-stage builds?
5. Explain `CMD` vs `ENTRYPOINT`.
6. What happens if PID 1 exits?
7. What is the difference between a Docker volume and a bind mount?
8. Why use `.dockerignore`?
9. How does Docker layer caching work?
10. Explain Docker networking modes: Bridge, Host, Overlay, and None.
11. Why should containers avoid running as root?
12. What is the purpose of `HEALTHCHECK`?
13. What is the difference between `COPY` and `ADD`?
14. How do you optimize Docker image size?
15. What are common Docker security best practices?

These notes cover the core advanced Docker topics frequently tested in **AZ-400**, **CKA/CKAD**, **Docker Certified Associate (DCA)**, and senior **DevOps/SRE/Cloud Engineer** interviews.
