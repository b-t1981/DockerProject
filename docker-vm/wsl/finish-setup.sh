#!/bin/bash
set -e
echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
apt-get update
apt-get install -y iptables
dockerd > /tmp/dockerd.log 2>&1 &
sleep 12
docker info | head -10
