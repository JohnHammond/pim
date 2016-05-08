#!/bin/bash
# Author: John Hammond
# Date: 15FEB16
# Description:
#    build_new_gcc.sh will automate the process of grabbing the latest GCC and building it in your home directory's /opt folder.
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
DEPENDENCIES="libgmp3-dev libmpfr-dev libmpc-dev gcc-multilib"

function install_dependencies(){

	echo "$FUNCNAME: ${GREEN}Downloading all necessary dependencies...${NC}"
	echo "$FUNCNAME: ${GREEN}Please supply your password for sudo if you haven't already.${NC}"

	sudo apt-get update || panic
	sudo apt-get install $DEPENDENCIES || panic

}

function download_gcc_source(){

	echo "$FUNCNAME: ${GREEN}Downloading $GCC_VERSION source package...${NC}"
	wget -nc "$GCC_URL/$GCC_VERSION.tar.gz" || panic
}

function prepare_directories(){

	echo "$FUNCNAME: ${GREEN}Making and moving into an /opt/ folder in your home directory..${NC}"

	mkdir -p $HOME/opt/build-gcc || panic

	cd $HOME/opt
}

function extract_gcc(){

	echo "$FUNCNAME: ${GREEN}Extracting the gcc source package ... ${NC}"
	
	if [ ! -d "$GCC_VERSION" ]; then
		gunzip $GCC_VERSION.tar.gz || panic
		tar xfv $GCC_VERSION.tar || panic
	fi
}

function build_gcc(){

	echo "$FUNCNAME: ${GREEN}Beginning to build gcc... ${NC}"
	echo "$FUNCNAME: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"
	
	export PREFIX="$HOME/opt/$GCC_VERSION"
	
	cd build-gcc || panic
	../$GCC_VERSION/configure --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --enable-multilib || panic 

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 
	# --enable-languages tells GCC to not to compile all the other language frontends it supports, but only C (and optionally C++).


	# I use -j8 to use 8 threads; make it go a lot faster than just 1 thread!
	make -j8 || panic
	make install || panic
}

function add_gcc_to_path(){

	echo "$FUNCNAME: ${GREEN}Now adding $GCC_VERSION to the PATH... ${NC}"
	export PATH="$HOME/opt/$GCC_VERSION/bin:$PATH"
	echo "export PATH=$HOME/opt/$GCC_VERSION/bin:$PATH" >> ~/.bashrc
}

function determine_latest_gcc_version(){

	echo "$FUNCNAME: ${GREEN}Determining the latest GCC version... ${NC}"
	GCC_URL=`lynx --dump "http://mirrors-usa.go-parts.com/gcc/releases/"|tail -n 1|awk '{print $2}'`
	GCC_VERSION=`echo $GCC_URL|rev|cut -d "/" -f2|rev`
	echo "$FUNCNAME: ${GREEN}Latest GCC version found to be $GCC_VERSION!${NC}"
}

function main()
{

	determine_latest_gcc_version

	echo "$FUNCNAME: ${GREEN}Preparing to build $GCC_VERSION!${NC}"

	install_dependencies
	prepare_directories
	download_gcc_source
	extract_gcc
	build_gcc

	add_gcc_to_path

	echo "$FUNCNAME: ${GREEN}GCC successfully built!${NC}"

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
