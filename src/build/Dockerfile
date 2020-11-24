FROM debian:buster AS build

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
  flex \
  git \
  libcurl4-openssl-dev \
  libtool \
  make \
  mercurial \
  python \
  python3 \
  rsync \
  ssh \
  subversion \
  texinfo \
  unzip \
  vim-tiny \
  zlib1g-dev \
  '

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends $DEPS && \
  useradd -m build

RUN mkdir -p /pkg
RUN chown -R build:build /pkg

USER build
WORKDIR /home/build
