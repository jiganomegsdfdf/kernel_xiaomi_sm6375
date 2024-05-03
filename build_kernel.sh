#!/bin/bash

#Clone neutron-clang 
 mkdir toolchain && (cd toolchain; bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S)
 
KERNEL_DEFCONFIG="veux_halium_defconfig"
KERNEL_CMDLINE="O=out ARCH=arm64 CC=clang LD=ld.lld AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-"



#Building kernel
    export PATH=$(pwd)/toolchain/bin/:$PATH
    export ARCH=arm64
    export SUBARCH=arm64
    export DISABLE_WRAPPER=1
    make $KERNEL_CMDLINE $KERNEL_DEFCONFIG 
    make $KERNEL_CMDLINE -j$(nproc --all)

    
#Zip the kernel    
cp out/arch/arm64/boot/Image $(pwd)/AnyKernel3
cd AnyKernel3 && mv veux.dtb dtb && zip -r9 Beast_veux_$(date +"%Y-%m-%d").zip *

echo "Done!"
