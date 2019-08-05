# Installing this Build Root structure

You should install this directory as `/mkhere/` in your build file system.

It creates directories straight under the root directory, for easy referene.

You will invoke the `/mkhere/xxx.sh` scripts, and it is okay if you point
into the (foreign) file system to do so.  All you require is to have
`/bin/bash` available on the system doing so.  The script will `chroot()`
before coming alive.


## Special notes: Architecture armhf for Raspberry Pi

Before the `cdebootstrap --arch=armhf` below can succeed, it is
first needed to install the proper `qemu` packages, notably
`qemu-user-static`.  The install will fail with `qemu-user-binfmt`
which also is incompatible with this choice.  No idea why.

Note that an explicit assumption is that the `mkhere/xxx.sh` scripts,
even though they are installed in a Raspberry Pi environment, will
run flawlessly on the target/host environment, which therefore
needs to recognise either the execution permissions with `#!/bin/bash`
header line or the `.sh` extension.  The former will apply on POSIX
systems, the latter on all the others (Windows).

We rely heavily on the `qemu-user-static` setup, which will run
the Raspberry Pi version of `chroot` and under that, the various
build tools, as if they were local programs.  Expect much slower
running times, but also expect functional equivalence.


## Special notes: Windows via Wine

We have a
[build environment using Wine](https://github.com/arpa2/docker-build-win64)
that is in many ways comparable to this approach.  We plan to grow
that into this setup.

The pivotal point is normally `chroot`, but we might need to
change that to `wine` in this structure.  Note however, that we
could also use `wine-binfmt` in much the same manner, and
exploit the filesystem (exported from this Docker container).

This remains work to be done.  The build scripts made here do
seem to align well with the work done in the Wine build
environment, adding precisely what has not been completed
in there.

Wine is expected to be more efficient than an architecture change,
at least when run on its native platforms.  Functional equivalence
is more problematic, however.  For that, we need Microsoft to
continue to advance on their current path of POSIX compliance.


## Special notes: Mac OS X support

The platform with forever breaking hardware, based on
proprietary connectors with fragile implementations, and
the operating system itself being closed.  Top that off
with perceived obsolence to keep it both hip and a drain
on the environment, and you won't find much enthousiasm
here.  Yes, I do own a share of the platform but hardly
consider them sufficiently reliable for continued building.

Mac OS X is a constant drain on funds and time.  If you feel
you have the energy to support the platform, you are more than
welcome to replace this section with constructive remarks.
It shouldn't be that difficult; all you need is to make the
C compiler work, and packages to be constructed from a file
list under a `/tree/xxx[-vvv]` prefix, as an add-on to the
`tar` and other targets.  Do adhere to the POSIX tree however.

Meanwhile, try a Mac Mini without SSD and a whopping 4 GB of
memory, and you will understand my complaints.  It cannot be
beaten forward, taking minutes to just open a menu, especially
if it happens to also be doing something else.

This platform is seriously broken but we could support it
as soon as we had a `chroot` build environment for it,
running on stock Linux like Windows can do through Wine.


## Having multiple build environments

So... you can setup any number of build environments you like...

```
cdebootstrap --flavour=build --arch=i386  /tank/debian-build-pc32
cdebootstrap --flavour=build --arch=amd64 /tank/debian-build-pc64
cdebootstrap --flavour=build --arch=armhf /tank/debian-build-rapi
```

...and in each you can mount or install this directory structure as `/mkhere`...

```
cp -r /path/from/mkhere /tank/debian-build-pc32/mkhere
cp -r /path/from/mkhere /tank/debian-build-pc64/mkhere
cp -r /path/from/mkhere /tank/debian-build-rapi/mkhere
```

...after which you can build stuff...

```
/tank/debian-build-pc32/mkhere/mbusd.sh update build
/tank/debian-build-pc64/mkhere/mbusd.sh update build
/tank/debian-build-rapi/mkhere/mbusd.sh update build
```

...and finally you can harvest the outcome...

```
/tank/debian-build-pc32/mkhere/mbusd.sh tgz > /tmp/mbusd-pc32.tgz
/tank/debian-build-pc64/mkhere/mbusd.sh tgz > /tmp/mbusd-pc64.tgz
/tank/debian-build-rapi/mkhere/mbusd.sh tgz > /tmp/mbusd-rapi.tgz
```

...or even as an initial ram filesystem to concatenate into
a Linux kernel `initrd` file...


```
/tank/debian-build-pc32/mkhere/mbusd.sh tgz > /tmp/mbusd-pc32.cpiogz
/tank/debian-build-pc64/mkhere/mbusd.sh tgz > /tmp/mbusd-pc64.cpiogz
/tank/debian-build-rapi/mkhere/mbusd.sh tgz > /tmp/mbusd-rapi.cpiogz
```

The two package files provide the files installed in the root
of your file system.
