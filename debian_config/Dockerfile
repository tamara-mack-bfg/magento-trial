FROM debian:latest
MAINTAINER chandlerbing7@gmail.com

#ARG AUTH_JSON
ARG php_version=php7.4
ARG php_module=$php_version
ARG composer_version=1.10.17

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
	apt update ; apt install $php_version -y
RUN	apt install -y 	${php_module}-bcmath ${php_module}-bz2 ${php_module}-cli ${php_module}-common \
					${php_module}-curl ${php_module}-dba ${php_module}-gd ${php_module}-gmp ${php_module}-imap \
					${php_module}-intl ${php_module}-ldap ${php_module}-mbstring  \
					${php_module}-mysql ${php_module}-odbc ${php_module}-pgsql php7.3-recode \
					${php_module}-snmp ${php_module}-soap ${php_module}-sqlite ${php_module}-tidy \
					${php_module}-xml ${php_module}-xmlrpc ${php_module}-xsl ${php_module}-zip

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

COPY ./conf/php.ini /etc/php/7.1/apache2/php.ini
COPY ./conf/php.ini /etc/php/7.2/apache2/php.ini
COPY ./conf/php.ini /etc/php/7.3/apache2/php.ini
COPY ./conf/php.ini /etc/php/7.4/apache2/php.ini

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
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --version=$composer_version && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

COPY ./composer/auth.json /root/.composer/auth.json

# NodeJs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Git
RUN apt install -y git

RUN apt --purge autoremove -y ; apt clean
