#!/bin/bash

###
### Script for getting Alfresco Metadata files (Bulk Import) for a given downloaded Alfresco folder structure
###

rawurlencode() {
	local string="${1}"
	local strlen=${#string}
	local encoded=''
	local pos c o dot_enc
	if [ "$2" == 'yes' ]; then
		dot_enc='yes'
	fi

	for (( pos=0 ; pos<strlen ; pos++ )); do
		c=${string:$pos:1}
		case "$c" in
			[_~1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-])
				o="${c}"
			;;
			[.])
				if [[ "$dot_enc" == "yes" ]]; then
					o=$(printf "$c" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
				else
					o="${c}"
				fi
			;;
			*)
				o=$(printf "$c" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
		esac
		encoded+="${o}"
	done

	echo "$encoded"
	return 0
}

rawurldecode() {
  # This is perhaps a risky gambit, but since all escape characters must be
  # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
  # will decode hex for us
  printf -v decoded '%b' "${1//%/\\x}"

  echo "${decoded}"
  return 0
}

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

  #inp=`echo "$f" | sed -e 's#^webdav##'`
  inp=`rawurlencode "$f" | sed -e 's#^webdav##'`
  out=`rawurldecode "$inp"`
  echo "Getting metadata file for path: $inp"
  #echo "f   : $f"
  #echo "inp : $inp"
  #echo "out : $out"
  #echo "fld : $f.metadata.properties.xml" 
  curl -k -s -u $MYUSER:$MYPASS "$ALFURL/service/net/zylk/export-bulk-metadata?path=$inp" > "$f.metadata.properties.xml"
done
IFS=$SAVEIFS
