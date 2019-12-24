#!/bin/bash
#
# musl build script

. $(dirname "$0")/lib/stdlib

default_VERSION 1.1.23

do_update () {
	cd "$DIR_FETCH"
	wget https://www.musl-libc.org/releases/musl-${VERSION}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/musl-${VERSION}"
	tar -xzvf "$DIR_FETCH/musl-${VERSION}.tar.gz"
	do_touch
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
	"$DIR_SRC/musl-${VERSION}/configure" --prefix="/usr" && \
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

