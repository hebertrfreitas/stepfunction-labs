#!/bin/sh

#load envs
source .env

docker build -t ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO} projects/simple-python-worker/Dockerfile .

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}

