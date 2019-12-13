# Extracting Flavours from Packages

> *Packages can be built in a given (configuration) variant, but
> then harvesting comes.  During this harvest, flavours can be
> used to determine what should and should not be delivered.*


In general, a flavour is defined in a variable in an environment
that calls upon a `mkhere/tool.sh` script:

```
...
export FLAVOUR_tool="word1 word2 word3"
...
"${MKHERE}/tool.sh" tar | tar -C rootfs -xvf -
...
```

The `word1` and so on define what the flavour does exactly.
It starts with an alphanumeric-with-underscore sequence, followed
by a symbol that defines how to continue and optional arguments.

The various `wordX` values are considered declarative, unordered
statements of desired behaviour.  This may not work out for
inconsistent specifications, such as setting one variable to more
than one value.

## General Variables: `var=value`

The `mkhere/tool.sh` scripts themselves are central to the generation of
initial material.  They do this through the `do_list` operations,
which may respond to the `FLAVOUR_tool` setting themselves.  It is
however possible to check variables or flags that may be set as
`var=value`.  For flags, the values `on` and `off` are recommended,
with a tool-specific default.

These variables are parsed from `FLAVOUR_tool` and made available
to the `mkhere/tool.sh` scripts, or at least to their `do_list` function,
where `var=val` is prefixed to form `FV_var=val` and added as an
environment variable.  These can then be used in the many ways that
the shell supports.  Unrecognised variables are never noticed.

Because flavours work like a filtering pipeline, variables must
be set at the beginning, which is the point where the original
content is generated, with `do_list`, and so the point where
the variables are needed.


## Matching Directory Patterns: "dir/glob"

It is possible to constrain what is installed below a given directory,
by using a `glob` restriction to that `dir` as in `dir/glob`.
That applies to `/any/path/to/dir/*` on the basis of the last
component.

It is possible to be more selective, such as in `to/dir/glob` or
even `/any/path/to/dir/glob` in which only the last component counts
as the glob.  Since the empty glob matches nothing, so `/` may
be used to remove everything that is not explicitly included.

When the same `dir` occurs more than once, the named `glob` are
considered alternative options, so it is possible to specify
`bin/my_client bin/my_server` to get those, but no other files from
`bin/*` included.

When no patterns `lib/glob` are defined, then all `lib/*` will
be included.  This means that the default is to include everything,
and that explains why `/` is a useful form to start with.

**Implementation Notes:**
Internally, all files generated pass through a selection filter,
which is built as a dynamically generated case-switch statement.
For instance, to pass `lib/*.so*` there will be a case to accept
`*/lib/*.so*` and another one, with lower selectivity, that
blocks `*/lib/*` from being passed.  When the path starts with
a slash, as in `/usr/lib/*.so*`, it will be mapped without the
prefixing of `*/`, of course.  There is a general case for
passing `*` by default, which can be overridden with `/` as that
translates to passing just that non-existent name and blocking
the omnipresent `/*` with a higher priority than passing `*`.
The patterns are globs, because they are more pleasant to work
with in this kind of use case; they have been worked out in
cautiously crafted bash scripts for reasons of portability.


## Adding Context: `oslibs@` and `deb@name`

Packages depend on other packages, executables depend on libraries.
So, it is possible to add contextual information of that kind with
a prefixed `@` symbol.  The additional files that may arise from
these contextual extensions are subjected to filtering by the
other flavour settings.

To add operating system libraries for those executables that are
part of a flavour, add `@oslibs` after extracting the flavour.

To install packages from an operating system, use one or more
`deb@name` options for Debian packages; we may add things like
`rpm@name` later; your build system defines where it locates
packages and how it unpacks them, with or without installing them.
Note that it is not problematic to request Debian packages from an
RPM-based system, or vice versa; tools for package crossover are
common.

To add the contents of an operating system package, add
`ospkg=name` as often as needed.  Further flavours will be applied
to these additional files too.  There is a `mkhere/null.sh` target that
lists no files of its own, yet allows the insertion of packages
from the operating system as a way to extract its packages.

