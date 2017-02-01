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
scores_file=$PROG_DIR_NAME/test/sco.tsv
pdf_file=$PROG_DIR_NAME/test/sco.pdf
metabomatching.sh -g -i "$PROG_DIR_NAME/test/ps.test.multi/test.pseudospectrum.tsv" -p "$PROG_DIR_NAME/test/parameters.gxy.1.tsv" -s "$scores_file" -S "$pdf_file" || exit 1
[ -f "$scores_file" ] || exit 1
[ -f "$svg_file" ] || exit 1
