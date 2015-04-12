#!/bin/bash
docker rm -f codepotpl-nginx

docker run -d --name codepotpl-nginx --link codepotpl-production:codepotpl-production -p 80:80 -v /var/log/nginx/:/var/log/nginx codepotpl-nginx:latest
