; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $008", ROMX[$4000], BANK[$8]

;@ path: world/overworld/rooms
;@ The area tile set of the overworld, one byte per 2 x 2 rooms (index = (room / 32) * 8 + (room % 16) / 2; room $07 counts as $08): the page of OverworldTileset1C ... OverworldTileset3E in bank $0F that is copied to $9000 (hWorldTileset; $0F = keep the tiles already loaded). Read by LoadRoomTilesets.
OverworldTilesetIds::
	db $1c, $1c, $3e, $3c, $3e, $3e, $3e, $30  ; rooms $00-$1F
	db $0f, $36, $36, $0f, $0f, $34, $0f, $3e  ; rooms $20-$3F
	db $20, $20, $0f, $38, $28, $28, $32, $32  ; rooms $40-$5F
	db $20, $20, $38, $38, $28, $28, $32, $32  ; rooms $60-$7F
	db $0f, $26, $0f, $24, $0f, $1e, $2a, $0f  ; rooms $80-$9F
	db $26, $26, $2e, $2e, $0f, $2a, $2a, $2a  ; rooms $A0-$BF
	db $0f, $24, $2e, $2e, $3a, $0f, $26, $2c  ; rooms $C0-$DF
	db $22, $22, $22, $0f, $3a, $3a, $0f, $2c  ; rooms $E0-$FF
;@ path: world/indoor/rooms
;@ The tile set of each room of indoor group A (IndoorTileset00 ... in bank $0D, copied to $9000; $FF = none), one byte per room.
IndoorATilesetIds::
	db $ff, $00, $00, $00, $ff, $01, $00, $05, $00, $09, $00, $00, $05, $05, $05, $ff  ; room $00-$0F
	db $00, $00, $ff, $ff, $02, $01, $01, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; room $10-$1F
	db $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $02, $00, $ff, $0e  ; room $20-$2F
	db $ff, $ff, $ff, $ff, $ff, $ff, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ; room $30-$3F
	db $02, $02, $ff, $02, $02, $09, $09, $ff, $02, $02, $09, $02, $09, $09, $09, $09  ; room $40-$4F
	db $09, $ff, $01, $01, $05, $00, $00, $00, $00, $0a, $0a, $0a, $0a, $00, $00, $00  ; room $50-$5F
	db $09, $00, $00, $09, $09, $00, $00, $09, $09, $09, $09, $00, $00, $ff, $02, $ff  ; room $60-$6F
	db $09, $00, $00, $ff, $00, $00, $00, $ff, $ff, $00, $01, $05, $00, $00, $00, $00  ; room $70-$7F
	db $ff, $05, $ff, $ff, $ff, $06, $07, $07, $07, $ff, $ff, $06, $06, $ff, $ff, $ff  ; room $80-$8F
	db $09, $ff, $ff, $ff, $07, $ff, $ff, $07, $ff, $07, $05, $ff, $ff, $05, $05, $05  ; room $90-$9F
	db $ff, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $19, $ff, $ff, $ff  ; room $A0-$AF
	db $03, $0e, $03, $0e, $ff, $0e, $0e, $0e, $0e, $0e, $0e, $ff, $0e, $0e, $ff, $0e  ; room $B0-$BF
	db $0e, $0e, $0e, $09, $00, $0e, $09, $ff, $ff, $0e, $09, $00, $0e, $ff, $02, $0e  ; room $C0-$CF
	db $0e, $0e, $02, $ff, $01, $01, $01, $09, $00, $00, $00, $00, $00, $00, $00, $00  ; room $D0-$DF
	db $0f, $0f, $0f, $08, $00, $0c, $0c, $03, $0c, $0c, $0c, $00, $00, $00, $0c, $00  ; room $E0-$EF
	db $03, $03, $00, $19, $00, $08, $0c, $03, $0c, $0c, $08, $19, $0c, $05, $0c, $00  ; room $F0-$FF
;@ path: world/indoor/rooms
;@ The tile set of each room of indoor group B, one byte per room (see IndoorATilesetIds).
IndoorBTilesetIds::
	db $00, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $ff, $01, $ff  ; room $00-$0F
	db $03, $03, $03, $ff, $03, $03, $ff, $0b, $ff, $03, $ff, $ff, $ff, $07, $07, $ff  ; room $10-$1F
	db $ff, $06, $ff, $ff, $00, $ff, $ff, $ff, $ff, $0e, $0e, $ff, $ff, $0e, $0e, $00  ; room $20-$2F
	db $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $ff, $17, $17, $17, $ff, $03, $ff, $ff  ; room $30-$3F
	db $ff, $ff, $0a, $0a, $0a, $ff, $ff, $ff, $0a, $0a, $ff, $0b, $ff, $0d, $ff, $ff  ; room $40-$4F
	db $0a, $0a, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $09, $01, $00, $00  ; room $50-$5F
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01  ; room $60-$6F
	db $0c, $ff, $ff, $ff, $1a, $ff, $ff, $ff, $ff, $ff, $0c, $0c, $0c, $0c, $0c, $01  ; room $70-$7F
	db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $05, $05, $05, $01  ; room $80-$8F
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $04, $05, $04, $04, $04, $00, $08  ; room $90-$9F
	db $04, $04, $08, $08, $00, $08, $08, $08, $08, $08, $08, $05, $05, $08, $0c, $0c  ; room $A0-$AF
	db $08, $04, $05, $0c, $04, $00, $05, $05, $0c, $0c, $0c, $0c, $0c, $05, $0c, $0c  ; room $B0-$BF
	db $0c, $0c, $03, $03, $00, $03, $ff, $08, $00, $0c, $0c, $04, $04, $0c, $0c, $0c  ; room $C0-$CF
	db $0c, $0c, $ff, $01, $00, $01, $01, $08, $00, $08, $08, $08, $08, $08, $0c, $0c  ; room $D0-$DF
	db $ff, $08, $08, $04, $0c, $0c, $0c, $0c, $00, $08, $0c, $0c, $0c, $0c, $0c, $0c  ; room $E0-$EF
	db $0c, $0c, $0c, $0c, $0c, $00, $0c, $0c, $00, $0c, $0c, $18, $05, $00, $08, $00  ; room $F0-$FF
;@ path: world/overworld/entities
;@ The entity graphics set of each overworld room, one byte per room: the number of a record of OverworldSpritesets.
OverworldSpritesetIds::
	db $65, $66, $67, $68, $69, $6d, $45, $46, $46, $00, $4e, $4e, $4e, $4e, $44, $50  ; room $00-$0F
	db $20, $74, $6b, $6c, $6d, $6d, $37, $37, $4f, $1c, $4f, $4e, $4e, $4e, $50, $4e  ; room $10-$1F
	db $02, $7d, $00, $0e, $48, $47, $37, $06, $06, $00, $51, $50, $50, $62, $62, $62  ; room $20-$2F
	db $02, $7d, $00, $0e, $48, $47, $37, $06, $06, $00, $51, $51, $00, $62, $62, $62  ; room $30-$3F
	db $00, $41, $7e, $7e, $7a, $06, $28, $28, $11, $11, $64, $63, $2d, $2d, $2d, $2d  ; room $40-$4F
	db $01, $2e, $74, $7f, $38, $28, $28, $29, $11, $11, $11, $64, $2d, $2d, $2d, $2d  ; room $50-$5F
	db $00, $00, $7e, $00, $00, $28, $29, $05, $58, $59, $5a, $00, $2d, $2d, $2d, $2d  ; room $60-$6F
	db $7e, $7e, $7e, $7e, $3a, $3a, $28, $29, $5b, $5c, $00, $12, $2d, $2d, $2d, $2d  ; room $70-$7F
	db $3d, $03, $0a, $0b, $39, $61, $18, $18, $4a, $2c, $72, $00, $2a, $6f, $2d, $2d  ; room $80-$8F
	db $00, $00, $43, $0a, $40, $3e, $00, $00, $75, $5f, $73, $70, $2a, $6f, $2d, $2d  ; room $90-$9F
	db $13, $0c, $0a, $00, $3b, $00, $3b, $3b, $5f, $54, $37, $71, $6e, $6e, $6e, $00  ; room $A0-$AF
	db $0f, $0c, $09, $09, $00, $3b, $3b, $3b, $77, $72, $70, $4b, $6e, $6e, $6e, $6e  ; room $B0-$BF
	db $08, $08, $07, $07, $3c, $3c, $3c, $00, $78, $23, $26, $57, $34, $35, $1d, $7b  ; room $C0-$CF
	db $07, $07, $07, $07, $3c, $3c, $3c, $7a, $79, $26, $1f, $53, $2f, $34, $00, $4d  ; room $D0-$DF
	db $07, $07, $00, $42, $00, $90, $91, $26, $26, $25, $36, $33, $31, $30, $7c, $4d  ; room $E0-$EF
	db $07, $07, $07, $00, $90, $90, $91, $00, $1f, $26, $1f, $00, $30, $21, $4c, $7c  ; room $F0-$FF
;@ path: world/indoor/entities
;@ The entity graphics set of each room of indoor group A: the number of a record of IndoorSpritesets.
IndoorASpritesetIds::
	db $01, $03, $0e, $07, $07, $00, $05, $01, $00, $03, $1c, $05, $01, $01, $01, $00  ; room $00-$0F
	db $00, $02, $00, $03, $03, $03, $03, $03, $33, $33, $33, $33, $00, $00, $63, $63  ; room $10-$1F
	db $14, $00, $14, $14, $00, $06, $13, $06, $13, $13, $0e, $08, $13, $08, $06, $07  ; room $20-$2F
	db $06, $06, $00, $00, $1b, $1b, $06, $1b, $06, $00, $33, $33, $33, $33, $33, $33  ; room $30-$3F
	db $18, $18, $18, $18, $00, $15, $00, $00, $17, $00, $17, $17, $06, $17, $06, $00  ; room $40-$4F
	db $18, $3c, $3c, $3c, $17, $17, $17, $17, $17, $0e, $16, $00, $17, $01, $33, $33  ; room $50-$5F
	db $00, $00, $0e, $31, $19, $30, $32, $32, $00, $00, $32, $32, $00, $32, $30, $30  ; room $60-$6F
	db $00, $30, $32, $00, $30, $30, $00, $30, $30, $30, $30, $30, $33, $33, $00, $01  ; room $70-$7F
	db $1e, $1e, $0f, $1e, $1e, $1d, $00, $00, $24, $24, $24, $00, $24, $24, $24, $24  ; room $80-$8F
	db $24, $00, $1e, $1f, $1f, $1e, $1e, $04, $04, $00, $00, $04, $04, $04, $04, $04  ; room $90-$9F
	db $04, $04, $33, $33, $33, $33, $33, $33, $33, $33, $64, $64, $80, $00, $00, $00  ; room $A0-$AF
	db $28, $28, $28, $28, $61, $0f, $61, $00, $00, $28, $28, $00, $25, $26, $61, $29  ; room $B0-$BF
	db $27, $00, $28, $61, $00, $26, $00, $29, $2a, $00, $00, $62, $00, $61, $00, $27  ; room $C0-$CF
	db $61, $61, $27, $27, $27, $27, $00, $61, $63, $63, $33, $33, $33, $33, $00, $00  ; room $D0-$DF
	db $44, $44, $44, $00, $4a, $67, $67, $00, $7f, $00, $00, $33, $33, $00, $6e, $1a  ; room $E0-$EF
	db $67, $67, $00, $80, $4a, $7e, $67, $00, $7f, $7f, $3d, $80, $10, $00, $6e, $1a  ; room $F0-$FF
;@ path: world/indoor/entities
;@ The entity graphics set of each room of indoor group B (see IndoorASpritesetIds).
IndoorBSpritesetIds::
	db $00, $00, $3f, $2c, $2c, $5e, $34, $39, $00, $5f, $60, $3e, $39, $2b, $2b, $00  ; room $00-$0F
	db $39, $2d, $2d, $2d, $2d, $2d, $2d, $2e, $2d, $2d, $2d, $2e, $00, $2d, $2d, $00  ; room $10-$1F
	db $36, $00, $35, $0f, $37, $35, $35, $00, $37, $00, $38, $35, $0f, $35, $68, $01  ; room $20-$2F
	db $0f, $5c, $56, $00, $50, $5c, $00, $51, $56, $58, $5b, $5b, $00, $54, $00, $51  ; room $30-$3F
	db $5a, $00, $59, $59, $00, $57, $5a, $59, $59, $00, $5c, $5c, $52, $00, $55, $00  ; room $40-$4F
	db $5c, $5c, $00, $53, $52, $52, $00, $5b, $00, $5c, $00, $53, $52, $5b, $5a, $53  ; room $50-$5F
	db $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $01, $01, $01, $3d  ; room $60-$6F
	db $01, $01, $01, $01, $6f, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $3d  ; room $70-$7F
	db $66, $66, $66, $01, $01, $66, $66, $66, $65, $65, $65, $65, $66, $66, $65, $3d  ; room $80-$8F
	db $65, $65, $65, $65, $66, $66, $66, $0d, $0d, $09, $65, $09, $09, $09, $00, $49  ; room $90-$9F
	db $10, $11, $20, $2f, $01, $0a, $0a, $0b, $0c, $09, $4b, $65, $65, $4c, $65, $65  ; room $A0-$AF
	db $10, $12, $0b, $65, $09, $01, $65, $65, $65, $65, $65, $65, $65, $65, $0d, $0d  ; room $B0-$BF
	db $00, $00, $21, $21, $21, $21, $21, $22, $66, $65, $65, $09, $09, $66, $0d, $0d  ; room $C0-$CF
	db $67, $67, $21, $21, $21, $21, $21, $40, $66, $41, $10, $4d, $4d, $46, $66, $66  ; room $D0-$DF
	db $3a, $4e, $3a, $09, $66, $66, $65, $65, $3b, $47, $65, $65, $65, $65, $65, $65  ; room $E0-$EF
	db $3a, $67, $67, $67, $66, $42, $65, $65, $3b, $67, $67, $43, $01, $45, $48, $00  ; room $F0-$FF
;@ path: world/overworld/entities
;@ Entity graphics sets of the overworld, 4 bytes each: for each of the four entity tile slots ($8400, $8500, $8600, $8700) the tile set to load (bits 6-7 = bank through EntityTilesBanks: $40-$7F bank $11, $80-$BF bank $0E, $C0-$FF bank $12; bits 0-5 = page: EntityTiles40 ...), $FF = keep that slot. Read by LoadRoomTilesets (wLoadedEntityTilesets) and loaded by LoadTileset09.
OverworldSpritesets::
	db $a4, $ff, $ff, $ff  ; set $00
	db $a4, $8e, $7c, $c8  ; set $01
	db $a4, $4a, $7c, $93  ; set $02
	db $a4, $e5, $ff, $4e  ; set $03
	db $a4, $91, $83, $a2  ; set $04
	db $a4, $42, $8a, $ff  ; set $05
	db $a4, $42, $83, $a2  ; set $06
	db $a4, $81, $e3, $a2  ; set $07
	db $a4, $e5, $e3, $ff  ; set $08
	db $a4, $e5, $43, $e7  ; set $09
	db $a4, $e5, $e6, $ff  ; set $0A
	db $a4, $e5, $e6, $e7  ; set $0B
	db $a4, $e5, $43, $a4  ; set $0C
	db $a4, $8e, $83, $a4  ; set $0D
	db $a4, $4a, $83, $40  ; set $0E
	db $a4, $e5, $4c, $e7  ; set $0F
	db $a4, $4d, $83, $ff  ; set $10
	db $a4, $42, $92, $5a  ; set $11
	db $a4, $61, $92, $67  ; set $12
	db $a4, $e5, $ff, $ff  ; set $13
	db $a4, $e3, $8b, $ff  ; set $14
	db $a4, $e3, $83, $76  ; set $15
	db $a4, $81, $79, $76  ; set $16
	db $a4, $61, $8b, $ff  ; set $17
	db $a4, $6c, $8b, $6b  ; set $18
	db $a4, $ff, $8b, $ff  ; set $19
	db $a4, $e3, $8b, $a2  ; set $1A
	db $a4, $e5, $ff, $ff  ; set $1B
	db $a4, $4a, $8f, $6d  ; set $1C
	db $a4, $81, $6e, $52  ; set $1D
	db $a4, $4d, $43, $a2  ; set $1E
	db $a4, $61, $79, $76  ; set $1F
	db $a4, $c6, $7c, $41  ; set $20
	db $a4, $c5, $6e, $6f  ; set $21
	db $a4, $c5, $ff, $70  ; set $22
	db $a4, $61, $ff, $71  ; set $23
	db $a4, $61, $ff, $72  ; set $24
	db $a4, $61, $79, $73  ; set $25
	db $a4, $61, $79, $ff  ; set $26
	db $a4, $e3, $79, $76  ; set $27
	db $a4, $42, $82, $a2  ; set $28
	db $a4, $42, $ff, $ff  ; set $29
	db $a4, $61, $78, $a2  ; set $2A
	db $a4, $81, $8f, $e7  ; set $2B
	db $a4, $e3, $8b, $8c  ; set $2C
	db $a4, $87, $78, $a2  ; set $2D
	db $a4, $6c, $7c, $c8  ; set $2E
	db $a4, $c4, $e6, $cf  ; set $2F
	db $a4, $ff, $6e, $6f  ; set $30
	db $a4, $ff, $e6, $cf  ; set $31
	db $a4, $ff, $83, $ff  ; set $32
	db $a4, $c4, $79, $76  ; set $33
	db $a4, $c4, $ff, $ff  ; set $34
	db $a4, $c4, $43, $cf  ; set $35
	db $a4, $ff, $79, $ff  ; set $36
	db $a4, $ff, $ff, $a2  ; set $37
	db $a4, $61, $79, $a2  ; set $38
	db $a4, $e5, $ff, $ff  ; set $39
	db $a4, $e5, $82, $a2  ; set $3A
	db $a4, $e3, $83, $a2  ; set $3B
	db $a4, $91, $83, $76  ; set $3C
	db $a4, $ff, $7c, $a2  ; set $3D
	db $a4, $e3, $8b, $a2  ; set $3E
	db $a4, $e3, $ff, $76  ; set $3F
	db $a4, $ff, $e6, $a2  ; set $40
	db $a4, $ff, $7c, $a2  ; set $41
	db $a4, $81, $e3, $d4  ; set $42
	db $a4, $e5, $e6, $dc  ; set $43
	db $a4, $87, $d6, $d7  ; set $44
	db $a4, $50, $51, $a2  ; set $45
	db $a4, $6c, $8f, $a2  ; set $46
	db $a4, $4a, $83, $a2  ; set $47
	db $a4, $4a, $83, $ff  ; set $48
	db $a4, $81, $8f, $76  ; set $49
	db $a4, $e3, $8b, $ff  ; set $4A
	db $a4, $ff, $79, $ff  ; set $4B
	db $a4, $81, $6e, $ff  ; set $4C
	db $a4, $81, $6e, $8c  ; set $4D
	db $a4, $87, $8f, $76  ; set $4E
	db $a4, $ff, $8f, $ff  ; set $4F
	db $a4, $87, $ff, $ff  ; set $50
	db $a4, $87, $83, $76  ; set $51
	db $a4, $87, $83, $98  ; set $52
	db $a4, $ff, $79, $76  ; set $53
	db $a4, $e3, $83, $a2  ; set $54
	db $a4, $61, $79, $93  ; set $55
	db $a4, $ff, $79, $93  ; set $56
	db $a4, $c4, $79, $ff  ; set $57
	db $a4, $ff, $92, $5a  ; set $58
	db $a4, $61, $92, $8c  ; set $59
	db $a4, $42, $92, $ff  ; set $5A
	db $a4, $61, $ff, $ff  ; set $5B
	db $a4, $61, $ff, $8c  ; set $5C
	db $a4, $ff, $83, $93  ; set $5D
	db $a4, $61, $8b, $ff  ; set $5E
	db $a4, $e3, $ff, $ff  ; set $5F
	db $a4, $61, $ff, $67  ; set $60
	db $a4, $ff, $ff, $a2  ; set $61
	db $a4, $87, $e3, $93  ; set $62
	db $a4, $87, $ff, $ff  ; set $63
	db $a4, $87, $92, $5a  ; set $64
	db $a4, $c6, $9c, $98  ; set $65
	db $a4, $c6, $9c, $ff  ; set $66
	db $a4, $ff, $9c, $93  ; set $67
	db $a4, $81, $ff, $ff  ; set $68
	db $a4, $ff, $9c, $98  ; set $69
	db $a4, $ff, $83, $ff  ; set $6A
	db $a4, $81, $ff, $93  ; set $6B
	db $a4, $81, $9c, $93  ; set $6C
	db $a4, $44, $9c, $98  ; set $6D
	db $a4, $91, $78, $a2  ; set $6E
	db $a4, $ff, $78, $a2  ; set $6F
	db $a4, $61, $ff, $a2  ; set $70
	db $a4, $ff, $79, $a2  ; set $71
	db $a4, $61, $83, $ff  ; set $72
	db $a4, $ff, $83, $a2  ; set $73
	db $a4, $ff, $7c, $ff  ; set $74
	db $a4, $e3, $8b, $a2  ; set $75
	db $a4, $e3, $83, $ff  ; set $76
	db $a4, $ff, $83, $76  ; set $77
	db $a4, $61, $83, $ff  ; set $78
	db $a4, $61, $ff, $76  ; set $79
	db $a4, $61, $ff, $a2  ; set $7A
	db $a4, $81, $6e, $ff  ; set $7B
	db $a4, $81, $ff, $8c  ; set $7C
	db $a4, $4a, $7c, $93  ; set $7D
	db $a4, $91, $7c, $a2  ; set $7E
	db $a4, $4d, $7c, $ff  ; set $7F
	db $a4, $ff, $ff, $ff  ; set $80
	db $a4, $ff, $ff, $ff  ; set $81
	db $a4, $ff, $ff, $ff  ; set $82
	db $a4, $ff, $ff, $ff  ; set $83
	db $a4, $ff, $ff, $ff  ; set $84
	db $a4, $ff, $ff, $ff  ; set $85
	db $a4, $ff, $ff, $ff  ; set $86
	db $a4, $ff, $ff, $ff  ; set $87
	db $a4, $ff, $ff, $ff  ; set $88
	db $a4, $ff, $ff, $ff  ; set $89
	db $a4, $ff, $ff, $ff  ; set $8A
	db $a4, $ff, $ff, $ff  ; set $8B
	db $a4, $ff, $ff, $ff  ; set $8C
	db $a4, $ff, $ff, $ff  ; set $8D
	db $a4, $ff, $ff, $ff  ; set $8E
	db $a4, $ff, $ff, $ff  ; set $8F
	db $a4, $81, $8f, $d4  ; set $90
	db $a4, $81, $79, $ff  ; set $91

;@ path: world/indoor/entities
;@ Entity graphics sets of the indoor rooms, 4 bytes each (see OverworldSpritesets).
IndoorSpritesets::
	db $ff, $ff, $ff, $ff  ; set $00
	db $90, $91, $92, $98  ; set $01
	db $90, $91, $ab, $ff  ; set $02
	db $90, $91, $92, $93  ; set $03
	db $90, $91, $94, $9f  ; set $04
	db $90, $91, $b0, $b1  ; set $05
	db $90, $91, $9c, $93  ; set $06
	db $90, $91, $97, $9b  ; set $07
	db $ff, $ff, $b6, $b7  ; set $08
	db $a4, $4c, $49, $46  ; set $09
	db $a4, $ff, $45, $6d  ; set $0A
	db $a4, $ff, $47, $48  ; set $0B
	db $a4, $ff, $4c, $4b  ; set $0C
	db $90, $91, $96, $ff  ; set $0D
	db $ff, $ff, $4f, $50  ; set $0E
	db $ff, $ff, $4f, $51  ; set $0F
	db $a4, $87, $84, $89  ; set $10
	db $a4, $ff, $88, $c7  ; set $11
	db $a0, $a1, $84, $83  ; set $12
	db $90, $91, $54, $a6  ; set $13
	db $90, $91, $97, $93  ; set $14
	db $90, $91, $aa, $ff  ; set $15
	db $90, $91, $b4, $b5  ; set $16
	db $90, $91, $9c, $9e  ; set $17
	db $90, $91, $9c, $9d  ; set $18
	db $68, $91, $56, $60  ; set $19
	db $ac, $ad, $ae, $af  ; set $1A
	db $90, $91, $58, $9b  ; set $1B
	db $90, $91, $a6, $59  ; set $1C
	db $ff, $ff, $b8, $b9  ; set $1D
	db $90, $91, $62, $63  ; set $1E
	db $90, $91, $a8, $9f  ; set $1F
	db $a4, $df, $a3, $ff  ; set $20
	db $90, $91, $92, $9a  ; set $21
	db $a4, $5b, $5c, $ff  ; set $22
	db $a6, $91, $97, $9b  ; set $23
	db $90, $91, $9c, $60  ; set $24
	db $ff, $ff, $b2, $b3  ; set $25
	db $a6, $91, $57, $ff  ; set $26
	db $a6, $91, $95, $98  ; set $27
	db $a6, $91, $5e, $60  ; set $28
	db $a6, $91, $aa, $93  ; set $29
	db $a6, $91, $58, $99  ; set $2A
	db $90, $91, $95, $93  ; set $2B
	db $5f, $91, $55, $99  ; set $2C
	db $66, $91, $5e, $59  ; set $2D
	db $66, $91, $54, $59  ; set $2E
	db $8d, $8e, $8f, $6a  ; set $2F
	db $68, $91, $9b, $60  ; set $30
	db $68, $91, $94, $9f  ; set $31
	db $68, $91, $9c, $60  ; set $32
	db $5f, $65, $5d, $64  ; set $33
	db $ff, $91, $55, $ff  ; set $34
	db $5f, $91, $95, $99  ; set $35
	db $5f, $91, $5e, $99  ; set $36
	db $5f, $91, $a9, $ff  ; set $37
	db $5f, $91, $94, $9f  ; set $38
	db $90, $91, $55, $93  ; set $39
	db $a4, $ff, $7c, $ff  ; set $3A
	db $bc, $bd, $be, $bf  ; set $3B
	db $a6, $91, $9c, $9d  ; set $3C
	db $ff, $d5, $78, $53  ; set $3D
	db $90, $91, $ff, $ff  ; set $3E
	db $5f, $91, $55, $98  ; set $3F
	db $a4, $ff, $ff, $69  ; set $40
	db $a4, $ff, $4c, $74  ; set $41
	db $a0, $a1, $75, $4e  ; set $42
	db $a4, $7d, $7e, $7f  ; set $43
	db $a4, $ff, $ff, $c7  ; set $44
	db $c0, $c1, $c2, $c3  ; set $45
	db $a4, $cc, $cd, $ce  ; set $46
	db $a4, $c9, $ca, $cb  ; set $47
	db $a4, $d1, $d2, $6a  ; set $48
	db $dd, $e5, $d3, $dd  ; set $49
	db $dd, $ff, $de, $ff  ; set $4A
	db $a4, $8d, $ff, $ff  ; set $4B
	db $ff, $df, $49, $ff  ; set $4C
	db $ff, $c4, $ff, $ff  ; set $4D
	db $a4, $80, $7c, $a5  ; set $4E
	db $ff, $ff, $ff, $ff  ; set $4F
	db $ff, $ff, $ba, $bb  ; set $50
	db $77, $91, $a7, $ff  ; set $51
	db $7b, $91, $7a, $ab  ; set $52
	db $7b, $91, $57, $99  ; set $53
	db $77, $91, $7a, $aa  ; set $54
	db $7b, $91, $54, $99  ; set $55
	db $7b, $91, $56, $ff  ; set $56
	db $77, $91, $54, $99  ; set $57
	db $7b, $91, $ff, $ff  ; set $58
	db $5f, $91, $9d, $99  ; set $59
	db $7b, $91, $96, $99  ; set $5A
	db $7b, $91, $7a, $99  ; set $5B
	db $77, $91, $7a, $99  ; set $5C
	db $77, $91, $96, $99  ; set $5D
	db $5f, $91, $55, $93  ; set $5E
	db $ff, $91, $95, $93  ; set $5F
	db $90, $91, $55, $93  ; set $60
	db $a6, $91, $95, $60  ; set $61
	db $a6, $91, $95, $99  ; set $62
	db $5f, $d9, $da, $db  ; set $63
	db $5f, $d9, $da, $64  ; set $64
	db $ff, $91, $90, $76  ; set $65
	db $ff, $91, $90, $98  ; set $66
	db $ff, $4a, $90, $76  ; set $67
	db $5f, $ff, $ff, $ff  ; set $68
	db $ff, $ff, $ff, $ff  ; set $69
	db $ff, $ff, $ff, $ff  ; set $6A
	db $ff, $ff, $ff, $ff  ; set $6B
	db $ff, $ff, $ff, $ff  ; set $6C
	db $ff, $91, $90, $a6  ; set $6D
	db $a4, $ff, $ff, $f4  ; set $6E
	db $e8, $e9, $ea, $eb  ; set $6F
	db $ff, $ff, $ff, $ff  ; set $70
	db $ff, $ff, $ff, $ff  ; set $71
	db $ff, $ff, $ff, $ff  ; set $72
	db $ff, $ff, $ff, $ff  ; set $73
	db $ff, $ff, $ff, $ff  ; set $74
	db $ff, $ff, $ff, $ff  ; set $75
	db $ff, $ff, $ff, $ff  ; set $76
	db $ff, $ff, $ff, $ff  ; set $77
	db $ff, $ff, $ff, $ff  ; set $78
	db $ff, $ff, $ff, $ff  ; set $79
	db $ff, $ff, $ff, $ff  ; set $7A
	db $ff, $ff, $ff, $ff  ; set $7B
	db $ff, $ff, $ff, $ff  ; set $7C
	db $ff, $ff, $ff, $ff  ; set $7D
	db $a4, $ff, $86, $ff  ; set $7E
	db $a4, $ff, $8b, $ff  ; set $7F
	db $a4, $4d, $ff, $ff  ; set $80

;@ path: world/overworld/objects
;@ The four tiles of each overworld object $00-$F4 (the 16 x 16 blocks rooms are built from), 4 bytes per object: top left, top right, bottom left, bottom right tile number. Read by LoadTileset01 and the room scroll drawing.
OverworldObjectTiles::
	db $7c, $7c, $7c, $7c  ; object $00
	db $7d, $7d, $7d, $7d  ; object $01
	db $7e, $7e, $7e, $7e  ; object $02
	db $76, $76, $76, $76  ; object $03
	db $5a, $7f, $7f, $5a  ; object $04
	db $7c, $7c, $7c, $00  ; object $05
	db $7c, $7c, $01, $02  ; object $06
	db $7c, $7c, $03, $7c  ; object $07
	db $0c, $0d, $1c, $1d  ; object $08
	db $72, $73, $73, $72  ; object $09
	db $75, $75, $75, $75  ; object $0A
	db $74, $74, $74, $74  ; object $0B
	db $0f, $0f, $0f, $0f  ; object $0C
	db $0e, $0e, $0e, $0e  ; object $0D
	db $6d, $6d, $6d, $6d  ; object $0E
	db $5a, $7f, $04, $04  ; object $0F
	db $14, $14, $7f, $5a  ; object $10
	db $5a, $15, $7f, $15  ; object $11
	db $05, $7f, $05, $5a  ; object $12
	db $5a, $7f, $7f, $17  ; object $13
	db $5a, $7f, $06, $5a  ; object $14
	db $5a, $07, $7f, $5a  ; object $15
	db $16, $7f, $7f, $5a  ; object $16
	db $5a, $15, $04, $18  ; object $17
	db $05, $7f, $19, $04  ; object $18
	db $14, $08, $7f, $15  ; object $19
	db $09, $14, $05, $5a  ; object $1A
	db $6c, $6c, $6c, $6c  ; object $1B
	db $7f, $7f, $7f, $7f  ; object $1C
	db $7d, $7d, $16, $5c  ; object $1D
	db $6c, $6d, $6e, $6f  ; object $1E
	db $6e, $6f, $6e, $6f  ; object $1F
	db $f0, $f2, $f1, $f3  ; object $20
	db $0e, $01, $10, $11  ; object $21
	db $4a, $4b, $5a, $5b  ; object $22
	db $0e, $0f, $1e, $1f  ; object $23
	db $0a, $0b, $1a, $1b  ; object $24
	db $20, $21, $30, $31  ; object $25
	db $22, $23, $32, $33  ; object $26
	db $24, $25, $34, $35  ; object $27
	db $26, $27, $36, $37  ; object $28
	db $28, $21, $30, $31  ; object $29
	db $22, $29, $32, $33  ; object $2A
	db $4c, $4a, $48, $5c  ; object $2B
	db $4a, $4a, $45, $45  ; object $2C
	db $4a, $4d, $5d, $59  ; object $2D
	db $48, $51, $44, $56  ; object $2E
	db $45, $45, $55, $56  ; object $2F
	db $0c, $0d, $1c, $1d  ; object $30
	db $4e, $49, $45, $52  ; object $31
	db $49, $4f, $51, $45  ; object $32
	db $48, $51, $54, $56  ; object $33
	db $52, $59, $55, $57  ; object $34
	db $45, $2a, $55, $3a  ; object $35
	db $2b, $45, $3b, $56  ; object $36
	db $48, $49, $48, $49  ; object $37
	db $49, $59, $49, $59  ; object $38
	db $44, $56, $54, $56  ; object $39
	db $55, $56, $55, $56  ; object $3A
	db $55, $47, $55, $57  ; object $3B
	db $45, $41, $43, $49  ; object $3C
	db $42, $45, $49, $40  ; object $3D
	db $44, $56, $44, $56  ; object $3E
	db $55, $47, $55, $47  ; object $3F
	db $09, $7c, $16, $0d  ; object $40
	db $7c, $7c, $1d, $1e  ; object $41
	db $7c, $19, $1f, $18  ; object $42
	db $74, $74, $56, $56  ; object $43
	db $6e, $5a, $5a, $6f  ; object $44
	db $50, $53, $46, $58  ; object $45
	db $43, $49, $48, $49  ; object $46
	db $49, $40, $49, $59  ; object $47
	db $45, $2a, $55, $56  ; object $48
	db $2b, $45, $55, $56  ; object $49
	db $7f, $7f, $56, $56  ; object $4A
	db $48, $49, $45, $52  ; object $4B
	db $49, $59, $51, $45  ; object $4C
	db $7c, $7c, $45, $45  ; object $4D
	db $52, $59, $55, $47  ; object $4E
	db $02, $1e, $12, $13  ; object $4F
	db $7d, $7d, $45, $45  ; object $50
	db $0a, $0b, $1a, $1b  ; object $51
	db $5e, $5e, $5f, $5f  ; object $52
	db $5b, $5b, $5b, $5b  ; object $53
	db $08, $09, $18, $19  ; object $54
	db $06, $07, $09, $7c  ; object $55
	db $07, $08, $7c, $19  ; object $56
	db $09, $7c, $16, $17  ; object $57
	db $7c, $19, $17, $18  ; object $58
	db $7c, $7c, $17, $17  ; object $59
	db $07, $07, $7c, $7c  ; object $5A
	db $2c, $2d, $3c, $3d  ; object $5B
	db $f4, $f6, $f5, $f7  ; object $5C
	db $7d, $7d, $5d, $17  ; object $5D
	db $02, $03, $12, $13  ; object $5E
	db $04, $05, $04, $05  ; object $5F
	db $04, $05, $14, $15  ; object $60
	db $0a, $0b, $1a, $1b  ; object $61
	db $0c, $0c, $1c, $1c  ; object $62
	db $10, $7f, $12, $7f  ; object $63
	db $7f, $7f, $0e, $7f  ; object $64
	db $0e, $11, $7f, $13  ; object $65
	db $04, $05, $14, $15  ; object $66
	db $06, $07, $16, $17  ; object $67
	db $08, $09, $18, $19  ; object $68
	db $0a, $0b, $1a, $1b  ; object $69
	db $0a, $0a, $0a, $0a  ; object $6A
	db $0a, $0a, $1a, $1a  ; object $6B
	db $0b, $0b, $1b, $1b  ; object $6C
	db $00, $01, $0e, $1e  ; object $6D
	db $42, $41, $51, $52  ; object $6E
	db $38, $39, $54, $57  ; object $6F
	db $0a, $0b, $1a, $1b  ; object $70
	db $04, $7f, $04, $0e  ; object $71
	db $00, $01, $04, $11  ; object $72
	db $02, $03, $12, $05  ; object $73
	db $07, $06, $06, $07  ; object $74
	db $07, $0b, $06, $1b  ; object $75
	db $0e, $06, $1e, $07  ; object $76
	db $0f, $1f, $0f, $1f  ; object $77
	db $0d, $0d, $1c, $1c  ; object $78
	db $1c, $1c, $1d, $1d  ; object $79
	db $0d, $0d, $1d, $1d  ; object $7A
	db $0c, $0c, $0c, $0c  ; object $7B
	db $7c, $0a, $0a, $7f  ; object $7C
	db $1a, $7c, $7f, $1a  ; object $7D
	db $1a, $0a, $7f, $7f  ; object $7E
	db $0e, $05, $7f, $05  ; object $7F
	db $7c, $7c, $06, $5c  ; object $80
	db $7c, $7c, $5d, $07  ; object $81
	db $24, $25, $0e, $0f  ; object $82
	db $26, $27, $10, $11  ; object $83
	db $12, $7c, $00, $00  ; object $84
	db $01, $01, $7c, $12  ; object $85
	db $02, $7c, $02, $12  ; object $86
	db $12, $03, $7c, $03  ; object $87
	db $12, $7c, $7c, $04  ; object $88
	db $12, $7c, $05, $12  ; object $89
	db $12, $06, $7c, $12  ; object $8A
	db $07, $7c, $7c, $12  ; object $8B
	db $12, $03, $00, $09  ; object $8C
	db $02, $7c, $08, $00  ; object $8D
	db $01, $0b, $7c, $03  ; object $8E
	db $0a, $01, $02, $12  ; object $8F
	db $12, $7c, $7c, $12  ; object $90
	db $00, $6c, $10, $6d  ; object $91
	db $12, $7c, $13, $14  ; object $92
	db $0b, $0b, $1b, $1b  ; object $93
	db $00, $0b, $10, $1b  ; object $94
	db $0b, $01, $1b, $11  ; object $95
	db $0b, $0b, $0b, $0b  ; object $96
	db $00, $0b, $00, $0b  ; object $97
	db $0b, $01, $0b, $01  ; object $98
	db $09, $09, $19, $19  ; object $99
	db $08, $18, $08, $18  ; object $9A
	db $02, $09, $08, $04  ; object $9B
	db $09, $03, $05, $18  ; object $9C
	db $08, $14, $12, $19  ; object $9D
	db $15, $18, $19, $13  ; object $9E
	db $02, $03, $08, $18  ; object $9F
	db $60, $61, $70, $71  ; object $A0
	db $62, $63, $70, $71  ; object $A1
	db $00, $01, $00, $01  ; object $A2
	db $08, $18, $12, $13  ; object $A3
	db $0b, $0b, $0b, $1e  ; object $A4
	db $0b, $0b, $1e, $1e  ; object $A5
	db $0b, $0b, $1e, $0b  ; object $A6
	db $0b, $1e, $1b, $1e  ; object $A7
	db $1e, $0b, $1e, $1b  ; object $A8
	db $14, $7f, $0b, $1b  ; object $A9
	db $7f, $0e, $1e, $1e  ; object $AA
	db $0a, $0a, $1a, $1a  ; object $AB
	db $1a, $1a, $1a, $1a  ; object $AC
	db $1e, $1e, $09, $08  ; object $AD
	db $09, $04, $19, $14  ; object $AE
	db $1e, $1e, $18, $08  ; object $AF
	db $05, $04, $15, $14  ; object $B0
	db $1e, $1e, $18, $09  ; object $B1
	db $05, $09, $15, $19  ; object $B2
	db $0e, $0f, $0f, $0e  ; object $B3
	db $1e, $1e, $09, $09  ; object $B4
	db $09, $09, $19, $19  ; object $B5
	db $00, $01, $10, $11  ; object $B6
	db $02, $03, $12, $13  ; object $B7
	db $06, $07, $16, $17  ; object $B8
	db $0c, $0d, $1c, $1d  ; object $B9
	db $fc, $fd, $fe, $ff  ; object $BA
	db $04, $05, $14, $15  ; object $BB
	db $06, $07, $16, $17  ; object $BC
	db $08, $09, $18, $19  ; object $BD
	db $0a, $0b, $1a, $1b  ; object $BE
	db $7f, $15, $1c, $0c  ; object $BF
	db $02, $03, $0d, $1d  ; object $C0
	db $7f, $7f, $0f, $0f  ; object $C1
	db $0c, $0c, $1c, $1c  ; object $C2
	db $02, $01, $12, $11  ; object $C3
	db $0e, $0f, $1e, $1f  ; object $C4
	db $0e, $0f, $1e, $1f  ; object $C5
	db $68, $69, $77, $4b  ; object $C6
	db $0f, $01, $10, $11  ; object $C7
	db $08, $09, $18, $19  ; object $C8
	db $02, $1f, $12, $13  ; object $C9
	db $0e, $1e, $1e, $0e  ; object $CA
	db $7e, $7e, $1f, $1f  ; object $CB
	db $6a, $6b, $7a, $7b  ; object $CC
	db $04, $05, $14, $15  ; object $CD
	db $06, $07, $16, $17  ; object $CE
	db $6c, $6c, $6c, $6c  ; object $CF
	db $6d, $6d, $6d, $6d  ; object $D0
	db $6e, $6e, $6e, $6e  ; object $D1
	db $6f, $6f, $6f, $6f  ; object $D2
	db $f4, $f6, $f5, $f7  ; object $D3
	db $f8, $fa, $f9, $fb  ; object $D4
	db $0a, $0b, $1a, $1b  ; object $D5
	db $0c, $0d, $1c, $1d  ; object $D6
	db $0e, $0f, $1e, $1f  ; object $D7
	db $45, $45, $55, $56  ; object $D8
	db $6d, $6d, $6d, $6d  ; object $D9
	db $4a, $4a, $45, $45  ; object $DA
	db $0c, $0d, $1c, $1d  ; object $DB
	db $6e, $5a, $5a, $6f  ; object $DC
	db $49, $40, $49, $59  ; object $DD
	db $43, $49, $48, $49  ; object $DE
	db $00, $00, $00, $00  ; object $DF
	db $5b, $5b, $5b, $5b  ; object $E0
	db $64, $65, $66, $67  ; object $E1
	db $2e, $2f, $3e, $3f  ; object $E2
	db $7e, $7e, $1f, $1f  ; object $E3
	db $15, $16, $17, $18  ; object $E4
	db $7d, $7d, $7d, $7d  ; object $E5
	db $74, $0c, $74, $1c  ; object $E6
	db $1e, $1e, $7e, $7e  ; object $E7
	db $68, $69, $78, $79  ; object $E8
	db $6e, $6e, $6e, $6e  ; object $E9
	db $48, $49, $48, $5f  ; object $EA
	db $6c, $6c, $6c, $6c  ; object $EB
	db $6d, $6d, $6d, $6d  ; object $EC
	db $6f, $6f, $6f, $6f  ; object $ED
	db $6e, $6e, $6e, $6e  ; object $EE
	db $6f, $6f, $7d, $7d  ; object $EF
	db $48, $7f, $48, $7f  ; object $F0
	db $48, $5e, $48, $49  ; object $F1
	db $49, $59, $5f, $59  ; object $F2
	db $7f, $59, $7f, $59  ; object $F3
	db $5e, $59, $49, $59  ; object $F4
;@ path: world/indoor/objects
;@ The four tiles of each indoor object $00-$EB, 4 bytes per object (top left, top right, bottom left, bottom right).
IndoorObjectTiles::
	db $7f, $7f, $7f, $7f  ; object $00
	db $7e, $7e, $7e, $7e  ; object $01
	db $7d, $7d, $7d, $7d  ; object $02
	db $7c, $7c, $7c, $7c  ; object $03
	db $7e, $7e, $7e, $7e  ; object $04
	db $5a, $5a, $5a, $5a  ; object $05
	db $6e, $6f, $6f, $6e  ; object $06
	db $7c, $7d, $7d, $7c  ; object $07
	db $10, $29, $12, $39  ; object $08
	db $2a, $2b, $12, $13  ; object $09
	db $10, $11, $2a, $2b  ; object $0A
	db $3a, $3b, $12, $13  ; object $0B
	db $10, $11, $3a, $3b  ; object $0C
	db $10, $11, $12, $13  ; object $0D
	db $6d, $6d, $6d, $6d  ; object $0E
	db $18, $19, $1a, $1b  ; object $0F
	db $10, $68, $12, $68  ; object $10
	db $68, $11, $68, $13  ; object $11
	db $68, $68, $12, $13  ; object $12
	db $10, $11, $68, $68  ; object $13
	db $10, $68, $68, $68  ; object $14
	db $68, $11, $68, $68  ; object $15
	db $68, $68, $12, $68  ; object $16
	db $68, $68, $68, $13  ; object $17
	db $1c, $1d, $1e, $1f  ; object $18
	db $10, $68, $68, $13  ; object $19
	db $68, $11, $12, $68  ; object $1A
	db $6c, $6c, $6c, $6c  ; object $1B
	db $48, $48, $48, $48  ; object $1C
	db $76, $76, $49, $49  ; object $1D
	db $76, $76, $48, $48  ; object $1E
	db $48, $48, $49, $49  ; object $1F
	db $f0, $f2, $f1, $f3  ; object $20
	db $28, $28, $38, $38  ; object $21
	db $29, $29, $39, $39  ; object $22
	db $2a, $2b, $2a, $2b  ; object $23
	db $3a, $3b, $3a, $3b  ; object $24
	db $20, $28, $2a, $30  ; object $25
	db $28, $21, $31, $3b  ; object $26
	db $2a, $32, $22, $39  ; object $27
	db $33, $3b, $39, $23  ; object $28
	db $24, $2b, $38, $34  ; object $29
	db $3a, $25, $35, $38  ; object $2A
	db $29, $36, $26, $2b  ; object $2B
	db $37, $29, $3a, $27  ; object $2C
	db $28, $40, $38, $50  ; object $2D
	db $41, $28, $51, $38  ; object $2E
	db $29, $42, $39, $52  ; object $2F
	db $43, $29, $53, $39  ; object $30
	db $2a, $2b, $44, $45  ; object $31
	db $54, $55, $2a, $2b  ; object $32
	db $3a, $3b, $46, $47  ; object $33
	db $56, $57, $3a, $3b  ; object $34
	db $28, $40, $38, $58  ; object $35
	db $41, $28, $59, $38  ; object $36
	db $29, $4a, $39, $52  ; object $37
	db $4b, $29, $53, $39  ; object $38
	db $2a, $2b, $44, $4d  ; object $39
	db $54, $5d, $2a, $2b  ; object $3A
	db $3a, $3b, $4e, $47  ; object $3B
	db $5e, $57, $3a, $3b  ; object $3C
	db $72, $73, $72, $73  ; object $3D
	db $69, $69, $79, $79  ; object $3E
	db $2c, $2c, $3c, $3c  ; object $3F
	db $2d, $2d, $3d, $3d  ; object $40
	db $2e, $2f, $2e, $2f  ; object $41
	db $3e, $3f, $3e, $3f  ; object $42
	db $28, $11, $38, $13  ; object $43
	db $10, $28, $12, $38  ; object $44
	db $29, $66, $39, $52  ; object $45
	db $67, $29, $53, $39  ; object $46
	db $28, $28, $38, $38  ; object $47
	db $29, $29, $39, $39  ; object $48
	db $2a, $2b, $2a, $2b  ; object $49
	db $3a, $3b, $3a, $3b  ; object $4A
	db $08, $09, $18, $19  ; object $4B
	db $7e, $7e, $72, $73  ; object $4C
	db $44, $45, $54, $55  ; object $4D
	db $0c, $0d, $0e, $0f  ; object $4E
	db $00, $01, $02, $03  ; object $4F
	db $04, $05, $12, $11  ; object $50
	db $02, $01, $12, $11  ; object $51
	db $02, $01, $14, $15  ; object $52
	db $04, $05, $10, $11  ; object $53
	db $00, $01, $10, $11  ; object $54
	db $00, $01, $14, $15  ; object $55
	db $04, $05, $10, $13  ; object $56
	db $00, $03, $10, $13  ; object $57
	db $00, $03, $14, $15  ; object $58
	db $06, $07, $12, $11  ; object $59
	db $02, $01, $16, $17  ; object $5A
	db $06, $07, $10, $11  ; object $5B
	db $00, $01, $16, $17  ; object $5C
	db $06, $07, $10, $13  ; object $5D
	db $00, $03, $16, $17  ; object $5E
	db $64, $65, $74, $75  ; object $5F
	db $66, $67, $76, $77  ; object $60
	db $68, $69, $78, $79  ; object $61
	db $0a, $0b, $0a, $0b  ; object $62
	db $0a, $0b, $0a, $0b  ; object $63
	db $1a, $1b, $1a, $1b  ; object $64
	db $1a, $1b, $1a, $1b  ; object $65
	db $1c, $1d, $1c, $1d  ; object $66
	db $1c, $1d, $1c, $1d  ; object $67
	db $0e, $0f, $1e, $1f  ; object $68
	db $08, $09, $18, $19  ; object $69
	db $7e, $7e, $1e, $1f  ; object $6A
	db $7e, $7e, $18, $19  ; object $6B
	db $20, $21, $30, $31  ; object $6C
	db $22, $23, $32, $33  ; object $6D
	db $7e, $7e, $30, $31  ; object $6E
	db $7e, $7e, $32, $33  ; object $6F
	db $24, $25, $34, $35  ; object $70
	db $26, $27, $36, $37  ; object $71
	db $28, $29, $38, $39  ; object $72
	db $7e, $7e, $38, $7e  ; object $73
	db $7e, $7e, $7e, $39  ; object $74
	db $2a, $2b, $3a, $3b  ; object $75
	db $2c, $2d, $3c, $3d  ; object $76
	db $2e, $2f, $3e, $3f  ; object $77
	db $40, $41, $50, $51  ; object $78
	db $42, $43, $52, $53  ; object $79
	db $00, $00, $00, $00  ; object $7A
	db $46, $47, $56, $57  ; object $7B
	db $48, $49, $58, $59  ; object $7C
	db $4a, $4b, $5a, $5b  ; object $7D
	db $4e, $4f, $5e, $5f  ; object $7E
	db $60, $61, $70, $71  ; object $7F
	db $6c, $6c, $7d, $7d  ; object $80
	db $7d, $7d, $7d, $7d  ; object $81
	db $6d, $6e, $0c, $0d  ; object $82
	db $6f, $6f, $7e, $7e  ; object $83
	db $7e, $7e, $7e, $7e  ; object $84
	db $6c, $6d, $6e, $6f  ; object $85
	db $00, $01, $02, $03  ; object $86
	db $04, $05, $06, $07  ; object $87
	db $04, $05, $06, $07  ; object $88
	db $6c, $6d, $6e, $6f  ; object $89
	db $6c, $6d, $6e, $6f  ; object $8A
	db $18, $19, $1a, $1b  ; object $8B
	db $29, $11, $39, $13  ; object $8C
	db $08, $09, $0a, $0b  ; object $8D
	db $f0, $f2, $f1, $f3  ; object $8E
	db $4c, $4d, $5c, $5d  ; object $8F
	db $04, $05, $06, $07  ; object $90
	db $08, $09, $0a, $0b  ; object $91
	db $68, $68, $68, $68  ; object $92
	db $68, $11, $12, $13  ; object $93
	db $10, $68, $12, $13  ; object $94
	db $10, $11, $68, $13  ; object $95
	db $10, $11, $12, $68  ; object $96
	db $78, $78, $78, $78  ; object $97
	db $78, $78, $78, $78  ; object $98
	db $fc, $fd, $fe, $ff  ; object $99
	db $fe, $ff, $12, $13  ; object $9A
	db $0c, $04, $0e, $05  ; object $9B
	db $04, $0d, $05, $0f  ; object $9C
	db $04, $05, $04, $05  ; object $9D
	db $06, $07, $08, $09  ; object $9E
	db $0a, $0b, $06, $07  ; object $9F
	db $60, $61, $70, $71  ; object $A0
	db $62, $63, $70, $71  ; object $A1
	db $0c, $0d, $0e, $0f  ; object $A2
	db $00, $01, $02, $03  ; object $A3
	db $28, $00, $38, $02  ; object $A4
	db $01, $28, $03, $38  ; object $A5
	db $f8, $fa, $f9, $fb  ; object $A6
	db $f8, $fa, $f9, $fb  ; object $A7
	db $0c, $0d, $0e, $0f  ; object $A8
	db $fc, $fe, $fd, $ff  ; object $A9
	db $14, $15, $16, $17  ; object $AA
	db $64, $65, $74, $75  ; object $AB
	db $6c, $6d, $74, $75  ; object $AC
	db $7c, $7c, $7c, $7c  ; object $AD
	db $76, $76, $77, $77  ; object $AE
	db $76, $76, $7e, $7e  ; object $AF
	db $7e, $7e, $77, $77  ; object $B0
	db $28, $00, $38, $02  ; object $B1
	db $01, $28, $03, $38  ; object $B2
	db $10, $0b, $12, $0b  ; object $B3
	db $0b, $0b, $06, $06  ; object $B4
	db $0b, $11, $0b, $13  ; object $B5
	db $10, $0b, $12, $00  ; object $B6
	db $06, $07, $01, $09  ; object $B7
	db $08, $06, $09, $00  ; object $B8
	db $0b, $11, $01, $13  ; object $B9
	db $29, $02, $39, $04  ; object $BA
	db $03, $0a, $05, $7f  ; object $BB
	db $0a, $02, $7f, $04  ; object $BC
	db $03, $29, $05, $39  ; object $BD
	db $6a, $6b, $7a, $7b  ; object $BE
	db $6a, $6b, $7a, $7b  ; object $BF
	db $f4, $f6, $f5, $f7  ; object $C0
	db $00, $7f, $01, $7f  ; object $C1
	db $7f, $02, $7f, $03  ; object $C2
	db $00, $00, $01, $01  ; object $C3
	db $02, $02, $03, $03  ; object $C4
	db $08, $09, $0a, $0b  ; object $C5
	db $0a, $0b, $06, $07  ; object $C6
	db $6e, $6e, $4c, $4c  ; object $C7
	db $4f, $4f, $6e, $6e  ; object $C8
	db $6e, $5c, $6e, $5c  ; object $C9
	db $5f, $6e, $5f, $6e  ; object $CA
	db $08, $09, $0a, $0b  ; object $CB
	db $04, $05, $06, $07  ; object $CC
	db $0b, $0b, $12, $13  ; object $CD
	db $0c, $0d, $0e, $0f  ; object $CE
	db $0c, $0c, $0c, $0c  ; object $CF
	db $0d, $0d, $0d, $0d  ; object $D0
	db $0e, $0e, $0e, $0e  ; object $D1
	db $0f, $0f, $0f, $0f  ; object $D2
	db $7f, $7f, $0b, $0b  ; object $D3
	db $6f, $6f, $6f, $6f  ; object $D4
	db $08, $08, $09, $0b  ; object $D5
	db $08, $08, $0b, $0a  ; object $D6
	db $05, $07, $04, $04  ; object $D7
	db $07, $06, $04, $04  ; object $D8
	db $6a, $6b, $7a, $7b  ; object $D9
	db $5b, $5b, $5b, $5b  ; object $DA
	db $04, $05, $06, $07  ; object $DB
	db $08, $09, $0a, $0b  ; object $DC
	db $0c, $0d, $0e, $0f  ; object $DD
	db $0c, $0d, $0e, $0f  ; object $DE
	db $1c, $1d, $1e, $1f  ; object $DF
	db $0e, $0f, $1e, $1f  ; object $E0
	db $20, $21, $30, $31  ; object $E1
	db $22, $23, $32, $33  ; object $E2
	db $6a, $7a, $50, $61  ; object $E3
	db $7a, $7a, $44, $45  ; object $E4
	db $7a, $6b, $4c, $53  ; object $E5
	db $4c, $4d, $5c, $5d  ; object $E6
	db $00, $01, $02, $03  ; object $E7
	db $04, $05, $06, $07  ; object $E8
	db $08, $09, $0a, $0b  ; object $E9
	db $0c, $0d, $0e, $0f  ; object $EA
	db $00, $00, $00, $00  ; object $EB
;@ path: object/physics
;@ The physics kind of each overworld object $00-$FF (GetObjectPhysics with d = 0): what Link and the entities do with that block - $00 nothing (floor), $01 solid, and other values for water, pits, ledges, stairs, bushes, grass, ...
OverworldObjectPhysics::
	db $01, $00, $00, $00, $00, $01, $01, $01, $00, $00, $06, $00, $00, $00, $07, $00  ; object $00-$0F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $01, $01, $05, $04  ; object $10-$1F
	db $30, $01, $01, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01  ; object $20-$2F
	db $05, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01  ; object $30-$3F
	db $01, $01, $01, $10, $00, $01, $01, $01, $01, $01, $10, $01, $01, $01, $01, $01  ; object $40-$4F
	db $01, $01, $01, $0a, $c0, $01, $01, $01, $01, $01, $01, $01, $30, $01, $01, $01  ; object $50-$5F
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $60, $01  ; object $60-$6F
	db $c0, $01, $01, $01, $01, $01, $01, $02, $08, $08, $08, $50, $01, $01, $01, $01  ; object $70-$7F
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01  ; object $80-$8F
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01  ; object $90-$9F
	db $60, $60, $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01  ; object $A0-$AF
	db $01, $01, $01, $00, $01, $01, $01, $01, $01, $00, $99, $01, $01, $01, $01, $01  ; object $B0-$BF
	db $c0, $01, $01, $01, $01, $01, $09, $01, $60, $01, $01, $03, $09, $01, $01, $f4  ; object $C0-$CF
	db $f5, $f6, $f7, $30, $60, $01, $01, $01, $01, $07, $01, $08, $00, $01, $01, $01  ; object $D0-$DF
	db $02, $03, $03, $03, $01, $01, $81, $03, $50, $01, $01, $07, $07, $07, $07, $50  ; object $E0-$EF
	db $d1, $01, $01, $d0, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $ff  ; object $F0-$FF
;@ path: object/physics
;@ The physics kind of each indoor object $00-$FF (GetObjectPhysics with d = 1; values as in OverworldObjectPhysics).
IndoorObjectPhysics::
	db $00, $50, $00, $00, $00, $00, $0b, $00, $7d, $7e, $7f, $7e, $7f, $00, $07, $00  ; object $00-$0F
	db $81, $80, $82, $83, $84, $85, $86, $87, $00, $8c, $8d, $05, $51, $51, $51, $51  ; object $10-$1F
	db $30, $d3, $d2, $d0, $d1, $01, $01, $01, $01, $01, $01, $01, $01, $90, $90, $91  ; object $20-$2F
	db $91, $92, $92, $93, $93, $d3, $d3, $d2, $d2, $d0, $d0, $d1, $d1, $00, $00, $99  ; object $30-$3F
	db $9a, $9b, $9c, $7c, $7d, $01, $01, $99, $9a, $9b, $9c, $b0, $00, $00, $60, $60  ; object $40-$4F
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01  ; object $50-$5F
	db $01, $01, $b1, $b1, $b1, $b1, $b1, $b0, $01, $00, $00, $00, $01, $01, $00, $00  ; object $60-$6F
	db $00, $00, $b0, $b0, $b0, $00, $00, $00, $00, $00, $00, $01, $00, $b0, $b0, $00  ; object $70-$7F
	db $b0, $b0, $00, $b0, $b0, $b0, $01, $01, $60, $00, $01, $01, $7c, $00, $30, $60  ; object $80-$8F
	db $01, $01, $00, $88, $89, $8a, $8b, $0a, $02, $01, $7e, $01, $01, $00, $00, $00  ; object $90-$9F
	db $60, $60, $03, $03, $98, $98, $60, $60, $03, $30, $00, $01, $01, $01, $50, $50  ; object $A0-$AF
	db $50, $7c, $7d, $00, $00, $00, $8b, $8a, $8b, $8a, $01, $7c, $7d, $01, $00, $00  ; object $B0-$BF
	db $01, $7c, $7d, $01, $01, $01, $01, $d3, $d2, $d0, $d1, $08, $09, $7e, $01, $f0  ; object $C0-$CF
	db $f1, $f2, $f3, $7f, $e0, $01, $01, $01, $01, $60, $00, $04, $04, $30, $01, $00  ; object $D0-$DF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01  ; object $E0-$EF
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $fe, $ff  ; object $F0-$FF
;@ path: gfx/bgmap/layouts
;@ Screen layout $15 (wBGMapToLoad = $15, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout15::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $00, $01, $02, $03, $00, $01, $02, $03, $00, $01, $02, $03, $00, $01, $02, $03
	db $00, $01, $02, $03
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $10, $11, $12, $13, $10, $11, $12, $13, $10, $11, $12, $13, $10, $11, $12, $13
	db $10, $11, $12, $13
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $02, $03, $04, $05, $06, $07, $06, $07, $07, $06, $06, $07, $06, $07, $07, $07
	db $06, $08, $00, $01
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $12, $13, $09, $0a, $0b, $14, $0c, $0d, $0e, $0f, $0b, $15, $14, $15, $0b, $14
	db $16, $17, $10, $11
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $00, $03, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $1e, $20, $22
	db $24, $25, $00, $03
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $10, $13, $26, $27, $28, $29, $2a, $2b, $2c, $22, $21, $37, $21, $22, $1f, $20
	db $42, $2d, $10, $13
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $02, $03, $18, $2e, $2f, $30, $42, $1d, $40, $21, $1f, $22, $20, $1f, $37, $21
	db $40, $31, $00, $01
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $12, $13, $32, $33, $34, $42, $35, $36, $1d, $22, $20, $1f, $39, $37, $38, $39
	db $42, $2d, $10, $11
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $00, $03, $3a, $3b, $2b, $2c, $3c, $1d, $3d, $3e, $3f, $42, $40, $40, $40, $40
	db $3c, $31, $00, $03
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $10, $13, $18, $41, $42, $3c, $1d, $42, $43, $44, $45, $40, $42, $40, $42, $1d
	db $46, $31, $10, $13
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $02, $03, $18, $47, $48, $49, $4a, $4b, $48, $49, $4a, $4c, $4d, $4e, $3c, $4f
	db $50, $2d, $00, $01
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $12, $13, $51, $52, $53, $54, $55, $56, $57, $58, $56, $58, $59, $5a, $5b, $5c
	db $5d, $2d, $10, $11
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $02, $03, $5e, $5f, $60, $61, $62, $63, $64, $65, $63, $64, $66, $67, $68, $69
	db $6a, $31, $00, $03
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $10, $13, $18, $6b, $6c, $6d, $70, $6e, $6f, $70, $6e, $6f, $71, $72, $42, $73
	db $50, $2d, $10, $13
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $02, $03, $26, $41, $42, $1d, $3c, $1d, $74, $75, $76, $1d, $40, $1d, $35, $36
	db $77, $78, $00, $01
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $12, $13, $79, $10, $7b, $7a, $7b, $7a, $7c, $7d, $23, $7a, $7b, $7b, $7a, $7a
	db $7f, $13, $10, $11
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $00, $01, $02, $03, $00, $01, $02, $03, $00, $01, $02, $03, $00, $01, $02, $03
	db $00, $01, $02, $03
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $10, $11, $12, $13, $10, $11, $12, $13, $10, $11, $12, $13, $10, $11, $12, $13
	db $10, $11, $12, $13
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $12 (wBGMapToLoad = $12, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout12::
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $05
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $05
	db $98, $40, $53  ; BG map 0, row 2, column 0: 20 tiles repeated across
	db $05
	db $98, $60, $53  ; BG map 0, row 3, column 0: 20 tiles repeated across
	db $05
	db $98, $80, $53  ; BG map 0, row 4, column 0: 20 tiles repeated across
	db $05
	db $98, $a0, $53  ; BG map 0, row 5, column 0: 20 tiles repeated across
	db $05
	db $98, $c0, $53  ; BG map 0, row 6, column 0: 20 tiles repeated across
	db $05
	db $98, $e0, $53  ; BG map 0, row 7, column 0: 20 tiles repeated across
	db $05
	db $99, $00, $53  ; BG map 0, row 8, column 0: 20 tiles repeated across
	db $05
	db $99, $20, $53  ; BG map 0, row 9, column 0: 20 tiles repeated across
	db $05
	db $99, $40, $53  ; BG map 0, row 10, column 0: 20 tiles repeated across
	db $05
	db $99, $60, $53  ; BG map 0, row 11, column 0: 20 tiles repeated across
	db $05
	db $99, $80, $53  ; BG map 0, row 12, column 0: 20 tiles repeated across
	db $05
	db $99, $a0, $53  ; BG map 0, row 13, column 0: 20 tiles repeated across
	db $05
	db $99, $c0, $53  ; BG map 0, row 14, column 0: 20 tiles repeated across
	db $05
	db $99, $e0, $53  ; BG map 0, row 15, column 0: 20 tiles repeated across
	db $05
	db $9a, $00, $53  ; BG map 0, row 16, column 0: 20 tiles repeated across
	db $05
	db $9a, $20, $53  ; BG map 0, row 17, column 0: 20 tiles repeated across
	db $05
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $05
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $05
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7b, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7e, $05
	db $05, $05, $05, $05
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $00, $01, $02, $03, $04, $05, $06, $07, $7f, $05
	db $05, $05, $05, $05
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $10, $11, $12, $13, $14, $15, $16, $17, $7f, $05
	db $05, $05, $05, $05
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $20, $21, $22, $23, $24, $25, $26, $27, $7f, $05
	db $05, $05, $05, $05
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $30, $31, $32, $33, $34, $35, $36, $37, $7f, $05
	db $05, $05, $05, $05
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $40, $41, $42, $43, $44, $45, $46, $47, $7f, $05
	db $05, $05, $05, $05
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $50, $51, $52, $53, $54, $55, $56, $57, $7f, $05
	db $05, $05, $05, $05
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $60, $61, $62, $63, $64, $65, $66, $67, $7f, $05
	db $05, $05, $05, $05
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $70, $71, $72, $73, $74, $75, $76, $77, $7f, $05
	db $05, $05, $05, $05
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $7f, $68
	db $05, $05, $05, $05
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7f, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $7f, $78
	db $79, $05, $05, $05
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $7d, $3e, $4d, $4e, $58, $69, $6a, $6b, $6c, $6d, $6e
	db $6f, $05, $05, $05
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $28, $29, $2a, $2b, $2c, $2d
	db $2e, $2f, $05, $05
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $38, $39, $3a, $3b, $3c, $3d
	db $3d, $3f, $05, $05
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $48, $49, $4a, $4b, $4c, $3d
	db $3d, $4f, $05, $05
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $59, $5a, $5b, $5c, $5d
	db $5e, $5f, $05, $05
	db $00  ; end
;@ path: gfx/bgmap/layouts
;@ Screen layout $13 (wBGMapToLoad = $13, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout13::
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $7c
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $7c
	db $98, $40, $53  ; BG map 0, row 2, column 0: 20 tiles repeated across
	db $7c
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $06, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $09
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $7f, $16, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $17, $7f
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $7f, $7f, $06, $07, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $08, $09, $06, $07
	db $08, $09, $7f, $7f
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $0d, $0e, $0f, $20, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $17, $7f, $7f, $16
	db $0a, $0b, $0c, $0d
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $1d, $1e, $1f, $30, $06, $07, $7c, $7c, $7c, $7c, $08, $09, $7f, $7f, $7f, $7f
	db $1a, $1b, $1c, $1d
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $24, $25, $26, $27, $7f, $16, $7c, $7c, $7c, $7c, $17, $7f, $7f, $7f, $7f, $7f
	db $21, $22, $23, $24
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $34, $35, $36, $37, $50, $51, $50, $51, $50, $51, $50, $51, $50, $51, $50, $51
	db $31, $32, $33, $34
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $2b, $2c, $2d, $2e, $52, $53, $52, $53, $52, $53, $52, $53, $52, $53, $52, $53
	db $28, $29, $2a, $2b
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $3b, $3c, $54, $55, $54, $55, $54, $55, $54, $55, $54, $55, $54, $55, $54, $55
	db $54, $55, $3a, $3b
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $3e, $3f, $56, $57, $56, $57, $56, $57, $56, $57, $56, $57, $56, $57, $56, $57
	db $56, $57, $3d, $3e
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $3e, $3f, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01
	db $00, $01, $3d, $3e
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $3e, $3f, $10, $11, $10, $11, $10, $11, $10, $11, $10, $11, $10, $11, $04, $05
	db $10, $11, $3d, $3e
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $43, $44, $45, $46, $04, $05, $02, $18, $19, $38, $39, $4e, $4f, $03, $14, $15
	db $40, $41, $42, $43
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $4a, $4b, $4c, $4d, $14, $15, $12, $13, $12, $13, $12, $13, $12, $13, $12, $13
	db $47, $48, $49, $4a
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $12, $13, $12, $13, $12, $13, $12, $13, $12, $13, $12, $13, $12, $13, $12, $13
	db $12, $13, $12, $13
	db $9a, $40, $53  ; BG map 0, row 18, column 0: 20 tiles repeated across
	db $7c
	db $9a, $60, $53  ; BG map 0, row 19, column 0: 20 tiles repeated across
	db $7c
	db $9a, $80, $53  ; BG map 0, row 20, column 0: 20 tiles repeated across
	db $7c
	db $9a, $a0, $53  ; BG map 0, row 21, column 0: 20 tiles repeated across
	db $7c
	db $9a, $c0, $53  ; BG map 0, row 22, column 0: 20 tiles repeated across
	db $7c
	db $9a, $e0, $53  ; BG map 0, row 23, column 0: 20 tiles repeated across
	db $7c
	db $9b, $00, $53  ; BG map 0, row 24, column 0: 20 tiles repeated across
	db $7c
	db $9b, $20, $53  ; BG map 0, row 25, column 0: 20 tiles repeated across
	db $7c
	db $9b, $40, $53  ; BG map 0, row 26, column 0: 20 tiles repeated across
	db $7c
	db $9b, $60, $53  ; BG map 0, row 27, column 0: 20 tiles repeated across
	db $7c
	db $9b, $80, $53  ; BG map 0, row 28, column 0: 20 tiles repeated across
	db $7c
	db $9b, $a0, $53  ; BG map 0, row 29, column 0: 20 tiles repeated across
	db $7c
	db $9b, $c0, $53  ; BG map 0, row 30, column 0: 20 tiles repeated across
	db $7c
	db $9b, $e0, $53  ; BG map 0, row 31, column 0: 20 tiles repeated across
	db $7c
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $23 (wBGMapToLoad = $23, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout23::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $04, $05, $06, $07, $7f, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $30, $7f, $7f, $40, $7f, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $00, $01, $02, $03, $03, $01, $01, $02, $08, $09, $7f
	db $7f, $7f, $7f, $7f
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $7f
	db $7f, $7f, $7f, $7f
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $7f
	db $7f, $7f, $7f, $7f
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $10, $31, $32, $33, $34, $35, $36, $37, $38, $39, $7f
	db $7f, $7f, $7f, $7f
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $20, $41, $42, $43, $44, $45, $46, $47, $48, $49, $7f
	db $7f, $7f, $7f, $7f
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $7f
	db $7f, $7f, $7f, $7f
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $60, $61, $62, $63, $45, $65, $66, $67, $68, $69, $7f
	db $7f, $7f, $7f, $7f
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $70, $71, $72, $73, $75, $75, $76, $77, $78, $79, $7f
	db $7f, $7f, $7f, $7f
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $0a, $0b, $0c, $0d, $0e, $0f, $77, $4b, $4c, $4d, $7f
	db $7f, $7f, $7f, $7f
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $1a, $1b, $1c, $1d, $1e, $1f, $5a, $5b, $5c, $5d, $7f
	db $7f, $7f, $7f, $7f
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $2a, $2b, $2c, $2d, $2e, $2f, $6a, $6b, $1b, $6d, $7f
	db $7f, $7f, $7f, $7f
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $3a, $3b, $3c, $3d, $3e, $3f, $7a, $7b, $7c, $7d, $7f
	db $7f, $7f, $7f, $7f
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $6e, $4a, $64, $64, $6c, $64, $4a, $4a, $6c, $4a, $64, $6f
	db $7f, $7f, $7f, $7f
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $04, $05, $7f, $4e, $4f, $7f, $06, $07, $7f, $7f
	db $7f, $7f, $7f, $7f
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $30, $7f, $7f, $4e, $4f, $7f, $7f, $40, $7f, $7f
	db $7f, $7f, $7f, $7f
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $40, $7f, $7f, $5e, $5f, $7f, $7f, $30, $7f, $7f
	db $7f, $7f, $7f, $7f
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $24 (wBGMapToLoad = $24, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout24::
	db $9b, $e0, $53  ; BG map 0, row 31, column 0: 20 tiles repeated across
	db $7c
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $7c
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $7c
	db $98, $40, $53  ; BG map 0, row 2, column 0: 20 tiles repeated across
	db $7c
	db $98, $60, $53  ; BG map 0, row 3, column 0: 20 tiles repeated across
	db $7c
	db $98, $80, $53  ; BG map 0, row 4, column 0: 20 tiles repeated across
	db $7c
	db $98, $a0, $53  ; BG map 0, row 5, column 0: 20 tiles repeated across
	db $7c
	db $98, $c0, $53  ; BG map 0, row 6, column 0: 20 tiles repeated across
	db $7c
	db $98, $c0, $03  ; BG map 0, row 6, column 0: 4 tiles across
	db $2a, $2b, $04, $14
	db $98, $ce, $03  ; BG map 0, row 6, column 14: 4 tiles across
	db $2a, $2b, $04, $14
	db $98, $e0, $53  ; BG map 0, row 7, column 0: 20 tiles repeated across
	db $7c
	db $98, $e0, $03  ; BG map 0, row 7, column 0: 4 tiles across
	db $39, $7f, $7f, $1e
	db $98, $ee, $05  ; BG map 0, row 7, column 14: 6 tiles across
	db $39, $7f, $7f, $1e, $3a, $3b
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $7f, $7f, $7f, $7f, $04, $14, $7c, $7c, $2a, $2b, $04, $14, $2a, $2b, $7f, $7f
	db $7f, $7f, $7f, $7f
	db $99, $20, $53  ; BG map 0, row 9, column 0: 20 tiles repeated across
	db $7f
	db $99, $25, $03  ; BG map 0, row 9, column 5: 4 tiles across
	db $1e, $3a, $3b, $39
	db $99, $2b, $01  ; BG map 0, row 9, column 11: 2 tiles across
	db $1e, $39
	db $99, $40, $53  ; BG map 0, row 10, column 0: 20 tiles repeated across
	db $7f
	db $99, $60, $53  ; BG map 0, row 11, column 0: 20 tiles repeated across
	db $7f
	db $99, $80, $53  ; BG map 0, row 12, column 0: 20 tiles repeated across
	db $7f
	db $99, $a0, $53  ; BG map 0, row 13, column 0: 20 tiles repeated across
	db $7f
	db $99, $c0, $53  ; BG map 0, row 14, column 0: 20 tiles repeated across
	db $7f
	db $99, $e0, $53  ; BG map 0, row 15, column 0: 20 tiles repeated across
	db $7f
	db $9a, $00, $53  ; BG map 0, row 16, column 0: 20 tiles repeated across
	db $7f
	db $9a, $20, $53  ; BG map 0, row 17, column 0: 20 tiles repeated across
	db $7f
	db $99, $86, $07  ; BG map 0, row 12, column 6: 8 tiles across
	db $24, $25, $26, $26, $29, $29, $27, $28
	db $99, $a7, $05  ; BG map 0, row 13, column 7: 6 tiles across
	db $34, $35, $36, $36, $37, $38
	db $99, $c7, $05  ; BG map 0, row 14, column 7: 6 tiles across
	db $24, $25, $26, $26, $27, $28
	db $99, $e7, $05  ; BG map 0, row 15, column 7: 6 tiles across
	db $24, $25, $26, $26, $27, $28
	db $9a, $06, $07  ; BG map 0, row 16, column 6: 8 tiles across
	db $24, $25, $26, $26, $29, $29, $27, $28
	db $9a, $26, $07  ; BG map 0, row 17, column 6: 8 tiles across
	db $24, $25, $26, $26, $29, $29, $27, $28
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $1E (wBGMapToLoad = $1E, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout1E::
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $30, $31, $32, $33, $7f, $5a, $74, $74, $7f, $5a, $30, $31
	db $32, $33, $30, $31
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $1a, $5a, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $74, $74
	db $5a, $7f, $24, $25
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5a, $1a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $74, $74
	db $7f, $5a, $34, $35
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5e, $5e, $5e, $5e, $5e, $5e, $5a, $7f, $5a, $7f, $74, $74
	db $5a, $7f, $20, $21
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5f, $5f, $5f, $5f, $5f, $5f, $7f, $5a, $7f, $5a, $74, $74
	db $7f, $5a, $30, $31
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $2c, $2d, $2e, $2f, $2c, $2d, $5a, $7f, $5a, $7f, $74, $74
	db $5a, $7f, $24, $25
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $3c, $3d, $3e, $3f, $3c, $3d, $7f, $5a, $7f, $5a, $74, $74
	db $7f, $5a, $34, $35
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $74, $74, $74, $74
	db $1a, $5a, $20, $21
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $74, $74, $74, $74
	db $5a, $1a, $30, $31
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5a, $7f, $5a, $7f, $5a, $7f, $74, $74, $74, $74, $5a, $7f
	db $14, $16, $24, $25
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $7f, $5a, $7f, $5a, $7f, $5a, $74, $74, $74, $74, $7f, $5a
	db $15, $17, $34, $35
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5a, $7f, $5a, $7f, $5a, $7f, $74, $74, $5a, $7f, $5a, $7f
	db $14, $16, $20, $21
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $7f, $5a, $7f, $5a, $7f, $5a, $74, $74, $7f, $5a, $7f, $5a
	db $15, $17, $30, $31
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $5a, $7f, $5a, $7f, $5a, $7f, $74, $74, $5a, $7f, $5a, $7f
	db $20, $21, $22, $29
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $7f, $5a, $7f, $5a, $7f, $5a, $74, $74, $7f, $5a, $7f, $5a
	db $30, $31, $32, $33
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $20, $21, $22, $23, $5a, $7f, $74, $74, $5a, $7f, $20, $21
	db $22, $29, $28, $21
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $30, $31, $32, $33, $7f, $5a, $74, $74, $7f, $5a, $30, $31
	db $32, $33, $30, $31
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $24, $25, $26, $27, $5a, $7f, $74, $74, $5a, $7f, $24, $25
	db $28, $21, $22, $29
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $1b, $1b, $48, $49, $34, $35, $36, $37, $7f, $5a, $74, $74, $7f, $5a, $34, $35
	db $30, $31, $32, $33
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $1F (wBGMapToLoad = $1F, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout1F::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $26, $27, $5a, $7f, $44, $56, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $55, $56, $55, $56
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $36, $37, $7f, $5a, $54, $56, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $55, $56, $55, $56
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $22, $23, $5a, $7f, $5a, $7f, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef
	db $5a, $7f, $5a, $7f
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $32, $33, $7f, $5a, $7f, $5a, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef
	db $7f, $5a, $7f, $5a
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $26, $27, $5a, $7f, $ef, $ef, $ef, $ef, $1a, $5a, $1a, $5a, $1a, $5a, $ef, $ef
	db $ef, $ef, $5a, $7f
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $36, $37, $7f, $5a, $ef, $ef, $ef, $ef, $5a, $1a, $5a, $1a, $5a, $1a, $ef, $ef
	db $ef, $ef, $7f, $5a
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $22, $23, $5a, $7f, $ef, $ef, $1a, $5a, $ef, $ef, $e0, $e1, $ef, $ef, $1a, $5a
	db $ef, $ef, $5a, $7f
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $32, $33, $7f, $5a, $ef, $ef, $5a, $1a, $ef, $ef, $f0, $f1, $ef, $ef, $5a, $1a
	db $ef, $ef, $7f, $5a
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $26, $27, $5a, $7f, $ef, $ef, $1a, $5a, $ef, $ef, $e2, $e3, $ef, $ef, $1a, $5a
	db $ef, $ef, $5a, $7f
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $36, $37, $7f, $5a, $ef, $ef, $5a, $1a, $ef, $ef, $f2, $f3, $ef, $ef, $5a, $1a
	db $ef, $ef, $7f, $5a
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $22, $23, $5a, $7f, $ef, $ef, $1a, $5a, $ef, $ef, $ef, $ef, $ef, $ef, $1a, $5a
	db $ef, $ef, $5a, $7f
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $32, $33, $7f, $5a, $ef, $ef, $5a, $1a, $ef, $ef, $ef, $ef, $ef, $ef, $5a, $1a
	db $ef, $ef, $7f, $5a
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $26, $27, $5a, $7f, $ef, $ef, $ef, $ef, $1a, $5a, $1a, $5a, $1a, $5a, $ef, $ef
	db $ef, $ef, $74, $74
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $36, $37, $7f, $5a, $ef, $ef, $ef, $ef, $5a, $1a, $5a, $1a, $5a, $1a, $ef, $ef
	db $ef, $ef, $74, $74
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $22, $23, $5a, $7f, $5a, $7f, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef
	db $5a, $7f, $5a, $7f
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $32, $33, $7f, $5a, $7f, $5a, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef
	db $7f, $5a, $7f, $5a
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $26, $27, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f
	db $5a, $7f, $5a, $7f
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $36, $37, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a
	db $7f, $5a, $7f, $5a
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $20 (wBGMapToLoad = $20, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout20::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $24, $25, $26, $27, $24, $25, $26, $27, $75, $75, $75, $75, $75, $75, $24, $25
	db $26, $27, $24, $25
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $34, $35, $36, $37, $34, $35, $36, $37, $75, $75, $75, $75, $75, $75, $34, $35
	db $36, $37, $34, $35
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $74, $74, $74, $74, $e6, $e7, $e7, $e7, $e7, $e8, $75, $75, $5a, $7f, $5a, $7f
	db $5a, $7f, $5a, $7f
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $74, $74, $74, $74, $e9, $7c, $7c, $7c, $7c, $f9, $75, $75, $7f, $5a, $7f, $5a
	db $7f, $5a, $7f, $5a
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $5a, $7f, $74, $74, $e9, $7c, $7c, $7c, $7c, $f9, $5e, $5e, $1a, $5a, $5a, $7f
	db $5a, $7f, $5a, $7f
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $7f, $5a, $74, $74, $f6, $f7, $f7, $f7, $f7, $f8, $5f, $5f, $5a, $1a, $7f, $5a
	db $7f, $5a, $7f, $5a
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $5a, $7f, $74, $74, $2c, $2d, $2e, $2f, $2c, $2d, $2e, $2f, $ec, $ec, $75, $75
	db $5a, $7f, $5a, $7f
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $7f, $5a, $74, $74, $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f, $fc, $fc, $75, $75
	db $7f, $5a, $7f, $5a
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $5a, $7f, $74, $74, $74, $74, $74, $74, $74, $ec, $75, $75, $75, $75, $75, $75
	db $75, $75, $5a, $7f
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $7f, $5a, $74, $74, $74, $74, $74, $74, $74, $fc, $75, $75, $75, $75, $75, $75
	db $75, $75, $7f, $5a
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $5a, $7f, $5a, $7f, $1a, $5a, $75, $75, $75, $75, $75, $75, $75, $75, $75, $75
	db $5a, $7f, $5a, $7f
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $7f, $5a, $7f, $5a, $5a, $1a, $75, $75, $75, $75, $75, $75, $75, $75, $75, $75
	db $7f, $5a, $7f, $5a
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $74, $74, $74, $74, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f
	db $1a, $5a, $5a, $7f
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $74, $74, $74, $74, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a
	db $5a, $1a, $7f, $5a
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $22, $23, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74
	db $74, $74, $74, $74
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $32, $33, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74, $74
	db $74, $74, $74, $74
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $26, $27, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f
	db $5a, $7f, $5a, $7f
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $36, $37, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a
	db $7f, $5a, $7f, $5a
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $21 (wBGMapToLoad = $21, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout21::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $92, $7c, $92, $7c, $92, $83, $5a, $7f, $5a, $7f, $5a, $7f, $75, $75, $82, $7c
	db $92, $7c, $24, $25
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $7c, $92, $7c, $84, $80, $89, $7f, $5a, $7f, $5a, $7f, $5a, $75, $75, $82, $92
	db $7c, $92, $8e, $8f
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $92, $7c, $92, $83, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $75, $75, $82, $7c
	db $92, $7c, $28, $21
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $7c, $84, $80, $89, $7f, $5a, $7f, $5a, $7f, $5a, $7f, $5a, $75, $75, $88, $80
	db $85, $92, $30, $31
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $92, $83, $8c, $8d, $5a, $7f, $14, $16, $14, $16, $5a, $7f, $5a, $7f, $1a, $5a
	db $82, $7c, $24, $25
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $7c, $83, $9c, $9d, $7f, $5a, $15, $17, $15, $17, $7f, $5a, $7f, $5a, $5a, $1a
	db $82, $92, $8e, $8f
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $92, $83, $5a, $7f, $14, $16, $20, $21, $22, $23, $14, $16, $1a, $5a, $75, $75
	db $82, $7c, $28, $21
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $7c, $83, $7f, $5a, $15, $17, $30, $31, $32, $33, $15, $17, $5a, $1a, $75, $75
	db $82, $92, $30, $31
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $92, $83, $5a, $7f, $14, $16, $24, $25, $26, $27, $14, $16, $5a, $7f, $75, $75
	db $82, $7c, $24, $25
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $7c, $83, $7f, $5a, $15, $17, $34, $35, $36, $37, $15, $17, $7f, $5a, $75, $75
	db $82, $92, $8e, $8f
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $92, $83, $5a, $7f, $5a, $7f, $14, $16, $14, $16, $5a, $7f, $75, $75, $75, $75
	db $82, $7c, $28, $21
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $7c, $83, $7f, $5a, $7f, $5a, $15, $17, $15, $17, $7f, $5a, $75, $75, $75, $75
	db $82, $92, $30, $31
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $92, $83, $5a, $7f, $5a, $7f, $1a, $5a, $8c, $8d, $5a, $7f, $75, $75, $8a, $81
	db $92, $7c, $24, $25
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $7c, $83, $7f, $5a, $7f, $5a, $5a, $1a, $9c, $9d, $7f, $5a, $75, $75, $82, $92
	db $7c, $92, $8e, $8f
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $92, $86, $81, $81, $81, $8b, $5a, $7f, $5a, $7f, $5a, $7f, $75, $75, $82, $7c
	db $92, $7c, $28, $21
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $7c, $92, $7c, $92, $7c, $83, $7f, $5a, $7f, $5a, $7f, $5a, $75, $75, $82, $92
	db $7c, $92, $30, $31
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $92, $7c, $92, $7c, $92, $83, $5a, $7f, $5a, $7f, $75, $75, $75, $75, $82, $7c
	db $92, $7c, $24, $25
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $7c, $92, $7c, $92, $7c, $83, $7f, $5a, $7f, $5a, $75, $75, $75, $75, $82, $92
	db $7c, $92, $8e, $8f
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $22 (wBGMapToLoad = $22, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout22::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $76, $76, $49, $59, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $44, $56
	db $48, $51, $45, $45
	db $98, $20, $13  ; BG map 0, row 1, column 0: 20 tiles across
	db $76, $76, $49, $59, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $44, $56
	db $44, $56, $55, $56
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $45, $45, $52, $59, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $aa, $ab, $44, $56
	db $44, $56, $55, $56
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $55, $56, $55, $47, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $ba, $bb, $54, $56
	db $44, $56, $55, $56
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $55, $56, $55, $47, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad
	db $44, $56, $55, $56
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $55, $56, $55, $57, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd
	db $54, $56, $55, $56
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $ac, $ad, $ae, $af, $ac, $ad, $ac, $ad
	db $aa, $ab, $ac, $ad
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $bc, $bd, $be, $bf, $bc, $bd, $bc, $bd
	db $ba, $bb, $bc, $bd
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $4a, $4a, $4a, $4d, $ac, $ad, $ac, $ad, $ae, $af, $ac, $ad, $ac, $ad, $a8, $a9
	db $ac, $ad, $ac, $ad
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $45, $45, $5d, $59, $bc, $bd, $bc, $bd, $be, $bf, $bc, $bd, $bc, $bd, $b8, $b9
	db $bc, $bd, $bc, $bd
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $76, $76, $49, $59, $1c, $1d, $1c, $1d, $1c, $1d, $1c, $1d, $1c, $1d, $1c, $1d
	db $1c, $1d, $1c, $1d
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $76, $76, $49, $59, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $45, $45, $52, $59, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $55, $56, $55, $47, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $55, $56, $55, $47, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $55, $56, $55, $57, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f, $1e, $1f
	db $1e, $1f, $1e, $1f
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $01 (wBGMapToLoad = $01, drawn by DrawRequestedBGMap while the LCD is off): $01: the ending: the island fading away (MemoryDrawIsland). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout01::
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $ac
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $ac
	db $98, $40, $53  ; BG map 0, row 2, column 0: 20 tiles repeated across
	db $ac
	db $98, $60, $53  ; BG map 0, row 3, column 0: 20 tiles repeated across
	db $ac
	db $98, $80, $53  ; BG map 0, row 4, column 0: 20 tiles repeated across
	db $ac
	db $98, $a0, $53  ; BG map 0, row 5, column 0: 20 tiles repeated across
	db $ac
	db $98, $c0, $53  ; BG map 0, row 6, column 0: 20 tiles repeated across
	db $ac
	db $98, $e0, $53  ; BG map 0, row 7, column 0: 20 tiles repeated across
	db $ac
	db $99, $00, $53  ; BG map 0, row 8, column 0: 20 tiles repeated across
	db $ac
	db $99, $20, $53  ; BG map 0, row 9, column 0: 20 tiles repeated across
	db $ac
	db $99, $40, $53  ; BG map 0, row 10, column 0: 20 tiles repeated across
	db $ac
	db $99, $60, $53  ; BG map 0, row 11, column 0: 20 tiles repeated across
	db $ac
	db $99, $80, $53  ; BG map 0, row 12, column 0: 20 tiles repeated across
	db $ac
	db $99, $a0, $53  ; BG map 0, row 13, column 0: 20 tiles repeated across
	db $ac
	db $99, $c0, $53  ; BG map 0, row 14, column 0: 20 tiles repeated across
	db $ac
	db $99, $e0, $53  ; BG map 0, row 15, column 0: 20 tiles repeated across
	db $ac
	db $9a, $00, $53  ; BG map 0, row 16, column 0: 20 tiles repeated across
	db $ac
	db $9a, $20, $53  ; BG map 0, row 17, column 0: 20 tiles repeated across
	db $ac
	db $98, $49, $00  ; BG map 0, row 2, column 9: 1 tile across
	db $1f
	db $98, $68, $02  ; BG map 0, row 3, column 8: 3 tiles across
	db $06, $15, $0a
	db $98, $88, $02  ; BG map 0, row 4, column 8: 3 tiles across
	db $16, $15, $1a
	db $98, $a7, $04  ; BG map 0, row 5, column 7: 5 tiles across
	db $07, $15, $15, $15, $19
	db $98, $c6, $07  ; BG map 0, row 6, column 6: 8 tiles across
	db $07, $15, $15, $15, $15, $15, $08, $09
	db $98, $e5, $09  ; BG map 0, row 7, column 5: 10 tiles across
	db $07, $15, $15, $15, $15, $15, $15, $15, $15, $19
	db $99, $03, $0d  ; BG map 0, row 8, column 3: 14 tiles across
	db $17, $18, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $08, $09
	db $99, $21, $11  ; BG map 0, row 9, column 1: 18 tiles across
	db $17, $18, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
	db $08, $09
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $82, $83, $0c, $0d, $0c, $0d, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0c, $0d
	db $0c, $0d, $82, $83
	db $99, $60, $01  ; BG map 0, row 11, column 0: 2 tiles across
	db $92, $93
	db $99, $72, $01  ; BG map 0, row 11, column 18: 2 tiles across
	db $92, $93
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $16 (wBGMapToLoad = $16, drawn by DrawRequestedBGMap while the LCD is off): $16: the ending, after the egg. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout16::
	db $9c, $00, $5f  ; BG map 1, row 0, column 0: 32 tiles repeated across
	db $a0
	db $9c, $20, $5f  ; BG map 1, row 1, column 0: 32 tiles repeated across
	db $a0
	db $9c, $40, $5f  ; BG map 1, row 2, column 0: 32 tiles repeated across
	db $a0
	db $9c, $60, $5f  ; BG map 1, row 3, column 0: 32 tiles repeated across
	db $a0
	db $9c, $80, $5f  ; BG map 1, row 4, column 0: 32 tiles repeated across
	db $a0
	db $9c, $a0, $5f  ; BG map 1, row 5, column 0: 32 tiles repeated across
	db $a0
	db $9c, $c0, $5f  ; BG map 1, row 6, column 0: 32 tiles repeated across
	db $a0
	db $9c, $e0, $5f  ; BG map 1, row 7, column 0: 32 tiles repeated across
	db $a0
	db $9d, $00, $5f  ; BG map 1, row 8, column 0: 32 tiles repeated across
	db $a0
	db $9d, $20, $5f  ; BG map 1, row 9, column 0: 32 tiles repeated across
	db $a0
	db $9d, $40, $5f  ; BG map 1, row 10, column 0: 32 tiles repeated across
	db $a0
	db $9d, $60, $5f  ; BG map 1, row 11, column 0: 32 tiles repeated across
	db $a0
	db $9d, $80, $5f  ; BG map 1, row 12, column 0: 32 tiles repeated across
	db $a0
	db $9d, $a0, $5f  ; BG map 1, row 13, column 0: 32 tiles repeated across
	db $a0
	db $9d, $c0, $5f  ; BG map 1, row 14, column 0: 32 tiles repeated across
	db $a0
	db $9d, $e0, $5f  ; BG map 1, row 15, column 0: 32 tiles repeated across
	db $a0
	db $9e, $00, $5f  ; BG map 1, row 16, column 0: 32 tiles repeated across
	db $a0
	db $9e, $20, $5f  ; BG map 1, row 17, column 0: 32 tiles repeated across
	db $a0
	db $9e, $40, $13  ; BG map 1, row 18, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $a0
	db $a0, $a0, $a0, $a0
	db $9e, $60, $13  ; BG map 1, row 19, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d
	db $a0, $a0, $a0, $a0
	db $9e, $80, $13  ; BG map 1, row 20, column 0: 20 tiles across
	db $a0, $a0, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad
	db $ae, $a0, $a0, $a0
	db $9e, $a0, $13  ; BG map 1, row 21, column 0: 20 tiles across
	db $a0, $a0, $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd
	db $be, $bf, $a0, $a0
	db $9e, $c0, $13  ; BG map 1, row 22, column 0: 20 tiles across
	db $a0, $a0, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $8e, $8f, $ca, $cb, $cc, $cd
	db $ce, $cf, $a0, $a0
	db $9e, $e0, $13  ; BG map 1, row 23, column 0: 20 tiles across
	db $a0, $a0, $a0, $82, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fd
	db $8d, $a0, $a0, $a0
	db $9f, $00, $13  ; BG map 1, row 24, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $20, $13  ; BG map 1, row 25, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $40, $13  ; BG map 1, row 26, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $60, $13  ; BG map 1, row 27, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $80, $13  ; BG map 1, row 28, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $a0, $13  ; BG map 1, row 29, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $c0, $13  ; BG map 1, row 30, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9f, $e0, $13  ; BG map 1, row 31, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $a0
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $a0
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $a0
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $a0
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $a0
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $a0
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $a0
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $a0
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $a0
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $a0
	db $99, $40, $5f  ; BG map 0, row 10, column 0: 32 tiles repeated across
	db $a0
	db $99, $60, $5f  ; BG map 0, row 11, column 0: 32 tiles repeated across
	db $a0
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $a0
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $a0
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $a0
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $a0
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $a0
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $a0
	db $9b, $00, $5f  ; BG map 0, row 24, column 0: 32 tiles repeated across
	db $a0
	db $9b, $20, $5f  ; BG map 0, row 25, column 0: 32 tiles repeated across
	db $a0
	db $9b, $40, $5f  ; BG map 0, row 26, column 0: 32 tiles repeated across
	db $a0
	db $9b, $80, $5f  ; BG map 0, row 28, column 0: 32 tiles repeated across
	db $a0
	db $9b, $a0, $5f  ; BG map 0, row 29, column 0: 32 tiles repeated across
	db $a0
	db $9b, $c0, $5f  ; BG map 0, row 30, column 0: 32 tiles repeated across
	db $a0
	db $9b, $e0, $5f  ; BG map 0, row 31, column 0: 32 tiles repeated across
	db $a0
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $03, $04, $03
	db $04, $a0, $a0, $a0
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $03, $04, $a0, $a0, $02, $10, $11, $10
	db $30, $04, $03, $04
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $12, $04, $03, $30, $30, $30, $04, $00, $01, $00, $6b
	db $30, $30, $30, $30
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $02, $5a, $10, $30, $30, $30, $30, $10, $04, $a0, $03, $30
	db $30, $11, $10, $11
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $00, $01, $00, $10, $11, $21, $00, $00, $21, $12, $5a, $10
	db $11, $01, $00, $01
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $04, $a0, $a0, $a0, $a0, $a0, $a0, $00, $01, $a0, $a0, $a0, $a0, $00, $01, $00
	db $01, $a0, $a0, $a0
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $30, $04, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $10, $0f, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
	db $03, $04, $a0, $a0
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $12
	db $30, $30, $04, $a0
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $03, $04, $a0, $02, $5a
	db $20, $10, $0f, $a0
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $a0, $a0, $a0, $a0, $a0, $a0, $12, $04, $03, $30, $30, $30, $0f, $a0, $00, $01
	db $00, $01, $a0, $a0
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $a0, $12, $04, $a0, $a0, $a0, $00, $20, $10, $10, $10, $30, $04, $a0, $a0, $a0
	db $a0, $a0, $a0, $a0
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $a0, $00, $10, $04, $03, $04, $03, $71, $6b, $10, $10, $10, $0f, $a0, $a0, $a0
	db $a0, $03, $04, $a0
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $a0, $02, $5a, $10, $30, $11, $10, $30, $11, $11, $11, $01, $a0, $a0, $12, $04
	db $03, $30, $0f, $a0
	db $9a, $40, $53  ; BG map 0, row 18, column 0: 20 tiles repeated across
	db $a0
	db $9a, $60, $53  ; BG map 0, row 19, column 0: 20 tiles repeated across
	db $a0
	db $9a, $80, $53  ; BG map 0, row 20, column 0: 20 tiles repeated across
	db $a0
	db $9a, $a0, $53  ; BG map 0, row 21, column 0: 20 tiles repeated across
	db $a0
	db $9a, $c0, $53  ; BG map 0, row 22, column 0: 20 tiles repeated across
	db $a0
	db $9a, $e0, $53  ; BG map 0, row 23, column 0: 20 tiles repeated across
	db $a0
	db $9b, $00, $53  ; BG map 0, row 24, column 0: 20 tiles repeated across
	db $a0
	db $9b, $20, $53  ; BG map 0, row 25, column 0: 20 tiles repeated across
	db $a0
	db $9b, $40, $53  ; BG map 0, row 26, column 0: 20 tiles repeated across
	db $a0
	db $9b, $60, $53  ; BG map 0, row 27, column 0: 20 tiles repeated across
	db $a0
	db $9b, $80, $53  ; BG map 0, row 28, column 0: 20 tiles repeated across
	db $a0
	db $9b, $a0, $53  ; BG map 0, row 29, column 0: 20 tiles repeated across
	db $a0
	db $9b, $c0, $53  ; BG map 0, row 30, column 0: 20 tiles repeated across
	db $a0
	db $9b, $e0, $53  ; BG map 0, row 31, column 0: 20 tiles repeated across
	db $a0
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $17 (wBGMapToLoad = $17, drawn by DrawRequestedBGMap while the LCD is off): $17: the ending: the log Marin was sitting on (FarLogSpawn). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout17::
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $ac
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $ac
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $ac
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $ac
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $ac
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $ac
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $ac
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $ac
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $ac
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $ac
	db $99, $40, $5f  ; BG map 0, row 10, column 0: 32 tiles repeated across
	db $ac
	db $99, $60, $5f  ; BG map 0, row 11, column 0: 32 tiles repeated across
	db $ac
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $ac
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $ac
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $ac
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $ac
	db $98, $02, $03  ; BG map 0, row 0, column 2: 4 tiles across
	db $e5, $e6, $e1, $e2
	db $98, $22, $03  ; BG map 0, row 1, column 2: 4 tiles across
	db $f5, $f6, $f1, $f2
	db $98, $40, $07  ; BG map 0, row 2, column 0: 8 tiles across
	db $e3, $e4, $e7, $e8, $a0, $a1, $80, $81
	db $98, $52, $01  ; BG map 0, row 2, column 18: 2 tiles across
	db $e3, $e4
	db $98, $60, $07  ; BG map 0, row 3, column 0: 8 tiles across
	db $f3, $f4, $f7, $ae, $b0, $b1, $90, $91
	db $98, $72, $01  ; BG map 0, row 3, column 18: 2 tiles across
	db $f3, $f4
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $e7, $e8, $ae, $ae, $ae, $ae, $a0, $a1, $80, $81, $e3, $e4, $e1, $e2, $ac, $ac
	db $e5, $e6, $e7, $e8
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $f7, $ae, $ae, $ae, $ae, $ae, $b0, $b1, $90, $91, $f3, $f4, $f1, $f2, $ac, $ac
	db $f5, $f6, $f7, $ae
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83
	db $82, $83, $82, $83
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $92, $93, $92, $93
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $18 (wBGMapToLoad = $18, drawn by DrawRequestedBGMap while the LCD is off): $18: the ending: the sky (SkyViewSpawn). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout18::
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $ac
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $ac
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $ac
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $ac
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $ac
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $ac
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $ac
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $ac
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $ac
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $ac
	db $99, $40, $5f  ; BG map 0, row 10, column 0: 32 tiles repeated across
	db $ac
	db $99, $60, $5f  ; BG map 0, row 11, column 0: 32 tiles repeated across
	db $ac
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $ac
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $ac
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $ac
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $ac
	db $98, $00, $07  ; BG map 0, row 0, column 0: 8 tiles across
	db $56, $73, $ae, $ae, $ae, $ae, $ae, $3e
	db $98, $0e, $05  ; BG map 0, row 0, column 14: 6 tiles across
	db $56, $73, $ae, $ae, $ae, $ae
	db $98, $20, $07  ; BG map 0, row 1, column 0: 8 tiles across
	db $72, $ae, $ae, $ae, $ae, $ae, $3d, $3f
	db $98, $2e, $05  ; BG map 0, row 1, column 14: 6 tiles across
	db $72, $ae, $ae, $ae, $ae, $ae
	db $98, $40, $07  ; BG map 0, row 2, column 0: 8 tiles across
	db $ae, $ae, $ae, $ae, $ae, $ae, $74, $67
	db $98, $4e, $05  ; BG map 0, row 2, column 14: 6 tiles across
	db $45, $ae, $ae, $ae, $ae, $ae
	db $98, $60, $07  ; BG map 0, row 3, column 0: 8 tiles across
	db $ae, $ae, $ae, $ae, $ae, $ae, $ae, $75
	db $98, $6e, $05  ; BG map 0, row 3, column 14: 6 tiles across
	db $78, $79, $ae, $ae, $ae, $ae
	db $98, $80, $07  ; BG map 0, row 4, column 0: 8 tiles across
	db $45, $ae, $2c, $2d, $45, $ae, $2c, $2d
	db $98, $90, $03  ; BG map 0, row 4, column 16: 4 tiles across
	db $7a, $4b, $ae, $3e
	db $98, $a0, $06  ; BG map 0, row 5, column 0: 7 tiles across
	db $78, $79, $3c, $ac, $78, $79, $3c
	db $98, $b1, $02  ; BG map 0, row 5, column 17: 3 tiles across
	db $7b, $3d, $3f
	db $98, $c8, $03  ; BG map 0, row 6, column 8: 4 tiles across
	db $84, $85, $9d, $9f
	db $98, $e8, $03  ; BG map 0, row 7, column 8: 4 tiles across
	db $a2, $a3, $bf, $f0
	db $99, $08, $03  ; BG map 0, row 8, column 8: 4 tiles across
	db $f8, $fa, $fc, $fd
	db $99, $28, $03  ; BG map 0, row 9, column 8: 4 tiles across
	db $fe, $ff, $05, $0b
	db $98, $e0, $01  ; BG map 0, row 7, column 0: 2 tiles across
	db $74, $67
	db $99, $00, $01  ; BG map 0, row 8, column 0: 2 tiles across
	db $ae, $75
	db $99, $20, $01  ; BG map 0, row 9, column 0: 2 tiles across
	db $2c, $2d
	db $99, $40, $00  ; BG map 0, row 10, column 0: 1 tile across
	db $3c
	db $99, $44, $03  ; BG map 0, row 10, column 4: 4 tiles across
	db $56, $73, $74, $67
	db $99, $64, $03  ; BG map 0, row 11, column 4: 4 tiles across
	db $72, $ae, $ae, $75
	db $99, $84, $03  ; BG map 0, row 12, column 4: 4 tiles across
	db $7a, $4b, $ae, $3e
	db $99, $a5, $02  ; BG map 0, row 13, column 5: 3 tiles across
	db $7b, $3d, $3f
	db $99, $92, $01  ; BG map 0, row 12, column 18: 2 tiles across
	db $56, $73
	db $99, $b2, $01  ; BG map 0, row 13, column 18: 2 tiles across
	db $72, $ae
	db $99, $d2, $01  ; BG map 0, row 14, column 18: 2 tiles across
	db $7a, $4b
	db $99, $f3, $00  ; BG map 0, row 15, column 19: 1 tile across
	db $7b
	db $9a, $13, $00  ; BG map 0, row 16, column 19: 1 tile across
	db $57
	db $9a, $32, $01  ; BG map 0, row 17, column 18: 2 tiles across
	db $70, $71
	db $99, $c2, $02  ; BG map 0, row 14, column 2: 3 tiles across
	db $56, $73, $66
	db $99, $e2, $03  ; BG map 0, row 15, column 2: 4 tiles across
	db $72, $ae, $76, $77
	db $9a, $00, $07  ; BG map 0, row 16, column 0: 8 tiles across
	db $56, $73, $ae, $ae, $ae, $ae, $74, $67
	db $9a, $20, $07  ; BG map 0, row 17, column 0: 8 tiles across
	db $72, $ae, $ae, $ae, $ae, $ae, $ae, $75
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $19 (wBGMapToLoad = $19, drawn by DrawRequestedBGMap while the LCD is off): $19: the ending: Link waking up at sea (LinkWakesSpawn). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout19::
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $ac
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $ac
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $ac
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $ac
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $ac
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $ac
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $ac
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $ac
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $ac
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $ac
	db $99, $40, $5f  ; BG map 0, row 10, column 0: 32 tiles repeated across
	db $ac
	db $99, $60, $5f  ; BG map 0, row 11, column 0: 32 tiles repeated across
	db $ac
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $ac
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $ac
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $ac
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $ac
	db $9a, $40, $5f  ; BG map 0, row 18, column 0: 32 tiles repeated across
	db $ac
	db $9a, $60, $5f  ; BG map 0, row 19, column 0: 32 tiles repeated across
	db $ac
	db $9a, $80, $5f  ; BG map 0, row 20, column 0: 32 tiles repeated across
	db $ac
	db $9a, $a0, $5f  ; BG map 0, row 21, column 0: 32 tiles repeated across
	db $ac
	db $9a, $e0, $5f  ; BG map 0, row 23, column 0: 32 tiles repeated across
	db $ac
	db $9b, $c0, $5f  ; BG map 0, row 30, column 0: 32 tiles repeated across
	db $ac
	db $9b, $e0, $5f  ; BG map 0, row 31, column 0: 32 tiles repeated across
	db $ac
	db $98, $12, $01  ; BG map 0, row 0, column 18: 2 tiles across
	db $e5, $e6
	db $98, $32, $01  ; BG map 0, row 1, column 18: 2 tiles across
	db $f5, $f6
	db $98, $40, $01  ; BG map 0, row 2, column 0: 2 tiles across
	db $80, $81
	db $98, $4c, $07  ; BG map 0, row 2, column 12: 8 tiles across
	db $e5, $e6, $e1, $e2, $e3, $e4, $e7, $e8
	db $98, $60, $01  ; BG map 0, row 3, column 0: 2 tiles across
	db $90, $91
	db $98, $6c, $07  ; BG map 0, row 3, column 12: 8 tiles across
	db $f5, $f6, $f1, $f2, $f3, $f4, $f7, $ae
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $a0, $a1, $e1, $e2, $ac, $e3, $e4, $e1, $e2, $ac, $e3, $e4, $e7, $e8, $a0, $a1
	db $e7, $e8, $a0, $a1
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $b0, $b1, $f1, $f2, $ac, $f3, $f4, $f1, $f2, $ac, $f3, $f4, $f7, $ae, $b0, $b1
	db $f7, $ae, $b0, $b1
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83
	db $82, $83, $82, $83
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $92, $93, $92, $93
	db $99, $68, $03  ; BG map 0, row 11, column 8: 4 tiles across
	db $86, $87, $88, $89
	db $99, $86, $05  ; BG map 0, row 12, column 6: 6 tiles across
	db $94, $95, $96, $97, $98, $99
	db $99, $a6, $07  ; BG map 0, row 13, column 6: 8 tiles across
	db $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab
	db $99, $c4, $0c  ; BG map 0, row 14, column 4: 13 tiles across
	db $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be
	db $99, $e2, $0f  ; BG map 0, row 15, column 2: 16 tiles across
	db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf
	db $9a, $02, $0f  ; BG map 0, row 16, column 2: 16 tiles across
	db $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de, $df
	db $9a, $22, $0f  ; BG map 0, row 17, column 2: 16 tiles across
	db $e0, $6c, $6d, $6e, $6f, $6c, $6d, $6e, $6f, $6c, $6d, $6e, $6f, $6c, $6d, $ef
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $1A (wBGMapToLoad = $1A, drawn by DrawRequestedBGMap while the LCD is off): $1A: the ending: the Wind Fish flying away (WindFishFliesSpawn). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout1A::
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $ac
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $ac
	db $98, $28, $03  ; BG map 0, row 1, column 8: 4 tiles across
	db $50, $51, $52, $53
	db $98, $40, $53  ; BG map 0, row 2, column 0: 20 tiles repeated across
	db $ac
	db $98, $48, $05  ; BG map 0, row 2, column 8: 6 tiles across
	db $60, $61, $62, $63, $64, $65
	db $98, $60, $53  ; BG map 0, row 3, column 0: 20 tiles repeated across
	db $ac
	db $98, $80, $53  ; BG map 0, row 4, column 0: 20 tiles repeated across
	db $ac
	db $98, $92, $01  ; BG map 0, row 4, column 18: 2 tiles across
	db $e5, $e6
	db $98, $a0, $53  ; BG map 0, row 5, column 0: 20 tiles repeated across
	db $ac
	db $98, $a4, $01  ; BG map 0, row 5, column 4: 2 tiles across
	db $64, $65
	db $98, $b2, $01  ; BG map 0, row 5, column 18: 2 tiles across
	db $f5, $f6
	db $98, $c0, $53  ; BG map 0, row 6, column 0: 20 tiles repeated across
	db $ac
	db $98, $c0, $01  ; BG map 0, row 6, column 0: 2 tiles across
	db $80, $81
	db $98, $cc, $07  ; BG map 0, row 6, column 12: 8 tiles across
	db $e5, $e6, $e1, $e2, $e3, $e4, $e7, $e8
	db $98, $e0, $53  ; BG map 0, row 7, column 0: 20 tiles repeated across
	db $ac
	db $98, $e0, $01  ; BG map 0, row 7, column 0: 2 tiles across
	db $90, $91
	db $98, $ec, $07  ; BG map 0, row 7, column 12: 8 tiles across
	db $f5, $f6, $f1, $f2, $f3, $f4, $f7, $ae
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $a0, $a1, $e1, $e2, $ac, $e3, $e4, $e1, $e2, $ac, $e3, $e4, $e7, $e8, $a0, $a1
	db $e7, $e8, $a0, $a1
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $b0, $b1, $f1, $f2, $ac, $f3, $f4, $f1, $f2, $ac, $f3, $f4, $f7, $ae, $b0, $b1
	db $f7, $ae, $b0, $b1
	db $99, $40, $1f  ; BG map 0, row 10, column 0: 32 tiles across
	db $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83
	db $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83
	db $99, $60, $1f  ; BG map 0, row 11, column 0: 32 tiles across
	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $ac
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $ac
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $ac
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $ac
	db $00  ; end
;@ path: gfx/bgmap/layouts
;@ Screen layout $1B (wBGMapToLoad = $1B, drawn by DrawRequestedBGMap while the LCD is off): $1B: the ending: a portrait (PortraitSpawn). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout1B::
	db $9b, $c0, $5f  ; BG map 0, row 30, column 0: 32 tiles repeated across
	db $ac
	db $9b, $e0, $5f  ; BG map 0, row 31, column 0: 32 tiles repeated across
	db $ac
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $ac
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $ac
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $ac
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $ac
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $ac
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $ac
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $ac
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $ac
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $ac
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $ac
	db $99, $40, $5f  ; BG map 0, row 10, column 0: 32 tiles repeated across
	db $ac
	db $99, $60, $5f  ; BG map 0, row 11, column 0: 32 tiles repeated across
	db $ac
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $ac
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $ac
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $ac
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $ac
	db $9a, $40, $5f  ; BG map 0, row 18, column 0: 32 tiles repeated across
	db $ac
	db $9a, $60, $5f  ; BG map 0, row 19, column 0: 32 tiles repeated across
	db $ac
	db $98, $01, $05  ; BG map 0, row 0, column 1: 6 tiles across
	db $58, $59, $5a, $5b, $5c, $5d
	db $98, $21, $05  ; BG map 0, row 1, column 1: 6 tiles across
	db $68, $69, $6a, $6b, $6c, $6d
	db $98, $31, $02  ; BG map 0, row 1, column 17: 3 tiles across
	db $58, $59, $5a
	db $98, $51, $02  ; BG map 0, row 2, column 17: 3 tiles across
	db $68, $69, $6a
	db $98, $60, $01  ; BG map 0, row 3, column 0: 2 tiles across
	db $5c, $5d
	db $98, $80, $07  ; BG map 0, row 4, column 0: 8 tiles across
	db $6c, $6d, $ac, $ac, $50, $51, $52, $53
	db $98, $a4, $05  ; BG map 0, row 5, column 4: 6 tiles across
	db $60, $61, $62, $63, $64, $65
	db $99, $40, $03  ; BG map 0, row 10, column 0: 4 tiles across
	db $50, $51, $52, $53
	db $99, $4f, $03  ; BG map 0, row 10, column 15: 4 tiles across
	db $50, $51, $52, $53
	db $99, $60, $03  ; BG map 0, row 11, column 0: 4 tiles across
	db $60, $61, $62, $63
	db $99, $6d, $05  ; BG map 0, row 11, column 13: 6 tiles across
	db $64, $65, $60, $61, $62, $63
	db $99, $e3, $01  ; BG map 0, row 15, column 3: 2 tiles across
	db $64, $65
	db $9a, $00, $01  ; BG map 0, row 16, column 0: 2 tiles across
	db $64, $65
	db $9a, $10, $01  ; BG map 0, row 16, column 16: 2 tiles across
	db $64, $65
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $1C / $1D (wBGMapToLoad = $1C or $1D, drawn by DrawRequestedBGMap while the LCD is off): $1C: the last picture of the ending (FinalSpawn). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout1C::
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $ac
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $ac
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $ac
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $ac
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $ac
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $ac
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $ac
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $ac
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $ac
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $ac
	db $99, $40, $5f  ; BG map 0, row 10, column 0: 32 tiles repeated across
	db $ac
	db $99, $60, $5f  ; BG map 0, row 11, column 0: 32 tiles repeated across
	db $ac
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $ac
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $ac
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $ac
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $ac
	db $9a, $40, $5f  ; BG map 0, row 18, column 0: 32 tiles repeated across
	db $ac
	db $9a, $60, $5f  ; BG map 0, row 19, column 0: 32 tiles repeated across
	db $ac
	db $9a, $80, $5f  ; BG map 0, row 20, column 0: 32 tiles repeated across
	db $ac
	db $9a, $a0, $5f  ; BG map 0, row 21, column 0: 32 tiles repeated across
	db $ac
	db $9a, $c0, $5f  ; BG map 0, row 22, column 0: 32 tiles repeated across
	db $ac
	db $9a, $e0, $5f  ; BG map 0, row 23, column 0: 32 tiles repeated across
	db $ac
	db $9b, $00, $5f  ; BG map 0, row 24, column 0: 32 tiles repeated across
	db $ac
	db $9b, $20, $5f  ; BG map 0, row 25, column 0: 32 tiles repeated across
	db $ac
	db $9b, $40, $5f  ; BG map 0, row 26, column 0: 32 tiles repeated across
	db $ac
	db $9b, $60, $5f  ; BG map 0, row 27, column 0: 32 tiles repeated across
	db $ac
	db $9b, $80, $5f  ; BG map 0, row 28, column 0: 32 tiles repeated across
	db $ac
	db $9b, $a0, $5f  ; BG map 0, row 29, column 0: 32 tiles repeated across
	db $ac
	db $9b, $c0, $5f  ; BG map 0, row 30, column 0: 32 tiles repeated across
	db $ac
	db $9b, $e0, $5f  ; BG map 0, row 31, column 0: 32 tiles repeated across
	db $ac
	db $9a, $40, $01  ; BG map 0, row 18, column 0: 2 tiles across
	db $6c, $6d
	db $9a, $46, $03  ; BG map 0, row 18, column 6: 4 tiles across
	db $50, $51, $52, $53
	db $9a, $66, $03  ; BG map 0, row 19, column 6: 4 tiles across
	db $60, $61, $62, $63
	db $9a, $90, $03  ; BG map 0, row 20, column 16: 4 tiles across
	db $e3, $e4, $e1, $e2
	db $9a, $b0, $03  ; BG map 0, row 21, column 16: 4 tiles across
	db $f3, $f4, $f1, $f2
	db $9a, $ce, $05  ; BG map 0, row 22, column 14: 6 tiles across
	db $e3, $e4, $e7, $e8, $a0, $a1
	db $9a, $ee, $05  ; BG map 0, row 23, column 14: 6 tiles across
	db $f3, $f4, $f7, $ae, $b0, $b1
	db $9b, $04, $03  ; BG map 0, row 24, column 4: 4 tiles across
	db $50, $51, $52, $53
	db $9b, $0e, $05  ; BG map 0, row 24, column 14: 6 tiles across
	db $22, $23, $02, $03, $23, $ae
	db $9b, $24, $03  ; BG map 0, row 25, column 4: 4 tiles across
	db $60, $61, $62, $63
	db $9b, $2e, $05  ; BG map 0, row 25, column 14: 6 tiles across
	db $32, $33, $12, $13, $ae, $ae
	db $9b, $40, $03  ; BG map 0, row 26, column 0: 4 tiles across
	db $e3, $e4, $e1, $e2
	db $9b, $4b, $01  ; BG map 0, row 26, column 11: 2 tiles across
	db $64, $65
	db $9b, $50, $03  ; BG map 0, row 26, column 16: 4 tiles across
	db $22, $23, $02, $03
	db $9b, $60, $03  ; BG map 0, row 27, column 0: 4 tiles across
	db $f3, $f4, $f1, $f2
	db $9b, $70, $03  ; BG map 0, row 27, column 16: 4 tiles across
	db $32, $33, $12, $13
	db $9b, $80, $08  ; BG map 0, row 28, column 0: 9 tiles across
	db $e7, $e8, $a0, $a1, $80, $81, $ac, $64, $65
	db $9b, $92, $01  ; BG map 0, row 28, column 18: 2 tiles across
	db $22, $23
	db $9b, $a0, $05  ; BG map 0, row 29, column 0: 6 tiles across
	db $f7, $ae, $b0, $b1, $90, $91
	db $9b, $b2, $01  ; BG map 0, row 29, column 18: 2 tiles across
	db $f5, $f6
	db $9b, $c0, $05  ; BG map 0, row 30, column 0: 6 tiles across
	db $03, $00, $01, $ae, $20, $21
	db $9b, $cc, $07  ; BG map 0, row 30, column 12: 8 tiles across
	db $e5, $e6, $e1, $e2, $e3, $e4, $e7, $e8
	db $9b, $e0, $05  ; BG map 0, row 31, column 0: 6 tiles across
	db $13, $10, $11, $ae, $30, $31
	db $9b, $ec, $07  ; BG map 0, row 31, column 12: 8 tiles across
	db $f5, $f6, $f1, $f2, $f3, $f4, $f7, $ae
	db $98, $00, $03  ; BG map 0, row 0, column 0: 4 tiles across
	db $ae, $ae, $20, $21
	db $98, $0a, $09  ; BG map 0, row 0, column 10: 10 tiles across
	db $e3, $e4, $e7, $e8, $a0, $a1, $e7, $e8, $a0, $a1
	db $98, $20, $03  ; BG map 0, row 1, column 0: 4 tiles across
	db $ae, $ae, $30, $31
	db $98, $2a, $09  ; BG map 0, row 1, column 10: 10 tiles across
	db $f3, $f4, $f7, $ae, $b0, $b1, $f7, $23, $b0, $b1
	db $98, $40, $03  ; BG map 0, row 2, column 0: 4 tiles across
	db $02, $03, $e1, $e2
	db $98, $4a, $09  ; BG map 0, row 2, column 10: 10 tiles across
	db $22, $23, $02, $03, $23, $ae, $ae, $ae, $ae, $ae
	db $98, $60, $03  ; BG map 0, row 3, column 0: 4 tiles across
	db $12, $13, $f1, $f2
	db $98, $6a, $09  ; BG map 0, row 3, column 10: 10 tiles across
	db $32, $33, $12, $13, $23, $ae, $23, $ae, $ae, $ae
	db $98, $80, $03  ; BG map 0, row 4, column 0: 4 tiles across
	db $ae, $ae, $20, $21
	db $98, $8c, $07  ; BG map 0, row 4, column 12: 8 tiles across
	db $22, $23, $02, $03, $23, $ae, $ae, $ae
	db $98, $a0, $03  ; BG map 0, row 5, column 0: 4 tiles across
	db $ae, $ae, $30, $31
	db $98, $ac, $07  ; BG map 0, row 5, column 12: 8 tiles across
	db $32, $33, $12, $13, $ae, $ae, $ae, $ae
	db $98, $c0, $03  ; BG map 0, row 6, column 0: 4 tiles across
	db $ae, $ae, $e1, $e2
	db $98, $cc, $07  ; BG map 0, row 6, column 12: 8 tiles across
	db $e3, $e4, $e7, $e8, $ae, $ae, $ae, $ae
	db $98, $e0, $03  ; BG map 0, row 7, column 0: 4 tiles across
	db $ae, $ae, $f1, $f2
	db $98, $ec, $07  ; BG map 0, row 7, column 12: 8 tiles across
	db $f3, $f4, $f7, $ae, $ae, $ae, $ae, $ae
	db $99, $00, $05  ; BG map 0, row 8, column 0: 6 tiles across
	db $02, $03, $00, $01, $80, $81
	db $99, $0a, $09  ; BG map 0, row 8, column 10: 10 tiles across
	db $e5, $e6, $e7, $e8, $ae, $ae, $ae, $ae, $ae, $ae
	db $99, $20, $05  ; BG map 0, row 9, column 0: 6 tiles across
	db $12, $13, $10, $11, $90, $91
	db $99, $2a, $09  ; BG map 0, row 9, column 10: 10 tiles across
	db $f5, $f6, $f7, $ae, $ae, $ae, $ae, $ae, $ae, $ae
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $23, $ae, $ae, $ae, $a0, $a1, $e1, $e2, $ac, $ac, $22, $23, $ae, $ae, $ae, $ae
	db $ae, $ae, $ae, $ae
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $ae, $ae, $ae, $23, $b0, $b1, $f1, $f2, $ac, $ac, $32, $33, $23, $ae, $ae, $ae
	db $ae, $ae, $ae, $ae
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83
	db $82, $83, $82, $83
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $92, $93, $92, $93
	db $9c, $00, $5f  ; BG map 1, row 0, column 0: 32 tiles repeated across
	db $ac
	db $9c, $20, $5f  ; BG map 1, row 1, column 0: 32 tiles repeated across
	db $ac
	db $9c, $40, $5f  ; BG map 1, row 2, column 0: 32 tiles repeated across
	db $ac
	db $9c, $60, $5f  ; BG map 1, row 3, column 0: 32 tiles repeated across
	db $ac
	db $9c, $80, $5f  ; BG map 1, row 4, column 0: 32 tiles repeated across
	db $ac
	db $9c, $a0, $5f  ; BG map 1, row 5, column 0: 32 tiles repeated across
	db $ac
	db $9c, $c0, $5f  ; BG map 1, row 6, column 0: 32 tiles repeated across
	db $ac
	db $9c, $e0, $5f  ; BG map 1, row 7, column 0: 32 tiles repeated across
	db $ac
	db $9d, $00, $5f  ; BG map 1, row 8, column 0: 32 tiles repeated across
	db $ac
	db $9d, $20, $5f  ; BG map 1, row 9, column 0: 32 tiles repeated across
	db $ac
	db $9d, $40, $5f  ; BG map 1, row 10, column 0: 32 tiles repeated across
	db $ac
	db $9d, $60, $5f  ; BG map 1, row 11, column 0: 32 tiles repeated across
	db $ac
	db $9d, $80, $5f  ; BG map 1, row 12, column 0: 32 tiles repeated across
	db $ac
	db $9d, $a0, $5f  ; BG map 1, row 13, column 0: 32 tiles repeated across
	db $ac
	db $9d, $c0, $5f  ; BG map 1, row 14, column 0: 32 tiles repeated across
	db $ac
	db $9d, $e0, $5f  ; BG map 1, row 15, column 0: 32 tiles repeated across
	db $ac
	db $9e, $00, $5f  ; BG map 1, row 16, column 0: 32 tiles repeated across
	db $ac
	db $9e, $20, $5f  ; BG map 1, row 17, column 0: 32 tiles repeated across
	db $ac
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $14 (wBGMapToLoad = $14, drawn by DrawRequestedBGMap while the LCD is off): $14: a stage scene of bank $18. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout14::
	db $9a, $00, $53  ; BG map 0, row 16, column 0: 20 tiles repeated across
	db $7e
	db $9a, $20, $53  ; BG map 0, row 17, column 0: 20 tiles repeated across
	db $7e
	db $9a, $40, $53  ; BG map 0, row 18, column 0: 20 tiles repeated across
	db $7e
	db $9a, $60, $53  ; BG map 0, row 19, column 0: 20 tiles repeated across
	db $7e
	db $9a, $80, $53  ; BG map 0, row 20, column 0: 20 tiles repeated across
	db $7e
	db $9a, $a0, $53  ; BG map 0, row 21, column 0: 20 tiles repeated across
	db $7e
	db $9a, $c0, $53  ; BG map 0, row 22, column 0: 20 tiles repeated across
	db $7e
	db $9a, $e0, $53  ; BG map 0, row 23, column 0: 20 tiles repeated across
	db $7e
	db $9b, $00, $53  ; BG map 0, row 24, column 0: 20 tiles repeated across
	db $7e
	db $9b, $20, $53  ; BG map 0, row 25, column 0: 20 tiles repeated across
	db $7e
	db $9b, $40, $53  ; BG map 0, row 26, column 0: 20 tiles repeated across
	db $7e
	db $9b, $60, $53  ; BG map 0, row 27, column 0: 20 tiles repeated across
	db $7e
	db $9b, $80, $53  ; BG map 0, row 28, column 0: 20 tiles repeated across
	db $7e
	db $9b, $a0, $53  ; BG map 0, row 29, column 0: 20 tiles repeated across
	db $7e
	db $9b, $c0, $53  ; BG map 0, row 30, column 0: 20 tiles repeated across
	db $7e
	db $9b, $e0, $53  ; BG map 0, row 31, column 0: 20 tiles repeated across
	db $7e
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $08 (wBGMapToLoad = $08, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout08::
	db $98, $00, $13  ; BG map 0, row 0, column 0: 20 tiles across
	db $fc, $3b, $52, $52, $52, $52, $52, $52, $52, $52, $52, $52, $52, $52, $52, $52
	db $52, $52, $3c, $fc
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $fc, $4b, $4f, $4e, $4e, $4e, $4e, $4d, $53, $53, $4f, $4e, $4d, $53, $53, $53
	db $53, $53, $4c, $fc
	db $98, $20, $cf  ; BG map 0, row 1, column 0: 16 tiles repeated down
	db $fc
	db $98, $33, $cf  ; BG map 0, row 1, column 19: 16 tiles repeated down
	db $fc
	db $98, $21, $cf  ; BG map 0, row 1, column 1: 16 tiles repeated down
	db $50
	db $98, $32, $cf  ; BG map 0, row 1, column 18: 16 tiles repeated down
	db $51
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $04 (wBGMapToLoad = $04, drawn by DrawRequestedBGMap while the LCD is off): $04: the file menu, drawn again after a name entry or a copy. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout04::
	db $99, $e6, $0a, $04, $11, $00, $12, $04, $7e, $7e, $02, $0e, $0f, $18

;@ path: gfx/bgmap/layouts
;@ Screen layout $03 (wBGMapToLoad = $03, drawn by DrawRequestedBGMap while the LCD is off): $03: the file menu. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout03::
	db $98, $00, $48  ; BG map 0, row 0, column 0: 9 tiles repeated across
	db $8f
	db $98, $01, $00  ; BG map 0, row 0, column 1: 1 tile across
	db $9f
	db $98, $03, $00  ; BG map 0, row 0, column 3: 1 tile across
	db $9f
	db $98, $05, $00  ; BG map 0, row 0, column 5: 1 tile across
	db $9f
	db $98, $07, $00  ; BG map 0, row 0, column 7: 1 tile across
	db $9f
	db $98, $09, $00  ; BG map 0, row 0, column 9: 1 tile across
	db $9f
	db $98, $20, $08  ; BG map 0, row 1, column 0: 9 tiles across
	db $9f, $80, $81, $82, $83, $84, $89, $8f, $9f
	db $98, $40, $08  ; BG map 0, row 2, column 0: 9 tiles across
	db $8f, $90, $91, $92, $93, $94, $aa, $9f, $8f
	db $98, $60, $08  ; BG map 0, row 3, column 0: 9 tiles across
	db $9f, $8a, $8b, $8c, $8d, $8e, $af, $8f, $9f
	db $98, $80, $52  ; BG map 0, row 4, column 0: 19 tiles repeated across
	db $8f
	db $98, $81, $00  ; BG map 0, row 4, column 1: 1 tile across
	db $9f
	db $98, $83, $00  ; BG map 0, row 4, column 3: 1 tile across
	db $9f
	db $98, $85, $00  ; BG map 0, row 4, column 5: 1 tile across
	db $9f
	db $98, $87, $00  ; BG map 0, row 4, column 7: 1 tile across
	db $9f
	db $98, $89, $00  ; BG map 0, row 4, column 9: 1 tile across
	db $9f
	db $98, $8b, $00  ; BG map 0, row 4, column 11: 1 tile across
	db $9f
	db $98, $8d, $00  ; BG map 0, row 4, column 13: 1 tile across
	db $9f
	db $98, $8f, $00  ; BG map 0, row 4, column 15: 1 tile across
	db $9f
	db $98, $91, $00  ; BG map 0, row 4, column 17: 1 tile across
	db $9f
	db $98, $93, $00  ; BG map 0, row 4, column 19: 1 tile across
	db $9f
	db $98, $a0, $cb  ; BG map 0, row 5, column 0: 12 tiles repeated down
	db $9f
	db $98, $c0, $00  ; BG map 0, row 6, column 0: 1 tile across
	db $8f
	db $99, $00, $00  ; BG map 0, row 8, column 0: 1 tile across
	db $8f
	db $99, $40, $00  ; BG map 0, row 10, column 0: 1 tile across
	db $8f
	db $99, $80, $00  ; BG map 0, row 12, column 0: 1 tile across
	db $8f
	db $99, $c0, $00  ; BG map 0, row 14, column 0: 1 tile across
	db $8f
	db $9a, $00, $00  ; BG map 0, row 16, column 0: 1 tile across
	db $8f
	db $9a, $20, $00  ; BG map 0, row 17, column 0: 1 tile across
	db $9f
	db $9a, $21, $50  ; BG map 0, row 17, column 1: 17 tiles repeated across
	db $8f
	db $9a, $22, $00  ; BG map 0, row 17, column 2: 1 tile across
	db $9f
	db $9a, $24, $00  ; BG map 0, row 17, column 4: 1 tile across
	db $9f
	db $9a, $26, $00  ; BG map 0, row 17, column 6: 1 tile across
	db $9f
	db $9a, $28, $00  ; BG map 0, row 17, column 8: 1 tile across
	db $9f
	db $9a, $2a, $00  ; BG map 0, row 17, column 10: 1 tile across
	db $9f
	db $9a, $2c, $00  ; BG map 0, row 17, column 12: 1 tile across
	db $9f
	db $9a, $2e, $00  ; BG map 0, row 17, column 14: 1 tile across
	db $9f
	db $9a, $30, $00  ; BG map 0, row 17, column 16: 1 tile across
	db $9f
	db $9a, $32, $00  ; BG map 0, row 17, column 18: 1 tile across
	db $8f
	db $98, $b3, $ca  ; BG map 0, row 5, column 19: 11 tiles repeated down
	db $8f
	db $98, $d3, $00  ; BG map 0, row 6, column 19: 1 tile across
	db $9f
	db $99, $13, $00  ; BG map 0, row 8, column 19: 1 tile across
	db $9f
	db $99, $53, $00  ; BG map 0, row 10, column 19: 1 tile across
	db $9f
	db $99, $93, $00  ; BG map 0, row 12, column 19: 1 tile across
	db $9f
	db $99, $d3, $00  ; BG map 0, row 14, column 19: 1 tile across
	db $9f
	db $9a, $13, $00  ; BG map 0, row 16, column 19: 1 tile across
	db $9f
	db $9a, $33, $00  ; BG map 0, row 17, column 19: 1 tile across
	db $9f
	db $98, $0a, $49  ; BG map 0, row 0, column 10: 10 tiles repeated across
	db $7f
	db $98, $29, $4a  ; BG map 0, row 1, column 9: 11 tiles repeated across
	db $7f
	db $98, $69, $4a  ; BG map 0, row 3, column 9: 11 tiles repeated across
	db $a2
	db $98, $49, $0a  ; BG map 0, row 2, column 9: 11 tiles across
	db $a1, $a0, $a1, $a5, $a6, $a0, $a1, $a5, $a6, $a0, $a1
	db $98, $2c, $01  ; BG map 0, row 1, column 12: 2 tiles across
	db $a3, $a4
	db $98, $30, $01  ; BG map 0, row 1, column 16: 2 tiles across
	db $a3, $a4
	db $98, $6c, $01  ; BG map 0, row 3, column 12: 2 tiles across
	db $a7, $a8
	db $98, $70, $01  ; BG map 0, row 3, column 16: 2 tiles across
	db $a7, $a8
	db $98, $c4, $00  ; BG map 0, row 6, column 4: 1 tile across
	db $ab
	db $99, $24, $00  ; BG map 0, row 9, column 4: 1 tile across
	db $ac
	db $99, $84, $00  ; BG map 0, row 12, column 4: 1 tile across
	db $ad
	db $99, $c2, $4f  ; BG map 0, row 14, column 2: 16 tiles repeated across
	db $a9
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $05 (wBGMapToLoad = $05, drawn by DrawRequestedBGMap while the LCD is off): $05: the name entry. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout05::
	db $98, $00, $50  ; BG map 0, row 0, column 0: 17 tiles repeated across
	db $8f
	db $98, $01, $00  ; BG map 0, row 0, column 1: 1 tile across
	db $9f
	db $98, $03, $00  ; BG map 0, row 0, column 3: 1 tile across
	db $9f
	db $98, $05, $00  ; BG map 0, row 0, column 5: 1 tile across
	db $9f
	db $98, $07, $00  ; BG map 0, row 0, column 7: 1 tile across
	db $9f
	db $98, $09, $00  ; BG map 0, row 0, column 9: 1 tile across
	db $9f
	db $98, $0b, $00  ; BG map 0, row 0, column 11: 1 tile across
	db $9f
	db $98, $0d, $00  ; BG map 0, row 0, column 13: 1 tile across
	db $9f
	db $98, $0f, $00  ; BG map 0, row 0, column 15: 1 tile across
	db $9f
	db $98, $20, $06  ; BG map 0, row 1, column 0: 7 tiles across
	db $9f, $85, $86, $87, $88, $8f, $9f
	db $98, $40, $06  ; BG map 0, row 2, column 0: 7 tiles across
	db $8f, $95, $96, $97, $98, $99, $8f
	db $98, $60, $06  ; BG map 0, row 3, column 0: 7 tiles across
	db $9f, $9a, $9b, $9c, $9d, $9e, $9f
	db $98, $2f, $00  ; BG map 0, row 1, column 15: 1 tile across
	db $8f
	db $98, $4f, $00  ; BG map 0, row 2, column 15: 1 tile across
	db $9f
	db $98, $6f, $00  ; BG map 0, row 3, column 15: 1 tile across
	db $8f
	db $98, $11, $42  ; BG map 0, row 0, column 17: 3 tiles repeated across
	db $7f
	db $98, $30, $43  ; BG map 0, row 1, column 16: 4 tiles repeated across
	db $7f
	db $98, $50, $03  ; BG map 0, row 2, column 16: 4 tiles across
	db $a1, $a0, $a1, $a0
	db $98, $70, $43  ; BG map 0, row 3, column 16: 4 tiles repeated across
	db $a2
	db $98, $80, $52  ; BG map 0, row 4, column 0: 19 tiles repeated across
	db $8f
	db $98, $81, $00  ; BG map 0, row 4, column 1: 1 tile across
	db $9f
	db $98, $83, $00  ; BG map 0, row 4, column 3: 1 tile across
	db $9f
	db $98, $85, $00  ; BG map 0, row 4, column 5: 1 tile across
	db $9f
	db $98, $87, $00  ; BG map 0, row 4, column 7: 1 tile across
	db $9f
	db $98, $89, $00  ; BG map 0, row 4, column 9: 1 tile across
	db $9f
	db $98, $8b, $00  ; BG map 0, row 4, column 11: 1 tile across
	db $9f
	db $98, $8d, $00  ; BG map 0, row 4, column 13: 1 tile across
	db $9f
	db $98, $8f, $00  ; BG map 0, row 4, column 15: 1 tile across
	db $9f
	db $98, $91, $00  ; BG map 0, row 4, column 17: 1 tile across
	db $9f
	db $98, $93, $00  ; BG map 0, row 4, column 19: 1 tile across
	db $9f
	db $98, $a0, $c9  ; BG map 0, row 5, column 0: 10 tiles repeated down
	db $9f
	db $98, $c0, $00  ; BG map 0, row 6, column 0: 1 tile across
	db $8f
	db $99, $00, $00  ; BG map 0, row 8, column 0: 1 tile across
	db $8f
	db $99, $40, $00  ; BG map 0, row 10, column 0: 1 tile across
	db $8f
	db $99, $80, $00  ; BG map 0, row 12, column 0: 1 tile across
	db $8f
	db $99, $c0, $00  ; BG map 0, row 14, column 0: 1 tile across
	db $8f
	db $98, $b3, $c9  ; BG map 0, row 5, column 19: 10 tiles repeated down
	db $8f
	db $98, $d3, $00  ; BG map 0, row 6, column 19: 1 tile across
	db $9f
	db $99, $13, $00  ; BG map 0, row 8, column 19: 1 tile across
	db $9f
	db $99, $53, $00  ; BG map 0, row 10, column 19: 1 tile across
	db $9f
	db $99, $93, $00  ; BG map 0, row 12, column 19: 1 tile across
	db $9f
	db $99, $d3, $00  ; BG map 0, row 14, column 19: 1 tile across
	db $9f
	db $9a, $20, $52  ; BG map 0, row 17, column 0: 19 tiles repeated across
	db $9f
	db $9a, $21, $00  ; BG map 0, row 17, column 1: 1 tile across
	db $8f
	db $9a, $23, $00  ; BG map 0, row 17, column 3: 1 tile across
	db $8f
	db $9a, $25, $00  ; BG map 0, row 17, column 5: 1 tile across
	db $8f
	db $9a, $27, $00  ; BG map 0, row 17, column 7: 1 tile across
	db $8f
	db $9a, $29, $00  ; BG map 0, row 17, column 9: 1 tile across
	db $8f
	db $9a, $2b, $00  ; BG map 0, row 17, column 11: 1 tile across
	db $8f
	db $9a, $2d, $00  ; BG map 0, row 17, column 13: 1 tile across
	db $8f
	db $9a, $2f, $00  ; BG map 0, row 17, column 15: 1 tile across
	db $8f
	db $9a, $31, $00  ; BG map 0, row 17, column 17: 1 tile across
	db $8f
	db $9a, $33, $00  ; BG map 0, row 17, column 19: 1 tile across
	db $8f
	db $98, $c2, $06  ; BG map 0, row 6, column 2: 7 tiles across
	db $00, $01, $02, $03, $04, $05, $06
	db $99, $02, $06  ; BG map 0, row 8, column 2: 7 tiles across
	db $07, $08, $09, $0a, $0b, $0c, $0d
	db $99, $42, $06  ; BG map 0, row 10, column 2: 7 tiles across
	db $0e, $0f, $10, $11, $12, $13, $14
	db $99, $82, $04  ; BG map 0, row 12, column 2: 5 tiles across
	db $15, $16, $17, $18, $19
	db $98, $cb, $06  ; BG map 0, row 6, column 11: 7 tiles across
	db $1a, $1b, $1c, $1d, $1e, $1f, $20
	db $99, $0b, $06  ; BG map 0, row 8, column 11: 7 tiles across
	db $21, $22, $23, $24, $25, $26, $27
	db $99, $4b, $06  ; BG map 0, row 10, column 11: 7 tiles across
	db $28, $29, $2a, $2b, $2c, $2d, $2e
	db $99, $8b, $04  ; BG map 0, row 12, column 11: 5 tiles across
	db $2f, $30, $31, $32, $3e
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $06 (wBGMapToLoad = $06, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout06::
	db $98, $00, $52  ; BG map 0, row 0, column 0: 19 tiles repeated across
	db $8f
	db $98, $01, $00  ; BG map 0, row 0, column 1: 1 tile across
	db $9f
	db $98, $03, $00  ; BG map 0, row 0, column 3: 1 tile across
	db $9f
	db $98, $05, $00  ; BG map 0, row 0, column 5: 1 tile across
	db $9f
	db $98, $07, $00  ; BG map 0, row 0, column 7: 1 tile across
	db $9f
	db $98, $09, $00  ; BG map 0, row 0, column 9: 1 tile across
	db $9f
	db $98, $0b, $00  ; BG map 0, row 0, column 11: 1 tile across
	db $9f
	db $98, $0d, $00  ; BG map 0, row 0, column 13: 1 tile across
	db $9f
	db $98, $0f, $00  ; BG map 0, row 0, column 15: 1 tile across
	db $9f
	db $98, $11, $00  ; BG map 0, row 0, column 17: 1 tile across
	db $9f
	db $98, $13, $00  ; BG map 0, row 0, column 19: 1 tile across
	db $9f
	db $98, $20, $d1  ; BG map 0, row 1, column 0: 18 tiles repeated down
	db $9f
	db $98, $40, $00  ; BG map 0, row 2, column 0: 1 tile across
	db $8f
	db $98, $80, $00  ; BG map 0, row 4, column 0: 1 tile across
	db $8f
	db $98, $c0, $00  ; BG map 0, row 6, column 0: 1 tile across
	db $8f
	db $99, $00, $00  ; BG map 0, row 8, column 0: 1 tile across
	db $8f
	db $99, $40, $00  ; BG map 0, row 10, column 0: 1 tile across
	db $8f
	db $99, $80, $00  ; BG map 0, row 12, column 0: 1 tile across
	db $8f
	db $99, $c0, $00  ; BG map 0, row 14, column 0: 1 tile across
	db $8f
	db $9a, $00, $00  ; BG map 0, row 16, column 0: 1 tile across
	db $8f
	db $98, $33, $d1  ; BG map 0, row 1, column 19: 18 tiles repeated down
	db $8f
	db $98, $53, $00  ; BG map 0, row 2, column 19: 1 tile across
	db $9f
	db $98, $93, $00  ; BG map 0, row 4, column 19: 1 tile across
	db $9f
	db $98, $d3, $00  ; BG map 0, row 6, column 19: 1 tile across
	db $9f
	db $99, $13, $00  ; BG map 0, row 8, column 19: 1 tile across
	db $9f
	db $99, $53, $00  ; BG map 0, row 10, column 19: 1 tile across
	db $9f
	db $99, $93, $00  ; BG map 0, row 12, column 19: 1 tile across
	db $9f
	db $99, $d3, $00  ; BG map 0, row 14, column 19: 1 tile across
	db $9f
	db $9a, $13, $00  ; BG map 0, row 16, column 19: 1 tile across
	db $9f
	db $9a, $21, $50  ; BG map 0, row 17, column 1: 17 tiles repeated across
	db $8f
	db $9a, $22, $00  ; BG map 0, row 17, column 2: 1 tile across
	db $9f
	db $9a, $24, $00  ; BG map 0, row 17, column 4: 1 tile across
	db $9f
	db $9a, $26, $00  ; BG map 0, row 17, column 6: 1 tile across
	db $9f
	db $9a, $28, $00  ; BG map 0, row 17, column 8: 1 tile across
	db $9f
	db $9a, $2a, $00  ; BG map 0, row 17, column 10: 1 tile across
	db $9f
	db $9a, $2c, $00  ; BG map 0, row 17, column 12: 1 tile across
	db $9f
	db $9a, $2e, $00  ; BG map 0, row 17, column 14: 1 tile across
	db $9f
	db $9a, $30, $00  ; BG map 0, row 17, column 16: 1 tile across
	db $9f
	db $9a, $32, $00  ; BG map 0, row 17, column 18: 1 tile across
	db $9f
	db $98, $42, $0a  ; BG map 0, row 2, column 2: 11 tiles across
	db $04, $11, $00, $12, $04, $7e, $16, $07, $08, $02, $07
	db $98, $8a, $07  ; BG map 0, row 4, column 10: 8 tiles across
	db $0f, $0b, $00, $18, $04, $11, $7e, $3c
	db $98, $c4, $00  ; BG map 0, row 6, column 4: 1 tile across
	db $ab
	db $99, $24, $00  ; BG map 0, row 9, column 4: 1 tile across
	db $ac
	db $99, $84, $00  ; BG map 0, row 12, column 4: 1 tile across
	db $ad
	db $99, $c2, $4f  ; BG map 0, row 14, column 2: 16 tiles repeated across
	db $a9
	db $99, $e4, $0d  ; BG map 0, row 15, column 4: 14 tiles across
	db $11, $04, $13, $14, $11, $0d, $7e, $13, $0e, $7e, $0c, $04, $0d, $14
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $0C (wBGMapToLoad = $0C, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout0C::
	db $98, $00, $52  ; BG map 0, row 0, column 0: 19 tiles repeated across
	db $8f
	db $98, $01, $00  ; BG map 0, row 0, column 1: 1 tile across
	db $9f
	db $98, $03, $00  ; BG map 0, row 0, column 3: 1 tile across
	db $9f
	db $98, $05, $00  ; BG map 0, row 0, column 5: 1 tile across
	db $9f
	db $98, $07, $00  ; BG map 0, row 0, column 7: 1 tile across
	db $9f
	db $98, $09, $00  ; BG map 0, row 0, column 9: 1 tile across
	db $9f
	db $98, $0b, $00  ; BG map 0, row 0, column 11: 1 tile across
	db $9f
	db $98, $0d, $00  ; BG map 0, row 0, column 13: 1 tile across
	db $9f
	db $98, $0f, $00  ; BG map 0, row 0, column 15: 1 tile across
	db $9f
	db $98, $11, $00  ; BG map 0, row 0, column 17: 1 tile across
	db $9f
	db $98, $13, $00  ; BG map 0, row 0, column 19: 1 tile across
	db $9f
	db $98, $20, $d1  ; BG map 0, row 1, column 0: 18 tiles repeated down
	db $9f
	db $98, $40, $00  ; BG map 0, row 2, column 0: 1 tile across
	db $8f
	db $98, $80, $00  ; BG map 0, row 4, column 0: 1 tile across
	db $8f
	db $98, $c0, $00  ; BG map 0, row 6, column 0: 1 tile across
	db $8f
	db $99, $00, $00  ; BG map 0, row 8, column 0: 1 tile across
	db $8f
	db $99, $40, $00  ; BG map 0, row 10, column 0: 1 tile across
	db $8f
	db $99, $80, $00  ; BG map 0, row 12, column 0: 1 tile across
	db $8f
	db $99, $c0, $00  ; BG map 0, row 14, column 0: 1 tile across
	db $8f
	db $9a, $00, $00  ; BG map 0, row 16, column 0: 1 tile across
	db $8f
	db $98, $33, $d1  ; BG map 0, row 1, column 19: 18 tiles repeated down
	db $8f
	db $98, $53, $00  ; BG map 0, row 2, column 19: 1 tile across
	db $9f
	db $98, $93, $00  ; BG map 0, row 4, column 19: 1 tile across
	db $9f
	db $98, $d3, $00  ; BG map 0, row 6, column 19: 1 tile across
	db $9f
	db $99, $13, $00  ; BG map 0, row 8, column 19: 1 tile across
	db $9f
	db $99, $53, $00  ; BG map 0, row 10, column 19: 1 tile across
	db $9f
	db $99, $93, $00  ; BG map 0, row 12, column 19: 1 tile across
	db $9f
	db $99, $d3, $00  ; BG map 0, row 14, column 19: 1 tile across
	db $9f
	db $9a, $13, $00  ; BG map 0, row 16, column 19: 1 tile across
	db $9f
	db $9a, $21, $50  ; BG map 0, row 17, column 1: 17 tiles repeated across
	db $8f
	db $9a, $22, $00  ; BG map 0, row 17, column 2: 1 tile across
	db $9f
	db $9a, $24, $00  ; BG map 0, row 17, column 4: 1 tile across
	db $9f
	db $9a, $26, $00  ; BG map 0, row 17, column 6: 1 tile across
	db $9f
	db $9a, $28, $00  ; BG map 0, row 17, column 8: 1 tile across
	db $9f
	db $9a, $2a, $00  ; BG map 0, row 17, column 10: 1 tile across
	db $9f
	db $9a, $2c, $00  ; BG map 0, row 17, column 12: 1 tile across
	db $9f
	db $9a, $2e, $00  ; BG map 0, row 17, column 14: 1 tile across
	db $9f
	db $9a, $30, $00  ; BG map 0, row 17, column 16: 1 tile across
	db $9f
	db $9a, $32, $00  ; BG map 0, row 17, column 18: 1 tile across
	db $9f
	db $99, $c2, $4f  ; BG map 0, row 14, column 2: 16 tiles repeated across
	db $a9
	db $98, $42, $0a  ; BG map 0, row 2, column 2: 11 tiles across
	db $02, $0e, $0f, $18, $7e, $0f, $0b, $00, $18, $04, $11
	db $98, $84, $0c  ; BG map 0, row 4, column 4: 13 tiles across
	db $3f, $05, $11, $0e, $0c, $3f, $7e, $7e, $7e, $3f, $13, $0e, $3f
	db $98, $c3, $00  ; BG map 0, row 6, column 3: 1 tile across
	db $ab
	db $98, $cc, $00  ; BG map 0, row 6, column 12: 1 tile across
	db $ab
	db $99, $23, $00  ; BG map 0, row 9, column 3: 1 tile across
	db $ac
	db $99, $2c, $00  ; BG map 0, row 9, column 12: 1 tile across
	db $ac
	db $99, $83, $00  ; BG map 0, row 12, column 3: 1 tile across
	db $ad
	db $99, $8c, $00  ; BG map 0, row 12, column 12: 1 tile across
	db $ad
	db $99, $e4, $0d  ; BG map 0, row 15, column 4: 14 tiles across
	db $11, $04, $13, $14, $11, $0d, $7e, $13, $0e, $7e, $0c, $04, $0d, $14
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $02 (wBGMapToLoad = $02, drawn by DrawRequestedBGMap while the LCD is off): $02: entering an overworld room (WorldLoadRoom step 0). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout02::
	db $9c, $00, $53, $7f, $9c, $20, $53, $7f, $9c, $40, $53, $7f, $9c
	db $60, $53, $7f, $9c, $80, $53, $7f, $9c, $a0, $53, $7f, $9c, $c0, $53, $7f, $9c
	db $e0, $53, $7f, $9d, $00, $53, $7f, $9d, $20, $53, $7f, $9d, $40, $53, $7f, $9d
	db $60, $53, $7f, $9d, $80, $53, $7f, $9d, $a0, $53, $7f, $9d, $c0, $53, $7f, $9d
	db $e0, $53, $7f, $9e, $00, $53, $7f, $9e, $20, $53, $7f, $9c, $00, $0e, $bd, $7f
	db $7f, $7f, $be, $bb, $7f, $7f, $7f, $be, $cf, $7f, $7f, $7f, $7f, $9c, $20, $0e
	db $bc, $7f, $7f, $7f, $bf, $bc, $7f, $7f, $7f, $bf, $7f, $7f, $7f, $7f, $7f, $9c
	db $40, $53, $cc, $9c, $68, $d3, $8d, $9c, $e9, $49, $7f, $9d, $09, $49, $7f, $9d
	db $0a, $c8, $7f

;@ path: gfx/bgmap/layouts
;@ Screen layout $09 (wBGMapToLoad = $09, drawn by DrawRequestedBGMap while the LCD is off): $09: entering a house, a cave, the egg or a side-view area (WorldLoadRoom step 0). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout09::
	db $9a, $14, $0b  ; BG map 0, row 16, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $9a, $34, $0b  ; BG map 0, row 17, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $9a, $54, $0b  ; BG map 0, row 18, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $9a, $74, $0b  ; BG map 0, row 19, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $9a, $94, $0b  ; BG map 0, row 20, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $9a, $b4, $0b  ; BG map 0, row 21, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $9a, $d4, $0b  ; BG map 0, row 22, column 20: 12 tiles across
	db $2c, $2d, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $2a, $2b
	db $9a, $f4, $0b  ; BG map 0, row 23, column 20: 12 tiles across
	db $7f, $3d, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $3a, $7f
	db $9b, $14, $0b  ; BG map 0, row 24, column 20: 12 tiles across
	db $7f, $7f, $2c, $2d, $7c, $7c, $7c, $7c, $2a, $2b, $7f, $7f
	db $9b, $34, $0b  ; BG map 0, row 25, column 20: 12 tiles across
	db $7f, $7f, $7f, $3d, $3e, $3f, $3e, $3f, $3a, $7f, $7f, $7f
	db $98, $14, $0b  ; BG map 0, row 0, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $98, $34, $0b  ; BG map 0, row 1, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $98, $54, $0b  ; BG map 0, row 2, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $98, $74, $0b  ; BG map 0, row 3, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $98, $94, $0b  ; BG map 0, row 4, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $98, $b4, $0b  ; BG map 0, row 5, column 20: 12 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $98, $d4, $0b  ; BG map 0, row 6, column 20: 12 tiles across
	db $2c, $2d, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $2a, $2b
	db $98, $f4, $0b  ; BG map 0, row 7, column 20: 12 tiles across
	db $7f, $3d, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $3a, $7f
	db $99, $14, $0b  ; BG map 0, row 8, column 20: 12 tiles across
	db $7f, $7f, $2c, $2d, $7c, $7c, $7c, $7c, $2a, $2b, $7f, $7f
	db $99, $34, $0b  ; BG map 0, row 9, column 20: 12 tiles across
	db $7f, $7f, $7f, $3d, $3e, $3f, $3e, $3f, $3a, $7f, $7f, $7f
	db $00  ; end
;@ path: gfx/bgmap/layouts
;@ Screen layout $0B (wBGMapToLoad = $0B, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout0B::
	db $9c, $00, $5f  ; BG map 1, row 0, column 0: 32 tiles repeated across
	db $7e
	db $9c, $20, $5f  ; BG map 1, row 1, column 0: 32 tiles repeated across
	db $7e
	db $9c, $40, $5f  ; BG map 1, row 2, column 0: 32 tiles repeated across
	db $7e
	db $9c, $60, $5f  ; BG map 1, row 3, column 0: 32 tiles repeated across
	db $7e
	db $9c, $80, $5f  ; BG map 1, row 4, column 0: 32 tiles repeated across
	db $7e
	db $9c, $a0, $5f  ; BG map 1, row 5, column 0: 32 tiles repeated across
	db $7e
	db $9c, $c0, $5f  ; BG map 1, row 6, column 0: 32 tiles repeated across
	db $7e
	db $9c, $e0, $5f  ; BG map 1, row 7, column 0: 32 tiles repeated across
	db $7e
	db $9d, $00, $5f  ; BG map 1, row 8, column 0: 32 tiles repeated across
	db $7e
	db $9d, $20, $5f  ; BG map 1, row 9, column 0: 32 tiles repeated across
	db $7e
	db $9d, $40, $5f  ; BG map 1, row 10, column 0: 32 tiles repeated across
	db $7e
	db $9d, $60, $5f  ; BG map 1, row 11, column 0: 32 tiles repeated across
	db $7e
	db $9d, $80, $5f  ; BG map 1, row 12, column 0: 32 tiles repeated across
	db $7e
	db $9d, $a0, $5f  ; BG map 1, row 13, column 0: 32 tiles repeated across
	db $7e
	db $9d, $c0, $5f  ; BG map 1, row 14, column 0: 32 tiles repeated across
	db $7e
	db $9d, $e0, $5f  ; BG map 1, row 15, column 0: 32 tiles repeated across
	db $7e
	db $9e, $00, $5f  ; BG map 1, row 16, column 0: 32 tiles repeated across
	db $7e
	db $9e, $20, $5f  ; BG map 1, row 17, column 0: 32 tiles repeated across
	db $7e
	db $9e, $40, $5f  ; BG map 1, row 18, column 0: 32 tiles repeated across
	db $7e
	db $9e, $60, $5f  ; BG map 1, row 19, column 0: 32 tiles repeated across
	db $7e
	db $9e, $80, $5f  ; BG map 1, row 20, column 0: 32 tiles repeated across
	db $7e
	db $9e, $a0, $5f  ; BG map 1, row 21, column 0: 32 tiles repeated across
	db $7e
	db $9e, $c0, $5f  ; BG map 1, row 22, column 0: 32 tiles repeated across
	db $7e
	db $9e, $e0, $5f  ; BG map 1, row 23, column 0: 32 tiles repeated across
	db $7e
	db $9f, $00, $5f  ; BG map 1, row 24, column 0: 32 tiles repeated across
	db $7e
	db $9f, $20, $5f  ; BG map 1, row 25, column 0: 32 tiles repeated across
	db $7e
	db $9f, $40, $5f  ; BG map 1, row 26, column 0: 32 tiles repeated across
	db $7e
	db $9f, $60, $5f  ; BG map 1, row 27, column 0: 32 tiles repeated across
	db $7e
	db $9f, $80, $5f  ; BG map 1, row 28, column 0: 32 tiles repeated across
	db $7e
	db $9f, $a0, $5f  ; BG map 1, row 29, column 0: 32 tiles repeated across
	db $7e
	db $9f, $c0, $5f  ; BG map 1, row 30, column 0: 32 tiles repeated across
	db $7e
	db $9f, $e0, $5f  ; BG map 1, row 31, column 0: 32 tiles repeated across
	db $7e
	db $9c, $a9, $41  ; BG map 1, row 5, column 9: 2 tiles repeated across
	db $7f
	db $9c, $c8, $43  ; BG map 1, row 6, column 8: 4 tiles repeated across
	db $7f
	db $9c, $e7, $45  ; BG map 1, row 7, column 7: 6 tiles repeated across
	db $7f
	db $9d, $07, $45  ; BG map 1, row 8, column 7: 6 tiles repeated across
	db $7f
	db $9d, $28, $43  ; BG map 1, row 9, column 8: 4 tiles repeated across
	db $7f
	db $9d, $49, $41  ; BG map 1, row 10, column 9: 2 tiles repeated across
	db $7f
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $0A (wBGMapToLoad = $0A, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout0A::
	db $98, $65, $4b  ; BG map 0, row 3, column 5: 12 tiles repeated across
	db $7f
	db $98, $83, $4d  ; BG map 0, row 4, column 3: 14 tiles repeated across
	db $7f
	db $98, $a3, $4d  ; BG map 0, row 5, column 3: 14 tiles repeated across
	db $7f
	db $98, $c3, $4d  ; BG map 0, row 6, column 3: 14 tiles repeated across
	db $7f
	db $98, $e3, $4d  ; BG map 0, row 7, column 3: 14 tiles repeated across
	db $7f
	db $99, $03, $4d  ; BG map 0, row 8, column 3: 14 tiles repeated across
	db $7f
	db $99, $23, $4d  ; BG map 0, row 9, column 3: 14 tiles repeated across
	db $7f
	db $99, $43, $4d  ; BG map 0, row 10, column 3: 14 tiles repeated across
	db $7f
	db $99, $63, $4d  ; BG map 0, row 11, column 3: 14 tiles repeated across
	db $7f
	db $99, $83, $4d  ; BG map 0, row 12, column 3: 14 tiles repeated across
	db $7f
	db $99, $a3, $4d  ; BG map 0, row 13, column 3: 14 tiles repeated across
	db $7f
	db $99, $c3, $4d  ; BG map 0, row 14, column 3: 14 tiles repeated across
	db $7f
	db $98, $42, $0f  ; BG map 0, row 2, column 2: 16 tiles across
	db $90, $91, $92, $93, $94, $98, $99, $98, $99, $98, $99, $98, $99, $98, $99, $a4
	db $98, $62, $02  ; BG map 0, row 3, column 2: 3 tiles across
	db $95, $96, $97
	db $98, $82, $8b  ; BG map 0, row 4, column 2: 12 tiles down
	db $9e, $9c, $9e, $9c, $9e, $9c, $9e, $9c, $9e, $9c, $9e, $a5
	db $99, $e3, $0e  ; BG map 0, row 15, column 3: 15 tiles across
	db $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $a6
	db $98, $71, $8b  ; BG map 0, row 3, column 17: 12 tiles down
	db $9d, $9f, $9d, $9f, $9d, $9f, $9d, $9f, $9d, $9f, $9d, $9f
	db $9a, $03, $0e  ; BG map 0, row 16, column 3: 15 tiles across
	db $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7
	db $98, $86, $47  ; BG map 0, row 4, column 6: 8 tiles repeated across
	db $a2
	db $98, $a5, $09  ; BG map 0, row 5, column 5: 10 tiles across
	db $a0, $80, $81, $82, $83, $84, $85, $86, $87, $a1
	db $98, $c5, $09  ; BG map 0, row 6, column 5: 10 tiles across
	db $a0, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $a1
	db $98, $e6, $47  ; BG map 0, row 7, column 6: 8 tiles repeated across
	db $a3
	db $99, $05, $0a  ; BG map 0, row 8, column 5: 11 tiles across
	db $a9, $aa, $ab, $ac, $ad, $b0, $b1, $b2, $b3, $b4, $b5
	db $99, $45, $07  ; BG map 0, row 10, column 5: 8 tiles across
	db $a9, $aa, $ab, $ac, $ad, $b6, $b7, $b8
	db $99, $85, $05  ; BG map 0, row 12, column 5: 6 tiles across
	db $b0, $b1, $b2, $b3, $b4, $b5
	db $99, $a5, $0a  ; BG map 0, row 13, column 5: 11 tiles across
	db $c5, $c6, $c7, $c8, $c9, $ca, $a9, $aa, $cb, $cc, $cd
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $0D (wBGMapToLoad = $0D, drawn by DrawRequestedBGMap while the LCD is off). A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout0D::
	db $98, $a5, $4b  ; BG map 0, row 5, column 5: 12 tiles repeated across
	db $7f
	db $98, $c3, $4d  ; BG map 0, row 6, column 3: 14 tiles repeated across
	db $7f
	db $98, $e3, $4d  ; BG map 0, row 7, column 3: 14 tiles repeated across
	db $7f
	db $99, $03, $4d  ; BG map 0, row 8, column 3: 14 tiles repeated across
	db $7f
	db $99, $23, $4d  ; BG map 0, row 9, column 3: 14 tiles repeated across
	db $7f
	db $99, $43, $4d  ; BG map 0, row 10, column 3: 14 tiles repeated across
	db $7f
	db $98, $82, $0f  ; BG map 0, row 4, column 2: 16 tiles across
	db $90, $91, $92, $93, $94, $98, $99, $98, $99, $98, $99, $98, $99, $98, $99, $a4
	db $98, $a2, $02  ; BG map 0, row 5, column 2: 3 tiles across
	db $95, $96, $97
	db $98, $c2, $84  ; BG map 0, row 6, column 2: 5 tiles down
	db $9e, $9c, $9e, $9c, $9e
	db $98, $b1, $85  ; BG map 0, row 5, column 17: 6 tiles down
	db $9d, $9f, $9d, $9f, $9d, $9f
	db $99, $62, $0f  ; BG map 0, row 11, column 2: 16 tiles across
	db $a5, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $9a, $9b, $a6
	db $99, $83, $0e  ; BG map 0, row 12, column 3: 15 tiles across
	db $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7, $a8, $a7
	db $98, $e5, $09  ; BG map 0, row 7, column 5: 10 tiles across
	db $b9, $ba, $bb, $bc, $bd, $c0, $c1, $c2, $c3, $c4
	db $99, $25, $07  ; BG map 0, row 9, column 5: 8 tiles across
	db $a9, $aa, $ab, $ac, $ad, $b6, $b7, $b8
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $0E (wBGMapToLoad = $0E, drawn by DrawRequestedBGMap while the LCD is off): $0E: the storm at sea of the opening. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout0E::
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $7f
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $7f
	db $98, $40, $5f  ; BG map 0, row 2, column 0: 32 tiles repeated across
	db $7f
	db $98, $60, $5f  ; BG map 0, row 3, column 0: 32 tiles repeated across
	db $7f
	db $98, $80, $1f  ; BG map 0, row 4, column 0: 32 tiles across
	db $80, $81, $82, $83, $80, $81, $82, $83, $80, $81, $82, $83, $80, $81, $82, $83
	db $80, $81, $82, $83, $80, $81, $82, $83, $80, $81, $82, $83, $80, $81, $82, $83
	db $98, $a0, $1f  ; BG map 0, row 5, column 0: 32 tiles across
	db $84, $85, $86, $87, $84, $85, $86, $87, $84, $85, $86, $87, $84, $85, $86, $87
	db $84, $85, $86, $87, $84, $85, $86, $87, $84, $85, $86, $87, $84, $85, $86, $87
	db $98, $c0, $1f  ; BG map 0, row 6, column 0: 32 tiles across
	db $88, $89, $8a, $8b, $88, $89, $8a, $8b, $88, $89, $8a, $8b, $88, $89, $8a, $8b
	db $88, $89, $8a, $8b, $88, $89, $8a, $8b, $88, $89, $8a, $8b, $88, $89, $8a, $8b
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $7c
	db $99, $00, $5f  ; BG map 0, row 8, column 0: 32 tiles repeated across
	db $7c
	db $99, $20, $5f  ; BG map 0, row 9, column 0: 32 tiles repeated across
	db $7c
	db $99, $40, $1f  ; BG map 0, row 10, column 0: 32 tiles across
	db $90, $91, $92, $93, $90, $91, $92, $93, $90, $91, $92, $93, $90, $91, $92, $93
	db $90, $91, $92, $93, $90, $91, $92, $93, $90, $91, $92, $93, $90, $91, $92, $93
	db $99, $60, $1f  ; BG map 0, row 11, column 0: 32 tiles across
	db $94, $95, $96, $97, $94, $95, $96, $97, $94, $95, $96, $97, $94, $95, $96, $97
	db $94, $95, $96, $97, $94, $95, $96, $97, $94, $95, $96, $97, $94, $95, $96, $97
	db $99, $80, $1f  ; BG map 0, row 12, column 0: 32 tiles across
	db $8c, $8d, $8e, $8f, $8c, $8d, $8e, $8f, $8c, $8d, $8e, $8f, $8c, $8d, $8e, $8f
	db $8c, $8d, $8e, $8f, $8c, $8d, $8e, $8f, $8c, $8d, $8e, $8f, $8c, $8d, $8e, $8f
	db $99, $a0, $1f  ; BG map 0, row 13, column 0: 32 tiles across
	db $98, $99, $9a, $9b, $98, $99, $9a, $9b, $98, $99, $9a, $9b, $98, $99, $9a, $9b
	db $98, $99, $9a, $9b, $98, $99, $9a, $9b, $98, $99, $9a, $9b, $98, $99, $9a, $9b
	db $99, $c0, $1f  ; BG map 0, row 14, column 0: 32 tiles across
	db $7f, $7f, $9c, $9d, $7f, $7f, $9c, $9d, $7f, $7f, $9c, $9d, $7f, $7f, $9c, $9d
	db $7f, $7f, $9c, $9d, $7f, $7f, $9c, $9d, $7f, $7f, $9c, $9d, $7f, $7f, $9c, $9d
	db $99, $e0, $5f  ; BG map 0, row 15, column 0: 32 tiles repeated across
	db $7f
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $7f
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $7f
	db $9a, $40, $5f  ; BG map 0, row 18, column 0: 32 tiles repeated across
	db $7f
	db $9a, $60, $5f  ; BG map 0, row 19, column 0: 32 tiles repeated across
	db $7f
	db $00  ; end
;@ path: gfx/bgmap/layouts
;@ Screen layout $0F (wBGMapToLoad = $0F, drawn by DrawRequestedBGMap while the LCD is off): $0F: Link at the mast in the opening. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout0F::
	db $98, $00, $5f  ; BG map 0, row 0, column 0: 32 tiles repeated across
	db $7f
	db $98, $20, $5f  ; BG map 0, row 1, column 0: 32 tiles repeated across
	db $7f
	db $98, $40, $1f  ; BG map 0, row 2, column 0: 32 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $a0, $a1, $a2, $a3, $a4, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $98, $60, $1f  ; BG map 0, row 3, column 0: 32 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $27, $28, $29, $2a, $b3, $b4, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $98, $80, $1f  ; BG map 0, row 4, column 0: 32 tiles across
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $a5, $a6, $a7, $a8, $a9, $7f, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $98, $a0, $1f  ; BG map 0, row 5, column 0: 32 tiles across
	db $7f, $7f, $9e, $7f, $7f, $7f, $7f, $b0, $b1, $b2, $aa, $ab, $7f, $ac, $7f, $7f
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $98, $c0, $1f  ; BG map 0, row 6, column 0: 32 tiles across
	db $7f, $7f, $9f, $ad, $7f, $b6, $b7, $a1, $a2, $b9, $ba, $bb, $bc, $bd, $be, $bf
	db $c0, $c1, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $98, $e0, $1f  ; BG map 0, row 7, column 0: 32 tiles across
	db $7f, $7f, $ae, $af, $b5, $c2, $c3, $b1, $b2, $c5, $c6, $c7, $c8, $c9, $ca, $cb
	db $cc, $cd, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $00, $1f  ; BG map 0, row 8, column 0: 32 tiles across
	db $7f, $7f, $ce, $cf, $b8, $d0, $d1, $a2, $a3, $d2, $d3, $d4, $d5, $d6, $d7, $d8
	db $d9, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $20, $1f  ; BG map 0, row 9, column 0: 32 tiles across
	db $7f, $7f, $7f, $dc, $dd, $de, $c4, $b2, $b3, $df, $e0, $e1, $e2, $e3, $e4, $e5
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $40, $1f  ; BG map 0, row 10, column 0: 32 tiles across
	db $7f, $7f, $7f, $7f, $e8, $e9, $ea, $eb, $a4, $7f, $ec, $ed, $ee, $ef, $f0, $f1
	db $f2, $f3, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $60, $1f  ; BG map 0, row 11, column 0: 32 tiles across
	db $7f, $7f, $7f, $7f, $b0, $b1, $f4, $f5, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fd
	db $fe, $ff, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $80, $1f  ; BG map 0, row 12, column 0: 32 tiles across
	db $7f, $7f, $7f, $a0, $a1, $a2, $a3, $00, $01, $02, $03, $04, $05, $06, $07, $08
	db $09, $0a, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $a0, $1f  ; BG map 0, row 13, column 0: 32 tiles across
	db $7f, $7f, $7f, $b0, $b1, $b2, $b3, $0b, $0c, $0d, $0e, $0f, $10, $11, $12, $13
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $c0, $1f  ; BG map 0, row 14, column 0: 32 tiles across
	db $7f, $7f, $a0, $a1, $a2, $a3, $a4, $7f, $7f, $7f, $14, $15, $16, $17, $18, $19
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $99, $e0, $1f  ; BG map 0, row 15, column 0: 32 tiles across
	db $7f, $7f, $b0, $b1, $b2, $b3, $b4, $7f, $7f, $db, $e6, $e7, $1a, $1b, $1c, $1d
	db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
	db $9a, $00, $5f  ; BG map 0, row 16, column 0: 32 tiles repeated across
	db $7f
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $7f
	db $9a, $40, $5f  ; BG map 0, row 18, column 0: 32 tiles repeated across
	db $7f
	db $9a, $60, $5f  ; BG map 0, row 19, column 0: 32 tiles repeated across
	db $7f
	db $9b, $a0, $5f  ; BG map 0, row 29, column 0: 32 tiles repeated across
	db $7f
	db $9b, $c0, $5f  ; BG map 0, row 30, column 0: 32 tiles repeated across
	db $7f
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $10 (wBGMapToLoad = $10, drawn by DrawRequestedBGMap while the LCD is off): $10: the beach of the opening. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout10::
	db $98, $00, $1f  ; BG map 0, row 0, column 0: 32 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $98, $20, $1f  ; BG map 0, row 1, column 0: 32 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $40, $41, $42, $43, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $98, $40, $1f  ; BG map 0, row 2, column 0: 32 tiles across
	db $7c, $7c, $7c, $7c, $40, $41, $42, $43, $47, $48, $49, $4a, $40, $41, $42, $43
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $98, $60, $1f  ; BG map 0, row 3, column 0: 32 tiles across
	db $40, $41, $42, $43, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $98, $80, $5f  ; BG map 0, row 4, column 0: 32 tiles repeated across
	db $7d
	db $98, $a0, $5f  ; BG map 0, row 5, column 0: 32 tiles repeated across
	db $7d
	db $98, $c0, $5f  ; BG map 0, row 6, column 0: 32 tiles repeated across
	db $7d
	db $98, $e0, $5f  ; BG map 0, row 7, column 0: 32 tiles repeated across
	db $7d
	db $99, $00, $1f  ; BG map 0, row 8, column 0: 32 tiles across
	db $38, $39, $3a, $3b, $38, $39, $3a, $3b, $38, $39, $3a, $3b, $38, $39, $3a, $3b
	db $38, $39, $3a, $3b, $38, $39, $3a, $3b, $38, $39, $3a, $3b, $38, $39, $3a, $3b
	db $99, $20, $1f  ; BG map 0, row 9, column 0: 32 tiles across
	db $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f
	db $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f, $3c, $3d, $3e, $3f
	db $99, $40, $1f  ; BG map 0, row 10, column 0: 32 tiles across
	db $60, $61, $62, $63, $60, $61, $62, $63, $60, $61, $62, $63, $60, $61, $62, $63
	db $60, $61, $62, $63, $60, $61, $62, $63, $60, $61, $62, $63, $60, $61, $62, $63
	db $99, $60, $1f  ; BG map 0, row 11, column 0: 32 tiles across
	db $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f
	db $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f, $4e, $4f
	db $99, $80, $5f  ; BG map 0, row 12, column 0: 32 tiles repeated across
	db $7e
	db $99, $a0, $5f  ; BG map 0, row 13, column 0: 32 tiles repeated across
	db $7e
	db $99, $c0, $5f  ; BG map 0, row 14, column 0: 32 tiles repeated across
	db $64
	db $99, $e0, $1f  ; BG map 0, row 15, column 0: 32 tiles across
	db $30, $31, $32, $33, $30, $31, $32, $33, $30, $31, $32, $33, $30, $31, $32, $33
	db $30, $31, $32, $33, $30, $31, $32, $33, $30, $31, $32, $33, $30, $31, $32, $33
	db $9a, $00, $1f  ; BG map 0, row 16, column 0: 32 tiles across
	db $34, $35, $36, $37, $34, $35, $36, $37, $34, $35, $36, $37, $34, $35, $36, $37
	db $34, $35, $36, $37, $34, $35, $36, $37, $34, $35, $36, $37, $34, $35, $36, $37
	db $9a, $20, $5f  ; BG map 0, row 17, column 0: 32 tiles repeated across
	db $7c
	db $00  ; end

;@ path: gfx/bgmap/layouts
;@ Screen layout $11 (wBGMapToLoad = $11, drawn by DrawRequestedBGMap while the LCD is off): $11: the title screen. A list of draw commands: VRAM address (high byte first), mode byte (bits 0-5 = count - 1; bits 6-7: 0 = tiles along a BG map row, 1 = one tile repeated along the row, 2 = tiles down a column, 3 = one tile repeated down the column), then the tile numbers; $00 ends the list (DrawCommands).
ScreenLayout11::
	db $98, $00, $53  ; BG map 0, row 0, column 0: 20 tiles repeated across
	db $7c
	db $98, $20, $53  ; BG map 0, row 1, column 0: 20 tiles repeated across
	db $7c
	db $98, $40, $13  ; BG map 0, row 2, column 0: 20 tiles across
	db $7c, $7c, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d
	db $8e, $8f, $7c, $7c
	db $98, $60, $13  ; BG map 0, row 3, column 0: 20 tiles across
	db $7c, $7c, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d
	db $9e, $9f, $7c, $7c
	db $98, $80, $13  ; BG map 0, row 4, column 0: 20 tiles across
	db $7c, $7c, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad
	db $ae, $af, $7c, $7c
	db $98, $a0, $13  ; BG map 0, row 5, column 0: 20 tiles across
	db $7c, $7c, $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd
	db $be, $bf, $7c, $7c
	db $98, $c0, $13  ; BG map 0, row 6, column 0: 20 tiles across
	db $7c, $7c, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd
	db $ce, $cf, $7c, $7c
	db $98, $e0, $13  ; BG map 0, row 7, column 0: 20 tiles across
	db $7c, $7c, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd
	db $de, $df, $7c, $7c
	db $99, $00, $13  ; BG map 0, row 8, column 0: 20 tiles across
	db $7c, $7c, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed
	db $ee, $ef, $7c, $7c
	db $99, $20, $13  ; BG map 0, row 9, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $2b, $2c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c
	db $99, $40, $13  ; BG map 0, row 10, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $50, $51, $52, $53, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c
	db $99, $60, $13  ; BG map 0, row 11, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $54, $55, $56, $57, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c
	db $99, $80, $13  ; BG map 0, row 12, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $58, $59, $5a, $5b, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c
	db $99, $a0, $13  ; BG map 0, row 13, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $5c, $5d, $5e, $5f, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c
	db $99, $c0, $13  ; BG map 0, row 14, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $46, $7d, $7d, $7d, $7d, $4b, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c
	db $99, $e0, $13  ; BG map 0, row 15, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $7c, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $7c
	db $7c, $7c, $7c, $7c
	db $9a, $00, $13  ; BG map 0, row 16, column 0: 20 tiles across
	db $7c, $7c, $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $4c, $4d
	db $7c, $7c, $7c, $7c
	db $9a, $20, $13  ; BG map 0, row 17, column 0: 20 tiles across
	db $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $4c, $4d, $7c, $7c
	db $00  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank08FreeSpace::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
