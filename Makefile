SDK_PREFIX ?= arm-none-eabi-
CC = $(SDK_PREFIX)gcc
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy

QEMU = qemu-system-arm
BOARD ?= mps2-an385
CPU_CC = cortex-m3
TARGET = firmware
TCP_ADDR = 1234

deps = \
       start.S \
       lscript.ld

all: target

target:
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -mthumb -Wall start.S -o start.o
	$(CC) start.o -mcpu=$(CPU_CC) -mthumb -Wall --specs=nosys.specs -nostdlib -lgcc -T./lscript.ld -o $(TARGET).elf

qemu:
	$(OBJCOPY) -O binary -F elf32-littlearm $(TARGET).elf $(TARGET).bin
	$(QEMU) -M $(BOARD) -cpu $(CPU_CC) -d unimp,guest_errors -kernel $(TARGET).bin -semihosting-config enable=on,target=native -s -S

clean:
	-rm *.o
	-rm *.elf
	-rm *.bin
