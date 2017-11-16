# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.
FROM cado-build

ENV RUNDEPS ' \
	curl \
	libdata-dumper-concise-perl \
	libgomp1 \
	openssl \
	python \
	python3 \
	'

# This list could be built with the aid of 
# dpkg-query -Wf '${Package;-40}${Priority}\n' | grep -v essential
ENV CRUFT ' \
	autoconf \
	automake \
	bison \
	clang \
	cmake \
	dpkg-dev \
	make \
	mercurial \
	nano \
	subversion \
	texinfo \
	'

RUN apt-get update && \
	apt-get install -y \
		$RUNDEPS && \
	dpkg --purge \
		$CRUFT && \
	useradd \
		--create-home \
		--home /home/cado \
		--password yyN7aDl7nlnvQ \
		--shell /bin/bash \
		--user-group \
		cado
