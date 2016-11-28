#!/bin/bash

# Constants
# ==============

PROG_NAME=$(basename $0)
PROG_DIR_NAME=$(dirname $0)
isabs=$(echo $PROG_DIR_NAME | grep ^/)
if [ -z "$isabs" ] ; then 
	PROG_DIR_NAME="$PWD/$PROG_DIR_NAME"
fi

# MAIN {{{1
# =========

metabomatching.sh $PROG_DIR_NAME/test
