### set up build environment
FROM debian:testing-slim as build

### tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

ENV DEPS " \
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
  vim-tiny \
  zlib1g-dev \
  "

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends \
    $DEPS \
    && \
  useradd -m build

RUN mkdir -p /pkg
RUN chown -R build:build /pkg

USER build
WORKDIR /home/build

### install HWLoc
RUN curl -L -O "https://download.open-mpi.org/release/hwloc/v1.11/hwloc-1.11.13.tar.bz2" && tar xf hwloc-1.11.13.tar.bz2

WORKDIR hwloc-1.11.13

RUN ./configure \
    --prefix=/pkg \
    CFLAGS="-Ofast -march=native" \
    CXXFLAGS="-Ofast -march=native" \
    && \
  make -s -j$(nproc) all && \
  make -s install

WORKDIR ..

### install OpenMPI
RUN curl -L -O "https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.bz2" && tar xf openmpi-4.0.2.tar.bz2

WORKDIR openmpi-4.0.2

RUN ./configure \
    --prefix=/pkg \
    --with-hwloc=/pkg \
    CFLAGS="-Ofast -march=native" \
    CXXFLAGS="-Ofast -march=native" \
    && \
  make -s -j$(nproc) all && \
  make -s install

WORKDIR ..

### install GMP
RUN curl -L -O "https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.bz2" && \
  tar jxf gmp-6.2.0.tar.bz2

WORKDIR gmp-6.2.0

# TODO:  are the std flags really required or useful?
RUN ./configure \
    --prefix=/pkg \
    --enable-cxx \
    CFLAGS="-std=c99 -Ofast -march=native -W -Wall" \
    CXXFLAGS="-std=c++11 -Ofast -march=native -W -Wall" \
    && \
  make -s -j$(nproc) install

WORKDIR ..

RUN git clone https://gitlab.inria.fr/cado-nfs/cado-nfs.git
### install cado-nfs

WORKDIR cado-nfs

# a known-good commit, found at https://cado-nfs-ci.loria.fr/ci/job/master/job/compile-debian-9-amd64/lastSuccessfulBuild/
RUN git checkout 67de595909cf4cecc9692ff767c1472972b8ca65

RUN make -s -j$(nproc) install \
  FLAGS_SIZE="-DSIZEOF_P_R_VALUES=8 -DSIZEOF_INDEX=8" \
  CFLAGS="-Ofast -march=native -W -Wall -DNDEBUG" \
  CXXFLAGS="-Ofast -march=native -W -Wall -DNDEBUG" \
  GMP="/pkg" \
  HWLOC="/pkg" \
  MPI="/pkg" \
  PREFIX="/pkg"

### set up final container
FROM debian:testing-slim as cado
COPY --from=build /pkg /pkg

ENV DEPS " \
  curl \
  gzip \
  libgomp1 \
  openssl \
  perl \
  python \
  python3 \
  ssh \
  tzdata \
  "

ENV NONESSENTIAL " \
  bc \
  less \
  vim \
  "

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
    $DEPS $NONESSENTIAL && \
  useradd -m cado

USER cado
ENV LD_LIBRARY_PATH /pkg/lib
ENV TZ "US/Eastern"
WORKDIR /home/cado
