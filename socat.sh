#!/bin/bash
#
# socat build script

. $(dirname "$0")/lib/stdlib

default_VERSION 1.7.3.3

do_touch () {
	touch "$DIR_SRC/socat-${VERSION}"
}

do_update () {
	cd "$DIR_FETCH"
	wget http://www.dest-unreach.org/socat/download/socat-${VERSION}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/socat-${VERSION}"
	tar -xzvf "$DIR_FETCH/socat-${VERSION}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do_check () {
	[ "$DIR_BUILD" -nt "$DIR_SRC/socat-${VERSION}" ]
}

do_build2 () {
	cd "$DIR_BUILD"
	empty_dir
	"$DIR_SRC/socat-${VERSION}/configure" --prefix="/usr" && \
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

