This is a showcase project demonstrating the required minimum of things needed to build an executable for STM32 Cortex-M3 processor _without_ Cube IDE.

The tools needed are:
- GNU Compiler Collection [`sudo apt install gcc-arm-none-eabi`]
- GNU Make [`sudo apt install make`]
- OpenOCD [[mirror](https://github.com/openocd-org/openocd/releases)]

On Windows one may need [zadig](https://zadig.akeo.ie/#) or similar tool so to install WinUSB driver for STLink dongle.

Flashing command is like:

`openocd -f interface/stlink.cfg -f target/stm32f1x_clone.cfg -c "program build/STBlink.elf verify reset exit"`

A helpful [article series](https://kleinembedded.com/stm32-without-cubeide-part-1-the-bare-necessities/) this project is born after. 
Repository contains some reference documents that originate from [STMicroelectronics site](https://www.st.com/content/st_com/en.html)

