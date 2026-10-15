; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

EntityHandlerBankTable::
	db $03, $19, $03, $18, $03, $03, $03, $07, $18, $03, $03, $03, $03, $06, $04, $06
	db $04, $04, $04, $03, $07, $06, $06, $06, $06, $06, $06, $06, $06, $06, $15, $06
	db $06, $06, $06, $06, $03, $03, $03, $06, $19, $04, $04, $15, $07, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $05, $05
	db $05, $06, $18, $15, $15, $15, $15, $15, $15, $15, $03, $03, $04, $04, $04, $04
	db $06, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $05, $05, $07
	db $05, $19, $05, $05, $18, $05, $15, $05, $15, $18, $05, $18, $05, $05, $06, $19
	db $06, $06, $06, $06, $18, $18, $18, $06, $06, $06, $06, $06, $06, $06, $06, $18
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $19
	db $06, $06, $06, $06, $07, $06, $19, $19, $07, $07, $07, $07, $07, $19, $07, $07
	db $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $19, $19, $19, $07, $07, $07
	db $07, $07, $15, $07, $07, $07, $07, $07, $07, $18, $18, $07, $18, $18, $18, $18
	db $18, $18, $18, $18, $18, $15, $15, $18, $18, $18, $18, $18, $15, $19, $18, $19
	db $18, $18, $18, $18, $19, $19, $19, $19, $19, $19, $19, $19, $19, $19, $19, $19
	db $15, $15, $15, $15, $15, $06, $15, $15, $17

EntityPhysicsFlagsTable::
	db $42, $c2, $d2, $c2, $c2, $d2, $c2
	db $c2, $c3, $12, $42, $12, $42, $12, $12, $92, $12, $18, $12, $11, $12, $02, $02
	db $02, $12, $02, $12, $12, $11, $02, $12, $12, $12, $02, $42, $92, $12, $e2, $e2
	db $02, $12, $02, $02, $41, $12, $b1, $b1, $b1, $b1, $b1, $b2, $b2, $b1, $b2, $b2
	db $b2, $b1, $92, $b2, $b1, $b2, $b1, $82, $92, $84, $92, $82, $c0, $c0, $c2, $82
	db $82, $82, $82, $82, $82, $41, $82, $82, $82, $12, $02, $42, $42, $c2, $02, $02
	db $02, $42, $08, $48, $00, $91, $02, $00, $00, $02, $c2, $08, $02, $c0, $00, $82
	db $02, $c0, $c2, $92, $82, $92, $12, $c1, $92, $92, $92, $92, $92, $93, $92, $92
	db $92, $92, $92, $52, $92, $00, $42, $02, $82, $92, $00, $42, $c2, $d1, $d2, $d1
	db $12, $84, $0c, $c2, $c2, $92, $92, $08, $12, $12, $13, $14, $12, $80, $92, $92
	db $c0, $d2, $12, $c0, $d2, $12, $94, $c0, $12, $12, $12, $14, $c4, $c4, $c4, $c2
	db $8a, $92, $02, $12, $12, $12, $92, $12, $b2, $02, $82, $c0, $82, $92, $82, $92
	db $94, $95, $12, $13, $12, $12, $13, $16, $52, $c0, $d2, $d2, $94, $98, $12, $12
	db $d0, $d2, $c1, $88, $02, $52, $85, $84, $c2, $82, $82, $82, $d2, $d2, $d2, $82
	db $02, $c2, $c8, $42, $48, $c4, $c2, $c2, $c2, $d3, $d2, $42, $12, $13, $d2, $50
	db $c0, $00

EntityHitboxFlagsTable::
	db $00, $00, $01, $01, $01, $00, $06, $00, $00, $00, $00, $00, $00, $00
	db $00, $80, $00, $08, $00, $01, $00, $00, $03, $03, $00, $00, $00, $00, $10, $02
	db $00, $00, $00, $00, $00, $00, $00, $80, $80, $82, $00, $00, $80, $00, $80, $1d
	db $1d, $1d, $1d, $1d, $01, $1d, $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $1d, $1d
	db $98, $98, $98, $98, $98, $98, $98, $00, $84, $84, $84, $84, $98, $98, $00, $98
	db $98, $98, $00, $00, $00, $00, $80, $00, $00, $00, $00, $88, $08, $00, $80, $80
	db $80, $a8, $80, $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $98, $00, $80
	db $00, $00, $98, $98, $98, $98, $98, $98, $98, $98, $80, $98, $00, $98, $08, $10
	db $00, $80, $98, $00, $20, $00, $00, $00, $38, $00, $88, $08, $04, $04, $84, $84
	db $88, $00, $00, $00, $80, $00, $00, $80, $80, $00, $00, $00, $00, $00, $00, $a4
	db $00, $00, $00, $00, $00, $2c, $2c, $2c, $30, $a4, $80, $00, $00, $00, $00, $80
	db $00, $1d, $00, $98, $00, $98, $98, $b4, $98, $98, $98, $00, $00, $00, $00, $00
	db $80, $00, $00, $18, $18, $b4, $b4, $06, $00, $34, $98, $00, $80, $00, $00, $98
	db $98, $00, $98, $98, $98, $98, $00, $18, $bd, $80, $2d, $2d, $00, $0a, $00, $00
	db $00, $00, $00, $00, $00, $00, $84, $38, $00, $00, $00

EntityHealthGroupTable::
	db $00, $00, $02, $00, $00
	db $00, $00, $00, $00, $00, $0d, $01, $0d, $01, $01, $08, $13, $13, $13, $00, $01
	db $06, $2c, $2c, $0c, $00, $2a, $00, $00, $00, $2a, $2f, $0b, $0c, $0e, $01, $01
	db $06, $06, $09, $04, $01, $00, $0e, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0e, $00, $00, $00, $20, $13, $00, $00, $00
	db $0b, $0b, $30, $0e, $18, $1d, $1a, $19, $1c, $10, $11, $12, $00, $1f, $1e, $00
	db $1b, $22, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $21, $00, $29, $00, $29, $00, $00, $13, $00, $00, $00
	db $00, $00, $13, $15, $14, $01, $01, $01, $01, $13, $24, $2d, $2e, $13, $25, $23
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00
	db $00, $00, $00, $00, $0f, $2b, $00, $00, $00, $13, $00, $00, $00, $00, $00, $00
	db $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $28, $00, $13
	db $00, $26, $00, $00

EntityOptionsTable::
	db $12, $12, $0a, $12, $12, $0a, $02, $02, $02, $08, $12, $08
	db $12, $08, $00, $40, $11, $11, $11, $00, $08, $12, $12, $12, $08, $11, $08, $08
	db $08, $10, $08, $08, $08, $08, $12, $08, $08, $08, $08, $52, $08, $08, $0a, $12
	db $08, $0a, $0a, $13, $0a, $0a, $0a, $0a, $0a, $0a, $08, $0a, $0a, $08, $0a, $0a
	db $1b, $1a, $02, $02, $02, $02, $02, $02, $02, $42, $02, $02, $02, $02, $02, $02
	db $12, $00, $02, $02, $30, $08, $02, $02, $02, $08, $08, $08, $12, $d0, $90, $90
	db $d0, $90, $d4, $84, $d4, $02, $d0, $90, $02, $80, $02, $42, $12, $02, $02, $02
	db $02, $43, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00
	db $02, $02, $02, $40, $00, $84, $40, $00, $00, $00, $02, $84, $c4, $94, $00, $00
	db $00, $00, $84, $00, $00, $00, $c4, $10, $00, $00, $00, $00, $00, $10, $00, $00
	db $00, $42, $02, $00, $00, $00, $00, $02, $02, $02, $02, $42, $42, $00, $10, $10
	db $08, $18, $00, $13, $00, $12, $00, $02, $02, $02, $02, $02, $02, $00, $01, $00
	db $84, $11, $84, $00, $00, $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $00, $00, $00, $00, $00, $03, $02, $42, $42, $02, $02, $02
	db $02, $02, $02, $12, $02, $02, $02, $02, $00, $02, $00, $02, $02

EntityDamageClassTable::
	db $01, $01, $01
	db $00, $00, $01, $02, $01, $02, $03, $03, $02, $00, $00, $00, $00, $01, $01, $01
	db $00, $00, $02, $02, $02, $02, $03, $03, $02, $00, $00, $00, $00, $01, $01, $01
	db $00, $00, $02, $02, $02, $02, $01, $03, $02, $00, $00, $00, $00, $01, $01, $01
	db $00, $00, $02, $01, $02, $01, $01, $03, $02, $00, $00, $00, $00, $00, $03, $03
	db $00, $00, $00, $01, $00, $01, $00, $00, $01, $00, $00, $00, $00, $00, $00, $03
	db $00, $00, $00, $01, $00, $01, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $02, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $03, $01, $02, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $03, $01, $02, $04, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $01, $01, $01, $01, $03, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $01, $03, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $01, $03, $01, $01, $01, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $02, $01, $02, $02, $02, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $02, $02, $02, $04, $00, $01, $02, $00, $00, $00, $00, $01, $02, $02
	db $00, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $02, $02, $02, $02, $02, $00, $02, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $02, $02, $02, $02, $04, $00, $02, $02, $00, $00, $00, $00, $00, $01, $01
	db $01, $02, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $00, $00, $02, $00, $00, $02, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $00, $02, $00, $00, $01, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $00, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $02, $02, $00, $00, $02, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $00, $00, $00, $00, $02, $01, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $02, $01, $02, $00, $01, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $02, $01, $02, $00, $01, $02, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $01, $02, $01, $00, $03, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $01, $00, $00, $00, $01, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $02, $01, $02, $00, $01, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $02, $01, $02, $00, $01, $02, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01
	db $01, $01, $00, $02, $00, $02, $00, $03, $00, $00, $00, $00, $00, $01, $01, $01
	db $00, $00, $02, $02, $02, $02, $00, $00, $02, $00, $00, $00, $00, $01, $01, $01
	db $00, $00, $02, $00, $00, $05, $02, $03, $03, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $05, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $02, $01, $04, $00, $01, $02, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $02, $04, $00, $02, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $01, $01, $02, $04, $00, $03, $02, $00, $00, $00, $00, $01, $01, $01
	db $01, $01, $02, $02, $01, $01, $00, $03, $02, $00, $00, $00, $00

WeaponDamageTable::
	db $00, $01, $02
	db $40, $00, $00, $00, $00, $00, $02, $01, $40, $00, $00, $00, $00, $00, $04, $02
	db $40, $00, $00, $00, $00, $00, $08, $04, $40, $00, $00, $00, $00, $00, $10, $08
	db $40, $00, $00, $00, $00, $00, $01, $04, $40, $00, $00, $00, $00, $00, $ff, $02
	db $40, $00, $00, $00, $00, $00, $01, $04, $40, $00, $00, $00, $00, $00, $ff, $18
	db $fe, $02, $fd, $00, $00, $00, $ff, $fd, $fe, $00, $00, $00, $00, $00, $01, $04
	db $fe, $00, $00, $00, $00, $00, $ff, $02, $40, $00, $00, $00, $00, $00, $01, $02
	db $40, $00, $00, $00, $00, $00, $01, $02, $40, $00, $00, $00, $00, $00, $01, $02
	db $40, $00, $00, $00, $00, $00, $01, $02, $40, $00, $00, $00, $00

EntityHealthTable::
	db $01, $02, $02
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $0c, $3f, $08
	db $08, $08, $0c, $00, $00, $04, $06, $08, $0a, $04, $14, $0a, $18, $04, $02, $08
	db $08, $02, $04, $ff, $00, $02, $04, $02, $03, $01, $01, $08, $06, $02

EntityGroupTable484E::
	db $04, $04
	db $08, $08, $18, $08, $04, $08, $10, $08, $10, $08, $08, $04, $08, $08, $08, $08
	db $08, $08, $08, $0c, $00, $00, $08, $08, $08, $0c, $0c, $14, $10, $20, $08, $08
	db $04, $04, $04, $04, $04, $00, $14, $08, $04, $08, $04, $04, $08, $08, $04

EntityGroupTable487F::
	db $02
	db $06, $01, $03, $03, $03, $0d, $08, $0a, $02, $07, $0b, $00, $04, $00, $08, $04
	db $0e, $0e, $0e, $0e, $0e, $00, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
	db $02, $00, $00, $02, $00, $00, $00, $00, $06, $06, $0d, $0e, $00, $09, $03, $06

;@ def InitEntityProperties(slot: c)
;@ path: entity/spawn
;@ Gives a fresh entity slot the defaults of its type: clears its variables, remembers the room it was
;@ loaded in, then loads the type's properties (ReloadEntityProperties).
InitEntityProperties::
;> ResetEntityVariablesFrom3()  # clears speeds, state, private variables and timers of the slot (code in bank $15)
	call ResetEntityVariablesFrom3
;> wEntityRoom[slot] = hMapRoom
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
;> wEntityLoadOrder[slot] = 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;> ReloadEntityProperties(slot)
;@ def ReloadEntityProperties(slot: c)
;@ path: entity/spawn
;@ Copies physics flags, hitbox, health and option flags of the slot's current type from the per-type
;@ tables. Also used when an entity turns into another type (a burnt Gibdo becomes a Stalfos).
ReloadEntityProperties::
;> type = wEntityType[slot]
	ld hl, wEntityType
	add hl, bc
	ld e, [hl]
	ld d, b
;> wEntityPhysicsFlags[slot] = EntityPhysicsFlagsTable[type]
	ld hl, EntityPhysicsFlagsTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], a
;> wEntityHitboxFlags[slot] = EntityHitboxFlagsTable[type]
	ld hl, EntityHitboxFlagsTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], a
;> InitEntityHealth(slot, type)
	call InitEntityHealth
;> wEntityOptions1[slot] = EntityOptionsTable[type]
	ld hl, EntityOptionsTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], a
;> return LoadEntityHitbox()  # copies the hitbox chosen by wEntityHitboxFlags into the slot's hitbox
	jp LoadEntityHitbox


;@ def InitEntityHealth(slot: c, type: de)
;@ path: entity/spawn
;@ Sets the entity's health group from its type and its starting health from the group.
InitEntityHealth::
;> group = EntityHealthGroupTable[type]
	push de
	ld hl, EntityHealthGroupTable
	add hl, de
	ld e, [hl]
;> wEntityHealthGroup[slot] = group
	ld hl, wEntityHealthGroup
	add hl, bc
	ld [hl], e
;> health = EntityHealthTable[group]
	ld d, b
	ld hl, EntityHealthTable
	add hl, de
	ld a, [hl]
;> wEntityHealth[slot] = health
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], a
	pop de
	ret


;@ def CancelMiniBossAndDespawn(slot: c)
;@ path: entity/status
;@ Removes a mini-boss that must not appear yet and marks the room's event as done, so the room acts
;@ as cleared (its shutters stay open).
CancelMiniBossAndDespawn::
;> wRoomEventDone = 1
	ld a, $01
	ld [wRoomEventDone], a
;> return Call_3FB7(slot)  # frees the slot
	jp Call_3FB7


;@ def EntityStatusInitHandler(slot: c)
;@ path: entity/status
;@ Status 4: the first frame of a freshly loaded entity. A boss or mini-boss (option bit 7) is not
;@ loaded again in a room where it was beaten, and it starts the boss music; Master Stalfos only
;@ shows up once the right rooms of his dungeon are done. Then the entity becomes active (status 5)
;@ and its type's init routine from EntityInitHandlers runs.
EntityStatusInitHandler::
;> if wEntityOptions1[slot] & 0x80:  # a boss or mini-boss
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .activate

;>     if hRoomStatus & 0x30:  # already beaten in this room
	ldh a, [hRoomStatus]
	and $30
	jr z, .notBeaten

;>         return Call_3FB7(slot)  # frees the slot
	jp Call_3FB7


.notBeaten
;>     if hActiveEntityType == 0x5F:  # Master Stalfos
	ldh a, [hActiveEntityType]
	cp $5f
	jr nz, .bossStart

;>         if hMapRoom != 0x95 and hMapRoom != 0x92:
	ldh a, [hMapRoom]
	cp $95
	jr z, .bossStart

	cp $92
	jr z, .bossStart

;>             if hMapRoom != 0x84 and not wRoomStatus[0x184] & 0x30: return CancelMiniBossAndDespawn(slot)
	cp $84
	jr z, .room84Done

	ld a, [wRoomStatus + $184]
	and $30
	jr z, CancelMiniBossAndDespawn

.room84Done
;>             if not wRoomStatus[0x192] & 0x30: return CancelMiniBossAndDespawn(slot)
	ld a, [wRoomStatus + $192]
	and $30
	jr z, CancelMiniBossAndDespawn

;>             if not wRoomStatus[0x195] & 0x30: return CancelMiniBossAndDespawn(slot)
	ld a, [wRoomStatus + $195]
	and $30
	jr z, CancelMiniBossAndDespawn

.bossStart
;>     if not wIsIndoor or not mem[0xD478]:
	ld a, [wIsIndoor]
	and a
	jr z, .resetSound

	ld a, [wEvilEagleFightStarted]
	and a
	jr nz, .bossVars

;>         if wIsIndoor and wEntityOptions1[slot] & 0x04:  # a dungeon boss
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $04
	jr z, .resetSound

;>             wRestoreMusicAfterTransition = 4
	ld [wRestoreMusicAfterTransition], a

.resetSound
;>         ResetSoundEngine()  # resets the sound engine (bank $1F)
	call ResetSoundEngine

.bossVars
;>     wBossMusicStarted = 0
	xor a
	ld [wBossMusicStarted], a
;>     wBossInRoom = 1
	inc a
	ld [wBossInRoom], a
;>     wBossMusicDelay = 0x20  # frames until the boss music starts
	ld a, $20
	ld [wBossMusicDelay], a

.activate
;> wEntityStatus[slot] = 5  # active
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> return EntityInitHandlers[hActiveEntityType](slot)
	ldh a, [hActiveEntityType]
	rst $00

EntityInitHandlers::
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_PushedBlock
	dw EntityInit_ChestItem
	dw EntityInit_RandomDirection
	dw EntityInit_OctorokMoblin
	dw EntityInit_RandomDirection
	dw EntityInit_OctorokMoblin
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_Leever
	dw EntityInit_RandomDirection
	dw EntityInit_Ghini
	dw EntityInit_Ghini
	dw EntityInit_Ghini
	dw EntityInit_Type13
	dw EntityInit_MoblinSword
	dw EntityInit_RandomDiagonal
	dw EntityInit_SparkCounterClockwise
	dw EntityInit_SparkClockwise
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_Gel
	dw EntityInit_RandomDirection
	dw EntityInit_Wizrobe

	db $8d, $3b, $8d, $3b, $09, $4d, $8e, $4f, $09, $4d, $8d, $3b, $09, $4d, $1e, $4d, $1e, $4d, $09, $4d, $09, $4d, $db, $3d, $09, $4d, $09, $4d, $09, $4d, $d6, $4f, $32, $50, $32, $50, $e5, $4f, $7e, $4c, $32, $50, $32, $50, $32, $50, $13, $4d, $32, $50, $32, $50, $32, $50, $59, $50, $13, $4d, $d6, $4f, $d6, $4f, $b2, $4f, $86, $4c, $ec, $4c, $ff, $4c, $79, $4c, $09, $4d, $59, $50, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $09, $4d, $09, $4d, $09, $4d, $00, $4d, $09, $4d, $f2, $4c, $09, $4d, $09, $4d, $09, $4d, $09, $4d, $f2, $4c, $09, $4d, $09, $4d, $09, $4d, $09, $4d, $e6, $3d, $f1, $3d, $fc, $3d, $07, $3e, $12, $3e, $09, $4d, $09, $4d, $1d, $3e, $28, $50, $28, $3e, $33, $3e, $14, $4d, $3e, $3e, $09, $4d, $13, $4d, $13, $4d, $e6, $4b, $d8, $4c, $13, $4d, $13, $4d, $61, $4c, $13, $4d, $13, $4d, $ec, $4c, $2b, $4c, $39, $4c, $ec, $4c, $ec, $4c, $ec, $4c, $3a, $4c, $ec, $4c, $13, $4d, $cb, $4c, $13, $4d, $ec, $4c, $3b, $50, $13, $4d, $13, $4d, $13, $4d, $a0, $4b, $13, $4d, $13, $4d, $bf, $4b, $46, $4c, $13, $4d, $06, $4c, $f4, $4b, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $3b, $50, $13, $4d, $13, $4d, $da, $4b, $13, $4d, $13, $4d, $13, $4d, $a4, $4b, $13, $4d, $13, $4d, $4a, $4b, $13, $4d, $13, $4d, $13, $4d, $5f, $4f, $13, $4d, $d4, $4b, $13, $4d, $13, $4d, $61, $4b, $13, $4d, $13, $4d, $67, $4b, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $c7, $4b, $09, $4d, $20, $50, $13, $4d, $13, $4d, $13, $4d, $3b, $50, $98, $4b, $13, $4d, $13, $4d, $13, $4d, $c3, $4b, $13, $4d, $89, $4b, $97, $4b, $3b, $50, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $7e, $4b, $58, $4b, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $5f, $4f, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $13, $4d, $f8, $4b, $b7, $4b, $13, $4d, $13, $4d

;@ path: entity/init
;@ Sprite variant of each Horse Piece (type $98), by its load order in the room: the two pieces of
;@ the puzzle look different. 2 bytes.
HorsePieceVariantTable::
	db $01, $04

;@ def EntityInit_HorsePiece(slot: c)
;@ path: entity/init
;@ Init of type $98: picks the sprite variant from HorsePieceVariantTable by the piece's load order.
EntityInit_HorsePiece::
;> order = wEntityLoadOrder[slot]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	ld d, b
;> return SetEntitySpriteVariant(slot, HorsePieceVariantTable[order])  # sets wEntitySpriteVariant
	ld hl, HorsePieceVariantTable
	add hl, de
	ld a, [hl]
	jp SetEntitySpriteVariant

;@ def EntityInit_MarinAtTalTal(slot: c)
;@ path: entity/init
;@ Init of type $C2: moves the entity 3 pixels up from where the room data put it.
EntityInit_MarinAtTalTal::
;> wEntityY[slot] -= 3
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $03
	ld [hl], a
	ret

;@ def EntityInit_Snake(slot: c)
;@ path: entity/init
;@ Init of type $A1: starts timer 1 at $30 frames.
EntityInit_Snake::
;> wEntityTimer1[slot] = 0x30
	call GetEntityTimer1
	ld [hl], $30
	ret

;@ def EntityInit_VerticalPlatform(slot: c)
;@ path: entity/init
;@ Init of type $A4: in room $65, a platform that starts at y $50 or below sets its private variable 1
;@ (it starts by moving the other way).
EntityInit_VerticalPlatform::
;> if hMapRoom != 0x65: return
	ldh a, [hMapRoom]
	cp $65
	ret nz
;> if hActiveEntityDrawY < 0x50: return
	ldh a, [hActiveEntityDrawY]
	cp $50
	ret c
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ret

;@ def EntityInit_Gel(slot: c)
;@ path: entity/init
;@ Init of type $1B: gives it 2 health instead of the group's default.
EntityInit_Gel::
;> wEntityHealth[slot] = 2
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $02
	ret


;@ def EntityInit_MarinAtShore(slot: c)
;@ path: entity/init
;@ Init of type $C1: Marin is not at the shore while she walks with Link or waits in Animal Village.
EntityInit_MarinAtShore::
;> if wIsMarinFollowingLink | wIsMarinInAnimalVillage:
	ld hl, wIsMarinInAnimalVillage
	ld a, [wIsMarinFollowingLink]
	or [hl]
;>     return Call_3FB7(slot)  # frees the slot
	jp nz, Call_3FB7
	ret

;@ def EntityInit_Bomber(slot: c)
;@ path: entity/init
;@ Init of type $BA: starts 16 pixels up in the air, with a random animation counter.
EntityInit_Bomber::
;> wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;> wEntityPrivateCounter[slot] = GetRandomByte()  # random byte
	call GetRandomByte
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], a

;@ def EntityInit_BushCrawler(slot: c)
;@ path: entity/init
;@ Init of type $BB: nothing to do.
EntityInit_BushCrawler::
;> return
	ret

;@ def EntityInit_Tarin(slot: c)
;@ path: entity/init
;@ Init of type $B4: centred on its tile, sprite variant 2.
EntityInit_Tarin::
;> CenterEntityOnTile(slot)
	call CenterEntityOnTile
;> return SetEntitySpriteVariant(slot, 2)  # sets wEntitySpriteVariant
	ld a, $02
	jp SetEntitySpriteVariant

;@ def EntityInit_Telephone(slot: c)
;@ path: entity/init
;@ Init of type $80: plays music $33 in the room (once Link has a sword).
EntityInit_Telephone::
;> return PlayMusicIfLinkHasSword(0x33)
	ld a, $33
	jr PlayMusicIfLinkHasSword

;@ def EntityInit_Richard(slot: c)
;@ path: entity/init
;@ Init of type $95: plays music $40 in the room (once Link has a sword).
EntityInit_Richard::
;> return PlayMusicIfLinkHasSword(0x40)
	ld a, $40

;@ def PlayMusicIfLinkHasSword(track: a)
;@ path: sound/music
;@ Starts `track` as the room's music, but only once Link owns a sword (not during the opening part
;@ of the story).
PlayMusicIfLinkHasSword::
;> if wSwordLevel == 0: return
	ld e, a
	ld a, [wSwordLevel]
	and a
	ret z
;> PlayRoomMusic(track)
	ld a, e

;@ def PlayRoomMusic(track: a)
;@ path: sound/music
;@ Starts `track` and makes it the room's music (the default track, and the copies at $FFBD and $FFBF
;@ the music code keeps of the playing track).
PlayRoomMusic::
;> wMusicTrackToPlay = track
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrack = track
	ldh [hDefaultMusicTrack], a
;> mem[0xFFBD] = track
	ldh [$ffbd], a
;> mem[0xFFBF] = track
	ldh [$ffbf], a
	ret


;@ def EntityInit_FinalNightmare(slot: c)
;@ path: entity/init
;@ Init of type $E6: starts at form 0 ($D219) and resets the sound engine.
EntityInit_FinalNightmare::
;> wFinalNightmareForm = 0
	xor a
	ld [wFinalNightmareForm], a
;> ResetSoundEngine()  # resets the sound engine (bank $1F)
	call ResetSoundEngine
	ret

;@ def EntityInit_DreamShrineBed(slot: c)
;@ path: entity/init
;@ Init of type $83: plays music $24 in the room.
EntityInit_DreamShrineBed::
;> return PlayRoomMusic(0x24)
	ld a, $24
	jr PlayRoomMusic

;@ def EntityInit_FishermanUnderBridge(slot: c)
;@ path: entity/init
;@ Init of type $B8: plays music $3A in the room.
EntityInit_FishermanUnderBridge::
;> return PlayRoomMusic(0x3A)
	ld a, $3a
	jr PlayRoomMusic
;@ def EntityInit_Kiki(slot: c)
;@ path: entity/init
;@ Init of type $AD: clears $C168 and moves the entity 4 pixels up.
EntityInit_Kiki::
;> mem[0xC168] = 0
	xor a
	ld [wMonkeysLeaving], a
;> wEntityY[slot] -= 4
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	ret

;@ def EntityInit_FireballShooter(slot: c)
;@ path: entity/init
;@ Init of type $9E: a random sprite variant (used as a random start phase).
EntityInit_FireballShooter::
;> return SetEntitySpriteVariant(slot, GetRandomByte())  # wEntitySpriteVariant = random byte
	call GetRandomByte
	jp SetEntitySpriteVariant

;@ def EntityInit_AntiKirby(slot: c)
;@ path: entity/init
;@ Init of type $91: drop timer starts at a random $10-$4F frames.
EntityInit_AntiKirby::
;> wEntityDropTimer[slot] = (GetRandomByte() & 0x3F) + 0x10
	call GetEntityDropTimer
	call GetRandomByte
	and $3f
	add $10
	ld [hl], a
	ret

;@ def EntityInit_MovingBlockMover(slot: c)
;@ path: entity/init
;@ Init of type $69: moves 10 pixels down and remembers that y in private variable 2.
EntityInit_MovingBlockMover::
;> wEntityY[slot] += 10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $0a
	ld [hl], a
;> wEntityPrivate2[slot] = wEntityY[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	ret

;@ def EntityInit_DesertLanmola(slot: c)
;@ path: entity/init
;@ Init of type $87: no room music while it is around.
EntityInit_DesertLanmola::
;> hDefaultMusicTrack = 0
	xor a
	ldh [hDefaultMusicTrack], a
	ret

;@ def EntityInit_FloatingItem2(slot: c)
;@ path: entity/init
;@ Init of type $E5: floats 19 pixels up; sprite variant 4 or 5 depending on whether it stands in the
;@ left or the right half of a 32-pixel column.
EntityInit_FloatingItem2::
;> SetEntityZ13(slot)
	call SetEntityZ13
;> return SetEntitySpriteVariant(slot, 4 + ((hActiveEntityX >> 4) & 1))  # sets wEntitySpriteVariant
	ldh a, [hActiveEntityX]
	swap a
	and $01
	add $04
	jp SetEntitySpriteVariant

;@ def EntityInit_FloatingItem(slot: c)
;@ path: entity/init
;@ Init of type $86: the sprite variant (0-3) comes from where it stands (x bit 4, y bit 4 shifted);
;@ variant 1 is not there any more once $DB4B is set. It floats 19 pixels up.
EntityInit_FloatingItem::
;> v = (hActiveEntityX >> 4) & 1
	ldh a, [hActiveEntityX]
	swap a
	and $01
	ld e, a
;> v |= (((hActiveEntityY >> 4 | hActiveEntityY << 4) + 1) << 1) & 2
	ldh a, [hActiveEntityY]
	swap a
	inc a
	rla
	and $02
	or e
;> SetEntitySpriteVariant(slot, v)  # sets wEntitySpriteVariant
	call SetEntitySpriteVariant
;> if v == 1 and mem[0xDB4B]:
	cp $01
	jr nz, SetEntityZ13
	ld a, [wHasToadstool]
	and a
;>     return Call_3FB7(slot)  # frees the slot
	jp nz, Call_3FB7
;> SetEntityZ13(slot)

;@ def SetEntityZ13(slot: c)
;@ path: entity/init
;@ Puts the entity 19 pixels up in the air.
SetEntityZ13::
;> wEntityZ[slot] = 0x13
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $13
	ret

;@ def EntityInit_Kid71(slot: c)
;@ path: entity/init
;@ Init of type $71: faces up, starts in state 1 with a $20-frame timer.
EntityInit_Kid71::
;> wEntityDirection[slot] = 2
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20

;@ def EntityInit_Kid72(slot: c)
;@ path: entity/init
;@ Init of type $72: nothing to do.
EntityInit_Kid72::
;> return
	ret

;@ def EntityInit_MrWrite(slot: c)
;@ path: entity/init
;@ Init of type $76: plays music $37 in room $D9 and $32 elsewhere (once Link has a sword), then
;@ moves half a tile right.
EntityInit_MrWrite::
;> track = 0x37 if hMapRoom == 0xD9 else 0x32
	ldh a, [hMapRoom]
	cp $d9
	ld a, $32
	jr nz, .play
	ld a, $37
.play
;> return PlayMusicAndCenterX(slot, track)
	jr PlayMusicAndCenterX

;@ def EntityInit_BigFairy(slot: c)
;@ path: entity/init
;@ Init of type $84: floats 16 pixels up; not there while $C5A9 is set. Plays music $0C (once Link has
;@ a sword) and moves half a tile right.
EntityInit_BigFairy::
;> wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;> if mem[0xC5A9]: return Call_3FB7(slot)  # frees the slot
	ld a, [wHealthIsFull]
	and a
	jp nz, Call_3FB7
;> PlayMusicAndCenterX(slot, 0x0C)
	ld a, $0c
;@ def PlayMusicAndCenterX(slot: c, track: a)
;@ path: entity/init
;@ Plays `track` as room music (once Link has a sword) and moves the entity half a tile right.
PlayMusicAndCenterX::
;> PlayMusicIfLinkHasSword(track)
	call PlayMusicIfLinkHasSword
;> return AddHalfTileToCoord(slot, wEntityX, wEntityPosXHigh)
	ld de, wEntityPosXHigh
	ld hl, wEntityX
	jp AddHalfTileToCoord

;@ def EntityInit_BowWow(slot: c)
;@ path: entity/init
;@ Init of type $6D: in room $E2 (the kidnappers' place) BowWow is only there while he is kidnapped
;@ (wIsBowWowFollowingLink = $80); elsewhere he is only there while not with Link.
EntityInit_BowWow::
;> if hMapRoom == 0xE2:
	ldh a, [hMapRoom]
	cp $e2
	jr nz, .home
;>     if wIsBowWowFollowingLink != 0x80: return Call_3FB7(slot)  # frees the slot
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jr z, .done
	jp Call_3FB7
.home
;> elif wIsBowWowFollowingLink: return Call_3FB7(slot)
	ld a, [wIsBowWowFollowingLink]
	and a
	jp nz, Call_3FB7
.done
	ret

;@ def EntityInit_OwlEvent(slot: c)
;@ path: entity/init
;@ Init of type $41: the owl does not come back once bit 5 of the room's status is set.
EntityInit_OwlEvent::
;> return DespawnIfRoomFlag(slot, hRoomStatus >> 1)  # tests bit 5 of the room status
	ldh a, [hRoomStatus]
	rra
	jr DespawnIfRoomFlag

;@ def EntityInit_Sword(slot: c)
;@ path: entity/init
;@ Init of type $31: the sword on the beach is gone once bit 4 of the room's status is set (taken).
EntityInit_Sword::
;> DespawnIfRoomFlag(slot, hRoomStatus)
	ldh a, [hRoomStatus]
;@ def DespawnIfRoomFlag(slot: c, flags: a)
;@ path: entity/init
;@ Frees the slot when bit 4 of `flags` is set (callers pass the room status, shifted to test other
;@ bits).
DespawnIfRoomFlag::
;> if flags & 0x10: return Call_3FB7(slot)  # frees the slot
	and $10
	jp nz, Call_3FB7
	ret

;@ def EntityInit_Marin(slot: c)
;@ path: entity/init
;@ Init of type $3E. In the rooms from $C0 on (Animal Village) Marin is only there while she waits in
;@ the village; she then plays her song (music $2F). A debug feature follows: when the cartridge byte
;@ at $0003 is non-zero and the player has no name, Marin switches the game to mode 1 or turns into
;@ the text debugger (type $6B). Otherwise she is set up like a townsperson.
EntityInit_Marin::
;> if hMapRoom >= 0xC0:
	ldh a, [hMapRoom]
	cp $c0
	jr c, .debugCheck

;>     if not wIsMarinInAnimalVillage: return Call_3FB7(slot)  # frees the slot
	ld a, [wIsMarinInAnimalVillage]
	and a
	jp z, Call_3FB7

;>     if wIsMarinFollowingLink: return Call_3FB7(slot)
	ld a, [wIsMarinFollowingLink]
	and a
	jp nz, Call_3FB7

;>     mem[0xC3C8] = 1
	inc a
	ld [wMarinSinging], a
;>     hNextDefaultMusicTrack = 0x2F
	ld a, $2f
	ldh [hNextDefaultMusicTrack], a
;>     hDefaultMusicTrack = 0x2F
	ldh [hDefaultMusicTrack], a
;>     hDefaultMusicTrackAlt = 0x2F
	ldh [hDefaultMusicTrackAlt], a
;>     FadeOutVolume()
	call FadeOutVolume

.debugCheck
;> if mem[0x0003] and not wPlayerName:  # debug build switch in the ROM
	ld a, [$0003]
	and a
	jr z, EntityInit_Townsperson

	ld a, [wPlayerName]
	and a
	jr nz, EntityInit_Townsperson

;>     if not mem[0xDB50]:
	ld a, [$db50]
	and a
	jr nz, .textDebugger

;>         wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>         wGameplayType = 1
	ld a, $01
	ld [wGameplayType], a
;>         return
	ret


.textDebugger
;>     wEntityType[slot] = 0x6B  # the text debugger
	ld hl, wEntityType
	add hl, bc
	ld [hl], $6b
;>     return
	ret
;> EntityInit_Townsperson(slot)


;@ def EntityInit_MadamMeowMeow(slot: c)
;@ path: entity/init
;@ Init of type $79: while BowWow is kidnapped (wIsBowWowFollowingLink = $80) her house plays music $0E.
EntityInit_MadamMeowMeow::
;> if wIsBowWowFollowingLink == 0x80:
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jr nz, .done
;>     wMusicTrackToPlay = 0x0E
	ld a, $0e
	ld [wMusicTrackToPlay], a
.done
	ret

;@ def EntityInit_Raft(slot: c)
;@ path: entity/init
;@ Init of type $6A: indoors it is set up like a townsperson; outdoors, unless $D477 is set, it moves
;@ 16 pixels up.
EntityInit_Raft::
;> if wIsIndoor: return EntityInit_Townsperson(slot)
	ld a, [wIsIndoor]
	and a
	jr nz, EntityInit_Townsperson
;> if mem[0xD477]: return
	ld a, [wRaftRented]
	and a
	ret nz
;> wEntityY[slot] -= 0x10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
	ret

;@ def EntityInit_Townsperson(slot: c)
;@ path: entity/init
;@ Init of the villagers (types $3F, $70, $73-$75, $77, $7B) and of the raft owner indoors: the
;@ direction is set to down, then like EntityInit_GameOwner they end up facing left.
EntityInit_Townsperson::
;> wEntityDirection[slot] = 3
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
;> EntityInit_GameOwner(slot)
;@ def EntityInit_GameOwner(slot: c)
;@ path: entity/init
;@ Init of types $4F and $54 (and the end of EntityInit_Townsperson): before Link owns a shield the room
;@ plays music $1C; the character faces left.
EntityInit_GameOwner::
;> if not wShieldLevel:
	ld a, [wShieldLevel]
	and a
	jr nz, .face

;>     PlayRoomMusic(0x1C)
	ld a, $1c
	call PlayRoomMusic

.face
;> return SetEntityDirectionLeft(slot)
	jr SetEntityDirectionLeft

;@ def EntityInit_Witch(slot: c)
;@ path: entity/init
;@ Init of type $40: nothing to do.
EntityInit_Witch::
;> return
	ret

;@ def EntityInit_ShopOwner(slot: c)
;@ path: entity/init
;@ Init of type $4D: plays music $07 in the shop (once Link has a sword) and faces left.
EntityInit_ShopOwner::
;> PlayMusicIfLinkHasSword(0x07)
	ld a, $07
	call PlayMusicIfLinkHasSword
;> SetEntityDirectionLeft(slot)

;@ def SetEntityDirectionLeft(slot: c)
;@ path: entity/init
;@ Makes the entity face left.
SetEntityDirectionLeft::
;> return SetEntityDirection(slot, 1)
	ld a, $01
	jr SetEntityDirection

;@ def EntityInit_RandomDirection(slot: c)
;@ path: entity/init
;@ The default init of most types: faces a random direction.
EntityInit_RandomDirection::
;> SetEntityDirection(slot, GetRandomByte() & 3)  # random byte
	call GetRandomByte
	and $03

;@ def SetEntityDirection(slot: c, direction: a)
;@ path: entity/init
;@ Sets the entity's facing direction (0 right, 1 left, 2 up, 3 down).
SetEntityDirection::
;> wEntityDirection[slot] = direction
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

;@ def EntityInit_None()
;@ path: entity/init
;@ Init of the types that need nothing.
EntityInit_None::
;> return
	ret


;@ def EntityInit_FaceShrineDoor(slot: c)
;@ path: entity/init
;@ Init of type $64: enables the VBlank and LCD STAT interrupts (rIE = 3).
EntityInit_FaceShrineDoor::
;> rIE = 0x03
	ld a, $03
	ldh [$ffff], a
	ret

;@ def EntityInit_Leever(slot: c)
;@ path: entity/init
;@ Init of type $0E: starts hidden in the ground (sprite variant $FF = not drawn).
EntityInit_Leever::
;> return SetEntitySpriteVariant(slot, 0xFF)  # sets wEntitySpriteVariant
	ld a, $ff
	jp SetEntitySpriteVariant


;@ path: entity/status
;@ The flames drawn over an entity that burns (status 3): two 8x16 sprites of tile $34, the right one
;@ x-flipped. 2 variants of 2 (tile, attribute) pairs: variant 0 palette 0, variant 1 palette 1 (the
;@ flames flicker between them every 8 frames). The handler pointer and the init pointer of the unused
;@ types $25 and $26 also point here.
BurningFlameSprites::
	db $34, $00, $34, $20, $34, $10, $34, $30

;@ def EntityStatus3Handler(slot: c)
;@ path: entity/status
;@ Status 3: the entity burns (hit by fire). While wEntityTimer runs it stands still under flickering
;@ flames, its own handler still drawing it. Then it dies (status 1), except a Gibdo (type $1F),
;@ which turns into a Stalfos (type $1E).
EntityStatus3Handler::
;> if GetEntityTimer(slot):
	call GetEntityTimer
	jr z, .burntOut
;>     hActiveEntitySpriteVariant = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(BurningFlameSprites)  # draws the flames (two sprites)
	ld de, BurningFlameSprites
	call DrawEntity16x16
;>     hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>     RunEntityHandlerFrom3()  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3
;>     ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;>     ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;>     UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;>     ClearEntitySpeed()  # stops the entity (x and y speed 0)
	call ClearEntitySpeed
;>     return
	ret
.burntOut
;> if hActiveEntityType == 0x1F:  # Gibdo
	ldh a, [hActiveEntityType]
	cp $1f
	jr nz, .die
;>     wEntityType[slot] = 0x1E  # Stalfos
	ld hl, wEntityType
	add hl, bc
	ld [hl], $1e
;>     wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;>     return ReloadEntityProperties(slot)
	jp ReloadEntityProperties
.die
;> wEntityDyingTimer[slot] = 0x1F
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
;> wEntityStatus[slot] = 1  # dying
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
;> wEntityPhysicsFlags[slot] = 0x04
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $04
;> hNoiseSfx = 0x13
	ld hl, hNoiseSfx
	ld [hl], $13
	ret
;@ path: entity/status
;@ Falling into a pit: added to the draw y in each of the 4 stages (stage = (timer >> 4) & 3; stage 3
;@ comes first). 4 signed bytes, pixels.
PitFallDrawYOffsets::
	db $00, $00, $04, $00

;@ path: entity/status
;@ Falling into a pit: speed with which the entity is pulled towards the pit's centre in each stage
;@ (stage 3 first: 6, then 3, 1, 0). 4 bytes.
PitFallPullSpeeds::
	db $00, $01, $03, $06

;@ path: entity/status
;@ Falling into a pit, stages 0-2: one 8x16 sprite per stage, (tile, attribute) pairs: $24, $24, $3E.
PitFallSprites::
	db $24, $00, $24, $00, $3e, $00

;@ path: entity/status
;@ Falling into a pit, stage 3 (the first): two 8x16 sprites (tile, attribute) of tile $1E, the right
;@ one flipped both ways.
PitFallStartSprite::
	db $1e, $00, $1e, $60

;@ def EntityStatus2Handler(slot: c)
;@ path: entity/status
;@ Status 2: the entity falls into a pit. For the first frames ($40 and more on wEntityTimer) its own
;@ handler still runs; then it shrinks through 4 stages while it is pulled to the pit's centre
;@ (wEntityPitX/Y). When the timer runs out the slot is freed; the heavy ball (type $A8) goes back to
;@ its starting place.
EntityStatus2Handler::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .falling
;>     if not wEntityOptions1[slot] & 0x02:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $02
	jr nz, .noFlag
;>         mem[0xD460] = 1
	ld hl, $d460
	ld [hl], $01
.noFlag
;>     if hActiveEntityType == 0xA8:
	ldh a, [hActiveEntityType]
	cp $a8
	jr nz, .free
;>         wIronBallRoom = 0x16
	ld a, $16
	ld [$db6f], a
;>         wIronBallX = 0x50
	ld a, $50
	ld [$db70], a
;>         wIronBallY = 0x27
	ld a, $27
	ld [$db71], a
.free
;>     return Call_3FB7(slot)  # frees the slot
	jp Call_3FB7
.falling
;> if t >= 0x40:
	cp $40
	jr c, .shrink
;>     walker = hActiveEntityType in (0x09, 0x0B)  # Octorok, Moblin
	ldh a, [hActiveEntityType]
	cp $09
	jr z, .walker
	cp $0b
	jr z, .walker
;>     if walker or hActiveEntityType == 0x14:  # or Moblin with sword
	cp $14
	jr nz, .runHandler
.walker
;>@three         for i in range(3): SetWalkingSpriteVariant_03(slot)
	call SetWalkingSpriteVariant_03
;=@three
	call SetWalkingSpriteVariant_03
	call SetWalkingSpriteVariant_03
.runHandler
;>     RunEntityHandlerFrom3()  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3
;>     ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;>     return
	ret
.shrink
;> stage = (t >> 4) & 3
	rra
	rra
	rra
	rra
	and $03
;> wEntitySpriteVariant[slot] = stage
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;> hActiveEntitySpriteVariant = stage
	ldh [hActiveEntitySpriteVariant], a
;> offset = PitFallDrawYOffsets[stage]
	ld e, a
	ld d, b
	ld hl, PitFallDrawYOffsets
	add hl, de
;> hActiveEntityDrawY += offset
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> if stage == 3:
	ld a, e
	cp $03
	jr nz, .small
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(PitFallStartSprite)  # draws two sprites
	ld de, PitFallStartSprite
	call DrawEntity16x16
	jr .drawn
.small
;> else:
;>     DrawEntity8x16(PitFallSprites)  # draws one sprite
	ld de, PitFallSprites
	call DrawEntity8x16
.drawn
;> ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0x3F: hJingle = 0x18
	cp $3f
	jr nz, .pull
	ld hl, hJingle
	ld [hl], $18
.pull
;> stage = (t >> 4) & 3
	rra
	rra
	rra
	rra
	and $03
;> speed = PitFallPullSpeeds[stage]
	ld e, a
	ld d, b
	ld hl, PitFallPullSpeeds
	add hl, de
	ld e, [hl]
;> linkX = hLinkX  # Call_03_7E99 aims at Link's position: point it at the pit for a moment
	ldh a, [hLinkX]
	push af
;> hLinkX = wEntityPitX[slot]
	ld hl, $c4b0
	add hl, bc
	ld a, [hl]
	ldh [hLinkX], a
;> linkY = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = wEntityPitY[slot]
	ld hl, $c4c0
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
;> Call_03_7E99(slot, speed)  # sets the speed towards that point
	ld a, e
	call Call_03_7E99
;> hLinkY = linkY
	pop af
	ldh [hLinkY], a
;> hLinkX = linkX
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
	ret

;@ def EntityStatus8Handler(slot: c)
;@ path: entity/status
;@ Status 8: the entity flies through the air after Link threw it. It hits other entities as weapon
;@ $0B (a thrown object); when it stops moving it lands stunned (status 6). The Genie's bottle
;@ (type $5C) counts its hits against walls: on the third one, or when it stops, the Genie comes out
;@ (back to status 5, state 1).
EntityStatus8Handler::
;> RunEntityHandlerFrom3()  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3
;> ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;> wEntityIgnoreHitsTimer[slot] = 2
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $02
;> UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;> wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
;> jr_003_6723(slot)
	call jr_003_6723
;> CheckThrownObjectRoomEvents(slot)
	call CheckThrownObjectRoomEvents
;> landed = False
;> if hActiveEntityType == 0x5C:  # the Genie's bottle
	ldh a, [hActiveEntityType]
	cp $5c
	jr nz, .flying
;>     if wEntityCollisions[slot]:  # it hit a wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .flying
;>         wEntityFlashTimer[slot] = 0x20
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $20
;>         hWaveSfx = 7
	ld hl, hWaveSfx
	ld [hl], $07
;>         wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>         landed = wEntityPrivate4[slot] == 3
	cp $03
	jr z, .genieOut
.flying
;> if not landed:
;>     wProjectileWeaponType = 0x0B  # a thrown object
	ld a, $0b
	ld [wProjectileWeaponType], a
;>     Call_03_75A6(slot)  # hits the other entities
	call Call_03_75A6
;>     moving = wEntitySpeedX[slot] | wEntitySpeedY[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	or [hl]
;>     if moving: return
	jr nz, .done
;>     StunEntity(slot)
	call StunEntity
;>     if hActiveEntityType != 0x5C: return
	ldh a, [hActiveEntityType]
	cp $5c
	jr nz, .done
.genieOut
;> wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
.done
	ret

;@ path: entity/status
;@ X speeds that shake a stunned entity during its last $3C frames: alternately right and left every
;@ 4 frames. 2 signed bytes (1/16 pixel per frame).
StunShakeSpeeds::
	db $10, $f0

;@ def EntityStatus6Handler(slot: c)
;@ path: entity/status
;@ Status 6: the entity is stunned. It stands still while its own handler still draws it; Link can
;@ lift it with the Power Bracelet (item 3) by pressing that item's button.
EntityStatus6Handler::
;> RunEntityHandlerFrom3()  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3
;> ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;> ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;> UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;> ClearEntitySpeed()  # stops the entity (x and y speed 0)
	call ClearEntitySpeed
;> Call_03_6E40(slot)
	call Call_03_6E40
;> if wItemB == 3:  # Power Bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .itemA
;>     if hJoypadPressed & 0x20: return TryLiftStunnedEntity(slot)
	ldh a, [hJoypadPressed]
	and $20
	jr nz, TryLiftStunnedEntity
;>     return UpdateStunnedEntity(slot)
	jr UpdateStunnedEntity
.itemA
;> if wItemA != 3: return UpdateStunnedEntity(slot)
	ld a, [wItemA]
	cp $03
	jr nz, UpdateStunnedEntity
;> if not hJoypadPressed & 0x10: return UpdateStunnedEntity(slot)
	ldh a, [hJoypadPressed]
	and $10
	jr z, UpdateStunnedEntity
;> TryLiftStunnedEntity(slot)

;@ def TryLiftStunnedEntity(slot: c)
;@ path: entity/status
;@ Link tries to lift a stunned entity: if he carries nothing and touches it, it becomes lifted
;@ (status 7) and the lifted handler takes over; otherwise it stays stunned.
TryLiftStunnedEntity::
;> if wLinkIsCarrying: return UpdateStunnedEntity(slot)
	ld a, [wLinkIsCarrying]
	and a
	jr nz, UpdateStunnedEntity

;> flags = wEntityPhysicsFlags[slot]
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	push hl
	push af
;> wEntityPhysicsFlags[slot] = flags | 0x80  # for the touch test only
	or $80
	ld [hl], a
;> touching = Call_03_6C8E(slot)  # carry: Link touches the entity
	call Call_03_6C8E
	rl e
;> wEntityPhysicsFlags[slot] = flags
	pop af
	pop hl
	ld [hl], a
;> if not touching: return UpdateStunnedEntity(slot)
	rr e
	jr nc, UpdateStunnedEntity

;> wLinkIsCarrying = 1
	ld a, $01
	ld [wLinkIsCarrying], a
;> wEntityStatus[slot] = 7  # lifted
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;> hWaveSfx = 2
	ld a, $02
	ldh [hWaveSfx], a
;> wEntityLiftStep[slot] = 0
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
;> wEntityTimer[slot] = 2
	call GetEntityTimer
	ld [hl], $02
;> wLiftDirection = hLinkDirection
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
;> return EntityStatus7Handler(slot)  # the lifted status handler
	jp EntityStatus7Handler


;@ def UpdateStunnedEntity(slot: c)
;@ path: entity/status
;@ Counts the stun down on wEntityTimer2: at 0 the entity is active again (status 5); during the last
;@ $3C frames it shakes left and right.
UpdateStunnedEntity::
;> t = wEntityTimer2[slot]
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
;> if t == 0:
	and a
	jr nz, .shake

;>     wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.shake
;> if t < 0x3C:
	cp $3c
	jr nc, .done

;>     i = (t >> 2) & 1
	srl a
	srl a
	and $01
;>     speed = StunShakeSpeeds[i]
	ld e, a
	ld d, b
	ld hl, StunShakeSpeeds
	add hl, de
	ld a, [hl]
;>     wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     AddEntitySpeedToPos_03(slot)  # moves it along x
	call AddEntitySpeedToPos_03
;>     ClearEntitySpeed()  # x and y speed back to 0
	call ClearEntitySpeed

.done
	ret


;@ path: entity/init
;@ Diagonal start speeds of EntityInit_RandomDiagonal, x part: 4 directions (index 0-3), signed
;@ 1/16 pixel per frame ($0C = 12).
DiagonalSpeedsX::
	db $0c, $0c, $f4, $f4

;@ path: entity/init
;@ Diagonal start speeds, y part (same index as DiagonalSpeedsX).
DiagonalSpeedsY::
	db $0c, $f4, $0c, $f4

;@ def EntityInit_RandomDiagonal(slot: c)
;@ path: entity/init
;@ Init of types $15, $9C and $DB: starts moving in one of the 4 diagonal directions at random.
EntityInit_RandomDiagonal::
;> i = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = DiagonalSpeedsX[i]
	ld hl, DiagonalSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = DiagonalSpeedsY[i]
	ld hl, DiagonalSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def EntityInit_SparkClockwise(slot: c)
;@ path: entity/init
;@ Init of type $17: private variable 2 = 4 and 3 pixels down.
EntityInit_SparkClockwise::
;> wEntityPrivate2[slot] = 4
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $04
;> return AddToEntityY(slot, 3)
	ld a, $03
	jr AddToEntityY

;@ def EntityInit_SparkCounterClockwise(slot: c)
;@ path: entity/init
;@ Init of type $16: 3 pixels up.
EntityInit_SparkCounterClockwise::
;> AddToEntityY(slot, -3)
	ld a, $fd

;@ def AddToEntityY(slot: c, dy: a)
;@ path: entity/init
;@ Moves the entity `dy` pixels down (negative: up).
AddToEntityY::
;> wEntityY[slot] += dy
	ld hl, wEntityY
	add hl, bc
	add [hl]
	ld [hl], a
	ret


;@ def EntityInit_Wizrobe(slot: c)
;@ path: entity/init
;@ Init of types $1D and $21: waits $80 frames, sprite variant $FF (not drawn).
EntityInit_Wizrobe::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntitySpriteVariant[slot] -= 1  # 0 -> $FF
	ld hl, wEntitySpriteVariant
	add hl, bc
	dec [hl]
	ret


;@ def EntityInit_MoblinSword(slot: c)
;@ path: entity/init
;@ Init of type $14: picks a facing direction from the x position (right or down), lets SetWalkingSpriteVariant_03
;@ use it, then flips bit 0 of it (right <-> left, up <-> down).
EntityInit_MoblinSword::
;> d = 0 if hActiveEntityX & 0x10 else 3
	ldh a, [hActiveEntityX]
	and $10
	ld a, $00
	jr nz, .set

	ld a, $03

.set
;> wEntityDirection[slot] = d
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> SetWalkingSpriteVariant_03(slot)
	push hl
	call SetWalkingSpriteVariant_03
	pop hl
;> wEntityDirection[slot] ^= 1
	ld a, [hl]
	xor $01
	ld [hl], a
	ret


;@ def EntityInit_SecretSeashell(slot: c)
;@ path: entity/init
;@ Init of type $3D: a pickup with private variable 3 = 2; in rooms $A4 and $D2 it is 1 and the shell
;@ is centred on its tile.
EntityInit_SecretSeashell::
;> wEntityPrivate3[slot] = 2
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], $02
;> if hMapRoom == 0xA4 or hMapRoom == 0xD2:
	ldh a, [hMapRoom]
	cp $a4
	jr z, .center
	cp $d2
	jr nz, .options
.center
;>     wEntityPrivate3[slot] -= 1
	dec [hl]
;>     CenterEntityOnTile(slot)
	call CenterEntityOnTile
.options
;> SetPickupOptions(slot)
	call SetPickupOptions
	ret

;@ def InitPickupItem(slot: c)
;@ path: entity/init
;@ Common setup of the pickups: private variable 3 = 1 on the overworld, 2 indoors, and option bits
;@ 0 and 4 set.
InitPickupItem::
;> wEntityPrivate3[slot] = 1
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], $01
;> if not wIsIndoor: return SetPickupOptions(slot)
	ld a, [wIsIndoor]
	and a
	jr z, SetPickupOptions
;> EntityInit_DroppedItem(slot)

;@ def EntityInit_DroppedItem(slot: c)
;@ path: entity/init
;@ Init of types $2D, $3B and $3C (and the indoor part of InitPickupItem): private variable 3 = 2,
;@ then SetPickupOptions.
EntityInit_DroppedItem::
;> wEntityPrivate3[slot] = 2
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], $02
;> SetPickupOptions(slot)

;@ def SetPickupOptions(slot: c)
;@ path: entity/init
;@ Sets option bits 0 and 4 of a pickup.
SetPickupOptions::
;> wEntityOptions1[slot] |= 0x11
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	or $11
	ld [hl], a
	ret


;@ def EntityInit_KeyDropPoint(slot: c)
;@ path: entity/init
;@ Init of type $30, which places a key in three rooms: room $F8 needs room flag 5 and not flag 4
;@ (sprite variant 2); room $7A needs flag 4 clear (variant 4); room $7C needs flag 4 of room $169
;@ set and its own flag 4 clear. Flag 4 = the key was taken.
EntityInit_KeyDropPoint::
;> if hMapRoom == 0xF8:
	ldh a, [hMapRoom]
	cp $f8
	jr nz, .room7A
;>     if hRoomStatus & 0x10: return Call_3FB7(slot)  # frees the slot
	ldh a, [hRoomStatus]
	bit 4, a
	jp nz, Call_3FB7
;>     if not hRoomStatus & 0x20: return Call_3FB7(slot)
	bit 5, a
	jp z, Call_3FB7
;>     return SetEntitySpriteVariant(slot, 2)  # sets wEntitySpriteVariant
	ld a, $02
	jp SetEntitySpriteVariant
.room7A
;> if hMapRoom == 0x7A:
	cp $7a
	jr nz, .room7C
;>     if hRoomStatus & 0x10: return Call_3FB7(slot)
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7
;>     return SetEntitySpriteVariant(slot, 4)
	ld a, $04
	jp SetEntitySpriteVariant
.room7C
;> if hMapRoom == 0x7C:
	cp $7c
	jr nz, .done
;>     if not wRoomStatus[0x169] & 0x10: return Call_3FB7(slot)
	ld a, [wRoomStatus + $169]
	and $10
	jp z, Call_3FB7
;>     if hRoomStatus & 0x10: return Call_3FB7(slot)
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7
.done
	ret

;@ def EntityInit_TradingItem(slot: c)
;@ path: entity/init
;@ Init of type $AF: centred on its tile while the trading item is the last one ($0E).
EntityInit_TradingItem::
;> if wTradeSequenceItem == 0x0E: return CenterEntityOnTile(slot)
	ld a, [wTradeSequenceItem]
	cp $0e
	jr z, CenterEntityOnTile
	ret

;@ def EntityInit_Warp(slot: c)
;@ path: entity/init
;@ Init of type $61: indoors it starts in state 1, centred on its tile; nothing on the overworld.
EntityInit_Warp::
;> if not wIsIndoor: return
	ld a, [wIsIndoor]
	and a
	ret z
;> wEntityState[slot] += 1
	call IncrementEntityState
;> return CenterEntityOnTile(slot)
	jr CenterEntityOnTile

;@ def EntityInit_PickupItem(slot: c)
;@ path: entity/init
;@ Init of the pickups $2E, $2F, $32-$34 and $36-$38: common pickup setup; indoors it gets a drop timer
;@ of $80 frames, outdoors it is centred on its tile.
EntityInit_PickupItem::
;> InitPickupItem(slot)
	call InitPickupItem
;> if wIsIndoor: return SetEntityDropTimer80(slot)
	ld a, [wIsIndoor]
	and a
	jr nz, SetEntityDropTimer80
;> CenterEntityOnTile(slot)

;@ def CenterEntityOnTile(slot: c)
;@ path: entity/init
;@ Moves the entity half a tile right and down (8 pixels each, with carry into the high bytes): room
;@ data places entities at the corner of a 16x16 square.
CenterEntityOnTile::
;> AddHalfTileToCoord(slot, wEntityX, wEntityPosXHigh)
	ld de, wEntityPosXHigh
	ld hl, wEntityX
	call AddHalfTileToCoord
;> AddHalfTileToCoord(slot, wEntityY, wEntityPosYHigh)
	ld de, wEntityPosYHigh
	ld hl, wEntityY

;@ def AddHalfTileToCoord(slot: c, low: hl, high: de)
;@ path: entity/init
;@ Adds 8 to one coordinate of the entity: `low` is the array of the low byte (wEntityX or wEntityY),
;@ `high` the array of its high byte, which takes the carry.
AddHalfTileToCoord::
;> v = mem[low + slot] + 8
	add hl, bc
	ld a, [hl]
	add $08
;> mem[low + slot] = v & 0xFF
	ld [hl], a
;> carry = v >> 8
	rla
;> p = high + slot
	push de
	pop hl
	add hl, bc
	rra
;> mem[p] += carry
	ld a, [hl]
	adc $00
	ld [hl], a
	ret


;@ def EntityInit_Instrument(slot: c)
;@ path: entity/init
;@ Init of types $39 and $43: half a tile right.
EntityInit_Instrument::
;> return AddHalfTileToCoord(slot, wEntityX, wEntityPosXHigh)
	ld de, wEntityPosXHigh
	ld hl, wEntityX
	jr AddHalfTileToCoord

;@ def SetEntityDropTimer80(slot: c)
;@ path: entity/init
;@ Starts the drop timer at $80 frames.
SetEntityDropTimer80::
;> wEntityDropTimer[slot] = 0x80
	call GetEntityDropTimer
	ld [hl], $80
	ret


;@ def EntityInit_OctorokMoblin(slot: c)
;@ path: entity/init
;@ Init of types $09 and $0B: timer 1 starts at $A0 frames.
EntityInit_OctorokMoblin::
;> wEntityTimer1[slot] = 0xA0
	call GetEntityTimer1
	ld [hl], $a0
	ret


;@ def EntityInit_Ghini(slot: c)
;@ path: entity/init
;@ Init of types $10-$12: the Ghini $12 starts 16 pixels up with private variable 3 = 1; the others
;@ start in state 1.
EntityInit_Ghini::
;> if hActiveEntityType == 0x12:
	ldh a, [hActiveEntityType]
	cp $12
	jr nz, .nextState

;>     wEntityPrivate3[slot] = 1
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], $01
;>     wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;>     return
	ret


.nextState
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ path: enemy/iron-mask
;@ Sprites of the Iron Mask (type $24) while it wears its mask, for WalkingEnemyHandler: 8 variants of two
;@ 8x16 sprites, each sprite a (tile, attribute) pair (attribute $20 = x flip). Tiles $60-$6E.
IronMaskSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20, $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
;@ path: enemy/iron-mask
;@ Sprites of the Iron Mask after it lost its mask: 2 variants (animation frames) of two 8x16 sprites
;@ (tile, attribute): tiles $70/$72, the frames mirror each other.
IronMaskFaceSprites::
	db $70, $00, $72, $00, $72, $20, $70, $20

;@ path: enemy/iron-mask
;@ X speeds of the unmasked Iron Mask's 4 random directions (right, left, -, -), signed 1/16 pixel
;@ per frame.
IronMaskSpeedsX::
	db $0c, $f4, $00, $00

;@ path: enemy/iron-mask
;@ Y speeds of the same 4 directions (-, -, up, down).
IronMaskSpeedsY::
	db $00, $00, $f4, $0c

;@ def IronMaskHandler(slot: c)
;@ path: enemy/iron-mask
;@ Handler of type $24, the Iron Mask. With its mask on (private variable 2 = 0) it walks like a
;@ Moblin (WalkingEnemyHandler). Without it, it runs in a random straight direction for $20-$3F frames at a
;@ time, animating every 16 frames.
IronMaskHandler::
;> if not wEntityPrivate2[slot]:  # still masked
;>@masked     return WalkingEnemyHandler(slot, IronMaskSprites)  # walks like a Moblin
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .masked

;> DrawEntity16x16(IronMaskFaceSprites)  # draws the unmasked sprites
	ld de, IronMaskFaceSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;> Call_03_6E3D(slot)
	call Call_03_6E3D
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> Call_03_7892(slot)
	call Call_03_7892
;> if not GetEntityTimer(slot):  # time for a new direction
	call GetEntityTimer
	jr nz, .animate

;>     t = (GetRandomByte() & 0x1F) + 0x20
	call GetRandomByte
	and $1f
	add $20
;>     wEntityTimer[slot] = t
	ld [hl], a
;>     d = t & 3
	and $03
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = IronMaskSpeedsX[d]
	ld hl, IronMaskSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = IronMaskSpeedsY[d]
	ld hl, IronMaskSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.animate
;> frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)  # sets wEntitySpriteVariant
	call SetEntitySpriteVariant
;> return
	ret


.masked
;=@masked
	ld de, IronMaskSprites
	call WalkingEnemyHandler
	ret


;@ path: item/chest
;@ Background tiles of an opened chest, drawn over the chest's 16x16 square: top-left, bottom-left,
;@ top-right, bottom-right.
OpenChestTiles::
	db $62, $70, $63, $71

;@ path: item/chest
;@ Inventory item id given for chest contents $00-$0B (index = content): $03 Power Bracelet,
;@ $04 shield, $05 bow, $06 hookshot, $07 Fire Rod, $08 Pegasus Boots, $09 Ocarina, $0A feather,
;@ $0B shovel, $0C magic powder, $02 bombs, $01 sword. 12 bytes.
ChestItemInventoryIds::
	db $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $02, $01
;@ path: item/chest
;@ High byte of the rupees in chests with contents $1B-$1F (index = content - $1B).
ChestRupeesHigh::
	db $00, $00, $00, $00, $01

;@ path: item/chest
;@ Low byte of the rupees: contents $1B-$1F give 50, 20, 100, 200 and 500 rupees.
ChestRupeesLow::
	db $32, $14, $64, $c8, $f4

;@ def EntityInit_ChestItem(slot: c)
;@ path: item/chest
;@ Init of type $07, the item that rises out of a chest Link opened. The chest square becomes an open
;@ chest (object $A1), the item starts 8 pixels higher moving up, and Link gets the content (in
;@ wEntitySpriteVariant): inventory items $00-$0B (upgrading the shield and the bracelet), counters
;@ $0C-$15, dungeon items $16-$1A, rupees $1B-$1F, $20 a special case; then the room remembers that
;@ its chest is open.
EntityInit_ChestItem::
;> wLinkPoseLock = 0x2A
	ld a, $2a
	ld [wLinkPoseLock], a
;> hNoiseSfx = 4
	ld a, $04
	ldh [hNoiseSfx], a
;> ReplaceRoomObjectAtEntity(slot, OpenChestTiles, 0xA1)
	ld de, OpenChestTiles
	ld b, $a1
	call ReplaceRoomObjectAtEntity
;> wEntityY[slot] -= 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
;> wEntitySpeedY[slot] = -4
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fc
;> content = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
;> hBGTilesRequestCopy = content  # used as scratch here
	ldh [hBGTilesRequestCopy], a
;> if content == 0x11:
	ld d, b
	cp $11
	jr nz, .dispatch

;>     other = mem[0xC501]
	push af
	ld a, [$c501]
	ld e, a
;>     wEntityTimer1[other] = 0x38
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $38
	pop af

.dispatch
;> if content >= 0x21: return MarkRoomChestOpened()
	ld e, a
	cp $21
	jp nc, MarkRoomChestOpened

;> if content == 0x20: return AddSeashell(slot)
	cp $20
	jr nz, .rupees

	jp AddSeashell


.rupees
;> if 0x1B <= content < 0x20:
	cp $1b
	jr c, .dungeonItem

	cp $20
	jr nc, .dungeonItem

;>     wAddRupeeBufferLow = ChestRupeesLow[content - 0x1B]
	ld hl, ChestRupeesLow - $1b
	add hl, de
	ld a, [hl]
	ld [wAddRupeeBufferLow], a
;>     wAddRupeeBufferHigh = ChestRupeesHigh[content - 0x1B]
	ld hl, ChestRupeesHigh - $1b
	add hl, de
	ld a, [hl]
	ld [wAddRupeeBufferHigh], a
;>     mem[0xC3CE] = 0x18
	ld a, $18
	ld [wRupeeCountDelay], a
;>     return MarkRoomChestOpened()
	jr MarkRoomChestOpened

.dungeonItem
;> if 0x16 <= content < 0x1B:  # map, compass, stone beak, nightmare key, small key
	cp $16
	jr c, .inventory

	cp $1b
	jr nc, .inventory

;>     wDungeonHasMap[content - 0x16] += 1
	sub $16
	ld e, a
	ld d, $00
	ld hl, wDungeonHasMap
	add hl, de
	inc [hl]
;>     SaveDungeonItemFlags()
	call SaveDungeonItemFlags
;>     return MarkRoomChestOpened()
	jr MarkRoomChestOpened

.inventory
;> if content < 0x0C:
	cp $0c
	jr nc, .counter

;>     if content == 1: wShieldLevel += 1
	ldh a, [hBGTilesRequestCopy]
	cp $01
	jr nz, .bracelet

	ld hl, wShieldLevel
	inc [hl]

.bracelet
;>     if content == 0 and wPowerBraceletLevel != 2:
	cp $00
	jr nz, .bombs

	ld a, [wPowerBraceletLevel]
	cp $02
	jr z, .bombs

;>         wPowerBraceletLevel += 1
	ld hl, wPowerBraceletLevel
	inc [hl]

.bombs
;>     if content == 0x0A:
	ldh a, [hBGTilesRequestCopy]
	cp $0a
	jr nz, .give

;>         wBombCount = to_bcd(bcd_to_int(wBombCount) + 1)
	ld hl, wBombCount
	ld a, [hl]
	add $01
	daa
	ld [hl], a

.give
;>     GiveInventoryItem(ChestItemInventoryIds[content])  # puts the item in the inventory
	ld d, b
	ld hl, ChestItemInventoryIds
	add hl, de
	ld d, [hl]
	call GiveInventoryItem
;>     return MarkRoomChestOpened()
	jr MarkRoomChestOpened

.counter
;> mem[wItemB + content] += 1  # contents $0C-$15 count up the byte at $DB00 + content
	ld hl, wItemB
	add hl, de
	inc [hl]
;> MarkRoomChestOpened()

;@ def MarkRoomChestOpened()
;@ path: item/chest
;@ Sets bit 4 of the current room's status (the chest is open) in wRoomStatus and hRoomStatus.
MarkRoomChestOpened::
;> p = GetRoomStatusAddress_03()
	call GetRoomStatusAddress_03
;> mem[p] |= 0x10
	ld a, [hl]
	or $10
	ld [hl], a
;> hRoomStatus = mem[p]
	ldh [hRoomStatus], a
	ret


;@ def GetRoomStatusAddress_03() -> hl
;@ path: world/rooms
;@ Address of the current room's byte in wRoomStatus: the overworld uses the first 256 bytes, the
;@ indoor maps $06-$19 the third block, the other indoor maps the second.
GetRoomStatusAddress_03::
;> group = wIsIndoor
	ld a, [wIsIndoor]
	ld d, a
;> base = wRoomStatus
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
;> if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .add

	cp $06
	jr c, .add

;>     group += 1
	inc d

.add
;> return base + group * 0x100 + hMapRoom
	add hl, de
	ret


;@ path: object/block
;@ Floor tiles drawn where a block was pushed away in room $C7 (top-left, bottom-left, top-right,
;@ bottom-right).
BlockFloorTilesRoomC7::
	db $6a, $7a, $6b, $7b

;@ path: object/block
;@ Floor tiles drawn where a block was pushed away indoors (same order).
BlockFloorTilesIndoor::
	db $10, $12, $11, $13

;@ path: object/block
;@ Tiles of the block drawn where a pushed block stops indoors (same order).
FloorTiles5201::
	db $f8, $f9, $fa, $fb

;@ path: object/block
;@ Tiles of the block drawn where a pushed block stops on the overworld (same order).
FloorTiles5205::
	db $0e, $1e, $0f, $1f
;@ path: object/block
;@ Ground tiles drawn where a block was pushed away on the overworld (same order).
BlockFloorTilesOutdoor::
	db $68, $77, $69, $4b

;@ def EntityInit_PushedBlock(slot: c)
;@ path: object/block
;@ Init of type $06, a block Link pushes: it moves away from Link; if it would hit a wall at once it
;@ vanishes, otherwise its square becomes floor (object $C6 outdoors, $0D indoors, $BE in room $C7).
EntityInit_PushedBlock::
;> d = GetEntityDirectionToLink_03(slot)
	call GetEntityDirectionToLink_03
	ld d, $00
;> wEntitySpeedX[slot] = PushedBlockSpeedsX[d]
	ld hl, PushedBlockSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = PushedBlockSpeedsY[d]
	ld hl, PushedBlockSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> PushedBlockHandler(slot)
	call PushedBlockHandler
;> Call_03_7892(slot)  # background collision
	call Call_03_7892
;> if wEntityCollisions[slot]: return Call_3FB7(slot)  # frees the slot
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .moves

	jp Call_3FB7


.moves
;> hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;> tiles, obj = BlockFloorTilesOutdoor, 0xC6
	ld de, BlockFloorTilesOutdoor
	ld b, $c6
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, ReplaceRoomObjectAtEntity

;>     tiles, obj = BlockFloorTilesIndoor, 0x0D
	ld de, BlockFloorTilesIndoor
	ld b, $0d
;>     if hMapRoom == 0xC7: tiles, obj = BlockFloorTilesRoomC7, 0xBE
	ldh a, [hMapRoom]
	cp $c7
	jr nz, ReplaceRoomObjectAtEntity

	ld de, BlockFloorTilesRoomC7
	ld b, $be
;> ReplaceRoomObjectAtEntity(slot, tiles, obj)

;@ def ReplaceRoomObjectAtEntity(tiles: de, obj: b)
;@ path: world/objects
;@ Puts object `obj` into wRoomObjects at the 16x16 square under the active entity and queues the
;@ square's four background tiles from `tiles`.
ReplaceRoomObjectAtEntity::
;> b = 0  # obj and tiles wait on the stack
	push de
	ld a, b
	push af
	ld b, $00
;> hBGPosY = hActiveEntityY - 0x0F
	ldh a, [hActiveEntityY]
	sub $0f
	ldh [hBGPosY], a
;> hBGPosX = hActiveEntityX - 7
	ldh a, [hActiveEntityX]
	sub $07
	ldh [hBGPosX], a
;> square = (hBGPosY & 0xF0) | (hBGPosX >> 4)
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
;> wRoomObjects[square] = obj
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	pop af
	ld [hl], a
;> DrawRoomObjectTiles(tiles)

;@ def DrawRoomObjectTiles(tiles: de)
;@ path: world/objects
;@ Queues a background draw of one 16x16 square at (hBGPosX, hBGPosY): two commands of 2 tiles going
;@ down ($81), the left column tiles[0], tiles[1], the right column tiles[2], tiles[3]. 10 bytes plus
;@ the end mark.
DrawRoomObjectTiles::
;> GetBGAddress()  # hBGAddrHigh/Low of the square
	call GetBGAddress
;> cmd = wDrawCommand + wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize += 10
	add $0a
	ld [wDrawCommandsSize], a
;> mem[cmd + 0] = hBGAddrHigh
	pop de
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x81  # 2 tiles, going down
	ld a, $81
	ld [hli], a
;> mem[cmd + 3] = tiles[0]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 4] = tiles[1]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 5] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 6] = hBGAddrLow + 1
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;> mem[cmd + 7] = 0x81
	ld a, $81
	ld [hli], a
;> mem[cmd + 8] = tiles[2]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 9] = tiles[3]
	ld a, [de]
	ld [hli], a
;> mem[cmd + 10] = 0  # end of the queue
	xor a
	ld [hl], a
	ret


;@ path: object/block
;@ Sprites of a pushed block, by wIsIndoor: variant 0 (overworld) tile $6E twice, the right one
;@ x-flipped; variant 1 (indoors) tiles $F8/$FA with palette 1. (tile, attribute) pairs.
PushedBlockSprites::
	db $6e, $00, $6e, $20, $f8, $10, $fa, $10

;@ path: object/block
;@ X speed of a pushed block by the direction from the block to Link (0 right, 1 left, 2 up, 3 down):
;@ it moves the other way, 8/16 pixel per frame.
PushedBlockSpeedsX::
	db $f8, $08, $00, $00

;@ path: object/block
;@ Y speed of a pushed block, same index.
PushedBlockSpeedsY::
	db $00, $00, $08, $f8

;@ def PushedBlockHandler(slot: c)
;@ path: object/block
;@ Handler of type $06. The block slides for $20 frames, pushing entities in its way and holding Link
;@ back; then it becomes a block object again (object $C4 outdoors, $A6 indoors) where it stopped,
;@ unless it fell into a pit. Room events 2 (push a block) and 7 (with object $A6/$A7 under it) fire.
PushedBlockHandler::
;> hActiveEntitySpriteVariant = wIsIndoor
	ld a, [wIsIndoor]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(PushedBlockSprites)  # draws the block
	ld de, PushedBlockSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> Call_03_5343(slot)  # pushes the entities it touches
	call Call_03_5343
;> if Call_03_6C93(slot):  # carry: the block touches Link
	call Call_03_6C93
	jr nc, .moving

;>     RestoreLinkPosition()
	call RestoreLinkPosition
;>     wLinkPushingTimer = 3
	ld a, $03
	ld [wLinkPushingTimer], a

.moving
;> if hMapRoom == 0xC7 or not wIsIndoor:
	ldh a, [hMapRoom]
	cp $c7
	jr z, .freeze

	ld a, [wIsIndoor]
	and a
	jr nz, .count

.freeze
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a

.count
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] != 0x21: return
	cp $21
	jr nz, .done

;> wEntityIgnoreHitsTimer[slot] = 0x21
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], a
;> Call_03_7892(slot)  # background collision (may make it fall into a pit)
	call Call_03_7892
;> status = wEntityStatus[slot]
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
;> if status in (0, 2): return  # gone, or falling into a pit
	and a
	jr z, .done

	cp $02
	jr z, .done

;> Call_3FB7(slot)  # frees the slot
	call Call_3FB7
;> tiles, obj = FloorTiles5205, 0xC4
	ld de, FloorTiles5205
	ld b, $c4
;> if wIsIndoor: tiles, obj = FloorTiles5201, 0xA6
	ld a, [wIsIndoor]
	and a
	jr z, .place

	ld de, FloorTiles5201
	ld b, $a6

.place
;> ReplaceRoomObjectAtEntity(slot, tiles, obj)
	call ReplaceRoomObjectAtEntity
;> event = wRoomEvent & 0x1F
	ld a, [wRoomEvent]
	and $1f
;> if event == 2: return TriggerRoomEvent()
	cp $02
	jr z, .trigger

;> if event != 7: return
	cp $07
	jr nz, .done

;> Call_03_7892(slot)
	call Call_03_7892
;> if mem[0xC503] not in (0xA7, 0xA6): return
	ld a, [$c503]
	cp $a7
	jr z, .trigger

	cp $a6
	jr nz, .done

.trigger
;> TriggerRoomEvent()
	call TriggerRoomEvent

.done
	ret


;@ def Call_03_5343(slot: c)
;@ path: object/block
;@ The pushed block hits every entity (slots 15-0) it overlaps: active ones (status 5 and up) without
;@ physics bits 6 and 5, closer than 12 pixels in x and in drawn y, get Call_03_6FE1 with weapon 8.
Call_03_5343::
;>@loop for other in range(15, -1, -1):
	ld e, $0f
	ld d, b

.loop
;>     if wEntityStatus[other] < 5: continue
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr c, .next

;>     if wEntityPhysicsFlags[other] & 0x40: continue
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $40
	jr nz, .next

;>     dx = hActiveEntityX - wEntityX[other]
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
;>     if (dx + 12) & 0xFF >= 0x18: continue
	add $0c
	cp $18
	jr nc, .next

;>     dy = wEntityY[other] - wEntityZ[other]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, de
	sub [hl]
;>     dy -= hActiveEntityDrawY
	ld hl, hActiveEntityDrawY
	sub [hl]
;>     if (dy + 12) & 0xFF >= 0x18: continue
	add $0c
	cp $18
	jr nc, .next

;>     if wEntityPhysicsFlags[other] & 0x20: continue
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $20
	jr nz, .next

;>     target = other  # the other entity becomes the slot in c
	push bc
	push de
	pop bc
	push de
;>     Call_03_6FE1(target, 8)
	ld a, $08
	call Call_03_6FE1
	pop de
	pop bc

.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jp nz, .loop

	ret


;@ def EntityHandler_Type4B(slot: c)
;@ path: object/liftable
;@ Handler of type $4B: the same as LiftableObjectHandler (d is cleared first, but set again before
;@ it is used).
EntityHandler_Type4B::
;> LiftableObjectHandler(slot)
	ld d, $00

;@ def LiftableObjectHandler(slot: c)
;@ path: object/liftable
;@ Handler of type $05, a pot or rock Link lifted and threw (sprite variant 0 = pot, 1 = rock). While
;@ timer 1 is 0 it flies (UpdateThrownObject); when it breaks, timer 1 counts the pieces' animation
;@ down. On the last frame a pot may leave a fairy (private variable 5 set, 1 in 4), and in the maps
;@ $10 and $1E Marin, if she is with Link, comments on the broken pot.
LiftableObjectHandler::
;> mem[0xC50C] = slot
	ld a, c
	ld [wLiftableObjectSlot], a
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> hMultiPurpose0 = t
	ldh [hMultiPurpose0], a
;> if t == 0: return UpdateThrownObject(slot)
	jp z, UpdateThrownObject

;>@pieces if t != 1: return ShatterThrownObject()  # draws the pieces (code in bank $19)
	cp $01
	jr nz, .pieces

;> if wEntityPrivate5[slot]:
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	and a
	jr z, .marin

;>     if GetRandomByte() & 3 == 0:
	call GetRandomByte
	and $03
	jr nz, .marin

;>         fairy = SpawnEntity_03(0x2F)  # carry: no free slot
	ld a, $2f
	call SpawnEntity_03
;>         if fairy is not None:
	jr c, .marin

;>             wEntityX[fairy] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[fairy] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             wEntityZ[fairy] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>             wEntityDropTimer[fairy] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80

.marin
;> if hActiveEntitySpriteVariant == 0:  # a pot
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr nz, .free

;>     if hMapId in (0x1E, 0x10):
	ldh a, [hMapId]
	cp $1e
	jr z, .withMarin

	cp $10
	jr nz, .free

.withMarin
;>         if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .free

;>             if GetRandomByte() & 0x3F == 0:
	call GetRandomByte
	and $3f
	jr nz, .usual

;>                 OpenDialog(0x28)
	ld a, $28
	call OpenDialog
;>                 return Call_3FB7(slot)  # frees the slot
	jp Call_3FB7


.usual
;>             OpenDialogTable1(0x99)
	ld a, $99
	call OpenDialogTable1

.free
;> return Call_3FB7(slot)
	jp Call_3FB7


.pieces
;=@pieces
	call ShatterThrownObject
	ret


;@ path: object/liftable
;@ Sprites of a thrown pot or rock, by sprite variant: 0 = pot (tiles $F0/$F2), 1 = rock (tiles
;@ $F4/$F6), each two 8x16 sprites as (tile, attribute) pairs with palette 1.
LiftableObjectSprites::
	db $f0, $10, $f2, $10, $f4, $10, $f6, $10

;@ def UpdateThrownObject(slot: c)
;@ path: object/liftable
;@ A thrown pot or rock in flight: it hits the entities it meets (weapon $0B), and breaks when it lands
;@ or hits a wall (where room events may fire).
UpdateThrownObject::
;> DrawEntity16x16(LiftableObjectSprites)  # draws it
	ld de, LiftableObjectSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> wProjectileWeaponType = 0x0B  # a thrown object
	ld a, $0b
	ld [wProjectileWeaponType], a
;> Call_03_75A6(slot)  # hits the other entities
	call Call_03_75A6
;> UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;> if wEntityStatus[slot] == 2: return  # falls into a pit
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, ThrownObjectDone

;> if wEntityZ[slot] == 0: return BreakThrownObject(slot)  # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, BreakThrownObject

;> if not wEntityCollisions[slot]: return
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, ThrownObjectDone

;> CheckThrownObjectRoomEvents(slot)
	call CheckThrownObjectRoomEvents
;> BreakThrownObject(slot)

;@ def BreakThrownObject(slot: c)
;@ path: object/liftable
;@ A thrown object breaks: a pot ($FF or 1 = special variants keep the long version) plays noise 5
;@ for $1F frames of pieces, others noise 9 for $0F frames; it now uses 2 more OAM sprites.
BreakThrownObject::
;> hNoiseSfx = 5
	ld hl, hNoiseSfx
	ld [hl], $05
;> frames = 0x1F
	ld e, $1f
;> if hActiveEntitySpriteVariant not in (0xFF, 1):
	ldh a, [hActiveEntitySpriteVariant]
	cp $ff
	jr z, .start

	cp $01
	jr z, .start

;>     hNoiseSfx = 9
	ld [hl], $09
;>     frames = 0x0F
	ld e, $0f

.start
;> wEntityTimer1[slot] = frames
	ld hl, wEntityTimer1
	add hl, bc
	ld [hl], e
;> wEntityPhysicsFlags[slot] += 2  # two more sprites for the pieces
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	add $02
	ld [hl], a

ThrownObjectDone:
	ret


;@ def BreakIntoPieces(slot: c)
;@ path: object/liftable
;@ Replaces the entity in `slot` by breaking pot pieces: a new type $05 entity at (hMultiPurpose0,
;@ hMultiPurpose1 - hMultiPurpose3), variant 0, already breaking ($0F frames, 4 OAM sprites, noise 9).
;@ Called from bank 0.
BreakIntoPieces::
;> pieces = SpawnEntity_03(0x05)
	ld a, $05
	call SpawnEntity_03
;> if pieces is None: return  # no free slot
	jr c, .done

;> wEntityX[pieces] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[pieces] = hMultiPurpose1 - hMultiPurpose3
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	sub [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpriteVariant[pieces] = 0
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $00
;> wEntityTimer1[pieces] = 0x0F
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
;> wEntityPhysicsFlags[pieces] = 0xC4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4
;> hNoiseSfx = 9
	ld a, $09
	ldh [hNoiseSfx], a
;> Call_3FB7(slot)  # frees the old slot
	call Call_3FB7

.done
	ret


;@ def CheckThrownObjectRoomEvents(slot: c)
;@ path: object/liftable
;@ A thrown object hit a wall. Room event $0D: if the object it hit ($C503 or $C50D) is $A0, the
;@ square at (x $30, y $20) changes ($19) and the event fires. Room event $0B: it fires when $C50D is
;@ in $35-$3C, or else $C503 is.
CheckThrownObjectRoomEvents::
;> if not wEntityCollisions[slot]: return
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;> event = wRoomEvent & 0x1F
	ld a, [wRoomEvent]
	and $1f
;> if event == 0x0D:
	cp $0d
	jr nz, .event0B

;>     if mem[0xC503] != 0xA0 and mem[0xC50D] != 0xA0: return
	ld a, [$c503]
	cp $a0
	jr z, .open

	ld a, [$c50d]
	cp $a0
	jr nz, .done

.open
;>     hBGPosX = 0x30
	ld a, $30
	ldh [hBGPosX], a
;>     hBGPosY = 0x20
	ld a, $20
	ldh [hBGPosY], a
;>     hMultiPurpose8 = 0x19
	ld a, $19
	ldh [hMultiPurpose8], a
;>     Call_3E7D()  # changes that square
	call Call_3E7D
;>     return TriggerRoomEvent()
	jp TriggerRoomEvent


.event0B
;> if event != 0x0B: return
	cp $0b
	jr nz, .done

;> hit = mem[0xC50D]
	ld a, [$c50d]
;> if hit < 0x35: return
	cp $35
	jr c, .done

;> if hit >= 0x3D:
	cp $3d
	jr c, .fire

;>     if not 0x35 <= mem[0xC503] < 0x3D: return
	ld a, [$c503]
	cp $35
	jr c, .done

	cp $3d
	jr nc, .done

.fire
;> TriggerRoomEvent()
	call TriggerRoomEvent

.done
	ret


;@ path: unused
;@ 8 bytes no code refers to: two sprite pairs (tile, attribute) of tiles $32 and $30, the right one
;@ flipped both ways.
UnusedSprites54E6::
	db $32, $00, $32, $60, $30, $00, $30, $60

;@ path: entity/status
;@ The puff of smoke of a dying entity: 4 stages of 4 OAM entries (y offset, x offset, tile,
;@ attributes; $FF bytes = no sprite), 16 bytes each. Stage = (wEntityDyingTimer >> 3) & 3, so stage 3
;@ comes first: four tiles $30 spreading out, then $3A puffs, then small $3A, then $3C.
DeathPoofSprites::
	db $00, $00, $3c, $00, $00, $08, $3c, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $3a, $00, $00, $08, $3a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fa, $fa, $3a, $00, $fa, $02, $3a, $20, $06, $06, $3a, $00, $06, $0e, $3a, $20, $04, $fc, $30, $00, $04, $04, $30, $20, $fc, $04, $30, $00, $fc, $0c, $30, $20

;@ path: entity/status
;@ The bigger death puff (used when $C4A0 of the entity is set): stages 0-2 as 4 OAM entries (y, x,
;@ tile, attributes) of tile $3A, stage 3 (first) 8 entries: a 32x16 burst of tiles $10/$12 mirrored
;@ in all four directions. 80 bytes.
DeathPoofLargeSprites::
	db $00, $00, $3a, $00, $00, $08, $3a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $f8, $3a, $00, $f8, $00, $3a, $20, $08, $08, $3a, $00, $08, $10, $3a, $20, $08, $f8, $3a, $00, $08, $00, $3a, $20, $f8, $08, $3a, $00, $f8, $10, $3a, $20, $f8, $f8, $10, $00, $f8, $00, $12, $00, $f8, $08, $12, $20, $f8, $10, $10, $20, $08, $f8, $10, $40, $08, $00, $12, $40, $08, $08, $12, $60, $08, $10, $10, $60

;@ def EntityStatus1Handler(slot: c)
;@ path: entity/status
;@ Status 1: the entity dies. Bosses (option bit 7) run their own death code in their handler. Others
;@ flash for a moment ($20 and more on wEntityDyingTimer, handler still running), then vanish in a puff
;@ of smoke; at 0 Call_3F7A drops an item and frees the slot.
EntityStatus1Handler::
;> if wEntityOptions1[slot] & 0x80: return RunEntityHandler()  # a boss: its own handler
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .normal
	jp RunEntityHandler
.normal
;> t = wEntityDyingTimer[slot]
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
;> if t == 0: return Call_3F7A()  # drops the item, frees the slot
	and a
	jp z, Call_3F7A
;> large = mem[0xC4A0 + slot]
	push af
	ld hl, $c4a0
	add hl, bc
	ld a, [hl]
;> sprites = DeathPoofLargeSprites if large else DeathPoofSprites
	ld hl, DeathPoofSprites
	and a
	jr z, .small
	ld hl, DeathPoofLargeSprites
.small
;> if t >= 0x20:  # still flashing
;>@f1     RunEntityHandlerFrom3()  # runs the type's own handler, then switches bank 3 back in
;>@f2     ReturnIfGameFrozen_03()
;>@f3     if not wEntityIgnoreHitsTimer[slot]:
;>@f4         wEntityDyingTimer[slot] = 0x1F  # the puff starts
;>@f5         if wActivePowerUp == 1: hWaveSfx = 0x12
;>@f6         hNoiseSfx = 0x13
;>@f7     ApplyRecoilIfNeeded_03(slot)
;>@f8     return
	pop af
	cp $20
	jr nc, .flash
;> stage = (t << 1) & 0x30  # 16 bytes per stage
	rla
	and $30
	ld e, a
	ld d, b
	add hl, de
;> big = mem[0xC4A0 + slot] if stage == 0x30 else 0
	cp $30
	jr nz, .four
	push hl
	ld hl, $c4a0
	add hl, bc
	ld a, [hl]
;> if big:  # the large puff's first stage has 8 sprites
;>@b1     DrawEntitySprites(sprites + stage, 8)  # draws 8 OAM entries
;>@b2     ReserveOAMEntriesFar(4)
	pop hl
	and a
	jr nz, .eight
.four
;> else:
;>     DrawEntitySprites(sprites + stage, 4)  # draws 4 OAM entries
	ld c, $04
	call DrawEntitySprites
	jr .drawn
.eight
;=@b1
	ld c, $08
	call DrawEntitySprites
;=@b2
	ld a, $04
	call ReserveOAMEntriesFar
	jr .drawn
.drawn
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;> return
	ret
.flash
;=@f1
	call RunEntityHandlerFrom3
;=@f2
	call ReturnIfGameFrozen_03
;=@f3
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .recoil
;=@f4
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
;=@f5
	ld a, [wActivePowerUp]
	cp $01
	jr nz, .noise
	ld a, $12
	ldh [hWaveSfx], a
.noise
;=@f6
	ld hl, hNoiseSfx
	ld [hl], $13
.recoil
;=@f7
	call ApplyRecoilIfNeeded_03
;=@f8
	ret
;@ path: item/drops
;@ Item dropped by a defeated entity, by drop class 1-14 (the class comes from EntityGroupTable487F;
;@ entry c is at DropItemByClass + c - 1): entity types $2D heart, $2E rupee, $2F fairy, $37 arrows,
;@ $38 bombs; $FF = a random one from RandomDropItems.
DropItemByClass::
	db $2e, $2e, $2d, $2d, $37, $2d, $ff, $ff, $2f, $37, $38, $2e, $2f, $2f

;@ path: item/drops
;@ Drop chance by drop class 1-14: an item drops when (random byte AND mask) == 0, so 0 = always,
;@ 1 = 1 in 2, 3 = 1 in 4.
DropChanceMasks::
	db $03, $01, $01, $00, $03, $03, $03, $03, $01, $00, $00, $00, $03, $00

;@ path: item/drops
;@ The same masks while Link's health is low (wLowHealth): better chances.
DropChanceMasksLowHealth::
	db $01, $01, $01, $00, $01, $01, $01, $01, $01, $00, $00, $00, $01, $00

;@ path: item/drops
;@ The 8 entity types a random drop ($FF in DropItemByClass) picks from (random byte & 7): rupee,
;@ heart, bombs, fairy, rupee, heart, bombs, arrows.
RandomDropItems::
	db $2e, $2d, $38, $2f, $2e, $2d, $38, $37

;@ def DropDefeatedEntityItem(slot: c)
;@ path: item/drops
;@ Leaves the item of a defeated entity. A Like Like that swallowed something gives it back (type
;@ $31); a fixed wEntityDropType ($FF = nothing) wins; every 12th kill drops a Guardian Acorn ($34)
;@ and every $1E-$28th (more hearts = rarer) a Piece of Power ($33), not during boss fights, side
;@ view or an active power-up; otherwise the drop class of the health group decides. The item pops
;@ out where the entity was.
DropDefeatedEntityItem::
;> if hActiveEntityType == 0x23:  # a Like Like
	ldh a, [hActiveEntityType]
	cp $23
	jr nz, .fixedDrop

;>     if wEntityPrivate1[slot]:  # it swallowed the shield
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .fixedDrop

;>         return SpawnDrop(slot, 0x31)
	ld a, $31
	jp SpawnDrop


.fixedDrop
;> drop = wEntityDropType[slot]
	ld hl, wEntityDropType
	add hl, bc
	ld a, [hl]
;> if drop == 0xFF: return
	cp $ff
	ret z

;> if drop: return SpawnDrop(slot, drop)
	and a
	jp nz, SpawnDrop

;> mem[0xD471] += 1  # kill counter for the acorn
	ld a, [$d471]
	inc a
	ld [$d471], a
;> if mem[0xD471] >= 12:
	cp $0c
	jr c, .byClass

;>     mem[0xD471] = 0
	xor a
	ld [$d471], a
;>     if not (wBossInRoom | wActivePowerUp | hIsSideScrolling):
	ld a, [wBossInRoom]
	ld hl, wActivePowerUp
	or [hl]
	ld hl, hIsSideScrolling
	or [hl]
	jr nz, .byClass

;>         return SpawnDrop(slot, 0x34)  # Guardian Acorn
	ld a, $34
	jp SpawnDrop


.byClass
;> group = wEntityHealthGroup[slot]
	ld hl, wEntityHealthGroup
	add hl, bc
	ld d, b
	ld e, [hl]
;> cls = EntityGroupTable487F[group]  # drop class
	ld hl, EntityGroupTable487F
	add hl, de
	ld a, [hl]
;> if cls == 0: return  # drops nothing
	and a
	ret z

;> limit = 0x1E
	ld e, a
	ld d, $1e
;> if wMaxHearts >= 7: limit = 0x23
	ld a, [wMaxHearts]
	cp $07
	jr c, .count

	ld d, $23
;> if wMaxHearts >= 11: limit = 0x28
	cp $0b
	jr c, .count

	ld d, $28

.count
;> mem[0xD415] += 1  # kill counter for the Piece of Power
	ld hl, wKillCounter
	inc [hl]
;> if mem[0xD415] >= limit:
	ld a, [hl]
	cp d
	jr c, .chance

;>     mem[0xD415] = 0
	ld [hl], b
;>     if not (wBossInRoom | hIsSideScrolling | wActivePowerUp):
	ld a, [wBossInRoom]
	ld hl, hIsSideScrolling
	or [hl]
	ld hl, wActivePowerUp
	or [hl]
	jr nz, .chance

;>         return SpawnDrop(slot, 0x33)  # Piece of Power
	ld a, $33
	jr SpawnDrop

.chance
;> masks = DropChanceMasksLowHealth if wLowHealth else DropChanceMasks
	ld d, b
	ld hl, DropChanceMasks - 1
	ld a, [wLowHealth]
	and a
	jr z, .roll

	ld hl, DropChanceMasksLowHealth - 1

.roll
;> if GetRandomByte() & masks[cls - 1]: return
	add hl, de
	call GetRandomByte
	and [hl]
	ret nz

;> drop = DropItemByClass[cls - 1]
	ld hl, DropItemByClass - 1
	add hl, de
	ld a, [hl]
;> if drop == 0xFF:
	cp $ff
	jr nz, SpawnDrop

;>     r = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     drop = RandomDropItems[r]
	ld hl, RandomDropItems
	add hl, de
	ld a, [hl]
;> SpawnDrop(slot, drop)

;@ def SpawnDrop(slot: c, drop: a)
;@ path: item/drops
;@ Spawns entity type `drop` where the defeated entity was (it inherits private variable 1 and the
;@ height) and makes it pop up: up into the air, or upwards in side view. A key ($30) from the Armos
;@ Knight uses sprite variant 3; the slime key ($3C) in rooms $58 and $5A flies towards Link.
SpawnDrop::
;> item = SpawnEntity_03(drop)  # at the entity's place
	call SpawnEntity_03
;> if item is None: return
	ret c

;> wEntityPrivate1[item] = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], a
;> wEntityX[item] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[item] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityDropTimer[item] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
;> wEntityTimer1[item] = 0x18
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $18
;> wEntityDyingTimer[item] = 3
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $03
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .sideView

;>     itemType = wEntityType[item]
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
;>     if itemType == 0x30 and hActiveEntityType == 0x88:  # key from the Armos Knight
	cp $30
	jr nz, .slimeKey

	ldh a, [hActiveEntityType]
	cp $88
	jr nz, .slimeKey

;>         wEntitySpriteVariant[item] = 3
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $03
;>         itemType = 0x88  # (a now holds the Armos Knight's type)
.slimeKey
;>     if itemType == 0x3C:  # the slime key
	cp $3c
	jr nz, .popUp

;>         if hMapRoom in (0x58, 0x5A):
	ldh a, [hMapRoom]
	cp $58
	jr z, .towardLink

	cp $5a
	jr nz, .popUp

.towardLink
;>             target = item  # the item becomes the slot in c
	push bc
	push de
	push de
	pop bc
;>             Call_03_7E99(target, 0x10)  # sets its speed towards Link
	ld a, $10
	call Call_03_7E99
	pop de
	pop bc

.popUp
;>     wEntitySpeedZ[item] = 0x18  # pops up
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $18
	jr .height

.sideView
;> else:
;>     wEntitySpeedY[item] = -20
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $ec

.height
;> wEntityZ[item] = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;> return
	ret


;@ path: object/liftable
;@ Frames of each lift step (wEntityLiftStep 0-3) when Link lifts an entity: 1, 8, 8, 16.
LiftStepFrames::
	db $01, $08, $08, $10

;@ path: object/liftable
;@ Faster lift steps (bombs, the Level-2 Power Bracelet, a Piece of Power): 1, 4, 4, 10.
LiftStepFramesStrong::
	db $01, $04, $04, $0a

;@ path: object/liftable
;@ Link's pose while he lifts, by direction and step: entry (direction * 4 + step - 1), steps 1-4,
;@ directions right, left, up, down. $37/$39/$3B/$3D = lifting poses, 1 = holding it over his head.
LiftLinkPoses::
	db $37, $37, $37, $01, $39, $39, $39, $01, $3b, $3b, $3b, $01, $3d, $3d, $3d, $01

;@ path: object/liftable
;@ X of the lifted entity relative to Link, same index (signed pixels): in front of him first, then
;@ over his head.
LiftOffsetsX::
	db $10, $10, $08, $00, $f0, $f0, $f8, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff

;@ path: object/liftable
;@ Y of the lifted entity relative to Link (added to wLinkSpriteDY too), same index.
LiftOffsetsY::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $00

;@ path: object/liftable
;@ Height of the lifted entity above Link's height, same index (in side view it is subtracted from y).
LiftOffsetsZ::
	db $00, $00, $08, $0e, $00, $00, $08, $0e, $00, $00, $08, $0e, $00, $00, $00, $0e

;@ def EntityStatus7Handler(slot: c)
;@ path: entity/status
;@ Status 7: Link lifts or carries the entity. Each lift step (4 of them) lasts LiftStepFrames frames;
;@ the entity is kept at Link's hands or over his head. A bomb keeps ticking (Call_03_673D) instead of
;@ running its handler.
EntityStatus7Handler::
;> wCarriedEntityType = hActiveEntityType
	ldh a, [hActiveEntityType]
	ld [wCarriedEntityType], a
;> if hActiveEntityType == 2:  # a bomb
	cp $02
	jr nz, .handler

;>     wEntityFlashTimer[slot] = 0
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], b
;>     Call_03_673D(slot)
	call Call_03_673D
	jr .step

.handler
;> else:
;>     RunEntityHandlerFrom3()  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3

.step
;> step = wEntityLiftStep[slot]
	ld hl, wEntityLiftStep
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
;> if step != 4:
	cp $04
	jr z, .place

;>     hLinkDirection = wLiftDirection
	ld a, [wLiftDirection]
	ldh [hLinkDirection], a
;>     if GetEntityTimer(slot) == 0:
	push hl
	call GetEntityTimer
	pop hl
	and a
	jr nz, .place

;>         wEntityLiftStep[slot] += 1
	inc [hl]
;>         frames = LiftStepFrames
	ld hl, LiftStepFrames
;>         strong = hActiveEntityType == 2 or wPowerBraceletLevel >= 2
	ldh a, [hActiveEntityType]
	cp $02
	jr z, .strong

	ld a, [wPowerBraceletLevel]
	cp $02
	jr nc, .strong

;>         if strong or wActivePowerUp == 1:
	ld a, [wActivePowerUp]
	cp $01
	jr nz, .setTimer

.strong
;>             frames = LiftStepFramesStrong
	ld hl, LiftStepFramesStrong

.setTimer
;>         wEntityTimer[slot] = frames[step]
	add hl, de
	ld a, [hl]
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], a

.place
;> if step == 0: step = 1
	ld a, e
	cp $00
	jr nz, .call

	inc e

.call
;> PlaceLiftedEntity(slot, step)
	call PlaceLiftedEntity
;> Call_03_5840()
	call Call_03_5840
	ret


;@ def PlaceLiftedEntity(slot: c, step: e)
;@ path: object/liftable
;@ Puts a lifted entity at Link's hands for lift step `step` (1-4) and Link's direction, and sets
;@ Link's lift pose.
PlaceLiftedEntity::
;> i = hLinkDirection * 4 + step - 1
	ldh a, [hLinkDirection]
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
;> wIsCarryingLiftedObject = LiftLinkPoses[i]
	ld hl, LiftLinkPoses - 1
	add hl, de
	ld a, [hl]
	ld [wIsCarryingLiftedObject], a
;> x = hLinkX + LiftOffsetsX[i]
	ld hl, LiftOffsetsX - 1
	add hl, de
	ld a, [hl]
	ld hl, hLinkX
	add [hl]
;> wEntityX[slot] = x
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> y = hLinkY + LiftOffsetsY[i]
	ld hl, LiftOffsetsY - 1
	add hl, de
	ld a, [hl]
	ld hl, hLinkY
	add [hl]
;> wEntityY[slot] = y + wLinkSpriteDY
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .height

;>     dz = LiftOffsetsZ[i]
	push hl
	ld hl, LiftOffsetsZ - 1
	add hl, de
	ld e, [hl]
	pop hl
;>     wEntityY[slot] -= dz
	ld a, [hl]
	sub e
	ld [hl], a
;>     return
	ret


.height
;> dz = LiftOffsetsZ[i]
	ld hl, LiftOffsetsZ - 1
	add hl, de
	ld a, [hl]
;> wEntityZ[slot] = hLinkPositionZ + dz
	ld hl, hLinkPositionZ
	add [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
	ret


;@ def Call_03_5840()
;@ path: object/liftable
;@ Runs UpdateCarriedEntity (code in bank $14 for the carried entity).
Call_03_5840::
;> UpdateCarriedEntity()
	call UpdateCarriedEntity
	ret


;@ def OctorokHandler(slot: c)
;@ path: enemy/octorok
;@ Handler of type $09, the Octorok: the shared walking enemy code with the Octorok's sprites. Outside
;@ game mode 1 it first sets $FFF5 to $30.
OctorokHandler::
;> sprites = OctorokSprites
	ld de, OctorokSprites
;> if wGameplayType != 1: mem[0xFFF5] = 0x30
	ld a, [wGameplayType]
	cp $01
	jr z, .walk

	ld a, $30
	ldh [hActiveEntityTileOffset], a

.walk
;> WalkingEnemyHandler(slot, sprites)
	call WalkingEnemyHandler
	ret


;@ path: enemy/octorok
;@ Octorok sprites: 8 variants of two 8x16 sprites (tile, attribute): 0-1 facing down (tiles $30/$32,
;@ mirrored), 2-3 facing up (the same flipped vertically), 4-5 facing left (tiles $34-$3A), 6-7 facing
;@ right (mirrored). Two walking frames per direction (WalkerDirectionVariants + frame).
OctorokSprites::
	db $30, $00, $30, $20, $32, $00, $32, $20, $30, $40, $30, $60, $32, $40, $32, $60, $34, $00, $36, $00, $38, $00, $3a, $00, $36, $20, $34, $20, $3a, $20, $38, $20
;@ path: enemy/walker
;@ X speed of a walking enemy (Octorok, Moblin, Iron Mask) by direction: right, left, up, down; signed
;@ 1/16 pixel per frame.
WalkerSpeedsX::
	db $08, $f8, $00, $00

;@ path: enemy/walker
;@ Y speed of a walking enemy by direction (same index).
WalkerSpeedsY::
	db $00, $00, $f8, $08

;@ path: enemy/walker
;@ First sprite variant of a walking enemy by direction: right 6, left 4, up 2, down 0 (the walking
;@ frame, 0 or 1, is added).
WalkerDirectionVariants::
	db $06, $04, $02, $00

;@ def MoblinHandler(slot: c)
;@ path: enemy/moblin
;@ Handler of type $0B, the Moblin. In map $15 (the Moblins' cave) the Moblins are only there while
;@ BowWow is held there (wIsBowWowFollowingLink = $80). Remembers its slot in $D153, then walks like
;@ the other walking enemies with the Moblin's sprites.
MoblinHandler::
;> if hMapId == 0x15:
	ldh a, [hMapId]
	cp $15
	jr nz, .here

;>     if wIsBowWowFollowingLink != 0x80: return Call_3FB7(slot)  # frees the slot
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp nz, Call_3FB7

.here
;> mem[0xD153] = slot
	ld a, c
	ld [$d153], a
;> sprites = MoblinSprites
	ld de, MoblinSprites
;> WalkingEnemyHandler(slot, sprites)

;@ def WalkingEnemyHandler(slot: c, sprites: de)
;@ path: enemy/walker
;@ The walking enemies (Octorok, Moblin, the masked Iron Mask). State 0: walk straight for a while,
;@ stopping at walls. State 1: stand still; at the end pick a new direction (every fourth time towards
;@ Link, otherwise at random). While standing, an Octorok or Moblin that faces Link shoots a rock or an
;@ arrow (timer at $0A). A hit puts it into state 1 for $40 frames.
WalkingEnemyHandler::
;> DrawEntity16x16(sprites)  # draws it (two sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> if wEntityIgnoreHitsTimer[slot]:  # it was just hit
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .noHit

;>     wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld a, $01
	ld [hl], a
;>     hActiveEntityState = 1
	ldh [hActiveEntityState], a
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40

.noHit
;> ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;> Call_03_6E3D(slot)
	call Call_03_6E3D
;> if hActiveEntityState == 0:  # walking
;>@w1     hitWall = wEntityCollisions[slot] & 0x0F
;>@w2     if hitWall or not GetEntityTimer(slot):  # time to stop
;>@w3         # (after a wall hit hl still points at wEntityCollisions, which then gets the new time)
;>@w3         (wEntityCollisions if hitWall else wEntityTimer)[slot] = (GetRandomByte() & 0x0F) | 0x10
;>@w4         wEntityState[slot] = 1
;>@w5         ClearEntitySpeed()  # stops it
;>@w6     UpdateEntityPosWithSpeed_03(slot)
;>@w7     Call_03_7892(slot)  # background collision
;>@w8     return SetWalkingSpriteVariant_03(slot)
	ldh a, [hActiveEntityState]
	and a
	jr z, .walk

;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:  # done standing: a new walk
;>@t1     wEntityTimer[slot] = (GetRandomByte() & 0x1F) | 0x20
;>@t2     wEntityState[slot] = 0
;>@t3     wEntityPrivate1[slot] = (wEntityPrivate1[slot] + 1) & 3
;>@t4     d = GetEntityDirectionToLink_03(slot) if wEntityPrivate1[slot] == 0 else GetRandomByte()
;>@t5     d &= 3
;>@t6     wEntityDirection[slot] = d
;>@t7     wEntitySpeedX[slot] = WalkerSpeedsX[d]
;>@t8     wEntitySpeedY[slot] = WalkerSpeedsY[d]
;>@t9     return
	jr z, .turn

;> if t == 0x0A and GetEntityTimer1(slot) == 0:
	cp $0a
	jr nz, .moveOn

	call GetEntityTimer1
	jr nz, .moveOn

;>     if GetEntityDirectionToLink_03(slot) == wEntityDirection[slot]:  # it faces Link
	call GetEntityDirectionToLink_03
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, .moveOn

;>         if hActiveEntityType != 0x24:  # the Iron Mask does not shoot
	ldh a, [hActiveEntityType]
	cp $24
	jr z, .moveOn

;>             if hActiveEntityType == 0x09:
;>@o1                 if wGameplayType == 1: return
;>@o2                 return OctorokShootRock(slot)
	cp $09
	jr z, .octorok

;>             MoblinShootArrow(slot)
	call MoblinShootArrow

.moveOn
;> Call_03_7892(slot)  # background collision
	call Call_03_7892
;> return
	ret


.octorok
;=@o1
	ld a, [wGameplayType]
	cp $01
	ret z

;=@o2
	call OctorokShootRock
	ret


.turn
;=@t1
	call GetRandomByte
	and $1f
	or $20
	ld [hl], a
;=@t2
	ld hl, wEntityState
	add hl, bc
	ld [hl], $00
;=@t3
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
;=@t4
	cp $00
	jr nz, .random

	call GetEntityDirectionToLink_03
	jr .setDirection

.random
	call GetRandomByte

.setDirection
;=@t5
	and $03
;=@t6
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ld e, a
	ld d, b
;=@t7
	ld hl, WalkerSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;=@t8
	ld hl, WalkerSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;=@t9
	ret


.walk
;=@w1
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, .stop

;=@w2
	call GetEntityTimer
	jr nz, .move

.stop
;=@w3
	call GetRandomByte
	and $0f
	or $10
	ld [hl], a
;=@w4
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;=@w5
	call ClearEntitySpeed

.move
;=@w6
	call UpdateEntityPosWithSpeed_03
;=@w7
	call Call_03_7892
;=@w8

;@ def SetWalkingSpriteVariant_03(slot: c)
;@ path: enemy/walker
;@ Sprite variant of a walking entity: the direction's first variant (WalkerDirectionVariants) plus
;@ the walking frame, which changes every 8 frames of its private counter.
SetWalkingSpriteVariant_03::
;> base = WalkerDirectionVariants[wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, WalkerDirectionVariants
	add hl, de
;> wEntityPrivateCounter[slot] += 1
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> frame = (wEntityPrivateCounter[slot] >> 3) & 1
	ld a, [hl]
	rra
	rra
	rra
	pop hl
	and $01
;> SetEntitySpriteVariant(slot, base | frame)  # sets wEntitySpriteVariant
	or [hl]
	call SetEntitySpriteVariant
	ret


;@ path: enemy/moblin
;@ Moblin sprites, the same layout as OctorokSprites: 0-1 down (tiles $60/$62), 2-3 up ($64/$66),
;@ 4-5 left ($68-$6E), 6-7 right (mirrored).
MoblinSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20, $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
;@ path: enemy/moblin
;@ X offset of a new Moblin arrow from the Moblin, by direction (right, left, up, down).
MoblinArrowOffsetsX::
	db $08, $f8, $04, $fc

;@ path: enemy/moblin
;@ Y offset of a new Moblin arrow, by direction.
MoblinArrowOffsetsY::
	db $fc, $fc, $f8, $00

;@ path: enemy/moblin
;@ X speed of a Moblin arrow by direction ($20 = 2 pixels per frame).
MoblinArrowSpeedsX::
	db $20, $e0, $00, $00

;@ path: enemy/moblin
;@ Y speed of a Moblin arrow by direction.
MoblinArrowSpeedsY::
	db $00, $00, $e0, $20

;@ def MoblinShootArrow(slot: c)
;@ path: enemy/moblin
;@ Spawns a Moblin arrow (type $0C) in front of the Moblin, flying in the Moblin's direction
;@ (hMultiPurpose2 holds that direction after SpawnEntity_03); sprite variant and direction = that
;@ direction.
MoblinShootArrow::
;> arrow = SpawnEntity_03(0x0C)
	ld a, $0c
	call SpawnEntity_03
;> if arrow is None: return
	jr c, .done

;> d = hMultiPurpose2
	push bc
	ldh a, [hMultiPurpose2]
	ld c, a
;> x = hMultiPurpose0 + MoblinArrowOffsetsX[d]
	ld hl, MoblinArrowOffsetsX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;> wEntityX[arrow] = x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> y = hMultiPurpose1 + MoblinArrowOffsetsY[d]
	ld hl, MoblinArrowOffsetsY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;> wEntityY[arrow] = y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpeedX[arrow] = MoblinArrowSpeedsX[d]
	ld hl, MoblinArrowSpeedsX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[arrow] = MoblinArrowSpeedsY[d]
	ld hl, MoblinArrowSpeedsY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;> wEntitySpriteVariant[arrow] = d
	ldh a, [hMultiPurpose2]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;> wEntityDirection[arrow] = d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	pop bc

.done
	ret


;@ path: enemy/octorok
;@ X offset of a new Octorok rock by direction (right, left; up and down read on into
;@ OctorokRockOffsetsY, both 0).
OctorokRockOffsetsX::
	db $08, $f8

;@ path: enemy/octorok
;@ Y offset of a new Octorok rock by direction (right, left, up, down).
OctorokRockOffsetsY::
	db $00, $00, $f8, $08

;@ path: enemy/octorok
;@ X speed of an Octorok rock by direction (right, left; up and down read on into the next table: 0).
OctorokRockSpeedsX::
	db $20, $e0

;@ path: enemy/octorok
;@ Y speed of an Octorok rock by direction (right, left, up, down).
OctorokRockSpeedsY::
	db $00, $00, $e0, $20

;@ def OctorokShootRock(slot: c) -> carry
;@ path: enemy/octorok
;@ Spawns an Octorok rock (type $0A) in front of the Octorok, flying in its direction. Carry: no
;@ free slot.
OctorokShootRock::
;> rock = SpawnEntity_03(0x0A)
	ld a, $0a
	call SpawnEntity_03
;> if rock is None: return True
	jr c, .done

;> d = hMultiPurpose2
	push bc
	ldh a, [hMultiPurpose2]
;> wEntityDirection[rock] = d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	ld c, a
;> x = hMultiPurpose0 + OctorokRockOffsetsX[d]
	ld hl, OctorokRockOffsetsX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;> wEntityX[rock] = x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> y = hMultiPurpose1 + OctorokRockOffsetsY[d]
	ld hl, OctorokRockOffsetsY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;> wEntityY[rock] = y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpeedX[rock] = OctorokRockSpeedsX[d]
	ld hl, OctorokRockSpeedsX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[rock] = OctorokRockSpeedsY[d]
	ld hl, OctorokRockSpeedsY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;> return False
	pop bc
	and a

.done
	ret


;@ def EntityInit_Type13()
;@ path: entity/init
;@ Init of type $13: nothing. (Its handler pointer points at HeartContainerSprite, data, so the type
;@ is not used.)
EntityInit_Type13::
;> return
	ret


;@ path: item/heart-container
;@ Sprite of the heart container (type $36): tile $AA twice, the right one x-flipped, palette 1.
;@ (tile, attribute) pairs.
HeartContainerSprite::
	db $aa, $10, $aa, $30

;@ def HeartContainerHandler(slot: c)
;@ path: item/heart-container
;@ Handler of type $36, a heart container. It waits for Link (CollectPickupIfTouched starts
;@ wEntityTimer); while the timer runs Link holds it up; on its last frame Link gets one more heart
;@ and full health, the room remembers it (status bit 5) and music $18 plays.
HeartContainerHandler::
;> DrawEntity16x16(HeartContainerSprite)  # draws it
	ld de, HeartContainerSprite
	call DrawEntity16x16
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return CollectPickupIfTouched(slot)
	jp z, CollectPickupIfTouched

;> if t != 1: return HoldItemAboveLink(slot)
	dec a
	jr nz, HoldItemAboveLink

;> wMusicTrackToPlay = 0x18
	ld a, $18
	ld [wMusicTrackToPlay], a
;> wMaxHearts += 1
	ld hl, wMaxHearts
	inc [hl]
;> wAddHealthBuffer = 0xFF  # refills all health
	ld hl, wAddHealthBuffer
	ld [hl], $ff
;> p = GetRoomStatusAddress_03()
	call GetRoomStatusAddress_03
;> mem[p] |= 0x20  # taken
	ld a, [hl]
	or $20
	ld [hl], a
;> hRoomStatus = mem[p]
	ldh [hRoomStatus], a
;> return Call_3FB7(slot)  # frees the slot
	jp Call_3FB7


;@ def HoldItemAboveLink(slot: c)
;@ path: item/pickup
;@ Keeps a collected item 12 pixels above Link's head while he holds it up: Link faces down in pose
;@ $6C, his sword action is cancelled and he cannot move.
HoldItemAboveLink::
;> wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = hLinkY - 0x0C
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub $0c
	ld [hl], a
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> hLinkAnimationState = 0x6C  # holding something up
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
;> wSwordAnimationState = 0
	xor a
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> wSwordCharge = 0
	ld [wSwordCharge], a
;> wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
;> wEntityGroundStatus[slot] = 0
	ld hl, wEntityGroundStatus
	add hl, bc
	ld [hl], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


;@ path: item/heart-piece
;@ Sprite of a piece of heart (type $35): tile $AC twice, the right one x-flipped. (tile, attribute).
HeartPieceSprite::
	db $ac, $00, $ac, $20

;@ def HeartPieceHandler(slot: c)
;@ path: item/heart-piece
;@ Handler of type $35, a piece of heart; gone once the room's status bit 4 is set. A state machine
;@ (HeartPieceStates): wait for Link, hold it up, load the counter tiles, show the message with the
;@ heart counter filling up, and with the fourth piece add a heart container.
HeartPieceHandler::
;> if hRoomStatus & 0x10: return Call_3FB7(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7

;> return HeartPieceStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: item/heart-piece
;@ States of the piece of heart (wEntityState 0-8).
HeartPieceStates::
	dw HeartPiece_Wait
	dw HeartPiece_Hold
	dw HeartPiece_LoadTiles1
	dw HeartPiece_LoadTiles2
	dw HeartPiece_OpenDialog
	dw HeartPiece_Count
	dw HeartPiece_CheckFull
	dw HeartPiece_WaitDialog
	dw HeartPiece_Done

;@ def HeartPiece_Hold(slot: c)
;@ path: item/heart-piece
;@ State 1: Link holds the piece up until wEntityTimer runs out.
HeartPiece_Hold::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> if GetEntityTimer(slot) == 0: wEntityState[slot] += 1
	call GetEntityTimer
	jr nz, .done

	call IncrementEntityState

.done
	ret


;@ def HeartPiece_LoadTiles1(slot: c)
;@ path: item/heart-piece
;@ State 2: background tile copy request 3 (part of the counter graphics).
HeartPiece_LoadTiles1::
;> hNeedsUpdatingBGTiles = 3
	ld a, $03
	ldh [hNeedsUpdatingBGTiles], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def HeartPiece_LoadTiles2(slot: c)
;@ path: item/heart-piece
;@ State 3: background tile copy request 4.
HeartPiece_LoadTiles2::
;> hNeedsUpdatingBGTiles = 4
	ld a, $04
	ldh [hNeedsUpdatingBGTiles], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def HeartPiece_OpenDialog(slot: c)
;@ path: item/heart-piece
;@ State 4: opens message $4F and keeps the box open.
HeartPiece_OpenDialog::
;> OpenDialog(0x4F)
	ld a, $4f
	call OpenDialog
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wDialogKeepOpen = 1
	ld a, $01
	ld [wDialogKeepOpen], a
	ret


;@ def HeartPiece_Count(slot: c)
;@ path: item/heart-piece
;@ State 5: Link holds the piece while the counter is shown; after $38 frames the new piece is added
;@ to wHeartPieces, after $A8 frames the next state.
HeartPiece_Count::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> DrawEntity16x16(HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> DrawHeartPieceCounter()
	call DrawHeartPieceCounter
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] == 0xA8: return IncrementEntityState()  # next state
	ld a, [hl]
	cp $a8
	jp z, IncrementEntityState

;> if wEntityPrivateCounter[slot] == 0x38: wHeartPieces += 1
	cp $38
	jr nz, .done

	ld a, [wHeartPieces]
	inc a
	ld [wHeartPieces], a

.done
	ret


;@ def HeartPiece_CheckFull(slot: c)
;@ path: item/heart-piece
;@ State 6: lets the message close; with 4 pieces they become a heart container (jingle $19, health
;@ refill of $40, message $50).
HeartPiece_CheckFull::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> DrawEntity16x16(HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> wDialogKeepOpen = 0
	xor a
	ld [wDialogKeepOpen], a
;> DrawHeartPieceCounter()
	call DrawHeartPieceCounter
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	jr nz, .done

;> if wHeartPieces == 4:
	ld a, [wHeartPieces]
	cp $04
	jr nz, .next

;>     hJingle = 0x19
	ld a, $19
	ldh [hJingle], a
;>     wHeartPieces = 0
	xor a
	ld [wHeartPieces], a
;>     wAddHealthBuffer = 0x40
	ld hl, wAddHealthBuffer
	ld [hl], $40
;>     wMaxHearts += 1
	ld hl, wMaxHearts
	inc [hl]
;>     OpenDialog(0x50)
	ld a, $50
	call OpenDialog

.next
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def HeartPiece_WaitDialog(slot: c)
;@ path: item/heart-piece
;@ State 7: holds the piece until the message is closed, then background tile request 5.
HeartPiece_WaitDialog::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> DrawEntity16x16(HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	jr nz, .done

;> hNeedsUpdatingBGTiles = 5
	ld a, $05
	ldh [hNeedsUpdatingBGTiles], a
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def HeartPiece_Done(slot: c)
;@ path: item/heart-piece
;@ State 8: background tile request 6 (restores the tiles), frees the slot, background change $0D,
;@ and marks the room's piece as taken.
HeartPiece_Done::
;> hNeedsUpdatingBGTiles = 6
	ld a, $06
	ldh [hNeedsUpdatingBGTiles], a
;> Call_3FB7(slot)  # frees the slot
	call Call_3FB7
;> hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;> return MarkRoomChestOpened()
	jp MarkRoomChestOpened


;@ path: item/heart-piece
;@ The heart counter shown next to the message: 5 variants (0-4 pieces) of two 8x16 sprites (tile,
;@ attribute): tiles $9A empty quarter pair, $9C one piece, $9E two pieces; the right half x-flipped.
HeartPieceCounterSprites::
	db $9a, $00, $9a, $20, $9c, $00, $9a, $20, $9e, $00, $9a, $20, $9e, $00, $9c, $20, $9e, $00, $9e, $20

;@ def DrawHeartPieceCounter()
;@ path: item/heart-piece
;@ While a message is open, draws the heart counter for wHeartPieces at x $8B, at y $23 when the box
;@ is at the bottom and $6B when it is at the top (wDialogState bit 7).
DrawHeartPieceCounter::
;> if not wDialogState: return
	ld a, [wDialogState]
	and a
	jr z, .done

;> hActiveEntityDrawY = 0x6B if wDialogState & 0x80 else 0x23
	and $80
	ld a, $23
	jr z, .setY

	ld a, $6b

.setY
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = wHeartPieces
	ld a, [wHeartPieces]
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityX = 0x8B
	ld a, $8b
	ldh [hActiveEntityX], a
;> DrawEntity16x16(HeartPieceCounterSprites)
	ld de, HeartPieceCounterSprites
	call DrawEntity16x16

.done
	ret


;@ def HeartPiece_Wait(slot: c)
;@ path: item/heart-piece
;@ State 0: the piece lies there until Link touches it.
HeartPiece_Wait::
;> DrawEntity16x16(HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/pickup
;@ Sprite of the Guardian Acorn (type $34): one 8x16 sprite, tile $AE, palette 1 (tile, attribute).
GuardianAcornSprite::
	db $ae, $10

;@ def GuardianAcornHandler(slot: c)
;@ path: item/pickup
;@ Handler of type $34, the Guardian Acorn: drawn and collected when touched.
GuardianAcornHandler::
;> DrawEntity8x16(GuardianAcornSprite)
	ld de, GuardianAcornSprite
	call DrawEntity8x16
;> return PickupUpdateTail(slot)
	jr PickupUpdateTail

;@ path: item/pickup
;@ Sprites of the Piece of Power (type $33): 2 variants of two sprites of tile $14 (right one
;@ x-flipped), palette 0 and palette 1: it flickers between them every 8 frames.
PieceOfPowerSprites::
	db $14, $00, $14, $20, $14, $10, $14, $30

;@ def PieceOfPowerHandler(slot: c)
;@ path: item/pickup
;@ Handler of type $33, the Piece of Power: flickering, collected when touched.
PieceOfPowerHandler::
;> DrawEntity16x16(PieceOfPowerSprites)
	ld de, PieceOfPowerSprites
	call DrawEntity16x16
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)  # sets wEntitySpriteVariant
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant

PickupUpdateTail:
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/pickup
;@ Sprites of type $32: two 8x16 sprites (tile, attribute), tiles $74/$76 and mirrored.
Type32Sprites::
	db $74, $00, $76, $00, $76, $20, $74, $20

;@ def Type32Handler(slot: c)
;@ path: item/pickup
;@ Handler of type $32: drawn, then the shared pickup movement FollowCarryingWeapon.
Type32Handler::
;> DrawEntity16x16(Type32Sprites)
	ld de, Type32Sprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> FollowCarryingWeapon(slot)
	call FollowCarryingWeapon
	ret


;@ path: item/sword
;@ One 8x16 sprite (tile, attribute): tile $86, palette 1 (the sword once Link owns one).
SwordIconSprite::
	db $86, $10

;@ path: item/sword
;@ One 8x16 sprite: tile $84, palette 1 (the sword lying on the beach).
BeachSwordSprite::
	db $84, $10

;@ def SwordHandler(slot: c)
;@ path: item/sword
;@ Handler of type $31, the sword on the beach (gone once taken, room status bit 4). States
;@ (SwordStates): wait and hold it up with message $9B and its music $31, a pause, show it, then
;@ Link gets the sword (inventory item 1, wSwordLevel 1).
SwordHandler::
;> sprite = SwordIconSprite
	ld de, SwordIconSprite
;> if not wSwordLevel:
	ld a, [wSwordLevel]
	and a
	jr nz, .draw

;>     if hRoomStatus & 0x10: return Call_3FB7(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7

;>     sprite = BeachSwordSprite
	ld de, BeachSwordSprite

.draw
;> DrawEntity8x16(sprite)
	call DrawEntity8x16
;> return SwordStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: item/sword
;@ States of the beach sword (wEntityState 0-3).
SwordStates::
	dw Sword_Hold
	dw Sword_WaitDrop
	dw Sword_Show
	dw Sword_Give

;@ def Sword_Hold(slot: c)
;@ path: item/sword
;@ State 0: waits for Link; while Link holds it up message $9B opens ($10 frames left); on the last
;@ frame the sword music ($31) starts, the room music becomes 5 and the next state waits $52 frames.
Sword_Hold::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return CollectPickupIfTouched(slot)
	jp z, CollectPickupIfTouched

;> if t == 0x10:
	cp $10
	jr nz, .last

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     OpenDialog(0x9B)
	ld a, $9b
	call OpenDialog
;>     t = 0
	xor a

.last
;> if t == 1:
	dec a
	jr nz, .hold

;>     wMusicTrackToPlay = 0x31
	ld a, $31
	ld [wMusicTrackToPlay], a
;>     hDefaultMusicTrack = 5
	ld a, $05
	ldh [hDefaultMusicTrack], a
;>     hLastMusicTrack = 5
	ldh [hLastMusicTrack], a
;>     wEntityDropTimer[slot] = 0x52
	call GetEntityDropTimer
	ld [hl], $52
;>     wEntityState[slot] += 1
	call IncrementEntityState

.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ def Sword_WaitDrop(slot: c)
;@ path: item/sword
;@ State 1: Link holds the sword during the music; then it vanishes ($FF variant) for $20 frames while
;@ Link does a spin attack (noise 3).
Sword_WaitDrop::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> if GetEntityDropTimer(slot): return
	call GetEntityDropTimer
	jr nz, .done

;> SetEntitySpriteVariant(slot, 0xFF)  # not drawn
	ld a, $ff
	call SetEntitySpriteVariant
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wSpinAttackTimer = 0x20
	ld a, $20
	ld [wSpinAttackTimer], a
;> hNoiseSfx = 3
	ld a, $03
	ldh [hNoiseSfx], a
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def Sword_Show(slot: c)
;@ path: item/sword
;@ State 2: after the spin, the sword shows again (variant 0) for $20 frames.
Sword_Show::
;> if GetEntityTimer(slot): return
	call GetEntityTimer
	jr nz, .done

;> wEntityTimer[slot] = 0x20
	ld [hl], $20
;> SetEntitySpriteVariant(slot, 0)
	ld a, $00
	call SetEntitySpriteVariant
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def Sword_Give(slot: c)
;@ path: item/sword
;@ State 3: Link holds the sword up in pose $6B (sword 4 pixels to the left); halfway a sparkle
;@ appears (Call_03_6C51) with jingle 7; at the end Link owns the sword.
Sword_Give::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> hLinkAnimationState = 0x6B
	ld a, $6b
	ldh [hLinkAnimationState], a
;> wEntityX[slot] = hLinkX - 4
	ld hl, wEntityX
	add hl, bc
	ldh a, [hLinkX]
	sub $04
	ld [hl], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .sparkle

;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     GiveInventoryItem(1)  # puts the sword (item 1) in the inventory
	ld d, $01
	call GiveInventoryItem
;>     wSwordLevel = 1
	ld a, $01
	ld [wSwordLevel], a
;>     MarkRoomChestOpened()
	call MarkRoomChestOpened
;>     return Call_3FB7(slot)  # frees the slot
	jp Call_3FB7


.sparkle
;> if t == 0x1A:
	cp $1a
	jr nz, .done

;>     Call_03_6C51(slot, hActiveEntityY - 0x0C)
	ldh a, [hActiveEntityY]
	sub $0c
	call Call_03_6C51
;>     hJingle = 7
	ld a, $07
	ldh [hJingle], a

.done
	ret


;@ path: item/pickup
;@ One 8x16 sprite (tile, attribute): tile $8A, palette 1 (the item of type $30 in room $80).
ItemSprite8A::
	db $8a, $10

;@ def KeyDropPoint_Room80(slot: c)
;@ path: item/pickup
;@ Type $30 in room $80: an item (gone once taken). Collected like the other pickups; while held up
;@ message $93 opens; at the end Link gets inventory item 6 (the hookshot).
KeyDropPoint_Room80::
;> if hRoomStatus & 0x10: return Call_3FB7(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7

;> DrawEntity8x16(ItemSprite8A)
	ld de, ItemSprite8A
	call DrawEntity8x16
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return CollectPickupIfTouched(slot)
	jp z, CollectPickupIfTouched

;> if t == 0x10:
	cp $10
	jr nz, .last

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     OpenDialog(0x93)
	ld a, $93
	call OpenDialog
;>     t = 0
	xor a

.last
;> if t != 1: return HoldItemAboveLink(slot)
	dec a
	jr nz, .hold

;> GiveInventoryItem(6)  # puts item 6 in the inventory
	ld d, $06
	call GiveInventoryItem
;> MarkRoomChestOpened()
	call MarkRoomChestOpened
;> return Call_3FB7(slot)
	jp Call_3FB7


.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ path: item/keys
;@ Sprites of the keys of type $30 by sprite variant (one 8x16 sprite, tile and attribute, palette 1):
;@ 0 $CA, 1 $C0 (Tail Key), 2 $C2, 3 $C4, 4 $C6, 5 $CA.
KeySprites::
	db $ca, $10, $c0, $10, $c2, $10, $c4, $10, $c6, $10, $ca, $10

;@ path: item/keys
;@ Message shown for key variant 1-5 (entry variant - 1): $00, $A3, $A4, $A5, $00.
KeyDialogs::
	db $00, $a3, $a4, $a5, $00

;@ def KeyDropPointHandler(slot: c)
;@ path: item/keys
;@ Handler of type $30, a key (variant 1-5) that appears on the ground. In overworld room $CE it can
;@ fall into the hole there (which marks rooms $CE and $1F8). In room $80 it is another item. Link
;@ picks it up like other pickups; while he holds it up the variant's message opens and the variant's
;@ key flag ($DB11 + variant - 1) is set.
KeyDropPointHandler::
;> if CheckKeyFallsInPit(slot):
	call CheckKeyFallsInPit
	jr nc, .notInPit

;>     wRoomStatus[0xCE] |= 0x10
	ld hl, wRoomStatus + $ce
	set 4, [hl]
;>     wRoomStatus[0x1F8] |= 0x20
	ld hl, wRoomStatus + $1f8
	set 5, [hl]
;>     return
	ret


.notInPit
;> if hMapRoom == 0x80: return KeyDropPoint_Room80(slot)
	ldh a, [hMapRoom]
	cp $80
	jp z, KeyDropPoint_Room80

;> DrawEntity8x16(KeySprites)
	ld de, KeySprites
	call DrawEntity8x16
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return KeyDropPoint_Lying(slot)
	jp z, KeyDropPoint_Lying

;> if t == 0x10:
	cp $10
	jr nz, .last

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     i = hActiveEntitySpriteVariant - 1
	ldh a, [hActiveEntitySpriteVariant]
	dec a
	ld e, a
	ld d, b
;>     OpenDialog(KeyDialogs[i])
	ld hl, KeyDialogs
	add hl, de
	ld a, [hl]
	call OpenDialog
;>     i = hActiveEntitySpriteVariant - 1
	ldh a, [hActiveEntitySpriteVariant]
	dec a
	ld e, a
	ld d, b
;>     wKeyItemFlags[i] = 1  # variant 5 sets the byte after the array
	ld hl, wKeyItemFlags
	add hl, de
	ld [hl], $01
;>     MarkRoomChestOpened()
	call MarkRoomChestOpened
;>     t = 0
	xor a

.last
;> if t == 1: return Call_3FB7(slot)  # frees the slot
	dec a
	jr nz, .hold

	jp Call_3FB7


.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ def KeyDropPoint_Lying(slot: c)
;@ path: item/keys
;@ The key lies on the ground (or drops to it): pickup movement, the landing (CheckPickupCollected), and the
;@ touch test.
KeyDropPoint_Lying::
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> FollowCarryingWeapon(slot)
	call FollowCarryingWeapon
;> if wEntityZ[slot] == 0: CheckPickupCollected(slot)
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .touch

	call CheckPickupCollected

.touch
;> return UpdatePickupPhysics(slot)
	jp UpdatePickupPhysics


;@ def CheckKeyFallsInPit(slot: c) -> carry
;@ path: item/keys
;@ In overworld room $CE, a key lying (height 0, status 5) within 3 pixels of (x $50, y $48) falls into
;@ the hole there: status 2 towards that point for $2F frames, jingle $18. Carry: it falls.
CheckKeyFallsInPit::
;> if wIsIndoor: return False
	ld a, [wIsIndoor]
	and a
	jr nz, .no

;> if hMapRoom != 0xCE: return False
	ldh a, [hMapRoom]
	cp $ce
	jr nz, .no

;> if (hActiveEntityY - 0x48 + 3) & 0xFF >= 6: return False
	ldh a, [hActiveEntityY]
	sub $48
	add $03
	cp $06
	jr nc, .no

;> if (hActiveEntityX - 0x50 + 3) & 0xFF >= 6: return False
	ldh a, [hActiveEntityX]
	sub $50
	add $03
	cp $06
	jr nc, .no

;> if wEntityZ[slot]: return False
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .no

;> if wEntityStatus[slot] != 5: return False
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $05
	jr nz, .no

;> wEntityStatus[slot] = 2  # falls into the pit
	ld [hl], $02
;> wEntityPitX[slot] = 0x50
	ld hl, wEntityPitX
	add hl, bc
	ld [hl], $50
;> wEntityPitY[slot] = 0x48
	ld hl, wEntityPitY
	add hl, bc
	ld [hl], $48
;> wEntityTimer[slot] = 0x2F
	call GetEntityTimer
	ld [hl], $2f
;> hJingle = 0x18
	ld a, $18
	ldh [hJingle], a
;> return True
	scf
	ret


.no
;> return False
	and a
	ret


;@ path: item/pickup
;@ Sprite of a dropped heart (type $2D): one 8x16 sprite, tile $A8, palette 1.
DroppedHeartSprite::
	db $a8, $10

;@ def DroppedHeartHandler(slot: c)
;@ path: item/pickup
;@ Handler of type $2D, a heart dropped by an enemy: it bounces and blinks (CheckHiddenPickup,
;@ UpdatePickupLifetime), and is collected when touched.
DroppedHeartHandler::
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity8x16(DroppedHeartSprite)
	ld de, DroppedHeartSprite
	call DrawEntity8x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/toadstool
;@ Sprite of the Sleepy Toadstool (type $3A): tile $5E twice, the right one x-flipped.
ToadstoolSprites::
	db $5e, $00, $5e, $20

;@ def ToadstoolHandler(slot: c)
;@ path: item/toadstool
;@ Handler of type $3A, the Sleepy Toadstool in the Mysterious Woods: not there while Link has it or
;@ has magic powder. Collected like a pickup; message $0F while held up; then Link has it (inventory
;@ item $0C) and the background change $0A runs.
ToadstoolHandler::
;> if wMagicPowderCount | wHasToadstool: return Call_3FB7(slot)  # frees the slot
	ld hl, wHasToadstool
	ld a, [wMagicPowderCount]
	or [hl]
	jp nz, Call_3FB7

;> DrawEntity16x16(ToadstoolSprites)
	ld de, ToadstoolSprites
	call DrawEntity16x16
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return CollectPickupIfTouched(slot)
	jp z, CollectPickupIfTouched

;> if t == 0x10:
	cp $10
	jr nz, .last

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     OpenDialog(0x0F)
	ld a, $0f
	call OpenDialog
;>     t = 0
	xor a

.last
;> if t != 1: return HoldItemAboveLink(slot)
	dec a
	jr nz, .hold

;> hBGChangeRequest = 0x0A
	ld a, $0a
	ldh [hBGChangeRequest], a
;> GiveInventoryItem(0x0C)  # inventory item $0C
	ld d, $0c
	call GiveInventoryItem
;> wHasToadstool = 1
	ld a, $01
	ld [wHasToadstool], a
;> return Call_3FB7(slot)
	jp Call_3FB7


.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ path: item/instrument
;@ Sprites of the eight Instruments of the Sirens (type $39), by sprite variant 0-7: one 8x16 sprite
;@ each (tile, attribute): tiles $70, $72, ... $7E.
InstrumentSprites_03::
	db $70, $00, $72, $00, $74, $00, $76, $00, $78, $00, $7a, $00, $7c, $00, $7e, $00

InstrumentHandler::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

InstrumentModes::
	dw InstrumentItemHandler
	dw MusicNoteHandler
	dw InstrumentWarpOut

InstrumentFadeBGPalettes::
	db $e4, $e4, $e4, $e4, $90, $90, $90, $90, $40, $40, $40, $40, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

InstrumentFadeOBJPalettes::
	db $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $08, $08, $08
	db $08, $04, $04, $04, $04, $00, $00, $00, $00, $00

InstrumentWarpOut::
	call Call_3EA0
	ld a, $01
	ld [wLinkFrozen], a
	call GetEntityDropTimer
	jr nz, InstrumentFlashPalettes

	call Call_3FB7
	xor a
	ldh [hLinkAnimationState], a
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	inc [hl]
	call StartScreenFadeOut
	ldh a, [hMapId]
	rst $00

InstrumentDoneEffects::
	dw InstrumentDone_Map0
	dw InstrumentDone_Map1
	dw InstrumentDone_Map2
	dw InstrumentDone_Map3
	dw InstrumentDone_Map4
	dw InstrumentDone_Map5
	dw InstrumentDone_Map6
	dw InstrumentDone_Map4

InstrumentDone_Map0::
	ld a, $80
	ld [wIsBowWowFollowingLink], a
	ret


InstrumentDone_Map1::
	ld a, $02
	ld [wTarinState], a
	ret


InstrumentDone_Map2::
	ret


InstrumentDone_Map3::
	ld a, $02
	ld [wIsGhostFollowingLink], a

InstrumentDone_Map4::
	ret


InstrumentDone_Map5::
	xor a
	ld [wIsMarinInAnimalVillage], a
	ret


InstrumentDone_Map6::
	xor a
	ld [wIsRoosterFollowingLink], a
	ret


InstrumentFlashPalettes::
	cp $50
	jr nc, jr_003_5ec1

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $19
	jr nc, jr_003_5ec1

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_003_5ea2

	ld a, [hl]
	and a
	jr nz, jr_003_5e8c

	ld a, $2c
	ldh [hNoiseSfx], a
	xor a

jr_003_5e8c:
	inc [hl]
	cp $18
	jr nz, jr_003_5ea2

	ld a, $9f
	call SpawnEntity_03
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60

jr_003_5ea2:
	ldh a, [hFrameCounter]
	and $03
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld e, a
	ld d, b
	ld hl, $5de6
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld hl, $5e03
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	xor a
	ld [wOBJ1Palette], a

jr_003_5ec1:
	ret


MusicNoteSprites::
	db $6c, $00, $ff, $ff, $6c, $00, $6e, $00

MusicNoteHandler::
	ld de, $5ec2
	call DrawEntity16x16
	call UpdateEntityPosWithSpeed_03
	call GetEntityTimer
	jp z, Call_3FB7

	ret


InstrumentItemHandler::
	ld a, c
	ld [wSmasherBallSlot], a
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7

	ldh a, [hMapId]
	and $03
	ldh [hActiveEntitySpriteVariant], a
	call ConfineLinkToArena
	ld de, $5dca
	call DrawEntity16x16
	ldh a, [hActiveEntityState]
	rst $00

InstrumentStates::
	dw Instrument_Collect
	dw Instrument_StartMusic
	dw Instrument_PlayNotes
	dw Instrument_Hold
	dw Instrument_Done

Instrument_Collect::
	call GetEntityTimer
	jp z, CollectPickupIfTouched

	cp $10
	jr nz, jr_003_5f2a

	dec [hl]
	call IncrementEntityState
	ldh a, [hMapId]
	add $00
	call OpenDialogTable1
	ldh a, [hMapId]
	ld e, a
	ld d, b
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	or $02
	ld [hl], a
	call GetRoomStatusAddress_03
	ld a, [hl]
	or $10
	ld [hl], a
	xor a

jr_003_5f2a:
	dec a
	jr nz, jr_003_5f2d

jr_003_5f2d:
	jp HoldItemAboveLink


InstrumentMusicTracks::
	db $20, $28, $29, $2a, $2b, $2c, $2d, $2e

Instrument_StartMusic::
	ld a, [wActiveMusicTrack]
	and a
	jr nz, jr_003_5f58

	ld a, [wDialogState]
	and a
	jr nz, jr_003_5f58

	ldh a, [hMapId]
	ld e, a
	ld d, b
	ld hl, $5f30
	add hl, de
	ld a, [hl]
	ld [wMusicTrackToPlay], a
	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $ff

jr_003_5f58:
	jp HoldItemAboveLink


InstrumentNoteOffsetX::
	db $0a, $fa

InstrumentNoteSpeedX::
	db $04, $fc

Instrument_PlayNotes::
	call GetEntityTimer
	jr nz, jr_003_5f8b

	ld a, $2b
	ldh [hJingle], a
	ld a, $39
	call SpawnEntity_03
	ldh a, [hMultiPurpose0]
	dec a
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
	jp IncrementEntityState


jr_003_5f8b:
	ld hl, wEntityPrivate3
	add hl, bc
	dec [hl]
	ld a, [hl]
	cp $ff
	jr nz, jr_003_5fe5

	ld [hl], $17
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $01
	ldh [hBGTilesRequestCopy], a
	ld a, $39
	call SpawnEntity_03
	push bc
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, $5f5b
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $5f5d
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $f8
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fd
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $38
	call GetRandomByte
	and $01
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
	pop bc

jr_003_5fe5:
	jp HoldItemAboveLink


Instrument_Hold::
	jp HoldItemAboveLink


Instrument_Done::
	ret


DroppedBombsSprite::
	db $80, $10

DroppedBombsHandler::
	call CheckHiddenPickup
	call UpdatePickupLifetime
	ld de, $5fec
	call DrawEntity8x16
	jp CollectPickupIfTouched


SeashellSprite::
	db $9e, $10

SecretSeashellHandler::
	ld a, [wSwordLevel]
	cp $02
	jp nc, Call_3FB7

	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7

	ldh a, [hMapRoom]
	cp $e3
	jr nz, jr_003_601b

	ldh a, [hRoomStatus]
	and $40
	jp z, Call_3FB7

jr_003_601b:
	call CheckHiddenPickup
	ld de, $5ffd
	call DrawEntity8x16
	jp CollectPickupIfTouched


GoldenLeafSprite::
	db $ca, $10

GoldenLeafHandler::
	ldh a, [hRoomStatus]
	and $10
	jp nz, Call_3FB7

	call CheckHiddenPickup
	ld de, $6027
	call DrawEntity8x16
	call GetEntityTimer
	jp z, CollectPickupIfTouched

	cp $10
	jr nz, jr_003_6078

	dec [hl]
	ld a, [wIsIndoor]
	and a
	jr nz, jr_003_6055

	ldh a, [hMapRoom]
	cp $c6
	jr nz, jr_003_6055

	ld a, $05
	ld [wGoldenLeaves], a

jr_003_6055:
	ld hl, wGoldenLeaves
	call IncrementBCD99
	call MarkRoomChestOpened
	ld hl, hRoomStatus
	res 4, [hl]
	ld e, $a2
	ld a, [wGoldenLeaves]
	cp $06
	jr z, jr_003_6073

	ld e, $e8
	cp $05
	jr nz, jr_003_6073

	inc e

jr_003_6073:
	ld a, e
	call OpenDialog
	xor a

jr_003_6078:
	dec a
	jr nz, jr_003_607e

	jp Call_3FB7


jr_003_607e:
	jp HoldItemAboveLink


MagicPowderSprite::
	db $8e, $10

MagicPowderHandler::
	ld a, [wHasToadstool]
	and a
	jp nz, Call_3FB7

	call CheckHiddenPickup
	call UpdatePickupLifetime
	ld de, $6081
	call DrawEntity8x16
	jp CollectPickupIfTouched


DroppedArrowsSprites::
	db $2a, $40, $2a, $60

DroppedArrowsHandler::
	call CheckHiddenPickup
	call UpdatePickupLifetime
	ld de, $6099
	call DrawEntity16x16
	jp CollectPickupIfTouched


UpdatePickupLifetime::
	call GetEntityDropTimer
	cp $1c
	jr nc, jr_003_60bd

	and a
	jp z, Call_3FB7

	and $01
	dec a
	call SetEntitySpriteVariant

jr_003_60bd:
	ret


RupeeSprite::
	db $a6, $10

RupeeHandler::
	call CheckHiddenPickup
	call UpdatePickupLifetime
	ld de, $60be
	call DrawEntity8x16

CollectPickupIfTouched:
	call ReturnIfNonInteractive_03
	call FollowCarryingWeapon
	call CheckPickupCollected

UpdatePickupPhysics::
	call UpdateEntityPosWithSpeed_03
	call Call_03_6B96
	call Call_03_7892
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_003_6105

	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $08
	jp z, Jump_003_6178

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	and $f0
	add $05
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	sra a
	cp $f8
	jr c, jr_003_6134

	jr jr_003_6125

jr_003_6105:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_003_6178

	xor a
	ld [hl], a
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	cp $02
	jr z, jr_003_6125

	ld a, [hl]
	sra a
	cpl
	cp $07
	jr nc, jr_003_6134

jr_003_6125:
	xor a
	push hl
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop hl
	jr jr_003_6158

jr_003_6134:
	push af
	push hl
	ldh a, [hActiveEntityType]
	cp $30
	jr nz, jr_003_6142

	ld a, $17
	ldh [hNoiseSfx], a
	jr jr_003_6156

jr_003_6142:
	cp $02
	jr nz, jr_003_6156

	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_6156

	cp $02
	jr z, jr_003_6156

	ld a, $09
	ldh [hJingle], a

jr_003_6156:
	pop hl
	pop af

jr_003_6158:
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	sra a
	cp $ff
	jr nz, jr_003_6165

	xor a

jr_003_6165:
	ld [hl], a
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_6178

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sra a
	cp $ff
	jr nz, jr_003_6177

	xor a

jr_003_6177:
	ld [hl], a

Jump_003_6178:
jr_003_6178:
	ret


FairySprites::
	db $20, $20, $20, $00

FairyHandler::
	call CheckHiddenPickup
	call UpdatePickupLifetime
	ld de, $6179
	call DrawEntity8x16
	call ReturnIfNonInteractive_03
	call FollowCarryingWeapon
	call CheckPickupCollected
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	rlca
	and $01
	call SetEntitySpriteVariant
	call UpdateEntityPosWithSpeed_03
	call UpdateFairyHeight
	call Call_03_7892
	call GetEntityXDistanceToLink_03
	ld a, d
	bit 7, a
	jr z, jr_003_61ae

jr_003_61ae:
	cp $20
	jr c, jr_003_61be

	call GetEntityYDistanceToLink_03
	ld a, d
	bit 7, a
	jr z, jr_003_61ba

jr_003_61ba:
	cp $20
	jr nc, jr_003_61df

jr_003_61be:
	call GetEntityTimer
	jr nz, jr_003_61e4

	ld [hl], $30
	call GetRandomByte
	and $0f
	sub $08
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $0f
	sub $08
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	jr jr_003_61e4

jr_003_61df:
	ld a, $09
	call Call_03_7E99

jr_003_61e4:
	ret


UpdateFairyHeight::
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_003_6202

	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $10
	jr z, jr_003_6202

	bit 7, a
	jr z, jr_003_61fb

	inc [hl]
	jr jr_003_6202

jr_003_61fb:
	cp $10
	jr nc, jr_003_6201

	inc [hl]
	ret


jr_003_6201:
	dec [hl]

jr_003_6202:
	ret


CheckHiddenPickup::
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_003_62c2

	ld a, [wRoomTransitionState]
	and a
	jp nz, Jump_003_62c1

	ld a, [hl]
	cp $02
	jr nz, jr_003_6268

	ldh a, [hActiveEntityType]
	cp $3d
	jr z, jr_003_6225

	ld a, [wIsIndoor]
	and a
	jp nz, Jump_003_62c1

jr_003_6225:
	call Call_03_7DE0
	ldh a, [hActiveEntityType]
	cp $2d
	jr z, jr_003_624c

	cp $3d
	jr nz, jr_003_6254

	ldh a, [hMapRoom]
	cp $da
	jr z, jr_003_6254

	cp $a5
	jr z, jr_003_6254

	cp $74
	jr z, jr_003_6254

	cp $3a
	jr z, jr_003_6254

	cp $a8
	jr z, jr_003_6254

	cp $b2
	jr z, jr_003_6254

jr_003_624c:
	ldh a, [hRoomObjectType]
	cp $04
	jr z, jr_003_6260

	jr jr_003_625a

jr_003_6254:
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], $01

jr_003_625a:
	ldh a, [hRoomObjectType]
	cp $cc
	jr nz, jr_003_62c1

jr_003_6260:
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $0a
	jr jr_003_6290

jr_003_6268:
	ld a, [wBumpShakeTimer]
	and a
	jr z, jr_003_62c1

	ld a, [wDashBumpFrames]
	and a
	jr z, jr_003_62c1

	ldh a, [hActiveEntityX]
	add $08
	ld hl, wDashBumpX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_003_62c1

	ldh a, [hActiveEntityY]
	add $08
	ld hl, wDashBumpY
	sub [hl]
	add $10
	cp $20
	jr nc, jr_003_62c1

jr_003_6290:
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
	call GetEntityTimer1
	ld [hl], $18
	ld a, $0c
	call Call_03_7E17
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	call GetEntityDropTimer
	ld [hl], $80

Jump_003_62c1:
jr_003_62c1:
	pop af

Jump_003_62c2:
	ret


PickupSwordCollectable::
	db $01, $01, $00, $00, $01, $00, $01, $01, $00, $00, $01, $01, $00, $00, $01, $00
	db $00

FollowCarryingWeapon::
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_630f

	pop de
	dec a
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_003_6336

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $01
	jr z, jr_003_62f5

	cp $03
	jr nz, jr_003_6336

jr_003_62f5:
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	xor a
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a

jr_003_630f:
	ret


CheckPickupCollected::
	call GetEntityTimer1
	jr nz, jr_003_630f

	ldh a, [hActiveEntityType]
	sub $2d
	ld e, a
	ld d, b
	ld hl, $62c3
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_003_6331

	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	push af
	push hl
	ld [hl], b
	call Call_03_6E40
	pop hl
	pop af
	ld [hl], a

jr_003_6331:
	call Call_03_6C87
	jr nc, jr_003_630f

CollectPickup::
jr_003_6336:
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	call Call_3FA2
	ldh a, [hActiveEntityType]
	sub $2d
	cp $02
	jr nc, jr_003_634d

	ld hl, hJingle
	ld [hl], $14
	jr jr_003_6352

jr_003_634d:
	ld hl, hWaveSfx
	ld [hl], $01

jr_003_6352:
	rst $00

PickupCollectEffects::
	dw Collect_Heart
	dw Collect_Rupee
	dw Collect_Fairy
	dw Collect_Key
	dw Collect_Sword
	dw Collect_Type32
	dw Collect_PieceOfPower
	dw Collect_GuardianAcorn
	dw Collect_HeartPiece
	dw Collect_HeartContainer
	dw Collect_Arrows
	dw Collect_Bombs
	dw Collect_Instrument
	dw Collect_WithFanfare
	dw Collect_MagicPowder
	dw Collect_WithFanfare
	dw Collect_Seashell

Collect_MagicPowder::
	ld a, $0b
	ldh [hBGChangeRequest], a
	ld d, $0c
	call GiveInventoryItem
	ld hl, wMaxMagicPowder
	ld de, wMagicPowderCount

AddOneUpToMax:
	ld a, [de]
	cp [hl]
	jr nc, jr_003_638c

	add $01
	daa
	ld [de], a

jr_003_638c:
	ret


Collect_Seashell::
	ld a, $ef
	call OpenDialog

AddSeashell::
	call MarkRoomChestOpened
	ld hl, wSeashells

IncrementBCD99::
	ld a, [hl]
	cp $99
	jr z, jr_003_63a1

	add $01
	daa
	ld [hl], a

jr_003_63a1:
	ret


Collect_Arrows::
	ld hl, wMaxArrows
	ld de, wArrowCount
	jr AddOneUpToMax

Collect_Bombs::
	ld d, $02
	call GiveInventoryItem
	ld hl, wMaxBombs
	ld de, wBombCount
	jr AddOneUpToMax

Collect_Instrument::
	xor a
	ld [wIndoorAltMusic], a
	ld [$c3cb], a
	ld a, $1b
	ld [wMusicTrackToPlay], a
	ld [wLinkFrozen], a

ShowItemWithSparkles::
	ldh a, [hLinkX]
	push af
	add $04
	ldh [hLinkX], a
	call SpawnSparklesAroundLink
	pop af
	ldh [hLinkX], a
	jr jr_003_63f7

Collect_HeartContainer::
	xor a
	ld [wActivePowerUp], a
	ld a, $25
	ld [wMusicTrackToPlay], a
	ld [wIndoorAltMusic], a
	call GetEntityTimer
	ld a, $70
	ld [hl], a
	ld [wLinkPoseLock], a
	jr SetPickupHeld

Collect_WithFanfare::
	ld a, $10
	ld [wMusicTrackToPlay], a
	jr jr_003_63f7

UnusedPickupCode::
	db $3e, $01, $e0, $f2

ShowPickupPose::
jr_003_63f7:
	call GetEntityTimer
	ld a, $68
	ld [hl], a
	ld [wLinkPoseLock], a

SetPickupHeld:
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
	jp ResetSpinAttackAndDash


Collect_HeartPiece::
	ld a, $10
	ld [wMusicTrackToPlay], a
	call IncrementEntityState
	jr SetPickupHeld

SparkleOffsetX::
	db $e4, $14, $e4, $14

SparkleOffsetY::
	db $d4, $d4, $04, $04

Collect_GuardianAcorn::
	ld a, $02
	ld e, $05
	jr StartPowerUp

Collect_PieceOfPower::
	ld a, $01
	ld e, $01

StartPowerUp:
	ld [wActivePowerUp], a
	ld a, e
	ld [wLinkShowItemPose], a
	ld a, $30
	ld [wLinkShowItemTimer], a
	ld [wLinkPoseLock], a
	xor a
	ld [$d47a], a
	ld a, $27
	ld [wMusicTrackToPlay], a
	ld a, $49
	ldh [hDefaultMusicTrackAlt], a
	ldh [hLastMusicTrack], a

SpawnSparklesAroundLink::
	ld e, $03
	ld d, $00

jr_003_6447:
	push de
	ld hl, $6413
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hMultiPurpose0], a
	ld hl, $6417
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hMultiPurpose1], a
	ld a, $07
	call AddTransientVfx
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $22
	ld hl, wVfxDirection
	add hl, de
	pop de
	ld [hl], e
	dec e
	ld a, e
	cp $ff
	jr nz, jr_003_6447

Collect_Type32::
	ret


Collect_Sword::
	ld a, [wSwordLevel]
	and a
	jr nz, jr_003_648d

	ld a, $0f
	ld [wMusicTrackToPlay], a
	ld [wLinkFrozen], a
	call ShowItemWithSparkles
	call GetEntityTimer
	ld [hl], $a0
	ld a, $ff
	ldh [hLastMusicTrack], a
	ret


jr_003_648d:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld [wShieldLevel], a
	ld d, $04

GiveInventoryItem::
	ld hl, wItemB
	ld e, $0c

jr_003_649c:
	ld a, [hli]
	cp d
	jr z, jr_003_64b3

	dec e
	jr nz, jr_003_649c

	ld hl, wItemB

jr_003_64a6:
	ld a, [hl]
	and a
	jr nz, jr_003_64ac

	ld [hl], d
	ret


jr_003_64ac:
	inc hl
	inc e
	ld a, e
	cp $0c
	jr nz, jr_003_64a6

jr_003_64b3:
	ret


Collect_Key::
	ldh a, [hMapRoom]
	cp $80
	jr nz, jr_003_64c2

	ld a, $10
	ld [wMusicTrackToPlay], a
	jp ShowPickupPose


jr_003_64c2:
	ldh a, [hMapRoom]
	cp $7c
	jr nz, jr_003_64cd

	ld hl, $d969
	set 4, [hl]

jr_003_64cd:
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, jr_003_64da

	ld a, $10
	ld [wMusicTrackToPlay], a
	jp ShowPickupPose


jr_003_64da:
	call MarkRoomChestOpened
	ld hl, wDungeonSmallKeys
	inc [hl]
	call SaveDungeonItemFlags
	ret


Collect_Heart::
	ld a, $08

AddHealth:
	ld hl, wAddHealthBuffer

AddToBuffer:
	add [hl]
	ld [hl], a
	ret


Collect_Rupee::
	ld a, $01
	ld hl, wAddRupeeBufferLow
	jr AddToBuffer

Collect_Fairy::
	ld a, $30
	jr AddHealth

SpawnEntity_03::
	ld e, $0f

SpawnEntityFromSlot_03::
	push af
	ld d, $00

jr_003_64fd:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_003_650e

	dec e
	ld a, e
	cp $ff
	jr nz, jr_003_64fd

	pop af
	scf
	ret


jr_003_650e:
	ld [hl], $05
	pop af
	ld hl, wEntityType
	add hl, de
	ld [hl], a
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose3], a
	call InitSpawnedEntityProperties
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], $01
	ld hl, wEntityPosXHigh
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPosXHigh
	add hl, de
	ld [hl], a
	ld hl, wEntityPosYHigh
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPosYHigh
	add hl, de
	ld [hl], a
	scf
	ccf
	ret


InitSpawnedEntityProperties::
	push bc
	push de
	push de
	pop bc
	call InitEntityProperties
	pop de
	pop bc
	ret


	db $80, $10, $f8, $f8, $32, $00, $f8, $00, $32, $20, $f8, $08, $32, $00, $f8, $10
	db $32, $20, $08, $f8, $32, $00, $08, $00, $32, $20, $08, $08, $32, $00, $08, $10
	db $32, $20, $f8, $f8, $10, $00, $f8, $00, $12, $00, $f8, $08, $12, $20, $f8, $10
	db $10, $20, $08, $f8, $10, $40, $08, $00, $12, $40, $08, $08, $12, $60, $08, $10
	db $10, $60, $fc, $fc, $30, $10, $fc, $04, $30, $30, $fc, $04, $30, $10, $fc, $0c
	db $30, $30, $04, $fc, $30, $10, $04, $04, $30, $30, $04, $04, $30, $10, $04, $0c
	db $30, $30, $fc, $fc, $30, $00, $fc, $04, $30, $20, $fc, $04, $30, $00, $fc, $0c
	db $30, $20, $04, $fc, $30, $00, $04, $04, $30, $20, $04, $04, $30, $00, $04, $0c
	db $30, $20

Call_03_65DE::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	sla a
	sla a
	sla a
	sla a
	sla a
	ld e, a
	ld d, b
	ld hl, $655e
	add hl, de
	ld c, $08
	call DrawEntitySprites
	ret


	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $03, $03, $03, $03

Jump_003_6611:
	call Call_03_667F
	call ReturnIfNonInteractive_03
	call GetEntityTimer
	and a
	jp nz, Jump_003_6621

	jp Call_3FB7


Jump_003_6621:
	ld e, a
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $4c
	ld a, e
	jp z, Jump_003_667e

	cp $0e
	jr c, jr_003_6643

	cp $17
	jr nc, jr_003_6643

	push af
	sub $0e
	ld e, a
	ld d, b
	push de
	call Call_03_691C
	pop de
	call Call_03_678D
	pop af

jr_003_6643:
	cp $12
	jr nz, jr_003_667e

	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_6654

	call Call_03_77D8
	jr jr_003_6679

jr_003_6654:
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $18
	cp $30
	jr nc, jr_003_6679

	ldh a, [hActiveEntityY]
	ld hl, hLinkY
	sub [hl]
	add $18
	cp $30
	jr nc, jr_003_6679

	call Call_03_6CF1
	ld hl, hLinkSpeedX
	sla [hl]
	ld hl, hLinkSpeedY
	sla [hl]

jr_003_6679:
	ld a, $04
	ld [wClinkTimer], a

Jump_003_667e:
jr_003_667e:
	ret


Call_03_667F::
	call GetEntityTimer
	ld e, a
	ld d, b
	ld hl, $65f9
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
	call Call_03_65DE
	ld a, [wIsIndoor]
	and a
	jr z, jr_003_66b4

	ld e, $e4
	ld a, [wRoomTransitionState]
	and a
	jr nz, jr_003_66b0

	call GetEntityTimer
	and $04
	jr z, jr_003_66b0

	ld e, $84

jr_003_66b0:
	ld hl, wBGPalette
	ld [hl], e

jr_003_66b4:
	ret


jr_003_66b5:
	ld de, $54ea
	call DrawEntity16x16
	call ReturnIfNonInteractive_03
	ret


Call_03_66BF::
	ldh a, [hActiveEntityDrawY]
	add $10
	cp $a0
	jp nc, Call_3FB7

	call GetEntityTimer
	cp $18
	jp c, Jump_003_6611

	jr nz, jr_003_66d6

	dec [hl]
	call PlayClinkNoise

jr_003_66d6:
	ld hl, wBombsOnScreen
	inc [hl]
	cp $22
	jr c, jr_003_66b5

	cp $48
	jr nz, jr_003_66e8

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $30

jr_003_66e8:
	call Call_03_673D
	call CheckKeyFallsInPit
	call ReturnIfNonInteractive_03
	call UpdatePickupPhysics
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $ff
	call GetEntityTimer1
	ld hl, wEntityPrivate4
	add hl, bc
	or [hl]
	jr nz, jr_003_6723

	ld a, [wItemB]
	cp $02
	jr nz, jr_003_6713

	ldh a, [hJoypadPressed]
	and $20
	jr nz, jr_003_6720

	jr jr_003_6723

jr_003_6713:
	ld a, [wItemA]
	cp $02
	jr nz, jr_003_6723

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_003_6723

jr_003_6720:
	call TryLiftStunnedEntity

jr_003_6723:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_003_672f

	call Call_03_6B4F

jr_003_672f:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_673c

	ld a, [hl]
	and $0c
	jr z, jr_003_673c

	call Call_03_6B5E

jr_003_673c:
	ret


Call_03_673D::
	ld hl, hActiveEntityDrawY
	inc [hl]
	inc [hl]
	ld de, $655c
	call DrawEntity8x16
	jp LoadEntityPosition


	db $f8, $08, $18, $f8, $08, $18, $f8, $08, $18, $f8, $f8, $f8, $08, $08, $08, $18
	db $18, $18, $48, $48, $00, $90, $00, $70, $38, $38, $3d, $3d, $3e, $3e, $72, $72
	db $73, $73, $69, $79, $69, $79, $64, $66, $65, $67, $04, $08, $02, $01, $08, $04
	db $01, $02, $f8, $08, $ff, $01, $72, $73, $73, $72, $00, $10, $f0, $10, $00, $00
	db $10, $00

Call_03_678D::
	ldh a, [hIsSideScrolling]
	and a
	jp nz, Jump_003_68c5

	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
	ld hl, $674b
	add hl, de
	add [hl]
	and $f0
	ldh [hBGPosX], a
	swap a
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $10
	ld hl, $6754
	add hl, de
	add [hl]
	and $f0
	ldh [hBGPosY], a
	or c
	ld c, a
	ld b, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	ld a, c
	ldh [hMultiPurposeH], a
	ld a, [hl]
	ldh [hRoomObjectType], a
	ld e, a
	cp $bb
	jr c, jr_003_6828

	cp $bf
	jr nc, jr_003_6828

	ld a, [wIsIndoor]
	and a
	jr nz, jr_003_6828

	ld a, $02
	ldh [hJingle], a
	ldh a, [hBGPosY]
	and $e0
	ldh [hBGPosY], a
	ldh a, [hBGPosX]
	and $e0
	ldh [hBGPosX], a
	call Call_03_68CE
	ld a, c
	and $ee
	ld c, a
	ld hl, wRoomObjects
	add hl, bc
	ld a, $09
	ld [hli], a
	ld [hld], a
	ld a, l
	add $10
	ld l, a
	ld a, $09
	ld [hli], a
	ld [hl], $09
	ld c, $03
	ld b, $00

jr_003_6802:
	call Call_03_6822
	ld hl, $6785
	add hl, bc
	ld a, [hl]
	ld hl, hBGPosX
	add [hl]
	ld [hl], a
	ld hl, $6789
	add hl, bc
	ld a, [hl]
	ld hl, hBGPosY
	add [hl]
	ld [hl], a
	dec c
	ld a, c
	cp $ff
	jr nz, jr_003_6802

	jp Jump_003_68c4


Call_03_6822::
	ld de, $6781
	jp Jump_003_6852


jr_003_6828:
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	sub $99
	jp c, Jump_003_68c4

	cp $04
	jp nc, Jump_003_68c4

	ld c, a
	ld a, $02
	ldh [hJingle], a
	ld a, [wIsIndoor]
	and a
	jr nz, jr_003_6865

	pop bc
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, b
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $e1
	ld de, $6771

Jump_003_6852:
	push de
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	or $04
	ld [hl], a
	ldh [hRoomStatus], a
	jp DrawRoomObjectTiles


jr_003_6865:
	ld hl, $d900
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_003_6878

	cp $06
	jr c, jr_003_6878

	inc d

jr_003_6878:
	add hl, de
	push hl
	pop de
	ld hl, $6775
	add hl, bc
	ld a, [de]
	or [hl]
	ld [de], a
	ldh [hRoomStatus], a
	ld hl, $677d
	add hl, bc
	ld a, [wIndoorRoom]
	add [hl]
	ld e, a
	ld d, $00
	call GetDungeonRoomStatusAddress
	push hl
	pop de
	ld hl, $6779
	add hl, bc
	ld a, [de]
	or [hl]
	ld [de], a
	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	push hl
	pop de
	ld hl, $6765
	add hl, bc
	ld a, [hl]
	ld [de], a
	ld a, c
	rla
	and $04
	ld c, a
	ld hl, $6769
	add hl, bc
	pop bc
	push hl
	jp DrawRoomObjectTiles


Jump_003_68c4:
	pop bc

Jump_003_68c5:
	ret


	db $08, $18, $08, $18, $10, $10, $20, $20

Call_03_68CE::
	push bc
	ld c, $03
	ld b, $00

jr_003_68d3:
	ld a, $05
	call SpawnEntity_03
	jr c, jr_003_6902

	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
	ldh a, [hBGPosX]
	ld hl, $68c6
	add hl, bc
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hBGPosY]
	ld hl, $68ca
	add hl, bc
	add [hl]
	ld hl, hMultiPurpose3
	sub [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4

jr_003_6902:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_003_68d3

	pop bc
	ret


	db $f8, $08, $18, $f8, $08, $18, $f8, $08, $18, $f8, $f8, $f8, $08, $08, $08, $18
	db $18, $18

Call_03_691C::
	push bc
	ld hl, $690a
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	sub $08
	and $f0
	ldh [hBGPosX], a
	swap a
	ld c, a
	ld hl, $6913
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	sub $10
	and $f0
	ldh [hBGPosY], a
	or c
	ld e, a
	ld hl, wRoomObjects
	add hl, de
	ld a, h
	cp $d7
	jp nz, Jump_003_69bb

	ld a, [wIsIndoor]
	and a
	ld a, [hl]
	ldh [hRoomObjectType], a
	jr nz, jr_003_6960

	ldh [hMultiPurposeH], a
	cp $0a
	jr z, jr_003_697f

	cp $d3
	jr z, jr_003_697f

	cp $5c
	jr z, jr_003_697f

	jp Jump_003_69bb


jr_003_6960:
	cp $a9
	jp nz, Jump_003_69bb

	ldh a, [hMapRoom]
	ld c, a
	ld b, $00
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_003_6975

	cp $06
	jr c, jr_003_6975

	inc b

jr_003_6975:
	ld hl, $d900
	add hl, bc
	ld a, [hl]
	or $40
	ld [hl], a
	ldh [hRoomStatus], a

jr_003_697f:
	call RemoveRoomObject
	ld a, $05
	call SpawnEntity_03
	jr c, jr_003_69bb

	xor a
	ld [wItemUsePoseTimer], a
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [wIsIndoor]
	xor $01
	ld [hl], a
	ldh [hActiveEntitySpriteVariant], a
	ldh a, [hMultiPurposeH]
	cp $0a
	jr nz, jr_003_69b6

	ld a, $ff
	ld [hl], a
	ldh [hActiveEntitySpriteVariant], a

jr_003_69b6:
	push de
	pop bc
	call BreakThrownObject

Jump_003_69bb:
jr_003_69bb:
	pop bc
	ret


	db $6c, $74, $6d, $75, $36, $00, $36, $20, $36, $10, $36, $30

Call_03_69C9::
	ld hl, wActiveProjectileCount
	inc [hl]
	ld a, $0a
	ld [wProjectileWeaponType], a
	call Call_03_75A6
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	call GetEntityTimer1
	jr z, jr_003_69f0

	dec a
	jp z, Call_3FB7

	ld de, BurningFlameSprites
	jp DrawEntity16x16


jr_003_69f0:
	ld de, $69c1
	call Call_03_6AF2
	call ReturnIfNonInteractive_03
	ld a, [wIsIndoor]
	and a
	ldh a, [hRoomObjectType]
	jr z, jr_003_6a07

	cp $8a
	jr z, jr_003_6a0f

	jr jr_003_6a34

jr_003_6a07:
	cp $d3
	jr z, jr_003_6a0f

	cp $5c
	jr nz, jr_003_6a34

jr_003_6a0f:
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], b
	call GetEntityTimer1
	ld [hl], b
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, b
	call RemoveRoomObject
	ldh a, [hBGPosX]
	add $08
	ldh [hMultiPurpose0], a
	ldh a, [hBGPosY]
	add $10
	ldh [hMultiPurpose1], a
	ld a, $08
	call AddTransientVfx
	ld a, $13
	ldh [hNoiseSfx], a

jr_003_6a34:
	ret


	db $6c, $00, $6c, $20, $5c, $00, $5c, $20

Call_03_6A3D::
	call GetEntityTimer
	jr nz, jr_003_6a45

	call Call_03_6BF9

jr_003_6a45:
	ld de, $6a35
	jp Call_03_6AF2


Call_03_6A4B::
	ld hl, wActiveProjectileCount
	inc [hl]
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_003_6a8b

	call GetEntityTimer
	jp nz, Call_03_6AEF

	ld a, $05
	ld [wProjectileWeaponType], a
	call Call_03_75A6
	call Call_03_6AEF
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nz, jr_003_6a80

	ld a, [wRoomEvent]
	and $1f
	cp $0f
	jr nz, jr_003_6a80

	ldh a, [hRoomObjectType]
	cp $c0
	jr nz, jr_003_6a80

	call TriggerRoomEvent
	call Call_3FB7

jr_003_6a80:
	ret


	db $80, $10, $04, $fc, $00, $00, $fe, $fe, $fa, $04

jr_003_6a8b:
	call GetEntityTimer
	jr z, jr_003_6ab1

	ld a, $02
	call SpawnEntity_03
	jr c, jr_003_6aae

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
	call PlayClinkNoise

jr_003_6aae:
	jp Call_3FB7


jr_003_6ab1:
	ldh a, [hActiveEntitySpriteVariant]
	push af
	ld e, a
	ld d, b
	xor a
	ldh [hActiveEntitySpriteVariant], a
	ld hl, $6a83
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $6a87
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld de, $6a81
	call DrawEntity8x16
	call LoadEntityPosition
	pop af
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6be1
	call DrawEntity16x16
	ld a, $0c
	ld [wProjectileWeaponType], a
	call Call_03_75A6
	jr jr_003_6af5

Call_03_6AE7::
	call GetEntityTimer
	jr nz, Call_03_6AEF

	call Call_03_6BF9

Call_03_6AEF::
	ld de, $6be1

Call_03_6AF2::
	call DrawEntity16x16

jr_003_6af5:
	call ReturnIfNonInteractive_03
	call GetEntityTimer
	jr nz, jr_003_6b67

	call UpdateEntityPosWithSpeed_03
	call Call_03_7CAA
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_6b5d

	call GetEntityTimer
	ldh a, [hActiveEntityType]
	cp $04
	jr nz, jr_003_6b1a

	call GetEntityTimer1
	ld [hl], $30
	ret


jr_003_6b1a:
	ld [hl], $18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	inc a
	jr z, jr_003_6b2e

	ld a, $07
	ldh [hJingle], a

jr_003_6b2e:
	call StartClinkTimer
	ldh a, [hActiveEntityType]
	cp $00
	jr nz, jr_003_6b4c

	call Call_03_6B47
	ld hl, wEntitySpeedX

jr_003_6b3d:
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	sra a
	ld [hl], a
	ret


Call_03_6B47::
	ld hl, wEntitySpeedY
	jr jr_003_6b3d

jr_003_6b4c:
	call Call_03_6B5E

Call_03_6B4F::
	ld hl, wEntitySpeedX

jr_003_6b52:
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	sra a
	sra a
	ld [hl], a

jr_003_6b5d:
	ret


Call_03_6B5E::
	ld hl, wEntitySpeedY
	jr jr_003_6b52

	db $00, $03, $01, $02

jr_003_6b67:
	cp $01
	jr nz, jr_003_6b6e

	jp Call_3FB7


jr_003_6b6e:
	ldh a, [hActiveEntityType]
	cp $0a
	jr z, jr_003_6b89

	call GetEntityTimer
	srl a
	srl a
	srl a
	and $03
	ld e, a
	ld d, b
	ld hl, $6b63
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant

jr_003_6b89:
	call UpdateEntityPosWithSpeed_03
	jr Call_03_6B96

	db $02, $01, $02, $02, $40, $08, $40, $40

Call_03_6B96::
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_6ba7

	call AddEntityZSpeedToPos_03
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sub $02
	ld [hl], a
	ret


jr_003_6ba7:
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	and a
	jr z, jr_003_6bc6

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_003_6bc6

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_6bc6

	and $80
	jr z, jr_003_6bc5

	inc [hl]
	inc [hl]

jr_003_6bc5:
	dec [hl]

jr_003_6bc6:
	ld hl, $6b8e
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $6b92
	add hl, de
	sub [hl]
	and $80
	jr nz, jr_003_6be0

	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_003_6be0:
	ret


	db $2e, $20, $2c, $20, $2c, $00, $2e, $00, $2a, $40, $2a, $60, $2a, $00, $2a, $20
	db $01, $00, $03, $02, $02, $0a, $0e, $06

Call_03_6BF9::
	ld a, [wLinkMotionState]
	cp $02
	jr nc, jr_003_6c76

	ldh a, [hLinkPositionZ]
	and a
	jr nz, jr_003_6c76

	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_003_6c76

	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_003_6c76

	ld a, [wIsUsingShield]
	and a
	jr z, jr_003_6c77

	ldh a, [hActiveEntityType]
	cp $2b
	jr nz, jr_003_6c5d

	ld a, [wShieldLevel]
	cp $02
	jr c, jr_003_6c77

	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $6bf5
	add hl, de
	ld e, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	sub e
	and $0f
	cp $05
	jr nc, jr_003_6c77

	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $02
	ld a, $07
	ldh [hJingle], a
	ldh a, [hActiveEntityY]

Call_03_6C51::
	ldh [hMultiPurpose1], a
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ld a, $05
	call AddTransientVfx
	ret


jr_003_6c5d:
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6bf1
	add hl, de
	ldh a, [hLinkDirection]
	cp [hl]
	jr nz, jr_003_6c77

	ld a, $16
	ldh [hJingle], a

Jump_003_6c70:
jr_003_6c70:
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $ff

jr_003_6c76:
	ret


jr_003_6c77:
	call Call_03_6CDC
	ldh a, [hActiveEntityType]
	cp $2b
	jr z, jr_003_6c84

	cp $0c
	jr nz, jr_003_6c70

jr_003_6c84:
	jp Call_3FB7


Call_03_6C87::
	ldh a, [hFrameCounter]
	xor c
	rra
	jp nc, Jump_003_6ce7

Call_03_6C8E::
	ldh a, [hLinkPositionZ]
	and a
	jr nz, jr_003_6c76

Call_03_6C93::
	ld a, [wLinkMotionState]
	cp $02
	jr nc, jr_003_6c76

	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	pop bc
	ldh a, [hActiveEntityX]
	add [hl]
	push hl
	ld hl, hLinkX
	sub [hl]
	sub $08
	cp $80
	jr c, jr_003_6cb4

	cpl
	inc a

jr_003_6cb4:
	pop hl
	push af
	inc hl
	ld a, $04
	add [hl]
	ld e, a
	pop af
	cp e
	jp nc, Jump_003_6ce7

	inc hl
	ldh a, [hActiveEntityDrawY]
	add [hl]
	push hl
	ld hl, hLinkY
	sub [hl]
	sub $08
	cp $80
	jr c, jr_003_6cd1

	cpl
	inc a

jr_003_6cd1:
	pop hl
	push af
	inc hl
	ld a, $04
	add [hl]
	ld e, a
	pop af
	cp e
	jr nc, jr_003_6ce7

Call_03_6CDC::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_003_6ce9

jr_003_6ce5:
	scf
	ret


Jump_003_6ce7:
jr_003_6ce7:
	and a
	ret


jr_003_6ce9:
	ldh a, [hLinkAnimationState]
	sub $4e
	cp $02
	jr c, jr_003_6ce5

Call_03_6CF1::
	ldh a, [hActiveEntityType]
	cp $ac
	jr nz, jr_003_6d15

	call GetEntityYDistanceToLink_03
	ld a, e
	cp $02
	jr nz, jr_003_6d59

	call IncrementEntityState
	ld [hl], $05
	ld a, $02
	ld [wIsLinkInTheAir], a
	ld a, $f0
	ldh [hLinkSpeedY], a
	call ClearEntitySpeed
	ld a, $0e
	ldh [hWaveSfx], a
	ret


jr_003_6d15:
	ldh a, [hActiveEntityType]
	cp $9f
	jr nz, jr_003_6d59

	ld a, [wIsLinkInTheAir]
	and a
	jr z, jr_003_6d59

	ldh a, [hLinkCountdown]
	and a
	jr nz, jr_003_6d37

	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_6d31

	ldh a, [hLinkSpeedZ]
	xor $80
	jr jr_003_6d33

jr_003_6d31:
	ldh a, [hLinkSpeedY]

jr_003_6d33:
	and $80
	jr nz, jr_003_6d59

jr_003_6d37:
	ld a, $02
	ldh [hLinkCountdown], a
	ld hl, wEntityState
	add hl, bc
	ld [hl], $02
	call GetEntityTimer
	ld [hl], $30
	ld a, $0e
	ldh [hWaveSfx], a
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_6d54

	ld a, $10
	ldh [hLinkSpeedZ], a
	ret


jr_003_6d54:
	ld a, $f0
	ldh [hLinkSpeedY], a
	ret


jr_003_6d59:
	ldh a, [hActiveEntityType]
	cp $1c
	jr nz, jr_003_6d6a

	call GetEntityTimer
	ld [hl], $80
	call IncrementEntityState
	ld [hl], $04
	ret


jr_003_6d6a:
	cp $8e
	jr z, jr_003_6d79

	cp $82
	jr z, jr_003_6d79

	ld a, [wLinkPushedTimer]
	and a
	jp nz, Jump_003_6e1f

jr_003_6d79:
	ldh a, [hActiveEntityType]
	cp $e4
	jr nz, jr_003_6d8f

	ldh a, [hActiveEntityState]
	cp $04
	jr nz, jr_003_6d8f

	call IncrementEntityState
	ld [hl], $08
	ld a, $03
	ldh [hWaveSfx], a
	ret


jr_003_6d8f:
	ld a, [wInvincibilityCounter]
	ld hl, wHookshotOut
	or [hl]
	ld hl, wOcarinaSongState
	or [hl]
	ld hl, wLinkShowItemPose
	or [hl]
	jp nz, Jump_003_6e1f

	ld a, $03
	ldh [hWaveSfx], a
	ld hl, wEntityHealthGroup
	add hl, bc
	ld d, b
	ld e, [hl]
	ld hl, $484e
	add hl, de
	ld e, [hl]
	ld a, [wActivePowerUp]
	cp $02
	jr nz, jr_003_6dc0

	ld a, e
	cp $04
	jr nz, jr_003_6dbe

	ld e, $00

jr_003_6dbe:
	srl e

jr_003_6dc0:
	ld a, [wSubtractHealthBuffer]
	add e
	ld [wSubtractHealthBuffer], a
	ld a, $50
	ld [wInvincibilityCounter], a
	xor a
	ld [$d471], a
	ld a, [wActivePowerUp]
	and a
	jr z, Call_03_6DF4

	ld hl, $d47a
	inc [hl]
	ld a, [hl]
	cp $03
	jr c, Call_03_6DF4

	xor a
	ld [wActivePowerUp], a
	ld a, [wBossInRoom]
	and a
	jr nz, Call_03_6DF4

	ldh a, [hDefaultMusicTrack]
	cp $22
	jr z, jr_003_6df2

	ld [wMusicTrackToPlay], a

jr_003_6df2:
	ldh [hLastMusicTrack], a

Call_03_6DF4::
	call ResetPegasusBoots
	ld a, $10
	ld [wLinkPushedTimer], a
	ldh a, [hActiveEntityType]
	ld e, $18
	cp $82
	jp z, Jump_003_6fbc

	cp $5a
	jr nz, jr_003_6e0f

	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $01

jr_003_6e0f:
	cp $59
	ld a, $14
	jr nz, jr_003_6e17

	ld a, $18

jr_003_6e17:
	call Call_03_7569
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_6e23

Jump_003_6e1f:
jr_003_6e1f:
	scf
	ret


	db $0c, $f4

jr_003_6e23:
	ldh a, [hLinkMotionStep]
	cp $02
	jr z, jr_003_6e1f

	call GetEntityXDistanceToLink_03
	ld d, b
	ld hl, $6e21
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld a, $f4
	ldh [hLinkSpeedY], a
	xor a
	ldh [hLinkMotionStep], a
	scf
	ret


Call_03_6E3D::
	call Call_03_6C87

Call_03_6E40::
	ld a, [wSwordHitboxX]
	cp $00
	jp z, Jump_003_73ea

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_6e55

	cp $18
	jp c, Jump_003_73ea

jr_003_6e55:
	ld a, [wSwordDirectionLocked]
	and a
	jr z, jr_003_6e60

	dec a
	cp c
	jp z, Jump_003_73ea

jr_003_6e60:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_003_73ea

	ld de, hActiveEntityX
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	pop bc
	ld a, [de]
	add [hl]
	push hl
	ld hl, wSwordHitboxX
	sub [hl]
	cp $80
	jr c, jr_003_6e83

	cpl
	inc a

jr_003_6e83:
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxWidth]
	add [hl]
	ld e, a
	pop af
	cp e
	jp nc, Jump_003_73ea

	inc hl
	push hl
	ld de, hActiveEntityDrawY
	pop hl
	ld a, [de]
	add [hl]
	push hl
	ld hl, wSwordHitboxY
	sub [hl]
	cp $80
	jr c, jr_003_6ea3

	cpl
	inc a

jr_003_6ea3:
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxHeight]
	add [hl]
	ld e, a
	pop af
	cp e
	jp nc, Jump_003_73ea

	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $20
	jp nz, CollectPickup

	ld a, [wSwordCollisionEnabled]
	and a
	jp nz, Jump_003_6ffe

	ld a, [wIsUsingPegasusBoots]
	ldh [hMultiPurposeH], a
	call ResetPegasusBoots
	ldh a, [hActiveEntityType]
	cp $e2
	jr nz, jr_003_6ee6

	ld a, [wShieldLevel]
	cp $02
	ret nz

	ldh a, [hLinkDirection]
	cp $02
	ret nz

	ld a, $04
	ldh [hLinkSpeedY], a
	ld a, $08
	ld [wLinkPushedTimer], a
	jp IncrementEntityState


jr_003_6ee6:
	cp $55
	jr nz, jr_003_6f0c

	ldh a, [hActiveEntityState]
	cp $02
	jp nz, Call_03_6FA8

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call GetEntityTimer
	ld [hl], $40
	call GetEntityTimer1
	ld [hl], $08
	ret


jr_003_6f0c:
	cp $51
	jr nz, jr_003_6f35

	ld hl, wEntityOptions1
	add hl, bc
	and $40
	jp z, Call_03_6FA8

Jump_003_6f19:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call Call_03_6F71
	call GetEntityTimer1
	ld [hl], $0c
	ld a, $01
	ld [$c160], a
	xor a
	ld [wSwordCharge], a
	jp Jump_003_714c


jr_003_6f35:
	cp $58
	jr nz, jr_003_6f3f

Jump_003_6f39:
	call Call_03_6FA8
	jp Jump_003_6c70


jr_003_6f3f:
	cp $2c
	jr nz, jr_003_6f82

	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	cp $03
	jr z, Call_03_6F71

	ld [hl], $03
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	call GetEntityTimer
	ld [hl], $ff
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $6f7a
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $6f7e
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

Call_03_6F71::
	call Call_03_6FA8
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ret


	db $10, $f0, $00, $00, $00, $00, $f0, $10

jr_003_6f82:
	cp $9c
	jr z, jr_003_6f8a

	cp $15
	jr nz, jr_003_6fa3

jr_003_6f8a:
	ldh a, [hLinkDirection]
	and $02
	jr nz, jr_003_6f96

	ld hl, wEntitySpeedX
	add hl, bc
	jr jr_003_6f9a

jr_003_6f96:
	ld hl, wEntitySpeedY
	add hl, bc

jr_003_6f9a:
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call Call_03_6FA8
	ld [hl], b
	ret


jr_003_6fa3:
	cp $5a
	jp z, Jump_003_6f39

Call_03_6FA8::
	ld a, $09
	ldh [hJingle], a
	call ResetPegasusBoots
	ld a, $0c
	ld [wLinkPushedTimer], a
	ldh a, [hActiveEntityType]
	cp $82
	jr nz, jr_003_6fce

	ld e, $10

Jump_003_6fbc:
	push de
	call GetEntityXDistanceToLink_03
	ld a, e
	and a
	pop de
	ld a, e
	jr z, jr_003_6fc8

	cpl
	inc a

jr_003_6fc8:
	ldh [hLinkSpeedX], a
	xor a
	ldh [hLinkSpeedY], a
	ret


jr_003_6fce:
	ld a, $12
	call Call_03_7569
	ld hl, hMultiPurposeH
	ldh a, [hJoypadHeld]
	and $0f
	ld a, $08
	or [hl]
	jr z, Call_03_6FE1

	ld a, $20

Call_03_6FE1::
	call Call_03_7E17
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], a
	call Call_03_73DF
	ret


	db $00, $01, $02, $03

Jump_003_6ffe:
	ldh a, [hActiveEntityType]
	cp $e2
	ret z

	cp $e6
	jr nz, jr_003_702f

	ld a, [wFinalNightmareForm]
	rst $00

JumpTable_03_700B::
	dw EntityInit_None
	dw Jump_03_7017
	dw Jump_03_701D
	dw Jump_03_702D
	dw Jump_03_702D
	dw Jump_03_7059

Jump_03_7017::
	call IncrementEntityState
	ld [hl], $06
	ret


Jump_03_701D::
	ld a, [wSpinAttackTimer]
	and a
	jr nz, jr_003_7029

	ld a, [wSwordAnimationStatePrev]
	cp $04
	ret nc

jr_003_7029:
	call IncrementEntityState
	ret


Jump_03_702D::
	ldh a, [hActiveEntityType]

jr_003_702f:
	cp $b9
	jr nz, Jump_03_7059

	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, Jump_03_7059

	call IncrementEntityState
	ld [hl], $01
	call GetEntityTimer
	ld [hl], $40
	ld a, $40
	ld [$d464], a
	xor a
	ld [wSwordAnimationState], a
	ld [wSwordAnimationStatePrev], a
	ld [wSpinAttackTimer], a
	ld a, $1c
	ldh [hNoiseSfx], a
	jp Call_03_6CF1


Jump_03_7059::
	ldh a, [hActiveEntityType]
	cp $55
	jr nz, jr_003_7086

	ld a, $30
	call Call_03_7E17
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call IncrementEntityState
	ld [hl], $02
	call GetEntityTimer
	ld [hl], $40
	call GetEntityTimer1
	ld [hl], $08
	ret


jr_003_7086:
	cp $65
	jr nz, jr_003_7094

	call Call_03_6DF4
	ld a, $08
	ld [wLinkPushedTimer], a
	jr jr_003_70d1

jr_003_7094:
	cp $5b
	jr nz, jr_003_70d1

	ldh a, [hBGTilesRequestCopy]
	and a
	jr nz, jr_003_70c0

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $04
	jp nz, Jump_003_70b4

	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_003_7113

	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $0c
	ret


Jump_003_70b4:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_003_70c4

	call Call_03_6DF4
	jp Jump_003_7113


jr_003_70c0:
	call Call_03_6DF4
	ret


jr_003_70c4:
	ld a, $04
	ld [wLinkPushedTimer], a
	ld a, $10
	call Call_03_7569
	jp Jump_003_7113


jr_003_70d1:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $40
	jr z, jr_003_7113

	ldh a, [hActiveEntityType]
	cp $51
	jp z, Jump_003_6f19

	cp $5c
	jr nz, jr_003_70f8

	ld a, [wActivePowerUp]
	cp $01
	ld a, $20
	jr nz, jr_003_70f0

	ld a, $30

jr_003_70f0:
	call Call_03_6FE1
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], b

jr_003_70f8:
	ld a, c
	inc a
	ld [wSwordDirectionLocked], a
	call AddClinkAtSword
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $10
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], b
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], b
	jp Call_03_6DF4


Jump_003_7113:
jr_003_7113:
	ldh a, [hActiveEntityType]
	cp $8e
	jr nz, jr_003_711e

	call ResetPegasusBoots
	jr jr_003_715f

jr_003_711e:
	cp $24
	jr nz, jr_003_7158

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_7158

	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $6ffa
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr z, jr_003_715f

	call ResetPegasusBoots
	ld a, $10
	ld [wLinkPushedTimer], a
	ld a, $10
	call Call_03_7569
	ld a, $10
	call Call_03_6FE1

Jump_003_714c:
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	call AddClinkVfx
	ret


jr_003_7158:
	ldh a, [hActiveEntityType]
	cp $15
	jp z, Jump_003_73ea

jr_003_715f:
	ld a, $01
	ld [$c160], a
	ld a, [wSwordAnimationStatePrev]
	cp $05
	jr nz, jr_003_7170

	ld a, $0c
	ld [wSwordPokeTimer], a

jr_003_7170:
	xor a
	ld [wSwordCharge], a
	ld a, $30
	call Call_03_6FE1
	ld hl, hJingle
	ld [hl], $09
	ld a, [wActivePowerUp]
	cp $01
	jr nz, Call_03_71A8

	call Call_03_71A8
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $20
	ld hl, $c4a0
	add hl, bc
	ld [hl], $01
	ld a, $11
	ldh [hWaveSfx], a
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $01
	jr nz, jr_003_71a7

	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $40

jr_003_71a7:
	ret


Call_03_71A8::
	ld a, c
	inc a
	ld [wSwordDirectionLocked], a
	ld a, [wActivePowerUp]
	and $01
	ld hl, wSpinAttackTimer
	or [hl]
	ld hl, wIsUsingPegasusBoots
	or [hl]
	ld a, [wSwordLevel]
	jr z, jr_003_71c0

	inc a

jr_003_71c0:
	dec a
	ld [wProjectileWeaponType], a

Call_03_71C4::
	ld hl, wEntityHealthGroup
	add hl, bc
	ld e, [hl]
	ld d, b
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, EntityDamageClassTable
	add hl, de
	ld a, [wProjectileWeaponType]
	ld e, a
	ld d, b
	add hl, de
	ld e, [hl]
	push de
	ld a, [wProjectileWeaponType]
	rla
	rla
	rla
	and $f8
	ld e, a
	ld hl, WeaponDamageTable
	add hl, de
	pop de
	add hl, de
	ld a, [hl]
	and a
	ret z

	push af
	ldh a, [hActiveEntityType]
	cp $e6
	jr nz, jr_003_7219

	ld a, [wFinalNightmareForm]
	cp $04
	jr nz, jr_003_7219

	ld a, [wIsUsingPegasusBoots]
	push af
	call Call_03_6DF4
	pop af
	and a
	jr nz, jr_003_7219

	ld a, [wSpinAttackTimer]
	and a
	jr nz, jr_003_7219

	pop af
	ret


jr_003_7219:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	ld hl, hJingle
	ld [hl], $03
	and $80
	jr z, jr_003_722c

	ld hl, hWaveSfx
	ld [hl], $07

jr_003_722c:
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	cp $6c
	jr nz, jr_003_7239

	ld a, $13
	ldh [hWaveSfx], a

jr_003_7239:
	pop af
	cp $f0
	jr c, jr_003_72b9

	cp $fe
	jr nz, jr_003_7264

	ld hl, hNoiseSfx
	ld [hl], $12
	call Call_03_73DF
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $03
	call GetEntityTimer
	ld [hl], $60
	ld hl, wEntityPhysicsFlags
	add hl, bc
	inc [hl]
	inc [hl]
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $c2
	ld [hl], a
	ret


jr_003_7264:
	cp $ff
	jr nz, jr_003_727d

	call Call_03_73DF
StunEntity::
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $06
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $ff
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ret


jr_003_727d:
	cp $fd
	jr nz, jr_003_72b8

	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	cp $b9
	jr nz, jr_003_7295

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_72b8

	inc [hl]
	jr jr_003_729f

jr_003_7295:
	ld [hl], $2f
	call InitEntityProperties
	call GetEntityDropTimer
	ld [hl], $80

jr_003_729f:
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	sub [hl]
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx
	ret


jr_003_72b8:
	ret


jr_003_72b9:
	ld e, a
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	jr c, jr_003_72c6

	jp nz, Jump_003_73ba

jr_003_72c6:
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_003_7342

	bit 2, a
	jr nz, jr_003_7308

	ld e, $0f
	ld d, b

jr_003_72dc:
	ld a, e
	cp c
	jr z, jr_003_72f2

	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_003_72f2

	ld hl, wEntityOptions1
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_003_7308

jr_003_72f2:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_003_72dc

	ld a, [wCurrentBank]
	push af
	ld a, $03
	call SwitchBank
	call ResetSoundEngine
	pop af
	ld [wCurrentBank], a

jr_003_7308:
	ld a, $03
	ld [wDelayedWaveSfxTimer], a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	ld e, $b7
	cp $5a
	jr z, jr_003_7329

	ld e, $b9
	cp $63
	jr z, jr_003_7334

	ld e, $bd
	cp $62
	jr nz, jr_003_7342

jr_003_7329:
	ld a, e
	call OpenDialog
	ld a, $5e
	ld [wMusicTrackToPlay], a
	jr jr_003_7342

jr_003_7334:
	ldh a, [hLinkY]
	push af
	ld a, $10
	ldh [hLinkY], a
	ld a, e
	call OpenDialog
	pop af
	ldh [hLinkY], a

jr_003_7342:
	call IncrementEntityState
	ld [hl], b
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $2f
	ld hl, wEntityFlashTimer
	add hl, bc
	xor a
	ld [hl], a
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_003_7365

	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a

jr_003_7365:
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	cp $12
	jr nz, jr_003_73ba

	ld e, $0f
	ld d, b

jr_003_7371:
	ld a, e
	cp c
	jr z, jr_003_73ae

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $10
	jr z, jr_003_7382

	cp $11
	jr nz, jr_003_73ae

jr_003_7382:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_003_73ae

	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_003_73ae

	ld [hl], $01
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $1f
	call GetRandomByte
	and $03
	push bc
	ld c, a
	ld b, $00
	ld hl, $73eb
	add hl, bc
	ld a, [hl]
	ld hl, wEntityDropType
	add hl, de
	ld [hl], a
	pop bc

jr_003_73ae:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_003_7371

	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $2e

Jump_003_73ba:
jr_003_73ba:
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	ld hl, wEntityFlashTimer
	add hl, bc
	cp $e6
	jr nz, jr_003_73d0

	ld a, [wFinalNightmareForm]
	cp $03
	jr z, jr_003_73d4

	jr jr_003_73dd

jr_003_73d0:
	cp $59
	jr nz, jr_003_73dd

jr_003_73d4:
	ld [hl], $28
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $c8
	ret


jr_003_73dd:
	ld [hl], $18

Call_03_73DF::
	ld hl, $c4a0
	add hl, bc
	ld [hl], b
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $0a

Jump_003_73ea:
	ret


	db $2d, $2e, $38, $37

Call_03_73EF::
	ld hl, wSwordDirectionLocked
	ld a, [wLinkPushedTimer]
	or [hl]
	ld hl, $ffb6
	or [hl]
	ld hl, wSpinAttackTimer
	or [hl]
	jp nz, Jump_003_74e5

	ld a, [wSwordHitboxX]
	cp $00
	jp z, Jump_003_74e5

	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hLinkDirection]
	cp [hl]
	jp z, Jump_003_74e5

	ld de, hActiveEntityX
	ld hl, wClashBoxX
	ld a, [de]
	add [hl]
	push hl
	ld hl, wSwordHitboxX
	sub [hl]
	cp $80
	jr c, jr_003_7426

	cpl
	inc a

jr_003_7426:
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxWidth]
	add [hl]
	ld e, a
	pop af
	cp e
	jp nc, Jump_003_74e5

	inc hl
	ld de, hActiveEntityDrawY
	ld a, [de]
	add [hl]
	push hl
	ld hl, wSwordHitboxY
	sub [hl]
	cp $80
	jr c, jr_003_7444

	cpl
	inc a

jr_003_7444:
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxHeight]
	add [hl]
	ld e, a
	pop af
	cp e
	jp nc, Jump_003_74e5

	call ResetPegasusBoots
	ld a, $08
	ld [wLinkPushedTimer], a
	ld a, $12
	call Call_03_7569
	ld a, $18
	call Call_03_7E17
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], a
	call Call_03_73DF
	ld [hl], $08
	xor a
	ld [wSwordCharge], a
	call StartClinkTimer
	ld hl, wSpinAttackTimer
	ld a, [wSwordAnimationStatePrev]
	or [hl]
	jr z, jr_003_748f

	ld a, $0c
	ld [wSwordPokeTimer], a

jr_003_748f:
	ldh a, [hActiveEntityType]
	cp $be
	jr nz, jr_003_74c5

	ld a, $09
	ldh [hJingle], a
	ld a, [wEvilEagleAttack]
	cp $00
	jr z, jr_003_74c3

	cp $01
	jr z, jr_003_74b9

	cp $04
	jr z, jr_003_74b9

	cp $03
	jp z, Jump_003_7575

	ld a, $20
	ld [wLinkPushedTimer], a
	ld a, $20
	call Call_03_7569
	jr jr_003_74e0

jr_003_74b9:
	ld a, $10
	ld [wLinkPushedTimer], a
	ld a, $20
	call Call_03_7569

jr_003_74c3:
	jr jr_003_74e0

jr_003_74c5:
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $74e8
	add hl, de
	ld a, [wSwordHitboxX]
	add [hl]
	ldh [hMultiPurpose0], a
	ld hl, $74ec
	add hl, de
	ld a, [wSwordHitboxY]
	add [hl]
	ldh [hMultiPurpose1], a
	call AddClinkVfx

jr_003_74e0:
	ld a, $0c
	ldh [$ffb6], a
	ret


Jump_003_74e5:
	jp Jump_003_74f0


	db $00, $f0, $f8, $fc, $fc, $fc, $f0, $00

Jump_003_74f0:
	ldh a, [hFrameCounter]
	xor c
	rra
	jr nc, jr_003_7574

	ldh a, [hLinkX]
	add $08
	ldh [hMultiPurpose0], a
	ldh a, [hLinkY]
	add $08
	ldh [hMultiPurpose2], a
	ld de, hActiveEntityX
	ld hl, wClashBoxX
	ld a, [de]
	add [hl]
	push hl
	ld hl, hMultiPurpose0
	sub [hl]
	cp $80
	jr c, jr_003_7515

	cpl
	inc a

jr_003_7515:
	pop hl
	push af
	inc hl
	ld a, $04
	add [hl]
	ld e, a
	pop af
	cp e
	jr nc, jr_003_7574

	inc hl
	ld de, hActiveEntityDrawY
	ld a, [de]
	add [hl]
	push hl
	ld hl, hMultiPurpose2
	sub [hl]
	cp $80
	jr c, jr_003_7531

	cpl
	inc a

jr_003_7531:
	pop hl
	push af
	inc hl
	ld a, $05
	add [hl]
	ld e, a
	pop af
	cp e
	jr nc, jr_003_7574

	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_003_7574

	call Call_03_6CF1
	ldh a, [hActiveEntityType]
	cp $be
	jr nz, jr_003_7574

	ld a, [wEvilEagleAttack]
	and a
	jr z, jr_003_7574

	cp $01
	jr z, jr_003_7574

	cp $04
	jr z, jr_003_7574

	cp $02
	jr nz, jr_003_7575

	call GetEntityTimer1
	ld [hl], $a0
	ld a, $20
	ld [wLinkPushedTimer], a
	ld a, $30

Call_03_7569::
	call Call_03_7E17
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a

jr_003_7574:
	ret


Jump_003_7575:
jr_003_7575:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $22
	jr c, jr_003_7574

	ld a, $0a
	ld [wLinkMotionState], a
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $30
	jr z, jr_003_758f

	ld a, $d0

jr_003_758f:
	ldh [hLinkSpeedX], a
	xor a
	ldh [hLinkSpeedY], a
	ld a, $30
	ldh [hLinkSpeedZ], a
	ld a, $0b
	ldh [hJingle], a
	ret


	db $3e, $20, $ea, $3e, $c1, $3e, $20, $18, $c3

Call_03_75A6::
	ld e, $0f
	ld d, $00

Jump_003_75aa:
	ld a, e
	cp c
	jp z, Jump_003_779d

	ldh a, [hFrameCounter]
	xor e
	and $01
	jp nz, Jump_003_779d

	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jp c, Jump_003_779d

	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $40
	jp nz, Jump_003_779d

	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $0c
	cp $18
	jp nc, Jump_003_779d

	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, de
	sub [hl]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $0c
	cp $18
	jp nc, Jump_003_779d

	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [hl]
	cp $ff
	jp z, Jump_003_779d

	ldh a, [hActiveEntityType]
	cp $55
	jr nz, jr_003_7602

	call GetEntityTimer
	ld [hl], b

jr_003_7602:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $55
	jr nz, jr_003_7634

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
	ld hl, wEntityState
	add hl, de
	ld [hl], $02
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $08
	jp Jump_003_779d


jr_003_7634:
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $20
	jp nz, Jump_003_7719

	ldh a, [hActiveEntityType]
	cp $08
	jr z, jr_003_766c

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $e6
	jr nz, jr_003_765a

	ld a, [wFinalNightmareForm]
	cp $05
	jr nz, jr_003_765a

	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nz, jr_003_7663

jr_003_765a:
	ld hl, wEntityHitboxFlags
	add hl, de
	ld a, [hl]
	and $80
	jr z, jr_003_766c

Jump_003_7663:
jr_003_7663:
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $01
	jp Jump_003_773b


jr_003_766c:
	ldh a, [hActiveEntityType]
	cp $08
	jr nz, jr_003_76b0

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $ca
	jr nz, jr_003_7684

	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_003_76b0

	inc [hl]

jr_003_7684:
	cp $3f
	jr nz, jr_003_76b0

	ld a, [wIsIndoor]
	and a
	jr nz, jr_003_76b0

	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_003_76b0

	inc [hl]
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $7f
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $10
	ld a, $03
	ld [wCurrentBank], a
	call ResetSoundEngine
	ld a, $18
	ld [wCurrentBank], a

jr_003_76b0:
	ld hl, wEntityHitboxFlags
	add hl, de
	ld a, [hl]
	and $80
	jp nz, Jump_003_779d

	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld a, [hl]
	and a
	jp nz, Jump_003_779d

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $24
	jr nz, jr_003_7714

	ld hl, wEntityDirection
	add hl, de
	ld a, [hl]
	xor $01
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr nz, jr_003_7714

	ld hl, wEntityPrivate2
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_003_7714

	ldh a, [hActiveEntityType]
	cp $03
	jp nz, Jump_003_7663

	ld [hl], $01
	push de
	ld a, $32
	call SpawnEntity_03
	jr c, jr_003_7711

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate5
	add hl, de
	ld a, c
	inc a
	ld [hl], a
	ldh a, [hMultiPurpose2]
	and $01
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a

jr_003_7711:
	pop de
	jr jr_003_773b

jr_003_7714:
	call Call_03_77A5
	jr jr_003_773b

Jump_003_7719:
	ldh a, [hActiveEntityType]
	cp $01
	jr z, jr_003_7723

	cp $03
	jr nz, jr_003_7738

jr_003_7723:
	call GetEntityTimer
	xor a
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $20
	jr z, jr_003_773b

	ld a, c
	inc a
	ld hl, wEntityPrivate5
	add hl, de
	ld [hl], a

jr_003_7738:
	jp Jump_003_779d


Jump_003_773b:
jr_003_773b:
	ldh a, [hActiveEntityType]
	cp $a8
	jr z, jr_003_775e

	cp $01
	jr z, jr_003_7798

	cp $03
	jr z, jr_003_7798

	cp $05
	jr nz, jr_003_7755

	push de
	call BreakThrownObject
	pop de
	jp Jump_003_779d


jr_003_7755:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_003_7780

jr_003_775e:
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_779d

	ld [hl], $0c
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	sra [hl]
	ld a, [hl]
	cpl
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
	sra [hl]
	ld a, [hl]
	cpl
	ld [hl], a
	jr jr_003_7798

jr_003_7780:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_7798

	ldh a, [hActiveEntityType]
	cp $00
	jr nz, jr_003_7793

	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_003_7796

jr_003_7793:
	call Call_3FB7

jr_003_7796:
	jr jr_003_779d

jr_003_7798:
	call GetEntityTimer
	xor a
	ld [hl], a

Jump_003_779d:
jr_003_779d:
	dec e
	ld a, e
	cp $ff
	jp nz, Jump_003_75aa

	ret


Call_03_77A5::
	ldh a, [hActiveEntityType]
	cp $00
	jr nz, jr_003_77b6

	ldh a, [hActiveEntityState]
	and a
	jr z, jr_003_77b6

	call GetEntityTimer
	ld [hl], $03
	ret


jr_003_77b6:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityRecoilSpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityRecoilSpeedY
	add hl, de
	ld [hl], a
	push bc
	push de
	pop bc
	push de
	call Call_03_77D4
	pop de
	pop bc
	ret


Call_03_77D4::
	call Call_03_71C4
	ret


Call_03_77D8::
	ld e, $0f
	ld d, $00

jr_003_77dc:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr c, jr_003_7833

	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $60
	jr nz, jr_003_7833

	ld hl, wEntityHitboxFlags
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_003_7833

	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $18
	cp $30
	jr nc, jr_003_7833

	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, de
	sub [hl]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $18
	cp $30
	jr nc, jr_003_7833

	ld a, $07
	ld [wProjectileWeaponType], a
	call Call_03_77A5
	ld a, $30
	call Call_03_783A
	ld hl, wEntityRecoilSpeedY
	add hl, de
	ldh a, [hMultiPurpose0]
	ld [hl], a
	ld hl, wEntityRecoilSpeedX
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hl], a

jr_003_7833:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_003_77dc

	ret


Call_03_783A::
	ldh [hMultiPurpose0], a
	ldh a, [hLinkX]
	push af
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
	ldh a, [hLinkY]
	push af
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
	push de
	ldh a, [hMultiPurpose0]
	call Call_03_7E17
	pop de
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	ret


	db $0d, $02, $08, $08, $0a, $06, $08, $08, $10, $ff, $08, $08, $0d, $02, $08, $08
	db $08, $08, $02, $0d, $08, $08, $06, $0a, $08, $08, $ff, $10, $08, $08, $02, $0d
	db $01, $02, $04, $08, $00, $00, $ff, $01, $01, $ff, $01, $ff, $01, $ff, $00, $00
	db $01, $01, $ff, $ff

Call_03_7892::
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	xor a
	ld [hl], a
	ldh [hMultiPurpose1], a
	ld [$c503], a
	ld [$c50d], a
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, jr_003_78b0

	and a
	jp nz, Jump_003_7a17

jr_003_78b0:
	ld hl, $c4f0
	add hl, bc
	ld [hl], b
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	bit 4, a
	jp nz, Jump_003_7a17

	call Call_03_7DE0
	jr jr_003_78e2

jr_003_78c4:
	ld e, $02
	ldh a, [hActiveEntityType]
	cp $cc
	jr z, jr_003_7906

	cp $a0
	jr z, jr_003_7906

	cp $d5
	jr z, jr_003_7906

	cp $6d
	jr z, jr_003_7906

	cp $c1
	jr z, jr_003_7906

	call Call_3FB7
	jp Jump_003_795b


jr_003_78e2:
	ld e, $01
	ldh a, [hRoomObjectType]
	cp $67
	jr z, jr_003_7906

	ldh a, [hMultiPurpose3]
	and a
	jp z, Jump_003_7a17

	cp $0b
	jr z, jr_003_78c4

	cp $07
	jr z, jr_003_78c4

	cp $b0
	jr z, jr_003_7906

	inc e
	cp $05
	jr z, jr_003_7906

	cp $06
	jr nz, jr_003_790b

	inc e

jr_003_7906:
	ld hl, wEntityGroundStatus
	add hl, bc
	ld [hl], e

jr_003_790b:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $08
	jr z, jr_003_7972

	ld hl, wEntityGroundStatus
	add hl, bc
	ldh a, [hMultiPurpose0]
	cp [hl]
	jr z, jr_003_7972

	ld a, [hl]
	cp $03
	jr z, jr_003_7972

	ldh a, [hMultiPurpose0]
	cp $03
	jr z, jr_003_7972

	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_003_793c

	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_003_7972

	cp $e7
	jr nc, jr_003_7972

	jr jr_003_7953

jr_003_793c:
	ldh a, [hActiveEntityType]
	cp $ac
	jr z, jr_003_7953

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, jr_003_7953

	ld [hl], $00
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]

jr_003_7953:
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_7972

Jump_003_795b:
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
	ld a, $0e
	ldh [hJingle], a
	ld a, $01
	call AddTransientVfx

jr_003_7972:
	ldh a, [hMultiPurpose3]
	inc a
	cp $f1
	jr c, jr_003_799b

	sub $f1
	ld e, a
	ld d, b
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_003_7999

	ld hl, $7882
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $788a
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	add [hl]
	ld [hl], a

jr_003_7999:
	jr jr_003_7a17

jr_003_799b:
	ldh a, [hRoomObjectType]
	cp $61
	jr z, jr_003_79ab

	ldh a, [hMultiPurpose3]
	cp $50
	jr z, jr_003_79ab

	cp $51
	jr nz, jr_003_7a17

jr_003_79ab:
	ldh a, [hActiveEntityType]
	cp $6d
	jr z, jr_003_7a17

	cp $d5
	jr z, jr_003_7a17

	cp $36
	jr z, jr_003_7a17

	cp $c1
	jr nz, jr_003_79ca

	ld a, [wLinkMotionState]
	cp $06
	jr nz, jr_003_7a17

	ldh a, [hRoomObjectType]
	cp $61
	jr nz, jr_003_7a17

jr_003_79ca:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7a17

	dec [hl]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $00
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $02
	ldh a, [hBGPosX]
	add $08
	ld hl, wEntityPitX
	add hl, bc
	ld [hl], a
	ldh a, [hBGPosY]
	add $10
	ld hl, wEntityPitY
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	ld [hl], $6f
	ldh a, [hActiveEntityType]
	cp $14
	jr z, jr_003_7a17

	cp $0b
	jr z, jr_003_7a17

	cp $09
	jr z, jr_003_7a17

	ld [hl], $48
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_003_7a17

	call GetEntityTimer
	ld [hl], $2f
	ld a, $18
	ldh [hJingle], a

Jump_003_7a17:
jr_003_7a17:
	ldh a, [hActiveEntityType]
	cp $6d
	jp z, Jump_003_7a83

	xor a
	ld [$c503], a
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld a, [hl]
	and $03
	sla a
	sla a
	ldh [hMultiPurpose0], a
	ld hl, wEntityCollisions
	add hl, bc
	xor a
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cp $00
	jr z, jr_003_7a5c

	ld de, $0000
	and $80
	jr z, jr_003_7a46

	inc e

jr_003_7a46:
	call Call_03_7ACC
	jr c, jr_003_7a5c

	ldh a, [hRoomObjectType]
	ld [$c503], a
	ldh a, [$ffbe]
	and a
	jr nz, jr_003_7a5c

	ld hl, wEntityX
	add hl, bc
	ldh a, [hActiveEntityX]
	ld [hl], a

jr_003_7a5c:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $00
	jr z, jr_003_7a83

	ld de, $0002
	and $80
	jr nz, jr_003_7a6d

	inc e

jr_003_7a6d:
	call Call_03_7ACC
	jr c, jr_003_7a83

	ldh a, [hRoomObjectType]
	ld [$c50d], a
	ldh a, [$ffbe]
	and a
	jr nz, jr_003_7a83

	ld hl, wEntityY
	add hl, bc
	ldh a, [hActiveEntityY]
	ld [hl], a

Jump_003_7a83:
jr_003_7a83:
	ret


	db $01, $00, $01, $00, $00, $01, $00, $01, $01, $01, $00, $00, $00, $00, $01, $01
	db $01, $00, $01, $00, $00, $01, $00, $01, $01, $01, $00, $00, $00, $00, $01, $01
	db $00, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00
	db $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $01
	db $00, $01, $01, $00, $01, $00, $00, $01

Call_03_7ACC::
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
	push af
	ldh a, [hMultiPurpose0]
	ld c, a
	pop af
	ld hl, $785e
	add hl, bc
	add hl, de
	add [hl]
	ldh [hMultiPurpose4], a
	swap a
	and $0f
	ldh [hMultiPurpose1], a
	pop bc
	push bc
	ld a, e
	cp $03
	jr nz, jr_003_7b0d

	ldh a, [hActiveEntityType]
	cp $a8
	jr z, jr_003_7af8

	cp $05
	jr nz, jr_003_7b0d

jr_003_7af8:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld c, [hl]
	bit 7, c
	jr z, jr_003_7b08

	ld c, $00

jr_003_7b08:
	srl c
	sub c
	jr jr_003_7b12

jr_003_7b0d:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]

jr_003_7b12:
	sub $10
	push af
	ldh a, [hMultiPurpose0]
	ld c, a
	pop af
	ld hl, $786e
	add hl, bc
	add hl, de
	add [hl]
	ldh [hMultiPurpose5], a
	and $f0
	ld hl, hMultiPurpose1
	or [hl]
	ld c, a
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
	ld a, [hl]
	ldh [hRoomObjectType], a
	cp $20
	jp z, Jump_003_7c7a

	push de
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysicsBank3
	pop de
	ldh [hMultiPurpose3], a
	ldh a, [hActiveEntityType]
	cp $cc
	jr z, jr_003_7b4d

	cp $99
	jr nz, jr_003_7b5c

jr_003_7b4d:
	ldh a, [hMultiPurpose3]
	cp $05
	jp z, Jump_003_7ca6

	cp $07
	jp z, Jump_003_7ca6

	jp Jump_003_7c74


jr_003_7b5c:
	ldh a, [hMultiPurpose3]
	and a
	jp z, Jump_003_7ca6

	cp $0b
	jr z, jr_003_7b6e

	cp $50
	jr z, jr_003_7b6e

	cp $51
	jr nz, jr_003_7b8a

jr_003_7b6e:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_003_7ca6

	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_003_7c74

	ldh a, [hActiveEntityType]
	cp $59
	jp z, Jump_003_7c74

	jp Jump_003_7ca6


jr_003_7b8a:
	cp $7c
	jp c, Jump_003_7be3

	cp $90
	jp nc, Jump_003_7be3

	cp $80
	ldh a, [hActiveEntityType]
	jr c, jr_003_7ba6

	cp $a8
	jp z, Jump_003_7ca6

	cp $02
	jp z, Jump_003_7ca6

	jr jr_003_7bba

jr_003_7ba6:
	cp $16
	jp z, Jump_003_7c99

	cp $17
	jp z, Jump_003_7c99

	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, Jump_003_7c99

jr_003_7bba:
	push de
	ldh a, [hMultiPurpose3]
	sub $7c
	sla a
	sla a
	ld e, a
	ld d, $00
	ld hl, $7a84
	add hl, de
	ldh a, [hMultiPurpose4]
	rra
	rra
	rra
	and $01
	ld e, a
	ldh a, [hMultiPurpose5]
	rra
	rra
	and $02
	or e
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	pop de
	and a
	jp z, Jump_003_7ca6

Jump_003_7be3:
	ldh a, [hMultiPurpose3]
	cp $d0
	jr c, jr_003_7c2a

	cp $d4
	jr nc, jr_003_7c2a

	sub $d0
	ld hl, $c5d0
	add hl, bc
	cp [hl]
	jr z, jr_003_7c19

	ldh a, [hActiveEntityType]
	cp $a8
	jr z, jr_003_7c74

	ld hl, $c4f0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7c74

	ldh a, [hFrameCounter]
	and $03
	jr z, jr_003_7c27

	ld a, [wIsIndoor]
	and a
	jr nz, jr_003_7c16

	ldh a, [hFrameCounter]
	and $01
	jr z, jr_003_7c27

jr_003_7c16:
	dec [hl]
	jr jr_003_7c27

jr_003_7c19:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_003_7c74

	ld hl, $c4f0
	add hl, bc
	inc [hl]

jr_003_7c27:
	jp Jump_003_7ca6


jr_003_7c2a:
	cp $ff
	jr z, jr_003_7c99

	cp $a0
	jr nc, jr_003_7ca6

	cp $10
	jr nc, jr_003_7c74

	cp $01
	jr z, jr_003_7c90

	cp $03
	jr z, jr_003_7c90

	cp $04
	jr nz, jr_003_7ca6

	ldh a, [hActiveEntityType]
	cp $a8
	jp z, Jump_003_7ca6

	cp $02
	jp z, Jump_003_7ca6

	cp $03
	jr nz, jr_003_7c59

	ld a, [wLinkOnRaisedBlock]
	and a
	jp nz, Jump_003_7ca6

jr_003_7c59:
	ldh a, [hRoomObjectType]
	cp $db
	jr c, jr_003_7c99

	cp $dd
	jr nc, jr_003_7c99

	push de
	sub $db
	ld e, a
	ld d, $00
	ld hl, $7ca8
	add hl, de
	pop de
	ld a, [wRaisedBlocksState]
	xor [hl]
	jr z, jr_003_7ca6

Jump_003_7c74:
jr_003_7c74:
	ldh a, [hMultiPurpose3]
	cp $60
	jr nz, jr_003_7c90

Jump_003_7c7a:
	ldh a, [hActiveEntityType]
	cp $03
	jr nz, jr_003_7c90

	call GetEntityTimer
	cp $26
	jr c, jr_003_7c8a

	call Call_3FB7

jr_003_7c8a:
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01

jr_003_7c90:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $01
	jr nz, jr_003_7ca6

Jump_003_7c99:
jr_003_7c99:
	ld hl, $787e
	add hl, de
	ld a, [hl]
	ld hl, wEntityCollisions
	add hl, bc
	or [hl]
	ld [hl], a
	and a
	ret


Jump_003_7ca6:
jr_003_7ca6:
	scf
	ret


	db $00, $02

Call_03_7CAA::
	ld de, $0000
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose4], a
	and $f0
	ldh [hBGPosX], a
	swap a
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $08
	ldh [hMultiPurpose5], a
	and $f0
	ldh [hBGPosY], a
	or c
	ld c, a
	ldh [hMultiPurposeH], a
	ld b, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
	ld a, [hl]
	ldh [hRoomObjectType], a
	cp $ac
	jp z, Jump_003_7dd5

	cp $ab
	jr nz, jr_003_7d3d

	ldh a, [hActiveEntityType]
	cp $04
	jr nz, jr_003_7d3d

	ld a, [wIsIndoor]
	and a
	jr z, jr_003_7d3d

	push hl
	ld a, $12
	ldh [hNoiseSfx], a
	ld a, $08
	call SpawnEntity_03
	jr c, jr_003_7d3c

	pop hl
	ld [hl], $ac
	push bc
	push de
	pop bc
	ld d, h
	ld e, l
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], d
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], e
	ldh a, [hBGPosX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ldh a, [hBGPosY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
	call GetEntityDropTimer
	ld [hl], $80
	pop bc
	ld hl, wRoomEventCounter
	inc [hl]
	ld a, [wRoomDarkness]
	and a
	jr z, jr_003_7d35

	sub $04
	ld [wRoomDarkness], a

jr_003_7d35:
	ld de, $69bd
	push de
	jp DrawRoomObjectTiles


jr_003_7d3c:
	pop hl

jr_003_7d3d:
	ld a, [hl]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysicsBank3
	ldh [hMultiPurpose1], a
	and a
	jp z, Jump_003_7dd5

	ldh [hMultiPurpose3], a
	cp $ff
	jp z, Jump_003_7dd7

	cp $d0
	jr c, jr_003_7d92

	cp $d4
	jr nc, jr_003_7d92

	sub $d0
	ld hl, $c5d0
	add hl, bc
	cp [hl]
	jr z, jr_003_7d82

	ld hl, $c4f0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7db5

	ldh a, [hFrameCounter]
	and $03
	jr z, jr_003_7dd5

	ld a, [wIsIndoor]
	and a
	jr nz, jr_003_7d7e

	ldh a, [hFrameCounter]
	and $01
	jr z, jr_003_7dd5

jr_003_7d7e:
	dec [hl]
	jp Jump_003_7dd5


jr_003_7d82:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7db5

	ld hl, $c4f0
	add hl, bc
	inc [hl]
	jp Jump_003_7dd5


jr_003_7d92:
	cp $7c
	jp c, Jump_003_7d9f

	cp $90
	jp nc, Jump_003_7d9f

	jp Jump_003_7dd5


Jump_003_7d9f:
	ldh a, [hMultiPurpose3]
	cp $a0
	jr nc, jr_003_7dd5

	cp $50
	jr z, jr_003_7dd5

	cp $51
	jr z, jr_003_7dd5

	cp $10
	jr nc, jr_003_7db5

	cp $01
	jr nz, jr_003_7dd5

jr_003_7db5:
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $01
	ldh a, [hActiveEntityType]
	cp $01
	jr nz, jr_003_7dc5

	call GetEntityTimer
	ret z

jr_003_7dc5:
	ld hl, wEntityX
	add hl, bc
	ldh a, [hActiveEntityX]
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	ldh a, [hActiveEntityY]
	ld [hl], a
	scf
	ret


Jump_003_7dd5:
jr_003_7dd5:
	and a
	ret


Jump_003_7dd7:
	ldh a, [hActiveEntityType]
	cp $01
	jr z, jr_003_7db5

	jp Call_3FB7


Call_03_7DE0::
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $01
	ldh [hMultiPurpose4], a
	and $f0
	ldh [hBGPosX], a
	swap a
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $07
	ldh [hMultiPurpose5], a
	and $f0
	ldh [hBGPosY], a
	or c
	ld c, a
	ld b, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
	ld a, [hl]
	ldh [hRoomObjectType], a
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysicsBank3
	ldh [hMultiPurpose3], a
	ret


Call_03_7E17::
	ldh [hMultiPurpose1], a
	and a
	jp z, Jump_003_7e95

	call GetEntityYDistanceToLink_03
	dec e
	dec e
	ld a, e
	ldh [hMultiPurpose2], a
	ld a, d
	bit 7, a
	jr z, jr_003_7e2c

	cpl
	inc a

jr_003_7e2c:
	ldh [hMultiPurposeC], a
	call GetEntityXDistanceToLink_03
	ld a, e
	ldh [hMultiPurpose3], a
	ld a, d
	bit 7, a
	jr z, jr_003_7e3b

	cpl
	inc a

jr_003_7e3b:
	ldh [hMultiPurposeD], a
	ld e, $00
	ld hl, hMultiPurposeC
	ldh a, [hMultiPurposeD]
	cp [hl]
	jr nc, jr_003_7e50

	inc e
	push af
	ldh a, [hMultiPurposeC]
	ldh [hMultiPurposeD], a
	pop af
	ldh [hMultiPurposeC], a

jr_003_7e50:
	xor a
	ldh [hMultiPurposeB], a
	ldh [hMultiPurpose0], a
	ldh a, [hMultiPurpose1]
	ld d, a

jr_003_7e58:
	ldh a, [hMultiPurposeB]
	ld hl, hMultiPurposeC
	add [hl]
	jr c, jr_003_7e66

	ld hl, hMultiPurposeD
	cp [hl]
	jr c, jr_003_7e6b

jr_003_7e66:
	sub [hl]
	ld hl, hMultiPurpose0
	inc [hl]

jr_003_7e6b:
	ldh [hMultiPurposeB], a
	dec d
	jr nz, jr_003_7e58

	ld a, e
	and a
	jr z, jr_003_7e7e

	ldh a, [hMultiPurpose0]
	push af
	ldh a, [hMultiPurpose1]
	ldh [hMultiPurpose0], a
	pop af
	ldh [hMultiPurpose1], a

jr_003_7e7e:
	ldh a, [hMultiPurpose2]
	and a
	ldh a, [hMultiPurpose0]
	jr nz, jr_003_7e89

	cpl
	inc a
	ldh [hMultiPurpose0], a

jr_003_7e89:
	ldh a, [hMultiPurpose3]
	and a
	ldh a, [hMultiPurpose1]
	jr z, jr_003_7e94

	cpl
	inc a
	ldh [hMultiPurpose1], a

jr_003_7e94:
	ret


Jump_003_7e95:
	xor a
	ldh [hMultiPurpose0], a
	ret


Call_03_7E99::
	call Call_03_7E17
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ret


GetEntityXDistanceToLink_03::
	ld e, $00
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_003_7eb9

	inc e

jr_003_7eb9:
	ld d, a
	ret


GetEntityYDistanceToLink_03::
	ld e, $02
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
	ld hl, wEntityZ
	add hl, bc
	add [hl]
	bit 7, a
	jr nz, jr_003_7ece

	inc e

jr_003_7ece:
	ld d, a
	ret


GetEntityDirectionToLink_03::
	call GetEntityXDistanceToLink_03
	ld a, e
	ldh [hMultiPurpose0], a
	ld a, d
	bit 7, a
	jr z, jr_003_7edd

	cpl
	inc a

jr_003_7edd:
	push af
	call GetEntityYDistanceToLink_03
	ld a, e
	ldh [hMultiPurpose1], a
	ld a, d
	bit 7, a
	jr z, jr_003_7eeb

	cpl
	inc a

jr_003_7eeb:
	pop de
	cp d
	jr nc, jr_003_7ef3

	ldh a, [hMultiPurpose0]
	jr jr_003_7ef5

jr_003_7ef3:
	ldh a, [hMultiPurpose1]

jr_003_7ef5:
	ld e, a
	ret


UpdateEntityPosWithSpeed_03::
	call AddEntitySpeedToPos_03
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPos_03
	pop bc
	ret


AddEntitySpeedToPos_03::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7f2f

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityX

jr_003_7f1c:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_003_7f26

	ld e, $f0

jr_003_7f26:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_003_7f2f:
	ret


AddEntityZSpeedToPos_03::
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7f2f

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityZ
	jr jr_003_7f1c

ReturnIfNonInteractive_03::
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, jr_003_7f6a

ReturnIfGameFrozen_03::
	ld a, [wGameplayType]
	cp $07
	jr z, jr_003_7f6a

	ld a, [wDialogState]
	ld hl, wLinkShowItemPoseActive
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, jr_003_7f6a

	ld a, [wRoomTransitionState]
	and a
	jr z, jr_003_7f6b

jr_003_7f6a:
	pop af

jr_003_7f6b:
	ret


ApplyRecoilIfNeeded_03::
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_003_7fb8

	dec a
	ld [hl], a
	call Call_3EB8
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call UpdateEntityPosWithSpeed_03
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_003_7fa8

	call Call_03_7892

jr_003_7fa8:
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
	pop af
	call Call_3ED9

jr_003_7fb8:
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff
