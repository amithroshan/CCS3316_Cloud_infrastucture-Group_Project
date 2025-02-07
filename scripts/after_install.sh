#!/bin/bash

echo "Navigating to the application directory..."
cd /home/ubuntu/app || { echo "Failed to navigate to /home/ubuntu/app"; exit 1; }

echo "Installing dependencies..."
npm install

echo "Restarting the application..."
pm2 restart app || pm2 start app.js --name app

echo "Deployment completed successfully."
