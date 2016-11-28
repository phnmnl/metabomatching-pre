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

# Test with a directory
metabomatching.sh -g "$PROG_DIR_NAME/test" || exit 1

# Test with an input file
scores_file=$PROG_DIR_NAME/test/scores.tsv
svg_file=$PROG_DIR_NAME/test/image.svg
metabomatching.sh -g -i "$PROG_DIR_NAME/test/ps.test/test.pseudospectrum.tsv" -s "$scores_file" -S "$svg_file" || exit 1
[ -f "$scores_file" ] || exit 1
[ -f "$svg_file" ] || exit 1
