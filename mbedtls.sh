#!/bin/bash
#
# mbedTLS build script

. $(dirname "$0")/lib/stdlib

STABLE=2.16.2

do_touch () {
	touch "$DIR_SRC/mbedtls-${STABLE}"
}

do_update () {
	cd "$DIR_FETCH"
	empty_dir
	wget https://tls.mbed.org/download/mbedtls-${STABLE}-apache.tgz
	cd "$DIR_SRC"
	empty_dir
	tar -xzvf "$DIR_FETCH/mbedtls-${STABLE}-apache.tgz"
	do_touch
}

do_dependencies () {
	echo -n ''
}

do_build () {
	if [ "$DIR_BUILD" -nt "$DIR_SRC/mbedtls-${STABLE}" ]
	then
		echo 'Reusing build, as it postdates the source'
	else
		cd "$DIR_BUILD"
		empty_dir
		cmake -D CMAKE_INSTALL_PREFIX:PATH=/usr "$DIR_SRC/mbedtls-${STABLE}"
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
