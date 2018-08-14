#!/bin/bash

###
### getAlfrescoSites.sh [-f]
###
###
### Script for listing Alfresco Sites via REST API /service/api/sites 
###

# Usage functions
usage() { echo "Usage: $0 [-f]" 1>&2; exit 1; }

# Command line options
while getopts "fu:p:h:" o; do
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
            ALFURL=${OPTARG}
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

# Exports ALFALFURL,MYUSER,MYPASS 
source ./exportENVARS.sh

# Needs at least ALFURL as parameter 
if [ -z "${ALFURL}" ] || [ -z "${MYUSER}" ] || [ -z "${MYPASS}" ]; then
    usage
fi

# Default parameters
#ALFURL=${ALFURL:-http://localhost:8080/alfresco}
#MYUSER=${MYUSER:-admin}
#MYPASS=${MYPASS:-admin}
FULL=${FULL:-0}

# Full/Brief report
if [ "${FULL}" == "1" ]; then 
  #curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites" | jq '.'
  #curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites" | jq '.' | jsonv shortName,visibility,title
  #curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites" | jq '.' | jq '.[] | "\(.shortName),\(.visibility),\(.title),\(.siteManagers)"' | sed -e 's#\"##g' | sed -e 's#\\##g'
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites" | jq -r '.[] | "\(.shortName),\(.visibility),\(.title)"'
else
  curl -s -u $MYUSER:$MYPASS "$ALFURL/service/api/sites" | jq '.[] .shortName' | sed -e 's#\"##g' 
fi
