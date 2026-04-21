# Menggunakan base image PHP 8.2 dengan Apache
FROM php:8.2-apache

# Install ekstensi sistem yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y libzip-dev zip unzip
RUN docker-php-ext-install pdo_mysql zip

# Aktifkan mod_rewrite Apache untuk routing Laravel
RUN a2enmod rewrite

# Set folder kerja
WORKDIR /var/www/html

# Copy file composer dari image resmi
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy seluruh file backend ke dalam container
COPY . .

# Install dependensi Laravel (abaikan error dev)
RUN composer install --no-dev --optimize-autoloader

# Berikan hak akses ke folder storage agar tidak error permission
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Ubah setting Apache agar langsung membaca folder /public milik Laravel
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80