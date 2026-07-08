Date - 12/06/2026

# 1. Frontend Docker image build Error - bun.lock not found to copy

## Root Cause of Error :-
Image build karte waqt ishliye Error aaya kyuki docker bun.lock ko app folder me copy karna chahta tha lekin wo bun.lock ko find nahi kar paya kyuki maine bun.lock of .dockerignore me add kar rakha tha iss reason ke wo bun.lock ko ignore kar raha tha.

## Error Resoluton :-
Iss Error ko solve karne ke 2 taarike hai :
1. Mujhe .dockerignore me se bun.lock ko remove karna padega toh docker bun.lock ko ignore nahi karega
2. Ya fir Mujhe Dockerfile me se bun.lock ko remove karna padega taaki wo app folder me copy na ho

Mai Option 1 ko choose kiya hun 

Date - 13/06/2026

# 2. Backend Docker image build Error - Alpine Linux package manager error

## Root Cause of Error:
Image build karte waqt ishliye error occur hua kyuki mere Docker image Alpine Linux (python:3.12-alpine) pe based hai naaki Fedora ya Ubuntu. Alpine `apk` ko apna package manager ke taur pe use karta hai , naaki `dnf` (Fedora/RHEL) or `apt` (Debian/Ubuntu).

```Dockerfile
# Wrong Command according to Alpine Linux
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*
```

## Error Resolution :-
Iss error ko solve karne ke liye mujhe Dockerfile ke command me `apline linux` ka package manager `apk` ko use karna padega kyuki mai apne Dockerfile me `python:3.12-alpine` ko use kiya hai 

```Dockerfile
# Correct Command according to Apline Linux
RUN apk add --no-cache gcc mariadb-dev pkgconfig
```
Date - 14/06/2026

# 3. Frontend Docker image build Error - Environment Variable "undefined" Issue in Docker Build

## Root Cause of Error :
### 1. Build-Time vs Runtime Difference
```text
❌ JYADA hone wala:
Local development:  .env file → NextJS read → Build time pe available
Docker build:       .env file → Docker context mein nahin → Build time pe undefined
```

### Kya ho raha hai:
```javascript
// Server Component mein
const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/products/`);
                        ↑ ye value build time pe hard-coded ho jaata hai
```

Build time pe `process.env.NEXT_PUBLIC_API_URL` evaluate hota hai. Agar `.env` file Docker container mein available nahin hai, toh `undefined` ho jaata hai.

### 2. NEXT_PUBLIC_ Prefix Confusion
`NEXT_PUBLIC_` prefix ka matlab:

- ✅ Client-side mein expose ho sakta hai
- ✅ Build time mein hard-coded ho jaata hai
- ❌ Runtime pe change nahin ho sakta

```javascript
// ye build time mein ye ban jaata hai:
const res = await fetch(`undefined/api/products/`);
// kyunki build time pe undefined tha
```

## Error Resolution :

Maine iss error ko resolve karne ke liye **Runtime Environment Variables** ka use kiya hai jo server side rendering ke liye environment variables ko build time se runtime mein move karta hai.

```javascript
// lib/config.js
export const getApiUrl = () => {
  // Runtime pe check karo, build time nahin
  return process.env.NEXT_PUBLIC_API_URL || 
         'http://localhost:8000';
};
```

```javascript
// app/products/page.js
import { getApiUrl } from '@/lib/config';

export default async function ProductsPage() {
  const apiUrl = getApiUrl(); // Runtime pe call hota hai!
  
  const res = await fetch(`${apiUrl}/api/products/`, {
    cache: "no-store",
  });
  const products = await res.json();
  
  return (
    // ... same JSX
  );
}
```

```Dockerfile
# Runtime pe environment variables default values ke saath
# Docker/docker-compose se override ho sakte hain
ENV NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
```


# 4. Frontend Docker image build Error - Module not found: Can't resolve '@/lib/config'" Error

## Root Cause of Error :
Ye issue TypeScript/JavaScript path alias resolution ka hai. Build time pe `@/` path resolve nahin ho pa raha!

## Error Resolution :

Mai iss error ko resolve karne ke liye relative path ka use kiya hua hu

```javascript

// Build time pe '@/' resolve nahi ho raha hai
import { getApiUrl } from "@/lib/config" ❌

// To resolve this change `@` to '..' relative path
import { getApiUrl } from "../lib/config" ✅
```

# 5. Frontend Docker image build Error - Build Time PE API Connection Refused Error

**Kya hua (What happened):**     Your Next.js build fail ho gaya kyun ke production build ke time pe app ek API endpoint (`http://localhost:8000/api/products/featured?limit=4`) ko access karne ki koshish kar raha tha, lekin woh service available nahi tha.

## Root Cause of Error :
Dockerfile mein **build time pe API calls ho rahe hain** kyun ke:

1. Next.js 13+ default mein static export ya ISR (Incremental Static Regeneration) use kar raha hai
2. Build phase ke doran page `/` ko prerender kar rahe ho
3. Jab prerender ho raha tha, toh page ne featured products fetch karne ke liye API call kiya
4. **Docker container ke andar `localhost:8000` par koi service nahi chal raha tha** → Connection Refused

```Code
❌ Build Phase (Docker ke andar)
  └─ Next.js tries to prerender "/"
    └─ Page calls: http://localhost:8000/api/products/featured
      └─ Connection refused (service doesn't exist)
        └─ Build fails
```

## Error Resolution :

Mai iss error ko resolve karne ke liye mai **Dynamic Rendering** ka use kiya hu jo best hai **API-dependent Pages** ke liye.

```typescript
// ✅ Isko ISR ke bajay dynamic render karo
export const dynamic = 'force-dynamic';
// Ya revalidate set karo
export const revalidate = 60; // 60 seconds

export default async function Home() {
  const res = await fetch('http://localhost:8000/api/products/featured?limit=4', {
    next: { revalidate: 60 }
  });
  const products = await res.json();
  
  return <div>{/* render */}</div>;
}
```

# 6. Docker compose run error - failed to set up container networking

## Error
> **Error response from daemon**: failed to set up container networking: driver failed programming external connectivity on endpoint d2c-mysql (95410553efb0842ac2c6024dd5ebd54683d802beb7473810ab744d4ac471cd79): failed to bind host port 0.0.0.0:3306/tcp: address already in use

## Root Cause Analysis
**Kya hua (What happened)**: Docker compose ne `d2c-mysql` container start karne ki koshish ki, lekin port `3306` (MySQL ka default port) already aapke machine par use ho raha tha.

```Code
❌ Docker trying to bind
  └─ Port: 0.0.0.0:3306/tcp
    └─ Status: "address already in use"
      └─ Reason: Koi aur process/container us port par chal raha hai
```

## Root Cause
**Ek hi wajah ho sakti hai**:

1. **Purana MySQL/MariaDB container still running hai** ← Most likely
2. Local machine par MySQL service already chal rahi hai
## Error Resolution :
Iss error ko resolve karne ke liye mujhe port `3306` ke alawa koi dushra port use karna padega jo already use me nahi ho jaise 3307 ya fir 3308 agar ye use me na ho toh

```yaml
# Port ko flexible banao
ports:
  - "${MYSQL_PORT:-3306}:3306"
  # ✅ Ab 3306 par conflict ho toh MYSQL_PORT env variable se alag port use hoga

# DATABASE_URL fix karo
DATABASE_URL: mysql+aiomysql://root:Password123!@mysql:3306/d2c_fashion?charset=utf8mb4
# ✅ localhost ke bajay 'mysql' (container name) use karo
```

```.env
MYSQL_PORT=3306
# Agar conflict ho toh 3307 ya 3308 kar do
```
Date - 15/06/2026

# 7. Docker Compose run error - dependency failed to start

## Error
> **dependency failed to start**: container d2c-mysql is unhealthy

## Root Cause 
**What Failed:** Container d2c-mysql unhealthy status mein tha → backend depends_on condition fail → entire stack fail

Ye error occur hone ke 2 sabse bade reasons hai:
1. Primary Issue: Volume Mount Path Bug ⭐⭐⭐
2. Secondary Issue: Healthcheck Test Command ⭐⭐

###  Primary Issue: Volume Mount Path Bug ⭐⭐⭐

```yaml
# ❌ WRONG:
- ./mysql-init:/docker-entrypoint-initdb.d/init.sql
```

- docker-entrypoint-initdb.d ek directory hai jisme saare .sql file run hote hai 
- Volumne mount me mistake hua kyuki ./mysql-init ek folder hai aur wo ek file ke saath mount hua 
- Jisse database initialization script run nahi hua


### Secondary Issue: Healthcheck Test Command ⭐⭐

```yaml
# Healthcheck command:
test: ["CMD","mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
```
- Healthcheck ki test command me .env variable apne values se replace nahi hote hai jo unka variable name hota hai wo as it is reh jaate hai
- jisse healthcheck test fail ho jaata hai aur fir wo unhealthy ho jaata hai
- fir backend ko dikkat ho jata hai kyuki wo mysql database pe depend karta hai
 

## Error Resolving

### 1. Volume Mount
- Always mount Directory to Directory that is recommended

```yaml
# ❌ WRONG (Before):
- ./mysql-init:/docker-entrypoint-initdb.d/init.sql

# ✅ CORRECT (After):
- ./mysql-init:/docker-entrypoint-initdb.d
```

### 2. Healthcheck Test Command

- Environment variable healthcheck test me work nahi karte 
- Ishiliye simple connectivity check karna chahiye jisme authentication ki need na ho

```yaml
# ❌ Wrong (Before) :
test: ["CMD","mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]

# ✅ CORRECT (After) :
test: ["CMD", "mariadb-admin", "ping", "-h", "127.0.0.1", "--silent"]
```

## Complete Cause Chain (Diagram):
```code
┌─────────────────────────────────────────────────────────┐
│ ROOT CAUSE: Wrong Volume Mount Path                     │
│ ./mysql-init:/docker-entrypoint-initdb.d/init.sql       │
└──────────────────┬──────────────────────────────────────┘
                   │
        ┌──────────▼──────────┐
        │ Mount Fails Silently│
        └──────────┬──────────┘
                   │
        ┌──────────▼────────────────────┐
        │ init.sql Not Found/Executed   │
        │ Database Creation Incomplete  │
        └──────────┬────────────────────┘
                   │
        ┌──────────▼─────────────────────┐
        │ MySQL Starts But Inconsistent  │
        │ State (Missing DB/Tables)      │
        └──────────┬─────────────────────┘
                   │
        ┌──────────▼──────────────────────────────┐
        │ SECONDARY: Healthcheck Test Fails       │
        │ Password var doesn't expand in healthcheck
        │ mysqladmin authentication error          │
        └──────────┬──────────────────────────────┘
                   │
        ┌──────────▼──────────────────────┐
        │ Container Marked UNHEALTHY      │
        └──────────┬──────────────────────┘
                   │
        ┌──────────▼──────────────────────┐
        │ Backend depends_on mysql:healthy│
        │ Condition NOT MET               │
        └──────────┬──────────────────────┘
                   │
        ┌──────────▼──────────────────────┐
        │ ❌ dependency failed to start:  │
        │    container d2c-mysql unhealthy
        │                                  │
        │ Frontend also fails              │
        └──────────────────────────────────┘
```

---
---

Date - 19/06/2026

# 8. CI/CD Pipeline broken becaue docker image build failed

## Error
### Backend docker image build error
ERROR: failed to build: invalid tag "ghcr.io/swapnil-lakra//fastapi-backend:latest": invalid reference format

### Frontend docker image build error
ERROR: failed to build: invalid tag "ghcr.io/swapnil-lakra//nextjs-frontend:latest": invalid reference format

## Root Cause
- Iss pipeline break hone ka main reason hai invalid tag docker image ko assign karna

- "ghcr.io/swapnil-lakra//nextjs-frontend:latest" ❌

- "ghcr.io/swapnil-lakra//fastapi-backend:latest" ❌

Aur invalid tag hone ka main reason hai - invalid github context
```yaml
# frontend tag ❌
env:
  GHCR_REGISTRY: ghcr.io/${{ github.repository_owner }}
  FRONTEND_IMAGE: ${{ github.respository_name }}/nextjs-frontend ❌

# backend tag ❌
env:
  GHCR_REGISTRY: ghcr.io/${{ github.repository_owner }}
  BACKEND_IMAGE: ${{ github.repository_name }}/fastapi-backend ❌
```

`github.repsitory_name` invalid hai kyuki yeh exist hi nahi karta hai

## Error Resolving

Iss broken ci/cd pipeline ko repair karne ke liye valid github context provide karna padega jisse ki valid tag assign ho docker image ko

```yaml

# frontend tag
env:
  GHCR_REGISTRY: ghcr.io/${{ github.repository_owner }}
  FRONTEND_IMAGE: ${{ github.respository_name }}/nextjs-frontend ❌
  FRONTEND_IMAGE: ${{ github.event.repository.name }}/nextjs-frontend ✅

# backend tag
env:
  GHCR_REGISTRY: ghcr.io/${{ github.repository_owner }}
  BACKEND_IMAGE: ${{ github.repository_name }}/fastapi-backend ❌
  BACKEND_IMAGE: ${{ github.event.repository.name }}/fastapi-backend ✅
```

---
---

# 9. CI/CD Pipeline broken during pushing docker image to GHCR (GitHub Container Registry)

## Error
denied: installation not allowed to Create organization package

## Root Cause
Error occure hone ka main reason tha ki kyuki organization level par package create karne ki permission (write access) nahi thi

## Error Resolving
Iss erro ko solve karne ke liye hume package create karne ki permission (write access) dena hoga github action ke ci/cd workflow me

```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    # Yeh lines add karna zaroori hai
➕  permissions:
      contents: read
      packages: write
```

---
---

Date - 23/06/2026

# 10. Nginx server routing misconfiguration

## Root Cause
Nginx config mein sirf ek catch-all `location /` block tha jo `try_files` karta tha aur fallback `/index.html` bhej deta tha. Isliye jab browser se `/api/...` requests aati thi, nginx unhe khud handle kar leta tha aur `/index.html` return kar deta tha (HTML file). Client ko JSON ki jagah HTML mila, to `productAPI` ne galat data diya aur `ProductList` crash ho gaya. Yahi wajah hai ki bug sirf Docker/nginx production build mein dikha, dev mein nahi — kyunki Vite dev server usually `/api` ko backend pe proxy kar deta hai.

```Dockerfile
RUN echo $'server { \n\
    listen 80; \n\
    root /usr/share/nginx/html; \n\
    index index.html; \n\
  📌 location / { \n\
        try_files $uri $uri/ /index.html; \n\
    } \n\
}' > /etc/nginx/conf.d/default.conf
```

- **Browser ka behaviour**: frontend code jab `fetch('/api/products/...')` call karta hai to request usi origin pe jaati hai jahan se static files aayi thi (yani nginx).

- **Nginx routing**: tumhara `location / { try_files $uri $uri/ /index.html; }` block **sabhi paths** ko match karta hai, including `/api/....` Prefix match hota hai. `try_files` pehle static file dhundhta hai — `/api/products/...` jaisi koi file nahi milti — to fallback `/index.html` return kar deta hai, status 200 OK aur content `text/html`.

- **Result**: Fetch ko HTML mila. Tumhara request code `response.json()` ko call karta hai; ya to wo fail ho gaya (null return) ya unexpected data mila. Isliye `productAPI` ne array nahi diya, `ProductList` ne `products.length` / `products.map` pe runtime error throw kiya.

- **Dev mein kyun chal raha tha**: Vite dev server typically backend ke liye proxy configure karta hai (jaise `vite.config.js` mein `/api` target set hota hai) ya dev backend alag origin pe hota hai. Production mein nginx ko explicitly batana padta hai ki `/api` ko proxy karna hai, nahi to wo static-server ki tarah behave karega.

## Error Resolving

Iss error ko solve karne ke liye mujhe API call ko backend path me proxy karna padega jisse ki jab bhi api call ho toh static files nahi milne pe wo fallback hoke `/index.html` return na kare

```Dockerfile
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
```

---
---

# 11. Environment variable is not detected

## root cause
mai blue-green environment ke liye 3 environment fies create kiya hun `.env` jisme saare common variables ke liye,`.env.blue` isme kewal blue environment ke saare variable ke liye,`.env.green` isme kewal green environment ke saare variables ke liye, toh docker compose `.env` file ke variables aur uske values ko easily read kar raha hai but `.env.blue` aur `.env.green` ke variables aur unke values ke saath 
aisa nahi kar paa raha hai

```Dockerfile
version: "3.8"

services:
  #MySQL Database
  mariadb-blue:
    env_file: 
    - .env.blue ❌
    - .env
    environment:
      MARIADB_DATABASE: ❌${MARIADB_BLUE_DATABASE}
    ports:
      - "❌ ${MARIADB_BLUE_PORT:-3306}:3306"  
  
  # FastAPI Backend
  backend-blue:
    env_file: 
    - .env.blue ❌
    - .env
    environment:
      DATABASE_URL: mysql+aiomysql://${MARIADB_USER}:${MARIADB_USER_PASSWORD}@mariadb-blue:3306/❌${MARIADB_BLUE_DATABASE}?charset=utf8mb4
      ENVIRONMENT: blue   
```

```sql
CREATE DATABASE IF NOT EXISTS `${MARIADB_DATABASE}`; ❌
USE `${MARIADB_DATABASE}`; ❌
``` 

maine iss error ko resolve karne ke liye command se .env.blue ke variable diya but wo bhi work nahi kiya ❌

```bash
docker compose \
--env-file .env \
--env-file .env.blue \
-f docker-compose.blue.yaml up -d
```

## Error resolution
Iss errro ko resolve karne ke liye mujhe ek hi `.env` file ko rakhna padega, aur jo environment variables `.env.blue` aur `.env.green` me hai unko in files se hata ke direct docker compose wala file me hi value ko dena hoga

```bash
# removing .env.blue and .env.green file
cd aap/fashion-d2c-app/
rm -r .env.blue .env.green
```

Docker compose file me ye changes karne padegenge iss error ko resolve karne ke liye
```dockerfile
version: "3.8"

services:
  #MySQL Database
  mariadb-blue:

  # Env file
❌  env_file: 
      - .env.blue 
      - .env

✅  env_file: .env

  #environment variable 
❌  environment:
      MARIADB_DATABASE: ${MARIADB_BLUE_DATABASE}

✅  environment:
      MARIADB_DATABASE: d2c-fashion-blue

  # ports
❌  ports:
      - "${MARIADB_BLUE_PORT:-3306}:3306" 

✅  ports:
      - "3306:3306" 

  # FastAPI Backend
  backend-blue:

  # Env file
❌  env_file: 
      - .env.blue 
      - .env

✅  env_file: .env

  # Environment variables
❌  environment:
      DATABASE_URL: mysql+aiomysql://${MARIADB_USER}:${MARIADB_USER_PASSWORD}@mariadb-blue:3306/${MARIADB_BLUE_DATABASE}?charset=utf8mb4

✅  environment:
      DATABASE_URL: mysql+aiomysql://${MARIADB_USER}:${MARIADB_USER_PASSWORD}@mariadb-blue:3306/d2c-fashion-blue?charset=utf8mb4
```

Aur mariadb database initialization occur ko resolve karne ke ye lines remove karne padenge
init.sql file se 
```sql
--- Remove these 2 lines 
CREATE DATABASE IF NOT EXISTS `${MARIADB_DATABASE}`; ❌
USE `${MARIADB_DATABASE}`; ❌
```

---
---

Date - 26/06/2026

# 12. Missing semicolon error in Nginx Configuration

## Error
> nginx: [emerg] directive "return" is not terminated by ";" in /etc/nginx/conf.d/default.conf:8

## Root Cause
Ye error occur hone ke main reason hai nginx configuration me `return {}` me semicolon missing tha

Aur dikkat ye bhi hai ki mai Nginx ke configuration ko frontend ke Dockerfile se frontend ke image jab build hogi wo ushi build time me hi configure hota tha

```Dockerfile
RUN echo $'server { \n\
    listen 80; \n\
    root /usr/share/nginx/html; \n\
    index index.html; \n\
\n\
    # ================= FRONTEND HEALTH CHECK ================= \n\
    location /health { \n\
        default_type application/json; \n\
        return 200 '{ \n\
            "status": "healthy", \n\
            "service": "frontend", \n\
            "environment": "blue", \n\          
            "timestamp": "'$(date +%s)'" \n\
        }'\n\ ❌
    }\n\
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
```

## Error Resolution

Mai iss Error ko resolve karne ke liye kewal `;` add nahi kiya balki mai nginx ke configuration ko naye folder structure me shift kiya hu aur Dockerfile ko bhi update kiya hun 

```Text
NEW FOLDER STRUCTURE
.
└── deploy-sheild/app/fashion-d2c-app/
    └── frontend/
        ├── nginx/
        │   └── default.conf.template
        ├── entrypoint.sh
        └── Dockerfile
```

Fir jo semicolon missing tha nginx configuration me mai usko `default.conf.template` ke add kiya hun

```default.conf.template
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    # React SPA
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Backend API
    location /api/ {
        proxy_pass http://${BACKEND_HOST}:${BACKEND_PORT};

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check
    location /health {   
        default_type application/json;
        return 200 '{"status":"healthy","service":"frontend","environment":"${ENVIRONMENT}"}'; ✅
    }

}
```

Fir iss `default.conf.template` file me jo bhi environment variables use hue hai usko unki value se substitute karna aur nginx server ko run karne ka command isme likha hun
```bash
#!/bin/sh

set -e

envsubst '${BACKEND_HOST} ${BACKEND_PORT} ${ENVIRONMENT}' \
< /etc/nginx/templates/default.conf.template \
> /etc/nginx/conf.d/default.conf

echo "Starting Nginx..."

exec nginx -g "daemon off;"
```

uske baad mai Frontend Dockerfile ko update kiya kyuki nginx ka folder structure change hua aur entrypoint file bhi add hu thi 

```Dockerfile
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

# Copy frontend build
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx template
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Default values (can be overridden by docker-compose env_file)
ENV BACKEND_HOST=backend-blue
ENV BACKEND_PORT=8000
ENV ENVIRONMENT=blue

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]
```

---
---

# 13. Chmod: Operation not permitted during frontend docker image build

## Error

```log
 > [stage-1 5/5] RUN chmod +x /entrypoint.sh:
0.153 chmod: /entrypoint.sh: Operation not permitted
------
Dockerfile:37
--------------------
  35 |     
  36 |     # Make entrypoint executable
  37 | >>> RUN chmod +x /entrypoint.sh
  38 |     
  39 |     # Default values (can be overridden by docker-compose env_file)
--------------------
ERROR: failed to build: failed to solve: process "/bin/sh -c chmod +x /entrypoint.sh" did not complete successfully: exit code: 1
```

## Root Cause
Error occur hone ka main reason hai ki mai nginx ka `nginxinc/nginx-unprivileged:alpine-slim` docker image use kar raha hun aur ye `root user se nahi` balki `non-root user (UID 101)` se chalti hai security reasons ki wajah se.

Flow kuch aisa hai:
```text
Base Image
      │
      ▼
nginxinc/nginx-unprivileged
      │
      ▼
Current User = nginx (non-root)
      │
      ▼
RUN chmod +x /entrypoint.sh
      │
      ▼
Permission Denied
```

Non-root user `/entrypoint.sh` ki permissions change nahi kar sakta, isliye:
> Operation not permitted

## Error Resolution
Iss error ko resolve karne ke liye mujhe iss `/entrypoint.sh` file ko executable file banane ke liye root user ka use karna padega fir ye task hone ke baad usko default user me shift karna padega jisse security maintain rahegi

```Dockerfile
FROM nginxinc/nginx-unprivileged:alpine-slim

# executing as root user until entrypoint.sh file becomes executable file
USER root ⬅️

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# changing to default user (non-root user UID 101) for security reasons
USER 101 ⬅️

ENV BACKEND_HOST=backend-blue
ENV BACKEND_PORT=8000
ENV ENVIRONMENT=blue

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]
```

---
---

# 14. Backend container becomes unhealthy while running on blue environment

## Root Cause
Backend container ka unhealthy hone ka main reason hai healthcheck test fail hona aur wo healthcheck test fail hone ka main reason hai `curl` install na hona container me

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/health"] ❌
```

## Error Resolution
Iss error ko resolve karne ke 2 tarike hai:
1. curl install karna padega 
2. python ka use karke healthcheck test karna kyuki python already installed hai

Mai 2nd tarika use karunga iss error ko resolve karne ke liye kyuki curl ko install karunga toh frontend ki images size halki si aur badh jaayegi iss accha toh ye hoga ki mai python se hi healthcheck test karlu kyuki wo phele se hi installed hai

```yaml
# using 'curl' to do healthcheck test, and which is not installed 
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/health"] ❌

# using 'python' to do healthcheck test, which is already installed
healthcheck:
  test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"] ✅️  

```

---
---

Date - 30/06/2026

# 15. Wrong shebang in scripting file 

## Error
> exec /entrypoint.sh: no such file or directory

## Root Cause
Error occur hone ka main reason hai wrong shebang ka use hona, kyuki mai nginx ka docker image me apline linux distribution use kar raha hu 

```bash
#!/bin/bash ❌
```

## Errro Resolution
Error ko resovle karne ke liye mujhe right shebang ha use karna padega kyuki different linux distribution me different shebangs use hote hai toh mujhe apline linux distribution ka shebang use karna padega

```bash
#!/bin/bash ❌

#!/bin/sh ✅
```

# 16. `envsubst` not found error because it haven't pre installed

## Error
> sh: envsubst: not found

> Error: failed to solve: process "/bin/sh -c envsubst ..." did not complete successfully: exit code: 127

## Root Cause
Error occur hone ka main reason hai ki envsubst ka installed na hona kyuki mai nginx ka docker image use kar raha hu jisme apline linux distribution hota hai aur usme phele se `envsubst` pre installed nahi hota hai 

## Error Resolution
Ye error ko resolve karne ek liye mujeh Dockerfile ke script me `envsubst` kon installation command add karna padega

```Dockerfile
RUN apk add --no-cache envsubst
```

---
---

# 17. Nginx `server` directive error

## Error
> 2026/06/25 19:46:37 [emerg] 1#1: "server" directive is not allowed here in /etc/nginx/conf.d/

> default.conf:3 nginx: [emerg] "server" directive is not allowed here in /etc/nginx/conf.d/default.conf:3
## Root Cause
Error occur hone ka main reason hai maine invalid nginx configuration ne wrong direction use kiya hua hai `server`, aisa ko directive nahi hota hai nginx me

```default.conf.template
server {
    listen 80;
    server _name _; ❌ 
```
## Error Resolution
Ye error ko resolve karne ke liye invalid nginx directive ka use karna padega - `server_name`

```default.conf.template
server {
    listen 80;

    server _name_; ❌ 

    server_name _; ✅
```

---
---

# 18. `host not found in upstream` (Nginx Start-up Error)

## Error
> Starting Nginx... 2026/06/25 20:13:26 [emerg] 1#1: host not found in upstream "backend_blue" in /etc/nginx/conf.d/default.conf:15 nginx: [emerg] host not found in upstream "backend_blue" in /etc/nginx/conf.d/default.conf:15

## Root Cause
Error occur hone ka main reason hai ye hai ki host name ko galat enter kar diya hu `backend_blue` jo exist hi nahi karta 

```docker-compose.blue.yaml
frontend-blue:
    environment:
      BACKEND_HOST: backend_blue ❌
```

## Error Resolution 
Yeh error ko resolve kar ne ke likhe mujhe sahi aur existing host ka name use karna padega

```docker-compose.blue.yaml
frontend-blue:
    environment:
      BACKEND_HOST: backend_blue ❌
      BACKEND_HOST: backend-blue ✅
```

---
---

# 19. Connection Refused Error (`ECONNREFUSED`)

## Error
> ConnectionRefusedError: [Errno 111] Connection refused

## Root Cause
Error occur hone ka main reason hai mai mai invalid backend server ka port use raha raha hu 

```docker-compose.green.yaml
ports:
 - 8001:8000
```

```text
Host Machine        Container
8001       ----->   8000
```

container ke andar backend server port `8000` par chal rha hai aur mai host machine ka port use kar rha hu `8001` backend server ka healthcheck test karne ke liye aur saath hi me frontend ke liye backend port bhi 

ye sab ishiliye hua kyuki mujhe host machine vs container port ke bech ka jo difference hota hai usme me confusion tha

```docker-compose.green.yaml
version: "3.8"

services:
  # FastAPI Backend
  backend-green:
    ports:
      - "8001:8000"
    healthcheck:
      test: [ "CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8001/health')" ] ❌
  
  #Next.js Frontend
  frontend-green:
    environment:
      BACKEND_PORT: 8001 ❌
    
```

## Error Resolution
Yeh error ko resovle karne ke liye mujhe host machine aur container ka port ka dhyan rakhte hue sahi ports ka use karna hai maine host machine ka port ko use kiya hua lekin mujhe container ka port ko use karna hai 

kyuki backend ha healthcheck test host machine me nahi hoga wo container ke andar hoga aur frontend ke backend port, host machine se nginx proxy nahi hoga wo container me run ho ke nginx porxy hoga

```docker-compose.green.yaml
version: "3.8"

# change the port 8001 -> 8000

services:
  # FastAPI Backend
  backend-green:
    ports:
      - "8001:8000"
    healthcheck:

      test: [ "CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8001/health')" ] ❌
      
      test: [ "CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" ] ✅
  
  #Next.js Frontend
  frontend-green:
    environment:
      BACKEND_PORT: 8001 ❌

      BACKEND_PORT: 8000 ✅
```

---
---