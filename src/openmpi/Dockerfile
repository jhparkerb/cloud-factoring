FROM build as build_openmpi

COPY --from=hwloc /pkg/hwloc /pkg/hwloc

RUN curl -L -O \
  https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.bz2 && \
    tar xf openmpi-4.0.3.tar.bz2

WORKDIR openmpi-4.0.3

RUN ./configure \
    --prefix=/pkg/openmpi \
    --with-hwloc=/pkg/hwloc \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' && \
  make -s -j$(nproc) all && \
  make -s install

FROM scratch as openmpi
COPY --from=build_openmpi /pkg/openmpi /pkg/openmpi
