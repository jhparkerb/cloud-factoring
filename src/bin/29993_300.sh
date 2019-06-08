#!/bin/bash

NUM_CORES=$(nproc)
NET_NAME=cado-net

NAME=29993_300
N=1202510478719796470309646445568640701590736078586062717873137060148545422874532311084667540206857309697091242914943841786950033964708533541630044926290986494573206160361139

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
				--workdir=/home/cado/${NAME}/client-${num} \
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
			--workdir=/home/cado/${NAME} \
			--client-threads=1 \
			-t all \
			server.port=4242 \
			server.ssl=no \
			server.whitelist=0.0.0.0/0 \
			tasks.linalg.run=false \
			tasks.maxtimedout=200 \
			tasks.wutimeout=86500 \
			$N

docker run \
	--network ${NET_NAME} \
	--cpus=$((${NUM_CORES} / 2)).0 \
	--name=local \
	-v ${HOME}/work:/home/cado \
	cado \
		/pkg/cado/bin/cado-nfs.py \
			--server \
			--workdir=/home/cado/${NAME} \
			$N

for num in $(seq 1 $NUM_CORES)
do
	docker rm -f client-${num} > /dev/null
done
