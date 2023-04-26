#!/bin/bash

# Create the necessary folders and files
sudo cp -r $(pwd)/reports /var/www
cd /tmp && mkcert localhost
cd -

# Setting permissions
sudo chown -R nginx:nginx /tmp/localhost.pem
sudo chown -R nginx:nginx /tmp/localhost-key.pem
sudo chmod 777 /var/log

# Launch nginx and php-fpm
sudo fuser -k 443/tcp
sudo /usr/sbin/php-fpm8.2 --php-ini "$(pwd)/php.ini" -y "$(pwd)/php-fpm.conf"
sudo nginx -c "$(pwd)/nginx.conf"

# Sending requests
time curl https://localhost/reports/fast
time curl https://localhost/reports/slow
