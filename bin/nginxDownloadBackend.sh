#!/bin/sh
echo


echo
echo ">>> DOWNLOAD <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 3 ]; then
  echo "Non hai inserito la versione desiderata dei pacchetti"
  echo " esempio: ./nginxDownloadBackend.sh NGINX_VERSION PCRE_VERSION CDIR"
  echo " esempio: ./nginxDownloadBackend.sh 1.13.0 8.40 /home/compila/nginx"
  echo
  exit 0
fi

NGINX_V=$1
PCRE_V=$2
CDIR=$3


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
tar -zxf pcre-$PCRE_V.tar.gz --directory $CDIR/backend
echo "     - PCRE estratto"


echo "   - NGINX $NGINX_V"
if [ -f "nginx-$NGINX_V.tar.gz" ]; then
  echo "     - NGINX già scaricato"
else
  wget http://nginx.org/download/nginx-$NGINX_V.tar.gz >/dev/null 2>&1
  echo "     - NGINX scaricato"
fi
tar -zxf nginx-$NGINX_V.tar.gz --directory $CDIR/backend
echo "     - NGINX estratto"

echo
echo "Ok"
echo


