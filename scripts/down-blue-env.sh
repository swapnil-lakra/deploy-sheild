#!/bin/bash

DOCKER_COMPOSE_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/docker-compose.yaml"
BLUE_ENVIRONMENT_FILE_PATH="$HOME/deploy-sheild/app/fashion-d2c-app/.env.blue"

echo "Blue container getting down ⬇️ "
docker compose --env-file "$BLUE_ENVIRONMENT_FILE_PATH" -f "$DOCKER_COMPOSE_FILE_PATH" -p d2c-blue down -v

