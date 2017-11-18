# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.
FROM cado-build

ENV DEPS ' \
	bc \
	bind-tools \
	curl \
	gzip \
	less \
	openssl \
	perl \
	python \
	python3 \
	vim \
	'

#	libgomp1 \
#	iputils-ping \
#	libdata-dumper-concise-perl \

RUN apk update && \
	apk add $DEPS && \
	adduser -D cado
