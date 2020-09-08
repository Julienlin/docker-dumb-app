#!/usr/bin/env bash
set -euo pipefail

BRANCH=${1:-"master"}
echo "Deploying branch $BRANCH"

scp -i "training instance.pem" deploy-on-premise.sh ec2-user@ec2-18-223-132-37.us-east-2.compute.amazonaws.com:~
ssh -i "training instance.pem" ec2-user@ec2-18-223-132-37.us-east-2.compute.amazonaws.com "BRANCH=$BRANCH ./deploy-on-premise.sh"
