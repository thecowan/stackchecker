#!/bin/sh

docker build . -t ghcr.io/thecowan/stackchecker:latest
docker push ghcr.io/thecowan/stackchecker:latest
