#ifndef _KERNEL_TTY_H
#define _KERNEL_TTY_H


#include <stddef.h> 
// stddef.h just defines standard type definitions. 
// http://pubs.opengroup.org/onlinepubs/7908799/xsh/stddef.h.html
//
// It defines:
//		* NULL
//		* offsetof( type, member-designator )
// 
// It also defines through `typedef`...
//		* ptrdiff_t
//		* wchar_t
//		* size_t


// These are just function prototypes, that will be defined in a future tty.c

void terminal_initialize(void);
void terminal_putchar(char character);
void terminal_write(const char* data, size_t size);
void terminal_writestring(const char* data);

#endif