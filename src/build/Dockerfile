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
  flex \
  g++-10 \
  gcc-10 \
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
  dpkg --purge gcc g++ && \
  useradd -m build

RUN gcc-10 --version | fgrep -q ' 10.'
RUN mkdir -p /pkg
RUN chown -R build:build /pkg

USER build
WORKDIR /home/build
