FROM build as build_hwloc

RUN curl -L -O \
  https://download.open-mpi.org/release/hwloc/v1.11/hwloc-1.11.13.tar.bz2 && \
    tar xf hwloc-1.11.13.tar.bz2

WORKDIR hwloc-1.11.13

RUN ./configure \
    --prefix=/pkg/hwloc \
    --disable-dlopen \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' && \
  make -s -j$(nproc) all LDFLAGS='-all-static -lpthread' && \
  make -s install

FROM scratch as hwloc
COPY --from=build_hwloc /pkg/hwloc /pkg/hwloc
