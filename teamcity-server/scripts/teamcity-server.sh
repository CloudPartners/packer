#!/bin/bash

cd /

# install server dependencies
sudo yum update
sudo yum upgrade -y
sudo yum install -y curl
sudo yum install -y git
sudo yum install -y nginx
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk-headless

# install team city
echo "Installing TeamCity $TEAMCITY_VERSION"

sudo wget -nv -c https://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz -O /tmp/TeamCity.tar.gz
sudo tar -xvf /tmp/TeamCity.tar.gz -C /srv
sudo rm -rf /tmp/TeamCity.tar.gz
sudo mkdir /srv/.BuildServer

# create user
sudo useradd -m teamcity
sudo chown -R teamcity /srv/TeamCity
sudo chown -R teamcity /srv/.BuildServer

# create init.d script
sudo cp /tmp/teamcity /etc/init.d/teamcity
sudo chmod 775 /etc/init.d/teamcity
sudo chkconfig teamcity on

# download postgres
sudo mkdir -p /srv/.BuildServer/lib/jdbc
sudo mkdir -p /srv/.BuildServer/config
#sudo wget http://jdbc.postgresql.org/download/postgresql-9.3-1101.jdbc41.jar -O /srv/.BuildServer/lib/jdbc/postgresql-9.3-1101.jdbc41.jar
#sudo wget https://gist.githubusercontent.com/sandcastle/9282638/raw/postgres.database.properties -O /srv/.BuildServer/config/database.properties

# ensure owership
sudo chown -R teamcity /srv/TeamCity
sudo chown -R teamcity /srv/.BuildServer

# proxy port 80 to 8111
sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf
sudo chkconfig nginx on
