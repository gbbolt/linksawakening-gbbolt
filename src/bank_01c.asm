; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

DialogTablesStart::
	db $01

DialogPointers::
	db $00, $5c, $59, $5c, $1a, $5d, $b9, $5d, $45, $5e, $93, $5e, $da, $5e, $86
	db $5f, $c5, $5f, $12, $60, $72, $60, $17, $61, $64, $61, $ac, $61, $fa, $61, $84
	db $62, $ee, $62, $3e, $63, $6f, $63, $15, $64, $71, $64, $d7, $64, $11, $65, $7d
	db $65, $da, $65, $19, $66, $58, $66, $01, $67, $37, $67, $62, $67, $bc, $67, $f6
	db $67, $1e, $68, $27, $68, $68, $68, $81, $68, $9a, $68, $f3, $68, $4f, $69, $ab
	db $69, $29, $6a, $80, $6a, $e1, $6a, $2c, $6b, $2c, $6b, $5c, $6b, $8b, $6b, $ca
	db $6b, $f7, $6b, $38, $6c, $67, $6c, $96, $6c, $c5, $6c, $14, $6d, $34, $6d, $6e
	db $6d, $6e, $6d, $b6, $6d, $06, $6e, $06, $6e, $32, $6e, $9d, $6e, $cc, $6e, $e8
	db $6e, $f3, $6e, $23, $6f, $6b, $6f, $ac, $6f, $0b, $70, $57, $70, $b8, $70, $e7
	db $70, $67, $71, $a8, $71, $e9, $71, $4a, $72, $96, $72, $c7, $72, $33, $73, $a1
	db $73, $c2, $73, $13, $74, $49, $74, $84, $74, $cb, $74, $88, $75, $38, $76, $57
	db $76, $78, $76, $99, $76, $ba, $76, $db, $76, $fc, $76, $1d, $77, $3e, $77, $4f
	db $77, $4f, $77, $60, $77, $7c, $77, $8a, $77, $a7, $77, $b6, $77, $c7, $77, $e8
	db $77, $f7, $77, $06, $78, $16, $78, $27, $78, $38, $78, $59, $78, $6a, $78, $7b
	db $78, $8c, $78, $9d, $78, $ae, $78, $bf, $78, $cf, $78, $de, $78, $ee, $78, $fe
	db $78, $0e, $79, $1e, $79, $2e, $79, $3f, $79, $5b, $79, $6c, $79, $9c, $79, $bd
	db $79, $00, $57, $1d, $57, $39, $57, $4a, $57, $5b, $57, $6c, $57, $7d, $57, $8e
	db $57, $9f, $57, $b0, $57, $c1, $57, $0f, $58, $59, $58, $9a, $58, $f8, $58, $36
	db $59, $57, $59, $9f, $59, $e0, $59, $a1, $5a, $e9, $5a, $3a, $5b, $84, $5b, $c5
	db $5b, $12, $5c, $4e, $5c, $99, $5c, $99, $5c, $e9, $5c, $4a, $5d, $a2, $5d, $a2
	db $5d, $e8, $5d, $e8, $5d, $28, $5e, $71, $5e, $8d, $5e, $a7, $5e, $c1, $5e, $00
	db $5f, $c1, $5f, $17, $60, $6d, $60, $a3, $60, $ce, $60, $fd, $60, $2d, $61, $5e
	db $61, $ab, $61, $cc, $61, $fc, $61, $3c, $62, $9d, $62, $d7, $62, $55, $63, $b3
	db $63, $2f, $64, $2f, $64, $ae, $64, $05, $65, $05, $65, $62, $65, $12, $66, $12
	db $66, $12, $66, $c3, $67, $54, $68, $b2, $69, $21, $6a, $f2, $6a, $32, $6c, $d3
	db $6c, $81, $6d, $02, $6f, $fe, $6f, $ce, $70, $bd, $71, $fd, $72, $49, $73, $49
	db $73, $5a, $75, $88, $77, $88, $77, $c7, $77, $c7, $77, $c7, $77, $d8, $77, $d8
	db $77, $24, $78, $6e, $78, $cc, $79, $f8, $79, $78, $7a, $77, $7b, $a6, $7b, $dc
	db $7b, $4d, $7c, $99, $7c, $17, $7d, $65, $7d, $b3, $7d, $01, $7e, $70, $7e, $d0
	db $7e, $00, $67, $50, $67, $ac, $67, $ac, $67, $ac, $67, $fa, $67, $58, $68, $a6
	db $68, $0e, $69, $4e, $69, $7f, $69, $9a, $69, $b5, $69, $d5, $69, $13, $6b, $84
	db $6b, $c4, $6b, $02, $6c, $73, $6c, $7c, $6c, $85, $6c, $bb, $6c, $f2, $6c, $51
	db $6d, $00, $4a, $21, $4a, $3d, $4a, $5e, $4a, $79, $4a, $97, $4a, $b7, $4a, $e7
	db $4a, $05, $4b, $31, $4b, $73, $4b, $a1, $4b, $cf, $4b, $fb, $4b, $29, $4c, $57
	db $4c, $9c, $4c, $fb, $4c, $4b, $4d, $8b, $4d, $b7, $4d, $0e, $4e, $1f, $4e, $57
	db $4e, $57, $4e, $d7, $4e, $6e, $4f, $e6, $4f, $5b, $50, $ab, $50, $17, $51, $96
	db $51, $2c, $52, $90, $52, $f0, $52, $85, $53, $ba, $53, $ba, $53, $ba, $53, $ba
	db $53, $d5, $53, $2d, $54, $7d, $54, $2d, $55, $69, $55, $aa, $55, $34, $56, $34
	db $56, $0f, $57, $4e, $57, $d7, $57, $77, $58, $15, $59, $73, $59, $22, $5a, $70
	db $5a, $b0, $5a, $df, $5a, $0e, $5b, $8e, $5c, $34, $5d, $92, $5d, $0a, $5e, $47
	db $5e, $a7, $5e, $24, $5f, $a1, $5f, $62, $60, $22, $61, $10, $62, $8e, $62, $26
	db $63, $e7, $63, $6f, $64, $f7, $64, $d4, $65, $61, $66, $df, $66, $6f, $67, $80
	db $68, $0e, $69, $3f, $69, $7f, $69, $b0, $69, $e1, $69, $12, $6a, $51, $6a, $82
	db $6a, $b2, $6a, $b2, $6a, $ce, $6a, $ee, $6a, $2d, $6b, $79, $6b, $d9, $6b, $26
	db $6c, $46, $6c, $75, $6c, $b6, $6c, $f7, $6c, $24, $6d, $61, $6d, $9e, $6d, $7a
	db $6e, $06, $6f, $76, $6f, $b3, $6f, $e2, $6f, $70, $70, $a0, $70, $00, $00, $00
	db $00, $da, $70, $58, $71, $72, $71, $c0, $71, $11, $72, $2c, $72, $59, $72, $77
	db $72, $f6, $72, $60, $73, $60, $73, $60, $73, $60, $73, $60, $73, $60, $73, $60
	db $73, $00, $40, $61, $40, $0e, $41, $3d, $41, $65, $41, $95, $41, $e1, $41, $02
	db $42, $2f, $42, $78, $42, $05, $43, $35, $43, $c2, $43, $49, $44, $83, $44, $a3
	db $44, $a3, $44, $f2, $44, $71, $45, $20, $46, $50, $46, $f1, $46, $86, $47, $c7
	db $47, $52, $48, $b3, $48, $da, $48, $1b, $49, $d3, $49, $1e, $4a, $2f, $4a, $50
	db $4a, $50, $4a, $91, $4a, $ef, $4a, $30, $4b, $41, $4b, $62, $4b, $8b, $4b, $d4
	db $4b, $e5, $4b, $15, $4c, $23, $4c, $31, $4c, $3f, $4c, $4d, $4c, $6a, $4c, $99
	db $4c, $b7, $4c, $d6, $4c, $f5, $4c, $16, $4d, $37, $4d, $47, $4d, $68, $4d, $99
	db $4d, $c8, $4d, $f6, $4d, $24, $4e, $45, $4e, $76, $4e, $a2, $4e, $da, $4e, $23
	db $4f, $23, $4f, $82, $4f, $cf, $4f, $e9, $4f, $2a, $50, $2a, $50, $b4, $50, $80
	db $51, $0f, $52, $2f, $52, $8e, $52, $fe, $52, $39, $53, $59, $53, $ca, $53, $2a
	db $54, $96, $54, $d7, $54, $21, $55, $3e, $56, $77, $56, $d0, $56, $3f, $57, $6e
	db $57, $88, $57, $93, $58, $73, $59, $c2, $59, $ff, $59, $5d, $5a, $a4, $5a, $f3
	db $5a, $f3, $5a, $14, $5b, $73, $5b, $aa, $5b, $eb, $5b, $3c, $5c, $7b, $5c, $a6
	db $5c, $46, $5d, $f2, $5d, $31, $5e, $6f, $5e, $a0, $5e, $cb, $5e, $f7, $5e, $f7
	db $5e, $f7, $5e, $98, $5f, $be, $5f, $2c, $60, $4b, $60, $6b, $60, $c9, $60, $c9
	db $60, $45, $61, $45, $61, $56, $61, $72, $61, $8b, $61, $a6, $61, $40, $62, $bc
	db $62, $78, $63, $c7, $63, $97, $64, $e6, $64, $a6, $65, $e5, $65, $f5, $66, $34
	db $67, $32, $68, $71, $68, $7e, $69, $ad, $69, $59, $6a, $e8, $6a, $46, $6b, $af
	db $6b, $af, $6b, $de, $6b, $1f, $6c, $3f, $6c, $6f, $6c, $9e, $6c, $de, $6c, $2e
	db $6d, $9c, $6d, $0a, $6e, $78, $6e, $e6, $6e, $17, $6f, $51, $6f, $77, $6f, $d6
	db $6f, $d6, $6f, $85, $71, $01, $72, $52, $72, $72, $72, $b0, $72, $11, $73, $4c
	db $73, $88, $73, $88, $73, $88, $73, $88, $73, $88, $73, $88, $73, $88, $73, $88
	db $73, $88, $73, $b7, $73, $e7, $73, $18, $74, $47, $74, $76, $74, $86, $74, $e3
	db $74, $0e, $75, $3f, $75, $6e, $75, $af, $75, $c0, $75, $c0, $75, $c0, $75, $c0
	db $75, $c0, $75, $68, $76, $15, $77, $a3, $77, $74, $78, $f5, $78, $d3, $79, $b1
	db $7a, $60, $7b, $ce, $7b, $ce, $7b, $5a, $7c, $9b, $7c, $b6, $7d, $30, $7e, $a8
	db $7e, $f7, $7e, $47, $7f, $98, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7
	db $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7
	db $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7
	db $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7
	db $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $b7, $7f, $00, $7d, $60
	db $7d, $ae, $7d, $e7, $7d, $23, $7e, $3d, $7e, $64, $7e, $6d, $7e, $99, $7e, $c3
	db $7e

DialogCharTileLow::
	db $00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $a0, $b0, $c0, $d0, $e0
	db $f0, $00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $a0, $b0, $c0, $d0, $e0
	db $f0

DialogCharTileHigh::
	db $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d
	db $8d, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e
	db $8e

DialogCharTileNumbers::
	db $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de
	db $df, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $ee
	db $ef

DialogCharBGHigh::
	db $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98
	db $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98
	db $98, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99
	db $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99
	db $99

DialogCharBGLow::
	db $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50
	db $51, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $90
	db $91, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $70
	db $71, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $b0
	db $b1

DialogCharGlyphs::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $7e, $3d, $41, $00, $8a, $8b, $44, $40, $45, $46, $8c, $8d, $3a, $3f, $3b
	db $00, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $42, $43, $8e, $00, $8f
	db $3c, $00, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d
	db $0e, $0f, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $00, $00, $00, $40
	db $00, $00, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24, $25, $26, $27
	db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $3e, $00, $00, $00, $00
	db $00, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53, $59, $5a
	db $5b, $5c, $5d, $59, $5a, $5b, $5c, $5d, $32, $6f, $6d, $6e, $00, $00, $00, $00
	db $00, $3d, $3c, $3f, $7e, $39, $3a, $3b, $7a, $7b, $00, $00, $00, $00, $00, $00
	db $00, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $9b, $9c, $9d, $9e, $9f
	db $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e
	db $8f, $88, $90, $91, $92, $93, $94, $95, $89, $96, $97, $98, $99, $9a, $87, $86
	db $00, $34, $35, $36, $37, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7e, $00
	db $00

DialogBanks::
	db $14, $94, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14
	db $94, $14, $14, $14, $94, $14, $14, $94, $14, $14, $14, $14, $14, $14, $14, $14
	db $14, $14, $14, $14, $14, $14, $14, $94, $14, $14, $14, $14, $14, $14, $14, $14
	db $14, $14, $14, $14, $14, $14, $14, $94, $14, $94, $14, $14, $14, $14, $14, $14
	db $14, $14, $14, $14, $14, $14, $94, $94, $94, $94, $94, $94, $94, $94, $94, $94
	db $94, $94, $94, $94, $94, $94, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14
	db $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14
	db $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14
	db $14, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16
	db $16, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $16, $16, $16, $16, $16
	db $16, $16, $96, $96, $96, $96, $96, $16, $16, $09, $89, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $89, $89, $89, $09, $09, $09, $09, $09, $09, $89
	db $09, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $9c, $9c, $9c, $9c, $9c, $9c, $9c
	db $9c, $9c, $9c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $9c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
	db $1c, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $9d, $1d, $1d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $9d, $9d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $9d
	db $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $9d, $9d, $1d, $9d, $9d, $9d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $9d, $9d, $9d, $9d, $9d, $9d, $9d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank1CFreeSpace1::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: text/dialogs
;@ Dialog $100: "You've got the Full Moon Cello!"
Dialog100::
	db "You^ve got the  "
	db "Full Moon Cello!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $101: "You've got the Conch Horn!"
Dialog101::
	db "You^ve got the  "
	db "Conch Horn!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $102: "You've got the Sea Lily's Bell!"
Dialog102::
	db "You^ve got the  "
	db "Sea Lily^s Bell!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $103: "You've got the Surf Harp!"
Dialog103::
	db "You^ve got the  "
	db "Surf Harp!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $104: "You've got the Wind Marimba!"
Dialog104::
	db "You^ve got the  "
	db "Wind Marimba!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $105: "You've got the Coral Triangle!"
Dialog105::
	db "You^ve got the  "
	db "Coral Triangle!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $106: "You've got the Organ of Evening Calm!"
Dialog106::
	db "You^ve got the  "
	db "Organ of        "
	db "  Evening Calm!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $107: "You've got the Thunder Drum!"
Dialog107::
	db "You^ve got the  "
	db "Thunder Drum!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $108: "Turn aside the spined ones with a shield..." (B does not hurry it)
Dialog108::
	db "Turn aside the  "
	db "spined ones with"
	db "a shield..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $109: "First, defeat the imprisoned Pols Voice, Last, Stalfos..." (B does not hurry it)
Dialog109::
	db "First, defeat   "
	db "the imprisoned  "
	db "Pols Voice,     "
	db "Last, Stalfos..."
	db $ff  ; end
	db $ff

;@ path: text/dialogs
;@ Dialog $10A: "Far away... Do not fear, dash and fly!" (B does not hurry it)
Dialog10A::
	db "Far away...     "
	db "Do not fear,    "
	db "dash and fly!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10B: "The glint of the tile will be your guide..." (B does not hurry it)
Dialog10B::
	db "The glint of the"
	db "tile will be    "
	db "your guide..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10C: "Dive under where torchlight beams do cross..." (B does not hurry it)
Dialog10C::
	db "Dive under where"
	db "torchlight beams"
	db "do cross..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10D: "Enter the space where the eyes have walls..." (B does not hurry it)
Dialog10D::
	db "Enter the space "
	db "where the eyes  "
	db "have walls..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10E: "The riddle is solved when the pillars fall!" (B does not hurry it)
Dialog10E::
	db "The riddle is   "
	db "solved when the "
	db "pillars fall!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10F: "Fill all the holes with the rock that rolls, this (?) is the key!" (B does not hurry it)
Dialog10F::
	db "Fill all the    "
	db "holes with the  "
	db "rock that rolls,"
	db "this (", $ee, ") is the "
	db "key!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $110: "Something is inscribed on the stone slab, but you can't read it bec..." (B does not hurry it)
Dialog110::
	db "Something is    "
	db "inscribed on the"
	db "stone slab, but "
	db "you can^t read  "
	db "it because a    "
	db "piece is gone."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $111: "'I've got what was inside this box. Come and get it, if you can!' M..." (B does not hurry it)
Dialog111::
	db "^I^ve got what  "
	db "was inside this "
	db "box.  Come and  "
	db "get it, if you  "
	db "can!^  Master ", $dc
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $112: "Gulp! You found me! You're a real pesky kid, you know that?!"
Dialog112::
	db "Gulp!  You found"
	db "me!  You^re a   "
	db "real pesky kid, "
	db "you know that?!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $113: "Arrgh! I can't beat you! I'm outta here!"
Dialog113::
	db "Arrgh!  I can^t "
	db "beat you!  I^m  "
	db "outta here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $114: "You again?! You keep going and going... I can't outlast you! All ri..."
Dialog114::
	db "You again?!  You"
	db "keep going and  "
	db "going... I can^t"
	db "outlast you!    "
	db "All right, let^s"
	db "do it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $115: "WOOF! Dig! RUFF!"
Dialog115::
	db "WOOF! Dig! RUFF!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $116: "You put the missing scale in the mermaid statue!"
Dialog116::
	db "You put the     "
	db "missing scale in"
	db "the mermaid     "
	db "statue!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $117, $118: "Hey, man! When you want to save just push all the Buttons at once! ..."
Dialog117::
	db "Hey, man!  When "
	db "you want to save"
	db "just push all   "
	db "the Buttons at  "
	db "once!  Uhh...   "
	db "Don^t ask me    "
	db "what that means,"
	db "I^m just a kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $119: "Well, it seems that after you save, you will start at the last door..."
Dialog119::
	db "Well, it seems  "
	db "that after you  "
	db "save, you will  "
	db "start at the    "
	db "last door you   "
	db "went through... "
	db "I^m not really  "
	db "sure why that is"
	db "^cause I^m just "
	db "a kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11A: "I heard that you can press SELECT to look at the island map... But,..."
Dialog11A::
	db "I heard that you"
	db "can press SELECT"
	db "to look at the  "
	db "island map...   "
	db "But, I don^t    "
	db "understand what "
	db "they mean by    "
	db "that..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11B: "When you're running out of Hearts, you'd better enter a house or ca..."
Dialog11B::
	db "When you^re     "
	db "running out of  "
	db "Hearts, you^d   "
	db "better enter a  "
	db "house or cave..."
	db "Why?  I have no "
	db "idea, I^m just a"
	db "kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11C: "Hey, dude! What do you think of Marin? Uhh... I don't know, I'm jus..."
Dialog11C::
	db "Hey, dude! What "
	db "do you think of "
	db "Marin?  Uhh...  "
	db "I don^t know,   "
	db "I^m just a kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11D: "Where are you from, brother? ...Outside the island? What is 'outsid..."
Dialog11D::
	db "Where are you   "
	db "from, brother?  "
	db "...Outside the  "
	db "island?  What is"
	db "^outside?^  I^ve"
	db "never thought   "
	db "about it..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11E: "The giant egg on top Tamaranch Mountain? They say the Wind Fish is ..."
Dialog11E::
	db "The giant egg on"
	db "top Tamaranch   "
	db "Mountain?  They "
	db "say the Wind    "
	db "Fish is sleeping"
	db "inside of it... "
	db "Why?  I don^t   "
	db "know either..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11F: "Dude! You're asking me when we started to live on this island? What..."
Dialog11F::
	db "Dude!  You^re   "
	db "asking me when  "
	db "we started to   "
	db "live on this    "
	db "island?  What do"
	db "you mean by     "
	db "^when?^  Whoa!  "
	db "The concept just"
	db "makes my head   "
	db "hurt!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $120: "Marin? She likes to go stare at the ocean all by herself... Why? He..."
Dialog120::
	db "Marin? She likes"
	db "to go stare at  "
	db "the ocean all by"
	db "herself...  Why?"
	db "Hey, I^m just a "
	db "kid, don^t ask  "
	db "me!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $121: "Hey... Where're you two going together? Hunh? Uh, I didn't mean any..."
Dialog121::
	db "Hey... Where^re "
	db "you two going   "
	db "together?  Hunh?"
	db "Uh, I didn^t    "
	db "mean anything..."
	db "I^m just a kid!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $122: "Hey hey, bro! About the Dream Shrine there... They say there's some..."
Dialog122::
	db "Hey hey, bro!   "
	db "About the Dream "
	db "Shrine there... "
	db "They say there^s"
	db "something good  "
	db "inside... ...   "
	db "I better not say"
	db "anything else   "
	db "as I^m just a   "
	db "kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $123: "Hunh?! Marin's not with you? What happened to her?"
Dialog123::
	db "Hunh?!  Marin^s "
	db "not with you?   "
	db "What happened to"
	db "her?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $124, $125, $126, $127: "Tsk tsk... What a shame..."
Dialog124::
	db "Tsk tsk...  What"
	db "a shame..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $128: "Oh thank you! You are indeed a generous person! Ah! I will give you..."
Dialog128::
	db "Oh thank you!   "
	db "You are indeed a"
	db "generous person!"
	db "Ah!  I will give"
	db "you this in     "
	db "return!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $129: "You traded your ? for ?! Maybe you can trade the ribbon for somethi..."
Dialog129::
	db "You traded your "
	db $e0, " for ", $e1, "!  Maybe "
	db "you can trade   "
	db "the ribbon for  "
	db "something else!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $12A: "Because they all look alike, even I am sometimes confused... By the..."
Dialog12A::
	db "Because they all"
	db "look alike, even"
	db "I am sometimes  "
	db "confused...     "
	db "By the way, do  "
	db "you know Yoshi? "
	db "My baby keeps on"
	db "asking for a    "
	db "Yoshi Doll and I"
	db "don^t know what "
	db "to do about it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $12B: "Oh! Will you give that doll to my baby?! Yes No"
Dialog12B::
	db "Oh!  Will you   "
	db "give that doll  "
	db "to my baby?!    "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $12C: "Because they all look alike, even I am sometimes confused..."
Dialog12C::
	db "Because they all"
	db "look alike, even"
	db "I am sometimes  "
	db "confused...     "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $12D: "Ahem! Really, I must insist that you not bring that awful beast in ..."
Dialog12D::
	db "Ahem!  Really, I"
	db "must insist that"
	db "you not bring   "
	db "that awful beast"
	db "in here!  Leave "
	db "that creature   "
	db "outside and then"
	db "we can talk!    "
	db "Good Bye!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $12E, $12F: "Ho ho ho! I really appre- ciate what you did for my poor, precious ..."
Dialog12E::
	db "Ho ho ho!       "
	db "I really appre- "
	db "ciate what you  "
	db "did for my poor,"
	db "precious BowWow!"
	db "You are such a  "
	db "nice boy!  How  "
	db "can I ever repay"
	db "you?  I know... "
	db "  SMOOOOOOOCH!  "
	db "You got a reward"
	db "from Madam Meow-"
	db "Meow... ... ... "
	db "L-l-lucky!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $130: "Ho ho ho! My BowWow is so proud of his fine fur coat!"
Dialog130::
	db "Ho ho ho!  My   "
	db "BowWow is so    "
	db "proud of his    "
	db "fine fur coat!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $131: "AIEEEEEEEE! It's terrrrbile! My BowWow was dognapped by... Mo-mo-MO..."
Dialog131::
	db "AIEEEEEEEE!     "
	db "It^s terrrrbile!"
	db "My BowWow was   "
	db "dognapped by... "
	db "Mo-mo-MOBLINS!! "
	db "OHHH!  AHHHH!   "
	db "Please! Somebody"
	db "help my poor    "
	db "BowWow!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $132: "Oh thank you! I'm so happy you brought my baby back! Now, would you..."
Dialog132::
	db "Oh thank you!   "
	db "I^m so happy you"
	db "brought my baby "
	db "back! Now, would"
	db "you be a dear   "
	db "and take him for"
	db "a walk? It would"
	db "really help me  "
	db "out a lot!  You "
	db "will?!  Thanks!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $133: "Well... I pretty much stick to myself, me and my letters... My name..."
Dialog133::
	db "Well... I pretty"
	db "much stick to   "
	db "myself, me and  "
	db "my letters...   "
	db "My name^s Write!"
	db "The only thing I"
	db "don^t like about"
	db "my hobby is that"
	db "I never receive "
	db "a response..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $134: "What's this?! A letter for me?! I'm so happy! ...And look! The lett..."
Dialog134::
	db "What^s this?!  A"
	db "letter for me?! "
	db "I^m so happy!   "
	db "...And look! The"
	db "letter came with"
	db "a photograph!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $135: "Mmm... She's so beautiful... I must give you something for your tro..."
Dialog135::
	db "Mmm... She^s so "
	db "beautiful...    "
	db "I must give you "
	db "something for   "
	db "your trouble... "
	db "Hmm...  Well, it"
	db "looks like all I"
	db "have is this    "
	db "broom... how^ll "
	db "that be?        "
	db "    Fine No..."
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $136: "You got a Broom as your reward from Mr. Write! But that photo was n..."
Dialog136::
	db "You got a Broom "
	db "as your reward  "
	db "from Mr. Write! "
	db "But that photo  "
	db "was not of..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $137: "Please! I really must insist you have this ?! Okay No Way"
Dialog137::
	db "Please! I really"
	db "must insist you "
	db "have this ", $e8, "!    "
	db "    Okay No Way"
	db $fe  ; end, then a choice of two answers
;@ path: text/dialogs
;@ Dialog $138: "Oh boy! Letter writing is such a great hobby!"
Dialog138::
	db "Oh boy!  Letter "
	db "writing is such "
	db "a great hobby!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $139: "Hello! I'm writing back to Christine now!"
Dialog139::
	db "Hello!  I^m     "
	db "writing back to "
	db "Christine now!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13A: "Salutations! You wouldn't know by the look of me, but I used to liv..."
Dialog13A::
	db "Salutations!    "
	db "You wouldn^t    "
	db "know by the look"
	db "of me, but I    "
	db "used to live in "
	db "the castle! My  "
	db "servants went   "
	db "berserk and I   "
	db "was forced to   "
	db "flee to my      "
	db "villa... So, you"
	db "want the key to "
	db "Ukuku Prairie,  "
	db "do you?  I may  "
	db "be able to help "
	db "you...  Let^s   "
	db "make... a deal, "
	db "shall we? I want"
	db "you to retrieve "
	db "the Golden Leaf "
	db "I left behind in"
	db "the castle when "
	db "I fled...       "
	db "    Okay No Way"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $13B: "Smashing! To tell you the truth, there are five leaves, and I want ..."
Dialog13B::
	db "Smashing!  To   "
	db "tell you the    "
	db "truth, there are"
	db "five leaves, and"
	db "I want them all!"
	db "Oh, you^ll need "
	db "to do some dig- "
	db "ging, so buy a  "
	db "shovel! Are you "
	db "off, then?  Good"
	db "luck!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13C: "Well, I never! I thought you looked cowardly, but... Please, leave ..."
Dialog13C::
	db "Well, I never!  "
	db "I thought you   "
	db "looked cowardly,"
	db "but...  Please, "
	db "leave me... just"
	db "get out here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13D: "Ahh! Tres Bien! I see you have recovered all of the leaves! Now, mo..."
Dialog13D::
	db "Ahh!  Tres Bien!"
	db "I see you have  "
	db "recovered all of"
	db "the leaves! Now,"
	db "move this box   "
	db "and you will    "
	db "find your       "
	db "reward!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13E: "I am forever in your debt for getting my leaves back!"
Dialog13E::
	db "I am forever in "
	db "your debt for   "
	db "getting my      "
	db "leaves back!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13F: "Ah! Bonjour! [NAME], for the love of justice, and my own sake, you ..."
Dialog13F::
	db "Ah!  Bonjour!   "
	db "#####, for the  "
	db "love of justice,"
	db "and my own sake,"
	db "you must find   "
	db "all the leaves!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $140: "Er...Uh...Hmm... How to say... Please call... Outside... ... It see..."
Dialog140::
	db "Er...Uh...Hmm..."
	db "How to say...   "
	db "Please call...  "
	db "Outside...  ... "
	db "It seems that   "
	db "old man Ulrira  "
	db "is a shy guy,   "
	db "in person..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $141: "'BRRING! BRRING! Hello! It's me, Ulrira! Ask me anything about the ..."
Dialog141::
	db "^BRRING! BRRING!"
	db "Hello!  It^s me,"
	db "Ulrira!  Ask me "
	db "anything about  "
	db "the island!  If "
	db "you get lost,   "
	db "give me a call! "
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $142: "'BRRING! BRRING! Hello, this is Ulrira! ...Well, most Moblins live ..."
Dialog142::
	db "^BRRING! BRRING!"
	db "Hello, this is  "
	db "Ulrira! ...Well,"
	db "most Moblins    "
	db "live in the Mys-"
	db "terious Forest, "
	db "but some live in"
	db "the caves of Tal"
	db "Tal Heights...  "
	db "I hope that is  "
	db "what you wanted "
	db "to know! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $143: "'BRRING! BRRING! Yes, this is Ulrira. The Indigestible Flowers of G..."
Dialog143::
	db "^BRRING! BRRING!"
	db "Yes, this is    "
	db "Ulrira.  The    "
	db "Indigestible    "
	db "Flowers of      "
	db "Goponga Swamp..."
	db "Those flowers   "
	db "are BowWow^s    "
	db "favorite.  Why  "
	db "don^t you take  "
	db "him for a walk  "
	db "there?  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $144: "'BRRING! BRRING! Hi, it's Ulrira! ...Have you met everyone on the i..."
Dialog144::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "...Have you met "
	db "everyone on the "
	db "island?  There^s"
	db "a man named     "
	db "Richard who     "
	db "lives in Pothole"
	db "Field, southeast"
	db "of the village. "
	db "Why not pay him "
	db "a visit?  That^s"
	db "all I can tell  "
	db "you for now!    "
	db "Bye!  CLICK!^"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $145: "'BRRING! BRRING! Old man Ulrira here! ...Do you like bananas? Try t..."
Dialog145::
	db "^BRRING! BRRING!"
	db "Old man Ulrira  "
	db "here! ...Do you "
	db "like bananas?   "
	db "Try talking to  "
	db "people in the   "
	db "village again!  "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $146: "'BRRING! BRRING! Ulrira speaking! You know, there is a library in t..."
Dialog146::
	db "^BRRING! BRRING!"
	db "Ulrira speaking!"
	db "You know, there "
	db "is a library in "
	db "the village that"
	db "might have some "
	db "good information"
	db "for you!  Talk  "
	db "to you later!   "
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $147: "'BRRING! BRRING! Yeah, it's me, Ulrira! Hmmm... You can't find all ..."
Dialog147::
	db "^BRRING! BRRING!"
	db "Yeah, it^s me,  "
	db "Ulrira!  Hmmm..."
	db "You can^t find  "
	db "all the leaves  "
	db "you say?  That^s"
	db "a stumper!  Ahh,"
	db "check out the   "
	db "raven by the    "
	db "castle!  In any "
	db "case, try many  "
	db "things!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $148: "'BRRING! BRRING! Ulrira here! ... Shovel... Did you purchase a shov..."
Dialog148::
	db "^BRRING! BRRING!"
	db "Ulrira here! ..."
	db "Shovel...  Did  "
	db "you purchase a  "
	db "shovel?  You may"
	db "find something  "
	db "if you dig here "
	db "and there!  Bye!"
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $149: "'BRRING! BRRING! Ya, it's Ulrira! The cave in the Ukuku Prairie is ..."
Dialog149::
	db "^BRRING! BRRING!"
	db "Ya, it^s Ulrira!"
	db "The cave in the "
	db "Ukuku Prairie is"
	db "the key!  Yes, I"
	db "mean the key    "
	db "cave, no pun    "
	db "intended!  Bye! "
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14A: "'BRRING! BRRING! Hi, this is Ulrira! In the Yarna Desert, which is ..."
Dialog14A::
	db "^BRRING! BRRING!"
	db "Hi, this is     "
	db "Ulrira!  In the "
	db "Yarna Desert,   "
	db "which is located"
	db "in the southeast"
	db "of the island,  "
	db "you will find   "
	db "something called"
	db "the Angler Key. "
	db "Hmmm... How much"
	db "more obvious do "
	db "I have to be?   "
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14B: "'BRRING! BRRING! This is Ulrira! Now you're being haunted by a ghos..."
Dialog14B::
	db "^BRRING! BRRING!"
	db "This is Ulrira! "
	db "Now you^re being"
	db "haunted by a    "
	db "ghost?! Well,   "
	db "how about taking"
	db "him where he    "
	db "wants to go?    "
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14C: "'BRRING! BRRING! Hi, it's Ulrira! The Catfish's mouth is wide open?..."
Dialog14C::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "The Catfish^s   "
	db "mouth is wide   "
	db "open?  It sounds"
	db "like a great    "
	db "place to dive!  "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14D: "'BRRING! BRRING! Ulrira here! ... Have you been to the Face Shrine?..."
Dialog14D::
	db "^BRRING! BRRING!"
	db "Ulrira here! ..."
	db "Have you been to"
	db "the Face Shrine?"
	db "It is north of  "
	db "Animal Village. "
	db "That is a very  "
	db "interesting     "
	db "ruin... CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14E: "'BRRING! BRRING! Hi, it's Ulrira! Have you heard of the Flying Roos..."
Dialog14E::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "Have you heard  "
	db "of the Flying   "
	db "Rooster of Mabe "
	db "Village?  In the"
	db "good old days,  "
	db "it used to give "
	db "us rides if we  "
	db "held it above   "
	db "our heads... Now"
	db "it is lying     "
	db "under the       "
	db "Weathercock...  "
	db "Is that useful  "
	db "for you?  I hope"
	db "so! Bye! CLICK!^"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $14F: "'BRRING! BRRING! Hi, it's Ulrira! The head of the turtle is in your..."
Dialog14F::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "The head of the "
	db "turtle is in    "
	db "your way?  Put  "
	db "life into it and"
	db "it will move!   "
	db "It^s true! True!"
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $150: "...SWAMP... A path opens... in the blooms..."
Dialog150::
	db "   ...SWAMP...  "
	db " A path opens..."
	db "in the blooms..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $151: "...PRAIRIE... ...PRAIRIE... The Prairie is waiting..."
Dialog151::
	db "  ...PRAIRIE... "
	db "  ...PRAIRIE... "
	db " The Prairie is "
	db "     waiting..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $152: "...WATERFALL... It is hidden in the waterfall..."
Dialog152::
	db "...WATERFALL... "
	db "It is hidden in "
	db "the waterfall..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $153: "...BAY... Your road goes into the bay..."
Dialog153::
	db "    ...BAY...   "
	db "Your road goes  "
	db "into the bay... "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $154: "...SHRINE... An island secret in the shrine..."
Dialog154::
	db "   ...SHRINE... "
	db "An island secret"
	db "in the shrine..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $155: "...MOUNTAIN... Something calls ...from the mountains..."
Dialog155::
	db " ...MOUNTAIN... "
	db "Something calls "
	db "  ...from the   "
	db "  mountains..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $156: "...OCARINA... The music of the Ocarina leads..."
Dialog156::
	db "  ...OCARINA... "
	db "The music of the"
	db "Ocarina leads..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $157: "...EGG.... The Egg on the mountain calls!"
Dialog157::
	db "    ...EGG....  "
	db "The Egg on the  "
	db "mountain calls!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $158, $159: "Then YOU sweep the island!"
Dialog158::
	db "Then YOU sweep  "
	db "the island!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15A: "YAHOO! I'm fine, and you?!"
Dialog15A::
	db "YAHOO!   I^m    "
	db "fine, and you?!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15B: "YAHOO! I worked too hard and now my broom is worn to the handle!"
Dialog15B::
	db "YAHOO!  I worked"
	db "too hard and now"
	db "my broom is worn"
	db "to the handle!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15C: "YAHOO! YAHOO! A new broom?! For me? It is, isn't it?! Yes No"
Dialog15C::
	db "YAHOO!  YAHOO!  "
	db "A new broom?!   "
	db "For me?  It is, "
	db "isn^t it?!      "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $15D: "Okay! In return you can have this fishing hook I found when I swept..."
Dialog15D::
	db "Okay!  In return"
	db "you can have    "
	db "this fishing    "
	db "hook I found    "
	db "when I swept by "
	db "the river bank!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15E: "You exchanged ? for the fishing hook ?! What will the fishing hook ..."
Dialog15E::
	db "You exchanged ", $e8, " "
	db "for the fishing "
	db "hook ", $e9, "!  What   "
	db "will the fishing"
	db "hook become?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15F: "YAHOO! A new broom! Superb!"
Dialog15F::
	db "YAHOO!  A new   "
	db "broom!  Superb!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $160: "Kiiiki! What?! All right, mutt! Let's battle!!"
Dialog160::
	db "Kiiiki!  What?! "
	db "All right, mutt!"
	db "Let^s battle!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $161: "Chi-kiita! Chi- kiita! Kiki the monkey! Hungry! Kiki the monkey!"
Dialog161::
	db "Chi-kiita! Chi- "
	db "kiita!  Kiki the"
	db "monkey!  Hungry!"
	db "Kiki the monkey!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $162: "?! ?! Oooh! Ooh! Kiki! Monkees! Come! Repay him! Kiki!"
Dialog162::
	db "    ", $e3, "!    ", $e3, "!    "
	db "Oooh! Ooh! Kiki!"
	db "Monkees!  Come! "
	db "Repay him! Kiki!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $163: "Monkey business! Done! Bye bye! Oooh! Kiki!"
Dialog163::
	db "Monkey business!"
	db "Done!  Bye bye! "
	db "Oooh!  Kiki!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $164: "You found a stick a monkey left behind... You take it!"
Dialog164::
	db "You found a     "
	db "stick a monkey  "
	db "left behind...  "
	db "You take it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $165: "?! ?! Oooh! Oooh! Give to Kiki!? Yes No!"
Dialog165::
	db "    ", $e3, "!    ", $e3, "!    "
	db "  Oooh!  Oooh!  "
	db " Give to Kiki!? "
	db "    Yes  No!"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $166: "You don't know the proper etiquette when dealing with a lady, do yo..."
Dialog166::
	db "You don^t know  "
	db "the proper      "
	db "etiquette when  "
	db "dealing with a  "
	db "lady, do you?   "
	db "You should have "
	db "brought flowers "
	db "or something,   "
	db "then I might be "
	db "more inclined to"
	db "talk with you..."
	db "Oh yes, in my   "
	db "case, hibiscus  "
	db "are best..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $167: "Oh, you brought me a hibiscus! How sweet! Well, since you are such ..." (B does not hurry it)
Dialog167::
	db "Oh, you brought "
	db "me a hibiscus!  "
	db "How sweet! Well,"
	db "since you are   "
	db "such a gentleman"
	db "I have a request"
	db "to make of you. "
	db "Will you listen?"
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $168: "I would like you to take this letter to a Mr. Write who lives on th..."
Dialog168::
	db "I would like you"
	db "to take this    "
	db "letter to a Mr. "
	db "Write who lives "
	db "on the border of"
	db "the Mysterious  "
	db "Forest, please!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $169: "...Is that so? And I thought you were a gentleman..."
Dialog169::
	db "...Is that so?  "
	db "And I thought   "
	db "you were a      "
	db "gentleman..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $16A: "You traded ? for a goat's letter ?! ...Great!?"
Dialog16A::
	db "You traded ", $e7, " for"
	db "a goat^s letter "
	db $ed, "!  ...Great!?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $16B: "You know, some- times I can't help eating a delicious piece of pape..."
Dialog16B::
	db "You know, some- "
	db "times I can^t   "
	db "help eating a   "
	db "delicious piece "
	db "of paper, even  "
	db "if it^s a letter"
	db "to my darling   "
	db "Mr. Write... How"
	db "embarrassing!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $16C: "You've saved BowWow! What a fearsome beast!"
Dialog16C::
	db "You^ve saved    "
	db "BowWow!  What a "
	db "fearsome beast!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $16D: "Wow! The Rooster has recovered! He seems very friendly!"
Dialog16D::
	db "Wow! The Rooster"
	db "has recovered!  "
	db "He seems very   "
	db "friendly!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $170: "Yep, Papahl got lost, just like he said! Now, I am so famished I ca..."
Dialog170::
	db "Yep, Papahl got "
	db "lost, just like "
	db "he said!  Now, I"
	db "am so famished I"
	db "can^t move!  Can"
	db "you give me some"
	db "vittles?        "
	db "    Yes  Nope"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $171: "You're one cold hombre..."
Dialog171::
	db "You^re one cold "
	db "hombre..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $172: "This ? is so delicious! I'm going to eat the ? right now! Bon Appet..."
Dialog172::
	db "This ", $e6, " is so    "
	db "delicious!  I^m "
	db "going to eat the"
	db $e6, " right now!    "
	db " Bon Appetit!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $173: "AH! This isn't meant to be a reward... Here, take this ?! It's a hi..."
Dialog173::
	db "AH!  This isn^t "
	db "meant to be a   "
	db "reward...  Here,"
	db "take this ", $e7, "!    "
	db "It^s a hibiscus!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $174: "You traded the ? for the ?!"
Dialog174::
	db "You traded the ", $e6
	db "for the ", $e7, "!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $175: "Delicious! Yum! I'm filled with energy, now!"
Dialog175::
	db "Delicious!  Yum!"
	db "I^m filled with "
	db "energy, now!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $176: "I've got to say, thanks again!"
Dialog176::
	db "I^ve got to say,"
	db "thanks again!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $177: "Yep, Papahl got lost, just like he said! Now, I am so famished I ca..."
Dialog177::
	db "Yep, Papahl got "
	db "lost, just like "
	db "he said!  Now, I"
	db "am so famished I"
	db "can^t move!  Can"
	db "you give me some"
	db "vittles?        "
	db "    Nope Can^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $178: "She's had an awful tradgedy in the house across the way! It's just ..."
Dialog178::
	db "She^s had an    "
	db "awful tradgedy  "
	db "in the house    "
	db "across the way! "
	db "It^s just awful,"
	db "and all I can do"
	db "is sweep!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialogs $179, $17A, $17B, $17C, $17D, $17E, $17F: ""
Dialog179::
	db $ff  ; end
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
