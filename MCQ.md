/**
 * Creates an Advanced Docker MCQ Quiz in Google Forms.
 *
 * Features:
 * - 20 multiple-choice questions
 * - Correct answers configured
 * - 1 point per question
 * - Correct and incorrect answer explanations
 * - Required questions
 * - Email collection enabled
 *
 * Run myFunction() once from Google Apps Script.
 */
function myFunction() {
  const form = FormApp.create("Advanced Docker MCQ Quiz");

  form
    .setDescription(
      "Advanced Docker Assessment\n\n" +
      "Total Questions: 20\n" +
      "Total Marks: 20\n" +
      "Each question carries 1 mark.\n\n" +
      "Select the most appropriate answer."
    )
    .setIsQuiz(true)
    .setCollectEmail(true)
    .setProgressBar(true)
    .setShuffleQuestions(false)
    .setConfirmationMessage(
      "Your Docker quiz has been submitted successfully."
    );

  const questions = [
    {
      question:
        "1. What is the primary purpose of a multi-stage Docker build?",
      options: [
        "Run multiple containers from one image",
        "Reduce the final image size by separating build and runtime environments",
        "Create multiple image tags simultaneously",
        "Allow containers to use multiple networks"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. Multi-stage builds allow compilation in one stage and copy only the required runtime files into the final stage.",
      incorrectExplanation:
        "Incorrect. Multi-stage builds separate the build environment from the runtime environment, reducing the final image size and attack surface."
    },
    {
      question:
        "2. Which command displays the processes running inside a container?",
      options: [
        "docker inspect <container>",
        "docker ps <container>",
        "docker top <container>",
        "docker stats <container>"
      ],
      correctAnswer: 2,
      correctExplanation:
        "Correct. docker top displays the processes currently running inside a container.",
      incorrectExplanation:
        "Incorrect. docker inspect shows metadata, docker ps lists containers, and docker stats shows resource usage. The correct command is docker top."
    },
    {
      question:
        "3. What happens when PID 1 inside a Docker container stops?",
      options: [
        "Docker restarts the Docker daemon",
        "The container stops",
        "Only the application process restarts",
        "The container enters the paused state"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. The container lifecycle is tied to its main process, which runs as PID 1.",
      incorrectExplanation:
        "Incorrect. When the container's PID 1 process exits, the container stops. It restarts only when an appropriate restart policy is configured."
    },
    {
      question:
        "4. Which Dockerfile instruction executes a command during image build and creates a filesystem layer?",
      options: [
        "ENV",
        "LABEL",
        "RUN",
        "ARG"
      ],
      correctAnswer: 2,
      correctExplanation:
        "Correct. RUN executes a command during the image build and commits the resulting filesystem changes as a layer.",
      incorrectExplanation:
        "Incorrect. RUN executes build-time commands. ENV, LABEL and ARG primarily configure metadata or variables."
    },
    {
      question:
        "5. What is the main difference between CMD and ENTRYPOINT?",
      options: [
        "CMD runs during build, while ENTRYPOINT runs during startup",
        "ENTRYPOINT defines the main executable, while CMD commonly provides default arguments",
        "CMD cannot be overridden",
        "There is no difference"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. ENTRYPOINT normally defines the executable, while CMD can provide default arguments to that executable.",
      incorrectExplanation:
        "Incorrect. Both apply when a container starts. ENTRYPOINT defines the main executable, while CMD commonly supplies default arguments and can be overridden."
    },
    {
      question:
        "6. Which command removes unused containers, networks, images and build cache?",
      options: [
        "docker system clean",
        "docker system prune",
        "docker image purge",
        "docker container prune --all"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. docker system prune removes unused Docker resources. The -a option additionally removes all unused images.",
      incorrectExplanation:
        "Incorrect. The valid command for removing multiple categories of unused Docker resources is docker system prune."
    },
    {
      question:
        "7. Which storage option is generally recommended for persistent container data?",
      options: [
        "Container writable layer",
        "Docker volume",
        "Docker image layer",
        "Temporary filesystem only"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. Docker volumes persist independently of a container's lifecycle and are managed by Docker.",
      incorrectExplanation:
        "Incorrect. The container writable layer is removed with the container, image layers are read-only, and tmpfs data disappears when the container stops."
    },
    {
      question:
        "8. Which statement about bind mounts is correct?",
      options: [
        "Docker completely manages their storage location",
        "They map a host file or directory directly into a container",
        "They cannot be used in development",
        "They are stored inside the Docker image"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. A bind mount maps a specific file or directory from the Docker host into the container.",
      incorrectExplanation:
        "Incorrect. Bind mounts use explicit host paths and are frequently used during development for live source-code access."
    },
    {
      question:
        "9. What does the --read-only option do when starting a container?",
      options: [
        "Makes the Docker image read-only",
        "Prevents the container from writing to its root filesystem",
        "Stops users from reading container logs",
        "Prevents all volume mounting"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. --read-only mounts the container's root filesystem as read-only.",
      incorrectExplanation:
        "Incorrect. --read-only affects the container root filesystem. Writable volumes and tmpfs mounts can still be attached when necessary."
    },
    {
      question:
        "10. What does docker run --rm -it ubuntu bash do?",
      options: [
        "Builds an Ubuntu image",
        "Runs Ubuntu interactively and removes the container after it exits",
        "Runs Ubuntu permanently in the background",
        "Removes the Ubuntu image after execution"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. -it provides an interactive terminal, and --rm automatically removes the container after it exits.",
      incorrectExplanation:
        "Incorrect. This command starts an interactive Ubuntu container and deletes the container, not the image, after exit."
    },
    {
      question:
        "11. Which Docker network driver supports communication across multiple Docker hosts?",
      options: [
        "bridge",
        "host",
        "overlay",
        "none"
      ],
      correctAnswer: 2,
      correctExplanation:
        "Correct. Overlay networks support communication between services or containers running on different Docker hosts.",
      incorrectExplanation:
        "Incorrect. A bridge network normally works on one host, host mode shares the host network stack, and none disables networking."
    },
    {
      question:
        "12. What is an important benefit of a user-defined bridge network?",
      options: [
        "It automatically builds Docker images",
        "It provides automatic DNS-based container-name resolution",
        "It prevents all communication between containers",
        "It exposes every container port publicly"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. Containers on a user-defined bridge network can resolve one another using container names or network aliases.",
      incorrectExplanation:
        "Incorrect. User-defined bridge networks provide built-in DNS-based name resolution and better network isolation."
    },
    {
      question:
        "13. What does Docker's copy-on-write mechanism mean?",
      options: [
        "Every container receives a full physical copy of the image",
        "Image layers are shared until a container modifies a file",
        "Containers cannot modify files",
        "Container changes are written back to the original image"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. Containers share read-only image layers and copy changed files into their own writable layer.",
      incorrectExplanation:
        "Incorrect. Docker shares immutable image layers. Modified files are copied into the individual container's writable layer."
    },
    {
      question:
        "14. Which file excludes files and directories from the Docker build context?",
      options: [
        ".dockerignore",
        ".gitignore",
        "EXCLUDE",
        "IGNORE"
      ],
      correctAnswer: 0,
      correctExplanation:
        "Correct. .dockerignore prevents specified files and directories from being sent as part of the Docker build context.",
      incorrectExplanation:
        "Incorrect. .gitignore affects Git tracking. Docker uses .dockerignore to exclude files from the build context."
    },
    {
      question:
        "15. Why should applications usually avoid running as root inside a container?",
      options: [
        "Root cannot access environment variables",
        "Running as root increases the impact of a container compromise",
        "Root automatically increases image size",
        "Docker does not support root users"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. Running with the minimum required privileges reduces the potential impact of an application or container compromise.",
      incorrectExplanation:
        "Incorrect. Docker supports root users, but running applications as root increases security risk. A non-root USER should normally be configured."
    },
    {
      question:
        "16. What is the purpose of the Dockerfile HEALTHCHECK instruction?",
      options: [
        "Restart the Docker daemon",
        "Check whether the containerized application is functioning correctly",
        "Scan the image for security vulnerabilities",
        "Measure the physical host's hardware health"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. HEALTHCHECK periodically runs a command to determine whether the application inside the container is healthy.",
      incorrectExplanation:
        "Incorrect. HEALTHCHECK evaluates application health. It does not perform vulnerability scanning or host hardware monitoring."
    },
    {
      question:
        "17. What normally happens when an earlier Dockerfile layer changes?",
      options: [
        "Docker always uses every cached layer",
        "That layer and subsequent layers may need to be rebuilt",
        "Only the image tag changes",
        "Docker deletes the Dockerfile"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. A change invalidates the cache for that instruction and normally causes subsequent layers to be rebuilt.",
      incorrectExplanation:
        "Incorrect. Docker layer caching is sequential. When a layer changes, the cache for later instructions is generally invalidated."
    },
    {
      question:
        "18. Which restart policy restarts a container unless it was manually stopped?",
      options: [
        "no",
        "on-failure",
        "always-fail",
        "unless-stopped"
      ],
      correctAnswer: 3,
      correctExplanation:
        "Correct. unless-stopped restarts the container after failures or daemon restarts unless it was manually stopped.",
      incorrectExplanation:
        "Incorrect. The correct policy is unless-stopped. on-failure only restarts after a non-zero exit code."
    },
    {
      question:
        "19. What is the effect of --memory=\"512m\"?",
      options: [
        "Reserves exactly 512 MB permanently",
        "Limits the container's memory usage to approximately 512 MB",
        "Increases the Docker image size to 512 MB",
        "Limits the container disk size to 512 MB"
      ],
      correctAnswer: 1,
      correctExplanation:
        "Correct. --memory sets a maximum memory limit for the container.",
      incorrectExplanation:
        "Incorrect. The option controls runtime memory usage. It does not affect image size or directly limit disk storage."
    },
    {
      question:
        "20. Why is the exec form of ENTRYPOINT generally recommended?",
      options: [
        "It executes during the image build",
        "It prevents the application from receiving signals",
        "It makes the application the direct container process and improves signal handling",
        "It automatically creates multiple containers"
      ],
      correctAnswer: 2,
      correctExplanation:
        "Correct. The exec form avoids an unnecessary shell process and helps signals such as SIGTERM reach the application directly.",
      incorrectExplanation:
        "Incorrect. The exec form makes the application the direct process, which improves signal handling and graceful container shutdown."
    }
  ];

  questions.forEach(function (questionData) {
    addQuizQuestion(form, questionData);
  });

  Logger.log("Google Form created successfully.");
  Logger.log("Form title: " + form.getTitle());
  Logger.log("Edit URL: " + form.getEditUrl());
  Logger.log("Student URL: " + form.getPublishedUrl());
}

/**
 * Adds one graded multiple-choice question to the form.
 *
 * @param {GoogleAppsScript.Forms.Form} form Google Form object.
 * @param {Object} questionData Question configuration.
 */
function addQuizQuestion(form, questionData) {
  const item = form.addMultipleChoiceItem();

  const choices = questionData.options.map(function (option, index) {
    const isCorrect = index === questionData.correctAnswer;
    return item.createChoice(option, isCorrect);
  });

  const correctFeedback = FormApp.createFeedback()
    .setText(questionData.correctExplanation)
    .build();

  const incorrectFeedback = FormApp.createFeedback()
    .setText(questionData.incorrectExplanation)
    .build();

  item
    .setTitle(questionData.question)
    .setChoices(choices)
    .setRequired(true)
    .setPoints(1)
    .setFeedbackForCorrect(correctFeedback)
    .setFeedbackForIncorrect(incorrectFeedback);
}
