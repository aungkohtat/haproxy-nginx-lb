#!/bin/bash

# Install IPVS (assuming already installed)
sudo apt-get update
sudo apt-get install -y ipvsadm

# Add IPVS rules for virtual IP
sudo ipvsadm -A -t 100.100.100.100:80 -s rr  # Round Robin scheduling

# Add load balancer container to IPVS (modify ports accordingly)
sudo ipvsadm -a -t 100.100.100.100:80 -r 172.16.0.2 -m
sudo ipvsadm -a -t 100.100.100.100:80 -r 172.16.0.3 -m

# Check IPVS configuration
sudo ipvsadm -l

# Access web server via virtual IP (should cycle through servers)
while true; do curl http://100.100.100.100; sleep 1; echo; done