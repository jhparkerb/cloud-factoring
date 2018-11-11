FROM debian:buster-slim as ecmnet-build
LABEL maintainer "Jason Parker-Burlingham <jasonp@panix.com>"

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		libgmp3-dev \
		subversion \
		unixodbc-dev

RUN svn checkout https://svn.code.sf.net/p/ecmnet/code/ ecmnet

WORKDIR ecmnet/source

RUN make

WORKDIR ../..

RUN mkdir -p /pkg/ecmnet/bin && \
	cp ecmnet/source/ecmclient /pkg/ecmnet/bin && \
	cp ecmnet/source/ecmserver /pkg/ecmnet/bin

RUN useradd -d /home/ecmnet -m -p '*' ecmnet

COPY database.ini ecmserver.b1 ecmserver.ini \
	/home/ecmnet/
