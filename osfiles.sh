#!/bin/bash
#
# os file "build" script -- collects files from the build OS
#
# A list of newline-terminated package names is in $FLAVOUR_osfiles
# and will be used to resolve files, with support of file name globs.
# The customary listings, packages and even oslib packages can be made
# to retrieve the contents and possibly install them.
#
# From: Rick van Rein <rick@openfortress.nl>


. $(dirname "$0")/lib/stdlib

do_touch () {
	echo -n ''
}

do_update () {
	echo -n ''
}

do_dependencies () {
	echo -n ''
}

do_build () {
	find /* -maxdepth 0 | \
		while read ROOTNAME
		do
			ln -s "$ROOTNAME" "$DIR_TREE$ROOTNAME"
		done
}

do_list () {
	echo -n "$FLAVOUR_osfiles" | while read FILEPATN
	do
		ls -1 "$FILEPATN"
	done
}

do_variants () {
	echo -n ''
}

do_flavours () {
	# Not helpful to list all combinations of all files
	echo -n ''
}

main_do_commands "$@"


