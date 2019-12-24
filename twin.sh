#!/bin/bash
#
# twin build script

. $(dirname "$0")/lib/stdlib

default_VERSION 88b90b73e1d4b28f07e6a9471e32534b65d251ef

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/cosmos72/twin "$DIR_GIT"
	cd "$DIR_GIT"
	git reset $VERSION
	git remote add vanrein https://github.com/vanrein/twin
	# git fetch vanrein pr-multiline-menu
	# git merge vanrein/pr-multiline-menu
	git fetch vanrein rvrmods
	git merge --no-edit vanrein/rvrmods
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo 'libgpm-dev'
	echo 'libgpm2'
}

do_build2 () {
	cd "$DIR_BUILD"
	empty_dir
	"$DIR_GIT/configure" --prefix="/usr" && \
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install && \
	find "$DIR_TREE/usr/lib" -name \*.la -exec rm {} \; && \
	rm "$DIR_TREE/usr/bin/twin" && \
	ln -s twin_server "$DIR_TREE/usr/bin/twin"
	#KEEP:DEBUG#MOVE:2UP#
	#KEEP:DEBUG# find "$DIR_TREE/usr/lib" -name \*.so* -type f -exec strip {} \; && \
	#KEEP:DEBUG# find "$DIR_TREE/usr/bin" -type f | grep -v twstart | while read FILE ; do strip $FILE ; done && \
	#KEEP:DEBUG# rm "$DIR_TREE/usr/bin/"{twcuckoo,twclutter,twdialog,twthreadtest} && \
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

