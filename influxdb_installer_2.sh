#!/bin/bash
echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
apt -y update
apt install -y influxdb
systemctl start influxdb
systemctl enable influxdb
