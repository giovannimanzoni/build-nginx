#!/bin/bash


if [ $# -ne 2 ]; then
  echo "Non hai inserito la versione di nginx desiderata"
  echo " esempio: ./nginxFix.sh NGINX_VERSION CDIR"
  echo " esempio: ./nginxFix.sh 1.10.1  /home/compila/build/frontend"
  echo
  exit 0
fi


NGINX_V=$1
CDIR=$2

echo
echo ">>> SECURITY FIX <<<"
echo

#edito i file
cd $CDIR
cd nginx-$NGINX_V/src/http/
echo "- Hide Nginx web server string"
sed -i 's@Server: nginx@Imaging Agency Front End Web Server@' ngx_http_header_filter_module.c
sed -i 's@Server: " NGINX_VER CRLF;@Imaging Agency Front End Web Server" CRLF;@' ngx_http_header_filter_module.c
sed -i 's/\<center\>.*\<center\>/center>Imaging Agency Front End Web Server<\/center/g' ngx_http_special_response.c

echo
echo "Ok"
echo

