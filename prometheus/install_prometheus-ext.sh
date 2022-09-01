sudo su
wget https://github.com/prometheus/prometheus/releases/download/v2.38.0/prometheus-2.38.0.linux-amd64.tar.gz
tar -xvf prometheus-2.38.0.linux-amd64.tar.gz
rm -rf prometheus-2.38.0.linux-amd64.tar.gz
./prometheus-2.38.0.linux-amd64/prometheus --config.file=/prometheus-2.38.0.linux-amd64/prometheus.yml
