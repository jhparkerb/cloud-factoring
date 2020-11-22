FROM build as build

COPY --from=hwloc /pkg/hwloc /pkg/hwloc
COPY --from=openmpi /pkg/openmpi /pkg/openmpi
COPY --from=gmp /pkg/gmp /pkg/gmp

RUN git clone https://gitlab.inria.fr/cado-nfs/cado-nfs.git

WORKDIR cado-nfs

# This is a known-good commit, found at
# https://cado-nfs-ci.loria.fr/ci/job/master/job/compile-debian-9-amd64/lastSuccessfulBuild/
RUN git checkout 67de595909cf4cecc9692ff767c1472972b8ca65
#RUN git checkout 98854840d6aaa889c568523a76cce096e91b942f

RUN make -s -j$(nproc) install \
  FLAGS_SIZE='-DSIZEOF_P_R_VALUES=8 -DSIZEOF_INDEX=8' \
  CFLAGS='-Ofast -march=native -W -Wall -DNDEBUG' \
  CXXFLAGS='-Ofast -march=native -W -Wall -DNDEBUG' \
  GMP='/pkg/gmp' \
  HWLOC='/pkg/hwloc' \
  MPI='/pkg/openmpi' \
  PREFIX='/pkg/cado'

FROM debian:testing-slim as cado
COPY --from=build /pkg /pkg

ENV DEPS ' \
  curl \
  gzip \
  libgomp1 \
  openssl \
  perl \
  python \
  python3 \
  ssh \
  tzdata \
  '

ENV NONESSENTIAL ' \
  bc \
  less \
  ltrace \
  strace \
  vim \
  '

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
    $DEPS $NONESSENTIAL && \
  useradd -m cado

USER cado
ENV LD_LIBRARY_PATH /pkg/lib
ENV TZ 'US/Eastern'
WORKDIR /home/cado
