#!/bin/bash

if curl -s -f --max-time 5 http://localhost:3001/health > /dev/null && \
   curl -s -f --max-time 5 http://localhost:8001/health > /dev/null; then
   echo "⬆️ Greeen is up. Switching traffic to green 🟢."
else
   echo "⬇️ Green is down. Switching traffic to blue 🔵."
fi
