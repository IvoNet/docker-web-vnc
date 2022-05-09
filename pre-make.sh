#!/usr/bin/env bash

if [ ! -f "root/etc/guacamole/extensions/ivonet-guacamole-custom-login.jar" ]; then
  echo "Build custom login extension..."
  cd ivonet-guacamole-custom-login
  mvn clean package clean
  cd ..
else
  echo "Not building custom-login Guacamole extension. It already exists."
fi

if [ ! -f "root/etc/guacamole/extensions/ivonet-guacamole-docker-auto-login.jar" ]; then
  echo "Build auto login extension..."
  cd ivonet-guacamole-docker-auto-login
  mvn clean package clean
  cd ..
else
  echo "Not building auto-login Guacamole extension. It already exists."
fi