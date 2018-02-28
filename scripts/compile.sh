#!/bin/sh

# Copy config
cp config/config.ini.php vendor/piwik/piwik/config/config.ini.php

# Update config
DB_HOST=`echo $DATABASE_URL | cut -d@ -f2 | cut -d: -f1`
DB_USERNAME=`echo $DATABASE_URL | cut -d@ -f1 | cut -d/ -f3 | cut -d: -f1`
DB_PASSWORD=`echo $DATABASE_URL | cut -d@ -f1 | cut -d/ -f3 | cut -d: -f2`
DB_NAME=`echo $DATABASE_URL | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f2`

sed -i s/#DB_HOST/$DB_HOST/ vendor/piwik/piwik/config/config.ini.php
sed -i s/#DB_USERNAME/$DB_USERNAME/ vendor/piwik/piwik/config/config.ini.php
sed -i s/#DB_PASSWORD/$DB_PASSWORD/ vendor/piwik/piwik/config/config.ini.php
sed -i s/#DB_NAME/$DB_NAME/ vendor/piwik/piwik/config/config.ini.php

sed -i s/#SECRET_TOKEN/$SECRET_TOKEN/ vendor/piwik/piwik/config/config.ini.php
sed -i s/#POSTMARK_TOKEN/$POSTMARK_TOKEN/ vendor/piwik/piwik/config/config.ini.php
sed -i s/#NOREPLY_EMAIL/$NOREPLY_EMAIL/ vendor/piwik/piwik/config/config.ini.php
sed -i s/#FORCE_SSL/${FORCE_SSL:-0}/ vendor/piwik/piwik/config/config.ini.php

THS_ENV=`compgen -A variable | grep "^TRUSTED_HOSTS_" | while read TH_ENV ; do echo trusted_hosts[] = "\\\\\"${!TH_ENV}\\\\\"" ; done`
sed -i "s/#TRUSTED_HOSTS/`echo "$THS_ENV" | awk '{printf("%s\\\\n", $0);}' | sed -e 's/\\\n$//'`/" vendor/piwik/piwik/config/config.ini.php

cp -R plugins/* vendor/piwik/piwik/plugins/ 
cp -R misc/* vendor/piwik/piwik/misc/
cp -R icons/* vendor/piwik/piwik/plugins/Morpheus/icons/
cp index.php vendor/piwik/piwik/
cp config.ini.php vendor/piwik/piwik/config/
if [ -d .heroku ]; then
	cp .geoip/share/GeoLite2-City.mmdb .geoip/share/GeoLite2-Country.mmdb vendor/piwik/piwik/misc/; 
fi
