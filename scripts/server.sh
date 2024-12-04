#!/bin/bash

source "/scripts/functions.sh"



if [ "$DOCKER_VERSION_CHECK_ENABLED" != false ]; then
	ACTION "Checking Container Version..."
	INFO "Current Version of the Container: ${IMAGE_VERSION#v}"
	if ! [[ "${IMAGE_VERSION#v}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		WARNING "${IMAGE_VERSION#v} is Unreleased Version"
	fi

	LATEST_VERSION="$(curl -s "$IMAGE_API/releases/latest" | jq .name -r)"
	if [ "${IMAGE_VERSION#v}" == "${LATEST_VERSION#v}" ]; then
		SUCCESS "Already Up To Date"
	else
		IMPORTANT "New Released Version: ${LATEST_VERSION#v}"
		INFO "How to update: $IMAGE_URL"
	fi
fi



cd "$DATA_DIR" || exit
SERVER_ALREADY_INSTALLED=false
if [ -d "$DATA_DIR/.git" ]; then
	SERVER_ALREADY_INSTALLED=true
elif [ "$SERVER_INSTALL_ENABLED" != false ]; then
	LOCKFILE="$DATA_DIR/.install.lock"
	if [ "$SERVER_INSTALL_AWAIT" = true ]; then
		touch "$LOCKFILE"
		SERVER_INSTALL_LOCKED=true
	else
		if ! TAKELEAD "$LOCKFILE"; then
			SERVER_INSTALL_LOCKED=true
		else
			ACTION "Starting Server Installation"
			git init
			git remote add origin "$SERVER_INSTALL_URL"
			git fetch origin main
			git checkout main
			rm "$LOCKFILE"
		fi
	fi
	if [ "$SERVER_INSTALL_LOCKED" = true ]; then
		INFO "Waiting for Server to be Installed..."
		LOCKED "$LOCKFILE"
	fi
fi

if [ "$SERVER_ALREADY_INSTALLED" = true ] && [ "$SERVER_UPDATE_ENABLED" != false ]; then
	LOCKFILE="$DATA_DIR/.update.lock"
	if [ "$SERVER_UPDATE_AWAIT" = true ]; then
		touch "$LOCKFILE"
		SERVER_UPDATE_LOCKED=true
	else
		if ! TAKELEAD "$LOCKFILE"; then
			SERVER_UPDATE_LOCKED=true
		else
			if [ -d "$DATA_DIR/.git" ]; then
				ACTION "Starting Server Update"
				CURRENT_COMMIT=$(git log HEAD -1 --format=format:%H)
				INFO "Current Version: $CURRENT_COMMIT"
				LATEST_COMMIT=$(curl -sfSL "$SERVER_INSTALL_API/commits/main" 2> /dev/null | jq .sha -r)
				if [ -z "$LATEST_COMMIT" ]; then
					WARNING "Failed to check latest version"
				elif [ "$CURRENT_COMMIT" == "$LATEST_COMMIT" ]; then
					SUCCESS "Already Up To Date!"
				else
					INFO "Latest Version: $LATEST_COMMIT"
					git stash save "$(date "+%F %T")"
					git fetch origin main
					git pull origin main
				fi
			fi
			rm "$LOCKFILE"
		fi
	fi
	if [ "$SERVER_UPDATE_LOCKED" = true ]; then
		INFO "Waiting for Server to be Up To Dated..."
		LOCKED "$LOCKFILE"
	fi
fi



mkdir -p "$VENV_DIR"
if [ "$VENV_INSTALL_ENABLED" != false ] && ! sha256sum -c "$VENV_DIR/.installed" > /dev/null 2>&1; then
	LOCKFILE="$VENV_DIR/.lock"
	if [ "$VENV_INSTALL_AWAIT" = true ]; then
		touch "$LOCKFILE"
		VENV_LOCKED=true
	else
		if ! TAKELEAD "$LOCKFILE"; then
			VENV_LOCKED=true
		else
			if [ ! -f "$VENV_DIR/.installed" ]; then
				ACTION "Creating VENV"
				python3 -m venv "$VENV_DIR"
				touch "$VENV_DIR/.installed"
			fi
			if ! sha256sum -c "$VENV_DIR/.installed" > /dev/null 2>&1; then
				ACTION "Updating VENV Modules"
				$PIP install -U pip
				$PIP install -Ur "$DATA_DIR/requirements.txt"
				sha256sum "$DATA_DIR/requirements.txt" > "$VENV_DIR/.installed"
			fi
			rm "$LOCKFILE"
		fi
	fi
	if [ "$VENV_LOCKED" = true ]; then
		INFO "Waiting for VENV to be installed..."
		LOCKED "$LOCKFILE"
	fi
fi
echo "source $VENV_DIR/bin/activate" >> ~/.bashrc



if [ ! -f "$BACKEND_DIR/utils.py" ]; then
	cp /scripts/utils.py "$BACKEND_DIR/utils.py"
fi



if [ "$FRONTEND_SERVER_ENABLED" != false ]; then
	cd "$FRONTEND_DIR" || exit
	ACTION "Front-end has been Started"
	$PYTHON manage.py migrate
	$PYTHON manage.py runserver 0.0.0.0:8000
	ACTION "Front-end is Stopped"
fi
