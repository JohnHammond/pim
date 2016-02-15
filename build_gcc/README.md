`PIM`: Building GCC
================

The first step I was instructed was to get the latest and greatest version of [`gcc`][gcc], all off of [this article](http://wiki.osdev.org/Building_GCC). 

The [`gcc`][gcc] version I am currently running is version `4.9.2`, which I found by: 

```
gcc --version
```

Research tells me that the latest version is version `5.3.0`, so I downloaded `gcc-5.3.0.tar.gz` off [this](ftp://mirrors-usa.go-parts.com/gcc/releases/gcc-5.3.0/) [`ftp`][ftp] mirror. 

It was also recommended that I update [`binutils`][binutils], but because I the most recent version `2.25`, there is (currently) no new version for me to update to. I found the version found by:

```
ld --version
```

Here are the commands I proceeded to run after I downloaded the source packe for [`gcc`][gcc]:

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



[kernel]: https://en.wikipedia.org/wiki/Kernel_%28operating_system%29
[operating system]: https://en.wikipedia.org/wiki/Operating_system
[OSDev.org]: http://osdev.org 
[StewieOS]: https://github.com/Caleb1994/StewieOS
[GCC]: https://gcc.gnu.org/
[ftp]: https://en.wikipedia.org/wiki/File_Transfer_Protocol
[binutils]: https://www.gnu.org/software/binutils/