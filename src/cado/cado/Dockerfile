# Build cado-nfs from source and install it into /pkg/cado.
FROM debian:jessie-slim AS buildenv

ENV DEPS ' \
	autoconf \
	automake \
	binutils \
	bison \
	ca-certificates \
	clang \
	cmake \
	dpkg-dev \
	libtool \
	make \
	mercurial \
	python \
	python3 \
	rsync \
	ssh \
	subversion \
	texinfo \
	'

RUN apt-get update && \
	apt-get install -y \
		$DEPS

COPY gmp-6.1.2.tar.bz2 .
RUN tar jxf gmp-6.1.2.tar.bz2

WORKDIR gmp-6.1.2

RUN CFLAGS="-static -std=c99 -O2 -W -Wall" LDFLAGS="-s" ./configure --enable-static --prefix=/pkg/gmp &&  \
	make install check

WORKDIR ..

COPY ./cado-nfs-2.3.0.tar.gz .
RUN tar zxf cado-nfs-2.3.0.tar.gz

WORKDIR cado-nfs-2.3.0

RUN make install CFLAGS="-static -std=c99 -O2 -W -Wall" CXXFLAGS="-static -std=c++11 -O2" LDFLAGS="-s" PREFIX=/pkg/cado GMP=/pkg/gmp

FROM alpine:latest as cado-build
COPY --from=buildenv /pkg /pkg


# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.
FROM cado-build as cado

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
	apk add tzdata && \
	cp /usr/share/zoneinfo/US/Eastern /etc/localtime && \
	apk del tzdata && \
	adduser -D cado
