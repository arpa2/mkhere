#!/bin/bash
#
# knot build script

. $(dirname "$0")/lib/stdlib

default_VERSION 2.8.3

do_touch () {
	touch "$DIR_SRC/knot-${VERSION}"
}

do_update () {
	cd "$DIR_FETCH"
	wget https://secure.nic.cz/files/knot-dns/knot-${VERSION}.tar.xz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/knot-${VERSION}"
	tar -xJvf "$DIR_FETCH/knot-${VERSION}.tar.xz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo gnutls-dev
	echo liburcu-dev
	echo libedit-dev
	echo liblmdb-dev
}

do_check () {
	[ "$DIR_BUILD" -nt "$DIR_SRC/knot-${VERSION}" ]
}

do_build2 () {
	cd "$DIR_BUILD"
	empty_dir
	"$DIR_SRC/knot-${VERSION}/configure" --prefix="/usr" && \
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

