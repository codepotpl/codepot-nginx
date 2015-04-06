# codepot-nginx
## Build
```bash
docker build -t nginx-codepot .
cp logrotate.d/nginx /etc/logrotate.d/nginx
```
## Run
```docker run -d -p 80:80 -v /tmp/log/:/var/log/nginx nginx-codepot:latest```
