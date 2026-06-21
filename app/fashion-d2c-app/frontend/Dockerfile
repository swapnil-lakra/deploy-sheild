# ---- Build Stage ----
FROM oven/bun:latest AS builder

WORKDIR /app

# Accept build-time API URL and expose it to the build
ARG VITE_API_URL="/api"
ENV VITE_API_URL=${VITE_API_URL}

# Copy package files first (better caching)
COPY package.json bun.lockb* ./

# Install dependencies using Bun (faster than npm)
RUN bun install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build the Vite app (produces 'dist' folder)
RUN bun run build

# ---- Runtime Stage ----
FROM nginxinc/nginx-unprivileged:alpine-slim

# Copy built static files from builder to nginx html folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Create nginx config to serve SPA and proxy /api to backend service inside docker network
RUN echo $'server { \n\
    listen 80; \n\
    root /usr/share/nginx/html; \n\
    index index.html; \n\
\n\
    # Proxy API calls to backend container (docker-compose service name) \n\
    location /api/ { \n\
        proxy_pass http://backend-blue:8000/; \n\
        proxy_set_header Host $host; \n\
        proxy_set_header X-Real-IP $remote_addr; \n\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \n\
        proxy_set_header X-Forwarded-Proto $scheme; \n\
    } \n\
\n\
    # SPA fallback for client-side routing\n\
    location / { \n\
        try_files $uri $uri/ /index.html; \n\
    } \n\
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]