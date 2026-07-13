#!/bin/bash

BLUE_RUNNING=false
GREEN_RUNNING=false

if [ $(docker ps --filter "label=com.docker.compose.project=d2c-blue" --filter "status=running" -q | wc -l) -gt 0 ]; then
    BLUE_RUNNING=true
else
    BLUE_RUNNING=false
fi

if [ $(docker ps --filter "label=com.docker.compose.project=d2c-green" --filter "status=running" -q | wc -l) -gt 0 ]; then
    GREEN_RUNNING=true
else
    GREEN_RUNNING=false
fi

if [ "$BLUE_RUNNING" = true ] && [ "$GREEN_RUNNING" = true ]; then
  echo "🟡 Both Blue and Green environments are running!"
elif [ "$BLUE_RUNNING" = true ]; then
  echo "🔵 Blue Environment is currently ACTIVE"
elif [ "$GREEN_RUNNING" = true ]; then
  echo "🟢 Green Environment is currently ACTIVE"
else
  echo "⚪ No environment is running."
fi
