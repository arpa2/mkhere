#!/bin/bash
#
# mbusd build script

. $(dirname "$0")/lib/stdlib

default_VERSION 88916fe82daeadeff59de03b9f1647603f67be42

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/3cky/mbusd "$DIR_GIT"
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
	cmake -D CMAKE_INSTALL_PREFIX:PATH=/usr "$DIR_GIT"
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

