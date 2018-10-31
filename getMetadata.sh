#!/bin/bash

###
### Script for getting Alfresco Metadata files (Bulk Import) for a given downloaded Alfresco folder structure
###

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# Usage functions
usage() { echo "Usage: $0 [-f <local-webdav-folder>]" 1>&2; exit 1; }

# Command line options
while getopts "u:p:he:f:" o; do
    case "${o}" in
        u)
            MYUSER=${OPTARG}
            ;;
        p)
            MYPASS=${OPTARG}
            ;;
        e)
            URL=${OPTARG}
            ;;
        f)
            FOLDER=${OPTARG}
            ;;
        \?)
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
        h)
            usage 
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Exports ALFALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh
# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}

if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ]; then
    usage
fi

# Needs at least -f as parameter 
if [ -z "${FOLDER}" ]; then
    usage
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in `find $FOLDER`
do
  inp=`urlencode "$f" | sed -e 's#^webdav##'`
  out=`urldecode "$inp"`
  echo "Getting metadata file for path: $inp"
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/net/zylk/export-bulk-metadata?path=$inp" > "./webdav/$out.metadata.properties.xml"
done
IFS=$SAVEIFS
