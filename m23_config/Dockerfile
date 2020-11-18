FROM mike/debian_config
MAINTAINER chandlerbing7@gmail.com

RUN composer create-project -v --repository=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento2ce/
#RUN composer create-project --repository=https://repo.magento.com/ magento/project-enterprise-edition /var/www/html/magento2ce/
RUN mkdir /var/www/html/magento2ce/var/composer_home/
RUN touch /var/www/html/magento2ce/var/composer_home/auth.json
RUN cp /root/.composer/auth.json /var/www/html/magento2ce/var/composer_home/auth.json

# Magento2 and Sample Data
RUN cd /var/www/html/magento2ce/ && \
	composer install -v && \
	php bin/magento sampledata:deploy && \
	bin/magento setup:upgrade ; \
	mv Gruntfile.js.sample Gruntfile.js && \
	mv package.json.sample package.json

RUN cd /var/www/html/magento2ce/ &&  \
	php bin/magento setup:install \
	--base-url=http://magento2u.loc:8080 \
	--backend-frontname=admin \
	--admin-firstname=admin \
	--admin-lastname=admin \
	--admin-email=example@gmail.com \
	--admin-user=admin \
	--admin-password=mageU123 \
	--db-name=m2 \
	--db-host=magento-mysql \
	--db-user=root \
	--db-password=password \
	--elasticsearch-host=elasticsearch \
    --elasticsearch-port=9200 \
    --use-rewrites=1 && \
	php bin/magento indexer:reindex && \
	php bin/magento cache:flush

RUN cd /var/www/html/magento2ce/ &&  \
	apt install -y nodejs && \
	npm install -g grunt-cli && \
	npm install && \
	grunt exec --force && \
	grunt less --force && \
    php bin/magento deploy:mode:set developer && \
    composer require --dev n98/magerun2-dist

RUN chown -R www-data:www-data /var/www/html/magento2ce/

RUN apt --purge autoremove -y ; apt clean && rm -rf /var/lib/apt/list/*

ENTRYPOINT 	service mysql restart && service sendmail restart && \
			service apache2 restart && bash

EXPOSE 80
