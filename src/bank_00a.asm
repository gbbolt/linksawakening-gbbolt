; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $00a", ROMX[$4000], BANK[$a]

;@ path: world/indoor/rooms
;@ The data address of each of the 256 rooms of indoor group A, one word per room: the rooms of the maps $00-$05 and $1A-$1F (the first five dungeons, the caves and houses of those maps). A special second layout of room $F5 of map $1F is used while the story value at $DB0E is $0E (IndoorARoomF5Alt).
;@ Room data format: byte 0 = the room's animated-tiles set (which background tiles animate: water, flowers, torches...; hAnimatedTilesGroup), byte 1 = the floor object in the low nibble (FillRoomObjects) and the room template in the high nibble (ApplyIndoorRoomTemplate: which walls and corners frame the room), then a list of entries up to the end byte $FE:
;@ - $E0-$E3 = a warp, 5 bytes: type (the low 2 bits), destination map, destination room, x and y (pixels) where Link appears; the loader copies up to four of them to the warp list at $D401.
;@ - $8N / $CN (bit 7 set, bit 4 clear) = a strip, 3 bytes: N copies of the object going right ($8N) or down ($CN), from position YX, then the object number.
;@ - otherwise 2 bytes: position YX (Y = row 0-7 in the high nibble, X = column 0-9 in the low nibble) and the object number. Objects $EC-$FD are macros (doors, stairs, key blocks...; IndoorMacroHandlers).
;@ Objects are 16 x 16 pixel blocks; each is drawn from four tiles (OverworldObjectTiles / IndoorObjectTiles in bank $08). The loader (LoadRoom) fills the room's 10 x 8 object grid at $D711 (rows 16 bytes apart) from this list.
IndoorARoomPointers::
	dw IndoorARoom00, IndoorARoom01, IndoorARoom02, IndoorARoom03  ; room $00-$03
	dw IndoorARoom04, IndoorARoom05, IndoorARoom06, IndoorARoom07  ; room $04-$07
	dw IndoorARoom08, IndoorARoom09, IndoorARoom0A, IndoorARoom0B  ; room $08-$0B
	dw IndoorARoom0C, IndoorARoom0D, IndoorARoom0E, IndoorARoom0F  ; room $0C-$0F
	dw IndoorARoom10, IndoorARoom11, IndoorARoom12, IndoorARoom13  ; room $10-$13
	dw IndoorARoom14, IndoorARoom15, IndoorARoom16, IndoorARoom17  ; room $14-$17
	dw IndoorARoom18, IndoorARoom19, IndoorARoom1A, IndoorARoom1B  ; room $18-$1B
	dw IndoorARoom1C, IndoorARoom1D, IndoorARoom1E, IndoorARoom1F  ; room $1C-$1F
	dw IndoorARoom20, IndoorARoom21, IndoorARoom22, IndoorARoom23  ; room $20-$23
	dw IndoorARoom24, IndoorARoom25, IndoorARoom26, IndoorARoom27  ; room $24-$27
	dw IndoorARoom28, IndoorARoom29, IndoorARoom2A, IndoorARoom2B  ; room $28-$2B
	dw IndoorARoom2C, IndoorARoom2D, IndoorARoom2E, IndoorARoom2F  ; room $2C-$2F
	dw IndoorARoom30, IndoorARoom31, IndoorARoom32, IndoorARoom33  ; room $30-$33
	dw IndoorARoom34, IndoorARoom35, IndoorARoom36, IndoorARoom37  ; room $34-$37
	dw IndoorARoom38, IndoorARoom39, IndoorARoom3A, IndoorARoom3B  ; room $38-$3B
	dw IndoorARoom3C, IndoorARoom3D, IndoorARoom3E, IndoorARoom3F  ; room $3C-$3F
	dw IndoorARoom40, IndoorARoom41, IndoorARoom42, IndoorARoom43  ; room $40-$43
	dw IndoorARoom44, IndoorARoom45, IndoorARoom46, IndoorARoom47  ; room $44-$47
	dw IndoorARoom48, IndoorARoom49, IndoorARoom4A, IndoorARoom4B  ; room $48-$4B
	dw IndoorARoom4C, IndoorARoom4D, IndoorARoom4E, IndoorARoom4F  ; room $4C-$4F
	dw IndoorARoom50, IndoorARoom51, IndoorARoom52, IndoorARoom53  ; room $50-$53
	dw IndoorARoom54, IndoorARoom55, IndoorARoom56, IndoorARoom57  ; room $54-$57
	dw IndoorARoom58, IndoorARoom59, IndoorARoom5A, IndoorARoom5B  ; room $58-$5B
	dw IndoorARoom5C, IndoorARoom5D, IndoorARoom5E, IndoorARoom5F  ; room $5C-$5F
	dw IndoorARoom60, IndoorARoom61, IndoorARoom62, IndoorARoom63  ; room $60-$63
	dw IndoorARoom64, IndoorARoom65, IndoorARoom66, IndoorARoom67  ; room $64-$67
	dw IndoorARoom68, IndoorARoom69, IndoorARoom6A, IndoorARoom6B  ; room $68-$6B
	dw IndoorARoom6C, IndoorARoom6D, IndoorARoom6E, IndoorARoom6F  ; room $6C-$6F
	dw IndoorARoom70, IndoorARoom71, IndoorARoom72, IndoorARoom73  ; room $70-$73
	dw IndoorARoom74, IndoorARoom75, IndoorARoom76, IndoorARoom77  ; room $74-$77
	dw IndoorARoom78, IndoorARoom79, IndoorARoom7A, IndoorARoom7B  ; room $78-$7B
	dw IndoorARoom7C, IndoorARoom7D, IndoorARoom7E, IndoorARoom7E  ; room $7C-$7F
	dw IndoorARoom80, IndoorARoom81, IndoorARoom82, IndoorARoom83  ; room $80-$83
	dw IndoorARoom84, IndoorARoom85, IndoorARoom86, IndoorARoom87  ; room $84-$87
	dw IndoorARoom88, IndoorARoom89, IndoorARoom8A, IndoorARoom8B  ; room $88-$8B
	dw IndoorARoom8C, IndoorARoom8D, IndoorARoom8E, IndoorARoom8F  ; room $8C-$8F
	dw IndoorARoom90, IndoorARoom91, IndoorARoom92, IndoorARoom93  ; room $90-$93
	dw IndoorARoom94, IndoorARoom95, IndoorARoom96, IndoorARoom97  ; room $94-$97
	dw IndoorARoom98, IndoorARoom99, IndoorARoom9A, IndoorARoom9B  ; room $98-$9B
	dw IndoorARoom9C, IndoorARoom9D, IndoorARoom9E, IndoorARoom9F  ; room $9C-$9F
	dw IndoorARoomA0, IndoorARoomA1, IndoorARoomA2, IndoorARoomA3  ; room $A0-$A3
	dw IndoorARoomA4, IndoorARoomA5, IndoorARoomA6, IndoorARoomA7  ; room $A4-$A7
	dw IndoorARoomA8, IndoorARoomA9, IndoorARoomAA, IndoorARoomAB  ; room $A8-$AB
	dw IndoorARoomAC, IndoorARoomAD, IndoorARoomAE, IndoorARoomAF  ; room $AC-$AF
	dw IndoorARoomB0, IndoorARoomB1, IndoorARoomB2, IndoorARoomB3  ; room $B0-$B3
	dw IndoorARoomB4, IndoorARoomB5, IndoorARoomB6, IndoorARoomB7  ; room $B4-$B7
	dw IndoorARoomB8, IndoorARoomB9, IndoorARoomBA, IndoorARoomBB  ; room $B8-$BB
	dw IndoorARoomBC, IndoorARoomBD, IndoorARoomBE, IndoorARoomBF  ; room $BC-$BF
	dw IndoorARoomC0, IndoorARoomC1, IndoorARoomC2, IndoorARoomC3  ; room $C0-$C3
	dw IndoorARoomC4, IndoorARoomC5, IndoorARoomC6, IndoorARoomC7  ; room $C4-$C7
	dw IndoorARoomC8, IndoorARoomC9, IndoorARoomCA, IndoorARoomCB  ; room $C8-$CB
	dw IndoorARoomCC, IndoorARoomCD, IndoorARoomCE, IndoorARoomCF  ; room $CC-$CF
	dw IndoorARoomD0, IndoorARoomD1, IndoorARoomD2, IndoorARoomD3  ; room $D0-$D3
	dw IndoorARoomD4, IndoorARoomD5, IndoorARoomD6, IndoorARoomD7  ; room $D4-$D7
	dw IndoorARoomD8, IndoorARoomD9, IndoorARoomDA, IndoorARoomDB  ; room $D8-$DB
	dw IndoorARoomDC, IndoorARoomDD, IndoorARoomDE, IndoorARoomDF  ; room $DC-$DF
	dw IndoorARoomE0, IndoorARoomE1, IndoorARoomE2, IndoorARoomE3  ; room $E0-$E3
	dw IndoorARoomE4, IndoorARoomE5, IndoorARoomE6, IndoorARoomE7  ; room $E4-$E7
	dw IndoorARoomE8, IndoorARoomE9, IndoorARoomEA, IndoorARoomEB  ; room $E8-$EB
	dw IndoorARoomEC, IndoorARoomED, IndoorARoomED, IndoorARoomEF  ; room $EC-$EF
	dw IndoorARoomF0, IndoorARoomF1, IndoorARoomF2, IndoorARoomF3  ; room $F0-$F3
	dw IndoorARoomF4, IndoorARoomF5, IndoorARoomF6, IndoorARoomF7  ; room $F4-$F7
	dw IndoorARoomF8, IndoorARoomF9, IndoorARoomFA, IndoorARoomFB  ; room $F8-$FB
	dw IndoorARoomFC, IndoorARoomFD, IndoorARoomFE, IndoorARoomFF  ; room $FC-$FF
;@ path: world/indoor/rooms
;@ Room $00 of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom00::
	db $00, $0d  ; animated tiles $00, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $01 of indoor group A: 23 objects, room template 9 and floor object $03; a warp (type 2) to map $00 room $18 at x 40, y 16. Format: see IndoorARoomPointers.
IndoorARoom01::
	db $04, $93  ; animated tiles $04, template 9, floor $03
	db $03, $f4  ; (3, 0): object $F4
	db $c4, $04, $0d  ; 4 down from (4, 0): object $0D
	db $85, $43, $0d  ; 5 across from (3, 4): object $0D
	db $86, $52, $0d  ; 6 across from (2, 5): object $0D
	db $85, $63, $0d  ; 5 across from (3, 6): object $0D
	db $c3, $03, $23  ; 3 down from (3, 0): object $23
	db $31, $25  ; (1, 3): object $25
	db $32, $21  ; (2, 3): object $21
	db $33, $29  ; (3, 3): object $29
	db $c3, $41, $23  ; 3 down from (1, 4): object $23
	db $71, $27  ; (1, 7): object $27
	db $86, $72, $22  ; 6 across from (2, 7): object $22
	db $77, $28  ; (7, 7): object $28
	db $c3, $47, $24  ; 3 down from (7, 4): object $24
	db $37, $26  ; (7, 3): object $26
	db $35, $2a  ; (5, 3): object $2A
	db $36, $21  ; (6, 3): object $21
	db $c3, $05, $24  ; 3 down from (5, 0): object $24
	db $42, $ac  ; (2, 4): object $AC
	db $46, $ac  ; (6, 4): object $AC
	db $62, $ac  ; (2, 6): object $AC
	db $66, $ac  ; (6, 6): object $AC
	db $54, $be  ; (4, 5): object $BE
	db $e2, $00, $18, $28, $10  ; warp type 2 to map $00 room $18, x 40 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $02 of indoor group A: 26 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $D3 at x 104, y 34. Format: see IndoorARoomPointers.
IndoorARoom02::
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
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $e0, $00, $d3, $68, $22  ; warp type 0 to map $00 room $D3, x 104 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $03 of indoor group A: 18 objects, room template 0 and floor object $0D; a warp (type 2) to map $00 room $19 at x 120, y 16. Format: see IndoorARoomPointers.
IndoorARoom03::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $29, $f7  ; (9, 2): object $F7
	db $13, $ae  ; (3, 1): object $AE
	db $16, $ae  ; (6, 1): object $AE
	db $22, $ae  ; (2, 2): object $AE
	db $27, $ae  ; (7, 2): object $AE
	db $51, $ac  ; (1, 5): object $AC
	db $62, $ac  ; (2, 6): object $AC
	db $58, $ac  ; (8, 5): object $AC
	db $67, $ac  ; (7, 6): object $AC
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $70, $03  ; (0, 7): object $03
	db $71, $27  ; (1, 7): object $27
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $79, $03  ; (9, 7): object $03
	db $18, $bf  ; (8, 1): object $BF
	db $e2, $00, $19, $78, $10  ; warp type 2 to map $00 room $19, x 120 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $04 of indoor group A: 22 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom04::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $20, $f2  ; (0, 2): object $F2
	db $39, $f7  ; (9, 3): object $F7
	db $74, $ed  ; (4, 7): object $ED
	db $10, $c9  ; (0, 1): object $C9
	db $40, $c9  ; (0, 4): object $C9
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $09, $21  ; (9, 0): object $21
	db $79, $22  ; (9, 7): object $22
	db $c6, $19, $0d  ; 6 down from (9, 1): object $0D
	db $89, $21, $0f  ; 9 across from (1, 2): object $0F
	db $89, $31, $0f  ; 9 across from (1, 3): object $0F
	db $86, $64, $0f  ; 6 across from (4, 6): object $0F
	db $89, $51, $12  ; 9 across from (1, 5): object $12
	db $11, $ac  ; (1, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $24, $a6  ; (4, 2): object $A6
	db $26, $a6  ; (6, 2): object $A6
	db $35, $a6  ; (5, 3): object $A6
	db $37, $a6  ; (7, 3): object $A6
	db $32, $a7  ; (2, 3): object $A7
	db $82, $52, $ae  ; 2 across from (2, 5): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $05 of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom05::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $c6, $10, $0d  ; 6 down from (0, 1): object $0D
	db $88, $20, $0f  ; 8 across from (0, 2): object $0F
	db $88, $30, $0f  ; 8 across from (0, 3): object $0F
	db $88, $60, $0f  ; 8 across from (0, 6): object $0F
	db $82, $46, $0f  ; 2 across from (6, 4): object $0F
	db $82, $56, $0f  ; 2 across from (6, 5): object $0F
	db $23, $a6  ; (3, 2): object $A6
	db $26, $a6  ; (6, 2): object $A6
	db $32, $a6  ; (2, 3): object $A6
	db $35, $a6  ; (5, 3): object $A6
	db $44, $a6  ; (4, 4): object $A6
	db $47, $a6  ; (7, 4): object $A6
	db $53, $a6  ; (3, 5): object $A6
	db $56, $a6  ; (6, 5): object $A6
	db $00, $21  ; (0, 0): object $21
	db $70, $22  ; (0, 7): object $22
	db $18, $ac  ; (8, 1): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $83, $50, $12  ; 3 across from (0, 5): object $12
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $06 of indoor group A: 10 objects, room template 0 and floor object $0F; a warp (type 2) to map $00 room $1A at x 40, y 19. Format: see IndoorARoomPointers.
IndoorARoom06::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $c6, $11, $1c  ; 6 down from (1, 1): object $1C
	db $c6, $18, $1c  ; 6 down from (8, 1): object $1C
	db $12, $1f  ; (2, 1): object $1F
	db $17, $1f  ; (7, 1): object $1F
	db $62, $1e  ; (2, 6): object $1E
	db $67, $1e  ; (7, 6): object $1E
	db $e2, $00, $1a, $28, $13  ; warp type 2 to map $00 room $1A, x 40 y 19
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $07 of indoor group A: 36 objects, room template 8 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom07::
	db $04, $8d  ; animated tiles $04, template 8, floor $0D
	db $04, $ec  ; (4, 0): object $EC
	db $74, $f5  ; (4, 7): object $F5
	db $39, $f7  ; (9, 3): object $F7
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $10, $03  ; (0, 1): object $03
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $c3, $17, $24  ; 3 down from (7, 1): object $24
	db $47, $2a  ; (7, 4): object $2A
	db $82, $48, $21  ; 2 across from (8, 4): object $21
	db $08, $17  ; (8, 0): object $17
	db $09, $12  ; (9, 0): object $12
	db $c2, $18, $11  ; 2 down from (8, 1): object $11
	db $38, $15  ; (8, 3): object $15
	db $39, $13  ; (9, 3): object $13
	db $16, $af  ; (6, 1): object $AF
	db $56, $b0  ; (6, 5): object $B0
	db $c3, $26, $01  ; 3 down from (6, 2): object $01
	db $83, $57, $b0  ; 3 across from (7, 5): object $B0
	db $68, $2c  ; (8, 6): object $2C
	db $69, $22  ; (9, 6): object $22
	db $78, $24  ; (8, 7): object $24
	db $79, $03  ; (9, 7): object $03
	db $63, $c0  ; (3, 6): object $C0
	db $66, $c0  ; (6, 6): object $C0
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $02, $25  ; (2, 0): object $25
	db $22, $ae  ; (2, 2): object $AE
	db $35, $ae  ; (5, 3): object $AE
	db $42, $a7  ; (2, 4): object $A7
	db $61, $ac  ; (1, 6): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $08 of indoor group A: 35 objects, room template 7 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom08::
	db $04, $7d  ; animated tiles $04, template 7, floor $0D
	db $69, $f7  ; (9, 6): object $F7
	db $30, $f6  ; (0, 3): object $F6
	db $74, $f5  ; (4, 7): object $F5
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $8a, $00, $12  ; 10 across from (0, 0): object $12
	db $82, $01, $ac  ; 2 across from (1, 0): object $AC
	db $82, $06, $ac  ; 2 across from (6, 0): object $AC
	db $14, $a0  ; (4, 1): object $A0
	db $21, $96  ; (1, 2): object $96
	db $85, $22, $13  ; 5 across from (2, 2): object $13
	db $27, $95  ; (7, 2): object $95
	db $30, $13  ; (0, 3): object $13
	db $31, $14  ; (1, 3): object $14
	db $32, $25  ; (2, 3): object $25
	db $83, $33, $21  ; 3 across from (3, 3): object $21
	db $36, $26  ; (6, 3): object $26
	db $37, $15  ; (7, 3): object $15
	db $82, $38, $13  ; 2 across from (8, 3): object $13
	db $82, $40, $21  ; 2 across from (0, 4): object $21
	db $42, $29  ; (2, 4): object $29
	db $83, $43, $01  ; 3 across from (3, 4): object $01
	db $44, $b0  ; (4, 4): object $B0
	db $46, $2a  ; (6, 4): object $2A
	db $82, $47, $21  ; 2 across from (7, 4): object $21
	db $49, $26  ; (9, 4): object $26
	db $89, $50, $b0  ; 9 across from (0, 5): object $B0
	db $54, $0d  ; (4, 5): object $0D
	db $59, $24  ; (9, 5): object $24
	db $60, $22  ; (0, 6): object $22
	db $61, $2b  ; (1, 6): object $2B
	db $70, $03  ; (0, 7): object $03
	db $71, $23  ; (1, 7): object $23
	db $c2, $19, $0d  ; 2 down from (9, 1): object $0D
	db $c3, $59, $24  ; 3 down from (9, 5): object $24
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $09 of indoor group A: 26 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom09::
	db $00, $0d  ; animated tiles $00, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $76, $f5  ; (6, 7): object $F5
	db $76, $2b  ; (6, 7): object $2B
	db $77, $0d  ; (7, 7): object $0D
	db $78, $2c  ; (8, 7): object $2C
	db $04, $25  ; (4, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $03  ; (9, 0): object $03
	db $83, $00, $12  ; 3 across from (0, 0): object $12
	db $03, $16  ; (3, 0): object $16
	db $c3, $14, $23  ; 3 down from (4, 1): object $23
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $0a, $26  ; (10, 0): object $26
	db $c2, $13, $10  ; 2 down from (3, 1): object $10
	db $82, $30, $13  ; 2 across from (0, 3): object $13
	db $33, $14  ; (3, 3): object $14
	db $40, $25  ; (0, 4): object $25
	db $83, $41, $21  ; 3 across from (1, 4): object $21
	db $44, $29  ; (4, 4): object $29
	db $42, $98  ; (2, 4): object $98
	db $52, $de  ; (2, 5): object $DE
	db $45, $af  ; (5, 4): object $AF
	db $55, $01  ; (5, 5): object $01
	db $65, $b0  ; (5, 6): object $B0
	db $c2, $10, $0d  ; 2 down from (0, 1): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0A of indoor group A: 22 objects, room template 0 and floor object $07. Format: see IndoorARoomPointers.
IndoorARoom0A::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $74, $f5  ; (4, 7): object $F5
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $21, $ac  ; (1, 2): object $AC
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $70, $03  ; (0, 7): object $03
	db $71, $27  ; (1, 7): object $27
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $79, $03  ; (9, 7): object $03
	db $28, $a1  ; (8, 2): object $A1
	db $00, $03  ; (0, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $08, $26  ; (8, 0): object $26
	db $09, $03  ; (9, 0): object $03
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0B of indoor group A: 8 objects, room template 0 and floor object $0D; a warp (type 2) to map $00 room $1B at x 120, y 16. Format: see IndoorARoomPointers.
IndoorARoom0B::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f8  ; (4, 0): object $F8
	db $74, $f5  ; (4, 7): object $F5
	db $33, $ac  ; (3, 3): object $AC
	db $36, $ac  ; (6, 3): object $AC
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $84, $43, $c0  ; 4 across from (3, 4): object $C0
	db $35, $be  ; (5, 3): object $BE
	db $e2, $00, $1b, $78, $10  ; warp type 2 to map $00 room $1B, x 120 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0C of indoor group A: 23 objects, room template 0 and floor object $0F. Format: see IndoorARoomPointers.
IndoorARoom0C::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $39, $42  ; (9, 3): object $42
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $c6, $10, $03  ; 6 down from (0, 1): object $03
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $02, $25  ; (2, 0): object $25
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $13, $01  ; (3, 1): object $01
	db $83, $14, $b0  ; 3 across from (4, 1): object $B0
	db $82, $17, $01  ; 2 across from (7, 1): object $01
	db $c4, $22, $01  ; 4 down from (2, 2): object $01
	db $23, $b0  ; (3, 2): object $B0
	db $82, $27, $b0  ; 2 across from (7, 2): object $B0
	db $53, $af  ; (3, 5): object $AF
	db $82, $57, $af  ; 2 across from (7, 5): object $AF
	db $63, $01  ; (3, 6): object $01
	db $83, $64, $af  ; 3 across from (4, 6): object $AF
	db $82, $67, $01  ; 2 across from (7, 6): object $01
	db $c4, $21, $23  ; 4 down from (1, 2): object $23
	db $61, $27  ; (1, 6): object $27
	db $62, $2b  ; (2, 6): object $2B
	db $72, $27  ; (2, 7): object $27
	db $34, $a0  ; (4, 3): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0D of indoor group A: 21 objects, room template 5 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom0D::
	db $04, $5d  ; animated tiles $04, template 5, floor $0D
	db $30, $41  ; (0, 3): object $41
	db $74, $f5  ; (4, 7): object $F5
	db $04, $f4  ; (4, 0): object $F4
	db $39, $f7  ; (9, 3): object $F7
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $08, $24  ; (8, 0): object $24
	db $09, $03  ; (9, 0): object $03
	db $c2, $13, $c0  ; 2 down from (3, 1): object $C0
	db $c2, $16, $c0  ; 2 down from (6, 1): object $C0
	db $18, $2a  ; (8, 1): object $2A
	db $19, $21  ; (9, 1): object $21
	db $32, $af  ; (2, 3): object $AF
	db $37, $af  ; (7, 3): object $AF
	db $42, $b0  ; (2, 4): object $B0
	db $47, $b0  ; (7, 4): object $B0
	db $51, $af  ; (1, 5): object $AF
	db $61, $01  ; (1, 6): object $01
	db $87, $62, $af  ; 7 across from (2, 6): object $AF
	db $82, $64, $dd  ; 2 across from (4, 6): object $DD
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0E of indoor group A: 23 objects, room template 6 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom0E::
	db $04, $6d  ; animated tiles $04, template 6, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $00, $03  ; (0, 0): object $03
	db $01, $23  ; (1, 0): object $23
	db $10, $21  ; (0, 1): object $21
	db $11, $29  ; (1, 1): object $29
	db $83, $13, $0f  ; 3 across from (3, 1): object $0F
	db $19, $f7  ; (9, 1): object $F7
	db $19, $24  ; (9, 1): object $24
	db $28, $0d  ; (8, 2): object $0D
	db $39, $a6  ; (9, 3): object $A6
	db $c2, $49, $0d  ; 2 down from (9, 4): object $0D
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $24, $a0  ; (4, 2): object $A0
	db $27, $a6  ; (7, 2): object $A6
	db $54, $a6  ; (4, 5): object $A6
	db $57, $a6  ; (7, 5): object $A6
	db $29, $0d  ; (9, 2): object $0D
	db $19, $2a  ; (9, 1): object $2A
	db $69, $2c  ; (9, 6): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $0F of indoor group A: 13 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom0F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $06, $f4  ; (6, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $39, $ef  ; (9, 3): object $EF
	db $74, $fb  ; (4, 7): object $FB
	db $06, $29  ; (6, 0): object $29
	db $07, $0d  ; (7, 0): object $0D
	db $08, $2a  ; (8, 0): object $2A
	db $20, $0d  ; (0, 2): object $0D
	db $84, $30, $a6  ; 4 across from (0, 3): object $A6
	db $86, $23, $a6  ; 6 across from (3, 2): object $A6
	db $c2, $40, $0d  ; 2 down from (0, 4): object $0D
	db $10, $29  ; (0, 1): object $29
	db $60, $2b  ; (0, 6): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $10 of indoor group A: 19 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom10::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $ee  ; (0, 3): object $EE
	db $39, $f7  ; (9, 3): object $F7
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $33, $2c  ; (3, 3): object $2C
	db $34, $22  ; (4, 3): object $22
	db $35, $2b  ; (5, 3): object $2B
	db $43, $2a  ; (3, 4): object $2A
	db $44, $21  ; (4, 4): object $21
	db $45, $29  ; (5, 4): object $29
	db $28, $ae  ; (8, 2): object $AE
	db $58, $ae  ; (8, 5): object $AE
	db $27, $af  ; (7, 2): object $AF
	db $57, $b0  ; (7, 5): object $B0
	db $c2, $37, $01  ; 2 down from (7, 3): object $01
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $11 of indoor group A: 6 objects, room template 0 and floor object $0F. Format: see IndoorARoomPointers.
IndoorARoom11::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $30, $f2  ; (0, 3): object $F2
	db $04, $f0  ; (4, 0): object $F0
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $12 of indoor group A: 31 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom12::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $39, $f3  ; (9, 3): object $F3
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $00, $03  ; (0, 0): object $03
	db $09, $03  ; (9, 0): object $03
	db $70, $03  ; (0, 7): object $03
	db $79, $03  ; (9, 7): object $03
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $71, $27  ; (1, 7): object $27
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $86, $12, $df  ; 6 across from (2, 1): object $DF
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $c4, $21, $df  ; 4 down from (1, 2): object $DF
	db $86, $62, $df  ; 6 across from (2, 6): object $DF
	db $82, $64, $0d  ; 2 across from (4, 6): object $0D
	db $28, $df  ; (8, 2): object $DF
	db $58, $df  ; (8, 5): object $DF
	db $33, $c0  ; (3, 3): object $C0
	db $36, $c0  ; (6, 3): object $C0
	db $43, $c0  ; (3, 4): object $C0
	db $46, $c0  ; (6, 4): object $C0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $13 of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom13::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $23, $af  ; (3, 2): object $AF
	db $26, $af  ; (6, 2): object $AF
	db $33, $01  ; (3, 3): object $01
	db $36, $01  ; (6, 3): object $01
	db $43, $b0  ; (3, 4): object $B0
	db $83, $44, $ae  ; 3 across from (4, 4): object $AE
	db $46, $b0  ; (6, 4): object $B0
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $35, $aa  ; (5, 3): object $AA
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $14 of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom14::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $04, $fa  ; (4, 0): object $FA
	db $20, $f6  ; (0, 2): object $F6
	db $34, $a0  ; (4, 3): object $A0
	db $20, $29  ; (0, 2): object $29
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $11, $01  ; (1, 1): object $01
	db $61, $01  ; (1, 6): object $01
	db $21, $b0  ; (1, 2): object $B0
	db $51, $af  ; (1, 5): object $AF
	db $53, $c0  ; (3, 5): object $C0
	db $56, $c0  ; (6, 5): object $C0
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $84, $43, $0f  ; 4 across from (3, 4): object $0F
	db $13, $ac  ; (3, 1): object $AC
	db $16, $ac  ; (6, 1): object $AC
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $15 of indoor group A: 25 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom15::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $39, $f3  ; (9, 3): object $F3
	db $83, $22, $0f  ; 3 across from (2, 2): object $0F
	db $83, $32, $0f  ; 3 across from (2, 3): object $0F
	db $83, $42, $0f  ; 3 across from (2, 4): object $0F
	db $22, $c0  ; (2, 2): object $C0
	db $24, $c0  ; (4, 2): object $C0
	db $33, $a0  ; (3, 3): object $A0
	db $06, $26  ; (6, 0): object $26
	db $16, $24  ; (6, 1): object $24
	db $26, $2a  ; (6, 2): object $2A
	db $82, $27, $21  ; 2 across from (7, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $83, $17, $03  ; 3 across from (7, 1): object $03
	db $83, $67, $03  ; 3 across from (7, 6): object $03
	db $83, $77, $03  ; 3 across from (7, 7): object $03
	db $56, $2c  ; (6, 5): object $2C
	db $82, $57, $22  ; 2 across from (7, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $66, $24  ; (6, 6): object $24
	db $76, $28  ; (6, 7): object $28
	db $11, $ac  ; (1, 1): object $AC
	db $15, $ac  ; (5, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $65, $ac  ; (5, 6): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $16 of indoor group A: 30 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom16::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $21, $b0  ; (1, 2): object $B0
	db $86, $12, $b0  ; 6 across from (2, 1): object $B0
	db $28, $b0  ; (8, 2): object $B0
	db $51, $af  ; (1, 5): object $AF
	db $86, $62, $af  ; 6 across from (2, 6): object $AF
	db $58, $af  ; (8, 5): object $AF
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $00, $03  ; (0, 0): object $03
	db $09, $03  ; (9, 0): object $03
	db $70, $03  ; (0, 7): object $03
	db $79, $03  ; (9, 7): object $03
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $71, $27  ; (1, 7): object $27
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $32, $0f  ; (2, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $17 of indoor group A: 22 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $D3 at x 104, y 34. Format: see IndoorARoomPointers.
IndoorARoom17::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $20, $29  ; (0, 2): object $29
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $c6, $11, $0f  ; 6 down from (1, 1): object $0F
	db $c6, $18, $0f  ; 6 down from (8, 1): object $0F
	db $88, $11, $0f  ; 8 across from (1, 1): object $0F
	db $62, $0f  ; (2, 6): object $0F
	db $67, $0f  ; (7, 6): object $0F
	db $c3, $22, $c0  ; 3 down from (2, 2): object $C0
	db $c3, $27, $c0  ; 3 down from (7, 2): object $C0
	db $23, $c0  ; (3, 2): object $C0
	db $26, $c0  ; (6, 2): object $C0
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $d3, $68, $22  ; warp type 0 to map $00 room $D3, x 104 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $18 of indoor group A: 17 objects, room template 9 and floor object $04; a warp (type 1) to map $00 room $01 at x 72, y 96. Format: see IndoorARoomPointers.
IndoorARoom18::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c7, $02, $63  ; 7 down from (2, 0): object $63
	db $c3, $10, $6c  ; 3 down from (0, 1): object $6C
	db $83, $16, $6b  ; 3 across from (6, 1): object $6B
	db $17, $69  ; (7, 1): object $69
	db $83, $26, $69  ; 3 across from (6, 2): object $69
	db $27, $82  ; (7, 2): object $82
	db $8a, $40, $6d  ; 10 across from (0, 4): object $6D
	db $42, $62  ; (2, 4): object $62
	db $45, $04  ; (5, 4): object $04
	db $48, $62  ; (8, 4): object $62
	db $c3, $50, $54  ; 3 down from (0, 5): object $54
	db $c2, $51, $57  ; 2 down from (1, 5): object $57
	db $c2, $58, $63  ; 2 down from (8, 5): object $63
	db $c2, $59, $6c  ; 2 down from (9, 5): object $6C
	db $71, $54  ; (1, 7): object $54
	db $88, $72, $5b  ; 8 across from (2, 7): object $5B
	db $e1, $00, $01, $48, $60  ; warp type 1 to map $00 room $01, x 72 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $19 of indoor group A: 18 objects, room template 9 and floor object $04; a warp (type 1) to map $00 room $03 at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoom19::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c7, $07, $63  ; 7 down from (7, 0): object $63
	db $83, $11, $6b  ; 3 across from (1, 1): object $6B
	db $12, $69  ; (2, 1): object $69
	db $83, $21, $69  ; 3 across from (1, 2): object $69
	db $22, $82  ; (2, 2): object $82
	db $c2, $19, $6c  ; 2 down from (9, 1): object $6C
	db $84, $36, $6d  ; 4 across from (6, 3): object $6D
	db $37, $62  ; (7, 3): object $62
	db $40, $6d  ; (0, 4): object $6D
	db $41, $62  ; (1, 4): object $62
	db $82, $43, $6d  ; 2 across from (3, 4): object $6D
	db $c3, $48, $51  ; 3 down from (8, 4): object $51
	db $c3, $49, $54  ; 3 down from (9, 4): object $54
	db $c2, $50, $6c  ; 2 down from (0, 5): object $6C
	db $c2, $51, $63  ; 2 down from (1, 5): object $63
	db $88, $70, $5b  ; 8 across from (0, 7): object $5B
	db $82, $78, $54  ; 2 across from (8, 7): object $54
	db $e1, $00, $03, $88, $20  ; warp type 1 to map $00 room $03, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1A of indoor group A: 22 objects, room template 9 and floor object $04. Format: see IndoorARoomPointers.
IndoorARoom1A::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $c7, $00, $6c  ; 7 down from (0, 0): object $6C
	db $82, $30, $6d  ; 2 across from (0, 3): object $6D
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $82, $61, $75  ; 2 across from (1, 6): object $75
	db $64, $75  ; (4, 6): object $75
	db $83, $32, $6b  ; 3 across from (2, 3): object $6B
	db $33, $69  ; (3, 3): object $69
	db $83, $42, $69  ; 3 across from (2, 4): object $69
	db $43, $82  ; (3, 4): object $82
	db $83, $36, $6b  ; 3 across from (6, 3): object $6B
	db $37, $69  ; (7, 3): object $69
	db $83, $46, $69  ; 3 across from (6, 4): object $69
	db $47, $82  ; (7, 4): object $82
	db $02, $4d  ; (2, 0): object $4D
	db $08, $4d  ; (8, 0): object $4D
	db $c2, $05, $4d  ; 2 down from (5, 0): object $4D
	db $12, $78  ; (2, 1): object $78
	db $18, $78  ; (8, 1): object $78
	db $25, $78  ; (5, 2): object $78
	db $22, $79  ; (2, 2): object $79
	db $28, $79  ; (8, 2): object $79
	db $35, $79  ; (5, 3): object $79
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1B of indoor group A: 14 objects, room template 9 and floor object $04; a warp (type 1) to map $00 room $0B at x 88, y 64. Format: see IndoorARoomPointers.
IndoorARoom1B::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $83, $31, $6b  ; 3 across from (1, 3): object $6B
	db $32, $69  ; (2, 3): object $69
	db $83, $41, $69  ; 3 across from (1, 4): object $69
	db $42, $82  ; (2, 4): object $82
	db $85, $05, $6d  ; 5 across from (5, 0): object $6D
	db $c2, $15, $6c  ; 2 down from (5, 1): object $6C
	db $c6, $19, $6c  ; 6 down from (9, 1): object $6C
	db $85, $35, $6d  ; 5 across from (5, 3): object $6D
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $c7, $07, $63  ; 7 down from (7, 0): object $63
	db $64, $75  ; (4, 6): object $75
	db $66, $75  ; (6, 6): object $75
	db $68, $75  ; (8, 6): object $75
	db $37, $62  ; (7, 3): object $62
	db $e1, $00, $0b, $58, $40  ; warp type 1 to map $00 room $0B, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1C of indoor group A: 5 objects, room template 9 and floor object $03. Format: see IndoorARoomPointers.
IndoorARoom1C::
	db $04, $93  ; animated tiles $04, template 9, floor $03
	db $03, $f4  ; (3, 0): object $F4
	db $73, $f5  ; (3, 7): object $F5
	db $c8, $03, $23  ; 8 down from (3, 0): object $23
	db $c8, $04, $0d  ; 8 down from (4, 0): object $0D
	db $c8, $05, $24  ; 8 down from (5, 0): object $24
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1D of indoor group A: 19 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom1D::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $73, $f5  ; (3, 7): object $F5
	db $73, $2b  ; (3, 7): object $2B
	db $74, $0d  ; (4, 7): object $0D
	db $75, $2c  ; (5, 7): object $2C
	db $83, $13, $0f  ; 3 across from (3, 1): object $0F
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $12, $ac  ; (2, 1): object $AC
	db $16, $ac  ; (6, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $24, $a0  ; (4, 2): object $A0
	db $c3, $11, $01  ; 3 down from (1, 1): object $01
	db $c3, $17, $01  ; 3 down from (7, 1): object $01
	db $c3, $18, $01  ; 3 down from (8, 1): object $01
	db $41, $b0  ; (1, 4): object $B0
	db $82, $47, $b0  ; 2 across from (7, 4): object $B0
	db $85, $42, $ae  ; 5 across from (2, 4): object $AE
	db $44, $0d  ; (4, 4): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $1E of indoor group A: 17 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $72 at x 40, y 112. Format: see IndoorARoomPointers.
IndoorARoom1E::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c3, $01, $62  ; 3 down from (1, 0): object $62
	db $c2, $10, $6c  ; 2 down from (0, 1): object $6C
	db $82, $15, $71  ; 2 across from (5, 1): object $71
	db $83, $17, $6b  ; 3 across from (7, 1): object $6B
	db $18, $69  ; (8, 1): object $69
	db $83, $27, $69  ; 3 across from (7, 2): object $69
	db $28, $82  ; (8, 2): object $82
	db $83, $30, $6d  ; 3 across from (0, 3): object $6D
	db $c3, $40, $54  ; 3 down from (0, 4): object $54
	db $c3, $41, $57  ; 3 down from (1, 4): object $57
	db $43, $64  ; (3, 4): object $64
	db $53, $65  ; (3, 5): object $65
	db $82, $48, $6d  ; 2 across from (8, 4): object $6D
	db $82, $70, $54  ; 2 across from (0, 7): object $54
	db $88, $72, $5b  ; 8 across from (2, 7): object $5B
	db $23, $6d  ; (3, 2): object $6D
	db $e1, $03, $72, $28, $70  ; warp type 1 to map $03 room $72, x 40 y 112
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $1F of indoor group A: 14 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $67 at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoom1F::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c7, $08, $63  ; 7 down from (8, 0): object $63
	db $83, $11, $6b  ; 3 across from (1, 1): object $6B
	db $12, $69  ; (2, 1): object $69
	db $83, $21, $69  ; 3 across from (1, 2): object $69
	db $22, $82  ; (2, 2): object $82
	db $c3, $13, $6c  ; 3 down from (3, 1): object $6C
	db $c3, $16, $6c  ; 3 down from (6, 1): object $6C
	db $c6, $19, $51  ; 6 down from (9, 1): object $51
	db $82, $40, $6d  ; 2 across from (0, 4): object $6D
	db $43, $6d  ; (3, 4): object $6D
	db $46, $6d  ; (6, 4): object $6D
	db $89, $70, $5b  ; 9 across from (0, 7): object $5B
	db $79, $54  ; (9, 7): object $54
	db $e1, $03, $67, $88, $20  ; warp type 1 to map $03 room $67, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $20 of indoor group A: 26 objects, room template 0 and floor object $07. Format: see IndoorARoomPointers.
IndoorARoom20::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $39, $ef  ; (9, 3): object $EF
	db $c8, $00, $03  ; 8 down from (0, 0): object $03
	db $08, $21  ; (8, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $61, $03  ; (1, 6): object $03
	db $19, $24  ; (9, 1): object $24
	db $82, $71, $03  ; 2 across from (1, 7): object $03
	db $69, $03  ; (9, 6): object $03
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $01, $25  ; (1, 0): object $25
	db $11, $23  ; (1, 1): object $23
	db $02, $21  ; (2, 0): object $21
	db $51, $27  ; (1, 5): object $27
	db $52, $2b  ; (2, 5): object $2B
	db $62, $27  ; (2, 6): object $27
	db $63, $2b  ; (3, 6): object $2B
	db $73, $27  ; (3, 7): object $27
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $77, $28  ; (7, 7): object $28
	db $22, $ab  ; (2, 2): object $AB
	db $65, $ab  ; (5, 6): object $AB
	db $c3, $21, $23  ; 3 down from (1, 2): object $23
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $21 of indoor group A: 38 objects, room template 2 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom21::
	db $04, $2d  ; animated tiles $04, template 2, floor $0D
	db $30, $ee  ; (0, 3): object $EE
	db $39, $f7  ; (9, 3): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $00, $03  ; (0, 0): object $03
	db $49, $03  ; (9, 4): object $03
	db $70, $03  ; (0, 7): object $03
	db $01, $25  ; (1, 0): object $25
	db $05, $c7  ; (5, 0): object $C7
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $71, $27  ; (1, 7): object $27
	db $12, $01  ; (2, 1): object $01
	db $13, $b0  ; (3, 1): object $B0
	db $21, $b0  ; (1, 2): object $B0
	db $22, $b0  ; (2, 2): object $B0
	db $83, $16, $20  ; 3 across from (6, 1): object $20
	db $83, $26, $20  ; 3 across from (6, 2): object $20
	db $27, $a0  ; (7, 2): object $A0
	db $82, $23, $20  ; 2 across from (3, 2): object $20
	db $82, $56, $20  ; 2 across from (6, 5): object $20
	db $82, $66, $20  ; 2 across from (6, 6): object $20
	db $82, $46, $ae  ; 2 across from (6, 4): object $AE
	db $51, $af  ; (1, 5): object $AF
	db $52, $af  ; (2, 5): object $AF
	db $62, $01  ; (2, 6): object $01
	db $63, $af  ; (3, 6): object $AF
	db $38, $2c  ; (8, 3): object $2C
	db $39, $c8  ; (9, 3): object $C8
	db $48, $24  ; (8, 4): object $24
	db $58, $2a  ; (8, 5): object $2A
	db $59, $c7  ; (9, 5): object $C7
	db $73, $2b  ; (3, 7): object $2B
	db $74, $0d  ; (4, 7): object $0D
	db $75, $2c  ; (5, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $22 of indoor group A: 32 objects, room template 2 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom22::
	db $04, $2d  ; animated tiles $04, template 2, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $c6, $10, $0d  ; 6 down from (0, 1): object $0D
	db $88, $11, $db  ; 8 across from (1, 1): object $DB
	db $88, $21, $db  ; 8 across from (1, 2): object $DB
	db $88, $31, $db  ; 8 across from (1, 3): object $DB
	db $00, $21  ; (0, 0): object $21
	db $70, $22  ; (0, 7): object $22
	db $04, $03  ; (4, 0): object $03
	db $03, $26  ; (3, 0): object $26
	db $05, $25  ; (5, 0): object $25
	db $13, $2a  ; (3, 1): object $2A
	db $15, $29  ; (5, 1): object $29
	db $14, $c7  ; (4, 1): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $23, $a6  ; (3, 2): object $A6
	db $25, $a6  ; (5, 2): object $A6
	db $27, $a0  ; (7, 2): object $A0
	db $34, $dc  ; (4, 3): object $DC
	db $30, $2b  ; (0, 3): object $2B
	db $40, $23  ; (0, 4): object $23
	db $50, $29  ; (0, 5): object $29
	db $88, $41, $ae  ; 8 across from (1, 4): object $AE
	db $39, $2c  ; (9, 3): object $2C
	db $49, $24  ; (9, 4): object $24
	db $59, $2a  ; (9, 5): object $2A
	db $88, $51, $dc  ; 8 across from (1, 5): object $DC
	db $84, $53, $20  ; 4 across from (3, 5): object $20
	db $84, $63, $dc  ; 4 across from (3, 6): object $DC
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $24, $0d  ; (4, 2): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $23 of indoor group A: 30 objects, room template 4 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom23::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $59, $f7  ; (9, 5): object $F7
	db $c6, $19, $0d  ; 6 down from (9, 1): object $0D
	db $09, $21  ; (9, 0): object $21
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $c2, $11, $dc  ; 2 down from (1, 1): object $DC
	db $15, $ae  ; (5, 1): object $AE
	db $32, $af  ; (2, 3): object $AF
	db $87, $33, $af  ; 7 across from (3, 3): object $AF
	db $34, $0d  ; (4, 3): object $0D
	db $37, $0d  ; (7, 3): object $0D
	db $87, $42, $b0  ; 7 across from (2, 4): object $B0
	db $44, $ae  ; (4, 4): object $AE
	db $47, $ae  ; (7, 4): object $AE
	db $30, $c8  ; (0, 3): object $C8
	db $31, $2b  ; (1, 3): object $2B
	db $40, $03  ; (0, 4): object $03
	db $41, $23  ; (1, 4): object $23
	db $50, $c7  ; (0, 5): object $C7
	db $51, $29  ; (1, 5): object $29
	db $84, $52, $dc  ; 4 across from (2, 5): object $DC
	db $82, $56, $db  ; 2 across from (6, 5): object $DB
	db $82, $66, $db  ; 2 across from (6, 6): object $DB
	db $49, $2c  ; (9, 4): object $2C
	db $59, $2a  ; (9, 5): object $2A
	db $69, $0d  ; (9, 6): object $0D
	db $79, $22  ; (9, 7): object $22
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $24 of indoor group A: 21 objects, room template 4 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom24::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $39, $ef  ; (9, 3): object $EF
	db $50, $f6  ; (0, 5): object $F6
	db $77, $f5  ; (7, 7): object $F5
	db $04, $c7  ; (4, 0): object $C7
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $74, $c8  ; (4, 7): object $C8
	db $83, $30, $af  ; 3 across from (0, 3): object $AF
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $83, $43, $0f  ; 3 across from (3, 4): object $0F
	db $40, $2b  ; (0, 4): object $2B
	db $82, $41, $a6  ; 2 across from (1, 4): object $A6
	db $83, $53, $a6  ; 3 across from (3, 5): object $A6
	db $c4, $26, $a6  ; 4 down from (6, 2): object $A6
	db $50, $29  ; (0, 5): object $29
	db $60, $0d  ; (0, 6): object $0D
	db $70, $22  ; (0, 7): object $22
	db $76, $2b  ; (6, 7): object $2B
	db $77, $0d  ; (7, 7): object $0D
	db $78, $2c  ; (8, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $25 of indoor group A: 13 objects, room template 0 and floor object $0D; a warp (type 2) to map $01 room $3B at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom25::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $ee  ; (0, 3): object $EE
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $83, $11, $20  ; 3 across from (1, 1): object $20
	db $83, $21, $20  ; 3 across from (1, 2): object $20
	db $83, $51, $20  ; 3 across from (1, 5): object $20
	db $83, $61, $20  ; 3 across from (1, 6): object $20
	db $c2, $14, $20  ; 2 down from (4, 1): object $20
	db $c2, $54, $20  ; 2 down from (4, 5): object $20
	db $c4, $25, $20  ; 4 down from (5, 2): object $20
	db $18, $bf  ; (8, 1): object $BF
	db $e2, $01, $3b, $88, $10  ; warp type 2 to map $01 room $3B, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $26 of indoor group A: 28 objects, room template 0 and floor object $0D; a warp (type 1) to map $01 room $36 at x 80, y 124. Format: see IndoorARoomPointers.
IndoorARoom26::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $77, $f5  ; (7, 7): object $F5
	db $11, $ac  ; (1, 1): object $AC
	db $16, $ac  ; (6, 1): object $AC
	db $38, $ac  ; (8, 3): object $AC
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $82, $18, $03  ; 2 across from (8, 1): object $03
	db $17, $24  ; (7, 1): object $24
	db $27, $2a  ; (7, 2): object $2A
	db $28, $21  ; (8, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $22, $a0  ; (2, 2): object $A0
	db $23, $ae  ; (3, 2): object $AE
	db $34, $ae  ; (4, 3): object $AE
	db $45, $ae  ; (5, 4): object $AE
	db $56, $ae  ; (6, 5): object $AE
	db $41, $af  ; (1, 4): object $AF
	db $52, $af  ; (2, 5): object $AF
	db $51, $b0  ; (1, 5): object $B0
	db $62, $01  ; (2, 6): object $01
	db $63, $af  ; (3, 6): object $AF
	db $03, $29  ; (3, 0): object $29
	db $04, $0d  ; (4, 0): object $0D
	db $05, $2a  ; (5, 0): object $2A
	db $76, $2b  ; (6, 7): object $2B
	db $77, $0d  ; (7, 7): object $0D
	db $78, $2c  ; (8, 7): object $2C
	db $e1, $01, $36, $50, $7c  ; warp type 1 to map $01 room $36, x 80 y 124
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $27 of indoor group A: 15 objects, room template 0 and floor object $0D; a warp (type 2) to map $01 room $3D at x 136, y 128. Format: see IndoorARoomPointers.
IndoorARoom27::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $06, $29  ; (6, 0): object $29
	db $07, $0d  ; (7, 0): object $0D
	db $08, $2a  ; (8, 0): object $2A
	db $82, $12, $20  ; 2 across from (2, 1): object $20
	db $22, $20  ; (2, 2): object $20
	db $82, $44, $a7  ; 2 across from (4, 4): object $A7
	db $c2, $53, $a6  ; 2 down from (3, 5): object $A6
	db $c2, $56, $a6  ; 2 down from (6, 5): object $A6
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $82, $54, $07  ; 2 across from (4, 5): object $07
	db $82, $64, $07  ; 2 across from (4, 6): object $07
	db $28, $a1  ; (8, 2): object $A1
	db $11, $cb  ; (1, 1): object $CB
	db $e2, $01, $3d, $88, $80  ; warp type 2 to map $01 room $3D, x 136 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $28 of indoor group A: 19 objects, room template 0 and floor object $0F. Format: see IndoorARoomPointers.
IndoorARoom28::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $59, $f3  ; (9, 5): object $F3
	db $74, $fb  ; (4, 7): object $FB
	db $00, $03  ; (0, 0): object $03
	db $09, $03  ; (9, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $08, $26  ; (8, 0): object $26
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $86, $12, $df  ; 6 across from (2, 1): object $DF
	db $12, $df  ; (2, 1): object $DF
	db $17, $df  ; (7, 1): object $DF
	db $41, $df  ; (1, 4): object $DF
	db $48, $df  ; (8, 4): object $DF
	db $86, $62, $df  ; 6 across from (2, 6): object $DF
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
	db $c2, $21, $df  ; 2 down from (1, 2): object $DF
	db $c2, $28, $df  ; 2 down from (8, 2): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $29 of indoor group A: 21 objects, room template 0 and floor object $0D; a warp (type 2) to map $01 room $3C at x 24, y 128. Format: see IndoorARoomPointers.
IndoorARoom29::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $50, $f6  ; (0, 5): object $F6
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $63, $af  ; (3, 6): object $AF
	db $66, $af  ; (6, 6): object $AF
	db $38, $ae  ; (8, 3): object $AE
	db $13, $b0  ; (3, 1): object $B0
	db $16, $b0  ; (6, 1): object $B0
	db $22, $c0  ; (2, 2): object $C0
	db $84, $23, $20  ; 4 across from (3, 2): object $20
	db $27, $c0  ; (7, 2): object $C0
	db $c2, $32, $20  ; 2 down from (2, 3): object $20
	db $c2, $37, $a6  ; 2 down from (7, 3): object $A6
	db $52, $c0  ; (2, 5): object $C0
	db $84, $53, $a6  ; 4 across from (3, 5): object $A6
	db $57, $c0  ; (7, 5): object $C0
	db $06, $29  ; (6, 0): object $29
	db $44, $cb  ; (4, 4): object $CB
	db $e2, $01, $3c, $18, $80  ; warp type 2 to map $01 room $3C, x 24 y 128
	db $07, $0d  ; (7, 0): object $0D
	db $08, $2a  ; (8, 0): object $2A
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2A of indoor group A: 24 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $24 at x 56, y 34. Format: see IndoorARoomPointers.
IndoorARoom2A::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $49, $f3  ; (9, 4): object $F3
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
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
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $e0, $00, $24, $38, $22  ; warp type 0 to map $00 room $24, x 56 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2B of indoor group A: 16 objects, room template 0 and floor object $0F. Format: see IndoorARoomPointers.
IndoorARoom2B::
	db $04, $0f  ; animated tiles $04, template 0, floor $0F
	db $40, $f2  ; (0, 4): object $F2
	db $74, $f1  ; (4, 7): object $F1
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $19, $26  ; (9, 1): object $26
	db $11, $c7  ; (1, 1): object $C7
	db $18, $c7  ; (8, 1): object $C7
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $12, $29  ; (2, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $33, $ac  ; (3, 3): object $AC
	db $36, $ac  ; (6, 3): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2C of indoor group A: 28 objects, room template 0 and floor object $07; a warp (type 2) to map $01 room $3E at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom2C::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $04, $f4  ; (4, 0): object $F4
	db $04, $fa  ; (4, 0): object $FA
	db $09, $03  ; (9, 0): object $03
	db $79, $03  ; (9, 7): object $03
	db $18, $2a  ; (8, 1): object $2A
	db $08, $26  ; (8, 0): object $26
	db $19, $26  ; (9, 1): object $26
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $09, $03  ; (9, 0): object $03
	db $32, $af  ; (2, 3): object $AF
	db $85, $23, $af  ; 5 across from (3, 2): object $AF
	db $82, $28, $af  ; 2 across from (8, 2): object $AF
	db $42, $b0  ; (2, 4): object $B0
	db $53, $b0  ; (3, 5): object $B0
	db $84, $56, $b0  ; 4 across from (6, 5): object $B0
	db $82, $54, $ae  ; 2 across from (4, 5): object $AE
	db $c2, $33, $01  ; 2 down from (3, 3): object $01
	db $c2, $36, $01  ; 2 down from (6, 3): object $01
	db $c2, $37, $01  ; 2 down from (7, 3): object $01
	db $82, $38, $01  ; 2 across from (8, 3): object $01
	db $82, $48, $01  ; 2 across from (8, 4): object $01
	db $c4, $29, $24  ; 4 down from (9, 2): object $24
	db $11, $ab  ; (1, 1): object $AB
	db $61, $ab  ; (1, 6): object $AB
	db $82, $24, $ae  ; 2 across from (4, 2): object $AE
	db $67, $be  ; (7, 6): object $BE
	db $e2, $01, $3e, $18, $10  ; warp type 2 to map $01 room $3E, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2D of indoor group A: 28 objects, room template 0 and floor object $0D; a warp (type 2) to map $01 room $3A at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom2D::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $c7  ; (3, 0): object $C7
	db $04, $f8  ; (4, 0): object $F8
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $13, $af  ; (3, 1): object $AF
	db $16, $af  ; (6, 1): object $AF
	db $53, $b0  ; (3, 5): object $B0
	db $56, $b0  ; (6, 5): object $B0
	db $c3, $23, $01  ; 3 down from (3, 2): object $01
	db $c3, $26, $01  ; 3 down from (6, 2): object $01
	db $c4, $14, $11  ; 4 down from (4, 1): object $11
	db $c4, $15, $10  ; 4 down from (5, 1): object $10
	db $82, $24, $ae  ; 2 across from (4, 2): object $AE
	db $82, $54, $ae  ; 2 across from (4, 5): object $AE
	db $28, $2c  ; (8, 2): object $2C
	db $29, $28  ; (9, 2): object $28
	db $c4, $38, $24  ; 4 down from (8, 3): object $24
	db $78, $28  ; (8, 7): object $28
	db $c5, $39, $03  ; 5 down from (9, 3): object $03
	db $00, $25  ; (0, 0): object $25
	db $10, $23  ; (0, 1): object $23
	db $20, $27  ; (0, 2): object $27
	db $21, $2b  ; (1, 2): object $2B
	db $c4, $31, $23  ; 4 down from (1, 3): object $23
	db $c5, $30, $03  ; 5 down from (0, 3): object $03
	db $71, $27  ; (1, 7): object $27
	db $18, $be  ; (8, 1): object $BE
	db $e2, $01, $3a, $18, $10  ; warp type 2 to map $01 room $3A, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2E of indoor group A: 25 objects, room template 0 and floor object $07. Format: see IndoorARoomPointers.
IndoorARoom2E::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $74, $f1  ; (4, 7): object $F1
	db $8a, $00, $03  ; 10 across from (0, 0): object $03
	db $8a, $10, $03  ; 10 across from (0, 1): object $03
	db $02, $25  ; (2, 0): object $25
	db $12, $23  ; (2, 1): object $23
	db $84, $03, $21  ; 4 across from (3, 0): object $21
	db $07, $26  ; (7, 0): object $26
	db $17, $24  ; (7, 1): object $24
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $20, $25  ; (0, 2): object $25
	db $21, $21  ; (1, 2): object $21
	db $22, $29  ; (2, 2): object $29
	db $24, $a0  ; (4, 2): object $A0
	db $27, $2a  ; (7, 2): object $2A
	db $28, $21  ; (8, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $82, $41, $af  ; 2 across from (1, 4): object $AF
	db $84, $43, $ae  ; 4 across from (3, 4): object $AE
	db $82, $47, $af  ; 2 across from (7, 4): object $AF
	db $82, $51, $b0  ; 2 across from (1, 5): object $B0
	db $82, $57, $b0  ; 2 across from (7, 5): object $B0
	db $53, $ab  ; (3, 5): object $AB
	db $56, $ab  ; (6, 5): object $AB
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $2F of indoor group A: 15 objects, room template 0 and floor object $0D; a warp (type 2) to map $01 room $3F at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom2F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $77, $ed  ; (7, 7): object $ED
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $84, $13, $20  ; 4 across from (3, 1): object $20
	db $82, $24, $20  ; 2 across from (4, 2): object $20
	db $c2, $31, $20  ; 2 down from (1, 3): object $20
	db $c2, $38, $20  ; 2 down from (8, 3): object $20
	db $82, $54, $20  ; 2 across from (4, 5): object $20
	db $84, $63, $20  ; 4 across from (3, 6): object $20
	db $82, $34, $0f  ; 2 across from (4, 3): object $0F
	db $33, $a7  ; (3, 3): object $A7
	db $36, $a7  ; (6, 3): object $A7
	db $18, $bf  ; (8, 1): object $BF
	db $e2, $01, $3f, $88, $10  ; warp type 2 to map $01 room $3F, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $30 of indoor group A: 4 objects, room template 0 and floor object $07. Format: see IndoorARoomPointers.
IndoorARoom30::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $04, $f0  ; (4, 0): object $F0
	db $39, $ef  ; (9, 3): object $EF
	db $53, $ab  ; (3, 5): object $AB
	db $56, $ab  ; (6, 5): object $AB
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $31 of indoor group A: 37 objects, room template 0 and floor object $07. Format: see IndoorARoomPointers.
IndoorARoom31::
	db $04, $07  ; animated tiles $04, template 0, floor $07
	db $30, $ee  ; (0, 3): object $EE
	db $39, $f3  ; (9, 3): object $F3
	db $74, $f5  ; (4, 7): object $F5
	db $c2, $00, $03  ; 2 down from (0, 0): object $03
	db $c2, $09, $03  ; 2 down from (9, 0): object $03
	db $c2, $60, $03  ; 2 down from (0, 6): object $03
	db $c2, $69, $03  ; 2 down from (9, 6): object $03
	db $01, $25  ; (1, 0): object $25
	db $11, $23  ; (1, 1): object $23
	db $21, $29  ; (1, 2): object $29
	db $20, $25  ; (0, 2): object $25
	db $08, $26  ; (8, 0): object $26
	db $18, $24  ; (8, 1): object $24
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $61, $23  ; (1, 6): object $23
	db $71, $27  ; (1, 7): object $27
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $68, $24  ; (8, 6): object $24
	db $78, $28  ; (8, 7): object $28
	db $23, $2c  ; (3, 2): object $2C
	db $82, $24, $22  ; 2 across from (4, 2): object $22
	db $26, $2b  ; (6, 2): object $2B
	db $c2, $33, $24  ; 2 down from (3, 3): object $24
	db $c2, $36, $23  ; 2 down from (6, 3): object $23
	db $53, $2a  ; (3, 5): object $2A
	db $56, $29  ; (6, 5): object $29
	db $82, $54, $97  ; 2 across from (4, 5): object $97
	db $34, $ab  ; (4, 3): object $AB
	db $35, $ab  ; (5, 3): object $AB
	db $82, $44, $0f  ; 2 across from (4, 4): object $0F
	db $73, $2b  ; (3, 7): object $2B
	db $76, $2c  ; (6, 7): object $2C
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $32 of indoor group A: 38 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom32::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $74, $ed  ; (4, 7): object $ED
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $82, $10, $03  ; 2 across from (0, 1): object $03
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $82, $18, $03  ; 2 across from (8, 1): object $03
	db $82, $60, $03  ; 2 across from (0, 6): object $03
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $82, $68, $03  ; 2 across from (8, 6): object $03
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $c2, $37, $db  ; 2 down from (7, 3): object $DB
	db $02, $25  ; (2, 0): object $25
	db $12, $23  ; (2, 1): object $23
	db $22, $29  ; (2, 2): object $29
	db $21, $21  ; (1, 2): object $21
	db $20, $25  ; (0, 2): object $25
	db $50, $27  ; (0, 5): object $27
	db $51, $22  ; (1, 5): object $22
	db $52, $2b  ; (2, 5): object $2B
	db $62, $23  ; (2, 6): object $23
	db $72, $27  ; (2, 7): object $27
	db $07, $26  ; (7, 0): object $26
	db $17, $24  ; (7, 1): object $24
	db $27, $2a  ; (7, 2): object $2A
	db $28, $21  ; (8, 2): object $21
	db $29, $21  ; (9, 2): object $21
	db $59, $22  ; (9, 5): object $22
	db $58, $22  ; (8, 5): object $22
	db $57, $2c  ; (7, 5): object $2C
	db $67, $24  ; (7, 6): object $24
	db $77, $28  ; (7, 7): object $28
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $32, $0f  ; (2, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $33 of indoor group A: 29 objects, room template 3 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom33::
	db $04, $3d  ; animated tiles $04, template 3, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $c2, $60, $03  ; 2 down from (0, 6): object $03
	db $c2, $69, $03  ; 2 down from (9, 6): object $03
	db $c2, $00, $03  ; 2 down from (0, 0): object $03
	db $c2, $09, $03  ; 2 down from (9, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $11, $23  ; (1, 1): object $23
	db $18, $24  ; (8, 1): object $24
	db $20, $21  ; (0, 2): object $21
	db $21, $29  ; (1, 2): object $29
	db $28, $2a  ; (8, 2): object $2A
	db $29, $21  ; (9, 2): object $21
	db $50, $22  ; (0, 5): object $22
	db $51, $2b  ; (1, 5): object $2B
	db $c2, $61, $23  ; 2 down from (1, 6): object $23
	db $58, $2c  ; (8, 5): object $2C
	db $59, $22  ; (9, 5): object $22
	db $c2, $68, $24  ; 2 down from (8, 6): object $24
	db $86, $62, $dc  ; 6 across from (2, 6): object $DC
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $23, $c0  ; (3, 2): object $C0
	db $26, $c0  ; (6, 2): object $C0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $34 of indoor group A: 32 objects, room template 4 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom34::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $76, $c8  ; (6, 7): object $C8
	db $74, $db  ; (4, 7): object $DB
	db $74, $dc  ; (4, 7): object $DC
	db $39, $f7  ; (9, 3): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $30, $f6  ; (0, 3): object $F6
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $19, $2a  ; (9, 1): object $2A
	db $69, $2c  ; (9, 6): object $2C
	db $c4, $29, $0d  ; 4 down from (9, 2): object $0D
	db $83, $00, $03  ; 3 across from (0, 0): object $03
	db $83, $10, $03  ; 3 across from (0, 1): object $03
	db $83, $60, $03  ; 3 across from (0, 6): object $03
	db $83, $70, $03  ; 3 across from (0, 7): object $03
	db $03, $25  ; (3, 0): object $25
	db $13, $23  ; (3, 1): object $23
	db $83, $20, $21  ; 3 across from (0, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $83, $50, $22  ; 3 across from (0, 5): object $22
	db $53, $2b  ; (3, 5): object $2B
	db $63, $23  ; (3, 6): object $23
	db $73, $27  ; (3, 7): object $27
	db $32, $0f  ; (2, 3): object $0F
	db $c2, $33, $a6  ; 2 down from (3, 3): object $A6
	db $82, $14, $20  ; 2 across from (4, 1): object $20
	db $82, $67, $20  ; 2 across from (7, 6): object $20
	db $24, $20  ; (4, 2): object $20
	db $58, $20  ; (8, 5): object $20
	db $67, $20  ; (7, 6): object $20
	db $73, $23  ; (3, 7): object $23
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $35 of indoor group A: 23 objects, room template 4 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom35::
	db $04, $4d  ; animated tiles $04, template 4, floor $0D
	db $07, $ec  ; (7, 0): object $EC
	db $30, $f6  ; (0, 3): object $F6
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $00, $03  ; (0, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $10, $21  ; (0, 1): object $21
	db $11, $29  ; (1, 1): object $29
	db $60, $22  ; (0, 6): object $22
	db $70, $03  ; (0, 7): object $03
	db $61, $2b  ; (1, 6): object $2B
	db $71, $27  ; (1, 7): object $27
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $84, $43, $0f  ; 4 across from (3, 4): object $0F
	db $84, $53, $0f  ; 4 across from (3, 5): object $0F
	db $82, $34, $a6  ; 2 across from (4, 3): object $A6
	db $82, $44, $a6  ; 2 across from (4, 4): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $36 of indoor group A: 32 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $24 at x 56, y 34. Format: see IndoorARoomPointers.
IndoorARoom36::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $82, $60, $03  ; 2 across from (0, 6): object $03
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $82, $68, $03  ; 2 across from (8, 6): object $03
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $30, $c9  ; (0, 3): object $C9
	db $39, $ca  ; (9, 3): object $CA
	db $50, $27  ; (0, 5): object $27
	db $72, $27  ; (2, 7): object $27
	db $51, $22  ; (1, 5): object $22
	db $52, $2b  ; (2, 5): object $2B
	db $62, $23  ; (2, 6): object $23
	db $57, $2c  ; (7, 5): object $2C
	db $58, $22  ; (8, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $67, $24  ; (7, 6): object $24
	db $77, $28  ; (7, 7): object $28
	db $03, $29  ; (3, 0): object $29
	db $06, $2a  ; (6, 0): object $2A
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $24, $38, $22  ; warp type 0 to map $00 room $24, x 56 y 34
	db $c4, $11, $20  ; 4 down from (1, 1): object $20
	db $c4, $12, $20  ; 4 down from (2, 1): object $20
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $c4, $17, $20  ; 4 down from (7, 1): object $20
	db $c4, $18, $20  ; 4 down from (8, 1): object $20
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $82, $24, $ac  ; 2 across from (4, 2): object $AC
	db $21, $a0  ; (1, 2): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $37 of indoor group A: 22 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom37::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $ec  ; (4, 0): object $EC
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $61, $27  ; (1, 6): object $27
	db $62, $2b  ; (2, 6): object $2B
	db $72, $27  ; (2, 7): object $27
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $67, $2c  ; (7, 6): object $2C
	db $68, $28  ; (8, 6): object $28
	db $77, $28  ; (7, 7): object $28
	db $60, $03  ; (0, 6): object $03
	db $69, $03  ; (9, 6): object $03
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $28, $a1  ; (8, 2): object $A1
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $84, $43, $20  ; 4 across from (3, 4): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $38 of indoor group A: 29 objects, room template 1 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom38::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $19, $f7  ; (9, 1): object $F7
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $c2, $49, $0d  ; 2 down from (9, 4): object $0D
	db $30, $c9  ; (0, 3): object $C9
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $00, $03  ; (0, 0): object $03
	db $c3, $09, $03  ; 3 down from (9, 0): object $03
	db $79, $03  ; (9, 7): object $03
	db $01, $23  ; (1, 0): object $23
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $c3, $08, $24  ; 3 down from (8, 0): object $24
	db $38, $2a  ; (8, 3): object $2A
	db $39, $21  ; (9, 3): object $21
	db $78, $28  ; (8, 7): object $28
	db $68, $2c  ; (8, 6): object $2C
	db $69, $22  ; (9, 6): object $22
	db $c2, $48, $db  ; 2 down from (8, 4): object $DB
	db $83, $33, $db  ; 3 across from (3, 3): object $DB
	db $83, $53, $db  ; 3 across from (3, 5): object $DB
	db $42, $db  ; (2, 4): object $DB
	db $46, $db  ; (6, 4): object $DB
	db $43, $a0  ; (3, 4): object $A0
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $70, $03  ; (0, 7): object $03
	db $71, $27  ; (1, 7): object $27
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $39 of indoor group A: 36 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom39::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $58, $aa  ; (8, 5): object $AA
	db $04, $f4  ; (4, 0): object $F4
	db $40, $f6  ; (0, 4): object $F6
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $c2, $40, $0d  ; 2 down from (0, 4): object $0D
	db $c2, $11, $20  ; 2 down from (1, 1): object $20
	db $28, $a1  ; (8, 2): object $A1
	db $60, $2b  ; (0, 6): object $2B
	db $30, $29  ; (0, 3): object $29
	db $82, $31, $ae  ; 2 across from (1, 3): object $AE
	db $48, $ae  ; (8, 4): object $AE
	db $c6, $13, $01  ; 6 down from (3, 1): object $01
	db $c6, $15, $01  ; 6 down from (5, 1): object $01
	db $c6, $17, $01  ; 6 down from (7, 1): object $01
	db $83, $14, $0d  ; 3 across from (4, 1): object $0D
	db $24, $ae  ; (4, 2): object $AE
	db $26, $ae  ; (6, 2): object $AE
	db $25, $af  ; (5, 2): object $AF
	db $12, $dc  ; (2, 1): object $DC
	db $22, $dc  ; (2, 2): object $DC
	db $16, $dc  ; (6, 1): object $DC
	db $82, $41, $db  ; 2 across from (1, 4): object $DB
	db $52, $dc  ; (2, 5): object $DC
	db $62, $db  ; (2, 6): object $DB
	db $c2, $34, $db  ; 2 down from (4, 3): object $DB
	db $c2, $54, $dc  ; 2 down from (4, 5): object $DC
	db $36, $dc  ; (6, 3): object $DC
	db $c2, $46, $db  ; 2 down from (6, 4): object $DB
	db $66, $dc  ; (6, 6): object $DC
	db $58, $aa  ; (8, 5): object $AA
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $3A of indoor group A: 21 objects, room template 9 and floor object $04; a warp (type 1) to map $01 room $2D at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoom3A::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c7, $01, $63  ; 7 down from (1, 0): object $63
	db $c3, $10, $6c  ; 3 down from (0, 1): object $6C
	db $83, $14, $6b  ; 3 across from (4, 1): object $6B
	db $15, $69  ; (5, 1): object $69
	db $83, $24, $69  ; 3 across from (4, 2): object $69
	db $25, $82  ; (5, 2): object $82
	db $22, $6d  ; (2, 2): object $6D
	db $28, $62  ; (8, 2): object $62
	db $29, $6d  ; (9, 2): object $6D
	db $32, $6c  ; (2, 3): object $6C
	db $c4, $38, $63  ; 4 down from (8, 3): object $63
	db $39, $6c  ; (9, 3): object $6C
	db $83, $40, $6d  ; 3 across from (0, 4): object $6D
	db $41, $62  ; (1, 4): object $62
	db $85, $45, $6d  ; 5 across from (5, 4): object $6D
	db $48, $62  ; (8, 4): object $62
	db $c2, $50, $57  ; 2 down from (0, 5): object $57
	db $c2, $55, $6c  ; 2 down from (5, 5): object $6C
	db $70, $54  ; (0, 7): object $54
	db $89, $71, $5b  ; 9 across from (1, 7): object $5B
	db $e1, $01, $2d, $88, $20  ; warp type 1 to map $01 room $2D, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3B of indoor group A: 16 objects, room template 9 and floor object $04; a warp (type 1) to map $01 room $25 at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoom3B::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c4, $08, $63  ; 4 down from (8, 0): object $63
	db $83, $14, $6b  ; 3 across from (4, 1): object $6B
	db $15, $69  ; (5, 1): object $69
	db $83, $24, $69  ; 3 across from (4, 2): object $69
	db $25, $82  ; (5, 2): object $82
	db $c3, $19, $6c  ; 3 down from (9, 1): object $6C
	db $83, $20, $6d  ; 3 across from (0, 2): object $6D
	db $82, $30, $54  ; 2 across from (0, 3): object $54
	db $32, $6c  ; (2, 3): object $6C
	db $8a, $40, $6d  ; 10 across from (0, 4): object $6D
	db $82, $43, $04  ; 2 across from (3, 4): object $04
	db $c2, $58, $51  ; 2 down from (8, 5): object $51
	db $c2, $59, $54  ; 2 down from (9, 5): object $54
	db $88, $70, $5b  ; 8 across from (0, 7): object $5B
	db $82, $78, $54  ; 2 across from (8, 7): object $54
	db $e1, $01, $25, $88, $20  ; warp type 1 to map $01 room $25, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3C of indoor group A: 25 objects, room template 9 and floor object $04; a warp (type 1) to map $01 room $29 at x 72, y 80. Format: see IndoorARoomPointers.
IndoorARoom3C::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $54  ; 10 across from (0, 0): object $54
	db $84, $10, $54  ; 4 across from (0, 1): object $54
	db $83, $20, $54  ; 3 across from (0, 2): object $54
	db $14, $5e  ; (4, 1): object $5E
	db $23, $5e  ; (3, 2): object $5E
	db $c2, $30, $57  ; 2 down from (0, 3): object $57
	db $c3, $50, $68  ; 3 down from (0, 5): object $68
	db $c2, $61, $65  ; 2 down from (1, 6): object $65
	db $61, $64  ; (1, 6): object $64
	db $88, $62, $68  ; 8 across from (2, 6): object $68
	db $88, $72, $68  ; 8 across from (2, 7): object $68
	db $c3, $53, $6c  ; 3 down from (3, 5): object $6C
	db $c3, $57, $6c  ; 3 down from (7, 5): object $6C
	db $16, $71  ; (6, 1): object $71
	db $18, $71  ; (8, 1): object $71
	db $41, $71  ; (1, 4): object $71
	db $32, $71  ; (2, 3): object $71
	db $25, $71  ; (5, 2): object $71
	db $27, $71  ; (7, 2): object $71
	db $29, $71  ; (9, 2): object $71
	db $31, $70  ; (1, 3): object $70
	db $15, $70  ; (5, 1): object $70
	db $17, $70  ; (7, 1): object $70
	db $19, $70  ; (9, 1): object $70
	db $49, $68  ; (9, 4): object $68
	db $e1, $01, $29, $48, $50  ; warp type 1 to map $01 room $29, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3D of indoor group A: 27 objects, room template 9 and floor object $04; a warp (type 1) to map $01 room $27 at x 24, y 32. Format: see IndoorARoomPointers.
IndoorARoom3D::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $54  ; 10 across from (0, 0): object $54
	db $84, $16, $54  ; 4 across from (6, 1): object $54
	db $83, $27, $54  ; 3 across from (7, 2): object $54
	db $c2, $39, $51  ; 2 down from (9, 3): object $51
	db $15, $5a  ; (5, 1): object $5A
	db $26, $5a  ; (6, 2): object $5A
	db $c3, $59, $68  ; 3 down from (9, 5): object $68
	db $82, $40, $68  ; 2 across from (0, 4): object $68
	db $46, $68  ; (6, 4): object $68
	db $47, $64  ; (7, 4): object $64
	db $57, $65  ; (7, 5): object $65
	db $60, $68  ; (0, 6): object $68
	db $67, $68  ; (7, 6): object $68
	db $88, $70, $68  ; 8 across from (0, 7): object $68
	db $c3, $54, $6c  ; 3 down from (4, 5): object $6C
	db $c2, $68, $65  ; 2 down from (8, 6): object $65
	db $68, $64  ; (8, 6): object $64
	db $11, $71  ; (1, 1): object $71
	db $13, $71  ; (3, 1): object $71
	db $20, $71  ; (0, 2): object $71
	db $22, $71  ; (2, 2): object $71
	db $24, $71  ; (4, 2): object $71
	db $48, $71  ; (8, 4): object $71
	db $10, $70  ; (0, 1): object $70
	db $12, $70  ; (2, 1): object $70
	db $14, $70  ; (4, 1): object $70
	db $38, $70  ; (8, 3): object $70
	db $e1, $01, $27, $18, $20  ; warp type 1 to map $01 room $27, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3E of indoor group A: 21 objects, room template 9 and floor object $04; a warp (type 1) to map $01 room $2C at x 120, y 112. Format: see IndoorARoomPointers.
IndoorARoom3E::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c2, $10, $57  ; 2 down from (0, 1): object $57
	db $c5, $30, $54  ; 5 down from (0, 3): object $54
	db $31, $5b  ; (1, 3): object $5B
	db $c4, $41, $54  ; 4 down from (1, 4): object $54
	db $32, $5d  ; (2, 3): object $5D
	db $c3, $42, $57  ; 3 down from (2, 4): object $57
	db $88, $72, $54  ; 8 across from (2, 7): object $54
	db $c3, $01, $63  ; 3 down from (1, 0): object $63
	db $15, $5a  ; (5, 1): object $5A
	db $84, $16, $54  ; 4 across from (6, 1): object $54
	db $26, $5a  ; (6, 2): object $5A
	db $83, $27, $54  ; 3 across from (7, 2): object $54
	db $82, $63, $4c  ; 2 across from (3, 6): object $4C
	db $67, $4c  ; (7, 6): object $4C
	db $37, $71  ; (7, 3): object $71
	db $48, $71  ; (8, 4): object $71
	db $39, $71  ; (9, 3): object $71
	db $38, $70  ; (8, 3): object $70
	db $82, $65, $5b  ; 2 across from (5, 6): object $5B
	db $82, $68, $5b  ; 2 across from (8, 6): object $5B
	db $e1, $01, $2c, $78, $70  ; warp type 1 to map $01 room $2C, x 120 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $3F of indoor group A: 18 objects, room template 9 and floor object $04; a warp (type 1) to map $01 room $2F at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoom3F::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $86, $10, $54  ; 6 across from (0, 1): object $54
	db $85, $20, $54  ; 5 across from (0, 2): object $54
	db $16, $5e  ; (6, 1): object $5E
	db $25, $5e  ; (5, 2): object $5E
	db $c5, $08, $63  ; 5 down from (8, 0): object $63
	db $30, $71  ; (0, 3): object $71
	db $32, $71  ; (2, 3): object $71
	db $34, $71  ; (4, 3): object $71
	db $41, $71  ; (1, 4): object $71
	db $43, $71  ; (3, 4): object $71
	db $31, $70  ; (1, 3): object $70
	db $33, $70  ; (3, 3): object $70
	db $c6, $19, $51  ; 6 down from (9, 1): object $51
	db $82, $60, $5b  ; 2 across from (0, 6): object $5B
	db $86, $62, $4c  ; 6 across from (2, 6): object $4C
	db $68, $59  ; (8, 6): object $59
	db $8a, $70, $54  ; 10 across from (0, 7): object $54
	db $e1, $01, $2f, $88, $20  ; warp type 1 to map $01 room $2F, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $40 of indoor group A: 33 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom40::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $69, $f7  ; (9, 6): object $F7
	db $74, $fb  ; (4, 7): object $FB
	db $78, $f5  ; (8, 7): object $F5
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $10, $03  ; (0, 1): object $03
	db $11, $25  ; (1, 1): object $25
	db $12, $29  ; (2, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $26  ; (8, 1): object $26
	db $19, $03  ; (9, 1): object $03
	db $20, $25  ; (0, 2): object $25
	db $21, $29  ; (1, 2): object $29
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $56, $2c  ; (6, 5): object $2C
	db $57, $22  ; (7, 5): object $22
	db $58, $98  ; (8, 5): object $98
	db $59, $28  ; (9, 5): object $28
	db $66, $24  ; (6, 6): object $24
	db $c2, $67, $10  ; 2 down from (7, 6): object $10
	db $69, $12  ; (9, 6): object $12
	db $76, $28  ; (6, 7): object $28
	db $78, $0d  ; (8, 7): object $0D
	db $79, $13  ; (9, 7): object $13
	db $82, $24, $20  ; 2 across from (4, 2): object $20
	db $33, $20  ; (3, 3): object $20
	db $36, $20  ; (6, 3): object $20
	db $82, $44, $20  ; 2 across from (4, 4): object $20
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $41 of indoor group A: 13 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom41::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $39, $42  ; (9, 3): object $42
	db $60, $f6  ; (0, 6): object $F6
	db $84, $24, $13  ; 4 across from (4, 2): object $13
	db $82, $34, $20  ; 2 across from (4, 3): object $20
	db $82, $44, $20  ; 2 across from (4, 4): object $20
	db $50, $27  ; (0, 5): object $27
	db $88, $51, $22  ; 8 across from (1, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $8a, $60, $12  ; 10 across from (0, 6): object $12
	db $8a, $70, $13  ; 10 across from (0, 7): object $13
	db $32, $0f  ; (2, 3): object $0F
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $42 of indoor group A: 13 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom42::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $29, $f7  ; (9, 2): object $F7
	db $30, $49  ; (0, 3): object $49
	db $50, $27  ; (0, 5): object $27
	db $88, $51, $22  ; 8 across from (1, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $8a, $60, $12  ; 10 across from (0, 6): object $12
	db $8a, $70, $13  ; 10 across from (0, 7): object $13
	db $83, $13, $0f  ; 3 across from (3, 1): object $0F
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $24, $a0  ; (4, 2): object $A0
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $43 of indoor group A: 27 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom43::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $20, $f2  ; (0, 2): object $F2
	db $74, $f1  ; (4, 7): object $F1
	db $06, $26  ; (6, 0): object $26
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $16, $2a  ; (6, 1): object $2A
	db $17, $21  ; (7, 1): object $21
	db $18, $26  ; (8, 1): object $26
	db $19, $03  ; (9, 1): object $03
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $50, $27  ; (0, 5): object $27
	db $51, $22  ; (1, 5): object $22
	db $52, $2b  ; (2, 5): object $2B
	db $60, $12  ; (0, 6): object $12
	db $61, $16  ; (1, 6): object $16
	db $62, $23  ; (2, 6): object $23
	db $67, $2c  ; (7, 6): object $2C
	db $68, $22  ; (8, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $70, $13  ; (0, 7): object $13
	db $71, $14  ; (1, 7): object $14
	db $72, $27  ; (2, 7): object $27
	db $77, $28  ; (7, 7): object $28
	db $78, $0f  ; (8, 7): object $0F
	db $79, $2c  ; (9, 7): object $2C
	db $10, $c9  ; (0, 1): object $C9
	db $40, $c9  ; (0, 4): object $C9
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $44 of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom44::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $fa  ; (4, 0): object $FA
	db $74, $fb  ; (4, 7): object $FB
	db $08, $f4  ; (8, 0): object $F4
	db $78, $f5  ; (8, 7): object $F5
	db $06, $26  ; (6, 0): object $26
	db $c6, $16, $24  ; 6 down from (6, 1): object $24
	db $76, $28  ; (6, 7): object $28
	db $07, $14  ; (7, 0): object $14
	db $08, $0d  ; (8, 0): object $0D
	db $09, $15  ; (9, 0): object $15
	db $c6, $17, $11  ; 6 down from (7, 1): object $11
	db $c6, $19, $10  ; 6 down from (9, 1): object $10
	db $77, $16  ; (7, 7): object $16
	db $78, $0d  ; (8, 7): object $0D
	db $79, $17  ; (9, 7): object $17
	db $28, $a1  ; (8, 2): object $A1
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $26, $ca  ; (6, 2): object $CA
	db $56, $ca  ; (6, 5): object $CA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $45 of indoor group A: 26 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom45::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $29, $f3  ; (9, 2): object $F3
	db $75, $f1  ; (5, 7): object $F1
	db $c3, $47, $a6  ; 3 down from (7, 4): object $A6
	db $48, $a6  ; (8, 4): object $A6
	db $58, $de  ; (8, 5): object $DE
	db $59, $0d  ; (9, 5): object $0D
	db $c2, $68, $0d  ; 2 down from (8, 6): object $0D
	db $69, $2c  ; (9, 6): object $2C
	db $79, $24  ; (9, 7): object $24
	db $49, $2a  ; (9, 4): object $2A
	db $77, $2b  ; (7, 7): object $2B
	db $00, $0d  ; (0, 0): object $0D
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $60, $27  ; (0, 6): object $27
	db $83, $61, $22  ; 3 across from (1, 6): object $22
	db $63, $98  ; (3, 6): object $98
	db $64, $2b  ; (4, 6): object $2B
	db $82, $70, $12  ; 2 across from (0, 7): object $12
	db $72, $16  ; (2, 7): object $16
	db $73, $0d  ; (3, 7): object $0D
	db $74, $27  ; (4, 7): object $27
	db $78, $0d  ; (8, 7): object $0D
	db $03, $c7  ; (3, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $46 of indoor group A: 34 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom46::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $20, $f6  ; (0, 2): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $73, $f5  ; (3, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $07, $24  ; (7, 0): object $24
	db $17, $2a  ; (7, 1): object $2A
	db $82, $18, $21  ; 2 across from (8, 1): object $21
	db $82, $08, $0d  ; 2 across from (8, 0): object $0D
	db $c5, $29, $0d  ; 5 down from (9, 2): object $0D
	db $83, $23, $a6  ; 3 across from (3, 2): object $A6
	db $24, $a0  ; (4, 2): object $A0
	db $c4, $33, $11  ; 4 down from (3, 3): object $11
	db $82, $41, $13  ; 2 across from (1, 4): object $13
	db $82, $50, $0d  ; 2 across from (0, 5): object $0D
	db $60, $22  ; (0, 6): object $22
	db $61, $2b  ; (1, 6): object $2B
	db $c2, $62, $0d  ; 2 down from (2, 6): object $0D
	db $70, $03  ; (0, 7): object $03
	db $71, $23  ; (1, 7): object $23
	db $c2, $36, $a7  ; 2 down from (6, 3): object $A7
	db $c4, $28, $a6  ; 4 down from (8, 2): object $A6
	db $83, $55, $a6  ; 3 across from (5, 5): object $A6
	db $82, $65, $4f  ; 2 across from (5, 6): object $4F
	db $67, $a7  ; (7, 6): object $A7
	db $73, $2c  ; (3, 7): object $2C
	db $82, $74, $22  ; 2 across from (4, 7): object $22
	db $76, $2b  ; (6, 7): object $2B
	db $79, $2c  ; (9, 7): object $2C
	db $40, $29  ; (0, 4): object $29
	db $78, $0d  ; (8, 7): object $0D
	db $52, $de  ; (2, 5): object $DE
	db $07, $26  ; (7, 0): object $26
	db $77, $0d  ; (7, 7): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $47 of indoor group A: 21 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom47::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $73, $48  ; (3, 7): object $48
	db $07, $26  ; (7, 0): object $26
	db $09, $24  ; (9, 0): object $24
	db $10, $29  ; (0, 1): object $29
	db $c6, $17, $24  ; 6 down from (7, 1): object $24
	db $c8, $08, $0f  ; 8 down from (8, 0): object $0F
	db $70, $22  ; (0, 7): object $22
	db $77, $28  ; (7, 7): object $28
	db $79, $24  ; (9, 7): object $24
	db $48, $af  ; (8, 4): object $AF
	db $58, $b0  ; (8, 5): object $B0
	db $18, $a0  ; (8, 1): object $A0
	db $27, $ca  ; (7, 2): object $CA
	db $57, $ca  ; (7, 5): object $CA
	db $c3, $13, $0f  ; 3 down from (3, 1): object $0F
	db $85, $41, $0f  ; 5 across from (1, 4): object $0F
	db $83, $52, $0f  ; 3 across from (2, 5): object $0F
	db $63, $0f  ; (3, 6): object $0F
	db $c5, $20, $0d  ; 5 down from (0, 2): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $48 of indoor group A: 24 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom48::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $fa  ; (4, 0): object $FA
	db $49, $f7  ; (9, 4): object $F7
	db $08, $f4  ; (8, 0): object $F4
	db $06, $26  ; (6, 0): object $26
	db $82, $16, $24  ; 2 across from (6, 1): object $24
	db $26, $2a  ; (6, 2): object $2A
	db $82, $27, $21  ; 2 across from (7, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $18, $21  ; (8, 1): object $21
	db $19, $0d  ; (9, 1): object $0D
	db $50, $27  ; (0, 5): object $27
	db $82, $51, $22  ; 2 across from (1, 5): object $22
	db $53, $2b  ; (3, 5): object $2B
	db $83, $60, $03  ; 3 across from (0, 6): object $03
	db $63, $23  ; (3, 6): object $23
	db $83, $70, $03  ; 3 across from (0, 7): object $03
	db $73, $27  ; (3, 7): object $27
	db $c2, $07, $10  ; 2 down from (7, 0): object $10
	db $09, $12  ; (9, 0): object $12
	db $c2, $08, $0d  ; 2 down from (8, 0): object $0D
	db $82, $18, $13  ; 2 across from (8, 1): object $13
	db $32, $0f  ; (2, 3): object $0F
	db $17, $ac  ; (7, 1): object $AC
	db $62, $ac  ; (2, 6): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $49 of indoor group A: 36 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom49::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $05, $f0  ; (5, 0): object $F0
	db $40, $f2  ; (0, 4): object $F2
	db $49, $f7  ; (9, 4): object $F7
	db $08, $0d  ; (8, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $c2, $17, $10  ; 2 down from (7, 1): object $10
	db $19, $2a  ; (9, 1): object $2A
	db $28, $de  ; (8, 2): object $DE
	db $29, $a6  ; (9, 2): object $A6
	db $c4, $39, $0d  ; 4 down from (9, 3): object $0D
	db $39, $12  ; (9, 3): object $12
	db $79, $22  ; (9, 7): object $22
	db $07, $29  ; (7, 0): object $29
	db $20, $25  ; (0, 2): object $25
	db $00, $12  ; (0, 0): object $12
	db $01, $16  ; (1, 0): object $16
	db $02, $25  ; (2, 0): object $25
	db $12, $23  ; (2, 1): object $23
	db $22, $29  ; (2, 2): object $29
	db $21, $98  ; (1, 2): object $98
	db $10, $13  ; (0, 1): object $13
	db $31, $a7  ; (1, 3): object $A7
	db $30, $c9  ; (0, 3): object $C9
	db $60, $c9  ; (0, 6): object $C9
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $82, $00, $12  ; 2 across from (0, 0): object $12
	db $02, $a6  ; (2, 0): object $A6
	db $03, $0d  ; (3, 0): object $0D
	db $04, $25  ; (4, 0): object $25
	db $10, $13  ; (0, 1): object $13
	db $11, $0d  ; (1, 1): object $0D
	db $12, $25  ; (2, 1): object $25
	db $13, $21  ; (3, 1): object $21
	db $14, $29  ; (4, 1): object $29
	db $37, $94  ; (7, 3): object $94
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4A of indoor group A: 32 objects, room template 0 and floor object $0D; a warp (type 2) to map $02 room $AA at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom4A::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $29, $ca  ; (9, 2): object $CA
	db $49, $ca  ; (9, 4): object $CA
	db $03, $f4  ; (3, 0): object $F4
	db $39, $4a  ; (9, 3): object $4A
	db $40, $f6  ; (0, 4): object $F6
	db $74, $f5  ; (4, 7): object $F5
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $c5, $20, $0d  ; 5 down from (0, 2): object $0D
	db $02, $0d  ; (2, 0): object $0D
	db $00, $03  ; (0, 0): object $03
	db $01, $23  ; (1, 0): object $23
	db $10, $21  ; (0, 1): object $21
	db $11, $29  ; (1, 1): object $29
	db $c2, $13, $11  ; 2 down from (3, 1): object $11
	db $83, $30, $12  ; 3 across from (0, 3): object $12
	db $33, $93  ; (3, 3): object $93
	db $21, $be  ; (1, 2): object $BE
	db $22, $de  ; (2, 2): object $DE
	db $70, $22  ; (0, 7): object $22
	db $04, $0d  ; (4, 0): object $0D
	db $e2, $02, $aa, $18, $10  ; warp type 2 to map $02 room $AA, x 24 y 16
	db $03, $2a  ; (3, 0): object $2A
	db $04, $c7  ; (4, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $06, $29  ; (6, 0): object $29
	db $82, $07, $0d  ; 2 across from (7, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $82, $57, $20  ; 2 across from (7, 5): object $20
	db $82, $62, $20  ; 2 across from (2, 6): object $20
	db $82, $67, $20  ; 2 across from (7, 6): object $20
	db $20, $a6  ; (0, 2): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4B of indoor group A: 22 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom4B::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $41  ; (0, 3): object $41
	db $03, $3f  ; (3, 0): object $3F
	db $07, $26  ; (7, 0): object $26
	db $c2, $08, $0f  ; 2 down from (8, 0): object $0F
	db $09, $24  ; (9, 0): object $24
	db $17, $24  ; (7, 1): object $24
	db $19, $2a  ; (9, 1): object $2A
	db $27, $2a  ; (7, 2): object $2A
	db $28, $98  ; (8, 2): object $98
	db $29, $26  ; (9, 2): object $26
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $83, $24, $a6  ; 3 across from (4, 2): object $A6
	db $84, $54, $a6  ; 4 across from (4, 5): object $A6
	db $83, $34, $af  ; 3 across from (4, 3): object $AF
	db $83, $44, $b0  ; 3 across from (4, 4): object $B0
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $82, $66, $20  ; 2 across from (6, 6): object $20
	db $68, $24  ; (8, 6): object $24
	db $c2, $69, $03  ; 2 down from (9, 6): object $03
	db $78, $28  ; (8, 7): object $28
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4C of indoor group A: 39 objects, room template 0 and floor object $0D; a warp (type 1) to map $02 room $56 at x 104, y 64. Format: see IndoorARoomPointers.
IndoorARoom4C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $76, $f5  ; (6, 7): object $F5
	db $75, $2b  ; (5, 7): object $2B
	db $82, $76, $0d  ; 2 across from (6, 7): object $0D
	db $78, $2c  ; (8, 7): object $2C
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $10, $03  ; (0, 1): object $03
	db $19, $03  ; (9, 1): object $03
	db $02, $25  ; (2, 0): object $25
	db $11, $25  ; (1, 1): object $25
	db $20, $25  ; (0, 2): object $25
	db $07, $26  ; (7, 0): object $26
	db $18, $26  ; (8, 1): object $26
	db $29, $26  ; (9, 2): object $26
	db $12, $29  ; (2, 1): object $29
	db $21, $29  ; (1, 2): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $28, $2a  ; (8, 2): object $2A
	db $83, $25, $0f  ; 3 across from (5, 2): object $0F
	db $83, $35, $0f  ; 3 across from (5, 3): object $0F
	db $83, $45, $0f  ; 3 across from (5, 4): object $0F
	db $70, $23  ; (0, 7): object $23
	db $52, $2c  ; (2, 5): object $2C
	db $53, $22  ; (3, 5): object $22
	db $54, $2b  ; (4, 5): object $2B
	db $c2, $62, $24  ; 2 down from (2, 6): object $24
	db $c2, $63, $03  ; 2 down from (3, 6): object $03
	db $64, $23  ; (4, 6): object $23
	db $74, $27  ; (4, 7): object $27
	db $71, $0d  ; (1, 7): object $0D
	db $82, $22, $db  ; 2 across from (2, 2): object $DB
	db $c2, $32, $db  ; 2 down from (2, 3): object $DB
	db $33, $a0  ; (3, 3): object $A0
	db $c3, $24, $dc  ; 3 down from (4, 2): object $DC
	db $43, $dc  ; (3, 4): object $DC
	db $15, $a7  ; (5, 1): object $A7
	db $36, $be  ; (6, 3): object $BE
	db $e1, $02, $56, $68, $40  ; warp type 1 to map $02 room $56, x 104 y 64
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4D of indoor group A: 27 objects, room template 0 and floor object $0D; a warp (type 1) to map $02 room $57 at x 72, y 96. Format: see IndoorARoomPointers.
IndoorARoom4D::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $00, $03  ; (0, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $03  ; (9, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $13, $ac  ; (3, 1): object $AC
	db $16, $ac  ; (6, 1): object $AC
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $31, $ac  ; (1, 3): object $AC
	db $38, $ac  ; (8, 3): object $AC
	db $33, $2c  ; (3, 3): object $2C
	db $82, $34, $22  ; 2 across from (4, 3): object $22
	db $35, $98  ; (5, 3): object $98
	db $36, $2b  ; (6, 3): object $2B
	db $43, $24  ; (3, 4): object $24
	db $46, $23  ; (6, 4): object $23
	db $53, $2a  ; (3, 5): object $2A
	db $82, $54, $21  ; 2 across from (4, 5): object $21
	db $56, $29  ; (6, 5): object $29
	db $32, $0f  ; (2, 3): object $0F
	db $44, $be  ; (4, 4): object $BE
	db $e1, $02, $57, $48, $60  ; warp type 1 to map $02 room $57, x 72 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4E of indoor group A: 16 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom4E::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $06, $f4  ; (6, 0): object $F4
	db $76, $f5  ; (6, 7): object $F5
	db $05, $29  ; (5, 0): object $29
	db $82, $06, $0d  ; 2 across from (6, 0): object $0D
	db $08, $2a  ; (8, 0): object $2A
	db $c8, $00, $23  ; 8 down from (0, 0): object $23
	db $c8, $01, $0d  ; 8 down from (1, 0): object $0D
	db $c8, $02, $24  ; 8 down from (2, 0): object $24
	db $c8, $03, $03  ; 8 down from (3, 0): object $03
	db $c8, $04, $23  ; 8 down from (4, 0): object $23
	db $04, $25  ; (4, 0): object $25
	db $74, $27  ; (4, 7): object $27
	db $28, $a1  ; (8, 2): object $A1
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $4F of indoor group A: 15 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom4F::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $06, $f0  ; (6, 0): object $F0
	db $39, $f3  ; (9, 3): object $F3
	db $76, $f1  ; (6, 7): object $F1
	db $05, $c7  ; (5, 0): object $C7
	db $08, $c7  ; (8, 0): object $C7
	db $c8, $00, $23  ; 8 down from (0, 0): object $23
	db $c8, $01, $0d  ; 8 down from (1, 0): object $0D
	db $c8, $02, $24  ; 8 down from (2, 0): object $24
	db $c8, $03, $03  ; 8 down from (3, 0): object $03
	db $c8, $04, $23  ; 8 down from (4, 0): object $23
	db $04, $25  ; (4, 0): object $25
	db $74, $27  ; (4, 7): object $27
	db $31, $4f  ; (1, 3): object $4F
	db $41, $4f  ; (1, 4): object $4F
	db $27, $a0  ; (7, 2): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $50 of indoor group A: 17 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom50::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $86, $13, $dc  ; 6 across from (3, 1): object $DC
	db $c4, $28, $dc  ; 4 down from (8, 2): object $DC
	db $83, $66, $dc  ; 3 across from (6, 6): object $DC
	db $23, $2c  ; (3, 2): object $2C
	db $83, $24, $22  ; 3 across from (4, 2): object $22
	db $27, $2b  ; (7, 2): object $2B
	db $c2, $33, $24  ; 2 down from (3, 3): object $24
	db $83, $34, $0f  ; 3 across from (4, 3): object $0F
	db $83, $44, $0f  ; 3 across from (4, 4): object $0F
	db $c2, $37, $23  ; 2 down from (7, 3): object $23
	db $53, $2a  ; (3, 5): object $2A
	db $83, $54, $c7  ; 3 across from (4, 5): object $C7
	db $55, $98  ; (5, 5): object $98
	db $57, $29  ; (7, 5): object $29
	db $62, $a7  ; (2, 6): object $A7
	db $35, $a0  ; (5, 3): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $51 of indoor group A: 25 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom51::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $06, $f4  ; (6, 0): object $F4
	db $74, $f5  ; (4, 7): object $F5
	db $00, $23  ; (0, 0): object $23
	db $01, $0d  ; (1, 0): object $0D
	db $c3, $02, $24  ; 3 down from (2, 0): object $24
	db $c3, $03, $03  ; 3 down from (3, 0): object $03
	db $04, $25  ; (4, 0): object $25
	db $c2, $14, $23  ; 2 down from (4, 1): object $23
	db $32, $2a  ; (2, 3): object $2A
	db $33, $21  ; (3, 3): object $21
	db $34, $29  ; (4, 3): object $29
	db $60, $27  ; (0, 6): object $27
	db $71, $27  ; (1, 7): object $27
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $70, $03  ; (0, 7): object $03
	db $79, $03  ; (9, 7): object $03
	db $72, $c8  ; (2, 7): object $C8
	db $77, $c8  ; (7, 7): object $C8
	db $28, $a1  ; (8, 2): object $A1
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $52 of indoor group A: 30 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $B5 at x 104, y 32. Format: see IndoorARoomPointers.
IndoorARoom52::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $39, $f7  ; (9, 3): object $F7
	db $83, $00, $03  ; 3 across from (0, 0): object $03
	db $03, $25  ; (3, 0): object $25
	db $06, $26  ; (6, 0): object $26
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $82, $11, $21  ; 2 across from (1, 1): object $21
	db $12, $c7  ; (2, 1): object $C7
	db $13, $29  ; (3, 1): object $29
	db $82, $14, $0f  ; 2 across from (4, 1): object $0F
	db $16, $2a  ; (6, 1): object $2A
	db $17, $c7  ; (7, 1): object $C7
	db $18, $21  ; (8, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $86, $42, $0f  ; 6 across from (2, 4): object $0F
	db $c2, $23, $c0  ; 2 down from (3, 2): object $C0
	db $c2, $26, $c0  ; 2 down from (6, 2): object $C0
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $82, $51, $20  ; 2 across from (1, 5): object $20
	db $82, $57, $20  ; 2 across from (7, 5): object $20
	db $62, $20  ; (2, 6): object $20
	db $67, $20  ; (7, 6): object $20
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $b5, $68, $20  ; warp type 0 to map $00 room $B5, x 104 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $53 of indoor group A: 12 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom53::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $30, $f2  ; (0, 3): object $F2
	db $86, $11, $01  ; 6 across from (1, 1): object $01
	db $86, $21, $b0  ; 6 across from (1, 2): object $B0
	db $86, $51, $af  ; 6 across from (1, 5): object $AF
	db $86, $61, $01  ; 6 across from (1, 6): object $01
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $82, $27, $0f  ; 2 across from (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $28, $a0  ; (8, 2): object $A0
	db $20, $29  ; (0, 2): object $29
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $54 of indoor group A: 28 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom54::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $74, $ed  ; (4, 7): object $ED
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $00, $03  ; (0, 0): object $03
	db $09, $03  ; (9, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $08, $26  ; (8, 0): object $26
	db $19, $26  ; (9, 1): object $26
	db $18, $2a  ; (8, 1): object $2A
	db $22, $96  ; (2, 2): object $96
	db $23, $0f  ; (3, 2): object $0F
	db $24, $95  ; (4, 2): object $95
	db $25, $96  ; (5, 2): object $96
	db $26, $0f  ; (6, 2): object $0F
	db $27, $95  ; (7, 2): object $95
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $42, $94  ; (2, 4): object $94
	db $43, $0f  ; (3, 4): object $0F
	db $44, $93  ; (4, 4): object $93
	db $45, $94  ; (5, 4): object $94
	db $46, $0f  ; (6, 4): object $0F
	db $47, $93  ; (7, 4): object $93
	db $21, $20  ; (1, 2): object $20
	db $28, $20  ; (8, 2): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $55 of indoor group A: 25 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom55::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $39, $ef  ; (9, 3): object $EF
	db $00, $03  ; (0, 0): object $03
	db $09, $03  ; (9, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $08, $26  ; (8, 0): object $26
	db $19, $26  ; (9, 1): object $26
	db $18, $2a  ; (8, 1): object $2A
	db $60, $27  ; (0, 6): object $27
	db $71, $27  ; (1, 7): object $27
	db $69, $28  ; (9, 6): object $28
	db $78, $28  ; (8, 7): object $28
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $70, $03  ; (0, 7): object $03
	db $79, $03  ; (9, 7): object $03
	db $c6, $13, $d2  ; 6 down from (3, 1): object $D2
	db $14, $af  ; (4, 1): object $AF
	db $c6, $15, $d1  ; 6 down from (5, 1): object $D1
	db $c5, $24, $01  ; 5 down from (4, 2): object $01
	db $64, $b0  ; (4, 6): object $B0
	db $c2, $32, $d2  ; 2 down from (2, 3): object $D2
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $56 of indoor group A: 30 objects, room template 0 and floor object $0D; a warp (type 1) to map $02 room $4C at x 104, y 64. Format: see IndoorARoomPointers.
IndoorARoom56::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $04, $d0  ; (4, 0): object $D0
	db $04, $ec  ; (4, 0): object $EC
	db $39, $ef  ; (9, 3): object $EF
	db $30, $ee  ; (0, 3): object $EE
	db $74, $ed  ; (4, 7): object $ED
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $11, $21  ; (1, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $21  ; (8, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $22  ; (1, 6): object $22
	db $62, $2b  ; (2, 6): object $2B
	db $67, $2c  ; (7, 6): object $2C
	db $68, $22  ; (8, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $72, $27  ; (2, 7): object $27
	db $77, $28  ; (7, 7): object $28
	db $36, $cb  ; (6, 3): object $CB
	db $e1, $02, $4c, $68, $40  ; warp type 1 to map $02 room $4C, x 104 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $57 of indoor group A: 22 objects, room template 0 and floor object $0D; a warp (type 1) to map $02 room $4D at x 72, y 80. Format: see IndoorARoomPointers.
IndoorARoom57::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $30, $ee  ; (0, 3): object $EE
	db $12, $c7  ; (2, 1): object $C7
	db $17, $c7  ; (7, 1): object $C7
	db $8a, $00, $03  ; 10 across from (0, 0): object $03
	db $8a, $70, $03  ; 10 across from (0, 7): object $03
	db $10, $25  ; (0, 1): object $25
	db $88, $11, $21  ; 8 across from (1, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $88, $61, $22  ; 8 across from (1, 6): object $22
	db $87, $22, $d1  ; 7 across from (2, 2): object $D1
	db $c2, $38, $d0  ; 2 down from (8, 3): object $D0
	db $84, $44, $d2  ; 4 across from (4, 4): object $D2
	db $86, $32, $c0  ; 6 across from (2, 3): object $C0
	db $c2, $42, $c0  ; 2 down from (2, 4): object $C0
	db $84, $55, $c0  ; 4 across from (5, 5): object $C0
	db $69, $28  ; (9, 6): object $28
	db $12, $c7  ; (2, 1): object $C7
	db $17, $c7  ; (7, 1): object $C7
	db $62, $c8  ; (2, 6): object $C8
	db $67, $c8  ; (7, 6): object $C8
	db $54, $cb  ; (4, 5): object $CB
	db $e1, $02, $4d, $48, $50  ; warp type 1 to map $02 room $4D, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $58 of indoor group A: 41 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom58::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $04, $ec  ; (4, 0): object $EC
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $11, $21  ; (1, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $21  ; (8, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $63, $ae  ; (3, 6): object $AE
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $03  ; (0, 7): object $03
	db $71, $27  ; (1, 7): object $27
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $78, $28  ; (8, 7): object $28
	db $79, $03  ; (9, 7): object $03
	db $c2, $31, $cf  ; 2 down from (1, 3): object $CF
	db $87, $32, $d1  ; 7 across from (2, 3): object $D1
	db $33, $cf  ; (3, 3): object $CF
	db $35, $cf  ; (5, 3): object $CF
	db $37, $cf  ; (7, 3): object $CF
	db $42, $d0  ; (2, 4): object $D0
	db $43, $d1  ; (3, 4): object $D1
	db $82, $44, $ae  ; 2 across from (4, 4): object $AE
	db $46, $d0  ; (6, 4): object $D0
	db $47, $d1  ; (7, 4): object $D1
	db $c2, $48, $d0  ; 2 down from (8, 4): object $D0
	db $82, $51, $d2  ; 2 across from (1, 5): object $D2
	db $53, $cf  ; (3, 5): object $CF
	db $82, $54, $20  ; 2 across from (4, 5): object $20
	db $82, $56, $d2  ; 2 across from (6, 5): object $D2
	db $83, $63, $d2  ; 3 across from (3, 6): object $D2
	db $66, $d0  ; (6, 6): object $D0
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $59 of indoor group A: 26 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $B5 at x 104, y 34. Format: see IndoorARoomPointers.
IndoorARoom59::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
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
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $e0, $00, $b5, $68, $22  ; warp type 0 to map $00 room $B5, x 104 y 34
	db $fe  ; end
	db $fe

;@ path: world/indoor/rooms
;@ Room $5A of indoor group A: 8 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom5A::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5B of indoor group A: 38 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom5B::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $04, $f8  ; (4, 0): object $F8
	db $39, $f7  ; (9, 3): object $F7
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $11, $cf  ; (1, 1): object $CF
	db $12, $d1  ; (2, 1): object $D1
	db $13, $c0  ; (3, 1): object $C0
	db $84, $14, $d2  ; 4 across from (4, 1): object $D2
	db $c3, $18, $cf  ; 3 down from (8, 1): object $CF
	db $83, $21, $d2  ; 3 across from (1, 2): object $D2
	db $22, $d0  ; (2, 2): object $D0
	db $24, $d0  ; (4, 2): object $D0
	db $25, $c0  ; (5, 2): object $C0
	db $c2, $26, $d0  ; 2 down from (6, 2): object $D0
	db $c2, $27, $c0  ; 2 down from (7, 2): object $C0
	db $c3, $31, $d0  ; 3 down from (1, 3): object $D0
	db $c2, $32, $c0  ; 2 down from (2, 3): object $C0
	db $33, $cf  ; (3, 3): object $CF
	db $34, $c0  ; (4, 3): object $C0
	db $35, $d2  ; (5, 3): object $D2
	db $36, $d0  ; (6, 3): object $D0
	db $82, $43, $d2  ; 2 across from (3, 4): object $D2
	db $45, $d0  ; (5, 4): object $D0
	db $46, $c0  ; (6, 4): object $C0
	db $47, $cf  ; (7, 4): object $CF
	db $48, $d1  ; (8, 4): object $D1
	db $52, $d1  ; (2, 5): object $D1
	db $c2, $53, $d0  ; 2 down from (3, 5): object $D0
	db $82, $54, $c0  ; 2 across from (4, 5): object $C0
	db $56, $cf  ; (6, 5): object $CF
	db $57, $d1  ; (7, 5): object $D1
	db $58, $c0  ; (8, 5): object $C0
	db $82, $61, $c0  ; 2 across from (1, 6): object $C0
	db $63, $d0  ; (3, 6): object $D0
	db $83, $64, $d1  ; 3 across from (4, 6): object $D1
	db $82, $67, $c0  ; 2 across from (7, 6): object $C0
	db $31, $d2  ; (1, 3): object $D2
	db $32, $d0  ; (2, 3): object $D0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5C of indoor group A: 15 objects, room template 0 and floor object $0D; a warp (type 2) to map $02 room $AB at x 136, y 128. Format: see IndoorARoomPointers.
IndoorARoom5C::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $30, $d1  ; (0, 3): object $D1
	db $30, $f2  ; (0, 3): object $F2
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $11, $88  ; (1, 1): object $88
	db $16, $88  ; (6, 1): object $88
	db $82, $21, $88  ; 2 across from (1, 2): object $88
	db $82, $25, $88  ; 2 across from (5, 2): object $88
	db $82, $33, $88  ; 2 across from (3, 3): object $88
	db $c2, $38, $88  ; 2 down from (8, 3): object $88
	db $c2, $51, $88  ; 2 down from (1, 5): object $88
	db $c2, $53, $88  ; 2 down from (3, 5): object $88
	db $c2, $56, $88  ; 2 down from (6, 5): object $88
	db $54, $88  ; (4, 5): object $88
	db $18, $cb  ; (8, 1): object $CB
	db $e2, $02, $ab, $88, $80  ; warp type 2 to map $02 room $AB, x 136 y 128
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5D of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom5D::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5E of indoor group A: 15 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $6D at x 24, y 32. Format: see IndoorARoomPointers.
IndoorARoom5E::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c3, $01, $64  ; 3 down from (1, 0): object $64
	db $c6, $10, $57  ; 6 down from (0, 1): object $57
	db $89, $31, $80  ; 9 across from (1, 3): object $80
	db $89, $41, $81  ; 9 across from (1, 4): object $81
	db $c3, $14, $6c  ; 3 down from (4, 1): object $6C
	db $c3, $15, $6c  ; 3 down from (5, 1): object $6C
	db $89, $51, $81  ; 9 across from (1, 5): object $81
	db $89, $61, $81  ; 9 across from (1, 6): object $81
	db $64, $50  ; (4, 6): object $50
	db $65, $56  ; (5, 6): object $56
	db $70, $54  ; (0, 7): object $54
	db $89, $71, $53  ; 9 across from (1, 7): object $53
	db $82, $74, $54  ; 2 across from (4, 7): object $54
	db $82, $44, $6d  ; 2 across from (4, 4): object $6D
	db $e1, $03, $6d, $18, $20  ; warp type 1 to map $03 room $6D, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $5F of indoor group A: 16 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $6E at x 24, y 32. Format: see IndoorARoomPointers.
IndoorARoom5F::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c3, $08, $65  ; 3 down from (8, 0): object $65
	db $89, $30, $80  ; 9 across from (0, 3): object $80
	db $89, $40, $81  ; 9 across from (0, 4): object $81
	db $87, $50, $81  ; 7 across from (0, 5): object $81
	db $87, $60, $81  ; 7 across from (0, 6): object $81
	db $c4, $12, $6c  ; 4 down from (2, 1): object $6C
	db $c4, $19, $51  ; 4 down from (9, 1): object $51
	db $52, $6d  ; (2, 5): object $6D
	db $57, $50  ; (7, 5): object $50
	db $58, $53  ; (8, 5): object $53
	db $c3, $59, $54  ; 3 down from (9, 5): object $54
	db $67, $51  ; (7, 6): object $51
	db $68, $54  ; (8, 6): object $54
	db $87, $70, $53  ; 7 across from (0, 7): object $53
	db $83, $77, $54  ; 3 across from (7, 7): object $54
	db $e1, $03, $6e, $18, $20  ; warp type 1 to map $03 room $6E, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $60 of indoor group A: 32 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom60::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $39, $f3  ; (9, 3): object $F3
	db $74, $f1  ; (4, 7): object $F1
	db $02, $26  ; (2, 0): object $26
	db $83, $03, $c0  ; 3 across from (3, 0): object $C0
	db $06, $25  ; (6, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $c2, $09, $03  ; 2 down from (9, 0): object $03
	db $11, $c0  ; (1, 1): object $C0
	db $c3, $12, $24  ; 3 down from (2, 1): object $24
	db $c3, $16, $23  ; 3 down from (6, 1): object $23
	db $13, $17  ; (3, 1): object $17
	db $14, $12  ; (4, 1): object $12
	db $15, $16  ; (5, 1): object $16
	db $23, $11  ; (3, 2): object $11
	db $25, $10  ; (5, 2): object $10
	db $33, $15  ; (3, 3): object $15
	db $35, $14  ; (5, 3): object $14
	db $17, $c0  ; (7, 1): object $C0
	db $18, $24  ; (8, 1): object $24
	db $42, $2a  ; (2, 4): object $2A
	db $43, $c7  ; (3, 4): object $C7
	db $44, $98  ; (4, 4): object $98
	db $45, $c7  ; (5, 4): object $C7
	db $46, $29  ; (6, 4): object $29
	db $29, $26  ; (9, 2): object $26
	db $28, $2a  ; (8, 2): object $2A
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $68, $24  ; (8, 6): object $24
	db $c2, $69, $03  ; 2 down from (9, 6): object $03
	db $78, $28  ; (8, 7): object $28
	db $24, $a0  ; (4, 2): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $61 of indoor group A: 11 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom61::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $74, $f5  ; (4, 7): object $F5
	db $c2, $31, $0f  ; 2 down from (1, 3): object $0F
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
	db $03, $c7  ; (3, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $22, $a6  ; (2, 2): object $A6
	db $24, $a6  ; (4, 2): object $A6
	db $43, $a6  ; (3, 4): object $A6
	db $45, $a6  ; (5, 4): object $A6
	db $c4, $17, $0f  ; 4 down from (7, 1): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $62 of indoor group A: 26 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $2B at x 72, y 34. Format: see IndoorARoomPointers.
IndoorARoom62::
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
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $e0, $00, $2b, $48, $22  ; warp type 0 to map $00 room $2B, x 72 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $63 of indoor group A: 21 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom63::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f5  ; (4, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $20, $c9  ; (0, 2): object $C9
	db $82, $61, $12  ; 2 across from (1, 6): object $12
	db $63, $2c  ; (3, 6): object $2C
	db $82, $64, $22  ; 2 across from (4, 6): object $22
	db $66, $2b  ; (6, 6): object $2B
	db $73, $24  ; (3, 7): object $24
	db $82, $74, $03  ; 2 across from (4, 7): object $03
	db $76, $23  ; (6, 7): object $23
	db $70, $23  ; (0, 7): object $23
	db $82, $71, $0d  ; 2 across from (1, 7): object $0D
	db $82, $77, $0d  ; 2 across from (7, 7): object $0D
	db $79, $24  ; (9, 7): object $24
	db $22, $8d  ; (2, 2): object $8D
	db $27, $8d  ; (7, 2): object $8D
	db $42, $8d  ; (2, 4): object $8D
	db $47, $8d  ; (7, 4): object $8D
	db $35, $8d  ; (5, 3): object $8D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $64 of indoor group A: 14 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom64::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $88, $11, $1b  ; 8 across from (1, 1): object $1B
	db $88, $21, $1b  ; 8 across from (1, 2): object $1B
	db $88, $31, $1b  ; 8 across from (1, 3): object $1B
	db $88, $41, $1b  ; 8 across from (1, 4): object $1B
	db $88, $51, $1b  ; 8 across from (1, 5): object $1B
	db $88, $61, $1b  ; 8 across from (1, 6): object $1B
	db $33, $2c  ; (3, 3): object $2C
	db $82, $34, $22  ; 2 across from (4, 3): object $22
	db $36, $2b  ; (6, 3): object $2B
	db $43, $2a  ; (3, 4): object $2A
	db $82, $44, $21  ; 2 across from (4, 4): object $21
	db $46, $29  ; (6, 4): object $29
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $65 of indoor group A: 16 objects, room template 0 and floor object $0E. Format: see IndoorARoomPointers.
IndoorARoom65::
	db $0c, $0e  ; animated tiles $0C, template 0, floor $0E
	db $74, $f5  ; (4, 7): object $F5
	db $03, $c7  ; (3, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $c8, $00, $03  ; 8 down from (0, 0): object $03
	db $01, $25  ; (1, 0): object $25
	db $c6, $11, $23  ; 6 down from (1, 1): object $23
	db $71, $27  ; (1, 7): object $27
	db $83, $14, $1b  ; 3 across from (4, 1): object $1B
	db $83, $24, $1b  ; 3 across from (4, 2): object $1B
	db $83, $34, $1b  ; 3 across from (4, 3): object $1B
	db $c4, $45, $1b  ; 4 down from (5, 4): object $1B
	db $25, $a0  ; (5, 2): object $A0
	db $45, $a9  ; (5, 4): object $A9
	db $74, $2b  ; (4, 7): object $2B
	db $76, $2c  ; (6, 7): object $2C
	db $32, $1b  ; (2, 3): object $1B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $66 of indoor group A: 32 objects, room template 0 and floor object $0D; a warp (type 2) to map $03 room $EF at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom66::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f5  ; (4, 7): object $F5
	db $c8, $00, $03  ; 8 down from (0, 0): object $03
	db $c8, $01, $03  ; 8 down from (1, 0): object $03
	db $c8, $02, $03  ; 8 down from (2, 0): object $03
	db $c8, $07, $03  ; 8 down from (7, 0): object $03
	db $c8, $08, $03  ; 8 down from (8, 0): object $03
	db $c8, $09, $03  ; 8 down from (9, 0): object $03
	db $03, $25  ; (3, 0): object $25
	db $06, $26  ; (6, 0): object $26
	db $13, $23  ; (3, 1): object $23
	db $16, $24  ; (6, 1): object $24
	db $22, $25  ; (2, 2): object $25
	db $23, $29  ; (3, 2): object $29
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $c3, $32, $23  ; 3 down from (2, 3): object $23
	db $c3, $37, $24  ; 3 down from (7, 3): object $24
	db $62, $27  ; (2, 6): object $27
	db $63, $2b  ; (3, 6): object $2B
	db $66, $2c  ; (6, 6): object $2C
	db $67, $28  ; (7, 6): object $28
	db $73, $27  ; (3, 7): object $27
	db $76, $28  ; (6, 7): object $28
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $84, $43, $0f  ; 4 across from (3, 4): object $0F
	db $84, $53, $0f  ; 4 across from (3, 5): object $0F
	db $33, $ac  ; (3, 3): object $AC
	db $36, $ac  ; (6, 3): object $AC
	db $53, $ac  ; (3, 5): object $AC
	db $56, $ac  ; (6, 5): object $AC
	db $44, $be  ; (4, 4): object $BE
	db $e2, $03, $ef, $18, $10  ; warp type 2 to map $03 room $EF, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $67 of indoor group A: 23 objects, room template 0 and floor object $0E; a warp (type 2) to map $03 room $1F at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom67::
	db $0c, $0e  ; animated tiles $0C, template 0, floor $0E
	db $39, $f7  ; (9, 3): object $F7
	db $76, $f5  ; (6, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $83, $16, $1b  ; 3 across from (6, 1): object $1B
	db $c2, $27, $1b  ; 2 down from (7, 2): object $1B
	db $c2, $28, $1b  ; 2 down from (8, 2): object $1B
	db $83, $46, $1b  ; 3 across from (6, 4): object $1B
	db $84, $54, $1b  ; 4 across from (4, 5): object $1B
	db $87, $61, $1b  ; 7 across from (1, 6): object $1B
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $c2, $58, $0d  ; 2 down from (8, 5): object $0D
	db $75, $2b  ; (5, 7): object $2B
	db $76, $0d  ; (6, 7): object $0D
	db $77, $2c  ; (7, 7): object $2C
	db $29, $2a  ; (9, 2): object $2A
	db $59, $2c  ; (9, 5): object $2C
	db $22, $8d  ; (2, 2): object $8D
	db $27, $8d  ; (7, 2): object $8D
	db $42, $8d  ; (2, 4): object $8D
	db $47, $8d  ; (7, 4): object $8D
	db $35, $8d  ; (5, 3): object $8D
	db $18, $bf  ; (8, 1): object $BF
	db $e2, $03, $1f, $88, $10  ; warp type 2 to map $03 room $1F, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $68 of indoor group A: 28 objects, room template 1 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom68::
	db $0c, $1d  ; animated tiles $0C, template 1, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $59, $f7  ; (9, 5): object $F7
	db $10, $c9  ; (0, 1): object $C9
	db $60, $c9  ; (0, 6): object $C9
	db $20, $29  ; (0, 2): object $29
	db $50, $2b  ; (0, 5): object $2B
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $c4, $03, $24  ; 4 down from (3, 0): object $24
	db $c5, $06, $23  ; 5 down from (6, 0): object $23
	db $c4, $04, $03  ; 4 down from (4, 0): object $03
	db $c5, $05, $03  ; 5 down from (5, 0): object $03
	db $43, $2a  ; (3, 4): object $2A
	db $44, $26  ; (4, 4): object $26
	db $54, $2a  ; (4, 5): object $2A
	db $55, $21  ; (5, 5): object $21
	db $56, $29  ; (6, 5): object $29
	db $63, $a7  ; (3, 6): object $A7
	db $82, $04, $c0  ; 2 across from (4, 0): object $C0
	db $29, $ca  ; (9, 2): object $CA
	db $82, $11, $0f  ; 2 across from (1, 1): object $0F
	db $82, $21, $0f  ; 2 across from (1, 2): object $0F
	db $82, $31, $0f  ; 2 across from (1, 3): object $0F
	db $49, $2a  ; (9, 4): object $2A
	db $59, $0e  ; (9, 5): object $0E
	db $82, $68, $0e  ; 2 across from (8, 6): object $0E
	db $79, $22  ; (9, 7): object $22
	db $22, $a0  ; (2, 2): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $69 of indoor group A: 30 objects, room template 8 and floor object $0D; a warp (type 2) to map $03 room $7C at x 40, y 19. Format: see IndoorARoomPointers.
IndoorARoom69::
	db $0c, $8d  ; animated tiles $0C, template 8, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $04, $ec  ; (4, 0): object $EC
	db $74, $f5  ; (4, 7): object $F5
	db $29, $f7  ; (9, 2): object $F7
	db $50, $f6  ; (0, 5): object $F6
	db $86, $71, $0d  ; 6 across from (1, 7): object $0D
	db $c3, $19, $0d  ; 3 down from (9, 1): object $0D
	db $22, $13  ; (2, 2): object $13
	db $27, $13  ; (7, 2): object $13
	db $42, $12  ; (2, 4): object $12
	db $47, $12  ; (7, 4): object $12
	db $31, $10  ; (1, 3): object $10
	db $36, $10  ; (6, 3): object $10
	db $33, $11  ; (3, 3): object $11
	db $38, $11  ; (8, 3): object $11
	db $32, $1c  ; (2, 3): object $1C
	db $37, $1c  ; (7, 3): object $1C
	db $49, $2c  ; (9, 4): object $2C
	db $c2, $59, $24  ; 2 down from (9, 5): object $24
	db $77, $2c  ; (7, 7): object $2C
	db $78, $22  ; (8, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $20, $c9  ; (0, 2): object $C9
	db $40, $29  ; (0, 4): object $29
	db $82, $50, $0e  ; 2 across from (0, 5): object $0E
	db $82, $60, $0e  ; 2 across from (0, 6): object $0E
	db $70, $2b  ; (0, 7): object $2B
	db $58, $20  ; (8, 5): object $20
	db $82, $67, $20  ; 2 across from (7, 6): object $20
	db $e2, $03, $7c, $28, $13  ; warp type 2 to map $03 room $7C, x 40 y 19
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6A of indoor group A: 25 objects, room template 7 and floor object $0D; a warp (type 2) to map $03 room $7D at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom6A::
	db $0c, $7d  ; animated tiles $0C, template 7, floor $0D
	db $40, $f6  ; (0, 4): object $F6
	db $72, $f5  ; (2, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $49, $ca  ; (9, 4): object $CA
	db $c2, $15, $a6  ; 2 down from (5, 1): object $A6
	db $83, $40, $22  ; 3 across from (0, 4): object $22
	db $43, $2b  ; (3, 4): object $2B
	db $c3, $53, $23  ; 3 down from (3, 5): object $23
	db $45, $a7  ; (5, 4): object $A7
	db $83, $46, $a6  ; 3 across from (6, 4): object $A6
	db $50, $17  ; (0, 5): object $17
	db $51, $a0  ; (1, 5): object $A0
	db $52, $16  ; (2, 5): object $16
	db $c3, $53, $23  ; 3 down from (3, 5): object $23
	db $54, $a7  ; (4, 5): object $A7
	db $55, $de  ; (5, 5): object $DE
	db $56, $a6  ; (6, 5): object $A6
	db $c2, $60, $11  ; 2 down from (0, 6): object $11
	db $71, $0d  ; (1, 7): object $0D
	db $c2, $62, $10  ; 2 down from (2, 6): object $10
	db $83, $16, $0f  ; 3 across from (6, 1): object $0F
	db $83, $26, $0f  ; 3 across from (6, 2): object $0F
	db $83, $36, $0f  ; 3 across from (6, 3): object $0F
	db $27, $be  ; (7, 2): object $BE
	db $e2, $03, $7d, $88, $10  ; warp type 2 to map $03 room $7D, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6B of indoor group A: 22 objects, room template 3 and floor object $0E. Format: see IndoorARoomPointers.
IndoorARoom6B::
	db $0c, $3e  ; animated tiles $0C, template 3, floor $0E
	db $04, $f4  ; (4, 0): object $F4
	db $74, $f5  ; (4, 7): object $F5
	db $c4, $00, $03  ; 4 down from (0, 0): object $03
	db $88, $71, $0d  ; 8 across from (1, 7): object $0D
	db $01, $25  ; (1, 0): object $25
	db $03, $c7  ; (3, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $04, $29  ; (4, 0): object $29
	db $06, $2a  ; (6, 0): object $2A
	db $c3, $11, $23  ; 3 down from (1, 1): object $23
	db $40, $25  ; (0, 4): object $25
	db $41, $29  ; (1, 4): object $29
	db $05, $1b  ; (5, 0): object $1B
	db $84, $15, $1b  ; 4 across from (5, 1): object $1B
	db $c2, $27, $1b  ; 2 down from (7, 2): object $1B
	db $c2, $28, $1b  ; 2 down from (8, 2): object $1B
	db $83, $46, $1b  ; 3 across from (6, 4): object $1B
	db $84, $54, $1b  ; 4 across from (4, 5): object $1B
	db $87, $61, $1b  ; 7 across from (1, 6): object $1B
	db $87, $71, $1b  ; 7 across from (1, 7): object $1B
	db $c2, $58, $0d  ; 2 down from (8, 5): object $0D
	db $c2, $58, $20  ; 2 down from (8, 5): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6C of indoor group A: 23 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom6C::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $04, $f8  ; (4, 0): object $F8
	db $07, $c7  ; (7, 0): object $C7
	db $29, $f7  ; (9, 2): object $F7
	db $87, $12, $b0  ; 7 across from (2, 1): object $B0
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $c6, $11, $01  ; 6 down from (1, 1): object $01
	db $86, $62, $af  ; 6 across from (2, 6): object $AF
	db $38, $af  ; (8, 3): object $AF
	db $c2, $48, $01  ; 2 down from (8, 4): object $01
	db $68, $b0  ; (8, 6): object $B0
	db $19, $2a  ; (9, 1): object $2A
	db $29, $0d  ; (9, 2): object $0D
	db $39, $2c  ; (9, 3): object $2C
	db $49, $24  ; (9, 4): object $24
	db $59, $2a  ; (9, 5): object $2A
	db $69, $0d  ; (9, 6): object $0D
	db $79, $22  ; (9, 7): object $22
	db $22, $a6  ; (2, 2): object $A6
	db $27, $a7  ; (7, 2): object $A7
	db $52, $a6  ; (2, 5): object $A6
	db $57, $a6  ; (7, 5): object $A6
	db $82, $54, $20  ; 2 across from (4, 5): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6D of indoor group A: 34 objects, room template 9 and floor object $0D; a warp (type 2) to map $03 room $5E at x 24, y 19. Format: see IndoorARoomPointers.
IndoorARoom6D::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $05, $f4  ; (5, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $75, $f5  ; (5, 7): object $F5
	db $84, $05, $21  ; 4 across from (5, 0): object $21
	db $88, $71, $0d  ; 8 across from (1, 7): object $0D
	db $c8, $09, $24  ; 8 down from (9, 0): object $24
	db $00, $25  ; (0, 0): object $25
	db $01, $21  ; (1, 0): object $21
	db $02, $26  ; (2, 0): object $26
	db $c4, $03, $03  ; 4 down from (3, 0): object $03
	db $c5, $04, $23  ; 5 down from (4, 0): object $23
	db $10, $29  ; (0, 1): object $29
	db $c2, $12, $24  ; 2 down from (2, 1): object $24
	db $82, $30, $22  ; 2 across from (0, 3): object $22
	db $32, $28  ; (2, 3): object $28
	db $84, $40, $03  ; 4 across from (0, 4): object $03
	db $84, $50, $21  ; 4 across from (0, 5): object $21
	db $54, $29  ; (4, 5): object $29
	db $70, $2b  ; (0, 7): object $2B
	db $04, $25  ; (4, 0): object $25
	db $09, $26  ; (9, 0): object $26
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $52, $c7  ; (2, 5): object $C7
	db $05, $29  ; (5, 0): object $29
	db $06, $0d  ; (6, 0): object $0D
	db $07, $2a  ; (7, 0): object $2A
	db $83, $25, $0f  ; 3 across from (5, 2): object $0F
	db $83, $35, $0f  ; 3 across from (5, 3): object $0F
	db $83, $45, $0f  ; 3 across from (5, 4): object $0F
	db $36, $a0  ; (6, 3): object $A0
	db $11, $be  ; (1, 1): object $BE
	db $e2, $03, $5e, $18, $13  ; warp type 2 to map $03 room $5E, x 24 y 19
	db $15, $20  ; (5, 1): object $20
	db $82, $17, $20  ; 2 across from (7, 1): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6E of indoor group A: 33 objects, room template 2 and floor object $0D; a warp (type 2) to map $03 room $5F at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom6E::
	db $0c, $2d  ; animated tiles $0C, template 2, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $71, $f5  ; (1, 7): object $F5
	db $19, $f7  ; (9, 1): object $F7
	db $14, $a6  ; (4, 1): object $A6
	db $15, $1b  ; (5, 1): object $1B
	db $83, $16, $0e  ; 3 across from (6, 1): object $0E
	db $c2, $19, $1b  ; 2 down from (9, 1): object $1B
	db $21, $a6  ; (1, 2): object $A6
	db $22, $de  ; (2, 2): object $DE
	db $23, $a7  ; (3, 2): object $A7
	db $82, $24, $1b  ; 2 across from (4, 2): object $1B
	db $83, $26, $0e  ; 3 across from (6, 2): object $0E
	db $33, $2c  ; (3, 3): object $2C
	db $34, $22  ; (4, 3): object $22
	db $35, $2b  ; (5, 3): object $2B
	db $36, $a0  ; (6, 3): object $A0
	db $83, $37, $0e  ; 3 across from (7, 3): object $0E
	db $c3, $43, $24  ; 3 down from (3, 4): object $24
	db $c4, $44, $03  ; 4 down from (4, 4): object $03
	db $c4, $45, $23  ; 4 down from (5, 4): object $23
	db $c2, $46, $1b  ; 2 down from (6, 4): object $1B
	db $83, $47, $0e  ; 3 across from (7, 4): object $0E
	db $53, $ca  ; (3, 5): object $CA
	db $55, $c9  ; (5, 5): object $C9
	db $83, $57, $0e  ; 3 across from (7, 5): object $0E
	db $84, $66, $0e  ; 4 across from (6, 6): object $0E
	db $73, $28  ; (3, 7): object $28
	db $84, $76, $0e  ; 4 across from (6, 7): object $0E
	db $79, $0d  ; (9, 7): object $0D
	db $11, $be  ; (1, 1): object $BE
	db $e2, $03, $5f, $88, $10  ; warp type 2 to map $03 room $5F, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $6F of indoor group A: 28 objects, room template 9 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom6F::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $10, $f6  ; (0, 1): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $75, $f5  ; (5, 7): object $F5
	db $00, $29  ; (0, 0): object $29
	db $c8, $07, $24  ; 8 down from (7, 0): object $24
	db $08, $17  ; (8, 0): object $17
	db $c7, $18, $11  ; 7 down from (8, 1): object $11
	db $09, $12  ; (9, 0): object $12
	db $19, $96  ; (9, 1): object $96
	db $c6, $29, $10  ; 6 down from (9, 2): object $10
	db $10, $1b  ; (0, 1): object $1B
	db $87, $20, $1b  ; 7 across from (0, 2): object $1B
	db $c4, $30, $0e  ; 4 down from (0, 3): object $0E
	db $31, $0e  ; (1, 3): object $0E
	db $c2, $32, $1b  ; 2 down from (2, 3): object $1B
	db $c4, $36, $1b  ; 4 down from (6, 3): object $1B
	db $c4, $41, $1b  ; 4 down from (1, 4): object $1B
	db $c2, $55, $0e  ; 2 down from (5, 5): object $0E
	db $82, $75, $0e  ; 2 across from (5, 7): object $0E
	db $27, $ca  ; (7, 2): object $CA
	db $57, $ca  ; (7, 5): object $CA
	db $84, $13, $1b  ; 4 across from (3, 1): object $1B
	db $82, $24, $0d  ; 2 across from (4, 2): object $0D
	db $82, $33, $1b  ; 2 across from (3, 3): object $1B
	db $35, $0d  ; (5, 3): object $0D
	db $82, $44, $1b  ; 2 across from (4, 4): object $1B
	db $25, $c0  ; (5, 2): object $C0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $70 of indoor group A: 33 objects, room template 1 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom70::
	db $0c, $1d  ; animated tiles $0C, template 1, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $10, $f6  ; (0, 1): object $F6
	db $29, $f7  ; (9, 2): object $F7
	db $73, $f5  ; (3, 7): object $F5
	db $00, $93  ; (0, 0): object $93
	db $02, $10  ; (2, 0): object $10
	db $c2, $03, $23  ; 2 down from (3, 0): object $23
	db $c2, $09, $24  ; 2 down from (9, 0): object $24
	db $10, $13  ; (0, 1): object $13
	db $12, $14  ; (2, 1): object $14
	db $20, $25  ; (0, 2): object $25
	db $21, $98  ; (1, 2): object $98
	db $22, $21  ; (2, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $29, $2a  ; (9, 2): object $2A
	db $39, $0d  ; (9, 3): object $0D
	db $49, $2c  ; (9, 4): object $2C
	db $50, $c9  ; (0, 5): object $C9
	db $59, $ca  ; (9, 5): object $CA
	db $73, $2b  ; (3, 7): object $2B
	db $85, $74, $0d  ; 5 across from (4, 7): object $0D
	db $79, $24  ; (9, 7): object $24
	db $85, $24, $a6  ; 5 across from (4, 2): object $A6
	db $86, $43, $a6  ; 6 across from (3, 4): object $A6
	db $25, $af  ; (5, 2): object $AF
	db $35, $01  ; (5, 3): object $01
	db $45, $b0  ; (5, 4): object $B0
	db $34, $ae  ; (4, 3): object $AE
	db $36, $ae  ; (6, 3): object $AE
	db $82, $41, $af  ; 2 across from (1, 4): object $AF
	db $82, $51, $01  ; 2 across from (1, 5): object $01
	db $53, $af  ; (3, 5): object $AF
	db $83, $61, $b0  ; 3 across from (1, 6): object $B0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $71 of indoor group A: 23 objects, room template 1 and floor object $0E. Format: see IndoorARoomPointers.
IndoorARoom71::
	db $0c, $1e  ; animated tiles $0C, template 1, floor $0E
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $10, $c9  ; (0, 1): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $20, $29  ; (0, 2): object $29
	db $88, $01, $1b  ; 8 across from (1, 0): object $1B
	db $86, $11, $1b  ; 6 across from (1, 1): object $1B
	db $84, $23, $1b  ; 4 across from (3, 2): object $1B
	db $83, $33, $1b  ; 3 across from (3, 3): object $1B
	db $83, $43, $1b  ; 3 across from (3, 4): object $1B
	db $82, $52, $1b  ; 2 across from (2, 5): object $1B
	db $83, $61, $1b  ; 3 across from (1, 6): object $1B
	db $37, $a0  ; (7, 3): object $A0
	db $47, $a7  ; (7, 4): object $A7
	db $46, $a9  ; (6, 4): object $A9
	db $28, $0e  ; (8, 2): object $0E
	db $57, $0e  ; (7, 5): object $0E
	db $82, $65, $0e  ; 2 across from (5, 6): object $0E
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $c4, $21, $0d  ; 4 down from (1, 2): object $0D
	db $c4, $12, $0d  ; 4 down from (2, 1): object $0D
	db $40, $2b  ; (0, 4): object $2B
	db $c2, $51, $20  ; 2 down from (1, 5): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $72 of indoor group A: 39 objects, room template 9 and floor object $0E; a warp (type 2) to map $03 room $1E at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom72::
	db $0c, $9e  ; animated tiles $0C, template 9, floor $0E
	db $04, $f4  ; (4, 0): object $F4
	db $19, $f7  ; (9, 1): object $F7
	db $73, $f5  ; (3, 7): object $F5
	db $c3, $00, $23  ; 3 down from (0, 0): object $23
	db $88, $01, $0d  ; 8 across from (1, 0): object $0D
	db $c2, $09, $24  ; 2 down from (9, 0): object $24
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $30, $27  ; (0, 3): object $27
	db $84, $31, $22  ; 4 across from (1, 3): object $22
	db $35, $2b  ; (5, 3): object $2B
	db $c3, $45, $23  ; 3 down from (5, 4): object $23
	db $10, $c9  ; (0, 1): object $C9
	db $32, $c8  ; (2, 3): object $C8
	db $40, $17  ; (0, 4): object $17
	db $82, $41, $12  ; 2 across from (1, 4): object $12
	db $c3, $50, $11  ; 3 down from (0, 5): object $11
	db $c4, $44, $10  ; 4 down from (4, 4): object $10
	db $83, $51, $0f  ; 3 across from (1, 5): object $0F
	db $83, $61, $0f  ; 3 across from (1, 6): object $0F
	db $83, $71, $0f  ; 3 across from (1, 7): object $0F
	db $75, $27  ; (5, 7): object $27
	db $84, $76, $22  ; 4 across from (6, 7): object $22
	db $77, $c8  ; (7, 7): object $C8
	db $c2, $09, $24  ; 2 down from (9, 0): object $24
	db $88, $11, $1b  ; 8 across from (1, 1): object $1B
	db $86, $21, $1b  ; 6 across from (1, 2): object $1B
	db $82, $27, $0e  ; 2 across from (7, 2): object $0E
	db $29, $2a  ; (9, 2): object $2A
	db $c4, $36, $1b  ; 4 down from (6, 3): object $1B
	db $83, $37, $0e  ; 3 across from (7, 3): object $0E
	db $83, $47, $0e  ; 3 across from (7, 4): object $0E
	db $83, $57, $0e  ; 3 across from (7, 5): object $0E
	db $83, $67, $1b  ; 3 across from (7, 6): object $1B
	db $82, $11, $0d  ; 2 across from (1, 1): object $0D
	db $82, $21, $0d  ; 2 across from (1, 2): object $0D
	db $43, $0d  ; (3, 4): object $0D
	db $62, $be  ; (2, 6): object $BE
	db $e2, $03, $1e, $18, $10  ; warp type 2 to map $03 room $1E, x 24 y 16
	db $c2, $11, $20  ; 2 down from (1, 1): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $73 of indoor group A: 32 objects, room template 9 and floor object $0E. Format: see IndoorARoomPointers.
IndoorARoom73::
	db $0c, $9e  ; animated tiles $0C, template 9, floor $0E
	db $01, $f0  ; (1, 0): object $F0
	db $10, $f6  ; (0, 1): object $F6
	db $59, $f7  ; (9, 5): object $F7
	db $75, $f5  ; (5, 7): object $F5
	db $00, $25  ; (0, 0): object $25
	db $03, $26  ; (3, 0): object $26
	db $c2, $04, $03  ; 2 down from (4, 0): object $03
	db $c2, $05, $23  ; 2 down from (5, 0): object $23
	db $09, $0d  ; (9, 0): object $0D
	db $10, $23  ; (0, 1): object $23
	db $82, $11, $0d  ; 2 across from (1, 1): object $0D
	db $13, $24  ; (3, 1): object $24
	db $20, $29  ; (0, 2): object $29
	db $23, $2a  ; (3, 2): object $2A
	db $24, $21  ; (4, 2): object $21
	db $25, $29  ; (5, 2): object $29
	db $26, $1b  ; (6, 2): object $1B
	db $84, $34, $1b  ; 4 across from (4, 3): object $1B
	db $86, $44, $1b  ; 6 across from (4, 4): object $1B
	db $82, $53, $1b  ; 2 across from (3, 5): object $1B
	db $55, $2c  ; (5, 5): object $2C
	db $84, $56, $22  ; 4 across from (6, 5): object $22
	db $57, $c8  ; (7, 5): object $C8
	db $85, $60, $1b  ; 5 across from (0, 6): object $1B
	db $65, $24  ; (5, 6): object $24
	db $66, $17  ; (6, 6): object $17
	db $83, $67, $12  ; 3 across from (7, 6): object $12
	db $85, $70, $22  ; 5 across from (0, 7): object $22
	db $75, $28  ; (5, 7): object $28
	db $76, $11  ; (6, 7): object $11
	db $83, $77, $0d  ; 3 across from (7, 7): object $0D
	db $12, $aa  ; (2, 1): object $AA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $74 of indoor group A: 21 objects, room template 9 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom74::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $05, $f4  ; (5, 0): object $F4
	db $10, $f6  ; (0, 1): object $F6
	db $74, $f5  ; (4, 7): object $F5
	db $82, $05, $0e  ; 2 across from (5, 0): object $0E
	db $c5, $07, $24  ; 5 down from (7, 0): object $24
	db $c6, $08, $11  ; 6 down from (8, 0): object $11
	db $c8, $09, $10  ; 8 down from (9, 0): object $10
	db $83, $10, $0e  ; 3 across from (0, 1): object $0E
	db $16, $0e  ; (6, 1): object $0E
	db $87, $20, $0e  ; 7 across from (0, 2): object $0E
	db $85, $30, $0e  ; 5 across from (0, 3): object $0E
	db $82, $35, $1b  ; 2 across from (5, 3): object $1B
	db $87, $40, $1b  ; 7 across from (0, 4): object $1B
	db $42, $0e  ; (2, 4): object $0E
	db $27, $ca  ; (7, 2): object $CA
	db $87, $50, $22  ; 7 across from (0, 5): object $22
	db $52, $c8  ; (2, 5): object $C8
	db $57, $28  ; (7, 5): object $28
	db $88, $60, $12  ; 8 across from (0, 6): object $12
	db $68, $93  ; (8, 6): object $93
	db $89, $70, $0d  ; 9 across from (0, 7): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $75 of indoor group A: 29 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom75::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $76, $ed  ; (6, 7): object $ED
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $03, $29  ; (3, 0): object $29
	db $04, $0d  ; (4, 0): object $0D
	db $05, $2a  ; (5, 0): object $2A
	db $09, $24  ; (9, 0): object $24
	db $85, $11, $0e  ; 5 across from (1, 1): object $0E
	db $c2, $18, $1b  ; 2 down from (8, 1): object $1B
	db $c3, $21, $0f  ; 3 down from (1, 2): object $0F
	db $85, $22, $0e  ; 5 across from (2, 2): object $0E
	db $32, $a0  ; (2, 3): object $A0
	db $84, $33, $0e  ; 4 across from (3, 3): object $0E
	db $82, $37, $1b  ; 2 across from (7, 3): object $1B
	db $42, $0f  ; (2, 4): object $0F
	db $84, $43, $0e  ; 4 across from (3, 4): object $0E
	db $82, $47, $1b  ; 2 across from (7, 4): object $1B
	db $85, $51, $0e  ; 5 across from (1, 5): object $0E
	db $83, $56, $1b  ; 3 across from (6, 5): object $1B
	db $84, $61, $0e  ; 4 across from (1, 6): object $0E
	db $84, $65, $1b  ; 4 across from (5, 6): object $1B
	db $09, $26  ; (9, 0): object $26
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $84, $05, $0d  ; 4 across from (5, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $21, $20  ; (1, 2): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $76 of indoor group A: 31 objects, room template 2 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom76::
	db $0c, $2d  ; animated tiles $0C, template 2, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $10, $f7  ; (0, 1): object $F7
	db $c3, $00, $11  ; 3 down from (0, 0): object $11
	db $83, $01, $0f  ; 3 across from (1, 0): object $0F
	db $83, $11, $0f  ; 3 across from (1, 1): object $0F
	db $83, $21, $0f  ; 3 across from (1, 2): object $0F
	db $c3, $04, $10  ; 3 down from (4, 0): object $10
	db $85, $05, $12  ; 5 across from (5, 0): object $12
	db $30, $15  ; (0, 3): object $15
	db $83, $31, $13  ; 3 across from (1, 3): object $13
	db $34, $14  ; (4, 3): object $14
	db $85, $15, $13  ; 5 across from (5, 1): object $13
	db $40, $25  ; (0, 4): object $25
	db $84, $41, $21  ; 4 across from (1, 4): object $21
	db $45, $29  ; (5, 4): object $29
	db $25, $25  ; (5, 2): object $25
	db $84, $26, $21  ; 4 across from (6, 2): object $21
	db $35, $23  ; (5, 3): object $23
	db $27, $c7  ; (7, 2): object $C7
	db $42, $c7  ; (2, 4): object $C7
	db $84, $36, $1b  ; 4 across from (6, 3): object $1B
	db $85, $51, $1b  ; 5 across from (1, 5): object $1B
	db $84, $46, $1b  ; 4 across from (6, 4): object $1B
	db $84, $56, $1b  ; 4 across from (6, 5): object $1B
	db $89, $61, $1b  ; 9 across from (1, 6): object $1B
	db $12, $a0  ; (2, 1): object $A0
	db $48, $a6  ; (8, 4): object $A6
	db $82, $46, $0e  ; 2 across from (6, 4): object $0E
	db $86, $52, $0e  ; 6 across from (2, 5): object $0E
	db $83, $63, $0e  ; 3 across from (3, 6): object $0E
	db $c2, $51, $20  ; 2 down from (1, 5): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $77 of indoor group A: 29 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom77::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $74, $f5  ; (4, 7): object $F5
	db $8a, $00, $0d  ; 10 across from (0, 0): object $0D
	db $86, $00, $12  ; 6 across from (0, 0): object $12
	db $06, $93  ; (6, 0): object $93
	db $83, $07, $0d  ; 3 across from (7, 0): object $0D
	db $8a, $10, $13  ; 10 across from (0, 1): object $13
	db $15, $0d  ; (5, 1): object $0D
	db $89, $20, $21  ; 9 across from (0, 2): object $21
	db $22, $c7  ; (2, 2): object $C7
	db $27, $c7  ; (7, 2): object $C7
	db $25, $98  ; (5, 2): object $98
	db $29, $26  ; (9, 2): object $26
	db $89, $30, $1b  ; 9 across from (0, 3): object $1B
	db $35, $1b  ; (5, 3): object $1B
	db $c4, $39, $24  ; 4 down from (9, 3): object $24
	db $89, $40, $1b  ; 9 across from (0, 4): object $1B
	db $89, $50, $1b  ; 9 across from (0, 5): object $1B
	db $89, $60, $1b  ; 9 across from (0, 6): object $1B
	db $41, $a6  ; (1, 4): object $A6
	db $44, $a6  ; (4, 4): object $A6
	db $47, $a6  ; (7, 4): object $A6
	db $89, $70, $22  ; 9 across from (0, 7): object $22
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $1b  ; 2 across from (4, 7): object $1B
	db $76, $2c  ; (6, 7): object $2C
	db $79, $28  ; (9, 7): object $28
	db $49, $f3  ; (9, 4): object $F3
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $78 of indoor group A: 21 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom78::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $40, $f2  ; (0, 4): object $F2
	db $59, $ef  ; (9, 5): object $EF
	db $74, $f1  ; (4, 7): object $F1
	db $8a, $00, $0d  ; 10 across from (0, 0): object $0D
	db $09, $94  ; (9, 0): object $94
	db $8a, $10, $13  ; 10 across from (0, 1): object $13
	db $20, $25  ; (0, 2): object $25
	db $88, $21, $21  ; 8 across from (1, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $22, $c7  ; (2, 2): object $C7
	db $27, $c7  ; (7, 2): object $C7
	db $84, $31, $1b  ; 4 across from (1, 3): object $1B
	db $83, $35, $0f  ; 3 across from (5, 3): object $0F
	db $85, $41, $1b  ; 5 across from (1, 4): object $1B
	db $86, $51, $1b  ; 6 across from (1, 5): object $1B
	db $88, $61, $1b  ; 8 across from (1, 6): object $1B
	db $c2, $47, $0f  ; 2 down from (7, 4): object $0F
	db $55, $0f  ; (5, 5): object $0F
	db $43, $a6  ; (3, 4): object $A6
	db $46, $a0  ; (6, 4): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $79 of indoor group A: 30 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom79::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $05, $c7  ; (5, 0): object $C7
	db $06, $ec  ; (6, 0): object $EC
	db $08, $c7  ; (8, 0): object $C7
	db $49, $ca  ; (9, 4): object $CA
	db $50, $ee  ; (0, 5): object $EE
	db $82, $00, $12  ; 2 across from (0, 0): object $12
	db $02, $16  ; (2, 0): object $16
	db $03, $25  ; (3, 0): object $25
	db $10, $13  ; (0, 1): object $13
	db $12, $14  ; (2, 1): object $14
	db $13, $23  ; (3, 1): object $23
	db $c3, $14, $0f  ; 3 down from (4, 1): object $0F
	db $c3, $15, $c0  ; 3 down from (5, 1): object $C0
	db $83, $16, $1b  ; 3 across from (6, 1): object $1B
	db $20, $25  ; (0, 2): object $25
	db $21, $98  ; (1, 2): object $98
	db $22, $21  ; (2, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $24, $a0  ; (4, 2): object $A0
	db $83, $26, $1b  ; 3 across from (6, 2): object $1B
	db $33, $0e  ; (3, 3): object $0E
	db $83, $36, $0e  ; 3 across from (6, 3): object $0E
	db $84, $41, $c0  ; 4 across from (1, 4): object $C0
	db $83, $45, $0e  ; 3 across from (5, 4): object $0E
	db $c2, $48, $1b  ; 2 down from (8, 4): object $1B
	db $52, $1b  ; (2, 5): object $1B
	db $85, $53, $0e  ; 5 across from (3, 5): object $0E
	db $87, $62, $1b  ; 7 across from (2, 6): object $1B
	db $64, $0e  ; (4, 6): object $0E
	db $84, $31, $0f  ; 4 across from (1, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7A of indoor group A: 19 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $2B at x 72, y 34. Format: see IndoorARoomPointers.
IndoorARoom7A::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $1b  ; 2 across from (4, 0): object $1B
	db $06, $2a  ; (6, 0): object $2A
	db $88, $11, $1b  ; 8 across from (1, 1): object $1B
	db $82, $14, $1b  ; 2 across from (4, 1): object $1B
	db $88, $21, $1b  ; 8 across from (1, 2): object $1B
	db $88, $31, $1b  ; 8 across from (1, 3): object $1B
	db $88, $41, $1b  ; 8 across from (1, 4): object $1B
	db $88, $51, $1b  ; 8 across from (1, 5): object $1B
	db $88, $61, $1b  ; 8 across from (1, 6): object $1B
	db $c2, $23, $c0  ; 2 down from (3, 2): object $C0
	db $c2, $26, $c0  ; 2 down from (6, 2): object $C0
	db $84, $43, $0d  ; 4 across from (3, 4): object $0D
	db $86, $52, $0d  ; 6 across from (2, 5): object $0D
	db $86, $62, $0d  ; 6 across from (2, 6): object $0D
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $2b, $48, $22  ; warp type 0 to map $00 room $2B, x 72 y 34
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7B of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom7B::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $88, $11, $1b  ; 8 across from (1, 1): object $1B
	db $88, $21, $1b  ; 8 across from (1, 2): object $1B
	db $88, $31, $1b  ; 8 across from (1, 3): object $1B
	db $88, $41, $1b  ; 8 across from (1, 4): object $1B
	db $88, $51, $1b  ; 8 across from (1, 5): object $1B
	db $88, $61, $1b  ; 8 across from (1, 6): object $1B
	db $84, $23, $0e  ; 4 across from (3, 2): object $0E
	db $c2, $33, $c0  ; 2 down from (3, 3): object $C0
	db $82, $34, $dd  ; 2 across from (4, 3): object $DD
	db $c2, $36, $c0  ; 2 down from (6, 3): object $C0
	db $c3, $37, $dd  ; 3 down from (7, 3): object $DD
	db $c2, $38, $0e  ; 2 down from (8, 3): object $0E
	db $c3, $42, $0e  ; 3 down from (2, 4): object $0E
	db $85, $53, $dd  ; 5 across from (3, 5): object $DD
	db $84, $64, $0e  ; 4 across from (4, 6): object $0E
	db $45, $0d  ; (5, 4): object $0D
	db $44, $a0  ; (4, 4): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7C of indoor group A: 21 objects, room template 9 and floor object $04. Format: see IndoorARoomPointers.
IndoorARoom7C::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $83, $02, $6b  ; 3 across from (2, 0): object $6B
	db $03, $69  ; (3, 0): object $69
	db $83, $12, $69  ; 3 across from (2, 1): object $69
	db $13, $82  ; (3, 1): object $82
	db $83, $06, $6b  ; 3 across from (6, 0): object $6B
	db $07, $69  ; (7, 0): object $69
	db $83, $16, $69  ; 3 across from (6, 1): object $69
	db $17, $82  ; (7, 1): object $82
	db $c3, $00, $6c  ; 3 down from (0, 0): object $6C
	db $8a, $30, $6d  ; 10 across from (0, 3): object $6D
	db $82, $33, $04  ; 2 across from (3, 3): object $04
	db $37, $62  ; (7, 3): object $62
	db $47, $63  ; (7, 4): object $63
	db $c4, $40, $57  ; 4 down from (0, 4): object $57
	db $87, $51, $80  ; 7 across from (1, 5): object $80
	db $87, $61, $81  ; 7 across from (1, 6): object $81
	db $87, $71, $53  ; 7 across from (1, 7): object $53
	db $c2, $57, $67  ; 2 down from (7, 5): object $67
	db $c3, $48, $51  ; 3 down from (8, 4): object $51
	db $c3, $49, $54  ; 3 down from (9, 4): object $54
	db $82, $78, $54  ; 2 across from (8, 7): object $54
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7D of indoor group A: 16 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $6A at x 120, y 48. Format: see IndoorARoomPointers.
IndoorARoom7D::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $83, $03, $6b  ; 3 across from (3, 0): object $6B
	db $04, $69  ; (4, 0): object $69
	db $83, $13, $69  ; 3 across from (3, 1): object $69
	db $14, $82  ; (4, 1): object $82
	db $c3, $08, $65  ; 3 down from (8, 0): object $65
	db $c3, $09, $6c  ; 3 down from (9, 0): object $6C
	db $30, $6d  ; (0, 3): object $6D
	db $31, $64  ; (1, 3): object $64
	db $c2, $41, $65  ; 2 down from (1, 4): object $65
	db $83, $37, $6d  ; 3 across from (7, 3): object $6D
	db $c3, $40, $57  ; 3 down from (0, 4): object $57
	db $83, $61, $5b  ; 3 across from (1, 6): object $5B
	db $84, $64, $4c  ; 4 across from (4, 6): object $4C
	db $c3, $48, $51  ; 3 down from (8, 4): object $51
	db $c3, $49, $54  ; 3 down from (9, 4): object $54
	db $8a, $70, $54  ; 10 across from (0, 7): object $54
	db $e1, $03, $6a, $78, $30  ; warp type 1 to map $03 room $6A, x 120 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $7E of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom7E::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $80 of indoor group A: 12 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom80::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $39, $f3  ; (9, 3): object $F3
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $86, $42, $0f  ; 6 across from (2, 4): object $0F
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $53, $0f  ; (3, 5): object $0F
	db $56, $0f  ; (6, 5): object $0F
	db $11, $a6  ; (1, 1): object $A6
	db $18, $a6  ; (8, 1): object $A6
	db $61, $a6  ; (1, 6): object $A6
	db $68, $a6  ; (8, 6): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $81 of indoor group A: 12 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A8 at x 24, y 19. Format: see IndoorARoomPointers.
IndoorARoom81::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $84, $23, $dd  ; 4 across from (3, 2): object $DD
	db $86, $32, $dd  ; 6 across from (2, 3): object $DD
	db $86, $42, $dd  ; 6 across from (2, 4): object $DD
	db $84, $53, $dd  ; 4 across from (3, 5): object $DD
	db $33, $a7  ; (3, 3): object $A7
	db $36, $a7  ; (6, 3): object $A7
	db $44, $a6  ; (4, 4): object $A6
	db $45, $a6  ; (5, 4): object $A6
	db $48, $dd  ; (8, 4): object $DD
	db $66, $dd  ; (6, 6): object $DD
	db $68, $be  ; (8, 6): object $BE
	db $e2, $04, $a8, $18, $13  ; warp type 2 to map $04 room $A8, x 24 y 19
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $82 of indoor group A: 20 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $D9 at x 88, y 64. Format: see IndoorARoomPointers.
IndoorARoom82::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
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
	db $e0, $00, $d9, $58, $40  ; warp type 0 to map $00 room $D9, x 88 y 64
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $83 of indoor group A: 21 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom83::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $59, $f3  ; (9, 5): object $F3
	db $c8, $00, $03  ; 8 down from (0, 0): object $03
	db $c8, $01, $03  ; 8 down from (1, 0): object $03
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $83, $17, $03  ; 3 across from (7, 1): object $03
	db $83, $27, $03  ; 3 across from (7, 2): object $03
	db $83, $37, $03  ; 3 across from (7, 3): object $03
	db $02, $25  ; (2, 0): object $25
	db $83, $03, $21  ; 3 across from (3, 0): object $21
	db $06, $26  ; (6, 0): object $26
	db $c6, $12, $23  ; 6 down from (2, 1): object $23
	db $c3, $16, $24  ; 3 down from (6, 1): object $24
	db $46, $2a  ; (6, 4): object $2A
	db $82, $47, $21  ; 2 across from (7, 4): object $21
	db $49, $26  ; (9, 4): object $26
	db $72, $27  ; (2, 7): object $27
	db $83, $13, $0f  ; 3 across from (3, 1): object $0F
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $24, $a0  ; (4, 2): object $A0
	db $c2, $56, $20  ; 2 down from (6, 5): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $84 of indoor group A: 12 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom84::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $50, $f2  ; (0, 5): object $F2
	db $74, $f1  ; (4, 7): object $F1
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $86, $42, $0f  ; 6 across from (2, 4): object $0F
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $53, $0f  ; (3, 5): object $0F
	db $56, $0f  ; (6, 5): object $0F
	db $11, $a6  ; (1, 1): object $A6
	db $18, $a6  ; (8, 1): object $A6
	db $68, $a6  ; (8, 6): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $85 of indoor group A: 6 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom85::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $52, $0f  ; 6 across from (2, 5): object $0F
	db $c2, $32, $0f  ; 2 down from (2, 3): object $0F
	db $c2, $37, $0f  ; 2 down from (7, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $86 of indoor group A: 21 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A2 at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom86::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $83, $11, $0f  ; 3 across from (1, 1): object $0F
	db $83, $21, $0f  ; 3 across from (1, 2): object $0F
	db $83, $31, $0f  ; 3 across from (1, 3): object $0F
	db $22, $a0  ; (2, 2): object $A0
	db $04, $26  ; (4, 0): object $26
	db $05, $25  ; (5, 0): object $25
	db $c2, $14, $24  ; 2 down from (4, 1): object $24
	db $c2, $15, $23  ; 2 down from (5, 1): object $23
	db $34, $2a  ; (4, 3): object $2A
	db $35, $29  ; (5, 3): object $29
	db $83, $26, $af  ; 3 across from (6, 2): object $AF
	db $83, $36, $01  ; 3 across from (6, 3): object $01
	db $41, $af  ; (1, 4): object $AF
	db $43, $af  ; (3, 4): object $AF
	db $85, $44, $01  ; 5 across from (4, 4): object $01
	db $c2, $51, $01  ; 2 down from (1, 5): object $01
	db $86, $53, $b0  ; 6 across from (3, 5): object $B0
	db $82, $57, $01  ; 2 across from (7, 5): object $01
	db $67, $9f  ; (7, 6): object $9F
	db $68, $b0  ; (8, 6): object $B0
	db $18, $be  ; (8, 1): object $BE
	db $e2, $04, $a2, $18, $10  ; warp type 2 to map $04 room $A2, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $87 of indoor group A: 21 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom87::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $39, $f7  ; (9, 3): object $F7
	db $71, $f5  ; (1, 7): object $F5
	db $29, $2a  ; (9, 2): object $2A
	db $39, $0d  ; (9, 3): object $0D
	db $49, $2c  ; (9, 4): object $2C
	db $71, $2b  ; (1, 7): object $2B
	db $72, $0d  ; (2, 7): object $0D
	db $73, $2c  ; (3, 7): object $2C
	db $82, $11, $a6  ; 2 across from (1, 1): object $A6
	db $82, $22, $a6  ; 2 across from (2, 2): object $A6
	db $33, $a7  ; (3, 3): object $A7
	db $82, $44, $a6  ; 2 across from (4, 4): object $A6
	db $55, $a7  ; (5, 5): object $A7
	db $82, $66, $a6  ; 2 across from (6, 6): object $A6
	db $18, $20  ; (8, 1): object $20
	db $21, $20  ; (1, 2): object $20
	db $34, $20  ; (4, 3): object $20
	db $56, $20  ; (6, 5): object $20
	db $61, $20  ; (1, 6): object $20
	db $68, $20  ; (8, 6): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $88 of indoor group A: 23 objects, room template 3 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom88::
	db $0c, $3d  ; animated tiles $0C, template 3, floor $0D
	db $20, $f6  ; (0, 2): object $F6
	db $77, $f5  ; (7, 7): object $F5
	db $82, $77, $0d  ; 2 across from (7, 7): object $0D
	db $30, $0d  ; (0, 3): object $0D
	db $74, $0d  ; (4, 7): object $0D
	db $20, $29  ; (0, 2): object $29
	db $30, $0d  ; (0, 3): object $0D
	db $40, $2b  ; (0, 4): object $2B
	db $11, $a6  ; (1, 1): object $A6
	db $84, $13, $b0  ; 4 across from (3, 1): object $B0
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $84, $23, $a6  ; 4 across from (3, 2): object $A6
	db $27, $0f  ; (7, 2): object $0F
	db $37, $af  ; (7, 3): object $AF
	db $c5, $36, $a6  ; 5 down from (6, 3): object $A6
	db $38, $01  ; (8, 3): object $01
	db $82, $47, $01  ; 2 across from (7, 4): object $01
	db $82, $57, $01  ; 2 across from (7, 5): object $01
	db $82, $67, $b0  ; 2 across from (7, 6): object $B0
	db $28, $9e  ; (8, 2): object $9E
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $18, $a0  ; (8, 1): object $A0
	db $83, $62, $20  ; 3 across from (2, 6): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $89 of indoor group A: 9 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A6 at x 24, y 19. Format: see IndoorARoomPointers.
IndoorARoom89::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $59, $f3  ; (9, 5): object $F3
	db $82, $24, $c0  ; 2 across from (4, 2): object $C0
	db $82, $54, $c0  ; 2 across from (4, 5): object $C0
	db $41, $ac  ; (1, 4): object $AC
	db $48, $ac  ; (8, 4): object $AC
	db $11, $be  ; (1, 1): object $BE
	db $e2, $04, $a6, $18, $13  ; warp type 2 to map $04 room $A6, x 24 y 19
	db $82, $17, $20  ; 2 across from (7, 1): object $20
	db $28, $20  ; (8, 2): object $20
	db $82, $61, $20  ; 2 across from (1, 6): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8A of indoor group A: 14 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom8A::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $50, $f2  ; (0, 5): object $F2
	db $59, $f3  ; (9, 5): object $F3
	db $c4, $00, $03  ; 4 down from (0, 0): object $03
	db $c4, $01, $03  ; 4 down from (1, 0): object $03
	db $c4, $09, $03  ; 4 down from (9, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $40, $25  ; (0, 4): object $25
	db $41, $21  ; (1, 4): object $21
	db $42, $29  ; (2, 4): object $29
	db $c3, $12, $23  ; 3 down from (2, 1): object $23
	db $c3, $18, $24  ; 3 down from (8, 1): object $24
	db $48, $2a  ; (8, 4): object $2A
	db $49, $26  ; (9, 4): object $26
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8B of indoor group A: 17 objects, room template 2 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom8B::
	db $0c, $2d  ; animated tiles $0C, template 2, floor $0D
	db $39, $f7  ; (9, 3): object $F7
	db $04, $f8  ; (4, 0): object $F8
	db $50, $f6  ; (0, 5): object $F6
	db $82, $14, $0f  ; 2 across from (4, 1): object $0F
	db $20, $27  ; (0, 2): object $27
	db $87, $21, $22  ; 7 across from (1, 2): object $22
	db $28, $2b  ; (8, 2): object $2B
	db $29, $a6  ; (9, 2): object $A6
	db $38, $27  ; (8, 3): object $27
	db $39, $22  ; (9, 3): object $22
	db $40, $25  ; (0, 4): object $25
	db $85, $41, $21  ; 5 across from (1, 4): object $21
	db $46, $26  ; (6, 4): object $26
	db $56, $2a  ; (6, 5): object $2A
	db $83, $57, $21  ; 3 across from (7, 5): object $21
	db $88, $30, $03  ; 8 across from (0, 3): object $03
	db $83, $47, $03  ; 3 across from (7, 4): object $03
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8C of indoor group A: 19 objects, room template 4 and floor object $0D; a warp (type 2) to map $04 room $A4 at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoom8C::
	db $0c, $4d  ; animated tiles $0C, template 4, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $20, $a6  ; (0, 2): object $A6
	db $30, $22  ; (0, 3): object $22
	db $31, $2b  ; (1, 3): object $2B
	db $40, $03  ; (0, 4): object $03
	db $41, $23  ; (1, 4): object $23
	db $50, $21  ; (0, 5): object $21
	db $51, $29  ; (1, 5): object $29
	db $84, $12, $01  ; 4 across from (2, 1): object $01
	db $84, $22, $01  ; 4 across from (2, 2): object $01
	db $84, $32, $01  ; 4 across from (2, 3): object $01
	db $84, $42, $01  ; 4 across from (2, 4): object $01
	db $84, $52, $b0  ; 4 across from (2, 5): object $B0
	db $c2, $27, $a6  ; 2 down from (7, 2): object $A6
	db $82, $46, $a6  ; 2 across from (6, 4): object $A6
	db $48, $de  ; (8, 4): object $DE
	db $56, $a6  ; (6, 5): object $A6
	db $57, $be  ; (7, 5): object $BE
	db $e2, $04, $a4, $18, $10  ; warp type 2 to map $04 room $A4, x 24 y 16
	db $67, $a7  ; (7, 6): object $A7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8D of indoor group A: 21 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A3 at x 72, y 16. Format: see IndoorARoomPointers.
IndoorARoom8D::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $71, $f5  ; (1, 7): object $F5
	db $01, $29  ; (1, 0): object $29
	db $02, $0d  ; (2, 0): object $0D
	db $03, $2a  ; (3, 0): object $2A
	db $71, $2b  ; (1, 7): object $2B
	db $72, $1b  ; (2, 7): object $1B
	db $73, $2c  ; (3, 7): object $2C
	db $05, $c7  ; (5, 0): object $C7
	db $75, $c8  ; (5, 7): object $C8
	db $40, $c9  ; (0, 4): object $C9
	db $49, $ca  ; (9, 4): object $CA
	db $88, $11, $1b  ; 8 across from (1, 1): object $1B
	db $88, $21, $1b  ; 8 across from (1, 2): object $1B
	db $88, $31, $1b  ; 8 across from (1, 3): object $1B
	db $88, $41, $1b  ; 8 across from (1, 4): object $1B
	db $88, $51, $1b  ; 8 across from (1, 5): object $1B
	db $88, $61, $1b  ; 8 across from (1, 6): object $1B
	db $83, $34, $0e  ; 3 across from (4, 3): object $0E
	db $83, $44, $0e  ; 3 across from (4, 4): object $0E
	db $83, $54, $0e  ; 3 across from (4, 5): object $0E
	db $e2, $04, $a3, $48, $10  ; warp type 2 to map $04 room $A3, x 72 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8E of indoor group A: 32 objects, room template 1 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom8E::
	db $0c, $1d  ; animated tiles $0C, template 1, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $19, $f7  ; (9, 1): object $F7
	db $73, $f5  ; (3, 7): object $F5
	db $c5, $06, $a6  ; 5 down from (6, 0): object $A6
	db $82, $07, $0f  ; 2 across from (7, 0): object $0F
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $82, $27, $0f  ; 2 across from (7, 2): object $0F
	db $09, $2a  ; (9, 0): object $2A
	db $19, $0d  ; (9, 1): object $0D
	db $29, $a6  ; (9, 2): object $A6
	db $17, $a0  ; (7, 1): object $A0
	db $29, $a6  ; (9, 2): object $A6
	db $38, $2c  ; (8, 3): object $2C
	db $48, $2a  ; (8, 4): object $2A
	db $39, $22  ; (9, 3): object $22
	db $49, $21  ; (9, 4): object $21
	db $59, $0d  ; (9, 5): object $0D
	db $37, $af  ; (7, 3): object $AF
	db $47, $01  ; (7, 4): object $01
	db $57, $b0  ; (7, 5): object $B0
	db $82, $52, $a6  ; 2 across from (2, 5): object $A6
	db $63, $af  ; (3, 6): object $AF
	db $82, $64, $ae  ; 2 across from (4, 6): object $AE
	db $66, $af  ; (6, 6): object $AF
	db $68, $a6  ; (8, 6): object $A6
	db $69, $2c  ; (9, 6): object $2C
	db $c2, $21, $df  ; 2 down from (1, 2): object $DF
	db $35, $df  ; (5, 3): object $DF
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $c2, $13, $20  ; 2 down from (3, 1): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $8F of indoor group A: 21 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom8F::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $40, $f6  ; (0, 4): object $F6
	db $00, $21  ; (0, 0): object $21
	db $10, $0d  ; (0, 1): object $0D
	db $20, $a6  ; (0, 2): object $A6
	db $30, $2b  ; (0, 3): object $2B
	db $40, $29  ; (0, 4): object $29
	db $50, $0d  ; (0, 5): object $0D
	db $60, $2b  ; (0, 6): object $2B
	db $84, $12, $01  ; 4 across from (2, 1): object $01
	db $84, $22, $b0  ; 4 across from (2, 2): object $B0
	db $82, $17, $a6  ; 2 across from (7, 1): object $A6
	db $82, $27, $0f  ; 2 across from (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $82, $47, $0f  ; 2 across from (7, 4): object $0F
	db $38, $a0  ; (8, 3): object $A0
	db $86, $31, $a6  ; 6 across from (1, 3): object $A6
	db $46, $a6  ; (6, 4): object $A6
	db $83, $56, $a6  ; 3 across from (6, 5): object $A6
	db $44, $df  ; (4, 4): object $DF
	db $61, $df  ; (1, 6): object $DF
	db $67, $df  ; (7, 6): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $90 of indoor group A: 16 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom90::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $01, $f4  ; (1, 0): object $F4
	db $39, $f7  ; (9, 3): object $F7
	db $22, $4f  ; (2, 2): object $4F
	db $27, $4f  ; (7, 2): object $4F
	db $52, $4f  ; (2, 5): object $4F
	db $57, $4f  ; (7, 5): object $4F
	db $34, $4f  ; (4, 3): object $4F
	db $45, $4f  ; (5, 4): object $4F
	db $01, $29  ; (1, 0): object $29
	db $02, $1b  ; (2, 0): object $1B
	db $03, $2a  ; (3, 0): object $2A
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $82, $12, $1b  ; 2 across from (2, 1): object $1B
	db $c4, $23, $1b  ; 4 down from (3, 2): object $1B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $91 of indoor group A: 33 objects, room template 9 and floor object $03. Format: see IndoorARoomPointers.
IndoorARoom91::
	db $0c, $93  ; animated tiles $0C, template 9, floor $03
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $49, $f3  ; (9, 4): object $F3
	db $73, $f5  ; (3, 7): object $F5
	db $c8, $04, $0d  ; 8 down from (4, 0): object $0D
	db $c6, $05, $0d  ; 6 down from (5, 0): object $0D
	db $84, $30, $0d  ; 4 across from (0, 3): object $0D
	db $89, $40, $0d  ; 9 across from (0, 4): object $0D
	db $84, $55, $0d  ; 4 across from (5, 5): object $0D
	db $c3, $53, $0d  ; 3 down from (3, 5): object $0D
	db $83, $20, $21  ; 3 across from (0, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $c2, $03, $23  ; 2 down from (3, 0): object $23
	db $c3, $06, $24  ; 3 down from (6, 0): object $24
	db $36, $2a  ; (6, 3): object $2A
	db $83, $37, $21  ; 3 across from (7, 3): object $21
	db $82, $50, $22  ; 2 across from (0, 5): object $22
	db $52, $2b  ; (2, 5): object $2B
	db $c2, $62, $23  ; 2 down from (2, 6): object $23
	db $65, $2c  ; (5, 6): object $2C
	db $75, $24  ; (5, 7): object $24
	db $83, $66, $22  ; 3 across from (6, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $39, $26  ; (9, 3): object $26
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $83, $43, $0f  ; 3 across from (3, 4): object $0F
	db $83, $53, $0f  ; 3 across from (3, 5): object $0F
	db $33, $a6  ; (3, 3): object $A6
	db $35, $a6  ; (5, 3): object $A6
	db $53, $a6  ; (3, 5): object $A6
	db $55, $a6  ; (5, 5): object $A6
	db $44, $a7  ; (4, 4): object $A7
	db $25, $aa  ; (5, 2): object $AA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $92 of indoor group A: 10 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom92::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $40, $f2  ; (0, 4): object $F2
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $86, $42, $0f  ; 6 across from (2, 4): object $0F
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $53, $0f  ; (3, 5): object $0F
	db $56, $0f  ; (6, 5): object $0F
	db $11, $a6  ; (1, 1): object $A6
	db $18, $a6  ; (8, 1): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $93 of indoor group A: 12 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom93::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $19, $f3  ; (9, 1): object $F3
	db $59, $f7  ; (9, 5): object $F7
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $86, $42, $0f  ; 6 across from (2, 4): object $0F
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $53, $0f  ; (3, 5): object $0F
	db $56, $0f  ; (6, 5): object $0F
	db $59, $2a  ; (9, 5): object $2A
	db $69, $0d  ; (9, 6): object $0D
	db $79, $22  ; (9, 7): object $22
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $94 of indoor group A: 23 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A5 at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom94::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $10, $f2  ; (0, 1): object $F2
	db $72, $f5  ; (2, 7): object $F5
	db $83, $16, $0f  ; 3 across from (6, 1): object $0F
	db $83, $26, $0f  ; 3 across from (6, 2): object $0F
	db $83, $36, $0f  ; 3 across from (6, 3): object $0F
	db $87, $32, $a6  ; 7 across from (2, 3): object $A6
	db $30, $27  ; (0, 3): object $27
	db $31, $2b  ; (1, 3): object $2B
	db $82, $34, $0d  ; 2 across from (4, 3): object $0D
	db $40, $03  ; (0, 4): object $03
	db $41, $23  ; (1, 4): object $23
	db $44, $a7  ; (4, 4): object $A7
	db $45, $a6  ; (5, 4): object $A6
	db $50, $21  ; (0, 5): object $21
	db $51, $29  ; (1, 5): object $29
	db $60, $0d  ; (0, 6): object $0D
	db $61, $de  ; (1, 6): object $DE
	db $70, $22  ; (0, 7): object $22
	db $76, $2b  ; (6, 7): object $2B
	db $82, $77, $0d  ; 2 across from (7, 7): object $0D
	db $79, $24  ; (9, 7): object $24
	db $17, $be  ; (7, 1): object $BE
	db $e2, $04, $a5, $88, $10  ; warp type 2 to map $04 room $A5, x 136 y 16
	db $82, $34, $20  ; 2 across from (4, 3): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $95 of indoor group A: 10 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom95::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $49, $f3  ; (9, 4): object $F3
	db $74, $f1  ; (4, 7): object $F1
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $86, $42, $0f  ; 6 across from (2, 4): object $0F
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $53, $0f  ; (3, 5): object $0F
	db $56, $0f  ; (6, 5): object $0F
	db $11, $a6  ; (1, 1): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $96 of indoor group A: 33 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A7 at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom96::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $40, $f6  ; (0, 4): object $F6
	db $84, $06, $03  ; 4 across from (6, 0): object $03
	db $84, $16, $03  ; 4 across from (6, 1): object $03
	db $84, $26, $03  ; 4 across from (6, 2): object $03
	db $82, $03, $0d  ; 2 across from (3, 0): object $0D
	db $02, $29  ; (2, 0): object $29
	db $c3, $05, $24  ; 3 down from (5, 0): object $24
	db $35, $2a  ; (5, 3): object $2A
	db $83, $36, $21  ; 3 across from (6, 3): object $21
	db $39, $26  ; (9, 3): object $26
	db $60, $27  ; (0, 6): object $27
	db $88, $61, $22  ; 8 across from (1, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $8a, $70, $03  ; 10 across from (0, 7): object $03
	db $14, $df  ; (4, 1): object $DF
	db $52, $df  ; (2, 5): object $DF
	db $82, $47, $0f  ; 2 across from (7, 4): object $0F
	db $82, $57, $0f  ; 2 across from (7, 5): object $0F
	db $83, $11, $0f  ; 3 across from (1, 1): object $0F
	db $83, $21, $0f  ; 3 across from (1, 2): object $0F
	db $83, $31, $0f  ; 3 across from (1, 3): object $0F
	db $22, $a0  ; (2, 2): object $A0
	db $48, $be  ; (8, 4): object $BE
	db $e2, $04, $a7, $88, $10  ; warp type 2 to map $04 room $A7, x 136 y 16
	db $15, $2a  ; (5, 1): object $2A
	db $16, $21  ; (6, 1): object $21
	db $17, $26  ; (7, 1): object $26
	db $27, $24  ; (7, 2): object $24
	db $37, $2a  ; (7, 3): object $2A
	db $38, $21  ; (8, 3): object $21
	db $39, $26  ; (9, 3): object $26
	db $82, $25, $20  ; 2 across from (5, 2): object $20
	db $82, $35, $20  ; 2 across from (5, 3): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $97 of indoor group A: 13 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom97::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $59, $f7  ; (9, 5): object $F7
	db $83, $12, $0f  ; 3 across from (2, 1): object $0F
	db $83, $22, $0f  ; 3 across from (2, 2): object $0F
	db $83, $32, $0f  ; 3 across from (2, 3): object $0F
	db $84, $15, $01  ; 4 across from (5, 1): object $01
	db $84, $25, $01  ; 4 across from (5, 2): object $01
	db $84, $35, $01  ; 4 across from (5, 3): object $01
	db $84, $45, $b0  ; 4 across from (5, 4): object $B0
	db $19, $2a  ; (9, 1): object $2A
	db $29, $0d  ; (9, 2): object $0D
	db $39, $2c  ; (9, 3): object $2C
	db $23, $a0  ; (3, 2): object $A0
	db $c6, $11, $20  ; 6 down from (1, 1): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $98 of indoor group A: 31 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom98::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $29, $f7  ; (9, 2): object $F7
	db $50, $f2  ; (0, 5): object $F2
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $10, $29  ; (0, 1): object $29
	db $c6, $13, $a6  ; 6 down from (3, 1): object $A6
	db $c6, $15, $a6  ; 6 down from (5, 1): object $A6
	db $17, $24  ; (7, 1): object $24
	db $18, $c0  ; (8, 1): object $C0
	db $19, $03  ; (9, 1): object $03
	db $20, $0d  ; (0, 2): object $0D
	db $27, $2a  ; (7, 2): object $2A
	db $82, $28, $21  ; 2 across from (8, 2): object $21
	db $30, $2b  ; (0, 3): object $2B
	db $31, $ae  ; (1, 3): object $AE
	db $33, $af  ; (3, 3): object $AF
	db $35, $af  ; (5, 3): object $AF
	db $37, $af  ; (7, 3): object $AF
	db $39, $a6  ; (9, 3): object $A6
	db $41, $a6  ; (1, 4): object $A6
	db $43, $b0  ; (3, 4): object $B0
	db $45, $b0  ; (5, 4): object $B0
	db $47, $b0  ; (7, 4): object $B0
	db $49, $0d  ; (9, 4): object $0D
	db $57, $2c  ; (7, 5): object $2C
	db $82, $58, $22  ; 2 across from (8, 5): object $22
	db $67, $24  ; (7, 6): object $24
	db $68, $c0  ; (8, 6): object $C0
	db $69, $03  ; (9, 6): object $03
	db $77, $28  ; (7, 7): object $28
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $99 of indoor group A: 23 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom99::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $02, $f0  ; (2, 0): object $F0
	db $74, $f5  ; (4, 7): object $F5
	db $30, $f6  ; (0, 3): object $F6
	db $06, $29  ; (6, 0): object $29
	db $82, $07, $0d  ; 2 across from (7, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $20, $29  ; (0, 2): object $29
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $30, $a6  ; (0, 3): object $A6
	db $50, $2b  ; (0, 5): object $2B
	db $c5, $16, $a6  ; 5 down from (6, 1): object $A6
	db $82, $17, $af  ; 2 across from (7, 1): object $AF
	db $82, $27, $01  ; 2 across from (7, 2): object $01
	db $82, $37, $01  ; 2 across from (7, 3): object $01
	db $82, $47, $01  ; 2 across from (7, 4): object $01
	db $82, $57, $b0  ; 2 across from (7, 5): object $B0
	db $18, $9e  ; (8, 1): object $9E
	db $15, $c0  ; (5, 1): object $C0
	db $51, $20  ; (1, 5): object $20
	db $82, $61, $20  ; 2 across from (1, 6): object $20
	db $27, $b0  ; (7, 2): object $B0
	db $37, $20  ; (7, 3): object $20
	db $47, $af  ; (7, 4): object $AF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9A of indoor group A: 18 objects, room template 3 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom9A::
	db $0c, $3d  ; animated tiles $0C, template 3, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f5  ; (4, 7): object $F5
	db $21, $dd  ; (1, 2): object $DD
	db $28, $dd  ; (8, 2): object $DD
	db $82, $44, $dd  ; 2 across from (4, 4): object $DD
	db $82, $54, $dd  ; 2 across from (4, 5): object $DD
	db $51, $dd  ; (1, 5): object $DD
	db $58, $dd  ; (8, 5): object $DD
	db $82, $61, $dd  ; 2 across from (1, 6): object $DD
	db $82, $67, $dd  ; 2 across from (7, 6): object $DD
	db $32, $a6  ; (2, 3): object $A6
	db $37, $a6  ; (7, 3): object $A6
	db $82, $71, $a6  ; 2 across from (1, 7): object $A6
	db $82, $77, $a6  ; 2 across from (7, 7): object $A6
	db $c3, $55, $1b  ; 3 down from (5, 5): object $1B
	db $c7, $16, $1b  ; 7 down from (6, 1): object $1B
	db $82, $73, $0d  ; 2 across from (3, 7): object $0D
	db $c2, $16, $0d  ; 2 down from (6, 1): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9B of indoor group A: 11 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom9B::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $39, $f7  ; (9, 3): object $F7
	db $22, $a6  ; (2, 2): object $A6
	db $27, $a6  ; (7, 2): object $A6
	db $52, $a6  ; (2, 5): object $A6
	db $57, $a6  ; (7, 5): object $A6
	db $23, $20  ; (3, 2): object $20
	db $36, $20  ; (6, 3): object $20
	db $43, $20  ; (3, 4): object $20
	db $56, $20  ; (6, 5): object $20
	db $34, $a6  ; (4, 3): object $A6
	db $45, $a6  ; (5, 4): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9C of indoor group A: 10 objects, room template 2 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom9C::
	db $0c, $2d  ; animated tiles $0C, template 2, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $30, $f2  ; (0, 3): object $F2
	db $39, $f7  ; (9, 3): object $F7
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $19, $a6  ; (9, 1): object $A6
	db $22, $a6  ; (2, 2): object $A6
	db $35, $a6  ; (5, 3): object $A6
	db $46, $a6  ; (6, 4): object $A6
	db $53, $a6  ; (3, 5): object $A6
	db $69, $a6  ; (9, 6): object $A6
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9D of indoor group A: 23 objects, room template 6 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom9D::
	db $0c, $6d  ; animated tiles $0C, template 6, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $30, $f6  ; (0, 3): object $F6
	db $74, $ed  ; (4, 7): object $ED
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $00, $29  ; (0, 0): object $29
	db $82, $01, $a6  ; 2 across from (1, 0): object $A6
	db $82, $07, $a6  ; 2 across from (7, 0): object $A6
	db $10, $a6  ; (0, 1): object $A6
	db $60, $a6  ; (0, 6): object $A6
	db $84, $13, $dd  ; 4 across from (3, 1): object $DD
	db $21, $dd  ; (1, 2): object $DD
	db $28, $dd  ; (8, 2): object $DD
	db $35, $dd  ; (5, 3): object $DD
	db $44, $dd  ; (4, 4): object $DD
	db $52, $dd  ; (2, 5): object $DD
	db $57, $dd  ; (7, 5): object $DD
	db $61, $dd  ; (1, 6): object $DD
	db $68, $dd  ; (8, 6): object $DD
	db $c6, $05, $1b  ; 6 down from (5, 0): object $1B
	db $06, $1b  ; (6, 0): object $1B
	db $82, $53, $1b  ; 2 across from (3, 5): object $1B
	db $63, $1b  ; (3, 6): object $1B
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9E of indoor group A: 21 objects, room template 0 and floor object $0D; a warp (type 2) to map $04 room $A9 at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoom9E::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $39, $f3  ; (9, 3): object $F3
	db $88, $11, $0f  ; 8 across from (1, 1): object $0F
	db $88, $21, $0f  ; 8 across from (1, 2): object $0F
	db $88, $31, $0f  ; 8 across from (1, 3): object $0F
	db $82, $34, $0d  ; 2 across from (4, 3): object $0D
	db $04, $26  ; (4, 0): object $26
	db $05, $25  ; (5, 0): object $25
	db $14, $24  ; (4, 1): object $24
	db $15, $23  ; (5, 1): object $23
	db $24, $2a  ; (4, 2): object $2A
	db $25, $29  ; (5, 2): object $29
	db $74, $28  ; (4, 7): object $28
	db $75, $27  ; (5, 7): object $27
	db $64, $24  ; (4, 6): object $24
	db $65, $23  ; (5, 6): object $23
	db $54, $2c  ; (4, 5): object $2C
	db $55, $2b  ; (5, 5): object $2B
	db $52, $c0  ; (2, 5): object $C0
	db $57, $c0  ; (7, 5): object $C0
	db $27, $a0  ; (7, 2): object $A0
	db $22, $be  ; (2, 2): object $BE
	db $e2, $04, $a9, $88, $10  ; warp type 2 to map $04 room $A9, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $9F of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoom9F::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $04, $ec  ; (4, 0): object $EC
	db $30, $f2  ; (0, 3): object $F2
	db $49, $f7  ; (9, 4): object $F7
	db $87, $31, $0f  ; 7 across from (1, 3): object $0F
	db $41, $0f  ; (1, 4): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $83, $17, $0f  ; 3 across from (7, 1): object $0F
	db $28, $a6  ; (8, 2): object $A6
	db $13, $1b  ; (3, 1): object $1B
	db $c4, $14, $1b  ; 4 down from (4, 1): object $1B
	db $c3, $45, $1b  ; 3 down from (5, 4): object $1B
	db $09, $21  ; (9, 0): object $21
	db $c2, $29, $a6  ; 2 down from (9, 2): object $A6
	db $49, $0d  ; (9, 4): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $23, $c0  ; (3, 2): object $C0
	db $26, $c0  ; (6, 2): object $C0
	db $43, $c0  ; (3, 4): object $C0
	db $46, $c0  ; (6, 4): object $C0
	db $14, $0d  ; (4, 1): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A0 of indoor group A: 20 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomA0::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $40, $f6  ; (0, 4): object $F6
	db $59, $f7  ; (9, 5): object $F7
	db $00, $21  ; (0, 0): object $21
	db $10, $0d  ; (0, 1): object $0D
	db $20, $a6  ; (0, 2): object $A6
	db $89, $30, $a6  ; 9 across from (0, 3): object $A6
	db $40, $0d  ; (0, 4): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $83, $16, $0f  ; 3 across from (6, 1): object $0F
	db $83, $26, $0f  ; 3 across from (6, 2): object $0F
	db $17, $a0  ; (7, 1): object $A0
	db $59, $2a  ; (9, 5): object $2A
	db $69, $0d  ; (9, 6): object $0D
	db $84, $12, $01  ; 4 across from (2, 1): object $01
	db $84, $22, $b0  ; 4 across from (2, 2): object $B0
	db $79, $22  ; (9, 7): object $22
	db $53, $c0  ; (3, 5): object $C0
	db $56, $c0  ; (6, 5): object $C0
	db $82, $10, $0f  ; 2 across from (0, 1): object $0F
	db $21, $0f  ; (1, 2): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A1 of indoor group A: 17 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $D9 at x 88, y 64. Format: see IndoorARoomPointers.
IndoorARoomA1::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $50, $f6  ; (0, 5): object $F6
	db $50, $29  ; (0, 5): object $29
	db $88, $11, $0f  ; 8 across from (1, 1): object $0F
	db $88, $21, $0f  ; 8 across from (1, 2): object $0F
	db $88, $31, $0f  ; 8 across from (1, 3): object $0F
	db $04, $26  ; (4, 0): object $26
	db $05, $25  ; (5, 0): object $25
	db $14, $24  ; (4, 1): object $24
	db $15, $23  ; (5, 1): object $23
	db $24, $2a  ; (4, 2): object $2A
	db $25, $29  ; (5, 2): object $29
	db $82, $34, $0d  ; 2 across from (4, 3): object $0D
	db $22, $c0  ; (2, 2): object $C0
	db $27, $c0  ; (7, 2): object $C0
	db $60, $0d  ; (0, 6): object $0D
	db $70, $22  ; (0, 7): object $22
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $d9, $58, $40  ; warp type 0 to map $00 room $D9, x 88 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A2 of indoor group A: 23 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $86 at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoomA2::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $11, $83  ; (1, 1): object $83
	db $c5, $21, $84  ; 5 down from (1, 2): object $84
	db $88, $51, $84  ; 8 across from (1, 5): object $84
	db $88, $61, $84  ; 8 across from (1, 6): object $84
	db $83, $33, $83  ; 3 across from (3, 3): object $83
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $01, $65  ; (1, 0): object $65
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $c3, $10, $6c  ; 3 down from (0, 1): object $6C
	db $c3, $12, $6c  ; 3 down from (2, 1): object $6C
	db $8a, $40, $6d  ; 10 across from (0, 4): object $6D
	db $41, $84  ; (1, 4): object $84
	db $83, $43, $84  ; 3 across from (3, 4): object $84
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $82, $61, $72  ; 2 across from (1, 6): object $72
	db $63, $73  ; (3, 6): object $73
	db $c2, $50, $6c  ; 2 down from (0, 5): object $6C
	db $c2, $59, $4b  ; 2 down from (9, 5): object $4B
	db $11, $83  ; (1, 1): object $83
	db $36, $6d  ; (6, 3): object $6D
	db $86, $13, $5c  ; 6 across from (3, 1): object $5C
	db $84, $24, $04  ; 4 across from (4, 2): object $04
	db $c3, $19, $6c  ; 3 down from (9, 1): object $6C
	db $e1, $04, $86, $88, $20  ; warp type 1 to map $04 room $86, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A3 of indoor group A: 25 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $8D at x 80, y 72. Format: see IndoorARoomPointers.
IndoorARoomA3::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $82, $00, $6d  ; 2 across from (0, 0): object $6D
	db $82, $08, $6d  ; 2 across from (8, 0): object $6D
	db $c3, $11, $6c  ; 3 down from (1, 1): object $6C
	db $c6, $18, $6c  ; 6 down from (8, 1): object $6C
	db $10, $54  ; (0, 1): object $54
	db $19, $54  ; (9, 1): object $54
	db $20, $54  ; (0, 2): object $54
	db $29, $54  ; (9, 2): object $54
	db $30, $54  ; (0, 3): object $54
	db $39, $54  ; (9, 3): object $54
	db $c4, $49, $54  ; 4 down from (9, 4): object $54
	db $82, $40, $6d  ; 2 across from (0, 4): object $6D
	db $c2, $58, $6c  ; 2 down from (8, 5): object $6C
	db $89, $70, $6d  ; 9 across from (0, 7): object $6D
	db $86, $02, $80  ; 6 across from (2, 0): object $80
	db $86, $12, $81  ; 6 across from (2, 1): object $81
	db $86, $22, $81  ; 6 across from (2, 2): object $81
	db $86, $32, $81  ; 6 across from (2, 3): object $81
	db $86, $42, $81  ; 6 across from (2, 4): object $81
	db $86, $52, $81  ; 6 across from (2, 5): object $81
	db $86, $62, $81  ; 6 across from (2, 6): object $81
	db $82, $50, $4b  ; 2 across from (0, 5): object $4B
	db $82, $60, $4b  ; 2 across from (0, 6): object $4B
	db $c2, $24, $6c  ; 2 down from (4, 2): object $6C
	db $82, $44, $6d  ; 2 across from (4, 4): object $6D
	db $e1, $04, $8d, $50, $48  ; warp type 1 to map $04 room $8D, x 80 y 72
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A4 of indoor group A: 19 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $8C at x 120, y 96. Format: see IndoorARoomPointers.
IndoorARoomA4::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c5, $10, $6c  ; 5 down from (0, 1): object $6C
	db $85, $30, $6d  ; 5 across from (0, 3): object $6D
	db $c3, $17, $6c  ; 3 down from (7, 1): object $6C
	db $47, $6d  ; (7, 4): object $6D
	db $82, $35, $64  ; 2 across from (5, 3): object $64
	db $c3, $01, $65  ; 3 down from (1, 0): object $65
	db $16, $8f  ; (6, 1): object $8F
	db $82, $60, $6d  ; 2 across from (0, 6): object $6D
	db $82, $70, $54  ; 2 across from (0, 7): object $54
	db $88, $72, $6d  ; 8 across from (2, 7): object $6D
	db $83, $43, $6b  ; 3 across from (3, 4): object $6B
	db $44, $69  ; (4, 4): object $69
	db $83, $53, $69  ; 3 across from (3, 5): object $69
	db $54, $82  ; (4, 5): object $82
	db $51, $75  ; (1, 5): object $75
	db $c3, $29, $6d  ; 3 down from (9, 2): object $6D
	db $39, $6c  ; (9, 3): object $6C
	db $69, $6d  ; (9, 6): object $6D
	db $e1, $04, $8c, $78, $60  ; warp type 1 to map $04 room $8C, x 120 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A5 of indoor group A: 21 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $94 at x 120, y 32. Format: see IndoorARoomPointers.
IndoorARoomA5::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $83, $12, $6b  ; 3 across from (2, 1): object $6B
	db $13, $69  ; (3, 1): object $69
	db $83, $22, $69  ; 3 across from (2, 2): object $69
	db $23, $82  ; (3, 2): object $82
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c6, $08, $63  ; 6 down from (8, 0): object $63
	db $16, $8f  ; (6, 1): object $8F
	db $c2, $17, $6c  ; 2 down from (7, 1): object $6C
	db $c5, $19, $6c  ; 5 down from (9, 1): object $6C
	db $20, $6d  ; (0, 2): object $6D
	db $30, $6c  ; (0, 3): object $6C
	db $31, $6d  ; (1, 3): object $6D
	db $35, $6d  ; (5, 3): object $6D
	db $36, $64  ; (6, 3): object $64
	db $37, $6d  ; (7, 3): object $6D
	db $38, $62  ; (8, 3): object $62
	db $39, $6d  ; (9, 3): object $6D
	db $86, $40, $6d  ; 6 across from (0, 4): object $6D
	db $60, $6d  ; (0, 6): object $6D
	db $69, $6d  ; (9, 6): object $6D
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $e1, $04, $94, $78, $20  ; warp type 1 to map $04 room $94, x 120 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A6 of indoor group A: 22 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $89 at x 24, y 32. Format: see IndoorARoomPointers.
IndoorARoomA6::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $68  ; 10 across from (0, 0): object $68
	db $c3, $01, $65  ; 3 down from (1, 0): object $65
	db $c3, $10, $6c  ; 3 down from (0, 1): object $6C
	db $89, $31, $7b  ; 9 across from (1, 3): object $7B
	db $c2, $13, $4d  ; 2 down from (3, 1): object $4D
	db $83, $14, $6b  ; 3 across from (4, 1): object $6B
	db $15, $69  ; (5, 1): object $69
	db $83, $24, $69  ; 3 across from (4, 2): object $69
	db $25, $82  ; (5, 2): object $82
	db $c2, $16, $4d  ; 2 down from (6, 1): object $4D
	db $c2, $40, $57  ; 2 down from (0, 4): object $57
	db $89, $51, $80  ; 9 across from (1, 5): object $80
	db $88, $62, $81  ; 8 across from (2, 6): object $81
	db $88, $72, $81  ; 8 across from (2, 7): object $81
	db $82, $78, $53  ; 2 across from (8, 7): object $53
	db $c2, $60, $54  ; 2 down from (0, 6): object $54
	db $61, $56  ; (1, 6): object $56
	db $71, $54  ; (1, 7): object $54
	db $88, $72, $53  ; 8 across from (2, 7): object $53
	db $34, $04  ; (4, 3): object $04
	db $82, $37, $04  ; 2 across from (7, 3): object $04
	db $48, $64  ; (8, 4): object $64
	db $e1, $04, $89, $18, $20  ; warp type 1 to map $04 room $89, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A7 of indoor group A: 20 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $96 at x 136, y 80. Format: see IndoorARoomPointers.
IndoorARoomA7::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $68  ; 10 across from (0, 0): object $68
	db $c3, $08, $65  ; 3 down from (8, 0): object $65
	db $c3, $19, $6c  ; 3 down from (9, 1): object $6C
	db $89, $30, $7b  ; 9 across from (0, 3): object $7B
	db $c2, $11, $4d  ; 2 down from (1, 1): object $4D
	db $c2, $16, $4d  ; 2 down from (6, 1): object $4D
	db $83, $13, $6b  ; 3 across from (3, 1): object $6B
	db $14, $69  ; (4, 1): object $69
	db $83, $23, $69  ; 3 across from (3, 2): object $69
	db $24, $82  ; (4, 2): object $82
	db $c2, $49, $51  ; 2 down from (9, 4): object $51
	db $89, $50, $80  ; 9 across from (0, 5): object $80
	db $89, $60, $81  ; 9 across from (0, 6): object $81
	db $82, $63, $53  ; 2 across from (3, 6): object $53
	db $88, $70, $53  ; 8 across from (0, 7): object $53
	db $82, $73, $54  ; 2 across from (3, 7): object $54
	db $c2, $69, $54  ; 2 down from (9, 6): object $54
	db $68, $56  ; (8, 6): object $56
	db $78, $54  ; (8, 7): object $54
	db $82, $33, $04  ; 2 across from (3, 3): object $04
	db $e1, $04, $96, $88, $50  ; warp type 1 to map $04 room $96, x 136 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $A8 of indoor group A: 12 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $81 at x 136, y 112. Format: see IndoorARoomPointers.
IndoorARoomA8::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c6, $10, $6c  ; 6 down from (0, 1): object $6C
	db $82, $30, $6d  ; 2 across from (0, 3): object $6D
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $39, $6d  ; (9, 3): object $6D
	db $49, $6c  ; (9, 4): object $6C
	db $59, $6d  ; (9, 5): object $6D
	db $c3, $01, $65  ; 3 down from (1, 0): object $65
	db $c4, $12, $4d  ; 4 down from (2, 1): object $4D
	db $c4, $14, $4d  ; 4 down from (4, 1): object $4D
	db $c2, $16, $4d  ; 2 down from (6, 1): object $4D
	db $c2, $18, $4d  ; 2 down from (8, 1): object $4D
	db $e1, $04, $81, $88, $70  ; warp type 1 to map $04 room $81, x 136 y 112
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $A9 of indoor group A: 14 objects, room template 9 and floor object $04; a warp (type 1) to map $04 room $9E at x 40, y 48. Format: see IndoorARoomPointers.
IndoorARoomA9::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $c6, $19, $6c  ; 6 down from (9, 1): object $6C
	db $8a, $70, $6d  ; 10 across from (0, 7): object $6D
	db $83, $30, $6d  ; 3 across from (0, 3): object $6D
	db $83, $37, $6d  ; 3 across from (7, 3): object $6D
	db $c4, $31, $65  ; 4 down from (1, 3): object $65
	db $c6, $08, $65  ; 6 down from (8, 0): object $65
	db $40, $6c  ; (0, 4): object $6C
	db $c3, $42, $6c  ; 3 down from (2, 4): object $6C
	db $50, $6d  ; (0, 5): object $6D
	db $c4, $14, $4d  ; 4 down from (4, 1): object $4D
	db $c2, $16, $4d  ; 2 down from (6, 1): object $4D
	db $31, $64  ; (1, 3): object $64
	db $38, $64  ; (8, 3): object $64
	db $e1, $04, $9e, $28, $30  ; warp type 1 to map $04 room $9E, x 40 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AA of indoor group A: 21 objects, room template 9 and floor object $04; a warp (type 1) to map $02 room $4A at x 24, y 48. Format: see IndoorARoomPointers.
IndoorARoomAA::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $c6, $00, $68  ; 6 down from (0, 0): object $68
	db $c6, $01, $65  ; 6 down from (1, 0): object $65
	db $88, $02, $68  ; 8 across from (2, 0): object $68
	db $19, $68  ; (9, 1): object $68
	db $83, $22, $68  ; 3 across from (2, 2): object $68
	db $27, $68  ; (7, 2): object $68
	db $28, $64  ; (8, 2): object $64
	db $29, $68  ; (9, 2): object $68
	db $83, $33, $6b  ; 3 across from (3, 3): object $6B
	db $34, $69  ; (4, 3): object $69
	db $83, $43, $69  ; 3 across from (3, 4): object $69
	db $44, $82  ; (4, 4): object $82
	db $c2, $38, $65  ; 2 down from (8, 3): object $65
	db $83, $57, $68  ; 3 across from (7, 5): object $68
	db $83, $60, $68  ; 3 across from (0, 6): object $68
	db $84, $63, $4c  ; 4 across from (3, 6): object $4C
	db $67, $68  ; (7, 6): object $68
	db $82, $68, $60  ; 2 across from (8, 6): object $60
	db $82, $70, $60  ; 2 across from (0, 7): object $60
	db $86, $72, $68  ; 6 across from (2, 7): object $68
	db $82, $78, $60  ; 2 across from (8, 7): object $60
	db $e1, $02, $4a, $18, $30  ; warp type 1 to map $02 room $4A, x 24 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AB of indoor group A: 21 objects, room template 9 and floor object $04; a warp (type 1) to map $02 room $5C at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoomAB::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $c2, $00, $60  ; 2 down from (0, 0): object $60
	db $89, $01, $68  ; 9 across from (1, 0): object $68
	db $11, $68  ; (1, 1): object $68
	db $c7, $19, $68  ; 7 down from (9, 1): object $68
	db $82, $20, $68  ; 2 across from (0, 2): object $68
	db $83, $33, $6b  ; 3 across from (3, 3): object $6B
	db $34, $69  ; (4, 3): object $69
	db $83, $43, $69  ; 3 across from (3, 4): object $69
	db $44, $82  ; (4, 4): object $82
	db $36, $64  ; (6, 3): object $64
	db $c4, $37, $6c  ; 4 down from (7, 3): object $6C
	db $38, $64  ; (8, 3): object $64
	db $83, $50, $68  ; 3 across from (0, 5): object $68
	db $c2, $46, $65  ; 2 down from (6, 4): object $65
	db $c4, $48, $65  ; 4 down from (8, 4): object $65
	db $83, $50, $68  ; 3 across from (0, 5): object $68
	db $82, $60, $60  ; 2 across from (0, 6): object $60
	db $62, $68  ; (2, 6): object $68
	db $84, $63, $4c  ; 4 across from (3, 6): object $4C
	db $82, $70, $60  ; 2 across from (0, 7): object $60
	db $86, $72, $68  ; 6 across from (2, 7): object $68
	db $e1, $02, $5c, $88, $20  ; warp type 1 to map $02 room $5C, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AC of indoor group A: 33 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $8D at x 56, y 32. Format: see IndoorARoomPointers.
IndoorARoomAC::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $0d  ; (0, 0): object $0D
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $c3, $12, $10  ; 3 down from (2, 1): object $10
	db $13, $25  ; (3, 1): object $25
	db $82, $14, $21  ; 2 across from (4, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $c3, $17, $11  ; 3 down from (7, 1): object $11
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $23, $23  ; (3, 2): object $23
	db $82, $24, $1b  ; 2 across from (4, 2): object $1B
	db $26, $24  ; (6, 2): object $24
	db $33, $27  ; (3, 3): object $27
	db $82, $34, $22  ; 2 across from (4, 3): object $22
	db $36, $28  ; (6, 3): object $28
	db $42, $87  ; (2, 4): object $87
	db $52, $ce  ; (2, 5): object $CE
	db $84, $43, $12  ; 4 across from (3, 4): object $12
	db $47, $87  ; (7, 4): object $87
	db $57, $ce  ; (7, 5): object $CE
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $8d, $38, $20  ; warp type 0 to map $00 room $8D, x 56 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AD of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomAD::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AE of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomAE::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $AF of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomAF::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B0 of indoor group A: 19 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $6C at x 72, y 64. Format: see IndoorARoomPointers.
IndoorARoomB0::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $73, $f1  ; (3, 7): object $F1
	db $02, $c7  ; (2, 0): object $C7
	db $02, $c7  ; (2, 0): object $C7
	db $05, $26  ; (5, 0): object $26
	db $06, $2a  ; (6, 0): object $2A
	db $88, $11, $0f  ; 8 across from (1, 1): object $0F
	db $88, $21, $0f  ; 8 across from (1, 2): object $0F
	db $88, $31, $0f  ; 8 across from (1, 3): object $0F
	db $c3, $14, $dc  ; 3 down from (4, 1): object $DC
	db $c3, $15, $24  ; 3 down from (5, 1): object $24
	db $27, $a0  ; (7, 2): object $A0
	db $37, $db  ; (7, 3): object $DB
	db $39, $2a  ; (9, 3): object $2A
	db $84, $41, $dc  ; 4 across from (1, 4): object $DC
	db $45, $2a  ; (5, 4): object $2A
	db $83, $46, $21  ; 3 across from (6, 4): object $21
	db $47, $98  ; (7, 4): object $98
	db $49, $26  ; (9, 4): object $26
	db $07, $a3  ; (7, 0): object $A3
	db $e0, $00, $6c, $48, $40  ; warp type 0 to map $00 room $6C, x 72 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B1 of indoor group A: 19 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB1::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $75, $f1  ; (5, 7): object $F1
	db $02, $c7  ; (2, 0): object $C7
	db $03, $29  ; (3, 0): object $29
	db $04, $25  ; (4, 0): object $25
	db $07, $c7  ; (7, 0): object $C7
	db $88, $11, $0f  ; 8 across from (1, 1): object $0F
	db $88, $21, $0f  ; 8 across from (1, 2): object $0F
	db $88, $31, $0f  ; 8 across from (1, 3): object $0F
	db $c3, $14, $23  ; 3 down from (4, 1): object $23
	db $c3, $15, $dc  ; 3 down from (5, 1): object $DC
	db $22, $a0  ; (2, 2): object $A0
	db $30, $29  ; (0, 3): object $29
	db $32, $db  ; (2, 3): object $DB
	db $40, $25  ; (0, 4): object $25
	db $83, $41, $21  ; 3 across from (1, 4): object $21
	db $42, $98  ; (2, 4): object $98
	db $44, $29  ; (4, 4): object $29
	db $84, $45, $dc  ; 4 across from (5, 4): object $DC
	db $32, $db  ; (2, 3): object $DB
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B2 of indoor group A: 24 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB2::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $f0  ; (3, 0): object $F0
	db $49, $f7  ; (9, 4): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $c5, $16, $dc  ; 5 down from (6, 1): object $DC
	db $86, $23, $db  ; 6 across from (3, 2): object $DB
	db $c2, $33, $db  ; 2 down from (3, 3): object $DB
	db $50, $27  ; (0, 5): object $27
	db $82, $51, $22  ; 2 across from (1, 5): object $22
	db $53, $2b  ; (3, 5): object $2B
	db $63, $23  ; (3, 6): object $23
	db $73, $27  ; (3, 7): object $27
	db $83, $60, $03  ; 3 across from (0, 6): object $03
	db $83, $70, $03  ; 3 across from (0, 7): object $03
	db $66, $2c  ; (6, 6): object $2C
	db $83, $67, $22  ; 3 across from (7, 6): object $22
	db $76, $28  ; (6, 7): object $28
	db $49, $2a  ; (9, 4): object $2A
	db $59, $0d  ; (9, 5): object $0D
	db $83, $77, $03  ; 3 across from (7, 7): object $03
	db $60, $c0  ; (0, 6): object $C0
	db $83, $70, $c0  ; 3 across from (0, 7): object $C0
	db $51, $98  ; (1, 5): object $98
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B3 of indoor group A: 27 objects, room template 9 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB3::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $40, $db  ; (0, 4): object $DB
	db $40, $f6  ; (0, 4): object $F6
	db $76, $f5  ; (6, 7): object $F5
	db $88, $01, $12  ; 8 across from (1, 0): object $12
	db $09, $16  ; (9, 0): object $16
	db $c7, $19, $10  ; 7 down from (9, 1): object $10
	db $10, $15  ; (0, 1): object $15
	db $87, $11, $13  ; 7 across from (1, 1): object $13
	db $17, $95  ; (7, 1): object $95
	db $13, $0d  ; (3, 1): object $0D
	db $c6, $27, $11  ; 6 down from (7, 2): object $11
	db $c6, $20, $23  ; 6 down from (0, 2): object $23
	db $86, $21, $21  ; 6 across from (1, 2): object $21
	db $c5, $36, $24  ; 5 down from (6, 3): object $24
	db $20, $25  ; (0, 2): object $25
	db $22, $c7  ; (2, 2): object $C7
	db $23, $98  ; (3, 2): object $98
	db $24, $c7  ; (4, 2): object $C7
	db $26, $26  ; (6, 2): object $26
	db $40, $29  ; (0, 4): object $29
	db $50, $0d  ; (0, 5): object $0D
	db $60, $2b  ; (0, 6): object $2B
	db $83, $32, $0f  ; 3 across from (2, 3): object $0F
	db $83, $42, $0f  ; 3 across from (2, 4): object $0F
	db $83, $52, $0f  ; 3 across from (2, 5): object $0F
	db $85, $61, $c0  ; 5 across from (1, 6): object $C0
	db $43, $a0  ; (3, 4): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B4 of indoor group A: 17 objects, room template 9 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB4::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $72, $f5  ; (2, 7): object $F5
	db $88, $11, $db  ; 8 across from (1, 1): object $DB
	db $88, $21, $db  ; 8 across from (1, 2): object $DB
	db $88, $31, $db  ; 8 across from (1, 3): object $DB
	db $88, $41, $db  ; 8 across from (1, 4): object $DB
	db $88, $51, $db  ; 8 across from (1, 5): object $DB
	db $88, $61, $db  ; 8 across from (1, 6): object $DB
	db $8a, $00, $a6  ; 10 across from (0, 0): object $A6
	db $c6, $10, $a6  ; 6 down from (0, 1): object $A6
	db $c7, $19, $a6  ; 7 down from (9, 1): object $A6
	db $70, $11  ; (0, 7): object $11
	db $71, $0d  ; (1, 7): object $0D
	db $72, $10  ; (2, 7): object $10
	db $86, $73, $a6  ; 6 across from (3, 7): object $A6
	db $82, $14, $0d  ; 2 across from (4, 1): object $0D
	db $33, $0d  ; (3, 3): object $0D
	db $36, $0d  ; (6, 3): object $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B5 of indoor group A: 30 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $8C at x 56, y 64. Format: see IndoorARoomPointers.
IndoorARoomB5::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $74, $f1  ; (4, 7): object $F1
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $29, $ca  ; (9, 2): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $84, $23, $0f  ; 4 across from (3, 2): object $0F
	db $84, $33, $0f  ; 4 across from (3, 3): object $0F
	db $02, $26  ; (2, 0): object $26
	db $03, $2a  ; (3, 0): object $2A
	db $06, $29  ; (6, 0): object $29
	db $07, $25  ; (7, 0): object $25
	db $c3, $12, $24  ; 3 down from (2, 1): object $24
	db $42, $2a  ; (2, 4): object $2A
	db $84, $43, $21  ; 4 across from (3, 4): object $21
	db $82, $44, $97  ; 2 across from (4, 4): object $97
	db $82, $54, $0f  ; 2 across from (4, 5): object $0F
	db $82, $64, $0f  ; 2 across from (4, 6): object $0F
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
	db $e0, $00, $8c, $38, $40  ; warp type 0 to map $00 room $8C, x 56 y 64
	db $fe  ; end
	db $fe

;@ path: world/indoor/rooms
;@ Room $B6 of indoor group A: 22 objects, room template 3 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB6::
	db $0c, $3d  ; animated tiles $0C, template 3, floor $0D
	db $74, $f5  ; (4, 7): object $F5
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $11, $20  ; (1, 1): object $20
	db $18, $20  ; (8, 1): object $20
	db $86, $12, $0f  ; 6 across from (2, 1): object $0F
	db $86, $22, $0f  ; 6 across from (2, 2): object $0F
	db $86, $32, $0f  ; 6 across from (2, 3): object $0F
	db $c2, $62, $10  ; 2 down from (2, 6): object $10
	db $86, $53, $13  ; 6 across from (3, 5): object $13
	db $52, $96  ; (2, 5): object $96
	db $63, $25  ; (3, 6): object $25
	db $84, $64, $21  ; 4 across from (4, 6): object $21
	db $68, $26  ; (8, 6): object $26
	db $73, $23  ; (3, 7): object $23
	db $78, $24  ; (8, 7): object $24
	db $84, $74, $1b  ; 4 across from (4, 7): object $1B
	db $86, $12, $20  ; 6 across from (2, 1): object $20
	db $c2, $21, $20  ; 2 down from (1, 2): object $20
	db $c2, $28, $20  ; 2 down from (8, 2): object $20
	db $88, $41, $20  ; 8 across from (1, 4): object $20
	db $23, $a0  ; (3, 2): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B7 of indoor group A: 22 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB7::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $05, $f4  ; (5, 0): object $F4
	db $72, $f5  ; (2, 7): object $F5
	db $83, $00, $03  ; 3 across from (0, 0): object $03
	db $03, $25  ; (3, 0): object $25
	db $04, $c7  ; (4, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $08, $26  ; (8, 0): object $26
	db $09, $03  ; (9, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $82, $11, $21  ; 2 across from (1, 1): object $21
	db $13, $29  ; (3, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $23, $20  ; (3, 2): object $20
	db $28, $20  ; (8, 2): object $20
	db $87, $32, $a6  ; 7 across from (2, 3): object $A6
	db $41, $20  ; (1, 4): object $20
	db $47, $20  ; (7, 4): object $20
	db $87, $51, $a6  ; 7 across from (1, 5): object $A6
	db $65, $20  ; (5, 6): object $20
	db $34, $a7  ; (4, 3): object $A7
	db $44, $20  ; (4, 4): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B8 of indoor group A: 19 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomB8::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $29, $f7  ; (9, 2): object $F7
	db $74, $f5  ; (4, 7): object $F5
	db $06, $26  ; (6, 0): object $26
	db $16, $2a  ; (6, 1): object $2A
	db $83, $17, $21  ; 3 across from (7, 1): object $21
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $29, $0d  ; (9, 2): object $0D
	db $c4, $13, $db  ; 4 down from (3, 1): object $DB
	db $c4, $36, $dc  ; 4 down from (6, 3): object $DC
	db $82, $37, $dc  ; 2 across from (7, 3): object $DC
	db $39, $2c  ; (9, 3): object $2C
	db $c3, $47, $20  ; 3 down from (7, 4): object $20
	db $c3, $48, $20  ; 3 down from (8, 4): object $20
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $B9 of indoor group A: 33 objects, room template 1 and floor object $0D; a warp (type 2) to map $05 room $DC at x 24, y 19. Format: see IndoorARoomPointers.
IndoorARoomB9::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $20, $f6  ; (0, 2): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $76, $f5  ; (6, 7): object $F5
	db $10, $29  ; (0, 1): object $29
	db $20, $0d  ; (0, 2): object $0D
	db $30, $2b  ; (0, 3): object $2B
	db $c7, $02, $0f  ; 7 down from (2, 0): object $0F
	db $c7, $03, $0f  ; 7 down from (3, 0): object $0F
	db $c7, $04, $0f  ; 7 down from (4, 0): object $0F
	db $86, $31, $c0  ; 6 across from (1, 3): object $C0
	db $33, $ac  ; (3, 3): object $AC
	db $c2, $06, $24  ; 2 down from (6, 0): object $24
	db $56, $2c  ; (6, 5): object $2C
	db $82, $57, $22  ; 2 across from (7, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $76, $28  ; (6, 7): object $28
	db $67, $17  ; (7, 6): object $17
	db $82, $68, $12  ; 2 across from (8, 6): object $12
	db $77, $11  ; (7, 7): object $11
	db $78, $0d  ; (8, 7): object $0D
	db $79, $96  ; (9, 7): object $96
	db $26, $2a  ; (6, 2): object $2A
	db $82, $27, $21  ; 2 across from (7, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $09, $94  ; (9, 0): object $94
	db $07, $11  ; (7, 0): object $11
	db $17, $15  ; (7, 1): object $15
	db $82, $18, $13  ; 2 across from (8, 1): object $13
	db $66, $24  ; (6, 6): object $24
	db $17, $ac  ; (7, 1): object $AC
	db $13, $a0  ; (3, 1): object $A0
	db $53, $be  ; (3, 5): object $BE
	db $e2, $05, $dc, $18, $13  ; warp type 2 to map $05 room $DC, x 24 y 19
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BA of indoor group A: 21 objects, room template 9 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomBA::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $30, $dc  ; (0, 3): object $DC
	db $30, $f2  ; (0, 3): object $F2
	db $39, $f3  ; (9, 3): object $F3
	db $8a, $00, $12  ; 10 across from (0, 0): object $12
	db $8a, $60, $12  ; 10 across from (0, 6): object $12
	db $8a, $10, $13  ; 10 across from (0, 1): object $13
	db $8a, $70, $13  ; 10 across from (0, 7): object $13
	db $20, $25  ; (0, 2): object $25
	db $88, $21, $21  ; 8 across from (1, 2): object $21
	db $29, $26  ; (9, 2): object $26
	db $50, $27  ; (0, 5): object $27
	db $88, $51, $22  ; 8 across from (1, 5): object $22
	db $59, $28  ; (9, 5): object $28
	db $23, $c7  ; (3, 2): object $C7
	db $26, $c7  ; (6, 2): object $C7
	db $53, $c8  ; (3, 5): object $C8
	db $56, $c8  ; (6, 5): object $C8
	db $33, $20  ; (3, 3): object $20
	db $36, $20  ; (6, 3): object $20
	db $43, $20  ; (3, 4): object $20
	db $46, $20  ; (6, 4): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BB of indoor group A: 29 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomBB::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $30, $f2  ; (0, 3): object $F2
	db $76, $f5  ; (6, 7): object $F5
	db $00, $93  ; (0, 0): object $93
	db $01, $0d  ; (1, 0): object $0D
	db $02, $10  ; (2, 0): object $10
	db $03, $25  ; (3, 0): object $25
	db $82, $10, $13  ; 2 across from (0, 1): object $13
	db $12, $14  ; (2, 1): object $14
	db $20, $25  ; (0, 2): object $25
	db $82, $21, $21  ; 2 across from (1, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $50, $27  ; (0, 5): object $27
	db $82, $51, $22  ; 2 across from (1, 5): object $22
	db $53, $28  ; (3, 5): object $28
	db $43, $2c  ; (3, 4): object $2C
	db $83, $44, $22  ; 3 across from (4, 4): object $22
	db $47, $2b  ; (7, 4): object $2B
	db $c3, $57, $23  ; 3 down from (7, 5): object $23
	db $84, $60, $12  ; 4 across from (0, 6): object $12
	db $64, $93  ; (4, 6): object $93
	db $54, $ac  ; (4, 5): object $AC
	db $56, $ac  ; (6, 5): object $AC
	db $86, $70, $13  ; 6 across from (0, 7): object $13
	db $76, $14  ; (6, 7): object $14
	db $66, $10  ; (6, 6): object $10
	db $78, $0d  ; (8, 7): object $0D
	db $13, $23  ; (3, 1): object $23
	db $79, $24  ; (9, 7): object $24
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BC of indoor group A: 12 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomBC::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $f1  ; (4, 7): object $F1
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $88, $11, $0f  ; 8 across from (1, 1): object $0F
	db $c4, $21, $0f  ; 4 down from (1, 2): object $0F
	db $c4, $28, $0f  ; 4 down from (8, 2): object $0F
	db $88, $61, $0f  ; 8 across from (1, 6): object $0F
	db $11, $20  ; (1, 1): object $20
	db $18, $20  ; (8, 1): object $20
	db $61, $20  ; (1, 6): object $20
	db $68, $20  ; (8, 6): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BD of indoor group A: 10 objects, room template 0 and floor object $0D; a warp (type 2) to map $05 room $DB at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoomBD::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $74, $f1  ; (4, 7): object $F1
	db $88, $21, $0f  ; 8 across from (1, 2): object $0F
	db $88, $31, $0f  ; 8 across from (1, 3): object $0F
	db $88, $41, $0f  ; 8 across from (1, 4): object $0F
	db $c3, $24, $0d  ; 3 down from (4, 2): object $0D
	db $c3, $25, $0d  ; 3 down from (5, 2): object $0D
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $32, $be  ; (2, 3): object $BE
	db $e2, $05, $db, $88, $10  ; warp type 2 to map $05 room $DB, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BE of indoor group A: 37 objects, room template 9 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomBE::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $03, $f4  ; (3, 0): object $F4
	db $75, $f5  ; (5, 7): object $F5
	db $c8, $00, $23  ; 8 down from (0, 0): object $23
	db $c5, $02, $10  ; 5 down from (2, 0): object $10
	db $c4, $03, $23  ; 4 down from (3, 0): object $23
	db $84, $04, $1b  ; 4 across from (4, 0): object $1B
	db $84, $14, $1b  ; 4 across from (4, 1): object $1B
	db $84, $24, $1b  ; 4 across from (4, 2): object $1B
	db $84, $34, $1b  ; 4 across from (4, 3): object $1B
	db $c4, $08, $24  ; 4 down from (8, 0): object $24
	db $c5, $09, $24  ; 5 down from (9, 0): object $24
	db $52, $94  ; (2, 5): object $94
	db $53, $12  ; (3, 5): object $12
	db $54, $16  ; (4, 5): object $16
	db $64, $10  ; (4, 6): object $10
	db $43, $27  ; (3, 4): object $27
	db $44, $22  ; (4, 4): object $22
	db $45, $2b  ; (5, 4): object $2B
	db $c4, $46, $1b  ; 4 down from (6, 4): object $1B
	db $47, $2c  ; (7, 4): object $2C
	db $48, $28  ; (8, 4): object $28
	db $c3, $55, $23  ; 3 down from (5, 5): object $23
	db $c3, $57, $24  ; 3 down from (7, 5): object $24
	db $58, $2c  ; (8, 5): object $2C
	db $59, $28  ; (9, 5): object $28
	db $c2, $68, $24  ; 2 down from (8, 6): object $24
	db $c2, $69, $03  ; 2 down from (9, 6): object $03
	db $71, $0d  ; (1, 7): object $0D
	db $72, $2c  ; (2, 7): object $2C
	db $73, $22  ; (3, 7): object $22
	db $74, $2b  ; (4, 7): object $2B
	db $10, $c9  ; (0, 1): object $C9
	db $40, $c9  ; (0, 4): object $C9
	db $19, $ca  ; (9, 1): object $CA
	db $49, $ca  ; (9, 4): object $CA
	db $16, $a0  ; (6, 1): object $A0
	db $82, $62, $20  ; 2 across from (2, 6): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $BF of indoor group A: 22 objects, room template 0 and floor object $0D; a warp (type 2) to map $05 room $DD at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoomBF::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $f0  ; (2, 0): object $F0
	db $72, $f1  ; (2, 7): object $F1
	db $05, $26  ; (5, 0): object $26
	db $06, $2a  ; (6, 0): object $2A
	db $c3, $15, $24  ; 3 down from (5, 1): object $24
	db $45, $2a  ; (5, 4): object $2A
	db $83, $46, $21  ; 3 across from (6, 4): object $21
	db $47, $98  ; (7, 4): object $98
	db $49, $26  ; (9, 4): object $26
	db $39, $2a  ; (9, 3): object $2A
	db $11, $20  ; (1, 1): object $20
	db $14, $20  ; (4, 1): object $20
	db $16, $11  ; (6, 1): object $11
	db $36, $15  ; (6, 3): object $15
	db $38, $13  ; (8, 3): object $13
	db $67, $2c  ; (7, 6): object $2C
	db $68, $22  ; (8, 6): object $22
	db $69, $28  ; (9, 6): object $28
	db $77, $28  ; (7, 7): object $28
	db $78, $0d  ; (8, 7): object $0D
	db $79, $2c  ; (9, 7): object $2C
	db $18, $be  ; (8, 1): object $BE
	db $e2, $05, $dd, $88, $10  ; warp type 2 to map $05 room $DD, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C0 of indoor group A: 13 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC0::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f4  ; (4, 0): object $F4
	db $49, $f7  ; (9, 4): object $F7
	db $03, $29  ; (3, 0): object $29
	db $82, $04, $0d  ; 2 across from (4, 0): object $0D
	db $06, $2a  ; (6, 0): object $2A
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $c3, $16, $dc  ; 3 down from (6, 1): object $DC
	db $82, $57, $dc  ; 2 across from (7, 5): object $DC
	db $86, $41, $db  ; 6 across from (1, 4): object $DB
	db $c2, $56, $db  ; 2 down from (6, 5): object $DB
	db $46, $dc  ; (6, 4): object $DC
	db $28, $a1  ; (8, 2): object $A1
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C1 of indoor group A: 35 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC1::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $11, $8e  ; (1, 1): object $8E
	db $06, $f4  ; (6, 0): object $F4
	db $40, $f2  ; (0, 4): object $F2
	db $49, $4a  ; (9, 4): object $4A
	db $75, $f5  ; (5, 7): object $F5
	db $06, $26  ; (6, 0): object $26
	db $16, $24  ; (6, 1): object $24
	db $26, $2a  ; (6, 2): object $2A
	db $27, $21  ; (7, 2): object $21
	db $28, $98  ; (8, 2): object $98
	db $29, $26  ; (9, 2): object $26
	db $07, $11  ; (7, 0): object $11
	db $08, $0d  ; (8, 0): object $0D
	db $09, $10  ; (9, 0): object $10
	db $19, $14  ; (9, 1): object $14
	db $02, $c7  ; (2, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $c4, $34, $db  ; 4 down from (4, 3): object $DB
	db $83, $41, $dc  ; 3 across from (1, 4): object $DC
	db $35, $db  ; (5, 3): object $DB
	db $71, $2b  ; (1, 7): object $2B
	db $77, $2b  ; (7, 7): object $2B
	db $72, $0d  ; (2, 7): object $0D
	db $76, $0d  ; (6, 7): object $0D
	db $73, $2c  ; (3, 7): object $2C
	db $77, $2c  ; (7, 7): object $2C
	db $75, $2b  ; (5, 7): object $2B
	db $82, $12, $20  ; 2 across from (2, 1): object $20
	db $23, $20  ; (3, 2): object $20
	db $25, $20  ; (5, 2): object $20
	db $61, $20  ; (1, 6): object $20
	db $39, $ca  ; (9, 3): object $CA
	db $59, $ca  ; (9, 5): object $CA
	db $83, $46, $0f  ; 3 across from (6, 4): object $0F
	db $c3, $56, $0f  ; 3 down from (6, 5): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C2 of indoor group A: 10 objects, room template 0 and floor object $07; a warp (type 2) to map $05 room $D9 at x 136, y 16. Format: see IndoorARoomPointers.
IndoorARoomC2::
	db $07, $07  ; animated tiles $07, template 0, floor $07
	db $40, $dc  ; (0, 4): object $DC
	db $40, $41  ; (0, 4): object $41
	db $22, $ab  ; (2, 2): object $AB
	db $26, $ab  ; (6, 2): object $AB
	db $85, $32, $a6  ; 5 across from (2, 3): object $A6
	db $44, $a6  ; (4, 4): object $A6
	db $83, $54, $a6  ; 3 across from (4, 5): object $A6
	db $83, $62, $a6  ; 3 across from (2, 6): object $A6
	db $66, $a6  ; (6, 6): object $A6
	db $18, $bf  ; (8, 1): object $BF
	db $e2, $05, $d9, $88, $10  ; warp type 2 to map $05 room $D9, x 136 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C3 of indoor group A: 24 objects, room template 0 and floor object $0D; a warp (type 2) to map $05 room $DA at x 24, y 19. Format: see IndoorARoomPointers.
IndoorARoomC3::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $07, $f4  ; (7, 0): object $F4
	db $76, $f5  ; (6, 7): object $F5
	db $07, $29  ; (7, 0): object $29
	db $08, $0d  ; (8, 0): object $0D
	db $09, $24  ; (9, 0): object $24
	db $18, $de  ; (8, 1): object $DE
	db $13, $da  ; (3, 1): object $DA
	db $16, $da  ; (6, 1): object $DA
	db $22, $da  ; (2, 2): object $DA
	db $27, $da  ; (7, 2): object $DA
	db $31, $da  ; (1, 3): object $DA
	db $33, $da  ; (3, 3): object $DA
	db $36, $da  ; (6, 3): object $DA
	db $38, $da  ; (8, 3): object $DA
	db $42, $da  ; (2, 4): object $DA
	db $82, $44, $da  ; 2 across from (4, 4): object $DA
	db $47, $da  ; (7, 4): object $DA
	db $53, $da  ; (3, 5): object $DA
	db $56, $da  ; (6, 5): object $DA
	db $82, $64, $da  ; 2 across from (4, 6): object $DA
	db $11, $be  ; (1, 1): object $BE
	db $e2, $05, $da, $18, $13  ; warp type 2 to map $05 room $DA, x 24 y 19
	db $32, $0f  ; (2, 3): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C4 of indoor group A: 10 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC4::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $c7  ; (3, 0): object $C7
	db $04, $f8  ; (4, 0): object $F8
	db $06, $c7  ; (6, 0): object $C7
	db $74, $f1  ; (4, 7): object $F1
	db $82, $32, $ac  ; 2 across from (2, 3): object $AC
	db $82, $36, $ac  ; 2 across from (6, 3): object $AC
	db $82, $42, $ac  ; 2 across from (2, 4): object $AC
	db $82, $46, $ac  ; 2 across from (6, 4): object $AC
	db $42, $ab  ; (2, 4): object $AB
	db $47, $ab  ; (7, 4): object $AB
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C5 of indoor group A: 14 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC5::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $74, $40  ; (4, 7): object $40
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $84, $13, $0f  ; 4 across from (3, 1): object $0F
	db $22, $0f  ; (2, 2): object $0F
	db $27, $0f  ; (7, 2): object $0F
	db $31, $0f  ; (1, 3): object $0F
	db $82, $34, $0f  ; 2 across from (4, 3): object $0F
	db $38, $0f  ; (8, 3): object $0F
	db $42, $0f  ; (2, 4): object $0F
	db $82, $44, $0f  ; 2 across from (4, 4): object $0F
	db $47, $0f  ; (7, 4): object $0F
	db $84, $53, $0f  ; 4 across from (3, 5): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C6 of indoor group A: 40 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC6::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $05, $f4  ; (5, 0): object $F4
	db $49, $f7  ; (9, 4): object $F7
	db $71, $f5  ; (1, 7): object $F5
	db $00, $23  ; (0, 0): object $23
	db $01, $0d  ; (1, 0): object $0D
	db $02, $2a  ; (2, 0): object $2A
	db $04, $29  ; (4, 0): object $29
	db $05, $23  ; (5, 0): object $23
	db $c2, $06, $1b  ; 2 down from (6, 0): object $1B
	db $c6, $07, $24  ; 6 down from (7, 0): object $24
	db $08, $2a  ; (8, 0): object $2A
	db $c2, $13, $10  ; 2 down from (3, 1): object $10
	db $04, $29  ; (4, 0): object $29
	db $05, $23  ; (5, 0): object $23
	db $15, $29  ; (5, 1): object $29
	db $14, $25  ; (4, 1): object $25
	db $c6, $18, $11  ; 6 down from (8, 1): object $11
	db $22, $a6  ; (2, 2): object $A6
	db $c2, $24, $23  ; 2 down from (4, 2): object $23
	db $c3, $25, $1b  ; 3 down from (5, 2): object $1B
	db $c3, $26, $1b  ; 3 down from (6, 2): object $1B
	db $82, $31, $13  ; 2 across from (1, 3): object $13
	db $33, $14  ; (3, 3): object $14
	db $41, $25  ; (1, 4): object $25
	db $82, $42, $21  ; 2 across from (2, 4): object $21
	db $44, $29  ; (4, 4): object $29
	db $c3, $51, $23  ; 3 down from (1, 5): object $23
	db $85, $52, $1b  ; 5 across from (2, 5): object $1B
	db $c2, $62, $1b  ; 2 down from (2, 6): object $1B
	db $63, $2c  ; (3, 6): object $2C
	db $83, $64, $22  ; 3 across from (4, 6): object $22
	db $67, $28  ; (7, 6): object $28
	db $70, $23  ; (0, 7): object $23
	db $71, $23  ; (1, 7): object $23
	db $73, $24  ; (3, 7): object $24
	db $74, $2c  ; (4, 7): object $2C
	db $23, $0d  ; (3, 2): object $0D
	db $28, $0d  ; (8, 2): object $0D
	db $11, $de  ; (1, 1): object $DE
	db $40, $c9  ; (0, 4): object $C9
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C7 of indoor group A: 18 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC7::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $02, $f0  ; (2, 0): object $F0
	db $40, $f2  ; (0, 4): object $F2
	db $11, $ae  ; (1, 1): object $AE
	db $61, $ae  ; (1, 6): object $AE
	db $68, $ae  ; (8, 6): object $AE
	db $33, $af  ; (3, 3): object $AF
	db $35, $af  ; (5, 3): object $AF
	db $43, $b0  ; (3, 4): object $B0
	db $45, $b0  ; (5, 4): object $B0
	db $07, $26  ; (7, 0): object $26
	db $08, $0d  ; (8, 0): object $0D
	db $09, $2a  ; (9, 0): object $2A
	db $17, $2a  ; (7, 1): object $2A
	db $18, $98  ; (8, 1): object $98
	db $19, $26  ; (9, 1): object $26
	db $27, $af  ; (7, 2): object $AF
	db $37, $b0  ; (7, 3): object $B0
	db $38, $ae  ; (8, 3): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C8 of indoor group A: 25 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC8::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $f4  ; (2, 0): object $F4
	db $19, $f3  ; (9, 1): object $F3
	db $74, $fb  ; (4, 7): object $FB
	db $c7, $06, $0f  ; 7 down from (6, 0): object $0F
	db $84, $66, $0f  ; 4 across from (6, 6): object $0F
	db $01, $29  ; (1, 0): object $29
	db $02, $0d  ; (2, 0): object $0D
	db $03, $24  ; (3, 0): object $24
	db $04, $03  ; (4, 0): object $03
	db $05, $23  ; (5, 0): object $23
	db $07, $2a  ; (7, 0): object $2A
	db $12, $db  ; (2, 1): object $DB
	db $13, $2a  ; (3, 1): object $2A
	db $14, $c7  ; (4, 1): object $C7
	db $15, $29  ; (5, 1): object $29
	db $16, $db  ; (6, 1): object $DB
	db $52, $db  ; (2, 5): object $DB
	db $56, $db  ; (6, 5): object $DB
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $83, $33, $0f  ; 3 across from (3, 3): object $0F
	db $83, $43, $0f  ; 3 across from (3, 4): object $0F
	db $59, $2a  ; (9, 5): object $2A
	db $79, $22  ; (9, 7): object $22
	db $30, $c9  ; (0, 3): object $C9
	db $39, $ca  ; (9, 3): object $CA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $C9 of indoor group A: 28 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomC9::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $10, $db  ; (0, 1): object $DB
	db $10, $f6  ; (0, 1): object $F6
	db $77, $f1  ; (7, 7): object $F1
	db $02, $c7  ; (2, 0): object $C7
	db $07, $c7  ; (7, 0): object $C7
	db $c3, $16, $0f  ; 3 down from (6, 1): object $0F
	db $30, $27  ; (0, 3): object $27
	db $85, $31, $22  ; 5 across from (1, 3): object $22
	db $c3, $46, $23  ; 3 down from (6, 4): object $23
	db $76, $27  ; (6, 7): object $27
	db $84, $50, $21  ; 4 across from (0, 5): object $21
	db $54, $26  ; (4, 5): object $26
	db $c2, $64, $24  ; 2 down from (4, 6): object $24
	db $86, $40, $03  ; 6 across from (0, 4): object $03
	db $c3, $55, $03  ; 3 down from (5, 5): object $03
	db $60, $0d  ; (0, 6): object $0D
	db $70, $2b  ; (0, 7): object $2B
	db $83, $71, $0d  ; 3 across from (1, 7): object $0D
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $82, $27, $0f  ; 2 across from (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $52, $c7  ; (2, 5): object $C7
	db $27, $a0  ; (7, 2): object $A0
	db $35, $2b  ; (5, 3): object $2B
	db $45, $27  ; (5, 4): object $27
	db $46, $2b  ; (6, 4): object $2B
	db $83, $60, $0f  ; 3 across from (0, 6): object $0F
	db $72, $0f  ; (2, 7): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CA of indoor group A: 23 objects, room template 0 and floor object $0D; a warp (type 1) to map $05 room $D4 at x 80, y 124. Format: see IndoorARoomPointers.
IndoorARoomCA::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $06, $f0  ; (6, 0): object $F0
	db $59, $f3  ; (9, 5): object $F3
	db $21, $ac  ; (1, 2): object $AC
	db $27, $ac  ; (7, 2): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $67, $ac  ; (7, 6): object $AC
	db $33, $af  ; (3, 3): object $AF
	db $34, $ae  ; (4, 3): object $AE
	db $35, $af  ; (5, 3): object $AF
	db $43, $01  ; (3, 4): object $01
	db $45, $01  ; (5, 4): object $01
	db $53, $b0  ; (3, 5): object $B0
	db $54, $ae  ; (4, 5): object $AE
	db $55, $b0  ; (5, 5): object $B0
	db $85, $00, $03  ; 5 across from (0, 0): object $03
	db $05, $25  ; (5, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $03  ; (9, 0): object $03
	db $10, $25  ; (0, 1): object $25
	db $84, $11, $21  ; 4 across from (1, 1): object $21
	db $15, $29  ; (5, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $e1, $05, $d4, $50, $7c  ; warp type 1 to map $05 room $D4, x 80 y 124
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CB of indoor group A: 14 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomCB::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $50, $f2  ; (0, 5): object $F2
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $21, $af  ; (1, 2): object $AF
	db $22, $a7  ; (2, 2): object $A7
	db $84, $23, $13  ; 4 across from (3, 2): object $13
	db $37, $a7  ; (7, 3): object $A7
	db $28, $af  ; (8, 2): object $AF
	db $31, $b0  ; (1, 3): object $B0
	db $38, $b0  ; (8, 3): object $B0
	db $86, $42, $ae  ; 6 across from (2, 4): object $AE
	db $54, $a7  ; (4, 5): object $A7
	db $65, $a7  ; (5, 6): object $A7
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CC of indoor group A: 9 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomCC::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $3f  ; (4, 0): object $3F
	db $74, $ed  ; (4, 7): object $ED
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $04, $47  ; (4, 0): object $47
	db $c2, $32, $20  ; 2 down from (2, 3): object $20
	db $c2, $37, $20  ; 2 down from (7, 3): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CD of indoor group A: 25 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomCD::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $23  ; (0, 0): object $23
	db $01, $f4  ; (1, 0): object $F4
	db $77, $f5  ; (7, 7): object $F5
	db $c6, $01, $23  ; 6 down from (1, 0): object $23
	db $c5, $02, $1b  ; 5 down from (2, 0): object $1B
	db $c4, $03, $24  ; 4 down from (3, 0): object $24
	db $04, $2a  ; (4, 0): object $2A
	db $07, $c7  ; (7, 0): object $C7
	db $c2, $14, $11  ; 2 down from (4, 1): object $11
	db $34, $15  ; (4, 3): object $15
	db $36, $13  ; (6, 3): object $13
	db $37, $95  ; (7, 3): object $95
	db $43, $2a  ; (3, 4): object $2A
	db $44, $21  ; (4, 4): object $21
	db $45, $98  ; (5, 4): object $98
	db $46, $26  ; (6, 4): object $26
	db $c3, $47, $11  ; 3 down from (7, 4): object $11
	db $84, $52, $1b  ; 4 across from (2, 5): object $1B
	db $56, $24  ; (6, 5): object $24
	db $61, $27  ; (1, 6): object $27
	db $84, $62, $22  ; 4 across from (2, 6): object $22
	db $66, $28  ; (6, 6): object $28
	db $73, $c8  ; (3, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $83, $16, $20  ; 3 across from (6, 1): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CE of indoor group A: 30 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomCE::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $fa  ; (4, 0): object $FA
	db $74, $f5  ; (4, 7): object $F5
	db $00, $17  ; (0, 0): object $17
	db $01, $12  ; (1, 0): object $12
	db $02, $16  ; (2, 0): object $16
	db $03, $25  ; (3, 0): object $25
	db $06, $26  ; (6, 0): object $26
	db $07, $17  ; (7, 0): object $17
	db $08, $12  ; (8, 0): object $12
	db $09, $16  ; (9, 0): object $16
	db $c2, $10, $11  ; 2 down from (0, 1): object $11
	db $c2, $12, $10  ; 2 down from (2, 1): object $10
	db $c3, $13, $23  ; 3 down from (3, 1): object $23
	db $c3, $16, $24  ; 3 down from (6, 1): object $24
	db $c2, $17, $11  ; 2 down from (7, 1): object $11
	db $18, $20  ; (8, 1): object $20
	db $c2, $19, $10  ; 2 down from (9, 1): object $10
	db $30, $ac  ; (0, 3): object $AC
	db $32, $ac  ; (2, 3): object $AC
	db $37, $ac  ; (7, 3): object $AC
	db $39, $ac  ; (9, 3): object $AC
	db $40, $25  ; (0, 4): object $25
	db $41, $98  ; (1, 4): object $98
	db $42, $21  ; (2, 4): object $21
	db $43, $29  ; (3, 4): object $29
	db $46, $2a  ; (6, 4): object $2A
	db $47, $21  ; (7, 4): object $21
	db $48, $98  ; (8, 4): object $98
	db $49, $26  ; (9, 4): object $26
	db $11, $a0  ; (1, 1): object $A0
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $CF of indoor group A: 21 objects, room template 1 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomCF::
	db $04, $1d  ; animated tiles $04, template 1, floor $0D
	db $07, $f4  ; (7, 0): object $F4
	db $20, $c9  ; (0, 2): object $C9
	db $50, $c9  ; (0, 5): object $C9
	db $77, $f5  ; (7, 7): object $F5
	db $c7, $04, $24  ; 7 down from (4, 0): object $24
	db $c8, $05, $03  ; 8 down from (5, 0): object $03
	db $c7, $06, $23  ; 7 down from (6, 0): object $23
	db $06, $25  ; (6, 0): object $25
	db $09, $26  ; (9, 0): object $26
	db $71, $2b  ; (1, 7): object $2B
	db $72, $0d  ; (2, 7): object $0D
	db $73, $2c  ; (3, 7): object $2C
	db $74, $28  ; (4, 7): object $28
	db $76, $27  ; (6, 7): object $27
	db $82, $27, $0f  ; 2 across from (7, 2): object $0F
	db $82, $37, $0f  ; 2 across from (7, 3): object $0F
	db $82, $47, $0f  ; 2 across from (7, 4): object $0F
	db $24, $ca  ; (4, 2): object $CA
	db $54, $ca  ; (4, 5): object $CA
	db $37, $a0  ; (7, 3): object $A0
	db $c8, $02, $0f  ; 8 down from (2, 0): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D0 of indoor group A: 15 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomD0::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $ec  ; (4, 0): object $EC
	db $49, $f3  ; (9, 4): object $F3
	db $74, $f5  ; (4, 7): object $F5
	db $13, $c0  ; (3, 1): object $C0
	db $16, $c0  ; (6, 1): object $C0
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $10, $25  ; (0, 1): object $25
	db $11, $21  ; (1, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $17, $2a  ; (7, 1): object $2A
	db $18, $21  ; (8, 1): object $21
	db $19, $26  ; (9, 1): object $26
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D1 of indoor group A: 22 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomD1::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $07, $db  ; (7, 0): object $DB
	db $07, $f0  ; (7, 0): object $F0
	db $40, $f2  ; (0, 4): object $F2
	db $73, $f1  ; (3, 7): object $F1
	db $47, $2c  ; (7, 4): object $2C
	db $48, $22  ; (8, 4): object $22
	db $49, $28  ; (9, 4): object $28
	db $c2, $57, $24  ; 2 down from (7, 5): object $24
	db $77, $28  ; (7, 7): object $28
	db $59, $2c  ; (9, 5): object $2C
	db $78, $0d  ; (8, 7): object $0D
	db $79, $24  ; (9, 7): object $24
	db $02, $c7  ; (2, 0): object $C7
	db $c3, $58, $0f  ; 3 down from (8, 5): object $0F
	db $58, $a0  ; (8, 5): object $A0
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $10, $25  ; (0, 1): object $25
	db $11, $21  ; (1, 1): object $21
	db $12, $29  ; (2, 1): object $29
	db $82, $17, $0f  ; 2 across from (7, 1): object $0F
	db $82, $61, $0f  ; 2 across from (1, 6): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D2 of indoor group A: 11 objects, room template 0 and floor object $0D; a warp (type 2) to map $05 room $D8 at x 24, y 16. Format: see IndoorARoomPointers.
IndoorARoomD2::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $04, $f0  ; (4, 0): object $F0
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $83, $32, $0f  ; 3 across from (2, 3): object $0F
	db $83, $42, $0f  ; 3 across from (2, 4): object $0F
	db $83, $52, $0f  ; 3 across from (2, 5): object $0F
	db $85, $21, $dc  ; 5 across from (1, 2): object $DC
	db $c3, $35, $dc  ; 3 down from (5, 3): object $DC
	db $c3, $31, $dc  ; 3 down from (1, 3): object $DC
	db $85, $61, $dc  ; 5 across from (1, 6): object $DC
	db $43, $be  ; (3, 4): object $BE
	db $e2, $05, $d8, $18, $10  ; warp type 2 to map $05 room $D8, x 24 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D3 of indoor group A: 17 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomD3::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $07, $f0  ; (7, 0): object $F0
	db $39, $f7  ; (9, 3): object $F7
	db $01, $29  ; (1, 0): object $29
	db $02, $0d  ; (2, 0): object $0D
	db $03, $2a  ; (3, 0): object $2A
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $59, $2c  ; (9, 5): object $2C
	db $22, $ac  ; (2, 2): object $AC
	db $83, $23, $0f  ; 3 across from (3, 2): object $0F
	db $26, $ac  ; (6, 2): object $AC
	db $c2, $32, $0f  ; 2 down from (2, 3): object $0F
	db $c2, $36, $0f  ; 2 down from (6, 3): object $0F
	db $52, $ac  ; (2, 5): object $AC
	db $83, $53, $0f  ; 3 across from (3, 5): object $0F
	db $56, $ac  ; (6, 5): object $AC
	db $c2, $02, $0f  ; 2 down from (2, 0): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D4 of indoor group A: 16 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $8C at x 56, y 64. Format: see IndoorARoomPointers.
IndoorARoomD4::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $30, $d0  ; (0, 3): object $D0
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $11, $ac  ; (1, 1): object $AC
	db $18, $ac  ; (8, 1): object $AC
	db $61, $ac  ; (1, 6): object $AC
	db $68, $ac  ; (8, 6): object $AC
	db $20, $29  ; (0, 2): object $29
	db $29, $2a  ; (9, 2): object $2A
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $59, $2c  ; (9, 5): object $2C
	db $c3, $32, $c0  ; 3 down from (2, 3): object $C0
	db $c3, $37, $c0  ; 3 down from (7, 3): object $C0
	db $53, $fc  ; (3, 5): object $FC
	db $e0, $00, $8c, $38, $40  ; warp type 0 to map $00 room $8C, x 56 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D5 of indoor group A: 41 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomD5::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $30, $f6  ; (0, 3): object $F6
	db $39, $f7  ; (9, 3): object $F7
	db $82, $00, $03  ; 2 across from (0, 0): object $03
	db $02, $25  ; (2, 0): object $25
	db $04, $26  ; (4, 0): object $26
	db $05, $25  ; (5, 0): object $25
	db $07, $26  ; (7, 0): object $26
	db $82, $08, $03  ; 2 across from (8, 0): object $03
	db $82, $10, $03  ; 2 across from (0, 1): object $03
	db $12, $23  ; (2, 1): object $23
	db $14, $24  ; (4, 1): object $24
	db $15, $23  ; (5, 1): object $23
	db $17, $24  ; (7, 1): object $24
	db $82, $18, $03  ; 2 across from (8, 1): object $03
	db $82, $20, $21  ; 2 across from (0, 2): object $21
	db $22, $29  ; (2, 2): object $29
	db $24, $2a  ; (4, 2): object $2A
	db $25, $29  ; (5, 2): object $29
	db $27, $2a  ; (7, 2): object $2A
	db $82, $28, $21  ; 2 across from (8, 2): object $21
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $c2, $39, $0d  ; 2 down from (9, 3): object $0D
	db $82, $50, $22  ; 2 across from (0, 5): object $22
	db $52, $2b  ; (2, 5): object $2B
	db $57, $2c  ; (7, 5): object $2C
	db $82, $58, $22  ; 2 across from (8, 5): object $22
	db $8a, $60, $03  ; 10 across from (0, 6): object $03
	db $62, $23  ; (2, 6): object $23
	db $67, $24  ; (7, 6): object $24
	db $82, $70, $03  ; 2 across from (0, 7): object $03
	db $72, $27  ; (2, 7): object $27
	db $77, $28  ; (7, 7): object $28
	db $82, $78, $03  ; 2 across from (8, 7): object $03
	db $83, $33, $d2  ; 3 across from (3, 3): object $D2
	db $c3, $34, $cf  ; 3 down from (4, 3): object $CF
	db $c2, $36, $cf  ; 2 down from (6, 3): object $CF
	db $c3, $43, $d0  ; 3 down from (3, 4): object $D0
	db $c2, $45, $d0  ; 2 down from (5, 4): object $D0
	db $56, $d1  ; (6, 5): object $D1
	db $64, $d1  ; (4, 6): object $D1
	db $82, $65, $ae  ; 2 across from (5, 6): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D6 of indoor group A: 17 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomD6::
	db $07, $0d  ; animated tiles $07, template 0, floor $0D
	db $04, $d0  ; (4, 0): object $D0
	db $04, $aa  ; (4, 0): object $AA
	db $04, $f0  ; (4, 0): object $F0
	db $30, $f6  ; (0, 3): object $F6
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $20, $29  ; (0, 2): object $29
	db $c2, $30, $0d  ; 2 down from (0, 3): object $0D
	db $50, $2b  ; (0, 5): object $2B
	db $61, $20  ; (1, 6): object $20
	db $68, $20  ; (8, 6): object $20
	db $84, $23, $da  ; 4 across from (3, 2): object $DA
	db $82, $32, $da  ; 2 across from (2, 3): object $DA
	db $82, $36, $da  ; 2 across from (6, 3): object $DA
	db $82, $42, $da  ; 2 across from (2, 4): object $DA
	db $82, $46, $da  ; 2 across from (6, 4): object $DA
	db $84, $53, $da  ; 4 across from (3, 5): object $DA
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D7 of indoor group A: 32 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomD7::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $03, $f0  ; (3, 0): object $F0
	db $02, $c7  ; (2, 0): object $C7
	db $05, $c7  ; (5, 0): object $C7
	db $07, $26  ; (7, 0): object $26
	db $c6, $08, $0f  ; 6 down from (8, 0): object $0F
	db $09, $24  ; (9, 0): object $24
	db $c4, $17, $24  ; 4 down from (7, 1): object $24
	db $22, $dc  ; (2, 2): object $DC
	db $26, $dc  ; (6, 2): object $DC
	db $31, $dc  ; (1, 3): object $DC
	db $83, $33, $dc  ; 3 across from (3, 3): object $DC
	db $40, $27  ; (0, 4): object $27
	db $41, $98  ; (1, 4): object $98
	db $42, $2b  ; (2, 4): object $2B
	db $83, $43, $db  ; 3 across from (3, 4): object $DB
	db $44, $dc  ; (4, 4): object $DC
	db $50, $2b  ; (0, 5): object $2B
	db $51, $0f  ; (1, 5): object $0F
	db $52, $23  ; (2, 5): object $23
	db $53, $db  ; (3, 5): object $DB
	db $54, $2c  ; (4, 5): object $2C
	db $55, $98  ; (5, 5): object $98
	db $56, $22  ; (6, 5): object $22
	db $57, $28  ; (7, 5): object $28
	db $61, $c0  ; (1, 6): object $C0
	db $62, $27  ; (2, 6): object $27
	db $63, $22  ; (3, 6): object $22
	db $64, $28  ; (4, 6): object $28
	db $84, $65, $0f  ; 4 across from (5, 6): object $0F
	db $c2, $50, $c0  ; 2 down from (0, 5): object $C0
	db $70, $2c  ; (0, 7): object $2C
	db $11, $20  ; (1, 1): object $20
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D8 of indoor group A: 18 objects, room template 9 and floor object $04; a warp (type 1) to map $05 room $D2 at x 56, y 80. Format: see IndoorARoomPointers.
IndoorARoomD8::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $68  ; 10 across from (0, 0): object $68
	db $c3, $01, $65  ; 3 down from (1, 0): object $65
	db $c6, $10, $68  ; 6 down from (0, 1): object $68
	db $83, $14, $6b  ; 3 across from (4, 1): object $6B
	db $15, $69  ; (5, 1): object $69
	db $83, $24, $69  ; 3 across from (4, 2): object $69
	db $25, $82  ; (5, 2): object $82
	db $38, $64  ; (8, 3): object $64
	db $82, $45, $64  ; 2 across from (5, 4): object $64
	db $c3, $48, $65  ; 3 down from (8, 4): object $65
	db $c3, $39, $68  ; 3 down from (9, 3): object $68
	db $69, $68  ; (9, 6): object $68
	db $89, $70, $68  ; 9 across from (0, 7): object $68
	db $79, $68  ; (9, 7): object $68
	db $82, $31, $68  ; 2 across from (1, 3): object $68
	db $33, $64  ; (3, 3): object $64
	db $83, $41, $64  ; 3 across from (1, 4): object $64
	db $c2, $51, $65  ; 2 down from (1, 5): object $65
	db $e1, $05, $d2, $38, $50  ; warp type 1 to map $05 room $D2, x 56 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $D9 of indoor group A: 22 objects, room template 9 and floor object $04; a warp (type 1) to map $05 room $C2 at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoomD9::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $68  ; 10 across from (0, 0): object $68
	db $c6, $08, $65  ; 6 down from (8, 0): object $65
	db $83, $11, $6b  ; 3 across from (1, 1): object $6B
	db $12, $69  ; (2, 1): object $69
	db $83, $21, $69  ; 3 across from (1, 2): object $69
	db $22, $82  ; (2, 2): object $82
	db $14, $68  ; (4, 1): object $68
	db $15, $68  ; (5, 1): object $68
	db $c5, $19, $68  ; 5 down from (9, 1): object $68
	db $30, $68  ; (0, 3): object $68
	db $31, $64  ; (1, 3): object $64
	db $c2, $41, $65  ; 2 down from (1, 4): object $65
	db $82, $24, $68  ; 2 across from (4, 2): object $68
	db $82, $44, $64  ; 2 across from (4, 4): object $64
	db $c2, $40, $68  ; 2 down from (0, 4): object $68
	db $8a, $60, $68  ; 10 across from (0, 6): object $68
	db $84, $63, $04  ; 4 across from (3, 6): object $04
	db $63, $75  ; (3, 6): object $75
	db $8a, $70, $68  ; 10 across from (0, 7): object $68
	db $84, $73, $68  ; 4 across from (3, 7): object $68
	db $82, $70, $60  ; 2 across from (0, 7): object $60
	db $82, $78, $60  ; 2 across from (8, 7): object $60
	db $e1, $05, $c2, $88, $20  ; warp type 1 to map $05 room $C2, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DA of indoor group A: 20 objects, room template 9 and floor object $04; a warp (type 1) to map $05 room $C3 at x 24, y 32. Format: see IndoorARoomPointers.
IndoorARoomDA::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $12, $69  ; (2, 1): object $69
	db $22, $82  ; (2, 2): object $82
	db $14, $69  ; (4, 1): object $69
	db $24, $82  ; (4, 2): object $82
	db $16, $69  ; (6, 1): object $69
	db $26, $82  ; (6, 2): object $82
	db $8a, $00, $68  ; 10 across from (0, 0): object $68
	db $c5, $01, $63  ; 5 down from (1, 0): object $63
	db $c6, $10, $68  ; 6 down from (0, 1): object $68
	db $c4, $13, $65  ; 4 down from (3, 1): object $65
	db $c4, $15, $65  ; 4 down from (5, 1): object $65
	db $c5, $17, $65  ; 5 down from (7, 1): object $65
	db $82, $38, $68  ; 2 across from (8, 3): object $68
	db $c3, $48, $68  ; 3 down from (8, 4): object $68
	db $c3, $49, $54  ; 3 down from (9, 4): object $54
	db $87, $61, $4c  ; 7 across from (1, 6): object $4C
	db $8a, $70, $68  ; 10 across from (0, 7): object $68
	db $37, $64  ; (7, 3): object $64
	db $65, $68  ; (5, 6): object $68
	db $c4, $49, $60  ; 4 down from (9, 4): object $60
	db $e1, $05, $c3, $18, $20  ; warp type 1 to map $05 room $C3, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DB of indoor group A: 18 objects, room template 9 and floor object $04; a warp (type 1) to map $05 room $BD at x 40, y 80. Format: see IndoorARoomPointers.
IndoorARoomDB::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $68  ; 10 across from (0, 0): object $68
	db $c2, $08, $63  ; 2 down from (8, 0): object $63
	db $13, $64  ; (3, 1): object $64
	db $c6, $19, $68  ; 6 down from (9, 1): object $68
	db $82, $30, $68  ; 2 across from (0, 3): object $68
	db $33, $68  ; (3, 3): object $68
	db $82, $35, $68  ; 2 across from (5, 3): object $68
	db $c3, $38, $65  ; 3 down from (8, 3): object $65
	db $38, $64  ; (8, 3): object $64
	db $c4, $40, $68  ; 4 down from (0, 4): object $68
	db $c3, $41, $68  ; 3 down from (1, 4): object $68
	db $43, $68  ; (3, 4): object $68
	db $82, $45, $68  ; 2 across from (5, 4): object $68
	db $82, $62, $4c  ; 2 across from (2, 6): object $4C
	db $64, $68  ; (4, 6): object $68
	db $68, $4c  ; (8, 6): object $4C
	db $89, $71, $68  ; 9 across from (1, 7): object $68
	db $c4, $40, $60  ; 4 down from (0, 4): object $60
	db $e1, $05, $bd, $28, $50  ; warp type 1 to map $05 room $BD, x 40 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DC of indoor group A: 18 objects, room template 9 and floor object $04; a warp (type 1) to map $05 room $B9 at x 56, y 96. Format: see IndoorARoomPointers.
IndoorARoomDC::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $c6, $01, $65  ; 6 down from (1, 0): object $65
	db $c6, $00, $68  ; 6 down from (0, 0): object $68
	db $c3, $02, $68  ; 3 down from (2, 0): object $68
	db $87, $03, $60  ; 7 across from (3, 0): object $60
	db $86, $13, $68  ; 6 across from (3, 1): object $68
	db $19, $60  ; (9, 1): object $60
	db $23, $68  ; (3, 2): object $68
	db $82, $28, $68  ; 2 across from (8, 2): object $68
	db $83, $32, $6b  ; 3 across from (2, 3): object $6B
	db $33, $69  ; (3, 3): object $69
	db $83, $42, $69  ; 3 across from (2, 4): object $69
	db $43, $82  ; (3, 4): object $82
	db $83, $37, $6b  ; 3 across from (7, 3): object $6B
	db $38, $69  ; (8, 3): object $69
	db $83, $47, $69  ; 3 across from (7, 4): object $69
	db $48, $82  ; (8, 4): object $82
	db $8a, $60, $68  ; 10 across from (0, 6): object $68
	db $8a, $70, $60  ; 10 across from (0, 7): object $60
	db $e1, $05, $b9, $38, $60  ; warp type 1 to map $05 room $B9, x 56 y 96
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DD of indoor group A: 20 objects, room template 9 and floor object $04; a warp (type 1) to map $05 room $BF at x 136, y 32. Format: see IndoorARoomPointers.
IndoorARoomDD::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $87, $00, $60  ; 7 across from (0, 0): object $60
	db $c3, $07, $68  ; 3 down from (7, 0): object $68
	db $c6, $08, $65  ; 6 down from (8, 0): object $65
	db $c7, $09, $68  ; 7 down from (9, 0): object $68
	db $87, $10, $68  ; 7 across from (0, 1): object $68
	db $10, $60  ; (0, 1): object $60
	db $16, $60  ; (6, 1): object $60
	db $87, $20, $68  ; 7 across from (0, 2): object $68
	db $22, $04  ; (2, 2): object $04
	db $24, $04  ; (4, 2): object $04
	db $83, $30, $6b  ; 3 across from (0, 3): object $6B
	db $31, $69  ; (1, 3): object $69
	db $83, $40, $69  ; 3 across from (0, 4): object $69
	db $41, $82  ; (1, 4): object $82
	db $83, $35, $6b  ; 3 across from (5, 3): object $6B
	db $36, $69  ; (6, 3): object $69
	db $83, $45, $69  ; 3 across from (5, 4): object $69
	db $46, $82  ; (6, 4): object $82
	db $8a, $60, $68  ; 10 across from (0, 6): object $68
	db $8a, $70, $60  ; 10 across from (0, 7): object $60
	db $e1, $05, $bf, $88, $20  ; warp type 1 to map $05 room $BF, x 136 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $DE of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomDE::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $fe  ; end
;@ path: world/indoor/rooms
;@ Room $DF of indoor group A: 0 objects, room template 0 and floor object $0D. Format: see IndoorARoomPointers.
IndoorARoomDF::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E0 of indoor group A: 39 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $E6 at x 72, y 64. Format: see IndoorARoomPointers.
IndoorARoomE0::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $02, $c7  ; (2, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $20, $29  ; (0, 2): object $29
	db $21, $0f  ; (1, 2): object $0F
	db $23, $87  ; (3, 2): object $87
	db $25, $87  ; (5, 2): object $87
	db $29, $24  ; (9, 2): object $24
	db $30, $25  ; (0, 3): object $25
	db $31, $21  ; (1, 3): object $21
	db $32, $26  ; (2, 3): object $26
	db $33, $ce  ; (3, 3): object $CE
	db $34, $86  ; (4, 3): object $86
	db $35, $ce  ; (5, 3): object $CE
	db $36, $25  ; (6, 3): object $25
	db $37, $21  ; (7, 3): object $21
	db $38, $26  ; (8, 3): object $26
	db $39, $2a  ; (9, 3): object $2A
	db $c2, $41, $1b  ; 2 down from (1, 4): object $1B
	db $42, $24  ; (2, 4): object $24
	db $46, $23  ; (6, 4): object $23
	db $47, $0f  ; (7, 4): object $0F
	db $48, $24  ; (8, 4): object $24
	db $49, $0d  ; (9, 4): object $0D
	db $52, $2a  ; (2, 5): object $2A
	db $83, $53, $21  ; 3 across from (3, 5): object $21
	db $54, $98  ; (4, 5): object $98
	db $56, $29  ; (6, 5): object $29
	db $58, $2a  ; (8, 5): object $2A
	db $59, $26  ; (9, 5): object $26
	db $85, $61, $1b  ; 5 across from (1, 6): object $1B
	db $68, $cb  ; (8, 6): object $CB
	db $e0, $00, $e6, $48, $40  ; warp type 0 to map $00 room $E6, x 72 y 64
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E1 of indoor group A: 35 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $52 at x 104, y 48. Format: see IndoorARoomPointers.
IndoorARoomE1::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $10, $29  ; (0, 1): object $29
	db $12, $0f  ; (2, 1): object $0F
	db $16, $25  ; (6, 1): object $25
	db $17, $21  ; (7, 1): object $21
	db $18, $26  ; (8, 1): object $26
	db $19, $2a  ; (9, 1): object $2A
	db $20, $25  ; (0, 2): object $25
	db $21, $21  ; (1, 2): object $21
	db $22, $26  ; (2, 2): object $26
	db $23, $87  ; (3, 2): object $87
	db $25, $87  ; (5, 2): object $87
	db $c4, $26, $23  ; 4 down from (6, 2): object $23
	db $c2, $27, $20  ; 2 down from (7, 2): object $20
	db $38, $20  ; (8, 3): object $20
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $c2, $32, $24  ; 2 down from (2, 3): object $24
	db $33, $ce  ; (3, 3): object $CE
	db $34, $86  ; (4, 3): object $86
	db $35, $ce  ; (5, 3): object $CE
	db $52, $2a  ; (2, 5): object $2A
	db $83, $53, $21  ; 3 across from (3, 5): object $21
	db $56, $29  ; (6, 5): object $29
	db $57, $0f  ; (7, 5): object $0F
	db $87, $61, $1b  ; 7 across from (1, 6): object $1B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $72, $c8  ; (2, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $54, $98  ; (4, 5): object $98
	db $48, $cb  ; (8, 4): object $CB
	db $e0, $00, $52, $68, $30  ; warp type 0 to map $00 room $52, x 104 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E2 of indoor group A: 35 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $04 at x 120, y 112. Format: see IndoorARoomPointers.
IndoorARoomE2::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $02, $c7  ; (2, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $10, $29  ; (0, 1): object $29
	db $12, $0f  ; (2, 1): object $0F
	db $16, $25  ; (6, 1): object $25
	db $17, $21  ; (7, 1): object $21
	db $18, $26  ; (8, 1): object $26
	db $19, $2a  ; (9, 1): object $2A
	db $20, $25  ; (0, 2): object $25
	db $21, $21  ; (1, 2): object $21
	db $22, $26  ; (2, 2): object $26
	db $23, $87  ; (3, 2): object $87
	db $25, $87  ; (5, 2): object $87
	db $c4, $26, $23  ; 4 down from (6, 2): object $23
	db $c2, $27, $20  ; 2 down from (7, 2): object $20
	db $38, $20  ; (8, 3): object $20
	db $28, $2a  ; (8, 2): object $2A
	db $29, $26  ; (9, 2): object $26
	db $c2, $32, $24  ; 2 down from (2, 3): object $24
	db $33, $ce  ; (3, 3): object $CE
	db $34, $86  ; (4, 3): object $86
	db $35, $ce  ; (5, 3): object $CE
	db $52, $2a  ; (2, 5): object $2A
	db $83, $53, $21  ; 3 across from (3, 5): object $21
	db $56, $29  ; (6, 5): object $29
	db $57, $0f  ; (7, 5): object $0F
	db $87, $61, $1b  ; 7 across from (1, 6): object $1B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $72, $c8  ; (2, 7): object $C8
	db $76, $c8  ; (6, 7): object $C8
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $54, $98  ; (4, 5): object $98
	db $48, $cb  ; (8, 4): object $CB
	db $e0, $00, $04, $78, $70  ; warp type 0 to map $00 room $04, x 120 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E3 of indoor group A: 18 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $F6 at x 88, y 66. Format: see IndoorARoomPointers.
IndoorARoomE3::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $02, $99  ; (2, 0): object $99
	db $c2, $11, $df  ; 2 down from (1, 1): object $DF
	db $12, $9a  ; (2, 1): object $9A
	db $83, $15, $df  ; 3 across from (5, 1): object $DF
	db $22, $c5  ; (2, 2): object $C5
	db $26, $a6  ; (6, 2): object $A6
	db $27, $ce  ; (7, 2): object $CE
	db $28, $a6  ; (8, 2): object $A6
	db $32, $c6  ; (2, 3): object $C6
	db $38, $20  ; (8, 3): object $20
	db $43, $df  ; (3, 4): object $DF
	db $48, $df  ; (8, 4): object $DF
	db $83, $52, $df  ; 3 across from (2, 5): object $DF
	db $82, $57, $20  ; 2 across from (7, 5): object $20
	db $82, $61, $df  ; 2 across from (1, 6): object $DF
	db $82, $67, $20  ; 2 across from (7, 6): object $20
	db $18, $ab  ; (8, 1): object $AB
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $f6, $58, $42  ; warp type 0 to map $00 room $F6, x 88 y 66
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E4 of indoor group A: 33 objects, room template 0 and floor object $05. Format: see IndoorARoomPointers.
IndoorARoomE4::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $86, $12, $1b  ; 6 across from (2, 1): object $1B
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $c4, $21, $1b  ; 4 down from (1, 2): object $1B
	db $c4, $22, $1b  ; 4 down from (2, 2): object $1B
	db $23, $2c  ; (3, 2): object $2C
	db $82, $24, $22  ; 2 across from (4, 2): object $22
	db $26, $2b  ; (6, 2): object $2B
	db $c4, $27, $1b  ; 4 down from (7, 2): object $1B
	db $c4, $28, $1b  ; 4 down from (8, 2): object $1B
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $86, $62, $1b  ; 6 across from (2, 6): object $1B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $0d  ; 2 across from (4, 7): object $0D
	db $76, $2c  ; (6, 7): object $2C
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $c2, $33, $24  ; 2 down from (3, 3): object $24
	db $c2, $36, $23  ; 2 down from (6, 3): object $23
	db $53, $2a  ; (3, 5): object $2A
	db $82, $54, $97  ; 2 across from (4, 5): object $97
	db $56, $29  ; (6, 5): object $29
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E5 of indoor group A: 42 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $E7 at x 104, y 32. Format: see IndoorARoomPointers.
IndoorARoomE5::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $82, $02, $21  ; 2 across from (2, 0): object $21
	db $04, $26  ; (4, 0): object $26
	db $05, $df  ; (5, 0): object $DF
	db $82, $06, $0d  ; 2 across from (6, 0): object $0D
	db $08, $df  ; (8, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $14, $24  ; (4, 1): object $24
	db $82, $15, $df  ; 2 across from (5, 1): object $DF
	db $83, $17, $0d  ; 3 across from (7, 1): object $0D
	db $c2, $20, $23  ; 2 down from (0, 2): object $23
	db $24, $2a  ; (4, 2): object $2A
	db $25, $26  ; (5, 2): object $26
	db $84, $26, $df  ; 4 across from (6, 2): object $DF
	db $18, $0d  ; (8, 1): object $0D
	db $35, $2a  ; (5, 3): object $2A
	db $36, $26  ; (6, 3): object $26
	db $83, $37, $df  ; 3 across from (7, 3): object $DF
	db $40, $27  ; (0, 4): object $27
	db $41, $2b  ; (1, 4): object $2B
	db $45, $1b  ; (5, 4): object $1B
	db $46, $2a  ; (6, 4): object $2A
	db $83, $47, $21  ; 3 across from (7, 4): object $21
	db $50, $df  ; (0, 5): object $DF
	db $51, $27  ; (1, 5): object $27
	db $52, $2b  ; (2, 5): object $2B
	db $84, $54, $1b  ; 4 across from (4, 5): object $1B
	db $82, $58, $0e  ; 2 across from (8, 5): object $0E
	db $60, $0d  ; (0, 6): object $0D
	db $61, $df  ; (1, 6): object $DF
	db $62, $27  ; (2, 6): object $27
	db $63, $22  ; (3, 6): object $22
	db $64, $2b  ; (4, 6): object $2B
	db $82, $65, $1b  ; 2 across from (5, 6): object $1B
	db $83, $67, $0e  ; 3 across from (7, 6): object $0E
	db $82, $70, $0d  ; 2 across from (0, 7): object $0D
	db $82, $72, $df  ; 2 across from (2, 7): object $DF
	db $74, $27  ; (4, 7): object $27
	db $85, $75, $22  ; 5 across from (5, 7): object $22
	db $22, $cb  ; (2, 2): object $CB
	db $e0, $00, $e7, $68, $20  ; warp type 0 to map $00 room $E7, x 104 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E6 of indoor group A: 33 objects, room template 9 and floor object $05. Format: see IndoorARoomPointers.
IndoorARoomE6::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $02, $0d  ; (2, 0): object $0D
	db $82, $04, $df  ; 2 across from (4, 0): object $DF
	db $c3, $09, $df  ; 3 down from (9, 0): object $DF
	db $82, $10, $0d  ; 2 across from (0, 1): object $0D
	db $13, $df  ; (3, 1): object $DF
	db $16, $df  ; (6, 1): object $DF
	db $18, $df  ; (8, 1): object $DF
	db $20, $df  ; (0, 2): object $DF
	db $85, $21, $0d  ; 5 across from (1, 2): object $0D
	db $85, $30, $df  ; 5 across from (0, 3): object $DF
	db $82, $35, $0d  ; 2 across from (5, 3): object $0D
	db $37, $df  ; (7, 3): object $DF
	db $39, $0d  ; (9, 3): object $0D
	db $84, $40, $21  ; 4 across from (0, 4): object $21
	db $44, $26  ; (4, 4): object $26
	db $45, $df  ; (5, 4): object $DF
	db $82, $46, $0d  ; 2 across from (6, 4): object $0D
	db $c2, $48, $df  ; 2 down from (8, 4): object $DF
	db $84, $50, $0e  ; 4 across from (0, 5): object $0E
	db $54, $2a  ; (4, 5): object $2A
	db $55, $26  ; (5, 5): object $26
	db $56, $df  ; (6, 5): object $DF
	db $85, $60, $0e  ; 5 across from (0, 6): object $0E
	db $65, $2a  ; (5, 6): object $2A
	db $66, $26  ; (6, 6): object $26
	db $c2, $67, $df  ; 2 down from (7, 6): object $DF
	db $c2, $68, $0d  ; 2 down from (8, 6): object $0D
	db $69, $0d  ; (9, 6): object $0D
	db $82, $70, $22  ; 2 across from (0, 7): object $22
	db $72, $2b  ; (2, 7): object $2B
	db $83, $73, $0e  ; 3 across from (3, 7): object $0E
	db $76, $24  ; (6, 7): object $24
	db $79, $df  ; (9, 7): object $DF
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E7 of indoor group A: 43 objects, room template 3 and floor object $0D; a warp (type 0) to overworld room $2F at x 24, y 112. Format: see IndoorARoomPointers.
IndoorARoomE7::
	db $0c, $3d  ; animated tiles $0C, template 3, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $02, $29  ; (2, 0): object $29
	db $03, $25  ; (3, 0): object $25
	db $05, $21  ; (5, 0): object $21
	db $06, $26  ; (6, 0): object $26
	db $07, $2a  ; (7, 0): object $2A
	db $08, $26  ; (8, 0): object $26
	db $c8, $09, $df  ; 8 down from (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $12, $25  ; (2, 1): object $25
	db $13, $29  ; (3, 1): object $29
	db $16, $2a  ; (6, 1): object $2A
	db $17, $26  ; (7, 1): object $26
	db $c3, $18, $24  ; 3 down from (8, 1): object $24
	db $21, $25  ; (1, 2): object $25
	db $22, $29  ; (2, 2): object $29
	db $27, $24  ; (7, 2): object $24
	db $c2, $31, $23  ; 2 down from (1, 3): object $23
	db $35, $2c  ; (5, 3): object $2C
	db $36, $22  ; (6, 3): object $22
	db $37, $28  ; (7, 3): object $28
	db $44, $2c  ; (4, 4): object $2C
	db $45, $28  ; (5, 4): object $28
	db $46, $2c  ; (6, 4): object $2C
	db $47, $22  ; (7, 4): object $22
	db $48, $28  ; (8, 4): object $28
	db $51, $27  ; (1, 5): object $27
	db $82, $52, $22  ; 2 across from (2, 5): object $22
	db $54, $28  ; (4, 5): object $28
	db $55, $2c  ; (5, 5): object $2C
	db $56, $28  ; (6, 5): object $28
	db $82, $57, $df  ; 2 across from (7, 5): object $DF
	db $63, $1b  ; (3, 6): object $1B
	db $64, $2c  ; (4, 6): object $2C
	db $65, $28  ; (5, 6): object $28
	db $66, $df  ; (6, 6): object $DF
	db $82, $72, $1b  ; 2 across from (2, 7): object $1B
	db $74, $24  ; (4, 7): object $24
	db $75, $df  ; (5, 7): object $DF
	db $78, $df  ; (8, 7): object $DF
	db $04, $a3  ; (4, 0): object $A3
	db $e0, $00, $2f, $18, $70  ; warp type 0 to map $00 room $2F, x 24 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E8 of indoor group A: 23 objects, room template 0 and floor object $05. Format: see IndoorARoomPointers.
IndoorARoomE8::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $74, $3d  ; (4, 7): object $3D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $22, $0f  ; (2, 2): object $0F
	db $36, $0f  ; (6, 3): object $0F
	db $31, $0f  ; (1, 3): object $0F
	db $44, $0f  ; (4, 4): object $0F
	db $67, $0f  ; (7, 6): object $0F
	db $82, $25, $0f  ; 2 across from (5, 2): object $0F
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $E9 of indoor group A: 27 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $2B at x 104, y 48. Format: see IndoorARoomPointers.
IndoorARoomE9::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $00, $25  ; (0, 0): object $25
	db $82, $01, $21  ; 2 across from (1, 0): object $21
	db $03, $26  ; (3, 0): object $26
	db $82, $05, $df  ; 2 across from (5, 0): object $DF
	db $c2, $13, $24  ; 2 down from (3, 1): object $24
	db $82, $15, $05  ; 2 across from (5, 1): object $05
	db $82, $17, $df  ; 2 across from (7, 1): object $DF
	db $86, $24, $df  ; 6 across from (4, 2): object $DF
	db $27, $05  ; (7, 2): object $05
	db $82, $31, $1b  ; 2 across from (1, 3): object $1B
	db $33, $2a  ; (3, 3): object $2A
	db $86, $34, $21  ; 6 across from (4, 3): object $21
	db $40, $27  ; (0, 4): object $27
	db $41, $2b  ; (1, 4): object $2B
	db $88, $42, $1b  ; 8 across from (2, 4): object $1B
	db $51, $27  ; (1, 5): object $27
	db $88, $52, $22  ; 8 across from (2, 5): object $22
	db $82, $60, $05  ; 2 across from (0, 6): object $05
	db $88, $62, $df  ; 8 across from (2, 6): object $DF
	db $64, $0d  ; (4, 6): object $0D
	db $82, $66, $0d  ; 2 across from (6, 6): object $0D
	db $89, $70, $df  ; 9 across from (0, 7): object $DF
	db $72, $05  ; (2, 7): object $05
	db $73, $0d  ; (3, 7): object $0D
	db $c3, $10, $23  ; 3 down from (0, 1): object $23
	db $21, $1b  ; (1, 2): object $1B
	db $12, $cb  ; (2, 1): object $CB
	db $e0, $00, $2b, $68, $30  ; warp type 0 to map $00 room $2B, x 104 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EA of indoor group A: 27 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $2D at x 88, y 80. Format: see IndoorARoomPointers.
IndoorARoomEA::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $8a, $00, $df  ; 10 across from (0, 0): object $DF
	db $83, $06, $05  ; 3 across from (6, 0): object $05
	db $82, $11, $df  ; 2 across from (1, 1): object $DF
	db $83, $15, $df  ; 3 across from (5, 1): object $DF
	db $8a, $20, $df  ; 10 across from (0, 2): object $DF
	db $82, $25, $0d  ; 2 across from (5, 2): object $0D
	db $88, $30, $21  ; 8 across from (0, 3): object $21
	db $38, $26  ; (8, 3): object $26
	db $39, $df  ; (9, 3): object $DF
	db $84, $40, $1b  ; 4 across from (0, 4): object $1B
	db $44, $a7  ; (4, 4): object $A7
	db $45, $ae  ; (5, 4): object $AE
	db $48, $2a  ; (8, 4): object $2A
	db $49, $26  ; (9, 4): object $26
	db $86, $50, $22  ; 6 across from (0, 5): object $22
	db $56, $2b  ; (6, 5): object $2B
	db $c2, $59, $24  ; 2 down from (9, 5): object $24
	db $86, $60, $df  ; 6 across from (0, 6): object $DF
	db $62, $05  ; (2, 6): object $05
	db $63, $0d  ; (3, 6): object $0D
	db $66, $23  ; (6, 6): object $23
	db $82, $71, $df  ; 2 across from (1, 7): object $DF
	db $83, $73, $05  ; 3 across from (3, 7): object $05
	db $76, $27  ; (6, 7): object $27
	db $82, $77, $22  ; 2 across from (7, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $68, $cb  ; (8, 6): object $CB
	db $e0, $00, $2d, $58, $50  ; warp type 0 to map $00 room $2D, x 88 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EB of indoor group A: 24 objects, room template 9 and floor object $04; a warp (type 0) to overworld room $49 at x 104, y 80. Format: see IndoorARoomPointers.
IndoorARoomEB::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $88, $00, $69  ; 8 across from (0, 0): object $69
	db $c2, $08, $6c  ; 2 down from (8, 0): object $6C
	db $c2, $09, $68  ; 2 down from (9, 0): object $68
	db $88, $10, $69  ; 8 across from (0, 1): object $69
	db $20, $61  ; (0, 2): object $61
	db $21, $64  ; (1, 2): object $64
	db $22, $5f  ; (2, 2): object $5F
	db $87, $23, $60  ; 7 across from (3, 2): object $60
	db $c3, $30, $57  ; 3 down from (0, 3): object $57
	db $c2, $31, $65  ; 2 down from (1, 3): object $65
	db $32, $5a  ; (2, 3): object $5A
	db $87, $33, $5c  ; 7 across from (3, 3): object $5C
	db $53, $82  ; (3, 5): object $82
	db $57, $82  ; (7, 5): object $82
	db $60, $54  ; (0, 6): object $54
	db $61, $5b  ; (1, 6): object $5B
	db $62, $5d  ; (2, 6): object $5D
	db $63, $4c  ; (3, 6): object $4C
	db $64, $59  ; (4, 6): object $59
	db $65, $5d  ; (5, 6): object $5D
	db $82, $66, $4c  ; 2 across from (6, 6): object $4C
	db $68, $59  ; (8, 6): object $59
	db $69, $5b  ; (9, 6): object $5B
	db $8a, $70, $54  ; 10 across from (0, 7): object $54
	db $e0, $00, $49, $68, $50  ; warp type 0 to map $00 room $49, x 104 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EC of indoor group A: 35 objects, room template 9 and floor object $04; a warp (type 0) to overworld room $4A at x 136, y 48. Format: see IndoorARoomPointers.
IndoorARoomEC::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $c2, $00, $68  ; 2 down from (0, 0): object $68
	db $c2, $01, $6d  ; 2 down from (1, 0): object $6D
	db $02, $79  ; (2, 0): object $79
	db $03, $e3  ; (3, 0): object $E3
	db $82, $04, $e4  ; 2 across from (4, 0): object $E4
	db $06, $e5  ; (6, 0): object $E5
	db $12, $03  ; (2, 1): object $03
	db $13, $7f  ; (3, 1): object $7F
	db $82, $14, $4d  ; 2 across from (4, 1): object $4D
	db $16, $e6  ; (6, 1): object $E6
	db $07, $e3  ; (7, 0): object $E3
	db $82, $08, $e4  ; 2 across from (8, 0): object $E4
	db $17, $7f  ; (7, 1): object $7F
	db $82, $18, $4d  ; 2 across from (8, 1): object $4D
	db $8a, $20, $60  ; 10 across from (0, 2): object $60
	db $25, $61  ; (5, 2): object $61
	db $26, $64  ; (6, 2): object $64
	db $27, $5f  ; (7, 2): object $5F
	db $85, $30, $5c  ; 5 across from (0, 3): object $5C
	db $35, $5e  ; (5, 3): object $5E
	db $c2, $36, $65  ; 2 down from (6, 3): object $65
	db $c2, $37, $51  ; 2 down from (7, 3): object $51
	db $c5, $38, $54  ; 5 down from (8, 3): object $54
	db $c5, $39, $54  ; 5 down from (9, 3): object $54
	db $53, $82  ; (3, 5): object $82
	db $55, $64  ; (5, 5): object $64
	db $56, $59  ; (6, 5): object $59
	db $83, $57, $54  ; 3 across from (7, 5): object $54
	db $60, $5b  ; (0, 6): object $5B
	db $61, $5d  ; (1, 6): object $5D
	db $65, $65  ; (5, 6): object $65
	db $66, $51  ; (6, 6): object $51
	db $83, $67, $54  ; 3 across from (7, 6): object $54
	db $8a, $70, $54  ; 10 across from (0, 7): object $54
	db $84, $72, $5b  ; 4 across from (2, 7): object $5B
	db $e0, $00, $4a, $88, $30  ; warp type 0 to map $00 room $4A, x 136 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $ED of indoor group A: 29 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $03 at x 72, y 80. Format: see IndoorARoomPointers.
IndoorARoomED::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $02, $05  ; (2, 0): object $05
	db $03, $df  ; (3, 0): object $DF
	db $04, $25  ; (4, 0): object $25
	db $84, $05, $21  ; 4 across from (5, 0): object $21
	db $09, $26  ; (9, 0): object $26
	db $10, $05  ; (0, 1): object $05
	db $82, $11, $df  ; 2 across from (1, 1): object $DF
	db $13, $25  ; (3, 1): object $25
	db $14, $29  ; (4, 1): object $29
	db $c7, $19, $24  ; 7 down from (9, 1): object $24
	db $20, $25  ; (0, 2): object $25
	db $82, $21, $21  ; 2 across from (1, 2): object $21
	db $23, $29  ; (3, 2): object $29
	db $c3, $30, $23  ; 3 down from (0, 3): object $23
	db $35, $2c  ; (5, 3): object $2C
	db $36, $22  ; (6, 3): object $22
	db $37, $2b  ; (7, 3): object $2B
	db $45, $24  ; (5, 4): object $24
	db $c4, $46, $df  ; 4 down from (6, 4): object $DF
	db $c4, $47, $23  ; 4 down from (7, 4): object $23
	db $54, $2c  ; (4, 5): object $2C
	db $55, $28  ; (5, 5): object $28
	db $60, $27  ; (0, 6): object $27
	db $84, $61, $22  ; 4 across from (1, 6): object $22
	db $64, $28  ; (4, 6): object $28
	db $65, $df  ; (5, 6): object $DF
	db $66, $0d  ; (6, 6): object $0D
	db $84, $70, $df  ; 4 across from (0, 7): object $DF
	db $31, $cb  ; (1, 3): object $CB
	db $e0, $00, $03, $48, $50  ; warp type 0 to map $00 room $03, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $EF of indoor group A: 22 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $66 at x 72, y 80. Format: see IndoorARoomPointers.
IndoorARoomEF::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $83, $12, $6b  ; 3 across from (2, 1): object $6B
	db $13, $69  ; (3, 1): object $69
	db $83, $22, $69  ; 3 across from (2, 2): object $69
	db $23, $82  ; (3, 2): object $82
	db $83, $16, $6b  ; 3 across from (6, 1): object $6B
	db $17, $69  ; (7, 1): object $69
	db $83, $26, $69  ; 3 across from (6, 2): object $69
	db $27, $82  ; (7, 2): object $82
	db $8a, $00, $6d  ; 10 across from (0, 0): object $6D
	db $8a, $40, $6d  ; 10 across from (0, 4): object $6D
	db $c3, $10, $6c  ; 3 down from (0, 1): object $6C
	db $c3, $19, $6c  ; 3 down from (9, 1): object $6C
	db $c4, $01, $65  ; 4 down from (1, 0): object $65
	db $8a, $50, $83  ; 10 across from (0, 5): object $83
	db $8a, $60, $84  ; 10 across from (0, 6): object $84
	db $8a, $70, $84  ; 10 across from (0, 7): object $84
	db $43, $64  ; (3, 4): object $64
	db $83, $44, $04  ; 3 across from (4, 4): object $04
	db $82, $60, $4b  ; 2 across from (0, 6): object $4B
	db $82, $70, $4b  ; 2 across from (0, 7): object $4B
	db $82, $68, $4b  ; 2 across from (8, 6): object $4B
	db $82, $78, $4b  ; 2 across from (8, 7): object $4B
	db $e1, $03, $66, $48, $50  ; warp type 1 to map $03 room $66, x 72 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F0 of indoor group A: 35 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $9C at x 88, y 16. Format: see IndoorARoomPointers.
IndoorARoomF0::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $83, $02, $21  ; 3 across from (2, 0): object $21
	db $05, $26  ; (5, 0): object $26
	db $06, $df  ; (6, 0): object $DF
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $15, $2a  ; (5, 1): object $2A
	db $16, $26  ; (6, 1): object $26
	db $17, $df  ; (7, 1): object $DF
	db $c3, $20, $23  ; 3 down from (0, 2): object $23
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $82, $28, $df  ; 2 across from (8, 2): object $DF
	db $83, $34, $af  ; 3 across from (4, 3): object $AF
	db $37, $2a  ; (7, 3): object $2A
	db $82, $38, $21  ; 2 across from (8, 3): object $21
	db $41, $a6  ; (1, 4): object $A6
	db $43, $af  ; (3, 4): object $AF
	db $83, $44, $01  ; 3 across from (4, 4): object $01
	db $47, $ae  ; (7, 4): object $AE
	db $50, $27  ; (0, 5): object $27
	db $51, $2b  ; (1, 5): object $2B
	db $84, $53, $b0  ; 4 across from (3, 5): object $B0
	db $58, $a7  ; (8, 5): object $A7
	db $60, $df  ; (0, 6): object $DF
	db $61, $27  ; (1, 6): object $27
	db $84, $62, $22  ; 4 across from (2, 6): object $22
	db $66, $2b  ; (6, 6): object $2B
	db $68, $ae  ; (8, 6): object $AE
	db $85, $71, $df  ; 5 across from (1, 7): object $DF
	db $76, $27  ; (6, 7): object $27
	db $83, $77, $22  ; 3 across from (7, 7): object $22
	db $03, $a3  ; (3, 0): object $A3
	db $e0, $00, $9c, $58, $10  ; warp type 0 to map $00 room $9C, x 88 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F1 of indoor group A: 25 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $9D at x 56, y 48. Format: see IndoorARoomPointers.
IndoorARoomF1::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $83, $00, $df  ; 3 across from (0, 0): object $DF
	db $05, $df  ; (5, 0): object $DF
	db $c2, $10, $df  ; 2 down from (0, 1): object $DF
	db $83, $16, $df  ; 3 across from (6, 1): object $DF
	db $84, $21, $df  ; 4 across from (1, 2): object $DF
	db $29, $df  ; (9, 2): object $DF
	db $84, $30, $21  ; 4 across from (0, 3): object $21
	db $34, $26  ; (4, 3): object $26
	db $83, $35, $df  ; 3 across from (5, 3): object $DF
	db $82, $42, $0e  ; 2 across from (2, 4): object $0E
	db $44, $2a  ; (4, 4): object $2A
	db $82, $45, $21  ; 2 across from (5, 4): object $21
	db $47, $26  ; (7, 4): object $26
	db $48, $df  ; (8, 4): object $DF
	db $84, $51, $0e  ; 4 across from (1, 5): object $0E
	db $82, $55, $1b  ; 2 across from (5, 5): object $1B
	db $57, $2a  ; (7, 5): object $2A
	db $58, $21  ; (8, 5): object $21
	db $59, $26  ; (9, 5): object $26
	db $83, $61, $0e  ; 3 across from (1, 6): object $0E
	db $82, $64, $1b  ; 2 across from (4, 6): object $1B
	db $69, $24  ; (9, 6): object $24
	db $89, $70, $22  ; 9 across from (0, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $58, $a3  ; (8, 5): object $A3
	db $e0, $00, $9d, $38, $30  ; warp type 0 to map $00 room $9D, x 56 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F2 of indoor group A: 19 objects, room template 0 and floor object $0E; a warp (type 0) to overworld room $2E at x 88, y 32. Format: see IndoorARoomPointers.
IndoorARoomF2::
	db $0c, $0e  ; animated tiles $0C, template 0, floor $0E
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $73, $2b  ; (3, 7): object $2B
	db $74, $0e  ; (4, 7): object $0E
	db $75, $2c  ; (5, 7): object $2C
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $e0, $00, $2e, $58, $20  ; warp type 0 to map $00 room $2E, x 88 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F3 of indoor group A: 33 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $87 at x 40, y 16. Format: see IndoorARoomPointers.
IndoorARoomF3::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $0d  ; (0, 0): object $0D
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $c3, $12, $10  ; 3 down from (2, 1): object $10
	db $13, $25  ; (3, 1): object $25
	db $82, $14, $21  ; 2 across from (4, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $c3, $17, $11  ; 3 down from (7, 1): object $11
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $23, $23  ; (3, 2): object $23
	db $82, $24, $1b  ; 2 across from (4, 2): object $1B
	db $26, $24  ; (6, 2): object $24
	db $33, $27  ; (3, 3): object $27
	db $82, $34, $22  ; 2 across from (4, 3): object $22
	db $36, $28  ; (6, 3): object $28
	db $42, $87  ; (2, 4): object $87
	db $52, $ce  ; (2, 5): object $CE
	db $84, $43, $12  ; 4 across from (3, 4): object $12
	db $47, $87  ; (7, 4): object $87
	db $57, $ce  ; (7, 5): object $CE
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $87, $28, $10  ; warp type 0 to map $00 room $87, x 40 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F4 of indoor group A: 27 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $92 at x 88, y 82. Format: see IndoorARoomPointers.
IndoorARoomF4::
	db $0c, $9d  ; animated tiles $0C, template 9, floor $0D
	db $c4, $00, $df  ; 4 down from (0, 0): object $DF
	db $c4, $21, $df  ; 4 down from (1, 2): object $DF
	db $02, $00  ; (2, 0): object $00
	db $c7, $03, $23  ; 7 down from (3, 0): object $23
	db $c7, $06, $24  ; 7 down from (6, 0): object $24
	db $c3, $07, $df  ; 3 down from (7, 0): object $DF
	db $09, $00  ; (9, 0): object $00
	db $12, $df  ; (2, 1): object $DF
	db $c3, $18, $df  ; 3 down from (8, 1): object $DF
	db $19, $df  ; (9, 1): object $DF
	db $22, $00  ; (2, 2): object $00
	db $29, $00  ; (9, 2): object $00
	db $37, $00  ; (7, 3): object $00
	db $40, $00  ; (0, 4): object $00
	db $42, $df  ; (2, 4): object $DF
	db $47, $df  ; (7, 4): object $DF
	db $c2, $48, $00  ; 2 down from (8, 4): object $00
	db $c2, $52, $00  ; 2 down from (2, 5): object $00
	db $57, $00  ; (7, 5): object $00
	db $c3, $59, $df  ; 3 down from (9, 5): object $DF
	db $c2, $60, $df  ; 2 down from (0, 6): object $DF
	db $c2, $68, $df  ; 2 down from (8, 6): object $DF
	db $71, $df  ; (1, 7): object $DF
	db $73, $27  ; (3, 7): object $27
	db $82, $74, $22  ; 2 across from (4, 7): object $22
	db $76, $28  ; (6, 7): object $28
	db $65, $cb  ; (5, 6): object $CB
	db $e0, $00, $92, $58, $52  ; warp type 0 to map $00 room $92, x 88 y 82
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F5 of indoor group A: 23 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $F4 at x 24, y 32. Format: see IndoorARoomPointers.
IndoorARoomF5::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $82, $14, $1b  ; 2 across from (4, 1): object $1B
	db $84, $23, $1b  ; 4 across from (3, 2): object $1B
	db $84, $33, $1b  ; 4 across from (3, 3): object $1B
	db $82, $44, $1b  ; 2 across from (4, 4): object $1B
	db $74, $3d  ; (4, 7): object $3D
	db $e0, $00, $f4, $18, $20  ; warp type 0 to map $00 room $F4, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Second layout of room $F5 of indoor group A: 27 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $F4 at x 24, y 32. Format: see IndoorARoomPointers. The loader uses it instead of the first layout once the room's event has happened.
IndoorARoomF5Alt::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $03, $c7  ; (3, 0): object $C7
	db $06, $c7  ; (6, 0): object $C7
	db $82, $14, $1b  ; 2 across from (4, 1): object $1B
	db $84, $23, $1b  ; 4 across from (3, 2): object $1B
	db $84, $33, $1b  ; 4 across from (3, 3): object $1B
	db $82, $44, $1b  ; 2 across from (4, 4): object $1B
	db $21, $c5  ; (1, 2): object $C5
	db $31, $c6  ; (1, 3): object $C6
	db $24, $9b  ; (4, 2): object $9B
	db $25, $9c  ; (5, 2): object $9C
	db $74, $3d  ; (4, 7): object $3D
	db $e0, $00, $f4, $18, $20  ; warp type 0 to map $00 room $F4, x 24 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F6 of indoor group A: 47 objects, room template 9 and floor object $05; a warp (type 0) to overworld room $F9 at x 120, y 80. Format: see IndoorARoomPointers.
IndoorARoomF6::
	db $0c, $95  ; animated tiles $0C, template 9, floor $05
	db $82, $00, $df  ; 2 across from (0, 0): object $DF
	db $02, $23  ; (2, 0): object $23
	db $84, $03, $0e  ; 4 across from (3, 0): object $0E
	db $06, $2a  ; (6, 0): object $2A
	db $07, $26  ; (7, 0): object $26
	db $c2, $08, $df  ; 2 down from (8, 0): object $DF
	db $c2, $09, $0d  ; 2 down from (9, 0): object $0D
	db $c2, $10, $0d  ; 2 down from (0, 1): object $0D
	db $11, $df  ; (1, 1): object $DF
	db $12, $27  ; (2, 1): object $27
	db $13, $2b  ; (3, 1): object $2B
	db $83, $14, $0e  ; 3 across from (4, 1): object $0E
	db $17, $24  ; (7, 1): object $24
	db $c2, $21, $0d  ; 2 down from (1, 2): object $0D
	db $22, $df  ; (2, 2): object $DF
	db $23, $27  ; (3, 2): object $27
	db $24, $2b  ; (4, 2): object $2B
	db $82, $25, $1b  ; 2 across from (5, 2): object $1B
	db $27, $2a  ; (7, 2): object $2A
	db $28, $26  ; (8, 2): object $26
	db $29, $df  ; (9, 2): object $DF
	db $c2, $32, $0d  ; 2 down from (2, 3): object $0D
	db $33, $df  ; (3, 3): object $DF
	db $34, $27  ; (4, 3): object $27
	db $35, $2b  ; (5, 3): object $2B
	db $82, $36, $1b  ; 2 across from (6, 3): object $1B
	db $38, $2a  ; (8, 3): object $2A
	db $39, $26  ; (9, 3): object $26
	db $40, $0d  ; (0, 4): object $0D
	db $82, $42, $0d  ; 2 across from (2, 4): object $0D
	db $c2, $44, $df  ; 2 down from (4, 4): object $DF
	db $45, $23  ; (5, 4): object $23
	db $46, $1b  ; (6, 4): object $1B
	db $c3, $49, $24  ; 3 down from (9, 4): object $24
	db $51, $0d  ; (1, 5): object $0D
	db $52, $df  ; (2, 5): object $DF
	db $55, $27  ; (5, 5): object $27
	db $56, $2b  ; (6, 5): object $2B
	db $c2, $63, $df  ; 2 down from (3, 6): object $DF
	db $c2, $64, $0d  ; 2 down from (4, 6): object $0D
	db $c2, $65, $df  ; 2 down from (5, 6): object $DF
	db $66, $23  ; (6, 6): object $23
	db $70, $df  ; (0, 7): object $DF
	db $76, $27  ; (6, 7): object $27
	db $82, $77, $22  ; 2 across from (7, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $68, $cb  ; (8, 6): object $CB
	db $e0, $00, $f9, $78, $50  ; warp type 0 to map $00 room $F9, x 120 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F7 of indoor group A: 50 objects, room template 9 and floor object $00; a warp (type 0) to overworld room $8F at x 8, y 32. Format: see IndoorARoomPointers.
IndoorARoomF7::
	db $0c, $90  ; animated tiles $0C, template 9, floor $00
	db $c2, $00, $23  ; 2 down from (0, 0): object $23
	db $82, $02, $1b  ; 2 across from (2, 0): object $1B
	db $c2, $04, $24  ; 2 down from (4, 0): object $24
	db $83, $05, $df  ; 3 across from (5, 0): object $DF
	db $83, $11, $1b  ; 3 across from (1, 1): object $1B
	db $15, $df  ; (5, 1): object $DF
	db $18, $df  ; (8, 1): object $DF
	db $20, $27  ; (0, 2): object $27
	db $21, $2b  ; (1, 2): object $2B
	db $22, $1b  ; (2, 2): object $1B
	db $23, $0e  ; (3, 2): object $0E
	db $24, $2a  ; (4, 2): object $2A
	db $25, $26  ; (5, 2): object $26
	db $82, $26, $0d  ; 2 across from (6, 2): object $0D
	db $c3, $29, $df  ; 3 down from (9, 2): object $DF
	db $c2, $30, $df  ; 2 down from (0, 3): object $DF
	db $31, $23  ; (1, 3): object $23
	db $83, $32, $0e  ; 3 across from (2, 3): object $0E
	db $35, $2a  ; (5, 3): object $2A
	db $36, $26  ; (6, 3): object $26
	db $37, $df  ; (7, 3): object $DF
	db $38, $0d  ; (8, 3): object $0D
	db $41, $27  ; (1, 4): object $27
	db $42, $2b  ; (2, 4): object $2B
	db $83, $43, $0e  ; 3 across from (3, 4): object $0E
	db $46, $2a  ; (6, 4): object $2A
	db $47, $26  ; (7, 4): object $26
	db $48, $df  ; (8, 4): object $DF
	db $50, $0d  ; (0, 5): object $0D
	db $51, $df  ; (1, 5): object $DF
	db $52, $27  ; (2, 5): object $27
	db $53, $2b  ; (3, 5): object $2B
	db $83, $54, $0e  ; 3 across from (4, 5): object $0E
	db $57, $2a  ; (7, 5): object $2A
	db $59, $26  ; (9, 5): object $26
	db $61, $0d  ; (1, 6): object $0D
	db $62, $df  ; (2, 6): object $DF
	db $63, $27  ; (3, 6): object $27
	db $64, $22  ; (4, 6): object $22
	db $65, $2b  ; (5, 6): object $2B
	db $83, $66, $0e  ; 3 across from (6, 6): object $0E
	db $69, $24  ; (9, 6): object $24
	db $72, $0d  ; (2, 7): object $0D
	db $82, $73, $df  ; 2 across from (3, 7): object $DF
	db $75, $27  ; (5, 7): object $27
	db $83, $76, $22  ; 3 across from (6, 7): object $22
	db $79, $28  ; (9, 7): object $28
	db $68, $1b  ; (8, 6): object $1B
	db $01, $0d  ; (1, 0): object $0D
	db $58, $a3  ; (8, 5): object $A3
	db $e0, $00, $8f, $08, $20  ; warp type 0 to map $00 room $8F, x 8 y 32
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F8 of indoor group A: 29 objects, room template 0 and floor object $05. Format: see IndoorARoomPointers.
IndoorARoomF8::
	db $0c, $05  ; animated tiles $0C, template 0, floor $05
	db $04, $47  ; (4, 0): object $47
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $22, $0f  ; (2, 2): object $0F
	db $36, $0f  ; (6, 3): object $0F
	db $31, $0f  ; (1, 3): object $0F
	db $44, $0f  ; (4, 4): object $0F
	db $67, $0f  ; (7, 6): object $0F
	db $82, $25, $0f  ; 2 across from (5, 2): object $0F
	db $39, $2a  ; (9, 3): object $2A
	db $49, $05  ; (9, 4): object $05
	db $59, $2c  ; (9, 5): object $2C
	db $38, $ae  ; (8, 3): object $AE
	db $42, $ae  ; (2, 4): object $AE
	db $62, $ae  ; (2, 6): object $AE
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $F9 of indoor group A: 26 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $CF at x 88, y 16. Format: see IndoorARoomPointers.
IndoorARoomF9::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $df  ; (0, 0): object $DF
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $22, $05  ; (2, 2): object $05
	db $36, $05  ; (6, 3): object $05
	db $31, $05  ; (1, 3): object $05
	db $44, $05  ; (4, 4): object $05
	db $67, $05  ; (7, 6): object $05
	db $82, $25, $05  ; 2 across from (5, 2): object $05
	db $30, $29  ; (0, 3): object $29
	db $40, $05  ; (0, 4): object $05
	db $50, $2b  ; (0, 5): object $2B
	db $57, $cb  ; (7, 5): object $CB
	db $e0, $00, $cf, $58, $10  ; warp type 0 to map $00 room $CF, x 88 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FA of indoor group A: 11 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $B0 at x 56, y 50. Format: see IndoorARoomPointers.
IndoorARoomFA::
	db $04, $0d  ; animated tiles $04, template 0, floor $0D
	db $88, $01, $99  ; 8 across from (1, 0): object $99
	db $88, $11, $9a  ; 8 across from (1, 1): object $9A
	db $21, $ce  ; (1, 2): object $CE
	db $23, $ce  ; (3, 2): object $CE
	db $26, $ce  ; (6, 2): object $CE
	db $28, $ce  ; (8, 2): object $CE
	db $51, $ce  ; (1, 5): object $CE
	db $53, $ce  ; (3, 5): object $CE
	db $56, $ce  ; (6, 5): object $CE
	db $58, $ce  ; (8, 5): object $CE
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $b0, $38, $32  ; warp type 0 to map $00 room $B0, x 56 y 50
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FB of indoor group A: 33 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $1F at x 56, y 80. Format: see IndoorARoomPointers.
IndoorARoomFB::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $00, $0d  ; (0, 0): object $0D
	db $01, $25  ; (1, 0): object $25
	db $08, $26  ; (8, 0): object $26
	db $09, $df  ; (9, 0): object $DF
	db $10, $25  ; (0, 1): object $25
	db $11, $29  ; (1, 1): object $29
	db $c3, $12, $10  ; 3 down from (2, 1): object $10
	db $13, $25  ; (3, 1): object $25
	db $82, $14, $21  ; 2 across from (4, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $c3, $17, $11  ; 3 down from (7, 1): object $11
	db $18, $2a  ; (8, 1): object $2A
	db $19, $26  ; (9, 1): object $26
	db $23, $23  ; (3, 2): object $23
	db $82, $24, $1b  ; 2 across from (4, 2): object $1B
	db $26, $24  ; (6, 2): object $24
	db $33, $27  ; (3, 3): object $27
	db $82, $34, $22  ; 2 across from (4, 3): object $22
	db $36, $28  ; (6, 3): object $28
	db $42, $87  ; (2, 4): object $87
	db $52, $ce  ; (2, 5): object $CE
	db $84, $43, $12  ; 4 across from (3, 4): object $12
	db $47, $87  ; (7, 4): object $87
	db $57, $ce  ; (7, 5): object $CE
	db $60, $27  ; (0, 6): object $27
	db $61, $2b  ; (1, 6): object $2B
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $70, $df  ; (0, 7): object $DF
	db $71, $27  ; (1, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $0d  ; (9, 7): object $0D
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $1f, $38, $50  ; warp type 0 to map $00 room $1F, x 56 y 80
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FC of indoor group A: 11 objects, room template 0 and floor object $0D; a warp (type 0) to overworld room $38 at x 88, y 48. Format: see IndoorARoomPointers.
IndoorARoomFC::
	db $0c, $0d  ; animated tiles $0C, template 0, floor $0D
	db $84, $11, $1b  ; 4 across from (1, 1): object $1B
	db $85, $21, $1b  ; 5 across from (1, 2): object $1B
	db $86, $31, $1b  ; 6 across from (1, 3): object $1B
	db $86, $41, $1b  ; 6 across from (1, 4): object $1B
	db $87, $51, $1b  ; 7 across from (1, 5): object $1B
	db $88, $61, $1b  ; 8 across from (1, 6): object $1B
	db $25, $0f  ; (5, 2): object $0F
	db $51, $0e  ; (1, 5): object $0E
	db $83, $61, $0e  ; 3 across from (1, 6): object $0E
	db $15, $a0  ; (5, 1): object $A0
	db $74, $fd  ; (4, 7): object $FD
	db $e0, $00, $38, $58, $30  ; warp type 0 to map $00 room $38, x 88 y 48
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FD of indoor group A: 31 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $78 at x 40, y 112. Format: see IndoorARoomPointers.
IndoorARoomFD::
	db $04, $9d  ; animated tiles $04, template 9, floor $0D
	db $8a, $00, $df  ; 10 across from (0, 0): object $DF
	db $82, $10, $df  ; 2 across from (0, 1): object $DF
	db $82, $18, $df  ; 2 across from (8, 1): object $DF
	db $82, $20, $df  ; 2 across from (0, 2): object $DF
	db $82, $27, $df  ; 2 across from (7, 2): object $DF
	db $85, $34, $df  ; 5 across from (4, 3): object $DF
	db $c2, $29, $df  ; 2 down from (9, 2): object $DF
	db $82, $44, $df  ; 2 across from (4, 4): object $DF
	db $82, $54, $df  ; 2 across from (4, 5): object $DF
	db $82, $74, $df  ; 2 across from (4, 7): object $DF
	db $13, $25  ; (3, 1): object $25
	db $82, $14, $21  ; 2 across from (4, 1): object $21
	db $16, $26  ; (6, 1): object $26
	db $22, $25  ; (2, 2): object $25
	db $23, $29  ; (3, 2): object $29
	db $82, $24, $05  ; 2 across from (4, 2): object $05
	db $26, $2a  ; (6, 2): object $2A
	db $27, $26  ; (7, 2): object $26
	db $32, $23  ; (2, 3): object $23
	db $84, $33, $05  ; 4 across from (3, 3): object $05
	db $37, $24  ; (7, 3): object $24
	db $42, $27  ; (2, 4): object $27
	db $43, $2b  ; (3, 4): object $2B
	db $82, $44, $05  ; 2 across from (4, 4): object $05
	db $46, $2c  ; (6, 4): object $2C
	db $47, $28  ; (7, 4): object $28
	db $53, $27  ; (3, 5): object $27
	db $82, $54, $22  ; 2 across from (4, 5): object $22
	db $56, $28  ; (6, 5): object $28
	db $24, $a0  ; (4, 2): object $A0
	db $45, $cb  ; (5, 4): object $CB
	db $e0, $00, $78, $28, $70  ; warp type 0 to map $00 room $78, x 40 y 112
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FE of indoor group A: 28 objects, room template 9 and floor object $0D; a warp (type 0) to overworld room $13 at x 88, y 16. Format: see IndoorARoomPointers.
IndoorARoomFE::
	db $00, $9d  ; animated tiles $00, template 9, floor $0D
	db $87, $00, $df  ; 7 across from (0, 0): object $DF
	db $05, $0d  ; (5, 0): object $0D
	db $c4, $07, $23  ; 4 down from (7, 0): object $23
	db $c6, $09, $24  ; 6 down from (9, 0): object $24
	db $82, $11, $df  ; 2 across from (1, 1): object $DF
	db $c3, $14, $05  ; 3 down from (4, 1): object $05
	db $20, $05  ; (0, 2): object $05
	db $25, $df  ; (5, 2): object $DF
	db $c3, $28, $df  ; 3 down from (8, 2): object $DF
	db $30, $df  ; (0, 3): object $DF
	db $83, $40, $df  ; 3 across from (0, 4): object $DF
	db $44, $df  ; (4, 4): object $DF
	db $45, $25  ; (5, 4): object $25
	db $46, $21  ; (6, 4): object $21
	db $47, $29  ; (7, 4): object $29
	db $52, $05  ; (2, 5): object $05
	db $53, $df  ; (3, 5): object $DF
	db $c2, $55, $23  ; 2 down from (5, 5): object $23
	db $82, $57, $df  ; 2 across from (7, 5): object $DF
	db $60, $df  ; (0, 6): object $DF
	db $64, $df  ; (4, 6): object $DF
	db $68, $2c  ; (8, 6): object $2C
	db $69, $28  ; (9, 6): object $28
	db $83, $72, $df  ; 3 across from (2, 7): object $DF
	db $75, $27  ; (5, 7): object $27
	db $78, $28  ; (8, 7): object $28
	db $79, $df  ; (9, 7): object $DF
	db $76, $fd  ; (6, 7): object $FD
	db $e0, $00, $13, $58, $10  ; warp type 0 to map $00 room $13, x 88 y 16
	db $fe  ; end

;@ path: world/indoor/rooms
;@ Room $FF of indoor group A: 22 objects, room template 9 and floor object $04; a warp (type 1) to map $03 room $66 at x 72, y 80. Format: see IndoorARoomPointers.
IndoorARoomFF::
	db $05, $94  ; animated tiles $05, template 9, floor $04
	db $8a, $00, $84  ; 10 across from (0, 0): object $84
	db $8a, $10, $84  ; 10 across from (0, 1): object $84
	db $8a, $20, $84  ; 10 across from (0, 2): object $84
	db $8a, $30, $84  ; 10 across from (0, 3): object $84
	db $8a, $40, $84  ; 10 across from (0, 4): object $84
	db $8a, $50, $84  ; 10 across from (0, 5): object $84
	db $8a, $60, $84  ; 10 across from (0, 6): object $84
	db $8a, $70, $84  ; 10 across from (0, 7): object $84
	db $82, $00, $4b  ; 2 across from (0, 0): object $4B
	db $82, $08, $4b  ; 2 across from (8, 0): object $4B
	db $10, $4b  ; (0, 1): object $4B
	db $19, $4b  ; (9, 1): object $4B
	db $60, $72  ; (0, 6): object $72
	db $61, $73  ; (1, 6): object $73
	db $68, $74  ; (8, 6): object $74
	db $69, $72  ; (9, 6): object $72
	db $83, $70, $72  ; 3 across from (0, 7): object $72
	db $73, $73  ; (3, 7): object $73
	db $74, $74  ; (4, 7): object $74
	db $75, $72  ; (5, 7): object $72
	db $76, $7e  ; (6, 7): object $7E
	db $83, $77, $72  ; 3 across from (7, 7): object $72
	db $e1, $03, $66, $48, $50  ; warp type 1 to map $03 room $66, x 72 y 80
	db $fe  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank0AFreeSpace::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
