FROM dunglas/frankenphp

# Install ekstensi PHP yang dibutuhkan Laravel
RUN install-php-extensions pcntl bcmath gd intl zip opcache pdo_mysql

WORKDIR /app

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy semua source code
COPY . .

# Install dependensi mode production
RUN composer install --no-dev --optimize-autoloader

# Publish aset Filament & Cache View secara otomatis saat build
RUN php artisan filament:assets
RUN php artisan view:cache

# Set permission
RUN chmod -R 777 storage bootstrap/cache

# Jalankan FrankenPHP di port 8000
CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8000"]