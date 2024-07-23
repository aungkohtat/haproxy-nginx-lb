# haproxy-nginx-lb
## HAProxy load balancer for Nginx servers using Docker (IPVS)

This project demonstrates a high-availability load balancing setup using HAProxy and Nginx with Docker. It includes three Nginx web servers and two HAProxy load balancers, with an option to set up a virtual IP for enhanced reliability.
Project Structure
```
├── docker-compose.yml
├── haproxy
│   ├── Dockerfile
│   ├── haproxy.cfg
│   └── haproxy.sh
├── ivps.sh
├── nginx
│   ├── web1
│   │   └── Dockerfile
│   ├── web2
│   │   └── Dockerfile
│   └── web3
│       └── Dockerfile
└── script.sh

```

### docker-compose.yml:

Defines and configures the Docker services for our setup.
Specifies the network configuration and links between services.


### haproxy/ directory:

Dockerfile: Instructions for building the HAProxy Docker image.
haproxy.cfg: Configuration file for HAProxy, defining load balancing rules.
haproxy.sh: Shell script for additional HAProxy setup or runtime configurations.


### nginx/ directory:

Contains subdirectories (web1, web2, web3) for three Nginx web servers.
Each subdirectory has a Dockerfile for building the respective Nginx Docker image.


### script.sh:

Main setup script that orchestrates the deployment of the entire system.
Likely includes commands to start Docker services and perform initial checks.


### ivps.sh:

Script for setting up the Virtual IP (IVPS) functionality.
Enhances high availability by providing a shared IP between HAProxy instances.



### Setup and Usage
1. Clone this repository:

```
git clone haproxy-nginx-lb
cd haproxy-nginx-lb
```

2. Run the main setup script:

```
chmod +x script.sh
./script.sh
```

3. Set up Virtual IP

```
chmod +x ivps.sh
./ivps.sh
```
Output docker  images and process

```

vagrant@cloud-native-box:~/haproxy-nginx-lb$ docker images
REPOSITORY                     TAG       IMAGE ID       CREATED         SIZE
haproxy-nginx-lb-haproxy1      latest    10c576d562d3   7 minutes ago   165MB
haproxy-nginx-lb-haproxy2      latest    24f90296fa75   7 minutes ago   165MB
haproxy-nginx-lb-nginx_web_1   latest    197dbc12602e   7 minutes ago   188MB
haproxy-nginx-lb-nginx_web_3   latest    44e7c7d776fd   7 minutes ago   188MB
haproxy-nginx-lb-nginx_web_2   latest    7fa80429a4b7   7 minutes ago   188MB
my-node-app                    latest    bb731a7e73aa   28 hours ago    1.25GB
node-mongo-docker-setup-app    latest    e8a4b79b0a7d   28 hours ago    1.25GB
mongo                          latest    a31b196b207d   3 weeks ago     796MB
vagrant@cloud-native-box:~/haproxy-nginx-lb$ docker ps
CONTAINER ID   IMAGE                          COMMAND                  CREATED         STATUS         PORTS     NAMES
0e60fe43ef62   haproxy-nginx-lb-nginx_web_1   "/docker-entrypoint.…"   7 minutes ago   Up 4 minutes   80/tcp    nginx_web_1
ae01ee16ba0d   haproxy-nginx-lb-nginx_web_2   "/docker-entrypoint.…"   7 minutes ago   Up 4 minutes   80/tcp    nginx_web_2
7cfc641f77be   haproxy-nginx-lb-nginx_web_3   "/docker-entrypoint.…"   7 minutes ago   Up 4 minutes   80/tcp    nginx_web_3
vagrant@cloud-native-box:~/haproxy-nginx-lb$ 

```

- Check list ist all running containers and their IP addresse

```
docker ps -q | xargs -n 1 -I {} docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {}

```

```
vagrant@cloud-native-box:~/haproxy-nginx-lb$ docker ps -q | xargs -n 1 -I {} docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {}
xargs: warning: options --max-args and --replace/-I/-i are mutually exclusive, ignoring previous --max-args value
/nginx_web_1 - 172.16.0.10
/nginx_web_2 - 172.16.0.20
/nginx_web_3 - 172.16.0.30
vagrant@cloud-native-box:~/haproxy-nginx-lb$ 
```

4. Test the load balancer:
- Test the load balancer with IVPS by executing some random curl commands on the HAProxy IP to check the response from three web servers

```
curl <haproxy-ip>
```

```
vagrant@cloud-native-box:~/haproxy-nginx-lb$ 
vagrant@cloud-native-box:~/haproxy-nginx-lb$ curl 172.16.0.10
“this is first webserver”
vagrant@cloud-native-box:~/haproxy-nginx-lb$ curl 172.16.0.20
“this is second webserver”
vagrant@cloud-native-box:~/haproxy-nginx-lb$ curl 172.16.0.30
“this is third webserver”
vagrant@cloud-native-box:~/haproxy-nginx-lb$ 
```
