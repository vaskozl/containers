FROM znc:1.8.2-slim

# znc:slim removed them. Install them again.
RUN set -x \
    && apk add --no-cache \
        build-base \
        cmake \
        icu-dev \
        openssl-dev \
        perl \
        python3

RUN wget https://raw.githubusercontent.com/jreese/znc-push/master/push.cpp && \
  /opt/znc/bin/znc-buildmod push.cpp && \
  mv push.so /opt/znc/lib64/znc/ && \
  rm push.cpp

USER znc
CMD ["/opt/znc/bin/znc", "--foreground", "--datadir", "/znc-data"]
