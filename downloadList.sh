#!/bin/bash

INPUT=$1 
OLDIFS=$IFS
IFS=';'

#if [ -z "$INPUT" ]; then
#  echo "Usage: downloadList.sh <listfile>"
#  exit 1;
#fi

#if [ ! -f $INPUT ]; then 
#  echo "Usage: downloadList.sh <listfile>"
#  echo "ERROR: $INPUT file not found"; 
#  exit 1;
#fi 

# Exports ALFALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh
curl -s -u "$MYUSER:$MYPASS" "$ALFURL/s/net/zylk/get-download-list" > /tmp/alflist
INPUT=/tmp/alflist

while read aux1 aux2 aux3 
do
  echo "Downloading document... $aux1 ($aux3)"
  ./downloadDoc.sh -d $aux1 -n "$aux3" 
  mkdir -p "$aux2"
  mv "$aux3" "$aux2"
done < $INPUT
IFS=$OLDIFS
