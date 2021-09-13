#!/bin/bash
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
sudo apt update -y
sudo apt install nginx -y

sudo cat <<EOF > /etc/nginx/sites-available/default

upstream web_backend {
        server 10.0.1.32:3000;
        server 10.0.1.33:3000;
}
server {
listen 80;
location / {
proxy_pass http://web_backend;
}
}

EOF

sudo service nginx restart
