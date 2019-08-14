#!/bin/bash
#
# dialog build script

. $(dirname "$0")/lib/stdlib

do_touch () {
	touch "$DIR_SRC/dialog"
}

do_update () {
	cd "$DIR_FETCH"
	# Note: unversioned download...
	empty_dir
	wget https://invisible-island.net/datafiles/release/dialog.tar.gz
	cd "$DIR_SRC"
	empty_dir
	tar -xzvf "$DIR_FETCH/dialog.tar.gz"
	mv dialog-* dialog
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/dialog" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/dialog/configure" --prefix="/usr" && \
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

