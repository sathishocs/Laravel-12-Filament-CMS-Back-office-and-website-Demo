#!/bin/bash

mysql --user=root --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS test;
    GRANT ALL PRIVILEGES ON \`test%\`.* TO '$MYSQL_USER'@'%';
EOSQL
