FROM build as build_ggnfs

# install gmp
COPY --from=gmp /pkg/gmp /pkg/gmp

# RUN svn checkout https://svn.code.sf.net/p/openpfgw/code/ openpfgw
RUN curl -L -O 'https://github.com/radii/ggnfs/archive/master.zip' && \
	unzip master.zip

COPY ggnfs.patch .
WORKDIR ggnfs-master

# patch
RUN patch -p1 < ../ggnfs.patch

# build is expected to fail eventually
RUN make -k x86_64 || true

# build asm sievers
WORKDIR src/experimental/lasieve4_64/athlon64
RUN make && \
	make liblasieve.a && \
	make liblasieveI11.a && \
	make liblasieveI12.a && \
	make liblasieveI13.a && \
	make liblasieveI14.a && \
	make liblasieveI15.a && \
	make liblasieveI16.a && \
	cp *.a .. && \
	cd .. && \
	ln -s athlon64 asm && \
	make

# copy asm sievers into place
WORKDIR ../../../..
RUN cp -f src/experimental/lasieve4_64/gnfs-lasieve4I* bin

FROM scratch as pkg_ggnfs
COPY --from=build_ggnfs /home/build/ggnfs-master/bin/* /pkg/ggnfs/bin/

FROM alpine:latest as ggnfs
COPY --from=pkg_ggnfs /pkg/ggnfs /pkg/ggnfs

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
	adduser -D ggnfs

USER ggnfs
WORKDIR /home/ggnfs
