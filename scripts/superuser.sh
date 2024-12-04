#!/bin/bash

source "/scripts/variables.sh"



cd "$FRONTEND_DIR" || exit

$PYTHON manage.py createsuperuser "$@"
