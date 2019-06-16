FROM build as build_srsieve

COPY sr2sieve-2.0.0.7z .
RUN 7z x sr2sieve-2.0.0.7z

WORKDIR sr2sieve_2.0.0

RUN make CFLAGS='-march=native -Ofast' LDFLAGS='-static'

FROM scratch as pkg_srsieve
COPY --from=build_srsieve /home/build/sr2sieve_2.0.0/sr2sieve /pkg/srsieve/bin/sr2sieve

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
