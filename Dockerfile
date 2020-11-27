FROM php:7.0-fpm

# Install mcrypt and LDAP
RUN apt-get update && apt-get install -y && \
	apt-get install libldap2-dev libmcrypt-dev -y && \
	docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
	docker-php-ext-install ldap && \
	docker-php-ext-install mcrypt

# FROM http://repos.zend.com/cloudfoundry/clidriver.tar.gz
ADD resources/clidriver.tar.gz /

# https://pecl.php.net/get/PDO_IBM-1.3.4.tgz
ADD resources/PDO_IBM-1.3.4.tgz /

# IBM DB2 is easy as pie
RUN yes '/clidriver' | pecl install ibm_db2 && docker-php-ext-enable ibm_db2

# for IBM_PDO we have have to do it manually
RUN cd /PDO_IBM-1.3.4 && phpize && ./configure --with-pdo-ibm=/clidriver && make install && docker-php-ext-enable pdo_ibm

# RUN cd / && rm -Rf clidriver && rm -Rf PDO_IBM-1.3.4
