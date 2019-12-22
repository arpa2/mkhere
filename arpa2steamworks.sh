#!/bin/bash
#
# SteamWorks build script

. $(dirname "$0")/lib/stdlib

#TODO# Use $VERSION

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://gitlab.com/arpa2/steamworks arpa2steamworks.git
}

do_touch () {
	touch "$DIR_GIT"
}

do_dependencies () {
	echo 'arpa2cm'
}

do_osdependencies () {
	echo -n ''
}

do_check () {
	[ "$DIR_BUILD" -nt "$DIR_GIT" ]
}

do_build2 () {
	cd "$DIR_BUILD"
	empty_dir
	cmake -D CMAKE_INSTALL_PREFIX:PATH=/usr \
		-D CMAKE_FIND_ROOT_PATH=/tree/arpa2cm/usr/local \
		"$DIR_GIT"
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

