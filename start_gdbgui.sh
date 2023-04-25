#!/bin/bash

gdbgui -g "gdb-multiarch -q -iex 'set auto-load safe-path $PWD'" build/STBlink.elf