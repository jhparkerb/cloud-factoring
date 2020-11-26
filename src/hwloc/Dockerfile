FROM build as build_hwloc

ENV VERSION 2.3.0

RUN curl -L -O \
  https://download.open-mpi.org/release/hwloc/v${VERSION%.*}/hwloc-${VERSION}.tar.bz2 && \
    tar xf hwloc-${VERSION}.tar.bz2

WORKDIR hwloc-${VERSION}

RUN ./configure \
    --prefix=/pkg/hwloc \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' && \
  make -s -j$(nproc) all && \
  make -s install

FROM scratch as hwloc
COPY --from=build_hwloc /pkg/hwloc /pkg/hwloc
