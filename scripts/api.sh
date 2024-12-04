#!/bin/bash

source "/scripts/functions.sh"

using() {
	INFO "$(cat << EOF
Using: docker exec -it <container_name> api [OPTION] [...PATH]
       e.g. docker exec -it <container_name> api pens <pen_code> payloads

OPTION:
  -p, --pretty, --pretty-print		Enabled Pretty-print

PATH:
  path to request
  path/to/request
  /path/to/request/
EOF
)"
}

args=()
while [ "${#@}" -ne 0 ]; do
	case "$1" in
		"-h"|"--help")
			using
			exit
			;;
		"-p"|"--pretty"|"--pretty-print")
			pretty=true
			;;
		*)
			args+=("$1")
			;;
	esac
	shift
done

pathname="$(JOIN "/" "${args[@]}")"
result="$(curl -sSL "http://localhost:8000/api/${pathname#/}")"
if [ "$pretty" = true ]; then
	echo "$result" | jq
else
	echo "$result"
fi
