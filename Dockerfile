FROM fedora:latest AS base

FROM base AS build

RUN dnf install -y make cmake clang git golang glibc-static libstdc++-static
WORKDIR /build
ADD . .

RUN make dep
RUN export CC=clang CXX=clang++ && \
    make build-ssl
RUN export CC=clang CXX=clang++ && \
    make build && \
    make DESTDIR=/tmp/nginx install
COPY conf/nginx.conf /tmp/nginx/etc/nginx/


FROM base

WORKDIR /tmp/build
RUN useradd --system -U nginx
RUN mkdir -p /etc/nginx/conf.d /usr/lib64/nginx 
    # /opt/nginx /var/log/nginx /opt/nginx/log
# COPY --from=build /build/lib/nginx*/conf /etc/nginx/
# COPY --from=build /build/lib/nginx*/objs/nginx /opt/nginx/
COPY --from=build /tmp/nginx /

ENTRYPOINT ["nginx"]
