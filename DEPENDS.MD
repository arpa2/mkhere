On Debian, we created the basic build environment using

```
cdebootstrap --flavour=build --arch=... stable ...dir...
```

After this, we ran `apt-get update` and still had to post-add:

  - `git`
  - `cmake`
  - `wget`
  - `pkg-config`

In addition, it is optional but desirable to also add:

  - *(none yet)*

This does not include package dependencies, which are installed
with `/mkhere/xxx.sh depend` of course.
