#!/bin/bash

# Navigate to the app directory
cd /home/ubuntu/app || { echo "Failed to navigate to /home/ubuntu/app"; exit 1; }

# Install Node.js if not already installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install PM2 globally if not already installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Start or restart the application using PM2
echo "Starting the application..."
pm2 restart app.js || pm2 start app.js

echo "Application started successfully."