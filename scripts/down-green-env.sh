#!/bin/bash

DOCKER_COMPOSE_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/docker-compose.yaml"
GREEN_ENVIRONMENT_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/.env.green"

echo "Green container getting down ⬇️ "
docker compose --env-file "$GREEN_ENVIRONMENT_FILE_PATH" -f "$DOCKER_COMPOSE_FILE_PATH" -p d2c-green down -v

