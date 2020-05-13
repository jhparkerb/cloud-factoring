FROM build as build_openpfgw

# install gmp
COPY --from=gmp /pkg/gmp /pkg/gmp

# install gwnum
COPY --from=gwnum /pkg/gwnum /pkg/gwnum

RUN svn checkout https://svn.code.sf.net/p/openpfgw/code/ openpfgw

WORKDIR openpfgw

RUN ln -s /pkg/gmp/lib/libgmp.a packages/gmp/64bit
RUN ln -s /pkg/gmp/include/gmp* packages/gmp/64bit
RUN ln -s /pkg/gwnum/lib/gwnum.a packages/gwnum/64bit
RUN sed -i 's/-Wl,-no_pie//g' makefile

RUN make IS64=1 CFLAGS='-static -Ofast -march=native -m64 -DX86_64 -D_64BIT -I../../packages/gmp/64bit -I../../pform/primesieve' CXXFLAGS='$(CFLAGS) -I../../pfconfig/headers'

FROM scratch as pkg_openpfgw
COPY --from=build_openpfgw /home/build/openpfgw/pfgw64 /pkg/openpfgw/bin/pfgw64

FROM alpine:latest as openpfgw
COPY --from=pkg_openpfgw /pkg/openpfgw /pkg/openpfgw

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
  adduser -D openpfgw

USER openpfgw
WORKDIR /home/openpfgw
