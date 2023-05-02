#!/bin/bash

# Create the necessary folders and files
sudo cp -r $(pwd)/reports /var/www
cd /tmp && mkcert localhost
cd - &> /dev/null

# Setting permissions
sudo chown -R nginx:nginx /tmp/localhost.pem
sudo chown -R nginx:nginx /tmp/localhost-key.pem
sudo chmod 777 /var/log

# Launch nginx and php-fpm
sudo killall -9 nginx &> /dev/null
sudo killall -9 /usr/sbin/php-fpm8.2 &> /dev/null
sudo /usr/sbin/php-fpm8.2 --php-ini "$(pwd)/php.ini" -y "$(pwd)/php-fpm.conf"
sudo nginx -c "$(pwd)/nginx.conf"

while [[ $(ps aux | grep nginx | wc -l) -eq 1 || $(ps aux | grep php-fpm | wc -l) -eq 1 ]]; do
  sleep 1
done

# Sending requests
time curl https://localhost/reports/fast
time curl https://localhost/reports/slow
