FROM build as build_llr

COPY --from=gmp /pkg/gmp /pkg/gmp

COPY --chown=build:build llr38nsrc.zip .

# The contents of the zipfile are misnamed!
RUN unzip llr38nsrc.zip && \
	mv llr38nrsc llr38nsrc

WORKDIR llr38nsrc/linux64llr

# Adding these tweaks to the build process is enough to break the resulting
# binary such that it seems to endlessy fail to start testing and restart
# over and over.
# RUN sed -i -e's/-O2/-O2 -march=native/' ../gwnum/make64
# RUN echo '\ngwbench.o: CFLAGS = -I.. -I../sqlite-amalgamation-3180000 -DSQLITE_OMIT_LOAD_EXTENSION -DX86_64 -Wno-unused-result -O2\n' >> ../gwnum/make64
# RUN sed -i -e's/-O2/-O2 -march=native/' ../make64

RUN ln -sf /pkg/gmp/lib/libgmp.a .

RUN make

FROM scratch as pkg_llr
COPY --from=build_llr /home/build/llr38nsrc/linux64llr/sllr64 /pkg/llr/bin/llr64

FROM alpine:latest as llr
COPY --from=pkg_llr /pkg/llr /pkg/llr
