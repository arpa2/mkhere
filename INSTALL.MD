# Installing this Build Root structure

You should install this directory as `/mkhere/` in your build file system.

It creates directories straight under the root directory, for easy referene.

You will invoke the `/mkhere/xxx.sh` scripts, and it is okay if you point
into the (foreign) file system to do so.  All you require is to have
`/bin/bash` available on the system doing so.  The script will `chroot()`
before coming alive.

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
