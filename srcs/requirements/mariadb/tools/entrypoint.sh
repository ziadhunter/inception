#!/bin/bash

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "MariaDB needs initialization"

    ls -la /var/lib/mysql

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    chown -R mysql:mysql /var/lib/mysql

    echo "MariaDB initialized"

    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld

    mariadbd --user=mysql &

    echo "Waiting for MariaDB to be ready..."

    until mariadb-admin ping --silent; do
        sleep 1
    done

    echo "MariaDB is ready!"

    echo "Creating database..."

    mariadb -e "CREATE DATABASE wordpress;"

    echo "Creating user..."

    mariadb -e "CREATE USER 'wpuser'@'%' IDENTIFIED BY 'secret';"

    echo "Granting privileges..."

    mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"

    echo "Database and user created!"
else
    echo "MariaDB is already initialized"
fi

echo "im here"