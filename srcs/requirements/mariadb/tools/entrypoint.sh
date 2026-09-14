#!/bin/bash

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "MariaDB needs initialization"

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql

    chown -R mysql:mysql /var/lib/mysql

    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld

    echo "Starting MariaDB temporarily..."

    mariadbd --user=mysql &

    echo "Waiting for MariaDB to be ready..."

    until mariadb-admin ping --silent; do
        sleep 1
    done

    echo "MariaDB is ready!"

    echo "Creating database and user..."

    mariadb <<EOF
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOF

    echo "Database and user created!"
    echo "Stopping temporary MariaDB..."

    mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

    echo "MariaDB initialization finished!"
else
    echo "MariaDB is already initialized"
fi

echo "Starting MariaDB..."

exec mariadbd --user=mysql
