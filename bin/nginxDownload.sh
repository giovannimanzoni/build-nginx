#!/bin/sh
echo


echo
echo ">>> DOWNLOAD <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 5 ]; then
  echo "Non hai inserito la versione desiderata dei pacchetti"
  echo " esempio: ./frontendNginxDownload.sh NGINX_VERSION PCRE_VERSION OPENSSL_VERSION ZLIB_VERSION CDIR"
  echo " esempio: ./frontendNginxDownload.sh 1.13.0 8.40 1.1.0e 1.2.11 /home/compila/nginx"
  echo
  exit 0
fi

NGINX_V=$1
PCRE_V=$2
OPENSSL_V=$3
ZLIB_V=$4
CDIR=$5


echo " - Scarico i file"
mkdir -p $CDIR/src
cd $CDIR/src


# controllo se esiste il file
echo "   - PCRE $PCRE_V"
if [ -f "pcre-$PCRE_V.tar.gz" ]; then
  echo "     - PCRE già scaricato"
else
  wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_V.tar.gz >/dev/null 2>&1
  echo "     - PCRE scaricato"
fi
tar -zxf pcre-$PCRE_V.tar.gz --directory $CDIR/frontend
echo "     - PCRE estratto"


echo "   - NGINX $NGINX_V"
if [ -f "nginx-$NGINX_V.tar.gz" ]; then
  echo "     - NGINX già scaricato"
else
  wget http://nginx.org/download/nginx-$NGINX_V.tar.gz >/dev/null 2>&1
  echo "     - NGINX scaricato"
fi
tar -zxf nginx-$NGINX_V.tar.gz --directory $CDIR/frontend
echo "     - NGINX estratto"


echo "   - OPENSSL $OPENSSL_V"
if [ -f "openssl-$OPENSSL_V.tar.gz" ]; then
  echo "     - OPENSSL già scaricato"
else
  wget https://www.openssl.org/source/openssl-$OPENSSL_V.tar.gz >/dev/null 2>&1
  echo "     - OPENSSL scaricato"
fi
tar -zxf openssl-$OPENSSL_V.tar.gz --directory $CDIR/frontend
echo "     - OPENSSL estratto"


echo "   - ZLIB $ZLIB_V"
if [ -f "zlib-$ZLIB_V.tar.gz" ]; then
  echo "     - ZLIB già scaricato"
else
  wget http://zlib.net/zlib-$ZLIB_V.tar.gz >/dev/null 2>&1
  echo "     - ZLIB scaricato"
fi
tar -zxf zlib-$ZLIB_V.tar.gz --directory $CDIR/frontend
echo "     - ZLIB estratto"


echo
echo "Ok"
echo


