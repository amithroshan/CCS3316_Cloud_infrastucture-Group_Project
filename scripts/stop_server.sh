#!/bin/bash

echo "Stopping Node.js application..."

# Method 1: Use lsof if available
if command -v lsof &> /dev/null; then
    APP_PID=$(lsof -t -i:3000)
else
    # Method 2: Use netstat (fallback)
    APP_PID=$(netstat -tulpn 2>/dev/null | grep ':3000' | awk '{print $7}' | cut -d'/' -f1)
fi

# Terminate the process
if [ -n "$APP_PID" ]; then
    echo "Killing process $APP_PID..."
    kill -9 "$APP_PID"
    echo "Application stopped successfully."
else
    echo "No process found running on port 3000."
fi

# Stop PM2 processes (if used)
if command -v pm2 &> /dev/null; then
    echo "Stopping PM2 processes..."
    pm2 stop all || echo "No PM2 processes running."
    pm2 delete all || echo "No PM2 processes to delete."
fi

echo "Shutdown script completed."