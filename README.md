# CUSTOM_LINUX_CPUCACHE
Custom server linux distro (macro kernel) that can run in L1 cache i hope, otherwise can run in a ryzen 7 9800X3D's L3 cache easily. Since this is the public version i am currently making this run inside ram and it will only be CLI

## RANDOM INFORMATION
CURRENTLY ONLY RUNS IN RAM!!!
Will run as a "initrd

## LICENCE (CUSTOM)
By aquiring you understand you are NOT to edit, copy or patent any of the files within this repository

## HOW TO COMPILE CORRECTLY

### Step 1
nasm -f elf32 boot.asm -o boot.o

### Step 2
gcc -m32 -Os -ffreestanding -fno-indent -nostdlib -c kernel.c -o kernel.o
gcc -m32 -Os -ffreestanding -fno-indent -nostdlib -c brsr.c -o brsr.o
gcc -m32 -Os -ffreestanding -fno-indent -nostdlib -c shell.c -o shell.o

### Step 3
ld -m elf_i386 -T linker.ld boot.o kernel.o -o kernel.bin

### Step 4
strip --strip-all --remove-section=.comment --remove-section=.note kernel.bin

### Step 5
upx --best --ultra-brute kernel.bin
