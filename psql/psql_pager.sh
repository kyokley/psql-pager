#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PLUGIN_DIR="$SCRIPT_DIR/plugin"
exec vim --not-a-term -u NONE -S "$PLUGIN_DIR/psql.vim" -c "source $SCRIPT_DIR/common.vim" -c Less -
