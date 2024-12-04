#!/bin/bash

source "/scripts/functions.sh"



if [ "${OLLAMA_ACTION,,}" == "create" ]; then
	if [ "$OLLAMA_GGUF_DOWNLOAD_ENABLED" != false ]; then
		if [ -n "$OLLAMA_GGUF_DOWNLOAD_URL" ] && [ ! -f "$SHARE_DIR/$OLLAMA_GGUF_PATH" ]; then
			ACTION "Downloading GGUF"
			INFO "URL: $OLLAMA_GGUF_DOWNLOAD_URL"
			curl -sSL -o "$SHARE_DIR/$OLLAMA_GGUF_PATH" -# "$OLLAMA_GGUF_DOWNLOAD_URL"
		fi
	fi
	if [ -n "$OLLAMA_MODELFILE_PATH" ] && [ ! -f "$SHARE_DIR/$OLLAMA_MODELFILE_PATH" ]; then
		echo "FROM $SHARE_DIR/$OLLAMA_GGUF_PATH" > "$SHARE_DIR/$OLLAMA_MODELFILE_PATH"
	fi

	API="create"
	JSON="$(jo model="$OLLAMA_MODEL_NAME" stream=false path="$SHARE_DIR/$OLLAMA_MODELFILE_PATH")"
	TITLE="Creating Ollama Model"
else
	API="pull"
	JSON="$(jo model="$OLLAMA_MODEL_NAME" stream=false)"
	TITLE="Pulling Ollama Model"
fi

while ! curl -sfSL "$OLLAMA_HOST:$OLLAMA_PORT" > /dev/null 2>&1; do
	INFO "Wait for Ollama is running"
	sleep 3s
done

ACTION "$TITLE"
INFO "JSON: $JSON"
curl -sSL "$OLLAMA_HOST:$OLLAMA_PORT/api/$API" -d "$JSON"
