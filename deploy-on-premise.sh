#!/usr/bin/env bash
set -euo pipefail

echo "Installing docker..."
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
echo "...installing docker done"

# echo "Installing docker-compose..."
# sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
# echo "...installing docker-compose done"

echo "Installing git..."
sudo yum install -y git
echo "...installing git done"

REPO="~/docker-dumb-app"

if  [[ ! -d $REPO ]]
then 
    echo "Cloning repository..."
    git clone https://github.com/padok-team/docker-dumb-app.git 
    cd $REPO    
else
    cd $REPO
    git pull
fi

git checkout $BRANCH

echo "Building and runnning..."
TAG="docker-dumb-app:$BRANCH"
sudo docker build -t $TAG .

echo "Stopping running containers..."
CONTAINERS=$(sudo docker container ls -q)
echo "MAINS:::" $CONTAINERS
if [[ ! -z "$CONTAINERS" ]]
then 
    sudo docker stop $CONTAINERS
fi
echo "...stopping running containers done"

sudo docker run --rm -d -p 3000:8080 $TAG
echo "App running..."
