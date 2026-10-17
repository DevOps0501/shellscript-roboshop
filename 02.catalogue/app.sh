#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
dnf install nodejs20 -y
command -v node
useradd --system --home-dir /app --shell /sbin/nologin --comment "roboshop user" roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip
pwd
npm install
cp "$SCRIPT_DIR/catalogue.service" /etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
if [ "$(systemctl is-active catalogue)" = "active" ]; then
    echo "SUCCESS: catalogue service is Active"
else
    echo "Failed: catalogue service is not on active state"
    systemctl status catalogue --no-pager
fi
cp "$SCRIPT_DIR/mongo.repo" /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y
if mongosh --host mongodb.aws05.shop < /app/db/master-data.js; then
    echo "SUCCESS: MongoDB connection and data import completed"
else
    echo "FAILED: MongoDB connection or data import failed"
    exit 1
fi