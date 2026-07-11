#!/bin/bash

# Nginx config file ka absolute path yahan set karein (apne setup ke hisab se)
NGINX_CONF="/etc/nginx/nginx.conf"

while true; do
    # 🩺 Green Environment (Ports 3001 & 8001) ka Health Check
    if curl -s -f --max-time 5 http://localhost:3001/health > /dev/null && \
       curl -s -f --max-time 5 http://localhost:8001/health > /dev/null; then
        
        # 🟢 SWITCH TO GREEN: 
        if grep -q "127.0.0.1:3001 down;" "$NGINX_CONF" && grep -q "127.0.0.1:8001 down;" "$NGINX_CONF"; then
            echo "🟢 Green is healthy! Switching traffic from Blue to Green..."
            
            sudo sed -i \
              -e 's/127.0.0.1:3000 weight=10;/127.0.0.1:3000 down;/g' \
              -e 's/127.0.0.1:3001 down;/127.0.0.1:3001 weight=10;/g' \
              -e 's/127.0.0.1:8000 weight=10;/127.0.0.1:8000 down;/g' \
              -e 's/127.0.0.1:8001 down;/127.0.0.1:8001 weight=10;/g' \
              -e 's/"active_environment": "blue"/"active_environment": "green"/g' \
              "$NGINX_CONF"
            
            sudo nginx -s reload
            echo "🚀 Traffic successfully shifted to Green."
        fi
    else
        # 🔵 ROLLBACK TO BLUE:
        if grep -q "127.0.0.1:3000 down;" "$NGINX_CONF" && grep -q "127.0.0.1:8000 down;" "$NGINX_CONF"; then
            echo "🚨 ALERT: Green environment health check failed! Rolling back to Blue..."
            
            sudo sed -i \
              -e 's/127.0.0.1:3000 down;/127.0.0.1:3000 weight=10;/g' \
              -e 's/127.0.0.1:3001 weight=10;/127.0.0.1:3001 down;/g' \
              -e 's/127.0.0.1:8000 down;/127.0.0.1:8000 weight=10;/g' \
              -e 's/127.0.0.1:8001 weight=10;/127.0.0.1:8001 down;/g' \
              -e 's/"active_environment": "green"/"active_environment": "blue"/g' \
              "$NGINX_CONF"
            
            sudo nginx -s reload
            echo "🔙 Successfully rolled back to Blue environment safely."
        fi
    fi
    
    # Har 10 seconds me dubara check karega
    sleep 10
done