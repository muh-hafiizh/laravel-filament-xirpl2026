# Kita pakai base image resmi FrankenPHP
FROM dunglas/frankenphp

# Install ekstensi PHP yang wajib buat Laravel
RUN install-php-extensions \
    pcntl \
    bcmath \
    gd \
    intl \
    zip \
    opcache \
    pdo_mysql

# Set folder kerja
WORKDIR /app

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy semua file projek ke dalam container
COPY . .

# Install dependensi Laravel (mode production)
RUN composer install --no-dev --optimize-autoloader

# Pastikan folder storage bisa ditulisi
RUN chmod -R 777 storage bootstrap/cache

# Perintah untuk menjalankan aplikasi saat container start
# Kita set ke port 8000
CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8000"]
