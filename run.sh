#!/bin/bash

#djangos=`docker ps --filter=name=codepotbackendproduction_django | grep django | sed 's/ \+/ /g' | cut -d ' ' -f 15-`
#docker ps | grep django_ | sed 's/ \{2,\}/,/g' | cut -d ',' -f 7
#links=""
#i=1
#for django in $djangos;  do
#	links="$links --link codepotbackendproduction_django_$i:$django"
#	i=$((i+1))
#	echo $i
#done
#echo $links

docker rm -f codepot-nginx-production
docker run -d --name codepot-nginx-production \
    --link codepotbackendproduction_django_1:codepotbackendproduction_django_1 \
    --link codepotbackendproduction_django_2:codepotbackendproduction_django_2 \
    --link codepotbackendproduction_django_3:codepotbackendproduction_django_3 \
    -p 80:80 \
    -p 443:443 \
    -v /var/log/nginx/:/var/log/nginx \
    -v /home/codepot/codepot-webclient-production/dist:/registration \
    -v /etc/ssl/codepot:/ssl \
    codepot-nginx-production:latest

