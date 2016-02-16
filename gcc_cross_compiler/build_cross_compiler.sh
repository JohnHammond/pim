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

# Dependencies variables...
DEPENDENCIES="libgmp3-dev libmpfr-dev libmpc-dev"

# This function is taken directly from the `build_new_gcc` script in the 
# corresponding folder
function install_dependencies(){

	echo "$0: ${GREEN}Downloading all necessary dependencies...${NC}"
	echo "$0: ${GREEN}Please supply your password for sudo if you haven't already.${NC}"

	sudo apt-get update || panic
	sudo apt-get install $DEPENDENCIES || panic

}

# This function is taken directly from the `build_new_gcc` script in the 
# corresponding folder
function download_gcc_source(){

	echo "$0: ${GREEN}Downloading gcc_5.3.0 source package...${NC}"
	wget -nc "ftp://mirrors-usa.go-parts.com/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.gz" || panic
}

# This function is taken directly from the `build_new_binutils` script in the 
# corresponding folder
function download_binutils_source(){

	echo "$0: ${GREEN}Downloading binutils 2.26 source package...${NC}"
	wget -nc "http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.gz" || panic
}


function prepare_directories(){

	echo "$0: ${GREEN}Making and moving into an /opt/ folder in your home directory..${NC}"

	export PREFIX="$HOME/opt/cross"
	export TARGET=i686-elf
	export PATH="$PREFIX/bin:$PATH"

	mkdir -p $PREFIX || panic
	mkdir -p $HOME/opt/build-binutils || panic
	mkdir -p $HOME/opt/build-gcc || panic

	cd $HOME/opt
}

# This function is taken directly from the `build_new_gcc` script in the 
# corresponding folder
function extract_gcc(){

	echo "$0: ${GREEN}Extracting the gcc source package ... ${NC}"
	
	if [ ! -d "gcc-5.3.0" ]; then
		gunzip gcc-5.3.0.tar.gz || panic
		tar xfv gcc-5.3.0.tar || panic
	fi
}

# This function is taken directly from the `build_new_binutils` script in the 
# corresponding folder
function extract_binutils(){

	echo "$0: ${GREEN}Extracting the binutils 2.26 package ... ${NC}"
	
	if [ ! -d "binutils-2.26" ]; then
		gunzip binutils-2.26.tar.gz || panic
		tar xfv binutils-2.26.tar || panic
	fi
}

# THIS FUNCTION IS MODIFIED FROM `build_new_binutils`:
#   it has new flags for the configure script, the target and other options
function build_binutils(){

	echo "$0: ${GREEN}Beginning to build binutils... ${NC}"
	# echo "$0: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"
	
	# I use the same prefix as the gcc folder because they are intertwined...
	
	cd ~/opt/build-binutils || panic
	../binutils-2.26/configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror || panic

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 
	# --with-sysroot tells binutils to enable sysroot support in the cross-compiler by pointing it to a default empty directory

	# Clean anything that might already be there...
	sudo make distclean


	make || panic
	make install || panic
}

# THIS FUNCTION IS MODIFIED FROM `build_new_gcc`:
#   it has new flags for the configure script, the target and other options
#   it also only makes the necessary components, not the entire package
function build_gcc(){

	echo "$0: ${GREEN}Beginning to build gcc... ${NC}"
	echo "$0: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"

	cd ~/opt/build-gcc || panic
	../gcc-5.3.0/configure --target="$TARGET" --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers || panic

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 
	# --enable-languages tells GCC to not to compile all the other language frontends it supports, but only C (and optionally C++).
	# --without-headers tells GCC not to rely on any C library (standard or runtime) being present for the target. 

	# Clean anything that might already be there...
	sudo make distclean

	# I use -j8 to use 8 threads; make it go a lot faster than just 1 thread!
	make -j8 || panic

	# For the cross-compiler we just make things that are only necessary.
	make all-gcc || panic
	make all-target-libgcc || panic
	make install-gcc || panic
	make install-target || panic
}

function add_cross_to_path(){

	echo "$0: ${GREEN}Now adding the cross-compiler to the PATH... ${NC}"
	export PATH="$HOME/opt/cross/bin:$PATH"

	echo 'export PATH="$HOME/opt/cross/bin:$PATH"' >> ~/.bashrc
}

function main()
{
	echo "$0: ${GREEN}Preparing to build cross compiler!${NC}"

	export PREFIX="$HOME/opt/cross"
	# export TARGET=i686-elf
	export PATH="$PREFIX/bin:$PATH"

	cd ~/opt/build-binutils
	rm -rf ~/opt/build-binutils/* # The makefiles may be broken; clean it all up
	../binutils-2.26/configure --target=i686-elf --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
	
	make || panic
	make install || panic


	cd ~/opt/build-gcc
	rm -rf ~/opt/build-gcc/* # The makefiles may be broken; clean it all up
	../gcc-5.3.0/configure --target=i686-elf --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers || panic
	make all-gcc || panic
	make all-target-libgcc || panic
	make install-gcc || panic
	make install-target-libgcc || panic

	
	# install_dependencies
	# prepare_directories

	# download_gcc_source
	# download_binutils_source
	# extract_gcc
	# extract_binutils
	

	# build_binutils
	# build_gcc

	# add_cross_to_path

	echo "$0: ${GREEN}GCC successfully built!${NC}"

	exit 0
}


# Print a fatal error message and exit
# Usage:
# 	some_command parameter || panic
# 	
# 	This will print the panic message and exit if `some_command` fails.
function panic
{
	echo "$0: ${RED}fatal error${NC}"
	exit -1
}



# This makes it so every function has a "pre-declaration" of all the functions
main "$@"
