FROM build as build_gmp

ENV VERSION 6.2.1

RUN curl -L -O https://ftp.gnu.org/gnu/gmp/gmp-${VERSION}.tar.bz2 && \
  tar jxf gmp-${VERSION}.tar.bz2

WORKDIR gmp-${VERSION}

RUN CFLAGS='-O3 -march=native -W -Wall' \
  CXXFLAGS='-O3 -march=native -W -Wall' \
  ./configure \
    --enable-cxx \
    --prefix=/home/build/pkg/gmp &&  \
  make -s -j$(nproc)

WORKDIR tune

RUN make tuneup && \
  ./tuneup > tee ../mpn/x86_64/zen/gmp-mparam.h

WORKDIR ..

RUN make clean
RUN CFLAGS='-O3 -march=native -W -Wall' \
  CXXFLAGS='-O3 -march=native -W -Wall' \
  ./configure \
    --enable-cxx \
    --prefix=/home/build/pkg/gmp &&  \
  make -s -j$(nproc) && \
  make -s check && \
  make -s install

FROM scratch as gmp
COPY --from=build_gmp /home/build/pkg/gmp /pkg/gmp
