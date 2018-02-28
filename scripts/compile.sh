#!/bin/sh

CONFIG_FILE=config/install_run.json

# Copy config
cp config/install.json $CONFIG_FILE

# Update config
DB_HOST=`echo $DATABASE_URL | cut -d@ -f2 | cut -d: -f1`
DB_USERNAME=`echo $DATABASE_URL | cut -d@ -f1 | cut -d/ -f3 | cut -d: -f1`
DB_PASSWORD=`echo $DATABASE_URL | cut -d@ -f1 | cut -d/ -f3 | cut -d: -f2`
DB_NAME=`echo $DATABASE_URL | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f2`

sed -i s/#DB_HOST/$DB_HOST/ $CONFIG_FILE
sed -i s/#DB_USERNAME/$DB_USERNAME/ $CONFIG_FILE
sed -i s/#DB_PASSWORD/$DB_PASSWORD/ $CONFIG_FILE
sed -i s/#DB_NAME/$DB_NAME/ $CONFIG_FILE

sed -i s/#USERNAME/$USERNAME/ $CONFIG_FILE
sed -i s/#PASSWORD/$PASSWORD/ $CONFIG_FILE
sed -i s/#EMAIL/$EMAIL/ $CONFIG_FILE
sed -i s/#SITE_NAME/$SITE_NAME/ $CONFIG_FILE
sed -i s/#SITE_URL/$SITE_URL/ $CONFIG_FILE
sed -i s/#BASE_DOMAIN/$BASE_DOMAIN/ $CONFIG_FILE

# sed -i s/#SECRET_TOKEN/$SECRET_TOKEN/ $CONFIG_FILE
# sed -i s/#POSTMARK_TOKEN/$POSTMARK_TOKEN/ $CONFIG_FILE
# sed -i s/#NOREPLY_EMAIL/$NOREPLY_EMAIL/ $CONFIG_FILE
# sed -i s/#FORCE_SSL/${FORCE_SSL:-0}/ $CONFIG_FILE
# sed -i s/#TRUSTED_HOSTS/$TRUSTED_HOSTS/ $CONFIG_FILE

# THS_ENV=`compgen -A variable | grep "^TRUSTED_HOSTS_" | while read TH_ENV ; do echo trusted_hosts[] = "\\\\\"${!TH_ENV}\\\\\"" ; done`
# sed -i "s/#TRUSTED_HOSTS/`echo "$THS_ENV" | awk '{printf("%s\\\\n", $0);}' | sed -e 's/\\\n$//'`/" vendor/piwik/piwik/config/config.ini.php

cp -R plugins/* vendor/piwik/piwik/plugins/ 
cp -R misc/* vendor/piwik/piwik/misc/
cp -R icons/* vendor/piwik/piwik/plugins/Morpheus/icons/
if [ -d .heroku ]; then
	cp .geoip/share/GeoLite2-City.mmdb .geoip/share/GeoLite2-Country.mmdb vendor/piwik/piwik/misc/; 
fi

# Run install script
php install.php
