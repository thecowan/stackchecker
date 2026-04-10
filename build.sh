#!/bin/sh

docker build . -t ghcr.io/thecowan/stackchecker
docker push ghcr.io/thecowan/stackchecker:master
