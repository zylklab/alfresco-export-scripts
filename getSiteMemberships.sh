#!/bin/bash

###
### Script for getting Alfresco Site Memership via REST API 
###

# Usage functions
usage() { echo "Usage: $0 [-f | -s <site>]" 1>&2; exit 1; }

# Command line options
while getopts "fu:p:h:s:" o; do
    case "${o}" in
        f)
            FULL=1
            ;;
        u)
            MYUSER=${OPTARG}
            ;;
        p)
            MYPASS=${OPTARG}
            ;;
        h)
            URL=${OPTARG}
            ;;
        s)
            SITE=${OPTARG}
            ;;
        \?)
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Exports ALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh

# Needs at least URL as parameter 
if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ]; then
    usage
fi

if [ -z "${SITE}" ] && [ -z "${FULL}" ]; then
    usage
fi

# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}
#SITE=${SITE:-swsdp}
FULL=${FULL:-0}

if [ "${FULL}" == "1" ]; then 
  for i in `curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites" | jq '.[] .shortName' | sed -e 's#\"##g'`;
    do 
      curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites/$i/memberships" | jq '.[] | "\(.authority.userName),\(.role)"' | sed -e 's#\"##g' | sed -e "s/^/$i,/g"
    done
else
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites/$SITE/memberships" | jq '.[] | "\(.authority.userName),\(.role)"' | sed -e 's#\"##g' | sed -e "s/^/${SITE},/g"
fi 
