# The Legend of Zelda: Link's Awakening (Game Boy) - gbbolt disassembly

**Open it: <https://gbbolt.lingora.org/linksawakening/>**

A matching disassembly of *The Legend of Zelda: Link's Awakening* (Nintendo, 1993, USA, revision 1.2) for
the original Game Boy, a 512 KiB MBC1 cartridge with battery RAM and 32 banks. It is read with
[gbbolt](https://github.com/gbbolt/gbbolt): code and pseudo-code side by side, each short piece of Python
directly above the few instructions that do it.

**Work in progress.** The ROM rebuilds byte for byte; the code is being named and explained bank by bank.

- **Every bank is its own file** (`src/bank_000.asm` ... `src/bank_01f.asm`). Bank 0 is always mapped;
  the code switches the other banks in with `ld a, N` + `ld [$2100], a` before it calls into them.
- Banks 1-7, $14, $15 and $17-$19 hold code (the game's modes, Link, the rooms, the enemies, characters and
  objects); banks $1B, $1E and $1F the sound engine; the others graphics, maps and text.

## Building

The disassembly rebuilds the original ROM byte for byte. You need
[RGBDS](https://rgbds.gbdev.io) 1.0.1, Python 3.9+ with numpy, and gbbolt next to this folder:

```
git clone https://github.com/gbbolt/gbbolt
git clone https://github.com/gbbolt/linksawakening-gbbolt
cd linksawakening-gbbolt
# put your own ROM here as la.gb (sha1 5ab63def958728933571c3b4f6af54db14f3f8b2)
python ../gbbolt/tools/gbbolt.py
```

The ROM is not part of this repository.
