#!/bin/bash
#
# ARPA2CM build script

. $(dirname "$0")/lib/stdlib

default_VERSION version-0.7

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://gitlab.com/arpa2/arpa2cm "$DIR_GIT"
	cd "$DIR_GIT" ; git reset $VERSION
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do_build2 () {
	cd "$DIR_BUILD"
	empty_dir
	cmake "$DIR_GIT"
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install
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

