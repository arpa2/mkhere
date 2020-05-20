#!/bin/bash
#
# pacman build script (the package installer for Arch Linux and MSYS2)

. $(dirname "$0")/lib/stdlib

default_VERSION 5.2.1

do_update () {
	cd "$DIR_FETCH"
	wget https://sources.archlinux.org/other/pacman/pacman-${VERSION}.tar.gz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC/pacman-${VERSION}"
	tar -xzvf "$DIR_FETCH/pacman-${VERSION}.tar.gz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo 'libarchive-dev'
	echo 'libssl-dev'
	echo 'pkg-config'
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	"$DIR_SRC/pacman-${VERSION}/configure" --prefix="/usr" && \
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

