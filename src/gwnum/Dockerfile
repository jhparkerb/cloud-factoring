FROM build as build_gwnum

RUN curl -L -O 'https://www.mersenne.org/ftp_root/gimps/p95v298b3.source.zip' && \
  unzip -d mprime p95v298b3.source.zip || true

WORKDIR mprime/gwnum

RUN make -f make64

FROM scratch as gwnum
COPY --from=build_gwnum /home/build/mprime/gwnum/gwnum.a /pkg/gwnum/lib/gwnum.a
