#!/bin/bash

cd /tmp && mkcert devops-camp
cd - && sudo cp $(pwd)/50x.html /usr/share/nginx/html

sudo nginx -c "$(pwd)/nginx.conf"
uwsgi --ini app.ini

