; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $009", ROMX[$4000], BANK[$9]

;@ path: world/overworld/rooms
;@ The data address of each of the 256 overworld rooms (a 16 x 16 map; room number = row * 16 + column), one word per room. Rooms $00-$7F keep their data in this bank, rooms $80-$FF in bank $1A (the loader, LoadRoom, switches to it). Six rooms have a second layout that replaces this one once bit 4 of a room status byte is set: $06, $0E, $1B (looking at room $2B's byte), $2B, $79 and $8C (OverworldRoom06Alt ...).
;@ Room data format: byte 0 = the room's animated-tiles set (which background tiles animate: water, flowers, torches...; hAnimatedTilesGroup), byte 1 = the floor object: the object that fills every cell the list leaves empty, then a list of entries up to the end byte $FE:
;@ - $E0-$E3 = a warp, 5 bytes: type (the low 2 bits), destination map, destination room, x and y (pixels) where Link appears; the loader copies up to four of them to the warp list at $D401.
;@ - $8N / $CN (bit 7 set, bit 4 clear) = a strip, 3 bytes: N copies of the object going right ($8N) or down ($CN), from position YX, then the object number.
;@ - otherwise 2 bytes: position YX (Y = row 0-7 in the high nibble, X = column 0-9 in the low nibble) and the object number. Objects $F5-$FD are macros that place a group of objects (a tree, a house, a door; OverworldMacroHandlers).
;@ Objects are 16 x 16 pixel blocks; each is drawn from four tiles (OverworldObjectTiles / IndoorObjectTiles in bank $08). The loader (LoadRoom) fills the room's 10 x 8 object grid at $D711 (rows 16 bytes apart) from this list.
OverworldRoomPointers::
	dw OverworldRoom00, OverworldRoom01, OverworldRoom02, OverworldRoom03  ; room $00-$03
	dw OverworldRoom04, OverworldRoom05, OverworldRoom06, OverworldRoom07  ; room $04-$07
	dw OverworldRoom08, OverworldRoom09, OverworldRoom0A, OverworldRoom0B  ; room $08-$0B
	dw OverworldRoom0C, OverworldRoom0D, OverworldRoom0E, OverworldRoom0F  ; room $0C-$0F
	dw OverworldRoom10, OverworldRoom11, OverworldRoom12, OverworldRoom13  ; room $10-$13
	dw OverworldRoom14, OverworldRoom15, OverworldRoom16, OverworldRoom17  ; room $14-$17
	dw OverworldRoom18, OverworldRoom19, OverworldRoom1A, OverworldRoom1B  ; room $18-$1B
	dw OverworldRoom1C, OverworldRoom1D, OverworldRoom1E, OverworldRoom1F  ; room $1C-$1F
	dw OverworldRoom20, OverworldRoom21, OverworldRoom22, OverworldRoom23  ; room $20-$23
	dw OverworldRoom24, OverworldRoom25, OverworldRoom26, OverworldRoom27  ; room $24-$27
	dw OverworldRoom28, OverworldRoom29, OverworldRoom2A, OverworldRoom2B  ; room $28-$2B
	dw OverworldRoom2C, OverworldRoom2D, OverworldRoom2E, OverworldRoom2F  ; room $2C-$2F
	dw OverworldRoom30, OverworldRoom31, OverworldRoom32, OverworldRoom33  ; room $30-$33
	dw OverworldRoom34, OverworldRoom35, OverworldRoom36, OverworldRoom37  ; room $34-$37
	dw OverworldRoom38, OverworldRoom39, OverworldRoom3A, OverworldRoom3B  ; room $38-$3B
	dw OverworldRoom3C, OverworldRoom3D, OverworldRoom3E, OverworldRoom3F  ; room $3C-$3F
	dw OverworldRoom40, OverworldRoom41, OverworldRoom42, OverworldRoom43  ; room $40-$43
	dw OverworldRoom44, OverworldRoom45, OverworldRoom46, OverworldRoom47  ; room $44-$47
	dw OverworldRoom48, OverworldRoom49, OverworldRoom4A, OverworldRoom4B  ; room $48-$4B
	dw OverworldRoom4C, OverworldRoom4D, OverworldRoom4E, OverworldRoom4F  ; room $4C-$4F
	dw OverworldRoom50, OverworldRoom51, OverworldRoom52, OverworldRoom53  ; room $50-$53
	dw OverworldRoom54, OverworldRoom55, OverworldRoom56, OverworldRoom57  ; room $54-$57
	dw OverworldRoom58, OverworldRoom59, OverworldRoom5A, OverworldRoom5B  ; room $58-$5B
	dw OverworldRoom5C, OverworldRoom5D, OverworldRoom5E, OverworldRoom5F  ; room $5C-$5F
	dw OverworldRoom60, OverworldRoom61, OverworldRoom62, OverworldRoom51  ; room $60-$63
	dw OverworldRoom64, OverworldRoom65, OverworldRoom66, OverworldRoom67  ; room $64-$67
	dw OverworldRoom68, OverworldRoom69, OverworldRoom6A, OverworldRoom6B  ; room $68-$6B
	dw OverworldRoom6C, OverworldRoom6D, OverworldRoom6E, OverworldRoom6F  ; room $6C-$6F
	dw OverworldRoom70, OverworldRoom71, OverworldRoom72, OverworldRoom73  ; room $70-$73
	dw OverworldRoom74, OverworldRoom75, OverworldRoom76, OverworldRoom77  ; room $74-$77
	dw OverworldRoom78, OverworldRoom79, OverworldRoom7A, OverworldRoom7B  ; room $78-$7B
	dw OverworldRoom7C, OverworldRoom7D, OverworldRoom7E, OverworldRoom7F  ; room $7C-$7F
	dw OverworldRoom80, OverworldRoom81, OverworldRoom82, OverworldRoom83  ; room $80-$83
	dw OverworldRoom84, OverworldRoom85, OverworldRoom86, OverworldRoom87  ; room $84-$87
	dw OverworldRoom88, OverworldRoom89, OverworldRoom8A, OverworldRoom8B  ; room $88-$8B
	dw OverworldRoom8C, OverworldRoom8D, OverworldRoom8E, OverworldRoom8F  ; room $8C-$8F
	dw OverworldRoom90, OverworldRoom91, OverworldRoom92, OverworldRoom93  ; room $90-$93
	dw OverworldRoom94, OverworldRoom95, OverworldRoom96, OverworldRoom97  ; room $94-$97
	dw OverworldRoom98, OverworldRoom99, OverworldRoom9A, OverworldRoom9B  ; room $98-$9B
	dw OverworldRoom9C, OverworldRoom9D, OverworldRoom9E, OverworldRoom9F  ; room $9C-$9F
	dw OverworldRoomA0, OverworldRoomA1, OverworldRoomA2, OverworldRoomA3  ; room $A0-$A3
	dw OverworldRoomA4, OverworldRoomA5, OverworldRoomA6, OverworldRoomA7  ; room $A4-$A7
	dw OverworldRoomA8, OverworldRoomA9, OverworldRoomAA, OverworldRoomAB  ; room $A8-$AB
	dw OverworldRoomAC, OverworldRoomAD, OverworldRoomAE, OverworldRoomAF  ; room $AC-$AF
	dw OverworldRoomB0, OverworldRoomB1, OverworldRoomB2, OverworldRoomB3  ; room $B0-$B3
	dw OverworldRoomB4, OverworldRoomB5, OverworldRoomB6, OverworldRoomB7  ; room $B4-$B7
	dw OverworldRoomB8, OverworldRoomB9, OverworldRoomBA, OverworldRoomBB  ; room $B8-$BB
	dw OverworldRoomBC, OverworldRoomBD, OverworldRoomBE, OverworldRoomBF  ; room $BC-$BF
	dw OverworldRoomC0, OverworldRoomC1, OverworldRoomC2, OverworldRoomC3  ; room $C0-$C3
	dw OverworldRoomC4, OverworldRoomC5, OverworldRoomC6, OverworldRoomC7  ; room $C4-$C7
	dw OverworldRoomC8, OverworldRoomC9, OverworldRoomCA, OverworldRoomCB  ; room $C8-$CB
	dw OverworldRoomCC, OverworldRoomCD, OverworldRoomCE, OverworldRoomCF  ; room $CC-$CF
	dw OverworldRoomD0, OverworldRoomD1, OverworldRoomD2, OverworldRoomD3  ; room $D0-$D3
	dw OverworldRoomD4, OverworldRoomD5, OverworldRoomD6, OverworldRoomD7  ; room $D4-$D7
	dw OverworldRoomD8, OverworldRoomD9, OverworldRoomDA, OverworldRoomDB  ; room $D8-$DB
	dw OverworldRoomDC, OverworldRoomDD, OverworldRoomDE, OverworldRoomDF  ; room $DC-$DF
	dw OverworldRoomE0, OverworldRoomE1, OverworldRoomE2, OverworldRoomE3  ; room $E0-$E3
	dw OverworldRoomE4, OverworldRoomE5, OverworldRoomE6, OverworldRoomE7  ; room $E4-$E7
	dw OverworldRoomE8, OverworldRoomE9, OverworldRoomEA, OverworldRoomEB  ; room $E8-$EB
	dw OverworldRoomEC, OverworldRoomED, OverworldRoomEE, OverworldRoomEF  ; room $EC-$EF
	dw OverworldRoomF0, OverworldRoomF1, OverworldRoomF2, OverworldRoomF3  ; room $F0-$F3
	dw OverworldRoomF4, OverworldRoomF5, OverworldRoomF6, OverworldRoomF7  ; room $F4-$F7
	dw OverworldRoomF8, OverworldRoomF9, OverworldRoomFA, OverworldRoomFB  ; room $F8-$FB
	dw OverworldRoomFC, OverworldRoomFD, OverworldRoomFE, OverworldRoomFF  ; room $FC-$FF
;@ path: world/overworld/rooms
;@ Overworld room $00 (row 0, column 0 of the 16 x 16 map): 39 objects on floor object $E5; a warp (type 1) to map $07 room $3A at x 88, y 16. Format: see OverworldRoomPointers.
OverworldRoom00::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7d  ; (1, 1): object $7D
	db $19, $7c  ; (9, 1): object $7C
	db $13, $80  ; (3, 1): object $80
	db $84, $14, $4d  ; 4 across from (4, 1): object $4D
	db $17, $81  ; (7, 1): object $81
	db $23, $37  ; (3, 2): object $37
	db $83, $24, $0a  ; 3 across from (4, 2): object $0A
	db $27, $38  ; (7, 2): object $38
	db $32, $1d  ; (2, 3): object $1D
	db $33, $2e  ; (3, 3): object $2E
	db $34, $48  ; (4, 3): object $48
	db $36, $49  ; (6, 3): object $49
	db $37, $4e  ; (7, 3): object $4E
	db $38, $5d  ; (8, 3): object $5D
	db $41, $1d  ; (1, 4): object $1D
	db $42, $37  ; (2, 4): object $37
	db $43, $39  ; (3, 4): object $39
	db $44, $e1  ; (4, 4): object $E1
	db $e1, $07, $3a, $58, $10  ; warp type 1 to map $07 room $3A, x 88 y 16
	db $82, $45, $3a  ; 2 across from (5, 4): object $3A
	db $c2, $35, $e0  ; 2 down from (5, 3): object $E0
	db $47, $3b  ; (7, 4): object $3B
	db $48, $38  ; (8, 4): object $38
	db $50, $1d  ; (0, 5): object $1D
	db $c3, $51, $37  ; 3 down from (1, 5): object $37
	db $c2, $52, $37  ; 2 down from (2, 5): object $37
	db $85, $53, $09  ; 5 across from (3, 5): object $09
	db $82, $58, $7a  ; 2 across from (8, 5): object $7A
	db $c2, $60, $37  ; 2 down from (0, 6): object $37
	db $85, $63, $09  ; 5 across from (3, 6): object $09
	db $68, $38  ; (8, 6): object $38
	db $72, $2e  ; (2, 7): object $2E
	db $85, $73, $2f  ; 5 across from (3, 7): object $2F
	db $78, $4e  ; (8, 7): object $4E
	db $69, $50  ; (9, 6): object $50
	db $79, $09  ; (9, 7): object $09
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $01 (row 0, column 1 of the 16 x 16 map): 33 objects on floor object $E5. Format: see OverworldRoomPointers.
OverworldRoom01::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $00, $7c  ; (0, 0): object $7C
	db $01, $7d  ; (1, 0): object $7D
	db $03, $7c  ; (3, 0): object $7C
	db $04, $7d  ; (4, 0): object $7D
	db $10, $1c  ; (0, 1): object $1C
	db $82, $10, $1c  ; 2 across from (0, 1): object $1C
	db $12, $7e  ; (2, 1): object $7E
	db $82, $13, $1c  ; 2 across from (3, 1): object $1C
	db $15, $7e  ; (5, 1): object $7E
	db $16, $7d  ; (6, 1): object $7D
	db $35, $1d  ; (5, 3): object $1D
	db $36, $50  ; (6, 3): object $50
	db $37, $5d  ; (7, 3): object $5D
	db $43, $1d  ; (3, 4): object $1D
	db $86, $44, $50  ; 6 across from (4, 4): object $50
	db $45, $37  ; (5, 4): object $37
	db $46, $e8  ; (6, 4): object $E8
	db $47, $38  ; (7, 4): object $38
	db $84, $50, $7a  ; 4 across from (0, 5): object $7A
	db $54, $0a  ; (4, 5): object $0A
	db $55, $33  ; (5, 5): object $33
	db $56, $e0  ; (6, 5): object $E0
	db $57, $34  ; (7, 5): object $34
	db $82, $58, $03  ; 2 across from (8, 5): object $03
	db $83, $60, $50  ; 3 across from (0, 6): object $50
	db $63, $37  ; (3, 6): object $37
	db $86, $64, $0a  ; 6 across from (4, 6): object $0A
	db $83, $70, $09  ; 3 across from (0, 7): object $09
	db $73, $2e  ; (3, 7): object $2E
	db $86, $74, $2f  ; 6 across from (4, 7): object $2F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $02 (row 0, column 2 of the 16 x 16 map): 39 objects on floor object $E5; a warp (type 1) to map $07 room $3D at x 88, y 16. Format: see OverworldRoomPointers.
OverworldRoom02::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $06, $7c  ; (6, 0): object $7C
	db $07, $7d  ; (7, 0): object $7D
	db $15, $7c  ; (5, 1): object $7C
	db $82, $16, $1c  ; 2 across from (6, 1): object $1C
	db $18, $7e  ; (8, 1): object $7E
	db $19, $7d  ; (9, 1): object $7D
	db $12, $80  ; (2, 1): object $80
	db $13, $4d  ; (3, 1): object $4D
	db $14, $81  ; (4, 1): object $81
	db $22, $37  ; (2, 2): object $37
	db $23, $03  ; (3, 2): object $03
	db $24, $38  ; (4, 2): object $38
	db $31, $1d  ; (1, 3): object $1D
	db $32, $2e  ; (2, 3): object $2E
	db $33, $2f  ; (3, 3): object $2F
	db $34, $4e  ; (4, 3): object $4E
	db $35, $5d  ; (5, 3): object $5D
	db $39, $1d  ; (9, 3): object $1D
	db $40, $50  ; (0, 4): object $50
	db $41, $4b  ; (1, 4): object $4B
	db $42, $39  ; (2, 4): object $39
	db $43, $e1  ; (3, 4): object $E1
	db $e1, $07, $3d, $58, $10  ; warp type 1 to map $07 room $3D, x 88 y 16
	db $44, $3b  ; (4, 4): object $3B
	db $c3, $45, $38  ; 3 down from (5, 4): object $38
	db $49, $37  ; (9, 4): object $37
	db $85, $50, $03  ; 5 across from (0, 5): object $03
	db $83, $56, $50  ; 3 across from (6, 5): object $50
	db $59, $4b  ; (9, 5): object $4B
	db $85, $60, $03  ; 5 across from (0, 6): object $03
	db $85, $70, $2f  ; 5 across from (0, 7): object $2F
	db $75, $4e  ; (5, 7): object $4E
	db $84, $66, $03  ; 4 across from (6, 6): object $03
	db $84, $76, $03  ; 4 across from (6, 7): object $03
	db $79, $3d  ; (9, 7): object $3D
	db $42, $cd  ; (2, 4): object $CD
	db $44, $d7  ; (4, 4): object $D7
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $03 (row 0, column 3 of the 16 x 16 map): 48 objects on floor object $03; a warp (type 1) to map $1F room $EE at x 24, y 64. Format: see OverworldRoomPointers.
OverworldRoom03::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $00, $80  ; (0, 0): object $80
	db $82, $01, $4d  ; 2 across from (1, 0): object $4D
	db $03, $81  ; (3, 0): object $81
	db $04, $00  ; (4, 0): object $00
	db $05, $80  ; (5, 0): object $80
	db $82, $06, $4d  ; 2 across from (6, 0): object $4D
	db $08, $81  ; (8, 0): object $81
	db $09, $00  ; (9, 0): object $00
	db $c3, $10, $37  ; 3 down from (0, 1): object $37
	db $87, $11, $03  ; 7 across from (1, 1): object $03
	db $87, $21, $03  ; 7 across from (1, 2): object $03
	db $87, $31, $03  ; 7 across from (1, 3): object $03
	db $13, $4c  ; (3, 1): object $4C
	db $14, $4d  ; (4, 1): object $4D
	db $15, $4b  ; (5, 1): object $4B
	db $c3, $18, $38  ; 3 down from (8, 1): object $38
	db $40, $2e  ; (0, 4): object $2E
	db $82, $41, $2f  ; 2 across from (1, 4): object $2F
	db $43, $4e  ; (3, 4): object $4E
	db $33, $3d  ; (3, 3): object $3D
	db $34, $2f  ; (4, 3): object $2F
	db $35, $3c  ; (5, 3): object $3C
	db $44, $3a  ; (4, 4): object $3A
	db $45, $2e  ; (5, 4): object $2E
	db $82, $46, $2f  ; 2 across from (6, 4): object $2F
	db $48, $4e  ; (8, 4): object $4E
	db $50, $39  ; (0, 5): object $39
	db $82, $51, $3a  ; 2 across from (1, 5): object $3A
	db $53, $3b  ; (3, 5): object $3B
	db $55, $39  ; (5, 5): object $39
	db $82, $56, $3a  ; 2 across from (6, 5): object $3A
	db $58, $3b  ; (8, 5): object $3B
	db $39, $5d  ; (9, 3): object $5D
	db $c4, $49, $38  ; 4 down from (9, 4): object $38
	db $69, $7a  ; (9, 6): object $7A
	db $78, $09  ; (8, 7): object $09
	db $19, $00  ; (9, 1): object $00
	db $29, $ef  ; (9, 2): object $EF
	db $66, $c8  ; (6, 6): object $C8
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $72, $48  ; (2, 7): object $48
	db $73, $4a  ; (3, 7): object $4A
	db $74, $49  ; (4, 7): object $49
	db $76, $48  ; (6, 7): object $48
	db $77, $4a  ; (7, 7): object $4A
	db $78, $49  ; (8, 7): object $49
	db $79, $4e  ; (9, 7): object $4E
	db $44, $e1  ; (4, 4): object $E1
	db $e1, $1f, $ee, $18, $40  ; warp type 1 to map $1F room $EE, x 24 y 64
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $04 (row 0, column 4 of the 16 x 16 map): 29 objects on floor object $E5; a warp (type 1) to map $1F room $E2 at x 136, y 80. Format: see OverworldRoomPointers.
OverworldRoom04::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $06, $7c  ; (6, 0): object $7C
	db $07, $7d  ; (7, 0): object $7D
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7d  ; (1, 1): object $7D
	db $13, $7c  ; (3, 1): object $7C
	db $14, $7d  ; (4, 1): object $7D
	db $15, $7c  ; (5, 1): object $7C
	db $82, $16, $1c  ; 2 across from (6, 1): object $1C
	db $18, $7e  ; (8, 1): object $7E
	db $19, $7d  ; (9, 1): object $7D
	db $32, $1d  ; (2, 3): object $1D
	db $87, $33, $50  ; 7 across from (3, 3): object $50
	db $c2, $42, $37  ; 2 down from (2, 4): object $37
	db $87, $43, $03  ; 7 across from (3, 4): object $03
	db $87, $53, $03  ; 7 across from (3, 5): object $03
	db $87, $63, $03  ; 7 across from (3, 6): object $03
	db $45, $a0  ; (5, 4): object $A0
	db $70, $1d  ; (0, 7): object $1D
	db $71, $50  ; (1, 7): object $50
	db $72, $2e  ; (2, 7): object $2E
	db $87, $73, $2f  ; 7 across from (3, 7): object $2F
	db $76, $48  ; (6, 7): object $48
	db $77, $4a  ; (7, 7): object $4A
	db $78, $49  ; (8, 7): object $49
	db $83, $60, $7a  ; 3 across from (0, 6): object $7A
	db $66, $20  ; (6, 6): object $20
	db $e1, $1f, $e2, $88, $50  ; warp type 1 to map $1F room $E2, x 136 y 80
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $05 (row 0, column 5 of the 16 x 16 map): 29 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom05::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $13, $7c  ; (3, 1): object $7C
	db $04, $7c  ; (4, 0): object $7C
	db $05, $7d  ; (5, 0): object $7D
	db $16, $7e  ; (6, 1): object $7E
	db $17, $7d  ; (7, 1): object $7D
	db $82, $14, $1c  ; 2 across from (4, 1): object $1C
	db $87, $30, $50  ; 7 across from (0, 3): object $50
	db $37, $5d  ; (7, 3): object $5D
	db $82, $38, $e5  ; 2 across from (8, 3): object $E5
	db $41, $09  ; (1, 4): object $09
	db $c3, $47, $38  ; 3 down from (7, 4): object $38
	db $c4, $48, $e5  ; 4 down from (8, 4): object $E5
	db $c4, $49, $e5  ; 4 down from (9, 4): object $E5
	db $63, $09  ; (3, 6): object $09
	db $87, $70, $2f  ; 7 across from (0, 7): object $2F
	db $73, $48  ; (3, 7): object $48
	db $74, $e0  ; (4, 7): object $E0
	db $75, $49  ; (5, 7): object $49
	db $77, $4e  ; (7, 7): object $4E
	db $78, $50  ; (8, 7): object $50
	db $79, $5d  ; (9, 7): object $5D
	db $43, $20  ; (3, 4): object $20
	db $46, $20  ; (6, 4): object $20
	db $51, $20  ; (1, 5): object $20
	db $54, $20  ; (4, 5): object $20
	db $65, $20  ; (5, 6): object $20
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $06 (row 0, column 6 of the 16 x 16 map): 50 objects on floor object $E5; a warp (type 1) to map $08 room $70 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom06::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $35, $e1  ; (5, 3): object $E1
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $04, $05  ; (4, 0): object $05
	db $05, $06  ; (5, 0): object $06
	db $06, $07  ; (6, 0): object $07
	db $14, $63  ; (4, 1): object $63
	db $15, $64  ; (5, 1): object $64
	db $16, $65  ; (6, 1): object $65
	db $24, $71  ; (4, 2): object $71
	db $25, $1c  ; (5, 2): object $1C
	db $26, $7f  ; (6, 2): object $7F
	db $34, $a9  ; (4, 3): object $A9
	db $35, $aa  ; (5, 3): object $AA
	db $36, $bf  ; (6, 3): object $BF
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7d  ; (1, 1): object $7D
	db $18, $7c  ; (8, 1): object $7C
	db $19, $7d  ; (9, 1): object $7D
	db $13, $80  ; (3, 1): object $80
	db $17, $81  ; (7, 1): object $81
	db $c2, $23, $37  ; 2 down from (3, 2): object $37
	db $c2, $27, $38  ; 2 down from (7, 2): object $38
	db $32, $1d  ; (2, 3): object $1D
	db $38, $5d  ; (8, 3): object $5D
	db $c2, $42, $37  ; 2 down from (2, 4): object $37
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $43, $2e  ; (3, 4): object $2E
	db $44, $48  ; (4, 4): object $48
	db $46, $49  ; (6, 4): object $49
	db $47, $4e  ; (7, 4): object $4E
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $53, $3e  ; (3, 5): object $3E
	db $83, $54, $3a  ; 3 across from (4, 5): object $3A
	db $57, $3f  ; (7, 5): object $3F
	db $61, $1d  ; (1, 6): object $1D
	db $62, $2e  ; (2, 6): object $2E
	db $63, $2f  ; (3, 6): object $2F
	db $64, $48  ; (4, 6): object $48
	db $66, $49  ; (6, 6): object $49
	db $67, $2f  ; (7, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $69, $5d  ; (9, 6): object $5D
	db $71, $37  ; (1, 7): object $37
	db $72, $3e  ; (2, 7): object $3E
	db $85, $73, $3a  ; 5 across from (3, 7): object $3A
	db $78, $3b  ; (8, 7): object $3B
	db $79, $38  ; (9, 7): object $38
	db $c4, $45, $e0  ; 4 down from (5, 4): object $E0
	db $e1, $08, $70, $50, $7c  ; warp type 1 to map $08 room $70, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Second layout of overworld room $06 (row 0, column 6 of the 16 x 16 map): 51 objects on floor object $E5; a warp (type 1) to map $08 room $70 at x 80, y 124. Format: see OverworldRoomPointers. The loader uses it instead of the first layout once the room's event has happened.
OverworldRoom06Alt::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $04, $05  ; (4, 0): object $05
	db $05, $06  ; (5, 0): object $06
	db $06, $07  ; (6, 0): object $07
	db $14, $63  ; (4, 1): object $63
	db $15, $64  ; (5, 1): object $64
	db $16, $65  ; (6, 1): object $65
	db $24, $71  ; (4, 2): object $71
	db $25, $1c  ; (5, 2): object $1C
	db $26, $7f  ; (6, 2): object $7F
	db $34, $a9  ; (4, 3): object $A9
	db $35, $aa  ; (5, 3): object $AA
	db $36, $bf  ; (6, 3): object $BF
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7d  ; (1, 1): object $7D
	db $18, $7c  ; (8, 1): object $7C
	db $19, $7d  ; (9, 1): object $7D
	db $13, $80  ; (3, 1): object $80
	db $17, $81  ; (7, 1): object $81
	db $c2, $23, $37  ; 2 down from (3, 2): object $37
	db $c2, $27, $38  ; 2 down from (7, 2): object $38
	db $32, $1d  ; (2, 3): object $1D
	db $38, $5d  ; (8, 3): object $5D
	db $c2, $42, $37  ; 2 down from (2, 4): object $37
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $43, $2e  ; (3, 4): object $2E
	db $44, $48  ; (4, 4): object $48
	db $46, $49  ; (6, 4): object $49
	db $47, $4e  ; (7, 4): object $4E
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $53, $3e  ; (3, 5): object $3E
	db $83, $54, $3a  ; 3 across from (4, 5): object $3A
	db $57, $3f  ; (7, 5): object $3F
	db $61, $1d  ; (1, 6): object $1D
	db $62, $2e  ; (2, 6): object $2E
	db $63, $2f  ; (3, 6): object $2F
	db $64, $48  ; (4, 6): object $48
	db $66, $49  ; (6, 6): object $49
	db $67, $2f  ; (7, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $69, $5d  ; (9, 6): object $5D
	db $71, $37  ; (1, 7): object $37
	db $72, $3e  ; (2, 7): object $3E
	db $85, $73, $3a  ; 5 across from (3, 7): object $3A
	db $78, $3b  ; (8, 7): object $3B
	db $79, $38  ; (9, 7): object $38
	db $c4, $45, $e0  ; 4 down from (5, 4): object $E0
	db $25, $c1  ; (5, 2): object $C1
	db $35, $cb  ; (5, 3): object $CB
	db $e1, $08, $70, $50, $7c  ; warp type 1 to map $08 room $70, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $07 (row 0, column 7 of the 16 x 16 map): 36 objects on floor object $E5; a warp (type 1) to map $0A room $EE at x 120, y 48. Format: see OverworldRoomPointers.
OverworldRoom07::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $85, $20, $ef  ; 5 across from (0, 2): object $EF
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7d  ; (1, 1): object $7D
	db $13, $80  ; (3, 1): object $80
	db $85, $14, $4d  ; 5 across from (4, 1): object $4D
	db $19, $81  ; (9, 1): object $81
	db $23, $37  ; (3, 2): object $37
	db $85, $24, $03  ; 5 across from (4, 2): object $03
	db $25, $09  ; (5, 2): object $09
	db $29, $38  ; (9, 2): object $38
	db $32, $1d  ; (2, 3): object $1D
	db $33, $4b  ; (3, 3): object $4B
	db $85, $34, $03  ; 5 across from (4, 3): object $03
	db $39, $7a  ; (9, 3): object $7A
	db $c3, $42, $37  ; 3 down from (2, 4): object $37
	db $43, $d3  ; (3, 4): object $D3
	db $e1, $0a, $ee, $78, $30  ; warp type 1 to map $0A room $EE, x 120 y 48
	db $c3, $44, $03  ; 3 down from (4, 4): object $03
	db $45, $3d  ; (5, 4): object $3D
	db $46, $48  ; (6, 4): object $48
	db $47, $4a  ; (7, 4): object $4A
	db $48, $49  ; (8, 4): object $49
	db $49, $4e  ; (9, 4): object $4E
	db $53, $03  ; (3, 5): object $03
	db $c2, $55, $38  ; 2 down from (5, 5): object $38
	db $83, $56, $3a  ; 3 across from (6, 5): object $3A
	db $59, $3b  ; (9, 5): object $3B
	db $63, $09  ; (3, 6): object $09
	db $84, $66, $03  ; 4 across from (6, 6): object $03
	db $72, $2e  ; (2, 7): object $2E
	db $82, $73, $2f  ; 2 across from (3, 7): object $2F
	db $75, $4e  ; (5, 7): object $4E
	db $76, $e0  ; (6, 7): object $E0
	db $77, $3c  ; (7, 7): object $3C
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $08 (row 0, column 8 of the 16 x 16 map): 29 objects on floor object $E5. Format: see OverworldRoomPointers.
OverworldRoom08::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $12, $7c  ; (2, 1): object $7C
	db $13, $7d  ; (3, 1): object $7D
	db $18, $7c  ; (8, 1): object $7C
	db $19, $7d  ; (9, 1): object $7D
	db $20, $c8  ; (0, 2): object $C8
	db $82, $21, $7a  ; 2 across from (1, 2): object $7A
	db $24, $7a  ; (4, 2): object $7A
	db $82, $28, $7a  ; 2 across from (8, 2): object $7A
	db $83, $30, $7a  ; 3 across from (0, 3): object $7A
	db $86, $33, $7b  ; 6 across from (3, 3): object $7B
	db $34, $7a  ; (4, 3): object $7A
	db $82, $38, $7a  ; 2 across from (8, 3): object $7A
	db $29, $c8  ; (9, 2): object $C8
	db $82, $50, $50  ; 2 across from (0, 5): object $50
	db $52, $5d  ; (2, 5): object $5D
	db $82, $60, $03  ; 2 across from (0, 6): object $03
	db $c2, $62, $38  ; 2 down from (2, 6): object $38
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $71, $09  ; (1, 7): object $09
	db $54, $1d  ; (4, 5): object $1D
	db $85, $55, $50  ; 5 across from (5, 5): object $50
	db $64, $37  ; (4, 6): object $37
	db $85, $65, $03  ; 5 across from (5, 6): object $03
	db $73, $1d  ; (3, 7): object $1D
	db $74, $2e  ; (4, 7): object $2E
	db $85, $75, $2f  ; 5 across from (5, 7): object $2F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $09 (row 0, column 9 of the 16 x 16 map): 35 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom09::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $83, $20, $78  ; 3 across from (0, 2): object $78
	db $83, $30, $79  ; 3 across from (0, 3): object $79
	db $84, $33, $7b  ; 4 across from (3, 3): object $7B
	db $84, $40, $e5  ; 4 across from (0, 4): object $E5
	db $44, $1d  ; (4, 4): object $1D
	db $85, $45, $50  ; 5 across from (5, 4): object $50
	db $84, $50, $50  ; 4 across from (0, 5): object $50
	db $54, $4b  ; (4, 5): object $4B
	db $84, $70, $2f  ; 4 across from (0, 7): object $2F
	db $73, $3c  ; (3, 7): object $3C
	db $66, $09  ; (6, 6): object $09
	db $02, $7c  ; (2, 0): object $7C
	db $03, $7d  ; (3, 0): object $7D
	db $11, $7c  ; (1, 1): object $7C
	db $82, $12, $1c  ; 2 across from (2, 1): object $1C
	db $14, $7e  ; (4, 1): object $7E
	db $15, $7d  ; (5, 1): object $7D
	db $18, $80  ; (8, 1): object $80
	db $19, $4d  ; (9, 1): object $4D
	db $82, $27, $78  ; 2 across from (7, 2): object $78
	db $82, $37, $79  ; 2 across from (7, 3): object $79
	db $c2, $29, $03  ; 2 down from (9, 2): object $03
	db $48, $2e  ; (8, 4): object $2E
	db $49, $2f  ; (9, 4): object $2F
	db $58, $3e  ; (8, 5): object $3E
	db $c2, $59, $3a  ; 2 down from (9, 5): object $3A
	db $68, $39  ; (8, 6): object $39
	db $70, $48  ; (0, 7): object $48
	db $71, $4a  ; (1, 7): object $4A
	db $72, $49  ; (2, 7): object $49
	db $20, $c8  ; (0, 2): object $C8
	db $38, $c8  ; (8, 3): object $C8
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $0A (row 0, column A of the 16 x 16 map): 28 objects on floor object $03; a warp (type 1) to map $0A room $8B at x 80, y 124; a warp (type 1) to map $0A room $7E at x 96, y 124; a warp (type 1) to map $10 room $9F at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom0A::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $8a, $00, $4d  ; 10 across from (0, 0): object $4D
	db $8a, $40, $2f  ; 10 across from (0, 4): object $2F
	db $43, $48  ; (3, 4): object $48
	db $44, $4a  ; (4, 4): object $4A
	db $45, $49  ; (5, 4): object $49
	db $46, $3c  ; (6, 4): object $3C
	db $47, $03  ; (7, 4): object $03
	db $48, $3d  ; (8, 4): object $3D
	db $8a, $50, $3a  ; 10 across from (0, 5): object $3A
	db $82, $60, $3a  ; 2 across from (0, 6): object $3A
	db $8a, $70, $03  ; 10 across from (0, 7): object $03
	db $c2, $62, $37  ; 2 down from (2, 6): object $37
	db $56, $2e  ; (6, 5): object $2E
	db $57, $2f  ; (7, 5): object $2F
	db $58, $4e  ; (8, 5): object $4E
	db $61, $e1  ; (1, 6): object $E1
	db $e1, $0a, $8b, $50, $7c  ; warp type 1 to map $0A room $8B, x 80 y 124
	db $66, $39  ; (6, 6): object $39
	db $67, $e1  ; (7, 6): object $E1
	db $e1, $0a, $7e, $60, $7c  ; warp type 1 to map $0A room $7E, x 96 y 124
	db $68, $3b  ; (8, 6): object $3B
	db $03, $fd  ; (3, 0): object $FD
	db $e1, $10, $9f, $50, $7c  ; warp type 1 to map $10 room $9F, x 80 y 124
	db $12, $09  ; (2, 1): object $09
	db $16, $09  ; (6, 1): object $09
	db $23, $09  ; (3, 2): object $09
	db $38, $09  ; (8, 3): object $09
	db $c2, $44, $e0  ; 2 down from (4, 4): object $E0
	db $62, $de  ; (2, 6): object $DE
	db $00, $80  ; (0, 0): object $80
	db $10, $4b  ; (0, 1): object $4B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $0B (row 0, column B of the 16 x 16 map): 29 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom0B::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $83, $00, $4d  ; 3 across from (0, 0): object $4D
	db $03, $81  ; (3, 0): object $81
	db $13, $4c  ; (3, 1): object $4C
	db $14, $4d  ; (4, 1): object $4D
	db $15, $81  ; (5, 1): object $81
	db $85, $40, $2f  ; 5 across from (0, 4): object $2F
	db $45, $4e  ; (5, 4): object $4E
	db $85, $35, $7a  ; 5 across from (5, 3): object $7A
	db $37, $7b  ; (7, 3): object $7B
	db $85, $50, $3a  ; 5 across from (0, 5): object $3A
	db $87, $70, $03  ; 7 across from (0, 7): object $03
	db $55, $3f  ; (5, 5): object $3F
	db $46, $50  ; (6, 4): object $50
	db $47, $5d  ; (7, 4): object $5D
	db $82, $48, $e5  ; 2 across from (8, 4): object $E5
	db $82, $74, $09  ; 2 across from (4, 7): object $09
	db $66, $09  ; (6, 6): object $09
	db $83, $57, $78  ; 3 across from (7, 5): object $78
	db $83, $67, $79  ; 3 across from (7, 6): object $79
	db $86, $04, $00  ; 6 across from (4, 0): object $00
	db $84, $16, $00  ; 4 across from (6, 1): object $00
	db $16, $7c  ; (6, 1): object $7C
	db $17, $7d  ; (7, 1): object $7D
	db $84, $26, $ef  ; 4 across from (6, 2): object $EF
	db $77, $38  ; (7, 7): object $38
	db $82, $78, $e5  ; 2 across from (8, 7): object $E5
	db $56, $03  ; (6, 5): object $03
	db $25, $38  ; (5, 2): object $38
	db $55, $3b  ; (5, 5): object $3B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $0C (row 0, column C of the 16 x 16 map): 49 objects on floor object $E5. Format: see OverworldRoomPointers.
OverworldRoom0C::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $10, $00  ; (0, 1): object $00
	db $11, $7c  ; (1, 1): object $7C
	db $12, $7d  ; (2, 1): object $7D
	db $13, $00  ; (3, 1): object $00
	db $14, $7c  ; (4, 1): object $7C
	db $15, $7d  ; (5, 1): object $7D
	db $16, $80  ; (6, 1): object $80
	db $82, $17, $4d  ; 2 across from (7, 1): object $4D
	db $19, $81  ; (9, 1): object $81
	db $20, $ef  ; (0, 2): object $EF
	db $82, $21, $78  ; 2 across from (1, 2): object $78
	db $84, $23, $7a  ; 4 across from (3, 2): object $7A
	db $82, $27, $20  ; 2 across from (7, 2): object $20
	db $c2, $29, $38  ; 2 down from (9, 2): object $38
	db $30, $7a  ; (0, 3): object $7A
	db $82, $31, $79  ; 2 across from (1, 3): object $79
	db $35, $1d  ; (5, 3): object $1D
	db $36, $4b  ; (6, 3): object $4B
	db $37, $03  ; (7, 3): object $03
	db $38, $03  ; (8, 3): object $03
	db $41, $1d  ; (1, 4): object $1D
	db $82, $42, $50  ; 2 across from (2, 4): object $50
	db $44, $5d  ; (4, 4): object $5D
	db $c2, $45, $37  ; 2 down from (5, 4): object $37
	db $82, $46, $03  ; 2 across from (6, 4): object $03
	db $48, $3d  ; (8, 4): object $3D
	db $49, $4e  ; (9, 4): object $4E
	db $82, $50, $78  ; 2 across from (0, 5): object $78
	db $82, $52, $03  ; 2 across from (2, 5): object $03
	db $c2, $54, $38  ; 2 down from (4, 5): object $38
	db $82, $56, $03  ; 2 across from (6, 5): object $03
	db $82, $48, $7a  ; 2 across from (8, 4): object $7A
	db $58, $38  ; (8, 5): object $38
	db $59, $3f  ; (9, 5): object $3F
	db $82, $60, $79  ; 2 across from (0, 6): object $79
	db $82, $62, $03  ; 2 across from (2, 6): object $03
	db $65, $2e  ; (5, 6): object $2E
	db $82, $66, $2f  ; 2 across from (6, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $69, $3f  ; (9, 6): object $3F
	db $71, $2e  ; (1, 7): object $2E
	db $82, $72, $2f  ; 2 across from (2, 7): object $2F
	db $74, $4e  ; (4, 7): object $4E
	db $75, $3e  ; (5, 7): object $3E
	db $76, $e1  ; (6, 7): object $E1
	db $77, $3a  ; (7, 7): object $3A
	db $82, $78, $3f  ; 2 across from (8, 7): object $3F
	db $73, $e0  ; (3, 7): object $E0
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $0D (row 0, column D of the 16 x 16 map): 41 objects on floor object $E5; a warp (type 1) to map $0A room $F2 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom0D::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $16, $7c  ; (6, 1): object $7C
	db $82, $17, $1c  ; 2 across from (7, 1): object $1C
	db $19, $7d  ; (9, 1): object $7D
	db $07, $7c  ; (7, 0): object $7C
	db $08, $7d  ; (8, 0): object $7D
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $10, $80  ; (0, 1): object $80
	db $83, $11, $4d  ; 3 across from (1, 1): object $4D
	db $14, $81  ; (4, 1): object $81
	db $82, $36, $50  ; 2 across from (6, 3): object $50
	db $38, $5d  ; (8, 3): object $5D
	db $30, $3e  ; (0, 3): object $3E
	db $83, $31, $3a  ; 3 across from (1, 3): object $3A
	db $34, $3f  ; (4, 3): object $3F
	db $20, $2e  ; (0, 2): object $2E
	db $83, $21, $2f  ; 3 across from (1, 2): object $2F
	db $24, $4e  ; (4, 2): object $4E
	db $35, $1d  ; (5, 3): object $1D
	db $82, $46, $03  ; 2 across from (6, 4): object $03
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $86, $40, $7a  ; 6 across from (0, 4): object $7A
	db $82, $56, $03  ; 2 across from (6, 5): object $03
	db $50, $3e  ; (0, 5): object $3E
	db $83, $51, $3a  ; 3 across from (1, 5): object $3A
	db $54, $3f  ; (4, 5): object $3F
	db $55, $37  ; (5, 5): object $37
	db $60, $3e  ; (0, 6): object $3E
	db $83, $61, $3a  ; 3 across from (1, 6): object $3A
	db $64, $3f  ; (4, 6): object $3F
	db $65, $2e  ; (5, 6): object $2E
	db $82, $66, $2f  ; 2 across from (6, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $70, $37  ; (0, 7): object $37
	db $83, $71, $03  ; 3 across from (1, 7): object $03
	db $74, $38  ; (4, 7): object $38
	db $75, $3e  ; (5, 7): object $3E
	db $82, $76, $3a  ; 2 across from (6, 7): object $3A
	db $78, $3f  ; (8, 7): object $3F
	db $61, $e1  ; (1, 6): object $E1
	db $e1, $0a, $f2, $50, $7c  ; warp type 1 to map $0A room $F2, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $0E (row 0, column E of the 16 x 16 map): 39 objects on floor object $03; a warp (type 1) to map $06 room $0E at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom0E::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $25, $e1  ; (5, 2): object $E1
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7e  ; (1, 1): object $7E
	db $12, $7d  ; (2, 1): object $7D
	db $18, $7c  ; (8, 1): object $7C
	db $19, $7d  ; (9, 1): object $7D
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $30, $1d  ; (0, 3): object $1D
	db $89, $31, $50  ; 9 across from (1, 3): object $50
	db $c2, $40, $37  ; 2 down from (0, 4): object $37
	db $60, $2e  ; (0, 6): object $2E
	db $61, $3c  ; (1, 6): object $3C
	db $70, $3e  ; (0, 7): object $3E
	db $71, $2e  ; (1, 7): object $2E
	db $82, $72, $2f  ; 2 across from (2, 7): object $2F
	db $74, $48  ; (4, 7): object $48
	db $75, $4a  ; (5, 7): object $4A
	db $76, $49  ; (6, 7): object $49
	db $77, $48  ; (7, 7): object $48
	db $78, $4a  ; (8, 7): object $4A
	db $79, $49  ; (9, 7): object $49
	db $41, $54  ; (1, 4): object $54
	db $42, $20  ; (2, 4): object $20
	db $51, $20  ; (1, 5): object $20
	db $56, $09  ; (6, 5): object $09
	db $59, $09  ; (9, 5): object $09
	db $63, $09  ; (3, 6): object $09
	db $c4, $03, $72  ; 4 down from (3, 0): object $72
	db $43, $b6  ; (3, 4): object $B6
	db $c5, $04, $74  ; 5 down from (4, 0): object $74
	db $c5, $05, $74  ; 5 down from (5, 0): object $74
	db $c5, $06, $74  ; 5 down from (6, 0): object $74
	db $c4, $07, $73  ; 4 down from (7, 0): object $73
	db $47, $b7  ; (7, 4): object $B7
	db $14, $75  ; (4, 1): object $75
	db $15, $d6  ; (5, 1): object $D6
	db $16, $76  ; (6, 1): object $76
	db $e1, $06, $0e, $50, $7c  ; warp type 1 to map $06 room $0E, x 80 y 124
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Second layout of overworld room $0E (row 0, column E of the 16 x 16 map): 40 objects on floor object $03; a warp (type 1) to map $06 room $0E at x 80, y 124. Format: see OverworldRoomPointers. The loader uses it instead of the first layout once the room's event has happened.
OverworldRoom0EAlt::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7e  ; (1, 1): object $7E
	db $12, $7d  ; (2, 1): object $7D
	db $18, $7c  ; (8, 1): object $7C
	db $19, $7d  ; (9, 1): object $7D
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $30, $1d  ; (0, 3): object $1D
	db $89, $31, $50  ; 9 across from (1, 3): object $50
	db $c2, $40, $37  ; 2 down from (0, 4): object $37
	db $60, $2e  ; (0, 6): object $2E
	db $61, $3c  ; (1, 6): object $3C
	db $70, $3e  ; (0, 7): object $3E
	db $71, $2e  ; (1, 7): object $2E
	db $82, $72, $2f  ; 2 across from (2, 7): object $2F
	db $74, $48  ; (4, 7): object $48
	db $75, $4a  ; (5, 7): object $4A
	db $76, $49  ; (6, 7): object $49
	db $77, $48  ; (7, 7): object $48
	db $78, $4a  ; (8, 7): object $4A
	db $79, $49  ; (9, 7): object $49
	db $41, $54  ; (1, 4): object $54
	db $42, $20  ; (2, 4): object $20
	db $51, $20  ; (1, 5): object $20
	db $56, $09  ; (6, 5): object $09
	db $59, $09  ; (9, 5): object $09
	db $63, $09  ; (3, 6): object $09
	db $c4, $03, $72  ; 4 down from (3, 0): object $72
	db $43, $b6  ; (3, 4): object $B6
	db $c5, $04, $74  ; 5 down from (4, 0): object $74
	db $c5, $05, $74  ; 5 down from (5, 0): object $74
	db $c5, $06, $74  ; 5 down from (6, 0): object $74
	db $c4, $07, $73  ; 4 down from (7, 0): object $73
	db $47, $b7  ; (7, 4): object $B7
	db $14, $75  ; (4, 1): object $75
	db $15, $d6  ; (5, 1): object $D6
	db $16, $76  ; (6, 1): object $76
	db $c2, $35, $77  ; 2 down from (5, 3): object $77
	db $25, $e1  ; (5, 2): object $E1
	db $e1, $06, $0e, $50, $7c  ; warp type 1 to map $06 room $0E, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $0F (row 0, column F of the 16 x 16 map): 29 objects on floor object $E5; a warp (type 1) to map $0A room $8E at x 112, y 124. Format: see OverworldRoomPointers.
OverworldRoom0F::
	db $0b, $e5  ; animated tiles $0B, floor $E5
	db $8a, $00, $00  ; 10 across from (0, 0): object $00
	db $8a, $10, $00  ; 10 across from (0, 1): object $00
	db $06, $7c  ; (6, 0): object $7C
	db $07, $7d  ; (7, 0): object $7D
	db $10, $7c  ; (0, 1): object $7C
	db $11, $7d  ; (1, 1): object $7D
	db $15, $7e  ; (5, 1): object $7E
	db $82, $16, $1c  ; 2 across from (6, 1): object $1C
	db $14, $7c  ; (4, 1): object $7C
	db $18, $7d  ; (8, 1): object $7D
	db $8a, $20, $ef  ; 10 across from (0, 2): object $EF
	db $88, $30, $50  ; 8 across from (0, 3): object $50
	db $38, $5d  ; (8, 3): object $5D
	db $88, $40, $03  ; 8 across from (0, 4): object $03
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $41, $09  ; (1, 4): object $09
	db $47, $09  ; (7, 4): object $09
	db $33, $fd  ; (3, 3): object $FD
	db $e1, $0a, $8e, $70, $7c  ; warp type 1 to map $0A room $8E, x 112 y 124
	db $43, $b6  ; (3, 4): object $B6
	db $45, $b7  ; (5, 4): object $B7
	db $88, $50, $03  ; 8 across from (0, 5): object $03
	db $86, $60, $03  ; 6 across from (0, 6): object $03
	db $66, $3d  ; (6, 6): object $3D
	db $67, $2f  ; (7, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $86, $70, $2f  ; 6 across from (0, 7): object $2F
	db $76, $4e  ; (6, 7): object $4E
	db $77, $3a  ; (7, 7): object $3A
	db $78, $3f  ; (8, 7): object $3F
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $10 (row 1, column 0 of the 16 x 16 map): 30 objects on floor object $09; a warp (type 1) to map $07 room $5D at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom10::
	db $0b, $09  ; animated tiles $0B, floor $09
	db $c7, $00, $37  ; 7 down from (0, 0): object $37
	db $70, $2e  ; (0, 7): object $2E
	db $85, $71, $2f  ; 5 across from (1, 7): object $2F
	db $76, $3c  ; (6, 7): object $3C
	db $c7, $01, $37  ; 7 down from (1, 0): object $37
	db $61, $33  ; (1, 6): object $33
	db $88, $62, $2f  ; 8 across from (2, 6): object $2F
	db $02, $39  ; (2, 0): object $39
	db $85, $03, $3a  ; 5 across from (3, 0): object $3A
	db $05, $e1  ; (5, 0): object $E1
	db $e1, $07, $5d, $50, $7c  ; warp type 1 to map $07 room $5D, x 80 y 124
	db $08, $3b  ; (8, 0): object $3B
	db $03, $b6  ; (3, 0): object $B6
	db $07, $b6  ; (7, 0): object $B6
	db $13, $b7  ; (3, 1): object $B7
	db $17, $b7  ; (7, 1): object $B7
	db $22, $c8  ; (2, 2): object $C8
	db $28, $c8  ; (8, 2): object $C8
	db $83, $77, $0a  ; 3 across from (7, 7): object $0A
	db $09, $c8  ; (9, 0): object $C8
	db $83, $77, $04  ; 3 across from (7, 7): object $04
	db $82, $77, $f5  ; 2 across from (7, 7): object $F5
	db $49, $3d  ; (9, 4): object $3D
	db $59, $38  ; (9, 5): object $38
	db $69, $34  ; (9, 6): object $34
	db $83, $32, $03  ; 3 across from (2, 3): object $03
	db $43, $03  ; (3, 4): object $03
	db $52, $03  ; (2, 5): object $03
	db $83, $36, $03  ; 3 across from (6, 3): object $03
	db $47, $03  ; (7, 4): object $03
	db $83, $56, $03  ; 3 across from (6, 5): object $03
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $11 (row 1, column 1 of the 16 x 16 map): 34 objects on floor object $03; a warp (type 1) to map $10 room $99 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom11::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $03, $39  ; (3, 0): object $39
	db $86, $04, $3a  ; 6 across from (4, 0): object $3A
	db $c4, $10, $09  ; 4 down from (0, 1): object $09
	db $15, $f5  ; (5, 1): object $F5
	db $16, $f5  ; (6, 1): object $F5
	db $16, $45  ; (6, 1): object $45
	db $c2, $21, $09  ; 2 down from (1, 2): object $09
	db $c2, $23, $09  ; 2 down from (3, 2): object $09
	db $26, $e1  ; (6, 2): object $E1
	db $e1, $10, $99, $50, $7c  ; warp type 1 to map $10 room $99, x 80 y 124
	db $82, $40, $2f  ; 2 across from (0, 4): object $2F
	db $42, $3c  ; (2, 4): object $3C
	db $46, $3d  ; (6, 4): object $3D
	db $83, $47, $2f  ; 3 across from (7, 4): object $2F
	db $c2, $50, $c8  ; 2 down from (0, 5): object $C8
	db $51, $0a  ; (1, 5): object $0A
	db $52, $2e  ; (2, 5): object $2E
	db $53, $48  ; (3, 5): object $48
	db $54, $4a  ; (4, 5): object $4A
	db $55, $49  ; (5, 5): object $49
	db $56, $4e  ; (6, 5): object $4E
	db $83, $57, $3a  ; 3 across from (7, 5): object $3A
	db $62, $39  ; (2, 6): object $39
	db $84, $63, $3a  ; 4 across from (3, 6): object $3A
	db $66, $3b  ; (6, 6): object $3B
	db $7f, $f5  ; (15, 7): object $F5
	db $84, $71, $0a  ; 4 across from (1, 7): object $0A
	db $72, $09  ; (2, 7): object $09
	db $75, $3d  ; (5, 7): object $3D
	db $76, $48  ; (6, 7): object $48
	db $77, $4a  ; (7, 7): object $4A
	db $78, $49  ; (8, 7): object $49
	db $79, $3c  ; (9, 7): object $3C
	db $51, $6f  ; (1, 5): object $6F
	db $83, $00, $c8  ; 3 across from (0, 0): object $C8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $12 (row 1, column 2 of the 16 x 16 map): 13 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom12::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $85, $00, $3a  ; 5 across from (0, 0): object $3A
	db $05, $3b  ; (5, 0): object $3B
	db $8a, $40, $2f  ; 10 across from (0, 4): object $2F
	db $8a, $50, $3a  ; 10 across from (0, 5): object $3A
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $14, $09  ; (4, 1): object $09
	db $31, $09  ; (1, 3): object $09
	db $70, $3d  ; (0, 7): object $3D
	db $c4, $09, $38  ; 4 down from (9, 0): object $38
	db $48, $2f  ; (8, 4): object $2F
	db $49, $4e  ; (9, 4): object $4E
	db $58, $3a  ; (8, 5): object $3A
	db $59, $3b  ; (9, 5): object $3B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $13 (row 1, column 3 of the 16 x 16 map): 20 objects on floor object $03; a warp (type 1) to map $1F room $FE at x 112, y 124. Format: see OverworldRoomPointers.
OverworldRoom13::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $09, $3b  ; (9, 0): object $3B
	db $12, $09  ; (2, 1): object $09
	db $68, $09  ; (8, 6): object $09
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $10, $c8  ; (0, 1): object $C8
	db $c2, $12, $c8  ; 2 down from (2, 1): object $C8
	db $c3, $16, $c8  ; 3 down from (6, 1): object $C8
	db $18, $c8  ; (8, 1): object $C8
	db $24, $c8  ; (4, 2): object $C8
	db $c2, $29, $c8  ; 2 down from (9, 2): object $C8
	db $31, $c8  ; (1, 3): object $C8
	db $c2, $40, $c8  ; 2 down from (0, 4): object $C8
	db $43, $c8  ; (3, 4): object $C8
	db $45, $c8  ; (5, 4): object $C8
	db $48, $c8  ; (8, 4): object $C8
	db $c2, $59, $c8  ; 2 down from (9, 5): object $C8
	db $64, $c8  ; (4, 6): object $C8
	db $67, $c8  ; (7, 6): object $C8
	db $05, $ba  ; (5, 0): object $BA
	db $e1, $1f, $fe, $70, $7c  ; warp type 1 to map $1F room $FE, x 112 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $14 (row 1, column 4 of the 16 x 16 map): 24 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom14::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $c2, $00, $37  ; 2 down from (0, 0): object $37
	db $02, $3e  ; (2, 0): object $3E
	db $87, $03, $3a  ; 7 across from (3, 0): object $3A
	db $12, $39  ; (2, 1): object $39
	db $87, $13, $3a  ; 7 across from (3, 1): object $3A
	db $20, $2e  ; (0, 2): object $2E
	db $21, $3c  ; (1, 2): object $3C
	db $30, $39  ; (0, 3): object $39
	db $31, $2e  ; (1, 3): object $2E
	db $88, $32, $2f  ; 8 across from (2, 3): object $2F
	db $33, $48  ; (3, 3): object $48
	db $35, $49  ; (5, 3): object $49
	db $40, $09  ; (0, 4): object $09
	db $41, $39  ; (1, 4): object $39
	db $88, $42, $3a  ; 8 across from (2, 4): object $3A
	db $c2, $34, $e0  ; 2 down from (4, 3): object $E0
	db $50, $c8  ; (0, 5): object $C8
	db $61, $c8  ; (1, 6): object $C8
	db $65, $09  ; (5, 6): object $09
	db $66, $3d  ; (6, 6): object $3D
	db $83, $67, $2f  ; 3 across from (7, 6): object $2F
	db $87, $70, $2f  ; 7 across from (0, 7): object $2F
	db $76, $4e  ; (6, 7): object $4E
	db $83, $77, $3a  ; 3 across from (7, 7): object $3A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $15 (row 1, column 5 of the 16 x 16 map): 24 objects on floor object $03; a warp (type 1) to map $0A room $EA at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom15::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $87, $00, $3a  ; 7 across from (0, 0): object $3A
	db $07, $3f  ; (7, 0): object $3F
	db $c2, $09, $38  ; 2 down from (9, 0): object $38
	db $87, $10, $3a  ; 7 across from (0, 1): object $3A
	db $17, $3b  ; (7, 1): object $3B
	db $18, $09  ; (8, 1): object $09
	db $c2, $04, $e0  ; 2 down from (4, 0): object $E0
	db $21, $09  ; (1, 2): object $09
	db $26, $3d  ; (6, 2): object $3D
	db $82, $27, $2f  ; 2 across from (7, 2): object $2F
	db $29, $4e  ; (9, 2): object $4E
	db $86, $30, $2f  ; 6 across from (0, 3): object $2F
	db $36, $4e  ; (6, 3): object $4E
	db $82, $37, $3a  ; 2 across from (7, 3): object $3A
	db $39, $3b  ; (9, 3): object $3B
	db $86, $40, $3a  ; 6 across from (0, 4): object $3A
	db $46, $3b  ; (6, 4): object $3B
	db $38, $e1  ; (8, 3): object $E1
	db $e1, $0a, $ea, $50, $7c  ; warp type 1 to map $0A room $EA, x 80 y 124
	db $c2, $49, $c8  ; 2 down from (9, 4): object $C8
	db $58, $09  ; (8, 5): object $09
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $69, $3c  ; (9, 6): object $3C
	db $79, $2e  ; (9, 7): object $2E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $16 (row 1, column 6 of the 16 x 16 map): 29 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom16::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $00, $1d  ; (0, 0): object $1D
	db $01, $2e  ; (1, 0): object $2E
	db $82, $02, $2f  ; 2 across from (2, 0): object $2F
	db $04, $48  ; (4, 0): object $48
	db $06, $49  ; (6, 0): object $49
	db $82, $07, $2f  ; 2 across from (7, 0): object $2F
	db $09, $4e  ; (9, 0): object $4E
	db $c2, $10, $37  ; 2 down from (0, 1): object $37
	db $c2, $11, $3e  ; 2 down from (1, 1): object $3E
	db $87, $12, $3a  ; 7 across from (2, 1): object $3A
	db $87, $22, $3a  ; 7 across from (2, 2): object $3A
	db $c2, $19, $3f  ; 2 down from (9, 1): object $3F
	db $30, $2e  ; (0, 3): object $2E
	db $83, $31, $2f  ; 3 across from (1, 3): object $2F
	db $34, $48  ; (4, 3): object $48
	db $36, $49  ; (6, 3): object $49
	db $83, $37, $2f  ; 3 across from (7, 3): object $2F
	db $40, $39  ; (0, 4): object $39
	db $89, $41, $3a  ; 9 across from (1, 4): object $3A
	db $c5, $05, $e0  ; 5 down from (5, 0): object $E0
	db $c2, $50, $c8  ; 2 down from (0, 5): object $C8
	db $54, $d4  ; (4, 5): object $D4
	db $57, $09  ; (7, 5): object $09
	db $c2, $59, $c8  ; 2 down from (9, 5): object $C8
	db $61, $09  ; (1, 6): object $09
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $74, $48  ; (4, 7): object $48
	db $75, $e0  ; (5, 7): object $E0
	db $76, $49  ; (6, 7): object $49
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $17 (row 1, column 7 of the 16 x 16 map): 42 objects on floor object $03; a warp (type 1) to map $0A room $B6 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom17::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $00, $5d  ; (0, 0): object $5D
	db $01, $1d  ; (1, 0): object $1D
	db $c2, $02, $3e  ; 2 down from (2, 0): object $3E
	db $c2, $03, $3a  ; 2 down from (3, 0): object $3A
	db $c3, $04, $3a  ; 3 down from (4, 0): object $3A
	db $c2, $05, $3f  ; 2 down from (5, 0): object $3F
	db $c2, $06, $e0  ; 2 down from (6, 0): object $E0
	db $c2, $07, $37  ; 2 down from (7, 0): object $37
	db $09, $09  ; (9, 0): object $09
	db $c2, $10, $38  ; 2 down from (0, 1): object $38
	db $c4, $11, $37  ; 4 down from (1, 1): object $37
	db $22, $39  ; (2, 2): object $39
	db $25, $3b  ; (5, 2): object $3B
	db $35, $09  ; (5, 3): object $09
	db $27, $2e  ; (7, 2): object $2E
	db $82, $28, $2f  ; 2 across from (8, 2): object $2F
	db $30, $4e  ; (0, 3): object $4E
	db $32, $20  ; (2, 3): object $20
	db $34, $20  ; (4, 3): object $20
	db $43, $20  ; (3, 4): object $20
	db $37, $39  ; (7, 3): object $39
	db $38, $3a  ; (8, 3): object $3A
	db $c2, $39, $38  ; 2 down from (9, 3): object $38
	db $39, $3a  ; (9, 3): object $3A
	db $40, $3b  ; (0, 4): object $3B
	db $51, $33  ; (1, 5): object $33
	db $82, $52, $2f  ; 2 across from (2, 5): object $2F
	db $54, $48  ; (4, 5): object $48
	db $56, $49  ; (6, 5): object $49
	db $82, $57, $2f  ; 2 across from (7, 5): object $2F
	db $59, $4e  ; (9, 5): object $4E
	db $86, $63, $3a  ; 6 across from (3, 6): object $3A
	db $86, $73, $3a  ; 6 across from (3, 7): object $3A
	db $c2, $69, $3f  ; 2 down from (9, 6): object $3F
	db $c3, $55, $e0  ; 3 down from (5, 5): object $E0
	db $42, $09  ; (2, 4): object $09
	db $23, $e1  ; (3, 2): object $E1
	db $e1, $0a, $b6, $50, $7c  ; warp type 1 to map $0A room $B6, x 80 y 124
	db $62, $38  ; (2, 6): object $38
	db $82, $70, $2f  ; 2 across from (0, 7): object $2F
	db $72, $4e  ; (2, 7): object $4E
	db $49, $dd  ; (9, 4): object $DD
	db $62, $dd  ; (2, 6): object $DD
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $18 (row 1, column 8 of the 16 x 16 map): 28 objects on floor object $03; a warp (type 1) to map $0A room $BB at x 80, y 124; a warp (type 1) to map $0A room $BC at x 48, y 124. Format: see OverworldRoomPointers.
OverworldRoom18::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $c2, $02, $38  ; 2 down from (2, 0): object $38
	db $82, $20, $2f  ; 2 across from (0, 2): object $2F
	db $22, $4e  ; (2, 2): object $4E
	db $c4, $30, $3a  ; 4 down from (0, 3): object $3A
	db $c4, $31, $3a  ; 4 down from (1, 3): object $3A
	db $c4, $03, $37  ; 4 down from (3, 0): object $37
	db $43, $33  ; (3, 4): object $33
	db $86, $44, $2f  ; 6 across from (4, 4): object $2F
	db $04, $39  ; (4, 0): object $39
	db $85, $05, $3a  ; 5 across from (5, 0): object $3A
	db $14, $a0  ; (4, 1): object $A0
	db $c3, $17, $c8  ; 3 down from (7, 1): object $C8
	db $18, $09  ; (8, 1): object $09
	db $26, $09  ; (6, 2): object $09
	db $32, $37  ; (2, 3): object $37
	db $c2, $42, $37  ; 2 down from (2, 4): object $37
	db $62, $2e  ; (2, 6): object $2E
	db $85, $63, $2f  ; 5 across from (3, 6): object $2F
	db $85, $73, $3a  ; 5 across from (3, 7): object $3A
	db $87, $53, $1b  ; 7 across from (3, 5): object $1B
	db $68, $3c  ; (8, 6): object $3C
	db $78, $2e  ; (8, 7): object $2E
	db $79, $2f  ; (9, 7): object $2F
	db $69, $1b  ; (9, 6): object $1B
	db $72, $3e  ; (2, 7): object $3E
	db $06, $e1  ; (6, 0): object $E1
	db $e1, $0a, $bb, $50, $7c  ; warp type 1 to map $0A room $BB, x 80 y 124
	db $08, $e1  ; (8, 0): object $E1
	db $e1, $0a, $bc, $30, $7c  ; warp type 1 to map $0A room $BC, x 48 y 124
	db $70, $f5  ; (0, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $19 (row 1, column 9 of the 16 x 16 map): 26 objects on floor object $03; a warp (type 1) to map $0A room $89 at x 64, y 124. Format: see OverworldRoomPointers.
OverworldRoom19::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $83, $00, $3a  ; 3 across from (0, 0): object $3A
	db $c3, $03, $37  ; 3 down from (3, 0): object $37
	db $08, $09  ; (8, 0): object $09
	db $22, $09  ; (2, 2): object $09
	db $25, $09  ; (5, 2): object $09
	db $27, $3d  ; (7, 2): object $3D
	db $82, $28, $2f  ; 2 across from (8, 2): object $2F
	db $33, $2e  ; (3, 3): object $2E
	db $83, $34, $2f  ; 3 across from (4, 3): object $2F
	db $37, $4e  ; (7, 3): object $4E
	db $38, $e1  ; (8, 3): object $E1
	db $e1, $0a, $89, $40, $7c  ; warp type 1 to map $0A room $89, x 64 y 124
	db $39, $3a  ; (9, 3): object $3A
	db $40, $2f  ; (0, 4): object $2F
	db $41, $48  ; (1, 4): object $48
	db $42, $e0  ; (2, 4): object $E0
	db $43, $39  ; (3, 4): object $39
	db $83, $44, $3a  ; 3 across from (4, 4): object $3A
	db $47, $3b  ; (7, 4): object $3B
	db $82, $48, $1b  ; 2 across from (8, 4): object $1B
	db $8a, $50, $1b  ; 10 across from (0, 5): object $1B
	db $60, $1b  ; (0, 6): object $1B
	db $61, $3d  ; (1, 6): object $3D
	db $88, $62, $2f  ; 8 across from (2, 6): object $2F
	db $70, $2f  ; (0, 7): object $2F
	db $71, $4e  ; (1, 7): object $4E
	db $88, $72, $3a  ; 8 across from (2, 7): object $3A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $1A (row 1, column A of the 16 x 16 map): 29 objects on floor object $1B. Format: see OverworldRoomPointers.
OverworldRoom1A::
	db $0b, $1b  ; animated tiles $0B, floor $1B
	db $8a, $00, $03  ; 10 across from (0, 0): object $03
	db $8a, $10, $03  ; 10 across from (0, 1): object $03
	db $c2, $02, $37  ; 2 down from (2, 0): object $37
	db $14, $3d  ; (4, 1): object $3D
	db $83, $15, $2f  ; 3 across from (5, 1): object $2F
	db $18, $3c  ; (8, 1): object $3C
	db $82, $20, $2f  ; 2 across from (0, 2): object $2F
	db $22, $2e  ; (2, 2): object $2E
	db $23, $2f  ; (3, 2): object $2F
	db $24, $4e  ; (4, 2): object $4E
	db $83, $25, $e1  ; 3 across from (5, 2): object $E1
	db $28, $2e  ; (8, 2): object $2E
	db $29, $2f  ; (9, 2): object $2F
	db $82, $30, $3a  ; 2 across from (0, 3): object $3A
	db $32, $3e  ; (2, 3): object $3E
	db $c2, $33, $3a  ; 2 down from (3, 3): object $3A
	db $34, $3f  ; (4, 3): object $3F
	db $83, $35, $e9  ; 3 across from (5, 3): object $E9
	db $38, $3e  ; (8, 3): object $3E
	db $c2, $39, $3a  ; 2 down from (9, 3): object $3A
	db $42, $39  ; (2, 4): object $39
	db $44, $3b  ; (4, 4): object $3B
	db $83, $45, $e9  ; 3 across from (5, 4): object $E9
	db $48, $39  ; (8, 4): object $39
	db $83, $60, $2f  ; 3 across from (0, 6): object $2F
	db $63, $3c  ; (3, 6): object $3C
	db $83, $70, $3a  ; 3 across from (0, 7): object $3A
	db $73, $2e  ; (3, 7): object $2E
	db $86, $74, $2f  ; 6 across from (4, 7): object $2F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $1B (row 1, column B of the 16 x 16 map): 38 objects on floor object $1B. Format: see OverworldRoomPointers.
OverworldRoom1B::
	db $0b, $1b  ; animated tiles $0B, floor $1B
	db $87, $00, $03  ; 7 across from (0, 0): object $03
	db $87, $10, $03  ; 7 across from (0, 1): object $03
	db $20, $2f  ; (0, 2): object $2F
	db $21, $4e  ; (1, 2): object $4E
	db $11, $3d  ; (1, 1): object $3D
	db $12, $2f  ; (2, 1): object $2F
	db $13, $3c  ; (3, 1): object $3C
	db $23, $2e  ; (3, 2): object $2E
	db $83, $24, $2f  ; 3 across from (4, 2): object $2F
	db $27, $4e  ; (7, 2): object $4E
	db $c2, $07, $38  ; 2 down from (7, 0): object $38
	db $82, $08, $50  ; 2 across from (8, 0): object $50
	db $22, $e1  ; (2, 2): object $E1
	db $c2, $30, $3a  ; 2 down from (0, 3): object $3A
	db $31, $3f  ; (1, 3): object $3F
	db $c2, $32, $e9  ; 2 down from (2, 3): object $E9
	db $33, $3e  ; (3, 3): object $3E
	db $83, $34, $3a  ; 3 across from (4, 3): object $3A
	db $36, $e1  ; (6, 3): object $E1
	db $37, $3f  ; (7, 3): object $3F
	db $41, $3b  ; (1, 4): object $3B
	db $43, $39  ; (3, 4): object $39
	db $83, $44, $3a  ; 3 across from (4, 4): object $3A
	db $46, $e9  ; (6, 4): object $E9
	db $47, $3b  ; (7, 4): object $3B
	db $87, $51, $0e  ; 7 across from (1, 5): object $0E
	db $68, $0e  ; (8, 6): object $0E
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $61, $3d  ; (1, 6): object $3D
	db $62, $48  ; (2, 6): object $48
	db $83, $63, $e9  ; 3 across from (3, 6): object $E9
	db $66, $49  ; (6, 6): object $49
	db $67, $3c  ; (7, 6): object $3C
	db $71, $4e  ; (1, 7): object $4E
	db $72, $3a  ; (2, 7): object $3A
	db $83, $73, $e9  ; 3 across from (3, 7): object $E9
	db $76, $3a  ; (6, 7): object $3A
	db $77, $2e  ; (7, 7): object $2E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Second layout of overworld room $1B (row 1, column B of the 16 x 16 map): 40 objects on floor object $03. Format: see OverworldRoomPointers. The loader uses it instead of the first layout once the room's event has happened.
OverworldRoom1BAlt::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $82, $18, $1b  ; 2 across from (8, 1): object $1B
	db $29, $1b  ; (9, 2): object $1B
	db $59, $1b  ; (9, 5): object $1B
	db $c2, $50, $1b  ; 2 down from (0, 5): object $1B
	db $87, $00, $03  ; 7 across from (0, 0): object $03
	db $87, $10, $03  ; 7 across from (0, 1): object $03
	db $20, $2f  ; (0, 2): object $2F
	db $21, $4e  ; (1, 2): object $4E
	db $11, $3d  ; (1, 1): object $3D
	db $12, $2f  ; (2, 1): object $2F
	db $13, $3c  ; (3, 1): object $3C
	db $23, $2e  ; (3, 2): object $2E
	db $83, $24, $2f  ; 3 across from (4, 2): object $2F
	db $27, $4e  ; (7, 2): object $4E
	db $c2, $07, $38  ; 2 down from (7, 0): object $38
	db $82, $08, $50  ; 2 across from (8, 0): object $50
	db $22, $e1  ; (2, 2): object $E1
	db $c2, $30, $3a  ; 2 down from (0, 3): object $3A
	db $31, $3f  ; (1, 3): object $3F
	db $32, $3a  ; (2, 3): object $3A
	db $33, $3e  ; (3, 3): object $3E
	db $83, $34, $3a  ; 3 across from (4, 3): object $3A
	db $36, $e1  ; (6, 3): object $E1
	db $37, $3f  ; (7, 3): object $3F
	db $41, $3b  ; (1, 4): object $3B
	db $43, $39  ; (3, 4): object $39
	db $83, $44, $3a  ; 3 across from (4, 4): object $3A
	db $47, $3b  ; (7, 4): object $3B
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $61, $3d  ; (1, 6): object $3D
	db $62, $48  ; (2, 6): object $48
	db $66, $49  ; (6, 6): object $49
	db $67, $3c  ; (7, 6): object $3C
	db $71, $4e  ; (1, 7): object $4E
	db $83, $63, $4a  ; 3 across from (3, 6): object $4A
	db $85, $72, $3a  ; 5 across from (2, 7): object $3A
	db $77, $2e  ; (7, 7): object $2E
	db $52, $09  ; (2, 5): object $09
	db $82, $55, $09  ; 2 across from (5, 5): object $09
	db $68, $09  ; (8, 6): object $09
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $1C (row 1, column C of the 16 x 16 map): 29 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoom1C::
	db $0b, $0e  ; animated tiles $0B, floor $0E
	db $00, $50  ; (0, 0): object $50
	db $c4, $01, $3e  ; 4 down from (1, 0): object $3E
	db $c5, $02, $3a  ; 5 down from (2, 0): object $3A
	db $03, $e1  ; (3, 0): object $E1
	db $c4, $04, $3f  ; 4 down from (4, 0): object $3F
	db $c3, $05, $3e  ; 3 down from (5, 0): object $3E
	db $c4, $06, $e9  ; 4 down from (6, 0): object $E9
	db $c4, $07, $3a  ; 4 down from (7, 0): object $3A
	db $c3, $08, $3f  ; 3 down from (8, 0): object $3F
	db $c2, $09, $3f  ; 2 down from (9, 0): object $3F
	db $c4, $13, $e9  ; 4 down from (3, 1): object $E9
	db $41, $39  ; (1, 4): object $39
	db $44, $3b  ; (4, 4): object $3B
	db $35, $39  ; (5, 3): object $39
	db $38, $3b  ; (8, 3): object $3B
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $29, $3b  ; (9, 2): object $3B
	db $61, $3d  ; (1, 6): object $3D
	db $70, $2f  ; (0, 7): object $2F
	db $71, $4e  ; (1, 7): object $4E
	db $c6, $10, $1b  ; 6 down from (0, 1): object $1B
	db $51, $1b  ; (1, 5): object $1B
	db $48, $1b  ; (8, 4): object $1B
	db $c3, $39, $1b  ; 3 down from (9, 3): object $1B
	db $c2, $63, $e9  ; 2 down from (3, 6): object $E9
	db $c2, $65, $e9  ; 2 down from (5, 6): object $E9
	db $c2, $67, $e9  ; 2 down from (7, 6): object $E9
	db $c5, $03, $e0  ; 5 down from (3, 0): object $E0
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $1D (row 1, column D of the 16 x 16 map): 32 objects on floor object $03; a warp (type 1) to map $0A room $F9 at x 32, y 124; a warp (type 1) to map $0A room $FA at x 112, y 124. Format: see OverworldRoomPointers.
OverworldRoom1D::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $00, $37  ; (0, 0): object $37
	db $83, $01, $03  ; 3 across from (1, 0): object $03
	db $04, $32  ; (4, 0): object $32
	db $05, $2c  ; (5, 0): object $2C
	db $06, $2d  ; (6, 0): object $2D
	db $c4, $07, $3a  ; 4 down from (7, 0): object $3A
	db $c4, $08, $3f  ; 4 down from (8, 0): object $3F
	db $c2, $09, $e5  ; 2 down from (9, 0): object $E5
	db $10, $2e  ; (0, 1): object $2E
	db $11, $2f  ; (1, 1): object $2F
	db $12, $3c  ; (2, 1): object $3C
	db $15, $a0  ; (5, 1): object $A0
	db $c2, $16, $38  ; 2 down from (6, 1): object $38
	db $20, $39  ; (0, 2): object $39
	db $21, $e1  ; (1, 2): object $E1
	db $e1, $0a, $f9, $20, $7c  ; warp type 1 to map $0A room $F9, x 32 y 124
	db $22, $37  ; (2, 2): object $37
	db $29, $50  ; (9, 2): object $50
	db $c3, $30, $1b  ; 3 down from (0, 3): object $1B
	db $c3, $31, $1b  ; 3 down from (1, 3): object $1B
	db $32, $2e  ; (2, 3): object $2E
	db $83, $33, $2f  ; 3 across from (3, 3): object $2F
	db $36, $4e  ; (6, 3): object $4E
	db $42, $3e  ; (2, 4): object $3E
	db $83, $43, $3a  ; 3 across from (3, 4): object $3A
	db $83, $53, $3a  ; 3 across from (3, 5): object $3A
	db $46, $3f  ; (6, 4): object $3F
	db $47, $e1  ; (7, 4): object $E1
	db $e1, $0a, $fa, $70, $7c  ; warp type 1 to map $0A room $FA, x 112 y 124
	db $48, $3b  ; (8, 4): object $3B
	db $52, $39  ; (2, 5): object $39
	db $56, $3b  ; (6, 5): object $3B
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $1E (row 1, column E of the 16 x 16 map): 38 objects on floor object $03; a warp (type 1) to map $0A room $80 at x 32, y 124; a warp (type 1) to map $0A room $83 at x 128, y 124; a warp (type 1) to map $1F room $F2 at x 72, y 64. Format: see OverworldRoomPointers.
OverworldRoom1E::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $c2, $00, $3e  ; 2 down from (0, 0): object $3E
	db $20, $39  ; (0, 2): object $39
	db $c3, $01, $3e  ; 3 down from (1, 0): object $3E
	db $31, $39  ; (1, 3): object $39
	db $88, $02, $3a  ; 8 across from (2, 0): object $3A
	db $12, $37  ; (2, 1): object $37
	db $22, $2e  ; (2, 2): object $2E
	db $32, $3e  ; (2, 3): object $3E
	db $42, $39  ; (2, 4): object $39
	db $03, $e1  ; (3, 0): object $E1
	db $e1, $0a, $80, $20, $7c  ; warp type 1 to map $0A room $80, x 32 y 124
	db $13, $03  ; (3, 1): object $03
	db $c3, $23, $e0  ; 3 down from (3, 2): object $E0
	db $14, $38  ; (4, 1): object $38
	db $24, $4e  ; (4, 2): object $4E
	db $34, $3f  ; (4, 3): object $3F
	db $44, $3b  ; (4, 4): object $3B
	db $16, $37  ; (6, 1): object $37
	db $26, $2e  ; (6, 2): object $2E
	db $36, $3e  ; (6, 3): object $3E
	db $46, $39  ; (6, 4): object $39
	db $83, $27, $2f  ; 3 across from (7, 2): object $2F
	db $83, $17, $03  ; 3 across from (7, 1): object $03
	db $07, $e1  ; (7, 0): object $E1
	db $e1, $0a, $83, $80, $7c  ; warp type 1 to map $0A room $83, x 128 y 124
	db $37, $37  ; (7, 3): object $37
	db $47, $2e  ; (7, 4): object $2E
	db $57, $39  ; (7, 5): object $39
	db $82, $48, $2f  ; 2 across from (8, 4): object $2F
	db $82, $58, $3a  ; 2 across from (8, 5): object $3A
	db $39, $03  ; (9, 3): object $03
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $c3, $15, $3a  ; 3 down from (5, 1): object $3A
	db $45, $e1  ; (5, 4): object $E1
	db $e1, $1f, $f2, $48, $40  ; warp type 1 to map $1F room $F2, x 72 y 64
	db $45, $e8  ; (5, 4): object $E8
	db $16, $de  ; (6, 1): object $DE
	db $37, $de  ; (7, 3): object $DE
	db $12, $de  ; (2, 1): object $DE
	db $14, $dd  ; (4, 1): object $DD
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $1F (row 1, column F of the 16 x 16 map): 34 objects on floor object $03; a warp (type 1) to map $0A room $82 at x 112, y 124; a warp (type 1) to map $0A room $8C at x 96, y 124; a warp (type 1) to map $0A room $87 at x 96, y 124; a warp (type 1) to map $1F room $FB at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom1F::
	db $0b, $03  ; animated tiles $0B, floor $03
	db $c8, $09, $e5  ; 8 down from (9, 0): object $E5
	db $86, $00, $3a  ; 6 across from (0, 0): object $3A
	db $02, $e1  ; (2, 0): object $E1
	db $e1, $0a, $82, $70, $7c  ; warp type 1 to map $0A room $82, x 112 y 124
	db $c3, $06, $3f  ; 3 down from (6, 0): object $3F
	db $07, $e1  ; (7, 0): object $E1
	db $e1, $0a, $8c, $60, $7c  ; warp type 1 to map $0A room $8C, x 96 y 124
	db $08, $3f  ; (8, 0): object $3F
	db $84, $10, $03  ; 4 across from (0, 1): object $03
	db $11, $09  ; (1, 1): object $09
	db $14, $38  ; (4, 1): object $38
	db $c2, $15, $3a  ; 2 down from (5, 1): object $3A
	db $c5, $18, $38  ; 5 down from (8, 1): object $38
	db $84, $20, $2f  ; 4 across from (0, 2): object $2F
	db $20, $48  ; (0, 2): object $48
	db $21, $e0  ; (1, 2): object $E0
	db $22, $49  ; (2, 2): object $49
	db $24, $4e  ; (4, 2): object $4E
	db $82, $30, $03  ; 2 across from (0, 3): object $03
	db $32, $38  ; (2, 3): object $38
	db $c2, $33, $3a  ; 2 down from (3, 3): object $3A
	db $34, $3f  ; (4, 3): object $3F
	db $35, $e1  ; (5, 3): object $E1
	db $e1, $0a, $87, $60, $7c  ; warp type 1 to map $0A room $87, x 96 y 124
	db $36, $3b  ; (6, 3): object $3B
	db $82, $40, $2f  ; 2 across from (0, 4): object $2F
	db $42, $4e  ; (2, 4): object $4E
	db $43, $ba  ; (3, 4): object $BA
	db $e1, $1f, $fb, $50, $7c  ; warp type 1 to map $1F room $FB, x 80 y 124
	db $44, $3b  ; (4, 4): object $3B
	db $82, $50, $3a  ; 2 across from (0, 5): object $3A
	db $52, $3b  ; (2, 5): object $3B
	db $88, $60, $2f  ; 8 across from (0, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $88, $70, $3a  ; 8 across from (0, 7): object $3A
	db $78, $3f  ; (8, 7): object $3F
	db $14, $dd  ; (4, 1): object $DD
	db $32, $dd  ; (2, 3): object $DD
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $20 (row 2, column 0 of the 16 x 16 map): 19 objects on floor object $04; a warp (type 1) to map $11 room $AE at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom20::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $00, $37  ; 3 down from (0, 0): object $37
	db $86, $01, $3a  ; 6 across from (1, 0): object $3A
	db $06, $37  ; (6, 0): object $37
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $86, $11, $3a  ; 6 across from (1, 1): object $3A
	db $16, $2e  ; (6, 1): object $2E
	db $83, $17, $2f  ; 3 across from (7, 1): object $2F
	db $26, $39  ; (6, 2): object $39
	db $83, $27, $3a  ; 3 across from (7, 2): object $3A
	db $28, $e1  ; (8, 2): object $E1
	db $e1, $11, $ae, $50, $7c  ; warp type 1 to map $11 room $AE, x 80 y 124
	db $30, $2e  ; (0, 3): object $2E
	db $31, $3c  ; (1, 3): object $3C
	db $40, $39  ; (0, 4): object $39
	db $c4, $41, $37  ; 4 down from (1, 4): object $37
	db $49, $2b  ; (9, 4): object $2B
	db $c3, $50, $0e  ; 3 down from (0, 5): object $0E
	db $54, $20  ; (4, 5): object $20
	db $57, $20  ; (7, 5): object $20
	db $c3, $59, $37  ; 3 down from (9, 5): object $37
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $21 (row 2, column 1 of the 16 x 16 map): 22 objects on floor object $04; a warp (type 1) to map $11 room $AF at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom21::
	db $03, $04  ; animated tiles $03, floor $04
	db $ff, $f5  ; (15, 15): object $F5
	db $86, $01, $0a  ; 6 across from (1, 0): object $0A
	db $05, $38  ; (5, 0): object $38
	db $83, $06, $3a  ; 3 across from (6, 0): object $3A
	db $83, $16, $3a  ; 3 across from (6, 1): object $3A
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $85, $10, $2f  ; 5 across from (0, 1): object $2F
	db $12, $48  ; (2, 1): object $48
	db $14, $49  ; (4, 1): object $49
	db $15, $4e  ; (5, 1): object $4E
	db $86, $20, $3a  ; 6 across from (0, 2): object $3A
	db $21, $e1  ; (1, 2): object $E1
	db $e1, $11, $af, $50, $7c  ; warp type 1 to map $11 room $AF, x 80 y 124
	db $25, $3b  ; (5, 2): object $3B
	db $82, $34, $5c  ; 2 across from (4, 3): object $5C
	db $40, $2d  ; (0, 4): object $2D
	db $c4, $48, $0a  ; 4 down from (8, 4): object $0A
	db $c3, $50, $38  ; 3 down from (0, 5): object $38
	db $52, $5c  ; (2, 5): object $5C
	db $56, $0a  ; (6, 5): object $0A
	db $57, $5c  ; (7, 5): object $5C
	db $83, $65, $0a  ; 3 across from (5, 6): object $0A
	db $c2, $13, $e0  ; 2 down from (3, 1): object $E0
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $22 (row 2, column 2 of the 16 x 16 map): 19 objects on floor object $1B. Format: see OverworldRoomPointers.
OverworldRoom22::
	db $03, $1b  ; animated tiles $03, floor $1B
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $c6, $21, $04  ; 6 down from (1, 2): object $04
	db $83, $20, $04  ; 3 across from (0, 2): object $04
	db $c5, $30, $04  ; 5 down from (0, 3): object $04
	db $23, $11  ; (3, 2): object $11
	db $32, $13  ; (2, 3): object $13
	db $33, $17  ; (3, 3): object $17
	db $c4, $42, $11  ; 4 down from (2, 4): object $11
	db $c3, $24, $30  ; 3 down from (4, 2): object $30
	db $c2, $43, $30  ; 2 down from (3, 4): object $30
	db $26, $30  ; (6, 2): object $30
	db $c3, $25, $51  ; 3 down from (5, 2): object $51
	db $29, $51  ; (9, 2): object $51
	db $82, $57, $51  ; 2 across from (7, 5): object $51
	db $49, $51  ; (9, 4): object $51
	db $75, $51  ; (5, 7): object $51
	db $82, $78, $51  ; 2 across from (8, 7): object $51
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $23 (row 2, column 3 of the 16 x 16 map): 16 objects on floor object $1B. Format: see OverworldRoomPointers.
OverworldRoom23::
	db $03, $1b  ; animated tiles $03, floor $1B
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $20, $51  ; (0, 2): object $51
	db $82, $21, $30  ; 2 across from (1, 2): object $30
	db $27, $51  ; (7, 2): object $51
	db $31, $30  ; (1, 3): object $30
	db $34, $51  ; (4, 3): object $51
	db $39, $51  ; (9, 3): object $51
	db $83, $40, $51  ; 3 across from (0, 4): object $51
	db $82, $48, $51  ; 2 across from (8, 4): object $51
	db $53, $51  ; (3, 5): object $51
	db $c3, $59, $51  ; 3 down from (9, 5): object $51
	db $66, $51  ; (6, 6): object $51
	db $70, $51  ; (0, 7): object $51
	db $74, $51  ; (4, 7): object $51
	db $76, $51  ; (6, 7): object $51
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $24 (row 2, column 4 of the 16 x 16 map): 29 objects on floor object $1B; a warp (type 1) to map $01 room $36 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom24::
	db $03, $1b  ; animated tiles $03, floor $1B
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $86, $10, $3a  ; 6 across from (0, 1): object $3A
	db $06, $3f  ; (6, 0): object $3F
	db $16, $3b  ; (6, 1): object $3B
	db $13, $e1  ; (3, 1): object $E1
	db $25, $12  ; (5, 2): object $12
	db $35, $18  ; (5, 3): object $18
	db $36, $14  ; (6, 3): object $14
	db $c4, $46, $12  ; 4 down from (6, 4): object $12
	db $c7, $17, $04  ; 7 down from (7, 1): object $04
	db $c7, $18, $04  ; 7 down from (8, 1): object $04
	db $c7, $19, $04  ; 7 down from (9, 1): object $04
	db $c3, $37, $f5  ; 3 down from (7, 3): object $F5
	db $29, $f5  ; (9, 2): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $c5, $30, $51  ; 5 down from (0, 3): object $51
	db $82, $71, $51  ; 2 across from (1, 7): object $51
	db $75, $51  ; (5, 7): object $51
	db $82, $57, $04  ; 2 across from (7, 5): object $04
	db $82, $67, $04  ; 2 across from (7, 6): object $04
	db $82, $26, $20  ; 2 across from (6, 2): object $20
	db $c2, $57, $20  ; 2 down from (7, 5): object $20
	db $02, $b6  ; (2, 0): object $B6
	db $03, $d7  ; (3, 0): object $D7
	db $04, $b6  ; (4, 0): object $B6
	db $11, $b6  ; (1, 1): object $B6
	db $12, $b7  ; (2, 1): object $B7
	db $14, $b7  ; (4, 1): object $B7
	db $15, $b6  ; (5, 1): object $B6
	db $e1, $01, $36, $50, $7c  ; warp type 1 to map $01 room $36, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $25 (row 2, column 5 of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom25::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $82, $2f, $f5  ; 2 across from (15, 2): object $F5
	db $c2, $23, $20  ; 2 down from (3, 2): object $20
	db $35, $20  ; (5, 3): object $20
	db $24, $36  ; (4, 2): object $36
	db $25, $2f  ; (5, 2): object $2F
	db $26, $3c  ; (6, 2): object $3C
	db $36, $37  ; (6, 3): object $37
	db $46, $2e  ; (6, 4): object $2E
	db $47, $48  ; (7, 4): object $48
	db $48, $4a  ; (8, 4): object $4A
	db $49, $49  ; (9, 4): object $49
	db $56, $39  ; (6, 5): object $39
	db $83, $57, $3a  ; 3 across from (7, 5): object $3A
	db $7f, $f5  ; (15, 7): object $F5
	db $51, $36  ; (1, 5): object $36
	db $c2, $62, $37  ; 2 down from (2, 6): object $37
	db $52, $3c  ; (2, 5): object $3C
	db $34, $d4  ; (4, 3): object $D4
	db $09, $3e  ; (9, 0): object $3E
	db $19, $39  ; (9, 1): object $39
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $26 (row 2, column 6 of the 16 x 16 map): 20 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom26::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $40, $2f  ; 2 across from (0, 4): object $2F
	db $82, $50, $3a  ; 2 across from (0, 5): object $3A
	db $87, $33, $2f  ; 7 across from (3, 3): object $2F
	db $87, $43, $3a  ; 7 across from (3, 4): object $3A
	db $32, $3d  ; (2, 3): object $3D
	db $42, $4e  ; (2, 4): object $4E
	db $52, $3b  ; (2, 5): object $3B
	db $34, $48  ; (4, 3): object $48
	db $35, $4a  ; (5, 3): object $4A
	db $36, $49  ; (6, 3): object $49
	db $02, $09  ; (2, 0): object $09
	db $17, $09  ; (7, 1): object $09
	db $75, $3d  ; (5, 7): object $3D
	db $66, $3d  ; (6, 6): object $3D
	db $67, $35  ; (7, 6): object $35
	db $76, $4e  ; (6, 7): object $4E
	db $27, $09  ; (7, 2): object $09
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $c2, $05, $e0  ; 2 down from (5, 0): object $E0
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $27 (row 2, column 7 of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom27::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $86, $30, $2f  ; 6 across from (0, 3): object $2F
	db $32, $48  ; (2, 3): object $48
	db $33, $4a  ; (3, 3): object $4A
	db $34, $49  ; (4, 3): object $49
	db $86, $40, $3a  ; 6 across from (0, 4): object $3A
	db $c4, $46, $37  ; 4 down from (6, 4): object $37
	db $82, $52, $0a  ; 2 across from (2, 5): object $0A
	db $54, $5c  ; (4, 5): object $5C
	db $55, $5c  ; (5, 5): object $5C
	db $65, $5c  ; (5, 6): object $5C
	db $17, $09  ; (7, 1): object $09
	db $24, $09  ; (4, 2): object $09
	db $38, $09  ; (8, 3): object $09
	db $77, $09  ; (7, 7): object $09
	db $01, $39  ; (1, 0): object $39
	db $89, $00, $3a  ; 9 across from (0, 0): object $3A
	db $09, $3b  ; (9, 0): object $3B
	db $05, $e0  ; (5, 0): object $E0
	db $02, $3f  ; (2, 0): object $3F
	db $82, $10, $3a  ; 2 across from (0, 1): object $3A
	db $12, $3b  ; (2, 1): object $3B
	db $36, $3c  ; (6, 3): object $3C
	db $29, $2b  ; (9, 2): object $2B
	db $c5, $39, $37  ; 5 down from (9, 3): object $37
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $28 (row 2, column 8 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom28::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $86, $03, $3a  ; 6 across from (3, 0): object $3A
	db $02, $39  ; (2, 0): object $39
	db $84, $15, $3a  ; 4 across from (5, 1): object $3A
	db $84, $25, $0e  ; 4 across from (5, 2): object $0E
	db $85, $35, $0e  ; 5 across from (5, 3): object $0E
	db $c3, $14, $38  ; 3 down from (4, 1): object $38
	db $44, $32  ; (4, 4): object $32
	db $85, $45, $2c  ; 5 across from (5, 4): object $2C
	db $64, $3d  ; (4, 6): object $3D
	db $83, $65, $2f  ; 3 across from (5, 6): object $2F
	db $68, $3c  ; (8, 6): object $3C
	db $74, $38  ; (4, 7): object $38
	db $83, $75, $3a  ; 3 across from (5, 7): object $3A
	db $78, $2e  ; (8, 7): object $2E
	db $79, $2f  ; (9, 7): object $2F
	db $c3, $09, $3a  ; 3 down from (9, 0): object $3A
	db $c2, $08, $3e  ; 2 down from (8, 0): object $3E
	db $28, $39  ; (8, 2): object $39
	db $55, $20  ; (5, 5): object $20
	db $f0, $f5  ; (0, 15): object $F5
	db $20, $2d  ; (0, 2): object $2D
	db $c5, $30, $38  ; 5 down from (0, 3): object $38
	db $14, $dd  ; (4, 1): object $DD
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $29 (row 2, column 9 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom29::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $c3, $00, $3a  ; 3 down from (0, 0): object $3A
	db $c2, $01, $3f  ; 2 down from (1, 0): object $3F
	db $21, $3b  ; (1, 2): object $3B
	db $88, $02, $3a  ; 8 across from (2, 0): object $3A
	db $88, $12, $3a  ; 8 across from (2, 1): object $3A
	db $88, $22, $0e  ; 8 across from (2, 2): object $0E
	db $8a, $30, $0e  ; 10 across from (0, 3): object $0E
	db $43, $0e  ; (3, 4): object $0E
	db $82, $40, $2c  ; 2 across from (0, 4): object $2C
	db $42, $2d  ; (2, 4): object $2D
	db $c2, $52, $38  ; 2 down from (2, 5): object $38
	db $70, $48  ; (0, 7): object $48
	db $71, $e0  ; (1, 7): object $E0
	db $72, $4e  ; (2, 7): object $4E
	db $53, $2c  ; (3, 5): object $2C
	db $54, $31  ; (4, 5): object $31
	db $44, $2b  ; (4, 4): object $2B
	db $85, $45, $2c  ; 5 across from (5, 4): object $2C
	db $73, $0a  ; (3, 7): object $0A
	db $74, $2b  ; (4, 7): object $2B
	db $75, $2c  ; (5, 7): object $2C
	db $76, $2d  ; (6, 7): object $2D
	db $79, $2b  ; (9, 7): object $2B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $2A (row 2, column A of the 16 x 16 map): 23 objects on floor object $0E; a warp (type 2) to map $0A room $FD at x 11, y 48. Format: see OverworldRoomPointers.
OverworldRoom2A::
	db $0b, $0e  ; animated tiles $0B, floor $0E
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $86, $24, $3a  ; 6 across from (4, 2): object $3A
	db $c2, $03, $3e  ; 2 down from (3, 0): object $3E
	db $23, $39  ; (3, 2): object $39
	db $40, $2c  ; (0, 4): object $2C
	db $41, $2d  ; (1, 4): object $2D
	db $51, $32  ; (1, 5): object $32
	db $88, $52, $2c  ; 8 across from (2, 5): object $2C
	db $50, $04  ; (0, 5): object $04
	db $8a, $60, $04  ; 10 across from (0, 6): object $04
	db $8a, $70, $04  ; 10 across from (0, 7): object $04
	db $14, $b6  ; (4, 1): object $B6
	db $15, $b7  ; (5, 1): object $B7
	db $17, $b6  ; (7, 1): object $B6
	db $18, $b7  ; (8, 1): object $B7
	db $26, $e1  ; (6, 2): object $E1
	db $e2, $0a, $fd, $0b, $30  ; warp type 2 to map $0A room $FD, x 11 y 48
	db $70, $2c  ; (0, 7): object $2C
	db $71, $2d  ; (1, 7): object $2D
	db $74, $2b  ; (4, 7): object $2B
	db $75, $2c  ; (5, 7): object $2C
	db $76, $2d  ; (6, 7): object $2D
	db $79, $2b  ; (9, 7): object $2B
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $2B (row 2, column B of the 16 x 16 map): 26 objects on floor object $0E; a warp (type 1) to map $03 room $7A at x 80, y 124; a warp (type 1) to map $1F room $E9 at x 40, y 32. Format: see OverworldRoomPointers.
OverworldRoom2B::
	db $0b, $0e  ; animated tiles $0B, floor $0E
	db $14, $e1  ; (4, 1): object $E1
	db $e1, $03, $7a, $50, $7c  ; warp type 1 to map $03 room $7A, x 80 y 124
	db $26, $c6  ; (6, 2): object $C6
	db $e1, $1f, $e9, $28, $20  ; warp type 1 to map $1F room $E9, x 40 y 32
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $8a, $20, $3a  ; 10 across from (0, 2): object $3A
	db $c2, $01, $3f  ; 2 down from (1, 0): object $3F
	db $c2, $07, $3e  ; 2 down from (7, 0): object $3E
	db $21, $3b  ; (1, 2): object $3B
	db $27, $39  ; (7, 2): object $39
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $8a, $60, $04  ; 10 across from (0, 6): object $04
	db $8a, $70, $04  ; 10 across from (0, 7): object $04
	db $54, $54  ; (4, 5): object $54
	db $83, $03, $e9  ; 3 across from (3, 0): object $E9
	db $83, $13, $e9  ; 3 across from (3, 1): object $E9
	db $85, $22, $0e  ; 5 across from (2, 2): object $0E
	db $70, $2c  ; (0, 7): object $2C
	db $71, $2d  ; (1, 7): object $2D
	db $72, $2b  ; (2, 7): object $2B
	db $73, $2c  ; (3, 7): object $2C
	db $74, $2d  ; (4, 7): object $2D
	db $75, $2b  ; (5, 7): object $2B
	db $76, $2c  ; (6, 7): object $2C
	db $77, $2d  ; (7, 7): object $2D
	db $78, $2b  ; (8, 7): object $2B
	db $79, $2c  ; (9, 7): object $2C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Second layout of overworld room $2B (row 2, column B of the 16 x 16 map): 35 objects on floor object $0E; a warp (type 1) to map $03 room $7A at x 80, y 124; a warp (type 1) to map $1F room $E9 at x 40, y 32. Format: see OverworldRoomPointers. The loader uses it instead of the first layout once the room's event has happened.
OverworldRoom2BAlt::
	db $0b, $0e  ; animated tiles $0B, floor $0E
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $8a, $20, $3a  ; 10 across from (0, 2): object $3A
	db $c2, $01, $3f  ; 2 down from (1, 0): object $3F
	db $c2, $07, $3e  ; 2 down from (7, 0): object $3E
	db $21, $3b  ; (1, 2): object $3B
	db $27, $39  ; (7, 2): object $39
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $8a, $60, $04  ; 10 across from (0, 6): object $04
	db $8a, $70, $04  ; 10 across from (0, 7): object $04
	db $54, $54  ; (4, 5): object $54
	db $03, $d5  ; (3, 0): object $D5
	db $04, $d6  ; (4, 0): object $D6
	db $05, $d7  ; (5, 0): object $D7
	db $85, $22, $03  ; 5 across from (2, 2): object $03
	db $83, $34, $03  ; 3 across from (4, 3): object $03
	db $23, $09  ; (3, 2): object $09
	db $25, $09  ; (5, 2): object $09
	db $36, $09  ; (6, 3): object $09
	db $82, $32, $1b  ; 2 across from (2, 3): object $1B
	db $84, $43, $1b  ; 4 across from (3, 4): object $1B
	db $13, $cd  ; (3, 1): object $CD
	db $14, $e1  ; (4, 1): object $E1
	db $15, $ce  ; (5, 1): object $CE
	db $e1, $03, $7a, $50, $7c  ; warp type 1 to map $03 room $7A, x 80 y 124
	db $70, $2c  ; (0, 7): object $2C
	db $71, $2d  ; (1, 7): object $2D
	db $72, $2b  ; (2, 7): object $2B
	db $73, $2c  ; (3, 7): object $2C
	db $74, $2d  ; (4, 7): object $2D
	db $75, $2b  ; (5, 7): object $2B
	db $76, $2c  ; (6, 7): object $2C
	db $77, $2d  ; (7, 7): object $2D
	db $78, $2b  ; (8, 7): object $2B
	db $79, $2c  ; (9, 7): object $2C
	db $26, $c6  ; (6, 2): object $C6
	db $e1, $1f, $e9, $28, $20  ; warp type 1 to map $1F room $E9, x 40 y 32
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $2C (row 2, column C of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom2C::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $c2, $01, $3f  ; 2 down from (1, 0): object $3F
	db $21, $3b  ; (1, 2): object $3B
	db $88, $22, $0e  ; 8 across from (2, 2): object $0E
	db $8a, $30, $0e  ; 10 across from (0, 3): object $0E
	db $83, $40, $0e  ; 3 across from (0, 4): object $0E
	db $43, $2b  ; (3, 4): object $2B
	db $86, $44, $2c  ; 6 across from (4, 4): object $2C
	db $83, $50, $2c  ; 3 across from (0, 5): object $2C
	db $53, $31  ; (3, 5): object $31
	db $20, $3a  ; (0, 2): object $3A
	db $35, $fc  ; (5, 3): object $FC
	db $39, $fc  ; (9, 3): object $FC
	db $56, $e0  ; (6, 5): object $E0
	db $70, $2d  ; (0, 7): object $2D
	db $71, $fc  ; (1, 7): object $FC
	db $75, $fc  ; (5, 7): object $FC
	db $79, $2b  ; (9, 7): object $2B
	db $c2, $03, $e9  ; 2 down from (3, 0): object $E9
	db $c2, $05, $e9  ; 2 down from (5, 0): object $E9
	db $c2, $07, $e9  ; 2 down from (7, 0): object $E9
	db $69, $0a  ; (9, 6): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $2D (row 2, column D of the 16 x 16 map): 23 objects on floor object $04; a warp (type 1) to map $1F room $EA at x 136, y 112. Format: see OverworldRoomPointers.
OverworldRoom2D::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $8a, $20, $0e  ; 10 across from (0, 2): object $0E
	db $8a, $30, $0e  ; 10 across from (0, 3): object $0E
	db $8a, $40, $2c  ; 10 across from (0, 4): object $2C
	db $30, $2c  ; (0, 3): object $2C
	db $31, $2d  ; (1, 3): object $2D
	db $40, $e8  ; (0, 4): object $E8
	db $41, $38  ; (1, 4): object $38
	db $50, $2f  ; (0, 5): object $2F
	db $51, $34  ; (1, 5): object $34
	db $34, $fc  ; (4, 3): object $FC
	db $82, $60, $0a  ; 2 across from (0, 6): object $0A
	db $83, $64, $0a  ; 3 across from (4, 6): object $0A
	db $70, $2c  ; (0, 7): object $2C
	db $71, $2d  ; (1, 7): object $2D
	db $74, $fc  ; (4, 7): object $FC
	db $45, $c6  ; (5, 4): object $C6
	db $55, $e0  ; (5, 5): object $E0
	db $e1, $1f, $ea, $88, $70  ; warp type 1 to map $1F room $EA, x 136 y 112
	db $38, $2b  ; (8, 3): object $2B
	db $39, $2c  ; (9, 3): object $2C
	db $48, $31  ; (8, 4): object $31
	db $49, $04  ; (9, 4): object $04
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $2E (row 2, column E of the 16 x 16 map): 19 objects on floor object $04; a warp (type 1) to map $1F room $F2 at x 72, y 124. Format: see OverworldRoomPointers.
OverworldRoom2E::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $8a, $20, $0e  ; 10 across from (0, 2): object $0E
	db $8a, $30, $2c  ; 10 across from (0, 3): object $2C
	db $c5, $34, $0e  ; 5 down from (4, 3): object $0E
	db $c5, $35, $0e  ; 5 down from (5, 3): object $0E
	db $33, $2d  ; (3, 3): object $2D
	db $36, $2b  ; (6, 3): object $2B
	db $43, $f2  ; (3, 4): object $F2
	db $46, $ea  ; (6, 4): object $EA
	db $51, $6e  ; (1, 5): object $6E
	db $c2, $53, $f3  ; 2 down from (3, 5): object $F3
	db $c2, $56, $f0  ; 2 down from (6, 5): object $F0
	db $68, $6e  ; (8, 6): object $6E
	db $69, $f5  ; (9, 6): object $F5
	db $73, $f4  ; (3, 7): object $F4
	db $76, $f1  ; (6, 7): object $F1
	db $75, $ca  ; (5, 7): object $CA
	db $15, $e1  ; (5, 1): object $E1
	db $e1, $1f, $f2, $48, $7c  ; warp type 1 to map $1F room $F2, x 72 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $2F (row 2, column F of the 16 x 16 map): 21 objects on floor object $04; a warp (type 1) to map $1F room $E7 at x 72, y 16. Format: see OverworldRoomPointers.
OverworldRoom2F::
	db $03, $04  ; animated tiles $03, floor $04
	db $88, $00, $3a  ; 8 across from (0, 0): object $3A
	db $08, $3f  ; (8, 0): object $3F
	db $09, $2d  ; (9, 0): object $2D
	db $88, $10, $3a  ; 8 across from (0, 1): object $3A
	db $c7, $18, $0e  ; 7 down from (8, 1): object $0E
	db $c7, $19, $38  ; 7 down from (9, 1): object $38
	db $88, $20, $0e  ; 8 across from (0, 2): object $0E
	db $c2, $36, $0e  ; 2 down from (6, 3): object $0E
	db $c5, $37, $0e  ; 5 down from (7, 3): object $0E
	db $85, $30, $2c  ; 5 across from (0, 3): object $2C
	db $35, $2d  ; (5, 3): object $2D
	db $45, $38  ; (5, 4): object $38
	db $55, $32  ; (5, 5): object $32
	db $56, $2d  ; (6, 5): object $2D
	db $c2, $66, $38  ; 2 down from (6, 6): object $38
	db $6f, $f5  ; (15, 6): object $F5
	db $82, $70, $f5  ; 2 across from (0, 7): object $F5
	db $18, $3b  ; (8, 1): object $3B
	db $57, $ca  ; (7, 5): object $CA
	db $68, $ca  ; (8, 6): object $CA
	db $61, $c6  ; (1, 6): object $C6
	db $e1, $1f, $e7, $48, $10  ; warp type 1 to map $1F room $E7, x 72 y 16
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $30 (row 3, column 0 of the 16 x 16 map): 22 objects on floor object $04; a warp (type 1) to map $10 room $A8 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom30::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $00, $0e  ; 2 down from (0, 0): object $0E
	db $c2, $01, $37  ; 2 down from (1, 0): object $37
	db $c5, $30, $37  ; 5 down from (0, 3): object $37
	db $83, $46, $e8  ; 3 across from (6, 4): object $E8
	db $82, $55, $e8  ; 2 across from (5, 5): object $E8
	db $c2, $51, $f5  ; 2 down from (1, 5): object $F5
	db $62, $f5  ; (2, 6): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $34, $e8  ; (4, 3): object $E8
	db $54, $d4  ; (4, 5): object $D4
	db $21, $31  ; (1, 2): object $31
	db $20, $2b  ; (0, 2): object $2B
	db $12, $44  ; (2, 1): object $44
	db $25, $44  ; (5, 2): object $44
	db $41, $44  ; (1, 4): object $44
	db $c4, $09, $37  ; 4 down from (9, 0): object $37
	db $39, $2e  ; (9, 3): object $2E
	db $49, $39  ; (9, 4): object $39
	db $25, $0a  ; (5, 2): object $0A
	db $83, $36, $0a  ; 3 across from (6, 3): object $0A
	db $16, $fd  ; (6, 1): object $FD
	db $e1, $10, $a8, $50, $7c  ; warp type 1 to map $10 room $A8, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $31 (row 3, column 1 of the 16 x 16 map): 21 objects on floor object $04; a warp (type 1) to map $10 room $9B at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom31::
	db $03, $04  ; animated tiles $03, floor $04
	db $60, $f5  ; (0, 6): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $c2, $49, $0a  ; 2 down from (9, 4): object $0A
	db $86, $43, $0a  ; 6 across from (3, 4): object $0A
	db $82, $55, $0a  ; 2 across from (5, 5): object $0A
	db $08, $0a  ; (8, 0): object $0A
	db $22, $44  ; (2, 2): object $44
	db $c4, $00, $38  ; 4 down from (0, 0): object $38
	db $30, $4e  ; (0, 3): object $4E
	db $40, $3b  ; (0, 4): object $3B
	db $c2, $09, $37  ; 2 down from (9, 0): object $37
	db $29, $2e  ; (9, 2): object $2E
	db $39, $39  ; (9, 3): object $39
	db $23, $f5  ; (3, 2): object $F5
	db $27, $f5  ; (7, 2): object $F5
	db $82, $31, $e8  ; 2 across from (1, 3): object $E8
	db $35, $f5  ; (5, 3): object $F5
	db $36, $f5  ; (6, 3): object $F5
	db $36, $45  ; (6, 3): object $45
	db $46, $e1  ; (6, 4): object $E1
	db $e1, $10, $9b, $50, $7c  ; warp type 1 to map $10 room $9B, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $32 (row 3, column 2 of the 16 x 16 map): 38 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom32::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $02, $11  ; 3 down from (2, 0): object $11
	db $32, $15  ; (2, 3): object $15
	db $33, $10  ; (3, 3): object $10
	db $34, $19  ; (4, 3): object $19
	db $c2, $44, $11  ; 2 down from (4, 4): object $11
	db $87, $03, $1b  ; 7 across from (3, 0): object $1B
	db $87, $13, $1b  ; 7 across from (3, 1): object $1B
	db $87, $23, $1b  ; 7 across from (3, 2): object $1B
	db $85, $35, $1b  ; 5 across from (5, 3): object $1B
	db $85, $45, $1b  ; 5 across from (5, 4): object $1B
	db $85, $55, $1b  ; 5 across from (5, 5): object $1B
	db $82, $68, $1b  ; 2 across from (8, 6): object $1B
	db $54, $15  ; (4, 5): object $15
	db $55, $10  ; (5, 5): object $10
	db $56, $19  ; (6, 5): object $19
	db $67, $1b  ; (7, 6): object $1B
	db $83, $77, $1b  ; 3 across from (7, 7): object $1B
	db $84, $60, $f5  ; 4 across from (0, 6): object $F5
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $c2, $13, $30  ; 2 down from (3, 1): object $30
	db $c2, $05, $51  ; 2 down from (5, 0): object $51
	db $19, $51  ; (9, 1): object $51
	db $24, $30  ; (4, 2): object $30
	db $26, $51  ; (6, 2): object $51
	db $82, $45, $30  ; 2 across from (5, 4): object $30
	db $82, $48, $51  ; 2 across from (8, 4): object $51
	db $57, $30  ; (7, 5): object $30
	db $c2, $58, $51  ; 2 down from (8, 5): object $51
	db $82, $08, $51  ; 2 across from (8, 0): object $51
	db $11, $44  ; (1, 1): object $44
	db $33, $d4  ; (3, 3): object $D4
	db $c2, $00, $38  ; 2 down from (0, 0): object $38
	db $20, $4e  ; (0, 2): object $4E
	db $30, $3b  ; (0, 3): object $3B
	db $c2, $40, $0a  ; 2 down from (0, 4): object $0A
	db $51, $0a  ; (1, 5): object $0A
	db $53, $44  ; (3, 5): object $44
	db $37, $51  ; (7, 3): object $51
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $33 (row 3, column 3 of the 16 x 16 map): 13 objects on floor object $1B. Format: see OverworldRoomPointers.
OverworldRoom33::
	db $03, $1b  ; animated tiles $03, floor $1B
	db $84, $70, $1b  ; 4 across from (0, 7): object $1B
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $c2, $00, $51  ; 2 down from (0, 0): object $51
	db $c3, $04, $51  ; 3 down from (4, 0): object $51
	db $c4, $06, $51  ; 4 down from (6, 0): object $51
	db $c2, $09, $51  ; 2 down from (9, 0): object $51
	db $33, $51  ; (3, 3): object $51
	db $83, $40, $51  ; 3 across from (0, 4): object $51
	db $83, $47, $51  ; 3 across from (7, 4): object $51
	db $53, $51  ; (3, 5): object $51
	db $82, $61, $30  ; 2 across from (1, 6): object $30
	db $65, $51  ; (5, 6): object $51
	db $82, $67, $30  ; 2 across from (7, 6): object $30
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $34 (row 3, column 4 of the 16 x 16 map): 35 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom34::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $00, $1b  ; 6 across from (0, 0): object $1B
	db $86, $10, $1b  ; 6 across from (0, 1): object $1B
	db $84, $20, $1b  ; 4 across from (0, 2): object $1B
	db $83, $30, $1b  ; 3 across from (0, 3): object $1B
	db $83, $40, $1b  ; 3 across from (0, 4): object $1B
	db $83, $50, $1b  ; 3 across from (0, 5): object $1B
	db $83, $60, $1b  ; 3 across from (0, 6): object $1B
	db $83, $70, $1b  ; 3 across from (0, 7): object $1B
	db $83, $00, $51  ; 3 across from (0, 0): object $51
	db $05, $51  ; (5, 0): object $51
	db $c2, $06, $12  ; 2 down from (6, 0): object $12
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $10, $51  ; (0, 1): object $51
	db $c2, $12, $51  ; 2 down from (2, 1): object $51
	db $15, $30  ; (5, 1): object $30
	db $19, $f5  ; (9, 1): object $F5
	db $24, $1a  ; (4, 2): object $1A
	db $25, $10  ; (5, 2): object $10
	db $26, $16  ; (6, 2): object $16
	db $27, $f5  ; (7, 2): object $F5
	db $31, $51  ; (1, 3): object $51
	db $33, $1a  ; (3, 3): object $1A
	db $34, $16  ; (4, 3): object $16
	db $35, $f5  ; (5, 3): object $F5
	db $82, $40, $51  ; 2 across from (0, 4): object $51
	db $c2, $43, $12  ; 2 down from (3, 4): object $12
	db $c2, $44, $20  ; 2 down from (4, 4): object $20
	db $52, $30  ; (2, 5): object $30
	db $59, $f5  ; (9, 5): object $F5
	db $61, $30  ; (1, 6): object $30
	db $62, $f5  ; (2, 6): object $F5
	db $82, $66, $f5  ; 2 across from (6, 6): object $F5
	db $82, $7f, $f5  ; 2 across from (15, 7): object $F5
	db $82, $77, $f5  ; 2 across from (7, 7): object $F5
	db $11, $a0  ; (1, 1): object $A0
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $35 (row 3, column 5 of the 16 x 16 map): 25 objects on floor object $04; a warp (type 1) to map $15 room $F0 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom35::
	db $03, $04  ; animated tiles $03, floor $04
	db $60, $f5  ; (0, 6): object $F5
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $85, $71, $f5  ; 5 across from (1, 7): object $F5
	db $c3, $02, $37  ; 3 down from (2, 0): object $37
	db $32, $2e  ; (2, 3): object $2E
	db $87, $33, $2f  ; 7 across from (3, 3): object $2F
	db $36, $48  ; (6, 3): object $48
	db $82, $37, $4a  ; 2 across from (7, 3): object $4A
	db $39, $49  ; (9, 3): object $49
	db $42, $39  ; (2, 4): object $39
	db $87, $43, $3a  ; 7 across from (3, 4): object $3A
	db $45, $b6  ; (5, 4): object $B6
	db $46, $e1  ; (6, 4): object $E1
	db $47, $b6  ; (7, 4): object $B6
	db $e1, $15, $f0, $50, $7c  ; warp type 1 to map $15 room $F0, x 80 y 124
	db $c2, $30, $04  ; 2 down from (0, 3): object $04
	db $83, $03, $0f  ; 3 across from (3, 0): object $0F
	db $06, $14  ; (6, 0): object $14
	db $82, $13, $1b  ; 2 across from (3, 1): object $1B
	db $15, $30  ; (5, 1): object $30
	db $16, $12  ; (6, 1): object $12
	db $82, $23, $1b  ; 2 across from (3, 2): object $1B
	db $25, $1a  ; (5, 2): object $1A
	db $26, $16  ; (6, 2): object $16
	db $53, $6f  ; (3, 5): object $6F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $36 (row 3, column 6 of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom36::
	db $03, $04  ; animated tiles $03, floor $04
	db $30, $2f  ; (0, 3): object $2F
	db $40, $3a  ; (0, 4): object $3A
	db $83, $22, $3a  ; 3 across from (2, 2): object $3A
	db $11, $3d  ; (1, 1): object $3D
	db $12, $48  ; (2, 1): object $48
	db $13, $4a  ; (3, 1): object $4A
	db $14, $49  ; (4, 1): object $49
	db $15, $4e  ; (5, 1): object $4E
	db $05, $38  ; (5, 0): object $38
	db $25, $3b  ; (5, 2): object $3B
	db $06, $3b  ; (6, 0): object $3B
	db $82, $32, $0a  ; 2 across from (2, 3): object $0A
	db $42, $0a  ; (2, 4): object $0A
	db $16, $0a  ; (6, 1): object $0A
	db $46, $e8  ; (6, 4): object $E8
	db $64, $e8  ; (4, 6): object $E8
	db $c2, $59, $f5  ; 2 down from (9, 5): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $77, $f5  ; (7, 7): object $F5
	db $31, $4e  ; (1, 3): object $4E
	db $41, $3b  ; (1, 4): object $3B
	db $60, $f5  ; (0, 6): object $F5
	db $7f, $f5  ; (15, 7): object $F5
	db $24, $3a  ; (4, 2): object $3A
	db $21, $38  ; (1, 2): object $38
	db $43, $d4  ; (3, 4): object $D4
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $37 (row 3, column 7 of the 16 x 16 map): 16 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom37::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $5f, $f5  ; (15, 5): object $F5
	db $c2, $06, $37  ; 2 down from (6, 0): object $37
	db $c2, $37, $37  ; 2 down from (7, 3): object $37
	db $26, $2e  ; (6, 2): object $2E
	db $36, $39  ; (6, 3): object $39
	db $27, $3c  ; (7, 2): object $3C
	db $57, $2e  ; (7, 5): object $2E
	db $67, $39  ; (7, 6): object $39
	db $82, $58, $2f  ; 2 across from (8, 5): object $2F
	db $82, $68, $3a  ; 2 across from (8, 6): object $3A
	db $09, $09  ; (9, 0): object $09
	db $28, $09  ; (8, 2): object $09
	db $09, $37  ; (9, 0): object $37
	db $19, $2e  ; (9, 1): object $2E
	db $29, $39  ; (9, 2): object $39
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $38 (row 3, column 8 of the 16 x 16 map): 35 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom38::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $c2, $04, $38  ; 2 down from (4, 0): object $38
	db $83, $05, $3a  ; 3 across from (5, 0): object $3A
	db $08, $3e  ; (8, 0): object $3E
	db $c2, $09, $3a  ; 2 down from (9, 0): object $3A
	db $15, $3a  ; (5, 1): object $3A
	db $18, $39  ; (8, 1): object $39
	db $23, $3d  ; (3, 2): object $3D
	db $24, $4e  ; (4, 2): object $4E
	db $c2, $33, $38  ; 2 down from (3, 3): object $38
	db $53, $4e  ; (3, 5): object $4E
	db $83, $50, $2f  ; 3 across from (0, 5): object $2F
	db $83, $60, $3a  ; 3 across from (0, 6): object $3A
	db $34, $3f  ; (4, 3): object $3F
	db $44, $3b  ; (4, 4): object $3B
	db $63, $3f  ; (3, 6): object $3F
	db $73, $3f  ; (3, 7): object $3F
	db $7f, $f5  ; (15, 7): object $F5
	db $72, $38  ; (2, 7): object $38
	db $c3, $16, $37  ; 3 down from (6, 1): object $37
	db $46, $33  ; (6, 4): object $33
	db $47, $3c  ; (7, 4): object $3C
	db $57, $33  ; (7, 5): object $33
	db $82, $58, $2f  ; 2 across from (8, 5): object $2F
	db $82, $28, $0a  ; 2 across from (8, 2): object $0A
	db $c3, $25, $0e  ; 3 down from (5, 2): object $0E
	db $83, $54, $0e  ; 3 across from (4, 5): object $0E
	db $86, $64, $0e  ; 6 across from (4, 6): object $0E
	db $74, $0e  ; (4, 7): object $0E
	db $75, $2b  ; (5, 7): object $2B
	db $84, $76, $2c  ; 4 across from (6, 7): object $2C
	db $00, $38  ; (0, 0): object $38
	db $10, $4e  ; (0, 1): object $4E
	db $20, $3b  ; (0, 2): object $3B
	db $16, $de  ; (6, 1): object $DE
	db $72, $dd  ; (2, 7): object $DD
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $39 (row 3, column 9 of the 16 x 16 map): 18 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom39::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $82, $00, $3a  ; 2 across from (0, 0): object $3A
	db $82, $10, $3a  ; 2 across from (0, 1): object $3A
	db $c2, $01, $e0  ; 2 down from (1, 0): object $E0
	db $02, $3f  ; (2, 0): object $3F
	db $12, $3b  ; (2, 1): object $3B
	db $84, $20, $0a  ; 4 across from (0, 2): object $0A
	db $03, $0a  ; (3, 0): object $0A
	db $16, $f5  ; (6, 1): object $F5
	db $8a, $50, $2f  ; 10 across from (0, 5): object $2F
	db $8a, $60, $0e  ; 10 across from (0, 6): object $0E
	db $8a, $70, $2c  ; 10 across from (0, 7): object $2C
	db $04, $33  ; (4, 0): object $33
	db $05, $2f  ; (5, 0): object $2F
	db $06, $34  ; (6, 0): object $34
	db $82, $07, $0a  ; 2 across from (7, 0): object $0A
	db $09, $33  ; (9, 0): object $33
	db $82, $14, $0a  ; 2 across from (4, 1): object $0A
	db $19, $0a  ; (9, 1): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $3A (row 3, column A of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom3A::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $35, $3d  ; (5, 3): object $3D
	db $84, $36, $2f  ; 4 across from (6, 3): object $2F
	db $45, $38  ; (5, 4): object $38
	db $84, $46, $0e  ; 4 across from (6, 4): object $0E
	db $85, $50, $2f  ; 5 across from (0, 5): object $2F
	db $55, $34  ; (5, 5): object $34
	db $82, $56, $0e  ; 2 across from (6, 5): object $0E
	db $58, $2b  ; (8, 5): object $2B
	db $59, $2c  ; (9, 5): object $2C
	db $88, $60, $0e  ; 8 across from (0, 6): object $0E
	db $68, $37  ; (8, 6): object $37
	db $69, $f5  ; (9, 6): object $F5
	db $88, $70, $2c  ; 8 across from (0, 7): object $2C
	db $78, $31  ; (8, 7): object $31
	db $8a, $00, $0a  ; 10 across from (0, 0): object $0A
	db $82, $10, $0a  ; 2 across from (0, 1): object $0A
	db $83, $14, $0a  ; 3 across from (4, 1): object $0A
	db $19, $0a  ; (9, 1): object $0A
	db $00, $2f  ; (0, 0): object $2F
	db $01, $34  ; (1, 0): object $34
	db $04, $33  ; (4, 0): object $33
	db $05, $2f  ; (5, 0): object $2F
	db $06, $34  ; (6, 0): object $34
	db $09, $33  ; (9, 0): object $33
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $3B (row 3, column B of the 16 x 16 map): 40 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom3B::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $86, $30, $2f  ; 6 across from (0, 3): object $2F
	db $36, $3c  ; (6, 3): object $3C
	db $46, $33  ; (6, 4): object $33
	db $47, $2f  ; (7, 4): object $2F
	db $48, $3c  ; (8, 4): object $3C
	db $c2, $58, $37  ; 2 down from (8, 5): object $37
	db $68, $2e  ; (8, 6): object $2E
	db $69, $3c  ; (9, 6): object $3C
	db $79, $37  ; (9, 7): object $37
	db $78, $3e  ; (8, 7): object $3E
	db $86, $40, $0e  ; 6 across from (0, 4): object $0E
	db $88, $50, $0e  ; 8 across from (0, 5): object $0E
	db $84, $64, $0e  ; 4 across from (4, 6): object $0E
	db $77, $0e  ; (7, 7): object $0E
	db $83, $50, $2c  ; 3 across from (0, 5): object $2C
	db $51, $e0  ; (1, 5): object $E0
	db $53, $2d  ; (3, 5): object $2D
	db $6f, $f5  ; (15, 6): object $F5
	db $63, $38  ; (3, 6): object $38
	db $73, $32  ; (3, 7): object $32
	db $82, $74, $2c  ; 2 across from (4, 7): object $2C
	db $76, $2d  ; (6, 7): object $2D
	db $33, $48  ; (3, 3): object $48
	db $34, $e0  ; (4, 3): object $E0
	db $35, $49  ; (5, 3): object $49
	db $00, $2f  ; (0, 0): object $2F
	db $01, $34  ; (1, 0): object $34
	db $02, $33  ; (2, 0): object $33
	db $03, $2f  ; (3, 0): object $2F
	db $04, $34  ; (4, 0): object $34
	db $05, $33  ; (5, 0): object $33
	db $06, $2f  ; (6, 0): object $2F
	db $07, $34  ; (7, 0): object $34
	db $08, $37  ; (8, 0): object $37
	db $09, $e8  ; (9, 0): object $E8
	db $88, $10, $0a  ; 8 across from (0, 1): object $0A
	db $18, $33  ; (8, 1): object $33
	db $19, $2f  ; (9, 1): object $2F
	db $85, $25, $0a  ; 5 across from (5, 2): object $0A
	db $82, $37, $0a  ; 2 across from (7, 3): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $3C (row 3, column C of the 16 x 16 map): 38 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom3C::
	db $0a, $04  ; animated tiles $0A, floor $04
	db $00, $38  ; (0, 0): object $38
	db $10, $34  ; (0, 1): object $34
	db $01, $37  ; (1, 0): object $37
	db $02, $e8  ; (2, 0): object $E8
	db $03, $38  ; (3, 0): object $38
	db $11, $33  ; (1, 1): object $33
	db $12, $2f  ; (2, 1): object $2F
	db $13, $34  ; (3, 1): object $34
	db $05, $37  ; (5, 0): object $37
	db $06, $e8  ; (6, 0): object $E8
	db $07, $38  ; (7, 0): object $38
	db $15, $33  ; (5, 1): object $33
	db $16, $2f  ; (6, 1): object $2F
	db $17, $34  ; (7, 1): object $34
	db $09, $37  ; (9, 0): object $37
	db $19, $33  ; (9, 1): object $33
	db $41, $3d  ; (1, 4): object $3D
	db $88, $42, $2f  ; 8 across from (2, 4): object $2F
	db $51, $38  ; (1, 5): object $38
	db $61, $4e  ; (1, 6): object $4E
	db $60, $3d  ; (0, 6): object $3D
	db $70, $38  ; (0, 7): object $38
	db $71, $3f  ; (1, 7): object $3F
	db $52, $0e  ; (2, 5): object $0E
	db $87, $53, $0e  ; 7 across from (3, 5): object $0E
	db $83, $67, $0e  ; 3 across from (7, 6): object $0E
	db $83, $62, $e9  ; 3 across from (2, 6): object $E9
	db $83, $72, $e9  ; 3 across from (2, 7): object $E9
	db $65, $49  ; (5, 6): object $49
	db $66, $3c  ; (6, 6): object $3C
	db $75, $3a  ; (5, 7): object $3A
	db $76, $2e  ; (6, 7): object $2E
	db $83, $77, $2f  ; 3 across from (7, 7): object $2F
	db $84, $20, $0a  ; 4 across from (0, 2): object $0A
	db $14, $0a  ; (4, 1): object $0A
	db $83, $25, $0a  ; 3 across from (5, 2): object $0A
	db $18, $0a  ; (8, 1): object $0A
	db $29, $0a  ; (9, 2): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $3D (row 3, column D of the 16 x 16 map): 25 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom3D::
	db $0a, $04  ; animated tiles $0A, floor $04
	db $00, $e8  ; (0, 0): object $E8
	db $01, $38  ; (1, 0): object $38
	db $10, $2f  ; (0, 1): object $2F
	db $11, $34  ; (1, 1): object $34
	db $04, $37  ; (4, 0): object $37
	db $05, $e8  ; (5, 0): object $E8
	db $06, $38  ; (6, 0): object $38
	db $14, $33  ; (4, 1): object $33
	db $15, $2f  ; (5, 1): object $2F
	db $16, $34  ; (6, 1): object $34
	db $8a, $40, $2f  ; 10 across from (0, 4): object $2F
	db $8a, $50, $0e  ; 10 across from (0, 5): object $0E
	db $60, $0e  ; (0, 6): object $0E
	db $70, $2f  ; (0, 7): object $2F
	db $71, $4e  ; (1, 7): object $4E
	db $61, $3d  ; (1, 6): object $3D
	db $62, $48  ; (2, 6): object $48
	db $72, $3a  ; (2, 7): object $3A
	db $82, $63, $e9  ; 2 across from (3, 6): object $E9
	db $82, $73, $e9  ; 2 across from (3, 7): object $E9
	db $65, $49  ; (5, 6): object $49
	db $84, $66, $2f  ; 4 across from (6, 6): object $2F
	db $85, $75, $3a  ; 5 across from (5, 7): object $3A
	db $82, $20, $0a  ; 2 across from (0, 2): object $0A
	db $83, $24, $0a  ; 3 across from (4, 2): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $3E (row 3, column E of the 16 x 16 map): 19 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom3E::
	db $0b, $04  ; animated tiles $0B, floor $04
	db $c2, $03, $38  ; 2 down from (3, 0): object $38
	db $c4, $04, $0e  ; 4 down from (4, 0): object $0E
	db $05, $2b  ; (5, 0): object $2B
	db $06, $31  ; (6, 0): object $31
	db $c2, $09, $f5  ; 2 down from (9, 0): object $F5
	db $c3, $15, $37  ; 3 down from (5, 1): object $37
	db $21, $3d  ; (1, 2): object $3D
	db $22, $e0  ; (2, 2): object $E0
	db $23, $34  ; (3, 2): object $34
	db $31, $38  ; (1, 3): object $38
	db $83, $32, $0e  ; 3 across from (2, 3): object $0E
	db $40, $2f  ; (0, 4): object $2F
	db $41, $34  ; (1, 4): object $34
	db $83, $42, $ca  ; 3 across from (2, 4): object $CA
	db $45, $33  ; (5, 4): object $33
	db $84, $46, $2f  ; 4 across from (6, 4): object $2F
	db $8a, $50, $0e  ; 10 across from (0, 5): object $0E
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $3F (row 3, column F of the 16 x 16 map): 24 objects on floor object $04; a warp (type 1) to map $10 room $B0 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom3F::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $0f, $f5  ; 2 down from (15, 0): object $F5
	db $01, $fd  ; (1, 0): object $FD
	db $82, $21, $0a  ; 2 across from (1, 2): object $0A
	db $14, $0a  ; (4, 1): object $0A
	db $c2, $06, $38  ; 2 down from (6, 0): object $38
	db $25, $3d  ; (5, 2): object $3D
	db $26, $34  ; (6, 2): object $34
	db $35, $38  ; (5, 3): object $38
	db $45, $34  ; (5, 4): object $34
	db $84, $40, $2f  ; 4 across from (0, 4): object $2F
	db $44, $e0  ; (4, 4): object $E0
	db $89, $60, $2f  ; 9 across from (0, 6): object $2F
	db $89, $70, $3a  ; 9 across from (0, 7): object $3A
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $c6, $07, $0e  ; 6 down from (7, 0): object $0E
	db $c3, $36, $0e  ; 3 down from (6, 3): object $0E
	db $86, $50, $0e  ; 6 across from (0, 5): object $0E
	db $c6, $08, $0e  ; 6 down from (8, 0): object $0E
	db $23, $d4  ; (3, 2): object $D4
	db $69, $4e  ; (9, 6): object $4E
	db $79, $3f  ; (9, 7): object $3F
	db $e1, $10, $b0, $50, $7c  ; warp type 1 to map $10 room $B0, x 80 y 124
	db $01, $b6  ; (1, 0): object $B6
	db $02, $b7  ; (2, 0): object $B7
	db $03, $66  ; (3, 0): object $66
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $40 (row 4, column 0 of the 16 x 16 map): 31 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom40::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $37  ; 8 down from (0, 0): object $37
	db $c4, $01, $90  ; 4 down from (1, 0): object $90
	db $c4, $02, $90  ; 4 down from (2, 0): object $90
	db $41, $88  ; (1, 4): object $88
	db $c3, $51, $87  ; 3 down from (1, 5): object $87
	db $03, $8e  ; (3, 0): object $8E
	db $c2, $13, $87  ; 2 down from (3, 1): object $87
	db $33, $8a  ; (3, 3): object $8A
	db $86, $34, $85  ; 6 across from (4, 3): object $85
	db $88, $42, $84  ; 8 across from (2, 4): object $84
	db $c2, $f1, $f5  ; 2 down from (1, 15): object $F5
	db $14, $08  ; (4, 1): object $08
	db $27, $08  ; (7, 2): object $08
	db $52, $08  ; (2, 5): object $08
	db $83, $53, $5c  ; 3 across from (3, 5): object $5C
	db $75, $0a  ; (5, 7): object $0A
	db $76, $8f  ; (6, 7): object $8F
	db $83, $77, $85  ; 3 across from (7, 7): object $85
	db $08, $8f  ; (8, 0): object $8F
	db $09, $90  ; (9, 0): object $90
	db $18, $8d  ; (8, 1): object $8D
	db $19, $84  ; (9, 1): object $84
	db $f9, $f5  ; (9, 15): object $F5
	db $35, $8e  ; (5, 3): object $8E
	db $36, $04  ; (6, 3): object $04
	db $37, $8f  ; (7, 3): object $8F
	db $45, $8c  ; (5, 4): object $8C
	db $46, $e8  ; (6, 4): object $E8
	db $47, $8d  ; (7, 4): object $8D
	db $28, $44  ; (8, 2): object $44
	db $72, $44  ; (2, 7): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $41 (row 4, column 1 of the 16 x 16 map): 34 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom41::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $90  ; 10 across from (0, 0): object $90
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $8a, $10, $84  ; 10 across from (0, 1): object $84
	db $16, $89  ; (6, 1): object $89
	db $17, $88  ; (7, 1): object $88
	db $26, $86  ; (6, 2): object $86
	db $27, $87  ; (7, 2): object $87
	db $36, $8d  ; (6, 3): object $8D
	db $37, $8c  ; (7, 3): object $8C
	db $c2, $47, $e8  ; 2 down from (7, 4): object $E8
	db $82, $30, $85  ; 2 across from (0, 3): object $85
	db $32, $8e  ; (2, 3): object $8E
	db $40, $84  ; (0, 4): object $84
	db $41, $89  ; (1, 4): object $89
	db $c4, $42, $87  ; 4 down from (2, 4): object $87
	db $c2, $51, $86  ; 2 down from (1, 5): object $86
	db $70, $85  ; (0, 7): object $85
	db $71, $8b  ; (1, 7): object $8B
	db $58, $8f  ; (8, 5): object $8F
	db $59, $85  ; (9, 5): object $85
	db $67, $8f  ; (7, 6): object $8F
	db $77, $86  ; (7, 7): object $86
	db $82, $68, $90  ; 2 across from (8, 6): object $90
	db $82, $78, $90  ; 2 across from (8, 7): object $90
	db $68, $f5  ; (8, 6): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $83, $33, $5c  ; 3 across from (3, 3): object $5C
	db $44, $5c  ; (4, 4): object $5C
	db $34, $a0  ; (4, 3): object $A0
	db $28, $08  ; (8, 2): object $08
	db $c2, $66, $0a  ; 2 down from (6, 6): object $0A
	db $65, $08  ; (5, 6): object $08
	db $38, $44  ; (8, 3): object $44
	db $73, $44  ; (3, 7): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $42 (row 4, column 2 of the 16 x 16 map): 47 objects on floor object $04; a warp (type 1) to map $11 room $B3 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom42::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $90  ; 10 across from (0, 0): object $90
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $8a, $10, $84  ; 10 across from (0, 1): object $84
	db $11, $89  ; (1, 1): object $89
	db $21, $86  ; (1, 2): object $86
	db $31, $8d  ; (1, 3): object $8D
	db $32, $8c  ; (2, 3): object $8C
	db $22, $87  ; (2, 2): object $87
	db $12, $88  ; (2, 1): object $88
	db $13, $92  ; (3, 1): object $92
	db $14, $89  ; (4, 1): object $89
	db $24, $86  ; (4, 2): object $86
	db $34, $8d  ; (4, 3): object $8D
	db $35, $84  ; (5, 3): object $84
	db $23, $e4  ; (3, 2): object $E4
	db $36, $8c  ; (6, 3): object $8C
	db $26, $87  ; (6, 2): object $87
	db $16, $88  ; (6, 1): object $88
	db $50, $8e  ; (0, 5): object $8E
	db $60, $8a  ; (0, 6): object $8A
	db $61, $8e  ; (1, 6): object $8E
	db $70, $90  ; (0, 7): object $90
	db $71, $87  ; (1, 7): object $87
	db $48, $8f  ; (8, 4): object $8F
	db $49, $85  ; (9, 4): object $85
	db $58, $86  ; (8, 5): object $86
	db $68, $8b  ; (8, 6): object $8B
	db $66, $8f  ; (6, 6): object $8F
	db $67, $85  ; (7, 6): object $85
	db $76, $86  ; (6, 7): object $86
	db $83, $77, $90  ; 3 across from (7, 7): object $90
	db $c2, $59, $90  ; 2 down from (9, 5): object $90
	db $c2, $20, $0a  ; 2 down from (0, 2): object $0A
	db $41, $0a  ; (1, 4): object $0A
	db $42, $20  ; (2, 4): object $20
	db $44, $20  ; (4, 4): object $20
	db $53, $20  ; (3, 5): object $20
	db $c2, $47, $0a  ; 2 down from (7, 4): object $0A
	db $c2, $65, $0a  ; 2 down from (5, 6): object $0A
	db $51, $08  ; (1, 5): object $08
	db $c2, $15, $90  ; 2 down from (5, 1): object $90
	db $59, $f5  ; (9, 5): object $F5
	db $82, $77, $f5  ; 2 across from (7, 7): object $F5
	db $7f, $f5  ; (15, 7): object $F5
	db $33, $e3  ; (3, 3): object $E3
	db $e1, $11, $b3, $50, $7c  ; warp type 1 to map $11 room $B3, x 80 y 124
	db $56, $44  ; (6, 5): object $44
	db $64, $44  ; (4, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $43 (row 4, column 3 of the 16 x 16 map): 27 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom43::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $90  ; 10 across from (0, 0): object $90
	db $85, $ff, $f5  ; 5 across from (15, 15): object $F5
	db $8a, $10, $84  ; 10 across from (0, 1): object $84
	db $28, $8c  ; (8, 2): object $8C
	db $40, $85  ; (0, 4): object $85
	db $41, $8e  ; (1, 4): object $8E
	db $51, $87  ; (1, 5): object $87
	db $61, $8a  ; (1, 6): object $8A
	db $86, $62, $85  ; 6 across from (2, 6): object $85
	db $88, $70, $90  ; 8 across from (0, 7): object $90
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $67, $8e  ; (7, 6): object $8E
	db $c2, $50, $90  ; 2 down from (0, 5): object $90
	db $5f, $f5  ; (15, 5): object $F5
	db $86, $52, $0a  ; 6 across from (2, 5): object $0A
	db $68, $0a  ; (8, 6): object $0A
	db $32, $08  ; (2, 3): object $08
	db $48, $08  ; (8, 4): object $08
	db $69, $08  ; (9, 6): object $08
	db $17, $89  ; (7, 1): object $89
	db $27, $8d  ; (7, 2): object $8D
	db $82, $18, $90  ; 2 across from (8, 1): object $90
	db $82, $28, $90  ; 2 across from (8, 2): object $90
	db $c2, $08, $f5  ; 2 down from (8, 0): object $F5
	db $19, $f5  ; (9, 1): object $F5
	db $33, $44  ; (3, 3): object $44
	db $46, $44  ; (6, 4): object $44
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $44 (row 4, column 4 of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom44::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $ff, $f5  ; 2 across from (15, 15): object $F5
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $85, $00, $f5  ; 5 across from (0, 0): object $F5
	db $82, $04, $04  ; 2 across from (4, 0): object $04
	db $82, $14, $04  ; 2 across from (4, 1): object $04
	db $82, $1f, $f5  ; 2 across from (15, 1): object $F5
	db $7f, $f5  ; (15, 7): object $F5
	db $c2, $59, $f5  ; 2 down from (9, 5): object $F5
	db $83, $23, $e8  ; 3 across from (3, 2): object $E8
	db $83, $63, $e8  ; 3 across from (3, 6): object $E8
	db $c3, $32, $e8  ; 3 down from (2, 3): object $E8
	db $c3, $36, $e8  ; 3 down from (6, 3): object $E8
	db $83, $33, $0a  ; 3 across from (3, 3): object $0A
	db $83, $43, $0a  ; 3 across from (3, 4): object $0A
	db $83, $53, $0a  ; 3 across from (3, 5): object $0A
	db $82, $50, $0b  ; 2 across from (0, 5): object $0B
	db $82, $61, $0b  ; 2 across from (1, 6): object $0B
	db $72, $0b  ; (2, 7): object $0B
	db $33, $e8  ; (3, 3): object $E8
	db $35, $e8  ; (5, 3): object $E8
	db $53, $e8  ; (3, 5): object $E8
	db $55, $e8  ; (5, 5): object $E8
	db $37, $44  ; (7, 3): object $44
	db $58, $44  ; (8, 5): object $44
	db $20, $f5  ; (0, 2): object $F5
	db $26, $20  ; (6, 2): object $20
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $45 (row 4, column 5 of the 16 x 16 map): 26 objects on floor object $04; a warp (type 1) to map $0E room $AD at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom45::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $85, $00, $f5  ; 5 across from (0, 0): object $F5
	db $c2, $5f, $f5  ; 2 down from (15, 5): object $F5
	db $13, $f5  ; (3, 1): object $F5
	db $33, $20  ; (3, 3): object $20
	db $42, $3d  ; (2, 4): object $3D
	db $82, $43, $2f  ; 2 across from (3, 4): object $2F
	db $44, $e0  ; (4, 4): object $E0
	db $45, $3c  ; (5, 4): object $3C
	db $84, $46, $0a  ; 4 across from (6, 4): object $0A
	db $51, $20  ; (1, 5): object $20
	db $52, $38  ; (2, 5): object $38
	db $82, $53, $1b  ; 2 across from (3, 5): object $1B
	db $55, $37  ; (5, 5): object $37
	db $83, $56, $0a  ; 3 across from (6, 5): object $0A
	db $61, $0a  ; (1, 6): object $0A
	db $62, $32  ; (2, 6): object $32
	db $82, $63, $2c  ; 2 across from (3, 6): object $2C
	db $65, $31  ; (5, 6): object $31
	db $66, $0a  ; (6, 6): object $0A
	db $83, $73, $0a  ; 3 across from (3, 7): object $0A
	db $20, $44  ; (0, 2): object $44
	db $78, $44  ; (8, 7): object $44
	db $22, $d4  ; (2, 2): object $D4
	db $27, $fd  ; (7, 2): object $FD
	db $e1, $0e, $ad, $50, $7c  ; warp type 1 to map $0E room $AD, x 80 y 124
	db $c2, $59, $f5  ; 2 down from (9, 5): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $46 (row 4, column 6 of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom46::
	db $03, $04  ; animated tiles $03, floor $04
	db $ff, $f5  ; (15, 15): object $F5
	db $59, $0a  ; (9, 5): object $0A
	db $c2, $00, $f5  ; 2 down from (0, 0): object $F5
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $14, $fb  ; (4, 1): object $FB
	db $18, $fb  ; (8, 1): object $FB
	db $36, $fb  ; (6, 3): object $FB
	db $49, $fb  ; (9, 4): object $FB
	db $53, $fb  ; (3, 5): object $FB
	db $75, $fb  ; (5, 7): object $FB
	db $79, $fb  ; (9, 7): object $FB
	db $c3, $12, $0a  ; 3 down from (2, 1): object $0A
	db $23, $0a  ; (3, 2): object $0A
	db $83, $33, $09  ; 3 across from (3, 3): object $09
	db $82, $42, $09  ; 2 across from (2, 4): object $09
	db $c2, $40, $0a  ; 2 down from (0, 4): object $0A
	db $51, $09  ; (1, 5): object $09
	db $82, $67, $09  ; 2 across from (7, 6): object $09
	db $82, $38, $03  ; 2 across from (8, 3): object $03
	db $48, $03  ; (8, 4): object $03
	db $82, $56, $03  ; 2 across from (6, 5): object $03
	db $82, $71, $03  ; 2 across from (1, 7): object $03
	db $c2, $5f, $f5  ; 2 down from (15, 5): object $F5
	db $41, $20  ; (1, 4): object $20
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $47 (row 4, column 7 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom47::
	db $03, $04  ; animated tiles $03, floor $04
	db $50, $0a  ; (0, 5): object $0A
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $c4, $08, $f5  ; 4 down from (8, 0): object $F5
	db $10, $fb  ; (0, 1): object $FB
	db $25, $fb  ; (5, 2): object $FB
	db $3f, $fb  ; (15, 3): object $FB
	db $52, $fb  ; (2, 5): object $FB
	db $70, $b7  ; (0, 7): object $B7
	db $22, $e8  ; (2, 2): object $E8
	db $15, $09  ; (5, 1): object $09
	db $23, $09  ; (3, 2): object $09
	db $84, $30, $03  ; 4 across from (0, 3): object $03
	db $82, $44, $09  ; 2 across from (4, 4): object $09
	db $47, $03  ; (7, 4): object $03
	db $55, $e8  ; (5, 5): object $E8
	db $67, $09  ; (7, 6): object $09
	db $82, $56, $03  ; 2 across from (6, 5): object $03
	db $82, $64, $03  ; 2 across from (4, 6): object $03
	db $82, $72, $03  ; 2 across from (2, 7): object $03
	db $82, $74, $09  ; 2 across from (4, 7): object $09
	db $77, $03  ; (7, 7): object $03
	db $06, $f5  ; (6, 0): object $F5
	db $17, $f5  ; (7, 1): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $48 (row 4, column 8 of the 16 x 16 map): 31 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom48::
	db $03, $04  ; animated tiles $03, floor $04
	db $ff, $f5  ; (15, 15): object $F5
	db $10, $3d  ; (0, 1): object $3D
	db $11, $2f  ; (1, 1): object $2F
	db $12, $4e  ; (2, 1): object $4E
	db $02, $38  ; (2, 0): object $38
	db $03, $3b  ; (3, 0): object $3B
	db $21, $3a  ; (1, 2): object $3A
	db $22, $3b  ; (2, 2): object $3B
	db $c6, $20, $38  ; 6 down from (0, 2): object $38
	db $c5, $31, $0e  ; 5 down from (1, 3): object $0E
	db $83, $32, $0e  ; 3 across from (2, 3): object $0E
	db $c3, $13, $0e  ; 3 down from (3, 1): object $0E
	db $c4, $04, $0e  ; 4 down from (4, 0): object $0E
	db $05, $9b  ; (5, 0): object $9B
	db $84, $06, $99  ; 4 across from (6, 0): object $99
	db $84, $16, $96  ; 4 across from (6, 1): object $96
	db $84, $26, $93  ; 4 across from (6, 2): object $93
	db $c3, $15, $9a  ; 3 down from (5, 1): object $9A
	db $45, $9e  ; (5, 4): object $9E
	db $82, $43, $99  ; 2 across from (3, 4): object $99
	db $42, $9b  ; (2, 4): object $9B
	db $c3, $52, $9a  ; 3 down from (2, 5): object $9A
	db $82, $53, $96  ; 2 across from (3, 5): object $96
	db $55, $98  ; (5, 5): object $98
	db $82, $63, $93  ; 2 across from (3, 6): object $93
	db $65, $95  ; (5, 6): object $95
	db $59, $9b  ; (9, 5): object $9B
	db $68, $9b  ; (8, 6): object $9B
	db $78, $9a  ; (8, 7): object $9A
	db $c2, $69, $9a  ; 2 down from (9, 6): object $9A
	db $73, $f5  ; (3, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $49 (row 4, column 9 of the 16 x 16 map): 9 objects on floor object $04; a warp (type 2) to map $1F room $EB at x 24, y 48. Format: see OverworldRoomPointers.
OverworldRoom49::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $99  ; 10 across from (0, 0): object $99
	db $8a, $10, $96  ; 10 across from (0, 1): object $96
	db $8a, $20, $93  ; 10 across from (0, 2): object $93
	db $82, $42, $f5  ; 2 across from (2, 4): object $F5
	db $39, $44  ; (9, 3): object $44
	db $8a, $50, $99  ; 10 across from (0, 5): object $99
	db $8a, $60, $0c  ; 10 across from (0, 6): object $0C
	db $8a, $70, $0c  ; 10 across from (0, 7): object $0C
	db $46, $c6  ; (6, 4): object $C6
	db $e2, $1f, $eb, $18, $30  ; warp type 2 to map $1F room $EB, x 24 y 48
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $4A (row 4, column A of the 16 x 16 map): 21 objects on floor object $04; a warp (type 2) to map $1F room $EC at x 104, y 48. Format: see OverworldRoomPointers.
OverworldRoom4A::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $00, $99  ; 6 across from (0, 0): object $99
	db $06, $9c  ; (6, 0): object $9C
	db $82, $07, $f5  ; 2 across from (7, 0): object $F5
	db $86, $10, $96  ; 6 across from (0, 1): object $96
	db $c3, $16, $9a  ; 3 down from (6, 1): object $9A
	db $86, $20, $93  ; 6 across from (0, 2): object $93
	db $83, $27, $44  ; 3 across from (7, 2): object $44
	db $83, $37, $44  ; 3 across from (7, 3): object $44
	db $28, $d3  ; (8, 2): object $D3
	db $46, $9d  ; (6, 4): object $9D
	db $82, $47, $99  ; 2 across from (7, 4): object $99
	db $49, $9c  ; (9, 4): object $9C
	db $50, $9c  ; (0, 5): object $9C
	db $56, $97  ; (6, 5): object $97
	db $82, $57, $96  ; 2 across from (7, 5): object $96
	db $c3, $59, $9a  ; 3 down from (9, 5): object $9A
	db $c2, $60, $9a  ; 2 down from (0, 6): object $9A
	db $61, $9c  ; (1, 6): object $9C
	db $71, $9a  ; (1, 7): object $9A
	db $66, $94  ; (6, 6): object $94
	db $82, $67, $93  ; 2 across from (7, 6): object $93
	db $e2, $1f, $ec, $68, $30  ; warp type 2 to map $1F room $EC, x 104 y 48
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $4B (row 4, column B of the 16 x 16 map): 12 objects on floor object $04; a warp (type 1) to map $10 room $CC at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom4B::
	db $03, $04  ; animated tiles $03, floor $04
	db $0f, $f5  ; (15, 0): object $F5
	db $c2, $06, $0e  ; 2 down from (6, 0): object $0E
	db $c8, $07, $0e  ; 8 down from (7, 0): object $0E
	db $08, $39  ; (8, 0): object $39
	db $c7, $18, $0e  ; 7 down from (8, 1): object $0E
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c2, $40, $f5  ; 2 down from (0, 4): object $F5
	db $03, $f5  ; (3, 0): object $F5
	db $04, $f5  ; (4, 0): object $F5
	db $14, $e1  ; (4, 1): object $E1
	db $04, $45  ; (4, 0): object $45
	db $e1, $10, $cc, $50, $7c  ; warp type 1 to map $10 room $CC, x 80 y 124
	db $c8, $06, $38  ; 8 down from (6, 0): object $38
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $4C (row 4, column C of the 16 x 16 map): 29 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom4C::
	db $0a, $eb  ; animated tiles $0A, floor $EB
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $01, $3f  ; (1, 0): object $3F
	db $11, $3b  ; (1, 1): object $3B
	db $83, $02, $e9  ; 3 across from (2, 0): object $E9
	db $83, $12, $e9  ; 3 across from (2, 1): object $E9
	db $c2, $05, $3a  ; 2 down from (5, 0): object $3A
	db $c2, $06, $3e  ; 2 down from (6, 0): object $3E
	db $26, $39  ; (6, 2): object $39
	db $83, $07, $3a  ; 3 across from (7, 0): object $3A
	db $83, $17, $3a  ; 3 across from (7, 1): object $3A
	db $83, $27, $3a  ; 3 across from (7, 2): object $3A
	db $c4, $21, $ed  ; 4 down from (1, 2): object $ED
	db $52, $ed  ; (2, 5): object $ED
	db $82, $24, $ed  ; 2 across from (4, 2): object $ED
	db $46, $ed  ; (6, 4): object $ED
	db $47, $c8  ; (7, 4): object $C8
	db $82, $61, $e9  ; 2 across from (1, 6): object $E9
	db $82, $71, $e9  ; 2 across from (1, 7): object $E9
	db $82, $67, $e9  ; 2 across from (7, 6): object $E9
	db $82, $77, $e9  ; 2 across from (7, 7): object $E9
	db $63, $2b  ; (3, 6): object $2B
	db $69, $2b  ; (9, 6): object $2B
	db $73, $2e  ; (3, 7): object $2E
	db $79, $2e  ; (9, 7): object $2E
	db $82, $64, $2c  ; 2 across from (4, 6): object $2C
	db $66, $2d  ; (6, 6): object $2D
	db $82, $74, $2f  ; 2 across from (4, 7): object $2F
	db $76, $4e  ; (6, 7): object $4E
	db $c2, $22, $ed  ; 2 down from (2, 2): object $ED
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $4D (row 4, column D of the 16 x 16 map): 35 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom4D::
	db $0a, $eb  ; animated tiles $0A, floor $EB
	db $c3, $00, $3a  ; 3 down from (0, 0): object $3A
	db $c2, $01, $3f  ; 2 down from (1, 0): object $3F
	db $02, $3b  ; (2, 0): object $3B
	db $c2, $02, $3a  ; 2 down from (2, 0): object $3A
	db $85, $05, $3a  ; 5 across from (5, 0): object $3A
	db $85, $15, $3a  ; 5 across from (5, 1): object $3A
	db $82, $03, $e9  ; 2 across from (3, 0): object $E9
	db $82, $13, $e9  ; 2 across from (3, 1): object $E9
	db $31, $ed  ; (1, 3): object $ED
	db $32, $c8  ; (2, 3): object $C8
	db $c2, $25, $ed  ; 2 down from (5, 2): object $ED
	db $46, $ed  ; (6, 4): object $ED
	db $58, $ed  ; (8, 5): object $ED
	db $17, $21  ; (7, 1): object $21
	db $18, $4f  ; (8, 1): object $4F
	db $26, $b6  ; (6, 2): object $B6
	db $27, $4f  ; (7, 2): object $4F
	db $28, $21  ; (8, 2): object $21
	db $29, $b7  ; (9, 2): object $B7
	db $36, $cd  ; (6, 3): object $CD
	db $37, $21  ; (7, 3): object $21
	db $38, $4f  ; (8, 3): object $4F
	db $39, $ce  ; (9, 3): object $CE
	db $47, $cd  ; (7, 4): object $CD
	db $48, $ce  ; (8, 4): object $CE
	db $60, $2c  ; (0, 6): object $2C
	db $61, $2d  ; (1, 6): object $2D
	db $70, $2f  ; (0, 7): object $2F
	db $71, $4e  ; (1, 7): object $4E
	db $21, $3b  ; (1, 2): object $3B
	db $62, $fb  ; (2, 6): object $FB
	db $64, $fb  ; (4, 6): object $FB
	db $66, $fb  ; (6, 6): object $FB
	db $78, $b6  ; (8, 7): object $B6
	db $79, $b7  ; (9, 7): object $B7
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $4E (row 4, column E of the 16 x 16 map): 15 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom4E::
	db $09, $eb  ; animated tiles $09, floor $EB
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $20, $fb  ; (0, 2): object $FB
	db $c4, $24, $ed  ; 4 down from (4, 2): object $ED
	db $45, $fb  ; (5, 4): object $FB
	db $47, $fb  ; (7, 4): object $FB
	db $49, $b6  ; (9, 4): object $B6
	db $59, $cd  ; (9, 5): object $CD
	db $70, $fb  ; (0, 7): object $FB
	db $72, $fb  ; (2, 7): object $FB
	db $74, $c8  ; (4, 7): object $C8
	db $75, $fb  ; (5, 7): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $79, $b6  ; (9, 7): object $B6
	db $c2, $24, $eb  ; 2 down from (4, 2): object $EB
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $4F (row 4, column F of the 16 x 16 map): 19 objects on floor object $ED. Format: see OverworldRoomPointers.
OverworldRoom4F::
	db $09, $ed  ; animated tiles $09, floor $ED
	db $89, $00, $3a  ; 9 across from (0, 0): object $3A
	db $89, $10, $3a  ; 9 across from (0, 1): object $3A
	db $c2, $09, $3f  ; 2 down from (9, 0): object $3F
	db $c6, $29, $38  ; 6 down from (9, 2): object $38
	db $87, $20, $eb  ; 7 across from (0, 2): object $EB
	db $85, $30, $eb  ; 5 across from (0, 3): object $EB
	db $37, $eb  ; (7, 3): object $EB
	db $82, $45, $ee  ; 2 across from (5, 4): object $EE
	db $82, $57, $ee  ; 2 across from (7, 5): object $EE
	db $36, $c8  ; (6, 3): object $C8
	db $47, $c8  ; (7, 4): object $C8
	db $55, $c8  ; (5, 5): object $C8
	db $66, $c8  ; (6, 6): object $C8
	db $56, $ec  ; (6, 5): object $EC
	db $40, $b7  ; (0, 4): object $B7
	db $50, $ce  ; (0, 5): object $CE
	db $70, $b7  ; (0, 7): object $B7
	db $41, $fb  ; (1, 4): object $FB
	db $60, $eb  ; (0, 6): object $EB
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $50 (row 5, column 0 of the 16 x 16 map): 31 objects on floor object $04; a warp (type 1) to map $0A room $AB at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom50::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $37  ; 8 down from (0, 0): object $37
	db $c5, $01, $87  ; 5 down from (1, 0): object $87
	db $c3, $05, $0a  ; 3 down from (5, 0): object $0A
	db $c2, $06, $86  ; 2 down from (6, 0): object $86
	db $07, $88  ; (7, 0): object $88
	db $08, $92  ; (8, 0): object $92
	db $09, $89  ; (9, 0): object $89
	db $17, $87  ; (7, 1): object $87
	db $18, $e4  ; (8, 1): object $E4
	db $c6, $19, $86  ; 6 down from (9, 1): object $86
	db $c3, $23, $5c  ; 3 down from (3, 2): object $5C
	db $26, $8d  ; (6, 2): object $8D
	db $27, $8c  ; (7, 2): object $8C
	db $83, $36, $0a  ; 3 across from (6, 3): object $0A
	db $51, $8a  ; (1, 5): object $8A
	db $52, $85  ; (2, 5): object $85
	db $53, $8e  ; (3, 5): object $8E
	db $82, $61, $90  ; 2 across from (1, 6): object $90
	db $63, $87  ; (3, 6): object $87
	db $82, $71, $90  ; 2 across from (1, 7): object $90
	db $73, $8a  ; (3, 7): object $8A
	db $85, $74, $85  ; 5 across from (4, 7): object $85
	db $79, $8b  ; (9, 7): object $8B
	db $61, $f5  ; (1, 6): object $F5
	db $12, $08  ; (2, 1): object $08
	db $42, $08  ; (2, 4): object $08
	db $64, $08  ; (4, 6): object $08
	db $34, $44  ; (4, 3): object $44
	db $45, $44  ; (5, 4): object $44
	db $58, $44  ; (8, 5): object $44
	db $28, $e3  ; (8, 2): object $E3
	db $e1, $0a, $ab, $50, $7c  ; warp type 1 to map $0A room $AB, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $51 (row 5, column 1 of the 16 x 16 map): 34 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom51::
	db $03, $04  ; animated tiles $03, floor $04
	db $00, $90  ; (0, 0): object $90
	db $01, $88  ; (1, 0): object $88
	db $02, $8c  ; (2, 0): object $8C
	db $c2, $06, $0a  ; 2 down from (6, 0): object $0A
	db $07, $86  ; (7, 0): object $86
	db $08, $90  ; (8, 0): object $90
	db $c8, $09, $90  ; 8 down from (9, 0): object $90
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $10, $88  ; (0, 1): object $88
	db $11, $8c  ; (1, 1): object $8C
	db $17, $8d  ; (7, 1): object $8D
	db $18, $89  ; (8, 1): object $89
	db $c5, $20, $87  ; 5 down from (0, 2): object $87
	db $21, $08  ; (1, 2): object $08
	db $82, $23, $5c  ; 2 across from (3, 2): object $5C
	db $27, $44  ; (7, 2): object $44
	db $c4, $28, $86  ; 4 down from (8, 2): object $86
	db $c2, $32, $5c  ; 2 down from (2, 3): object $5C
	db $33, $f5  ; (3, 3): object $F5
	db $c2, $35, $5c  ; 2 down from (5, 3): object $5C
	db $36, $44  ; (6, 3): object $44
	db $c3, $37, $0a  ; 3 down from (7, 3): object $0A
	db $82, $53, $5c  ; 2 across from (3, 5): object $5C
	db $c2, $56, $0a  ; 2 down from (6, 5): object $0A
	db $63, $44  ; (3, 6): object $44
	db $64, $08  ; (4, 6): object $08
	db $67, $8f  ; (7, 6): object $8F
	db $68, $8b  ; (8, 6): object $8B
	db $70, $8a  ; (0, 7): object $8A
	db $71, $85  ; (1, 7): object $85
	db $72, $8e  ; (2, 7): object $8E
	db $82, $75, $0a  ; 2 across from (5, 7): object $0A
	db $77, $86  ; (7, 7): object $86
	db $78, $90  ; (8, 7): object $90
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $52 (row 5, column 2 of the 16 x 16 map): 30 objects on floor object $04; a warp (type 1) to map $1F room $E1 at x 136, y 80. Format: see OverworldRoomPointers.
OverworldRoom52::
	db $03, $04  ; animated tiles $03, floor $04
	db $83, $07, $90  ; 3 across from (7, 0): object $90
	db $c8, $00, $90  ; 8 down from (0, 0): object $90
	db $c8, $01, $87  ; 8 down from (1, 0): object $87
	db $06, $86  ; (6, 0): object $86
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $c4, $19, $90  ; 4 down from (9, 1): object $90
	db $c2, $19, $f5  ; 2 down from (9, 1): object $F5
	db $c3, $28, $86  ; 3 down from (8, 2): object $86
	db $85, $75, $85  ; 5 across from (5, 7): object $85
	db $73, $8f  ; (3, 7): object $8F
	db $58, $8d  ; (8, 5): object $8D
	db $59, $84  ; (9, 5): object $84
	db $16, $8d  ; (6, 1): object $8D
	db $17, $84  ; (7, 1): object $84
	db $18, $89  ; (8, 1): object $89
	db $c2, $05, $0a  ; 2 down from (5, 0): object $0A
	db $26, $0a  ; (6, 2): object $0A
	db $c2, $52, $0a  ; 2 down from (2, 5): object $0A
	db $c2, $63, $0a  ; 2 down from (3, 6): object $0A
	db $24, $08  ; (4, 2): object $08
	db $27, $08  ; (7, 2): object $08
	db $56, $08  ; (6, 5): object $08
	db $69, $08  ; (9, 6): object $08
	db $72, $08  ; (2, 7): object $08
	db $75, $8f  ; (5, 7): object $8F
	db $83, $33, $44  ; 3 across from (3, 3): object $44
	db $83, $43, $44  ; 3 across from (3, 4): object $44
	db $83, $53, $44  ; 3 across from (3, 5): object $44
	db $27, $20  ; (7, 2): object $20
	db $e1, $1f, $e1, $88, $50  ; warp type 1 to map $1F room $E1, x 136 y 80
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $53 (row 5, column 3 of the 16 x 16 map): 30 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoom53::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $8a, $00, $90  ; 10 across from (0, 0): object $90
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $c4, $10, $90  ; 4 down from (0, 1): object $90
	db $c2, $1f, $f5  ; 2 down from (15, 1): object $F5
	db $c7, $19, $90  ; 7 down from (9, 1): object $90
	db $c4, $19, $f5  ; 4 down from (9, 1): object $F5
	db $c3, $21, $87  ; 3 down from (1, 2): object $87
	db $86, $12, $84  ; 6 across from (2, 1): object $84
	db $c6, $28, $86  ; 6 down from (8, 2): object $86
	db $82, $70, $85  ; 2 across from (0, 7): object $85
	db $72, $8e  ; (2, 7): object $8E
	db $51, $8c  ; (1, 5): object $8C
	db $50, $84  ; (0, 5): object $84
	db $11, $88  ; (1, 1): object $88
	db $18, $89  ; (8, 1): object $89
	db $82, $61, $04  ; 2 across from (1, 6): object $04
	db $67, $04  ; (7, 6): object $04
	db $76, $04  ; (6, 7): object $04
	db $60, $08  ; (0, 6): object $08
	db $77, $8f  ; (7, 7): object $8F
	db $78, $8b  ; (8, 7): object $8B
	db $23, $3d  ; (3, 2): object $3D
	db $82, $24, $2f  ; 2 across from (4, 2): object $2F
	db $26, $3c  ; (6, 2): object $3C
	db $33, $38  ; (3, 3): object $38
	db $82, $34, $0e  ; 2 across from (4, 3): object $0E
	db $36, $37  ; (6, 3): object $37
	db $43, $32  ; (3, 4): object $32
	db $82, $44, $2c  ; 2 across from (4, 4): object $2C
	db $46, $31  ; (6, 4): object $31
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $54 (row 5, column 4 of the 16 x 16 map): 22 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom54::
	db $03, $04  ; animated tiles $03, floor $04
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $60, $f5  ; (0, 6): object $F5
	db $85, $71, $f5  ; 5 across from (1, 7): object $F5
	db $21, $3d  ; (1, 2): object $3D
	db $83, $22, $2f  ; 3 across from (2, 2): object $2F
	db $25, $3c  ; (5, 2): object $3C
	db $c2, $31, $38  ; 2 down from (1, 3): object $38
	db $51, $32  ; (1, 5): object $32
	db $52, $2d  ; (2, 5): object $2D
	db $62, $32  ; (2, 6): object $32
	db $82, $63, $2c  ; 2 across from (3, 6): object $2C
	db $25, $3c  ; (5, 2): object $3C
	db $c3, $35, $37  ; 3 down from (5, 3): object $37
	db $65, $31  ; (5, 6): object $31
	db $83, $32, $0e  ; 3 across from (2, 3): object $0E
	db $83, $42, $0e  ; 3 across from (2, 4): object $0E
	db $82, $53, $0e  ; 2 across from (3, 5): object $0E
	db $02, $0b  ; (2, 0): object $0B
	db $86, $12, $0b  ; 6 across from (2, 1): object $0B
	db $c4, $f9, $f5  ; 4 down from (9, 15): object $F5
	db $84, $75, $04  ; 4 across from (5, 7): object $04
	db $c6, $27, $0b  ; 6 down from (7, 2): object $0B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $55 (row 5, column 5 of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom55::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $c4, $ff, $f5  ; 4 down from (15, 15): object $F5
	db $60, $f5  ; (0, 6): object $F5
	db $82, $14, $09  ; 2 across from (4, 1): object $09
	db $84, $41, $09  ; 4 across from (1, 4): object $09
	db $82, $52, $09  ; 2 across from (2, 5): object $09
	db $02, $44  ; (2, 0): object $44
	db $59, $09  ; (9, 5): object $09
	db $82, $67, $09  ; 2 across from (7, 6): object $09
	db $62, $e8  ; (2, 6): object $E8
	db $82, $45, $03  ; 2 across from (5, 4): object $03
	db $54, $03  ; (4, 5): object $03
	db $83, $63, $03  ; 3 across from (3, 6): object $03
	db $26, $f5  ; (6, 2): object $F5
	db $32, $f5  ; (2, 3): object $F5
	db $38, $f5  ; (8, 3): object $F5
	db $c2, $f9, $f5  ; 2 down from (9, 15): object $F5
	db $11, $f5  ; (1, 1): object $F5
	db $24, $20  ; (4, 2): object $20
	db $35, $20  ; (5, 3): object $20
	db $82, $77, $04  ; 2 across from (7, 7): object $04
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $56 (row 5, column 6 of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom56::
	db $03, $04  ; animated tiles $03, floor $04
	db $01, $09  ; (1, 0): object $09
	db $05, $cd  ; (5, 0): object $CD
	db $06, $ce  ; (6, 0): object $CE
	db $82, $02, $03  ; 2 across from (2, 0): object $03
	db $08, $09  ; (8, 0): object $09
	db $09, $cd  ; (9, 0): object $CD
	db $16, $fb  ; (6, 1): object $FB
	db $19, $09  ; (9, 1): object $09
	db $22, $fb  ; (2, 2): object $FB
	db $30, $fb  ; (0, 3): object $FB
	db $34, $fb  ; (4, 3): object $FB
	db $36, $e8  ; (6, 3): object $E8
	db $42, $09  ; (2, 4): object $09
	db $43, $e8  ; (3, 4): object $E8
	db $82, $50, $09  ; 2 across from (0, 5): object $09
	db $82, $52, $03  ; 2 across from (2, 5): object $03
	db $82, $56, $09  ; 2 across from (6, 5): object $09
	db $58, $03  ; (8, 5): object $03
	db $82, $60, $03  ; 2 across from (0, 6): object $03
	db $82, $63, $09  ; 2 across from (3, 6): object $09
	db $83, $46, $03  ; 3 across from (6, 4): object $03
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $59, $fb  ; (9, 5): object $FB
	db $c2, $ff, $f5  ; 2 down from (15, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $57 (row 5, column 7 of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom57::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $08, $f5  ; 4 down from (8, 0): object $F5
	db $85, $7f, $f5  ; 5 across from (15, 7): object $F5
	db $82, $73, $04  ; 2 across from (3, 7): object $04
	db $00, $ce  ; (0, 0): object $CE
	db $83, $04, $03  ; 3 across from (4, 0): object $03
	db $82, $10, $09  ; 2 across from (0, 1): object $09
	db $13, $03  ; (3, 1): object $03
	db $14, $09  ; (4, 1): object $09
	db $82, $16, $03  ; 2 across from (6, 1): object $03
	db $21, $03  ; (1, 2): object $03
	db $22, $fb  ; (2, 2): object $FB
	db $82, $25, $03  ; 2 across from (5, 2): object $03
	db $27, $09  ; (7, 2): object $09
	db $82, $42, $09  ; 2 across from (2, 4): object $09
	db $44, $03  ; (4, 4): object $03
	db $45, $fb  ; (5, 4): object $FB
	db $4f, $fb  ; (15, 4): object $FB
	db $51, $09  ; (1, 5): object $09
	db $82, $52, $03  ; 2 across from (2, 5): object $03
	db $54, $09  ; (4, 5): object $09
	db $57, $09  ; (7, 5): object $09
	db $62, $09  ; (2, 6): object $09
	db $63, $03  ; (3, 6): object $03
	db $82, $66, $03  ; 2 across from (6, 6): object $03
	db $82, $34, $03  ; 2 across from (4, 3): object $03
	db $61, $03  ; (1, 6): object $03
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $58 (row 5, column 8 of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom58::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $c8, $01, $0e  ; 8 down from (1, 0): object $0E
	db $c2, $62, $0e  ; 2 down from (2, 6): object $0E
	db $c3, $02, $9a  ; 3 down from (2, 0): object $9A
	db $c4, $43, $9a  ; 4 down from (3, 4): object $9A
	db $c7, $08, $9a  ; 7 down from (8, 0): object $9A
	db $09, $9d  ; (9, 0): object $9D
	db $32, $9d  ; (2, 3): object $9D
	db $78, $9d  ; (8, 7): object $9D
	db $33, $9c  ; (3, 3): object $9C
	db $42, $97  ; (2, 4): object $97
	db $52, $94  ; (2, 5): object $94
	db $19, $97  ; (9, 1): object $97
	db $29, $94  ; (9, 2): object $94
	db $c2, $f3, $f5  ; 2 down from (3, 15): object $F5
	db $76, $f5  ; (6, 7): object $F5
	db $35, $44  ; (5, 3): object $44
	db $64, $44  ; (4, 6): object $44
	db $c4, $39, $0d  ; 4 down from (9, 3): object $0D
	db $79, $99  ; (9, 7): object $99
	db $c2, $57, $20  ; 2 down from (7, 5): object $20
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $59 (row 5, column 9 of the 16 x 16 map): 21 objects on floor object $0D; a warp (type 1) to map $14 room $D5 at x 80, y 124; a warp (type 1) to map $14 room $D6 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom59::
	db $03, $0d  ; animated tiles $03, floor $0D
	db $8a, $00, $99  ; 10 across from (0, 0): object $99
	db $03, $9c  ; (3, 0): object $9C
	db $83, $04, $0c  ; 3 across from (4, 0): object $0C
	db $07, $9b  ; (7, 0): object $9B
	db $10, $f9  ; (0, 1): object $F9
	db $e1, $14, $d5, $50, $7c  ; warp type 1 to map $14 room $D5, x 80 y 124
	db $13, $9d  ; (3, 1): object $9D
	db $83, $14, $99  ; 3 across from (4, 1): object $99
	db $17, $9e  ; (7, 1): object $9E
	db $82, $18, $96  ; 2 across from (8, 1): object $96
	db $23, $b7  ; (3, 2): object $B7
	db $24, $f9  ; (4, 2): object $F9
	db $e1, $14, $d6, $50, $7c  ; warp type 1 to map $14 room $D6, x 80 y 124
	db $27, $b7  ; (7, 2): object $B7
	db $82, $28, $93  ; 2 across from (8, 2): object $93
	db $33, $a2  ; (3, 3): object $A2
	db $37, $a2  ; (7, 3): object $A2
	db $43, $b6  ; (3, 4): object $B6
	db $47, $b6  ; (7, 4): object $B6
	db $83, $70, $99  ; 3 across from (0, 7): object $99
	db $82, $78, $99  ; 2 across from (8, 7): object $99
	db $73, $9c  ; (3, 7): object $9C
	db $77, $9b  ; (7, 7): object $9B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $5A (row 5, column A of the 16 x 16 map): 18 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom5A::
	db $03, $04  ; animated tiles $03, floor $04
	db $00, $9e  ; (0, 0): object $9E
	db $c7, $01, $9a  ; 7 down from (1, 0): object $9A
	db $c7, $09, $9a  ; 7 down from (9, 0): object $9A
	db $10, $98  ; (0, 1): object $98
	db $20, $95  ; (0, 2): object $95
	db $c4, $30, $0d  ; 4 down from (0, 3): object $0D
	db $70, $99  ; (0, 7): object $99
	db $71, $9e  ; (1, 7): object $9E
	db $77, $9b  ; (7, 7): object $9B
	db $78, $99  ; (8, 7): object $99
	db $79, $9e  ; (9, 7): object $9E
	db $15, $e8  ; (5, 1): object $E8
	db $32, $e8  ; (2, 3): object $E8
	db $38, $e8  ; (8, 3): object $E8
	db $45, $e8  ; (5, 4): object $E8
	db $63, $e8  ; (3, 6): object $E8
	db $67, $e8  ; (7, 6): object $E8
	db $72, $f5  ; (2, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $5B (row 5, column B of the 16 x 16 map): 20 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom5B::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c2, $06, $38  ; 2 down from (6, 0): object $38
	db $c3, $34, $38  ; 3 down from (4, 3): object $38
	db $24, $3d  ; (4, 2): object $3D
	db $25, $2f  ; (5, 2): object $2F
	db $26, $34  ; (6, 2): object $34
	db $83, $34, $38  ; 3 across from (4, 3): object $38
	db $64, $32  ; (4, 6): object $32
	db $65, $2c  ; (5, 6): object $2C
	db $66, $2d  ; (6, 6): object $2D
	db $67, $38  ; (7, 6): object $38
	db $c8, $07, $0e  ; 8 down from (7, 0): object $0E
	db $c8, $08, $0e  ; 8 down from (8, 0): object $0E
	db $c3, $35, $0e  ; 3 down from (5, 3): object $0E
	db $c3, $36, $0e  ; 3 down from (6, 3): object $0E
	db $13, $44  ; (3, 1): object $44
	db $75, $44  ; (5, 7): object $44
	db $76, $38  ; (6, 7): object $38
	db $c4, $00, $f5  ; 4 down from (0, 0): object $F5
	db $74, $f5  ; (4, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $5C (row 5, column C of the 16 x 16 map): 28 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom5C::
	db $0a, $eb  ; animated tiles $0A, floor $EB
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $03, $3e  ; (3, 0): object $3E
	db $82, $04, $3a  ; 2 across from (4, 0): object $3A
	db $06, $3f  ; (6, 0): object $3F
	db $c3, $13, $37  ; 3 down from (3, 1): object $37
	db $c3, $16, $38  ; 3 down from (6, 1): object $38
	db $43, $33  ; (3, 4): object $33
	db $44, $48  ; (4, 4): object $48
	db $45, $e0  ; (5, 4): object $E0
	db $46, $34  ; (6, 4): object $34
	db $c3, $14, $04  ; 3 down from (4, 1): object $04
	db $c3, $15, $04  ; 3 down from (5, 1): object $04
	db $82, $01, $e9  ; 2 across from (1, 0): object $E9
	db $82, $07, $e9  ; 2 across from (7, 0): object $E9
	db $09, $39  ; (9, 0): object $39
	db $c5, $11, $ed  ; 5 down from (1, 1): object $ED
	db $c5, $12, $ed  ; 5 down from (2, 1): object $ED
	db $c3, $17, $ed  ; 3 down from (7, 1): object $ED
	db $56, $c8  ; (6, 5): object $C8
	db $47, $c8  ; (7, 4): object $C8
	db $24, $a0  ; (4, 2): object $A0
	db $68, $fb  ; (8, 6): object $FB
	db $71, $fb  ; (1, 7): object $FB
	db $73, $fb  ; (3, 7): object $FB
	db $75, $fb  ; (5, 7): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $78, $4f  ; (8, 7): object $4F
	db $79, $21  ; (9, 7): object $21
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $5D (row 5, column D of the 16 x 16 map): 32 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom5D::
	db $09, $eb  ; animated tiles $09, floor $EB
	db $00, $3a  ; (0, 0): object $3A
	db $01, $3b  ; (1, 0): object $3B
	db $02, $2b  ; (2, 0): object $2B
	db $84, $03, $2c  ; 4 across from (3, 0): object $2C
	db $07, $2d  ; (7, 0): object $2D
	db $08, $cd  ; (8, 0): object $CD
	db $09, $ce  ; (9, 0): object $CE
	db $12, $37  ; (2, 1): object $37
	db $84, $13, $04  ; 4 across from (3, 1): object $04
	db $16, $a0  ; (6, 1): object $A0
	db $c2, $17, $38  ; 2 down from (7, 1): object $38
	db $22, $33  ; (2, 2): object $33
	db $23, $3c  ; (3, 2): object $3C
	db $83, $24, $04  ; 3 across from (4, 2): object $04
	db $33, $33  ; (3, 3): object $33
	db $34, $48  ; (4, 3): object $48
	db $35, $e0  ; (5, 3): object $E0
	db $36, $49  ; (6, 3): object $49
	db $37, $34  ; (7, 3): object $34
	db $c2, $11, $ed  ; 2 down from (1, 1): object $ED
	db $32, $ed  ; (2, 3): object $ED
	db $43, $ed  ; (3, 4): object $ED
	db $46, $c8  ; (6, 4): object $C8
	db $60, $fb  ; (0, 6): object $FB
	db $71, $fb  ; (1, 7): object $FB
	db $73, $fb  ; (3, 7): object $FB
	db $75, $fb  ; (5, 7): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $70, $4f  ; (0, 7): object $4F
	db $71, $21  ; (1, 7): object $21
	db $79, $b6  ; (9, 7): object $B6
	db $14, $6f  ; (4, 1): object $6F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $5E (row 5, column E of the 16 x 16 map): 35 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom5E::
	db $09, $eb  ; animated tiles $09, floor $EB
	db $c3, $40, $ec  ; 3 down from (0, 4): object $EC
	db $41, $2b  ; (1, 4): object $2B
	db $42, $2c  ; (2, 4): object $2C
	db $43, $2c  ; (3, 4): object $2C
	db $44, $2d  ; (4, 4): object $2D
	db $c2, $51, $37  ; 2 down from (1, 5): object $37
	db $c2, $54, $38  ; 2 down from (4, 5): object $38
	db $71, $33  ; (1, 7): object $33
	db $82, $72, $2f  ; 2 across from (2, 7): object $2F
	db $74, $34  ; (4, 7): object $34
	db $82, $52, $04  ; 2 across from (2, 5): object $04
	db $82, $62, $04  ; 2 across from (2, 6): object $04
	db $28, $c8  ; (8, 2): object $C8
	db $37, $c8  ; (7, 3): object $C8
	db $58, $c8  ; (8, 5): object $C8
	db $66, $c8  ; (6, 6): object $C8
	db $27, $ec  ; (7, 2): object $EC
	db $31, $ec  ; (1, 3): object $EC
	db $36, $ec  ; (6, 3): object $EC
	db $57, $ec  ; (7, 5): object $EC
	db $65, $ec  ; (5, 6): object $EC
	db $00, $cd  ; (0, 0): object $CD
	db $02, $cd  ; (2, 0): object $CD
	db $05, $cd  ; (5, 0): object $CD
	db $07, $cd  ; (7, 0): object $CD
	db $09, $cd  ; (9, 0): object $CD
	db $01, $ce  ; (1, 0): object $CE
	db $03, $ce  ; (3, 0): object $CE
	db $06, $ce  ; (6, 0): object $CE
	db $08, $ce  ; (8, 0): object $CE
	db $04, $c8  ; (4, 0): object $C8
	db $70, $b7  ; (0, 7): object $B7
	db $75, $fb  ; (5, 7): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $79, $b6  ; (9, 7): object $B6
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $5F (row 5, column F of the 16 x 16 map): 27 objects on floor object $ED. Format: see OverworldRoomPointers.
OverworldRoom5F::
	db $09, $ed  ; animated tiles $09, floor $ED
	db $00, $ce  ; (0, 0): object $CE
	db $c6, $10, $eb  ; 6 down from (0, 1): object $EB
	db $82, $31, $eb  ; 2 across from (1, 3): object $EB
	db $82, $06, $eb  ; 2 across from (6, 0): object $EB
	db $82, $46, $eb  ; 2 across from (6, 4): object $EB
	db $83, $03, $ee  ; 3 across from (3, 0): object $EE
	db $82, $37, $ee  ; 2 across from (7, 3): object $EE
	db $43, $ee  ; (3, 4): object $EE
	db $13, $fb  ; (3, 1): object $FB
	db $15, $fb  ; (5, 1): object $FB
	db $24, $21  ; (4, 2): object $21
	db $25, $4f  ; (5, 2): object $4F
	db $34, $cd  ; (4, 3): object $CD
	db $35, $ce  ; (5, 3): object $CE
	db $44, $fb  ; (4, 4): object $FB
	db $53, $fb  ; (3, 5): object $FB
	db $55, $fb  ; (5, 5): object $FB
	db $54, $4f  ; (4, 5): object $4F
	db $55, $21  ; (5, 5): object $21
	db $64, $21  ; (4, 6): object $21
	db $65, $4f  ; (5, 6): object $4F
	db $74, $cd  ; (4, 7): object $CD
	db $75, $ce  ; (5, 7): object $CE
	db $c2, $17, $c8  ; 2 down from (7, 1): object $C8
	db $c2, $57, $c8  ; 2 down from (7, 5): object $C8
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $70, $b7  ; (0, 7): object $B7
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $60 (row 6, column 0 of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom60::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $37  ; 8 down from (0, 0): object $37
	db $c8, $01, $90  ; 8 down from (1, 0): object $90
	db $c8, $02, $90  ; 8 down from (2, 0): object $90
	db $c8, $03, $90  ; 8 down from (3, 0): object $90
	db $c5, $04, $87  ; 5 down from (4, 0): object $87
	db $04, $88  ; (4, 0): object $88
	db $85, $05, $84  ; 5 across from (5, 0): object $84
	db $38, $8f  ; (8, 3): object $8F
	db $39, $85  ; (9, 3): object $85
	db $c2, $48, $86  ; 2 down from (8, 4): object $86
	db $c2, $49, $90  ; 2 down from (9, 4): object $90
	db $49, $f5  ; (9, 4): object $F5
	db $c2, $51, $f5  ; 2 down from (1, 5): object $F5
	db $53, $88  ; (3, 5): object $88
	db $54, $8c  ; (4, 5): object $8C
	db $c2, $63, $87  ; 2 down from (3, 6): object $87
	db $68, $8d  ; (8, 6): object $8D
	db $69, $84  ; (9, 6): object $84
	db $15, $08  ; (5, 1): object $08
	db $36, $08  ; (6, 3): object $08
	db $65, $08  ; (5, 6): object $08
	db $25, $44  ; (5, 2): object $44
	db $29, $44  ; (9, 2): object $44
	db $56, $44  ; (6, 5): object $44
	db $c2, $01, $f5  ; 2 down from (1, 0): object $F5
	db $c2, $12, $f5  ; 2 down from (2, 1): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $61 (row 6, column 1 of the 16 x 16 map): 29 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom61::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $00, $84  ; 2 across from (0, 0): object $84
	db $02, $8c  ; (2, 0): object $8C
	db $c4, $07, $86  ; 4 down from (7, 0): object $86
	db $c4, $08, $90  ; 4 down from (8, 0): object $90
	db $c4, $09, $90  ; 4 down from (9, 0): object $90
	db $c2, $11, $0a  ; 2 down from (1, 1): object $0A
	db $13, $08  ; (3, 1): object $08
	db $22, $0a  ; (2, 2): object $0A
	db $47, $8d  ; (7, 4): object $8D
	db $82, $48, $84  ; 2 across from (8, 4): object $84
	db $83, $30, $85  ; 3 across from (0, 3): object $85
	db $33, $8e  ; (3, 3): object $8E
	db $36, $5c  ; (6, 3): object $5C
	db $83, $40, $90  ; 3 across from (0, 4): object $90
	db $c2, $43, $87  ; 2 down from (3, 4): object $87
	db $83, $50, $90  ; 3 across from (0, 5): object $90
	db $82, $4f, $f5  ; 2 across from (15, 4): object $F5
	db $83, $60, $84  ; 3 across from (0, 6): object $84
	db $63, $8c  ; (3, 6): object $8C
	db $65, $08  ; (5, 6): object $08
	db $67, $8f  ; (7, 6): object $8F
	db $82, $68, $85  ; 2 across from (8, 6): object $85
	db $77, $86  ; (7, 7): object $86
	db $82, $78, $90  ; 2 across from (8, 7): object $90
	db $79, $f5  ; (9, 7): object $F5
	db $c2, $08, $f5  ; 2 down from (8, 0): object $F5
	db $19, $f5  ; (9, 1): object $F5
	db $44, $44  ; (4, 4): object $44
	db $56, $44  ; (6, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $62 (row 6, column 2 of the 16 x 16 map): 35 objects on floor object $04; a warp (type 1) to map $0A room $BD at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom62::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $00, $90  ; 4 down from (0, 0): object $90
	db $c2, $ff, $f5  ; 2 down from (15, 15): object $F5
	db $c4, $01, $87  ; 4 down from (1, 0): object $87
	db $84, $06, $90  ; 4 across from (6, 0): object $90
	db $84, $16, $90  ; 4 across from (6, 1): object $90
	db $84, $26, $90  ; 4 across from (6, 2): object $90
	db $84, $36, $84  ; 4 across from (6, 3): object $84
	db $c3, $05, $86  ; 3 down from (5, 0): object $86
	db $35, $8d  ; (5, 3): object $8D
	db $45, $d4  ; (5, 4): object $D4
	db $86, $74, $85  ; 6 across from (4, 7): object $85
	db $73, $8f  ; (3, 7): object $8F
	db $16, $88  ; (6, 1): object $88
	db $17, $92  ; (7, 1): object $92
	db $18, $89  ; (8, 1): object $89
	db $26, $87  ; (6, 2): object $87
	db $27, $e4  ; (7, 2): object $E4
	db $28, $86  ; (8, 2): object $86
	db $36, $8c  ; (6, 3): object $8C
	db $38, $8d  ; (8, 3): object $8D
	db $37, $e3  ; (7, 3): object $E3
	db $e1, $0a, $bd, $50, $7c  ; warp type 1 to map $0A room $BD, x 80 y 124
	db $39, $89  ; (9, 3): object $89
	db $c3, $49, $86  ; 3 down from (9, 4): object $86
	db $40, $84  ; (0, 4): object $84
	db $41, $8c  ; (1, 4): object $8C
	db $60, $85  ; (0, 6): object $85
	db $61, $8e  ; (1, 6): object $8E
	db $70, $90  ; (0, 7): object $90
	db $71, $87  ; (1, 7): object $87
	db $7f, $f5  ; (15, 7): object $F5
	db $72, $08  ; (2, 7): object $08
	db $82, $65, $08  ; 2 across from (5, 6): object $08
	db $58, $08  ; (8, 5): object $08
	db $79, $8b  ; (9, 7): object $8B
	db $52, $44  ; (2, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $64 (row 6, column 4 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom64::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $82, $00, $f5  ; 2 across from (0, 0): object $F5
	db $82, $1f, $f5  ; 2 across from (15, 1): object $F5
	db $c3, $3f, $f5  ; 3 down from (15, 3): object $F5
	db $82, $20, $f5  ; 2 across from (0, 2): object $F5
	db $33, $f5  ; (3, 3): object $F5
	db $44, $f5  ; (4, 4): object $F5
	db $55, $f5  ; (5, 5): object $F5
	db $c3, $18, $0b  ; 3 down from (8, 1): object $0B
	db $39, $0b  ; (9, 3): object $0B
	db $27, $08  ; (7, 2): object $08
	db $75, $3d  ; (5, 7): object $3D
	db $76, $48  ; (6, 7): object $48
	db $77, $e0  ; (7, 7): object $E0
	db $78, $49  ; (8, 7): object $49
	db $79, $2f  ; (9, 7): object $2F
	db $84, $05, $04  ; 4 across from (5, 0): object $04
	db $67, $20  ; (7, 6): object $20
	db $c2, $07, $0b  ; 2 down from (7, 0): object $0B
	db $82, $41, $44  ; 2 across from (1, 4): object $44
	db $83, $51, $44  ; 3 across from (1, 5): object $44
	db $83, $61, $44  ; 3 across from (1, 6): object $44
	db $52, $c4  ; (2, 5): object $C4
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $65 (row 6, column 5 of the 16 x 16 map): 23 objects on floor object $04; a warp (type 1) to map $0E room $A2 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom65::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $13, $fb  ; (3, 1): object $FB
	db $14, $fb  ; (4, 1): object $FB
	db $14, $c8  ; (4, 1): object $C8
	db $24, $e1  ; (4, 2): object $E1
	db $32, $fb  ; (2, 3): object $FB
	db $35, $fb  ; (5, 3): object $FB
	db $20, $08  ; (0, 2): object $08
	db $18, $08  ; (8, 1): object $08
	db $86, $70, $2f  ; 6 across from (0, 7): object $2F
	db $76, $3c  ; (6, 7): object $3C
	db $77, $0a  ; (7, 7): object $0A
	db $30, $0b  ; (0, 3): object $0B
	db $c3, $31, $0b  ; 3 down from (1, 3): object $0B
	db $83, $52, $0b  ; 3 across from (2, 5): object $0B
	db $c2, $34, $0b  ; 2 down from (4, 3): object $0B
	db $c2, $19, $f5  ; 2 down from (9, 1): object $F5
	db $28, $f5  ; (8, 2): object $F5
	db $47, $20  ; (7, 4): object $20
	db $c2, $56, $e8  ; 2 down from (6, 5): object $E8
	db $79, $f5  ; (9, 7): object $F5
	db $48, $d4  ; (8, 4): object $D4
	db $e1, $0e, $a2, $50, $7c  ; warp type 1 to map $0E room $A2, x 80 y 124
	db $82, $07, $04  ; 2 across from (7, 0): object $04
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $66 (row 6, column 6 of the 16 x 16 map): 29 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoom66::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $8a, $00, $04  ; 10 across from (0, 0): object $04
	db $c7, $10, $04  ; 7 down from (0, 1): object $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $c2, $1f, $f5  ; 2 down from (15, 1): object $F5
	db $89, $11, $51  ; 9 across from (1, 1): object $51
	db $c6, $21, $51  ; 6 down from (1, 2): object $51
	db $85, $22, $09  ; 5 across from (2, 2): object $09
	db $33, $c4  ; (3, 3): object $C4
	db $34, $03  ; (4, 3): object $03
	db $35, $c4  ; (5, 3): object $C4
	db $37, $c4  ; (7, 3): object $C4
	db $38, $03  ; (8, 3): object $03
	db $45, $09  ; (5, 4): object $09
	db $46, $03  ; (6, 4): object $03
	db $c2, $51, $04  ; 2 down from (1, 5): object $04
	db $53, $c4  ; (3, 5): object $C4
	db $54, $03  ; (4, 5): object $03
	db $55, $c4  ; (5, 5): object $C4
	db $57, $c4  ; (7, 5): object $C4
	db $82, $58, $09  ; 2 across from (8, 5): object $09
	db $65, $03  ; (5, 6): object $03
	db $82, $66, $09  ; 2 across from (6, 6): object $09
	db $7f, $f5  ; (15, 7): object $F5
	db $82, $72, $09  ; 2 across from (2, 7): object $09
	db $82, $77, $03  ; 2 across from (7, 7): object $03
	db $79, $f5  ; (9, 7): object $F5
	db $29, $fb  ; (9, 2): object $FB
	db $49, $fb  ; (9, 4): object $FB
	db $69, $fb  ; (9, 6): object $FB
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $67 (row 6, column 7 of the 16 x 16 map): 30 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoom67::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $8a, $00, $04  ; 10 across from (0, 0): object $04
	db $85, $ff, $f5  ; 5 across from (15, 15): object $F5
	db $03, $08  ; (3, 0): object $08
	db $04, $04  ; (4, 0): object $04
	db $82, $18, $04  ; 2 across from (8, 1): object $04
	db $88, $10, $51  ; 8 across from (0, 1): object $51
	db $82, $13, $04  ; 2 across from (3, 1): object $04
	db $c6, $29, $51  ; 6 down from (9, 2): object $51
	db $82, $31, $03  ; 2 across from (1, 3): object $03
	db $33, $c4  ; (3, 3): object $C4
	db $35, $c4  ; (5, 3): object $C4
	db $37, $c4  ; (7, 3): object $C4
	db $82, $42, $03  ; 2 across from (2, 4): object $03
	db $44, $09  ; (4, 4): object $09
	db $82, $47, $03  ; 2 across from (7, 4): object $03
	db $83, $50, $03  ; 3 across from (0, 5): object $03
	db $51, $0a  ; (1, 5): object $0A
	db $53, $c4  ; (3, 5): object $C4
	db $55, $c4  ; (5, 5): object $C4
	db $57, $c4  ; (7, 5): object $C4
	db $82, $62, $09  ; 2 across from (2, 6): object $09
	db $7f, $f5  ; (15, 7): object $F5
	db $82, $75, $03  ; 2 across from (5, 7): object $03
	db $08, $f5  ; (8, 0): object $F5
	db $20, $b7  ; (0, 2): object $B7
	db $30, $ce  ; (0, 3): object $CE
	db $40, $b7  ; (0, 4): object $B7
	db $50, $ce  ; (0, 5): object $CE
	db $60, $b7  ; (0, 6): object $B7
	db $70, $ce  ; (0, 7): object $CE
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $68 (row 6, column 8 of the 16 x 16 map): 15 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom68::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $c8, $01, $0e  ; 8 down from (1, 0): object $0E
	db $c6, $02, $0e  ; 6 down from (2, 0): object $0E
	db $c6, $03, $9a  ; 6 down from (3, 0): object $9A
	db $62, $9b  ; (2, 6): object $9B
	db $63, $9e  ; (3, 6): object $9E
	db $72, $9a  ; (2, 7): object $9A
	db $73, $9b  ; (3, 7): object $9B
	db $86, $74, $99  ; 6 across from (4, 7): object $99
	db $c2, $f6, $f5  ; 2 down from (6, 15): object $F5
	db $08, $b7  ; (8, 0): object $B7
	db $18, $a2  ; (8, 1): object $A2
	db $28, $b6  ; (8, 2): object $B6
	db $09, $96  ; (9, 0): object $96
	db $19, $93  ; (9, 1): object $93
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $69 (row 6, column 9 of the 16 x 16 map): 27 objects on floor object $04; a warp (type 1) to map $14 room $D3 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom69::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $70, $99  ; 10 across from (0, 7): object $99
	db $83, $74, $04  ; 3 across from (4, 7): object $04
	db $8a, $00, $96  ; 10 across from (0, 0): object $96
	db $8a, $10, $93  ; 10 across from (0, 1): object $93
	db $23, $b7  ; (3, 2): object $B7
	db $27, $b7  ; (7, 2): object $B7
	db $33, $a2  ; (3, 3): object $A2
	db $37, $a2  ; (7, 3): object $A2
	db $43, $b6  ; (3, 4): object $B6
	db $47, $b6  ; (7, 4): object $B6
	db $03, $9a  ; (3, 0): object $9A
	db $07, $9a  ; (7, 0): object $9A
	db $13, $9d  ; (3, 1): object $9D
	db $17, $9e  ; (7, 1): object $9E
	db $83, $14, $99  ; 3 across from (4, 1): object $99
	db $83, $04, $0d  ; 3 across from (4, 0): object $0D
	db $24, $f9  ; (4, 2): object $F9
	db $c3, $22, $5c  ; 3 down from (2, 2): object $5C
	db $c3, $28, $5c  ; 3 down from (8, 2): object $5C
	db $c2, $32, $5c  ; 2 down from (2, 3): object $5C
	db $c3, $44, $5c  ; 3 down from (4, 4): object $5C
	db $c4, $45, $0c  ; 4 down from (5, 4): object $0C
	db $c3, $46, $5c  ; 3 down from (6, 4): object $5C
	db $72, $9b  ; (2, 7): object $9B
	db $73, $9c  ; (3, 7): object $9C
	db $77, $9b  ; (7, 7): object $9B
	db $78, $9c  ; (8, 7): object $9C
	db $e1, $14, $d3, $50, $7c  ; warp type 1 to map $14 room $D3, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $6A (row 6, column A of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom6A::
	db $03, $04  ; animated tiles $03, floor $04
	db $00, $96  ; (0, 0): object $96
	db $10, $93  ; (0, 1): object $93
	db $01, $b7  ; (1, 0): object $B7
	db $11, $a2  ; (1, 1): object $A2
	db $21, $b6  ; (1, 2): object $B6
	db $c2, $f2, $f5  ; 2 down from (2, 15): object $F5
	db $c6, $70, $9a  ; 6 down from (0, 7): object $9A
	db $67, $9d  ; (7, 6): object $9D
	db $68, $9c  ; (8, 6): object $9C
	db $87, $70, $99  ; 7 across from (0, 7): object $99
	db $77, $9c  ; (7, 7): object $9C
	db $78, $9a  ; (8, 7): object $9A
	db $82, $48, $2f  ; 2 across from (8, 4): object $2F
	db $82, $58, $0e  ; 2 across from (8, 5): object $0E
	db $c2, $69, $0e  ; 2 down from (9, 6): object $0E
	db $c6, $07, $9a  ; 6 down from (7, 0): object $9A
	db $08, $96  ; (8, 0): object $96
	db $09, $98  ; (9, 0): object $98
	db $18, $93  ; (8, 1): object $93
	db $19, $95  ; (9, 1): object $95
	db $48, $e0  ; (8, 4): object $E0
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $6B (row 6, column B of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom6B::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c2, $06, $38  ; 2 down from (6, 0): object $38
	db $c5, $37, $38  ; 5 down from (7, 3): object $38
	db $36, $32  ; (6, 3): object $32
	db $27, $2d  ; (7, 2): object $2D
	db $40, $2f  ; (0, 4): object $2F
	db $41, $3c  ; (1, 4): object $3C
	db $c3, $51, $37  ; 3 down from (1, 5): object $37
	db $c3, $50, $0e  ; 3 down from (0, 5): object $0E
	db $c2, $07, $0e  ; 2 down from (7, 0): object $0E
	db $c8, $08, $0e  ; 8 down from (8, 0): object $0E
	db $00, $f5  ; (0, 0): object $F5
	db $f4, $f5  ; (4, 15): object $F5
	db $c4, $03, $0d  ; 4 down from (3, 0): object $0D
	db $c4, $34, $0d  ; 4 down from (4, 3): object $0D
	db $c2, $36, $5c  ; 2 down from (6, 3): object $5C
	db $c2, $52, $5c  ; 2 down from (2, 5): object $5C
	db $63, $5c  ; (3, 6): object $5C
	db $c2, $55, $f5  ; 2 down from (5, 5): object $F5
	db $72, $f5  ; (2, 7): object $F5
	db $26, $32  ; (6, 2): object $32
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $6C (row 6, column C of the 16 x 16 map): 29 objects on floor object $EE; a warp (type 1) to map $05 room $B0 at x 120, y 16. Format: see OverworldRoomPointers.
OverworldRoom6C::
	db $09, $ee  ; animated tiles $09, floor $EE
	db $01, $cd  ; (1, 0): object $CD
	db $02, $ce  ; (2, 0): object $CE
	db $03, $cd  ; (3, 0): object $CD
	db $04, $ce  ; (4, 0): object $CE
	db $05, $cd  ; (5, 0): object $CD
	db $06, $ce  ; (6, 0): object $CE
	db $07, $cd  ; (7, 0): object $CD
	db $08, $ce  ; (8, 0): object $CE
	db $09, $cd  ; (9, 0): object $CD
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $c7, $11, $ed  ; 7 down from (1, 1): object $ED
	db $82, $26, $ec  ; 2 across from (6, 2): object $EC
	db $82, $36, $ec  ; 2 across from (6, 3): object $EC
	db $82, $46, $ed  ; 2 across from (6, 4): object $ED
	db $82, $56, $ed  ; 2 across from (6, 5): object $ED
	db $88, $62, $eb  ; 8 across from (2, 6): object $EB
	db $88, $72, $eb  ; 8 across from (2, 7): object $EB
	db $22, $2b  ; (2, 2): object $2B
	db $82, $23, $2c  ; 2 across from (3, 2): object $2C
	db $25, $2d  ; (5, 2): object $2D
	db $c2, $32, $37  ; 2 down from (2, 3): object $37
	db $52, $33  ; (2, 5): object $33
	db $82, $53, $2f  ; 2 across from (3, 5): object $2F
	db $55, $34  ; (5, 5): object $34
	db $c2, $35, $38  ; 2 down from (5, 3): object $38
	db $82, $43, $04  ; 2 across from (3, 4): object $04
	db $33, $a0  ; (3, 3): object $A0
	db $34, $c6  ; (4, 3): object $C6
	db $e1, $05, $b0, $78, $10  ; warp type 1 to map $05 room $B0, x 120 y 16
	db $48, $fb  ; (8, 4): object $FB
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $6D (row 6, column D of the 16 x 16 map): 27 objects on floor object $EE. Format: see OverworldRoomPointers.
OverworldRoom6D::
	db $09, $ee  ; animated tiles $09, floor $EE
	db $25, $fb  ; (5, 2): object $FB
	db $27, $fb  ; (7, 2): object $FB
	db $34, $fb  ; (4, 3): object $FB
	db $35, $4f  ; (5, 3): object $4F
	db $40, $fb  ; (0, 4): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $79, $b6  ; (9, 7): object $B6
	db $00, $ce  ; (0, 0): object $CE
	db $01, $cd  ; (1, 0): object $CD
	db $02, $ce  ; (2, 0): object $CE
	db $03, $cd  ; (3, 0): object $CD
	db $04, $ce  ; (4, 0): object $CE
	db $05, $cd  ; (5, 0): object $CD
	db $06, $ce  ; (6, 0): object $CE
	db $07, $cd  ; (7, 0): object $CD
	db $08, $ce  ; (8, 0): object $CE
	db $09, $cd  ; (9, 0): object $CD
	db $82, $53, $c8  ; 2 across from (3, 5): object $C8
	db $c2, $65, $c8  ; 2 down from (5, 6): object $C8
	db $c2, $42, $ed  ; 2 down from (2, 4): object $ED
	db $c2, $64, $ed  ; 2 down from (4, 6): object $ED
	db $c4, $46, $ed  ; 4 down from (6, 4): object $ED
	db $55, $eb  ; (5, 5): object $EB
	db $84, $60, $eb  ; 4 across from (0, 6): object $EB
	db $84, $70, $eb  ; 4 across from (0, 7): object $EB
	db $39, $c8  ; (9, 3): object $C8
	db $29, $ec  ; (9, 2): object $EC
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $6E (row 6, column E of the 16 x 16 map): 27 objects on floor object $EE. Format: see OverworldRoomPointers.
OverworldRoom6E::
	db $09, $ee  ; animated tiles $09, floor $EE
	db $00, $ce  ; (0, 0): object $CE
	db $01, $fb  ; (1, 0): object $FB
	db $03, $fb  ; (3, 0): object $FB
	db $05, $cd  ; (5, 0): object $CD
	db $06, $ce  ; (6, 0): object $CE
	db $07, $cd  ; (7, 0): object $CD
	db $08, $ce  ; (8, 0): object $CE
	db $09, $cd  ; (9, 0): object $CD
	db $83, $30, $c8  ; 3 across from (0, 3): object $C8
	db $c5, $15, $ed  ; 5 down from (5, 1): object $ED
	db $c3, $46, $ed  ; 3 down from (6, 4): object $ED
	db $33, $ed  ; (3, 3): object $ED
	db $34, $ec  ; (4, 3): object $EC
	db $82, $26, $c8  ; 2 across from (6, 2): object $C8
	db $28, $ed  ; (8, 2): object $ED
	db $39, $c8  ; (9, 3): object $C8
	db $84, $41, $eb  ; 4 across from (1, 4): object $EB
	db $c2, $51, $ec  ; 2 down from (1, 5): object $EC
	db $83, $52, $c8  ; 3 across from (2, 5): object $C8
	db $82, $67, $c8  ; 2 across from (7, 6): object $C8
	db $69, $ec  ; (9, 6): object $EC
	db $70, $b7  ; (0, 7): object $B7
	db $71, $fb  ; (1, 7): object $FB
	db $73, $fb  ; (3, 7): object $FB
	db $75, $fb  ; (5, 7): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $79, $b6  ; (9, 7): object $B6
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $6F (row 6, column F of the 16 x 16 map): 22 objects on floor object $EE. Format: see OverworldRoomPointers.
OverworldRoom6F::
	db $09, $ee  ; animated tiles $09, floor $EE
	db $00, $ce  ; (0, 0): object $CE
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $83, $01, $ed  ; 3 across from (1, 0): object $ED
	db $82, $04, $c8  ; 2 across from (4, 0): object $C8
	db $c4, $06, $ed  ; 4 down from (6, 0): object $ED
	db $c4, $17, $c8  ; 4 down from (7, 1): object $C8
	db $c5, $08, $ed  ; 5 down from (8, 0): object $ED
	db $c2, $15, $c8  ; 2 down from (5, 1): object $C8
	db $83, $30, $c8  ; 3 across from (0, 3): object $C8
	db $13, $ec  ; (3, 1): object $EC
	db $24, $ec  ; (4, 2): object $EC
	db $33, $ec  ; (3, 3): object $EC
	db $84, $53, $c8  ; 4 across from (3, 5): object $C8
	db $c3, $44, $ec  ; 3 down from (4, 4): object $EC
	db $82, $41, $ed  ; 2 across from (1, 4): object $ED
	db $82, $51, $ed  ; 2 across from (1, 5): object $ED
	db $57, $ed  ; (7, 5): object $ED
	db $70, $b7  ; (0, 7): object $B7
	db $71, $fb  ; (1, 7): object $FB
	db $73, $fb  ; (3, 7): object $FB
	db $75, $fb  ; (5, 7): object $FB
	db $77, $fb  ; (7, 7): object $FB
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $70 (row 7, column 0 of the 16 x 16 map): 27 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom70::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $00, $37  ; 4 down from (0, 0): object $37
	db $40, $31  ; (0, 4): object $31
	db $c3, $50, $90  ; 3 down from (0, 5): object $90
	db $c8, $01, $90  ; 8 down from (1, 0): object $90
	db $c8, $02, $90  ; 8 down from (2, 0): object $90
	db $c2, $33, $90  ; 2 down from (3, 3): object $90
	db $c2, $03, $87  ; 2 down from (3, 0): object $87
	db $23, $8a  ; (3, 2): object $8A
	db $24, $8e  ; (4, 2): object $8E
	db $c2, $34, $87  ; 2 down from (4, 3): object $87
	db $52, $88  ; (2, 5): object $88
	db $53, $84  ; (3, 5): object $84
	db $54, $8c  ; (4, 5): object $8C
	db $62, $87  ; (2, 6): object $87
	db $c3, $f1, $f5  ; 3 down from (1, 15): object $F5
	db $c2, $50, $f5  ; 2 down from (0, 5): object $F5
	db $82, $70, $f5  ; 2 across from (0, 7): object $F5
	db $16, $08  ; (6, 1): object $08
	db $27, $08  ; (7, 2): object $08
	db $63, $08  ; (3, 6): object $08
	db $38, $f5  ; (8, 3): object $F5
	db $c2, $49, $f5  ; 2 down from (9, 4): object $F5
	db $c2, $58, $f5  ; 2 down from (8, 5): object $F5
	db $c2, $67, $0a  ; 2 down from (7, 6): object $0A
	db $18, $44  ; (8, 1): object $44
	db $45, $44  ; (5, 4): object $44
	db $63, $44  ; (3, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $71 (row 7, column 1 of the 16 x 16 map): 22 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom71::
	db $03, $04  ; animated tiles $03, floor $04
	db $c5, $07, $86  ; 5 down from (7, 0): object $86
	db $c5, $08, $90  ; 5 down from (8, 0): object $90
	db $c5, $09, $90  ; 5 down from (9, 0): object $90
	db $c2, $4f, $f5  ; 2 down from (15, 4): object $F5
	db $61, $f5  ; (1, 6): object $F5
	db $c3, $30, $f5  ; 3 down from (0, 3): object $F5
	db $32, $20  ; (2, 3): object $20
	db $82, $23, $f5  ; 2 across from (3, 2): object $F5
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $c4, $08, $f5  ; 4 down from (8, 0): object $F5
	db $46, $f5  ; (6, 4): object $F5
	db $57, $f5  ; (7, 5): object $F5
	db $83, $53, $0a  ; 3 across from (3, 5): object $0A
	db $64, $0a  ; (4, 6): object $0A
	db $12, $08  ; (2, 1): object $08
	db $14, $08  ; (4, 1): object $08
	db $83, $72, $f5  ; 3 across from (2, 7): object $F5
	db $44, $44  ; (4, 4): object $44
	db $53, $44  ; (3, 5): object $44
	db $55, $44  ; (5, 5): object $44
	db $64, $44  ; (4, 6): object $44
	db $54, $a0  ; (4, 5): object $A0
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $72 (row 7, column 2 of the 16 x 16 map): 28 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom72::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $90  ; 8 down from (0, 0): object $90
	db $89, $71, $90  ; 9 across from (1, 7): object $90
	db $c4, $39, $90  ; 4 down from (9, 3): object $90
	db $c6, $01, $87  ; 6 down from (1, 0): object $87
	db $86, $62, $85  ; 6 across from (2, 6): object $85
	db $c2, $03, $86  ; 2 down from (3, 0): object $86
	db $c3, $38, $86  ; 3 down from (8, 3): object $86
	db $68, $8b  ; (8, 6): object $8B
	db $61, $8a  ; (1, 6): object $8A
	db $23, $8d  ; (3, 2): object $8D
	db $28, $8f  ; (8, 2): object $8F
	db $29, $85  ; (9, 2): object $85
	db $47, $5c  ; (7, 4): object $5C
	db $86, $52, $5c  ; 6 across from (2, 5): object $5C
	db $82, $24, $84  ; 2 across from (4, 2): object $84
	db $82, $14, $90  ; 2 across from (4, 1): object $90
	db $82, $04, $90  ; 2 across from (4, 0): object $90
	db $26, $8c  ; (6, 2): object $8C
	db $16, $87  ; (6, 1): object $87
	db $06, $88  ; (6, 0): object $88
	db $60, $f5  ; (0, 6): object $F5
	db $83, $07, $84  ; 3 across from (7, 0): object $84
	db $04, $f5  ; (4, 0): object $F5
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $85, $71, $f5  ; 5 across from (1, 7): object $F5
	db $c2, $39, $f5  ; 2 down from (9, 3): object $F5
	db $35, $44  ; (5, 3): object $44
	db $42, $44  ; (2, 4): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $73 (row 7, column 3 of the 16 x 16 map): 34 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom73::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $00, $84  ; 2 across from (0, 0): object $84
	db $c5, $30, $90  ; 5 down from (0, 3): object $90
	db $c8, $09, $90  ; 8 down from (9, 0): object $90
	db $c5, $28, $86  ; 5 down from (8, 2): object $86
	db $78, $90  ; (8, 7): object $90
	db $02, $8c  ; (2, 0): object $8C
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $71, $90  ; (1, 7): object $90
	db $c4, $31, $87  ; 4 down from (1, 3): object $87
	db $20, $85  ; (0, 2): object $85
	db $21, $8e  ; (1, 2): object $8E
	db $c3, $3f, $f5  ; 3 down from (15, 3): object $F5
	db $86, $62, $85  ; 6 across from (2, 6): object $85
	db $61, $8a  ; (1, 6): object $8A
	db $68, $8b  ; (8, 6): object $8B
	db $87, $71, $90  ; 7 across from (1, 7): object $90
	db $85, $71, $f5  ; 5 across from (1, 7): object $F5
	db $82, $05, $0a  ; 2 across from (5, 0): object $0A
	db $07, $8d  ; (7, 0): object $8D
	db $08, $89  ; (8, 0): object $89
	db $c5, $17, $0a  ; 5 down from (7, 1): object $0A
	db $56, $0a  ; (6, 5): object $0A
	db $52, $08  ; (2, 5): object $08
	db $18, $86  ; (8, 1): object $86
	db $14, $e8  ; (4, 1): object $E8
	db $23, $08  ; (3, 2): object $08
	db $25, $08  ; (5, 2): object $08
	db $32, $e8  ; (2, 3): object $E8
	db $34, $5c  ; (4, 3): object $5C
	db $36, $e8  ; (6, 3): object $E8
	db $43, $08  ; (3, 4): object $08
	db $45, $08  ; (5, 4): object $08
	db $54, $e8  ; (4, 5): object $E8
	db $12, $44  ; (2, 1): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $74 (row 7, column 4 of the 16 x 16 map): 22 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoom74::
	db $03, $03  ; animated tiles $03, floor $03
	db $c8, $00, $04  ; 8 down from (0, 0): object $04
	db $84, $06, $3a  ; 4 across from (6, 0): object $3A
	db $07, $e0  ; (7, 0): object $E0
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $05, $38  ; (5, 0): object $38
	db $11, $3d  ; (1, 1): object $3D
	db $12, $48  ; (2, 1): object $48
	db $13, $e0  ; (3, 1): object $E0
	db $14, $49  ; (4, 1): object $49
	db $15, $34  ; (5, 1): object $34
	db $c5, $21, $38  ; 5 down from (1, 2): object $38
	db $83, $25, $0a  ; 3 across from (5, 2): object $0A
	db $26, $08  ; (6, 2): object $08
	db $34, $0a  ; (4, 3): object $0A
	db $83, $35, $08  ; 3 across from (5, 3): object $08
	db $38, $0a  ; (8, 3): object $0A
	db $36, $5c  ; (6, 3): object $5C
	db $83, $45, $0a  ; 3 across from (5, 4): object $0A
	db $46, $08  ; (6, 4): object $08
	db $71, $32  ; (1, 7): object $32
	db $88, $72, $2c  ; 8 across from (2, 7): object $2C
	db $26, $08  ; (6, 2): object $08
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $75 (row 7, column 5 of the 16 x 16 map): 24 objects on floor object $04; a warp (type 1) to map $0A room $DE at x 56, y 64. Format: see OverworldRoomPointers.
OverworldRoom75::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $00, $3a  ; 6 across from (0, 0): object $3A
	db $c3, $06, $37  ; 3 down from (6, 0): object $37
	db $86, $10, $03  ; 6 across from (0, 1): object $03
	db $86, $20, $03  ; 6 across from (0, 2): object $03
	db $86, $30, $03  ; 6 across from (0, 3): object $03
	db $86, $40, $03  ; 6 across from (0, 4): object $03
	db $86, $50, $03  ; 6 across from (0, 5): object $03
	db $86, $60, $03  ; 6 across from (0, 6): object $03
	db $c4, $17, $0a  ; 4 down from (7, 1): object $0A
	db $c3, $f9, $f5  ; 3 down from (9, 15): object $F5
	db $23, $20  ; (3, 2): object $20
	db $c2, $32, $20  ; 2 down from (2, 3): object $20
	db $c2, $34, $20  ; 2 down from (4, 3): object $20
	db $35, $2b  ; (5, 3): object $2B
	db $36, $31  ; (6, 3): object $31
	db $38, $0a  ; (8, 3): object $0A
	db $c3, $45, $37  ; 3 down from (5, 4): object $37
	db $53, $20  ; (3, 5): object $20
	db $56, $0a  ; (6, 5): object $0A
	db $c2, $58, $f5  ; 2 down from (8, 5): object $F5
	db $69, $f5  ; (9, 6): object $F5
	db $85, $70, $2c  ; 5 across from (0, 7): object $2C
	db $75, $31  ; (5, 7): object $31
	db $33, $c6  ; (3, 3): object $C6
	db $e1, $0a, $de, $38, $40  ; warp type 1 to map $0A room $DE, x 56 y 64
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $76 (row 7, column 6 of the 16 x 16 map): 32 objects on floor object $0A; a warp (type 1) to map $0A room $DF at x 56, y 48. Format: see OverworldRoomPointers.
OverworldRoom76::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $c8, $00, $04  ; 8 down from (0, 0): object $04
	db $c3, $ff, $f5  ; 3 down from (15, 15): object $F5
	db $31, $04  ; (1, 3): object $04
	db $c5, $01, $51  ; 5 down from (1, 0): object $51
	db $82, $04, $09  ; 2 across from (4, 0): object $09
	db $06, $03  ; (6, 0): object $03
	db $09, $04  ; (9, 0): object $04
	db $f9, $f5  ; (9, 15): object $F5
	db $13, $09  ; (3, 1): object $09
	db $14, $c4  ; (4, 1): object $C4
	db $16, $c4  ; (6, 1): object $C4
	db $83, $17, $03  ; 3 across from (7, 1): object $03
	db $18, $0a  ; (8, 1): object $0A
	db $26, $03  ; (6, 2): object $03
	db $82, $27, $09  ; 2 across from (7, 2): object $09
	db $34, $c4  ; (4, 3): object $C4
	db $35, $03  ; (5, 3): object $03
	db $36, $c5  ; (6, 3): object $C5
	db $37, $03  ; (7, 3): object $03
	db $82, $43, $03  ; 2 across from (3, 4): object $03
	db $82, $47, $03  ; 2 across from (7, 4): object $03
	db $49, $09  ; (9, 4): object $09
	db $c2, $51, $04  ; 2 down from (1, 5): object $04
	db $88, $52, $51  ; 8 across from (2, 5): object $51
	db $71, $08  ; (1, 7): object $08
	db $72, $38  ; (2, 7): object $38
	db $62, $3d  ; (2, 6): object $3D
	db $87, $63, $2f  ; 7 across from (3, 6): object $2F
	db $87, $73, $3a  ; 7 across from (3, 7): object $3A
	db $c2, $50, $f5  ; 2 down from (0, 5): object $F5
	db $6f, $f5  ; (15, 6): object $F5
	db $09, $fb  ; (9, 0): object $FB
	db $e1, $0a, $df, $38, $30  ; warp type 1 to map $0A room $DF, x 56 y 48
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $77 (row 7, column 7 of the 16 x 16 map): 33 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoom77::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $ff, $f5  ; (15, 15): object $F5
	db $01, $09  ; (1, 0): object $09
	db $82, $02, $03  ; 2 across from (2, 0): object $03
	db $c4, $09, $51  ; 4 down from (9, 0): object $51
	db $12, $03  ; (2, 1): object $03
	db $13, $c4  ; (3, 1): object $C4
	db $14, $09  ; (4, 1): object $09
	db $15, $c4  ; (5, 1): object $C4
	db $16, $03  ; (6, 1): object $03
	db $17, $c4  ; (7, 1): object $C4
	db $21, $03  ; (1, 2): object $03
	db $82, $22, $09  ; 2 across from (2, 2): object $09
	db $26, $09  ; (6, 2): object $09
	db $27, $03  ; (7, 2): object $03
	db $32, $03  ; (2, 3): object $03
	db $33, $c4  ; (3, 3): object $C4
	db $35, $c4  ; (5, 3): object $C4
	db $36, $03  ; (6, 3): object $03
	db $82, $44, $03  ; 2 across from (4, 4): object $03
	db $84, $46, $51  ; 4 across from (6, 4): object $51
	db $85, $50, $51  ; 5 across from (0, 5): object $51
	db $85, $60, $2f  ; 5 across from (0, 6): object $2F
	db $65, $4e  ; (5, 6): object $4E
	db $55, $3d  ; (5, 5): object $3D
	db $56, $35  ; (6, 5): object $35
	db $85, $70, $3a  ; 5 across from (0, 7): object $3A
	db $75, $3f  ; (5, 7): object $3F
	db $82, $68, $04  ; 2 across from (8, 6): object $04
	db $84, $76, $04  ; 4 across from (6, 7): object $04
	db $68, $f5  ; (8, 6): object $F5
	db $76, $f5  ; (6, 7): object $F5
	db $00, $b7  ; (0, 0): object $B7
	db $10, $ce  ; (0, 1): object $CE
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $78 (row 7, column 8 of the 16 x 16 map): 17 objects on floor object $0E; a warp (type 1) to map $1F room $FD at x 88, y 80. Format: see OverworldRoomPointers.
OverworldRoom78::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $8a, $60, $04  ; 10 across from (0, 6): object $04
	db $8a, $70, $04  ; 10 across from (0, 7): object $04
	db $60, $f5  ; (0, 6): object $F5
	db $84, $72, $f5  ; 4 across from (2, 7): object $F5
	db $c5, $00, $38  ; 5 down from (0, 0): object $38
	db $50, $32  ; (0, 5): object $32
	db $89, $51, $2c  ; 9 across from (1, 5): object $2C
	db $86, $04, $96  ; 6 across from (4, 0): object $96
	db $86, $14, $93  ; 6 across from (4, 1): object $93
	db $02, $9d  ; (2, 0): object $9D
	db $03, $9e  ; (3, 0): object $9E
	db $12, $97  ; (2, 1): object $97
	db $22, $94  ; (2, 2): object $94
	db $13, $98  ; (3, 1): object $98
	db $23, $95  ; (3, 2): object $95
	db $62, $c6  ; (2, 6): object $C6
	db $e1, $1f, $fd, $58, $50  ; warp type 1 to map $1F room $FD, x 88 y 80
	db $85, $64, $e8  ; 5 across from (4, 6): object $E8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $79 (row 7, column 9 of the 16 x 16 map): 31 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom79::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $96  ; 10 across from (0, 0): object $96
	db $8a, $10, $93  ; 10 across from (0, 1): object $93
	db $8a, $20, $0e  ; 10 across from (0, 2): object $0E
	db $8a, $30, $0e  ; 10 across from (0, 3): object $0E
	db $8a, $40, $0e  ; 10 across from (0, 4): object $0E
	db $03, $9e  ; (3, 0): object $9E
	db $13, $98  ; (3, 1): object $98
	db $23, $95  ; (3, 2): object $95
	db $02, $9d  ; (2, 0): object $9D
	db $12, $97  ; (2, 1): object $97
	db $22, $94  ; (2, 2): object $94
	db $07, $9d  ; (7, 0): object $9D
	db $17, $97  ; (7, 1): object $97
	db $27, $94  ; (7, 2): object $94
	db $08, $9e  ; (8, 0): object $9E
	db $18, $98  ; (8, 1): object $98
	db $28, $95  ; (8, 2): object $95
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $33, $9f  ; (3, 3): object $9F
	db $37, $9f  ; (7, 3): object $9F
	db $43, $9a  ; (3, 4): object $9A
	db $47, $9a  ; (7, 4): object $9A
	db $53, $a3  ; (3, 5): object $A3
	db $57, $a3  ; (7, 5): object $A3
	db $c6, $04, $0d  ; 6 down from (4, 0): object $0D
	db $c6, $06, $0d  ; 6 down from (6, 0): object $0D
	db $c8, $05, $0c  ; 8 down from (5, 0): object $0C
	db $70, $f5  ; (0, 7): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $83, $14, $ab  ; 3 across from (4, 1): object $AB
	db $83, $24, $ac  ; 3 across from (4, 2): object $AC
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Second layout of overworld room $79 (row 7, column 9 of the 16 x 16 map): 29 objects on floor object $04. Format: see OverworldRoomPointers. The loader uses it instead of the first layout once the room's event has happened.
OverworldRoom79Alt::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $96  ; 10 across from (0, 0): object $96
	db $8a, $10, $93  ; 10 across from (0, 1): object $93
	db $8a, $20, $0e  ; 10 across from (0, 2): object $0E
	db $8a, $30, $0e  ; 10 across from (0, 3): object $0E
	db $8a, $40, $0e  ; 10 across from (0, 4): object $0E
	db $03, $9e  ; (3, 0): object $9E
	db $13, $98  ; (3, 1): object $98
	db $23, $95  ; (3, 2): object $95
	db $02, $9d  ; (2, 0): object $9D
	db $12, $97  ; (2, 1): object $97
	db $22, $94  ; (2, 2): object $94
	db $07, $9d  ; (7, 0): object $9D
	db $17, $97  ; (7, 1): object $97
	db $27, $94  ; (7, 2): object $94
	db $08, $9e  ; (8, 0): object $9E
	db $18, $98  ; (8, 1): object $98
	db $28, $95  ; (8, 2): object $95
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $33, $9f  ; (3, 3): object $9F
	db $37, $9f  ; (7, 3): object $9F
	db $43, $9a  ; (3, 4): object $9A
	db $47, $9a  ; (7, 4): object $9A
	db $53, $a3  ; (3, 5): object $A3
	db $57, $a3  ; (7, 5): object $A3
	db $c6, $04, $0d  ; 6 down from (4, 0): object $0D
	db $c6, $06, $0d  ; 6 down from (6, 0): object $0D
	db $c8, $05, $0c  ; 8 down from (5, 0): object $0C
	db $70, $f5  ; (0, 7): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $7A (row 7, column A of the 16 x 16 map): 12 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoom7A::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $8a, $60, $04  ; 10 across from (0, 6): object $04
	db $8a, $70, $04  ; 10 across from (0, 7): object $04
	db $87, $00, $96  ; 7 across from (0, 0): object $96
	db $87, $10, $93  ; 7 across from (0, 1): object $93
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $07, $9d  ; (7, 0): object $9D
	db $08, $9e  ; (8, 0): object $9E
	db $17, $97  ; (7, 1): object $97
	db $18, $98  ; (8, 1): object $98
	db $27, $94  ; (7, 2): object $94
	db $28, $95  ; (8, 2): object $95
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $7B (row 7, column B of the 16 x 16 map): 27 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom7B::
	db $03, $04  ; animated tiles $03, floor $04
	db $f2, $f5  ; (2, 15): object $F5
	db $f5, $f5  ; (5, 15): object $F5
	db $c5, $00, $0e  ; 5 down from (0, 0): object $0E
	db $c8, $08, $0e  ; 8 down from (8, 0): object $0E
	db $c3, $21, $0e  ; 3 down from (1, 2): object $0E
	db $c3, $27, $0e  ; 3 down from (7, 2): object $0E
	db $85, $22, $0e  ; 5 across from (2, 2): object $0E
	db $01, $37  ; (1, 0): object $37
	db $11, $33  ; (1, 1): object $33
	db $85, $12, $2f  ; 5 across from (2, 1): object $2F
	db $07, $38  ; (7, 0): object $38
	db $17, $34  ; (7, 1): object $34
	db $32, $2b  ; (2, 3): object $2B
	db $36, $2d  ; (6, 3): object $2D
	db $42, $37  ; (2, 4): object $37
	db $46, $38  ; (6, 4): object $38
	db $52, $31  ; (2, 5): object $31
	db $56, $32  ; (6, 5): object $32
	db $57, $2d  ; (7, 5): object $2D
	db $82, $50, $2c  ; 2 across from (0, 5): object $2C
	db $c2, $67, $38  ; 2 down from (7, 6): object $38
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $83, $33, $2c  ; 3 across from (3, 3): object $2C
	db $14, $d8  ; (4, 1): object $D8
	db $24, $d9  ; (4, 2): object $D9
	db $34, $da  ; (4, 3): object $DA
	db $82, $7f, $f5  ; 2 across from (15, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $7C (row 7, column C of the 16 x 16 map): 12 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom7C::
	db $09, $eb  ; animated tiles $09, floor $EB
	db $c5, $00, $38  ; 5 down from (0, 0): object $38
	db $50, $32  ; (0, 5): object $32
	db $89, $51, $2c  ; 9 across from (1, 5): object $2C
	db $60, $3d  ; (0, 6): object $3D
	db $70, $38  ; (0, 7): object $38
	db $89, $61, $2f  ; 9 across from (1, 6): object $2F
	db $89, $71, $3a  ; 9 across from (1, 7): object $3A
	db $c4, $01, $ed  ; 4 down from (1, 0): object $ED
	db $85, $12, $ec  ; 5 across from (2, 1): object $EC
	db $85, $22, $ec  ; 5 across from (2, 2): object $EC
	db $85, $32, $ec  ; 5 across from (2, 3): object $EC
	db $83, $17, $c8  ; 3 across from (7, 1): object $C8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $7D (row 7, column D of the 16 x 16 map): 15 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom7D::
	db $09, $eb  ; animated tiles $09, floor $EB
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $10, $c8  ; (0, 1): object $C8
	db $83, $21, $c8  ; 3 across from (1, 2): object $C8
	db $c3, $05, $c8  ; 3 down from (5, 0): object $C8
	db $26, $c8  ; (6, 2): object $C8
	db $82, $38, $c8  ; 2 across from (8, 3): object $C8
	db $07, $cd  ; (7, 0): object $CD
	db $08, $ce  ; (8, 0): object $CE
	db $09, $cd  ; (9, 0): object $CD
	db $c3, $04, $ed  ; 3 down from (4, 0): object $ED
	db $c2, $27, $ed  ; 2 down from (7, 2): object $ED
	db $06, $ed  ; (6, 0): object $ED
	db $20, $ed  ; (0, 2): object $ED
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $7E (row 7, column E of the 16 x 16 map): 16 objects on floor object $EB. Format: see OverworldRoomPointers.
OverworldRoom7E::
	db $0a, $eb  ; animated tiles $0A, floor $EB
	db $00, $ce  ; (0, 0): object $CE
	db $01, $cd  ; (1, 0): object $CD
	db $02, $ce  ; (2, 0): object $CE
	db $03, $cd  ; (3, 0): object $CD
	db $04, $ce  ; (4, 0): object $CE
	db $05, $cd  ; (5, 0): object $CD
	db $06, $ce  ; (6, 0): object $CE
	db $07, $cd  ; (7, 0): object $CD
	db $08, $ce  ; (8, 0): object $CE
	db $09, $cd  ; (9, 0): object $CD
	db $83, $30, $c8  ; 3 across from (0, 3): object $C8
	db $88, $22, $c8  ; 8 across from (2, 2): object $C8
	db $83, $45, $c8  ; 3 across from (5, 4): object $C8
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $8a, $60, $2f  ; 10 across from (0, 6): object $2F
	db $8a, $70, $3a  ; 10 across from (0, 7): object $3A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $7F (row 7, column F of the 16 x 16 map): 37 objects on floor object $ED. Format: see OverworldRoomPointers.
OverworldRoom7F::
	db $0a, $ed  ; animated tiles $0A, floor $ED
	db $00, $ce  ; (0, 0): object $CE
	db $01, $cd  ; (1, 0): object $CD
	db $02, $ce  ; (2, 0): object $CE
	db $03, $cd  ; (3, 0): object $CD
	db $04, $ce  ; (4, 0): object $CE
	db $05, $cd  ; (5, 0): object $CD
	db $06, $ce  ; (6, 0): object $CE
	db $07, $cd  ; (7, 0): object $CD
	db $08, $ce  ; (8, 0): object $CE
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $84, $10, $ed  ; 4 across from (0, 1): object $ED
	db $20, $c8  ; (0, 2): object $C8
	db $83, $30, $ed  ; 3 across from (0, 3): object $ED
	db $83, $40, $ed  ; 3 across from (0, 4): object $ED
	db $33, $c8  ; (3, 3): object $C8
	db $83, $16, $c8  ; 3 across from (6, 1): object $C8
	db $28, $c8  ; (8, 2): object $C8
	db $50, $2c  ; (0, 5): object $2C
	db $51, $2d  ; (1, 5): object $2D
	db $55, $2b  ; (5, 5): object $2B
	db $82, $56, $2c  ; 2 across from (6, 5): object $2C
	db $58, $2d  ; (8, 5): object $2D
	db $60, $2f  ; (0, 6): object $2F
	db $61, $4e  ; (1, 6): object $4E
	db $65, $2e  ; (5, 6): object $2E
	db $82, $66, $2f  ; 2 across from (6, 6): object $2F
	db $68, $4e  ; (8, 6): object $4E
	db $70, $3a  ; (0, 7): object $3A
	db $71, $3f  ; (1, 7): object $3F
	db $75, $3e  ; (5, 7): object $3E
	db $82, $76, $3a  ; 2 across from (6, 7): object $3A
	db $78, $3f  ; (8, 7): object $3F
	db $83, $62, $e9  ; 3 across from (2, 6): object $E9
	db $83, $72, $e9  ; 3 across from (2, 7): object $E9
	db $84, $10, $eb  ; 4 across from (0, 1): object $EB
	db $82, $30, $eb  ; 2 across from (0, 3): object $EB
	db $82, $40, $eb  ; 2 across from (0, 4): object $EB
	db $fe  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank09FreeSpace1::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: text/dialogs
;@ Dialog $0E8: "You've found a Golden Leaf! You can see how many you have on the Su..."
Dialog0E8::
	db "You^ve found a  "
	db "Golden Leaf!    "
	db "You can see how "
	db "many you have on"
	db "the Sub-Screen."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $0E9: "At last! You've got the final Golden Leaf! Now go and see Richard a..." (B does not hurry it)
Dialog0E9::
	db "At last!  You^ve"
	db "got the final   "
	db "Golden Leaf!    "
	db "Now go and see  "
	db "Richard about   "
	db "that key..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0EA, $0EB, $0EC: "You've got a Guardian Acorn! It will reduce the damage you take by ..."
Dialog0EA::
	db "You^ve got a    "
	db "Guardian Acorn! "
	db "It will reduce  "
	db "the damage you  "
	db "take by half!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0ED: "You've got the Mirror Shield! You can now turn back the beams you c..."
Dialog0ED::
	db "You^ve got the  "
	db "Mirror Shield!  "
	db "You can now turn"
	db "back the beams  "
	db "you couldn^t    "
	db "block before!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0EE: "You've got a more Powerful Bracelet! Now you can almost lift a whale!"
Dialog0EE::
	db "You^ve got a    "
	db "more Powerful   "
	db "Bracelet!  Now  "
	db "you can almost  "
	db "lift a whale!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0EF: "You found a Secret Seashell! If you collect a lot of these, somethi..."
Dialog0EF::
	db "You found a     "
	db "Secret Seashell!"
	db "If you collect a"
	db "lot of these,   "
	db "something good  "
	db "is bound to     "
	db "happen!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F0: "Want to go on a raft ride for a hundred Rupees? Yes No Way"
Dialog0F0::
	db "Want to go on a "
	db "raft ride for a "
	db "hundred Rupees? "
	db "    Yes  No Way"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0F1: "Okay, the raft is ready for you outside! Enjoy!"
Dialog0F1::
	db "Okay, the raft  "
	db "is ready for you"
	db "outside!  Enjoy!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F2: "Waterfall at the Shrine"
Dialog0F2::
	db "Waterfall at the"
	db "    Shrine"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F3: "South of the Shrine"
Dialog0F3::
	db " South of the   "
	db "    Shrine"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F4: "Entrance to the Animal Village"
Dialog0F4::
	db "Entrance to the "
	db " Animal Village"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F5: "We were born of nightmares... To take over this world, we made the ..." (B does not hurry it)
Dialog0F5::
	db "We were born of "
	db "nightmares... To"
	db "take over this  "
	db "world, we made  "
	db "the Wind Fish   "
	db "sleep endlessly!"
	db "If the Wind Fish"
	db "doesn^t wake up,"
	db "this island will"
	db "never disappear!"
	db "We would have   "
	db "been the masters"
	db "of this place..."
	db "But you had to  "
	db "come here and   "
	db "disrupt our     "
	db "plans!  Heh heh!"
	db "You can never   "
	db "defeat us!!!    "
	db "Let^s rumble!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F6: "This island is going to dis- appear... Our world is going to disapp..." (B does not hurry it)
Dialog0F6::
	db "This island is  "
	db "going to dis-   "
	db "appear...  Our  "
	db "world is going  "
	db "to disappear... "
	db "Our world...    "
	db "Our... world... "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0F7: "Wow! [NAME], can I try this?! What do you say? Okay No Way" (B does not hurry it)
Dialog0F7::
	db "Wow!  #####, can"
	db "I try this?!    "
	db "What do you say?"
	db "    Okay No Way"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0F8: "C'mon! I want to do it! Can I? It looks so fun! Yes Okay"
Dialog0F8::
	db "C^mon!  I want  "
	db "to do it! Can I?"
	db "It looks so fun!"
	db "    Yes  Okay"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0F9: "You're good! You're a pro, aren't you? ... ... ... ... Well, beat i..."
Dialog0F9::
	db "You^re good!    "
	db "You^re a pro,   "
	db "aren^t you?     "
	db "... ... ... ... "
	db "Well, beat it!  "
	db "Pros aren^t     "
	db "allowed in here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0FA: "Go away!"
Dialog0FA::
	db "Go away!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0FB: "Quit it!"
Dialog0FB::
	db "Quit it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0FC: "This is not a chest... What? You knew that? Okay."
Dialog0FC::
	db "This is not a   "
	db "chest...  What? "
	db "You knew that?  "
	db "Okay."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0FD: "[NAME] checked the chest. Wow! This is a nice chest!"
Dialog0FD::
	db "##### checked   "
	db "the chest.  Wow!"
	db "This is a nice  "
	db "chest!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0FE: "It's all ready, it is! Take care, as there's not much there! Why no..." (B does not hurry it)
Dialog0FE::
	db "It^s all ready, "
	db "it is!  Take    "
	db "care, as there^s"
	db "not much there! "
	db "Why not try a   "
	db "bit in my hut?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0FF: "Hey! What are ya doin' in my chest?! Where'd you learn ta do such a..."
Dialog0FF::
	db "Hey!  What are  "
	db "ya doin^ in my  "
	db "chest?!  Where^d"
	db "you learn ta do "
	db "such a thing?!"
	db $ff  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank09FreeSpace2::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
;@ Dialog $276: "Ha ha ha! Do it! Do it! Do it moooore! ... ... Hunh? No, it's nothi..."
Dialog276::
	db "Ha ha ha! Do it!"
	db "Do it!  Do it   "
	db "moooore! ... ..."
	db "Hunh?  No, it^s "
	db "nothing... I    "
	db "didn^t mean it."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $277: "Not very good... Eh? What? Did I say something? No, you're hear- in..."
Dialog277::
	db "Not very good..."
	db "Eh?  What?  Did "
	db "I say something?"
	db "No, you^re hear-"
	db "ing things..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $278: "[NAME], do you always look in other people's drawers?"
Dialog278::
	db "#####, do you   "
	db "always look in  "
	db "other people^s  "
	db "drawers?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $279: "Great! Dig it! Dig it! Dig to the center of the earth!!"
Dialog279::
	db "Great!  Dig it! "
	db "Dig it!  Dig to "
	db "the center of   "
	db "the earth!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $27A: "Whew! What a surprise!"
Dialog27A::
	db "Whew!  What a   "
	db "surprise!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $27B: "Ohh! I'm sorry! Are you okay?! [NAME]?"
Dialog27B::
	db "Ohh!  I^m sorry!"
	db "Are you okay?!  "
	db "#####?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $27C: "Hey Mon!"
Dialog27C::
	db "Hey Mon!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $27D: "You know me, I like short names the best..."
Dialog27D::
	db "You know me, I  "
	db "like short names"
	db "the best..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $27E: "It can display millions of polygons!"
Dialog27E::
	db "It can display  "
	db "millions of     "
	db "polygons!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $27F: "I definitely need it, as soon as possible!"
Dialog27F::
	db "I definitely    "
	db "need it, as soon"
	db "as possible!"
	db $ff  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank09FreeSpace3::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
