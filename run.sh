#!/bin/bash
docker rm -f codepot-nginx-aws

docker run -d --name codepot-nginx-aws \
    --link codepot-production:codepot-production \
    --link codepot-staging:codepot-staging \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    -p 80:80 \
    -p 8080:8080 \
    -p 8443:8443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    -v /var/files:/files \
    codepot-nginx-staging:latest
