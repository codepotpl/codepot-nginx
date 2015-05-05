#!/bin/bash
docker rm -f codepotpl-nginx

docker run -d --name codepotpl-nginx \
    --link codepotpl-production:codepotpl-production \
    --link codepotpl-staging:codepotpl-staging \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/nginx/ssl:/ssl \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    codepotpl-nginx:latest
