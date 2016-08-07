FROM nginx
MAINTAINER ktaka

CMD ip add show dev eth0 |egrep inet |cut -f 1 -d / |sed -e "s/.*inet //g"  > /usr/share/nginx/html/index.html \
        && /usr/sbin/nginx -g "daemon off;"



