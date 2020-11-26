FROM build as build

COPY --from=hwloc /pkg/hwloc /pkg/hwloc
COPY --from=openmpi /pkg/openmpi /pkg/openmpi
COPY --from=gmp /pkg/gmp /pkg/gmp

RUN git clone https://gitlab.inria.fr/cado-nfs/cado-nfs.git && \
	cd cado-nfs && \
	git checkout 3dc7496d1fd72bc5f0be34bc7dcbd839e41efa82


WORKDIR cado-nfs

RUN FLAGS_SIZE='-DSIZEOF_P_R_VALUES=8 -DSIZEOF_INDEX=8' \
  CFLAGS='-Ofast -march=native -W -Wall -DNDEBUG' \
  CXXFLAGS='-Ofast -march=native -W -Wall -DNDEBUG' \
  GMP='/pkg/gmp' \
  HWLOC='/pkg/hwloc' \
  MPI='/pkg/openmpi' \
  PREFIX='/pkg/cado' \
	make -s -j$(nproc) install

FROM debian:buster as cado
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
