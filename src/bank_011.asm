; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $011", ROMX[$4000], BANK[$11]

;@ path: gfx/sprites/entities
;@ Entity graphics set $40: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles40::
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $3f, $00, $59, $3e
	db $ae, $71, $a7, $78, $51, $3e, $61, $1e, $72, $2d, $ff, $61, $ff, $01, $e2, $dd
	db $00, $00, $00, $00, $73, $00, $9f, $63, $1f, $ec, $3b, $dc, $bb, $5c, $ff, $1c
	db $ee, $1b, $b7, $6b, $75, $fb, $9a, $fd, $9b, $fd, $f7, $fb, $ff, $f7, $6e, $f7
	db $52, $3d, $6e, $31, $d3, $6c, $e1, $5e, $c9, $7e, $b3, $7c, $7e, $01, $3d, $03
	db $26, $1b, $76, $3b, $6e, $33, $7e, $43, $76, $7b, $07, $01, $03, $00, $01, $00
	db $7e, $ef, $7f, $ef, $19, $ef, $99, $6f, $ff, $0f, $76, $8f, $3a, $c7, $4c, $b3
	db $87, $78, $82, $7d, $0b, $fd, $35, $fb, $5d, $e3, $be, $c1, $f7, $06, $c3, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $3f, $00, $59, $3e
	db $af, $70, $9f, $67, $78, $0f, $77, $38, $cf, $70, $df, $60, $bf, $70, $4f, $38
	db $03, $00, $07, $03, $7c, $07, $9d, $66, $1b, $e6, $3f, $ce, $73, $9c, $ef, $30
	db $ff, $20, $ff, $20, $df, $b0, $7f, $d0, $bf, $69, $df, $39, $e6, $19, $fd, $02
	db $7f, $08, $7d, $0e, $d7, $6f, $d9, $67, $cc, $73, $a7, $78, $7f, $00, $3c, $03
	db $26, $1b, $76, $3b, $6e, $33, $7e, $43, $76, $7b, $07, $01, $03, $00, $01, $00
	db $fd, $03, $ee, $19, $ff, $f4, $fb, $ec, $37, $d8, $ff, $10, $ff, $10, $ff, $10
	db $ff, $10, $af, $58, $37, $ce, $13, $ee, $5d, $e6, $bd, $c6, $ff, $03, $c7, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $41: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles41::
	db $00, $00, $03, $00, $0c, $03, $14, $0b, $20, $1f, $20, $1f, $24, $1b, $2a, $1d
	db $2e, $1d, $1e, $0d, $16, $0d, $0a, $05, $06, $01, $02, $01, $01, $00, $01, $00
	db $f3, $00, $0c, $f3, $03, $fc, $60, $9f, $85, $7b, $82, $7d, $89, $7e, $e4, $1f
	db $d2, $2f, $ba, $77, $be, $7b, $bc, $63, $95, $6a, $5f, $a1, $3d, $c3, $89, $77
	db $e5, $1b, $a4, $5b, $a9, $57, $69, $17, $49, $37, $84, $7b, $84, $7b, $81, $7f
	db $45, $3b, $26, $19, $22, $1d, $22, $1d, $21, $1f, $10, $0f, $0c, $03, $03, $00
	db $07, $00, $08, $07, $30, $0f, $51, $2e, $b3, $6d, $b6, $49, $f7, $28, $b7, $68
	db $b3, $6c, $b0, $4f, $f0, $2f, $b8, $77, $9f, $78, $4f, $3f, $20, $1f, $1f, $00
	db $f3, $00, $0c, $f3, $03, $fc, $60, $9f, $85, $7b, $82, $7d, $89, $7e, $e4, $1f
	db $72, $8f, $da, $27, $ce, $33, $a4, $5b, $95, $6a, $4f, $b1, $3d, $c3, $89, $77
	db $01, $01, $03, $02, $07, $04, $0f, $0c, $1f, $14, $17, $1a, $23, $3d, $23, $3e
	db $27, $3c, $2f, $3c, $37, $3c, $37, $1c, $17, $1e, $15, $1f, $1c, $0f, $07, $03
	db $ff, $ff, $ff, $20, $ff, $20, $ff, $58, $ff, $86, $ff, $81, $ff, $81, $ef, $f1
	db $f7, $99, $f9, $cf, $bd, $e7, $9d, $f7, $cf, $fe, $ff, $3c, $ff, $88, $7f, $c8
	db $ff, $f8, $df, $70, $df, $73, $ff, $74, $cf, $78, $8f, $f8, $87, $fc, $87, $ff
	db $9f, $fc, $ef, $74, $e7, $3a, $e7, $3b, $67, $3c, $7f, $18, $3f, $08, $1f, $07
;@ path: gfx/sprites/entities
;@ Entity graphics set $42: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles42::
	db $03, $00, $0f, $00, $1f, $00, $3f, $03, $3f, $01, $3f, $06, $57, $38, $73, $3c
	db $7b, $34, $63, $3c, $67, $38, $47, $38, $49, $30, $33, $01, $07, $02, $07, $00
	db $80, $00, $c0, $00, $e0, $00, $f0, $00, $f0, $00, $f8, $00, $b8, $40, $bc, $40
	db $bc, $40, $dc, $20, $ec, $10, $f8, $00, $dc, $20, $cc, $70, $a8, $d0, $f8, $00
	db $38, $00, $2f, $10, $3f, $00, $3f, $00, $7f, $06, $7f, $02, $7f, $0c, $af, $70
	db $e7, $78, $f7, $68, $c7, $78, $cf, $70, $8f, $70, $93, $61, $67, $02, $07, $00
	db $0f, $00, $17, $08, $ae, $10, $fc, $00, $ff, $00, $f7, $08, $fe, $00, $fc, $00
	db $f8, $00, $f0, $00, $fc, $00, $fe, $00, $dc, $20, $c8, $70, $a8, $d0, $f8, $00
	db $07, $00, $0f, $07, $3f, $0c, $7c, $2b, $ff, $68, $ff, $4f, $7f, $10, $3a, $15
	db $38, $17, $3f, $18, $3f, $1f, $1f, $0f, $0f, $07, $07, $00, $00, $00, $00, $00
	db $c0, $00, $e0, $c0, $f0, $e0, $fc, $60, $fe, $7c, $ff, $de, $fe, $10, $38, $d0
	db $7c, $b0, $fe, $64, $ff, $de, $ff, $f2, $f2, $e0, $e0, $00, $00, $00, $00, $00
	db $00, $00, $07, $00, $cf, $07, $ff, $4c, $fc, $6b, $7f, $28, $3f, $0f, $3f, $10
	db $3a, $15, $3a, $15, $3a, $15, $38, $17, $1f, $08, $0f, $07, $07, $00, $00, $00
	db $00, $00, $c0, $00, $e7, $c0, $ff, $e6, $fe, $6c, $fc, $78, $f8, $d0, $f8, $10
	db $3a, $d0, $7f, $b2, $7f, $a6, $7e, $bc, $fc, $70, $f0, $e0, $e0, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $43: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles43::
	db $0f, $00, $3f, $0f, $7f, $33, $7f, $2d, $7f, $2d, $3f, $0d, $3f, $0e, $3f, $1a
	db $3f, $1f, $1f, $0c, $0f, $03, $1f, $0b, $3f, $0c, $ef, $30, $cf, $70, $70, $00
	db $c0, $00, $ec, $c0, $fe, $ec, $ff, $ee, $ff, $f6, $ff, $f6, $f9, $f6, $fe, $f0
	db $f0, $20, $60, $80, $f0, $00, $d0, $20, $30, $c0, $f8, $00, $f8, $00, $00, $00
	db $1f, $00, $3f, $1f, $7f, $30, $7f, $36, $ff, $6f, $ff, $5f, $ff, $5f, $7f, $16
	db $3f, $1f, $1f, $0e, $0f, $01, $1f, $01, $17, $08, $3f, $06, $3d, $0e, $1f, $00
	db $80, $00, $f8, $80, $fc, $d8, $fe, $ec, $fe, $74, $fa, $74, $fc, $b0, $f8, $c0
	db $e8, $90, $f0, $60, $f0, $60, $e0, $80, $90, $60, $f8, $00, $f8, $00, $00, $00
	db $1f, $00, $3f, $1f, $7f, $30, $7f, $36, $ff, $6f, $ff, $5f, $ff, $5f, $7f, $16
	db $3f, $1f, $1f, $06, $3f, $19, $3f, $19, $1f, $00, $30, $0f, $3f, $00, $00, $00
	db $80, $00, $f8, $80, $fc, $d8, $fe, $ec, $fe, $74, $fa, $74, $fc, $b0, $f8, $d0
	db $f0, $a0, $e0, $00, $e0, $80, $e0, $80, $90, $60, $78, $80, $f8, $00, $00, $00
	db $07, $00, $6f, $04, $ff, $6b, $ff, $67, $7f, $0b, $7f, $0f, $7f, $0d, $3f, $0d
	db $37, $0d, $1b, $07, $1f, $00, $0f, $00, $1b, $04, $3c, $03, $77, $38, $7f, $00
	db $c0, $00, $f0, $c0, $f8, $70, $fc, $b8, $fe, $38, $ff, $ca, $ff, $f6, $ff, $e6
	db $d6, $ec, $bc, $c0, $f8, $00, $fc, $00, $fc, $30, $7c, $b0, $f8, $00, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $44: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles44::
	db $0f, $00, $3f, $00, $47, $38, $9b, $7c, $bd, $7e, $ff, $06, $07, $02, $03, $00
	db $01, $00, $00, $00, $01, $00, $03, $01, $02, $01, $03, $00, $07, $03, $07, $00
	db $81, $00, $c7, $00, $ff, $c7, $ff, $4c, $fd, $7e, $fe, $a7, $fe, $a7, $fd, $ae
	db $fb, $fc, $ff, $70, $fc, $53, $fc, $73, $7e, $81, $24, $c3, $42, $81, $81, $00
	db $01, $00, $01, $00, $00, $00, $01, $00, $03, $00, $07, $00, $07, $00, $0d, $02
	db $0b, $06, $0f, $06, $0f, $06, $0b, $06, $07, $02, $05, $02, $03, $00, $01, $00
	db $c7, $00, $ef, $c7, $ff, $4c, $fd, $7e, $fe, $a7, $fe, $a7, $fd, $ae, $fb, $fc
	db $ff, $70, $ff, $50, $ff, $70, $7e, $81, $99, $e7, $db, $24, $a5, $c3, $c3, $00
	db $03, $00, $3c, $03, $79, $37, $db, $75, $bb, $54, $f9, $46, $ac, $43, $e7, $40
	db $a7, $42, $e7, $42, $a2, $40, $e0, $40, $a0, $40, $e0, $40, $90, $60, $70, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $00, $7b, $30, $dc, $73
	db $b9, $57, $eb, $55, $ab, $54, $e9, $56, $bc, $43, $e7, $40, $97, $62, $73, $00
	db $01, $00, $0e, $01, $33, $0d, $5f, $21, $9f, $6c, $ff, $1d, $bf, $5d, $bf, $5e
	db $bf, $5d, $bf, $43, $7f, $1b, $4f, $3d, $47, $3e, $21, $1e, $19, $06, $07, $00
	db $e0, $00, $10, $e0, $dc, $e0, $f2, $ec, $f9, $16, $fd, $da, $fd, $9a, $fd, $6a
	db $ff, $e0, $fd, $ee, $fd, $de, $f9, $de, $f2, $1c, $f4, $e8, $18, $e0, $e0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $45: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles45::
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $05, $03, $07, $02
	db $05, $02, $07, $02, $05, $02, $03, $00, $03, $01, $02, $01, $01, $00, $00, $00
	db $07, $00, $0f, $00, $0f, $01, $3f, $01, $ff, $07, $bf, $ed, $ff, $0d, $7f, $f7
	db $ff, $ab, $ff, $fa, $75, $cb, $ff, $00, $db, $bd, $cf, $bb, $c6, $3b, $3f, $00
	db $f0, $00, $f8, $00, $f8, $00, $fe, $00, $ff, $c0, $ff, $6c, $fe, $7c, $ff, $fc
	db $ff, $f0, $ee, $70, $d8, $e0, $f0, $00, $60, $80, $50, $a0, $f0, $00, $f0, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $05, $03, $07, $02, $05, $02
	db $07, $02, $05, $02, $03, $00, $03, $01, $02, $01, $01, $00, $00, $00, $00, $00
	db $07, $00, $0f, $00, $1f, $04, $ff, $04, $af, $f7, $ff, $05, $7f, $f5, $ff, $af
	db $ff, $ef, $7f, $cb, $ff, $07, $f7, $b8, $d7, $bb, $8f, $77, $7f, $06, $1f, $00
	db $e0, $00, $f0, $00, $f0, $00, $f8, $00, $fc, $00, $fe, $b0, $fe, $b0, $fc, $f0
	db $de, $e0, $be, $c0, $7c, $80, $e0, $00, $e0, $00, $90, $60, $f0, $00, $f0, $00
	db $0f, $00, $1f, $00, $1f, $06, $1f, $07, $0f, $05, $1f, $05, $3f, $17, $3f, $1f
	db $3f, $1f, $1f, $04, $1f, $07, $3f, $1b, $3f, $18, $1f, $00, $39, $1e, $3f, $00
	db $78, $00, $fc, $00, $fc, $c0, $fc, $c0, $f0, $40, $f8, $40, $fc, $d8, $fc, $f8
	db $f8, $f0, $f0, $c0, $f8, $b0, $f8, $30, $f8, $00, $f8, $00, $bc, $78, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $46: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles46::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $0f, $07, $1f, $0f, $1f, $0f, $7f, $0a
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $80, $00, $c0, $80, $f0, $c0, $f8, $f0, $f8, $d0
	db $7f, $22, $ec, $5f, $e0, $5f, $ff, $60, $ff, $7f, $77, $18, $3f, $00, $7f, $1b
	db $7f, $00, $ff, $66, $88, $77, $7f, $00, $ef, $73, $42, $3d, $3f, $00, $00, $00
	db $f0, $a0, $f8, $70, $f8, $70, $f8, $e0, $fc, $f0, $fc, $e8, $fc, $08, $7c, $88
	db $7c, $88, $fc, $18, $f6, $78, $f2, $6c, $56, $a8, $0c, $f0, $f8, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $03, $01, $07, $03, $1f, $02, $3f, $18
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $e0, $00, $f0, $e0, $fc, $f0, $fe, $bc, $fe, $a4
	db $3b, $17, $78, $37, $7f, $38, $7f, $3f, $3b, $0c, $1f, $00, $3f, $0c, $3f, $00
	db $7f, $33, $44, $3b, $3f, $00, $7f, $31, $46, $39, $21, $1e, $1f, $00, $00, $00
	db $3c, $d8, $3e, $dc, $fe, $38, $fe, $fc, $ff, $78, $ff, $02, $df, $e2, $df, $22
	db $ff, $02, $7f, $be, $ff, $3e, $ea, $94, $29, $d6, $03, $fc, $fe, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $47: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles47::
	db $07, $00, $3f, $00, $7f, $02, $ff, $07, $ff, $0f, $ff, $2b, $ff, $3b, $d3, $3f
	db $7f, $1f, $2f, $1e, $37, $0f, $2c, $13, $7f, $34, $73, $2f, $30, $0f, $3f, $00
	db $e0, $00, $fc, $00, $fe, $80, $ff, $c0, $ff, $e0, $ff, $ac, $ff, $bc, $9a, $fc
	db $ff, $fa, $f5, $fa, $ee, $f0, $77, $88, $ff, $58, $be, $d8, $1c, $e0, $fc, $00
	db $07, $00, $3f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $01
	db $7e, $03, $3d, $02, $3f, $00, $7f, $20, $77, $28, $23, $1c, $23, $1f, $3f, $00
	db $e0, $00, $7c, $80, $7e, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $c0
	db $1e, $e0, $fc, $00, $38, $c0, $fc, $08, $fc, $08, $ec, $10, $e4, $f8, $fc, $00
	db $1f, $00, $3f, $00, $3f, $0c, $3f, $1e, $3f, $1f, $3f, $17, $7f, $37, $73, $3f
	db $7f, $3f, $7f, $3f, $3f, $1f, $11, $0e, $0f, $01, $1f, $0b, $16, $0b, $0f, $00
	db $c0, $00, $f8, $00, $fc, $00, $fe, $00, $ae, $70, $fe, $70, $de, $f0, $ec, $f0
	db $be, $c4, $b7, $c8, $7f, $80, $df, $20, $5e, $a0, $48, $b0, $84, $78, $fc, $00
	db $0f, $00, $3f, $00, $7f, $0a, $7f, $1f, $7f, $1f, $3f, $1b, $7f, $3b, $79, $3f
	db $7f, $3f, $7f, $1f, $2f, $1f, $10, $0f, $0f, $00, $1d, $0e, $11, $0e, $0f, $00
	db $e0, $00, $fc, $00, $fe, $00, $ff, $00, $d7, $b8, $ff, $b8, $ef, $f8, $f6, $f8
	db $dc, $e0, $de, $e4, $b6, $c8, $fe, $00, $bc, $c0, $e8, $d0, $64, $d8, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $48: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles48::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $04, $0f, $00, $0f, $10
	db $1f, $00, $1f, $00, $1f, $08, $1b, $0e, $1e, $03, $0f, $00, $03, $04, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $20, $70, $80, $f0, $08
	db $58, $e0, $f8, $a0, $58, $e0, $f8, $00, $f0, $08, $f0, $00, $c0, $20, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $04, $0f, $00, $0f, $10
	db $1f, $0c, $1f, $0b, $0f, $02, $17, $08, $10, $0f, $0f, $00, $03, $04, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $20, $70, $80, $f0, $08
	db $a8, $70, $f8, $50, $a8, $f0, $78, $80, $f0, $08, $f0, $00, $c0, $20, $00, $00
	db $00, $00, $01, $00, $01, $00, $03, $01, $03, $01, $0f, $00, $1e, $01, $1f, $20
	db $3e, $01, $3f, $01, $3e, $11, $37, $1c, $3d, $06, $1f, $00, $07, $08, $00, $00
	db $c0, $00, $e6, $c0, $ef, $c6, $ff, $8e, $df, $6e, $9f, $66, $ff, $0e, $ff, $0e
	db $bf, $c6, $f6, $40, $b0, $c0, $f0, $00, $e0, $10, $e0, $00, $80, $40, $00, $00
	db $00, $00, $00, $00, $01, $00, $01, $00, $03, $01, $0f, $00, $1e, $01, $1f, $20
	db $3f, $18, $3f, $16, $1f, $05, $2e, $11, $21, $1e, $1f, $00, $07, $08, $00, $00
	db $00, $00, $c0, $00, $e6, $c0, $ef, $c6, $ff, $8e, $df, $6e, $df, $26, $ff, $0e
	db $5f, $ee, $ff, $a6, $56, $e0, $f0, $00, $e0, $10, $e0, $00, $80, $40, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $49: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles49::
	db $3c, $00, $3e, $1c, $3f, $16, $3f, $18, $3f, $10, $17, $08, $1f, $00, $7f, $01
	db $bf, $41, $ff, $01, $ff, $03, $7f, $0b, $3f, $0f, $7f, $07, $ff, $13, $ff, $00
	db $1f, $00, $3f, $1e, $ff, $26, $ff, $9e, $de, $3c, $ee, $1c, $7c, $80, $fc, $80
	db $fe, $80, $ff, $80, $ff, $50, $ff, $70, $ee, $f0, $fc, $c0, $fe, $88, $ff, $00
	db $0e, $00, $0f, $06, $0f, $04, $0f, $01, $1f, $00, $2f, $10, $3b, $04, $3f, $04
	db $7f, $04, $7f, $06, $7f, $05, $3f, $0d, $3f, $0f, $3f, $0f, $7f, $07, $ff, $00
	db $78, $00, $fc, $78, $fc, $48, $fc, $38, $f8, $70, $f8, $30, $fc, $00, $fe, $00
	db $ff, $00, $ff, $00, $bf, $60, $fe, $e0, $dc, $e0, $fe, $80, $ff, $20, $ff, $00
	db $fc, $0b, $77, $18, $3f, $13, $1f, $05, $0f, $06, $0f, $04, $0e, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $40, $be, $60, $d8, $30, $f0, $80, $e0, $c0, $c0, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $4A: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles4A::
	db $00, $00, $01, $00, $07, $01, $0f, $06, $1f, $0e, $1f, $0d, $3f, $1b, $2f, $1b
	db $37, $0b, $7d, $43, $74, $4b, $77, $68, $3e, $21, $3e, $31, $1f, $1c, $07, $07
	db $0e, $00, $1f, $0e, $7f, $0d, $ff, $75, $fd, $7b, $fc, $7b, $fe, $21, $7f, $1c
	db $7f, $3d, $ff, $bb, $ff, $83, $f7, $c9, $7f, $60, $3e, $31, $1f, $1c, $07, $07
	db $07, $00, $3f, $01, $7f, $12, $7f, $3a, $7f, $09, $3f, $18, $3f, $08, $7f, $08
	db $ff, $19, $fb, $77, $f3, $6f, $6f, $1b, $2f, $1c, $17, $0f, $0f, $00, $00, $00
	db $fc, $00, $e2, $9c, $fd, $42, $ff, $40, $df, $a0, $e8, $10, $e8, $10, $f8, $00
	db $ff, $c0, $ff, $c6, $ff, $86, $9e, $6c, $bc, $d8, $7c, $98, $9c, $08, $0c, $00
	db $38, $00, $58, $20, $b8, $40, $bf, $40, $b9, $46, $f7, $08, $ff, $30, $ff, $48
	db $ff, $48, $ff, $30, $ff, $00, $7f, $1f, $7f, $35, $7f, $13, $3e, $03, $03, $00
	db $e0, $00, $f0, $60, $ff, $70, $ff, $1e, $fe, $0c, $ec, $10, $e4, $d8, $fa, $ec
	db $fe, $f4, $fe, $74, $9e, $6c, $da, $3c, $d4, $b8, $48, $b0, $f0, $00, $80, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0e, $00
	db $12, $0c, $2e, $10, $2e, $10, $5e, $20, $5e, $20, $ff, $81, $ff, $c3, $7e, $7e
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $00
	db $2c, $10, $2c, $10, $2c, $10, $6e, $52, $ef, $91, $ff, $81, $ff, $c3, $7e, $7e
;@ path: gfx/sprites/entities
;@ Entity graphics set $4B: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles4B::
	db $0e, $00, $1d, $0e, $20, $1f, $20, $1f, $25, $1a, $1f, $05, $1f, $0f, $1f, $02
	db $7f, $1d, $bf, $55, $bf, $5d, $9f, $62, $bf, $48, $b7, $4f, $af, $50, $ef, $1c
	db $f8, $00, $64, $f8, $02, $fc, $02, $fc, $82, $7c, $c4, $b8, $e8, $d0, $fc, $20
	db $fe, $c8, $fd, $5a, $f5, $da, $f9, $26, $dd, $e2, $bd, $c2, $e5, $1a, $f7, $38
	db $7f, $0c, $6f, $33, $7f, $3f, $7f, $29, $7f, $3f, $7f, $22, $7f, $3f, $7f, $25
	db $7f, $3f, $7f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $07, $00, $0c, $07, $11, $0e, $10, $0f, $16, $09, $1f, $06, $1f, $0f, $3f, $03
	db $7f, $2c, $ff, $2d, $bf, $4d, $bf, $53, $bf, $47, $b7, $4f, $af, $50, $ef, $1c
	db $7c, $00, $a2, $7c, $41, $fe, $01, $fe, $01, $fe, $01, $fe, $82, $7c, $b4, $48
	db $fe, $30, $f9, $b6, $e9, $f6, $f9, $c6, $bd, $c2, $7d, $82, $e5, $1a, $f7, $38
	db $0e, $00, $0a, $04, $0e, $00, $0a, $04, $0a, $04, $0e, $00, $0a, $04, $11, $0e
	db $15, $0e, $1f, $00, $15, $0e, $25, $1e, $2d, $1e, $4d, $3e, $5d, $2a, $7f, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $4C: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles4C::
	db $38, $00, $5f, $20, $bf, $40, $fc, $03, $b7, $78, $ff, $03, $1f, $07, $3f, $0e
	db $3e, $0d, $7e, $0d, $7f, $0e, $bf, $47, $ff, $43, $bf, $60, $5f, $3f, $3f, $00
	db $1c, $00, $f2, $0c, $fd, $02, $3f, $c0, $ed, $1e, $ff, $c0, $f8, $e0, $fc, $70
	db $7c, $b0, $7e, $90, $9e, $60, $cd, $b2, $ff, $82, $fd, $06, $fa, $fc, $fc, $00
	db $00, $00, $00, $00, $1e, $00, $21, $1e, $47, $3f, $77, $0d, $ef, $77, $e8, $17
	db $f0, $6f, $fc, $5f, $ff, $3e, $7f, $3e, $5e, $3f, $2d, $1e, $1f, $01, $1f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $00, $60, $80, $1e, $e0
	db $1d, $e2, $39, $c6, $1a, $e4, $14, $e8, $f8, $00, $f0, $40, $d0, $e0, $f0, $00
	db $00, $00, $0f, $00, $10, $0f, $23, $1f, $3b, $06, $77, $3b, $74, $0b, $78, $37
	db $7e, $2f, $3f, $1e, $3f, $1e, $3f, $1f, $2f, $1f, $11, $0e, $0f, $01, $1f, $00
	db $00, $00, $00, $00, $80, $00, $c0, $80, $c0, $80, $e0, $80, $1e, $e0, $1d, $e2
	db $39, $c6, $1a, $e4, $14, $e8, $e8, $10, $70, $80, $e0, $40, $d0, $e0, $f0, $00
	db $e0, $00, $f0, $00, $9e, $60, $61, $1e, $47, $3f, $77, $0d, $ef, $77, $e8, $17
	db $f0, $6f, $fc, $5f, $fe, $3f, $7e, $3f, $5e, $3f, $2d, $1e, $1f, $01, $1f, $00
	db $07, $00, $1f, $00, $2f, $10, $4f, $30, $83, $7c, $82, $7c, $02, $fc, $06, $f8
	db $09, $f6, $31, $ce, $02, $fc, $04, $f8, $78, $80, $f0, $40, $d0, $e0, $f0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $4D: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles4D::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $0e, $00, $1f, $0e, $0f, $01, $01, $00, $00, $00, $06, $00, $0f, $00, $0d, $02
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $70, $00
	db $79, $30, $3b, $10, $9f, $08, $fe, $8b, $b6, $49, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $f0, $00, $38, $c0, $f8, $00, $fc, $00, $fc, $00, $fc, $00, $bc, $00, $d8, $00
	db $0f, $00, $0f, $00, $1f, $00, $1f, $08, $17, $0c, $0f, $06, $07, $03, $03, $01
	db $01, $00, $00, $00, $01, $00, $03, $01, $03, $00, $00, $00, $00, $00, $00, $00
	db $ff, $18, $ff, $18, $ff, $18, $ff, $35, $ff, $b7, $fe, $ff, $ff, $7c, $7f, $b8
	db $7f, $82, $e7, $5b, $fb, $c5, $d1, $8e, $9f, $00, $1e, $0b, $1f, $0a, $1e, $00
	db $c7, $00, $cf, $06, $dd, $0e, $fe, $1c, $fa, $3c, $fc, $78, $68, $f0, $30, $c0
	db $c0, $00, $80, $00, $c0, $80, $c0, $00, $80, $00, $80, $00, $00, $00, $00, $00
	db $0f, $00, $0f, $00, $0f, $00, $07, $00, $03, $00, $01, $00, $00, $00, $01, $00
	db $02, $01, $07, $03, $0f, $06, $1f, $0d, $3f, $18, $18, $00, $00, $00, $00, $00
	db $c0, $00, $c0, $00, $c0, $00, $c0, $00, $80, $00, $80, $00, $80, $00, $40, $80
	db $f0, $c0, $f8, $70, $fc, $b8, $fe, $1c, $9f, $06, $87, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $4E: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles4E::
	db $0f, $00, $1f, $0c, $ff, $00, $f9, $7e, $7f, $00, $1f, $0d, $1f, $05, $7f, $1f
	db $bf, $5e, $9e, $61, $c0, $3f, $ff, $40, $fc, $5b, $7f, $18, $1b, $07, $3f, $00
	db $f8, $00, $b4, $78, $7a, $fc, $6a, $fc, $02, $fc, $fc, $00, $e4, $d8, $e8, $10
	db $30, $c0, $18, $e0, $78, $80, $98, $60, $38, $c0, $f8, $00, $20, $c0, $f0, $00
	db $3f, $00, $5b, $3c, $bd, $7e, $ad, $7e, $81, $7e, $7f, $01, $4f, $37, $6f, $11
	db $31, $0e, $a0, $1f, $f0, $0f, $ff, $60, $fc, $5b, $7f, $18, $1b, $07, $3f, $00
	db $e0, $00, $f0, $60, $fe, $00, $3e, $fc, $fc, $00, $f0, $60, $f8, $40, $fc, $f0
	db $fa, $f4, $f2, $0c, $04, $f8, $f8, $00, $38, $c0, $f8, $00, $20, $c0, $f0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $00
	db $7f, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00
	db $bc, $c0, $7b, $fc, $f6, $0f, $0d, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $1c, $00, $3f, $1c, $1f, $03, $03, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $80, $00, $e0, $80, $78, $e0, $dc, $38, $2e, $1c
	db $17, $0e, $0b, $07, $05, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $4F: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles4F::
	db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $37, $0f, $5f, $3f, $bf, $7f
	db $bf, $7f, $5f, $3f, $37, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $02, $01, $05, $03, $07, $03, $0b, $07, $0f, $07, $0f, $07, $0f, $07
	db $0f, $07, $0f, $07, $0f, $07, $0b, $07, $07, $03, $05, $03, $02, $01, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1f, $00, $6f, $1f, $bf, $7f
	db $bf, $7f, $6f, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $02, $01, $03, $01, $05, $03, $07, $03, $07, $03, $07, $03, $07, $03
	db $07, $03, $07, $03, $07, $03, $07, $03, $05, $03, $03, $01, $02, $01, $01, $00
	db $00, $00, $00, $00, $1f, $00, $2e, $1f, $3f, $1f, $3f, $1f, $3f, $1f, $2f, $1f
	db $1f, $0f, $17, $0f, $0f, $07, $05, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $18, $00, $26, $18, $2d, $1e, $1f, $0f, $17, $0f, $0f, $07
	db $07, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
	db $01, $00, $01, $00, $1f, $00, $3f, $00, $3e, $00, $1c, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $80, $00, $c0, $00, $60, $00, $70, $00, $30, $00
	db $30, $00, $20, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $50: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles50::
	db $00, $00, $00, $00, $00, $00, $03, $00, $07, $03, $3f, $02, $7e, $3d, $fd, $6a
	db $fa, $45, $fc, $53, $f0, $7f, $e3, $7c, $c4, $3b, $60, $1f, $7f, $00, $9f, $00
	db $1e, $00, $19, $0e, $25, $1a, $df, $20, $b0, $40, $50, $a0, $98, $60, $18, $e0
	db $78, $80, $30, $c0, $20, $c0, $20, $c0, $20, $c0, $60, $80, $c0, $00, $80, $00
	db $00, $00, $07, $00, $1d, $07, $38, $1f, $22, $1d, $67, $39, $66, $3b, $cd, $76
	db $fa, $7d, $7d, $02, $1c, $03, $1e, $01, $0f, $00, $0f, $00, $07, $00, $00, $00
	db $00, $00, $00, $00, $80, $00, $c0, $80, $e0, $80, $70, $a0, $b8, $60, $9c, $68
	db $7f, $88, $15, $ea, $f7, $08, $34, $c8, $f8, $00, $c0, $00, $80, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $1d, $03, $27, $1f, $5e, $21, $bf, $40
	db $bf, $43, $bf, $43, $bc, $43, $5f, $20, $5f, $20, $27, $18, $18, $07, $07, $00
	db $00, $00, $0c, $00, $fe, $0c, $7a, $e4, $8c, $f0, $04, $f8, $c4, $f8, $44, $f8
	db $88, $70, $48, $b0, $50, $a0, $d0, $20, $d0, $20, $a0, $40, $40, $80, $80, $00
	db $3c, $00, $7c, $38, $6f, $30, $5e, $3f, $27, $18, $1a, $00, $0a, $00, $0a, $00
	db $0a, $00, $0a, $00, $0a, $00, $0a, $00, $3f, $00, $60, $3f, $4f, $30, $70, $00
	db $00, $00, $00, $00, $80, $00, $40, $80, $20, $c0, $90, $60, $c8, $30, $a4, $18
	db $b2, $0c, $aa, $04, $a5, $02, $a5, $02, $a5, $02, $79, $86, $02, $fc, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $51: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles51::
	db $01, $00, $02, $01, $06, $01, $09, $06, $18, $07, $24, $1b, $62, $1d, $91, $6e
	db $89, $76, $4f, $31, $bf, $4c, $9f, $61, $ba, $7d, $47, $38, $38, $00, $00, $00
	db $80, $00, $40, $80, $20, $c0, $10, $e0, $88, $70, $44, $b8, $26, $d8, $3f, $c6
	db $ff, $30, $ff, $86, $f9, $36, $ce, $b0, $70, $80, $80, $00, $00, $00, $00, $00
	db $06, $00, $07, $02, $04, $03, $02, $01, $02, $01, $05, $02, $05, $02, $0a, $04
	db $0a, $04, $14, $08, $14, $08, $28, $10, $2f, $10, $60, $3f, $7f, $00, $00, $00
	db $b0, $00, $fc, $a0, $12, $e0, $a9, $40, $25, $c0, $d3, $20, $50, $20, $28, $10
	db $28, $10, $14, $08, $14, $08, $08, $00, $fe, $00, $02, $fc, $fe, $00, $00, $00
	db $00, $00, $07, $00, $0b, $07, $10, $0f, $21, $1f, $43, $3e, $47, $3c, $4f, $38
	db $5f, $30, $7f, $22, $7f, $01, $7f, $19, $5f, $2e, $2f, $17, $17, $08, $0f, $00
	db $00, $00, $f0, $00, $f8, $c0, $fc, $88, $fe, $04, $ff, $26, $ff, $1a, $ff, $9c
	db $fd, $6a, $fa, $74, $f4, $a8, $e8, $d0, $d0, $a0, $a0, $40, $40, $80, $80, $00
	db $00, $00, $07, $00, $1f, $07, $38, $1f, $61, $3e, $63, $3d, $63, $3c, $79, $1e
	db $7f, $27, $7f, $18, $7f, $27, $7f, $30, $7d, $26, $3b, $0c, $1a, $05, $07, $00
	db $1c, $00, $fe, $14, $fa, $ac, $f4, $58, $ec, $b0, $d6, $6c, $a6, $dc, $de, $38
	db $fe, $e4, $fe, $18, $fa, $e4, $f2, $0c, $36, $c8, $24, $d8, $78, $80, $e0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $52: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles52::
	db $07, $00, $18, $07, $23, $1f, $2f, $10, $5f, $20, $7e, $01, $4d, $33, $b5, $7b
	db $bf, $79, $ba, $6d, $ff, $2c, $5e, $35, $62, $1d, $3e, $01, $17, $0c, $0e, $00
	db $03, $00, $0c, $03, $17, $0f, $2f, $1c, $6d, $13, $fb, $47, $e8, $17, $4f, $30
	db $5f, $20, $ef, $1f, $ef, $57, $af, $59, $57, $2f, $38, $07, $1f, $00, $07, $00
	db $80, $00, $60, $80, $b8, $c0, $fc, $00, $7a, $84, $7d, $86, $fd, $06, $fd, $06
	db $fd, $06, $7d, $86, $b9, $c6, $ba, $c4, $b2, $cc, $64, $98, $f8, $00, $c0, $00
	db $00, $00, $03, $00, $0f, $00, $1e, $01, $3d, $03, $3d, $03, $5e, $21, $5f, $20
	db $5f, $20, $4f, $30, $27, $18, $25, $1b, $14, $0b, $0c, $03, $03, $00, $00, $00
	db $06, $00, $09, $06, $15, $0e, $1b, $0c, $1f, $08, $17, $08, $1e, $01, $1d, $03
	db $7d, $03, $9e, $61, $af, $70, $5b, $3c, $3f, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $07, $00, $18, $07, $26, $1f, $73, $0c, $8c, $73, $a9, $77
	db $9d, $63, $6f, $1c, $2d, $1e, $21, $1e, $13, $0c, $0c, $00, $00, $00, $00, $00
	db $18, $00, $3c, $18, $3a, $1c, $12, $0c, $1e, $00, $15, $0e, $7f, $06, $ef, $71
	db $fe, $6d, $7d, $0e, $09, $06, $07, $00, $0b, $06, $05, $02, $02, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $7f, $06, $e9, $76
	db $9e, $60, $74, $18, $3e, $00, $7e, $0c, $b4, $68, $cc, $70, $90, $60, $60, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $53: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles53::
	db $04, $00, $0e, $04, $0e, $04, $0e, $04, $0f, $06, $0f, $07, $1f, $07, $3b, $17
	db $6d, $33, $5e, $21, $ff, $00, $fe, $01, $fc, $03, $bc, $43, $be, $61, $5b, $3c
	db $00, $00, $03, $00, $04, $03, $09, $07, $13, $0f, $f3, $0f, $f1, $ee, $f3, $ed
	db $d3, $ed, $23, $dd, $c1, $3e, $30, $cf, $f9, $d7, $dd, $eb, $2d, $f3, $81, $7e
	db $7f, $00, $f7, $38, $9b, $7d, $8f, $7b, $8f, $75, $4f, $35, $3b, $05, $0c, $03
	db $17, $08, $20, $1f, $2f, $10, $3f, $00, $27, $18, $4f, $30, $7f, $00, $3f, $00
	db $e3, $1d, $f3, $0c, $db, $a5, $cf, $30, $e3, $df, $f1, $8f, $bf, $d0, $6f, $9b
	db $b1, $4f, $0f, $f0, $04, $fb, $87, $78, $cf, $30, $ff, $00, $f8, $00, $e0, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $05, $03, $fb, $07, $f3, $ef, $f3, $ee
	db $d1, $ee, $21, $de, $c1, $3e, $00, $ff, $f8, $e7, $6d, $f3, $15, $fb, $81, $7e
	db $ff, $80, $df, $3f, $bf, $7f, $9f, $60, $be, $41, $b7, $48, $b1, $4e, $b4, $4b
	db $bf, $40, $b7, $49, $b2, $4d, $9b, $64, $8f, $70, $e4, $1b, $31, $0e, $1f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1e, $00, $3f, $10
	db $6f, $31, $5f, $21, $ff, $00, $ff, $01, $fd, $03, $bc, $43, $be, $61, $5b, $3c
	db $00, $00, $00, $00, $03, $00, $75, $03, $e9, $76, $bb, $44, $ff, $00, $ff, $80
	db $ff, $00, $e3, $1c, $dd, $3e, $df, $3e, $ef, $1a, $d1, $ee, $3f, $e0, $9f, $6c
;@ path: gfx/sprites/entities
;@ Entity graphics set $54: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles54::
	db $00, $00, $00, $00, $03, $00, $02, $01, $02, $01, $02, $01, $0f, $00, $13, $0c
	db $2d, $1e, $40, $3f, $70, $0f, $5d, $3e, $9d, $7e, $9b, $7c, $85, $7b, $c8, $37
	db $07, $00, $0d, $02, $cf, $00, $e9, $87, $72, $cf, $b1, $6e, $42, $bd, $25, $db
	db $a5, $5b, $cd, $33, $9a, $7d, $81, $7e, $9c, $63, $df, $24, $7b, $86, $bf, $c0
	db $80, $00, $4e, $80, $de, $04, $fb, $cc, $33, $ec, $ca, $35, $e7, $d9, $f5, $eb
	db $f4, $2b, $f6, $29, $fb, $dc, $c1, $3e, $1d, $e2, $fd, $12, $e9, $36, $f1, $0e
	db $38, $00, $7e, $38, $a7, $7a, $9f, $62, $89, $76, $e7, $98, $85, $fa, $12, $ec
	db $0c, $f0, $84, $78, $04, $f8, $04, $f8, $38, $c0, $10, $e0, $b0, $40, $f0, $00
	db $83, $7c, $80, $7f, $66, $1f, $23, $1f, $30, $0f, $18, $07, $1f, $00, $13, $0c
	db $0c, $03, $08, $07, $1e, $01, $2a, $1f, $24, $1b, $3f, $00, $00, $03, $00, $00
	db $3e, $d9, $bd, $72, $3d, $fe, $3b, $fc, $15, $fa, $81, $7e, $c3, $3c, $7f, $80
	db $6f, $90, $0d, $f0, $04, $f8, $4c, $f3, $98, $67, $f0, $0f, $00, $ff, $00, $ff
	db $03, $fc, $1f, $e0, $fe, $01, $f9, $06, $e3, $1c, $0e, $f1, $fc, $03, $fc, $03
	db $fc, $03, $da, $05, $10, $0f, $20, $df, $20, $df, $39, $c7, $0c, $f3, $07, $f8
	db $e0, $00, $a0, $40, $70, $80, $f8, $00, $6c, $f0, $74, $f8, $0a, $fc, $1a, $fc
	db $42, $bc, $3c, $c0, $08, $f0, $78, $80, $0c, $f2, $2a, $fd, $92, $6d, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $55: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles55::
	db $00, $00, $00, $00, $07, $00, $1f, $07, $3f, $1f, $7f, $3f, $7f, $2e, $ff, $6e
	db $ff, $7f, $ff, $7f, $ff, $6e, $bf, $71, $5f, $3f, $6f, $1f, $f8, $67, $ff, $00
	db $00, $00, $00, $00, $e0, $00, $f8, $e0, $fc, $f8, $fe, $fc, $fe, $fc, $ff, $fe
	db $f7, $ee, $f9, $f6, $ff, $f8, $f9, $fe, $f2, $fc, $dc, $e0, $2e, $dc, $fe, $00
	db $00, $00, $00, $00, $07, $00, $1f, $07, $3f, $1f, $7f, $3f, $7f, $2f, $ff, $6f
	db $ff, $7f, $ff, $7f, $ff, $77, $bf, $78, $5f, $3f, $6f, $1f, $f8, $67, $ff, $00
	db $33, $00, $7f, $33, $7f, $27, $7f, $16, $7f, $3f, $7f, $3f, $ff, $60, $ff, $40
	db $ff, $40, $ff, $40, $ff, $40, $bf, $60, $5f, $3f, $6f, $1f, $f8, $67, $ff, $00
	db $c6, $00, $ff, $c6, $ff, $6e, $fd, $de, $f9, $fe, $f2, $fc, $fd, $fa, $f9, $7e
	db $f9, $3e, $f9, $3e, $f9, $2e, $f9, $6e, $f2, $dc, $dc, $e0, $2e, $dc, $fe, $00
	db $00, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $ff, $fb
	db $ff, $ff, $ff, $ff, $ff, $f7, $ff, $0f, $ff, $ff, $ff, $ff, $00, $ff, $ff, $00
	db $00, $00, $30, $00, $7f, $30, $7f, $27, $7f, $1f, $7f, $2e, $7f, $2e, $ff, $7f
	db $ff, $7f, $ff, $77, $ff, $77, $bf, $77, $5f, $3f, $6f, $1f, $f8, $67, $ff, $00
	db $00, $00, $06, $00, $ef, $06, $ff, $ee, $fd, $fe, $f9, $fe, $f2, $fc, $fd, $fa
	db $f9, $fe, $f9, $fe, $f9, $fe, $f9, $fe, $f2, $fc, $dc, $e0, $2e, $dc, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $56: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles56::
	db $00, $00, $00, $00, $00, $00, $01, $01, $03, $03, $06, $07, $0d, $0e, $1b, $1c
	db $1e, $19, $14, $1b, $3c, $33, $28, $37, $38, $27, $38, $27, $38, $27, $38, $27
	db $00, $00, $00, $00, $3f, $3f, $ef, $f0, $3f, $c0, $e0, $1f, $80, $7f, $00, $ff
	db $00, $ff, $07, $ff, $1f, $ff, $3f, $ff, $3f, $ff, $7f, $ff, $7f, $ff, $7f, $ff
	db $38, $27, $78, $67, $78, $47, $e4, $9b, $cf, $b0, $df, $b0, $df, $b0, $d7, $b8
	db $6f, $58, $77, $4c, $39, $26, $1f, $10, $0f, $0a, $0d, $0b, $0e, $09, $07, $04
	db $3f, $ff, $03, $ff, $7d, $83, $de, $39, $87, $7c, $fb, $06, $b5, $7b, $7b, $fd
	db $7f, $fd, $7e, $fd, $7e, $e5, $bf, $64, $c6, $39, $fc, $03, $f1, $0e, $ff, $61
	db $00, $00, $03, $03, $07, $04, $0e, $09, $7d, $73, $fb, $86, $db, $34, $bf, $60
	db $f8, $07, $f7, $8f, $ef, $9f, $ef, $13, $af, $53, $bf, $4f, $9f, $60, $c9, $b7
	db $f8, $f8, $fe, $06, $8f, $73, $3f, $c0, $ff, $00, $f0, $0f, $e0, $1f, $e0, $1f
	db $70, $8f, $a9, $d7, $e5, $db, $ed, $db, $ad, $db, $5d, $b3, $bb, $67, $f7, $cf
	db $00, $00, $04, $04, $00, $00, $18, $18, $18, $18, $06, $06, $46, $46, $00, $00
	db $18, $18, $1d, $1d, $0d, $0d, $01, $01, $47, $47, $06, $06, $00, $00, $00, $00
	db $00, $00, $10, $10, $00, $00, $c0, $c0, $e0, $e0, $6c, $6c, $0c, $0c, $78, $78
	db $78, $78, $98, $98, $9c, $9c, $fc, $fc, $fe, $fe, $3e, $3e, $0e, $0e, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $57: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles57::
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $07, $00, $0f, $00, $1f, $00
	db $3f, $00, $3f, $01, $5f, $21, $6e, $31, $57, $38, $2d, $1e, $1b, $07, $07, $00
	db $00, $00, $00, $00, $00, $00, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $e0, $ff, $30, $ff, $30, $ef, $f0, $1f, $e0, $fd, $03, $ff, $ff, $ff, $00
	db $20, $00, $20, $00, $60, $00, $e0, $00, $f0, $00, $f8, $00, $fc, $00, $fe, $00
	db $fe, $00, $d7, $38, $fb, $2c, $bd, $76, $77, $f8, $e4, $f8, $98, $e0, $e0, $00
	db $03, $00, $06, $03, $0d, $06, $0b, $04, $1f, $00, $1f, $01, $1f, $01, $2e, $11
	db $3f, $10, $37, $18, $3b, $1c, $2e, $1f, $17, $0f, $0b, $07, $06, $01, $01, $00
	db $81, $00, $fd, $00, $ff, $00, $ff, $00, $ff, $e0, $ff, $30, $ff, $30, $ef, $f0
	db $1f, $e0, $ff, $00, $fe, $01, $fb, $07, $ff, $ff, $ff, $ff, $00, $ff, $ff, $00
	db $cc, $00, $b8, $c0, $f0, $c0, $50, $e0, $f0, $60, $a8, $70, $f8, $30, $f4, $38
	db $bc, $78, $7c, $f8, $f4, $f8, $e4, $f8, $c8, $f0, $10, $e0, $60, $80, $80, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $70, $00, $d8, $20, $f8, $00, $f8, $00, $70, $00, $20, $00
	db $07, $00, $1f, $00, $3e, $01, $7d, $03, $7d, $03, $fe, $01, $ff, $00, $ff, $00
	db $bf, $40, $bf, $40, $9f, $60, $47, $38, $40, $3f, $20, $1f, $18, $07, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $58: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles58::
	db $0f, $00, $1b, $07, $2f, $1f, $3f, $1f, $5f, $33, $7f, $33, $7f, $33, $7f, $3f
	db $5f, $3c, $7f, $1c, $ef, $5f, $d8, $67, $97, $68, $78, $07, $7c, $3b, $7f, $00
	db $f0, $00, $68, $90, $d4, $e8, $f2, $ec, $ea, $34, $f9, $36, $f9, $36, $fe, $f0
	db $ea, $f4, $d1, $ee, $a9, $de, $75, $9a, $a5, $5a, $19, $e6, $06, $f8, $fc, $00
	db $03, $00, $0c, $03, $13, $0f, $26, $1f, $24, $1f, $20, $1f, $30, $0f, $30, $0f
	db $28, $17, $47, $38, $40, $3f, $40, $3f, $60, $1f, $40, $3f, $20, $1f, $1f, $00
	db $e0, $00, $18, $e0, $04, $f8, $04, $f8, $02, $fc, $02, $fc, $22, $dc, $3a, $c4
	db $c6, $38, $03, $fc, $01, $fe, $41, $be, $89, $76, $3e, $c0, $7c, $b8, $fc, $00
	db $3f, $00, $56, $39, $7b, $3c, $bf, $7c, $fd, $26, $ff, $26, $ff, $26, $bf, $7e
	db $bd, $5e, $bb, $5c, $75, $3b, $4a, $37, $79, $06, $3e, $01, $7b, $3c, $7f, $00
	db $f0, $00, $cc, $f0, $02, $fc, $01, $fe, $81, $7e, $91, $6e, $fd, $02, $8b, $70
	db $08, $f0, $8c, $70, $12, $ec, $81, $7e, $07, $f8, $1f, $e2, $ff, $1c, $fe, $00
	db $3f, $00, $5b, $3c, $7d, $3e, $bf, $7e, $fe, $53, $ff, $53, $ff, $53, $ff, $7f
	db $fe, $6f, $bd, $6e, $7a, $3d, $c5, $3b, $bc, $43, $ff, $00, $1f, $07, $3f, $00
	db $e0, $00, $58, $e0, $84, $78, $82, $7c, $c2, $3c, $d2, $2c, $fa, $04, $ce, $30
	db $88, $70, $c8, $30, $8c, $f0, $42, $bc, $81, $7e, $c1, $3e, $ff, $c0, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $59: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles59::
	db $07, $00, $1f, $02, $3f, $03, $7f, $00, $7b, $07, $f7, $0f, $ef, $1e, $fe, $1d
	db $fc, $1b, $fc, $1b, $fe, $1d, $6f, $1e, $77, $0f, $bb, $67, $8f, $70, $7c, $00
	db $f0, $00, $fc, $20, $fe, $60, $fe, $00, $ef, $f0, $f7, $78, $7b, $bc, $3f, $dc
	db $1f, $ec, $1f, $ec, $3e, $dc, $7a, $bc, $f5, $7a, $ed, $f2, $fe, $00, $00, $00
	db $07, $00, $1f, $02, $3f, $03, $7f, $00, $7b, $07, $f7, $0f, $ef, $1c, $fc, $1b
	db $fc, $1b, $fc, $1b, $fe, $1d, $6f, $1e, $77, $0f, $bb, $67, $8f, $70, $7c, $00
	db $f0, $00, $fc, $20, $fe, $60, $fe, $00, $ef, $f0, $f7, $f8, $fb, $9c, $9f, $6c
	db $1f, $ec, $1f, $ec, $3e, $dc, $7a, $bc, $f5, $7a, $ed, $f2, $fe, $00, $00, $00
	db $07, $00, $1f, $02, $3f, $03, $7f, $00, $7b, $07, $f7, $0f, $ef, $1e, $ff, $1c
	db $ff, $18, $ff, $18, $ff, $18, $6e, $1f, $77, $0e, $bb, $67, $8f, $70, $7c, $00
	db $f0, $00, $fc, $20, $fe, $60, $fe, $00, $ef, $f0, $f7, $78, $fb, $3c, $ff, $1c
	db $ff, $0c, $ff, $0c, $fe, $0c, $ba, $7c, $f5, $3a, $ed, $f2, $fe, $00, $00, $00
	db $07, $00, $1f, $02, $3f, $03, $7f, $00, $7b, $07, $f7, $0f, $ef, $1e, $ff, $1e
	db $ff, $19, $ff, $10, $ff, $10, $6f, $19, $77, $0f, $bb, $67, $8f, $70, $7c, $00
	db $f0, $00, $fc, $20, $fe, $60, $fe, $00, $ef, $f0, $f7, $78, $fb, $3c, $ff, $3c
	db $ff, $4c, $ff, $04, $fe, $04, $fa, $4c, $f5, $7a, $ed, $f2, $fe, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $5A: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles5A::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $30, $00, $7b, $30, $ff, $3a, $df, $76, $b7, $7e, $5d, $3e, $23, $1c, $3c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $60, $00, $70, $20, $5f, $30, $2b, $17
	db $31, $0f, $27, $18, $27, $1a, $3f, $00, $2d, $1e, $5b, $3e, $45, $3a, $3e, $00
	db $30, $00, $38, $10, $3f, $10, $37, $0f, $23, $1f, $2f, $10, $2f, $14, $2f, $10
	db $22, $1d, $62, $1d, $90, $6f, $9f, $60, $ad, $5e, $5b, $3e, $45, $3a, $3e, $00
	db $06, $00, $0e, $04, $fa, $0c, $b4, $d8, $18, $e0, $e4, $18, $e4, $98, $e4, $18
	db $04, $f8, $1a, $e4, $35, $ce, $f9, $06, $b5, $7a, $da, $7c, $a2, $5c, $7c, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $5B: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles5B::
	db $39, $00, $73, $00, $7f, $00, $7f, $00, $7f, $00, $3f, $00, $3f, $1d, $17, $0d
	db $0b, $07, $1f, $00, $3d, $1a, $3e, $1b, $79, $07, $78, $07, $7f, $00, $4f, $00
	db $e0, $00, $f8, $00, $fc, $00, $fc, $00, $fe, $00, $fe, $6c, $fa, $bc, $ec, $b0
	db $d8, $e0, $fc, $00, $de, $20, $3e, $ec, $df, $ec, $7f, $80, $bd, $78, $f8, $00
	db $73, $00, $e7, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $3b, $2f, $1b
	db $17, $0f, $3f, $00, $7b, $04, $7c, $37, $fb, $37, $fe, $01, $bd, $1e, $1f, $00
	db $c0, $00, $f0, $00, $f8, $00, $f8, $00, $fc, $00, $fc, $d8, $f4, $78, $d8, $60
	db $b0, $c0, $f8, $00, $bc, $58, $7c, $d8, $9e, $e0, $1e, $e0, $fe, $00, $f2, $00
	db $73, $00, $e7, $00, $ff, $00, $ff, $00, $7f, $00, $1f, $00, $3f, $0b, $3f, $1b
	db $1f, $0f, $0f, $00, $0f, $06, $0f, $06, $06, $01, $03, $00, $07, $03, $07, $00
	db $e0, $00, $f8, $00, $fc, $00, $fc, $00, $fc, $00, $fc, $60, $f8, $60, $f0, $c0
	db $f0, $80, $f8, $00, $7c, $80, $3c, $c0, $3e, $c0, $fe, $00, $de, $e0, $f8, $00
	db $00, $00, $73, $00, $e7, $00, $ff, $00, $ff, $00, $7f, $00, $1f, $00, $3f, $0b
	db $3f, $1b, $1f, $0f, $0f, $00, $07, $03, $07, $03, $0f, $00, $1f, $0c, $1f, $00
	db $00, $00, $e0, $00, $f8, $00, $fc, $00, $fc, $00, $fc, $00, $fc, $60, $f8, $60
	db $f0, $c0, $fe, $80, $bf, $40, $9f, $60, $9f, $60, $3f, $c8, $fc, $38, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $5C: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles5C::
	db $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $0f, $06, $0e, $05, $16, $0d
	db $10, $0f, $1c, $0b, $17, $0c, $3f, $17, $2b, $17, $3a, $05, $4f, $34, $7f, $00
	db $06, $00, $0f, $06, $0e, $05, $16, $0d, $10, $0f, $1f, $08, $1f, $0c, $17, $0f
	db $0b, $07, $09, $07, $0a, $05, $0f, $04, $0d, $02, $09, $06, $12, $0c, $1c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $0d, $06, $08, $07, $11, $0f
	db $11, $0f, $10, $0f, $1a, $05, $3a, $15, $24, $1b, $30, $0f, $4c, $33, $7f, $00
	db $06, $00, $0d, $06, $08, $07, $11, $0f, $11, $0f, $10, $0f, $12, $0d, $1a, $05
	db $14, $0b, $14, $0b, $0d, $02, $05, $02, $05, $02, $09, $06, $12, $0c, $1c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $0e, $07, $0e, $03, $1e, $03
	db $21, $1f, $21, $1f, $3c, $03, $1f, $0e, $0a, $05, $04, $03, $09, $06, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $40, $80, $30, $c0
	db $88, $f0, $84, $f8, $e4, $18, $d2, $6c, $8a, $74, $e6, $18, $86, $78, $fc, $00
	db $1c, $00, $3a, $1c, $39, $0e, $79, $0e, $86, $7f, $c6, $3f, $20, $1f, $70, $0f
	db $7e, $3d, $32, $0d, $0e, $01, $04, $03, $07, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $20, $c0, $10, $e0, $08, $f0
	db $88, $70, $e8, $50, $e8, $10, $a6, $18, $21, $1e, $1d, $02, $05, $02, $06, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $5D: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles5D::
	db $03, $00, $07, $03, $0f, $06, $1f, $0c, $3f, $00, $3f, $18, $3f, $1c, $3f, $1e
	db $1f, $0c, $7f, $03, $f7, $6f, $f7, $6f, $f3, $6f, $f9, $67, $64, $03, $03, $00
	db $c0, $00, $e0, $c0, $f8, $00, $fc, $68, $fe, $fc, $fe, $d4, $fe, $d4, $fe, $fc
	db $fe, $60, $fe, $1c, $ff, $be, $ff, $b2, $df, $be, $aa, $dc, $1c, $e0, $e0, $00
	db $03, $00, $07, $03, $0f, $06, $1f, $0c, $3f, $18, $3f, $10, $2f, $10, $3f, $00
	db $7f, $3e, $7f, $3e, $ff, $5d, $ff, $63, $f3, $6f, $f9, $67, $64, $03, $03, $00
	db $c0, $00, $e0, $c0, $f8, $00, $fc, $68, $fe, $fc, $fe, $d4, $fe, $d4, $fe, $fc
	db $fe, $60, $fe, $1c, $ff, $be, $ff, $b2, $ff, $b2, $dd, $be, $2a, $dc, $fc, $00
	db $03, $00, $0f, $03, $3f, $0f, $7f, $3f, $ff, $70, $ff, $6c, $7f, $12, $3f, $12
	db $3f, $0c, $3f, $11, $7f, $3f, $7f, $37, $7f, $36, $5b, $36, $2d, $12, $16, $00
	db $00, $00, $03, $00, $0f, $03, $3f, $0f, $7f, $3f, $ff, $70, $ff, $6c, $7f, $12
	db $7f, $12, $ff, $6d, $ff, $73, $bf, $6e, $57, $2c, $2a, $04, $06, $00, $00, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $5E: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles5E::
	db $03, $00, $03, $01, $03, $00, $07, $03, $7f, $07, $ff, $7e, $ff, $5f, $bf, $7f
	db $4f, $33, $36, $0f, $0f, $00, $04, $03, $0a, $05, $09, $06, $0c, $03, $07, $00
	db $60, $00, $f0, $60, $f8, $b0, $fc, $d0, $fe, $f4, $fe, $f8, $ff, $fa, $bf, $f8
	db $7f, $ba, $be, $78, $34, $f8, $74, $f8, $ea, $f4, $f2, $0c, $c6, $f8, $fc, $00
	db $07, $00, $0f, $03, $1f, $0d, $1f, $0f, $17, $0f, $0b, $07, $05, $02, $0f, $00
	db $17, $0f, $20, $1f, $2e, $11, $2f, $10, $2f, $10, $17, $08, $08, $07, $07, $00
	db $00, $00, $80, $00, $f0, $80, $ff, $d0, $ff, $fa, $ff, $fe, $be, $7c, $7b, $fc
	db $ff, $7a, $f7, $b8, $67, $da, $6e, $d0, $3e, $c4, $2c, $c0, $40, $80, $80, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $5F: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles5F::
	db $1c, $00, $3e, $1c, $7f, $3e, $73, $3e, $33, $1d, $1d, $03, $3c, $1b, $73, $3c
	db $73, $3e, $7f, $3e, $3f, $1c, $1f, $00, $13, $0c, $19, $07, $0c, $03, $07, $00
	db $03, $00, $07, $03, $06, $03, $75, $02, $ff, $71, $e5, $7b, $e4, $7b, $ff, $70
	db $7e, $03, $0e, $07, $0f, $07, $17, $0b, $13, $0c, $19, $07, $0c, $03, $07, $00
	db $1f, $00, $3e, $1f, $7e, $2b, $7e, $2b, $b6, $7f, $80, $7f, $81, $7e, $fe, $01
	db $7e, $3f, $3c, $03, $1c, $0f, $39, $1e, $38, $1f, $2d, $1f, $17, $0f, $3f, $00
	db $80, $00, $40, $80, $20, $c0, $10, $e0, $d0, $20, $90, $60, $10, $e0, $20, $c0
	db $23, $c0, $45, $82, $f5, $02, $09, $f6, $01, $fe, $f1, $fe, $6a, $9c, $fc, $00
	db $80, $00, $40, $80, $20, $c0, $10, $e0, $d0, $20, $90, $60, $10, $e0, $20, $c0
	db $20, $c0, $46, $80, $ea, $04, $12, $ec, $04, $f8, $cc, $f8, $f8, $70, $fc, $00
	db $03, $00, $1c, $03, $3e, $01, $0f, $04, $1f, $0f, $2f, $1b, $4f, $3b, $40, $3f
	db $50, $2f, $4f, $30, $20, $1f, $1f, $00, $0b, $07, $3d, $03, $77, $38, $7e, $00
	db $c0, $00, $7c, $80, $fe, $00, $f0, $60, $e8, $f0, $e4, $b8, $e2, $bc, $02, $fc
	db $12, $ec, $e2, $1c, $04, $f8, $f8, $00, $d8, $e0, $ac, $d8, $fc, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $f3, $00, $3c, $03, $4e, $31, $87, $78, $bf, $76, $7f, $00, $f2, $7d, $7f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $60: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles60::
	db $00, $00, $1b, $00, $3d, $1b, $69, $37, $fb, $a4, $fd, $93, $ff, $f2, $1f, $02
	db $3d, $1b, $77, $3c, $69, $36, $76, $20, $70, $20, $f8, $a8, $f8, $98, $70, $70
	db $00, $00, $00, $00, $1b, $00, $3d, $1b, $69, $37, $db, $64, $fd, $13, $ef, $e2
	db $1f, $02, $3d, $1b, $67, $3c, $d9, $66, $f6, $40, $e0, $40, $e0, $20, $e0, $e0
	db $00, $00, $00, $00, $e3, $00, $f6, $61, $ff, $70, $bf, $72, $5f, $32, $3f, $10
	db $3f, $18, $3f, $1c, $3f, $1f, $3b, $1c, $74, $38, $4f, $30, $3f, $00, $00, $00
	db $00, $00, $30, $00, $7b, $30, $7e, $39, $5f, $34, $3f, $15, $3f, $11, $2f, $10
	db $1f, $08, $1f, $0c, $1f, $0f, $3b, $1c, $24, $18, $1f, $00, $03, $04, $00, $00
	db $00, $00, $00, $00, $c0, $00, $6e, $80, $fe, $0c, $fe, $1c, $fa, $3c, $f4, $38
	db $e8, $30, $e8, $70, $e8, $f0, $78, $f0, $bc, $78, $dc, $38, $f8, $00, $00, $00
	db $01, $00, $03, $01, $03, $00, $06, $01, $0f, $00, $0f, $01, $0d, $03, $0d, $03
	db $04, $03, $04, $03, $05, $03, $05, $03, $05, $03, $07, $01, $06, $01, $03, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $06, $01, $0f, $00, $0f, $00, $0f, $04
	db $0f, $00, $1f, $03, $35, $1b, $26, $19, $1d, $02, $04, $03, $03, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $c0, $00, $60, $80, $f0, $00, $f0, $00, $f0, $c0
	db $f0, $00, $78, $90, $ff, $f0, $ff, $f6, $ed, $7e, $ba, $7c, $c4, $38, $f8, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $61: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles61::
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $00, $01, $00, $03, $01, $e3, $01, $f7, $60, $ff, $74, $7d, $2b, $78, $27
	db $f3, $6c, $f7, $69, $77, $28, $f7, $68, $f3, $8c, $f8, $e7, $77, $78, $0f, $0f
	db $00, $00, $07, $07, $1f, $1c, $3f, $31, $7f, $67, $7f, $6e, $ff, $cc, $ff, $cd
	db $ff, $67, $ff, $73, $ff, $b8, $ff, $9f, $7f, $47, $3f, $30, $0f, $0f, $00, $00
	db $01, $00, $03, $01, $e3, $01, $f7, $60, $ff, $70, $7f, $2c, $7f, $2e, $ff, $6b
	db $ff, $68, $79, $27, $f3, $6c, $f4, $4b, $f1, $8e, $ff, $f1, $3f, $3f, $07, $07
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $62: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles62::
	db $00, $00, $00, $00, $00, $00, $07, $00, $0f, $07, $17, $08, $17, $08, $17, $08
	db $0c, $03, $0b, $07, $09, $07, $07, $03, $07, $03, $05, $03, $02, $01, $01, $00
	db $07, $00, $0f, $07, $1f, $0f, $df, $0f, $fb, $8e, $f7, $ca, $ff, $63, $ff, $21
	db $7f, $b0, $5f, $bc, $ef, $1c, $be, $43, $9f, $7c, $7f, $81, $5e, $bf, $ff, $00
	db $f8, $00, $fd, $f8, $ff, $fc, $ff, $fe, $b7, $7a, $ff, $32, $ff, $36, $ff, $fe
	db $ff, $cc, $ff, $f8, $ff, $4a, $fd, $06, $bb, $ec, $5f, $b0, $e2, $1c, $fc, $00
	db $f0, $00, $e8, $70, $f4, $18, $3c, $c8, $fc, $08, $fc, $08, $f4, $18, $68, $b0
	db $50, $e0, $f0, $00, $60, $c0, $60, $c0, $60, $c0, $a0, $40, $c0, $00, $00, $00
	db $07, $00, $0e, $07, $0f, $07, $0f, $07, $08, $07, $04, $03, $03, $00, $03, $00
	db $07, $00, $0f, $07, $1e, $09, $17, $08, $1f, $05, $3e, $0b, $7e, $37, $7f, $00
	db $3c, $03, $dc, $3b, $57, $bc, $5b, $b7, $4d, $bb, $f7, $0d, $cb, $07, $c7, $00
	db $e0, $00, $f0, $00, $f0, $80, $78, $c0, $f8, $40, $b4, $48, $4c, $b0, $f8, $00
	db $f0, $00, $ff, $70, $bf, $d6, $7d, $b6, $f7, $68, $f9, $40, $c3, $80, $8f, $00
	db $1f, $01, $1e, $03, $37, $0a, $39, $06, $1e, $01, $07, $00, $00, $00, $00, $00
	db $70, $00, $b8, $70, $78, $f0, $78, $f0, $08, $f0, $90, $60, $e0, $00, $e0, $00
	db $d0, $e0, $e8, $10, $f8, $a0, $fc, $d0, $7e, $ec, $fe, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $63: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles63::
	db $0f, $00, $37, $0f, $5f, $3f, $7f, $30, $bf, $67, $bf, $69, $bf, $69, $b7, $6d
	db $bb, $66, $be, $63, $bf, $63, $7f, $32, $5f, $38, $2f, $1f, $10, $0f, $0f, $00
	db $01, $00, $01, $00, $02, $01, $03, $01, $05, $03, $07, $03, $1b, $07, $2e, $17
	db $2d, $16, $6f, $18, $b1, $6e, $de, $30, $fa, $5c, $ba, $7c, $44, $38, $38, $00
	db $0e, $00, $1e, $0c, $2e, $1c, $3a, $1c, $5c, $38, $74, $38, $b8, $70, $e8, $70
	db $70, $e0, $d0, $e0, $e0, $c0, $a0, $c0, $c0, $80, $40, $80, $80, $00, $80, $00
	db $0e, $00, $35, $0e, $5e, $3f, $7f, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $bf, $7f
	db $bf, $7f, $7f, $3f, $5f, $3f, $2f, $1f, $1b, $07, $07, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $80, $00, $40, $80, $a0, $c0, $d8, $e0, $f7, $f8, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7d, $fe, $fe, $00, $00, $00
	db $01, $00, $01, $00, $02, $01, $05, $03, $0b, $07, $37, $0f, $df, $3f, $fe, $ff
	db $fd, $fe, $fa, $fc, $f4, $f8, $d8, $e0, $60, $80, $80, $00, $00, $00, $00, $00
	db $56, $3c, $76, $3c, $6e, $3c, $6a, $3c, $6c, $38, $bc, $78, $fc, $78, $f4, $78
	db $78, $f0, $e8, $f0, $f0, $e0, $d0, $e0, $e0, $c0, $a0, $c0, $40, $80, $80, $00
	db $00, $01, $00, $01, $01, $00, $01, $04, $03, $06, $07, $12, $07, $12, $1f, $0a
	db $1f, $0a, $1f, $0a, $1f, $0a, $2f, $1a, $3f, $1a, $3b, $16, $3f, $16, $3d, $16
;@ path: gfx/sprites/entities
;@ Entity graphics set $64: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles64::
	db $06, $00, $0f, $06, $0f, $06, $1f, $06, $2f, $16, $2f, $16, $4f, $36, $4b, $36
	db $77, $3b, $75, $3b, $43, $3c, $21, $1f, $39, $1f, $18, $0f, $0c, $03, $03, $00
	db $02, $01, $3a, $01, $46, $39, $9e, $61, $a2, $5d, $8e, $71, $92, $61, $62, $01
	db $02, $01, $3a, $01, $46, $39, $9e, $61, $a2, $5d, $8e, $71, $92, $61, $62, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $06, $00, $0f, $06, $0f, $06, $1f, $06, $2f, $16, $2f, $16, $4f, $36, $4b, $36
	db $77, $3b, $75, $3b, $43, $3c, $21, $1f, $39, $1f, $18, $0f, $0c, $03, $03, $00
	db $02, $01, $3a, $01, $46, $39, $9e, $61, $a2, $5d, $8e, $71, $92, $61, $62, $01
	db $00, $00, $00, $00, $70, $00, $e8, $70, $bc, $78, $ee, $1c, $97, $6e, $8b, $76
	db $77, $3b, $75, $3b, $43, $3c, $21, $1f, $39, $1f, $18, $0f, $0c, $03, $03, $00
	db $03, $03, $3e, $3f, $65, $7e, $5b, $64, $ae, $d1, $a5, $db, $cb, $bf, $df, $bb
	db $df, $b9, $cf, $b9, $a7, $dd, $b3, $cf, $5c, $63, $67, $78, $38, $3f, $0f, $0f
	db $00, $00, $00, $00, $00, $00, $0d, $0d, $1a, $1f, $15, $1a, $36, $39, $29, $37
	db $2b, $37, $2b, $37, $29, $37, $36, $39, $19, $1e, $0e, $0f, $03, $03, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $06, $07, $05, $06
	db $0a, $0d, $0a, $0d, $0d, $0e, $06, $07, $03, $03, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $65: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles65::
	db $ff, $00, $ff, $7f, $c0, $7f, $c0, $7f, $86, $79, $ff, $00, $c0, $3f, $f3, $3f
	db $ec, $3f, $e0, $3f, $c0, $3f, $c0, $3f, $64, $1b, $34, $0f, $18, $07, $0f, $00
	db $ff, $00, $cf, $ff, $30, $ff, $00, $ff, $00, $ff, $ff, $00, $00, $ff, $f1, $ff
	db $0e, $ff, $00, $ff, $c0, $3f, $c0, $ff, $00, $ff, $00, $ff, $8c, $73, $ff, $00
	db $ff, $00, $ff, $7f, $c0, $7f, $c0, $7f, $87, $78, $fd, $03, $c2, $3f, $f3, $3e
	db $ec, $3f, $e0, $3f, $c0, $3f, $c0, $3f, $64, $1b, $34, $0b, $1a, $05, $0f, $00
	db $ff, $00, $cf, $ff, $70, $ff, $f8, $07, $76, $f9, $8d, $fe, $f2, $0f, $fd, $03
	db $1e, $e1, $00, $ff, $3f, $c0, $7f, $b6, $ff, $20, $e0, $1f, $0c, $f3, $ff, $00
	db $ff, $00, $ff, $66, $f6, $69, $e0, $1f, $c0, $3f, $ed, $53, $ef, $54, $cf, $37
	db $cb, $36, $e7, $58, $e0, $5f, $c3, $3c, $e0, $1f, $f6, $69, $ff, $66, $ff, $00
	db $ff, $00, $ff, $66, $f6, $69, $e0, $1f, $c3, $3c, $e5, $5b, $e7, $5b, $c7, $3a
	db $c5, $3a, $e3, $5c, $e0, $5f, $c1, $3e, $e0, $1f, $f6, $69, $ff, $66, $ff, $00
	db $0f, $09, $3f, $18, $7f, $03, $7f, $4f, $ff, $d3, $ff, $19, $ff, $3d, $ff, $af
	db $ff, $a7, $ff, $39, $ff, $1c, $ff, $de, $7f, $4f, $7f, $03, $3f, $18, $0f, $09
	db $7f, $00, $4f, $3f, $47, $3f, $20, $1f, $1f, $00, $20, $1f, $43, $3f, $43, $3f
	db $81, $7f, $80, $7f, $a3, $5c, $d2, $2d, $9e, $61, $40, $3f, $20, $1f, $1f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $66: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles66::
	db $00, $00, $3f, $00, $21, $1f, $21, $1f, $21, $1f, $21, $1f, $3f, $1f, $3f, $1f
	db $21, $1f, $21, $1f, $21, $1f, $21, $1f, $3f, $00, $3f, $00, $00, $00, $00, $00
	db $01, $00, $02, $01, $04, $03, $08, $07, $1c, $0f, $26, $1f, $43, $3f, $81, $7f
	db $c3, $3f, $66, $1f, $3c, $0f, $1c, $07, $0c, $03, $06, $01, $03, $00, $01, $00
	db $03, $00, $02, $01, $03, $00, $02, $01, $0f, $01, $1b, $0d, $2e, $11, $5a, $21
	db $b2, $41, $a2, $41, $a2, $41, $a2, $41, $be, $41, $87, $7d, $fe, $01, $7f, $00
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $3f, $00, $7f, $3f, $ef, $70, $d0, $6f, $e0, $5f, $e0, $5f, $e0, $5f, $d0, $6f
	db $ef, $70, $bf, $7f, $9f, $7f, $c0, $3f, $60, $1f, $3f, $00, $23, $1f, $27, $1f
	db $27, $1f, $23, $1f, $33, $0f, $2c, $13, $2b, $1c, $27, $1f, $23, $1f, $27, $1f
	db $27, $1f, $23, $1f, $33, $0f, $2c, $13, $2b, $1c, $27, $1f, $23, $1f, $27, $1f
	db $27, $1f, $23, $1f, $33, $0f, $2c, $13, $27, $1c, $63, $1f, $a3, $5f, $a7, $5f
	db $a7, $5f, $b3, $6f, $bc, $73, $9b, $7c, $8f, $7f, $c0, $3f, $60, $1f, $3f, $00
	db $03, $00, $0f, $00, $1f, $00, $3e, $01, $3d, $03, $7d, $03, $7e, $01, $5f, $20
	db $5f, $20, $4f, $30, $23, $1c, $20, $1f, $10, $0f, $0c, $03, $03, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $67: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles67::
	db $00, $00, $01, $00, $07, $00, $0f, $00, $1f, $0d, $1f, $0f, $3f, $0a, $3f, $1f
	db $7f, $3b, $7f, $04, $3f, $1f, $1f, $00, $1f, $04, $3f, $16, $3f, $06, $07, $00
	db $00, $00, $e0, $00, $f0, $00, $f8, $10, $f8, $90, $f8, $c0, $fc, $c0, $fe, $c0
	db $de, $e0, $d6, $68, $b6, $c8, $ec, $10, $fc, $40, $ee, $dc, $fe, $c0, $c0, $00
	db $00, $00, $03, $00, $07, $00, $0f, $02, $0f, $02, $3f, $08, $7f, $30, $7f, $30
	db $4f, $30, $3f, $00, $3f, $00, $6f, $30, $7f, $20, $7f, $34, $3b, $07, $07, $00
	db $00, $00, $c0, $00, $e0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f8, $00
	db $fc, $00, $3a, $c4, $12, $ec, $96, $68, $fc, $00, $fc, $00, $fc, $98, $fc, $00
	db $0e, $00, $1f, $0e, $3f, $06, $3f, $00, $7f, $0d, $7f, $0f, $7f, $0a, $3f, $1f
	db $7f, $3b, $7f, $04, $3f, $1f, $1f, $00, $1f, $00, $37, $18, $3f, $00, $01, $00
	db $1c, $00, $3e, $1c, $7f, $0c, $ff, $00, $ff, $0d, $ff, $0f, $7f, $0a, $3f, $1f
	db $7f, $3b, $7f, $04, $3f, $1f, $1f, $00, $1f, $00, $37, $18, $3f, $00, $01, $00
	db $03, $00, $6f, $00, $ff, $6d, $ff, $4a, $ff, $5f, $ff, $3b, $7f, $04, $5f, $3f
	db $2f, $1f, $1f, $00, $13, $0c, $18, $07, $0f, $00, $07, $00, $03, $01, $01, $00
	db $c0, $00, $f8, $00, $fc, $b8, $fe, $b8, $fe, $88, $fe, $c0, $fe, $60, $de, $e0
	db $fc, $80, $fc, $00, $1e, $e0, $1e, $e0, $ff, $04, $ff, $0e, $cf, $86, $c6, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $68: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles68::
	db $1c, $00, $3e, $1c, $7f, $3e, $73, $3e, $33, $1d, $1d, $03, $3c, $1b, $73, $3c
	db $73, $3e, $7f, $3e, $3f, $1c, $1f, $00, $13, $0c, $19, $07, $0c, $03, $07, $00
	db $03, $00, $07, $03, $06, $03, $75, $02, $ff, $71, $e5, $7b, $e4, $7b, $ff, $70
	db $7e, $03, $0e, $07, $0f, $07, $17, $0b, $13, $0c, $19, $07, $0c, $03, $07, $00
	db $03, $00, $02, $01, $03, $00, $02, $01, $0f, $01, $1b, $0d, $2e, $11, $5a, $21
	db $b2, $41, $a2, $41, $a2, $41, $a2, $41, $be, $41, $87, $7d, $fe, $01, $7f, $00
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $03, $00, $1c, $03, $3e, $01, $0f, $04, $1f, $0f, $2f, $1b, $4f, $3b, $40, $3f
	db $50, $2f, $4f, $30, $20, $1f, $1f, $00, $0b, $07, $3d, $03, $77, $38, $7e, $00
	db $c0, $00, $7c, $80, $fe, $00, $f0, $60, $e8, $f0, $e4, $b8, $e2, $bc, $02, $fc
	db $12, $ec, $e2, $1c, $04, $f8, $f8, $00, $d8, $e0, $ac, $d8, $fc, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $f3, $00, $3c, $03, $4e, $31, $87, $78, $bf, $76, $7f, $00, $f2, $7d, $7f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $69: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles69::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $07, $00, $07, $00, $0f, $00
	db $07, $00, $0f, $07, $0d, $03, $0f, $07, $1f, $03, $1f, $08, $1f, $00, $3f, $10
	db $3f, $0e, $7f, $1f, $ff, $1f, $ff, $23, $ff, $37, $ff, $36, $ff, $01, $ff, $5f
	db $f8, $00, $fc, $f8, $be, $cc, $fe, $f4, $fe, $84, $fe, $34, $fc, $10, $f8, $c0
	db $fc, $40, $fe, $00, $ff, $80, $ff, $c3, $ff, $c6, $ff, $c6, $ff, $86, $ff, $06
	db $0f, $00, $1f, $00, $1f, $00, $1f, $0c, $1f, $0e, $1f, $0c, $1f, $0e, $0f, $06
	db $07, $00, $03, $00, $0f, $00, $1f, $0f, $3f, $1f, $3f, $15, $3f, $00, $00, $00
	db $ff, $60, $ff, $60, $ff, $ff, $ff, $8f, $d3, $af, $fc, $8f, $bf, $ff, $bf, $ff
	db $bf, $ff, $df, $7f, $cf, $7f, $70, $bf, $bf, $df, $df, $e0, $ff, $00, $00, $00
	db $73, $00, $5f, $33, $2c, $1b, $37, $0c, $6b, $36, $7d, $23, $76, $29, $5f, $30
	db $6f, $1c, $5b, $27, $4f, $38, $4f, $3f, $4f, $3f, $27, $1f, $18, $07, $07, $00
	db $c0, $00, $f0, $c0, $38, $f0, $ec, $18, $76, $8c, $be, $44, $be, $44, $fa, $0c
	db $f6, $38, $da, $e4, $fa, $14, $fa, $c4, $f2, $fc, $e4, $f8, $18, $e0, $e0, $00
	db $3c, $00, $ff, $18, $bd, $66, $99, $6e, $52, $2c, $24, $18, $3c, $00, $42, $3c
	db $99, $7e, $db, $24, $bd, $5a, $99, $7e, $db, $24, $a5, $5a, $42, $3c, $3c, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $6A: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles6A::
	db $00, $00, $00, $00, $1e, $00, $21, $1e, $5e, $21, $5e, $21, $5e, $21, $6d, $1e
	db $7f, $00, $5e, $21, $4c, $3f, $6d, $1e, $7f, $00, $5e, $21, $2d, $1e, $1e, $00
	db $3c, $00, $7e, $3c, $c7, $7e, $c3, $fe, $c3, $fe, $fe, $3c, $bc, $00, $80, $00
	db $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $38, $00, $2c, $18, $2f, $1c, $e7, $1f, $b8, $67, $bf, $78
	db $5f, $3f, $2e, $1f, $ff, $00, $bf, $7f, $9f, $7f, $40, $3f, $30, $0f, $0f, $00
	db $1c, $00, $3e, $1c, $37, $0e, $1f, $06, $ef, $10, $aa, $d4, $ea, $34, $de, $ec
	db $ba, $dc, $fa, $3c, $f4, $f8, $e4, $f8, $88, $f0, $10, $e0, $60, $80, $80, $00
	db $7c, $7c, $fe, $82, $7e, $7a, $1c, $14, $38, $28, $7c, $5c, $fe, $82, $7c, $7c
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $6B: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles6B::
	db $03, $00, $05, $03, $05, $02, $03, $00, $0c, $03, $11, $0f, $2f, $15, $5f, $2d
	db $7f, $2d, $bf, $60, $b1, $4e, $ed, $12, $8c, $73, $e1, $1e, $6d, $12, $3f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $c6, $00, $ee, $44, $fe, $6c, $7c, $28
	db $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $73, $00, $ff, $70, $ff, $75, $ff, $60, $fb, $07, $98, $67, $9f, $60, $4f, $30
	db $4f, $36, $2b, $16, $15, $0b, $1b, $0c, $27, $1f, $78, $07, $f7, $78, $ff, $00
	db $e0, $00, $f8, $00, $fc, $a0, $fc, $a0, $7e, $f0, $7e, $94, $fe, $1c, $fa, $3c
	db $fc, $78, $fa, $74, $b9, $c6, $fd, $1a, $be, $d8, $1e, $e0, $ef, $1e, $ff, $00
	db $30, $00, $48, $30, $48, $30, $4c, $30, $52, $2c, $52, $2c, $42, $3c, $44, $38
	db $48, $30, $48, $30, $48, $30, $48, $30, $48, $30, $48, $30, $48, $30, $30, $00
	db $00, $00, $00, $00, $00, $00, $0c, $00, $12, $0c, $11, $0e, $0c, $03, $12, $0d
	db $10, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $40, $80
	db $20, $c0, $10, $e0, $88, $70, $44, $38, $22, $1c, $12, $0c, $0c, $00, $00, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $6C: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles6C::
	db $15, $00, $1f, $00, $1f, $00, $3f, $07, $7f, $2d, $7f, $28, $5b, $37, $38, $17
	db $3f, $10, $3f, $08, $7f, $27, $77, $28, $33, $0f, $1e, $01, $3d, $1e, $1f, $00
	db $e0, $00, $f8, $00, $fc, $00, $fc, $e0, $fe, $b4, $fe, $b4, $3a, $fc, $3c, $c8
	db $fc, $18, $fa, $34, $f2, $cc, $fa, $34, $fc, $b0, $38, $c0, $fc, $00, $f0, $00
	db $07, $00, $1f, $00, $3f, $00, $3f, $00, $7f, $20, $7f, $20, $5f, $20, $3f, $10
	db $2f, $18, $7f, $2c, $7f, $23, $33, $0c, $16, $0f, $3f, $01, $3f, $0e, $1f, $00
	db $b0, $00, $f8, $00, $fc, $00, $fc, $00, $fe, $04, $fe, $04, $fa, $04, $fc, $08
	db $f4, $18, $e8, $30, $fc, $c0, $ce, $34, $2e, $f4, $dc, $e0, $fc, $00, $f8, $00
	db $2b, $00, $3f, $00, $3f, $00, $1f, $0f, $3f, $15, $3f, $05, $5b, $3f, $43, $3c
	db $7f, $00, $3f, $01, $17, $0f, $0f, $00, $11, $0e, $1f, $00, $0b, $07, $1f, $00
	db $c0, $00, $f0, $00, $f8, $00, $fc, $00, $fc, $d8, $fc, $d8, $f4, $f8, $f8, $70
	db $f8, $f0, $f8, $e0, $e4, $18, $e4, $d8, $e4, $d8, $f8, $00, $d0, $e0, $f8, $00
	db $00, $00, $2b, $00, $3f, $00, $3f, $00, $1f, $0f, $3f, $15, $3f, $05, $5b, $3f
	db $43, $3c, $7f, $00, $3f, $00, $17, $0d, $0f, $01, $1f, $00, $3d, $1e, $3f, $00
	db $00, $00, $c0, $00, $f0, $00, $f8, $00, $fc, $00, $fc, $d8, $fc, $d8, $f4, $f8
	db $f8, $70, $f8, $e0, $e4, $18, $c4, $b8, $c4, $b8, $fe, $04, $fe, $7c, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $6D: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles6D::
	db $07, $00, $0f, $00, $0f, $06, $1f, $0e, $1f, $0c, $1d, $02, $1f, $03, $1f, $03
	db $1f, $03, $1f, $02, $1f, $03, $3f, $01, $7f, $30, $5c, $3b, $6f, $18, $3c, $00
	db $bc, $00, $fe, $00, $fe, $60, $fe, $e0, $f8, $a0, $fc, $a0, $fe, $ec, $fe, $fc
	db $fc, $f8, $fe, $60, $ff, $c6, $ff, $82, $fe, $0c, $3a, $dc, $f6, $18, $3c, $00
	db $07, $00, $0f, $00, $cf, $03, $e7, $43, $f7, $62, $ff, $62, $7f, $0b, $7f, $0e
	db $3f, $06, $1f, $02, $1f, $02, $3f, $01, $7f, $30, $5c, $3b, $6f, $18, $3c, $00
	db $bc, $00, $fe, $00, $fe, $60, $fe, $e0, $f8, $a0, $fc, $a0, $fe, $ec, $fe, $fc
	db $fc, $78, $fe, $60, $f7, $4e, $ff, $82, $fe, $0c, $3a, $dc, $f6, $18, $3c, $00
	db $0e, $00, $1f, $00, $3f, $00, $3f, $00, $1f, $0d, $3f, $0f, $3f, $1a, $3f, $1a
	db $1f, $08, $3e, $07, $7c, $37, $7e, $2f, $78, $0f, $5d, $2e, $6f, $10, $38, $00
	db $f0, $00, $f8, $00, $f8, $00, $f8, $00, $e0, $80, $f0, $80, $f8, $b0, $f8, $f0
	db $f0, $c0, $f8, $40, $f8, $00, $fc, $60, $fe, $6c, $7a, $9c, $f6, $18, $3c, $00
	db $07, $00, $0f, $00, $0f, $03, $07, $03, $07, $02, $0f, $02, $1f, $0b, $1f, $0e
	db $0f, $04, $0f, $00, $7d, $0e, $f9, $6e, $fd, $5e, $f1, $1e, $7b, $1c, $3e, $00
	db $03, $00, $07, $03, $0e, $05, $0f, $04, $07, $03, $0f, $00, $17, $0d, $2b, $1c
	db $2d, $1b, $41, $3f, $41, $3f, $40, $3f, $48, $37, $28, $17, $1c, $03, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $6E: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles6E::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $03, $00
	db $0d, $03, $1f, $0f, $3c, $1f, $50, $3f, $4c, $33, $c8, $37, $82, $7d, $81, $7e
	db $00, $00, $00, $00, $1f, $00, $6f, $1f, $bf, $7f, $63, $ff, $01, $ff, $f0, $0f
	db $c8, $f7, $00, $ff, $30, $cf, $40, $bf, $40, $bf, $70, $8f, $38, $ff, $0c, $ff
	db $00, $00, $00, $00, $f0, $00, $ec, $f0, $fa, $fc, $6d, $fe, $26, $ff, $03, $ff
	db $01, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $00
	db $40, $80, $40, $80, $20, $c0, $20, $c0, $20, $c0, $10, $e0, $1c, $e0, $12, $ec
	db $a1, $5e, $e3, $1c, $fd, $42, $fd, $6e, $fd, $6e, $b7, $6e, $7f, $26, $5b, $26
	db $3f, $02, $16, $09, $3b, $1c, $70, $3f, $7f, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $00, $ff, $03, $fc, $05, $fb, $07, $fb, $02, $ff, $00, $ff
	db $01, $fe, $09, $f6, $09, $f6, $fc, $03, $ff, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $00, $ff, $80, $7f, $c0, $ff, $00, $ff, $30, $cf, $0c, $f3
	db $32, $fd, $3d, $fe, $1f, $ff, $87, $7f, $c0, $3f, $3f, $00, $00, $00, $00, $00
	db $12, $ec, $04, $f8, $0a, $fc, $0d, $fe, $05, $fe, $01, $fe, $11, $ee, $11, $ee
	db $39, $c6, $c6, $00, $80, $00, $40, $80, $40, $80, $c0, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $6F: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles6F::
	db $00, $00, $00, $00, $1f, $00, $6f, $1f, $bf, $7f, $63, $ff, $01, $ff, $f0, $0f
	db $c8, $f7, $20, $df, $70, $8f, $78, $b7, $78, $97, $28, $d7, $38, $ff, $0c, $ff
	db $03, $00, $0d, $03, $1f, $0f, $3c, $1f, $50, $3f, $4c, $33, $c8, $37, $82, $7d
	db $81, $7e, $a1, $5e, $e3, $1c, $fd, $42, $fd, $6e, $fd, $6e, $b7, $6e, $7f, $26
	db $f0, $00, $cc, $f0, $23, $dc, $71, $8e, $78, $b7, $78, $97, $28, $d7, $38, $ff
	db $0c, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $5b, $26, $35, $0a, $13, $0c, $10, $0f, $08, $07, $08, $07, $04, $03, $04, $03
	db $0e, $01, $12, $0d, $39, $1e, $70, $3f, $7f, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00
	db $02, $01, $04, $03, $0e, $01, $38, $07, $78, $37, $f1, $6e, $93, $6c, $78, $07
	db $01, $00, $06, $01, $08, $07, $13, $0f, $18, $07, $60, $1f, $80, $7f, $e0, $1f
	db $00, $ff, $00, $ff, $60, $ff, $d4, $eb, $3c, $db, $7c, $8b, $39, $c7, $03, $ff
	db $f8, $00, $e4, $f8, $08, $f0, $90, $60, $78, $80, $06, $f8, $01, $fe, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $40, $bf, $29, $df, $2d, $df, $97, $ef, $d7, $ef
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $40, $80
	db $20, $c0, $10, $e0, $17, $e0, $09, $f6, $09, $f6, $21, $fe, $a1, $fe, $f2, $fc
;@ path: gfx/sprites/entities
;@ Entity graphics set $70: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles70::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $0d, $03, $1f, $0f, $3c, $1f
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $f0, $00, $cc, $f0, $22, $dc, $73, $8e
	db $50, $3f, $4c, $33, $c8, $37, $82, $7d, $81, $7e, $a1, $5e, $e3, $1c, $fd, $42
	db $fd, $6e, $fd, $6e, $b7, $6e, $ff, $a6, $db, $a6, $ff, $c2, $7f, $78, $1f, $1f
	db $79, $b7, $78, $97, $28, $d7, $38, $ff, $0c, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $ff
	db $80, $00, $c0, $80, $a0, $c0, $10, $e0, $10, $e0, $08, $f0, $08, $f0, $04, $f8
	db $04, $f8, $04, $f8, $02, $fc, $03, $fd, $03, $fd, $0f, $f3, $fe, $0e, $fc, $fc
	db $01, $00, $06, $01, $0f, $07, $1e, $0f, $28, $1f, $26, $19, $64, $1b, $41, $3e
	db $40, $3f, $d0, $af, $f1, $8e, $fe, $a1, $fe, $b7, $fe, $87, $7f, $70, $1f, $1f
	db $f8, $00, $e6, $f8, $93, $ee, $39, $c7, $3c, $db, $3c, $cb, $14, $eb, $1c, $ff
	db $86, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $ff, $00, $ff, $ff
	db $00, $00, $00, $00, $80, $00, $40, $80, $a0, $c0, $10, $e0, $10, $e0, $08, $f0
	db $08, $f0, $06, $fa, $06, $fa, $06, $fa, $06, $fa, $1e, $e6, $fc, $1c, $f8, $f8
;@ path: gfx/sprites/entities
;@ Entity graphics set $71: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles71::
	db $00, $00, $00, $00, $00, $00, $0f, $00, $1f, $00, $3f, $02, $3f, $06, $3f, $06
	db $1f, $07, $3f, $0b, $7c, $0b, $77, $0f, $7b, $07, $1f, $00, $00, $00, $00, $00
	db $38, $00, $76, $38, $ef, $16, $da, $6c, $fd, $62, $f7, $5a, $fe, $18, $fc, $00
	db $f8, $80, $fc, $50, $ee, $70, $be, $c0, $7e, $80, $f8, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $c0, $80, $f8, $c0, $7f, $f8, $1f, $7f, $00, $1f
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $0f, $00, $13, $0f, $09, $07, $09, $07, $05, $03, $04, $03, $02, $01, $06, $03
	db $0e, $07, $15, $0e, $11, $0e, $21, $1e, $21, $1e, $60, $5f, $70, $6f, $3f, $3f
	db $00, $00, $80, $00, $c0, $80, $c0, $80, $f8, $80, $fc, $f8, $7e, $fc, $0e, $fc
	db $c1, $3e, $3f, $00, $00, $00, $00, $00, $00, $00, $c0, $40, $c0, $40, $80, $80
	db $2f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $07, $7f, $0f
	db $7f, $1f, $3f, $1b, $1f, $0b, $17, $0f, $1b, $07, $1f, $08, $1e, $0c, $0e, $00
	db $dc, $00, $ff, $d8, $ff, $10, $ff, $6c, $ff, $34, $fe, $01, $fb, $06, $fd, $86
	db $ff, $d4, $fa, $74, $dc, $68, $bd, $d8, $75, $98, $f9, $30, $71, $20, $60, $00
	db $00, $00, $00, $00, $80, $00, $40, $80, $a0, $c0, $60, $c0, $10, $e0, $90, $60
	db $10, $e0, $88, $70, $a4, $78, $74, $f8, $7a, $dc, $de, $8c, $ce, $84, $c6, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $72: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles72::
	db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $1f, $00, $3f, $02, $3f, $06
	db $3f, $06, $1f, $07, $3f, $0b, $7f, $0b, $f7, $0f, $fb, $07, $77, $08, $ff, $0b
	db $00, $00, $38, $00, $76, $38, $ef, $16, $da, $6c, $fd, $62, $f7, $5a, $fe, $18
	db $fc, $00, $fc, $80, $fe, $50, $ef, $70, $bf, $c0, $7e, $80, $ff, $40, $ff, $40
	db $ff, $08, $ef, $18, $7f, $17, $3c, $0f, $21, $1e, $20, $1f, $10, $0f, $0c, $03
	db $03, $00, $01, $00, $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $ff, $20, $ef, $30, $7e, $98, $38, $c0, $20, $c0, $a0, $40, $7e, $80, $0e, $fc
	db $3c, $f8, $78, $e0, $60, $c0, $60, $c0, $e0, $c0, $e0, $40, $40, $00, $00, $00
	db $ff, $08, $ef, $18, $7f, $17, $3c, $0f, $20, $1f, $21, $1e, $23, $1c, $24, $18
	db $22, $1c, $49, $3e, $5d, $3e, $be, $77, $f7, $63, $e3, $41, $41, $00, $00, $00
	db $ff, $20, $ef, $30, $7e, $98, $38, $c0, $20, $c0, $20, $c0, $c0, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $80, $00, $80, $00, $80, $00, $80, $00, $00, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $73: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles73::
	db $00, $00, $01, $00, $06, $01, $0c, $07, $1a, $0d, $16, $09, $0e, $05, $0e, $05
	db $19, $0e, $30, $0f, $68, $37, $ae, $71, $c6, $7b, $8f, $76, $49, $36, $5d, $22
	db $00, $00, $e0, $00, $d0, $e0, $28, $f0, $18, $f0, $14, $f8, $04, $f8, $c4, $38
	db $ca, $bc, $45, $be, $85, $7e, $c9, $be, $4a, $bc, $44, $b8, $42, $bc, $22, $dc
	db $2c, $1f, $58, $3f, $43, $3c, $45, $3e, $62, $1f, $78, $27, $b6, $69, $bb, $5c
	db $dd, $3e, $af, $5c, $9f, $60, $89, $76, $88, $77, $50, $2f, $30, $0f, $1f, $00
	db $92, $6c, $7c, $80, $fc, $18, $fe, $3c, $fe, $04, $6f, $f6, $1f, $ee, $3d, $de
	db $3b, $dc, $2d, $d2, $79, $86, $c5, $3a, $46, $b8, $44, $b8, $48, $b0, $f0, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $74: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles74::
	db $38, $00, $4c, $38, $46, $3c, $4b, $34, $5c, $2b, $5f, $28, $7f, $07, $ff, $7f
	db $ff, $4a, $7f, $2a, $3f, $0f, $3f, $1f, $3f, $11, $7f, $1b, $ff, $5f, $ff, $6b
	db $1e, $00, $39, $1e, $61, $3e, $e1, $1e, $e2, $5c, $e2, $5c, $fe, $00, $ff, $fe
	db $fb, $66, $fe, $ec, $fc, $e0, $f8, $e0, $fc, $d8, $fe, $bc, $fd, $be, $9f, $6e
	db $ff, $70, $bf, $7c, $5f, $3d, $7f, $15, $7f, $23, $7f, $3f, $7f, $29, $7f, $3f
	db $7f, $22, $7f, $3f, $7f, $25, $7f, $3f, $7f, $00, $00, $00, $00, $00, $00, $00
	db $0c, $00, $16, $0c, $13, $0e, $15, $0a, $1e, $05, $1f, $08, $7f, $07, $7f, $2f
	db $6f, $1c, $7f, $3d, $ff, $7f, $ff, $0f, $ff, $5f, $ff, $7c, $7c, $3b, $f8, $47
	db $38, $00, $64, $38, $c4, $78, $64, $98, $d4, $68, $a4, $d8, $f8, $00, $fc, $f8
	db $ec, $98, $f8, $f0, $f0, $80, $f8, $b0, $fc, $f8, $fe, $fc, $7d, $fe, $3f, $ee
	db $0f, $00, $18, $07, $1f, $0a, $3f, $04, $3f, $1a, $5f, $38, $4f, $33, $6b, $17
	db $38, $07, $07, $00, $05, $02, $05, $03, $0b, $04, $09, $07, $08, $07, $07, $00
	db $00, $00, $f0, $00, $88, $70, $c8, $f0, $c8, $f0, $c8, $30, $f0, $80, $20, $c0
	db $20, $c0, $c0, $00, $a0, $40, $a0, $c0, $d0, $20, $90, $e0, $10, $e0, $e0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $04, $03, $05, $02, $05, $03, $0b, $04, $09, $07, $08, $07, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $75: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles75::
	db $1c, $00, $1f, $0c, $0f, $06, $1f, $03, $3f, $18, $3f, $1e, $7f, $0c, $cf, $37
	db $e7, $5b, $f3, $6c, $f8, $07, $7f, $30, $78, $37, $ff, $00, $b3, $7c, $ff, $00
	db $f0, $00, $f8, $00, $74, $c8, $be, $5c, $dd, $be, $e3, $1e, $f5, $ce, $f9, $e6
	db $f6, $28, $24, $d8, $38, $c0, $f0, $00, $70, $80, $f0, $00, $68, $f0, $f8, $00
	db $00, $00, $00, $00, $03, $00, $07, $03, $0d, $06, $1a, $0c, $14, $08, $18, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $e0, $00, $d0, $e0, $f8, $70, $5c, $38, $2c, $18, $1e, $0c
	db $16, $0c, $0f, $06, $0b, $06, $0b, $07, $07, $03, $05, $03, $05, $03, $03, $00
	db $ff, $00, $ff, $7f, $ff, $00, $40, $3f, $47, $3f, $6b, $17, $24, $1b, $33, $0c
	db $10, $0f, $18, $07, $0c, $03, $06, $01, $03, $00, $01, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $ff, $ff, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
	db $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $fe, $ff, $00, $0e, $f0, $e8, $f0, $e8, $f0, $d8, $e0, $34, $c8
	db $f4, $08, $36, $c8, $33, $cc, $71, $8e, $f1, $0e, $e9, $06, $0f, $00, $00, $00
	db $18, $00, $24, $18, $42, $3c, $43, $3c, $3d, $00, $39, $10, $38, $00, $44, $38
	db $82, $7c, $82, $7c, $84, $78, $48, $30, $31, $00, $31, $00, $1a, $00, $0c, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $76: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles76::
	db $1c, $00, $3a, $1c, $29, $1e, $11, $0e, $39, $1e, $1b, $0c, $17, $08, $1f, $00
	db $0b, $04, $08, $07, $04, $03, $07, $00, $07, $00, $0d, $06, $0b, $04, $0f, $00
	db $3c, $00, $42, $3c, $99, $66, $bd, $42, $3c, $c3, $18, $e7, $81, $7e, $81, $7e
	db $00, $ff, $42, $bd, $ff, $42, $ff, $3c, $bd, $7e, $db, $3c, $bd, $00, $00, $00
	db $00, $00, $30, $00, $78, $30, $5c, $38, $eb, $5c, $bb, $7c, $57, $38, $ef, $50
	db $bb, $74, $48, $37, $24, $1b, $1f, $00, $07, $00, $0d, $06, $0b, $04, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0d, $00, $1f, $0c, $3f, $18, $37, $18
	db $73, $1c, $72, $2d, $72, $1d, $57, $28, $25, $1a, $17, $08, $0f, $00, $00, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $00, $00, $00, $00, $00, $03, $00, $04, $03, $1b, $07, $34, $0f, $58, $2f
	db $a3, $5f, $e7, $1c, $bc, $5b, $9e, $61, $ea, $45, $44, $03, $03, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $c0, $00, $38, $c0, $d4, $e8, $2a, $f4, $1a, $f4
	db $c6, $f8, $e4, $38, $3c, $d8, $7a, $84, $52, $ac, $2e, $c4, $ce, $04, $04, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $77: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles77::
	db $00, $00, $00, $00, $7f, $00, $fd, $7b, $fb, $77, $8b, $77, $f9, $77, $8c, $73
	db $f7, $78, $fb, $7f, $84, $7b, $ff, $00, $b1, $4e, $bf, $40, $80, $7f, $7f, $00
	db $3f, $00, $7f, $38, $7f, $31, $4f, $30, $7b, $34, $79, $36, $4c, $33, $77, $38
	db $7b, $3f, $7b, $3f, $44, $3b, $7f, $00, $59, $26, $5f, $20, $40, $3f, $3f, $00
	db $0f, $00, $73, $0f, $f7, $6f, $9f, $64, $ff, $60, $9f, $6f, $f3, $6f, $96, $6f
	db $bb, $77, $57, $38, $20, $1f, $7f, $3f, $43, $3c, $ff, $78, $ff, $00, $7f, $00
	db $e0, $00, $90, $e0, $e8, $f0, $ec, $b0, $ee, $34, $0f, $f6, $eb, $f6, $7d, $8e
	db $ed, $7e, $ea, $7c, $7e, $80, $82, $fc, $be, $7c, $c3, $3c, $ff, $3e, $ff, $00
	db $00, $00, $00, $00, $00, $00, $0e, $00, $1e, $04, $1d, $0e, $1a, $07, $05, $03
	db $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $07, $03, $0f, $07, $0f, $04, $7f, $05, $7b, $37, $7f, $31, $3f, $1d
	db $5f, $2c, $7c, $03, $7b, $34, $7c, $33, $3f, $00, $0f, $06, $1f, $0e, $1f, $00
	db $f0, $00, $f8, $f0, $7c, $f8, $3c, $c8, $ff, $e8, $f7, $3a, $ff, $e6, $fe, $2c
	db $fd, $0a, $cd, $32, $37, $c8, $cf, $36, $ff, $06, $ce, $30, $f8, $00, $00, $00
	db $e7, $00, $ff, $67, $fe, $6f, $7e, $29, $ff, $0b, $ff, $66, $ff, $6b, $ff, $02
	db $27, $18, $7f, $20, $f8, $70, $78, $30, $70, $20, $20, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $78: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles78::
	db $3b, $00, $25, $1b, $19, $06, $0b, $04, $1b, $04, $ff, $00, $fa, $7d, $fb, $54
	db $fa, $7d, $fb, $7c, $fb, $54, $fb, $7c, $fa, $7d, $fb, $54, $83, $7c, $ff, $00
	db $dc, $00, $a4, $d8, $9e, $60, $d7, $22, $d7, $22, $9f, $62, $37, $ca, $cf, $30
	db $2f, $f6, $8b, $76, $ff, $06, $8f, $70, $07, $fa, $ff, $02, $86, $78, $fc, $00
	db $3b, $00, $25, $1b, $19, $06, $0b, $05, $ff, $01, $fb, $7c, $fa, $55, $fb, $7c
	db $fa, $7d, $fb, $54, $fb, $7c, $fb, $7c, $fa, $55, $83, $7c, $7f, $00, $ff, $00
	db $dc, $00, $a4, $d8, $98, $60, $d2, $a0, $d7, $a2, $9f, $62, $37, $ca, $c7, $3a
	db $2f, $f0, $8f, $76, $fb, $06, $8f, $76, $77, $88, $ff, $72, $ff, $7a, $fe, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $79: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles79::
	db $03, $00, $04, $03, $09, $07, $0b, $07, $0b, $05, $0b, $05, $0b, $05, $0b, $07
	db $0b, $07, $0b, $07, $05, $03, $04, $03, $1c, $07, $38, $1f, $23, $1c, $3c, $00
	db $00, $00, $00, $00, $07, $00, $08, $07, $13, $0f, $13, $0f, $13, $0e, $09, $07
	db $09, $07, $04, $03, $1c, $03, $2e, $19, $74, $0f, $70, $0f, $3f, $00, $38, $00
	db $00, $00, $00, $00, $80, $00, $60, $80, $90, $e0, $d0, $e0, $c8, $b0, $e8, $50
	db $e8, $50, $e8, $f0, $48, $f0, $10, $e0, $30, $c0, $18, $f0, $8c, $78, $78, $00
	db $20, $00, $47, $00, $48, $07, $11, $0f, $13, $0f, $13, $0d, $53, $0d, $2b, $07
	db $09, $07, $29, $07, $74, $03, $04, $03, $1c, $07, $38, $1f, $23, $1c, $3c, $00
	db $80, $00, $40, $00, $80, $00, $5c, $80, $c8, $80, $a8, $40, $a0, $40, $a0, $c0
	db $a0, $c0, $a4, $c0, $28, $c0, $24, $c0, $38, $e0, $1c, $f8, $c4, $38, $3c, $00
	db $03, $00, $05, $03, $05, $03, $3e, $01, $5d, $3e, $7f, $36, $5d, $3e, $3e, $01
	db $04, $03, $04, $03, $04, $03, $04, $03, $18, $07, $29, $1e, $23, $1c, $1e, $00
	db $1e, $00, $2d, $1e, $2c, $1f, $20, $1f, $10, $0f, $1f, $00, $3f, $1e, $7d, $36
	db $5a, $3d, $3e, $01, $04, $03, $04, $03, $18, $07, $29, $1e, $23, $1c, $1e, $00
	db $00, $00, $38, $00, $f4, $38, $f4, $58, $e8, $70, $90, $60, $e0, $00, $20, $c0
	db $20, $c0, $20, $c0, $20, $c0, $18, $e0, $14, $f8, $c4, $38, $fc, $00, $38, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $7A: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles7A::
	db $07, $00, $18, $07, $0e, $01, $0f, $00, $1b, $0c, $32, $1d, $2a, $15, $4f, $30
	db $58, $27, $92, $6f, $a7, $5a, $ae, $59, $bc, $43, $65, $03, $03, $00, $00, $00
	db $81, $00, $7e, $81, $3c, $ff, $99, $7e, $5a, $bd, $66, $db, $66, $ff, $00, $ff
	db $ff, $42, $e7, $5a, $c3, $bd, $7e, $ff, $3c, $ff, $bd, $c3, $c3, $00, $00, $00
	db $0e, $00, $3f, $08, $58, $37, $be, $41, $7f, $00, $1f, $00, $06, $01, $02, $01
	db $07, $00, $08, $07, $12, $0f, $27, $1a, $2e, $19, $1c, $03, $05, $03, $03, $00
	db $00, $00, $81, $00, $7e, $81, $3c, $ff, $99, $7e, $5a, $bd, $66, $db, $66, $ff
	db $00, $ff, $ff, $42, $e7, $5a, $c3, $bd, $7e, $ff, $3c, $ff, $bd, $c3, $c3, $00
	db $03, $00, $04, $03, $09, $06, $17, $00, $3f, $00, $76, $39, $62, $3d, $22, $1d
	db $11, $0e, $3d, $16, $27, $1a, $2c, $13, $2e, $11, $2c, $13, $1d, $03, $13, $00
	db $81, $00, $7e, $81, $3c, $ff, $db, $3c, $66, $db, $66, $ff, $3c, $c3, $ff, $42
	db $ff, $42, $7e, $81, $66, $99, $bd, $42, $42, $bd, $3c, $c3, $bd, $c3, $c3, $00
	db $00, $00, $00, $00, $08, $00, $18, $00, $3e, $00, $7f, $06, $6f, $12, $cb, $37
	db $bf, $75, $ff, $75, $fb, $67, $e7, $42, $c7, $02, $83, $00, $00, $00, $00, $00
	db $00, $00, $02, $00, $06, $00, $0e, $00, $0f, $06, $1f, $02, $1b, $07, $1f, $05
	db $1f, $05, $1b, $07, $1f, $02, $1f, $02, $0b, $00, $08, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $7B: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles7B::
	db $00, $00, $00, $00, $7f, $00, $fd, $7b, $fb, $77, $8b, $77, $f9, $77, $8c, $73
	db $f7, $78, $fb, $7f, $84, $7b, $ff, $00, $b1, $4e, $bf, $40, $80, $7f, $7f, $00
	db $3f, $00, $7f, $38, $7f, $31, $4f, $30, $7b, $34, $79, $36, $4c, $33, $77, $38
	db $7b, $3f, $7b, $3f, $44, $3b, $7f, $00, $59, $26, $5f, $20, $40, $3f, $3f, $00
	db $1f, $00, $3e, $1f, $7e, $2b, $7e, $2b, $b6, $7f, $80, $7f, $81, $7e, $fe, $01
	db $7e, $3f, $3c, $03, $1c, $0f, $39, $1e, $38, $1f, $2d, $1f, $17, $0f, $3f, $00
	db $80, $00, $40, $80, $20, $c0, $10, $e0, $d0, $20, $90, $60, $10, $e0, $20, $c0
	db $23, $c0, $45, $82, $f5, $02, $09, $f6, $01, $fe, $f1, $fe, $6a, $9c, $fc, $00
	db $80, $00, $40, $80, $20, $c0, $10, $e0, $d0, $20, $90, $60, $10, $e0, $20, $c0
	db $20, $c0, $46, $80, $ea, $04, $12, $ec, $04, $f8, $cc, $f8, $f8, $70, $fc, $00
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $24, $ff, $18, $ff, $18, $ff, $24, $ff, $00, $ff, $00, $ff
	db $03, $03, $0c, $0f, $13, $1c, $2f, $30, $2f, $30, $5c, $63, $59, $67, $59, $67
	db $59, $66, $59, $66, $2c, $33, $2f, $30, $13, $1c, $0c, $0f, $03, $03, $00, $00
	db $00, $0c, $45, $0b, $16, $19, $37, $38, $0f, $f0, $7c, $83, $39, $47, $59, $67
	db $d9, $66, $59, $66, $3c, $43, $7f, $80, $0f, $f0, $36, $39, $55, $1b, $00, $0c
;@ path: gfx/sprites/entities
;@ Entity graphics set $7C: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles7C::
	db $f3, $00, $8c, $73, $54, $2b, $37, $0c, $52, $2d, $f8, $07, $ff, $68, $dd, $6b
	db $9b, $66, $77, $0f, $7d, $03, $73, $0c, $7f, $03, $23, $1c, $77, $3e, $7f, $00
	db $cf, $00, $31, $ce, $2a, $d4, $ec, $30, $4a, $b4, $19, $e6, $fd, $12, $bf, $d0
	db $df, $66, $eb, $f6, $b9, $c6, $ee, $10, $fc, $e0, $f0, $00, $f8, $00, $c0, $00
	db $f3, $00, $8c, $73, $4f, $30, $3f, $0f, $3f, $10, $7f, $00, $bf, $40, $bf, $40
	db $af, $50, $60, $1f, $30, $0f, $3f, $00, $3f, $00, $23, $1c, $41, $3e, $7f, $00
	db $cf, $00, $31, $ce, $e2, $1c, $f4, $e8, $fe, $14, $ff, $06, $fb, $06, $f9, $06
	db $e9, $16, $0f, $f0, $1c, $e0, $fc, $00, $fc, $00, $f8, $00, $fc, $00, $00, $00
	db $0f, $00, $f0, $0f, $d6, $29, $8e, $73, $81, $7e, $83, $7d, $77, $0b, $7f, $32
	db $5f, $38, $37, $08, $1e, $07, $1c, $07, $08, $07, $07, $00, $03, $01, $07, $00
	db $e0, $00, $10, $e0, $68, $90, $1c, $e0, $8e, $74, $be, $48, $ff, $30, $ff, $00
	db $ef, $70, $07, $fa, $87, $7a, $07, $f8, $8f, $70, $fc, $00, $86, $f8, $fe, $00
	db $00, $00, $0f, $00, $f0, $0f, $d6, $29, $8e, $73, $81, $7e, $83, $7d, $77, $0b
	db $7f, $32, $5f, $38, $37, $0b, $1e, $03, $1c, $03, $0f, $00, $1c, $0f, $1f, $00
	db $00, $00, $e0, $00, $10, $e0, $68, $90, $1c, $e0, $8e, $74, $fe, $08, $ff, $30
	db $ff, $00, $bf, $70, $47, $ba, $07, $fa, $4f, $b0, $f9, $06, $79, $9e, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $7D: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles7D::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $0d, $00, $7f, $05, $b7, $78, $b1, $4e, $b8, $47, $7c, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $c0, $00, $e0, $c0, $e0, $40, $e0, $c0, $d0, $20, $10, $e0
	db $7e, $01, $3e, $01, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $01, $5e, $23
	db $7d, $26, $5b, $3d, $ff, $43, $af, $57, $78, $17, $75, $1a, $ff, $6d, $ff, $00
	db $68, $90, $68, $90, $08, $f0, $04, $f8, $04, $f8, $04, $f8, $02, $fc, $8a, $74
	db $8a, $f4, $ce, $f0, $cb, $f6, $d1, $6e, $d2, $6c, $fe, $c8, $ff, $8e, $ff, $00
	db $0e, $00, $1f, $0e, $1f, $0a, $1e, $0d, $2c, $13, $40, $3f, $51, $2f, $78, $17
	db $3f, $08, $5f, $27, $d7, $68, $93, $6d, $5b, $2d, $7a, $0d, $ef, $76, $ff, $00
	db $0e, $00, $1f, $0e, $1f, $0a, $1e, $0d, $2c, $13, $40, $3f, $51, $2f, $58, $37
	db $3f, $18, $6f, $1f, $d7, $6f, $98, $67, $5f, $28, $7a, $0d, $ef, $76, $ff, $00
	db $1b, $00, $3f, $1b, $3f, $09, $3f, $1b, $5b, $24, $80, $7f, $98, $7f, $81, $7e
	db $7e, $01, $7f, $3f, $ff, $41, $a7, $5b, $77, $1b, $74, $1b, $ff, $6c, $ff, $00
	db $80, $00, $e0, $80, $d0, $a0, $d8, $a0, $84, $78, $34, $c8, $34, $c8, $84, $78
	db $cc, $f0, $d2, $ec, $93, $6e, $91, $6e, $b2, $6c, $b6, $68, $f7, $ce, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $7E: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles7E::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01
	db $0d, $03, $14, $0f, $29, $1e, $21, $1e, $20, $1f, $13, $0c, $0c, $03, $05, $03
	db $00, $00, $00, $00, $18, $00, $3d, $18, $7f, $2d, $7f, $35, $ff, $39, $39, $c6
	db $80, $ff, $00, $ff, $60, $9f, $40, $bf, $00, $ff, $80, $7f, $63, $9c, $dd, $e3
	db $07, $00, $0f, $06, $fe, $05, $ff, $e1, $fd, $d6, $fa, $b7, $f8, $67, $ec, $df
	db $d8, $3f, $00, $ff, $1c, $e3, $2a, $d5, $7e, $95, $bc, $53, $f6, $0f, $fd, $fe
	db $00, $00, $f0, $00, $f0, $e0, $f0, $e0, $d8, $e0, $b8, $50, $8c, $70, $76, $8c
	db $33, $ce, $3b, $c6, $3b, $c6, $37, $ce, $7d, $9e, $76, $b8, $dc, $60, $b8, $c0
	db $06, $01, $1f, $00, $27, $1c, $4b, $36, $4f, $30, $4f, $3c, $4e, $31, $2f, $1d
	db $3d, $03, $25, $1b, $23, $1d, $12, $0d, $1f, $00, $3f, $16, $7c, $2f, $7f, $00
	db $ff, $ff, $7f, $ff, $bf, $7f, $e0, $1f, $7f, $c0, $3f, $dc, $ff, $3e, $7f, $be
	db $ff, $be, $fe, $dd, $fd, $e3, $ff, $ff, $7f, $ff, $9e, $7f, $ff, $00, $ff, $00
	db $fb, $fd, $ef, $f1, $37, $c8, $e6, $1b, $be, $c7, $3e, $c1, $dc, $2b, $5c, $ef
	db $6e, $f1, $ee, $f7, $ef, $f0, $c8, $f7, $97, $e8, $2f, $d6, $f3, $0f, $ff, $00
	db $7c, $80, $4c, $b0, $9c, $78, $ca, $3c, $42, $bc, $02, $fc, $02, $fc, $26, $d8
	db $3e, $c0, $7c, $80, $fc, $40, $ff, $60, $bd, $72, $df, $ba, $ef, $5e, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $7F: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTiles7F::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $0d, $03, $3a, $0d
	db $52, $3d, $40, $3f, $43, $3c, $24, $1b, $17, $0b, $0f, $03, $07, $00, $04, $03
	db $00, $00, $18, $00, $3d, $18, $7f, $2d, $7f, $35, $ff, $09, $e9, $f6, $60, $9f
	db $40, $bf, $00, $ff, $e0, $1f, $9c, $63, $fa, $6d, $fd, $6e, $ff, $00, $fe, $ff
	db $07, $00, $ff, $06, $fe, $e5, $ff, $d1, $f9, $b6, $fc, $6f, $fc, $df, $d0, $3f
	db $06, $f9, $04, $fb, $02, $fd, $02, $fd, $02, $fd, $04, $fb, $8e, $73, $fd, $0e
	db $00, $00, $f0, $00, $f0, $e0, $f0, $e0, $d8, $e0, $b8, $50, $8c, $70, $76, $8c
	db $33, $ce, $3b, $c6, $3b, $c6, $37, $ce, $7d, $9e, $76, $b8, $dc, $60, $b8, $c0
	db $07, $00, $08, $07, $16, $0f, $10, $0f, $10, $0f, $10, $0f, $09, $06, $07, $01
	db $05, $02, $02, $01, $02, $01, $02, $01, $02, $01, $05, $03, $07, $03, $05, $03
	db $0e, $00, $df, $0e, $3f, $c8, $09, $f6, $00, $ff, $e0, $1f, $f0, $af, $fc, $b3
	db $ff, $00, $ff, $00, $ff, $00, $c4, $3b, $b7, $7f, $a6, $7f, $90, $6f, $ff, $80
	db $78, $00, $fc, $78, $ff, $c4, $fd, $ba, $fe, $67, $6c, $9f, $00, $ff, $00, $ff
	db $e0, $1f, $f8, $07, $fc, $03, $7c, $83, $3c, $c3, $1c, $e3, $76, $8f, $bd, $7e
	db $00, $00, $e0, $00, $60, $c0, $fc, $c0, $fc, $38, $fc, $78, $fe, $30, $5e, $ac
	db $22, $dc, $3f, $c0, $1f, $e2, $1b, $e6, $1b, $e6, $35, $ce, $da, $3c, $f4, $f8
