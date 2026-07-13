#!/bin/sh

# 1. Install PHP & tools needed for Statamic
dnf clean metadata
dnf install -y php8.2 php8.2-{common,mbstring,gd,bcmath,xml,fpm,intl,zip} dnf install -y wget

# 2. Download and install Composer
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php

# 3. Install your project's PHP code packages
php composer.phar install

# 4. Generate the secure environment key
php artisan key:generate

# 5. Compile your static HTML files
php please stache:warm -n -q
php please ssg:generate