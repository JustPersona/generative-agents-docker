#!/bin/bash

export DATA_DIR="/data"
export VENV_DIR="$DATA_DIR/venv"
export SHARE_DIR="/share"
export DVWA_DIR="/dvwa"
export FRONTEND_DIR="$DATA_DIR/$FRONTEND_SERVER_ROOT"
export BACKEND_DIR="$DATA_DIR/$BACKEND_SERVER_ROOT"

export PYTHON="$VENV_DIR/bin/python3"
export PIP="$VENV_DIR/bin/pip3"
export SLEEP_DURATION="3s"

export IMAGE_URL="https://github.com/JustPersona/generative-agents-docker"
export IMAGE_API="${IMAGE_URL/github\.com/api.github.com\/repos}"
export SERVER_INSTALL_URL="$SERVER_INSTALL_URL"
export SERVER_INSTALL_API="${SERVER_INSTALL_URL/github\.com/api.github.com\/repos}"
