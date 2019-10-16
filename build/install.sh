#!/bin/bash
set -ex
if ! docker --version &> /dev/null
then
    echo "must have docker installed"
    exit 1
fi

if ! docker-compose --version &> /dev/null
then
    echo  "must have docker-compose installed"
    exit 1
fi

mkdir -p ~/app/docker/prometheus
mkdir -p ~/app/docker/prometheus/rules
mkdir -p ~/app/docker/alertmanager
mkdir -p ~/app/docker/monitor
cp ../monitor-server/conf/docker/prometheus.yml ~/app/docker/prometheus
cp ../monitor-server/conf/docker/alertmanager.yml ~/app/docker/alertmanager
cp ../monitor-server/conf/docker/monitor.json ~/app/docker/monitor/default.json

source monitor.cfg

sed "s~{{MONITOR_DATABASE_IMAGE_NAME}}~$database_image_name~g" docker-compose.tpl > docker-compose.yml
sed -i "s~{{MYSQL_ROOT_PASSWORD}}~$database_init_password~g" docker-compose.yml
sed -i "s~{{MONITOR_IMAGE_NAME}}~$monitor_image_name~g" docker-compose.yml
sed -i "s~{{MONITOR_SERVER_PORT}}~$monitor_server_port~g" docker-compose.yml

sed -i "s~{{MYSQL_ROOT_PASSWORD}}~$database_init_password~g" ~/app/docker/monitor/default.json
sed -i "s~{{MONITOR_SERVER_PORT}}~$monitor_server_port~g" ~/app/docker/monitor/default.json

docker-compose  -f docker-compose.yml  up -d

 









