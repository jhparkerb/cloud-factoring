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

#	LFLAGS_SERVER="-static -static-libgcc -static-libstdc++ -o" \
#	LFLAGS_SERVER2="-lodbc -lgmp -lpthread -lltdl -ldl -lc" \
#	LFLAGS_CLIENT="-static -static-libgcc -static-libstdc++ -o" \
#	LFLAGS_CLIENT2="-lpthread"

WORKDIR ../..

RUN mkdir -p /pkg/ecmnet/bin && \
	cp ecmnet/source/ecmclient /pkg/ecmnet/bin && \
	cp ecmnet/source/ecmserver /pkg/ecmnet/bin

RUN useradd -d /home/ecmnet -m -p '*' ecmnet

COPY database.ini ecmserver.b1 ecmserver.ini \
	/home/ecmnet/

# $ /pkg/ecmnet/bin/ecmserver -d
# [2018-11-09 02:43:43] 2: ODBC Connection via a driver: <Driver={SQLite3};Server=;Port=0;Database=/home/ecmnet/ecmnet.db;User=;UID=;Option=3;>
# [2018-11-09 02:43:43] 2: ODBC Information: SQL_SUCCESS_WITH_INFO: 
# [2018-11-09 02:43:43] 2: ODBC Information: SQL_SUCCESS_WITH_INFO: 
# [2018-11-09 02:43:43] PRPNet does not support SQLite databases

