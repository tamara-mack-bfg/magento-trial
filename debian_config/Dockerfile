FROM debian:latest
MAINTAINER chandlerbing7@gmail.com

#ARG AUTH_JSON
ARG php_version=php7.4
ARG php_module=$php_version
ARG composer_version=1.10.17

ARG DEBIAN_FRONTEND=noninteractive
# System
RUN	apt update
RUN apt install -y	apt-utils curl nano vim sendmail
# RUN echo "127.0.0.1 localhost magento2u.loc" >> /etc/hosts

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
	apt update ; apt install $php_version -y

#   TODO: find proper calls for
#       ${php_module_legacy}-hash ${php_module_legacy}-openssl ${php_module_legacy}-pdo_mysql
RUN	apt install -y 	${php_module}-bcmath ${php_module}-ctype ${php_module}-curl ${php_module}-dom \
                    ${php_module}-gd ${php_module}-iconv ${php_module}-intl ${php_module}-mbstring \
                    ${php_module}-simplexml ${php_module}-soap ${php_module}-xsl ${php_module}-zip \
                    ${php_module}-cli ${php_module}-common ${php_module}-gmp ${php_module}-imap \
                    ${php_module}-ldap ${php_module}-mysql ${php_module}-odbc ${php_module}-pgsql \
                    ${php_module}-snmp ${php_module}-tidy ${php_module}-xml ${php_module}-sockets

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

RUN update-alternatives --set php /usr/bin/$php_version ; \
	a2dismod php7.0 ; a2enmod $php_version ; service apache2 restart

COPY ./conf/php.ini /etc/php/7.4/apache2/php.ini

# Install Xdebug for a better developer experience.
RUN apt update && apt install -y php-xdebug
RUN echo "xdebug.remote_enable=on" >> /etc/php/7.4/mods-available/xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /etc/php/7.4/mods-available/xdebug.ini

# MySQL
# Install the mysql CLI client.
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
COPY ./composer/install.sh /root/.composer/composeInit
RUN sh /root/.composer/composeInit && \
    rm /root/.composer/composeInit

COPY ./composer/auth.json /root/.composer/auth.json

# NodeJs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Git
RUN apt install -y git

RUN apt --purge autoremove -y ; apt clean
