#!/bin/bash

# Go to application directory
cd /home/ubuntu/app || exit

# Install Node.js & npm (if not installed)
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install dependencies
npm install

# Install PM2 globally if not already installed
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
fi

# Restart or start the app using PM2
pm2 restart app.js || pm2 start app.js
