#!/bin/bash
sudo apt-get -o Acquire::ForceIPv4=true update -y
sudo apt-get -o Acquire::ForceIPv4=true upgrade -y
sudo apt install mariadb-server -y
sudo systemctl enable --now mariadb
sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE redminedb;
CREATE USER 'redmineuser'@'localhost' IDENTIFIED BY 'P@ssW0rD';
GRANT ALL PRIVILEGES ON *.* TO 'redmineuser'@'localhost'
WITH GRANT OPTION;
CREATE USER 'redmineuser'@'%' IDENTIFIED BY 'P@ssW0rD';
GRANT ALL PRIVILEGES ON *.* TO 'redmineuser'@'%'
WITH GRANT OPTION;
FLUSH PRIVILEGES;
MYSQL_SCRIPT

sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf


sudo service mysql restart
