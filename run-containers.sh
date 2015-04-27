#!/bin/bash
docker rm -f codepotpl-nginx

docker run -d --name codepotpl-nginx \
    --link codepotpl-production:codepotpl-production \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    -p 80:80 \
    -p 8081:8081 \
    -p 8082:8082 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    codepotpl-nginx:latest
