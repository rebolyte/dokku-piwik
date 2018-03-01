# dokku-piwik

This is a simple setup of Piwik and a few plugins, suitable for running on [dokku](http://dokku.viewdocs.io/dokku/).

Piwik Version: *3+*

Composer config and other things borrowed from [creativecoder/piwik-heroku](https://github.com/creativecoder/piwik-heroku).

Install script from [nebev/piwik-cli-setup](https://github.com/nebev/piwik-cli-setup).

## Deploy

Install mariadb and create the app and its db:

```
# on your server
$ dokku apps:create piwik
$ dokku plugin:install https://github.com/dokku/dokku-mariadb.git mariadb
$ dokku mariadb:create piwikdb
$ dokku mariadb:link piwikdb piwik
```

*Before deploying*, update the config settings for your app:

```
# on your server
$ dokku config:set piwik \
USERNAME='user' \
USER_PASSWORD='pass' \
USER_EMAIL='me@me.com' \
SITE_NAME='My Company' \
SITE_URL='https://mycompany.com' \
BASE_DOMAIN='piwik.mycompany.com'
```

Now push piwik:

```
# on your local box
$ git clone git@github.com:rebolyte/dokku-piwik.git
$ cd dokku-piwik
$ git remote add dokku dokku@yourserver.me:piwik
$ git push dokku master
```

Start the archiver process (this step is only needed once):

```
# on your server
$ dokku ps:scale piwik archive=1
```

Now visit the URL you deployed to! Note that if you are getting a problem with JavaScript bundles loading correctly, it could be a DNS issue that hasn't resolved yet or it could be the browser or an extension blocking anything with "piwik" in the domain name.

## Config

Note that some settings made from the Piwik web UI (e.g. changing plugins) won't persist between launches unless you add those changes to this repository as well.

## Archiving

The Procfile includes a process responsible for running the `core:archive` task. It's set to run every 3600 seconds by default, but this interval can be changed using the env var ARCHIVE_INTERVAL.

## Plugins

You can use composer to install additional plugins. See https://github.com/composer/installers and the examples in `composer.json`.

## License

MIT
