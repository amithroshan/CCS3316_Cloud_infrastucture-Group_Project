#!/bin/bash

echo "Stopping Node.js application..."

# Get the process ID (PID) of the app running on port 3000 (update if needed)
APP_PID=$(lsof -t -i:3000)

# Check if the process exists and terminate it
if [ -n "$APP_PID" ]; then
    echo "Killing process $APP_PID..."
    kill -9 "$APP_PID"
    echo "Application stopped successfully."
else
    echo "No process found running on port 3000."
fi

# Ensure PM2 stops all processes (if using PM2)
if command -v pm2 &> /dev/null; then
    echo "Stopping PM2 processes..."
    pm2 stop all || echo "No PM2 processes running."
    pm2 delete all || echo "No PM2 processes to delete."
fi

echo "Shutdown script completed."
