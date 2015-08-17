#!/bin/bash
docker rm -f codepot-nginx-production

docker run -d --name codepot-nginx-production \
    --link codepot-production:codepot-production \
    --link codepotbackendproduction_django_1:codepotbackendproduction_django_1 \
    --link codepotbackendproduction_django_2:codepotbackendproduction_django_2 \
    --link codepotbackendproduction_django_3:codepotbackendproduction_django_3 \
    -p 80:80 \
    -p 443:443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /home/codepot/codepot-webclient-production/dist:/registration \
    -v /etc/ssl/codepot:/ssl \
    codepot-nginx-production:latest
