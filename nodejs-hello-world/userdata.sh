install.sh
----------------------------
#!/bin/bash

# Update system packages
sudo apt-get update -y

# Install required dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker repository and install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce

# Start Docker service
sudo systemctl start docker

# Login to Docker Hub
#echo '${var.dockerhub_password}' | sudo docker login -u '${var.dockerhub_username}' --password-stdin

# Pull and run the Node.js application
sudo docker pull rahulhbc/nodejs-hello-world:v1
sudo docker run -d -p 80:8080 rahulhbc/nodejs-hello-world:v1