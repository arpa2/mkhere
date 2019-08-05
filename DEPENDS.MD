On Debian, we created the basic build environment using

```
cdebootstrap --flavour=build --arch=... stable ...dir...
```

After this, we still had to post-add:

  - `git`
  - `cmake`
  - `wget`
  - `pkg-config`

In addition, it is optional but desirable to also add:

  - `strip`

This does not include package dependencies, which are installed
with `/mkhere/xxx.sh depend` of course.
