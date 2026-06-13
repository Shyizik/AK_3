SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = qemu-system-arm
BOARD ?= mps2-an385
MCU = cortex-m3
TARGET = firmware
CPU_CC = cortex-m3

all: kernel bootloader

kernel:
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -mthumb -Wall print.S -o print.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -mthumb -Wall kernel.S -o kernel.o
	$(CC) print.o kernel.o -mcpu=$(CPU_CC) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./lscript.ld -o kernel.elf
	$(OBJCOPY) -O binary -F elf32-littlearm kernel.elf kernel.bin

bootloader:
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -mthumb -Wall bootloader.S -o bootloader.o
	$(CC) print.o bootloader.o -mcpu=$(CPU_CC) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./lscript.ld -o $(TARGET).elf

qemu:
	$(OBJCOPY) -O binary -F elf32-littlearm $(TARGET).elf $(TARGET).bin
	$(QEMU) -M $(BOARD) -cpu $(MCU) -d unimp,guest_errors -kernel $(TARGET).bin -semihosting-config enable=on,target=native -s -S

clean:
	-rm *.o
	-rm *.elf
	-rm *.bin
