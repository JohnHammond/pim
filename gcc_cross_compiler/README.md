`PIM`: Creating a new GCC Cross-Compiler
================

I understand the most necessary thing to start with to build your own [operating system] is to set up a [cross-compiler] with [`gcc`][gcc] so whatever I build on my own [operating system] will run and work on the [operating system] that I am trying to write. 

[I followed this article to try and do this][cross-compiler].

Currently I am trying to go through the [Bare Bones] tutorial, which uses `i686_elf` as the target platform. 

I intend on adapting the code I wrote to build a new 5.3.0 version of [`gcc`][gcc] to prepare and build the [cross-compiler].

Because of that, try and run the scripts to [`build_new_gcc`](../build_new_gcc/) and [`build_new_binutils`](build_new_binutils/) before you run this script to build the [cross-compiler].

[kernel]: https://en.wikipedia.org/wiki/Kernel_%28operating_system%29
[operating system]: https://en.wikipedia.org/wiki/Operating_system
[OSDev.org]: http://osdev.org 
[StewieOS]: https://github.com/Caleb1994/StewieOS
[GCC]: https://gcc.gnu.org/
[ftp]: https://en.wikipedia.org/wiki/File_Transfer_Protocol
[binutils]: https://www.gnu.org/software/binutils/
[MPFR]: http://www.mpfr.org/
[GMP]: https://gmplib.org/
[MPC]: http://multiprecision.org/
[cross-compiler]: http://wiki.osdev.org/GCC_Cross-Compiler
[Bare Bones]: http://wiki.osdev.org/Bare_Bones