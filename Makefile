BUILD_CONFIG ?= release

CC=arm-none-eabi-gcc
CFLAGS.debug := -g
CFLAGS.release := 
CFLAGS=-mcpu=cortex-m3 -mthumb $(CFLAGS.$(BUILD_CONFIG))
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

openocd := $(shell openocd --version >/dev/null 2>&1 && echo 'openocd')

ifneq (,$(openocd))
run: $(build_dir)/$(BINARY)
	$(openocd) -f 'openocd.cfg' -c 'program $< verify reset exit'
endif # openocd

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
