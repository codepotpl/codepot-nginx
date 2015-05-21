#!/bin/bash
docker rm -f codepot-nginx-production

docker run -d --name codepot-nginx-production \
    --link codepot-production:codepot-production \
    --link codepotbackendproduction_django_1:codepotbackendproduction_django_1 \
    -p 80:80 \
    -p 443:443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/ssl/codepot:/ssl \
    codepot-nginx-production:latest
