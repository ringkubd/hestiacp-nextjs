#!/bin/bash
# install.sh

HESTIA='/usr/local/hestia'
source $HESTIA/conf/hestia.conf
source $HESTIA/func/main.sh

# Install Node.js and PM2
apt-get update
apt-get install -y nodejs npm
npm install -g pm2

# Create plugin directories
# Create subdirectories individually
sudo mkdir -p $HESTIA/plugins/nextjs/config
sudo mkdir -p $HESTIA/plugins/nextjs/web/templates
sudo mkdir -p $HESTIA/plugins/nextjs/func
sudo mkdir -p $HESTIA/plugins/nextjs/bin

chmod 751 $HESTIA/plugins/nextjs

# Verify directories
if [ ! -d "$HESTIA/plugins/nextjs/web/templates" ]; then
	echo "Failed to create directories"
	exit 1
fi

# Copy plugin files
cp -rf config/* $HESTIA/plugins/nextjs/config/
cp -rf web/* $HESTIA/plugins/nextjs/web/
cp -rf func/* $HESTIA/plugins/nextjs/func/
cp -rf bin/v-deploy-nextjs $HESTIA/bin/

# Set proper permissions
chmod +x $HESTIA/bin/v-deploy-nextjs
chmod 644 $HESTIA/plugins/nextjs/config/*.json
chmod 644 $HESTIA/plugins/nextjs/web/*.php
chmod 644 $HESTIA/plugins/nextjs/web/templates/*.php
chmod 755 $HESTIA/plugins/nextjs/func/*.sh

# Install dependencies globally
npm install -g pnpm yarn

# Register plugin menu
$HESTIA/bin/v-add-user-plugin-menu admin nextjs

# Clear HestiaCP cache
rm -f $HESTIA/data/cache/menu/*

# Restart web server
systemctl restart nginx php$PHP_VERSION-fpm

# Log installation
log_event "system" "info" "Next.js plugin installation completed"

echo "Next.js plugin installed successfully. Please refresh your HestiaCP panel."
