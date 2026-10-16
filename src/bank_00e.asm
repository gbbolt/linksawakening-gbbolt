; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $00e", ROMX[$4000], BANK[$e]

;@ path: gfx/sprites/entities
;@ Entity graphics set $80: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles80::
	db $02, $00, $07, $02, $0f, $06, $0a, $07, $05, $02, $03, $01, $03, $01, $07, $00
	db $07, $02, $0f, $05, $0b, $04, $0f, $02, $07, $02, $07, $00, $05, $03, $02, $01
	db $00, $00, $00, $00, $3c, $00, $ff, $00, $fd, $8e, $fe, $df, $fe, $57, $fd, $0e
	db $ff, $30, $ff, $fd, $ff, $02, $ff, $06, $ff, $06, $ff, $f1, $fe, $ff, $77, $f8
	db $40, $00, $e0, $40, $f0, $60, $d0, $e0, $a0, $40, $c0, $00, $e0, $00, $f0, $20
	db $d0, $60, $e0, $00, $e0, $80, $e0, $80, $c0, $80, $40, $80, $80, $00, $00, $00
	db $00, $00, $01, $00, $03, $00, $07, $00, $0f, $00, $17, $08, $27, $18, $2f, $10
	db $27, $1c, $23, $1c, $17, $08, $0f, $00, $04, $03, $07, $00, $0f, $05, $0f, $00
	db $7e, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $af, $70, $8f, $70, $ff, $00, $00, $ff, $9e, $61, $ca, $b1, $fb, $00
	db $00, $00, $80, $00, $f8, $00, $c4, $38, $c2, $3c, $e2, $1c, $d2, $6c, $d2, $2c
	db $82, $fc, $06, $f8, $8e, $70, $fc, $00, $08, $f0, $3c, $c0, $7e, $b4, $fe, $00
	db $70, $00, $98, $70, $89, $70, $9f, $60, $8f, $70, $4f, $30, $47, $38, $27, $18
	db $1f, $00, $0f, $00, $0f, $00, $0f, $00, $04, $03, $07, $00, $0f, $05, $0f, $00
	db $0e, $00, $9d, $0e, $f5, $0e, $e9, $16, $e7, $18, $e2, $1c, $f2, $0c, $fc, $00
	db $fe, $00, $fe, $00, $fe, $00, $fc, $00, $08, $f0, $3c, $c0, $7e, $b4, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $81: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles81::
	db $0c, $00, $1e, $0c, $3e, $0c, $3f, $14, $3e, $11, $3f, $18, $2f, $1c, $1f, $0c
	db $3f, $04, $5f, $20, $5f, $20, $e7, $18, $f9, $87, $ff, $80, $7f, $70, $1f, $19
	db $01, $00, $63, $01, $73, $21, $7b, $20, $7f, $31, $7f, $31, $5f, $31, $2f, $11
	db $3e, $01, $df, $20, $df, $a0, $e7, $98, $f9, $07, $ff, $c0, $7f, $60, $3f, $36
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $0e, $04, $3e, $04
	db $3f, $14, $3e, $11, $3f, $18, $6f, $1c, $f7, $6c, $fb, $e4, $ff, $d0, $7f, $78
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $0e, $00, $3f, $2e, $3f, $2d, $7f, $31, $7f, $36, $7f, $4d, $3f, $39, $0f, $0e
	db $00, $00, $38, $00, $7c, $38, $fc, $70, $fe, $74, $fe, $74, $fe, $74, $ba, $6c
	db $57, $38, $2f, $12, $1f, $02, $35, $0a, $76, $2d, $f3, $6f, $f8, $47, $ff, $00
	db $1c, $00, $3e, $1c, $7e, $38, $7f, $3a, $7f, $3a, $7f, $3a, $5d, $36, $2b, $1c
	db $2f, $12, $1f, $02, $15, $0a, $36, $0d, $73, $2f, $78, $37, $7f, $20, $7f, $00
	db $00, $00, $61, $00, $71, $20, $3f, $10, $1f, $00, $14, $0f, $6f, $1b, $ef, $5b
	db $6f, $1b, $14, $0f, $1f, $00, $3f, $10, $6f, $30, $f3, $41, $c3, $01, $01, $00
	db $80, $00, $c3, $80, $cf, $82, $fe, $0c, $f4, $18, $b8, $c0, $d8, $60, $de, $60
	db $df, $6e, $be, $c0, $f8, $00, $f8, $10, $ec, $18, $9e, $04, $86, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $82: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles82::
	db $e7, $00, $3c, $03, $3e, $1d, $fe, $15, $be, $1d, $3c, $03, $3f, $18, $3f, $01
	db $77, $38, $82, $7d, $ab, $54, $7e, $01, $20, $1f, $23, $1c, $1f, $00, $07, $00
	db $dc, $00, $30, $c0, $1e, $e0, $ca, $30, $88, $70, $3c, $c0, $ee, $1c, $c1, $be
	db $d5, $2a, $7e, $80, $c4, $38, $04, $f8, $08, $f0, $84, $78, $c4, $38, $fc, $00
	db $73, $00, $1e, $01, $1f, $0e, $7f, $0a, $5f, $0e, $3e, $01, $77, $38, $83, $7c
	db $ab, $54, $7e, $01, $23, $1c, $20, $1f, $10, $0f, $21, $1e, $23, $1c, $3f, $00
	db $ee, $00, $18, $e0, $0f, $f0, $65, $98, $44, $b8, $1c, $e0, $fc, $08, $fc, $d8
	db $fc, $00, $2e, $dc, $c1, $3e, $55, $aa, $3e, $c0, $84, $78, $f8, $00, $e0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e7, $00, $38, $07, $20, $1f
	db $3c, $03, $fe, $1d, $be, $15, $3e, $05, $75, $3a, $83, $7c, $ab, $54, $7c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $9c, $00, $70, $80, $1e, $e0
	db $0a, $f0, $c8, $30, $88, $70, $38, $c0, $dc, $38, $82, $7c, $aa, $54, $7c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $14, $00, $6a, $14, $aa, $54, $c2, $3c, $96, $68, $69, $00, $00, $00
	db $0f, $00, $1f, $0f, $3f, $1f, $30, $1f, $27, $18, $2f, $13, $2f, $10, $6f, $16
	db $ef, $50, $ef, $55, $ef, $50, $e0, $5f, $ff, $40, $ff, $7f, $98, $67, $ff, $98
;@ path: gfx/sprites/entities
;@ Entity graphics set $83: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles83::
	db $73, $00, $ff, $73, $7f, $3f, $3f, $07, $1f, $0b, $3f, $08, $7f, $27, $ff, $6f
	db $ff, $6d, $9f, $67, $7f, $00, $3b, $07, $3f, $00, $3f, $1c, $7f, $2c, $7e, $00
	db $cc, $00, $fe, $cc, $ff, $fe, $df, $e0, $b8, $d0, $fc, $10, $ee, $b4, $ff, $c6
	db $df, $62, $ff, $ce, $fd, $0e, $b2, $cc, $fc, $00, $a4, $58, $fc, $00, $00, $00
	db $03, $00, $7f, $03, $ff, $7f, $5f, $2f, $3f, $00, $17, $0f, $27, $18, $7f, $00
	db $ff, $40, $ff, $40, $a7, $58, $70, $0f, $3f, $00, $27, $18, $3f, $00, $00, $00
	db $c0, $00, $ec, $c0, $fe, $ec, $ff, $fe, $ee, $10, $dc, $e0, $cc, $30, $fe, $04
	db $fb, $06, $fd, $02, $ce, $30, $1c, $e0, $fc, $00, $fc, $18, $fe, $3c, $7e, $00
	db $03, $00, $07, $03, $6f, $07, $ff, $64, $ff, $71, $ff, $5b, $bf, $7c, $7f, $0f
	db $5e, $3f, $37, $08, $0f, $07, $0f, $07, $0a, $07, $07, $00, $03, $01, $07, $00
	db $dc, $00, $fe, $dc, $ff, $fe, $7f, $d8, $dc, $60, $de, $68, $be, $d0, $7f, $80
	db $ff, $70, $fd, $fa, $fd, $7a, $f7, $f8, $8f, $70, $fc, $00, $86, $f8, $fe, $00
	db $00, $00, $03, $00, $07, $03, $6f, $07, $ff, $64, $ff, $71, $ff, $5b, $bf, $7c
	db $7f, $0f, $5f, $3c, $37, $0b, $1f, $03, $1d, $03, $0f, $00, $1c, $0f, $1f, $00
	db $00, $00, $cf, $00, $ff, $ce, $fe, $fc, $7c, $d8, $dc, $60, $de, $68, $be, $d0
	db $7f, $80, $ff, $70, $fd, $ba, $f5, $fa, $4f, $b0, $f9, $06, $79, $9e, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $84: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles84::
	db $0f, $00, $3f, $01, $7f, $03, $73, $0f, $fe, $01, $ff, $2e, $7f, $36, $7f, $3d
	db $3f, $03, $7f, $0c, $ff, $47, $e7, $58, $60, $1f, $1e, $01, $1f, $0c, $1f, $00
	db $f0, $00, $fc, $80, $fe, $c0, $ce, $f0, $7f, $80, $ff, $74, $fe, $6c, $fe, $bc
	db $fe, $c0, $fc, $38, $fc, $e0, $fe, $0c, $1e, $ec, $1c, $e0, $f0, $00, $f0, $00
	db $07, $00, $1f, $00, $3f, $00, $7f, $00, $7f, $00, $ff, $40, $ff, $40, $f3, $5c
	db $78, $1f, $1f, $0f, $3f, $00, $70, $2f, $70, $2f, $38, $07, $0f, $00, $3f, $00
	db $e0, $00, $f8, $00, $fc, $00, $fe, $00, $fe, $00, $ff, $02, $ff, $02, $cf, $3a
	db $1e, $f8, $fe, $f0, $fe, $04, $0e, $f4, $0c, $f0, $f8, $00, $f8, $70, $fc, $00
	db $07, $00, $0f, $02, $0f, $07, $3f, $04, $3f, $13, $3f, $13, $3f, $0a, $3f, $1b
	db $7f, $3c, $7f, $07, $1f, $0f, $1f, $00, $05, $02, $05, $02, $03, $01, $07, $00
	db $f0, $00, $fc, $00, $fe, $c0, $ff, $40, $ff, $4c, $ff, $3e, $ff, $7e, $fe, $70
	db $fc, $f8, $f8, $f0, $f0, $00, $e8, $d0, $e8, $d0, $f8, $00, $f8, $e0, $f8, $00
	db $00, $00, $07, $00, $0f, $02, $0f, $07, $3f, $04, $3f, $13, $3f, $13, $3f, $0a
	db $3f, $1b, $7f, $3c, $7f, $07, $1f, $0e, $0f, $01, $0f, $01, $1f, $0e, $1f, $00
	db $00, $00, $f0, $00, $fc, $00, $fe, $c0, $ff, $40, $ff, $4c, $ff, $3e, $ff, $7e
	db $fe, $70, $fc, $f8, $f8, $f0, $f0, $00, $d8, $a0, $fc, $88, $fc, $38, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $85: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles85::
	db $03, $00, $04, $03, $09, $07, $11, $0f, $11, $0e, $23, $1c, $26, $19, $65, $1b
	db $af, $51, $bf, $46, $9f, $6f, $4b, $37, $3f, $07, $27, $1b, $67, $1d, $7f, $00
	db $c0, $00, $20, $c0, $90, $e0, $88, $f0, $88, $70, $c4, $38, $66, $98, $a5, $da
	db $f5, $8a, $f9, $66, $fa, $f4, $dc, $e0, $f4, $e8, $e2, $dc, $f2, $bc, $fe, $00
	db $03, $00, $05, $03, $09, $07, $11, $0f, $10, $0f, $28, $17, $28, $17, $24, $1b
	db $50, $2f, $88, $77, $8c, $7b, $9f, $6c, $57, $2f, $30, $0f, $60, $1f, $7f, $00
	db $c0, $00, $a0, $c0, $90, $e0, $08, $f0, $08, $f0, $14, $e8, $34, $c8, $4a, $b4
	db $11, $ee, $29, $d6, $59, $b6, $fa, $74, $ec, $f0, $04, $f8, $02, $fc, $fe, $00
	db $7e, $00, $ff, $7e, $e0, $3f, $e0, $1f, $70, $0f, $70, $0f, $78, $27, $f8, $67
	db $ff, $18, $f8, $77, $f8, $77, $fc, $73, $7b, $34, $78, $27, $38, $07, $1f, $00
	db $00, $00, $80, $00, $40, $80, $20, $c0, $10, $e0, $70, $80, $08, $f0, $c8, $30
	db $24, $d8, $14, $e8, $1c, $f0, $78, $b0, $88, $70, $08, $f0, $04, $f8, $fc, $00
	db $00, $00, $7e, $00, $ff, $7e, $e0, $3f, $e0, $1f, $70, $0f, $70, $0f, $78, $27
	db $f9, $66, $fe, $11, $f0, $6f, $f0, $6f, $f8, $77, $7f, $30, $70, $2f, $3f, $00
	db $00, $00, $00, $00, $80, $00, $40, $80, $20, $c0, $10, $e0, $70, $80, $08, $f0
	db $c8, $30, $24, $d8, $14, $e8, $1c, $f0, $b8, $70, $04, $f8, $02, $fc, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $86: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles86::
	db $73, $00, $6f, $32, $3f, $17, $1f, $05, $0f, $00, $1f, $04, $3f, $0f, $5f, $2c
	db $ff, $6b, $fb, $67, $99, $67, $7f, $00, $3b, $07, $4f, $30, $f3, $7c, $ff, $00
	db $cf, $00, $f7, $ce, $fe, $e4, $fc, $60, $f8, $00, $dc, $e0, $ea, $f4, $ff, $76
	db $ff, $b6, $a9, $d6, $3e, $c0, $fc, $00, $de, $e0, $f2, $0c, $cf, $3e, $ff, $00
	db $73, $00, $5f, $20, $2f, $10, $1f, $00, $3f, $00, $7f, $20, $ff, $60, $df, $60
	db $bf, $44, $7f, $06, $7b, $07, $75, $0b, $23, $1c, $58, $27, $c7, $78, $ff, $00
	db $ef, $00, $fd, $02, $fa, $04, $fc, $00, $f8, $00, $fc, $00, $fe, $04, $ff, $06
	db $fb, $06, $fd, $02, $fe, $00, $bc, $40, $0c, $f0, $1a, $e4, $e3, $1e, $ff, $00
	db $0f, $00, $1f, $0c, $1f, $04, $ff, $04, $ff, $38, $ff, $7c, $fd, $3e, $fd, $5e
	db $bb, $6c, $5f, $2b, $3f, $03, $25, $1b, $3f, $00, $1f, $01, $0e, $07, $0f, $00
	db $70, $00, $f0, $60, $e0, $c0, $f0, $00, $f8, $00, $f8, $00, $fc, $00, $5c, $e0
	db $fe, $e0, $ff, $e2, $df, $e2, $b9, $c6, $e2, $1c, $3c, $c0, $08, $f0, $f8, $00
	db $1f, $00, $3f, $16, $3f, $0b, $7f, $03, $ff, $4c, $ff, $7e, $fe, $5f, $fe, $2f
	db $ff, $76, $7b, $34, $3f, $01, $23, $1d, $3e, $01, $1f, $00, $0e, $07, $0f, $00
	db $78, $00, $f8, $30, $f0, $60, $f0, $00, $f8, $00, $f8, $00, $fc, $00, $ac, $70
	db $fe, $70, $ff, $72, $ff, $f2, $e9, $f6, $d2, $ec, $fc, $00, $08, $f0, $f8, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $87: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles87::
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $00, $01, $00, $03, $01, $e3, $01, $f7, $60, $ff, $74, $7d, $2b, $78, $27
	db $f3, $6c, $f7, $69, $77, $28, $f7, $68, $f3, $8c, $f8, $e7, $77, $78, $0f, $0f
	db $00, $00, $07, $07, $1f, $1c, $3f, $31, $7f, $67, $7f, $6e, $ff, $cc, $ff, $cd
	db $ff, $67, $ff, $73, $ff, $b8, $ff, $9f, $7f, $47, $3f, $30, $0f, $0f, $00, $00
	db $01, $00, $03, $01, $e3, $01, $f7, $60, $ff, $70, $7f, $2c, $7f, $2e, $ff, $6b
	db $ff, $68, $79, $27, $f3, $6c, $f4, $4b, $f1, $8e, $ff, $f1, $3f, $3f, $07, $07
	db $03, $00, $3c, $03, $79, $37, $db, $75, $bb, $54, $f9, $46, $ac, $43, $e7, $40
	db $a7, $42, $e7, $42, $a2, $40, $e0, $40, $a0, $40, $e0, $40, $90, $60, $70, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $00, $7b, $30, $dc, $73
	db $b9, $57, $eb, $55, $ab, $54, $e9, $56, $bc, $43, $e7, $40, $97, $62, $73, $00
	db $00, $00, $3f, $00, $7f, $2b, $ff, $ab, $d4, $ab, $ff, $80, $ff, $ab, $ff, $ab
	db $d4, $ab, $ff, $80, $ff, $ab, $ff, $ab, $d4, $ab, $d4, $ab, $bf, $c0, $7f, $7f
	db $00, $00, $3f, $3f, $7f, $40, $ff, $ab, $ff, $ab, $d4, $ab, $ff, $c0, $ff, $ab
	db $ff, $ab, $d4, $ab, $ff, $c0, $ff, $ab, $ff, $ab, $d4, $ab, $ff, $c0, $7f, $7f
;@ path: gfx/sprites/entities
;@ Entity graphics set $88: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles88::
	db $03, $00, $07, $03, $0f, $07, $3f, $0f, $7f, $2b, $6f, $3d, $7f, $3f, $3f, $1b
	db $2f, $1c, $17, $0f, $2f, $10, $2f, $17, $1f, $06, $1f, $00, $3f, $1c, $3f, $00
	db $c0, $00, $e0, $c0, $f0, $e0, $fe, $f0, $ff, $b6, $f7, $7e, $fd, $fe, $fe, $b8
	db $f4, $78, $e8, $f0, $f8, $00, $f4, $68, $f4, $68, $f8, $c0, $fc, $38, $fc, $00
	db $03, $00, $07, $03, $0f, $07, $3f, $0f, $7f, $37, $77, $3f, $5f, $3f, $3f, $0f
	db $5e, $2f, $4f, $33, $43, $3c, $20, $1f, $1f, $0f, $1f, $00, $3f, $1c, $3f, $00
	db $c0, $00, $e0, $c0, $f0, $e0, $fc, $f0, $fe, $f4, $fe, $fc, $fa, $fc, $fc, $f8
	db $38, $f0, $fc, $c0, $c2, $3c, $02, $fc, $fc, $f8, $f8, $00, $fc, $38, $fc, $00
	db $03, $00, $07, $03, $0f, $07, $1f, $0f, $1f, $0b, $3f, $17, $3f, $1f, $3f, $1b
	db $3f, $07, $1f, $0f, $1f, $00, $3f, $1a, $3f, $16, $1f, $0e, $0f, $01, $0f, $00
	db $c0, $00, $f0, $c0, $f8, $f0, $fc, $c0, $fc, $b8, $bc, $f8, $fc, $f8, $f8, $e0
	db $f0, $e0, $f0, $00, $10, $e0, $10, $e0, $20, $c0, $e0, $00, $f0, $e0, $f0, $00
	db $03, $00, $07, $03, $1f, $07, $1f, $0f, $3f, $16, $3f, $15, $3f, $1f, $3f, $1e
	db $1f, $01, $1f, $0f, $3f, $00, $7e, $2d, $7e, $2d, $7f, $34, $3f, $01, $0f, $00
	db $c0, $00, $f0, $c0, $f8, $f0, $fc, $e0, $fe, $dc, $de, $fc, $fe, $fc, $fc, $f0
	db $f8, $f0, $f0, $80, $90, $60, $10, $e0, $20, $c0, $e0, $00, $f0, $e0, $f0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $89: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles89::
	db $03, $00, $07, $03, $07, $00, $ff, $03, $ff, $7a, $ff, $02, $ff, $7b, $ff, $40
	db $e0, $40, $e0, $40, $e0, $40, $e0, $40, $e0, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $07, $03, $07, $00, $0f, $03, $1f, $0a, $3f, $1a, $7f, $33, $ff, $68
	db $f8, $50, $f0, $20, $f0, $40, $78, $20, $3c, $10, $1c, $08, $08, $00, $00, $00
	db $00, $00, $00, $00, $ff, $00, $ff, $7e, $ff, $7e, $81, $7e, $bd, $42, $a5, $5a
	db $85, $7a, $9d, $62, $99, $66, $81, $7e, $99, $66, $81, $7e, $ff, $00, $00, $00
	db $ff, $00, $ff, $7f, $ff, $00, $ff, $6b, $ff, $5d, $ff, $5d, $ff, $6b, $ff, $00
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $ff, $00, $ff, $fe, $ff, $00, $ff, $c6, $ff, $82, $ff, $82, $ff, $c6, $ff, $00
	db $40, $80, $40, $80, $40, $80, $40, $80, $40, $80, $40, $80, $40, $80, $40, $80
	db $78, $00, $6c, $00, $6c, $00, $7c, $00, $66, $00, $66, $00, $7e, $00, $00, $00
	db $00, $00, $08, $00, $7c, $00, $7e, $00, $7e, $00, $7c, $00, $08, $00, $00, $00
	db $3c, $00, $66, $00, $66, $00, $7e, $00, $66, $00, $66, $00, $66, $00, $00, $00
	db $00, $00, $3c, $00, $3c, $00, $3c, $00, $7e, $00, $3c, $00, $18, $00, $00, $00
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $8A: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles8A::
	db $00, $00, $00, $00, $00, $00, $00, $00, $30, $00, $78, $30, $7d, $38, $5f, $3d
	db $4f, $3f, $2f, $1f, $27, $1b, $17, $0b, $0f, $01, $0f, $07, $1f, $0f, $1f, $0f
	db $00, $00, $00, $00, $03, $00, $1f, $03, $7f, $1f, $ff, $7f, $ff, $f8, $f8, $f7
	db $f1, $ef, $e1, $de, $e3, $dc, $a3, $dc, $1f, $e3, $ff, $ff, $ff, $ff, $ff, $ff
	db $1f, $0f, $1f, $0f, $1f, $0f, $17, $0f, $17, $0f, $13, $0f, $0b, $07, $09, $07
	db $09, $07, $04, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $3f, $ff, $0f, $ff, $00, $ff, $80, $ff, $c0, $f1, $ce, $e2, $dd, $e2, $dd
	db $e2, $dd, $e2, $dd, $70, $ef, $33, $ef, $88, $77, $67, $18, $18, $07, $07, $00
	db $ff, $fc, $ff, $f0, $ff, $00, $ff, $00, $ff, $01, $0f, $f7, $1f, $ef, $1f, $ef
	db $1f, $ef, $1e, $ef, $1f, $ef, $3f, $df, $7f, $bf, $80, $7f, $01, $fe, $fe, $00
	db $f8, $f0, $f8, $f0, $fb, $f0, $ef, $f2, $ef, $f6, $cf, $f6, $dd, $ee, $9d, $ee
	db $39, $de, $7a, $bc, $f2, $fc, $e4, $f8, $08, $f0, $30, $c0, $c0, $00, $00, $00
	db $ff, $7f, $ff, $1f, $ff, $80, $f1, $ce, $e2, $dd, $e2, $dd, $f0, $ef, $f3, $ef
	db $f8, $f7, $ff, $f8, $7f, $ff, $3f, $ff, $87, $7f, $60, $1f, $18, $07, $07, $00
	db $ff, $fe, $ff, $f8, $ff, $01, $1f, $e7, $0f, $f7, $0f, $f7, $1f, $ef, $1f, $ef
	db $3f, $df, $fe, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $01, $fe, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $8B: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles8B::
	db $0f, $00, $10, $0f, $1c, $03, $3e, $1d, $7f, $3e, $7f, $36, $7f, $36, $7f, $1c
	db $9c, $60, $98, $70, $b8, $70, $b8, $70, $b8, $70, $7c, $38, $3e, $1c, $1e, $00
	db $3e, $00, $7f, $3e, $e3, $7e, $dd, $62, $e3, $40, $c1, $00, $01, $00, $01, $00
	db $c1, $00, $e3, $40, $ff, $63, $bf, $7f, $5e, $3f, $21, $1e, $1e, $00, $00, $00
	db $70, $00, $f8, $70, $fc, $98, $fa, $f4, $71, $8e, $f9, $76, $fd, $fa, $fd, $9a
	db $f5, $fa, $69, $f6, $f1, $0e, $43, $bc, $86, $78, $fc, $00, $00, $00, $00, $00
	db $01, $00, $0f, $01, $37, $0b, $47, $3a, $5f, $3a, $bf, $79, $b9, $70, $f0, $60
	db $f0, $60, $f0, $60, $e0, $40, $60, $00, $03, $00, $0f, $03, $0f, $07, $07, $00
	db $f8, $00, $e4, $d8, $f2, $ec, $f1, $6e, $fd, $e2, $ff, $dc, $ff, $3e, $7f, $36
	db $7f, $26, $7e, $1c, $3e, $00, $72, $3c, $f4, $78, $e4, $f8, $98, $e0, $e0, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $5a, $3c, $a5, $7e, $a5, $7e
	db $99, $7e, $81, $7e, $42, $3c, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $13, $0c, $2d, $1e, $3f, $1a
	db $3f, $1a, $2d, $1e, $33, $0c, $1f, $00, $07, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $1f, $00, $3f, $00, $3f, $00
	db $3f, $00, $3f, $00, $3f, $00, $1f, $00, $0f, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $8C: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles8C::
	db $00, $00, $00, $00, $00, $00, $06, $00, $0f, $06, $1f, $0a, $1f, $08, $1f, $01
	db $07, $01, $1f, $00, $3f, $1c, $7f, $20, $f0, $40, $e0, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $7e, $3c, $ff, $02, $63, $80
	db $e0, $00, $f0, $60, $f8, $50, $f8, $10, $38, $10, $18, $00, $00, $00, $00, $00
	db $06, $00, $0f, $04, $1c, $03, $30, $0f, $67, $18, $e7, $5a, $c7, $38, $40, $3f
	db $49, $36, $ef, $10, $e6, $59, $70, $0f, $1c, $03, $1f, $08, $0c, $00, $00, $00
	db $00, $00, $06, $00, $0f, $04, $0e, $01, $38, $07, $72, $2d, $77, $0a, $22, $1d
	db $22, $1d, $77, $0a, $72, $2d, $38, $07, $0e, $01, $0f, $04, $06, $00, $00, $00
	db $1c, $00, $13, $0c, $18, $07, $1c, $0b, $3e, $1d, $3f, $18, $3e, $19, $2f, $1e
	db $37, $0d, $5f, $21, $56, $2d, $57, $2e, $4b, $37, $3c, $03, $37, $1c, $3f, $00
	db $1c, $00, $13, $0c, $18, $07, $14, $0b, $22, $1d, $21, $1e, $3e, $01, $21, $1e
	db $33, $0d, $5f, $21, $56, $2d, $57, $2e, $4b, $37, $3c, $03, $37, $1c, $3f, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $08, $07, $08, $07, $07, $00, $03, $01
	db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $1c, $00, $13, $0c, $18, $07, $9c, $0b, $7e, $9d, $3f, $d8, $be, $d9, $ef, $de
	db $f7, $6d, $5f, $31, $3e, $1d, $2f, $1e, $17, $0f, $1c, $03, $37, $1c, $3f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $8D: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles8D::
	db $03, $00, $0d, $02, $1f, $09, $1f, $0c, $37, $0d, $2d, $17, $25, $1b, $3f, $00
	db $47, $3f, $a7, $7f, $a7, $7f, $a7, $7f, $a7, $7f, $a7, $7f, $a3, $7f, $b1, $7f
	db $f0, $00, $fc, $f4, $ff, $00, $ff, $e1, $ff, $30, $ff, $e8, $f6, $ba, $fc, $00
	db $fa, $fc, $ed, $fe, $f5, $fe, $f5, $fe, $f5, $fe, $f5, $fe, $f5, $fe, $cd, $fe
	db $00, $00, $07, $00, $0b, $07, $1b, $04, $3f, $13, $3f, $14, $3f, $10, $27, $18
	db $3f, $0d, $37, $0d, $6b, $17, $ef, $58, $df, $6c, $ed, $73, $7f, $3f, $3f, $40
	db $00, $00, $c0, $00, $20, $c0, $18, $e0, $dc, $e8, $fc, $28, $fc, $08, $e4, $18
	db $f8, $b0, $ec, $b0, $d6, $e8, $f7, $1a, $fb, $36, $b7, $ce, $fe, $fc, $fc, $02
	db $00, $00, $07, $00, $08, $07, $13, $0f, $24, $1b, $4f, $34, $4d, $36, $2f, $16
	db $1f, $06, $2b, $16, $6d, $12, $ef, $5c, $df, $6c, $ed, $73, $7f, $3f, $3f, $40
	db $00, $00, $c0, $00, $b0, $c0, $78, $b0, $ee, $70, $dc, $e0, $70, $80, $fc, $50
	db $fc, $d8, $e8, $f0, $16, $e8, $f7, $1a, $fb, $36, $b7, $ce, $fe, $fc, $fc, $02
	db $00, $00, $c0, $00, $b0, $c0, $78, $b0, $ee, $70, $dc, $e0, $70, $80, $fc, $70
	db $fc, $d8, $e8, $f0, $16, $e8, $f7, $1a, $fb, $36, $b7, $ce, $fe, $fc, $fc, $02
	db $00, $00, $00, $00, $22, $00, $14, $00, $08, $00, $14, $00, $22, $00, $00, $00
	db $00, $00, $00, $00, $22, $00, $14, $00, $08, $00, $14, $00, $22, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $8E: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles8E::
	db $15, $00, $1f, $00, $1f, $00, $3f, $07, $7f, $2d, $7f, $28, $5b, $37, $38, $17
	db $3f, $10, $3f, $08, $7f, $27, $77, $28, $33, $0f, $1e, $01, $3d, $1e, $1f, $00
	db $e0, $00, $f8, $00, $fc, $00, $fc, $e0, $fe, $b4, $fe, $b4, $3a, $fc, $3c, $c8
	db $fc, $18, $fa, $34, $f2, $cc, $fa, $34, $fc, $b0, $78, $80, $bc, $78, $f8, $00
	db $2b, $2b, $7f, $54, $7f, $40, $7f, $40, $3f, $2f, $7f, $5f, $7f, $44, $5b, $3f
	db $43, $3c, $7f, $00, $37, $0f, $6f, $3f, $df, $7f, $c7, $7f, $cf, $7f, $df, $7f
	db $c0, $c0, $f0, $30, $f8, $08, $fc, $04, $fe, $02, $fe, $da, $fe, $da, $f6, $fa
	db $fc, $74, $fc, $04, $dc, $e4, $e4, $f8, $f2, $fc, $f2, $fc, $e6, $fc, $8e, $fc
	db $2b, $00, $3f, $00, $3f, $00, $1f, $0f, $3f, $15, $3f, $05, $5b, $3f, $43, $3c
	db $7f, $00, $3f, $01, $17, $0f, $0f, $00, $11, $0e, $1f, $00, $0b, $07, $1f, $00
	db $c0, $00, $f0, $00, $f8, $00, $fc, $00, $fc, $d8, $fc, $d8, $f4, $f8, $f8, $70
	db $f8, $f0, $f8, $e0, $e4, $18, $e4, $d8, $e4, $d8, $f8, $00, $d0, $e0, $f8, $00
	db $7f, $00, $7f, $3f, $7f, $22, $7f, $3f, $7f, $29, $7f, $3f, $7f, $22, $7f, $3f
	db $7f, $25, $7f, $3f, $7f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $05, $03, $09, $07, $10, $0f
	db $10, $0f, $10, $0f, $0c, $03, $03, $00, $03, $01, $03, $01, $01, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $8F: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles8F::
	db $07, $00, $38, $07, $50, $2f, $41, $3e, $51, $2e, $3f, $10, $3f, $15, $5f, $2d
	db $9f, $67, $9f, $63, $b7, $48, $7c, $17, $3b, $17, $30, $0f, $1f, $0f, $1f, $00
	db $e0, $00, $1c, $e0, $8a, $74, $c2, $bc, $ca, $b4, $fc, $88, $fe, $a8, $f9, $b6
	db $f9, $e6, $f9, $c6, $ee, $10, $7c, $d8, $bc, $d8, $1c, $e0, $08, $f0, $f8, $00
	db $03, $00, $04, $03, $39, $07, $40, $3f, $40, $3f, $20, $1f, $30, $0f, $20, $1f
	db $10, $0f, $20, $1f, $20, $1f, $30, $0f, $1c, $03, $23, $1c, $20, $1f, $3f, $00
	db $c0, $00, $20, $c0, $9c, $e0, $02, $fc, $02, $fc, $04, $f8, $0c, $f0, $04, $f8
	db $08, $f0, $08, $f0, $1c, $e0, $1c, $e8, $74, $88, $88, $70, $04, $f8, $fc, $00
	db $0f, $00, $36, $0f, $60, $3f, $58, $27, $7c, $0b, $1f, $08, $1f, $0a, $3f, $1a
	db $3f, $1f, $1e, $0f, $0f, $00, $07, $03, $07, $03, $07, $00, $08, $07, $0f, $00
	db $80, $00, $60, $80, $10, $e0, $1c, $e0, $04, $f8, $74, $88, $78, $a0, $d8, $60
	db $a4, $d8, $44, $b8, $c2, $3c, $e2, $1c, $bc, $40, $10, $e0, $08, $f0, $f8, $00
	db $00, $00, $0f, $00, $76, $0f, $a0, $7f, $b8, $47, $7c, $0b, $1f, $08, $1f, $0a
	db $3f, $1a, $3f, $1f, $1e, $0f, $0f, $00, $07, $03, $0f, $03, $13, $0c, $1f, $00
	db $00, $00, $80, $00, $60, $80, $10, $e0, $1c, $e0, $04, $f8, $74, $88, $78, $a0
	db $d4, $68, $a2, $dc, $41, $be, $e1, $1e, $9e, $60, $88, $70, $04, $f8, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $90: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles90::
	db $00, $00, $00, $00, $00, $00, $00, $00, $10, $00, $32, $00, $3a, $00, $7f, $00
	db $7f, $06, $ff, $02, $e7, $00, $81, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $02, $00, $02, $00, $06, $00, $07, $00, $0f, $02
	db $0f, $02, $0f, $00, $0d, $00, $0c, $00, $08, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $0e, $01, $1d, $03, $3e, $01, $3f, $00, $7b, $07, $ff, $4f, $d7, $78
	db $af, $76, $df, $2a, $7f, $0a, $7f, $2e, $6e, $31, $6f, $36, $7f, $06, $1f, $00
	db $00, $00, $00, $00, $03, $00, $0e, $01, $1d, $03, $3e, $01, $3f, $00, $7b, $07
	db $ff, $4f, $d7, $78, $af, $72, $7f, $0e, $ee, $71, $df, $66, $fd, $0e, $3f, $00
	db $00, $00, $00, $00, $00, $00, $0e, $00, $1e, $04, $1d, $0e, $1a, $07, $05, $03
	db $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $07, $03, $0f, $07, $0f, $04, $7f, $05, $7b, $37, $7f, $31, $3f, $1d
	db $5f, $2c, $7c, $03, $7b, $34, $7c, $33, $3f, $00, $0f, $06, $1f, $0e, $1f, $00
	db $f0, $00, $f8, $f0, $7c, $f8, $3c, $c8, $ff, $e8, $f7, $3a, $ff, $e6, $fe, $2c
	db $fd, $0a, $cd, $32, $37, $c8, $cf, $36, $ff, $06, $ce, $30, $f8, $00, $00, $00
	db $e7, $00, $ff, $67, $fe, $6f, $7e, $29, $ff, $0b, $ff, $66, $ff, $6b, $ff, $02
	db $27, $18, $7f, $20, $f8, $70, $78, $30, $70, $20, $20, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $91: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles91::
	db $06, $00, $0e, $04, $1e, $0c, $3b, $1c, $74, $3b, $e8, $77, $fa, $05, $1a, $05
	db $18, $07, $fc, $03, $ef, $70, $77, $38, $3b, $1c, $1e, $0c, $0e, $04, $06, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $08, $07, $11, $0f
	db $23, $1f, $21, $1f, $20, $1f, $22, $1d, $22, $1d, $30, $0f, $18, $07, $0f, $00
	db $03, $00, $04, $03, $09, $07, $09, $07, $08, $07, $0a, $05, $0a, $05, $0a, $05
	db $0a, $05, $0a, $05, $08, $07, $08, $07, $18, $07, $18, $07, $1c, $03, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $38, $00, $74, $38, $a2, $7c, $ca, $34, $ca, $34, $82, $7c, $7c, $00
	db $00, $00, $03, $00, $0c, $03, $11, $0f, $13, $0f, $23, $1d, $27, $18, $27, $18
	db $77, $28, $73, $2c, $5c, $33, $2f, $1c, $7b, $07, $77, $18, $3f, $10, $1f, $00
	db $03, $00, $77, $70, $7f, $78, $7f, $78, $3f, $33, $7f, $07, $ff, $09, $ff, $09
	db $ff, $0d, $ff, $0f, $7f, $03, $3f, $32, $7f, $7a, $7f, $78, $77, $70, $03, $00
	db $0f, $09, $3f, $18, $7f, $03, $7f, $4f, $ff, $d3, $ff, $19, $ff, $3d, $ff, $af
	db $ff, $a7, $ff, $39, $ff, $1c, $ff, $de, $7f, $4f, $7f, $03, $3f, $18, $0f, $09
	db $1f, $00, $3f, $1f, $5f, $3f, $9f, $60, $a0, $5f, $c0, $3f, $9b, $64, $9f, $78
	db $87, $78, $b7, $48, $b7, $78, $87, $7c, $bb, $46, $b9, $7f, $80, $7f, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $92: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles92::
	db $30, $00, $3f, $10, $3b, $17, $15, $0b, $17, $08, $77, $0a, $f3, $6c, $d1, $6e
	db $91, $6e, $f9, $06, $9f, $60, $ff, $03, $ec, $73, $ff, $70, $ff, $70, $7f, $00
	db $0e, $00, $fe, $0c, $bc, $d8, $78, $90, $de, $20, $cf, $b6, $8b, $76, $09, $f6
	db $0f, $f0, $39, $c6, $f9, $06, $9f, $e0, $37, $ce, $ff, $0e, $ff, $6e, $fe, $00
	db $03, $00, $07, $03, $09, $07, $1c, $03, $3c, $0b, $3c, $1b, $7c, $1b, $fd, $52
	db $be, $41, $bb, $5e, $7b, $1f, $3b, $1f, $39, $1f, $6c, $1f, $77, $0f, $3f, $00
	db $c0, $00, $a0, $c0, $d8, $e0, $dc, $e8, $1e, $ec, $1e, $ec, $1e, $e4, $df, $20
	db $3f, $ca, $ed, $3a, $fd, $fa, $fe, $f8, $fe, $f8, $7e, $f8, $fe, $f0, $fc, $00
	db $00, $00, $1f, $00, $3f, $1e, $6d, $32, $5d, $22, $78, $17, $70, $0f, $47, $38
	db $4f, $37, $cc, $37, $bc, $43, $fb, $34, $78, $37, $7f, $00, $ff, $1f, $ff, $00
	db $fc, $00, $fc, $f8, $b8, $c0, $f0, $e0, $e0, $00, $20, $c0, $70, $a0, $f0, $60
	db $f0, $60, $78, $b0, $78, $b0, $fc, $18, $fc, $18, $fc, $08, $fc, $80, $f0, $00
	db $00, $00, $00, $00, $1f, $00, $3f, $1e, $6d, $32, $5d, $22, $78, $17, $70, $0f
	db $47, $38, $4f, $37, $fc, $07, $fc, $33, $fb, $34, $78, $07, $ff, $70, $ff, $00
	db $00, $00, $fc, $00, $fc, $f8, $b8, $c0, $f0, $e0, $e0, $00, $20, $c0, $70, $a0
	db $f0, $60, $ff, $70, $7f, $be, $7f, $9e, $ff, $0e, $ff, $20, $f8, $e0, $f0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $93: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles93::
	db $70, $00, $f8, $70, $fc, $58, $de, $6c, $ce, $74, $cf, $76, $67, $3b, $67, $3b
	db $37, $1f, $1f, $0d, $ff, $0d, $2f, $15, $ff, $0f, $27, $1f, $43, $3c, $7c, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $00, $7e, $3c, $ff, $7e
	db $7f, $03, $23, $1d, $17, $0f, $1f, $0f, $7f, $0b, $af, $1d, $47, $3f, $7f, $00
	db $0f, $00, $73, $0f, $f7, $6f, $9f, $64, $ff, $60, $9f, $6f, $f3, $6f, $96, $6f
	db $bb, $77, $57, $38, $20, $1f, $7f, $3f, $43, $3c, $ff, $78, $ff, $00, $7f, $00
	db $e0, $00, $90, $e0, $e8, $f0, $ec, $b0, $ee, $34, $0f, $f6, $eb, $f6, $7d, $8e
	db $ed, $7e, $ea, $7c, $7e, $80, $82, $fc, $be, $7c, $c3, $3c, $ff, $3e, $ff, $00
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $00, $0f, $00, $3f, $0f, $5b, $3c, $bf, $78, $bb, $7c, $9f, $7f, $8b, $77
	db $c8, $37, $fc, $43, $f7, $78, $bf, $7f, $8b, $77, $c8, $37, $7c, $03, $1f, $00
	db $07, $00, $1f, $07, $2d, $1e, $3d, $1e, $5f, $3f, $4f, $3f, $45, $3b, $44, $3b
	db $64, $1b, $7e, $21, $7b, $3c, $5f, $3f, $45, $3b, $64, $1b, $3e, $01, $0f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $94: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles94::
	db $3f, $00, $7f, $3f, $7f, $1f, $3e, $0f, $1f, $07, $3f, $0b, $3f, $09, $3f, $0d
	db $2f, $13, $2f, $17, $68, $17, $d8, $67, $f8, $77, $ff, $00, $00, $00, $00, $00
	db $fc, $00, $fe, $fc, $fe, $fc, $4e, $fc, $1c, $f8, $9c, $f8, $fc, $f0, $fc, $f0
	db $fc, $f8, $fe, $f8, $f7, $fa, $77, $fa, $3f, $f0, $f8, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $07, $01, $1f, $07, $3f, $1f, $7f, $20, $ff, $40, $f8, $47
	db $f0, $0f, $23, $1d, $63, $1d, $a1, $5e, $e0, $5f, $f0, $6f, $fc, $03, $0f, $00
	db $00, $00, $c0, $00, $e0, $c0, $f0, $e0, $f8, $f0, $fc, $08, $fe, $04, $1e, $e4
	db $0e, $f0, $84, $78, $84, $78, $06, $f8, $0d, $f2, $1b, $e6, $7f, $8e, $ff, $00
	db $00, $00, $00, $00, $01, $00, $06, $01, $18, $07, $7f, $1f, $ff, $7f, $41, $3f
	db $20, $1f, $10, $0f, $10, $0f, $10, $0f, $31, $0e, $7f, $01, $3f, $00, $00, $00
	db $1f, $00, $7f, $1e, $ff, $7e, $3e, $fc, $3c, $e0, $fa, $d4, $f9, $96, $f9, $b6
	db $f1, $8e, $41, $be, $42, $bc, $fc, $00, $fe, $f8, $c7, $f8, $fe, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $0c, $03, $3f, $0f, $7f, $3f, $23, $1f
	db $11, $0f, $08, $07, $08, $07, $0f, $00, $3f, $07, $7e, $0f, $3f, $00, $00, $00
	db $0f, $00, $3f, $0e, $ff, $3c, $7e, $f0, $7c, $c0, $f2, $ac, $f1, $2e, $f1, $6e
	db $e1, $1e, $81, $7e, $82, $7c, $c6, $38, $fa, $c4, $23, $dc, $fe, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $95: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles95::
	db $01, $00, $03, $01, $05, $03, $1f, $00, $20, $1f, $40, $3f, $e7, $18, $ff, $62
	db $ff, $72, $bf, $70, $5f, $38, $3f, $1f, $3c, $1f, $7e, $3f, $ff, $7f, $ff, $00
	db $01, $00, $03, $01, $05, $03, $1d, $03, $25, $1b, $45, $3b, $45, $3b, $c3, $3c
	db $e0, $5f, $f0, $6f, $7f, $30, $38, $1f, $3f, $1f, $7f, $3f, $ff, $7f, $ff, $00
	db $0f, $00, $10, $0f, $20, $1f, $20, $1f, $37, $08, $7f, $30, $7f, $35, $5f, $35
	db $3f, $10, $3f, $18, $2f, $1f, $18, $0f, $1d, $0f, $1f, $0f, $3f, $1f, $3f, $00
	db $00, $00, $fc, $00, $7e, $bc, $22, $dc, $1e, $e0, $9f, $6e, $ff, $1e, $fd, $3e
	db $fa, $7c, $f4, $f8, $f4, $f8, $f4, $f8, $f4, $f8, $fe, $fc, $ff, $fe, $ff, $00
	db $00, $00, $00, $00, $03, $00, $07, $03, $0e, $07, $1f, $0f, $1c, $0f, $3f, $1f
	db $3f, $1f, $1c, $0f, $1f, $0f, $0e, $07, $07, $03, $03, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $fc, $00, $f0, $e0, $60, $80, $f8, $c0, $c0, $00, $f8, $c0
	db $f8, $c0, $c0, $00, $f8, $c0, $60, $80, $f0, $e0, $fc, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $20, $00, $25, $00, $35, $00, $3d, $10, $3f, $15, $37, $1d
	db $35, $1f, $3d, $1f, $1f, $0f, $0f, $07, $07, $01, $01, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03, $01
	db $05, $03, $1d, $03, $25, $1b, $45, $3b, $43, $3c, $40, $3f, $20, $1f, $1f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $96: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles96::
	db $03, $00, $05, $03, $69, $07, $98, $67, $88, $77, $e2, $1d, $f2, $6d, $fa, $75
	db $78, $37, $39, $16, $11, $0e, $11, $0e, $1c, $03, $1f, $0c, $3f, $1e, $3f, $00
	db $c0, $00, $a0, $c0, $90, $e0, $10, $e0, $10, $e0, $4c, $b0, $42, $bc, $41, $be
	db $1d, $e2, $9f, $6c, $8f, $76, $8e, $70, $18, $e0, $f8, $00, $f0, $00, $00, $00
	db $03, $00, $05, $03, $69, $07, $98, $67, $88, $77, $80, $7f, $80, $7f, $80, $7f
	db $48, $37, $30, $0f, $10, $0f, $10, $0f, $1c, $03, $1f, $0c, $3f, $1e, $3f, $00
	db $c0, $00, $a0, $c0, $90, $e0, $10, $e0, $10, $e0, $0c, $f0, $02, $fc, $01, $fe
	db $01, $fe, $11, $ee, $09, $f6, $0e, $f0, $18, $e0, $f8, $00, $f0, $00, $00, $00
	db $03, $00, $05, $03, $09, $07, $08, $07, $08, $07, $0a, $05, $12, $0d, $22, $1d
	db $28, $17, $2c, $13, $2c, $13, $2c, $13, $10, $0f, $0f, $00, $0f, $07, $1f, $00
	db $c0, $00, $a0, $c0, $90, $e0, $08, $f0, $08, $f0, $38, $c0, $0c, $f0, $02, $fc
	db $41, $be, $21, $de, $1f, $e0, $08, $f0, $10, $e0, $e0, $00, $e0, $c0, $e0, $00
	db $00, $00, $03, $00, $05, $03, $09, $07, $08, $07, $08, $07, $0a, $05, $12, $0d
	db $22, $1d, $28, $17, $2c, $13, $2c, $13, $2c, $13, $38, $07, $7f, $38, $7f, $00
	db $00, $00, $c0, $00, $a0, $c0, $9e, $e0, $11, $ee, $27, $d8, $4f, $b6, $1f, $ee
	db $3e, $dc, $7c, $b8, $3c, $c0, $04, $f8, $0c, $f0, $3e, $c4, $fe, $3c, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $97: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles97::
	db $07, $00, $1f, $07, $ff, $1f, $ff, $7f, $ff, $6f, $7f, $30, $ff, $76, $ff, $76
	db $ff, $7f, $ff, $6f, $ff, $70, $7f, $3f, $78, $3f, $3f, $1f, $1f, $07, $07, $00
	db $80, $00, $e0, $80, $fe, $e0, $fe, $fc, $fe, $7c, $fc, $f8, $fc, $f0, $fc, $f8
	db $fc, $f8, $fc, $b8, $fe, $78, $ff, $f6, $f9, $fe, $e2, $fc, $9c, $e0, $e0, $00
	db $07, $00, $1f, $07, $ff, $1f, $ff, $6f, $ff, $76, $7f, $36, $ff, $70, $ff, $76
	db $ff, $5f, $ff, $40, $ff, $49, $7f, $20, $7f, $30, $3f, $1f, $1f, $07, $07, $00
	db $80, $00, $e0, $80, $fe, $e0, $fe, $7c, $fe, $fc, $fc, $f8, $fc, $f0, $fc, $f8
	db $ff, $d8, $ff, $1a, $ff, $9a, $fd, $36, $fa, $7c, $e4, $f8, $98, $e0, $e0, $00
	db $06, $02, $46, $02, $60, $00, $63, $40, $2f, $20, $1f, $00, $1f, $00, $3f, $02
	db $3f, $02, $7f, $06, $7f, $00, $7f, $00, $1c, $03, $1f, $00, $0f, $00, $03, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $7f, $00, $ff, $02, $ff, $02, $7f, $06
	db $3f, $00, $3f, $00, $3f, $03, $3f, $07, $1f, $00, $1f, $00, $0f, $00, $03, $00
	db $07, $00, $1f, $07, $ff, $1f, $ff, $7f, $ff, $76, $7f, $36, $ff, $7f, $ff, $7f
	db $ff, $7f, $ff, $4f, $ff, $76, $7f, $39, $7f, $3f, $39, $1f, $1f, $07, $07, $00
	db $80, $00, $e0, $80, $fe, $e0, $fe, $fc, $fe, $fc, $fc, $f8, $fc, $f0, $fc, $f8
	db $fc, $f8, $fc, $18, $fe, $f8, $ff, $f6, $f9, $fe, $e2, $fc, $9c, $e0, $e0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $98: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles98::
	db $00, $00, $03, $00, $0c, $03, $13, $0c, $2f, $10, $2f, $10, $5e, $21, $5d, $23
	db $5d, $23, $5e, $21, $2f, $10, $3f, $0e, $3f, $19, $3f, $19, $1f, $0e, $0e, $00
	db $00, $00, $03, $00, $3c, $03, $7b, $34, $ff, $78, $ff, $48, $fe, $49, $7d, $33
	db $7d, $33, $fe, $49, $ff, $48, $ff, $78, $7b, $34, $3c, $03, $03, $00, $00, $00
	db $00, $00, $c0, $00, $30, $c0, $c8, $30, $f4, $08, $f4, $08, $7a, $84, $ba, $c4
	db $ba, $c4, $7a, $84, $f4, $08, $f4, $08, $c8, $30, $30, $c0, $c0, $00, $00, $00
	db $00, $00, $03, $00, $0c, $03, $13, $0c, $2f, $10, $2f, $10, $7e, $01, $7d, $33
	db $fd, $7b, $fe, $49, $ff, $48, $7f, $3f, $3f, $09, $1f, $09, $0f, $07, $07, $00
	db $00, $00, $c0, $00, $30, $c0, $c8, $30, $f4, $08, $f4, $08, $7a, $84, $ba, $c4
	db $ba, $c4, $7a, $84, $f4, $08, $f4, $08, $c8, $b0, $f0, $80, $c0, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $04, $03, $0b, $04, $16, $09, $16, $09
	db $17, $08, $17, $08, $0b, $04, $04, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $04, $03, $0b, $04, $0a, $05
	db $0b, $04, $0b, $04, $04, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $99: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles99::
	db $00, $00, $00, $00, $03, $00, $0f, $00, $1e, $01, $1e, $01, $1f, $00, $3f, $00
	db $5f, $23, $5f, $27, $5f, $26, $5b, $26, $4d, $33, $67, $18, $33, $0f, $1f, $00
	db $07, $00, $0b, $06, $0b, $07, $1b, $04, $1e, $01, $1e, $01, $1f, $00, $3f, $00
	db $5f, $20, $5f, $20, $5f, $20, $5f, $20, $4f, $30, $67, $18, $33, $0f, $1f, $00
	db $00, $00, $00, $00, $03, $00, $3f, $00, $7e, $39, $fe, $19, $ff, $18, $fb, $3c
	db $b3, $7c, $47, $38, $7f, $00, $5f, $20, $4f, $30, $67, $18, $33, $0f, $1f, $00
	db $00, $00, $00, $00, $c0, $00, $f0, $00, $78, $80, $78, $80, $f8, $00, $fc, $00
	db $fa, $04, $fa, $04, $fa, $04, $fa, $04, $f2, $0c, $e6, $18, $cc, $f0, $f8, $00
	db $00, $00, $00, $00, $03, $00, $0f, $00, $1e, $01, $1e, $01, $1f, $00, $3f, $0e
	db $7f, $1f, $7f, $13, $7f, $13, $6e, $1f, $50, $2f, $6f, $10, $33, $0f, $1f, $00
	db $00, $00, $00, $00, $c0, $00, $f0, $00, $78, $80, $78, $80, $f8, $00, $fc, $00
	db $fa, $04, $7a, $84, $7a, $84, $7a, $84, $f2, $0c, $e6, $18, $cc, $f0, $f8, $00
	db $0e, $00, $1d, $0e, $3f, $0c, $7f, $38, $7e, $31, $4e, $31, $4f, $30, $3f, $00
	db $5f, $20, $5f, $20, $5f, $20, $5f, $20, $4f, $30, $67, $18, $33, $0f, $1f, $00
	db $00, $00, $00, $00, $c0, $00, $f0, $00, $78, $80, $78, $80, $f8, $00, $fc, $00
	db $fa, $04, $fa, $04, $fa, $04, $fa, $04, $f2, $0c, $e6, $18, $cc, $f0, $f8, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $9A: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles9A::
	db $07, $00, $3b, $07, $7b, $37, $78, $37, $7f, $30, $7f, $04, $4f, $30, $48, $37
	db $78, $07, $48, $37, $37, $08, $20, $1f, $23, $1c, $3c, $03, $1f, $00, $07, $00
	db $c0, $00, $20, $c0, $10, $e0, $10, $e0, $dc, $20, $fe, $8c, $f2, $0c, $52, $ac
	db $3e, $c0, $7e, $bc, $ff, $66, $ff, $42, $ff, $42, $ff, $66, $fe, $3c, $fc, $00
	db $67, $00, $f9, $67, $f1, $6f, $f0, $6f, $f7, $08, $9f, $62, $9f, $60, $f4, $0b
	db $90, $6f, $78, $07, $27, $18, $20, $1f, $23, $1c, $3e, $01, $3f, $1e, $1f, $00
	db $e0, $00, $90, $e0, $88, $f0, $08, $f0, $e8, $10, $fe, $40, $ff, $06, $3d, $c2
	db $7f, $bc, $ff, $66, $ff, $42, $ff, $42, $ff, $66, $fe, $3c, $fe, $00, $fc, $00
	db $01, $01, $03, $02, $3f, $3d, $3f, $21, $3f, $28, $3f, $26, $7b, $46, $ff, $b0
	db $cf, $b0, $7f, $46, $3d, $26, $3f, $28, $3e, $21, $3e, $3d, $03, $02, $01, $01
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $9B: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles9B::
	db $18, $00, $1c, $08, $1e, $0c, $1b, $0c, $d6, $09, $ff, $40, $ff, $60, $7f, $30
	db $5f, $38, $27, $18, $5f, $20, $47, $38, $63, $1f, $78, $27, $7f, $38, $3f, $00
	db $00, $00, $18, $00, $1c, $08, $1e, $0c, $1b, $0c, $d6, $09, $ff, $40, $ff, $60
	db $7f, $30, $5f, $38, $27, $18, $5f, $20, $47, $38, $e3, $5f, $f8, $67, $ff, $00
	db $00, $00, $07, $00, $18, $07, $23, $1c, $45, $3b, $4e, $37, $4e, $37, $4d, $37
	db $47, $3b, $c3, $3c, $e0, $5f, $f1, $0f, $1c, $03, $0f, $00, $05, $03, $03, $00
	db $00, $00, $07, $00, $1b, $05, $23, $1d, $5f, $23, $5f, $2d, $5f, $2e, $4f, $35
	db $47, $39, $c3, $3c, $e0, $5f, $f1, $0f, $1c, $03, $0f, $00, $05, $03, $03, $00
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $9C: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles9C::
	db $03, $00, $05, $03, $0b, $07, $17, $08, $28, $17, $37, $0f, $3f, $0b, $5f, $2b
	db $9f, $6b, $97, $6f, $bc, $67, $bf, $67, $bf, $64, $67, $18, $c0, $3f, $ff, $00
	db $e0, $00, $90, $e0, $08, $f0, $c4, $38, $44, $b8, $a2, $dc, $d2, $6c, $f5, $2a
	db $f5, $2a, $dd, $e2, $b1, $ce, $f9, $8e, $fa, $8c, $cd, $32, $01, $fe, $ff, $00
	db $03, $00, $05, $03, $09, $07, $11, $0f, $10, $0f, $28, $17, $28, $17, $64, $1b
	db $a0, $5f, $90, $6f, $88, $77, $b7, $58, $4c, $3f, $83, $7f, $80, $7f, $ff, $00
	db $e0, $00, $90, $e0, $88, $f0, $08, $f0, $08, $f0, $14, $e8, $34, $c8, $4a, $b4
	db $11, $ee, $21, $de, $45, $ba, $8d, $7a, $12, $fc, $e2, $fc, $01, $fe, $ff, $00
	db $00, $00, $7f, $00, $7f, $3f, $7c, $0f, $2c, $17, $78, $37, $7c, $23, $7e, $21
	db $fa, $65, $bb, $7c, $a7, $7b, $ff, $63, $bf, $6b, $7f, $00, $10, $0f, $1f, $00
	db $00, $00, $c0, $00, $a0, $c0, $10, $e0, $08, $f0, $38, $c0, $04, $f8, $e4, $18
	db $92, $6c, $0e, $f0, $04, $f8, $04, $f8, $2a, $dc, $f1, $3e, $01, $fe, $ff, $00
	db $7f, $00, $7f, $3f, $7c, $0f, $2c, $17, $78, $37, $7c, $23, $7e, $21, $fa, $65
	db $bb, $7c, $a7, $79, $ff, $65, $bf, $6d, $7f, $00, $06, $01, $08, $07, $0f, $00
	db $c0, $00, $a0, $c0, $10, $e0, $08, $f0, $38, $c0, $04, $f8, $64, $98, $92, $6c
	db $8e, $70, $84, $f8, $84, $f8, $ac, $d8, $f4, $38, $02, $fc, $02, $fc, $fe, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $9D: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles9D::
	db $01, $00, $03, $01, $03, $01, $07, $01, $1f, $00, $3f, $03, $3f, $06, $7f, $00
	db $7f, $01, $7f, $00, $7f, $06, $3f, $03, $3f, $00, $1f, $00, $29, $1e, $1e, $00
	db $80, $00, $c0, $80, $c0, $80, $e0, $80, $f8, $00, $fc, $c0, $fc, $60, $fe, $60
	db $fe, $c0, $fe, $60, $fe, $60, $fc, $c0, $fc, $00, $f8, $00, $94, $78, $78, $00
	db $00, $00, $00, $00, $01, $00, $07, $01, $1f, $00, $3f, $03, $3f, $06, $7f, $00
	db $7f, $01, $7f, $03, $7f, $06, $3f, $07, $3f, $00, $1f, $00, $29, $1e, $1e, $00
	db $00, $00, $00, $00, $80, $00, $e0, $80, $f8, $00, $fc, $c0, $fc, $60, $fe, $60
	db $fe, $c0, $fe, $00, $fe, $00, $fc, $e0, $fc, $00, $f8, $00, $94, $78, $78, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $1f, $02, $3d, $03, $3f, $00, $7f, $00
	db $7f, $10, $7f, $10, $7f, $18, $3f, $08, $3f, $00, $57, $38, $43, $3c, $3c, $00
	db $38, $00, $68, $30, $d0, $60, $a0, $c0, $f0, $00, $b8, $c0, $f8, $00, $fc, $00
	db $fc, $20, $fc, $60, $fc, $c0, $f8, $80, $f4, $08, $e4, $18, $f8, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $1f, $00, $3f, $01, $3f, $01, $7f, $01
	db $7f, $01, $7f, $01, $7f, $01, $3f, $01, $3f, $00, $1f, $00, $29, $1e, $1e, $00
	db $01, $00, $03, $01, $03, $01, $07, $01, $1f, $00, $3f, $04, $3f, $06, $7f, $02
	db $7f, $00, $7f, $18, $7b, $1f, $3b, $0f, $3b, $07, $1f, $00, $29, $1e, $1e, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $9E: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles9E::
	db $1c, $00, $3f, $1c, $3f, $17, $3f, $18, $7f, $07, $5f, $2f, $af, $5f, $af, $5f
	db $ef, $5f, $f6, $6f, $bf, $60, $56, $2f, $38, $07, $7f, $38, $fd, $56, $ff, $00
	db $e0, $00, $f0, $e0, $f8, $a0, $fc, $e0, $fe, $00, $c6, $b8, $bb, $dc, $bb, $dc
	db $7d, $9e, $bd, $5e, $3d, $de, $5a, $bc, $fc, $00, $de, $3c, $bf, $6a, $ff, $00
	db $01, $00, $03, $01, $03, $01, $03, $01, $03, $01, $05, $03, $0b, $07, $17, $0f
	db $17, $0f, $0b, $07, $05, $03, $03, $01, $03, $01, $03, $01, $03, $01, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $00, $7f, $3f
	db $7f, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00, $03, $01, $03, $01, $ff, $03, $ff, $ff
	db $ff, $ff, $ff, $03, $03, $01, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01
	db $fc, $03, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $1c, $00, $3f, $08, $3f, $1c, $3f, $0f, $1e, $07, $1d, $06
	db $1d, $06, $1e, $07, $3f, $0f, $3f, $1c, $3f, $08, $1c, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $03, $00, $03, $01, $07, $01, $0f, $03, $3e, $07, $7d, $1e
	db $7d, $1e, $3e, $07, $0f, $03, $07, $01, $03, $01, $03, $00, $01, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $9F: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTiles9F::
	db $00, $00, $00, $00, $03, $00, $0c, $03, $1f, $01, $1f, $0e, $3f, $0a, $3f, $0e
	db $2e, $11, $20, $1f, $60, $1f, $f0, $6f, $f8, $77, $ff, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $e0, $00, $90, $e0, $f8, $c0, $fc, $b8, $7c, $a8, $7c, $b8
	db $3c, $c0, $06, $f8, $07, $fa, $07, $fa, $0f, $f0, $f0, $00, $00, $00, $00, $00
	db $07, $00, $07, $03, $07, $03, $0c, $07, $19, $0f, $7f, $1f, $ff, $7f, $41, $3f
	db $20, $1f, $10, $0f, $10, $0f, $10, $0f, $10, $0f, $0f, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $fe, $ff, $fe, $7e, $fc, $fc, $f0, $f0, $e0, $e0, $c0, $c0, $80
	db $c0, $80, $40, $80, $40, $80, $40, $80, $80, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $A0: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA0::
	db $03, $00, $03, $01, $1f, $00, $67, $1f, $ce, $71, $fe, $65, $fe, $6d, $6d, $32
	db $74, $3b, $36, $19, $30, $1f, $39, $06, $7f, $3d, $f7, $78, $ff, $07, $07, $00
	db $60, $00, $f0, $60, $f8, $10, $bc, $c8, $5c, $e0, $a8, $70, $9e, $70, $e7, $1a
	db $ff, $02, $87, $7a, $f7, $1a, $f7, $da, $ee, $b0, $dc, $68, $b8, $d0, $f0, $00
	db $03, $00, $03, $01, $1f, $00, $67, $1f, $ce, $71, $fe, $6d, $fe, $65, $6d, $32
	db $74, $3b, $f6, $59, $f0, $5f, $79, $26, $3f, $1d, $1f, $08, $0f, $07, $07, $00
	db $c0, $00, $e0, $40, $f0, $20, $b0, $c0, $50, $e0, $a8, $70, $4c, $b0, $6a, $94
	db $fa, $04, $4a, $b4, $fa, $04, $fa, $64, $ec, $d0, $d8, $20, $f0, $c0, $e0, $00
	db $00, $00, $01, $00, $1b, $01, $7f, $18, $fc, $4b, $bd, $5a, $d9, $26, $61, $1e
	db $39, $06, $ff, $1c, $ff, $7b, $7f, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $c0, $00, $e0, $c0, $f0, $00, $0b, $f0, $57, $fa, $57, $fa, $d7, $3a
	db $df, $ba, $fb, $70, $f0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $1b, $01, $7f, $18, $fc, $4b, $bd, $5a, $59, $26, $e1, $5e
	db $f9, $66, $7f, $3c, $3f, $0b, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $c0, $00, $a0, $c0, $e0, $00, $16, $e0, $4a, $f4, $5a, $f4, $fa, $14
	db $fa, $d4, $f6, $20, $e0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $A1: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA1::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $10, $10, $12, $12, $1c, $1c, $04, $04, $07, $07, $00, $00, $00, $00
	db $00, $00, $00, $00, $10, $00, $18, $00, $1e, $00, $2f, $1e, $5f, $2a, $bf, $4e
	db $fe, $00, $7c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $10, $00, $18, $00, $16, $08, $3f, $1e, $7f, $3a
	db $ef, $7e, $82, $7c, $7c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $00, $80, $00, $40, $00, $40, $00, $60, $00, $60, $00, $60, $00, $60, $00
	db $30, $00, $30, $00, $30, $00, $3c, $00, $3e, $0c, $3e, $0c, $3c, $00, $30, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $0f, $00, $3f, $00, $c0, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $00
	db $1e, $0c, $1e, $0c, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $00, $07, $00
	db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $c0, $00, $e0, $00, $76, $00, $3f, $06, $1f, $06, $0e, $00, $07, $00, $03, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $A2: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA2::
	db $1c, $00, $3a, $1c, $29, $1e, $11, $0e, $39, $1e, $1b, $0c, $17, $08, $1f, $00
	db $0b, $04, $08, $07, $04, $03, $07, $00, $07, $00, $0d, $06, $0b, $04, $0f, $00
	db $3c, $00, $42, $3c, $99, $66, $bd, $42, $3c, $c3, $18, $e7, $81, $7e, $81, $7e
	db $00, $ff, $42, $bd, $ff, $42, $ff, $3c, $bd, $7e, $db, $3c, $bd, $00, $00, $00
	db $00, $00, $30, $00, $78, $30, $5c, $38, $eb, $5c, $bb, $7c, $57, $38, $ef, $50
	db $bb, $74, $48, $37, $24, $1b, $1f, $00, $07, $00, $0d, $06, $0b, $04, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0d, $00, $1f, $0c, $3f, $18, $37, $18
	db $73, $1c, $72, $2d, $72, $1d, $57, $28, $25, $1a, $17, $08, $0f, $00, $00, $00
	db $1c, $00, $13, $0c, $18, $07, $1c, $0b, $3e, $1d, $3f, $18, $3e, $19, $2f, $1e
	db $37, $0d, $5f, $21, $56, $2d, $57, $2e, $4b, $37, $3c, $03, $37, $1c, $3f, $00
	db $1c, $00, $13, $0c, $18, $07, $14, $0b, $22, $1d, $21, $1e, $3e, $01, $21, $1e
	db $33, $0d, $5f, $21, $56, $2d, $57, $2e, $4b, $37, $3c, $03, $37, $1c, $3f, $00
	db $00, $00, $00, $00, $00, $00, $07, $00, $08, $07, $08, $07, $07, $00, $03, $01
	db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $1c, $00, $13, $0c, $18, $07, $9c, $0b, $7e, $9d, $3f, $d8, $be, $d9, $ef, $de
	db $f7, $6d, $5f, $31, $3e, $1d, $2f, $1e, $17, $0f, $1c, $03, $37, $1c, $3f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $A3: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA3::
	db $00, $00, $00, $00, $00, $00, $01, $00, $1f, $00, $7f, $00, $ff, $00, $ff, $00
	db $f0, $0f, $7f, $05, $3f, $0d, $3f, $1f, $7f, $3f, $7f, $37, $70, $0f, $bf, $70
	db $00, $00, $00, $00, $f8, $00, $8c, $70, $7e, $80, $fe, $00, $f0, $00, $f8, $00
	db $fc, $00, $7c, $80, $dc, $a0, $c8, $b0, $44, $b8, $44, $b8, $c4, $38, $e8, $10
	db $bf, $60, $7f, $18, $5f, $30, $f3, $0c, $f7, $4e, $eb, $17, $3d, $13, $2f, $18
	db $57, $2f, $4f, $30, $43, $3f, $60, $1f, $6c, $13, $3e, $01, $0f, $10, $00, $00
	db $fe, $00, $ff, $02, $ff, $02, $7f, $f6, $ef, $18, $fe, $08, $fc, $08, $f4, $18
	db $ea, $f4, $f2, $0c, $c2, $fc, $06, $f8, $36, $c8, $7c, $80, $f0, $08, $00, $00
	db $00, $00, $01, $00, $03, $00, $03, $00, $03, $00, $1f, $00, $7f, $00, $ff, $00
	db $f7, $0b, $ef, $15, $6f, $15, $4f, $37, $4b, $37, $4f, $33, $4d, $33, $3f, $00
	db $00, $00, $e0, $00, $70, $80, $70, $80, $60, $80, $f8, $00, $fe, $00, $ff, $00
	db $af, $d0, $f7, $a8, $f2, $ac, $f3, $ec, $91, $ee, $e1, $9e, $61, $9e, $f2, $0c
	db $3f, $07, $3f, $0e, $7f, $0d, $ff, $40, $f5, $5b, $fd, $13, $3e, $11, $2f, $18
	db $57, $2f, $4f, $30, $43, $3f, $60, $1f, $6c, $13, $3e, $01, $0f, $10, $00, $00
	db $fc, $00, $fc, $c0, $be, $c0, $df, $32, $6f, $9a, $7f, $88, $fc, $08, $f4, $18
	db $ea, $f4, $f2, $0c, $c2, $fc, $06, $f8, $36, $c8, $7c, $80, $f0, $08, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $A4: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA4::
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
;@ Entity graphics set $A5: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA5::
	db $07, $00, $0e, $03, $3f, $01, $5f, $21, $ff, $41, $fe, $01, $3e, $01, $77, $38
	db $ff, $78, $f7, $08, $1f, $06, $0f, $05, $0f, $03, $07, $00, $03, $00, $00, $00
	db $3f, $00, $ff, $00, $bf, $40, $bf, $40, $b9, $46, $94, $6f, $90, $6f, $f1, $0e
	db $fa, $65, $f4, $db, $e4, $db, $e4, $5b, $f8, $47, $fe, $e1, $fe, $0d, $1f, $00
	db $18, $00, $a4, $18, $f4, $08, $9a, $64, $8f, $70, $8f, $76, $8e, $70, $c8, $30
	db $08, $f0, $08, $f0, $08, $f0, $30, $c0, $40, $80, $40, $80, $40, $80, $80, $00
	db $00, $00, $3f, $00, $ff, $00, $bf, $40, $bf, $40, $b9, $46, $94, $6f, $90, $6f
	db $f1, $0e, $f9, $66, $f5, $ea, $e9, $de, $e1, $5e, $f3, $6c, $fc, $e0, $e0, $00
	db $00, $00, $00, $00, $f0, $00, $c8, $30, $c8, $30, $c4, $38, $e4, $18, $84, $78
	db $06, $f8, $0a, $f4, $1a, $e4, $0a, $f4, $84, $78, $f2, $0c, $f2, $6c, $fc, $00
	db $08, $00, $1c, $08, $1f, $0c, $17, $0e, $0b, $05, $07, $01, $67, $00, $f4, $43
	db $ab, $56, $8f, $75, $6f, $15, $fb, $66, $ed, $53, $c7, $38, $64, $1b, $3f, $00
	db $00, $00, $7c, $00, $ef, $10, $ff, $c3, $ff, $a7, $ff, $e5, $ff, $d3, $db, $24
	db $00, $ff, $ff, $00, $ff, $82, $ff, $76, $ff, $f9, $be, $7f, $ff, $00, $ff, $00
	db $00, $00, $10, $00, $38, $10, $f8, $30, $e8, $b0, $d0, $a0, $ec, $00, $7e, $84
	db $aa, $d4, $e2, $dc, $e6, $d8, $bf, $c6, $77, $8a, $e3, $1c, $26, $d8, $fc, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $A6: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA6::
	db $00, $00, $3f, $00, $21, $1f, $21, $1f, $21, $1f, $21, $1f, $3f, $1f, $3f, $1f
	db $21, $1f, $21, $1f, $21, $1f, $21, $1f, $3f, $00, $3f, $00, $00, $00, $00, $00
	db $01, $00, $02, $01, $04, $03, $08, $07, $1c, $0f, $26, $1f, $43, $3f, $81, $7f
	db $c3, $3f, $66, $1f, $3c, $0f, $1c, $07, $0c, $03, $06, $01, $03, $00, $01, $00
	db $03, $00, $02, $01, $03, $00, $02, $01, $0f, $01, $1b, $0d, $2e, $11, $5a, $21
	db $b2, $41, $a2, $41, $a2, $41, $a2, $41, $be, $41, $87, $7d, $fe, $01, $7f, $00
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $00, $00, $e7, $00, $fb, $67, $97, $7f, $9f, $6e, $af, $5d, $ae, $5d, $af, $5e
	db $b7, $4f, $bb, $57, $bd, $53, $6c, $1b, $f5, $4b, $fd, $63, $bc, $7b, $7d, $3b
	db $dd, $3b, $a4, $5b, $bd, $43, $a5, $5b, $a4, $5b, $a5, $5b, $a5, $5b, $c4, $3b
	db $c5, $3b, $c5, $3b, $fc, $43, $bd, $5b, $ec, $1b, $fe, $41, $fd, $7e, $7f, $00
	db $03, $03, $0c, $0f, $13, $1c, $2f, $30, $2f, $30, $5c, $63, $59, $67, $59, $67
	db $59, $66, $59, $66, $2c, $33, $2f, $30, $13, $1c, $0c, $0f, $03, $03, $00, $00
	db $00, $0c, $45, $0b, $16, $19, $37, $38, $0f, $f0, $7c, $83, $39, $47, $59, $67
	db $d9, $66, $59, $66, $3c, $43, $7f, $80, $0f, $f0, $36, $39, $55, $1b, $00, $0c
;@ path: gfx/sprites/entities
;@ Entity graphics set $A7: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA7::
	db $07, $00, $1f, $00, $3f, $1c, $7f, $3e, $7f, $26, $dd, $2e, $e3, $1c, $ff, $03
	db $cf, $3f, $be, $7f, $bd, $7e, $c2, $3d, $7c, $03, $7f, $00, $bd, $7e, $ff, $00
	db $c0, $00, $f0, $00, $f8, $00, $f8, $00, $f4, $08, $6c, $f0, $f2, $0c, $6a, $9c
	db $fa, $fc, $fa, $fc, $f2, $fc, $e7, $f8, $0f, $f6, $fd, $0e, $fb, $3c, $fe, $00
	db $07, $00, $1f, $00, $3f, $0e, $7f, $1f, $7f, $13, $ee, $17, $f1, $0e, $ff, $31
	db $f7, $6f, $f7, $6f, $f6, $6f, $b9, $76, $46, $39, $7f, $00, $0b, $07, $0f, $00
	db $c0, $00, $f0, $00, $f8, $00, $f8, $00, $f4, $08, $ec, $70, $fa, $04, $b2, $cc
	db $fa, $fc, $7a, $fc, $f2, $7c, $e4, $f8, $08, $f0, $f8, $00, $e8, $f0, $f8, $00
	db $0f, $00, $3f, $00, $7f, $11, $7f, $3b, $ff, $2a, $d5, $2a, $ee, $11, $bf, $40
	db $ff, $51, $ff, $5f, $bf, $5f, $5f, $3f, $2f, $1f, $7c, $03, $bb, $7c, $ff, $00
	db $e0, $00, $f8, $00, $fc, $c0, $fe, $e0, $fe, $60, $db, $ec, $3f, $c0, $ef, $1c
	db $fd, $fe, $fd, $ee, $f1, $ee, $ee, $f0, $84, $f8, $0e, $f0, $f3, $0c, $fe, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1f, $00, $27, $1f, $47, $3f
	db $40, $3f, $40, $3f, $40, $3f, $40, $3f, $60, $1f, $70, $0f, $3f, $00, $1f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $20, $c0, $10, $e0
	db $10, $e0, $10, $e0, $10, $e0, $10, $e0, $30, $c0, $70, $80, $e0, $00, $c0, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $A8: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA8::
	db $00, $00, $e3, $00, $fe, $61, $5f, $30, $5f, $20, $ff, $00, $fd, $03, $f3, $0c
	db $ef, $10, $ff, $00, $ff, $80, $ff, $00, $ff, $60, $ff, $70, $7e, $bd, $3e, $c0
	db $e3, $00, $ff, $60, $5d, $33, $53, $2c, $ef, $13, $ff, $0f, $ff, $1d, $de, $39
	db $cf, $38, $e5, $9a, $f2, $0d, $ff, $c0, $ef, $d0, $e0, $df, $f0, $6f, $70, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $05, $03, $0e, $05, $1b, $0c, $34, $18, $68, $30, $d0, $60, $e0, $1f
	db $70, $00, $f8, $30, $dc, $78, $ee, $5c, $f7, $4e, $eb, $47, $e5, $42, $e3, $40
	db $ff, $00, $ff, $fd, $05, $fb, $fc, $03, $75, $22, $63, $1c, $00, $07, $00, $ff
	db $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $00, $03, $00, $07, $02
	db $0d, $06, $1b, $0c, $35, $18, $69, $30, $d1, $60, $e1, $1e, $01, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $c0, $00, $e0, $c0, $30, $e0, $ff, $b0, $dd, $ba
	db $ef, $9c, $f7, $8d, $cd, $83, $c4, $83, $c5, $82, $c3, $bc, $c0, $87, $c0, $3f
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00
	db $01, $00, $03, $01, $03, $01, $06, $03, $07, $02, $0d, $06, $0e, $04, $0c, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $00, $df, $38, $f7, $ce
	db $ff, $b0, $4f, $bd, $f3, $0d, $8c, $03, $05, $0a, $03, $fc, $00, $07, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $A9: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesA9::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $00, $3c, $10, $3e, $1c
	db $ff, $0e, $ff, $6a, $9e, $61, $ff, $00, $01, $00, $03, $00, $07, $03, $07, $00
	db $0f, $00, $3f, $0f, $7f, $3f, $ff, $4e, $ff, $5c, $ff, $4c, $ff, $4c, $ff, $6c
	db $ff, $3f, $ff, $d3, $7f, $82, $ff, $70, $bf, $78, $5c, $bb, $bf, $c0, $f8, $00
	db $c0, $00, $f0, $c0, $f8, $f0, $fc, $38, $fc, $98, $fc, $18, $fc, $38, $fe, $f0
	db $ff, $80, $ff, $00, $ff, $00, $e7, $18, $9e, $60, $7e, $98, $bf, $7e, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $00, $3e, $04, $7e, $34
	db $ff, $3c, $ff, $53, $98, $67, $ff, $00, $07, $00, $06, $03, $03, $01, $03, $00
	db $ff, $6e, $f7, $6e, $69, $06, $0f, $00, $0d, $06, $0d, $06, $0d, $06, $0d, $06
	db $0d, $06, $0d, $06, $0d, $06, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $0f, $00, $3f, $0f, $7f, $3f, $ff, $63, $ff, $61, $ff, $61
	db $ff, $65, $7f, $39, $ff, $0f, $ff, $06, $bf, $42, $bf, $40, $5f, $20, $ff, $4c
	db $00, $00, $00, $00, $c0, $00, $f0, $c0, $f8, $f0, $fc, $c8, $fc, $88, $fc, $88
	db $fe, $d8, $ff, $b6, $ff, $ee, $ff, $6c, $ff, $40, $d6, $28, $2f, $de, $ff, $00
	db $c0, $00, $e0, $00, $f0, $00, $88, $70, $b8, $70, $bb, $70, $7f, $30, $3f, $06
	db $1f, $0f, $1f, $0d, $1f, $0d, $1f, $06, $0f, $00, $07, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $AA: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesAA::
	db $0e, $01, $1d, $03, $3e, $01, $7f, $00, $7e, $01, $fe, $61, $ff, $70, $ff, $5f
	db $e7, $5f, $b8, $67, $7f, $20, $5f, $30, $2f, $18, $27, $1f, $18, $07, $07, $00
	db $00, $00, $07, $00, $0b, $07, $17, $0f, $17, $0c, $2e, $19, $5f, $30, $fe, $61
	db $fd, $63, $be, $61, $5f, $20, $7f, $00, $3f, $00, $1f, $00, $0f, $00, $03, $00
	db $38, $00, $57, $38, $ac, $73, $ff, $60, $ff, $60, $af, $70, $5b, $3c, $27, $1f
	db $18, $07, $27, $18, $4f, $30, $bf, $60, $ae, $71, $9f, $7f, $40, $3f, $3f, $00
	db $70, $00, $ac, $70, $ae, $70, $df, $20, $ff, $00, $ff, $00, $ff, $00, $7f, $80
	db $df, $e0, $ef, $70, $ef, $70, $ef, $70, $de, $e0, $be, $c0, $f8, $00, $c0, $00
	db $03, $00, $0e, $01, $1d, $03, $3d, $03, $7e, $01, $7f, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $7f, $00, $3f, $00, $0f, $00
	db $07, $00, $3f, $00, $fe, $01, $fd, $03, $fd, $03, $fe, $01, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $07, $00, $0f, $00, $1f, $00, $1f, $00
	db $3f, $00, $3f, $00, $7f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00
	db $07, $00, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $AB: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesAB::
	db $01, $00, $0f, $01, $1f, $0c, $1f, $0b, $3f, $02, $4f, $3b, $43, $3c, $42, $3d
	db $70, $0f, $bf, $70, $bf, $7f, $5f, $3f, $30, $0f, $0f, $00, $04, $03, $03, $00
	db $f0, $00, $fc, $f0, $ff, $3c, $ff, $df, $ff, $df, $ff, $8f, $bf, $77, $0f, $f7
	db $4f, $b7, $ff, $0f, $ff, $ff, $ff, $ff, $3f, $ff, $ff, $7f, $00, $ff, $ff, $00
	db $00, $00, $00, $00, $00, $00, $c0, $00, $e0, $c0, $f0, $e0, $f8, $f0, $f8, $f0
	db $fc, $f8, $fc, $f8, $fe, $fc, $fe, $fc, $fa, $fc, $f2, $fc, $04, $f8, $f8, $00
	db $00, $00, $01, $00, $03, $01, $03, $01, $07, $00, $09, $07, $08, $07, $0c, $03
	db $0a, $05, $09, $06, $04, $03, $03, $00, $05, $03, $04, $03, $04, $03, $03, $00
	db $3e, $00, $ff, $3e, $ff, $87, $ff, $7b, $ff, $5b, $ff, $71, $77, $8e, $41, $be
	db $09, $f6, $f3, $0c, $07, $fb, $ff, $07, $f8, $f7, $ff, $f8, $00, $ff, $ff, $00
	db $00, $00, $c0, $00, $f0, $c0, $f8, $f0, $fc, $f8, $fe, $fc, $fe, $fc, $ff, $fe
	db $ff, $3e, $ef, $fe, $ff, $ee, $df, $ee, $3d, $de, $f9, $3e, $02, $fc, $fc, $00
	db $39, $07, $39, $07, $7d, $03, $bf, $4d, $bf, $4d, $7d, $03, $39, $07, $39, $07
	db $39, $07, $39, $07, $39, $06, $7b, $35, $7b, $35, $39, $06, $39, $07, $39, $07
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $70, $00, $d8, $20, $f8, $00, $f8, $00, $74, $00, $02, $00, $02, $00, $02, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $AC: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesAC::
	db $00, $3c, $3c, $7e, $7e, $ff, $7e, $ff, $7e, $ff, $7e, $ff, $3c, $7e, $00, $3c
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $0f, $07, $1f, $0f
	db $00, $00, $00, $00, $00, $00, $e0, $00, $f0, $60, $78, $10, $1c, $08, $0e, $04
	db $0e, $04, $0f, $04, $0e, $05, $3f, $06, $7f, $21, $ff, $5e, $ff, $33, $f7, $a9
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $0c, $03, $13, $0f
	db $26, $1f, $e0, $3f, $70, $bf, $f0, $7f, $f0, $ff, $70, $ff, $b1, $7e, $e0, $bf
	db $0f, $0f, $10, $1f, $28, $3f, $53, $7f, $54, $7f, $a4, $ff, $29, $ff, $a9, $7f
	db $92, $7e, $cf, $3f, $e0, $1f, $20, $df, $00, $ff, $80, $7f, $60, $9f, $e1, $9f
	db $00, $00, $80, $80, $80, $80, $00, $00, $80, $80, $81, $81, $06, $07, $09, $0f
	db $32, $3f, $c4, $ff, $09, $ff, $0a, $ff, $04, $ff, $02, $ff, $03, $ff, $81, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f8, $f8, $06, $fe, $81, $ff
	db $03, $ff, $7d, $ff, $81, $ff, $1e, $fe, $61, $ff, $82, $fe, $0c, $fc, $f0, $f0
	db $13, $0f, $1d, $03, $1a, $0d, $17, $0a, $3d, $02, $57, $38, $bb, $7c, $99, $7e
	db $80, $7f, $60, $1f, $18, $07, $0c, $03, $06, $01, $03, $00, $01, $00, $00, $00
	db $ff, $a1, $ff, $b3, $fe, $df, $71, $ee, $0e, $f1, $87, $78, $c4, $bb, $44, $bb
	db $e2, $1d, $e1, $1e, $60, $9f, $30, $cf, $10, $ef, $10, $ef, $99, $66, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $AD: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesAD::
	db $ff, $48, $ff, $4a, $ff, $d2, $ff, $94, $ff, $24, $ff, $c4, $ff, $08, $ff, $08
	db $ff, $08, $fb, $0c, $fd, $86, $fa, $87, $fa, $87, $b2, $cf, $86, $ff, $0c, $ff
	db $f1, $8f, $bc, $cf, $be, $df, $be, $df, $be, $df, $ac, $df, $c0, $ff, $46, $ff
	db $a6, $7f, $9f, $7f, $1f, $ff, $1c, $ff, $18, $ff, $18, $ff, $18, $ff, $18, $ff
	db $80, $ff, $00, $ff, $38, $ff, $78, $ff, $38, $ff, $19, $ff, $81, $ff, $18, $ff
	db $1c, $ff, $3e, $ff, $ff, $ff, $81, $ff, $00, $ff, $3f, $ff, $c0, $ff, $8c, $ff
	db $20, $e0, $10, $f0, $08, $f8, $09, $f9, $06, $ff, $84, $ff, $82, $ff, $01, $ff
	db $61, $ff, $e0, $ff, $f0, $ff, $fe, $ff, $ff, $ff, $cf, $ff, $80, $ff, $81, $ff
	db $00, $00, $3c, $3c, $c2, $fe, $3a, $fe, $41, $ff, $9a, $fe, $61, $ff, $02, $fe
	db $1c, $fc, $a8, $f8, $86, $fe, $bc, $fc, $82, $fe, $82, $fe, $bc, $fc, $88, $f8
	db $8e, $ff, $80, $ff, $83, $ff, $98, $ff, $44, $7f, $46, $7f, $23, $3f, $11, $1f
	db $08, $0f, $06, $07, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $10, $ff, $20, $ff, $c0, $ff, $00, $ff, $01, $ff, $03, $ff, $fe, $ff, $fc, $ff
	db $00, $ff, $00, $ff, $83, $ff, $7c, $7f, $26, $3f, $13, $1f, $0f, $0f, $00, $00
	db $30, $ff, $30, $ff, $61, $ff, $c1, $ff, $86, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $f0, $ff, $4f, $ff, $22, $fe, $11, $ff, $89, $ff, $7e, $7e
;@ path: gfx/sprites/entities
;@ Entity graphics set $AE: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesAE::
	db $f3, $ff, $8c, $ff, $f0, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $01, $ff
	db $01, $ff, $03, $ff, $0c, $ff, $fc, $ff, $02, $03, $01, $01, $00, $00, $00, $00
	db $03, $ff, $0e, $ff, $12, $f3, $22, $e3, $79, $f9, $c4, $fc, $c3, $ff, $20, $ff
	db $18, $ff, $87, $ff, $60, $ff, $1f, $ff, $00, $ff, $81, $ff, $7e, $7e, $00, $00
	db $24, $fc, $9c, $fc, $42, $fe, $21, $ff, $1d, $ff, $83, $ff, $62, $7e, $9c, $9c
	db $80, $80, $80, $80, $40, $c0, $80, $80, $40, $c0, $80, $80, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $18, $18, $3c, $18, $3c, $00, $18, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $0f, $07, $1f, $0f
	db $13, $0f, $1d, $03, $1a, $0d, $17, $0a, $1d, $02, $1f, $00, $3f, $08, $4f, $32
	db $9b, $7c, $bd, $7e, $98, $7f, $60, $1f, $18, $07, $0e, $01, $03, $00, $01, $00
	db $30, $30, $48, $78, $bc, $fc, $44, $fc, $84, $fc, $3c, $fc, $44, $fc, $18, $f8
	db $28, $f8, $86, $fe, $81, $ff, $af, $ff, $81, $ff, $9e, $fe, $81, $ff, $02, $fe
	db $4c, $fc, $38, $f8, $84, $fc, $44, $fc, $38, $f8, $84, $fc, $44, $7c, $b8, $b8
	db $80, $80, $80, $80, $40, $c0, $80, $80, $40, $c0, $80, $80, $00, $00, $00, $00
	db $00, $00, $00, $00, $22, $22, $14, $14, $08, $08, $14, $14, $22, $22, $00, $00
	db $00, $00, $00, $00, $22, $22, $14, $14, $08, $08, $14, $14, $22, $22, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $AF: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesAF::
	db $00, $00, $00, $00, $22, $22, $14, $14, $08, $08, $14, $14, $22, $22, $00, $00
	db $00, $00, $00, $00, $22, $22, $14, $14, $08, $08, $14, $14, $22, $22, $00, $00
	db $00, $00, $00, $00, $1c, $1c, $22, $22, $22, $22, $22, $22, $1c, $1c, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $07, $00, $08, $07, $17, $0f, $2f, $1f, $4f, $3f, $e3, $1f, $9b, $67, $8e, $71
	db $83, $7c, $80, $7f, $60, $1f, $1c, $03, $06, $01, $01, $00, $00, $00, $00, $00
	db $00, $00, $c0, $00, $b0, $c0, $cc, $f0, $fa, $fc, $f5, $fa, $c9, $f6, $d1, $ee
	db $b1, $4e, $42, $bc, $44, $b8, $48, $b0, $50, $a0, $e0, $00, $00, $00, $00, $00
	db $c0, $d0, $c0, $c8, $00, $08, $39, $00, $77, $38, $fd, $1b, $f4, $bb, $7e, $c1
	db $b7, $68, $7f, $26, $df, $6e, $af, $dd, $cf, $33, $4f, $3f, $30, $0f, $0f, $00
	db $00, $00, $70, $00, $d0, $60, $d0, $e0, $c8, $30, $ab, $d0, $1f, $e3, $cc, $37
	db $fb, $07, $fb, $07, $ec, $57, $ef, $f3, $db, $e0, $38, $c0, $74, $b8, $b2, $1c
	db $00, $d0, $00, $c8, $00, $08, $39, $00, $77, $38, $fd, $1b, $f4, $bb, $7e, $c1
	db $b7, $68, $ff, $a7, $df, $ef, $af, $5e, $4f, $31, $4f, $3f, $30, $0f, $0f, $00
	db $00, $00, $70, $00, $f0, $60, $f0, $e0, $f8, $30, $bb, $d0, $1f, $e2, $cd, $36
	db $fb, $06, $fb, $06, $ed, $56, $ef, $f2, $db, $e0, $38, $c0, $7c, $b8, $be, $1c
;@ path: gfx/sprites/entities
;@ Entity graphics set $B0: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB0::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $01, $00, $00, $00, $00, $00, $01, $00, $01, $00, $06, $01, $0a, $05
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $03, $00, $cc, $03
	db $33, $cf, $4f, $bc, $9f, $70, $bf, $60, $7f, $c0, $7f, $c0, $fe, $81, $fd, $83
	db $0a, $05, $06, $01, $01, $00, $01, $00, $02, $01, $02, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $fd, $83, $fe, $81, $7f, $c0, $7f, $c0, $dd, $3e, $be, $7f, $ff, $67, $ff, $63
	db $be, $73, $5d, $3e, $3e, $00, $48, $30, $90, $60, $b0, $60, $b0, $60, $60, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $71, $00, $8a, $71, $e5, $7b, $77, $0b, $0f, $02, $07, $02, $05, $03, $02, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $33, $00, $4c, $33
	db $f3, $0f, $df, $ec, $ef, $f0, $ff, $30, $ff, $30, $ff, $70, $ee, $f1, $dd, $e3
	db $0a, $05, $05, $03, $3f, $03, $47, $3b, $8f, $73, $d5, $63, $63, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $dd, $e3, $ee, $f1, $ff, $30, $ff, $30, $ed, $3e, $fe, $ff, $3f, $e3, $bf, $63
	db $7e, $3f, $5d, $3e, $3e, $01, $15, $08, $24, $18, $64, $38, $48, $30, $30, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B1: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB1::
	db $e7, $00, $b8, $47, $e7, $1f, $4f, $38, $5f, $30, $bf, $60, $be, $61, $bd, $63
	db $bd, $63, $be, $61, $bf, $60, $5f, $30, $4f, $38, $e7, $1f, $b8, $47, $e7, $00
	db $00, $00, $73, $00, $5c, $23, $73, $0f, $27, $1c, $2f, $18, $5f, $30, $5e, $31
	db $5e, $31, $5f, $30, $2f, $18, $27, $1c, $73, $0f, $5c, $23, $73, $00, $00, $00
	db $01, $00, $03, $01, $03, $01, $0f, $01, $12, $0d, $17, $08, $7f, $00, $f7, $79
	db $f7, $79, $7f, $00, $17, $08, $12, $0d, $0f, $01, $03, $01, $03, $01, $01, $00
	db $00, $00, $30, $00, $79, $30, $77, $39, $23, $1d, $13, $0c, $1f, $00, $3f, $19
	db $3f, $19, $1f, $00, $13, $0c, $23, $1d, $77, $39, $79, $30, $30, $00, $00, $00
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
	db $00, $ff, $00, $ff, $22, $dd, $14, $eb, $08, $f7, $14, $eb, $22, $dd, $00, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $B2: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB2::
	db $00, $00, $00, $00, $00, $30, $30, $48, $40, $80, $00, $80, $1e, $01, $3f, $00
	db $27, $18, $03, $24, $01, $02, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $00, $08, $03, $84
	db $c0, $20, $f0, $08, $ff, $00, $ff, $00, $3f, $c0, $0f, $30, $00, $0f, $00, $00
	db $00, $3c, $0c, $72, $1a, $fd, $3d, $fe, $1c, $ff, $0c, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $7f, $00, $7f, $00, $3f, $01, $1e, $02, $0d, $00, $00, $00, $00
	db $07, $00, $0a, $07, $0e, $07, $0f, $90, $9f, $40, $9f, $40, $5f, $80, $4f, $90
	db $47, $88, $40, $83, $83, $53, $88, $14, $04, $9b, $03, $0c, $00, $07, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01
	db $03, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $04, $03, $08, $07, $0b, $04
	db $0f, $00, $0f, $00, $07, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $0f, $00, $10, $0f, $20, $1f, $27, $18, $2f, $10, $3f, $00
	db $3f, $00, $3f, $00, $3f, $00, $3f, $00, $1f, $00, $0f, $00, $00, $00, $00, $00
	db $1f, $00, $20, $1f, $40, $3f, $9f, $60, $bf, $40, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $3f, $00, $1f, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B3: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB3::
	db $00, $00, $00, $00, $60, $00, $18, $00, $0e, $00, $03, $00, $01, $00, $00, $00
	db $00, $02, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $c0, $00
	db $60, $00, $30, $00, $98, $40, $4c, $20, $26, $10, $13, $08, $00, $00, $00, $00
	db $00, $00, $00, $00, $70, $00, $3c, $00, $1f, $00, $0f, $00, $07, $00, $03, $10
	db $01, $08, $04, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $08, $00, $04, $00, $02, $80, $02, $c0, $01, $a0, $41
	db $d0, $21, $f8, $00, $7c, $00, $1e, $80, $c7, $20, $31, $02, $00, $01, $00, $00
	db $1f, $00, $3f, $00, $5f, $20, $7f, $00, $3f, $00, $3f, $00, $1f, $00, $0f, $40
	db $07, $20, $13, $08, $09, $04, $04, $02, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $08, $c0, $04, $e2, $00, $f1, $00, $f9, $00, $7c, $c1, $bc, $60, $de, $20
	db $fe, $00, $ff, $00, $ff, $00, $7f, $00, $1d, $82, $c7, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c
	db $00, $10, $07, $00, $08, $07, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $03, $80, $00, $60, $80, $1f, $60, $00, $1f, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B4: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB4::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01
	db $04, $03, $08, $06, $10, $0c, $10, $0b, $21, $16, $23, $14, $47, $38, $4c, $33
	db $00, $00, $00, $00, $00, $00, $03, $00, $1c, $03, $60, $1c, $80, $60, $00, $80
	db $00, $1f, $00, $7f, $0f, $f0, $7f, $80, $f0, $0f, $c0, $3f, $00, $f0, $00, $80
	db $c8, $36, $d0, $2c, $d0, $28, $c0, $38, $c0, $38, $60, $1c, $60, $1e, $30, $0f
	db $38, $07, $1c, $03, $0e, $01, $07, $00, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $0c, $03, $11, $0f, $23, $1d, $27, $18
	db $27, $d8, $27, $d8, $2b, $dc, $94, $6f, $ef, $13, $ff, $00, $3f, $00, $03, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $04, $03
	db $04, $02, $08, $06, $08, $04, $10, $0c, $10, $09, $30, $0b, $31, $0e, $33, $0c
	db $00, $00, $0f, $00, $30, $0f, $40, $3c, $80, $70, $00, $c0, $00, $80, $00, $00
	db $00, $00, $00, $07, $00, $3f, $00, $ff, $1f, $e0, $7f, $80, $e0, $18, $80, $60
	db $33, $0c, $36, $09, $34, $0a, $34, $0a, $30, $0e, $38, $06, $18, $07, $1c, $03
	db $0c, $03, $0e, $01, $07, $00, $03, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $c0, $00, $f0, $00, $ff, $80, $7f, $e0, $1f, $ff, $00, $3f, $00, $03, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B5: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB5::
	db $00, $00, $00, $00, $1f, $00, $e0, $1f, $00, $e0, $00, $00, $00, $00, $00, $ff
	db $00, $ff, $ff, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00
	db $07, $00, $18, $07, $20, $1f, $41, $3f, $43, $3f, $87, $79, $8f, $70, $8f, $70
	db $8f, $70, $8f, $70, $57, $b8, $5b, $3c, $2f, $5f, $1b, $e7, $ff, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c3, $00, $3c, $c3
	db $00, $7e, $00, $00, $00, $00, $00, $c3, $81, $7e, $ff, $00, $7c, $83, $00, $ff
	db $00, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7e
	db $00, $ff, $00, $ff, $7e, $81, $ff, $00, $c3, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00
	db $60, $80, $18, $60, $07, $18, $00, $cf, $80, $60, $c0, $38, $f8, $07, $3f, $c0
	db $07, $78, $00, $1f, $00, $07, $00, $00, $00, $03, $00, $0f, $03, $3c, $0e, $70
	db $18, $e0, $30, $c0, $60, $80, $c0, $00, $80, $00, $00, $00, $00, $00, $00, $00
	db $07, $78, $00, $1f, $03, $04, $0f, $10, $18, $24, $30, $48, $20, $d0, $60, $90
	db $60, $90, $c0, $20, $c0, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $00, $00, $ff, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B6: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB6::
	db $01, $00, $03, $01, $03, $01, $63, $01, $f3, $61, $fb, $71, $7f, $39, $3f, $0f
	db $0f, $07, $0f, $03, $7f, $0f, $ff, $7f, $ff, $78, $7f, $07, $7f, $1d, $bf, $58
	db $80, $00, $c0, $80, $c0, $80, $cc, $80, $de, $8c, $fe, $9c, $fc, $b8, $f8, $70
	db $fe, $60, $ff, $ee, $ff, $dc, $ff, $b0, $ff, $7b, $ff, $db, $ff, $c3, $f3, $cd
	db $0e, $00, $1d, $0e, $1d, $0e, $11, $0e, $0e, $00, $06, $00, $03, $00, $1f, $00
	db $3f, $00, $6b, $1c, $ff, $00, $df, $67, $ff, $ae, $ff, $3d, $bf, $5b, $ff, $1b
	db $9d, $62, $80, $7f, $80, $7f, $82, $7d, $85, $7a, $45, $3a, $45, $3a, $24, $1b
	db $1c, $03, $04, $03, $02, $01, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00
	db $e7, $1d, $69, $96, $e4, $5b, $f4, $4b, $f2, $ed, $f1, $ee, $f8, $17, $3c, $db
	db $3f, $dc, $7f, $bf, $7f, $b1, $73, $8d, $03, $fc, $c0, $3f, $30, $0f, $0f, $00
	db $ff, $d1, $fb, $d5, $ff, $02, $76, $b9, $80, $ff, $ff, $00, $d3, $2c, $92, $6d
	db $92, $6d, $d7, $6c, $ef, $7d, $bb, $7d, $c5, $3a, $38, $c7, $00, $ff, $c3, $3c
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $87, $00, $d8, $07, $e0, $1f, $e0, $df, $ec, $d3, $ff, $cc, $ff, $cf
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $e0, $00, $18, $e0, $04, $f8, $04, $f8, $c2, $3c, $e2, $dc, $e1, $de
;@ path: gfx/sprites/entities
;@ Entity graphics set $B7: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB7::
	db $ff, $81, $ff, $7e, $ff, $7f, $7f, $87, $5f, $af, $bf, $5f, $7f, $b9, $ff, $71
	db $fb, $75, $ff, $09, $ff, $99, $df, $a1, $c3, $3d, $01, $fe, $06, $f8, $f8, $00
	db $fd, $c2, $fd, $7a, $fd, $ba, $fe, $d8, $ff, $ee, $ff, $ee, $ff, $f4, $fe, $b8
	db $fe, $9c, $fe, $8c, $ec, $80, $c0, $80, $c0, $80, $80, $00, $00, $00, $00, $00
	db $a5, $5a, $82, $7c, $a4, $78, $a8, $70, $74, $38, $5a, $3c, $2d, $1e, $1f, $0e
	db $1f, $0e, $3e, $1c, $7c, $38, $78, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $07, $00, $0b, $07, $17, $0c, $17, $0c, $13, $0f, $08, $07, $07, $00, $02, $01
	db $06, $01, $0a, $05, $16, $0d, $35, $0e, $53, $2f, $68, $37, $b7, $78, $98, $67
	db $bf, $5b, $fe, $3d, $fe, $35, $be, $5d, $9c, $63, $40, $3f, $30, $0f, $0f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $01, $02, $01, $02, $01
	db $01, $00, $00, $00, $00, $00, $01, $00, $01, $00, $02, $01, $06, $01, $0a, $05
	db $00, $00, $00, $00, $00, $00, $f0, $00, $7c, $f0, $fe, $8c, $fd, $86, $7d, $c6
	db $3d, $fe, $82, $7c, $fc, $00, $10, $e0, $20, $c0, $40, $80, $60, $80, $50, $a0
	db $0e, $05, $1b, $06, $29, $17, $34, $1b, $7b, $2c, $7c, $2f, $77, $2f, $71, $2e
	db $73, $2d, $67, $1b, $47, $3a, $47, $3b, $23, $1d, $21, $1e, $18, $07, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B8: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB8::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $01, $00, $02, $01, $02, $01, $05, $03, $05, $03, $05, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $18, $07, $67, $1f
	db $9f, $78, $3f, $e0, $7f, $c0, $ff, $80, $ff, $80, $ff, $00, $fe, $01, $fd, $03
	db $05, $03, $05, $03, $04, $03, $02, $01, $02, $01, $01, $00, $01, $00, $00, $00
	db $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $07, $fe, $8f, $fd, $8e, $7d, $ce, $7f, $c6, $ff, $06, $ff, $72
	db $ff, $fa, $ff, $ca, $ff, $ca, $ff, $76, $77, $0e, $13, $0e, $09, $06, $06, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00
	db $0f, $07, $1f, $0f, $1f, $09, $3f, $09, $4f, $37, $9f, $78, $bf, $7f, $7f, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $18, $07, $63, $1f
	db $cf, $3c, $ff, $b0, $ff, $80, $ff, $80, $ff, $1c, $ff, $7e, $e7, $fe, $fb, $06
	db $0f, $01, $1f, $0e, $3f, $1f, $3f, $13, $3f, $13, $1f, $0e, $1f, $01, $17, $0f
	db $17, $0e, $13, $0d, $0d, $03, $04, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $ff, $1d, $ff, $3e, $f3, $3f, $eb, $77, $f7, $6f, $ff, $de, $ff, $b8, $ff, $60
	db $ff, $dd, $ff, $be, $ff, $a6, $7f, $a6, $fe, $1c, $1c, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $B9: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesB9::
	db $07, $00, $18, $07, $27, $1f, $4f, $38, $5f, $30, $bf, $60, $be, $61, $bd, $63
	db $bd, $63, $be, $61, $bf, $60, $5f, $30, $4f, $38, $27, $1f, $18, $07, $07, $00
	db $00, $00, $03, $00, $0c, $03, $13, $0f, $27, $1c, $2f, $18, $5f, $30, $5e, $31
	db $5e, $31, $5f, $30, $2f, $18, $27, $1c, $13, $0f, $0c, $03, $03, $00, $00, $00
	db $01, $01, $03, $02, $3f, $3d, $3f, $21, $3f, $28, $3f, $26, $7b, $46, $ff, $b0
	db $cf, $b0, $7f, $46, $3d, $26, $3f, $28, $3e, $21, $3e, $3d, $03, $02, $01, $01
	db $7f, $38, $ff, $7c, $ff, $64, $ff, $64, $7f, $38, $39, $06, $17, $0e, $17, $0e
	db $09, $06, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $05, $03, $05, $03, $07, $00, $0f, $07, $1f, $0f, $1f, $09, $1f, $09, $0f, $07
	db $0f, $00, $0b, $07, $0b, $07, $07, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $07, $fc, $0f, $fb, $1c, $fc, $98, $fc, $b8, $fe, $b4, $fe, $60
	db $e0, $c0, $e0, $80, $f0, $60, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $07, $00, $18, $07, $23, $1f, $4f, $3f, $5f, $33, $93, $6d, $bf, $60, $bf, $60
	db $bf, $60, $bf, $70, $9f, $78, $5f, $3c, $4f, $3e, $23, $1f, $18, $07, $07, $00
	db $07, $00, $18, $07, $23, $1f, $4f, $3f, $5f, $3f, $9f, $7f, $bf, $79, $bd, $7a
	db $bf, $78, $bf, $7c, $9f, $7e, $5f, $3f, $4f, $3f, $23, $1f, $18, $07, $07, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $BA: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesBA::
	db $00, $00, $00, $00, $02, $00, $07, $02, $07, $03, $07, $03, $2f, $07, $7f, $27
	db $7e, $27, $2e, $07, $0e, $07, $0f, $07, $2f, $07, $7e, $2f, $7c, $3f, $7c, $3f
	db $10, $00, $38, $10, $39, $10, $3b, $11, $93, $01, $87, $03, $c7, $83, $ef, $c7
	db $fd, $ef, $7b, $ff, $ff, $ff, $fc, $ff, $78, $ff, $30, $ff, $30, $ff, $20, $ff
	db $40, $00, $e1, $40, $f3, $e1, $b7, $e3, $b6, $e3, $3e, $f7, $1c, $ff, $1c, $ff
	db $1c, $ff, $be, $ff, $bf, $ff, $ff, $ff, $fb, $ff, $f3, $ff, $33, $ff, $21, $ff
	db $04, $00, $0e, $04, $9e, $0c, $d6, $8c, $cc, $80, $c0, $80, $e0, $c0, $e4, $c0
	db $ee, $c4, $fe, $e4, $ff, $ee, $ff, $fe, $fb, $fe, $bb, $fe, $3b, $fe, $1f, $fe
	db $f9, $7f, $fa, $7f, $d1, $7e, $d1, $7e, $f1, $7e, $ec, $73, $ee, $71, $e6, $79
	db $67, $38, $77, $38, $33, $1c, $39, $1e, $1c, $0f, $0f, $07, $07, $01, $01, $00
	db $e0, $ff, $f0, $1f, $fc, $0f, $fe, $07, $fb, $27, $fb, $07, $77, $8f, $1f, $ff
	db $f7, $f8, $6f, $f0, $9f, $60, $fc, $03, $f0, $0f, $07, $ff, $ff, $fc, $fc, $00
	db $01, $00, $07, $00, $0f, $00, $1e, $01, $15, $0b, $25, $1a, $21, $1e, $2d, $1e
	db $3e, $13, $3f, $11, $3f, $10, $1f, $08, $1d, $0e, $0f, $07, $07, $01, $01, $00
	db $fe, $00, $ff, $00, $0f, $f0, $f7, $f8, $fb, $0c, $fb, $04, $fa, $25, $f9, $07
	db $f3, $0f, $8f, $fc, $ff, $f8, $ff, $00, $fc, $03, $03, $ff, $ff, $ff, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $BB: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesBB::
	db $00, $00, $00, $00, $18, $00, $1c, $08, $1e, $0c, $0f, $06, $0a, $07, $04, $03
	db $04, $03, $04, $03, $08, $07, $01, $2e, $00, $27, $00, $30, $00, $1c, $00, $00
	db $00, $00, $40, $00, $e1, $40, $e3, $41, $d5, $63, $f4, $63, $a8, $77, $bb, $74
	db $8f, $70, $8e, $71, $8e, $71, $06, $f9, $04, $fb, $00, $0f, $00, $e3, $00, $18
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $1e, $01
	db $3e, $1f, $01, $3f, $00, $1f, $06, $09, $0a, $07, $14, $0f, $10, $0f, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $c4, $03, $a5, $c3, $58, $e7
	db $00, $ff, $0f, $f0, $3f, $c0, $cc, $f3, $20, $ff, $01, $df, $00, $07, $00, $03
	db $00, $00, $00, $00, $01, $00, $33, $01, $7b, $31, $4e, $39, $26, $1d, $10, $0f
	db $3c, $03, $7f, $3c, $40, $3f, $3d, $03, $04, $03, $02, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $01, $00, $03, $01, $02, $01, $61, $00, $f0, $60, $88, $70
	db $70, $00, $00, $00, $38, $00, $68, $30, $d1, $60, $93, $61, $62, $01, $01, $00
	db $03, $00, $f4, $03, $db, $64, $6c, $33, $39, $07, $7b, $07, $e7, $1b, $db, $3d
	db $dd, $26, $6e, $1b, $5f, $3b, $bb, $75, $fd, $66, $e6, $43, $43, $00, $00, $00
	db $87, $00, $cc, $03, $7b, $84, $b4, $4b, $cb, $b4, $ff, $c4, $ff, $27, $ff, $27
	db $ff, $e0, $ee, $1f, $7f, $ff, $ff, $f3, $ff, $00, $fe, $65, $ff, $20, $30, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $BC: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesBC::
	db $00, $00, $00, $00, $0e, $00, $17, $0e, $2c, $1b, $3c, $13, $4c, $37, $48, $3f
	db $80, $7f, $81, $7f, $83, $7f, $cf, $7e, $ff, $78, $fc, $63, $f2, $41, $e1, $00
	db $03, $00, $04, $03, $0b, $04, $1f, $00, $ff, $18, $ff, $d0, $1f, $f6, $0f, $f2
	db $1f, $e4, $9f, $f3, $cd, $fe, $c2, $7d, $fc, $73, $70, $8f, $04, $fb, $fb, $00
	db $e0, $00, $c0, $00, $f0, $00, $f8, $70, $f8, $20, $fc, $70, $ff, $f8, $ff, $ff
	db $db, $37, $e4, $db, $e6, $59, $45, $b8, $48, $b0, $70, $80, $40, $80, $80, $00
	db $07, $00, $0f, $07, $1f, $0f, $3f, $18, $3f, $10, $3f, $14, $3f, $10, $3f, $1b
	db $1e, $07, $3f, $1f, $77, $39, $4f, $3e, $27, $1f, $73, $0f, $f9, $07, $df, $e0
	db $e0, $00, $f0, $e0, $f8, $f0, $fc, $78, $fc, $70, $ff, $c0, $ff, $3e, $ef, $f1
	db $ff, $3e, $ff, $cf, $ff, $f0, $ff, $70, $ff, $80, $ff, $80, $e7, $98, $f3, $0c
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $00, $fc, $00, $fe, $00
	db $ff, $00, $e7, $00, $f3, $00, $ff, $03, $7f, $83, $3f, $c1, $bf, $51, $bf, $5e
	db $ff, $e0, $7f, $e0, $1e, $e1, $bf, $40, $ff, $00, $7f, $00, $3f, $00, $3f, $00
	db $1a, $01, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $f8, $07, $78, $87, $39, $c6, $01, $fe, $07, $f8, $00, $ff, $80, $7f, $80, $7f
	db $00, $ff, $00, $ff, $18, $ff, $e7, $1f, $18, $07, $07, $00, $00, $00, $00, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $BD: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesBD::
	db $0c, $ff, $18, $ef, $23, $dc, $c4, $3b, $0e, $ff, $1e, $ff, $0e, $ff, $00, $ff
	db $11, $ee, $3f, $c0, $08, $f0, $90, $e0, $60, $80, $80, $00, $00, $00, $00, $00
	db $78, $00, $ff, $00, $ff, $80, $fe, $98, $fc, $70, $f8, $c0, $7e, $80, $fd, $0e
	db $f9, $26, $fd, $26, $f1, $1e, $f6, $78, $c8, $30, $70, $80, $c0, $00, $80, $00
	db $06, $00, $0e, $00, $1e, $00, $3f, $00, $7f, $00, $7f, $01, $ff, $0f, $ff, $5f
	db $ff, $5f, $ef, $5f, $ff, $6f, $bf, $6f, $77, $2f, $7f, $37, $7f, $37, $5f, $37
	db $00, $00, $03, $00, $1f, $00, $ff, $00, $ff, $7c, $ff, $fc, $ff, $f8, $ff, $f0
	db $cf, $fc, $ff, $fc, $ff, $f8, $f7, $fe, $ef, $fe, $ff, $fc, $ff, $fa, $f7, $fe
	db $7e, $00, $fe, $00, $fc, $00, $f0, $00, $ff, $00, $ff, $00, $fe, $00, $f0, $00
	db $c0, $00, $fc, $00, $fe, $00, $fc, $00, $f0, $00, $c0, $00, $f0, $00, $e0, $00
	db $c0, $00, $f8, $00, $fc, $78, $ff, $f0, $ff, $3f, $fb, $7f, $f3, $ff, $e5, $fb
	db $04, $fb, $c4, $3b, $44, $bb, $4c, $b3, $72, $81, $47, $80, $8f, $00, $0f, $00
	db $3f, $17, $3b, $17, $3f, $1b, $bf, $1b, $bf, $1b, $bf, $1b, $ff, $9b, $ff, $db
	db $ff, $db, $7b, $d7, $6f, $d7, $7f, $87, $ff, $0f, $ff, $0f, $ff, $1f, $ff, $1e
	db $ff, $fc, $fe, $f8, $ff, $f0, $ef, $f8, $ff, $f8, $fe, $f0, $ff, $f8, $ff, $f8
	db $ff, $c0, $fc, $e0, $f8, $e0, $f8, $00, $e0, $80, $ec, $80, $fc, $00, $ff, $00
;@ path: gfx/sprites/entities
;@ Entity graphics set $BE: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesBE::
	db $00, $00, $00, $00, $00, $00, $36, $00, $4f, $36, $d9, $6e, $fd, $02, $ff, $6c
	db $7e, $24, $24, $00, $00, $00, $0e, $00, $0f, $06, $07, $02, $03, $00, $00, $00
	db $0f, $00, $0f, $04, $1f, $0f, $7f, $03, $df, $6d, $b3, $de, $f9, $06, $fd, $da
	db $fd, $4b, $fd, $03, $a7, $59, $9e, $61, $fc, $1b, $7e, $8d, $2f, $c0, $c0, $00
	db $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3d, $df, $f2, $3d
	db $f2, $7d, $e3, $7c, $82, $7c, $c4, $b8, $64, $d8, $98, $60, $90, $60, $60, $00
	db $ff, $90, $ef, $b0, $ee, $f0, $dc, $e0, $bc, $c0, $0e, $f0, $0e, $f0, $1e, $e0
	db $78, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $0e, $00, $3f, $00, $7f, $00, $ff, $00, $ff, $00, $f7, $08, $e7, $18, $f6, $e9
	db $f6, $e9, $70, $ef, $70, $cf, $70, $8f, $f0, $0f, $f0, $0f, $fc, $1f, $ff, $1e
	db $00, $00, $c0, $00, $f0, $00, $f8, $00, $fc, $00, $fe, $00, $7e, $80, $77, $88
	db $77, $88, $66, $98, $0f, $f0, $0e, $f0, $78, $80, $3c, $c0, $7c, $80, $ff, $00
	db $c0, $00, $f8, $00, $fc, $78, $ff, $f0, $ff, $3f, $fb, $7f, $f3, $ff, $e5, $fb
	db $05, $fa, $c5, $3a, $47, $b8, $4f, $b0, $7f, $80, $5f, $81, $9f, $01, $3f, $03
	db $03, $00, $07, $03, $0f, $07, $1f, $0c, $ff, $08, $ff, $72, $ff, $7c, $ff, $7e
	db $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $fe, $ff, $ff, $ff, $ff
;@ path: gfx/sprites/entities
;@ Entity graphics set $BF: 16 sprite tiles (8 x 16 pairs) that LoadTileset09 copies to one of the four entity tile slots ($8400-$87FF) when a room's entity graphics set (OverworldSpritesets / IndoorSpritesets, through EntityTilesBanks) names it. 16 tiles.
;@ asset: tiles bpp=2 length=$100 tall
EntityTilesBF::
	db $e0, $00, $f8, $e0, $fc, $f8, $fc, $38, $fe, $3c, $fe, $7c, $fe, $e0, $fc, $80
	db $fe, $00, $fe, $80, $fe, $80, $fc, $00, $f0, $00, $ec, $00, $fc, $00, $ff, $00
	db $3f, $07, $5f, $2f, $5f, $2f, $ff, $1f, $ff, $5f, $fb, $bf, $ff, $3b, $ff, $b3
	db $ff, $22, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ef, $00, $2e, $c0, $cc, $00
	db $fd, $fe, $ff, $fe, $ff, $ff, $fb, $fd, $ff, $fc, $7f, $fe, $ef, $7e, $ff, $6e
	db $ff, $4e, $ff, $04, $ff, $00, $ff, $00, $7f, $00, $77, $00, $76, $00, $60, $00
	db $ff, $10, $ef, $30, $ee, $30, $dc, $20, $fc, $00, $ce, $30, $ce, $30, $9e, $60
	db $f8, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $07, $00, $0b, $07
	db $17, $0f, $1f, $0f, $7f, $1f, $ff, $60, $e0, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00, $fe, $00, $7c, $80
	db $b8, $c0, $b0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $c0, $00, $e0, $00, $f0, $00, $88, $70, $b8, $70, $bb, $70, $7f, $30, $3f, $06
	db $1f, $0f, $1f, $0d, $1f, $0d, $1f, $06, $0f, $00, $07, $00, $00, $00, $00, $00
	db $07, $00, $1f, $07, $3f, $1f, $7f, $23, $7f, $21, $7f, $25, $5f, $31, $7f, $0d
	db $ff, $07, $ff, $46, $ff, $62, $f7, $68, $7b, $04, $74, $1b, $fb, $7c, $fe, $00
