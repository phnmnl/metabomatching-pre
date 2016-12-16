#!/bin/bash
# Constants
# ==============

NM_PROG=$(basename $0)
DR_PROG=$(dirname $0)
isabs=$(echo $DR_PROG | grep ^/)
if [ -z "$isabs" ] ; then 
	DR_PROG="$PWD/$DR_PROG"
fi
YES=yes
DEBUG=0
DR_WORK=
IF_PSS=
IF_PAR=
OF_SCO=
OF_PDF=

function print_help {
	echo "Usage: $NM_PROG [options] directory"
	echo
	echo "metabomatching"
	echo
	echo "Options:"
	echo "   -g, --debug              Debug mode."
	echo "   -h, --help               Print this help message."
	echo "   -i, --input-file         Set input file."
	echo "   -s, --output-score-file  Set output score file."
	echo "   -S, --output-svg-file    Set output SVG file."
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
			-g|--debug)                  DEBUG=$((DEBUG + 1)) ;;
			-h|--help)                   print_help ; exit 0 ;;
			-i|--input-file)             IF_PSS=$(get_opt_val $1 $2) ; shift_count=2 ;;
			-p|--input-file-parameters)  IF_PAR=$(get_opt_val $1 $2) ; shift_count=2 ;;
			-s|--output-file-scores)     OF_SCO=$(get_opt_val $1 $2) ; shift_count=2 ;;
			-S|--output-file-pdf)        OF_PDF=$(get_opt_val $1 $2) ; shift_count=2 ;;
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
	if [ -z "$IF_PSS" ] ; then
		[ $# -eq 1 ] || error "You must specify one, and only one, directory to process."
		DR_WORK="$1"
		[ -d "$DR_WORK" ] || error "This is not a directory."
	else
		[ $# -eq 0 ] || error "You cannot specify a directory when using the -i option."
		[ -f "$IF_PSS" ] || error "\"$IF_PSS\" is not a file."
		[ -n "$OF_SCO" ] || error "When using -i option, you must also set -s option."
		[ -n "$OF_PDF" ] || error "When using -i option, you must also set -S option."
	fi
	
	# Debug
	print_debug_msg 1 "Arguments are : $args"
	print_debug_msg 1 "Directory to process is: $DR_WORK"
	print_debug_msg 1 "Input file to process is: $IF_PSS"
}

# MAIN {{{1
# =========

read_args "$@"

# Set working directory
if [ -n "$IF_PSS" ] ; then
	DR_WORK=working_dir
	rm -fr $DR_WORK
	mkdir -p $DR_WORK/ps.study
	cp $IF_PSS $DR_WORK/ps.study/tag.pseudospectrum.tsv
fi
if [ -n "$IF_PAR" ] ; then
	cp $IF_PAR $DR_WORK/ps.study/parameters.in.tsv
fi
# Execute
cd "$DR_WORK"
export DR_METABOMATCHING=$DR_PROG
octave-cli $DR_PROG/metabomatching.m
find -name "*.svg" -type f | while read file; do inkscape "${file}" --export-pdf="${file%.svg}.pdf"; done

if [ -n "$IF_PSS" ] ; then
	pdftk ps.study/*.pdf cat output ps.study/all.pdf
fi
cd -

# Move output files
if [ -n "$IF_PSS" ] ; then
	mv $DR_WORK/ps.study/tag.scores.tsv $OF_SCO
	mv $DR_WORK/ps.study/all.pdf $OF_PDF
fi
