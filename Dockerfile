FROM ubuntu-debootstrap:14.04
MAINTAINER Marcin Jasion <marcinjasion@gmail.com>

RUN   echo "Europe/Warsaw" > /etc/timezone && \
      locale-gen en_US.UTF-8 && \
      dpkg-reconfigure --frontend noninteractive tzdata && \
      dpkg-reconfigure locales

ENV NGINX_VERSION 1.8.0
ENV OPENSSL_VERSION openssl-1.0.2a
ENV MODULESDIR /usr/src/nginx-modules
ENV NPS_VERSION 1.9.32.3
ENV DEBIAN_FRONTEND noninteractive

# Install Nginx.
RUN sed -i 's/archive/pl\.archive/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install nano git build-essential cmake zlib1g-dev libpcre3 libpcre3-dev unzip wget -y --no-install-recommends && \
    apt-get dist-upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd nginx && \
    mkdir -p ${MODULESDIR} && \
    mkdir -p /data/{config,ssl,logs} && \
    cd /usr/src/ && \
    wget -O- http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar zx && \
    wget -O- http://www.openssl.org/source/${OPENSSL_VERSION}.tar.gz | tar zx && \
    cd ${MODULESDIR} && \
    wget --no-check-certificate https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip && \
    unzip release-${NPS_VERSION}-beta.zip && \
    rm release-${NPS_VERSION}-beta.zip && \
    cd ${MODULESDIR}/ngx_pagespeed-release-${NPS_VERSION}-beta/ && \
    wget --no-check-certificate -O- https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz | tar zx

# Compile nginx
RUN cd /usr/src/nginx-${NGINX_VERSION} && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/data/logs/error.log \
        --http-log-path=/data/logs/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --with-http_ssl_module \
        --with-http_addition_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-file-aio \
        --with-http_spdy_module \
        --with-sha1='../${OPENSSL_VERSION}' \
        --with-md5='../${OPENSSL_VERSION}' \
        --with-openssl='../${OPENSSL_VERSION}' \
        --add-module=${MODULESDIR}/ngx_pagespeed-release-${NPS_VERSION}-beta && \
    cd /usr/src/nginx-${NGINX_VERSION} && make && make install
RUN mkdir /var/ngx_pagespeed_cache

ADD   *.conf /etc/nginx/
ADD   conf/* /etc/nginx/conf.d/

ADD   logrotate.d/* /etc/logrotate.d/
RUN   chmod 644 /etc/logrotate.d/*

VOLUME ["/var/log/nginx"]

EXPOSE 80 443 8080 8443

CMD   nginx -g "daemon off;"
