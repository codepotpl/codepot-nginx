#!/bin/bash
docker rm -f codepot-nginx-monitoring

docker run -d --name codepot-nginx-monitoring \
    -p 8080:80 \
    -p 8443:443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /var/www/logs:/logs \
    codepot-nginx-staging:latest
