FROM build as build_yafu

COPY --from=gmp /pkg/gmp /pkg/gmp
COPY --from=ecm /pkg/ecm /pkg/ecm
COPY --from=msieve /pkg/msieve /pkg/msieve

RUN svn checkout -r 381 https://svn.code.sf.net/p/yafu/code/trunk yafu

COPY yafu.patch .

WORKDIR yafu

# patch makefiles
RUN patch < ../yafu.patch

RUN make x86_64 NFS=1 USE_SSE41=1

# consider patching yafu.ini

# fails with 'expected numeric input for option B1pm1'
# RUN ./yafu tune

FROM scratch as pkg_yafu
COPY --from=build_yafu /home/build/yafu /pkg/yafu/bin/
COPY ./yafu.ini /pkg/yafu/etc/

FROM alpine:latest as yafu
COPY --from=pkg_yafu /pkg/yafu /pkg/yafu

COPY --from=gmp /pkg/gmp /pkg/gmp
COPY --from=ecm /pkg/ecm /pkg/ecm
COPY --from=msieve /pkg/msieve /pkg/msieve
COPY --from=ggnfs /pkg/ggnfs /pkg/ggnfs

ENV DEPS ' \
  bind-tools \
  curl \
  gzip \
  openssl \
  perl \
  python \
  python3 \
  tzdata \
  zlib \
  '

ENV NON_ESSENTIAL ' \
  bc \
  gdb \
  less \
  subversion \
  vim \
  '

RUN apk update && \
  apk add $DEPS && \
  apk add $NON_ESSENTIAL && \
  cp /usr/share/zoneinfo/US/Eastern /etc/localtime && \
  apk del tzdata && \
  adduser -D yafu

USER yafu
WORKDIR /home/yafu
