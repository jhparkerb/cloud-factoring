FROM build as build_openmpi

USER root
RUN apt-get -y install flex
USER build

COPY --from=hwloc /pkg/hwloc /pkg/hwloc

RUN curl -L -O 'https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.bz2' && tar xf openmpi-4.0.2.tar.bz2

WORKDIR openmpi-4.0.2

RUN ./configure --prefix=/pkg/openmpi \
    --disable-dlopen \
    --enable-shared=no \
    --enable-static=yes \
    --with-hwloc=/pkg/hwloc \
    CFLAGS='-Ofast -march=native' \
    CXXFLAGS='-Ofast -march=native' \
    && \
  make -s -j$(nproc) all LDFLAGS='-all-static' && \
  make -s install

FROM scratch as pkg_openmpi
COPY --from=build_openmpi /pkg/openmpi /pkg/openmpi

FROM alpine:latest as openmpi
COPY --from=pkg_openmpi /pkg/openmpi /pkg/openmpi
