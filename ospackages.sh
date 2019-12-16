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
# From: Rick van Rein <rick@openfortress.nl>


. $(dirname "$0")/lib/stdlib

do_touch () {
	echo -n ''
}

do_update () {
	echo -n ''
}

do_dependencies () {
	for PKG in $FLAVOUR_ospackages
	do
		echo $PKG
	done
}

do_build () {
	find /* -maxdepth 0 | \
		while read ROOTNAME
		do
			ln -s "$ROOTNAME" "$DIR_TREE$ROOTNAME"
		done
}

do_list () {
	. $(dirname "$0")/lib/pkglib
	for PKG in $FLAVOUR_ospackages
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
	sort | uniq
}

do_variants () {
	echo -n ''
}

do_flavours () {
	# Not helpful to list all combinations of all packages
	echo -n ''
}

main_do_commands "$@"

