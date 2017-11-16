# Given a properly installed cado-nfs, start a server that waits for
# connections from clients.
FROM cado-base

ARG N=14447_190

COPY 14447_190 /home/cado/
USER cado
WORKDIR /home/cado
EXPOSE 4242
CMD /pkg/cado/bin/cado-nfs.py \
	--server \
	$(cat 14447_190) \
	server.port=4242 \
	server.ssl=no \
	server.whitelist=localhost,172.17.0.0/16 \
	--client-threads 8 \
	--server-threads 2 \
	--workdir=/home/cado/14447_190.work
