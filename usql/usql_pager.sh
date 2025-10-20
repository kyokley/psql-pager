#!/usr/bin/env bash
what=-
test "$@" && what="$@"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PLUGIN_DIR="$SCRIPT_DIR/plugin"
exec vim --not-a-term -u NONE -S "$PLUGIN_DIR/usql.vim" -c "source $SCRIPT_DIR/common.vim" -c "let &runtimepath='$PLUGIN_DIR,' . &runtimepath" -c Less "$what"
