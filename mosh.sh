#!/bin/bash
#
# mosh build script

. $(dirname "$0")/lib/stdlib

STABLE=1.3.2

do_touch () {
	touch "$DIR_SRC/mosh-${STABLE}"
}

do_update () {
	cd "$DIR_FETCH"
	wget https://mosh.org/mosh-${STABLE}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/mosh-${STABLE}"
	tar -xzvf "$DIR_FETCH/mosh-${STABLE}.tar.gz"
	do_touch
}

do_dependencies () {
	echo perl
	echo protobuf-compiler
	echo libprotobuf-dev
	echo libncurses5-dev
	echo zlib1g-dev
	echo libutempter-dev
	echo libssl-dev
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/mosh-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/mosh-${STABLE}/configure" --prefix="/usr" && \
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

