# Given a properly installed cado-nfs, start a client that connects to the
# named server for work.
FROM cado-base

USER cado
WORKDIR /home/cado
CMD sleep $(( $RANDOM % 300 )) && \
	/pkg/cado/bin/cado-nfs-client.py \
		--server=http://cado-server:4242/ \
		--workdir=/home/cado/$(hostname)
