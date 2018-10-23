#!/bin/sh
# Compila Nginx come Frontend
#   richiede apt-get update && apt-get install libgoogle-perftools-dev libxml2-dev libxslt1-dev libxslt1.1 libgeoip-dev checkinstall



echo


echo
echo ">>> PROCEDURA PER COMPILARE Nginx COME FRONTEND ! <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 4 ]; then
  echo "Non hai inserito la versione desiderata dei pacchetti"
  echo " esempio: ./1frontendNginx.sh NGINX_VERSION PCRE_VERSION OPENSSL_VERSION ZLIB_VERSION"
  echo " esempio: ./1frontendNginx.sh 1.13.0 8.40 1.1.0e 1.2.11"
  echo
  exit 0
fi

#parametri
NGINX_V=$1
PCRE_V=$2
OPENSSL_V=$3
ZLIB_V=$4

#directory di compilazione
CDIR=/home/compila/build
mkdir -p $CDIR/frontend


#pulizia cartelle di compilazione
cd $CDIR/frontend
rm -rf nginx-$NGINX_V > /dev/null 2>&1
rm -rf pcre-$PCRE_V > /dev/null 2>&1
rm -rf openssl-$OPENSSL_V > /dev/null 2>&1
rm -rf zlib-$ZLIB_V > /dev/null 2>&1
cd $CDIR
cd ..

cd bin
./nginxDownload.sh $NGINX_V $PCRE_V $OPENSSL_V $ZLIB_V $CDIR
./nginxFix.sh $NGINX_V $CDIR/frontend
./frontendNginxCompile.sh $NGINX_V $PCRE_V $OPENSSL_V $ZLIB_V $CDIR


#pulizia cartelle di compilazione
cd $CDIR/frontend
rm -rf nginx-$NGINX_V > /dev/null 2>&1
rm -rf pcre-$PCRE_V > /dev/null 2>&1
rm -rf openssl-$OPENSSL_V > /dev/null 2>&1
rm -rf zlib-$ZLIB_V > /dev/null 2>&1
cd $CDIR

echo
echo "Procedura completata"
echo





