# Build script repository "make here"

These are build scripts that run in a local directory structure
where all the build tools are native:

  * `/mkhere/xxx.sh` builds the default install of package `xxx` or its
    variant `vvv` under envvar `VARIANT_xxx=vvv` where the `xxx` is
    usually written in lower case, as is the script name.  The naming of
    variants is done in-situ, and clashes resolved in the Git repository
    of these build scripts.  The scripts will `chroot` to their local
    system, so that their path is shortened to `/mkhere/xxx.sh` when called
    as `/path/to/mkhere/xxx.sh`.  Subcommands exist.
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

  * `update` to have a package's latest source code
  * `touch` to mark the source as newer than anything built
  * `dependencies` and `osdependencies` to list build dependencies from source and from the underlying operating system (the latter: named like Debian stable pkgs)
  * `osdepend` to install the packages listed by `osdependencies`
  * `have` to ensure having the source code for a package and its dependency's
    source code as well
  * `check` to check that the source code has been built
  * `depend` to check that source code dependencies have been built
  * `build` to run configuration and building, as required
  * `variants` and `flavours` list the respective room for choice.
  * `list` to list packages, possibly specific to `FLAVOUR_xxx=fff`
    which makes a consistent selection from among the `VARIANT_xxx=vvv`
    compiled variant.  The flavour string `fff` can take any form.
  * `oslib` to list libraries from the underlying operating system
    on which the package binaries depend.
  * `cpio`, `cpiogz`, `tar`, `tgz` export the `list` contents in a
    requested format to file descriptor `&3` for CPIO, and `&4` for
    for the TAR or TGZ targets.  Note that the `cpio` and `cpiogz`
    flavours are geared towards initial ram disk use; both CPIO and
    GZIP streams can be concatenated to form larger wholes, and so
    can Linux' initial rootfs's; this is why CPIO is fixed on `&3`
    while TAR archives use `&4` as output stream.  As with `list`,
    the `FLAVOUR_xxx=fff` settings will work.
  * `oslibcpio`, `oslibcpiogz`, `oslibtar`, `oslibtgz` export the
    `oslib` pack of libraries from the underlying operating system,
    also output on file descriptor `&3` for CPIO, and `&4` for TAR.
  * It is possible to generate multiple CPIO archives and have their
    outcomes appended.  The inner logic of "mkhere" will automatically
    strip the trailer and append it at the end.  This even works for
    GZIP versions of CPIO archives, but you cannot mix gzipped and
    non-gzipped content, though, as you still need to pass the
    concatenated result through a gunzipper.
  * `install` can only be the last command.  It will be run in the
    environment outside `chroot`, and lap up file descriptor `&3`
    from the inside of `chroot` where it should be produced by the
    `cpio` commands (not their GZIP counterparts).  Run the command
    in the directory where content should be installed.

Any build OS dependencies will be installed before building commences.
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

Similarly, you would want to install build OS dependencies manually onto
the build system,

```
/path/to/mkhere/xxx.sh osdependencies | less
#then#
/path/to/mkhere/xxx.sh osdepend
```

And you might take the same approach to source code dependencies,

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
`osdepend` too, in case the operator did not do it:

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
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpiogz 3>...
```

You can line this up as your `initrd=` image for a kernel, or you could ask for a tar ball to unzip on the spot,

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh tar 4>&1 | tar -xvf -
```

It is intentional that most of the actions above constitute exactly one shell command.

As for the `/path/to`, we are sure you have a taste about ways of setting
this path.  Include it into your package's configuration and export as an
environment variable, for instance.


## Inclusion into "mkroot"

You can use "mkhere" as a stand-alone solution to building (foreign)
software packages.  Most often however, you will want to build up a
root file system.  The ["mkroot"](https://github.com/arpa2/mkroot)
package was built as a perfect match to "mkhere":

  * The concern in "mkhere" is to have self-contained build roots,
    possibly on another operating system.  The build root serves
    as a cache of packages built, and an oracle from which the
    concrete files can be extracted with a plethora of useful
    little commands.  These extractions can be made mostly
    self-contained, by automatic harvesting of dependencies.

  * The concern in "mkroot" is to compose root file systems with
    embellishments to run them in a great diversity of ways.  The
    options include disk-based booting with GRUB, LILO, RedBoot
    and U-Boot, but also CDROM and USB booting with ISOLINUX, and
    network booting with PXE.  Most interestingly however, the
    [Open Containers](http://opencontainers.org) specification has
    standardised on a root file system plus a manifest `config.json`
    as the standard format for (Linux-based) containers.  There
    will be many tools for build such structures, but "mkroot" may
    well be the coolest, thanks to its orthogonal use of "mkhere".


## Operating System Libraries

It is possible to retrieve
OS libraries used from the installed OS dependencies for any given flavour,
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
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpio oslibcpio 3>...
```

and you could additionally install the produced archive in the calling
directory, which is usually outside the build root, with

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpio oslibcpio install
```

The complete call to build and install a package with all that it
takes might be as simple as

```
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh osdepend depend have build
FLAVOUR_xxx=fff /path/to/mkhere/xxx.sh cpio oslibcpio install
```

where the separation of the commands is useful because the first
produces user output and the second merely installs packages in the
current directory.


## Operating System Packages and Files

It is possible to extract packages from the underlying operating
system, of course along with library requirements.  This implements
the customary targets for listing and archiving and even installation,
as part of a special target `/path/to/mkhere/ospackages.sh` which is
sensitive to a space-separated list of packages in `FLAVOUR_ospackages`.

So, to retrieve the OS package plus dependent libraries instead of
building something from source, the formulation is only changed lightly,
passing the packages through the flavour mechanism to a standard target,

```
FLAVOUR_ospackages='bash gcc' /path/to/mkhere/ospackages.sh osdepend depend have build
FLAVOUR_ospackages='bash gcc' /path/to/mkhere/ospackages.sh cpio oslibcpio install
```

Here, `osdepend` installs the packages listed in the flavour variable;
`depend` ensures that no source-code dependencies were forgotten to build;
`have` installs nothing; `build` sets up links to the installation
root, which is necessary for listing the files in preparation of packaging.

You can invoke this more than once, using different flavours, if you like.

Similarly, you can export individual files.  For this, set `FLAVOUR_osfiles`
to a file name (with glob support) per line.  Note that the last line must
be terminated with a newline too!

```
FLAVOUR_osfiles='/bin/bash^J/usr/bin/gcc^J' /path/to/mkhere/osfiles.sh osdepend depend have build
FLAVOUR_osfiles='/bin/bash^J/usr/bin/gcc^J' /path/to/mkhere/osfiles.sh cpio oslibcpio install
```

Again, multiple invocations are possible.  A likely form of using this is to
start general, by exporting whole packages, and to later minimise the size of
the formed root file system by only choosing those files that are needed.

This form is also useful for base files like `/etc/ld.so.conf` and
core libraries, and even kernel modules.
