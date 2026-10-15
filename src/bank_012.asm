; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $012", ROMX[$4000], BANK[$12]

;@ path: gfx/sprites/entities
;@ Entity graphics set $C0: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC0::
	db $03, $00, $3f, $01, $3f, $13, $7f, $1f, $ff, $31, $ff, $60, $ff, $24, $7f, $26
	db $7f, $26, $ff, $22, $ff, $70, $ff, $38, $7f, $1f, $3f, $13, $3f, $01, $03, $00
	db $bd, $00, $ff, $18, $ff, $ff, $ff, $f3, $ff, $f3, $ff, $f3, $ff, $63, $ff, $61
	db $ff, $64, $ff, $44, $ff, $4c, $ff, $cc, $ff, $ff, $ff, $ff, $ff, $18, $bd, $00
	db $c0, $00, $fc, $80, $fe, $c8, $fe, $fc, $ff, $e4, $ff, $e6, $ff, $c4, $fe, $cc
	db $fe, $cc, $ff, $fc, $ff, $9e, $ff, $9c, $fe, $f8, $fc, $c8, $fc, $80, $c0, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $0c, $03, $13, $0c, $27, $18
	db $2f, $10, $5f, $20, $5f, $20, $5f, $20, $cb, $34, $ff, $00, $af, $58, $b7, $4f
	db $07, $00, $18, $07, $67, $18, $9f, $60, $ff, $00, $3f, $c0, $ef, $10, $d7, $38
	db $bf, $78, $7b, $fc, $fb, $fc, $fb, $7c, $fb, $7c, $ff, $78, $f7, $f8, $ef, $f0
	db $fc, $03, $3f, $00, $1f, $00, $2e, $1f, $5f, $3f, $5f, $3f, $43, $3f, $3b, $07
	db $11, $0f, $09, $07, $04, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00
	db $3f, $cc, $f9, $1e, $37, $de, $ef, $de, $f9, $de, $e7, $de, $7f, $ed, $8f, $73
	db $f7, $8f, $ff, $ff, $7f, $ff, $1e, $ff, $80, $7f, $70, $0f, $0e, $01, $01, $00
	db $f2, $0d, $ff, $00, $d9, $26, $f1, $0e, $fb, $04, $ce, $31, $cc, $33, $ec, $13
	db $ff, $00, $f0, $0f, $e8, $1f, $fc, $ff, $f0, $ff, $92, $ff, $9e, $ff, $f8, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $C1: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC1::
	db $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $0c, $03, $13, $0c, $27, $18
	db $2f, $10, $5f, $20, $4f, $30, $7b, $04, $cf, $30, $ff, $10, $af, $58, $b7, $4f
	db $07, $00, $18, $07, $67, $18, $9f, $60, $ff, $00, $3f, $c0, $cf, $30, $f7, $08
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $9f, $60, $f7, $78, $f7, $f8, $ef, $f0
	db $fc, $03, $7f, $00, $b7, $78, $bf, $7f, $47, $3f, $37, $0f, $23, $1f, $13, $0f
	db $11, $0f, $09, $07, $04, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00
	db $3f, $c3, $fe, $07, $fd, $0f, $73, $ef, $fe, $ef, $f1, $ef, $6f, $f6, $8f, $71
	db $f7, $8f, $ff, $ff, $7f, $ff, $1e, $ff, $80, $7f, $70, $0f, $0e, $01, $01, $00
	db $07, $00, $0b, $04, $17, $08, $2f, $10, $2e, $10, $5e, $20, $5e, $20, $bf, $40
	db $9f, $60, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fd, $02, $ff, $00, $f6, $09
	db $f2, $0d, $ff, $00, $d9, $26, $f1, $0e, $fb, $04, $ce, $31, $cc, $33, $ec, $13
	db $ff, $80, $30, $cf, $e8, $df, $3c, $df, $f0, $df, $d2, $bf, $9e, $7f, $f8, $ff
	db $f8, $ff, $c8, $ff, $c0, $ff, $00, $ff, $0f, $f0, $70, $8f, $81, $7f, $87, $78
	db $62, $3c, $52, $3c, $31, $1e, $29, $1e, $19, $0e, $15, $0e, $09, $06, $06, $00
	db $c0, $00, $b8, $c0, $44, $f8, $be, $7c, $b2, $7c, $cd, $3e, $5f, $be, $5f, $be
	db $5d, $be, $42, $bc, $dd, $3e, $dd, $3e, $dd, $3e, $42, $bc, $5d, $be, $dd, $3e
;@ path: gfx/sprites/entities
;@ Entity graphics set $C2: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC2::
	db $60, $00, $b0, $40, $b0, $40, $b0, $40, $b8, $40, $bc, $40, $bc, $40, $be, $40
	db $9f, $60, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fd, $02, $ff, $00, $f6, $09
	db $f8, $ff, $c8, $ff, $c0, $ff, $00, $ff, $0f, $f0, $70, $8f, $81, $7f, $87, $78
	db $c2, $7c, $c2, $7c, $c4, $78, $c4, $78, $c8, $70, $88, $70, $90, $60, $60, $00
	db $00, $00, $03, $00, $0c, $03, $17, $0f, $2f, $1f, $3f, $1f, $5f, $3f, $5f, $3f
	db $5f, $3f, $5f, $3f, $3f, $1f, $2f, $1f, $17, $0f, $0c, $03, $03, $00, $00, $00
	db $00, $00, $c0, $00, $30, $c0, $e8, $f0, $f4, $f8, $fc, $f8, $fa, $fc, $fa, $fc
	db $fa, $8c, $fa, $04, $ec, $10, $fc, $00, $f8, $80, $30, $c0, $c0, $00, $00, $00
	db $0f, $00, $3f, $0e, $5f, $2a, $7f, $2e, $8e, $71, $80, $7f, $95, $6e, $6f, $1d
	db $1f, $03, $1f, $0b, $1f, $0d, $0f, $06, $07, $00, $01, $00, $00, $00, $00, $00
	db $cc, $00, $3e, $cc, $2f, $f6, $57, $ba, $4f, $ba, $4b, $bc, $82, $7c, $82, $fc
	db $c2, $fc, $c2, $bc, $c2, $bc, $c4, $38, $e4, $d8, $b8, $e0, $f0, $60, $70, $00
	db $1f, $00, $3f, $17, $3f, $05, $5f, $37, $67, $38, $40, $3f, $4a, $37, $37, $0e
	db $1f, $00, $05, $02, $07, $02, $03, $00, $01, $00, $01, $00, $00, $00, $00, $00
	db $d8, $00, $bc, $58, $be, $6c, $be, $54, $2e, $d4, $26, $d8, $c2, $3c, $e2, $dc
	db $82, $fc, $d2, $ec, $f4, $68, $e4, $18, $e8, $d0, $b0, $e0, $f0, $60, $70, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $C3: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC3::
	db $06, $00, $0f, $06, $0f, $05, $0f, $06, $16, $09, $11, $0f, $10, $0f, $0b, $04
	db $0c, $03, $0f, $04, $0d, $06, $0b, $04, $07, $01, $03, $01, $02, $01, $01, $00
	db $01, $00, $37, $01, $7f, $37, $cf, $77, $cf, $7e, $fe, $6f, $7c, $1f, $3f, $1d
	db $3f, $1d, $3d, $1e, $2c, $1f, $1e, $0f, $3f, $17, $3d, $1b, $1f, $0c, $0c, $00
	db $f0, $00, $c8, $b0, $c8, $b0, $c8, $f0, $c8, $30, $e8, $d0, $70, $e0, $70, $e0
	db $e0, $c0, $cc, $00, $5e, $8c, $7f, $9e, $3f, $de, $ff, $de, $fe, $0c, $0c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $0f, $03, $1f, $0a, $1f, $0b
	db $33, $1c, $20, $1f, $24, $1b, $19, $07, $07, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $1e, $00, $3f, $1e, $ff, $00, $c0, $bf, $cc, $b3, $de, $ad
	db $9e, $6d, $7f, $db, $ff, $d7, $fd, $be, $ff, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0e, $00, $de, $0c, $3e, $dc, $3e, $dc
	db $fe, $dc, $be, $cc, $4e, $80, $e0, $c0, $e0, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $0f, $03, $1f, $0a, $37, $1b
	db $23, $1c, $20, $1f, $3c, $03, $05, $03, $05, $02, $07, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0c, $00, $dc, $08, $3c, $d8, $3c, $d8
	db $fc, $d8, $bc, $c8, $4c, $80, $e0, $c0, $e0, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $C4: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC4::
	db $1c, $00, $3e, $1c, $37, $0e, $0b, $06, $0b, $04, $0f, $07, $1f, $0b, $1f, $0b
	db $2f, $19, $2f, $1f, $17, $0f, $3f, $10, $3f, $17, $1b, $07, $1d, $0e, $1f, $00
	db $60, $00, $f0, $60, $90, $e0, $a0, $c0, $a0, $c0, $e0, $c0, $f0, $60, $f8, $60
	db $e8, $f0, $c8, $f0, $f0, $80, $f0, $60, $f0, $60, $f0, $80, $78, $f0, $f8, $00
	db $06, $00, $0f, $06, $0f, $07, $07, $03, $07, $03, $07, $03, $0f, $07, $1f, $0f
	db $1f, $0f, $17, $0f, $0b, $04, $1f, $0b, $17, $0b, $0f, $04, $1e, $0f, $1f, $00
	db $38, $00, $7c, $38, $fc, $70, $f0, $60, $f0, $60, $f0, $e0, $f8, $f0, $f8, $f0
	db $f4, $f8, $f4, $f8, $e8, $70, $fc, $b8, $f4, $b8, $f8, $60, $f8, $70, $f8, $00
	db $77, $00, $7f, $36, $2d, $1b, $15, $0b, $0d, $03, $1f, $0f, $1f, $0b, $3f, $1b
	db $7f, $0f, $7f, $3f, $5d, $3e, $3f, $01, $07, $01, $07, $00, $07, $03, $0f, $00
	db $00, $00, $80, $00, $80, $00, $80, $00, $80, $00, $c0, $00, $e0, $c0, $d0, $e0
	db $d0, $e0, $a0, $c0, $78, $e0, $dc, $e8, $bc, $c8, $d8, $20, $f0, $e0, $f0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $00, $3e, $14
	db $3e, $00, $24, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $c3, $00, $e7, $42, $ff, $66, $ff, $66
	db $7e, $24, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $C5: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC5::
	db $07, $00, $18, $07, $26, $19, $27, $1a, $4f, $33, $5f, $2b, $3f, $0f, $1f, $0d
	db $17, $0d, $2b, $17, $2f, $10, $3f, $0d, $1f, $0d, $1d, $02, $17, $0f, $1f, $00
	db $c0, $00, $20, $c0, $1c, $e0, $82, $7c, $d2, $2c, $fa, $54, $fc, $d0, $ea, $f4
	db $b2, $cc, $61, $9e, $d1, $2e, $d1, $ae, $d2, $ac, $8c, $70, $88, $f0, $f8, $00
	db $07, $00, $08, $07, $31, $0e, $43, $3d, $57, $29, $7f, $15, $3f, $17, $5f, $2f
	db $8b, $77, $85, $7b, $87, $78, $4f, $36, $3f, $06, $16, $09, $13, $0f, $1f, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $77, $00, $7f, $36, $2d, $1b, $15, $0b, $0d, $03, $1f, $0f, $1f, $0b, $3f, $1b
	db $7f, $0f, $7f, $3f, $5d, $3e, $3f, $01, $07, $01, $07, $00, $07, $03, $0f, $00
	db $00, $00, $80, $00, $80, $00, $80, $00, $80, $00, $c0, $00, $e0, $c0, $d0, $e0
	db $d0, $e0, $a0, $c0, $78, $e0, $dc, $e8, $bc, $c8, $d8, $20, $f0, $e0, $f0, $00
	db $3c, $00, $3e, $1c, $17, $0e, $0b, $06, $0f, $02, $1f, $0f, $1f, $07, $3f, $17
	db $7f, $1f, $7f, $3f, $5a, $3d, $3f, $03, $07, $03, $0f, $00, $19, $0e, $1f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $c0, $80, $a0, $c0
	db $a0, $c0, $c0, $80, $ec, $c0, $9e, $ec, $7e, $b4, $ac, $70, $d8, $e0, $f0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $C6: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC6::
	db $05, $00, $07, $00, $0d, $02, $0b, $04, $0f, $00, $1f, $0c, $3f, $0d, $79, $3e
	db $c7, $78, $e9, $56, $8b, $75, $5f, $21, $31, $00, $03, $01, $07, $02, $07, $00
	db $f0, $00, $f0, $00, $e0, $00, $f0, $00, $f0, $80, $e8, $90, $54, $b8, $cc, $38
	db $ca, $3c, $c6, $bc, $e7, $dc, $f3, $cc, $5e, $a0, $cc, $70, $a8, $d0, $f8, $00
	db $30, $00, $3d, $10, $3f, $18, $2d, $1a, $1b, $04, $1f, $00, $1f, $0c, $3f, $0d
	db $79, $3e, $c7, $78, $e9, $56, $8b, $75, $5d, $23, $33, $00, $07, $02, $07, $00
	db $03, $00, $e5, $02, $e9, $06, $d5, $0e, $ef, $1e, $fd, $9e, $da, $bc, $5a, $bc
	db $e4, $18, $f8, $00, $fe, $80, $ff, $c0, $de, $a0, $cc, $70, $a8, $d0, $f8, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $C7: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC7::
	db $01, $00, $03, $01, $f9, $00, $b4, $78, $63, $1c, $38, $07, $36, $19, $3a, $1d
	db $3a, $1d, $1c, $0b, $0c, $03, $02, $01, $01, $00, $03, $00, $07, $03, $07, $00
	db $c3, $00, $a5, $c3, $99, $66, $5a, $24, $81, $7e, $c3, $3c, $ff, $42, $ff, $66
	db $66, $99, $99, $7e, $ff, $00, $7e, $a5, $3c, $c3, $81, $7e, $bd, $42, $c3, $00
	db $01, $00, $03, $01, $01, $00, $01, $00, $06, $01, $0a, $07, $0c, $07, $12, $0d
	db $12, $0d, $12, $0d, $13, $0c, $13, $0c, $0b, $04, $09, $06, $07, $01, $03, $00
	db $e7, $00, $99, $e7, $db, $24, $81, $7e, $c3, $3c, $ff, $42, $ff, $66, $66, $99
	db $99, $7e, $7e, $81, $00, $ff, $18, $e7, $81, $7e, $99, $66, $e7, $81, $c3, $00
	db $e0, $00, $f8, $00, $fe, $30, $7b, $3c, $7e, $1f, $2f, $1f, $3f, $0f, $16, $0f
	db $1e, $07, $1f, $07, $3f, $07, $36, $0f, $6f, $1e, $7d, $1e, $fb, $1c, $ff, $18
	db $03, $00, $0f, $00, $3f, $00, $f7, $0f, $ef, $1f, $fd, $fe, $f7, $f8, $6f, $f0
	db $ff, $00, $fe, $00, $fc, $00, $e0, $00, $e0, $00, $e0, $00, $c0, $00, $80, $00
	db $07, $00, $0f, $03, $0f, $03, $07, $01, $03, $00, $03, $00, $03, $00, $07, $01
	db $1f, $03, $3f, $0f, $7f, $1f, $3f, $0f, $1f, $03, $07, $01, $03, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $18, $00, $3c, $18, $3e, $1c, $1f, $0c, $0e, $05
	db $05, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $C8: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC8::
	db $1f, $00, $16, $0b, $20, $1f, $3c, $03, $fe, $09, $fe, $61, $f6, $39, $fc, $7f
	db $5a, $3d, $7c, $33, $f8, $6f, $f8, $6f, $7f, $30, $3c, $03, $3e, $17, $3f, $00
	db $00, $00, $80, $00, $40, $80, $20, $c0, $20, $c0, $10, $e0, $10, $e0, $10, $e0
	db $08, $f0, $08, $f0, $08, $f0, $8e, $70, $15, $ea, $35, $ca, $3e, $c0, $e0, $00
	db $06, $00, $0d, $06, $08, $07, $10, $0f, $7c, $03, $fc, $63, $c8, $77, $88, $77
	db $40, $3f, $60, $1f, $70, $2f, $70, $3f, $30, $1f, $38, $07, $70, $3f, $7f, $00
	db $c0, $00, $20, $c0, $10, $e0, $10, $e0, $08, $f0, $08, $f0, $04, $f8, $04, $f8
	db $04, $f8, $1e, $e0, $69, $96, $e9, $16, $ff, $00, $7e, $80, $c2, $3c, $fe, $00
	db $0c, $00, $13, $0c, $10, $0f, $17, $08, $6f, $14, $ef, $50, $af, $5f, $af, $59
	db $5f, $2f, $5c, $33, $5f, $3f, $5f, $3f, $2f, $1d, $37, $0f, $71, $3e, $7f, $00
	db $60, $00, $90, $60, $30, $e0, $c8, $30, $e4, $98, $e4, $18, $64, $98, $c2, $fc
	db $f2, $ec, $e2, $dc, $e2, $bc, $e7, $b8, $fd, $c2, $87, $f8, $8e, $7c, $fe, $00
	db $03, $00, $04, $03, $0f, $00, $1f, $04, $1f, $00, $6f, $1f, $fb, $54, $bf, $50
	db $bf, $58, $5f, $2f, $59, $37, $5f, $3f, $5f, $3b, $2f, $1f, $71, $3e, $7f, $00
	db $30, $00, $d8, $30, $e8, $10, $e4, $98, $e4, $18, $e4, $f8, $b2, $5c, $f2, $1c
	db $e9, $36, $f1, $ee, $f1, $de, $f3, $dc, $fd, $e2, $e7, $f8, $8e, $7c, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $C9: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesC9::
	db $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f
	db $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f, $cf, $3f
	db $00, $00, $00, $00, $00, $00, $01, $00, $03, $01, $03, $00, $01, $00, $01, $00
	db $07, $00, $0d, $06, $1a, $0d, $1f, $00, $02, $01, $02, $01, $03, $01, $03, $01
	db $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01
	db $02, $01, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
	db $03, $02, $07, $04, $07, $04, $0f, $08, $0f, $08, $1f, $10, $1f, $10, $1f, $10
	db $00, $00, $00, $00, $00, $00, $07, $07, $1f, $18, $7f, $60, $ff, $80, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02, $07, $04
	db $07, $04, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $07, $04
	db $00, $00, $00, $00, $0f, $0f, $3f, $30, $ff, $c0, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $07, $04, $03, $02, $03, $02, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $CA: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesCA::
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $ff, $80, $7f, $40
	db $7f, $40, $3f, $20, $3f, $20, $1f, $10, $0f, $0c, $03, $03, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02
	db $07, $04, $0f, $08, $0f, $08, $0f, $08, $07, $04, $03, $03, $00, $00, $00, $00
	db $00, $00, $07, $07, $0f, $08, $1f, $10, $1f, $10, $7f, $60, $ff, $80, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $7f, $40
	db $7f, $40, $3f, $20, $3f, $20, $3f, $20, $3f, $20, $3f, $20, $3f, $20, $1f, $10
	db $1f, $10, $1f, $10, $0f, $08, $0f, $08, $07, $04, $03, $02, $01, $01, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02
	db $07, $04, $07, $04, $07, $04, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00
	db $03, $03, $07, $04, $0f, $08, $0f, $08, $0f, $08, $3f, $38, $ff, $c0, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $c0, $3f, $20, $1f, $10, $1f, $10
	db $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10
	db $1f, $10, $1f, $10, $0f, $08, $0f, $08, $07, $04, $07, $04, $03, $02, $01, $01
	db $01, $01, $03, $02, $07, $04, $07, $04, $07, $04, $03, $02, $1f, $1e, $3f, $22
	db $7f, $40, $ff, $80, $ff, $80, $ff, $f0, $0f, $08, $0f, $08, $0f, $08, $0f, $08
;@ path: gfx/sprites/entities
;@ Entity graphics set $CB: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesCB::
	db $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08
	db $0f, $08, $0f, $08, $07, $04, $07, $04, $07, $04, $03, $02, $03, $02, $01, $01
	db $18, $00, $3c, $18, $3c, $18, $3c, $18, $3c, $18, $3c, $18, $3c, $18, $3c, $18
	db $3c, $18, $3c, $18, $3c, $18, $3c, $18, $3c, $18, $3c, $18, $3c, $18, $18, $00
	db $00, $00, $03, $00, $07, $02, $0f, $06, $0f, $06, $1e, $0c, $1e, $0c, $3c, $18
	db $3c, $18, $78, $30, $78, $30, $f0, $60, $f0, $60, $e0, $40, $c0, $00, $00, $00
	db $00, $00, $00, $00, $18, $00, $3c, $18, $7c, $38, $f8, $70, $f0, $e0, $e0, $c0
	db $c0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $1e, $00, $7e, $1c, $fc, $78, $f8, $e0
	db $e0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $07, $07, $1f, $18, $3f, $20, $7f, $40, $7f, $40, $ff, $80, $ff, $80, $ff, $80
	db $ff, $80, $ff, $80, $ff, $80, $7f, $40, $7f, $40, $3f, $20, $1f, $18, $07, $07
	db $c0, $00, $7c, $00, $3e, $00, $06, $00, $0c, $00, $18, $00, $18, $00, $19, $00
	db $33, $00, $3e, $00, $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $3c, $00, $7e, $00, $6e, $30, $77, $38, $3e, $01, $03, $00, $ff, $00, $8f, $7e
	db $8f, $7e, $ff, $00, $41, $3e, $4f, $3e, $4f, $3e, $4f, $3e, $4f, $3e, $7f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $CC: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesCC::
	db $0e, $00, $15, $0a, $10, $0f, $1e, $01, $cf, $06, $e5, $03, $fb, $00, $79, $30
	db $3f, $00, $0e, $05, $0e, $01, $09, $06, $07, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $3f, $00, $4d, $3e, $7c, $03, $7e, $2d, $ff, $7e, $ff, $56
	db $ee, $11, $e0, $7f, $04, $fb, $2e, $d5, $ff, $20, $ff, $df, $7f, $ff, $ff, $00
	db $00, $00, $80, $00, $c0, $80, $c0, $00, $80, $00, $40, $80, $40, $80, $83, $00
	db $47, $82, $29, $c6, $91, $6e, $d2, $6c, $52, $ec, $fa, $84, $ba, $74, $85, $7a
	db $7f, $8e, $3e, $dd, $7f, $94, $ff, $17, $ff, $1d, $5f, $2f, $ef, $70, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $c7, $3a, $27, $da, $8f, $72, $9d, $66, $fe, $00, $f2, $8c, $c7, $3e, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $0d, $06
	db $10, $0f, $10, $0f, $1d, $02, $0f, $04, $0f, $02, $03, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $1e, $00, $2f, $1c, $23, $1d, $21, $1e, $60, $1f, $f0, $2f
	db $78, $a7, $07, $f8, $a0, $5f, $f0, $bf, $ef, $70, $d7, $ee, $ff, $00, $67, $18
	db $00, $00, $00, $00, $00, $00, $80, $00, $c0, $00, $a0, $40, $20, $c0, $20, $c0
	db $27, $c0, $fb, $06, $6d, $9e, $da, $3c, $84, $78, $38, $c0, $38, $f0, $38, $f0
;@ path: gfx/sprites/entities
;@ Entity graphics set $CD: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesCD::
	db $a2, $5d, $82, $7d, $44, $3b, $38, $07, $39, $07, $65, $1b, $c3, $7c, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $24, $f8, $7c, $f8, $8c, $f8, $f4, $f8, $1c, $f0, $fa, $e4, $f3, $0e, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $03, $00, $07, $03, $07, $03, $07, $02, $0f, $00, $0a, $05
	db $0f, $00, $10, $0f, $2b, $14, $2a, $15, $20, $1f, $4c, $3f, $80, $7f, $a4, $5b
	db $00, $00, $00, $00, $0e, $00, $9f, $0e, $ff, $1e, $b7, $de, $b6, $4c, $7e, $9c
	db $3e, $cc, $1e, $e4, $0c, $f0, $48, $f0, $c4, $38, $84, $78, $82, $7c, $42, $bc
	db $80, $7f, $80, $7f, $40, $3f, $3f, $00, $40, $3f, $40, $3f, $80, $7f, $80, $7f
	db $80, $7f, $80, $7f, $80, $7f, $40, $3f, $30, $0f, $4f, $30, $82, $7d, $ff, $00
	db $42, $bc, $41, $be, $81, $7e, $21, $de, $31, $ce, $21, $de, $43, $bc, $65, $ba
	db $39, $c6, $01, $fe, $02, $fc, $04, $f8, $c4, $38, $02, $fc, $02, $fc, $fe, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $18, $00, $3c, $18, $3f, $18, $3d, $16, $7d, $02, $53, $2c, $79, $06, $80, $7f
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $70, $00, $f8, $70, $f8, $f0, $b8, $f0, $b0, $60, $f0, $e0, $f0, $60, $e0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $CE: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesCE::
	db $01, $00, $01, $00, $01, $00, $02, $01, $04, $03, $05, $02, $04, $03, $02, $01
	db $01, $00, $03, $00, $07, $03, $06, $03, $04, $03, $04, $03, $02, $01, $01, $00
	db $58, $a7, $52, $af, $06, $f9, $64, $fb, $02, $fd, $22, $dd, $03, $fc, $06, $f9
	db $f8, $07, $06, $f9, $8f, $76, $53, $ae, $51, $ae, $51, $ae, $73, $8c, $ff, $00
	db $20, $c0, $10, $e0, $08, $f0, $04, $f8, $04, $f8, $02, $fc, $22, $dc, $21, $de
	db $31, $ce, $41, $be, $62, $bc, $6e, $b0, $72, $8c, $06, $f8, $1c, $e0, $f0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0e, $00, $0a, $04, $3f, $00, $7f, $2d
	db $60, $3f, $60, $3f, $60, $3f, $60, $3f, $60, $3f, $60, $3f, $60, $3f, $60, $3f
	db $60, $3f, $60, $3f, $60, $3f, $60, $3f, $60, $3f, $60, $3f, $5f, $3f, $ff, $00
	db $c0, $7f, $ff, $00, $0d, $00, $0d, $00, $1d, $00, $2c, $13, $38, $07, $00, $00
	db $01, $00, $01, $00, $03, $00, $04, $03, $05, $02, $04, $03, $04, $03, $02, $01
	db $01, $00, $03, $00, $07, $03, $06, $03, $04, $03, $04, $03, $02, $01, $01, $00
	db $58, $a7, $52, $af, $66, $f9, $04, $fb, $12, $ed, $02, $fd, $03, $fc, $0c, $f3
	db $f0, $0f, $06, $f9, $8f, $76, $53, $ae, $51, $ae, $51, $ae, $73, $8c, $ff, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $CF: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesCF::
	db $00, $00, $00, $00, $00, $00, $1b, $00, $24, $1b, $2e, $13, $30, $0f, $20, $1f
	db $73, $0c, $78, $1f, $7b, $3c, $5f, $3b, $38, $07, $29, $16, $1c, $03, $07, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $b8, $00, $5c, $b8, $2c, $d0
	db $3e, $cc, $27, $de, $07, $f8, $82, $7c, $82, $7c, $22, $dc, $44, $b8, $f8, $00
	db $00, $00, $00, $00, $06, $00, $09, $06, $1d, $06, $28, $17, $20, $1f, $33, $0c
	db $78, $1f, $7b, $3c, $5f, $3b, $28, $17, $59, $26, $48, $37, $3c, $03, $07, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $9c, $00, $6e, $9c, $3e, $c0
	db $2e, $dc, $24, $d8, $84, $78, $82, $7c, $02, $fc, $22, $dc, $44, $b8, $f8, $00
	db $00, $00, $30, $00, $7f, $30, $a1, $5e, $87, $7f, $bf, $40, $a0, $5f, $dd, $02
	db $03, $00, $07, $00, $07, $00, $07, $00, $03, $00, $07, $02, $07, $00, $01, $00
	db $60, $00, $f0, $40, $3e, $c0, $7c, $80, $ae, $70, $fc, $50, $b8, $60, $f0, $00
	db $fc, $00, $d6, $28, $d6, $28, $a4, $58, $fc, $00, $f0, $00, $c8, $f0, $f8, $00
	db $18, $00, $3e, $18, $51, $2e, $9c, $7f, $bb, $47, $c7, $00, $0e, $01, $04, $03
	db $09, $06, $0f, $00, $07, $00, $07, $00, $03, $00, $07, $02, $07, $00, $01, $00
	db $30, $00, $78, $20, $9c, $60, $bf, $40, $fe, $80, $c7, $38, $7c, $80, $78, $80
	db $fc, $00, $d6, $28, $d6, $28, $a4, $58, $fc, $00, $f0, $00, $c8, $f0, $f8, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D0: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD0::
	db $06, $00, $0e, $04, $1e, $0c, $3b, $1c, $74, $3b, $e8, $77, $fa, $05, $1a, $05
	db $18, $07, $fc, $03, $ef, $70, $77, $38, $3b, $1c, $1e, $0c, $0e, $04, $06, $00
	db $00, $00, $01, $00, $03, $01, $e3, $01, $f7, $60, $ff, $74, $7d, $2b, $78, $27
	db $f3, $6c, $f7, $69, $77, $28, $f7, $68, $f3, $8c, $f8, $e7, $77, $78, $0f, $0f
	db $00, $00, $07, $07, $1f, $1c, $3f, $31, $7f, $67, $7f, $6e, $ff, $cc, $ff, $cd
	db $ff, $67, $ff, $73, $ff, $b8, $ff, $9f, $7f, $47, $3f, $30, $0f, $0f, $00, $00
	db $01, $00, $03, $01, $e3, $01, $f7, $60, $ff, $70, $7f, $2c, $7f, $2e, $ff, $6b
	db $ff, $68, $79, $27, $f3, $6c, $f4, $4b, $f1, $8e, $ff, $f1, $3f, $3f, $07, $07
	db $00, $00, $03, $00, $0c, $03, $11, $0f, $13, $0f, $23, $1d, $27, $18, $27, $18
	db $77, $28, $73, $2c, $5c, $33, $2f, $1c, $7b, $07, $77, $18, $3f, $10, $1f, $00
	db $03, $00, $77, $70, $7f, $78, $7f, $78, $3f, $33, $7f, $07, $ff, $09, $ff, $09
	db $ff, $0d, $ff, $0f, $7f, $03, $3f, $32, $7f, $7a, $7f, $78, $77, $70, $03, $00
	db $0f, $09, $3f, $18, $7f, $03, $7f, $4f, $ff, $d3, $ff, $19, $ff, $3d, $ff, $af
	db $ff, $a7, $ff, $39, $ff, $1c, $ff, $de, $7f, $4f, $7f, $03, $3f, $18, $0f, $09
	db $1f, $00, $3f, $1f, $5f, $3f, $9f, $60, $a0, $5f, $c0, $3f, $9b, $64, $9f, $78
	db $87, $78, $b7, $48, $b7, $78, $87, $7c, $bb, $46, $b9, $7f, $80, $7f, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D1: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD1::
	db $00, $00, $00, $00, $00, $00, $0f, $00, $3f, $00, $3f, $00, $1f, $01, $07, $03
	db $7f, $02, $a7, $58, $81, $7e, $f8, $07, $7d, $3a, $5f, $3d, $37, $0e, $0b, $07
	db $00, $00, $7c, $00, $b2, $7c, $f9, $06, $ff, $00, $ff, $00, $ff, $60, $ff, $f0
	db $ff, $b0, $e3, $1c, $00, $ff, $04, $fb, $3f, $c3, $ff, $2f, $f6, $d9, $e9, $f6
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $e0, $00, $e0, $00
	db $cc, $00, $0e, $04, $8e, $04, $5e, $8c, $5e, $8c, $7a, $9c, $f6, $38, $ea, $74
	db $0e, $01, $0b, $04, $13, $0d, $12, $0d, $0f, $00, $1d, $06, $3c, $1f, $3f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $38, $c7, $c4, $3b, $40, $bf, $61, $9e, $ff, $00, $f0, $1f, $f8, $7f, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $b2, $4c, $c2, $3c, $84, $78, $84, $78, $08, $f0, $b0, $40, $40, $80, $c0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $e0, $00, $e0, $00
	db $c0, $00, $00, $00, $80, $00, $40, $80, $40, $80, $40, $80, $80, $00, $00, $00
	db $c0, $00, $e0, $40, $b8, $60, $de, $38, $37, $ce, $8f, $70, $40, $bf, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D2: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD2::
	db $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $e0, $00, $10, $e0, $f0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $07, $00, $0f, $00, $0f, $00, $0f, $00, $07, $00, $3f, $01, $53, $2c
	db $40, $3f, $78, $07, $7c, $2b, $2f, $00, $07, $00, $03, $00, $3f, $01, $3f, $1e
	db $1e, $00, $ed, $1e, $f8, $07, $fe, $01, $ff, $00, $ff, $b0, $ff, $f8, $ff, $58
	db $f3, $0c, $01, $fe, $25, $da, $fe, $23, $fe, $07, $fe, $0f, $f6, $19, $e9, $f6
	db $00, $00, $00, $00, $80, $00, $80, $00, $80, $00, $80, $00, $c0, $00, $e0, $00
	db $e0, $00, $c0, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00, $80, $00
	db $2f, $1f, $1f, $00, $13, $0d, $12, $0d, $0f, $00, $1d, $06, $3c, $1f, $3f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $07, $00, $07, $03, $02, $01, $03, $00, $3f, $02, $3f, $1c
	db $3f, $00, $7e, $2d, $2a, $15, $3c, $03, $7c, $2b, $3c, $03, $7c, $2b, $39, $06
	db $79, $06, $fb, $54, $f1, $0e, $71, $8e, $de, $e7, $3e, $cf, $fe, $39, $f9, $f6
	db $00, $00, $80, $00, $40, $80, $40, $80, $f0, $00, $f8, $00, $f8, $00, $fc, $00
	db $7c, $80, $fe, $40, $ff, $c2, $7f, $82, $f9, $06, $fa, $04, $fc, $00, $e0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D3: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD3::
	db $03, $00, $07, $00, $0f, $00, $0f, $07, $1f, $0b, $1f, $0b, $0f, $07, $1f, $0f
	db $16, $0f, $2f, $10, $27, $19, $2f, $14, $1f, $06, $0f, $00, $1c, $0f, $1f, $00
	db $e0, $00, $f0, $00, $f8, $80, $fc, $d8, $fc, $58, $f4, $78, $e8, $f0, $f8, $20
	db $f4, $28, $e4, $58, $e4, $98, $f4, $68, $f8, $60, $f8, $00, $9c, $78, $fc, $00
	db $07, $00, $0f, $00, $0f, $07, $0d, $03, $3f, $0f, $ff, $2f, $f5, $6e, $ff, $60
	db $7f, $00, $4f, $37, $2f, $13, $1f, $00, $0c, $03, $0f, $00, $1c, $0f, $1f, $00
	db $e0, $00, $f0, $80, $f0, $c0, $f8, $40, $fc, $58, $fc, $f8, $f4, $78, $f8, $60
	db $f4, $c8, $e4, $98, $e4, $18, $f4, $68, $f8, $60, $f8, $00, $9c, $78, $fc, $00
	db $37, $00, $7f, $31, $7f, $37, $7d, $23, $7f, $0f, $5f, $2f, $5f, $2e, $2f, $10
	db $2f, $10, $1f, $05, $6f, $05, $fe, $63, $ff, $70, $7f, $30, $3f, $00, $00, $00
	db $d8, $00, $fc, $18, $fe, $9c, $fe, $44, $f6, $48, $f2, $ec, $f2, $6c, $e4, $58
	db $e4, $d8, $e8, $90, $78, $80, $f8, $30, $f8, $70, $f0, $60, $e0, $00, $00, $00
	db $37, $00, $7f, $31, $7f, $37, $7d, $23, $7f, $0f, $5f, $2f, $5f, $2e, $2f, $10
	db $2f, $10, $1f, $07, $0f, $03, $0f, $00, $06, $01, $07, $00, $03, $01, $01, $00
	db $d8, $00, $fc, $18, $fe, $9c, $fe, $44, $f6, $48, $f2, $ec, $f2, $6c, $e4, $58
	db $e4, $d8, $e8, $90, $f8, $00, $f8, $00, $7c, $80, $fe, $04, $fe, $dc, $dc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D4: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD4::
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $04, $1e, $01, $3f, $0d
	db $3f, $1d, $3f, $1d, $2e, $1d, $13, $0c, $0f, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $c3, $00, $24, $db, $a5, $db, $e7, $db
	db $ff, $c3, $db, $e7, $db, $e7, $db, $e7, $5a, $e7, $99, $66, $7f, $00, $00, $00
	db $00, $00, $00, $00, $03, $00, $0c, $03, $11, $0f, $30, $0f, $40, $3f, $6e, $3f
	db $6f, $33, $3f, $0b, $57, $2f, $4b, $36, $77, $08, $f7, $6e, $ff, $06, $07, $00
	db $0f, $00, $13, $0f, $60, $1f, $80, $7f, $dd, $7f, $df, $67, $7f, $17, $af, $5f
	db $b7, $4d, $9f, $60, $9f, $7d, $5f, $3b, $39, $07, $40, $3f, $f3, $7c, $fc, $00
	db $d1, $0e, $31, $ce, $19, $e6, $05, $fa, $dd, $fa, $dd, $3a, $da, $64, $d2, $ec
	db $a4, $d8, $e4, $38, $f2, $fc, $f2, $fc, $e6, $f8, $07, $fe, $ff, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $3c, $00, $7a, $3c, $7e, $1c, $7d, $3e, $31, $0e, $11, $0e
	db $00, $00, $00, $00, $03, $00, $0d, $03, $17, $0f, $1c, $0f, $28, $1f, $38, $1f
	db $30, $1f, $30, $1f, $20, $1f, $27, $18, $18, $07, $0f, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $f0, $00, $c8, $f0, $08, $f0, $14, $e8, $14, $e8, $14, $e8
	db $14, $e8, $24, $d8, $48, $b0, $88, $70, $30, $c0, $c0, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D5: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD5::
	db $ff, $7e, $ff, $7e, $81, $7e, $ff, $00, $fc, $7b, $85, $7a, $86, $79, $fc, $03
	db $7c, $3b, $45, $3a, $7d, $02, $7c, $3b, $44, $3b, $7f, $00, $7f, $3e, $7f, $00
	db $ff, $fb, $ff, $fb, $04, $fb, $ff, $00, $00, $ff, $e0, $1f, $d3, $2c, $06, $f9
	db $ff, $00, $52, $ad, $b3, $4c, $ff, $00, $06, $f9, $ff, $00, $ff, $f7, $ff, $00
	db $ff, $df, $ff, $df, $20, $df, $ff, $00, $55, $aa, $00, $ff, $55, $aa, $00, $ff
	db $f9, $06, $df, $20, $2f, $d0, $f9, $06, $00, $ff, $ff, $00, $ff, $ef, $ff, $00
	db $ff, $7e, $ff, $7e, $81, $7e, $ff, $00, $3f, $de, $21, $de, $21, $de, $bf, $40
	db $be, $5c, $22, $dc, $3e, $c0, $be, $5c, $a2, $5c, $fe, $00, $fe, $7c, $fe, $00
	db $ff, $00, $a1, $5e, $a1, $5e, $bf, $40, $bf, $40, $bf, $40, $bf, $40, $ff, $00
	db $df, $7e, $df, $7e, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $7c, $00, $be, $7c, $bf, $7e, $be, $7f, $be, $7f, $be, $7f, $86, $7f, $81, $7e
	db $ff, $01, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $D6: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD6::
	db $c0, $b8, $88, $f8, $98, $f8, $98, $f8, $98, $f8, $98, $f8, $f8, $f8, $98, $f8
	db $98, $f8, $9c, $fc, $98, $f8, $98, $f8, $98, $f8, $98, $f8, $b8, $f8, $d8, $e0
	db $fc, $00, $e4, $18, $ec, $18, $fc, $00, $fc, $00, $e4, $18, $ec, $18, $fc, $00
	db $fc, $00, $e4, $18, $ec, $18, $fc, $00, $fc, $00, $e4, $18, $ec, $18, $1c, $00
	db $c5, $3e, $8e, $7f, $1f, $ff, $1f, $ff, $1f, $ff, $1f, $ff, $3f, $ff, $df, $ff
	db $9f, $7f, $9f, $7f, $1f, $ff, $1f, $ff, $1f, $ff, $19, $ff, $2f, $f1, $7f, $c1
	db $ff, $00, $e1, $1e, $ef, $1e, $ff, $00, $ff, $00, $e1, $1e, $ef, $1e, $ff, $00
	db $ff, $00, $e1, $1e, $ef, $1e, $ff, $00, $ff, $00, $e1, $1e, $6f, $1e, $3f, $00
	db $f3, $0f, $cf, $3f, $9f, $7f, $3f, $ff, $3f, $ff, $3f, $ff, $3f, $ff, $7f, $ff
	db $bf, $ff, $bf, $7f, $bf, $7f, $1f, $ff, $1f, $ff, $20, $ff, $5f, $e0, $bf, $c0
	db $ff, $00, $c0, $3f, $df, $3f, $ff, $00, $ff, $00, $c0, $3f, $df, $3f, $ff, $00
	db $ff, $00, $c0, $3f, $df, $3f, $ff, $00, $ff, $00, $c0, $3f, $df, $3f, $ff, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $D7: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD7::
	db $1f, $00, $3f, $16, $7f, $36, $eb, $76, $db, $66, $fb, $56, $bb, $46, $7b, $06
	db $fb, $66, $fb, $76, $fb, $76, $fb, $56, $eb, $76, $fb, $66, $df, $62, $73, $00
	db $3d, $00, $7f, $2d, $7e, $3f, $7b, $3c, $f7, $7b, $ff, $77, $9f, $71, $6f, $11
	db $fc, $63, $fb, $7c, $fb, $7c, $f6, $59, $fc, $73, $ff, $70, $b8, $60, $70, $00
	db $bc, $00, $fe, $bc, $e7, $7e, $93, $6e, $db, $26, $7b, $86, $4b, $b6, $4b, $b6
	db $8b, $76, $9b, $66, $1b, $e6, $9b, $66, $fb, $06, $9b, $06, $0f, $00, $06, $00
	db $1b, $00, $3f, $1a, $67, $3b, $6d, $33, $ff, $65, $df, $65, $ee, $51, $ef, $50
	db $eb, $55, $e7, $5b, $e7, $5b, $e7, $59, $ef, $53, $f5, $03, $62, $01, $01, $00
	db $ce, $00, $ff, $cc, $f3, $fd, $ee, $f1, $df, $ec, $fd, $de, $7d, $c6, $bd, $46
	db $fb, $8c, $de, $e1, $fc, $f3, $f9, $66, $f9, $c6, $bf, $c0, $70, $80, $e0, $00
	db $f8, $00, $fc, $f8, $8e, $fc, $36, $cc, $76, $8c, $ff, $06, $1b, $e6, $0b, $f6
	db $0b, $f6, $2b, $d6, $2b, $d6, $2b, $d6, $eb, $16, $3b, $06, $1f, $00, $0e, $00
	db $0f, $00, $1f, $0f, $31, $1f, $36, $19, $6f, $30, $6f, $30, $78, $27, $d0, $6f
	db $d0, $6f, $d2, $6d, $d2, $6d, $d2, $6d, $d7, $68, $dc, $60, $78, $00, $30, $00
	db $39, $00, $bf, $19, $e7, $9f, $bb, $c7, $57, $bb, $ff, $3b, $fe, $23, $7d, $a2
	db $7f, $99, $3d, $c3, $1f, $e7, $4f, $b5, $cf, $37, $7d, $03, $0e, $01, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D8: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD8::
	db $37, $00, $6f, $37, $5f, $2f, $3f, $1a, $3f, $12, $7f, $17, $ff, $7f, $bf, $78
	db $5f, $30, $3f, $13, $3f, $1f, $2c, $1f, $17, $0f, $10, $0f, $0c, $03, $03, $00
	db $d8, $00, $ec, $d8, $e4, $d8, $f8, $60, $fc, $38, $fe, $30, $ff, $fe, $fd, $7e
	db $e2, $3c, $ec, $30, $e6, $f8, $c5, $fa, $89, $f6, $02, $fc, $0c, $f0, $f0, $00
	db $37, $00, $6f, $37, $5f, $2f, $3f, $1a, $3f, $12, $3f, $17, $3f, $1f, $3f, $18
	db $7f, $30, $ff, $73, $9f, $7f, $6c, $1f, $17, $0f, $10, $0f, $0c, $03, $03, $00
	db $d8, $00, $ec, $d8, $e4, $d8, $f8, $60, $fc, $38, $fc, $38, $fc, $f8, $fe, $7c
	db $ff, $3e, $f7, $3e, $e9, $f6, $ce, $f0, $98, $e0, $04, $f8, $02, $fc, $fc, $00
	db $1b, $00, $37, $1b, $27, $1b, $1f, $07, $1f, $0f, $7f, $0f, $ff, $7f, $bf, $7f
	db $5f, $3f, $3d, $1e, $2f, $1f, $27, $1f, $10, $0f, $10, $0f, $0c, $03, $03, $00
	db $d8, $00, $ec, $d8, $f4, $e8, $f8, $f0, $f8, $f0, $fe, $f0, $ff, $fe, $fd, $9e
	db $fa, $6c, $fc, $f0, $9c, $f8, $04, $f8, $04, $f8, $08, $f0, $10, $e0, $e0, $00
	db $1b, $00, $37, $1b, $27, $1b, $1f, $07, $1f, $0f, $2f, $1f, $2f, $1f, $7f, $3f
	db $ff, $7f, $8f, $7f, $7f, $0f, $27, $1f, $13, $0f, $10, $0f, $0c, $03, $03, $00
	db $d8, $00, $ec, $d8, $f4, $e8, $f8, $f0, $f8, $f0, $f8, $f0, $fc, $f8, $fe, $fc
	db $ff, $fe, $f9, $fe, $fe, $88, $fc, $70, $cc, $f8, $04, $f8, $08, $f0, $f0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $D9: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesD9::
	db $07, $00, $3c, $03, $48, $37, $59, $27, $77, $0f, $cc, $3f, $99, $7e, $92, $7d
	db $95, $7b, $ca, $37, $b5, $4e, $f5, $4e, $b0, $4f, $c8, $37, $94, $7b, $88, $7f
	db $ff, $00, $7c, $bb, $bb, $c7, $c6, $ff, $3c, $ff, $00, $ff, $f0, $0f, $e8, $f7
	db $f4, $fb, $0a, $fd, $e5, $1e, $f3, $2f, $fe, $31, $7c, $83, $00, $ff, $00, $ff
	db $88, $7f, $88, $7f, $c8, $3f, $a8, $5f, $e8, $5f, $aa, $5d, $cb, $3d, $92, $7d
	db $93, $7c, $c9, $3e, $64, $1f, $52, $2f, $48, $37, $24, $1b, $1f, $00, $00, $00
	db $00, $ff, $7c, $83, $bb, $7c, $ff, $3f, $bf, $47, $bf, $78, $78, $87, $c3, $ff
	db $00, $ff, $8c, $73, $f0, $0f, $00, $ff, $70, $8f, $a8, $77, $ff, $00, $00, $00
	db $07, $00, $3c, $03, $48, $37, $58, $27, $7d, $03, $cf, $39, $8f, $7c, $93, $7c
	db $97, $7b, $cc, $37, $bd, $46, $fd, $46, $b9, $46, $c9, $36, $99, $66, $f8, $07
	db $ff, $00, $7c, $bb, $bb, $c7, $76, $cf, $fc, $cf, $30, $cf, $fc, $03, $fb, $fc
	db $80, $7f, $f8, $07, $fc, $03, $ff, $30, $ff, $48, $ff, $49, $fe, $33, $fe, $03
	db $dc, $3b, $e7, $7c, $c3, $3e, $a1, $5e, $eb, $5d, $af, $59, $fe, $03, $9c, $73
	db $8e, $79, $c7, $3c, $67, $1c, $57, $29, $4c, $33, $24, $1b, $1f, $00, $00, $00
	db $7c, $8f, $f1, $0e, $fb, $65, $9b, $f5, $0b, $fc, $03, $fc, $03, $fc, $13, $ec
	db $10, $ef, $fb, $07, $fc, $f3, $07, $f8, $71, $8e, $a9, $76, $ff, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $DA: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesDA::
	db $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $07, $01, $0f, $03, $1f
	db $07, $1f, $07, $3f, $0f, $3f, $0f, $3f, $1f, $7f, $1f, $7f, $1f, $7f, $1f, $7f
	db $00, $00, $00, $0f, $00, $7f, $0f, $ff, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c7, $ff, $83, $ff, $83, $ff, $83
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $07, $01, $0f
	db $03, $1f, $07, $3f, $0f, $3f, $0f, $7f, $1f, $7f, $1f, $7f, $3f, $ff, $3f, $ff
	db $00, $00, $00, $00, $00, $00, $00, $1f, $00, $ff, $1f, $ff, $7f, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $87, $ff, $03, $ff, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $07, $01, $07
	db $01, $0f, $03, $0f, $03, $0f, $07, $1f, $07, $1f, $07, $1f, $07, $1f, $07, $1f
	db $00, $03, $00, $1f, $03, $7f, $0f, $ff, $3f, $ff, $7f, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f3, $ff, $e1, $ff, $e1, $ff, $e1, $ff, $e1
	db $cf, $f0, $b7, $cf, $5f, $bf, $7f, $bf, $ff, $7f, $ff, $7f, $ff, $43, $e7, $19
	db $7f, $81, $7f, $81, $3f, $c3, $0f, $f0, $00, $ff, $07, $f8, $0f, $f0, $4e, $b1
	db $cf, $f0, $bf, $c3, $67, $99, $7f, $81, $ff, $01, $ff, $43, $ff, $7f, $ff, $7f
	db $7f, $bf, $5f, $bf, $37, $cf, $0f, $f0, $00, $ff, $07, $f8, $0f, $f0, $4e, $b1
;@ path: gfx/sprites/entities
;@ Entity graphics set $DB: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesDB::
	db $ff, $00, $87, $7f, $80, $7f, $80, $7f, $ff, $00, $7f, $00, $40, $3f, $41, $3e
	db $62, $1d, $f3, $6d, $f5, $6b, $96, $6b, $96, $6b, $66, $1b, $46, $3b, $44, $3b
	db $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $df, $3f, $70, $ff
	db $c0, $ff, $80, $ff, $00, $ff, $70, $8f, $bf, $70, $ff, $7f, $ff, $7f, $bf, $7f
	db $64, $1b, $f2, $6d, $f2, $6d, $91, $6e, $90, $6f, $60, $1f, $40, $3f, $40, $3f
	db $40, $3f, $60, $1f, $70, $0f, $58, $27, $4f, $30, $5a, $3c, $24, $18, $18, $00
	db $7f, $bc, $5e, $b9, $37, $c8, $0f, $f0, $00, $ff, $98, $67, $9f, $60, $8f, $70
	db $40, $bf, $20, $df, $00, $ff, $00, $ff, $ff, $00, $5a, $3c, $24, $18, $18, $00
	db $cf, $f0, $b7, $cf, $5f, $bf, $7f, $bf, $bf, $7f, $ff, $7f, $ff, $7c, $bf, $78
	db $7e, $b9, $5f, $b8, $37, $cc, $0f, $f0, $00, $ff, $07, $f8, $0f, $f0, $4e, $b1
	db $cf, $f0, $b7, $cc, $5e, $b9, $7f, $b8, $bf, $78, $ff, $7c, $ff, $7f, $bf, $7f
	db $7f, $bf, $5f, $bf, $37, $cf, $0f, $f0, $00, $ff, $07, $f8, $0f, $f0, $4e, $b1
	db $cf, $f0, $b7, $cf, $5f, $bf, $7f, $87, $cf, $33, $ff, $03, $ff, $03, $ff, $07
	db $7f, $bf, $5f, $bf, $37, $cf, $0f, $f0, $00, $ff, $07, $f8, $0f, $f0, $4e, $b1
	db $f3, $0f, $ed, $f3, $fa, $fd, $fe, $fd, $fd, $fe, $ff, $fe, $ff, $fe, $fd, $fe
	db $fe, $fd, $fa, $fd, $ec, $f3, $f0, $0f, $00, $ff, $e0, $1f, $f0, $0f, $72, $8d
;@ path: gfx/sprites/entities
;@ Entity graphics set $DC: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesDC::
	db $00, $00, $00, $00, $07, $00, $0f, $00, $3f, $00, $7f, $30, $7f, $37, $7f, $3e
	db $3f, $0e, $0b, $07, $1f, $00, $3f, $18, $3c, $1b, $1f, $00, $0f, $07, $0f, $00
	db $00, $00, $00, $00, $e0, $00, $f0, $00, $f8, $c0, $fc, $c8, $fc, $e8, $fc, $d8
	db $f8, $d0, $f8, $e0, $fc, $18, $fc, $18, $38, $c0, $10, $e0, $f8, $00, $f0, $00
	db $00, $00, $00, $00, $07, $00, $0f, $00, $3f, $00, $7f, $30, $7f, $30, $7f, $30
	db $3f, $0c, $1f, $07, $37, $18, $3f, $10, $18, $07, $08, $07, $1f, $00, $0f, $00
	db $00, $00, $00, $00, $e0, $00, $f0, $00, $fc, $00, $fe, $0c, $fe, $0c, $fe, $0c
	db $fc, $30, $f0, $e0, $f8, $00, $fc, $08, $3c, $c8, $f8, $00, $f8, $e0, $f0, $00
	db $18, $00, $38, $10, $3e, $10, $69, $36, $df, $60, $ff, $4e, $ff, $0a, $ff, $4e
	db $ff, $60, $fe, $61, $df, $60, $ff, $4c, $af, $46, $c7, $03, $07, $01, $07, $02
	db $00, $00, $03, $00, $07, $02, $77, $02, $95, $62, $f5, $02, $f7, $00, $ff, $02
	db $1f, $ea, $dd, $22, $d7, $20, $f5, $02, $f5, $62, $e5, $c2, $c5, $02, $c3, $80
	db $07, $03, $03, $00, $1f, $01, $3b, $0d, $5b, $2d, $db, $2c, $d8, $2f, $df, $2f
	db $df, $20, $df, $20, $c0, $3f, $df, $20, $bf, $4f, $bf, $4a, $bf, $4f, $ff, $00
	db $c0, $80, $80, $00, $f0, $00, $b8, $60, $b4, $68, $b6, $68, $36, $e8, $f6, $e8
	db $f6, $08, $f6, $08, $06, $f8, $f6, $08, $fa, $e4, $fa, $a4, $fa, $e4, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $DD: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesDD::
	db $37, $00, $5f, $20, $7e, $00, $7f, $00, $55, $2e, $7f, $0a, $95, $6e, $de, $61
	db $bc, $43, $fe, $11, $3f, $19, $2f, $1f, $17, $0f, $0f, $00, $1b, $0d, $1f, $00
	db $00, $00, $38, $00, $3c, $18, $ce, $3c, $06, $fc, $06, $fc, $1c, $e0, $04, $f8
	db $02, $fc, $01, $fe, $05, $fa, $83, $fc, $c2, $bc, $fe, $00, $d8, $e0, $f0, $00
	db $00, $00, $37, $00, $5f, $20, $7e, $00, $7f, $00, $55, $2e, $7f, $0a, $95, $6e
	db $de, $61, $bc, $43, $fe, $11, $3f, $19, $3f, $1f, $19, $06, $1f, $09, $1f, $00
	db $00, $00, $00, $00, $1c, $00, $2e, $1c, $ce, $30, $11, $ee, $23, $dc, $05, $fa
	db $01, $fe, $01, $fe, $01, $fe, $82, $fc, $a4, $d8, $d8, $20, $d0, $e0, $f0, $00
	db $03, $00, $0f, $02, $1b, $0c, $17, $08, $0f, $04, $1e, $09, $3f, $0c, $4e, $31
	db $87, $79, $96, $69, $77, $0e, $17, $0f, $0b, $07, $0e, $01, $11, $0e, $1f, $00
	db $00, $00, $01, $00, $01, $00, $73, $00, $af, $50, $8f, $74, $5e, $29, $57, $2c
	db $2e, $11, $27, $19, $26, $19, $17, $0e, $17, $0f, $0b, $07, $14, $0b, $1f, $00
	db $01, $00, $03, $00, $05, $02, $09, $06, $08, $07, $10, $0f, $31, $0e, $47, $39
	db $8f, $77, $af, $57, $77, $0b, $17, $0f, $0b, $07, $0e, $01, $11, $0e, $1f, $00
	db $00, $00, $00, $00, $01, $00, $63, $00, $95, $62, $89, $76, $c8, $37, $41, $3e
	db $27, $19, $2f, $17, $2f, $17, $17, $0b, $17, $0f, $0b, $07, $14, $0b, $1f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $DE: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesDE::
	db $38, $00, $78, $30, $f0, $40, $e7, $00, $bf, $67, $ef, $1f, $57, $3e, $5f, $2c
	db $7f, $0c, $7f, $34, $fb, $77, $f4, $5b, $ff, $60, $e2, $5d, $c1, $22, $00, $01
	db $03, $00, $67, $02, $fa, $64, $dc, $20, $fe, $8c, $fb, $d6, $dd, $6a, $fe, $69
	db $d4, $6a, $5c, $e2, $bc, $c2, $63, $9c, $c7, $3a, $fd, $c6, $3a, $dc, $fc, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $0c, $00, $12, $0c, $22, $1c, $22, $1c, $5a, $2c
	db $5b, $2c, $5c, $3b, $be, $59, $bb, $74, $bd, $76, $77, $2c, $5f, $2c, $3f, $0f
	db $1f, $0f, $17, $0f, $0b, $07, $07, $03, $02, $01, $07, $00, $0e, $07, $0f, $00
	db $9c, $00, $f4, $88, $7e, $80, $af, $70, $ff, $50, $ac, $70, $7e, $80, $11, $ee
	db $83, $fc, $85, $7a, $81, $7e, $82, $7c, $c6, $b8, $f9, $06, $fb, $1c, $fe, $00
	db $3c, $00, $7e, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7e, $00, $3c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $3c, $00, $7e, $00, $7e, $00, $7e, $00, $7e, $00, $3c, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $18, $00, $3c, $00, $3c, $00, $18, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $DF: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesDF::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $33, $00, $2d, $13
	db $33, $1e, $44, $3b, $e4, $1b, $86, $7f, $f1, $6e, $7e, $01, $3f, $17, $3f, $00
	db $04, $00, $08, $00, $08, $00, $0c, $00, $06, $00, $02, $00, $e3, $00, $91, $60
	db $8b, $70, $25, $da, $42, $bc, $42, $bc, $46, $b8, $74, $88, $e4, $78, $f8, $00
	db $00, $00, $00, $00, $19, $00, $16, $09, $19, $0f, $22, $1d, $72, $0d, $43, $3f
	db $78, $37, $3f, $00, $1e, $0f, $37, $1e, $3f, $15, $3b, $04, $75, $3a, $7f, $00
	db $00, $00, $00, $00, $c0, $00, $c3, $80, $c6, $00, $44, $80, $24, $c0, $16, $e0
	db $93, $60, $09, $f0, $09, $f0, $cb, $b0, $cf, $b0, $fa, $04, $6c, $f0, $f8, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $E0: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. LoadTileset1D (the ending) copies $6000-$67FF to $8000. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE0::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $04, $0f, $00, $0f, $10
	db $1f, $00, $1f, $00, $1f, $08, $1b, $0e, $1e, $03, $0f, $00, $03, $04, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $20, $70, $80, $f0, $08
	db $58, $e0, $f8, $a0, $58, $e0, $f8, $00, $f0, $08, $f0, $00, $c0, $20, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $04, $0f, $00, $0f, $10
	db $1f, $0c, $1f, $0b, $0f, $02, $17, $08, $10, $0f, $0f, $00, $03, $04, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $20, $70, $80, $f0, $08
	db $a8, $70, $f8, $50, $a8, $f0, $78, $80, $f0, $08, $f0, $00, $c0, $20, $00, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $18, $07, $26, $19, $27, $1a, $4f, $33
	db $5f, $2b, $3f, $0f, $1f, $07, $1f, $0a, $1f, $0d, $1f, $00, $3f, $1b, $3f, $00
	db $00, $00, $00, $00, $00, $00, $c0, $00, $20, $c0, $1c, $e0, $82, $7c, $d2, $2c
	db $fa, $54, $fc, $f0, $ea, $14, $f9, $c6, $cd, $b2, $d5, $2a, $66, $98, $fc, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $00, $00, $00, $00, $02, $02, $05, $02, $05, $02, $05, $02, $05, $02, $05
	db $02, $1d, $1e, $21, $2e, $51, $3e, $41, $3c, $42, $00, $3c, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E1: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE1::
	db $00, $00, $01, $00, $01, $00, $03, $01, $03, $01, $0f, $00, $1e, $01, $1f, $20
	db $3e, $01, $3f, $01, $3e, $11, $37, $1c, $3d, $06, $1f, $00, $07, $08, $00, $00
	db $c0, $00, $e6, $c0, $ef, $c6, $ff, $8e, $df, $6e, $9f, $66, $ff, $0e, $ff, $0e
	db $bf, $c6, $f6, $40, $b0, $c0, $f0, $00, $e0, $10, $e0, $00, $80, $40, $00, $00
	db $00, $00, $00, $00, $01, $00, $01, $00, $03, $01, $0f, $00, $1e, $01, $1f, $20
	db $3f, $18, $3f, $16, $1f, $05, $2e, $11, $21, $1e, $1f, $00, $07, $08, $00, $00
	db $00, $00, $c0, $00, $e6, $c0, $ef, $c6, $ff, $8e, $df, $6e, $df, $26, $ff, $0e
	db $5f, $ee, $ff, $a6, $56, $e0, $f0, $00, $e0, $10, $e0, $00, $80, $40, $00, $00
	db $00, $00, $10, $10, $00, $00, $00, $82, $00, $38, $38, $7c, $5c, $fe, $3e, $7f
	db $7e, $ff, $07, $ff, $03, $07, $01, $03, $41, $43, $01, $13, $00, $01, $00, $01
	db $00, $c0, $00, $60, $00, $71, $00, $33, $00, $37, $00, $36, $00, $16, $00, $14
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $30, $10, $30, $10, $1c, $0c, $0f, $03, $03, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $08, $07, $11, $0f, $13, $0f
	db $0b, $07, $09, $07, $08, $07, $04, $03, $03, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E2: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE2::
	db $15, $00, $1f, $00, $1f, $00, $3f, $07, $7f, $2d, $7f, $28, $5b, $37, $38, $17
	db $3f, $10, $3f, $08, $7f, $27, $77, $28, $33, $0f, $1e, $01, $3d, $1e, $1f, $00
	db $e0, $00, $f8, $00, $fc, $00, $fc, $e0, $fe, $b4, $fe, $b4, $3a, $fc, $3c, $c8
	db $fc, $18, $fa, $34, $f2, $cc, $fa, $34, $fc, $b0, $38, $c0, $fc, $00, $f0, $00
	db $73, $00, $ff, $70, $ff, $75, $ff, $60, $fb, $07, $98, $67, $9f, $60, $4f, $30
	db $4f, $36, $2b, $16, $15, $0b, $1b, $0c, $27, $1f, $78, $07, $f7, $78, $ff, $00
	db $00, $00, $00, $00, $7e, $00, $ff, $00, $ff, $00, $7e, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $e0, $00, $f8, $00, $fc, $a0, $fc, $a0, $7e, $f0, $7e, $94, $fe, $1c, $fa, $3c
	db $fc, $78, $fa, $74, $b9, $c6, $fd, $1a, $be, $d8, $1e, $e0, $ef, $1e, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $05, $03, $09, $07, $10, $0f
	db $10, $0f, $10, $0f, $0c, $03, $03, $00, $03, $01, $03, $01, $01, $00, $00, $00
	db $00, $00, $61, $00, $71, $20, $3f, $10, $1f, $00, $14, $0f, $6f, $1b, $ef, $5b
	db $6f, $1b, $14, $0f, $1f, $00, $3f, $10, $6f, $30, $f3, $41, $c3, $01, $01, $00
	db $80, $00, $c3, $80, $cf, $82, $fe, $0c, $f4, $18, $b8, $c0, $d8, $60, $de, $60
	db $df, $6e, $be, $c0, $f8, $00, $f8, $10, $ec, $18, $9e, $04, $86, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E3: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. Also page $63 of the table at $01:$7FA4 (copied to $8F00 on map $09). 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE3::
	db $07, $00, $e8, $07, $91, $6f, $53, $2f, $21, $1f, $2c, $1f, $2f, $1b, $2f, $19
	db $37, $0d, $57, $2f, $9c, $63, $a5, $43, $cf, $00, $13, $0f, $1f, $00, $00, $00
	db $00, $00, $07, $00, $08, $07, $71, $0f, $93, $6f, $e1, $1f, $2c, $1f, $6f, $1b
	db $af, $59, $b7, $4d, $f7, $0f, $0c, $03, $05, $03, $0f, $00, $13, $0f, $1f, $00
	db $1c, $00, $13, $0c, $6d, $03, $57, $22, $7b, $27, $7b, $2f, $7b, $2e, $7b, $2f
	db $71, $2f, $5c, $23, $5f, $20, $6f, $03, $09, $06, $13, $0c, $1c, $00, $00, $00
	db $f0, $00, $ec, $f0, $ea, $3c, $dd, $7e, $dd, $fe, $c9, $fe, $e1, $7e, $e1, $3e
	db $e1, $be, $e2, $fc, $3e, $c0, $fe, $18, $f2, $0c, $f9, $06, $07, $00, $00, $00
	db $03, $00, $07, $01, $cb, $06, $af, $44, $f7, $4f, $f7, $5f, $f7, $5c, $f7, $5e
	db $e3, $5f, $b9, $47, $be, $41, $df, $06, $09, $06, $09, $06, $05, $02, $03, $00
	db $e0, $00, $d8, $e0, $d4, $78, $ba, $fc, $ba, $fc, $92, $fc, $c2, $fc, $c2, $7c
	db $c2, $7c, $c4, $f8, $3c, $c0, $7c, $b0, $cc, $30, $c8, $30, $50, $20, $60, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $09, $06, $13, $0d, $17, $0b, $17, $0b
	db $17, $09, $19, $06, $11, $0e, $08, $07, $07, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $3c, $00, $5a, $3c, $7e, $3c, $7e, $3c, $5a, $3c, $3c, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E4: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE4::
	db $07, $00, $1e, $01, $3f, $00, $7f, $00, $7f, $20, $ff, $50, $ff, $50, $ff, $20
	db $ff, $00, $bf, $40, $ff, $30, $77, $3e, $7e, $17, $3f, $02, $1f, $00, $07, $00
	db $07, $00, $1e, $01, $3f, $00, $7f, $20, $7f, $10, $ff, $50, $ff, $20, $fe, $07
	db $f7, $1e, $ff, $32, $bf, $50, $5f, $20, $5f, $20, $27, $18, $19, $07, $07, $00
	db $07, $00, $1e, $01, $3f, $00, $7f, $00, $7f, $00, $ff, $01, $ff, $01, $ff, $40
	db $ff, $60, $ff, $58, $ff, $13, $7f, $02, $7f, $00, $3f, $00, $1f, $00, $07, $00
	db $e0, $00, $78, $80, $fc, $00, $fe, $00, $fe, $c0, $ff, $20, $ff, $20, $ff, $c0
	db $ff, $00, $ff, $00, $bf, $40, $fe, $00, $fe, $00, $fc, $00, $f8, $00, $e0, $00
	db $07, $00, $1e, $01, $3f, $00, $7f, $00, $ff, $60, $ff, $50, $ff, $58, $7f, $1c
	db $3f, $02, $5f, $23, $ff, $40, $fc, $43, $7b, $3c, $3f, $00, $1f, $00, $07, $00
	db $e0, $00, $78, $80, $fc, $00, $fe, $60, $fe, $90, $ff, $90, $ff, $60, $ff, $00
	db $ff, $00, $ff, $00, $3f, $c0, $fe, $00, $fe, $00, $fc, $00, $f8, $00, $e0, $00
	db $07, $00, $1e, $01, $3f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $3f, $00, $1f, $00, $07, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $5a, $3c, $7e, $24
	db $7e, $24, $5a, $3c, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E5: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE5::
	db $00, $00, $00, $00, $36, $00, $5e, $20, $7e, $00, $7f, $0e, $7f, $3f, $7f, $1b
	db $df, $6b, $9f, $6f, $bf, $47, $f8, $07, $20, $1f, $18, $07, $37, $18, $3f, $00
	db $00, $00, $00, $00, $00, $00, $38, $00, $7c, $38, $fc, $60, $fe, $dc, $fe, $b8
	db $be, $f4, $fe, $fc, $3a, $fc, $04, $f8, $48, $b0, $b0, $40, $a0, $c0, $e0, $00
	db $00, $00, $36, $00, $5e, $20, $7e, $00, $7f, $0e, $7f, $3f, $7f, $1b, $df, $6b
	db $9f, $6f, $be, $47, $ff, $06, $21, $1e, $11, $0e, $0f, $00, $07, $03, $07, $00
	db $00, $00, $00, $00, $70, $00, $78, $30, $fc, $78, $f4, $f8, $fc, $f8, $d8, $e0
	db $fc, $f8, $fe, $fc, $ee, $f4, $76, $f8, $84, $78, $7c, $80, $f0, $80, $e0, $00
	db $00, $00, $30, $00, $28, $10, $29, $10, $26, $19, $20, $1f, $2a, $15, $4a, $35
	db $c0, $7f, $d8, $67, $41, $3e, $43, $3c, $3e, $01, $10, $0f, $1b, $0d, $1f, $00
	db $00, $00, $60, $00, $a0, $40, $66, $c0, $ef, $c0, $cf, $80, $2b, $c4, $31, $ee
	db $71, $ce, $72, $ec, $f2, $0c, $14, $e8, $08, $f0, $44, $b8, $fc, $98, $fc, $00
	db $00, $00, $60, $00, $a0, $40, $78, $c0, $fc, $c0, $fc, $80, $26, $d8, $32, $ec
	db $72, $cc, $72, $ec, $f4, $08, $14, $e8, $08, $f0, $44, $b8, $fc, $98, $fc, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $c3, $00, $e7, $42, $ff, $66, $ff, $66
	db $7e, $24, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E6: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. LoadTileset1B copies $6600-$667F to $8000. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE6::
	db $07, $00, $18, $07, $26, $19, $27, $1a, $4f, $33, $5f, $2b, $3f, $0f, $1f, $0d
	db $17, $0d, $2b, $17, $2f, $10, $3f, $0d, $1f, $0d, $1d, $02, $17, $0f, $1f, $00
	db $c0, $00, $20, $c0, $1c, $e0, $82, $7c, $d2, $2c, $fa, $54, $fc, $d0, $ea, $f4
	db $b2, $cc, $61, $9e, $d1, $2e, $d1, $ae, $d2, $ac, $8c, $70, $88, $f0, $f8, $00
	db $07, $00, $08, $07, $31, $0e, $43, $3d, $57, $29, $7f, $15, $3f, $17, $5f, $2f
	db $8b, $77, $85, $7b, $87, $78, $4f, $36, $3f, $06, $16, $09, $13, $0f, $1f, $00
	db $03, $00, $04, $03, $39, $07, $40, $3f, $40, $3f, $20, $1f, $30, $0f, $20, $1f
	db $10, $0f, $20, $1f, $20, $1f, $30, $0f, $1c, $03, $23, $1c, $20, $1f, $3f, $00
	db $07, $00, $38, $07, $50, $2f, $41, $3e, $51, $2e, $3f, $10, $3f, $15, $5f, $2d
	db $9f, $67, $9f, $63, $b7, $48, $7c, $17, $3b, $17, $30, $0f, $1f, $0f, $1f, $00
	db $e0, $00, $1c, $e0, $8a, $74, $c2, $bc, $ca, $b4, $fc, $88, $fe, $a8, $f9, $b6
	db $f9, $e6, $f9, $c6, $ee, $10, $7c, $d8, $bc, $d8, $1c, $e0, $08, $f0, $f8, $00
	db $0f, $00, $36, $0f, $60, $3f, $58, $27, $7c, $0b, $1f, $08, $1f, $0a, $3f, $1a
	db $3f, $1f, $1e, $0f, $0f, $00, $07, $03, $07, $03, $07, $00, $08, $07, $0f, $00
	db $80, $00, $60, $80, $10, $e0, $1c, $e0, $04, $f8, $74, $88, $78, $a0, $d8, $60
	db $a4, $d8, $44, $b8, $c2, $3c, $e2, $1c, $bc, $40, $10, $e0, $08, $f0, $f8, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E7: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE7::
	db $00, $00, $00, $00, $07, $00, $0f, $00, $3f, $00, $7f, $30, $7f, $37, $7f, $3e
	db $3f, $0e, $0b, $07, $1f, $00, $3f, $18, $3c, $1b, $1f, $00, $0f, $07, $0f, $00
	db $00, $00, $00, $00, $e0, $00, $f0, $00, $f8, $c0, $fc, $c8, $fc, $e8, $fc, $d8
	db $f8, $d0, $f8, $e0, $fc, $18, $fc, $18, $38, $c0, $10, $e0, $f8, $00, $f0, $00
	db $00, $00, $00, $00, $07, $00, $0f, $00, $3f, $00, $7f, $30, $7f, $30, $7f, $30
	db $3f, $0c, $1f, $07, $37, $18, $3f, $10, $18, $07, $08, $07, $1f, $00, $0f, $00
	db $00, $00, $00, $00, $e0, $00, $f0, $00, $fc, $00, $fe, $0c, $fe, $0c, $fe, $0c
	db $fc, $30, $f0, $e0, $f8, $00, $fc, $08, $3c, $c8, $f8, $00, $f8, $e0, $f0, $00
	db $00, $00, $00, $00, $0f, $00, $1f, $00, $1f, $04, $1f, $04, $0f, $07, $1f, $05
	db $1f, $0d, $3f, $07, $3f, $18, $3f, $16, $1f, $06, $07, $00, $03, $01, $07, $00
	db $00, $00, $00, $00, $c0, $00, $e0, $00, $f0, $00, $f8, $30, $f8, $30, $f8, $f0
	db $d0, $e0, $a0, $c0, $e0, $00, $f0, $00, $10, $e0, $f0, $00, $e0, $c0, $f0, $00
	db $00, $00, $00, $00, $00, $00, $1f, $00, $3f, $00, $3f, $08, $3f, $08, $1f, $0e
	db $3f, $0b, $3f, $1b, $7f, $00, $7f, $38, $3e, $19, $3c, $03, $47, $38, $7f, $00
	db $00, $00, $00, $00, $00, $00, $80, $00, $c0, $00, $e0, $00, $f0, $60, $f0, $60
	db $f0, $e0, $e0, $80, $c0, $00, $f0, $00, $38, $d0, $78, $b0, $f0, $60, $f8, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E8: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE8::
	db $00, $00, $03, $00, $0f, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $3f, $00, $0f, $00
	db $7e, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $07, $00, $0f, $00, $1f, $00, $1f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00
	db $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00
	db $ff, $00, $db, $67, $f8, $07, $df, $60, $df, $60, $db, $67, $98, $67, $ff, $00
	db $ff, $00, $db, $67, $f8, $07, $df, $60, $df, $60, $db, $67, $98, $67, $ff, $00
	db $07, $00, $1f, $00, $3f, $00, $7f, $00, $4f, $30, $f7, $38, $fb, $3c, $ff, $3c
	db $dd, $3e, $ff, $1e, $ef, $1e, $77, $0e, $7d, $02, $3f, $00, $1f, $00, $07, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $07, $00, $0f, $00, $0f, $00
	db $0f, $00, $0f, $00, $07, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $03, $00, $0f, $00, $1f, $00, $1f, $00, $3f, $00, $3f, $00
	db $3f, $00, $3f, $00, $1f, $00, $1f, $00, $0f, $00, $03, $00, $00, $00, $00, $00
	db $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $3f, $00, $1f, $00, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $E9: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesE9::
	db $00, $00, $1c, $00, $3e, $00, $7f, $00, $ff, $00, $cf, $00, $0f, $00, $0f, $00
	db $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00
	db $00, $00, $3e, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $e0, $ff, $f1, $ff, $79, $ff, $19, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $18, $00, $2a, $10, $5d, $32, $77, $3a, $bf, $7b, $bf, $7e
	db $b7, $7e, $a7, $7f, $9b, $67, $a6, $41, $a1, $40, $c0, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $02, $00, $05, $02, $07, $02, $0b, $07, $0b, $06, $0f, $06
	db $17, $0f, $15, $0f, $14, $0f, $13, $0c, $14, $08, $14, $08, $14, $08, $18, $00
	db $03, $00, $04, $03, $05, $03, $05, $03, $02, $01, $72, $01, $8c, $73, $b1, $7f
	db $b1, $7f, $8c, $73, $72, $01, $02, $01, $05, $03, $05, $03, $04, $03, $03, $00
	db $00, $00, $38, $00, $44, $38, $5a, $3c, $5a, $3c, $21, $1e, $18, $07, $05, $03
	db $05, $03, $18, $07, $21, $1e, $5a, $3c, $5a, $3c, $44, $38, $38, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $1f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $EA: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesEA::
	db $00, $00, $00, $00, $03, $00, $0f, $00, $1f, $00, $1f, $00, $3f, $00, $3f, $00
	db $3f, $00, $3f, $00, $3f, $00, $3f, $00, $1f, $00, $1f, $00, $0f, $00, $0f, $00
	db $00, $00, $00, $00, $f0, $00, $fc, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $cf, $30, $f7, $38, $fb, $3c, $ff, $3c
	db $dd, $3e, $ff, $1e, $ef, $1e, $f7, $0e, $fd, $02, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $f0, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $07, $00, $0f, $00, $1f, $00, $1f, $00
	db $3f, $00, $3f, $00, $3f, $00, $7f, $00, $7f, $00, $7f, $00, $7f, $00, $7f, $00
	db $00, $00, $1f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $cf, $30, $f7, $38, $fb, $3c, $ff, $3c
	db $dd, $3e, $ff, $1e, $ef, $1e, $f7, $0e, $fd, $02, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $1f, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $03, $00, $07, $00, $1f, $00
	db $3f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $0f, $00, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $cf, $30, $f7, $38, $fb, $3c, $ff, $3c
;@ path: gfx/sprites/entities
;@ Entity graphics set $EB: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesEB::
	db $dd, $3e, $ff, $1e, $ef, $1e, $f7, $0e, $fd, $02, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $3f, $00, $07, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $07, $00, $0f, $00
	db $0f, $00, $1f, $00, $1f, $00, $1f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00
	db $00, $00, $00, $00, $0f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $03, $00, $03, $00, $07, $00, $07, $00, $07, $00, $0f, $00, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $1f, $00, $7f, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $03, $00, $03, $00, $03, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $1f, $00
	db $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $EC: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesEC::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00
	db $03, $00, $03, $00, $07, $00, $07, $00, $07, $00, $07, $00, $07, $00, $07, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $19, $00, $1f, $00, $3f, $00, $bf, $00
	db $ff, $00, $fb, $1c, $fd, $1e, $ef, $1e, $f7, $0e, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $1f, $00, $0c, $00, $de, $00, $fe, $00, $78, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $19, $00, $1f, $00, $3f, $00, $bf, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7c, $00, $1c, $00
	db $00, $00, $0c, $00, $0c, $00, $c6, $00, $f2, $00, $1a, $00, $0f, $00, $ff, $00
	db $cf, $00, $1f, $00, $33, $00, $33, $00, $03, $00, $03, $00, $01, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $c0, $00, $c0, $00, $40, $00, $c0, $00, $80, $00
	db $00, $00, $00, $00, $07, $00, $ff, $00, $ff, $00, $ff, $00, $1f, $00, $0f, $00
	db $0f, $00, $0f, $00, $0f, $00, $0f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $00
	db $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $1e, $00, $0c, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $ED: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesED::
	db $e0, $40, $e0, $40, $fc, $60, $7e, $3c, $3f, $0e, $0f, $06, $07, $02, $07, $02
	db $3f, $06, $7f, $3e, $fe, $70, $f0, $60, $e0, $40, $e0, $40, $e0, $40, $e0, $40
	db $00, $00, $00, $00, $00, $00, $00, $00, $33, $00, $7f, $00, $7f, $00, $ff, $00
	db $ff, $00, $f7, $0c, $eb, $1c, $6f, $18, $6f, $18, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $c0, $00, $c0, $00
	db $f0, $00, $f8, $00, $f8, $00, $f8, $00, $fe, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $7f, $00, $1f, $00, $1f, $00, $7f, $00, $78, $00
	db $f8, $00, $f8, $00, $fc, $00, $fc, $00, $fc, $00, $fe, $00, $fe, $00, $fe, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fc, $00, $00, $00, $00, $00
	db $00, $00, $1f, $00, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $3f, $00, $3f, $00
	db $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $3f, $00, $1e, $00, $00, $00
	db $00, $00, $00, $00, $03, $00, $0c, $03, $10, $0f, $11, $0f, $23, $1f, $27, $1f
	db $27, $1f, $23, $1f, $11, $0f, $10, $0f, $0c, $03, $03, $00, $00, $00, $00, $00
	db $07, $00, $18, $07, $20, $1f, $40, $3f, $43, $3f, $87, $7f, $8f, $7f, $8f, $7f
	db $8f, $7f, $8f, $7f, $87, $7f, $43, $3f, $40, $3f, $20, $1f, $18, $07, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $EE: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesEE::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $01, $00, $00, $00, $00, $00, $01, $00, $01, $00, $07, $00, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $03, $00, $cf, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $0f, $00, $07, $00, $01, $00, $01, $00, $03, $00, $03, $00, $01, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $dd, $3e, $be, $7f, $ff, $7f, $ff, $7f
	db $be, $7f, $5d, $3e, $3e, $00, $78, $00, $f0, $00, $f0, $00, $f0, $00, $60, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $71, $00, $fa, $01, $fd, $03, $7f, $03, $0f, $03, $07, $03, $05, $03, $02, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $33, $00, $7f, $00
	db $ff, $00, $df, $e0, $ef, $f0, $ff, $f0, $ff, $f0, $ff, $f0, $ef, $f0, $df, $e0
	db $0e, $01, $05, $03, $3f, $03, $7f, $03, $ff, $03, $f5, $03, $63, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $df, $e0, $ef, $f0, $ff, $f0, $ff, $f0, $ed, $fe, $fe, $ff, $3f, $ff, $bf, $7f
	db $7e, $3f, $5d, $3e, $3f, $00, $1d, $00, $3c, $00, $7c, $00, $78, $00, $30, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $EF: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesEF::
	db $e7, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $e7, $00
	db $00, $00, $73, $00, $7f, $00, $7f, $00, $3f, $00, $3f, $00, $7f, $00, $7f, $00
	db $7f, $00, $7f, $00, $3f, $00, $3f, $00, $7f, $00, $7f, $00, $73, $00, $00, $00
	db $03, $00, $07, $00, $07, $00, $0f, $00, $1f, $00, $7f, $00, $ff, $08, $ff, $0c
	db $ff, $0e, $ff, $06, $7f, $02, $1f, $00, $0f, $00, $07, $00, $07, $00, $03, $00
	db $00, $00, $38, $00, $7f, $00, $7f, $00, $7f, $00, $3f, $00, $3f, $08, $3f, $0c
	db $3f, $0e, $3f, $06, $3f, $02, $7f, $00, $7f, $00, $7f, $00, $38, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $00
	db $03, $00, $01, $00, $00, $00, $00, $00, $01, $00, $01, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00
	db $67, $00, $ff, $00, $ff, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $f1, $0e, $e0, $1f, $e0, $1f, $20, $1f, $11, $0e
	db $1f, $00, $3c, $00, $38, $00, $38, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $F0: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF0::
	db $c3, $00, $f3, $00, $fb, $00, $fb, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $7f, $00, $3f, $00, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $18, $00, $38, $00, $30, $00, $70, $00, $e3, $00, $ff, $00, $fe, $00
	db $f8, $00, $fc, $00, $ff, $00, $e7, $00, $c0, $00, $00, $00, $00, $00, $00, $00
	db $1e, $00, $3f, $00, $7f, $00, $7f, $00, $7e, $00, $fc, $00, $fc, $00, $fe, $00
	db $fe, $00, $ff, $00, $7f, $00, $7f, $00, $3f, $00, $3f, $00, $1f, $00, $0f, $00
	db $01, $00, $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $7f, $00, $1f, $00, $07, $00, $00, $00, $00, $00
	db $07, $00, $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $7f, $00, $7f, $00
	db $3f, $00, $1f, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $1f, $00, $1d, $00
	db $07, $00, $07, $00, $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $00
	db $ff, $00, $7f, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $1f, $00, $1d, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $e0, $00, $c0, $00
	db $3c, $00, $7e, $00, $ff, $00, $e7, $00, $f0, $00, $f0, $00, $f8, $00, $f8, $00
	db $fe, $c0, $ff, $c0, $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $F1: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF1::
	db $01, $00, $09, $00, $1b, $00, $1f, $00, $3f, $00, $3f, $00, $3b, $00, $33, $00
	db $31, $00, $11, $00, $01, $00, $03, $00, $03, $00, $01, $00, $01, $00, $01, $00
	db $00, $00, $00, $00, $0f, $00, $3f, $00, $7e, $00, $1c, $00, $3f, $00, $ff, $00
	db $ff, $00, $3f, $00, $1c, $00, $7e, $00, $3f, $00, $0f, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $80, $00, $c0, $00, $00, $00, $00, $00, $18, $00, $ff, $00
	db $ff, $00, $18, $00, $00, $00, $00, $00, $c0, $00, $80, $00, $00, $00, $00, $00
	db $07, $00, $03, $00, $33, $00, $3f, $00, $1f, $00, $9f, $00, $df, $00, $ff, $00
	db $f7, $00, $70, $00, $78, $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $00, $e0, $00, $f0, $00, $f0, $00, $30, $00, $90, $00, $80, $00, $80, $00
	db $c0, $00, $f0, $00, $70, $00, $78, $00, $1c, $00, $0e, $00, $07, $00, $03, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
	db $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
	db $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $c0, $00, $e0, $00, $70, $00, $38, $00, $1c, $00, $0c, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $F2: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF2::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $39, $00
	db $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $3c, $00, $7e, $00, $7e, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $00, $7c, $00
	db $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $7e, $00, $7e, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $38, $00, $7e, $00, $7f, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $7e, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00
	db $7f, $00, $3f, $00, $3f, $00, $1f, $00, $0f, $00, $03, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $F3: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF3::
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $78, $07
	db $7c, $03, $3f, $00, $3f, $00, $1f, $00, $07, $00, $01, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $66, $99
	db $ff, $81, $7e, $81, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $01, $7d, $03, $7b, $07
	db $79, $07, $3c, $03, $3e, $01, $1f, $00, $07, $00, $01, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $bd, $7e, $ff, $ff, $bd, $c3, $e7, $99
	db $ff, $81, $7e, $81, $7e, $81, $bd, $42, $ff, $00, $ff, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $fe, $01, $fd, $03, $ff, $03, $fb, $07, $7b, $07, $7b, $07
	db $79, $07, $3c, $03, $3c, $03, $1e, $01, $0f, $00, $03, $00, $00, $00, $00, $00
	db $ff, $00, $81, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bd, $c3, $e7, $99
	db $ff, $81, $ff, $81, $7e, $81, $3c, $c3, $80, $7f, $ff, $00, $00, $00, $00, $00
	db $c1, $00, $e3, $00, $7f, $00, $3f, $00, $3c, $03, $38, $07, $71, $0f, $f3, $0f
	db $f3, $0f, $71, $0f, $38, $07, $3c, $03, $3f, $00, $7f, $00, $e3, $00, $c1, $00
	db $ff, $00, $fd, $f6, $0f, $f0, $fd, $06, $fd, $06, $fd, $f6, $09, $f6, $ff, $00
	db $ff, $00, $fd, $f6, $0f, $f0, $fd, $06, $fd, $06, $fd, $f6, $09, $f6, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $F4: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF4::
	db $3f, $00, $7f, $3b, $bf, $7b, $af, $70, $be, $61, $be, $61, $bf, $60, $bb, $67
	db $f7, $2f, $bb, $4c, $bf, $68, $bf, $68, $bf, $68, $57, $2c, $2b, $17, $1f, $00
	db $3f, $00, $7f, $3b, $bf, $7b, $af, $70, $bf, $60, $bb, $67, $b7, $6f, $bb, $6c
	db $ff, $28, $bf, $48, $bf, $68, $b7, $6c, $bb, $67, $5f, $20, $20, $1f, $1f, $00
	db $19, $00, $16, $09, $13, $0d, $15, $0f, $6f, $1f, $ac, $5f, $c9, $7e, $dd, $7a
	db $d7, $78, $b7, $78, $b7, $78, $5b, $3c, $4c, $3f, $27, $1f, $18, $07, $07, $00
	db $00, $00, $01, $00, $02, $01, $03, $01, $05, $03, $15, $03, $2b, $17, $27, $1f
	db $36, $1f, $3e, $1d, $2f, $1c, $1d, $0e, $16, $0f, $09, $07, $06, $01, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $01, $05, $03, $07, $03
	db $0a, $07, $0b, $06, $0a, $07, $05, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $06, $00, $09, $06, $16, $0d, $2d, $1f, $2e, $1f, $59, $3e, $5b, $3c
	db $ac, $73, $af, $70, $af, $70, $b7, $78, $5c, $3f, $47, $3f, $30, $0f, $0f, $00
	db $37, $00, $cb, $36, $3d, $ee, $de, $fc, $ff, $fc, $19, $fe, $8d, $7e, $2a, $dc
	db $d6, $38, $ba, $74, $ba, $7c, $74, $f8, $f4, $f8, $c8, $f0, $30, $c0, $c0, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $F5: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. LoadTileset15 copies $7500-$753F to $8000 and $7500-$76FF to $8D00 (the ending). 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF5::
	db $03, $00, $07, $00, $07, $03, $1f, $04, $3d, $13, $39, $17, $3a, $15, $2c, $13
	db $1c, $03, $14, $0b, $34, $1b, $3b, $14, $17, $0f, $18, $07, $1f, $00, $0f, $00
	db $80, $00, $c0, $00, $e0, $c0, $f8, $20, $bc, $c8, $9c, $e8, $9c, $e8, $94, $e8
	db $38, $c0, $54, $a8, $94, $68, $2c, $f0, $c8, $f0, $38, $c0, $fc, $30, $f8, $00
	db $07, $00, $0b, $04, $1f, $00, $3f, $11, $3f, $15, $6f, $1f, $ff, $6e, $ff, $66
	db $6b, $16, $25, $1b, $1b, $04, $38, $07, $3f, $18, $3f, $1c, $1f, $0c, $0c, $00
	db $00, $00, $01, $00, $1f, $00, $3d, $1a, $3b, $17, $3f, $06, $2f, $14, $2f, $14
	db $3b, $07, $65, $1b, $e3, $5c, $f1, $6e, $fb, $65, $7f, $23, $37, $03, $03, $00
	db $f0, $00, $f8, $00, $fc, $08, $fe, $8c, $fe, $c4, $ff, $80, $fd, $ee, $fa, $fc
	db $fe, $e0, $df, $e6, $ef, $16, $8e, $70, $f0, $80, $e0, $80, $c0, $00, $80, $00
	db $00, $00, $3b, $00, $7d, $32, $fb, $75, $ff, $62, $ef, $14, $6f, $14, $6b, $17
	db $65, $1b, $66, $19, $f9, $66, $fd, $7a, $7f, $38, $38, $00, $00, $00, $00, $00
	db $c0, $00, $ec, $c0, $fe, $00, $fe, $e0, $ff, $40, $ff, $70, $ff, $f2, $ff, $c6
	db $ff, $ec, $fd, $ca, $f9, $36, $fe, $d8, $fc, $c0, $c8, $30, $30, $00, $00, $00
	db $03, $00, $07, $03, $0f, $00, $7a, $07, $f4, $6f, $f9, $76, $7b, $35, $3f, $03
	db $17, $0b, $17, $0a, $1f, $02, $3d, $1b, $3f, $19, $1f, $00, $02, $01, $01, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $F6: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
EntityTilesF6::
	db $c0, $00, $e0, $c0, $e0, $00, $bc, $40, $fe, $0c, $fe, $cc, $fc, $80, $fe, $08
	db $fd, $1a, $f1, $3e, $b5, $6e, $a5, $5e, $ca, $3c, $82, $7c, $0c, $f0, $f0, $00
	db $0c, $00, $1f, $0c, $3f, $1c, $3c, $1b, $19, $07, $2f, $10, $4b, $37, $77, $0c
	db $ff, $68, $fb, $57, $7e, $11, $30, $0f, $11, $0f, $08, $07, $04, $03, $03, $00
	db $03, $00, $07, $00, $07, $03, $1f, $04, $3d, $13, $39, $17, $3a, $15, $2c, $13
	db $1c, $03, $2c, $13, $6c, $33, $73, $2c, $37, $0f, $18, $07, $3f, $18, $3f, $00
	db $80, $00, $c0, $00, $e0, $c0, $f8, $20, $bc, $c8, $9c, $e8, $9c, $e8, $94, $e8
	db $38, $c0, $54, $a8, $96, $6c, $0e, $f4, $ec, $f0, $18, $e0, $fc, $18, $fc, $00
	db $07, $00, $0b, $07, $1b, $04, $3f, $13, $3f, $14, $3f, $10, $27, $18, $1f, $0d
	db $17, $0d, $2b, $17, $6f, $30, $78, $27, $37, $0f, $1c, $03, $3b, $1c, $3f, $00
	db $c0, $00, $20, $c0, $18, $e0, $dc, $e8, $fc, $28, $fc, $08, $e4, $18, $f8, $b0
	db $e8, $b0, $d4, $e8, $f6, $0c, $1e, $e4, $ec, $f0, $38, $c0, $dc, $38, $fc, $00
	db $1b, $00, $3d, $1b, $3f, $18, $3f, $00, $2f, $11, $2f, $15, $2f, $17, $2b, $16
	db $2b, $16, $15, $0b, $1b, $04, $18, $0f, $27, $1f, $78, $27, $f7, $78, $7f, $00
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
	db $00, $ff, $00, $ff, $22, $ff, $14, $ff, $08, $ff, $14, $ff, $22, $ff, $00, $ff
;@ path: gfx/tiles/indoor
;@ Page $77: copied to $8F00 ($100 bytes) on the indoor maps whose entry in the table at $01:$7FA4 is $77 (LoadTileset06). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles8F77::
	db $03, $03, $07, $04, $0e, $09, $1d, $1b, $2d, $3b, $2f, $39, $4a, $7c, $45, $7e
	db $63, $7f, $63, $7c, $51, $7e, $5c, $6f, $3f, $23, $2f, $30, $1b, $1c, $07, $07
	db $e0, $e0, $f0, $10, $38, $c8, $dc, $ec, $da, $ee, $fa, $ce, $29, $1f, $d1, $3f
	db $e1, $ff, $63, $1f, $c5, $3f, $1d, $fb, $fe, $e2, $fa, $06, $ec, $1c, $f0, $f0
	db $30, $30, $2b, $2b, $26, $24, $34, $24, $3c, $20, $3e, $38, $67, $66, $f3, $a2
	db $fb, $b2, $ff, $ae, $fe, $a3, $ff, $93, $f7, $98, $ff, $8f, $80, $80, $ff, $ff
	db $0c, $0c, $d4, $d4, $64, $24, $2c, $24, $3c, $04, $7c, $1c, $e6, $66, $cf, $45
	db $df, $4d, $ff, $75, $7f, $c5, $ff, $c9, $ef, $19, $ff, $f1, $01, $01, $ff, $ff
	db $ff, $ff, $f6, $81, $df, $a7, $df, $a4, $97, $ec, $cf, $b4, $df, $a4, $dc, $a7
	db $d6, $a1, $d9, $a7, $91, $ef, $d1, $af, $ff, $bf, $ff, $88, $88, $ff, $ff, $ff
	db $ff, $ff, $e1, $0f, $f5, $ef, $d5, $2f, $c7, $3f, $dd, $2f, $d5, $2f, $15, $ef
	db $e5, $0f, $15, $ef, $0f, $f7, $0d, $f7, $fd, $ff, $ff, $21, $21, $ff, $ff, $ff
	db $ff, $7c, $f3, $83, $d7, $a7, $d6, $a7, $dd, $6e, $f5, $36, $d5, $67, $d7, $a7
	db $d7, $a2, $c2, $af, $c5, $6f, $c9, $7f, $fb, $bf, $af, $9e, $8f, $f9, $ff, $70
	db $ff, $fe, $01, $0f, $e5, $ef, $67, $ee, $ff, $7e, $ef, $af, $e5, $2f, $e7, $ee
	db $07, $0c, $1f, $ec, $1f, $fe, $1d, $f7, $fd, $ff, $ff, $22, $23, $fe, $ff, $fc
;@ path: gfx/tiles/indoor
;@ Page $78: copied to $8F00 ($100 bytes) on the indoor maps whose entry in the table at $01:$7FA4 is $78 (LoadTileset06). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles8F78::
	db $03, $03, $07, $04, $0e, $09, $1d, $1b, $2d, $3b, $2f, $39, $4a, $7c, $45, $7e
	db $63, $7f, $63, $7c, $51, $7e, $5c, $6f, $3f, $23, $2f, $30, $1b, $1c, $07, $07
	db $e0, $e0, $f0, $10, $38, $c8, $dc, $ec, $da, $ee, $fa, $ce, $29, $1f, $d1, $3f
	db $e1, $ff, $63, $1f, $c5, $3f, $1d, $fb, $fe, $e2, $fa, $06, $ec, $1c, $f0, $f0
	db $f1, $f1, $ba, $cb, $5d, $66, $2d, $32, $31, $3e, $48, $4f, $4d, $4f, $4f, $4e
	db $a6, $e4, $fe, $b8, $ae, $b8, $a6, $bc, $92, $9e, $cf, $8e, $63, $41, $3f, $3f
	db $8f, $8f, $5d, $d3, $ba, $66, $b4, $4c, $ac, $5c, $12, $f2, $b2, $f2, $f2, $72
	db $65, $27, $7f, $1d, $75, $3d, $65, $3d, $49, $79, $f3, $71, $c6, $82, $fc, $fc
	db $ff, $ff, $e0, $9f, $90, $ef, $8f, $f0, $88, $f7, $8b, $f4, $8b, $f4, $8b, $f4
	db $8b, $f4, $88, $f7, $8f, $f0, $8f, $ff, $9f, $ff, $bf, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $01, $ff, $07, $ff, $ff, $0f, $1f, $ef, $df, $2f, $df, $2f, $df, $2f
	db $df, $2f, $1f, $ef, $ff, $0f, $ff, $f7, $ff, $fb, $ff, $fd, $ff, $fd, $ff, $ff
	db $7f, $ff, $e1, $9f, $90, $ef, $8f, $f0, $88, $f7, $97, $fc, $f7, $e3, $ea, $d6
	db $cb, $b6, $89, $f7, $8e, $f2, $8e, $ff, $9e, $ff, $be, $ff, $ff, $ff, $7f, $ff
	db $fe, $ff, $c1, $bf, $c7, $bf, $3f, $8f, $9f, $ef, $9f, $af, $9f, $bf, $e3, $ff
	db $0c, $2f, $1f, $ef, $ff, $0f, $ff, $f7, $ff, $fb, $ff, $fd, $7f, $fd, $7e, $ff
;@ path: gfx/tiles/indoor
;@ Page $79: copied to $8F00 ($100 bytes) on the indoor maps whose entry in the table at $01:$7FA4 is $79 (LoadTileset06). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles8F79::
	db $03, $03, $07, $04, $0e, $09, $1d, $1b, $2d, $3b, $2f, $39, $4a, $7c, $45, $7e
	db $63, $7f, $63, $7c, $51, $7e, $5c, $6f, $3f, $23, $2f, $30, $1b, $1c, $07, $07
	db $e0, $e0, $f0, $10, $38, $c8, $dc, $ec, $da, $ee, $fa, $ce, $29, $1f, $d1, $3f
	db $e1, $ff, $63, $1f, $c5, $3f, $1d, $fb, $fe, $e2, $fa, $06, $ec, $1c, $f0, $f0
	db $07, $07, $3a, $3c, $4e, $48, $77, $58, $5f, $73, $2c, $34, $69, $79, $ad, $b9
	db $fa, $bc, $ef, $f7, $af, $b0, $96, $98, $7b, $7c, $2c, $27, $5b, $47, $7f, $7f
	db $e0, $e0, $5c, $3c, $72, $12, $fe, $12, $fa, $ce, $34, $2c, $96, $9e, $b5, $9d
	db $5f, $3d, $f7, $ef, $f5, $0d, $69, $19, $df, $3f, $36, $e6, $da, $e2, $fe, $fe
	db $ff, $ff, $e0, $9f, $90, $ef, $8f, $f0, $88, $f7, $8b, $f4, $8b, $f4, $8b, $f4
	db $8b, $f4, $88, $f7, $8f, $f0, $8f, $ff, $9f, $ff, $bf, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $01, $ff, $07, $ff, $ff, $0f, $1f, $ef, $df, $2f, $df, $2f, $df, $2f
	db $df, $2f, $1f, $ef, $ff, $0f, $ff, $f7, $ff, $fb, $ff, $fd, $ff, $fd, $ff, $ff
	db $7f, $ff, $e1, $9f, $90, $ef, $8f, $f0, $88, $f7, $97, $fc, $f7, $e3, $ea, $d6
	db $cb, $b6, $89, $f7, $8e, $f2, $8e, $ff, $9e, $ff, $be, $ff, $ff, $ff, $7f, $ff
	db $fe, $ff, $c1, $bf, $c7, $bf, $3f, $8f, $9f, $ef, $9f, $af, $9f, $bf, $e3, $ff
	db $0c, $2f, $1f, $ef, $ff, $0f, $ff, $f7, $ff, $fb, $ff, $fd, $7f, $fd, $7e, $ff
;@ path: gfx/tiles/indoor
;@ Page $7A: copied to $8F00 ($100 bytes) on the indoor maps whose entry in the table at $01:$7FA4 is $7A (LoadTileset06). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles8F7A::
	db $00, $00, $03, $03, $0f, $0c, $1f, $10, $3f, $26, $3f, $2e, $7f, $4c, $7f, $40
	db $5f, $65, $3f, $29, $3f, $20, $3f, $30, $7f, $4d, $6f, $5a, $3f, $3e, $03, $03
	db $00, $00, $c0, $c0, $f0, $30, $e8, $18, $f4, $cc, $fc, $e4, $fa, $e6, $fa, $66
	db $fa, $06, $c6, $3e, $8c, $7c, $b8, $78, $a0, $e0, $c0, $40, $40, $c0, $80, $80
	db $07, $07, $3a, $3c, $4e, $48, $77, $58, $5f, $73, $2c, $34, $69, $79, $ad, $b9
	db $fa, $bc, $ef, $f7, $af, $b0, $96, $98, $7b, $7c, $2c, $27, $5b, $47, $7f, $7f
	db $e0, $e0, $5c, $3c, $72, $12, $fe, $12, $fa, $ce, $34, $2c, $96, $9e, $b5, $9d
	db $5f, $3d, $f7, $ef, $f5, $0d, $69, $19, $df, $3f, $36, $e6, $da, $e2, $fe, $fe
	db $1f, $1f, $25, $3e, $4f, $77, $fb, $ec, $97, $f8, $b7, $d8, $b7, $d8, $b3, $dc
	db $b1, $fe, $d8, $ef, $9f, $e7, $8f, $f1, $81, $ff, $41, $7f, $21, $3f, $1f, $1f
	db $f8, $f8, $c4, $3c, $f2, $ee, $d9, $37, $ef, $1f, $ed, $1b, $ed, $1b, $cd, $3b
	db $8d, $7b, $19, $ff, $fd, $e7, $f3, $0f, $01, $ff, $02, $fe, $84, $fc, $f8, $f8
	db $19, $19, $26, $3f, $4f, $77, $fb, $ed, $97, $fa, $b7, $dc, $bf, $da, $f7, $d9
	db $f3, $3c, $d8, $6f, $9f, $e7, $8f, $f1, $81, $ff, $41, $7f, $23, $3e, $1e, $1c
	db $f8, $f8, $c4, $3c, $f2, $ee, $d9, $37, $ef, $9f, $ed, $5b, $ff, $7b, $ee, $9c
	db $ef, $9a, $99, $ff, $fd, $e7, $f3, $0f, $01, $ff, $02, $fe, $84, $fc, $f8, $78
;@ path: gfx/tiles/indoor
;@ Page $7B: copied to $8F00 ($100 bytes) on the indoor maps whose entry in the table at $01:$7FA4 is $7B (LoadTileset06). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles8F7B::
	db $03, $03, $0f, $0c, $1f, $10, $1c, $13, $3b, $27, $7f, $67, $7f, $67, $7f, $53
	db $77, $58, $5e, $6c, $5f, $63, $57, $68, $22, $3c, $23, $3c, $19, $1e, $07, $07
	db $c0, $c0, $f0, $30, $f8, $08, $38, $c8, $dc, $e4, $fe, $e6, $fe, $e6, $fe, $ca
	db $ee, $1a, $7a, $36, $fa, $c6, $ea, $16, $44, $3c, $c4, $3c, $98, $78, $e0, $e0
	db $00, $00, $1e, $1e, $3f, $21, $79, $46, $74, $4b, $37, $68, $35, $6b, $77, $48
	db $6c, $53, $61, $5e, $7f, $61, $5e, $7f, $40, $7f, $61, $3f, $3f, $1e, $00, $00
	db $00, $00, $78, $78, $fc, $84, $ce, $32, $36, $ca, $f6, $0a, $ae, $d6, $ec, $16
	db $36, $ca, $ce, $32, $fe, $c6, $3a, $fe, $02, $fe, $c6, $fc, $7c, $38, $00, $00
	db $7f, $7f, $ff, $80, $bf, $d0, $ff, $80, $80, $ff, $ff, $80, $bf, $d0, $ff, $80
	db $80, $ff, $ff, $80, $bf, $d0, $ff, $80, $ff, $ff, $92, $ff, $92, $ff, $7f, $7f
	db $fe, $fe, $ff, $01, $fd, $0b, $ff, $01, $01, $ff, $ff, $01, $fd, $0b, $ff, $01
	db $01, $ff, $ff, $01, $fd, $0b, $ff, $01, $ff, $ff, $49, $ff, $49, $ff, $fe, $fe
	db $ff, $ff, $80, $80, $80, $80, $80, $80, $80, $80, $ff, $ff, $80, $80, $ff, $bf
	db $ff, $ff, $01, $01, $01, $01, $01, $01, $01, $01, $ff, $ff, $01, $01, $ff, $fd
	db $ff, $a0, $ff, $a1, $fe, $a0, $ff, $bf, $ff, $a0, $ff, $a1, $fe, $a0, $ff, $bf
	db $ff, $05, $ff, $85, $7f, $05, $ff, $fd, $ff, $05, $ff, $85, $7f, $05, $ff, $fd
;@ path: gfx/tiles/indoor
;@ Page $7C: copied to $8F00 ($100 bytes) on the indoor maps whose entry in the table at $01:$7FA4 is $7C (LoadTileset06). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles8F7C::
	db $03, $03, $07, $04, $0e, $09, $1d, $1b, $2d, $3b, $2f, $39, $4a, $7c, $45, $7e
	db $63, $7f, $63, $7c, $51, $7e, $5c, $6f, $3f, $23, $2f, $30, $1b, $1c, $07, $07
	db $e0, $e0, $f0, $10, $38, $c8, $dc, $ec, $da, $ee, $fa, $ce, $29, $1f, $d1, $3f
	db $e1, $ff, $63, $1f, $c5, $3f, $1d, $fb, $fe, $e2, $fa, $06, $ec, $1c, $f0, $f0
	db $38, $38, $27, $27, $1e, $14, $0f, $0b, $3f, $3b, $5e, $4a, $7b, $4d, $ff, $fe
	db $83, $82, $ff, $bb, $fe, $ba, $fe, $bb, $ff, $93, $ff, $c7, $ff, $b8, $ff, $ff
	db $0e, $0e, $f2, $f2, $5c, $34, $f8, $68, $fe, $ee, $bb, $a9, $ef, $d9, $c9, $bf
	db $df, $bf, $fb, $f9, $5f, $39, $3f, $ff, $e5, $c7, $fd, $ff, $fd, $01, $ff, $ff
	db $7f, $7f, $ff, $80, $bf, $d0, $ff, $80, $80, $ff, $ff, $80, $bf, $d0, $ff, $80
	db $80, $ff, $ff, $80, $bf, $d0, $ff, $80, $ff, $ff, $92, $ff, $92, $ff, $7f, $7f
	db $fe, $fe, $ff, $01, $fd, $0b, $ff, $01, $01, $ff, $ff, $01, $fd, $0b, $ff, $01
	db $01, $ff, $ff, $01, $fd, $0b, $ff, $01, $ff, $ff, $49, $ff, $49, $ff, $fe, $fe
	db $ff, $ff, $80, $80, $80, $80, $80, $80, $80, $80, $ff, $ff, $80, $80, $ff, $bf
	db $ff, $ff, $01, $01, $01, $01, $01, $01, $01, $01, $ff, $ff, $01, $01, $ff, $fd
	db $ff, $bf, $ff, $a7, $fd, $a5, $fd, $a5, $fd, $a5, $ff, $bf, $ff, $80, $ff, $bf
	db $ff, $e5, $ff, $e5, $3f, $e5, $3f, $e5, $3f, $e5, $ff, $fd, $ff, $01, $ff, $fd
;@ path: gfx/tiles/indoor
;@ Tiles of the dungeons at $8C00: LoadTileset06 copies $7D00-$7FFF there on maps below $0A (the other indoor maps take WorldTiles8C00). 48 tiles.
;@ asset: tiles bpp=2 length=$300
DungeonTiles8C00::
	db $00, $00, $67, $67, $ff, $99, $ff, $81, $ff, $81, $ff, $a5, $ff, $81, $ff, $a9
	db $ff, $81, $fb, $95, $ff, $81, $ff, $a5, $ff, $81, $ff, $99, $e7, $e7, $00, $00
	db $00, $00, $18, $18, $24, $24, $24, $24, $3c, $3c, $7e, $42, $ff, $a1, $ff, $b1
	db $f7, $99, $f3, $8d, $e7, $c3, $bd, $ff, $91, $ef, $52, $6e, $3c, $3c, $00, $00
	db $00, $00, $3e, $3e, $41, $41, $ff, $bf, $ff, $c1, $ff, $81, $ff, $bd, $c3, $81
	db $ff, $81, $ff, $e7, $99, $81, $fe, $82, $7c, $44, $38, $38, $00, $00, $00, $00
	db $00, $00, $c3, $c3, $e7, $a5, $ff, $bd, $e7, $a5, $df, $c3, $7e, $42, $7e, $7e
	db $1c, $14, $1c, $14, $3f, $2f, $3f, $29, $3f, $2b, $3f, $29, $3f, $3f, $00, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f8, $fa, $fa, $f8, $f8, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fa, $fa, $fa, $fa, $ff, $ff
	db $00, $00, $00, $00, $7c, $7c, $fe, $82, $fe, $ba, $fe, $ba, $fe, $82, $7c, $7c
	db $38, $28, $38, $28, $3e, $2e, $3e, $2a, $3e, $2e, $3e, $2a, $3e, $3e, $00, $00
	db $00, $00, $00, $00, $fe, $fe, $fe, $82, $fe, $fe, $00, $00, $00, $00, $00, $00
	db $00, $00, $6c, $00, $92, $00, $82, $00, $82, $00, $44, $00, $28, $00, $10, $00
	db $00, $00, $6c, $60, $f2, $90, $c2, $b0, $82, $f0, $44, $70, $28, $30, $10, $10
	db $00, $00, $0f, $0f, $11, $11, $25, $21, $41, $4f, $42, $7e, $44, $7c, $78, $78
	db $00, $ff, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $ff
	db $00, $e7, $00, $81, $00, $81, $00, $00, $00, $00, $00, $81, $00, $81, $00, $e7
	db $00, $ff, $00, $81, $00, $81, $00, $80, $00, $80, $00, $81, $00, $81, $00, $ff
	db $00, $ff, $00, $81, $00, $81, $00, $01, $00, $01, $00, $81, $00, $81, $00, $ff
	db $00, $ff, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $e7
	db $00, $e7, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $ff
	db $00, $e7, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $e7
	db $00, $ff, $00, $81, $00, $81, $00, $00, $00, $00, $00, $81, $00, $81, $00, $ff
	db $00, $ff, $00, $81, $00, $81, $00, $80, $00, $80, $00, $81, $00, $81, $00, $e7
	db $00, $ff, $00, $81, $00, $81, $00, $01, $00, $01, $00, $81, $00, $81, $00, $e7
	db $00, $e7, $00, $81, $00, $81, $00, $80, $00, $80, $00, $81, $00, $81, $00, $ff
	db $00, $e7, $00, $81, $00, $81, $00, $01, $00, $01, $00, $81, $00, $81, $00, $ff
	db $00, $e7, $00, $81, $00, $81, $00, $80, $00, $80, $00, $81, $00, $81, $00, $e7
	db $00, $e7, $00, $81, $00, $81, $00, $01, $00, $01, $00, $81, $00, $81, $00, $e7
	db $00, $ff, $00, $81, $00, $81, $00, $00, $00, $00, $00, $81, $00, $81, $00, $e7
	db $00, $e7, $00, $81, $00, $81, $00, $00, $00, $00, $00, $81, $00, $81, $00, $ff
	db $00, $00, $00, $00, $00, $00, $00, $07, $04, $08, $0b, $10, $07, $10, $07, $10
	db $00, $00, $00, $00, $00, $00, $00, $e0, $20, $10, $d0, $08, $e0, $08, $e0, $08
	db $07, $10, $07, $10, $0b, $10, $04, $08, $00, $07, $00, $00, $00, $00, $00, $00
	db $e0, $08, $e0, $08, $d0, $08, $20, $10, $00, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
	db $ff, $ff, $81, $81, $bd, $bd, $bd, $bd, $81, $81, $ff, $99, $ff, $81, $ff, $ff
	db $00, $00, $00, $00, $4e, $4e, $48, $48, $4e, $4e, $48, $48, $48, $48, $00, $00
	db $00, $00, $00, $00, $ee, $ee, $28, $28, $ee, $ee, $88, $88, $e8, $e8, $00, $00
	db $00, $00, $00, $00, $ee, $ee, $28, $28, $ee, $ee, $28, $28, $e8, $e8, $00, $00
	db $00, $00, $00, $00, $ae, $ae, $a8, $a8, $ae, $ae, $e8, $e8, $28, $28, $00, $00
	db $00, $00, $00, $00, $70, $70, $50, $50, $7a, $7a, $48, $48, $78, $78, $00, $00
	db $ff, $ff, $81, $81, $81, $81, $ff, $81, $99, $e7, $c3, $bd, $ff, $81, $ff, $ff
	db $e7, $ff, $bd, $bd, $81, $81, $a5, $a5, $a5, $a5, $c3, $c3, $db, $db, $7e, $ff
	db $00, $ff, $00, $ff, $3c, $c3, $3c, $c3, $3c, $c3, $3c, $c3, $00, $ff, $00, $ff
