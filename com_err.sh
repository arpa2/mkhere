#!/bin/bash
#
# com_err build script

. $(dirname "$0")/lib/stdlib

# STABLE=0.0.0

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/arpa2/com_err com_err.git
}

do_touch () {
	touch "$DIR_GIT"
}

do_dependencies () {
	echo flex
	echo bison
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_GIT" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		cmake -D CMAKE_INSTALL_PREFIX:PATH=/usr "$DIR_GIT"
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

