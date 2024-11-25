#!/bin/bash

# Install necessary PHP and Apache tools (requires sudo)
echo "Installing PHP and Apache tools..."
sudo apt-get update -y || { echo "Warning: Failed to update package list. Proceeding with installation."; }
sudo apt-get install -y apache2 php libapache2-mod-php php-curl php-mysql || { echo "Error: Failed to install PHP and Apache tools. Please check your network or package sources."; exit 1; }

# Restart Apache to apply changes (requires sudo)
echo "Restarting Apache..."
sudo service apache2 restart || { echo "Error: Failed to restart Apache. Please check the Apache service."; exit 1; }

# Enable .htaccess file support (requires sudo)
echo "Enabling .htaccess support..."
sudo a2enmod rewrite || { echo "Error: Failed to enable rewrite module. Please check Apache configuration."; exit 1; }

# Restart Apache again to apply module changes
echo "Restarting Apache to apply .htaccess changes..."
sudo service apache2 restart || { echo "Error: Failed to restart Apache after enabling rewrite module."; exit 1; }

# Update Apache configuration to allow .htaccess overrides
echo "Updating Apache configuration to allow .htaccess overrides..."
sudo bash -c "cat >> /etc/apache2/sites-enabled/000-default.conf << EOF
<Directory /var/www/html>
    AllowOverride All
</Directory>
EOF" || { echo "Error: Failed to update Apache configuration. Please check permissions."; exit 1; }

# Restart Apache to apply configuration changes
echo "Restarting Apache to apply configuration changes..."
sudo service apache2 restart || { echo "Error: Failed to restart Apache after updating configuration."; exit 1; }

# Print success message
echo "PHP setup was completed successfully."
