; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01a", ROMX[$4000], BANK[$1a]

;@ path: world/overworld/rooms
;@ Overworld room $80 (row 8, column 0 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom80::
	db $03, $04  ; animated tiles $03, floor $04
	db $f0, $f5  ; (0, 15): object $F5
	db $f2, $f5  ; (2, 15): object $F5
	db $01, $f5  ; (1, 0): object $F5
	db $21, $f5  ; (1, 2): object $F5
	db $c4, $09, $f5  ; 4 down from (9, 0): object $F5
	db $c5, $f8, $f5  ; 5 down from (8, 15): object $F5
	db $c2, $47, $f5  ; 2 down from (7, 4): object $F5
	db $c2, $42, $f5  ; 2 down from (2, 4): object $F5
	db $c3, $33, $f5  ; 3 down from (3, 3): object $F5
	db $c2, $44, $f5  ; 2 down from (4, 4): object $F5
	db $10, $f5  ; (0, 1): object $F5
	db $20, $3c  ; (0, 2): object $3C
	db $30, $37  ; (0, 3): object $37
	db $40, $2e  ; (0, 4): object $2E
	db $41, $3c  ; (1, 4): object $3C
	db $c3, $51, $37  ; 3 down from (1, 5): object $37
	db $50, $3e  ; (0, 5): object $3E
	db $60, $39  ; (0, 6): object $39
	db $70, $0e  ; (0, 7): object $0E
	db $16, $0a  ; (6, 1): object $0A
	db $c4, $07, $0a  ; 4 down from (7, 0): object $0A
	db $07, $44  ; (7, 0): object $44
	db $35, $44  ; (5, 3): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $81 (row 8, column 1 of the 16 x 16 map): 26 objects on floor object $04; a warp (type 2) to map $0F room $B1 at x 140, y 34. Format: see OverworldRoomPointers.
OverworldRoom81::
	db $03, $04  ; animated tiles $03, floor $04
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $c4, $08, $f5  ; 4 down from (8, 0): object $F5
	db $84, $f0, $f5  ; 4 across from (0, 15): object $F5
	db $c4, $0f, $f5  ; 4 down from (15, 0): object $F5
	db $70, $f5  ; (0, 7): object $F5
	db $11, $3d  ; (1, 1): object $3D
	db $82, $12, $2f  ; 2 across from (2, 1): object $2F
	db $14, $3c  ; (4, 1): object $3C
	db $83, $15, $0a  ; 3 across from (5, 1): object $0A
	db $83, $25, $0a  ; 3 across from (5, 2): object $0A
	db $15, $fd  ; (5, 1): object $FD
	db $26, $5b  ; (6, 2): object $5B
	db $c3, $21, $38  ; 3 down from (1, 2): object $38
	db $24, $37  ; (4, 2): object $37
	db $34, $33  ; (4, 3): object $33
	db $35, $3c  ; (5, 3): object $3C
	db $45, $37  ; (5, 4): object $37
	db $51, $32  ; (1, 5): object $32
	db $83, $52, $2c  ; 3 across from (2, 5): object $2C
	db $55, $31  ; (5, 5): object $31
	db $82, $22, $0e  ; 2 across from (2, 2): object $0E
	db $82, $32, $0e  ; 2 across from (2, 3): object $0E
	db $83, $42, $0e  ; 3 across from (2, 4): object $0E
	db $82, $36, $0a  ; 2 across from (6, 3): object $0A
	db $e2, $0f, $b1, $8c, $22  ; warp type 2 to map $0F room $B1, x 140 y 34
	db $47, $44  ; (7, 4): object $44
	db $63, $44  ; (3, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $82 (row 8, column 2 of the 16 x 16 map): 19 objects on floor object $04; a warp (type 1) to map $10 room $A5 at x 80, y 124; a warp (type 1) to map $10 room $A6 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom82::
	db $10, $04  ; animated tiles $10, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $85, $00, $f5  ; 5 across from (0, 0): object $F5
	db $c4, $1f, $f5  ; 4 down from (15, 1): object $F5
	db $c3, $21, $5c  ; 3 down from (1, 2): object $5C
	db $42, $5c  ; (2, 4): object $5C
	db $53, $5c  ; (3, 5): object $5C
	db $84, $63, $5c  ; 4 across from (3, 6): object $5C
	db $51, $36  ; (1, 5): object $36
	db $52, $3c  ; (2, 5): object $3C
	db $62, $37  ; (2, 6): object $37
	db $72, $2e  ; (2, 7): object $2E
	db $84, $73, $2f  ; 4 across from (3, 7): object $2F
	db $77, $48  ; (7, 7): object $48
	db $78, $4a  ; (8, 7): object $4A
	db $79, $49  ; (9, 7): object $49
	db $85, $55, $0b  ; 5 across from (5, 5): object $0B
	db $24, $f6  ; (4, 2): object $F6
	db $e1, $10, $a5, $50, $7c  ; warp type 1 to map $10 room $A5, x 80 y 124
	db $e1, $10, $a6, $50, $7c  ; warp type 1 to map $10 room $A6, x 80 y 124
	db $54, $44  ; (4, 5): object $44
	db $68, $44  ; (8, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $83 (row 8, column 3 of the 16 x 16 map): 23 objects on floor object $04; a warp (type 1) to map $13 room $AA at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom83::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $85, $00, $f5  ; 5 across from (0, 0): object $F5
	db $84, $70, $2f  ; 4 across from (0, 7): object $2F
	db $71, $e0  ; (1, 7): object $E0
	db $74, $4e  ; (4, 7): object $4E
	db $64, $3d  ; (4, 6): object $3D
	db $65, $35  ; (5, 6): object $35
	db $21, $5f  ; (1, 2): object $5F
	db $22, $5f  ; (2, 2): object $5F
	db $23, $5f  ; (3, 2): object $5F
	db $31, $60  ; (1, 3): object $60
	db $33, $60  ; (3, 3): object $60
	db $41, $20  ; (1, 4): object $20
	db $43, $20  ; (3, 4): object $20
	db $52, $20  ; (2, 5): object $20
	db $32, $e2  ; (2, 3): object $E2
	db $e1, $13, $aa, $50, $7c  ; warp type 1 to map $13 room $AA, x 80 y 124
	db $50, $0b  ; (0, 5): object $0B
	db $c2, $51, $0b  ; 2 down from (1, 5): object $0B
	db $26, $44  ; (6, 2): object $44
	db $40, $44  ; (0, 4): object $44
	db $54, $44  ; (4, 5): object $44
	db $67, $44  ; (7, 6): object $44
	db $c2, $49, $f5  ; 2 down from (9, 4): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $84 (row 8, column 4 of the 16 x 16 map): 20 objects on floor object $04; a warp (type 1) to map $11 room $CD at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom84::
	db $03, $04  ; animated tiles $03, floor $04
	db $ff, $f5  ; (15, 15): object $F5
	db $85, $00, $f5  ; 5 across from (0, 0): object $F5
	db $c4, $15, $f5  ; 4 down from (5, 1): object $F5
	db $83, $22, $5c  ; 3 across from (2, 2): object $5C
	db $c2, $35, $5c  ; 2 down from (5, 3): object $5C
	db $c2, $36, $04  ; 2 down from (6, 3): object $04
	db $36, $f5  ; (6, 3): object $F5
	db $27, $36  ; (7, 2): object $36
	db $28, $3c  ; (8, 2): object $3C
	db $38, $2e  ; (8, 3): object $2E
	db $39, $2f  ; (9, 3): object $2F
	db $48, $3e  ; (8, 4): object $3E
	db $49, $3a  ; (9, 4): object $3A
	db $29, $0a  ; (9, 2): object $0A
	db $83, $57, $0a  ; 3 across from (7, 5): object $0A
	db $82, $68, $0a  ; 2 across from (8, 6): object $0A
	db $79, $0a  ; (9, 7): object $0A
	db $58, $39  ; (8, 5): object $39
	db $59, $e1  ; (9, 5): object $E1
	db $e1, $11, $cd, $50, $7c  ; warp type 1 to map $11 room $CD, x 80 y 124
	db $c2, $4f, $f5  ; 2 down from (15, 4): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $85 (row 8, column 5 of the 16 x 16 map): 31 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoom85::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $8a, $00, $04  ; 10 across from (0, 0): object $04
	db $8a, $10, $04  ; 10 across from (0, 1): object $04
	db $87, $20, $04  ; 7 across from (0, 2): object $04
	db $88, $30, $2f  ; 8 across from (0, 3): object $2F
	db $88, $40, $3a  ; 8 across from (0, 4): object $3A
	db $88, $50, $3a  ; 8 across from (0, 5): object $3A
	db $34, $48  ; (4, 3): object $48
	db $36, $49  ; (6, 3): object $49
	db $37, $4e  ; (7, 3): object $4E
	db $17, $3d  ; (7, 1): object $3D
	db $82, $18, $2f  ; 2 across from (8, 1): object $2F
	db $27, $38  ; (7, 2): object $38
	db $82, $73, $04  ; 2 across from (3, 7): object $04
	db $82, $68, $04  ; 2 across from (8, 6): object $04
	db $82, $77, $04  ; 2 across from (7, 7): object $04
	db $47, $3f  ; (7, 4): object $3F
	db $57, $3b  ; (7, 5): object $3B
	db $86, $04, $04  ; 6 across from (4, 0): object $04
	db $82, $15, $04  ; 2 across from (5, 1): object $04
	db $82, $28, $3a  ; 2 across from (8, 2): object $3A
	db $82, $38, $3a  ; 2 across from (8, 3): object $3A
	db $25, $20  ; (5, 2): object $20
	db $35, $4a  ; (5, 3): object $4A
	db $f8, $f5  ; (8, 15): object $F5
	db $82, $68, $44  ; 2 across from (8, 6): object $44
	db $73, $44  ; (3, 7): object $44
	db $c3, $59, $04  ; 3 down from (9, 5): object $04
	db $c2, $49, $f5  ; 2 down from (9, 4): object $F5
	db $83, $00, $f5  ; 3 across from (0, 0): object $F5
	db $21, $44  ; (1, 2): object $44
	db $c3, $35, $e0  ; 3 down from (5, 3): object $E0
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $86 (row 8, column 6 of the 16 x 16 map): 35 objects on floor object $04; a warp (type 1) to map $11 room $F4 at x 64, y 124. Format: see OverworldRoomPointers.
OverworldRoom86::
	db $03, $04  ; animated tiles $03, floor $04
	db $87, $03, $3a  ; 7 across from (3, 0): object $3A
	db $02, $38  ; (2, 0): object $38
	db $82, $10, $2f  ; 2 across from (0, 1): object $2F
	db $12, $4e  ; (2, 1): object $4E
	db $82, $20, $3a  ; 2 across from (0, 2): object $3A
	db $82, $30, $3a  ; 2 across from (0, 3): object $3A
	db $22, $3f  ; (2, 2): object $3F
	db $32, $3b  ; (2, 3): object $3B
	db $82, $13, $0a  ; 2 across from (3, 1): object $0A
	db $82, $23, $0a  ; 2 across from (3, 2): object $0A
	db $33, $0a  ; (3, 3): object $0A
	db $82, $43, $0a  ; 2 across from (3, 4): object $0A
	db $85, $50, $0a  ; 5 across from (0, 5): object $0A
	db $57, $0a  ; (7, 5): object $0A
	db $83, $60, $0a  ; 3 across from (0, 6): object $0A
	db $65, $0a  ; (5, 6): object $0A
	db $84, $70, $0a  ; 4 across from (0, 7): object $0A
	db $69, $f5  ; (9, 6): object $F5
	db $37, $44  ; (7, 3): object $44
	db $55, $44  ; (5, 5): object $44
	db $83, $15, $5c  ; 3 across from (5, 1): object $5C
	db $f0, $f5  ; (0, 15): object $F5
	db $27, $e8  ; (7, 2): object $E8
	db $34, $e8  ; (4, 3): object $E8
	db $46, $e8  ; (6, 4): object $E8
	db $48, $e8  ; (8, 4): object $E8
	db $54, $e8  ; (4, 5): object $E8
	db $66, $e8  ; (6, 6): object $E8
	db $c3, $50, $04  ; 3 down from (0, 5): object $04
	db $c2, $4f, $f5  ; 2 down from (15, 4): object $F5
	db $82, $41, $0a  ; 2 across from (1, 4): object $0A
	db $84, $36, $0b  ; 4 across from (6, 3): object $0B
	db $82, $44, $0b  ; 2 across from (4, 4): object $0B
	db $c2, $64, $0b  ; 2 down from (4, 6): object $0B
	db $31, $ba  ; (1, 3): object $BA
	db $e1, $11, $f4, $40, $7c  ; warp type 1 to map $11 room $F4, x 64 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $87 (row 8, column 7 of the 16 x 16 map): 31 objects on floor object $04; a warp (type 1) to map $1F room $F3 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom87::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $29, $f5  ; 2 down from (9, 2): object $F5
	db $f6, $f5  ; (6, 15): object $F5
	db $08, $f5  ; (8, 0): object $F5
	db $85, $00, $3a  ; 5 across from (0, 0): object $3A
	db $05, $3b  ; (5, 0): object $3B
	db $24, $f5  ; (4, 2): object $F5
	db $33, $0a  ; (3, 3): object $0A
	db $36, $0a  ; (6, 3): object $0A
	db $82, $44, $0a  ; 2 across from (4, 4): object $0A
	db $11, $44  ; (1, 1): object $44
	db $23, $44  ; (3, 2): object $44
	db $26, $44  ; (6, 2): object $44
	db $32, $44  ; (2, 3): object $44
	db $37, $44  ; (7, 3): object $44
	db $43, $44  ; (3, 4): object $44
	db $46, $44  ; (6, 4): object $44
	db $54, $44  ; (4, 5): object $44
	db $55, $44  ; (5, 5): object $44
	db $64, $44  ; (4, 6): object $44
	db $65, $44  ; (5, 6): object $44
	db $17, $5c  ; (7, 1): object $5C
	db $c2, $28, $5c  ; 2 down from (8, 2): object $5C
	db $6f, $f5  ; (15, 6): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $82, $30, $0b  ; 2 across from (0, 3): object $0B
	db $82, $41, $0b  ; 2 across from (1, 4): object $0B
	db $c2, $52, $0b  ; 2 down from (2, 5): object $0B
	db $82, $63, $0b  ; 2 across from (3, 6): object $0B
	db $74, $0b  ; (4, 7): object $0B
	db $77, $6e  ; (7, 7): object $6E
	db $02, $ba  ; (2, 0): object $BA
	db $e1, $1f, $f3, $50, $7c  ; warp type 1 to map $1F room $F3, x 80 y 124
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $88 (row 8, column 8 of the 16 x 16 map): 16 objects on floor object $04; a warp (type 1) to map $10 room $9C at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom88::
	db $03, $04  ; animated tiles $03, floor $04
	db $84, $f2, $f5  ; 4 across from (2, 15): object $F5
	db $c2, $2f, $f5  ; 2 down from (15, 2): object $F5
	db $00, $f5  ; (0, 0): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $82, $60, $f5  ; 2 across from (0, 6): object $F5
	db $16, $44  ; (6, 1): object $44
	db $32, $44  ; (2, 3): object $44
	db $49, $44  ; (9, 4): object $44
	db $67, $44  ; (7, 6): object $44
	db $34, $f5  ; (4, 3): object $F5
	db $35, $f5  ; (5, 3): object $F5
	db $35, $45  ; (5, 3): object $45
	db $45, $e1  ; (5, 4): object $E1
	db $e1, $10, $9c, $50, $7c  ; warp type 1 to map $10 room $9C, x 80 y 124
	db $85, $55, $0b  ; 5 across from (5, 5): object $0B
	db $c2, $65, $0b  ; 2 down from (5, 6): object $0B
	db $77, $f5  ; (7, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $89 (row 8, column 9 of the 16 x 16 map): 22 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom89::
	db $03, $04  ; animated tiles $03, floor $04
	db $f0, $f5  ; (0, 15): object $F5
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $85, $7f, $f5  ; 5 across from (15, 7): object $F5
	db $37, $d4  ; (7, 3): object $D4
	db $c5, $05, $0b  ; 5 down from (5, 0): object $0B
	db $c3, $12, $5c  ; 3 down from (2, 1): object $5C
	db $13, $44  ; (3, 1): object $44
	db $14, $5c  ; (4, 1): object $5C
	db $c2, $17, $5c  ; 2 down from (7, 1): object $5C
	db $20, $44  ; (0, 2): object $44
	db $34, $e8  ; (4, 3): object $E8
	db $41, $5c  ; (1, 4): object $5C
	db $43, $5c  ; (3, 4): object $5C
	db $86, $50, $0b  ; 6 across from (0, 5): object $0B
	db $56, $e8  ; (6, 5): object $E8
	db $58, $44  ; (8, 5): object $44
	db $61, $5c  ; (1, 6): object $5C
	db $63, $5c  ; (3, 6): object $5C
	db $c2, $64, $0b  ; 2 down from (4, 6): object $0B
	db $65, $5c  ; (5, 6): object $5C
	db $67, $5c  ; (7, 6): object $5C
	db $73, $04  ; (3, 7): object $04
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $8A (row 8, column A of the 16 x 16 map): 16 objects on floor object $04; a warp (type 2) to map $10 room $E9 at x 8, y 112. Format: see OverworldRoomPointers.
OverworldRoom8A::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $c4, $1f, $f5  ; 4 down from (15, 1): object $F5
	db $87, $13, $2c  ; 7 across from (3, 1): object $2C
	db $c5, $31, $37  ; 5 down from (1, 3): object $37
	db $79, $3d  ; (9, 7): object $3D
	db $12, $2b  ; (2, 1): object $2B
	db $22, $31  ; (2, 2): object $31
	db $21, $2b  ; (1, 2): object $2B
	db $24, $fb  ; (4, 2): object $FB
	db $25, $fb  ; (5, 2): object $FB
	db $25, $c3  ; (5, 2): object $C3
	db $35, $e1  ; (5, 3): object $E1
	db $46, $d4  ; (6, 4): object $D4
	db $c4, $45, $0b  ; 4 down from (5, 4): object $0B
	db $42, $fb  ; (2, 4): object $FB
	db $47, $fb  ; (7, 4): object $FB
	db $e2, $10, $e9, $08, $70  ; warp type 2 to map $10 room $E9, x 8 y 112
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $8B (row 8, column B of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom8B::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $ff, $f5  ; 2 across from (15, 15): object $F5
	db $82, $10, $2c  ; 2 across from (0, 1): object $2C
	db $12, $2d  ; (2, 1): object $2D
	db $22, $38  ; (2, 2): object $38
	db $32, $32  ; (2, 3): object $32
	db $82, $33, $2c  ; 2 across from (3, 3): object $2C
	db $c3, $45, $38  ; 3 down from (5, 4): object $38
	db $c8, $07, $38  ; 8 down from (7, 0): object $38
	db $c8, $08, $0e  ; 8 down from (8, 0): object $0E
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c2, $43, $5c  ; 2 down from (3, 4): object $5C
	db $c2, $44, $5c  ; 2 down from (4, 4): object $5C
	db $84, $61, $5c  ; 4 across from (1, 6): object $5C
	db $70, $2f  ; (0, 7): object $2F
	db $71, $48  ; (1, 7): object $48
	db $72, $4a  ; (2, 7): object $4A
	db $73, $4a  ; (3, 7): object $4A
	db $74, $49  ; (4, 7): object $49
	db $75, $4e  ; (5, 7): object $4E
	db $35, $2d  ; (5, 3): object $2D
	db $16, $44  ; (6, 1): object $44
	db $21, $44  ; (1, 2): object $44
	db $24, $44  ; (4, 2): object $44
	db $50, $44  ; (0, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $8C (row 8, column C of the 16 x 16 map): 34 objects on floor object $04; a warp (type 1) to map $05 room $D4 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom8C::
	db $03, $04  ; animated tiles $03, floor $04
	db $33, $e3  ; (3, 3): object $E3
	db $e1, $05, $d4, $50, $7c  ; warp type 1 to map $05 room $D4, x 80 y 124
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $89, $01, $3a  ; 9 across from (1, 0): object $3A
	db $85, $11, $b9  ; 5 across from (1, 1): object $B9
	db $c6, $16, $38  ; 6 down from (6, 1): object $38
	db $83, $17, $3a  ; 3 across from (7, 1): object $3A
	db $85, $21, $b3  ; 5 across from (1, 2): object $B3
	db $c6, $28, $38  ; 6 down from (8, 2): object $38
	db $29, $3a  ; (9, 2): object $3A
	db $85, $31, $b3  ; 5 across from (1, 3): object $B3
	db $c5, $39, $0e  ; 5 down from (9, 3): object $0E
	db $85, $41, $b9  ; 5 across from (1, 4): object $B9
	db $42, $b8  ; (2, 4): object $B8
	db $44, $b8  ; (4, 4): object $B8
	db $85, $51, $b9  ; 5 across from (1, 5): object $B9
	db $51, $b6  ; (1, 5): object $B6
	db $55, $b6  ; (5, 5): object $B6
	db $85, $61, $b9  ; 5 across from (1, 6): object $B9
	db $61, $b7  ; (1, 6): object $B7
	db $65, $b7  ; (5, 6): object $B7
	db $85, $71, $2f  ; 5 across from (1, 7): object $2F
	db $72, $48  ; (2, 7): object $48
	db $73, $e0  ; (3, 7): object $E0
	db $74, $49  ; (4, 7): object $49
	db $76, $4e  ; (6, 7): object $4E
	db $36, $f2  ; (6, 3): object $F2
	db $46, $f3  ; (6, 4): object $F3
	db $56, $f4  ; (6, 5): object $F4
	db $48, $f2  ; (8, 4): object $F2
	db $58, $f3  ; (8, 5): object $F3
	db $68, $f4  ; (8, 6): object $F4
	db $27, $70  ; (7, 2): object $70
	db $16, $dd  ; (6, 1): object $DD
	db $28, $dd  ; (8, 2): object $DD
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Second layout of overworld room $8C (row 8, column C of the 16 x 16 map): 43 objects on floor object $04; a warp (type 1) to map $05 room $D4 at x 80, y 124. Format: see OverworldRoomPointers. The loader uses it instead of the first layout once the room's event has happened.
OverworldRoom8CAlt::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $38  ; 8 down from (0, 0): object $38
	db $89, $01, $3a  ; 9 across from (1, 0): object $3A
	db $85, $11, $b9  ; 5 across from (1, 1): object $B9
	db $c6, $16, $38  ; 6 down from (6, 1): object $38
	db $83, $17, $3a  ; 3 across from (7, 1): object $3A
	db $c6, $28, $38  ; 6 down from (8, 2): object $38
	db $29, $3a  ; (9, 2): object $3A
	db $c5, $39, $0e  ; 5 down from (9, 3): object $0E
	db $85, $41, $b9  ; 5 across from (1, 4): object $B9
	db $42, $b8  ; (2, 4): object $B8
	db $44, $b8  ; (4, 4): object $B8
	db $85, $51, $b9  ; 5 across from (1, 5): object $B9
	db $51, $b6  ; (1, 5): object $B6
	db $55, $b6  ; (5, 5): object $B6
	db $85, $61, $b9  ; 5 across from (1, 6): object $B9
	db $61, $b7  ; (1, 6): object $B7
	db $65, $b7  ; (5, 6): object $B7
	db $85, $71, $2f  ; 5 across from (1, 7): object $2F
	db $72, $48  ; (2, 7): object $48
	db $73, $e0  ; (3, 7): object $E0
	db $74, $49  ; (4, 7): object $49
	db $76, $4e  ; (6, 7): object $4E
	db $36, $f2  ; (6, 3): object $F2
	db $46, $f3  ; (6, 4): object $F3
	db $56, $f4  ; (6, 5): object $F4
	db $48, $f2  ; (8, 4): object $F2
	db $58, $f3  ; (8, 5): object $F3
	db $68, $f4  ; (8, 6): object $F4
	db $27, $70  ; (7, 2): object $70
	db $16, $dd  ; (6, 1): object $DD
	db $28, $dd  ; (8, 2): object $DD
	db $85, $01, $b3  ; 5 across from (1, 0): object $B3
	db $85, $11, $b3  ; 5 across from (1, 1): object $B3
	db $21, $ad  ; (1, 2): object $AD
	db $22, $b1  ; (2, 2): object $B1
	db $23, $e7  ; (3, 2): object $E7
	db $24, $ad  ; (4, 2): object $AD
	db $25, $b1  ; (5, 2): object $B1
	db $31, $ae  ; (1, 3): object $AE
	db $32, $b2  ; (2, 3): object $B2
	db $33, $e3  ; (3, 3): object $E3
	db $34, $ae  ; (4, 3): object $AE
	db $35, $b2  ; (5, 3): object $B2
	db $e1, $05, $d4, $50, $7c  ; warp type 1 to map $05 room $D4, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $8D (row 8, column D of the 16 x 16 map): 23 objects on floor object $0E; a warp (type 1) to map $1F room $AC at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom8D::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $8a, $20, $3a  ; 10 across from (0, 2): object $3A
	db $c4, $22, $37  ; 4 down from (2, 2): object $37
	db $c4, $23, $04  ; 4 down from (3, 2): object $04
	db $c4, $24, $04  ; 4 down from (4, 2): object $04
	db $c2, $25, $38  ; 2 down from (5, 2): object $38
	db $45, $32  ; (5, 4): object $32
	db $84, $46, $2c  ; 4 across from (6, 4): object $2C
	db $47, $e0  ; (7, 4): object $E0
	db $62, $33  ; (2, 6): object $33
	db $85, $63, $2f  ; 5 across from (3, 6): object $2F
	db $64, $48  ; (4, 6): object $48
	db $65, $e0  ; (5, 6): object $E0
	db $66, $49  ; (6, 6): object $49
	db $68, $3c  ; (8, 6): object $3C
	db $78, $37  ; (8, 7): object $37
	db $85, $55, $04  ; 5 across from (5, 5): object $04
	db $c2, $69, $04  ; 2 down from (9, 6): object $04
	db $69, $6e  ; (9, 6): object $6E
	db $22, $de  ; (2, 2): object $DE
	db $25, $dd  ; (5, 2): object $DD
	db $13, $ba  ; (3, 1): object $BA
	db $e1, $1f, $ac, $50, $7c  ; warp type 1 to map $1F room $AC, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $8E (row 8, column E of the 16 x 16 map): 25 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom8E::
	db $0a, $04  ; animated tiles $0A, floor $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $84, $20, $3a  ; 4 across from (0, 2): object $3A
	db $24, $37  ; (4, 2): object $37
	db $28, $09  ; (8, 2): object $09
	db $84, $30, $0e  ; 4 across from (0, 3): object $0E
	db $34, $33  ; (4, 3): object $33
	db $85, $35, $2f  ; 5 across from (5, 3): object $2F
	db $36, $48  ; (6, 3): object $48
	db $37, $e0  ; (7, 3): object $E0
	db $38, $49  ; (8, 3): object $49
	db $82, $40, $2c  ; 2 across from (0, 4): object $2C
	db $42, $2d  ; (2, 4): object $2D
	db $87, $43, $0e  ; 7 across from (3, 4): object $0E
	db $52, $32  ; (2, 5): object $32
	db $87, $53, $2c  ; 7 across from (3, 5): object $2C
	db $60, $6e  ; (0, 6): object $6E
	db $82, $61, $20  ; 2 across from (1, 6): object $20
	db $82, $63, $5c  ; 2 across from (3, 6): object $5C
	db $66, $20  ; (6, 6): object $20
	db $c2, $68, $6e  ; 2 down from (8, 6): object $6E
	db $71, $6e  ; (1, 7): object $6E
	db $73, $6e  ; (3, 7): object $6E
	db $76, $6e  ; (6, 7): object $6E
	db $24, $de  ; (4, 2): object $DE
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $8F (row 8, column F of the 16 x 16 map): 32 objects on floor object $04; a warp (type 1) to map $1F room $F7 at x 136, y 96. Format: see OverworldRoomPointers.
OverworldRoom8F::
	db $0a, $04  ; animated tiles $0A, floor $04
	db $00, $3a  ; (0, 0): object $3A
	db $01, $3f  ; (1, 0): object $3F
	db $10, $e1  ; (0, 1): object $E1
	db $e1, $1f, $f7, $88, $60  ; warp type 1 to map $1F room $F7, x 136 y 96
	db $11, $3f  ; (1, 1): object $3F
	db $c5, $38, $38  ; 5 down from (8, 3): object $38
	db $c8, $05, $37  ; 8 down from (5, 0): object $37
	db $c6, $06, $0a  ; 6 down from (6, 0): object $0A
	db $c7, $07, $0a  ; 7 down from (7, 0): object $0A
	db $c8, $03, $0e  ; 8 down from (3, 0): object $0E
	db $c8, $04, $0e  ; 8 down from (4, 0): object $0E
	db $26, $f5  ; (6, 2): object $F5
	db $30, $2f  ; (0, 3): object $2F
	db $31, $34  ; (1, 3): object $34
	db $21, $38  ; (1, 2): object $38
	db $83, $40, $0e  ; 3 across from (0, 4): object $0E
	db $82, $50, $2c  ; 2 across from (0, 5): object $2C
	db $52, $2d  ; (2, 5): object $2D
	db $c5, $39, $0e  ; 5 down from (9, 3): object $0E
	db $28, $3d  ; (8, 2): object $3D
	db $29, $34  ; (9, 2): object $34
	db $c2, $09, $38  ; 2 down from (9, 0): object $38
	db $c2, $05, $3e  ; 2 down from (5, 0): object $3E
	db $82, $06, $3a  ; 2 across from (6, 0): object $3A
	db $08, $3f  ; (8, 0): object $3F
	db $82, $16, $3a  ; 2 across from (6, 1): object $3A
	db $18, $3b  ; (8, 1): object $3B
	db $83, $02, $e9  ; 3 across from (2, 0): object $E9
	db $83, $12, $e9  ; 3 across from (2, 1): object $E9
	db $c2, $22, $0e  ; 2 down from (2, 2): object $0E
	db $c2, $62, $38  ; 2 down from (2, 6): object $38
	db $47, $6f  ; (7, 4): object $6F
	db $61, $20  ; (1, 6): object $20
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $90 (row 9, column 0 of the 16 x 16 map): 15 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom90::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $0e  ; 8 down from (0, 0): object $0E
	db $c8, $01, $37  ; 8 down from (1, 0): object $37
	db $c4, $02, $f5  ; 4 down from (2, 0): object $F5
	db $c2, $f3, $f5  ; 2 down from (3, 15): object $F5
	db $04, $f5  ; (4, 0): object $F5
	db $07, $f5  ; (7, 0): object $F5
	db $c5, $f8, $f5  ; 5 down from (8, 15): object $F5
	db $c4, $09, $f5  ; 4 down from (9, 0): object $F5
	db $25, $0a  ; (5, 2): object $0A
	db $26, $5c  ; (6, 2): object $5C
	db $c2, $34, $0a  ; 2 down from (4, 3): object $0A
	db $55, $d4  ; (5, 5): object $D4
	db $c2, $66, $0b  ; 2 down from (6, 6): object $0B
	db $77, $0a  ; (7, 7): object $0A
	db $67, $44  ; (7, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $91 (row 9, column 1 of the 16 x 16 map): 12 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom91::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $0f, $f5  ; 4 down from (15, 0): object $F5
	db $f0, $f5  ; (0, 15): object $F5
	db $82, $70, $f5  ; 2 across from (0, 7): object $F5
	db $08, $f5  ; (8, 0): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $c3, $f9, $f5  ; 3 down from (9, 15): object $F5
	db $c2, $59, $f5  ; 2 down from (9, 5): object $F5
	db $77, $f5  ; (7, 7): object $F5
	db $22, $f5  ; (2, 2): object $F5
	db $45, $f5  ; (5, 4): object $F5
	db $25, $44  ; (5, 2): object $44
	db $53, $44  ; (3, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $92 (row 9, column 2 of the 16 x 16 map): 19 objects on floor object $0C; a warp (type 1) to map $1F room $F4 at x 88, y 112. Format: see OverworldRoomPointers.
OverworldRoom92::
	db $10, $0c  ; animated tiles $10, floor $0C
	db $45, $c6  ; (5, 4): object $C6
	db $87, $03, $3a  ; 7 across from (3, 0): object $3A
	db $83, $24, $5c  ; 3 across from (4, 2): object $5C
	db $c3, $33, $5c  ; 3 down from (3, 3): object $5C
	db $c3, $37, $5c  ; 3 down from (7, 3): object $5C
	db $83, $64, $5c  ; 3 across from (4, 6): object $5C
	db $c8, $00, $04  ; 8 down from (0, 0): object $04
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $02, $39  ; (2, 0): object $39
	db $c8, $01, $04  ; 8 down from (1, 0): object $04
	db $c7, $19, $04  ; 7 down from (9, 1): object $04
	db $69, $0b  ; (9, 6): object $0B
	db $35, $91  ; (5, 3): object $91
	db $45, $5e  ; (5, 4): object $5E
	db $e1, $1f, $f4, $58, $70  ; warp type 1 to map $1F room $F4, x 88 y 112
	db $83, $24, $44  ; 3 across from (4, 2): object $44
	db $c3, $33, $44  ; 3 down from (3, 3): object $44
	db $c3, $37, $44  ; 3 down from (7, 3): object $44
	db $83, $64, $44  ; 3 across from (4, 6): object $44
	db $25, $dc  ; (5, 2): object $DC
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $93 (row 9, column 3 of the 16 x 16 map): 17 objects on floor object $04; a warp (type 1) to map $0E room $A1 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoom93::
	db $10, $04  ; animated tiles $10, floor $04
	db $84, $00, $3a  ; 4 across from (0, 0): object $3A
	db $01, $e0  ; (1, 0): object $E0
	db $04, $3b  ; (4, 0): object $3B
	db $83, $23, $5c  ; 3 across from (3, 2): object $5C
	db $c3, $32, $5c  ; 3 down from (2, 3): object $5C
	db $c3, $36, $5c  ; 3 down from (6, 3): object $5C
	db $33, $f7  ; (3, 3): object $F7
	db $43, $40  ; (3, 4): object $40
	db $44, $41  ; (4, 4): object $41
	db $45, $42  ; (5, 4): object $42
	db $e1, $0e, $a1, $50, $7c  ; warp type 1 to map $0E room $A1, x 80 y 124
	db $83, $27, $0b  ; 3 across from (7, 2): object $0B
	db $c5, $11, $0b  ; 5 down from (1, 1): object $0B
	db $88, $60, $0b  ; 8 across from (0, 6): object $0B
	db $c3, $37, $0b  ; 3 down from (7, 3): object $0B
	db $16, $44  ; (6, 1): object $44
	db $09, $f5  ; (9, 0): object $F5
	db $c3, $39, $f5  ; 3 down from (9, 3): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $94 (row 9, column 4 of the 16 x 16 map): 22 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom94::
	db $03, $04  ; animated tiles $03, floor $04
	db $f5, $f5  ; (5, 15): object $F5
	db $35, $f5  ; (5, 3): object $F5
	db $44, $f5  ; (4, 4): object $F5
	db $82, $51, $f5  ; 2 across from (1, 5): object $F5
	db $82, $60, $f5  ; 2 across from (0, 6): object $F5
	db $83, $7f, $f5  ; 3 across from (15, 7): object $F5
	db $8a, $20, $0b  ; 10 across from (0, 2): object $0B
	db $c3, $14, $5c  ; 3 down from (4, 1): object $5C
	db $c2, $33, $5c  ; 2 down from (3, 3): object $5C
	db $42, $5c  ; (2, 4): object $5C
	db $13, $d4  ; (3, 1): object $D4
	db $c2, $15, $20  ; 2 down from (5, 1): object $20
	db $0f, $f5  ; (15, 0): object $F5
	db $c3, $3f, $f5  ; 3 down from (15, 3): object $F5
	db $83, $07, $0a  ; 3 across from (7, 0): object $0A
	db $83, $17, $0a  ; 3 across from (7, 1): object $0A
	db $38, $44  ; (8, 3): object $44
	db $c2, $39, $0a  ; 2 down from (9, 3): object $0A
	db $47, $0a  ; (7, 4): object $0A
	db $82, $56, $0a  ; 2 across from (6, 5): object $0A
	db $69, $0a  ; (9, 6): object $0A
	db $84, $76, $0a  ; 4 across from (6, 7): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $95 (row 9, column 5 of the 16 x 16 map): 30 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoom95::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $82, $04, $04  ; 2 across from (4, 0): object $04
	db $18, $5c  ; (8, 1): object $5C
	db $22, $5c  ; (2, 2): object $5C
	db $82, $23, $04  ; 2 across from (3, 2): object $04
	db $82, $33, $04  ; 2 across from (3, 3): object $04
	db $23, $f5  ; (3, 2): object $F5
	db $85, $55, $0b  ; 5 across from (5, 5): object $0B
	db $82, $78, $04  ; 2 across from (8, 7): object $04
	db $78, $f5  ; (8, 7): object $F5
	db $82, $20, $0b  ; 2 across from (0, 2): object $0B
	db $82, $31, $0b  ; 2 across from (1, 3): object $0B
	db $83, $42, $0b  ; 3 across from (2, 4): object $0B
	db $c2, $54, $0b  ; 2 down from (4, 5): object $0B
	db $85, $64, $0b  ; 5 across from (4, 6): object $0B
	db $82, $58, $0b  ; 2 across from (8, 5): object $0B
	db $82, $50, $04  ; 2 across from (0, 5): object $04
	db $82, $61, $04  ; 2 across from (1, 6): object $04
	db $74, $04  ; (4, 7): object $04
	db $76, $04  ; (6, 7): object $04
	db $35, $2b  ; (5, 3): object $2B
	db $36, $2c  ; (6, 3): object $2C
	db $37, $2d  ; (7, 3): object $2D
	db $45, $37  ; (5, 4): object $37
	db $46, $e8  ; (6, 4): object $E8
	db $47, $38  ; (7, 4): object $38
	db $55, $33  ; (5, 5): object $33
	db $56, $e0  ; (6, 5): object $E0
	db $57, $34  ; (7, 5): object $34
	db $09, $04  ; (9, 0): object $04
	db $09, $f5  ; (9, 0): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $96 (row 9, column 6 of the 16 x 16 map): 16 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom96::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $09, $f5  ; 4 down from (9, 0): object $F5
	db $38, $f5  ; (8, 3): object $F5
	db $85, $70, $f5  ; 5 across from (0, 7): object $F5
	db $82, $10, $0a  ; 2 across from (0, 1): object $0A
	db $22, $0a  ; (2, 2): object $0A
	db $c2, $30, $0a  ; 2 down from (0, 3): object $0A
	db $83, $60, $0a  ; 3 across from (0, 6): object $0A
	db $0f, $f5  ; (15, 0): object $F5
	db $18, $e8  ; (8, 1): object $E8
	db $23, $e8  ; (3, 2): object $E8
	db $35, $e8  ; (5, 3): object $E8
	db $41, $e8  ; (1, 4): object $E8
	db $56, $e8  ; (6, 5): object $E8
	db $37, $5c  ; (7, 3): object $5C
	db $c5, $04, $0b  ; 5 down from (4, 0): object $0B
	db $85, $50, $0b  ; 5 across from (0, 5): object $0B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $97 (row 9, column 7 of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom97::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $0f, $f5  ; 4 down from (15, 0): object $F5
	db $30, $f5  ; (0, 3): object $F5
	db $63, $f5  ; (3, 6): object $F5
	db $69, $f5  ; (9, 6): object $F5
	db $85, $70, $f5  ; 5 across from (0, 7): object $F5
	db $c2, $04, $0b  ; 2 down from (4, 0): object $0B
	db $07, $2b  ; (7, 0): object $2B
	db $82, $08, $2c  ; 2 across from (8, 0): object $2C
	db $17, $ea  ; (7, 1): object $EA
	db $22, $e8  ; (2, 2): object $E8
	db $83, $24, $0b  ; 3 across from (4, 2): object $0B
	db $27, $f0  ; (7, 2): object $F0
	db $29, $44  ; (9, 2): object $44
	db $37, $f1  ; (7, 3): object $F1
	db $43, $e8  ; (3, 4): object $E8
	db $47, $2e  ; (7, 4): object $2E
	db $49, $49  ; (9, 4): object $49
	db $52, $09  ; (2, 5): object $09
	db $57, $39  ; (7, 5): object $39
	db $82, $58, $3a  ; 2 across from (8, 5): object $3A
	db $c2, $48, $e0  ; 2 down from (8, 4): object $E0
	db $61, $6e  ; (1, 6): object $6E
	db $46, $6e  ; (6, 4): object $6E
	db $44, $fa  ; (4, 4): object $FA
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $98 (row 9, column 8 of the 16 x 16 map): 27 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom98::
	db $03, $04  ; animated tiles $03, floor $04
	db $6f, $f5  ; (15, 6): object $F5
	db $83, $75, $f5  ; 3 across from (5, 7): object $F5
	db $c4, $f9, $f5  ; 4 down from (9, 15): object $F5
	db $82, $70, $f5  ; 2 across from (0, 7): object $F5
	db $83, $00, $2c  ; 3 across from (0, 0): object $2C
	db $03, $2d  ; (3, 0): object $2D
	db $11, $44  ; (1, 1): object $44
	db $c2, $13, $38  ; 2 down from (3, 1): object $38
	db $15, $44  ; (5, 1): object $44
	db $31, $3d  ; (1, 3): object $3D
	db $c2, $32, $e0  ; 2 down from (2, 3): object $E0
	db $33, $4e  ; (3, 3): object $4E
	db $40, $2f  ; (0, 4): object $2F
	db $41, $4e  ; (1, 4): object $4E
	db $43, $3b  ; (3, 4): object $3B
	db $47, $44  ; (7, 4): object $44
	db $50, $3a  ; (0, 5): object $3A
	db $51, $3b  ; (1, 5): object $3B
	db $61, $44  ; (1, 6): object $44
	db $27, $d4  ; (7, 2): object $D4
	db $36, $e8  ; (6, 3): object $E8
	db $c2, $05, $0b  ; 2 down from (5, 0): object $0B
	db $82, $25, $0b  ; 2 across from (5, 2): object $0B
	db $46, $0b  ; (6, 4): object $0B
	db $85, $52, $0b  ; 5 across from (2, 5): object $0B
	db $c2, $64, $0b  ; 2 down from (4, 6): object $0B
	db $f7, $f5  ; (7, 15): object $F5
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $99 (row 9, column 9 of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom99::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $c3, $1f, $f5  ; 3 down from (15, 1): object $F5
	db $19, $f5  ; (9, 1): object $F5
	db $03, $04  ; (3, 0): object $04
	db $c5, $04, $0b  ; 5 down from (4, 0): object $0B
	db $12, $5c  ; (2, 1): object $5C
	db $16, $5c  ; (6, 1): object $5C
	db $18, $5c  ; (8, 1): object $5C
	db $21, $44  ; (1, 2): object $44
	db $23, $e8  ; (3, 2): object $E8
	db $25, $5c  ; (5, 2): object $5C
	db $27, $e8  ; (7, 2): object $E8
	db $32, $5c  ; (2, 3): object $5C
	db $36, $5c  ; (6, 3): object $5C
	db $37, $44  ; (7, 3): object $44
	db $38, $5c  ; (8, 3): object $5C
	db $43, $e8  ; (3, 4): object $E8
	db $45, $5c  ; (5, 4): object $5C
	db $47, $e8  ; (7, 4): object $E8
	db $52, $5c  ; (2, 5): object $5C
	db $86, $54, $0b  ; 6 across from (4, 5): object $0B
	db $61, $44  ; (1, 6): object $44
	db $c2, $67, $0b  ; 2 down from (7, 6): object $0B
	db $75, $44  ; (5, 7): object $44
	db $82, $7f, $f5  ; 2 across from (15, 7): object $F5
	db $78, $f5  ; (8, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $9A (row 9, column A of the 16 x 16 map): 15 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom9A::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $ff, $f5  ; 2 down from (15, 15): object $F5
	db $c2, $01, $37  ; 2 down from (1, 0): object $37
	db $21, $33  ; (1, 2): object $33
	db $82, $22, $2f  ; 2 across from (2, 2): object $2F
	db $24, $3c  ; (4, 2): object $3C
	db $34, $33  ; (4, 3): object $33
	db $35, $35  ; (5, 3): object $35
	db $28, $36  ; (8, 2): object $36
	db $29, $34  ; (9, 2): object $34
	db $c2, $09, $38  ; 2 down from (9, 0): object $38
	db $85, $70, $f5  ; 5 across from (0, 7): object $F5
	db $05, $0b  ; (5, 0): object $0B
	db $83, $15, $0b  ; 3 across from (5, 1): object $0B
	db $c3, $27, $0b  ; 3 down from (7, 2): object $0B
	db $88, $50, $0b  ; 8 across from (0, 5): object $0B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $9B (row 9, column B of the 16 x 16 map): 31 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom9B::
	db $03, $04  ; animated tiles $03, floor $04
	db $85, $00, $3a  ; 5 across from (0, 0): object $3A
	db $05, $3b  ; (5, 0): object $3B
	db $10, $f5  ; (0, 1): object $F5
	db $c3, $08, $0e  ; 3 down from (8, 0): object $0E
	db $86, $34, $0e  ; 6 across from (4, 3): object $0E
	db $86, $44, $0e  ; 6 across from (4, 4): object $0E
	db $c3, $53, $0e  ; 3 down from (3, 5): object $0E
	db $c3, $54, $0e  ; 3 down from (4, 5): object $0E
	db $c2, $07, $38  ; 2 down from (7, 0): object $38
	db $c2, $09, $37  ; 2 down from (9, 0): object $37
	db $29, $2e  ; (9, 2): object $2E
	db $23, $3d  ; (3, 2): object $3D
	db $24, $48  ; (4, 2): object $48
	db $25, $e0  ; (5, 2): object $E0
	db $26, $49  ; (6, 2): object $49
	db $27, $34  ; (7, 2): object $34
	db $33, $38  ; (3, 3): object $38
	db $39, $39  ; (9, 3): object $39
	db $40, $44  ; (0, 4): object $44
	db $42, $3d  ; (2, 4): object $3D
	db $43, $34  ; (3, 4): object $34
	db $c3, $52, $38  ; 3 down from (2, 5): object $38
	db $68, $44  ; (8, 6): object $44
	db $16, $44  ; (6, 1): object $44
	db $68, $44  ; (8, 6): object $44
	db $76, $44  ; (6, 7): object $44
	db $70, $f5  ; (0, 7): object $F5
	db $55, $2b  ; (5, 5): object $2B
	db $84, $56, $2c  ; 4 across from (6, 5): object $2C
	db $c2, $65, $37  ; 2 down from (5, 6): object $37
	db $79, $2b  ; (9, 7): object $2B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $9C (row 9, column C of the 16 x 16 map): 24 objects on floor object $04; a warp (type 1) to map $1F room $F0 at x 56, y 16. Format: see OverworldRoomPointers.
OverworldRoom9C::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $00, $38  ; 2 down from (0, 0): object $38
	db $85, $01, $3a  ; 5 across from (1, 0): object $3A
	db $03, $e0  ; (3, 0): object $E0
	db $05, $e1  ; (5, 0): object $E1
	db $e1, $1f, $f0, $38, $10  ; warp type 1 to map $1F room $F0, x 56 y 16
	db $06, $3b  ; (6, 0): object $3B
	db $c2, $08, $38  ; 2 down from (8, 0): object $38
	db $c4, $09, $0e  ; 4 down from (9, 0): object $0E
	db $11, $3a  ; (1, 1): object $3A
	db $12, $de  ; (2, 1): object $DE
	db $20, $4e  ; (0, 2): object $4E
	db $c2, $21, $0e  ; 2 down from (1, 2): object $0E
	db $22, $2e  ; (2, 2): object $2E
	db $23, $48  ; (3, 2): object $48
	db $24, $4a  ; (4, 2): object $4A
	db $25, $49  ; (5, 2): object $49
	db $82, $26, $2f  ; 2 across from (6, 2): object $2F
	db $28, $4e  ; (8, 2): object $4E
	db $30, $3b  ; (0, 3): object $3B
	db $32, $39  ; (2, 3): object $39
	db $85, $33, $3a  ; 5 across from (3, 3): object $3A
	db $38, $3b  ; (8, 3): object $3B
	db $8a, $40, $0e  ; 10 across from (0, 4): object $0E
	db $8a, $50, $2c  ; 10 across from (0, 5): object $2C
	db $8a, $70, $2c  ; 10 across from (0, 7): object $2C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $9D (row 9, column D of the 16 x 16 map): 22 objects on floor object $0E; a warp (type 1) to map $1F room $F1 at x 136, y 96. Format: see OverworldRoomPointers.
OverworldRoom9D::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $c5, $08, $37  ; 5 down from (8, 0): object $37
	db $c6, $09, $04  ; 6 down from (9, 0): object $04
	db $11, $2b  ; (1, 1): object $2B
	db $84, $12, $2c  ; 4 across from (2, 1): object $2C
	db $16, $2d  ; (6, 1): object $2D
	db $21, $37  ; (1, 2): object $37
	db $22, $c6  ; (2, 2): object $C6
	db $e1, $1f, $f1, $88, $60  ; warp type 1 to map $1F room $F1, x 136 y 96
	db $83, $23, $b9  ; 3 across from (3, 2): object $B9
	db $25, $b8  ; (5, 2): object $B8
	db $26, $38  ; (6, 2): object $38
	db $31, $33  ; (1, 3): object $33
	db $32, $2f  ; (2, 3): object $2F
	db $33, $48  ; (3, 3): object $48
	db $34, $e0  ; (4, 3): object $E0
	db $35, $49  ; (5, 3): object $49
	db $36, $34  ; (6, 3): object $34
	db $88, $50, $2c  ; 8 across from (0, 5): object $2C
	db $58, $31  ; (8, 5): object $31
	db $8a, $60, $04  ; 10 across from (0, 6): object $04
	db $8a, $70, $2c  ; 10 across from (0, 7): object $2C
	db $29, $6e  ; (9, 2): object $6E
	db $59, $6e  ; (9, 5): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $9E (row 9, column E of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom9E::
	db $0a, $04  ; animated tiles $0A, floor $04
	db $01, $6e  ; (1, 0): object $6E
	db $03, $6e  ; (3, 0): object $6E
	db $08, $6e  ; (8, 0): object $6E
	db $88, $11, $20  ; 8 across from (1, 1): object $20
	db $14, $5c  ; (4, 1): object $5C
	db $c2, $06, $6e  ; 2 down from (6, 0): object $6E
	db $87, $20, $6e  ; 7 across from (0, 2): object $6E
	db $c3, $28, $20  ; 3 down from (8, 2): object $20
	db $29, $6e  ; (9, 2): object $6E
	db $31, $6e  ; (1, 3): object $6E
	db $83, $33, $20  ; 3 across from (3, 3): object $20
	db $82, $36, $5c  ; 2 across from (6, 3): object $5C
	db $44, $20  ; (4, 4): object $20
	db $85, $45, $6e  ; 5 across from (5, 4): object $6E
	db $82, $47, $20  ; 2 across from (7, 4): object $20
	db $84, $50, $6e  ; 4 across from (0, 5): object $6E
	db $62, $5c  ; (2, 6): object $5C
	db $84, $63, $20  ; 4 across from (3, 6): object $20
	db $65, $5c  ; (5, 6): object $5C
	db $68, $20  ; (8, 6): object $20
	db $8a, $70, $2c  ; 10 across from (0, 7): object $2C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $9F (row 9, column F of the 16 x 16 map): 22 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoom9F::
	db $0a, $04  ; animated tiles $0A, floor $04
	db $c2, $02, $38  ; 2 down from (2, 0): object $38
	db $82, $03, $0e  ; 2 across from (3, 0): object $0E
	db $c2, $05, $37  ; 2 down from (5, 0): object $37
	db $c8, $08, $38  ; 8 down from (8, 0): object $38
	db $c8, $09, $0e  ; 8 down from (9, 0): object $0E
	db $c3, $11, $5c  ; 3 down from (1, 1): object $5C
	db $82, $13, $0e  ; 2 across from (3, 1): object $0E
	db $20, $6e  ; (0, 2): object $6E
	db $22, $32  ; (2, 2): object $32
	db $82, $23, $2c  ; 2 across from (3, 2): object $2C
	db $25, $31  ; (5, 2): object $31
	db $32, $6e  ; (2, 3): object $6E
	db $83, $40, $6e  ; 3 across from (0, 4): object $6E
	db $46, $36  ; (6, 4): object $36
	db $47, $3c  ; (7, 4): object $3C
	db $82, $54, $20  ; 2 across from (4, 5): object $20
	db $c2, $57, $37  ; 2 down from (7, 5): object $37
	db $87, $70, $2c  ; 7 across from (0, 7): object $2C
	db $72, $2d  ; (2, 7): object $2D
	db $73, $04  ; (3, 7): object $04
	db $74, $2b  ; (4, 7): object $2B
	db $77, $31  ; (7, 7): object $31
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A0 (row A, column 0 of the 16 x 16 map): 29 objects on floor object $04; a warp (type 1) to map $11 room $A4 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomA0::
	db $03, $04  ; animated tiles $03, floor $04
	db $02, $f5  ; (2, 0): object $F5
	db $c8, $01, $37  ; 8 down from (1, 0): object $37
	db $c8, $00, $0e  ; 8 down from (0, 0): object $0E
	db $c2, $06, $0b  ; 2 down from (6, 0): object $0B
	db $84, $16, $0b  ; 4 across from (6, 1): object $0B
	db $22, $36  ; (2, 2): object $36
	db $23, $3c  ; (3, 2): object $3C
	db $83, $24, $5c  ; 3 across from (4, 2): object $5C
	db $27, $3d  ; (7, 2): object $3D
	db $28, $35  ; (8, 2): object $35
	db $33, $2e  ; (3, 3): object $2E
	db $34, $48  ; (4, 3): object $48
	db $35, $4a  ; (5, 3): object $4A
	db $36, $49  ; (6, 3): object $49
	db $37, $4e  ; (7, 3): object $4E
	db $43, $39  ; (3, 4): object $39
	db $83, $44, $3a  ; 3 across from (4, 4): object $3A
	db $47, $3b  ; (7, 4): object $3B
	db $c2, $38, $5c  ; 2 down from (8, 3): object $5C
	db $c2, $54, $62  ; 2 down from (4, 5): object $62
	db $c2, $56, $62  ; 2 down from (6, 5): object $62
	db $55, $61  ; (5, 5): object $61
	db $83, $67, $0b  ; 3 across from (7, 6): object $0B
	db $77, $0b  ; (7, 7): object $0B
	db $e1, $11, $a4, $50, $7c  ; warp type 1 to map $11 room $A4, x 80 y 124
	db $f8, $f5  ; (8, 15): object $F5
	db $07, $0a  ; (7, 0): object $0A
	db $48, $44  ; (8, 4): object $44
	db $63, $44  ; (3, 6): object $44
	db $79, $f5  ; (9, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A1 (row A, column 1 of the 16 x 16 map): 22 objects on floor object $04; a warp (type 1) to map $12 room $B2 at x 80, y 124; a warp (type 1) to map $10 room $A7 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomA1::
	db $03, $04  ; animated tiles $03, floor $04
	db $83, $04, $0a  ; 3 across from (4, 0): object $0A
	db $25, $52  ; (5, 2): object $52
	db $35, $e2  ; (5, 3): object $E2
	db $e1, $12, $b2, $50, $7c  ; warp type 1 to map $12 room $B2, x 80 y 124
	db $82, $f0, $f5  ; 2 across from (0, 15): object $F5
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $10, $0b  ; (0, 1): object $0B
	db $c4, $11, $0b  ; 4 down from (1, 1): object $0B
	db $82, $42, $0b  ; 2 across from (2, 4): object $0B
	db $82, $60, $0b  ; 2 across from (0, 6): object $0B
	db $89, $71, $0b  ; 9 across from (1, 7): object $0B
	db $82, $36, $0a  ; 2 across from (6, 3): object $0A
	db $82, $36, $0a  ; 2 across from (6, 3): object $0A
	db $84, $45, $0a  ; 4 across from (5, 4): object $0A
	db $85, $53, $0a  ; 5 across from (3, 5): object $0A
	db $44, $e6  ; (4, 4): object $E6
	db $15, $0a  ; (5, 1): object $0A
	db $c2, $26, $62  ; 2 down from (6, 2): object $62
	db $12, $f7  ; (2, 1): object $F7
	db $e1, $10, $a7, $50, $7c  ; warp type 1 to map $10 room $A7, x 80 y 124
	db $26, $44  ; (6, 2): object $44
	db $52, $44  ; (2, 5): object $44
	db $68, $44  ; (8, 6): object $44
	db $7f, $f5  ; (15, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A2 (row A, column 2 of the 16 x 16 map): 16 objects on floor object $04; a warp (type 1) to map $10 room $A3 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomA2::
	db $10, $04  ; animated tiles $10, floor $04
	db $84, $23, $0a  ; 4 across from (3, 2): object $0A
	db $84, $33, $0a  ; 4 across from (3, 3): object $0A
	db $85, $43, $0a  ; 5 across from (3, 4): object $0A
	db $85, $53, $0a  ; 5 across from (3, 5): object $0A
	db $27, $f5  ; (7, 2): object $F5
	db $c2, $29, $0a  ; 2 down from (9, 2): object $0A
	db $34, $fd  ; (4, 3): object $FD
	db $e1, $10, $a3, $50, $7c  ; warp type 1 to map $10 room $A3, x 80 y 124
	db $87, $12, $62  ; 7 across from (2, 1): object $62
	db $c5, $22, $62  ; 5 down from (2, 2): object $62
	db $86, $63, $62  ; 6 across from (3, 6): object $62
	db $c2, $48, $62  ; 2 down from (8, 4): object $62
	db $65, $04  ; (5, 6): object $04
	db $ff, $f5  ; (15, 15): object $F5
	db $86, $70, $0b  ; 6 across from (0, 7): object $0B
	db $c2, $55, $0b  ; 2 down from (5, 5): object $0B
	db $31, $44  ; (1, 3): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A3 (row A, column 3 of the 16 x 16 map): 7 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoomA3::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $c8, $09, $04  ; 8 down from (9, 0): object $04
	db $86, $22, $5c  ; 6 across from (2, 2): object $5C
	db $86, $32, $5c  ; 6 across from (2, 3): object $5C
	db $86, $42, $5c  ; 6 across from (2, 4): object $5C
	db $86, $52, $5c  ; 6 across from (2, 5): object $5C
	db $86, $62, $5c  ; 6 across from (2, 6): object $5C
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A4 (row A, column 4 of the 16 x 16 map): 23 objects on floor object $0A; a warp (type 1) to map $10 room $B4 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomA4::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $c3, $05, $04  ; 3 down from (5, 0): object $04
	db $85, $31, $04  ; 5 across from (1, 3): object $04
	db $85, $41, $04  ; 5 across from (1, 4): object $04
	db $83, $52, $04  ; 3 across from (2, 5): object $04
	db $41, $44  ; (1, 4): object $44
	db $54, $44  ; (4, 5): object $44
	db $c8, $00, $04  ; 8 down from (0, 0): object $04
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $84, $01, $04  ; 4 across from (1, 0): object $04
	db $82, $f1, $f5  ; 2 across from (1, 15): object $F5
	db $22, $f5  ; (2, 2): object $F5
	db $23, $f5  ; (3, 2): object $F5
	db $23, $45  ; (3, 2): object $45
	db $33, $e1  ; (3, 3): object $E1
	db $e1, $10, $b4, $50, $7c  ; warp type 1 to map $10 room $B4, x 80 y 124
	db $44, $d4  ; (4, 4): object $D4
	db $82, $26, $04  ; 2 across from (6, 2): object $04
	db $82, $36, $04  ; 2 across from (6, 3): object $04
	db $26, $f5  ; (6, 2): object $F5
	db $c3, $58, $04  ; 3 down from (8, 5): object $04
	db $c3, $59, $04  ; 3 down from (9, 5): object $04
	db $c2, $58, $f5  ; 2 down from (8, 5): object $F5
	db $48, $36  ; (8, 4): object $36
	db $49, $2f  ; (9, 4): object $2F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A5 (row A, column 5 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomA5::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $02, $0a  ; 6 across from (2, 0): object $0A
	db $f8, $f5  ; (8, 15): object $F5
	db $87, $11, $0a  ; 7 across from (1, 1): object $0A
	db $18, $2b  ; (8, 1): object $2B
	db $19, $2c  ; (9, 1): object $2C
	db $c5, $20, $0a  ; 5 down from (0, 2): object $0A
	db $c6, $21, $0a  ; 6 down from (1, 2): object $0A
	db $c6, $22, $0a  ; 6 down from (2, 2): object $0A
	db $23, $2b  ; (3, 2): object $2B
	db $84, $24, $2c  ; 4 across from (4, 2): object $2C
	db $28, $31  ; (8, 2): object $31
	db $c5, $33, $37  ; 5 down from (3, 3): object $37
	db $33, $ea  ; (3, 3): object $EA
	db $43, $f0  ; (3, 4): object $F0
	db $53, $f1  ; (3, 5): object $F1
	db $73, $2e  ; (3, 7): object $2E
	db $86, $74, $2f  ; 6 across from (4, 7): object $2F
	db $35, $0a  ; (5, 3): object $0A
	db $44, $0a  ; (4, 4): object $0A
	db $46, $0a  ; (6, 4): object $0A
	db $55, $0a  ; (5, 5): object $0A
	db $40, $3c  ; (0, 4): object $3C
	db $c3, $50, $37  ; 3 down from (0, 5): object $37
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A6 (row A, column 6 of the 16 x 16 map): 24 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoomA6::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $8a, $00, $04  ; 10 across from (0, 0): object $04
	db $85, $f0, $f5  ; 5 across from (0, 15): object $F5
	db $83, $10, $2c  ; 3 across from (0, 1): object $2C
	db $13, $2d  ; (3, 1): object $2D
	db $86, $14, $0f  ; 6 across from (4, 1): object $0F
	db $c5, $20, $04  ; 5 down from (0, 2): object $04
	db $c5, $21, $04  ; 5 down from (1, 2): object $04
	db $c5, $22, $04  ; 5 down from (2, 2): object $04
	db $c5, $23, $38  ; 5 down from (3, 2): object $38
	db $70, $48  ; (0, 7): object $48
	db $71, $e0  ; (1, 7): object $E0
	db $72, $49  ; (2, 7): object $49
	db $73, $4e  ; (3, 7): object $4E
	db $35, $1a  ; (5, 3): object $1A
	db $36, $10  ; (6, 3): object $10
	db $37, $19  ; (7, 3): object $19
	db $c2, $45, $12  ; 2 down from (5, 4): object $12
	db $46, $5c  ; (6, 4): object $5C
	db $c2, $47, $11  ; 2 down from (7, 4): object $11
	db $56, $04  ; (6, 5): object $04
	db $65, $18  ; (5, 6): object $18
	db $66, $0f  ; (6, 6): object $0F
	db $67, $17  ; (7, 6): object $17
	db $19, $6e  ; (9, 1): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A7 (row A, column 7 of the 16 x 16 map): 19 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomA7::
	db $03, $04  ; animated tiles $03, floor $04
	db $85, $f0, $f5  ; 5 across from (0, 15): object $F5
	db $05, $f5  ; (5, 0): object $F5
	db $09, $f5  ; (9, 0): object $F5
	db $82, $10, $0f  ; 2 across from (0, 1): object $0F
	db $12, $14  ; (2, 1): object $14
	db $c6, $20, $0e  ; 6 down from (0, 2): object $0E
	db $c6, $21, $0e  ; 6 down from (1, 2): object $0E
	db $c6, $22, $0e  ; 6 down from (2, 2): object $0E
	db $82, $28, $0b  ; 2 across from (8, 2): object $0B
	db $38, $0b  ; (8, 3): object $0B
	db $c2, $45, $f5  ; 2 down from (5, 4): object $F5
	db $82, $47, $0b  ; 2 across from (7, 4): object $0B
	db $c3, $57, $0b  ; 3 down from (7, 5): object $0B
	db $59, $2b  ; (9, 5): object $2B
	db $c2, $69, $37  ; 2 down from (9, 6): object $37
	db $12, $0f  ; (2, 1): object $0F
	db $13, $14  ; (3, 1): object $14
	db $c6, $23, $12  ; 6 down from (3, 2): object $12
	db $10, $6e  ; (0, 1): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A8 (row A, column 8 of the 16 x 16 map): 21 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomA8::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $f0, $f5  ; 2 across from (0, 15): object $F5
	db $0f, $f5  ; (15, 0): object $F5
	db $83, $f5, $f5  ; 3 across from (5, 15): object $F5
	db $82, $50, $2c  ; 2 across from (0, 5): object $2C
	db $52, $31  ; (2, 5): object $31
	db $42, $37  ; (2, 4): object $37
	db $32, $2b  ; (2, 3): object $2B
	db $84, $33, $2c  ; 4 across from (3, 3): object $2C
	db $37, $2d  ; (7, 3): object $2D
	db $47, $32  ; (7, 4): object $32
	db $48, $2d  ; (8, 4): object $2D
	db $c3, $58, $38  ; 3 down from (8, 5): object $38
	db $60, $f5  ; (0, 6): object $F5
	db $73, $2b  ; (3, 7): object $2B
	db $82, $74, $2c  ; 2 across from (4, 7): object $2C
	db $76, $2d  ; (6, 7): object $2D
	db $c2, $04, $0b  ; 2 down from (4, 0): object $0B
	db $85, $20, $0b  ; 5 across from (0, 2): object $0B
	db $16, $f5  ; (6, 1): object $F5
	db $49, $6e  ; (9, 4): object $6E
	db $44, $6f  ; (4, 4): object $6F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $A9 (row A, column 9 of the 16 x 16 map): 18 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomA9::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $ff, $f5  ; 2 across from (15, 15): object $F5
	db $c4, $07, $0b  ; 4 down from (7, 0): object $0B
	db $82, $38, $0b  ; 2 across from (8, 3): object $0B
	db $85, $22, $6e  ; 5 across from (2, 2): object $6E
	db $32, $6e  ; (2, 3): object $6E
	db $83, $40, $6e  ; 3 across from (0, 4): object $6E
	db $45, $6e  ; (5, 4): object $6E
	db $c4, $47, $6e  ; 4 down from (7, 4): object $6E
	db $61, $6e  ; (1, 6): object $6E
	db $63, $6e  ; (3, 6): object $6E
	db $65, $6e  ; (5, 6): object $6E
	db $04, $44  ; (4, 0): object $44
	db $31, $44  ; (1, 3): object $44
	db $46, $44  ; (6, 4): object $44
	db $54, $44  ; (4, 5): object $44
	db $f8, $f5  ; (8, 15): object $F5
	db $19, $f5  ; (9, 1): object $F5
	db $79, $f5  ; (9, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $AA (row A, column A of the 16 x 16 map): 9 objects on floor object $04; a warp (type 1) to map $11 room $D0 at x 40, y 64. Format: see OverworldRoomPointers.
OverworldRoomAA::
	db $03, $04  ; animated tiles $03, floor $04
	db $89, $30, $0b  ; 9 across from (0, 3): object $0B
	db $85, $f0, $f5  ; 5 across from (0, 15): object $F5
	db $05, $f5  ; (5, 0): object $F5
	db $1f, $f5  ; (15, 1): object $F5
	db $82, $14, $f5  ; 2 across from (4, 1): object $F5
	db $83, $42, $f5  ; 3 across from (2, 4): object $F5
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $23, $d4  ; (3, 2): object $D4
	db $48, $d3  ; (8, 4): object $D3
	db $e1, $11, $d0, $28, $40  ; warp type 1 to map $11 room $D0, x 40 y 64
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $AB (row A, column B of the 16 x 16 map): 27 objects on floor object $04; a warp (type 1) to map $11 room $D1 at x 120, y 64. Format: see OverworldRoomPointers.
OverworldRoomAB::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $02, $38  ; 3 down from (2, 0): object $38
	db $32, $32  ; (2, 3): object $32
	db $33, $2d  ; (3, 3): object $2D
	db $c4, $43, $38  ; 4 down from (3, 4): object $38
	db $c2, $05, $37  ; 2 down from (5, 0): object $37
	db $25, $33  ; (5, 2): object $33
	db $26, $3c  ; (6, 2): object $3C
	db $c5, $36, $37  ; 5 down from (6, 3): object $37
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $47, $c6  ; (7, 4): object $C6
	db $e1, $11, $d1, $78, $40  ; warp type 1 to map $11 room $D1, x 120 y 64
	db $c2, $06, $0a  ; 2 down from (6, 0): object $0A
	db $08, $44  ; (8, 0): object $44
	db $27, $44  ; (7, 2): object $44
	db $f0, $f5  ; (0, 15): object $F5
	db $82, $7f, $f5  ; 2 across from (15, 7): object $F5
	db $c3, $03, $0e  ; 3 down from (3, 0): object $0E
	db $c3, $04, $0e  ; 3 down from (4, 0): object $0E
	db $c5, $34, $0e  ; 5 down from (4, 3): object $0E
	db $c5, $35, $0e  ; 5 down from (5, 3): object $0E
	db $61, $6e  ; (1, 6): object $6E
	db $53, $f2  ; (3, 5): object $F2
	db $63, $f3  ; (3, 6): object $F3
	db $73, $f4  ; (3, 7): object $F4
	db $56, $ea  ; (6, 5): object $EA
	db $66, $f0  ; (6, 6): object $F0
	db $76, $f1  ; (6, 7): object $F1
	db $68, $6e  ; (8, 6): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $AC (row A, column C of the 16 x 16 map): 31 objects on floor object $03; a warp (type 1) to map $16 room $8F at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomAC::
	db $03, $03  ; animated tiles $03, floor $03
	db $00, $3d  ; (0, 0): object $3D
	db $01, $3c  ; (1, 0): object $3C
	db $09, $3d  ; (9, 0): object $3D
	db $c7, $10, $38  ; 7 down from (0, 1): object $38
	db $c7, $11, $37  ; 7 down from (1, 1): object $37
	db $c7, $19, $38  ; 7 down from (9, 1): object $38
	db $71, $2e  ; (1, 7): object $2E
	db $87, $72, $2f  ; 7 across from (2, 7): object $2F
	db $74, $48  ; (4, 7): object $48
	db $75, $e0  ; (5, 7): object $E0
	db $76, $49  ; (6, 7): object $49
	db $79, $4e  ; (9, 7): object $4E
	db $c3, $45, $b9  ; 3 down from (5, 4): object $B9
	db $64, $b9  ; (4, 6): object $B9
	db $66, $b9  ; (6, 6): object $B9
	db $87, $02, $b3  ; 7 across from (2, 0): object $B3
	db $87, $12, $b3  ; 7 across from (2, 1): object $B3
	db $22, $ad  ; (2, 2): object $AD
	db $23, $af  ; (3, 2): object $AF
	db $24, $b1  ; (4, 2): object $B1
	db $25, $e7  ; (5, 2): object $E7
	db $26, $ad  ; (6, 2): object $AD
	db $27, $af  ; (7, 2): object $AF
	db $28, $b1  ; (8, 2): object $B1
	db $32, $ae  ; (2, 3): object $AE
	db $33, $b0  ; (3, 3): object $B0
	db $34, $b2  ; (4, 3): object $B2
	db $35, $e3  ; (5, 3): object $E3
	db $36, $ae  ; (6, 3): object $AE
	db $37, $b0  ; (7, 3): object $B0
	db $38, $b2  ; (8, 3): object $B2
	db $e1, $16, $8f, $50, $7c  ; warp type 1 to map $16 room $8F, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $AD (row A, column D of the 16 x 16 map): 12 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomAD::
	db $03, $03  ; animated tiles $03, floor $03
	db $8a, $00, $2f  ; 10 across from (0, 0): object $2F
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $c6, $20, $b6  ; 6 down from (0, 2): object $B6
	db $c4, $43, $b6  ; 4 down from (3, 4): object $B6
	db $c3, $25, $b6  ; 3 down from (5, 2): object $B6
	db $55, $b7  ; (5, 5): object $B7
	db $c4, $47, $b6  ; 4 down from (7, 4): object $B6
	db $82, $78, $b6  ; 2 across from (8, 7): object $B6
	db $49, $b6  ; (9, 4): object $B6
	db $59, $b7  ; (9, 5): object $B7
	db $33, $b8  ; (3, 3): object $B8
	db $37, $b8  ; (7, 3): object $B8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $AE (row A, column E of the 16 x 16 map): 15 objects on floor object $03; a warp (type 1) to map $11 room $FC at x 104, y 96. Format: see OverworldRoomPointers.
OverworldRoomAE::
	db $03, $03  ; animated tiles $03, floor $03
	db $8a, $00, $2f  ; 10 across from (0, 0): object $2F
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $c5, $25, $b6  ; 5 down from (5, 2): object $B6
	db $40, $b6  ; (0, 4): object $B6
	db $50, $b7  ; (0, 5): object $B7
	db $8a, $70, $b6  ; 10 across from (0, 7): object $B6
	db $32, $b8  ; (2, 3): object $B8
	db $52, $b8  ; (2, 5): object $B8
	db $38, $b8  ; (8, 3): object $B8
	db $58, $b8  ; (8, 5): object $B8
	db $54, $c6  ; (4, 5): object $C6
	db $e1, $11, $fc, $68, $60  ; warp type 1 to map $11 room $FC, x 104 y 96
	db $c3, $33, $b9  ; 3 down from (3, 3): object $B9
	db $83, $42, $b9  ; 3 across from (2, 4): object $B9
	db $c3, $37, $b9  ; 3 down from (7, 3): object $B9
	db $83, $46, $b9  ; 3 across from (6, 4): object $B9
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $AF (row A, column F of the 16 x 16 map): 33 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomAF::
	db $0a, $03  ; animated tiles $0A, floor $03
	db $82, $00, $2f  ; 2 across from (0, 0): object $2F
	db $02, $4e  ; (2, 0): object $4E
	db $04, $2e  ; (4, 0): object $2E
	db $05, $2f  ; (5, 0): object $2F
	db $06, $3c  ; (6, 0): object $3C
	db $07, $09  ; (7, 0): object $09
	db $c5, $08, $38  ; 5 down from (8, 0): object $38
	db $c5, $09, $0e  ; 5 down from (9, 0): object $0E
	db $82, $10, $3a  ; 2 across from (0, 1): object $3A
	db $12, $3b  ; (2, 1): object $3B
	db $14, $39  ; (4, 1): object $39
	db $15, $3a  ; (5, 1): object $3A
	db $c6, $16, $37  ; 6 down from (6, 1): object $37
	db $c3, $22, $b6  ; 3 down from (2, 2): object $B6
	db $c2, $34, $b6  ; 2 down from (4, 3): object $B6
	db $52, $b7  ; (2, 5): object $B7
	db $54, $b7  ; (4, 5): object $B7
	db $31, $b8  ; (1, 3): object $B8
	db $35, $b8  ; (5, 3): object $B8
	db $51, $b8  ; (1, 5): object $B8
	db $55, $b8  ; (5, 5): object $B8
	db $67, $09  ; (7, 6): object $09
	db $70, $b6  ; (0, 7): object $B6
	db $72, $b6  ; (2, 7): object $B6
	db $74, $b6  ; (4, 7): object $B6
	db $76, $2e  ; (6, 7): object $2E
	db $77, $3c  ; (7, 7): object $3C
	db $58, $32  ; (8, 5): object $32
	db $59, $2d  ; (9, 5): object $2D
	db $c2, $69, $38  ; 2 down from (9, 6): object $38
	db $c6, $23, $b9  ; 6 down from (3, 2): object $B9
	db $24, $b9  ; (4, 2): object $B9
	db $83, $62, $b9  ; 3 across from (2, 6): object $B9
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B0 (row B, column 0 of the 16 x 16 map): 15 objects on floor object $04; a warp (type 1) to map $1D room $FA at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomB0::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $0e  ; 8 down from (0, 0): object $0E
	db $c8, $01, $37  ; 8 down from (1, 0): object $37
	db $72, $f5  ; (2, 7): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $82, $77, $f5  ; 2 across from (7, 7): object $F5
	db $c4, $07, $0b  ; 4 down from (7, 0): object $0B
	db $36, $0b  ; (6, 3): object $0B
	db $82, $45, $0b  ; 2 across from (5, 4): object $0B
	db $c2, $48, $5c  ; 2 down from (8, 4): object $5C
	db $c3, $55, $0b  ; 3 down from (5, 5): object $0B
	db $02, $44  ; (2, 0): object $44
	db $14, $44  ; (4, 1): object $44
	db $38, $44  ; (8, 3): object $44
	db $c4, $f9, $f5  ; 4 down from (9, 15): object $F5
	db $12, $fd  ; (2, 1): object $FD
	db $e1, $1d, $fa, $50, $7c  ; warp type 1 to map $1D room $FA, x 80 y 124
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $B1 (row B, column 1 of the 16 x 16 map): 15 objects on floor object $04; a warp (type 1) to map $10 room $A9 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomB1::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $ff, $f5  ; 4 down from (15, 15): object $F5
	db $60, $f5  ; (0, 6): object $F5
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $87, $21, $60  ; 7 across from (1, 2): object $60
	db $21, $5f  ; (1, 2): object $5F
	db $27, $5f  ; (7, 2): object $5F
	db $31, $60  ; (1, 3): object $60
	db $37, $60  ; (7, 3): object $60
	db $c3, $32, $0a  ; 3 down from (2, 3): object $0A
	db $c3, $36, $0a  ; 3 down from (6, 3): object $0A
	db $33, $f7  ; (3, 3): object $F7
	db $e1, $10, $a9, $50, $7c  ; warp type 1 to map $10 room $A9, x 80 y 124
	db $07, $44  ; (7, 0): object $44
	db $13, $44  ; (3, 1): object $44
	db $39, $44  ; (9, 3): object $44
	db $68, $44  ; (8, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B2 (row B, column 2 of the 16 x 16 map): 16 objects on floor object $04; a warp (type 1) to map $10 room $CB at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomB2::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $7f, $f5  ; 6 across from (15, 7): object $F5
	db $87, $12, $0c  ; 7 across from (2, 1): object $0C
	db $c4, $22, $0c  ; 4 down from (2, 2): object $0C
	db $c4, $28, $0c  ; 4 down from (8, 2): object $0C
	db $87, $62, $0c  ; 7 across from (2, 6): object $0C
	db $85, $23, $0d  ; 5 across from (3, 2): object $0D
	db $c2, $33, $0d  ; 2 down from (3, 3): object $0D
	db $c2, $37, $0d  ; 2 down from (7, 3): object $0D
	db $85, $53, $0d  ; 5 across from (3, 5): object $0D
	db $34, $f5  ; (4, 3): object $F5
	db $35, $f5  ; (5, 3): object $F5
	db $35, $45  ; (5, 3): object $45
	db $45, $e1  ; (5, 4): object $E1
	db $e1, $10, $cb, $50, $7c  ; warp type 1 to map $10 room $CB, x 80 y 124
	db $07, $44  ; (7, 0): object $44
	db $20, $44  ; (0, 2): object $44
	db $61, $44  ; (1, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B3 (row B, column 3 of the 16 x 16 map): 22 objects on floor object $04; a warp (type 1) to map $0F room $A0 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomB3::
	db $03, $04  ; animated tiles $03, floor $04
	db $83, $14, $5c  ; 3 across from (4, 1): object $5C
	db $c4, $23, $5c  ; 4 down from (3, 2): object $5C
	db $c4, $27, $5c  ; 4 down from (7, 2): object $5C
	db $82, $64, $5c  ; 2 across from (4, 6): object $5C
	db $24, $f7  ; (4, 2): object $F7
	db $34, $40  ; (4, 3): object $40
	db $35, $41  ; (5, 3): object $41
	db $36, $42  ; (6, 3): object $42
	db $e1, $0f, $a0, $50, $7c  ; warp type 1 to map $0F room $A0, x 80 y 124
	db $c7, $08, $38  ; 7 down from (8, 0): object $38
	db $c7, $09, $0e  ; 7 down from (9, 0): object $0E
	db $82, $73, $04  ; 2 across from (3, 7): object $04
	db $66, $f5  ; (6, 6): object $F5
	db $84, $7f, $f5  ; 4 across from (15, 7): object $F5
	db $88, $00, $0a  ; 8 across from (0, 0): object $0A
	db $78, $32  ; (8, 7): object $32
	db $79, $2c  ; (9, 7): object $2C
	db $09, $04  ; (9, 0): object $04
	db $f9, $f5  ; (9, 15): object $F5
	db $08, $0a  ; (8, 0): object $0A
	db $18, $3d  ; (8, 1): object $3D
	db $19, $2f  ; (9, 1): object $2F
	db $41, $44  ; (1, 4): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B4 (row B, column 4 of the 16 x 16 map): 20 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoomB4::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $00, $04  ; (0, 0): object $04
	db $ff, $f5  ; (15, 15): object $F5
	db $c8, $08, $04  ; 8 down from (8, 0): object $04
	db $c8, $09, $04  ; 8 down from (9, 0): object $04
	db $c5, $f8, $f5  ; 5 down from (8, 15): object $F5
	db $10, $3c  ; (0, 1): object $3C
	db $c5, $20, $37  ; 5 down from (0, 2): object $37
	db $82, $43, $04  ; 2 across from (3, 4): object $04
	db $43, $f5  ; (3, 4): object $F5
	db $45, $d4  ; (5, 4): object $D4
	db $c4, $51, $04  ; 4 down from (1, 5): object $04
	db $c3, $52, $04  ; 3 down from (2, 5): object $04
	db $c2, $51, $f5  ; 2 down from (1, 5): object $F5
	db $c2, $63, $04  ; 2 down from (3, 6): object $04
	db $62, $f5  ; (2, 6): object $F5
	db $70, $31  ; (0, 7): object $31
	db $26, $e8  ; (6, 2): object $E8
	db $83, $35, $e8  ; 3 across from (5, 3): object $E8
	db $46, $e8  ; (6, 4): object $E8
	db $c2, $47, $e8  ; 2 down from (7, 4): object $E8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B5 (row B, column 5 of the 16 x 16 map): 40 objects on floor object $04; a warp (type 1) to map $02 room $52 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomB5::
	db $03, $04  ; animated tiles $03, floor $04
	db $04, $6a  ; (4, 0): object $6A
	db $08, $6a  ; (8, 0): object $6A
	db $14, $6b  ; (4, 1): object $6B
	db $18, $6b  ; (8, 1): object $6B
	db $83, $05, $6c  ; 3 across from (5, 0): object $6C
	db $83, $15, $62  ; 3 across from (5, 1): object $62
	db $16, $c2  ; (6, 1): object $C2
	db $03, $39  ; (3, 0): object $39
	db $09, $3a  ; (9, 0): object $3A
	db $13, $b6  ; (3, 1): object $B6
	db $23, $b7  ; (3, 2): object $B7
	db $33, $b6  ; (3, 3): object $B6
	db $43, $b7  ; (3, 4): object $B7
	db $44, $b6  ; (4, 4): object $B6
	db $54, $b7  ; (4, 5): object $B7
	db $46, $b6  ; (6, 4): object $B6
	db $56, $c0  ; (6, 5): object $C0
	db $48, $b6  ; (8, 4): object $B6
	db $58, $b7  ; (8, 5): object $B7
	db $19, $1b  ; (9, 1): object $1B
	db $24, $11  ; (4, 2): object $11
	db $83, $25, $1b  ; 3 across from (5, 2): object $1B
	db $28, $1a  ; (8, 2): object $1A
	db $29, $10  ; (9, 2): object $10
	db $34, $15  ; (4, 3): object $15
	db $83, $35, $10  ; 3 across from (5, 3): object $10
	db $38, $16  ; (8, 3): object $16
	db $c2, $53, $0a  ; 2 down from (3, 5): object $0A
	db $64, $0a  ; (4, 6): object $0A
	db $e1, $02, $52, $50, $7c  ; warp type 1 to map $02 room $52, x 80 y 124
	db $c7, $00, $37  ; 7 down from (0, 0): object $37
	db $70, $2e  ; (0, 7): object $2E
	db $89, $71, $2f  ; 9 across from (1, 7): object $2F
	db $75, $48  ; (5, 7): object $48
	db $76, $e0  ; (6, 7): object $E0
	db $77, $49  ; (7, 7): object $49
	db $c7, $01, $0a  ; 7 down from (1, 0): object $0A
	db $c7, $02, $0a  ; 7 down from (2, 0): object $0A
	db $55, $6e  ; (5, 5): object $6E
	db $57, $6e  ; (7, 5): object $6E
	db $68, $6e  ; (8, 6): object $6E
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $B6 (row B, column 6 of the 16 x 16 map): 32 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoomB6::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $83, $00, $3a  ; 3 across from (0, 0): object $3A
	db $01, $e0  ; (1, 0): object $E0
	db $03, $3b  ; (3, 0): object $3B
	db $10, $1a  ; (0, 1): object $1A
	db $82, $11, $10  ; 2 across from (1, 1): object $10
	db $13, $19  ; (3, 1): object $19
	db $15, $1a  ; (5, 1): object $1A
	db $16, $19  ; (6, 1): object $19
	db $20, $16  ; (0, 2): object $16
	db $82, $21, $04  ; 2 across from (1, 2): object $04
	db $23, $11  ; (3, 2): object $11
	db $25, $18  ; (5, 2): object $18
	db $26, $17  ; (6, 2): object $17
	db $c4, $30, $04  ; 4 down from (0, 3): object $04
	db $31, $13  ; (1, 3): object $13
	db $32, $0f  ; (2, 3): object $0F
	db $33, $17  ; (3, 3): object $17
	db $c3, $40, $04  ; 3 down from (0, 4): object $04
	db $c3, $41, $11  ; 3 down from (1, 4): object $11
	db $46, $1a  ; (6, 4): object $1A
	db $47, $19  ; (7, 4): object $19
	db $53, $1a  ; (3, 5): object $1A
	db $54, $19  ; (4, 5): object $19
	db $56, $18  ; (6, 5): object $18
	db $57, $17  ; (7, 5): object $17
	db $63, $18  ; (3, 6): object $18
	db $64, $17  ; (4, 6): object $17
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $18, $1a  ; (8, 1): object $1A
	db $28, $18  ; (8, 2): object $18
	db $19, $10  ; (9, 1): object $10
	db $29, $0f  ; (9, 2): object $0F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B7 (row B, column 7 of the 16 x 16 map): 25 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomB7::
	db $03, $04  ; animated tiles $03, floor $04
	db $c7, $00, $0e  ; 7 down from (0, 0): object $0E
	db $c7, $01, $0e  ; 7 down from (1, 0): object $0E
	db $c7, $02, $0e  ; 7 down from (2, 0): object $0E
	db $c2, $33, $0e  ; 2 down from (3, 3): object $0E
	db $05, $f5  ; (5, 0): object $F5
	db $c2, $07, $0b  ; 2 down from (7, 0): object $0B
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c3, $26, $f5  ; 3 down from (6, 2): object $F5
	db $c4, $45, $0a  ; 4 down from (5, 4): object $0A
	db $53, $3d  ; (3, 5): object $3D
	db $54, $35  ; (4, 5): object $35
	db $62, $0e  ; (2, 6): object $0E
	db $63, $38  ; (3, 6): object $38
	db $64, $0a  ; (4, 6): object $0A
	db $83, $70, $2f  ; 3 across from (0, 7): object $2F
	db $73, $4e  ; (3, 7): object $4E
	db $82, $74, $d3  ; 2 across from (4, 7): object $D3
	db $10, $10  ; (0, 1): object $10
	db $20, $0f  ; (0, 2): object $0F
	db $11, $19  ; (1, 1): object $19
	db $21, $17  ; (1, 2): object $17
	db $c3, $03, $12  ; 3 down from (3, 0): object $12
	db $23, $18  ; (3, 2): object $18
	db $24, $14  ; (4, 2): object $14
	db $c2, $34, $12  ; 2 down from (4, 3): object $12
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B8 (row B, column 8 of the 16 x 16 map): 26 objects on floor object $04; a warp (type 1) to map $0A room $95 at x 112, y 124; a warp (type 1) to map $0A room $92 at x 48, y 124. Format: see OverworldRoomPointers.
OverworldRoomB8::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $00, $f5  ; 4 down from (0, 0): object $F5
	db $c2, $51, $f5  ; 2 down from (1, 5): object $F5
	db $03, $37  ; (3, 0): object $37
	db $06, $38  ; (6, 0): object $38
	db $13, $2e  ; (3, 1): object $2E
	db $82, $14, $2f  ; 2 across from (4, 1): object $2F
	db $16, $4e  ; (6, 1): object $4E
	db $23, $39  ; (3, 2): object $39
	db $24, $3a  ; (4, 2): object $3A
	db $25, $e1  ; (5, 2): object $E1
	db $e1, $0a, $95, $70, $7c  ; warp type 1 to map $0A room $95, x 112 y 124
	db $26, $3b  ; (6, 2): object $3B
	db $c4, $08, $38  ; 4 down from (8, 0): object $38
	db $45, $3d  ; (5, 4): object $3D
	db $82, $46, $2f  ; 2 across from (6, 4): object $2F
	db $48, $4e  ; (8, 4): object $4E
	db $56, $3a  ; (6, 5): object $3A
	db $57, $e1  ; (7, 5): object $E1
	db $e1, $0a, $92, $30, $7c  ; warp type 1 to map $0A room $92, x 48 y 124
	db $58, $3b  ; (8, 5): object $3B
	db $c3, $55, $38  ; 3 down from (5, 5): object $38
	db $c4, $29, $0a  ; 4 down from (9, 2): object $0A
	db $83, $66, $0a  ; 3 across from (6, 6): object $0A
	db $82, $76, $0a  ; 2 across from (6, 7): object $0A
	db $33, $44  ; (3, 3): object $44
	db $59, $6e  ; (9, 5): object $6E
	db $77, $6e  ; (7, 7): object $6E
	db $79, $6e  ; (9, 7): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $B9 (row B, column 9 of the 16 x 16 map): 20 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomB9::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $66, $38  ; 2 down from (6, 6): object $38
	db $56, $3d  ; (6, 5): object $3D
	db $83, $57, $2f  ; 3 across from (7, 5): object $2F
	db $83, $67, $0e  ; 3 across from (7, 6): object $0E
	db $83, $77, $0e  ; 3 across from (7, 7): object $0E
	db $c3, $07, $6e  ; 3 down from (7, 0): object $6E
	db $11, $6e  ; (1, 1): object $6E
	db $13, $6e  ; (3, 1): object $6E
	db $15, $6e  ; (5, 1): object $6E
	db $31, $6e  ; (1, 3): object $6E
	db $34, $20  ; (4, 3): object $20
	db $83, $35, $6e  ; 3 across from (5, 3): object $6E
	db $c2, $44, $6e  ; 2 down from (4, 4): object $6E
	db $83, $50, $6e  ; 3 across from (0, 5): object $6E
	db $04, $44  ; (4, 0): object $44
	db $19, $44  ; (9, 1): object $44
	db $74, $44  ; (4, 7): object $44
	db $70, $6e  ; (0, 7): object $6E
	db $72, $6e  ; (2, 7): object $6E
	db $f9, $f5  ; (9, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $BA (row B, column A of the 16 x 16 map): 28 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomBA::
	db $03, $04  ; animated tiles $03, floor $04
	db $20, $44  ; (0, 2): object $44
	db $23, $3d  ; (3, 2): object $3D
	db $86, $24, $2f  ; 6 across from (4, 2): object $2F
	db $26, $48  ; (6, 2): object $48
	db $27, $e0  ; (7, 2): object $E0
	db $28, $49  ; (8, 2): object $49
	db $33, $38  ; (3, 3): object $38
	db $86, $34, $0e  ; 6 across from (4, 3): object $0E
	db $42, $3d  ; (2, 4): object $3D
	db $43, $34  ; (3, 4): object $34
	db $44, $0e  ; (4, 4): object $0E
	db $45, $2b  ; (5, 4): object $2B
	db $84, $46, $2c  ; 4 across from (6, 4): object $2C
	db $82, $50, $2f  ; 2 across from (0, 5): object $2F
	db $52, $34  ; (2, 5): object $34
	db $82, $53, $0e  ; 2 across from (3, 5): object $0E
	db $55, $37  ; (5, 5): object $37
	db $84, $56, $0a  ; 4 across from (6, 5): object $0A
	db $85, $60, $0e  ; 5 across from (0, 6): object $0E
	db $65, $33  ; (5, 6): object $33
	db $66, $e0  ; (6, 6): object $E0
	db $67, $3c  ; (7, 6): object $3C
	db $82, $68, $0a  ; 2 across from (8, 6): object $0A
	db $87, $70, $0e  ; 7 across from (0, 7): object $0E
	db $77, $37  ; (7, 7): object $37
	db $78, $0a  ; (8, 7): object $0A
	db $79, $f5  ; (9, 7): object $F5
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $BB (row B, column B of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomBB::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $04, $0e  ; 3 down from (4, 0): object $0E
	db $c3, $05, $0e  ; 3 down from (5, 0): object $0E
	db $85, $30, $0e  ; 5 across from (0, 3): object $0E
	db $c2, $03, $38  ; 2 down from (3, 0): object $38
	db $83, $20, $2f  ; 3 across from (0, 2): object $2F
	db $23, $34  ; (3, 2): object $34
	db $c3, $06, $37  ; 3 down from (6, 0): object $37
	db $35, $2b  ; (5, 3): object $2B
	db $36, $31  ; (6, 3): object $31
	db $85, $40, $2c  ; 5 across from (0, 4): object $2C
	db $45, $31  ; (5, 4): object $31
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c3, $27, $0a  ; 3 down from (7, 2): object $0A
	db $46, $0a  ; (6, 4): object $0A
	db $88, $50, $0a  ; 8 across from (0, 5): object $0A
	db $82, $65, $0a  ; 2 across from (5, 6): object $0A
	db $c2, $68, $0a  ; 2 down from (8, 6): object $0A
	db $38, $5c  ; (8, 3): object $5C
	db $58, $5c  ; (8, 5): object $5C
	db $64, $5c  ; (4, 6): object $5C
	db $08, $44  ; (8, 0): object $44
	db $76, $44  ; (6, 7): object $44
	db $7f, $f5  ; (15, 7): object $F5
	db $82, $ff, $f5  ; 2 across from (15, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $BC (row B, column C of the 16 x 16 map): 24 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomBC::
	db $03, $03  ; animated tiles $03, floor $03
	db $c7, $00, $38  ; 7 down from (0, 0): object $38
	db $01, $39  ; (1, 0): object $39
	db $87, $02, $3a  ; 7 across from (2, 0): object $3A
	db $05, $e0  ; (5, 0): object $E0
	db $09, $3b  ; (9, 0): object $3B
	db $16, $b6  ; (6, 1): object $B6
	db $83, $23, $b6  ; 3 across from (3, 2): object $B6
	db $c2, $33, $b6  ; 2 down from (3, 3): object $B6
	db $82, $34, $b7  ; 2 across from (4, 3): object $B7
	db $53, $b7  ; (3, 5): object $B7
	db $26, $b7  ; (6, 2): object $B7
	db $44, $b8  ; (4, 4): object $B8
	db $83, $47, $b6  ; 3 across from (7, 4): object $B6
	db $57, $b6  ; (7, 5): object $B6
	db $82, $58, $b7  ; 2 across from (8, 5): object $B7
	db $67, $b7  ; (7, 6): object $B7
	db $70, $32  ; (0, 7): object $32
	db $89, $71, $2c  ; 9 across from (1, 7): object $2C
	db $83, $13, $b9  ; 3 across from (3, 1): object $B9
	db $c3, $17, $b9  ; 3 down from (7, 1): object $B9
	db $c4, $22, $b9  ; 4 down from (2, 2): object $B9
	db $c3, $36, $b9  ; 3 down from (6, 3): object $B9
	db $c2, $45, $b9  ; 2 down from (5, 4): object $B9
	db $54, $b9  ; (4, 5): object $B9
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $BD (row B, column D of the 16 x 16 map): 11 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomBD::
	db $03, $03  ; animated tiles $03, floor $03
	db $00, $b7  ; (0, 0): object $B7
	db $c4, $03, $b6  ; 4 down from (3, 0): object $B6
	db $83, $07, $b7  ; 3 across from (7, 0): object $B7
	db $84, $36, $b6  ; 4 across from (6, 3): object $B6
	db $84, $40, $b6  ; 4 across from (0, 4): object $B6
	db $c2, $46, $b6  ; 2 down from (6, 4): object $B6
	db $83, $47, $b7  ; 3 across from (7, 4): object $B7
	db $84, $50, $b7  ; 4 across from (0, 5): object $B7
	db $66, $b7  ; (6, 6): object $B7
	db $8a, $70, $2c  ; 10 across from (0, 7): object $2C
	db $24, $b8  ; (4, 2): object $B8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $BE (row B, column E of the 16 x 16 map): 14 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomBE::
	db $03, $03  ; animated tiles $03, floor $03
	db $8a, $00, $b7  ; 10 across from (0, 0): object $B7
	db $c4, $22, $b6  ; 4 down from (2, 2): object $B6
	db $c3, $07, $b6  ; 3 down from (7, 0): object $B6
	db $83, $37, $b6  ; 3 across from (7, 3): object $B6
	db $30, $b6  ; (0, 3): object $B6
	db $40, $b7  ; (0, 4): object $B7
	db $83, $47, $b7  ; 3 across from (7, 4): object $B7
	db $16, $b8  ; (6, 1): object $B8
	db $44, $b8  ; (4, 4): object $B8
	db $8a, $70, $2c  ; 10 across from (0, 7): object $2C
	db $62, $b7  ; (2, 6): object $B7
	db $c4, $15, $b9  ; 4 down from (5, 1): object $B9
	db $83, $24, $b9  ; 3 across from (4, 2): object $B9
	db $83, $34, $b9  ; 3 across from (4, 3): object $B9
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $BF (row B, column F of the 16 x 16 map): 26 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomBF::
	db $03, $03  ; animated tiles $03, floor $03
	db $06, $39  ; (6, 0): object $39
	db $c8, $07, $37  ; 8 down from (7, 0): object $37
	db $88, $70, $2c  ; 8 across from (0, 7): object $2C
	db $77, $31  ; (7, 7): object $31
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $28, $09  ; (8, 2): object $09
	db $68, $09  ; (8, 6): object $09
	db $00, $b7  ; (0, 0): object $B7
	db $02, $b6  ; (2, 0): object $B6
	db $04, $b6  ; (4, 0): object $B6
	db $12, $b7  ; (2, 1): object $B7
	db $14, $b7  ; (4, 1): object $B7
	db $30, $b6  ; (0, 3): object $B6
	db $32, $b6  ; (2, 3): object $B6
	db $34, $b6  ; (4, 3): object $B6
	db $40, $b7  ; (0, 4): object $B7
	db $42, $b7  ; (2, 4): object $B7
	db $44, $b7  ; (4, 4): object $B7
	db $33, $b8  ; (3, 3): object $B8
	db $55, $b8  ; (5, 5): object $B8
	db $c2, $03, $b9  ; 2 down from (3, 0): object $B9
	db $c2, $41, $b9  ; 2 down from (1, 4): object $B9
	db $43, $b9  ; (3, 4): object $B9
	db $45, $b9  ; (5, 4): object $B9
	db $52, $b9  ; (2, 5): object $B9
	db $54, $b9  ; (4, 5): object $B9
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C0 (row C, column 0 of the 16 x 16 map): 36 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomC0::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $01, $37  ; 2 down from (1, 0): object $37
	db $c2, $00, $0e  ; 2 down from (0, 0): object $0E
	db $21, $31  ; (1, 2): object $31
	db $20, $2b  ; (0, 2): object $2B
	db $c5, $30, $37  ; 5 down from (0, 3): object $37
	db $82, $f7, $f5  ; 2 across from (7, 15): object $F5
	db $f2, $f5  ; (2, 15): object $F5
	db $22, $36  ; (2, 2): object $36
	db $23, $3c  ; (3, 2): object $3C
	db $33, $2e  ; (3, 3): object $2E
	db $34, $2f  ; (4, 3): object $2F
	db $35, $48  ; (5, 3): object $48
	db $36, $43  ; (6, 3): object $43
	db $37, $49  ; (7, 3): object $49
	db $38, $4e  ; (8, 3): object $4E
	db $28, $3d  ; (8, 2): object $3D
	db $29, $2f  ; (9, 2): object $2F
	db $84, $44, $3a  ; 4 across from (4, 4): object $3A
	db $43, $39  ; (3, 4): object $39
	db $48, $3b  ; (8, 4): object $3B
	db $70, $2e  ; (0, 7): object $2E
	db $82, $71, $2f  ; 2 across from (1, 7): object $2F
	db $73, $48  ; (3, 7): object $48
	db $74, $43  ; (4, 7): object $43
	db $75, $49  ; (5, 7): object $49
	db $82, $76, $2f  ; 2 across from (6, 7): object $2F
	db $78, $4e  ; (8, 7): object $4E
	db $68, $3d  ; (8, 6): object $3D
	db $69, $2f  ; (9, 6): object $2F
	db $14, $d4  ; (4, 1): object $D4
	db $c2, $05, $0b  ; 2 down from (5, 0): object $0B
	db $c2, $16, $0b  ; 2 down from (6, 1): object $0B
	db $56, $0b  ; (6, 5): object $0B
	db $83, $64, $0b  ; 3 across from (4, 6): object $0B
	db $27, $44  ; (7, 2): object $44
	db $55, $44  ; (5, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C1 (row C, column 1 of the 16 x 16 map): 14 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomC1::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $83, $20, $2f  ; 3 across from (0, 2): object $2F
	db $23, $35  ; (3, 2): object $35
	db $60, $35  ; (0, 6): object $35
	db $57, $35  ; (7, 5): object $35
	db $56, $3d  ; (6, 5): object $3D
	db $c2, $66, $38  ; 2 down from (6, 6): object $38
	db $c3, $39, $f5  ; 3 down from (9, 3): object $F5
	db $82, $26, $5c  ; 2 across from (6, 2): object $5C
	db $83, $42, $5c  ; 3 across from (2, 4): object $5C
	db $45, $e8  ; (5, 4): object $E8
	db $15, $44  ; (5, 1): object $44
	db $62, $44  ; (2, 6): object $44
	db $68, $44  ; (8, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C2 (row C, column 2 of the 16 x 16 map): 10 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomC2::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $ff, $f5  ; 6 across from (15, 15): object $F5
	db $c3, $3f, $f5  ; 3 down from (15, 3): object $F5
	db $83, $35, $f5  ; 3 across from (5, 3): object $F5
	db $41, $f5  ; (1, 4): object $F5
	db $69, $f5  ; (9, 6): object $F5
	db $78, $f5  ; (8, 7): object $F5
	db $83, $53, $e8  ; 3 across from (3, 5): object $E8
	db $43, $e8  ; (3, 4): object $E8
	db $16, $44  ; (6, 1): object $44
	db $22, $44  ; (2, 2): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C3 (row C, column 3 of the 16 x 16 map): 15 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomC3::
	db $03, $04  ; animated tiles $03, floor $04
	db $84, $ff, $f5  ; 4 across from (15, 15): object $F5
	db $82, $06, $f5  ; 2 across from (6, 0): object $F5
	db $c4, $19, $f5  ; 4 down from (9, 1): object $F5
	db $82, $3f, $f5  ; 2 across from (15, 3): object $F5
	db $6f, $f5  ; (15, 6): object $F5
	db $82, $70, $f5  ; 2 across from (0, 7): object $F5
	db $74, $2b  ; (4, 7): object $2B
	db $83, $75, $2c  ; 3 across from (5, 7): object $2C
	db $78, $2d  ; (8, 7): object $2D
	db $34, $5c  ; (4, 3): object $5C
	db $38, $5c  ; (8, 3): object $5C
	db $56, $5c  ; (6, 5): object $5C
	db $23, $44  ; (3, 2): object $44
	db $36, $44  ; (6, 3): object $44
	db $55, $44  ; (5, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C4 (row C, column 4 of the 16 x 16 map): 38 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomC4::
	db $03, $04  ; animated tiles $03, floor $04
	db $f1, $f5  ; (1, 15): object $F5
	db $82, $00, $f5  ; 2 across from (0, 0): object $F5
	db $c4, $1f, $f5  ; 4 down from (15, 1): object $F5
	db $40, $f5  ; (0, 4): object $F5
	db $86, $04, $0a  ; 6 across from (4, 0): object $0A
	db $86, $14, $0a  ; 6 across from (4, 1): object $0A
	db $84, $21, $0a  ; 4 across from (1, 2): object $0A
	db $22, $d4  ; (2, 2): object $D4
	db $25, $1a  ; (5, 2): object $1A
	db $84, $26, $10  ; 4 across from (6, 2): object $10
	db $83, $31, $0a  ; 3 across from (1, 3): object $0A
	db $34, $1a  ; (4, 3): object $1A
	db $35, $16  ; (5, 3): object $16
	db $36, $e8  ; (6, 3): object $E8
	db $37, $d4  ; (7, 3): object $D4
	db $42, $e8  ; (2, 4): object $E8
	db $43, $0a  ; (3, 4): object $0A
	db $44, $12  ; (4, 4): object $12
	db $46, $13  ; (6, 4): object $13
	db $83, $47, $0f  ; 3 across from (7, 4): object $0F
	db $52, $6e  ; (2, 5): object $6E
	db $53, $1a  ; (3, 5): object $1A
	db $54, $16  ; (4, 5): object $16
	db $c2, $56, $11  ; 2 down from (6, 5): object $11
	db $57, $d4  ; (7, 5): object $D4
	db $82, $58, $1b  ; 2 across from (8, 5): object $1B
	db $c2, $49, $04  ; 2 down from (9, 4): object $04
	db $49, $f5  ; (9, 4): object $F5
	db $61, $e8  ; (1, 6): object $E8
	db $62, $0a  ; (2, 6): object $0A
	db $c2, $63, $12  ; 2 down from (3, 6): object $12
	db $65, $d4  ; (5, 6): object $D4
	db $83, $67, $1b  ; 3 across from (7, 6): object $1B
	db $82, $71, $0a  ; 2 across from (1, 7): object $0A
	db $76, $15  ; (6, 7): object $15
	db $83, $77, $10  ; 3 across from (7, 7): object $10
	db $82, $08, $04  ; 2 across from (8, 0): object $04
	db $f8, $f5  ; (8, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C5 (row C, column 5 of the 16 x 16 map): 46 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomC5::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $00, $39  ; (0, 0): object $39
	db $06, $e0  ; (6, 0): object $E0
	db $83, $74, $0a  ; 3 across from (4, 7): object $0A
	db $84, $10, $0a  ; 4 across from (0, 1): object $0A
	db $84, $16, $0a  ; 4 across from (6, 1): object $0A
	db $88, $22, $0a  ; 8 across from (2, 2): object $0A
	db $14, $f5  ; (4, 1): object $F5
	db $25, $f5  ; (5, 2): object $F5
	db $20, $10  ; (0, 2): object $10
	db $21, $19  ; (1, 2): object $19
	db $22, $d4  ; (2, 2): object $D4
	db $31, $15  ; (1, 3): object $15
	db $82, $32, $10  ; 2 across from (2, 3): object $10
	db $34, $19  ; (4, 3): object $19
	db $37, $d4  ; (7, 3): object $D4
	db $38, $6e  ; (8, 3): object $6E
	db $82, $40, $0f  ; 2 across from (0, 4): object $0F
	db $42, $14  ; (2, 4): object $14
	db $43, $44  ; (3, 4): object $44
	db $44, $15  ; (4, 4): object $15
	db $82, $45, $10  ; 2 across from (5, 4): object $10
	db $47, $19  ; (7, 4): object $19
	db $82, $50, $1b  ; 2 across from (0, 5): object $1B
	db $52, $18  ; (2, 5): object $18
	db $53, $14  ; (3, 5): object $14
	db $55, $20  ; (5, 5): object $20
	db $56, $d4  ; (6, 5): object $D4
	db $57, $11  ; (7, 5): object $11
	db $83, $60, $1b  ; 3 across from (0, 6): object $1B
	db $c2, $63, $12  ; 2 down from (3, 6): object $12
	db $64, $d4  ; (4, 6): object $D4
	db $65, $13  ; (5, 6): object $13
	db $66, $0f  ; (6, 6): object $0F
	db $67, $17  ; (7, 6): object $17
	db $70, $19  ; (0, 7): object $19
	db $82, $71, $1b  ; 2 across from (1, 7): object $1B
	db $73, $12  ; (3, 7): object $12
	db $74, $44  ; (4, 7): object $44
	db $75, $11  ; (5, 7): object $11
	db $c3, $48, $0a  ; 3 down from (8, 4): object $0A
	db $83, $76, $0a  ; 3 across from (6, 7): object $0A
	db $c2, $40, $04  ; 2 down from (0, 4): object $04
	db $4f, $f5  ; (15, 4): object $F5
	db $c3, $39, $f5  ; 3 down from (9, 3): object $F5
	db $27, $0a  ; (7, 2): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C6 (row C, column 6 of the 16 x 16 map): 29 objects on floor object $0A; a warp (type 1) to map $11 room $C9 at x 128, y 124. Format: see OverworldRoomPointers.
OverworldRoomC6::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $22, $2b  ; (2, 2): object $2B
	db $82, $23, $2c  ; 2 across from (3, 2): object $2C
	db $25, $2d  ; (5, 2): object $2D
	db $32, $2e  ; (2, 3): object $2E
	db $82, $33, $2f  ; 2 across from (3, 3): object $2F
	db $35, $4e  ; (5, 3): object $4E
	db $42, $39  ; (2, 4): object $39
	db $43, $e1  ; (3, 4): object $E1
	db $e1, $11, $c9, $80, $7c  ; warp type 1 to map $11 room $C9, x 128 y 124
	db $44, $3a  ; (4, 4): object $3A
	db $45, $3b  ; (5, 4): object $3B
	db $c8, $00, $04  ; 8 down from (0, 0): object $04
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $c2, $10, $0a  ; 2 down from (0, 1): object $0A
	db $19, $d3  ; (9, 1): object $D3
	db $27, $5c  ; (7, 2): object $5C
	db $c3, $3f, $f5  ; 3 down from (15, 3): object $F5
	db $39, $d3  ; (9, 3): object $D3
	db $84, $46, $d3  ; 4 across from (6, 4): object $D3
	db $c3, $52, $6e  ; 3 down from (2, 5): object $6E
	db $86, $54, $d3  ; 6 across from (4, 5): object $D3
	db $87, $63, $5c  ; 7 across from (3, 6): object $5C
	db $87, $73, $d3  ; 7 across from (3, 7): object $D3
	db $76, $0a  ; (6, 7): object $0A
	db $69, $0a  ; (9, 6): object $0A
	db $15, $6e  ; (5, 1): object $6E
	db $19, $6e  ; (9, 1): object $6E
	db $39, $6e  ; (9, 3): object $6E
	db $84, $46, $6e  ; 4 across from (6, 4): object $6E
	db $17, $6f  ; (7, 1): object $6F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C7 (row C, column 7 of the 16 x 16 map): 18 objects on floor object $D3. Format: see OverworldRoomPointers.
OverworldRoomC7::
	db $03, $d3  ; animated tiles $03, floor $D3
	db $c8, $07, $6e  ; 8 down from (7, 0): object $6E
	db $c8, $08, $04  ; 8 down from (8, 0): object $04
	db $c8, $09, $37  ; 8 down from (9, 0): object $37
	db $c2, $11, $5c  ; 2 down from (1, 1): object $5C
	db $c2, $14, $5c  ; 2 down from (4, 1): object $5C
	db $15, $5c  ; (5, 1): object $5C
	db $c6, $16, $5c  ; 6 down from (6, 1): object $5C
	db $20, $0a  ; (0, 2): object $0A
	db $86, $31, $5c  ; 6 across from (1, 3): object $5C
	db $83, $52, $5c  ; 3 across from (2, 5): object $5C
	db $82, $60, $5c  ; 2 across from (0, 6): object $5C
	db $64, $5c  ; (4, 6): object $5C
	db $71, $0a  ; (1, 7): object $0A
	db $74, $0a  ; (4, 7): object $0A
	db $76, $0a  ; (6, 7): object $0A
	db $60, $0a  ; (0, 6): object $0A
	db $83, $00, $3a  ; 3 across from (0, 0): object $3A
	db $03, $3b  ; (3, 0): object $3B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C8 (row C, column 8 of the 16 x 16 map): 39 objects on floor object $04; a warp (type 1) to map $0A room $93 at x 48, y 124. Format: see OverworldRoomPointers.
OverworldRoomC8::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $00, $03  ; 2 down from (0, 0): object $03
	db $f1, $f5  ; (1, 15): object $F5
	db $03, $09  ; (3, 0): object $09
	db $04, $09  ; (4, 0): object $09
	db $11, $09  ; (1, 1): object $09
	db $12, $03  ; (2, 1): object $03
	db $20, $09  ; (0, 2): object $09
	db $22, $09  ; (2, 2): object $09
	db $30, $3d  ; (0, 3): object $3D
	db $c4, $40, $38  ; 4 down from (0, 4): object $38
	db $82, $31, $2f  ; 2 across from (1, 3): object $2F
	db $33, $4e  ; (3, 3): object $4E
	db $23, $38  ; (3, 2): object $38
	db $13, $3d  ; (3, 1): object $3D
	db $14, $2f  ; (4, 1): object $2F
	db $15, $4e  ; (5, 1): object $4E
	db $05, $38  ; (5, 0): object $38
	db $24, $3a  ; (4, 2): object $3A
	db $25, $3b  ; (5, 2): object $3B
	db $41, $3a  ; (1, 4): object $3A
	db $42, $e1  ; (2, 4): object $E1
	db $e1, $0a, $93, $30, $7c  ; warp type 1 to map $0A room $93, x 48 y 124
	db $43, $3b  ; (3, 4): object $3B
	db $c3, $06, $0a  ; 3 down from (6, 0): object $0A
	db $35, $0a  ; (5, 3): object $0A
	db $c3, $34, $0a  ; 3 down from (4, 3): object $0A
	db $83, $51, $0a  ; 3 across from (1, 5): object $0A
	db $83, $61, $0a  ; 3 across from (1, 6): object $0A
	db $82, $71, $0a  ; 2 across from (1, 7): object $0A
	db $38, $3d  ; (8, 3): object $3D
	db $39, $2f  ; (9, 3): object $2F
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $68, $4e  ; (8, 6): object $4E
	db $67, $3d  ; (7, 6): object $3D
	db $77, $38  ; (7, 7): object $38
	db $78, $3f  ; (8, 7): object $3F
	db $c4, $49, $0e  ; 4 down from (9, 4): object $0E
	db $07, $6e  ; (7, 0): object $6E
	db $09, $6e  ; (9, 0): object $6E
	db $82, $26, $6e  ; 2 across from (6, 2): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $C9 (row C, column 9 of the 16 x 16 map): 17 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoomC9::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $86, $00, $04  ; 6 across from (0, 0): object $04
	db $06, $38  ; (6, 0): object $38
	db $83, $10, $04  ; 3 across from (0, 1): object $04
	db $83, $13, $3d  ; 3 across from (3, 1): object $3D
	db $82, $14, $2f  ; 2 across from (4, 1): object $2F
	db $16, $34  ; (6, 1): object $34
	db $83, $20, $04  ; 3 across from (0, 2): object $04
	db $23, $38  ; (3, 2): object $38
	db $30, $48  ; (0, 3): object $48
	db $31, $e0  ; (1, 3): object $E0
	db $32, $49  ; (2, 3): object $49
	db $33, $34  ; (3, 3): object $34
	db $17, $ca  ; (7, 1): object $CA
	db $62, $ca  ; (2, 6): object $CA
	db $65, $51  ; (5, 6): object $51
	db $02, $6e  ; (2, 0): object $6E
	db $00, $6e  ; (0, 0): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $CA (row C, column A of the 16 x 16 map): 4 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoomCA::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $c8, $07, $37  ; 8 down from (7, 0): object $37
	db $08, $0a  ; (8, 0): object $0A
	db $c7, $18, $04  ; 7 down from (8, 1): object $04
	db $c5, $f9, $f5  ; 5 down from (9, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $CB (row C, column B of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomCB::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $07, $0a  ; 2 across from (7, 0): object $0A
	db $c3, $52, $0a  ; 3 down from (2, 5): object $0A
	db $63, $0a  ; (3, 6): object $0A
	db $06, $44  ; (6, 0): object $44
	db $11, $44  ; (1, 1): object $44
	db $45, $44  ; (5, 4): object $44
	db $58, $44  ; (8, 5): object $44
	db $67, $44  ; (7, 6): object $44
	db $23, $5c  ; (3, 2): object $5C
	db $26, $5c  ; (6, 2): object $5C
	db $53, $5c  ; (3, 5): object $5C
	db $56, $5c  ; (6, 5): object $5C
	db $09, $2e  ; (9, 0): object $2E
	db $19, $39  ; (9, 1): object $39
	db $27, $f5  ; (7, 2): object $F5
	db $38, $f5  ; (8, 3): object $F5
	db $68, $f5  ; (8, 6): object $F5
	db $47, $d4  ; (7, 4): object $D4
	db $c5, $ff, $f5  ; 5 down from (15, 15): object $F5
	db $01, $0a  ; (1, 0): object $0A
	db $11, $44  ; (1, 1): object $44
	db $12, $0a  ; (2, 1): object $0A
	db $83, $16, $0a  ; 3 across from (6, 1): object $0A
	db $21, $0a  ; (1, 2): object $0A
	db $c4, $41, $0a  ; 4 down from (1, 4): object $0A
	db $c3, $52, $0a  ; 3 down from (2, 5): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $CC (row C, column C of the 16 x 16 map): 19 objects on floor object $04; a warp (type 1) to map $10 room $DB at x 80, y 124; a warp (type 1) to map $10 room $DD at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomCC::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $40, $0a  ; 10 across from (0, 4): object $0A
	db $8a, $00, $2f  ; 10 across from (0, 0): object $2F
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $89, $61, $0a  ; 9 across from (1, 6): object $0A
	db $89, $71, $0a  ; 9 across from (1, 7): object $0A
	db $8a, $50, $0c  ; 10 across from (0, 5): object $0C
	db $8a, $30, $62  ; 10 across from (0, 3): object $62
	db $40, $62  ; (0, 4): object $62
	db $21, $55  ; (1, 2): object $55
	db $82, $22, $5a  ; 2 across from (2, 2): object $5A
	db $24, $56  ; (4, 2): object $56
	db $31, $57  ; (1, 3): object $57
	db $82, $32, $59  ; 2 across from (2, 3): object $59
	db $34, $58  ; (4, 3): object $58
	db $84, $41, $5b  ; 4 across from (1, 4): object $5B
	db $42, $e2  ; (2, 4): object $E2
	db $e1, $10, $db, $50, $7c  ; warp type 1 to map $10 room $DB, x 80 y 124
	db $c2, $60, $62  ; 2 down from (0, 6): object $62
	db $28, $44  ; (8, 2): object $44
	db $36, $fd  ; (6, 3): object $FD
	db $e1, $10, $dd, $50, $7c  ; warp type 1 to map $10 room $DD, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $CD (row C, column D of the 16 x 16 map): 14 objects on floor object $04; a warp (type 1) to map $0A room $F7 at x 96, y 124; a warp (type 1) to map $10 room $D9 at x 80, y 124; a warp (type 1) to map $10 room $DA at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomCD::
	db $03, $04  ; animated tiles $03, floor $04
	db $89, $00, $2f  ; 9 across from (0, 0): object $2F
	db $89, $10, $3a  ; 9 across from (0, 1): object $3A
	db $09, $3c  ; (9, 0): object $3C
	db $c7, $19, $37  ; 7 down from (9, 1): object $37
	db $87, $30, $62  ; 7 across from (0, 3): object $62
	db $18, $ba  ; (8, 1): object $BA
	db $e1, $0a, $f7, $60, $7c  ; warp type 1 to map $0A room $F7, x 96 y 124
	db $21, $f7  ; (1, 2): object $F7
	db $e1, $10, $d9, $50, $7c  ; warp type 1 to map $10 room $D9, x 80 y 124
	db $24, $f7  ; (4, 2): object $F7
	db $e1, $10, $da, $50, $7c  ; warp type 1 to map $10 room $DA, x 80 y 124
	db $c5, $37, $62  ; 5 down from (7, 3): object $62
	db $40, $0a  ; (0, 4): object $0A
	db $86, $50, $0c  ; 6 across from (0, 5): object $0C
	db $86, $60, $0a  ; 6 across from (0, 6): object $0A
	db $86, $70, $0a  ; 6 across from (0, 7): object $0A
	db $c3, $56, $0c  ; 3 down from (6, 5): object $0C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $CE (row C, column E of the 16 x 16 map): 31 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomCE::
	db $08, $08  ; animated tiles $08, floor $08
	db $c5, $20, $38  ; 5 down from (0, 2): object $38
	db $10, $3d  ; (0, 1): object $3D
	db $70, $32  ; (0, 7): object $32
	db $00, $09  ; (0, 0): object $09
	db $09, $09  ; (9, 0): object $09
	db $11, $34  ; (1, 1): object $34
	db $01, $3d  ; (1, 0): object $3D
	db $86, $02, $2f  ; 6 across from (2, 0): object $2F
	db $08, $3c  ; (8, 0): object $3C
	db $18, $33  ; (8, 1): object $33
	db $19, $3c  ; (9, 1): object $3C
	db $29, $33  ; (9, 2): object $33
	db $75, $2b  ; (5, 7): object $2B
	db $83, $76, $2c  ; 3 across from (6, 7): object $2C
	db $79, $31  ; (9, 7): object $31
	db $c2, $59, $37  ; 2 down from (9, 5): object $37
	db $49, $2b  ; (9, 4): object $2B
	db $83, $12, $cf  ; 3 across from (2, 1): object $CF
	db $84, $21, $cf  ; 4 across from (1, 2): object $CF
	db $84, $31, $cf  ; 4 across from (1, 3): object $CF
	db $83, $15, $d0  ; 3 across from (5, 1): object $D0
	db $84, $25, $d0  ; 4 across from (5, 2): object $D0
	db $84, $35, $d0  ; 4 across from (5, 3): object $D0
	db $84, $41, $d1  ; 4 across from (1, 4): object $D1
	db $84, $51, $d1  ; 4 across from (1, 5): object $D1
	db $84, $61, $d1  ; 4 across from (1, 6): object $D1
	db $84, $45, $d2  ; 4 across from (5, 4): object $D2
	db $84, $55, $d2  ; 4 across from (5, 5): object $D2
	db $84, $65, $d2  ; 4 across from (5, 6): object $D2
	db $82, $71, $2c  ; 2 across from (1, 7): object $2C
	db $73, $2d  ; (3, 7): object $2D
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $CF (row C, column F of the 16 x 16 map): 23 objects on floor object $08; a warp (type 1) to map $1F room $F9 at x 120, y 96. Format: see OverworldRoomPointers.
OverworldRoomCF::
	db $08, $08  ; animated tiles $08, floor $08
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $00, $3d  ; (0, 0): object $3D
	db $86, $01, $2f  ; 6 across from (1, 0): object $2F
	db $07, $3c  ; (7, 0): object $3C
	db $08, $09  ; (8, 0): object $09
	db $10, $38  ; (0, 1): object $38
	db $17, $33  ; (7, 1): object $33
	db $18, $3c  ; (8, 1): object $3C
	db $20, $34  ; (0, 2): object $34
	db $c5, $28, $37  ; 5 down from (8, 2): object $37
	db $78, $31  ; (8, 7): object $31
	db $77, $2c  ; (7, 7): object $2C
	db $76, $2b  ; (6, 7): object $2B
	db $40, $2d  ; (0, 4): object $2D
	db $c3, $50, $38  ; 3 down from (0, 5): object $38
	db $32, $69  ; (2, 3): object $69
	db $83, $44, $69  ; 3 across from (4, 4): object $69
	db $83, $51, $69  ; 3 across from (1, 5): object $69
	db $82, $72, $69  ; 2 across from (2, 7): object $69
	db $13, $6f  ; (3, 1): object $6F
	db $04, $48  ; (4, 0): object $48
	db $05, $e1  ; (5, 0): object $E1
	db $06, $49  ; (6, 0): object $49
	db $e1, $1f, $f9, $78, $60  ; warp type 1 to map $1F room $F9, x 120 y 96
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D0 (row D, column 0 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomD0::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $37  ; 8 down from (0, 0): object $37
	db $00, $3e  ; (0, 0): object $3E
	db $87, $01, $3a  ; 7 across from (1, 0): object $3A
	db $08, $3b  ; (8, 0): object $3B
	db $30, $2e  ; (0, 3): object $2E
	db $40, $3e  ; (0, 4): object $3E
	db $89, $31, $2f  ; 9 across from (1, 3): object $2F
	db $89, $41, $3a  ; 9 across from (1, 4): object $3A
	db $37, $48  ; (7, 3): object $48
	db $c2, $38, $e0  ; 2 down from (8, 3): object $E0
	db $39, $49  ; (9, 3): object $49
	db $34, $48  ; (4, 3): object $48
	db $35, $43  ; (5, 3): object $43
	db $36, $49  ; (6, 3): object $49
	db $c2, $14, $0b  ; 2 down from (4, 1): object $0B
	db $25, $0b  ; (5, 2): object $0B
	db $63, $36  ; (3, 6): object $36
	db $64, $3c  ; (4, 6): object $3C
	db $74, $2e  ; (4, 7): object $2E
	db $75, $48  ; (5, 7): object $48
	db $76, $4a  ; (6, 7): object $4A
	db $77, $49  ; (7, 7): object $49
	db $82, $78, $2f  ; 2 across from (8, 7): object $2F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D1 (row D, column 1 of the 16 x 16 map): 23 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomD1::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $f9, $f5  ; 4 down from (9, 15): object $F5
	db $c2, $06, $38  ; 2 down from (6, 0): object $38
	db $26, $4e  ; (6, 2): object $4E
	db $36, $3b  ; (6, 3): object $3B
	db $83, $33, $3a  ; 3 across from (3, 3): object $3A
	db $25, $49  ; (5, 2): object $49
	db $23, $48  ; (3, 2): object $48
	db $24, $4a  ; (4, 2): object $4A
	db $22, $3d  ; (2, 2): object $3D
	db $32, $4e  ; (2, 3): object $4E
	db $82, $30, $2f  ; 2 across from (0, 3): object $2F
	db $82, $40, $3a  ; 2 across from (0, 4): object $3A
	db $42, $3b  ; (2, 4): object $3B
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $74, $48  ; (4, 7): object $48
	db $76, $49  ; (6, 7): object $49
	db $75, $4a  ; (5, 7): object $4A
	db $83, $56, $5c  ; 3 across from (6, 5): object $5C
	db $82, $62, $5c  ; 2 across from (2, 6): object $5C
	db $01, $44  ; (1, 0): object $44
	db $14, $44  ; (4, 1): object $44
	db $27, $44  ; (7, 2): object $44
	db $53, $44  ; (3, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D2 (row D, column 2 of the 16 x 16 map): 12 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomD2::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $ff, $f5  ; 4 down from (15, 15): object $F5
	db $f8, $f5  ; (8, 15): object $F5
	db $09, $f5  ; (9, 0): object $F5
	db $29, $f5  ; (9, 2): object $F5
	db $38, $f5  ; (8, 3): object $F5
	db $49, $f5  ; (9, 4): object $F5
	db $43, $f5  ; (3, 4): object $F5
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $12, $44  ; (2, 1): object $44
	db $18, $44  ; (8, 1): object $44
	db $25, $44  ; (5, 2): object $44
	db $52, $44  ; (2, 5): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D3 (row D, column 3 of the 16 x 16 map): 23 objects on floor object $0C; a warp (type 1) to map $00 room $17 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomD3::
	db $03, $0c  ; animated tiles $03, floor $0C
	db $82, $f0, $f5  ; 2 across from (0, 15): object $F5
	db $c3, $0f, $f5  ; 3 down from (15, 0): object $F5
	db $c4, $f9, $f5  ; 4 down from (9, 15): object $F5
	db $04, $2e  ; (4, 0): object $2E
	db $83, $05, $2f  ; 3 across from (5, 0): object $2F
	db $08, $4e  ; (8, 0): object $4E
	db $14, $39  ; (4, 1): object $39
	db $18, $3b  ; (8, 1): object $3B
	db $83, $15, $62  ; 3 across from (5, 1): object $62
	db $16, $c2  ; (6, 1): object $C2
	db $82, $11, $04  ; 2 across from (1, 1): object $04
	db $82, $21, $04  ; 2 across from (1, 2): object $04
	db $82, $31, $04  ; 2 across from (1, 3): object $04
	db $82, $41, $04  ; 2 across from (1, 4): object $04
	db $83, $51, $04  ; 3 across from (1, 5): object $04
	db $68, $04  ; (8, 6): object $04
	db $34, $b6  ; (4, 3): object $B6
	db $38, $b6  ; (8, 3): object $B6
	db $46, $b6  ; (6, 4): object $B6
	db $44, $b7  ; (4, 4): object $B7
	db $48, $b7  ; (8, 4): object $B7
	db $56, $c0  ; (6, 5): object $C0
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $e1, $00, $17, $50, $7c  ; warp type 1 to map $00 room $17, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D4 (row D, column 4 of the 16 x 16 map): 45 objects on floor object $04; a warp (type 1) to map $11 room $FB at x 136, y 112. Format: see OverworldRoomPointers.
OverworldRoomD4::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $c4, $ff, $f5  ; 4 down from (15, 15): object $F5
	db $82, $01, $0a  ; 2 across from (1, 0): object $0A
	db $03, $12  ; (3, 0): object $12
	db $05, $44  ; (5, 0): object $44
	db $07, $13  ; (7, 0): object $13
	db $08, $0f  ; (8, 0): object $0F
	db $09, $14  ; (9, 0): object $14
	db $11, $0a  ; (1, 1): object $0A
	db $12, $1a  ; (2, 1): object $1A
	db $13, $16  ; (3, 1): object $16
	db $c2, $17, $11  ; 2 down from (7, 1): object $11
	db $c2, $18, $1b  ; 2 down from (8, 1): object $1B
	db $c2, $19, $12  ; 2 down from (9, 1): object $12
	db $21, $d4  ; (1, 2): object $D4
	db $22, $18  ; (2, 2): object $18
	db $23, $0f  ; (3, 2): object $0F
	db $24, $14  ; (4, 2): object $14
	db $25, $d3  ; (5, 2): object $D3
	db $e1, $11, $fb, $88, $70  ; warp type 1 to map $11 room $FB, x 136 y 112
	db $82, $31, $0a  ; 2 across from (1, 3): object $0A
	db $33, $6e  ; (3, 3): object $6E
	db $34, $18  ; (4, 3): object $18
	db $35, $0f  ; (5, 3): object $0F
	db $36, $14  ; (6, 3): object $14
	db $37, $15  ; (7, 3): object $15
	db $38, $10  ; (8, 3): object $10
	db $39, $16  ; (9, 3): object $16
	db $42, $6e  ; (2, 4): object $6E
	db $82, $43, $d3  ; 2 across from (3, 4): object $D3
	db $46, $18  ; (6, 4): object $18
	db $83, $47, $0f  ; 3 across from (7, 4): object $0F
	db $52, $d4  ; (2, 5): object $D4
	db $53, $0a  ; (3, 5): object $0A
	db $84, $54, $e8  ; 4 across from (4, 5): object $E8
	db $82, $58, $0a  ; 2 across from (8, 5): object $0A
	db $59, $6e  ; (9, 5): object $6E
	db $84, $61, $0a  ; 4 across from (1, 6): object $0A
	db $62, $20  ; (2, 6): object $20
	db $84, $64, $e8  ; 4 across from (4, 6): object $E8
	db $68, $d3  ; (8, 6): object $D3
	db $69, $0a  ; (9, 6): object $0A
	db $40, $f5  ; (0, 4): object $F5
	db $44, $6e  ; (4, 4): object $6E
	db $45, $6e  ; (5, 4): object $6E
	db $53, $20  ; (3, 5): object $20
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D5 (row D, column 5 of the 16 x 16 map): 37 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomD5::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $70, $2f  ; 10 across from (0, 7): object $2F
	db $79, $3c  ; (9, 7): object $3C
	db $c2, $00, $11  ; 2 down from (0, 0): object $11
	db $82, $01, $1b  ; 2 across from (1, 0): object $1B
	db $03, $12  ; (3, 0): object $12
	db $c2, $05, $11  ; 2 down from (5, 0): object $11
	db $83, $06, $0a  ; 3 across from (6, 0): object $0A
	db $c3, $f9, $f5  ; 3 down from (9, 15): object $F5
	db $11, $1b  ; (1, 1): object $1B
	db $12, $1a  ; (2, 1): object $1A
	db $13, $16  ; (3, 1): object $16
	db $14, $6e  ; (4, 1): object $6E
	db $83, $16, $0a  ; 3 across from (6, 1): object $0A
	db $20, $15  ; (0, 2): object $15
	db $21, $10  ; (1, 2): object $10
	db $22, $16  ; (2, 2): object $16
	db $23, $13  ; (3, 2): object $13
	db $24, $0f  ; (4, 2): object $0F
	db $25, $17  ; (5, 2): object $17
	db $26, $d4  ; (6, 2): object $D4
	db $82, $27, $0a  ; 2 across from (7, 2): object $0A
	db $31, $44  ; (1, 3): object $44
	db $32, $d4  ; (2, 3): object $D4
	db $33, $11  ; (3, 3): object $11
	db $82, $34, $0a  ; 2 across from (4, 3): object $0A
	db $36, $20  ; (6, 3): object $20
	db $37, $d4  ; (7, 3): object $D4
	db $38, $0a  ; (8, 3): object $0A
	db $83, $40, $0f  ; 3 across from (0, 4): object $0F
	db $43, $17  ; (3, 4): object $17
	db $85, $44, $0a  ; 5 across from (4, 4): object $0A
	db $89, $50, $0a  ; 9 across from (0, 5): object $0A
	db $54, $d4  ; (4, 5): object $D4
	db $89, $60, $0a  ; 9 across from (0, 6): object $0A
	db $c2, $38, $04  ; 2 down from (8, 3): object $04
	db $58, $f5  ; (8, 5): object $F5
	db $50, $6e  ; (0, 5): object $6E
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D6 (row D, column 6 of the 16 x 16 map): 24 objects on floor object $04; a warp (type 1) to map $10 room $C7 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomD6::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $ff, $f5  ; 3 down from (15, 15): object $F5
	db $c5, $01, $0a  ; 5 down from (1, 0): object $0A
	db $88, $02, $d3  ; 8 across from (2, 0): object $D3
	db $06, $0a  ; (6, 0): object $0A
	db $82, $12, $d3  ; 2 across from (2, 1): object $D3
	db $85, $14, $5c  ; 5 across from (4, 1): object $5C
	db $19, $0a  ; (9, 1): object $0A
	db $88, $22, $d3  ; 8 across from (2, 2): object $D3
	db $26, $5c  ; (6, 2): object $5C
	db $32, $d3  ; (2, 3): object $D3
	db $83, $36, $5c  ; 3 across from (6, 3): object $5C
	db $39, $0a  ; (9, 3): object $0A
	db $84, $46, $6e  ; 4 across from (6, 4): object $6E
	db $47, $d4  ; (7, 4): object $D4
	db $50, $f5  ; (0, 5): object $F5
	db $52, $0a  ; (2, 5): object $0A
	db $59, $6e  ; (9, 5): object $6E
	db $83, $62, $0a  ; 3 across from (2, 6): object $0A
	db $65, $d3  ; (5, 6): object $D3
	db $66, $f5  ; (6, 6): object $F5
	db $83, $70, $f5  ; 3 across from (0, 7): object $F5
	db $78, $f5  ; (8, 7): object $F5
	db $c4, $02, $6e  ; 4 down from (2, 0): object $6E
	db $33, $fd  ; (3, 3): object $FD
	db $e1, $10, $c7, $50, $7c  ; warp type 1 to map $10 room $C7, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D7 (row D, column 7 of the 16 x 16 map): 26 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomD7::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $00, $d3  ; 6 across from (0, 0): object $D3
	db $01, $0a  ; (1, 0): object $0A
	db $04, $0a  ; (4, 0): object $0A
	db $06, $0a  ; (6, 0): object $0A
	db $c4, $07, $6e  ; 4 down from (7, 0): object $6E
	db $10, $0a  ; (0, 1): object $0A
	db $86, $11, $5c  ; 6 across from (1, 1): object $5C
	db $13, $d3  ; (3, 1): object $D3
	db $c2, $15, $d3  ; 2 down from (5, 1): object $D3
	db $82, $20, $d3  ; 2 across from (0, 2): object $D3
	db $83, $22, $5c  ; 3 across from (2, 2): object $5C
	db $c2, $26, $5c  ; 2 down from (6, 2): object $5C
	db $30, $0a  ; (0, 3): object $0A
	db $31, $5c  ; (1, 3): object $5C
	db $83, $32, $d3  ; 3 across from (2, 3): object $D3
	db $82, $35, $5c  ; 2 across from (5, 3): object $5C
	db $40, $d3  ; (0, 4): object $D3
	db $85, $41, $5c  ; 5 across from (1, 4): object $5C
	db $46, $6e  ; (6, 4): object $6E
	db $86, $50, $6e  ; 6 across from (0, 5): object $6E
	db $c5, $09, $37  ; 5 down from (9, 0): object $37
	db $59, $2e  ; (9, 5): object $2E
	db $69, $39  ; (9, 6): object $39
	db $85, $70, $f5  ; 5 across from (0, 7): object $F5
	db $67, $f5  ; (7, 6): object $F5
	db $53, $d4  ; (3, 5): object $D4
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D8 (row D, column 8 of the 16 x 16 map): 19 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomD8::
	db $03, $04  ; animated tiles $03, floor $04
	db $c5, $00, $38  ; 5 down from (0, 0): object $38
	db $50, $4e  ; (0, 5): object $4E
	db $60, $3b  ; (0, 6): object $3B
	db $70, $f5  ; (0, 7): object $F5
	db $c5, $01, $0a  ; 5 down from (1, 0): object $0A
	db $c4, $07, $38  ; 4 down from (7, 0): object $38
	db $43, $3d  ; (3, 4): object $3D
	db $83, $54, $3a  ; 3 across from (4, 5): object $3A
	db $44, $48  ; (4, 4): object $48
	db $c2, $45, $e0  ; 2 down from (5, 4): object $E0
	db $46, $49  ; (6, 4): object $49
	db $57, $3b  ; (7, 5): object $3B
	db $c3, $53, $38  ; 3 down from (3, 5): object $38
	db $c8, $08, $0e  ; 8 down from (8, 0): object $0E
	db $c8, $09, $0e  ; 8 down from (9, 0): object $0E
	db $84, $64, $0e  ; 4 across from (4, 6): object $0E
	db $84, $74, $0e  ; 4 across from (4, 7): object $0E
	db $47, $4e  ; (7, 4): object $4E
	db $08, $3b  ; (8, 0): object $3B
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $D9 (row D, column 9 of the 16 x 16 map): 13 objects on floor object $0E; a warp (type 1) to map $04 room $A1 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomD9::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $13, $ca  ; (3, 1): object $CA
	db $c2, $22, $51  ; 2 down from (2, 2): object $51
	db $42, $51  ; (2, 4): object $51
	db $53, $51  ; (3, 5): object $51
	db $83, $61, $ca  ; 3 across from (1, 6): object $CA
	db $84, $64, $51  ; 4 across from (4, 6): object $51
	db $65, $ca  ; (5, 6): object $CA
	db $57, $ca  ; (7, 5): object $CA
	db $28, $ca  ; (8, 2): object $CA
	db $c3, $38, $51  ; 3 down from (8, 3): object $51
	db $84, $14, $51  ; 4 across from (4, 1): object $51
	db $41, $ca  ; (1, 4): object $CA
	db $24, $f8  ; (4, 2): object $F8
	db $e1, $04, $a1, $50, $7c  ; warp type 1 to map $04 room $A1, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $DA (row D, column A of the 16 x 16 map): 26 objects on floor object $0E. Format: see OverworldRoomPointers.
OverworldRoomDA::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $07, $37  ; (7, 0): object $37
	db $82, $08, $04  ; 2 across from (8, 0): object $04
	db $82, $33, $04  ; 2 across from (3, 3): object $04
	db $84, $43, $04  ; 4 across from (3, 4): object $04
	db $66, $04  ; (6, 6): object $04
	db $83, $74, $04  ; 3 across from (4, 7): object $04
	db $f9, $f5  ; (9, 15): object $F5
	db $17, $33  ; (7, 1): object $33
	db $18, $e0  ; (8, 1): object $E0
	db $19, $2f  ; (9, 1): object $2F
	db $22, $2b  ; (2, 2): object $2B
	db $82, $23, $2c  ; 2 across from (3, 2): object $2C
	db $25, $2d  ; (5, 2): object $2D
	db $c2, $32, $37  ; 2 down from (2, 3): object $37
	db $35, $32  ; (5, 3): object $32
	db $36, $2c  ; (6, 3): object $2C
	db $37, $2d  ; (7, 3): object $2D
	db $46, $04  ; (6, 4): object $04
	db $c4, $47, $38  ; 4 down from (7, 4): object $38
	db $52, $33  ; (2, 5): object $33
	db $53, $3c  ; (3, 5): object $3C
	db $83, $54, $04  ; 3 across from (4, 5): object $04
	db $c2, $63, $37  ; 2 down from (3, 6): object $37
	db $82, $64, $04  ; 2 across from (4, 6): object $04
	db $76, $44  ; (6, 7): object $44
	db $34, $6f  ; (4, 3): object $6F
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $DB (row D, column B of the 16 x 16 map): 24 objects on floor object $04; a warp (type 1) to map $10 room $E3 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomDB::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $0e  ; 8 down from (0, 0): object $0E
	db $c8, $01, $37  ; 8 down from (1, 0): object $37
	db $01, $04  ; (1, 0): object $04
	db $c2, $02, $0a  ; 2 down from (2, 0): object $0A
	db $42, $44  ; (2, 4): object $44
	db $c3, $52, $0a  ; 3 down from (2, 5): object $0A
	db $68, $3d  ; (8, 6): object $3D
	db $69, $2f  ; (9, 6): object $2F
	db $78, $38  ; (8, 7): object $38
	db $79, $0e  ; (9, 7): object $0E
	db $c3, $08, $f5  ; 3 down from (8, 0): object $F5
	db $82, $26, $0a  ; 2 across from (6, 2): object $0A
	db $c2, $35, $0a  ; 2 down from (5, 3): object $0A
	db $82, $56, $0a  ; 2 across from (6, 5): object $0A
	db $36, $f5  ; (6, 3): object $F5
	db $37, $f5  ; (7, 3): object $F5
	db $37, $45  ; (7, 3): object $45
	db $47, $e1  ; (7, 4): object $E1
	db $64, $44  ; (4, 6): object $44
	db $16, $44  ; (6, 1): object $44
	db $c2, $62, $0a  ; 2 down from (2, 6): object $0A
	db $e1, $10, $e3, $50, $7c  ; warp type 1 to map $10 room $E3, x 80 y 124
	db $ff, $f5  ; (15, 15): object $F5
	db $10, $2f  ; (0, 1): object $2F
	db $11, $3c  ; (1, 1): object $3C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $DC (row D, column C of the 16 x 16 map): 19 objects on floor object $0A. Format: see OverworldRoomPointers.
OverworldRoomDC::
	db $03, $0a  ; animated tiles $03, floor $0A
	db $85, $13, $04  ; 5 across from (3, 1): object $04
	db $87, $22, $04  ; 7 across from (2, 2): object $04
	db $87, $32, $04  ; 7 across from (2, 3): object $04
	db $87, $42, $04  ; 7 across from (2, 4): object $04
	db $51, $04  ; (1, 5): object $04
	db $85, $53, $04  ; 5 across from (3, 5): object $04
	db $87, $73, $04  ; 7 across from (3, 7): object $04
	db $23, $44  ; (3, 2): object $44
	db $38, $44  ; (8, 3): object $44
	db $46, $44  ; (6, 4): object $44
	db $55, $44  ; (5, 5): object $44
	db $51, $62  ; (1, 5): object $62
	db $c6, $00, $62  ; 6 down from (0, 0): object $62
	db $84, $66, $62  ; 4 across from (6, 6): object $62
	db $82, $60, $2f  ; 2 across from (0, 6): object $2F
	db $62, $3c  ; (2, 6): object $3C
	db $82, $70, $0e  ; 2 across from (0, 7): object $0E
	db $72, $37  ; (2, 7): object $37
	db $83, $74, $f5  ; 3 across from (4, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $DD (row D, column D of the 16 x 16 map): 27 objects on floor object $04; a warp (type 1) to map $10 room $D7 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomDD::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $09, $37  ; 3 down from (9, 0): object $37
	db $39, $2e  ; (9, 3): object $2E
	db $49, $39  ; (9, 4): object $39
	db $86, $00, $0a  ; 6 across from (0, 0): object $0A
	db $84, $10, $0a  ; 4 across from (0, 1): object $0A
	db $82, $20, $0a  ; 2 across from (0, 2): object $0A
	db $82, $30, $0a  ; 2 across from (0, 3): object $0A
	db $82, $40, $0a  ; 2 across from (0, 4): object $0A
	db $82, $70, $0a  ; 2 across from (0, 7): object $0A
	db $06, $0c  ; (6, 0): object $0C
	db $c4, $07, $62  ; 4 down from (7, 0): object $62
	db $14, $f7  ; (4, 1): object $F7
	db $e1, $10, $d7, $50, $7c  ; warp type 1 to map $10 room $D7, x 80 y 124
	db $82, $22, $5c  ; 2 across from (2, 2): object $5C
	db $32, $5c  ; (2, 3): object $5C
	db $33, $61  ; (3, 3): object $61
	db $84, $42, $0c  ; 4 across from (2, 4): object $0C
	db $85, $60, $62  ; 5 across from (0, 6): object $62
	db $c3, $52, $0c  ; 3 down from (2, 5): object $0C
	db $46, $62  ; (6, 4): object $62
	db $53, $0a  ; (3, 5): object $0A
	db $83, $54, $62  ; 3 across from (4, 5): object $62
	db $48, $44  ; (8, 4): object $44
	db $58, $f5  ; (8, 5): object $F5
	db $73, $f5  ; (3, 7): object $F5
	db $82, $76, $f5  ; 2 across from (6, 7): object $F5
	db $82, $70, $04  ; 2 across from (0, 7): object $04
	db $70, $f5  ; (0, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $DE (row D, column E of the 16 x 16 map): 29 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomDE::
	db $08, $08  ; animated tiles $08, floor $08
	db $c8, $00, $37  ; 8 down from (0, 0): object $37
	db $00, $36  ; (0, 0): object $36
	db $82, $01, $2f  ; 2 across from (1, 0): object $2F
	db $03, $34  ; (3, 0): object $34
	db $05, $2e  ; (5, 0): object $2E
	db $84, $06, $2f  ; 4 across from (6, 0): object $2F
	db $15, $39  ; (5, 1): object $39
	db $84, $16, $3a  ; 4 across from (6, 1): object $3A
	db $10, $b6  ; (0, 1): object $B6
	db $20, $b7  ; (0, 2): object $B7
	db $30, $3c  ; (0, 3): object $3C
	db $c5, $31, $03  ; 5 down from (1, 3): object $03
	db $82, $62, $03  ; 2 across from (2, 6): object $03
	db $82, $72, $03  ; 2 across from (2, 7): object $03
	db $63, $09  ; (3, 6): object $09
	db $22, $3d  ; (2, 2): object $3D
	db $23, $35  ; (3, 2): object $35
	db $c2, $32, $38  ; 2 down from (2, 3): object $38
	db $52, $32  ; (2, 5): object $32
	db $53, $2c  ; (3, 5): object $2C
	db $54, $2d  ; (4, 5): object $2D
	db $c2, $64, $38  ; 2 down from (4, 6): object $38
	db $76, $2b  ; (6, 7): object $2B
	db $82, $77, $2c  ; 2 across from (7, 7): object $2C
	db $79, $31  ; (9, 7): object $31
	db $69, $37  ; (9, 6): object $37
	db $59, $2b  ; (9, 5): object $2B
	db $26, $69  ; (6, 2): object $69
	db $43, $69  ; (3, 4): object $69
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $DF (row D, column F of the 16 x 16 map): 21 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomDF::
	db $03, $08  ; animated tiles $03, floor $08
	db $00, $4e  ; (0, 0): object $4E
	db $06, $33  ; (6, 0): object $33
	db $07, $2f  ; (7, 0): object $2F
	db $08, $35  ; (8, 0): object $35
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $10, $3b  ; (0, 1): object $3B
	db $45, $36  ; (5, 4): object $36
	db $46, $2f  ; (6, 4): object $2F
	db $47, $3c  ; (7, 4): object $3C
	db $50, $2d  ; (0, 5): object $2D
	db $c2, $57, $37  ; 2 down from (7, 5): object $37
	db $60, $38  ; (0, 6): object $38
	db $70, $32  ; (0, 7): object $32
	db $86, $71, $2c  ; 6 across from (1, 7): object $2C
	db $77, $31  ; (7, 7): object $31
	db $c3, $58, $03  ; 3 down from (8, 5): object $03
	db $82, $02, $69  ; 2 across from (2, 0): object $69
	db $13, $69  ; (3, 1): object $69
	db $24, $69  ; (4, 2): object $69
	db $35, $69  ; (5, 3): object $69
	db $66, $c8  ; (6, 6): object $C8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E0 (row E, column 0 of the 16 x 16 map): 14 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomE0::
	db $02, $03  ; animated tiles $02, floor $03
	db $c8, $00, $37  ; 8 down from (0, 0): object $37
	db $85, $05, $3a  ; 5 across from (5, 0): object $3A
	db $04, $39  ; (4, 0): object $39
	db $34, $fb  ; (4, 3): object $FB
	db $39, $fb  ; (9, 3): object $FB
	db $36, $fb  ; (6, 3): object $FB
	db $59, $fb  ; (9, 5): object $FB
	db $82, $67, $5c  ; 2 across from (7, 6): object $5C
	db $65, $5c  ; (5, 6): object $5C
	db $86, $74, $2f  ; 6 across from (4, 7): object $2F
	db $73, $3d  ; (3, 7): object $3D
	db $75, $48  ; (5, 7): object $48
	db $76, $e0  ; (6, 7): object $E0
	db $77, $49  ; (7, 7): object $49
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E1 (row E, column 1 of the 16 x 16 map): 22 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomE1::
	db $02, $03  ; animated tiles $02, floor $03
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $83, $15, $5c  ; 3 across from (5, 1): object $5C
	db $18, $fb  ; (8, 1): object $FB
	db $2f, $fb  ; (15, 2): object $FB
	db $4f, $fb  ; (15, 4): object $FB
	db $82, $61, $5c  ; 2 across from (1, 6): object $5C
	db $83, $70, $2f  ; 3 across from (0, 7): object $2F
	db $73, $4e  ; (3, 7): object $4E
	db $c2, $53, $38  ; 2 down from (3, 5): object $38
	db $43, $3d  ; (3, 4): object $3D
	db $44, $2f  ; (4, 4): object $2F
	db $45, $35  ; (5, 4): object $35
	db $48, $36  ; (8, 4): object $36
	db $49, $2f  ; (9, 4): object $2F
	db $86, $54, $08  ; 6 across from (4, 5): object $08
	db $86, $64, $08  ; 6 across from (4, 6): object $08
	db $86, $74, $08  ; 6 across from (4, 7): object $08
	db $12, $5c  ; (2, 1): object $5C
	db $66, $24  ; (6, 6): object $24
	db $78, $2b  ; (8, 7): object $2B
	db $79, $2c  ; (9, 7): object $2C
	db $12, $d4  ; (2, 1): object $D4
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E2 (row E, column 2 of the 16 x 16 map): 16 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomE2::
	db $02, $03  ; animated tiles $02, floor $03
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $10, $fb  ; (0, 1): object $FB
	db $18, $fb  ; (8, 1): object $FB
	db $58, $fb  ; (8, 5): object $FB
	db $87, $40, $2f  ; 7 across from (0, 4): object $2F
	db $47, $3c  ; (7, 4): object $3C
	db $c2, $57, $37  ; 2 down from (7, 5): object $37
	db $77, $2e  ; (7, 7): object $2E
	db $78, $3c  ; (8, 7): object $3C
	db $70, $2c  ; (0, 7): object $2C
	db $71, $2d  ; (1, 7): object $2D
	db $87, $50, $08  ; 7 across from (0, 5): object $08
	db $87, $60, $08  ; 7 across from (0, 6): object $08
	db $85, $72, $08  ; 5 across from (2, 7): object $08
	db $52, $24  ; (2, 5): object $24
	db $64, $24  ; (4, 6): object $24
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E3 (row E, column 3 of the 16 x 16 map): 16 objects on floor object $03; a warp (type 1) to map $10 room $FE at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomE3::
	db $02, $03  ; animated tiles $02, floor $03
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $10, $fb  ; (0, 1): object $FB
	db $16, $fb  ; (6, 1): object $FB
	db $18, $fb  ; (8, 1): object $FB
	db $50, $fb  ; (0, 5): object $FB
	db $56, $fb  ; (6, 5): object $FB
	db $58, $fb  ; (8, 5): object $FB
	db $70, $2f  ; (0, 7): object $2F
	db $72, $48  ; (2, 7): object $48
	db $83, $73, $4a  ; 3 across from (3, 7): object $4A
	db $76, $49  ; (6, 7): object $49
	db $83, $77, $2f  ; 3 across from (7, 7): object $2F
	db $c2, $32, $5c  ; 2 down from (2, 3): object $5C
	db $70, $03  ; (0, 7): object $03
	db $71, $3d  ; (1, 7): object $3D
	db $13, $fd  ; (3, 1): object $FD
	db $e1, $10, $fe, $50, $7c  ; warp type 1 to map $10 room $FE, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E4 (row E, column 4 of the 16 x 16 map): 17 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomE4::
	db $02, $08  ; animated tiles $02, floor $08
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $c6, $10, $03  ; 6 down from (0, 1): object $03
	db $c6, $11, $03  ; 6 down from (1, 1): object $03
	db $c3, $32, $5c  ; 3 down from (2, 3): object $5C
	db $82, $70, $2f  ; 2 across from (0, 7): object $2F
	db $72, $4e  ; (2, 7): object $4E
	db $62, $38  ; (2, 6): object $38
	db $52, $3d  ; (2, 5): object $3D
	db $53, $35  ; (3, 5): object $35
	db $38, $24  ; (8, 3): object $24
	db $64, $24  ; (4, 6): object $24
	db $10, $fb  ; (0, 1): object $FB
	db $12, $fb  ; (2, 1): object $FB
	db $14, $fb  ; (4, 1): object $FB
	db $50, $fb  ; (0, 5): object $FB
	db $69, $2b  ; (9, 6): object $2B
	db $79, $37  ; (9, 7): object $37
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E5 (row E, column 5 of the 16 x 16 map): 24 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomE5::
	db $02, $08  ; animated tiles $02, floor $08
	db $89, $00, $3a  ; 9 across from (0, 0): object $3A
	db $09, $37  ; (9, 0): object $37
	db $15, $24  ; (5, 1): object $24
	db $19, $2e  ; (9, 1): object $2E
	db $23, $c8  ; (3, 2): object $C8
	db $27, $a0  ; (7, 2): object $A0
	db $28, $20  ; (8, 2): object $20
	db $29, $39  ; (9, 2): object $39
	db $31, $24  ; (1, 3): object $24
	db $36, $c8  ; (6, 3): object $C8
	db $c2, $37, $20  ; 2 down from (7, 3): object $20
	db $c3, $38, $04  ; 3 down from (8, 3): object $04
	db $c3, $39, $04  ; 3 down from (9, 3): object $04
	db $52, $c8  ; (2, 5): object $C8
	db $56, $36  ; (6, 5): object $36
	db $57, $3c  ; (7, 5): object $3C
	db $60, $2d  ; (0, 6): object $2D
	db $67, $33  ; (7, 6): object $33
	db $68, $2f  ; (8, 6): object $2F
	db $69, $3c  ; (9, 6): object $3C
	db $70, $32  ; (0, 7): object $32
	db $83, $71, $2c  ; 3 across from (1, 7): object $2C
	db $74, $2d  ; (4, 7): object $2D
	db $79, $37  ; (9, 7): object $37
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E6 (row E, column 6 of the 16 x 16 map): 22 objects on floor object $04; a warp (type 1) to map $1F room $E0 at x 136, y 112. Format: see OverworldRoomPointers.
OverworldRoomE6::
	db $03, $04  ; animated tiles $03, floor $04
	db $85, $f0, $f5  ; 5 across from (0, 15): object $F5
	db $06, $3d  ; (6, 0): object $3D
	db $07, $35  ; (7, 0): object $35
	db $86, $10, $2f  ; 6 across from (0, 1): object $2F
	db $16, $4e  ; (6, 1): object $4E
	db $83, $17, $0a  ; 3 across from (7, 1): object $0A
	db $86, $20, $3a  ; 6 across from (0, 2): object $3A
	db $34, $c6  ; (4, 3): object $C6
	db $e1, $1f, $e0, $88, $70  ; warp type 1 to map $1F room $E0, x 136 y 112
	db $26, $3b  ; (6, 2): object $3B
	db $83, $27, $0a  ; 3 across from (7, 2): object $0A
	db $32, $f5  ; (2, 3): object $F5
	db $83, $35, $0a  ; 3 across from (5, 3): object $0A
	db $38, $f5  ; (8, 3): object $F5
	db $82, $44, $f5  ; 2 across from (4, 4): object $F5
	db $c2, $49, $f5  ; 2 down from (9, 4): object $F5
	db $60, $3d  ; (0, 6): object $3D
	db $61, $2f  ; (1, 6): object $2F
	db $62, $3c  ; (2, 6): object $3C
	db $70, $38  ; (0, 7): object $38
	db $71, $3a  ; (1, 7): object $3A
	db $72, $2e  ; (2, 7): object $2E
	db $73, $3c  ; (3, 7): object $3C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E7 (row E, column 7 of the 16 x 16 map): 17 objects on floor object $04; a warp (type 1) to map $1F room $E5 at x 40, y 48. Format: see OverworldRoomPointers.
OverworldRoomE7::
	db $03, $04  ; animated tiles $03, floor $04
	db $85, $f0, $f5  ; 5 across from (0, 15): object $F5
	db $07, $f5  ; (7, 0): object $F5
	db $26, $f5  ; (6, 2): object $F5
	db $82, $30, $f5  ; 2 across from (0, 3): object $F5
	db $35, $f5  ; (5, 3): object $F5
	db $43, $f5  ; (3, 4): object $F5
	db $86, $10, $0a  ; 6 across from (0, 1): object $0A
	db $86, $20, $0a  ; 6 across from (0, 2): object $0A
	db $34, $0a  ; (4, 3): object $0A
	db $16, $c6  ; (6, 1): object $C6
	db $e1, $1f, $e5, $28, $30  ; warp type 1 to map $1F room $E5, x 40 y 48
	db $57, $e8  ; (7, 5): object $E8
	db $77, $04  ; (7, 7): object $04
	db $c2, $4f, $f5  ; 2 down from (15, 4): object $F5
	db $29, $44  ; (9, 2): object $44
	db $55, $44  ; (5, 5): object $44
	db $78, $44  ; (8, 7): object $44
	db $83, $71, $f5  ; 3 across from (1, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E8 (row E, column 8 of the 16 x 16 map): 21 objects on floor object $04; a warp (type 1) to map $10 room $9D at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomE8::
	db $03, $04  ; animated tiles $03, floor $04
	db $86, $04, $0e  ; 6 across from (4, 0): object $0E
	db $86, $14, $0e  ; 6 across from (4, 1): object $0E
	db $c3, $28, $0e  ; 3 down from (8, 2): object $0E
	db $c3, $29, $0e  ; 3 down from (9, 2): object $0E
	db $c2, $03, $38  ; 2 down from (3, 0): object $38
	db $23, $32  ; (3, 2): object $32
	db $83, $24, $2c  ; 3 across from (4, 2): object $2C
	db $27, $2d  ; (7, 2): object $2D
	db $c2, $37, $38  ; 2 down from (7, 3): object $38
	db $57, $32  ; (7, 5): object $32
	db $82, $58, $2c  ; 2 across from (8, 5): object $2C
	db $f0, $f5  ; (0, 15): object $F5
	db $36, $09  ; (6, 3): object $09
	db $64, $09  ; (4, 6): object $09
	db $50, $03  ; (0, 5): object $03
	db $83, $60, $03  ; 3 across from (0, 6): object $03
	db $86, $70, $03  ; 6 across from (0, 7): object $03
	db $42, $f5  ; (2, 4): object $F5
	db $43, $f5  ; (3, 4): object $F5
	db $43, $45  ; (3, 4): object $45
	db $53, $e1  ; (3, 5): object $E1
	db $e1, $10, $9d, $50, $7c  ; warp type 1 to map $10 room $9D, x 80 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $E9 (row E, column 9 of the 16 x 16 map): 34 objects on floor object $0E; a warp (type 1) to map $0A room $98 at x 104, y 96. Format: see OverworldRoomPointers.
OverworldRoomE9::
	db $03, $0e  ; animated tiles $03, floor $0E
	db $39, $04  ; (9, 3): object $04
	db $70, $04  ; (0, 7): object $04
	db $84, $46, $04  ; 4 across from (6, 4): object $04
	db $82, $58, $04  ; 2 across from (8, 5): object $04
	db $14, $2b  ; (4, 1): object $2B
	db $85, $15, $2c  ; 5 across from (5, 1): object $2C
	db $23, $ca  ; (3, 2): object $CA
	db $24, $37  ; (4, 2): object $37
	db $85, $25, $04  ; 5 across from (5, 2): object $04
	db $83, $36, $04  ; 3 across from (6, 3): object $04
	db $34, $33  ; (4, 3): object $33
	db $35, $3c  ; (5, 3): object $3C
	db $42, $ca  ; (2, 4): object $CA
	db $45, $37  ; (5, 4): object $37
	db $55, $33  ; (5, 5): object $33
	db $56, $2f  ; (6, 5): object $2F
	db $57, $3c  ; (7, 5): object $3C
	db $67, $33  ; (7, 6): object $33
	db $82, $68, $2f  ; 2 across from (8, 6): object $2F
	db $83, $50, $2c  ; 3 across from (0, 5): object $2C
	db $53, $2d  ; (3, 5): object $2D
	db $55, $33  ; (5, 5): object $33
	db $56, $2f  ; (6, 5): object $2F
	db $57, $3c  ; (7, 5): object $3C
	db $82, $60, $0a  ; 2 across from (0, 6): object $0A
	db $62, $5c  ; (2, 6): object $5C
	db $c2, $63, $38  ; 2 down from (3, 6): object $38
	db $67, $33  ; (7, 6): object $33
	db $82, $68, $2f  ; 2 across from (8, 6): object $2F
	db $82, $71, $0a  ; 2 across from (1, 7): object $0A
	db $83, $77, $ca  ; 3 across from (7, 7): object $CA
	db $82, $46, $04  ; 2 across from (6, 4): object $04
	db $48, $44  ; (8, 4): object $44
	db $26, $c6  ; (6, 2): object $C6
	db $e1, $0a, $98, $68, $60  ; warp type 1 to map $0A room $98, x 104 y 96
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $EA (row E, column A of the 16 x 16 map): 37 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomEA::
	db $03, $04  ; animated tiles $03, floor $04
	db $8a, $00, $0e  ; 10 across from (0, 0): object $0E
	db $8a, $10, $0e  ; 10 across from (0, 1): object $0E
	db $87, $23, $0e  ; 7 across from (3, 2): object $0E
	db $85, $33, $0e  ; 5 across from (3, 3): object $0E
	db $83, $44, $0e  ; 3 across from (4, 4): object $0E
	db $83, $04, $04  ; 3 across from (4, 0): object $04
	db $03, $37  ; (3, 0): object $37
	db $07, $38  ; (7, 0): object $38
	db $82, $10, $2c  ; 2 across from (0, 1): object $2C
	db $12, $2d  ; (2, 1): object $2D
	db $13, $33  ; (3, 1): object $33
	db $83, $14, $2f  ; 3 across from (4, 1): object $2F
	db $17, $34  ; (7, 1): object $34
	db $22, $38  ; (2, 2): object $38
	db $c2, $24, $ca  ; 2 down from (4, 2): object $CA
	db $c2, $36, $ca  ; 2 down from (6, 3): object $CA
	db $38, $2b  ; (8, 3): object $2B
	db $39, $2c  ; (9, 3): object $2C
	db $32, $32  ; (2, 3): object $32
	db $33, $2d  ; (3, 3): object $2D
	db $43, $32  ; (3, 4): object $32
	db $44, $2d  ; (4, 4): object $2D
	db $47, $2b  ; (7, 4): object $2B
	db $48, $31  ; (8, 4): object $31
	db $54, $32  ; (4, 5): object $32
	db $82, $55, $2c  ; 2 across from (5, 5): object $2C
	db $57, $31  ; (7, 5): object $31
	db $60, $3c  ; (0, 6): object $3C
	db $70, $37  ; (0, 7): object $37
	db $79, $f5  ; (9, 7): object $F5
	db $04, $44  ; (4, 0): object $44
	db $21, $44  ; (1, 2): object $44
	db $40, $44  ; (0, 4): object $44
	db $67, $44  ; (7, 6): object $44
	db $c5, $15, $db  ; 5 down from (5, 1): object $DB
	db $52, $f5  ; (2, 5): object $F5
	db $73, $f5  ; (3, 7): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $EB (row E, column B of the 16 x 16 map): 16 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomEB::
	db $03, $04  ; animated tiles $03, floor $04
	db $c3, $00, $0e  ; 3 down from (0, 0): object $0E
	db $c7, $08, $38  ; 7 down from (8, 0): object $38
	db $77, $3d  ; (7, 7): object $3D
	db $78, $34  ; (8, 7): object $34
	db $c8, $09, $0e  ; 8 down from (9, 0): object $0E
	db $82, $7f, $f5  ; 2 across from (15, 7): object $F5
	db $52, $f5  ; (2, 5): object $F5
	db $07, $44  ; (7, 0): object $44
	db $13, $44  ; (3, 1): object $44
	db $34, $44  ; (4, 3): object $44
	db $46, $44  ; (6, 4): object $44
	db $60, $44  ; (0, 6): object $44
	db $73, $44  ; (3, 7): object $44
	db $c3, $01, $37  ; 3 down from (1, 0): object $37
	db $30, $2c  ; (0, 3): object $2C
	db $31, $31  ; (1, 3): object $31
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $EC (row E, column C of the 16 x 16 map): 28 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomEC::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $0e  ; 8 down from (0, 0): object $0E
	db $c3, $01, $0e  ; 3 down from (1, 0): object $0E
	db $c3, $02, $37  ; 3 down from (2, 0): object $37
	db $32, $31  ; (2, 3): object $31
	db $31, $2b  ; (1, 3): object $2B
	db $c4, $41, $37  ; 4 down from (1, 4): object $37
	db $14, $3d  ; (4, 1): object $3D
	db $85, $15, $2f  ; 5 across from (5, 1): object $2F
	db $c5, $24, $38  ; 5 down from (4, 2): object $38
	db $74, $32  ; (4, 7): object $32
	db $86, $75, $2c  ; 6 across from (5, 7): object $2C
	db $85, $25, $1b  ; 5 across from (5, 2): object $1B
	db $85, $35, $1b  ; 5 across from (5, 3): object $1B
	db $85, $45, $1b  ; 5 across from (5, 4): object $1B
	db $85, $55, $1b  ; 5 across from (5, 5): object $1B
	db $85, $65, $1b  ; 5 across from (5, 6): object $1B
	db $35, $2b  ; (5, 3): object $2B
	db $36, $2c  ; (6, 3): object $2C
	db $37, $2d  ; (7, 3): object $2D
	db $45, $37  ; (5, 4): object $37
	db $46, $e8  ; (6, 4): object $E8
	db $47, $38  ; (7, 4): object $38
	db $55, $33  ; (5, 5): object $33
	db $56, $e0  ; (6, 5): object $E0
	db $57, $34  ; (7, 5): object $34
	db $42, $44  ; (2, 4): object $44
	db $63, $44  ; (3, 6): object $44
	db $83, $f4, $f5  ; 3 across from (4, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $ED (row E, column D of the 16 x 16 map): 34 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomED::
	db $03, $04  ; animated tiles $03, floor $04
	db $c2, $f3, $f5  ; 2 down from (3, 15): object $F5
	db $82, $f6, $f5  ; 2 across from (6, 15): object $F5
	db $10, $2f  ; (0, 1): object $2F
	db $11, $3c  ; (1, 1): object $3C
	db $21, $37  ; (1, 2): object $37
	db $31, $33  ; (1, 3): object $33
	db $32, $e0  ; (2, 3): object $E0
	db $33, $3c  ; (3, 3): object $3C
	db $c3, $43, $37  ; 3 down from (3, 4): object $37
	db $83, $70, $2c  ; 3 across from (0, 7): object $2C
	db $73, $31  ; (3, 7): object $31
	db $c2, $20, $1b  ; 2 down from (0, 2): object $1B
	db $83, $40, $1b  ; 3 across from (0, 4): object $1B
	db $83, $50, $1b  ; 3 across from (0, 5): object $1B
	db $83, $60, $1b  ; 3 across from (0, 6): object $1B
	db $18, $2b  ; (8, 1): object $2B
	db $19, $2c  ; (9, 1): object $2C
	db $27, $2b  ; (7, 2): object $2B
	db $28, $31  ; (8, 2): object $31
	db $37, $37  ; (7, 3): object $37
	db $46, $2b  ; (6, 4): object $2B
	db $47, $31  ; (7, 4): object $31
	db $c3, $56, $37  ; 3 down from (6, 5): object $37
	db $29, $03  ; (9, 2): object $03
	db $82, $38, $03  ; 2 across from (8, 3): object $03
	db $82, $48, $03  ; 2 across from (8, 4): object $03
	db $83, $57, $03  ; 3 across from (7, 5): object $03
	db $83, $67, $03  ; 3 across from (7, 6): object $03
	db $83, $77, $03  ; 3 across from (7, 7): object $03
	db $02, $44  ; (2, 0): object $44
	db $17, $44  ; (7, 1): object $44
	db $65, $44  ; (5, 6): object $44
	db $74, $44  ; (4, 7): object $44
	db $f0, $f5  ; (0, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $EE (row E, column E of the 16 x 16 map): 22 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomEE::
	db $03, $08  ; animated tiles $03, floor $08
	db $00, $37  ; (0, 0): object $37
	db $10, $31  ; (0, 1): object $31
	db $c4, $04, $38  ; 4 down from (4, 0): object $38
	db $06, $33  ; (6, 0): object $33
	db $83, $07, $2f  ; 3 across from (7, 0): object $2F
	db $c4, $01, $03  ; 4 down from (1, 0): object $03
	db $c4, $02, $03  ; 4 down from (2, 0): object $03
	db $c4, $03, $03  ; 4 down from (3, 0): object $03
	db $c6, $20, $03  ; 6 down from (0, 2): object $03
	db $31, $3d  ; (1, 3): object $3D
	db $82, $32, $2f  ; 2 across from (2, 3): object $2F
	db $34, $4e  ; (4, 3): object $4E
	db $82, $42, $3a  ; 2 across from (2, 4): object $3A
	db $44, $3b  ; (4, 4): object $3B
	db $c4, $41, $38  ; 4 down from (1, 4): object $38
	db $01, $09  ; (1, 0): object $09
	db $40, $09  ; (0, 4): object $09
	db $19, $b6  ; (9, 1): object $B6
	db $79, $b6  ; (9, 7): object $B6
	db $29, $b7  ; (9, 2): object $B7
	db $57, $c8  ; (7, 5): object $C8
	db $63, $c8  ; (3, 6): object $C8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $EF (row E, column F of the 16 x 16 map): 10 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomEF::
	db $03, $08  ; animated tiles $03, floor $08
	db $87, $00, $2f  ; 7 across from (0, 0): object $2F
	db $07, $3c  ; (7, 0): object $3C
	db $c7, $17, $37  ; 7 down from (7, 1): object $37
	db $c8, $08, $03  ; 8 down from (8, 0): object $03
	db $c8, $09, $38  ; 8 down from (9, 0): object $38
	db $10, $b6  ; (0, 1): object $B6
	db $20, $b7  ; (0, 2): object $B7
	db $34, $69  ; (4, 3): object $69
	db $70, $b6  ; (0, 7): object $B6
	db $83, $74, $b6  ; 3 across from (4, 7): object $B6
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F0 (row F, column 0 of the 16 x 16 map): 24 objects on floor object $03. Format: see OverworldRoomPointers.
OverworldRoomF0::
	db $02, $03  ; animated tiles $02, floor $03
	db $86, $54, $1e  ; 6 across from (4, 5): object $1E
	db $8a, $60, $1f  ; 10 across from (0, 6): object $1F
	db $8a, $70, $1f  ; 10 across from (0, 7): object $1F
	db $50, $1f  ; (0, 5): object $1F
	db $c3, $00, $37  ; 3 down from (0, 0): object $37
	db $30, $2e  ; (0, 3): object $2E
	db $40, $39  ; (0, 4): object $39
	db $31, $3c  ; (1, 3): object $3C
	db $41, $37  ; (1, 4): object $37
	db $51, $2e  ; (1, 5): object $2E
	db $61, $39  ; (1, 6): object $39
	db $52, $2f  ; (2, 5): object $2F
	db $62, $3a  ; (2, 6): object $3A
	db $53, $4e  ; (3, 5): object $4E
	db $63, $3b  ; (3, 6): object $3B
	db $c5, $03, $38  ; 5 down from (3, 0): object $38
	db $86, $04, $3a  ; 6 across from (4, 0): object $3A
	db $06, $e0  ; (6, 0): object $E0
	db $86, $14, $08  ; 6 across from (4, 1): object $08
	db $86, $24, $08  ; 6 across from (4, 2): object $08
	db $86, $34, $08  ; 6 across from (4, 3): object $08
	db $86, $44, $08  ; 6 across from (4, 4): object $08
	db $27, $24  ; (7, 2): object $24
	db $46, $c8  ; (6, 4): object $C8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F1 (row F, column 1 of the 16 x 16 map): 21 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomF1::
	db $02, $08  ; animated tiles $02, floor $08
	db $8a, $50, $1e  ; 10 across from (0, 5): object $1E
	db $8a, $60, $1f  ; 10 across from (0, 6): object $1F
	db $8a, $70, $1f  ; 10 across from (0, 7): object $1F
	db $83, $00, $3a  ; 3 across from (0, 0): object $3A
	db $03, $3b  ; (3, 0): object $3B
	db $08, $37  ; (8, 0): object $37
	db $09, $03  ; (9, 0): object $03
	db $18, $2e  ; (8, 1): object $2E
	db $19, $2f  ; (9, 1): object $2F
	db $29, $3a  ; (9, 2): object $3A
	db $28, $39  ; (8, 2): object $39
	db $16, $24  ; (6, 1): object $24
	db $38, $24  ; (8, 3): object $24
	db $41, $24  ; (1, 4): object $24
	db $44, $23  ; (4, 4): object $23
	db $33, $c8  ; (3, 3): object $C8
	db $46, $c8  ; (6, 4): object $C8
	db $49, $2b  ; (9, 4): object $2B
	db $59, $37  ; (9, 5): object $37
	db $69, $2e  ; (9, 6): object $2E
	db $79, $39  ; (9, 7): object $39
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F2 (row F, column 2 of the 16 x 16 map): 29 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomF2::
	db $02, $08  ; animated tiles $02, floor $08
	db $00, $03  ; (0, 0): object $03
	db $01, $38  ; (1, 0): object $38
	db $07, $3e  ; (7, 0): object $3E
	db $08, $2e  ; (8, 0): object $2E
	db $09, $2f  ; (9, 0): object $2F
	db $10, $2f  ; (0, 1): object $2F
	db $11, $4e  ; (1, 1): object $4E
	db $16, $24  ; (6, 1): object $24
	db $17, $39  ; (7, 1): object $39
	db $18, $3e  ; (8, 1): object $3E
	db $c2, $19, $3a  ; 2 down from (9, 1): object $3A
	db $20, $3a  ; (0, 2): object $3A
	db $21, $3b  ; (1, 2): object $3B
	db $28, $39  ; (8, 2): object $39
	db $35, $23  ; (5, 3): object $23
	db $38, $24  ; (8, 3): object $24
	db $40, $2c  ; (0, 4): object $2C
	db $41, $2d  ; (1, 4): object $2D
	db $44, $23  ; (4, 4): object $23
	db $47, $c8  ; (7, 4): object $C8
	db $50, $03  ; (0, 5): object $03
	db $51, $38  ; (1, 5): object $38
	db $88, $52, $1e  ; 8 across from (2, 5): object $1E
	db $60, $2f  ; (0, 6): object $2F
	db $61, $4e  ; (1, 6): object $4E
	db $88, $62, $1f  ; 8 across from (2, 6): object $1F
	db $70, $3a  ; (0, 7): object $3A
	db $71, $3b  ; (1, 7): object $3B
	db $88, $72, $1f  ; 8 across from (2, 7): object $1F
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F3 (row F, column 3 of the 16 x 16 map): 13 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomF3::
	db $02, $08  ; animated tiles $02, floor $08
	db $8a, $00, $3a  ; 10 across from (0, 0): object $3A
	db $8a, $10, $3a  ; 10 across from (0, 1): object $3A
	db $8a, $50, $1e  ; 10 across from (0, 5): object $1E
	db $8a, $60, $1f  ; 10 across from (0, 6): object $1F
	db $8a, $70, $1f  ; 10 across from (0, 7): object $1F
	db $00, $2f  ; (0, 0): object $2F
	db $01, $4e  ; (1, 0): object $4E
	db $c2, $10, $3a  ; 2 down from (0, 1): object $3A
	db $11, $3f  ; (1, 1): object $3F
	db $21, $3b  ; (1, 2): object $3B
	db $23, $24  ; (3, 2): object $24
	db $38, $24  ; (8, 3): object $24
	db $43, $c8  ; (3, 4): object $C8
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F4 (row F, column 4 of the 16 x 16 map): 14 objects on floor object $08; a warp (type 1) to map $1F room $F5 at x 72, y 124. Format: see OverworldRoomPointers.
OverworldRoomF4::
	db $02, $08  ; animated tiles $02, floor $08
	db $8a, $50, $1e  ; 10 across from (0, 5): object $1E
	db $8a, $60, $1f  ; 10 across from (0, 6): object $1F
	db $8a, $70, $1f  ; 10 across from (0, 7): object $1F
	db $82, $00, $3a  ; 2 across from (0, 0): object $3A
	db $82, $10, $3a  ; 2 across from (0, 1): object $3A
	db $02, $3f  ; (2, 0): object $3F
	db $12, $3b  ; (2, 1): object $3B
	db $c6, $09, $37  ; 6 down from (9, 0): object $37
	db $69, $33  ; (9, 6): object $33
	db $15, $24  ; (5, 1): object $24
	db $34, $c8  ; (4, 3): object $C8
	db $38, $24  ; (8, 3): object $24
	db $41, $24  ; (1, 4): object $24
	db $11, $ba  ; (1, 1): object $BA
	db $e1, $1f, $f5, $48, $7c  ; warp type 1 to map $1F room $F5, x 72 y 124
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F5 (row F, column 5 of the 16 x 16 map): 21 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomF5::
	db $02, $08  ; animated tiles $02, floor $08
	db $8a, $50, $1e  ; 10 across from (0, 5): object $1E
	db $8a, $60, $1f  ; 10 across from (0, 6): object $1F
	db $8a, $70, $1f  ; 10 across from (0, 7): object $1F
	db $c2, $00, $03  ; 2 down from (0, 0): object $03
	db $01, $3d  ; (1, 0): object $3D
	db $82, $02, $2f  ; 2 across from (2, 0): object $2F
	db $04, $34  ; (4, 0): object $34
	db $c5, $09, $37  ; 5 down from (9, 0): object $37
	db $11, $38  ; (1, 1): object $38
	db $22, $fb  ; (2, 2): object $FB
	db $15, $24  ; (5, 1): object $24
	db $20, $3d  ; (0, 2): object $3D
	db $21, $4e  ; (1, 2): object $4E
	db $27, $fb  ; (7, 2): object $FB
	db $c3, $30, $38  ; 3 down from (0, 3): object $38
	db $31, $3b  ; (1, 3): object $3B
	db $43, $c8  ; (3, 4): object $C8
	db $59, $2e  ; (9, 5): object $2E
	db $60, $34  ; (0, 6): object $34
	db $69, $3e  ; (9, 6): object $3E
	db $79, $39  ; (9, 7): object $39
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F6 (row F, column 6 of the 16 x 16 map): 32 objects on floor object $04; a warp (type 1) to map $1E room $E3 at x 80, y 124. Format: see OverworldRoomPointers.
OverworldRoomF6::
	db $03, $04  ; animated tiles $03, floor $04
	db $c5, $00, $38  ; 5 down from (0, 0): object $38
	db $c8, $01, $0e  ; 8 down from (1, 0): object $0E
	db $02, $39  ; (2, 0): object $39
	db $c7, $12, $0e  ; 7 down from (2, 1): object $0E
	db $c4, $03, $37  ; 4 down from (3, 0): object $37
	db $09, $f5  ; (9, 0): object $F5
	db $16, $44  ; (6, 1): object $44
	db $34, $44  ; (4, 3): object $44
	db $37, $44  ; (7, 3): object $44
	db $43, $2e  ; (3, 4): object $2E
	db $44, $3c  ; (4, 4): object $3C
	db $49, $44  ; (9, 4): object $44
	db $50, $4e  ; (0, 5): object $4E
	db $53, $39  ; (3, 5): object $39
	db $54, $2e  ; (4, 5): object $2E
	db $55, $2f  ; (5, 5): object $2F
	db $56, $3c  ; (6, 5): object $3C
	db $60, $3f  ; (0, 6): object $3F
	db $c2, $63, $0e  ; 2 down from (3, 6): object $0E
	db $64, $39  ; (4, 6): object $39
	db $65, $3a  ; (5, 6): object $3A
	db $66, $2e  ; (6, 6): object $2E
	db $83, $67, $2f  ; 3 across from (7, 6): object $2F
	db $70, $3b  ; (0, 7): object $3B
	db $85, $71, $0e  ; 5 across from (1, 7): object $0E
	db $76, $39  ; (6, 7): object $39
	db $83, $77, $3a  ; 3 across from (7, 7): object $3A
	db $82, $27, $0a  ; 2 across from (7, 2): object $0A
	db $37, $0a  ; (7, 3): object $0A
	db $24, $fd  ; (4, 2): object $FD
	db $e1, $1e, $e3, $50, $7c  ; warp type 1 to map $1E room $E3, x 80 y 124
	db $82, $45, $0a  ; 2 across from (5, 4): object $0A
	db $82, $14, $0a  ; 2 across from (4, 1): object $0A
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F7 (row F, column 7 of the 16 x 16 map): 18 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomF7::
	db $03, $04  ; animated tiles $03, floor $04
	db $0f, $f5  ; (15, 0): object $F5
	db $18, $f5  ; (8, 1): object $F5
	db $38, $3d  ; (8, 3): object $3D
	db $39, $2f  ; (9, 3): object $2F
	db $c2, $48, $38  ; 2 down from (8, 4): object $38
	db $88, $60, $2f  ; 8 across from (0, 6): object $2F
	db $88, $70, $3a  ; 8 across from (0, 7): object $3A
	db $68, $4e  ; (8, 6): object $4E
	db $78, $3b  ; (8, 7): object $3B
	db $c4, $49, $0e  ; 4 down from (9, 4): object $0E
	db $46, $f5  ; (6, 4): object $F5
	db $07, $44  ; (7, 0): object $44
	db $83, $11, $f5  ; 3 across from (1, 1): object $F5
	db $02, $f5  ; (2, 0): object $F5
	db $04, $f5  ; (4, 0): object $F5
	db $83, $33, $e8  ; 3 across from (3, 3): object $E8
	db $82, $42, $f5  ; 2 across from (2, 4): object $F5
	db $83, $f1, $f5  ; 3 across from (1, 15): object $F5
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F8 (row F, column 8 of the 16 x 16 map): 38 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomF8::
	db $03, $04  ; animated tiles $03, floor $04
	db $32, $2b  ; (2, 3): object $2B
	db $82, $33, $2c  ; 2 across from (3, 3): object $2C
	db $35, $2d  ; (5, 3): object $2D
	db $42, $37  ; (2, 4): object $37
	db $82, $43, $04  ; 2 across from (3, 4): object $04
	db $45, $38  ; (5, 4): object $38
	db $52, $33  ; (2, 5): object $33
	db $82, $53, $2f  ; 2 across from (3, 5): object $2F
	db $53, $e0  ; (3, 5): object $E0
	db $55, $34  ; (5, 5): object $34
	db $10, $3d  ; (0, 1): object $3D
	db $11, $2f  ; (1, 1): object $2F
	db $12, $48  ; (2, 1): object $48
	db $13, $e0  ; (3, 1): object $E0
	db $14, $49  ; (4, 1): object $49
	db $15, $3c  ; (5, 1): object $3C
	db $20, $38  ; (0, 2): object $38
	db $84, $21, $0e  ; 4 across from (1, 2): object $0E
	db $25, $33  ; (5, 2): object $33
	db $26, $2f  ; (6, 2): object $2F
	db $27, $3c  ; (7, 2): object $3C
	db $30, $34  ; (0, 3): object $34
	db $c4, $31, $0e  ; 4 down from (1, 3): object $0E
	db $c5, $36, $0e  ; 5 down from (6, 3): object $0E
	db $c3, $37, $37  ; 3 down from (7, 3): object $37
	db $67, $2e  ; (7, 6): object $2E
	db $68, $3c  ; (8, 6): object $3C
	db $77, $39  ; (7, 7): object $39
	db $78, $2e  ; (8, 7): object $2E
	db $79, $2f  ; (9, 7): object $2F
	db $44, $5c  ; (4, 4): object $5C
	db $86, $60, $0e  ; 6 across from (0, 6): object $0E
	db $86, $70, $0e  ; 6 across from (0, 7): object $0E
	db $c3, $40, $ca  ; 3 down from (0, 4): object $CA
	db $64, $ca  ; (4, 6): object $CA
	db $83, $71, $ca  ; 3 across from (1, 7): object $CA
	db $18, $44  ; (8, 1): object $44
	db $69, $44  ; (9, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $F9 (row F, column 9 of the 16 x 16 map): 23 objects on floor object $04; a warp (type 1) to map $1F room $F6 at x 136, y 112. Format: see OverworldRoomPointers.
OverworldRoomF9::
	db $03, $04  ; animated tiles $03, floor $04
	db $03, $38  ; (3, 0): object $38
	db $86, $04, $0e  ; 6 across from (4, 0): object $0E
	db $83, $07, $ca  ; 3 across from (7, 0): object $CA
	db $13, $32  ; (3, 1): object $32
	db $85, $14, $2c  ; 5 across from (4, 1): object $2C
	db $19, $2d  ; (9, 1): object $2D
	db $c4, $29, $38  ; 4 down from (9, 2): object $38
	db $82, $23, $e8  ; 2 across from (3, 2): object $E8
	db $84, $25, $5c  ; 4 across from (5, 2): object $5C
	db $83, $32, $e8  ; 3 across from (2, 3): object $E8
	db $84, $35, $5c  ; 4 across from (5, 3): object $5C
	db $82, $42, $e8  ; 2 across from (2, 4): object $E8
	db $85, $44, $5c  ; 5 across from (4, 4): object $5C
	db $82, $52, $e8  ; 2 across from (2, 5): object $E8
	db $85, $54, $5c  ; 5 across from (4, 5): object $5C
	db $83, $62, $e8  ; 3 across from (2, 6): object $E8
	db $83, $65, $5c  ; 3 across from (5, 6): object $5C
	db $68, $3d  ; (8, 6): object $3D
	db $69, $34  ; (9, 6): object $34
	db $88, $70, $2f  ; 8 across from (0, 7): object $2F
	db $78, $34  ; (8, 7): object $34
	db $79, $0e  ; (9, 7): object $0E
	db $47, $c6  ; (7, 4): object $C6
	db $e1, $1f, $f6, $88, $70  ; warp type 1 to map $1F room $F6, x 136 y 112
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $FA (row F, column A of the 16 x 16 map): 33 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomFA::
	db $03, $04  ; animated tiles $03, floor $04
	db $c4, $00, $37  ; 4 down from (0, 0): object $37
	db $c6, $14, $0e  ; 6 down from (4, 1): object $0E
	db $c6, $15, $0e  ; 6 down from (5, 1): object $0E
	db $c2, $f9, $f5  ; 2 down from (9, 15): object $F5
	db $23, $f2  ; (3, 2): object $F2
	db $26, $ea  ; (6, 2): object $EA
	db $31, $20  ; (1, 3): object $20
	db $c2, $33, $f3  ; 2 down from (3, 3): object $F3
	db $c2, $36, $f0  ; 2 down from (6, 3): object $F0
	db $40, $33  ; (0, 4): object $33
	db $41, $3c  ; (1, 4): object $3C
	db $48, $20  ; (8, 4): object $20
	db $c3, $50, $0e  ; 3 down from (0, 5): object $0E
	db $51, $37  ; (1, 5): object $37
	db $53, $f4  ; (3, 5): object $F4
	db $56, $f1  ; (6, 5): object $F1
	db $61, $33  ; (1, 6): object $33
	db $62, $2f  ; (2, 6): object $2F
	db $63, $34  ; (3, 6): object $34
	db $65, $ca  ; (5, 6): object $CA
	db $66, $33  ; (6, 6): object $33
	db $83, $67, $2f  ; 3 across from (7, 6): object $2F
	db $89, $71, $0e  ; 9 across from (1, 7): object $0E
	db $82, $73, $ca  ; 2 across from (3, 7): object $CA
	db $12, $44  ; (2, 1): object $44
	db $18, $44  ; (8, 1): object $44
	db $47, $44  ; (7, 4): object $44
	db $52, $44  ; (2, 5): object $44
	db $f3, $f5  ; (3, 15): object $F5
	db $13, $3d  ; (3, 1): object $3D
	db $14, $2f  ; (4, 1): object $2F
	db $15, $e0  ; (5, 1): object $E0
	db $16, $3c  ; (6, 1): object $3C
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $FB (row F, column B of the 16 x 16 map): 18 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomFB::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $ff, $f5  ; 2 across from (15, 15): object $F5
	db $1f, $f5  ; (15, 1): object $F5
	db $c4, $07, $38  ; 4 down from (7, 0): object $38
	db $45, $3d  ; (5, 4): object $3D
	db $46, $2f  ; (6, 4): object $2F
	db $47, $34  ; (7, 4): object $34
	db $54, $3d  ; (4, 5): object $3D
	db $55, $34  ; (5, 5): object $34
	db $84, $60, $2f  ; 4 across from (0, 6): object $2F
	db $64, $34  ; (4, 6): object $34
	db $c8, $08, $0e  ; 8 down from (8, 0): object $0E
	db $c8, $09, $0e  ; 8 down from (9, 0): object $0E
	db $82, $56, $0e  ; 2 across from (6, 5): object $0E
	db $83, $65, $0e  ; 3 across from (5, 6): object $0E
	db $8a, $70, $0e  ; 10 across from (0, 7): object $0E
	db $c3, $29, $ca  ; 3 down from (9, 2): object $CA
	db $48, $ca  ; (8, 4): object $CA
	db $57, $ca  ; (7, 5): object $CA
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $FC (row F, column C of the 16 x 16 map): 31 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomFC::
	db $03, $04  ; animated tiles $03, floor $04
	db $c8, $00, $0e  ; 8 down from (0, 0): object $0E
	db $c8, $01, $0e  ; 8 down from (1, 0): object $0E
	db $c2, $01, $37  ; 2 down from (1, 0): object $37
	db $61, $33  ; (1, 6): object $33
	db $62, $3c  ; (2, 6): object $3C
	db $72, $33  ; (2, 7): object $33
	db $20, $2b  ; (0, 2): object $2B
	db $21, $31  ; (1, 2): object $31
	db $c2, $30, $37  ; 2 down from (0, 3): object $37
	db $50, $33  ; (0, 5): object $33
	db $51, $3c  ; (1, 5): object $3C
	db $61, $33  ; (1, 6): object $33
	db $62, $3c  ; (2, 6): object $3C
	db $72, $33  ; (2, 7): object $33
	db $83, $04, $f5  ; 3 across from (4, 0): object $F5
	db $15, $f5  ; (5, 1): object $F5
	db $24, $5c  ; (4, 2): object $5C
	db $35, $5c  ; (5, 3): object $5C
	db $82, $44, $5c  ; 2 across from (4, 4): object $5C
	db $83, $53, $5c  ; 3 across from (3, 5): object $5C
	db $63, $5c  ; (3, 6): object $5C
	db $36, $f5  ; (6, 3): object $F5
	db $12, $44  ; (2, 1): object $44
	db $27, $44  ; (7, 2): object $44
	db $33, $44  ; (3, 3): object $44
	db $41, $44  ; (1, 4): object $44
	db $52, $44  ; (2, 5): object $44
	db $58, $44  ; (8, 5): object $44
	db $66, $44  ; (6, 6): object $44
	db $87, $73, $2f  ; 7 across from (3, 7): object $2F
	db $31, $04  ; (1, 3): object $04
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $FD (row F, column D of the 16 x 16 map): 24 objects on floor object $04. Format: see OverworldRoomPointers.
OverworldRoomFD::
	db $03, $04  ; animated tiles $03, floor $04
	db $82, $00, $f5  ; 2 across from (0, 0): object $F5
	db $22, $d4  ; (2, 2): object $D4
	db $06, $37  ; (6, 0): object $37
	db $83, $07, $03  ; 3 across from (7, 0): object $03
	db $16, $2e  ; (6, 1): object $2E
	db $17, $48  ; (7, 1): object $48
	db $18, $4a  ; (8, 1): object $4A
	db $19, $49  ; (9, 1): object $49
	db $26, $39  ; (6, 2): object $39
	db $83, $27, $3a  ; 3 across from (7, 2): object $3A
	db $55, $3d  ; (5, 5): object $3D
	db $84, $56, $2f  ; 4 across from (6, 5): object $2F
	db $64, $3d  ; (4, 6): object $3D
	db $65, $34  ; (5, 6): object $34
	db $84, $70, $2f  ; 4 across from (0, 7): object $2F
	db $74, $34  ; (4, 7): object $34
	db $84, $66, $0e  ; 4 across from (6, 6): object $0E
	db $85, $75, $0e  ; 5 across from (5, 7): object $0E
	db $14, $44  ; (4, 1): object $44
	db $30, $44  ; (0, 3): object $44
	db $36, $44  ; (6, 3): object $44
	db $43, $44  ; (3, 4): object $44
	db $49, $44  ; (9, 4): object $44
	db $62, $44  ; (2, 6): object $44
	db $fe  ; end

;@ path: world/overworld/rooms
;@ Overworld room $FE (row F, column E of the 16 x 16 map): 20 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomFE::
	db $03, $08  ; animated tiles $03, floor $08
	db $00, $09  ; (0, 0): object $09
	db $01, $38  ; (1, 0): object $38
	db $10, $2f  ; (0, 1): object $2F
	db $11, $4e  ; (1, 1): object $4E
	db $20, $3a  ; (0, 2): object $3A
	db $21, $3b  ; (1, 2): object $3B
	db $8a, $50, $2f  ; 10 across from (0, 5): object $2F
	db $8a, $60, $0e  ; 10 across from (0, 6): object $0E
	db $8a, $70, $0e  ; 10 across from (0, 7): object $0E
	db $09, $b7  ; (9, 0): object $B7
	db $23, $b6  ; (3, 2): object $B6
	db $26, $b6  ; (6, 2): object $B6
	db $33, $b7  ; (3, 3): object $B7
	db $36, $b7  ; (6, 3): object $B7
	db $39, $b6  ; (9, 3): object $B6
	db $49, $b7  ; (9, 4): object $B7
	db $23, $cd  ; (3, 2): object $CD
	db $26, $cd  ; (6, 2): object $CD
	db $33, $ce  ; (3, 3): object $CE
	db $36, $ce  ; (6, 3): object $CE
	db $fe  ; end
;@ path: world/overworld/rooms
;@ Overworld room $FF (row F, column F of the 16 x 16 map): 30 objects on floor object $08. Format: see OverworldRoomPointers.
OverworldRoomFF::
	db $03, $08  ; animated tiles $03, floor $08
	db $8a, $60, $0e  ; 10 across from (0, 6): object $0E
	db $8a, $70, $0e  ; 10 across from (0, 7): object $0E
	db $c2, $08, $03  ; 2 down from (8, 0): object $03
	db $37, $03  ; (7, 3): object $03
	db $46, $03  ; (6, 4): object $03
	db $c2, $28, $5c  ; 2 down from (8, 2): object $5C
	db $82, $34, $20  ; 2 across from (4, 3): object $20
	db $82, $44, $20  ; 2 across from (4, 4): object $20
	db $c2, $07, $37  ; 2 down from (7, 0): object $37
	db $27, $31  ; (7, 2): object $31
	db $24, $2b  ; (4, 2): object $2B
	db $82, $25, $2c  ; 2 across from (5, 2): object $2C
	db $c2, $34, $37  ; 2 down from (4, 3): object $37
	db $87, $50, $2f  ; 7 across from (0, 5): object $2F
	db $54, $2e  ; (4, 5): object $2E
	db $64, $39  ; (4, 6): object $39
	db $57, $4e  ; (7, 5): object $4E
	db $47, $3d  ; (7, 4): object $3D
	db $48, $2f  ; (8, 4): object $2F
	db $49, $4e  ; (9, 4): object $4E
	db $c4, $09, $38  ; 4 down from (9, 0): object $38
	db $82, $65, $3a  ; 2 across from (5, 6): object $3A
	db $00, $b7  ; (0, 0): object $B7
	db $30, $b6  ; (0, 3): object $B6
	db $40, $b7  ; (0, 4): object $B7
	db $83, $04, $b7  ; 3 across from (4, 0): object $B7
	db $67, $3b  ; (7, 6): object $3B
	db $36, $09  ; (6, 3): object $09
	db $58, $3a  ; (8, 5): object $3A
	db $59, $3b  ; (9, 5): object $3B
	db $fe  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank1AFreeSpace::
	db $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
