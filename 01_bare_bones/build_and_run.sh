#!/bin/bash
# @Author: John Hammond
# @Date:   2016-05-07 22:03:40
# @Last Modified by:   John Hammond
# @Last Modified time: 2016-05-07 22:15:31

# Color variables
RED=`tput setaf 1`							# code for red console text
GREEN=`tput setaf 2`						# code for green text
NC=`tput sgr0`								# Reset the text color

# Stuff you may need or want if you have not ran this before...
DEPENDENCIES="qemu-system-x86 xorriso"

function install_dependencies(){

	echo "$FUNCNAME: ${GREEN}Downloading all necessary dependencies...${NC}"
	echo "$FUNCNAME: ${GREEN}Please supply your password for sudo if you haven't already.${NC}"

	sudo apt-get update || panic
	sudo apt-get install $DEPENDENCIES || panic

}


function assemble_bootstrap(){

	echo "$FUNCNAME: ${GREEN}Assembling the multiboot bootstrap...${NC}"
	i686-elf-as boot.s -o boot.o
}


function compile_kernel(){

	echo "$FUNCNAME: ${GREEN}Compiling the C code for the kernel...${NC}"
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
}

function link_files(){

	echo "$FUNCNAME: ${GREEN}Linking both objects files for Assembly and C...${NC}"
	i686-elf-gcc -T linker.ld -o PIM.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
}

function create_grub_menu(){

	echo "$FUNCNAME: ${GREEN}Preparing the boot menu for GRUB...${NC}"
cat <<EOF 	> grub.cfg
menuentry "Poetry in Motion" {
	multiboot /boot/PIM.bin
}
EOF

}

function create_bootable_image(){

	echo "$FUNCNAME: ${GREEN}Creating the ISO with GRUB...${NC}"
	mkdir -p isodir/boot/grub
	cp PIM.bin isodir/boot/PIM.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o PIM.iso isodir
}

function run(){

	echo "$FUNCNAME: ${GREEN}Starting up QEMU...${NC}"
	echo "$FUNCNAME: ${GREEN}Running! ${NC}"
	qemu-system-i386 -cdrom PIM.iso
}


function main(){

	echo "$FUNCNAME: ${GREEN}Beginning to build everything for the Bare Bones tutorial...${NC}"
	echo "$FUNCNAME: ${GREEN}The necessary files are: 'boot.s', 'kernel.c', & 'linker.ld'.${NC}"

	install_dependencies	
	assemble_bootstrap || panic
	compile_kernel || panic
	link_files || panic
	create_grub_menu || panic
	create_bootable_image || panic
	run
}


# Test if we actually have a command on the current box.
# Usage:
#    if command_exists <command> ; then
#			# do stuff if the command exists!
#    else
#           # do other stuff is the command does not exist
#	 fi
function command_exists(){
	type "$1" &> /dev/null
}

# Print a fatal error message and exit
# Usage:
# 	some_command parameter || panic
# 	
# 	This will print the panic message and exit if `some_command` fails.
function panic
{
	echo "$FUNCNAME: ${RED}fatal error${NC}"
	exit -1
}


# This makes it so every function has a "pre-declaration" of all the functions
main "$@"
