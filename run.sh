#!/bin/bash
docker rm -f codepot-nginx-staging

docker run -d --name codepot-nginx-staging-pagespeed \
    --link codepot-staging:codepot-staging \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    -p 8081:8080 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/ssl/codepot:/ssl \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    -v /var/files:/files \
    codepot-nginx-staging:latest
