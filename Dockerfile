FROM ubuntu:18.04

RUN apt update \
    && apt install -y nginx \
    && apt install -y php-fpm php-mysql \
    && apt install -y ca-certificates

# installing composer

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') ===  '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./php/info.php /var/www/html/info.php
COPY ./start.sh .


EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]
CMD ["bash", "start.sh"]
