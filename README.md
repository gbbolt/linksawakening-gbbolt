# The Legend of Zelda: Link's Awakening (Game Boy) - gbbolt disassembly

**Open it: <https://gbbolt.lingora.org/linksawakening/>**

A matching disassembly of *The Legend of Zelda: Link's Awakening* (Nintendo, 1993, USA, revision 1.2) for
the original Game Boy, a 512 KiB MBC1 cartridge with battery RAM and 32 banks. It is read with
[gbbolt](https://github.com/gbbolt/gbbolt): code and pseudo-code side by side, each short piece of Python
directly above the few instructions that do it.

**Complete.** All 3,428 code units are named, explained and given pseudo-code, and every unit sits in a
folder of the code tree; the data banks are split into labelled, described blocks. The ROM rebuilds byte
for byte.

- **Every bank is its own file** (`src/bank_000.asm` ... `src/bank_01f.asm`). Bank 0 is always mapped;
  the code switches the other banks in with `ld a, N` + `ld [$2100], a` (or `call SwitchBank`) before it
  calls into them. Entity types are dispatched through `EntityHandlers` in bank 0, with each type's bank
  in `EntityHandlerBankTable` (bank 3).
- **What the code does:** the game modes (intro, file menu, the world, the ending), Link's movement,
  items and weapons, room loading with its object macros and doors, room events, the dialog engine, the
  inventory, the minimap and the island map, the entity engine with hit detection and damage, every
  enemy, boss, character and object handler (banks 3-7, $15, $18, $19), the final battle against the
  Shadow Nightmare in all its forms (bank $15), the ending and the credits (bank $17), and the sound
  engine (banks $1B, $1E, $1F).
- **Koholint as data a remake can use:** the whole overworld (16 x 16 rooms) and every dungeon,
  cave and house drawn by the game's own room loader, with a card for each of the 767 rooms (tile set,
  sprite set, objects, enemies and characters, warps, chest contents, music). Warps, chests, dialogs,
  rooms, dungeon layouts, entity stats, item tables, object physics and the sound list are also
  downloadable as JSON and CSV.
- **Enemies, bosses and characters:** a card for each entity type with its sprite frames drawn from
  the game's own sprite tables, health, damage to Link, drops, hitbox, physics and option flags, how it
  reacts to each weapon, the rooms it appears in, and for characters their dialogs and trade items.
- **Items and objects:** each item with its inventory icon as the game draws it, what it does with its speed and range tables, the damage table of
  weapons against enemy classes, and the object physics (walls, pits, ledges, bombable walls, hookshot
  targets, liftable objects) with the code that handles each kind.
- **Tile sheets taken apart:** under every tile sheet, the objects the game builds from its tiles, put
  together from the game's own composition data with their flips and palettes: the 16x16 room blocks
  (animated ones in every step), every entity sprite frame, all 119 poses of Link, sprite layouts and
  screens. Each sheet says which of its tiles no object uses, and every object's pieces are
  downloadable as JSON and CSV.
- **Text and screens:** all 640 dialogs decoded and the font, the file menu, name entry, inventory,
  status bar, island map, save menu, and the screen layouts drawn by the game's own tile-map loader.
- **Music and sound effects**, played by the game's own sound engine: 96 music tracks and 163 sound
  effects, each named with the rooms or the code that starts it.
- **The opening**, played by the game's own code on an emulated Game Boy from power-on to the title,
  with its sound.

## Building

The disassembly rebuilds the original ROM byte for byte. You need
[RGBDS](https://rgbds.gbdev.io) 1.0.1, Python 3.9+ with numpy, and gbbolt next to this folder:

```
git clone https://github.com/gbbolt/gbbolt
git clone https://github.com/gbbolt/linksawakening-gbbolt
cd linksawakening-gbbolt
python ../gbbolt/tools/gbbolt.py            # build, verify, write out/site/index.html
```

The build is checked against the SHA1 of the original ROM
(`5ab63def958728933571c3b4f6af54db14f3f8b2`, *Legend of Zelda, The - Link's Awakening (U) (V1.2)*).
No ROM is needed to build it. If you put your own dump next to `game.json` as `la.gb`, it is compared
byte by byte.

## Layout

```
game.json           what gbbolt needs to know about the game
src/game.asm        includes every bank; the ROM is assembled as one unit
src/bank_XXX.asm    the disassembly, one file per ROM bank, with its annotations
src/ram.inc         RAM variables: names, types, descriptions
src/hardware.inc    hardware registers
src/sound.json      the music and sound effects and how the game's sound engine plays them
assets/*.py         asset plugins: the game's own code run on an emulated Game Boy, and the sheets
                    read from the game's tables (assets/_la.py holds the shared readers)
```

## Legal

The Legend of Zelda: Link's Awakening and its code, graphics and music are the property of Nintendo.
This repository contains no ROM. It is a research and documentation project in the tradition of other
community disassemblies; please buy the game.

The annotations, names, pseudo-code, descriptions, plugins and configuration written for this project
are available under the MIT license (see [LICENSE](LICENSE)), as far as they are separable from the
game itself.
