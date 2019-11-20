FROM build as build_gmp

RUN curl -L -O 'https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2' && \
  tar jxf gmp-6.1.2.tar.bz2

WORKDIR gmp-6.1.2

# TODO:  are the std flags really required or useful?
RUN CFLAGS="-static -std=c99 -Ofast -march=native -W -Wall" \
  CXXFLAGS="-static -std=c++11 -Ofast -march=native -W -Wall" \
  LDFLAGS="-static" \
  ./configure \
    --enable-static \
    --enable-cxx \
    --prefix=/home/build/pkg/gmp &&  \
  make -j$(nproc) install

FROM scratch as gmp
COPY --from=build_gmp /home/build/pkg/gmp /pkg/gmp
