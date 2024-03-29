#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export ARCH=arm64
export KBUILD_BUILD_HOST="gitpodkesayanganku"
export KBUILD_BUILD_USER="fjrXTR"
git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
git clone --depth=1 https://github.com/sarthakroy2002/prebuilts_gcc_linux-x86_aarch64_aarch64-linaro-7 los-4.9-64
git clone --depth=1 https://github.com/sarthakroy2002/linaro_arm-linux-gnueabihf-7.5 los-4.9-32

rm -rf AnyKernel
make O=out ARCH=arm64 rosemary_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/los-4.9-32/bin:${PATH}:${PWD}/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="${PWD}/los-4.9-64/bin/aarch64-linux-gnu-" \
                      CROSS_COMPILE_ARM32="${PWD}/los-4.9-32/bin/arm-linux-gnueabihf-" \
                      LD=ld.lld \
                      AS=llvm-as \
		              AR=llvm-ar \
			          NM=llvm-nm \
			          OBJCOPY=llvm-objcopy \
                      CONFIG_SECTION_MISMATCH_WARN_ONLY=y
}

function zupload()
{
git clone --depth=1 https://github.com/fjrXTR/AnyKernel3.git AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 liquid-Maika-kernel-v1.4-rosemary.zip *
curl -T liquid-Maika-kernel-v1.4-rosemary.zip temp.sh
}

compile
zupload