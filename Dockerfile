FROM fedora:latest AS base

RUN dnf install -y make


FROM base AS build

RUN dnf install -y make cmake clang git
WORKDIR /tmp/build
ADD . .

RUN make dep && \
    make build-ssl && \
    make build


FROM base

WORKDIR /tmp/build

COPY --from=build /tmp/build .
RUN make install

ENTRYPOINT [ "/opt/nginx/nginx"]
