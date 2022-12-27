#!/bin/bash

###
### Script for get folder permission template 
###

# Usage functions
usage() { echo "Usage: $0 <noderef> [user] [role]" 1>&2; exit 1; }

# Exports ALFALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh

if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ] || [ -z "$1" ]; then
    usage
else
    curl -s -u $MYUSER:$MYPASS "$ALFURL/service/net/zylk/get-folder-permissions?proj=$1&user=$2&role=$3" 
fi
