Advanced Docker MCQ Quiz — 20 Questions

1. What is the primary purpose of a multi-stage Docker build?

A. Run multiple containers from one image
B. Reduce the final image size by separating build and runtime environments
C. Create multiple image tags simultaneously
D. Allow containers to use multiple networks

Correct answer: B

Explanation:

A — Wrong: Multiple containers are normally managed using Docker Compose, Swarm, or Kubernetes.

B — Right: Multi-stage builds allow compilation in one stage and copying only required runtime files into the final stage.

C — Wrong: Tags are assigned through docker build -t or docker tag.

D — Wrong: Docker networks are unrelated to image build stages.



---

2. Which command displays the processes running inside a container?

A. docker inspect <container>
B. docker ps <container>
C. docker top <container>
D. docker stats <container>

Correct answer: C

Explanation:

A — Wrong: docker inspect displays detailed configuration and metadata.

B — Wrong: docker ps lists containers, not processes inside them.

C — Right: docker top displays processes running inside a container.

D — Wrong: docker stats displays CPU, memory and network usage.



---

3. What happens when PID 1 inside a Docker container stops?

A. Docker restarts the Docker daemon
B. The container stops
C. Only the application process restarts
D. The container enters the paused state

Correct answer: B

Explanation:

A — Wrong: The Docker daemon is independent of the container process.

B — Right: A container remains alive only while its main PID 1 process is running.

C — Wrong: Automatic restart happens only when a restart policy is configured.

D — Wrong: A paused container is created using docker pause.



---

4. Which Dockerfile instruction creates a new image layer during build?

A. ENV
B. LABEL
C. RUN
D. ARG

Correct answer: C

Explanation:

A — Wrong: ENV changes image metadata and configuration.

B — Wrong: LABEL adds metadata.

C — Right: RUN executes a command during the image build and creates a filesystem layer.

D — Wrong: ARG defines build-time variables and does not directly create a filesystem layer.



---

5. What is the difference between CMD and ENTRYPOINT?

A. CMD runs during build, while ENTRYPOINT runs during container startup
B. ENTRYPOINT defines the main executable, while CMD usually provides default arguments
C. CMD cannot be overridden
D. There is no difference

Correct answer: B

Explanation:

A — Wrong: Both apply when the container starts. RUN executes during image build.

B — Right: ENTRYPOINT defines the main command, while CMD commonly supplies its default arguments.

C — Wrong: CMD can easily be overridden from docker run.

D — Wrong: They have different override and execution behaviours.


Example:

ENTRYPOINT ["python", "app.py"]
CMD ["--port", "8080"]


---

6. Which command removes unused containers, networks, images and build cache?

A. docker system clean
B. docker system prune
C. docker image purge
D. docker container prune --all

Correct answer: B

Explanation:

A — Wrong: docker system clean is not a valid Docker command.

B — Right: docker system prune removes unused Docker resources.

C — Wrong: docker image purge is invalid.

D — Wrong: docker container prune removes only stopped containers and does not support this behaviour.


Use carefully:

docker system prune -a

The -a option also removes unused images, not only dangling images.


---

7. Which storage option is recommended for persistent production data?

A. Container writable layer
B. Docker volume
C. Docker image layer
D. Temporary filesystem only

Correct answer: B

Explanation:

A — Wrong: Data in the container writable layer may be lost when the container is removed.

B — Right: Docker volumes are managed by Docker and persist independently of containers.

C — Wrong: Image layers are read-only.

D — Wrong: tmpfs stores data in memory and loses it when the container stops.



---

8. Which statement about bind mounts is correct?

A. Docker completely manages their storage location
B. They map a host file or directory directly into a container
C. They cannot be used in development
D. They are stored inside the Docker image

Correct answer: B

Explanation:

A — Wrong: Docker volumes are managed by Docker; bind mounts use explicit host paths.

B — Right: Bind mounts expose a host file or directory inside the container.

C — Wrong: They are commonly used in development for live source-code changes.

D — Wrong: Bind-mounted data is not stored in the image.


Example:

docker run -v "$PWD":/app nginx


---

9. What does the --read-only option do?

A. Makes the Docker image read-only
B. Prevents the container from writing to its root filesystem
C. Stops users from reading container logs
D. Prevents volume mounting

Correct answer: B

Explanation:

A — Wrong: Docker image layers are already immutable.

B — Right: It mounts the container root filesystem as read-only.

C — Wrong: It does not control log access.

D — Wrong: Writable volumes and tmpfs mounts can still be attached.


Example:

docker run --read-only --tmpfs /tmp myapp


---

10. What does the following command do?

docker run --rm -it ubuntu bash

A. Builds an Ubuntu image
B. Runs Ubuntu interactively and removes the container after it exits
C. Runs Ubuntu permanently in the background
D. Removes the Ubuntu image after execution

Correct answer: B

Explanation:

A — Wrong: docker build builds images.

B — Right: -it provides an interactive terminal, and --rm removes the container after exit.

C — Wrong: Background execution requires -d.

D — Wrong: --rm removes the container, not the image.



---

11. Which network driver allows communication between containers running on different Docker hosts?

A. bridge
B. host
C. overlay
D. none

Correct answer: C

Explanation:

A — Wrong: A bridge network normally connects containers on the same Docker host.

B — Wrong: Host networking uses the host's network stack.

C — Right: Overlay networking connects services or containers across multiple Docker hosts.

D — Wrong: The none driver disables external networking.



---

12. What is the main benefit of a user-defined bridge network?

A. It automatically builds Docker images
B. It provides automatic DNS-based container-name resolution
C. It disables container communication
D. It exposes all container ports publicly

Correct answer: B

Explanation:

A — Wrong: Networks do not build images.

B — Right: Containers on a user-defined bridge network can resolve each other using container or service names.

C — Wrong: Containers on the network can communicate unless restricted.

D — Wrong: Ports are publicly exposed only when explicitly published.


Example:

docker network create app-network
docker run -d --name database --network app-network mysql
docker run -d --name backend --network app-network myapp

The backend can connect to the hostname database.


---

13. What does Docker’s copy-on-write mechanism mean?

A. Every container receives a complete physical copy of the image
B. Image layers are shared until a container modifies a file
C. Containers cannot modify files
D. Changes are automatically written back to the original image

Correct answer: B

Explanation:

A — Wrong: Sharing layers prevents unnecessary duplication.

B — Right: Containers share read-only image layers and copy files into the writable layer when modifications are required.

C — Wrong: Containers can write to their writable layer.

D — Wrong: Running-container changes do not modify the original image.



---

14. Which instruction should be used to exclude files from the Docker build context?

A. .dockerignore
B. .gitignore
C. EXCLUDE
D. IGNORE

Correct answer: A

Explanation:

A — Right: .dockerignore prevents unnecessary or sensitive files from being sent in the build context.

B — Wrong: .gitignore controls Git tracking, not the Docker build context.

C — Wrong: EXCLUDE is not a Dockerfile instruction.

D — Wrong: IGNORE is not a valid Dockerfile instruction.


Example .dockerignore:

.git
node_modules
.env
*.log
Dockerfile*


---

15. Why should applications usually avoid running as the root user inside a container?

A. Root users cannot access environment variables
B. Running as root increases the impact of a container compromise
C. Root users make images larger
D. Docker does not support root users

Correct answer: B

Explanation:

A — Wrong: Root can access environment variables.

B — Right: A compromised root process may have greater ability to exploit container or host misconfigurations.

C — Wrong: User identity does not significantly determine image size.

D — Wrong: Containers run as root by default unless another user is configured.


Example:

RUN useradd --create-home appuser
USER appuser


---

16. What is the purpose of the HEALTHCHECK instruction?

A. Restart the Docker daemon
B. Check whether the containerized application is functioning correctly
C. Scan the image for security vulnerabilities
D. Measure the host’s hardware health

Correct answer: B

Explanation:

A — Wrong: It does not manage the Docker daemon.

B — Right: It runs a command periodically to determine whether the container is healthy.

C — Wrong: Vulnerability scanning requires tools such as Docker Scout, Trivy, or Grype.

D — Wrong: It evaluates the container application, not the physical host.


Example:

HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/health || exit 1


---

17. What happens when a command before COPY . . changes in a Dockerfile?

A. Docker always uses every cached layer
B. That layer and all subsequent layers may need to be rebuilt
C. Only the final image tag changes
D. Docker deletes the Dockerfile

Correct answer: B

Explanation:

A — Wrong: Cache is reused only when the instruction and its dependencies remain unchanged.

B — Right: When one layer changes, Docker rebuilds that layer and normally invalidates subsequent layers.

C — Wrong: The image content may also change.

D — Wrong: Docker does not delete the Dockerfile.


A cache-friendly Node.js pattern is:

COPY package*.json ./
RUN npm ci
COPY . .

Dependencies are reinstalled only when package files change.


---

18. Which restart policy restarts a container unless it is manually stopped?

A. no
B. on-failure
C. always-fail
D. unless-stopped

Correct answer: D

Explanation:

A — Wrong: no disables automatic restart.

B — Wrong: on-failure restarts only when the process exits with a non-zero code.

C — Wrong: always-fail is not a valid policy.

D — Right: unless-stopped restarts the container after failures or daemon restarts unless it was manually stopped.


Example:

docker run -d --restart unless-stopped nginx


---

19. What is the effect of this option?

--memory="512m"

A. Reserves exactly 512 MB permanently
B. Limits the container’s memory usage to approximately 512 MB
C. Increases the Docker image size to 512 MB
D. Limits disk storage to 512 MB

Correct answer: B

Explanation:

A — Wrong: It sets a limit rather than permanently reserving that amount in every case.

B — Right: It restricts the maximum memory available to the container.

C — Wrong: Runtime memory limits do not affect image size.

D — Wrong: It does not set a disk-storage limit.


Example:

docker run -d --memory="512m" --cpus="1.5" myapp


---

20. Why is the exec form of ENTRYPOINT recommended?

ENTRYPOINT ["nginx", "-g", "daemon off;"]

A. It runs during image build
B. It prevents the application from receiving signals
C. It makes the application the direct container process and handles signals correctly
D. It automatically creates multiple containers

Correct answer: C

Explanation:

A — Wrong: ENTRYPOINT runs when the container starts.

B — Wrong: The exec form improves signal delivery.

C — Right: It avoids an unnecessary shell process and allows signals such as SIGTERM to reach the application directly.

D — Wrong: It starts only the configured process inside one container.


The shell form:

ENTRYPOINT nginx -g "daemon off;"

may run through /bin/sh -c, which can interfere with signal handling.


---

Answer Key

Question	Answer	Topic

1	B	Multi-stage builds
2	C	Container processes
3	B	PID 1
4	C	Image layers
5	B	CMD vs ENTRYPOINT
6	B	Resource cleanup
7	B	Persistent storage
8	B	Bind mounts
9	B	Read-only filesystem
10	B	Interactive containers
11	C	Overlay networking
12	B	Docker DNS
13	B	Copy-on-write
14	A	Build context
15	B	Container security
16	B	Health checks
17	B	Build cache
18	D	Restart policies
19	B	Resource limits
20	C	Signal handling