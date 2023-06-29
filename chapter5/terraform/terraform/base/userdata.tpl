#! /bin/bash
mkdir /tmp/ssm

curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm -o /tmp/ssm/amazon-ssm-agent.rpm

sudo yum install -y /tmp/ssm/amazon-ssm-agent.rpm

sudo stop amazon-ssm-agent

sudo -E amazon-ssm-agent -register -code "activation-code" -id "activation-id" -region "us-east-2"

sudo start amazon-ssm-agent

# Install and run nginx
sudo yum -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install php and php-fpm
sudo yum -y install php php-fpm php-mysqli 
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# Install mysql
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install -y mysql80-community-release-el9-1.noarch.rpm
sudo dnf install -y mysql-shell
sudo yum install -y mysql-server
sudo service mysqld start


# Install dependencies for efs
sudo yum install -y amazon-efs-utils nfs-utils
sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3 /tmp/get-pip.py
sudo pip3 install botocore
sudo yum install -y gcc openssl-devel

# Mount EFS
cd /
sudo mkdir efs
sudo chmod go+rw efs
sudo mount -t efs -o tls ${efs_id}:/ efs

# Install wordpress
if ! [ -d /efs/wordpress ]; then
  cd /efs
  wget https://wordpress.org/latest.tar.gz
  tar -xzf latest.tar.gz
  cd wordpress

  # Creating wp-config.php
  cat << EOF > wp-config.php
<?php

define('DB_NAME',          '${rds_name}');
define('DB_USER',          '${rds_user}');
define('DB_PASSWORD',      '${rds_password}');
define('DB_HOST',          '${rds_endpoint}');
define('DB_CHARSET',       'utf8');
define('DB_COLLATE',       '' );
define('AUTH_KEY',         '${auth_key}');
define('SECURE_AUTH_KEY',  '${secure_auth_key}');
define('LOGGED_IN_KEY',    '${logged_in_key}');
define('NONCE_KEY',        '${nonce_key}');
define('AUTH_SALT',        '${auth_salt}');
define('SECURE_AUTH_SALT', '${secure_auth_salt}');
define('LOGGED_IN_SALT',   '${logged_in_salt}');
define('NONCE_SALT',       '${nonce_salt}');
\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

if (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
  \$_SERVER['HTTPS'] = 'on';

require_once ABSPATH . 'wp-settings.php';

define( 'FS_METHOD', 'direct' );
\$_SERVER["HTTPS"] = "on";

define( 'WP_HOME', 'https://${fqdn_record}/' );
define( 'WP_SITEURL', 'https://${fqdn_record}/' );
EOF
fi

# Editing nginx configuration
cat << EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    access_log  /var/log/nginx/access.log;
    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
    include /etc/nginx/conf.d/*.conf;
    client_max_body_size 300M;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /efs/wordpress;

        include /etc/nginx/default.d/*.conf;
    }
}
EOF
sudo service php-fpm restart
sudo service nginx restart
