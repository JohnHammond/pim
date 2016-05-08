`PIM`: Building GCC
================

The first step I was instructed was to get the latest and greatest version of [`gcc`][gcc], all off of [this article](http://wiki.osdev.org/Building_GCC). 

The [`gcc`][gcc] version I was currently running is version `4.9.2`, which I found by: 

```
gcc --version
```

It was also recommended that I update [`binutils`][binutils], so that is in [a separate script](../build_new_binutils).


I've tried to put this all in a [simple script](build_new_gcc.sh) that does this all in a logical fashion. It is hopefully a little cleaner and should do everything necessary, but you can walk through what does what in [the guiding article](http://wiki.osdev.org/Building_GCC)


-----

After trying to run the script, I got an error initially:

```
Building GCC requires GMP 4.2+, MPFR 2.4.0+ and MPC 0.8.0+.
Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify
their locations.  Source code for these libraries can be found at
their respective hosting sites as well as at
ftp://gcc.gnu.org/pub/gcc/infrastructure/.  See also
http://gcc.gnu.org/install/prerequisites.html for additional info.  If
you obtained GMP, MPFR and/or MPC from a vendor distribution package,
make sure that you have installed both the libraries and the header
files.  They may be located in separate packages.
./build_new_gcc.sh: fatal error
```

I had forgotten the dependencies (I didn't actually _forget_ them, I just chose to ignore them because I figured (hoped) they would already be on my box) so I added them to my script. The big ones were [GNU MPFR][MPFR], [GMP], and [MPC], which I was told are all in the repositories `libgmp3-dev libmpfr-dev libmpc-dev`.


__Keep in mind this will take a good long while to actually run and build all of [`gcc`][gcc]. Set some good time aside for it to run; it will take like 20 minutes.__

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