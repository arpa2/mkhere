#!/bin/bash
#
# hexio build script

. $(dirname "$0")/lib/stdlib

default_VERSION version-1.1-RC1

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/vanrein/hexio "$DIR_GIT"
	cd "$DIR_GIT" ; git reset $VERSION
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	cmake -D CMAKE_INSTALL_PREFIX:PATH=/usr "$DIR_GIT"
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

