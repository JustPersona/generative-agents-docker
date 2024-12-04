#!/bin/bash

source "/scripts/variables.sh"
source "/scripts/functions.sh"



if [ "$EUID" -ne 0 ]; then
	ERROR "Permission denind"
	exit 1
elif [ "$PUID" -eq 0 ] || [ "$PGID" -eq 0 ]; then
	ERROR "PUID/PGID cannot be set to 0."
	exit 1
elif [ ! -d "$DATA_DIR" ]; then
	ERROR "$DATA_DIR is not mounted."
	exit 1
elif [ "$OLLAMA_SETTING_ENABLED" != false ] && [ "$OLLAMA_GGUF_DOWNLOAD_ENABLED" != false ] && [ -n "$OLLAMA_GGUF_DOWNLOAD_URL" ] && [ ! -d "$SHARE_DIR" ]; then
	ERROR "$SHARE_DIR is not mounted."
	exit 1
elif [ "$DVWA_SOURCE_DOWNLOAD_ENABLED" = true ] && [ ! -d "$DVWA_DIR" ]; then
	ERROR "$DVWA_DIR is not mounted."
	exit 1
fi



mkdir -p "$SHARE_DIR" "$DVWA_DIR"
if [ "$CHOWN_ENABLED" != false ]; then
	ACTION "Change UID/PID"
	INFO "User UID: $PUID"
	INFO "User GID: $PGID"
	usermod -o -u "$PUID" "$USER" > /dev/null 2>&1
	groupmod -o -g "$PGID" "$USER" > /dev/null 2>&1
	chown -R "$USER":"$USER" "$DATA_DIR" "/home/$USER" /scripts "$SHARE_DIR" "$DVWA_DIR"
fi



server_down() {
	mapfile -t pids < <(pgrep -f "manage.py|ollama serve|sleep infinity")
	for pid in "${pids[@]}"; do
		kill -15 "$pid" 2> /dev/null
		tail -f --pid="$pid" 2> /dev/null
	done
}
trap "server_down" 15



pids=()
if [ "$DVWA_SOURCE_DOWNLOAD_ENABLED" = true ]; then
	su "$USER" -c /scripts/dvwa.sh &
	pids+=("$!")
fi
if [ "$OLLAMA_CONFIG_ENABLED" != false ]; then
	su "$USER" -c /scripts/ollama.sh &
	pids+=("$!")
fi
if [ "$SERVER_ENABLED" != false ]; then
	su "$USER" -c /scripts/server.sh &
	pids+=("$!")
fi



for pid in "${pids[@]}"; do
	wait "$pid"
done

mapfile -t backs < <(pgrep -f reverie.py)
if [ "${#backs[@]}" -ne 0 ]; then
	ACTION "Waiting for Backend to end..."
	for back in "${backs[@]}"; do
		tail -f --pid="$back" 2> /dev/null
	done
fi
