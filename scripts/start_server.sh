#!/bin/bash
cd /home/ubuntu/app
npm install
pm2 restart app.js || pm2 start app.js
