#!/bin/bash

###
### Script for setting permission from file template 
###

# Usage functions
usage() { echo "Usage: $0 [<permissions-file>]" 1>&2; exit 1; }

# Exports ALFALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh

if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ]; then
    usage
fi

for i in `awk -F";" '{print "noderef=" $4 "&user=" $2 "&role=" $3}' $1`; do
  #echo "curl -s -k --user \"$USER:$PASS\" \"$ALFURL/s/net/zylk/set-perm?${i}\""
  curl -s -k --user "$MYUSER:$MYPASS" "$ALFURL/s/net/zylk/set-perm?${i}"
  echo
done 
