#!/bin/bash

what=-
test "$@" && what="$@"
PLUGIN_DIR='/pager/plugin'
exec vim -u NONE -S $PLUGIN_DIR/psql.vim -c "let &runtimepath='$PLUGIN_DIR,' . &runtimepath" -c Less $what
