#!/bin/bash
#
# Quick DER build script

. $(dirname "$0")/lib/stdlib

default_VERSION version-1.3.0

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://gitlab.com/arpa2/quick-der "$DIR_GIT"
	cd "$DIR_GIT" ; git reset $VERSION
}

do_dependencies () {
	echo arpa2cm
	VERSION_arpa2cm=0.8.0
}

do_osdependencies () {
	echo python3
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	cmake "$DIR_GIT"
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install && \
	python3 "$DIR_GIT/setup.py" install
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

