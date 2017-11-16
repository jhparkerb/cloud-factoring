#!/bin/sh

# Destroy all docker state.

set -e

docker rm $(docker ps -a -q) || true
docker rmi $(docker images -q) || true
