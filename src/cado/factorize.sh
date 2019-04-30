#!/bin/bash

NUM_CORES=$(nproc)
NET_NAME=cado-net

BITS=400
P=$(openssl prime -generate -safe -bits $(($BITS/2 + 1)))
Q=$(openssl prime -generate -safe -bits $(($BITS/2 + 1)))
N=$(echo $P \* $Q | BC_LINE_LENGTH=1000 bc)

docker ps | awk '/cado-client/ { print $1 }' | xargs docker rm -f
docker rm -f dist local || true
yes | docker container prune -f

docker network rm ${NET_NAME} || true
docker network create ${NET_NAME}

for num in $(seq 1 $NUM_CORES)
do
	docker run \
		--network ${NET_NAME} \
		--cpus=1.0 \
		--name=client-${num} \
		-v ${HOME}/work:/home/cado \
		-d \
		cado \
			/pkg/cado/bin/cado-nfs-client.py \
				--workdir=/home/cado/client-${num} \
				--bindir=/pkg/cado/lib/cado-nfs-3.0.0 \
				--server=http://dist:4242/ &
done

docker run \
	--network ${NET_NAME} \
	--cpus=${NUM_CORES}.0 \
	--name=dist \
	-v ${HOME}/work:/home/cado \
	cado \
		/pkg/cado/bin/cado-nfs.py \
			--server \
			--workdir=/home/cado \
			--client-threads=1 \
			-t all \
			server.port=4242 \
			server.ssl=no \
			server.whitelist=0.0.0.0/0 \
			tasks.linalg.run=false \
			$N

for num in $(seq 1 $NUM_CORES)
do
	docker rm -f client-${num} &
done

docker run \
	--network ${NET_NAME} \
	--cpus=${NUM_CORES}.0 \
	--name=local \
	-v ${HOME}/work:/home/cado \
	cado \
		/pkg/cado/bin/cado-nfs.py \
			--server \
			-t all \
			--workdir=/home/cado \
			$N
