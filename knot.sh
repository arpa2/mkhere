#!/bin/bash
#
# knot build script

. $(dirname "$0")/lib/stdlib

STABLE=2.8.3

do_update () {
	cd "$DIR_FETCH"
	wget https://secure.nic.cz/files/knot-dns/knot-${STABLE}.tar.xz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/knot-${STABLE}"
	tar -xJvf "$DIR_FETCH/knot-${STABLE}.tar.xz"
}

do_touch () {
	touch "$DIR_SRC/knot-${STABLE}"
}

do_dependencies () {
	echo gnutls-dev
	echo liburcu-dev
	echo libedit-dev
	echo liblmdb-dev
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/knot-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/knot-${STABLE}/configure" --prefix="/usr" && \
		make && \
		empty_dir "$DIR_TREE" && \
		make DESTDIR="$DIR_TREE" install
	fi
}

do_list () {
	cd "$DIR_TREE"
	find . | sed 's+^\./++'
}

do_variants () {
	echo -n ''
}

do_flavours () {
	echo -n ''
}

main_do_commands "$@"

