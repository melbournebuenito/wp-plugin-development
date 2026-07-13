#!/bin/sh

# 1. Update and install PHP + tools needed for Statamic
dnf clean metadata
dnf install -y php8.2 php8.2-common php8.2-mbstring php8.2-gd php8.2-bcmath php8.2-xml php8.2-fpm php8.2-intl php8.2-zip wget

# 2. Download and install Composer
wget -O composer-setup.php https://getcomposer.org/installer
php composer-setup.php --quiet
rm composer-setup.php

# 3. Install your project's PHP packages
php composer.phar install --no-dev --prefer-dist --optimize-autoloader

# 4. Generate the secure environment key
php artisan key:generate

# 5. Compile your static HTML files
php please stache:warm -n -q
php please ssg:generate