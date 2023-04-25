set architecture arm

file build/STBlink.elf
target extended-remote :3333

set remote hardware-breakpoint-limit 6
set remote hardware-watchpoint-limit 4

set print asm-demangle on

# Enable ARM semihosting to show debug console output in OpenOCD console.
monitor arm semihosting enable
