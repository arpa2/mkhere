#!/bin/bash
#
# arpa2shell build script

. $(dirname "$0")/lib/stdlib

#TODO# Use $VERSION

do_update () {
	cd "$DIR_SRC"
	empty_dir
	git clone https://github.com/arpa2/arpa2shell "$DIR_GIT"
	# cd "$DIR_GIT" ; git reset $VERSION
}

do_dependencies () {
	echo -n ''
}

do_osdependencies () {
	echo python3-setuptools
	echo python3-pkg-resources
	echo python3-pip
	echo python3-venv
	echo python3-dev
	echo libsasl2-dev
	echo libkrb5-dev
}

do2_build () {
	cd "$DIR_BUILD"
	empty_dir
	# To get .ez_files, need to --upgrade and install one by one
	# python3 -m easy_install --upgrade --record="$DIR_BUILD/ez_files" six pkg_resources gssapi python_qpid_proton
	python3 -m pip install six pkg_resources gssapi python_qpid_proton
	python3 "$DIR_GIT/setup.py" install --root="$DIR_TREE"
}

do_test () {
	return 0;
}

do_list () {
	cd "$DIR_TREE"
	#TODO# Need to be able to find...
	# cat "$DIR_BUILD/ez_files" | \
	for PYM in pkg_resources gssapi python_qpid_proton
	do
		python3 -m pip show -f $PYM
	done | \
	awk '/^Location:\ / { loc=$2; } /^\ \ / { printf("%s/%s\n", loc, $1); }' | \
	while read PYF
	do
		if [ ! -h "${PYF#/}" ]
		then
			mkdir -p $(dirname "${PYF#/}")
			ln -s "$PYF" "${PYF#/}"
		fi
	done
	find . -type f,l | sed 's+^\./++'
}

do_variants () {
	echo -n ''
}

do_flavours () {
	echo -n ''
}

main_do_commands "$@"

