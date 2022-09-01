#! /bin/bash
sudo su
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
rm -rf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz
./node_exporter-1.4.0-rc.0.linux-amd64/node_exporter &
