Haxe CHIP-8 Fonset file editor
==============================

This tool provides a simple way to edit fontset file for CHIP-8 emulators.

Fontset file is first 240 bytes in CHIP-8 memory that represents fonts used by intepreter. It contains characters 0-9 A-F in two formats:
  - basic font (4x5 pixels) for standard CHIP-8 instruction set usage
  - super font (8x10 pixels) for more advanced SuperCHIP-8 instruction set usage

This tool was developed to enable easy editing for "CHIP-8 Emu" emulator (https://github.com/AfBu/haxe-chip-8-emulator), but hopefuly it will be useful for others as well.

Licence: MIT
