FROM fedora:latest AS base

RUN dnf install -y make


FROM base AS build

RUN dnf install -y make cmake clang git golang
WORKDIR /tmp/build
ADD . .

RUN export CC=clang CXX=clang++ && \
    make dep && \
    make build-ssl && \
    make build


FROM base

WORKDIR /tmp/build

COPY --from=build /tmp/build .
RUN make install

ENTRYPOINT [ "/opt/nginx/nginx"]
