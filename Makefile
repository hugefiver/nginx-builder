.PHONY: dep build install clean

include conf.mk requires.mk

.DEFAULT_GOAL := build

clean:
	cd $(lib_path); \
	rm -rf $(nginx_file) $(nginx) $(boringssl) $(zlib) $(pcre) $(brotli)

dep: get-nginx get-ssl get-zlib get-pcre get-brotli

build: set-pcre build-ssl
	cd $(nginx_path) && \
	./configure \
		--prefix=/opt/nginx \
		--sbin-path=/usr/sbin/nginx \
		--user=nginx --group=nginx \
		--modules-path=/usr/lib64/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--with-cc-opt='-Wno-error -O2 -I../$(boringssl)/.openssl/include' \
		--with-ld-opt='-L../$(boringssl)/.openssl/lib' \
		--with-file-aio \
		--with-stream \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-http_auth_request_module \
		--with-http_ssl_module \
		--with-http_v2_module \
		--with-http_v3_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-pcre=../$(pcre) --with-pcre-jit \
		--with-zlib=../$(zlib) \
		--add-module=../$(brotli)
		# --with-openssl=../$(boringssl) \
	touch $(lib_path)/$(boringssl)/include/openssl/ssl.h
	cd $(nginx_path) && \
		make -j $(compile_process)

install: 
	$(MAKE) -C $(nginx_path) install
