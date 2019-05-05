#!/bin/sh

# Destroy all docker state.

set -e

docker rm -f $(docker ps -a -q) || true
docker rmi -f $(docker images -a -q) || true
docker volume prune -f
