FROM debian:buster-slim AS build

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

ENV DEPS ' \
	autoconf \
	automake \
	binutils \
	bison \
	ca-certificates \
	clang \
	cmake \
	curl \
	dpkg-dev \
	git \
	libtool \
	make \
	mercurial \
	python \
	python3 \
	rsync \
	ssh \
	subversion \
	texinfo \
	'

RUN apt-get update && \
	apt-get install -y $DEPS --no-install-recommends && \
	useradd -m build

RUN mkdir -p /pkg
RUN chown -R build:build /pkg

USER build
WORKDIR /home/build
