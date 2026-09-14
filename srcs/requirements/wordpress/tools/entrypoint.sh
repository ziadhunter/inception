#!/bin/bash

set -e

echo "Starting WordPress container..."

echo "Waiting for MariaDB..."

until mariadb \
    -h "mariadb" \
    -P "$MYSQL_PORT" \
    -u "$MYSQL_USER" \
    -p"$MYSQL_PASSWORD" \
    -e "SELECT 1;"
do
    echo "MariaDB is not ready yet..."
    sleep 2
done


echo "MariaDB is ready."

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root --path=/var/www/html

    wp config create \
        --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:${MYSQL_PORT}" \
        --path=/var/www/html

    wp core install \
        --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path=/var/www/html

    wp user create \
        --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --role=author \
        --path=/var/www/html
fi

exec "$@"
