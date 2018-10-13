# Build cado-nfs from source and install it into /pkg/cado.
FROM debian:buster-slim AS buildenv

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

ENV DEPS ' \
	autoconf \
	automake \
	binutils \
	bison \
	ca-certificates \
	clang \
	cmake \
	dpkg-dev \
	git \
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

RUN apt-get update && apt-get install -y \
	$DEPS \
	--no-install-recommends

RUN hg clone https://gmplib.org/repo/gmp/ gmp

WORKDIR gmp

RUN ./.bootstrap && \
	CFLAGS="-static -std=c99 -O3 -Ofast -W -Wall" \
	LDFLAGS="-s" \
	./configure --enable-static --prefix=/pkg/gmp &&  \
	make -j8 install

WORKDIR ..

RUN git clone https://scm.gforge.inria.fr/anonscm/git/cado-nfs/cado-nfs.git

WORKDIR cado-nfs

RUN make -j8 install \
	CFLAGS="-static -std=c99 -O3 -Ofast -W -Wall" \
	CXXFLAGS="-static -std=c++11 -O3 -Ofast -W -Wall" \
	LDFLAGS="-s" \
	PREFIX="/pkg/cado" \
	GMP="/pkg/gmp"

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
