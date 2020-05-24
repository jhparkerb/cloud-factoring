FROM build as build_llr

COPY --from=gmp /pkg/gmp /pkg/gmp
COPY --chown=build:build llr38nsrc.zip .

# The contents of the zipfile are misnamed!
# The file is very slow to download so it's cached.
RUN unzip llr38nsrc.zip && \
  mv llr38nrsc llr38nsrc

WORKDIR llr38nsrc/linux64llr

RUN ln -sf /pkg/gmp/lib/libgmp.a .

RUN make

FROM scratch as pkg_llr
COPY --from=build_llr /home/build/llr38nsrc/linux64llr/sllr64 /pkg/llr/bin/llr64

FROM alpine:latest as llr
COPY --from=pkg_llr /pkg/llr /pkg/llr
