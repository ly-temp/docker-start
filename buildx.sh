#!/bin/sh -e
CLOUD_NAME="$1"
ARCH=amd64

sudo apt update && sudo apt install -y jq curl
mkdir -p ~/.docker/cli-plugins
BUILDX_URL=$(curl -s https://raw.githubusercontent.com/docker/actions-toolkit/main/.github/buildx-lab-releases.json | jq -r ".latest.assets[] | select(endswith(\"linux-$ARCH\"))")
curl --silent -L --output ~/.docker/cli-plugins/docker-buildx $BUILDX_URL
chmod a+x ~/.docker/cli-plugins/docker-buildx
docker buildx create --use --driver cloud "$CLOUD_NAME"
docker buildx use "$CLOUD_NAME" --global

#run with docker buildx build --builder "$CLOUD_NAME" --tag myorg/some-tag .
