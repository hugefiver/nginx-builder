.PHONY: get-nginx get-ssl get-zlib get-pcre build-ssl get-brotli set-pcre

nginx = nginx-1.26.1
nginx_path = $(lib_path)/$(nginx)
nginx_url = https://nginx.org/download/nginx-1.26.1.tar.gz
nginx_file = lib/nginx.tar.gz

zlib = zlib-1.3.1
zlib_url = http://zlib.net/zlib-1.3.1.tar.gz
zlib_file = lib/$(zlib).tar.gz

pcre = pcre2-10.43
pcre_url = https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.43/pcre2-10.43.tar.gz
pcre_file = lib/$(pcre).tar.gz

brotli = brotli
brotli_url = https://github.com/google/ngx_brotli.git
brotli_lib = lib/brotli

aio = libaio
aio_url = https://pagure.io/libaio/archive/libaio-0.3.113/libaio-libaio-0.3.113.tar.gz
aio_file = lib/libaio.tar.gz

boringssl = boringssl
ssl_lib = $(boringssl)/.openssl/lib
ssl_include = $(boringssl)/.openssl/include/openssl

get-nginx:
	curl -L $(nginx_url) -o $(nginx_file)
	tar zxf $(nginx_file) -C lib
	rm $(nginx_file)

get-ssl:
	# if [ -d "$(lib_path)/$(boringssl)" ]; then \
	# 	cd $(lib_path)/$(boringssl) && \
	# 	git pull --recurse-submodules; \
	# else \
	# 	git clone --depth 1 https://github.com/google/boringssl.git $(lib_path)/$(boringssl); \
	# fi;

	if [ -d "$(lib_path)/$(boringssl)" ]; then \
		cd $(lib_path)/$(boringssl) && \
		git fetch origin master;\
	else \
		git clone --branch master  https://github.com/google/boringssl.git $(lib_path)/$(boringssl); \
	fi;
	cd $(lib_path)/$(boringssl) && \
	git reset --hard 0568c2c1dbff4e1de4d5a63fbaf7d13925df27fa
	git submodule update --init --recursive
	
get-zlib:
	curl -L $(zlib_url) -o $(zlib_file)
	tar zxf $(zlib_file) -C lib
	rm $(zlib_file)

get-pcre:
	curl -L $(pcre_url) -o $(pcre_file)
	tar zxf $(pcre_file) -C lib
	rm $(pcre_file)

get-brotli:
	if [ -d "$(brotli_lib)" ]; then \
		cd $(brotli_lib) && \
		git pull --recurse-submodules; \
	else \
		git clone --depth 1 $(brotli_url) $(brotli_lib); \
		cd $(brotli_lib) && \
			git submodule update --init && \
			chmod +x config filter/config static/config; \
	fi;

build-ssl:
	cd $(lib_path)/$(boringssl) && \
		mkdir -p build .openssl/lib
	cd $(lib_path)/$(boringssl) && \
		ln -sf `pwd`/include .openssl/ \
		# && touch .openssl/include/openssl/ssl.h
	cd $(lib_path)/$(boringssl) && cmake -S ./ -B build/ -DCMAKE_BUILD_TYPE=Release
	# cd $(lib_path)/$(boringssl) && make -C build/ -j $(compile_process)
	cd $(lib_path)/$(boringssl) && make -C build/ -j $(compile_process) ssl crypto
	cd $(lib_path)/$(boringssl) && \
		cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib

set-pcre:
	cd $(lib_path)/$(pcre) && \
	./configure --enable-jit 
