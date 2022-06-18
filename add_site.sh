#!/bin/bash
echo "Enter Your Domain"
read url

echo "Index type ? (php/html)"
read indextype

cd /var/www/html
mkdir $url
chown -R www-data:www-data /var/www/html/$url

cat > /etc/apache2/sites-available/$url.conf << EOF
<VirtualHost *:80>
ServerAdmin $url
ServerName $url
DocumentRoot /var/www/html/$url
DirectoryIndex index.$indextype
ErrorLog ${APACHE_LOG_DIR}/$url_error.log
CustomLog ${APACHE_LOG_DIR}/$url_access.log combined
</VirtualHost>
EOF

a2ensite $url

sleep 2

systemctl restart apache2