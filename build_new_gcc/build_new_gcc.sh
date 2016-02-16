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

# Color variables
RED=`tput setaf 1`							# code for red console text
GREEN=`tput setaf 2`						# code for green text
NC=`tput sgr0`								# Reset the text color

# Dependencies variables...
DEPENDENCIES="libgmp3-dev libmpfr-dev libmpc-dev"

function install_dependencies(){

	echo "$0: ${GREEN}Downloading all necessary dependencies...${NC}"
	echo "$0: ${GREEN}Please supply your password for sudo if you haven't already.${NC}"

	sudo apt-get update || panic
	sudo apt-get install $DEPENDENCIES || panic

}

function download_gcc_source(){

	echo "$0: ${GREEN}Downloading gcc_5.3.0 source package...${NC}"
	wget -nc "ftp://mirrors-usa.go-parts.com/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.gz" || panic
}

function prepare_directories(){

	echo "$0: ${GREEN}Making and moving into an /opt/ folder in your home directory..${NC}"

	mkdir -p $HOME/opt/build-gcc || panic

	cd $HOME/opt
}

function extract_gcc(){

	echo "$0: ${GREEN}Extracting the gcc source package ... ${NC}"
	
	if [ ! -d "gcc-5.3.0" ]; then
		gunzip gcc-5.3.0.tar.gz || panic
		tar xfv gcc-5.3.0.tar || panic
	fi
}

function build_gcc(){

	echo "$0: ${GREEN}Beginning to build gcc... ${NC}"
	echo "$0: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"
	
	export PREFIX="$HOME/opt/gcc-5.3.0"
	
	cd build-gcc || panic
	../gcc-5.3.0/configure --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ || panic

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 
	# --enable-languages tells GCC to not to compile all the other language frontends it supports, but only C (and optionally C++).


	# I use -j8 to use 8 threads; make it go a lot faster than just 1 thread!
	make -j8 || panic
	make install || panic
}

function add_gcc_to_path(){

	echo "$0: ${GREEN}Now adding gcc 5.3.0 to the PATH... ${NC}"
	export PATH="$HOME/opt/gcc-5.3.0/bin:$PATH"
	echo 'export PATH="$HOME/opt/gcc-5.3.0/bin:$PATH"' >> ~/.bashrc
}

function main()
{
	echo "$0: ${GREEN}Preparing to build gcc 5.3.0!${NC}"
	
	install_dependencies
	prepare_directories
	download_gcc_source
	extract_gcc
	build_gcc

	add_gcc_to_path

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
