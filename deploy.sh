#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Redirect all stdout and stderr to a log file so we can debug easily if it fails
exec > /var/log/user-data.log 2>&1

echo "=== Starting CloudDrive Deployment Script ==="

# 1. Update system package index
sudo apt-get update -y

# 2. Install Node.js 18.x and AWS CLI
echo "Installing Node.js and AWS CLI..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs awscli

# 3. Create app workspace and navigate into it
mkdir -p /home/ubuntu/clouddrive
cd /home/ubuntu/clouddrive

# 4. Pull the latest compiled code bundle from your S3 bucket
echo "Fetching code archive from S3..."
aws s3 cp s3://clouddrive-deploy-bucket-2026/clouddrive-latest.tar.gz .

# 5. Extract the code bundle
echo "Extracting code bundle..."
tar -xzf clouddrive-latest.tar.gz

# 6. Install production dependencies
echo "Installing application dependencies..."
npm install --production

# 7. Install and configure PM2 (Process Manager) to keep our server running forever
echo "Starting application with PM2..."
sudo npm install -g pm2

# Stop any running instances of our app gracefully if they exist
pm2 delete clouddrive || true

# Start the application on port 3000
pm2 start server.js --name "clouddrive"

# Ensure PM2 restarts our application automatically if the EC2 instance reboots
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

echo "=== CloudDrive Deployment Script Finished Successfully ==="