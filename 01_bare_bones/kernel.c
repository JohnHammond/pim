/*
* @Author: John Hammond
* @Date:   2016-05-07 19:58:54
* @Last Modified by:   John Hammond
* @Last Modified time: 2016-05-07 20:16:58
*/

#if !defined(__cplusplus)
#include <stdbool.h> /* C does not have booleans on its own! */
#endif


#include <stddef.h> // This will include NULL and size_t.
#include <stdint.h> // This will include intx_t and uintx_t.

/* Check if the compiler thinks we are targetting the wrong operating system */
#if defined(__linux__)
#error "You are not using a cross-compiler. You will not succeed."
#endif

/* Our code will only work for a 32-bit ix86 target */
#if !defined(__i386__)
#error "This code is meant to be compiled with a ix86-elf compiler."
#endif

// Hardware text mode color constants...
enum vga_color {

	COLOR_BLACK = 0,
	COLOR_BLUE = 1,
	COLOR_GREEN = 2,
	COLOR_CYAN = 3,
	COLOR_RED = 4,
	COLOR_MAGENTA = 5,
	COLOR_BROWN = 6,
	COLOR_LIGHT_GREY = 7,
	COLOR_DARK_GREY = 8,
	COLOR_LIGHT_BLUE = 9,
	COLOR_LIGHT_GREEN = 10,
	COLOR_LIGHT_CYAN = 11,
	COLOR_LIGHT_RED = 12,
	COLOR_LIGHT_MAGENTA = 13,
	COLOR_LIGHT_BROWN = 14,
	COLOR_WHITE = 15,
};

uint8_t make_color( enum vga_color fg, enum vga_color bg ){

	return fg | bg << 4;
}

uint16_t make_vgaentry( char c, uint8_t color ){

	uint16_t c16 = c;
	uint16_t color16 = color;
	return c16 | color16 << 8;

}

size_t strlen( const char* str ){

	size_t iterator = 0;
	while ( str[iterator] != 0 ){
		iterator++;
	}

	return iterator;
}

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_initialize(){

	// Start at the top of the terminal
	terminal_row = 0;    
	terminal_column = 0;

	// Set a color...
	terminal_color = make_color( COLOR_LIGHT_GREY, COLOR_BLACK );
	terminal_buffer = (uint16_t*) 0xB8000; // This is where the VGA starts!

	// Begin to clear the whole screen...
	for ( size_t y = 0; y < VGA_HEIGHT; y++ ) {
		for ( size_t x = 0; x < VGA_WIDTH; x++ ){

			const size_t index = y * VGA_WIDTH + x; // Get the current position

			// Clear that position
			terminal_buffer[index] = make_vgaentry(' ', terminal_color);
		}
	}
}

void terminal_setcolor( uint8_t color ){

	terminal_color = color;
}

void terminal_putentryat( char c, uint8_t color, size_t x, size_t y ){

	// Get that current position...
	const size_t index = y * VGA_WIDTH + x;

	// Put a vgaentry there...
	terminal_buffer[index] = make_vgaentry(c, color);
}

void terminal_putchar( char c ){

	// Write the character..
	terminal_putentryat( c, terminal_color, terminal_column, terminal_row );

	// Account for if we overflow the terminal screen display...
	if ( ++terminal_column == VGA_WIDTH ){
		terminal_column = 0;
		if ( ++terminal_row == VGA_HEIGHT ){
			terminal_row = 0;
		}
	}	
}

void terminal_writestring(const char* string){

	// Get the length of the string
	size_t string_length = strlen(string);

	// Loop through it and print out all each character!
	for ( size_t i = 0; i < string_length; i++ ){

		terminal_putchar(string[i]);
	}
}


#if #defined(__cplusplus)
extern "C" /* Use C linkage for kernel_main */
#endif


// This is where our kernel will drop off; it's the start of our C code!
void kernel_main(){

	// Set up our display...
	terminal_initialize();

	// Say the magic words. :)
	terminal_writestring("Hello, Kernel World!");

}