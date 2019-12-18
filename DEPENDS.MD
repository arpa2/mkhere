On Debian, we created the basic build environment using

```
cdebootstrap --flavour=build --arch=... stable ...dir...
```

After this, we ran `apt-get update` and still had to post-add:

  - `git`
  - `cmake`
  - `wget`
  - `pkg-config`
  - `bison` and `flex`
  - `autoconf` and `automake`
  - `libtool`
  - `gdbserver` and `gdb`

Please setup your GIT name and email address to support merges
in the various scripts; do this as the builder user,
which is the `root` user:

```
chroot mkhere/.. git config --global user.email john@example.com
chroot mkhere/.. git config --global user.name "John Exemplified"
```

In addition, it is optional but desirable to also add:

  - *(none yet)*

You may find it pleasant to also have things like

  - `ccmake-ncurses-gui`

This does not include package dependencies, which are installed
with `/mkhere/xxx.sh osdepend` of course.
