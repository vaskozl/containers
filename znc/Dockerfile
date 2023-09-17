FROM znc:1.8.2

WORKDIR /build

RUN wget https://raw.githubusercontent.com/jreese/znc-push/master/push.cpp && \
  /opt/znc/bin/znc-buildmod push.cpp

FROM znc:1.8.2-slim
COPY --from=0 /build/push.so /opt/znc/lib64/znc/push.so

USER znc
CMD ["/opt/znc/bin/znc", "--foreground", "--datadir", "/znc-data"]
