#!/bin/bash
#
# dropbear build script

. $(dirname "$0")/lib/stdlib

default_VERSION 2019.78

do_update () {
	cd "$DIR_FETCH"
	wget https://matt.ucc.asn.au/dropbear/releases/dropbear-${VERSION}.tar.bz2
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/dropbear-${VERSION}"
	tar -xjvf "$DIR_FETCH/dropbear-${VERSION}.tar.bz2"
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
	"$DIR_SRC/dropbear-${VERSION}/configure" --prefix="/usr" && \
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

