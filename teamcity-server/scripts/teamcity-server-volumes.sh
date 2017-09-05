#!/bin/bash

sudo mkfs.ext4 /dev/xvdf
sudo mkdir /data
sudo mount /dev/xvdf /data

sudo mkdir -p /data/.BuildServer/lib/jdbc
sudo mkdir -p /data/.BuildServer/config/projects/_Root
#sudo wget http://jdbc.postgresql.org/download/postgresql-9.3-1101.jdbc41.jar -O /data/.BuildServer/lib/jdbc/postgresql-9.3-1101.jdbc41.jar
#sudo wget https://gist.githubusercontent.com/sandcastle/9282638/raw/postgres.database.properties -O /data/.BuildServer/config/database.properties

sudo mkfs.ext4 /dev/xvdg
sudo mkdir /artifacts
sudo mount /dev/xvdg /artifacts

sudo mv /tmp/database.properties /data/.BuildServer/config/database.properties
sudo mv /tmp/project-config.xml /data/.BuildServer/config/projects/_Root/project-config.xml
sudo mv /tmp/main-config.xml /data/.BuildServer/config/main-config.xml