#!/bin/bash

# Colorize and add text parameters
export red=$(tput setaf 1)             #  red
export grn=$(tput setaf 2)             #  green
export blu=$(tput setaf 4)             #  blue
export cya=$(tput setaf 6)             #  cyan
export txtbld=$(tput bold)             #  Bold
export bldred=${txtbld}$(tput setaf 1) #  red
export bldgrn=${txtbld}$(tput setaf 2) #  green
export bldblu=${txtbld}$(tput setaf 4) #  blue
export bldcya=${txtbld}$(tput setaf 6) #  cyan
export txtrst=$(tput sgr0)             #  Reset


# check if ccache installed, if not install
if [ ! -e /usr/bin/ccache ]; then
	echo "You must install 'ccache' to continue.";
	sudo apt-get install ccache
fi

# check if xmllint installed, if not install
if [ ! -e /usr/bin/xmllint ]; then
	echo "You must install 'xmllint' to continue.";
	sudo apt-get install libxml2-utils
fi

echo "${bldcya}***** Clean up Environment before compile *****${txtrst}";


# Make clean source
read -t 5 -p "Make clean source, 5sec timeout (y/n)?";
if [ "$REPLY" == "y" ]; then
make clean;
make distclean;
make mrproper;
fi;

# clear ccache
read -t 5 -p "Clear ccache but keeping the config file, 5sec timeout (y/n)?";
if [ "$REPLY" == "y" ]; then
ccache -C;
fi;


TARGET=$1
if [ "$TARGET" != "" ]; then
	echo
        echo "Starting your build for $TARGET"
else
        echo ""
        echo "You need to define your device target!"
        echo "example: build_kernel.sh G928C"
        echo "example: build_kernel.sh G928T"
        echo "example: build_kernel.sh G9287C"
        echo "example: build_kernel.sh N920C"
        echo "example: build_kernel.sh N920P"
        echo "example: build_kernel.sh N920R4"
        echo "example: build_kernel.sh N920K"
        echo "example: build_kernel.sh N920S"
        echo "example: build_kernel.sh N9200"
        echo "example: build_kernel.sh N9208_SEA"
        echo "example: build_kernel.sh N9208_TW"
        echo "example: build_kernel.sh N920T"
        exit 1
fi


# location
	export KERNELDIR=`readlink -f .`;


# set build variables
BK=build_kernel
export KCONFIG_NOTIMESTAMP=true
export ARCH=arm64;
export SUB_ARCH=arm64;

# SM-G928 C/F/G/I
if [ "$TARGET" = "G928C" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-G928C_MEA_defconfig";
fi;

# SM-G928 T/W8 (T-Mobile)
if [ "$TARGET" = "G928T" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-G928T_defconfig";
fi;

# SM-G9278C (dual SIM) use same defconfig as SM-G928 C/F/G/I but specific ramdisks
if [ "$TARGET" = "G9287C" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-G928C_MEA_defconfig";
fi;

# SM-N920 C/CD/G/I
if [ "$TARGET" = "N920C" ] ; then
export KERNEL_CONFIG="SkyHigh_defconfig";
fi;

# SM-N920 P (Sprint)
if [ "$TARGET" = "N920P" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920P_Sprint_defconfig";
fi;

# SM-N920 R4 (US.Cellular) ## not supported by SkyHigh
if [ "$TARGET" = "N920R4" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920R4_USC_defconfig";
fi;

# SM-N920 K (Korea KKT) use same defconfig for SM-N920 S/K/L but specific ramdisks
if [ "$TARGET" = "N920K" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920S_defconfig";
fi;

# SM-N920 S (Korea SKT) use same defconfig for SM-N920 S/K/L but specific ramdisks
if [ "$TARGET" = "N920S" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N920S_defconfig";
fi;

# SM-N9200 (Hong Kong - dual SIM)
if [ "$TARGET" = "N9200" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N9200_HK_defconfig";
fi;

# SM-N9208 (SEA - dual SIM)
if [ "$TARGET" = "N9208_SEA" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N9208_SEA_defconfig";
fi;

# SM-N9208 (Taiwan - dual SIM) ## not supported by SkyHigh
if [ "$TARGET" = "N9208_TW" ] ; then
export KERNEL_CONFIG="SkyHigh_SM-N9208_TW_defconfig";
fi;

# SM-N920 T/W8 (T-Mobile)
if [ "$TARGET" = "N920T" ] ; then
export KERNEL_CONFIG="SkyHigh_tmo_defconfig";
fi;


# build script
export USER=`whoami`;
export TMPFILE=`mktemp -t`;


# system compiler
export CROSS_COMPILE=/home/upintheair/gcc-linaro-4.9-2015.02-3-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-


# CPU Core
export NUMBEROFCPUS=`grep 'processor' /proc/cpuinfo | wc -l`;
