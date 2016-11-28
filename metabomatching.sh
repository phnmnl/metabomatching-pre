#!/bin/bash
# Constants
# ==============

PROG_NAME=$(basename $0)
PROG_DIR_NAME=$(dirname $0)
isabs=$(echo $PROG_DIR_NAME | grep ^/)
if [ -z "$isabs" ] ; then 
	PROG_DIR_NAME="$PWD/$PROG_DIR_NAME"
fi
YES=yes
DEBUG=0
DIRECTORY=
INPUT_FILE=
OUTPUT_SCORE_FILE=
OUTPUT_SVG_FILE=

function print_help {
	echo "Usage: $PROG_NAME [options] directory"
	echo
	echo "metabomatching"
	echo
	echo "Options:"
	echo "   -g, --debug            Debug mode."
	echo "   -h, --help             Print this help message."
}
# Error {{{1
# ==========

function error {

	local msg=$1

	echo "ERROR: $msg" >&2

	exit 1
}

# Print debug msg {{{1
# ====================

function print_debug_msg {

	local dbglvl=$1
	local dbgmsg=$2

	[ $DEBUG -ge $dbglvl ] && echo "[DEBUG] $dbgmsg" >&2
}
# Get opt val {{{1
# ================

function get_opt_val {
	[ -n "$2" ] || error "\"$1\" requires a non-empty option argument."
	echo $2
}
# Read args {{{1
# ==============

function read_args {

	local args="$*" # save arguments for debugging purpose
	
	# Read options
	while true ; do
		shift_count=1
		case $1 in
			-g|--debug)               DEBUG=$((DEBUG + 1)) ;;
			-h|--help)                print_help ; exit 0 ;;
			-i|--input-file)          INPUT_FILE=$(get_opt_val $1 $2) ; shift_count=2 ;;
			-s|--output-score-file)   OUTPUT_SCORE_FILE=$(get_opt_val $1 $2) ; shift_count=2 ;;
			-S|--output-svg-file)     OUTPUT_SVG_FILE=$(get_opt_val $1 $2) ; shift_count=2 ;;
			-) error "Illegal option $1." ;;
			--) error "Illegal option $1." ;;
			--*) error "Illegal option $1." ;;
			-?) error "Unknown option $1." ;;
			-[^-]*) split_opt=$(echo $1 | sed 's/^-//' | sed 's/\([a-zA-Z]\)/ -\1/g') ; set -- $1$split_opt "${@:2}" ;;
			*) break
		esac
		shift $shift_count
	done
	shift $((OPTIND - 1))

	# Read remaining arguments
	if [ -z "$INPUT_FILE" ] ; then
		[ $# -eq 1 ] || error "You must specify one, and only one, directory to process."
		DIRECTORY="$1"
		[ -d "$DIRECTORY" ] || error "This is not a directory, you fool"
	else
		[ $# -eq 0 ] || error "You cannot specify a directory when using the -i option."
		[ -f "$INPUT_FILE" ] || error "\"$INPUT_FILE\" is not a file."
		[ -n "$OUTPUT_SCORE_FILE" ] || error "When using -i option, you must also set -s option."
		[ -n "$OUTPUT_SVG_FILE" ] || error "When using -i option, you must also set -S option."
	fi
	
	# Debug
	print_debug_msg 1 "Arguments are : $args"
	print_debug_msg 1 "Directory to process is: $DIRECTORY"
	print_debug_msg 1 "Input file to process is: $INPUT_FILE"
}

# MAIN {{{1
# =========

read_args "$@"

# Set working directory
if [ -n "$INPUT_FILE" ] ; then
	DIRECTORY=working_dir
	rm -r $DIRECTORY
	mkdir $DIRECTORY
	cp $INPUT_FILE $DIRECTORY/tag.pseudospectrum.tsv
fi
cd "$DIRECTORY"

export METABOMATCHING_SCRIPTDIR=$PROG_DIR_NAME
octave-cli $PROG_DIR_NAME/metabomatching.m

# Move output files
mv $DIRECTORY/tag.scores.tsv $OUTPUT_SCORE_FILE
mv $DIRECTORY/tag.svg $OUTPUT_SVG_FILE
