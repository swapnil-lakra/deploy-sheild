# ------------------------- 
# Stage 1 - Build React/Vite App 
# -------------------------

FROM oven/bun:latest AS builder

WORKDIR /app

# Copy dependency files first (better Docker cache)
COPY package.json bun.lockb* ./

# Install depencencies
RUN bun install --frozen-lockfile

# Copy application source
COPY . .

# Build production bundle
RUN bun run build

# ------------------------- 
# Stage 2 - Runtime (Nginx) 
# -------------------------

FROM nginxinc/nginx-unprivileged:alpine-slim

USER root

# Copy frontend build
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx template
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

RUN apk add --no-cache wget envsubst
# Copy startup script
COPY --chmod=755 entrypoint.sh /entrypoint.sh

USER 101

# Default values (can be overridden by docker-compose env_file)
ENV BACKEND_HOST=backend-blue
ENV BACKEND_PORT=8000
ENV ENVIRONMENT=blue

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]