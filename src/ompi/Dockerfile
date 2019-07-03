FROM build as build_ompi

USER root
RUN apt-get -y install flex
USER build

RUN git clone -b v4.0.1 https://github.com/open-mpi/ompi.git

WORKDIR ompi

RUN ./autogen.pl && \
	./configure --prefix=/pkg/ompi \
		--disable-dlopen \
		--enable-shared=no \
		--enable-static=yes \
		CFLAGS='-Ofast -march=native' \
		CXXFLAGS='-Ofast -march=native' && \
	make -s -j$(nproc) all && \
	make -s install

FROM scratch as pkg_ompi
COPY --from=build_ompi /pkg/ompi /pkg/ompi

FROM alpine:latest as ompi
COPY --from=pkg_ompi /pkg/ompi /pkg/ompi
