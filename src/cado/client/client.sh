#!/bin/sh

set -e

su -c 'cd /home/cado; \
	/pkg/cado/bin/cado-nfs-client.py \
		--server=http://localhost:4242 \
		--workdir=/home/cado/client-work' cado
