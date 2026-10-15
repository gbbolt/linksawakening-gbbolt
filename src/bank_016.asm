; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $016", ROMX[$4000], BANK[$16]

;@ path: world/overworld/entities
;@ The address of each overworld room's entity list, one word per room (room = row * 16 + column).
;@ Entity list format: pairs of position YX (Y = row 0-7 in the high nibble, X = column 0-9 in the low nibble, in 16-pixel cells) and entity type (the handler number of EntityHandlers), up to the end byte $FF. When a room is entered the loader (around $3738) spawns the entries in order; entries 0-7 are skipped while their bit in the room's byte at $CF00 is set (the enemies already beaten there).
OverworldEntityPointers::
	dw OverworldEntities00, OverworldEntities01, OverworldEntities02, OverworldEntities03  ; room $00-$03
	dw OverworldEntities04, OverworldEntities05, OverworldEntities06, OverworldEntities07  ; room $04-$07
	dw OverworldEntities08, OverworldEntities09, OverworldEntities0A, OverworldEntities0B  ; room $08-$0B
	dw OverworldEntities0C, OverworldEntities0D, OverworldEntities0E, OverworldEntities0F  ; room $0C-$0F
	dw OverworldEntities10, OverworldEntities11, OverworldEntities12, OverworldEntities13  ; room $10-$13
	dw OverworldEntities14, OverworldEntities15, OverworldEntities16, OverworldEntities17  ; room $14-$17
	dw OverworldEntities18, OverworldEntities19, OverworldEntities1A, OverworldEntities1B  ; room $18-$1B
	dw OverworldEntities1C, OverworldEntities1D, OverworldEntities1E, OverworldEntities1F  ; room $1C-$1F
	dw OverworldEntities20, OverworldEntities21, OverworldEntities22, OverworldEntities23  ; room $20-$23
	dw OverworldEntities24, OverworldEntities25, OverworldEntities26, OverworldEntities27  ; room $24-$27
	dw OverworldEntities28, OverworldEntities29, OverworldEntities2A, OverworldEntities2B  ; room $28-$2B
	dw OverworldEntities2C, OverworldEntities2D, OverworldEntities2E, OverworldEntities2F  ; room $2C-$2F
	dw OverworldEntities30, OverworldEntities31, OverworldEntities32, OverworldEntities33  ; room $30-$33
	dw OverworldEntities34, OverworldEntities35, OverworldEntities36, OverworldEntities37  ; room $34-$37
	dw OverworldEntities38, OverworldEntities39, OverworldEntities3A, OverworldEntities3B  ; room $38-$3B
	dw OverworldEntities3C, OverworldEntities3D, OverworldEntities3E, OverworldEntities3F  ; room $3C-$3F
	dw OverworldEntities40, OverworldEntities41, OverworldEntities42, OverworldEntities43  ; room $40-$43
	dw OverworldEntities44, OverworldEntities45, OverworldEntities46, OverworldEntities47  ; room $44-$47
	dw OverworldEntities48, OverworldEntities49, OverworldEntities4A, OverworldEntities4B  ; room $48-$4B
	dw OverworldEntities4C, OverworldEntities4D, OverworldEntities4E, OverworldEntities4F  ; room $4C-$4F
	dw OverworldEntities50, OverworldEntities51, OverworldEntities52, OverworldEntities53  ; room $50-$53
	dw OverworldEntities54, OverworldEntities55, OverworldEntities56, OverworldEntities57  ; room $54-$57
	dw OverworldEntities58, OverworldEntities59, OverworldEntities5A, OverworldEntities5B  ; room $58-$5B
	dw OverworldEntities5C, OverworldEntities5D, OverworldEntities5E, OverworldEntities5F  ; room $5C-$5F
	dw OverworldEntities60, OverworldEntities61, OverworldEntities62, OverworldEntities63  ; room $60-$63
	dw OverworldEntities64, OverworldEntities65, OverworldEntities66, OverworldEntities67  ; room $64-$67
	dw OverworldEntities68, OverworldEntities69, OverworldEntities6A, OverworldEntities6B  ; room $68-$6B
	dw OverworldEntities6C, OverworldEntities6D, OverworldEntities6E, OverworldEntities6F  ; room $6C-$6F
	dw OverworldEntities70, OverworldEntities71, OverworldEntities72, OverworldEntities73  ; room $70-$73
	dw OverworldEntities74, OverworldEntities75, OverworldEntities76, OverworldEntities77  ; room $74-$77
	dw OverworldEntities78, OverworldEntities79, OverworldEntities7A, OverworldEntities7B  ; room $78-$7B
	dw OverworldEntities7C, OverworldEntities7D, OverworldEntities7E, OverworldEntities7F  ; room $7C-$7F
	dw OverworldEntities80, OverworldEntities81, OverworldEntities82, OverworldEntities83  ; room $80-$83
	dw OverworldEntities84, OverworldEntities85, OverworldEntities86, OverworldEntities87  ; room $84-$87
	dw OverworldEntities88, OverworldEntities89, OverworldEntities8A, OverworldEntities8B  ; room $88-$8B
	dw OverworldEntities8C, OverworldEntities8D, OverworldEntities8E, OverworldEntities8F  ; room $8C-$8F
	dw OverworldEntities90, OverworldEntities91, OverworldEntities92, OverworldEntities93  ; room $90-$93
	dw OverworldEntities94, OverworldEntities95, OverworldEntities96, OverworldEntities97  ; room $94-$97
	dw OverworldEntities98, OverworldEntities99, OverworldEntities9A, OverworldEntities9B  ; room $98-$9B
	dw OverworldEntities9C, OverworldEntities9D, OverworldEntities9E, OverworldEntities9F  ; room $9C-$9F
	dw OverworldEntitiesA0, OverworldEntitiesA1, OverworldEntitiesA2, OverworldEntitiesA3  ; room $A0-$A3
	dw OverworldEntitiesA4, OverworldEntitiesA5, OverworldEntitiesA6, OverworldEntitiesA7  ; room $A4-$A7
	dw OverworldEntitiesA8, OverworldEntitiesA9, OverworldEntitiesAA, OverworldEntitiesAB  ; room $A8-$AB
	dw OverworldEntitiesAC, OverworldEntitiesAD, OverworldEntitiesAE, OverworldEntitiesAF  ; room $AC-$AF
	dw OverworldEntitiesB0, OverworldEntitiesB1, OverworldEntitiesB2, OverworldEntitiesB3  ; room $B0-$B3
	dw OverworldEntitiesB4, OverworldEntitiesB5, OverworldEntitiesB6, OverworldEntitiesB7  ; room $B4-$B7
	dw OverworldEntitiesB8, OverworldEntitiesB9, OverworldEntitiesBA, OverworldEntitiesBB  ; room $B8-$BB
	dw OverworldEntitiesBC, OverworldEntitiesBD, OverworldEntitiesBE, OverworldEntitiesBF  ; room $BC-$BF
	dw OverworldEntitiesC0, OverworldEntitiesC1, OverworldEntitiesC2, OverworldEntitiesC3  ; room $C0-$C3
	dw OverworldEntitiesC4, OverworldEntitiesC5, OverworldEntitiesC6, OverworldEntitiesC7  ; room $C4-$C7
	dw OverworldEntitiesC8, OverworldEntitiesC9, OverworldEntitiesCA, OverworldEntitiesCB  ; room $C8-$CB
	dw OverworldEntitiesCC, OverworldEntitiesCD, OverworldEntitiesCE, OverworldEntitiesCF  ; room $CC-$CF
	dw OverworldEntitiesD0, OverworldEntitiesD1, OverworldEntitiesD2, OverworldEntitiesD3  ; room $D0-$D3
	dw OverworldEntitiesD4, OverworldEntitiesD5, OverworldEntitiesD6, OverworldEntitiesD7  ; room $D4-$D7
	dw OverworldEntitiesD8, OverworldEntitiesD9, OverworldEntitiesDA, OverworldEntitiesDB  ; room $D8-$DB
	dw OverworldEntitiesDC, OverworldEntitiesDD, OverworldEntitiesDE, OverworldEntitiesDF  ; room $DC-$DF
	dw OverworldEntitiesE0, OverworldEntitiesE1, OverworldEntitiesE2, OverworldEntitiesE3  ; room $E0-$E3
	dw OverworldEntitiesE4, OverworldEntitiesE5, OverworldEntitiesE6, OverworldEntitiesE7  ; room $E4-$E7
	dw OverworldEntitiesE8, OverworldEntitiesE9, OverworldEntitiesEA, OverworldEntitiesEB  ; room $E8-$EB
	dw OverworldEntitiesEC, OverworldEntitiesED, OverworldEntitiesEE, OverworldEntitiesEF  ; room $EC-$EF
	dw OverworldEntitiesF0, OverworldEntitiesF1, OverworldEntitiesF2, OverworldEntitiesF3  ; room $F0-$F3
	dw OverworldEntitiesF4, OverworldEntitiesF5, OverworldEntitiesF6, OverworldEntitiesF7  ; room $F4-$F7
	dw OverworldEntitiesF8, OverworldEntitiesF9, OverworldEntitiesFA, OverworldEntitiesFB  ; room $F8-$FB
	dw OverworldEntitiesFC, OverworldEntitiesFD, OverworldEntitiesFE, OverworldEntitiesFF  ; room $FC-$FF
;@ path: world/indoor/entities
;@ The address of the entity list of each room of indoor group A (maps $00-$05, $1A-$1F), one word per room. Format: see OverworldEntityPointers.
IndoorAEntityPointers::
	dw IndoorAEntities00, IndoorAEntities01, IndoorAEntities02, IndoorAEntities03  ; room $00-$03
	dw IndoorAEntities04, IndoorAEntities05, IndoorAEntities06, IndoorAEntities07  ; room $04-$07
	dw IndoorAEntities08, IndoorAEntities09, IndoorAEntities0A, IndoorAEntities0B  ; room $08-$0B
	dw IndoorAEntities0C, IndoorAEntities0D, IndoorAEntities0E, IndoorAEntities0F  ; room $0C-$0F
	dw IndoorAEntities10, IndoorAEntities11, IndoorAEntities12, IndoorAEntities13  ; room $10-$13
	dw IndoorAEntities14, IndoorAEntities15, IndoorAEntities16, IndoorAEntities17  ; room $14-$17
	dw IndoorAEntities18, IndoorAEntities19, IndoorAEntities1A, IndoorAEntities1B  ; room $18-$1B
	dw IndoorAEntities1C, IndoorAEntities1D, IndoorAEntities1E, IndoorAEntities1F  ; room $1C-$1F
	dw IndoorAEntities20, IndoorAEntities21, IndoorAEntities22, IndoorAEntities23  ; room $20-$23
	dw IndoorAEntities24, IndoorAEntities25, IndoorAEntities26, IndoorAEntities27  ; room $24-$27
	dw IndoorAEntities28, IndoorAEntities29, IndoorAEntities2A, IndoorAEntities2B  ; room $28-$2B
	dw IndoorAEntities2C, IndoorAEntities2D, IndoorAEntities2E, IndoorAEntities2F  ; room $2C-$2F
	dw IndoorAEntities30, IndoorAEntities31, IndoorAEntities32, IndoorAEntities33  ; room $30-$33
	dw IndoorAEntities34, IndoorAEntities35, IndoorAEntities36, IndoorAEntities37  ; room $34-$37
	dw IndoorAEntities38, IndoorAEntities39, IndoorAEntities3A, IndoorAEntities3B  ; room $38-$3B
	dw IndoorAEntities3C, IndoorAEntities3D, IndoorAEntities3E, IndoorAEntities3F  ; room $3C-$3F
	dw IndoorAEntities40, IndoorAEntities41, IndoorAEntities42, IndoorAEntities43  ; room $40-$43
	dw IndoorAEntities44, IndoorAEntities45, IndoorAEntities46, IndoorAEntities47  ; room $44-$47
	dw IndoorAEntities48, IndoorAEntities49, IndoorAEntities4A, IndoorAEntities4B  ; room $48-$4B
	dw IndoorAEntities4C, IndoorAEntities4D, IndoorAEntities4E, IndoorAEntities4F  ; room $4C-$4F
	dw IndoorAEntities50, IndoorAEntities51, IndoorAEntities52, IndoorAEntities53  ; room $50-$53
	dw IndoorAEntities54, IndoorAEntities55, IndoorAEntities56, IndoorAEntities57  ; room $54-$57
	dw IndoorAEntities58, IndoorAEntities59, IndoorAEntities5A, IndoorAEntities5B  ; room $58-$5B
	dw IndoorAEntities5C, IndoorAEntities5D, IndoorAEntities5E, IndoorAEntities5F  ; room $5C-$5F
	dw IndoorAEntities60, IndoorAEntities61, IndoorAEntities62, IndoorAEntities63  ; room $60-$63
	dw IndoorAEntities64, IndoorAEntities65, IndoorAEntities66, IndoorAEntities67  ; room $64-$67
	dw IndoorAEntities68, IndoorAEntities69, IndoorAEntities6A, IndoorAEntities6B  ; room $68-$6B
	dw IndoorAEntities6C, IndoorAEntities6D, IndoorAEntities6E, IndoorAEntities6F  ; room $6C-$6F
	dw IndoorAEntities70, IndoorAEntities71, IndoorAEntities72, IndoorAEntities73  ; room $70-$73
	dw IndoorAEntities74, IndoorAEntities75, IndoorAEntities76, IndoorAEntities77  ; room $74-$77
	dw IndoorAEntities78, IndoorAEntities79, IndoorAEntities7A, IndoorAEntities7B  ; room $78-$7B
	dw IndoorAEntities7C, IndoorAEntities7D, IndoorAEntities7E, IndoorAEntities7F  ; room $7C-$7F
	dw IndoorAEntities80, IndoorAEntities81, IndoorAEntities82, IndoorAEntities83  ; room $80-$83
	dw IndoorAEntities84, IndoorAEntities85, IndoorAEntities86, IndoorAEntities87  ; room $84-$87
	dw IndoorAEntities88, IndoorAEntities89, IndoorAEntities8A, IndoorAEntities8B  ; room $88-$8B
	dw IndoorAEntities8C, IndoorAEntities8D, IndoorAEntities8E, IndoorAEntities8F  ; room $8C-$8F
	dw IndoorAEntities90, IndoorAEntities91, IndoorAEntities92, IndoorAEntities93  ; room $90-$93
	dw IndoorAEntities94, IndoorAEntities95, IndoorAEntities96, IndoorAEntities97  ; room $94-$97
	dw IndoorAEntities98, IndoorAEntities99, IndoorAEntities9A, IndoorAEntities9B  ; room $98-$9B
	dw IndoorAEntities9C, IndoorAEntities9D, IndoorAEntities9E, IndoorAEntities9F  ; room $9C-$9F
	dw IndoorAEntitiesA0, IndoorAEntitiesA1, IndoorAEntitiesA2, IndoorAEntitiesA3  ; room $A0-$A3
	dw IndoorAEntitiesA4, IndoorAEntitiesA5, IndoorAEntitiesA6, IndoorAEntitiesA7  ; room $A4-$A7
	dw IndoorAEntitiesA8, IndoorAEntitiesA9, IndoorAEntitiesAA, IndoorAEntitiesAB  ; room $A8-$AB
	dw IndoorAEntitiesAC, IndoorAEntitiesAD, IndoorAEntitiesAE, IndoorAEntitiesAF  ; room $AC-$AF
	dw IndoorAEntitiesB0, IndoorAEntitiesB1, IndoorAEntitiesB2, IndoorAEntitiesB3  ; room $B0-$B3
	dw IndoorAEntitiesB4, IndoorAEntitiesB5, IndoorAEntitiesB6, IndoorAEntitiesB7  ; room $B4-$B7
	dw IndoorAEntitiesB8, IndoorAEntitiesB9, IndoorAEntitiesBA, IndoorAEntitiesBB  ; room $B8-$BB
	dw IndoorAEntitiesBC, IndoorAEntitiesBD, IndoorAEntitiesBE, IndoorAEntitiesBF  ; room $BC-$BF
	dw IndoorAEntitiesC0, IndoorAEntitiesC1, IndoorAEntitiesC2, IndoorAEntitiesC3  ; room $C0-$C3
	dw IndoorAEntitiesC4, IndoorAEntitiesC5, IndoorAEntitiesC6, IndoorAEntitiesC7  ; room $C4-$C7
	dw IndoorAEntitiesC8, IndoorAEntitiesC9, IndoorAEntitiesCA, IndoorAEntitiesCB  ; room $C8-$CB
	dw IndoorAEntitiesCC, IndoorAEntitiesCD, IndoorAEntitiesCE, IndoorAEntitiesCF  ; room $CC-$CF
	dw IndoorAEntitiesD0, IndoorAEntitiesD1, IndoorAEntitiesD2, IndoorAEntitiesD3  ; room $D0-$D3
	dw IndoorAEntitiesD4, IndoorAEntitiesD5, IndoorAEntitiesD6, IndoorAEntitiesD7  ; room $D4-$D7
	dw IndoorAEntitiesD8, IndoorAEntitiesD9, IndoorAEntitiesDA, IndoorAEntitiesDB  ; room $D8-$DB
	dw IndoorAEntitiesDC, IndoorAEntitiesDD, IndoorAEntitiesDE, IndoorAEntitiesDF  ; room $DC-$DF
	dw IndoorAEntitiesE0, IndoorAEntitiesE0, IndoorAEntitiesE0, IndoorAEntitiesE3  ; room $E0-$E3
	dw IndoorAEntitiesE4, IndoorAEntitiesE5, IndoorAEntitiesE6, IndoorAEntitiesE7  ; room $E4-$E7
	dw IndoorAEntitiesE8, IndoorAEntitiesE9, IndoorAEntitiesEA, IndoorAEntitiesEB  ; room $E8-$EB
	dw IndoorAEntitiesEC, IndoorAEntitiesED, IndoorAEntitiesEE, IndoorAEntitiesEF  ; room $EC-$EF
	dw IndoorAEntitiesF0, IndoorAEntitiesF1, IndoorAEntitiesF2, IndoorAEntitiesF3  ; room $F0-$F3
	dw IndoorAEntitiesF4, IndoorAEntitiesF5, IndoorAEntitiesF6, IndoorAEntitiesF7  ; room $F4-$F7
	dw IndoorAEntitiesF8, IndoorAEntitiesF9, IndoorAEntitiesFA, IndoorAEntitiesFB  ; room $F8-$FB
	dw IndoorAEntitiesFC, IndoorAEntitiesFD, IndoorAEntitiesFE, IndoorAEntitiesFF  ; room $FC-$FF
;@ path: world/indoor/entities
;@ The address of the entity list of each room of indoor group B (maps $06-$19), one word per room. Format: see OverworldEntityPointers.
IndoorBEntityPointers::
	dw IndoorBEntities00, IndoorBEntities01, IndoorBEntities02, IndoorBEntities03  ; room $00-$03
	dw IndoorBEntities04, IndoorBEntities05, IndoorBEntities06, IndoorBEntities07  ; room $04-$07
	dw IndoorBEntities08, IndoorBEntities09, IndoorBEntities0A, IndoorBEntities0B  ; room $08-$0B
	dw IndoorBEntities0C, IndoorBEntities0D, IndoorBEntities0E, IndoorBEntities0F  ; room $0C-$0F
	dw IndoorBEntities10, IndoorBEntities11, IndoorBEntities12, IndoorBEntities13  ; room $10-$13
	dw IndoorBEntities14, IndoorBEntities15, IndoorBEntities16, IndoorBEntities17  ; room $14-$17
	dw IndoorBEntities18, IndoorBEntities19, IndoorBEntities1A, IndoorBEntities1B  ; room $18-$1B
	dw IndoorBEntities1C, IndoorBEntities1D, IndoorBEntities1E, IndoorBEntities1F  ; room $1C-$1F
	dw IndoorBEntities20, IndoorBEntities21, IndoorBEntities22, IndoorBEntities23  ; room $20-$23
	dw IndoorBEntities24, IndoorBEntities25, IndoorBEntities26, IndoorBEntities27  ; room $24-$27
	dw IndoorBEntities28, IndoorBEntities29, IndoorBEntities2A, IndoorBEntities2B  ; room $28-$2B
	dw IndoorBEntities2C, IndoorBEntities2D, IndoorBEntities2E, IndoorBEntities2F  ; room $2C-$2F
	dw IndoorBEntities30, IndoorBEntities31, IndoorBEntities32, IndoorBEntities33  ; room $30-$33
	dw IndoorBEntities34, IndoorBEntities35, IndoorBEntities36, IndoorBEntities37  ; room $34-$37
	dw IndoorBEntities38, IndoorBEntities39, IndoorBEntities3A, IndoorBEntities3B  ; room $38-$3B
	dw IndoorBEntities3C, IndoorBEntities3D, IndoorBEntities3E, IndoorBEntities3F  ; room $3C-$3F
	dw IndoorBEntities40, IndoorBEntities41, IndoorBEntities42, IndoorBEntities43  ; room $40-$43
	dw IndoorBEntities44, IndoorBEntities45, IndoorBEntities46, IndoorBEntities47  ; room $44-$47
	dw IndoorBEntities48, IndoorBEntities49, IndoorBEntities4A, IndoorBEntities4B  ; room $48-$4B
	dw IndoorBEntities4C, IndoorBEntities4D, IndoorBEntities4E, IndoorBEntities4F  ; room $4C-$4F
	dw IndoorBEntities50, IndoorBEntities51, IndoorBEntities52, IndoorBEntities53  ; room $50-$53
	dw IndoorBEntities54, IndoorBEntities55, IndoorBEntities56, IndoorBEntities57  ; room $54-$57
	dw IndoorBEntities58, IndoorBEntities59, IndoorBEntities5A, IndoorBEntities5B  ; room $58-$5B
	dw IndoorBEntities5C, IndoorBEntities5D, IndoorBEntities5E, IndoorBEntities5F  ; room $5C-$5F
	dw IndoorBEntities60, IndoorBEntities61, IndoorBEntities62, IndoorBEntities63  ; room $60-$63
	dw IndoorBEntities64, IndoorBEntities65, IndoorBEntities66, IndoorBEntities67  ; room $64-$67
	dw IndoorBEntities68, IndoorBEntities69, IndoorBEntities6A, IndoorBEntities6B  ; room $68-$6B
	dw IndoorBEntities6C, IndoorBEntities6D, IndoorBEntities6E, IndoorBEntities6F  ; room $6C-$6F
	dw IndoorBEntities70, IndoorBEntities71, IndoorBEntities72, IndoorBEntities73  ; room $70-$73
	dw IndoorBEntities74, IndoorBEntities75, IndoorBEntities76, IndoorBEntities77  ; room $74-$77
	dw IndoorBEntities78, IndoorBEntities79, IndoorBEntities7A, IndoorBEntities7B  ; room $78-$7B
	dw IndoorBEntities7C, IndoorBEntities7D, IndoorBEntities7E, IndoorBEntities7F  ; room $7C-$7F
	dw IndoorBEntities80, IndoorBEntities81, IndoorBEntities82, IndoorBEntities83  ; room $80-$83
	dw IndoorBEntities84, IndoorBEntities85, IndoorBEntities86, IndoorBEntities87  ; room $84-$87
	dw IndoorBEntities88, IndoorBEntities89, IndoorBEntities8A, IndoorBEntities8B  ; room $88-$8B
	dw IndoorBEntities8C, IndoorBEntities8D, IndoorBEntities8E, IndoorBEntities8F  ; room $8C-$8F
	dw IndoorBEntities90, IndoorBEntities91, IndoorBEntities92, IndoorBEntities93  ; room $90-$93
	dw IndoorBEntities94, IndoorBEntities95, IndoorBEntities96, IndoorBEntities97  ; room $94-$97
	dw IndoorBEntities98, IndoorBEntities99, IndoorBEntities9A, IndoorBEntities9B  ; room $98-$9B
	dw IndoorBEntities9C, IndoorBEntities9D, IndoorBEntities9E, IndoorBEntities9F  ; room $9C-$9F
	dw IndoorBEntitiesA0, IndoorBEntitiesA1, IndoorBEntitiesA2, IndoorBEntitiesA3  ; room $A0-$A3
	dw IndoorBEntitiesA4, IndoorBEntitiesA5, IndoorBEntitiesA6, IndoorBEntitiesA7  ; room $A4-$A7
	dw IndoorBEntitiesA8, IndoorBEntitiesA9, IndoorBEntitiesAA, IndoorBEntitiesAB  ; room $A8-$AB
	dw IndoorBEntitiesAC, IndoorBEntitiesAD, IndoorBEntitiesAE, IndoorBEntitiesAF  ; room $AC-$AF
	dw IndoorBEntitiesB0, IndoorBEntitiesB1, IndoorBEntitiesB2, IndoorBEntitiesB3  ; room $B0-$B3
	dw IndoorBEntitiesB4, IndoorBEntitiesB5, IndoorBEntitiesB6, IndoorBEntitiesB7  ; room $B4-$B7
	dw IndoorBEntitiesB8, IndoorBEntitiesB9, IndoorBEntitiesBA, IndoorBEntitiesBB  ; room $B8-$BB
	dw IndoorBEntitiesBC, IndoorBEntitiesBD, IndoorBEntitiesBE, IndoorBEntitiesBF  ; room $BC-$BF
	dw IndoorBEntitiesC0, IndoorBEntitiesC1, IndoorBEntitiesC2, IndoorBEntitiesC3  ; room $C0-$C3
	dw IndoorBEntitiesC4, IndoorBEntitiesC5, IndoorBEntitiesC6, IndoorBEntitiesC7  ; room $C4-$C7
	dw IndoorBEntitiesC8, IndoorBEntitiesC9, IndoorBEntitiesCA, IndoorBEntitiesCB  ; room $C8-$CB
	dw IndoorBEntitiesCC, IndoorBEntitiesCD, IndoorBEntitiesCE, IndoorBEntitiesCF  ; room $CC-$CF
	dw IndoorBEntitiesD0, IndoorBEntitiesD1, IndoorBEntitiesD2, IndoorBEntitiesD3  ; room $D0-$D3
	dw IndoorBEntitiesD4, IndoorBEntitiesD5, IndoorBEntitiesD6, IndoorBEntitiesD7  ; room $D4-$D7
	dw IndoorBEntitiesD8, IndoorBEntitiesD9, IndoorBEntitiesDA, IndoorBEntitiesDB  ; room $D8-$DB
	dw IndoorBEntitiesDC, IndoorBEntitiesDD, IndoorBEntitiesDE, IndoorBEntitiesDF  ; room $DC-$DF
	dw IndoorBEntitiesE0, IndoorBEntitiesE1, IndoorBEntitiesE2, IndoorBEntitiesE3  ; room $E0-$E3
	dw IndoorBEntitiesE4, IndoorBEntitiesE5, IndoorBEntitiesE6, IndoorBEntitiesE7  ; room $E4-$E7
	dw IndoorBEntitiesE8, IndoorBEntitiesE9, IndoorBEntitiesEA, IndoorBEntitiesEB  ; room $E8-$EB
	dw IndoorBEntitiesEC, IndoorBEntitiesED, IndoorBEntitiesEE, IndoorBEntitiesEF  ; room $EC-$EF
	dw IndoorBEntitiesF0, IndoorBEntitiesF1, IndoorBEntitiesF2, IndoorBEntitiesF3  ; room $F0-$F3
	dw IndoorBEntitiesF4, IndoorBEntitiesF5, IndoorBEntitiesF6, IndoorBEntitiesF7  ; room $F4-$F7
	dw IndoorBEntitiesF8, IndoorBEntitiesF9, IndoorBEntitiesFA, IndoorBEntitiesFB  ; room $F8-$FB
	dw IndoorBEntitiesFC, IndoorBEntitiesFD, IndoorBEntitiesFE, IndoorBEntitiesFF  ; room $FC-$FF
;@ path: world/indoor/entities
;@ Entities of indoor group A room $00: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities00::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $01: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities01::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $02: 1 ($39). Format: see IndoorAEntityPointers.
IndoorAEntities02::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $03: 3 ($42, $2C, $2C). Format: see IndoorAEntityPointers.
IndoorAEntities03::
	db $05, $42  ; (5, 0): entity $42
	db $32, $2c  ; (2, 3): entity $2C
	db $55, $2c  ; (5, 5): entity $2C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $04: 1 ($17). Format: see IndoorAEntityPointers.
IndoorAEntities04::
	db $14, $17  ; (4, 1): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $05: 4 ($17, $16, $1C, $1C). Format: see IndoorAEntityPointers.
IndoorAEntities05::
	db $13, $17  ; (3, 1): entity $17
	db $66, $16  ; (6, 6): entity $16
	db $15, $1c  ; (5, 1): entity $1C
	db $33, $1c  ; (3, 3): entity $1C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $06: 1 ($59). Format: see IndoorAEntityPointers.
IndoorAEntities06::
	db $23, $59  ; (3, 2): entity $59
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $07: 2 ($27, $19). Format: see IndoorAEntityPointers.
IndoorAEntities07::
	db $31, $27  ; (1, 3): entity $27
	db $45, $19  ; (5, 4): entity $19
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $08: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities08::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $09: 1 ($20). Format: see IndoorAEntityPointers.
IndoorAEntities09::
	db $27, $20  ; (7, 2): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $0A: 4 ($90, $90, $90, $42). Format: see IndoorAEntityPointers.
IndoorAEntities0A::
	db $22, $90  ; (2, 2): entity $90
	db $27, $90  ; (7, 2): entity $90
	db $34, $90  ; (4, 3): entity $90
	db $05, $42  ; (5, 0): entity $42
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $0B: 4 ($27, $27, $27, $27). Format: see IndoorAEntityPointers.
IndoorAEntities0B::
	db $11, $27  ; (1, 1): entity $27
	db $18, $27  ; (8, 1): entity $27
	db $61, $27  ; (1, 6): entity $27
	db $68, $27  ; (8, 6): entity $27
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $0C: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities0C::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $0D: 1 ($29). Format: see IndoorAEntityPointers.
IndoorAEntities0D::
	db $24, $29  ; (4, 2): entity $29
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $0E: 3 ($29, $17, $16). Format: see IndoorAEntityPointers.
IndoorAEntities0E::
	db $35, $29  ; (5, 3): entity $29
	db $14, $17  ; (4, 1): entity $17
	db $67, $16  ; (7, 6): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $0F: 3 ($1E, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities0F::
	db $44, $1e  ; (4, 4): entity $1E
	db $26, $19  ; (6, 2): entity $19
	db $35, $19  ; (5, 3): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $10: 3 ($17, $16, $1E). Format: see IndoorAEntityPointers.
IndoorAEntities10::
	db $67, $17  ; (7, 6): entity $17
	db $55, $16  ; (5, 5): entity $16
	db $23, $1e  ; (3, 2): entity $1E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $11: 3 ($61, $81, $82). Format: see IndoorAEntityPointers.
IndoorAEntities11::
	db $34, $61  ; (4, 3): entity $61
	db $38, $81  ; (8, 3): entity $81
	db $36, $82  ; (6, 3): entity $82
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $12: 4 ($19, $19, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities12::
	db $34, $19  ; (4, 3): entity $19
	db $35, $19  ; (5, 3): entity $19
	db $44, $19  ; (4, 4): entity $19
	db $45, $19  ; (5, 4): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $13: 3 ($20, $1C, $1C). Format: see IndoorAEntityPointers.
IndoorAEntities13::
	db $14, $20  ; (4, 1): entity $20
	db $52, $1c  ; (2, 5): entity $1C
	db $57, $1c  ; (7, 5): entity $1C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $14: 4 ($1E, $1E, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities14::
	db $43, $1e  ; (3, 4): entity $1E
	db $46, $1e  ; (6, 4): entity $1E
	db $54, $19  ; (4, 5): entity $19
	db $55, $19  ; (5, 5): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $15: 6 ($9B, $9B, $9B, $9B, $9E, $9E). Format: see IndoorAEntityPointers.
IndoorAEntities15::
	db $42, $9b  ; (2, 4): entity $9B
	db $32, $9b  ; (2, 3): entity $9B
	db $34, $9b  ; (4, 3): entity $9B
	db $44, $9b  ; (4, 4): entity $9B
	db $11, $9e  ; (1, 1): entity $9E
	db $15, $9e  ; (5, 1): entity $9E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $16: 2 ($20, $20). Format: see IndoorAEntityPointers.
IndoorAEntities16::
	db $23, $20  ; (3, 2): entity $20
	db $26, $20  ; (6, 2): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $17: 1 ($61). Format: see IndoorAEntityPointers.
IndoorAEntities17::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $18: 1 ($9F). Format: see IndoorAEntityPointers.
IndoorAEntities18::
	db $65, $9f  ; (5, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $19: 2 ($9F, $9F). Format: see IndoorAEntityPointers.
IndoorAEntities19::
	db $62, $9f  ; (2, 6): entity $9F
	db $65, $9f  ; (5, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $1A: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities1A::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $1B: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities1B::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $1C: 1 ($E5). Format: see IndoorAEntityPointers.
IndoorAEntities1C::
	db $44, $e5  ; (4, 4): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $1D: 2 ($27, $27). Format: see IndoorAEntityPointers.
IndoorAEntities1D::
	db $51, $27  ; (1, 5): entity $27
	db $58, $27  ; (8, 5): entity $27
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $1E: 1 ($D8). Format: see IndoorAEntityPointers.
IndoorAEntities1E::
	db $25, $d8  ; (5, 2): entity $D8
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $1F: 1 ($D8). Format: see IndoorAEntityPointers.
IndoorAEntities1F::
	db $14, $d8  ; (4, 1): entity $D8
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $20: 2 ($50, $50). Format: see IndoorAEntityPointers.
IndoorAEntities20::
	db $24, $50  ; (4, 2): entity $50
	db $45, $50  ; (5, 4): entity $50
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $21: 6 ($19, $19, $2D, $2E, $2E, $86). Format: see IndoorAEntityPointers.
IndoorAEntities21::
	db $32, $19  ; (2, 3): entity $19
	db $37, $19  ; (7, 3): entity $19
	db $18, $2d  ; (8, 1): entity $2D
	db $24, $2e  ; (4, 2): entity $2E
	db $57, $2e  ; (7, 5): entity $2E
	db $25, $86  ; (5, 2): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $22: 5 ($66, $2D, $2D, $2D, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities22::
	db $24, $66  ; (4, 2): entity $66
	db $53, $2d  ; (3, 5): entity $2D
	db $54, $2d  ; (4, 5): entity $2D
	db $55, $2d  ; (5, 5): entity $2D
	db $56, $2d  ; (6, 5): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $23: 3 ($20, $1C, $19). Format: see IndoorAEntityPointers.
IndoorAEntities23::
	db $17, $20  ; (7, 1): entity $20
	db $23, $1c  ; (3, 2): entity $1C
	db $64, $19  ; (4, 6): entity $19
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $24: 6 ($19, $19, $19, $19, $66, $1A). Format: see IndoorAEntityPointers.
IndoorAEntities24::
	db $23, $19  ; (3, 2): entity $19
	db $25, $19  ; (5, 2): entity $19
	db $43, $19  ; (3, 4): entity $19
	db $45, $19  ; (5, 4): entity $19
	db $34, $66  ; (4, 3): entity $66
	db $18, $1a  ; (8, 1): entity $1A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $25: 5 ($18, $18, $1B, $2E, $2F). Format: see IndoorAEntityPointers.
IndoorAEntities25::
	db $44, $18  ; (4, 4): entity $18
	db $67, $18  ; (7, 6): entity $18
	db $46, $1b  ; (6, 4): entity $1B
	db $55, $2e  ; (5, 5): entity $2E
	db $63, $2f  ; (3, 6): entity $2F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $26: 4 ($52, $19, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities26::
	db $61, $52  ; (1, 6): entity $52
	db $24, $19  ; (4, 2): entity $19
	db $35, $19  ; (5, 3): entity $19
	db $46, $19  ; (6, 4): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $27: 3 ($18, $19, $0B). Format: see IndoorAEntityPointers.
IndoorAEntities27::
	db $64, $18  ; (4, 6): entity $18
	db $67, $19  ; (7, 6): entity $19
	db $33, $0b  ; (3, 3): entity $0B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $28: 2 ($89, $61). Format: see IndoorAEntityPointers.
IndoorAEntities28::
	db $25, $89  ; (5, 2): entity $89
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $29: 5 ($19, $19, $42, $2D, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities29::
	db $22, $19  ; (2, 2): entity $19
	db $57, $19  ; (7, 5): entity $19
	db $05, $42  ; (5, 0): entity $42
	db $32, $2d  ; (2, 3): entity $2D
	db $66, $e5  ; (6, 6): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $2A: 1 ($39). Format: see IndoorAEntityPointers.
IndoorAEntities2A::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $2B: 1 ($5C). Format: see IndoorAEntityPointers.
IndoorAEntities2B::
	db $24, $5c  ; (4, 2): entity $5C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $2C: 3 ($19, $16, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities2C::
	db $22, $19  ; (2, 2): entity $19
	db $21, $16  ; (1, 2): entity $16
	db $44, $e5  ; (4, 4): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $2D: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities2D::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $2E: 1 ($20). Format: see IndoorAEntityPointers.
IndoorAEntities2E::
	db $15, $20  ; (5, 1): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $2F: 5 ($19, $19, $17, $2D, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities2F::
	db $24, $19  ; (4, 2): entity $19
	db $54, $19  ; (4, 5): entity $19
	db $62, $17  ; (2, 6): entity $17
	db $24, $2d  ; (4, 2): entity $2D
	db $65, $2d  ; (5, 6): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $30: 6 ($27, $27, $27, $27, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities30::
	db $11, $27  ; (1, 1): entity $27
	db $18, $27  ; (8, 1): entity $27
	db $61, $27  ; (1, 6): entity $27
	db $68, $27  ; (8, 6): entity $27
	db $33, $19  ; (3, 3): entity $19
	db $36, $19  ; (6, 3): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $31: 1 ($16). Format: see IndoorAEntityPointers.
IndoorAEntities31::
	db $12, $16  ; (2, 1): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $32: 2 ($1E, $1A). Format: see IndoorAEntityPointers.
IndoorAEntities32::
	db $34, $1e  ; (4, 3): entity $1E
	db $35, $1a  ; (5, 3): entity $1A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $33: 2 ($66, $16). Format: see IndoorAEntityPointers.
IndoorAEntities33::
	db $35, $66  ; (5, 3): entity $66
	db $12, $16  ; (2, 1): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $34: 3 ($8F, $8F, $2E). Format: see IndoorAEntityPointers.
IndoorAEntities34::
	db $35, $8f  ; (5, 3): entity $8F
	db $36, $8f  ; (6, 3): entity $8F
	db $68, $2e  ; (8, 6): entity $2E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $35: 2 ($2C, $2C). Format: see IndoorAEntityPointers.
IndoorAEntities35::
	db $25, $2c  ; (5, 2): entity $2C
	db $68, $2c  ; (8, 6): entity $2C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $36: 5 ($61, $2D, $2D, $2D, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities36::
	db $34, $61  ; (4, 3): entity $61
	db $17, $2d  ; (7, 1): entity $2D
	db $18, $2d  ; (8, 1): entity $2D
	db $27, $2d  ; (7, 2): entity $2D
	db $28, $2d  ; (8, 2): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $37: 3 ($8F, $2E, $2E). Format: see IndoorAEntityPointers.
IndoorAEntities37::
	db $54, $8f  ; (4, 5): entity $8F
	db $44, $2e  ; (4, 4): entity $2E
	db $46, $2e  ; (6, 4): entity $2E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $38: 2 ($14, $66). Format: see IndoorAEntityPointers.
IndoorAEntities38::
	db $62, $14  ; (2, 6): entity $14
	db $45, $66  ; (5, 4): entity $66
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $39: 4 ($66, $2D, $2D, $86). Format: see IndoorAEntityPointers.
IndoorAEntities39::
	db $68, $66  ; (8, 6): entity $66
	db $11, $2d  ; (1, 1): entity $2D
	db $21, $2d  ; (1, 2): entity $2D
	db $45, $86  ; (5, 4): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $3A: 2 ($A5, $D6). Format: see IndoorAEntityPointers.
IndoorAEntities3A::
	db $43, $a5  ; (3, 4): entity $A5
	db $66, $d6  ; (6, 6): entity $D6
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $3B: 3 ($A5, $D6, $D6). Format: see IndoorAEntityPointers.
IndoorAEntities3B::
	db $43, $a5  ; (3, 4): entity $A5
	db $66, $d6  ; (6, 6): entity $D6
	db $67, $d6  ; (7, 6): entity $D6
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $3C: 3 ($A2, $A2, $9F). Format: see IndoorAEntityPointers.
IndoorAEntities3C::
	db $53, $a2  ; (3, 5): entity $A2
	db $57, $a2  ; (7, 5): entity $A2
	db $55, $9f  ; (5, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $3D: 2 ($A2, $9F). Format: see IndoorAEntityPointers.
IndoorAEntities3D::
	db $54, $a2  ; (4, 5): entity $A2
	db $62, $9f  ; (2, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $3E: 1 ($A4). Format: see IndoorAEntityPointers.
IndoorAEntities3E::
	db $33, $a4  ; (3, 3): entity $A4
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $3F: 1 ($A3). Format: see IndoorAEntityPointers.
IndoorAEntities3F::
	db $63, $a3  ; (3, 6): entity $A3
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $40: 4 ($55, $55, $14, $86). Format: see IndoorAEntityPointers.
IndoorAEntities40::
	db $15, $55  ; (5, 1): entity $55
	db $42, $55  ; (2, 4): entity $55
	db $37, $14  ; (7, 3): entity $14
	db $34, $86  ; (4, 3): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $41: 4 ($55, $55, $55, $2F). Format: see IndoorAEntityPointers.
IndoorAEntities41::
	db $18, $55  ; (8, 1): entity $55
	db $41, $55  ; (1, 4): entity $55
	db $43, $55  ; (3, 4): entity $55
	db $44, $2f  ; (4, 4): entity $2F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $42: 4 ($9B, $0B, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities42::
	db $23, $9b  ; (3, 2): entity $9B
	db $32, $0b  ; (2, 3): entity $0B
	db $35, $9b  ; (5, 3): entity $9B
	db $46, $9b  ; (6, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $43: 5 ($56, $56, $56, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities43::
	db $12, $56  ; (2, 1): entity $56
	db $26, $56  ; (6, 2): entity $56
	db $47, $56  ; (7, 4): entity $56
	db $33, $9b  ; (3, 3): entity $9B
	db $37, $9b  ; (7, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $44: 3 ($1A, $1B, $1B). Format: see IndoorAEntityPointers.
IndoorAEntities44::
	db $23, $1a  ; (3, 2): entity $1A
	db $35, $1b  ; (5, 3): entity $1B
	db $42, $1b  ; (2, 4): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $45: 3 ($60, $60, $61). Format: see IndoorAEntityPointers.
IndoorAEntities45::
	db $23, $60  ; (3, 2): entity $60
	db $25, $60  ; (5, 2): entity $60
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $46: 1 ($E5). Format: see IndoorAEntityPointers.
IndoorAEntities46::
	db $64, $e5  ; (4, 6): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $47: 3 ($1A, $1A, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities47::
	db $13, $1a  ; (3, 1): entity $1A
	db $46, $1a  ; (6, 4): entity $1A
	db $32, $9b  ; (2, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $48: 4 ($57, $57, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities48::
	db $22, $57  ; (2, 2): entity $57
	db $56, $57  ; (6, 5): entity $57
	db $33, $9b  ; (3, 3): entity $9B
	db $36, $9b  ; (6, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $49: 5 ($1C, $1C, $1C, $1C, $1B). Format: see IndoorAEntityPointers.
IndoorAEntities49::
	db $34, $1c  ; (4, 3): entity $1C
	db $43, $1c  ; (3, 4): entity $1C
	db $45, $1c  ; (5, 4): entity $1C
	db $54, $1c  ; (4, 5): entity $1C
	db $44, $1b  ; (4, 4): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $4A: 4 ($0B, $0B, $2D, $38). Format: see IndoorAEntityPointers.
IndoorAEntities4A::
	db $24, $0b  ; (4, 2): entity $0B
	db $47, $0b  ; (7, 4): entity $0B
	db $67, $2d  ; (7, 6): entity $2D
	db $68, $38  ; (8, 6): entity $38
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $4B: 4 ($0B, $0B, $2D, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities4B::
	db $62, $0b  ; (2, 6): entity $0B
	db $64, $0b  ; (4, 6): entity $0B
	db $66, $2d  ; (6, 6): entity $2D
	db $67, $2d  ; (7, 6): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $4C: 4 ($9B, $9B, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities4C::
	db $25, $9b  ; (5, 2): entity $9B
	db $27, $9b  ; (7, 2): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $47, $9b  ; (7, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $4D: 5 ($9B, $9B, $9B, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities4D::
	db $12, $9b  ; (2, 1): entity $9B
	db $21, $9b  ; (1, 2): entity $9B
	db $26, $9b  ; (6, 2): entity $9B
	db $28, $9b  ; (8, 2): entity $9B
	db $68, $9b  ; (8, 6): entity $9B
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $4E: 3 ($1C, $1E, $1E). Format: see IndoorAEntityPointers.
IndoorAEntities4E::
	db $31, $1c  ; (1, 3): entity $1C
	db $35, $1e  ; (5, 3): entity $1E
	db $45, $1e  ; (5, 4): entity $1E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $4F: 4 ($9B, $9B, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities4F::
	db $36, $9b  ; (6, 3): entity $9B
	db $46, $9b  ; (6, 4): entity $9B
	db $37, $9b  ; (7, 3): entity $9B
	db $47, $9b  ; (7, 4): entity $9B
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $50: 3 ($19, $19, $14). Format: see IndoorAEntityPointers.
IndoorAEntities50::
	db $32, $19  ; (2, 3): entity $19
	db $61, $19  ; (1, 6): entity $19
	db $46, $14  ; (6, 4): entity $14
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $51: 4 ($1C, $55, $55, $14). Format: see IndoorAEntityPointers.
IndoorAEntities51::
	db $31, $1c  ; (1, 3): entity $1C
	db $41, $55  ; (1, 4): entity $55
	db $48, $55  ; (8, 4): entity $55
	db $35, $14  ; (5, 3): entity $14
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $52: 1 ($61). Format: see IndoorAEntityPointers.
IndoorAEntities52::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $53: 1 ($53). Format: see IndoorAEntityPointers.
IndoorAEntities53::
	db $37, $53  ; (7, 3): entity $53
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $54: 5 ($42, $66, $0B, $1A, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities54::
	db $33, $42  ; (3, 3): entity $42
	db $36, $66  ; (6, 3): entity $66
	db $41, $0b  ; (1, 4): entity $0B
	db $48, $1a  ; (8, 4): entity $1A
	db $21, $2d  ; (1, 2): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $55: 5 ($57, $9B, $9B, $57, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities55::
	db $27, $57  ; (7, 2): entity $57
	db $36, $9b  ; (6, 3): entity $9B
	db $41, $9b  ; (1, 4): entity $9B
	db $57, $57  ; (7, 5): entity $57
	db $42, $e5  ; (2, 4): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $56: 5 ($9B, $9B, $9B, $9B, $1C). Format: see IndoorAEntityPointers.
IndoorAEntities56::
	db $25, $9b  ; (5, 2): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $27, $9b  ; (7, 2): entity $9B
	db $47, $9b  ; (7, 4): entity $9B
	db $32, $1c  ; (2, 3): entity $1C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $57: 3 ($57, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities57::
	db $26, $57  ; (6, 2): entity $57
	db $33, $19  ; (3, 3): entity $19
	db $57, $19  ; (7, 5): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $58: 7 ($9B, $9B, $9B, $57, $0B, $38, $38). Format: see IndoorAEntityPointers.
IndoorAEntities58::
	db $34, $9b  ; (4, 3): entity $9B
	db $41, $9b  ; (1, 4): entity $9B
	db $56, $9b  ; (6, 5): entity $9B
	db $36, $57  ; (6, 3): entity $57
	db $52, $0b  ; (2, 5): entity $0B
	db $54, $38  ; (4, 5): entity $38
	db $55, $38  ; (5, 5): entity $38
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $59: 1 ($39). Format: see IndoorAEntityPointers.
IndoorAEntities59::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $5A: 1 ($5B). Format: see IndoorAEntityPointers.
IndoorAEntities5A::
	db $34, $5b  ; (4, 3): entity $5B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $5B: 5 ($19, $19, $19, $19, $19). Format: see IndoorAEntityPointers.
IndoorAEntities5B::
	db $13, $19  ; (3, 1): entity $19
	db $25, $19  ; (5, 2): entity $19
	db $42, $19  ; (2, 4): entity $19
	db $55, $19  ; (5, 5): entity $19
	db $67, $19  ; (7, 6): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $5C: 4 ($57, $57, $57, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities5C::
	db $15, $57  ; (5, 1): entity $57
	db $32, $57  ; (2, 3): entity $57
	db $67, $57  ; (7, 6): entity $57
	db $34, $e5  ; (4, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $5D: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities5D::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $5E: 2 ($AB, $AA). Format: see IndoorAEntityPointers.
IndoorAEntities5E::
	db $37, $ab  ; (7, 3): entity $AB
	db $53, $aa  ; (3, 5): entity $AA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $5F: 2 ($AB, $AA). Format: see IndoorAEntityPointers.
IndoorAEntities5F::
	db $34, $ab  ; (4, 3): entity $AB
	db $62, $aa  ; (2, 6): entity $AA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $60: 4 ($9E, $9E, $1B, $1B). Format: see IndoorAEntityPointers.
IndoorAEntities60::
	db $03, $9e  ; (3, 0): entity $9E
	db $05, $9e  ; (5, 0): entity $9E
	db $53, $1b  ; (3, 5): entity $1B
	db $55, $1b  ; (5, 5): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $61: 6 ($69, $16, $46, $47, $48, $49). Format: see IndoorAEntityPointers.
IndoorAEntities61::
	db $07, $69  ; (7, 0): entity $69
	db $53, $16  ; (3, 5): entity $16
	db $21, $46  ; (1, 2): entity $46
	db $51, $47  ; (1, 5): entity $47
	db $63, $48  ; (3, 6): entity $48
	db $66, $49  ; (6, 6): entity $49
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $62: 1 ($39). Format: see IndoorAEntityPointers.
IndoorAEntities62::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $63: 5 ($8A, $24, $24, $1B, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities63::
	db $34, $8a  ; (4, 3): entity $8A
	db $33, $24  ; (3, 3): entity $24
	db $36, $24  ; (6, 3): entity $24
	db $45, $1b  ; (5, 4): entity $1B
	db $44, $e5  ; (4, 4): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $64: 2 ($8E, $61). Format: see IndoorAEntityPointers.
IndoorAEntities64::
	db $11, $8e  ; (1, 1): entity $8E
	db $14, $61  ; (4, 1): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $65: 4 ($15, $15, $99, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities65::
	db $13, $15  ; (3, 1): entity $15
	db $17, $15  ; (7, 1): entity $15
	db $35, $99  ; (5, 3): entity $99
	db $32, $e5  ; (2, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $66: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities66::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $67: 4 ($8B, $99, $99, $99). Format: see IndoorAEntityPointers.
IndoorAEntities67::
	db $34, $8b  ; (4, 3): entity $8B
	db $23, $99  ; (3, 2): entity $99
	db $36, $99  ; (6, 3): entity $99
	db $55, $99  ; (5, 5): entity $99
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $68: 5 ($9E, $9E, $9B, $9B, $17). Format: see IndoorAEntityPointers.
IndoorAEntities68::
	db $04, $9e  ; (4, 0): entity $9E
	db $05, $9e  ; (5, 0): entity $9E
	db $37, $9b  ; (7, 3): entity $9B
	db $58, $9b  ; (8, 5): entity $9B
	db $61, $17  ; (1, 6): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $69: 4 ($1B, $1B, $2E, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities69::
	db $44, $1b  ; (4, 4): entity $1B
	db $45, $1b  ; (5, 4): entity $1B
	db $67, $2e  ; (7, 6): entity $2E
	db $68, $2d  ; (8, 6): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $6A: 4 ($9C, $9B, $14, $1B). Format: see IndoorAEntityPointers.
IndoorAEntities6A::
	db $13, $9c  ; (3, 1): entity $9C
	db $24, $9b  ; (4, 2): entity $9B
	db $32, $14  ; (2, 3): entity $14
	db $58, $1b  ; (8, 5): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $6B: 5 ($99, $A0, $99, $A0, $38). Format: see IndoorAEntityPointers.
IndoorAEntities6B::
	db $28, $99  ; (8, 2): entity $99
	db $35, $a0  ; (5, 3): entity $A0
	db $43, $99  ; (3, 4): entity $99
	db $57, $a0  ; (7, 5): entity $A0
	db $58, $38  ; (8, 5): entity $38
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $6C: 4 ($1B, $1B, $1B, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities6C::
	db $23, $1b  ; (3, 2): entity $1B
	db $53, $1b  ; (3, 5): entity $1B
	db $56, $1b  ; (6, 5): entity $1B
	db $54, $2d  ; (4, 5): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $6D: 4 ($14, $1B, $0B, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities6D::
	db $37, $14  ; (7, 3): entity $14
	db $48, $1b  ; (8, 4): entity $1B
	db $55, $0b  ; (5, 5): entity $0B
	db $18, $2d  ; (8, 1): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $6E: 3 ($99, $99, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities6E::
	db $37, $99  ; (7, 3): entity $99
	db $46, $99  ; (6, 4): entity $99
	db $52, $e5  ; (2, 5): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $6F: 5 ($42, $9B, $2C, $2C, $2F). Format: see IndoorAEntityPointers.
IndoorAEntities6F::
	db $43, $42  ; (3, 4): entity $42
	db $33, $9b  ; (3, 3): entity $9B
	db $36, $2c  ; (6, 3): entity $2C
	db $42, $2c  ; (2, 4): entity $2C
	db $25, $2f  ; (5, 2): entity $2F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $70: 2 ($1B, $1B). Format: see IndoorAEntityPointers.
IndoorAEntities70::
	db $55, $1b  ; (5, 5): entity $1B
	db $58, $1b  ; (8, 5): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $71: 5 ($15, $99, $A0, $2E, $2E). Format: see IndoorAEntityPointers.
IndoorAEntities71::
	db $35, $15  ; (5, 3): entity $15
	db $43, $99  ; (3, 4): entity $99
	db $58, $a0  ; (8, 5): entity $A0
	db $51, $2e  ; (1, 5): entity $2E
	db $61, $2e  ; (1, 6): entity $2E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $72: 3 ($A0, $A0, $A0). Format: see IndoorAEntityPointers.
IndoorAEntities72::
	db $13, $a0  ; (3, 1): entity $A0
	db $28, $a0  ; (8, 2): entity $A0
	db $36, $a0  ; (6, 3): entity $A0
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $73: 3 ($99, $99, $99). Format: see IndoorAEntityPointers.
IndoorAEntities73::
	db $22, $99  ; (2, 2): entity $99
	db $26, $99  ; (6, 2): entity $99
	db $34, $99  ; (4, 3): entity $99
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $74: 3 ($99, $A0, $99). Format: see IndoorAEntityPointers.
IndoorAEntities74::
	db $22, $99  ; (2, 2): entity $99
	db $35, $a0  ; (5, 3): entity $A0
	db $44, $99  ; (4, 4): entity $99
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $75: 5 ($99, $99, $A0, $99, $2F). Format: see IndoorAEntityPointers.
IndoorAEntities75::
	db $25, $99  ; (5, 2): entity $99
	db $28, $99  ; (8, 2): entity $99
	db $42, $a0  ; (2, 4): entity $A0
	db $47, $99  ; (7, 4): entity $99
	db $21, $2f  ; (1, 2): entity $2F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $76: 4 ($2D, $2D, $99, $86). Format: see IndoorAEntityPointers.
IndoorAEntities76::
	db $51, $2d  ; (1, 5): entity $2D
	db $61, $2d  ; (1, 6): entity $2D
	db $65, $99  ; (5, 6): entity $99
	db $36, $86  ; (6, 3): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $77: 3 ($2C, $2C, $1B). Format: see IndoorAEntityPointers.
IndoorAEntities77::
	db $42, $2c  ; (2, 4): entity $2C
	db $46, $2c  ; (6, 4): entity $2C
	db $55, $1b  ; (5, 5): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $78: 4 ($2C, $16, $1B, $2C). Format: see IndoorAEntityPointers.
IndoorAEntities78::
	db $35, $2c  ; (5, 3): entity $2C
	db $53, $16  ; (3, 5): entity $16
	db $56, $1b  ; (6, 5): entity $1B
	db $62, $2c  ; (2, 6): entity $2C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $79: 3 ($99, $99, $99). Format: see IndoorAEntityPointers.
IndoorAEntities79::
	db $36, $99  ; (6, 3): entity $99
	db $48, $99  ; (8, 4): entity $99
	db $54, $99  ; (4, 5): entity $99
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $7A: 1 ($61). Format: see IndoorAEntityPointers.
IndoorAEntities7A::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $7B: 4 ($99, $99, $99, $99). Format: see IndoorAEntityPointers.
IndoorAEntities7B::
	db $21, $99  ; (1, 2): entity $99
	db $28, $99  ; (8, 2): entity $99
	db $52, $99  ; (2, 5): entity $99
	db $68, $99  ; (8, 6): entity $99
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $7C: 1 ($30). Format: see IndoorAEntityPointers.
IndoorAEntities7C::
	db $23, $30  ; (3, 2): entity $30
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $7D: 1 ($A3). Format: see IndoorAEntityPointers.
IndoorAEntities7D::
	db $32, $a3  ; (2, 3): entity $A3
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $7E: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities7E::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $7F: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities7F::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $80: 1 ($5F). Format: see IndoorAEntityPointers.
IndoorAEntities80::
	db $34, $5f  ; (4, 3): entity $5F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $81: 4 ($1E, $1E, $1A, $1A). Format: see IndoorAEntityPointers.
IndoorAEntities81::
	db $13, $1e  ; (3, 1): entity $1E
	db $51, $1e  ; (1, 5): entity $1E
	db $18, $1a  ; (8, 1): entity $1A
	db $65, $1a  ; (5, 6): entity $1A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $82: 1 ($39). Format: see IndoorAEntityPointers.
IndoorAEntities82::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $83: 4 ($1E, $1A, $1E, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities83::
	db $33, $1e  ; (3, 3): entity $1E
	db $34, $1a  ; (4, 3): entity $1A
	db $35, $1e  ; (5, 3): entity $1E
	db $54, $e5  ; (4, 5): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $84: 1 ($5F). Format: see IndoorAEntityPointers.
IndoorAEntities84::
	db $34, $5f  ; (4, 3): entity $5F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $85: 1 ($5D). Format: see IndoorAEntityPointers.
IndoorAEntities85::
	db $34, $5d  ; (4, 3): entity $5D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $86: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities86::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $87: 6 ($16, $9B, $9B, $9B, $2D, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities87::
	db $16, $16  ; (6, 1): entity $16
	db $25, $9b  ; (5, 2): entity $9B
	db $37, $9b  ; (7, 3): entity $9B
	db $42, $9b  ; (2, 4): entity $9B
	db $18, $2d  ; (8, 1): entity $2D
	db $61, $2d  ; (1, 6): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $88: 5 ($14, $9C, $2E, $2E, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities88::
	db $32, $14  ; (2, 3): entity $14
	db $44, $9c  ; (4, 4): entity $9C
	db $62, $2e  ; (2, 6): entity $2E
	db $64, $2e  ; (4, 6): entity $2E
	db $58, $e5  ; (8, 5): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $89: 7 ($9E, $9E, $0B, $14, $2D, $2E, $2E). Format: see IndoorAEntityPointers.
IndoorAEntities89::
	db $41, $9e  ; (1, 4): entity $9E
	db $48, $9e  ; (8, 4): entity $9E
	db $26, $0b  ; (6, 2): entity $0B
	db $56, $14  ; (6, 5): entity $14
	db $18, $2d  ; (8, 1): entity $2D
	db $61, $2e  ; (1, 6): entity $2E
	db $62, $2e  ; (2, 6): entity $2E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $8A: 5 ($42, $9C, $15, $9C, $9C). Format: see IndoorAEntityPointers.
IndoorAEntities8A::
	db $05, $42  ; (5, 0): entity $42
	db $24, $9c  ; (4, 2): entity $9C
	db $26, $15  ; (6, 2): entity $15
	db $64, $9c  ; (4, 6): entity $9C
	db $66, $9c  ; (6, 6): entity $9C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $8B: 1 ($17). Format: see IndoorAEntityPointers.
IndoorAEntities8B::
	db $65, $17  ; (5, 6): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $8C: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntities8C::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $8D: 4 ($99, $99, $99, $99). Format: see IndoorAEntityPointers.
IndoorAEntities8D::
	db $15, $99  ; (5, 1): entity $99
	db $41, $99  ; (1, 4): entity $99
	db $48, $99  ; (8, 4): entity $99
	db $65, $99  ; (5, 6): entity $99
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $8E: 4 ($0B, $0B, $9C, $2E). Format: see IndoorAEntityPointers.
IndoorAEntities8E::
	db $22, $0b  ; (2, 2): entity $0B
	db $35, $0b  ; (5, 3): entity $0B
	db $43, $9c  ; (3, 4): entity $9C
	db $13, $2e  ; (3, 1): entity $2E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $8F: 4 ($16, $1B, $14, $86). Format: see IndoorAEntityPointers.
IndoorAEntities8F::
	db $42, $16  ; (2, 4): entity $16
	db $64, $1b  ; (4, 6): entity $1B
	db $66, $14  ; (6, 6): entity $14
	db $54, $86  ; (4, 5): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $90: 6 ($27, $27, $27, $27, $9C, $14). Format: see IndoorAEntityPointers.
IndoorAEntities90::
	db $11, $27  ; (1, 1): entity $27
	db $18, $27  ; (8, 1): entity $27
	db $61, $27  ; (1, 6): entity $27
	db $68, $27  ; (8, 6): entity $27
	db $23, $9c  ; (3, 2): entity $9C
	db $42, $14  ; (2, 4): entity $14
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $91: 2 ($16, $17). Format: see IndoorAEntityPointers.
IndoorAEntities91::
	db $31, $16  ; (1, 3): entity $16
	db $57, $17  ; (7, 5): entity $17
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $92: 1 ($5F). Format: see IndoorAEntityPointers.
IndoorAEntities92::
	db $34, $5f  ; (4, 3): entity $5F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $93: 3 ($5E, $5E, $61). Format: see IndoorAEntityPointers.
IndoorAEntities93::
	db $12, $5e  ; (2, 1): entity $5E
	db $42, $5e  ; (2, 4): entity $5E
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $94: 5 ($1B, $1B, $15, $2D, $37). Format: see IndoorAEntityPointers.
IndoorAEntities94::
	db $24, $1b  ; (4, 2): entity $1B
	db $43, $1b  ; (3, 4): entity $1B
	db $55, $15  ; (5, 5): entity $15
	db $34, $2d  ; (4, 3): entity $2D
	db $35, $37  ; (5, 3): entity $37
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $95: 1 ($5F). Format: see IndoorAEntityPointers.
IndoorAEntities95::
	db $34, $5f  ; (4, 3): entity $5F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $96: 6 ($9B, $9B, $9B, $38, $38, $2D). Format: see IndoorAEntityPointers.
IndoorAEntities96::
	db $24, $9b  ; (4, 2): entity $9B
	db $32, $9b  ; (2, 3): entity $9B
	db $44, $9b  ; (4, 4): entity $9B
	db $25, $38  ; (5, 2): entity $38
	db $26, $38  ; (6, 2): entity $38
	db $36, $2d  ; (6, 3): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $97: 5 ($24, $24, $24, $2D, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities97::
	db $42, $24  ; (2, 4): entity $24
	db $53, $24  ; (3, 5): entity $24
	db $66, $24  ; (6, 6): entity $24
	db $21, $2d  ; (1, 2): entity $2D
	db $53, $e5  ; (3, 5): entity $E5
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $98: 6 ($27, $27, $27, $27, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntities98::
	db $14, $27  ; (4, 1): entity $27
	db $16, $27  ; (6, 1): entity $27
	db $64, $27  ; (4, 6): entity $27
	db $66, $27  ; (6, 6): entity $27
	db $22, $9b  ; (2, 2): entity $9B
	db $52, $9b  ; (2, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $99: 5 ($9E, $1B, $1B, $2F, $E5). Format: see IndoorAEntityPointers.
IndoorAEntities99::
	db $15, $9e  ; (5, 1): entity $9E
	db $32, $1b  ; (2, 3): entity $1B
	db $34, $1b  ; (4, 3): entity $1B
	db $37, $2f  ; (7, 3): entity $2F
	db $43, $e5  ; (3, 4): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $9A: 3 ($1A, $1A, $1E). Format: see IndoorAEntityPointers.
IndoorAEntities9A::
	db $12, $1a  ; (2, 1): entity $1A
	db $17, $1a  ; (7, 1): entity $1A
	db $46, $1e  ; (6, 4): entity $1E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $9B: 4 ($16, $24, $24, $86). Format: see IndoorAEntityPointers.
IndoorAEntities9B::
	db $24, $16  ; (4, 2): entity $16
	db $33, $24  ; (3, 3): entity $24
	db $55, $24  ; (5, 5): entity $24
	db $54, $86  ; (4, 5): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $9C: 6 ($27, $27, $27, $27, $24, $24). Format: see IndoorAEntityPointers.
IndoorAEntities9C::
	db $11, $27  ; (1, 1): entity $27
	db $18, $27  ; (8, 1): entity $27
	db $61, $27  ; (1, 6): entity $27
	db $68, $27  ; (8, 6): entity $27
	db $55, $24  ; (5, 5): entity $24
	db $33, $24  ; (3, 3): entity $24
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $9D: 3 ($1A, $24, $1E). Format: see IndoorAEntityPointers.
IndoorAEntities9D::
	db $26, $1a  ; (6, 2): entity $1A
	db $32, $24  ; (2, 3): entity $24
	db $53, $1e  ; (3, 5): entity $1E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $9E: 3 ($16, $24, $24). Format: see IndoorAEntityPointers.
IndoorAEntities9E::
	db $34, $16  ; (4, 3): entity $16
	db $35, $24  ; (5, 3): entity $24
	db $44, $24  ; (4, 4): entity $24
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $9F: 5 ($19, $19, $19, $19, $24). Format: see IndoorAEntityPointers.
IndoorAEntities9F::
	db $23, $19  ; (3, 2): entity $19
	db $26, $19  ; (6, 2): entity $19
	db $43, $19  ; (3, 4): entity $19
	db $46, $19  ; (6, 4): entity $19
	db $34, $24  ; (4, 3): entity $24
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A0: 3 ($24, $16, $1B). Format: see IndoorAEntityPointers.
IndoorAEntitiesA0::
	db $44, $24  ; (4, 4): entity $24
	db $45, $16  ; (5, 4): entity $16
	db $55, $1b  ; (5, 5): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A1: 1 ($61). Format: see IndoorAEntityPointers.
IndoorAEntitiesA1::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A2: 3 ($A9, $A9, $9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesA2::
	db $33, $a9  ; (3, 3): entity $A9
	db $34, $a9  ; (4, 3): entity $A9
	db $37, $9f  ; (7, 3): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A3: 2 ($A9, $A9). Format: see IndoorAEntityPointers.
IndoorAEntitiesA3::
	db $42, $a9  ; (2, 4): entity $A9
	db $52, $a9  ; (2, 5): entity $A9
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A4: 1 ($9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesA4::
	db $51, $9f  ; (1, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A5: 2 ($9F, $9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesA5::
	db $32, $9f  ; (2, 3): entity $9F
	db $34, $9f  ; (4, 3): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A6: 2 ($AC, $AC). Format: see IndoorAEntityPointers.
IndoorAEntitiesA6::
	db $53, $ac  ; (3, 5): entity $AC
	db $56, $ac  ; (6, 5): entity $AC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A7: 2 ($AC, $AC). Format: see IndoorAEntityPointers.
IndoorAEntitiesA7::
	db $52, $ac  ; (2, 5): entity $AC
	db $56, $ac  ; (6, 5): entity $AC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A8: 4 ($A6, $A6, $A6, $A6). Format: see IndoorAEntityPointers.
IndoorAEntitiesA8::
	db $52, $a6  ; (2, 5): entity $A6
	db $36, $a6  ; (6, 3): entity $A6
	db $54, $a6  ; (4, 5): entity $A6
	db $38, $a6  ; (8, 3): entity $A6
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $A9: 2 ($A6, $A6). Format: see IndoorAEntityPointers.
IndoorAEntitiesA9::
	db $54, $a6  ; (4, 5): entity $A6
	db $36, $a6  ; (6, 3): entity $A6
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $AA: 1 ($D9). Format: see IndoorAEntityPointers.
IndoorAEntitiesAA::
	db $15, $d9  ; (5, 1): entity $D9
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $AB: 1 ($A2). Format: see IndoorAEntityPointers.
IndoorAEntitiesAB::
	db $37, $a2  ; (7, 3): entity $A2
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $AC: 1 ($84). Format: see IndoorAEntityPointers.
IndoorAEntitiesAC::
	db $24, $84  ; (4, 2): entity $84
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $AD: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesAD::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $AE: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesAE::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $AF: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesAF::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $B0: 4 ($98, $98, $66, $9C). Format: see IndoorAEntityPointers.
IndoorAEntitiesB0::
	db $53, $98  ; (3, 5): entity $98
	db $56, $98  ; (6, 5): entity $98
	db $22, $66  ; (2, 2): entity $66
	db $21, $9c  ; (1, 2): entity $9C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B1: 5 ($98, $98, $66, $9C, $E5). Format: see IndoorAEntityPointers.
IndoorAEntitiesB1::
	db $53, $98  ; (3, 5): entity $98
	db $56, $98  ; (6, 5): entity $98
	db $27, $66  ; (7, 2): entity $66
	db $28, $9c  ; (8, 2): entity $9C
	db $64, $e5  ; (4, 6): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B2: 4 ($16, $9D, $9D, $17). Format: see IndoorAEntityPointers.
IndoorAEntitiesB2::
	db $15, $16  ; (5, 1): entity $16
	db $32, $9d  ; (2, 3): entity $9D
	db $34, $9d  ; (4, 3): entity $9D
	db $42, $17  ; (2, 4): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B3: 3 ($66, $9C, $86). Format: see IndoorAEntityPointers.
IndoorAEntitiesB3::
	db $00, $66  ; (0, 0): entity $66
	db $35, $9c  ; (5, 3): entity $9C
	db $38, $86  ; (8, 3): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B4: 3 ($15, $21, $21). Format: see IndoorAEntityPointers.
IndoorAEntitiesB4::
	db $14, $15  ; (4, 1): entity $15
	db $33, $21  ; (3, 3): entity $21
	db $36, $21  ; (6, 3): entity $21
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B5: 1 ($39). Format: see IndoorAEntityPointers.
IndoorAEntitiesB5::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B6: 1 ($66). Format: see IndoorAEntityPointers.
IndoorAEntitiesB6::
	db $26, $66  ; (6, 2): entity $66
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B7: 5 ($17, $16, $86, $37, $2D). Format: see IndoorAEntityPointers.
IndoorAEntitiesB7::
	db $31, $17  ; (1, 3): entity $17
	db $48, $16  ; (8, 4): entity $16
	db $34, $86  ; (4, 3): entity $86
	db $23, $37  ; (3, 2): entity $37
	db $28, $2d  ; (8, 2): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B8: 6 ($38, $38, $9B, $9B, $9B, $E5). Format: see IndoorAEntityPointers.
IndoorAEntitiesB8::
	db $57, $38  ; (7, 5): entity $38
	db $58, $38  ; (8, 5): entity $38
	db $25, $9b  ; (5, 2): entity $9B
	db $32, $9b  ; (2, 3): entity $9B
	db $34, $9b  ; (4, 3): entity $9B
	db $32, $e5  ; (2, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $B9: 1 ($9E). Format: see IndoorAEntityPointers.
IndoorAEntitiesB9::
	db $17, $9e  ; (7, 1): entity $9E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $BA: 4 ($98, $98, $2D, $2D). Format: see IndoorAEntityPointers.
IndoorAEntitiesBA::
	db $34, $98  ; (4, 3): entity $98
	db $45, $98  ; (5, 4): entity $98
	db $36, $2d  ; (6, 3): entity $2D
	db $43, $2d  ; (3, 4): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $BB: 5 ($42, $86, $9D, $16, $17). Format: see IndoorAEntityPointers.
IndoorAEntitiesBB::
	db $55, $42  ; (5, 5): entity $42
	db $38, $86  ; (8, 3): entity $86
	db $14, $9d  ; (4, 1): entity $9D
	db $32, $16  ; (2, 3): entity $16
	db $42, $17  ; (2, 4): entity $17
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $BC: 1 ($5A). Format: see IndoorAEntityPointers.
IndoorAEntitiesBC::
	db $34, $5a  ; (4, 3): entity $5A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $BD: 2 ($9D, $9D). Format: see IndoorAEntityPointers.
IndoorAEntitiesBD::
	db $32, $9d  ; (2, 3): entity $9D
	db $37, $9d  ; (7, 3): entity $9D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $BE: 5 ($99, $99, $99, $9C, $2D). Format: see IndoorAEntityPointers.
IndoorAEntitiesBE::
	db $25, $99  ; (5, 2): entity $99
	db $27, $99  ; (7, 2): entity $99
	db $46, $99  ; (6, 4): entity $99
	db $31, $9c  ; (1, 3): entity $9C
	db $63, $2d  ; (3, 6): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $BF: 4 ($18, $18, $18, $38). Format: see IndoorAEntityPointers.
IndoorAEntitiesBF::
	db $31, $18  ; (1, 3): entity $18
	db $34, $18  ; (4, 3): entity $18
	db $52, $18  ; (2, 5): entity $18
	db $11, $38  ; (1, 1): entity $38
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C0: 5 ($66, $21, $21, $21, $E5). Format: see IndoorAEntityPointers.
IndoorAEntitiesC0::
	db $61, $66  ; (1, 6): entity $66
	db $27, $21  ; (7, 2): entity $21
	db $34, $21  ; (4, 3): entity $21
	db $52, $21  ; (2, 5): entity $21
	db $33, $e5  ; (3, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C1: 5 ($9B, $9B, $2D, $38, $37). Format: see IndoorAEntityPointers.
IndoorAEntitiesC1::
	db $46, $9b  ; (6, 4): entity $9B
	db $53, $9b  ; (3, 5): entity $9B
	db $11, $2d  ; (1, 1): entity $2D
	db $25, $38  ; (5, 2): entity $38
	db $61, $37  ; (1, 6): entity $37
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C2: 5 ($9B, $9B, $9B, $9B, $9D). Format: see IndoorAEntityPointers.
IndoorAEntitiesC2::
	db $23, $9b  ; (3, 2): entity $9B
	db $25, $9b  ; (5, 2): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $53, $9b  ; (3, 5): entity $9B
	db $34, $9d  ; (4, 3): entity $9D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C3: 1 ($9A). Format: see IndoorAEntityPointers.
IndoorAEntitiesC3::
	db $22, $9a  ; (2, 2): entity $9A
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $C4: 2 ($17, $17). Format: see IndoorAEntityPointers.
IndoorAEntitiesC4::
	db $22, $17  ; (2, 2): entity $17
	db $26, $17  ; (6, 2): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C5: 2 ($92, $61). Format: see IndoorAEntityPointers.
IndoorAEntitiesC5::
	db $35, $92  ; (5, 3): entity $92
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C6: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesC6::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C7: 2 ($60, $60). Format: see IndoorAEntityPointers.
IndoorAEntitiesC7::
	db $25, $60  ; (5, 2): entity $60
	db $54, $60  ; (4, 5): entity $60
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $C8: 3 ($66, $8F, $9D). Format: see IndoorAEntityPointers.
IndoorAEntitiesC8::
	db $34, $66  ; (4, 3): entity $66
	db $25, $8f  ; (5, 2): entity $8F
	db $54, $9d  ; (4, 5): entity $9D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $C9: 2 ($9D, $E5). Format: see IndoorAEntityPointers.
IndoorAEntitiesC9::
	db $14, $9d  ; (4, 1): entity $9D
	db $22, $e5  ; (2, 2): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $CA: 5 ($52, $9B, $9B, $9B, $9B). Format: see IndoorAEntityPointers.
IndoorAEntitiesCA::
	db $44, $52  ; (4, 4): entity $52
	db $24, $9b  ; (4, 2): entity $9B
	db $51, $9b  ; (1, 5): entity $9B
	db $46, $9b  ; (6, 4): entity $9B
	db $64, $9b  ; (4, 6): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $CB: 2 ($21, $2A). Format: see IndoorAEntityPointers.
IndoorAEntitiesCB::
	db $35, $21  ; (5, 3): entity $21
	db $68, $2a  ; (8, 6): entity $2A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $CC: 6 ($9E, $9E, $1B, $1B, $2D, $38). Format: see IndoorAEntityPointers.
IndoorAEntitiesCC::
	db $11, $9e  ; (1, 1): entity $9E
	db $18, $9e  ; (8, 1): entity $9E
	db $34, $1b  ; (4, 3): entity $1B
	db $35, $1b  ; (5, 3): entity $1B
	db $37, $2d  ; (7, 3): entity $2D
	db $42, $38  ; (2, 4): entity $38
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $CD: 6 ($16, $99, $99, $9C, $38, $37). Format: see IndoorAEntityPointers.
IndoorAEntitiesCD::
	db $27, $16  ; (7, 2): entity $16
	db $22, $99  ; (2, 2): entity $99
	db $53, $99  ; (3, 5): entity $99
	db $38, $9c  ; (8, 3): entity $9C
	db $17, $38  ; (7, 1): entity $38
	db $18, $37  ; (8, 1): entity $37
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $CE: 3 ($9D, $9D, $2F). Format: see IndoorAEntityPointers.
IndoorAEntitiesCE::
	db $34, $9d  ; (4, 3): entity $9D
	db $35, $9d  ; (5, 3): entity $9D
	db $18, $2f  ; (8, 1): entity $2F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $CF: 3 ($29, $9D, $17). Format: see IndoorAEntityPointers.
IndoorAEntitiesCF::
	db $23, $29  ; (3, 2): entity $29
	db $38, $9d  ; (8, 3): entity $9D
	db $63, $17  ; (3, 6): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D0: 4 ($9E, $9E, $9D, $9D). Format: see IndoorAEntityPointers.
IndoorAEntitiesD0::
	db $13, $9e  ; (3, 1): entity $9E
	db $16, $9e  ; (6, 1): entity $9E
	db $43, $9d  ; (3, 4): entity $9D
	db $46, $9d  ; (6, 4): entity $9D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D1: 5 ($21, $21, $21, $21, $E5). Format: see IndoorAEntityPointers.
IndoorAEntitiesD1::
	db $23, $21  ; (3, 2): entity $21
	db $34, $21  ; (4, 3): entity $21
	db $45, $21  ; (5, 4): entity $21
	db $56, $21  ; (6, 5): entity $21
	db $25, $e5  ; (5, 2): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D2: 3 ($29, $21, $21). Format: see IndoorAEntityPointers.
IndoorAEntitiesD2::
	db $48, $29  ; (8, 4): entity $29
	db $38, $21  ; (8, 3): entity $21
	db $58, $21  ; (8, 5): entity $21
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D3: 3 ($21, $21, $21). Format: see IndoorAEntityPointers.
IndoorAEntitiesD3::
	db $24, $21  ; (4, 2): entity $21
	db $43, $21  ; (3, 4): entity $21
	db $45, $21  ; (5, 4): entity $21
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D4: 1 ($61). Format: see IndoorAEntityPointers.
IndoorAEntitiesD4::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D5: 4 ($9D, $9D, $27, $27). Format: see IndoorAEntityPointers.
IndoorAEntitiesD5::
	db $43, $9d  ; (3, 4): entity $9D
	db $46, $9d  ; (6, 4): entity $9D
	db $13, $27  ; (3, 1): entity $27
	db $16, $27  ; (6, 1): entity $27
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D6: 1 ($9A). Format: see IndoorAEntityPointers.
IndoorAEntitiesD6::
	db $00, $9a  ; (0, 0): entity $9A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D7: 4 ($9C, $9C, $27, $2D). Format: see IndoorAEntityPointers.
IndoorAEntitiesD7::
	db $32, $9c  ; (2, 3): entity $9C
	db $36, $9c  ; (6, 3): entity $9C
	db $68, $27  ; (8, 6): entity $27
	db $11, $2d  ; (1, 1): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D8: 3 ($DB, $9F, $9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesD8::
	db $25, $db  ; (5, 2): entity $DB
	db $64, $9f  ; (4, 6): entity $9F
	db $66, $9f  ; (6, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $D9: 2 ($DB, $9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesD9::
	db $12, $db  ; (2, 1): entity $DB
	db $64, $9f  ; (4, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $DA: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesDA::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $DB: 3 ($17, $16, $9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesDB::
	db $25, $17  ; (5, 2): entity $17
	db $53, $16  ; (3, 5): entity $16
	db $66, $9f  ; (6, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $DC: 4 ($D7, $D7, $D7, $D7). Format: see IndoorAEntityPointers.
IndoorAEntitiesDC::
	db $24, $d7  ; (4, 2): entity $D7
	db $25, $d7  ; (5, 2): entity $D7
	db $26, $d7  ; (6, 2): entity $D7
	db $27, $d7  ; (7, 2): entity $D7
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $DD: 3 ($D7, $D7, $D7). Format: see IndoorAEntityPointers.
IndoorAEntitiesDD::
	db $22, $d7  ; (2, 2): entity $D7
	db $24, $d7  ; (4, 2): entity $D7
	db $33, $d7  ; (3, 3): entity $D7
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $DE: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesDE::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $DF: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesDF::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A rooms $E0, $E1, $E2: 1 ($CA). Format: see IndoorAEntityPointers.
IndoorAEntitiesE0::
	db $34, $ca  ; (4, 3): entity $CA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $E3: 1 ($3D). Format: see IndoorAEntityPointers.
IndoorAEntitiesE3::
	db $68, $3d  ; (8, 6): entity $3D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $E4: 1 ($DC). Format: see IndoorAEntityPointers.
IndoorAEntitiesE4::
	db $34, $dc  ; (4, 3): entity $DC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $E5: 1 ($CC). Format: see IndoorAEntityPointers.
IndoorAEntitiesE5::
	db $55, $cc  ; (5, 5): entity $CC
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $E6: 1 ($CC). Format: see IndoorAEntityPointers.
IndoorAEntitiesE6::
	db $53, $cc  ; (3, 5): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $E7: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesE7::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $E8: 1 ($35). Format: see IndoorAEntityPointers.
IndoorAEntitiesE8::
	db $14, $35  ; (4, 1): entity $35
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $E9: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesE9::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $EA: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesEA::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $EB: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesEB::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $EC: 2 ($9F, $9F). Format: see IndoorAEntityPointers.
IndoorAEntitiesEC::
	db $62, $9f  ; (2, 6): entity $9F
	db $64, $9f  ; (4, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $ED: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesED::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $EE: 1 ($E2). Format: see IndoorAEntityPointers.
IndoorAEntitiesEE::
	db $08, $e2  ; (8, 0): entity $E2
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $EF: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesEF::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F0: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesF0::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F1: 2 ($CC, $CC). Format: see IndoorAEntityPointers.
IndoorAEntitiesF1::
	db $53, $cc  ; (3, 5): entity $CC
	db $64, $cc  ; (4, 6): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F2: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesF2::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F3: 1 ($84). Format: see IndoorAEntityPointers.
IndoorAEntitiesF3::
	db $24, $84  ; (4, 2): entity $84
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F4: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesF4::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F5: 1 ($8F). Format: see IndoorAEntityPointers.
IndoorAEntitiesF5::
	db $14, $8f  ; (4, 1): entity $8F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F6: 1 ($CC). Format: see IndoorAEntityPointers.
IndoorAEntitiesF6::
	db $15, $cc  ; (5, 1): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F7: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesF7::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F8: 4 ($30, $B0, $B0, $B0). Format: see IndoorAEntityPointers.
IndoorAEntitiesF8::
	db $34, $30  ; (4, 3): entity $30
	db $38, $b0  ; (8, 3): entity $B0
	db $42, $b0  ; (2, 4): entity $B0
	db $62, $b0  ; (2, 6): entity $B0
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $F9: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesF9::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group A room $FA: 8 ($DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD). Format: see IndoorAEntityPointers.
IndoorAEntitiesFA::
	db $21, $dd  ; (1, 2): entity $DD
	db $23, $dd  ; (3, 2): entity $DD
	db $26, $dd  ; (6, 2): entity $DD
	db $28, $dd  ; (8, 2): entity $DD
	db $51, $dd  ; (1, 5): entity $DD
	db $53, $dd  ; (3, 5): entity $DD
	db $56, $dd  ; (6, 5): entity $DD
	db $58, $dd  ; (8, 5): entity $DD
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $FB: 1 ($84). Format: see IndoorAEntityPointers.
IndoorAEntitiesFB::
	db $24, $84  ; (4, 2): entity $84
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $FC: 3 ($14, $0B, $0B). Format: see IndoorAEntityPointers.
IndoorAEntitiesFC::
	db $14, $14  ; (4, 1): entity $14
	db $23, $0b  ; (3, 2): entity $0B
	db $26, $0b  ; (6, 2): entity $0B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $FD: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesFD::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $FE: none (only the end byte). Format: see IndoorAEntityPointers.
IndoorAEntitiesFE::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group A room $FF: 1 ($65). Format: see IndoorAEntityPointers.
IndoorAEntitiesFF::
	db $26, $65  ; (6, 2): entity $65
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $00: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities00::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $01: 2 ($91, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities01::
	db $33, $91  ; (3, 3): entity $91
	db $57, $9f  ; (7, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $02: 3 ($29, $A0, $A0). Format: see IndoorBEntityPointers.
IndoorBEntities02::
	db $55, $29  ; (5, 5): entity $29
	db $43, $a0  ; (3, 4): entity $A0
	db $58, $a0  ; (8, 5): entity $A0
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $03: 3 ($A0, $A0, $2A). Format: see IndoorBEntityPointers.
IndoorBEntities03::
	db $41, $a0  ; (1, 4): entity $A0
	db $47, $a0  ; (7, 4): entity $A0
	db $54, $2a  ; (4, 5): entity $2A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $04: 3 ($91, $2A, $16). Format: see IndoorBEntityPointers.
IndoorBEntities04::
	db $51, $91  ; (1, 5): entity $91
	db $44, $2a  ; (4, 4): entity $2A
	db $36, $16  ; (6, 3): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $05: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities05::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $06: 1 ($E5). Format: see IndoorBEntityPointers.
IndoorBEntities06::
	db $22, $e5  ; (2, 2): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $07: 3 ($1E, $23, $23). Format: see IndoorBEntityPointers.
IndoorBEntities07::
	db $45, $1e  ; (5, 4): entity $1E
	db $26, $23  ; (6, 2): entity $23
	db $42, $23  ; (2, 4): entity $23
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $08: 2 ($9E, $66). Format: see IndoorBEntityPointers.
IndoorBEntities08::
	db $04, $9e  ; (4, 0): entity $9E
	db $54, $66  ; (4, 5): entity $66
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $09: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities09::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $0A: 3 ($1F, $1F, $17). Format: see IndoorBEntityPointers.
IndoorBEntities0A::
	db $47, $1f  ; (7, 4): entity $1F
	db $25, $1f  ; (5, 2): entity $1F
	db $65, $17  ; (5, 6): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $0B: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities0B::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $0C: 3 ($27, $27, $1F). Format: see IndoorBEntityPointers.
IndoorBEntities0C::
	db $11, $27  ; (1, 1): entity $27
	db $61, $27  ; (1, 6): entity $27
	db $33, $1f  ; (3, 3): entity $1F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $0D: 3 ($21, $38, $38). Format: see IndoorBEntityPointers.
IndoorBEntities0D::
	db $45, $21  ; (5, 4): entity $21
	db $25, $38  ; (5, 2): entity $38
	db $36, $38  ; (6, 3): entity $38
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $0E: 1 ($61). Format: see IndoorBEntityPointers.
IndoorBEntities0E::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $0F: 2 ($27, $27). Format: see IndoorBEntityPointers.
IndoorBEntities0F::
	db $11, $27  ; (1, 1): entity $27
	db $18, $27  ; (8, 1): entity $27
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $10: 4 ($9E, $23, $15, $23). Format: see IndoorBEntityPointers.
IndoorBEntities10::
	db $00, $9e  ; (0, 0): entity $9E
	db $23, $23  ; (3, 2): entity $23
	db $35, $15  ; (5, 3): entity $15
	db $46, $23  ; (6, 4): entity $23
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $11: 3 ($90, $90, $90). Format: see IndoorBEntityPointers.
IndoorBEntities11::
	db $31, $90  ; (1, 3): entity $90
	db $48, $90  ; (8, 4): entity $90
	db $65, $90  ; (5, 6): entity $90
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $12: 3 ($98, $98, $15). Format: see IndoorBEntityPointers.
IndoorBEntities12::
	db $42, $98  ; (2, 4): entity $98
	db $47, $98  ; (7, 4): entity $98
	db $65, $15  ; (5, 6): entity $15
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $13: 2 ($9A, $15). Format: see IndoorBEntityPointers.
IndoorBEntities13::
	db $11, $9a  ; (1, 1): entity $9A
	db $16, $15  ; (6, 1): entity $15
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $14: 1 ($A7). Format: see IndoorBEntityPointers.
IndoorBEntities14::
	db $35, $a7  ; (5, 3): entity $A7
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $15: 4 ($9B, $A7, $9B, $1B). Format: see IndoorBEntityPointers.
IndoorBEntities15::
	db $22, $9b  ; (2, 2): entity $9B
	db $34, $a7  ; (4, 3): entity $A7
	db $45, $9b  ; (5, 4): entity $9B
	db $17, $1b  ; (7, 1): entity $1B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $16: 4 ($69, $42, $46, $47). Format: see IndoorBEntityPointers.
IndoorBEntities16::
	db $08, $69  ; (8, 0): entity $69
	db $01, $42  ; (1, 0): entity $42
	db $21, $46  ; (1, 2): entity $46
	db $51, $47  ; (1, 5): entity $47
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $17: 4 ($16, $17, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities17::
	db $12, $16  ; (2, 1): entity $16
	db $25, $17  ; (5, 2): entity $17
	db $33, $9b  ; (3, 3): entity $9B
	db $57, $9b  ; (7, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $18: 3 ($A7, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities18::
	db $45, $a7  ; (5, 4): entity $A7
	db $37, $9b  ; (7, 3): entity $9B
	db $54, $9b  ; (4, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $19: 3 ($A7, $9B, $E5). Format: see IndoorBEntityPointers.
IndoorBEntities19::
	db $44, $a7  ; (4, 4): entity $A7
	db $52, $9b  ; (2, 5): entity $9B
	db $56, $e5  ; (6, 5): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $1A: 1 ($66). Format: see IndoorBEntityPointers.
IndoorBEntities1A::
	db $68, $66  ; (8, 6): entity $66
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $1B: 3 ($9E, $9E, $89). Format: see IndoorBEntityPointers.
IndoorBEntities1B::
	db $61, $9e  ; (1, 6): entity $9E
	db $68, $9e  ; (8, 6): entity $9E
	db $34, $89  ; (4, 3): entity $89
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $1C: 3 ($90, $90, $90). Format: see IndoorBEntityPointers.
IndoorBEntities1C::
	db $52, $90  ; (2, 5): entity $90
	db $56, $90  ; (6, 5): entity $90
	db $64, $90  ; (4, 6): entity $90
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $1D: 3 ($66, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities1D::
	db $24, $66  ; (4, 2): entity $66
	db $37, $9b  ; (7, 3): entity $9B
	db $63, $9b  ; (3, 6): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $1E: 1 ($15). Format: see IndoorBEntityPointers.
IndoorBEntities1E::
	db $56, $15  ; (6, 5): entity $15
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $1F: 5 ($A0, $A0, $2A, $27, $27). Format: see IndoorBEntityPointers.
IndoorBEntities1F::
	db $22, $a0  ; (2, 2): entity $A0
	db $27, $a0  ; (7, 2): entity $A0
	db $34, $2a  ; (4, 3): entity $2A
	db $51, $27  ; (1, 5): entity $27
	db $58, $27  ; (8, 5): entity $27
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $20: 4 ($98, $98, $1B, $2A). Format: see IndoorBEntityPointers.
IndoorBEntities20::
	db $15, $98  ; (5, 1): entity $98
	db $23, $98  ; (3, 2): entity $98
	db $45, $1b  ; (5, 4): entity $1B
	db $57, $2a  ; (7, 5): entity $2A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $21: 4 ($9F, $16, $2A, $A0). Format: see IndoorBEntityPointers.
IndoorBEntities21::
	db $22, $9f  ; (2, 2): entity $9F
	db $15, $16  ; (5, 1): entity $16
	db $34, $2a  ; (4, 3): entity $2A
	db $47, $a0  ; (7, 4): entity $A0
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $22: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities22::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $23: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities23::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $24: 4 ($66, $17, $17, $17). Format: see IndoorBEntityPointers.
IndoorBEntities24::
	db $21, $66  ; (1, 2): entity $66
	db $26, $17  ; (6, 2): entity $17
	db $51, $17  ; (1, 5): entity $17
	db $58, $17  ; (8, 5): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $25: 4 ($21, $21, $2A, $15). Format: see IndoorBEntityPointers.
IndoorBEntities25::
	db $15, $21  ; (5, 1): entity $21
	db $35, $21  ; (5, 3): entity $21
	db $43, $2a  ; (3, 4): entity $2A
	db $66, $15  ; (6, 6): entity $15
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $26: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities26::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $27: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities27::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $28: 2 ($BC, $61). Format: see IndoorBEntityPointers.
IndoorBEntities28::
	db $04, $bc  ; (4, 0): entity $BC
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $29: 4 ($A0, $A0, $15, $A1). Format: see IndoorBEntityPointers.
IndoorBEntities29::
	db $34, $a0  ; (4, 3): entity $A0
	db $51, $a0  ; (1, 5): entity $A0
	db $63, $15  ; (3, 6): entity $15
	db $56, $a1  ; (6, 5): entity $A1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $2A: 4 ($A0, $24, $24, $86). Format: see IndoorBEntityPointers.
IndoorBEntities2A::
	db $23, $a0  ; (3, 2): entity $A0
	db $47, $24  ; (7, 4): entity $24
	db $64, $24  ; (4, 6): entity $24
	db $34, $86  ; (4, 3): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $2B: 3 ($9F, $9F, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities2B::
	db $25, $9f  ; (5, 2): entity $9F
	db $48, $9f  ; (8, 4): entity $9F
	db $54, $9f  ; (4, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $2C: 1 ($39). Format: see IndoorBEntityPointers.
IndoorBEntities2C::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $2D: 4 ($9F, $9F, $9F, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities2D::
	db $25, $9f  ; (5, 2): entity $9F
	db $47, $9f  ; (7, 4): entity $9F
	db $52, $9f  ; (2, 5): entity $9F
	db $57, $9f  ; (7, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $2E: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities2E::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $2F: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities2F::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $30: 1 ($39). Format: see IndoorBEntityPointers.
IndoorBEntities30::
	db $24, $39  ; (4, 2): entity $39
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $31: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities31::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $32: 1 ($B1). Format: see IndoorBEntityPointers.
IndoorBEntities32::
	db $52, $b1  ; (2, 5): entity $B1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $33: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities33::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $34: 1 ($62). Format: see IndoorBEntityPointers.
IndoorBEntities34::
	db $34, $62  ; (4, 3): entity $62
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $35: 4 ($E5, $E5, $86, $86). Format: see IndoorBEntityPointers.
IndoorBEntities35::
	db $47, $e5  ; (7, 4): entity $E5
	db $56, $e5  ; (6, 5): entity $E5
	db $27, $86  ; (7, 2): entity $86
	db $36, $86  ; (6, 3): entity $86
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $36: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities36::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $37: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities37::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $38: 1 ($8E). Format: see IndoorBEntityPointers.
IndoorBEntities38::
	db $11, $8e  ; (1, 1): entity $8E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $39: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities39::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $3A: 6 ($BD, $A1, $A1, $37, $2F, $37). Format: see IndoorBEntityPointers.
IndoorBEntities3A::
	db $32, $bd  ; (2, 3): entity $BD
	db $33, $a1  ; (3, 3): entity $A1
	db $54, $a1  ; (4, 5): entity $A1
	db $62, $37  ; (2, 6): entity $37
	db $65, $2f  ; (5, 6): entity $2F
	db $66, $37  ; (6, 6): entity $37
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $3B: 1 ($E5). Format: see IndoorBEntityPointers.
IndoorBEntities3B::
	db $31, $e5  ; (1, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $3C: 4 ($9B, $9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities3C::
	db $11, $9b  ; (1, 1): entity $9B
	db $21, $9b  ; (1, 2): entity $9B
	db $23, $9b  ; (3, 2): entity $9B
	db $34, $9b  ; (4, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $3D: 2 ($60, $60). Format: see IndoorBEntityPointers.
IndoorBEntities3D::
	db $32, $60  ; (2, 3): entity $60
	db $55, $60  ; (5, 5): entity $60
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $3E: 4 ($E5, $1F, $1F, $86). Format: see IndoorBEntityPointers.
IndoorBEntities3E::
	db $16, $e5  ; (6, 1): entity $E5
	db $34, $1f  ; (4, 3): entity $1F
	db $36, $1f  ; (6, 3): entity $1F
	db $25, $86  ; (5, 2): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $3F: 2 ($BE, $61). Format: see IndoorBEntityPointers.
IndoorBEntities3F::
	db $35, $be  ; (5, 3): entity $BE
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $40: 1 ($2A). Format: see IndoorBEntityPointers.
IndoorBEntities40::
	db $63, $2a  ; (3, 6): entity $2A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $41: 2 ($17, $17). Format: see IndoorBEntityPointers.
IndoorBEntities41::
	db $33, $17  ; (3, 3): entity $17
	db $36, $17  ; (6, 3): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $42: 3 ($A1, $A0, $A1). Format: see IndoorBEntityPointers.
IndoorBEntities42::
	db $14, $a1  ; (4, 1): entity $A1
	db $34, $a0  ; (4, 3): entity $A0
	db $56, $a1  ; (6, 5): entity $A1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $43: 1 ($A1). Format: see IndoorBEntityPointers.
IndoorBEntities43::
	db $34, $a1  ; (4, 3): entity $A1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $44: 4 ($16, $16, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities44::
	db $16, $16  ; (6, 1): entity $16
	db $17, $16  ; (7, 1): entity $16
	db $42, $9b  ; (2, 4): entity $9B
	db $52, $9b  ; (2, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $45: 5 ($9B, $9B, $9B, $9B, $86). Format: see IndoorBEntityPointers.
IndoorBEntities45::
	db $23, $9b  ; (3, 2): entity $9B
	db $26, $9b  ; (6, 2): entity $9B
	db $53, $9b  ; (3, 5): entity $9B
	db $56, $9b  ; (6, 5): entity $9B
	db $38, $86  ; (8, 3): entity $86
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $46: 2 ($A1, $A1). Format: see IndoorBEntityPointers.
IndoorBEntities46::
	db $31, $a1  ; (1, 3): entity $A1
	db $38, $a1  ; (8, 3): entity $A1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $47: 3 ($86, $E5, $E5). Format: see IndoorBEntityPointers.
IndoorBEntities47::
	db $32, $86  ; (2, 3): entity $86
	db $43, $e5  ; (3, 4): entity $E5
	db $52, $e5  ; (2, 5): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $48: 3 ($A0, $A0, $A0). Format: see IndoorBEntityPointers.
IndoorBEntities48::
	db $23, $a0  ; (3, 2): entity $A0
	db $45, $a0  ; (5, 4): entity $A0
	db $27, $a0  ; (7, 2): entity $A0
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $49: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities49::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $4A: 2 ($BD, $E5). Format: see IndoorBEntityPointers.
IndoorBEntities4A::
	db $23, $bd  ; (3, 2): entity $BD
	db $36, $e5  ; (6, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $4B: 5 ($27, $27, $27, $27, $1E). Format: see IndoorBEntityPointers.
IndoorBEntities4B::
	db $11, $27  ; (1, 1): entity $27
	db $18, $27  ; (8, 1): entity $27
	db $61, $27  ; (1, 6): entity $27
	db $68, $27  ; (8, 6): entity $27
	db $47, $1e  ; (7, 4): entity $1E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $4C: 2 ($16, $BD). Format: see IndoorBEntityPointers.
IndoorBEntities4C::
	db $16, $16  ; (6, 1): entity $16
	db $34, $bd  ; (4, 3): entity $BD
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $4D: 1 ($B1). Format: see IndoorBEntityPointers.
IndoorBEntities4D::
	db $36, $b1  ; (6, 3): entity $B1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $4E: 1 ($89). Format: see IndoorBEntityPointers.
IndoorBEntities4E::
	db $34, $89  ; (4, 3): entity $89
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $4F: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities4F::
	db $22, $9b  ; (2, 2): entity $9B
	db $24, $9b  ; (4, 2): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $50: 1 ($B1). Format: see IndoorBEntityPointers.
IndoorBEntities50::
	db $53, $b1  ; (3, 5): entity $B1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $51: 1 ($E5). Format: see IndoorBEntityPointers.
IndoorBEntities51::
	db $68, $e5  ; (8, 6): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $52: 1 ($66). Format: see IndoorBEntityPointers.
IndoorBEntities52::
	db $34, $66  ; (4, 3): entity $66
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $53: 4 ($42, $2A, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities53::
	db $51, $42  ; (1, 5): entity $42
	db $18, $2a  ; (8, 1): entity $2A
	db $34, $9b  ; (4, 3): entity $9B
	db $55, $9b  ; (5, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $54: 2 ($81, $82). Format: see IndoorBEntityPointers.
IndoorBEntities54::
	db $31, $81  ; (1, 3): entity $81
	db $33, $82  ; (3, 3): entity $82
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $55: 3 ($17, $16, $E5). Format: see IndoorBEntityPointers.
IndoorBEntities55::
	db $46, $17  ; (6, 4): entity $17
	db $47, $16  ; (7, 4): entity $16
	db $62, $e5  ; (2, 6): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $56: 4 ($A1, $A1, $A1, $2A). Format: see IndoorBEntityPointers.
IndoorBEntities56::
	db $22, $a1  ; (2, 2): entity $A1
	db $41, $a1  ; (1, 4): entity $A1
	db $45, $a1  ; (5, 4): entity $A1
	db $54, $2a  ; (4, 5): entity $2A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $57: 1 ($BD). Format: see IndoorBEntityPointers.
IndoorBEntities57::
	db $44, $bd  ; (4, 4): entity $BD
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $58: 4 ($16, $16, $86, $2F). Format: see IndoorBEntityPointers.
IndoorBEntities58::
	db $13, $16  ; (3, 1): entity $16
	db $46, $16  ; (6, 4): entity $16
	db $45, $86  ; (5, 4): entity $86
	db $68, $2f  ; (8, 6): entity $2F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $59: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities59::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $5A: 4 ($B1, $9B, $9B, $E5). Format: see IndoorBEntityPointers.
IndoorBEntities5A::
	db $47, $b1  ; (7, 4): entity $B1
	db $42, $9b  ; (2, 4): entity $9B
	db $53, $9b  ; (3, 5): entity $9B
	db $34, $e5  ; (4, 3): entity $E5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $5B: 1 ($92). Format: see IndoorBEntityPointers.
IndoorBEntities5B::
	db $34, $92  ; (4, 3): entity $92
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $5C: 4 ($9B, $9B, $9B, $52). Format: see IndoorBEntityPointers.
IndoorBEntities5C::
	db $33, $9b  ; (3, 3): entity $9B
	db $35, $9b  ; (5, 3): entity $9B
	db $44, $9b  ; (4, 4): entity $9B
	db $67, $52  ; (7, 6): entity $52
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $5D: 1 ($61). Format: see IndoorBEntityPointers.
IndoorBEntities5D::
	db $34, $61  ; (4, 3): entity $61
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $5E: 4 ($28, $28, $9E, $9E). Format: see IndoorBEntityPointers.
IndoorBEntities5E::
	db $26, $28  ; (6, 2): entity $28
	db $53, $28  ; (3, 5): entity $28
	db $61, $9e  ; (1, 6): entity $9E
	db $68, $9e  ; (8, 6): entity $9E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $5F: 4 ($A1, $A1, $A1, $A1). Format: see IndoorBEntityPointers.
IndoorBEntities5F::
	db $15, $a1  ; (5, 1): entity $A1
	db $33, $a1  ; (3, 3): entity $A1
	db $37, $a1  ; (7, 3): entity $A1
	db $45, $a1  ; (5, 4): entity $A1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $60: 2 ($9F, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities60::
	db $13, $9f  ; (3, 1): entity $9F
	db $16, $9f  ; (6, 1): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $61: 2 ($9F, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities61::
	db $43, $9f  ; (3, 4): entity $9F
	db $45, $9f  ; (5, 4): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $62: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities62::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $63: 1 ($9F). Format: see IndoorBEntityPointers.
IndoorBEntities63::
	db $53, $9f  ; (3, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $64: 3 ($A3, $DA, $DA). Format: see IndoorBEntityPointers.
IndoorBEntities64::
	db $43, $a3  ; (3, 4): entity $A3
	db $64, $da  ; (4, 6): entity $DA
	db $67, $da  ; (7, 6): entity $DA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $65: 4 ($A4, $A4, $DA, $DA). Format: see IndoorBEntityPointers.
IndoorBEntities65::
	db $32, $a4  ; (2, 3): entity $A4
	db $55, $a4  ; (5, 5): entity $A4
	db $64, $da  ; (4, 6): entity $DA
	db $67, $da  ; (7, 6): entity $DA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $66: 2 ($9F, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities66::
	db $33, $9f  ; (3, 3): entity $9F
	db $65, $9f  ; (5, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $67: 2 ($DA, $DA). Format: see IndoorBEntityPointers.
IndoorBEntities67::
	db $63, $da  ; (3, 6): entity $DA
	db $65, $da  ; (5, 6): entity $DA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $68: 3 ($A4, $17, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities68::
	db $33, $a4  ; (3, 3): entity $A4
	db $26, $17  ; (6, 2): entity $17
	db $67, $9f  ; (7, 6): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $69: 2 ($A3, $9F). Format: see IndoorBEntityPointers.
IndoorBEntities69::
	db $53, $a3  ; (3, 5): entity $A3
	db $57, $9f  ; (7, 5): entity $9F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $6A: 3 ($DA, $DA, $DA). Format: see IndoorBEntityPointers.
IndoorBEntities6A::
	db $63, $da  ; (3, 6): entity $DA
	db $65, $da  ; (5, 6): entity $DA
	db $67, $da  ; (7, 6): entity $DA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $6B: 2 ($DA, $DA). Format: see IndoorBEntityPointers.
IndoorBEntities6B::
	db $63, $da  ; (3, 6): entity $DA
	db $65, $da  ; (5, 6): entity $DA
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $6C: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities6C::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $6D: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities6D::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $6E: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities6E::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $6F: 1 ($42). Format: see IndoorBEntityPointers.
IndoorBEntities6F::
	db $04, $42  ; (4, 0): entity $42
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $70: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities70::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $71: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities71::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $72: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities72::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $73: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities73::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $74: 1 ($E6). Format: see IndoorBEntityPointers.
IndoorBEntities74::
	db $34, $e6  ; (4, 3): entity $E6
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $75: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities75::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $76: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities76::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $77: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities77::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $78: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities78::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $79: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities79::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $7A: 1 ($30). Format: see IndoorBEntityPointers.
IndoorBEntities7A::
	db $24, $30  ; (4, 2): entity $30
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $7B: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities7B::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $7C: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities7C::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $7D: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities7D::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $7E: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities7E::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $7F: 1 ($88). Format: see IndoorBEntityPointers.
IndoorBEntities7F::
	db $34, $88  ; (4, 3): entity $88
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $80: 4 ($19, $19, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntities80::
	db $05, $19  ; (5, 0): entity $19
	db $13, $19  ; (3, 1): entity $19
	db $22, $19  ; (2, 2): entity $19
	db $34, $19  ; (4, 3): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $81: 3 ($9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities81::
	db $13, $9b  ; (3, 1): entity $9B
	db $14, $9b  ; (4, 1): entity $9B
	db $15, $9b  ; (5, 1): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $82: 4 ($19, $19, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntities82::
	db $04, $19  ; (4, 0): entity $19
	db $16, $19  ; (6, 1): entity $19
	db $34, $19  ; (4, 3): entity $19
	db $37, $19  ; (7, 3): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $83: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities83::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $84: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities84::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $85: 1 ($9B). Format: see IndoorBEntityPointers.
IndoorBEntities85::
	db $48, $9b  ; (8, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $86: 4 ($20, $9B, $9B, $20). Format: see IndoorBEntityPointers.
IndoorBEntities86::
	db $36, $20  ; (6, 3): entity $20
	db $34, $9b  ; (4, 3): entity $9B
	db $47, $9b  ; (7, 4): entity $9B
	db $42, $20  ; (2, 4): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $87: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities87::
	db $41, $9b  ; (1, 4): entity $9B
	db $51, $9b  ; (1, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $88: 4 ($9B, $9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities88::
	db $25, $9b  ; (5, 2): entity $9B
	db $27, $9b  ; (7, 2): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $47, $9b  ; (7, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $89: 2 ($19, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities89::
	db $33, $19  ; (3, 3): entity $19
	db $35, $9b  ; (5, 3): entity $9B
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $8A: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities8A::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $8B: 4 ($19, $19, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntities8B::
	db $23, $19  ; (3, 2): entity $19
	db $26, $19  ; (6, 2): entity $19
	db $43, $19  ; (3, 4): entity $19
	db $46, $19  ; (6, 4): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $8C: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities8C::
	db $44, $9b  ; (4, 4): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $8D: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities8D::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $8E: 4 ($BB, $20, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntities8E::
	db $17, $bb  ; (7, 1): entity $BB
	db $42, $20  ; (2, 4): entity $20
	db $36, $19  ; (6, 3): entity $19
	db $38, $19  ; (8, 3): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $8F: 2 ($37, $37). Format: see IndoorBEntityPointers.
IndoorBEntities8F::
	db $43, $37  ; (3, 4): entity $37
	db $46, $37  ; (6, 4): entity $37
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $90: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities90::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $91: 4 ($19, $BB, $BB, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities91::
	db $16, $19  ; (6, 1): entity $19
	db $25, $bb  ; (5, 2): entity $BB
	db $53, $bb  ; (3, 5): entity $BB
	db $66, $9b  ; (6, 6): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $92: 2 ($9B, $BB). Format: see IndoorBEntityPointers.
IndoorBEntities92::
	db $32, $9b  ; (2, 3): entity $9B
	db $45, $bb  ; (5, 4): entity $BB
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $93: 4 ($BB, $9B, $BB, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities93::
	db $21, $bb  ; (1, 2): entity $BB
	db $24, $9b  ; (4, 2): entity $9B
	db $37, $bb  ; (7, 3): entity $BB
	db $43, $9b  ; (3, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $94: 1 ($9B). Format: see IndoorBEntityPointers.
IndoorBEntities94::
	db $27, $9b  ; (7, 2): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $95: 3 ($9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntities95::
	db $15, $9b  ; (5, 1): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $52, $9b  ; (2, 5): entity $9B
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $96: 1 ($9B). Format: see IndoorBEntityPointers.
IndoorBEntities96::
	db $52, $9b  ; (2, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $97: 7 ($AF, $2D, $2D, $2D, $2D, $2D, $2D). Format: see IndoorBEntityPointers.
IndoorBEntities97::
	db $14, $af  ; (4, 1): entity $AF
	db $11, $2d  ; (1, 1): entity $2D
	db $21, $2d  ; (1, 2): entity $2D
	db $31, $2d  ; (1, 3): entity $2D
	db $18, $2d  ; (8, 1): entity $2D
	db $28, $2d  ; (8, 2): entity $2D
	db $38, $2d  ; (8, 3): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $98: 5 ($1B, $1B, $1B, $28, $28). Format: see IndoorBEntityPointers.
IndoorBEntities98::
	db $22, $1b  ; (2, 2): entity $1B
	db $48, $1b  ; (8, 4): entity $1B
	db $53, $1b  ; (3, 5): entity $1B
	db $25, $28  ; (5, 2): entity $28
	db $41, $28  ; (1, 4): entity $28
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $99: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntities99::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $9A: 1 ($20). Format: see IndoorBEntityPointers.
IndoorBEntities9A::
	db $21, $20  ; (1, 2): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $9B: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntities9B::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $9C: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntities9C::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $9D: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntities9D::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $9E: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntities9E::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $9F: 4 ($DC, $6C, $6C, $6C). Format: see IndoorBEntityPointers.
IndoorBEntities9F::
	db $26, $dc  ; (6, 2): entity $DC
	db $17, $6c  ; (7, 1): entity $6C
	db $36, $6c  ; (6, 3): entity $6C
	db $44, $6c  ; (4, 4): entity $6C
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A0: 1 ($4F). Format: see IndoorBEntityPointers.
IndoorBEntitiesA0::
	db $68, $4f  ; (8, 6): entity $4F
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A1: 1 ($4D). Format: see IndoorBEntityPointers.
IndoorBEntitiesA1::
	db $57, $4d  ; (7, 5): entity $4D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A2: 8 ($40, $2D, $2D, $2D, $2D, $3B, $3B, $E1). Format: see IndoorBEntityPointers.
IndoorBEntitiesA2::
	db $44, $40  ; (4, 4): entity $40
	db $17, $2d  ; (7, 1): entity $2D
	db $21, $2d  ; (1, 2): entity $2D
	db $23, $2d  ; (3, 2): entity $2D
	db $61, $2d  ; (1, 6): entity $2D
	db $32, $3b  ; (2, 3): entity $3B
	db $37, $3b  ; (7, 3): entity $3B
	db $24, $e1  ; (4, 2): entity $E1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A3: 4 ($3E, $3F, $2D, $2D). Format: see IndoorBEntityPointers.
IndoorBEntitiesA3::
	db $35, $3e  ; (5, 3): entity $3E
	db $47, $3f  ; (7, 4): entity $3F
	db $61, $2d  ; (1, 6): entity $2D
	db $62, $2d  ; (2, 6): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A4: 1 ($35). Format: see IndoorBEntityPointers.
IndoorBEntitiesA4::
	db $44, $35  ; (4, 4): entity $35
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A5: 1 ($2E). Format: see IndoorBEntityPointers.
IndoorBEntitiesA5::
	db $23, $2e  ; (3, 2): entity $2E
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A6: 2 ($74, $B6). Format: see IndoorBEntityPointers.
IndoorBEntitiesA6::
	db $32, $74  ; (2, 3): entity $74
	db $24, $b6  ; (4, 2): entity $B6
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A7: 2 ($78, $79). Format: see IndoorBEntityPointers.
IndoorBEntitiesA7::
	db $22, $78  ; (2, 2): entity $78
	db $34, $79  ; (4, 3): entity $79
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A8: 2 ($76, $85). Format: see IndoorBEntityPointers.
IndoorBEntitiesA8::
	db $34, $76  ; (4, 3): entity $76
	db $26, $85  ; (6, 2): entity $85
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $A9: 2 ($80, $77). Format: see IndoorBEntityPointers.
IndoorBEntitiesA9::
	db $22, $80  ; (2, 2): entity $80
	db $44, $77  ; (4, 4): entity $77
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $AA: 1 ($83). Format: see IndoorBEntityPointers.
IndoorBEntitiesAA::
	db $35, $83  ; (5, 3): entity $83
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $AB: 1 ($35). Format: see IndoorBEntityPointers.
IndoorBEntitiesAB::
	db $33, $35  ; (3, 3): entity $35
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $AC: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesAC::
	db $33, $9b  ; (3, 3): entity $9B
	db $44, $9b  ; (4, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $AD: 3 ($7B, $E1, $E1). Format: see IndoorBEntityPointers.
IndoorBEntitiesAD::
	db $24, $7b  ; (4, 2): entity $7B
	db $36, $e1  ; (6, 3): entity $E1
	db $52, $e1  ; (2, 5): entity $E1
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $AE: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesAE::
	db $31, $9b  ; (1, 3): entity $9B
	db $53, $9b  ; (3, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $AF: 3 ($9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesAF::
	db $54, $9b  ; (4, 5): entity $9B
	db $55, $9b  ; (5, 5): entity $9B
	db $56, $9b  ; (6, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B0: 1 ($6A). Format: see IndoorBEntityPointers.
IndoorBEntitiesB0::
	db $58, $6a  ; (8, 5): entity $6A
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B1: 1 ($54). Format: see IndoorBEntityPointers.
IndoorBEntitiesB1::
	db $37, $54  ; (7, 3): entity $54
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B2: 2 ($78, $3D). Format: see IndoorBEntityPointers.
IndoorBEntitiesB2::
	db $44, $78  ; (4, 4): entity $78
	db $66, $3d  ; (6, 6): entity $3D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B3: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesB3::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B4: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntitiesB4::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B5: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesB5::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B6: 4 ($19, $19, $20, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesB6::
	db $27, $19  ; (7, 2): entity $19
	db $34, $19  ; (4, 3): entity $19
	db $35, $20  ; (5, 3): entity $20
	db $58, $19  ; (8, 5): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B7: 3 ($9B, $9E, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesB7::
	db $14, $9b  ; (4, 1): entity $9B
	db $20, $9e  ; (0, 2): entity $9E
	db $55, $9b  ; (5, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B8: 3 ($19, $19, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesB8::
	db $26, $19  ; (6, 2): entity $19
	db $27, $19  ; (7, 2): entity $19
	db $46, $9b  ; (6, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $B9: 3 ($19, $19, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesB9::
	db $22, $19  ; (2, 2): entity $19
	db $24, $19  ; (4, 2): entity $19
	db $33, $9b  ; (3, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $BA: 1 ($35). Format: see IndoorBEntityPointers.
IndoorBEntitiesBA::
	db $33, $35  ; (3, 3): entity $35
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $BB: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesBB::
	db $37, $9b  ; (7, 3): entity $9B
	db $42, $9b  ; (2, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $BC: 3 ($9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesBC::
	db $37, $9b  ; (7, 3): entity $9B
	db $45, $9b  ; (5, 4): entity $9B
	db $68, $9b  ; (8, 6): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $BD: 4 ($19, $19, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesBD::
	db $25, $19  ; (5, 2): entity $19
	db $26, $19  ; (6, 2): entity $19
	db $22, $19  ; (2, 2): entity $19
	db $52, $19  ; (2, 5): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $BE: 4 ($28, $28, $28, $28). Format: see IndoorBEntityPointers.
IndoorBEntitiesBE::
	db $14, $28  ; (4, 1): entity $28
	db $17, $28  ; (7, 1): entity $28
	db $31, $28  ; (1, 3): entity $28
	db $51, $28  ; (1, 5): entity $28
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $BF: 5 ($28, $28, $28, $28, $28). Format: see IndoorBEntityPointers.
IndoorBEntitiesBF::
	db $13, $28  ; (3, 1): entity $28
	db $14, $28  ; (4, 1): entity $28
	db $15, $28  ; (5, 1): entity $28
	db $28, $28  ; (8, 2): entity $28
	db $48, $28  ; (8, 4): entity $28
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C0: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesC0::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C1: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesC1::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C2: 2 ($0B, $14). Format: see IndoorBEntityPointers.
IndoorBEntitiesC2::
	db $53, $0b  ; (3, 5): entity $0B
	db $66, $14  ; (6, 6): entity $14
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C3: 3 ($E7, $0B, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesC3::
	db $00, $e7  ; (0, 0): entity $E7
	db $56, $0b  ; (6, 5): entity $0B
	db $64, $19  ; (4, 6): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C4: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesC4::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C5: 3 ($94, $94, $17). Format: see IndoorBEntityPointers.
IndoorBEntitiesC5::
	db $32, $94  ; (2, 3): entity $94
	db $37, $94  ; (7, 3): entity $94
	db $64, $17  ; (4, 6): entity $17
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C6: 1 ($51). Format: see IndoorBEntityPointers.
IndoorBEntitiesC6::
	db $26, $51  ; (6, 2): entity $51
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C7: 5 ($95, $96, $96, $96, $96). Format: see IndoorBEntityPointers.
IndoorBEntitiesC7::
	db $16, $95  ; (6, 1): entity $95
	db $62, $96  ; (2, 6): entity $96
	db $43, $96  ; (3, 4): entity $96
	db $56, $96  ; (6, 5): entity $96
	db $48, $96  ; (8, 4): entity $96
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C8: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesC8::
	db $32, $9b  ; (2, 3): entity $9B
	db $37, $9b  ; (7, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $C9: 1 ($9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesC9::
	db $33, $9b  ; (3, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $CA: 3 ($BB, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesCA::
	db $45, $bb  ; (5, 4): entity $BB
	db $62, $9b  ; (2, 6): entity $9B
	db $64, $9b  ; (4, 6): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $CB: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntitiesCB::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $CC: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntitiesCC::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $CD: 4 ($9B, $9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesCD::
	db $21, $9b  ; (1, 2): entity $9B
	db $27, $9b  ; (7, 2): entity $9B
	db $43, $9b  ; (3, 4): entity $9B
	db $48, $9b  ; (8, 4): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $CE: 1 ($28). Format: see IndoorBEntityPointers.
IndoorBEntitiesCE::
	db $41, $28  ; (1, 4): entity $28
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $CF: 4 ($28, $28, $28, $28). Format: see IndoorBEntityPointers.
IndoorBEntitiesCF::
	db $18, $28  ; (8, 1): entity $28
	db $28, $28  ; (8, 2): entity $28
	db $38, $28  ; (8, 3): entity $28
	db $48, $28  ; (8, 4): entity $28
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D0: 1 ($CC). Format: see IndoorBEntityPointers.
IndoorBEntitiesD0::
	db $46, $cc  ; (6, 4): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D1: 2 ($CC, $CC). Format: see IndoorBEntityPointers.
IndoorBEntitiesD1::
	db $34, $cc  ; (4, 3): entity $CC
	db $55, $cc  ; (5, 5): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D2: 4 ($0B, $0B, $1B, $15). Format: see IndoorBEntityPointers.
IndoorBEntitiesD2::
	db $13, $0b  ; (3, 1): entity $0B
	db $16, $0b  ; (6, 1): entity $0B
	db $32, $1b  ; (2, 3): entity $1B
	db $37, $15  ; (7, 3): entity $15
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D3: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesD3::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D4: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesD4::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D5: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesD5::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D6: 2 ($38, $2D). Format: see IndoorBEntityPointers.
IndoorBEntitiesD6::
	db $31, $38  ; (1, 3): entity $38
	db $48, $2d  ; (8, 4): entity $2D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D7: 1 ($B5). Format: see IndoorBEntityPointers.
IndoorBEntitiesD7::
	db $25, $b5  ; (5, 2): entity $B5
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D8: 2 ($9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesD8::
	db $13, $9b  ; (3, 1): entity $9B
	db $26, $9b  ; (6, 2): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $D9: 2 ($76, $85). Format: see IndoorBEntityPointers.
IndoorBEntitiesD9::
	db $46, $76  ; (6, 4): entity $76
	db $26, $85  ; (6, 2): entity $85
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $DA: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesDA::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $DB: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesDB::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $DC: 1 ($D3). Format: see IndoorBEntityPointers.
IndoorBEntitiesDC::
	db $35, $d3  ; (5, 3): entity $D3
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $DD: 1 ($CD). Format: see IndoorBEntityPointers.
IndoorBEntitiesDD::
	db $45, $cd  ; (5, 4): entity $CD
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $DE: 3 ($19, $19, $20). Format: see IndoorBEntityPointers.
IndoorBEntitiesDE::
	db $26, $19  ; (6, 2): entity $19
	db $51, $19  ; (1, 5): entity $19
	db $56, $20  ; (6, 5): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $DF: 2 ($35, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesDF::
	db $16, $35  ; (6, 1): entity $35
	db $35, $19  ; (5, 3): entity $19
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $E0: 4 ($0B, $0B, $0B, $0B). Format: see IndoorBEntityPointers.
IndoorBEntitiesE0::
	db $14, $0b  ; (4, 1): entity $0B
	db $22, $0b  ; (2, 2): entity $0B
	db $26, $0b  ; (6, 2): entity $0B
	db $48, $0b  ; (8, 4): entity $0B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E1: 1 ($E4). Format: see IndoorBEntityPointers.
IndoorBEntitiesE1::
	db $55, $e4  ; (5, 5): entity $E4
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E2: 1 ($6D). Format: see IndoorBEntityPointers.
IndoorBEntitiesE2::
	db $37, $6d  ; (7, 3): entity $6D
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E3: 1 ($80). Format: see IndoorBEntityPointers.
IndoorBEntitiesE3::
	db $55, $80  ; (5, 5): entity $80
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E4: 1 ($16). Format: see IndoorBEntityPointers.
IndoorBEntitiesE4::
	db $13, $16  ; (3, 1): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E5: 1 ($35). Format: see IndoorBEntityPointers.
IndoorBEntitiesE5::
	db $45, $35  ; (5, 4): entity $35
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E6: 4 ($35, $9B, $9B, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesE6::
	db $13, $35  ; (3, 1): entity $35
	db $34, $9b  ; (4, 3): entity $9B
	db $35, $9b  ; (5, 3): entity $9B
	db $36, $9b  ; (6, 3): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E7: 3 ($19, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesE7::
	db $22, $19  ; (2, 2): entity $19
	db $35, $19  ; (5, 3): entity $19
	db $43, $19  ; (3, 4): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E8: 1 ($63). Format: see IndoorBEntityPointers.
IndoorBEntitiesE8::
	db $43, $63  ; (3, 4): entity $63
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $E9: 1 ($CF). Format: see IndoorBEntityPointers.
IndoorBEntitiesE9::
	db $00, $cf  ; (0, 0): entity $CF
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $EA: 2 ($19, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesEA::
	db $36, $19  ; (6, 3): entity $19
	db $44, $19  ; (4, 4): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $EB: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesEB::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $EC: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesEC::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $ED: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesED::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $EE: 3 ($BB, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesEE::
	db $13, $bb  ; (3, 1): entity $BB
	db $42, $19  ; (2, 4): entity $19
	db $55, $19  ; (5, 5): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $EF: 4 ($BB, $9B, $BB, $9B). Format: see IndoorBEntityPointers.
IndoorBEntitiesEF::
	db $31, $bb  ; (1, 3): entity $BB
	db $35, $9b  ; (5, 3): entity $9B
	db $55, $bb  ; (5, 5): entity $BB
	db $53, $9b  ; (3, 5): entity $9B
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F0: 1 ($14). Format: see IndoorBEntityPointers.
IndoorBEntitiesF0::
	db $36, $14  ; (6, 3): entity $14
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F1: 2 ($CC, $CC). Format: see IndoorBEntityPointers.
IndoorBEntitiesF1::
	db $37, $cc  ; (7, 3): entity $CC
	db $54, $cc  ; (4, 5): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F2: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesF2::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F3: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesF3::
	db $ff  ; end
;@ path: world/indoor/entities
;@ Entities of indoor group B room $F4: 1 ($16). Format: see IndoorBEntityPointers.
IndoorBEntitiesF4::
	db $51, $16  ; (1, 5): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F5: 1 ($B8). Format: see IndoorBEntityPointers.
IndoorBEntitiesF5::
	db $24, $b8  ; (4, 2): entity $B8
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F6: 2 ($20, $16). Format: see IndoorBEntityPointers.
IndoorBEntitiesF6::
	db $13, $20  ; (3, 1): entity $20
	db $43, $16  ; (3, 4): entity $16
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F7: 1 ($20). Format: see IndoorBEntityPointers.
IndoorBEntitiesF7::
	db $23, $20  ; (3, 2): entity $20
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F8: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesF8::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $F9: 2 ($19, $CC). Format: see IndoorBEntityPointers.
IndoorBEntitiesF9::
	db $22, $19  ; (2, 2): entity $19
	db $25, $cc  ; (5, 2): entity $CC
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $FA: 3 ($BB, $19, $19). Format: see IndoorBEntityPointers.
IndoorBEntitiesFA::
	db $25, $bb  ; (5, 2): entity $BB
	db $16, $19  ; (6, 1): entity $19
	db $44, $19  ; (4, 4): entity $19
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $FB: 3 ($C3, $C3, $C3). Format: see IndoorBEntityPointers.
IndoorBEntitiesFB::
	db $14, $c3  ; (4, 1): entity $C3
	db $42, $c3  ; (2, 4): entity $C3
	db $47, $c3  ; (7, 4): entity $C3
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $FC: none (only the end byte). Format: see IndoorBEntityPointers.
IndoorBEntitiesFC::
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $FD: 3 ($C7, $C7, $C7). Format: see IndoorBEntityPointers.
IndoorBEntitiesFD::
	db $35, $c7  ; (5, 3): entity $C7
	db $63, $c7  ; (3, 6): entity $C7
	db $66, $c7  ; (6, 6): entity $C7
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $FE: 1 ($CD). Format: see IndoorBEntityPointers.
IndoorBEntitiesFE::
	db $37, $cd  ; (7, 3): entity $CD
	db $ff  ; end

;@ path: world/indoor/entities
;@ Entities of indoor group B room $FF: 1 ($6A). Format: see IndoorBEntityPointers.
IndoorBEntitiesFF::
	db $34, $6a  ; (4, 3): entity $6A
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $00: 3 ($29, $35, $7A). Format: see OverworldEntityPointers.
OverworldEntities00::
	db $67, $29  ; (7, 6): entity $29
	db $24, $35  ; (4, 2): entity $35
	db $26, $7a  ; (6, 2): entity $7A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $01: 2 ($61, $7A). Format: see OverworldEntityPointers.
OverworldEntities01::
	db $46, $61  ; (6, 4): entity $61
	db $53, $7a  ; (3, 5): entity $7A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $02: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities02::
	db $64, $0b  ; (4, 6): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $03: 1 ($0E). Format: see OverworldEntityPointers.
OverworldEntities03::
	db $63, $0e  ; (3, 6): entity $0E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $04: 1 ($29). Format: see OverworldEntityPointers.
OverworldEntities04::
	db $53, $29  ; (3, 5): entity $29
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $05: 1 ($29). Format: see OverworldEntityPointers.
OverworldEntities05::
	db $45, $29  ; (5, 4): entity $29
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $06: 2 ($DE, $41). Format: see OverworldEntityPointers.
OverworldEntities06::
	db $00, $de  ; (0, 0): entity $DE
	db $f0, $41  ; (0, 15): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $07: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities07::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $08: 2 ($41, $C2). Format: see OverworldEntityPointers.
OverworldEntities08::
	db $00, $41  ; (0, 0): entity $41
	db $24, $c2  ; (4, 2): entity $C2
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $09: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities09::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $0A: 2 ($0D, $0D). Format: see OverworldEntityPointers.
OverworldEntities0A::
	db $32, $0d  ; (2, 3): entity $0D
	db $36, $0d  ; (6, 3): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $0B: 2 ($0D, $0D). Format: see OverworldEntityPointers.
OverworldEntities0B::
	db $12, $0d  ; (2, 1): entity $0D
	db $56, $0d  ; (6, 5): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $0C: 2 ($3D, $BB). Format: see OverworldEntityPointers.
OverworldEntities0C::
	db $28, $3d  ; (8, 2): entity $3D
	db $37, $bb  ; (7, 3): entity $BB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $0D: 1 ($BB). Format: see OverworldEntityPointers.
OverworldEntities0D::
	db $46, $bb  ; (6, 4): entity $BB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $0E: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities0E::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $0F: 2 ($0D, $0D). Format: see OverworldEntityPointers.
OverworldEntities0F::
	db $52, $0d  ; (2, 5): entity $0D
	db $57, $0d  ; (7, 5): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $10: 3 ($7F, $7A, $7A). Format: see OverworldEntityPointers.
OverworldEntities10::
	db $15, $7f  ; (5, 1): entity $7F
	db $13, $7a  ; (3, 1): entity $7A
	db $17, $7a  ; (7, 1): entity $7A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $11: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities11::
	db $33, $0b  ; (3, 3): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $12: 3 ($0E, $23, $0E). Format: see OverworldEntityPointers.
OverworldEntities12::
	db $13, $0e  ; (3, 1): entity $0E
	db $25, $23  ; (5, 2): entity $23
	db $32, $0e  ; (2, 3): entity $0E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $13: 2 ($0B, $23). Format: see OverworldEntityPointers.
OverworldEntities13::
	db $44, $0b  ; (4, 4): entity $0B
	db $55, $23  ; (5, 5): entity $23
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $14: 2 ($29, $45). Format: see OverworldEntityPointers.
OverworldEntities14::
	db $53, $29  ; (3, 5): entity $29
	db $00, $45  ; (0, 0): entity $45
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $15: 1 ($45). Format: see OverworldEntityPointers.
OverworldEntities15::
	db $00, $45  ; (0, 0): entity $45
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $16: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntities16::
	db $35, $41  ; (5, 3): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $17: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntities17::
	db $00, $41  ; (0, 0): entity $41
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $18: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities18::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $19: 1 ($B6). Format: see OverworldEntityPointers.
OverworldEntities19::
	db $26, $b6  ; (6, 2): entity $B6
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $1A: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities1A::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $1B: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities1B::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $1C: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities1C::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $1D: 1 ($0D). Format: see OverworldEntityPointers.
OverworldEntities1D::
	db $23, $0d  ; (3, 2): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $1E: 1 ($0D). Format: see OverworldEntityPointers.
OverworldEntities1E::
	db $56, $0d  ; (6, 5): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $1F: 1 ($0D). Format: see OverworldEntityPointers.
OverworldEntities1F::
	db $57, $0d  ; (7, 5): entity $0D
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $20: 3 ($0B, $23, $23). Format: see OverworldEntityPointers.
OverworldEntities20::
	db $25, $0b  ; (5, 2): entity $0B
	db $32, $23  ; (2, 3): entity $23
	db $45, $23  ; (5, 4): entity $23
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $21: 3 ($23, $0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities21::
	db $36, $23  ; (6, 3): entity $23
	db $53, $0b  ; (3, 5): entity $0B
	db $56, $0b  ; (6, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $22: 3 ($7E, $7E, $CC). Format: see OverworldEntityPointers.
OverworldEntities22::
	db $38, $7e  ; (8, 3): entity $7E
	db $67, $7e  ; (7, 6): entity $7E
	db $53, $cc  ; (3, 5): entity $CC
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $23: 2 ($7C, $CC). Format: see OverworldEntityPointers.
OverworldEntities23::
	db $35, $7c  ; (5, 3): entity $7C
	db $54, $cc  ; (4, 5): entity $CC
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $24: 5 ($7E, $7E, $7E, $7E, $7E). Format: see OverworldEntityPointers.
OverworldEntities24::
	db $22, $7e  ; (2, 2): entity $7E
	db $24, $7e  ; (4, 2): entity $7E
	db $32, $7e  ; (2, 3): entity $7E
	db $34, $7e  ; (4, 3): entity $7E
	db $43, $7e  ; (3, 4): entity $7E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $25: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities25::
	db $43, $0b  ; (3, 4): entity $0B
	db $55, $0b  ; (5, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $26: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities26::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $27: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities27::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $28: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities28::
	db $33, $0b  ; (3, 3): entity $0B
	db $53, $0b  ; (3, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $29: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities29::
	db $55, $0b  ; (5, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $2A: 2 ($0D, $0D). Format: see OverworldEntityPointers.
OverworldEntities2A::
	db $64, $0d  ; (4, 6): entity $0D
	db $67, $0d  ; (7, 6): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $2B: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities2B::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $2C: 2 ($61, $0D). Format: see OverworldEntityPointers.
OverworldEntities2C::
	db $46, $61  ; (6, 4): entity $61
	db $54, $0d  ; (4, 5): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $2D: 1 ($23). Format: see OverworldEntityPointers.
OverworldEntities2D::
	db $53, $23  ; (3, 5): entity $23
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $2E: 1 ($23). Format: see OverworldEntityPointers.
OverworldEntities2E::
	db $47, $23  ; (7, 4): entity $23
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $2F: 2 ($09, $09). Format: see OverworldEntityPointers.
OverworldEntities2F::
	db $43, $09  ; (3, 4): entity $09
	db $54, $09  ; (4, 5): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $30: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities30::
	db $43, $0b  ; (3, 4): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $31: 3 ($0B, $23, $0B). Format: see OverworldEntityPointers.
OverworldEntities31::
	db $22, $0b  ; (2, 2): entity $0B
	db $52, $23  ; (2, 5): entity $23
	db $63, $0b  ; (3, 6): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $32: 1 ($CC). Format: see OverworldEntityPointers.
OverworldEntities32::
	db $27, $cc  ; (7, 2): entity $CC
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $33: 3 ($7C, $7E, $CC). Format: see OverworldEntityPointers.
OverworldEntities33::
	db $17, $7c  ; (7, 1): entity $7C
	db $25, $7e  ; (5, 2): entity $7E
	db $32, $cc  ; (2, 3): entity $CC
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $34: 1 ($CC). Format: see OverworldEntityPointers.
OverworldEntities34::
	db $15, $cc  ; (5, 1): entity $CC
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $35: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities35::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $36: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntities36::
	db $45, $41  ; (5, 4): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $37: 1 ($14). Format: see OverworldEntityPointers.
OverworldEntities37::
	db $24, $14  ; (4, 2): entity $14
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $38: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities38::
	db $42, $0b  ; (2, 4): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $39: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities39::
	db $35, $0b  ; (5, 3): entity $0B
	db $46, $0b  ; (6, 4): entity $0B
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $3A: 2 ($0B, $0D). Format: see OverworldEntityPointers.
OverworldEntities3A::
	db $24, $0b  ; (4, 2): entity $0B
	db $44, $0d  ; (4, 4): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $3B: 1 ($BA). Format: see OverworldEntityPointers.
OverworldEntities3B::
	db $37, $ba  ; (7, 3): entity $BA
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $3C: 2 ($0D, $0D). Format: see OverworldEntityPointers.
OverworldEntities3C::
	db $24, $0d  ; (4, 2): entity $0D
	db $36, $0d  ; (6, 3): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $3D: 1 ($0D). Format: see OverworldEntityPointers.
OverworldEntities3D::
	db $36, $0d  ; (6, 3): entity $0D
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $3E: 2 ($23, $23). Format: see OverworldEntityPointers.
OverworldEntities3E::
	db $26, $23  ; (6, 2): entity $23
	db $37, $23  ; (7, 3): entity $23
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $3F: 1 ($6A). Format: see OverworldEntityPointers.
OverworldEntities3F::
	db $54, $6a  ; (4, 5): entity $6A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $40: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities40::
	db $24, $0b  ; (4, 2): entity $0B
	db $56, $0b  ; (6, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $41: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntities41::
	db $00, $41  ; (0, 0): entity $41
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $42: 3 ($1B, $1B, $0B). Format: see OverworldEntityPointers.
OverworldEntities42::
	db $45, $1b  ; (5, 4): entity $1B
	db $54, $1b  ; (4, 5): entity $1B
	db $47, $0b  ; (7, 4): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $43: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities43::
	db $33, $0b  ; (3, 3): entity $0B
	db $55, $0b  ; (5, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $44: 1 ($35). Format: see OverworldEntityPointers.
OverworldEntities44::
	db $44, $35  ; (4, 4): entity $35
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $45: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities45::
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $46: 2 ($7A, $7A). Format: see OverworldEntityPointers.
OverworldEntities46::
	db $37, $7a  ; (7, 3): entity $7A
	db $54, $7a  ; (4, 5): entity $7A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $47: 2 ($7A, $7A). Format: see OverworldEntityPointers.
OverworldEntities47::
	db $26, $7a  ; (6, 2): entity $7A
	db $53, $7a  ; (3, 5): entity $7A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $48: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities48::
	db $36, $0b  ; (6, 3): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $49: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities49::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $4A: 1 ($14). Format: see OverworldEntityPointers.
OverworldEntities4A::
	db $35, $14  ; (5, 3): entity $14
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $4B: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities4B::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $4C: 1 ($86). Format: see OverworldEntityPointers.
OverworldEntities4C::
	db $44, $86  ; (4, 4): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $4D: 1 ($86). Format: see OverworldEntityPointers.
OverworldEntities4D::
	db $35, $86  ; (5, 3): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $4E: 1 ($86). Format: see OverworldEntityPointers.
OverworldEntities4E::
	db $66, $86  ; (6, 6): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $4F: 3 ($86, $86, $86). Format: see OverworldEntityPointers.
OverworldEntities4F::
	db $26, $86  ; (6, 2): entity $86
	db $35, $86  ; (5, 3): entity $86
	db $48, $86  ; (8, 4): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $50: 1 ($3A). Format: see OverworldEntityPointers.
OverworldEntities50::
	db $32, $3a  ; (2, 3): entity $3A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $51: 1 ($3F). Format: see OverworldEntityPointers.
OverworldEntities51::
	db $37, $3f  ; (7, 3): entity $3F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $52: 2 ($14, $0B). Format: see OverworldEntityPointers.
OverworldEntities52::
	db $42, $14  ; (2, 4): entity $14
	db $45, $0b  ; (5, 4): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $53: 1 ($84). Format: see OverworldEntityPointers.
OverworldEntities53::
	db $34, $84  ; (4, 3): entity $84
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $54: 2 ($B9, $CB). Format: see OverworldEntityPointers.
OverworldEntities54::
	db $37, $b9  ; (7, 3): entity $B9
	db $43, $cb  ; (3, 4): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $55: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities55::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $56: 2 ($7A, $7A). Format: see OverworldEntityPointers.
OverworldEntities56::
	db $23, $7a  ; (3, 2): entity $7A
	db $35, $7a  ; (5, 3): entity $7A
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $57: 2 ($7A, $7A). Format: see OverworldEntityPointers.
OverworldEntities57::
	db $23, $7a  ; (3, 2): entity $7A
	db $46, $7a  ; (6, 4): entity $7A
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $58: 2 ($7A, $14). Format: see OverworldEntityPointers.
OverworldEntities58::
	db $14, $7a  ; (4, 1): entity $7A
	db $47, $14  ; (7, 4): entity $14
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $59: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities59::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $5A: 1 ($93). Format: see OverworldEntityPointers.
OverworldEntities5A::
	db $34, $93  ; (4, 3): entity $93
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $5B: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities5B::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $5C: 3 ($E5, $86, $86). Format: see OverworldEntityPointers.
OverworldEntities5C::
	db $31, $e5  ; (1, 3): entity $E5
	db $41, $86  ; (1, 4): entity $86
	db $52, $86  ; (2, 5): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $5D: 2 ($86, $E5). Format: see OverworldEntityPointers.
OverworldEntities5D::
	db $67, $86  ; (7, 6): entity $86
	db $54, $e5  ; (4, 5): entity $E5
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $5E: 2 ($86, $E5). Format: see OverworldEntityPointers.
OverworldEntities5E::
	db $16, $86  ; (6, 1): entity $86
	db $55, $e5  ; (5, 5): entity $E5
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $5F: 2 ($86, $E5). Format: see OverworldEntityPointers.
OverworldEntities5F::
	db $48, $86  ; (8, 4): entity $86
	db $62, $e5  ; (2, 6): entity $E5
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $60: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities60::
	db $35, $0b  ; (5, 3): entity $0B
	db $55, $0b  ; (5, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $61: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities61::
	db $23, $0b  ; (3, 2): entity $0B
	db $34, $0b  ; (4, 3): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $62: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities62::
	db $65, $0b  ; (5, 6): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $63: 1 ($0B). Format: see OverworldEntityPointers.
OverworldEntities63::
	db $37, $0b  ; (7, 3): entity $0B
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $64: 2 ($41, $44). Format: see OverworldEntityPointers.
OverworldEntities64::
	db $2d, $41  ; (13, 2): entity $41
	db $52, $44  ; (2, 5): entity $44
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $65: 1 ($2F). Format: see OverworldEntityPointers.
OverworldEntities65::
	db $19, $2f  ; (9, 1): entity $2F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $66: 4 ($10, $10, $10, $12). Format: see OverworldEntityPointers.
OverworldEntities66::
	db $37, $10  ; (7, 3): entity $10
	db $53, $10  ; (3, 5): entity $10
	db $57, $10  ; (7, 5): entity $10
	db $45, $12  ; (5, 4): entity $12
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $67: 4 ($10, $10, $12, $11). Format: see OverworldEntityPointers.
OverworldEntities67::
	db $33, $10  ; (3, 3): entity $10
	db $53, $10  ; (3, 5): entity $10
	db $45, $12  ; (5, 4): entity $12
	db $57, $11  ; (7, 5): entity $11
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $68: 1 ($14). Format: see OverworldEntityPointers.
OverworldEntities68::
	db $64, $14  ; (4, 6): entity $14
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $69: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities69::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $6A: 3 ($14, $14, $2F). Format: see OverworldEntityPointers.
OverworldEntities6A::
	db $32, $14  ; (2, 3): entity $14
	db $66, $14  ; (6, 6): entity $14
	db $12, $2f  ; (2, 1): entity $2F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $6B: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities6B::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $6C: 1 ($86). Format: see OverworldEntityPointers.
OverworldEntities6C::
	db $66, $86  ; (6, 6): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $6D: 4 ($E5, $E5, $86, $86). Format: see OverworldEntityPointers.
OverworldEntities6D::
	db $57, $e5  ; (7, 5): entity $E5
	db $58, $e5  ; (8, 5): entity $E5
	db $67, $86  ; (7, 6): entity $86
	db $68, $86  ; (8, 6): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $6E: 1 ($86). Format: see OverworldEntityPointers.
OverworldEntities6E::
	db $24, $86  ; (4, 2): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $6F: 5 ($86, $86, $86, $86, $86). Format: see OverworldEntityPointers.
OverworldEntities6F::
	db $26, $86  ; (6, 2): entity $86
	db $28, $86  ; (8, 2): entity $86
	db $48, $86  ; (8, 4): entity $86
	db $51, $86  ; (1, 5): entity $86
	db $68, $86  ; (8, 6): entity $86
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $70: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntities70::
	db $27, $0b  ; (7, 2): entity $0B
	db $36, $0b  ; (6, 3): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $71: 3 ($1B, $1B, $0B). Format: see OverworldEntityPointers.
OverworldEntities71::
	db $42, $1b  ; (2, 4): entity $1B
	db $66, $1b  ; (6, 6): entity $1B
	db $22, $0b  ; (2, 2): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $72: 3 ($0B, $0B, $1B). Format: see OverworldEntityPointers.
OverworldEntities72::
	db $42, $0b  ; (2, 4): entity $0B
	db $46, $0b  ; (6, 4): entity $0B
	db $32, $1b  ; (2, 3): entity $1B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $73: 3 ($0B, $0B, $1B). Format: see OverworldEntityPointers.
OverworldEntities73::
	db $24, $0b  ; (4, 2): entity $0B
	db $35, $0b  ; (5, 3): entity $0B
	db $57, $1b  ; (7, 5): entity $1B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $74: 2 ($3D, $BF). Format: see OverworldEntityPointers.
OverworldEntities74::
	db $36, $3d  ; (6, 3): entity $3D
	db $00, $bf  ; (0, 0): entity $BF
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $75: 1 ($BF). Format: see OverworldEntityPointers.
OverworldEntities75::
	db $00, $bf  ; (0, 0): entity $BF
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $76: 5 ($BF, $10, $10, $10, $12). Format: see OverworldEntityPointers.
OverworldEntities76::
	db $00, $bf  ; (0, 0): entity $BF
	db $14, $10  ; (4, 1): entity $10
	db $16, $10  ; (6, 1): entity $10
	db $34, $10  ; (4, 3): entity $10
	db $25, $12  ; (5, 2): entity $12
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $77: 4 ($10, $10, $10, $12). Format: see OverworldEntityPointers.
OverworldEntities77::
	db $13, $10  ; (3, 1): entity $10
	db $17, $10  ; (7, 1): entity $10
	db $35, $10  ; (5, 3): entity $10
	db $24, $12  ; (4, 2): entity $12
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $78: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities78::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $79: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities79::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $7A: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities7A::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $7B: 2 ($AF, $AD). Format: see OverworldEntityPointers.
OverworldEntities7B::
	db $24, $af  ; (4, 2): entity $AF
	db $54, $ad  ; (4, 5): entity $AD
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $7C: 3 ($E5, $86, $86). Format: see OverworldEntityPointers.
OverworldEntities7C::
	db $21, $e5  ; (1, 2): entity $E5
	db $28, $86  ; (8, 2): entity $86
	db $31, $86  ; (1, 3): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $7D: 2 ($86, $86). Format: see OverworldEntityPointers.
OverworldEntities7D::
	db $24, $86  ; (4, 2): entity $86
	db $48, $86  ; (8, 4): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $7E: 3 ($86, $86, $86). Format: see OverworldEntityPointers.
OverworldEntities7E::
	db $22, $86  ; (2, 2): entity $86
	db $24, $86  ; (4, 2): entity $86
	db $26, $86  ; (6, 2): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $7F: 4 ($86, $86, $E5, $86). Format: see OverworldEntityPointers.
OverworldEntities7F::
	db $22, $86  ; (2, 2): entity $86
	db $34, $86  ; (4, 3): entity $86
	db $43, $e5  ; (3, 4): entity $E5
	db $45, $86  ; (5, 4): entity $86
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $80: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntities80::
	db $11, $41  ; (1, 1): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $81: 1 ($54). Format: see OverworldEntityPointers.
OverworldEntities81::
	db $46, $54  ; (6, 4): entity $54
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $82: 3 ($6E, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntities82::
	db $26, $6e  ; (6, 2): entity $6E
	db $32, $6e  ; (2, 3): entity $6E
	db $55, $6e  ; (5, 5): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $83: 3 ($70, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntities83::
	db $25, $70  ; (5, 2): entity $70
	db $22, $6e  ; (2, 2): entity $6E
	db $56, $6e  ; (6, 5): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $84: 2 ($6E, $6E). Format: see OverworldEntityPointers.
OverworldEntities84::
	db $23, $6e  ; (3, 2): entity $6E
	db $41, $6e  ; (1, 4): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $85: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities85::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $86: 3 ($B0, $B0, $B0). Format: see OverworldEntityPointers.
OverworldEntities86::
	db $27, $b0  ; (7, 2): entity $B0
	db $34, $b0  ; (4, 3): entity $B0
	db $54, $b0  ; (4, 5): entity $B0
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $87: 2 ($B3, $B4). Format: see OverworldEntityPointers.
OverworldEntities87::
	db $24, $b3  ; (4, 2): entity $B3
	db $45, $b4  ; (5, 4): entity $B4
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $88: 2 ($AE, $AE). Format: see OverworldEntityPointers.
OverworldEntities88::
	db $27, $ae  ; (7, 2): entity $AE
	db $32, $ae  ; (2, 3): entity $AE
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $89: 2 ($B0, $B2). Format: see OverworldEntityPointers.
OverworldEntities89::
	db $34, $b0  ; (4, 3): entity $B0
	db $56, $b2  ; (6, 5): entity $B2
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $8A: 4 ($0B, $0B, $43, $43). Format: see OverworldEntityPointers.
OverworldEntities8A::
	db $54, $0b  ; (4, 5): entity $0B
	db $56, $0b  ; (6, 5): entity $0B
	db $52, $43  ; (2, 5): entity $43
	db $57, $43  ; (7, 5): entity $43
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $8B: 2 ($3D, $CB). Format: see OverworldEntityPointers.
OverworldEntities8B::
	db $44, $3d  ; (4, 4): entity $3D
	db $38, $cb  ; (8, 3): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $8C: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities8C::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $8D: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities8D::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $8E: 2 ($BA, $BA). Format: see OverworldEntityPointers.
OverworldEntities8E::
	db $25, $ba  ; (5, 2): entity $BA
	db $43, $ba  ; (3, 4): entity $BA
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $8F: 1 ($2F). Format: see OverworldEntityPointers.
OverworldEntities8F::
	db $26, $2f  ; (6, 2): entity $2F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $90: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities90::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $91: 4 ($38, $6C, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntities91::
	db $22, $38  ; (2, 2): entity $38
	db $44, $6c  ; (4, 4): entity $6C
	db $26, $6e  ; (6, 2): entity $6E
	db $32, $6e  ; (2, 3): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $92: 7 ($73, $3E, $6F, $6E, $6E, $6E, $DC). Format: see OverworldEntityPointers.
OverworldEntities92::
	db $57, $73  ; (7, 5): entity $73
	db $42, $3e  ; (2, 4): entity $3E
	db $63, $6f  ; (3, 6): entity $6F
	db $11, $6e  ; (1, 1): entity $6E
	db $17, $6e  ; (7, 1): entity $6E
	db $23, $6e  ; (3, 2): entity $6E
	db $45, $dc  ; (5, 4): entity $DC
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $93: 2 ($6C, $6E). Format: see OverworldEntityPointers.
OverworldEntities93::
	db $22, $6c  ; (2, 2): entity $6C
	db $46, $6e  ; (6, 4): entity $6E
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $94: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntities94::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $95: 3 ($61, $AE, $2F). Format: see OverworldEntityPointers.
OverworldEntities95::
	db $46, $61  ; (6, 4): entity $61
	db $25, $ae  ; (5, 2): entity $AE
	db $23, $2f  ; (3, 2): entity $2F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $96: 2 ($B0, $B0). Format: see OverworldEntityPointers.
OverworldEntities96::
	db $23, $b0  ; (3, 2): entity $B0
	db $56, $b0  ; (6, 5): entity $B0
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $97: 1 ($B0). Format: see OverworldEntityPointers.
OverworldEntities97::
	db $22, $b0  ; (2, 2): entity $B0
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $98: 3 ($AE, $AE, $BA). Format: see OverworldEntityPointers.
OverworldEntities98::
	db $12, $ae  ; (2, 1): entity $AE
	db $35, $ae  ; (5, 3): entity $AE
	db $58, $ba  ; (8, 5): entity $BA
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $99: 2 ($AE, $AE). Format: see OverworldEntityPointers.
OverworldEntities99::
	db $33, $ae  ; (3, 3): entity $AE
	db $56, $ae  ; (6, 5): entity $AE
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $9A: 3 ($0B, $14, $0B). Format: see OverworldEntityPointers.
OverworldEntities9A::
	db $46, $0b  ; (6, 4): entity $0B
	db $54, $14  ; (4, 5): entity $14
	db $57, $0b  ; (7, 5): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $9B: 2 ($BA, $CB). Format: see OverworldEntityPointers.
OverworldEntities9B::
	db $44, $ba  ; (4, 4): entity $BA
	db $38, $cb  ; (8, 3): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $9C: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntities9C::
	db $f0, $41  ; (0, 15): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $9D: 3 ($41, $0F, $BA). Format: see OverworldEntityPointers.
OverworldEntities9D::
	db $0f, $41  ; (15, 0): entity $41
	db $22, $0f  ; (2, 2): entity $0F
	db $64, $ba  ; (4, 6): entity $BA
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $9E: 2 ($0D, $0D). Format: see OverworldEntityPointers.
OverworldEntities9E::
	db $43, $0d  ; (3, 4): entity $0D
	db $56, $0d  ; (6, 5): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $9F: 2 ($BA, $0D). Format: see OverworldEntityPointers.
OverworldEntities9F::
	db $44, $ba  ; (4, 4): entity $BA
	db $37, $0d  ; (7, 3): entity $0D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A0: 6 ($6E, $6E, $6E, $2D, $2D, $2D). Format: see OverworldEntityPointers.
OverworldEntitiesA0::
	db $13, $6e  ; (3, 1): entity $6E
	db $26, $6e  ; (6, 2): entity $6E
	db $52, $6e  ; (2, 5): entity $6E
	db $24, $2d  ; (4, 2): entity $2D
	db $25, $2d  ; (5, 2): entity $2D
	db $26, $2d  ; (6, 2): entity $2D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A1: 4 ($6F, $6E, $6E, $6D). Format: see OverworldEntityPointers.
OverworldEntitiesA1::
	db $17, $6f  ; (7, 1): entity $6F
	db $23, $6e  ; (3, 2): entity $6E
	db $58, $6e  ; (8, 5): entity $6E
	db $44, $6d  ; (4, 4): entity $6D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A2: 2 ($2F, $6C). Format: see OverworldEntityPointers.
OverworldEntitiesA2::
	db $27, $2f  ; (7, 2): entity $2F
	db $53, $6c  ; (3, 5): entity $6C
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A3: 4 ($3D, $6E, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntitiesA3::
	db $35, $3d  ; (5, 3): entity $3D
	db $13, $6e  ; (3, 1): entity $6E
	db $32, $6e  ; (2, 3): entity $6E
	db $57, $6e  ; (7, 5): entity $6E
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $A4: 3 ($3D, $AE, $AE). Format: see OverworldEntityPointers.
OverworldEntitiesA4::
	db $26, $3d  ; (6, 2): entity $3D
	db $51, $ae  ; (1, 5): entity $AE
	db $46, $ae  ; (6, 4): entity $AE
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A5: 3 ($AE, $AE, $3D). Format: see OverworldEntityPointers.
OverworldEntitiesA5::
	db $34, $ae  ; (4, 3): entity $AE
	db $65, $ae  ; (5, 6): entity $AE
	db $45, $3d  ; (5, 4): entity $3D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A6: 1 ($3D). Format: see OverworldEntityPointers.
OverworldEntitiesA6::
	db $46, $3d  ; (6, 4): entity $3D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A7: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesA7::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A8: 3 ($3D, $AE, $AE). Format: see OverworldEntityPointers.
OverworldEntitiesA8::
	db $53, $3d  ; (3, 5): entity $3D
	db $46, $ae  ; (6, 4): entity $AE
	db $64, $ae  ; (4, 6): entity $AE
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $A9: 3 ($0B, $0B, $0B). Format: see OverworldEntityPointers.
OverworldEntitiesA9::
	db $33, $0b  ; (3, 3): entity $0B
	db $46, $0b  ; (6, 4): entity $0B
	db $54, $0b  ; (4, 5): entity $0B
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $AA: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesAA::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $AB: 3 ($B9, $BA, $B9). Format: see OverworldEntityPointers.
OverworldEntitiesAB::
	db $28, $b9  ; (8, 2): entity $B9
	db $34, $ba  ; (4, 3): entity $BA
	db $42, $b9  ; (2, 4): entity $B9
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $AC: 3 ($41, $0F, $0F). Format: see OverworldEntityPointers.
OverworldEntitiesAC::
	db $41, $41  ; (1, 4): entity $41
	db $63, $0f  ; (3, 6): entity $0F
	db $67, $0f  ; (7, 6): entity $0F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $AD: 6 ($0F, $0F, $9B, $9B, $9B, $9B). Format: see OverworldEntityPointers.
OverworldEntitiesAD::
	db $23, $0f  ; (3, 2): entity $0F
	db $27, $0f  ; (7, 2): entity $0F
	db $24, $9b  ; (4, 2): entity $9B
	db $26, $9b  ; (6, 2): entity $9B
	db $44, $9b  ; (4, 4): entity $9B
	db $46, $9b  ; (6, 4): entity $9B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $AE: 4 ($0F, $0F, $0F, $0F). Format: see OverworldEntityPointers.
OverworldEntitiesAE::
	db $34, $0f  ; (4, 3): entity $0F
	db $36, $0f  ; (6, 3): entity $0F
	db $54, $0f  ; (4, 5): entity $0F
	db $56, $0f  ; (6, 5): entity $0F
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $AF: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesAF::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B0: 4 ($71, $72, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntitiesB0::
	db $44, $71  ; (4, 4): entity $71
	db $47, $72  ; (7, 4): entity $72
	db $15, $6e  ; (5, 1): entity $6E
	db $17, $6e  ; (7, 1): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B1: 2 ($6C, $75). Format: see OverworldEntityPointers.
OverworldEntitiesB1::
	db $03, $6c  ; (3, 0): entity $6C
	db $57, $75  ; (7, 5): entity $75
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B2: 2 ($6E, $6C). Format: see OverworldEntityPointers.
OverworldEntitiesB2::
	db $23, $6e  ; (3, 2): entity $6E
	db $27, $6c  ; (7, 2): entity $6C
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B3: 5 ($6E, $6E, $6E, $6F, $73). Format: see OverworldEntityPointers.
OverworldEntitiesB3::
	db $26, $6e  ; (6, 2): entity $6E
	db $33, $6e  ; (3, 3): entity $6E
	db $47, $6e  ; (7, 4): entity $6E
	db $22, $6f  ; (2, 2): entity $6F
	db $52, $73  ; (2, 5): entity $73
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B4: 2 ($C0, $14). Format: see OverworldEntityPointers.
OverworldEntitiesB4::
	db $00, $c0  ; (0, 0): entity $C0
	db $42, $14  ; (2, 4): entity $14
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B5: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesB5::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B6: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntitiesB6::
	db $f1, $41  ; (1, 15): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B7: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesB7::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B8: 2 ($BA, $BA). Format: see OverworldEntityPointers.
OverworldEntitiesB8::
	db $37, $ba  ; (7, 3): entity $BA
	db $42, $ba  ; (2, 4): entity $BA
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $B9: 4 ($3D, $0B, $0B, $0B). Format: see OverworldEntityPointers.
OverworldEntitiesB9::
	db $34, $3d  ; (4, 3): entity $3D
	db $22, $0b  ; (2, 2): entity $0B
	db $26, $0b  ; (6, 2): entity $0B
	db $42, $0b  ; (2, 4): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $BA: 2 ($BA, $CB). Format: see OverworldEntityPointers.
OverworldEntitiesBA::
	db $22, $ba  ; (2, 2): entity $BA
	db $55, $cb  ; (5, 5): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $BB: 2 ($B9, $B9). Format: see OverworldEntityPointers.
OverworldEntitiesBB::
	db $46, $b9  ; (6, 4): entity $B9
	db $53, $b9  ; (3, 5): entity $B9
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $BC: 5 ($0F, $0F, $9B, $9B, $9B). Format: see OverworldEntityPointers.
OverworldEntitiesBC::
	db $12, $0f  ; (2, 1): entity $0F
	db $64, $0f  ; (4, 6): entity $0F
	db $13, $9b  ; (3, 1): entity $9B
	db $42, $9b  ; (2, 4): entity $9B
	db $66, $9b  ; (6, 6): entity $9B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $BD: 6 ($0F, $0F, $0F, $0F, $9B, $9B). Format: see OverworldEntityPointers.
OverworldEntitiesBD::
	db $22, $0f  ; (2, 2): entity $0F
	db $26, $0f  ; (6, 2): entity $0F
	db $44, $0f  ; (4, 4): entity $0F
	db $57, $0f  ; (7, 5): entity $0F
	db $25, $9b  ; (5, 2): entity $9B
	db $32, $9b  ; (2, 3): entity $9B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $BE: 6 ($0F, $0F, $0F, $9B, $9B, $9B). Format: see OverworldEntityPointers.
OverworldEntitiesBE::
	db $12, $0f  ; (2, 1): entity $0F
	db $14, $0f  ; (4, 1): entity $0F
	db $46, $0f  ; (6, 4): entity $0F
	db $41, $9b  ; (1, 4): entity $9B
	db $53, $9b  ; (3, 5): entity $9B
	db $56, $9b  ; (6, 5): entity $9B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $BF: 5 ($0F, $0F, $0F, $1B, $9B). Format: see OverworldEntityPointers.
OverworldEntitiesBF::
	db $31, $0f  ; (1, 3): entity $0F
	db $35, $0f  ; (5, 3): entity $0F
	db $53, $0f  ; (3, 5): entity $0F
	db $23, $1b  ; (3, 2): entity $1B
	db $26, $9b  ; (6, 2): entity $9B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C0: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesC0::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C1: 2 ($09, $09). Format: see OverworldEntityPointers.
OverworldEntitiesC1::
	db $33, $09  ; (3, 3): entity $09
	db $54, $09  ; (4, 5): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C2: 3 ($09, $09, $09). Format: see OverworldEntityPointers.
OverworldEntitiesC2::
	db $13, $09  ; (3, 1): entity $09
	db $26, $09  ; (6, 2): entity $09
	db $56, $09  ; (6, 5): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C3: 3 ($09, $09, $09). Format: see OverworldEntityPointers.
OverworldEntitiesC3::
	db $24, $09  ; (4, 2): entity $09
	db $47, $09  ; (7, 4): entity $09
	db $52, $09  ; (2, 5): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C4: 4 ($C0, $9B, $9B, $1B). Format: see OverworldEntityPointers.
OverworldEntitiesC4::
	db $00, $c0  ; (0, 0): entity $C0
	db $23, $9b  ; (3, 2): entity $9B
	db $44, $9b  ; (4, 4): entity $9B
	db $56, $1b  ; (6, 5): entity $1B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C5: 3 ($C0, $9B, $9B). Format: see OverworldEntityPointers.
OverworldEntitiesC5::
	db $00, $c0  ; (0, 0): entity $C0
	db $43, $9b  ; (3, 4): entity $9B
	db $58, $9b  ; (8, 5): entity $9B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C6: 1 ($3C). Format: see OverworldEntityPointers.
OverworldEntitiesC6::
	db $27, $3c  ; (7, 2): entity $3C
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C7: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesC7::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C8: 2 ($0B, $0B). Format: see OverworldEntityPointers.
OverworldEntitiesC8::
	db $35, $0b  ; (5, 3): entity $0B
	db $44, $0b  ; (4, 4): entity $0B
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $C9: 1 ($B7). Format: see OverworldEntityPointers.
OverworldEntitiesC9::
	db $47, $b7  ; (7, 4): entity $B7
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $CA: 3 ($CB, $CB, $CB). Format: see OverworldEntityPointers.
OverworldEntitiesCA::
	db $22, $cb  ; (2, 2): entity $CB
	db $36, $cb  ; (6, 3): entity $CB
	db $54, $cb  ; (4, 5): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $CB: 3 ($6E, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntitiesCB::
	db $22, $6e  ; (2, 2): entity $6E
	db $37, $6e  ; (7, 3): entity $6E
	db $54, $6e  ; (4, 5): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $CC: 4 ($D3, $6E, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntitiesCC::
	db $54, $d3  ; (4, 5): entity $D3
	db $22, $6e  ; (2, 2): entity $6E
	db $43, $6e  ; (3, 4): entity $6E
	db $58, $6e  ; (8, 5): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $CD: 4 ($D3, $75, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntitiesCD::
	db $53, $d3  ; (3, 5): entity $D3
	db $56, $75  ; (6, 5): entity $75
	db $54, $6e  ; (4, 5): entity $6E
	db $62, $6e  ; (2, 6): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $CE: 2 ($87, $61). Format: see OverworldEntityPointers.
OverworldEntitiesCE::
	db $43, $87  ; (3, 4): entity $87
	db $00, $61  ; (0, 0): entity $61
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $CF: 2 ($0E, $0E). Format: see OverworldEntityPointers.
OverworldEntitiesCF::
	db $25, $0e  ; (5, 2): entity $0E
	db $33, $0e  ; (3, 3): entity $0E
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $D0: 1 ($09). Format: see OverworldEntityPointers.
OverworldEntitiesD0::
	db $17, $09  ; (7, 1): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D1: 2 ($09, $09). Format: see OverworldEntityPointers.
OverworldEntitiesD1::
	db $37, $09  ; (7, 3): entity $09
	db $43, $09  ; (3, 4): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D2: 2 ($41, $3D). Format: see OverworldEntityPointers.
OverworldEntitiesD2::
	db $45, $41  ; (5, 4): entity $41
	db $43, $3d  ; (3, 4): entity $3D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D3: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesD3::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D4: 3 ($C0, $9B, $BB). Format: see OverworldEntityPointers.
OverworldEntitiesD4::
	db $00, $c0  ; (0, 0): entity $C0
	db $22, $9b  ; (2, 2): entity $9B
	db $36, $bb  ; (6, 3): entity $BB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D5: 5 ($C0, $9B, $9B, $9B, $BB). Format: see OverworldEntityPointers.
OverworldEntitiesD5::
	db $00, $c0  ; (0, 0): entity $C0
	db $24, $9b  ; (4, 2): entity $9B
	db $33, $9b  ; (3, 3): entity $9B
	db $47, $9b  ; (7, 4): entity $9B
	db $64, $bb  ; (4, 6): entity $BB
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $D6: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesD6::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D7: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesD7::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D8: 2 ($BA, $CB). Format: see OverworldEntityPointers.
OverworldEntitiesD8::
	db $32, $ba  ; (2, 3): entity $BA
	db $38, $cb  ; (8, 3): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $D9: 2 ($97, $97). Format: see OverworldEntityPointers.
OverworldEntitiesD9::
	db $52, $97  ; (2, 5): entity $97
	db $54, $97  ; (4, 5): entity $97
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $DA: 3 ($3D, $CB, $CB). Format: see OverworldEntityPointers.
OverworldEntitiesDA::
	db $33, $3d  ; (3, 3): entity $3D
	db $26, $cb  ; (6, 2): entity $CB
	db $62, $cb  ; (2, 6): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $DB: 3 ($BA, $BB, $BB). Format: see OverworldEntityPointers.
OverworldEntitiesDB::
	db $32, $ba  ; (2, 3): entity $BA
	db $34, $bb  ; (4, 3): entity $BB
	db $55, $bb  ; (5, 5): entity $BB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $DC: 7 ($3E, $6E, $D0, $D2, $D0, $D1, $D0). Format: see OverworldEntityPointers.
OverworldEntitiesDC::
	db $35, $3e  ; (5, 3): entity $3E
	db $38, $6e  ; (8, 3): entity $6E
	db $26, $d0  ; (6, 2): entity $D0
	db $23, $d2  ; (3, 2): entity $D2
	db $53, $d0  ; (3, 5): entity $D0
	db $57, $d1  ; (7, 5): entity $D1
	db $65, $d0  ; (5, 6): entity $D0
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $DD: 4 ($D3, $6E, $6E, $6E). Format: see OverworldEntityPointers.
OverworldEntitiesDD::
	db $42, $d3  ; (2, 4): entity $D3
	db $18, $6e  ; (8, 1): entity $6E
	db $33, $6e  ; (3, 3): entity $6E
	db $47, $6e  ; (7, 4): entity $6E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $DE: 3 ($0E, $0E, $0E). Format: see OverworldEntityPointers.
OverworldEntitiesDE::
	db $27, $0e  ; (7, 2): entity $0E
	db $34, $0e  ; (4, 3): entity $0E
	db $57, $0e  ; (7, 5): entity $0E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $DF: 5 ($E3, $E3, $0E, $0E, $44). Format: see OverworldEntityPointers.
OverworldEntitiesDF::
	db $37, $e3  ; (7, 3): entity $E3
	db $63, $e3  ; (3, 6): entity $E3
	db $32, $0e  ; (2, 3): entity $0E
	db $65, $0e  ; (5, 6): entity $0E
	db $66, $44  ; (6, 6): entity $44
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E0: 2 ($09, $09). Format: see OverworldEntityPointers.
OverworldEntitiesE0::
	db $14, $09  ; (4, 1): entity $09
	db $42, $09  ; (2, 4): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E1: 3 ($C5, $C5, $C5). Format: see OverworldEntityPointers.
OverworldEntitiesE1::
	db $23, $c5  ; (3, 2): entity $C5
	db $46, $c5  ; (6, 4): entity $C5
	db $47, $c5  ; (7, 4): entity $C5
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $E2: 4 ($09, $09, $C5, $C5). Format: see OverworldEntityPointers.
OverworldEntitiesE2::
	db $26, $09  ; (6, 2): entity $09
	db $55, $09  ; (5, 5): entity $09
	db $52, $c5  ; (2, 5): entity $C5
	db $62, $c5  ; (2, 6): entity $C5
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E3: 4 ($CD, $CD, $CD, $CD). Format: see OverworldEntityPointers.
OverworldEntitiesE3::
	db $10, $cd  ; (0, 1): entity $CD
	db $16, $cd  ; (6, 1): entity $CD
	db $50, $cd  ; (0, 5): entity $CD
	db $56, $cd  ; (6, 5): entity $CD
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E4: 1 ($E0). Format: see OverworldEntityPointers.
OverworldEntitiesE4::
	db $14, $e0  ; (4, 1): entity $E0
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E5: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesE5::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E6: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesE6::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E7: 1 ($B9). Format: see OverworldEntityPointers.
OverworldEntitiesE7::
	db $34, $b9  ; (4, 3): entity $B9
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E8: 2 ($B9, $B9). Format: see OverworldEntityPointers.
OverworldEntitiesE8::
	db $33, $b9  ; (3, 3): entity $B9
	db $46, $b9  ; (6, 4): entity $B9
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $E9: 2 ($CE, $3D). Format: see OverworldEntityPointers.
OverworldEntitiesE9::
	db $26, $ce  ; (6, 2): entity $CE
	db $62, $3d  ; (2, 6): entity $3D
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $EA: 2 ($97, $B9). Format: see OverworldEntityPointers.
OverworldEntitiesEA::
	db $26, $97  ; (6, 2): entity $97
	db $66, $b9  ; (6, 6): entity $B9
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $EB: 3 ($B9, $BA, $B9). Format: see OverworldEntityPointers.
OverworldEntitiesEB::
	db $32, $b9  ; (2, 3): entity $B9
	db $33, $ba  ; (3, 3): entity $BA
	db $46, $b9  ; (6, 4): entity $B9
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $EC: 1 ($61). Format: see OverworldEntityPointers.
OverworldEntitiesEC::
	db $46, $61  ; (6, 4): entity $61
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $ED: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesED::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $EE: 1 ($41). Format: see OverworldEntityPointers.
OverworldEntitiesEE::
	db $01, $41  ; (1, 0): entity $41
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $EF: 2 ($E3, $E3). Format: see OverworldEntityPointers.
OverworldEntitiesEF::
	db $46, $e3  ; (6, 4): entity $E3
	db $53, $e3  ; (3, 5): entity $E3
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F0: 3 ($0E, $0E, $09). Format: see OverworldEntityPointers.
OverworldEntitiesF0::
	db $44, $0e  ; (4, 4): entity $0E
	db $47, $0e  ; (7, 4): entity $0E
	db $22, $09  ; (2, 2): entity $09
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F1: 3 ($09, $0E, $0E). Format: see OverworldEntityPointers.
OverworldEntitiesF1::
	db $13, $09  ; (3, 1): entity $09
	db $23, $0e  ; (3, 2): entity $0E
	db $45, $0e  ; (5, 4): entity $0E
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F2: 3 ($41, $31, $C5). Format: see OverworldEntityPointers.
OverworldEntitiesF2::
	db $00, $41  ; (0, 0): entity $41
	db $55, $31  ; (5, 5): entity $31
	db $32, $c5  ; (2, 3): entity $C5
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F3: 2 ($C6, $C6). Format: see OverworldEntityPointers.
OverworldEntitiesF3::
	db $32, $c6  ; (2, 3): entity $C6
	db $46, $c6  ; (6, 4): entity $C6
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F4: 3 ($0E, $0E, $C6). Format: see OverworldEntityPointers.
OverworldEntitiesF4::
	db $24, $0e  ; (4, 2): entity $0E
	db $26, $0e  ; (6, 2): entity $0E
	db $28, $c6  ; (8, 2): entity $C6
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F5: 1 ($C1). Format: see OverworldEntityPointers.
OverworldEntitiesF5::
	db $45, $c1  ; (5, 4): entity $C1
	db $ff  ; end
;@ path: world/overworld/entities
;@ Entities of overworld room $F6: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesF6::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F7: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesF7::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F8: 2 ($3D, $CB). Format: see OverworldEntityPointers.
OverworldEntitiesF8::
	db $44, $3d  ; (4, 4): entity $3D
	db $21, $cb  ; (1, 2): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $F9: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesF9::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $FA: 2 ($B9, $CB). Format: see OverworldEntityPointers.
OverworldEntitiesFA::
	db $22, $b9  ; (2, 2): entity $B9
	db $51, $cb  ; (1, 5): entity $CB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $FB: 2 ($B9, $BB). Format: see OverworldEntityPointers.
OverworldEntitiesFB::
	db $24, $b9  ; (4, 2): entity $B9
	db $22, $bb  ; (2, 2): entity $BB
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $FC: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesFC::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $FD: 1 ($C4). Format: see OverworldEntityPointers.
OverworldEntitiesFD::
	db $38, $c4  ; (8, 3): entity $C4
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $FE: none (only the end byte). Format: see OverworldEntityPointers.
OverworldEntitiesFE::
	db $ff  ; end

;@ path: world/overworld/entities
;@ Entities of overworld room $FF: 3 ($3D, $0E, $0E). Format: see OverworldEntityPointers.
OverworldEntitiesFF::
	db $45, $3d  ; (5, 4): entity $3D
	db $23, $0e  ; (3, 2): entity $0E
	db $42, $0e  ; (2, 4): entity $0E
	db $ff  ; end

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank16FreeSpace1::
	db $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
;@ Dialog $080: "Crazy Tracy's Health Spa"
Dialog080::
	db " Crazy Tracy^s  "
	db "  Health Spa"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $081: "Quadruplet's House"
Dialog081::
	db "Quadruplet^s    "
	db "      House"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $082: "Dream Shrine"
Dialog082::
	db "  Dream Shrine  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $083: "Telephone Booth"
Dialog083::
	db "Telephone Booth "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $084: "Seashell Mansion"
Dialog084::
	db "Seashell Mansion"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $085: "Richard's Villa"
Dialog085::
	db "Richard^s Villa "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $086: "Hen House"
Dialog086::
	db "     Hen House  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $087: "Village Library"
Dialog087::
	db "Village Library "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $088: "Raft Shop"
Dialog088::
	db "    Raft Shop   "
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $089: "Warp Hole"
Dialog089::
	db "    Warp Hole   "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $08A: "This rock has many cracks... There must be some way to shatter it..."
Dialog08A::
	db "This rock has   "
	db "many cracks...  "
	db "There must be   "
	db "some way to     "
	db "shatter it..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $08B: "Oh? What a weird object! There must be some way to tackle this obst..."
Dialog08B::
	db "Oh? What a weird"
	db "object!  There  "
	db "must be some way"
	db "to tackle this  "
	db "obstacle."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $08C: "Hunh? This rock has a key hole! You should come back with a key!"
Dialog08C::
	db "Hunh?  This rock"
	db "has a key hole! "
	db "You should come "
	db "back with a key!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $08D: "Wow! This looks pretty heavy! You won't be able to lift it with jus..."
Dialog08D::
	db "Wow!  This looks"
	db "pretty heavy!   "
	db "You won^t be    "
	db "able to lift it "
	db "with just your  "
	db "bare hands..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $08E: "Well, it's an Ocarina, but you don't know how to play it..."
Dialog08E::
	db "Well, it^s an   "
	db "Ocarina, but you"
	db "don^t know how  "
	db "to play it..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $08F: "No! No! Poor hen! Stop that!"
Dialog08F::
	db "No!  No!  Poor  "
	db "hen!  Stop that!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $090: "You found the Power Bracelet! At last, you can pick up pots and sto..." (B does not hurry it)
Dialog090::
	db "You found the   "
	db "Power Bracelet! "
	db "At last, you can"
	db "pick up pots and"
	db "stones!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $091: "You got your Shield back! You can use it to flip enemies!" (B does not hurry it)
Dialog091::
	db "You got your    "
	db "Shield back!    "
	db "You can use it  "
	db "to flip enemies!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $092: "Ahhh... Yess... That dust was so refreshing... For that, I'll tell ..." (B does not hurry it)
Dialog092::
	db "Ahhh... Yess... "
	db "That dust was so"
	db "refreshing...   "
	db "For that, I^ll  "
	db "tell you a hint!"
	db "Use a Bomb in a "
	db "place where the "
	db "sand swallows   "
	db "you... There is "
	db "a treat on the  "
	db "other side of   "
	db "the wall... Bye!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $093: "You've got the Hook Shot! Its chain stretches long when you use it!" (B does not hurry it)
Dialog093::
	db "You^ve got the  "
	db "Hook Shot!  Its "
	db "chain stretches "
	db "long when you   "
	db "use it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $094: "You've got the Magic Rod! Now you can burn things! Burn it! Burn, b..." (B does not hurry it)
Dialog094::
	db "You^ve got the  "
	db "Magic Rod!  Now "
	db "you can burn    "
	db "things! Burn it!"
	db "Burn, baby burn!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $095: "You've got the Pegasus Boots! If you hold down the Button, you can ..." (B does not hurry it)
Dialog095::
	db "You^ve got the  "
	db "Pegasus Boots!  "
	db "If you hold down"
	db "the Button, you "
	db "can dash!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $096: "You've got the Ocarina! You should learn to play many songs!" (B does not hurry it)
Dialog096::
	db "You^ve got the  "
	db "Ocarina!  You   "
	db "should learn to "
	db "play many songs!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $097: "You've got the Roc's Feather! It feels like your body is a lot ligh..." (B does not hurry it)
Dialog097::
	db "You^ve got the  "
	db "Roc^s Feather!  "
	db "It feels like   "
	db "your body is a  "
	db "lot lighter!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $098: "You've got a Shovel! Now you can feel the joy of digging!" (B does not hurry it)
Dialog098::
	db "You^ve got a    "
	db "Shovel!  Now you"
	db "can feel the joy"
	db "of digging!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $099: "You've got some Magic Powder! Try sprinkling it on a variety of thi..." (B does not hurry it)
Dialog099::
	db "You^ve got some "
	db "Magic Powder!   "
	db "Try sprinkling  "
	db "it on a variety "
	db "of things!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $09A, $09B: "You found your Sword! It must be yours because it has your name eng..." (B does not hurry it)
Dialog09A::
	db "You found your  "
	db "Sword!  It must "
	db "be yours because"
	db "it has your name"
	db "engraved on it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $09C: "You've got the Flippers! If you press the B Button while you swim, ..." (B does not hurry it)
Dialog09C::
	db "You^ve got the  "
	db "Flippers! If you"
	db "press the B     "
	db "Button while you"
	db "swim, you can   "
	db "dive underwater!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $09D: "You've got the Magnifying Lens! This will reveal many things you co..." (B does not hurry it)
Dialog09D::
	db "You^ve got the  "
	db "Magnifying Lens!"
	db "This will reveal"
	db "many things you "
	db "couldn^t see    "
	db "before!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $09E, $09F: "You've got a new Sword! You should put your name on it right away!" (B does not hurry it)
Dialog09E::
	db "You^ve got a    "
	db "new Sword!  You "
	db "should put your "
	db "name on it right"
	db "away!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0A0, $0A1: "You've got the Tail Key! Now you can open the Tail Cave gate!" (B does not hurry it)
Dialog0A0::
	db "You^ve got the  "
	db "Tail Key!  Now  "
	db "you can open the"
	db "Tail Cave gate!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A2: "You've got the Slime Key! Now you can open the gate in Ukuku Prairie!" (B does not hurry it)
Dialog0A2::
	db "You^ve got the  "
	db "Slime Key!  Now "
	db "you can open the"
	db "gate in Ukuku   "
	db "Prairie!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A3: "You've got the Angler Key!" (B does not hurry it)
Dialog0A3::
	db "You^ve got the  "
	db "Angler Key!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A4: "You've got the Face Key!" (B does not hurry it)
Dialog0A4::
	db "You^ve got the  "
	db "Face Key!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A5: "You've got the Bird Key!" (B does not hurry it)
Dialog0A5::
	db "You^ve got the  "
	db "Bird Key!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A6: "At last, you got a Map! Press the START Button to look at it!" (B does not hurry it)
Dialog0A6::
	db "At last, you got"
	db "a Map!  Press   "
	db "the START Button"
	db "to look at it!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $0A7: "You've got the Compass! Now, you can see where the chests and Night..." (B does not hurry it)
Dialog0A7::
	db "You^ve got the  "
	db "Compass!  Now,  "
	db "you can see     "
	db "where the chests"
	db "and Nightmare   "
	db "are hidden! This"
	db "Compass has a   "
	db "new feature-- a "
	db "tone will tell  "
	db "you if a key is "
	db "hidden in a room"
	db "when you enter! "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A8: "You found a fragment of a Stone Slab! Now you can read the message ..." (B does not hurry it)
Dialog0A8::
	db "You found a     "
	db "fragment of a   "
	db "Stone Slab!  Now"
	db "you can read the"
	db "message on the  "
	db "wall!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0A9: "You've got the Nightmare's Key! Now you can open the door to the Ni..." (B does not hurry it)
Dialog0A9::
	db "You^ve got the  "
	db "Nightmare^s Key!"
	db "Now you can open"
	db "the door to the "
	db "Nightmare^s     "
	db "Lair!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0AA: "You got a Small Key! You can open a locked door." (B does not hurry it)
Dialog0AA::
	db "You got a Small "
	db "Key!  You can   "
	db "open a locked   "
	db "door."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0AB: "You got 20 Rupees! JOY!" (B does not hurry it)
Dialog0AB::
	db "   You got 20   "
	db "     Rupees!    "
	db "      JOY!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0AC: "You got 50 Rupees! Very Nice!" (B does not hurry it)
Dialog0AC::
	db "    You got 50  "
	db "      Rupees!   "
	db "    Very Nice!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0AD: "You got 100 Rupees! You're Happy!" (B does not hurry it)
Dialog0AD::
	db "   You got 100  "
	db "     Rupees!    "
	db "  You^re Happy!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0AE: "You got 200 Rupees! You're Ecstatic!" (B does not hurry it)
Dialog0AE::
	db "   You got 200  "
	db "     Rupees!    "
	db "You^re Ecstatic!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0AF: "Leave me alone! I'm trying to sit still so Schule can paint my port..." (B does not hurry it)
Dialog0AF::
	db "Leave me alone! "
	db "I^m trying to   "
	db "sit still so    "
	db "Schule can paint"
	db "my portrait!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B0: "BUZZZZZ! BUZZZZ! OUTZZZIDER!" (B does not hurry it)
Dialog0B0::
	db "BUZZZZZ! BUZZZZ!"
	db "   OUTZZZIDER!  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B1: "NEENER NEENER! You can't find me! NYAH NYAH!" (B does not hurry it)
Dialog0B1::
	db "NEENER NEENER!  "
	db "You can^t find  "
	db "me!  NYAH NYAH!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B2: "BLOOOP! BLOOOP! GLUB! GLUB! OGGGH! FOOOOD! BLOOOOP! GLUB!" (B does not hurry it)
Dialog0B2::
	db "BLOOOP! BLOOOP! "
	db "  GLUB!  GLUB!  "
	db "OGGGH!  FOOOOD! "
	db "BLOOOOP!  GLUB!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B3: "Ssso...you are the outsssider, come to wake the Wind Fisssh... KEEE..." (B does not hurry it)
Dialog0B3::
	db "Ssso...you are  "
	db "the outsssider, "
	db "come to wake the"
	db "Wind Fisssh...  "
	db "KEEE-HEE-HEEEH! "
	db "I shall eat you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B4: "HO HO HO! I'm your bad guy this time!! HO HO HO!" (B does not hurry it)
Dialog0B4::
	db "HO HO HO!       "
	db "I^m your bad guy"
	db "this time!!     "
	db "HO HO HO!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B5: "TSSSK, TSSSK! You don't ssseem to know what kind of island thisss i..." (B does not hurry it)
Dialog0B5::
	db "TSSSK, TSSSK!   "
	db "You don^t ssseem"
	db "to know what    "
	db "kind of island  "
	db "thisss iss...   "
	db "KEEE-HEEE-HEEE! "
	db "What a fool...  "
	db "KEE-HEE-HEH!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B6: "Hey dummy! Need a hint? My weak point is... !! Whoops! There I go, ..." (B does not hurry it)
Dialog0B6::
	db "Hey dummy! Need "
	db "a hint?  My weak"
	db "point is... !!  "
	db "Whoops!  There I"
	db "go, talking too "
	db "much again..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0B7: "Okay, listen up! If the Wind Fish wakes up, every- thing on this is..." (B does not hurry it)
Dialog0B7::
	db "Okay, listen up!"
	db "If the Wind Fish"
	db "wakes up, every-"
	db "thing on this   "
	db "island will be  "
	db "gone forever!   "
	db "And I do mean..."
	db "EVERYTHING!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0B8, $0B9: "My energy... gone...I...lost! But you will be lost too, if the Wind..." (B does not hurry it)
Dialog0B8::
	db "My energy...    "
	db "gone...I...lost!"
	db "But you will be "
	db "lost too, if the"
	db "Wind Fish wakes!"
	db "Same as me...you"
	db "...are...in...  "
	db "his...dream..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0BA: "BAH! I'm not going to hold back! I'm going to make you wish you wer..." (B does not hurry it)
Dialog0BA::
	db "BAH!  I^m not   "
	db "going to hold   "
	db "back!  I^m going"
	db "to make you wish"
	db "you were never  "
	db "born!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0BB, $0BC: "CRACKLE-FWOOOSH! You're finished! I will never let you play the Ins..." (B does not hurry it)
Dialog0BB::
	db "CRACKLE-FWOOOSH!"
	db "You^re finished!"
	db "I will never let"
	db "you play the    "
	db "Instruments of  "
	db "the Sirens!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0BD: "C-C-CRACKLE! Why did you come here? If it weren't for you, nothing ..." (B does not hurry it)
Dialog0BD::
	db "C-C-CRACKLE!    "
	db "Why did you come"
	db "here?  If it    "
	db "weren^t for you,"
	db "nothing would   "
	db "have to change! "
	db "You cannot wake "
	db "the Wind Fish!  "
	db "Remember, you..."
	db "too...are in... "
	db "...the dream..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0BE, $0BF, $0C0: "Hoot! Ho, brave lad, on your quest to wake the dreamer! Welcome to ..." (B does not hurry it)
Dialog0BE::
	db "Hoot!  Ho, brave"
	db "lad, on your    "
	db "quest to wake   "
	db "the dreamer!    "
	db "Welcome to the  "
	db "Mysterious Wood!"
	db "Much of mystery "
	db "you will find on"
	db "this uncharted  "
	db "Koholint island!"
	db "I^m afraid you  "
	db "may find it a   "
	db "trifle difficult"
	db "to leave the    "
	db "island while the"
	db "Wind Fish naps. "
	db "...By the by,   "
	db "have you ever   "
	db "visited the Tail"
	db "Cave, which is  "
	db "south of the    "
	db "village?  Go    "
	db "there with the  "
	db "key you find in "
	db "this forest...  "
	db "The Wind Fish is"
	db "watching...Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C1: "Hoot! Take the key and go to the Tail Cave. Retrieve the Instrument..." (B does not hurry it)
Dialog0C1::
	db "Hoot!  Take the "
	db "key and go to   "
	db "the Tail Cave.  "
	db "Retrieve the    "
	db "Instrument that "
	db "is hidden there!"
	db "Go now!  The    "
	db "Wind Fish is    "
	db "waiting!  Hooot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C2: "Hoooot! That is an 'Instrument of the Sirens!' I have to admit, at ..." (B does not hurry it)
Dialog0C2::
	db "Hoooot!  That is"
	db "an ^Instrument  "
	db "of the Sirens!^ "
	db "I have to admit,"
	db "at first I did  "
	db "not believe you "
	db "were real...    "
	db "That Instrument,"
	db "along with the  "
	db "seven others in "
	db "the set, has the"
	db "power to wake   "
	db "the Wind Fish!  "
	db "You must collect"
	db "them all!  I was"
	db "instructed to   "
	db "give you direc- "
	db "tions...  Your  "
	db "next goal is    "
	db "north, in       "
	db "Goponga Swamp!! "
	db "Hoot, indeed!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C3: "Hoot! That is a fearsome looking animal you have there! Do not forg..." (B does not hurry it)
Dialog0C3::
	db "Hoot!  That is a"
	db "fearsome looking"
	db "animal you have "
	db "there!  Do not  "
	db "forget, the next"
	db "Instrument is in"
	db "Goponga Swamp!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C4: "Hoooot! The Wind Fish sleeps long and dreamily in the Egg above... ..." (B does not hurry it)
Dialog0C4::
	db "Hoooot! The Wind"
	db "Fish sleeps long"
	db "and dreamily in "
	db "the Egg above..."
	db "When you play   "
	db "the eight Siren "
	db "Instruments in  "
	db "front of the Egg"
	db "he will awaken. "
	db "This, my friend,"
	db "is the only way "
	db "for you to leave"
	db "the island! Hoo!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C5: "Hoot! How many Instruments have you gotten so far? When you play th..." (B does not hurry it)
Dialog0C5::
	db "Hoot!  How many "
	db "Instruments     "
	db "have you gotten "
	db "so far?  When   "
	db "you play the    "
	db "Instruments in  "
	db "front of the    "
	db "Egg, the Wind   "
	db "Fish will wake  "
	db "and you will    "
	db "leave this      "
	db "island.  Now,   "
	db "you must hasten "
	db "to the Yarna    "
	db "Desert!  The    "
	db "dark, monstrous "
	db "inhabitants of  "
	db "the sand will   "
	db "show you the    "
	db "way! Hoot Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C6: "Hoot! The shape of the key shows a fish, swimming up a cascade of w..." (B does not hurry it)
Dialog0C6::
	db "Hoot!  The shape"
	db "of the key shows"
	db "a fish, swimming"
	db "up a cascade of "
	db "water!  Go now  "
	db "to the mountain "
	db "waterfall!  A   "
	db "leap from the   "
	db "top and you will"
	db "reach your goal!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C7: "Hoot! There are two shrines, one to the north, the other to the sou..." (B does not hurry it)
Dialog0C7::
	db "Hoot!  There are"
	db "two shrines, one"
	db "to the north,   "
	db "the other to the"
	db "south.  First,  "
	db "head south,     "
	db "where ancient   "
	db "ruins speak of  "
	db "the Wind Fish..."
	db "You will learn  "
	db "much there..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C8: "Hoot! I see you have read the relief... While it does say the islan..." (B does not hurry it)
Dialog0C8::
	db "Hoot!  I see you"
	db "have read the   "
	db "relief...  While"
	db "it does say the "
	db "island is but a "
	db "dream of the    "
	db "Wind Fish, no   "
	db "one is really   "
	db "sure...  Just as"
	db "you cannot know "
	db "if a chest holds"
	db "treasure until  "
	db "you open it, so "
	db "you cannot tell "
	db "if this is a    "
	db "dream until you "
	db "awaken...  The  "
	db "only one who    "
	db "knows for sure  "
	db "is the Wind     "
	db "Fish...  Trust  "
	db "your feelings..."
	db "Someday you will"
	db "know for sure..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0C9: "Hoot! The many monsters of this island fear that the Wind Fish is a..." (B does not hurry it)
Dialog0C9::
	db "Hoot!  The many "
	db "monsters of this"
	db "island fear that"
	db "the Wind Fish is"
	db "about to awaken!"
	db "The monsters^   "
	db "power is real!  "
	db "They may conquer"
	db "the island and  "
	db "destroy their   "
	db "foes!  That day "
	db "may come soon!  "
	db "Now, go to the  "
	db "mountain tower! "
	db "Fly like a bird!"
	db "Hoot! Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0CA: "The going is much more trying from this point! You have only two mo..." (B does not hurry it)
Dialog0CA::
	db "The going is    "
	db "much more trying"
	db "from this point!"
	db "You have only   "
	db "two more tasks  "
	db "to accomplish!  "
	db "The first is in "
	db "the east part of"
	db "the mountains,  "
	db "the second in   "
	db "the west.  Go!  "
	db "The Wind Fish   "
	db "grows restless!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0CB: "Hoot! It has been some time since our paths crossed, lad. You must ..." (B does not hurry it)
Dialog0CB::
	db "Hoot!  It has   "
	db "been some time  "
	db "since our paths "
	db "crossed, lad.   "
	db "You must dive   "
	db "into the waters "
	db "of Martha^s Bay "
	db "to enter the    "
	db "Catfish^s Maw..."
	db "The closer you  "
	db "get to the Wind "
	db "Fish, the more  "
	db "restless he     "
	db "sleeps.  Carry  "
	db "onward!  Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0CC: "Hoot! That girl sang her song in front of the Egg! Her 'Ballad of t..." (B does not hurry it)
Dialog0CC::
	db "Hoot!  That girl"
	db "sang her song in"
	db "front of the    "
	db "Egg! Her ^Ballad"
	db "of the Wind     "
	db "Fish^ is a song "
	db "of awakening!   "
	db "Did she actually"
	db "intend to wake  "
	db "the Wind Fish?! "
	db "The next Sirens^"
	db "Instrument is in"
	db "the west.  Play "
	db "your melodies so"
	db "the unliving    "
	db "stones might    "
	db "hear!  Show your"
	db "courage!  The   "
	db "Wind Fish waits "
	db "for you!  Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0CD: "The time has come... The Wind Fish awaits... Enter the Egg... Hoot!..." (B does not hurry it)
Dialog0CD::
	db "The time has    "
	db "come... The Wind"
	db "Fish awaits...  "
	db "Enter the Egg..."
	db "Hoot! Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0CE, $0CF: "Hoot! Young lad, I mean... [NAME], the hero! You have defeated the ..." (B does not hurry it)
Dialog0CE::
	db "Hoot! Young lad,"
	db "I mean... #####,"
	db "the hero!  You  "
	db "have defeated   "
	db "the Nightmares! "
	db "You have proven "
	db "your wisdom,    "
	db "courage and     "
	db "power!          "
	db "... ... ... ... "
	db "As part of the  "
	db "Wind Fish^s     "
	db "spirit, I am the"
	db "guardian of his "
	db "dream world...  "
	db "But one day, the"
	db "Nightmares      "
	db "entered the     "
	db "dream and began "
	db "wreaking havoc. "
	db "Then you, #####,"
	db "came to rescue  "
	db "the island...   "
	db "I have always   "
	db "trusted in your "
	db "courage to turn "
	db "back the Night- "
	db "mares.  Thank   "
	db "you, #####... My"
	db "work is done... "
	db "The Wind Fish   "
	db "will wake soon. "
	db "Good bye...Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0D0: "... ... ... ... ... ... ... ... I AM THE WIND FISH... LONG HAS BEEN..." (B does not hurry it)
Dialog0D0::
	db "... ... ... ... "
	db " ... ... ... ..."
	db " I AM THE WIND  "
	db "      FISH...   "
	db " LONG HAS BEEN  "
	db "  MY SLUMBER... "
	db " IN MY DREAMS..."
	db " AN EGG APPEARED"
	db "     AND WAS    "
	db "SURROUNDED BY AN"
	db "  ISLAND, WITH  "
	db "PEOPLE, ANIMALS,"
	db "AN ENTIRE WORLD!"
	db "... ... ... ... "
	db "  BUT, VERILY,  "
	db "IT BE THE NATURE"
	db "  OF DREAMS TO  "
	db "END! WHEN I DOST"
	db "AWAKEN, KOHOLINT"
	db " WILL BE GONE..."
	db "ONLY THE MEMORY "
	db " OF THIS DREAM  "
	db "LAND WILL EXIST "
	db "  IN THE WAKING "
	db "      WORLD...  "
	db " SOMEDAY, THOU  "
	db "MAY RECALL THIS "
	db " ISLAND...  THAT"
	db " MEMORY MUST BE "
	db " THE REAL DREAM "
	db "     WORLD...   "
	db "... ... ... ... "
	db " COME, #####... "
	db "LET US AWAKEN..."
	db "   TOGETHER!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0D1, $0D2: "PLAY THE EIGHT INSTRUMENTS! PLAY THE SONG OF AWAKENING!!" (B does not hurry it)
Dialog0D1::
	db " PLAY THE EIGHT "
	db "  INSTRUMENTS!  "
	db "PLAY THE SONG OF"
	db "   AWAKENING!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0D3, $0D4, $0D5: "Mermaid Statue" (B does not hurry it)
Dialog0D3::
	db "Mermaid Statue  "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $0D6, $0D7: "...[NAME], you have beaten all the Nightmares! Climb the stairs bef..." (B does not hurry it)
Dialog0D6::
	db "...#####, you   "
	db "have beaten all "
	db "the Nightmares! "
	db "Climb the stairs"
	db "before you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0D8: "Ach! Vat are you looking at vith zat magnifying lens? Stop it at vo..." (B does not hurry it)
Dialog0D8::
	db "Ach! Vat are you"
	db "looking at vith "
	db "zat magnifying  "
	db "lens?  Stop it  "
	db "at vonce!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0D9: "Hoot! Hoot! So you are the lad who owns the sword... Now I understa..." (B does not hurry it)
Dialog0D9::
	db "  Hoot!  Hoot!  "
	db "So you are the  "
	db "lad who owns the"
	db "sword...  Now I "
	db "understand why  "
	db "the monsters are"
	db "starting to act "
	db "so violently... "
	db "A courageous lad"
	db "has come to wake"
	db "the Wind Fish..."
	db "It is said that "
	db "you cannot leave"
	db "the island      "
	db "unless you wake "
	db "the Wind Fish..."
	db "You should now  "
	db "go north, to the"
	db "Mysterious      "
	db "Forest.  I will "
	db "wait for you    "
	db "there!  Hoot!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0DA: "Annoyance! You are only getting in the way!"
Dialog0DA::
	db "Annoyance!  You "
	db "are only getting"
	db "in the way!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0DB: "Ribbit! Ribbit! Hey, man, I'm Mamu, on vocals! Brother, you look li..."
Dialog0DB::
	db "Ribbit!  Ribbit!"
	db "Hey, man, I^m   "
	db "Mamu, on vocals!"
	db "Brother, you    "
	db "look like you   "
	db "don^t know      "
	db "squat about     "
	db "music!  Ribbit!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0DC: "Ribbit! Ribbit! I'm Mamu, on vocals! But I don't need to tell you t..."
Dialog0DC::
	db "Ribbit!  Ribbit!"
	db "I^m Mamu, on    "
	db "vocals!  But I  "
	db "don^t need to   "
	db "tell you that,  "
	db "do I?  Everybody"
	db "knows me!  Want "
	db "to hang out and "
	db "listen to us    "
	db "jam?  For 300   "
	db "Rupees, we^ll   "
	db "let you listen  "
	db "to a previously "
	db "unreleased cut! "
	db "What do you do? "
	db "    Pay  Leave"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0DD: "Thank you... Thank you very much... Croak!"
Dialog0DD::
	db "Thank you...    "
	db "Thank you very  "
	db "much... Croak!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0DE: "Well, that's a shame, but we don't play for free!"
Dialog0DE::
	db "Well, that^s a  "
	db "shame, but we   "
	db "don^t play for  "
	db "free!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0DF: "You've learned The Frog's Song of Soul! It's a very moving tune... ..."
Dialog0DF::
	db "You^ve learned  "
	db "The Frog^s Song "
	db "of Soul!  It^s a"
	db "very moving     "
	db "tune... It can  "
	db "even liven up   "
	db "unliving things!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0E0: "If you play this song, you'll make everything around you feel more ..."
Dialog0E0::
	db "If you play this"
	db "song, you^ll    "
	db "make everything "
	db "around you feel "
	db "more alive!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $0E1: "Hey, Kid! You woke me up from a fine nap!! ...Thanks a lot! But now..." (B does not hurry it)
Dialog0E1::
	db "Hey, Kid!  You  "
	db "woke me up from "
	db "a fine nap!!    "
	db "...Thanks a lot!"
	db "But now, I^ll   "
	db "get my revenge! "
	db "Are you ready?! "
	db "    Yes  N-No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0E2: "I'll let you carry more Magic Powder! He He! Are you ready?! Yes N-No" (B does not hurry it)
Dialog0E2::
	db "I^ll let you    "
	db "carry more Magic"
	db "Powder!  He He! "
	db "Are you ready?! "
	db "    Yes  N-No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0E3: "Okay, I'll let you carry more Bombs! He He He! Are you ready?! Yes ..." (B does not hurry it)
Dialog0E3::
	db "Okay, I^ll let  "
	db "you carry more  "
	db "Bombs! He He He!"
	db "Are you ready?! "
	db "    Yes  N-No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0E4: "Fine, I'll let you have more arrows! Heh Heh! Are you ready?! Yes N..." (B does not hurry it)
Dialog0E4::
	db "Fine, I^ll let  "
	db "you have more   "
	db "arrows! Heh Heh!"
	db "Are you ready?! "
	db "    Yes  N-No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $0E5: "Heh Heh Heh! You deserve it! Now look at all that junk you have to ..." (B does not hurry it)
Dialog0E5::
	db "Heh Heh Heh!    "
	db "You deserve it! "
	db "Now look at all "
	db "that junk you   "
	db "have to carry!  "
	db "Hah!  Take care!"
	db "See you again!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $0E6: "?? There is a picture carved on the wall, but you can't see it beca..."
Dialog0E6::
	db "??  There is a  "
	db "picture carved  "
	db "on the wall, but"
	db "you can^t see it"
	db "because it^s too"
	db "dark in here..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $0E7: "TO THE FINDER... THE ISLE OF KOHOLINT, IS BUT AN ILLUSION... HUMAN,..."
Dialog0E7::
	db "TO THE FINDER..."
	db "  THE ISLE OF   "
	db "KOHOLINT, IS BUT"
	db "  AN ILLUSION..."
	db " HUMAN, MONSTER,"
	db " SEA, SKY... A  "
	db "SCENE ON THE LID"
	db " OF A SLEEPER^S "
	db "  EYE...  AWAKE "
	db "THE DREAMER, AND"
	db "  KOHOLINT WILL "
	db "VANISH MUCH LIKE"
	db "  A BUBBLE ON A "
	db "NEEDLE... CAST- "
	db "AWAY, YOU SHOULD"
	db "KNOW THE TRUTH! "
	db "... ... ... ... "
	db "What?  Illusion?"
	db $ff  ; end
;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank16FreeSpace2::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
