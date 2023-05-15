#syntax=docker/dockerfile:1.4

FROM mlocati/php-extension-installer:latest AS php_extension_installer

FROM php:8.2-fpm-alpine

WORKDIR /srv/app

COPY --from=php_extension_installer --link /usr/bin/install-php-extensions /usr/local/bin/

RUN apk add --no-cache $PHPIZE_DEPS git build-base zsh shadow bash

RUN install-php-extensions apcu intl opcache zip

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --link docker/app.ini $PHP_INI_DIR/conf.d/
COPY --link docker/app.prod.ini $PHP_INI_DIR/conf.d/

# Symfony cli
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv $HOME/.symfony5/bin/symfony /usr/local/bin/symfony

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY --link docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY --link . .

EXPOSE 80
ENTRYPOINT ["docker-entrypoint"]
CMD ["symfony", "serve", "--no-tls", "--allow-http", "--port=80"]