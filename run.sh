#!/bin/bash
docker rm -f codepot-nginx

docker run -d --name codepot-nginx \
    --link codepot-production:codepot-production \
    --link codepot-staging:codepot-staging \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    --link codepotbackendproduction_django_1:codepotbackendproduction_django_1 \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    -p 8443:8443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/ssl/codepot:/ssl \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    codepot-nginx:latest
