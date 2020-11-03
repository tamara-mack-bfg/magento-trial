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
	apt update ; apt install php7.3 -y
RUN	apt install -y 	php7.3-bcmath php7.3-bz2 php7.3-cli php7.3-common \
					php7.3-curl php7.3-dba php7.3-gd php7.3-gmp php7.3-imap \
					php7.3-intl php7.3-ldap php7.3-mbstring  \
					php7.3-mysql php7.3-odbc php7.3-pgsql php7.3-recode \
					php7.3-snmp php7.3-soap php7.3-sqlite php7.3-tidy \
					php7.3-xml php7.3-xmlrpc php7.3-xsl php7.3-zip

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

RUN update-alternatives --set php /usr/bin/php7.3 ; \
	a2dismod php7.0 ; a2enmod php7.3 ; service apache2 restart

COPY ./conf/php.ini /etc/php/7.1/apache2/php.ini
COPY ./conf/php.ini /etc/php/7.2/apache2/php.ini
COPY ./conf/php.ini /etc/php/7.3/apache2/php.ini

# MySQL
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server
RUN /etc/init.d/mysql start && \
        mysql -u root -e \
        "use mysql;update user set plugin='' where User='root'; \
        flush privileges;create database m2\q"

RUN /etc/init.d/mysql start && \
    mysql -u root -e \
    "create user 'magento'@'localhost' identified by 'magento';\
             create user 'magento'@'%' identified by 'magento';\
             grant all on *.* to 'magento'@'localhost';\
             grant all on *.* to 'magento'@'%';\q"

COPY ./mysql/my.cnf /etc/mysql/my.cnf
RUN /etc/init.d/mysql restart

# Composer
RUN sh ./composer/install.sh && \
    mv composer.phar /usr/local/bin/composer

COPY ./composer/auth.json /root/.composer/auth.json

# NodeJs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Git
RUN apt install -y git

RUN apt --purge autoremove -y ; apt clean
