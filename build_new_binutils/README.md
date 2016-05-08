`PIM`: Building binutils
================

Part of the first step in preparing to make a [cross-compiler] for the [operating system] I was hoping to make was having the latest and greatest renditions of [`gcc`][gcc] and [`binutils`][binutils].

I modified the current [`build_new_gcc.sh`](../build_new_gcc/) script that I wrote to easily set up the newest version of [`binutils`][binutils], that it will find and download.

I was currently running version 2.25, which you could find by 

```
ld -version
```

So all the technical work is in the [build script](build_new_binutils.sh). It should do everything necessary, but you can walk through what does what in [the guiding article](http://wiki.osdev.org/Building_GCC) and look at the script yourself.

__The only worthwhile note with that script is that `PREFIX` variable is the same as the `gcc` path, because they should both be installed in the same place and be essentially intertwined together__

There are no necessary dependencies to run the script. However, you should run the [`build_new_gcc`](../build_new_gcc/) first (before this one) to actually get the [`gcc`][gcc] folder and compiler ready as necessary.

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