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
	CFLAGS="-static -std=c99 -Ofast -march=native -W -Wall" \
	LDFLAGS="-static" \
	./configure --enable-static --prefix=/pkg/gmp &&  \
	make -j$(nproc) install

WORKDIR ..

RUN git clone https://scm.gforge.inria.fr/anonscm/git/cado-nfs/cado-nfs.git

WORKDIR cado-nfs

RUN make -j$(nproc) install \
	CADO_NFS_STATIC=1 \
	G2FX_CONFIGURE_EXTRA_FLAGS="--disable-shared" \
	CFLAGS="-static -std=c99 -Ofast -march=native -W -Wall" \
	CXXFLAGS="-static -std=c++11 -Ofast -march=native -W -Wall" \
	LDFLAGS="-static" \
	PREFIX="/pkg/cado" \
	GMP="/pkg/gmp"

FROM alpine:latest as cado-build
COPY --from=buildenv /pkg /pkg


# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.
FROM cado-build as cado

ENV DEPS ' \
	bind-tools \
	curl \
	gzip \
	openssl \
	perl \
	python \
	python3 \
	tzdata \
	'

ENV NON_ESSENTIAL ' \
	bc \
	less \
	vim \
	'

RUN apk update && \
	apk add $DEPS && \
	cp /usr/share/zoneinfo/US/Eastern /etc/localtime && \
	apk del tzdata && \
	adduser -D cado

USER cado
WORKDIR /home/cado
