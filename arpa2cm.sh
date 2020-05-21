#!/bin/bash
#
# ARPA2CM build script

. $(dirname "$0")/lib/stdlib
. $(dirname "$0")/lib/toolgit

GIT_URL="https://gitlab.com/arpa2/arpa2cm.git"

default_VERSION v0.8.0

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	cmake "$DIR_SRC"
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install
}

do_test () {
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

