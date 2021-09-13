#!/bin/bash
sudo apt-get -o Acquire::ForceIPv4=true update -y
sudo apt-get -o Acquire::ForceIPv4=true upgrade -y

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
