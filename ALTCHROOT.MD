# Alternatives to CHange ROOT

> *The basic design for "mkhere" is founded on the `chroot` operation.
> This allows much, but not everything.  This is how to vary more widely.*

The standard operation of "mkhere" is to run it on Linux to build Linux.
Thanks to ELF assuming a CPU, this can even be used to build for other
kinds of Linux, such as Raspberry Pi or OpenWRT platforms.

However, a few more targets are desirable, such as BSD and Windows systems.
(Mac OS X also becomes a target, but it first needs a suitable build system
without commercial license or manual update procedures.  It started like that
with Darwin, but these freedoms have eroded.)


## Simply an extra command to run

We can use a separate command `mkhere/lib/altchroot` that will be run
from the shell if it is available.  If it is not available, plain `chroot`
is used.

The makeup of this `altchroot` command should be like that of the `chroot`
shell command:

  * Accept an intended root directory with a command and arguments to run
  * The directory, command and arguments are proper strings and may contain spaces
  * The intended root directory should hold the `/mkhere` or `${ALTCACHE}/mkhere` tree
  * The command will be one of the `/mkhere/pkg.sh` scripts
  * The `stdout` stream must be preserved as-is, as it may deliver a package
  * The `stderr` stream should be preserved, and may report building errors
  * Mixed-up output on `stdout` is never acceptable; use `stderr` for messages
  * Exported environment variables must be inherited
  * Batch-mode operation is acceptable, so `stdout` may be buffered somewhere


## Running emulators

It is possible to run emulators from `mkhere/lib/altchroot`, such as Qemu
or KVM, or possibly Wine.  This is intended to support switching to different
operating systems and different CPU architectures.  Note however, that a
root directory installed with a Debian from a foreign CPU is likely to just
work under Linux, because the binaries can be run with silent Qemy support
built into the kernel (binfmt magic).

For FreeBSD and co, or for Windows, these solutions are insufficient;
for those a new kernel or OS API is required.

