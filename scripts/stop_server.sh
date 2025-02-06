#!/bin/bash

# Stop the running Node.js application
echo "Stopping Node.js application..."

# Find the process running on port 3000 (or your app's port) and kill it
APP_PID=$(lsof -t -i:3000)

if [ -n "$APP_PID" ]; then
  echo "Killing process $APP_PID..."
  kill -9 $APP_PID
else
  echo "No process found running on port 3000."
fi

echo "Application stopped."
