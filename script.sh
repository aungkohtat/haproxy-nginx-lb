#!/bin/bash

# Run Docker Compose to build the images and run them in a dcoker network
docker compose up

# Wait until the containers are up and running
while ! ( curl http://172.16.0.100 ) &&  (curl http://172.16.0.200)
do
  echo "$(date) - Waiting for both Docker containers to be up and running"
  sleep 1
done
echo "$(date) - Welcome to nginx"

# Check the status of the high-availability load-balancer:
curl 172.16.0.2
curl 172.16.0.3