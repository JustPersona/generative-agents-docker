#!/bin/bash

source "/scripts/variables.sh"
source "/scripts/functions.sh"



mapfile -t codes < <(ls "$FRONTEND_DIR/storage/")
if [ "${#codes[@]}" -eq 0 ]; then
        echo "Not found: <pen_code> in ${FRONTEND_DIR#/}/storage/"
        exit
fi

cd "$FRONTEND_DIR/.." || exit
ACTION "Select the folder to compress:"
select pen_code in "${codes[@]}"; do
	if [ -z "$pen_code" ]; then
		continue
	fi
	$PYTHON -c "$(cat << EOF
from compress_pen_storage import compress
compress("$pen_code")
EOF
)"
	break
done
