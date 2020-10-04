#!/usr/bin/env bash
 
apt-get update
 
# install apache
apt-get install -q -y apache2

# /vagrant is shared by default
# symlink that to /var/www
# this will be the pubic root of the site

# configuration files live at /etc/apache2/
rm -rf /var/www
mkdir -p /vagrant/www
ln -fs /vagrant/www /var/www

################################################################################

# Enable SSI following (mostly) the directions here:
# https://help.ubuntu.com/community/ServerSideIncludes

# Add the Includes module
a2enmod include

# Add Includes, AddType and AddOutputFilter directives
mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.bak
cp /vagrant/default /etc/apache2/sites-available/default

# To allow includes in index pages
mv /etc/apache2/mods-available/dir.conf /etc/apache2/mods-available/dir.conf.bak
cp /vagrant/dir.conf /etc/apache2/mods-available/dir.conf

# restart apache2
apachectl -k graceful

# smoke test
# open a brower to http://127.0.0.1:8080 to test
echo '<html><head><title>SSI Test Page</title></head><body><!--#echo var="DATE_LOCAL" --></body></html>' > /vagrant/www/index.html