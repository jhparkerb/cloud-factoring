# Given a properly installed cado-nfs, start a client that connects to the
# named server for work.
FROM cado-base

ARG server

COPY client.sh /home/cado/
USER cado
WORKDIR /home/cado
CMD /pkg/cado/bin/cado-nfs-client.py \
		--server=http://${server}:4242/ \
		--workdir=/home/cado/client-work
