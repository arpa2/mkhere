#!/bin/bash
#
# twin build script

. $(dirname "$0")/lib/stdlib

# STABLE=0.0.0

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/cosmos72/twin twin.git
	cd twin.git
	git remote add vanrein https://github.com/vanrein/twin
	git fetch vanrein pr-multiline-menu
	git merge vanrein/pr-multiline-menu
}

do_touch () {
	touch "$DIR_SRC/twin.git"
}

do_dependencies () {
	echo -n ''
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/twin.git" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		"$DIR_SRC/twin.git/configure" --prefix="/usr" && \
		make && \
		empty_dir "$DIR_TREE" && \
		make DESTDIR="$DIR_TREE" install && \
		find "$DIR_TREE/usr/lib" -name \*.la -exec rm {} \; && \
		find "$DIR_TREE/usr/lib" -name \*.so* -type f -exec strip {} \; && \
		find "$DIR_TREE/usr/bin" -type f | grep -v twstart | while read FILE ; do strip $FILE ; done && \
		rm "$DIR_TREE/usr/bin/"{twcuckoo,twclutter,twdialog,twthreadtest} && \
		rm "$DIR_TREE/usr/bin/twin" && \
		ln -s twin_server "$DIR_TREE/usr/bin/twin"
	fi
}

do_list () {
	cd "$DIR_TREE"
	find . | sed 's+^\./++'
}

do_variants () {
	echo -n ''
}

do_flavours () {
	echo -n ''
}

main_do_commands "$@"

