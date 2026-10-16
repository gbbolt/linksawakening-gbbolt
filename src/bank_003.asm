; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

;@ path: entity/types
;@ ROM bank of each entity type's handler: one byte per type $00-$E8 (233 bytes). UpdateEntity
;@ (bank 0) switches to this bank before calling the type's entry of EntityHandlers. Banks used: 3,
;@ 4, 5, 6, 7, $15, $17, $18, $19.
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

;@ path: entity/types
;@ Initial wEntityPhysicsFlags of each entity type $00-$E8 (233 bytes; copied by
;@ ReloadEntityProperties). Bits: 7 = touching it does not hurt Link (EntityHitsLink), 6 = other
;@ entities' weapons do not hit it (EntityHitOtherEntities_03, BombHitsEntities), 5 = a pickup: the
;@ sword collects it and the boomerang or hookshot catches it, 4 = it casts a shadow; bits 0-3 =
;@ the number of OAM sprites it uses.
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

;@ path: entity/types
;@ Initial wEntityHitboxFlags of each entity type $00-$E8 (233 bytes). Bits 0-1: size class for
;@ the wall probes (WallProbeOffsetsX/Y); bits 2-6: hitbox number in EntityHitboxTable (bank 0, 4
;@ bytes each: x offset, half width, y offset, half height; LoadEntityHitbox copies it to
;@ wEntityHitbox); bit 7: weapon entities bounce off it instead of hitting it.
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

;@ path: entity/types
;@ Health group of each entity type $00-$E8 (233 bytes, 0-$30), copied to wEntityHealthGroup. The
;@ group picks the starting health (EntityHealthTable), the damage done to Link by touching it
;@ (EntityContactDamageTable), the row of EntityDamageClassTable (how each weapon hurts it) and the
;@ drop class (EntityDropClassTable).
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

;@ path: entity/types
;@ Initial wEntityOptions1 of each entity type $00-$E8 (233 bytes). Bits: 0 = passes through soft
;@ walls (EntityCheckWallAt), 1 = not an enemy (does not count for "all enemies defeated"; a fall
;@ into a pit is not remembered), 2 = a mini-boss (mini-boss music $50; the dungeon bosses lack it and get $19), 3 = splashes when it lands
;@ on other ground, 4 = ignores the ground under it (water, pits, conveyors), 5 = walls do not stop
;@ its recoil, 6 = sword-proof (the sword clinks off), 7 = boss or mini-boss (boss music, does not
;@ come back, runs its own death code).
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

;@ path: entity/damage
;@ Damage class of each health group against each weapon: 49 rows (health group 0-$30) of 16 bytes
;@ (weapon = wProjectileWeaponType 0-$0F: 0-2 the sword by strength, 5 arrow, 6 hookshot, 7 bomb,
;@ 8 boomerang, 9 magic powder, $0A Magic Rod, $0B thrown object, $0C bomb arrow; 3, 4 and $0D-$0F
;@ are not used). The class (0-5) selects the column of WeaponDamageTable; read by ApplyWeaponHit.
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

;@ path: entity/damage
;@ What a weapon does to a damage class: 16 rows (weapon 0-$0F, as in EntityDamageClassTable) of 8
;@ bytes (class 0-7). 0 = nothing, $01-$EF = health taken from wEntityHealth ($40 always kills),
;@ $FD = turns into a fairy, $FE = burns, $FF = stunned. Class 0 is immune to everything. Read by
;@ ApplyWeaponHit.
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

;@ path: entity/damage
;@ Starting health (wEntityHealth) of each health group 0-$30 (49 bytes), set by InitEntityHealth.
EntityHealthTable::
	db $01, $02, $02
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $0c, $3f, $08
	db $08, $08, $0c, $00, $00, $04, $06, $08, $0a, $04, $14, $0a, $18, $04, $02, $08
	db $08, $02, $04, $ff, $00, $02, $04, $02, $03, $01, $01, $08, $06, $02

;@ path: entity/damage
;@ Damage done to Link by touching an entity, by health group 0-$30 (49 bytes), in eighths of a
;@ heart (8 = one heart; added to wSubtractHealthBuffer by HurtLink; halved by the Guardian Acorn).
EntityContactDamageTable::
	db $04, $04
	db $08, $08, $18, $08, $04, $08, $10, $08, $10, $08, $08, $04, $08, $08, $08, $08
	db $08, $08, $08, $0c, $00, $00, $08, $08, $08, $0c, $0c, $14, $10, $20, $08, $08
	db $04, $04, $04, $04, $04, $00, $14, $08, $04, $08, $04, $04, $08, $08, $04

;@ path: entity/drops
;@ Drop class of each health group 0-$30 (49 bytes): 0 = drops nothing, 1-$0E pick a line of
;@ DropItemByClass / the chances in DropDefeatedEntityItem.
EntityDropClassTable::
	db $02
	db $06, $01, $03, $03, $03, $0d, $08, $0a, $02, $07, $0b, $00, $04, $00, $08, $04
	db $0e, $0e, $0e, $0e, $0e, $00, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
	db $02, $00, $00, $02, $00, $00, $00, $00, $06, $06, $0d, $0e, $00, $09, $03, $06

;@ def InitEntityProperties(slot: bc)
;@ path: entity/spawn
;@ Gives a fresh entity slot the defaults of its type: clears its variables, remembers the room it was
;@ loaded in, then loads the type's properties (ReloadEntityProperties).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
InitEntityProperties::
;> ResetEntityVariablesFrom3(slot)  # clears speeds, state, private variables and timers of the slot (code in bank $15)
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
;@ def ReloadEntityProperties(slot: bc)
;@ path: entity/spawn
;@ Copies physics flags, hitbox, health and option flags of the slot's current type from the per-type
;@ tables. Also used when an entity turns into another type (a burnt Gibdo becomes a Stalfos).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ReloadEntityProperties::
;> type = wEntityType[slot]
	ld hl, wEntityType
	add hl, bc
	ld e, [hl]
	ld d, b
;> wEntityPhysicsFlags[slot] = mem[EntityPhysicsFlagsTable + type]
	ld hl, EntityPhysicsFlagsTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], a
;> wEntityHitboxFlags[slot] = mem[EntityHitboxFlagsTable + type]
	ld hl, EntityHitboxFlagsTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], a
;> InitEntityHealth(slot, type)
	call InitEntityHealth
;> wEntityOptions1[slot] = mem[EntityOptionsTable + type]
	ld hl, EntityOptionsTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], a
;> return LoadEntityHitbox(slot)  # copies the hitbox chosen by wEntityHitboxFlags into the slot's hitbox
	jp LoadEntityHitbox


;@ def InitEntityHealth(slot: bc, type: de)
;@ path: entity/spawn
;@ Sets the entity's health group from its type and its starting health from the group.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
InitEntityHealth::
;> group = mem[EntityHealthGroupTable + type]
	push de
	ld hl, EntityHealthGroupTable
	add hl, de
	ld e, [hl]
;> wEntityHealthGroup[slot] = group
	ld hl, wEntityHealthGroup
	add hl, bc
	ld [hl], e
;> health = mem[EntityHealthTable + group]
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


;@ def CancelMiniBossAndDespawn(slot: bc)
;@ path: entity/status
;@ Removes a mini-boss that must not appear yet and marks the room's event as done, so the room acts
;@ as cleared (its shutters stay open).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
CancelMiniBossAndDespawn::
;> wRoomEventDone = 1
	ld a, $01
	ld [wRoomEventDone], a
;> return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot


;@ def EntityStatusInitHandler(slot: bc)
;@ path: entity/status
;@ Status 4: the first frame of a freshly loaded entity. A boss or mini-boss (option bit 7) is not
;@ loaded again in a room where it was beaten, and it starts the boss music; Master Stalfos only
;@ shows up once the right rooms of his dungeon are done. Then the entity becomes active (status 5)
;@ and its type's init routine from EntityInitHandlers runs.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: skip runs the init handler of the entity's type from the 233-entry EntityInitHandlers table
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

;>         return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot


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
;>     if not wIsIndoor or not wEvilEagleFightStarted:
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

;@ path: entity/init
;@ The init routine of each entity type: one little-endian word per type, $00-$E8 (233 entries),
;@ indexed by the type number. EntityStatusInitHandler jumps through it (rst $00) with the slot in c, on the first
;@ frame after an entity is loaded or spawned. Most types use EntityInit_None (nothing to set up)
;@ or EntityInit_RandomDirection (start walking in a random direction); some entries point at bank
;@ 0 helpers such as IncrementEntityState or CenterEntityOnTile. Two entries (types $25 and $26) point at
;@ sprite data (BurningFlameSprites) instead of code; the table keeps them as the game has them.
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
	dw IncrementEntityState
	dw IncrementEntityState
	dw EntityInit_RandomDirection
	dw EntityInit_Wizrobe
	dw EntityInit_RandomDirection
	dw IncrementEntityState
	dw EntityInit_RandomDirection
	dw BurningFlameSprites
	dw BurningFlameSprites
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw MiniMoldormInitFar
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_DroppedItem
	dw EntityInit_PickupItem
	dw EntityInit_PickupItem
	dw EntityInit_KeyDropPoint
	dw EntityInit_Sword
	dw EntityInit_PickupItem
	dw EntityInit_PickupItem
	dw EntityInit_PickupItem
	dw EntityInit_None
	dw EntityInit_PickupItem
	dw EntityInit_PickupItem
	dw EntityInit_PickupItem
	dw EntityInit_Instrument
	dw EntityInit_None
	dw EntityInit_DroppedItem
	dw EntityInit_DroppedItem
	dw EntityInit_SecretSeashell
	dw EntityInit_Marin
	dw EntityInit_Townsperson
	dw EntityInit_Witch
	dw EntityInit_OwlEvent
	dw EntityInit_RandomDirection
	dw EntityInit_Instrument
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_ShopOwner
	dw EntityInit_RandomDirection
	dw EntityInit_GameOwner
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_GameOwner
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw MoldormInitFar
	dw FacadeInitFar
	dw SlimeEyeInitFar
	dw GenieInitFar
	dw SlimeEelInitFar
	dw EntityInit_RandomDirection
	dw EntityInit_RandomDirection
	dw DodongoSnakeInitFar
	dw EntityInit_Warp
	dw HideEntityWithFullHealthFar
	dw EvilEagleArenaSetupFar
	dw EntityInit_FaceShrineDoor
	dw AnglerRoomHelperFar
	dw EntityInit_RandomDirection
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_MovingBlockMover
	dw EntityInit_Raft
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_BowWow
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_Townsperson
	dw EntityInit_Kid71
	dw EntityInit_Kid72
	dw EntityInit_Townsperson
	dw EntityInit_Townsperson
	dw EntityInit_Townsperson
	dw EntityInit_MrWrite
	dw EntityInit_Townsperson
	dw EntityInit_None
	dw EntityInit_MadamMeowMeow
	dw EntityInit_None
	dw EntityInit_Townsperson
	dw CenterEntityOnTile
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_Telephone
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_DreamShrineBed
	dw EntityInit_BigFairy
	dw EntityInit_None
	dw EntityInit_FloatingItem
	dw EntityInit_DesertLanmola
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw CenterEntityOnTile
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_AntiKirby
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_Richard
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_HorsePiece
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_RandomDiagonal
	dw EntityInit_None
	dw EntityInit_FireballShooter
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_Snake
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_VerticalPlatform
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_Kiki
	dw EntityInit_RandomDirection
	dw EntityInit_TradingItem
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw CenterEntityOnTile
	dw EntityInit_Tarin
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_FishermanUnderBridge
	dw EntityInit_None
	dw EntityInit_Bomber
	dw EntityInit_BushCrawler
	dw CenterEntityOnTile
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_MarinAtShore
	dw EntityInit_MarinAtTalTal
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_RandomDiagonal
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_None
	dw EntityInit_FloatingItem2
	dw EntityInit_FinalNightmare
	dw EntityInit_None
	dw EntityInit_None

;@ path: entity/init
;@ Sprite variant of each Horse Piece (type $98), by its load order in the room: the two pieces of
;@ the puzzle look different. 2 bytes.
HorsePieceVariantTable::
	db $01, $04

;@ def EntityInit_HorsePiece(slot: bc)
;@ path: entity/init
;@ Init of type $98: picks the sprite variant from HorsePieceVariantTable by the piece's load order.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_HorsePiece::
;> order = wEntityLoadOrder[slot]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	ld d, b
;> return SetEntitySpriteVariant(slot, mem[HorsePieceVariantTable + order])  # sets wEntitySpriteVariant
	ld hl, HorsePieceVariantTable
	add hl, de
	ld a, [hl]
	jp SetEntitySpriteVariant

;@ def EntityInit_MarinAtTalTal(slot: bc)
;@ path: entity/init
;@ Init of type $C2: moves the entity 3 pixels up from where the room data put it.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_MarinAtTalTal::
;> wEntityY[slot] -= 3
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $03
	ld [hl], a
	ret

;@ def EntityInit_Snake(slot: bc)
;@ path: entity/init
;@ Init of type $A1: starts timer 1 at $30 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Snake::
;> wEntityTimer1[slot] = 0x30
	call GetEntityTimer1
	ld [hl], $30
	ret

;@ def EntityInit_VerticalPlatform(slot: bc)
;@ path: entity/init
;@ Init of type $A4: in room $65, a platform that starts at y $50 or below sets its private variable 1
;@ (it starts by moving the other way).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def EntityInit_Gel(slot: bc)
;@ path: entity/init
;@ Init of type $1B: gives it 2 health instead of the group's default.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Gel::
;> wEntityHealth[slot] = 2
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $02
	ret


;@ def EntityInit_MarinAtShore(slot: bc)
;@ path: entity/init
;@ Init of type $C1: Marin is not at the shore while she walks with Link or waits in Animal Village.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_MarinAtShore::
;> if wIsMarinFollowingLink | wIsMarinInAnimalVillage:
	ld hl, wIsMarinInAnimalVillage
	ld a, [wIsMarinFollowingLink]
	or [hl]
;>     return FreeEntitySlot(slot)  # frees the slot
	jp nz, FreeEntitySlot
	ret

;@ def EntityInit_Bomber(slot: bc)
;@ path: entity/init
;@ Init of type $BA: starts 16 pixels up in the air, with a random animation counter.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;> return EntityInit_BushCrawler(slot)    # (runs on into it)

;@ def EntityInit_BushCrawler(slot: c)
;@ path: entity/init
;@ Init of type $BB: nothing to do.
;@ test: slot = rand(0, 15)
EntityInit_BushCrawler::
;> return
	ret

;@ def EntityInit_Tarin(slot: bc)
;@ path: entity/init
;@ Init of type $B4: centred on its tile, sprite variant 2.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Tarin::
;> CenterEntityOnTile(slot)
	call CenterEntityOnTile
;> return SetEntitySpriteVariant(slot, 2)  # sets wEntitySpriteVariant
	ld a, $02
	jp SetEntitySpriteVariant

;@ def EntityInit_Telephone(slot: bc)
;@ path: entity/init
;@ Init of type $80: plays music $33 in the room (once Link has a sword).
;@ test: slot = rand(0, 15)
EntityInit_Telephone::
;> return PlayMusicIfLinkHasSword(0x33)
	ld a, $33
	jr PlayMusicIfLinkHasSword

;@ def EntityInit_Richard(slot: c)
;@ path: entity/init
;@ Init of type $95: plays music $40 in the room (once Link has a sword).
;@ test: slot = rand(0, 15)
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
;> hDefaultMusicTrackAlt = track
	ldh [hDefaultMusicTrackAlt], a
;> hLastMusicTrack = track
	ldh [hLastMusicTrack], a
	ret


;@ def EntityInit_FinalNightmare(slot: bc)
;@ path: entity/init
;@ Init of type $E6: starts at form 0 ($D219) and resets the sound engine.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_FinalNightmare::
;> wFinalNightmareForm = 0
	xor a
	ld [wFinalNightmareForm], a
;> ResetSoundEngine()  # resets the sound engine (bank $1F)
	call ResetSoundEngine
	ret

;@ def EntityInit_DreamShrineBed(slot: bc)
;@ path: entity/init
;@ Init of type $83: plays music $24 in the room.
;@ test: slot = rand(0, 15)
EntityInit_DreamShrineBed::
;> return PlayRoomMusic(0x24)
	ld a, $24
	jr PlayRoomMusic

;@ def EntityInit_FishermanUnderBridge(slot: bc)
;@ path: entity/init
;@ Init of type $B8: plays music $3A in the room.
;@ test: slot = rand(0, 15)
EntityInit_FishermanUnderBridge::
;> return PlayRoomMusic(0x3A)
	ld a, $3a
	jr PlayRoomMusic
;@ def EntityInit_Kiki(slot: bc)
;@ path: entity/init
;@ Init of type $AD: clears $C168 and moves the entity 4 pixels up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Kiki::
;> wMonkeysLeaving = 0
	xor a
	ld [wMonkeysLeaving], a
;> wEntityY[slot] -= 4
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	ret

;@ def EntityInit_FireballShooter(slot: bc)
;@ path: entity/init
;@ Init of type $9E: a random sprite variant (used as a random start phase).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_FireballShooter::
;> return SetEntitySpriteVariant(slot, GetRandomByte())  # wEntitySpriteVariant = random byte
	call GetRandomByte
	jp SetEntitySpriteVariant

;@ def EntityInit_AntiKirby(slot: bc)
;@ path: entity/init
;@ Init of type $91: drop timer starts at a random $10-$4F frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_AntiKirby::
;> wEntityDropTimer[slot] = (GetRandomByte() & 0x3F) + 0x10
	call GetEntityDropTimer
	call GetRandomByte
	and $3f
	add $10
	ld [hl], a
	ret

;@ def EntityInit_MovingBlockMover(slot: bc)
;@ path: entity/init
;@ Init of type $69: moves 10 pixels down and remembers that y in private variable 2.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;@ test: slot = rand(0, 15)
EntityInit_DesertLanmola::
;> hDefaultMusicTrack = 0
	xor a
	ldh [hDefaultMusicTrack], a
	ret

;@ def EntityInit_FloatingItem2(slot: bc)
;@ path: entity/init
;@ Init of type $E5: floats 19 pixels up; sprite variant 4 or 5 depending on whether it stands in the
;@ left or the right half of a 32-pixel column.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_FloatingItem2::
;> SetEntityZ13(slot)
	call SetEntityZ13
;> return SetEntitySpriteVariant(slot, 4 + ((hActiveEntityX >> 4) & 1))  # sets wEntitySpriteVariant
	ldh a, [hActiveEntityX]
	swap a
	and $01
	add $04
	jp SetEntitySpriteVariant

;@ def EntityInit_FloatingItem(slot: bc)
;@ path: entity/init
;@ Init of type $86: the sprite variant (0-3) comes from where it stands (x bit 4, y bit 4 shifted);
;@ variant 1 is not there any more once $DB4B is set. It floats 19 pixels up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;> if v == 1 and wHasToadstool:
	cp $01
	jr nz, SetEntityZ13
	ld a, [wHasToadstool]
	and a
;>     return FreeEntitySlot(slot)  # frees the slot
	jp nz, FreeEntitySlot
;> SetEntityZ13(slot)

;@ def SetEntityZ13(slot: bc)
;@ path: entity/init
;@ Puts the entity 19 pixels up in the air.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SetEntityZ13::
;> wEntityZ[slot] = 0x13
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $13
	ret

;@ def EntityInit_Kid71(slot: bc)
;@ path: entity/init
;@ Init of type $71: faces up, starts in state 1 with a $20-frame timer.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;> return EntityInit_Kid72(slot)    # (runs on into it)

;@ def EntityInit_Kid72(slot: c)
;@ path: entity/init
;@ Init of type $72: nothing to do.
;@ test: slot = rand(0, 15)
EntityInit_Kid72::
;> return
	ret

;@ def EntityInit_MrWrite(slot: bc)
;@ path: entity/init
;@ Init of type $76: plays music $37 in room $D9 and $32 elsewhere (once Link has a sword), then
;@ moves half a tile right.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def EntityInit_BigFairy(slot: bc)
;@ path: entity/init
;@ Init of type $84: floats 16 pixels up; not there while $C5A9 is set. Plays music $0C (once Link has
;@ a sword) and moves half a tile right.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_BigFairy::
;> wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;> if wHealthIsFull: return FreeEntitySlot(slot)  # frees the slot
	ld a, [wHealthIsFull]
	and a
	jp nz, FreeEntitySlot
;> PlayMusicAndCenterX(slot, 0x0C)
	ld a, $0c
;@ def PlayMusicAndCenterX(slot: bc, track: a)
;@ path: entity/init
;@ Plays `track` as room music (once Link has a sword) and moves the entity half a tile right.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
PlayMusicAndCenterX::
;> PlayMusicIfLinkHasSword(track)
	call PlayMusicIfLinkHasSword
;> return AddHalfTileToCoord(slot, wEntityX, wEntityPosXHigh)
	ld de, wEntityPosXHigh
	ld hl, wEntityX
	jp AddHalfTileToCoord

;@ def EntityInit_BowWow(slot: bc)
;@ path: entity/init
;@ Init of type $6D: in room $E2 (the kidnappers' place) BowWow is only there while he is kidnapped
;@ (wIsBowWowFollowingLink = $80); elsewhere he is only there while not with Link.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_BowWow::
;> if hMapRoom == 0xE2:
	ldh a, [hMapRoom]
	cp $e2
	jr nz, .home
;>     if wIsBowWowFollowingLink != 0x80: return FreeEntitySlot(slot)  # frees the slot
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jr z, .done
	jp FreeEntitySlot
.home
;> elif wIsBowWowFollowingLink: return FreeEntitySlot(slot)
	ld a, [wIsBowWowFollowingLink]
	and a
	jp nz, FreeEntitySlot
.done
	ret

;@ def EntityInit_OwlEvent(slot: bc)
;@ path: entity/init
;@ Init of type $41: the owl does not come back once bit 5 of the room's status is set.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_OwlEvent::
;> return DespawnIfRoomFlag(slot, hRoomStatus >> 1)  # tests bit 5 of the room status
	ldh a, [hRoomStatus]
	rra
	jr DespawnIfRoomFlag

;@ def EntityInit_Sword(slot: bc)
;@ path: entity/init
;@ Init of type $31: the sword on the beach is gone once bit 4 of the room's status is set (taken).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Sword::
;> DespawnIfRoomFlag(slot, hRoomStatus)
	ldh a, [hRoomStatus]
;@ def DespawnIfRoomFlag(slot: bc, flags: a)
;@ path: entity/init
;@ Frees the slot when bit 4 of `flags` is set (callers pass the room status, shifted to test other
;@ bits).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
DespawnIfRoomFlag::
;> if flags & 0x10: return FreeEntitySlot(slot)  # frees the slot
	and $10
	jp nz, FreeEntitySlot
	ret

;@ def EntityInit_Marin(slot: bc)
;@ path: entity/init
;@ Init of type $3E. In the rooms from $C0 on (Animal Village) Marin is only there while she waits in
;@ the village; she then plays her song (music $2F). A debug feature follows: when the cartridge byte
;@ at $0003 is non-zero and the player has no name, Marin switches the game to mode 1 or turns into
;@ the text debugger (type $6B). Otherwise she is set up like a townsperson.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Marin::
;> if hMapRoom >= 0xC0:
	ldh a, [hMapRoom]
	cp $c0
	jr c, .debugCheck

;>     if not wIsMarinInAnimalVillage: return FreeEntitySlot(slot)  # frees the slot
	ld a, [wIsMarinInAnimalVillage]
	and a
	jp z, FreeEntitySlot

;>     if wIsMarinFollowingLink: return FreeEntitySlot(slot)
	ld a, [wIsMarinFollowingLink]
	and a
	jp nz, FreeEntitySlot

;>     wMarinSinging = 1
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

;>     if not wPlayerName[1]:
	ld a, [wPlayerName + 1]
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
;@ test: slot = rand(0, 15)
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

;@ def EntityInit_Raft(slot: bc)
;@ path: entity/init
;@ Init of type $6A: indoors it is set up like a townsperson; outdoors, unless $D477 is set, it moves
;@ 16 pixels up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Raft::
;> if wIsIndoor: return EntityInit_Townsperson(slot)
	ld a, [wIsIndoor]
	and a
	jr nz, EntityInit_Townsperson
;> if wRaftRented: return
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

;@ def EntityInit_Townsperson(slot: bc)
;@ path: entity/init
;@ Init of the villagers (types $3F, $70, $73-$75, $77, $7B) and of the raft owner indoors: the
;@ direction is set to down, then like EntityInit_GameOwner they end up facing left.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Townsperson::
;> wEntityDirection[slot] = 3
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
;> EntityInit_GameOwner(slot)
;@ def EntityInit_GameOwner(slot: bc)
;@ path: entity/init
;@ Init of types $4F and $54 (and the end of EntityInit_Townsperson): before Link owns a shield the room
;@ plays music $1C; the character faces left.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;@ test: slot = rand(0, 15)
EntityInit_Witch::
;> return
	ret

;@ def EntityInit_ShopOwner(slot: bc)
;@ path: entity/init
;@ Init of type $4D: plays music $07 in the shop (once Link has a sword) and faces left.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_ShopOwner::
;> PlayMusicIfLinkHasSword(0x07)
	ld a, $07
	call PlayMusicIfLinkHasSword
;> SetEntityDirectionLeft(slot)

;@ def SetEntityDirectionLeft(slot: bc)
;@ path: entity/init
;@ Makes the entity face left.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SetEntityDirectionLeft::
;> return SetEntityDirection(slot, 1)
	ld a, $01
	jr SetEntityDirection

;@ def EntityInit_RandomDirection(slot: bc)
;@ path: entity/init
;@ The default init of most types: faces a random direction.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_RandomDirection::
;> SetEntityDirection(slot, GetRandomByte() & 3)  # random byte
	call GetRandomByte
	and $03

;@ def SetEntityDirection(slot: bc, direction: a)
;@ path: entity/init
;@ Sets the entity's facing direction (0 right, 1 left, 2 up, 3 down).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SetEntityDirection::
;> wEntityDirection[slot] = direction
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> return EntityInit_None()    # (runs on into it)

;@ def EntityInit_None()
;@ path: entity/init
;@ Init of the types that need nothing.
EntityInit_None::
;> return
	ret


;@ def EntityInit_FaceShrineDoor(slot: c)
;@ path: entity/init
;@ Init of type $64: enables the VBlank and LCD STAT interrupts (rIE = 3).
;@ test: slot = rand(0, 15)
EntityInit_FaceShrineDoor::
;> rIE = 0x03
	ld a, $03
	ldh [$ffff], a
	ret

;@ def EntityInit_Leever(slot: bc)
;@ path: entity/init
;@ Init of type $0E: starts hidden in the ground (sprite variant $FF = not drawn).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def EntityStatus3Handler(slot: bc)
;@ path: entity/status
;@ Status 3: the entity burns (hit by fire). While wEntityTimer runs it stands still under flickering
;@ flames, its own handler still drawing it. Then it dies (status 1), except a Gibdo (type $1F),
;@ which turns into a Stalfos (type $1E).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;>     DrawEntity16x16(slot, BurningFlameSprites)  # draws the flames (two sprites)
	ld de, BurningFlameSprites
	call DrawEntity16x16
;>     hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>     RunEntityHandlerFrom3(slot)  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3
;>     ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;>     ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;>     UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;>     ClearEntitySpeed(slot)  # stops the entity (x and y speed 0)
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

;@ def EntityStatus2Handler(slot: bc)
;@ path: entity/status
;@ Status 2: the entity falls into a pit. For the first frames ($40 and more on wEntityTimer) its own
;@ handler still runs; then it shrinks through 4 stages while it is pulled to the pit's centre
;@ (wEntityPitX/Y). When the timer runs out the slot is freed; the heavy ball (type $A8) goes back to
;@ its starting place.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
	ld [wIronBallRoom], a
;>         wIronBallX = 0x50
	ld a, $50
	ld [wIronBallX], a
;>         wIronBallY = 0x27
	ld a, $27
	ld [wIronBallY], a
.free
;>     return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot
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
;>     RunEntityHandlerFrom3(slot)  # runs the type's own handler, then switches bank 3 back in
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
;> offset = mem[PitFallDrawYOffsets + stage]
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
;>     DrawEntity16x16(slot, PitFallStartSprite)  # draws two sprites
	ld de, PitFallStartSprite
	call DrawEntity16x16
	jr .drawn
.small
;> else:
;>     DrawEntity8x16(slot, PitFallSprites)  # draws one sprite
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
;> speed = mem[PitFallPullSpeeds + stage]
	ld e, a
	ld d, b
	ld hl, PitFallPullSpeeds
	add hl, de
	ld e, [hl]
;> linkX = hLinkX  # SetEntitySpeedTowardsLink_03 aims at Link's position: point it at the pit for a moment
	ldh a, [hLinkX]
	push af
;> hLinkX = wEntityPitX[slot]
	ld hl, wEntityPitX
	add hl, bc
	ld a, [hl]
	ldh [hLinkX], a
;> linkY = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = wEntityPitY[slot]
	ld hl, wEntityPitY
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink_03(slot, speed)  # sets the speed towards that point
	ld a, e
	call SetEntitySpeedTowardsLink_03
;> hLinkY = linkY
	pop af
	ldh [hLinkY], a
;> hLinkX = linkX
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
	ret

;@ def EntityStatus8Handler(slot: bc)
;@ path: entity/status
;@ Status 8: the entity flies through the air after Link threw it. It hits other entities as weapon
;@ $0B (a thrown object); when it stops moving it lands stunned (status 6). The Genie's bottle
;@ (type $5C) counts its hits against walls: on the third one, or when it stops, the Genie comes out
;@ (back to status 5, state 1).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: skip runs the handler of the entity's type (RunEntityHandler: 233-entry table, handlers in many banks)
EntityStatus8Handler::
;> RunEntityHandlerFrom3(slot)  # runs the type's own handler, then switches bank 3 back in
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
;> BounceBombOffWalls(slot)
	call BounceBombOffWalls
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
;>     EntityHitOtherEntities_03(slot)  # hits the other entities
	call EntityHitOtherEntities_03
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

;@ def EntityStatus6Handler(slot: bc)
;@ path: entity/status
;@ Status 6: the entity is stunned. It stands still while its own handler still draws it; Link can
;@ lift it with the Power Bracelet (item 3) by pressing that item's button.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: skip runs the handler of the entity's type (RunEntityHandler: 233-entry table, handlers in many banks)
EntityStatus6Handler::
;> RunEntityHandlerFrom3(slot)  # runs the type's own handler, then switches bank 3 back in
	call RunEntityHandlerFrom3
;> ReturnIfGameFrozen_03()
	call ReturnIfGameFrozen_03
;> ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;> UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;> ClearEntitySpeed(slot)  # stops the entity (x and y speed 0)
	call ClearEntitySpeed
;> EntityCheckWeaponHits_03(slot)
	call EntityCheckWeaponHits_03
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

;@ def TryLiftStunnedEntity(slot: bc)
;@ path: entity/status
;@ Link tries to lift a stunned entity: if he carries nothing and touches it, it becomes lifted
;@ (status 7) and the lifted handler takes over; otherwise it stays stunned.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;> touching = EntityTouchesLinkOnGround_03(slot)  # carry: Link touches the entity
	call EntityTouchesLinkOnGround_03
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


;@ def UpdateStunnedEntity(slot: bc)
;@ path: entity/status
;@ Counts the stun down on wEntityTimer2: at 0 the entity is active again (status 5); during the last
;@ $3C frames it shakes left and right.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;>     speed = mem[StunShakeSpeeds + i]
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
;>     ClearEntitySpeed(slot)  # x and y speed back to 0
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

;@ def EntityInit_RandomDiagonal(slot: bc)
;@ path: entity/init
;@ Init of types $15, $9C and $DB: starts moving in one of the 4 diagonal directions at random.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_RandomDiagonal::
;> i = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[DiagonalSpeedsX + i]
	ld hl, DiagonalSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[DiagonalSpeedsY + i]
	ld hl, DiagonalSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def EntityInit_SparkClockwise(slot: bc)
;@ path: entity/init
;@ Init of type $17: private variable 2 = 4 and 3 pixels down.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_SparkClockwise::
;> wEntityPrivate2[slot] = 4
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $04
;> return AddToEntityY(slot, 3)
	ld a, $03
	jr AddToEntityY

;@ def EntityInit_SparkCounterClockwise(slot: bc)
;@ path: entity/init
;@ Init of type $16: 3 pixels up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_SparkCounterClockwise::
;> AddToEntityY(slot, -3)
	ld a, $fd

;@ def AddToEntityY(slot: bc, dy: a)
;@ path: entity/init
;@ Moves the entity `dy` pixels down (negative: up).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
AddToEntityY::
;> wEntityY[slot] += dy
	ld hl, wEntityY
	add hl, bc
	add [hl]
	ld [hl], a
	ret


;@ def EntityInit_Wizrobe(slot: bc)
;@ path: entity/init
;@ Init of types $1D and $21: waits $80 frames, sprite variant $FF (not drawn).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Wizrobe::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntitySpriteVariant[slot] -= 1  # 0 -> $FF
	ld hl, wEntitySpriteVariant
	add hl, bc
	dec [hl]
	ret


;@ def EntityInit_MoblinSword(slot: bc)
;@ path: entity/init
;@ Init of type $14: picks a facing direction from the x position (right or down), lets SetWalkingSpriteVariant_03
;@ use it, then flips bit 0 of it (right <-> left, up <-> down).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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


;@ def EntityInit_SecretSeashell(slot: bc)
;@ path: entity/init
;@ Init of type $3D: a pickup with private variable 3 = 2; in rooms $A4 and $D2 it is 1 and the shell
;@ is centred on its tile.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def InitPickupItem(slot: bc)
;@ path: entity/init
;@ Common setup of the pickups: private variable 3 = 1 on the overworld, 2 indoors, and option bits
;@ 0 and 4 set.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def EntityInit_DroppedItem(slot: bc)
;@ path: entity/init
;@ Init of types $2D, $3B and $3C (and the indoor part of InitPickupItem): private variable 3 = 2,
;@ then SetPickupOptions.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_DroppedItem::
;> wEntityPrivate3[slot] = 2
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], $02
;> SetPickupOptions(slot)

;@ def SetPickupOptions(slot: bc)
;@ path: entity/init
;@ Sets option bits 0 and 4 of a pickup.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SetPickupOptions::
;> wEntityOptions1[slot] |= 0x11
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	or $11
	ld [hl], a
	ret


;@ def EntityInit_KeyDropPoint(slot: bc)
;@ path: entity/init
;@ Init of type $30, which places a key in three rooms: room $F8 needs room flag 5 and not flag 4
;@ (sprite variant 2); room $7A needs flag 4 clear (variant 4); room $7C needs flag 4 of room $169
;@ set and its own flag 4 clear. Flag 4 = the key was taken.
;@ test: slot = rand(0, 15)
EntityInit_KeyDropPoint::
;> if hMapRoom == 0xF8:
	ldh a, [hMapRoom]
	cp $f8
	jr nz, .room7A
;>     if hRoomStatus & 0x10: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hRoomStatus]
	bit 4, a
	jp nz, FreeEntitySlot
;>     if not hRoomStatus & 0x20: return FreeEntitySlot(slot)
	bit 5, a
	jp z, FreeEntitySlot
;>     return SetEntitySpriteVariant(slot, 2)  # sets wEntitySpriteVariant
	ld a, $02
	jp SetEntitySpriteVariant
.room7A
;> if hMapRoom == 0x7A:
	cp $7a
	jr nz, .room7C
;>     if hRoomStatus & 0x10: return FreeEntitySlot(slot)
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot
;>     return SetEntitySpriteVariant(slot, 4)
	ld a, $04
	jp SetEntitySpriteVariant
.room7C
;> if hMapRoom == 0x7C:
	cp $7c
	jr nz, .done
;>     if not wRoomStatus[0x169] & 0x10: return FreeEntitySlot(slot)
	ld a, [wRoomStatus + $169]
	and $10
	jp z, FreeEntitySlot
;>     if hRoomStatus & 0x10: return FreeEntitySlot(slot)
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot
.done
	ret

;@ def EntityInit_TradingItem(slot: c)
;@ path: entity/init
;@ Init of type $AF: centred on its tile while the trading item is the last one ($0E).
;@ test: slot = rand(0, 15)
EntityInit_TradingItem::
;> if wTradeSequenceItem == 0x0E: return CenterEntityOnTile(slot)
	ld a, [wTradeSequenceItem]
	cp $0e
	jr z, CenterEntityOnTile
	ret

;@ def EntityInit_Warp(slot: bc)
;@ path: entity/init
;@ Init of type $61: indoors it starts in state 1, centred on its tile; nothing on the overworld.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Warp::
;> if not wIsIndoor: return
	ld a, [wIsIndoor]
	and a
	ret z
;> wEntityState[slot] += 1
	call IncrementEntityState
;> return CenterEntityOnTile(slot)
	jr CenterEntityOnTile

;@ def EntityInit_PickupItem(slot: bc)
;@ path: entity/init
;@ Init of the pickups $2E, $2F, $32-$34 and $36-$38: common pickup setup; indoors it gets a drop timer
;@ of $80 frames, outdoors it is centred on its tile.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_PickupItem::
;> InitPickupItem(slot)
	call InitPickupItem
;> if wIsIndoor: return SetEntityDropTimer80(slot)
	ld a, [wIsIndoor]
	and a
	jr nz, SetEntityDropTimer80
;> CenterEntityOnTile(slot)

;@ def CenterEntityOnTile(slot: bc)
;@ path: entity/init
;@ Moves the entity half a tile right and down (8 pixels each, with carry into the high bytes): room
;@ data places entities at the corner of a 16x16 square.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
CenterEntityOnTile::
;> AddHalfTileToCoord(slot, wEntityX, wEntityPosXHigh)
	ld de, wEntityPosXHigh
	ld hl, wEntityX
	call AddHalfTileToCoord
;> AddHalfTileToCoord(slot, wEntityY, wEntityPosYHigh)
	ld de, wEntityPosYHigh
	ld hl, wEntityY

;@ def AddHalfTileToCoord(slot: bc, low: hl, high: de)
;@ path: entity/init
;@ Adds 8 to one coordinate of the entity: `low` is the array of the low byte (wEntityX or wEntityY),
;@ `high` the array of its high byte, which takes the carry.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: low = rand_ram(16); high = rand_ram(16)
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


;@ def EntityInit_Instrument(slot: bc)
;@ path: entity/init
;@ Init of types $39 and $43: half a tile right.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_Instrument::
;> return AddHalfTileToCoord(slot, wEntityX, wEntityPosXHigh)
	ld de, wEntityPosXHigh
	ld hl, wEntityX
	jr AddHalfTileToCoord

;@ def SetEntityDropTimer80(slot: bc)
;@ path: entity/init
;@ Starts the drop timer at $80 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SetEntityDropTimer80::
;> wEntityDropTimer[slot] = 0x80
	call GetEntityDropTimer
	ld [hl], $80
	ret


;@ def EntityInit_OctorokMoblin(slot: bc)
;@ path: entity/init
;@ Init of types $09 and $0B: timer 1 starts at $A0 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityInit_OctorokMoblin::
;> wEntityTimer1[slot] = 0xA0
	call GetEntityTimer1
	ld [hl], $a0
	ret


;@ def EntityInit_Ghini(slot: bc)
;@ path: entity/init
;@ Init of types $10-$12: the Ghini $12 starts 16 pixels up with private variable 3 = 1; the others
;@ start in state 1.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def IronMaskHandler(slot: bc)
;@ path: enemy/iron-mask
;@ Handler of type $24, the Iron Mask. With its mask on (private variable 2 = 0) it walks like a
;@ Moblin (WalkingEnemyHandler). Without it, it runs in a random straight direction for $20-$3F frames at a
;@ time, animating every 16 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
IronMaskHandler::
;> if not wEntityPrivate2[slot]:  # still masked
;>@masked     return WalkingEnemyHandler(slot, IronMaskSprites)  # walks like a Moblin
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .masked

;> DrawEntity16x16(slot, IronMaskFaceSprites)  # draws the unmasked sprites
	ld de, IronMaskFaceSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> ApplyRecoilIfNeeded_03(slot)
	call ApplyRecoilIfNeeded_03
;> EntityCheckHits_03(slot)
	call EntityCheckHits_03
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> EntityCheckWalls_03(slot)
	call EntityCheckWalls_03
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
;>     wEntitySpeedX[slot] = mem[IronMaskSpeedsX + d]
	ld hl, IronMaskSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[IronMaskSpeedsY + d]
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

;@ def EntityInit_ChestItem(slot: bc)
;@ path: item/chest
;@ Init of type $07, the item that rises out of a chest Link opened. The chest square becomes an open
;@ chest (object $A1), the item starts 8 pixels higher moving up, and Link gets the content (in
;@ wEntitySpriteVariant): inventory items $00-$0B (upgrading the shield and the bracelet), counters
;@ $0C-$15, dungeon items $16-$1A, rupees $1B-$1F, $20 a special case; then the room remembers that
;@ its chest is open.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: mem[wEntitySpriteVariant + slot] = rand(0, 0x22)
;@ test: wIsIndoor = rand(0, 1)
EntityInit_ChestItem::
;> wLinkPoseLock = 0x2A
	ld a, $2a
	ld [wLinkPoseLock], a
;> hNoiseSfx = 4
	ld a, $04
	ldh [hNoiseSfx], a
;> ReplaceRoomObjectAtEntity(OpenChestTiles, 0xA1)
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
;> hMultiPurposeG = content  # used as scratch here
	ldh [hMultiPurposeG], a
;> if content == 0x11:
	ld d, b
	cp $11
	jr nz, .dispatch

;>     other = wOwlSlot
	push af
	ld a, [wOwlSlot]
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

;> if content == 0x20: return AddSeashell()
	cp $20
	jr nz, .rupees

	jp AddSeashell


.rupees
;> if 0x1B <= content < 0x20:
	cp $1b
	jr c, .dungeonItem

	cp $20
	jr nc, .dungeonItem

;>     wAddRupeeBufferLow = mem[ChestRupeesLow + (content - 0x1B)]
	ld hl, ChestRupeesLow - $1b
	add hl, de
	ld a, [hl]
	ld [wAddRupeeBufferLow], a
;>     wAddRupeeBufferHigh = mem[ChestRupeesHigh + (content - 0x1B)]
	ld hl, ChestRupeesHigh - $1b
	add hl, de
	ld a, [hl]
	ld [wAddRupeeBufferHigh], a
;>     wRupeeCountDelay = 0x18
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

;>     mem[addr(wDungeonHasMap) + (content - 0x16)] += 1
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
	ldh a, [hMultiPurposeG]
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
	ldh a, [hMultiPurposeG]
	cp $0a
	jr nz, .give

;>         wBombCount = to_bcd(bcd_to_int(wBombCount) + 1)
	ld hl, wBombCount
	ld a, [hl]
	add $01
	daa
	ld [hl], a

.give
;>     GiveInventoryItem(mem[ChestItemInventoryIds + content])  # puts the item in the inventory
	ld d, b
	ld hl, ChestItemInventoryIds
	add hl, de
	ld d, [hl]
	call GiveInventoryItem
;>     return MarkRoomChestOpened()
	jr MarkRoomChestOpened

.counter
;> mem[addr(wItemB) + content] += 1  # contents $0C-$15 count up the byte at $DB00 + content
	ld hl, wItemB
	add hl, de
	inc [hl]
;> MarkRoomChestOpened()

;@ def MarkRoomChestOpened()
;@ path: item/chest
;@ Sets bit 4 of the current room's status (the chest is open) in wRoomStatus and hRoomStatus.
;@ test: wCurrentBank = $03
;@ test: wIsIndoor = rand(0, 1)
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
;@ test: wIsIndoor = rand(0, 1)
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

;@ def EntityInit_PushedBlock(slot: bc)
;@ path: object/block
;@ Init of type $06, a block Link pushes: it moves away from Link; if it would hit a wall at once it
;@ vanishes, otherwise its square becomes floor (object $C6 outdoors, $0D indoors, $BE in room $C7).
;@ test: slot = rand(0, 15)
EntityInit_PushedBlock::
;> d = GetEntityDirectionToLink_03(slot)
	call GetEntityDirectionToLink_03
	ld d, $00
;> wEntitySpeedX[slot] = mem[PushedBlockSpeedsX + d]
	ld hl, PushedBlockSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[PushedBlockSpeedsY + d]
	ld hl, PushedBlockSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> PushedBlockHandler(slot)
	call PushedBlockHandler
;> EntityCheckWalls_03(slot)  # background collision
	call EntityCheckWalls_03
;> if wEntityCollisions[slot]: return FreeEntitySlot(slot)  # frees the slot
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .moves

	jp FreeEntitySlot


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
;> ReplaceRoomObjectAtEntity(tiles, obj)

;@ def ReplaceRoomObjectAtEntity(tiles: de, obj: b)
;@ path: world/objects
;@ Puts object `obj` into wRoomObjects at the 16x16 square under the active entity and queues the
;@ square's four background tiles from `tiles`.
;@ test: wCurrentBank = $03
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
;@ test: wCurrentBank = $03
;@ test: skip takes the tile list from the stack, where its caller pushed it
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
;> mem[cmd + 3] = mem[tiles + 0]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 4] = mem[tiles + 1]
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
;> mem[cmd + 8] = mem[tiles + 2]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 9] = mem[tiles + 3]
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

;@ def PushedBlockHandler(slot: bc)
;@ path: object/block
;@ Handler of type $06. The block slides for $20 frames, pushing entities in its way and holding Link
;@ back; then it becomes a block object again (object $C4 outdoors, $A6 indoors) where it stopped,
;@ unless it fell into a pit. Room events 2 (push a block) and 7 (with object $A6/$A7 under it) fire.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
PushedBlockHandler::
;> hActiveEntitySpriteVariant = wIsIndoor
	ld a, [wIsIndoor]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, PushedBlockSprites)  # draws the block
	ld de, PushedBlockSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> PushedBlockHitEntities(slot)  # pushes the entities it touches
	call PushedBlockHitEntities
;> if EntityTouchesLink_03(slot):  # carry: the block touches Link
	call EntityTouchesLink_03
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
;> EntityCheckWalls_03(slot)  # background collision (may make it fall into a pit)
	call EntityCheckWalls_03
;> status = wEntityStatus[slot]
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
;> if status in (0, 2): return  # gone, or falling into a pit
	and a
	jr z, .done

	cp $02
	jr z, .done

;> FreeEntitySlot(slot)  # frees the slot
	call FreeEntitySlot
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
;> ReplaceRoomObjectAtEntity(tiles, obj)
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

;> EntityCheckWalls_03(slot)
	call EntityCheckWalls_03
;> if wEntityWallObjectX not in (0xA7, 0xA6): return
	ld a, [wEntityWallObjectX]
	cp $a7
	jr z, .trigger

	cp $a6
	jr nz, .done

.trigger
;> TriggerRoomEvent()
	call TriggerRoomEvent

.done
	ret


;@ def PushedBlockHitEntities(slot: bc)
;@ path: object/block
;@ The pushed block hits every entity (slots 15-0) it overlaps: active ones (status 5 and up) without
;@ physics bits 6 and 5, closer than 12 pixels in x and in drawn y, get SetEntityRecoil with weapon 8.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
PushedBlockHitEntities::
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
;>     SetEntityRecoil(target, 8)
	ld a, $08
	call SetEntityRecoil
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
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityHandler_Type4B::
;> LiftableObjectHandler(slot)
	ld d, $00

;@ def LiftableObjectHandler(slot: bc)
;@ path: object/liftable
;@ Handler of type $05, a pot or rock Link lifted and threw (sprite variant 0 = pot, 1 = rock). While
;@ timer 1 is 0 it flies (UpdateThrownObject); when it breaks, timer 1 counts the pieces' animation
;@ down. On the last frame a pot may leave a fairy (private variable 5 set, 1 in 4), and in the maps
;@ $10 and $1E Marin, if she is with Link, comments on the broken pot.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
LiftableObjectHandler::
;> wLiftableObjectSlot = slot
	ld a, c
	ld [wLiftableObjectSlot], a
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> hMultiPurpose0 = t
	ldh [hMultiPurpose0], a
;> if t == 0: return UpdateThrownObject(slot)
	jp z, UpdateThrownObject

;>@pieces if t != 1: return ShatterThrownObject(slot)  # draws the pieces (code in bank $19)
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

;>         fairy, full = SpawnEntity_03(slot, 0x2F)  # carry: no free slot
	ld a, $2f
	call SpawnEntity_03
;>         if not full:
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
;>                 return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot


.usual
;>             OpenDialogTable1(0x99)
	ld a, $99
	call OpenDialogTable1

.free
;> return FreeEntitySlot(slot)
	jp FreeEntitySlot


.pieces
;=@pieces
	call ShatterThrownObject
	ret


;@ path: object/liftable
;@ Sprites of a thrown pot or rock, by sprite variant: 0 = pot (tiles $F0/$F2), 1 = rock (tiles
;@ $F4/$F6), each two 8x16 sprites as (tile, attribute) pairs with palette 1.
LiftableObjectSprites::
	db $f0, $10, $f2, $10, $f4, $10, $f6, $10

;@ def UpdateThrownObject(slot: bc)
;@ path: object/liftable
;@ A thrown pot or rock in flight: it hits the entities it meets (weapon $0B), and breaks when it lands
;@ or hits a wall (where room events may fire).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
UpdateThrownObject::
;> DrawEntity16x16(slot, LiftableObjectSprites)  # draws it
	ld de, LiftableObjectSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> wProjectileWeaponType = 0x0B  # a thrown object
	ld a, $0b
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities_03(slot)  # hits the other entities
	call EntityHitOtherEntities_03
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

;@ def BreakThrownObject(slot: bc)
;@ path: object/liftable
;@ A thrown object breaks: a pot ($FF or 1 = special variants keep the long version) plays noise 5
;@ for $1F frames of pieces, others noise 9 for $0F frames; it now uses 2 more OAM sprites.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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


;@ def BreakIntoPieces(slot: bc)
;@ path: object/liftable
;@ Replaces the entity in `slot` by breaking pot pieces: a new type $05 entity at (hMultiPurpose0,
;@ hMultiPurpose1 - hMultiPurpose3), variant 0, already breaking ($0F frames, 4 OAM sprites, noise 9).
;@ Called from bank 0.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
BreakIntoPieces::
;> pieces, full = SpawnEntity_03(slot, 0x05)
	ld a, $05
	call SpawnEntity_03
;> if full: return  # no free slot
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
;> FreeEntitySlot(slot)  # frees the old slot
	call FreeEntitySlot

.done
	ret


;@ def CheckThrownObjectRoomEvents(slot: bc)
;@ path: object/liftable
;@ A thrown object hit a wall. Room event $0D: if the object it hit ($C503 or $C50D) is $A0, the
;@ square at (x $30, y $20) changes ($19) and the event fires. Room event $0B: it fires when $C50D is
;@ in $35-$3C, or else $C503 is.
;@ test: slot = rand(0, 15)
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

;>     if wEntityWallObjectX != 0xA0 and wEntityWallObjectY != 0xA0: return
	ld a, [wEntityWallObjectX]
	cp $a0
	jr z, .open

	ld a, [wEntityWallObjectY]
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
;>     SpawnChestContentsFrom3()  # changes that square
	call SpawnChestContentsFrom3
;>     return TriggerRoomEvent()
	jp TriggerRoomEvent


.event0B
;> if event != 0x0B: return
	cp $0b
	jr nz, .done

;> hit = wEntityWallObjectY
	ld a, [wEntityWallObjectY]
;> if hit < 0x35: return
	cp $35
	jr c, .done

;> if hit >= 0x3D:
	cp $3d
	jr c, .fire

;>     if not 0x35 <= wEntityWallObjectX < 0x3D: return
	ld a, [wEntityWallObjectX]
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
;@ 4 bytes no code refers to: a sprite pair (tile, attribute) of tile $32, the right one flipped both
;@ ways.
UnusedSprites54E6::
	db $32, $00, $32, $60

;@ path: item/bomb
;@ The puff a bomb shows just before it explodes (DrawBombSmoke): two 8x16 sprites (tile, attribute),
;@ tile $30 and the same flipped both ways.
BombSmokeSprite::
	db $30, $00, $30, $60

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

;@ def EntityStatus1Handler(slot: bc)
;@ path: entity/status
;@ Status 1: the entity dies. Bosses (option bit 7) run their own death code in their handler. Others
;@ flash for a moment ($20 and more on wEntityDyingTimer, handler still running), then vanish in a puff
;@ of smoke; at 0 DefeatEntityWithDrop drops an item and frees the slot.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: skip runs the handler of the entity's type (RunEntityHandler: 233-entry table, handlers in many banks)
EntityStatus1Handler::
;> if wEntityOptions1[slot] & 0x80: return RunEntityHandler(slot)  # a boss: its own handler
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
;> if t == 0: return DefeatEntityWithDrop(slot)  # drops the item, frees the slot
	and a
	jp z, DefeatEntityWithDrop
;> large = wEntityHitByPowerUp[slot]
	push af
	ld hl, wEntityHitByPowerUp
	add hl, bc
	ld a, [hl]
;> sprites = DeathPoofLargeSprites if large else DeathPoofSprites
	ld hl, DeathPoofSprites
	and a
	jr z, .small
	ld hl, DeathPoofLargeSprites
.small
;> if t >= 0x20:  # still flashing
;>@f1     RunEntityHandlerFrom3(slot)  # runs the type's own handler, then switches bank 3 back in
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
;> big = wEntityHitByPowerUp[slot] if stage == 0x30 else 0
	cp $30
	jr nz, .four
	push hl
	ld hl, wEntityHitByPowerUp
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
;@ Item dropped by a defeated entity, by drop class 1-14 (the class comes from EntityDropClassTable;
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

;@ def DropDefeatedEntityItem(slot: bc)
;@ path: item/drops
;@ Leaves the item of a defeated entity. A Like Like that swallowed something gives it back (type
;@ $31); a fixed wEntityDropType ($FF = nothing) wins; every 12th kill drops a Guardian Acorn ($34)
;@ and every $1E-$28th (more hearts = rarer) a Piece of Power ($33), not during boss fights, side
;@ view or an active power-up; otherwise the drop class of the health group decides. The item pops
;@ out where the entity was.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;> wKillsWithoutHit += 1  # kill counter for the acorn
	ld a, [wKillsWithoutHit]
	inc a
	ld [wKillsWithoutHit], a
;> if wKillsWithoutHit >= 12:
	cp $0c
	jr c, .byClass

;>     wKillsWithoutHit = 0
	xor a
	ld [wKillsWithoutHit], a
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
;> cls = mem[EntityDropClassTable + group]  # drop class
	ld hl, EntityDropClassTable
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
;> wKillCounter += 1  # kill counter for the Piece of Power
	ld hl, wKillCounter
	inc [hl]
;> if wKillCounter >= limit:
	ld a, [hl]
	cp d
	jr c, .chance

;>     wKillCounter = 0
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
;> if GetRandomByte() & mem[masks + (cls - 1)]: return
	add hl, de
	call GetRandomByte
	and [hl]
	ret nz

;> drop = mem[DropItemByClass + (cls - 1)]
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
;>     drop = mem[RandomDropItems + r]
	ld hl, RandomDropItems
	add hl, de
	ld a, [hl]
;> SpawnDrop(slot, drop)

;@ def SpawnDrop(slot: bc, drop: a)
;@ path: item/drops
;@ Spawns entity type `drop` where the defeated entity was (it inherits private variable 1 and the
;@ height) and makes it pop up: up into the air, or upwards in side view. A key ($30) from the Armos
;@ Knight uses sprite variant 3; the slime key ($3C) in rooms $58 and $5A flies towards Link.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SpawnDrop::
;> item, full = SpawnEntity_03(slot, drop)  # at the entity's place
	call SpawnEntity_03
;> if full: return
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
;>             SetEntitySpeedTowardsLink_03(target, 0x10)  # sets its speed towards Link
	ld a, $10
	call SetEntitySpeedTowardsLink_03
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

;@ def EntityStatus7Handler(slot: bc)
;@ path: entity/status
;@ Status 7: Link lifts or carries the entity. Each lift step (4 of them) lasts LiftStepFrames frames;
;@ the entity is kept at Link's hands or over his head. A bomb keeps ticking (DrawBomb) instead of
;@ running its handler.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: skip runs the handler of the entity's type (RunEntityHandler: 233-entry table, handlers in many banks)
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
;>     DrawBomb(slot)
	call DrawBomb
	jr .step

.handler
;> else:
;>     RunEntityHandlerFrom3(slot)  # runs the type's own handler, then switches bank 3 back in
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
;>         wEntityTimer[slot] = mem[frames + step]
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
;> UpdateCarriedEntity_03(slot)
	call UpdateCarriedEntity_03
	ret


;@ def PlaceLiftedEntity(slot: bc, step: e)
;@ path: object/liftable
;@ Puts a lifted entity at Link's hands for lift step `step` (1-4) and Link's direction, and sets
;@ Link's lift pose.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: hLinkDirection = rand(0, 3)
;@ test: step = rand(1, 4)
PlaceLiftedEntity::
;> i = hLinkDirection * 4 + step - 1
	ldh a, [hLinkDirection]
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
;> wIsCarryingLiftedObject = mem[LiftLinkPoses + i]
	ld hl, LiftLinkPoses - 1
	add hl, de
	ld a, [hl]
	ld [wIsCarryingLiftedObject], a
;> x = hLinkX + mem[LiftOffsetsX + i]
	ld hl, LiftOffsetsX - 1
	add hl, de
	ld a, [hl]
	ld hl, hLinkX
	add [hl]
;> wEntityX[slot] = x
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> y = hLinkY + mem[LiftOffsetsY + i]
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

;>     dz = mem[LiftOffsetsZ + i]
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
;> dz = mem[LiftOffsetsZ + i]
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


;@ def UpdateCarriedEntity_03(slot: bc)
;@ path: object/liftable
;@ Runs UpdateCarriedEntity (code in bank $14 for the carried entity).
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
;@ test: hLinkDirection = rand(0, 3)
UpdateCarriedEntity_03::
;> UpdateCarriedEntity(slot)
	call UpdateCarriedEntity
	ret


;@ def OctorokHandler(slot: bc)
;@ path: enemy/octorok
;@ Handler of type $09, the Octorok: the shared walking enemy code with the Octorok's sprites. Outside
;@ game mode 1 it first sets $FFF5 to $30.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
OctorokHandler::
;> sprites = OctorokSprites
	ld de, OctorokSprites
;> if wGameplayType != 1: hActiveEntityTileOffset = 0x30
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
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
MoblinHandler::
;> if hMapId == 0x15:
	ldh a, [hMapId]
	cp $15
	jr nz, .here

;>     if wIsBowWowFollowingLink != 0x80: return FreeEntitySlot(slot)  # frees the slot
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp nz, FreeEntitySlot

.here
;> wEntityWorkRAM2[0x53] = slot
	ld a, c
	ld [wEntityWorkRAM2 + $53], a
;> sprites = MoblinSprites
	ld de, MoblinSprites
;> WalkingEnemyHandler(slot, sprites)

;@ def WalkingEnemyHandler(slot: bc, sprites: de)
;@ path: enemy/walker
;@ The walking enemies (Octorok, Moblin, the masked Iron Mask). State 0: walk straight for a while,
;@ stopping at walls. State 1: stand still; at the end pick a new direction (every fourth time towards
;@ Link, otherwise at random). While standing, an Octorok or Moblin that faces Link shoots a rock or an
;@ arrow (timer at $0A). A hit puts it into state 1 for $40 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
WalkingEnemyHandler::
;> DrawEntity16x16(slot, sprites)  # draws it (two sprites)
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
;> EntityCheckHits_03(slot)
	call EntityCheckHits_03
;> if hActiveEntityState == 0:  # walking
;>@w1     hitWall = wEntityCollisions[slot] & 0x0F
;>@w2     if hitWall or not GetEntityTimer(slot):  # time to stop
;>@w3         # (after a wall hit hl still points at wEntityCollisions, which then gets the new time)
;>@w3         (wEntityCollisions if hitWall else wEntityTimer)[slot] = (GetRandomByte() & 0x0F) | 0x10
;>@w4         wEntityState[slot] = 1
;>@w5         ClearEntitySpeed(slot)  # stops it
;>@w6     UpdateEntityPosWithSpeed_03(slot)
;>@w7     EntityCheckWalls_03(slot)  # background collision
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
;>@t7     wEntitySpeedX[slot] = mem[WalkerSpeedsX + d]
;>@t8     wEntitySpeedY[slot] = mem[WalkerSpeedsY + d]
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
;> EntityCheckWalls_03(slot)  # background collision
	call EntityCheckWalls_03
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
	call EntityCheckWalls_03
;=@w8

;@ def SetWalkingSpriteVariant_03(slot: bc)
;@ path: enemy/walker
;@ Sprite variant of a walking entity: the direction's first variant (WalkerDirectionVariants) plus
;@ the walking frame, which changes every 8 frames of its private counter.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SetWalkingSpriteVariant_03::
;> base = mem[WalkerDirectionVariants + wEntityDirection[slot]]
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

;@ def MoblinShootArrow(slot: bc)
;@ path: enemy/moblin
;@ Spawns a Moblin arrow (type $0C) in front of the Moblin, flying in the Moblin's direction
;@ (hMultiPurpose2 holds that direction after SpawnEntity_03); sprite variant and direction = that
;@ direction.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
MoblinShootArrow::
;> arrow, full = SpawnEntity_03(slot, 0x0C)
	ld a, $0c
	call SpawnEntity_03
;> if full: return
	jr c, .done

;> d = hMultiPurpose2
	push bc
	ldh a, [hMultiPurpose2]
	ld c, a
;> x = hMultiPurpose0 + mem[MoblinArrowOffsetsX + d]
	ld hl, MoblinArrowOffsetsX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;> wEntityX[arrow] = x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> y = hMultiPurpose1 + mem[MoblinArrowOffsetsY + d]
	ld hl, MoblinArrowOffsetsY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;> wEntityY[arrow] = y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpeedX[arrow] = mem[MoblinArrowSpeedsX + d]
	ld hl, MoblinArrowSpeedsX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[arrow] = mem[MoblinArrowSpeedsY + d]
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

;@ def OctorokShootRock(slot: bc) -> carry
;@ path: enemy/octorok
;@ Spawns an Octorok rock (type $0A) in front of the Octorok, flying in its direction. Carry: no
;@ free slot.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
OctorokShootRock::
;> rock, full = SpawnEntity_03(slot, 0x0A)
	ld a, $0a
	call SpawnEntity_03
;> if full: return True
	jr c, .done

;> d = hMultiPurpose2
	push bc
	ldh a, [hMultiPurpose2]
;> wEntityDirection[rock] = d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	ld c, a
;> x = hMultiPurpose0 + mem[OctorokRockOffsetsX + d]
	ld hl, OctorokRockOffsetsX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;> wEntityX[rock] = x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> y = hMultiPurpose1 + mem[OctorokRockOffsetsY + d]
	ld hl, OctorokRockOffsetsY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;> wEntityY[rock] = y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpeedX[rock] = mem[OctorokRockSpeedsX + d]
	ld hl, OctorokRockSpeedsX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[rock] = mem[OctorokRockSpeedsY + d]
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

;@ def HeartContainerHandler(slot: bc)
;@ path: item/heart-container
;@ Handler of type $36, a heart container. It waits for Link (CollectPickupIfTouched starts
;@ wEntityTimer); while the timer runs Link holds it up; on its last frame Link gets one more heart
;@ and full health, the room remembers it (status bit 5) and music $18 plays.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartContainerHandler::
;> DrawEntity16x16(slot, HeartContainerSprite)  # draws it
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
;> return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot


;@ def HoldItemAboveLink(slot: bc)
;@ path: item/pickup
;@ Keeps a collected item 12 pixels above Link's head while he holds it up: Link faces down in pose
;@ $6C, his sword action is cancelled and he cannot move.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;@ def HeartPieceHandler(slot: bc)
;@ path: item/heart-piece
;@ Handler of type $35, a piece of heart; gone once the room's status bit 4 is set. A state machine
;@ (HeartPieceStates): wait for Link, hold it up, load the counter tiles, show the message with the
;@ heart counter filling up, and with the fourth piece add a heart container.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: hActiveEntityState = rand(0, 8)
HeartPieceHandler::
;> if hRoomStatus & 0x10: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot

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

;@ def HeartPiece_Hold(slot: bc)
;@ path: item/heart-piece
;@ State 1: Link holds the piece up until wEntityTimer runs out.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_Hold::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> if GetEntityTimer(slot) == 0: wEntityState[slot] += 1
	call GetEntityTimer
	jr nz, .done

	call IncrementEntityState

.done
	ret


;@ def HeartPiece_LoadTiles1(slot: bc)
;@ path: item/heart-piece
;@ State 2: background tile copy request 3 (part of the counter graphics).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_LoadTiles1::
;> hNeedsUpdatingBGTiles = 3
	ld a, $03
	ldh [hNeedsUpdatingBGTiles], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def HeartPiece_LoadTiles2(slot: bc)
;@ path: item/heart-piece
;@ State 3: background tile copy request 4.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_LoadTiles2::
;> hNeedsUpdatingBGTiles = 4
	ld a, $04
	ldh [hNeedsUpdatingBGTiles], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def HeartPiece_OpenDialog(slot: bc)
;@ path: item/heart-piece
;@ State 4: opens message $4F and keeps the box open.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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


;@ def HeartPiece_Count(slot: bc)
;@ path: item/heart-piece
;@ State 5: Link holds the piece while the counter is shown; after $38 frames the new piece is added
;@ to wHeartPieces, after $A8 frames the next state.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_Count::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> DrawEntity16x16(slot, HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> DrawHeartPieceCounter(slot)
	call DrawHeartPieceCounter
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] == 0xA8: return IncrementEntityState(slot)  # next state
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


;@ def HeartPiece_CheckFull(slot: bc)
;@ path: item/heart-piece
;@ State 6: lets the message close; with 4 pieces they become a heart container (jingle $19, health
;@ refill of $40, message $50).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_CheckFull::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> DrawEntity16x16(slot, HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> wDialogKeepOpen = 0
	xor a
	ld [wDialogKeepOpen], a
;> DrawHeartPieceCounter(slot)
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


;@ def HeartPiece_WaitDialog(slot: bc)
;@ path: item/heart-piece
;@ State 7: holds the piece until the message is closed, then background tile request 5.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_WaitDialog::
;> HoldItemAboveLink(slot)
	call HoldItemAboveLink
;> DrawEntity16x16(slot, HeartPieceSprite)
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


;@ def HeartPiece_Done(slot: bc)
;@ path: item/heart-piece
;@ State 8: background tile request 6 (restores the tiles), frees the slot, background change $0D,
;@ and marks the room's piece as taken.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: wIsIndoor = rand(0, 1)
HeartPiece_Done::
;> hNeedsUpdatingBGTiles = 6
	ld a, $06
	ldh [hNeedsUpdatingBGTiles], a
;> FreeEntitySlot(slot)  # frees the slot
	call FreeEntitySlot
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

;@ def DrawHeartPieceCounter(slot: bc)
;@ path: item/heart-piece
;@ While a message is open, draws the heart counter for wHeartPieces at x $8B, at y $23 when the box
;@ is at the bottom and $6B when it is at the top (wDialogState bit 7).
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
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
;> DrawEntity16x16(slot, HeartPieceCounterSprites)
	ld de, HeartPieceCounterSprites
	call DrawEntity16x16

.done
	ret


;@ def HeartPiece_Wait(slot: bc)
;@ path: item/heart-piece
;@ State 0: the piece lies there until Link touches it.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HeartPiece_Wait::
;> DrawEntity16x16(slot, HeartPieceSprite)
	ld de, HeartPieceSprite
	call DrawEntity16x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/pickup
;@ Sprite of the Guardian Acorn (type $34): one 8x16 sprite, tile $AE, palette 1 (tile, attribute).
GuardianAcornSprite::
	db $ae, $10

;@ def GuardianAcornHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $34, the Guardian Acorn: drawn and collected when touched.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
GuardianAcornHandler::
;> DrawEntity8x16(slot, GuardianAcornSprite)
	ld de, GuardianAcornSprite
	call DrawEntity8x16
;> return PickupUpdateTail(slot)
	jr PickupUpdateTail

;@ path: item/pickup
;@ Sprites of the Piece of Power (type $33): 2 variants of two sprites of tile $14 (right one
;@ x-flipped), palette 0 and palette 1: it flickers between them every 8 frames.
PieceOfPowerSprites::
	db $14, $00, $14, $20, $14, $10, $14, $30

;@ def PieceOfPowerHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $33, the Piece of Power: flickering, collected when touched.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
PieceOfPowerHandler::
;> DrawEntity16x16(slot, PieceOfPowerSprites)
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

;@ def Type32Handler(slot: bc)
;@ path: item/pickup
;@ Handler of type $32: drawn, then the shared pickup movement FollowCarryingWeapon.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Type32Handler::
;> DrawEntity16x16(slot, Type32Sprites)
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

;@ def SwordHandler(slot: bc)
;@ path: item/sword
;@ Handler of type $31, the sword on the beach (gone once taken, room status bit 4). States
;@ (SwordStates): wait and hold it up with message $9B and its music $31, a pause, show it, then
;@ Link gets the sword (inventory item 1, wSwordLevel 1).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SwordHandler::
;> sprite = SwordIconSprite
	ld de, SwordIconSprite
;> if not wSwordLevel:
	ld a, [wSwordLevel]
	and a
	jr nz, .draw

;>     if hRoomStatus & 0x10: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot

;>     sprite = BeachSwordSprite
	ld de, BeachSwordSprite

.draw
;> DrawEntity8x16(slot, sprite)
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

;@ def Sword_Hold(slot: bc)
;@ path: item/sword
;@ State 0: waits for Link; while Link holds it up message $9B opens ($10 frames left); on the last
;@ frame the sword music ($31) starts, the room music becomes 5 and the next state waits $52 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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


;@ def Sword_WaitDrop(slot: bc)
;@ path: item/sword
;@ State 1: Link holds the sword during the music; then it vanishes ($FF variant) for $20 frames while
;@ Link does a spin attack (noise 3).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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


;@ def Sword_Show(slot: bc)
;@ path: item/sword
;@ State 2: after the spin, the sword shows again (variant 0) for $20 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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


;@ def Sword_Give(slot: bc)
;@ path: item/sword
;@ State 3: Link holds the sword up in pose $6B (sword 4 pixels to the left); halfway a sparkle
;@ appears (SpawnSparkleAtEntity) with jingle 7; at the end Link owns the sword.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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
;>     return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot


.sparkle
;> if t == 0x1A:
	cp $1a
	jr nz, .done

;>     SpawnSparkleAtEntity(hActiveEntityY - 0x0C)
	ldh a, [hActiveEntityY]
	sub $0c
	call SpawnSparkleAtEntity
;>     hJingle = 7
	ld a, $07
	ldh [hJingle], a

.done
	ret


;@ path: item/pickup
;@ One 8x16 sprite (tile, attribute): tile $8A, palette 1 (the item of type $30 in room $80).
ItemSprite8A::
	db $8a, $10

;@ def KeyDropPoint_Room80(slot: bc)
;@ path: item/pickup
;@ Type $30 in room $80: an item (gone once taken). Collected like the other pickups; while held up
;@ message $93 opens; at the end Link gets inventory item 6 (the hookshot).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
KeyDropPoint_Room80::
;> if hRoomStatus & 0x10: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot

;> DrawEntity8x16(slot, ItemSprite8A)
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
;> return FreeEntitySlot(slot)
	jp FreeEntitySlot


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

;@ def KeyDropPointHandler(slot: bc)
;@ path: item/keys
;@ Handler of type $30, a key (variant 1-5) that appears on the ground. In overworld room $CE it can
;@ fall into the hole there (which marks rooms $CE and $1F8). In room $80 it is another item. Link
;@ picks it up like other pickups; while he holds it up the variant's message opens and the variant's
;@ key flag ($DB11 + variant - 1) is set.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
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

;> DrawEntity8x16(slot, KeySprites)
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
;>     OpenDialog(mem[KeyDialogs + i])
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
;> if t == 1: return FreeEntitySlot(slot)  # frees the slot
	dec a
	jr nz, .hold

	jp FreeEntitySlot


.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ def KeyDropPoint_Lying(slot: bc)
;@ path: item/keys
;@ The key lies on the ground (or drops to it): pickup movement, the landing (CheckPickupCollected), and the
;@ touch test.
;@ test: slot = rand(0, 15)
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


;@ def CheckKeyFallsInPit(slot: bc) -> carry
;@ path: item/keys
;@ In overworld room $CE, a key lying (height 0, status 5) within 3 pixels of (x $50, y $48) falls into
;@ the hole there: status 2 towards that point for $2F frames, jingle $18. Carry: it falls.
;@ test: slot = rand(0, 15)
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

;@ def DroppedHeartHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $2D, a heart dropped by an enemy: it bounces and blinks (CheckHiddenPickup,
;@ UpdatePickupLifetime), and is collected when touched.
;@ test: slot = rand(0, 15)
DroppedHeartHandler::
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity8x16(slot, DroppedHeartSprite)
	ld de, DroppedHeartSprite
	call DrawEntity8x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/toadstool
;@ Sprite of the Sleepy Toadstool (type $3A): tile $5E twice, the right one x-flipped.
ToadstoolSprites::
	db $5e, $00, $5e, $20

;@ def ToadstoolHandler(slot: bc)
;@ path: item/toadstool
;@ Handler of type $3A, the Sleepy Toadstool in the Mysterious Woods: not there while Link has it or
;@ has magic powder. Collected like a pickup; message $0F while held up; then Link has it (inventory
;@ item $0C) and the background change $0A runs.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ToadstoolHandler::
;> if wMagicPowderCount | wHasToadstool: return FreeEntitySlot(slot)  # frees the slot
	ld hl, wHasToadstool
	ld a, [wMagicPowderCount]
	or [hl]
	jp nz, FreeEntitySlot

;> DrawEntity16x16(slot, ToadstoolSprites)
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
;> return FreeEntitySlot(slot)
	jp FreeEntitySlot


.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ path: item/instrument
;@ Sprite of an Instrument of the Sirens (type $39) by sprite variant 0-3 (hMapId & 3; each dungeon
;@ loads its own instrument tiles): two 8x16 sprites (tile, attribute) per variant: $70/$72,
;@ $74/$76, $78/$7A, $7C/$7E.
InstrumentSprites_03::
	db $70, $00, $72, $00, $74, $00, $76, $00, $78, $00, $7a, $00, $7c, $00, $7e, $00

;@ def InstrumentHandler(slot: bc)
;@ path: item/instrument
;@ Handler of type $39. The instrument and its effects share the type; wEntityPrivate1 selects the
;@ role (InstrumentModes): 0 the instrument, 1 a music note flying off it, 2 the screen flash that
;@ ends the dungeon.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: mem[wEntityPrivate1 + slot] = rand(0, 2)
InstrumentHandler::
;> return InstrumentModes[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: item/instrument
;@ Roles of type $39 by wEntityPrivate1 (0-2).
InstrumentModes::
	dw InstrumentItemHandler
	dw MusicNoteHandler
	dw InstrumentWarpOut

;@ path: item/instrument
;@ Background palettes (BGP) of the flash after the instrument's song, 29 bytes, read at index
;@ wEntityPrivate2 + (frame & 3): white-out from $E4 down to $00, then $1C, $08, $04, $00.
InstrumentFadeBGPalettes::
	db $e4, $e4, $e4, $e4, $90, $90, $90, $90, $40, $40, $40, $40, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ path: item/instrument
;@ Object palette 0 (OBP0) for the same flash, 29 bytes, same index as InstrumentFadeBGPalettes.
InstrumentFadeOBJPalettes::
	db $1c, $1c, $1c
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $08, $08, $08
	db $08, $04, $04, $04, $04, $00, $00, $00, $00, $00

;@ def InstrumentWarpOut(slot: bc)
;@ path: item/instrument
;@ Role 2, spawned when the instrument's song ends: Link is frozen while the screen flashes white
;@ (InstrumentFlashPalettes); when wEntityDropTimer runs out the slot is freed, the instrument goes to
;@ its last state, the screen fades out and the dungeon's after-effect runs (InstrumentDoneEffects).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
InstrumentWarpOut::
;> DrawInstrumentWarpEffectFrom3(slot)  # bank 6 $7940
	call DrawInstrumentWarpEffectFrom3
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> t = GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if t: return InstrumentFlashPalettes(slot, t)
	jr nz, InstrumentFlashPalettes

;> FreeEntitySlot(slot)  # frees the slot
	call FreeEntitySlot
;> hLinkAnimationState = 0
	xor a
	ldh [hLinkAnimationState], a
;> wEntityState[wEntityScratch1] += 1  # $D201 holds the instrument's slot here
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	inc [hl]
;> StartScreenFadeOut()
	call StartScreenFadeOut
;> return InstrumentDoneEffects[hMapId]()
	ldh a, [hMapId]
	rst $00

;@ path: item/instrument
;@ What changes in the world after each dungeon's instrument (index = hMapId 0-7).
InstrumentDoneEffects::
	dw InstrumentDone_Map0
	dw InstrumentDone_Map1
	dw InstrumentDone_Map2
	dw InstrumentDone_Map3
	dw InstrumentDone_Map4
	dw InstrumentDone_Map5
	dw InstrumentDone_Map6
	dw InstrumentDone_Map4

;@ def InstrumentDone_Map0()
;@ path: item/instrument
;@ After dungeon 0: wIsBowWowFollowingLink = $80.
InstrumentDone_Map0::
;> wIsBowWowFollowingLink = 0x80
	ld a, $80
	ld [wIsBowWowFollowingLink], a
	ret


;@ def InstrumentDone_Map1()
;@ path: item/instrument
;@ After dungeon 1: wTarinState = 2.
InstrumentDone_Map1::
;> wTarinState = 2
	ld a, $02
	ld [wTarinState], a
	ret


;@ def InstrumentDone_Map2()
;@ path: item/instrument
;@ After dungeon 2: nothing.
InstrumentDone_Map2::
;> return
	ret


;@ def InstrumentDone_Map3()
;@ path: item/instrument
;@ After dungeon 3: wIsGhostFollowingLink = 2.
InstrumentDone_Map3::
;> wIsGhostFollowingLink = 2
	ld a, $02
	ld [wIsGhostFollowingLink], a
;> return InstrumentDone_Map4()    # (runs on into it)

;@ def InstrumentDone_Map4()
;@ path: item/instrument
;@ After dungeons 4 and 7: nothing.
InstrumentDone_Map4::
;> return
	ret


;@ def InstrumentDone_Map5()
;@ path: item/instrument
;@ After dungeon 5: Marin leaves Animal Village (wIsMarinInAnimalVillage = 0).
InstrumentDone_Map5::
;> wIsMarinInAnimalVillage = 0
	xor a
	ld [wIsMarinInAnimalVillage], a
	ret


;@ def InstrumentDone_Map6()
;@ path: item/instrument
;@ After dungeon 6: the rooster stops following Link.
InstrumentDone_Map6::
;> wIsRoosterFollowingLink = 0
	xor a
	ld [wIsRoosterFollowingLink], a
	ret


;@ def InstrumentFlashPalettes(slot: bc, t: a)
;@ path: item/instrument
;@ The flash while wEntityDropTimer t is below $50: every 8 frames wEntityPrivate2 counts up to $19
;@ (noise $2C at the start); at $18 entity type $9F is spawned (role 1, timer $60). The palettes
;@ come from InstrumentFadeBGPalettes / InstrumentFadeOBJPalettes at wEntityPrivate2 + (frame & 3).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
InstrumentFlashPalettes::
;> if t >= 0x50: return
	cp $50
	jr nc, .done

;> if wEntityPrivate2[slot] >= 0x19: return
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $19
	jr nc, .done

;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palettes

;>     step = wEntityPrivate2[slot]
	ld a, [hl]
	and a
	jr nz, .count

;>     if step == 0: hNoiseSfx = 0x2C
	ld a, $2c
	ldh [hNoiseSfx], a
	xor a

.count
;>     wEntityPrivate2[slot] += 1
	inc [hl]
;>     if step == 0x18:
	cp $18
	jr nz, .palettes

;>         n, full = SpawnEntity_03(slot, 0x9F)
	ld a, $9f
	call SpawnEntity_03
;>         wEntityPrivate1[n] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>         wEntityTimer[n] = 0x60
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60

.palettes
;> i = (hFrameCounter & 3) + wEntityPrivate2[slot]
	ldh a, [hFrameCounter]
	and $03
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld e, a
;> wBGPalette = mem[InstrumentFadeBGPalettes + i]
	ld d, b
	ld hl, InstrumentFadeBGPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = mem[InstrumentFadeOBJPalettes + i]
	ld hl, InstrumentFadeOBJPalettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	xor a
	ld [wOBJ1Palette], a

.done
	ret


;@ path: item/instrument
;@ Music note sprites (role 1 of type $39), 2 variants of two 8x16 sprites (tile, attribute):
;@ 0 = tile $6C and nothing ($FF), 1 = tiles $6C and $6E.
MusicNoteSprites::
	db $6c, $00, $ff, $ff, $6c, $00, $6e, $00

;@ def MusicNoteHandler(slot: bc)
;@ path: item/instrument
;@ Role 1: a music note that flies off while the instrument plays, until its timer runs out.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
MusicNoteHandler::
;> DrawEntity16x16(slot, MusicNoteSprites)
	ld de, MusicNoteSprites
	call DrawEntity16x16
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> if GetEntityTimer(slot) == 0: return FreeEntitySlot(slot)  # frees the slot
	call GetEntityTimer
	jp z, FreeEntitySlot

	ret


;@ def InstrumentItemHandler(slot: bc)
;@ path: item/instrument
;@ Role 0, the instrument after a dungeon's boss (gone once taken, room status bit 4). Its slot goes
;@ to $D201 (wEntityScratch1); Link is kept in the arena; drawn with the variant hMapId & 3, then
;@ the state machine InstrumentStates.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
InstrumentItemHandler::
;> wEntityScratch1 = slot
	ld a, c
	ld [wEntityScratch1], a
;> if hRoomStatus & 0x10: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot

;> hActiveEntitySpriteVariant = hMapId & 3
	ldh a, [hMapId]
	and $03
	ldh [hActiveEntitySpriteVariant], a
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> DrawEntity16x16(slot, InstrumentSprites_03)
	ld de, InstrumentSprites_03
	call DrawEntity16x16
;> return InstrumentStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: item/instrument
;@ States of the instrument (wEntityState 0-4).
InstrumentStates::
	dw Instrument_Collect
	dw Instrument_StartMusic
	dw Instrument_PlayNotes
	dw Instrument_Hold
	dw Instrument_Done

;@ def Instrument_Collect(slot: bc)
;@ path: item/instrument
;@ State 0: waits for Link; when he holds it up the dungeon's message opens (dialog table 1, entry
;@ hMapId), the dungeon remembers the instrument (wDungeonFlags bit 1) and the room status gets bit 4.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Instrument_Collect::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return CollectPickupIfTouched(slot)
	jp z, CollectPickupIfTouched

;> if t == 0x10:
	cp $10
	jr nz, .hold

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     OpenDialogTable1(hMapId)
	ldh a, [hMapId]
	add $00
	call OpenDialogTable1
;>     i = hMapId
	ldh a, [hMapId]
	ld e, a
	ld d, b
;>     wDungeonFlags[i] |= 2
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	or $02
	ld [hl], a
;>     mem[GetRoomStatusAddress_03()] |= 0x10
	call GetRoomStatusAddress_03
	ld a, [hl]
	or $10
	ld [hl], a
	xor a

.hold
;> return HoldItemAboveLink(slot)
	dec a
	jr nz, .jump

.jump
	jp HoldItemAboveLink


;@ path: item/instrument
;@ Song of each dungeon's instrument (index hMapId 0-7): $20, $28, $29, ... $2E.
InstrumentMusicTracks::
	db $20, $28, $29, $2a, $2b, $2c, $2d, $2e

;@ def Instrument_StartMusic(slot: bc)
;@ path: item/instrument
;@ State 1: once the music is silent and the message closed, the instrument's song starts
;@ (InstrumentMusicTracks) and the timer is set to $FF.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Instrument_StartMusic::
;> if wActiveMusicTrack or wDialogState: return HoldItemAboveLink(slot)
	ld a, [wActiveMusicTrack]
	and a
	jr nz, .hold

	ld a, [wDialogState]
	and a
	jr nz, .hold

;> i = hMapId
	ldh a, [hMapId]
	ld e, a
	ld d, b
;> wMusicTrackToPlay = mem[InstrumentMusicTracks + i]
	ld hl, InstrumentMusicTracks
	add hl, de
	ld a, [hl]
	ld [wMusicTrackToPlay], a
;> IncrementEntityState(slot)
	call IncrementEntityState
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff

.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ path: item/instrument
;@ X offset of a new music note from the instrument, by side 0/1: +$0A, -6.
InstrumentNoteOffsetX::
	db $0a, $fa

;@ path: item/instrument
;@ X speed of a new music note by side 0/1: +4, -4.
InstrumentNoteSpeedX::
	db $04, $fc

;@ def Instrument_PlayNotes(slot: bc)
;@ path: item/instrument
;@ State 2, while the song plays: every $18 frames a music note (type $39, role 1) rises from the
;@ instrument, alternately to the right and the left, with a random sprite variant. When the timer runs
;@ out: jingle $2B and the flash (type $39, role 2, drop timer $80) is spawned.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Instrument_PlayNotes::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, .notes

;>     hJingle = 0x2B
	ld a, $2b
	ldh [hJingle], a
;>     n, full = SpawnEntity_03(slot, 0x39)
	ld a, $39
	call SpawnEntity_03
;>     wEntityX[n] = hMultiPurpose0 - 1
	ldh a, [hMultiPurpose0]
	dec a
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[n] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[n] = 2  # the flash
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityDropTimer[n] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
;>     return IncrementEntityState(slot)
	jp IncrementEntityState


.notes
;> wEntityPrivate3[slot] -= 1
	ld hl, wEntityPrivate3
	add hl, bc
	dec [hl]
;> if wEntityPrivate3[slot] != 0xFF: return HoldItemAboveLink(slot)
	ld a, [hl]
	cp $ff
	jr nz, .hold

;> wEntityPrivate3[slot] = 0x17
	ld [hl], $17
;> wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
;> side = wEntityPrivate4[slot] & 1  # kept in hMultiPurposeG
	ld a, [hl]
	and $01
	ldh [hMultiPurposeG], a
;> n, full = SpawnEntity_03(slot, 0x39)
	ld a, $39
	call SpawnEntity_03
	push bc
;> wEntityPrivate1[n] += 1  # role 1, a note
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> x = hMultiPurpose0 + mem[InstrumentNoteOffsetX + side]  # c = side from here on
	ldh a, [hMultiPurposeG]
	ld c, a
	ld hl, InstrumentNoteOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;> wEntityX[n] = x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntitySpeedX[n] = mem[InstrumentNoteSpeedX + side]
	ld hl, InstrumentNoteSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntityY[n] = hMultiPurpose1 - 8
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $f8
	ld [hl], a
;> wEntitySpeedY[n] = -3
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fd
;> wEntityTimer[n] = 0x38
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $38
;> wEntitySpriteVariant[n] = GetRandomByte() & 1
	call GetRandomByte
	and $01
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
	pop bc

.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ def Instrument_Hold(slot: bc)
;@ path: item/instrument
;@ State 3: Link holds the instrument up during the flash.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Instrument_Hold::
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ def Instrument_Done(slot: c)
;@ path: item/instrument
;@ State 4 (set by the flash when it ends): nothing more.
;@ test: slot = rand(0, 15)
Instrument_Done::
;> return
	ret


;@ path: item/pickup
;@ Sprite of dropped bombs (type $38): one 8x16 sprite, tile $80, palette 1 (tile, attribute).
DroppedBombsSprite::
	db $80, $10

;@ def DroppedBombsHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $38, bombs dropped by an enemy or hidden in the room.
;@ test: slot = rand(0, 15)
DroppedBombsHandler::
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity8x16(slot, DroppedBombsSprite)
	ld de, DroppedBombsSprite
	call DrawEntity8x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/pickup
;@ Sprite of a secret seashell (type $3D): one 8x16 sprite, tile $9E, palette 1.
SeashellSprite::
	db $9e, $10

;@ def SecretSeashellHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $3D, a secret seashell lying in the room (gone once taken, room status bit 4).
;@ Not there any more once Link's sword is level 2; in overworld room $E3 only after the room status
;@ bit 6 is set.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SecretSeashellHandler::
;> if wSwordLevel >= 2: return FreeEntitySlot(slot)  # frees the slot
	ld a, [wSwordLevel]
	cp $02
	jp nc, FreeEntitySlot

;> if hRoomStatus & 0x10: return FreeEntitySlot(slot)
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot

;> if hMapRoom == 0xE3 and not (hRoomStatus & 0x40): return FreeEntitySlot(slot)
	ldh a, [hMapRoom]
	cp $e3
	jr nz, .show

	ldh a, [hRoomStatus]
	and $40
	jp z, FreeEntitySlot

.show
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> DrawEntity8x16(slot, SeashellSprite)
	ld de, SeashellSprite
	call DrawEntity8x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/pickup
;@ Sprite of a golden leaf (type $3C): one 8x16 sprite, tile $CA, palette 1.
GoldenLeafSprite::
	db $ca, $10

;@ def GoldenLeafHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $3C, a golden leaf for Richard (gone once taken). When Link holds it up the leaf
;@ count goes up (in overworld room $C6 it becomes 6 straight away) and a message tells how many
;@ he has: $E8 normally, $E9 at 5 leaves, $A2 when all are found.
;@ test: slot = rand(0, 15)
GoldenLeafHandler::
;> if hRoomStatus & 0x10: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hRoomStatus]
	and $10
	jp nz, FreeEntitySlot

;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> DrawEntity8x16(slot, GoldenLeafSprite)
	ld de, GoldenLeafSprite
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
;>     if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr nz, .count

;>         if hMapRoom == 0xC6: wGoldenLeaves = 5
	ldh a, [hMapRoom]
	cp $c6
	jr nz, .count

	ld a, $05
	ld [wGoldenLeaves], a

.count
;>     IncrementBCD99(wGoldenLeaves)  # adds 1 to the BCD count
	ld hl, wGoldenLeaves
	call IncrementBCD99
;>     MarkRoomChestOpened()
	call MarkRoomChestOpened
;>     hRoomStatus &= ~0x10
	ld hl, hRoomStatus
	res 4, [hl]
;>     msg = 0xA2
	ld e, $a2
;>     if wGoldenLeaves != 6:
	ld a, [wGoldenLeaves]
	cp $06
	jr z, .open

;>         msg = 0xE9 if wGoldenLeaves == 5 else 0xE8
	ld e, $e8
	cp $05
	jr nz, .open

	inc e

.open
;>     OpenDialog(msg)
	ld a, e
	call OpenDialog
;>     t = 0
	xor a

.last
;> if t == 1: return FreeEntitySlot(slot)
	dec a
	jr nz, .hold

	jp FreeEntitySlot


.hold
;> return HoldItemAboveLink(slot)
	jp HoldItemAboveLink


;@ path: item/pickup
;@ Sprite of magic powder (type $3B): one 8x16 sprite, tile $8E, palette 1.
MagicPowderSprite::
	db $8e, $10

;@ def MagicPowderHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $3B, magic powder (only once Link has had the toadstool turned into powder:
;@ gone while wHasToadstool is set).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
MagicPowderHandler::
;> if wHasToadstool: return FreeEntitySlot(slot)  # frees the slot
	ld a, [wHasToadstool]
	and a
	jp nz, FreeEntitySlot

;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity8x16(slot, MagicPowderSprite)
	ld de, MagicPowderSprite
	call DrawEntity8x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ path: item/pickup
;@ Sprite of dropped arrows (type $37): two 8x16 sprites (tile, attribute): tile $2A with palette 0
;@ and attribute $40 (y-flipped), then the same x-flipped too ($60).
DroppedArrowsSprites::
	db $2a, $40, $2a, $60

;@ def DroppedArrowsHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $37, arrows dropped by an enemy.
;@ test: slot = rand(0, 15)
DroppedArrowsHandler::
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity16x16(slot, DroppedArrowsSprites)
	ld de, DroppedArrowsSprites
	call DrawEntity16x16
;> return CollectPickupIfTouched(slot)
	jp CollectPickupIfTouched


;@ def UpdatePickupLifetime(slot: bc)
;@ path: item/pickup
;@ Dropped pickups live as long as wEntityDropTimer runs (0 = forever is not possible: at 0 the slot is
;@ freed). In the last $1C frames they blink: sprite variant $FF (hidden) on even frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
UpdatePickupLifetime::
;> t = GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if t >= 0x1C: return
	cp $1c
	jr nc, .done

;> if t == 0: return FreeEntitySlot(slot)  # frees the slot
	and a
	jp z, FreeEntitySlot

;> SetEntitySpriteVariant(slot, (t & 1) - 1)
	and $01
	dec a
	call SetEntitySpriteVariant

.done
	ret


;@ path: item/pickup
;@ Sprite of a dropped rupee (type $2E): one 8x16 sprite, tile $A6, palette 1.
RupeeSprite::
	db $a6, $10

;@ def RupeeHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $2E, a rupee dropped by an enemy. Ends in CollectPickupIfTouched, the common
;@ pickup update: carried by a weapon, the collect test, movement with bouncing.
;@ test: slot = rand(0, 15)
RupeeHandler::
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity8x16(slot, RupeeSprite)
	ld de, RupeeSprite
	call DrawEntity8x16

CollectPickupIfTouched:
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> FollowCarryingWeapon(slot)  # while carried, returns from here
	call FollowCarryingWeapon
;> CheckPickupCollected(slot)
	call CheckPickupCollected
;> return UpdatePickupPhysics(slot)    # (runs on into it)

;@ def UpdatePickupPhysics(slot: bc)
;@ path: item/pickup
;@ Moves a pickup and lets it bounce: with each landing the vertical speed is halved and turned (top
;@ view: z speed; side view: y speed when the floor below is hit). A key bounce plays noise $17, a
;@ bomb (type 2) jingle 9; horizontal speeds are halved too.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
UpdatePickupPhysics::
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> UpdateEntityGravity(slot)
	call UpdateEntityGravity
;> EntityCheckWalls_03(slot)  # background collision
	call EntityCheckWalls_03
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .topView

;>     if not (wEntityCollisions[slot] & 8): return  # not on the floor
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $08
	jp z, .done

;>     wEntityY[slot] = (wEntityY[slot] & 0xF0) + 5
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	and $f0
	add $05
	ld [hl], a
;>     speed = wEntitySpeedY + slot  # an address
	ld hl, wEntitySpeedY
	add hl, bc
;>     v = u8(((mem[speed] ^ 0x7F) - 0x80) >> 1)    # the speed inverted, then a signed shift
	ld a, [hl]
	cpl
	sra a
;>     stopped = v >= 0xF8
	cp $f8
	jr c, .bounce

	jr .stop

.topView
;> else:
;>     if not (wEntityZ[slot] & 0x80): return  # still in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done

;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     g = wEntityGroundStatus[slot]
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
;>     speed = wEntitySpeedZ + slot  # an address
	ld hl, wEntitySpeedZ
	add hl, bc
;>     if g != 2:  # 2: in deep water or a hole
	cp $02
	jr z, .stop

;>         v = u8(((mem[speed] ^ 0x80) - 0x80) >> 1) ^ 0xFF   # a signed shift, then inverted
	ld a, [hl]
	sra a
	cpl
;>     stopped = g == 2 or v < 7
	cp $07
	jr nc, .bounce

.stop
;> if stopped:
;>     v = 0; wEntitySpeedX[slot] = 0
	xor a
	push hl
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop hl
	jr .store

.bounce
;> else:
	push af
	push hl
;>     if hActiveEntityType == 0x30: hNoiseSfx = 0x17  # a key
	ldh a, [hActiveEntityType]
	cp $30
	jr nz, .bomb

	ld a, $17
	ldh [hNoiseSfx], a
	jr .sfxDone

.bomb
;>     elif hActiveEntityType == 2:  # a bomb
	cp $02
	jr nz, .sfxDone

;>         s = wEntityStatus[slot]
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
;>         if s not in (0, 2): hJingle = 9
	and a
	jr z, .sfxDone

	cp $02
	jr z, .sfxDone

	ld a, $09
	ldh [hJingle], a

;> mem[speed] = v
.sfxDone
	pop hl
	pop af

.store
	ld [hl], a
;> s = u8(((wEntitySpeedX[slot] ^ 0x80) - 0x80) >> 1)    # a signed shift
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	sra a
;> wEntitySpeedX[slot] = 0 if s == 0xFF else s
	cp $ff
	jr nz, .storeX

	xor a

.storeX
	ld [hl], a
;> if hIsSideScrolling: return
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .done

;> s = u8(((wEntitySpeedY[slot] ^ 0x80) - 0x80) >> 1)    # a signed shift
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sra a
;> wEntitySpeedY[slot] = 0 if s == 0xFF else s
	cp $ff
	jr nz, .storeY

	xor a

.storeY
	ld [hl], a

.done
	ret


;@ path: item/pickup
;@ Sprite of a fairy (type $2F) by sprite variant: one 8x16 sprite each (tile, attribute): 0 = tile
;@ $20 x-flipped, 1 = tile $20.
FairySprites::
	db $20, $20, $20, $00

;@ def FairyHandler(slot: bc)
;@ path: item/pickup
;@ Handler of type $2F, a fairy. It faces its x direction, flies at a height of $10, and while Link is
;@ within $20 pixels it changes its course at random every $30 frames; farther away it flies towards
;@ him (SetEntitySpeedTowardsLink_03 with speed 9).
;@ test: slot = rand(0, 15)
FairyHandler::
;> CheckHiddenPickup(slot)
	call CheckHiddenPickup
;> UpdatePickupLifetime(slot)
	call UpdatePickupLifetime
;> DrawEntity8x16(slot, FairySprites)
	ld de, FairySprites
	call DrawEntity8x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> FollowCarryingWeapon(slot)
	call FollowCarryingWeapon
;> CheckPickupCollected(slot)
	call CheckPickupCollected
;> SetEntitySpriteVariant(slot, wEntitySpeedX[slot] >> 7)
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	rlca
	and $01
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> UpdateFairyHeight(slot)
	call UpdateFairyHeight
;> EntityCheckWalls_03(slot)  # background collision
	call EntityCheckWalls_03
;> dx = GetEntityXDistanceToLink_03(slot)  # the sign test that follows has no effect
	call GetEntityXDistanceToLink_03
	ld a, d
	bit 7, a
	jr z, .xDone

.xDone
;> near = dx < 0x20
	cp $20
	jr c, .wander

;> if not near:
;>     dy = GetEntityYDistanceToLink_03(slot)
	call GetEntityYDistanceToLink_03
	ld a, d
	bit 7, a
	jr z, .yDone

.yDone
;>@toLink     if dy >= 0x20: return SetEntitySpeedTowardsLink_03(slot, 9)  # flies towards Link
	cp $20
	jr nc, .toLink

.wander
;> if GetEntityTimer(slot): return  # near Link: a new random course every $30 frames
	call GetEntityTimer
	jr nz, .done

;> wEntityTimer[slot] = 0x30
	ld [hl], $30
;> wEntitySpeedX[slot] = (GetRandomByte() & 0x0F) - 8
	call GetRandomByte
	and $0f
	sub $08
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = (GetRandomByte() & 0x0F) - 8
	call GetRandomByte
	and $0f
	sub $08
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> return
	jr .done

.toLink
;=@toLink
	ld a, $09
	call SetEntitySpeedTowardsLink_03

.done
	ret


;@ def UpdateFairyHeight(slot: bc)
;@ path: item/pickup
;@ Every 4 frames moves the fairy's height one pixel towards $10.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
UpdateFairyHeight::
;> if hFrameCounter & 3: return
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done

;> z = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
;> if z == 0x10: return
	cp $10
	jr z, .done

;> if z & 0x80: wEntityZ[slot] += 1; return   # below the floor (negative): up
	bit 7, a
	jr z, .positive

	inc [hl]
	jr .done

.positive
;> if z < 0x10: wEntityZ[slot] += 1; return
	cp $10
	jr nc, .down

	inc [hl]
	ret


.down
;> wEntityZ[slot] -= 1
	dec [hl]

.done
	ret


;@ def CheckHiddenPickup(slot: bc)
;@ path: item/pickup
;@ A pickup can be hidden (wEntityPrivate3): 1 = up in a tree, it falls when Link dashes into the
;@ tree within 16 pixels of it; 2 = under a room object, it appears once the object under it has
;@ become object $04 or $CC (outdoors only, except secret seashells; hearts and most seashells need
;@ $04 or $CC, the other pickups and the seashells of overworld rooms $DA, $A5, $74, $3A, $A8 and
;@ $B2 only $CC). While hidden the rest of the caller is skipped. When it comes out it hops away from
;@ Link (speed $0C, z speed $20) and lives for $80 frames.
;@ test: slot = rand(0, 15)
CheckHiddenPickup::
;> h = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
;> if h == 0: return
	and a
	jp z, .done

;> if wRoomTransitionState: return_from_caller()
	ld a, [wRoomTransitionState]
	and a
	jp nz, .hidden

;> if h == 2:
	ld a, [hl]
	cp $02
	jr nz, .inTree

;>     if hActiveEntityType != 0x3D and wIsIndoor: return_from_caller()
	ldh a, [hActiveEntityType]
	cp $3d
	jr z, .readObject

	ld a, [wIsIndoor]
	and a
	jp nz, .hidden

.readObject
;>     GetObjectUnderEntity_03(slot)  # hRoomObjectType = the object under the entity
	call GetObjectUnderEntity_03
;>     if hActiveEntityType == 0x2D: needs4 = True
	ldh a, [hActiveEntityType]
	cp $2d
	jr z, .needs4

;>     elif hActiveEntityType != 0x3D: needs4 = False
	cp $3d
	jr nz, .onlyCC

;>     else:  # a seashell
;>         r = hMapRoom
	ldh a, [hMapRoom]
;>         if r in (0xDA, 0xA5, 0x74): needs4 = False
	cp $da
	jr z, .onlyCC

	cp $a5
	jr z, .onlyCC

	cp $74
	jr z, .onlyCC

;>         elif r in (0x3A, 0xA8, 0xB2): needs4 = False  # else needs4 = True
	cp $3a
	jr z, .onlyCC

	cp $a8
	jr z, .onlyCC

	cp $b2
	jr z, .onlyCC

.needs4
;>     if needs4 and hRoomObjectType == 4: wEntityOptions1[slot] = 0x0A; release()
	ldh a, [hRoomObjectType]
	cp $04
	jr z, .appear

	jr .checkCC

.onlyCC
;>     if not needs4: wEntityPrivate4[slot] = 1
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], $01

.checkCC
;>     if hRoomObjectType != 0xCC: return_from_caller()
	ldh a, [hRoomObjectType]
	cp $cc
	jr nz, .hidden

.appear
;>     wEntityOptions1[slot] = 0x0A
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $0a
;>     release()
	jr .release

.inTree
;> else:
;>     if not wBumpShakeTimer or not wDashBumpFrames: return_from_caller()
	ld a, [wBumpShakeTimer]
	and a
	jr z, .hidden

	ld a, [wDashBumpFrames]
	and a
	jr z, .hidden

;>     dx = hActiveEntityX + 8 - wDashBumpX
	ldh a, [hActiveEntityX]
	add $08
	ld hl, wDashBumpX
	sub [hl]
;>     if (dx + 0x10) & 0xFF >= 0x20: return_from_caller()
	add $10
	cp $20
	jr nc, .hidden

;>     dy = hActiveEntityY + 8 - wDashBumpY
	ldh a, [hActiveEntityY]
	add $08
	ld hl, wDashBumpY
	sub [hl]
;>     if (dy + 0x10) & 0xFF >= 0x20: return_from_caller()
	add $10
	cp $20
	jr nc, .hidden

.release
;> release: wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
;> wEntityPrivate4[slot] = 0
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
;> wEntityTimer1[slot] = 0x18  # not collectable for a moment
	call GetEntityTimer1
	ld [hl], $18
;> GetVectorTowardsLink_03(slot, 0x0C)  # hMultiPurpose0/1 = y/x speed towards Link
	ld a, $0c
	call GetVectorTowardsLink_03
;> wEntitySpeedX[slot] = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;> wEntityDropTimer[slot] = 0x80
	call GetEntityDropTimer
	ld [hl], $80

.hidden
;> return_from_caller()
	pop af

.done
	ret


;@ path: item/pickup
;@ One byte per pickup type $2D-$3D (index type - $2D): 1 = Link's sword collects it too (the hit test
;@ EntityCheckWeaponHits_03 runs for it in CheckPickupCollected), 0 = only touching it does. Set for hearts,
;@ rupees, the sword, the Piece of Power, the Guardian Acorn, arrows, bombs and magic powder.
PickupSwordCollectable::
	db $01, $01, $00, $00, $01, $00, $01, $01, $00, $00, $01, $01, $00, $00, $01, $00
	db $00

;@ def FollowCarryingWeapon(slot: bc)
;@ path: item/pickup
;@ wEntityPrivate5 = 1 + slot of the weapon that has caught the pickup (boomerang or hookshot). While
;@ that weapon (type 1 or 3) still flies the pickup sits on it and the rest of the caller is skipped;
;@ once it is gone, Link gets the pickup.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: hActiveEntityType = rand(0x2D, 0x3D)
FollowCarryingWeapon::
;> carrier = wEntityPrivate5[slot]
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
;> if carrier == 0: return
	and a
	jr z, .done

;> w = carrier - 1  # the caller's return address is dropped: returning now also leaves the caller
	pop de
	dec a
	ld e, a
	ld d, b
;> if wEntityStatus[w] == 0: return CollectPickup(slot)
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, CollectPickup.markEntityDefeated

;> t = wEntityType[w]
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
;> if t not in (1, 3): return CollectPickup(slot)  # not the boomerang or the hookshot
	cp $01
	jr z, .follow

	cp $03
	jr nz, CollectPickup.markEntityDefeated

.follow
;> wEntityX[slot] = wEntityX[w]
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = wEntityY[w]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityZ[slot] = 0
	xor a
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a

.done
.return
	ret


;@ def CheckPickupCollected(slot: bc)
;@ path: item/pickup
;@ Unless wEntityTimer1 still runs: for the types marked in PickupSwordCollectable the sword hit
;@ test runs first; when Link touches the pickup (EntityCheckContactDamage_03) it is collected.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
CheckPickupCollected::
;> if GetEntityTimer1(slot): return
	call GetEntityTimer1
	jr nz, FollowCarryingWeapon.return

;> i = hActiveEntityType - 0x2D
	ldh a, [hActiveEntityType]
	sub $2d
	ld e, a
	ld d, b
;> if mem[PickupSwordCollectable + i]:
	ld hl, PickupSwordCollectable
	add hl, de
	ld a, [hl]
	and a
	jr z, .touch

;>     saved = wEntityIgnoreHitsTimer[slot]
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	push af
	push hl
;>     wEntityIgnoreHitsTimer[slot] = 0
	ld [hl], b
;>     EntityCheckWeaponHits_03(slot)  # hit test against Link's weapons
	call EntityCheckWeaponHits_03
;>     wEntityIgnoreHitsTimer[slot] = saved
	pop hl
	pop af
	ld [hl], a

.touch
;> if not EntityCheckContactDamage_03(slot): return  # carry: touches Link
	call EntityCheckContactDamage_03
	jr nc, FollowCarryingWeapon.return
;> return CollectPickup(slot)    # (runs on into it)

;@ def CollectPickup(slot: bc)
;@ path: item/pickup
;@ Link takes the pickup: it is marked as taken (MarkEntityDefeated with its wEntityLoadOrder, so it does not
;@ come back), a sound plays (jingle $14 for hearts and rupees, wave sound 1 otherwise) and the
;@ type's effect runs (PickupCollectEffects).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: hActiveEntityType = rand(0x2D, 0x3D)
;@ test: wIsIndoor = rand(0, 1)
CollectPickup::
.markEntityDefeated
;> MarkEntityDefeated(slot, wEntityLoadOrder[slot])
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	call MarkEntityDefeated
;> i = hActiveEntityType - 0x2D
	ldh a, [hActiveEntityType]
	sub $2d
;> if i < 2: hJingle = 0x14
	cp $02
	jr nc, .wave

	ld hl, hJingle
	ld [hl], $14
	jr .effect

.wave
;> else: hWaveSfx = 1
	ld hl, hWaveSfx
	ld [hl], $01

.effect
;> return PickupCollectEffects[i](slot)
	rst $00

;@ path: item/pickup
;@ What collecting does, by type $2D-$3D (index type - $2D).
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

;@ def Collect_MagicPowder(slot: bc)
;@ path: item/pickup
;@ Type $3B: background change $0B, magic powder goes in the inventory and its count goes up by one
;@ (not above wMaxMagicPowder).
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15); wMagicPowderCount = to_bcd(rand(0, 98)); wMaxMagicPowder = to_bcd(rand(0, 99))
Collect_MagicPowder::
;> hBGChangeRequest = 0x0B
	ld a, $0b
	ldh [hBGChangeRequest], a
;> GiveInventoryItem(0x0C)
	ld d, $0c
	call GiveInventoryItem
;> count, limit = addr(wMagicPowderCount), addr(wMaxMagicPowder)   # AddOneUpToMax: one more, up to the maximum
	ld hl, wMaxMagicPowder
	ld de, wMagicPowderCount

AddOneUpToMax:
;> if mem[count] >= mem[limit]: return
	ld a, [de]
	cp [hl]
	jr nc, .done

;> mem[count] = to_bcd(bcd_to_int(mem[count]) + 1)
	add $01
	daa
	ld [de], a

.done
	ret


;@ def Collect_Seashell(slot: bc)
;@ path: item/pickup
;@ Type $3D: message $EF and one more seashell.
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
;@ test: wIsIndoor = rand(0, 1)
Collect_Seashell::
;> OpenDialog(0xEF)
;> return AddSeashell()                       # (runs on into it)
	ld a, $ef
	call OpenDialog

;@ def AddSeashell()
;@ path: item/pickup
;@ The room remembers its seashell and wSeashells goes up by one (BCD, at most 99). Also used for the
;@ seashells in chests.
;@ test: wCurrentBank = $03
;@ test: wIsIndoor = rand(0, 1)
AddSeashell::
;> MarkRoomChestOpened()
	call MarkRoomChestOpened
;> return IncrementBCD99(addr(wSeashells))
	ld hl, wSeashells

;@ def IncrementBCD99(p: hl)
;@ path: item/pickup
;@ Adds 1 to the BCD byte at p unless it is $99.
;@ test: wCurrentBank = $03
;@ test: p = rand_ram(1); mem[p] = to_bcd(rand(0, 99))
IncrementBCD99::
;> if mem[p] == 0x99: return
	ld a, [hl]
	cp $99
	jr z, .done

;> mem[p] = to_bcd(bcd_to_int(mem[p]) + 1)
	add $01
	daa
	ld [hl], a

.done
	ret


;@ def Collect_Arrows(slot: bc)
;@ path: item/pickup
;@ Type $37: one more arrow, up to wMaxArrows.
;@ test: slot = rand(0, 15)
Collect_Arrows::
;> return AddOneUpToMax(wArrowCount, wMaxArrows)
	ld hl, wMaxArrows
	ld de, wArrowCount
	jr AddOneUpToMax

;@ def Collect_Bombs(slot: bc)
;@ path: item/pickup
;@ Type $38: bombs go in the inventory (item 2) and one more bomb, up to wMaxBombs.
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
Collect_Bombs::
;> GiveInventoryItem(2)
	ld d, $02
	call GiveInventoryItem
;> return AddOneUpToMax(wBombCount, wMaxBombs)
	ld hl, wMaxBombs
	ld de, wBombCount
	jr AddOneUpToMax

;@ def Collect_Instrument(slot: bc)
;@ path: item/pickup
;@ Type $39: the instrument fanfare (music $1B; Link frozen), sparkles around Link, and Link holds it
;@ up for $68 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Collect_Instrument::
;> wIndoorAltMusic = 0
	xor a
	ld [wIndoorAltMusic], a
;> wRoomHasTorches = 0
	ld [wRoomHasTorches], a
;> wMusicTrackToPlay = 0x1B
	ld a, $1b
	ld [wMusicTrackToPlay], a
;> wLinkFrozen = 0x1B
	ld [wLinkFrozen], a
;> return ShowItemWithSparkles(slot)    # (runs on into it)

;@ def ShowItemWithSparkles(slot: bc)
;@ path: item/pickup
;@ Sparkles around a point 4 pixels right of Link, then Link holds the item up (ShowPickupPose).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ShowItemWithSparkles::
;> saved = hLinkX
	ldh a, [hLinkX]
	push af
;> hLinkX = saved + 4
	add $04
	ldh [hLinkX], a
;> SpawnSparklesAroundLink()
	call SpawnSparklesAroundLink
;> hLinkX = saved
	pop af
	ldh [hLinkX], a
;> return ShowPickupPose(slot)
	jr ShowPickupPose

;@ def Collect_HeartContainer(slot: bc)
;@ path: item/pickup
;@ Type $36: an active power-up ends, music $25 plays, and Link holds the container up for $70
;@ frames.
;@ test: slot = rand(0, 15)
Collect_HeartContainer::
;> wActivePowerUp = 0
	xor a
	ld [wActivePowerUp], a
;> wMusicTrackToPlay = 0x25
	ld a, $25
	ld [wMusicTrackToPlay], a
;> wIndoorAltMusic = 0x25
	ld [wIndoorAltMusic], a
;> wEntityTimer[slot] = 0x70
	call GetEntityTimer
	ld a, $70
	ld [hl], a
;> wLinkPoseLock = 0x70
	ld [wLinkPoseLock], a
;> return SetPickupHeld(slot)
	jr SetPickupHeld

;@ def Collect_WithFanfare(slot: bc)
;@ path: item/pickup
;@ Types $3A (Sleepy Toadstool) and $3C (golden leaf): jingle music $10, Link holds it up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Collect_WithFanfare::
;> wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;> return ShowPickupPose(slot)
	jr ShowPickupPose

;@ path: item/pickup
;@ Four bytes no code reaches: `ld a, 1` / `ldh [$FFF2], a`.
UnusedPickupCode::
	db $3e, $01, $e0, $f2

;@ def ShowPickupPose(slot: bc)
;@ path: item/pickup
;@ Link holds the pickup up for $68 frames (wEntityTimer and wLinkPoseLock); the pickup goes back to
;@ status 5 (it may have been carried or lifted) and Link's spin attack and dash end.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ShowPickupPose::
.setEntityTimer
;> wEntityTimer[slot] = 0x68
	call GetEntityTimer
	ld a, $68
	ld [hl], a
;> wLinkPoseLock = 0x68
	ld [wLinkPoseLock], a

SetPickupHeld:
;> wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> return ResetSpinAttackAndDash()
	jp ResetSpinAttackAndDash


;@ def Collect_HeartPiece(slot: bc)
;@ path: item/pickup
;@ Type $35: music $10; the piece goes to its next state (Link holds it up).
;@ test: slot = rand(0, 15)
Collect_HeartPiece::
;> wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return SetPickupHeld(slot)
	jr SetPickupHeld

;@ path: item/pickup
;@ X offsets of the four sparkles around Link (SpawnSparklesAroundLink, index 0-3): -$1C, +$14,
;@ -$1C, +$14.
SparkleOffsetX::
	db $e4, $14, $e4, $14

;@ path: item/pickup
;@ Y offsets of the four sparkles: -$2C, -$2C, +4, +4.
SparkleOffsetY::
	db $d4, $d4, $04, $04

;@ def Collect_GuardianAcorn(slot: bc)
;@ path: item/pickup
;@ Type $34: power-up 2 (defence), Link's show-item pose 5.
;@ test: slot = rand(0, 15)
Collect_GuardianAcorn::
;> powerUp = 2; pose = 5
	ld a, $02
	ld e, $05
;> return StartPowerUp(powerUp, pose)
	jr StartPowerUp

;@ def Collect_PieceOfPower(slot: bc)
;@ path: item/pickup
;@ Type $33: power-up 1 (attack), pose 1. Shared tail StartPowerUp: Link shows the item for $30
;@ frames, the power-up music ($27, then $49 as the room music) starts and sparkles appear.
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
Collect_PieceOfPower::
;> powerUp = 1; pose = 1
	ld a, $01
	ld e, $01

StartPowerUp:
;> wActivePowerUp = powerUp
	ld [wActivePowerUp], a
;> wLinkShowItemPose = pose
	ld a, e
	ld [wLinkShowItemPose], a
;> wLinkShowItemTimer = 0x30
	ld a, $30
	ld [wLinkShowItemTimer], a
;> wLinkPoseLock = 0x30
	ld [wLinkPoseLock], a
;> wPowerUpHits = 0
	xor a
	ld [wPowerUpHits], a
;> wMusicTrackToPlay = 0x27
	ld a, $27
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrackAlt = 0x49
	ld a, $49
	ldh [hDefaultMusicTrackAlt], a
;> hLastMusicTrack = 0x49
	ldh [hLastMusicTrack], a
;> return SpawnSparklesAroundLink()    # (runs on into it)

;@ def SpawnSparklesAroundLink()
;@ path: item/pickup
;@ Spawns four sparkle effects (transient effect 7, $22 frames) around Link, at SparkleOffsetX/Y,
;@ each with its index as direction.
;@ test: wCurrentBank = $03
SpawnSparklesAroundLink::
;> for i in range(3, -1, -1):
	ld e, $03
	ld d, $00

.loop
	push de
;>     hMultiPurpose0 = hLinkX + mem[SparkleOffsetX + i]
	ld hl, SparkleOffsetX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hLinkY + mem[SparkleOffsetY + i]
	ld hl, SparkleOffsetY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hMultiPurpose1], a
;>     v = AddTransientVfx(7)
	ld a, $07
	call AddTransientVfx
;>     wVfxTimer[v] = 0x22
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $22
;>     wVfxDirection[v] = i
	ld hl, wVfxDirection
	add hl, de
	pop de
	ld [hl], e
;>     continue  # next i
	dec e
	ld a, e
	cp $ff
	jr nz, .loop

;@ def Collect_Type32(slot: bc)
;@ path: item/pickup
;@ Type $32: nothing happens.
;@ test: slot = rand(0, 15)
Collect_Type32::
;> return
	ret


;@ def Collect_Sword(slot: bc)
;@ path: item/pickup
;@ Type $31. Without a sword: music $0F, sparkles, Link holds it up for $A0 frames (SwordHandler does
;@ the rest). With a sword it is a shield: wShieldLevel = wEntityPrivate1 and the shield (item 4)
;@ goes in the inventory.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Collect_Sword::
;> if not wSwordLevel:
	ld a, [wSwordLevel]
	and a
	jr nz, .shield

;>     wMusicTrackToPlay = 0x0F
	ld a, $0f
	ld [wMusicTrackToPlay], a
;>     wLinkFrozen = 0x0F
	ld [wLinkFrozen], a
;>     ShowItemWithSparkles(slot)
	call ShowItemWithSparkles
;>     wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;>     hLastMusicTrack = 0xFF
	ld a, $ff
	ldh [hLastMusicTrack], a
;>     return
	ret


.shield
;> wShieldLevel = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld [wShieldLevel], a
;> return GiveInventoryItem(4)
	ld d, $04

;@ def GiveInventoryItem(item: d)
;@ path: item/inventory
;@ Puts an item id in the first empty one of the 12 item slots (wItemB, wItemA, then the subscreen),
;@ unless Link already has it.
;@ test: wCurrentBank = $03
GiveInventoryItem::
;> for i in range(12):
	ld hl, wItemB
	ld e, $0c

.find
;>     if mem[addr(wItemB) + i] == item: return
	ld a, [hli]
	cp d
	jr z, .done

	dec e
	jr nz, .find

;> p = addr(wItemB)
	ld hl, wItemB

.empty
;> for i in range(12):
;>     if mem[p + i] == 0: mem[p + i] = item; return
	ld a, [hl]
	and a
	jr nz, .next

	ld [hl], d
	ret


.next
;>     continue  # next i
	inc hl
	inc e
	ld a, e
	cp $0c
	jr nz, .empty

.done
	ret


;@ def Collect_Key(slot: bc)
;@ path: item/pickup
;@ Type $30. In room $80 (an item, see KeyDropPoint_Room80) and for key variants 1-5: music $10 and
;@ Link holds it up. In overworld room $7C it also sets room $169's status bit 4. Variant 0 is a small
;@ key: the room remembers it, and wDungeonSmallKeys goes up and is saved.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
Collect_Key::
;> if hMapRoom == 0x80:
	ldh a, [hMapRoom]
	cp $80
	jr nz, .notRoom80

;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>     return ShowPickupPose(slot)
	jp ShowPickupPose


.notRoom80
;> if hMapRoom == 0x7C: wRoomStatus[0x169] |= 0x10
	ldh a, [hMapRoom]
	cp $7c
	jr nz, .variant

	ld hl, wRoomStatus + $169
	set 4, [hl]

.variant
;> if hActiveEntitySpriteVariant:
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, .smallKey

;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>     return ShowPickupPose(slot)
	jp ShowPickupPose


.smallKey
;> MarkRoomChestOpened()
	call MarkRoomChestOpened
;> wDungeonSmallKeys += 1
	ld hl, wDungeonSmallKeys
	inc [hl]
;> SaveDungeonItemFlags()
	call SaveDungeonItemFlags
	ret


;@ def Collect_Heart(slot: bc)
;@ path: item/pickup
;@ Type $2D: one heart of health (8 eighths) is added.
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
Collect_Heart::
;> n = 8
	ld a, $08

AddHealth:
;> buffer = addr(wAddHealthBuffer)
	ld hl, wAddHealthBuffer

AddToBuffer:
;> mem[buffer] += n
	add [hl]
	ld [hl], a
	ret


;@ def Collect_Rupee(slot: bc)
;@ path: item/pickup
;@ Type $2E: one rupee.
;@ test: slot = rand(0, 15)
Collect_Rupee::
;> return AddToBuffer(wAddRupeeBufferLow, 1)
	ld a, $01
	ld hl, wAddRupeeBufferLow
	jr AddToBuffer

;@ def Collect_Fairy(slot: bc)
;@ path: item/pickup
;@ Type $2F: six hearts of health ($30 eighths).
;@ test: slot = rand(0, 15)
Collect_Fairy::
;> return AddHealth(0x30)
	ld a, $30
	jr AddHealth

;@ def SpawnEntity_03(slot: bc, type: a) -> (de, carry)
;@ path: entity/spawn
;@ Spawns an entity of the given type in the highest free slot (15 down to 0): status 5, type, the
;@ properties of the type. hMultiPurpose0-3 get the spawner's (slot c) x, y, direction and height,
;@ so the caller can place the new entity; it takes the spawner's high position bytes and ignores
;@ hits for a frame. Returns the new slot in de; carry set when no slot was free.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SpawnEntity_03::
;> return SpawnEntityFromSlot_03(slot, type, 15)   # (runs on into it with e = 15)
	ld e, $0f

;@ def SpawnEntityFromSlot_03(slot: bc, type: a, e: e) -> (de, carry)
;@ path: entity/spawn
;@ Same as SpawnEntity_03 but searches the slots from e downwards.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: e = rand(0, 15)
SpawnEntityFromSlot_03::
;> for n in range(e, -1, -1):
	push af
	ld d, $00

.find
;>     if wEntityStatus[n] == 0: break
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .found

;>     continue  # next n
	dec e
	ld a, e
	cp $ff
	jr nz, .find

;> else: return 0xFF, True                 # no free slot: carry set, de = $00FF
	pop af
	scf
	ret


.found
;> wEntityStatus[n] = 5
	ld [hl], $05
;> wEntityType[n] = type
	pop af
	ld hl, wEntityType
	add hl, de
	ld [hl], a
;> hMultiPurpose0 = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose2 = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose3], a
;> InitSpawnedEntityProperties(n)
	call InitSpawnedEntityProperties
;> wEntityIgnoreHitsTimer[n] = 1
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], $01
;> wEntityPosXHigh[n] = wEntityPosXHigh[slot]
	ld hl, wEntityPosXHigh
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPosXHigh
	add hl, de
	ld [hl], a
;> wEntityPosYHigh[n] = wEntityPosYHigh[slot]
	ld hl, wEntityPosYHigh
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPosYHigh
	add hl, de
	ld [hl], a
;> return n, False  # carry clear
	scf
	ccf
	ret


;@ def InitSpawnedEntityProperties(n: de)
;@ path: entity/spawn
;@ Runs InitEntityProperties for slot n, keeping bc and de.
;@ test: wCurrentBank = $03
;@ test: n = rand(0, 15)
InitSpawnedEntityProperties::
;> InitEntityProperties(slot=n)
	push bc
	push de
	push de
	pop bc
	call InitEntityProperties
;> return  # bc and de as before
	pop de
	pop bc
	ret


;@ path: item/bomb
;@ The bomb (type 2): one 8x16 sprite (tile, attribute), tile $80, palette 1.
BombSprite::
	db $80, $10

;@ path: item/bomb
;@ The explosion, 4 stages (sprite variant 0-3, see BombExplosionStages) of 8 OAM entries each (y offset,
;@ x offset, tile, attributes), 32 bytes per stage: 0 = eight $32 puffs around the centre, 1 = a burst
;@ of tiles $10/$12 mirrored four ways, 2 and 3 = eight $30 puffs close together.
BombExplosionSprites::
	db $f8, $f8, $32, $00, $f8, $00, $32, $20, $f8, $08, $32, $00, $f8, $10
	db $32, $20, $08, $f8, $32, $00, $08, $00, $32, $20, $08, $08, $32, $00, $08, $10
	db $32, $20, $f8, $f8, $10, $00, $f8, $00, $12, $00, $f8, $08, $12, $20, $f8, $10
	db $10, $20, $08, $f8, $10, $40, $08, $00, $12, $40, $08, $08, $12, $60, $08, $10
	db $10, $60, $fc, $fc, $30, $10, $fc, $04, $30, $30, $fc, $04, $30, $10, $fc, $0c
	db $30, $30, $04, $fc, $30, $10, $04, $04, $30, $30, $04, $04, $30, $10, $04, $0c
	db $30, $30, $fc, $fc, $30, $00, $fc, $04, $30, $20, $fc, $04, $30, $00, $fc, $0c
	db $30, $20, $04, $fc, $30, $00, $04, $04, $30, $20, $04, $04, $30, $00, $04, $0c
	db $30, $20

;@ def DrawBombExplosion(slot: bc)
;@ path: item/bomb
;@ Draws the 8 sprites of the explosion stage wEntitySpriteVariant (BombExplosionSprites).
;@ test: slot = rand(0, 15)
DrawBombExplosion::
;> stage = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
;> offset = stage * 32
	sla a
	sla a
	sla a
	sla a
	sla a
;> p = BombExplosionSprites + offset
	ld e, a
	ld d, b
	ld hl, BombExplosionSprites
	add hl, de
;> DrawEntitySprites(p, 8)
	ld c, $08
	call DrawEntitySprites
	ret


;@ path: item/bomb
;@ Explosion stage by the bomb's wEntityTimer 0-$17: stage 0 for 0-7, 1 for 8-$0F, 2 for $10-$13,
;@ 3 for $14-$17 (the timer counts down, so stage 3 comes first).
BombExplosionStages::
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $03, $03, $03, $03

;@ def BombExploding(slot: bc, t: a)
;@ path: item/bomb
;@ The bomb's last $18 frames (wEntityTimer t): the explosion is drawn. From t $16 down to $0E one
;@ of the nine 16x16 squares around the bomb is hit per frame (objects and entities there, see
;@ BombDestroyObject and BombBlastBackground). At t $12 Link is hurt when he is near (enemy bombs,
;@ wEntityPrivate4 set) or the bomb checks him through BombHitsEntities (Link's own), and the screen
;@ shakes. A bomb with wEntityPrivate4 = $4C hits nothing.
;@ test: slot = rand(0, 15)
BombExploding::
;> UpdateBombExplosion(slot)
	call UpdateBombExplosion
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return FreeEntitySlot(slot)  # frees the slot
	and a
	jp nz, .running

	jp FreeEntitySlot


.running
;> p4 = wEntityPrivate4[slot]
	ld e, a
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
;> if p4 == 0x4C: return
	cp $4c
	ld a, e
	jp z, .done

;> if 0x0E <= t < 0x17:
	cp $0e
	jr c, .hurtLink

	cp $17
	jr nc, .hurtLink

;>     i = t - 0x0E
	push af
	sub $0e
	ld e, a
	ld d, b
;>     BombDestroyObject(slot, i)
	push de
	call BombDestroyObject
	pop de
;>     BombBlastBackground(slot, i)
	call BombBlastBackground
	pop af

.hurtLink
;> if t != 0x12: return
	cp $12
	jr nz, .done

;> p4 = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
;> if p4 == 0: BombHitsEntities(slot)
	and a
	jr nz, .enemyBomb

	call BombHitsEntities
	jr .shake

.enemyBomb
;> elif (hActiveEntityX - hLinkX + 0x18) & 0xFF < 0x30:
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $18
	cp $30
	jr nc, .shake

;>     if (hActiveEntityY - hLinkY + 0x18) & 0xFF < 0x30:
	ldh a, [hActiveEntityY]
	ld hl, hLinkY
	sub [hl]
	add $18
	cp $30
	jr nc, .shake

;>         HurtLink(slot)  # Link is hit
	call HurtLink
;>         hLinkSpeedX <<= 1
	ld hl, hLinkSpeedX
	sla [hl]
;>         hLinkSpeedY <<= 1
	ld hl, hLinkSpeedY
	sla [hl]

.shake
;> wClinkTimer = 4
	ld a, $04
	ld [wClinkTimer], a

.done
	ret


;@ def UpdateBombExplosion(slot: bc)
;@ path: item/bomb
;@ Picks the explosion stage for the timer, sets the low nibble of wEntityPhysicsFlags to 8 and draws
;@ it. Indoors the background palette flashes: $E4 normally, $84 while timer bit 2 is set (not during
;@ a room transition).
;@ test: slot = rand(0, 15)
UpdateBombExplosion::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> SetEntitySpriteVariant(slot, mem[BombExplosionStages + t])
	ld e, a
	ld d, b
	ld hl, BombExplosionStages
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> wEntityPhysicsFlags[slot] = (wEntityPhysicsFlags[slot] & 0xF0) | 8
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
;> DrawBombExplosion(slot)
	call DrawBombExplosion
;> if not wIsIndoor: return
	ld a, [wIsIndoor]
	and a
	jr z, .done

;> bgp = 0xE4
	ld e, $e4
;> if not wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
	jr nz, .set

;>     if GetEntityTimer(slot) & 4: bgp = 0x84
	call GetEntityTimer
	and $04
	jr z, .set

	ld e, $84

.set
;> wBGPalette = bgp
	ld hl, wBGPalette
	ld [hl], e

.done
	ret


;@ def DrawBombSmoke(slot: bc)
;@ path: item/bomb
;@ Draws the puff of the bomb about to explode.
;@ test: wCurrentBank = $03
;@ test: slot = rand(0, 15)
DrawBombSmoke::
;> DrawEntity16x16(slot, BombSmokeSprite)
	ld de, BombSmokeSprite
	call DrawEntity16x16
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
	ret


;@ def BombHandler(slot: bc)
;@ path: item/bomb
;@ Handler of type 2, a bomb. wEntityTimer counts down to the explosion: from $48 it flashes, $22-$18
;@ shows the puff, below $18 it explodes (BombExploding). Until then it is drawn, can fall into the
;@ hole of room $CE, moves and bounces like a pickup, and Link can pick it up again with the button of
;@ his bombs (B = $20, A = $10) unless wEntityTimer1 or wEntityPrivate4 is set. Walls stop its
;@ speed. It vanishes when it leaves the bottom of the screen.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
BombHandler::
;> if hActiveEntityDrawY + 0x10 >= 0xA0: return FreeEntitySlot(slot)  # frees the slot
	ldh a, [hActiveEntityDrawY]
	add $10
	cp $a0
	jp nc, FreeEntitySlot

;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t < 0x18: return BombExploding(slot, t)
	cp $18
	jp c, BombExploding

;> if t == 0x18:
	jr nz, .counting

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     PlayClinkNoise()
	call PlayClinkNoise

.counting
;> wBombsOnScreen += 1
	ld hl, wBombsOnScreen
	inc [hl]
;> if t < 0x22: return DrawBombSmoke(slot)
	cp $22
	jr c, DrawBombSmoke

;> if t == 0x48: wEntityFlashTimer[slot] = 0x30
	cp $48
	jr nz, .draw

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $30

.draw
;> DrawBomb(slot)
	call DrawBomb
;> CheckKeyFallsInPit(slot)
	call CheckKeyFallsInPit
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> UpdatePickupPhysics(slot)
	call UpdatePickupPhysics
;> wEntityTimer2[slot] = 0xFF
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $ff
;> if not (GetEntityTimer1(slot) | wEntityPrivate4[slot]):
	call GetEntityTimer1
	ld hl, wEntityPrivate4
	add hl, bc
	or [hl]
	jr nz, BounceBombOffWalls

;>     if wItemB == 2:  # bombs on B
	ld a, [wItemB]
	cp $02
	jr nz, .itemA

;>         if hJoypadPressed & 0x20: TryLiftStunnedEntity(slot)
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .lift

	jr BounceBombOffWalls

.itemA
;>     elif wItemA == 2:
	ld a, [wItemA]
	cp $02
	jr nz, BounceBombOffWalls

;>         if hJoypadPressed & 0x10: TryLiftStunnedEntity(slot)
	ldh a, [hJoypadPressed]
	and $10
	jr z, BounceBombOffWalls

.lift
	call TryLiftStunnedEntity

BounceBombOffWalls:
;> if wEntityCollisions[slot] & 3: ReverseSpeedXEighth(slot)  # x speed turned and slowed
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .vertical

	call ReverseSpeedXEighth

.vertical
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .done

;>     if wEntityCollisions[slot] & 0x0C: ReverseSpeedYEighth(slot)  # y speed turned and slowed
	ld a, [hl]
	and $0c
	jr z, .done

	call ReverseSpeedYEighth

.done
	ret


;@ def DrawBomb(slot: bc)
;@ path: item/bomb
;@ Draws the bomb two pixels lower (it sits on the ground), then reloads the entity's position.
;@ test: slot = rand(0, 15)
DrawBomb::
;> hActiveEntityDrawY += 2
	ld hl, hActiveEntityDrawY
	inc [hl]
	inc [hl]
;> DrawEntity8x16(slot, BombSprite)
	ld de, BombSprite
	call DrawEntity8x16
;> return LoadEntityPosition(slot)
	jp LoadEntityPosition


;@ path: item/bomb
;@ X offset of each of the nine 16x16 squares the explosion hits (index 0-8), from the bomb: -8, 8,
;@ $18 per row.
BombBlastOffsetsX::
	db $f8, $08, $18, $f8, $08, $18, $f8, $08, $18

;@ path: item/bomb
;@ Y offset of the nine squares: -8 (top row), 8, $18.
BombBlastOffsetsY::
	db $f8, $f8, $f8, $08, $08, $08, $18
	db $18, $18

;@ path: unused
;@ 8 bytes no code refers to.
Unused675D::
	db $48, $48, $00, $90, $00, $70, $38, $38

;@ path: item/bomb
;@ Room object that replaces a bombed wall, by wall kind k 0-3 (physics $99 + k): $3D, $3D, $3E, $3E.
BombedWallObjects::
	db $3d, $3d, $3e, $3e

;@ path: item/bomb
;@ Background tiles of a bombed-open wall (4 tiles, see DrawRoomObjectTiles): walls 0/1 use the first
;@ four ($72, $72, $73, $73), walls 2/3 the second four ($69, $79, $69, $79).
BombedWallTiles::
	db $72, $72
	db $73, $73, $69, $79, $69, $79

;@ path: item/bomb
;@ Background tiles of an overworld cave entrance bombed open (object $E1): $64, $66, $65, $67.
BombedEntranceTiles::
	db $64, $66, $65, $67

;@ path: item/bomb
;@ Room status bit set when wall k of the current room is bombed open: $04, $08, $02, $01.
BombedWallRoomBits::
	db $04, $08, $02, $01

;@ path: item/bomb
;@ Status bit set in the room on the other side of wall k: $08, $04, $01, $02.
BombedWallNeighbourBits::
	db $08, $04, $01, $02

;@ path: item/bomb
;@ Square of the neighbouring room behind wall k on the dungeon's 8x8 grid: -8 (up), +8 (down), -1
;@ (left), +1 (right).
NeighbourRoomOffsets::
	db $f8, $08, $ff, $01

;@ path: item/bomb
;@ Background tiles of each quarter of a bombed 32x32 rock: $72, $73, $73, $72.
BombedRockTiles::
	db $72, $73, $73, $72

;@ path: item/bomb
;@ X step from one quarter of the bombed rock to the next (quarters 3 down to 0): 0, +$10, -$10, +$10.
BombedRockStepX::
	db $00, $10, $f0, $10

;@ path: item/bomb
;@ Y step between the quarters: 0, 0, +$10, 0.
BombedRockStepY::
	db $00, $00, $10, $00

;@ def BombBlastBackground(slot: bc, i: de)
;@ path: item/bomb
;@ The explosion against the room's background at blast square i (top view only): a big overworld
;@ rock (objects $BB-$BE) breaks into floor and four pieces of debris; other objects go on in
;@ BombBlastObject (cracked walls and cave entrances).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
BombBlastBackground::
;> if hIsSideScrolling: return
	ldh a, [hIsSideScrolling]
	and a
	jp nz, BombBlastIndoorWall.return2

	push bc
;> x = wEntityX[slot] - 8
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
;> x = (x + mem[BombBlastOffsetsX + i]) & 0xF0
	ld hl, BombBlastOffsetsX
	add hl, de
	add [hl]
	and $f0
;> hBGPosX = x
	ldh [hBGPosX], a
	swap a
;> y = wEntityY[slot] - 0x10  # c = x >> 4
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $10
;> y = (y + mem[BombBlastOffsetsY + i]) & 0xF0
	ld hl, BombBlastOffsetsY
	add hl, de
	add [hl]
	and $f0
;> hBGPosY = y
	ldh [hBGPosY], a
;> square = y | (x >> 4)
	or c
	ld c, a
	ld b, $00
;> p = wRoomObjects + square  # stays in the page
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
;> hMultiPurposeH = square
	ld a, c
	ldh [hMultiPurposeH], a
;> hRoomObjectType = mem[p]
	ld a, [hl]
	ldh [hRoomObjectType], a
	ld e, a
;> if not (0xBB <= hRoomObjectType < 0xBF): return BombBlastObject(hRoomObjectType)
	cp $bb
	jr c, BombBlastObject

	cp $bf
	jr nc, BombBlastObject

;> if wIsIndoor: return BombBlastObject(hRoomObjectType)
	ld a, [wIsIndoor]
	and a
	jr nz, BombBlastObject

;> hJingle = 2
	ld a, $02
	ldh [hJingle], a
;> hBGPosY &= 0xE0
	ldh a, [hBGPosY]
	and $e0
	ldh [hBGPosY], a
;> hBGPosX &= 0xE0  # the rock's top left corner
	ldh a, [hBGPosX]
	and $e0
	ldh [hBGPosX], a
;> SpawnRockDebris(slot)
	call SpawnRockDebris
;> corner = square & 0xEE
	ld a, c
	and $ee
	ld c, a
;> wRoomObjects[corner] = 9
	ld hl, wRoomObjects
	add hl, bc
	ld a, $09
	ld [hli], a
;> wRoomObjects[corner + 1] = 9
	ld [hld], a
;> wRoomObjects[corner + 0x10] = 9
	ld a, l
	add $10
	ld l, a
	ld a, $09
	ld [hli], a
;> wRoomObjects[corner + 0x11] = 9
	ld [hl], $09
;> for q in range(3, -1, -1):
	ld c, $03
	ld b, $00

.quarter
;>     DrawBombedRockTiles()
	call DrawBombedRockTiles
;>     hBGPosX += mem[BombedRockStepX + q]
	ld hl, BombedRockStepX
	add hl, bc
	ld a, [hl]
	ld hl, hBGPosX
	add [hl]
	ld [hl], a
;>     hBGPosY += mem[BombedRockStepY + q]
	ld hl, BombedRockStepY
	add hl, bc
	ld a, [hl]
	ld hl, hBGPosY
	add [hl]
	ld [hl], a
;>     continue  # next q
	dec c
	ld a, c
	cp $ff
	jr nz, .quarter

;> return
	jp BombBlastIndoorWall.return


;@ def DrawBombedRockTiles()
;@ path: item/bomb
;@ One quarter of the bombed rock: marks the room (status bit 2) and draws BombedRockTiles at
;@ (hBGPosX, hBGPosY).
;@ test: wCurrentBank = $03
DrawBombedRockTiles::
;> return MarkRoomBombedAndDraw(BombedRockTiles)
	ld de, BombedRockTiles
	jp MarkRoomBombedAndDraw


;@ def BombBlastObject(obj: e)
;@ path: item/bomb
;@ The rest of BombBlastBackground: objects whose physics is $99-$9C can be bombed. Outdoors that
;@ opens a cave entrance (object $E1); indoors it is a cracked wall (BombBlastIndoorWall).
;@ test: wCurrentBank = $03
;@ test: wIsIndoor = rand(0, 1)
;@ test: skip pops the slot that BombBlastBackground saved on the stack, so it only runs from there
BombBlastObject::
;> k = GetObjectPhysics(obj, wIsIndoor) - 0x99
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	sub $99
;> if not (0 <= k < 4): return
	jp c, BombBlastIndoorWall.return

	cp $04
	jp nc, BombBlastIndoorWall.return

	ld c, a
;> hJingle = 2
	ld a, $02
	ldh [hJingle], a
;> if wIsIndoor: return BombBlastIndoorWall(k)
	ld a, [wIsIndoor]
	and a
	jr nz, BombBlastIndoorWall

	pop bc
;> wRoomObjects[hMultiPurposeH] = 0xE1
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, b
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $e1
;> return MarkRoomBombedAndDraw(BombedEntranceTiles)
	ld de, BombedEntranceTiles

;@ def MarkRoomBombedAndDraw(tiles: de)
;@ path: item/bomb
;@ Sets bit 2 in the current overworld room's status (and hRoomStatus) and queues the 16x16 square at
;@ (hBGPosX, hBGPosY) with the given tiles.
;@ test: wCurrentBank = $03
MarkRoomBombedAndDraw::
;> # the tiles go on the stack, where DrawRoomObjectTiles takes them from
	push de
;> p = wRoomStatus + hMapRoom
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	add hl, de
;> mem[p] |= 4
	ld a, [hl]
	or $04
	ld [hl], a
;> hRoomStatus = mem[p]
	ldh [hRoomStatus], a
;> return DrawRoomObjectTiles(tiles)
	jp DrawRoomObjectTiles


;@ def BombBlastIndoorWall(k: c)
;@ path: item/bomb
;@ Bombs open a cracked dungeon wall of kind k (0-3): the bit of that wall is set in this room's status
;@ and the matching bit in the neighbouring room's, the wall object becomes the opening
;@ (BombedWallObjects) and its tiles are queued.
;@ test: wCurrentBank = $03
;@ test: k = rand(0, 3)
;@ test: skip pops the slot that BombBlastBackground saved on the stack before it calls BombBlastObject, so it only runs from there
BombBlastIndoorWall::
;> offset = hMapRoom  # p starts at 0xD900, the first group of indoor rooms
	ld hl, wRoomStatus + $100
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
;> if 6 <= hMapId < 0x1A: offset += 0x100  # second group
	ldh a, [hMapId]
	cp $1a
	jr nc, .add

	cp $06
	jr c, .add

	inc d

.add
;> p = 0xD900 + offset
	add hl, de
;> q = p
	push hl
	pop de
;> mem[q] |= mem[BombedWallRoomBits + k]
	ld hl, BombedWallRoomBits
	add hl, bc
	ld a, [de]
	or [hl]
	ld [de], a
;> hRoomStatus = mem[q]
	ldh [hRoomStatus], a
;> r = wIndoorRoom + mem[NeighbourRoomOffsets + k]
	ld hl, NeighbourRoomOffsets
	add hl, bc
	ld a, [wIndoorRoom]
	add [hl]
;> q = GetDungeonRoomStatusAddress(r)
	ld e, a
	ld d, $00
	call GetDungeonRoomStatusAddress
	push hl
	pop de
;> mem[q] |= mem[BombedWallNeighbourBits + k]
	ld hl, BombedWallNeighbourBits
	add hl, bc
	ld a, [de]
	or [hl]
	ld [de], a
;> sx = hBGPosX >> 4
	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
;> square = (hBGPosY & 0xF0) | sx
	ldh a, [hBGPosY]
	and $f0
	or e
;> p = wRoomObjects + square
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	push hl
	pop de
;> mem[p] = mem[BombedWallObjects + k]
	ld hl, BombedWallObjects
	add hl, bc
	ld a, [hl]
	ld [de], a
;> tiles = BombedWallTiles + (4 if k >= 2 else 0)
	ld a, c
	rla
	and $04
	ld c, a
	ld hl, BombedWallTiles
	add hl, bc
;> return DrawRoomObjectTiles(tiles)
	pop bc
	push hl
	jp DrawRoomObjectTiles


.return
	pop bc

.return2
	ret


;@ path: item/bomb
;@ X offsets of the four pieces of a bombed rock (SpawnRockDebris, index 0-3): 8, $18, 8, $18.
RockDebrisOffsetsX::
	db $08, $18, $08, $18

;@ path: item/bomb
;@ Y offsets of the four pieces: $10, $10, $20, $20.
RockDebrisOffsetsY::
	db $10, $10, $20, $20

;@ def SpawnRockDebris(slot: bc)
;@ path: item/bomb
;@ Spawns four pieces of a bombed 32x32 rock (type 5, a liftable object, wEntityTimer1 $0F, physics
;@ flags $C4) at its four quarters around (hBGPosX, hBGPosY), raised by the bomb's height
;@ (hMultiPurpose3).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SpawnRockDebris::
;> for q in range(3, -1, -1):
	push bc
	ld c, $03
	ld b, $00

.piece
;>     n, full = SpawnEntity_03(q, 5)           # (bc holds q here, so the spawn copies slot q's position)
	ld a, $05
	call SpawnEntity_03
;>     if full: continue
	jr c, .next

;>     wEntityTimer1[n] = 0x0F
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
;>     x = hBGPosX + mem[RockDebrisOffsetsX + q]
	ldh a, [hBGPosX]
	ld hl, RockDebrisOffsetsX
	add hl, bc
	add [hl]
;>     wEntityX[n] = x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     y = hBGPosY + mem[RockDebrisOffsetsY + q] - hMultiPurpose3
	ldh a, [hBGPosY]
	ld hl, RockDebrisOffsetsY
	add hl, bc
	add [hl]
	ld hl, hMultiPurpose3
	sub [hl]
;>     wEntityY[n] = y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPhysicsFlags[n] = 0xC4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4

.next
;>     continue  # next q
	dec c
	ld a, c
	cp $ff
	jr nz, .piece

	pop bc
	ret


;@ path: item/bomb
;@ X offsets of the nine squares (BombDestroyObject, index 0-8): -8, 8, $18 per row.
BombObjectOffsetsX::
	db $f8, $08, $18, $f8, $08, $18, $f8, $08, $18

;@ path: item/bomb
;@ Y offsets of the nine squares: -8, 8, $18.
BombObjectOffsetsY::
	db $f8, $f8, $f8, $08, $08, $08, $18
	db $18, $18

;@ def BombDestroyObject(slot: bc, i: de)
;@ path: item/bomb
;@ The explosion at blast square i destroys an object there: outdoors objects $0A, $D3 and $5C
;@ (bushes and grass), indoors object $A9 (which also sets bit 6 of the room's status). The object is
;@ removed and a liftable object (type 5) appears there and breaks at once into pieces (variant 1
;@ outdoors, 0 indoors, $FF = invisible for object $0A).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: i = rand(0, 8)
BombDestroyObject::
;> x = hActiveEntityX + mem[BombObjectOffsetsX + i]
	push bc
	ld hl, BombObjectOffsetsX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
;> x = (x - 8) & 0xF0
	sub $08
	and $f0
;> hBGPosX = x
	ldh [hBGPosX], a
	swap a
	ld c, a
;> y = (hActiveEntityDrawY + mem[BombObjectOffsetsY + i] - 0x10) & 0xF0
	ld hl, BombObjectOffsetsY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	sub $10
	and $f0
;> hBGPosY = y
	ldh [hBGPosY], a
;> square = y | (x >> 4)
	or c
	ld e, a
;> p = wRoomObjects + square
	ld hl, wRoomObjects
	add hl, de
;> if p >= 0xD800: return  # outside the room
	ld a, h
	cp $d7
	jp nz, .done

;> hRoomObjectType = mem[p]
	ld a, [wIsIndoor]
	and a
	ld a, [hl]
	ldh [hRoomObjectType], a
;> if not wIsIndoor:
	jr nz, .indoor

;>     hMultiPurposeH = hRoomObjectType
	ldh [hMultiPurposeH], a
;>     destroy = hRoomObjectType in (0x0A, 0xD3)
	cp $0a
	jr z, .destroy

	cp $d3
	jr z, .destroy

;>     if not destroy and hRoomObjectType != 0x5C: return
	cp $5c
	jr z, .destroy

	jp .done


.indoor
;> else:
;>     if hRoomObjectType != 0xA9: return
	cp $a9
	jp nz, .done

;>     p = 0xD900 + hMapRoom
	ldh a, [hMapRoom]
	ld c, a
	ld b, $00
;>     if 6 <= hMapId < 0x1A: p += 0x100
	ldh a, [hMapId]
	cp $1a
	jr nc, .flag

	cp $06
	jr c, .flag

	inc b

.flag
;>     mem[p] |= 0x40
	ld hl, wRoomStatus + $100
	add hl, bc
	ld a, [hl]
	or $40
	ld [hl], a
;>     hRoomStatus = mem[p]
	ldh [hRoomStatus], a

.destroy
;> RemoveRoomObject(square)
	call RemoveRoomObject
;> n, full = SpawnEntity_03(slot, 5)
	ld a, $05
	call SpawnEntity_03
;> if full: return
	jr c, .done

;> wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
;> wEntityX[n] = hBGPosX + 8
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
;> wEntityY[n] = hBGPosY + 0x10
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
;> v = wIsIndoor ^ 1
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [wIsIndoor]
	xor $01
;> wEntitySpriteVariant[n] = v
	ld [hl], a
;> hActiveEntitySpriteVariant = v
	ldh [hActiveEntitySpriteVariant], a
;> if hMultiPurposeH == 0x0A:
	ldh a, [hMultiPurposeH]
	cp $0a
	jr nz, .break

;>     wEntitySpriteVariant[n] = 0xFF
	ld a, $ff
	ld [hl], a
;>     hActiveEntitySpriteVariant = 0xFF
	ldh [hActiveEntitySpriteVariant], a

.break
;> BreakThrownObject(slot=n)
	push de
	pop bc
	call BreakThrownObject

.done
	pop bc
	ret


;@ path: item/magic-rod
;@ Background tiles of a lit torch (4 tiles for DrawRoomObjectTiles): $6C, $74, $6D, $75.
LitTorchTiles_03::
	db $6c, $74, $6d, $75

;@ path: item/magic-rod
;@ The Magic Rod's fireball (type 4), 2 variants of two 8x16 sprites (tile, attribute): tile $36 and
;@ mirrored, palette 0 (variant 0) or 1 (variant 1); it flickers between them.
FireballSprites::
	db $36, $00, $36, $20, $36, $10, $36, $30

;@ def MagicRodFireballHandler(slot: bc)
;@ path: item/magic-rod
;@ Handler of type 4, the Magic Rod's fireball: hits entities as weapon $0A, flickers, flies. When it
;@ hits a wall it burns there for a while (wEntityTimer1, flame sprites). Bushes and grass outdoors
;@ (objects $D3, $5C) and object $8A indoors burn away (effect 8, noise $13) and the fireball flies on.
;@ test: slot = rand(0, 15)
MagicRodFireballHandler::
;> wActiveProjectileCount += 1
	ld hl, wActiveProjectileCount
	inc [hl]
;> wProjectileWeaponType = 0x0A
	ld a, $0a
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities_03(slot)  # hits entities
	call EntityHitOtherEntities_03
;> v = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> wEntitySpriteVariant[slot] = v
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> if t:
	jr z, .flying

;>     if t == 1: return FreeEntitySlot(slot)  # frees the slot
	dec a
	jp z, FreeEntitySlot

;>     return DrawEntity16x16(slot, BurningFlameSprites)
	ld de, BurningFlameSprites
	jp DrawEntity16x16


.flying
;> DrawAndUpdateProjectile(slot, FireballSprites)
	ld de, FireballSprites
	call DrawAndUpdateProjectile
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	ldh a, [hRoomObjectType]
	jr z, .outdoor

;>     if hRoomObjectType != 0x8A: return
	cp $8a
	jr z, .burn

	jr .done

.outdoor
;> elif hRoomObjectType not in (0xD3, 0x5C): return
	cp $d3
	jr z, .burn

	cp $5c
	jr nz, .done

.burn
;> wEntityCollisions[slot] = 0
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], b
;> wEntityTimer1[slot] = 0
	call GetEntityTimer1
	ld [hl], b
;> RemoveRoomObject(hMultiPurposeH)
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, b
	call RemoveRoomObject
;> hMultiPurpose0 = hBGPosX + 8
	ldh a, [hBGPosX]
	add $08
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hBGPosY + 0x10
	ldh a, [hBGPosY]
	add $10
	ldh [hMultiPurpose1], a
;> AddTransientVfx(8)
	ld a, $08
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a

.done
	ret


;@ path: enemy/octorok
;@ The Octorok's rock (type $0A), 2 variants of two 8x16 sprites (tile, attribute): tile $6C and
;@ mirrored, tile $5C and mirrored.
OctorokRockSprites::
	db $6c, $00, $6c, $20, $5c, $00, $5c, $20

;@ def OctorokRockHandler(slot: bc)
;@ path: enemy/octorok
;@ Handler of type $0A, the rock an Octorok spits: hurts Link (or is blocked by his shield) while it
;@ flies, then the common projectile update.
;@ test: slot = rand(0, 15)
OctorokRockHandler::
;> if GetEntityTimer(slot) == 0: ProjectileHitsLink(slot)
	call GetEntityTimer
	jr nz, .draw

	call ProjectileHitsLink

.draw
;> return DrawAndUpdateProjectile(slot, OctorokRockSprites)
	ld de, OctorokRockSprites
	jp DrawAndUpdateProjectile


;@ def ArrowHandler(slot: bc)
;@ path: item/bow
;@ Handler of type 0, Link's arrow (state 1: an arrow with a bomb, BombArrowHandler). It hits entities
;@ as weapon 5 while it flies. An arrow flying up (variant 2) into object $C0 triggers the room event
;@ when the room's event kind is $0F (shooting a switch) and vanishes.
;@ test: slot = rand(0, 15)
ArrowHandler::
;> wActiveProjectileCount += 1
	ld hl, wActiveProjectileCount
	inc [hl]
;> if hActiveEntityState: return BombArrowHandler(slot)
	ldh a, [hActiveEntityState]
	and a
	jr nz, BombArrowHandler

;> if GetEntityTimer(slot): return DrawArrowAndUpdate(slot)
	call GetEntityTimer
	jp nz, DrawArrowAndUpdate

;> wProjectileWeaponType = 5
	ld a, $05
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities_03(slot)  # hits entities
	call EntityHitOtherEntities_03
;> DrawArrowAndUpdate(slot)
	call DrawArrowAndUpdate
;> if hActiveEntitySpriteVariant != 2: return
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nz, .done

;> if wRoomEvent & 0x1F != 0x0F: return
	ld a, [wRoomEvent]
	and $1f
	cp $0f
	jr nz, .done

;> if hRoomObjectType != 0xC0: return
	ldh a, [hRoomObjectType]
	cp $c0
	jr nz, .done

;> TriggerRoomEvent()
	call TriggerRoomEvent
;> FreeEntitySlot(slot)  # frees the slot
	call FreeEntitySlot

.done
	ret


;@ path: item/bow
;@ The bomb tied to a bomb arrow: one 8x16 sprite, tile $80, palette 1.
ArrowBombSprite::
	db $80, $10

;@ path: item/bow
;@ X offset of the bomb from the arrow by direction (0 right, 1 left, 2 up, 3 down): 4, -4, 0, 0.
ArrowBombOffsetsX::
	db $04, $fc, $00, $00

;@ path: item/bow
;@ Y offset of the bomb by direction: -2, -2, -6, 4.
ArrowBombOffsetsY::
	db $fe, $fe, $fa, $04

;@ def BombArrowHandler(slot: bc)
;@ path: item/bow
;@ Bow and bombs together: the arrow carries a bomb and hits entities as weapon $0C. When it hits
;@ something (its timer starts) it becomes a bomb that explodes at once (type 2, timer $17).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
BombArrowHandler::
;> if GetEntityTimer(slot):
	call GetEntityTimer
	jr z, .flying

;>     n, full = SpawnEntity_03(slot, 2)
	ld a, $02
	call SpawnEntity_03
;>     if not full:
	jr c, .free

;>         wEntityX[n] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[n] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityTimer[n] = 0x17  # explodes now
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
;>         PlayClinkNoise()
	call PlayClinkNoise

.free
;>     return FreeEntitySlot(slot)  # frees the slot
	jp FreeEntitySlot


.flying
;> d = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
	push af
	ld e, a
	ld d, b
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityX += mem[ArrowBombOffsetsX + d]
	ld hl, ArrowBombOffsetsX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY += mem[ArrowBombOffsetsY + d]
	ld hl, ArrowBombOffsetsY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> DrawEntity8x16(slot, ArrowBombSprite)
	ld de, ArrowBombSprite
	call DrawEntity8x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> hActiveEntitySpriteVariant = d
	pop af
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, ArrowSprites)
	ld de, ArrowSprites
	call DrawEntity16x16
;> wProjectileWeaponType = 0x0C
	ld a, $0c
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities_03(slot)  # hits entities
	call EntityHitOtherEntities_03
;> return UpdateProjectile(slot)
	jr UpdateProjectile

;@ def MoblinArrowHandler(slot: bc)
;@ path: enemy/moblin
;@ Handler of type $0C, a Moblin's arrow: hurts Link while it flies, then the common projectile update.
;@ test: slot = rand(0, 15)
MoblinArrowHandler::
;> if GetEntityTimer(slot) == 0: ProjectileHitsLink(slot)
	call GetEntityTimer
	jr nz, DrawArrowAndUpdate

	call ProjectileHitsLink
;> return DrawArrowAndUpdate(slot)    # (runs on into it)

;@ def DrawArrowAndUpdate(slot: bc)
;@ path: entity/projectile
;@ Draws an arrow (ArrowSprites by direction) and runs the projectile update.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
DrawArrowAndUpdate::
;> sprites = ArrowSprites
;> return DrawAndUpdateProjectile(slot, sprites)    # (runs on into it)
	ld de, ArrowSprites

;@ def DrawAndUpdateProjectile(slot: bc, sprites: de)
;@ path: entity/projectile
;@ The common update of a flying projectile (arrows, rocks, the fireball): drawn, moved, and stopped
;@ by the background (EntityCheckObjectCollision_03). On a wall the fireball starts burning ($30 frames); the others
;@ bounce back up (z speed $10) with jingle 7 (unless the collision value is $FF), the clink timer
;@ starts, and they fall for $18 frames (ProjectileFalling): arrows with a quarter of their speed
;@ turned, others an eighth.
;@ test: slot = rand(0, 15)
DrawAndUpdateProjectile::
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16

UpdateProjectile:
;> ReturnIfNonInteractive_03()
	call ReturnIfNonInteractive_03
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t: return ProjectileFalling(slot, t)
	jr nz, ProjectileFalling

;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> EntityCheckObjectCollision_03(slot)  # background collision of projectiles
	call EntityCheckObjectCollision_03
;> if not wEntityCollisions[slot]: return
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, ReverseSpeedEighth.return

;> timer = wEntityTimer + slot
	call GetEntityTimer
;> if hActiveEntityType == 4:
	ldh a, [hActiveEntityType]
	cp $04
	jr nz, .bounce

;>     wEntityTimer1[slot] = 0x30  # the fireball burns
	call GetEntityTimer1
	ld [hl], $30
;>     return
	ret


.bounce
;> mem[timer] = 0x18
	ld [hl], $18
;> wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;> hit = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
;> if hit != 0xFF: hJingle = 7
	inc a
	jr z, .clink

	ld a, $07
	ldh [hJingle], a

.clink
;> StartClinkTimer()
	call StartClinkTimer
;> if hActiveEntityType != 0: return ReverseBothSpeedsEighth(slot)
	ldh a, [hActiveEntityType]
	cp $00
	jr nz, ReverseBothSpeedsEighth

;> ReverseSpeedYQuarter(slot)
	call ReverseSpeedYQuarter
;> speed = wEntitySpeedX
	ld hl, wEntitySpeedX

ReverseSpeedQuarter:
;> v = -speed[slot]
	add hl, bc
	ld a, [hl]
	cpl
	inc a
;> speed[slot] = v >> 2  # signed
	sra a
	sra a
	ld [hl], a
	ret


;@ def ReverseSpeedYQuarter(slot: bc)
;@ path: entity/projectile
;@ wEntitySpeedY = -wEntitySpeedY / 4.
;@ test: slot = rand(0, 15)
ReverseSpeedYQuarter::
;> return ReverseSpeedQuarter(slot, wEntitySpeedY)
	ld hl, wEntitySpeedY
	jr ReverseSpeedQuarter

ReverseBothSpeedsEighth:
;> ReverseSpeedYEighth(slot)
	call ReverseSpeedYEighth
;> return ReverseSpeedXEighth(slot)    # (runs on into it)

;@ def ReverseSpeedXEighth(slot: bc)
;@ path: entity/projectile
;@ wEntitySpeedX = -wEntitySpeedX / 8 (signed).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ReverseSpeedXEighth::
;> speed = wEntitySpeedX
	ld hl, wEntitySpeedX

ReverseSpeedEighth:
;> v = u8(-speed[slot])
	add hl, bc
	ld a, [hl]
	cpl
	inc a
;> speed[slot] = (v >> 3) | (0xE0 if v & 0x80 else 0)   # signed: an eighth, the other way
	sra a
	sra a
	sra a
	ld [hl], a

.return
	ret


;@ def ReverseSpeedYEighth(slot: bc)
;@ path: entity/projectile
;@ wEntitySpeedY = -wEntitySpeedY / 8.
;@ test: slot = rand(0, 15)
ReverseSpeedYEighth::
;> return ReverseSpeedEighth(slot, wEntitySpeedY)
	ld hl, wEntitySpeedY
	jr ReverseSpeedEighth

;@ path: item/bow
;@ Sprite variant of a falling arrow by (wEntityTimer >> 3) & 3: 0, 3, 1, 2 (it spins).
ArrowSpinVariants::
	db $00, $03, $01, $02

;@ def ProjectileFalling(slot: bc, t: a)
;@ path: entity/projectile
;@ A projectile that hit something falls for its timer t and vanishes at 1; arrows spin
;@ (ArrowSpinVariants), the Octorok's rock does not.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ProjectileFalling::
;> if t == 1: return FreeEntitySlot(slot)  # frees the slot
	cp $01
	jr nz, .fall

	jp FreeEntitySlot


.fall
;> if hActiveEntityType != 0x0A:
	ldh a, [hActiveEntityType]
	cp $0a
	jr z, .move

;>     i = (GetEntityTimer(slot) >> 3) & 3
	call GetEntityTimer
	srl a
	srl a
	srl a
	and $03
;>     SetEntitySpriteVariant(slot, mem[ArrowSpinVariants + i])
	ld e, a
	ld d, b
	ld hl, ArrowSpinVariants
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant

.move
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> return UpdateEntityGravity(slot)
	jr UpdateEntityGravity

;@ path: entity/physics
;@ Side view: added to wEntitySpeedY each frame, by wEntityGroundStatus 0-3: 2, 1, 2, 2 (1 = in
;@ water).
SideViewGravity::
	db $02, $01, $02, $02

;@ path: entity/physics
;@ Side view: the fastest fall (wEntitySpeedY) by ground status: $40, 8, $40, $40.
SideViewMaxFallSpeed::
	db $40, $08, $40, $40

;@ def UpdateEntityGravity(slot: bc)
;@ path: entity/physics
;@ Top view: moves the entity by its z speed and lowers that by 2. Side view: on special ground
;@ (wEntityGroundStatus != 0) the x speed slows by 1 every 8 frames; the y speed grows by
;@ SideViewGravity up to SideViewMaxFallSpeed.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
UpdateEntityGravity::
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .sideView

;>     AddEntityZSpeedToPos_03(slot)
	call AddEntityZSpeedToPos_03
;>     wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sub $02
	ld [hl], a
;>     return
	ret


.sideView
;> g = wEntityGroundStatus[slot]
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
;> if g and hFrameCounter & 7 == 0:
	and a
	jr z, .fall

	ldh a, [hFrameCounter]
	and $07
	jr nz, .fall

;>     if wEntitySpeedX[slot]:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .fall

;>         wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1   # towards 0
	and $80
	jr z, .slow

	inc [hl]
	inc [hl]

.slow
	dec [hl]

.fall
;> v = wEntitySpeedY[slot] + mem[SideViewGravity + g]
	ld hl, SideViewGravity
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
;> wEntitySpeedY[slot] = v
	ld [hl], a
;> over = v - mem[SideViewMaxFallSpeed + g]
	ld hl, SideViewMaxFallSpeed
	add hl, de
	sub [hl]
;> if not u8(over) & 0x80:                     # (signed: not below the limit)
	and $80
	jr nz, .done

;>     wEntitySpeedY[slot] = mem[SideViewMaxFallSpeed + g]
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.done
	ret


;@ path: item/bow
;@ Arrows by direction (sprite variant 0 right, 1 left, 2 up, 3 down), two 8x16 sprites each (tile,
;@ attribute): right $2E/$2C x-flipped, left $2C/$2E, up $2A y-flipped and x+y-flipped, down $2A and
;@ x-flipped.
ArrowSprites::
	db $2e, $20, $2c, $20, $2c, $00, $2e, $00, $2a, $40, $2a, $60, $2a, $00, $2a, $20
;@ path: entity/projectile
;@ The direction (0 right, 1 left, 2 up, 3 down) Link must face to block a projectile flying in
;@ direction 0-3: 1, 0, 3, 2.
OppositeDirections::
	db $01, $00, $03, $02

;@ path: entity/projectile
;@ By Link's direction 0-3: the 16-step angle a projectile of type $2B must come from to be blocked
;@ (within 4 steps): 2, $0A, $0E, 6.
ShieldFacingAngles::
	db $02, $0a, $0e, $06

;@ def ProjectileHitsLink(slot: bc)
;@ path: entity/projectile
;@ An enemy projectile reaching Link (within 6 pixels, Link on the ground). With his shield up and
;@ facing it, it is blocked: it bounces off (wEntityCollisions $FF, jingle $16); projectiles of type
;@ $2B need the Mirror Shield (level 2) and are reflected (collisions 2, jingle 7, a sparkle).
;@ Otherwise Link is hit (EntityHitsLink); types $2B and $0C vanish, the others bounce off.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ProjectileHitsLink::
;>@ph1 def hit():                              # the code at SpawnSparkleAtEntity.setHit (after its ret)
;>@ph2     EntityHitsLink(slot)
;>@ph3     if hActiveEntityType in (0x2B, 0x0C): return FreeEntitySlot(slot)  # these vanish
;>@ph4     wEntityCollisions[slot] = 0xFF            # the others bounce off
;>@ps1 def shield():                           # the code at SpawnSparkleAtEntity.setI: other projectiles
;>@ps2     if hLinkDirection != mem[OppositeDirections + wEntityDirection[slot]]: return hit()
;>@ps3     hJingle = 0x16
;>@ps4     wEntityCollisions[slot] = 0xFF            # bounces off
;> if wLinkMotionState >= 2: return
	ld a, [wLinkMotionState]
	cp $02
	jr nc, SpawnSparkleAtEntity.return

;> if hLinkPositionZ: return
	ldh a, [hLinkPositionZ]
	and a
	jr nz, SpawnSparkleAtEntity.return

;> if (hLinkX - hActiveEntityX + 6) & 0xFF >= 0x0C: return
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $06
	cp $0c
	jr nc, SpawnSparkleAtEntity.return

;> if (hLinkY - hActiveEntityDrawY + 6) & 0xFF >= 0x0C: return
	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $06
	cp $0c
	jr nc, SpawnSparkleAtEntity.return

;> if not wIsUsingShield: return hit()
	ld a, [wIsUsingShield]
	and a
;=@ph1
;=@ph2
;=@ph3
;=@ph4
	jr z, SpawnSparkleAtEntity.setHit

;> if hActiveEntityType != 0x2B: return shield()
	ldh a, [hActiveEntityType]
	cp $2b
;=@ps1
;=@ps2
;=@ps3
;=@ps4
	jr nz, SpawnSparkleAtEntity.setI

;> if wShieldLevel < 2: return hit()
	ld a, [wShieldLevel]
	cp $02
	jr c, SpawnSparkleAtEntity.setHit

;> angle = mem[ShieldFacingAngles + hLinkDirection]
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, ShieldFacingAngles
	add hl, de
	ld e, [hl]
;> d = (wEntityDirection[slot] - angle) & 0x0F
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	sub e
	and $0f
;> if d >= 5: return hit()
	cp $05
	jr nc, SpawnSparkleAtEntity.setHit

;> wEntityCollisions[slot] = 2  # reflected
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $02
;> hJingle = 7
	ld a, $07
	ldh [hJingle], a
;> return SpawnSparkleAtEntity(hActiveEntityY)    # (runs on into it)
	ldh a, [hActiveEntityY]

;@ def SpawnSparkleAtEntity(y: a)
;@ path: entity/projectile
;@ A sparkle (transient effect 5) at the active entity's x and the given y. The code after its ret
;@ is the rest of ProjectileHitsLink.
;@ test: wCurrentBank = $03
SpawnSparkleAtEntity::
;>@bo1 def bounce(slot):                         # .setEntityCollisions (the rest of ProjectileHitsLink from here on)
;>@bo2     wEntityCollisions[slot] = 0xFF          # bounces off
;>@hi1 def hit(slot):                            # .setHit: Link is hit
;>@hi2     EntityHitsLink(slot)
;>@hi3     if hActiveEntityType in (0x2B, 0x0C): return FreeEntitySlot(slot)  # these vanish
;>@hi4     return bounce(slot)
;>@sh1 def shield(slot):                         # .setI: other projectiles against the raised shield
;>@sh2     i = wEntityDirection[slot]
;>@sh3     if hLinkDirection != mem[OppositeDirections + i]: return hit(slot)  # not facing it
;>@sh4     hJingle = 0x16
;>@sh5     return bounce(slot)
;> hMultiPurpose1 = y
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> AddTransientVfx(5)
	ld a, $05
	call AddTransientVfx
	ret


.setI
;=@sh1
;=@sh2
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;=@sh3
	ld hl, OppositeDirections
	add hl, de
	ldh a, [hLinkDirection]
	cp [hl]
	jr nz, .setHit

;=@sh4
	ld a, $16
	ldh [hJingle], a
;=@sh5

.setEntityCollisions
;=@bo1
;=@bo2
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $ff

.return
	ret


.setHit
;=@hi1
;=@hi2
	call EntityHitsLink
;=@hi3
	ldh a, [hActiveEntityType]
	cp $2b
	jr z, .freeEntitySlot

	cp $0c
;=@hi4
	jr nz, .setEntityCollisions

.freeEntitySlot
;=@hi3
	jp FreeEntitySlot


;@ def EntityCheckContactDamage_03(slot: c) -> carry
;@ path: entity/collision
;@ EntityTouchesLinkOnGround_03, but only on every other frame (alternating between slots); on the other
;@ frames no carry.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityCheckContactDamage_03::
;> if not ((hFrameCounter ^ slot) & 1): return False
	ldh a, [hFrameCounter]
	xor c
	rra
	jp nc, EntityHitsLink.return
;> return EntityTouchesLinkOnGround_03(slot)    # (runs on into it)

;@ def EntityTouchesLinkOnGround_03(slot: c) -> carry
;@ path: entity/collision
;@ EntityTouchesLink_03 while Link is on the ground (not jumping).
;@ test: slot = rand(0, 15)
EntityTouchesLinkOnGround_03::
;> if hLinkPositionZ: return False
	ldh a, [hLinkPositionZ]
	and a
	jr nz, SpawnSparkleAtEntity.return
;> return EntityTouchesLink_03(slot)    # (runs on into it)

;@ def EntityTouchesLink_03(slot: bc) -> carry
;@ path: entity/collision
;@ Overlap test of the entity's hitbox (wEntityHitbox: x offset, half width, y offset, half height)
;@ with Link (centre 8 pixels into his sprite, 4 pixels of half size). Skipped while Link is in a
;@ special motion state (2 and up). On overlap EntityHitsLink decides what happens; carry when Link was
;@ touched.
;@ test: slot = rand(0, 15)
EntityTouchesLink_03::
;> if wLinkMotionState >= 2: return False
	ld a, [wLinkMotionState]
	cp $02
	jr nc, SpawnSparkleAtEntity.return

;> box = wEntityHitbox + slot * 4
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	pop bc
;> dx = hActiveEntityX + mem[box + 0] - hLinkX - 8
	ldh a, [hActiveEntityX]
	add [hl]
	push hl
	ld hl, hLinkX
	sub [hl]
	sub $08
;> dx = abs((u8(dx) ^ 0x80) - 0x80)
	cp $80
	jr c, .xAbs

	cpl
	inc a

.xAbs
;> limit = mem[box + 1] + 4
	pop hl
	push af
	inc hl
	ld a, $04
	add [hl]
	ld e, a
;> if dx >= limit: return False
	pop af
	cp e
	jp nc, EntityHitsLink.return

;> dy = hActiveEntityDrawY + mem[box + 2]
	inc hl
	ldh a, [hActiveEntityDrawY]
	add [hl]
	push hl
;> dy = dy - hLinkY - 8
	ld hl, hLinkY
	sub [hl]
	sub $08
;> dy = abs((u8(dy) ^ 0x80) - 0x80)
	cp $80
	jr c, .yAbs

	cpl
	inc a

.yAbs
;> limit = mem[box + 3] + 4
	pop hl
	push af
	inc hl
	ld a, $04
	add [hl]
	ld e, a
;> if dy >= limit: return False
	pop af
	cp e
	jr nc, EntityHitsLink.return
;> return EntityHitsLink(slot)    # (runs on into it)

;@ def EntityHitsLink(slot: bc) -> carry
;@ path: entity/collision
;@ The entity touches Link. Entities with physics flag bit 7 only touch (carry, no harm), and so does
;@ everything while Link is in pose $4E or $4F; otherwise HurtLink.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityHitsLink::
;> touchOnly = wEntityPhysicsFlags[slot] & 0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .checkLinkAnimationState

.checkTouchOnly
;> if touchOnly: return True
	scf
	ret


.return
;> # (.return: "return False", where the touch tests before this routine end when Link is not touched)
	and a
	ret


.checkLinkAnimationState
;> if u8(hLinkAnimationState - 0x4E) < 2: return True
	ldh a, [hLinkAnimationState]
	sub $4e
	cp $02
	jr c, .checkTouchOnly
;> return HurtLink(slot)    # (runs on into it)

;@ def HurtLink(slot: bc) -> carry
;@ path: entity/collision
;@ The entity hurts Link, after some special cases: type $AC (when Link is above it) and type $9F
;@ (when Link lands on it) bounce Link up instead; type $1C reacts by itself; type $E4 in state 4 goes
;@ to state 8. Nothing happens while Link is pushed back, invincible, using the hookshot, playing the
;@ ocarina or showing an item. Otherwise Link loses the entity's contact damage
;@ (EntityContactDamageTable by health group; halved with the Guardian Acorn, 4 becomes 0), is
;@ invincible for $50 frames, the kill counter restarts, and an active power-up ends after its third
;@ hit (the music goes back unless a boss is in the room). Then KnockLinkBack.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
HurtLink::
;> if hActiveEntityType == 0xAC:
	ldh a, [hActiveEntityType]
	cp $ac
	jr nz, .type9F

;>     if GetEntityYDistanceToLink_03(slot)[0] == 2:  # e = 2: Link above it
	call GetEntityYDistanceToLink_03
	ld a, e
	cp $02
	jr nz, .type1C

;>         wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;>         wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;>         hLinkSpeedY = 0xF0
	ld a, $f0
	ldh [hLinkSpeedY], a
;>         ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>         hWaveSfx = 0x0E
	ld a, $0e
	ldh [hWaveSfx], a
;>         return False
	ret


.type9F
;> land = hActiveEntityType == 0x9F
	ldh a, [hActiveEntityType]
	cp $9f
	jr nz, .type1C

;> land = land and wIsLinkInTheAir
	ld a, [wIsLinkInTheAir]
	and a
	jr z, .type1C

;> if land and not hLinkCountdown:
	ldh a, [hLinkCountdown]
	and a
	jr nz, .bounce

;>     if not hIsSideScrolling: land = hLinkSpeedZ < 0  # signed: falling
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .sideSpeed

	ldh a, [hLinkSpeedZ]
	xor $80
	jr .checkFall

.sideSpeed
;>     else: land = hLinkSpeedY >= 0  # signed: falling
	ldh a, [hLinkSpeedY]

.checkFall
;> if land:
	and $80
	jr nz, .type1C

.bounce
;>     hLinkCountdown = 2
	ld a, $02
	ldh [hLinkCountdown], a
;>     wEntityState[slot] = 2
	ld hl, wEntityState
	add hl, bc
	ld [hl], $02
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     hWaveSfx = 0x0E
	ld a, $0e
	ldh [hWaveSfx], a
;>     if not hIsSideScrolling: hLinkSpeedZ = 0x10; return False
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .sideBounce

	ld a, $10
	ldh [hLinkSpeedZ], a
	ret


.sideBounce
;>     hLinkSpeedY = 0xF0; return False
	ld a, $f0
	ldh [hLinkSpeedY], a
	ret


.type1C
;> if hActiveEntityType == 0x1C:
	ldh a, [hActiveEntityType]
	cp $1c
	jr nz, .pushed

;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>     return False
	ret


.pushed
;> exempt = hActiveEntityType in (0x8E, 0x82)
	cp $8e
	jr z, .typeE4

	cp $82
	jr z, .typeE4

;> if not exempt and wLinkPushedTimer: return True
	ld a, [wLinkPushedTimer]
	and a
	jp nz, KnockLinkBack.return

.typeE4
;> if hActiveEntityType == 0xE4 and hActiveEntityState == 4:
	ldh a, [hActiveEntityType]
	cp $e4
	jr nz, .damage

	ldh a, [hActiveEntityState]
	cp $04
	jr nz, .damage

;>     wEntityState[slot] = 8
	call IncrementEntityState
	ld [hl], $08
;>     hWaveSfx = 3
	ld a, $03
	ldh [hWaveSfx], a
;>     return False
	ret


.damage
;> busy = wInvincibilityCounter | wHookshotOut | wOcarinaSongState
	ld a, [wInvincibilityCounter]
	ld hl, wHookshotOut
	or [hl]
	ld hl, wOcarinaSongState
	or [hl]
;> if busy | wLinkShowItemPose: return True
	ld hl, wLinkShowItemPose
	or [hl]
	jp nz, KnockLinkBack.return

;> hWaveSfx = 3
	ld a, $03
	ldh [hWaveSfx], a
;> group = wEntityHealthGroup[slot]
	ld hl, wEntityHealthGroup
	add hl, bc
	ld d, b
	ld e, [hl]
;> dmg = mem[EntityContactDamageTable + group]
	ld hl, EntityContactDamageTable
	add hl, de
	ld e, [hl]
;> if wActivePowerUp == 2:  # Guardian Acorn
	ld a, [wActivePowerUp]
	cp $02
	jr nz, .subtract

;>     if dmg == 4: dmg = 0
	ld a, e
	cp $04
	jr nz, .halve

	ld e, $00

.halve
;>     dmg >>= 1
	srl e

.subtract
;> wSubtractHealthBuffer += dmg
	ld a, [wSubtractHealthBuffer]
	add e
	ld [wSubtractHealthBuffer], a
;> wInvincibilityCounter = 0x50
	ld a, $50
	ld [wInvincibilityCounter], a
;> wKillsWithoutHit = 0
	xor a
	ld [wKillsWithoutHit], a
;> if wActivePowerUp:
	ld a, [wActivePowerUp]
	and a
	jr z, KnockLinkBack

;>     wPowerUpHits += 1
	ld hl, wPowerUpHits
	inc [hl]
;>     if wPowerUpHits >= 3:
	ld a, [hl]
	cp $03
	jr c, KnockLinkBack

;>         wActivePowerUp = 0
	xor a
	ld [wActivePowerUp], a
;>         if not wBossInRoom:
	ld a, [wBossInRoom]
	and a
	jr nz, KnockLinkBack

;>             if hDefaultMusicTrack != 0x22: wMusicTrackToPlay = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	cp $22
	jr z, .last

	ld [wMusicTrackToPlay], a

.last
;>             hLastMusicTrack = hDefaultMusicTrack
	ldh [hLastMusicTrack], a
;> return KnockLinkBack(slot)    # (runs on into it)

;@ def KnockLinkBack(slot: bc) -> carry
;@ path: entity/collision
;@ Pushes Link away from the entity: boots stop, wLinkPushedTimer $10, speed $14 ($18 for type $59)
;@ away from the entity (PushLinkAway); type $82 pushes him sideways only, type $5A also sets its
;@ collision flag. In side view he hops back (SideViewKnockback). Returns carry.
;@ test: slot = rand(0, 15)
KnockLinkBack::
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> wLinkPushedTimer = 0x10
	ld a, $10
	ld [wLinkPushedTimer], a
;> if hActiveEntityType == 0x82: return SwordClink.setSide(0x18)  # sideways only
	ldh a, [hActiveEntityType]
	ld e, $18
	cp $82
	jp z, SwordClink.setSide

;> if hActiveEntityType == 0x5A: wEntityCollisions[slot] = 1
	cp $5a
	jr nz, .speed

	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $01

.speed
;> speed = 0x18 if hActiveEntityType == 0x59 else 0x14
	cp $59
	ld a, $14
	jr nz, .push

	ld a, $18

.push
;> PushLinkAway(slot, speed)  # pushes Link away
	call PushLinkAway
;> if hIsSideScrolling: return SideViewKnockback(slot)
	ldh a, [hIsSideScrolling]
	and a
	jr nz, SideViewKnockback

.return
;> return True
	scf
	ret


;@ path: entity/collision
;@ Link's x speed when knocked back in side view, by the side he is on (GetEntityXDistanceToLink_03 e:
;@ 0 = right of the entity, 1 = left): +$0C, -$0C.
SideKnockbackSpeedsX::
	db $0c, $f4

;@ def SideViewKnockback(slot: bc) -> carry
;@ path: entity/collision
;@ In side view Link hops back up and away (y speed -$0C), unless he is in motion step 2.
;@ test: slot = rand(0, 15)
SideViewKnockback::
;> if hLinkMotionStep == 2: return True
	ldh a, [hLinkMotionStep]
	cp $02
	jr z, KnockLinkBack.return

;> side = GetEntityXDistanceToLink_03(slot)[0]  # e
	call GetEntityXDistanceToLink_03
;> hLinkSpeedX = mem[SideKnockbackSpeedsX + side]
	ld d, b
	ld hl, SideKnockbackSpeedsX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = 0xF4
	ld a, $f4
	ldh [hLinkSpeedY], a
;> hLinkMotionStep = 0
	xor a
	ldh [hLinkMotionStep], a
;> return True
	scf
	ret


;@ def EntityCheckHits_03(slot: bc)
;@ path: entity/collision
;@ The per-frame collision of an ordinary enemy with Link: contact (EntityCheckContactDamage_03, which
;@ hurts him), then the sword test (EntityCheckWeaponHits_03).
;@ test: slot = rand(0, 15)
EntityCheckHits_03::
;> EntityCheckContactDamage_03(slot)
	call EntityCheckContactDamage_03
;> return EntityCheckWeaponHits_03(slot)    # (runs on into it)

;@ def EntityCheckWeaponHits_03(slot: bc)
;@ path: entity/collision
;@ Link's sword against the entity. Nothing while there is no sword hitbox, while the entity flashes
;@ from a hit (wEntityFlashTimer $18 and up), was the last one hit by this swing (wSwordDirectionLocked
;@ = slot + 1) or ignores hits. On overlap of the sword hitbox and the entity's hitbox: an entity with
;@ physics flag bit 5 is collected (a pickup); a swinging sword (wSwordCollisionEnabled) goes on to
;@ SwordHitsEntityAttack; a sword only held out pushes or bounces off (several types react in their
;@ own way: $E2 is pushed back with the Mirror Shield facing up, $55 and $51 bounce, $2C is knocked
;@ away by Link's direction, $9C and $15 turn round) and the rest clinks (SwordClink).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityCheckWeaponHits_03::
;> if wSwordHitboxX == 0: return
	ld a, [wSwordHitboxX]
	cp $00
	jp z, StartHitPause.return

;> f = wEntityFlashTimer[slot]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
;> if f and f < 0x18: return
	and a
	jr z, .notFlashing

	cp $18
	jp c, StartHitPause.return

.notFlashing
;> if wSwordDirectionLocked and wSwordDirectionLocked - 1 == slot: return
	ld a, [wSwordDirectionLocked]
	and a
	jr z, .notLocked

	dec a
	cp c
	jp z, StartHitPause.return

.notLocked
;> if wEntityIgnoreHitsTimer[slot]: return
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jp nz, StartHitPause.return

;> p = hActiveEntityX  # an address
	ld de, hActiveEntityX
;> box = wEntityHitbox + slot * 4
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	pop bc
;> dx = hActiveEntityX + mem[box + 0] - wSwordHitboxX
	ld a, [de]
	add [hl]
	push hl
	ld hl, wSwordHitboxX
	sub [hl]
;> dx = abs((u8(dx) ^ 0x80) - 0x80)
	cp $80
	jr c, .xAbs

	cpl
	inc a

.xAbs
;> limit = wSwordHitboxWidth + mem[box + 1]
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxWidth]
	add [hl]
	ld e, a
;> if dx >= limit: return
	pop af
	cp e
	jp nc, StartHitPause.return

;> dy = hActiveEntityDrawY + mem[box + 2]
	inc hl
	push hl
	ld de, hActiveEntityDrawY
	pop hl
	ld a, [de]
	add [hl]
;> dy -= wSwordHitboxY
	push hl
	ld hl, wSwordHitboxY
	sub [hl]
;> dy = abs((u8(dy) ^ 0x80) - 0x80)
	cp $80
	jr c, .yAbs

	cpl
	inc a

.yAbs
;> limit = wSwordHitboxHeight + mem[box + 3]
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxHeight]
	add [hl]
	ld e, a
;> if dy >= limit: return
	pop af
	cp e
	jp nc, StartHitPause.return

;> if wEntityPhysicsFlags[slot] & 0x20: return CollectPickup(slot)
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $20
	jp nz, CollectPickup

;> if wSwordCollisionEnabled: return SwordHitsEntityAttack(slot)
	ld a, [wSwordCollisionEnabled]
	and a
	jp nz, SwordHitsEntityAttack

;> hMultiPurposeH = wIsUsingPegasusBoots
	ld a, [wIsUsingPegasusBoots]
	ldh [hMultiPurposeH], a
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> if hActiveEntityType == 0xE2:
	ldh a, [hActiveEntityType]
	cp $e2
	jr nz, .type55

;>     if wShieldLevel != 2 or hLinkDirection != 2: return
	ld a, [wShieldLevel]
	cp $02
	ret nz

	ldh a, [hLinkDirection]
	cp $02
	ret nz

;>     hLinkSpeedY = 4
	ld a, $04
	ldh [hLinkSpeedY], a
;>     wLinkPushedTimer = 8
	ld a, $08
	ld [wLinkPushedTimer], a
;>     return IncrementEntityState(slot)
	jp IncrementEntityState


.type55
;> if hActiveEntityType == 0x55:
	cp $55
	jr nz, .type51

;>     if hActiveEntityState != 2: return SwordClink(slot)
	ldh a, [hActiveEntityState]
	cp $02
	jp nz, SwordClink

;>     wEntitySpeedX[slot] = -wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     wEntitySpeedY[slot] = -wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     wEntityTimer1[slot] = 8
	call GetEntityTimer1
	ld [hl], $08
;>     return
	ret


.type51
;> if hActiveEntityType == 0x51:
	cp $51
	jr nz, .checkActiveEntityType

;>     if not (0x51 & 0x40): return SwordClink(slot)  # meant for wEntityOptions1; never taken
	ld hl, wEntityOptions1
	add hl, bc
	and $40
	jp z, SwordClink

.setEntityPrivate1
;> # (also reached for a type $51 with option bit 6:)
;> wEntityPrivate1[slot] = -wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> SwordBounceOff(slot)
	call SwordBounceOff
;> wEntityTimer1[slot] = 0x0C
	call GetEntityTimer1
	ld [hl], $0c
;> mem[0xC160] = 1
	ld a, $01
	ld [$c160], a
;> wSwordCharge = 0
	xor a
	ld [wSwordCharge], a
;> return SwordHitsEntityNormal.setMultiPurpose0()  # a clink at the entity
	jp SwordHitsEntityNormal.setMultiPurpose0


.checkActiveEntityType
;> if hActiveEntityType == 0x58:
	cp $58
	jr nz, .checkActiveEntityType2

.swordClink
;>     SwordClink(slot)
	call SwordClink
;>     wEntityCollisions[slot] = 0xFF; return    # (SpawnSparkleAtEntity.setEntityCollisions)
	jp SpawnSparkleAtEntity.setEntityCollisions


.checkActiveEntityType2
;> if hActiveEntityType != 0x2C: return SwordHitOtherTypes(slot, hActiveEntityType)
	cp $2c
	jr nz, SwordHitOtherTypes

;> if wEntityState[slot] == 3: return SwordBounceOff(slot)
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	cp $03
	jr z, SwordBounceOff

;> wEntityState[slot] = 3
	ld [hl], $03
;> wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[SwordPushSpeedsX + d]
	ld hl, SwordPushSpeedsX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[SwordPushSpeedsY + d]
	ld hl, SwordPushSpeedsY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> return SwordBounceOff(slot)    # (runs on into it)

;@ def SwordBounceOff(slot: bc)
;@ path: entity/collision
;@ The sword clinks off (SwordClink) and the entity may be hit again at once.
;@ test: slot = rand(0, 15)
SwordBounceOff::
;> SwordClink(slot)
	call SwordClink
;> wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ret


;@ path: entity/collision
;@ X speed of an entity of type $2C knocked by the sword, by Link's direction (0 right, 1 left, 2 up,
;@ 3 down): $10, -$10, 0, 0.
SwordPushSpeedsX::
	db $10, $f0, $00, $00

;@ path: entity/collision
;@ Y speed of it by Link's direction: 0, 0, -$10, $10.
SwordPushSpeedsY::
	db $00, $00, $f0, $10

;@ def SwordHitOtherTypes(slot: bc, type: a)
;@ path: entity/collision
;@ The rest of the held-sword cases: types $9C and $15 turn round along Link's axis (x speed when he
;@ faces left or right, y speed otherwise) and clink; type $5A bounces off; others clink.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SwordHitOtherTypes::
;> if type in (0x9C, 0x15):
	cp $9c
	jr z, .turn

	cp $15
	jr nz, .type5A

.turn
;>     if not (hLinkDirection & 2): speed = wEntitySpeedX + slot
	ldh a, [hLinkDirection]
	and $02
	jr nz, .vertical

	ld hl, wEntitySpeedX
	add hl, bc
	jr .reverse

.vertical
;>     else: speed = wEntitySpeedY + slot
	ld hl, wEntitySpeedY
	add hl, bc

.reverse
;>     mem[speed] = -mem[speed]
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     SwordClink(slot)
	call SwordClink
;>     wEntityIgnoreHitsTimer[slot] = 0  # SwordClink leaves hl there
	ld [hl], b
	ret


.type5A
;> if type == 0x5A: return EntityCheckWeaponHits_03.swordClink()  # clink, collisions $FF
	cp $5a
	jp z, EntityCheckWeaponHits_03.swordClink
;> return SwordClink(slot)    # (runs on into it)

;@ def SwordClink(slot: bc)
;@ path: entity/collision
;@ The sword clinks on the entity: jingle 9, boots stop, Link slides back for $0C frames (type $82
;@ pushes him sideways with speed $10, others with speed $12 away from it, PushLinkAway), and the
;@ entity recoils with speed $20 (SetEntityRecoil).
;@ test: slot = rand(0, 15)
SwordClink::
;> hJingle = 9
	ld a, $09
	ldh [hJingle], a
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> wLinkPushedTimer = 0x0C
	ld a, $0c
	ld [wLinkPushedTimer], a
;> if hActiveEntityType == 0x82:
	ldh a, [hActiveEntityType]
	cp $82
	jr nz, .pushLinkAway

;>     speed = 0x10
	ld e, $10

.setSide
;>     # PushLinkSideways(speed): also used by KnockLinkBack
;>     side = GetEntityXDistanceToLink_03(slot)[0]
	push de
	call GetEntityXDistanceToLink_03
	ld a, e
	and a
	pop de
;>     hLinkSpeedX = speed if side == 0 else -speed
	ld a, e
	jr z, .setLinkSpeedY

	cpl
	inc a

.setLinkSpeedY
	ldh [hLinkSpeedX], a
;>     hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;>     return
	ret


.pushLinkAway
;> PushLinkAway(slot, 0x12)  # pushes Link away
	ld a, $12
	call PushLinkAway
;> held = hJoypadHeld & 0x0F
	ld hl, hMultiPurposeH
	ldh a, [hJoypadHeld]
	and $0f
;> recoil = 0x20  # the test for 8 (8 | hMultiPurposeH == 0) can never pass
;> return SetEntityRecoil(slot, recoil)        # (runs on into it)
	ld a, $08
	or [hl]
	jr z, SetEntityRecoil

	ld a, $20

;@ def SetEntityRecoil(slot: bc, speed: a)
;@ path: entity/collision
;@ The entity is knocked away from Link with the given speed (wEntityRecoilSpeedX/Y = the opposite of
;@ the speed towards Link, GetVectorTowardsLink_03), then a short hit pause (StartHitPause).
;@ test: slot = rand(0, 15)
SetEntityRecoil::
;> GetVectorTowardsLink_03(slot, speed)  # hMultiPurpose0/1 = y/x speed towards Link
	call GetVectorTowardsLink_03
;> wEntityRecoilSpeedY[slot] = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], a
;> wEntityRecoilSpeedX[slot] = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], a
;> StartHitPause(slot)
	call StartHitPause
	ret


;@ path: entity/collision
;@ Entity direction compared with Link's direction 0-3 for type $24: 0, 1, 2, 3 (the same). The type
;@ is only hurt when it faces the way Link faces, i.e. when hit from behind.
LinkFacingDirections::
	db $00, $01, $02, $03

;@ def SwordHitsEntityAttack(slot: bc)
;@ path: entity/collision
;@ A swinging sword hits the entity. Type $E2 ignores it; the Final Nightmare (type $E6) reacts by its
;@ form (FinalNightmareSwordReactions); type $B9 in status 5 is stunned for $40 frames and hurts Link.
;@ The rest goes on in SwordHitsEntityNormal.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: wFinalNightmareForm = rand(0, 5)
;@ test: hActiveEntityType = [0xE2, 0xE6, 0xB9, rand(0, 255)][rand(0, 3)]
SwordHitsEntityAttack::
;> if hActiveEntityType == 0xE2: return
	ldh a, [hActiveEntityType]
	cp $e2
	ret z

;> if hActiveEntityType != 0xE6: return FinalNightmareSword_Form3(slot)   # (enters at .checkT with a = the type: the same)
	cp $e6
	jr nz, FinalNightmareSword_Form3.checkT

;> return FinalNightmareSwordReactions[wFinalNightmareForm](slot)
	ld a, [wFinalNightmareForm]
	rst $00

;@ path: boss/final-nightmare
;@ How the Final Nightmare reacts to the sword, by wFinalNightmareForm 0-5: 0 nothing, 1 goes to state
;@ 6, 2 next state (with a spin attack or an early swing), 3 and 4 the type $B9 test, 5 the normal hit.
FinalNightmareSwordReactions::
	dw EntityInit_None
	dw FinalNightmareSword_Form1
	dw FinalNightmareSword_Form2
	dw FinalNightmareSword_Form3
	dw FinalNightmareSword_Form3
	dw SwordHitsEntityNormal

;@ def FinalNightmareSword_Form1(slot: bc)
;@ path: boss/final-nightmare
;@ Form 1: the sword sends it to state 6.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
FinalNightmareSword_Form1::
;> wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
	ret


;@ def FinalNightmareSword_Form2(slot: bc)
;@ path: boss/final-nightmare
;@ Form 2: a spin attack, or a swing in its first 4 animation steps, moves it to its next state.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
FinalNightmareSword_Form2::
;> if not wSpinAttackTimer and wSwordAnimationStatePrev >= 4: return
	ld a, [wSpinAttackTimer]
	and a
	jr nz, .next

	ld a, [wSwordAnimationStatePrev]
	cp $04
	ret nc

.next
;> IncrementEntityState(slot)
	call IncrementEntityState
	ret


;@ def FinalNightmareSword_Form3(slot: bc)
;@ path: boss/final-nightmare
;@ Forms 3 and 4, and every other type: the type $B9 test. A type $B9 in status 5 goes to state 1 for
;@ $40 frames, the screen flashes ($D464 = $40), the sword action stops (noise $1C) and Link is hurt.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
FinalNightmareSword_Form3::
;> t = hActiveEntityType
	ldh a, [hActiveEntityType]

.checkT
;> if t != 0xB9: return SwordHitsEntityNormal(slot)
	cp $b9
	jr nz, SwordHitsEntityNormal

;> if hActiveEntityStatus != 5: return SwordHitsEntityNormal(slot)
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, SwordHitsEntityNormal

;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wElectricShockTimer = 0x40
	ld a, $40
	ld [wElectricShockTimer], a
;> wSwordAnimationState = 0
	xor a
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
;> hNoiseSfx = 0x1C
	ld a, $1c
	ldh [hNoiseSfx], a
;> return HurtLink(slot)
	jp HurtLink


;@ def SwordHitsEntityNormal(slot: bc)
;@ path: entity/collision
;@ The sword hit for most entities. Some types first: $55 is sent flying away from Link (speed $30,
;@ state 2), $65 pushes Link back, $5B can only be hurt in some states and with or without the
;@ boots. Entities with option bit 6 are sword-proof: the sword clinks off (wSwordDirectionLocked,
;@ AddClinkAtSword, $10 frames of no hits, KnockLinkBack; $51 bounces, $5C recoils). Type $8E always
;@ takes the hit, type $24 only from behind, type $15 never. A hit: recoil $30, jingle 9, a held
;@ sword pokes, the damage (SwordDamageEntity); with the Piece of Power the hit also gives the big
;@ death puff, wave sound $11, $20 frames of no hits and a longer death.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SwordHitsEntityNormal::
;>@tak1 def take_hit():
;>@tak2     mem[0xC160] = 1
;>@tak3     if wSwordAnimationStatePrev == 5: wSwordPokeTimer = 0x0C
;>@tak4     wSwordCharge = 0
;>@tak5     SetEntityRecoil(slot, 0x30)
;>@tak6     hJingle = 9
;>@tak7     if wActivePowerUp != 1: return SwordDamageEntity(slot)
;>@tak8     SwordDamageEntity(slot)
;>@tak9     wEntityIgnoreHitsTimer[slot] = 0x20
;>@tak10     wEntityHitByPowerUp[slot] = 1
;>@tak11     hWaveSfx = 0x11
;>@tak12     s = wEntityStatus[slot]
;>@tak13     if s == 1: wEntityDyingTimer[slot] = 0x40
;>@hit1 def hit():
;>@hit2     if hActiveEntityType == 0x8E: ResetPegasusBoots(); return take_hit()
;>@hit3     if hActiveEntityType == 0x24:
;>@hit4         if not wEntityPrivate2[slot]:
;>@hit5             d = mem[LinkFacingDirections + hLinkDirection]
;>@hit6             if d == wEntityDirection[slot]: return take_hit()  # from behind
;>@hit7             ResetPegasusBoots()
;>@hit8             wLinkPushedTimer = 0x10
;>@hit9             PushLinkAway(slot, 0x10)  # pushes Link away
;>@hit10             SetEntityRecoil(slot, 0x10)
;>@hit11             hMultiPurpose0 = hActiveEntityX  # (a clink at the entity, also used by EntityCheckWeaponHits_03.setEntityPrivate1)
;>@hit12             hMultiPurpose1 = hActiveEntityDrawY
;>@hit13             return AddClinkVfx()
;>@hit14     if hActiveEntityType == 0x15: return
;>@hit15     return take_hit()
;> if hActiveEntityType == 0x55:
	ldh a, [hActiveEntityType]
	cp $55
	jr nz, .checkActiveEntityType

;>     GetVectorTowardsLink_03(slot, 0x30)  # hMultiPurpose0/1 = speed towards Link
	ld a, $30
	call GetVectorTowardsLink_03
;>     wEntitySpeedY[slot] = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     wEntityTimer1[slot] = 8
	call GetEntityTimer1
	ld [hl], $08
;>     return
	ret


.checkActiveEntityType
;> if hActiveEntityType == 0x65:
	cp $65
	jr nz, .checkActiveEntityType2

;>     KnockLinkBack(slot)
	call KnockLinkBack
;>     wLinkPushedTimer = 8
	ld a, $08
	ld [wLinkPushedTimer], a
;>     pass                                     # on to the sword-proof test below
	jr .checkEntityOptions1

.checkActiveEntityType2
;> if hActiveEntityType == 0x5B:
	cp $5b
	jr nz, .checkEntityOptions1

;>     if hMultiPurposeG: KnockLinkBack(slot); return
	ldh a, [hMultiPurposeG]
	and a
	jr nz, .knockLinkBack

;>     if wEntityPrivate1[slot] == 4:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $04
	jp nz, .checkIsUsingPegasusBoots

;>         if not wIsUsingPegasusBoots: return hit()
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .checkActiveEntityType3

;>         wEntityTimer2[slot] = 0x0C
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $0c
;>         return
	ret


.checkIsUsingPegasusBoots
;>     elif wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .otherwise

;>         KnockLinkBack(slot)
	call KnockLinkBack
;>         return hit()
	jp .checkActiveEntityType3


.knockLinkBack
	call KnockLinkBack
	ret


.otherwise
;>     else:
;>         wLinkPushedTimer = 4
	ld a, $04
	ld [wLinkPushedTimer], a
;>         PushLinkAway(slot, 0x10)  # pushes Link away
	ld a, $10
	call PushLinkAway
;>         return hit()
	jp .checkActiveEntityType3


.checkEntityOptions1
;> if wEntityOptions1[slot] & 0x40:  # sword-proof
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $40
	jr z, .checkActiveEntityType3

;>     if hActiveEntityType == 0x51: return EntityCheckWeaponHits_03.setEntityPrivate1(slot)
	ldh a, [hActiveEntityType]
	cp $51
	jp z, EntityCheckWeaponHits_03.setEntityPrivate1

;>     if hActiveEntityType == 0x5C:
	cp $5c
	jr nz, .setSwordDirectionLocked

;>         SetEntityRecoil(slot, 0x30 if wActivePowerUp == 1 else 0x20)
	ld a, [wActivePowerUp]
	cp $01
	ld a, $20
	jr nz, .setEntityRecoil

	ld a, $30

.setEntityRecoil
	call SetEntityRecoil
;>         wEntityFlashTimer[slot] = 0
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], b

.setSwordDirectionLocked
;>     wSwordDirectionLocked = slot + 1
	ld a, c
	inc a
	ld [wSwordDirectionLocked], a
;>     AddClinkAtSword()
	call AddClinkAtSword
;>     wEntityIgnoreHitsTimer[slot] = 0x10
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $10
;>     wEntityRecoilSpeedX[slot] = 0
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], b
;>     wEntityRecoilSpeedY[slot] = 0
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], b
;>     return KnockLinkBack(slot)
	jp KnockLinkBack


.checkActiveEntityType3
;> return hit()                                 # not sword-proof
;=@hit1
;=@hit2
	ldh a, [hActiveEntityType]
	cp $8e
	jr nz, .checkActiveEntityType4

	call ResetPegasusBoots
	jr .checkSwordAnimationStatePrev

.checkActiveEntityType4
;=@hit3
	cp $24
	jr nz, .checkActiveEntityType5

;=@hit4
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkActiveEntityType5

;=@hit5
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, LinkFacingDirections
	add hl, de
	ld a, [hl]
;=@hit6
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr z, .checkSwordAnimationStatePrev

;=@hit7
	call ResetPegasusBoots
;=@hit8
	ld a, $10
	ld [wLinkPushedTimer], a
;=@hit9
	ld a, $10
	call PushLinkAway
;=@hit10
	ld a, $10
	call SetEntityRecoil

.setMultiPurpose0
;=@hit11
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;=@hit12
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;=@hit13
	call AddClinkVfx
	ret


.checkActiveEntityType5
;=@hit14
	ldh a, [hActiveEntityType]
	cp $15
	jp z, StartHitPause.return

.checkSwordAnimationStatePrev
;=@hit15
;=@tak1
;=@tak2
	ld a, $01
	ld [$c160], a
;=@tak3
	ld a, [wSwordAnimationStatePrev]
	cp $05
	jr nz, .setSwordCharge

	ld a, $0c
	ld [wSwordPokeTimer], a

.setSwordCharge
;=@tak4
	xor a
	ld [wSwordCharge], a
;=@tak5
	ld a, $30
	call SetEntityRecoil
;=@tak6
	ld hl, hJingle
	ld [hl], $09
;=@tak7
	ld a, [wActivePowerUp]
	cp $01
	jr nz, SwordDamageEntity

;=@tak8
	call SwordDamageEntity
;=@tak9
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $20
;=@tak10
	ld hl, wEntityHitByPowerUp
	add hl, bc
	ld [hl], $01
;=@tak11
	ld a, $11
	ldh [hWaveSfx], a
;=@tak12
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
;=@tak13
	cp $01
	jr nz, .return

	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $40

.return
	ret


;@ def SwordDamageEntity(slot: bc)
;@ path: entity/collision
;@ Marks the entity as hit by this swing and applies the sword as a weapon: weapon = wSwordLevel - 1,
;@ plus 1 for a strong hit (Piece of Power, spin attack or dash with the boots).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
SwordDamageEntity::
;> wSwordDirectionLocked = slot + 1
	ld a, c
	inc a
	ld [wSwordDirectionLocked], a
;> strong = (wActivePowerUp & 1) | wSpinAttackTimer | wIsUsingPegasusBoots
	ld a, [wActivePowerUp]
	and $01
	ld hl, wSpinAttackTimer
	or [hl]
	ld hl, wIsUsingPegasusBoots
	or [hl]
;> wProjectileWeaponType = wSwordLevel - 1 + (1 if strong else 0)
	ld a, [wSwordLevel]
	jr z, .weak

	inc a

.weak
	dec a
	ld [wProjectileWeaponType], a
;> return ApplyWeaponHit(slot)    # (runs on into it)

;@ def ApplyWeaponHit(slot: bc)
;@ path: entity/collision
;@ The damage of weapon wProjectileWeaponType against the entity. Its health group selects a row of
;@ EntityDamageClassTable, the weapon a column: that gives the damage class. WeaponDamageTable[weapon]
;@ [class] is the effect: 0 nothing, $01-$EF damage taken from wEntityHealth, $FD the entity turns
;@ into a fairy (type $2F; type $B9 counts in wEntityPrivate1 instead), $FE it burns (status 3), $FF
;@ it is stunned (StunEntity); $F0-$FC do nothing. A defeated entity goes to status 1: when it was the
;@ last boss alive the music stops, some bosses speak (types $5A, $62, $63), a defeated type $12
;@ takes the other Ghinis with it. A survivor flashes and pauses.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ApplyWeaponHit::
;> group = wEntityHealthGroup[slot]
	ld hl, wEntityHealthGroup
	add hl, bc
	ld e, [hl]
	ld d, b
;> row = group * 4
	sla e
	rl d
	sla e
	rl d
;> row = row * 4  # group * 16
	sla e
	rl d
	sla e
	rl d
;> p = EntityDamageClassTable + row + wProjectileWeaponType
	ld hl, EntityDamageClassTable
	add hl, de
	ld a, [wProjectileWeaponType]
	ld e, a
	ld d, b
	add hl, de
;> cls = mem[p]  # the damage class
	ld e, [hl]
	push de
;> col = (wProjectileWeaponType * 8) & 0xF8
	ld a, [wProjectileWeaponType]
	rla
	rla
	rla
	and $f8
;> effect = mem[WeaponDamageTable + col + cls]
	ld e, a
	ld hl, WeaponDamageTable
	add hl, de
	pop de
	add hl, de
	ld a, [hl]
;> if effect == 0: return
	and a
	ret z

	push af
;> if hActiveEntityType == 0xE6 and wFinalNightmareForm == 4:
	ldh a, [hActiveEntityType]
	cp $e6
	jr nz, .setOpts

	ld a, [wFinalNightmareForm]
	cp $04
	jr nz, .setOpts

;>     boots = wIsUsingPegasusBoots
	ld a, [wIsUsingPegasusBoots]
	push af
;>     KnockLinkBack(slot)
	call KnockLinkBack
;>     if not boots:
	pop af
	and a
	jr nz, .setOpts

;>         if not wSpinAttackTimer: return  # only strong hits count
	ld a, [wSpinAttackTimer]
	and a
	jr nz, .setOpts

	pop af
	ret


.setOpts
;> opts = wEntityOptions1[slot]; hJingle = 3
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	ld hl, hJingle
	ld [hl], $03
;> if opts & 0x80: hWaveSfx = 7  # a boss
	and $80
	jr z, .setT

	ld hl, hWaveSfx
	ld [hl], $07

.setT
;> t = wEntityType[slot]
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
;> if t == 0x6C: hWaveSfx = 0x13
	cp $6c
	jr nz, .checkEffect

	ld a, $13
	ldh [hWaveSfx], a

.checkEffect
;> if effect < 0xF0: raise NotModeled('the damage goes on in the code after StunEntity (its damage part)')
	pop af
	cp $f0
	jr c, StunEntity.setEntityHealth

;> if effect == 0xFE:  # burns
	cp $fe
	jr nz, .checkEffect2

;>     hNoiseSfx = 0x12
	ld hl, hNoiseSfx
	ld [hl], $12
;>     StartHitPause(slot)
	call StartHitPause
;>     wEntityStatus[slot] = 3
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $03
;>     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;>     wEntityPhysicsFlags[slot] += 2
	ld hl, wEntityPhysicsFlags
	add hl, bc
	inc [hl]
	inc [hl]
;>     wEntityOptions1[slot] &= 0xC2
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $c2
	ld [hl], a
;>     return
	ret


.checkEffect2
;> if effect == 0xFF:  # stunned
	cp $ff
	jr nz, StunEntity.checkEffect

;>     StartHitPause(slot)
	call StartHitPause
;>     return StunEntity(slot)                  # (runs on into it)
;> raise NotModeled('effects $F0-$FD go on in the code after StunEntity (its effect part)')
;@ def StunEntity(slot: bc)
;@ path: entity/collision
;@ Stuns the entity: status 6, wEntityTimer2 $FF, no z speed. The code after it is the rest of
;@ ApplyWeaponHit.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
StunEntity::
;>@fla1 def flash():
;>@fla2     t = wEntityType[slot]; flash = wEntityFlashTimer + slot
;>@fla3     long = t == 0xE6 and wFinalNightmareForm == 3
;>@fla4     long = long or t == 0x59
;>@fla5     if long:
;>@fla6         mem[flash] = 0x28
;>@fla7         wEntityTimer2[slot] = 0xC8
;>@fla8         return
;>@fla9     else: mem[flash] = 0x18
;>@fla10     return StartHitPause(slot)    # (runs on into it)
;>@dam1 def damage(effect):
;>@dam2     wEntityHealth[slot] -= effect
;>@dam3     if wEntityHealth[slot] > 0: return flash()  # no borrow and not zero
;>@dam4     wEntityStatus[slot] = 1  # defeated
;>@dam5     opts = wEntityOptions1[slot]
;>@dam6     if opts & 0x80:  # boss or mini-boss
;>@dam7         if not (opts & 4):  # not the dungeon's boss
;>@dam8             for n in range(15, -1, -1):
;>@dam9                 if n == slot: continue
;>@dam10                 if wEntityStatus[n] != 5: continue
;>@dam11                 if wEntityOptions1[n] & 0x80: break  # another boss still alive
;>@dam12                 continue  # next n
;>@dam13             else:
;>@dam14                 saved = wCurrentBank
;>@dam15                 SwitchBank(3)
;>@dam16                 ResetSoundEngine()  # the boss music stops
;>@dam17                 wCurrentBank = saved
;>@dam18         wDelayedWaveSfxTimer = 3
;>@dam19         wEntityPrivate2[slot] = 0
;>@dam20         t = wEntityType[slot]
;>@dam21         if t == 0x5A: msg = 0xB7
;>@dam22         elif t == 0x63: msg = 0xB9
;>@dam23         elif t == 0x62: msg = 0xBD
;>@dam24         if t in (0x5A, 0x62):
;>@dam25             OpenDialog(msg)
;>@dam26             wMusicTrackToPlay = 0x5E
;>@dam27         elif t == 0x63:
;>@dam28             saved = hLinkY; hLinkY = 0x10  # the box opens at the bottom
;>@dam29             OpenDialog(msg); hLinkY = saved
;>@dam30     wEntityState[slot] = 0
;>@dam31     wEntityDyingTimer[slot] = 0x2F
;>@dam32     wEntityFlashTimer[slot] = 0
;>@dam33     if not (wEntityOptions1[slot] & 0x80):
;>@dam34         wEntityPhysicsFlags[slot] = (wEntityPhysicsFlags[slot] & 0xF0) | 4
;>@dam35     if wEntityType[slot] != 0x12: return flash()
;>@dam36     for n in range(15, -1, -1):
;>@dam37         if n == slot: continue
;>@dam38         t = wEntityType[n]
;>@dam39         if t not in (0x10, 0x11): continue
;>@dam40         if wEntityState[n]: continue
;>@dam41         if not wEntityStatus[n]: continue
;>@dam42         wEntityStatus[n] = 1
;>@dam43         wEntityDyingTimer[n] = 0x1F
;>@dam44         r = GetRandomByte() & 3
;>@dam45         d = mem[GhiniDropTypes + r]
;>@dam46         wEntityDropType[n] = d
;>@dam47         continue  # next n
;>@dam48     wEntityDropType[slot] = 0x2E  # a rupee
;>@app1 def apply_effect(effect):
;>@app2     if effect != 0xFD: return
;>@app3     if wEntityType[slot] == 0xB9:
;>@app4         if wEntityPrivate1[slot]: return
;>@app5         wEntityPrivate1[slot] += 1
;>@app6     else:
;>@app7         wEntityType[slot] = 0x2F  # a fairy
;>@app8         InitEntityProperties(slot)
;>@app9         wEntityDropTimer[slot] = 0x80
;>@app10     hMultiPurpose0 = wEntityX[slot]
;>@app11     y = wEntityY[slot]
;>@app12     hMultiPurpose1 = y - wEntityZ[slot]
;>@app13     AddTransientVfx(2)  # a puff
;> wEntityStatus[slot] = 6
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $06
;> wEntityTimer2[slot] = 0xFF
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $ff
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ret


.checkEffect
;=@app1
;=@app2
	cp $fd
	jr nz, .return

;=@app3
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	cp $b9
	jr nz, .otherwise

;=@app4
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .return

;=@app5
	inc [hl]
	jr .setMultiPurpose0

.otherwise
;=@app6
;=@app7
	ld [hl], $2f
;=@app8
	call InitEntityProperties
;=@app9
	call GetEntityDropTimer
	ld [hl], $80

.setMultiPurpose0
;=@app10
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;=@app11
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
;=@app12
	ld hl, wEntityZ
	add hl, bc
	sub [hl]
	ldh [hMultiPurpose1], a
;=@app13
	ld a, $02
	call AddTransientVfx
	ret


.return
	ret


.setEntityHealth
;=@dam1
;=@dam2
	ld e, a
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
;=@dam3
	jr c, .setEntityStatus

	jp nz, .setT

.setEntityStatus
;=@dam4
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
;=@dam5
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
;=@dam6
	bit 7, a
	jr z, .setEntityState

;=@dam7
	bit 2, a
	jr nz, .setDelayedWaveSfxTimer

;=@dam8
	ld e, $0f
	ld d, b

.checkN
;=@dam9
	ld a, e
	cp c
	jr z, .setContinue

;=@dam10
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, .setContinue

;=@dam11
	ld hl, wEntityOptions1
	add hl, de
	ld a, [hl]
	and $80
	jr nz, .setDelayedWaveSfxTimer

.setContinue
;=@dam12
	dec e
	ld a, e
	cp $ff
	jr nz, .checkN

;=@dam13
;=@dam14
	ld a, [wCurrentBank]
	push af
;=@dam15
	ld a, $03
	call SwitchBank
;=@dam16
	call ResetSoundEngine
;=@dam17
	pop af
	ld [wCurrentBank], a

.setDelayedWaveSfxTimer
;=@dam18
	ld a, $03
	ld [wDelayedWaveSfxTimer], a
;=@dam19
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
;=@dam20
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
;=@dam21
	ld e, $b7
	cp $5a
	jr z, .checkT

;=@dam22
	ld e, $b9
	cp $63
	jr z, .checkT2

;=@dam23
	ld e, $bd
	cp $62
	jr nz, .setEntityState

.checkT
;=@dam24
;=@dam25
	ld a, e
	call OpenDialog
;=@dam26
	ld a, $5e
	ld [wMusicTrackToPlay], a
	jr .setEntityState

.checkT2
;=@dam27
;=@dam28
	ldh a, [hLinkY]
	push af
	ld a, $10
	ldh [hLinkY], a
;=@dam29
	ld a, e
	call OpenDialog
	pop af
	ldh [hLinkY], a

.setEntityState
;=@dam30
	call IncrementEntityState
	ld [hl], b
;=@dam31
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $2f
;=@dam32
	ld hl, wEntityFlashTimer
	add hl, bc
	xor a
	ld [hl], a
;=@dam33
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .checkEntityType

;=@dam34
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a

.checkEntityType
;=@dam35
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	cp $12
	jr nz, .setT

;=@dam36
	ld e, $0f
	ld d, b

.checkN2
;=@dam37
	ld a, e
	cp c
	jr z, .setContinue2

;=@dam38
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
;=@dam39
	cp $10
	jr z, .checkEntityState

	cp $11
	jr nz, .setContinue2

.checkEntityState
;=@dam40
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, .setContinue2

;=@dam41
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .setContinue2

;=@dam42
	ld [hl], $01
;=@dam43
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $1f
;=@dam44
	call GetRandomByte
	and $03
	push bc
	ld c, a
	ld b, $00
;=@dam45
	ld hl, GhiniDropTypes
	add hl, bc
	ld a, [hl]
;=@dam46
	ld hl, wEntityDropType
	add hl, de
	ld [hl], a
	pop bc

.setContinue2
;=@dam47
	dec e
	ld a, e
	cp $ff
	jr nz, .checkN2

;=@dam48
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $2e

.setT
;=@fla1
;=@fla2
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	ld hl, wEntityFlashTimer
	add hl, bc
;=@fla3
	cp $e6
	jr nz, .setLong

	ld a, [wFinalNightmareForm]
	cp $03
	jr z, .checkLong

	jr .otherwise2

.setLong
;=@fla4
	cp $59
	jr nz, .otherwise2

.checkLong
;=@fla5
;=@fla6
	ld [hl], $28
;=@fla7
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $c8
;=@fla8
	ret


.otherwise2
;=@fla9
	ld [hl], $18
;=@fla10

;@ def StartHitPause(slot: bc)
;@ path: entity/collision
;@ After a hit: the big death puff mark is cleared and the entity ignores hits for $0A frames.
;@ test: slot = rand(0, 15)
StartHitPause::
;> wEntityHitByPowerUp[slot] = 0
	ld hl, wEntityHitByPowerUp
	add hl, bc
	ld [hl], b
;> wEntityIgnoreHitsTimer[slot] = 0x0A
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $0a

.return
	ret


;@ path: entity/collision
;@ What a Ghini defeated together with its master (type $12) leaves behind, by GetRandomByte() & 3:
;@ heart $2D, rupee $2E, bombs $38, arrows $37.
GhiniDropTypes::
	db $2d, $2e, $38, $37

;@ def EntityCheckSwordClash_03(slot: bc)
;@ path: entity/collision
;@ For entities that parry with a weapon or shield (their clash box, wClashBoxX): when Link's sword
;@ meets it while they face each other, the swords clash. Link is pushed back ($12, 8 frames), the
;@ entity recoils (speed $18) and ignores hits for 8 frames, the charge is lost, a held sword pokes,
;@ and a spark appears at the sword (the Evil Eagle, type $BE, pushes Link by its attack phase
;@ instead). After a clash hSwordClashCooldown blocks the next one for $0C frames. Otherwise the clash
;@ box may hurt Link (ClashBoxHitsLink).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityCheckSwordClash_03::
;> busy = wLinkPushedTimer | wSwordDirectionLocked
	ld hl, wSwordDirectionLocked
	ld a, [wLinkPushedTimer]
	or [hl]
;> busy |= hSwordClashCooldown | wSpinAttackTimer
	ld hl, hSwordClashCooldown
	or [hl]
	ld hl, wSpinAttackTimer
	or [hl]
;> if busy: return ClashBoxHitsLink(slot)
	jp nz, .clashBoxHitsLink

;> if wSwordHitboxX == 0: return ClashBoxHitsLink(slot)
	ld a, [wSwordHitboxX]
	cp $00
	jp z, .clashBoxHitsLink

;> if wEntityDirection[slot] == hLinkDirection: return ClashBoxHitsLink(slot)  # not facing Link
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hLinkDirection]
	cp [hl]
	jp z, .clashBoxHitsLink

;> dx = hActiveEntityX + wClashBoxX
	ld de, hActiveEntityX
	ld hl, wClashBoxX
	ld a, [de]
	add [hl]
	push hl
;> dx -= wSwordHitboxX
	ld hl, wSwordHitboxX
	sub [hl]
;> dx = abs((u8(dx) ^ 0x80) - 0x80)
	cp $80
	jr c, .setLimit

	cpl
	inc a

.setLimit
;> limit = wSwordHitboxWidth + mem[addr(wClashBoxX) + 1]
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxWidth]
	add [hl]
	ld e, a
;> if dx >= limit: return ClashBoxHitsLink(slot)
	pop af
	cp e
	jp nc, .clashBoxHitsLink

;> dy = hActiveEntityDrawY + mem[addr(wClashBoxX) + 2]
	inc hl
	ld de, hActiveEntityDrawY
	ld a, [de]
	add [hl]
	push hl
;> dy -= wSwordHitboxY
	ld hl, wSwordHitboxY
	sub [hl]
;> dy = abs((u8(dy) ^ 0x80) - 0x80)
	cp $80
	jr c, .setLimit2

	cpl
	inc a

.setLimit2
;> limit = wSwordHitboxHeight + mem[addr(wClashBoxX) + 3]
	pop hl
	push af
	inc hl
	ld a, [wSwordHitboxHeight]
	add [hl]
	ld e, a
;> if dy >= limit: return ClashBoxHitsLink(slot)
	pop af
	cp e
	jp nc, .clashBoxHitsLink

;> ResetPegasusBoots()
	call ResetPegasusBoots
;> wLinkPushedTimer = 8
	ld a, $08
	ld [wLinkPushedTimer], a
;> PushLinkAway(slot, 0x12)
	ld a, $12
	call PushLinkAway
;> GetVectorTowardsLink_03(slot, 0x18)
	ld a, $18
	call GetVectorTowardsLink_03
;> wEntityRecoilSpeedY[slot] = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], a
;> wEntityRecoilSpeedX[slot] = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], a
;> StartHitPause(slot)
	call StartHitPause
;> wEntityIgnoreHitsTimer[slot] = 8
	ld [hl], $08
;> wSwordCharge = 0
	xor a
	ld [wSwordCharge], a
;> StartClinkTimer()
	call StartClinkTimer
;> if wSwordAnimationStatePrev | wSpinAttackTimer: wSwordPokeTimer = 0x0C
	ld hl, wSpinAttackTimer
	ld a, [wSwordAnimationStatePrev]
	or [hl]
	jr z, .checkActiveEntityType

	ld a, $0c
	ld [wSwordPokeTimer], a

.checkActiveEntityType
;> if hActiveEntityType == 0xBE:  # the Evil Eagle
	ldh a, [hActiveEntityType]
	cp $be
	jr nz, .otherwise2

;>     hJingle = 9
	ld a, $09
	ldh [hJingle], a
;>     attack = wEntityScratch5
	ld a, [wEntityScratch5]
;>     if attack == 0: pass
	cp $00
	jr z, .otherwise

;>     elif attack in (1, 4):
	cp $01
	jr z, .setLinkPushedTimer

	cp $04
	jr z, .setLinkPushedTimer

;>@p1         wLinkPushedTimer = 0x10
;>@p2         PushLinkAway(slot, 0x20)
;>     elif attack == 3: return EvilEagleThrowsLink(slot)
	cp $03
	jp z, EvilEagleThrowsLink

;>     else:
;>         wLinkPushedTimer = 0x20
	ld a, $20
	ld [wLinkPushedTimer], a
;>         PushLinkAway(slot, 0x20)
	ld a, $20
	call PushLinkAway
	jr .setSwordClashCooldown

.setLinkPushedTimer
;=@p1
	ld a, $10
	ld [wLinkPushedTimer], a
;=@p2
	ld a, $20
	call PushLinkAway

.otherwise
	jr .setSwordClashCooldown

.otherwise2
;> else:
;>     d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
;>     hMultiPurpose0 = wSwordHitboxX + mem[ClashSparkOffsetsX + d]
	ld hl, ClashSparkOffsetsX
	add hl, de
	ld a, [wSwordHitboxX]
	add [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = wSwordHitboxY + mem[ClashSparkOffsetsY + d]
	ld hl, ClashSparkOffsetsY
	add hl, de
	ld a, [wSwordHitboxY]
	add [hl]
	ldh [hMultiPurpose1], a
;>     AddClinkVfx()
	call AddClinkVfx

.setSwordClashCooldown
;> hSwordClashCooldown = 0x0C
	ld a, $0c
	ldh [hSwordClashCooldown], a
	ret


.clashBoxHitsLink
;> # (no clash:)
	jp ClashBoxHitsLink


;@ path: entity/collision
;@ Where the clash spark appears from the sword hitbox centre, x by Link's direction (0 right, 1 left,
;@ 2 up, 3 down): 0, -$10, -8, -4.
ClashSparkOffsetsX::
	db $00, $f0, $f8, $fc

;@ path: entity/collision
;@ Y offset of the clash spark by Link's direction: -4, -4, -$10, 0.
ClashSparkOffsetsY::
	db $fc, $fc, $f0, $00

;@ def ClashBoxHitsLink(slot: bc)
;@ path: entity/collision
;@ On every other frame: when the entity's clash box overlaps Link (half sizes + 4 across, + 5 down)
;@ and Link is not invincible, Link is hurt (HurtLink). The Evil Eagle (type $BE) in attack 2 then
;@ blows him away (speed $30, wEntityTimer1 $A0); in attack 3 it throws him (EvilEagleThrowsLink).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
ClashBoxHitsLink::
;> if not ((hFrameCounter ^ slot) & 1): return
	ldh a, [hFrameCounter]
	xor c
	rra
	jr nc, PushLinkAway.return

;> hMultiPurpose0 = hLinkX + 8
	ldh a, [hLinkX]
	add $08
	ldh [hMultiPurpose0], a
;> hMultiPurpose2 = hLinkY + 8
	ldh a, [hLinkY]
	add $08
	ldh [hMultiPurpose2], a
;> dx = hActiveEntityX + wClashBoxX
	ld de, hActiveEntityX
	ld hl, wClashBoxX
	ld a, [de]
	add [hl]
	push hl
;> dx -= hMultiPurpose0
	ld hl, hMultiPurpose0
	sub [hl]
;> dx = abs((u8(dx) ^ 0x80) - 0x80)
	cp $80
	jr c, .setLimit

	cpl
	inc a

.setLimit
;> limit = mem[addr(wClashBoxX) + 1] + 4
	pop hl
	push af
	inc hl
	ld a, $04
	add [hl]
	ld e, a
;> if dx >= limit: return
	pop af
	cp e
	jr nc, PushLinkAway.return

;> dy = hActiveEntityDrawY + mem[addr(wClashBoxX) + 2]
	inc hl
	ld de, hActiveEntityDrawY
	ld a, [de]
	add [hl]
	push hl
;> dy -= hMultiPurpose2
	ld hl, hMultiPurpose2
	sub [hl]
;> dy = abs((u8(dy) ^ 0x80) - 0x80)
	cp $80
	jr c, .setLimit2

	cpl
	inc a

.setLimit2
;> limit = mem[addr(wClashBoxX) + 3] + 5
	pop hl
	push af
	inc hl
	ld a, $05
	add [hl]
	ld e, a
;> if dy >= limit: return
	pop af
	cp e
	jr nc, PushLinkAway.return

;> if wInvincibilityCounter: return
	ld a, [wInvincibilityCounter]
	and a
	jr nz, PushLinkAway.return

;> HurtLink(slot)
	call HurtLink
;> if hActiveEntityType != 0xBE: return
	ldh a, [hActiveEntityType]
	cp $be
	jr nz, PushLinkAway.return

;> attack = wEntityScratch5
	ld a, [wEntityScratch5]
;> if attack in (0, 1, 4): return
	and a
	jr z, PushLinkAway.return

	cp $01
	jr z, PushLinkAway.return

	cp $04
	jr z, PushLinkAway.return

;> if attack != 2: return EvilEagleThrowsLink(slot)
	cp $02
	jr nz, EvilEagleThrowsLink.checkEntityPrivateCounter

;> wEntityTimer1[slot] = 0xA0
	call GetEntityTimer1
	ld [hl], $a0
;> wLinkPushedTimer = 0x20
	ld a, $20
	ld [wLinkPushedTimer], a
;> return PushLinkAway(slot, 0x30)
	ld a, $30

;@ def PushLinkAway(slot: bc, speed: a)
;@ path: entity/collision
;@ Gives Link the given speed away from the entity (the vector from the entity towards him).
;@ test: slot = rand(0, 15)
PushLinkAway::
;> GetVectorTowardsLink_03(slot, speed)
	call GetVectorTowardsLink_03
;> hLinkSpeedY = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;> hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a

.return
	ret


;@ def EvilEagleThrowsLink(slot: bc)
;@ path: boss/evil-eagle
;@ Attack 3 of the Evil Eagle: once wEntityPrivateCounter is $22 or more, Link is thrown off the
;@ tower: motion state $0A, x speed $30 (or -$30 when the eagle faces left), z speed $30, jingle $0B.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EvilEagleThrowsLink::
.checkEntityPrivateCounter
;> if wEntityPrivateCounter[slot] < 0x22: return
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $22
	jr c, PushLinkAway.return

;> wLinkMotionState = 0x0A
	ld a, $0a
	ld [wLinkMotionState], a
;> dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
;> hLinkSpeedX = 0x30 if dir == 0 else 0xD0
	and a
	ld a, $30
	jr z, .setLinkSpeedY

	ld a, $d0

.setLinkSpeedY
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;> hLinkSpeedZ = 0x30
	ld a, $30
	ldh [hLinkSpeedZ], a
;> hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
	ret


;@ path: unused
;@ 9 bytes of code no one reaches: `ld a, $20` / `ld [wLinkPushedTimer], a` / `ld a, $20` /
;@ `jr PushLinkAway`.
Unused759D::
	db $3e, $20, $ea, $3e, $c1, $3e, $20, $18, $c3

;@ def EntityHitOtherEntities_03(slot: bc)
;@ path: entity/collision
;@ A weapon entity (Link's arrows, boomerang, hookshot, fireball, magic powder, thrown objects...)
;@ against every other active entity within 12 pixels, each one on every other frame. A pickup is
;@ caught by the boomerang or hookshot. Entities with hitbox flag bit 7 (and the Final Nightmare's
;@ last form unless hit from the right side) block it; type $24 blocks it from the front (the
;@ hookshot pulls its shield off: a type $32 entity carried back). Magic powder wakes type $CA and,
;@ outdoors, type $3F. Otherwise the target is hit (ProjectileHitsEntity). Afterwards the weapon:
;@ boomerang and hookshot come back, a thrown object breaks, type $A8 and thrown entities bounce
;@ off, an arrow without a bomb or another weapon that hit no wall vanishes.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityHitOtherEntities_03::
;>@st1 def stop():                              # .setEntityTimer2: the weapon comes back / stops
;>@st2     wEntityTimer[slot] = 0
;>@bo1 def bounce():                            # .checkEntityDyingTimer: bounces off
;>@bo2     if wEntityDyingTimer[slot]: return
;>@bo3     wEntityDyingTimer[slot] = 0x0C
;>@bo4     wEntitySpeedX[slot] = u8(((wEntitySpeedX[slot] ^ 0x80) - 0x80) >> 2)  # a quarter (signed)
;>@bo5     wEntitySpeedX[slot] = u8(~wEntitySpeedX[slot])  # turned
;>@bo6     wEntitySpeedY[slot] = u8(((wEntitySpeedY[slot] ^ 0x80) - 0x80) >> 2)
;>@bo7     wEntitySpeedY[slot] = u8(~wEntitySpeedY[slot])
;>@bo8     return stop()
;>@re1 def reaction(n):                         # .checkActiveEntityType3: the weapon after a hit
;>@re2     if hActiveEntityType == 0xA8: return bounce()
;>@re3     if hActiveEntityType in (1, 3): return stop()  # comes back
;>@re4     if hActiveEntityType == 5:
;>@re5         BreakThrownObject(slot)
;>@re6         return
;>@re7     if wEntityStatus[slot] == 8: return bounce()  # thrown
;>@re8     if wEntityCollisions[slot]: return stop()
;>@re9     if hActiveEntityType == 0 and hActiveEntityState: return  # a bomb arrow stays
;>@re10     FreeEntitySlot(slot)                     # the weapon vanishes
;>@re11     return
;>@bl1 def blocked(n):                          # .setEntityCollisions
;>@bl2     wEntityCollisions[slot] = 1
;>@bl3     return reaction(n)
;>@pi1 def pickup(n):                           # .checkActiveEntityType2: the boomerang and the hookshot catch a pickup
;>@pi2     if hActiveEntityType not in (1, 3): return
;>@pi3     wEntityTimer[slot] = 0                   # comes back
;>@pi4     if not (wEntityPhysicsFlags[n] & 0x20): return reaction(n)
;>@pi5     wEntityPrivate5[n] = slot + 1
;>@pi6     return
;> for n in range(15, -1, -1):
	ld e, $0f
	ld d, $00

.checkN
;>     if n == slot: continue
	ld a, e
	cp c
	jp z, .setContinue3

;>     if (hFrameCounter ^ n) & 1: continue
	ldh a, [hFrameCounter]
	xor e
	and $01
	jp nz, .setContinue3

;>     if wEntityStatus[n] < 5: continue
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jp c, .setContinue3

;>     if wEntityPhysicsFlags[n] & 0x40: continue
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $40
	jp nz, .setContinue3

;>     dx = hActiveEntityX - wEntityX[n]
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
;>     if (dx + 0x0C) & 0xFF >= 0x18: continue
	add $0c
	cp $18
	jp nc, .setContinue3

;>     dy = wEntityY[n] - wEntityZ[n]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, de
	sub [hl]
;>     if (dy - hActiveEntityDrawY + 0x0C) & 0xFF >= 0x18: continue
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $0c
	cp $18
	jp nc, .setContinue3

;>     if wEntitySpriteVariant[n] == 0xFF: continue  # invisible
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [hl]
	cp $ff
	jp z, .setContinue3

;>     if hActiveEntityType == 0x55: wEntityTimer[slot] = 0
	ldh a, [hActiveEntityType]
	cp $55
	jr nz, .checkEntityType

	call GetEntityTimer
	ld [hl], b

.checkEntityType
;>     if wEntityType[n] == 0x55:  # passes the hit on: takes the weapon's speed
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $55
	jr nz, .checkEntityPhysicsFlags

;>         wEntitySpeedX[n] = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntitySpeedY[n] = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>         wEntityTimer[n] = 0x40
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
;>         wEntityState[n] = 2
	ld hl, wEntityState
	add hl, de
	ld [hl], $02
;>         wEntityTimer1[n] = 8
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $08
;>         continue
	jp .setContinue3


.checkEntityPhysicsFlags
;>     if wEntityPhysicsFlags[n] & 0x20: pickup(n); continue  # a pickup
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $20
	jp nz, .checkActiveEntityType2

;>     if hActiveEntityType != 8:  # not magic powder
	ldh a, [hActiveEntityType]
	cp $08
	jr z, .checkActiveEntityType

;>         t = wEntityType[n]
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
;>         if t == 0xE6 and wFinalNightmareForm == 5:
	cp $e6
	jr nz, .checkEntityHitboxFlags

	ld a, [wFinalNightmareForm]
	cp $05
	jr nz, .checkEntityHitboxFlags

;>             if hActiveEntitySpriteVariant != 2: blocked(n); continue
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nz, .setEntityCollisions

.checkEntityHitboxFlags
;>         if wEntityHitboxFlags[n] & 0x80: blocked(n); continue
	ld hl, wEntityHitboxFlags
	add hl, de
	ld a, [hl]
	and $80
	jr z, .checkActiveEntityType

.setEntityCollisions
;=@bl1
;=@bl2
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $01
;=@bl3
	jp .checkActiveEntityType3


.checkActiveEntityType
;>     if hActiveEntityType == 8:  # magic powder
	ldh a, [hActiveEntityType]
	cp $08
	jr nz, .checkEntityHitboxFlags2

;>         t = wEntityType[n]
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
;>         if t == 0xCA:
	cp $ca
	jr nz, .checkT

;>             if not wEntityState[n]:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, .checkEntityHitboxFlags2

;>                 wEntityState[n] += 1  # t now holds the old state 0: the next test fails
	inc [hl]

.checkT
;>         if t == 0x3F and not wIsIndoor:
	cp $3f
	jr nz, .checkEntityHitboxFlags2

	ld a, [wIsIndoor]
	and a
	jr nz, .checkEntityHitboxFlags2

;>             if wEntityState[n] == 0:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, .checkEntityHitboxFlags2

;>                 wEntityState[n] += 1
	inc [hl]
;>                 wEntityDropTimer[n] = 0x7F
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $7f
;>                 wEntityFlashTimer[n] = 0x10
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $10
;>                 wCurrentBank = 3; ResetSoundEngine()
	ld a, $03
	ld [wCurrentBank], a
	call ResetSoundEngine
;>                 wCurrentBank = 0x18
	ld a, $18
	ld [wCurrentBank], a

.checkEntityHitboxFlags2
;>     if wEntityHitboxFlags[n] & 0x80: continue
	ld hl, wEntityHitboxFlags
	add hl, de
	ld a, [hl]
	and $80
	jp nz, .setContinue3

;>     if wEntityIgnoreHitsTimer[n]: continue
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld a, [hl]
	and a
	jp nz, .setContinue3

;>     if wEntityType[n] == 0x24:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $24
	jr nz, .projectileHitsEntity

;>         facing = wEntityDirection[n] ^ 1
	ld hl, wEntityDirection
	add hl, de
	ld a, [hl]
	xor $01
;>         if facing == wEntityDirection[slot]:  # it faces the weapon
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr nz, .projectileHitsEntity

;>             if not wEntityPrivate2[n]:  # still has its shield
	ld hl, wEntityPrivate2
	add hl, de
	ld a, [hl]
	and a
	jr nz, .projectileHitsEntity

;>                 if hActiveEntityType != 3: blocked(n); continue  # only the hookshot
	ldh a, [hActiveEntityType]
	cp $03
	jp nz, .setEntityCollisions

;>                 wEntityPrivate2[n] = 1
	ld [hl], $01
;>                 m, full = SpawnEntity_03(slot, 0x32)  # the shield
	push de
	ld a, $32
	call SpawnEntity_03
;>                 if not full:
	jr c, .weaponreaction

;>                     wEntityX[m] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>                     wEntityY[m] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>                     wEntityPrivate5[m] = slot + 1  # carried by the hookshot
	ld hl, wEntityPrivate5
	add hl, de
	ld a, c
	inc a
	ld [hl], a
;>                     wEntitySpriteVariant[m] = hMultiPurpose2 & 1
	ldh a, [hMultiPurpose2]
	and $01
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a

.weaponreaction
;>                 reaction(n); continue
	pop de
	jr .checkActiveEntityType3

.projectileHitsEntity
;>     ProjectileHitsEntity(slot, n)
	call ProjectileHitsEntity
;>     reaction(n); continue
	jr .checkActiveEntityType3

.checkActiveEntityType2
;=@pi1
;=@pi2
	ldh a, [hActiveEntityType]
	cp $01
	jr z, .setEntityTimer

	cp $03
	jr nz, .setContinue

.setEntityTimer
;=@pi3
	call GetEntityTimer
	xor a
	ld [hl], a
;=@pi4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $20
	jr z, .checkActiveEntityType3

;=@pi5
	ld a, c
	inc a
	ld hl, wEntityPrivate5
	add hl, de
	ld [hl], a

.setContinue
;=@pi6
	jp .setContinue3


.checkActiveEntityType3
;=@re1
;=@re2
	ldh a, [hActiveEntityType]
	cp $a8
	jr z, .checkEntityDyingTimer

;=@re3
	cp $01
	jr z, .setEntityTimer2

	cp $03
	jr z, .setEntityTimer2

;=@re4
	cp $05
	jr nz, .checkEntityStatus

;=@re5
	push de
	call BreakThrownObject
	pop de
;=@re6
	jp .setContinue3


.checkEntityStatus
;=@re7
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, .checkEntityCollisions

.checkEntityDyingTimer
;=@bo1
;=@bo2
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .setContinue3

;=@bo3
	ld [hl], $0c
;=@bo4
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	sra [hl]
;=@bo5
	ld a, [hl]
	cpl
	ld [hl], a
;=@bo6
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
	sra [hl]
;=@bo7
	ld a, [hl]
	cpl
	ld [hl], a
;=@bo8
	jr .setEntityTimer2

.checkEntityCollisions
;=@re8
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .setEntityTimer2

;=@re9
	ldh a, [hActiveEntityType]
	cp $00
	jr nz, .freeEntitySlot

	ldh a, [hActiveEntityState]
	and a
	jr nz, .setContinue2

.freeEntitySlot
;=@re10
	call FreeEntitySlot

.setContinue2
;=@re11
	jr .setContinue3

.setEntityTimer2
;=@st1
;=@st2
	call GetEntityTimer
	xor a
	ld [hl], a

.setContinue3
;>     continue  # next n
	dec e
	ld a, e
	cp $ff
	jp nz, .checkN

	ret


;@ def ProjectileHitsEntity(slot: bc, n: e)
;@ path: entity/collision
;@ The weapon in slot c hits entity n: a bomb arrow explodes (its timer becomes 3); otherwise the
;@ target recoils with the weapon's speed and takes the weapon's effect (ApplyWeaponHit for slot n).
;@ test: slot = rand(0, 15)
ProjectileHitsEntity::
;> if hActiveEntityType == 0 and hActiveEntityState:  # a bomb arrow
	ldh a, [hActiveEntityType]
	cp $00
	jr nz, .hit

	ldh a, [hActiveEntityState]
	and a
	jr z, .hit

;>     wEntityTimer[slot] = 3
	call GetEntityTimer
	ld [hl], $03
;>     return
	ret


.hit
;> wEntityRecoilSpeedX[n] = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityRecoilSpeedX
	add hl, de
	ld [hl], a
;> wEntityRecoilSpeedY[n] = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityRecoilSpeedY
	add hl, de
	ld [hl], a
;> ApplyWeaponHitTo(slot=n)
	push bc
	push de
	pop bc
	push de
	call ApplyWeaponHitTo
;> return
	pop de
	pop bc
	ret


;@ def ApplyWeaponHitTo(slot: bc)
;@ path: entity/collision
;@ ApplyWeaponHit for the given slot.
;@ test: slot = rand(0, 15)
ApplyWeaponHitTo::
;> ApplyWeaponHit(slot)
	call ApplyWeaponHit
	ret


;@ def BombHitsEntities(slot: bc)
;@ path: item/bomb
;@ The explosion (at its frame $12) hits every active entity within $18 pixels that can be hit
;@ (physics flags $60 and hitbox flag bit 7 clear) as weapon 7, and throws it away from the bomb
;@ with speed $30.
;@ test: slot = rand(0, 15)
BombHitsEntities::
;> for n in range(15, -1, -1):
	ld e, $0f
	ld d, $00

.checkEntityStatus
;>     if wEntityStatus[n] < 5: continue
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr c, .setContinue

;>     if wEntityPhysicsFlags[n] & 0x60: continue
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $60
	jr nz, .setContinue

;>     if wEntityHitboxFlags[n] & 0x80: continue
	ld hl, wEntityHitboxFlags
	add hl, de
	ld a, [hl]
	and $80
	jr nz, .setContinue

;>     dx = hActiveEntityX - wEntityX[n]
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
;>     if (dx + 0x18) & 0xFF >= 0x30: continue
	add $18
	cp $30
	jr nc, .setContinue

;>     dy = wEntityY[n] - wEntityZ[n]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, de
	sub [hl]
;>     if (dy - hActiveEntityDrawY + 0x18) & 0xFF >= 0x30: continue
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $18
	cp $30
	jr nc, .setContinue

;>     wProjectileWeaponType = 7
	ld a, $07
	ld [wProjectileWeaponType], a
;>     ProjectileHitsEntity(slot, n)
	call ProjectileHitsEntity
;>     GetVectorTowardsEntity(slot, n, 0x30)
	ld a, $30
	call GetVectorTowardsEntity
;>     wEntityRecoilSpeedY[n] = hMultiPurpose0
	ld hl, wEntityRecoilSpeedY
	add hl, de
	ldh a, [hMultiPurpose0]
	ld [hl], a
;>     wEntityRecoilSpeedX[n] = hMultiPurpose1
	ld hl, wEntityRecoilSpeedX
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hl], a

.setContinue
;>     continue  # next n
	dec e
	ld a, e
	cp $ff
	jr nz, .checkEntityStatus

	ret


;@ def GetVectorTowardsEntity(slot: bc, n: de, speed: a)
;@ path: entity/collision
;@ GetVectorTowardsLink_03 with entity n standing in for Link: the speed vector from slot c towards
;@ entity n (y in hMultiPurpose0, x in hMultiPurpose1). Link's position is restored afterwards.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
;@ test: n = rand(0, 15)
GetVectorTowardsEntity::
;> hMultiPurpose0 = speed
	ldh [hMultiPurpose0], a
;> savedX = hLinkX; hLinkX = wEntityX[n]
	ldh a, [hLinkX]
	push af
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;> savedY = hLinkY; hLinkY = wEntityY[n]
	ldh a, [hLinkY]
	push af
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
;> GetVectorTowardsLink_03(slot, hMultiPurpose0)
	push de
	ldh a, [hMultiPurpose0]
	call GetVectorTowardsLink_03
	pop de
;> hLinkY = savedY; hLinkX = savedX
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	ret


;@ path: entity/walls
;@ X offsets of the wall probe points from wEntityX - 8, index = size * 4 + direction (size =
;@ wEntityHitboxFlags & 3; direction 0 right, 1 left, 2 up, 3 down): size 0 and 3: $0D, 2, 8, 8;
;@ size 1: $0A, 6, 8, 8; size 2: $10, -1, 8, 8.
WallProbeOffsetsX::
	db $0d, $02, $08, $08, $0a, $06, $08, $08, $10, $ff, $08, $08, $0d, $02, $08, $08
;@ path: entity/walls
;@ Y offsets of the probe points from wEntityY - $10, same index: size 0 and 3: 8, 8, 2, $0D;
;@ size 1: 8, 8, 6, $0A; size 2: 8, 8, -1, $10.
WallProbeOffsetsY::
	db $08, $08, $02, $0d, $08, $08, $06, $0a, $08, $08, $ff, $10, $08, $08, $02, $0d
;@ path: entity/walls
;@ wEntityCollisions bit for a wall in direction 0-3: 1 right, 2 left, 4 up, 8 down.
WallCollisionBits::
	db $01, $02, $04, $08

;@ path: entity/walls
;@ How a conveyor floor (physics $F0-$F7) moves an entity every 4 frames, x by its kind 0-7: 0, 0,
;@ -1, +1, +1, -1, +1, -1.
ConveyorPushX::
	db $00, $00, $ff, $01, $01, $ff, $01, $ff

;@ path: entity/walls
;@ Y push of the conveyor kinds 0-7: +1, -1, 0, 0, +1, +1, -1, -1.
ConveyorPushY::
	db $01, $ff, $00, $00, $01, $01, $ff, $ff

;@ def EntityCheckWalls_03(slot: bc)
;@ path: entity/walls
;@ The entity against the room: first the ground under it (when it is not in the air and its option
;@ bit 4 is clear): object $67 and physics $B0 give ground status 1, shallow water (5) 2, tall grass
;@ (6) 3; deep water and lava (7, $0B) drown it (a splash, the slot is freed) unless it is one of the
;@ types $CC, $A0, $D5, $6D, $C1. Entities with option bit 3 splash when they come down onto other
;@ ground. Conveyors (physics $F0-$F7) carry it. A pit (object $61, physics $50/$51) swallows it while
;@ it is knocked back (status 2 towards the hole). Then the walls in the direction of its x and y
;@ speed (EntityCheckWallAt): a wall sets the wEntityCollisions bit, notes the object in
;@ wEntityWallObjectX/Y and puts the entity back (unless hWallCheckOnly). Type $6D skips the walls.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityCheckWalls_03::
;> hMultiPurpose0 = wEntityGroundStatus[slot]  # the old ground
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> wEntityGroundStatus[slot] = 0
	xor a
	ld [hl], a
;> hMultiPurpose1 = 0
	ldh [hMultiPurpose1], a
;> wEntityWallObjectX = 0
	ld [wEntityWallObjectX], a
;> wEntityWallObjectY = 0
	ld [wEntityWallObjectY], a
;> z = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
;> ground = z == 0 or z & 0x80                 # on the floor (z <= 0), not in the air
	bit 7, a
	jr nz, .setEntityLedgeCredit
	and a
	jp nz, .checkActiveEntityType2
.setEntityLedgeCredit
;> if ground:
;>     wEntityLedgeCredit[slot] = 0
	ld hl, wEntityLedgeCredit
	add hl, bc
	ld [hl], b
;>     ground = not (wEntityOptions1[slot] & 0x10)   # option bit 4: the ground does not matter
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	bit 4, a
	jp nz, .checkActiveEntityType2
;> if ground:
;>     GetObjectUnderEntity_03(slot)            # hRoomObjectType, its physics in hMultiPurpose3
	call GetObjectUnderEntity_03
	jr .checkRoomObjectType
.setG
;=@d0
	ld e, $02
;=@d1
	ldh a, [hActiveEntityType]
	cp $cc
	jr z, .setEntityGroundStatus
	cp $a0
	jr z, .setEntityGroundStatus
;=@d1
	cp $d5
	jr z, .setEntityGroundStatus
	cp $6d
	jr z, .setEntityGroundStatus
	cp $c1
	jr z, .setEntityGroundStatus
;=@d2
	call FreeEntitySlot
;=@d3
	jp .setMultiPurpose0
.checkRoomObjectType
;>     g, splash = 1, False                     # 1: plain ground
	ld e, $01
;>     phys = 0xB0 if hRoomObjectType == 0x67 else hMultiPurpose3   # object $67 counts as plain ground
	ldh a, [hRoomObjectType]
	cp $67
	jr z, .setEntityGroundStatus
	ldh a, [hMultiPurpose3]
;>     ground = phys != 0                       # physics 0: only the walls are checked
	and a
	jp z, .checkActiveEntityType2
;> if ground:
;>     if phys in (0x0B, 0x07):                 # deep water or lava
;>@d0         g = 2
;>@d1         if hActiveEntityType not in (0xCC, 0xA0, 0xD5, 0x6D, 0xC1):   # these types do not drown
;>@d2             FreeEntitySlot(slot)         # drowned
;>@d3             g, splash = 0, True
	cp $0b
	jr z, .setG
	cp $07
	jr z, .setG
;>     elif phys != 0xB0:
	cp $b0
	jr z, .setEntityGroundStatus
;>         g = {5: 2, 6: 3}.get(phys, 0)        # shallow water 2, tall grass 3, other ground: no status
	inc e
	cp $05
	jr z, .setEntityGroundStatus
	cp $06
	jr nz, .checkEntityOptions1
	inc e
.setEntityGroundStatus
;>     if g:
;>         wEntityGroundStatus[slot] = g
	ld hl, wEntityGroundStatus
	add hl, bc
	ld [hl], e
.checkEntityOptions1
;>     if not splash:
;>         landing = wEntityOptions1[slot] & 8  # option bit 3: it splashes when it lands on other ground
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $08
	jr z, .checkMultiPurpose3
;>         landing = landing and wEntityGroundStatus[slot] != hMultiPurpose0
	ld hl, wEntityGroundStatus
	add hl, bc
	ldh a, [hMultiPurpose0]
	cp [hl]
	jr z, .checkMultiPurpose3
;>         landing = landing and 3 not in (wEntityGroundStatus[slot], hMultiPurpose0)   # not in tall grass
	ld a, [hl]
	cp $03
	jr z, .checkMultiPurpose3
	ldh a, [hMultiPurpose0]
	cp $03
	jr z, .checkMultiPurpose3
;>         if landing:
;>             if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .checkActiveEntityType
;>                 v = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;>                 landing = v & 0x80 and v < 0xE7      # falling faster than -$19
	bit 7, a
	jr z, .checkMultiPurpose3
	cp $e7
	jr nc, .checkMultiPurpose3
	jr .checkEntityDyingTimer
.checkActiveEntityType
;>             elif hActiveEntityType != 0xAC:
	ldh a, [hActiveEntityType]
	cp $ac
	jr z, .checkEntityDyingTimer
;>                 if not wEntitySpeedY[slot] & 0x80:   # moving down: it stops, half the x speed
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, .checkEntityDyingTimer
;>                     wEntitySpeedY[slot] = 0
	ld [hl], $00
;>                     wEntitySpeedX[slot] = (wEntitySpeedX[slot] >> 1) | (wEntitySpeedX[slot] & 0x80)
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
.checkEntityDyingTimer
;>             splash = landing and not wEntityDyingTimer[slot]
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkMultiPurpose3
.setMultiPurpose0
;>     if splash:
;>         hMultiPurpose0 = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;>         hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;>         AddTransientVfx(1)                   # a splash
	ld a, $01
	call AddTransientVfx
.checkMultiPurpose3
;>     if u8(hMultiPurpose3 + 1) >= 0xF1:       # a conveyor (physics $F0-$FE)
	ldh a, [hMultiPurpose3]
	inc a
	cp $f1
	jr c, .setPit
;>         k = hMultiPurpose3 - 0xF0
	sub $f1
	ld e, a
	ld d, b
;>         if not hFrameCounter & 3:            # every 4th frame
	ldh a, [hFrameCounter]
	and $03
	jr nz, .return
;>             dx = mem[ConveyorPushX + k]
	ld hl, ConveyorPushX
	add hl, de
	ld a, [hl]
;>             wEntityX[slot] = u8(wEntityX[slot] + dx)
	ld hl, wEntityX
	add hl, bc
	add [hl]
	ld [hl], a
;>             dy = mem[ConveyorPushY + k]
	ld hl, ConveyorPushY
	add hl, de
	ld a, [hl]
;>             wEntityY[slot] = u8(wEntityY[slot] + dy)
	ld hl, wEntityY
	add hl, bc
	add [hl]
	ld [hl], a
.return
	jr .checkActiveEntityType2
.setPit
;>     else:
;>@p1         pit = hRoomObjectType == 0x61 or hMultiPurpose3 in (0x50, 0x51)   # a pit under it
	ldh a, [hRoomObjectType]
	cp $61
	jr z, .setT
	ldh a, [hMultiPurpose3]
;=@p1
	cp $50
	jr z, .setT
	cp $51
	jr nz, .checkActiveEntityType2
.setT
;>         t = hActiveEntityType
	ldh a, [hActiveEntityType]
;>         falls = pit and t not in (0x6D, 0xD5, 0x36)
	cp $6d
	jr z, .checkActiveEntityType2
	cp $d5
	jr z, .checkActiveEntityType2
	cp $36
	jr z, .checkActiveEntityType2
;>         if falls and t == 0xC1:              # type $C1 only into a hole (object $61) while Link falls too
	cp $c1
	jr nz, .checkEntityIgnoreHitsTimer
;>             falls = wLinkMotionState == 6 and hRoomObjectType == 0x61
	ld a, [wLinkMotionState]
	cp $06
	jr nz, .checkActiveEntityType2
	ldh a, [hRoomObjectType]
	cp $61
	jr nz, .checkActiveEntityType2
.checkEntityIgnoreHitsTimer
;>         if falls and wEntityIgnoreHitsTimer[slot]:   # only while it is knocked back
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .checkActiveEntityType2
;>             wEntityIgnoreHitsTimer[slot] -= 1
	dec [hl]
;>             wEntityFlashTimer[slot] = 0
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $00
;>             wEntityStatus[slot] = 2              # falls into the pit
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $02
;>             wEntityPitX[slot] = u8(hBGPosX + 8)
	ldh a, [hBGPosX]
	add $08
	ld hl, wEntityPitX
	add hl, bc
	ld [hl], a
;>             wEntityPitY[slot] = u8(hBGPosY + 0x10)
	ldh a, [hBGPosY]
	add $10
	ld hl, wEntityPitY
	add hl, bc
	ld [hl], a
;>             wEntityTimer[slot] = 0x6F
	call GetEntityTimer
	ld [hl], $6f
;>             t = hActiveEntityType
	ldh a, [hActiveEntityType]
;>             if t not in (0x14, 0x0B, 0x09):
	cp $14
	jr z, .checkActiveEntityType2
	cp $0b
	jr z, .checkActiveEntityType2
	cp $09
	jr z, .checkActiveEntityType2
;>                 wEntityTimer[slot] = 0x48
	ld [hl], $48
;>                 if not wEntityIgnoreHitsTimer[slot]:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkActiveEntityType2
;>                     wEntityTimer[slot] = 0x2F
	call GetEntityTimer
	ld [hl], $2f
;>                     hJingle = 0x18
	ld a, $18
	ldh [hJingle], a
.checkActiveEntityType2
;> if hActiveEntityType == 0x6D: return         # type $6D ignores walls
	ldh a, [hActiveEntityType]
	cp $6d
	jp z, .return2
;> wEntityWallObjectX = 0
	xor a
	ld [wEntityWallObjectX], a
;> size = wEntityHitboxFlags[slot] & 3
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld a, [hl]
	and $03
;> hMultiPurpose0 = size * 4
	sla a
	sla a
	ldh [hMultiPurpose0], a
;> wEntityCollisions[slot] = 0
	ld hl, wEntityCollisions
	add hl, bc
	xor a
	ld [hl], a
;> if wEntitySpeedX[slot]:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cp $00
	jr z, .checkEntitySpeedY
;>     dir = 1 if wEntitySpeedX[slot] & 0x80 else 0   # left / right
	ld de, $0000
	and $80
	jr z, .checkEntityCheckWallAt
	inc e
.checkEntityCheckWallAt
;>     if not EntityCheckWallAt(slot, dir):     # a wall
	call EntityCheckWallAt
	jr c, .checkEntitySpeedY
;>         wEntityWallObjectX = hRoomObjectType
	ldh a, [hRoomObjectType]
	ld [wEntityWallObjectX], a
;>         if not hWallCheckOnly:
	ldh a, [hWallCheckOnly]
	and a
	jr nz, .checkEntitySpeedY
;>             wEntityX[slot] = hActiveEntityX  # back
	ld hl, wEntityX
	add hl, bc
	ldh a, [hActiveEntityX]
	ld [hl], a
.checkEntitySpeedY
;> if wEntitySpeedY[slot]:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $00
	jr z, .return2
;>     dir = 2 if wEntitySpeedY[slot] & 0x80 else 3   # up / down
	ld de, $0002
	and $80
	jr nz, .checkEntityCheckWallAt2
	inc e
.checkEntityCheckWallAt2
;>     if not EntityCheckWallAt(slot, dir):
	call EntityCheckWallAt
	jr c, .return2
;>         wEntityWallObjectY = hRoomObjectType
	ldh a, [hRoomObjectType]
	ld [wEntityWallObjectY], a
;>         if not hWallCheckOnly:
	ldh a, [hWallCheckOnly]
	and a
	jr nz, .return2
;>             wEntityY[slot] = hActiveEntityY
	ld hl, wEntityY
	add hl, bc
	ldh a, [hActiveEntityY]
	ld [hl], a
.return2
	ret


;@ path: entity/walls
;@ Which quarters of a 16x16 square are solid for the partial walls (physics $7C-$8D): 4 bytes per
;@ physics value (index (physics - $7C) * 4 + quarter; quarter = right half 1 + lower half 2), 1 =
;@ solid. 18 entries, 72 bytes.
PartialWallSolidity::
	db $01, $00, $01, $00, $00, $01, $00, $01, $01, $01, $00, $00, $00, $00, $01, $01
	db $01, $00, $01, $00, $00, $01, $00, $01, $01, $01, $00, $00, $00, $00, $01, $01
	db $00, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00
	db $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $01
	db $00, $01, $01, $00, $01, $00, $00, $01

;@ def EntityCheckWallAt(slot: bc, dir: de) -> carry
;@ path: entity/walls
;@ Looks at the room object at the entity's probe point for direction dir (WallProbeOffsetsX/Y by the
;@ size in hMultiPurpose0; going down, types $A8 and 5 use their height too). Carry: free to move.
;@ No carry: blocked, and the direction's bit is set in wEntityCollisions. Free: floor (physics 0),
;@ $A0 and up (except $FF), physics 2 and 5-$0F, deep water and pits unless the entity walks on the
;@ ground and is not being knocked back (type $59 always stops), the free quarters of partial walls
;@ ($7C-$8F, PartialWallSolidity; bosses and types $16/$17 stop at the $7C-$7F ones, $A8 and bombs
;@ pass the $80-$8F ones), ledges ($D0-$D3) when crossed in the allowed direction in the air
;@ (wEntityLedgeDirection, wEntityLedgeCredit), lowered raised blocks ($DB/$DC). Option bit 0 lets an
;@ entity through all soft walls. The hookshot hitting object $20 or physics $60 is pulled back.
;@ test: slot = rand(0, 15)
;@ test: dir = rand(0, 3); hMultiPurpose0 = 4 * rand(0, 3)
EntityCheckWallAt::
;>@hw def hard_wall():                         # blocked: the direction's bit in wEntityCollisions
;>@hw1     wEntityCollisions[slot] |= mem[WallCollisionBits + dir]
;>@hw2     return False
;>@sw def soft_wall():                         # option bit 0 lets the entity through soft walls
;>@sw1     if wEntityOptions1[slot] & 1: return True
;>@sw2     return hard_wall()
;>@hk def hookshot_check():                    # the hookshot is pulled back (state 1)
;>@hk1     if hActiveEntityType == 3:
;>@hk2         if GetEntityTimer(slot) >= 0x26: FreeEntitySlot(slot)
;>@hk3         wEntityState[slot] = 1
;>@hk4     return soft_wall()
;>@bl def blocked():
;>@bl1     if hMultiPurpose3 == 0x60: return hookshot_check()   # physics $60 pulls the hookshot back
;>@bl2     return soft_wall()
;> x = wEntityX[slot] - 8
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
;> i = hMultiPurpose0  # the size row
	push af
	ldh a, [hMultiPurpose0]
	ld c, a
	pop af
;> x += mem[WallProbeOffsetsX + i + dir]
	ld hl, WallProbeOffsetsX
	add hl, bc
	add hl, de
	add [hl]
;> hMultiPurpose4 = x
	ldh [hMultiPurpose4], a
;> hMultiPurpose1 = u8(x) >> 4
	swap a
	and $0f
	ldh [hMultiPurpose1], a
	pop bc
	push bc
;> low = dir == 3
	ld a, e
	cp $03
	jr nz, .otherwise

;> low = low and hActiveEntityType in (0xA8, 5)
	ldh a, [hActiveEntityType]
	cp $a8
	jr z, .checkLow

	cp $05
	jr nz, .otherwise

.checkLow
;> if low:
;>     y = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
;>     z = 0 if wEntityZ[slot] & 0x80 else wEntityZ[slot]   # below the floor counts as 0
	ld hl, wEntityZ
	add hl, bc
	ld c, [hl]
	bit 7, c
	jr z, .setY

	ld c, $00

.setY
;>     y -= z >> 1
	srl c
	sub c
	jr .setY2

.otherwise
;> else: y = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]

.setY2
;> y -= 0x10
	sub $10
;> i = hMultiPurpose0
	push af
	ldh a, [hMultiPurpose0]
	ld c, a
	pop af
;> y += mem[WallProbeOffsetsY + i + dir]
	ld hl, WallProbeOffsetsY
	add hl, bc
	add hl, de
	add [hl]
;> hMultiPurpose5 = y
	ldh [hMultiPurpose5], a
;> square = (y & 0xF0) | hMultiPurpose1
	and $f0
	ld hl, hMultiPurpose1
	or [hl]
	ld c, a
;> p = (wRoomObjects & 0xFF00) | lo(wRoomObjects + square)   # (stays in the page)
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
;> hRoomObjectType = mem[p]
	ld a, [hl]
	ldh [hRoomObjectType], a
;> if hRoomObjectType == 0x20: return hookshot_check()   # object $20: the hookshot is pulled back
	cp $20
	jp z, .checkActiveEntityType2

;> phys = GetObjectPhysicsBank3(hRoomObjectType, wIsIndoor)
	push de
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysicsBank3
	pop de
;> hMultiPurpose3 = phys
	ldh [hMultiPurpose3], a
;> if hActiveEntityType in (0xCC, 0x99):
	ldh a, [hActiveEntityType]
	cp $cc
	jr z, .checkPhys

	cp $99
	jr nz, .checkPhys2

.checkPhys
;>     if phys in (5, 7): return True
	ldh a, [hMultiPurpose3]
	cp $05
	jp z, .return2

	cp $07
	jp z, .return2

;>     return blocked()
	jp .checkMultiPurpose3


.checkPhys2
;> if phys == 0: return True
	ldh a, [hMultiPurpose3]
	and a
	jp z, .return2

;> if phys in (0x0B, 0x50, 0x51):  # deep water, pits
	cp $0b
	jr z, .checkEntityZ

	cp $50
	jr z, .checkEntityZ

	cp $51
	jr nz, .checkX7C

.checkEntityZ
;>     if wEntityZ[slot]: return True
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jp nz, .return2

;>     if not wEntityIgnoreHitsTimer[slot]: return blocked()
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jp z, .checkMultiPurpose3

;>     if hActiveEntityType == 0x59: return blocked()
	ldh a, [hActiveEntityType]
	cp $59
	jp z, .checkMultiPurpose3

;>     return True
	jp .return2


.checkX7C
;> if 0x7C <= phys < 0x90:  # partial walls
	cp $7c
	jp c, .setPhys

	cp $90
	jp nc, .setPhys

;>     if phys >= 0x80:
	cp $80
	ldh a, [hActiveEntityType]
	jr c, .checkActiveEntityType

;>         if hActiveEntityType in (0xA8, 2): return True
	cp $a8
	jp z, .return2

	cp $02
	jp z, .return2


	jr .setK

.checkActiveEntityType
;>@pw     elif hActiveEntityType in (0x16, 0x17) or wEntityOptions1[slot] & 0x80: return hard_wall()   # solid for these
	cp $16
	jp z, .setBit

	cp $17
	jp z, .setBit

;=@pw
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, .setBit

.setK

;>     k = (phys - 0x7C) * 4
	push de
	ldh a, [hMultiPurpose3]
	sub $7c
	sla a
	sla a
	ld e, a
;>     row = PartialWallSolidity + k
	ld d, $00
	ld hl, PartialWallSolidity
	add hl, de
;>     qx = (hMultiPurpose4 >> 3) & 1
	ldh a, [hMultiPurpose4]
	rra
	rra
	rra
	and $01
	ld e, a
;>     quarter = qx | ((hMultiPurpose5 >> 2) & 2)
	ldh a, [hMultiPurpose5]
	rra
	rra
	and $02
	or e
;>     solid = mem[row + quarter]               # which quarters of the square are solid
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	pop de
;>     if not solid: return True
	and a
	jp z, .return2

.setPhys
;> phys = hMultiPurpose3
	ldh a, [hMultiPurpose3]
;> if 0xD0 <= phys < 0xD4:  # ledges
	cp $d0
	jr c, .checkPhys3

	cp $d4
	jr nc, .checkPhys3

;>     if phys - 0xD0 == wEntityLedgeDirection[slot]:   # crossed the way the ledge allows
;>@lz         if wEntityZ[slot] == 0: return blocked()     # only in the air
;>@li         wEntityLedgeCredit[slot] += 1
;>     else:
	sub $d0
	ld hl, wEntityLedgeDirection
	add hl, bc
	cp [hl]
	jr z, .checkEntityZ3

;>         if hActiveEntityType == 0xA8: return blocked()
	ldh a, [hActiveEntityType]
	cp $a8
	jr z, .checkMultiPurpose3

;>         credit = wEntityLedgeCredit + slot
	ld hl, wEntityLedgeCredit
	add hl, bc
;>         if not mem[credit]: return blocked()
	ld a, [hl]
	and a
	jr z, .checkMultiPurpose3

;>         if hFrameCounter & 3:
	ldh a, [hFrameCounter]
	and $03
	jr z, .return

;>             if wIsIndoor or hFrameCounter & 1:   # outdoors only every other frame
	ld a, [wIsIndoor]
	and a
	jr nz, .checkEntityZ2

	ldh a, [hFrameCounter]
	and $01
	jr z, .return

.checkEntityZ2
;>                 mem[credit] -= 1
	dec [hl]
	jr .return

.checkEntityZ3

;=@lz
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jp z, .checkMultiPurpose3

;=@li
	ld hl, wEntityLedgeCredit
	add hl, bc
	inc [hl]

.return
;>     return True
	jp .return2


.checkPhys3
;> if phys == 0xFF: return hard_wall()
	cp $ff
	jr z, .setBit

;> if phys >= 0xA0: return True
	cp $a0
	jr nc, .return2

;> if phys >= 0x10: return blocked()
	cp $10
	jr nc, .checkMultiPurpose3

;> if phys in (1, 3): return soft_wall()
	cp $01
	jr z, .checkEntityOptions1

	cp $03
	jr z, .checkEntityOptions1

;> if phys != 4: return True
	cp $04
	jr nz, .return2

;> if hActiveEntityType in (0xA8, 2): return True
	ldh a, [hActiveEntityType]
	cp $a8
	jp z, .return2

	cp $02
	jp z, .return2

;> if hActiveEntityType == 3 and wLinkOnRaisedBlock: return True
	cp $03
	jr nz, .checkXDB

	ld a, [wLinkOnRaisedBlock]
	and a
	jp nz, .return2

.checkXDB
;> if not (0xDB <= hRoomObjectType < 0xDD): return hard_wall()
	ldh a, [hRoomObjectType]
	cp $db
	jr c, .setBit

	cp $dd
	jr nc, .setBit

;> i = hRoomObjectType - 0xDB  # a raised block
	push de
	sub $db
	ld e, a
	ld d, $00
;> if wRaisedBlocksState == mem[RaisedBlockStates + i]: return True  # lowered
	ld hl, RaisedBlockStates
	add hl, de
	pop de
	ld a, [wRaisedBlocksState]
	xor [hl]
	jr z, .return2

.checkMultiPurpose3
;> return blocked()
;=@bl
;=@bl1

	ldh a, [hMultiPurpose3]
	cp $60
	jr nz, .checkEntityOptions1

.checkActiveEntityType2
;=@bl2
;=@hk
;=@hk1
	ldh a, [hActiveEntityType]
	cp $03
	jr nz, .checkEntityOptions1

;=@hk2
	call GetEntityTimer
	cp $26
	jr c, .setEntityState

	call FreeEntitySlot

.setEntityState
;=@hk3
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01

.checkEntityOptions1
;=@hk4
;=@sw
;=@sw1
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $01
	jr nz, .return2

.setBit
;=@sw2
;=@hw
;=@hw1
	ld hl, WallCollisionBits
	add hl, de
	ld a, [hl]
;=@hw1
	ld hl, wEntityCollisions
	add hl, bc
	or [hl]
	ld [hl], a
;=@hw2
	and a
	ret


.return2
;> return True                                  # (the exit of every `return True` above)
	scf
	ret


;@ path: entity/walls
;@ wRaisedBlocksState for which the raised blocks $DB and $DC are down (passable): 0, 2.
RaisedBlockStates::
	db $00, $02

;@ def EntityCheckObjectCollision_03(slot: bc) -> carry
;@ path: entity/walls
;@ For projectiles: the room object at the entity's centre (x, y - 8; also left in hBGPosX/Y and
;@ hMultiPurposeH). Physics $10-$9F (but not pits $50/$51 or partial walls) and 1 stop it: carry,
;@ wEntityCollisions 1, the position put back. Physics $FF destroys it (the boomerang is stopped).
;@ Ledges as in EntityCheckWallAt. The Magic Rod's fireball lights an unlit torch (object $AB,
;@ indoors): it becomes $AC, a flame (type 8, state 1) burns there, the room gets lighter and its
;@ event counter goes up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
EntityCheckObjectCollision_03::
;>@hi1 def hit():                               # .setEntityCollisions: stopped
;>@hi2     wEntityCollisions[slot] = 1
;>@hi3     if hActiveEntityType == 1 and not GetEntityTimer(slot): return False  # the boomerang turns
;>@hi4     wEntityX[slot] = hActiveEntityX
;>@hi5     wEntityY[slot] = hActiveEntityY
;>@hi6     return True
;>@cr1 def crossing():                          # .checkEntityZ2: crossing a ledge the right way
;>@cr2     if wEntityZ[slot] == 0: return hit()
;>@cr3     wEntityLedgeCredit[slot] += 1; return False
;>@de1 def destroyed():                         # .checkActiveEntityType: physics $FF
;>@de2     if hActiveEntityType == 1: return hit()
;>@de3     FreeEntitySlot(slot); return hActiveEntityType == 0  # (carry still from the type test)
;> x = wEntityX[slot]
	ld de, $0000
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
;> hMultiPurpose4 = x
	ldh [hMultiPurpose4], a
;> hBGPosX = x & 0xF0
	and $f0
	ldh [hBGPosX], a
	swap a
;> y = wEntityY[slot] - 8
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $08
;> hMultiPurpose5 = y
	ldh [hMultiPurpose5], a
;> hBGPosY = y & 0xF0
	and $f0
	ldh [hBGPosY], a
;> square = hBGPosY | (x >> 4)
	or c
	ld c, a
;> hMultiPurposeH = square
	ldh [hMultiPurposeH], a
	ld b, $00
;> p = 0xD700 | u8(addr(wRoomObjects) + square)  # wRoomObjects + square, kept in its page
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
;> hRoomObjectType = mem[p]
	ld a, [hl]
	ldh [hRoomObjectType], a
;> if hRoomObjectType == 0xAC: return False  # a lit torch
	cp $ac
	jp z, .return

;> torch = hRoomObjectType == 0xAB and hActiveEntityType == 4  # the fireball at an unlit torch
	cp $ab
	jr nz, .setPhys2

	ldh a, [hActiveEntityType]
	cp $04
	jr nz, .setPhys2

;> if torch and wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .setPhys2

;>     hNoiseSfx = 0x12
	push hl
	ld a, $12
	ldh [hNoiseSfx], a
;>     n, full = SpawnEntity_03(slot, 8)  # the torch flame
	ld a, $08
	call SpawnEntity_03
;>     if not full:                             # (no free slot: on to the physics below)
	jr c, .setPhys

;>         mem[p] = 0xAC
	pop hl
	ld [hl], $ac
;>         q = p  # bc = n from here, de = p
	push bc
	push de
	pop bc
	ld d, h
	ld e, l
;>         wEntityPrivate1[n] = q >> 8
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], d
;>         wEntityPrivate2[n] = q & 0xFF
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], e
;>         wEntityX[n] = hBGPosX
	ldh a, [hBGPosX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>         wEntityY[n] = hBGPosY
	ldh a, [hBGPosY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>         wEntityState[n] = 1
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;>         wEntityDropTimer[n] = 0x80
	call GetEntityDropTimer
	ld [hl], $80
	pop bc
;>         wRoomEventCounter += 1
	ld hl, wRoomEventCounter
	inc [hl]
;>         if wRoomDarkness: wRoomDarkness -= 4
	ld a, [wRoomDarkness]
	and a
	jr z, .drawRoomObjectTiles

	sub $04
	ld [wRoomDarkness], a

.drawRoomObjectTiles
;>         return DrawRoomObjectTiles(LitTorchTiles_03)
	ld de, LitTorchTiles_03
	push de
	jp DrawRoomObjectTiles


.setPhys
	pop hl

.setPhys2
;> # physics:
;> phys = GetObjectPhysicsBank3(mem[p], wIsIndoor)
	ld a, [hl]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysicsBank3
;> hMultiPurpose1 = phys
	ldh [hMultiPurpose1], a
;> if phys == 0: return False
	and a
	jp z, .return

;> hMultiPurpose3 = phys
	ldh [hMultiPurpose3], a
;> if phys == 0xFF: return destroyed()
	cp $ff
	jp z, .checkActiveEntityType

;> if 0xD0 <= phys < 0xD4:  # ledges
	cp $d0
	jr c, .checkX7C

	cp $d4
	jr nc, .checkX7C

;>     if phys - 0xD0 == wEntityLedgeDirection[slot]: return crossing()
	sub $d0
	ld hl, wEntityLedgeDirection
	add hl, bc
	cp [hl]
	jr z, .checkEntityZ2

;>     credit = wEntityLedgeCredit + slot
	ld hl, wEntityLedgeCredit
	add hl, bc
;>     if not mem[credit]: return hit()
	ld a, [hl]
	and a
	jr z, .setEntityCollisions

;>     if not (hFrameCounter & 3): return False
	ldh a, [hFrameCounter]
	and $03
	jr z, .return

;>     if not wIsIndoor and not (hFrameCounter & 1): return False
	ld a, [wIsIndoor]
	and a
	jr nz, .checkEntityZ

	ldh a, [hFrameCounter]
	and $01
	jr z, .return

.checkEntityZ
;>     mem[credit] -= 1; return False
	dec [hl]
	jp .return


.checkEntityZ2
;=@cr1
;=@cr2
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .setEntityCollisions

;=@cr3
	ld hl, wEntityLedgeCredit
	add hl, bc
	inc [hl]
	jp .return


.checkX7C
;> if 0x7C <= phys < 0x90: return False  # partial walls
	cp $7c
	jp c, .setPhys3

	cp $90
	jp nc, .setPhys3

	jp .return


.setPhys3
;> phys = hMultiPurpose3
	ldh a, [hMultiPurpose3]
;> if phys >= 0xA0 or phys in (0x50, 0x51): return False
	cp $a0
	jr nc, .return

	cp $50
	jr z, .return

	cp $51
	jr z, .return

;> if phys < 0x10 and phys != 1: return False
	cp $10
	jr nc, .setEntityCollisions

	cp $01
	jr nz, .return
;> return hit()

.setEntityCollisions
;=@hi1
;=@hi2
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], $01
;=@hi3
	ldh a, [hActiveEntityType]
	cp $01
	jr nz, .setEntityX

	call GetEntityTimer
	ret z

.setEntityX
;=@hi4
	ld hl, wEntityX
	add hl, bc
	ldh a, [hActiveEntityX]
	ld [hl], a
;=@hi5
	ld hl, wEntityY
	add hl, bc
	ldh a, [hActiveEntityY]
	ld [hl], a
;=@hi6
	scf
	ret


.return
;> return False
	and a
	ret


.checkActiveEntityType
;=@de1
;=@de2
	ldh a, [hActiveEntityType]
	cp $01
	jr z, .setEntityCollisions

;=@de3
	jp FreeEntitySlot


;@ def GetObjectUnderEntity_03(slot: bc)
;@ path: entity/walls
;@ The room object under the entity's feet (x - 1, y - 7): hRoomObjectType, its physics in
;@ hMultiPurpose3; also hBGPosX/Y of the square and the point in hMultiPurpose4/5.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
GetObjectUnderEntity_03::
;> x = wEntityX[slot] - 1
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $01
;> hMultiPurpose4 = x
	ldh [hMultiPurpose4], a
;> hBGPosX = x & 0xF0
	and $f0
	ldh [hBGPosX], a
	swap a
;> y = wEntityY[slot] - 7
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $07
;> hMultiPurpose5 = y
	ldh [hMultiPurpose5], a
;> hBGPosY = y & 0xF0
	and $f0
	ldh [hBGPosY], a
;> square = hBGPosY | (u8(x) >> 4)
	or c
	ld c, a
	ld b, $00
;> p = (wRoomObjects & 0xFF00) | lo(wRoomObjects + square)   # (stays in the page)
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
;> hRoomObjectType = mem[p]
	ld a, [hl]
	ldh [hRoomObjectType], a
;> hMultiPurpose3 = GetObjectPhysicsBank3(hRoomObjectType, wIsIndoor)
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysicsBank3
	ldh [hMultiPurpose3], a
	ret


;@ def GetVectorTowardsLink_03(slot: bc, speed: a)
;@ path: entity/engine
;@ A speed vector from the entity towards Link: the axis on which Link is farther away gets the full
;@ speed, the other one speed * shorter / longer distance (counted by repeated addition). y goes to
;@ hMultiPurpose0, x to hMultiPurpose1 (both signed). Speed 0 gives 0, 0.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
GetVectorTowardsLink_03::
;> hMultiPurpose1 = speed
	ldh [hMultiPurpose1], a
;>@z if speed == 0: hMultiPurpose0 = 0; return
	and a
	jp z, .setMultiPurpose0

;> side_y, dy = GetEntityYDistanceToLink_03(slot)
	call GetEntityYDistanceToLink_03
;> hMultiPurpose2 = side_y - 2  # 0: Link is above
	dec e
	dec e
	ld a, e
	ldh [hMultiPurpose2], a
;> hMultiPurposeC = abs((u8(dy) ^ 0x80) - 0x80)
	ld a, d
	bit 7, a
	jr z, .setSidex

	cpl
	inc a

.setSidex
	ldh [hMultiPurposeC], a
;> side_x, dx = GetEntityXDistanceToLink_03(slot)
	call GetEntityXDistanceToLink_03
;> hMultiPurpose3 = side_x  # 1: Link is to the left
	ld a, e
	ldh [hMultiPurpose3], a
;> hMultiPurposeD = abs((u8(dx) ^ 0x80) - 0x80)
	ld a, d
	bit 7, a
	jr z, .setYMajor

	cpl
	inc a

.setYMajor
	ldh [hMultiPurposeD], a
;> yMajor = False
	ld e, $00
;> if hMultiPurposeD < hMultiPurposeC:  # mostly vertical
	ld hl, hMultiPurposeC
	ldh a, [hMultiPurposeD]
	cp [hl]
	jr nc, .setMultiPurposeB

;>     yMajor = True
	inc e
;>     d = hMultiPurposeD; hMultiPurposeD = hMultiPurposeC; hMultiPurposeC = d   # D = the longer, C = the shorter
	push af
	ldh a, [hMultiPurposeC]
	ldh [hMultiPurposeD], a
	pop af
	ldh [hMultiPurposeC], a

.setMultiPurposeB
;> hMultiPurposeB = 0  # the accumulator
	xor a
	ldh [hMultiPurposeB], a
;> hMultiPurpose0 = 0  # the minor axis speed
	ldh [hMultiPurpose0], a
;> for i in range(speed):
	ldh a, [hMultiPurpose1]
	ld d, a

.setAcc
;>     acc = hMultiPurposeB + hMultiPurposeC
	ldh a, [hMultiPurposeB]
	ld hl, hMultiPurposeC
	add [hl]
	jr c, .setAcc2

;>     if acc >= 0x100 or acc >= hMultiPurposeD:   # (a carry counts too)
	ld hl, hMultiPurposeD
	cp [hl]
	jr c, .setMultiPurposeB2

.setAcc2
;>         acc -= hMultiPurposeD; hMultiPurpose0 += 1
	sub [hl]
	ld hl, hMultiPurpose0
	inc [hl]

.setMultiPurposeB2
;>     hMultiPurposeB = acc
	ldh [hMultiPurposeB], a
	dec d
	jr nz, .setAcc

;> if yMajor:
	ld a, e
	and a
	jr z, .setUp

;>     y = hMultiPurpose1; hMultiPurpose1 = hMultiPurpose0; hMultiPurpose0 = y   # y = speed, x = the minor part
	ldh a, [hMultiPurpose0]
	push af
	ldh a, [hMultiPurpose1]
	ldh [hMultiPurpose0], a
	pop af
	ldh [hMultiPurpose1], a

.setUp
;> up = hMultiPurpose2 == 0
	ldh a, [hMultiPurpose2]
	and a
;> if up: hMultiPurpose0 = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	jr nz, .setLeft

	cpl
	inc a
	ldh [hMultiPurpose0], a

.setLeft
;> left = hMultiPurpose3 != 0
	ldh a, [hMultiPurpose3]
	and a
;> if left: hMultiPurpose1 = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	jr z, .return

	cpl
	inc a
	ldh [hMultiPurpose1], a

.return
	ret


.setMultiPurpose0
;=@z

	xor a
	ldh [hMultiPurpose0], a
	ret


;@ def SetEntitySpeedTowardsLink_03(slot: bc, speed: a)
;@ path: entity/engine
;@ Sets the entity's x and y speed to move towards Link at the given speed.
;@ test: slot = rand(0, 15)
SetEntitySpeedTowardsLink_03::
;> GetVectorTowardsLink_03(slot, speed)
	call GetVectorTowardsLink_03
;> wEntitySpeedY[slot] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ret


;@ def GetEntityXDistanceToLink_03(slot: bc) -> (e, d)
;@ path: entity/engine
;@ Horizontal distance from the entity to Link: d = Link x - entity x (signed), e = 0 when Link is to
;@ the right (or level), 1 when he is to the left.
;@ test: slot = rand(0, 15)
GetEntityXDistanceToLink_03::
;> side = 0
	ld e, $00
;> dx = u8(hLinkX - wEntityX[slot])
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if dx & 0x80: side = 1
	bit 7, a
	jr z, .done

	inc e

.done
;> return side, dx
	ld d, a
	ret


;@ def GetEntityYDistanceToLink_03(slot: bc) -> (e, d)
;@ path: entity/engine
;@ Vertical distance from the entity (its shadow: y counts its height) to Link: d = Link y - entity
;@ y + z (signed), e = 2 when Link is above, 3 when he is below (or level).
;@ test: slot = rand(0, 15)
GetEntityYDistanceToLink_03::
;> side = 2
	ld e, $02
;> dy = hLinkY - wEntityY[slot]
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> dy = u8(dy + wEntityZ[slot])
	ld hl, wEntityZ
	add hl, bc
	add [hl]
;> if not dy & 0x80: side = 3
	bit 7, a
	jr nz, .done

	inc e

.done
;> return side, dy
	ld d, a
	ret


;@ def GetEntityDirectionToLink_03(slot: bc) -> e
;@ path: entity/engine
;@ The direction (0 right, 1 left, 2 up, 3 down) from the entity towards Link along the axis on which
;@ he is farther away. Leaves the horizontal side in hMultiPurpose0 and the vertical one in
;@ hMultiPurpose1.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
GetEntityDirectionToLink_03::
;> side_x, dx = GetEntityXDistanceToLink_03(slot)
	call GetEntityXDistanceToLink_03
;> hMultiPurpose0 = side_x
	ld a, e
	ldh [hMultiPurpose0], a
;> far_x = abs((u8(dx) ^ 0x80) - 0x80)
	ld a, d
	bit 7, a
	jr z, .xPositive

	cpl
	inc a

.xPositive
;> side_y, dy = GetEntityYDistanceToLink_03(slot)
	push af
	call GetEntityYDistanceToLink_03
;> hMultiPurpose1 = side_y
	ld a, e
	ldh [hMultiPurpose1], a
;> far_y = abs((u8(dy) ^ 0x80) - 0x80)
	ld a, d
	bit 7, a
	jr z, .yPositive

	cpl
	inc a

.yPositive
;> if far_y < far_x: return hMultiPurpose0
	pop de
	cp d
	jr nc, .vertical

	ldh a, [hMultiPurpose0]
	jr .done

.vertical
;> return hMultiPurpose1
	ldh a, [hMultiPurpose1]

.done
	ld e, a
	ret


;@ def UpdateEntityPosWithSpeed_03(slot: bc)
;@ path: entity/engine
;@ Moves the entity by its x and y speeds (1/16 pixel units); the y arrays lie 16 bytes after the x
;@ ones.
;@ test: slot = rand(0, 15)
UpdateEntityPosWithSpeed_03::
;> AddEntitySpeedToPos_03(slot)  # x
	call AddEntitySpeedToPos_03
;> y_slot = slot + 16  # the y arrays lie 16 bytes after the x ones
	push bc
	ld a, c
	add $10
	ld c, a
;> AddEntitySpeedToPos_03(y_slot)
	call AddEntitySpeedToPos_03
	pop bc
	ret


;@ def AddEntitySpeedToPos_03(slot: bc)
;@ path: entity/engine
;@ Moves the entity by its x speed: a signed number of 1/16 pixels; the fraction is added into
;@ wEntitySpeedXAcc and its carry moves the entity one more pixel. (With slot + 16: the y speed.)
;@ test: slot = rand(0, 15)
AddEntitySpeedToPos_03::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> if speed == 0: return
	and a
	jr z, .return

;> acc = wEntitySpeedXAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
;> wEntitySpeedXAcc[slot] = acc & 0xFF
	ld [hl], a
	rl d
	ld hl, wEntityX

.setSign
;> sign = 0xF0 if speed & 0x80 else 0
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .setPixels

	ld e, $f0

.setPixels
;> pixels = (speed >> 4) | sign
	swap a
	and $0f
	or e
;> wEntityX[slot] = u8(wEntityX[slot] + pixels + (acc >> 8))
	rr d
	adc [hl]
	ld [hl], a

.return
	ret


;@ def AddEntityZSpeedToPos_03(slot: bc)
;@ path: entity/engine
;@ Moves the entity up or down in height by its z speed (same units; shares the tail of
;@ AddEntitySpeedToPos_03).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $03
AddEntityZSpeedToPos_03::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0: return
	and a
	jr z, AddEntitySpeedToPos_03.return

;> acc = wEntitySpeedZAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
;> wEntitySpeedZAcc[slot] = acc & 0xFF
	ld [hl], a
	rl d
;> wEntityZ[slot] = u8(wEntityZ[slot] + ((speed >> 4) | (0xF0 if speed & 0x80 else 0)) + (acc >> 8))   # (in the end of AddEntitySpeedToPos_03)
	ld hl, wEntityZ
	jr AddEntitySpeedToPos_03.setSign

;@ def ReturnIfNonInteractive_03()
;@ path: entity/engine
;@ Ends the calling handler (returns from the caller) unless the entity is active (status 5) and the
;@ game runs normally.
ReturnIfNonInteractive_03::
;> if hActiveEntityStatus != 5: return_from_caller()
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, ReturnIfGameFrozen_03.return
;> return ReturnIfGameFrozen_03()    # (runs on into it)

;@ def ReturnIfGameFrozen_03()
;@ path: entity/engine
;@ Ends the calling handler while the world stands still: the world map (game mode 7), a message,
;@ an item shown by Link, the inventory sliding, or a room transition.
ReturnIfGameFrozen_03::
;> if wGameplayType == 7: return_from_caller()
	ld a, [wGameplayType]
	cp $07
	jr z, .return

;> if wDialogState or wLinkShowItemPoseActive or wInventoryAppearing: return_from_caller()
	ld a, [wDialogState]
	ld hl, wLinkShowItemPoseActive
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, .return

;> if wRoomTransitionState: return_from_caller()
	ld a, [wRoomTransitionState]
	and a
	jr z, .return2

.return
	pop af

.return2
	ret


;@ def ApplyRecoilIfNeeded_03(slot: bc)
;@ path: entity/engine
;@ While the entity is knocked back after a hit (wEntityIgnoreHitsTimer running): moves it by its
;@ recoil speed instead of its own (walls stop it unless option bit 5 is set), shows the trail of a
;@ Piece of Power hit, and ends the calling handler for this frame (EndHitImmunityAtWall runs in its
;@ place).
;@ test: slot = rand(0, 15)
ApplyRecoilIfNeeded_03::
;> if wEntityIgnoreHitsTimer[slot] == 0: return
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .return

;> wEntityIgnoreHitsTimer[slot] -= 1
	dec a
	ld [hl], a
;> AddPowerHitTrailVfx(slot)
	call AddPowerHitTrailVfx
;> speedX = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
;> speedY = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedX[slot] = wEntityRecoilSpeedX[slot]
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = wEntityRecoilSpeedY[slot]
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> UpdateEntityPosWithSpeed_03(slot)
	call UpdateEntityPosWithSpeed_03
;> if not (wEntityOptions1[slot] & 0x20): EntityCheckWalls_03(slot)
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .setEntitySpeedY

	call EntityCheckWalls_03

.setEntitySpeedY
;> wEntitySpeedY[slot] = speedY
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
;> wEntitySpeedX[slot] = speedX
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
;> EndHitImmunityAtWall(slot); return_from_caller()
	pop af
	call EndHitImmunityAtWall

.return
	ret


;@ path: unused
;@ The free end of bank 3: 71 bytes of $FF.
Bank3EndPadding::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff
