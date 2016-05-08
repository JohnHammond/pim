#!/bin/bash
# Author: John Hammond
# Date: 15FEB16
# Description:
#    build_new_binutils.sh will automate the process of grabbing the latest binutils version and building it in your home directory's /opt folder.
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

	echo "$FUNCNAME: ${GREEN}Downloading $BINUTILS_VERSION source package...${NC}"
	wget -nc "$BINUTILS_URL/$BINUTILS_VERSION.tar.gz" || panic
}

function prepare_directories(){

	echo "$FUNCNAME: ${GREEN}Making and moving into an /opt/ folder in your home directory..${NC}"

	mkdir -p $HOME/opt/build-binutils || panic

	cd $HOME/opt
}

function extract_binutils(){

	echo "$FUNCNAME: ${GREEN}Extracting the $BINUTILS_VERSION package ... ${NC}"
	
	if [ ! -d "$BINUTILS_VERSION" ]; then
		gunzip $BINUTILS_VERSION.tar.gz || panic
		tar xfv $BINUTILS_VERSION.tar || panic
	fi
}


function build_binutils(){

	echo "$FUNCNAME: ${GREEN}Beginning to build binutils... ${NC}"
	# echo "$FUNCNAME: ${GREEN} This is going to take a while. Get comfortable! :D ${NC}"
	
	# I use the same prefix as the gcc folder because they are intertwined...
	export PREFIX="$HOME/opt/$GCC_VERSION"
	
	cd build-binutils || panic
	../$BINUTILS_VERSION/configure --prefix="$PREFIX" --disable-nls --disable-werror || panic

	# --disable-nls tells binutils not not include native language support. This is basically optional, but reduces dependencies and compile time. It will also result in English-language diagnostics, 

	make -j8 || panic
	make install -j8 || panic
}

function add_binutils_to_path(){

	echo "$FUNCNAME: ${GREEN}Now adding $BINUTILS_VERSION to the PATH... ${NC}"
	export PATH="$HOME/opt/$BINUTILS_VERSION/bin:$PATH"
	echo 'export PATH="$HOME/opt/$BINUTILS_VERSION/binutils:$PATH"' >> ~/.bashrc
}

function determine_latest_binutils_version(){

	echo "$FUNCNAME: ${GREEN}Determining the latest binutils version... ${NC}"
	FOUND=`lynx --dump "http://ftp.gnu.org/gnu/binutils/"|tail -n 1|awk '{print $2}'`
	BINUTILS_URL=`echo $FOUND|cut -d "/" -f1,2,3,4,5`
	BINUTILS_VERSION=`echo $FOUND|cut -d "/" -f6|cut -d "." -f1,2`
	echo "$FUNCNAME: ${GREEN}Latest binutils version found to be $BINUTILS_VERSION!${NC}"
}

function determine_latest_gcc_version(){

	echo "$FUNCNAME: ${GREEN}Determining the latest GCC version... ${NC}"
	GCC_URL=`lynx --dump "http://mirrors-usa.go-parts.com/gcc/releases/"|tail -n 1|awk '{print $2}'`
	GCC_VERSION=`echo $GCC_URL|rev|cut -d "/" -f2|rev`
	echo "$FUNCNAME: ${GREEN}Latest GCC version found to be $GCC_VERSION!${NC}"
}

function main()
{

	determine_latest_binutils_version
	determine_latest_gcc_version

	echo "$FUNCNAME: ${GREEN}Preparing to build $BINUTILS_VERSION!${NC}"
	
	prepare_directories
	download_binutils_source
	extract_binutils
	build_binutils

	# I don't think this is a necessary step! ...
	# add_binutils_to_path


	echo "$FUNCNAME: ${GREEN}$BINUTILS_VERSION successfully built!${NC}"

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
