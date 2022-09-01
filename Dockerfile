FROM jetbrains/teamcity-agent

LABEL maintainer="william.rich@weblabs.dev"
LABEL version="1.0"
LABEL description="The great TeamCity CI with PHP 8.0"
USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common wget
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php8.0-cli php-pear php8.0-curl php8.0-dev php8.0-gd php8.0-mbstring php8.0-zip php8.0-mysql php8.0-xml php8.0-intl
    
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" 
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer 
RUN php -r "unlink('composer-setup.php');" 
RUN  composer global require "phpunit/phpunit ^9" \
    && ln -s ~/.composer/vendor/bin/phpunit /usr/local/bin/phpunit \
    && composer global require 'phpunit/dbunit=*' \
    && composer global require 'phpunit/php-invoker=*' \ 
    && composer global require 'phpunit/phpunit-selenium=*' \
    && composer global require phpmd/phpmd \
    && ln -s ~/.composer/vendor/bin/phpmd /usr/local/bin/phpmd \
    && composer global require pdepend/pdepend \
    && ln -s ~/.composer/vendor/bin/pdepend /usr/local/bin/pdepend \
    && cd ~ && wget https://github.com/phpDocumentor/phpDocumentor2/releases/download/v2.9.0/phpDocumentor.phar \
    && mv ~/phpDocumentor.phar /usr/bin && chmod a+x /usr/bin/phpDocumentor.phar \
    && ln -s /usr/bin/phpDocumentor.phar /usr/bin/phpdoc \
    && composer global require sebastian/phpcpd \
    && ln -s ~/.composer/vendor/bin/phpcpd /usr/local/bin/phpcpd \
    && composer global require phploc/phploc \
    && ln -s ~/.composer/vendor/bin/phploc /usr/local/bin/phploc \
    && composer global require squizlabs/php_codesniffer \
    && ln -s ~/.composer/vendor/bin/phpcs /usr/local/bin/phpcs
