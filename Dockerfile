FROM ubuntu:14.04
MAINTAINER Marcin Jasion <marcinjasion@gmail.com>

ENV   NGINX_VERSION 1.8.0
ENV   NPS_VERSION 1.9.32.3

RUN   echo "Europe/Warsaw" > /etc/timezone && \
      locale-gen en_US.UTF-8 && \
      dpkg-reconfigure --frontend noninteractive tzdata && \
      dpkg-reconfigure locales

RUN   apt-get update && \
      apt-get install build-essential wget unzip -y && \
      apt-get build-dep nginx -y && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* && \
      useradd nginx && \

      cd /usr/src/ && \
      wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
      tar xf nginx-${NGINX_VERSION}.tar.gz && \
      rm -f nginx-${NGINX_VERSION}.tar.gz && \

      cd / && \
      wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip && \
      unzip release-${NPS_VERSION}-beta.zip && \
      rm release-${NPS_VERSION}-beta.zip && \

      cd /ngx_pagespeed-release-${NPS_VERSION}-beta && \
      wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz && \
      tar -xzf ${NPS_VERSION}.tar.gz && \
      rm -r ${NPS_VERSION}.tar.gz && \

      cd /usr/src/nginx-${NGINX_VERSION} && \
      ./configure \
        --prefix=/etc/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/sbin \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/var/run/nginx.pid \
        --with-http_gzip_static_module \
        --with-http_ssl_module \
        --with-sha1=/usr/include/openssl \
        --with-md5=/usr/include/openssl \
        --add-module=/ngx_pagespeed-release-${NPS_VERSION}-beta && \
      make && \
      make install && \
      mkdir -p /var/lib/nginx &&\

      rm -rf /ngx_pagespeed-release-1.9.32.3-beta && \
      apt-get remove wget unzip -y

ADD   nginx.conf /etc/nginx/nginx.conf
ADD   conf/* /etc/nginx/conf.d/

ADD   logrotate.d/* /etc/logrotate.d/
RUN   chmod 644 /etc/logrotate.d/*

VOLUME ["/var/log/nginx"]

EXPOSE 80 443 8080 8443

CMD   nginx -g "daemon off;"
