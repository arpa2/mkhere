#!/bin/bash
#
# os terminfo "build" script -- collects terminal infos from the build OS
#
# A list of terminal names or globs, separated by spaces, is expected
# in FLAVOUR_osterminfo.  When absent, the selection will default to
# something completely unreliable like "ansi xterm* vt*".  Do
# not rely on it, it may change without notice and break your builds.
#
# The older termcap(5) system points to terminfo(5) as its successor,
# but future versions of this script may incorporate that too.  This
# will be done when really required (which is expected to never happen).
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

do_osdependencies () {
	echo -n ''
}

do_check () {
	# Always out of date
	return 1;
}

do_build () {
	find /* -maxdepth 0 | \
		while read ROOTNAME
		do
			if [ ! -h "$DIR_TREE$ROOTNAME" ]
			then
				ln -s "$ROOTNAME" "$DIR_TREE$ROOTNAME"
			fi
		done
}

do_test () {
	return 0;
}

do_list () {
	for PATN in ${FLAVOUR_osterminfo:-vt* ansi xterm*}
	do
		if false   #TODO#WONTWORK# [[ "$PATN" =~ "^[a-zA-Z0-9]" ]]
		then
			FIRST="${PATN:0:1}"
		else
			FIRST='*'
		fi
		SELECTORS+=( "/lib/terminfo/$FIRST/$PATN" )
	done
	find ${SELECTORS[@]} -type f | sed 's+^/++'
}

do_variants () {
	echo -n ''
}

do_flavours () {
	# Not helpful to list all combinations of all files
	echo -n ''
}

main_do_commands "$@"


