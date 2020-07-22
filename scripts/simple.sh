#! /bin/sh

./configure \
--prefix=/opt/nginx \
--sbin-path=/usr/sbin/nginx \
--user=nginx --group=nginx \
--modules-path=/usr/lib64/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/run/nginx.pid \
--lock-path=/run/lock/subsys/nginx \
--with-cc-opt="-static -static-libgcc" \
--with-ld-opt="-static" \
--with-file-aio \
--with-stream \
--with-stream_ssl_module \
--with-http_auth_request_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-pcre --with-pcre-jit \
--with-zlib=../zlib-1.2.11 \
--with-openssl=../boringssl 
