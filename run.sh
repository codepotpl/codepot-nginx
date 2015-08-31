#!/bin/bash
docker rm -f codepot-nginx-staging

docker run -d --name codepot-nginx-staging \
    --link codepot-staging:codepot-staging \
    --link codepotbackendstaging_django_1:codepotbackendstaging_django_1 \
    --link codepotsurveystaging_survey_1:codepotsurveystaging_survey_1 \
    -p 8080:8080 \
    -p 8443:8443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /etc/ssl/codepot:/ssl \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    -v /var/files:/files \
    codepot-nginx-staging:latest
