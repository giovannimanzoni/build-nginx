#!/bin/bash

echo
echo ">>> COMPILO <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 3 ]; then
  echo "Non hai inserito la versione desiderata dei pacchetti"
  echo " esempio: ./backendNginxCompile.sh NGINX_VERSION PCRE_VERSION CDIR"
  echo " esempio: ./backendNginxCompile.sh 1.13.0 8.40  /root/compila/nginx/backend"
  echo
  exit 0
fi

NGINX_V=$1
PCRE_V=$2
CDIR=$3
CDIR_BACK=$CDIR/backend

J_BASE='/srv/back'
JAIL=$J_BASE # path di installazione

NGINX_LOG_NAME='nginx_'
LOG_RUNTIME_PATH=$JAIL/logs/runtime/
LOG_ERROR='_error.log'
LOG_RUNTIME_ERROR=$NGINX_LOG_NAME$NGINX_V$LOG_ERROR
LOG_ACCESS='_access.log'
LOG_RUNTIME_ACCESS=$NGINX_LOG_NAME$NGINX_V$LOG_ACCESS
LOG_SETUP_PATH=$JAIL/logs/setup/
LOG_SETUP='_setup.log'
NGINX_FILE_NAME='nginxback'

LOG_FILE=$LOG_SETUP_PATH$NGINX_LOG_NAME$NGINX_V$LOG_SETUP


mkdir -p $LOG_SETUP_PATH
mkdir -p $LOG_RUNTIME_PATH
touch    $LOG_RUNTIME_PATH$LOG_RUNTIME_ERROR
touch    $LOG_RUNTIME_PATH$LOG_RUNTIME_ACCESS
# per run
mkdir -p $JAIL$LOG_RUNTIME_PATH
touch    $JAIL$LOG_RUNTIME_PATH$LOG_RUNTIME_ERROR
touch    $JAIL$LOG_RUNTIME_PATH$LOG_RUNTIME_ACCESS

# per creazione del pkg, deve esistere
mkdir -p $JAIL/usr/local/nginx


# --with-http_charset_module \ not found
# --with-http_geo_module \ not found
# --with-ld-opt='-static,-Wl,-z,relro,-z,now,-Wl,-E' \  # -e DA ERRORE...
# --with-http_xslt_module \ error: the HTTP XSLT module requires the libxml2/libxslt anche se lib installate con apt-get install libgeoip-dev  libxml2-dev libxslt1-dev  libxslt1.1


#CONF-PATH FORSE È SBAGLIATO ?
#tolgo static x filtrare errori
# pcre: The library is required for regular expressions support in the location directive and for the ngx_http_rewrite_module module



# http://stackoverflow.com/questions/23772816/when-do-i-need-zlib-in-openssl
# -> By default, compression is enabled unless you disable it at compile time or runtime. If compression is available, then you have to disable it at runtime with the SSL_OP_NO_COMPRESSION
# -> no-comp

#--with-cc-opt='-march=sandybridge


echo "- Eseguo ./configure + parametri"
cd $(echo $CDIR_BACK/nginx-$NGINX_V)
make clean
./configure \
--with-cc-opt='-g -O2 --param=ssp-buffer-size=4 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -Wp,-D_FORTIFY_SOURCE=2 -pipe -Wall -fexceptions -grecord-gcc-switches -m64 -DTCP_FASTOPEN=23' \
--with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now' \
--with-pcre=$CDIR_BACK/pcre-$PCRE_V \
--with-http_stub_status_module \
--with-http_realip_module \
--with-file-aio \
--with-http_auth_request_module \
--with-http_degradation_module \
--with-http_xslt_module \
--with-google_perftools_module \
--prefix=$JAIL/usr/local/nginx \
--sbin-path=$JAIL/usr/local/nginx/sbin/$NGINX_FILE_NAME \
--conf-path=$JAIL/conf/nginx.conf \
--error-log-path=$LOG_RUNTIME_PATH$LOG_RUNTIME_ERROR \
--http-log-path=$LOG_RUNTIME_PATH$LOG_RUNTIME_ACCESS \
--http-client-body-temp-path=$JAIL/usr/local/nginx/client_body_temp \
--http-proxy-temp-path=$JAIL/usr/local/nginx/proxy_temp \
--lock-path=/run/lock/$NGINX_FILE_NAME.lock \
--pid-path=/var/run/$NGINX_FILE_NAME.pid \
--user=www-data --group=www-data \
--without-http_autoindex_module \
--without-http_map_module --without-http_memcached_module \
--without-http_ssi_module --without-http_userid_module \
--without-mail_pop3_module --without-mail_imap_module \
--without-mail_smtp_module --without-http_split_clients_module \
--without-http_uwsgi_module --without-http_scgi_module \
--without-http_referer_module \
--without-poll_module \
--without-select_module \
--without-http_gzip_module \
--without-http_upstream_ip_hash_module > $LOG_FILE
# --with-pcre-jit \ non usare x security
# --with-openssl-opt=no-krb5 \ non piu valido ?
# --with-http_limit_req_module \ boh non va ??
# --with-http-cache_module \ non esiste penso sia il modulo proxy
# --with-ipv6



cat $LOG_FILE

echo "- Tra 5 secondi inzio la compilazione"
echo "5"
sleep 1
echo "4"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1

#http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log
#access_log logs/access.log combined;


# with -j > 1 nginx's tries to link openssl before it gets built
echo "- Wait about 1 minut"
time make -j1 >> $LOG_FILE 2>&1

echo "- Creo il pacchetto deb"
# create .deb  nginx-1.11.1/*.deb
UND='_'
checkinstall --install=no --type=debian --pkgname=$NGINX_FILE_NAME --pkgsource=$NGINX_FILE_NAME$UND$NGINX_V --pakdir=$CDIR_BACK --nodoc --maintainer=imagingagency.com --default


UND='_'
DEB='-1_amd64.deb'
cd $CDIR_BACK
echo
echo "da host esegui:"
echo "scp $CDIR_BACK/$NGINX_FILE_NAME$UND$NGINX_V$DEB user@SERVER_IP:/folder/path/"
echo
exit 0


