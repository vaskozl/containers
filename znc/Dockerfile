FROM znc:1.8.2

WORKDIR /build

RUN wget https://raw.githubusercontent.com/jreese/znc-push/master/push.cpp && \
  /opt/znc/bin/znc-buildmod push.cpp
RUN wget https://raw.githubusercontent.com/CyberShadow/znc-clientbuffer/master/clientbuffer.cpp && \
  /opt/znc/bin/znc-buildmod clientbuffer.cpp


FROM znc:1.8.2-slim
COPY --from=0 /build/*.so /opt/znc/lib/znc/

USER znc
CMD ["/opt/znc/bin/znc", "--foreground", "--datadir", "/znc-data"]
