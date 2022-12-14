#!/bin/bash

##########################################################################################
# Este script permite configurar un SO Debian 11 para el despliegue de Sitio Web Drupal  #
#                                                                                        #
# Algunas consideraciones:                                                               #
# - El script deberá ser ejecutado con permisos de super-usuario (root)                  #
# - Debe existir acceso a internet de manera directa, sin necesidad de uso de proxy      #
# - El script logue la mínima información (warnings o errores)                           #
#                                                                                        #
# Ejecución:                                                                             #
# $ sudo su                                                                              #
# # bash debian-configurations.sh                                                        #
##########################################################################################

BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}-= Configuring VARs for non interactive dialogs =-${NC}"

export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive

echo -e "${BLUE}-= Updating Debian =-${NC}"

apt-get -qq update && apt-get -qq dist-upgrade -y

echo -e "${BLUE}-= Installing PHP 7.4 & PHP Extensions =-${NC}"

apt-get -qq install -y php7.4 \
php7.4-apcu \
php7.4-bcmath \
php7.4-bz2 \
php7.4-calendar \
php7.4-ctype \
php7.4-curl \
php7.4-dom \
php7.4-exif \
php7.4-fileinfo \
php7.4-ftp \
php7.4-gd \
php7.4-gettext \
php7.4-iconv \
php7.4-imagick \
php7.4-imap \
php7.4-intl \
php7.4-json \
php7.4-ldap \
php7.4-mbstring \
php7.4-memcached \
php7.4-mysqli \
php7.4-mysqlnd \
php7.4-OAuth \
php7.4-PDO \
php7.4-Phar \
php7.4-posix \
php7.4-pgsql \
php7.4-readline \
php7.4-redis \
php7.4-SimpleXML \
php7.4-soap \
php7.4-sqlite3 \
php7.4-tokenizer \
php7.4-xml \
php7.4-xmlreader \
php7.4-xmlwriter \
php7.4-zip

echo -e "${BLUE}-= Installing Apache Server 2.0 & Modules =-${NC}"

apt-get -qq install -y apache2
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod rewrite

echo -e "${BLUE}-= Configuring Apache Default Site =-${NC}"

cat /dev/null > /etc/apache2/sites-available/000-default.conf
echo -e "<VirtualHost *:80>" >> /etc/apache2/sites-available/000-default.conf
echo -e "        DocumentRoot /var/www/html/bhuwebsite/web" >> /etc/apache2/sites-available/000-default.conf
echo -e "        ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/000-default.conf
echo -e "        CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/000-default.conf
echo -e "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

echo -e "<Directory /var/www/html/bhuwebsite/web/>" >> /etc/apache2/apache2.conf
echo -e "        Options Indexes FollowSymLinks" >> /etc/apache2/apache2.conf
echo -e "        AllowOverride All" >> /etc/apache2/apache2.conf
echo -e "        Require all granted" >> /etc/apache2/apache2.conf
echo -e "</Directory>" >> /etc/apache2/apache2.conf

echo -e "${BLUE}-= Enabling & Restart Apache Server =-${NC}"

systemctl enable apache2
systemctl restart apache2

echo -e "${BLUE}-= Installing PHP Composer =-${NC}"

apt-get -qq install -y php7.4-cli zip unzip
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
