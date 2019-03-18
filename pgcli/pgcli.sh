#!/bin/bash

what=-
test "$@" && what="$@"
PLUGIN_DIR='/pager/plugin'
exec vim -u NONE -S $PLUGIN_DIR/pgcli.vim -c "let &runtimepath='$PLUGIN_DIR,' . &runtimepath" -c Less $what
