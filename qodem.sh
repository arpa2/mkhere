#!/bin/bash
#
# qodem build script

. $(dirname "$0")/lib/stdlib

STABLE=1.0.0

do_touch () {
	touch "$DIR_SRC/qodem-${STABLE}"
}

do_update () {
	cd "$DIR_FETCH"
	wget -O qodem-${STABLE}.tar.gz https://github.com/klamonte/qodem/archive/v${STABLE}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/qodem-${STABLE}"
	tar -xzvf "$DIR_FETCH/qodem-${STABLE}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo libsdl-dev
	echo libncurses-dev
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/qodem-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		# Horrible code, cannot configure outside of builddir
		# "$DIR_SRC/qodem-${STABLE}/configure" --srcdir="$DIR_SRC/qodem-${STABLE}" --prefix="/usr" && \
		cp -pr "$DIR_SRC/qodem-${STABLE}"/* . && \
		./autogen.sh && \
		./configure --prefix="/usr" && \
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

