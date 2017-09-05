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

sudo cp /etc/fstab /etc/fstab.orig

sudo mkdir /data
echo "/dev/xvdf /data ext4 defaults,nofail 0 2" | sudo tee --append /etc/fstab

sudo mkdir /artifacts
echo "/dev/xvdg /artifacts ext4 defaults,nofail 0 2" | sudo tee --append /etc/fstab

# install team city
echo "Installing TeamCity $TEAMCITY_VERSION"

sudo wget -nv -c https://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz -O /tmp/TeamCity.tar.gz
sudo tar -xvf /tmp/TeamCity.tar.gz -C /srv
sudo rm -rf /tmp/TeamCity.tar.gz

# create user
sudo useradd -m teamcity

# create init.d script
sudo cp /tmp/teamcity /etc/init.d/teamcity
sudo chmod 775 /etc/init.d/teamcity

# ensure owership
sudo chown -R teamcity:teamcity /srv/TeamCity
sudo chown -R teamcity:teamcity /data
sudo chown -R teamcity:teamcity /artifacts

# proxy port 80 to 8111
sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf
sudo chkconfig nginx on
