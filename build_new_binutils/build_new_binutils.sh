#!/bin/bash
# Author: John Hammond
# Date: 15FEB16
# Description:
#    build_new_binutils.sh will automate the process of grabbing binutils 2.26 and building it in your home directory's /opt folder.
#    
#     Instructions
#
#    	 1. Run this script with regular user permissions; it should do everything for you!
#

# Color variables
RED=`tput setaf 1`							# code for red console text
GREEN=`tput setaf 2`						# code for green text
NC=`tput sgr0`								# Reset the text color


function download_binutils_source(){

	echo "$0: ${GREEN}Downloading binutils 2.26 source package...${NC}"
	wget -nc "http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.gz" || panic
}

function prepare_directories(){

	echo "$0: ${GREEN}Making and moving into an /opt/ folder in your home directory..${NC}"

	mkdir -p $HOME/opt/build-binutils || panic

	cd $HOME/opt
}

function extract_binutils(){

	echo "$0: ${GREEN}Extracting the binutils 2.26 package ... ${NC}"
	
	if [ ! -d "binutils-2.26" ]; then
		gunzip binutils-2.26.tar.gz || panic
		tar xfv binutils-2.26.tar || panic
	fi
}

function build_binutils(){

	echo "$0: ${GREEN}Beginning to build binutils... ${NC}"
	# echo "$0: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"
	
	# I use the same prefix as the gcc folder because they are intertwined...
	export PREFIX="$HOME/opt/gcc-5.3.0"
	
	cd build-binutils || panic
	../binutils-2.26/configure --prefix="$PREFIX" --disable-nls --disable-werror || panic

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 

	make -j8 || panic
	make install -j8 || panic
}

function add_binutils_to_path(){

	echo "$0: ${GREEN}Now adding binutils 2.26 to the PATH... ${NC}"
	export PATH="$HOME/opt/binutils-2.26/bin:$PATH"
	echo 'export PATH="$HOME/opt/binutils-2.26/bin:$PATH"' >> ~/.bashrc
}

function main()
{
	echo "$0: ${GREEN}Preparing to build binutils 2.26!${NC}"
	
	prepare_directories
	download_binutils_source
	extract_binutils
	build_binutils

	add_gcc_to_path

	echo "$0: ${GREEN}binutils 2.26 successfully built!${NC}"

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
