#!/bin/bash
#
# os command "build" script -- collects commands from the build OS
#
# A list of space-separated command names is in $FLAVOUR_oscommands
# and will be used to locate binaries, with support of file name globs.
# The customary listings, packages and even oslib packages can be made
# to retrieve the contents and possibly install them.
#
# Using this, together with oslibraries.sh and osfiles.sh, it should
# be possible to make more refined extractions than with ospackages.sh
# and find smaller boot-time images.  This may be of interest when
# resources are tight, be they memory or bandwidth.
#
# From: Rick van Rein <rick@openfortress.nl>


. $(dirname "$0")/lib/stdlib

default_VERSION 0.0.0

do_touch () {
	echo -n ''
}

do_update () {
	echo -n ''
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do_check () {
	# Always out of date
	return 1;
}

do_build () {
	echo -n "$PATH:" | sed "s+:+\n+g" | \
	while read ROOTNAME
	do
		if [ ! -h "$DIR_TREE$ROOTNAME" ]
		then
			ROOTDIR=$(dirname "$ROOTNAME")
			mkdir -p "$DIR_TREE$ROOTDIR"
			ln -s "$ROOTNAME" "$DIR_TREE$ROOTNAME"
		fi
	done
}

do_test () {
	return 0;
}

do_list () {
	do_build
	cd "$DIR_TREE"
	echo -n "$FLAVOUR_oscommands " | sed "s+ +\n+g" | \
	while read CMDPATN
	do
		find -L * -name $CMDPATN 2>/dev/null || true
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


