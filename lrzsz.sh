#!/bin/bash
#
# rz/sz build script

. $(dirname "$0")/lib/stdlib

#Note: Debian has a 0.12.21 which is not released?!?
default_VERSION 0.12.20

do_update () {
	cd "$DIR_FETCH"
	wget https://ohse.de/uwe/releases/lrzsz-${VERSION}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/lrzsz-${VERSION}"
	tar -xzvf "$DIR_FETCH/lrzsz-${VERSION}.tar.gz"
	do_touch
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
	"$DIR_SRC/lrzsz-${VERSION}/configure" --prefix="/usr" && \
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

