FROM golang:1.14

ENV EXPORTER_VERSION=1.2.1

ADD https://github.com/saphoooo/freebox_exporter/archive/v${EXPORTER_VERSION}.tar.gz /

RUN mkdir /code && tar -xzf /v${EXPORTER_VERSION}.tar.gz -C /code

WORKDIR /code/freebox_exporter-${EXPORTER_VERSION}

ADD https://github.com/upx/upx/releases/download/v3.95/upx-3.95-amd64_linux.tar.xz /usr/local

RUN set -x && \
    apt-get update && \
    apt-get install -y xz-utils && \
    xz -d -c /usr/local/upx-3.95-amd64_linux.tar.xz | \
    tar -xOf - upx-3.95-amd64_linux/upx > /bin/upx && \
    chmod a+x /bin/upx && \
    go get -d -v . && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app . && \
    strip --strip-unneeded app && \
    upx app && \
    cp app /


FROM scratch

COPY --from=0 app /

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/app"]
