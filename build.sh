#!/bin/sh

#load envs
source .env

cd projects/simple-python-worker

docker buildx build --platform=linux/amd64 . -t ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com

docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}

