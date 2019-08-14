#!/bin/bash
#
# dropbear build script

. $(dirname "$0")/lib/stdlib

STABLE=2019.78

do_touch () {
	touch "$DIR_SRC/dropbear-${STABLE}"
}

do_update () {
	cd "$DIR_FETCH"
	wget https://matt.ucc.asn.au/dropbear/releases/dropbear-${STABLE}.tar.bz2
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/dropbear-${STABLE}"
	tar -xjvf "$DIR_FETCH/dropbear-${STABLE}.tar.bz2"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/dropbear-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/dropbear-${STABLE}/configure" --prefix="/usr" && \
		make && \
		empty_dir "$DIR_TREE" && \
		make DESTDIR="$DIR_TREE" install
	fi
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

