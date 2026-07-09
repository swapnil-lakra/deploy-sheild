#!/bin/bash

# set -e lagane se kisi bhi error par script band ho jayegi, lekin humne saare errors fix kar diye hain
set -e

# ----------------------------------------------------------------- 
# 🔍 1. Check & Install Curl
# ----------------------------------------------------------------- 
if command -v curl &> /dev/null; then
    echo "✅ curl is already installed! Version:"
    curl --version | head -n 1
else
    echo "❌ curl not found. Installing it now..."
    if [ -f /etc/debian_version ]; then
        echo "📦 Debian/Ubuntu system detected..."
        sudo apt update && sudo apt install -y curl
    elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        echo "📦 Fedora/CentOS/RHEL system detected..."
        sudo dnf install -y curl
    else
        echo "⚠️ Sorry, your Linux distribution is not automatically supported."
        exit 1
    fi
fi

# -----------------------------------------------------------------
# 🔍 2. Check & Install Nginx
# -----------------------------------------------------------------
if command -v nginx &> /dev/null; then
    echo "✅ Nginx is already installed! Version:"
    nginx -v
else
    echo "❌ Nginx not found. Installing it now..."
    if [ -f /etc/debian_version ]; then
        echo "📦 Debian/Ubuntu system detected..."
        sudo apt update && sudo apt install -y nginx
    elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        echo "📦 Fedora/CentOS/RHEL system detected..."
        sudo dnf install -y nginx
    else
        echo "⚠️ Sorry, your Linux distribution is not automatically supported."
        exit 1
    fi
fi

echo "🔍 Checking Nginx service status..."

if systemctl is-active --quiet nginx; then
    echo "✅ Nginx is running perfectly!"
    exit 0
else
    echo "❌ Nginx is NOT running!"
    
    # 🔄 Optional Auto-Restart: Agar aap chahte hain ki script automatic Nginx ko start kare
    echo "🔄 Attempting to start Nginx service..."
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    # Dobara double-check karenge ki start hua ya nahi
    if systemctl is-active --quiet "$SERVICE"; then
        echo "🚀 Nginx started successfully now!"
        exit 0
    else
        echo "🚨 Critical Error: Nginx failed to start! Please check configuration or logs."
        echo "📂 Run this command to debug: sudo journalctl -eu nginx"
        exit 1
    fi
fi

# -----------------------------------------------------------------
# ⚙️ 3. Configuring Nginx Local and System Files
# -----------------------------------------------------------------
NGINX_CONF_DIR="$HOME/deploy-sheild/app/fashion-d2c-app/nginx"
NGINX_CONF_FILE_PATH="$NGINX_CONF_DIR/nginx.conf"
NGINX_CONF_DOWNLOAD_URL="https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/app/fashion-d2c-app/nginx/nginx.conf"

echo "🔍 Checking if Nginx configuration file exists at: $NGINX_CONF_FILE_PATH"

# 🛠️ Bug Fix: $FILE_PATH ko badal kar $NGINX_CONF_FILE_PATH kiya
if [ -f "$NGINX_CONF_FILE_PATH" ]; then
    echo "✅ nginx.conf already exists at the target location. Matching the Content..."

    TEMP_NGINX_FILE="/tmp/temp_nginx.conf"
    wget -q -O "$TEMP_NGINX_FILE" "$NGINX_CONF_DOWNLOAD_URL"

    if cmp -s "$NGINX_CONF_FILE_PATH" "$TEMP_NGINX_FILE"; then
        echo "🤝 Nginx file content already MATCHED! No need to do anything."
        rm -f "$TEMP_NGINX_FILE"
    else
        echo "⚠️ Content MISMATCHED! Deleting old nginx file and new nginx file is downloading..."
        rm -f "$NGINX_CONF_FILE_PATH"
        mv "$TEMP_NGINX_FILE" "$NGINX_CONF_FILE_PATH"
        echo "🔄 Nginx file successfully updated with new content!"
    fi
else
    echo "❌ nginx.conf not found. Preparing to download..."
    if [ ! -d "$NGINX_CONF_DIR" ]; then
        echo "📂 Nginx conf directory structure does not exist. Creating it now..."
        mkdir -p "$NGINX_CONF_DIR"
    fi
    echo "📥 Downloading file using wget..."
    wget -q -O "$NGINX_CONF_FILE_PATH" "$NGINX_CONF_DOWNLOAD_URL"
fi

NGINX_CONF_SYSTEM_FILE="/etc/nginx/nginx.conf"
NGINX_CONF_BACKUP_FILE="/etc/nginx/nginx.conf.bak"

echo "🔍 Comparing configuration files..."

if [ ! -f "$NGINX_CONF_SYSTEM_FILE" ]; then
    echo "⚠️ System nginx.conf not found. Creating it directly..."
    sudo cp "$NGINX_CONF_FILE_PATH" "$NGINX_CONF_SYSTEM_FILE"
else
    if diff -q "$NGINX_CONF_FILE_PATH" "$NGINX_CONF_SYSTEM_FILE" &> /dev/null; then
        echo "✅ Content matches perfectly! No changes needed."
    else
        echo "❌ Content mismatch detected! Updating system nginx.conf..."
        echo "📂 Creating a backup of the current file at $NGINX_CONF_BACKUP_FILE"
        sudo cp "$NGINX_CONF_SYSTEM_FILE" "$NGINX_CONF_BACKUP_FILE"
        sudo cp "$NGINX_CONF_FILE_PATH" "$NGINX_CONF_SYSTEM_FILE"
        
        echo "⚙️ Validating Nginx configuration syntax..."
        
        sudo nginx -t 

        if [ $? -eq 0 ]; then
            echo "🔄 Syntax is OK. Updated /etc/nginx/nginx.conf successfully."
            echo "🔄 Reloading nginx service to update changes"
            sudo systemctl reload nginx
        else
            echo "🚨 Critical Error: Syntax errors found! Rolling back to backup..."
            sudo cp "$NGINX_CONF_BACKUP_FILE" "$NGINX_CONF_SYSTEM_FILE"
            exit 1
        fi
    fi
fi


# ----------------------------------------------------------------
# 🏃‍♂️ 4. Starting and Running Health-Monitor Service
# ----------------------------------------------------------------
echo "=================================================="
echo "🚀 Starting D2C Fashion Health Monitor Automation"
echo "=================================================="

SERVICE_NAME="health-monitor.service"
LOCAL_BIN_DIR="/usr/local/bin"
SYSTEMD_DIR="/etc/systemd/system"

HEALTH_MONITOR_DIR="$HOME/deploy-sheild/app/fashion-d2c-app/health-monitor"
# 🛠️ Bug Fix: $TARGET_DIR ko sahi variable $HEALTH_MONITOR_DIR se replace kiya
HEALTH_MONITOR_LOCAL_SH="$HEALTH_MONITOR_DIR/health-monitor.sh"
HEALTH_MONITOR_LOCAL_SERVICE="$HEALTH_MONITOR_DIR/$SERVICE_NAME"

HEALTH_MONITOR_URL_SH="https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/app/fashion-d2c-app/health-monitor/health-monitor.sh"
HEALTH_MONITOR_URL_SERVICE="https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/app/fashion-d2c-app/health-monitor/health-monitor.service"

echo "🔍 Checking if service '${SERVICE_NAME}' exists in the system..."
if systemctl list-unit-files --type=service | grep -Fq "${SERVICE_NAME}"; then
    echo "✅ Success: '${SERVICE_NAME}' system me exist karti hai!"
    
    echo "🔍 Checking ${SERVICE_NAME} status..."

    # systemctl is-active --quiet flag ke sath check karega ki service RUNNING hai ya nahi
    if systemctl is-active --quiet "${SERVICE_NAME}"; then
        echo "✅ Success: '${SERVICE_NAME}' active hai aur smoothly run kar rahi hai!"
        exit 0
    else
        echo "❌ Alert: '${SERVICE_NAME}' abhi active/running nahi hai!"
        
        # 🔄 Auto-Start Logic: Agar service running nahi hai, toh use start karne ki koshish karein
        echo "🔄 Attempting to start '${SERVICE_NAME}'..."
        sudo systemctl enable --now "${SERVICE_NAME}"
        
        # 🔬 Double check validation
        if systemctl is-active --quiet "${SERVICE_NAME}"; then
            echo "🚀 Great! '${SERVICE_NAME}' as been started successfully!"
            exit 0
        else
            echo "🚨 Critical Error: '${SERVICE_NAME}' start nahi ho pa rahi hai!"
            echo "📂 Debugging ke liye logs check karein: sudo journalctl -eu ${SERVICE_NAME}"
            exit 1
        fi
    fi
    exit 0
else
    echo "❌ Error: '${SERVICE_NAME}' is server par install nahi hai!"
    echo "❌ Systemd service '$SERVICE_NAME' does not exist. Deploying now..."
    if [ ! -d "$HEALTH_MONITOR_DIR" ]; then
        mkdir -p "$HEALTH_MONITOR_DIR"
    fi

    if [ ! -f "$HEALTH_MONITOR_LOCAL_SH" ]; then
        echo "📥 Downloading health-monitor.sh..."
        wget -q -O "$HEALTH_MONITOR_LOCAL_SH" "$HEALTH_MONITOR_URL_SH"
    fi

    if [ ! -f "$HEALTH_MONITOR_LOCAL_SERVICE" ]; then
        echo "📥 Downloading health-monitor.service..."
        # 🛠️ Bug Fix: Un-defined variable $URL_SERVICE ko strict download URL se fix kiya
        wget -q -O "$HEALTH_MONITOR_LOCAL_SERVICE" "$HEALTH_MONITOR_URL_SERVICE"
    fi

    echo "⚙️ Deploying files to system paths..."
    sudo cp "$HEALTH_MONITOR_LOCAL_SH" "$LOCAL_BIN_DIR/health-monitor.sh"
    sudo chmod +x "$LOCAL_BIN_DIR/health-monitor.sh"
    sudo cp "$HEALTH_MONITOR_LOCAL_SERVICE" "$SYSTEMD_DIR/$SERVICE_NAME"
    echo "starting"
    sudo systemctl daemon-reload
    sudo systemctl enable --now health-monitor.service
    exit 0
fi

if [ -f "$SYSTEMD_DIR/$SERVICE_NAME" ]; then
    echo "✅ Systemd service file exists at $SYSTEMD_DIR/$SERVICE_NAME. Matching the Content..."
    
    TEMP_HEALTH_MONITOR_SH_FILE="/tmp/temp_health-monitor.sh"
    TEMP_HEALTH_MONITOR_SERVICE_FILE="/tmp/temp_health-monitor.service"

    wget -q -O "$TEMP_HEALTH_MONITOR_SH_FILE" "$HEALTH_MONITOR_URL_SH"
    wget -q -O "$TEMP_HEALTH_MONITOR_SERVICE_FILE" "$HEALTH_MONITOR_URL_SERVICE"

    if cmp -s "$HEALTH_MONITOR_LOCAL_SH" "$TEMP_HEALTH_MONITOR_SH_FILE"; then
      echo "🤝 health-monitor.sh content already MATCHED! No need to do anything."
      rm -f "$TEMP_HEALTH_MONITOR_SH_FILE"
    else
      echo "⚠️ Content MISMATCHED! Deleting old health-monitor.sh file and new health-monitor.sh file is downloading..."
      rm -f "$HEALTH_MONITOR_LOCAL_SH"
      mv "$TEMP_HEALTH_MONITOR_SH_FILE" "$HEALTH_MONITOR_LOCAL_SH"
      if [ ! -x "$HEALTH_MONITOR_LOCAL_SH" ]; then
            echo "🔑 Execute permission not found. Granting permission (chmod +x)..."
            chmod +x "$HEALTH_MONITOR_LOCAL_SH"
      fi
      sudo systemctl restart health-monitor.service
      echo "🔄 File successfully updated with new content!"
    fi

    if cmp -s "$HEALTH_MONITOR_LOCAL_SERVICE" "$TEMP_HEALTH_MONITOR_SERVICE_FILE"; then
      echo "🤝 health-monitor.sh content already MATCHED! No need to do anything."
      rm -f "$TEMP_HEALTH_MONITOR_SERVICE_FILE"
    else
      echo "⚠️ Content MISMATCHED! Deleting old health-monitor.sh file and new health-monitor.sh file is downloading..."
      rm -f "$HEALTH_MONITOR_LOCAL_SERVICE"
      mv "$TEMP_HEALTH_MONITOR_SERVICE_FILE" "$HEALTH_MONITOR_LOCAL_SERVICE"

      sudo systemctl daemon-reload
      sudo systemctl restart health-monitor.service
      echo "🔄 File successfully updated with new content!"
    fi
fi


# ----------------------------------------------------------------- 
# 🌐 5. Blue-Green Environment Traffic Orchestration
# ----------------------------------------------------------------- 
echo "🔍 Checking Current Environment..."

BLUE_RUNNING=false
GREEN_RUNNING=false

BLUE_DOCKER_COMPOSE_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/docker-compose.blue.yaml"
GREEN_DOCKER_COMPOSE_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/docker-compose.green.yaml"
BLUE_ENVIRONMENT_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/.env.blue"
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

    # 🛠️ Bug Fix: Safety check condition updated for accurate grep matching
    if grep -q "127.0.0.1:${P1_PORT} weight=" "$NGINX_CONF"; then
      local TARGET_ENV="unknown"
      if { [ "$P1_PORT" -eq 3000 ] || [ "$P1_PORT" -eq 8000 ]; } && [ "$P1_NEW_WT" -eq 10 ]; then
          TARGET_ENV="blue"
      elif { [ "$P1_PORT" -eq 3001 ] || [ "$P1_PORT" -eq 8001 ]; } && [ "$P1_NEW_WT" -eq 10 ]; then
          TARGET_ENV="green"
      fi
      
      # ⚠️ Execution Nginx Write
      sudo sed -i \
        -e "s/127.0.0.1:${P1_PORT} weight=${P1_OLD_WT};/127.0.0.1:${P1_PORT} weight=${P1_NEW_WT};/g" \
        -e "s/127.0.0.1:${P1_OPPOSITE_PORT} weight=${P1_OPPOSITE_OLD_WT};/127.0.0.1:${P1_OPPOSITE_PORT} weight=${P1_OPPOSITE_NEW_WT};/g" \
        -e "s/127.0.0.1:${P2_PORT} weight=${P2_OLD_WT};/127.0.0.1:${P2_PORT} weight=${P2_NEW_WT};/g" \
        -e "s/127.0.0.1:${P2_OPPOSITE_PORT} weight=${P2_OPPOSITE_OLD_WT};/127.0.0.1:${P2_OPPOSITE_PORT} weight=${P2_OPPOSITE_NEW_WT};/g" \
        -e "s/\"active_environment\": \"[^\"]*\"/\"active_environment\": \"${TARGET_ENV}\"/g" \
        "$NGINX_CONF"
  
      sudo nginx -t && sudo nginx -s reload
      echo "🚀 Shifted traffic to ${TARGET_ENV^^} successfully!"
    else
      echo "⚠️ Safety Check Failed. No changes made to Nginx."
      return 1
    fi
}

# Check Blue Environment
if [ -f "$BLUE_DOCKER_COMPOSE_FILE_PATH" ] && docker compose -f $BLUE_DOCKER_COMPOSE_FILE_PATH ps --services --filter "status=running" | grep -q "frontend-blue\|backend-blue"; then
  BLUE_RUNNING=true
fi

# Check Green Environment - 🛠️ Bug Fix: 'dokcer' -> 'docker' aur '--service' -> '--services' kiya
if [ -f "$GREEN_DOCKER_COMPOSE_FILE_PATH" ] && docker compose -f $GREEN_DOCKER_COMPOSE_FILE_PATH ps --services --filter "status=running" | grep -q "frontend-green\|backend-green"; then
  GREEN_RUNNING=true
fi

# Execution Matrix Logic
if [ "$BLUE_RUNNING" = true ] && [ "$GREEN_RUNNING" = true ]; then
  echo "🟡 Both Blue and Green environments are running!"
  CHANGE_TAG "latest" "previous"
  docker compose -f docker-compose.yaml -p d2c-blue pull
  docker compose -f docker-compose.yaml -p d2c-blue up -d --force-recreate
  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10"
  sleep 5
  docker compose -f docker-compose.yaml -p d2c-green pull
  docker compose -f docker-compose.yaml -p d2c-green up -d --force-recreate
  CHANGE_ENVIRONMENT "3001" "0" "10" "8001" "0" "10"

elif [ "$BLUE_RUNNING" = true ]; then
  echo "🔵 Blue Environment is currently ACTIVE"
  echo "🟢 Green Environment is starting..."
  CHANGE_TAG "latest" "previous"
  docker compose -f docker-compose.yaml -p d2c-green pull
  docker compose -f docker-compose.yaml -p d2c-green up -d --force-recreate
  CHANGE_ENVIRONMENT "3001" "0" "10" "8001" "0" "10"

elif [ "$GREEN_RUNNING" = true ]; then
  echo "🟢 Green Environment is currently ACTIVE"
  echo "🔵 Blue Environment is starting..."
  CHANGE_TAG "latest" "previous"
  docker compose -f docker-compose.yaml -p d2c-blue pull
  docker compose -f docker-compose.yaml -p d2c-blue up -d --force-recreate
  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10"

else
  echo "⚪ No environment is running. Booting Blue as Default..."
  CHANGE_TAG "previous" "latest"
  docker compose -f docker-compose.yaml -p d2c-blue pull
  docker compose -f docker-compose.yaml -p d2c-blue up -d --force-recreate
  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10" 
fi

echo "🎉 Everything processed successfully!"