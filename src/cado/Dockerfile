FROM build as build_cado

COPY --from=gmp /pkg/gmp /pkg/gmp

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

FROM scratch as pkg_cado
COPY --from=build_cado /pkg/cado /pkg/cado

FROM alpine:latest as cado
COPY --from=gmp /pkg/gmp /pkg/gmp
COPY --from=pkg_cado /pkg/cado /pkg/cado

# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.

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
