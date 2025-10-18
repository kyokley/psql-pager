#!/bin/bash

what=-
test "$@" && what="$@"
PLUGIN_DIR='/pager/plugin'
exec vim --not-a-term -u NONE -S $PLUGIN_DIR/usql.vim -c "let &runtimepath='$PLUGIN_DIR,' . &runtimepath" -c Less $what
