`PIM`: Bare Bones 
================

__May 8th, 2016:__ I wrote all the code out for the [Bare Bones] tutorial. 

Inside this directory there should be (at minimum) the three files necessary for the [Bare Bones] tutorial and a [bash] scrcipt that will build and run everything:

* __[`boot.s`](boot.s)__: The [Multiboot][Multiboot] [Assembly] bootstrap
* __[`kernel.c`](kernel.c)__: The whole kernel in [C], just a simple "Hello World" image.
* __[`linker.ld`](linker.ld)__: The linker file for this low level.

And like stated,

* __[`build_and_run.sh`](build_and_run.sh)__: The [shell script][bash] to connect everything and try to run it. This will attempt to install [QEMU] and [xorriso] if they are not already installed.

[kernel]: https://en.wikipedia.org/wiki/Kernel_%28operating_system%29
[operating system]: https://en.wikipedia.org/wiki/Operating_system
[OSDev.org]: http://osdev.org 
[StewieOS]: https://github.com/Caleb1994/StewieOS
[gcc]: https://gcc.gnu.org/
[Bare Bones]: http://wiki.osdev.org/Bare_Bones
[binutils]: https://www.gnu.org/software/binutils/
[bash]: https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29
[Assembly]: https://en.wikipedia.org/wiki/Assembly_language
[Multiboot]: https://en.wikipedia.org/wiki/Multiboot_Specification
[C]: https://en.wikipedia.org/wiki/C_%28programming_language%29
[QEMU]: http://wiki.qemu.org/Main_Page
[xorriso]: https://www.gnu.org/software/xorriso/