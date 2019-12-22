#!/bin/bash
#
# Quick DER build script

. $(dirname "$0")/lib/stdlib

#TODO# Use $VERSION

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/vanrein/quick-der "$DIR_GIT"
}

do_touch () {
	touch "$DIR_GIT"
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo python3
}

do_check () {
	[ "$DIR_BUILD" -nt "$DIR_GIT" ]
}

do_build2 () {
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

