#!/usr/bin/env bash

# Login to docker hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

#docker build -t securitypedant/paperserver:$PAPER_VERSION --build-arg PAPER_VERSION=$PAPER_VERSION --build-arg JAVA_VERSION=$JAVA_VERSION .
docker build -t simonsecuritypedant/paperserver:$PAPER_VERSION ..
docker push simonsecuritypedant/paperserver:$PAPER_VERSION
