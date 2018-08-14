#!/bin/bash

###
### Script for getting Alfresco Metadata files (Bulk Import) for a given downloaded Alfresco folder structure
###

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

if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ]; then
    usage
fi

# Needs at least -f as parameter 
if [ -z "${FOLDER}" ]; then
    usage
fi

# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in `find $FOLDER`
do
  aux=`echo "$f" | sed -e 's#^webdav##'`
  echo "Getting metadata file for path: $aux"
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/net/zylk/export-bulk-metadata?path=$aux" > ./webdav/$aux.metadata.properties.xml
done
IFS=$SAVEIFS

