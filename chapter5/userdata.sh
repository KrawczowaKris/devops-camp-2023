#!/bin/bash

# install ssm agent
mkdir /tmp/ssm
curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm -o /tmp/ssm/amazon-ssm-agent.rpm
sudo yum install -y /tmp/ssm/amazon-ssm-agent.rpm

# install nginx
sudo yum install -y nginx

# start services
sudo service amazon-ssm-agent start
sudo service nginx start
