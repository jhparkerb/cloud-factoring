FROM build as build_srsieve

COPY srsieve-0.6.17-src.zip .
RUN unzip srsieve-0.6.17-src.zip

RUN make LDFLAGS='-static'

FROM scratch as pkg_srsieve
COPY --from=build_srsieve /home/build/srsieve /pkg/srsieve/bin/srsieve

FROM alpine:latest as srsieve
COPY --from=pkg_srsieve /pkg/srsieve /pkg/srsieve

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
	adduser -D srsieve

USER srsieve
WORKDIR /home/srsieve
