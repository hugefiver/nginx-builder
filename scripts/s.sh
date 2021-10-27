./configure \
	--prefix=/opt/nginx \
	--sbin-path=/usr/sbin/nginx \
	--user=nginx --group=nginx \
	--modules-path=/usr/lib64/nginx/modules \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--with-file-aio \
	--with-stream \
	--with-stream_ssl_module \
	--with-stream_ssl_preread_module \
	--with-http_auth_request_module \
	--with-http_ssl_module \
	--with-http_v2_module \
	--with-http_realip_module \
	--with-http_addition_module \
	--with-pcre=../pcre-8.45 --with-pcre-jit \
	--with-zlib=../zlib-1.2.11 \
	--with-openssl=../boringssl

	# --with-cc-opt="-static -O2" \
	# --with-ld-opt="-static" \