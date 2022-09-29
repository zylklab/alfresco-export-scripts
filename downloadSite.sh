#!/bin/bash

###
### Script for downloading an Alfresco Site via webdav 
###

# Usage functions
usage() { echo "Usage: $0 [-s <site-shortname>] | [-f <folder>]" 1>&2; exit 1; }

# Command line options
while getopts "u:p:he:s:f:l:" o; do
    case "${o}" in
        u)
            MYUSER=${OPTARG}
            ;;
        p)
            MYPASS=${OPTARG}
            ;;
        e)
            ALFURL=${OPTARG}
            ;;
        s)
            SITE=${OPTARG}
            ;;
        f)
            FOLDER=${OPTARG}
            ;;
        l)
            MAXDEPTHLEVEL=${OPTARG}
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

# Needs at least site as parameter 
if [ -z "${SITE}" ] && [ -z "${FOLDER}" ] ; then
    usage
fi

# Needs at least default max depth level param
if [ -z "${MAXDEPTHLEVEL}" ]; then
    usage
fi

# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}
#SITE=${SITE:-swdps}

if [ -n "${SITE}" ]; then
  #wget -r -nH -np -nv --cut-dirs=1 --user=$MYUSER --password=$MYPASS "$ALFURL/webdav/Sitios/$SITE/documentLibrary"
  wget -r -nH -np -nv --level=$MAXDEPTHLEVEL --cut-dirs=1 --user=$MYUSER --password=$MYPASS "$ALFURL/webdav/Sites/$SITE/documentLibrary"
else
  wget -r -nH -np -nv --level=$MAXDEPTHLEVEL --cut-dirs=1 --user=$MYUSER --password=$MYPASS "$ALFURL/webdav/$FOLDER"
fi
