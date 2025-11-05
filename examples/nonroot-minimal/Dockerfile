# Minimal non-root image using BusyBox
FROM busybox:1.36
# Create a non-root user and a workspace
RUN addgroup -S appgrp && adduser -S appusr -G appgrp && \
    mkdir -p /workspace && chown -R appusr:appgrp /workspace
WORKDIR /workspace
USER appusr
# Read-only root filesystem and no shell needed at runtime is a good practice in prod
CMD ["/bin/sh", "-c", "echo Running as $(id -u):$(id -g) in $(pwd)"]
