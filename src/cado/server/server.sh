#!/bin/sh

set -e

export N=${1-N}
su -c 'cd /home/cado; \
	/pkg/cado/bin/cado-nfs.py \
		--server \
		$(cat $N) \
		server.port=4242 \
		server.ssl=no \
		server.whitelist=localhost \
		--client-threads 8 \
		--server-threads 2 \
		--workdir=/home/cado/${N}.work' cado
