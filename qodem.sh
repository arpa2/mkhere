#!/bin/bash
#
# qodem build script

. $(dirname "$0")/lib/stdlib

default_VERSION 1.0.0

do_update () {
	cd "$DIR_FETCH"
	wget -O qodem-${VERSION}.tar.gz https://github.com/klamonte/qodem/archive/v${VERSION}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/qodem-${VERSION}"
	tar -xzvf "$DIR_FETCH/qodem-${VERSION}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo libsdl-dev
	echo libncurses-dev
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	# Horrible code, cannot configure outside of builddir
	# "$DIR_SRC/qodem-${VERSION}/configure" --srcdir="$DIR_SRC/qodem-${VERSION}" --prefix="/usr" && \
	cp -pr "$DIR_SRC/qodem-${VERSION}"/* . && \
	./autogen.sh && \
	./configure --prefix="/usr" && \
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install
}

do_test () {
	return 0;
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

