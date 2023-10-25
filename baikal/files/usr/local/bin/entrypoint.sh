#!/bin/sh
sed -i 's/^;extension=pdo_sqlite/extension=pdo_sqlite/' /etc/php/php.ini
sed -i 's/^;extension=sqlite3/extension=sqlite3/' /etc/php/php.ini
php-fpm
exec nginx
