FROM build as build_ecm

COPY --from=gmp /pkg/gmp /pkg/gmp
COPY --from=openmpi /pkg/openmpi /pkg/openmpi

RUN svn checkout -r 3085 https://scm.gforge.inria.fr/anonscm/svn/ecm/trunk ecm

WORKDIR ecm

# configure and build CFLAGS and LDFLAGS courtesy
# https://stackoverflow.com/questions/20068947/
#   how-to-static-link-linux-software-that-uses-configure
RUN autoreconf -i && \
  ./configure CFLAGS='-static -Ofast -march=native' --prefix=/pkg/ecm \
    --with-gmp=/pkg/gmp \
    --with-openmpi=/pkg/openmpi \
    --enable-static && \
  make LDFLAGS='-all-static' && \
  make ecm-params && \
  make LDFLAGS='-all-static' && \
  make install && \
  cp ecmfactor /pkg/ecm/bin

FROM scratch as pkg_ecm
COPY --from=build_ecm /pkg/ecm /pkg/ecm

FROM alpine:latest as ecm
COPY --from=pkg_ecm /pkg/ecm /pkg/ecm

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
  apk add $NON_ESSENTIAL && \
  cp /usr/share/zoneinfo/US/Eastern /etc/localtime && \
  apk del tzdata && \
  adduser -D ecm

USER ecm
WORKDIR /home/ecm
