#!/bin/bash
#
# rz/sz build script

. $(dirname "$0")/lib/stdlib

#Note: Debian has a 0.12.21 which is not released?!?
STABLE=0.12.20

do_touch () {
	touch "$DIR_SRC/lrzsz-${STABLE}"
}

do_update () {
	cd "$DIR_FETCH"
	wget https://ohse.de/uwe/releases/lrzsz-${STABLE}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/lrzsz-${STABLE}"
	tar -xzvf "$DIR_FETCH/lrzsz-${STABLE}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo -n ''
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/lrzsz-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/lrzsz-${STABLE}/configure" --prefix="/usr" && \
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

