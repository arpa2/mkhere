#!/bin/bash
#
# KIP and HAAN build script

. $(dirname "$0")/lib/stdlib
. $(dirname "$0")/lib/toolgit

GIT_URL="https://gitlab.com/arpa2/kip.git"

default_VERSION master

do_dependencies () {
	echo arpa2cm
	echo quickder
}

do_osdependencies () {
	echo libkrb5-dev
	echo libunbound-dev
	echo libsasl2-dev
	echo libssl-dev
	echo libpcre3-dev
	echo libfreediameter-dev
	echo freediameter-extensions
	echo freediameterd
	echo swig
	echo python3
	echo python3-dev
	echo python3-setuptools
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	cmake "$DIR_SRC"
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install #TODO# && \
	#TODO# python3 "$DIR_SRC/setup.py" install
}

do_test () {
	cd "$DIR_BUILD"
	ctest
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

