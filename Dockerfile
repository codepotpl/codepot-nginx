FROM nginx

RUN   rm -f /etc/nginx/conf.d/*
RUN   echo "Europe/Warsaw" > /etc/timezone && \
      dpkg-reconfigure --frontend noninteractive tzdata
RUN   apt-get update && \
      apt-get install cron logrotate -y --no-install-recommends

ADD nginx.conf /etc/nginx/nginx.conf
ADD conf/* /etc/nginx/conf.d/

ADD crontab /etc/crontab
RUN chmod 644 /etc/crontab

VOLUME ["/var/cache/nginx", "/var/log/nginx"]

EXPOSE 80 443

CMD   cron; \
      nginx -g "daemon off;"
