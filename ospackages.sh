#!/bin/bash
#
# os package "build" script -- collects the files in OS packages
#
# A space-separated list of package names is in $FLAVOUR_ospackages
# and will be used to determine the usual package aspects, such as
# a list of dependencies and a list of file names.  The customary
# packages and oslib packages can be made to retrieve the contents
# and possibly install them.
#
# This mkhere script has an extra subcommand: "osupdate".  This
# retrieves recent package listings online and installs updates
# for all currently available packages.  Further details depend
# on the underlying package manager setup.
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
	for PKG in $FLAVOUR_ospackages
	do
		echo $PKG
	done
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
	. $(dirname "$0")/lib/pkglib
	DEPS=$(pkg_dependencies $FLAVOUR_ospackages)
	for PKG in $FLAVOUR_ospackages $DEPS
	do
		pkg_listfiles $PKG | \
			while read FILE
			do
				# List all but directories
				#TODO# FILE=${FILE#/}
				if [ ! -d "/$FILE" ]
				then
					echo "$FILE"
				fi
				# Additionally print link targets
				while [ -L "/$FILE" ]
				do
					FILE=$(readlink -f "/$FILE")
					#TODO# FILE=${FILE#/}
					if [ -d "/$FILE" ]
					then
						break
					fi
					echo "$FILE"
				done
			done
	done | \
	# Remove duplicates caused by link traversal
	unique
}

# The list of OS libraries will be split out per OS package
do_oslibs () {
	SAVE_ospackages="$FLAVOUR_ospackages"
	for PKG in $SAVE_ospackages
	do
		if [ ! -r "$DIR_BUILD/mkhere-oslibs-$PKG.txt" ]
		then
			FLAVOUR_ospackages="$PKG"
			do2_oslibs
			mv "$DIR_BUILD/mkhere-oslibs.txt" \
			   "$DIR_BUILD/mkhere-oslibs-$PKG.txt"
		fi
		cat "$DIR_BUILD/mkhere-oslibs-$PKG.txt"
	done | \
	# Remove duplicates caused by link traversal
	unique
	FLAVOUR_ospackages="$SAVE_ospackages"
}

do_variants () {
	echo -n ''
}

do_flavours () {
	# Not helpful to list all combinations of all packages
	echo -n ''
}

# The extra command for ospackages.sh
do_osupdate () {
	. $(dirname "$0")/lib/pkglib
	pkg_update
	find /build             -name mkhere-osdeps.txt   -exec rm {} \;
	find /build/ospackages* -name mkhere-osdeps-*.txt -exec rm {} \;
}

# The extra command for setting up mkhere
do_ossetup () {
	. $(dirname "$0")/lib/pkglib
	pkg_install build-essential git cmake wget pkg-config bison flex autoconf automake libtool gdbserver gdb
}


main_do_commands "$@"


