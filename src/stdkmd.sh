#!/bin/bash

NAME=$1; shift
N=$1; shift

WORK_ROOT=${HOME}/run

FACTOR_ROOT=${WORK_ROOT}/${NAME}

mkdir -p $FACTOR_ROOT

docker run \
	--cpuset-cpus 0-63 \
	--rm \
	-it \
	-v ${FACTOR_ROOT}:/home/cado \
	cado:latest \
		/pkg/cado/bin/cado-nfs.py \
			-w . \
			$N \
				name=${NAME} \
				--slaves 32 \
				--client-threads 2 \
				--server-threads 64
