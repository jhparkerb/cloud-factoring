FROM build as build_ecm

# install gmp
COPY --from=gmp /pkg/gmp /pkg/gmp

# RUN svn checkout https://svn.code.sf.net/p/openpfgw/code/ openpfgw
COPY ecm-7.0.4.tar.gz .

RUN tar zxf ecm-7.0.4.tar.gz

WORKDIR ecm-7.0.4

# configure and build CFLAGS and LDFLAGS courtesy
# https://stackoverflow.com/questions/20068947/
# 	how-to-static-link-linux-software-that-uses-configure
RUN ./configure CFLAGS='-static -Ofast -march=native' --prefix=/pkg/ecm \
		--with-gmp=/pkg/gmp \
		--enable-static && \
	make LDFLAGS='-all-static' && \
	make install

RUN cp ecmfactor /pkg/ecm/bin

### insert before `make install` when the build system is less loaded
#	make ecm-params && \
#	make && \

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
