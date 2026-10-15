; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $00d", ROMX[$4000], BANK[$d]

;@ path: gfx/tiles/indoor
;@ Background tiles of all indoor maps at $9200-$97FF (LoadTileset06, tile set request 6); the maps' own pieces from the tables at $01:$7F64 and $01:$7F84 are copied over parts of them. 96 tiles.
;@ asset: tiles bpp=2 length=$600
IndoorCommonTiles::
	db $00, $00, $7f, $00, $70, $3f, $78, $3f, $5c, $3f, $4e, $3f, $47, $3f, $43, $3f
	db $00, $00, $fe, $00, $0e, $fc, $1e, $fc, $3a, $fc, $72, $fc, $e2, $fc, $c2, $fc
	db $43, $3f, $47, $3f, $4e, $3f, $5c, $3f, $78, $3f, $70, $3f, $7f, $00, $00, $00
	db $c2, $fc, $e2, $fc, $72, $fc, $3a, $fc, $1e, $fc, $0e, $fc, $fe, $00, $00, $00
	db $00, $3f, $20, $1f, $50, $8f, $28, $c7, $14, $e3, $0a, $f1, $05, $f8, $02, $fc
	db $00, $fc, $04, $f8, $0a, $f1, $14, $e3, $28, $c7, $50, $8f, $a0, $1f, $40, $3f
	db $02, $fc, $05, $f8, $0a, $f1, $14, $e3, $28, $c7, $50, $8f, $20, $1f, $00, $3f
	db $40, $3f, $a0, $1f, $50, $8f, $28, $c7, $14, $e3, $0a, $f1, $04, $f8, $00, $fc
	db $00, $00, $ff, $00, $60, $9f, $00, $ff, $00, $ff, $06, $ff, $06, $f9, $00, $ff
	db $ff, $ff, $ff, $ff, $00, $ff, $c0, $ff, $06, $f9, $f9, $06, $ff, $ff, $18, $ff
	db $40, $3f, $46, $3d, $46, $3d, $40, $3f, $40, $3f, $60, $1f, $60, $1f, $40, $3f
	db $63, $df, $53, $ef, $53, $ef, $e3, $df, $e3, $df, $63, $df, $6b, $df, $6b, $df
	db $81, $00, $7e, $81, $85, $fb, $81, $ff, $81, $ff, $e3, $ff, $f7, $3e, $3e, $dd
	db $ff, $ff, $ff, $ff, $c1, $bf, $e1, $df, $76, $eb, $fd, $36, $ff, $ff, $3c, $db
	db $be, $7d, $47, $3e, $63, $1f, $41, $3f, $43, $3f, $47, $3e, $46, $3d, $be, $7d
	db $6f, $df, $53, $ff, $f3, $6f, $e3, $df, $f3, $ef, $fb, $77, $7f, $db, $6f, $df
	db $c0, $ff, $ff, $ff, $7f, $f0, $70, $ff, $78, $df, $6c, $df, $67, $df, $63, $df
	db $03, $ff, $ff, $ff, $fe, $0f, $0e, $ff, $1e, $fb, $36, $fb, $e6, $fb, $c6, $fb
	db $63, $df, $63, $df, $66, $df, $6c, $df, $78, $df, $7f, $f0, $ff, $ff, $c0, $ff
	db $c6, $fb, $c6, $fb, $66, $fb, $36, $fb, $1e, $fb, $fe, $0f, $ff, $ff, $03, $ff
	db $63, $5f, $a3, $df, $c3, $1f, $13, $ef, $0b, $f7, $07, $fb, $ff, $ff, $ff, $ff
	db $c6, $fa, $c5, $fb, $c3, $f8, $c8, $f7, $d0, $ef, $e0, $df, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $07, $fb, $0b, $f7, $13, $ef, $c3, $1f, $a3, $df, $63, $5f
	db $ff, $ff, $ff, $ff, $e0, $df, $d0, $ef, $c8, $f7, $c3, $f8, $c5, $fb, $c6, $fa
	db $18, $ff, $ff, $ff, $f9, $06, $06, $f9, $c0, $ff, $00, $ff, $ff, $ff, $ff, $ff
	db $00, $ff, $06, $f9, $06, $ff, $00, $ff, $00, $ff, $60, $9f, $ff, $00, $00, $00
	db $c6, $fb, $ca, $f7, $ca, $f7, $c7, $fb, $c7, $fb, $c6, $fb, $d6, $fb, $d6, $fb
	db $02, $fc, $62, $bc, $62, $bc, $02, $fc, $02, $fc, $06, $f8, $06, $f8, $02, $fc
	db $3c, $db, $ff, $ff, $fd, $36, $76, $eb, $e1, $df, $c1, $bf, $ff, $ff, $ff, $ff
	db $3e, $dd, $f7, $3e, $e3, $ff, $81, $ff, $81, $ff, $85, $fb, $7e, $81, $81, $00
	db $f6, $fb, $ca, $ff, $cf, $f6, $c7, $fb, $cf, $f7, $df, $ee, $fe, $db, $f6, $fb
	db $7d, $be, $e2, $7c, $c6, $f8, $82, $fc, $c2, $fc, $e2, $7c, $62, $bc, $7d, $be
	db $80, $80, $80, $80, $80, $80, $ff, $80, $c0, $bf, $c0, $bf, $c0, $bf, $c0, $bf
	db $01, $01, $01, $01, $01, $01, $ff, $01, $03, $fd, $03, $fd, $03, $fd, $03, $fd
	db $ff, $ff, $c0, $bc, $c1, $bd, $c1, $bd, $c1, $b9, $c3, $bb, $c3, $bb, $c0, $bc
	db $ff, $ff, $03, $3d, $83, $bd, $83, $bd, $83, $9d, $c3, $dd, $c3, $dd, $03, $3d
	db $ff, $ff, $1f, $00, $10, $0f, $10, $0f, $10, $0f, $10, $0f, $10, $0f, $10, $0f
	db $ff, $ff, $ff, $01, $01, $ff, $01, $ff, $01, $ff, $01, $8f, $61, $61, $7d, $7d
	db $ff, $ff, $ff, $80, $80, $ff, $80, $ff, $80, $ff, $80, $f1, $86, $86, $be, $be
	db $ff, $ff, $f8, $00, $08, $f0, $08, $f0, $08, $f0, $08, $f0, $08, $f0, $08, $f0
	db $bf, $ff, $bc, $ff, $fd, $ff, $f9, $ff, $1f, $ff, $ff, $ff, $f1, $ff, $f7, $ff
	db $bf, $ff, $bc, $ff, $fd, $ff, $f9, $ff, $9f, $ff, $ff, $ff, $ff, $3c, $ff, $18
	db $ff, $ff, $ff, $9e, $ff, $8c, $de, $80, $ed, $a1, $d2, $b3, $cc, $bf, $c0, $bf
	db $ff, $ff, $ff, $79, $ff, $31, $7b, $01, $b7, $85, $4b, $cd, $33, $fd, $03, $fd
	db $81, $81, $ff, $81, $ff, $ff, $66, $c3, $66, $c3, $7e, $e7, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $01, $17, $f1, $2f, $e3, $5f, $c7, $5f, $c7, $2f, $e3, $17, $f1
	db $ff, $ff, $ff, $80, $e8, $8f, $f4, $c7, $fa, $e3, $fa, $e3, $f4, $c7, $e8, $8f
	db $ff, $ff, $ff, $ff, $7e, $e7, $66, $c3, $66, $c3, $ff, $ff, $ff, $81, $81, $81
	db $c0, $bc, $c3, $bb, $c3, $bb, $c1, $b9, $c1, $bd, $c1, $bd, $c0, $bc, $ff, $ff
	db $03, $3d, $c3, $dd, $c3, $dd, $83, $9d, $83, $bd, $83, $bd, $03, $3d, $ff, $ff
	db $c0, $bf, $c0, $bf, $c0, $bf, $c0, $bf, $ff, $80, $80, $80, $80, $80, $80, $80
	db $03, $fd, $03, $fd, $03, $fd, $03, $fd, $ff, $01, $01, $01, $01, $01, $01, $01
	db $10, $0f, $10, $0f, $10, $0f, $10, $0f, $10, $0f, $10, $0f, $1f, $00, $ff, $ff
	db $7d, $7d, $61, $61, $01, $8f, $01, $ff, $01, $ff, $01, $ff, $ff, $01, $ff, $ff
	db $be, $be, $86, $86, $80, $f1, $80, $ff, $80, $ff, $80, $ff, $ff, $80, $ff, $ff
	db $08, $f0, $08, $f0, $08, $f0, $08, $f0, $08, $f0, $08, $f0, $f8, $00, $ff, $ff
	db $c0, $bf, $cc, $bf, $d2, $b3, $ed, $a1, $de, $80, $ff, $8c, $ff, $9e, $ff, $ff
	db $03, $fd, $33, $fd, $4b, $cd, $b7, $85, $7b, $01, $ff, $31, $ff, $79, $ff, $ff
	db $02, $00, $20, $00, $01, $00, $08, $00, $80, $00, $00, $00, $22, $00, $08, $00
	db $00, $00, $7e, $00, $7a, $00, $5e, $00, $7e, $00, $76, $00, $7e, $00, $00, $00
	db $e3, $ff, $7f, $3f, $7f, $27, $67, $23, $67, $23, $7f, $27, $7f, $3f, $e3, $ff
	db $17, $f1, $2f, $e3, $5f, $c7, $5f, $c7, $2f, $e3, $17, $f1, $ff, $01, $ff, $ff
	db $e8, $8f, $f4, $c7, $fa, $e3, $fa, $e3, $f4, $c7, $e8, $8f, $ff, $80, $ff, $ff
	db $c7, $ff, $fe, $fc, $fe, $e4, $e6, $c4, $e6, $c4, $fe, $e4, $fe, $fc, $c7, $ff
	db $ff, $ff, $80, $80, $9e, $9e, $9e, $92, $9e, $92, $9e, $92, $9e, $9e, $80, $80
	db $ff, $ff, $01, $01, $79, $79, $79, $49, $79, $49, $79, $49, $79, $79, $01, $01
	db $ff, $ff, $80, $80, $a0, $bf, $a0, $bf, $a0, $bf, $a0, $bf, $bf, $bf, $bf, $bf
	db $ff, $ff, $01, $01, $05, $fd, $05, $fd, $05, $fd, $05, $fd, $fd, $fd, $fd, $fd
	db $3f, $3f, $40, $40, $8f, $8f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $8f, $8f
	db $fc, $fc, $02, $02, $f1, $f1, $f9, $f9, $f9, $f9, $f9, $f9, $f9, $f9, $f1, $f1
	db $ff, $ff, $c0, $bf, $c1, $be, $c3, $bc, $c7, $b8, $ce, $b1, $cc, $b3, $c8, $b7
	db $ff, $ff, $03, $fd, $83, $7d, $c3, $3d, $e3, $1d, $73, $8d, $33, $cd, $13, $ed
	db $ff, $ff, $9f, $c1, $9f, $c1, $9f, $c1, $9f, $c1, $81, $c1, $81, $ff, $ff, $ff
	db $c3, $ff, $66, $7e, $3c, $3c, $18, $18, $40, $00, $01, $00, $3c, $00, $42, $00
	db $00, $ff, $00, $80, $20, $bf, $20, $bf, $3f, $bf, $3f, $bf, $3f, $bc, $3f, $bc
	db $00, $ff, $00, $01, $7c, $fd, $44, $c5, $c4, $c5, $c4, $c5, $c4, $45, $c4, $45
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $80, $ff, $ff, $d5, $9d, $d5, $9d, $d4, $9c, $df, $9f, $c0, $80, $ff, $ff
	db $01, $01, $ff, $ff, $ab, $b9, $ab, $b9, $2b, $39, $fb, $f9, $03, $01, $ff, $ff
	db $80, $80, $c7, $c0, $64, $e0, $34, $f0, $36, $f0, $63, $e0, $c0, $c0, $88, $80
	db $01, $01, $8b, $03, $46, $07, $2c, $0f, $6c, $0f, $c6, $07, $13, $03, $01, $01
	db $80, $80, $80, $c0, $80, $bf, $80, $80, $c4, $84, $e2, $42, $bf, $a0, $df, $ff
	db $01, $01, $01, $03, $01, $fd, $01, $01, $23, $21, $47, $42, $fd, $05, $fb, $ff
	db $d7, $38, $93, $7c, $10, $ff, $38, $ff, $7c, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3c, $ff, $18
	db $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00
	db $62, $00, $3c, $00, $18, $00, $40, $00, $1a, $18, $3c, $3c, $66, $7e, $c3, $ff
	db $3f, $bc, $27, $bc, $27, $bc, $27, $bc, $27, $bc, $3f, $bf, $00, $80, $00, $ff
	db $c4, $45, $c4, $45, $c4, $45, $c4, $45, $c4, $45, $fc, $fd, $00, $01, $00, $ff
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/tiles/indoor
;@ Page $46: copied to $9200 ($200 bytes) on the indoor maps whose entry in $01:$7F84 is $46. 32 tiles.
;@ asset: tiles bpp=2 length=$200
IndoorMapTiles46::
	db $00, $00, $07, $00, $04, $03, $04, $03, $0c, $03, $7c, $03, $60, $1f, $4f, $3f
	db $00, $00, $e0, $00, $60, $80, $20, $c0, $b0, $c0, $be, $c0, $82, $fc, $82, $fc
	db $41, $3f, $41, $3f, $7d, $03, $0d, $03, $04, $03, $06, $01, $07, $00, $00, $00
	db $f2, $fc, $06, $f8, $3e, $c0, $30, $c0, $20, $c0, $20, $c0, $e0, $00, $00, $00
	db $01, $0f, $0c, $03, $0e, $01, $8e, $01, $76, $81, $7a, $81, $bc, $c3, $80, $ff
	db $80, $f0, $30, $c0, $70, $80, $71, $80, $6e, $81, $5e, $81, $3d, $c3, $01, $ff
	db $80, $ff, $bc, $c3, $7a, $81, $76, $81, $8e, $01, $0e, $01, $0c, $03, $01, $0f
	db $01, $ff, $3d, $c3, $5e, $81, $6e, $81, $71, $80, $70, $80, $30, $c0, $80, $f0
	db $00, $00, $01, $00, $c2, $01, $66, $81, $3c, $c3, $b8, $c7, $b0, $cf, $90, $ef
	db $db, $e7, $66, $ff, $3c, $ff, $98, $7f, $db, $3c, $ef, $3c, $c3, $7e, $81, $ff
	db $40, $3f, $30, $0f, $18, $07, $0c, $03, $0f, $00, $1e, $01, $30, $0f, $27, $1f
	db $f1, $8f, $73, $cf, $26, $ff, $3d, $fe, $1d, $fe, $26, $ff, $73, $cf, $f9, $87
	db $ff, $00, $bd, $7e, $7e, $ff, $df, $e3, $bd, $c3, $b9, $c7, $99, $e7, $89, $f7
	db $db, $e7, $66, $ff, $3c, $ff, $98, $7f, $db, $3c, $bd, $7e, $66, $ff, $c3, $ff
	db $df, $3f, $b0, $7f, $ec, $73, $fe, $61, $ff, $60, $f8, $67, $b0, $7f, $df, $3f
	db $b9, $c7, $d3, $ef, $66, $ff, $3d, $fe, $3d, $fe, $66, $ff, $d3, $ef, $b1, $cf
	db $83, $fe, $cf, $fc, $77, $f8, $33, $fc, $58, $ff, $8c, $ff, $c6, $bf, $e3, $1f
	db $e3, $7f, $d6, $3f, $8c, $7f, $1c, $ff, $32, $ff, $66, $fb, $cf, $f1, $8f, $f0
	db $f1, $0f, $f3, $8f, $66, $df, $4c, $ff, $38, $ff, $31, $fe, $6b, $fc, $c7, $fe
	db $c7, $f8, $63, $fd, $31, $ff, $1a, $ff, $cc, $3f, $ee, $1f, $f3, $3f, $c1, $7f
	db $81, $ff, $7f, $fe, $76, $ce, $7a, $c6, $5a, $e6, $66, $fc, $7c, $f8, $e0, $c0
	db $81, $ff, $fe, $7f, $6e, $73, $5e, $63, $5a, $67, $66, $3f, $3e, $1f, $07, $03
	db $e0, $c0, $7c, $f8, $66, $fc, $5a, $e6, $7a, $c6, $76, $ce, $7f, $fe, $81, $ff
	db $07, $03, $3e, $1f, $66, $3f, $5a, $67, $5e, $63, $6e, $73, $fe, $7f, $81, $ff
	db $81, $ff, $c3, $7e, $ef, $3c, $db, $3c, $98, $7f, $3c, $ff, $66, $ff, $db, $e7
	db $90, $ef, $b0, $cf, $b8, $c7, $3c, $c3, $66, $81, $c2, $01, $01, $00, $00, $00
	db $9f, $e1, $ce, $f3, $64, $ff, $b8, $7f, $bc, $7f, $64, $ff, $ce, $f3, $8f, $f1
	db $e4, $f8, $0c, $f0, $78, $80, $f0, $00, $30, $c0, $18, $e0, $0c, $f0, $02, $fc
	db $c3, $ff, $66, $ff, $bd, $7e, $db, $3c, $98, $7f, $3c, $ff, $66, $ff, $db, $e7
	db $89, $f7, $99, $e7, $b9, $c7, $bd, $c3, $df, $e3, $7e, $ff, $bd, $7e, $ff, $00
	db $9d, $e3, $cb, $f7, $66, $ff, $bc, $7f, $bc, $7f, $66, $ff, $cb, $f7, $8d, $f3
	db $fb, $fc, $0d, $fe, $37, $ce, $7f, $86, $ff, $06, $1f, $e6, $0d, $fe, $fb, $fc
;@ path: gfx/tiles/indoor
;@ Page $48: copied to $9200 ($200 bytes) on the indoor maps whose entry in $01:$7F84 is $48. 32 tiles.
;@ asset: tiles bpp=2 length=$200
IndoorMapTiles48::
	db $ff, $00, $80, $00, $80, $3f, $9f, $3f, $9f, $38, $9f, $34, $9f, $32, $9f, $31
	db $ff, $00, $01, $00, $01, $fc, $f9, $fc, $f9, $1c, $f9, $2c, $f9, $4c, $f9, $8c
	db $9f, $31, $9f, $32, $9f, $34, $9f, $38, $9f, $3f, $80, $3f, $80, $00, $ff, $00
	db $f9, $8c, $f9, $4c, $f9, $2c, $f9, $1c, $f9, $fc, $01, $fc, $01, $00, $ff, $00
	db $9f, $30, $1f, $30, $1f, $f0, $ff, $f0, $f7, $00, $fb, $00, $fd, $00, $fe, $00
	db $f9, $0c, $f8, $0c, $f8, $0f, $ff, $0f, $ef, $00, $df, $00, $bf, $00, $7f, $00
	db $fe, $00, $fd, $00, $fb, $00, $f7, $00, $ff, $f0, $1f, $f0, $1f, $30, $9f, $30
	db $7f, $00, $bf, $00, $df, $00, $ef, $00, $ff, $0f, $f8, $0f, $f8, $0c, $f9, $0c
	db $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $ff, $ff, $ff, $40, $ff, $ff, $ff, $04, $ff, $04, $ff, $ff, $04, $ff, $ff
	db $9f, $30, $9f, $30, $9f, $30, $9f, $30, $9f, $30, $9f, $30, $9f, $30, $9f, $30
	db $cb, $bf, $cb, $bf, $cb, $bf, $fb, $ff, $cb, $bf, $cb, $bf, $cf, $bf, $cb, $bf
	db $81, $00, $7e, $81, $85, $fb, $81, $ff, $81, $ff, $e3, $ff, $f7, $3e, $3e, $dd
	db $ff, $ff, $83, $ff, $c1, $bf, $e1, $df, $76, $eb, $fd, $36, $ff, $ff, $3c, $db
	db $be, $7d, $47, $3e, $63, $1f, $41, $3f, $43, $3f, $47, $3e, $46, $3d, $be, $7d
	db $6f, $df, $53, $ff, $f1, $6f, $e1, $df, $f1, $ef, $f9, $77, $7d, $db, $6f, $df
	db $ff, $ff, $ff, $c0, $e0, $bf, $d0, $bf, $cf, $bf, $cc, $bf, $cb, $bf, $cb, $bf
	db $ff, $ff, $ff, $03, $07, $fd, $0b, $fd, $f3, $fd, $33, $fd, $d3, $fd, $d3, $fd
	db $cb, $bf, $cb, $bf, $cc, $bf, $cf, $bf, $d0, $bf, $e0, $bf, $ff, $c0, $ff, $ff
	db $d3, $fd, $d3, $fd, $33, $fd, $f3, $fd, $0b, $fd, $07, $fd, $ff, $03, $ff, $ff
	db $cb, $bf, $cb, $3f, $2b, $df, $1b, $ef, $fb, $ff, $07, $fb, $ff, $ff, $ff, $ff
	db $d3, $fd, $d3, $fc, $d4, $fb, $d8, $f7, $df, $ff, $e0, $df, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $07, $fb, $fb, $ff, $1b, $ef, $2b, $df, $cb, $3f, $cb, $bf
	db $ff, $ff, $ff, $ff, $e0, $df, $df, $ff, $d8, $f7, $d4, $fb, $d3, $fc, $d3, $fd
	db $ff, $ff, $ff, $04, $04, $ff, $04, $ff, $ff, $ff, $40, $ff, $ff, $ff, $ff, $ff
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $00, $ff, $00
	db $d3, $fd, $d3, $fd, $d3, $fd, $df, $ff, $d3, $fd, $d3, $fd, $f3, $fd, $d3, $fd
	db $f9, $0c, $f9, $0c, $f9, $0c, $f9, $0c, $f9, $0c, $f9, $0c, $f9, $0c, $f9, $0c
	db $3c, $db, $ff, $ff, $fd, $36, $76, $eb, $e1, $df, $c1, $bf, $83, $ff, $ff, $ff
	db $3e, $dd, $f7, $3e, $e3, $ff, $81, $ff, $81, $ff, $85, $fb, $7e, $81, $81, $00
	db $f6, $fb, $ca, $ff, $8f, $f6, $87, $fb, $8f, $f7, $9f, $ee, $be, $db, $f6, $fb
	db $7d, $be, $e2, $7c, $c6, $f8, $82, $fc, $c2, $fc, $e2, $7c, $62, $bc, $7d, $be
;@ path: gfx/tiles/indoor
;@ Page $4A: copied to $9200 ($200 bytes) on the indoor maps whose entry in $01:$7F84 is $4A. 32 tiles.
;@ asset: tiles bpp=2 length=$200
IndoorMapTiles4A::
	db $00, $00, $6f, $70, $75, $7a, $3a, $7d, $5c, $3f, $6e, $1f, $57, $2f, $63, $1f
	db $00, $00, $f6, $0e, $ae, $5e, $5c, $be, $3a, $fc, $76, $f8, $ea, $f4, $c6, $f8
	db $63, $1f, $57, $2f, $6e, $1f, $5c, $3f, $3a, $7d, $75, $7a, $6f, $70, $00, $00
	db $c6, $f8, $ea, $f4, $76, $f8, $3a, $fc, $5c, $be, $ae, $5e, $f6, $0e, $00, $00
	db $18, $07, $10, $0f, $08, $07, $c0, $07, $a0, $43, $40, $b1, $00, $f8, $00, $fc
	db $18, $e0, $08, $f0, $10, $e0, $03, $e0, $05, $c2, $02, $8d, $00, $1f, $00, $3f
	db $00, $fc, $00, $f8, $40, $b1, $a0, $43, $c0, $07, $08, $07, $10, $0f, $18, $07
	db $00, $3f, $00, $1f, $02, $8d, $05, $c2, $03, $e0, $10, $e0, $08, $f0, $18, $e0
	db $00, $00, $99, $00, $fe, $01, $5b, $a4, $84, $7b, $00, $ff, $10, $ff, $02, $ff
	db $ff, $ff, $ff, $ff, $ee, $ff, $7d, $ff, $d7, $ff, $44, $ff, $11, $ff, $40, $ff
	db $50, $2f, $31, $0f, $28, $17, $70, $0f, $72, $0f, $20, $1f, $30, $0f, $68, $17
	db $17, $ff, $bf, $ff, $0f, $ff, $5b, $ff, $0f, $ff, $3f, $ff, $17, $ff, $5b, $ff
	db $81, $00, $76, $89, $89, $f7, $a3, $dd, $89, $ff, $e3, $ff, $f7, $3e, $3e, $dd
	db $ff, $ff, $ff, $ff, $f7, $bf, $fd, $df, $76, $eb, $3c, $f7, $3d, $ff, $3c, $db
	db $be, $7d, $57, $2e, $43, $3f, $29, $5f, $43, $3f, $57, $2e, $46, $3d, $be, $7d
	db $4f, $ff, $17, $ff, $ff, $6f, $eb, $df, $ff, $ef, $ff, $77, $1f, $fb, $0f, $ff
	db $c0, $ff, $e4, $ff, $70, $ff, $3a, $ff, $1d, $ff, $9f, $ff, $07, $ff, $2f, $ff
	db $03, $ff, $27, $ff, $0e, $ff, $5c, $ff, $b8, $ff, $f9, $ff, $e0, $ff, $f4, $ff
	db $2f, $ff, $07, $ff, $9f, $ff, $1d, $ff, $3a, $ff, $70, $ff, $e4, $ff, $c0, $ff
	db $f4, $ff, $e0, $ff, $f9, $ff, $b8, $ff, $5c, $ff, $0e, $ff, $27, $ff, $03, $ff
	db $57, $3f, $af, $1f, $43, $9f, $87, $ef, $23, $f7, $b3, $ff, $fd, $ff, $ff, $ff
	db $ea, $fc, $f5, $f8, $c2, $f9, $e1, $f7, $c4, $ef, $cd, $ff, $bf, $ff, $ff, $ff
	db $ff, $ff, $fd, $ff, $b3, $ff, $23, $f7, $87, $ef, $43, $9f, $af, $1f, $57, $3f
	db $ff, $ff, $bf, $ff, $cd, $ff, $c4, $ef, $e1, $f7, $c2, $f9, $f5, $f8, $ea, $fc
	db $40, $ff, $11, $ff, $44, $ff, $d7, $ff, $7d, $ff, $ee, $ff, $ff, $ff, $ff, $ff
	db $02, $ff, $10, $ff, $00, $ff, $84, $7b, $5b, $a4, $fe, $01, $99, $00, $00, $00
	db $e8, $ff, $fd, $ff, $f0, $ff, $da, $ff, $f0, $ff, $fc, $ff, $e8, $ff, $da, $ff
	db $0a, $f4, $8c, $f0, $14, $e8, $0e, $f0, $4e, $f0, $04, $f8, $0c, $f0, $16, $e8
	db $3c, $db, $3d, $ff, $3c, $f7, $76, $eb, $fd, $df, $f7, $bf, $ff, $ff, $ff, $ff
	db $3e, $dd, $f7, $3e, $e3, $ff, $89, $ff, $a3, $dd, $89, $f7, $76, $89, $81, $00
	db $f2, $ff, $e8, $ff, $ff, $f6, $d7, $fb, $ff, $f7, $ff, $ee, $f8, $df, $f0, $ff
	db $7d, $be, $ea, $74, $c2, $fc, $94, $fa, $c2, $fc, $ea, $74, $62, $bc, $7d, $be
;@ path: gfx/tiles/indoor
;@ Page $4C: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $4C. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles4C::
	db $41, $00, $41, $00, $45, $00, $c1, $00, $e3, $00, $fc, $00, $38, $00, $12, $00
	db $f8, $00, $18, $00, $0c, $00, $04, $00, $87, $00, $c7, $00, $44, $00, $6c, $00
	db $50, $00, $10, $00, $91, $00, $18, $00, $3c, $00, $e3, $00, $c1, $00, $c9, $00
	db $38, $00, $3a, $00, $38, $00, $64, $00, $c6, $00, $93, $00, $83, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $3f, $00, $41, $00, $41, $00, $41, $00, $42, $00, $45, $00, $7b, $00
	db $00, $00, $7c, $00, $7e, $00, $7e, $00, $7e, $00, $0e, $00, $f6, $00, $f8, $00
	db $07, $00, $7b, $00, $7d, $00, $7e, $00, $7e, $00, $7e, $00, $3e, $00, $00, $00
	db $f6, $00, $ea, $00, $d2, $00, $22, $00, $c2, $00, $82, $00, $fc, $00, $00, $00
	db $00, $81, $00, $81, $42, $81, $64, $83, $98, $67, $c0, $3f, $43, $3c, $27, $18
	db $f8, $00, $18, $00, $2c, $10, $d0, $24, $20, $c7, $29, $c6, $3a, $c4, $00, $fc
	db $6d, $12, $2f, $10, $ae, $11, $2f, $10, $47, $38, $98, $67, $22, $c1, $c9, $00
	db $84, $78, $c2, $38, $c0, $38, $d4, $28, $aa, $44, $55, $82, $45, $82, $3f, $c0
;@ path: gfx/tiles/indoor
;@ Page $4D: copied to $9100 on the indoor maps whose entry in $01:$7F64 is $4D. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles4D::
	db $06, $00, $28, $01, $0c, $03, $00, $00, $20, $00, $02, $00, $60, $00, $b1, $00
	db $20, $00, $00, $00, $00, $00, $10, $00, $20, $08, $28, $10, $00, $00, $80, $00
	db $e1, $10, $11, $60, $00, $00, $0c, $00, $56, $00, $0c, $12, $12, $0c, $00, $00
	db $42, $00, $c0, $00, $00, $00, $00, $00, $18, $00, $2c, $00, $38, $04, $04, $18
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $18, $00, $25, $10, $49, $20, $50, $00, $6f, $00, $10, $00, $2c
	db $00, $7c, $00, $82, $82, $3d, $00, $c3, $00, $00, $00, $06, $00, $c9, $00, $2b
	db $00, $29, $00, $21, $01, $28, $02, $41, $04, $53, $00, $76, $00, $1d, $00, $01
	db $00, $aa, $44, $aa, $c4, $2a, $00, $ca, $00, $12, $00, $da, $40, $2e, $00, $c0
	db $22, $00, $3e, $00, $e2, $00, $40, $01, $40, $01, $20, $02, $00, $1c, $00, $04
	db $10, $00, $09, $00, $02, $0c, $00, $08, $00, $f8, $00, $24, $00, $22, $00, $41
	db $02, $04, $03, $07, $c1, $09, $20, $10, $10, $00, $18, $00, $67, $00, $01, $00
	db $40, $41, $e0, $f9, $c0, $86, $80, $84, $00, $84, $3e, $c0, $01, $00, $00, $00
;@ path: gfx/tiles/indoor
;@ Page $4E: copied to $9100 on the indoor maps whose entry in $01:$7F64 is $4E. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles4E::
	db $00, $00, $00, $00, $60, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $e0, $00, $00, $00, $00, $00, $ff, $00
	db $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $0c, $00, $00, $00, $00, $00, $c0, $00, $ff, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $dd, $00, $c1, $00, $5d, $00, $be, $00, $be, $00, $9d, $00, $63, $00, $fb, $00
	db $ef, $00, $f7, $00, $f0, $00, $f7, $00, $07, $00, $db, $00, $dc, $00, $de, $00
	db $fd, $00, $7a, $00, $b7, $00, $cf, $00, $ef, $00, $c6, $00, $39, $00, $bd, $00
	db $de, $00, $0e, $00, $71, $00, $7b, $00, $7b, $00, $39, $00, $c6, $00, $ef, $00
	db $22, $00, $3e, $00, $e2, $00, $40, $01, $40, $01, $20, $02, $00, $1c, $00, $04
	db $10, $00, $09, $00, $02, $0c, $00, $08, $00, $f8, $00, $24, $00, $22, $00, $41
	db $02, $04, $03, $07, $c1, $09, $20, $10, $10, $00, $18, $00, $67, $00, $01, $00
	db $40, $41, $e0, $f9, $c0, $86, $80, $84, $00, $84, $3e, $c0, $01, $00, $00, $00
;@ path: gfx/tiles/indoor
;@ Page $4F: copied to $9100 on the indoor maps whose entry in $01:$7F64 is $4F. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles4F::
	db $f0, $00, $12, $00, $10, $00, $18, $00, $0f, $00, $01, $00, $21, $00, $01, $00
	db $01, $00, $01, $00, $41, $00, $0f, $00, $18, $00, $10, $00, $12, $00, $f0, $00
	db $8f, $00, $08, $00, $08, $00, $18, $00, $f0, $00, $84, $00, $80, $00, $80, $00
	db $80, $00, $80, $00, $82, $00, $f0, $00, $18, $00, $08, $00, $88, $00, $0f, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $e0, $00, $cf, $00, $90, $00, $27, $00, $4f, $00, $5f, $00, $5f, $00, $7f, $00
	db $07, $00, $f3, $00, $f9, $00, $fc, $00, $fe, $00, $fe, $00, $fe, $00, $fe, $00
	db $5f, $00, $7f, $00, $7f, $00, $7f, $00, $3f, $00, $9c, $03, $cf, $00, $e0, $00
	db $fe, $00, $fa, $04, $fa, $04, $f2, $0c, $e4, $18, $09, $f0, $f2, $00, $05, $00
	db $f0, $00, $32, $00, $08, $10, $04, $18, $20, $1f, $80, $7f, $40, $31, $1e, $21
	db $00, $21, $20, $41, $3e, $41, $80, $7f, $04, $f8, $a8, $10, $ea, $10, $00, $fc
	db $00, $3f, $30, $0f, $15, $08, $65, $18, $00, $ff, $84, $01, $81, $00, $80, $00
	db $44, $82, $10, $82, $44, $82, $00, $ff, $67, $98, $90, $08, $00, $08, $0f, $00
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $00: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset00::
	db $80, $80, $c0, $c0, $a0, $a0, $9f, $97, $c8, $88, $e8, $c0, $f3, $a1, $d3, $b3
	db $01, $01, $03, $03, $05, $05, $f9, $e9, $13, $11, $17, $03, $cf, $85, $cb, $cd
	db $d3, $b3, $d3, $b3, $d9, $b1, $e5, $a1, $ed, $ad, $f6, $bc, $c3, $be, $ff, $ff
	db $cb, $cd, $cb, $cd, $9b, $8d, $a7, $85, $b7, $b5, $6f, $3d, $c3, $7d, $ff, $ff
	db $04, $09, $7f, $0d, $3b, $6f, $70, $3f, $e7, $38, $e9, $b0, $58, $e0, $19, $60
	db $30, $10, $f6, $30, $dc, $f6, $0c, $fc, $e5, $1c, $17, $0d, $9a, $07, $48, $06
	db $26, $40, $22, $c0, $2f, $40, $31, $40, $18, $e0, $0f, $30, $03, $1c, $00, $33
	db $3c, $02, $2c, $03, $c4, $02, $24, $02, $9c, $03, $f8, $06, $00, $fc, $00, $26
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $df, $7f
	db $00, $00, $ff, $00, $fb, $fc, $fd, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe
	db $cd, $7e, $db, $7c, $f7, $78, $ef, $70, $dd, $63, $f6, $4f, $d8, $7c, $ff, $ff
	db $ff, $7e, $ff, $3e, $ff, $3e, $63, $f2, $83, $c2, $03, $02, $03, $02, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $01: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset01::
	db $bf, $7f, $ff, $7f, $d0, $ef, $90, $ef, $90, $ef, $9f, $e0, $bf, $df, $e0, $bf
	db $fd, $fe, $ff, $fe, $0b, $f7, $09, $f7, $09, $f7, $f9, $07, $fd, $fb, $07, $fd
	db $d0, $ef, $90, $ef, $90, $ef, $90, $ef, $9f, $e0, $bf, $ff, $e0, $ff, $df, $e0
	db $0b, $f7, $09, $f7, $09, $f7, $09, $f7, $f9, $07, $fd, $ff, $07, $ff, $fb, $07
	db $bf, $c0, $f0, $80, $e0, $80, $c0, $80, $c0, $80, $c0, $80, $00, $00, $00, $00
	db $fd, $03, $0f, $01, $07, $01, $03, $01, $03, $01, $03, $01, $00, $00, $00, $00
	db $81, $7e, $42, $bd, $24, $db, $18, $e7, $10, $ef, $20, $df, $40, $bf, $80, $7f
	db $86, $78, $5d, $a0, $1b, $c0, $67, $80, $ef, $00, $df, $00, $bf, $00, $7f, $00
	db $61, $1e, $ba, $05, $d8, $03, $e6, $01, $ef, $00, $df, $00, $bf, $00, $7f, $00
	db $7e, $00, $bd, $00, $db, $00, $e7, $00, $ef, $00, $df, $00, $bf, $00, $7f, $00
	db $3e, $00, $94, $00, $89, $00, $42, $00, $a5, $00, $4a, $00, $00, $00, $00, $00
	db $00, $ff, $7e, $81, $7e, $81, $7e, $81, $7e, $81, $7e, $81, $7e, $81, $00, $ff
	db $01, $01, $02, $02, $05, $04, $09, $08, $ec, $e8, $9e, $98, $ca, $88, $a8, $c8
	db $00, $00, $80, $80, $4e, $4e, $32, $32, $66, $22, $ae, $62, $2c, $e4, $37, $ef
	db $5c, $68, $2e, $38, $7b, $79, $9a, $9a, $ce, $8a, $6e, $4a, $36, $3e, $05, $03
	db $2b, $f9, $b1, $f3, $66, $62, $6a, $26, $ec, $24, $f4, $2c, $b8, $78, $d0, $e0
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $02: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset02::
	db $80, $80, $80, $80, $80, $80, $ff, $83, $ff, $84, $ff, $88, $ff, $88, $ff, $88
	db $01, $01, $01, $01, $01, $01, $ff, $c1, $ff, $21, $ff, $11, $ff, $11, $ff, $11
	db $ff, $9c, $f7, $a0, $ef, $c8, $ff, $f8, $fe, $88, $ff, $89, $f9, $89, $ff, $ff
	db $ff, $39, $ef, $05, $f7, $13, $ff, $1f, $7f, $11, $ff, $91, $9f, $91, $ff, $ff
	db $04, $09, $7f, $0d, $3b, $6f, $70, $3f, $e7, $38, $e9, $b0, $58, $e0, $19, $60
	db $30, $10, $f6, $30, $dc, $f6, $0c, $fc, $e5, $1c, $17, $0d, $9a, $07, $48, $06
	db $26, $40, $22, $c0, $2f, $40, $31, $40, $18, $e0, $0f, $30, $03, $1c, $00, $33
	db $3c, $02, $2c, $03, $c4, $02, $24, $02, $9c, $03, $f8, $06, $00, $fc, $00, $26
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $ff, $ff, $9f, $81, $e7, $80, $f8, $80, $fb, $83, $fb, $93, $f9, $b1, $b9, $a1
	db $ff, $ff, $f9, $81, $e1, $07, $01, $1f, $c1, $df, $c9, $df, $8d, $9f, $87, $9d
	db $b8, $80, $f0, $87, $e1, $8f, $c1, $9f, $81, $bf, $81, $be, $80, $ff, $ff, $ff
	db $03, $1d, $11, $ef, $89, $f7, $85, $fb, $83, $fd, $83, $7d, $01, $ff, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $03: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset03::
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7c, $ff, $78
	db $00, $00, $ff, $00, $fb, $fc, $fd, $86, $df, $82, $af, $c2, $97, $e2, $cb, $72
	db $fb, $70, $f4, $78, $f1, $7e, $fc, $7f, $eb, $47, $c1, $40, $c0, $40, $ff, $ff
	db $e7, $3a, $f3, $1e, $3b, $0e, $4f, $86, $97, $e2, $73, $fe, $2f, $1e, $ff, $fe
	db $00, $00, $f7, $f8, $98, $ef, $8f, $f7, $4f, $f8, $30, $ff, $2f, $ff, $2d, $fd
	db $00, $00, $ef, $1f, $1d, $f3, $f1, $ef, $f2, $1f, $0c, $ff, $f4, $ff, $b4, $bf
	db $27, $ff, $e1, $ff, $21, $ff, $79, $ff, $e7, $df, $c0, $bf, $81, $ff, $ff, $ff
	db $e4, $ff, $87, $ff, $84, $ff, $9e, $ff, $e7, $fb, $03, $fd, $81, $ff, $ff, $ff
	db $ff, $06, $df, $e7, $ef, $f7, $fd, $ff, $4c, $7f, $a0, $3f, $71, $9f, $30, $df
	db $ff, $30, $fd, $f3, $fb, $f7, $9f, $ff, $1a, $fe, $05, $fc, $0e, $f9, $0c, $fb
	db $38, $df, $f2, $ff, $30, $3f, $3a, $df, $38, $df, $1f, $ff, $ef, $f0, $df, $e0
	db $1c, $fb, $4f, $ff, $0c, $fc, $5f, $f8, $1c, $fb, $f8, $ff, $f7, $0f, $fb, $07
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $df, $7f
	db $00, $00, $ff, $00, $fb, $fc, $fd, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe
	db $cd, $7e, $db, $7c, $f7, $78, $ef, $70, $dd, $63, $f6, $4f, $d8, $7c, $ff, $ff
	db $ff, $7e, $ff, $3e, $ff, $3e, $63, $f2, $83, $c2, $03, $02, $03, $02, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $04: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset04::
	db $ff, $fe, $9d, $e1, $9d, $e1, $a9, $d1, $a9, $d1, $99, $e1, $9d, $e1, $9d, $e1
	db $89, $f1, $a9, $d1, $a9, $d1, $bd, $fd, $c3, $c3, $81, $99, $81, $a5, $81, $a5
	db $ff, $7f, $b9, $87, $b9, $87, $95, $8b, $95, $8b, $99, $87, $b9, $87, $b9, $87
	db $91, $8f, $95, $8b, $95, $8b, $bd, $bf, $c3, $c3, $81, $99, $81, $a5, $81, $a5
	db $ff, $ff, $18, $ff, $00, $ff, $ff, $ff, $ff, $00, $00, $38, $ff, $ef, $38, $28
	db $38, $28, $38, $28, $38, $28, $ff, $ff, $00, $ff, $ff, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $ff, $00, $00, $ff, $ff, $ff, $38, $28, $38, $28, $38, $28
	db $38, $28, $ff, $ef, $00, $38, $ff, $00, $ff, $ff, $00, $ff, $18, $ff, $ff, $ff
	db $3c, $3c, $5a, $66, $66, $42, $66, $42, $5a, $66, $66, $7e, $3c, $3c, $00, $00
	db $00, $00, $ce, $ce, $db, $db, $db, $db, $db, $db, $db, $db, $ce, $ce, $00, $00
	db $00, $00, $22, $22, $14, $14, $08, $08, $08, $08, $14, $14, $22, $22, $00, $00
	db $00, $00, $ff, $00, $00, $ff, $ff, $ff, $a1, $ff, $a5, $ff, $85, $ff, $ff, $ff
	db $3c, $3c, $26, $26, $25, $25, $24, $24, $e4, $e4, $a4, $a4, $bc, $bc, $be, $a2
	db $00, $00, $00, $00, $00, $00, $80, $80, $fe, $fe, $82, $82, $82, $82, $82, $82
	db $bf, $a1, $bf, $a0, $bf, $bf, $80, $80, $ff, $80, $ff, $ff, $92, $ff, $ff, $ff
	db $82, $82, $82, $82, $82, $82, $02, $02, $fe, $02, $fe, $fe, $4a, $fe, $fe, $fe
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $05: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset05::
	db $fa, $dc, $2d, $f2, $1c, $e1, $d8, $21, $d0, $21, $c0, $31, $e8, $72, $90, $ec
	db $90, $e4, $90, $e4, $b0, $c4, $78, $82, $c4, $01, $82, $01, $00, $01, $01, $00
	db $5f, $3f, $b0, $4f, $38, $87, $1d, $82, $1b, $84, $0b, $84, $07, $4e, $09, $37
	db $09, $27, $09, $27, $0d, $23, $1e, $41, $23, $80, $41, $80, $00, $80, $80, $00
	db $04, $09, $7f, $0d, $3b, $6f, $70, $3f, $e7, $38, $e9, $b0, $58, $e0, $19, $60
	db $30, $10, $f6, $30, $dc, $f6, $0c, $fc, $e5, $1c, $17, $0d, $9a, $07, $48, $06
	db $26, $40, $22, $c0, $2f, $40, $31, $40, $18, $e0, $0f, $30, $03, $1c, $00, $33
	db $3c, $02, $2c, $03, $c4, $02, $24, $02, $9c, $03, $f8, $06, $00, $fc, $00, $26
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $01, $01, $02, $02, $05, $04, $09, $08, $ec, $e8, $9e, $98, $ca, $88, $a8, $c8
	db $00, $00, $80, $80, $4e, $4e, $32, $32, $66, $22, $ae, $62, $2c, $e4, $37, $ef
	db $5c, $68, $2e, $38, $7b, $79, $9a, $9a, $ce, $8a, $6e, $4a, $36, $3e, $05, $03
	db $2b, $f9, $b1, $f3, $66, $62, $6a, $26, $ec, $24, $f4, $2c, $b8, $78, $d0, $e0
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $06: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset06::
	db $80, $80, $c0, $c0, $a0, $a0, $9f, $97, $c8, $88, $e8, $c0, $f3, $a1, $d3, $b3
	db $01, $01, $03, $03, $05, $05, $f9, $e9, $13, $11, $17, $03, $cf, $85, $cb, $cd
	db $d3, $b3, $d3, $b3, $d9, $b1, $e5, $a1, $ed, $ad, $f6, $bc, $c3, $be, $ff, $ff
	db $cb, $cd, $cb, $cd, $9b, $8d, $a7, $85, $b7, $b5, $6f, $3d, $c3, $7d, $ff, $ff
	db $7e, $ff, $fc, $3f, $d8, $ff, $00, $ff, $00, $ff, $0d, $f2, $ff, $00, $00, $00
	db $e7, $f8, $30, $ff, $1f, $ff, $1f, $ef, $3f, $cf, $ff, $1f, $ff, $3f, $ff, $ff
	db $e7, $1f, $0c, $ff, $f8, $ff, $f8, $f7, $fc, $f3, $ff, $f8, $ff, $fc, $ff, $ff
	db $ff, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $ff, $00, $0d, $f2, $00, $ff, $00, $ff, $d8, $ff, $fc, $3f, $7e, $ff
	db $ff, $ff, $ff, $3f, $ff, $1f, $3f, $cf, $1f, $ef, $1f, $ff, $30, $ff, $e7, $f8
	db $ff, $ff, $ff, $fc, $ff, $f8, $fc, $f3, $f8, $f7, $f8, $ff, $0c, $ff, $e7, $1f
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $ff, $00
	db $ff, $ff, $9f, $81, $e7, $80, $f8, $80, $fb, $83, $fb, $93, $f9, $b1, $b9, $a1
	db $ff, $ff, $f9, $81, $e1, $07, $01, $1f, $c1, $df, $c9, $df, $8d, $9f, $87, $9d
	db $b8, $80, $f0, $87, $e1, $8f, $c1, $9f, $81, $bf, $81, $be, $80, $ff, $ff, $ff
	db $03, $1d, $11, $ef, $89, $f7, $85, $fb, $83, $fd, $83, $7d, $01, $ff, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $07: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset07::
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7c, $ff, $78
	db $00, $00, $ff, $00, $fb, $fc, $fd, $86, $df, $82, $af, $c2, $97, $e2, $cb, $72
	db $fb, $70, $f4, $78, $f1, $7e, $fc, $7f, $eb, $47, $c1, $40, $c0, $40, $ff, $ff
	db $e7, $3a, $f3, $1e, $3b, $0e, $4f, $86, $97, $e2, $73, $fe, $2f, $1e, $ff, $fe
	db $ff, $ef, $ff, $ef, $ff, $ff, $83, $80, $b0, $80, $ff, $ff, $ff, $ef, $ff, $ef
	db $ff, $f7, $ff, $f7, $ff, $ff, $01, $01, $19, $01, $ff, $ff, $ff, $f7, $ff, $f7
	db $ff, $ff, $c2, $c0, $ff, $ff, $90, $80, $ff, $ff, $80, $80, $ff, $ff, $c2, $c0
	db $ff, $ff, $13, $03, $ff, $ff, $21, $01, $ff, $ff, $03, $03, $ff, $ff, $09, $01
	db $ff, $ff, $80, $80, $9b, $83, $fe, $fe, $f8, $f8, $fb, $fb, $fd, $f9, $fe, $fc
	db $ff, $ff, $33, $03, $c3, $c3, $7f, $7f, $ff, $ff, $df, $df, $bf, $9f, $7f, $3f
	db $fc, $fc, $fb, $f9, $fb, $fb, $ff, $ff, $fe, $fe, $fe, $fe, $ff, $ff, $cc, $c0
	db $3f, $3f, $df, $9f, $df, $df, $3f, $1f, $7f, $7f, $7f, $7f, $ff, $ff, $19, $01
	db $ff, $ff, $9f, $81, $e7, $80, $f8, $80, $fb, $83, $fb, $93, $f9, $b1, $b9, $a1
	db $ff, $ff, $f9, $81, $e1, $07, $01, $1f, $c1, $df, $c9, $df, $8d, $9f, $87, $9d
	db $b8, $80, $f0, $87, $e1, $8f, $c1, $9f, $81, $bf, $81, $be, $80, $ff, $ff, $ff
	db $03, $1d, $11, $ef, $89, $f7, $85, $fb, $83, $fd, $83, $7d, $01, $ff, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $08: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset08::
	db $ff, $fe, $9d, $e1, $9d, $e1, $a9, $d1, $a9, $d1, $99, $e1, $9d, $e1, $9d, $e1
	db $89, $f1, $a9, $d1, $a9, $d1, $bd, $fd, $c3, $c3, $81, $99, $81, $a5, $81, $a5
	db $ff, $7f, $b9, $87, $b9, $87, $95, $8b, $95, $8b, $99, $87, $b9, $87, $b9, $87
	db $91, $8f, $95, $8b, $95, $8b, $bd, $bf, $c3, $c3, $81, $99, $81, $a5, $81, $a5
	db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $ff, $00
	db $e0, $80, $ff, $80, $bf, $c0, $ff, $ff, $c0, $7f, $bf, $7f, $00, $00, $ff, $00
	db $07, $01, $ff, $01, $fd, $03, $ff, $ff, $03, $fe, $fc, $fe, $00, $00, $ff, $00
	db $00, $00, $7f, $3f, $70, $6f, $60, $5f, $67, $5f, $78, $78, $4b, $48, $7f, $7f
	db $00, $00, $fe, $fc, $06, $fe, $02, $fe, $e2, $fe, $1e, $1e, $d2, $12, $fe, $fe
	db $c0, $80, $c0, $80, $fe, $80, $e0, $80, $c0, $80, $c0, $80, $c0, $80, $c0, $80
	db $03, $01, $03, $01, $07, $01, $03, $01, $03, $01, $03, $01, $03, $01, $03, $01
	db $1f, $1f, $3f, $20, $7f, $40, $7f, $40, $7f, $40, $7f, $40, $7f, $40, $7f, $40
	db $f8, $f8, $fc, $04, $fe, $02, $fe, $02, $fe, $02, $fe, $02, $fe, $02, $fe, $02
	db $7f, $40, $5f, $40, $6f, $40, $50, $60, $20, $3f, $3f, $3f, $2d, $33, $3f, $1e
	db $fe, $02, $fa, $02, $f6, $02, $0a, $06, $04, $fc, $fc, $fc, $b4, $cc, $fc, $78
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $09: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset09::
	db $03, $03, $04, $04, $0a, $08, $15, $10, $2c, $21, $58, $45, $52, $49, $52, $49
	db $c0, $c0, $20, $20, $50, $10, $a8, $08, $14, $a4, $0a, $b2, $26, $9a, $42, $9a
	db $4a, $41, $73, $40, $e8, $50, $e2, $59, $c1, $7b, $e5, $3b, $74, $1b, $3f, $0f
	db $46, $92, $ca, $06, $1b, $0e, $2b, $de, $bf, $de, $bf, $dc, $3e, $d8, $fc, $f0
	db $04, $09, $7f, $0d, $3b, $6f, $70, $3f, $e7, $38, $e9, $b0, $58, $e0, $19, $60
	db $30, $10, $f6, $30, $dc, $f6, $0c, $fc, $e5, $1c, $17, $0d, $9a, $07, $48, $06
	db $26, $40, $22, $c0, $2f, $40, $31, $40, $18, $e0, $0f, $30, $03, $1c, $00, $33
	db $3c, $02, $2c, $03, $c4, $02, $24, $02, $9c, $03, $f8, $06, $00, $fc, $00, $26
	db $00, $00, $00, $1f, $1f, $20, $3f, $40, $3f, $40, $3c, $43, $38, $47, $38, $47
	db $00, $00, $00, $f8, $f8, $04, $fc, $02, $fc, $02, $3c, $c2, $1c, $e2, $1c, $e2
	db $38, $47, $38, $47, $3c, $43, $3f, $40, $3f, $40, $1f, $20, $00, $1f, $00, $00
	db $1c, $e2, $1c, $e2, $3c, $c2, $fc, $02, $fc, $02, $f8, $04, $00, $f8, $00, $00
	db $ff, $ff, $9f, $81, $e7, $80, $f8, $80, $fb, $83, $fb, $93, $f9, $b1, $b9, $a1
	db $ff, $ff, $f9, $81, $e1, $07, $01, $1f, $c1, $df, $c9, $df, $8d, $9f, $87, $9d
	db $b8, $80, $f0, $87, $e1, $8f, $c1, $9f, $81, $bf, $81, $be, $80, $ff, $ff, $ff
	db $03, $1d, $11, $ef, $89, $f7, $85, $fb, $83, $fd, $83, $7d, $01, $ff, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $0A: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset0A::
	db $80, $80, $c0, $c0, $a0, $a0, $9f, $97, $c8, $88, $e8, $c0, $f3, $a1, $d3, $b3
	db $01, $01, $03, $03, $05, $05, $f9, $e9, $13, $11, $17, $03, $cf, $85, $cb, $cd
	db $d3, $b3, $d3, $b3, $d9, $b1, $e5, $a1, $ed, $ad, $f6, $bc, $c3, $be, $ff, $ff
	db $cb, $cd, $cb, $cd, $9b, $8d, $a7, $85, $b7, $b5, $6f, $3d, $c3, $7d, $ff, $ff
	db $03, $03, $04, $04, $0a, $08, $15, $10, $2c, $21, $58, $45, $52, $49, $52, $49
	db $c0, $c0, $20, $20, $50, $10, $a8, $08, $14, $a4, $0a, $b2, $26, $9a, $42, $9a
	db $4a, $41, $73, $40, $e8, $50, $e2, $59, $c1, $7b, $e5, $3b, $74, $1b, $3f, $0f
	db $46, $92, $ca, $06, $1b, $0e, $2b, $de, $bf, $de, $bf, $dc, $3e, $d8, $fc, $f0
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $ff, $ff, $9f, $81, $e7, $80, $f8, $80, $fb, $83, $fb, $93, $f9, $b1, $b9, $a1
	db $ff, $ff, $f9, $81, $e1, $07, $01, $1f, $c1, $df, $c9, $df, $8d, $9f, $87, $9d
	db $b8, $80, $f0, $87, $e1, $8f, $c1, $9f, $81, $bf, $81, $be, $80, $ff, $ff, $ff
	db $03, $1d, $11, $ef, $89, $f7, $85, $fb, $83, $fd, $83, $7d, $01, $ff, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $0B: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset0B::
	db $80, $80, $80, $80, $80, $80, $ff, $83, $ff, $84, $ff, $88, $ff, $88, $ff, $88
	db $01, $01, $01, $01, $01, $01, $ff, $c1, $ff, $21, $ff, $11, $ff, $11, $ff, $11
	db $ff, $9c, $f7, $a0, $ef, $c8, $ff, $f8, $fe, $88, $ff, $89, $f9, $89, $ff, $ff
	db $ff, $39, $ef, $05, $f7, $13, $ff, $1f, $7f, $11, $ff, $91, $9f, $91, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $df, $7f
	db $00, $00, $ff, $00, $fb, $fc, $fd, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe
	db $cd, $7e, $db, $7c, $f7, $78, $ef, $70, $dd, $63, $f6, $4f, $d8, $7c, $ff, $ff
	db $ff, $7e, $ff, $3e, $ff, $3e, $63, $f2, $83, $c2, $03, $02, $03, $02, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $0C: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset0C::
	db $fa, $dc, $2d, $f2, $1c, $e1, $d8, $21, $d0, $21, $c0, $31, $e8, $72, $90, $ec
	db $90, $e4, $90, $e4, $b0, $c4, $78, $82, $c4, $01, $82, $01, $00, $01, $01, $00
	db $5f, $3f, $b0, $4f, $38, $87, $1d, $82, $1b, $84, $0b, $84, $07, $4e, $09, $37
	db $09, $27, $09, $27, $0d, $23, $1e, $41, $23, $80, $41, $80, $00, $80, $80, $00
	db $04, $09, $7f, $0d, $3b, $6f, $70, $3f, $e7, $38, $e9, $b0, $58, $e0, $19, $60
	db $30, $10, $f6, $30, $dc, $f6, $0c, $fc, $e5, $1c, $17, $0d, $9a, $07, $48, $06
	db $26, $40, $22, $c0, $2f, $40, $31, $40, $18, $e0, $0f, $30, $03, $1c, $00, $33
	db $3c, $02, $2c, $03, $c4, $02, $24, $02, $9c, $03, $f8, $06, $00, $fc, $00, $26
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $03, $03, $04, $04, $0a, $08, $15, $10, $2c, $21, $58, $45, $52, $49, $52, $49
	db $c0, $c0, $20, $20, $50, $10, $a8, $08, $14, $a4, $0a, $b2, $26, $9a, $42, $9a
	db $4a, $41, $73, $40, $e8, $50, $e2, $59, $c1, $7b, $e5, $3b, $74, $1b, $3f, $0f
	db $46, $92, $ca, $06, $1b, $0e, $2b, $de, $bf, $de, $bf, $dc, $3e, $d8, $fc, $f0
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $0D: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset0D::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $ef, $ff, $ef, $ff, $ff, $83, $80, $b0, $80, $ff, $ff, $ff, $ef, $ff, $ef
	db $ff, $f7, $ff, $f7, $ff, $ff, $01, $01, $19, $01, $ff, $ff, $ff, $f7, $ff, $f7
	db $ff, $ff, $c2, $c0, $ff, $ff, $90, $80, $ff, $ff, $80, $80, $ff, $ff, $c2, $c0
	db $ff, $ff, $13, $03, $ff, $ff, $21, $01, $ff, $ff, $03, $03, $ff, $ff, $09, $01
	db $ff, $ff, $80, $80, $9b, $83, $fe, $fe, $f8, $f8, $fb, $fb, $fd, $f9, $fe, $fc
	db $ff, $ff, $33, $03, $c3, $c3, $7f, $7f, $ff, $ff, $df, $df, $bf, $9f, $7f, $3f
	db $fc, $fc, $fb, $f9, $fb, $fb, $ff, $ff, $fe, $fe, $fe, $fe, $ff, $ff, $cc, $c0
	db $3f, $3f, $df, $9f, $df, $df, $3f, $1f, $7f, $7f, $7f, $7f, $ff, $ff, $19, $01
	db $03, $03, $04, $04, $0a, $08, $15, $10, $2c, $21, $58, $45, $52, $49, $52, $49
	db $c0, $c0, $20, $20, $50, $10, $a8, $08, $14, $a4, $0a, $b2, $26, $9a, $42, $9a
	db $4a, $41, $73, $40, $e8, $50, $e2, $59, $c1, $7b, $e5, $3b, $74, $1b, $3f, $0f
	db $46, $92, $ca, $06, $1b, $0e, $2b, $de, $bf, $de, $bf, $dc, $3e, $d8, $fc, $f0
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $0E: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset0E::
	db $80, $80, $c0, $c0, $a0, $a0, $9f, $97, $c8, $88, $e8, $c0, $f3, $a1, $d3, $b3
	db $01, $01, $03, $03, $05, $05, $f9, $e9, $13, $11, $17, $03, $cf, $85, $cb, $cd
	db $d3, $b3, $d3, $b3, $d9, $b1, $e5, $a1, $ed, $ad, $f6, $bc, $c3, $be, $ff, $ff
	db $cb, $cd, $cb, $cd, $9b, $8d, $a7, $85, $b7, $b5, $6f, $3d, $c3, $7d, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $1f, $0f, $10, $0f, $10, $0f, $10
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $fc, $f8, $04, $f8, $04, $f8, $04
	db $0f, $10, $0f, $10, $0f, $10, $0f, $10, $0f, $10, $00, $1f, $00, $00, $00, $00
	db $f8, $04, $f8, $04, $f8, $04, $f8, $04, $f8, $04, $00, $fc, $00, $00, $00, $00
	db $1f, $0f, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $10
	db $fc, $f8, $fc, $04, $fc, $04, $fc, $04, $fc, $04, $fc, $04, $fc, $04, $fc, $04
	db $10, $10, $10, $1f, $10, $1f, $10, $1f, $10, $1f, $1f, $1f, $00, $00, $00, $00
	db $04, $04, $04, $fc, $04, $fc, $04, $fc, $04, $fc, $fc, $fc, $00, $00, $00, $00
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7c, $ff, $78
	db $00, $00, $ff, $00, $fb, $fc, $fd, $86, $df, $82, $af, $c2, $97, $e2, $cb, $72
	db $fb, $70, $f4, $78, $f1, $7e, $fc, $7f, $eb, $47, $c1, $40, $c0, $40, $ff, $ff
	db $e7, $3a, $f3, $1e, $3b, $0e, $4f, $86, $97, $e2, $73, $fe, $2f, $1e, $ff, $fe
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $0F: copied to $9000 ($100 bytes) when a room with this set in IndoorATilesetIds / IndoorBTilesetIds is loaded (LoadTileset09, (hWorldTileset + $50) * $100). 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset0F::
	db $0f, $0f, $12, $10, $22, $20, $43, $47, $77, $4f, $4f, $4f, $4f, $4f, $7f, $4f
	db $f0, $f0, $48, $08, $44, $04, $c2, $e2, $ee, $f2, $f2, $f2, $f2, $f2, $fe, $f2
	db $47, $47, $62, $40, $72, $60, $7f, $52, $5f, $6f, $40, $70, $2f, $30, $1f, $1f
	db $e2, $e2, $46, $02, $4e, $06, $fe, $4a, $fa, $f6, $02, $0e, $f4, $0c, $f8, $f8
	db $06, $06, $0a, $0a, $1a, $12, $1b, $13, $3c, $3c, $60, $40, $5c, $5c, $de, $9e
	db $60, $60, $50, $50, $58, $48, $d8, $c8, $3c, $3c, $06, $02, $3a, $3a, $7b, $79
	db $9e, $9e, $8e, $8e, $c0, $80, $fa, $92, $72, $62, $30, $20, $3c, $2c, $3f, $3f
	db $79, $79, $71, $71, $03, $01, $5f, $49, $4e, $46, $0c, $04, $3c, $34, $fc, $fc
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $57, $57, $b2, $92, $f8, $b0, $ce, $cc, $9f, $8f, $ad, $9d, $f9, $99, $d9, $b9
	db $ea, $ea, $4d, $49, $1f, $0d, $73, $33, $f9, $f1, $b5, $b9, $9f, $99, $9b, $9d
	db $f9, $f9, $9f, $f9, $a9, $df, $b7, $cf, $df, $60, $4f, $70, $30, $3f, $1f, $0f
	db $9f, $9f, $f9, $9f, $95, $fb, $ed, $f3, $fb, $06, $f2, $0e, $0c, $fc, $f8, $f0
;@ path: gfx/tiles/indoor
;@ Page $60: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $60. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles60::
	db $7c, $00, $86, $00, $82, $00, $82, $00, $86, $00, $cc, $00, $79, $00, $03, $00
	db $03, $00, $79, $00, $cc, $00, $86, $00, $82, $00, $82, $00, $86, $00, $7c, $00
	db $3e, $00, $61, $00, $41, $00, $41, $00, $61, $00, $33, $00, $9e, $00, $c0, $00
	db $c0, $00, $9e, $00, $33, $00, $61, $00, $41, $00, $41, $00, $61, $00, $3e, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $f0, $0f, $96, $6f, $96, $6f, $e0, $1f, $0e, $f1, $6e, $f1, $6e, $f1, $00, $ff
	db $f0, $0f, $f6, $0f, $f6, $0f, $10, $ef, $1f, $e0, $67, $98, $67, $98, $07, $f8
	db $e0, $1f, $e6, $19, $e6, $19, $f8, $07, $08, $f7, $6f, $f0, $6f, $f0, $0f, $f0
	db $00, $ff, $76, $8f, $76, $8f, $70, $8f, $07, $f8, $69, $f6, $69, $f6, $0f, $f0
	db $60, $1c, $c8, $07, $85, $02, $85, $02, $c9, $06, $30, $cf, $00, $7f, $18, $26
	db $03, $10, $09, $f0, $84, $40, $02, $80, $00, $82, $44, $82, $3c, $c2, $80, $7c
	db $01, $3e, $1c, $63, $22, $41, $40, $01, $42, $01, $3c, $03, $80, $1e, $c0, $00
	db $00, $f8, $60, $9e, $d2, $21, $a1, $40, $81, $40, $21, $c0, $53, $20, $26, $18
;@ path: gfx/tiles/indoor
;@ Page $61: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $61. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles61::
	db $05, $00, $45, $00, $09, $00, $13, $00, $26, $00, $cd, $00, $1b, $00, $f7, $00
	db $a0, $00, $a0, $00, $a4, $00, $d0, $00, $68, $00, $b7, $00, $d8, $00, $ef, $00
	db $f7, $00, $1b, $00, $ed, $00, $16, $00, $0b, $00, $05, $00, $45, $00, $05, $00
	db $ef, $00, $d8, $00, $b7, $00, $68, $00, $d0, $00, $a4, $00, $a0, $00, $a0, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $3f, $1f, $60, $3e, $41, $36, $49, $23, $5c, $29, $56, $3c, $43
	db $00, $00, $00, $fc, $f8, $06, $7c, $82, $6c, $92, $c4, $3a, $94, $6a, $3c, $c2
	db $3e, $41, $2e, $51, $26, $59, $37, $48, $3e, $41, $1f, $60, $00, $3f, $00, $00
	db $7c, $82, $74, $8a, $64, $9a, $ec, $12, $7c, $82, $f8, $06, $00, $fc, $00, $00
	db $05, $02, $44, $01, $08, $01, $12, $81, $26, $81, $8d, $42, $03, $3c, $d3, $24
	db $a0, $00, $a2, $00, $a0, $0e, $d0, $08, $00, $f8, $93, $24, $d8, $22, $ae, $41
	db $d3, $24, $1b, $27, $c5, $39, $06, $10, $0b, $30, $00, $2f, $45, $20, $05, $40
	db $ee, $41, $e0, $f9, $b1, $86, $e8, $84, $50, $84, $00, $fc, $a0, $42, $a1, $40
;@ path: gfx/tiles/indoor
;@ Page $62: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $62. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles62::
	db $84, $00, $27, $00, $68, $00, $09, $00, $9a, $00, $f2, $00, $20, $00, $29, $00
	db $14, $00, $f6, $00, $12, $00, $d8, $00, $0f, $00, $66, $00, $04, $00, $95, $00
	db $2c, $00, $2c, $00, $60, $00, $f9, $00, $0c, $00, $67, $00, $24, $00, $94, $00
	db $b4, $00, $24, $00, $0f, $00, $99, $00, $30, $00, $e6, $00, $24, $00, $31, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $09, $00, $13, $00, $26, $00, $4d, $00, $9b, $00, $36, $00, $6f, $00, $df, $00
	db $90, $00, $c8, $00, $64, $00, $b2, $00, $d9, $00, $ec, $00, $f6, $00, $fb, $00
	db $db, $00, $6f, $00, $37, $00, $9b, $00, $4d, $00, $26, $00, $13, $00, $09, $00
	db $fb, $00, $b6, $00, $ec, $00, $d9, $00, $b2, $00, $64, $00, $c8, $00, $90, $00
	db $82, $04, $28, $07, $60, $0f, $12, $0c, $64, $98, $80, $78, $40, $3f, $00, $32
	db $24, $10, $06, $f0, $0a, $f0, $44, $38, $40, $3f, $92, $6c, $28, $c4, $99, $44
	db $15, $22, $10, $27, $5a, $24, $00, $fc, $13, $0c, $68, $07, $20, $04, $90, $04
	db $80, $44, $28, $c4, $51, $2e, $47, $38, $c8, $30, $16, $e0, $04, $20, $11, $20
;@ path: gfx/tiles/indoor
;@ Page $63: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $63. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles63::
	db $89, $00, $41, $00, $22, $00, $3c, $00, $30, $00, $24, $00, $48, $00, $d0, $00
	db $88, $00, $c0, $00, $24, $00, $12, $00, $98, $00, $38, $00, $44, $00, $83, $00
	db $c1, $00, $22, $00, $1c, $00, $09, $00, $48, $00, $24, $00, $13, $00, $01, $00
	db $01, $00, $12, $00, $24, $00, $4c, $00, $1c, $00, $24, $00, $c2, $00, $81, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $3f, $00, $67, $00, $5f, $00, $7e, $00, $7c, $00, $79, $00, $32, $00
	db $00, $00, $7c, $00, $4e, $00, $7e, $00, $1e, $00, $ce, $00, $e0, $00, $60, $00
	db $02, $00, $3b, $00, $49, $00, $5c, $00, $7e, $00, $7e, $00, $3c, $00, $00, $00
	db $e6, $00, $ca, $00, $96, $00, $2e, $00, $7e, $00, $7e, $00, $3c, $00, $00, $00
	db $81, $00, $21, $40, $12, $21, $2c, $12, $20, $1e, $14, $22, $41, $22, $80, $63
	db $80, $00, $c2, $00, $2c, $c0, $08, $30, $c8, $30, $d0, $28, $88, $44, $44, $83
	db $18, $e7, $02, $3c, $04, $18, $14, $08, $14, $08, $13, $0c, $60, $13, $00, $01
	db $45, $82, $bc, $42, $58, $24, $44, $38, $4c, $30, $a4, $40, $42, $80, $81, $00
;@ path: gfx/tiles/indoor
;@ Page $64: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $64. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles64::
	db $80, $00, $8c, $00, $8e, $00, $c6, $00, $60, $00, $30, $00, $58, $00, $0f, $00
	db $0f, $00, $18, $00, $30, $00, $62, $00, $c0, $00, $8c, $00, $8c, $00, $80, $00
	db $01, $00, $31, $00, $71, $00, $63, $00, $06, $00, $0c, $00, $18, $00, $f0, $00
	db $f0, $00, $18, $00, $0c, $00, $06, $00, $33, $00, $31, $00, $81, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $f8, $00, $b8, $44, $f9, $04, $e9, $14, $79, $84, $01, $78, $03, $00, $3f, $00
	db $01, $02, $f8, $01, $bc, $40, $fc, $02, $ec, $12, $fc, $02, $fc, $02, $c0, $3c
	db $7f, $00, $6f, $10, $7e, $01, $7a, $05, $3e, $41, $1e, $21, $80, $1e, $c0, $00
	db $80, $40, $1e, $80, $3f, $00, $7b, $04, $6f, $10, $7f, $00, $7f, $00, $01, $3e
	db $80, $00, $40, $8f, $69, $90, $10, $e0, $10, $60, $09, $30, $46, $39, $18, $27
	db $13, $0c, $24, $18, $48, $b0, $02, $f0, $08, $f0, $51, $8e, $44, $88, $30, $c8
	db $14, $23, $42, $21, $d2, $21, $0d, $f2, $11, $0e, $10, $0f, $20, $18, $80, $70
	db $00, $f8, $64, $98, $92, $0c, $11, $0e, $e0, $13, $00, $e1, $80, $01, $01, $00
;@ path: gfx/tiles/indoor
;@ Page $65: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $65. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles65::
	db $13, $00, $26, $00, $4c, $00, $98, $00, $30, $00, $64, $00, $c8, $00, $90, $00
	db $c0, $00, $60, $00, $32, $00, $99, $00, $4c, $00, $26, $00, $13, $00, $09, $00
	db $90, $00, $c8, $00, $64, $00, $32, $00, $99, $00, $4c, $00, $06, $00, $03, $00
	db $09, $00, $13, $00, $26, $00, $0c, $00, $19, $00, $32, $00, $64, $00, $c8, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $3f, $00, $7e, $01, $6c, $02, $79, $04, $73, $08, $66, $10, $6f, $00
	db $00, $00, $fc, $00, $7e, $80, $36, $40, $9e, $20, $ce, $10, $e6, $08, $f6, $00
	db $67, $08, $73, $04, $79, $02, $5c, $01, $7e, $00, $3f, $40, $00, $3f, $00, $00
	db $e6, $10, $ce, $20, $9e, $40, $36, $80, $7e, $00, $fc, $02, $00, $fc, $00, $00
	db $12, $01, $e5, $02, $0a, $24, $84, $18, $24, $18, $5b, $24, $a4, $43, $44, $83
	db $41, $80, $a1, $40, $52, $24, $20, $18, $44, $28, $8a, $44, $09, $c6, $32, $c9
	db $45, $82, $b8, $47, $56, $29, $25, $18, $94, $08, $42, $0c, $05, $3a, $e2, $01
	db $8a, $71, $95, $42, $6a, $84, $14, $e8, $c9, $30, $42, $3c, $a4, $42, $49, $80
;@ path: gfx/tiles/indoor
;@ Page $66: copied to $9100 ($100 bytes) on the indoor maps whose entry in $01:$7F64 is $66. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles66::
	db $3e, $00, $3e, $00, $a2, $00, $41, $00, $41, $00, $63, $00, $9f, $00, $07, $00
	db $10, $00, $08, $00, $2f, $00, $08, $00, $f8, $00, $e4, $00, $e3, $00, $e1, $00
	db $27, $00, $87, $00, $c8, $00, $70, $00, $70, $00, $79, $00, $c7, $00, $43, $00
	db $e1, $00, $f1, $00, $8e, $00, $84, $00, $94, $00, $c4, $00, $f9, $00, $f0, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $3f, $00, $73, $00, $66, $00, $4c, $00, $59, $00, $73, $00, $67, $00
	db $00, $00, $fc, $00, $1e, $00, $7e, $00, $fe, $00, $fe, $00, $fe, $00, $fe, $00
	db $4f, $00, $5f, $00, $5f, $00, $7f, $00, $7f, $00, $3f, $40, $00, $3f, $00, $00
	db $fe, $00, $fe, $00, $fe, $00, $fe, $00, $fe, $00, $fc, $02, $00, $fc, $00, $00
	db $3c, $02, $3c, $02, $25, $82, $06, $43, $2e, $43, $5b, $27, $e3, $1f, $1b, $07
	db $10, $00, $00, $08, $20, $0f, $90, $08, $00, $f8, $14, $e0, $d3, $e0, $d1, $e0
	db $0b, $07, $89, $07, $c4, $09, $68, $10, $48, $30, $34, $48, $c3, $04, $43, $00
	db $d1, $e0, $89, $f0, $f2, $8c, $48, $84, $50, $84, $84, $40, $b9, $40, $b0, $40
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $17: copied to $9000 ($100 bytes) by LoadTileset09 for the rooms that use it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset17::
	db $80, $80, $c0, $c0, $a0, $a0, $9f, $97, $c8, $88, $e8, $c0, $f3, $a1, $d3, $b3
	db $01, $01, $03, $03, $05, $05, $f9, $e9, $13, $11, $17, $03, $cf, $85, $cb, $cd
	db $d3, $b3, $d3, $b3, $d9, $b1, $e5, $a1, $ed, $ad, $f6, $bc, $c3, $be, $ff, $ff
	db $cb, $cd, $cb, $cd, $9b, $8d, $a7, $85, $b7, $b5, $6f, $3d, $c3, $7d, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $00, $00, $ff, $00, $df, $3f, $bf, $7f, $ff, $7f, $ff, $7f, $ff, $7c, $ff, $78
	db $00, $00, $ff, $00, $fb, $fc, $fd, $86, $df, $82, $af, $c2, $97, $e2, $cb, $72
	db $fb, $70, $f4, $78, $f1, $7e, $fc, $7f, $eb, $47, $c1, $40, $c0, $40, $ff, $ff
	db $e7, $3a, $f3, $1e, $3b, $0e, $4f, $86, $97, $e2, $73, $fe, $2f, $1e, $ff, $fe
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $18: copied to $9000 ($100 bytes) by LoadTileset09 for the rooms that use it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset18::
	db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0
	db $ff, $ff, $f0, $f0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $ff, $0f, $0f, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $3f, $3f, $1f, $1f, $0f, $0f, $07, $07
	db $e0, $e0, $c0, $c0, $c0, $c0, $c0, $c0, $80, $80, $80, $80, $80, $80, $80, $80
	db $07, $07, $03, $03, $03, $03, $03, $03, $01, $01, $01, $01, $01, $01, $01, $01
	db $80, $80, $80, $80, $80, $80, $80, $80, $c0, $c0, $c0, $c0, $c0, $c0, $e0, $e0
	db $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $03, $03, $03, $03, $07, $07
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $e0, $e0, $f0, $f0, $f8, $f8, $fc, $fc, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $f0, $f0, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $0f, $0f, $ff, $ff
	db $07, $07, $0f, $0f, $1f, $1f, $3f, $3f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $19: copied to $9000 ($100 bytes) by LoadTileset09 for the rooms that use it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset19::
	db $fa, $dc, $2d, $f2, $1c, $e1, $d8, $21, $d0, $21, $c0, $31, $e8, $72, $90, $ec
	db $90, $e4, $90, $e4, $b0, $c4, $78, $82, $c4, $01, $82, $01, $00, $01, $01, $00
	db $5f, $3f, $b0, $4f, $38, $87, $1d, $82, $1b, $84, $0b, $84, $07, $4e, $09, $37
	db $09, $27, $09, $27, $0d, $23, $1e, $41, $23, $80, $41, $80, $00, $80, $80, $00
	db $c0, $c0, $a0, $a0, $93, $93, $cd, $8e, $69, $4e, $70, $5f, $31, $3f, $13, $1e
	db $03, $03, $05, $05, $c9, $c9, $b3, $71, $96, $72, $0e, $fa, $8c, $fc, $c8, $78
	db $63, $7e, $8f, $fe, $8f, $fa, $4f, $78, $3f, $3c, $1f, $17, $29, $27, $58, $4f
	db $c6, $7e, $f1, $7f, $f1, $5f, $f2, $1e, $fc, $3c, $f8, $e8, $94, $e4, $1a, $f2
	db $00, $ff, $00, $80, $3f, $83, $3f, $82, $3f, $be, $3f, $a2, $3f, $a2, $3f, $a2
	db $3f, $ff, $3f, $21, $ff, $e1, $ff, $21, $ff, $21, $ff, $21, $e1, $21, $ff, $3f
	db $3e, $a2, $3f, $a3, $23, $a3, $3f, $bf, $3f, $bf, $3f, $80, $00, $80, $00, $ff
	db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $01, $00, $01, $00, $ff
	db $b5, $96, $ec, $ef, $0c, $0b, $0e, $09, $3b, $3c, $47, $44, $bd, $9e, $a3, $be
	db $ad, $69, $37, $f7, $30, $d0, $70, $90, $dc, $3c, $e2, $22, $bd, $79, $cd, $7d
	db $a7, $ba, $a5, $bb, $a3, $bc, $df, $9f, $a0, $c0, $80, $ff, $40, $7f, $3f, $3f
	db $e5, $5d, $a5, $dd, $c5, $3d, $fb, $f9, $05, $03, $01, $ff, $02, $fe, $fc, $fc
;@ path: gfx/tiles/indoor
;@ Indoor room tile set $1A: copied to $9000 ($100 bytes) by LoadTileset09 for the rooms that use it. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorTileset1A::
	db $3c, $00, $46, $00, $e2, $00, $f2, $00, $fa, $00, $f8, $00, $fd, $00, $7d, $00
	db $00, $00, $73, $00, $cf, $00, $bf, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00
	db $7b, $00, $77, $00, $37, $00, $2f, $00, $2f, $00, $1f, $00, $9f, $00, $9f, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fe, $00, $fe, $00
	db $7f, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $f3, $00, $ef, $00, $df, $00
	db $c3, $00, $f9, $00, $fc, $00, $fe, $00, $3e, $00, $be, $00, $bf, $00, $bf, $00
	db $bf, $00, $bf, $00, $7f, $00, $7f, $00, $7e, $00, $fe, $00, $fe, $00, $fc, $00
	db $7f, $00, $7f, $00, $7f, $00, $7f, $00, $ff, $00, $7f, $00, $3e, $00, $3e, $00
	db $3f, $00, $bf, $00, $bf, $00, $7f, $00, $7f, $00, $7f, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f8, $00, $f0, $00, $f0, $00, $f1, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fc, $00, $f9, $00, $e1, $00, $9e, $00
	db $fa, $00, $f2, $00, $ea, $00, $f9, $00, $f3, $00, $e7, $00, $ef, $00, $cf, $00
	db $3c, $00, $3c, $00, $78, $00, $f8, $00, $fc, $00, $fc, $00, $fe, $00, $fe, $00
	db $df, $00, $9f, $00, $5e, $00, $59, $00, $41, $00, $33, $00, $9e, $00, $c0, $00
	db $fe, $00, $be, $00, $3f, $00, $5f, $00, $4f, $00, $4e, $00, $62, $00, $3c, $00
;@ path: gfx/tiles/indoor
;@ Page $6B: copied to $9100 on the indoor maps whose entry in $01:$7F64 is $6B. 16 tiles.
;@ asset: tiles bpp=2 length=$100
IndoorMapTiles6B::
	db $83, $00, $23, $00, $00, $00, $00, $00, $30, $00, $30, $00, $01, $00, $01, $00
	db $07, $00, $0e, $00, $1c, $00, $58, $00, $18, $00, $18, $00, $98, $00, $99, $00
	db $40, $00, $00, $00, $00, $00, $3f, $00, $7f, $00, $e0, $00, $c2, $00, $80, $00
	db $38, $00, $70, $00, $e0, $00, $c0, $00, $8c, $00, $0c, $00, $01, $00, $03, $00
	db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $08, $1b, $10, $17, $10, $17, $10
	db $00, $00, $00, $00, $00, $00, $e0, $e0, $30, $10, $d8, $08, $e8, $08, $e8, $08
	db $17, $10, $1b, $10, $14, $18, $08, $0f, $07, $07, $00, $00, $00, $00, $00, $00
	db $e8, $08, $d8, $08, $28, $18, $10, $f0, $e0, $e0, $00, $00, $00, $00, $00, $00
	db $00, $00, $3f, $00, $7f, $00, $7f, $00, $7e, $01, $7c, $02, $79, $04, $03, $78
	db $00, $00, $7c, $00, $7e, $00, $7e, $00, $1e, $60, $0e, $10, $e0, $0e, $f0, $00
	db $03, $00, $79, $02, $7c, $01, $7e, $00, $7e, $00, $3e, $40, $00, $3e, $00, $00
	db $e6, $10, $ce, $20, $1e, $c0, $3e, $00, $fe, $00, $fc, $02, $00, $fc, $00, $00
	db $00, $01, $02, $01, $8c, $03, $52, $8d, $69, $90, $89, $70, $36, $49, $28, $47
	db $07, $00, $88, $07, $90, $0c, $d0, $08, $70, $88, $00, $f8, $68, $90, $a9, $10
	db $45, $22, $45, $22, $5d, $22, $40, $3f, $1f, $60, $a1, $40, $81, $40, $02, $81
	db $ac, $10, $46, $38, $99, $66, $20, $c0, $40, $80, $46, $80, $46, $80, $80, $00
;@ path: gfx/tiles/indoor
;@ Page $6C: copied to $9200 ($200 bytes) on the indoor maps whose entry in $01:$7F84 is $6C. 32 tiles.
;@ asset: tiles bpp=2 length=$200
IndoorMapTiles6C::
	db $00, $00, $7f, $00, $78, $3f, $7c, $3f, $5e, $3f, $4f, $3f, $47, $3f, $47, $3f
	db $00, $00, $fe, $00, $1e, $fc, $3e, $fc, $7a, $fc, $f2, $fc, $e2, $fc, $e2, $fc
	db $47, $3f, $47, $3f, $4f, $3f, $5e, $3f, $7c, $3f, $78, $3f, $7f, $00, $00, $00
	db $e2, $fc, $e2, $fc, $f2, $fc, $7a, $fc, $3e, $fc, $1e, $fc, $fe, $00, $00, $00
	db $26, $1d, $34, $0f, $d7, $0f, $6e, $85, $16, $e5, $fe, $f9, $05, $f8, $02, $fc
	db $64, $b8, $6c, $b0, $eb, $f0, $76, $a1, $68, $a7, $7f, $9f, $be, $05, $44, $3f
	db $02, $fc, $f5, $08, $fe, $f9, $16, $e5, $6e, $85, $d6, $0d, $36, $0d, $24, $1f
	db $44, $3f, $bf, $04, $7f, $9f, $68, $a7, $76, $a1, $6b, $b0, $6c, $b0, $24, $f8
	db $00, $00, $bf, $60, $32, $ed, $20, $ff, $20, $ff, $ff, $ff, $f7, $0c, $04, $ff
	db $ff, $ff, $ff, $ff, $04, $ff, $ff, $ff, $20, $ff, $bf, $60, $ff, $ff, $04, $ff
	db $46, $3d, $66, $1d, $47, $3f, $44, $3f, $66, $1d, $7e, $7d, $06, $7d, $46, $3d
	db $6b, $df, $6b, $df, $ef, $df, $6b, $df, $6b, $df, $7b, $ff, $4b, $ff, $6b, $df
	db $81, $00, $fe, $81, $92, $ed, $80, $ff, $e3, $ff, $ff, $ff, $ff, $3c, $3c, $df
	db $ff, $ff, $ff, $ff, $c7, $ff, $ff, $ff, $e6, $df, $ff, $64, $ff, $ff, $3c, $ff
	db $fe, $7d, $4e, $3d, $4f, $3e, $67, $1f, $47, $3f, $47, $3f, $6e, $1d, $8e, $7d
	db $6f, $df, $7f, $df, $ff, $ff, $eb, $df, $eb, $df, $fb, $ef, $7f, $ff, $7f, $df
	db $c4, $ff, $ff, $ff, $ff, $f0, $70, $ff, $7f, $df, $6c, $df, $6f, $df, $6b, $df
	db $07, $ff, $ff, $ff, $ff, $0f, $0e, $ff, $fe, $fb, $36, $fb, $f6, $fb, $d6, $fb
	db $6b, $df, $6b, $df, $6e, $df, $6f, $df, $78, $df, $7f, $f0, $ff, $ff, $c4, $ff
	db $d6, $fb, $d6, $fb, $76, $fb, $f6, $fb, $1e, $fb, $fe, $0f, $ff, $ff, $07, $ff
	db $6b, $5f, $ab, $df, $cb, $1f, $1b, $ef, $fb, $f7, $07, $fb, $ff, $ff, $ff, $ff
	db $d6, $fa, $d5, $fb, $d3, $f8, $d8, $f7, $df, $ef, $e0, $df, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $07, $fb, $fb, $f7, $1b, $ef, $cb, $1f, $ab, $df, $6b, $5f
	db $ff, $ff, $ff, $ff, $e0, $df, $df, $ef, $d8, $f7, $d3, $f8, $d5, $fb, $d6, $fa
	db $04, $ff, $ff, $ff, $bf, $60, $20, $ff, $ff, $ff, $04, $ff, $ff, $ff, $ff, $ff
	db $04, $ff, $f7, $0c, $ff, $ff, $20, $ff, $20, $ff, $32, $ed, $bf, $60, $00, $00
	db $d6, $fb, $d6, $fb, $f7, $fb, $d6, $fb, $d6, $fb, $de, $ff, $d2, $ff, $d6, $fb
	db $62, $bc, $66, $b8, $e2, $fc, $22, $fc, $66, $b8, $7e, $be, $60, $be, $62, $bc
	db $3c, $ff, $ff, $ff, $ff, $64, $e6, $df, $ff, $ff, $c7, $ff, $ff, $ff, $ff, $ff
	db $3c, $df, $ff, $3c, $ff, $ff, $e3, $ff, $80, $ff, $92, $ed, $fe, $81, $81, $00
	db $f6, $fb, $fe, $fb, $ff, $ff, $d7, $fb, $d7, $fb, $df, $f7, $fe, $ff, $fe, $fb
	db $71, $be, $76, $b8, $e2, $fc, $e2, $fc, $e6, $f8, $f2, $7c, $72, $bc, $7f, $be
;@ path: gfx/tiles/indoor
;@ Page $6E: copied to $9200 ($200 bytes) on the indoor maps whose entry in $01:$7F84 is $6E. 32 tiles.
;@ asset: tiles bpp=2 length=$200
IndoorMapTiles6E::
	db $00, $00, $1f, $00, $2c, $1f, $5f, $3f, $7c, $3f, $5e, $3f, $57, $3f, $53, $3f
	db $00, $00, $f8, $00, $34, $f8, $fa, $fc, $3e, $fc, $7a, $fc, $ea, $fc, $ca, $fc
	db $53, $3f, $57, $3f, $5e, $3f, $7c, $3f, $5f, $3f, $2c, $1f, $1f, $00, $00, $00
	db $ca, $fc, $ea, $fc, $7a, $fc, $3e, $fc, $fa, $fc, $34, $f8, $f8, $00, $00, $00
	db $39, $17, $09, $17, $83, $0e, $8b, $c6, $d7, $22, $0b, $f1, $3d, $f9, $ff, $c6
	db $9c, $e8, $90, $e8, $c1, $70, $d1, $63, $eb, $44, $d0, $8f, $bc, $9f, $ff, $63
	db $ff, $c6, $3d, $f9, $0b, $f1, $d7, $22, $8b, $c6, $83, $0e, $09, $17, $39, $17
	db $ff, $63, $bc, $9f, $d0, $8f, $eb, $44, $d1, $63, $c1, $70, $90, $e8, $9c, $e8
	db $00, $00, $bd, $7e, $66, $c3, $c3, $81, $c3, $3c, $00, $ff, $3c, $ff, $66, $ff
	db $ff, $ff, $3c, $ff, $81, $ff, $db, $e7, $3c, $ff, $81, $7e, $66, $99, $a5, $c3
	db $58, $37, $39, $67, $63, $4f, $42, $4f, $42, $4f, $63, $4f, $39, $67, $58, $37
	db $ad, $df, $49, $bf, $d3, $3f, $1b, $77, $1b, $77, $d3, $3f, $49, $bf, $ad, $df
	db $00, $00, $bd, $7e, $66, $c3, $83, $c3, $c3, $ff, $c7, $7e, $6e, $fd, $7f, $ff
	db $ff, $ff, $bb, $ff, $83, $ff, $ff, $c7, $fc, $ff, $30, $ff, $f9, $36, $ff, $f9
	db $5c, $3b, $2f, $7f, $63, $4f, $41, $4f, $43, $4f, $67, $4f, $3f, $7d, $5d, $3b
	db $df, $bf, $d9, $bf, $fb, $f7, $fb, $f7, $db, $b7, $99, $7f, $8f, $7f, $cf, $bf
	db $c7, $e1, $e1, $fe, $70, $ff, $38, $7f, $1c, $7f, $8f, $7f, $87, $7f, $c7, $bf
	db $e3, $87, $87, $7f, $0e, $ff, $1c, $fe, $38, $fe, $f1, $fe, $e1, $fe, $e3, $fd
	db $c7, $bf, $87, $7f, $8f, $7f, $1c, $7f, $38, $7f, $70, $ff, $e1, $fe, $c7, $e1
	db $e3, $fd, $e1, $fe, $f1, $fe, $38, $fe, $1c, $fe, $0e, $ff, $87, $7f, $e3, $87
	db $4d, $bf, $89, $3f, $2b, $df, $1b, $ef, $fb, $f7, $87, $fb, $3f, $ff, $ff, $ff
	db $b2, $fd, $91, $fc, $d4, $fb, $d8, $f7, $df, $ef, $e1, $df, $fc, $ff, $ff, $ff
	db $ff, $ff, $3f, $ff, $87, $fb, $fb, $f7, $1b, $ef, $2b, $df, $89, $3f, $4d, $bf
	db $ff, $ff, $fc, $ff, $e1, $df, $df, $ef, $d8, $f7, $d4, $fb, $91, $fc, $b2, $fd
	db $a5, $c3, $66, $99, $81, $7e, $3c, $ff, $db, $e7, $81, $ff, $3c, $ff, $ff, $ff
	db $66, $ff, $3c, $ff, $00, $ff, $c3, $3c, $c3, $81, $66, $c3, $bd, $7e, $00, $00
	db $b5, $fb, $92, $fd, $cb, $fc, $d8, $ee, $d8, $ee, $cb, $fc, $92, $fd, $b5, $fb
	db $1a, $ec, $9c, $e6, $c6, $f2, $42, $f2, $42, $f2, $c6, $f2, $9c, $e6, $1a, $ec
	db $ff, $f9, $f9, $36, $30, $ff, $fc, $ff, $ff, $c7, $83, $ff, $bb, $ff, $ff, $ff
	db $7f, $ff, $6e, $fd, $c7, $7e, $c3, $ff, $83, $c3, $66, $c3, $bd, $7e, $00, $00
	db $fb, $fd, $9b, $fd, $df, $ef, $df, $ef, $db, $ed, $99, $fe, $f1, $fe, $f3, $fd
	db $3a, $dc, $f4, $fe, $c6, $f2, $82, $f2, $c2, $f2, $e6, $f2, $fc, $be, $ba, $dc
;@ path: gfx/tiles/sideview
;@ Background tiles of the side-view rooms: LoadTileset09 copies them to $9000 ($800 bytes) in side-view rooms of the houses and caves and of map 6. 128 tiles.
;@ asset: tiles bpp=2 length=$800
SideViewTiles::
	db $ff, $00, $07, $f8, $00, $ff, $7c, $ff, $c7, $ff, $39, $c7, $fe, $01, $df, $20
	db $ff, $00, $fc, $03, $60, $9f, $00, $ff, $07, $ff, $dc, $ff, $73, $fc, $0f, $f0
	db $9f, $e0, $99, $e6, $cc, $f3, $c4, $f3, $d0, $e7, $ae, $c1, $ab, $c4, $bf, $c0
	db $fd, $03, $f7, $0f, $2f, $d9, $77, $99, $51, $9f, $49, $9f, $d7, $0f, $e9, $07
	db $0f, $ff, $33, $fc, $50, $e0, $a0, $c0, $a3, $c0, $d3, $e0, $cf, $f0, $8f, $f0
	db $f8, $ff, $14, $0f, $0a, $07, $05, $03, $05, $03, $fb, $07, $e3, $1f, $f1, $0f
	db $ff, $ff, $f3, $fc, $d8, $e0, $b0, $c0, $bf, $c0, $df, $e0, $c3, $fc, $8f, $f0
	db $ff, $ff, $17, $0f, $0b, $07, $05, $03, $1d, $03, $fb, $07, $e3, $1f, $f1, $0f
	db $ff, $ff, $c1, $ff, $80, $ff, $84, $ff, $80, $ff, $90, $ff, $c6, $ff, $ff, $ff
	db $ff, $ff, $83, $ff, $01, $ff, $09, $ff, $01, $ff, $01, $ff, $13, $ff, $ff, $ff
	db $ff, $ff, $c1, $80, $bf, $9c, $b7, $97, $b0, $90, $bf, $9f, $bd, $c3, $ff, $ff
	db $ff, $ff, $e1, $03, $bf, $39, $ef, $e9, $0f, $09, $ff, $f9, $fd, $83, $ff, $ff
	db $f3, $f3, $f0, $f0, $ff, $f0, $f7, $f8, $fc, $ff, $ff, $fc, $fd, $fe, $ff, $ff
	db $cf, $cf, $0f, $0f, $ff, $0f, $ef, $1f, $3f, $ff, $ff, $3f, $bf, $7f, $ff, $ff
	db $ff, $ff, $c0, $80, $bf, $80, $af, $80, $bf, $80, $bf, $80, $bc, $c3, $ff, $ff
	db $ff, $ff, $e1, $03, $1f, $01, $ff, $01, $ff, $01, $f7, $09, $7d, $83, $ff, $ff
	db $ff, $00, $e3, $1c, $81, $7e, $00, $ff, $3c, $ff, $e3, $ff, $98, $e7, $7f, $80
	db $ff, $00, $e3, $1c, $c1, $3e, $00, $ff, $3c, $ff, $c3, $ff, $18, $e7, $fe, $01
	db $9f, $e0, $ef, $f0, $b4, $9b, $ee, $99, $8e, $f9, $92, $f9, $eb, $f0, $97, $e0
	db $f9, $07, $39, $c7, $33, $cf, $13, $cf, $0b, $e7, $75, $83, $dd, $23, $fd, $03
	db $8b, $fc, $b4, $cf, $bb, $c7, $59, $e7, $22, $ff, $1c, $ff, $00, $ff, $00, $ff
	db $df, $3f, $31, $ff, $cd, $f3, $9d, $e3, $5d, $e3, $2d, $f3, $12, $ff, $0c, $ff
	db $8b, $fc, $b4, $cf, $bb, $c7, $d9, $e7, $e3, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $df, $3f, $31, $ff, $cd, $f3, $9d, $e3, $dd, $e3, $ed, $f3, $f3, $ff, $ff, $ff
	db $ff, $ff, $c3, $ff, $01, $ff, $11, $ff, $01, $ff, $01, $ff, $63, $ff, $ff, $ff
	db $ff, $ff, $c0, $ff, $82, $ff, $80, $ff, $81, $ff, $90, $ff, $c0, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $f7, $ef, $ff, $e0, $e0, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ef, $f7, $ff, $07, $07, $ff, $ff, $ff, $ff, $ff
	db $18, $ff, $18, $ff, $3f, $c0, $17, $e8, $3f, $c0, $3f, $ff, $18, $ff, $18, $ff
	db $18, $ff, $18, $ff, $fc, $03, $e8, $17, $fc, $03, $fc, $ff, $18, $ff, $18, $ff
	db $ff, $ff, $e1, $03, $1f, $01, $ff, $01, $ff, $01, $f7, $09, $7d, $83, $ff, $ff
	db $ff, $ff, $c0, $80, $bf, $80, $af, $80, $bf, $80, $bf, $80, $bc, $c3, $ff, $ff
	db $ff, $ff, $90, $a3, $85, $a2, $85, $a2, $85, $a2, $85, $a2, $dc, $a3, $ff, $ff
	db $ff, $ff, $03, $01, $03, $01, $37, $01, $0b, $01, $17, $01, $fd, $03, $ff, $ff
	db $ff, $ff, $fe, $81, $c0, $bf, $c8, $bf, $e0, $bf, $c8, $bf, $80, $ff, $ff, $ff
	db $ff, $ff, $dd, $e5, $67, $dd, $67, $dd, $67, $dd, $67, $dd, $c7, $fd, $ff, $ff
	db $30, $3f, $50, $7f, $98, $ff, $89, $ff, $8f, $ff, $89, $ff, $90, $ff, $50, $7f
	db $ff, $ff, $c1, $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $81, $ff, $c1, $ff
	db $ff, $ff, $83, $ff, $01, $ff, $00, $ff, $00, $ff, $00, $ff, $81, $ff, $83, $ff
	db $0c, $fc, $0a, $fe, $19, $ff, $91, $ff, $f1, $ff, $91, $ff, $09, $ff, $0a, $fe
	db $00, $ff, $01, $fe, $31, $ce, $20, $cf, $28, $c7, $15, $e2, $08, $f1, $07, $f8
	db $00, $ff, $80, $7f, $0c, $73, $94, $63, $28, $c7, $10, $0f, $66, $99, $8a, $71
	db $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fc, $00, $fc, $00, $f8, $00, $f8, $00
	db $fc, $00, $e0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $3f, $00, $0f, $00, $07, $00, $07, $00, $03, $00, $03, $00, $00, $00, $00, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $1f, $00, $07, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $ff, $98, $80, $80, $90, $80, $90, $80, $90, $80, $90, $a8, $90, $ff, $ff
	db $ff, $ff, $a7, $40, $00, $40, $87, $40, $8f, $40, $87, $40, $bf, $40, $ff, $ff
	db $ff, $ff, $fa, $07, $a6, $5b, $c3, $3e, $a3, $5e, $e3, $1e, $83, $7e, $ff, $ff
	db $ff, $ff, $cd, $3b, $0d, $fb, $19, $ff, $09, $ff, $49, $ff, $09, $ff, $ff, $ff
	db $30, $3f, $50, $7f, $98, $ff, $89, $ff, $8f, $ff, $89, $ff, $90, $ff, $d0, $ff
	db $ff, $ff, $c1, $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $81, $ff, $c1, $ff
	db $ff, $ff, $83, $ff, $01, $ff, $00, $ff, $00, $ff, $00, $ff, $81, $ff, $83, $ff
	db $0c, $fc, $0a, $fe, $19, $ff, $91, $ff, $f1, $ff, $91, $ff, $09, $ff, $0a, $fe
	db $00, $ff, $40, $9e, $61, $8e, $32, $c1, $1e, $e1, $00, $ff, $02, $fd, $04, $f8
	db $14, $e3, $b8, $47, $f0, $0f, $c2, $39, $12, $e1, $fc, $03, $00, $ff, $c0, $3f
	db $f8, $00, $c0, $00, $80, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $03, $00, $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $fe, $00, $fc, $00, $fc, $00, $f8, $00, $f8, $00, $c0, $00, $80, $00, $00, $00
	db $1f, $00, $0f, $00, $0f, $00, $07, $00, $03, $00, $03, $00, $01, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $00, $7e, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $ce, $31, $ce, $31, $cf, $30, $ce, $31, $8e, $71, $8e, $71, $8f, $70, $cf, $30
	db $cd, $3f, $c9, $3f, $c8, $3f, $4c, $bf, $04, $ff, $04, $ff, $c4, $3f, $cc, $3f
	db $ff, $ff, $00, $00, $ff, $00, $ff, $ff, $13, $1e, $12, $1f, $09, $0f, $05, $06
	db $ff, $ff, $01, $01, $ff, $01, $ff, $ff, $c8, $78, $48, $f8, $90, $f0, $a0, $60
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $df, $bf, $df, $bf, $af, $df, $ef, $df, $47, $ff, $47, $ff, $63, $ff, $33, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $31, $ff, $37, $ff, $37, $ff, $37, $ff, $a3, $ff, $a3, $ff, $33, $ff, $33, $ff
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $ff, $c0
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fb, $fd, $fb, $fd, $f5, $fb, $f7, $fb, $e2, $ff, $e2, $ff, $c6, $ff, $cc, $ff
	db $00, $00, $01, $00, $07, $00, $3f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $f0, $00, $f9, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $00, $70, $00, $f8, $00, $fe, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $c7, $38, $8f, $70, $1c, $e0, $58, $e0, $58, $e0, $d8, $e0, $cc, $f0, $e7, $f8
	db $8e, $7f, $ce, $3f, $c7, $3f, $63, $1f, $63, $1f, $63, $1f, $c7, $3f, $87, $7f
	db $05, $06, $05, $06, $05, $06, $ff, $ff, $80, $80, $bf, $80, $9c, $e3, $ff, $ff
	db $a0, $60, $a0, $60, $a0, $60, $ff, $ff, $01, $01, $f7, $09, $7d, $83, $ff, $ff
	db $f7, $08, $e7, $18, $cd, $32, $c9, $36, $89, $76, $81, $7e, $80, $7f, $00, $ff
	db $7f, $80, $3f, $c0, $3b, $c4, $1b, $e4, $19, $e6, $09, $f6, $01, $fe, $00, $ff
	db $3f, $ff, $6b, $f7, $59, $e7, $b9, $c7, $bb, $c7, $b2, $cf, $a6, $df, $a7, $df
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $1c, $ff, $76, $8f, $7b, $87, $3d, $c3, $8e, $f1, $8e, $f1, $c6, $f9, $f0, $ff
	db $7f, $e0, $9f, $70, $4f, $b8, $a7, $dc, $b7, $cc, $d5, $ee, $c7, $fe, $c7, $fe
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fc, $ff, $d6, $ef, $9a, $e7, $9d, $e3, $dd, $e3, $4d, $f3, $65, $fb, $e5, $fb
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $03
	db $8d, $fe, $cd, $fe, $cd, $fe, $cd, $fe, $85, $fe, $85, $fe, $8d, $fe, $8d, $fe
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f6, $3f, $ff, $49, $c9, $80, $80, $80, $b6, $80, $ff, $a0, $ff, $f6, $ff, $ff
	db $76, $ff, $ff, $89, $88, $00, $30, $00, $7c, $00, $ff, $10, $ff, $3c, $c3, $ff
	db $76, $ff, $ff, $89, $88, $00, $30, $00, $7c, $00, $ff, $10, $ff, $3c, $c3, $ff
	db $76, $ff, $ff, $89, $88, $00, $30, $00, $7c, $00, $ff, $10, $ff, $3c, $c3, $ff
	db $76, $ff, $ff, $89, $88, $00, $30, $00, $7c, $00, $ff, $10, $ff, $3c, $c3, $ff
	db $6f, $fc, $ff, $92, $93, $01, $01, $01, $6d, $01, $ff, $05, $ff, $6f, $ff, $ff
	db $60, $7f, $60, $7f, $20, $7f, $30, $3f, $18, $3f, $0e, $1f, $07, $0f, $01, $03
	db $03, $ff, $03, $ff, $02, $ff, $06, $fe, $0c, $fe, $f8, $fc, $f0, $f8, $80, $c0
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $fc, $0f, $f0, $1f, $e2, $3d, $e5, $3b, $cd, $73, $ca, $77, $9a, $e7, $82, $ff
	db $1f, $f8, $2b, $f0, $c3, $e0, $a7, $c0, $6e, $81, $7c, $83, $7c, $83, $70, $8f
	db $ff, $ff, $dd, $ff, $ff, $dd, $dd, $dd, $99, $dd, $dd, $99, $dd, $99, $ff, $ff
	db $ff, $ff, $dd, $ff, $ff, $dd, $dd, $dd, $99, $dd, $dd, $99, $dd, $99, $ff, $ff
	db $9f, $e0, $99, $e6, $cc, $f3, $c4, $f3, $d0, $e7, $ae, $c1, $ab, $c4, $bf, $c0
	db $ff, $00, $fc, $03, $60, $9f, $00, $ff, $07, $ff, $dc, $ff, $73, $fc, $0f, $f0
	db $ff, $00, $07, $f8, $00, $ff, $7c, $ff, $c7, $ff, $39, $c7, $fe, $01, $df, $20
	db $ff, $00, $fc, $03, $60, $9f, $00, $ff, $07, $ff, $dc, $ff, $73, $fc, $0f, $f0
	db $ff, $00, $07, $f8, $00, $ff, $7c, $ff, $c7, $ff, $39, $c7, $fe, $01, $df, $20
	db $fd, $03, $f7, $0f, $2f, $d9, $77, $99, $51, $9f, $49, $9f, $d7, $0f, $e9, $07
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $18, $ff, $3c, $ff, $ff, $ff, $ff, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $18, $ff, $3c, $ff, $ff, $ff, $ff, $ff
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: gfx/tiles/sideview
;@ Background tiles of the side-view rooms of the dungeons (maps below $0A except 6) and of room $E9: copied to $9000 ($800 bytes) by LoadTileset09. 128 tiles.
;@ asset: tiles bpp=2 length=$800
DungeonSideViewTiles::
	db $46, $ff, $45, $fe, $c9, $fe, $f9, $fe, $c4, $ff, $9a, $e7, $bd, $c3, $be, $c1
	db $20, $ff, $90, $7f, $c8, $3f, $a7, $5f, $f3, $0f, $79, $87, $01, $ff, $ff, $ff
	db $e6, $9f, $85, $fe, $c9, $fe, $f9, $fe, $c4, $ff, $aa, $c7, $8d, $c3, $be, $c1
	db $35, $fb, $89, $7f, $d7, $0f, $cb, $07, $e5, $03, $79, $87, $03, $ff, $ff, $ff
	db $0f, $ff, $30, $ff, $6f, $f0, $d0, $e0, $a3, $c0, $b3, $c0, $be, $c1, $98, $e7
	db $f0, $ff, $1c, $ff, $e6, $1f, $13, $0f, $0b, $07, $e9, $07, $79, $87, $31, $cf
	db $ff, $ff, $f0, $ff, $ef, $f0, $d0, $e0, $a3, $c0, $b3, $c0, $be, $c1, $98, $e7
	db $ff, $ff, $1f, $ff, $e7, $1f, $13, $0f, $0b, $07, $e9, $07, $79, $87, $31, $cf
	db $ff, $ff, $86, $ff, $bf, $ff, $bf, $ff, $bf, $ff, $ff, $ff, $bf, $ff, $ff, $ff
	db $ff, $ff, $17, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $e7, $ff, $ff, $ff, $c0, $c0, $e8, $e8, $c0, $c0, $ff, $ff, $e7, $ff, $e7, $ff
	db $e7, $ff, $ff, $ff, $03, $03, $17, $17, $c3, $03, $ff, $ff, $e7, $ff, $e7, $ff
	db $f3, $f3, $f0, $f0, $ff, $f0, $f7, $f8, $fc, $ff, $ff, $fc, $fd, $fe, $ff, $ff
	db $cf, $cf, $0f, $0f, $ff, $0f, $ef, $1f, $3f, $ff, $ff, $3f, $bf, $7f, $ff, $ff
	db $ff, $ff, $c0, $80, $bf, $80, $af, $90, $ad, $82, $ff, $80, $9c, $e3, $c0, $ff
	db $ff, $ff, $e1, $03, $1f, $01, $ff, $01, $f7, $09, $f7, $01, $79, $87, $03, $ff
	db $83, $fc, $e7, $f8, $22, $fd, $d0, $3f, $d1, $3f, $be, $7f, $2a, $f7, $33, $ef
	db $83, $7f, $07, $ff, $0c, $ff, $fb, $fc, $5f, $b8, $95, $7a, $26, $f9, $e4, $fb
	db $c3, $fc, $e7, $f8, $d2, $fd, $a8, $df, $b7, $8f, $96, $8f, $da, $87, $b3, $cf
	db $b9, $47, $33, $cf, $0f, $ff, $f1, $ff, $4f, $b1, $9b, $61, $1b, $e1, $cf, $f1
	db $be, $c1, $be, $c1, $fd, $c3, $59, $e7, $63, $ff, $3e, $ff, $1c, $ff, $00, $ff
	db $83, $ff, $9f, $e1, $bf, $c1, $bd, $c3, $99, $e7, $c3, $ff, $66, $ff, $3c, $ff
	db $be, $c1, $be, $c1, $fd, $c3, $d9, $e7, $e3, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $83, $ff, $9f, $e1, $bf, $c1, $bd, $c3, $99, $e7, $c3, $ff, $e7, $ff, $ff, $ff
	db $ff, $ff, $17, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $86, $ff, $bf, $ff, $bf, $ff, $bf, $ff, $ff, $ff, $bf, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $f7, $ef, $ff, $e0, $e0, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ef, $f7, $ff, $07, $07, $ff, $ff, $ff, $ff, $ff
	db $18, $ff, $18, $ff, $3f, $c0, $17, $e8, $3f, $c0, $3f, $ff, $18, $ff, $18, $ff
	db $18, $ff, $18, $ff, $fc, $03, $e8, $17, $fc, $03, $fc, $ff, $18, $ff, $18, $ff
	db $ff, $ff, $e1, $03, $1f, $01, $ff, $01, $f7, $09, $f7, $01, $7d, $83, $83, $ff
	db $ff, $ff, $c0, $80, $bf, $80, $af, $90, $af, $80, $bf, $80, $bc, $c3, $c1, $ff
	db $8c, $f0, $9c, $e0, $e1, $fe, $f0, $c0, $ce, $f0, $cc, $f0, $c4, $f8, $c6, $f8
	db $79, $07, $31, $0f, $87, $7f, $0f, $01, $71, $0f, $21, $1f, $21, $1f, $71, $0f
	db $ff, $ff, $40, $80, $80, $00, $cc, $00, $7f, $80, $00, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $04, $03, $02, $01, $16, $01, $fc, $03, $01, $ff, $ff, $ff, $ff, $ff
	db $53, $ef, $cb, $f7, $e7, $ff, $bc, $ff, $a7, $ff, $80, $ff, $91, $ff, $c0, $ff
	db $9e, $ff, $4f, $bf, $6f, $9f, $91, $ff, $61, $ff, $09, $ff, $83, $ff, $0f, $ff
	db $c0, $ff, $e5, $ff, $f0, $ff, $f8, $ff, $e6, $ff, $e0, $ff, $f0, $ff, $fc, $ff
	db $7f, $ff, $df, $ff, $1f, $ff, $1f, $ff, $bf, $ff, $3f, $ff, $7f, $ff, $bf, $ff
	db $fd, $fe, $fa, $fd, $f4, $fb, $c0, $ff, $d2, $ef, $80, $ff, $39, $ff, $f7, $ff
	db $bf, $7f, $df, $3f, $6f, $9f, $37, $cf, $1b, $e7, $2b, $df, $5d, $bf, $3f, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $eb, $f7, $e1, $ff
	db $ff, $ff, $ff, $ef, $ff, $7d, $e3, $ff, $d5, $e3, $dd, $e3, $c3, $ff, $ef, $ff
	db $0d, $0e, $0d, $0e, $0e, $0f, $0a, $0f, $08, $0f, $09, $0e, $09, $0e, $09, $0e
	db $d8, $38, $c8, $38, $c8, $38, $48, $b8, $08, $f8, $28, $f8, $b8, $78, $f8, $38
	db $00, $00, $03, $03, $05, $06, $09, $0e, $08, $0f, $09, $0e, $09, $0e, $09, $0e
	db $00, $00, $e0, $e0, $d0, $30, $c8, $38, $08, $f8, $28, $f8, $b8, $78, $f8, $38
	db $ce, $f0, $cc, $f0, $cc, $f0, $c6, $f8, $f1, $fe, $e0, $80, $9c, $e0, $8e, $f0
	db $31, $0f, $21, $1f, $61, $1f, $71, $0f, $8f, $7f, $0f, $01, $31, $0f, $79, $07
	db $eb, $1c, $1c, $eb, $08, $ff, $ff, $ff, $b0, $cf, $c1, $be, $80, $ff, $ff, $ff
	db $eb, $1c, $0c, $fb, $08, $ff, $ff, $ff, $be, $c1, $c0, $bf, $80, $ff, $ff, $ff
	db $e4, $ff, $ff, $ff, $c8, $ff, $c0, $ff, $c4, $ff, $e0, $ff, $de, $ff, $c0, $ff
	db $1f, $ff, $47, $ff, $07, $ff, $0f, $ff, $3f, $ff, $0f, $ff, $8f, $ff, $1f, $ff
	db $f3, $ff, $f0, $ff, $f9, $ff, $fc, $ff, $fb, $ff, $f8, $ff, $fc, $ff, $ff, $ff
	db $3f, $ff, $7f, $ff, $bf, $ff, $7f, $ff, $ff, $ff, $7f, $ff, $ff, $ff, $ff, $ff
	db $ff, $3f, $3f, $df, $0f, $ff, $a7, $ff, $17, $ff, $af, $7f, $3f, $ff, $ff, $ff
	db $ff, $f0, $f8, $e7, $e4, $db, $c2, $bd, $38, $ff, $fe, $ff, $ff, $ff, $ff, $ff
	db $fd, $ff, $fb, $ff, $fb, $ff, $ef, $ff, $cd, $ff, $eb, $dd, $cc, $bb, $00, $ff
	db $f7, $ff, $f7, $ff, $6f, $ff, $2f, $ff, $6f, $bf, $49, $bf, $41, $bf, $00, $ff
	db $0d, $0e, $0d, $0e, $0e, $0f, $0a, $0f, $08, $0f, $09, $0e, $09, $0e, $09, $0e
	db $d8, $38, $c8, $38, $c8, $38, $48, $b8, $08, $f8, $28, $f8, $b8, $78, $f8, $38
	db $0d, $0e, $0d, $0e, $0e, $0f, $0a, $0f, $08, $0f, $09, $0e, $09, $0e, $09, $0e
	db $d8, $38, $c8, $38, $c8, $38, $48, $b8, $08, $f8, $28, $f8, $b8, $78, $f8, $38
	db $ff, $ff, $ff, $f0, $f3, $e0, $e7, $c0, $ff, $c6, $ff, $d6, $ff, $d2, $ff, $c8
	db $ff, $ff, $bf, $7f, $df, $3f, $7f, $9f, $ff, $1f, $ff, $7f, $ff, $ff, $ff, $bf
	db $ef, $f0, $ed, $f2, $f7, $db, $f7, $da, $db, $fe, $de, $f5, $ff, $d1, $fe, $d1
	db $7b, $df, $bf, $db, $6f, $9b, $ef, $1b, $6b, $9f, $5f, $bb, $df, $b9, $ef, $fb
	db $ff, $fe, $fc, $fd, $f8, $f9, $fb, $f9, $ff, $f9, $fb, $fc, $fc, $fe, $fe, $fe
	db $7f, $ff, $3f, $ff, $5f, $bf, $ff, $9f, $ff, $9f, $5f, $bf, $3f, $ff, $7f, $ff
	db $ff, $ff, $c0, $c0, $b8, $c7, $b3, $cc, $a7, $d8, $c0, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $07, $03, $cd, $33, $9d, $63, $bd, $43, $03, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $01, $00, $07, $03, $0c, $00, $3f, $18, $60, $30, $c0
	db $00, $3c, $20, $c6, $48, $86, $08, $f6, $30, $0e, $3c, $c3, $4c, $33, $f4, $0b
	db $00, $ff, $01, $fe, $31, $ce, $20, $cf, $28, $c7, $15, $e2, $08, $f1, $07, $f8
	db $00, $ff, $80, $7f, $0c, $73, $94, $63, $28, $c7, $10, $0f, $66, $99, $8a, $71
	db $ff, $ff, $ff, $ff, $fe, $fe, $ff, $fe, $fb, $f9, $9c, $8b, $38, $24, $63, $40
	db $f9, $f1, $37, $23, $ba, $97, $36, $1f, $fc, $3f, $ec, $c7, $06, $03, $cb, $31
	db $ff, $f0, $ff, $c0, $bf, $d9, $bf, $d9, $bf, $c9, $bf, $c0, $9f, $ee, $ff, $e4
	db $df, $3f, $ef, $1f, $f7, $cf, $f7, $cf, $f7, $8f, $e7, $1f, $8f, $7f, $7f, $ff
	db $ff, $e1, $ff, $f5, $ef, $fe, $cf, $f8, $df, $ef, $df, $ea, $d6, $e9, $c9, $f6
	db $ff, $bf, $ff, $bf, $af, $7f, $4f, $fb, $bf, $d3, $5f, $bb, $ef, $3b, $df, $7b
	db $de, $f7, $fe, $f5, $f5, $fe, $f6, $ff, $ff, $fe, $fd, $fe, $fe, $fd, $ff, $fd
	db $eb, $dd, $fd, $df, $ed, $df, $df, $6d, $df, $6d, $7d, $cf, $ef, $df, $df, $ff
	db $ff, $fe, $fc, $fd, $f8, $f9, $fb, $f9, $ff, $f9, $fb, $fc, $fc, $fe, $fe, $fe
	db $7f, $ff, $3f, $ff, $5f, $bf, $ff, $9f, $ff, $9f, $5f, $bf, $3f, $ff, $7f, $ff
	db $11, $ff, $22, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $11, $ff, $22, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $3f, $c0, $3c, $c3, $38, $c7, $38, $c7, $33, $cc, $30, $cf, $30, $cc, $00, $f8
	db $f8, $07, $3c, $c3, $0c, $f3, $0c, $f3, $f8, $06, $00, $fc, $00, $00, $00, $00
	db $00, $ff, $40, $9e, $61, $8e, $32, $c1, $1e, $e1, $00, $ff, $02, $fd, $04, $f8
	db $14, $e3, $b8, $47, $f0, $0f, $c2, $39, $12, $e1, $fc, $03, $00, $ff, $c0, $3f
	db $dd, $03, $77, $8f, $9e, $ff, $fd, $f6, $ff, $f4, $ff, $ff, $d0, $e0, $e0, $ff
	db $f3, $f9, $d5, $fb, $b5, $db, $fb, $97, $fb, $e7, $f4, $cf, $e8, $1f, $1f, $ff
	db $ff, $20, $3f, $d4, $0f, $ff, $a7, $ff, $17, $ff, $af, $7f, $3f, $ff, $ff, $ff
	db $ff, $f0, $f8, $e7, $e4, $db, $c2, $bd, $38, $ff, $fe, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $c0, $7f, $e0, $7f, $b8, $ff, $8f, $ff, $c0, $ff, $60, $ff, $38, $ff
	db $ff, $ff, $06, $fc, $0f, $fc, $3b, $ff, $e3, $ff, $07, $ff, $0d, $ff, $39, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $7f, $80, $1f, $87, $78, $88, $14, $f3, $73, $97, $77, $97, $17, $f7
	db $ff, $ff, $fe, $01, $f8, $e1, $1e, $11, $2c, $cb, $ce, $e9, $ee, $e9, $e8, $ef
	db $ff, $ff, $ff, $1c, $0c, $fb, $0c, $fb, $0c, $ff, $ff, $ff, $bd, $c3, $c1, $bf
	db $ff, $ff, $f7, $38, $58, $f7, $18, $f7, $10, $ff, $ff, $ff, $7f, $81, $81, $7f
	db $ff, $ff, $7f, $80, $90, $00, $ff, $00, $07, $fb, $fe, $02, $63, $9f, $1f, $e0
	db $ff, $ff, $fe, $01, $c1, $00, $ff, $00, $b4, $cb, $ff, $80, $8e, $f1, $f0, $0f
	db $9f, $8f, $ec, $c4, $5d, $e9, $6c, $f8, $3f, $fc, $37, $e3, $60, $c0, $d3, $8c
	db $ff, $ff, $ff, $ff, $7f, $7f, $ff, $7f, $df, $9f, $39, $d1, $1c, $24, $c6, $02
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $0f, $ff, $80, $ff, $e0, $ff, $7f, $ff, $df, $3f, $ff, $00, $e1, $00, $80, $00
	db $e1, $ff, $03, $ff, $0f, $ff, $fd, $fe, $f7, $f8, $ff, $00, $ff, $00, $7f, $00
	db $ff, $ff, $dd, $ff, $ff, $dd, $dd, $dd, $99, $dd, $dd, $99, $dd, $99, $ff, $ff
	db $ff, $ff, $dd, $ff, $ff, $dd, $dd, $dd, $99, $dd, $dd, $99, $dd, $99, $ff, $ff
	db $77, $97, $57, $b7, $7b, $93, $0c, $f8, $3f, $ff, $80, $ff, $ff, $ff, $ff, $ff
	db $ee, $e9, $ee, $e9, $d8, $cf, $30, $1f, $fc, $ff, $03, $ff, $ff, $ff, $ff, $ff
	db $c1, $bf, $81, $ff, $ff, $ff, $eb, $1c, $1c, $eb, $0c, $fb, $0c, $ff, $ff, $ff
	db $81, $7f, $01, $ff, $ff, $ff, $eb, $1c, $0c, $fb, $0c, $fb, $18, $ff, $ff, $ff
	db $ff, $00, $c3, $3f, $7e, $82, $03, $ff, $3c, $ff, $80, $ff, $ff, $ff, $ff, $ff
	db $ff, $00, $8e, $f1, $f0, $8f, $80, $ff, $7c, $ff, $03, $ff, $ff, $ff, $ff, $ff
	db $cf, $9f, $ab, $df, $ad, $db, $df, $e9, $df, $e7, $2f, $f3, $17, $f8, $f8, $ff
	db $bb, $c0, $ee, $f1, $79, $ff, $bf, $6f, $ff, $2f, $ff, $ff, $0b, $07, $07, $ff
	db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
	db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
