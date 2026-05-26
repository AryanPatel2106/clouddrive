#!/bin/bash
cd /home/ubuntu/clouddrive

# Download the incoming archive from S3
aws s3 cp s3://clouddrive-deploy-bucket-2026/clouddrive-latest.tar.gz clouddrive-incoming.tar.gz

# Check if the downloaded file is actually new
if ! cmp -s clouddrive-latest.tar.gz clouddrive-incoming.tar.gz; then
    echo "New deployment package found! Updating application..."
    mv clouddrive-incoming.tar.gz clouddrive-latest.tar.gz
    tar -xzf clouddrive-latest.tar.gz
    npm install --production
    pm2 restart clouddrive
else
    echo "No changes found in S3. Application is up to date."
    rm clouddrive-incoming.tar.gz
fi