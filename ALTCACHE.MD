# Using an Alternative Cache Directory

> *Maybe you do not want all the "mkhere" stuff in your root directory.
> For example, because you want to use a generally used disk for building.*

The "mkhere" code stores several directories:

  * `/mkhere` with build scripts and libraries
  * `/dl` for downloads
  * `/src` for source code (and Git checkouts)
  * `/build` for building code
  * `/tree` for built results

Note that the contents of this directory are basically caches, with the
exception of the `/mkhere` tree, which holds the recipes for recreating
the other parts.

This clutters a root directory.  This is hardly problematic on a dedicated
build system, but if you want to use your existing setup it may be less
desirable.  Being able to assign any other directory as an "alternative root"
for use with "mkhere" will help you use your existing system.

If you prefer, you can place the `mkhere` directory in another place,
an "alternative root directory".  It may for example be a disk's
`/var/cache/mkhere-altcache` directory.

It is even possible to set the physical directory of the installation,
and by doing so avoid the need to `chroot` for each script.

The `mkhere` directory is expected to be found in the directory,
of course.  If not, except problems.

Assuming you want to use `$ALTCACHE` directory, and have a subdirectory
`$ALTCACHE/mkhere` with the checkout of this repository, you can do

```
ln -s "$ALTCACHE" "$ALTCACHE/mkhere/lib/altcache"
```

It is necessary for the path to your scripts to use paths like
`/some/dir/to/$ALTCACHE/mkhere/xxx.sh`
so that the `/some/dir/to` only needs to be stripped off for the
`chroot` to take its effect.  This is true with normal usage
patterns, but still a technical requirement to know about.

