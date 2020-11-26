FROM build as build_openmpi

COPY --from=hwloc /pkg/hwloc /pkg/hwloc

ENV VERSION 4.0.5

RUN curl -L -O \
  https://download.open-mpi.org/release/open-mpi/v${VERSION%.*}/openmpi-${VERSION}.tar.bz2 && \
    tar xf openmpi-${VERSION}.tar.bz2

WORKDIR openmpi-${VERSION}

RUN ./configure \
    --prefix=/pkg/openmpi \
    --with-hwloc=/pkg/hwloc \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' && \
  make -s -j$(nproc) all && \
  make -s install

FROM scratch as openmpi
COPY --from=build_openmpi /pkg/openmpi /pkg/openmpi
