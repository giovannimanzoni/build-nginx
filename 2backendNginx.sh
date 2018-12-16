#!/bin/sh
# Build Nginx as bbackend
#   apt get update && apt-get install checkinstall


echo
echo
echo ">>> Nginx backend <<<"
echo
#controllo che venga passato il nome dell'utente con cui compilare Nginx
if [ $# -ne 2 ]; then
  echo "You have to insert packages version to use."
  echo " example: ./2backendNginx.sh NGINX_VERSION PCRE1_VERSION"
  echo " example: ./2backendNginx.sh 1.15.5 8.42"
  echo
  exit 0
fi

#parametri
NGINX_V=$1
PCRE_V=$2

#build folder
CDIR=$(pwd)/build
mkdir -p $CDIR/backend


# clean build folders (if you break this script or it do not reach the end)
cd $CDIR/backend
rm -rf nginx-$NGINX_V > /dev/null 2>&1
rm -rf pcre-$PCRE_V > /dev/null 2>&1
cd $CDIR
cd ..

cd bin
./nginxDownloadBackend.sh $NGINX_V $PCRE_V $CDIR
./nginxFixBack.sh $NGINX_V $CDIR/backend
./backendNginxCompile.sh $NGINX_V $PCRE_V $CDIR


# clean build folders
cd $CDIR/backend
rm -rf nginx-$NGINX_V > /dev/null 2>&1
rm -rf pcre-$PCRE_V > /dev/null 2>&1
cd $CDIR

echo
echo "ok."
echo





