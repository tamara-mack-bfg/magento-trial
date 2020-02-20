FROM debian:latest
MAINTAINER chandlerbing7@gmail.com

#ARG AUTH_JSON

# System
RUN	apt update
RUN apt install -y 	curl nano vim sendmail
RUN echo "127.0.0.1 localhost magento2u.loc" >> /etc/hosts

# Apache
RUN apt install -y 	apache2 \
						libapache2-mod-php && \
						apt-get clean
# PHP
RUN apt install apt-transport-https lsb-release ca-certificates -y ; \
    apt install mc -y ; \
	apt install wget -y ; \
	wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg ; \
	echo 	"deb https://packages.sury.org/php/ $(lsb_release -sc) main" > \
			/etc/apt/sources.list.d/php.list ; \
	apt update ; apt install php7.2 -y
RUN	apt install -y 	php7.2-bcmath php7.2-bz2 php7.2-cli php7.2-common \
					php7.2-curl php7.2-dba php7.2-gd php7.2-gmp php7.2-imap \
					php7.2-intl php7.2-ldap php7.2-mbstring  \
					php7.2-mysql php7.2-odbc php7.2-pgsql php7.2-recode \
					php7.2-snmp php7.2-soap php7.2-sqlite php7.2-tidy \
					php7.2-xml php7.2-xmlrpc php7.2-xsl php7.2-zip

# Create user and assign to web server group
#RUN adduser magento
RUN usermod -aG root www-data
#
#ENV APACHE_RUN_USER     magento
#ENV APACHE_RUN_GROUP    www-data
ENV APACHE_LOG_DIR      /var/log/apache2
ENV APACHE_PID_FILE     /var/run/apache2.pid
ENV APACHE_RUN_DIR      /var/run/apache2
ENV APACHE_LOCK_DIR     /var/lock/apache2

COPY ./conf/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2ensite 000-default

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite ; \
	a2enmod mpm_prefork

RUN update-alternatives --set php /usr/bin/php7.2 ; \
	a2dismod php7.0 ; a2enmod php7.2 ; service apache2 restart

COPY ./conf/php.ini /etc/php/7.1/apache2/php.ini
COPY ./conf/php.ini /etc/php/7.2/apache2/php.ini

# MySQL
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server
RUN /etc/init.d/mysql start && \
        mysql -u root -e \
        "use mysql;update user set plugin='' where User='root'; \
        flush privileges;create database m2\q"

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

COPY ./composer/auth.json /root/.composer/auth.json

# NodeJs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Git
RUN apt install -y git

RUN apt --purge autoremove -y ; apt clean