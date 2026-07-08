Date - 12/06/2026

## 1. d2c-fashion-app ko containerize karne ke liye mai frontend aur backed dono ke liye Dockerfile aur .dockerigore file bana ke likh li hai

Date - 14/06/2026

## 2. frontend ke liye docker image create kiya gaya hai.

```bash
cd app/fashion-d2c-app/frontend

docker build -t nextjs-frontend .
```
aur usko mai error aur uska resolution ko 4-RCA-&-Incident-Journal.md me point no. 1,3,4,5 me document kiya hua hai


## 3. backend ke liye docker image create kiya gaya hai.

```bash
cd app/fashion-d2c-app/backend

docker build -t fastapi-backend
```

aur usko mai error aur usko resolution ko 4-RCA-&-Incident-Journal.md me point no. 2 me document kiya hua hai

Date - 15/06/2026

## 4. d2c fashion application ke liye `docker compose` run kiya gaya hai

```bash
cd app/fashion-d2c-app

docker compose up -d
```

aur usko mai error aur usko resolution ko 4-RCA-&-Incident-Journal.md me point no. 6 aur 7 me document kiya hua hai

## 5. D2C fashion application ke frontend and backend ke docker images ko GHCR(GitHub Container Registry) me push kiya gaya hai

 Push karne se phele Docker Images ko tag karna padega GHCR registry URL structure me and strict naming convention ke saath 

```bash
# tagging frontend image
docker tag nextjs-frontend:latest ghcr.io/swapnil-lakra/deploysheild/nextjs-frontend:latest 

# tagging backend image
docker tag fastapi-backend:latest ghcr.io/swapnil-lakra/deploysheild/fastapi-backend:latest
```

d2c fashion application ke frontend and backend ka docker images ko GHCR(GitHub Container Registry) me push ho gaya 

```bash
# push frontend docker image to GHCR
docker push ghcr.io/swapnil-lakra/deploysheild/nextjs-frontend:latest

# push backend docker image to GHCR
docker push ghcr.io/swapnil-lakra/deploysheild/fastapi-backend:latest
```

Date - 18/06/2026

## 6. GitHub Actions se CI/CD Pipleline ke liye folders aur workflow file create kiya gaya hai

CI/CD Pipeline create karne ke liye mujhe workflow create karna padega jo ek YAML file hoti hai

```bash
# Creating folder for GitHub Actions Workflow folder
mkdir -p .github/workflows

# Creating workflow for frontend ci/cd pipeline
touch .github/workflows/frontend-ci-cd.yaml

# Creating workflow for backend ci/cd pipeline
touch .github/workflows/backend-ci-cd.yaml
```

Date - 20/06/2026

## 7. Creating blue and green environment

Blue aur Green environment create karne ke liye mujhe 2 folder create karna hoga "blue" and "green" aur un dono folders me docker-compose.yaml file hogi. Aur un docker-compose file me blue aur green ke hissab se application ki port define hogi

```bash
cd app/fashion-d2c-app

# creating blue and green folder 
mkdir blue green

# createting docker-compose.yaml file in blue and green folder
touch blue/docker-compose.yaml green/docker-compose.yaml 

# creating .env file for both blue and green environment
touch blue/.env green/.env
```

Date - 21/06/2026

## 8. Creating frontend using reactjs with tool vite 

React App ko create karne ka best took hai vite kyuki isse bahut hi fast create ho jaata hai 

```bash
npm create vite@latest frontend 

cd frontend && npm i

bun run dev
```

## 9. Running Docker compose blue and green environment 

Blue aur Green environment ke 2 separate docker-compose file hai toh usko run karne ke liye -f flag ka use karna padta hai 

```bash
cd app/fashion-d2c-app/
# running blue environment docker compose 
docker compose -f docker-compose.blue.yaml up -d

# running green environment docker compose
docker compose -f docker-compose.green.yaml up -d
```

jab mai blue ya green environment me application ko run kar rha hun toh mujhe error occur ho raha hai aur mai uss error ke baare me 4-RCA-&-Incident-Journal.md me point no. 11, 12, 13, 14 


Date - 26/06/2026

## 10. Installing wget for frontend container for healthcheck test

jab mai blue environment me backend container run hua toh unhealthy ho gaya because of healthcheck test fail ke reason se kyu mai `curl` use kar raha tha healthcheck test karne ke liye but wo container ke andar installed hi nahi tha ishiliye healthcheck test fail ho raha tha toh mai socha fir toh mai frontend ke liye bhi `wget` ka use kar raha hu healthcheck test ke liye aur wo bhi fail ho jaayega kyuki wo bhi installed nahi hai toh mujhe usko install karne ka script likhna padega fronend ke `Dockerfile` me

```Dockerfile
# adding this line to install 'wget' 
RUN apk add --no-cache wget 
```

---
--- 