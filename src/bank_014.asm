; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $014", ROMX[$4000], BANK[$14]

;@ path: world/rooms
;@ The event of each indoor room of the first group (maps $00-$05 and $1A-$1F; 256 bytes, by room
;@ number), copied to wRoomEvent when the room loads: low 5 bits what triggers it, high 3 bits what it
;@ does; 0 = no event.
IndoorRoomEventsA::
	db $00, $00, $21, $a1, $22, $00, $21, $00, $00, $00, $61, $00, $00, $61, $00, $00
	db $00, $c1, $21, $63, $61, $21, $81, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $61, $00, $00, $00, $00, $a1, $00, $66, $c1, $00, $21, $21, $00, $00, $21, $a7
	db $21, $25, $81, $00, $81, $00, $00, $61, $00, $63, $00, $00, $00, $00, $00, $00
	db $00, $81, $00, $21, $61, $c1, $00, $00, $81, $21, $00, $00, $00, $81, $61, $21
	db $00, $61, $2b, $00, $81, $81, $00, $00, $81, $21, $21, $81, $21, $00, $00, $00
	db $21, $00, $21, $29, $c1, $00, $2a, $a9, $00, $81, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $23, $00, $00, $00, $21, $21, $00, $00, $21, $00, $00, $00, $00
	db $21, $87, $21, $21, $21, $21, $00, $21, $00, $00, $21, $00, $00, $00, $00, $00
	db $00, $23, $21, $c1, $2b, $21, $00, $00, $2b, $2c, $21, $61, $21, $00, $21, $21
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $2c, $2c, $2b, $00, $81, $21, $0d, $00, $2b, $00, $2c, $2b, $21, $2b, $00, $21
	db $61, $23, $a1, $81, $45, $c1, $00, $21, $2b, $2b, $21, $21, $00, $00, $00, $00
	db $2b, $21, $21, $21, $00, $00, $21, $21, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: world/rooms
;@ The same for the indoor rooms of the second group (maps $06-$19; 256 bytes).
IndoorRoomEventsB::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $48, $00, $00, $00, $00, $00
	db $81, $61, $6c, $21, $00, $00, $00, $00, $00, $00, $00, $81, $61, $00, $00, $00
	db $61, $00, $00, $00, $67, $00, $00, $00, $c1, $00, $00, $00, $21, $00, $2a, $00
	db $21, $00, $6e, $00, $21, $00, $00, $00, $21, $2b, $21, $00, $00, $61, $81, $c1
	db $00, $8f, $21, $21, $00, $21, $65, $00, $00, $00, $00, $00, $81, $6e, $21, $00
	db $00, $00, $6e, $23, $21, $00, $21, $21, $23, $00, $8e, $21, $00, $00, $a1, $21
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $21
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $21, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $81, $00, $00, $00, $2b, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $21, $21, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $21, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: world/dungeons
;@ The room grid of each dungeon map $00-$0A (64 bytes per map: 8 rows of 8 room numbers, indexed by
;@ wIndoorRoom = row * 8 + column): maps 0-7 the eight dungeons, 8 the Wind Fish's Egg, $0A the caves
;@ that are put together the same way; map 9 has no grid of its own. LoadRoom reads the room number
;@ from here when Link enters a position of the grid.
DungeonLayouts::
	; map 0
	db $00, $00, $00, $00, $00, $18, $19, $00
	db $00, $00, $00, $00, $00, $1a, $1b, $00
	db $00, $00, $00, $00, $00, $00, $02, $00
	db $00, $03, $04, $05, $00, $00, $06, $00
	db $1d, $00, $07, $08, $09, $0a, $0b, $00
	db $1c, $0c, $0d, $0e, $0f, $10, $11, $00
	db $01, $00, $12, $13, $14, $00, $00, $00
	db $00, $15, $16, $17, $00, $00, $00, $00
	; map 1
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $20, $21, $22, $23, $24, $25, $00
	db $00, $00, $26, $00, $00, $27, $00, $00
	db $00, $28, $29, $3a, $3b, $2a, $2b, $00
	db $00, $2c, $00, $3c, $3d, $00, $2d, $00
	db $00, $2e, $00, $3e, $3f, $00, $2f, $00
	db $00, $30, $31, $32, $33, $34, $35, $00
	db $00, $00, $36, $37, $38, $39, $00, $00
	; map 2
	db $40, $41, $42, $43, $00, $aa, $ab, $00
	db $44, $45, $46, $47, $00, $00, $00, $00
	db $48, $49, $4a, $4b, $00, $00, $54, $00
	db $00, $4c, $4d, $00, $00, $55, $56, $57
	db $00, $4e, $00, $00, $00, $00, $58, $00
	db $00, $4f, $50, $00, $00, $00, $59, $00
	db $00, $51, $00, $00, $00, $00, $5a, $00
	db $00, $52, $53, $00, $00, $00, $5b, $5c
	; map 3
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $60, $61, $00, $00, $00
	db $00, $62, $00, $63, $64, $00, $65, $00
	db $ef, $66, $67, $68, $69, $6a, $6b, $00
	db $ff, $6c, $6d, $6e, $6f, $70, $71, $00
	db $7c, $7d, $72, $73, $74, $75, $00, $00
	db $1e, $1f, $76, $77, $78, $79, $00, $00
	db $5e, $5f, $00, $7a, $7b, $00, $00, $00
	; map 4
	db $00, $80, $81, $82, $83, $84, $00, $00
	db $00, $00, $00, $85, $86, $87, $88, $00
	db $00, $89, $8a, $8b, $8c, $8d, $8e, $8f
	db $00, $00, $00, $00, $00, $90, $91, $92
	db $a2, $a3, $00, $93, $94, $95, $96, $00
	db $a4, $a5, $97, $98, $99, $9a, $00, $00
	db $a6, $a7, $00, $9b, $9c, $9d, $00, $00
	db $a8, $a9, $00, $00, $9e, $9f, $a0, $a1
	; map 5
	db $d8, $d9, $da, $db, $dc, $dd, $00, $00
	db $b0, $00, $00, $00, $00, $00, $00, $b1
	db $b2, $b3, $00, $b4, $b5, $00, $b6, $b7
	db $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf
	db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7
	db $00, $c8, $c9, $ca, $cb, $cc, $cd, $00
	db $00, $ce, $cf, $00, $00, $d0, $d1, $00
	db $00, $d2, $d3, $d4, $d5, $d6, $d7, $00
	; map 6
	db $00, $11, $12, $00, $00, $00, $00, $e8
	db $13, $14, $15, $16, $00, $2b, $2c, $f8
	db $17, $18, $19, $1a, $00, $2d, $2e, $00
	db $1b, $1c, $1d, $1e, $00, $00, $00, $00
	db $01, $02, $03, $04, $00, $1f, $20, $00
	db $05, $06, $07, $08, $21, $22, $23, $24
	db $09, $0a, $0b, $0c, $25, $26, $27, $28
	db $0d, $0e, $0f, $10, $00, $29, $2a, $00
	; map 7
	db $60, $61, $00, $30, $31, $00, $62, $63
	db $32, $64, $65, $34, $35, $66, $67, $37
	db $38, $39, $3a, $3b, $3c, $3d, $3e, $3f
	db $00, $40, $41, $42, $43, $44, $45, $00
	db $00, $46, $47, $48, $49, $4a, $4b, $00
	db $4c, $4d, $4e, $4f, $50, $51, $52, $53
	db $54, $55, $56, $57, $58, $59, $5a, $5b
	db $5c, $68, $69, $5d, $5e, $6a, $6b, $5f
	; map 8
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $74, $00, $00, $00, $00
	db $00, $00, $00, $73, $00, $00, $00, $00
	db $00, $00, $00, $71, $00, $00, $00, $00
	db $00, $00, $00, $72, $00, $00, $00, $00
	db $00, $00, $00, $76, $00, $00, $00, $00
	db $00, $00, $00, $75, $00, $00, $00, $00
	db $00, $00, $00, $70, $00, $00, $00, $00
	; map 9
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	; map 10
	db $b6, $b7, $b8, $b9, $85, $86, $fd, $f3
	db $ed, $ee, $ea, $eb, $ec, $87, $f1, $f2
	db $fe, $ef, $ba, $bb, $bc, $8d, $f9, $fa
	db $80, $81, $82, $83, $84, $8c, $88, $8a
	db $90, $91, $92, $00, $8e, $9a, $89, $8b
	db $97, $93, $94, $95, $96, $00, $ab, $ac
	db $98, $7a, $7b, $00, $e6, $e7, $00, $bd
	db $00, $7c, $7d, $7e, $f6, $f7, $de, $df
;@ path: world/dungeons
;@ Eagle's Tower's second room grid (64 bytes, same format as DungeonLayouts), used for map 6 once
;@ wDungeon7Flags bit 2 is set - after the top floor has been brought down.
EaglesTowerLayout2::
	db $00, $11, $12, $00, $00, $00, $00, $e8
	db $13, $14, $15, $16, $00, $00, $00, $f8
	db $17, $18, $19, $1a, $00, $00, $00, $00
	db $1b, $1c, $1d, $1e, $00, $00, $00, $00
	db $01, $02, $03, $04, $00, $1f, $20, $00
	db $05, $06, $07, $08, $21, $2b, $2c, $24
	db $09, $0a, $0b, $0c, $25, $2d, $2e, $28
	db $0d, $0e, $0f, $10, $00, $29, $2a, $00
;@ path: world/rooms
;@ The info byte of each overworld room (256 bytes, by room number; GetRoomInfo with page 0): for a
;@ room with a chest, what the chest holds - $00-$0B the items (Power Bracelet, shield, bow, hookshot,
;@ Fire Rod, Pegasus Boots, Ocarina, feather, shovel, magic powder, bombs, sword), $0C-$15 counted items,
;@ $16-$1A dungeon items, $1B-$1F rupees (50, 20, 100, 200, 500); other values mark rooms of special kinds.
RoomInfoOverworld::
	db $00, $00, $00, $00, $1b, $00, $00, $1b, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $1b, $1d, $00, $00, $00, $20, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $1b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $1c, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00, $00
	db $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $1b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: world/rooms
;@ The info byte of each indoor room of the first group (256 bytes; GetRoomInfo with page 1), same
;@ values as RoomInfoOverworld.
RoomInfoIndoorA::
	db $00, $00, $00, $00, $00, $00, $00, $00, $19, $00, $18, $00, $20, $1c, $1a, $00
	db $00, $00, $00, $1a, $16, $17, $1a, $00, $00, $00, $00, $00, $00, $07, $00, $00
	db $00, $1c, $1a, $00, $00, $00, $18, $19, $00, $00, $00, $00, $00, $00, $16, $00
	db $00, $00, $00, $00, $00, $00, $1b, $17, $1a, $1a, $00, $00, $00, $00, $00, $00
	db $00, $00, $17, $00, $16, $00, $05, $19, $00, $00, $00, $00, $1b, $00, $18, $22
	db $1e, $1a, $00, $1a, $1a, $1a, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $0c, $00, $00, $00, $00, $1a, $00, $00, $1a, $1a, $16, $00, $00, $22, $1b, $00
	db $00, $1a, $00, $00, $00, $1b, $19, $00, $17, $18, $00, $1a, $00, $00, $00, $00
	db $00, $00, $00, $18, $00, $00, $19, $00, $1b, $00, $00, $00, $00, $00, $1b, $1a
	db $00, $00, $00, $00, $00, $00, $21, $1a, $00, $00, $00, $16, $00, $00, $17, $00
	db $1e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $1d, $1e, $00, $17, $00, $00, $19, $00, $00, $18, $00, $00, $00, $00, $1a, $00
	db $16, $00, $00, $00, $00, $00, $00, $00, $00, $1d, $00, $00, $00, $00, $00, $1b
	db $00, $1b, $00, $00, $00, $00, $00, $1b, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1e, $20, $00, $00
;@ path: world/rooms
;@ The info byte of each indoor room of the second group (256 bytes; GetRoomInfo with page 2), same
;@ values as RoomInfoOverworld.
RoomInfoIndoorB::
	db $00, $20, $00, $00, $1a, $00, $00, $00, $00, $18, $00, $00, $00, $00, $00, $00
	db $00, $17, $16, $00, $00, $00, $00, $00, $00, $00, $01, $00, $1c, $00, $00, $00
	db $1d, $00, $00, $00, $19, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $19, $00, $00, $1c, $00, $04, $00, $00, $1b, $00, $00, $1a, $00, $00
	db $1a, $00, $00, $00, $00, $00, $1a, $00, $00, $00, $00, $00, $00, $1c, $00, $16
	db $00, $00, $00, $00, $00, $1b, $00, $00, $00, $22, $00, $00, $17, $00, $00, $18
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $22, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $00, $1c, $00, $00, $1c, $1b
	db $00, $00, $00, $1b, $00, $00, $00, $00, $00, $00, $1b, $1b, $00, $1b, $06, $1d
	db $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00, $00, $00, $1b, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $1b, $00, $00, $00, $00, $00, $00
	db $00, $00, $1c, $00, $1b, $00, $08, $00, $00, $00, $00, $00, $20, $00, $00, $00
;@ path: unused
;@ Free space in bank $14 between the room tables and the code (2048 bytes of $FF).
Bank14FreeSpace1::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def PlaceIndoorWalls(template: a)
;@ path: world/rooms
;@ Builds the walls of an indoor room from wall template `template` (the high nibble of the room data's
;@ second byte): runs the template's entry of IndoorWallTemplates.
;@ test: skip jump table
PlaceIndoorWalls::
;> return IndoorWallTemplates[template]()
	rst $00

;@ path: world/rooms
;@ The 16 wall templates of indoor rooms (dw code addresses): 0-8 place walls with PlaceObjectShape,
;@ 9-15 none.
IndoorWallTemplates::
	dw IndoorWalls0, IndoorWalls1, IndoorWalls2, IndoorWalls3
	dw IndoorWalls4, IndoorWalls5, IndoorWalls6, IndoorWalls7
	dw IndoorWalls8, IndoorWallsNone, IndoorWallsNone, IndoorWallsNone
	dw IndoorWallsNone, IndoorWallsNone, IndoorWallsNone, IndoorWallsNone

;@ def IndoorWalls0()
;@ path: world/rooms
;@ Wall template 0: walls along the top, bottom, left and right sides of the room (32 objects,
;@ IndoorWalls0Places / IndoorWalls0Objects).
;@ test: skip jumps into bank 0
IndoorWalls0::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls0Places, IndoorWalls0Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls0Places
	ld de, IndoorWalls0Objects
	jp PlaceObjectShape


;@ def IndoorWalls1()
;@ path: world/rooms
;@ Wall template 1: walls along the bottom, left and right sides of the room (24 objects,
;@ IndoorWalls1Places / IndoorWalls1Objects).
;@ test: skip jumps into bank 0
IndoorWalls1::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls1Places, IndoorWalls1Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls1Places
	ld de, IndoorWalls1Objects
	jp PlaceObjectShape


;@ def IndoorWalls2()
;@ path: world/rooms
;@ Wall template 2: walls along the top, bottom and left sides of the room (26 objects,
;@ IndoorWalls2Places / IndoorWalls2Objects).
;@ test: skip jumps into bank 0
IndoorWalls2::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls2Places, IndoorWalls2Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls2Places
	ld de, IndoorWalls2Objects
	jp PlaceObjectShape


;@ def IndoorWalls3()
;@ path: world/rooms
;@ Wall template 3: walls along the top, left and right sides of the room (24 objects,
;@ IndoorWalls3Places / IndoorWalls3Objects).
;@ test: skip jumps into bank 0
IndoorWalls3::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls3Places, IndoorWalls3Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls3Places
	ld de, IndoorWalls3Objects
	jp PlaceObjectShape


;@ def IndoorWalls4()
;@ path: world/rooms
;@ Wall template 4: walls along the top, bottom and right sides of the room (26 objects,
;@ IndoorWalls4Places / IndoorWalls4Objects).
;@ test: skip jumps into bank 0
IndoorWalls4::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls4Places, IndoorWalls4Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls4Places
	ld de, IndoorWalls4Objects
	jp PlaceObjectShape


;@ def IndoorWalls5()
;@ path: world/rooms
;@ Wall template 5: walls along the bottom and left sides of the room (17 objects,
;@ IndoorWalls5Places / IndoorWalls5Objects).
;@ test: skip jumps into bank 0
IndoorWalls5::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls5Places, IndoorWalls5Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls5Places
	ld de, IndoorWalls5Objects
	jp PlaceObjectShape


;@ def IndoorWalls6()
;@ path: world/rooms
;@ Wall template 6: walls along the bottom and right sides of the room (17 objects,
;@ IndoorWalls6Places / IndoorWalls6Objects).
;@ test: skip jumps into bank 0
IndoorWalls6::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls6Places, IndoorWalls6Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls6Places
	ld de, IndoorWalls6Objects
	jp PlaceObjectShape


;@ def IndoorWalls7()
;@ path: world/rooms
;@ Wall template 7: walls along the top and right sides of the room (17 objects,
;@ IndoorWalls7Places / IndoorWalls7Objects).
;@ test: skip jumps into bank 0
IndoorWalls7::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls7Places, IndoorWalls7Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls7Places
	ld de, IndoorWalls7Objects
	jp PlaceObjectShape


;@ def IndoorWalls8()
;@ path: world/rooms
;@ Wall template 8: walls along the top and left sides of the room (17 objects,
;@ IndoorWalls8Places / IndoorWalls8Objects).
;@ test: skip jumps into bank 0
IndoorWalls8::
;> return PlaceObjectShape(wRoomObjects, IndoorWalls8Places, IndoorWalls8Objects)
	push bc
	ld hl, wRoomObjects
	ld bc, IndoorWalls8Places
	ld de, IndoorWalls8Objects
	jp PlaceObjectShape


;@ def IndoorWallsNone()
;@ path: world/rooms
;@ Wall templates 9-15: no walls.
IndoorWallsNone::
;> return
	ret


;@ path: world/rooms
;@ Wall template 0: the places in wRoomObjects (33 bytes, row * $10 + column; $FF ends).
IndoorWalls0Places::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $19, $20, $29, $30, $39
	db $40, $49, $50, $59, $60, $69, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79
	db $ff

;@ path: world/rooms
;@ Wall template 0: the wall object for each place (32 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls0Objects::
	db $25, $21, $21, $21, $21, $21, $21, $21, $21, $26, $23, $24, $23, $24, $23, $24
	db $23, $24, $23, $24, $23, $24, $27, $22, $22, $22, $22, $22, $22, $22, $22, $28

;@ path: world/rooms
;@ Wall template 1: the places in wRoomObjects (25 bytes, row * $10 + column; $FF ends).
IndoorWalls1Places::
	db $00, $09, $10, $19, $20, $29, $30, $39, $40, $49, $50, $59, $60, $69, $70, $71
	db $72, $73, $74, $75, $76, $77, $78, $79, $ff

;@ path: world/rooms
;@ Wall template 1: the wall object for each place (24 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls1Objects::
	db $23, $24, $23, $24, $23, $24, $23, $24, $23, $24, $23, $24, $23, $24, $27, $22
	db $22, $22, $22, $22, $22, $22, $22, $28

;@ path: world/rooms
;@ Wall template 2: the places in wRoomObjects (27 bytes, row * $10 + column; $FF ends).
IndoorWalls2Places::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $20, $30, $40, $50, $60
	db $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $ff

;@ path: world/rooms
;@ Wall template 2: the wall object for each place (26 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls2Objects::
	db $25, $21, $21, $21, $21, $21, $21, $21, $21, $21, $23, $23, $23, $23, $23, $23
	db $27, $22, $22, $22, $22, $22, $22, $22, $22, $22

;@ path: world/rooms
;@ Wall template 3: the places in wRoomObjects (25 bytes, row * $10 + column; $FF ends).
IndoorWalls3Places::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $19, $20, $29, $30, $39
	db $40, $49, $50, $59, $60, $69, $70, $79, $ff
;@ path: world/rooms
;@ Wall template 3: the wall object for each place (24 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls3Objects::
	db $25, $21, $21, $21, $21, $21, $21, $21, $21, $26, $23, $24, $23, $24, $23, $24
	db $23, $24, $23, $24, $23, $24, $23, $24

;@ path: world/rooms
;@ Wall template 4: the places in wRoomObjects (27 bytes, row * $10 + column; $FF ends).
IndoorWalls4Places::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $19, $29, $39, $49, $59, $69
	db $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $ff

;@ path: world/rooms
;@ Wall template 4: the wall object for each place (26 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls4Objects::
	db $21, $21, $21, $21, $21, $21, $21, $21, $21, $26, $24, $24, $24, $24, $24, $24
	db $22, $22, $22, $22, $22, $22, $22, $22, $22, $28

;@ path: world/rooms
;@ Wall template 5: the places in wRoomObjects (18 bytes, row * $10 + column; $FF ends).
IndoorWalls5Places::
	db $00, $10, $20, $30, $40, $50, $60, $70, $71, $72, $73, $74, $75, $76, $77, $78
	db $79, $ff

;@ path: world/rooms
;@ Wall template 5: the wall object for each place (17 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls5Objects::
	db $23, $23, $23, $23, $23, $23, $23, $27, $22, $22, $22, $22, $22, $22, $22, $22
	db $22
;@ path: world/rooms
;@ Wall template 6: the places in wRoomObjects (18 bytes, row * $10 + column; $FF ends).
IndoorWalls6Places::
	db $09, $19, $29, $39, $49, $59, $69, $70, $71, $72, $73, $74, $75, $76, $77, $78
	db $79, $ff

;@ path: world/rooms
;@ Wall template 6: the wall object for each place (17 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls6Objects::
	db $24, $24, $24, $24, $24, $24, $24, $22, $22, $22, $22, $22, $22, $22, $22, $22
	db $28

;@ path: world/rooms
;@ Wall template 7: the places in wRoomObjects (18 bytes, row * $10 + column; $FF ends).
IndoorWalls7Places::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $19, $29, $39, $49, $59, $69
	db $79, $ff

;@ path: world/rooms
;@ Wall template 7: the wall object for each place (17 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls7Objects::
	db $21, $21, $21, $21, $21, $21, $21, $21, $21, $26, $24, $24, $24, $24, $24, $24
	db $24

;@ path: world/rooms
;@ Wall template 8: the places in wRoomObjects (18 bytes, row * $10 + column; $FF ends).
IndoorWalls8Places::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $20, $30, $40, $50, $60
	db $70, $ff

;@ path: world/rooms
;@ Wall template 8: the wall object for each place (17 bytes: $21 top, $22 bottom, $23 left, $24
;@ right, $25-$28 the corners top left, top right, bottom left, bottom right).
IndoorWalls8Objects::
	db $25, $21, $21, $21, $21, $21, $21, $21, $21, $21, $23, $23, $23, $23, $23, $23
	db $23

;@ path: world/timers
;@ Full health for 3-14 heart containers (12 bytes, 8 per heart), read at wMaxHearts - 3.
FullHealthByMaxHearts::
	db $18, $20, $28, $30, $38, $40, $48, $50, $58, $60, $68, $70

;@ def UpdateWorldTimers(b: b)
;@ path: world/timers
;@ Per-frame bookkeeping of the game world (game mode $0B, before the step dispatcher): the compass chime
;@ (sound $1B when wCompassChimeDelay runs out), wClinkTimer, the music restart (wRestartMusicTimer: the
;@ last track again), wOverworldRoom, the sound of the waves in the beach rooms $F0-$F5, wHealthIsFull,
;@ the cycle wNoiseSfxCycle (0-$19), the counter mem $DB47 (+1 every 64 frames, up to $FF), and the
;@ electric shock: while wElectricShockTimer runs the palettes are normal, and in its first $20 frames
;@ the screen shakes sideways, flashes ($CC / $0C) and Link is held.
;@ test: wCurrentBank = $14
;@ test: wNoiseSfxCycle = rand(0, 0x19)
;@ test: b = 0
UpdateWorldTimers::
;> if wCompassChimeDelay:
	ld a, [wCompassChimeDelay]
	and a
	jr z, .clink
;>     wCompassChimeDelay -= 1
	dec a
	ld [wCompassChimeDelay], a
;>     if wCompassChimeDelay == 0:
	jr nz, .clink
;>         hWaveSfx = 0x1B
	ld a, $1b
	ldh [hWaveSfx], a
.clink
;> if wClinkTimer:
	ld a, [wClinkTimer]
	and a
	jr z, .music
;>     wClinkTimer -= 1
	dec a
	ld [wClinkTimer], a
.music
;> if wRestartMusicTimer:
	ld a, [wRestartMusicTimer]
	and a
	jr z, .room
;>     wRestartMusicTimer -= 1
	dec a
	ld [wRestartMusicTimer], a
;>     if wRestartMusicTimer == 0:
	jr nz, .room
;>         wMusicTrackToPlay = hLastMusicTrack
	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a
.room
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr nz, .health
;>     wOverworldRoom = hMapRoom
	ldh a, [hMapRoom]
	ld [wOverworldRoom], a
;>     if 0xF0 <= hMapRoom < 0xF6:
	ldh a, [hMapRoom]
	cp $f0
	jr c, .health
	cp $f6
	jr nc, .health
;>         waves = u8(wSeaWavesSoundTimer + 1)
	ld a, [wSeaWavesSoundTimer]
	inc a
;>         if waves == 0xA0:
	cp $a0
	jr nz, .storeWaves
;>             hNoiseSfx = 0x0F
	ld a, $0f
	ldh [hNoiseSfx], a
;>             waves = 0
	xor a
.storeWaves
;>         wSeaWavesSoundTimer = waves
	ld [wSeaWavesSoundTimer], a
.health
;>@h wHealthIsFull = 1 if wHealth == mem[FullHealthByMaxHearts + (wMaxHearts - 3)] else 0   # (d is taken from b, 0 here)
	ld a, [wMaxHearts]
	ld e, a
	ld d, b
	ld hl, FullHealthByMaxHearts - 3
	add hl, de
	ld a, [wHealth]
;=@h
	cp [hl]
	ld a, $00
	jr nz, .full
	inc a
.full
;=@h
	ld [wHealthIsFull], a
;> wNoiseSfxCycle = (wNoiseSfxCycle + 1) % 0x1A
	ld a, [wNoiseSfxCycle]
	inc a
	cp $1a
	jr nz, .cycle
	xor a
.cycle
	ld [wNoiseSfxCycle], a
;> if hFrameCounter & 0x3F == 0 and mem[0xDB47] != 0xFF:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .shock
	ld a, [$db47]
	cp $ff
	jr z, .shock
;>     mem[0xDB47] += 1
	inc a
	ld [$db47], a
.shock
;> if wElectricShockTimer == 0:
	ld a, [wElectricShockTimer]
	and a
;>     return
	ret z
;> wBGPalette = 0xE4
	ld a, $e4
	ld [wBGPalette], a
;> wOBJ1Palette = 0xE4
	ld [wOBJ1Palette], a
;> wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;> wElectricShockTimer -= 1
	ld hl, wElectricShockTimer
	dec [hl]
;> if wElectricShockTimer == 0:
;>     return
	ret z
;> wScreenShakeX = b                            # (b: 0 when the caller runs it)
	ld a, [hl]
	ld hl, wScreenShakeX
	ld [hl], b
;> if wElectricShockTimer >= 0x20:
	cp $20
	jr c, .done
;>@sx     wScreenShakeX = ((wElectricShockTimer << 1) & 4) - 2
	rla
	nop
	nop
	nop
	and $04
	sub $02
;=@sx
	ld [wScreenShakeX], a
;>     wBGPalette = 0xCC
	ld a, $cc
	ld [wBGPalette], a
;>     wOBJ1Palette = 0xCC
	ld [wOBJ1Palette], a
;>     wOBJ0Palette = 0x0C
	ld a, $0c
	ld [wOBJ0Palette], a
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
.done
	ret


;@ path: world/torches
;@ Background palettes of a room with torches by darkness (32 bytes, read at wRoomDarknessShown +
;@ (hFrameCounter & 3), so neighbouring levels blend): levels 0-$0C go from normal ($E4) to black ($FF).
RoomDarknessPalettes::
	db $e4, $e4, $e4, $e4, $f9, $f9, $f9, $f9, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff
	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $40, $40, $40, $40, $00, $00, $00, $00
;@ path: world/torches
;@ For each Link motion state 0-$0A (11 bytes): nonzero where the torch room's palette is left alone
;@ (states 3 and 4, the warps).
DarknessPausedMotions::
	db $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00

;@ def UpdateRoomDarkness()
;@ path: world/torches
;@ In normal play (step 7, fade done) in a room with torches: sets the background palette from
;@ RoomDarknessPalettes by wRoomDarknessShown (also kept in wRoomDarkPalette) and every second frame moves
;@ wRoomDarknessShown one step towards the target - wRoomDarkness, or 0 (bright) while the inventory
;@ covers the screen (wWindowY 0) or a dialogue or the wave effect runs. Not during the motion states
;@ of DarknessPausedMotions.
UpdateRoomDarkness::
;> if wGameplaySubtype != 7:
	ld a, [wGameplaySubtype]
	cp $07
;>     return
	ret nz
;> if wTransitionSequenceCounter != 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	ret nz
;> if not wRoomHasTorches:
	ld a, [wRoomHasTorches]
	and a
;>     return
	jr z, .done
;> hMultiPurpose0 = 0
	xor a
	ldh [hMultiPurpose0], a
	ld d, a
;>@pm if mem[DarknessPausedMotions + wLinkMotionState]:
	ld a, [wLinkMotionState]
	ld e, a
	ld hl, DarknessPausedMotions
	add hl, de
	ld a, [hl]
	and a
;=@pm
	jr nz, .done
;>     return
;>@w if wWindowY != 0 and not (wDialogState or wTransitionGfx):
	ld a, [wWindowY]
	cp $00
	jr z, .palette
	ld hl, wTransitionGfx
	ld a, [wDialogState]
	or [hl]
;=@w
	jr nz, .palette
;>     hMultiPurpose0 = wRoomDarkness
	ld a, [wRoomDarkness]
	ldh [hMultiPurpose0], a
.palette
;>@bp wBGPalette = mem[RoomDarknessPalettes + (wRoomDarknessShown + (hFrameCounter & 3))]
	ld a, [wRoomDarknessShown]
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	add e
	ld e, a
;=@bp
	ld hl, RoomDarknessPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wRoomDarkPalette = wBGPalette
	ld [wRoomDarkPalette], a
;>@c if hFrameCounter & 1 == 0 and hMultiPurpose0 != wRoomDarknessShown:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .done
	ldh a, [hMultiPurpose0]
	ld hl, wRoomDarknessShown
	sub [hl]
;=@c
	jr z, .done
;>     wRoomDarknessShown += 1 if hMultiPurpose0 > wRoomDarknessShown else -1
	and $80
	jr nz, .down
	inc [hl]
	inc [hl]
.down
	dec [hl]
.done
	ret


;@ def UpdateEntityTimers(slot: bc)
;@ path: entity/timers
;@ Counts the timers of entity `slot` down by one where they are not 0: wEntityTimer, wEntityTimer1,
;@ wEntityTimer2, wEntityDyingTimer, the drop timer (every 4th frame) and the flash timer, whose bit 2
;@ selects the flashing palette (hActiveEntityFlipAttribute = $10). Nothing counts on the world map (mode
;@ 7) or while a room transition, the inventory, a dialogue or an ocarina song runs; the flash is then
;@ off. Also clears hWallCheckOnly and hActiveEntityTileOffset.
;@ test: slot = rand(0, 15)
UpdateEntityTimers::
;> hWallCheckOnly = 0
	xor a
	ldh [hWallCheckOnly], a
;> hActiveEntityTileOffset = 0
	ldh [hActiveEntityTileOffset], a
;>@p if wGameplayType == 7 or wRoomTransitionState or wInventoryAppearing or wDialogState or wOcarinaSongState:
	ld a, [wGameplayType]
	cp $07
	jr z, .paused
	ld a, [wRoomTransitionState]
	ld hl, wInventoryAppearing
	or [hl]
;=@p
	ld hl, wDialogState
	or [hl]
	ld hl, wOcarinaSongState
	or [hl]
	jr nz, .paused
;>@p1     hActiveEntityFlipAttribute = 0
;>@p2     return
;> if GetEntityTimer(slot):
	call GetEntityTimer
	jr z, .timer1
;>     wEntityTimer[slot] -= 1
	dec [hl]
.timer1
;> if GetEntityTimer1(slot):
	call GetEntityTimer1
	jr z, .timer2
;>     wEntityTimer1[slot] -= 1
	dec [hl]
.timer2
;> if wEntityTimer2[slot]:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .dying
;>     wEntityTimer2[slot] -= 1
	dec [hl]
.dying
;> if wEntityDyingTimer[slot]:
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .drop
;>     wEntityDyingTimer[slot] -= 1
	dec [hl]
.drop
;> if hFrameCounter & 3 == 0 and GetEntityDropTimer(slot):
	ldh a, [hFrameCounter]
	and $03
	jr nz, .flash
	call GetEntityDropTimer
	jr z, .flash
;>     wEntityDropTimer[slot] -= 1
	dec [hl]
.flash
;> flash = wEntityFlashTimer[slot]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
;> if flash:
	and a
	jr z, .attr
;>     wEntityFlashTimer[slot] -= 1
	dec [hl]
.attr
;> hActiveEntityFlipAttribute = (flash << 2) & 0x10
	sla a
	sla a
	and $10
	ldh [hActiveEntityFlipAttribute], a
	ret
.paused
;=@p1
	xor a
	ldh [hActiveEntityFlipAttribute], a
;=@p2
	ret


;@ path: world/dungeons
;@ The entrance of each dungeon map 0-8 (9 records of 5 bytes, the format of a warp: kind 1 = indoors,
;@ map, room, x, y): where the restart point is put when Link enters a dungeon, and where the wave warp
;@ ends inside one (EndWaveWarp).
DungeonEntrances::
	; map 0
	db $01, $00, $17, $50, $7c
	; map 1
	db $01, $01, $36, $50, $7c
	; map 2
	db $01, $02, $52, $50, $7c
	; map 3
	db $01, $03, $7a, $50, $7c
	; map 4
	db $01, $04, $a1, $50, $7c
	; map 5
	db $01, $05, $d4, $50, $7c
	; map 6
	db $01, $06, $0e, $50, $7c
	; map 7
	db $01, $07, $5d, $50, $7c
	; map 8
	db $01, $08, $70, $50, $7c

;@ path: world/dungeons
;@ The entrance's place in the room grid of each dungeon map 0-8 (9 bytes, the wIndoorRoom value),
;@ stored with the restart point.
DungeonEntranceCells::
	db $3b, $3a, $39, $3b, $3f, $3b, $39, $3b, $3b

;@ def EndWaveWarp()
;@ path: world/warps
;@ Called when the full-screen wave effect has run: sets up the warp that follows it (motion state 3; mem
;@ $D474 = 1 makes the arrival use the wave effect too). In a dungeon (indoor maps 0-9) the warp leads to
;@ the dungeon's entrance (DungeonEntrances); elsewhere to overworld room $45 at x $38, y $60.
EndWaveWarp::
;> mem[0xD474] = 1
	ld a, $01
	ld [$d474], a
;> wLinkMotionState = 3
	ld a, $03
	ld [wLinkMotionState], a
;> if wIsIndoor and hMapId < 0x0A:
	ld a, [wIsIndoor]
	and a
	jr z, .overworld
	ldh a, [hMapId]
	cp $0a
	jr nc, .overworld
;>@e     entry = DungeonEntrances + 5 * hMapId
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
;=@e
	ld hl, DungeonEntrances
	add hl, de
;>@c     copy(addr(wWarpType), entry, 5)
	ld e, $05
	ld bc, wWarpType
.copy
	ld a, [hli]
	ld [bc], a
	inc bc
	dec e
;=@c
	jr nz, .copy
;>     return
	ret
.overworld
;> wWarpType = 0
	xor a
	ld [wWarpType], a
;> wWarpMap = 0
	ld [wWarpMap], a
;> wWarpRoom = 0x45
	ld a, $45
	ld [wWarpRoom], a
;> wWarpDestX = 0x38
	ld a, $38
	ld [wWarpDestX], a
;> hLinkX = 0x38
	ldh [hLinkX], a
;> wWarpDestY = 0x60
	ld a, $60
	ld [wWarpDestY], a
;> hLinkY = 0x60
	ldh [hLinkY], a
;> wWarpDestPosition = 0x53
	ld a, $53
	ld [wWarpDestPosition], a
	ret


;@ path: world/warps
;@ Background (and OBJ1) palettes of the wave effect, types 1 and 2 (16 bytes, by the effect's step):
;@ the screen fades to white.
WaveBGPalettes::
	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $40, $40, $40, $40, $00, $00, $00, $00
;@ path: world/warps
;@ OBJ0 palettes of the wave effect, types 1 and 2 (16 bytes).
WaveOBJ0Palettes::
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00
;@ path: world/warps
;@ Background (and OBJ1) palettes of the wave effect type 3 (16 bytes): the screen fades in from white.
WaveBGPalettes3::
	db $00, $00, $00, $00, $40, $40, $40, $40, $94, $94, $94, $94, $e4, $e4, $e4, $e4
;@ path: world/warps
;@ OBJ0 palettes of the wave effect type 3 (16 bytes).
WaveOBJ0Palettes3::
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c
;@ path: world/warps
;@ Line offsets of the wave effect (8 strengths of 32 signed bytes, 256 bytes): the x scroll of a line is
;@ shifted by entry ((phase + line) & $1F) of the row for the current strength.
WarpWaveLineOffsets::
	; strength 0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	; strength 1
	db $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00
	db $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00
	; strength 2
	db $00, $00, $00, $00, $01, $01, $02, $02, $02, $02, $02, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $ff, $ff, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $00, $00, $00
	; strength 3
	db $00, $01, $01, $02, $02, $02, $03, $03, $03, $03, $03, $02, $02, $02, $01, $00
	db $00, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fd, $fd, $fe, $fe, $fe, $ff, $00
	; strength 4
	db $00, $02, $02, $03, $03, $03, $04, $04, $04, $04, $04, $03, $03, $03, $02, $02
	db $00, $fe, $fe, $fd, $fd, $fd, $fc, $fc, $fc, $fc, $fc, $fd, $fd, $fd, $fe, $fe
	; strength 5
	db $00, $01, $01, $02, $02, $02, $03, $03, $03, $03, $03, $02, $02, $02, $01, $00
	db $00, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fd, $fd, $fe, $fe, $fe, $ff, $00
	; strength 6
	db $00, $00, $00, $00, $01, $01, $02, $02, $02, $02, $02, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $ff, $ff, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $00, $00, $00
	; strength 7
	db $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00
	db $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00

;@ def ReleaseEntitiesUnderObject()
;@ path: link/lift
;@ After Link has lifted a room object: an entity hidden under it (status 5, physics flag bit 5,
;@ wEntityPrivate3 = 2) within 8 pixels of the object's square (hBGPosX + 8, hBGPosY + $10) comes out:
;@ drop timer $80, wEntityPrivate3 = 0, wEntityTimer1 = $18.
ReleaseEntitiesUnderObject::
;>@l for slot in range(15, -1, -1):
	ld e, $0f
	ld d, $00
.loop
;>@c     if wEntityStatus[slot] == 5 and wEntityPhysicsFlags[slot] & 0x20 and wEntityPrivate3[slot] == 2 and (hBGPosX + 0x10 - wEntityX[slot]) & 0xFF < 0x10 and (hBGPosY + 0x18 - wEntityY[slot]) & 0xFF < 0x10:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, .next
	ld hl, wEntityPhysicsFlags
;=@c
	add hl, de
	ld a, [hl]
	and $20
	jr z, .next
	ld hl, wEntityPrivate3
	add hl, de
;=@c
	ld a, [hl]
	cp $02
	jr nz, .next
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
;=@c
	add $08
	sub [hl]
	add $08
	cp $10
	jr nc, .next
	ld hl, wEntityY
;=@c
	add hl, de
	ldh a, [hBGPosY]
	add $10
	sub [hl]
	add $08
	cp $10
;=@c
	jr nc, .next
;>         wEntityDropTimer[slot] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
;>         wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], d
;>         wEntityTimer1[slot] = 0x18
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $18
.next
;=@l
	dec e
	ld a, e
	cp $ff
	jr nz, .loop
	ret


;@ path: world/signs
;@ The text of the sign in each overworld room (256 bytes, by room number): dialogue $100 + value
;@ (value $83: dialogue $083); $A9 becomes $AF once the ocarina song flag bit 0 is set.
OverworldSignTexts::
	db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
	db $0c, $b6, $0c, $0c, $0c, $0c, $a3, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
	db $10, $10, $10, $10, $10, $b5, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $a5, $10, $a8, $10, $10, $b7, $b4, $10, $10, $10, $10, $10, $10, $10, $10, $a1
	db $08, $08, $08, $08, $10, $b0, $10, $10, $10, $10, $10, $83, $04, $04, $04, $04
	db $a6, $08, $08, $08, $10, $10, $10, $10, $10, $10, $10, $10, $04, $bc, $04, $04
	db $08, $08, $a6, $08, $10, $b3, $10, $10, $10, $10, $10, $10, $04, $04, $04, $04
	db $08, $08, $08, $08, $b8, $10, $10, $10, $10, $10, $10, $10, $04, $04, $04, $04
	db $c4, $10, $0a, $0a, $10, $10, $10, $10, $10, $fc, $9d, $10, $10, $10, $10, $bd
	db $a0, $10, $0a, $0a, $a2, $10, $10, $10, $fb, $10, $10, $10, $10, $10, $10, $10
	db $0a, $0a, $0a, $0a, $83, $10, $10, $10, $ba, $10, $b1, $10, $10, $10, $10, $10
	db $0a, $0a, $0a, $83, $a9, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $a4, $10, $10, $10, $af, $af, $b9, $10, $10, $10, $10, $b2, $0b, $0b, $10, $be
	db $10, $10, $10, $10, $af, $af, $f9, $fa, $10, $10, $bb, $db, $0b, $0b, $10, $10
	db $10, $c3, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $9e, $10, $10
;@ path: npc/bowwow
;@ For each entity type $00-$EE (239 bytes): 1 if BowWow eats it, else 0 (GetEntityTypeByte14).
BowWowEdibleTypes::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $01, $01
	db $00, $00, $00, $00, $01, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
	db $00, $01, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $00, $00, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00
	db $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $01, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ path: link/carry
;@ X speed of a thrown object by Link's direction (16 bytes, 4 directions each: top view, top view for
;@ entity type 2, side view, side view for entity type 2), read at hLinkDirection + offset.
ThrowSpeedX::
	db $30, $d0, $00, $00, $18, $e8, $00, $00, $30, $d0, $00, $00, $18, $e8, $00, $00

;@ path: link/carry
;@ Y speed of a thrown object, same layout as ThrowSpeedX (16 bytes).
ThrowSpeedY::
	db $00, $00, $d0, $30, $00, $00, $e8, $18, $f4, $f4, $d0, $00, $f8, $f8, $e8, $00

;@ path: link/carry
;@ Height speed of a thrown object, same layout as ThrowSpeedX (16 bytes).
ThrowSpeedZ::
	db $04, $04, $04, $04, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00

;@ path: link/carry
;@ The direction a thrown entity of type $98 gets, by Link's direction (4 bytes).
ThrowDirections::
	db $02, $06, $00, $04

;@ def CarriedEntityStep(slot: bc)
;@ path: link/carry
;@ Runs for the entity Link holds over his head. During a room transition or while Link falls (motion
;@ state 6) it is let go at once (ThrowCarriedEntity; not entity type $A8) and stops. Otherwise, after the
;@ pause in mem $C5AE, Link throws it when he presses the button of the Power Bracelet (item 3; for
;@ entity type 2, a bomb, the bomb item 2) - A or B, or either when neither button holds that item. The
;@ throw remembers Link's direction (mem $C5D0 + slot) and plays the sound 8.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $14
;@ test: hLinkDirection = rand(0, 3)
CarriedEntityStep::
;> if wRoomTransitionState or wLinkMotionState == 6:
	ld a, [wRoomTransitionState]
	and a
	jr nz, .drop
	ld a, [wLinkMotionState]
	cp $06
	jr nz, .normal
.drop
;>     if hActiveEntityType != 0xA8:
	ldh a, [hActiveEntityType]
	cp $a8
	jr z, .normal
;>         ThrowCarriedEntity(slot)
	call ThrowCarriedEntity
;>         return ClearEntitySpeed(slot)
	jp ClearEntitySpeed
.normal
;> if mem[0xC5AE]:
	ld a, [$c5ae]
	and a
	jr z, .carrying
;>     mem[0xC5AE] -= 1
	dec a
	ld [$c5ae], a
;>     return
	ret
.carrying
;> if wIsCarryingLiftedObject != 1:
	ld a, [wIsCarryingLiftedObject]
	cp $01
;>     return
	jp nz, ThrowCarriedEntity.done
;> item = 2 if hActiveEntityType == 2 else 3
	ld d, $03
	ldh a, [hActiveEntityType]
	cp $02
	jr nz, .buttons
	ld d, $02
.buttons
;>@b buttons = 0x20 if wItemB == item else 0x10 if wItemA == item else 0x30
	ld e, $10
	ld a, [wItemB]
	cp d
	jr nz, .itemA
	sla e
	jr .press
.itemA
;=@b
	ld a, [wItemA]
	cp d
	jr z, .press
	ld e, $30
.press
;> if not hJoypadPressed & buttons:
	ldh a, [hJoypadPressed]
	and e
;>     return
	jp z, ThrowCarriedEntity.done
;> wEntityLedgeDirection[slot] = hLinkDirection
	ldh a, [hLinkDirection]
	ld hl, wEntityLedgeDirection
	add hl, bc
	ld [hl], a
;> hJingle = 8
	ld hl, hJingle
	ld [hl], $08
;> return ThrowCarriedEntity(slot)   # runs on into it

;@ def ThrowCarriedEntity(slot: bc)
;@ path: link/carry
;@ Throws the carried entity in Link's direction: it becomes active again (status 5) - a bomb (type 2)
;@ with its fuse ($A0 frames); types $D6, $D5, $6C, $9D, $A8 and $98 go on in their state 2 (type $98
;@ also gets a direction from ThrowDirections and a random timer $30-$4F), type $92 in state 3; type 5
;@ stays as it is; all others become a thrown object (status 8). The speeds come from ThrowSpeedX / Y / Z
;@ (side view and type 2 have their own rows), and Link holds the throwing pose for $0C frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $14
;@ test: hLinkDirection = rand(0, 3)
ThrowCarriedEntity::
;> wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> if hActiveEntityType == 2:
	ldh a, [hActiveEntityType]
	cp $02
	jr nz, .other
;>     wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
	jr .speed
.other
;>@k elif hActiveEntityType in (0xD6, 0xD5, 0x6C, 0x9D, 0xA8, 0x98):
	ld hl, wEntityStatus
	add hl, bc
	cp $d6
	jr z, .state2
	cp $d5
	jr z, .state2
;=@k
	cp $6c
	jr z, .state2
	cp $9d
	jr z, .state2
	cp $a8
	jr z, .state2
;=@k
	cp $98
	jr nz, .notState2
;>     if hActiveEntityType == 0x98:
;>@dir2         wEntityDirection[slot] = mem[ThrowDirections + hLinkDirection]
	push hl
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, ThrowDirections
	add hl, de
;=@dir2
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>@t         wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	pop hl
.state2
;>     wEntityStatus[slot] = 5
	ld [hl], $05
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
	jr .speed
.notState2
;> elif hActiveEntityType == 0x92:
	cp $92
	jr nz, .notState3
;>     wEntityStatus[slot] = 5
	ld [hl], $05
;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
	jr .speed
.notState3
;> elif hActiveEntityType != 5:
	cp $05
	jr z, .speed
;>     wEntityStatus[slot] = 8
	ld [hl], $08
.speed
;> row = 8 if hIsSideScrolling else 0
	ld e, b
	ldh a, [hIsSideScrolling]
	and a
	jr z, .type2
	ld e, $08
.type2
;> if hActiveEntityType == 2:
	ldh a, [hActiveEntityType]
	cp $02
	jr nz, .direction
;>     row += 4
	ld a, e
	add $04
	ld e, a
.direction
;> i = row + hLinkDirection
	ldh a, [hLinkDirection]
	add e
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[ThrowSpeedX + i]
	ld hl, ThrowSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[ThrowSpeedY + i]
	ld hl, ThrowSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedZ[slot] = mem[ThrowSpeedZ + i]
	ld hl, ThrowSpeedZ
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
;> wItemUsePoseTimer = 0x0C
	ld a, $0c
	ld [wItemUsePoseTimer], a
.done
	ret


;@ def CancelDialog()
;@ path: text/dialog
;@ Closes the dialogue before it opens (wDialogState = 0); used by DialogStepOpenBox.
CancelDialog::
;> wDialogState = 0
	xor a
	ld [wDialogState], a
	ret

;@ def DialogStepOpenBox()
;@ path: text/dialog
;@ Dialog step 1, opening the box. While Link warps (motion states 3 and 4) the dialogue is cancelled,
;@ unless mem $C3C9 is set. Outside the ending, unless the room has torches or Link's animation is $6C,
;@ the palettes go to normal at once (transition step 4, BG and OBJ1 $E4, OBJ0 $1C). Once the draw
;@ command queue is empty, goes on to the next dialog step.
DialogStepOpenBox::
;> if not mem[0xC3C9]:
	ld a, [$c3c9]
	and a
	jr nz, .open
;>     if wLinkMotionState in (3, 4):
;>         return CancelDialog()
	ld a, [wLinkMotionState]
	cp $03
	jr z, CancelDialog
	cp $04
	jr z, CancelDialog
.open
;>@n if wGameplayType != 1 and not wRoomHasTorches and hLinkAnimationState != 0x6C:
	ld a, [wGameplayType]
	cp $01
	jr z, .wait
	ld a, [wRoomHasTorches]
	and a
	jr nz, .wait
;=@n
	ldh a, [hLinkAnimationState]
	cp $6c
	jr z, .wait
;>     wTransitionSequenceCounter = 4
	ld a, $04
	ld [wTransitionSequenceCounter], a
;>     wBGPalette = 0xE4
	ld a, $e4
	ld [wBGPalette], a
;>     wOBJ1Palette = 0xE4
	ld [wOBJ1Palette], a
;>     wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
.wait
;> if wDrawCommand[0]:
	ld a, [wDrawCommand]
	and a
;>     return
	ret nz
;> wDialogState += 1
	ld hl, wDialogState
	inc [hl]
	ret


;@ def KeepLinkInBossArena()
;@ path: boss/arena
;@ Keeps Link inside a boss arena: outside x $11-$8E he is pushed one pixel back towards the middle (x
;@ $50); otherwise outside y $16-$73 one pixel up; either way his controls are blocked for the frame
;@ (hLinkInteractiveMotionBlocked 1, wLinkPoseLock 2). Not during a room transition or with the debug
;@ toggle on.
KeepLinkInBossArena::
;> if wRoomTransitionState or wDebugToggle:
	ld hl, wDebugToggle
	ld a, [wRoomTransitionState]
	or [hl]
;>     return
	jr nz, .done
;> if (hLinkX - 0x11) & 0xFF >= 0x7E:
	ldh a, [hLinkX]
	sub $11
	cp $7e
	jr c, .checkY
;>@xr     hLinkX = (hLinkX + (1 if hLinkX < 0x50 else -1)) & 0xFF
	ldh a, [hLinkX]
	cp $50
	jr nc, .left
	ldh a, [hLinkX]
	inc a
	ldh [hLinkX], a
;=@xr
	jr .block
.left
;=@xr
	ldh a, [hLinkX]
	dec a
	ldh [hLinkX], a
	jr .block
.checkY
;> elif (hLinkY - 0x16) & 0xFF < 0x5E:
;>     return
	ldh a, [hLinkY]
	sub $16
	cp $5e
	jr c, .done
;> else:
;>     hLinkY -= 1
	ldh a, [hLinkY]
	dec a
	ldh [hLinkY], a
.block
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkPoseLock = 2
	ld a, $02
	ld [wLinkPoseLock], a
.done
	ret


;@ path: link/dash
;@ X shake of the screen after a bump (8 bytes): entries 0-3 for a bump to the side, 4-7 for a bump up
;@ or down (by wBumpShakeAxis), one per frame.
BumpShakeX::
	db $00, $02, $00, $fe, $00, $00, $00, $00

;@ path: link/dash
;@ Y shake of the screen after a bump (8 bytes, same layout as BumpShakeX).
BumpShakeY::
	db $00, $00, $00, $00, $00, $02, $00, $fe

;@ def UpdateBumpShake()
;@ path: link/dash
;@ Counts wDashBumpFrames down, and while wBumpShakeTimer runs shakes the screen after Link has bumped
;@ into something: wScreenShakeX / Y = BumpShakeX / BumpShakeY[((timer - 1) & 3) + wBumpShakeAxis].
UpdateBumpShake::
;> if wDashBumpFrames:
	ld a, [wDashBumpFrames]
	and a
	jr z, .shake
;>     wDashBumpFrames -= 1
	dec a
	ld [wDashBumpFrames], a
.shake
;> if wBumpShakeTimer:
	ld a, [wBumpShakeTimer]
	and a
	jr z, .done
;>     wBumpShakeTimer -= 1
	dec a
	ld [wBumpShakeTimer], a
;>     i = (wBumpShakeTimer & 3) + wBumpShakeAxis
	and $03
	ld hl, wBumpShakeAxis
	add [hl]
	ld e, a
	ld d, $00
;>     wScreenShakeX = mem[BumpShakeX + i]
	ld hl, BumpShakeX
	add hl, de
	ld a, [hl]
	ld [wScreenShakeX], a
;>     wScreenShakeY = mem[BumpShakeY + i]
	ld hl, BumpShakeY
	add hl, de
	ld a, [hl]
	ld [wScreenShakeY], a
.done
	ret


;@ def ReplaceRoomObjectWithFloor(pos: de)
;@ path: link/lift
;@ Puts what lies under a lifted or moved room object into wRoomObjects[pos] and queues the redraw of
;@ its square. QueueSquareRedraw(a, b, c, d) appends a 10-byte draw command at wDrawCommand +
;@ wDrawCommandsSize: the square's BG address (GetBGAddress) with $81 = two tiles downwards, tiles a and
;@ b, then the next column with c and d, then the end mark. Object $8E becomes $AA; object $D3 becomes
;@ stairs in rooms $75, $07, $AA and $4A (the room remembers it, status bit 4) and $E8 elsewhere;
;@ indoors in a side view object $8A becomes $04, other indoor objects the floor $0D; on the overworld
;@ object $20 becomes stairs in rooms $52 and $04, everything else the ground $04. Stairs also set
;@ hStairsState, the stairs' position and the warp target position, and play the sound 2.
;@ test: wCurrentBank = $14
;@ test: pos = rand(0, 0x9F)
;@ test: wIsIndoor = rand(0, 1)
ReplaceRoomObjectWithFloor::
;>@qs1 def QueueSquareRedraw(t0, t1, t2, t3):   # the 10-byte draw command (written out at each use)
;>@qs2     GetBGAddress()
;>@qs3     cmd = addr(wDrawCommand) + wDrawCommandsSize
;>@qs4     wDrawCommandsSize += 10
;>@qs5     for i, v in enumerate((hBGAddrHigh, hBGAddrLow, 0x81, t0, t1, hBGAddrHigh, u8(hBGAddrLow + 1), 0x81, t2, t3, 0)): mem[cmd + i] = v
;>@Repl1 def ReplaceD3Object(obj):                      # .objectD3
;>@m         if hMapRoom not in (0x75, 0x07, 0xAA, 0x4A):
;>@Repl2             return ReplaceD3WithHole(obj)
;>@rs         wRoomStatus[hMapRoom] |= 0x10
;>@Repl3         return PlaceStairs(obj)   # runs on into it
;>@Plac1 def PlaceStairs(obj):                          # .stairs
;>@Plac2         mem[obj] = 0xC6
;>@e         QueueSquareRedraw(0x68, 0x77, 0x69, 0x4B)
;>@Plac3         hStairsState = 1
;>@Plac4         hStairsY = (hBGPosY & 0xF0) + 0x10
;>@Plac5         hStairsX = (hBGPosX & 0xF0) + 8
;>@w         wWarpDestPosition = (hBGPosY & 0xF0) | (hBGPosX >> 4)
;>@Plac6         hJingle = 2
;>@Repl4 def ReplaceD3WithHole(obj):                    # .hole
;>@Repl5         mem[obj] = 0xE8
;>@h2         QueueSquareRedraw(0x68, 0x78, 0x69, 0x79)
;>@Repl6         return
;> obj = addr(wRoomObjects) + pos
	ld hl, wRoomObjects
	add hl, de
;> if hRoomObjectType == 0x8E:
	ldh a, [hRoomObjectType]
	cp $8e
	jr nz, .notAA
;>     mem[obj] = 0xAA
	ld [hl], $aa
;>@a     QueueSquareRedraw(0x14, 0x16, 0x15, 0x17)
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
;=@a
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
;=@a
	ld a, $81
	ld [hli], a
	ld a, $14
	ld [hli], a
	ld a, $16
	ld [hli], a
;=@a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@a
	ld [hli], a
	ld a, $15
	ld [hli], a
	ld a, $17
	jp .finish
.notAA
;> elif hRoomObjectType == 0xD3:
	cp $d3
	jr nz, .indoors
;>     return ReplaceD3Object(obj)
	jp .objectD3
.indoors
;> elif wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jp z, .overworld
;>     if hIsSideScrolling and hRoomObjectType == 0x8A:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .indoorFloor
	ldh a, [hRoomObjectType]
	cp $8a
	jr nz, .indoorFloor
;>         mem[obj] = 0x04
	ld [hl], $04
;>@b         QueueSquareRedraw(0x7E, 0x7E, 0x7E, 0x7E)
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
;=@b
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
;=@b
	ld a, $81
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
;=@b
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@b
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $7e
	jp .finish
;>     else:
.indoorFloor
;>         mem[obj] = 0x0D
	ld [hl], $0d
;>@c         QueueSquareRedraw(0x10, 0x12, 0x11, 0x13)
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
;=@c
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
;=@c
	ld a, $81
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, $12
	ld [hli], a
;=@c
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@c
	ld [hli], a
	ld a, $11
	ld [hli], a
	ld a, $13
	jr .finish
;> else:
.overworld
;>@s     if hRoomObjectType == 0x20 and hMapRoom in (0x52, 0x04):
	ldh a, [hRoomObjectType]
	cp $20
	jr nz, .ground
	ldh a, [hMapRoom]
	cp $52
	jr z, .owStairs
;=@s
	cp $04
	jr nz, .ground
.owStairs
;>         return PlaceStairs(obj)
	jp .stairs
.ground
;>     mem[obj] = 0x04
	ld [hl], $04
;>@d     QueueSquareRedraw(0x5A, 0x7F, 0x7F, 0x5A)
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
;=@d
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
;=@d
	ld a, $81
	ld [hli], a
	ld a, $5a
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@d
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@d
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $5a
.finish
;=@d
	ld [hli], a
	ld a, $00
	ld [hli], a
	ret
.objectD3
;=@Repl1
;=@m
	ldh a, [hMapRoom]
	cp $75
	jr z, .secret
	cp $07
	jr z, .secret
	cp $aa
;=@m
	jr z, .secret
	cp $4a
	jr nz, .hole
;=@Repl2
.secret
;=@rs
	ld hl, wRoomObjects
	add hl, de
	push hl
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
;=@rs
	ld hl, wRoomStatus
	add hl, de
	set 4, [hl]
;=@Repl3
	pop hl
.stairs
;=@Plac1
;=@Plac2
	ld [hl], $c6
;=@e
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
;=@e
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
;=@e
	ld a, $81
	ld [hli], a
	ld a, $68
	ld [hli], a
	ld a, $77
	ld [hli], a
;=@e
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@e
	ld [hli], a
	ld a, $69
	ld [hli], a
	ld a, $4b
	ld [hli], a
	ld [hl], $00
;=@Plac3
	ld a, $01
	ldh [hStairsState], a
;=@Plac4
	ldh a, [hBGPosY]
	and $f0
	add $10
	ldh [hStairsY], a
;=@Plac5
	ldh a, [hBGPosX]
	and $f0
	add $08
	ldh [hStairsX], a
;=@w
	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
;=@w
	or e
	ld [wWarpDestPosition], a
;=@Plac6
	ld a, $02
	ldh [hJingle], a
	ret
.hole
;=@Repl4
;=@Repl5
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $e8
;=@h2
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
;=@h2
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
;=@h2
	ld a, $81
	ld [hli], a
	ld a, $68
	ld [hli], a
	ld a, $78
	ld [hli], a
;=@h2
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@h2
	ld [hli], a
	ld a, $69
	ld [hli], a
	ld a, $79
	ld [hli], a
	ld [hl], $00
;=@Repl6
	ret
;=@qs1
;=@qs2
;=@qs3
;=@qs4
;=@qs5


;@ path: unused
;@ Free space between the code of bank $14 and its dialogs (93 bytes of $FF).
Bank14FreeSpace0::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ path: text/dialogs
;@ Dialog $000: "Whoa, boy! Where ya off to in such a hurry? Set a spell, I got some..."
Dialog000::
	db "Whoa, boy! Where"
	db "ya off to in    "
	db "such a hurry?   "
	db "Set a spell, I  "
	db "got somethin^ ta"
	db "tell ya!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $001: "What a relief! I thought you'd never wake up! You were tossing and ..." (B does not hurry it)
Dialog001::
	db "What a relief! I"
	db "thought you^d   "
	db "never wake up!  "
	db "You were tossing"
	db "and turning...  "
	db "What?  Zelda?   "
	db "No, my name^s   "
	db "Marin!  You must"
	db "still be feeling"
	db "a little woozy. "
	db "You are on      "
	db "Koholint Island!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $002: "Follow the lane south to reach the beach where I found you. Since y..."
Dialog002::
	db "Follow the lane "
	db "south to reach  "
	db "the beach where "
	db "I found you.    "
	db "Since you washed"
	db "ashore, lots of "
	db "nasty monsters  "
	db "have been in the"
	db "area, so be     "
	db "careful, okay?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $003: "Hi! Tarin went to the forest to look for toad- stools, but I'd rath..."
Dialog003::
	db "Hi!  Tarin went "
	db "to the forest to"
	db "look for toad-  "
	db "stools, but I^d "
	db "rather sing.    "
	db "Listen to this, "
	db "it^s called the "
	db "^Ballad of the  "
	db "Wind Fish.^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $004: "Hey! That's a nice Ocarina you have there! Will you accompany me as..."
Dialog004::
	db "Hey!  That^s a  "
	db "nice Ocarina you"
	db "have there! Will"
	db "you accompany   "
	db "me as I sing?"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $005: "I just love to sing-- what can I say? What do you like to do, [NAME]?"
Dialog005::
	db "I just love to  "
	db "sing-- what can "
	db "I say?  What do "
	db "you like to do, "
	db "#####?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $006: "[NAME], Tarin's taking a nap at home. I don't know how he can sleep..."
Dialog006::
	db "#####, Tarin^s  "
	db "taking a nap at "
	db "home.  I don^t  "
	db "know how he can "
	db "sleep on such a "
	db "nice day!  It   "
	db "makes me want to"
	db "sing a song...  "
	db "Yes, the song is"
	db "^Ballad of the  "
	db "Wind Fish!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $007: "Eh? It's locked! You can open the door with the Nightmare Key."
Dialog007::
	db "Eh? It^s locked!"
	db "You can open the"
	db "door with the   "
	db "Nightmare Key."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $008: "You got a Piece of Power! You can feel the energy flowing through y..."
Dialog008::
	db "You got a Piece "
	db "of Power!  You  "
	db "can feel the    "
	db "energy flowing  "
	db "through you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $009: "Ahhh... It has the Sleepy Toad- stool, it does! We'll mix it up som..."
Dialog009::
	db "Ahhh... It has  "
	db "the Sleepy Toad-"
	db "stool, it does! "
	db "We^ll mix it up "
	db "something in a  "
	db "jiffy, we will!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $00A: "The last thing I kin remember was bitin' into a big juicy toad- sto..."
Dialog00A::
	db "The last thing I"
	db "kin remember was"
	db "bitin^ into a   "
	db "big juicy toad- "
	db "stool... Then, I"
	db "had the darndest"
	db "dream... I was a"
	db "raccoon!  Yeah, "
	db "sounds strange, "
	db "but it sure was "
	db "fun!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $00B: "I'm all tucker'd out... I think I better set a spell before I head ..."
Dialog00B::
	db "I^m all tucker^d"
	db "out...  I think "
	db "I better set a  "
	db "spell before I  "
	db "head home..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $00C: "Double double, toil and trouble a toadstool mix makes powder for tr..."
Dialog00C::
	db "Double double,  "
	db "toil and trouble"
	db "a toadstool mix "
	db "makes powder for"
	db "tricks!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $00D: "As a raccoon, my nose is verrry sensitive, ta stuff like dust and p..."
Dialog00D::
	db "As a raccoon, my"
	db "nose is verrry  "
	db "sensitive, ta   "
	db "stuff like dust "
	db "and powder..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $00E: "It's the toad- stool you picked in the woods. What is it for? You h..."
Dialog00E::
	db "It^s the toad-  "
	db "stool you picked"
	db "in the woods.   "
	db "What is it for? "
	db "You hold it over"
	db "your head and a "
	db "mellow aroma    "
	db "wafts into your "
	db "nostrils."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $00F: "You pick the toadstool... As you hold it over your head, a mellow a..." (B does not hurry it)
Dialog00F::
	db "You pick the    "
	db "toadstool... As "
	db "you hold it over"
	db "your head, a    "
	db "mellow aroma    "
	db "flows into your "
	db "nostrils."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $010: "Hrrrm...Snore... Hunh?... If'n ya don' know...call old man Ulrira! ..."
Dialog010::
	db "Hrrrm...Snore..."
	db "Hunh?... If^n ya"
	db "don^ know...call"
	db "old man Ulrira! "
	db "Zonk...Snore..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $011: "I'm tired... I'm goin' ta sleep now... Zzzzzz..."
Dialog011::
	db "I^m tired... I^m"
	db "goin^ ta sleep  "
	db "now... Zzzzzz..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $012: "Well that was a surprise! Hey! I'll tell you a secret! Use your swo..."
Dialog012::
	db "Well that was a "
	db "surprise!  Hey! "
	db "I^ll tell you a "
	db "secret! Use your"
	db "sword to poke at"
	db "dungeon walls..."
	db "If you hear a   "
	db "hollow clank,   "
	db "you can break   "
	db "the wall with a "
	db "Bomb!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $013: "You've learned the 'Ballad of the Wind Fish!' This song will always..." (B does not hurry it)
Dialog013::
	db "You^ve learned  "
	db "the ^Ballad of  "
	db "the Wind Fish!^ "
	db "This song will  "
	db "always remain in"
	db "your heart!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $014: "Please remember this song! You should play it every once in a while..."
Dialog014::
	db "Please remember "
	db "this song!  You "
	db "should play it  "
	db "every once in a "
	db "while to keep it"
	db "fresh in your   "
	db "mind!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $015: "Please! I want you to learn it! This song is my favorite!"
Dialog015::
	db "Please!  I want "
	db "you to learn it!"
	db "This song is my "
	db "favorite!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $016: "So, how do you like it? It's really touching, isn't it? Does it sti..." (B does not hurry it)
Dialog016::
	db "So, how do you  "
	db "like it?  It^s  "
	db "really touching,"
	db "isn^t it?  Does "
	db "it stick in your"
	db "mind?           "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $017: "Hi there, big guy! I'm Crazy Tracy! I've got a little secret for sa..."
Dialog017::
	db "Hi there, big   "
	db "guy!  I^m Crazy "
	db "Tracy!  I^ve got"
	db "a little secret "
	db "for sale that^ll"
	db "pump you up!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $018: "Will you give me 28 Rupees for my secret? Give Don't"
Dialog018::
	db "Will you give me"
	db "28 Rupees for my"
	db "secret?         "
	db "    Give Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $019: "How about it? 42 Rupees for my little secret... Give Don't"
Dialog019::
	db "How about it?   "
	db "42 Rupees for my"
	db "little secret..."
	db "    Give Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $01A: "All right, come here and I'll rub it on you! ...There... I've appli..."
Dialog01A::
	db "All right, come "
	db "here and I^ll   "
	db "rub it on you!  "
	db "...There... I^ve"
	db "applied my own  "
	db "secret medicine!"
	db "It will take    "
	db "effect when you "
	db "lose all heart! "
	db "Drop by again,  "
	db "big guy!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $01B: "Beat it, then! Come back when you have some cash!"
Dialog01B::
	db "Beat it, then!  "
	db "Come back when  "
	db "you have some   "
	db "cash!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $01C: "... ... ... ... But I won't sell it to you!"
Dialog01C::
	db "... ... ... ... "
	db "But I won^t sell"
	db "it to you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $01D: "Well! I'm only offering you a secret that will make you strong! You..."
Dialog01D::
	db "Well!  I^m only "
	db "offering you a  "
	db "secret that will"
	db "make you strong!"
	db "You^re such a   "
	db "chicken!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $01E: "...You're so cute! I'll give you a 7 Rupee discount!"
Dialog01E::
	db "...You^re so    "
	db "cute!  I^ll give"
	db "you a 7 Rupee   "
	db "discount!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $01F: "You got Marin! Is this your big chance?"
Dialog01F::
	db "You got Marin!  "
	db "Is this your big"
	db "chance?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $020: "GRRRR..."
Dialog020::
	db "GRRRR..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $021: "Heh heh heh ho! You're goin' ta be lost, thanks to me! Heh heh!"
Dialog021::
	db "Heh heh heh ho! "
	db "You^re goin^ ta "
	db "be lost, thanks "
	db "to me!  Heh heh!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $022: "BOW WOW! BOW WOW!"
Dialog022::
	db "BOW WOW!        "
	db "BOW WOW!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $023: "YIP YIP! YIP YIP!"
Dialog023::
	db "YIP YIP!        "
	db "YIP YIP!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $024: "Let's heal your wounds and get rid of all that stress... Close your..."
Dialog024::
	db "Let^s heal your "
	db "wounds and get  "
	db "rid of all that "
	db "stress... Close "
	db "your eyes and   "
	db "relax..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $025: "You dirty rat! You k-k-k...beat my brothers! You'll pay!! I'll neve..."
Dialog025::
	db "You dirty rat!  "
	db "You k-k-k...beat"
	db "my brothers!    "
	db "You^ll pay!!    "
	db "I^ll never      "
	db "forget you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $026: "Hey runt! You think you can take me?! All right boys, get this punk..." (B does not hurry it)
Dialog026::
	db "Hey runt!  You  "
	db "think you can   "
	db "take me?!  All  "
	db "right boys, get "
	db "this punk out   "
	db "of my face!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $027: "Yep! Those're my boys! I'm Papahl, pleased ta meetcha! I'll be lost..."
Dialog027::
	db "Yep!  Those^re  "
	db "my boys!  I^m   "
	db "Papahl, pleased "
	db "ta meetcha! I^ll"
	db "be lost in the  "
	db "hills later, so "
	db "keep a look out "
	db "for me, hear?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $028: "Yes!! Yes!! Break them! Break them all! ... ... ... ... What? What'..."
Dialog028::
	db "Yes!!  Yes!!    "
	db "Break them!     "
	db "Break them all! "
	db "... ... ... ... "
	db "What?  What^s   "
	db "wrong?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $029: "Aye Caramba! Kid, you have a lot to learn, trying to buy something ..."
Dialog029::
	db "Aye Caramba!    "
	db "Kid, you have a "
	db "lot to learn,   "
	db "trying to buy   "
	db "something you   "
	db "have no use for!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $02A: "You've got a Heart! Thump! One of your Heart Containers is filled!"
Dialog02A::
	db "You^ve got a    "
	db "Heart!  Thump!  "
	db "One of your     "
	db "Heart Containers"
	db "is filled!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $02B, $02C: "Bow & Arrow Set Only 980 Rupees! Buy No Way"
Dialog02B::
	db "Bow & Arrow Set "
	db "Only 980 Rupees!"
	db "    Buy  No Way"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $02D: "10 Arrows 10 Rupees Buy Don't"
Dialog02D::
	db "   10 Arrows    "
	db "   10 Rupees    "
	db "    Buy  Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $02E: "Hey! Welcome! See something you like?! Just bring it here!"
Dialog02E::
	db "Hey!  Welcome!  "
	db "See something   "
	db "you like?!  Just"
	db "bring it here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $02F: "Hey! You! Stop! You gotta pay! Put it back!"
Dialog02F::
	db "Hey! You! Stop! "
	db "You gotta pay!  "
	db "Put it back!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $030: "Deluxe Shovel 200 Rupees! Seems expensive! Buy No Way!"
Dialog030::
	db "  Deluxe Shovel "
	db "   200 Rupees!  "
	db "Seems expensive!"
	db "    Buy  No Way!"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $031: "Three Hearts 10 Rupees! Buy Don't"
Dialog031::
	db "   Three Hearts "
	db "    10 Rupees!  "
	db "    Buy  Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $032: "Shield 20 Rupees! Buy Don't"
Dialog032::
	db "     Shield     "
	db "    20 Rupees!  "
	db "    Buy  Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $033: "Ten Bombs 10 Rupees Buy Don't"
Dialog033::
	db "    Ten Bombs   "
	db "    10 Rupees   "
	db "    Buy  Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $034: "Sorry, kid! You don't have the Rupees! Come back when you have the ..."
Dialog034::
	db "Sorry, kid!  You"
	db "don^t have the  "
	db "Rupees!  Come   "
	db "back when you   "
	db "have the cash!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $035: "Thanks a lot! And come again!"
Dialog035::
	db "Thanks a lot!   "
	db "And come again!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $036: "Guess what? You got it for free. Are you proud of yourself?" (B does not hurry it)
Dialog036::
	db "Guess what?  You"
	db "got it for free."
	db "Are you proud of"
	db "yourself?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $037, $038: "I wasn't kidding when I said pay! Now, you'll pay the ultimate pric..."
Dialog037::
	db "I wasn^t kidding"
	db "when I said pay!"
	db "Now, you^ll pay "
	db "the ultimate    "
	db "price!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $039: "Hunh? It sounds like the castle gate opened! You can easily leave t..."
Dialog039::
	db "Hunh?  It sounds"
	db "like the castle "
	db "gate opened! You"
	db "can easily leave"
	db "the castle now!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $03A, $03B: "TRENDY GAME! One Play 10 Rs. Play No"
Dialog03A::
	db "  TRENDY GAME!  "
	db " One Play 10 Rs."
	db "    Play No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $03C: "The A and B Buttons move the crane...The rest is just timing! Go ov..."
Dialog03C::
	db "The A and B     "
	db "Buttons move the"
	db "crane...The rest"
	db "is just timing! "
	db "Go over to the  "
	db "buttons to play!"
	db "Good Luck!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $03D: "It's a Shield! There is space for your name!"
Dialog03D::
	db "It^s a Shield!  "
	db "There is space  "
	db "for your name!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $03E: "Challenge Again? Play No"
Dialog03E::
	db "Challenge Again?"
	db "    Play No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $03F: "Good Luck!"
Dialog03F::
	db "Good Luck!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $040: "We're closing up for today! Come again, anytime!"
Dialog040::
	db "We^re closing up"
	db "for today!  Come"
	db "again, anytime!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $041: "You got some Magic Powder! Try to sprinkle it on many things!"
Dialog041::
	db "You got some    "
	db "Magic Powder!   "
	db "Try to sprinkle "
	db "it on many      "
	db "things!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $042: "It's 30 Rupees! You can play the game three more times with this!"
Dialog042::
	db "It^s 30 Rupees! "
	db "You can play the"
	db "game three more "
	db "times with this!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $043: "Cough Cough... Don't sprinkle that on me... ...I'll have to curse y..."
Dialog043::
	db "Cough Cough...  "
	db "Don^t sprinkle  "
	db "that on me...   "
	db "...I^ll have to "
	db "curse you!      "
	db "Cough Cough..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $044: "You got a Yoshi Doll! Recently, he seems to be showing up in many g..."
Dialog044::
	db "You got a Yoshi "
	db "Doll!  Recently,"
	db "he seems to be  "
	db "showing up in   "
	db "many games!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $045: "How about some fishing, little buddy? I'll only charge you 10 Rupee..." (B does not hurry it)
Dialog045::
	db "How about some  "
	db "fishing, little "
	db "buddy? I^ll only"
	db "charge you 10   "
	db "Rupees...       "
	db "    Fish Not Now"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $046: "You have to have more passion! Live a little!" (B does not hurry it)
Dialog046::
	db "You have to have"
	db "more passion!   "
	db "Live a little!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $047: "Okay, here's how you do it. Use ? and ? on the ? to aim a cast. Onc..." (B does not hurry it)
Dialog047::
	db "Okay, here^s how"
	db "you do it.  Use "
	db $f2, " and ", $f3, " on the ", $ee
	db "to aim a cast.  "
	db "Once you hook a "
	db "fish, press the "
	db "Button rapidly  "
	db "to reel him in!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $048: "Why not try one more time, little buddy? Cast Not Now" (B does not hurry it)
Dialog048::
	db "Why not try one "
	db "more time,      "
	db "little buddy?   "
	db "    Cast Not Now"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $049: "Wow! That one got away! Want to try again? Cast Not Now" (B does not hurry it)
Dialog049::
	db "Wow! That one   "
	db "got away!  Want "
	db "to try again?   "
	db "    Cast Not Now"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $04A: "Wow! Nice Fish! It's a lunker!! I'll give you a 20 Rupee prize! Try..." (B does not hurry it)
Dialog04A::
	db "Wow! Nice Fish! "
	db "It^s a lunker!! "
	db "I^ll give you a "
	db "20 Rupee prize! "
	db "Try again?      "
	db "    Cast Not Now"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $04B: "This pond's all fished out. Why not try your luck in the sea? Okay No" (B does not hurry it)
Dialog04B::
	db "This pond^s all "
	db "fished out.  Why"
	db "not try your    "
	db "luck in the sea?"
	db "    Okay No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $04C: "Did I say that? Forget it, okay? Run along now..." (B does not hurry it)
Dialog04C::
	db "Did I say that? "
	db "Forget it, okay?"
	db "Run along now..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $04D: "It's a runt! I'll only give you a 5 Rupees prize for that. You shou..." (B does not hurry it)
Dialog04D::
	db "It^s a runt!    "
	db "I^ll only give  "
	db "you a 5 Rupees  "
	db "prize for that. "
	db "You should try  "
	db "again!          "
	db "    Okay No"
	db $fe  ; end, then a choice of two answers
;@ path: text/dialogs
;@ Dialog $04E: "You're short of Rupees? Don't worry about it. You just come back wh..." (B does not hurry it)
Dialog04E::
	db "You^re short of "
	db "Rupees?  Don^t  "
	db "worry about it. "
	db "You just come   "
	db "back when you   "
	db "have more money,"
	db "little buddy."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $04F: "You've got a Piece of Heart!" (B does not hurry it)
Dialog04F::
	db "You^ve got a    "
	db "Piece of Heart! "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $050: "You collected four Pieces of Heart. Now, you have a complete Heart ..." (B does not hurry it)
Dialog050::
	db "You collected   "
	db "four Pieces of  "
	db "Heart.  Now, you"
	db "have a complete "
	db "Heart Container!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $051: "Brrrr... This is a block of solid ice! It's very cold!" (B does not hurry it)
Dialog051::
	db "Brrrr... This is"
	db "a block of solid"
	db "ice!  It^s very "
	db "cold!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $052: "NYAH NYAH! You can't hurt me as long as I have my bottle!" (B does not hurry it)
Dialog052::
	db "NYAH NYAH! You  "
	db "can^t hurt me as"
	db "long as I have  "
	db "my bottle!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $053: "Waaaah! You- you broke my bottle! Why, you... You make me hopping m..." (B does not hurry it)
Dialog053::
	db "Waaaah! You- you"
	db "broke my bottle!"
	db "Why, you... You "
	db "make me hopping "
	db "mad!!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $054: "Well, [NAME], ya finally snapped out of it... Name's Tarin... Hope ..." (B does not hurry it)
Dialog054::
	db "Well, #####, ya "
	db "finally snapped "
	db "out of it...    "
	db "Name^s Tarin... "
	db "Hope yer feelin^"
	db "better...  What?"
	db "How did I know  "
	db "your name?  You "
	db "think it^s weird"
	db "eh?  Well, I saw"
	db "it on back of   "
	db "this shield!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $055: "Oh, yeah... Some other stuff like this washed up on the beach... If..."
Dialog055::
	db "Oh, yeah... Some"
	db "other stuff like"
	db "this washed up  "
	db "on the beach... "
	db "If^n you go look"
	db "watch out for   "
	db "monsters! Ever  "
	db "since you showed"
	db "up, #####, I^ve "
	db "seen ^em all    "
	db "over the place!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $056: "Level 1-- Tail Cave"
Dialog056::
	db "Level 1--       "
	db "     Tail Cave"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $057: "Level 2-- Bottle Grotto"
Dialog057::
	db "Level 2--       "
	db "   Bottle Grotto"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $058: "Level 3-- Key Cavern"
Dialog058::
	db "Level 3--       "
	db "      Key Cavern"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $059: "Level 4-- Angler's Tunnel"
Dialog059::
	db "Level 4--       "
	db " Angler^s Tunnel"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $05A: "Level 5-- Catfish's Maw"
Dialog05A::
	db "Level 5--       "
	db "   Catfish^s Maw"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $05B: "Level 6-- Face Shrine"
Dialog05B::
	db "Level 6--       "
	db "     Face Shrine"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $05C: "Level 7-- Eagle's Tower"
Dialog05C::
	db "Level 7--       "
	db "   Eagle^s Tower"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $05D: "Level 8-- Turtle Rock"
Dialog05D::
	db "Level 8--       "
	db "     Turtle Rock"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $05E: "Wind Fish's Egg"
Dialog05E::
	db "Wind Fish^s Egg "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $05F, $060: "Mountain Bridge"
Dialog05F::
	db "Mountain Bridge "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $061: "Sale's House O' Bananas"
Dialog061::
	db "Sale^s House O^ "
	db "    Bananas"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $062: "Pothole Field"
Dialog062::
	db "Pothole Field"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $063: "House By The Bay"
Dialog063::
	db "    House By    "
	db "     The Bay"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $064: "Trendy Game"
Dialog064::
	db "   Trendy Game"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $065: "Town Tool Shop"
Dialog065::
	db "  Town Tool Shop"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $066: "Marin and Tarin's House"
Dialog066::
	db "Marin and       "
	db "   Tarin^s House"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $067: "Witch's Hut"
Dialog067::
	db "   Witch^s Hut"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $068: "Yarna Desert"
Dialog068::
	db "  Yarna Desert"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $069: "Ukuku Prairie"
Dialog069::
	db "  Ukuku Prairie"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $06A: "Mysterious Woods"
Dialog06A::
	db "Mysterious Woods"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $06B: "Mt. Tamaranch"
Dialog06B::
	db "  Mt. Tamaranch "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $06C: "Tal Tal Mountain Range"
Dialog06C::
	db "     Tal Tal    "
	db " Mountain Range "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $06D: "Signpost Maze"
Dialog06D::
	db "  Signpost Maze "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $06E: "Mabe Village"
Dialog06E::
	db "  Mabe Village  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $06F: "Animal Village"
Dialog06F::
	db " Animal Village "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $070: "Cemetary"
Dialog070::
	db "    Cemetary    "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $071: "Rapids Ride"
Dialog071::
	db "   Rapids Ride  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $072: "Koholint Prairie"
Dialog072::
	db "Koholint Prairie"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $073: "Toronbo Shores"
Dialog073::
	db " Toronbo Shores"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $074: "Martha's Bay"
Dialog074::
	db "  Martha^s Bay"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $075: "East of the Bay"
Dialog075::
	db "East of the Bay"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $076: "Goponga Swamp"
Dialog076::
	db "  Goponga Swamp"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $077: "Face Shrine"
Dialog077::
	db "   Face Shrine "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $078: "Kanalet Castle"
Dialog078::
	db " Kanalet Castle"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $079: "Tal Tal Heights"
Dialog079::
	db "Tal Tal Heights"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $07A: "Tabahl Wasteland"
Dialog07A::
	db "Tabahl Wasteland"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $07B: "South of the Village"
Dialog07B::
	db "  South of the  "
	db "    Village"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $07C: "Fishing Pond"
Dialog07C::
	db "  Fishing Pond  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $07D: "Madam MeowMeow's House Beware of Dog!"
Dialog07D::
	db "Madam MeowMeow^s"
	db "     House      "
	db " Beware of Dog!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $07E: "Old Man Ulrira's House"
Dialog07E::
	db "Old Man Ulrira^s"
	db "     House      "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $07F: "Weird Mr. Write"
Dialog07F::
	db "Weird Mr. Write "
	db $ff  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank14FreeSpace2::
	db $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
