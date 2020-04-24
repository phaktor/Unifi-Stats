#!/bin/bash
apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
apt -y update
apt-get -y install grafana
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service
