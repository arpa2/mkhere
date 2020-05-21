#!/bin/bash
#
# ARPA2CM build script

. $(dirname "$0")/lib/stdlib
. $(dirname "$0")/lib/toolgit
. $(dirname "$0")/lib/toolcmake

GIT_URL="https://gitlab.com/arpa2/arpa2cm.git"

default_VERSION v0.8.0

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do_test () {
	# Overrule CTest
	return 0;
}

do_list () {
	cd "$DIR_TREE"
	find . -type f,l | sed 's+^\./++'
}

do_variants () {
	echo -n ''
}

do_flavours () {
	echo -n ''
}

main_do_commands "$@"

