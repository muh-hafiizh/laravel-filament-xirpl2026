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

# Publish aset Filament & Livewire menjadi file fisik statis
RUN php artisan filament:assets
RUN php artisan livewire:publish --assets
RUN php artisan view:cache

# Pastikan folder storage bisa ditulisi
RUN chmod -R 777 storage bootstrap/cache

# Jalankan FrankenPHP di port 8000
CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8000"]