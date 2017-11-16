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

COPY cado-nfs-2.3.0.tar.gz .
RUN tar zxf cado-nfs-2.3.0.tar.gz

WORKDIR gmp-6.1.2

RUN ./configure --prefix=/pkg/gmp &&  \
	make install check

WORKDIR ..
WORKDIR cado-nfs-2.3.0

RUN make install PREFIX=/pkg/cado GMP=/pkg/gmp

FROM debian:jessie-slim
COPY --from=buildenv /pkg /pkg
