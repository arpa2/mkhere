#!/bin/bash
#
# os library "build" script -- collects shared objects from the build OS
#
# A list of space-separated library names is in $FLAVOUR_oslibraries
# and will be used to locate libraries, with support of file name globs.
# The customary listings, packages and even oslib packages can be made
# to retrieve the contents and possibly install them.
#
# This procedure is useful to locate libraries that are not visibly linked
# to binaries or libraries.  Examples are the PAM and NSS libraries, of
# which nss_files gives the strongest example; without it, the system will
# not be able to map uid 0 to username root, even with /etc/passwd present.
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
	cat /etc/ld.so.conf /etc/ld.so.conf.d/* | \
	sed -e 's/#.*$//' -e '/^[ \t]*$/d' -e '/^include[ \t].*/d' | \
	while read ROOTNAME
	do
		if [ ! -h "$DIR_TREE$ROOTNAME" ]
		then
			ROOTDIR=$(dirname "$ROOTNAME")
			if [ ! -x "$DIR_TREE/$ROOTDIR" ]
			then
				mkdir -p "$DIR_TREE$ROOTDIR"
				ln -s "$ROOTNAME" "$DIR_TREE$ROOTNAME"
			fi
		fi
	done
}

do_list () {
	do_build
	cd "$DIR_TREE"
	echo -n "$FLAVOUR_oslibraries " | sed "s+ +\n+g" | \
	while read LIBPATN
	do
		#TODO# Library pattern depends on the OS: .dll .def .dylib
		LIBPATN0="$LIBPATN.so"
		LIBPATN1="lib$LIBPATN-*.so"
		LIBPATN2="lib$LIBPATN.so*"
		find -L * -name $LIBPATN0 2>/dev/null || true
		find -L * -name $LIBPATN1 2>/dev/null || true
		find -L * -name $LIBPATN2 2>/dev/null || true
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


