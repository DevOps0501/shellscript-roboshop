#!/bin/bash
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y 
systemctl enable mongod 
systemctl start mongod 

sed -i 's/127\.0\.0\.1/0.0.0.0/g' /etc/mongod.conf

if grep "bindIp: 0.0.0.0" /etc/mongod.conf;then
echo "bindip updated"
else
echo "bindip not updated correctly..Please check it on /etc/mongo.conf"
exit 1
fi

systemctl restart mongod
if [ "$(systemctl is-active mongod)" = "active" ]; then
echo "SUCCESS: Monodb is Active"
else
echo "Failed: mongodb is not is Active state"
exit 1
fi