#!/bin/bash

set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ] || [ ! -f /etc/nginx/ssl/inception.key ]; then
    echo "Generating SSL certificate..."

    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MA/ST=Fes/L=Fes/O=1337/OU=Student/CN=zfarouk.42.fr"
#sawb hna

    chmod 600 /etc/nginx/ssl/inception.key
fi

# sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/conf.d/default.conf
# wfach tsawenb kolchi rje3 had star

echo "Starting NGINX..."


exec nginx -g "daemon off;"