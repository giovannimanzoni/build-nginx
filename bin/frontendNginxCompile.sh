#!/bin/bash

echo
echo ">>> COMPILO <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 5 ]; then
  echo "Non hai inserito la versione desiderata dei pacchetti"
  echo " esempio: ./frontendNginxCompile.sh NGINX_VERSION PCRE_VERSION OPENSSL_VERSION ZLIB_VERSION CDIR"
  echo " esempio: ./frontendNginxCompile.sh 1.13.0 8.40 1.1.0e 1.2.11 /root/compila/nginx/frontend"
  echo
  exit 0
fi

NGINX_V=$1
PCRE_V=$2
OPENSSL_V=$3
ZLIB_V=$4
CDIR=$5
CDIR_FRONT=$CDIR/frontend

J_BASE='/srv/front'
JAIL=$J_BASE # path di installazione

NGINX_LOG_NAME='nginx_'
LOG_RUNTIME_PATH=$JAIL/logs/runtime/
LOG_ERROR='_error.log'
LOG_RUNTIME_ERROR=$NGINX_LOG_NAME$NGINX_V$LOG_ERROR
LOG_ACCESS='_access.log'
LOG_RUNTIME_ACCESS=$NGINX_LOG_NAME$NGINX_V$LOG_ACCESS
LOG_SETUP_PATH=$JAIL/logs/setup/
LOG_SETUP='_setup.log'
NGINX_FILE_NAME='nginxfront'

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




# http://stackoverflow.com/questions/23772816/when-do-i-need-zlib-in-openssl
# -> By default, compression is enabled unless you disable it at compile time or runtime. If compression is available, then you have to disable it at runtime with the SSL_OP_NO_COMPRESSION
# -> no-comp


echo "- Eseguo ./configure + parametri"
cd $(echo $CDIR_FRONT/nginx-$NGINX_V)
make clean
./configure \
--with-cc-opt='-g -O2 --param=ssp-buffer-size=4 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -Wp,-D_FORTIFY_SOURCE=2 -pipe -Wall -fexceptions -grecord-gcc-switches -m64 -DTCP_FASTOPEN=23' \
--with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now' \
--with-pcre=$CDIR_FRONT/pcre-$PCRE_V \
--with-zlib=$CDIR_FRONT/zlib-$ZLIB_V \
--with-openssl=$CDIR_FRONT/openssl-$OPENSSL_V \
--with-openssl-opt=no-comp \
--with-http_ssl_module \
--with-openssl-opt=enable-ec_nistp_64_gcc_128 \
--with-openssl-opt=no-nextprotoneg \
--with-openssl-opt=no-weak-ssl-ciphers \
--with-openssl-opt=no-ssl3 \
--with-http_gzip_static_module \
--with-http_gunzip_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-poll_module \
--with-select_module \
--with-http_geoip_module \
--with-file-aio \
--with-http_auth_request_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_v2_module \
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
--user=$NGINX_FILE_NAME --group=$NGINX_FILE_NAME \
--without-http_autoindex_module \
--without-http_empty_gif_module \
--without-http_fastcgi_module \
--without-http_map_module --without-http_memcached_module \
--without-http_ssi_module --without-http_userid_module \
--without-mail_pop3_module --without-mail_imap_module \
--without-mail_smtp_module --without-http_split_clients_module \
--without-http_uwsgi_module --without-http_scgi_module \
--without-http_referer_module \
--without-http_upstream_ip_hash_module > $LOG_FILE
# --with-pcre-jit \ non usare x security
# --with-ipv6 deprecato
# --with-http_gzip_module  -> gia abilitato di default



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
echo "- Eseguo make, tempo di attesa meno di 5 minuti"
time make -j1 >> $LOG_FILE 2>&1

echo "- Creo il pacchetto deb"
# create .deb  nginx-1.11.1/*.deb
UND='_'
checkinstall --install=no --type=debian --pkgname=$NGINX_FILE_NAME --pkgsource=$NGINX_FILE_NAME$UND$NGINX_V --pakdir=$CDIR_FRONT --nodoc --maintainer=imagingagency.com --default


UND='_'
DEB='-1_amd64.deb'
cd $CDIR_FRONT
echo
echo "file deb in $CDIR_FRONT/$NGINX_FILE_NAME$UND$NGINX_V$DEB"
echo
exit 0


