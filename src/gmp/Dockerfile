FROM build as build_gmp

RUN curl -L -O 'https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.bz2' && \
  tar jxf gmp-6.2.0.tar.bz2

WORKDIR gmp-6.2.0

RUN CFLAGS='-static -O3 -march=native -W -Wall' \
  CXXFLAGS='-static -O3 -march=native -W -Wall' \
  LDFLAGS='-static' \
  ./configure \
    --enable-static \
    --enable-cxx \
    --prefix=/home/build/pkg/gmp &&  \
  make -j$(nproc)

WORKDIR tune

RUN make tuneup && \
	./tuneup | tee ../mpn/x86_64/zen/gmp-mparam.h

WORKDIR ..

RUN make clean
RUN CFLAGS='-static -O3 -march=native -W -Wall' \
  CXXFLAGS='-static -O3 -march=native -W -Wall' \
  LDFLAGS='-static' \
  ./configure \
    --enable-static \
    --enable-cxx \
    --prefix=/home/build/pkg/gmp &&  \
  make -j$(nproc) && \
  make check && \
  make install

FROM scratch as gmp
COPY --from=build_gmp /home/build/pkg/gmp /pkg/gmp
