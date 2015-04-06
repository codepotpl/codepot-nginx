FROM nginx

RUN   rm -f /etc/nginx/conf.d/*
RUN   echo "Europe/Warsaw" > /etc/timezone && \
      dpkg-reconfigure --frontend noninteractive tzdata

ADD nginx.conf /etc/nginx/nginx.conf
ADD conf/* /etc/nginx/conf.d/

VOLUME ["/var/cache/nginx", "/var/log/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
