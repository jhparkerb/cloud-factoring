#!/bin/bash

NUM_CORES=$(nproc)
NET_NAME=cado-net

N=1594060871834872849232550589685222453981967176450655020577707866167574633834981155680666100440925348543054119622244370855518420960468096525335913

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
				--workdir=/home/cado/32229_189/client-${num} \
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
			--workdir=/home/cado/32229_189 \
			--client-threads=1 \
			-t all \
			server.port=4242 \
			server.ssl=no \
			server.whitelist=0.0.0.0/0 \
			tasks.linalg.run=false \
			$N

docker run \
	--network ${NET_NAME} \
	--cpus=${NUM_CORES}.0 \
	--name=local \
	-v ${HOME}/work:/home/cado \
	cado \
		/pkg/cado/bin/cado-nfs.py \
			--server \
			-t all \
			--workdir=/home/cado/32229_189 \
			$N

for num in $(seq 1 $NUM_CORES)
do
	docker rm -f client-${num} > /dev/null
done
