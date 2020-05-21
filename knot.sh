#!/bin/bash
#
# knot build script

. $(dirname "$0")/lib/stdlib

default_VERSION 2.9.4

do_update () {
	cd "$DIR_FETCH"
	wget https://secure.nic.cz/files/knot-dns/knot-${VERSION}.tar.xz
	cd "$DIR_SRC"
	empty_dir "$DIR_SRC"
	cd ..
	tar --one-top-level="knot-${VERSION}" -xJvf "$DIR_FETCH/knot-${VERSION}.tar.xz"
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo gnutls-dev
	echo liburcu-dev
	echo libedit-dev
	echo liblmdb-dev
}

# As long as Knot's Python code does not clone during ./configure
# and fails to incorporate the libknot/control.py we need cpio below
do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	"$DIR_SRC/configure" --prefix="/usr" && \
	make && \
	empty_dir "$DIR_TREE" && \
	make DESTDIR="$DIR_TREE" install && \
	( cd "$DIR_SRC" ; find python -name \*.py | cpio -o --quiet ) | cpio -i --quiet && \
	cd "$DIR_BUILD/python" && \
	python3 setup.py install --root="${DIR_TREE}" --prefix=/usr/local
}

do_test () {
	return 0;
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

