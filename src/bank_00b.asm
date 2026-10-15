; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $00b", ROMX[$4000], BANK[$b]

;@ path: world/indoor/rooms
;@ The data address of each of the 256 rooms of indoor group B, one word per room: the rooms of the maps $06-$19 (the later dungeons and the houses and caves of those maps). The format is that of IndoorARoomPointers.
IndoorBRoomPointers::
	dw IndoorBRoom00, IndoorBRoom00, IndoorBRoom02, IndoorBRoom03  ; room $00-$03
	dw IndoorBRoom04, IndoorBRoom05, IndoorBRoom06, IndoorBRoom07  ; room $04-$07
	dw IndoorBRoom08, IndoorBRoom09, IndoorBRoom0A, IndoorBRoom0B  ; room $08-$0B
	dw IndoorBRoom0C, IndoorBRoom0D, IndoorBRoom0E, IndoorBRoom0F  ; room $0C-$0F
	dw IndoorBRoom10, IndoorBRoom11, IndoorBRoom12, IndoorBRoom13  ; room $10-$13
	dw IndoorBRoom14, IndoorBRoom15, IndoorBRoom16, IndoorBRoom17  ; room $14-$17
	dw IndoorBRoom18, IndoorBRoom19, IndoorBRoom1A, IndoorBRoom1B  ; room $18-$1B
	dw IndoorBRoom1C, IndoorBRoom1D, IndoorBRoom1E, IndoorBRoom1F  ; room $1C-$1F
	dw IndoorBRoom20, IndoorBRoom21, IndoorBRoom22, IndoorBRoom23  ; room $20-$23
	dw IndoorBRoom24, IndoorBRoom25, IndoorBRoom26, IndoorBRoom27  ; room $24-$27
	dw IndoorBRoom28, IndoorBRoom29, IndoorBRoom2A, IndoorBRoom2B  ; room $28-$2B
	dw IndoorBRoom2C, IndoorBRoom2D, IndoorBRoom2E, IndoorBRoom2F  ; room $2C-$2F
	dw IndoorBRoom30, IndoorBRoom31, IndoorBRoom32, IndoorBRoom33  ; room $30-$33
	dw IndoorBRoom33, IndoorBRoom35, IndoorBRoom36, IndoorBRoom36  ; room $34-$37
	dw IndoorBRoom38, IndoorBRoom39, IndoorBRoom3A, IndoorBRoom3B  ; room $38-$3B
	dw IndoorBRoom3C, IndoorBRoom3D, IndoorBRoom3E, IndoorBRoom3F  ; room $3C-$3F
	dw IndoorBRoom40, IndoorBRoom41, IndoorBRoom42, IndoorBRoom43  ; room $40-$43
	dw IndoorBRoom44, IndoorBRoom45, IndoorBRoom46, IndoorBRoom47  ; room $44-$47
	dw IndoorBRoom48, IndoorBRoom49, IndoorBRoom4A, IndoorBRoom4B  ; room $48-$4B
	dw IndoorBRoom4C, IndoorBRoom4D, IndoorBRoom4E, IndoorBRoom4F  ; room $4C-$4F
	dw IndoorBRoom50, IndoorBRoom51, IndoorBRoom52, IndoorBRoom53  ; room $50-$53
	dw IndoorBRoom54, IndoorBRoom55, IndoorBRoom56, IndoorBRoom57  ; room $54-$57
	dw IndoorBRoom58, IndoorBRoom59, IndoorBRoom5A, IndoorBRoom5B  ; room $58-$5B
	dw IndoorBRoom5C, IndoorBRoom5D, IndoorBRoom5E, IndoorBRoom5F  ; room $5C-$5F
	dw IndoorBRoom60, IndoorBRoom61, IndoorBRoom62, IndoorBRoom63  ; room $60-$63
	dw IndoorBRoom64, IndoorBRoom65, IndoorBRoom66, IndoorBRoom67  ; room $64-$67
	dw IndoorBRoom68, IndoorBRoom69, IndoorBRoom6A, IndoorBRoom6B  ; room $68-$6B
	dw IndoorBRoom6C, IndoorBRoom6C, IndoorBRoom6C, IndoorBRoom6C  ; room $6C-$6F
	dw IndoorBRoom70, IndoorBRoom71, IndoorBRoom72, IndoorBRoom73  ; room $70-$73
	dw IndoorBRoom74, IndoorBRoom75, IndoorBRoom70, IndoorBRoom77  ; room $74-$77
	dw IndoorBRoom77, IndoorBRoom77, IndoorBRoom77, IndoorBRoom7B  ; room $78-$7B
	dw IndoorBRoom7C, IndoorBRoom7D, IndoorBRoom7E, IndoorBRoom7F  ; room $7C-$7F
	dw IndoorBRoom80, IndoorBRoom81, IndoorBRoom82, IndoorBRoom83  ; room $80-$83
	dw IndoorBRoom84, IndoorBRoom85, IndoorBRoom86, IndoorBRoom87  ; room $84-$87
	dw IndoorBRoom88, IndoorBRoom89, IndoorBRoom8A, IndoorBRoom8B  ; room $88-$8B
	dw IndoorBRoom8C, IndoorBRoom8D, IndoorBRoom8E, IndoorBRoom8F  ; room $8C-$8F
	dw IndoorBRoom90, IndoorBRoom91, IndoorBRoom92, IndoorBRoom93  ; room $90-$93
	dw IndoorBRoom94, IndoorBRoom95, IndoorBRoom96, IndoorBRoom97  ; room $94-$97
	dw IndoorBRoom98, IndoorBRoom99, IndoorBRoom9A, IndoorBRoom9B  ; room $98-$9B
	dw IndoorBRoom9C, IndoorBRoom9D, IndoorBRoom9E, IndoorBRoom9E  ; room $9C-$9F
	dw IndoorBRoomA0, IndoorBRoomA1, IndoorBRoomA2, IndoorBRoomA3  ; room $A0-$A3
	dw IndoorBRoomA4, IndoorBRoomA5, IndoorBRoomA6, IndoorBRoomA7  ; room $A4-$A7
	dw IndoorBRoomA8, IndoorBRoomA9, IndoorBRoomAA, IndoorBRoomAB  ; room $A8-$AB
	dw IndoorBRoomAC, IndoorBRoomAD, IndoorBRoomAE, IndoorBRoomAF  ; room $AC-$AF
	dw IndoorBRoomB0, IndoorBRoomB1, IndoorBRoomB2, IndoorBRoomB3  ; room $B0-$B3
	dw IndoorBRoomB4, IndoorBRoomB5, IndoorBRoomB6, IndoorBRoomB7  ; room $B4-$B7
	dw IndoorBRoomB8, IndoorBRoomB9, IndoorBRoomBA, IndoorBRoomBB  ; room $B8-$BB
	dw IndoorBRoomBC, IndoorBRoomBD, IndoorBRoomBE, IndoorBRoomBF  ; room $BC-$BF
	dw IndoorBRoomC0, IndoorBRoomC1, IndoorBRoomC2, IndoorBRoomC3  ; room $C0-$C3
	dw IndoorBRoomC4, IndoorBRoomC5, IndoorBRoomC6, IndoorBRoomC7  ; room $C4-$C7
	dw IndoorBRoomC8, IndoorBRoomC9, IndoorBRoomCA, IndoorBRoomCB  ; room $C8-$CB
	dw IndoorBRoomCC, IndoorBRoomCD, IndoorBRoomCE, IndoorBRoomCF  ; room $CC-$CF
	dw IndoorBRoomD0, IndoorBRoomD1, IndoorBRoomD2, IndoorBRoomD3  ; room $D0-$D3
	dw IndoorBRoomD4, IndoorBRoomD5, IndoorBRoomD6, IndoorBRoomD7  ; room $D4-$D7
	dw IndoorBRoomD8, IndoorBRoomD9, IndoorBRoomDA, IndoorBRoomDB  ; room $D8-$DB
	dw IndoorBRoomDC, IndoorBRoomDD, IndoorBRoomDE, IndoorBRoomDF  ; room $DC-$DF
	dw IndoorBRoomE0, IndoorBRoomE1, IndoorBRoomE2, IndoorBRoomE3  ; room $E0-$E3
	dw IndoorBRoomE4, IndoorBRoomE5, IndoorBRoomE6, IndoorBRoomE7  ; room $E4-$E7
	dw IndoorBRoomE8, IndoorBRoomE9, IndoorBRoomEA, IndoorBRoomEB  ; room $E8-$EB
	dw IndoorBRoomEC, IndoorBRoomED, IndoorBRoomEE, IndoorBRoomEF  ; room $EC-$EF
	dw IndoorBRoomF0, IndoorBRoomF1, IndoorBRoomF2, IndoorBRoomF3  ; room $F0-$F3
	dw IndoorBRoomF4, IndoorBRoomF5, IndoorBRoomF6, IndoorBRoomF7  ; room $F4-$F7
	dw IndoorBRoomF8, IndoorBRoomF9, IndoorBRoomFA, IndoorBRoomFB  ; room $F8-$FB
	dw IndoorBRoomFC, IndoorBRoomFD, IndoorBRoomFE, IndoorBRoomFF  ; room $FC-$FF
;@ path: world/indoor/rooms
;@ Room $00 of indoor group B: 16 objects, room template 8 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom00::
	db $04, $8d  ; animated tiles $04, template 8, floor $0D
	db $19, $f7  ; (9, 1): object $F7
	db $75, $f5  ; (5, 7): object $F5
	db $89, $11, $0f  ; 9 across from (1, 1): object $0F
	db $c6, $21, $0f  ; 6 down from (1, 2): object $0F
	db $22, $25  ; (2, 2): object $25
	db $87, $23, $21  ; 7 across from (3, 2): object $21
	db $c5, $32, $23  ; 5 down from (2, 3): object $23
	db $86, $44, $db  ; 6 across from (4, 4): object $DB
	db $c3, $54, $db  ; 3 down from (4, 5): object $DB
	db $24, $c7  ; (4, 2): object $C7
	db $27, $c7  ; (7, 2): object $C7
	db $42, $c9  ; (2, 4): object $C9
	db $75, $0d  ; (5, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $83, $77, $22  ; 3 across from (7, 7): object $22
	db $11, $a0  ; (1, 1): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $02 of indoor group B: 17 objects, room template 4 and floor object $0D; a warp (type 1) to map $06 room $11 at x 88, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom02::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $10, $f6  ; (0, 1): object $F6
	db $19, $f7  ; (9, 1): object $F7
	db $72, $f5  ; (2, 7): object $F5
	db $09, $21  ; (9, 0): object $21
	db $8a, $10, $0f  ; 10 across from (0, 1): object $0F
	db $89, $20, $21  ; 9 across from (0, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $c5, $32, $dc  ; 5 down from (2, 3): object $DC
	db $82, $40, $db  ; 2 across from (0, 4): object $DB
	db $71, $2b  ; (1, 7): object $2B
	db $73, $2c  ; (3, 7): object $2C
	db $76, $2b  ; (6, 7): object $2B
	db $77, $dc  ; (7, 7): object $DC
	db $78, $2c  ; (8, 7): object $2C
	db $23, $c7  ; (3, 2): object $C7
	db $27, $c7  ; (7, 2): object $C7
	db $25, $a3  ; (5, 2): object $A3
	db $e1, $06, $11, $58, $30  ; warp type 1 to map $06 room $11, x 88 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $03 of indoor group B: 9 objects, room template 2 and floor object $0D; a warp (type 1) to map $06 room $12 at x 72, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom03::
	db $04, $2d  ; animated tiles $04, template 2, floor $0D
	db $10, $f6  ; (0, 1): object $F6
	db $19, $f7  ; (9, 1): object $F7
	db $00, $21  ; (0, 0): object $21
	db $8a, $10, $0f  ; 10 across from (0, 1): object $0F
	db $20, $25  ; (0, 2): object $25
	db $89, $21, $21  ; 9 across from (1, 2): object $21
	db $22, $c7  ; (2, 2): object $C7
	db $26, $c7  ; (6, 2): object $C7
	db $24, $a3  ; (4, 2): object $A3
	db $e1, $06, $12, $48, $30  ; warp type 1 to map $06 room $12, x 72 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $04 of indoor group B: 14 objects, room template 7 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom04::
	db $04, $7d  ; animated tiles $04, template 7, floor $0D
	db $10, $f6  ; (0, 1): object $F6
	db $74, $f5  ; (4, 7): object $F5
	db $89, $10, $0f  ; 9 across from (0, 1): object $0F
	db $c6, $28, $0f  ; 6 down from (8, 2): object $0F
	db $87, $20, $21  ; 7 across from (0, 2): object $21
	db $27, $26  ; (7, 2): object $26
	db $c5, $37, $24  ; 5 down from (7, 3): object $24
	db $70, $2b  ; (0, 7): object $2B
	db $73, $2c  ; (3, 7): object $2C
	db $74, $22  ; (4, 7): object $22
	db $75, $2b  ; (5, 7): object $2B
	db $22, $c7  ; (2, 2): object $C7
	db $25, $c7  ; (5, 2): object $C7
	db $18, $a0  ; (8, 1): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $05 of indoor group B: 26 objects, room template 9 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom05::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $29, $f7  ; (9, 2): object $F7
	db $71, $f5  ; (1, 7): object $F5
	db $c8, $00, $23  ; 8 down from (0, 0): object $23
	db $c8, $01, $0f  ; 8 down from (1, 0): object $0F
	db $c8, $02, $23  ; 8 down from (2, 0): object $23
	db $06, $2a  ; (6, 0): object $2A
	db $82, $07, $21  ; 2 across from (7, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $18, $ac  ; (8, 1): object $AC
	db $19, $2a  ; (9, 1): object $2A
	db $27, $0d  ; (7, 2): object $0D
	db $39, $2c  ; (9, 3): object $2C
	db $49, $2a  ; (9, 4): object $2A
	db $68, $ac  ; (8, 6): object $AC
	db $69, $2c  ; (9, 6): object $2C
	db $79, $24  ; (9, 7): object $24
	db $22, $c9  ; (2, 2): object $C9
	db $52, $c9  ; (2, 5): object $C9
	db $c8, $04, $db  ; 8 down from (4, 0): object $DB
	db $c6, $16, $dc  ; 6 down from (6, 1): object $DC
	db $85, $25, $db  ; 5 across from (5, 2): object $DB
	db $76, $2c  ; (6, 7): object $2C
	db $82, $77, $22  ; 2 across from (7, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $59, $dc  ; (9, 5): object $DC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $06 of indoor group B: 35 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom06::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $72, $f5  ; (2, 7): object $F5
	db $88, $11, $b0  ; 8 across from (1, 1): object $B0
	db $88, $31, $af  ; 8 across from (1, 3): object $AF
	db $88, $41, $b0  ; 8 across from (1, 4): object $B0
	db $86, $61, $af  ; 6 across from (1, 6): object $AF
	db $01, $29  ; (1, 0): object $29
	db $c2, $02, $dc  ; 2 down from (2, 0): object $DC
	db $03, $2a  ; (3, 0): object $2A
	db $82, $04, $c7  ; 2 across from (4, 0): object $C7
	db $06, $29  ; (6, 0): object $29
	db $c5, $07, $dc  ; 5 down from (7, 0): object $DC
	db $08, $2a  ; (8, 0): object $2A
	db $10, $29  ; (0, 1): object $29
	db $19, $2a  ; (9, 1): object $2A
	db $8a, $20, $db  ; 10 across from (0, 2): object $DB
	db $30, $2b  ; (0, 3): object $2B
	db $c2, $32, $db  ; 2 down from (2, 3): object $DB
	db $39, $2c  ; (9, 3): object $2C
	db $40, $29  ; (0, 4): object $29
	db $49, $2a  ; (9, 4): object $2A
	db $8a, $50, $dc  ; 10 across from (0, 5): object $DC
	db $60, $2b  ; (0, 6): object $2B
	db $c2, $62, $db  ; 2 down from (2, 6): object $DB
	db $c2, $67, $db  ; 2 down from (7, 6): object $DB
	db $68, $2c  ; (8, 6): object $2C
	db $69, $22  ; (9, 6): object $22
	db $71, $2b  ; (1, 7): object $2B
	db $73, $2c  ; (3, 7): object $2C
	db $82, $74, $c8  ; 2 across from (4, 7): object $C8
	db $76, $2b  ; (6, 7): object $2B
	db $78, $24  ; (8, 7): object $24
	db $79, $0f  ; (9, 7): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $07 of indoor group B: 24 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom07::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $10, $f6  ; (0, 1): object $F6
	db $19, $f7  ; (9, 1): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $10, $29  ; (0, 1): object $29
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $19, $2a  ; (9, 1): object $2A
	db $85, $20, $db  ; 5 across from (0, 2): object $DB
	db $29, $0d  ; (9, 2): object $0D
	db $30, $2b  ; (0, 3): object $2B
	db $8a, $50, $dc  ; 10 across from (0, 5): object $DC
	db $c5, $34, $db  ; 5 down from (4, 3): object $DB
	db $39, $2c  ; (9, 3): object $2C
	db $40, $29  ; (0, 4): object $29
	db $49, $2a  ; (9, 4): object $2A
	db $83, $60, $22  ; 3 across from (0, 6): object $22
	db $63, $2b  ; (3, 6): object $2B
	db $c2, $65, $dc  ; 2 down from (5, 6): object $DC
	db $68, $ac  ; (8, 6): object $AC
	db $69, $2c  ; (9, 6): object $2C
	db $83, $70, $0f  ; 3 across from (0, 7): object $0F
	db $73, $23  ; (3, 7): object $23
	db $76, $2c  ; (6, 7): object $2C
	db $82, $66, $dc  ; 2 across from (6, 6): object $DC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $08 of indoor group B: 24 objects, room template 1 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom08::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $77, $f5  ; (7, 7): object $F5
	db $03, $24  ; (3, 0): object $24
	db $04, $ac  ; (4, 0): object $AC
	db $05, $23  ; (5, 0): object $23
	db $c7, $07, $24  ; 7 down from (7, 0): object $24
	db $c8, $08, $0f  ; 8 down from (8, 0): object $0F
	db $10, $29  ; (0, 1): object $29
	db $13, $2a  ; (3, 1): object $2A
	db $14, $21  ; (4, 1): object $21
	db $15, $29  ; (5, 1): object $29
	db $20, $0d  ; (0, 2): object $0D
	db $30, $2b  ; (0, 3): object $2B
	db $40, $29  ; (0, 4): object $29
	db $50, $dc  ; (0, 5): object $DC
	db $60, $2b  ; (0, 6): object $2B
	db $27, $ca  ; (7, 2): object $CA
	db $57, $ca  ; (7, 5): object $CA
	db $77, $28  ; (7, 7): object $28
	db $79, $24  ; (9, 7): object $24
	db $83, $43, $d4  ; 3 across from (3, 4): object $D4
	db $83, $53, $d4  ; 3 across from (3, 5): object $D4
	db $83, $63, $d4  ; 3 across from (3, 6): object $D4
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $09 of indoor group B: 22 objects, room template 9 and floor object $0D; a warp (type 1) to map $06 room $17 at x 120, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom09::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $71, $f5  ; (1, 7): object $F5
	db $c8, $00, $23  ; 8 down from (0, 0): object $23
	db $c8, $01, $0f  ; 8 down from (1, 0): object $0F
	db $c8, $02, $23  ; 8 down from (2, 0): object $23
	db $c8, $09, $24  ; 8 down from (9, 0): object $24
	db $29, $f3  ; (9, 2): object $F3
	db $86, $53, $dc  ; 6 across from (3, 5): object $DC
	db $22, $c9  ; (2, 2): object $C9
	db $52, $c9  ; (2, 5): object $C9
	db $06, $2a  ; (6, 0): object $2A
	db $82, $07, $21  ; 2 across from (7, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $c4, $04, $db  ; 4 down from (4, 0): object $DB
	db $35, $db  ; (5, 3): object $DB
	db $c2, $26, $db  ; 2 down from (6, 2): object $DB
	db $83, $16, $dc  ; 3 across from (6, 1): object $DC
	db $25, $a0  ; (5, 2): object $A0
	db $07, $a3  ; (7, 0): object $A3
	db $e1, $06, $17, $78, $10  ; warp type 1 to map $06 room $17, x 120 y 16
	db $29, $2a  ; (9, 2): object $2A
	db $39, $0d  ; (9, 3): object $0D
	db $49, $2c  ; (9, 4): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0A of indoor group B: 32 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom0A::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $01, $29  ; (1, 0): object $29
	db $02, $db  ; (2, 0): object $DB
	db $03, $2a  ; (3, 0): object $2A
	db $06, $29  ; (6, 0): object $29
	db $c3, $07, $db  ; 3 down from (7, 0): object $DB
	db $c2, $08, $24  ; 2 down from (8, 0): object $24
	db $c2, $09, $0f  ; 2 down from (9, 0): object $0F
	db $11, $25  ; (1, 1): object $25
	db $12, $21  ; (2, 1): object $21
	db $13, $26  ; (3, 1): object $26
	db $c2, $21, $23  ; 2 down from (1, 2): object $23
	db $c2, $22, $01  ; 2 down from (2, 2): object $01
	db $c2, $23, $24  ; 2 down from (3, 2): object $24
	db $83, $37, $db  ; 3 across from (7, 3): object $DB
	db $28, $2a  ; (8, 2): object $2A
	db $29, $21  ; (9, 2): object $21
	db $41, $27  ; (1, 4): object $27
	db $42, $22  ; (2, 4): object $22
	db $43, $28  ; (3, 4): object $28
	db $49, $dc  ; (9, 4): object $DC
	db $59, $2c  ; (9, 5): object $2C
	db $61, $ac  ; (1, 6): object $AC
	db $36, $20  ; (6, 3): object $20
	db $62, $20  ; (2, 6): object $20
	db $67, $20  ; (7, 6): object $20
	db $68, $ac  ; (8, 6): object $AC
	db $20, $29  ; (0, 2): object $29
	db $30, $0d  ; (0, 3): object $0D
	db $40, $2b  ; (0, 4): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0B of indoor group B: 53 objects, room template 9 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom0B::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $72, $f5  ; (2, 7): object $F5
	db $83, $00, $0f  ; 3 across from (0, 0): object $0F
	db $03, $23  ; (3, 0): object $23
	db $04, $db  ; (4, 0): object $DB
	db $05, $dc  ; (5, 0): object $DC
	db $06, $2a  ; (6, 0): object $2A
	db $07, $c7  ; (7, 0): object $C7
	db $08, $26  ; (8, 0): object $26
	db $c2, $09, $03  ; 2 down from (9, 0): object $03
	db $10, $0f  ; (0, 1): object $0F
	db $11, $25  ; (1, 1): object $25
	db $12, $98  ; (2, 1): object $98
	db $13, $29  ; (3, 1): object $29
	db $84, $14, $dc  ; 4 across from (4, 1): object $DC
	db $08, $26  ; (8, 0): object $26
	db $18, $24  ; (8, 1): object $24
	db $20, $21  ; (0, 2): object $21
	db $21, $29  ; (1, 2): object $29
	db $22, $db  ; (2, 2): object $DB
	db $84, $23, $ac  ; 4 across from (3, 2): object $AC
	db $27, $dc  ; (7, 2): object $DC
	db $28, $2a  ; (8, 2): object $2A
	db $29, $21  ; (9, 2): object $21
	db $83, $30, $db  ; 3 across from (0, 3): object $DB
	db $c2, $33, $ac  ; 2 down from (3, 3): object $AC
	db $82, $34, $0f  ; 2 across from (4, 3): object $0F
	db $c2, $36, $ac  ; 2 down from (6, 3): object $AC
	db $83, $37, $dc  ; 3 across from (7, 3): object $DC
	db $83, $40, $dc  ; 3 across from (0, 4): object $DC
	db $82, $44, $0f  ; 2 across from (4, 4): object $0F
	db $83, $47, $db  ; 3 across from (7, 4): object $DB
	db $50, $22  ; (0, 5): object $22
	db $51, $2b  ; (1, 5): object $2B
	db $52, $dc  ; (2, 5): object $DC
	db $84, $53, $ac  ; 4 across from (3, 5): object $AC
	db $57, $db  ; (7, 5): object $DB
	db $58, $2c  ; (8, 5): object $2C
	db $59, $22  ; (9, 5): object $22
	db $c2, $60, $03  ; 2 down from (0, 6): object $03
	db $61, $23  ; (1, 6): object $23
	db $83, $62, $dc  ; 3 across from (2, 6): object $DC
	db $83, $65, $db  ; 3 across from (5, 6): object $DB
	db $68, $24  ; (8, 6): object $24
	db $c2, $69, $03  ; 2 down from (9, 6): object $03
	db $71, $27  ; (1, 7): object $27
	db $72, $c8  ; (2, 7): object $C8
	db $73, $2b  ; (3, 7): object $2B
	db $76, $2c  ; (6, 7): object $2C
	db $77, $c8  ; (7, 7): object $C8
	db $78, $28  ; (8, 7): object $28
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0C of indoor group B: 21 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $1A at x 104, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom0C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $05, $a3  ; (5, 0): object $A3
	db $07, $f4  ; (7, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $75, $ed  ; (5, 7): object $ED
	db $07, $26  ; (7, 0): object $26
	db $c8, $08, $0f  ; 8 down from (8, 0): object $0F
	db $09, $24  ; (9, 0): object $24
	db $c6, $14, $a6  ; 6 down from (4, 1): object $A6
	db $c6, $17, $24  ; 6 down from (7, 1): object $24
	db $20, $29  ; (0, 2): object $29
	db $30, $dc  ; (0, 3): object $DC
	db $82, $31, $0f  ; 2 across from (1, 3): object $0F
	db $40, $db  ; (0, 4): object $DB
	db $82, $41, $0f  ; 2 across from (1, 4): object $0F
	db $50, $2b  ; (0, 5): object $2B
	db $c3, $52, $0f  ; 3 down from (2, 5): object $0F
	db $71, $2b  ; (1, 7): object $2B
	db $73, $0d  ; (3, 7): object $0D
	db $74, $2c  ; (4, 7): object $2C
	db $77, $28  ; (7, 7): object $28
	db $79, $24  ; (9, 7): object $24
	db $e1, $06, $1a, $68, $30  ; warp type 1 to map $06 room $1A, x 104 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0D of indoor group B: 19 objects, room template 5 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom0D::
	db $04, $5d  ; animated tiles $04, template 5, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $59, $f7  ; (9, 5): object $F7
	db $c6, $01, $0f  ; 6 down from (1, 0): object $0F
	db $c5, $02, $23  ; 5 down from (2, 0): object $23
	db $09, $24  ; (9, 0): object $24
	db $86, $13, $0f  ; 6 across from (3, 1): object $0F
	db $86, $23, $0f  ; 6 across from (3, 2): object $0F
	db $87, $33, $0f  ; 7 across from (3, 3): object $0F
	db $86, $43, $0f  ; 6 across from (3, 4): object $0F
	db $25, $20  ; (5, 2): object $20
	db $26, $20  ; (6, 2): object $20
	db $35, $20  ; (5, 3): object $20
	db $36, $20  ; (6, 3): object $20
	db $19, $2a  ; (9, 1): object $2A
	db $52, $27  ; (2, 5): object $27
	db $87, $53, $22  ; 7 across from (3, 5): object $22
	db $88, $61, $0f  ; 8 across from (1, 6): object $0F
	db $69, $ac  ; (9, 6): object $AC
	db $79, $2b  ; (9, 7): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0E of indoor group B: 18 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $0E at x 88, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom0E::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $10, $29  ; (0, 1): object $29
	db $19, $2a  ; (9, 1): object $2A
	db $c3, $20, $0d  ; 3 down from (0, 2): object $0D
	db $c3, $29, $0d  ; 3 down from (9, 2): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $59, $2c  ; (9, 5): object $2C
	db $c2, $42, $c0  ; 2 down from (2, 4): object $C0
	db $c2, $47, $c0  ; 2 down from (7, 4): object $C0
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $8a, $30, $0f  ; 10 across from (0, 3): object $0F
	db $84, $43, $0f  ; 4 across from (3, 4): object $0F
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $0e, $58, $30  ; warp type 0 to map $00 room $0E, x 88 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0F of indoor group B: 23 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom0F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $c3, $20, $0d  ; 3 down from (0, 2): object $0D
	db $c3, $29, $0d  ; 3 down from (9, 2): object $0D
	db $79, $22  ; (9, 7): object $22
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $10, $29  ; (0, 1): object $29
	db $19, $2a  ; (9, 1): object $2A
	db $8a, $30, $0f  ; 10 across from (0, 3): object $0F
	db $8a, $50, $22  ; 10 across from (0, 5): object $22
	db $8a, $60, $0f  ; 10 across from (0, 6): object $0F
	db $60, $ac  ; (0, 6): object $AC
	db $70, $2c  ; (0, 7): object $2C
	db $41, $a6  ; (1, 4): object $A6
	db $48, $a6  ; (8, 4): object $A6
	db $68, $a6  ; (8, 6): object $A6
	db $84, $23, $d4  ; 4 across from (3, 2): object $D4
	db $33, $d4  ; (3, 3): object $D4
	db $36, $d4  ; (6, 3): object $D4
	db $84, $43, $d4  ; 4 across from (3, 4): object $D4
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $10 of indoor group B: 16 objects, room template 6 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom10::
	db $04, $6d  ; animated tiles $04, template 6, floor $0D
	db $05, $ec  ; (5, 0): object $EC
	db $50, $f6  ; (0, 5): object $F6
	db $00, $ac  ; (0, 0): object $AC
	db $01, $23  ; (1, 0): object $23
	db $c3, $02, $0f  ; 3 down from (2, 0): object $0F
	db $03, $0d  ; (3, 0): object $0D
	db $04, $2a  ; (4, 0): object $2A
	db $07, $26  ; (7, 0): object $26
	db $c6, $08, $0f  ; 6 down from (8, 0): object $0F
	db $10, $21  ; (0, 1): object $21
	db $11, $29  ; (1, 1): object $29
	db $c4, $17, $24  ; 4 down from (7, 1): object $24
	db $83, $30, $0f  ; 3 across from (0, 3): object $0F
	db $87, $50, $22  ; 7 across from (0, 5): object $22
	db $57, $28  ; (7, 5): object $28
	db $89, $60, $0f  ; 9 across from (0, 6): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $11 of indoor group B: 20 objects, room template 0 and floor object $07; a warp (type 1) to map $06 room $02 at x 88, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom11::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $72, $f5  ; (2, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $03, $26  ; (3, 0): object $26
	db $82, $04, $8b  ; 2 across from (4, 0): object $8B
	db $06, $25  ; (6, 0): object $25
	db $07, $c7  ; (7, 0): object $C7
	db $13, $24  ; (3, 1): object $24
	db $82, $14, $8b  ; 2 across from (4, 1): object $8B
	db $16, $23  ; (6, 1): object $23
	db $23, $2a  ; (3, 2): object $2A
	db $82, $24, $21  ; 2 across from (4, 2): object $21
	db $26, $29  ; (6, 2): object $29
	db $28, $a1  ; (8, 2): object $A1
	db $25, $a2  ; (5, 2): object $A2
	db $72, $2b  ; (2, 7): object $2B
	db $73, $07  ; (3, 7): object $07
	db $74, $2c  ; (4, 7): object $2C
	db $77, $2b  ; (7, 7): object $2B
	db $78, $07  ; (8, 7): object $07
	db $79, $24  ; (9, 7): object $24
	db $e1, $06, $02, $58, $30  ; warp type 1 to map $06 room $02, x 88 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $12 of indoor group B: 18 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $03 at x 72, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom12::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $71, $f5  ; (1, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $03, $26  ; (3, 0): object $26
	db $82, $04, $8b  ; 2 across from (4, 0): object $8B
	db $06, $25  ; (6, 0): object $25
	db $07, $c7  ; (7, 0): object $C7
	db $13, $24  ; (3, 1): object $24
	db $82, $14, $8b  ; 2 across from (4, 1): object $8B
	db $16, $23  ; (6, 1): object $23
	db $23, $2a  ; (3, 2): object $2A
	db $82, $24, $21  ; 2 across from (4, 2): object $21
	db $26, $29  ; (6, 2): object $29
	db $28, $a1  ; (8, 2): object $A1
	db $24, $a2  ; (4, 2): object $A2
	db $70, $23  ; (0, 7): object $23
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $73, $2c  ; (3, 7): object $2C
	db $34, $dc  ; (4, 3): object $DC
	db $e1, $06, $03, $48, $30  ; warp type 1 to map $06 room $03, x 72 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $13 of indoor group B: 11 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $05 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom13::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $49, $f3  ; (9, 4): object $F3
	db $74, $fb  ; (4, 7): object $FB
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $82, $14, $da  ; 2 across from (4, 1): object $DA
	db $c3, $21, $da  ; 3 down from (1, 2): object $DA
	db $c3, $28, $da  ; 3 down from (8, 2): object $DA
	db $82, $34, $da  ; 2 across from (4, 3): object $DA
	db $82, $44, $da  ; 2 across from (4, 4): object $DA
	db $c2, $53, $da  ; 2 down from (3, 5): object $DA
	db $c2, $56, $da  ; 2 down from (6, 5): object $DA
	db $e1, $06, $05, $00, $00  ; warp type 1 to map $06 room $05, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $14 of indoor group B: 26 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $06 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom14::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $40, $f6  ; (0, 4): object $F6
	db $59, $f7  ; (9, 5): object $F7
	db $72, $48  ; (2, 7): object $48
	db $02, $29  ; (2, 0): object $29
	db $03, $0d  ; (3, 0): object $0D
	db $04, $2a  ; (4, 0): object $2A
	db $07, $29  ; (7, 0): object $29
	db $08, $0d  ; (8, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $11, $ac  ; (1, 1): object $AC
	db $c2, $14, $11  ; 2 down from (4, 1): object $11
	db $c5, $17, $a6  ; 5 down from (7, 1): object $A6
	db $83, $21, $13  ; 3 across from (1, 2): object $13
	db $32, $1e  ; (2, 3): object $1E
	db $42, $1f  ; (2, 4): object $1F
	db $59, $2a  ; (9, 5): object $2A
	db $66, $a7  ; (6, 6): object $A7
	db $67, $1d  ; (7, 6): object $1D
	db $69, $0d  ; (9, 6): object $0D
	db $79, $22  ; (9, 7): object $22
	db $c2, $16, $d4  ; 2 down from (6, 1): object $D4
	db $28, $d4  ; (8, 2): object $D4
	db $34, $d4  ; (4, 3): object $D4
	db $71, $c8  ; (1, 7): object $C8
	db $73, $c8  ; (3, 7): object $C8
	db $e1, $06, $06, $00, $00  ; warp type 1 to map $06 room $06, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $15 of indoor group B: 30 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $07 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom15::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $39, $f7  ; (9, 3): object $F7
	db $50, $f6  ; (0, 5): object $F6
	db $71, $f5  ; (1, 7): object $F5
	db $04, $c7  ; (4, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $00, $23  ; (0, 0): object $23
	db $82, $01, $0d  ; 2 across from (1, 0): object $0D
	db $03, $2a  ; (3, 0): object $2A
	db $38, $13  ; (8, 3): object $13
	db $47, $1e  ; (7, 4): object $1E
	db $50, $29  ; (0, 5): object $29
	db $85, $51, $dc  ; 5 across from (1, 5): object $DC
	db $57, $1c  ; (7, 5): object $1C
	db $60, $0d  ; (0, 6): object $0D
	db $61, $a7  ; (1, 6): object $A7
	db $83, $64, $1d  ; 3 across from (4, 6): object $1D
	db $67, $1f  ; (7, 6): object $1F
	db $70, $2b  ; (0, 7): object $2B
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $73, $2c  ; (3, 7): object $2C
	db $76, $2b  ; (6, 7): object $2B
	db $82, $77, $0d  ; 2 across from (7, 7): object $0D
	db $79, $24  ; (9, 7): object $24
	db $82, $12, $d4  ; 2 across from (2, 1): object $D4
	db $82, $15, $d4  ; 2 across from (5, 1): object $D4
	db $23, $d4  ; (3, 2): object $D4
	db $25, $d4  ; (5, 2): object $D4
	db $c3, $38, $11  ; 3 down from (8, 3): object $11
	db $68, $15  ; (8, 6): object $15
	db $e1, $06, $07, $00, $00  ; warp type 1 to map $06 room $07, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $16 of indoor group B: 28 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom16::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $77, $f5  ; (7, 7): object $F5
	db $c2, $31, $0f  ; 2 down from (1, 3): object $0F
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $77, $2b  ; (7, 7): object $2B
	db $79, $24  ; (9, 7): object $24
	db $78, $db  ; (8, 7): object $DB
	db $02, $26  ; (2, 0): object $26
	db $07, $25  ; (7, 0): object $25
	db $03, $ac  ; (3, 0): object $AC
	db $82, $04, $c7  ; 2 across from (4, 0): object $C7
	db $06, $ac  ; (6, 0): object $AC
	db $12, $2a  ; (2, 1): object $2A
	db $13, $26  ; (3, 1): object $26
	db $82, $14, $0f  ; 2 across from (4, 1): object $0F
	db $82, $24, $0f  ; 2 across from (4, 2): object $0F
	db $16, $25  ; (6, 1): object $25
	db $17, $29  ; (7, 1): object $29
	db $23, $24  ; (3, 2): object $24
	db $33, $2a  ; (3, 3): object $2A
	db $82, $34, $97  ; 2 across from (4, 3): object $97
	db $26, $23  ; (6, 2): object $23
	db $36, $29  ; (6, 3): object $29
	db $43, $ac  ; (3, 4): object $AC
	db $46, $ac  ; (6, 4): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $17 of indoor group B: 15 objects, room template 2 and floor object $0D; a warp (type 1) to map $06 room $09 at x 120, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom17::
	db $04, $2d  ; animated tiles $04, template 2, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $04, $fa  ; (4, 0): object $FA
	db $07, $a2  ; (7, 0): object $A2
	db $39, $f7  ; (9, 3): object $F7
	db $75, $f5  ; (5, 7): object $F5
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $34, $2c  ; (4, 3): object $2C
	db $35, $2b  ; (5, 3): object $2B
	db $44, $2a  ; (4, 4): object $2A
	db $45, $29  ; (5, 4): object $29
	db $75, $2b  ; (5, 7): object $2B
	db $76, $0d  ; (6, 7): object $0D
	db $77, $2c  ; (7, 7): object $2C
	db $e1, $06, $09, $78, $10  ; warp type 1 to map $06 room $09, x 120 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $18 of indoor group B: 19 objects, room template 4 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom18::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $10, $f6  ; (0, 1): object $F6
	db $75, $ed  ; (5, 7): object $ED
	db $02, $3f  ; (2, 0): object $3F
	db $72, $40  ; (2, 7): object $40
	db $01, $c7  ; (1, 0): object $C7
	db $03, $c7  ; (3, 0): object $C7
	db $71, $c8  ; (1, 7): object $C8
	db $73, $c8  ; (3, 7): object $C8
	db $c6, $10, $0d  ; 6 down from (0, 1): object $0D
	db $c6, $11, $a7  ; 6 down from (1, 1): object $A7
	db $c6, $13, $a6  ; 6 down from (3, 1): object $A6
	db $18, $20  ; (8, 1): object $20
	db $68, $20  ; (8, 6): object $20
	db $74, $2b  ; (4, 7): object $2B
	db $82, $75, $0d  ; 2 across from (5, 7): object $0D
	db $77, $2c  ; (7, 7): object $2C
	db $84, $14, $d4  ; 4 across from (4, 1): object $D4
	db $27, $d4  ; (7, 2): object $D4
	db $82, $37, $d4  ; 2 across from (7, 3): object $D4
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $19 of indoor group B: 24 objects, room template 1 and floor object $0D; a warp (type 1) to map $06 room $0B at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom19::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $73, $f5  ; (3, 7): object $F5
	db $72, $c8  ; (2, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $03, $2a  ; (3, 0): object $2A
	db $82, $04, $21  ; 2 across from (4, 0): object $21
	db $06, $29  ; (6, 0): object $29
	db $c3, $13, $dc  ; 3 down from (3, 1): object $DC
	db $83, $14, $1d  ; 3 across from (4, 1): object $1D
	db $26, $dc  ; (6, 2): object $DC
	db $27, $1d  ; (7, 2): object $1D
	db $82, $31, $1d  ; 2 across from (1, 3): object $1D
	db $28, $2c  ; (8, 2): object $2C
	db $29, $28  ; (9, 2): object $28
	db $c4, $38, $24  ; 4 down from (8, 3): object $24
	db $c5, $39, $0f  ; 5 down from (9, 3): object $0F
	db $73, $2b  ; (3, 7): object $2B
	db $74, $0d  ; (4, 7): object $0D
	db $75, $2c  ; (5, 7): object $2C
	db $78, $28  ; (8, 7): object $28
	db $21, $d4  ; (1, 2): object $D4
	db $c2, $41, $d4  ; 2 down from (1, 4): object $D4
	db $57, $d4  ; (7, 5): object $D4
	db $83, $65, $d4  ; 3 across from (5, 6): object $D4
	db $e1, $06, $0b, $00, $00  ; warp type 1 to map $06 room $0B, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1A of indoor group B: 37 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $0C at x 88, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom1A::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $75, $f5  ; (5, 7): object $F5
	db $00, $2c  ; (0, 0): object $2C
	db $01, $2b  ; (1, 0): object $2B
	db $02, $25  ; (2, 0): object $25
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $07, $29  ; (7, 0): object $29
	db $08, $0d  ; (8, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $10, $24  ; (0, 1): object $24
	db $11, $23  ; (1, 1): object $23
	db $c6, $12, $23  ; 6 down from (2, 1): object $23
	db $82, $13, $dc  ; 2 across from (3, 1): object $DC
	db $82, $23, $dc  ; 2 across from (3, 2): object $DC
	db $82, $33, $dc  ; 2 across from (3, 3): object $DC
	db $84, $43, $dc  ; 4 across from (3, 4): object $DC
	db $86, $53, $dc  ; 6 across from (3, 5): object $DC
	db $84, $63, $dc  ; 4 across from (3, 6): object $DC
	db $20, $2a  ; (0, 2): object $2A
	db $21, $29  ; (1, 2): object $29
	db $c5, $30, $0f  ; 5 down from (0, 3): object $0F
	db $c5, $31, $0f  ; 5 down from (1, 3): object $0F
	db $71, $c0  ; (1, 7): object $C0
	db $72, $27  ; (2, 7): object $27
	db $75, $2b  ; (5, 7): object $2B
	db $76, $dc  ; (6, 7): object $DC
	db $77, $2c  ; (7, 7): object $2C
	db $83, $15, $0f  ; 3 across from (5, 1): object $0F
	db $83, $25, $0f  ; 3 across from (5, 2): object $0F
	db $83, $35, $0f  ; 3 across from (5, 3): object $0F
	db $26, $be  ; (6, 2): object $BE
	db $23, $a0  ; (3, 2): object $A0
	db $58, $1d  ; (8, 5): object $1D
	db $82, $47, $a6  ; 2 across from (7, 4): object $A6
	db $e1, $06, $0c, $58, $10  ; warp type 1 to map $06 room $0C, x 88 y 16
	db $08, $db  ; (8, 0): object $DB
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1B of indoor group B: 19 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $0D at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom1B::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $05, $f4  ; (5, 0): object $F4
	db $39, $f7  ; (9, 3): object $F7
	db $05, $29  ; (5, 0): object $29
	db $06, $0d  ; (6, 0): object $0D
	db $07, $2a  ; (7, 0): object $2A
	db $11, $ac  ; (1, 1): object $AC
	db $14, $1d  ; (4, 1): object $1D
	db $18, $ac  ; (8, 1): object $AC
	db $21, $1d  ; (1, 2): object $1D
	db $27, $1d  ; (7, 2): object $1D
	db $39, $2a  ; (9, 3): object $2A
	db $49, $0d  ; (9, 4): object $0D
	db $41, $1d  ; (1, 4): object $1D
	db $47, $1d  ; (7, 4): object $1D
	db $59, $2c  ; (9, 5): object $2C
	db $61, $ac  ; (1, 6): object $AC
	db $64, $1d  ; (4, 6): object $1D
	db $68, $ac  ; (8, 6): object $AC
	db $32, $0f  ; (2, 3): object $0F
	db $e1, $06, $0d, $00, $00  ; warp type 1 to map $06 room $0D, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1C of indoor group B: 24 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $0E at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom1C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $47  ; (2, 0): object $47
	db $30, $f6  ; (0, 3): object $F6
	db $49, $f7  ; (9, 4): object $F7
	db $82, $13, $a6  ; 2 across from (3, 1): object $A6
	db $82, $27, $0f  ; 2 across from (7, 2): object $0F
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $84, $23, $1d  ; 4 across from (3, 2): object $1D
	db $30, $29  ; (0, 3): object $29
	db $82, $31, $a7  ; 2 across from (1, 3): object $A7
	db $84, $33, $a6  ; 4 across from (3, 3): object $A6
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $40, $0d  ; (0, 4): object $0D
	db $46, $a6  ; (6, 4): object $A6
	db $82, $47, $a7  ; 2 across from (7, 4): object $A7
	db $49, $2a  ; (9, 4): object $2A
	db $50, $2b  ; (0, 5): object $2B
	db $59, $0d  ; (9, 5): object $0D
	db $69, $2c  ; (9, 6): object $2C
	db $04, $29  ; (4, 0): object $29
	db $82, $05, $0d  ; 2 across from (5, 0): object $0D
	db $07, $2a  ; (7, 0): object $2A
	db $82, $15, $13  ; 2 across from (5, 1): object $13
	db $35, $12  ; (5, 3): object $12
	db $28, $a1  ; (8, 2): object $A1
	db $e1, $06, $0e, $00, $00  ; warp type 1 to map $06 room $0E, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1D of indoor group B: 26 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $2A at x 136, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom1D::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $50, $f6  ; (0, 5): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $03, $29  ; (3, 0): object $29
	db $04, $0d  ; (4, 0): object $0D
	db $05, $2a  ; (5, 0): object $2A
	db $08, $26  ; (8, 0): object $26
	db $c2, $09, $0f  ; 2 down from (9, 0): object $0F
	db $11, $ac  ; (1, 1): object $AC
	db $c3, $12, $10  ; 3 down from (2, 1): object $10
	db $83, $13, $0f  ; 3 across from (3, 1): object $0F
	db $c3, $16, $11  ; 3 down from (6, 1): object $11
	db $07, $a3  ; (7, 0): object $A3
	db $e1, $06, $2a, $88, $20  ; warp type 1 to map $06 room $2A, x 136 y 32
	db $18, $24  ; (8, 1): object $24
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $28, $2a  ; (8, 2): object $2A
	db $29, $21  ; (9, 2): object $21
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $c2, $39, $db  ; 2 down from (9, 3): object $DB
	db $40, $29  ; (0, 4): object $29
	db $42, $94  ; (2, 4): object $94
	db $83, $43, $12  ; 3 across from (3, 4): object $12
	db $46, $93  ; (6, 4): object $93
	db $50, $0d  ; (0, 5): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $60, $2b  ; (0, 6): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1E of indoor group B: 24 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom1E::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $05, $f4  ; (5, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $82, $00, $0f  ; 2 across from (0, 0): object $0F
	db $02, $25  ; (2, 0): object $25
	db $04, $c7  ; (4, 0): object $C7
	db $05, $29  ; (5, 0): object $29
	db $06, $dc  ; (6, 0): object $DC
	db $07, $2a  ; (7, 0): object $2A
	db $08, $c7  ; (8, 0): object $C7
	db $82, $10, $0f  ; 2 across from (0, 1): object $0F
	db $12, $23  ; (2, 1): object $23
	db $82, $20, $21  ; 2 across from (0, 2): object $21
	db $21, $98  ; (1, 2): object $98
	db $22, $29  ; (2, 2): object $29
	db $24, $20  ; (4, 2): object $20
	db $27, $20  ; (7, 2): object $20
	db $c2, $30, $db  ; 2 down from (0, 3): object $DB
	db $31, $de  ; (1, 3): object $DE
	db $44, $20  ; (4, 4): object $20
	db $47, $20  ; (7, 4): object $20
	db $50, $2b  ; (0, 5): object $2B
	db $64, $20  ; (4, 6): object $20
	db $67, $20  ; (7, 6): object $20
	db $01, $c0  ; (1, 0): object $C0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1F of indoor group B: 20 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom1F::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $29, $cf  ; (9, 2): object $CF
	db $29, $f3  ; (9, 2): object $F3
	db $74, $f5  ; (4, 7): object $F5
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $60, $27  ; (0, 6): object $27
	db $88, $61, $22  ; 8 across from (1, 6): object $22
	db $63, $2b  ; (3, 6): object $2B
	db $82, $64, $0d  ; 2 across from (4, 6): object $0D
	db $66, $2c  ; (6, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $2c  ; (0, 7): object $2C
	db $71, $22  ; (1, 7): object $22
	db $72, $2b  ; (2, 7): object $2B
	db $73, $23  ; (3, 7): object $23
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $24  ; (6, 7): object $24
	db $77, $2c  ; (7, 7): object $2C
	db $78, $22  ; (8, 7): object $22
	db $79, $2b  ; (9, 7): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $20 of indoor group B: 16 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom20::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $20, $f6  ; (0, 2): object $F6
	db $85, $12, $d2  ; 5 across from (2, 1): object $D2
	db $c4, $17, $cf  ; 4 down from (7, 1): object $CF
	db $85, $53, $d1  ; 5 across from (3, 5): object $D1
	db $c4, $22, $d0  ; 4 down from (2, 2): object $D0
	db $62, $2c  ; (2, 6): object $2C
	db $84, $63, $22  ; 4 across from (3, 6): object $22
	db $67, $2b  ; (7, 6): object $2B
	db $72, $28  ; (2, 7): object $28
	db $73, $2c  ; (3, 7): object $2C
	db $82, $74, $22  ; 2 across from (4, 7): object $22
	db $76, $2b  ; (6, 7): object $2B
	db $77, $27  ; (7, 7): object $27
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $21 of indoor group B: 16 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom21::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $29, $f7  ; (9, 2): object $F7
	db $76, $f5  ; (6, 7): object $F5
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $11, $20  ; (1, 1): object $20
	db $18, $20  ; (8, 1): object $20
	db $61, $20  ; (1, 6): object $20
	db $68, $20  ; (8, 6): object $20
	db $29, $2a  ; (9, 2): object $2A
	db $85, $35, $dc  ; 5 across from (5, 3): object $DC
	db $49, $2c  ; (9, 4): object $2C
	db $c3, $44, $dc  ; 3 down from (4, 4): object $DC
	db $72, $2b  ; (2, 7): object $2B
	db $73, $0d  ; (3, 7): object $0D
	db $74, $2c  ; (4, 7): object $2C
	db $63, $de  ; (3, 6): object $DE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $22 of indoor group B: 34 objects, room template 8 and floor object $0D; a warp (type 1) to map $06 room $14 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom22::
	db $04, $8d  ; animated tiles $04, template 8, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $89, $11, $1c  ; 9 across from (1, 1): object $1C
	db $89, $21, $1c  ; 9 across from (1, 2): object $1C
	db $89, $31, $1c  ; 9 across from (1, 3): object $1C
	db $89, $41, $1c  ; 9 across from (1, 4): object $1C
	db $89, $51, $1c  ; 9 across from (1, 5): object $1C
	db $89, $61, $1c  ; 9 across from (1, 6): object $1C
	db $89, $71, $1c  ; 9 across from (1, 7): object $1C
	db $00, $2a  ; (0, 0): object $2A
	db $01, $c7  ; (1, 0): object $C7
	db $02, $29  ; (2, 0): object $29
	db $03, $23  ; (3, 0): object $23
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $24  ; (6, 0): object $24
	db $07, $2a  ; (7, 0): object $2A
	db $08, $c7  ; (8, 0): object $C7
	db $09, $29  ; (9, 0): object $29
	db $03, $23  ; (3, 0): object $23
	db $10, $03  ; (0, 1): object $03
	db $11, $25  ; (1, 1): object $25
	db $12, $21  ; (2, 1): object $21
	db $13, $29  ; (3, 1): object $29
	db $20, $21  ; (0, 2): object $21
	db $21, $29  ; (1, 2): object $29
	db $82, $30, $dc  ; 2 across from (0, 3): object $DC
	db $40, $2b  ; (0, 4): object $2B
	db $c3, $16, $11  ; 3 down from (6, 1): object $11
	db $86, $41, $1e  ; 6 across from (1, 4): object $1E
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $84, $22, $0d  ; 4 across from (2, 2): object $0D
	db $84, $32, $0d  ; 4 across from (2, 3): object $0D
	db $16, $2a  ; (6, 1): object $2A
	db $83, $17, $21  ; 3 across from (7, 1): object $21
	db $e1, $06, $14, $00, $00  ; warp type 1 to map $06 room $14, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $23 of indoor group B: 1 objects, room template 7 and floor object $0D; a warp (type 1) to map $06 room $2B at x 24, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom23::
	db $04, $7d  ; animated tiles $04, template 7, floor $0D
	db $34, $be  ; (4, 3): object $BE
	db $e1, $06, $2b, $18, $10  ; warp type 1 to map $06 room $2B, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $24 of indoor group B: 12 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom24::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $77, $f5  ; (7, 7): object $F5
	db $82, $11, $0f  ; 2 across from (1, 1): object $0F
	db $82, $21, $0f  ; 2 across from (1, 2): object $0F
	db $82, $31, $0f  ; 2 across from (1, 3): object $0F
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $33, $a7  ; (3, 3): object $A7
	db $36, $a7  ; (6, 3): object $A7
	db $53, $ac  ; (3, 5): object $AC
	db $56, $ac  ; (6, 5): object $AC
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $25 of indoor group B: 18 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom25::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $06, $f0  ; (6, 0): object $F0
	db $29, $f7  ; (9, 2): object $F7
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $23  ; (2, 0): object $23
	db $03, $0d  ; (3, 0): object $0D
	db $04, $2a  ; (4, 0): object $2A
	db $10, $25  ; (0, 1): object $25
	db $11, $21  ; (1, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $18, $ac  ; (8, 1): object $AC
	db $21, $ac  ; (1, 2): object $AC
	db $29, $2a  ; (9, 2): object $2A
	db $39, $db  ; (9, 3): object $DB
	db $49, $2c  ; (9, 4): object $2C
	db $22, $d4  ; (2, 2): object $D4
	db $c2, $31, $d4  ; 2 down from (1, 3): object $D4
	db $c2, $48, $d4  ; 2 down from (8, 4): object $D4
	db $82, $67, $d4  ; 2 across from (7, 6): object $D4
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $26 of indoor group B: 27 objects, room template 9 and floor object $0D; a warp (type 1) to map $06 room $18 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom26::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $20, $f6  ; (0, 2): object $F6
	db $75, $f5  ; (5, 7): object $F5
	db $c8, $00, $23  ; 8 down from (0, 0): object $23
	db $20, $29  ; (0, 2): object $29
	db $40, $2b  ; (0, 4): object $2B
	db $88, $72, $22  ; 8 across from (2, 7): object $22
	db $72, $2c  ; (2, 7): object $2C
	db $75, $2b  ; (5, 7): object $2B
	db $77, $2c  ; (7, 7): object $2C
	db $82, $01, $1c  ; 2 across from (1, 0): object $1C
	db $87, $03, $1c  ; 7 across from (3, 0): object $1C
	db $89, $11, $1f  ; 9 across from (1, 1): object $1F
	db $c6, $18, $1c  ; 6 down from (8, 1): object $1C
	db $c6, $19, $1c  ; 6 down from (9, 1): object $1C
	db $83, $21, $13  ; 3 across from (1, 2): object $13
	db $84, $24, $13  ; 4 across from (4, 2): object $13
	db $c4, $37, $11  ; 4 down from (7, 3): object $11
	db $87, $30, $db  ; 7 across from (0, 3): object $DB
	db $42, $17  ; (2, 4): object $17
	db $82, $43, $12  ; 2 across from (3, 4): object $12
	db $45, $16  ; (5, 4): object $16
	db $c2, $52, $11  ; 2 down from (2, 5): object $11
	db $c2, $55, $10  ; 2 down from (5, 5): object $10
	db $82, $53, $1e  ; 2 across from (3, 5): object $1E
	db $82, $63, $1c  ; 2 across from (3, 6): object $1C
	db $c4, $46, $dc  ; 4 down from (6, 4): object $DC
	db $27, $95  ; (7, 2): object $95
	db $e1, $06, $18, $00, $00  ; warp type 1 to map $06 room $18, x 0 y 0
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $27 of indoor group B: 18 objects, room template 6 and floor object $0D; a warp (type 1) to map $06 room $19 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom27::
	db $04, $6d  ; animated tiles $04, template 6, floor $0D
	db $29, $f7  ; (9, 2): object $F7
	db $72, $f5  ; (2, 7): object $F5
	db $89, $00, $1c  ; 9 across from (0, 0): object $1C
	db $c6, $10, $1c  ; 6 down from (0, 1): object $1C
	db $c6, $11, $1c  ; 6 down from (1, 1): object $1C
	db $87, $12, $1f  ; 7 across from (2, 1): object $1F
	db $c5, $22, $10  ; 5 down from (2, 2): object $10
	db $86, $23, $12  ; 6 across from (3, 2): object $12
	db $34, $13  ; (4, 3): object $13
	db $38, $13  ; (8, 3): object $13
	db $44, $11  ; (4, 4): object $11
	db $84, $45, $1e  ; 4 across from (5, 4): object $1E
	db $54, $1e  ; (4, 5): object $1E
	db $84, $55, $1c  ; 4 across from (5, 5): object $1C
	db $85, $64, $1c  ; 5 across from (4, 6): object $1C
	db $72, $2b  ; (2, 7): object $2B
	db $73, $0d  ; (3, 7): object $0D
	db $74, $2c  ; (4, 7): object $2C
	db $e1, $06, $19, $00, $00  ; warp type 1 to map $06 room $19, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $28 of indoor group B: 13 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom28::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f0  ; (7, 0): object $F0
	db $20, $f2  ; (0, 2): object $F2
	db $03, $26  ; (3, 0): object $26
	db $82, $04, $0f  ; 2 across from (4, 0): object $0F
	db $06, $25  ; (6, 0): object $25
	db $13, $24  ; (3, 1): object $24
	db $82, $14, $0f  ; 2 across from (4, 1): object $0F
	db $16, $23  ; (6, 1): object $23
	db $23, $2a  ; (3, 2): object $2A
	db $82, $24, $21  ; 2 across from (4, 2): object $21
	db $26, $29  ; (6, 2): object $29
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $29 of indoor group B: 15 objects, room template 1 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom29::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $49, $f3  ; (9, 4): object $F3
	db $01, $0d  ; (1, 0): object $0D
	db $02, $2a  ; (2, 0): object $2A
	db $82, $03, $21  ; 2 across from (3, 0): object $21
	db $05, $29  ; (5, 0): object $29
	db $c3, $06, $dc  ; 3 down from (6, 0): object $DC
	db $c3, $07, $24  ; 3 down from (7, 0): object $24
	db $08, $12  ; (8, 0): object $12
	db $09, $16  ; (9, 0): object $16
	db $11, $a7  ; (1, 1): object $A7
	db $c2, $19, $10  ; 2 down from (9, 1): object $10
	db $37, $2a  ; (7, 3): object $2A
	db $38, $98  ; (8, 3): object $98
	db $39, $26  ; (9, 3): object $26
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2A of indoor group B: 11 objects, room template 0 and floor object $0D; a warp (type 1) to map $06 room $1D at x 120, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom2A::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $40, $f2  ; (0, 4): object $F2
	db $02, $29  ; (2, 0): object $29
	db $03, $0d  ; (3, 0): object $0D
	db $04, $2a  ; (4, 0): object $2A
	db $06, $c7  ; (6, 0): object $C7
	db $18, $be  ; (8, 1): object $BE
	db $08, $c7  ; (8, 0): object $C7
	db $49, $ca  ; (9, 4): object $CA
	db $16, $db  ; (6, 1): object $DB
	db $83, $26, $db  ; 3 across from (6, 2): object $DB
	db $e1, $06, $1d, $78, $10  ; warp type 1 to map $06 room $1D, x 120 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2B of indoor group B: 34 objects, room template 9 and floor object $0D; a warp (type 1) to map $06 room $14 at x 0, y 0. Format: see IndoorBRoomPointers.
IndoorBRoom2B::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $71, $f5  ; (1, 7): object $F5
	db $00, $2a  ; (0, 0): object $2A
	db $01, $c7  ; (1, 0): object $C7
	db $02, $29  ; (2, 0): object $29
	db $c2, $03, $23  ; 2 down from (3, 0): object $23
	db $c3, $06, $24  ; 3 down from (6, 0): object $24
	db $07, $2a  ; (7, 0): object $2A
	db $08, $c7  ; (8, 0): object $C7
	db $09, $29  ; (9, 0): object $29
	db $10, $a6  ; (0, 1): object $A6
	db $18, $a6  ; (8, 1): object $A6
	db $19, $16  ; (9, 1): object $16
	db $83, $20, $21  ; 3 across from (0, 2): object $21
	db $21, $98  ; (1, 2): object $98
	db $23, $29  ; (3, 2): object $29
	db $c6, $29, $10  ; 6 down from (9, 2): object $10
	db $30, $dc  ; (0, 3): object $DC
	db $40, $22  ; (0, 4): object $22
	db $41, $2b  ; (1, 4): object $2B
	db $c3, $50, $03  ; 3 down from (0, 5): object $03
	db $c3, $51, $23  ; 3 down from (1, 5): object $23
	db $35, $2c  ; (5, 3): object $2C
	db $36, $28  ; (6, 3): object $28
	db $c3, $45, $24  ; 3 down from (5, 4): object $24
	db $84, $71, $22  ; 4 across from (1, 7): object $22
	db $71, $27  ; (1, 7): object $27
	db $72, $f5  ; (2, 7): object $F5
	db $64, $2c  ; (4, 6): object $2C
	db $65, $28  ; (5, 6): object $28
	db $74, $28  ; (4, 7): object $28
	db $79, $2c  ; (9, 7): object $2C
	db $42, $1d  ; (2, 4): object $1D
	db $e1, $06, $14, $00, $00  ; warp type 1 to map $06 room $14, x 0 y 0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2C of indoor group B: 33 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $0E at x 88, y 50. Format: see IndoorBRoomPointers.
IndoorBRoom2C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $74, $f1  ; (4, 7): object $F1
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $82, $54, $0f  ; 2 across from (4, 5): object $0F
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
	db $02, $26  ; (2, 0): object $26
	db $03, $2a  ; (3, 0): object $2A
	db $06, $29  ; (6, 0): object $29
	db $07, $25  ; (7, 0): object $25
	db $c3, $12, $24  ; 3 down from (2, 1): object $24
	db $42, $2a  ; (2, 4): object $2A
	db $84, $43, $21  ; 4 across from (3, 4): object $21
	db $82, $44, $97  ; 2 across from (4, 4): object $97
	db $47, $29  ; (7, 4): object $29
	db $c3, $17, $23  ; 3 down from (7, 1): object $23
	db $13, $c0  ; (3, 1): object $C0
	db $16, $c0  ; (6, 1): object $C0
	db $33, $c0  ; (3, 3): object $C0
	db $36, $c0  ; (6, 3): object $C0
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $60, $27  ; (0, 6): object $27
	db $82, $61, $22  ; 2 across from (1, 6): object $22
	db $63, $2b  ; (3, 6): object $2B
	db $66, $2c  ; (6, 6): object $2C
	db $82, $67, $22  ; 2 across from (7, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $83, $77, $03  ; 3 across from (7, 7): object $03
	db $82, $70, $22  ; 2 across from (0, 7): object $22
	db $72, $2b  ; (2, 7): object $2B
	db $73, $27  ; (3, 7): object $27
	db $76, $28  ; (6, 7): object $28
	db $e0, $00, $0e, $58, $32  ; warp type 0 to map $00 room $0E, x 88 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2D of indoor group B: 25 objects, room template 5 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom2D::
	db $04, $5d  ; animated tiles $04, template 5, floor $0D
	db $20, $f6  ; (0, 2): object $F6
	db $59, $f7  ; (9, 5): object $F7
	db $75, $f5  ; (5, 7): object $F5
	db $00, $ac  ; (0, 0): object $AC
	db $01, $25  ; (1, 0): object $25
	db $02, $f8  ; (2, 0): object $F8
	db $04, $26  ; (4, 0): object $26
	db $09, $2a  ; (9, 0): object $2A
	db $10, $03  ; (0, 1): object $03
	db $11, $23  ; (1, 1): object $23
	db $c3, $14, $24  ; 3 down from (4, 1): object $24
	db $20, $21  ; (0, 2): object $21
	db $21, $29  ; (1, 2): object $29
	db $30, $db  ; (0, 3): object $DB
	db $34, $2a  ; (4, 3): object $2A
	db $85, $35, $21  ; 5 across from (5, 3): object $21
	db $40, $2b  ; (0, 4): object $2B
	db $c2, $59, $0d  ; 2 down from (9, 5): object $0D
	db $75, $2b  ; (5, 7): object $2B
	db $76, $0d  ; (6, 7): object $0D
	db $77, $2c  ; (7, 7): object $2C
	db $70, $23  ; (0, 7): object $23
	db $71, $0d  ; (1, 7): object $0D
	db $72, $2c  ; (2, 7): object $2C
	db $76, $dc  ; (6, 7): object $DC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2E of indoor group B: 17 objects, room template 4 and floor object $0D; a warp (type 2) to map $06 room $F8 at x 72, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom2E::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $50, $f6  ; (0, 5): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $72, $f5  ; (2, 7): object $F5
	db $02, $29  ; (2, 0): object $29
	db $03, $25  ; (3, 0): object $25
	db $c3, $13, $23  ; 3 down from (3, 1): object $23
	db $83, $30, $21  ; 3 across from (0, 3): object $21
	db $33, $29  ; (3, 3): object $29
	db $c2, $50, $0d  ; 2 down from (0, 5): object $0D
	db $72, $2b  ; (2, 7): object $2B
	db $73, $0d  ; (3, 7): object $0D
	db $74, $2c  ; (4, 7): object $2C
	db $82, $34, $a6  ; 2 across from (4, 3): object $A6
	db $36, $a7  ; (6, 3): object $A7
	db $c3, $17, $a7  ; 3 down from (7, 1): object $A7
	db $01, $a8  ; (1, 0): object $A8
	db $e2, $06, $f8, $48, $50  ; warp type 2 to map $06 room $F8, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2F of indoor group B: 0 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom2F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $30 of indoor group B: 24 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $10 at x 88, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom30::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $74, $f1  ; (4, 7): object $F1
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $82, $54, $0f  ; 2 across from (4, 5): object $0F
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
	db $02, $26  ; (2, 0): object $26
	db $03, $2a  ; (3, 0): object $2A
	db $06, $29  ; (6, 0): object $29
	db $07, $25  ; (7, 0): object $25
	db $c3, $12, $24  ; 3 down from (2, 1): object $24
	db $42, $2a  ; (2, 4): object $2A
	db $84, $43, $21  ; 4 across from (3, 4): object $21
	db $82, $44, $97  ; 2 across from (4, 4): object $97
	db $47, $29  ; (7, 4): object $29
	db $c3, $17, $23  ; 3 down from (7, 1): object $23
	db $13, $c0  ; (3, 1): object $C0
	db $16, $c0  ; (6, 1): object $C0
	db $33, $c0  ; (3, 3): object $C0
	db $36, $c0  ; (6, 3): object $C0
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $e0, $00, $10, $58, $10  ; warp type 0 to map $00 room $10, x 88 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $31 of indoor group B: 9 objects, room template 9 and floor object $03; a warp (type 2) to map $07 room $66 at x 24, y 128. Format: see IndoorBRoomPointers.
IndoorBRoom31::
	db $06, $93  ; animated tiles $06, template 9, floor $03
	db $76, $f5  ; (6, 7): object $F5
	db $05, $25  ; (5, 0): object $25
	db $82, $06, $21  ; 2 across from (6, 0): object $21
	db $08, $26  ; (8, 0): object $26
	db $c7, $15, $23  ; 7 down from (5, 1): object $23
	db $c7, $16, $0d  ; 7 down from (6, 1): object $0D
	db $c7, $17, $0d  ; 7 down from (7, 1): object $0D
	db $c7, $18, $24  ; 7 down from (8, 1): object $24
	db $17, $cb  ; (7, 1): object $CB
	db $e2, $07, $66, $18, $80  ; warp type 2 to map $07 room $66, x 24 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $32 of indoor group B: 18 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom32::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $71, $f5  ; (1, 7): object $F5
	db $86, $22, $af  ; 6 across from (2, 2): object $AF
	db $86, $32, $01  ; 6 across from (2, 3): object $01
	db $86, $42, $01  ; 6 across from (2, 4): object $01
	db $86, $52, $01  ; 6 across from (2, 5): object $01
	db $85, $63, $b0  ; 5 across from (3, 6): object $B0
	db $23, $ae  ; (3, 2): object $AE
	db $26, $ae  ; (6, 2): object $AE
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $43, $af  ; (3, 4): object $AF
	db $46, $af  ; (6, 4): object $AF
	db $68, $ae  ; (8, 6): object $AE
	db $33, $ac  ; (3, 3): object $AC
	db $36, $ac  ; (6, 3): object $AC
	db $52, $0d  ; (2, 5): object $0D
	db $42, $b0  ; (2, 4): object $B0
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $33 of indoor group B: 9 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom33::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $12, $06  ; (2, 1): object $06
	db $17, $06  ; (7, 1): object $06
	db $86, $22, $06  ; 6 across from (2, 2): object $06
	db $86, $32, $06  ; 6 across from (2, 3): object $06
	db $86, $42, $06  ; 6 across from (2, 4): object $06
	db $86, $52, $06  ; 6 across from (2, 5): object $06
	db $c5, $11, $06  ; 5 down from (1, 1): object $06
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $35 of indoor group B: 25 objects, room template 3 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom35::
	db $06, $3d  ; animated tiles $06, template 3, floor $0D
	db $06, $f4  ; (6, 0): object $F4
	db $71, $f5  ; (1, 7): object $F5
	db $02, $26  ; (2, 0): object $26
	db $03, $12  ; (3, 0): object $12
	db $04, $25  ; (4, 0): object $25
	db $c7, $11, $06  ; 7 down from (1, 1): object $06
	db $c2, $12, $24  ; 2 down from (2, 1): object $24
	db $13, $a0  ; (3, 1): object $A0
	db $c7, $14, $23  ; 7 down from (4, 1): object $23
	db $32, $2a  ; (2, 3): object $2A
	db $33, $21  ; (3, 3): object $21
	db $34, $29  ; (4, 3): object $29
	db $83, $42, $06  ; 3 across from (2, 4): object $06
	db $52, $2c  ; (2, 5): object $2C
	db $53, $22  ; (3, 5): object $22
	db $54, $2b  ; (4, 5): object $2B
	db $c2, $62, $24  ; 2 down from (2, 6): object $24
	db $c2, $64, $23  ; 2 down from (4, 6): object $23
	db $74, $27  ; (4, 7): object $27
	db $84, $75, $22  ; 4 across from (5, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $c2, $61, $0d  ; 2 down from (1, 6): object $0D
	db $05, $29  ; (5, 0): object $29
	db $82, $06, $0d  ; 2 across from (6, 0): object $0D
	db $08, $2a  ; (8, 0): object $2A
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $36 of indoor group B: 40 objects, room template 0 and floor object $0D; a warp (type 2) to map $07 room $65 at x 136, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom36::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $85, $71, $0d  ; 5 across from (1, 7): object $0D
	db $00, $c0  ; (0, 0): object $C0
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $c0  ; (9, 0): object $C0
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $86, $12, $0f  ; 6 across from (2, 1): object $0F
	db $18, $2a  ; (8, 1): object $2A
	db $19, $21  ; (9, 1): object $21
	db $20, $29  ; (0, 2): object $29
	db $84, $21, $0f  ; 4 across from (1, 2): object $0F
	db $25, $25  ; (5, 2): object $25
	db $26, $c7  ; (6, 2): object $C7
	db $27, $98  ; (7, 2): object $98
	db $28, $c7  ; (8, 2): object $C7
	db $29, $26  ; (9, 2): object $26
	db $30, $25  ; (0, 3): object $25
	db $84, $31, $21  ; 4 across from (1, 3): object $21
	db $35, $29  ; (5, 3): object $29
	db $45, $a6  ; (5, 4): object $A6
	db $54, $a6  ; (4, 5): object $A6
	db $49, $2a  ; (9, 4): object $2A
	db $50, $29  ; (0, 5): object $29
	db $83, $46, $dc  ; 3 across from (6, 4): object $DC
	db $55, $25  ; (5, 5): object $25
	db $56, $c7  ; (6, 5): object $C7
	db $57, $98  ; (7, 5): object $98
	db $58, $c7  ; (8, 5): object $C7
	db $59, $26  ; (9, 5): object $26
	db $60, $25  ; (0, 6): object $25
	db $82, $61, $21  ; 2 across from (1, 6): object $21
	db $63, $26  ; (3, 6): object $26
	db $65, $23  ; (5, 6): object $23
	db $70, $23  ; (0, 7): object $23
	db $73, $24  ; (3, 7): object $24
	db $75, $27  ; (5, 7): object $27
	db $76, $f5  ; (6, 7): object $F5
	db $13, $a0  ; (3, 1): object $A0
	db $42, $be  ; (2, 4): object $BE
	db $e2, $07, $65, $88, $10  ; warp type 2 to map $07 room $65, x 136 y 16
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $38 of indoor group B: 8 objects, room template 0 and floor object $06. Format: see IndoorBRoomPointers.
IndoorBRoom38::
	db $06, $06  ; animated tiles $06, template 0, floor $06
	db $01, $f0  ; (1, 0): object $F0
	db $59, $f3  ; (9, 5): object $F3
	db $88, $11, $0d  ; 8 across from (1, 1): object $0D
	db $c4, $21, $0d  ; 4 down from (1, 2): object $0D
	db $c4, $28, $0d  ; 4 down from (8, 2): object $0D
	db $88, $61, $0d  ; 8 across from (1, 6): object $0D
	db $16, $06  ; (6, 1): object $06
	db $63, $06  ; (3, 6): object $06
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $39 of indoor group B: 39 objects, room template 2 and floor object $0D; a warp (type 2) to map $07 room $60 at x 24, y 128. Format: see IndoorBRoomPointers.
IndoorBRoom39::
	db $06, $2d  ; animated tiles $06, template 2, floor $0D
	db $50, $ee  ; (0, 5): object $EE
	db $c2, $00, $24  ; 2 down from (0, 0): object $24
	db $01, $17  ; (1, 0): object $17
	db $83, $02, $12  ; 3 across from (2, 0): object $12
	db $05, $16  ; (5, 0): object $16
	db $06, $25  ; (6, 0): object $25
	db $11, $11  ; (1, 1): object $11
	db $15, $10  ; (5, 1): object $10
	db $16, $23  ; (6, 1): object $23
	db $20, $2a  ; (0, 2): object $2A
	db $85, $21, $21  ; 5 across from (1, 2): object $21
	db $22, $98  ; (2, 2): object $98
	db $26, $29  ; (6, 2): object $29
	db $27, $25  ; (7, 2): object $25
	db $28, $98  ; (8, 2): object $98
	db $29, $26  ; (9, 2): object $26
	db $30, $c0  ; (0, 3): object $C0
	db $86, $31, $0f  ; 6 across from (1, 3): object $0F
	db $c3, $37, $23  ; 3 down from (7, 3): object $23
	db $c3, $39, $24  ; 3 down from (9, 3): object $24
	db $40, $25  ; (0, 4): object $25
	db $41, $98  ; (1, 4): object $98
	db $42, $21  ; (2, 4): object $21
	db $43, $26  ; (3, 4): object $26
	db $44, $2c  ; (4, 4): object $2C
	db $45, $22  ; (5, 4): object $22
	db $46, $2b  ; (6, 4): object $2B
	db $49, $f3  ; (9, 4): object $F3
	db $c2, $53, $24  ; 2 down from (3, 5): object $24
	db $c3, $54, $24  ; 3 down from (4, 5): object $24
	db $c3, $55, $03  ; 3 down from (5, 5): object $03
	db $c2, $56, $23  ; 2 down from (6, 5): object $23
	db $67, $27  ; (7, 6): object $27
	db $68, $22  ; (8, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $73, $28  ; (3, 7): object $28
	db $76, $27  ; (6, 7): object $27
	db $79, $2b  ; (9, 7): object $2B
	db $14, $cb  ; (4, 1): object $CB
	db $e2, $07, $60, $18, $80  ; warp type 2 to map $07 room $60, x 24 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3A of indoor group B: 34 objects, room template 2 and floor object $0D; a warp (type 0) to overworld room $00 at x 72, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom3A::
	db $06, $2d  ; animated tiles $06, template 2, floor $0D
	db $40, $f2  ; (0, 4): object $F2
	db $29, $f7  ; (9, 2): object $F7
	db $71, $f5  ; (1, 7): object $F5
	db $00, $21  ; (0, 0): object $21
	db $02, $29  ; (2, 0): object $29
	db $03, $25  ; (3, 0): object $25
	db $06, $26  ; (6, 0): object $26
	db $07, $17  ; (7, 0): object $17
	db $08, $12  ; (8, 0): object $12
	db $09, $16  ; (9, 0): object $16
	db $83, $10, $0d  ; 3 across from (0, 1): object $0D
	db $13, $23  ; (3, 1): object $23
	db $c2, $16, $24  ; 2 down from (6, 1): object $24
	db $19, $10  ; (9, 1): object $10
	db $20, $25  ; (0, 2): object $25
	db $82, $21, $21  ; 2 across from (1, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $29, $14  ; (9, 2): object $14
	db $36, $2a  ; (6, 3): object $2A
	db $83, $37, $21  ; 3 across from (7, 3): object $21
	db $82, $68, $06  ; 2 across from (8, 6): object $06
	db $70, $23  ; (0, 7): object $23
	db $71, $0d  ; (1, 7): object $0D
	db $72, $2c  ; (2, 7): object $2C
	db $73, $2b  ; (3, 7): object $2B
	db $74, $06  ; (4, 7): object $06
	db $75, $2c  ; (5, 7): object $2C
	db $77, $2b  ; (7, 7): object $2B
	db $78, $06  ; (8, 7): object $06
	db $79, $2c  ; (9, 7): object $2C
	db $86, $62, $20  ; 6 across from (2, 6): object $20
	db $64, $0d  ; (4, 6): object $0D
	db $18, $a0  ; (8, 1): object $A0
	db $05, $a8  ; (5, 0): object $A8
	db $e0, $00, $00, $48, $50  ; warp type 0 to map $00 room $00, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3B of indoor group B: 25 objects, room template 0 and floor object $06; a warp (type 2) to map $07 room $62 at x 24, y 128. Format: see IndoorBRoomPointers.
IndoorBRoom3B::
	db $06, $06  ; animated tiles $06, template 0, floor $06
	db $39, $ef  ; (9, 3): object $EF
	db $04, $f8  ; (4, 0): object $F8
	db $c3, $14, $11  ; 3 down from (4, 1): object $11
	db $c3, $15, $10  ; 3 down from (5, 1): object $10
	db $30, $29  ; (0, 3): object $29
	db $21, $12  ; (1, 2): object $12
	db $22, $ac  ; (2, 2): object $AC
	db $27, $ac  ; (7, 2): object $AC
	db $28, $12  ; (8, 2): object $12
	db $c2, $40, $0d  ; 2 down from (0, 4): object $0D
	db $c3, $32, $10  ; 3 down from (2, 3): object $10
	db $c3, $37, $11  ; 3 down from (7, 3): object $11
	db $44, $15  ; (4, 4): object $15
	db $45, $14  ; (5, 4): object $14
	db $59, $2a  ; (9, 5): object $2A
	db $60, $06  ; (0, 6): object $06
	db $62, $94  ; (2, 6): object $94
	db $84, $63, $12  ; 4 across from (3, 6): object $12
	db $67, $93  ; (7, 6): object $93
	db $69, $06  ; (9, 6): object $06
	db $70, $22  ; (0, 7): object $22
	db $79, $22  ; (9, 7): object $22
	db $c4, $31, $0d  ; 4 down from (1, 3): object $0D
	db $c4, $38, $0d  ; 4 down from (8, 3): object $0D
	db $35, $cb  ; (5, 3): object $CB
	db $e2, $07, $62, $18, $80  ; warp type 2 to map $07 room $62, x 24 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3C of indoor group B: 35 objects, room template 1 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom3C::
	db $06, $1d  ; animated tiles $06, template 1, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $30, $ee  ; (0, 3): object $EE
	db $39, $ef  ; (9, 3): object $EF
	db $c3, $01, $06  ; 3 down from (1, 0): object $06
	db $c2, $02, $24  ; 2 down from (2, 0): object $24
	db $c2, $04, $23  ; 2 down from (4, 0): object $23
	db $04, $25  ; (4, 0): object $25
	db $84, $05, $21  ; 4 across from (5, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $22, $2a  ; (2, 2): object $2A
	db $23, $98  ; (3, 2): object $98
	db $24, $29  ; (4, 2): object $29
	db $39, $0d  ; (9, 3): object $0D
	db $49, $2c  ; (9, 4): object $2C
	db $50, $29  ; (0, 5): object $29
	db $70, $22  ; (0, 7): object $22
	db $c5, $01, $0d  ; 5 down from (1, 0): object $0D
	db $c2, $15, $0d  ; 2 down from (5, 1): object $0D
	db $82, $27, $0d  ; 2 across from (7, 2): object $0D
	db $86, $33, $0d  ; 6 across from (3, 3): object $0D
	db $82, $43, $0d  ; 2 across from (3, 4): object $0D
	db $51, $06  ; (1, 5): object $06
	db $53, $0d  ; (3, 5): object $0D
	db $c3, $32, $06  ; 3 down from (2, 3): object $06
	db $16, $06  ; (6, 1): object $06
	db $c2, $26, $06  ; 2 down from (6, 2): object $06
	db $84, $45, $06  ; 4 across from (5, 4): object $06
	db $85, $54, $06  ; 5 across from (4, 5): object $06
	db $89, $60, $06  ; 9 across from (0, 6): object $06
	db $08, $26  ; (8, 0): object $26
	db $09, $c0  ; (9, 0): object $C0
	db $18, $24  ; (8, 1): object $24
	db $19, $13  ; (9, 1): object $13
	db $28, $2a  ; (8, 2): object $2A
	db $29, $21  ; (9, 2): object $21
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3D of indoor group B: 23 objects, room template 2 and floor object $0D; a warp (type 0) to overworld room $02 at x 56, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom3D::
	db $06, $2d  ; animated tiles $06, template 2, floor $0D
	db $05, $a3  ; (5, 0): object $A3
	db $10, $f6  ; (0, 1): object $F6
	db $19, $f7  ; (9, 1): object $F7
	db $00, $2a  ; (0, 0): object $2A
	db $09, $29  ; (9, 0): object $29
	db $87, $10, $13  ; 7 across from (0, 1): object $13
	db $17, $95  ; (7, 1): object $95
	db $19, $0d  ; (9, 1): object $0D
	db $86, $20, $21  ; 6 across from (0, 2): object $21
	db $26, $26  ; (6, 2): object $26
	db $c2, $27, $11  ; 2 down from (7, 2): object $11
	db $29, $2c  ; (9, 2): object $2C
	db $30, $0d  ; (0, 3): object $0D
	db $c2, $36, $24  ; 2 down from (6, 3): object $24
	db $47, $15  ; (7, 4): object $15
	db $39, $24  ; (9, 3): object $24
	db $40, $2b  ; (0, 4): object $2B
	db $56, $2a  ; (6, 5): object $2A
	db $82, $57, $21  ; 2 across from (7, 5): object $21
	db $49, $2a  ; (9, 4): object $2A
	db $59, $21  ; (9, 5): object $21
	db $48, $13  ; (8, 4): object $13
	db $28, $a1  ; (8, 2): object $A1
	db $e0, $00, $02, $38, $50  ; warp type 0 to map $00 room $02, x 56 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3E of indoor group B: 19 objects, room template 4 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom3E::
	db $06, $4d  ; animated tiles $06, template 4, floor $0D
	db $10, $f6  ; (0, 1): object $F6
	db $74, $f1  ; (4, 7): object $F1
	db $87, $12, $df  ; 7 across from (2, 1): object $DF
	db $87, $22, $df  ; 7 across from (2, 2): object $DF
	db $87, $32, $df  ; 7 across from (2, 3): object $DF
	db $87, $42, $df  ; 7 across from (2, 4): object $DF
	db $82, $57, $df  ; 2 across from (7, 5): object $DF
	db $83, $61, $df  ; 3 across from (1, 6): object $DF
	db $83, $66, $df  ; 3 across from (6, 6): object $DF
	db $00, $c0  ; (0, 0): object $C0
	db $01, $25  ; (1, 0): object $25
	db $10, $0d  ; (0, 1): object $0D
	db $c4, $11, $23  ; 4 down from (1, 1): object $23
	db $20, $2b  ; (0, 2): object $2B
	db $30, $23  ; (0, 3): object $23
	db $40, $29  ; (0, 4): object $29
	db $50, $21  ; (0, 5): object $21
	db $51, $29  ; (1, 5): object $29
	db $85, $52, $a6  ; 5 across from (2, 5): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3F of indoor group B: 6 objects, room template 0 and floor object $0D; a warp (type 1) to map $07 room $5D at x 80, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom3F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $00, $23  ; (0, 0): object $23
	db $82, $01, $0d  ; 2 across from (1, 0): object $0D
	db $03, $2a  ; (3, 0): object $2A
	db $05, $c7  ; (5, 0): object $C7
	db $06, $f0  ; (6, 0): object $F0
	db $08, $c7  ; (8, 0): object $C7
	db $e1, $07, $5d, $50, $50  ; warp type 1 to map $07 room $5D, x 80 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $40 of indoor group B: 27 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom40::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $19, $f7  ; (9, 1): object $F7
	db $70, $f5  ; (0, 7): object $F5
	db $00, $17  ; (0, 0): object $17
	db $83, $01, $12  ; 3 across from (1, 0): object $12
	db $04, $2a  ; (4, 0): object $2A
	db $84, $05, $21  ; 4 across from (5, 0): object $21
	db $09, $29  ; (9, 0): object $29
	db $c7, $10, $11  ; 7 down from (0, 1): object $11
	db $c7, $11, $10  ; 7 down from (1, 1): object $10
	db $12, $25  ; (2, 1): object $25
	db $13, $98  ; (3, 1): object $98
	db $85, $14, $21  ; 5 across from (4, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $c5, $22, $23  ; 5 down from (2, 2): object $23
	db $24, $a6  ; (4, 2): object $A6
	db $27, $a6  ; (7, 2): object $A6
	db $36, $a0  ; (6, 3): object $A0
	db $43, $af  ; (3, 4): object $AF
	db $82, $45, $a7  ; 2 across from (5, 4): object $A7
	db $48, $af  ; (8, 4): object $AF
	db $53, $b0  ; (3, 5): object $B0
	db $58, $01  ; (8, 5): object $01
	db $68, $b0  ; (8, 6): object $B0
	db $72, $27  ; (2, 7): object $27
	db $19, $21  ; (9, 1): object $21
	db $29, $0d  ; (9, 2): object $0D
	db $39, $2c  ; (9, 3): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $41 of indoor group B: 34 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom41::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $39, $4a  ; (9, 3): object $4A
	db $01, $f4  ; (1, 0): object $F4
	db $10, $f6  ; (0, 1): object $F6
	db $71, $f5  ; (1, 7): object $F5
	db $70, $23  ; (0, 7): object $23
	db $71, $0d  ; (1, 7): object $0D
	db $72, $2c  ; (2, 7): object $2C
	db $00, $23  ; (0, 0): object $23
	db $01, $0d  ; (1, 0): object $0D
	db $02, $2a  ; (2, 0): object $2A
	db $03, $29  ; (3, 0): object $29
	db $04, $06  ; (4, 0): object $06
	db $05, $2a  ; (5, 0): object $2A
	db $07, $29  ; (7, 0): object $29
	db $c8, $08, $06  ; 8 down from (8, 0): object $06
	db $09, $24  ; (9, 0): object $24
	db $12, $10  ; (2, 1): object $10
	db $83, $13, $06  ; 3 across from (3, 1): object $06
	db $14, $c0  ; (4, 1): object $C0
	db $16, $11  ; (6, 1): object $11
	db $22, $94  ; (2, 2): object $94
	db $23, $16  ; (3, 2): object $16
	db $24, $06  ; (4, 2): object $06
	db $25, $17  ; (5, 2): object $17
	db $26, $93  ; (6, 2): object $93
	db $c4, $34, $0f  ; 4 down from (4, 3): object $0F
	db $85, $42, $a6  ; 5 across from (2, 4): object $A6
	db $44, $0f  ; (4, 4): object $0F
	db $77, $2b  ; (7, 7): object $2B
	db $79, $24  ; (9, 7): object $24
	db $10, $29  ; (0, 1): object $29
	db $20, $0d  ; (0, 2): object $0D
	db $30, $2b  ; (0, 3): object $2B
	db $32, $0f  ; (2, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $42 of indoor group B: 22 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom42::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $30, $41  ; (0, 3): object $41
	db $39, $f3  ; (9, 3): object $F3
	db $74, $40  ; (4, 7): object $40
	db $06, $26  ; (6, 0): object $26
	db $83, $07, $a6  ; 3 across from (7, 0): object $A6
	db $25, $ab  ; (5, 2): object $AB
	db $16, $24  ; (6, 1): object $24
	db $18, $de  ; (8, 1): object $DE
	db $19, $0d  ; (9, 1): object $0D
	db $23, $ae  ; (3, 2): object $AE
	db $26, $2a  ; (6, 2): object $2A
	db $27, $98  ; (7, 2): object $98
	db $28, $21  ; (8, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $33, $a6  ; (3, 3): object $A6
	db $45, $ae  ; (5, 4): object $AE
	db $47, $a6  ; (7, 4): object $A6
	db $52, $ae  ; (2, 5): object $AE
	db $58, $ae  ; (8, 5): object $AE
	db $61, $ab  ; (1, 6): object $AB
	db $65, $a6  ; (5, 6): object $A6
	db $67, $ae  ; (7, 6): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $43 of indoor group B: 31 objects, room template 0 and floor object $07; a warp (type 2) to map $07 room $64 at x 24, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom43::
	db $06, $07  ; animated tiles $06, template 0, floor $07
	db $30, $f2  ; (0, 3): object $F2
	db $59, $f7  ; (9, 5): object $F7
	db $71, $40  ; (1, 7): object $40
	db $8a, $00, $0d  ; 10 across from (0, 0): object $0D
	db $8a, $10, $0d  ; 10 across from (0, 1): object $0D
	db $00, $a6  ; (0, 0): object $A6
	db $88, $01, $12  ; 8 across from (1, 0): object $12
	db $82, $04, $a6  ; 2 across from (4, 0): object $A6
	db $c2, $09, $a6  ; 2 down from (9, 0): object $A6
	db $12, $ab  ; (2, 1): object $AB
	db $17, $ab  ; (7, 1): object $AB
	db $20, $25  ; (0, 2): object $25
	db $88, $21, $21  ; 8 across from (1, 2): object $21
	db $22, $98  ; (2, 2): object $98
	db $27, $98  ; (7, 2): object $98
	db $29, $26  ; (9, 2): object $26
	db $42, $2c  ; (2, 4): object $2C
	db $83, $43, $22  ; 3 across from (3, 4): object $22
	db $46, $2b  ; (6, 4): object $2B
	db $59, $2a  ; (9, 5): object $2A
	db $c2, $52, $24  ; 2 down from (2, 5): object $24
	db $83, $53, $0d  ; 3 across from (3, 5): object $0D
	db $54, $de  ; (4, 5): object $DE
	db $c2, $56, $23  ; 2 down from (6, 5): object $23
	db $83, $63, $a6  ; 3 across from (3, 6): object $A6
	db $69, $0d  ; (9, 6): object $0D
	db $72, $28  ; (2, 7): object $28
	db $83, $73, $a6  ; 3 across from (3, 7): object $A6
	db $76, $27  ; (6, 7): object $27
	db $79, $22  ; (9, 7): object $22
	db $64, $be  ; (4, 6): object $BE
	db $e2, $07, $64, $18, $10  ; warp type 2 to map $07 room $64, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $44 of indoor group B: 14 objects, room template 0 and floor object $07. Format: see IndoorBRoomPointers.
IndoorBRoom44::
	db $06, $07  ; animated tiles $06, template 0, floor $07
	db $50, $f6  ; (0, 5): object $F6
	db $49, $42  ; (9, 4): object $42
	db $14, $af  ; (4, 1): object $AF
	db $c4, $24, $01  ; 4 down from (4, 2): object $01
	db $32, $ab  ; (2, 3): object $AB
	db $c4, $33, $a6  ; 4 down from (3, 3): object $A6
	db $35, $ae  ; (5, 3): object $AE
	db $37, $ab  ; (7, 3): object $AB
	db $50, $29  ; (0, 5): object $29
	db $60, $0d  ; (0, 6): object $0D
	db $61, $de  ; (1, 6): object $DE
	db $64, $b0  ; (4, 6): object $B0
	db $65, $ae  ; (5, 6): object $AE
	db $70, $22  ; (0, 7): object $22
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $45 of indoor group B: 18 objects, room template 0 and floor object $0F. Format: see IndoorBRoomPointers.
IndoorBRoom45::
	db $06, $0f  ; animated tiles $06, template 0, floor $0F
	db $04, $f0  ; (4, 0): object $F0
	db $40, $49  ; (0, 4): object $49
	db $74, $fb  ; (4, 7): object $FB
	db $c3, $13, $0d  ; 3 down from (3, 1): object $0D
	db $c2, $22, $a9  ; 2 down from (2, 2): object $A9
	db $c2, $31, $a9  ; 2 down from (1, 3): object $A9
	db $83, $33, $0d  ; 3 across from (3, 3): object $0D
	db $34, $a9  ; (4, 3): object $A9
	db $83, $36, $a9  ; 3 across from (6, 3): object $A9
	db $42, $0d  ; (2, 4): object $0D
	db $83, $43, $a9  ; 3 across from (3, 4): object $A9
	db $82, $46, $0d  ; 2 across from (6, 4): object $0D
	db $48, $a9  ; (8, 4): object $A9
	db $82, $52, $0d  ; 2 across from (2, 5): object $0D
	db $63, $0d  ; (3, 6): object $0D
	db $c2, $38, $0d  ; 2 down from (8, 3): object $0D
	db $47, $a9  ; (7, 4): object $A9
	db $41, $0d  ; (1, 4): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $46 of indoor group B: 22 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom46::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $00, $f4  ; (0, 0): object $F4
	db $74, $f5  ; (4, 7): object $F5
	db $00, $11  ; (0, 0): object $11
	db $01, $94  ; (1, 0): object $94
	db $83, $02, $12  ; 3 across from (2, 0): object $12
	db $05, $16  ; (5, 0): object $16
	db $06, $25  ; (6, 0): object $25
	db $10, $15  ; (0, 1): object $15
	db $16, $23  ; (6, 1): object $23
	db $20, $25  ; (0, 2): object $25
	db $85, $21, $21  ; 5 across from (1, 2): object $21
	db $26, $29  ; (6, 2): object $29
	db $88, $41, $13  ; 8 across from (1, 4): object $13
	db $82, $44, $0d  ; 2 across from (4, 4): object $0D
	db $c2, $53, $10  ; 2 down from (3, 5): object $10
	db $c2, $56, $11  ; 2 down from (6, 5): object $11
	db $61, $ab  ; (1, 6): object $AB
	db $68, $ab  ; (8, 6): object $AB
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $47 of indoor group B: 15 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom47::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $29, $f7  ; (9, 2): object $F7
	db $00, $23  ; (0, 0): object $23
	db $01, $0d  ; (1, 0): object $0D
	db $02, $2a  ; (2, 0): object $2A
	db $07, $29  ; (7, 0): object $29
	db $08, $06  ; (8, 0): object $06
	db $09, $2a  ; (9, 0): object $2A
	db $83, $17, $06  ; 3 across from (7, 1): object $06
	db $27, $06  ; (7, 2): object $06
	db $82, $28, $06  ; 2 across from (8, 2): object $06
	db $39, $0d  ; (9, 3): object $0D
	db $49, $2c  ; (9, 4): object $2C
	db $c6, $15, $a7  ; 6 down from (5, 1): object $A7
	db $c6, $16, $06  ; 6 down from (6, 1): object $06
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $48 of indoor group B: 18 objects, room template 2 and floor object $0D; a warp (type 2) to map $07 room $6A at x 24, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom48::
	db $06, $2d  ; animated tiles $06, template 2, floor $0D
	db $04, $47  ; (4, 0): object $47
	db $10, $f6  ; (0, 1): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $77, $40  ; (7, 7): object $40
	db $00, $21  ; (0, 0): object $21
	db $30, $0d  ; (0, 3): object $0D
	db $c3, $29, $0d  ; 3 down from (9, 2): object $0D
	db $09, $26  ; (9, 0): object $26
	db $19, $2a  ; (9, 1): object $2A
	db $40, $2b  ; (0, 4): object $2B
	db $c2, $10, $06  ; 2 down from (0, 1): object $06
	db $12, $ac  ; (2, 1): object $AC
	db $84, $13, $06  ; 4 across from (3, 1): object $06
	db $17, $ac  ; (7, 1): object $AC
	db $82, $41, $a6  ; 2 across from (1, 4): object $A6
	db $86, $54, $a6  ; 6 across from (4, 5): object $A6
	db $53, $a7  ; (3, 5): object $A7
	db $61, $be  ; (1, 6): object $BE
	db $e2, $07, $6a, $18, $10  ; warp type 2 to map $07 room $6A, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $49 of indoor group B: 32 objects, room template 3 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom49::
	db $06, $3d  ; animated tiles $06, template 3, floor $0D
	db $01, $47  ; (1, 0): object $47
	db $20, $f6  ; (0, 2): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $71, $f5  ; (1, 7): object $F5
	db $c6, $20, $0d  ; 6 down from (0, 2): object $0D
	db $c6, $29, $0d  ; 6 down from (9, 2): object $0D
	db $10, $29  ; (0, 1): object $29
	db $88, $11, $06  ; 8 across from (1, 1): object $06
	db $19, $2a  ; (9, 1): object $2A
	db $26, $de  ; (6, 2): object $DE
	db $32, $2c  ; (2, 3): object $2C
	db $82, $33, $22  ; 2 across from (3, 3): object $22
	db $35, $2b  ; (5, 3): object $2B
	db $37, $2c  ; (7, 3): object $2C
	db $82, $38, $22  ; 2 across from (8, 3): object $22
	db $42, $24  ; (2, 4): object $24
	db $82, $43, $03  ; 2 across from (3, 4): object $03
	db $45, $23  ; (5, 4): object $23
	db $47, $2a  ; (7, 4): object $2A
	db $82, $48, $21  ; 2 across from (8, 4): object $21
	db $82, $50, $a6  ; 2 across from (0, 5): object $A6
	db $52, $2a  ; (2, 5): object $2A
	db $82, $53, $21  ; 2 across from (3, 5): object $21
	db $55, $29  ; (5, 5): object $29
	db $c3, $57, $a6  ; 3 down from (7, 5): object $A6
	db $62, $a7  ; (2, 6): object $A7
	db $c2, $65, $a6  ; 2 down from (5, 6): object $A6
	db $69, $2c  ; (9, 6): object $2C
	db $70, $2b  ; (0, 7): object $2B
	db $73, $a6  ; (3, 7): object $A6
	db $79, $24  ; (9, 7): object $24
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4A of indoor group B: 18 objects, room template 4 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom4A::
	db $06, $4d  ; animated tiles $06, template 4, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $ef  ; (9, 3): object $EF
	db $71, $f5  ; (1, 7): object $F5
	db $00, $25  ; (0, 0): object $25
	db $10, $29  ; (0, 1): object $29
	db $20, $0d  ; (0, 2): object $0D
	db $30, $2b  ; (0, 3): object $2B
	db $40, $29  ; (0, 4): object $29
	db $84, $41, $a6  ; 4 across from (1, 4): object $A6
	db $54, $a6  ; (4, 5): object $A6
	db $84, $60, $22  ; 4 across from (0, 6): object $22
	db $62, $98  ; (2, 6): object $98
	db $64, $2b  ; (4, 6): object $2B
	db $70, $a6  ; (0, 7): object $A6
	db $83, $71, $0d  ; 3 across from (1, 7): object $0D
	db $74, $27  ; (4, 7): object $27
	db $88, $11, $06  ; 8 across from (1, 1): object $06
	db $c3, $26, $06  ; 3 down from (6, 2): object $06
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4B of indoor group B: 8 objects, room template 0 and floor object $0D; a warp (type 2) to map $07 room $67 at x 136, y 128. Format: see IndoorBRoomPointers.
IndoorBRoom4B::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $04, $fa  ; (4, 0): object $FA
	db $30, $ee  ; (0, 3): object $EE
	db $c4, $23, $20  ; 4 down from (3, 2): object $20
	db $c4, $26, $20  ; 4 down from (6, 2): object $20
	db $35, $20  ; (5, 3): object $20
	db $44, $20  ; (4, 4): object $20
	db $45, $cb  ; (5, 4): object $CB
	db $e2, $07, $67, $88, $80  ; warp type 2 to map $07 room $67, x 136 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4C of indoor group B: 20 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom4C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $71, $f5  ; (1, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $c2, $00, $03  ; 2 down from (0, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $c2, $09, $03  ; 2 down from (9, 0): object $03
	db $11, $23  ; (1, 1): object $23
	db $18, $24  ; (8, 1): object $24
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $82, $14, $ae  ; 2 across from (4, 1): object $AE
	db $31, $af  ; (1, 3): object $AF
	db $38, $af  ; (8, 3): object $AF
	db $41, $b0  ; (1, 4): object $B0
	db $48, $b0  ; (8, 4): object $B0
	db $82, $54, $af  ; 2 across from (4, 5): object $AF
	db $82, $64, $b0  ; 2 across from (4, 6): object $B0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4D of indoor group B: 25 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom4D::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $39, $f7  ; (9, 3): object $F7
	db $71, $f5  ; (1, 7): object $F5
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $82, $11, $af  ; 2 across from (1, 1): object $AF
	db $17, $a7  ; (7, 1): object $A7
	db $c4, $21, $01  ; 4 down from (1, 2): object $01
	db $22, $01  ; (2, 2): object $01
	db $84, $23, $a6  ; 4 across from (3, 2): object $A6
	db $32, $b0  ; (2, 3): object $B0
	db $83, $33, $ae  ; 3 across from (3, 3): object $AE
	db $42, $ac  ; (2, 4): object $AC
	db $84, $43, $a6  ; 4 across from (3, 4): object $A6
	db $57, $a7  ; (7, 5): object $A7
	db $61, $b0  ; (1, 6): object $B0
	db $63, $2c  ; (3, 6): object $2C
	db $85, $64, $22  ; 5 across from (4, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $70, $23  ; (0, 7): object $23
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $73, $24  ; (3, 7): object $24
	db $86, $74, $03  ; 6 across from (4, 7): object $03
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4E of indoor group B: 10 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom4E::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $30, $f2  ; (0, 3): object $F2
	db $74, $f5  ; (4, 7): object $F5
	db $22, $0f  ; (2, 2): object $0F
	db $c4, $24, $0f  ; 4 down from (4, 2): object $0F
	db $c4, $25, $0f  ; 4 down from (5, 2): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $84, $43, $0f  ; 4 across from (3, 4): object $0F
	db $52, $0f  ; (2, 5): object $0F
	db $57, $0f  ; (7, 5): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4F of indoor group B: 17 objects, room template 2 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom4F::
	db $06, $2d  ; animated tiles $06, template 2, floor $0D
	db $07, $3f  ; (7, 0): object $3F
	db $49, $f7  ; (9, 4): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $c3, $16, $a7  ; 3 down from (6, 1): object $A7
	db $18, $a6  ; (8, 1): object $A6
	db $82, $28, $a6  ; 2 across from (8, 2): object $A6
	db $89, $41, $a6  ; 9 across from (1, 4): object $A6
	db $82, $47, $a7  ; 2 across from (7, 4): object $A7
	db $89, $51, $06  ; 9 across from (1, 5): object $06
	db $82, $61, $06  ; 2 across from (1, 6): object $06
	db $70, $23  ; (0, 7): object $23
	db $71, $06  ; (1, 7): object $06
	db $72, $2c  ; (2, 7): object $2C
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $23, $a0  ; (3, 2): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $50 of indoor group B: 37 objects, room template 9 and floor object $06; a warp (type 2) to map $07 room $61 at x 136, y 128. Format: see IndoorBRoomPointers.
IndoorBRoom50::
	db $06, $96  ; animated tiles $06, template 9, floor $06
	db $03, $f4  ; (3, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $73, $f5  ; (3, 7): object $F5
	db $00, $29  ; (0, 0): object $29
	db $82, $01, $0d  ; 2 across from (1, 0): object $0D
	db $82, $03, $0d  ; 2 across from (3, 0): object $0D
	db $03, $a6  ; (3, 0): object $A6
	db $05, $a6  ; (5, 0): object $A6
	db $06, $0d  ; (6, 0): object $0D
	db $07, $a6  ; (7, 0): object $A6
	db $c2, $08, $0d  ; 2 down from (8, 0): object $0D
	db $09, $2a  ; (9, 0): object $2A
	db $82, $10, $0d  ; 2 across from (0, 1): object $0D
	db $14, $a7  ; (4, 1): object $A7
	db $16, $a7  ; (6, 1): object $A7
	db $19, $a6  ; (9, 1): object $A6
	db $82, $20, $a6  ; 2 across from (0, 2): object $A6
	db $28, $a7  ; (8, 2): object $A7
	db $29, $0d  ; (9, 2): object $0D
	db $30, $0d  ; (0, 3): object $0D
	db $39, $a6  ; (9, 3): object $A6
	db $82, $40, $a6  ; 2 across from (0, 4): object $A6
	db $49, $0d  ; (9, 4): object $0D
	db $56, $2c  ; (6, 5): object $2C
	db $57, $98  ; (7, 5): object $98
	db $82, $58, $22  ; 2 across from (8, 5): object $22
	db $85, $60, $0d  ; 5 across from (0, 6): object $0D
	db $66, $24  ; (6, 6): object $24
	db $68, $0f  ; (8, 6): object $0F
	db $c2, $69, $c0  ; 2 down from (9, 6): object $C0
	db $86, $70, $22  ; 6 across from (0, 7): object $22
	db $76, $28  ; (6, 7): object $28
	db $82, $77, $0f  ; 2 across from (7, 7): object $0F
	db $51, $0d  ; (1, 5): object $0D
	db $53, $0d  ; (3, 5): object $0D
	db $67, $cb  ; (7, 6): object $CB
	db $e2, $07, $61, $88, $80  ; warp type 2 to map $07 room $61, x 136 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $51 of indoor group B: 30 objects, room template 7 and floor object $0D; a warp (type 2) to map $07 room $63 at x 136, y 128. Format: see IndoorBRoomPointers.
IndoorBRoom51::
	db $06, $7d  ; animated tiles $06, template 7, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $49, $4a  ; (9, 4): object $4A
	db $60, $f6  ; (0, 6): object $F6
	db $73, $f5  ; (3, 7): object $F5
	db $00, $26  ; (0, 0): object $26
	db $83, $01, $0d  ; 3 across from (1, 0): object $0D
	db $04, $25  ; (4, 0): object $25
	db $10, $2a  ; (0, 1): object $2A
	db $11, $98  ; (1, 1): object $98
	db $12, $26  ; (2, 1): object $26
	db $14, $23  ; (4, 1): object $23
	db $22, $2a  ; (2, 2): object $2A
	db $23, $21  ; (3, 2): object $21
	db $24, $29  ; (4, 2): object $29
	db $82, $30, $a6  ; 2 across from (0, 3): object $A6
	db $86, $50, $22  ; 6 across from (0, 5): object $22
	db $56, $98  ; (6, 5): object $98
	db $57, $2b  ; (7, 5): object $2B
	db $82, $60, $c0  ; 2 across from (0, 6): object $C0
	db $85, $62, $0f  ; 5 across from (2, 6): object $0F
	db $64, $a6  ; (4, 6): object $A6
	db $67, $23  ; (7, 6): object $23
	db $82, $70, $c0  ; 2 across from (0, 7): object $C0
	db $72, $0f  ; (2, 7): object $0F
	db $82, $73, $a6  ; 2 across from (3, 7): object $A6
	db $82, $75, $0f  ; 2 across from (5, 7): object $0F
	db $77, $27  ; (7, 7): object $27
	db $78, $22  ; (8, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $18, $cb  ; (8, 1): object $CB
	db $e2, $07, $63, $88, $80  ; warp type 2 to map $07 room $63, x 136 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $52 of indoor group B: 17 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom52::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $40, $41  ; (0, 4): object $41
	db $74, $40  ; (4, 7): object $40
	db $08, $26  ; (8, 0): object $26
	db $c8, $09, $03  ; 8 down from (9, 0): object $03
	db $c6, $18, $24  ; 6 down from (8, 1): object $24
	db $78, $28  ; (8, 7): object $28
	db $22, $2c  ; (2, 2): object $2C
	db $83, $23, $22  ; 3 across from (3, 2): object $22
	db $26, $2b  ; (6, 2): object $2B
	db $c2, $32, $24  ; 2 down from (2, 3): object $24
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $c2, $36, $23  ; 2 down from (6, 3): object $23
	db $83, $43, $0f  ; 3 across from (3, 4): object $0F
	db $52, $2a  ; (2, 5): object $2A
	db $83, $53, $21  ; 3 across from (3, 5): object $21
	db $56, $29  ; (6, 5): object $29
	db $54, $98  ; (4, 5): object $98
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $53 of indoor group B: 20 objects, room template 0 and floor object $0D; a warp (type 2) to map $07 room $69 at x 136, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom53::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $77, $f1  ; (7, 7): object $F1
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $85, $13, $af  ; 5 across from (3, 1): object $AF
	db $13, $a6  ; (3, 1): object $A6
	db $82, $23, $b0  ; 2 across from (3, 2): object $B0
	db $83, $25, $01  ; 3 across from (5, 2): object $01
	db $31, $af  ; (1, 3): object $AF
	db $83, $35, $01  ; 3 across from (5, 3): object $01
	db $c2, $41, $01  ; 2 down from (1, 4): object $01
	db $42, $af  ; (2, 4): object $AF
	db $83, $45, $b0  ; 3 across from (5, 4): object $B0
	db $52, $01  ; (2, 5): object $01
	db $53, $af  ; (3, 5): object $AF
	db $82, $65, $ae  ; 2 across from (5, 6): object $AE
	db $23, $0d  ; (3, 2): object $0D
	db $82, $51, $b0  ; 2 across from (1, 5): object $B0
	db $53, $ae  ; (3, 5): object $AE
	db $48, $8e  ; (8, 4): object $8E
	db $11, $be  ; (1, 1): object $BE
	db $e2, $07, $69, $88, $10  ; warp type 2 to map $07 room $69, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $54 of indoor group B: 7 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom54::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $01, $f0  ; (1, 0): object $F0
	db $39, $f3  ; (9, 3): object $F3
	db $71, $f1  ; (1, 7): object $F1
	db $20, $c9  ; (0, 2): object $C9
	db $29, $ca  ; (9, 2): object $CA
	db $50, $c9  ; (0, 5): object $C9
	db $59, $ca  ; (9, 5): object $CA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $55 of indoor group B: 17 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom55::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $00, $23  ; (0, 0): object $23
	db $82, $01, $0d  ; 2 across from (1, 0): object $0D
	db $03, $2a  ; (3, 0): object $2A
	db $13, $af  ; (3, 1): object $AF
	db $15, $ae  ; (5, 1): object $AE
	db $17, $ae  ; (7, 1): object $AE
	db $c3, $23, $01  ; 3 down from (3, 2): object $01
	db $26, $a0  ; (6, 2): object $A0
	db $35, $ae  ; (5, 3): object $AE
	db $37, $ae  ; (7, 3): object $AE
	db $82, $51, $ae  ; 2 across from (1, 5): object $AE
	db $53, $b0  ; (3, 5): object $B0
	db $56, $ae  ; (6, 5): object $AE
	db $64, $ae  ; (4, 6): object $AE
	db $68, $ae  ; (8, 6): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $56 of indoor group B: 11 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom56::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $39, $f7  ; (9, 3): object $F7
	db $09, $21  ; (9, 0): object $21
	db $82, $18, $06  ; 2 across from (8, 1): object $06
	db $24, $a6  ; (4, 2): object $A6
	db $29, $2c  ; (9, 2): object $2C
	db $46, $a6  ; (6, 4): object $A6
	db $42, $a6  ; (2, 4): object $A6
	db $82, $43, $06  ; 2 across from (3, 4): object $06
	db $53, $06  ; (3, 5): object $06
	db $88, $61, $06  ; 8 across from (1, 6): object $06
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $57 of indoor group B: 19 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom57::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f2  ; (0, 3): object $F2
	db $39, $f3  ; (9, 3): object $F3
	db $74, $f5  ; (4, 7): object $F5
	db $00, $29  ; (0, 0): object $29
	db $01, $06  ; (1, 0): object $06
	db $02, $2a  ; (2, 0): object $2A
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $89, $10, $06  ; 9 across from (0, 1): object $06
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $20, $2b  ; (0, 2): object $2B
	db $23, $06  ; (3, 2): object $06
	db $26, $06  ; (6, 2): object $06
	db $84, $33, $06  ; 4 across from (3, 3): object $06
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $58 of indoor group B: 23 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom58::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f3  ; (9, 3): object $F3
	db $74, $f1  ; (4, 7): object $F1
	db $c2, $11, $06  ; 2 down from (1, 1): object $06
	db $22, $06  ; (2, 2): object $06
	db $06, $26  ; (6, 0): object $26
	db $82, $07, $0f  ; 2 across from (7, 0): object $0F
	db $09, $c0  ; (9, 0): object $C0
	db $c2, $14, $20  ; 2 down from (4, 1): object $20
	db $c3, $15, $20  ; 3 down from (5, 1): object $20
	db $16, $2a  ; (6, 1): object $2A
	db $82, $17, $21  ; 2 across from (7, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $26, $20  ; (6, 2): object $20
	db $27, $06  ; (7, 2): object $06
	db $82, $32, $20  ; 2 across from (2, 3): object $20
	db $c2, $37, $20  ; 2 down from (7, 3): object $20
	db $83, $42, $20  ; 3 across from (2, 4): object $20
	db $83, $54, $20  ; 3 across from (4, 5): object $20
	db $82, $61, $20  ; 2 across from (1, 6): object $20
	db $68, $20  ; (8, 6): object $20
	db $12, $8e  ; (2, 1): object $8E
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $59 of indoor group B: 30 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom59::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $82, $00, $c0  ; 2 across from (0, 0): object $C0
	db $85, $02, $0f  ; 5 across from (2, 0): object $0F
	db $82, $03, $a6  ; 2 across from (3, 0): object $A6
	db $83, $07, $c0  ; 3 across from (7, 0): object $C0
	db $10, $25  ; (0, 1): object $25
	db $86, $11, $21  ; 6 across from (1, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $82, $18, $c0  ; 2 across from (8, 1): object $C0
	db $c5, $26, $06  ; 5 down from (6, 2): object $06
	db $27, $2a  ; (7, 2): object $2A
	db $28, $21  ; (8, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $83, $43, $0f  ; 3 across from (3, 4): object $0F
	db $44, $a0  ; (4, 4): object $A0
	db $83, $53, $0f  ; 3 across from (3, 5): object $0F
	db $57, $2c  ; (7, 5): object $2C
	db $58, $22  ; (8, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $82, $61, $06  ; 2 across from (1, 6): object $06
	db $67, $24  ; (7, 6): object $24
	db $82, $68, $c0  ; 2 across from (8, 6): object $C0
	db $77, $28  ; (7, 7): object $28
	db $82, $78, $c0  ; 2 across from (8, 7): object $C0
	db $29, $21  ; (9, 2): object $21
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $59, $22  ; (9, 5): object $22
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5A of indoor group B: 25 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom5A::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $04, $47  ; (4, 0): object $47
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $83, $11, $af  ; 3 across from (1, 1): object $AF
	db $21, $b0  ; (1, 2): object $B0
	db $82, $22, $01  ; 2 across from (2, 2): object $01
	db $24, $af  ; (4, 2): object $AF
	db $25, $a6  ; (5, 2): object $A6
	db $32, $b0  ; (2, 3): object $B0
	db $82, $33, $01  ; 2 across from (3, 3): object $01
	db $35, $af  ; (5, 3): object $AF
	db $36, $a6  ; (6, 3): object $A6
	db $43, $b0  ; (3, 4): object $B0
	db $82, $44, $01  ; 2 across from (4, 4): object $01
	db $46, $af  ; (6, 4): object $AF
	db $54, $b0  ; (4, 5): object $B0
	db $82, $55, $01  ; 2 across from (5, 5): object $01
	db $57, $af  ; (7, 5): object $AF
	db $83, $65, $b0  ; 3 across from (5, 6): object $B0
	db $68, $ae  ; (8, 6): object $AE
	db $18, $c0  ; (8, 1): object $C0
	db $61, $c0  ; (1, 6): object $C0
	db $20, $29  ; (0, 2): object $29
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5B of indoor group B: 3 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom5B::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f0  ; (7, 0): object $F0
	db $30, $f2  ; (0, 3): object $F2
	db $77, $f1  ; (7, 7): object $F1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5C of indoor group B: 21 objects, room template 0 and floor object $0D; a warp (type 1) to map $07 room $5D at x 80, y 124. Format: see IndoorBRoomPointers.
IndoorBRoom5C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $03, $c7  ; (3, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $08, $26  ; (8, 0): object $26
	db $c8, $09, $03  ; 8 down from (9, 0): object $03
	db $c6, $18, $24  ; 6 down from (8, 1): object $24
	db $22, $a6  ; (2, 2): object $A6
	db $83, $23, $12  ; 3 across from (3, 2): object $12
	db $26, $11  ; (6, 2): object $11
	db $c2, $32, $11  ; 2 down from (2, 3): object $11
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $34, $a0  ; (4, 3): object $A0
	db $36, $16  ; (6, 3): object $16
	db $83, $43, $0f  ; 3 across from (3, 4): object $0F
	db $46, $10  ; (6, 4): object $10
	db $52, $12  ; (2, 5): object $12
	db $53, $15  ; (3, 5): object $15
	db $82, $54, $13  ; 2 across from (4, 5): object $13
	db $78, $28  ; (8, 7): object $28
	db $73, $c8  ; (3, 7): object $C8
	db $75, $c8  ; (5, 7): object $C8
	db $e1, $07, $5d, $50, $7c  ; warp type 1 to map $07 room $5D, x 80 y 124
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5D of indoor group B: 28 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $10 at x 88, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom5D::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $01, $06  ; (1, 0): object $06
	db $01, $f4  ; (1, 0): object $F4
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $83, $00, $03  ; 3 across from (0, 0): object $03
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $83, $10, $03  ; 3 across from (0, 1): object $03
	db $83, $17, $03  ; 3 across from (7, 1): object $03
	db $82, $20, $03  ; 2 across from (0, 2): object $03
	db $82, $28, $03  ; 2 across from (8, 2): object $03
	db $c5, $30, $03  ; 5 down from (0, 3): object $03
	db $c5, $39, $03  ; 5 down from (9, 3): object $03
	db $c2, $03, $23  ; 2 down from (3, 0): object $23
	db $c2, $06, $24  ; 2 down from (6, 0): object $24
	db $22, $25  ; (2, 2): object $25
	db $23, $29  ; (3, 2): object $29
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $31, $25  ; (1, 3): object $25
	db $32, $29  ; (2, 3): object $29
	db $33, $c0  ; (3, 3): object $C0
	db $36, $c0  ; (6, 3): object $C0
	db $37, $2a  ; (7, 3): object $2A
	db $38, $26  ; (8, 3): object $26
	db $c3, $41, $23  ; 3 down from (1, 4): object $23
	db $c3, $48, $24  ; 3 down from (8, 4): object $24
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $10, $58, $10  ; warp type 0 to map $00 room $10, x 88 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5E of indoor group B: 12 objects, room template 0 and floor object $0D; a warp (type 2) to map $07 room $68 at x 24, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom5E::
	db $06, $0d  ; animated tiles $06, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $21, $20  ; (1, 2): object $20
	db $28, $20  ; (8, 2): object $20
	db $41, $20  ; (1, 4): object $20
	db $48, $20  ; (8, 4): object $20
	db $34, $2c  ; (4, 3): object $2C
	db $35, $2b  ; (5, 3): object $2B
	db $44, $2a  ; (4, 4): object $2A
	db $45, $29  ; (5, 4): object $29
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $18, $bf  ; (8, 1): object $BF
	db $e2, $07, $68, $18, $10  ; warp type 2 to map $07 room $68, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5F of indoor group B: 35 objects, room template 0 and floor object $0D; a warp (type 2) to map $07 room $6B at x 136, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom5F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f0  ; (7, 0): object $F0
	db $04, $c7  ; (4, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $83, $00, $03  ; 3 across from (0, 0): object $03
	db $03, $25  ; (3, 0): object $25
	db $c3, $10, $03  ; 3 down from (0, 1): object $03
	db $c3, $11, $03  ; 3 down from (1, 1): object $03
	db $12, $25  ; (2, 1): object $25
	db $13, $29  ; (3, 1): object $29
	db $14, $af  ; (4, 1): object $AF
	db $16, $20  ; (6, 1): object $20
	db $c2, $22, $23  ; 2 down from (2, 2): object $23
	db $24, $b0  ; (4, 2): object $B0
	db $82, $26, $ae  ; 2 across from (6, 2): object $AE
	db $82, $34, $20  ; 2 across from (4, 3): object $20
	db $40, $25  ; (0, 4): object $25
	db $41, $21  ; (1, 4): object $21
	db $42, $29  ; (2, 4): object $29
	db $44, $af  ; (4, 4): object $AF
	db $46, $2c  ; (6, 4): object $2C
	db $82, $47, $22  ; 2 across from (7, 4): object $22
	db $49, $28  ; (9, 4): object $28
	db $53, $20  ; (3, 5): object $20
	db $54, $b0  ; (4, 5): object $B0
	db $56, $24  ; (6, 5): object $24
	db $83, $57, $03  ; 3 across from (7, 5): object $03
	db $63, $2c  ; (3, 6): object $2C
	db $56, $24  ; (6, 5): object $24
	db $82, $64, $22  ; 2 across from (4, 6): object $22
	db $66, $28  ; (6, 6): object $28
	db $83, $67, $03  ; 3 across from (7, 6): object $03
	db $73, $28  ; (3, 7): object $28
	db $86, $74, $03  ; 6 across from (4, 7): object $03
	db $28, $a0  ; (8, 2): object $A0
	db $61, $be  ; (1, 6): object $BE
	db $e2, $07, $6b, $88, $10  ; warp type 2 to map $07 room $6B, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $60 of indoor group B: 19 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $39 at x 72, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom60::
	db $0e, $94  ; animated tiles $0E, template 9, floor $04
	db $82, $00, $54  ; 2 across from (0, 0): object $54
	db $87, $02, $5c  ; 7 across from (2, 0): object $5C
	db $09, $54  ; (9, 0): object $54
	db $c2, $10, $54  ; 2 down from (0, 1): object $54
	db $11, $57  ; (1, 1): object $57
	db $c3, $19, $51  ; 3 down from (9, 1): object $51
	db $21, $5e  ; (1, 2): object $5E
	db $87, $22, $8a  ; 7 across from (2, 2): object $8A
	db $c5, $30, $57  ; 5 down from (0, 3): object $57
	db $41, $62  ; (1, 4): object $62
	db $42, $5b  ; (2, 4): object $5B
	db $84, $43, $8a  ; 4 across from (3, 4): object $8A
	db $49, $5c  ; (9, 4): object $5C
	db $c3, $51, $63  ; 3 down from (1, 5): object $63
	db $52, $57  ; (2, 5): object $57
	db $84, $53, $8a  ; 4 across from (3, 5): object $8A
	db $c2, $62, $54  ; 2 down from (2, 6): object $54
	db $87, $63, $5b  ; 7 across from (3, 6): object $5B
	db $87, $73, $54  ; 7 across from (3, 7): object $54
	db $e1, $07, $39, $48, $20  ; warp type 1 to map $07 room $39, x 72 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $61 of indoor group B: 19 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $50 at x 120, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom61::
	db $0e, $94  ; animated tiles $0E, template 9, floor $04
	db $8a, $00, $54  ; 10 across from (0, 0): object $54
	db $8a, $10, $54  ; 10 across from (0, 1): object $54
	db $8a, $20, $54  ; 10 across from (0, 2): object $54
	db $8a, $30, $54  ; 10 across from (0, 3): object $54
	db $84, $22, $5c  ; 4 across from (2, 2): object $5C
	db $31, $5e  ; (1, 3): object $5E
	db $84, $32, $8a  ; 4 across from (2, 3): object $8A
	db $82, $36, $5c  ; 2 across from (6, 3): object $5C
	db $40, $5e  ; (0, 4): object $5E
	db $82, $41, $8a  ; 2 across from (1, 4): object $8A
	db $46, $8a  ; (6, 4): object $8A
	db $48, $5a  ; (8, 4): object $5A
	db $49, $54  ; (9, 4): object $54
	db $85, $52, $8a  ; 5 across from (2, 5): object $8A
	db $c3, $59, $51  ; 3 down from (9, 5): object $51
	db $88, $60, $5b  ; 8 across from (0, 6): object $5B
	db $88, $70, $54  ; 8 across from (0, 7): object $54
	db $68, $62  ; (8, 6): object $62
	db $78, $63  ; (8, 7): object $63
	db $e1, $07, $50, $78, $70  ; warp type 1 to map $07 room $50, x 120 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $62 of indoor group B: 29 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $3B at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom62::
	db $0e, $94  ; animated tiles $0E, template 9, floor $04
	db $00, $54  ; (0, 0): object $54
	db $86, $01, $5c  ; 6 across from (1, 0): object $5C
	db $83, $07, $54  ; 3 across from (7, 0): object $54
	db $c7, $10, $57  ; 7 down from (0, 1): object $57
	db $82, $15, $8a  ; 2 across from (5, 1): object $8A
	db $83, $17, $5c  ; 3 across from (7, 1): object $5C
	db $21, $62  ; (1, 2): object $62
	db $22, $5b  ; (2, 2): object $5B
	db $83, $25, $8a  ; 3 across from (5, 2): object $8A
	db $c5, $31, $63  ; 5 down from (1, 3): object $63
	db $c5, $32, $57  ; 5 down from (2, 3): object $57
	db $c4, $33, $8a  ; 4 down from (3, 3): object $8A
	db $c2, $36, $8a  ; 2 down from (6, 3): object $8A
	db $c3, $44, $8a  ; 3 down from (4, 4): object $8A
	db $48, $64  ; (8, 4): object $64
	db $49, $5b  ; (9, 4): object $5B
	db $c2, $55, $8a  ; 2 down from (5, 5): object $8A
	db $57, $8a  ; (7, 5): object $8A
	db $58, $65  ; (8, 5): object $65
	db $c2, $59, $51  ; 2 down from (9, 5): object $51
	db $66, $8a  ; (6, 6): object $8A
	db $86, $73, $5b  ; 6 across from (3, 7): object $5B
	db $79, $54  ; (9, 7): object $54
	db $56, $8a  ; (6, 5): object $8A
	db $67, $8a  ; (7, 6): object $8A
	db $06, $54  ; (6, 0): object $54
	db $16, $51  ; (6, 1): object $51
	db $17, $54  ; (7, 1): object $54
	db $82, $26, $5c  ; 2 across from (6, 2): object $5C
	db $e1, $07, $3b, $58, $40  ; warp type 1 to map $07 room $3B, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $63 of indoor group B: 31 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $51 at x 136, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom63::
	db $0e, $94  ; animated tiles $0E, template 9, floor $04
	db $82, $00, $54  ; 2 across from (0, 0): object $54
	db $86, $02, $5c  ; 6 across from (2, 0): object $5C
	db $83, $07, $54  ; 3 across from (7, 0): object $54
	db $10, $5c  ; (0, 1): object $5C
	db $11, $54  ; (1, 1): object $54
	db $85, $12, $8a  ; 5 across from (2, 1): object $8A
	db $82, $17, $54  ; 2 across from (7, 1): object $54
	db $19, $54  ; (9, 1): object $54
	db $82, $21, $5c  ; 2 across from (1, 2): object $5C
	db $82, $23, $8a  ; 2 across from (3, 2): object $8A
	db $25, $5b  ; (5, 2): object $5B
	db $82, $26, $8a  ; 2 across from (6, 2): object $8A
	db $c6, $29, $51  ; 6 down from (9, 2): object $51
	db $85, $32, $8a  ; 5 across from (2, 3): object $8A
	db $35, $5c  ; (5, 3): object $5C
	db $37, $5b  ; (7, 3): object $5B
	db $38, $64  ; (8, 3): object $64
	db $83, $40, $5b  ; 3 across from (0, 4): object $5B
	db $83, $44, $8a  ; 3 across from (4, 4): object $8A
	db $47, $57  ; (7, 4): object $57
	db $c2, $48, $65  ; 2 down from (8, 4): object $65
	db $82, $50, $54  ; 2 across from (0, 5): object $54
	db $c2, $52, $57  ; 2 down from (2, 5): object $57
	db $55, $8a  ; (5, 5): object $8A
	db $82, $56, $5c  ; 2 across from (6, 5): object $5C
	db $82, $60, $54  ; 2 across from (0, 6): object $54
	db $82, $63, $5b  ; 2 across from (3, 6): object $5B
	db $67, $8a  ; (7, 6): object $8A
	db $85, $70, $54  ; 5 across from (0, 7): object $54
	db $83, $75, $5b  ; 3 across from (5, 7): object $5B
	db $78, $62  ; (8, 7): object $62
	db $e1, $07, $51, $88, $20  ; warp type 1 to map $07 room $51, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $64 of indoor group B: 17 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $43 at x 72, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom64::
	db $0f, $94  ; animated tiles $0F, template 9, floor $04
	db $02, $5c  ; (2, 0): object $5C
	db $87, $03, $54  ; 7 across from (3, 0): object $54
	db $c3, $01, $63  ; 3 down from (1, 0): object $63
	db $c5, $00, $57  ; 5 down from (0, 0): object $57
	db $09, $5c  ; (9, 0): object $5C
	db $31, $5b  ; (1, 3): object $5B
	db $35, $61  ; (5, 3): object $61
	db $39, $59  ; (9, 3): object $59
	db $c4, $40, $54  ; 4 down from (0, 4): object $54
	db $c4, $41, $57  ; 4 down from (1, 4): object $57
	db $c4, $49, $51  ; 4 down from (9, 4): object $51
	db $87, $62, $85  ; 7 across from (2, 6): object $85
	db $87, $72, $ad  ; 7 across from (2, 7): object $AD
	db $86, $13, $71  ; 6 across from (3, 1): object $71
	db $c2, $15, $4d  ; 2 down from (5, 1): object $4D
	db $17, $70  ; (7, 1): object $70
	db $27, $71  ; (7, 2): object $71
	db $e1, $07, $43, $48, $70  ; warp type 1 to map $07 room $43, x 72 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $65 of indoor group B: 19 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $37 at x 40, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom65::
	db $0f, $94  ; animated tiles $0F, template 9, floor $04
	db $8a, $00, $54  ; 10 across from (0, 0): object $54
	db $82, $00, $5c  ; 2 across from (0, 0): object $5C
	db $07, $5c  ; (7, 0): object $5C
	db $c3, $08, $62  ; 3 down from (8, 0): object $62
	db $c3, $09, $51  ; 3 down from (9, 0): object $51
	db $30, $5d  ; (0, 3): object $5D
	db $38, $59  ; (8, 3): object $59
	db $38, $5b  ; (8, 3): object $5B
	db $39, $54  ; (9, 3): object $54
	db $c4, $40, $57  ; 4 down from (0, 4): object $57
	db $c4, $48, $51  ; 4 down from (8, 4): object $51
	db $c4, $49, $54  ; 4 down from (9, 4): object $54
	db $87, $61, $85  ; 7 across from (1, 6): object $85
	db $87, $71, $ad  ; 7 across from (1, 7): object $AD
	db $85, $12, $71  ; 5 across from (2, 1): object $71
	db $13, $70  ; (3, 1): object $70
	db $15, $70  ; (5, 1): object $70
	db $23, $71  ; (3, 2): object $71
	db $25, $71  ; (5, 2): object $71
	db $e1, $07, $37, $28, $50  ; warp type 1 to map $07 room $37, x 40 y 80
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $66 of indoor group B: 25 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $31 at x 120, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom66::
	db $0f, $94  ; animated tiles $0F, template 9, floor $04
	db $86, $00, $54  ; 6 across from (0, 0): object $54
	db $84, $06, $5c  ; 4 across from (6, 0): object $5C
	db $83, $10, $54  ; 3 across from (0, 1): object $54
	db $13, $70  ; (3, 1): object $70
	db $82, $14, $71  ; 2 across from (4, 1): object $71
	db $c6, $20, $54  ; 6 down from (0, 2): object $54
	db $21, $57  ; (1, 2): object $57
	db $82, $22, $71  ; 2 across from (2, 2): object $71
	db $27, $59  ; (7, 2): object $59
	db $82, $28, $5b  ; 2 across from (8, 2): object $5B
	db $31, $54  ; (1, 3): object $54
	db $32, $5b  ; (2, 3): object $5B
	db $35, $5b  ; (5, 3): object $5B
	db $37, $5a  ; (7, 3): object $5A
	db $82, $38, $5c  ; 2 across from (8, 3): object $5C
	db $41, $71  ; (1, 4): object $71
	db $84, $42, $5c  ; 4 across from (2, 4): object $5C
	db $61, $64  ; (1, 6): object $64
	db $62, $5b  ; (2, 6): object $5B
	db $68, $59  ; (8, 6): object $59
	db $69, $5b  ; (9, 6): object $5B
	db $71, $65  ; (1, 7): object $65
	db $72, $54  ; (2, 7): object $54
	db $85, $73, $5b  ; 5 across from (3, 7): object $5B
	db $82, $78, $54  ; 2 across from (8, 7): object $54
	db $e1, $07, $31, $78, $20  ; warp type 1 to map $07 room $31, x 120 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $67 of indoor group B: 28 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $4B at x 88, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom67::
	db $0f, $94  ; animated tiles $0F, template 9, floor $04
	db $8a, $00, $5c  ; 10 across from (0, 0): object $5C
	db $83, $03, $54  ; 3 across from (3, 0): object $54
	db $09, $54  ; (9, 0): object $54
	db $13, $71  ; (3, 1): object $71
	db $14, $70  ; (4, 1): object $70
	db $15, $71  ; (5, 1): object $71
	db $18, $8f  ; (8, 1): object $8F
	db $19, $54  ; (9, 1): object $54
	db $20, $5b  ; (0, 2): object $5B
	db $82, $21, $64  ; 2 across from (1, 2): object $64
	db $24, $71  ; (4, 2): object $71
	db $28, $64  ; (8, 2): object $64
	db $c6, $29, $51  ; 6 down from (9, 2): object $51
	db $30, $5c  ; (0, 3): object $5C
	db $31, $d9  ; (1, 3): object $D9
	db $32, $65  ; (2, 3): object $65
	db $c5, $38, $65  ; 5 down from (8, 3): object $65
	db $52, $5b  ; (2, 5): object $5B
	db $82, $60, $5b  ; 2 across from (0, 6): object $5B
	db $c2, $62, $57  ; 2 down from (2, 6): object $57
	db $84, $63, $85  ; 4 across from (3, 6): object $85
	db $47, $5b  ; (7, 4): object $5B
	db $82, $70, $54  ; 2 across from (0, 7): object $54
	db $84, $73, $ad  ; 4 across from (3, 7): object $AD
	db $c3, $57, $57  ; 3 down from (7, 5): object $57
	db $28, $64  ; (8, 2): object $64
	db $48, $64  ; (8, 4): object $64
	db $68, $64  ; (8, 6): object $64
	db $e1, $07, $4b, $58, $50  ; warp type 1 to map $07 room $4B, x 88 y 80
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $68 of indoor group B: 23 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $5E at x 136, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom68::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $88, $02, $54  ; 8 across from (2, 0): object $54
	db $02, $51  ; (2, 0): object $51
	db $09, $5c  ; (9, 0): object $5C
	db $c7, $01, $63  ; 7 down from (1, 0): object $63
	db $87, $12, $71  ; 7 across from (2, 1): object $71
	db $13, $70  ; (3, 1): object $70
	db $15, $70  ; (5, 1): object $70
	db $17, $70  ; (7, 1): object $70
	db $23, $71  ; (3, 2): object $71
	db $25, $71  ; (5, 2): object $71
	db $27, $71  ; (7, 2): object $71
	db $36, $59  ; (6, 3): object $59
	db $37, $5d  ; (7, 3): object $5D
	db $39, $5b  ; (9, 3): object $5B
	db $c7, $00, $57  ; 7 down from (0, 0): object $57
	db $82, $46, $5c  ; 2 across from (6, 4): object $5C
	db $c3, $49, $51  ; 3 down from (9, 4): object $51
	db $65, $4c  ; (5, 6): object $4C
	db $68, $4c  ; (8, 6): object $4C
	db $70, $54  ; (0, 7): object $54
	db $87, $71, $5b  ; 7 across from (1, 7): object $5B
	db $75, $54  ; (5, 7): object $54
	db $82, $78, $54  ; 2 across from (8, 7): object $54
	db $e1, $07, $5e, $88, $20  ; warp type 1 to map $07 room $5E, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $69 of indoor group B: 27 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $53 at x 24, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom69::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $54  ; 10 across from (0, 0): object $54
	db $00, $5c  ; (0, 0): object $5C
	db $07, $57  ; (7, 0): object $57
	db $c3, $08, $63  ; 3 down from (8, 0): object $63
	db $13, $5a  ; (3, 1): object $5A
	db $c2, $14, $54  ; 2 down from (4, 1): object $54
	db $83, $15, $5c  ; 3 across from (5, 1): object $5C
	db $17, $5e  ; (7, 1): object $5E
	db $34, $5c  ; (4, 3): object $5C
	db $c3, $09, $51  ; 3 down from (9, 0): object $51
	db $30, $5b  ; (0, 3): object $5B
	db $31, $64  ; (1, 3): object $64
	db $35, $64  ; (5, 3): object $64
	db $83, $36, $5b  ; 3 across from (6, 3): object $5B
	db $39, $54  ; (9, 3): object $54
	db $c3, $40, $57  ; 3 down from (0, 4): object $57
	db $c3, $41, $65  ; 3 down from (1, 4): object $65
	db $82, $46, $5c  ; 2 across from (6, 4): object $5C
	db $82, $48, $54  ; 2 across from (8, 4): object $54
	db $58, $51  ; (8, 5): object $51
	db $59, $54  ; (9, 5): object $54
	db $82, $65, $4c  ; 2 across from (5, 6): object $4C
	db $67, $5b  ; (7, 6): object $5B
	db $82, $68, $54  ; 2 across from (8, 6): object $54
	db $70, $54  ; (0, 7): object $54
	db $84, $71, $5b  ; 4 across from (1, 7): object $5B
	db $85, $75, $54  ; 5 across from (5, 7): object $54
	db $e1, $07, $53, $18, $20  ; warp type 1 to map $07 room $53, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6A of indoor group B: 29 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $48 at x 24, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom6A::
	db $0f, $94  ; animated tiles $0F, template 9, floor $04
	db $02, $5c  ; (2, 0): object $5C
	db $87, $03, $54  ; 7 across from (3, 0): object $54
	db $c4, $01, $63  ; 4 down from (1, 0): object $63
	db $c5, $00, $57  ; 5 down from (0, 0): object $57
	db $41, $5b  ; (1, 4): object $5B
	db $42, $5d  ; (2, 4): object $5D
	db $46, $5b  ; (6, 4): object $5B
	db $c3, $50, $54  ; 3 down from (0, 5): object $54
	db $c3, $51, $54  ; 3 down from (1, 5): object $54
	db $c3, $52, $57  ; 3 down from (2, 5): object $57
	db $54, $5b  ; (4, 5): object $5B
	db $85, $63, $85  ; 5 across from (3, 6): object $85
	db $85, $73, $ad  ; 5 across from (3, 7): object $AD
	db $c3, $56, $54  ; 3 down from (6, 5): object $54
	db $58, $59  ; (8, 5): object $59
	db $59, $5b  ; (9, 5): object $5B
	db $c2, $64, $54  ; 2 down from (4, 6): object $54
	db $c2, $68, $51  ; 2 down from (8, 6): object $51
	db $c2, $69, $54  ; 2 down from (9, 6): object $54
	db $13, $71  ; (3, 1): object $71
	db $14, $70  ; (4, 1): object $70
	db $15, $71  ; (5, 1): object $71
	db $16, $70  ; (6, 1): object $70
	db $17, $71  ; (7, 1): object $71
	db $18, $70  ; (8, 1): object $70
	db $19, $71  ; (9, 1): object $71
	db $24, $71  ; (4, 2): object $71
	db $26, $71  ; (6, 2): object $71
	db $28, $71  ; (8, 2): object $71
	db $e1, $07, $48, $18, $70  ; warp type 1 to map $07 room $48, x 24 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6B of indoor group B: 25 objects, room template 9 and floor object $04; a warp (type 1) to map $07 room $5F at x 24, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom6B::
	db $0f, $94  ; animated tiles $0F, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c5, $08, $63  ; 5 down from (8, 0): object $63
	db $11, $5c  ; (1, 1): object $5C
	db $85, $12, $54  ; 5 across from (2, 1): object $54
	db $17, $5c  ; (7, 1): object $5C
	db $c6, $09, $51  ; 6 down from (9, 0): object $51
	db $22, $5a  ; (2, 2): object $5A
	db $83, $23, $5c  ; 3 across from (3, 2): object $5C
	db $26, $5e  ; (6, 2): object $5E
	db $86, $31, $64  ; 6 across from (1, 3): object $64
	db $46, $65  ; (6, 4): object $65
	db $50, $5b  ; (0, 5): object $5B
	db $51, $5d  ; (1, 5): object $5D
	db $57, $59  ; (7, 5): object $59
	db $58, $5b  ; (8, 5): object $5B
	db $c2, $60, $54  ; 2 down from (0, 6): object $54
	db $c2, $61, $57  ; 2 down from (1, 6): object $57
	db $85, $62, $85  ; 5 across from (2, 6): object $85
	db $85, $72, $ad  ; 5 across from (2, 7): object $AD
	db $c2, $67, $51  ; 2 down from (7, 6): object $51
	db $c2, $68, $54  ; 2 down from (8, 6): object $54
	db $c2, $69, $54  ; 2 down from (9, 6): object $54
	db $00, $5c  ; (0, 0): object $5C
	db $86, $01, $54  ; 6 across from (1, 0): object $54
	db $07, $57  ; (7, 0): object $57
	db $e1, $07, $5f, $18, $70  ; warp type 1 to map $07 room $5F, x 24 y 112
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $6C of indoor group B: 33 objects, room template 0 and floor object $0F. Format: see IndoorBRoomPointers.
IndoorBRoom6C::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $74, $f5  ; (4, 7): object $F5
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $c2, $10, $03  ; 2 down from (0, 1): object $03
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $c2, $19, $03  ; 2 down from (9, 1): object $03
	db $21, $23  ; (1, 2): object $23
	db $28, $24  ; (8, 2): object $24
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $82, $34, $97  ; 2 across from (4, 3): object $97
	db $37, $26  ; (7, 3): object $26
	db $38, $2a  ; (8, 3): object $2A
	db $39, $26  ; (9, 3): object $26
	db $41, $25  ; (1, 4): object $25
	db $42, $29  ; (2, 4): object $29
	db $47, $2a  ; (7, 4): object $2A
	db $48, $26  ; (8, 4): object $26
	db $c2, $51, $23  ; 2 down from (1, 5): object $23
	db $c2, $58, $24  ; 2 down from (8, 5): object $24
	db $70, $23  ; (0, 7): object $23
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $24  ; (9, 7): object $24
	db $53, $ab  ; (3, 5): object $AB
	db $56, $ab  ; (6, 5): object $AB
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $70 of indoor group B: 22 objects, room template 0 and floor object $0F; a warp (type 0) to overworld room $06 at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom70::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0f  ; 2 across from (4, 0): object $0F
	db $06, $2a  ; (6, 0): object $2A
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $00  ; (0, 7): object $00
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $00  ; (9, 7): object $00
	db $00, $ab  ; (0, 0): object $AB
	db $09, $ab  ; (9, 0): object $AB
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $06, $58, $40  ; warp type 0 to map $00 room $06, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $71 of indoor group B: 12 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom71::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $20, $29  ; (0, 2): object $29
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $59, $2c  ; (9, 5): object $2C
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $72 of indoor group B: 24 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom72::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $00  ; (0, 7): object $00
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $00  ; (9, 7): object $00
	db $32, $ac  ; (2, 3): object $AC
	db $37, $ac  ; (7, 3): object $AC
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $73 of indoor group B: 35 objects, room template 3 and floor object $0D; a warp (type 1) to map $08 room $74 at x 72, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom73::
	db $04, $3d  ; animated tiles $04, template 3, floor $0D
	db $11, $25  ; (1, 1): object $25
	db $86, $12, $21  ; 6 across from (2, 1): object $21
	db $18, $26  ; (8, 1): object $26
	db $c5, $21, $23  ; 5 down from (1, 2): object $23
	db $22, $25  ; (2, 2): object $25
	db $84, $23, $21  ; 4 across from (3, 2): object $21
	db $27, $26  ; (7, 2): object $26
	db $c5, $28, $24  ; 5 down from (8, 2): object $24
	db $c3, $32, $23  ; 3 down from (2, 3): object $23
	db $33, $25  ; (3, 3): object $25
	db $82, $34, $21  ; 2 across from (4, 3): object $21
	db $36, $26  ; (6, 3): object $26
	db $c3, $37, $24  ; 3 down from (7, 3): object $24
	db $43, $23  ; (3, 4): object $23
	db $82, $44, $1c  ; 2 across from (4, 4): object $1C
	db $46, $24  ; (6, 4): object $24
	db $53, $27  ; (3, 5): object $27
	db $82, $54, $22  ; 2 across from (4, 5): object $22
	db $56, $28  ; (6, 5): object $28
	db $60, $29  ; (0, 6): object $29
	db $62, $27  ; (2, 6): object $27
	db $63, $2b  ; (3, 6): object $2B
	db $82, $64, $0d  ; 2 across from (4, 6): object $0D
	db $66, $2c  ; (6, 6): object $2C
	db $67, $28  ; (7, 6): object $28
	db $69, $2a  ; (9, 6): object $2A
	db $70, $21  ; (0, 7): object $21
	db $71, $29  ; (1, 7): object $29
	db $72, $ac  ; (2, 7): object $AC
	db $73, $23  ; (3, 7): object $23
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $24  ; (6, 7): object $24
	db $77, $ac  ; (7, 7): object $AC
	db $78, $2a  ; (8, 7): object $2A
	db $79, $21  ; (9, 7): object $21
	db $e1, $08, $74, $48, $70  ; warp type 1 to map $08 room $74, x 72 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $74 of indoor group B: 20 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoom74::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $00  ; (0, 7): object $00
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $00  ; (9, 7): object $00
	db $34, $e7  ; (4, 3): object $E7
	db $35, $e8  ; (5, 3): object $E8
	db $44, $e9  ; (4, 4): object $E9
	db $45, $ea  ; (5, 4): object $EA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $75 of indoor group B: 32 objects, room template 0 and floor object $0F; a warp (type 1) to map $08 room $71 at x 72, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom75::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0f  ; 2 across from (4, 0): object $0F
	db $06, $2a  ; (6, 0): object $2A
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $00  ; (0, 7): object $00
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $00  ; (9, 7): object $00
	db $86, $12, $1c  ; 6 across from (2, 1): object $1C
	db $88, $21, $1c  ; 8 across from (1, 2): object $1C
	db $88, $31, $1c  ; 8 across from (1, 3): object $1C
	db $88, $41, $1c  ; 8 across from (1, 4): object $1C
	db $88, $51, $1c  ; 8 across from (1, 5): object $1C
	db $86, $62, $1c  ; 6 across from (2, 6): object $1C
	db $82, $54, $1c  ; 2 across from (4, 5): object $1C
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
	db $32, $ab  ; (2, 3): object $AB
	db $37, $ab  ; (7, 3): object $AB
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0f  ; 2 across from (4, 7): object $0F
	db $76, $2c  ; (6, 7): object $2C
	db $e1, $08, $71, $48, $40  ; warp type 1 to map $08 room $71, x 72 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $77 of indoor group B: 45 objects, room template 9 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom77::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $00, $25  ; (0, 0): object $25
	db $88, $01, $21  ; 8 across from (1, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $10, $29  ; (0, 1): object $29
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $19, $2a  ; (9, 1): object $2A
	db $20, $ac  ; (0, 2): object $AC
	db $29, $ac  ; (9, 2): object $AC
	db $21, $25  ; (1, 2): object $25
	db $22, $21  ; (2, 2): object $21
	db $23, $26  ; (3, 2): object $26
	db $26, $25  ; (6, 2): object $25
	db $27, $21  ; (7, 2): object $21
	db $28, $26  ; (8, 2): object $26
	db $29, $ac  ; (9, 2): object $AC
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $33, $24  ; (3, 3): object $24
	db $36, $23  ; (6, 3): object $23
	db $38, $2a  ; (8, 3): object $2A
	db $39, $21  ; (9, 3): object $21
	db $c4, $40, $23  ; 4 down from (0, 4): object $23
	db $43, $2a  ; (3, 4): object $2A
	db $82, $44, $97  ; 2 across from (4, 4): object $97
	db $46, $29  ; (6, 4): object $29
	db $51, $2c  ; (1, 5): object $2C
	db $52, $22  ; (2, 5): object $22
	db $53, $2b  ; (3, 5): object $2B
	db $61, $2a  ; (1, 6): object $2A
	db $62, $26  ; (2, 6): object $26
	db $63, $27  ; (3, 6): object $27
	db $64, $22  ; (4, 6): object $22
	db $65, $2b  ; (5, 6): object $2B
	db $69, $2c  ; (9, 6): object $2C
	db $72, $24  ; (2, 7): object $24
	db $82, $74, $df  ; 2 across from (4, 7): object $DF
	db $75, $27  ; (5, 7): object $27
	db $84, $76, $22  ; 4 across from (6, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $32, $01  ; (2, 3): object $01
	db $37, $b0  ; (7, 3): object $B0
	db $82, $41, $b0  ; 2 across from (1, 4): object $B0
	db $57, $ae  ; (7, 5): object $AE
	db $68, $ae  ; (8, 6): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7B of indoor group B: 38 objects, room template 0 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom7B::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $30, $29  ; (0, 3): object $29
	db $34, $2c  ; (4, 3): object $2C
	db $35, $2b  ; (5, 3): object $2B
	db $c2, $40, $05  ; 2 down from (0, 4): object $05
	db $c3, $44, $24  ; 3 down from (4, 4): object $24
	db $c4, $45, $23  ; 4 down from (5, 4): object $23
	db $60, $22  ; (0, 6): object $22
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $74, $28  ; (4, 7): object $28
	db $76, $05  ; (6, 7): object $05
	db $77, $2c  ; (7, 7): object $2C
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $86, $12, $af  ; 6 across from (2, 1): object $AF
	db $21, $af  ; (1, 2): object $AF
	db $28, $af  ; (8, 2): object $AF
	db $31, $b0  ; (1, 3): object $B0
	db $86, $22, $01  ; 6 across from (2, 2): object $01
	db $c3, $32, $01  ; 3 down from (2, 3): object $01
	db $c3, $33, $01  ; 3 down from (3, 3): object $01
	db $83, $36, $01  ; 3 across from (6, 3): object $01
	db $83, $46, $01  ; 3 across from (6, 4): object $01
	db $83, $56, $b0  ; 3 across from (6, 5): object $B0
	db $82, $62, $b0  ; 2 across from (2, 6): object $B0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7C of indoor group B: 49 objects, room template 9 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom7C::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $c2, $00, $23  ; 2 down from (0, 0): object $23
	db $02, $2a  ; (2, 0): object $2A
	db $03, $26  ; (3, 0): object $26
	db $82, $04, $df  ; 2 across from (4, 0): object $DF
	db $82, $06, $0d  ; 2 across from (6, 0): object $0D
	db $08, $00  ; (8, 0): object $00
	db $09, $df  ; (9, 0): object $DF
	db $10, $c9  ; (0, 1): object $C9
	db $13, $2a  ; (3, 1): object $2A
	db $14, $21  ; (4, 1): object $21
	db $15, $26  ; (5, 1): object $26
	db $82, $16, $df  ; 2 across from (6, 1): object $DF
	db $82, $18, $0d  ; 2 across from (8, 1): object $0D
	db $20, $27  ; (0, 2): object $27
	db $21, $2b  ; (1, 2): object $2B
	db $25, $2a  ; (5, 2): object $2A
	db $26, $21  ; (6, 2): object $21
	db $27, $26  ; (7, 2): object $26
	db $82, $28, $df  ; 2 across from (8, 2): object $DF
	db $30, $df  ; (0, 3): object $DF
	db $31, $27  ; (1, 3): object $27
	db $32, $2b  ; (2, 3): object $2B
	db $37, $2a  ; (7, 3): object $2A
	db $38, $21  ; (8, 3): object $21
	db $39, $26  ; (9, 3): object $26
	db $40, $0d  ; (0, 4): object $0D
	db $41, $df  ; (1, 4): object $DF
	db $42, $27  ; (2, 4): object $27
	db $43, $2b  ; (3, 4): object $2B
	db $49, $2a  ; (9, 4): object $2A
	db $82, $50, $0d  ; 2 across from (0, 5): object $0D
	db $52, $df  ; (2, 5): object $DF
	db $53, $27  ; (3, 5): object $27
	db $54, $22  ; (4, 5): object $22
	db $55, $2b  ; (5, 5): object $2B
	db $60, $00  ; (0, 6): object $00
	db $82, $61, $0d  ; 2 across from (1, 6): object $0D
	db $82, $63, $df  ; 2 across from (3, 6): object $DF
	db $65, $27  ; (5, 6): object $27
	db $84, $66, $22  ; 4 across from (6, 6): object $22
	db $67, $c8  ; (7, 6): object $C8
	db $82, $70, $00  ; 2 across from (0, 7): object $00
	db $83, $72, $0d  ; 3 across from (2, 7): object $0D
	db $85, $75, $df  ; 5 across from (5, 7): object $DF
	db $24, $ae  ; (4, 2): object $AE
	db $35, $ae  ; (5, 3): object $AE
	db $36, $af  ; (6, 3): object $AF
	db $46, $b0  ; (6, 4): object $B0
	db $82, $47, $ae  ; 2 across from (7, 4): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7D of indoor group B: 37 objects, room template 0 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom7D::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $02, $c7  ; (2, 0): object $C7
	db $05, $29  ; (5, 0): object $29
	db $07, $2a  ; (7, 0): object $2A
	db $08, $c7  ; (8, 0): object $C7
	db $82, $17, $a6  ; 2 across from (7, 1): object $A6
	db $82, $22, $a7  ; 2 across from (2, 2): object $A7
	db $82, $25, $a7  ; 2 across from (5, 2): object $A7
	db $28, $a6  ; (8, 2): object $A6
	db $82, $33, $a7  ; 2 across from (3, 3): object $A7
	db $37, $a7  ; (7, 3): object $A7
	db $83, $44, $a7  ; 3 across from (4, 4): object $A7
	db $83, $52, $a7  ; 3 across from (2, 5): object $A7
	db $40, $29  ; (0, 4): object $29
	db $49, $2a  ; (9, 4): object $2A
	db $60, $2b  ; (0, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $22  ; (9, 6): object $22
	db $70, $27  ; (0, 7): object $27
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $11, $af  ; (1, 1): object $AF
	db $13, $ae  ; (3, 1): object $AE
	db $14, $af  ; (4, 1): object $AF
	db $21, $01  ; (1, 2): object $01
	db $24, $b0  ; (4, 2): object $B0
	db $31, $b0  ; (1, 3): object $B0
	db $32, $af  ; (2, 3): object $AF
	db $82, $35, $ae  ; 2 across from (5, 3): object $AE
	db $42, $b0  ; (2, 4): object $B0
	db $43, $ae  ; (3, 4): object $AE
	db $47, $ae  ; (7, 4): object $AE
	db $56, $ae  ; (6, 5): object $AE
	db $06, $05  ; (6, 0): object $05
	db $50, $05  ; (0, 5): object $05
	db $59, $05  ; (9, 5): object $05
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $7E of indoor group B: 34 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $0A at x 120, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom7E::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $00, $0d  ; (0, 0): object $0D
	db $86, $01, $df  ; 6 across from (1, 0): object $DF
	db $82, $07, $0d  ; 2 across from (7, 0): object $0D
	db $09, $00  ; (9, 0): object $00
	db $10, $df  ; (0, 1): object $DF
	db $11, $25  ; (1, 1): object $25
	db $84, $12, $21  ; 4 across from (2, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $17, $df  ; (7, 1): object $DF
	db $18, $0d  ; (8, 1): object $0D
	db $c6, $19, $0d  ; 6 down from (9, 1): object $0D
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $c5, $28, $df  ; 5 down from (8, 2): object $DF
	db $30, $23  ; (0, 3): object $23
	db $c5, $37, $24  ; 5 down from (7, 3): object $24
	db $40, $29  ; (0, 4): object $29
	db $42, $2c  ; (2, 4): object $2C
	db $43, $22  ; (3, 4): object $22
	db $44, $2b  ; (4, 4): object $2B
	db $52, $24  ; (2, 5): object $24
	db $c2, $53, $df  ; 2 down from (3, 5): object $DF
	db $c2, $54, $23  ; 2 down from (4, 5): object $23
	db $82, $60, $22  ; 2 across from (0, 6): object $22
	db $62, $28  ; (2, 6): object $28
	db $83, $70, $df  ; 3 across from (0, 7): object $DF
	db $73, $0d  ; (3, 7): object $0D
	db $74, $27  ; (4, 7): object $27
	db $77, $28  ; (7, 7): object $28
	db $78, $0d  ; (8, 7): object $0D
	db $79, $00  ; (9, 7): object $00
	db $75, $fd  ; (5, 7): object $FD
	db $e0, $00, $0a, $78, $70  ; warp type 0 to map $00 room $0A, x 120 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7F of indoor group B: 27 objects, room template 3 and floor object $0F. Format: see IndoorBRoomPointers.
IndoorBRoom7F::
	db $04, $3f  ; animated tiles $04, template 3, floor $0F
	db $00, $23  ; (0, 0): object $23
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $24  ; (9, 0): object $24
	db $c5, $11, $23  ; 5 down from (1, 1): object $23
	db $c5, $18, $24  ; 5 down from (8, 1): object $24
	db $61, $27  ; (1, 6): object $27
	db $62, $2b  ; (2, 6): object $2B
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $71, $0d  ; (1, 7): object $0D
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $77, $28  ; (7, 7): object $28
	db $78, $0d  ; (8, 7): object $0D
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $20, $c9  ; (0, 2): object $C9
	db $31, $c9  ; (1, 3): object $C9
	db $51, $c9  ; (1, 5): object $C9
	db $60, $c9  ; (0, 6): object $C9
	db $29, $ca  ; (9, 2): object $CA
	db $38, $ca  ; (8, 3): object $CA
	db $58, $ca  ; (8, 5): object $CA
	db $69, $ca  ; (9, 6): object $CA
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $80 of indoor group B: 40 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $1E at x 56, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom80::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $82, $00, $0d  ; 2 across from (0, 0): object $0D
	db $82, $02, $df  ; 2 across from (2, 0): object $DF
	db $04, $25  ; (4, 0): object $25
	db $85, $05, $21  ; 5 across from (5, 0): object $21
	db $c3, $10, $0d  ; 3 down from (0, 1): object $0D
	db $11, $df  ; (1, 1): object $DF
	db $12, $25  ; (2, 1): object $25
	db $13, $21  ; (3, 1): object $21
	db $14, $29  ; (4, 1): object $29
	db $21, $25  ; (1, 2): object $25
	db $22, $29  ; (2, 2): object $29
	db $26, $2c  ; (6, 2): object $2C
	db $83, $27, $22  ; 3 across from (7, 2): object $22
	db $31, $23  ; (1, 3): object $23
	db $34, $2c  ; (4, 3): object $2C
	db $35, $22  ; (5, 3): object $22
	db $36, $28  ; (6, 3): object $28
	db $83, $37, $df  ; 3 across from (7, 3): object $DF
	db $40, $25  ; (0, 4): object $25
	db $41, $29  ; (1, 4): object $29
	db $43, $2c  ; (3, 4): object $2C
	db $44, $28  ; (4, 4): object $28
	db $82, $45, $df  ; 2 across from (5, 4): object $DF
	db $47, $25  ; (7, 4): object $25
	db $82, $48, $21  ; 2 across from (8, 4): object $21
	db $c2, $50, $23  ; 2 down from (0, 5): object $23
	db $c2, $53, $24  ; 2 down from (3, 5): object $24
	db $82, $54, $df  ; 2 across from (4, 5): object $DF
	db $56, $25  ; (6, 5): object $25
	db $57, $29  ; (7, 5): object $29
	db $c2, $64, $df  ; 2 down from (4, 6): object $DF
	db $c2, $65, $0d  ; 2 down from (5, 6): object $0D
	db $66, $23  ; (6, 6): object $23
	db $70, $27  ; (0, 7): object $27
	db $73, $28  ; (3, 7): object $28
	db $76, $27  ; (6, 7): object $27
	db $77, $c1  ; (7, 7): object $C1
	db $78, $c2  ; (8, 7): object $C2
	db $79, $22  ; (9, 7): object $22
	db $71, $fd  ; (1, 7): object $FD
	db $e0, $00, $1e, $38, $10  ; warp type 0 to map $00 room $1E, x 56 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $81 of indoor group B: 17 objects, room template 9 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom81::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $8a, $00, $21  ; 10 across from (0, 0): object $21
	db $82, $17, $df  ; 2 across from (7, 1): object $DF
	db $8a, $20, $22  ; 10 across from (0, 2): object $22
	db $89, $30, $df  ; 9 across from (0, 3): object $DF
	db $39, $0d  ; (9, 3): object $0D
	db $85, $40, $21  ; 5 across from (0, 4): object $21
	db $45, $26  ; (5, 4): object $26
	db $84, $46, $df  ; 4 across from (6, 4): object $DF
	db $55, $2a  ; (5, 5): object $2A
	db $56, $26  ; (6, 5): object $26
	db $83, $57, $df  ; 3 across from (7, 5): object $DF
	db $66, $24  ; (6, 6): object $24
	db $83, $67, $df  ; 3 across from (7, 6): object $DF
	db $86, $70, $22  ; 6 across from (0, 7): object $22
	db $76, $28  ; (6, 7): object $28
	db $83, $77, $df  ; 3 across from (7, 7): object $DF
	db $64, $be  ; (4, 6): object $BE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $82 of indoor group B: 43 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $1F at x 40, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom82::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $85, $00, $21  ; 5 across from (0, 0): object $21
	db $05, $26  ; (5, 0): object $26
	db $06, $0d  ; (6, 0): object $0D
	db $83, $07, $df  ; 3 across from (7, 0): object $DF
	db $83, $11, $df  ; 3 across from (1, 1): object $DF
	db $15, $2a  ; (5, 1): object $2A
	db $16, $21  ; (6, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $82, $18, $df  ; 2 across from (8, 1): object $DF
	db $83, $20, $22  ; 3 across from (0, 2): object $22
	db $23, $2b  ; (3, 2): object $2B
	db $24, $df  ; (4, 2): object $DF
	db $27, $24  ; (7, 2): object $24
	db $28, $0d  ; (8, 2): object $0D
	db $29, $df  ; (9, 2): object $DF
	db $82, $30, $0d  ; 2 across from (0, 3): object $0D
	db $32, $00  ; (2, 3): object $00
	db $33, $27  ; (3, 3): object $27
	db $34, $2b  ; (4, 3): object $2B
	db $c2, $35, $df  ; 2 down from (5, 3): object $DF
	db $37, $2a  ; (7, 3): object $2A
	db $38, $26  ; (8, 3): object $26
	db $39, $0d  ; (9, 3): object $0D
	db $40, $df  ; (0, 4): object $DF
	db $83, $41, $0d  ; 3 across from (1, 4): object $0D
	db $44, $23  ; (4, 4): object $23
	db $c3, $48, $24  ; 3 down from (8, 4): object $24
	db $c2, $49, $df  ; 2 down from (9, 4): object $DF
	db $82, $50, $df  ; 2 across from (0, 5): object $DF
	db $c3, $52, $0d  ; 3 down from (2, 5): object $0D
	db $c3, $53, $00  ; 3 down from (3, 5): object $00
	db $54, $27  ; (4, 5): object $27
	db $55, $2b  ; (5, 5): object $2B
	db $82, $60, $df  ; 2 across from (0, 6): object $DF
	db $64, $0d  ; (4, 6): object $0D
	db $65, $23  ; (5, 6): object $23
	db $c2, $69, $0d  ; 2 down from (9, 6): object $0D
	db $70, $df  ; (0, 7): object $DF
	db $71, $0d  ; (1, 7): object $0D
	db $82, $73, $00  ; 2 across from (3, 7): object $00
	db $75, $27  ; (5, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $76, $fd  ; (6, 7): object $FD
	db $e0, $00, $1f, $28, $10  ; warp type 0 to map $00 room $1F, x 40 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $83 of indoor group B: 40 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $1E at x 120, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom83::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $82, $00, $0d  ; 2 across from (0, 0): object $0D
	db $82, $02, $df  ; 2 across from (2, 0): object $DF
	db $04, $25  ; (4, 0): object $25
	db $85, $05, $21  ; 5 across from (5, 0): object $21
	db $c3, $10, $0d  ; 3 down from (0, 1): object $0D
	db $11, $df  ; (1, 1): object $DF
	db $12, $25  ; (2, 1): object $25
	db $13, $21  ; (3, 1): object $21
	db $14, $29  ; (4, 1): object $29
	db $21, $25  ; (1, 2): object $25
	db $22, $29  ; (2, 2): object $29
	db $26, $2c  ; (6, 2): object $2C
	db $83, $27, $22  ; 3 across from (7, 2): object $22
	db $31, $23  ; (1, 3): object $23
	db $34, $2c  ; (4, 3): object $2C
	db $35, $22  ; (5, 3): object $22
	db $36, $28  ; (6, 3): object $28
	db $83, $37, $df  ; 3 across from (7, 3): object $DF
	db $40, $25  ; (0, 4): object $25
	db $41, $29  ; (1, 4): object $29
	db $43, $2c  ; (3, 4): object $2C
	db $44, $28  ; (4, 4): object $28
	db $82, $45, $df  ; 2 across from (5, 4): object $DF
	db $47, $25  ; (7, 4): object $25
	db $82, $48, $21  ; 2 across from (8, 4): object $21
	db $c2, $50, $23  ; 2 down from (0, 5): object $23
	db $c2, $53, $24  ; 2 down from (3, 5): object $24
	db $82, $54, $df  ; 2 across from (4, 5): object $DF
	db $56, $25  ; (6, 5): object $25
	db $57, $29  ; (7, 5): object $29
	db $c2, $64, $df  ; 2 down from (4, 6): object $DF
	db $c2, $65, $0d  ; 2 down from (5, 6): object $0D
	db $66, $23  ; (6, 6): object $23
	db $70, $27  ; (0, 7): object $27
	db $71, $c1  ; (1, 7): object $C1
	db $72, $c2  ; (2, 7): object $C2
	db $73, $28  ; (3, 7): object $28
	db $76, $27  ; (6, 7): object $27
	db $79, $22  ; (9, 7): object $22
	db $77, $fd  ; (7, 7): object $FD
	db $e0, $00, $1e, $78, $10  ; warp type 0 to map $00 room $1E, x 120 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $84 of indoor group B: 17 objects, room template 9 and floor object $05; a warp (type 1) to map $0A room $85 at x 72, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom84::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $8a, $00, $21  ; 10 across from (0, 0): object $21
	db $82, $17, $df  ; 2 across from (7, 1): object $DF
	db $8a, $20, $22  ; 10 across from (0, 2): object $22
	db $89, $30, $df  ; 9 across from (0, 3): object $DF
	db $39, $0d  ; (9, 3): object $0D
	db $85, $40, $21  ; 5 across from (0, 4): object $21
	db $45, $26  ; (5, 4): object $26
	db $84, $46, $df  ; 4 across from (6, 4): object $DF
	db $55, $2a  ; (5, 5): object $2A
	db $56, $26  ; (6, 5): object $26
	db $83, $57, $df  ; 3 across from (7, 5): object $DF
	db $66, $24  ; (6, 6): object $24
	db $83, $67, $df  ; 3 across from (7, 6): object $DF
	db $86, $70, $22  ; 6 across from (0, 7): object $22
	db $76, $28  ; (6, 7): object $28
	db $83, $77, $df  ; 3 across from (7, 7): object $DF
	db $64, $be  ; (4, 6): object $BE
	db $e1, $0a, $85, $48, $40  ; warp type 1 to map $0A room $85, x 72 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $85 of indoor group B: 41 objects, room template 2 and floor object $05; a warp (type 1) to map $0A room $84 at x 72, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom85::
	db $0c, $25  ; animated tiles $0C, template 2, floor $05
	db $82, $00, $0d  ; 2 across from (0, 0): object $0D
	db $82, $02, $df  ; 2 across from (2, 0): object $DF
	db $04, $25  ; (4, 0): object $25
	db $06, $26  ; (6, 0): object $26
	db $07, $2a  ; (7, 0): object $2A
	db $10, $0d  ; (0, 1): object $0D
	db $11, $df  ; (1, 1): object $DF
	db $12, $25  ; (2, 1): object $25
	db $13, $21  ; (3, 1): object $21
	db $14, $29  ; (4, 1): object $29
	db $15, $af  ; (5, 1): object $AF
	db $16, $2a  ; (6, 1): object $2A
	db $17, $26  ; (7, 1): object $26
	db $20, $0d  ; (0, 2): object $0D
	db $21, $25  ; (1, 2): object $25
	db $22, $29  ; (2, 2): object $29
	db $23, $ae  ; (3, 2): object $AE
	db $25, $b0  ; (5, 2): object $B0
	db $26, $af  ; (6, 2): object $AF
	db $27, $2a  ; (7, 2): object $2A
	db $28, $98  ; (8, 2): object $98
	db $29, $21  ; (9, 2): object $21
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $32, $af  ; (2, 3): object $AF
	db $36, $01  ; (6, 3): object $01
	db $42, $b0  ; (2, 4): object $B0
	db $43, $af  ; (3, 4): object $AF
	db $45, $af  ; (5, 4): object $AF
	db $46, $b0  ; (6, 4): object $B0
	db $83, $53, $b0  ; 3 across from (3, 5): object $B0
	db $54, $ae  ; (4, 5): object $AE
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $66, $2c  ; (6, 6): object $2C
	db $83, $67, $22  ; 3 across from (7, 6): object $22
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $76, $28  ; (6, 7): object $28
	db $83, $77, $df  ; 3 across from (7, 7): object $DF
	db $34, $cb  ; (4, 3): object $CB
	db $e1, $0a, $84, $48, $70  ; warp type 1 to map $0A room $84, x 72 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $86 of indoor group B: 32 objects, room template 7 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom86::
	db $0c, $75  ; animated tiles $0C, template 7, floor $05
	db $03, $26  ; (3, 0): object $26
	db $04, $df  ; (4, 0): object $DF
	db $05, $25  ; (5, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $13, $2a  ; (3, 1): object $2A
	db $14, $21  ; (4, 1): object $21
	db $15, $29  ; (5, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $19, $df  ; (9, 1): object $DF
	db $20, $21  ; (0, 2): object $21
	db $21, $26  ; (1, 2): object $26
	db $31, $2a  ; (1, 3): object $2A
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $32, $21  ; (2, 3): object $21
	db $33, $26  ; (3, 3): object $26
	db $43, $2a  ; (3, 4): object $2A
	db $82, $44, $21  ; 2 across from (4, 4): object $21
	db $46, $26  ; (6, 4): object $26
	db $82, $54, $af  ; 2 across from (4, 5): object $AF
	db $56, $2a  ; (6, 5): object $2A
	db $57, $26  ; (7, 5): object $26
	db $60, $2b  ; (0, 6): object $2B
	db $84, $63, $af  ; 4 across from (3, 6): object $AF
	db $82, $64, $01  ; 2 across from (4, 6): object $01
	db $c2, $67, $24  ; 2 down from (7, 6): object $24
	db $70, $27  ; (0, 7): object $27
	db $71, $22  ; (1, 7): object $22
	db $72, $2b  ; (2, 7): object $2B
	db $84, $73, $01  ; 4 across from (3, 7): object $01
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $87 of indoor group B: 32 objects, room template 1 and floor object $05; a warp (type 0) to overworld room $1F at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom87::
	db $0c, $15  ; animated tiles $0C, template 1, floor $05
	db $00, $2b  ; (0, 0): object $2B
	db $02, $27  ; (2, 0): object $27
	db $03, $2b  ; (3, 0): object $2B
	db $c5, $04, $01  ; 5 down from (4, 0): object $01
	db $c5, $05, $01  ; 5 down from (5, 0): object $01
	db $06, $2c  ; (6, 0): object $2C
	db $07, $28  ; (7, 0): object $28
	db $11, $a6  ; (1, 1): object $A6
	db $c2, $13, $23  ; 2 down from (3, 1): object $23
	db $c2, $16, $24  ; 2 down from (6, 1): object $24
	db $28, $a6  ; (8, 2): object $A6
	db $29, $2a  ; (9, 2): object $2A
	db $32, $25  ; (2, 3): object $25
	db $33, $29  ; (3, 3): object $29
	db $36, $2a  ; (6, 3): object $2A
	db $82, $37, $21  ; 2 across from (7, 3): object $21
	db $39, $26  ; (9, 3): object $26
	db $c2, $42, $23  ; 2 down from (2, 4): object $23
	db $43, $ae  ; (3, 4): object $AE
	db $44, $b0  ; (4, 4): object $B0
	db $83, $46, $af  ; 3 across from (6, 4): object $AF
	db $84, $55, $b0  ; 4 across from (5, 5): object $B0
	db $62, $27  ; (2, 6): object $27
	db $63, $2b  ; (3, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $71, $2b  ; (1, 7): object $2B
	db $72, $df  ; (2, 7): object $DF
	db $73, $27  ; (3, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $75, $fd  ; (5, 7): object $FD
	db $e0, $00, $1f, $58, $40  ; warp type 0 to map $00 room $1F, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $88 of indoor group B: 44 objects, room template 9 and floor object $0D; a warp (type 1) to map $0A room $8A at x 104, y 96. Format: see IndoorBRoomPointers.
IndoorBRoom88::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $03, $df  ; (3, 0): object $DF
	db $04, $25  ; (4, 0): object $25
	db $83, $05, $21  ; 3 across from (5, 0): object $21
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $82, $11, $df  ; 2 across from (1, 1): object $DF
	db $13, $25  ; (3, 1): object $25
	db $14, $29  ; (4, 1): object $29
	db $83, $15, $1b  ; 3 across from (5, 1): object $1B
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $c2, $22, $df  ; 2 down from (2, 2): object $DF
	db $c3, $23, $23  ; 3 down from (3, 2): object $23
	db $85, $24, $1b  ; 5 across from (4, 2): object $1B
	db $26, $05  ; (6, 2): object $05
	db $c3, $29, $24  ; 3 down from (9, 2): object $24
	db $30, $df  ; (0, 3): object $DF
	db $83, $40, $df  ; 3 across from (0, 4): object $DF
	db $51, $df  ; (1, 5): object $DF
	db $53, $27  ; (3, 5): object $27
	db $54, $2b  ; (4, 5): object $2B
	db $85, $34, $1b  ; 5 across from (4, 3): object $1B
	db $83, $35, $05  ; 3 across from (5, 3): object $05
	db $85, $44, $1b  ; 5 across from (4, 4): object $1B
	db $46, $05  ; (6, 4): object $05
	db $51, $df  ; (1, 5): object $DF
	db $53, $27  ; (3, 5): object $27
	db $54, $2b  ; (4, 5): object $2B
	db $83, $55, $1b  ; 3 across from (5, 5): object $1B
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $83, $61, $df  ; 3 across from (1, 6): object $DF
	db $64, $27  ; (4, 6): object $27
	db $65, $2b  ; (5, 6): object $2B
	db $c2, $66, $1b  ; 2 down from (6, 6): object $1B
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $69, $df  ; (9, 6): object $DF
	db $83, $72, $df  ; 3 across from (2, 7): object $DF
	db $75, $23  ; (5, 7): object $23
	db $77, $24  ; (7, 7): object $24
	db $82, $78, $df  ; 2 across from (8, 7): object $DF
	db $36, $cb  ; (6, 3): object $CB
	db $e1, $0a, $8a, $68, $60  ; warp type 1 to map $0A room $8A, x 104 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $89 of indoor group B: 38 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $19 at x 136, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom89::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $04, $25  ; (4, 0): object $25
	db $05, $29  ; (5, 0): object $29
	db $06, $1b  ; (6, 0): object $1B
	db $c2, $07, $24  ; 2 down from (7, 0): object $24
	db $09, $df  ; (9, 0): object $DF
	db $82, $10, $df  ; 2 across from (0, 1): object $DF
	db $c2, $14, $23  ; 2 down from (4, 1): object $23
	db $82, $15, $1b  ; 2 across from (5, 1): object $1B
	db $21, $df  ; (1, 2): object $DF
	db $c2, $25, $1b  ; 2 down from (5, 2): object $1B
	db $26, $2c  ; (6, 2): object $2C
	db $27, $28  ; (7, 2): object $28
	db $28, $df  ; (8, 2): object $DF
	db $32, $25  ; (2, 3): object $25
	db $33, $21  ; (3, 3): object $21
	db $34, $29  ; (4, 3): object $29
	db $c2, $36, $24  ; 2 down from (6, 3): object $24
	db $82, $37, $df  ; 2 across from (7, 3): object $DF
	db $38, $df  ; (8, 3): object $DF
	db $40, $df  ; (0, 4): object $DF
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $83, $43, $1b  ; 3 across from (3, 4): object $1B
	db $47, $df  ; (7, 4): object $DF
	db $49, $df  ; (9, 4): object $DF
	db $c2, $51, $df  ; 2 down from (1, 5): object $DF
	db $82, $53, $1b  ; 2 across from (3, 5): object $1B
	db $55, $2c  ; (5, 5): object $2C
	db $56, $28  ; (6, 5): object $28
	db $82, $58, $df  ; 2 across from (8, 5): object $DF
	db $82, $63, $1b  ; 2 across from (3, 6): object $1B
	db $65, $24  ; (5, 6): object $24
	db $68, $df  ; (8, 6): object $DF
	db $82, $70, $df  ; 2 across from (0, 7): object $DF
	db $72, $27  ; (2, 7): object $27
	db $75, $28  ; (5, 7): object $28
	db $82, $76, $df  ; 2 across from (6, 7): object $DF
	db $73, $fd  ; (3, 7): object $FD
	db $e0, $00, $19, $88, $40  ; warp type 0 to map $00 room $19, x 136 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8A of indoor group B: 40 objects, room template 9 and floor object $0D; a warp (type 1) to map $0A room $88 at x 104, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom8A::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $83, $01, $df  ; 3 across from (1, 0): object $DF
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $84, $12, $df  ; 4 across from (2, 1): object $DF
	db $19, $df  ; (9, 1): object $DF
	db $c3, $20, $df  ; 3 down from (0, 2): object $DF
	db $22, $df  ; (2, 2): object $DF
	db $23, $25  ; (3, 2): object $25
	db $82, $24, $21  ; 2 across from (4, 2): object $21
	db $26, $26  ; (6, 2): object $26
	db $30, $df  ; (0, 3): object $DF
	db $32, $25  ; (2, 3): object $25
	db $33, $29  ; (3, 3): object $29
	db $82, $34, $05  ; 2 across from (4, 3): object $05
	db $36, $2a  ; (6, 3): object $2A
	db $37, $26  ; (7, 3): object $26
	db $38, $df  ; (8, 3): object $DF
	db $41, $25  ; (1, 4): object $25
	db $42, $29  ; (2, 4): object $29
	db $84, $43, $05  ; 4 across from (3, 4): object $05
	db $47, $2a  ; (7, 4): object $2A
	db $48, $26  ; (8, 4): object $26
	db $c2, $49, $df  ; 2 down from (9, 4): object $DF
	db $51, $23  ; (1, 5): object $23
	db $86, $52, $05  ; 6 across from (2, 5): object $05
	db $58, $24  ; (8, 5): object $24
	db $60, $df  ; (0, 6): object $DF
	db $61, $27  ; (1, 6): object $27
	db $62, $2b  ; (2, 6): object $2B
	db $84, $63, $05  ; 4 across from (3, 6): object $05
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $71, $df  ; (1, 7): object $DF
	db $72, $27  ; (2, 7): object $27
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $05  ; 2 across from (4, 7): object $05
	db $76, $2c  ; (6, 7): object $2C
	db $77, $28  ; (7, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $53, $a0  ; (3, 5): object $A0
	db $56, $be  ; (6, 5): object $BE
	db $e1, $0a, $88, $68, $40  ; warp type 1 to map $0A room $88, x 104 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8B of indoor group B: 20 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $0A at x 24, y 112. Format: see IndoorBRoomPointers.
IndoorBRoom8B::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $c2, $02, $df  ; 2 down from (2, 0): object $DF
	db $10, $df  ; (0, 1): object $DF
	db $82, $20, $df  ; 2 across from (0, 2): object $DF
	db $31, $df  ; (1, 3): object $DF
	db $40, $df  ; (0, 4): object $DF
	db $42, $df  ; (2, 4): object $DF
	db $82, $50, $df  ; 2 across from (0, 5): object $DF
	db $62, $df  ; (2, 6): object $DF
	db $70, $df  ; (0, 7): object $DF
	db $83, $27, $df  ; 3 across from (7, 2): object $DF
	db $83, $37, $df  ; 3 across from (7, 3): object $DF
	db $83, $47, $df  ; 3 across from (7, 4): object $DF
	db $83, $67, $df  ; 3 across from (7, 6): object $DF
	db $c7, $03, $23  ; 7 down from (3, 0): object $23
	db $c7, $04, $05  ; 7 down from (4, 0): object $05
	db $c7, $05, $05  ; 7 down from (5, 0): object $05
	db $c7, $06, $24  ; 7 down from (6, 0): object $24
	db $73, $27  ; (3, 7): object $27
	db $76, $28  ; (6, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $0a, $18, $70  ; warp type 0 to map $00 room $0A, x 24 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8C of indoor group B: 30 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $1F at x 120, y 16. Format: see IndoorBRoomPointers.
IndoorBRoom8C::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $83, $00, $df  ; 3 across from (0, 0): object $DF
	db $c5, $03, $23  ; 5 down from (3, 0): object $23
	db $c3, $05, $24  ; 3 down from (5, 0): object $24
	db $c3, $06, $df  ; 3 down from (6, 0): object $DF
	db $c2, $09, $0d  ; 2 down from (9, 0): object $0D
	db $10, $0d  ; (0, 1): object $0D
	db $11, $df  ; (1, 1): object $DF
	db $c2, $17, $0d  ; 2 down from (7, 1): object $0D
	db $82, $21, $0d  ; 2 across from (1, 2): object $0D
	db $c3, $28, $0d  ; 3 down from (8, 2): object $0D
	db $30, $df  ; (0, 3): object $DF
	db $35, $2a  ; (5, 3): object $2A
	db $36, $26  ; (6, 3): object $26
	db $c2, $37, $df  ; 2 down from (7, 3): object $DF
	db $82, $40, $df  ; 2 across from (0, 4): object $DF
	db $46, $24  ; (6, 4): object $24
	db $c2, $51, $0d  ; 2 down from (1, 5): object $0D
	db $52, $df  ; (2, 5): object $DF
	db $53, $27  ; (3, 5): object $27
	db $54, $2b  ; (4, 5): object $2B
	db $56, $2a  ; (6, 5): object $2A
	db $57, $26  ; (7, 5): object $26
	db $c2, $59, $df  ; 2 down from (9, 5): object $DF
	db $64, $23  ; (4, 6): object $23
	db $67, $24  ; (7, 6): object $24
	db $82, $72, $df  ; 2 across from (2, 7): object $DF
	db $74, $27  ; (4, 7): object $27
	db $77, $28  ; (7, 7): object $28
	db $78, $df  ; (8, 7): object $DF
	db $75, $fd  ; (5, 7): object $FD
	db $e0, $00, $1f, $78, $10  ; warp type 0 to map $00 room $1F, x 120 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8D of indoor group B: 34 objects, room template 9 and floor object $0D; a warp (type 1) to map $0A room $9A at x 56, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom8D::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $82, $00, $df  ; 2 across from (0, 0): object $DF
	db $83, $04, $df  ; 3 across from (4, 0): object $DF
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $c3, $10, $df  ; 3 down from (0, 1): object $DF
	db $c3, $12, $df  ; 3 down from (2, 1): object $DF
	db $c2, $13, $df  ; 2 down from (3, 1): object $DF
	db $c2, $15, $df  ; 2 down from (5, 1): object $DF
	db $c3, $16, $df  ; 3 down from (6, 1): object $DF
	db $c2, $18, $df  ; 2 down from (8, 1): object $DF
	db $c2, $19, $df  ; 2 down from (9, 1): object $DF
	db $33, $25  ; (3, 3): object $25
	db $34, $21  ; (4, 3): object $21
	db $35, $26  ; (5, 3): object $26
	db $c5, $37, $df  ; 5 down from (7, 3): object $DF
	db $42, $25  ; (2, 4): object $25
	db $43, $29  ; (3, 4): object $29
	db $44, $05  ; (4, 4): object $05
	db $45, $2a  ; (5, 4): object $2A
	db $46, $26  ; (6, 4): object $26
	db $82, $48, $df  ; 2 across from (8, 4): object $DF
	db $c3, $51, $df  ; 3 down from (1, 5): object $DF
	db $c2, $52, $23  ; 2 down from (2, 5): object $23
	db $83, $53, $05  ; 3 across from (3, 5): object $05
	db $c3, $56, $24  ; 3 down from (6, 5): object $24
	db $c2, $60, $df  ; 2 down from (0, 6): object $DF
	db $83, $63, $05  ; 3 across from (3, 6): object $05
	db $82, $68, $df  ; 2 across from (8, 6): object $DF
	db $72, $27  ; (2, 7): object $27
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $05  ; 2 across from (4, 7): object $05
	db $82, $77, $df  ; 2 across from (7, 7): object $DF
	db $75, $2c  ; (5, 7): object $2C
	db $76, $28  ; (6, 7): object $28
	db $54, $cb  ; (4, 5): object $CB
	db $e1, $0a, $9a, $38, $40  ; warp type 1 to map $0A room $9A, x 56 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8E of indoor group B: 24 objects, room template 2 and floor object $05; a warp (type 0) to overworld room $0F at x 72, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom8E::
	db $0c, $25  ; animated tiles $0C, template 2, floor $05
	db $83, $00, $00  ; 3 across from (0, 0): object $00
	db $03, $25  ; (3, 0): object $25
	db $10, $00  ; (0, 1): object $00
	db $11, $25  ; (1, 1): object $25
	db $12, $21  ; (2, 1): object $21
	db $13, $29  ; (3, 1): object $29
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $60, $27  ; (0, 6): object $27
	db $83, $61, $22  ; 3 across from (1, 6): object $22
	db $64, $2b  ; (4, 6): object $2B
	db $84, $70, $00  ; 4 across from (0, 7): object $00
	db $74, $27  ; (4, 7): object $27
	db $79, $28  ; (9, 7): object $28
	db $69, $2c  ; (9, 6): object $2C
	db $86, $24, $af  ; 6 across from (4, 2): object $AF
	db $86, $34, $01  ; 6 across from (4, 3): object $01
	db $82, $44, $b0  ; 2 across from (4, 4): object $B0
	db $49, $b0  ; (9, 4): object $B0
	db $36, $b0  ; (6, 3): object $B0
	db $38, $b0  ; (8, 3): object $B0
	db $c2, $27, $05  ; 2 down from (7, 2): object $05
	db $57, $ae  ; (7, 5): object $AE
	db $76, $fd  ; (6, 7): object $FD
	db $e0, $00, $0f, $48, $50  ; warp type 0 to map $00 room $0F, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8F of indoor group B: 17 objects, room template 1 and floor object $0D; a warp (type 0) to overworld room $AC at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoom8F::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $02, $25  ; (2, 0): object $25
	db $84, $03, $21  ; 4 across from (3, 0): object $21
	db $07, $26  ; (7, 0): object $26
	db $04, $f4  ; (4, 0): object $F4
	db $c2, $12, $23  ; 2 down from (2, 1): object $23
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $c2, $17, $24  ; 2 down from (7, 1): object $24
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $32, $27  ; (2, 3): object $27
	db $84, $33, $22  ; 4 across from (3, 3): object $22
	db $37, $28  ; (7, 3): object $28
	db $82, $34, $97  ; 2 across from (4, 3): object $97
	db $c3, $42, $ac  ; 3 down from (2, 4): object $AC
	db $43, $20  ; (3, 4): object $20
	db $46, $20  ; (6, 4): object $20
	db $c3, $47, $ac  ; 3 down from (7, 4): object $AC
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $ac, $58, $40  ; warp type 0 to map $00 room $AC, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $90 of indoor group B: 45 objects, room template 0 and floor object $05; a warp (type 1) to map $0A room $96 at x 40, y 32. Format: see IndoorBRoomPointers.
IndoorBRoom90::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $49, $3e  ; (9, 4): object $3E
	db $c8, $00, $00  ; 8 down from (0, 0): object $00
	db $01, $00  ; (1, 0): object $00
	db $82, $02, $0d  ; 2 across from (2, 0): object $0D
	db $86, $04, $df  ; 6 across from (4, 0): object $DF
	db $07, $0d  ; (7, 0): object $0D
	db $84, $11, $0d  ; 4 across from (1, 1): object $0D
	db $12, $0d  ; (2, 1): object $0D
	db $14, $25  ; (4, 1): object $25
	db $83, $15, $21  ; 3 across from (5, 1): object $21
	db $18, $26  ; (8, 1): object $26
	db $19, $df  ; (9, 1): object $DF
	db $c5, $21, $0d  ; 5 down from (1, 2): object $0D
	db $22, $df  ; (2, 2): object $DF
	db $23, $25  ; (3, 2): object $25
	db $24, $29  ; (4, 2): object $29
	db $82, $25, $ae  ; 2 across from (5, 2): object $AE
	db $27, $af  ; (7, 2): object $AF
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $32, $25  ; (2, 3): object $25
	db $33, $29  ; (3, 3): object $29
	db $34, $ae  ; (4, 3): object $AE
	db $37, $b0  ; (7, 3): object $B0
	db $38, $af  ; (8, 3): object $AF
	db $c2, $42, $23  ; 2 down from (2, 4): object $23
	db $43, $af  ; (3, 4): object $AF
	db $48, $01  ; (8, 4): object $01
	db $51, $df  ; (1, 5): object $DF
	db $53, $b0  ; (3, 5): object $B0
	db $54, $af  ; (4, 5): object $AF
	db $57, $af  ; (7, 5): object $AF
	db $58, $b0  ; (8, 5): object $B0
	db $62, $27  ; (2, 6): object $27
	db $63, $2b  ; (3, 6): object $2B
	db $64, $b0  ; (4, 6): object $B0
	db $82, $65, $ae  ; 2 across from (5, 6): object $AE
	db $67, $b0  ; (7, 6): object $B0
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $73, $27  ; (3, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $45, $cb  ; (5, 4): object $CB
	db $e1, $0a, $96, $28, $20  ; warp type 1 to map $0A room $96, x 40 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $91 of indoor group B: 22 objects, room template 9 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom91::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $8a, $00, $df  ; 10 across from (0, 0): object $DF
	db $83, $10, $df  ; 3 across from (0, 1): object $DF
	db $13, $25  ; (3, 1): object $25
	db $86, $14, $21  ; 6 across from (4, 1): object $21
	db $20, $df  ; (0, 2): object $DF
	db $21, $25  ; (1, 2): object $25
	db $22, $21  ; (2, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $40, $49  ; (0, 4): object $49
	db $41, $0d  ; (1, 4): object $0D
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $60, $df  ; (0, 6): object $DF
	db $61, $27  ; (1, 6): object $27
	db $62, $2b  ; (2, 6): object $2B
	db $69, $2c  ; (9, 6): object $2C
	db $82, $70, $df  ; 2 across from (0, 7): object $DF
	db $72, $23  ; (2, 7): object $23
	db $78, $2c  ; (8, 7): object $2C
	db $79, $28  ; (9, 7): object $28
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $92 of indoor group B: 26 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $B8 at x 120, y 96. Format: see IndoorBRoomPointers.
IndoorBRoom92::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $00, $0d  ; (0, 0): object $0D
	db $83, $01, $df  ; 3 across from (1, 0): object $DF
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $c2, $06, $00  ; 2 down from (6, 0): object $00
	db $c8, $07, $00  ; 8 down from (7, 0): object $00
	db $c8, $08, $00  ; 8 down from (8, 0): object $00
	db $c8, $09, $00  ; 8 down from (9, 0): object $00
	db $83, $10, $21  ; 3 across from (0, 1): object $21
	db $13, $26  ; (3, 1): object $26
	db $14, $df  ; (4, 1): object $DF
	db $15, $0d  ; (5, 1): object $0D
	db $23, $2a  ; (3, 2): object $2A
	db $24, $21  ; (4, 2): object $21
	db $25, $26  ; (5, 2): object $26
	db $26, $0d  ; (6, 2): object $0D
	db $35, $2a  ; (5, 3): object $2A
	db $36, $26  ; (6, 3): object $26
	db $c2, $46, $24  ; 2 down from (6, 4): object $24
	db $60, $2b  ; (0, 6): object $2B
	db $65, $2c  ; (5, 6): object $2C
	db $66, $28  ; (6, 6): object $28
	db $70, $27  ; (0, 7): object $27
	db $84, $71, $22  ; 4 across from (1, 7): object $22
	db $75, $28  ; (5, 7): object $28
	db $76, $0d  ; (6, 7): object $0D
	db $72, $fd  ; (2, 7): object $FD
	db $e0, $00, $b8, $78, $60  ; warp type 0 to map $00 room $B8, x 120 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $93 of indoor group B: 22 objects, room template 1 and floor object $05; a warp (type 0) to overworld room $C8 at x 40, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom93::
	db $0c, $15  ; animated tiles $0C, template 1, floor $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $02, $29  ; (2, 0): object $29
	db $c4, $08, $24  ; 4 down from (8, 0): object $24
	db $c2, $09, $df  ; 2 down from (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $c2, $29, $0d  ; 2 down from (9, 2): object $0D
	db $45, $2c  ; (5, 4): object $2C
	db $82, $46, $22  ; 2 across from (6, 4): object $22
	db $48, $28  ; (8, 4): object $28
	db $49, $00  ; (9, 4): object $00
	db $c2, $55, $24  ; 2 down from (5, 5): object $24
	db $84, $56, $00  ; 4 across from (6, 5): object $00
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $84, $66, $00  ; 4 across from (6, 6): object $00
	db $70, $0d  ; (0, 7): object $0D
	db $71, $27  ; (1, 7): object $27
	db $75, $28  ; (5, 7): object $28
	db $84, $76, $00  ; 4 across from (6, 7): object $00
	db $72, $fd  ; (2, 7): object $FD
	db $e0, $00, $c8, $28, $50  ; warp type 0 to map $00 room $C8, x 40 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $94 of indoor group B: 26 objects, room template 9 and floor object $00. Format: see IndoorBRoomPointers.
IndoorBRoom94::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $05, $0d  ; (5, 0): object $0D
	db $06, $df  ; (6, 0): object $DF
	db $07, $25  ; (7, 0): object $25
	db $82, $08, $21  ; 2 across from (8, 0): object $21
	db $c3, $15, $df  ; 3 down from (5, 1): object $DF
	db $16, $25  ; (6, 1): object $25
	db $17, $29  ; (7, 1): object $29
	db $82, $18, $0d  ; 2 across from (8, 1): object $0D
	db $26, $23  ; (6, 2): object $23
	db $82, $27, $0d  ; 2 across from (7, 2): object $0D
	db $29, $a6  ; (9, 2): object $A6
	db $36, $27  ; (6, 3): object $27
	db $37, $2b  ; (7, 3): object $2B
	db $82, $38, $0d  ; 2 across from (8, 3): object $0D
	db $c2, $45, $0d  ; 2 down from (5, 4): object $0D
	db $46, $df  ; (6, 4): object $DF
	db $47, $27  ; (7, 4): object $27
	db $82, $48, $22  ; 2 across from (8, 4): object $22
	db $56, $0d  ; (6, 5): object $0D
	db $83, $57, $df  ; 3 across from (7, 5): object $DF
	db $65, $df  ; (5, 6): object $DF
	db $67, $0d  ; (7, 6): object $0D
	db $82, $68, $df  ; 2 across from (8, 6): object $DF
	db $76, $df  ; (6, 7): object $DF
	db $82, $77, $0d  ; 2 across from (7, 7): object $0D
	db $79, $df  ; (9, 7): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $95 of indoor group B: 25 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $B8 at x 88, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom95::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $8a, $00, $21  ; 10 across from (0, 0): object $21
	db $c3, $10, $0d  ; 3 down from (0, 1): object $0D
	db $13, $ae  ; (3, 1): object $AE
	db $14, $a7  ; (4, 1): object $A7
	db $20, $a6  ; (0, 2): object $A6
	db $83, $21, $a7  ; 3 across from (1, 2): object $A7
	db $25, $a7  ; (5, 2): object $A7
	db $26, $a6  ; (6, 2): object $A6
	db $27, $2c  ; (7, 2): object $2C
	db $82, $28, $22  ; 2 across from (8, 2): object $22
	db $33, $a7  ; (3, 3): object $A7
	db $c3, $34, $a7  ; 3 down from (4, 3): object $A7
	db $c2, $37, $24  ; 2 down from (7, 3): object $24
	db $40, $2b  ; (0, 4): object $2B
	db $82, $48, $21  ; 2 across from (8, 4): object $21
	db $47, $2a  ; (7, 4): object $2A
	db $50, $23  ; (0, 5): object $23
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $82, $64, $a6  ; 2 across from (4, 6): object $A6
	db $82, $67, $0d  ; 2 across from (7, 6): object $0D
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $88, $72, $22  ; 8 across from (2, 7): object $22
	db $76, $fd  ; (6, 7): object $FD
	db $e0, $00, $b8, $58, $30  ; warp type 0 to map $00 room $B8, x 88 y 48
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $96 of indoor group B: 27 objects, room template 9 and floor object $00; a warp (type 1) to map $0A room $90 at x 88, y 80. Format: see IndoorBRoomPointers.
IndoorBRoom96::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $83, $00, $21  ; 3 across from (0, 0): object $21
	db $03, $26  ; (3, 0): object $26
	db $c7, $04, $df  ; 7 down from (4, 0): object $DF
	db $05, $0d  ; (5, 0): object $0D
	db $82, $10, $05  ; 2 across from (0, 1): object $05
	db $13, $24  ; (3, 1): object $24
	db $c4, $15, $df  ; 4 down from (5, 1): object $DF
	db $83, $20, $22  ; 3 across from (0, 2): object $22
	db $23, $28  ; (3, 2): object $28
	db $82, $30, $05  ; 2 across from (0, 3): object $05
	db $32, $a6  ; (2, 3): object $A6
	db $33, $df  ; (3, 3): object $DF
	db $83, $40, $21  ; 3 across from (0, 4): object $21
	db $41, $98  ; (1, 4): object $98
	db $43, $26  ; (3, 4): object $26
	db $82, $50, $05  ; 2 across from (0, 5): object $05
	db $52, $0d  ; (2, 5): object $0D
	db $53, $24  ; (3, 5): object $24
	db $c2, $55, $0d  ; 2 down from (5, 5): object $0D
	db $82, $60, $05  ; 2 across from (0, 6): object $05
	db $62, $2c  ; (2, 6): object $2C
	db $63, $28  ; (3, 6): object $28
	db $82, $70, $22  ; 2 across from (0, 7): object $22
	db $72, $28  ; (2, 7): object $28
	db $73, $df  ; (3, 7): object $DF
	db $74, $0d  ; (4, 7): object $0D
	db $12, $be  ; (2, 1): object $BE
	db $e1, $0a, $90, $58, $50  ; warp type 1 to map $0A room $90, x 88 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $97 of indoor group B: 30 objects, room template 0 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoom97::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $02, $26  ; (2, 0): object $26
	db $03, $2a  ; (3, 0): object $2A
	db $06, $29  ; (6, 0): object $29
	db $07, $25  ; (7, 0): object $25
	db $c3, $11, $20  ; 3 down from (1, 1): object $20
	db $c2, $12, $24  ; 2 down from (2, 1): object $24
	db $c2, $13, $ac  ; 2 down from (3, 1): object $AC
	db $c3, $14, $0d  ; 3 down from (4, 1): object $0D
	db $c3, $15, $0d  ; 3 down from (5, 1): object $0D
	db $c2, $16, $ac  ; 2 down from (6, 1): object $AC
	db $c2, $17, $23  ; 2 down from (7, 1): object $23
	db $c3, $18, $20  ; 3 down from (8, 1): object $20
	db $32, $2a  ; (2, 3): object $2A
	db $33, $26  ; (3, 3): object $26
	db $36, $25  ; (6, 3): object $25
	db $37, $29  ; (7, 3): object $29
	db $43, $2a  ; (3, 4): object $2A
	db $82, $44, $97  ; 2 across from (4, 4): object $97
	db $46, $29  ; (6, 4): object $29
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $05  ; 2 across from (4, 7): object $05
	db $76, $2c  ; (6, 7): object $2C
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $98 of indoor group B: 14 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $E9 at x 104, y 48. Format: see IndoorBRoomPointers.
IndoorBRoom98::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $05  ; 2 across from (4, 0): object $05
	db $06, $2a  ; (6, 0): object $2A
	db $c3, $46, $0d  ; 3 down from (6, 4): object $0D
	db $83, $55, $0d  ; 3 across from (5, 5): object $0D
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $56, $cb  ; (6, 5): object $CB
	db $e0, $00, $e9, $68, $30  ; warp type 0 to map $00 room $E9, x 104 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $99 of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $11 at x 104, y 50. Format: see IndoorBRoomPointers.
IndoorBRoom99::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $11, $68, $32  ; warp type 0 to map $00 room $11, x 104 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9A of indoor group B: 19 objects, room template 9 and floor object $00; a warp (type 1) to map $0A room $8D at x 72, y 96. Format: see IndoorBRoomPointers.
IndoorBRoom9A::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $00, $21  ; (0, 0): object $21
	db $01, $26  ; (1, 0): object $26
	db $10, $05  ; (0, 1): object $05
	db $11, $2a  ; (1, 1): object $2A
	db $12, $21  ; (2, 1): object $21
	db $13, $26  ; (3, 1): object $26
	db $20, $af  ; (0, 2): object $AF
	db $82, $21, $05  ; 2 across from (1, 2): object $05
	db $23, $2a  ; (3, 2): object $2A
	db $24, $26  ; (4, 2): object $26
	db $30, $01  ; (0, 3): object $01
	db $82, $31, $05  ; 2 across from (1, 3): object $05
	db $c3, $34, $24  ; 3 down from (4, 3): object $24
	db $40, $b0  ; (0, 4): object $B0
	db $83, $41, $05  ; 3 across from (1, 4): object $05
	db $84, $50, $05  ; 4 across from (0, 5): object $05
	db $84, $60, $22  ; 4 across from (0, 6): object $22
	db $64, $28  ; (4, 6): object $28
	db $33, $be  ; (3, 3): object $BE
	db $e1, $0a, $8d, $48, $60  ; warp type 1 to map $0A room $8D, x 72 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9B of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $31 at x 104, y 82. Format: see IndoorBRoomPointers.
IndoorBRoom9B::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $31, $68, $52  ; warp type 0 to map $00 room $31, x 104 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9C of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $88 at x 88, y 82. Format: see IndoorBRoomPointers.
IndoorBRoom9C::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $88, $58, $52  ; warp type 0 to map $00 room $88, x 88 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9D of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $E8 at x 56, y 98. Format: see IndoorBRoomPointers.
IndoorBRoom9D::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $e8, $38, $62  ; warp type 0 to map $00 room $E8, x 56 y 98
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9E of indoor group B: 12 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $0A at x 72, y 34. Format: see IndoorBRoomPointers.
IndoorBRoom9E::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $07, $c7  ; (7, 0): object $C7
	db $02, $99  ; (2, 0): object $99
	db $12, $9a  ; (2, 1): object $9A
	db $11, $c5  ; (1, 1): object $C5
	db $21, $c6  ; (1, 2): object $C6
	db $c2, $13, $10  ; 2 down from (3, 1): object $10
	db $85, $14, $1b  ; 5 across from (4, 1): object $1B
	db $85, $24, $12  ; 5 across from (4, 2): object $12
	db $26, $0d  ; (6, 2): object $0D
	db $31, $13  ; (1, 3): object $13
	db $33, $14  ; (3, 3): object $14
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $0a, $48, $22  ; warp type 0 to map $00 room $0A, x 72 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A0 of indoor group B: 21 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $B3 at x 88, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomA0::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $88, $11, $00  ; 8 across from (1, 1): object $00
	db $c3, $22, $00  ; 3 down from (2, 2): object $00
	db $c3, $28, $00  ; 3 down from (8, 2): object $00
	db $83, $34, $00  ; 3 across from (4, 3): object $00
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $c4, $11, $cf  ; 4 down from (1, 1): object $CF
	db $84, $24, $d1  ; 4 across from (4, 2): object $D1
	db $c2, $37, $d0  ; 2 down from (7, 3): object $D0
	db $c2, $23, $cf  ; 2 down from (3, 2): object $CF
	db $84, $43, $d2  ; 4 across from (3, 4): object $D2
	db $87, $52, $d3  ; 7 across from (2, 5): object $D3
	db $62, $0f  ; (2, 6): object $0F
	db $51, $cd  ; (1, 5): object $CD
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $b3, $58, $52  ; warp type 0 to map $00 room $B3, x 88 y 82
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $A1 of indoor group B: 7 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $93 at x 72, y 98. Format: see IndoorBRoomPointers.
IndoorBRoomA1::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $88, $11, $00  ; 8 across from (1, 1): object $00
	db $88, $21, $00  ; 8 across from (1, 2): object $00
	db $88, $31, $cd  ; 8 across from (1, 3): object $CD
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $56, $ce  ; (6, 5): object $CE
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $93, $48, $62  ; warp type 0 to map $00 room $93, x 72 y 98
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A2 of indoor group B: 17 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $65 at x 72, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomA2::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $99  ; (2, 0): object $99
	db $c6, $11, $20  ; 6 down from (1, 1): object $20
	db $12, $9a  ; (2, 1): object $9A
	db $85, $13, $20  ; 5 across from (3, 1): object $20
	db $18, $c5  ; (8, 1): object $C5
	db $82, $22, $20  ; 2 across from (2, 2): object $20
	db $26, $20  ; (6, 2): object $20
	db $c2, $27, $20  ; 2 down from (7, 2): object $20
	db $28, $c6  ; (8, 2): object $C6
	db $32, $20  ; (2, 3): object $20
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $c4, $38, $20  ; 4 down from (8, 3): object $20
	db $84, $43, $0f  ; 4 across from (3, 4): object $0F
	db $84, $53, $0f  ; 4 across from (3, 5): object $0F
	db $53, $a6  ; (3, 5): object $A6
	db $56, $ab  ; (6, 5): object $AB
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $65, $48, $32  ; warp type 0 to map $00 room $65, x 72 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A3 of indoor group B: 17 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $A2 at x 88, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomA3::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $85, $11, $0f  ; 5 across from (1, 1): object $0F
	db $85, $21, $0f  ; 5 across from (1, 2): object $0F
	db $85, $31, $0f  ; 5 across from (1, 3): object $0F
	db $85, $41, $0f  ; 5 across from (1, 4): object $0F
	db $21, $c5  ; (1, 2): object $C5
	db $31, $c6  ; (1, 3): object $C6
	db $23, $c5  ; (3, 2): object $C5
	db $33, $c6  ; (3, 3): object $C6
	db $c2, $18, $a7  ; 2 down from (8, 1): object $A7
	db $82, $61, $20  ; 2 across from (1, 6): object $20
	db $48, $c0  ; (8, 4): object $C0
	db $68, $c0  ; (8, 6): object $C0
	db $57, $9b  ; (7, 5): object $9B
	db $58, $9c  ; (8, 5): object $9C
	db $07, $99  ; (7, 0): object $99
	db $17, $9a  ; (7, 1): object $9A
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $a2, $58, $52  ; warp type 0 to map $00 room $A2, x 88 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A4 of indoor group B: 34 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $A0 at x 88, y 114. Format: see IndoorBRoomPointers.
IndoorBRoomA4::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $82, $00, $00  ; 2 across from (0, 0): object $00
	db $10, $00  ; (0, 1): object $00
	db $82, $08, $00  ; 2 across from (8, 0): object $00
	db $19, $00  ; (9, 1): object $00
	db $82, $70, $00  ; 2 across from (0, 7): object $00
	db $60, $00  ; (0, 6): object $00
	db $82, $78, $00  ; 2 across from (8, 7): object $00
	db $69, $00  ; (9, 6): object $00
	db $02, $25  ; (2, 0): object $25
	db $11, $25  ; (1, 1): object $25
	db $20, $25  ; (0, 2): object $25
	db $07, $26  ; (7, 0): object $26
	db $18, $26  ; (8, 1): object $26
	db $29, $26  ; (9, 2): object $26
	db $50, $27  ; (0, 5): object $27
	db $61, $27  ; (1, 6): object $27
	db $72, $27  ; (2, 7): object $27
	db $59, $28  ; (9, 5): object $28
	db $68, $28  ; (8, 6): object $28
	db $77, $28  ; (7, 7): object $28
	db $12, $29  ; (2, 1): object $29
	db $21, $29  ; (1, 2): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $28, $2a  ; (8, 2): object $2A
	db $51, $2b  ; (1, 5): object $2B
	db $62, $2b  ; (2, 6): object $2B
	db $58, $2c  ; (8, 5): object $2C
	db $67, $2c  ; (7, 6): object $2C
	db $84, $33, $1b  ; 4 across from (3, 3): object $1B
	db $84, $43, $1b  ; 4 across from (3, 4): object $1B
	db $82, $54, $1b  ; 2 across from (4, 5): object $1B
	db $24, $0f  ; (4, 2): object $0F
	db $57, $0f  ; (7, 5): object $0F
	db $35, $cb  ; (5, 3): object $CB
	db $e0, $00, $a0, $58, $72  ; warp type 0 to map $00 room $A0, x 88 y 114
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A5 of indoor group B: 16 objects, room template 2 and floor object $0F; a warp (type 0) to overworld room $82 at x 88, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomA5::
	db $04, $2f  ; animated tiles $04, template 2, floor $0F
	db $11, $25  ; (1, 1): object $25
	db $85, $12, $21  ; 5 across from (2, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $c2, $21, $23  ; 2 down from (1, 2): object $23
	db $c2, $27, $24  ; 2 down from (7, 2): object $24
	db $41, $27  ; (1, 4): object $27
	db $85, $42, $22  ; 5 across from (2, 4): object $22
	db $47, $28  ; (7, 4): object $28
	db $89, $61, $0d  ; 9 across from (1, 6): object $0D
	db $84, $22, $20  ; 4 across from (2, 2): object $20
	db $26, $0d  ; (6, 2): object $0D
	db $82, $61, $20  ; 2 across from (1, 6): object $20
	db $43, $98  ; (3, 4): object $98
	db $13, $c7  ; (3, 1): object $C7
	db $85, $32, $0d  ; 5 across from (2, 3): object $0D
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $82, $58, $52  ; warp type 0 to map $00 room $82, x 88 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A6 of indoor group B: 15 objects, room template 4 and floor object $0D; a warp (type 0) to overworld room $82 at x 120, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomA6::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $c5, $10, $0f  ; 5 down from (0, 1): object $0F
	db $03, $99  ; (3, 0): object $99
	db $84, $05, $99  ; 4 across from (5, 0): object $99
	db $13, $9a  ; (3, 1): object $9A
	db $84, $15, $9a  ; 4 across from (5, 1): object $9A
	db $23, $c5  ; (3, 2): object $C5
	db $84, $25, $c5  ; 4 across from (5, 2): object $C5
	db $33, $c6  ; (3, 3): object $C6
	db $84, $35, $c6  ; 4 across from (5, 3): object $C6
	db $52, $c0  ; (2, 5): object $C0
	db $42, $9b  ; (2, 4): object $9B
	db $43, $9c  ; (3, 4): object $9C
	db $84, $45, $ce  ; 4 across from (5, 4): object $CE
	db $84, $55, $c0  ; 4 across from (5, 5): object $C0
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $82, $78, $52  ; warp type 0 to map $00 room $82, x 120 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A7 of indoor group B: 13 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $A1 at x 56, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomA7::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $74, $fd  ; (4, 7): object $FD
	db $11, $c5  ; (1, 1): object $C5
	db $21, $c6  ; (1, 2): object $C6
	db $83, $61, $c0  ; 3 across from (1, 6): object $C0
	db $62, $ce  ; (2, 6): object $CE
	db $c4, $17, $20  ; 4 down from (7, 1): object $20
	db $c6, $18, $20  ; 6 down from (8, 1): object $20
	db $06, $99  ; (6, 0): object $99
	db $16, $9a  ; (6, 1): object $9A
	db $24, $c0  ; (4, 2): object $C0
	db $25, $9b  ; (5, 2): object $9B
	db $26, $9c  ; (6, 2): object $9C
	db $82, $35, $c0  ; 2 across from (5, 3): object $C0
	db $e0, $00, $a1, $38, $42  ; warp type 0 to map $00 room $A1, x 56 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A8 of indoor group B: 10 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $30 at x 120, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomA8::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $74, $fd  ; (4, 7): object $FD
	db $c6, $11, $20  ; 6 down from (1, 1): object $20
	db $c6, $12, $20  ; 6 down from (2, 1): object $20
	db $03, $99  ; (3, 0): object $99
	db $13, $9a  ; (3, 1): object $9A
	db $23, $c5  ; (3, 2): object $C5
	db $33, $c6  ; (3, 3): object $C6
	db $44, $9b  ; (4, 4): object $9B
	db $45, $9c  ; (5, 4): object $9C
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
	db $e0, $00, $30, $78, $32  ; warp type 0 to map $00 room $30, x 120 y 50
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $A9 of indoor group B: 15 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $B1 at x 72, y 98. Format: see IndoorBRoomPointers.
IndoorBRoomA9::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $74, $fd  ; (4, 7): object $FD
	db $86, $02, $99  ; 6 across from (2, 0): object $99
	db $86, $12, $9a  ; 6 across from (2, 1): object $9A
	db $21, $9b  ; (1, 2): object $9B
	db $22, $9c  ; (2, 2): object $9C
	db $82, $26, $c5  ; 2 across from (6, 2): object $C5
	db $82, $36, $c6  ; 2 across from (6, 3): object $C6
	db $28, $ce  ; (8, 2): object $CE
	db $51, $ce  ; (1, 5): object $CE
	db $41, $c0  ; (1, 4): object $C0
	db $61, $c0  ; (1, 6): object $C0
	db $84, $53, $0f  ; 4 across from (3, 5): object $0F
	db $84, $63, $0f  ; 4 across from (3, 6): object $0F
	db $82, $57, $20  ; 2 across from (7, 5): object $20
	db $82, $67, $20  ; 2 across from (7, 6): object $20
	db $e0, $00, $b1, $48, $62  ; warp type 0 to map $00 room $B1, x 72 y 98
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AA of indoor group B: 23 objects, room template 0 and floor object $0F; a warp (type 0) to overworld room $83 at x 40, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomAA::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $22, $2c  ; (2, 2): object $2C
	db $27, $2b  ; (7, 2): object $2B
	db $52, $2a  ; (2, 5): object $2A
	db $57, $29  ; (7, 5): object $29
	db $84, $33, $0d  ; 4 across from (3, 3): object $0D
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $23, $22  ; 4 across from (3, 2): object $22
	db $84, $53, $21  ; 4 across from (3, 5): object $21
	db $c2, $32, $24  ; 2 down from (2, 3): object $24
	db $c2, $37, $23  ; 2 down from (7, 3): object $23
	db $35, $c5  ; (5, 3): object $C5
	db $45, $c6  ; (5, 4): object $C6
	db $54, $98  ; (4, 5): object $98
	db $33, $17  ; (3, 3): object $17
	db $34, $12  ; (4, 3): object $12
	db $36, $16  ; (6, 3): object $16
	db $43, $15  ; (3, 4): object $15
	db $46, $14  ; (6, 4): object $14
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $83, $28, $42  ; warp type 0 to map $00 room $83, x 40 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AB of indoor group B: 35 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $50 at x 136, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomAB::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $11, $a6  ; (1, 1): object $A6
	db $14, $a6  ; (4, 1): object $A6
	db $19, $2a  ; (9, 1): object $2A
	db $23, $a6  ; (3, 2): object $A6
	db $25, $20  ; (5, 2): object $20
	db $82, $26, $a7  ; 2 across from (6, 2): object $A7
	db $c2, $29, $05  ; 2 down from (9, 2): object $05
	db $34, $20  ; (4, 3): object $20
	db $35, $a7  ; (5, 3): object $A7
	db $37, $a7  ; (7, 3): object $A7
	db $49, $2c  ; (9, 4): object $2C
	db $41, $a7  ; (1, 4): object $A7
	db $82, $43, $a7  ; 2 across from (3, 4): object $A7
	db $46, $a7  ; (6, 4): object $A7
	db $48, $a7  ; (8, 4): object $A7
	db $82, $52, $a7  ; 2 across from (2, 5): object $A7
	db $57, $a7  ; (7, 5): object $A7
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $62, $a6  ; (2, 6): object $A6
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $13, $0d  ; (3, 1): object $0D
	db $18, $0d  ; (8, 1): object $0D
	db $22, $0d  ; (2, 2): object $0D
	db $82, $31, $0d  ; 2 across from (1, 3): object $0D
	db $45, $0d  ; (5, 4): object $0D
	db $47, $0d  ; (7, 4): object $0D
	db $64, $0d  ; (4, 6): object $0D
	db $82, $66, $0d  ; 2 across from (6, 6): object $0D
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $50, $88, $32  ; warp type 0 to map $00 room $50, x 136 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AC of indoor group B: 30 objects, room template 9 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomAC::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $83, $03, $df  ; 3 across from (3, 0): object $DF
	db $83, $07, $df  ; 3 across from (7, 0): object $DF
	db $84, $10, $21  ; 4 across from (0, 1): object $21
	db $14, $26  ; (4, 1): object $26
	db $15, $df  ; (5, 1): object $DF
	db $17, $df  ; (7, 1): object $DF
	db $c3, $19, $df  ; 3 down from (9, 1): object $DF
	db $84, $20, $05  ; 4 across from (0, 2): object $05
	db $24, $2a  ; (4, 2): object $2A
	db $25, $26  ; (5, 2): object $26
	db $c4, $26, $df  ; 4 down from (6, 2): object $DF
	db $84, $30, $05  ; 4 across from (0, 3): object $05
	db $82, $40, $22  ; 2 across from (0, 4): object $22
	db $42, $2b  ; (2, 4): object $2B
	db $33, $05  ; (3, 3): object $05
	db $c5, $34, $05  ; 5 down from (4, 3): object $05
	db $c5, $35, $24  ; 5 down from (5, 3): object $24
	db $c4, $38, $df  ; 4 down from (8, 3): object $DF
	db $43, $05  ; (3, 4): object $05
	db $52, $27  ; (2, 5): object $27
	db $53, $2b  ; (3, 5): object $2B
	db $47, $df  ; (7, 4): object $DF
	db $51, $df  ; (1, 5): object $DF
	db $c2, $63, $23  ; 2 down from (3, 6): object $23
	db $59, $df  ; (9, 5): object $DF
	db $83, $60, $df  ; 3 across from (0, 6): object $DF
	db $67, $df  ; (7, 6): object $DF
	db $82, $70, $df  ; 2 across from (0, 7): object $DF
	db $82, $76, $df  ; 2 across from (6, 7): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AD of indoor group B: 14 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $45 at x 136, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomAD::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $11, $c0  ; (1, 1): object $C0
	db $31, $c0  ; (1, 3): object $C0
	db $21, $ce  ; (1, 2): object $CE
	db $34, $ce  ; (4, 3): object $CE
	db $24, $c0  ; (4, 2): object $C0
	db $c2, $25, $20  ; 2 down from (5, 2): object $20
	db $84, $45, $20  ; 4 across from (5, 4): object $20
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $17, $c5  ; (7, 1): object $C5
	db $27, $c6  ; (7, 2): object $C6
	db $08, $99  ; (8, 0): object $99
	db $18, $9a  ; (8, 1): object $9A
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $45, $88, $42  ; warp type 0 to map $00 room $45, x 136 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AE of indoor group B: 36 objects, room template 2 and floor object $05; a warp (type 0) to overworld room $20 at x 136, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomAE::
	db $04, $25  ; animated tiles $04, template 2, floor $05
	db $82, $70, $05  ; 2 across from (0, 7): object $05
	db $16, $0d  ; (6, 1): object $0D
	db $19, $0d  ; (9, 1): object $0D
	db $22, $0d  ; (2, 2): object $0D
	db $82, $27, $0d  ; 2 across from (7, 2): object $0D
	db $31, $0d  ; (1, 3): object $0D
	db $c2, $38, $0d  ; 2 down from (8, 3): object $0D
	db $49, $0d  ; (9, 4): object $0D
	db $82, $42, $0d  ; 2 across from (2, 4): object $0D
	db $55, $0d  ; (5, 5): object $0D
	db $69, $0d  ; (9, 6): object $0D
	db $60, $27  ; (0, 6): object $27
	db $61, $22  ; (1, 6): object $22
	db $62, $2b  ; (2, 6): object $2B
	db $72, $27  ; (2, 7): object $27
	db $41, $df  ; (1, 4): object $DF
	db $84, $51, $df  ; 4 across from (1, 5): object $DF
	db $83, $63, $df  ; 3 across from (3, 6): object $DF
	db $14, $df  ; (4, 1): object $DF
	db $82, $24, $df  ; 2 across from (4, 2): object $DF
	db $29, $0f  ; (9, 2): object $0F
	db $53, $0f  ; (3, 5): object $0F
	db $66, $0f  ; (6, 6): object $0F
	db $82, $11, $b0  ; 2 across from (1, 1): object $B0
	db $c2, $13, $01  ; 2 down from (3, 1): object $01
	db $33, $b0  ; (3, 3): object $B0
	db $83, $34, $ae  ; 3 across from (4, 3): object $AE
	db $37, $af  ; (7, 3): object $AF
	db $47, $01  ; (7, 4): object $01
	db $57, $b0  ; (7, 5): object $B0
	db $82, $58, $ae  ; 2 across from (8, 5): object $AE
	db $17, $a0  ; (7, 1): object $A0
	db $48, $15  ; (8, 4): object $15
	db $49, $13  ; (9, 4): object $13
	db $82, $68, $12  ; 2 across from (8, 6): object $12
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $20, $88, $32  ; warp type 0 to map $00 room $20, x 136 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AF of indoor group B: 36 objects, room template 4 and floor object $05; a warp (type 0) to overworld room $21 at x 24, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomAF::
	db $04, $45  ; animated tiles $04, template 4, floor $05
	db $13, $2c  ; (3, 1): object $2C
	db $84, $14, $22  ; 4 across from (4, 1): object $22
	db $18, $2b  ; (8, 1): object $2B
	db $c2, $23, $24  ; 2 down from (3, 2): object $24
	db $c2, $28, $23  ; 2 down from (8, 2): object $23
	db $43, $2a  ; (3, 4): object $2A
	db $84, $44, $21  ; 4 across from (4, 4): object $21
	db $48, $29  ; (8, 4): object $29
	db $82, $50, $ae  ; 2 across from (0, 5): object $AE
	db $22, $af  ; (2, 2): object $AF
	db $c2, $32, $01  ; 2 down from (2, 3): object $01
	db $52, $b0  ; (2, 5): object $B0
	db $83, $10, $0d  ; 3 across from (0, 1): object $0D
	db $20, $0d  ; (0, 2): object $0D
	db $34, $0f  ; (4, 3): object $0F
	db $57, $0f  ; (7, 5): object $0F
	db $25, $0d  ; (5, 2): object $0D
	db $40, $0d  ; (0, 4): object $0D
	db $60, $0d  ; (0, 6): object $0D
	db $54, $0d  ; (4, 5): object $0D
	db $45, $98  ; (5, 4): object $98
	db $69, $28  ; (9, 6): object $28
	db $68, $2c  ; (8, 6): object $2C
	db $78, $28  ; (8, 7): object $28
	db $79, $05  ; (9, 7): object $05
	db $40, $13  ; (0, 4): object $13
	db $41, $14  ; (1, 4): object $14
	db $82, $60, $12  ; 2 across from (0, 6): object $12
	db $24, $17  ; (4, 2): object $17
	db $82, $25, $12  ; 2 across from (5, 2): object $12
	db $26, $a0  ; (6, 2): object $A0
	db $27, $16  ; (7, 2): object $16
	db $36, $20  ; (6, 3): object $20
	db $37, $14  ; (7, 3): object $14
	db $34, $15  ; (4, 3): object $15
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $21, $18, $32  ; warp type 0 to map $00 room $21, x 24 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B0 of indoor group B: 19 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $3F at x 40, y 34. Format: see IndoorBRoomPointers.
IndoorBRoomB0::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $99  ; (4, 0): object $99
	db $83, $11, $0f  ; 3 across from (1, 1): object $0F
	db $83, $21, $0f  ; 3 across from (1, 2): object $0F
	db $83, $31, $0f  ; 3 across from (1, 3): object $0F
	db $12, $c5  ; (2, 1): object $C5
	db $14, $9a  ; (4, 1): object $9A
	db $c2, $15, $11  ; 2 down from (5, 1): object $11
	db $83, $16, $20  ; 3 across from (6, 1): object $20
	db $22, $c6  ; (2, 2): object $C6
	db $24, $13  ; (4, 2): object $13
	db $83, $26, $20  ; 3 across from (6, 2): object $20
	db $34, $11  ; (4, 3): object $11
	db $82, $41, $12  ; 2 across from (1, 4): object $12
	db $44, $93  ; (4, 4): object $93
	db $56, $c0  ; (6, 5): object $C0
	db $57, $ce  ; (7, 5): object $CE
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $3f, $28, $22  ; warp type 0 to map $00 room $3F, x 40 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B1 of indoor group B: 27 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $81 at x 104, y 96. Format: see IndoorBRoomPointers.
IndoorBRoomB1::
	db $05, $90  ; animated tiles $05, template 9, floor $00
	db $8a, $00, $78  ; 10 across from (0, 0): object $78
	db $01, $79  ; (1, 0): object $79
	db $03, $79  ; (3, 0): object $79
	db $05, $79  ; (5, 0): object $79
	db $07, $79  ; (7, 0): object $79
	db $09, $79  ; (9, 0): object $79
	db $8a, $10, $03  ; 10 across from (0, 1): object $03
	db $82, $18, $7c  ; 2 across from (8, 1): object $7C
	db $88, $20, $80  ; 8 across from (0, 2): object $80
	db $8a, $30, $81  ; 10 across from (0, 3): object $81
	db $8a, $40, $81  ; 10 across from (0, 4): object $81
	db $8a, $50, $81  ; 10 across from (0, 5): object $81
	db $8a, $60, $81  ; 10 across from (0, 6): object $81
	db $28, $5f  ; (8, 2): object $5F
	db $29, $60  ; (9, 2): object $60
	db $38, $52  ; (8, 3): object $52
	db $39, $54  ; (9, 3): object $54
	db $49, $51  ; (9, 4): object $51
	db $57, $72  ; (7, 5): object $72
	db $58, $50  ; (8, 5): object $50
	db $59, $54  ; (9, 5): object $54
	db $61, $72  ; (1, 6): object $72
	db $66, $72  ; (6, 6): object $72
	db $67, $50  ; (7, 6): object $50
	db $82, $68, $54  ; 2 across from (8, 6): object $54
	db $87, $70, $53  ; 7 across from (0, 7): object $53
	db $83, $77, $54  ; 3 across from (7, 7): object $54
	db $e0, $00, $81, $68, $60  ; warp type 0 to map $00 room $81, x 104 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B2 of indoor group B: 20 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $A1 at x 88, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomB2::
	db $00, $91  ; animated tiles $00, template 9, floor $01
	db $c8, $00, $0d  ; 8 down from (0, 0): object $0D
	db $00, $21  ; (0, 0): object $21
	db $01, $26  ; (1, 0): object $26
	db $c6, $11, $24  ; 6 down from (1, 1): object $24
	db $70, $22  ; (0, 7): object $22
	db $71, $28  ; (1, 7): object $28
	db $c6, $10, $20  ; 6 down from (0, 1): object $20
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $77, $28  ; (7, 7): object $28
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $c3, $47, $24  ; 3 down from (7, 4): object $24
	db $32, $25  ; (2, 3): object $25
	db $37, $26  ; (7, 3): object $26
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $84, $43, $05  ; 4 across from (3, 4): object $05
	db $84, $53, $05  ; 4 across from (3, 5): object $05
	db $84, $63, $05  ; 4 across from (3, 6): object $05
	db $54, $0f  ; (4, 5): object $0F
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $a1, $58, $42  ; warp type 0 to map $00 room $A1, x 88 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B3 of indoor group B: 21 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $42 at x 56, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomB3::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $84, $23, $01  ; 4 across from (3, 2): object $01
	db $86, $41, $01  ; 6 across from (1, 4): object $01
	db $83, $43, $01  ; 3 across from (3, 4): object $01
	db $83, $51, $01  ; 3 across from (1, 5): object $01
	db $88, $31, $af  ; 8 across from (1, 3): object $AF
	db $36, $01  ; (6, 3): object $01
	db $84, $13, $01  ; 4 across from (3, 1): object $01
	db $83, $61, $01  ; 3 across from (1, 6): object $01
	db $83, $54, $b0  ; 3 across from (4, 5): object $B0
	db $82, $47, $b0  ; 2 across from (7, 4): object $B0
	db $82, $11, $0d  ; 2 across from (1, 1): object $0D
	db $82, $21, $0d  ; 2 across from (1, 2): object $0D
	db $82, $17, $0d  ; 2 across from (7, 1): object $0D
	db $83, $33, $01  ; 3 across from (3, 3): object $01
	db $28, $0d  ; (8, 2): object $0D
	db $65, $0d  ; (5, 6): object $0D
	db $67, $0d  ; (7, 6): object $0D
	db $11, $a0  ; (1, 1): object $A0
	db $18, $a6  ; (8, 1): object $A6
	db $68, $a6  ; (8, 6): object $A6
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $42, $38, $42  ; warp type 0 to map $00 room $42, x 56 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B4 of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $A4 at x 56, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomB4::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $a4, $38, $42  ; warp type 0 to map $00 room $A4, x 56 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B5 of indoor group B: 0 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomB5::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B6 of indoor group B: 31 objects, room template 2 and floor object $0D; a warp (type 0) to overworld room $17 at x 56, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomB6::
	db $04, $2d  ; animated tiles $04, template 2, floor $0D
	db $83, $00, $df  ; 3 across from (0, 0): object $DF
	db $83, $10, $df  ; 3 across from (0, 1): object $DF
	db $20, $df  ; (0, 2): object $DF
	db $03, $25  ; (3, 0): object $25
	db $13, $23  ; (3, 1): object $23
	db $21, $25  ; (1, 2): object $25
	db $22, $21  ; (2, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $14, $0f  ; (4, 1): object $0F
	db $32, $0f  ; (2, 3): object $0F
	db $51, $0f  ; (1, 5): object $0F
	db $62, $0f  ; (2, 6): object $0F
	db $15, $05  ; (5, 1): object $05
	db $18, $05  ; (8, 1): object $05
	db $33, $05  ; (3, 3): object $05
	db $41, $05  ; (1, 4): object $05
	db $52, $05  ; (2, 5): object $05
	db $61, $05  ; (1, 6): object $05
	db $67, $05  ; (7, 6): object $05
	db $85, $25, $ae  ; 5 across from (5, 2): object $AE
	db $34, $ae  ; (4, 3): object $AE
	db $43, $af  ; (3, 4): object $AF
	db $c2, $53, $01  ; 2 down from (3, 5): object $01
	db $83, $57, $ae  ; 3 across from (7, 5): object $AE
	db $56, $af  ; (6, 5): object $AF
	db $66, $01  ; (6, 6): object $01
	db $29, $ac  ; (9, 2): object $AC
	db $59, $ac  ; (9, 5): object $AC
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $17, $38, $32  ; warp type 0 to map $00 room $17, x 56 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B7 of indoor group B: 33 objects, room template 4 and floor object $0D; a warp (type 1) to map $0A room $B8 at x 56, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomB7::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $89, $60, $df  ; 9 across from (0, 6): object $DF
	db $82, $60, $0d  ; 2 across from (0, 6): object $0D
	db $08, $26  ; (8, 0): object $26
	db $c2, $09, $df  ; 2 down from (9, 0): object $DF
	db $18, $24  ; (8, 1): object $24
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $11, $05  ; (1, 1): object $05
	db $c2, $17, $05  ; 2 down from (7, 1): object $05
	db $38, $05  ; (8, 3): object $05
	db $84, $12, $df  ; 4 across from (2, 1): object $DF
	db $24, $df  ; (4, 2): object $DF
	db $82, $33, $df  ; 2 across from (3, 3): object $DF
	db $46, $df  ; (6, 4): object $DF
	db $83, $55, $df  ; 3 across from (5, 5): object $DF
	db $84, $20, $ae  ; 4 across from (0, 2): object $AE
	db $83, $50, $ae  ; 3 across from (0, 5): object $AE
	db $43, $af  ; (3, 4): object $AF
	db $53, $b0  ; (3, 5): object $B0
	db $c3, $16, $a7  ; 3 down from (6, 1): object $A7
	db $32, $a7  ; (2, 3): object $A7
	db $35, $a7  ; (5, 3): object $A7
	db $c2, $44, $a7  ; 2 down from (4, 4): object $A7
	db $47, $a7  ; (7, 4): object $A7
	db $58, $a7  ; (8, 5): object $A7
	db $65, $a7  ; (5, 6): object $A7
	db $25, $dd  ; (5, 2): object $DD
	db $45, $dd  ; (5, 4): object $DD
	db $48, $dd  ; (8, 4): object $DD
	db $64, $dd  ; (4, 6): object $DD
	db $37, $be  ; (7, 3): object $BE
	db $e1, $0a, $b8, $38, $42  ; warp type 1 to map $0A room $B8, x 56 y 66
	db $20, $ac  ; (0, 2): object $AC
	db $50, $ac  ; (0, 5): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B8 of indoor group B: 19 objects, room template 9 and floor object $0D; a warp (type 1) to map $0A room $B7 at x 120, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomB8::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $8a, $00, $df  ; 10 across from (0, 0): object $DF
	db $8a, $10, $df  ; 10 across from (0, 1): object $DF
	db $8a, $60, $df  ; 10 across from (0, 6): object $DF
	db $8a, $70, $df  ; 10 across from (0, 7): object $DF
	db $20, $df  ; (0, 2): object $DF
	db $21, $25  ; (1, 2): object $25
	db $88, $22, $21  ; 8 across from (2, 2): object $21
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $40, $23  ; (0, 4): object $23
	db $50, $27  ; (0, 5): object $27
	db $89, $51, $22  ; 9 across from (1, 5): object $22
	db $38, $05  ; (8, 3): object $05
	db $39, $0f  ; (9, 3): object $0F
	db $42, $05  ; (2, 4): object $05
	db $44, $05  ; (4, 4): object $05
	db $49, $05  ; (9, 4): object $05
	db $46, $0f  ; (6, 4): object $0F
	db $33, $cb  ; (3, 3): object $CB
	db $e1, $0a, $b7, $78, $42  ; warp type 1 to map $0A room $B7, x 120 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B9 of indoor group B: 18 objects, room template 9 and floor object $0D; a warp (type 1) to map $0A room $BA at x 136, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomB9::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $8a, $00, $df  ; 10 across from (0, 0): object $DF
	db $8a, $10, $df  ; 10 across from (0, 1): object $DF
	db $8a, $60, $df  ; 10 across from (0, 6): object $DF
	db $8a, $70, $df  ; 10 across from (0, 7): object $DF
	db $59, $df  ; (9, 5): object $DF
	db $89, $20, $21  ; 9 across from (0, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $33, $0f  ; (3, 3): object $0F
	db $35, $05  ; (5, 3): object $05
	db $40, $05  ; (0, 4): object $05
	db $42, $05  ; (2, 4): object $05
	db $47, $05  ; (7, 4): object $05
	db $48, $2c  ; (8, 4): object $2C
	db $49, $28  ; (9, 4): object $28
	db $58, $28  ; (8, 5): object $28
	db $88, $50, $22  ; 8 across from (0, 5): object $22
	db $46, $cb  ; (6, 4): object $CB
	db $e1, $0a, $ba, $88, $42  ; warp type 1 to map $0A room $BA, x 136 y 66
	db $39, $24  ; (9, 3): object $24
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BA of indoor group B: 34 objects, room template 9 and floor object $05; a warp (type 1) to map $0A room $B9 at x 104, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomBA::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $c5, $20, $23  ; 5 down from (0, 2): object $23
	db $30, $f6  ; (0, 3): object $F6
	db $30, $29  ; (0, 3): object $29
	db $40, $0d  ; (0, 4): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $88, $02, $21  ; 8 across from (2, 0): object $21
	db $04, $26  ; (4, 0): object $26
	db $82, $05, $df  ; 2 across from (5, 0): object $DF
	db $07, $25  ; (7, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $12, $0f  ; (2, 1): object $0F
	db $14, $2a  ; (4, 1): object $2A
	db $15, $26  ; (5, 1): object $26
	db $16, $25  ; (6, 1): object $25
	db $17, $29  ; (7, 1): object $29
	db $18, $0f  ; (8, 1): object $0F
	db $c4, $25, $24  ; 4 down from (5, 2): object $24
	db $c4, $26, $23  ; 4 down from (6, 2): object $23
	db $56, $27  ; (6, 5): object $27
	db $57, $2b  ; (7, 5): object $2B
	db $64, $2c  ; (4, 6): object $2C
	db $65, $28  ; (5, 6): object $28
	db $66, $df  ; (6, 6): object $DF
	db $67, $27  ; (7, 6): object $27
	db $82, $68, $22  ; 2 across from (8, 6): object $22
	db $70, $27  ; (0, 7): object $27
	db $83, $71, $22  ; 3 across from (1, 7): object $22
	db $74, $28  ; (4, 7): object $28
	db $85, $75, $df  ; 5 across from (5, 7): object $DF
	db $53, $0f  ; (3, 5): object $0F
	db $38, $be  ; (8, 3): object $BE
	db $e1, $0a, $b9, $68, $52  ; warp type 1 to map $0A room $B9, x 104 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BB of indoor group B: 34 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $18 at x 104, y 18. Format: see IndoorBRoomPointers.
IndoorBRoomBB::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $8a, $00, $21  ; 10 across from (0, 0): object $21
	db $8a, $70, $22  ; 10 across from (0, 7): object $22
	db $82, $60, $22  ; 2 across from (0, 6): object $22
	db $62, $2b  ; (2, 6): object $2B
	db $82, $70, $df  ; 2 across from (0, 7): object $DF
	db $72, $27  ; (2, 7): object $27
	db $c5, $10, $0d  ; 5 down from (0, 1): object $0D
	db $11, $0d  ; (1, 1): object $0D
	db $52, $0d  ; (2, 5): object $0D
	db $63, $0d  ; (3, 6): object $0D
	db $82, $68, $0d  ; 2 across from (8, 6): object $0D
	db $82, $18, $0d  ; 2 across from (8, 1): object $0D
	db $27, $0d  ; (7, 2): object $0D
	db $37, $0f  ; (7, 3): object $0F
	db $38, $0d  ; (8, 3): object $0D
	db $84, $13, $01  ; 4 across from (3, 1): object $01
	db $83, $23, $01  ; 3 across from (3, 2): object $01
	db $26, $b0  ; (6, 2): object $B0
	db $33, $b0  ; (3, 3): object $B0
	db $c2, $34, $01  ; 2 down from (4, 3): object $01
	db $c2, $35, $01  ; 2 down from (5, 3): object $01
	db $46, $af  ; (6, 4): object $AF
	db $49, $af  ; (9, 4): object $AF
	db $86, $54, $b0  ; 6 across from (4, 5): object $B0
	db $82, $57, $ae  ; 2 across from (7, 5): object $AE
	db $30, $0f  ; (0, 3): object $0F
	db $21, $20  ; (1, 2): object $20
	db $51, $4e  ; (1, 5): object $4E
	db $82, $66, $4e  ; 2 across from (6, 6): object $4E
	db $28, $a0  ; (8, 2): object $A0
	db $36, $a6  ; (6, 3): object $A6
	db $39, $a6  ; (9, 3): object $A6
	db $82, $47, $a6  ; 2 across from (7, 4): object $A6
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $18, $68, $12  ; warp type 0 to map $00 room $18, x 104 y 18
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BC of indoor group B: 27 objects, room template 4 and floor object $0D; a warp (type 0) to overworld room $18 at x 136, y 18. Format: see IndoorBRoomPointers.
IndoorBRoomBC::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $08, $26  ; (8, 0): object $26
	db $18, $24  ; (8, 1): object $24
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $c2, $09, $df  ; 2 down from (9, 0): object $DF
	db $82, $11, $df  ; 2 across from (1, 1): object $DF
	db $c2, $13, $a6  ; 2 down from (3, 1): object $A6
	db $c4, $14, $01  ; 4 down from (4, 1): object $01
	db $c2, $15, $01  ; 2 down from (5, 1): object $01
	db $c3, $17, $df  ; 3 down from (7, 1): object $DF
	db $26, $df  ; (6, 2): object $DF
	db $83, $30, $a6  ; 3 across from (0, 3): object $A6
	db $c2, $33, $01  ; 2 down from (3, 3): object $01
	db $35, $b0  ; (5, 3): object $B0
	db $83, $40, $af  ; 3 across from (0, 4): object $AF
	db $45, $0f  ; (5, 4): object $0F
	db $c2, $48, $df  ; 2 down from (8, 4): object $DF
	db $85, $50, $b0  ; 5 across from (0, 5): object $B0
	db $55, $05  ; (5, 5): object $05
	db $56, $df  ; (6, 5): object $DF
	db $61, $05  ; (1, 6): object $05
	db $64, $df  ; (4, 6): object $DF
	db $65, $df  ; (5, 6): object $DF
	db $67, $05  ; (7, 6): object $05
	db $68, $0f  ; (8, 6): object $0F
	db $61, $4e  ; (1, 6): object $4E
	db $72, $fd  ; (2, 7): object $FD
	db $e0, $00, $18, $88, $12  ; warp type 0 to map $00 room $18, x 136 y 18
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BD of indoor group B: 29 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $62 at x 120, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomBD::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $03, $29  ; (3, 0): object $29
	db $04, $05  ; (4, 0): object $05
	db $05, $2a  ; (5, 0): object $2A
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $87, $11, $df  ; 7 across from (1, 1): object $DF
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $c5, $21, $df  ; 5 down from (1, 2): object $DF
	db $22, $af  ; (2, 2): object $AF
	db $c3, $23, $dd  ; 3 down from (3, 2): object $DD
	db $24, $dd  ; (4, 2): object $DD
	db $82, $25, $ae  ; 2 across from (5, 2): object $AE
	db $82, $27, $df  ; 2 across from (7, 2): object $DF
	db $32, $b0  ; (2, 3): object $B0
	db $34, $a0  ; (4, 3): object $A0
	db $c2, $35, $dd  ; 2 down from (5, 3): object $DD
	db $82, $37, $df  ; 2 across from (7, 3): object $DF
	db $44, $a7  ; (4, 4): object $A7
	db $83, $52, $ae  ; 3 across from (2, 5): object $AE
	db $55, $a7  ; (5, 5): object $A7
	db $48, $0d  ; (8, 4): object $0D
	db $82, $57, $0d  ; 2 across from (7, 5): object $0D
	db $66, $2c  ; (6, 6): object $2C
	db $82, $67, $22  ; 2 across from (7, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $76, $28  ; (6, 7): object $28
	db $83, $77, $df  ; 3 across from (7, 7): object $DF
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $62, $78, $42  ; warp type 0 to map $00 room $62, x 120 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BE of indoor group B: 20 objects, room template 8 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomBE::
	db $04, $8d  ; animated tiles $04, template 8, floor $0D
	db $c6, $13, $df  ; 6 down from (3, 1): object $DF
	db $c4, $31, $df  ; 4 down from (1, 3): object $DF
	db $22, $2c  ; (2, 2): object $2C
	db $87, $23, $22  ; 7 across from (3, 2): object $22
	db $c5, $32, $24  ; 5 down from (2, 3): object $24
	db $c4, $43, $11  ; 4 down from (3, 4): object $11
	db $33, $17  ; (3, 3): object $17
	db $34, $12  ; (4, 3): object $12
	db $35, $2c  ; (5, 3): object $2C
	db $84, $36, $22  ; 4 across from (6, 3): object $22
	db $c4, $45, $24  ; 4 down from (5, 4): object $24
	db $46, $ac  ; (6, 4): object $AC
	db $83, $47, $12  ; 3 across from (7, 4): object $12
	db $c3, $56, $11  ; 3 down from (6, 5): object $11
	db $83, $57, $0f  ; 3 across from (7, 5): object $0F
	db $83, $67, $0f  ; 3 across from (7, 6): object $0F
	db $83, $77, $0f  ; 3 across from (7, 7): object $0F
	db $68, $a0  ; (8, 6): object $A0
	db $49, $16  ; (9, 4): object $16
	db $c3, $59, $10  ; 3 down from (9, 5): object $10
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BF of indoor group B: 20 objects, room template 7 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomBF::
	db $04, $7d  ; animated tiles $04, template 7, floor $0D
	db $86, $11, $df  ; 6 across from (1, 1): object $DF
	db $c4, $38, $df  ; 4 down from (8, 3): object $DF
	db $87, $20, $22  ; 7 across from (0, 2): object $22
	db $27, $2b  ; (7, 2): object $2B
	db $c5, $37, $23  ; 5 down from (7, 3): object $23
	db $84, $30, $22  ; 4 across from (0, 3): object $22
	db $34, $2b  ; (4, 3): object $2B
	db $35, $12  ; (5, 3): object $12
	db $36, $16  ; (6, 3): object $16
	db $c4, $46, $10  ; 4 down from (6, 4): object $10
	db $c4, $44, $23  ; 4 down from (4, 4): object $23
	db $83, $40, $12  ; 3 across from (0, 4): object $12
	db $43, $ac  ; (3, 4): object $AC
	db $c3, $53, $10  ; 3 down from (3, 5): object $10
	db $83, $50, $0f  ; 3 across from (0, 5): object $0F
	db $83, $60, $0f  ; 3 across from (0, 6): object $0F
	db $83, $70, $0f  ; 3 across from (0, 7): object $0F
	db $61, $a0  ; (1, 6): object $A0
	db $40, $17  ; (0, 4): object $17
	db $c3, $50, $11  ; 3 down from (0, 5): object $11
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C0 of indoor group B: 27 objects, room template 9 and floor object $04; a warp (type 0) to overworld room $D9 at x 40, y 96. Format: see IndoorBRoomPointers.
IndoorBRoomC0::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $86, $00, $03  ; 6 across from (0, 0): object $03
	db $86, $00, $80  ; 6 across from (0, 0): object $80
	db $86, $10, $81  ; 6 across from (0, 1): object $81
	db $86, $20, $81  ; 6 across from (0, 2): object $81
	db $86, $30, $81  ; 6 across from (0, 3): object $81
	db $86, $40, $81  ; 6 across from (0, 4): object $81
	db $86, $50, $81  ; 6 across from (0, 5): object $81
	db $83, $07, $54  ; 3 across from (7, 0): object $54
	db $83, $17, $54  ; 3 across from (7, 1): object $54
	db $83, $27, $54  ; 3 across from (7, 2): object $54
	db $84, $36, $54  ; 4 across from (6, 3): object $54
	db $c3, $06, $51  ; 3 down from (6, 0): object $51
	db $35, $50  ; (5, 3): object $50
	db $45, $52  ; (5, 4): object $52
	db $84, $46, $5c  ; 4 across from (6, 4): object $5C
	db $56, $7d  ; (6, 5): object $7D
	db $83, $57, $84  ; 3 across from (7, 5): object $84
	db $8a, $60, $53  ; 10 across from (0, 6): object $53
	db $61, $56  ; (1, 6): object $56
	db $62, $81  ; (2, 6): object $81
	db $64, $50  ; (4, 6): object $50
	db $8a, $70, $54  ; 10 across from (0, 7): object $54
	db $82, $72, $53  ; 2 across from (2, 7): object $53
	db $25, $72  ; (5, 2): object $72
	db $50, $72  ; (0, 5): object $72
	db $63, $72  ; (3, 6): object $72
	db $84, $66, $5b  ; 4 across from (6, 6): object $5B
	db $e0, $00, $d9, $28, $60  ; warp type 0 to map $00 room $D9, x 40 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C1 of indoor group B: 32 objects, room template 9 and floor object $04; a warp (type 0) to overworld room $D9 at x 72, y 96. Format: see IndoorBRoomPointers.
IndoorBRoomC1::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $86, $03, $80  ; 6 across from (3, 0): object $80
	db $86, $13, $81  ; 6 across from (3, 1): object $81
	db $86, $23, $81  ; 6 across from (3, 2): object $81
	db $86, $33, $81  ; 6 across from (3, 3): object $81
	db $86, $43, $81  ; 6 across from (3, 4): object $81
	db $86, $53, $81  ; 6 across from (3, 5): object $81
	db $c4, $00, $54  ; 4 down from (0, 0): object $54
	db $c4, $01, $54  ; 4 down from (1, 0): object $54
	db $c3, $02, $57  ; 3 down from (2, 0): object $57
	db $32, $54  ; (2, 3): object $54
	db $33, $56  ; (3, 3): object $56
	db $83, $40, $5c  ; 3 across from (0, 4): object $5C
	db $43, $58  ; (3, 4): object $58
	db $82, $50, $84  ; 2 across from (0, 5): object $84
	db $52, $7e  ; (2, 5): object $7E
	db $83, $60, $5b  ; 3 across from (0, 6): object $5B
	db $63, $53  ; (3, 6): object $53
	db $8a, $70, $54  ; 10 across from (0, 7): object $54
	db $68, $54  ; (8, 6): object $54
	db $c3, $49, $54  ; 3 down from (9, 4): object $54
	db $c4, $09, $51  ; 4 down from (9, 0): object $51
	db $48, $50  ; (8, 4): object $50
	db $58, $51  ; (8, 5): object $51
	db $67, $50  ; (7, 6): object $50
	db $65, $81  ; (5, 6): object $81
	db $82, $75, $53  ; 2 across from (5, 7): object $53
	db $23, $72  ; (3, 2): object $72
	db $38, $72  ; (8, 3): object $72
	db $54, $72  ; (4, 5): object $72
	db $57, $72  ; (7, 5): object $72
	db $66, $72  ; (6, 6): object $72
	db $64, $56  ; (4, 6): object $56
	db $e0, $00, $d9, $48, $60  ; warp type 0 to map $00 room $D9, x 72 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C2 of indoor group B: 30 objects, room template 8 and floor object $0D; a warp (type 1) to map $14 room $C5 at x 72, y 16. Format: see IndoorBRoomPointers.
IndoorBRoomC2::
	db $04, $8d  ; animated tiles $04, template 8, floor $0D
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $04, $c7  ; (4, 0): object $C7
	db $08, $c7  ; (8, 0): object $C7
	db $10, $03  ; (0, 1): object $03
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $87, $13, $0f  ; 7 across from (3, 1): object $0F
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $22, $0f  ; (2, 2): object $0F
	db $23, $96  ; (3, 2): object $96
	db $86, $24, $13  ; 6 across from (4, 2): object $13
	db $31, $ac  ; (1, 3): object $AC
	db $32, $13  ; (2, 3): object $13
	db $33, $14  ; (3, 3): object $14
	db $34, $25  ; (4, 3): object $25
	db $85, $35, $21  ; 5 across from (5, 3): object $21
	db $40, $29  ; (0, 4): object $29
	db $41, $25  ; (1, 4): object $25
	db $82, $42, $21  ; 2 across from (2, 4): object $21
	db $44, $29  ; (4, 4): object $29
	db $45, $ac  ; (5, 4): object $AC
	db $50, $25  ; (0, 5): object $25
	db $51, $29  ; (1, 5): object $29
	db $61, $ac  ; (1, 6): object $AC
	db $73, $c0  ; (3, 7): object $C0
	db $76, $c0  ; (6, 7): object $C0
	db $79, $2c  ; (9, 7): object $2C
	db $06, $a3  ; (6, 0): object $A3
	db $e1, $14, $c5, $48, $10  ; warp type 1 to map $14 room $C5, x 72 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C3 of indoor group B: 28 objects, room template 4 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomC3::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $87, $10, $0f  ; 7 across from (0, 1): object $0F
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $19, $03  ; (9, 1): object $03
	db $86, $20, $13  ; 6 across from (0, 2): object $13
	db $22, $0d  ; (2, 2): object $0D
	db $26, $95  ; (6, 2): object $95
	db $27, $0f  ; (7, 2): object $0F
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $85, $30, $21  ; 5 across from (0, 3): object $21
	db $32, $98  ; (2, 3): object $98
	db $35, $26  ; (5, 3): object $26
	db $36, $15  ; (6, 3): object $15
	db $37, $13  ; (7, 3): object $13
	db $38, $ac  ; (8, 3): object $AC
	db $44, $ac  ; (4, 4): object $AC
	db $45, $2a  ; (5, 4): object $2A
	db $82, $46, $21  ; 2 across from (6, 4): object $21
	db $48, $26  ; (8, 4): object $26
	db $49, $2a  ; (9, 4): object $2A
	db $57, $ac  ; (7, 5): object $AC
	db $58, $2a  ; (8, 5): object $2A
	db $59, $26  ; (9, 5): object $26
	db $67, $0f  ; (7, 6): object $0F
	db $68, $aa  ; (8, 6): object $AA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C4 of indoor group B: 33 objects, room template 7 and floor object $03; a warp (type 0) to overworld room $4A at x 136, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomC4::
	db $04, $73  ; animated tiles $04, template 7, floor $03
	db $85, $00, $03  ; 5 across from (0, 0): object $03
	db $c3, $59, $03  ; 3 down from (9, 5): object $03
	db $05, $25  ; (5, 0): object $25
	db $c2, $15, $23  ; 2 down from (5, 1): object $23
	db $35, $27  ; (5, 3): object $27
	db $36, $2b  ; (6, 3): object $2B
	db $46, $23  ; (6, 4): object $23
	db $53, $25  ; (3, 5): object $25
	db $82, $54, $21  ; 2 across from (4, 5): object $21
	db $56, $29  ; (6, 5): object $29
	db $c2, $58, $24  ; 2 down from (8, 5): object $24
	db $78, $28  ; (8, 7): object $28
	db $c2, $63, $23  ; 2 down from (3, 6): object $23
	db $75, $2c  ; (5, 7): object $2C
	db $82, $76, $22  ; 2 across from (6, 7): object $22
	db $16, $ab  ; (6, 1): object $AB
	db $c2, $17, $0d  ; 2 down from (7, 1): object $0D
	db $26, $0d  ; (6, 2): object $0D
	db $c2, $28, $0d  ; 2 down from (8, 2): object $0D
	db $c3, $37, $0d  ; 3 down from (7, 3): object $0D
	db $82, $64, $0d  ; 2 across from (4, 6): object $0D
	db $82, $66, $0d  ; 2 across from (6, 6): object $0D
	db $74, $0d  ; (4, 7): object $0D
	db $48, $2c  ; (8, 4): object $2C
	db $49, $28  ; (9, 4): object $28
	db $18, $cb  ; (8, 1): object $CB
	db $c2, $17, $07  ; 2 down from (7, 1): object $07
	db $26, $07  ; (6, 2): object $07
	db $c2, $28, $07  ; 2 down from (8, 2): object $07
	db $c3, $37, $07  ; 3 down from (7, 3): object $07
	db $82, $64, $07  ; 2 across from (4, 6): object $07
	db $82, $66, $07  ; 2 across from (6, 6): object $07
	db $74, $07  ; (4, 7): object $07
	db $e0, $00, $4a, $88, $30  ; warp type 0 to map $00 room $4A, x 136 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C5 of indoor group B: 21 objects, room template 0 and floor object $0D; a warp (type 1) to map $14 room $C2 at x 104, y 16. Format: see IndoorBRoomPointers.
IndoorBRoomC5::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $c7  ; (3, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $00, $03  ; (0, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $14, $0f  ; (4, 1): object $0F
	db $20, $29  ; (0, 2): object $29
	db $89, $21, $13  ; 9 across from (1, 2): object $13
	db $24, $0d  ; (4, 2): object $0D
	db $30, $25  ; (0, 3): object $25
	db $88, $31, $21  ; 8 across from (1, 3): object $21
	db $39, $26  ; (9, 3): object $26
	db $34, $98  ; (4, 3): object $98
	db $52, $ac  ; (2, 5): object $AC
	db $57, $ac  ; (7, 5): object $AC
	db $09, $21  ; (9, 0): object $21
	db $19, $0d  ; (9, 1): object $0D
	db $32, $90  ; (2, 3): object $90
	db $37, $90  ; (7, 3): object $90
	db $04, $a2  ; (4, 0): object $A2
	db $e1, $14, $c2, $68, $10  ; warp type 1 to map $14 room $C2, x 104 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C6 of indoor group B: 18 objects, room template 4 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomC6::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $74, $f1  ; (4, 7): object $F1
	db $01, $29  ; (1, 0): object $29
	db $02, $25  ; (2, 0): object $25
	db $c7, $11, $10  ; 7 down from (1, 1): object $10
	db $c5, $30, $11  ; 5 down from (0, 3): object $11
	db $20, $95  ; (0, 2): object $95
	db $c6, $12, $23  ; 6 down from (2, 1): object $23
	db $72, $27  ; (2, 7): object $27
	db $67, $2c  ; (7, 6): object $2C
	db $68, $22  ; (8, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $77, $28  ; (7, 7): object $28
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $c5, $23, $df  ; 5 down from (3, 2): object $DF
	db $86, $13, $df  ; 6 across from (3, 1): object $DF
	db $c4, $28, $df  ; 4 down from (8, 2): object $DF
	db $13, $ac  ; (3, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C7 of indoor group B: 23 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $D6 at x 72, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomC7::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $00, $17  ; (0, 0): object $17
	db $01, $12  ; (1, 0): object $12
	db $02, $99  ; (2, 0): object $99
	db $03, $16  ; (3, 0): object $16
	db $c2, $10, $11  ; 2 down from (0, 1): object $11
	db $13, $10  ; (3, 1): object $10
	db $23, $14  ; (3, 2): object $14
	db $12, $9a  ; (2, 1): object $9A
	db $11, $c5  ; (1, 1): object $C5
	db $21, $c6  ; (1, 2): object $C6
	db $04, $25  ; (4, 0): object $25
	db $30, $25  ; (0, 3): object $25
	db $c2, $14, $23  ; 2 down from (4, 1): object $23
	db $83, $31, $21  ; 3 across from (1, 3): object $21
	db $34, $29  ; (4, 3): object $29
	db $32, $98  ; (2, 3): object $98
	db $c3, $41, $20  ; 3 down from (1, 4): object $20
	db $17, $a7  ; (7, 1): object $A7
	db $27, $ce  ; (7, 2): object $CE
	db $57, $ce  ; (7, 5): object $CE
	db $28, $c0  ; (8, 2): object $C0
	db $37, $c0  ; (7, 3): object $C0
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $d6, $48, $50  ; warp type 0 to map $00 room $D6, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C8 of indoor group B: 38 objects, room template 9 and floor object $0D; a warp (type 1) to map $11 room $CA at x 40, y 32. Format: see IndoorBRoomPointers.
IndoorBRoomC8::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $87, $02, $21  ; 7 across from (2, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $04, $26  ; (4, 0): object $26
	db $05, $25  ; (5, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $c3, $14, $24  ; 3 down from (4, 1): object $24
	db $c2, $15, $23  ; 2 down from (5, 1): object $23
	db $19, $24  ; (9, 1): object $24
	db $40, $27  ; (0, 4): object $27
	db $41, $2b  ; (1, 4): object $2B
	db $c3, $50, $23  ; 3 down from (0, 5): object $23
	db $43, $2c  ; (3, 4): object $2C
	db $44, $28  ; (4, 4): object $28
	db $c3, $53, $24  ; 3 down from (3, 5): object $24
	db $35, $27  ; (5, 3): object $27
	db $36, $2b  ; (6, 3): object $2B
	db $46, $23  ; (6, 4): object $23
	db $55, $25  ; (5, 5): object $25
	db $56, $29  ; (6, 5): object $29
	db $c2, $65, $23  ; 2 down from (5, 6): object $23
	db $28, $2c  ; (8, 2): object $2C
	db $29, $28  ; (9, 2): object $28
	db $c4, $38, $24  ; 4 down from (8, 3): object $24
	db $77, $2c  ; (7, 7): object $2C
	db $78, $28  ; (8, 7): object $28
	db $c4, $50, $00  ; 4 down from (0, 5): object $00
	db $45, $00  ; (5, 4): object $00
	db $c3, $54, $00  ; 3 down from (4, 5): object $00
	db $c5, $39, $00  ; 5 down from (9, 3): object $00
	db $22, $a0  ; (2, 2): object $A0
	db $52, $ae  ; (2, 5): object $AE
	db $62, $a7  ; (2, 6): object $A7
	db $c2, $20, $23  ; 2 down from (0, 2): object $23
	db $c3, $51, $23  ; 3 down from (1, 5): object $23
	db $18, $cb  ; (8, 1): object $CB
	db $e1, $11, $ca, $28, $20  ; warp type 1 to map $11 room $CA, x 40 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C9 of indoor group B: 36 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $C6 at x 56, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomC9::
	db $04, $90  ; animated tiles $04, template 9, floor $00
	db $84, $46, $05  ; 4 across from (6, 4): object $05
	db $84, $56, $05  ; 4 across from (6, 5): object $05
	db $84, $66, $05  ; 4 across from (6, 6): object $05
	db $c6, $00, $24  ; 6 down from (0, 0): object $24
	db $60, $2a  ; (0, 6): object $2A
	db $82, $61, $21  ; 2 across from (1, 6): object $21
	db $63, $29  ; (3, 6): object $29
	db $03, $25  ; (3, 0): object $25
	db $12, $25  ; (2, 1): object $25
	db $13, $29  ; (3, 1): object $29
	db $c2, $22, $23  ; 2 down from (2, 2): object $23
	db $42, $27  ; (2, 4): object $27
	db $43, $2b  ; (3, 4): object $2B
	db $53, $23  ; (3, 5): object $23
	db $86, $04, $21  ; 6 across from (4, 0): object $21
	db $35, $25  ; (5, 3): object $25
	db $44, $25  ; (4, 4): object $25
	db $45, $29  ; (5, 4): object $29
	db $84, $36, $21  ; 4 across from (6, 3): object $21
	db $37, $98  ; (7, 3): object $98
	db $c2, $54, $23  ; 2 down from (4, 5): object $23
	db $74, $27  ; (4, 7): object $27
	db $85, $75, $22  ; 5 across from (5, 7): object $22
	db $85, $25, $13  ; 5 across from (5, 2): object $13
	db $86, $14, $0d  ; 6 across from (4, 1): object $0D
	db $82, $23, $0d  ; 2 across from (3, 2): object $0D
	db $27, $0d  ; (7, 2): object $0D
	db $34, $ac  ; (4, 3): object $AC
	db $82, $47, $0d  ; 2 across from (7, 4): object $0D
	db $55, $0d  ; (5, 5): object $0D
	db $57, $0d  ; (7, 5): object $0D
	db $58, $0f  ; (8, 5): object $0F
	db $82, $65, $0d  ; 2 across from (5, 6): object $0D
	db $68, $0d  ; (8, 6): object $0D
	db $33, $0d  ; (3, 3): object $0D
	db $77, $fd  ; (7, 7): object $FD
	db $e0, $00, $c6, $38, $50  ; warp type 0 to map $00 room $C6, x 56 y 80
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $CA of indoor group B: 30 objects, room template 9 and floor object $00; a warp (type 1) to map $11 room $C8 at x 136, y 32. Format: see IndoorBRoomPointers.
IndoorBRoomCA::
	db $04, $90  ; animated tiles $04, template 9, floor $00
	db $88, $40, $05  ; 8 across from (0, 4): object $05
	db $88, $50, $05  ; 8 across from (0, 5): object $05
	db $88, $60, $05  ; 8 across from (0, 6): object $05
	db $88, $70, $05  ; 8 across from (0, 7): object $05
	db $83, $00, $21  ; 3 across from (0, 0): object $21
	db $03, $26  ; (3, 0): object $26
	db $13, $2a  ; (3, 1): object $2A
	db $14, $26  ; (4, 1): object $26
	db $24, $2a  ; (4, 2): object $2A
	db $25, $21  ; (5, 2): object $21
	db $c2, $06, $23  ; 2 down from (6, 0): object $23
	db $26, $29  ; (6, 2): object $29
	db $11, $0d  ; (1, 1): object $0D
	db $84, $20, $13  ; 4 across from (0, 2): object $13
	db $87, $30, $21  ; 7 across from (0, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $47, $2a  ; (7, 4): object $2A
	db $48, $26  ; (8, 4): object $26
	db $c2, $58, $24  ; 2 down from (8, 5): object $24
	db $88, $70, $22  ; 8 across from (0, 7): object $22
	db $40, $0d  ; (0, 4): object $0D
	db $42, $0d  ; (2, 4): object $0D
	db $46, $0d  ; (6, 4): object $0D
	db $82, $54, $0d  ; 2 across from (4, 5): object $0D
	db $62, $0d  ; (2, 6): object $0D
	db $83, $65, $0d  ; 3 across from (5, 6): object $0D
	db $43, $0f  ; (3, 4): object $0F
	db $66, $0f  ; (6, 6): object $0F
	db $78, $28  ; (8, 7): object $28
	db $12, $be  ; (2, 1): object $BE
	db $e1, $11, $c8, $88, $20  ; warp type 1 to map $11 room $C8, x 136 y 32
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $CB of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $B2 at x 88, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomCB::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $b2, $58, $52  ; warp type 0 to map $00 room $B2, x 88 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CC of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $4B at x 72, y 34. Format: see IndoorBRoomPointers.
IndoorBRoomCC::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $4b, $48, $22  ; warp type 0 to map $00 room $4B, x 72 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CD of indoor group B: 28 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $84 at x 152, y 98. Format: see IndoorBRoomPointers.
IndoorBRoomCD::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $12, $df  ; (2, 1): object $DF
	db $82, $14, $05  ; 2 across from (4, 1): object $05
	db $16, $a7  ; (6, 1): object $A7
	db $25, $a7  ; (5, 2): object $A7
	db $34, $a7  ; (4, 3): object $A7
	db $36, $a7  ; (6, 3): object $A7
	db $45, $a7  ; (5, 4): object $A7
	db $53, $a7  ; (3, 5): object $A7
	db $55, $a7  ; (5, 5): object $A7
	db $66, $a7  ; (6, 6): object $A7
	db $21, $0f  ; (1, 2): object $0F
	db $23, $05  ; (3, 2): object $05
	db $24, $a0  ; (4, 2): object $A0
	db $26, $df  ; (6, 2): object $DF
	db $27, $0f  ; (7, 2): object $0F
	db $28, $20  ; (8, 2): object $20
	db $32, $05  ; (2, 3): object $05
	db $33, $df  ; (3, 3): object $DF
	db $35, $05  ; (5, 3): object $05
	db $43, $0f  ; (3, 4): object $0F
	db $44, $df  ; (4, 4): object $DF
	db $46, $05  ; (6, 4): object $05
	db $48, $0f  ; (8, 4): object $0F
	db $51, $05  ; (1, 5): object $05
	db $61, $20  ; (1, 6): object $20
	db $62, $05  ; (2, 6): object $05
	db $68, $05  ; (8, 6): object $05
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $84, $98, $62  ; warp type 0 to map $00 room $84, x 152 y 98
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CE of indoor group B: 30 objects, room template 5 and floor object $0D; a warp (type 1) to map $13 room $AA at x 72, y 72. Format: see IndoorBRoomPointers.
IndoorBRoomCE::
	db $04, $5d  ; animated tiles $04, template 5, floor $0D
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $c4, $11, $df  ; 4 down from (1, 1): object $DF
	db $c5, $02, $24  ; 5 down from (2, 0): object $24
	db $c4, $03, $11  ; 4 down from (3, 0): object $11
	db $c2, $05, $24  ; 2 down from (5, 0): object $24
	db $06, $11  ; (6, 0): object $11
	db $83, $07, $0f  ; 3 across from (7, 0): object $0F
	db $52, $2a  ; (2, 5): object $2A
	db $43, $15  ; (3, 4): object $15
	db $86, $44, $13  ; 6 across from (4, 4): object $13
	db $66, $ac  ; (6, 6): object $AC
	db $c2, $05, $24  ; 2 down from (5, 0): object $24
	db $25, $2a  ; (5, 2): object $2A
	db $84, $26, $21  ; 4 across from (6, 2): object $21
	db $16, $ac  ; (6, 1): object $AC
	db $83, $17, $13  ; 3 across from (7, 1): object $13
	db $18, $0d  ; (8, 1): object $0D
	db $83, $07, $0f  ; 3 across from (7, 0): object $0F
	db $28, $98  ; (8, 2): object $98
	db $87, $53, $21  ; 7 across from (3, 5): object $21
	db $09, $10  ; (9, 0): object $10
	db $19, $14  ; (9, 1): object $14
	db $39, $10  ; (9, 3): object $10
	db $44, $95  ; (4, 4): object $95
	db $45, $96  ; (5, 4): object $96
	db $47, $0d  ; (7, 4): object $0D
	db $49, $14  ; (9, 4): object $14
	db $57, $98  ; (7, 5): object $98
	db $74, $fd  ; (4, 7): object $FD
	db $e1, $13, $aa, $48, $48  ; warp type 1 to map $13 room $AA, x 72 y 72
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CF of indoor group B: 23 objects, room template 6 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomCF::
	db $04, $6d  ; animated tiles $04, template 6, floor $0D
	db $83, $00, $0f  ; 3 across from (0, 0): object $0F
	db $03, $10  ; (3, 0): object $10
	db $c2, $04, $23  ; 2 down from (4, 0): object $23
	db $c4, $06, $10  ; 4 down from (6, 0): object $10
	db $c5, $07, $23  ; 5 down from (7, 0): object $23
	db $c4, $18, $df  ; 4 down from (8, 1): object $DF
	db $86, $40, $13  ; 6 across from (0, 4): object $13
	db $42, $0d  ; (2, 4): object $0D
	db $87, $50, $21  ; 7 across from (0, 5): object $21
	db $52, $98  ; (2, 5): object $98
	db $46, $14  ; (6, 4): object $14
	db $24, $29  ; (4, 2): object $29
	db $57, $29  ; (7, 5): object $29
	db $13, $ac  ; (3, 1): object $AC
	db $84, $20, $21  ; 4 across from (0, 2): object $21
	db $83, $10, $13  ; 3 across from (0, 1): object $13
	db $11, $0d  ; (1, 1): object $0D
	db $00, $11  ; (0, 0): object $11
	db $10, $15  ; (0, 1): object $15
	db $21, $98  ; (1, 2): object $98
	db $30, $11  ; (0, 3): object $11
	db $40, $15  ; (0, 4): object $15
	db $61, $4e  ; (1, 6): object $4E
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D0 of indoor group B: 28 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $AA at x 136, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomD0::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $86, $21, $05  ; 6 across from (1, 2): object $05
	db $86, $31, $05  ; 6 across from (1, 3): object $05
	db $85, $41, $05  ; 5 across from (1, 4): object $05
	db $84, $51, $05  ; 4 across from (1, 5): object $05
	db $11, $25  ; (1, 1): object $25
	db $86, $12, $21  ; 6 across from (2, 1): object $21
	db $18, $26  ; (8, 1): object $26
	db $13, $c7  ; (3, 1): object $C7
	db $16, $c7  ; (6, 1): object $C7
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $28, $2a  ; (8, 2): object $2A
	db $29, $21  ; (9, 2): object $21
	db $c2, $30, $23  ; 2 down from (0, 3): object $23
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $58, $2c  ; (8, 5): object $2C
	db $59, $22  ; (9, 5): object $22
	db $61, $27  ; (1, 6): object $27
	db $86, $62, $22  ; 6 across from (2, 6): object $22
	db $63, $c8  ; (3, 6): object $C8
	db $66, $c8  ; (6, 6): object $C8
	db $68, $28  ; (8, 6): object $28
	db $27, $1b  ; (7, 2): object $1B
	db $83, $37, $1b  ; 3 across from (7, 3): object $1B
	db $84, $46, $1b  ; 4 across from (6, 4): object $1B
	db $83, $55, $1b  ; 3 across from (5, 5): object $1B
	db $32, $cb  ; (2, 3): object $CB
	db $e0, $00, $aa, $88, $40  ; warp type 0 to map $00 room $AA, x 136 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D1 of indoor group B: 32 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $AB at x 120, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomD1::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $88, $20, $1b  ; 8 across from (0, 2): object $1B
	db $88, $30, $1b  ; 8 across from (0, 3): object $1B
	db $88, $40, $1b  ; 8 across from (0, 4): object $1B
	db $88, $50, $1b  ; 8 across from (0, 5): object $1B
	db $83, $41, $0e  ; 3 across from (1, 4): object $0E
	db $83, $52, $0e  ; 3 across from (2, 5): object $0E
	db $83, $36, $05  ; 3 across from (6, 3): object $05
	db $83, $46, $05  ; 3 across from (6, 4): object $05
	db $57, $05  ; (7, 5): object $05
	db $c2, $25, $4e  ; 2 down from (5, 2): object $4E
	db $46, $4e  ; (6, 4): object $4E
	db $57, $4e  ; (7, 5): object $4E
	db $11, $25  ; (1, 1): object $25
	db $86, $12, $21  ; 6 across from (2, 1): object $21
	db $13, $c7  ; (3, 1): object $C7
	db $16, $c7  ; (6, 1): object $C7
	db $18, $26  ; (8, 1): object $26
	db $20, $21  ; (0, 2): object $21
	db $21, $29  ; (1, 2): object $29
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $c2, $39, $24  ; 2 down from (9, 3): object $24
	db $50, $22  ; (0, 5): object $22
	db $51, $2b  ; (1, 5): object $2B
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $61, $27  ; (1, 6): object $27
	db $86, $62, $22  ; 6 across from (2, 6): object $22
	db $63, $c8  ; (3, 6): object $C8
	db $66, $c8  ; (6, 6): object $C8
	db $68, $28  ; (8, 6): object $28
	db $37, $cb  ; (7, 3): object $CB
	db $e0, $00, $ab, $78, $50  ; warp type 0 to map $00 room $AB, x 120 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D2 of indoor group B: 9 objects, room template 9 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomD2::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $c4, $00, $23  ; 4 down from (0, 0): object $23
	db $40, $27  ; (0, 4): object $27
	db $89, $41, $22  ; 9 across from (1, 4): object $22
	db $8a, $50, $03  ; 10 across from (0, 5): object $03
	db $8a, $60, $03  ; 10 across from (0, 6): object $03
	db $8a, $70, $03  ; 10 across from (0, 7): object $03
	db $03, $c0  ; (3, 0): object $C0
	db $06, $c0  ; (6, 0): object $C0
	db $09, $2a  ; (9, 0): object $2A
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D3 of indoor group B: 15 objects, room template 4 and floor object $0D; a warp (type 0) to overworld room $69 at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomD3::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $13, $c0  ; (3, 1): object $C0
	db $16, $c0  ; (6, 1): object $C0
	db $40, $22  ; (0, 4): object $22
	db $41, $2b  ; (1, 4): object $2B
	db $c2, $51, $23  ; 2 down from (1, 5): object $23
	db $71, $27  ; (1, 7): object $27
	db $48, $2c  ; (8, 4): object $2C
	db $49, $28  ; (9, 4): object $28
	db $c2, $58, $24  ; 2 down from (8, 5): object $24
	db $78, $28  ; (8, 7): object $28
	db $c3, $50, $03  ; 3 down from (0, 5): object $03
	db $c3, $59, $03  ; 3 down from (9, 5): object $03
	db $c3, $42, $ac  ; 3 down from (2, 4): object $AC
	db $c3, $47, $ac  ; 3 down from (7, 4): object $AC
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $69, $58, $40  ; warp type 0 to map $00 room $69, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D4 of indoor group B: 29 objects, room template 5 and floor object $03; a warp (type 1) to map $14 room $C3 at x 40, y 16. Format: see IndoorBRoomPointers.
IndoorBRoomD4::
	db $04, $53  ; animated tiles $04, template 5, floor $03
	db $04, $0d  ; (4, 0): object $0D
	db $82, $13, $0d  ; 2 across from (3, 1): object $0D
	db $02, $21  ; (2, 0): object $21
	db $c3, $00, $03  ; 3 down from (0, 0): object $03
	db $30, $25  ; (0, 3): object $25
	db $31, $29  ; (1, 3): object $29
	db $c2, $11, $23  ; 2 down from (1, 1): object $23
	db $01, $25  ; (1, 0): object $25
	db $03, $29  ; (3, 0): object $29
	db $c2, $05, $24  ; 2 down from (5, 0): object $24
	db $23, $2c  ; (3, 2): object $2C
	db $24, $22  ; (4, 2): object $22
	db $25, $28  ; (5, 2): object $28
	db $33, $24  ; (3, 3): object $24
	db $43, $2a  ; (3, 4): object $2A
	db $44, $26  ; (4, 4): object $26
	db $c2, $54, $24  ; 2 down from (4, 5): object $24
	db $74, $28  ; (4, 7): object $28
	db $c4, $12, $0d  ; 4 down from (2, 1): object $0D
	db $83, $51, $0d  ; 3 across from (1, 5): object $0D
	db $83, $61, $0d  ; 3 across from (1, 6): object $0D
	db $41, $ab  ; (1, 4): object $AB
	db $85, $75, $03  ; 5 across from (5, 7): object $03
	db $04, $07  ; (4, 0): object $07
	db $82, $13, $07  ; 2 across from (3, 1): object $07
	db $c4, $12, $07  ; 4 down from (2, 1): object $07
	db $83, $51, $07  ; 3 across from (1, 5): object $07
	db $83, $61, $07  ; 3 across from (1, 6): object $07
	db $63, $cb  ; (3, 6): object $CB
	db $e1, $14, $c3, $28, $10  ; warp type 1 to map $14 room $C3, x 40 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D5 of indoor group B: 16 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $59 at x 24, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomD5::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $00, $17  ; (0, 0): object $17
	db $89, $01, $12  ; 9 across from (1, 0): object $12
	db $10, $15  ; (0, 1): object $15
	db $89, $11, $13  ; 9 across from (1, 1): object $13
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $20, $25  ; (0, 2): object $25
	db $88, $21, $21  ; 8 across from (1, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $31, $c0  ; (1, 3): object $C0
	db $38, $c0  ; (8, 3): object $C0
	db $82, $34, $0f  ; 2 across from (4, 3): object $0F
	db $82, $44, $0f  ; 2 across from (4, 4): object $0F
	db $62, $ac  ; (2, 6): object $AC
	db $67, $ac  ; (7, 6): object $AC
	db $82, $24, $97  ; 2 across from (4, 2): object $97
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $59, $18, $30  ; warp type 0 to map $00 room $59, x 24 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D6 of indoor group B: 29 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $59 at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomD6::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $00, $93  ; (0, 0): object $93
	db $01, $10  ; (1, 0): object $10
	db $10, $13  ; (0, 1): object $13
	db $11, $14  ; (1, 1): object $14
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $82, $18, $03  ; 2 across from (8, 1): object $03
	db $20, $25  ; (0, 2): object $25
	db $21, $21  ; (1, 2): object $21
	db $22, $29  ; (2, 2): object $29
	db $12, $23  ; (2, 1): object $23
	db $17, $24  ; (7, 1): object $24
	db $27, $2a  ; (7, 2): object $2A
	db $28, $21  ; (8, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $c4, $14, $0f  ; 4 down from (4, 1): object $0F
	db $c4, $15, $0f  ; 4 down from (5, 1): object $0F
	db $23, $20  ; (3, 2): object $20
	db $26, $20  ; (6, 2): object $20
	db $82, $31, $20  ; 2 across from (1, 3): object $20
	db $82, $37, $20  ; 2 across from (7, 3): object $20
	db $41, $20  ; (1, 4): object $20
	db $48, $20  ; (8, 4): object $20
	db $62, $ac  ; (2, 6): object $AC
	db $67, $ac  ; (7, 6): object $AC
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $59, $58, $40  ; warp type 0 to map $00 room $59, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D7 of indoor group B: 16 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $DD at x 88, y 66. Format: see IndoorBRoomPointers.
IndoorBRoomD7::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $82, $05, $99  ; 2 across from (5, 0): object $99
	db $83, $11, $20  ; 3 across from (1, 1): object $20
	db $82, $15, $9a  ; 2 across from (5, 1): object $9A
	db $82, $17, $c5  ; 2 across from (7, 1): object $C5
	db $82, $27, $c6  ; 2 across from (7, 2): object $C6
	db $82, $31, $c0  ; 2 across from (1, 3): object $C0
	db $41, $9b  ; (1, 4): object $9B
	db $42, $9c  ; (2, 4): object $9C
	db $45, $9b  ; (5, 4): object $9B
	db $46, $9c  ; (6, 4): object $9C
	db $47, $9b  ; (7, 4): object $9B
	db $48, $9c  ; (8, 4): object $9C
	db $82, $51, $c0  ; 2 across from (1, 5): object $C0
	db $84, $55, $c0  ; 4 across from (5, 5): object $C0
	db $84, $63, $0f  ; 4 across from (3, 6): object $0F
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $dd, $58, $42  ; warp type 0 to map $00 room $DD, x 88 y 66
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $D8 of indoor group B: 31 objects, room template 9 and floor object $00; a warp (type 1) to map $10 room $C7 at x 104, y 50. Format: see IndoorBRoomPointers.
IndoorBRoomD8::
	db $04, $90  ; animated tiles $04, template 9, floor $00
	db $c2, $01, $23  ; 2 down from (1, 0): object $23
	db $21, $27  ; (1, 2): object $27
	db $83, $22, $22  ; 3 across from (2, 2): object $22
	db $25, $2b  ; (5, 2): object $2B
	db $35, $27  ; (5, 3): object $27
	db $36, $2b  ; (6, 3): object $2B
	db $46, $23  ; (6, 4): object $23
	db $55, $25  ; (5, 5): object $25
	db $56, $29  ; (6, 5): object $29
	db $65, $23  ; (5, 6): object $23
	db $75, $27  ; (5, 7): object $27
	db $83, $76, $22  ; 3 across from (6, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $85, $02, $0d  ; 5 across from (2, 0): object $0D
	db $03, $2a  ; (3, 0): object $2A
	db $04, $21  ; (4, 0): object $21
	db $05, $29  ; (5, 0): object $29
	db $07, $24  ; (7, 0): object $24
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $c2, $28, $24  ; 2 down from (8, 2): object $24
	db $48, $2a  ; (8, 4): object $2A
	db $49, $26  ; (9, 4): object $26
	db $c2, $59, $24  ; 2 down from (9, 5): object $24
	db $85, $12, $0d  ; 5 across from (2, 1): object $0D
	db $26, $0d  ; (6, 2): object $0D
	db $c4, $27, $0d  ; 4 down from (7, 2): object $0D
	db $58, $0d  ; (8, 5): object $0D
	db $82, $66, $0d  ; 2 across from (6, 6): object $0D
	db $13, $0f  ; (3, 1): object $0F
	db $68, $cb  ; (8, 6): object $CB
	db $e1, $10, $c7, $68, $32  ; warp type 1 to map $10 room $C7, x 104 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D9 of indoor group B: 18 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $CD at x 40, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomD9::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $83, $11, $1b  ; 3 across from (1, 1): object $1B
	db $83, $21, $1b  ; 3 across from (1, 2): object $1B
	db $31, $12  ; (1, 3): object $12
	db $33, $12  ; (3, 3): object $12
	db $34, $93  ; (4, 3): object $93
	db $c2, $14, $11  ; 2 down from (4, 1): object $11
	db $c3, $17, $0f  ; 3 down from (7, 1): object $0F
	db $c3, $18, $0f  ; 3 down from (8, 1): object $0F
	db $18, $c5  ; (8, 1): object $C5
	db $28, $c6  ; (8, 2): object $C6
	db $c3, $41, $20  ; 3 down from (1, 4): object $20
	db $c3, $42, $20  ; 3 down from (2, 4): object $20
	db $56, $9b  ; (6, 5): object $9B
	db $57, $9c  ; (7, 5): object $9C
	db $58, $ce  ; (8, 5): object $CE
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $cd, $28, $50  ; warp type 0 to map $00 room $CD, x 40 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DA of indoor group B: 18 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $CD at x 88, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomDA::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $c4, $11, $0f  ; 4 down from (1, 1): object $0F
	db $c4, $12, $0f  ; 4 down from (2, 1): object $0F
	db $c2, $15, $10  ; 2 down from (5, 1): object $10
	db $83, $16, $1b  ; 3 across from (6, 1): object $1B
	db $83, $26, $1b  ; 3 across from (6, 2): object $1B
	db $82, $26, $1b  ; 2 across from (6, 2): object $1B
	db $36, $12  ; (6, 3): object $12
	db $38, $12  ; (8, 3): object $12
	db $35, $94  ; (5, 3): object $94
	db $21, $c5  ; (1, 2): object $C5
	db $31, $c6  ; (1, 3): object $C6
	db $c3, $47, $20  ; 3 down from (7, 4): object $20
	db $c3, $48, $20  ; 3 down from (8, 4): object $20
	db $83, $51, $c0  ; 3 across from (1, 5): object $C0
	db $52, $ce  ; (2, 5): object $CE
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $cd, $58, $50  ; warp type 0 to map $00 room $CD, x 88 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DB of indoor group B: 16 objects, room template 2 and floor object $0D; a warp (type 0) to overworld room $CC at x 40, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomDB::
	db $0c, $2d  ; animated tiles $0C, template 2, floor $0D
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $c2, $11, $10  ; 2 down from (1, 1): object $10
	db $c2, $18, $11  ; 2 down from (8, 1): object $11
	db $82, $32, $12  ; 2 across from (2, 3): object $12
	db $82, $36, $12  ; 2 across from (6, 3): object $12
	db $31, $94  ; (1, 3): object $94
	db $38, $93  ; (8, 3): object $93
	db $86, $12, $1b  ; 6 across from (2, 1): object $1B
	db $86, $22, $1b  ; 6 across from (2, 2): object $1B
	db $83, $41, $20  ; 3 across from (1, 4): object $20
	db $83, $51, $20  ; 3 across from (1, 5): object $20
	db $83, $61, $20  ; 3 across from (1, 6): object $20
	db $83, $56, $c0  ; 3 across from (6, 5): object $C0
	db $57, $ce  ; (7, 5): object $CE
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $cc, $28, $50  ; warp type 0 to map $00 room $CC, x 40 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DC of indoor group B: 13 objects, room template 4 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomDC::
	db $0c, $4d  ; animated tiles $0C, template 4, floor $0D
	db $06, $26  ; (6, 0): object $26
	db $c6, $16, $24  ; 6 down from (6, 1): object $24
	db $76, $28  ; (6, 7): object $28
	db $c8, $07, $03  ; 8 down from (7, 0): object $03
	db $c8, $08, $03  ; 8 down from (8, 0): object $03
	db $c8, $09, $03  ; 8 down from (9, 0): object $03
	db $84, $12, $c5  ; 4 across from (2, 1): object $C5
	db $84, $22, $c6  ; 4 across from (2, 2): object $C6
	db $82, $43, $c0  ; 2 across from (3, 4): object $C0
	db $84, $52, $c0  ; 4 across from (2, 5): object $C0
	db $82, $63, $c0  ; 2 across from (3, 6): object $C0
	db $53, $9b  ; (3, 5): object $9B
	db $54, $9c  ; (4, 5): object $9C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DD of indoor group B: 18 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $CC at x 120, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomDD::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $83, $04, $99  ; 3 across from (4, 0): object $99
	db $83, $14, $9a  ; 3 across from (4, 1): object $9A
	db $82, $17, $c0  ; 2 across from (7, 1): object $C0
	db $27, $20  ; (7, 2): object $20
	db $28, $a6  ; (8, 2): object $A6
	db $38, $c0  ; (8, 3): object $C0
	db $83, $41, $0f  ; 3 across from (1, 4): object $0F
	db $47, $9b  ; (7, 4): object $9B
	db $48, $9c  ; (8, 4): object $9C
	db $83, $51, $0f  ; 3 across from (1, 5): object $0F
	db $51, $c5  ; (1, 5): object $C5
	db $52, $ce  ; (2, 5): object $CE
	db $58, $20  ; (8, 5): object $20
	db $83, $61, $0f  ; 3 across from (1, 6): object $0F
	db $61, $c6  ; (1, 6): object $C6
	db $66, $a6  ; (6, 6): object $A6
	db $82, $67, $20  ; 2 across from (7, 6): object $20
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $cc, $78, $50  ; warp type 0 to map $00 room $CC, x 120 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DE of indoor group B: 26 objects, room template 2 and floor object $05; a warp (type 0) to overworld room $75 at x 56, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomDE::
	db $04, $25  ; animated tiles $04, template 2, floor $05
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $06, $26  ; (6, 0): object $26
	db $83, $07, $00  ; 3 across from (7, 0): object $00
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $12, $af  ; (2, 1): object $AF
	db $83, $13, $ae  ; 3 across from (3, 1): object $AE
	db $16, $2a  ; (6, 1): object $2A
	db $83, $17, $21  ; 3 across from (7, 1): object $21
	db $21, $af  ; (1, 2): object $AF
	db $22, $b0  ; (2, 2): object $B0
	db $84, $26, $ae  ; 4 across from (6, 2): object $AE
	db $c2, $31, $01  ; 2 down from (1, 3): object $01
	db $44, $ae  ; (4, 4): object $AE
	db $47, $ae  ; (7, 4): object $AE
	db $51, $b0  ; (1, 5): object $B0
	db $52, $af  ; (2, 5): object $AF
	db $55, $ae  ; (5, 5): object $AE
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $62, $b0  ; (2, 6): object $B0
	db $87, $63, $ae  ; 7 across from (3, 6): object $AE
	db $70, $0d  ; (0, 7): object $0D
	db $71, $27  ; (1, 7): object $27
	db $33, $cb  ; (3, 3): object $CB
	db $e0, $00, $75, $38, $40  ; warp type 0 to map $00 room $75, x 56 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DF of indoor group B: 38 objects, room template 4 and floor object $05; a warp (type 0) to overworld room $76 at x 104, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomDF::
	db $04, $45  ; animated tiles $04, template 4, floor $05
	db $00, $00  ; (0, 0): object $00
	db $01, $0d  ; (1, 0): object $0D
	db $02, $25  ; (2, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $82, $10, $21  ; 2 across from (0, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $82, $13, $ae  ; 2 across from (3, 1): object $AE
	db $c2, $15, $a7  ; 2 down from (5, 1): object $A7
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $82, $20, $ae  ; 2 across from (0, 2): object $AE
	db $22, $af  ; (2, 2): object $AF
	db $28, $01  ; (8, 2): object $01
	db $c3, $32, $01  ; 3 down from (2, 3): object $01
	db $83, $34, $af  ; 3 across from (4, 3): object $AF
	db $37, $ae  ; (7, 3): object $AE
	db $38, $b0  ; (8, 3): object $B0
	db $43, $a9  ; (3, 4): object $A9
	db $83, $44, $01  ; 3 across from (4, 4): object $01
	db $48, $a7  ; (8, 4): object $A7
	db $51, $af  ; (1, 5): object $AF
	db $53, $af  ; (3, 5): object $AF
	db $54, $01  ; (4, 5): object $01
	db $82, $55, $b0  ; 2 across from (5, 5): object $B0
	db $57, $ae  ; (7, 5): object $AE
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $60, $ae  ; (0, 6): object $AE
	db $84, $61, $b0  ; 4 across from (1, 6): object $B0
	db $65, $2c  ; (5, 6): object $2C
	db $82, $66, $22  ; 2 across from (6, 6): object $22
	db $68, $28  ; (8, 6): object $28
	db $69, $0d  ; (9, 6): object $0D
	db $75, $28  ; (5, 7): object $28
	db $84, $76, $00  ; 4 across from (6, 7): object $00
	db $82, $78, $0d  ; 2 across from (8, 7): object $0D
	db $23, $cb  ; (3, 2): object $CB
	db $e0, $00, $76, $68, $50  ; warp type 0 to map $00 room $76, x 104 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E0 of indoor group B: 14 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomE0::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $39, $f3  ; (9, 3): object $F3
	db $71, $f1  ; (1, 7): object $F1
	db $00, $00  ; (0, 0): object $00
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $12, $df  ; (2, 1): object $DF
	db $c2, $31, $df  ; 2 down from (1, 3): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E1 of indoor group B: 22 objects, room template 0 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomE1::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f2  ; (0, 3): object $F2
	db $39, $f3  ; (9, 3): object $F3
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $00, $00  ; (0, 0): object $00
	db $09, $00  ; (9, 0): object $00
	db $70, $00  ; (0, 7): object $00
	db $79, $00  ; (9, 7): object $00
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $71, $27  ; (1, 7): object $27
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E2 of indoor group B: 31 objects, room template 9 and floor object $0D. Format: see IndoorBRoomPointers.
IndoorBRoomE2::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $85, $00, $00  ; 5 across from (0, 0): object $00
	db $05, $25  ; (5, 0): object $25
	db $82, $06, $21  ; 2 across from (6, 0): object $21
	db $08, $26  ; (8, 0): object $26
	db $09, $00  ; (9, 0): object $00
	db $84, $10, $00  ; 4 across from (0, 1): object $00
	db $14, $25  ; (4, 1): object $25
	db $15, $29  ; (5, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $20, $25  ; (0, 2): object $25
	db $83, $21, $21  ; 3 across from (1, 2): object $21
	db $22, $c7  ; (2, 2): object $C7
	db $24, $29  ; (4, 2): object $29
	db $c4, $29, $24  ; 4 down from (9, 2): object $24
	db $38, $a6  ; (8, 3): object $A6
	db $50, $27  ; (0, 5): object $27
	db $83, $51, $22  ; 3 across from (1, 5): object $22
	db $52, $c8  ; (2, 5): object $C8
	db $54, $2b  ; (4, 5): object $2B
	db $84, $60, $00  ; 4 across from (0, 6): object $00
	db $64, $27  ; (4, 6): object $27
	db $65, $2b  ; (5, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $85, $70, $00  ; 5 across from (0, 7): object $00
	db $75, $27  ; (5, 7): object $27
	db $82, $76, $22  ; 2 across from (6, 7): object $22
	db $78, $28  ; (8, 7): object $28
	db $79, $00  ; (9, 7): object $00
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E3 of indoor group B: 15 objects, room template 9 and floor object $01; a warp (type 0) to overworld room $DB at x 120, y 82. Format: see IndoorBRoomPointers.
IndoorBRoomE3::
	db $04, $91  ; animated tiles $04, template 9, floor $01
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $84, $53, $0d  ; 4 across from (3, 5): object $0D
	db $84, $63, $0d  ; 4 across from (3, 6): object $0D
	db $32, $25  ; (2, 3): object $25
	db $84, $33, $21  ; 4 across from (3, 3): object $21
	db $37, $26  ; (7, 3): object $26
	db $c3, $42, $23  ; 3 down from (2, 4): object $23
	db $72, $27  ; (2, 7): object $27
	db $84, $73, $22  ; 4 across from (3, 7): object $22
	db $c4, $47, $24  ; 4 down from (7, 4): object $24
	db $34, $99  ; (4, 3): object $99
	db $44, $9a  ; (4, 4): object $9A
	db $55, $c0  ; (5, 5): object $C0
	db $77, $28  ; (7, 7): object $28
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $db, $78, $52  ; warp type 0 to map $00 room $DB, x 120 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E4 of indoor group B: 28 objects, room template 3 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoomE4::
	db $0c, $35  ; animated tiles $0C, template 3, floor $05
	db $c5, $00, $00  ; 5 down from (0, 0): object $00
	db $01, $00  ; (1, 0): object $00
	db $c2, $11, $0d  ; 2 down from (1, 1): object $0D
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $08, $0d  ; (8, 0): object $0D
	db $c2, $18, $00  ; 2 down from (8, 1): object $00
	db $c5, $09, $00  ; 5 down from (9, 0): object $00
	db $29, $0d  ; (9, 2): object $0D
	db $c2, $12, $23  ; 2 down from (2, 1): object $23
	db $c2, $17, $24  ; 2 down from (7, 1): object $24
	db $31, $25  ; (1, 3): object $25
	db $32, $29  ; (2, 3): object $29
	db $37, $2a  ; (7, 3): object $2A
	db $38, $26  ; (8, 3): object $26
	db $41, $23  ; (1, 4): object $23
	db $48, $24  ; (8, 4): object $24
	db $50, $25  ; (0, 5): object $25
	db $51, $29  ; (1, 5): object $29
	db $58, $2a  ; (8, 5): object $2A
	db $59, $26  ; (9, 5): object $26
	db $c2, $60, $23  ; 2 down from (0, 6): object $23
	db $c2, $69, $24  ; 2 down from (9, 6): object $24
	db $69, $4a  ; (9, 6): object $4A
	db $c7, $15, $a6  ; 7 down from (5, 1): object $A6
	db $c3, $53, $a6  ; 3 down from (3, 5): object $A6
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E5 of indoor group B: 36 objects, room template 9 and floor object $00. Format: see IndoorBRoomPointers.
IndoorBRoomE5::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $00, $0d  ; (0, 0): object $0D
	db $82, $02, $0d  ; 2 across from (2, 0): object $0D
	db $07, $0d  ; (7, 0): object $0D
	db $11, $0d  ; (1, 1): object $0D
	db $18, $0d  ; (8, 1): object $0D
	db $30, $0d  ; (0, 3): object $0D
	db $41, $0d  ; (1, 4): object $0D
	db $c2, $49, $0d  ; 2 down from (9, 4): object $0D
	db $78, $0d  ; (8, 7): object $0D
	db $13, $25  ; (3, 1): object $25
	db $83, $14, $21  ; 3 across from (4, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $22, $25  ; (2, 2): object $25
	db $23, $29  ; (3, 2): object $29
	db $83, $24, $1b  ; 3 across from (4, 2): object $1B
	db $27, $2a  ; (7, 2): object $2A
	db $28, $26  ; (8, 2): object $26
	db $c2, $32, $23  ; 2 down from (2, 3): object $23
	db $85, $33, $1b  ; 5 across from (3, 3): object $1B
	db $35, $05  ; (5, 3): object $05
	db $c3, $38, $24  ; 3 down from (8, 3): object $24
	db $85, $43, $1b  ; 5 across from (3, 4): object $1B
	db $83, $44, $05  ; 3 across from (4, 4): object $05
	db $50, $25  ; (0, 5): object $25
	db $51, $21  ; (1, 5): object $21
	db $52, $29  ; (2, 5): object $29
	db $85, $53, $1b  ; 5 across from (3, 5): object $1B
	db $55, $05  ; (5, 5): object $05
	db $60, $3e  ; (0, 6): object $3E
	db $83, $61, $05  ; 3 across from (1, 6): object $05
	db $83, $64, $1b  ; 3 across from (4, 6): object $1B
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $70, $27  ; (0, 7): object $27
	db $86, $71, $22  ; 6 across from (1, 7): object $22
	db $77, $28  ; (7, 7): object $28
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E6 of indoor group B: 26 objects, room template 5 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoomE6::
	db $0c, $55  ; animated tiles $0C, template 5, floor $05
	db $84, $00, $21  ; 4 across from (0, 0): object $21
	db $04, $26  ; (4, 0): object $26
	db $85, $05, $00  ; 5 across from (5, 0): object $00
	db $00, $25  ; (0, 0): object $25
	db $14, $2a  ; (4, 1): object $2A
	db $85, $15, $21  ; 5 across from (5, 1): object $21
	db $22, $25  ; (2, 2): object $25
	db $87, $23, $21  ; 7 across from (3, 2): object $21
	db $30, $29  ; (0, 3): object $29
	db $32, $23  ; (2, 3): object $23
	db $39, $05  ; (9, 3): object $05
	db $40, $25  ; (0, 4): object $25
	db $41, $98  ; (1, 4): object $98
	db $42, $29  ; (2, 4): object $29
	db $82, $43, $12  ; 2 across from (3, 4): object $12
	db $45, $2c  ; (5, 4): object $2C
	db $84, $46, $22  ; 4 across from (6, 4): object $22
	db $55, $2a  ; (5, 5): object $2A
	db $83, $56, $21  ; 3 across from (6, 5): object $21
	db $59, $26  ; (9, 5): object $26
	db $62, $a6  ; (2, 6): object $A6
	db $84, $64, $af  ; 4 across from (4, 6): object $AF
	db $63, $a9  ; (3, 6): object $A9
	db $c2, $69, $24  ; 2 down from (9, 6): object $24
	db $77, $2b  ; (7, 7): object $2B
	db $78, $05  ; (8, 7): object $05
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E7 of indoor group B: 32 objects, room template 9 and floor object $00. Format: see IndoorBRoomPointers.
IndoorBRoomE7::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $02, $0d  ; (2, 0): object $0D
	db $82, $05, $0d  ; 2 across from (5, 0): object $0D
	db $86, $10, $21  ; 6 across from (0, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $17, $0d  ; (7, 1): object $0D
	db $85, $20, $21  ; 5 across from (0, 2): object $21
	db $25, $26  ; (5, 2): object $26
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $30, $05  ; (0, 3): object $05
	db $84, $31, $05  ; 4 across from (1, 3): object $05
	db $35, $2a  ; (5, 3): object $2A
	db $36, $26  ; (6, 3): object $26
	db $c3, $37, $24  ; 3 down from (7, 3): object $24
	db $83, $40, $22  ; 3 across from (0, 4): object $22
	db $43, $2b  ; (3, 4): object $2B
	db $82, $44, $05  ; 2 across from (4, 4): object $05
	db $c3, $46, $24  ; 3 down from (6, 4): object $24
	db $c2, $49, $0d  ; 2 down from (9, 4): object $0D
	db $50, $0d  ; (0, 5): object $0D
	db $53, $27  ; (3, 5): object $27
	db $54, $2b  ; (4, 5): object $2B
	db $c2, $55, $05  ; 2 down from (5, 5): object $05
	db $c2, $61, $0d  ; 2 down from (1, 6): object $0D
	db $64, $23  ; (4, 6): object $23
	db $67, $2a  ; (7, 6): object $2A
	db $68, $26  ; (8, 6): object $26
	db $74, $27  ; (4, 7): object $27
	db $75, $40  ; (5, 7): object $40
	db $76, $28  ; (6, 7): object $28
	db $77, $0d  ; (7, 7): object $0D
	db $78, $24  ; (8, 7): object $24
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E8 of indoor group B: 25 objects, room template 9 and floor object $00. Format: see IndoorBRoomPointers.
IndoorBRoomE8::
	db $00, $90  ; animated tiles $00, template 9, floor $00
	db $8a, $00, $03  ; 10 across from (0, 0): object $03
	db $8a, $10, $03  ; 10 across from (0, 1): object $03
	db $8a, $20, $03  ; 10 across from (0, 2): object $03
	db $8a, $30, $03  ; 10 across from (0, 3): object $03
	db $30, $76  ; (0, 3): object $76
	db $35, $75  ; (5, 3): object $75
	db $36, $76  ; (6, 3): object $76
	db $39, $75  ; (9, 3): object $75
	db $41, $76  ; (1, 4): object $76
	db $82, $42, $77  ; 2 across from (2, 4): object $77
	db $44, $75  ; (4, 4): object $75
	db $47, $76  ; (7, 4): object $76
	db $48, $75  ; (8, 4): object $75
	db $52, $6c  ; (2, 5): object $6C
	db $84, $53, $68  ; 4 across from (3, 5): object $68
	db $57, $6d  ; (7, 5): object $6D
	db $63, $6e  ; (3, 6): object $6E
	db $64, $6a  ; (4, 6): object $6A
	db $66, $6f  ; (6, 6): object $6F
	db $72, $e1  ; (2, 7): object $E1
	db $84, $73, $e0  ; 4 across from (3, 7): object $E0
	db $77, $e2  ; (7, 7): object $E2
	db $55, $62  ; (5, 5): object $62
	db $65, $65  ; (5, 6): object $65
	db $75, $62  ; (5, 7): object $62
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E9 of indoor group B: 20 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $8A at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomE9::
	db $0d, $90  ; animated tiles $0D, template 9, floor $00
	db $8a, $00, $61  ; 10 across from (0, 0): object $61
	db $10, $61  ; (0, 1): object $61
	db $20, $61  ; (0, 2): object $61
	db $8a, $70, $61  ; 10 across from (0, 7): object $61
	db $17, $5f  ; (7, 1): object $5F
	db $c7, $18, $69  ; 7 down from (8, 1): object $69
	db $19, $5f  ; (9, 1): object $5F
	db $c5, $27, $61  ; 5 down from (7, 2): object $61
	db $c5, $29, $61  ; 5 down from (9, 2): object $61
	db $37, $5f  ; (7, 3): object $5F
	db $39, $5f  ; (9, 3): object $5F
	db $57, $5f  ; (7, 5): object $5F
	db $59, $5f  ; (9, 5): object $5F
	db $41, $77  ; (1, 4): object $77
	db $42, $77  ; (2, 4): object $77
	db $c2, $51, $76  ; 2 down from (1, 5): object $76
	db $c2, $52, $76  ; 2 down from (2, 5): object $76
	db $86, $11, $7f  ; 6 across from (1, 1): object $7F
	db $22, $7c  ; (2, 2): object $7C
	db $25, $7c  ; (5, 2): object $7C
	db $e0, $00, $8a, $58, $40  ; warp type 0 to map $00 room $8A, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EA of indoor group B: 37 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $15 at x 136, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomEA::
	db $04, $90  ; animated tiles $04, template 9, floor $00
	db $82, $38, $05  ; 2 across from (8, 3): object $05
	db $84, $46, $05  ; 4 across from (6, 4): object $05
	db $84, $54, $05  ; 4 across from (4, 5): object $05
	db $82, $64, $05  ; 2 across from (4, 6): object $05
	db $01, $df  ; (1, 0): object $DF
	db $83, $03, $df  ; 3 across from (3, 0): object $DF
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $13, $df  ; (3, 1): object $DF
	db $85, $15, $df  ; 5 across from (5, 1): object $DF
	db $24, $df  ; (4, 2): object $DF
	db $26, $df  ; (6, 2): object $DF
	db $85, $30, $df  ; 5 across from (0, 3): object $DF
	db $32, $00  ; (2, 3): object $00
	db $40, $df  ; (0, 4): object $DF
	db $50, $df  ; (0, 5): object $DF
	db $52, $df  ; (2, 5): object $DF
	db $61, $df  ; (1, 6): object $DF
	db $70, $df  ; (0, 7): object $DF
	db $27, $25  ; (7, 2): object $25
	db $82, $28, $21  ; 2 across from (8, 2): object $21
	db $35, $25  ; (5, 3): object $25
	db $36, $21  ; (6, 3): object $21
	db $37, $29  ; (7, 3): object $29
	db $43, $25  ; (3, 4): object $25
	db $44, $21  ; (4, 4): object $21
	db $45, $29  ; (5, 4): object $29
	db $c2, $53, $23  ; 2 down from (3, 5): object $23
	db $73, $27  ; (3, 7): object $27
	db $58, $2c  ; (8, 5): object $2C
	db $59, $22  ; (9, 5): object $22
	db $66, $2c  ; (6, 6): object $2C
	db $67, $22  ; (7, 6): object $22
	db $68, $28  ; (8, 6): object $28
	db $76, $28  ; (6, 7): object $28
	db $69, $df  ; (9, 6): object $DF
	db $83, $77, $df  ; 3 across from (7, 7): object $DF
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $15, $88, $40  ; warp type 0 to map $00 room $15, x 136 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EB of indoor group B: 37 objects, room template 9 and floor object $00. Format: see IndoorBRoomPointers.
IndoorBRoomEB::
	db $04, $90  ; animated tiles $04, template 9, floor $00
	db $8a, $30, $05  ; 10 across from (0, 3): object $05
	db $8a, $40, $05  ; 10 across from (0, 4): object $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $27  ; (1, 0): object $27
	db $02, $2b  ; (2, 0): object $2B
	db $c6, $03, $01  ; 6 down from (3, 0): object $01
	db $c8, $04, $01  ; 8 down from (4, 0): object $01
	db $c8, $05, $01  ; 8 down from (5, 0): object $01
	db $c6, $26, $01  ; 6 down from (6, 2): object $01
	db $06, $2a  ; (6, 0): object $2A
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $11, $df  ; (1, 1): object $DF
	db $12, $23  ; (2, 1): object $23
	db $16, $af  ; (6, 1): object $AF
	db $17, $24  ; (7, 1): object $24
	db $19, $df  ; (9, 1): object $DF
	db $82, $20, $21  ; 2 across from (0, 2): object $21
	db $22, $29  ; (2, 2): object $29
	db $27, $2a  ; (7, 2): object $2A
	db $82, $28, $21  ; 2 across from (8, 2): object $21
	db $38, $a7  ; (8, 3): object $A7
	db $41, $a7  ; (1, 4): object $A7
	db $82, $50, $22  ; 2 across from (0, 5): object $22
	db $52, $2b  ; (2, 5): object $2B
	db $57, $2c  ; (7, 5): object $2C
	db $82, $58, $22  ; 2 across from (8, 5): object $22
	db $c2, $61, $df  ; 2 down from (1, 6): object $DF
	db $62, $23  ; (2, 6): object $23
	db $63, $b0  ; (3, 6): object $B0
	db $67, $2a  ; (7, 6): object $2A
	db $68, $26  ; (8, 6): object $26
	db $c2, $69, $df  ; 2 down from (9, 6): object $DF
	db $72, $27  ; (2, 7): object $27
	db $73, $2b  ; (3, 7): object $2B
	db $77, $af  ; (7, 7): object $AF
	db $78, $24  ; (8, 7): object $24
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $EC of indoor group B: 39 objects, room template 9 and floor object $00; a warp (type 1) to map $0A room $ED at x 72, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomEC::
	db $04, $90  ; animated tiles $04, template 9, floor $00
	db $16, $05  ; (6, 1): object $05
	db $87, $21, $05  ; 7 across from (1, 2): object $05
	db $82, $30, $05  ; 2 across from (0, 3): object $05
	db $36, $05  ; (6, 3): object $05
	db $82, $40, $05  ; 2 across from (0, 4): object $05
	db $82, $00, $df  ; 2 across from (0, 0): object $DF
	db $03, $df  ; (3, 0): object $DF
	db $05, $25  ; (5, 0): object $25
	db $06, $21  ; (6, 0): object $21
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $84, $11, $21  ; 4 across from (1, 1): object $21
	db $15, $29  ; (5, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $c6, $19, $df  ; 6 down from (9, 1): object $DF
	db $20, $29  ; (0, 2): object $29
	db $28, $24  ; (8, 2): object $24
	db $32, $2c  ; (2, 3): object $2C
	db $82, $33, $22  ; 2 across from (3, 3): object $22
	db $35, $2b  ; (5, 3): object $2B
	db $37, $2c  ; (7, 3): object $2C
	db $38, $28  ; (8, 3): object $28
	db $39, $00  ; (9, 3): object $00
	db $42, $24  ; (2, 4): object $24
	db $44, $df  ; (4, 4): object $DF
	db $45, $27  ; (5, 4): object $27
	db $46, $22  ; (6, 4): object $22
	db $47, $28  ; (7, 4): object $28
	db $82, $50, $22  ; 2 across from (0, 5): object $22
	db $52, $28  ; (2, 5): object $28
	db $82, $54, $df  ; 2 across from (4, 5): object $DF
	db $83, $60, $df  ; 3 across from (0, 6): object $DF
	db $83, $67, $df  ; 3 across from (7, 6): object $DF
	db $84, $70, $df  ; 4 across from (0, 7): object $DF
	db $75, $df  ; (5, 7): object $DF
	db $82, $77, $df  ; 2 across from (7, 7): object $DF
	db $26, $cb  ; (6, 2): object $CB
	db $e1, $0a, $ed, $48, $40  ; warp type 1 to map $0A room $ED, x 72 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $ED of indoor group B: 42 objects, room template 9 and floor object $05; a warp (type 1) to map $0A room $EC at x 104, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomED::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $c8, $00, $df  ; 8 down from (0, 0): object $DF
	db $01, $df  ; (1, 0): object $DF
	db $02, $25  ; (2, 0): object $25
	db $86, $03, $21  ; 6 across from (3, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $13, $25  ; (3, 1): object $25
	db $14, $21  ; (4, 1): object $21
	db $15, $26  ; (5, 1): object $26
	db $19, $2a  ; (9, 1): object $2A
	db $c3, $21, $23  ; 3 down from (1, 2): object $23
	db $22, $25  ; (2, 2): object $25
	db $23, $29  ; (3, 2): object $29
	db $25, $2a  ; (5, 2): object $2A
	db $26, $21  ; (6, 2): object $21
	db $27, $26  ; (7, 2): object $26
	db $32, $23  ; (2, 3): object $23
	db $37, $24  ; (7, 3): object $24
	db $42, $27  ; (2, 4): object $27
	db $43, $2b  ; (3, 4): object $2B
	db $45, $2c  ; (5, 4): object $2C
	db $46, $22  ; (6, 4): object $22
	db $47, $28  ; (7, 4): object $28
	db $48, $2c  ; (8, 4): object $2C
	db $49, $22  ; (9, 4): object $22
	db $51, $27  ; (1, 5): object $27
	db $52, $2b  ; (2, 5): object $2B
	db $53, $27  ; (3, 5): object $27
	db $54, $22  ; (4, 5): object $22
	db $55, $28  ; (5, 5): object $28
	db $56, $2c  ; (6, 5): object $2C
	db $57, $22  ; (7, 5): object $22
	db $58, $28  ; (8, 5): object $28
	db $59, $df  ; (9, 5): object $DF
	db $61, $df  ; (1, 6): object $DF
	db $62, $27  ; (2, 6): object $27
	db $83, $63, $22  ; 3 across from (3, 6): object $22
	db $66, $28  ; (6, 6): object $28
	db $83, $67, $df  ; 3 across from (7, 6): object $DF
	db $89, $71, $df  ; 9 across from (1, 7): object $DF
	db $34, $be  ; (4, 3): object $BE
	db $e1, $0a, $ec, $68, $30  ; warp type 1 to map $0A room $EC, x 104 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EE of indoor group B: 41 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $07 at x 56, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomEE::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $82, $02, $21  ; 2 across from (2, 0): object $21
	db $04, $26  ; (4, 0): object $26
	db $05, $2a  ; (5, 0): object $2A
	db $06, $21  ; (6, 0): object $21
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $10, $21  ; (0, 1): object $21
	db $11, $29  ; (1, 1): object $29
	db $14, $2a  ; (4, 1): object $2A
	db $15, $26  ; (5, 1): object $26
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $19, $df  ; (9, 1): object $DF
	db $c2, $25, $24  ; 2 down from (5, 2): object $24
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $39, $24  ; (9, 3): object $24
	db $40, $22  ; (0, 4): object $22
	db $41, $2b  ; (1, 4): object $2B
	db $45, $2a  ; (5, 4): object $2A
	db $46, $21  ; (6, 4): object $21
	db $47, $98  ; (7, 4): object $98
	db $48, $26  ; (8, 4): object $26
	db $49, $2a  ; (9, 4): object $2A
	db $c3, $50, $df  ; 3 down from (0, 5): object $DF
	db $51, $23  ; (1, 5): object $23
	db $58, $24  ; (8, 5): object $24
	db $c2, $59, $df  ; 2 down from (9, 5): object $DF
	db $61, $27  ; (1, 6): object $27
	db $62, $2b  ; (2, 6): object $2B
	db $64, $2c  ; (4, 6): object $2C
	db $83, $65, $22  ; 3 across from (5, 6): object $22
	db $68, $28  ; (8, 6): object $28
	db $71, $df  ; (1, 7): object $DF
	db $72, $27  ; (2, 7): object $27
	db $73, $48  ; (3, 7): object $48
	db $74, $28  ; (4, 7): object $28
	db $85, $75, $df  ; 5 across from (5, 7): object $DF
	db $27, $cb  ; (7, 2): object $CB
	db $e0, $00, $07, $38, $50  ; warp type 0 to map $00 room $07, x 56 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EF of indoor group B: 34 objects, room template 9 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoomEF::
	db $04, $95  ; animated tiles $04, template 9, floor $05
	db $8a, $00, $df  ; 10 across from (0, 0): object $DF
	db $02, $25  ; (2, 0): object $25
	db $03, $3d  ; (3, 0): object $3D
	db $04, $26  ; (4, 0): object $26
	db $10, $df  ; (0, 1): object $DF
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $14, $2a  ; (4, 1): object $2A
	db $82, $15, $21  ; 2 across from (5, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $82, $18, $df  ; 2 across from (8, 1): object $DF
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $27, $2a  ; (7, 2): object $2A
	db $28, $21  ; (8, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $c2, $30, $23  ; 2 down from (0, 3): object $23
	db $39, $2a  ; (9, 3): object $2A
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $58, $2c  ; (8, 5): object $2C
	db $59, $22  ; (9, 5): object $22
	db $60, $df  ; (0, 6): object $DF
	db $61, $27  ; (1, 6): object $27
	db $62, $22  ; (2, 6): object $22
	db $63, $2b  ; (3, 6): object $2B
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $69, $df  ; (9, 6): object $DF
	db $83, $70, $df  ; 3 across from (0, 7): object $DF
	db $73, $27  ; (3, 7): object $27
	db $83, $74, $22  ; 3 across from (4, 7): object $22
	db $77, $28  ; (7, 7): object $28
	db $82, $78, $df  ; 2 across from (8, 7): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F0 of indoor group B: 29 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $35 at x 104, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomF0::
	db $04, $05  ; animated tiles $04, template 0, floor $05
	db $01, $f0  ; (1, 0): object $F0
	db $03, $26  ; (3, 0): object $26
	db $82, $04, $ac  ; 2 across from (4, 0): object $AC
	db $06, $25  ; (6, 0): object $25
	db $13, $2a  ; (3, 1): object $2A
	db $82, $14, $21  ; 2 across from (4, 1): object $21
	db $16, $29  ; (6, 1): object $29
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $00  ; (0, 7): object $00
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $00  ; (9, 7): object $00
	db $82, $17, $0d  ; 2 across from (7, 1): object $0D
	db $82, $22, $0d  ; 2 across from (2, 2): object $0D
	db $25, $0d  ; (5, 2): object $0D
	db $27, $0d  ; (7, 2): object $0D
	db $83, $31, $0d  ; 3 across from (1, 3): object $0D
	db $c3, $38, $df  ; 3 down from (8, 3): object $DF
	db $41, $0d  ; (1, 4): object $0D
	db $46, $0d  ; (6, 4): object $0D
	db $82, $51, $0d  ; 2 across from (1, 5): object $0D
	db $55, $0d  ; (5, 5): object $0D
	db $62, $0d  ; (2, 6): object $0D
	db $63, $df  ; (3, 6): object $DF
	db $67, $df  ; (7, 6): object $DF
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $35, $68, $50  ; warp type 0 to map $00 room $35, x 104 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F1 of indoor group B: 31 objects, room template 0 and floor object $05; a warp (type 1) to map $0A room $F3 at x 88, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomF1::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $82, $00, $df  ; 2 across from (0, 0): object $DF
	db $02, $25  ; (2, 0): object $25
	db $05, $29  ; (5, 0): object $29
	db $06, $25  ; (6, 0): object $25
	db $10, $df  ; (0, 1): object $DF
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $16, $23  ; (6, 1): object $23
	db $82, $17, $1b  ; 2 across from (7, 1): object $1B
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $24, $25  ; (4, 2): object $25
	db $25, $98  ; (5, 2): object $98
	db $26, $29  ; (6, 2): object $29
	db $82, $27, $1b  ; 2 across from (7, 2): object $1B
	db $33, $25  ; (3, 3): object $25
	db $34, $29  ; (4, 3): object $29
	db $84, $35, $1b  ; 4 across from (5, 3): object $1B
	db $43, $23  ; (3, 4): object $23
	db $85, $44, $1b  ; 5 across from (4, 4): object $1B
	db $51, $25  ; (1, 5): object $25
	db $52, $21  ; (2, 5): object $21
	db $53, $29  ; (3, 5): object $29
	db $85, $54, $1b  ; 5 across from (4, 5): object $1B
	db $60, $29  ; (0, 6): object $29
	db $61, $23  ; (1, 6): object $23
	db $87, $62, $1b  ; 7 across from (2, 6): object $1B
	db $70, $0d  ; (0, 7): object $0D
	db $71, $27  ; (1, 7): object $27
	db $78, $3d  ; (8, 7): object $3D
	db $23, $cb  ; (3, 2): object $CB
	db $e1, $0a, $f3, $58, $40  ; warp type 1 to map $0A room $F3, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F2 of indoor group B: 37 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $0D at x 24, y 112. Format: see IndoorBRoomPointers.
IndoorBRoomF2::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $df  ; (0, 1): object $DF
	db $11, $23  ; (1, 1): object $23
	db $18, $24  ; (8, 1): object $24
	db $19, $df  ; (9, 1): object $DF
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $23, $a7  ; (3, 2): object $A7
	db $83, $34, $a7  ; 3 across from (4, 3): object $A7
	db $41, $a7  ; (1, 4): object $A7
	db $43, $a7  ; (3, 4): object $A7
	db $82, $46, $a7  ; 2 across from (6, 4): object $A7
	db $52, $a7  ; (2, 5): object $A7
	db $58, $a7  ; (8, 5): object $A7
	db $66, $a7  ; (6, 6): object $A7
	db $13, $a0  ; (3, 1): object $A0
	db $38, $a0  ; (8, 3): object $A0
	db $42, $a0  ; (2, 4): object $A0
	db $54, $a0  ; (4, 5): object $A0
	db $56, $a0  ; (6, 5): object $A0
	db $04, $29  ; (4, 0): object $29
	db $05, $05  ; (5, 0): object $05
	db $06, $2a  ; (6, 0): object $2A
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $0d, $18, $70  ; warp type 0 to map $00 room $0D, x 24 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F3 of indoor group B: 35 objects, room template 9 and floor object $0D; a warp (type 1) to map $0A room $F1 at x 56, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomF3::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $87, $02, $df  ; 7 across from (2, 0): object $DF
	db $87, $12, $df  ; 7 across from (2, 1): object $DF
	db $82, $21, $df  ; 2 across from (1, 2): object $DF
	db $c2, $29, $df  ; 2 down from (9, 2): object $DF
	db $30, $df  ; (0, 3): object $DF
	db $32, $df  ; (2, 3): object $DF
	db $82, $40, $df  ; 2 across from (0, 4): object $DF
	db $c2, $43, $df  ; 2 down from (3, 4): object $DF
	db $48, $df  ; (8, 4): object $DF
	db $51, $df  ; (1, 5): object $DF
	db $82, $58, $df  ; 2 across from (8, 5): object $DF
	db $82, $61, $df  ; 2 across from (1, 6): object $DF
	db $82, $67, $df  ; 2 across from (7, 6): object $DF
	db $70, $df  ; (0, 7): object $DF
	db $72, $df  ; (2, 7): object $DF
	db $77, $df  ; (7, 7): object $DF
	db $79, $df  ; (9, 7): object $DF
	db $c7, $15, $05  ; 7 down from (5, 1): object $05
	db $83, $24, $05  ; 3 across from (4, 2): object $05
	db $04, $25  ; (4, 0): object $25
	db $05, $21  ; (5, 0): object $21
	db $06, $26  ; (6, 0): object $26
	db $13, $25  ; (3, 1): object $25
	db $14, $29  ; (4, 1): object $29
	db $16, $2a  ; (6, 1): object $2A
	db $17, $26  ; (7, 1): object $26
	db $23, $23  ; (3, 2): object $23
	db $27, $24  ; (7, 2): object $24
	db $33, $27  ; (3, 3): object $27
	db $34, $2b  ; (4, 3): object $2B
	db $36, $2c  ; (6, 3): object $2C
	db $37, $28  ; (7, 3): object $28
	db $c4, $44, $23  ; 4 down from (4, 4): object $23
	db $c4, $46, $24  ; 4 down from (6, 4): object $24
	db $25, $be  ; (5, 2): object $BE
	db $e1, $0a, $f1, $38, $30  ; warp type 1 to map $0A room $F1, x 56 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F4 of indoor group B: 18 objects, room template 1 and floor object $05; a warp (type 0) to overworld room $86 at x 24, y 64. Format: see IndoorBRoomPointers.
IndoorBRoomF4::
	db $0c, $15  ; animated tiles $0C, template 1, floor $05
	db $c2, $03, $a6  ; 2 down from (3, 0): object $A6
	db $05, $a6  ; (5, 0): object $A6
	db $85, $23, $a6  ; 5 across from (3, 2): object $A6
	db $85, $31, $4e  ; 5 across from (1, 3): object $4E
	db $37, $a7  ; (7, 3): object $A7
	db $38, $4e  ; (8, 3): object $4E
	db $84, $41, $a6  ; 4 across from (1, 4): object $A6
	db $c3, $46, $a6  ; 3 down from (6, 4): object $A6
	db $48, $a0  ; (8, 4): object $A0
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $0d  ; (0, 7): object $0D
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $73, $fd  ; (3, 7): object $FD
	db $e0, $00, $86, $18, $40  ; warp type 0 to map $00 room $86, x 24 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F5 of indoor group B: 27 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $EA at x 104, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomF5::
	db $05, $90  ; animated tiles $05, template 9, floor $00
	db $8a, $10, $7b  ; 10 across from (0, 1): object $7B
	db $88, $22, $78  ; 8 across from (2, 2): object $78
	db $23, $79  ; (3, 2): object $79
	db $25, $79  ; (5, 2): object $79
	db $27, $79  ; (7, 2): object $79
	db $29, $79  ; (9, 2): object $79
	db $88, $32, $03  ; 8 across from (2, 3): object $03
	db $88, $42, $80  ; 8 across from (2, 4): object $80
	db $88, $52, $81  ; 8 across from (2, 5): object $81
	db $84, $63, $81  ; 4 across from (3, 6): object $81
	db $73, $81  ; (3, 7): object $81
	db $20, $6c  ; (0, 2): object $6C
	db $21, $6d  ; (1, 2): object $6D
	db $30, $60  ; (0, 3): object $60
	db $31, $61  ; (1, 3): object $61
	db $c4, $40, $54  ; 4 down from (0, 4): object $54
	db $c2, $41, $57  ; 2 down from (1, 4): object $57
	db $c2, $61, $54  ; 2 down from (1, 6): object $54
	db $62, $56  ; (2, 6): object $56
	db $72, $54  ; (2, 7): object $54
	db $52, $72  ; (2, 5): object $72
	db $82, $57, $72  ; 2 across from (7, 5): object $72
	db $65, $72  ; (5, 6): object $72
	db $67, $50  ; (7, 6): object $50
	db $82, $68, $53  ; 2 across from (8, 6): object $53
	db $84, $73, $53  ; 4 across from (3, 7): object $53
	db $83, $77, $54  ; 3 across from (7, 7): object $54
	db $e0, $00, $ea, $68, $30  ; warp type 0 to map $00 room $EA, x 104 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F6 of indoor group B: 30 objects, room template 2 and floor object $05. Format: see IndoorBRoomPointers.
IndoorBRoomF6::
	db $0c, $25  ; animated tiles $0C, template 2, floor $05
	db $07, $29  ; (7, 0): object $29
	db $08, $0d  ; (8, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $85, $11, $df  ; 5 across from (1, 1): object $DF
	db $19, $2a  ; (9, 1): object $2A
	db $82, $21, $df  ; 2 across from (1, 2): object $DF
	db $23, $2c  ; (3, 2): object $2C
	db $24, $2b  ; (4, 2): object $2B
	db $28, $ae  ; (8, 2): object $AE
	db $29, $af  ; (9, 2): object $AF
	db $31, $df  ; (1, 3): object $DF
	db $33, $2a  ; (3, 3): object $2A
	db $34, $29  ; (4, 3): object $29
	db $36, $2c  ; (6, 3): object $2C
	db $37, $2b  ; (7, 3): object $2B
	db $39, $b0  ; (9, 3): object $B0
	db $41, $ae  ; (1, 4): object $AE
	db $46, $2a  ; (6, 4): object $2A
	db $47, $29  ; (7, 4): object $29
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $82, $52, $ae  ; 2 across from (2, 5): object $AE
	db $60, $0d  ; (0, 6): object $0D
	db $61, $27  ; (1, 6): object $27
	db $62, $22  ; (2, 6): object $22
	db $63, $2b  ; (3, 6): object $2B
	db $86, $64, $ae  ; 6 across from (4, 6): object $AE
	db $82, $70, $0d  ; 2 across from (0, 7): object $0D
	db $72, $00  ; (2, 7): object $00
	db $73, $27  ; (3, 7): object $27
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F7 of indoor group B: 35 objects, room template 4 and floor object $05; a warp (type 0) to overworld room $CD at x 136, y 32. Format: see IndoorBRoomPointers.
IndoorBRoomF7::
	db $0c, $45  ; animated tiles $0C, template 4, floor $05
	db $82, $00, $00  ; 2 across from (0, 0): object $00
	db $02, $25  ; (2, 0): object $25
	db $05, $47  ; (5, 0): object $47
	db $07, $26  ; (7, 0): object $26
	db $08, $24  ; (8, 0): object $24
	db $09, $00  ; (9, 0): object $00
	db $82, $10, $21  ; 2 across from (0, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $82, $13, $ae  ; 2 across from (3, 1): object $AE
	db $16, $a7  ; (6, 1): object $A7
	db $17, $24  ; (7, 1): object $24
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $83, $20, $af  ; 3 across from (0, 2): object $AF
	db $27, $2a  ; (7, 2): object $2A
	db $28, $26  ; (8, 2): object $26
	db $82, $30, $b0  ; 2 across from (0, 3): object $B0
	db $c3, $32, $01  ; 3 down from (2, 3): object $01
	db $33, $ae  ; (3, 3): object $AE
	db $83, $34, $af  ; 3 across from (4, 3): object $AF
	db $c3, $38, $24  ; 3 down from (8, 3): object $24
	db $44, $b0  ; (4, 4): object $B0
	db $46, $01  ; (6, 4): object $01
	db $45, $b0  ; (5, 4): object $B0
	db $56, $b0  ; (6, 5): object $B0
	db $51, $af  ; (1, 5): object $AF
	db $84, $60, $ae  ; 4 across from (0, 6): object $AE
	db $82, $61, $b0  ; 2 across from (1, 6): object $B0
	db $55, $a7  ; (5, 5): object $A7
	db $64, $a7  ; (4, 6): object $A7
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $77, $28  ; (7, 7): object $28
	db $78, $2c  ; (8, 7): object $2C
	db $75, $fd  ; (5, 7): object $FD
	db $e0, $00, $cd, $88, $20  ; warp type 0 to map $00 room $CD, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F8 of indoor group B: 20 objects, room template 9 and floor object $00; a warp (type 1) to map $06 room $2E at x 24, y 16. Format: see IndoorBRoomPointers.
IndoorBRoomF8::
	db $00, $90  ; animated tiles $00, template 9, floor $00
	db $c4, $02, $e1  ; 4 down from (2, 0): object $E1
	db $84, $03, $e0  ; 4 across from (3, 0): object $E0
	db $84, $13, $e0  ; 4 across from (3, 1): object $E0
	db $84, $23, $e0  ; 4 across from (3, 2): object $E0
	db $84, $33, $e0  ; 4 across from (3, 3): object $E0
	db $c4, $07, $e2  ; 4 down from (7, 0): object $E2
	db $c4, $05, $63  ; 4 down from (5, 0): object $63
	db $43, $70  ; (3, 4): object $70
	db $44, $04  ; (4, 4): object $04
	db $45, $64  ; (5, 4): object $64
	db $46, $71  ; (6, 4): object $71
	db $50, $6c  ; (0, 5): object $6C
	db $88, $51, $68  ; 8 across from (1, 5): object $68
	db $59, $6d  ; (9, 5): object $6D
	db $61, $6e  ; (1, 6): object $6E
	db $86, $62, $6a  ; 6 across from (2, 6): object $6A
	db $68, $6f  ; (8, 6): object $6F
	db $71, $6c  ; (1, 7): object $6C
	db $86, $72, $68  ; 6 across from (2, 7): object $68
	db $78, $6d  ; (8, 7): object $6D
	db $e1, $06, $2e, $18, $10  ; warp type 1 to map $06 room $2E, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F9 of indoor group B: 40 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $1D at x 24, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomF9::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $04, $25  ; (4, 0): object $25
	db $85, $05, $21  ; 5 across from (5, 0): object $21
	db $08, $47  ; (8, 0): object $47
	db $84, $00, $0d  ; 4 across from (0, 0): object $0D
	db $03, $df  ; (3, 0): object $DF
	db $10, $0d  ; (0, 1): object $0D
	db $11, $df  ; (1, 1): object $DF
	db $12, $25  ; (2, 1): object $25
	db $13, $21  ; (3, 1): object $21
	db $14, $29  ; (4, 1): object $29
	db $85, $15, $1b  ; 5 across from (5, 1): object $1B
	db $20, $df  ; (0, 2): object $DF
	db $21, $25  ; (1, 2): object $25
	db $22, $29  ; (2, 2): object $29
	db $87, $23, $1b  ; 7 across from (3, 2): object $1B
	db $30, $0d  ; (0, 3): object $0D
	db $31, $23  ; (1, 3): object $23
	db $83, $32, $1b  ; 3 across from (2, 3): object $1B
	db $35, $2c  ; (5, 3): object $2C
	db $84, $36, $22  ; 4 across from (6, 3): object $22
	db $40, $25  ; (0, 4): object $25
	db $41, $29  ; (1, 4): object $29
	db $82, $42, $1b  ; 2 across from (2, 4): object $1B
	db $44, $2c  ; (4, 4): object $2C
	db $45, $28  ; (5, 4): object $28
	db $49, $df  ; (9, 4): object $DF
	db $c2, $50, $23  ; 2 down from (0, 5): object $23
	db $82, $51, $1b  ; 2 across from (1, 5): object $1B
	db $82, $61, $1b  ; 2 across from (1, 6): object $1B
	db $53, $2c  ; (3, 5): object $2C
	db $54, $28  ; (4, 5): object $28
	db $83, $56, $df  ; 3 across from (6, 5): object $DF
	db $63, $24  ; (3, 6): object $24
	db $85, $65, $df  ; 5 across from (5, 6): object $DF
	db $70, $27  ; (0, 7): object $27
	db $73, $28  ; (3, 7): object $28
	db $82, $74, $df  ; 2 across from (4, 7): object $DF
	db $79, $df  ; (9, 7): object $DF
	db $18, $05  ; (8, 1): object $05
	db $71, $fd  ; (1, 7): object $FD
	db $e0, $00, $1d, $18, $30  ; warp type 0 to map $00 room $1D, x 24 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FA of indoor group B: 34 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $1D at x 120, y 80. Format: see IndoorBRoomPointers.
IndoorBRoomFA::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $85, $00, $21  ; 5 across from (0, 0): object $21
	db $05, $26  ; (5, 0): object $26
	db $15, $2a  ; (5, 1): object $2A
	db $16, $21  ; (6, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $27, $24  ; (7, 2): object $24
	db $37, $2a  ; (7, 3): object $2A
	db $38, $26  ; (8, 3): object $26
	db $c4, $48, $24  ; 4 down from (8, 4): object $24
	db $85, $10, $05  ; 5 across from (0, 1): object $05
	db $83, $20, $1b  ; 3 across from (0, 2): object $1B
	db $84, $23, $05  ; 4 across from (3, 2): object $05
	db $83, $30, $22  ; 3 across from (0, 3): object $22
	db $33, $2b  ; (3, 3): object $2B
	db $83, $34, $05  ; 3 across from (4, 3): object $05
	db $83, $45, $05  ; 3 across from (5, 4): object $05
	db $82, $56, $05  ; 2 across from (6, 5): object $05
	db $82, $66, $05  ; 2 across from (6, 6): object $05
	db $43, $27  ; (3, 4): object $27
	db $44, $2b  ; (4, 4): object $2B
	db $54, $27  ; (4, 5): object $27
	db $55, $2b  ; (5, 5): object $2B
	db $c2, $65, $23  ; 2 down from (5, 6): object $23
	db $40, $df  ; (0, 4): object $DF
	db $82, $51, $df  ; 2 across from (1, 5): object $DF
	db $84, $60, $df  ; 4 across from (0, 6): object $DF
	db $70, $df  ; (0, 7): object $DF
	db $82, $73, $df  ; 2 across from (3, 7): object $DF
	db $84, $06, $df  ; 4 across from (6, 0): object $DF
	db $09, $0d  ; (9, 0): object $0D
	db $c2, $18, $0d  ; 2 down from (8, 1): object $0D
	db $c4, $19, $df  ; 4 down from (9, 1): object $DF
	db $c3, $59, $0d  ; 3 down from (9, 5): object $0D
	db $76, $fd  ; (6, 7): object $FD
	db $e0, $00, $1d, $78, $50  ; warp type 0 to map $00 room $1D, x 120 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FB of indoor group B: 20 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $D4 at x 136, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomFB::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $84, $33, $1b  ; 4 across from (3, 3): object $1B
	db $84, $43, $1b  ; 4 across from (3, 4): object $1B
	db $82, $54, $1b  ; 2 across from (4, 5): object $1B
	db $38, $0f  ; (8, 3): object $0F
	db $62, $0f  ; (2, 6): object $0F
	db $68, $cb  ; (8, 6): object $CB
	db $e0, $00, $d4, $88, $30  ; warp type 0 to map $00 room $D4, x 136 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FC of indoor group B: 42 objects, room template 0 and floor object $05; a warp (type 0) to overworld room $AE at x 72, y 112. Format: see IndoorBRoomPointers.
IndoorBRoomFC::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $00, $0d  ; (0, 0): object $0D
	db $82, $01, $df  ; 2 across from (1, 0): object $DF
	db $82, $03, $0d  ; 2 across from (3, 0): object $0D
	db $82, $05, $df  ; 2 across from (5, 0): object $DF
	db $07, $0d  ; (7, 0): object $0D
	db $82, $08, $df  ; 2 across from (8, 0): object $DF
	db $82, $10, $df  ; 2 across from (0, 1): object $DF
	db $12, $25  ; (2, 1): object $25
	db $83, $13, $21  ; 3 across from (3, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $17, $df  ; (7, 1): object $DF
	db $18, $0d  ; (8, 1): object $0D
	db $19, $df  ; (9, 1): object $DF
	db $20, $df  ; (0, 2): object $DF
	db $21, $25  ; (1, 2): object $25
	db $22, $29  ; (2, 2): object $29
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $82, $28, $df  ; 2 across from (8, 2): object $DF
	db $30, $df  ; (0, 3): object $DF
	db $c2, $31, $23  ; 2 down from (1, 3): object $23
	db $34, $a0  ; (4, 3): object $A0
	db $c3, $37, $24  ; 3 down from (7, 3): object $24
	db $38, $df  ; (8, 3): object $DF
	db $39, $0d  ; (9, 3): object $0D
	db $c2, $40, $0d  ; 2 down from (0, 4): object $0D
	db $48, $0d  ; (8, 4): object $0D
	db $49, $df  ; (9, 4): object $DF
	db $51, $27  ; (1, 5): object $27
	db $52, $2b  ; (2, 5): object $2B
	db $58, $df  ; (8, 5): object $DF
	db $59, $0d  ; (9, 5): object $0D
	db $82, $60, $df  ; 2 across from (0, 6): object $DF
	db $62, $27  ; (2, 6): object $27
	db $84, $63, $22  ; 4 across from (3, 6): object $22
	db $67, $28  ; (7, 6): object $28
	db $82, $68, $df  ; 2 across from (8, 6): object $DF
	db $70, $df  ; (0, 7): object $DF
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $85, $73, $df  ; 5 across from (3, 7): object $DF
	db $82, $78, $0d  ; 2 across from (8, 7): object $0D
	db $56, $cb  ; (6, 5): object $CB
	db $e0, $00, $ae, $48, $70  ; warp type 0 to map $00 room $AE, x 72 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FD of indoor group B: 25 objects, room template 9 and floor object $04; a warp (type 0) to overworld room $2A at x 104, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomFD::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $89, $20, $80  ; 9 across from (0, 2): object $80
	db $89, $30, $81  ; 9 across from (0, 3): object $81
	db $89, $40, $81  ; 9 across from (0, 4): object $81
	db $89, $50, $81  ; 9 across from (0, 5): object $81
	db $89, $60, $81  ; 9 across from (0, 6): object $81
	db $89, $70, $81  ; 9 across from (0, 7): object $81
	db $00, $57  ; (0, 0): object $57
	db $01, $5e  ; (1, 0): object $5E
	db $10, $5e  ; (0, 1): object $5E
	db $06, $5a  ; (6, 0): object $5A
	db $07, $51  ; (7, 0): object $51
	db $c2, $08, $51  ; 2 down from (8, 0): object $51
	db $c8, $09, $51  ; 8 down from (9, 0): object $51
	db $17, $5a  ; (7, 1): object $5A
	db $28, $52  ; (8, 2): object $52
	db $58, $72  ; (8, 5): object $72
	db $60, $56  ; (0, 6): object $56
	db $70, $57  ; (0, 7): object $57
	db $71, $56  ; (1, 7): object $56
	db $73, $72  ; (3, 7): object $72
	db $76, $72  ; (6, 7): object $72
	db $67, $72  ; (7, 6): object $72
	db $68, $50  ; (8, 6): object $50
	db $77, $50  ; (7, 7): object $50
	db $78, $51  ; (8, 7): object $51
	db $e0, $00, $2a, $68, $30  ; warp type 0 to map $00 room $2A, x 104 y 48
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $FE of indoor group B: 18 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $E3 at x 72, y 48. Format: see IndoorBRoomPointers.
IndoorBRoomFE::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $82, $05, $99  ; 2 across from (5, 0): object $99
	db $83, $11, $1b  ; 3 across from (1, 1): object $1B
	db $82, $15, $9a  ; 2 across from (5, 1): object $9A
	db $82, $17, $20  ; 2 across from (7, 1): object $20
	db $83, $21, $1b  ; 3 across from (1, 2): object $1B
	db $28, $20  ; (8, 2): object $20
	db $83, $31, $1b  ; 3 across from (1, 3): object $1B
	db $c3, $14, $11  ; 3 down from (4, 1): object $11
	db $41, $12  ; (1, 4): object $12
	db $43, $12  ; (3, 4): object $12
	db $44, $93  ; (4, 4): object $93
	db $83, $51, $a6  ; 3 across from (1, 5): object $A6
	db $83, $56, $a6  ; 3 across from (6, 5): object $A6
	db $83, $61, $a6  ; 3 across from (1, 6): object $A6
	db $83, $66, $a6  ; 3 across from (6, 6): object $A6
	db $12, $c5  ; (2, 1): object $C5
	db $22, $c6  ; (2, 2): object $C6
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $e3, $48, $30  ; warp type 0 to map $00 room $E3, x 72 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Unused: the pointer of room $FF leads to the free space after the rooms.
IndoorBRoomFF::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
