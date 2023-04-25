## STBlink

This is a showcase project demonstrating the required minimum of things needed to build an executable for STM32 Cortex-M3 processor _**without**_ Cube IDE.

The tools needed are:
- GNU Compiler Collection
- GNU Make
- GNU Debugger Multi-Arch
- OpenOCD

Intall those first: `sudo apt install gcc-arm-none-eabi gdb-multiarch make openocd`. When on Windows \w WSL2, check for [_usbipd-win_](https://learn.microsoft.com/en-us/windows/wsl/connect-usb) tool. This is needed for making host USB devices accessible by guest OS. Aside that, Windows users may need [zadig](https://zadig.akeo.ie/#) or similar tool so to install WinUSB driver for STLink dongle.

On Ubuntu OpenOCD may experience hard times reaching out to STLink device telling something similar to `Error: libusb_open() failed with LIBUSB_ERROR_ACCESS`. An additional _udev_ ruleset may be required in this situation:
```
$> sudo tee -a /etc/udev/rules.d/51-usb.stlink.rules > /dev/null << EOF
SUBSYSTEMS=="usb",ATTRS{idVendor}=="<VID>",ATTRS{idProduct}=="<PID>",GROUP="plugdev",TAG+="uaccess"
EOF
```

Both VID and PID can be retrieved either with `usbipd wsl list` on host or with `lsusb [-vvv]` output on guest system. Also, make sure your user belongs to _plugdev_ user group by checking `` id `whoami` `` output.

When all set, do: `sudo service udev restart && udevadm control --reload-rules`.

Finally, re-attach the STLink device to WSL by means of _usbipd_.

---

A helpful [article series](https://kleinembedded.com/stm32-without-cubeide-part-1-the-bare-necessities/) this project is born after. 
Repository contains some reference documents that originate from [STMicroelectronics site](https://www.st.com/content/st_com/en.html)

