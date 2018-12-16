#!/bin/bash
# Build Nginx as frontend
#   on host require
#       apt update && apt-get install libgoogle-perftools-dev libxml2-dev libxslt1-dev libxslt1.1 libgeoip-dev checkinstall
# ---------------------
#   on target require:
#       apt update && apt install libxslt1.1 libgoogle-perftools4
#       mkdir -p /srv/front/logs/runtime/
#       touch /srv/front/logs/runtime/nginx_x.yy.z_error.log
#       mkdir -p /srv/front/conf/common/
#       nano /srv/front/conf/common/upstream-cache.conf


echo
echo
echo ">>> Nginx frontend <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 4 ]; then
  echo "You have to insert packages version to use."
  echo " example: ./1frontendNginx.sh NGINX_VERSION PCRE1_VERSION OPENSSL_VERSION ZLIB_VERSION"
  echo " example: ./1frontendNginx.sh 1.15.7 8.42 1.1.1a 1.2.11"
  echo
  exit 0
fi

#parametri
NGINX_V=$1
PCRE_V=$2
OPENSSL_V=$3
ZLIB_V=$4

#build folder
CDIR=$(pwd)/build
mkdir -p $CDIR/frontend


# clean build folders (if you break this script or it do not reach the end)
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


# clean build folders
cd $CDIR/frontend
rm -rf nginx-$NGINX_V > /dev/null 2>&1
rm -rf pcre-$PCRE_V > /dev/null 2>&1
rm -rf openssl-$OPENSSL_V > /dev/null 2>&1
rm -rf zlib-$ZLIB_V > /dev/null 2>&1
cd $CDIR

echo
echo "ok."
echo





