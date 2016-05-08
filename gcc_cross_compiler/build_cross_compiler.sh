#!/bin/bash
# Author: John Hammond
# Date: 15FEB16
# Description:
#    build_new_gcc_5.3.0.sh will automate the process of grabbing gcc_5.3.0 and building it in your home directory's /opt folder.
#    
#     Instructions
#
#    	 1. Run this script with regular user permissions; it should do everything for you!
#


# Current status; THIS SCRIPT DOES  WORK... BUT IT MUST BE CLEANED

# Color variables
RED=`tput setaf 1`							# code for red console text
GREEN=`tput setaf 2`						# code for green text
NC=`tput sgr0`								# Reset the text color

# THIS FUNCTION IS MODIFIED FROM `build_new_binutils`:
#   it has new flags for the configure script, the target and the NEW PREFIX
function build_binutils(){

	echo "$FUNCNAME: ${GREEN}Beginning to build binutils... ${NC}"

	cd ~/opt/build-binutils
	rm -rf ~/opt/build-binutils/* # The makefiles may be broken; clean it all up
	../$BINUTILS_VERSION/configure --target=i686-elf --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 
	# --with-sysroot tells binutils to enable sysroot support in the cross-compiler by pointing it to a default empty directory


	make || panic
	make install || panic
}

# THIS FUNCTION IS MODIFIED FROM `build_new_gcc`:
#   it has new flags for the configure script, the target and other options
#   it also only makes the necessary components, not the entire package
function build_gcc(){

	echo "$FUNCNAME: ${GREEN}Beginning to build gcc... ${NC}"
	echo "$FUNCNAME: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"

	cd ~/opt/build-gcc
	rm -rf ~/opt/build-gcc/* # The makefiles may be broken; clean it all up
	../$GCC_VERSION/configure --target=i686-elf --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers || panic
	
	# For the cross-compiler we just make things that are only necessary.
	make all-gcc || panic
	make all-target-libgcc || panic
	make install-gcc || panic
	make install-target-libgcc || panic


}

# This is stolen straight from the build_binutils.sh script.
function determine_latest_binutils_version(){

	echo "$FUNCNAME: ${GREEN}Determining the latest binutils version... ${NC}"
	FOUND=`lynx --dump "http://ftp.gnu.org/gnu/binutils/"|tail -n 1|awk '{print $2}'`
	BINUTILS_URL=`echo $FOUND|cut -d "/" -f1,2,3,4,5`
	BINUTILS_VERSION=`echo $FOUND|cut -d "/" -f6|cut -d "." -f1,2`
	echo "$FUNCNAME: ${GREEN}Latest binutils version found to be $BINUTILS_VERSION!${NC}"
}

# This is stolen straight from the build_gcc.sh script.
function determine_latest_gcc_version(){

	echo "$FUNCNAME: ${GREEN}Determining the latest GCC version... ${NC}"
	GCC_URL=`lynx --dump "http://mirrors-usa.go-parts.com/gcc/releases/"|tail -n 1|awk '{print $2}'`
	GCC_VERSION=`echo $GCC_URL|rev|cut -d "/" -f2|rev`
	echo "$FUNCNAME: ${GREEN}Latest GCC version found to be $GCC_VERSION!${NC}"
}

function prepare_directories(){

	echo "$FUNCNAME: ${GREEN}Making and moving into an /opt/ folder in your home directory..${NC}"

	export PREFIX="$HOME/opt/cross"
	export TARGET=i686-elf
	export PATH="$PREFIX/bin:$PATH"

	mkdir -p $PREFIX || panic
	mkdir -p $HOME/opt/build-binutils || panic
	mkdir -p $HOME/opt/build-gcc || panic

	cd $HOME/opt
}
function add_cross_to_path(){

	echo "$FUNCNAME: ${GREEN}Now adding the cross-compiler to the PATH... ${NC}"
	export PATH="$HOME/opt/cross/bin:$PATH"

	echo 'export PATH="$HOME/opt/cross/bin:$PATH"' >> ~/.bashrc
}

function main()
{

	determine_latest_binutils_version
	determine_latest_gcc_version

	echo "$FUNCNAME: ${GREEN}Preparing to build cross compiler!${NC}"
	echo "$FUNCNAME: ${GREEN}This whole script operates under the assumption that you have${NC}"
	echo "$FUNCNAME: ${GREEN}ran the two scripts to download and build the latest binutils ${NC}"
	echo "$FUNCNAME: ${GREEN}and gcc versions. Their files must be accessible.${NC}"


	prepare_directories

	build_binutils
	build_gcc

	add_cross_to_path


	echo "$FUNCNAME: ${GREEN}The cross-compiler has been successfully built!${NC}"

	exit 0
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
