FROM php:7.0-fpm
MAINTAINER drupal-docker

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip \
	&& docker-php-ext-install opcache \
	&& rm -rf /var/lib/apt/lists/*

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
		echo 'session.cache_limiter=nocache'; \
		echo 'session.auto_start=0'; \
		echo 'expose_php=Off'; \
		echo 'register_globals=Off'; \
		echo 'memory_limit=512M'; \
		echo ''; \
	} > /usr/local/etc/php/conf.d/drupal.ini

VOLUME /var/www/html

ENV DRUPAL_VERSION 8.1.1
ENV DRUPAL_SHA1 a697981cb1abb160f5b6f837932471689075d80d

RUN curl -o drupal.tar.gz -SL https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz \
	&& echo "${DRUPAL_SHA1} *drupal.tar.gz" | sha1sum -c - \
	&& tar -xzf drupal.tar.gz -C /usr/src/ \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data /usr/src/

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]