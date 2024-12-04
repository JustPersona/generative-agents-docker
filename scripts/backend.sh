#!/bin/bash

source "/scripts/variables.sh"
source "/scripts/functions.sh"



if [ ! -f "$BACKEND_DIR/utils.py" ]; then
	WARNING "Not found: ${BACKEND_DIR#/}/utils.py"
	INFO "Waiting to be copied..."
	while [ ! -f "$BACKEND_DIR/utils.py" ]; do
		sleep "$SLEEP_DURATION"
	done
fi

cd "$BACKEND_DIR" || exit
ACTION "Back-end has been Started"
LOG_WITHOUT_NEWLINE INFO  "Press Ctrl+c to "
LOG_WITHOUT_NEWLINE ERROR "force exit"
LOG_WITHOUT_NEWLINE INFO  ", double press to exit immediately\n"

if [ "$EUID" -eq 0 ]; then
	su "$USER" --session-command "$PYTHON reverie.py"
else
	$PYTHON reverie.py
fi
ACTION "Back-end is Stopped"
