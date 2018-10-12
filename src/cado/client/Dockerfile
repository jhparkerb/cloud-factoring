# Given a properly installed cado-nfs, start a client that connects to the
# named server for work.
FROM cado-base

USER cado
WORKDIR /home/cado
CMD /pkg/cado/bin/cado-nfs-client.py \
		--workdir=/home/cado/$(hostname) \
		--server=
