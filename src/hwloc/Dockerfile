FROM build as build_hwloc

USER root
RUN apt-get -y install flex
USER build

RUN curl -L -O 'https://download.open-mpi.org/release/hwloc/v2.1/hwloc-2.1.0.tar.bz2' && tar xf hwloc-2.1.0.tar.bz2

WORKDIR hwloc-2.1.0

RUN ./configure --prefix=/pkg/hwloc \
		--disable-dlopen \
		--enable-shared=no \
		--enable-static=yes \
		CFLAGS='-Ofast -march=native' \
		CXXFLAGS='-Ofast -march=native' && \
	make -s -j$(nproc) all && \
	make -s install

FROM scratch as pkg_hwloc
COPY --from=build_hwloc /pkg/hwloc /pkg/hwloc

FROM alpine:latest as hwloc
COPY --from=pkg_hwloc /pkg/hwloc /pkg/hwloc
