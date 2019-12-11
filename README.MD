# Build script repository "make here"

These are build scripts that run in a local directory structure
where all the build tools are native:

  * `/mkhere/xxx.sh` builds the default install of package `xxx` or its
    variant `vvv` under envvar `VARIANT_xxx=vvv` where the `xxx` is
    usually written in lower case, as is the script name.  The naming of
    variants is done in-situ, and clashes resolved in the Git repository
    of these build scripts.  The scripts will `chroot` to their local
    system, so that their path is shortened to `/mkhere/xxx.sh` when called
    as `/path/to/mkhere/xxx`.  Subcommands exist.
  * `/src/xxx` is the Git repository for `xxx`, and will not be updated
    unless by the user.  Nothing is written here by the build system, so
    it is possible to share this among build platforms.
  * `/build/xxx-vvv` is the build environment for package `xxx` on the
    current platform.  Builds are usually configured with prefix `/usr`
    because the installation will be in its own directory.  When no
    `VARIANT_xxx` is set, the part `-vvv` is dropped.
  * `/tree/xxx-vvv` is the installation directory for package `xxx`, but
    it is not part of the prefix.  In effect, it is usually installed with
    `make DESTDIR=/tree/xxx/vvv` kind of syntax.  Again, `-vvv` is removed
    when no `VARIANT_xxx` is set.

The trick is that the same builds can be shared among different kinds
of build.  Variants exist to allow differentiation within the same
setup script.

Subcommands of the `/mkhere/xxx.sh` can be added on the commandline,
either one or multiple:

  * `update` to have a package's latest source code and build dependencies
  * `touch` to mark the source as newer than anything built
  * `dependencies` to list build dependencies (for now, Debian stable pkgs)
  * `depend` to install the packages listed by `dependencies`
  * `have` to ensure having both source code and dependencies for a package
  * `build` to run configuration and building, as required
  * `list` to list packages, possibly specific to `FLAVOUR_xxx=fff`
    which makes a consistent selection from among the `VARIANT_xxx=vvv`
    compiled variant.  The flavour string `fff` can take any form.
  * `variants` and `flavours` list the respective room for choice.
  * `tar`, `tgz`, `cpio`, `cpiogz` export the `list` contents in a
    requested format.  Note that the `cpio` and `cpiogz` flavours
    are geared towards initial ram disk use; both CPIO and GZIP
    streams can be concatenated to form larger wholes, and so can
    Linux' initial rootfs's.  As with `list`, the `FLAVOUR_xxx=fff`
    settings will work.
  * `cpioprefix` or `oslibcpioprefix` produce a CPIO archive without
    the trailer.  This can be used when further commands concatenate
    files in CPIO format; only the last should not have this.
  * `install` can only be the last command.  It will be removed in
    the `chroot` environment, and pass the output into an installer
    for the CPIO archive, which runs in the calling directory.

Any build dependencies will be installed before building commences.
This may be somewhat platform-specific.  We start off with Debian.
There can be a `lib/yyy` structure that uses no `.sh` endings anywhere,
so as to avoid clashes with the actual scripts.  This can be home to
such differentiation, but given the generic nature of build tools,
there barely ought to be anything.

The whole build system checks into a Git repository that can be shared
across platforms.

## Average Use

Normally, you will want to update software manually,

```
/path/to/mkhere/xxx.sh update
```

Similarly, you would want to install build dependencies manually onto
the build system,

```
/path/to/mkhere/xxx.sh dependencies | less
#then#
/path/to/mkhere/xxx.sh depend
```

However, you will always want to build automatically, but only if needed, as part of a script,

```
/path/to/mkhere/xxx.sh build
```

Note that an automated build may alternatively take care of `update` and
`depend` too, in case the operator did not do it:

```
/path/to/mkhere/xxx.sh have build
```

While working on the script containing this, if it fails, you can manually go back after downgrading the build, and possibly even build it on the spot,

```
/path/to/mkhere/xxx.sh touch
#or#
/path/to/mkhere/xxx.sh touch build
```

Once you have the results built, you can export the results,

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpiogz
```

You can line this up as your `initrd=` image for a kernel, or you could ask for a tar ball to unzip on the spot,

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh tar | tar -xvf -
```

It is intentional that most of the actions above constitute exactly one shell command.

As for the `/path/to`, we are sure you have a taste about ways of setting
this path.  Include it into your package's configuration and export as an
environment variable, for instance.

We have an extra command in preparation.  It is possible to retrieve
OS libraries used from the installed dependencies for any given flavour,
and it is likely that we will find a way to mix it into the flavours
later on.  For now, two commands exists to retrieve the OS libraries.

To find the names of OS libraries that are needed,

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh oslibs
```

and to retrieve them in a tarball,

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh oslibtar
```

To collect a package together with OS libraries, you can produce a CPIO
archive for the package by dropping the trailer from the first archive,

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpioprefix oslibcpio
```

and you could additionally install the produced archive in the calling
directory, which is usually outside the build root, with

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpioprefix oslibcpio install
```

The complete call to build and install a package with all that it
takes might be as simple as

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh depend have build
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpioprefix oslibcpio install
```

where the separation of the commands is useful because the first
produces user output and the second merely installs packages in the
current directory.
