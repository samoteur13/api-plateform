#syntax=docker/dockerfile:1.4

FROM mlocati/php-extension-installer:latest AS php_extension_installer

FROM php:8.2-fpm-alpine

WORKDIR /srv/app

COPY --from=php_extension_installer --link /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache $PHPIZE_DEPS git build-base zsh shadow

RUN install-php-extensions apcu intl opcache zip

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --link docker/php/conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link docker/php/conf.d/app.prod.ini $PHP_INI_DIR/conf.d/

# Symfony cli
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | sh
RUN apk add symfony-cli

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY --link docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY --link . .

EXPOSE 80
ENTRYPOINT ["docker-entrypoint"]
CMD ["symfony", "serve", "--no-tls", "--allow-http", "--port=80"]