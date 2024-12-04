#!/bin/bash

source "/scripts/functions.sh"



if [ -z "$(ls -A "$DVWA_DIR")" ]; then
	ACTION "Downloading DVWA Source to $DVWA_DIR"
	git clone https://github.com/digininja/DVWA "$DVWA_DIR"
	cp "$DVWA_DIR/config/config.inc.php.dist" "$DVWA_DIR/config/config.inc.php"
fi
