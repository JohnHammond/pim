`PIM`: Poetry in Motion 
================

`PIM` is my own endeavor to learn low-level programming and develop a [kernel] or [operating system].

This is entirely for the purpose of experimentation and education; I'll be following along with a lot of information offered by [OSDev.org] and I plan on learning some tips and tricks by looking at the [StewieOS] project, developed by a good friend of mine.

For the time being, I'll use this [`README.md`](README.md) page to archive a list of pages that I would like to read more about through [OSDev.org]. 


__Status:__ _May 8th, 2016_ I have ran through all the code I had previously and updated it so that the `build_new` scripts (for [`gcc`][gcc] and [`binutils`][binutils]) now grab the latest release and version from their online host. Now the code is no longer strapped to the version I wrote it for in the past (as time goes on).

Also, I have cleaned and organized the [`gcc_cross_compiler`](gcc_cross_compiler) script so it is now a bit more orderly. Everything up until that point works smoothly. 

I have written the code for the [Bare Bones] tutorial and that is in the [`bare_bones`](01_bare_bones) directory, and I do feel it is complete. It builds and runs without a problem. 

Now, as of __July 10th, 2016__, I am trying to move through the [Meaty Skeleton] section. 

--------

Current Page:
-----

__[Meaty Skeleton]__



--------

More Readings to do...
-----

* [The Stack](http://wiki.osdev.org/Stack)
* [GDB](http://wiki.osdev.org/GDB)
* [Assembly](http://wiki.osdev.org/Assembly)
* [Books](http://wiki.osdev.org/Books)
* [Why do I need a Cross Compiler?](http://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F)
* [Building GCC](http://wiki.osdev.org/Building_GCC)
* [GCC](http://wiki.osdev.org/GCC)
* [Getting Started](http://wiki.osdev.org/Getting_Started)
* [Bare Bones]
* [Boot Sequence](http://wiki.osdev.org/Boot_Sequence)
* [Tutorials](http://wiki.osdev.org/Tutorials)
* [What order should I make things in?](http://wiki.osdev.org/What_order_should_I_make_things_in)



[kernel]: https://en.wikipedia.org/wiki/Kernel_%28operating_system%29
[operating system]: https://en.wikipedia.org/wiki/Operating_system
[OSDev.org]: http://osdev.org 
[StewieOS]: https://github.com/Caleb1994/StewieOS
[gcc]: https://gcc.gnu.org/
[Bare Bones]: http://wiki.osdev.org/Bare_Bones
[binutils]: https://www.gnu.org/software/binutils/
[Meaty Skeleton]: http://wiki.osdev.org/Meaty_Skeleton