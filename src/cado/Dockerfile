### set up build environment
FROM debian:testing-slim as build

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
  g++ \
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
  zlib1g-dev \
  '

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
		$DEPS && \
  useradd -m build

RUN mkdir -p /pkg
RUN chown -R build:build /pkg

USER build
WORKDIR /home/build

### install HWLoc
USER root
RUN apt-get -y install flex
USER build

# RUN curl -L -O 'https://download.open-mpi.org/release/hwloc/v2.1/hwloc-2.1.0.tar.bz2' && tar xf hwloc-2.1.0.tar.bz2

# WORKDIR hwloc-2.1.0

RUN curl -L -O 'https://download.open-mpi.org/release/hwloc/v1.11/hwloc-1.11.13.tar.bz2' && tar xf hwloc-1.11.13.tar.bz2

WORKDIR hwloc-1.11.13

RUN ./configure --prefix=/pkg \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' && \
  make -s -j$(nproc) all && \
  make -s install

WORKDIR ..

### install OpenMPI
USER root
RUN apt-get -y install flex
USER build

COPY --from=hwloc /pkg/hwloc /pkg/hwloc

RUN curl -L -O 'https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.bz2' && tar xf openmpi-4.0.2.tar.bz2

WORKDIR openmpi-4.0.2

RUN ./configure --prefix=/pkg \
    --with-hwloc=/pkg \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' \
    && \
  make -s -j$(nproc) all && \
  make -s install

WORKDIR ..

### install GMP
RUN curl -L -O 'https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2' && \
  tar jxf gmp-6.1.2.tar.bz2

WORKDIR gmp-6.1.2

# TODO:  are the std flags really required or useful?
RUN CFLAGS="-std=c99 -Ofast -march=native -W -Wall" \
  CXXFLAGS="-std=c++11 -Ofast -march=native -W -Wall" \
  ./configure \
    --enable-cxx \
    --prefix=/pkg &&  \
  make -j$(nproc) install

WORKDIR ..

### install GMP-ECM
RUN svn checkout svn://scm.gforge.inria.fr/svnroot/ecm/trunk ecm
# COPY ecm-7.0.4.tar.gz .

WORKDIR ecm

RUN autoreconf -i && \
  ./configure CFLAGS='-Ofast -march=native' --prefix=/pkg \
    --with-gmp=/pkg \
    --with-openmpi=/pkg && \
  make && \
  make ecm-params && \
  make && \
  make install

WORKDIR ..

RUN git clone https://scm.gforge.inria.fr/anonscm/git/cado-nfs/cado-nfs.git

WORKDIR cado-nfs

RUN make -j$(nproc) install \
  FLAGS_SIZE="-DSIZEOF_P_R_VALUES=8 -DSIZEOF_INDEX=8" \
  CFLAGS="-Ofast -march=native -W -Wall -DNDEBUG" \
  CXXFLAGS="-Ofast -march=native -W -Wall -DNDEBUG" \
  GMPECM="/pkg" \
  GMP="/pkg" \
  HWLOC="/pkg" \
  MPI="/pkg" \
  PREFIX="/pkg"

FROM debian:testing-slim as cado
COPY --from=build /pkg /pkg

# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.

ENV DEPS ' \
  curl \
  gzip \
  libgomp1 \
  openssl \
  ssh \
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

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
		$DEPS $NON_ESSENTIAL && \
  useradd -m cado

USER cado
WORKDIR /home/cado
