FROM python:3.12.5-slim-bookworm

# hadolint ignore=DL3008
RUN apt-get update -y \
 && apt-get install --no-install-recommends --no-install-suggests -y \
    jo jq git curl procps \
    libffi-dev build-essential \
    libfreetype6-dev ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -ms /bin/bash persona

COPY ./scripts /scripts
RUN chmod 755 /scripts/*.sh \
 && mv /scripts/init.sh /init \
 && cp /scripts/backend.sh /usr/local/bin/reverie \
 && for file in api.sh backend.sh superuser.sh; do \
        mv /scripts/"$file" /usr/local/bin/"${file%.sh}"; \
    done

ARG VERSION="unknown"
ENV TZ="UTC" \
    USER="persona" \
    DATA_DIR="/data" \
    PUID=1000 \
    PGID=1000 \
    CHOWN_ENABLED=true \
    DOCKER_VERSION_CHECK_ENABLED=true \
    DVWA_SOURCE_DOWNLOAD_ENABLED=false \
    SERVER_ENABLED=true \
    SERVER_INSTALL_ENABLED=true \
    SERVER_INSTALL_AWAIT=false \
    SERVER_INSTALL_URL="https://github.com/JustPersona/generative-agents" \
    SERVER_UPDATE_ENABLED=true \
    SERVER_UPDATE_AWAIT=false \
    VENV_INSTALL_ENABLED=true \
    VENV_INSTALL_AWAIT=false \
    FRONTEND_SERVER_ENABLED=true \
    FRONTEND_SERVER_ROOT="environment/frontend_server" \
    BACKEND_SERVER_ROOT="reverie/backend_server" \
    OLLAMA_CONFIG_ENABLED=true \
    OLLAMA_HOST="ollama" \
    OLLAMA_PORT=11434 \
    OLLAMA_ACTION="pull" \
    OLLAMA_MODEL_NAME="llama3.2:1b" \
    OLLAMA_GGUF_DOWNLOAD_ENABLED=true \
    OLLAMA_GGUF_DOWNLOAD_URL="" \
    OLLAMA_GGUF_PATH="persona.gguf" \
    OLLAMA_MODELFILE_PATH="Modelfile" \
    IMAGE_VERSION="$VERSION"

EXPOSE 8000
WORKDIR /data
ENTRYPOINT ["/init"]
