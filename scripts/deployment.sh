#!/bin/bash

BLUE_RUNNING=false
GREEN_RUNNING=false

DOCKER_COMPOSE_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/docker-compose.yaml"
BLUE_ENVIRONMENT_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/.env.blue"
GREEN_ENVIRONMENT_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/.env.green"
NGINX_CONF="/etc/nginx/nginx.conf"

CHANGE_TAG(){
  local OLD_TAG="$1"
  local NEW_TAG="$2"
  if [ -f "$BLUE_ENVIRONMENT_FILE_PATH" ]; then
      sed -i "s/IMAGE_TAG=${OLD_TAG}/IMAGE_TAG=${NEW_TAG}/g" "$BLUE_ENVIRONMENT_FILE_PATH" 
      echo "✅ Successfully changed tag from ${OLD_TAG} to ${NEW_TAG}"
  else
      echo "⚠️ Warning: Env file not found at $BLUE_ENVIRONMENT_FILE_PATH"
  fi
}

CHANGE_ENVIRONMENT() {
    local P1_PORT="$1"
    local P1_OLD_WT="$2"
    local P1_NEW_WT="$3"
    local P2_PORT="$4"
    local P2_OLD_WT="$5"
    local P2_NEW_WT="$6"

    # 1️⃣ Logic: Find Opposite Ports
    local P1_OPPOSITE_PORT
    local P2_OPPOSITE_PORT
    (( P1_OPPOSITE_PORT = (P1_PORT == 3000) ? 3001 : ((P1_PORT == 3001) ? 3000 : ((P1_PORT == 8000) ? 8001 : ((P1_PORT == 8001) ? 8000 : P1_PORT))) ))
    (( P2_OPPOSITE_PORT = (P2_PORT == 3000) ? 3001 : ((P2_PORT == 3001) ? 3000 : ((P2_PORT == 8000) ? 8001 : ((P2_PORT == 8001) ? 8000 : P2_PORT))) ))

    local P1_OPPOSITE_OLD_WT="$P1_NEW_WT"
    local P1_OPPOSITE_NEW_WT="$P1_OLD_WT"
    local P2_OPPOSITE_OLD_WT="$P2_NEW_WT"
    local P2_OPPOSITE_NEW_WT="$P2_OLD_WT"

    # 🎯 2️⃣ Dynamic Suffix Helper: Agar weight 0 hai toh use 'down;' search/replace karna hai
    local P1_OLD_SUFF; local P1_NEW_SUFF
    local P1_OPP_OLD_SUFF; local P1_OPP_NEW_SUFF
    local P2_OLD_SUFF; local P2_NEW_SUFF
    local P2_OPP_OLD_SUFF; local P2_OPP_NEW_SUFF

    [ "$P1_OLD_WT" -eq 0 ] && P1_OLD_SUFF="down" || P1_OLD_SUFF="weight=${P1_OLD_WT}"
    [ "$P1_NEW_WT" -eq 0 ] && P1_NEW_SUFF="down" || P1_NEW_SUFF="weight=${P1_NEW_WT}"

    [ "$P1_OPPOSITE_OLD_WT" -eq 0 ] && P1_OPP_OLD_SUFF="down" || P1_OPP_OLD_SUFF="weight=${P1_OPPOSITE_OLD_WT}"
    [ "$P1_OPPOSITE_NEW_WT" -eq 0 ] && P1_OPP_NEW_SUFF="down" || P1_OPP_NEW_SUFF="weight=${P1_OPPOSITE_NEW_WT}"

    [ "$P2_OLD_WT" -eq 0 ] && P2_OLD_SUFF="down" || P2_OLD_SUFF="weight=${P2_OLD_WT}"
    [ "$P2_NEW_WT" -eq 0 ] && P2_NEW_SUFF="down" || P2_NEW_SUFF="weight=${P2_NEW_WT}"

    [ "$P2_OPPOSITE_OLD_WT" -eq 0 ] && P2_OPP_OLD_SUFF="down" || P2_OPP_OLD_SUFF="weight=${P2_OPPOSITE_OLD_WT}"
    [ "$P2_OPPOSITE_NEW_WT" -eq 0 ] && P2_OPP_NEW_SUFF="down" || P2_OPP_NEW_SUFF="weight=${P2_OPPOSITE_NEW_WT}"

    # 🛠️ Safety check condition updated: Kyunki file me 'weight=' ki jagah 'down' ho sakta hai, hum sirf IP:PORT verify karenge
    if grep -q "127.0.0.1:${P1_PORT}" "$NGINX_CONF"; then
      local TARGET_ENV="unknown"
      if { [ "$P1_PORT" -eq 3000 ] || [ "$P1_PORT" -eq 8000 ]; } && [ "$P1_NEW_WT" -eq 10 ]; then
          TARGET_ENV="blue"
      elif { [ "$P1_PORT" -eq 3001 ] || [ "$P1_PORT" -eq 8001 ]; } && [ "$P1_NEW_WT" -eq 10 ]; then
          TARGET_ENV="green"
      fi
      
      # ⚠️ Execution Nginx Write using dynamic suffixes
      sudo sed -i \
        -e "s/127.0.0.1:${P1_PORT} ${P1_OLD_SUFF};/127.0.0.1:${P1_PORT} ${P1_NEW_SUFF};/g" \
        -e "s/127.0.0.1:${P1_OPPOSITE_PORT} ${P1_OPP_OLD_SUFF};/127.0.0.1:${P1_OPPOSITE_PORT} ${P1_OPP_NEW_SUFF};/g" \
        -e "s/127.0.0.1:${P2_PORT} ${P2_OLD_SUFF};/127.0.0.1:${P2_PORT} ${P2_NEW_SUFF};/g" \
        -e "s/127.0.0.1:${P2_OPPOSITE_PORT} ${P2_OPP_OLD_SUFF};/127.0.0.1:${P2_OPPOSITE_PORT} ${P2_OPP_NEW_SUFF};/g" \
        -e "s/\"active_environment\": \"[^\"]*\"/\"active_environment\": \"${TARGET_ENV}\"/g" \
        "$NGINX_CONF"
  
      # Syntax verification aur systemd reload (safest production method)
      if sudo nginx -t; then
          sudo systemctl reload nginx
          echo "🚀 Shifted traffic to ${TARGET_ENV^^} successfully!"
      else
          echo "🚨 Critical: Nginx syntax test failed after modification! Rolling back not triggered automatically."
          return 1
      fi
    else
      echo "⚠️ Safety Check Failed. No changes made to Nginx."
      return 1
    fi
}

RUN_DOCKER_COMPOSE_FILE(){
    local ENVIRONMENT_FILE_PATH="$1"
    local FILE_NAME=$(basename "$ENVIRONMENT_FILE_PATH")
    local ENVIRONMENT_NAME=""

    if [[ "$FILE_NAME" == *".blue"* ]]; then
        ENVIRONMENT_NAME="d2c-blue"
    elif [[ "$FILE_NAME" == *".green"* ]]; then
        ENVIRONMENT_NAME="d2c-green"
    else
        echo "🚨 Unknown env file path: $ENVIRONMENT_FILE_PATH"
        return 1
    fi
    
    echo "🚚 Pulling latest images for project: $ENVIRONMENT_NAME..."
    docker compose --env-file "$ENVIRONMENT_FILE_PATH" -f "$DOCKER_COMPOSE_FILE_PATH" -p "$ENVIRONMENT_NAME" pull

    echo "🚀 Deploying and recreating containers for: $ENVIRONMENT_NAME..."
    docker compose --env-file "$ENVIRONMENT_FILE_PATH" -f "$DOCKER_COMPOSE_FILE_PATH" -p "$ENVIRONMENT_NAME" up -d --force-recreate

    if [ $? -eq 0 ]; then
        echo "✅ Successfully deployed $ENVIRONMENT_NAME cluster!"
    else
        echo "❌ Failed to start containers for $ENVIRONMENT_NAME"
        return 1
    fi
}

echo "🔍 Checking Docker environment states..."

# ==========================================
# 🔹 1. BLUE ENVIRONMENT CHECK
# ==========================================
# Docker se check karenge ki kya 'd2c-blue' project ka koi container running hai
if [ $(docker ps --filter "label=com.docker.compose.project=d2c-blue" --filter "status=running" -q | wc -l) -gt 0 ]; then
    BLUE_RUNNING=true
else
    BLUE_RUNNING=false
fi

# Docker se check karenge ki kya 'd2c-green' project ka koi container running hai
if [ $(docker ps --filter "label=com.docker.compose.project=d2c-green" --filter "status=running" -q | wc -l) -gt 0 ]; then
    GREEN_RUNNING=true
else
    GREEN_RUNNING=false
fi



# Execution Matrix Logic
if [ "$BLUE_RUNNING" = true ] && [ "$GREEN_RUNNING" = true ]; then
  echo "🟡 Both Blue and Green environments are running!"
  CHANGE_TAG "latest" "previous"
  RUN_DOCKER_COMPOSE_FILE "$BLUE_ENVIRONMENT_FILE_PATH"
  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10"
  sleep 5
  RUN_DOCKER_COMPOSE_FILE "$GREEN_ENVIRONMENT_FILE_PATH"
  CHANGE_ENVIRONMENT "3001" "0" "10" "8001" "0" "10"

elif [ "$BLUE_RUNNING" = true ]; then
  echo "🔵 Blue Environment is currently ACTIVE"
  echo "🟢 Green Environment is starting..."
  CHANGE_TAG "latest" "previous"
  RUN_DOCKER_COMPOSE_FILE "$GREEN_ENVIRONMENT_FILE_PATH"
  CHANGE_ENVIRONMENT "3001" "0" "10" "8001" "0" "10"

elif [ "$GREEN_RUNNING" = true ]; then
  echo "🟢 Green Environment is currently ACTIVE"
  echo "🔵 Blue Environment is starting..."
  CHANGE_TAG "latest" "previous"
  RUN_DOCKER_COMPOSE_FILE "$BLUE_ENVIRONMENT_FILE_PATH"
  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10"

else
  echo "⚪ No environment is running. Booting Blue as Default..."
  CHANGE_TAG "previous" "latest"
  RUN_DOCKER_COMPOSE_FILE "$BLUE_ENVIRONMENT_FILE_PATH"
  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10" 
fi

echo "🎉 Everything processed successfully!"
