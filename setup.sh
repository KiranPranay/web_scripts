#!/bin/bash
echo "Installing php tools"
apt-get install apache2 php libapache2-mod-php php-curl php-mysql
sudo service apache2 restart

# enable .htaccess
a2enmod rewrite 
service apache2 restart

cat >> /etc/apache2/sites-enabled/000-default.conf << EOF
<Directory /var/www/html>
    AllowOverride All
</Directory>
EOF

service apache2 restart

echo "php setup was completed succesfully"