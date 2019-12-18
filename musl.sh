#!/bin/bash
#
# musl build script

. $(dirname "$0")/lib/stdlib

STABLE=1.1.23

do_touch () {
	touch "$DIR_SRC/musl-${STABLE}"
}

do_update () {
	cd "$DIR_FETCH"
	wget https://www.musl-libc.org/releases/musl-${STABLE}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/musl-${STABLE}"
	tar -xzvf "$DIR_FETCH/musl-${STABLE}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/musl-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/musl-${STABLE}/configure" --prefix="/usr" && \
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

