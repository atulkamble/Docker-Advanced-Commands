# Multi-stage Node.js build with non-root runtime
# Builder stage
FROM node:20-alpine AS builder
WORKDIR /app
# Install dependencies first for better caching
COPY package*.json ./
RUN npm install --production=false
# Copy app source
COPY . .
# (Optional) run tests or build steps
# RUN npm test
# Prune dev deps for production
RUN npm prune --omit=dev

# Runtime stage (non-root)
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app
# Create non-root user and group
RUN addgroup -S nodegrp && adduser -S nodeusr -G nodegrp
# Copy only necessary files from builder
COPY --from=builder /app /app
# Set ownership and drop root
RUN chown -R nodeusr:nodegrp /app
USER nodeusr
EXPOSE 3000
HEALTHCHECK CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "index.js"]
