FROM debian:buster-slim as ecmnet
LABEL maintainer "Jason Parker-Burlingham <jasonp@panix.com>"

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		gmp-ecm \
		iputils-ping \
		libgmp3-dev \
		odbc-postgresql \
		subversion \
		telnet \
		unixodbc-dev \
		vim

RUN svn checkout https://svn.code.sf.net/p/ecmnet/code/ ecmnet

WORKDIR ecmnet/source

COPY *.patch ./

RUN patch -l < ecmadmin.patch && \
	patch -l < WorkSender.patch && \
	make && make ecmadmin

WORKDIR ../..

RUN mkdir -p /pkg/ecmnet/bin && \
	cp ecmnet/source/ecmclient \
		ecmnet/source/ecmserver \
		ecmnet/source/ecmadmin \
		/pkg/ecmnet/bin

RUN useradd -d /home/ecmnet -m -p '*' ecmnet

COPY --chown=ecmnet:ecmnet \
	database.ini ecmserver.b1 ecmserver.ini ecmclient.ini \
	input \
	/home/ecmnet/

USER ecmnet
WORKDIR /home/ecmnet
CMD /pkg/ecmnet/bin/ecmserver -d
