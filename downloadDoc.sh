#!/bin/bash

###
### Script for downloading an Alfresco document
###

# Usage functions
usage() { echo "Usage: $0 [-d uuid] [-n name]" 1>&2; exit 1; }

# Command line options
while getopts "u:p:hd:n:" o; do
    case "${o}" in
        u)
            MYUSER=${OPTARG}
            ;;
        p)
            MYPASS=${OPTARG}
            ;;
        d)
            MYUUID=${OPTARG}
            ;;
        n)
            MYNAME=${OPTARG}
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
if [ -z "${MYUUID}" ] && [ -z "${MYNAME}" ] ; then
    usage
fi

# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}

curl -s -u "$MYUSER:$MYPASS" "$ALFURL/api/-default-/public/cmis/versions/1.1/atom/content/zz?id=$MYUUID" -o "$MYNAME"
