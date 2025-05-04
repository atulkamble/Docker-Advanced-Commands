**Docker Advanced Commands Cheat Sheet**:

---

## 🐳 **Docker Advanced Commands & Tutorials Cheat Sheet**

### 🧱 **1. Multi-Stage Build (Optimize Image Size)**

Efficient builds using temporary build containers.

```Dockerfile
# 🔧 Stage 1: Build
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o app

# 🚀 Stage 2: Run
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .
CMD ["./app"]
```

```bash
docker build -t go-multi-stage-app .
```

---

### 📜 **2. View Image History (Detailed)**

```bash
docker history --no-trunc <image-name>
```

---

### 📦 **3. Export & Import Containers**

Move containers across environments 🌍

```bash
docker export <container_id> > container.tar
docker import container.tar
```

---

### 💾 **4. Backup & Restore Volumes**

🎒 **Backup:**

```bash
docker run --rm -v volume_name:/volume -v $(pwd):/backup alpine \
  tar czf /backup/backup.tar.gz -C /volume .
```

♻️ **Restore:**

```bash
docker run --rm -v volume_name:/volume -v $(pwd):/backup alpine \
  tar xzf /backup/backup.tar.gz -C /volume
```

---

### 🧪 **5. Execute Commands in Containers**

👨‍💻 Interactively:

```bash
docker exec -it <container_name> bash
```

🧾 Non-interactive:

```bash
docker exec <container_name> ls /app
```

---

### 🌐 **6. Create & Use Custom Networks**

```bash
docker network create my-bridge-network
docker run -d --name db --network my-bridge-network postgres
docker run -d --name app --network my-bridge-network myapp
```

---

### ❤️‍🩹 **7. Add Health Check to Container**

```Dockerfile
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
```

---

### 🧩 **8. Docker Compose Override for Dev/Prod**

```bash
docker-compose -f docker-compose.yml -f docker-compose.override.yml up
```

---

### ⚙️ **9. Limit Container Resources**

🧠 Memory & 🧮 CPU:

```bash
docker run -m 512m --cpus="1.0" mycontainer
```

---

### 📊 **10. View Live Container Metrics**

```bash
docker stats
```

---

### 🔐 **11. Use Secrets & Environment Variables**

`.env` file:

```env
DB_PASSWORD=securepass
```

In `docker-compose.yml`:

```yaml
environment:
  - DB_PASSWORD=${DB_PASSWORD}
```

---

### 🧹 **12. Clean Up Docker System**

```bash
docker system prune -a --volumes
```

---

### 🚀 **13. Enable BuildKit for Faster Builds**

```bash
export DOCKER_BUILDKIT=1
docker build -t mybuildkitapp .
```

---

### 📁 **14. Sample Project Structure**

```bash
project/
├── Dockerfile
├── docker-compose.yml
└── app/
    └── main.py
```

**Dockerfile (Python):**

```Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app/main.py"]
```

**docker-compose.yml:**

```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/app
```

---

