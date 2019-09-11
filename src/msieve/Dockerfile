FROM build as build_msieve

# install gmp & ecm
COPY --from=gmp /pkg/gmp /pkg/gmp
COPY --from=ecm /pkg/ecm /pkg/ecm

# RUN svn checkout https://svn.code.sf.net/p/openpfgw/code/ openpfgw
RUN curl -L -O 'https://sourceforge.net/projects/msieve/files/msieve/Msieve%20v1.53/msieve153_src.tar.gz' && \
	tar zxf msieve153_src.tar.gz

WORKDIR msieve-1.53

RUN make all CC='gcc -march=native -I/pkg/gmp/include -L/pkg/gmp/lib -I/pkg/ecm/include -L/pkg/ecm/lib' LDFLAGS='-static' GMP=1 ECM=1 NO_ZLIB=1 VBITS=256

FROM scratch as pkg_msieve
COPY --from=build_msieve /home/build/msieve-1.53/msieve /pkg/msieve/bin/
COPY --from=build_msieve /home/build/msieve-1.53/include/* /pkg/msieve/include/
COPY --from=build_msieve /home/build/msieve-1.53/libmsieve.a /pkg/msieve/lib/

FROM alpine:latest as msieve
COPY --from=pkg_msieve /pkg/msieve /pkg/msieve

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
	adduser -D msieve

USER msieve
WORKDIR /home/msieve
