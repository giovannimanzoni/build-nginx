# Abstract
This repository is for build Nginx on Debian from source  with optimization and custom setup. The scripts build Nginx as frontend and as backend.


## For build Nginx webserver as frontend

**Host requirements**

	apt update && apt install libgoogle-perftools-dev libxml2-dev libxslt1-dev libxslt1.1 libgeoip-dev checkinstall

**Build**

	chmod +x 1frontendNginx.sh
	./1frontendNginx.sh  NGINX_VERSION PCRE1_VERSION OPENSSL_VERSION ZLIB_VERSION
for example: ./1frontendNginx.sh 1.15.7 8.42 1.1.1a 1.2.11

**Target requirements**

	apt update && apt install libxslt1.1 libgoogle-perftools4
	mkdir -p /srv/front/logs/runtime/
	mkdir -p /srv/front/conf/common/
	mkdir -p /srv/front/usr/local/nginx/client_body_temp
	mkdir /srv/front/usr/local/nginx/proxy_temp
	mkdir /srv/front/conf/sites-availables/
	mkdir /srv/front/conf/sites-enabled/
	touch /srv/front/conf/common/upstream-cache.conf

**Run**
Script tell you where the packege will be created. You can use this my repository for handle Nginx as service : https://github.com/giovannimanzoni/nginx-sysvinit-script


## For build Nginx webserver as backend

**Host requirements**

On host this script require something like but less than 'libgoogle-perftools-dev libxml2-dev libxslt1-dev libxslt1.1 libgeoip-dev checkinstall' because this script use less library

**Build**

	chmod +x 2backendNginx.sh
	./2backendNginx.sh NGINX_VERSION PCRE1_VERSION
for example ./2backendNginx.sh 1.15.7 8.42

**Target requirements**

        apt update && apt install ?? (I never run it without nginxfront on same server)
        mkdir -p /srv/back/logs/runtime/
        mkdir /srv/back/conf/common/
        mkdir /srv/back/conf/sites-availables/
        mkdir /srv/back/conf/sites-enabled/


**Run**
Script tell you where the packege will be created. You can use this my repository for handle Nginx as service : https://github.com/giovannimanzoni/nginx-sysvinit-script
