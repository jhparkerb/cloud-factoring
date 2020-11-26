FROM build as build_hwloc

RUN curl -L -O \
  https://download.open-mpi.org/release/hwloc/v2.3/hwloc-2.3.0.tar.bz2 && \
    tar xf hwloc-2.3.0.tar.bz2

WORKDIR hwloc-2.3.0

RUN ./configure \
    --prefix=/pkg/hwloc \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' && \
  make -s -j$(nproc) all && \
  make -s install

FROM scratch as hwloc
COPY --from=build_hwloc /pkg/hwloc /pkg/hwloc
