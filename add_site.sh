#!/bin/bash

# Prompt for domain and index type
echo "Enter Your Domain"
read url

if [ -z "$url" ]; then
  echo "Error: Domain name cannot be empty."
  exit 1
fi

echo "Index type ? (php/html)"
read indextype

if [[ "$indextype" != "php" && "$indextype" != "html" ]]; then
  echo "Error: Invalid index type. Please enter either 'php' or 'html'."
  exit 1
fi

# Create the directory for the new website (requires sudo)
echo "Creating directory for the new website..."
sudo mkdir /var/www/html/$url || { echo "Error: Failed to create directory. Please check permissions."; exit 1; }

# Change ownership of the directory to www-data and grant group write permissions
sudo chown -R www-data:$USER /var/www/html/$url || { echo "Error: Failed to change ownership. Please check permissions."; exit 1; }
sudo chmod -R 775 /var/www/html/$url || { echo "Error: Failed to set permissions. Please check permissions."; exit 1; }

# Create Apache configuration file for the new site (requires sudo)
echo "Creating Apache configuration file for $url..."
sudo bash -c "cat > /etc/apache2/sites-available/$url.conf << EOF
<VirtualHost *:80>
    ServerAdmin webmaster@$url
    ServerName $url
    DocumentRoot /var/www/html/$url
    DirectoryIndex index.$indextype
    ErrorLog \${APACHE_LOG_DIR}/$url_error.log
    CustomLog \${APACHE_LOG_DIR}/$url_access.log combined
</VirtualHost>
EOF" || { echo "Error: Failed to create Apache configuration file."; exit 1; }

# Enable the new site (requires sudo)
echo "Enabling the new site $url..."
sudo a2ensite $url || { echo "Error: Failed to enable the site. Please check if the configuration file is correct."; exit 1; }

# Wait for a moment to ensure changes are applied
sleep 2

# Restart Apache to apply the changes (requires sudo)
echo "Restarting Apache..."
sudo systemctl restart apache2 || { echo "Error: Failed to restart Apache. Please check the Apache configuration."; exit 1; }

# Print success message
echo "The website $url has been successfully set up and enabled."
