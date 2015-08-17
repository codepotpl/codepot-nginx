#!/bin/bash
docker rm -f codepot-nginx-staging

docker run -d --name codepot-nginx-staging \
    -p 8080:8080 \
    -p 8443:8443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/ssl/codepot:/ssl \
    codepot-nginx-staging:latest
