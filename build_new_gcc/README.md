`PIM`: Building GCC
================

The first step I was instructed was to get the latest and greatest version of [`gcc`][gcc], all off of [this article](http://wiki.osdev.org/Building_GCC). 

The [`gcc`][gcc] version I am currently running is version `4.9.2`, which I found by: 

```
gcc --version
```

Research tells me that the latest version is version `5.3.0`, so I downloaded `gcc-5.3.0.tar.gz` off [this](ftp://mirrors-usa.go-parts.com/gcc/releases/gcc-5.3.0/) [`ftp`][ftp] mirror. 

It was also recommended that I update [`binutils`][binutils], so that is in [a separate script](../build_new_binutils).

Here are the commands I proceeded to run after I downloaded the source package for [`gcc`][gcc]:

``` bash
gunzip gcc-5.3.0.tar.gz
tar xfv gcc-5.3.0.tar
mkdir ~/opt/
mv gcc-5.3.0 ~/opt/
export PREFIX="$HOME/opt/gcc-5.3.0"

mkdir $HOME/opt/src
cd $HOME/opt/src
mkdir build-gcc
cd build-gcc
../../gcc-x.y.z/configure --prefix="$PREFIX" --disable-nls --enable-languages=c,c++

# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 

# --enable-languages tells GCC to not to compile all the other language frontends it supports, but only C (and optionally C++).

# --disable-bootstrap tells the compiler to not bootstrap itself against the current system compiler. This results in a much quicker compilation, but if the current and the new compiler differ too much in version, you will get a less robust compiler or weird errors. 

make
make install
```

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