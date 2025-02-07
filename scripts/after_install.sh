#!/bin/bash

echo "Navigating to the application directory..."
cd /var/www/html/ || { echo "Failed to navigate to /home/ubuntu/app"; exit 1; }

echo "Installing dependencies..."
npm install

echo "Restarting the application..."
pm2 restart app || pm2 start app.js --name app

echo "Deployment completed successfully."


sudo mv public/index.html .
sudo mv public/login.html .
sudo mv public/signup.html .
sudo mv public/style.css .
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
