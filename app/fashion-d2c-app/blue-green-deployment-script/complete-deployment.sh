#!/bin/bash

set -e

# ----------------------------------------------------------------- 

# 🔍 Check if curl is already installed
if command -v curl &> /dev/null; then
    echo "✅ curl is already installed! Version:"
    curl --version | head -n 1
else
    echo "❌ curl not found. Installing it now..."
    
    # 🐧 Detect OS type to use the correct package manager
    if [ -f /etc/debian_version ]; then
        echo "📦 Debian/Ubuntu system detected..."
        sudo apt update && sudo apt install -y curl
        
    elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        echo "📦 Fedora/CentOS/RHEL system detected..."
        sudo dnf install -y curl
        
    else
        echo "⚠️ Sorry, your Linux distribution is not automatically supported. Please install curl manually."
        exit 1
    fi

    # 🔬 Final verification (Double check)
    if command -v curl &> /dev/null; then
        echo "🚀 curl has been successfully installed!"
    else
        echo "🚨 Something went wrong. curl installation failed."
    fi
fi

# -----------------------------------------------------------------

# 🔍 Check if Nginx is already installed
if command -v nginx &> /dev/null; then
    echo "✅ Nginx is already installed! Version:"
    nginx -v
else
    echo "❌ Nginx not found. Installing it now..."
    
    # 🐧 Detect OS type to use the correct package manager
    if [ -f /etc/debian_version ]; then
        echo "📦 Debian/Ubuntu system detected..."
        sudo apt update && sudo apt install -y nginx
        
    elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        echo "📦 Fedora/CentOS/RHEL system detected..."
        sudo dnf install -y nginx
        
    else
        echo "⚠️ Sorry, your Linux distribution is not automatically supported. Please install Nginx manually."
        exit 1
    fi

    # 🔬 Final verification (Double check)
    if command -v nginx &> /dev/null; then
        echo "🚀 Nginx has been successfully installed and started!"
    else
        echo "🚨 Something went wrong. Nginx installation failed."
    fi
fi


# -----------------------------------------------------------------
# Configuring Nginx

NGINX_CONF_DIR="$HOME/deploy-sheild/app/fashion-d2c-app/nginx/"
NGINX_CONF_FILE_PATH="$NGINX_CONF_DIR/nginx.conf"
NGINX_CONF_DOWNLOAD_URL="https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/app/fashion-d2c-app/nginx/nginx.conf"

echo "🔍 Checking if Nginx configuration file exists at: $NGINX_CONF_FILE_PATH"

# Check if the nginx.conf file already exists

if [ -f "$FILE_PATH" ]; then
    echo "✅ nginx.conf already exists at the target location. No action needed."
else
    echo "❌ nginx.conf not found. Preparing to download..."
  
    # Create the directory tree if it does not exist
    if [ ! -d "$NGINX_CONF_DIR" ]; then
        echo "📂 Nginx conf directory structure does not exist. Creating it now..."
        mkdir -p "$NGINX_CONF_DIR"
    fi

    # Use wget to download the file and rename it as nginx.conf
    echo "📥 Downloading file using wget..."
    wget -c "$NGINX_CONF_DOWNLOAD_URL" -O "$NGINX_CONF_FILE_PATH"

    # Final verification: Verify if the file exists after download
    if [ -f "$NGINX_CONF_FILE_PATH" ]; then
        echo "🚀 Success! nginx.conf has been successfully downloaded and verified."
    else
        echo "🚨 Error: Download failed or file could not be saved!"
        exit 1
    fi
fi

NGINX_CONF_DOWNLOADED_FILE="$HOME/deploy-sheild/app/fashion-d2c-app/nginx/nginx.conf"
NGINX_CONF_SYSTEM_FILE="/etc/nginx/nginx.conf"
NGINX_CONF_BACKUP_FILE="/etc/nginx/nginx.conf.bak"

echo "🔍 Comparing configuration files..."
# Check if downloaded file actually exists first
if [ ! -f "$NGINX_CONF_DOWNLOADED_FILE" ]; then
    echo "🚨 Error: Downloaded file not found at $NGINX_CONF_DOWNLOADED_FILE"
    exit 1
fi

# Check if system nginx.conf exists
if [ ! -f "$NGINX_CONF_SYSTEM_FILE" ]; then
    echo "⚠️ System nginx.conf not found at $NGINX_CONF_SYSTEM_FILE. Creating it directly..."
    sudo cp "$NGINX_CONF_DOWNLOADED_FILE" "$NGINX_CONF_SYSTEM_FILE"
    echo "🚀 File copied successfully!"
    exit 0
fi

# Compare the content of both files using diff
if diff -q "$NGINX_CONF_DOWNLOADED_FILE" "$NGINX_CONF_SYSTEM_FILE" &> /dev/null; then
    echo "✅ Content matches perfectly! No changes needed."
else
    echo "❌ Content mismatch detected! Updating system nginx.conf..."

    echo "Stopping nginx service"
    sudo systemctl stop nginx

    # Take a backup of the current system file just in case (Best Practice)
    echo "📂 Creating a backup of the current file at $NGINX_CONF_BACKUP_FILE"
    sudo cp "$NGINX_CONF_SYSTEM_FILE" "$NGINX_CONF_BACKUP_FILE"

    # Copy the new content to /etc/nginx/nginx.conf
    sudo cp "$NGINX_CONF_DOWNLOADED_FILE" "$NGINX_CONF_SYSTEM_FILE"

    # Validate Nginx configuration syntax before reloading
    echo "⚙️ Validating Nginx configuration syntax..."
    if sudo nginx -t &> /dev/null; then
        echo "🔄 Syntax is OK."
        echo "🚀 Success! /etc/nginx/nginx.conf has been updated."
    else
        echo "🚨 Critical Error: New nginx.conf has syntax errors! Rolling back to backup..."
        sudo cp "$NGINX_CONF_BACKUP_FILE" "$NGINX_CONF_SYSTEM_FILE"
        exit 1
    fi
fi

# starting and enabling nginx systemd
sudo systemctl start nginx
sudo systemctl enable nginx

# ----------------------------------------------------------------
# Starting and running health-monitor service
SERVICE_NAME="health-monitor.service"
LOCAL_BIN_DIR="/usr/local/bin"
SYSTEMD_DIR="/etc/systemd/system"

HEALTH_MONITOR_DIR="$HOME/deploy-sheild/app/fashion-d2c-app/health-monitor"
HEALTH_MONITOR_LOCAL_SH="$TARGET_DIR/health-monitor.sh"
HEALTH_MONITOR_LOCAL_SERVICE="$TARGET_DIR/health-monitor.service"

HEALTH_MONITOR_URL_SH="https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/app/fashion-d2c-app/health-monitor/health-monitor.sh"
HEALTH_MONITOR_URL_SERVICE="https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/app/fashion-d2c-app/health-monitor/health-monitor.service"

echo "=================================================="
echo "🚀 Starting D2C Fashion Health Monitor Automation"
echo "=================================================="

# Check if the systemd service file already exists in the system directory

if [ -f "$SYSTEMD_DIR/$SERVICE_NAME" ]; then
    echo "✅ Systemd service file exists at $SYSTEMD_DIR/$SERVICE_NAME"
    
    # Check if the service is actively running
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "🏃‍♂️ Service '$SERVICE_NAME' is already running. No further action needed."
    else
        echo "⚠️ Service '$SERVICE_NAME' exists but is NOT running. Starting and enabling now..."
        sudo systemctl start "$SERVICE_NAME"
        sudo systemctl enable "$SERVICE_NAME"
        echo "🚀 Service started and enabled successfully!"
    fi
else
    echo "❌ Systemd service '$SERVICE_NAME' does not exist in the system."
    echo "📂 Checking local backup directory: $HEALTH_MONITOR_DIR"

    # Create target directory structure if it doesn't exist
    if [ ! -d "$HEALTH_MONITOR_DIR" ]; then
        echo "📁 Local directory structure missing. Creating it now..."
        mkdir -p "$HEALTH_MONITOR_DIR"
    fi

    # Check and Download health-monitor.sh if missing
    if [ ! -f "$HEALTH_MONITOR_LOCAL_SH" ]; then
        echo "📥 health-monitor.sh not found locally. Downloading..."
        wget -c "$HEALTH_MONITOR_URL_SH" -O "$HEALTH_MONITOR_LOCAL_SH"
        
        # Verify download
        if [ -f "$HEALTH_MONITOR_LOCAL_SH" ]; then
            echo "✅ health-monitor.sh downloaded successfully."
        else
            echo "🚨 Error: Failed to download health-monitor.sh!"
            exit 1
        fi
    else
        echo "✅ health-monitor.sh already exists locally."
    fi

    # Check and Download health-monitor.service if missing
    if [ ! -f "$HEALTH_MONITOR_LOCAL_SERVICE" ]; then
        echo "📥 health-monitor.service not found locally. Downloading..."
        wget -c "$URL_SERVICE" -O "$HEALTH_MONITOR_LOCAL_SERVICE"
        
        # Verify download
        if [ -f "$HEALTH_MONITOR_LOCAL_SERVICE" ]; then
            echo "✅ health-monitor.service downloaded successfully."
        else
            echo "🚨 Error: Failed to download health-monitor.service!"
            exit 1
        fi
    else
        echo "✅ health-monitor.service already exists locally."
    fi

    # 6. Copy files to production destinations and set permissions
    echo "⚙️ Deploying files to system paths..."
    
    # Copy script, rename it, and grant execute permission
    sudo cp "$HEALTH_MONITOR_LOCAL_SH" "$LOCAL_BIN_DIR/health-monitor.sh"
    sudo chmod +x "$LOCAL_BIN_DIR/health-monitor.sh"
    echo "📌 Script copied to $LOCAL_BIN_DIR and execution rights granted."

    # Copy systemd service unit file
    sudo cp "$HEALTH_MONITOR_LOCAL_SERVICE" "$SYSTEMD_DIR/$SERVICE_NAME"
    echo "📌 Service file copied to $SYSTEMD_DIR."

    # 7. Reload systemd daemon, start and enable the service
    echo "🔄 Reloading systemd daemon and starting the service..."
    sudo systemctl daemon-reload
    sudo systemctl start "$SERVICE_NAME"
    sudo systemctl enable "$SERVICE_NAME"

    # Final Double Check
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "🎉 Success! Health Monitor service is now fully active and enabled on boot!"
    else
        echo "🚨 Critical: Service was deployed but failed to start. Check systemctl status $SERVICE_NAME"
        exit 1
    fi
fi
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

  if grep -q "IMAGE_TAG=${OLD_TAG}" "$BLUE_ENVIRONMENT_FILE_PATH"; then
      sed -i "s/IMAGE_TAG=${OLD_TAG}/IMAGE_TAG=${NEW_TAG}/g" "$BLUE_ENVIRONMENT_FILE_PATH" 
      echo "✅ Successfully changed tag from ${OLD_TAG} to ${NEW_TAG}"
  else
      echo "⚠️ Warning: IMAGE_TAG=${OLD_TAG} not found in file!"
  fi
}

CHANGE_ENVIRONMENT() {
    local P1_PORT="$1"
    local P1_OLD_WT="$2"
    local P1_NEW_WT="$3"
    
    local P2_PORT="$4"
    local P2_OLD_WT="$5"
    local P2_NEW_WT="$6"

    if grep -q "127.0.0.1:${P1_PORT} weight=${P1_OLD_WT};" "$NGINX_CONF" && \
       grep -q "127.0.0.1:${P1_OPPOSITE_PORT} weight=${P1_OPPOSITE_OLD_WT};" "$NGINX_CONF" && \
       grep -q "127.0.0.1:${P2_PORT} weight=${P2_OLD_WT};" "$NGINX_CONF" && \
       grep -q "127.0.0.1:${P2_OPPOSITE_PORT} weight=${P2_OPPOSITE_OLD_WT};" "$NGINX_CONF"; then

      # 1️⃣ Logic: Find Opposite Ports (Universal Symmetric Matrix)
      local P1_OPPOSITE_PORT
      local P2_OPPOSITE_PORT
  
      (( P1_OPPOSITE_PORT = (P1_PORT == 3000) ? 3001 : ((P1_PORT == 3001) ? 3000 : ((P1_PORT == 8000) ? 8001 : ((P1_PORT == 8001) ? 8000 : P1_PORT))) ))
      (( P2_OPPOSITE_PORT = (P2_PORT == 3000) ? 3001 : ((P2_PORT == 3001) ? 3000 : ((P2_PORT == 8000) ? 8001 : ((P2_PORT == 8001) ? 8000 : P2_PORT))) ))
  
      # 2️⃣ Logic: Opposite Weights
      local P1_OPPOSITE_OLD_WT="$P1_NEW_WT"
      local P1_OPPOSITE_NEW_WT="$P1_OLD_WT"
      
      local P2_OPPOSITE_OLD_WT="$P2_NEW_WT"
      local P2_OPPOSITE_NEW_WT="$P2_OLD_WT"
  
      # 3️⃣ Logic: Environment Detection (Bulletproof Version)
      local TARGET_ENV="unknown"
      
      if { [ "$P1_PORT" -eq 3000 ] || [ "$P1_PORT" -eq 8000 ]; } && [ "$P1_NEW_WT" -eq 10 ]; then
          TARGET_ENV="blue"
      elif { [ "$P2_PORT" -eq 3000 ] || [ "$P2_PORT" -eq 8000 ]; } && [ "$P2_NEW_WT" -eq 10 ]; then
          TARGET_ENV="blue"
      elif { [ "$P1_PORT" -eq 3001 ] || [ "$P1_PORT" -eq 8001 ]; } && [ "$P1_NEW_WT" -eq 0 ]; then
          TARGET_ENV="blue"
      elif { [ "$P2_PORT" -eq 3001 ] || [ "$P2_PORT" -eq 8001 ]; } && [ "$P2_NEW_WT" -eq 0 ]; then
          TARGET_ENV="blue"
      elif { [ "$P1_PORT" -eq 3001 ] || [ "$P1_PORT" -eq 8001 ]; } && [ "$P1_NEW_WT" -eq 10 ]; then
          TARGET_ENV="green"
      elif { [ "$P2_PORT" -eq 3001 ] || [ "$P2_PORT" -eq 8001 ]; } && [ "$P2_NEW_WT" -eq 10 ]; then
          TARGET_ENV="green"
      elif { [ "$P1_PORT" -eq 3000 ] || [ "$P1_PORT" -eq 8000 ]; } && [ "$P1_NEW_WT" -eq 0 ]; then
          TARGET_ENV="green"
      elif { [ "$P2_PORT" -eq 3000 ] || [ "$P2_PORT" -eq 8000 ]; } && [ "$P2_NEW_WT" -eq 0 ]; then
          TARGET_ENV="green"
      fi
      
      # 4️⃣ Execution Action (Nginx Write and Reload)
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
      echo "⚠️ Safety Check Failed: Nginx configuration current state does not match input arguments. No changes made."
      return 1
    fi
}

# Check Blue Environment
if docker compose -f $BLUE_DOCKER_COMPOSE_FILE_PATH ps --services --filter "status=running" | grep -q "frontend-blue\|backend-blue"; then
  BLUE_RUNNING=true
fi

# Check Green Environment
if dokcer compose -f $GREEN_DOCKER_COMPOSE_FILE_PATH ps --service --filter "status=running" | grep -q "frontend-green\|backend-green"; then
  GREEN_RUNNING=true
fi

# Result
if [ "$BLUE_RUNNING" = true ] && [ "$GREEN_RUNNING" = true ]; then
  echo "🟡 Both Blue and Green environments are running!"
  echo "   - Blue  (Port 3000/8000)"
  echo "   - Green (Port 3001/8001)"
  
  CHANGE_TAG "latest" "previous"

  docker compose --env-file .env.blue -f docker-compose.yaml -p d2c-blue pull

  docker compose --env-file .env.blue -f docker-compose.yaml -p d2c-blue up -d --force-recreate

  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10"
  
  sleep 10

  docker compose --env-file .env.green -f docker-compose.yaml -p d2c-green pull

  docker compose --env-file .env.green -f docker-compose.yaml -p d2c-green up -d --force-recreate

  CHANGE_ENVIRONMENT "3001" "0" "10" "8001" "0" "10"
elif [ "$BLUE_RUNNING" = true ]; then
  echo "🔵 Blue Environment is currently ACTIVE"
  echo "   Ports: Frontend=3000, Backend=8000"

  echo "🟢 Green Environment is starting..."

  CHANGE_TAG "latest" "previous"

  docker compose --env-file .env.green -f docker-compose.yaml -p d2c-green pull

  docker compose --env-file .env.green -f docker-compose.yaml -p d2c-green up -d --force-recreate

  CHANGE_ENVIRONMENT "3001" "0" "10" "8001" "0" "10"

  if docker compose -f $GREEN_DOCKER_COMPOSE_FILE_PATH ps --services --filter "status=running" | grep -q "frontend-green\|backend-green"; then
    echo "Green environment is started successfully 🚀"
  else
    echo "❌ Green environment is failed to start"
    exit 1
  fi

  echo "🟢 Green Environment is currently ACTIVE"
  echo "   Ports: Frontend=3001, Backend=8001"

elif [ "$GREEN_RUNNING" = true ]; then
  echo "🟢 Green Environment is currently ACTIVE"
  echo "   Ports: Frontend=3001, Backend=8001"

  echo "🔵 Blue Environment is starting..."

  CHANGE_TAG "latest" "previous"

  docker compose --env-file .env.blue -f docker-compose.yaml -p d2c-blue pull

  docker compose --env-file .env.blue -f docker-compose.yaml -p d2c-blue up -d --force-recreate

  if docker compose -f $BLUE_DOCKER_COMPOSE_FILE_PATH ps --services --filter "status=running" | grep -q "frontend-blue\|backend-blue"; then
    echo "Blue environment is started successfully 🚀"
  else
    echo "❌ Blue environment is failed to start"
    exit 1
  fi

  echo "🔵 Blue Environment is currently ACTIVE"
  echo "   Ports: Frontend=3000, Backend=8000"

else
  echo "⚪ No environment is running."
  echo "🔵 Blue Environment is starting..."
  
  CHANGE_TAG "previous" "latest"

  docker compose --env-file .env.blue -f docker-compose.yaml -p d2c-blue pull

  docker compose --env-file .env.blue -f docker-compose.yaml -p d2c-blue up -d --force-recreate

  CHANGE_ENVIRONMENT "3000" "0" "10" "8000" "0" "10" 

  if docker compose -f $BLUE_DOCKER_COMPOSE_FILE_PATH ps --services --filter "status=running" | grep -q "frontend-blue\|backend-blue"; then
    echo "Blue environment is started successfully 🚀"
  else
    echo "❌ Blue environment is failed to start"
    exit 1
  fi

  echo "🔵 Blue Environment is currently ACTIVE"
  echo "   Ports: Frontend=3000, Backend=8000"

fi






