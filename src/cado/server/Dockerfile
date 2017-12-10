# Given a properly installed cado-nfs, start a server that waits for
# connections from clients.
FROM cado-base

USER cado
WORKDIR /home/cado
COPY 37771_187 .
EXPOSE 4242
CMD /pkg/cado/bin/cado-nfs.py \
	--server \
	$(cat 37771_187) \
	server.port=4242 \
	server.ssl=no \
	server.whitelist=0.0.0.0/0 \
	--workdir=/home/cado/37771_187.work
