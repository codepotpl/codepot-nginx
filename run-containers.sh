#!/bin/bash
docker rm -f codepot-nginx

docker run -d --name codepot-nginx \
    --link codepot-production:codepot-production \
    --link codepot-staging:codepot-staging \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/nginx/ssl:/ssl \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    codepot-nginx:latest
