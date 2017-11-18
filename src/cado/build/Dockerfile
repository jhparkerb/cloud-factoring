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

FROM alpine:latest
COPY --from=buildenv /pkg /pkg
