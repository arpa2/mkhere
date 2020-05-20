#!/bin/bash
#
# mosh build script

. $(dirname "$0")/lib/stdlib

default_VERSION 1.3.2

do_update () {
	cd "$DIR_FETCH"
	wget https://mosh.org/mosh-${VERSION}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/mosh-${VERSION}"
	tar -xzvf "$DIR_FETCH/mosh-${VERSION}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo perl
	echo protobuf-compiler
	echo libprotobuf-dev
	echo libncurses5-dev
	echo zlib1g-dev
	echo libutempter-dev
	echo libssl-dev
}

do_test () {
	return 0;
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	"$DIR_SRC/mosh-${VERSION}/configure" --prefix="/usr" && \
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

