#!/bin/bash

djangos=`docker ps | grep django_ | sed 's/ \{2,\}/,/g' | cut -d ',' -f 7`
links=""
i=1
for django in $djangos;  do
	links="$links --link $django:codepotbackendproduction_django_$i"
	i=$((i+1))
done
echo $links

docker rm -f codepot-nginx-aws

docker run -d --name codepot-nginx-aws \
    $links \
    -p 80:80 \
    -p 8080:8080 \
    -p 8443:8443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /home/codepot/codepot-webclient-staging/dist:/registration \
    -v /var/files:/files \
    codepot-nginx-staging:latest
