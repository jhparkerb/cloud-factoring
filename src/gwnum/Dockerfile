FROM build as build_gwnum

RUN curl -L -O \
  'https://www.mersenne.org/ftp_root/gimps/p95v298b3.source.zip' && \
    unzip -d mprime p95v298b3.source.zip || true

WORKDIR mprime/gwnum

RUN sed -i -e's/-O2/-Ofast -march=native/g' make64 && \
	echo '\ngwbench.o : CFLAGS := $(subst -Ofast,-O2,$(CFLAGS))' >> make64 && \
	make -f make64

FROM scratch as gwnum
COPY --from=build_gwnum /home/build/mprime/gwnum/gwnum.a /pkg/gwnum/lib/gwnum.a
