CC=arm-none-eabi-gcc
CFLAGS=-mcpu=cortex-m3 -mthumb
CPPFLAGS=-DSTM32F103xB \
 -I./3rd-party/cmsis_device_f1/Include \
 -I./3rd-party/CMSIS_5/CMSIS/Core/Include

LDFLAGS=-T STM32F103XB_FLASH.ld

BINARY = $(notdir $(CURDIR)).elf

build_dir := ./build
out_dir := $(build_dir)/obj

srcs := $(shell find ./src -name '*.c')
objs += $(srcs:%=$(out_dir)/%.o)
objs += $(out_dir)/system_stm32f1xx.o
objs += $(out_dir)/startup_stm32f103xb.o

all: $(build_dir)/$(BINARY)

$(build_dir)/$(BINARY): $(objs)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o $@

$(out_dir)/system_stm32f1xx.o: ./3rd-party/cmsis_device_f1/Source/Templates/system_stm32f1xx.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(out_dir)/startup_stm32f103xb.o: startup_stm32f103xb.s
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(out_dir)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf ./build
