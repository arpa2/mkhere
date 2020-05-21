#!/bin/bash
#
# Quick DER build script

. $(dirname "$0")/lib/stdlib
. $(dirname "$0")/lib/toolgit
. $(dirname "$0")/lib/toolcmake

GIT_URL="https://gitlab.com/arpa2/quick-der.git"

default_VERSION v1.4.2

do_dependencies () {
	echo arpa2cm
}

do_osdependencies () {
	echo python3
	echo python3-dev
	echo python3-setuptools
}

do2_build () {
	do2cmake_build && \
	python3 "$DIR_SRC/setup.py" install
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

