# deploy.sh

``deploy.sh`` is a script to deploy your application on **development/test** environment.

It performs the following tasks:
 - git checkout
 - remove Symfony cache folder
 - remove Vendor folder
 - clear Redis Cache
 - clear MemCache
 - composer install
 - warmup cache
 - symfony assets install
 - restart running supervisors

## Usage
- Copy/checkout this file in  your user folder (``cd ~``).
- In your release folder (cd -P /var/www/[user.name]-dev.mktp-ro/htdocs/..) run:
``sh ~/deploy.sh``
