#!/bin/bash
#
# Find OS kernel modules, depending on what this means for the build OS.
#
# Setup modules in FLAVOUR_oskernelmodules.  Note that the variables
# VERSION_oskernel and VARIANT_oskernel are meaningful too.
#
# From: Rick van Rein <rick@openfortress.nl>


. $(dirname "$0")/lib/stdlib
. $(dirname "$0")/lib/kernellib

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
	kernel_files
}

do_variants () {
	echo -n ''
}

do_flavours () {
	echo -n ''
}

main_do_commands "$@"
