; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

;@ def GenieInit(slot: bc)
;@ path: boss/genie
;@ Set-up of a new Genie (entity $5C, from the entity init table in bank 3, through a bank-switch stub
;@ in bank 0): moves it 8 pixels to the right, so the bottle stands in the middle of its two tiles.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GenieInit::
;> wEntityX[slot] += 8
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ret

;@ def GenieHandler(slot: c)
;@ path: boss/genie
;@ Entity $5C: the Genie, boss of Bottle Grotto (level 2), and the pieces of its fight. wEntityPrivate1
;@ says which piece this entity is: 0 the bottle, 1 the Genie, 2 the cloud of smoke it comes out of / goes
;@ back into, 3 a flame that hops from its hand, 4 a fireball thrown at Link.
;@ test: skip dispatches through a jump table into the whole boss
GenieHandler::
;> ConfineLinkToArena()                       # keep Link inside the boss arena
	call ConfineLinkToArena
;> StartBossMusic(slot)
	call StartBossMusic
;> return GeniePartHandlers[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/genie
;@ Handler of each piece of the Genie fight, indexed by wEntityPrivate1.
GeniePartHandlers::
	dw GenieBottle
	dw Genie
	dw GenieSmoke
	dw GenieHandFlame
	dw GenieFireball

;@ def GenieBottle(slot: c)
;@ path: boss/genie
;@ The Genie's bottle. It waits until Link walks up, hops to the middle of the room and lets the Genie
;@ out; after the Genie goes back in it hops after Link and can be lifted with the Power Bracelet and
;@ thrown. Once it has been smashed three times (wEntityPrivate4, counted by the throw code) it breaks and
;@ the Genie comes out for good. wEntityWorkRAM[2] keeps the bottle's slot for the other pieces.
;@ test: skip spawns entities and dispatches through a jump table
GenieBottle::
;> if wEntityPrivate4[slot] >= 3:        # smashed three times: the bottle breaks
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $03
	jr c, .whole
;>     new, _ = SpawnEntity(slot, 0x5C)              # spawn a smoke cloud (no check for a full entity table)
	ld a, $5c
	call SpawnEntity
;>     wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = hMultiPurpose1 - 0x18
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $18
	ld [hl], a
;>     wEntityPrivate1[new] = 2           # smoke that lets the Genie out
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityTimer[new] = 0x27
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $27
;>     wEntityHealth[new] = 8
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $08
;>     BreakIntoPiecesFar(slot)                        # shards of the bottle, removes it
	call BreakIntoPiecesFar
;>     hNoiseSfx = 0x29
	ld a, $29
	ldh [hNoiseSfx], a
;>     return
	ret


.whole
;> wEntityHealth[slot] = 0x20                # cannot be destroyed by hits
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $20
;> wEntityWorkRAM[2] = slot
	ld a, c
	ld [wEntityWorkRAM + 2], a
;> DrawGenieBottle(slot)
	call DrawGenieBottle
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> wEntityPhysicsFlags[slot] = 0x81
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $81
;> wEntityHitboxFlags[slot] = 0x80
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $80
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> wEntitySpeedZ[slot] -= 2                 # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot]                  # kept in $FFE8; negative = it just hit the floor
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeG], a
;> if landed & 0x80:
	and $80
	jr z, .states
;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.states
;> return GenieBottleStates[hActiveEntityState](slot, landed)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/genie
;@ States of the Genie's bottle.
GenieBottleStates::
	dw GenieBottleWaitForLink
	dw GenieBottleReleaseGenie
	dw GenieBottleLiftable
	dw GenieBottleHopTowardsLink

;@ def GenieBottleWaitForLink(slot: bc)
;@ path: boss/genie
;@ Bottle state 0: waits until Link has walked into the upper part of the room (y below $70).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GenieBottleWaitForLink::
;> if hLinkY < 0x70:
	ldh a, [hLinkY]
	cp $70
	jr nc, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff

.done
;> return
	ret


;@ path: boss/genie
;@ Sprite variant of the bottle for each 8-frame step of its wobble: 0 upright, 1 tilted left,
;@ 2 tilted right (1 byte each, see GenieBottleSprites).
GenieBottleWobbleFrames::
	db $00, $01, $00, $02

;@ def GenieBottleReleaseGenie(slot: c, landed)
;@ path: boss/genie
;@ Bottle state 1: hops to the middle of the room ($50, $48), bouncing Link away when he touches it,
;@ and when its timer is down to 1 releases a smoke cloud with the Genie in it.
;@ test: skip spawns entities and calls bank-3 collision code
GenieBottleReleaseGenie::
;> DecrementEntityIgnoreHitsTimer(slot)                          # count down the hit immunity
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)                          # hits from Link's weapons
	call EntityCheckWeaponHits
;> if EntityCheckContactDamage(slot):                      # Link touches the bottle: bounce him away
	call EntityCheckContactDamage
	jr nc, .noTouch
;>     ResetPegasusBoots()                          # stop the Pegasus Boots run
	call ResetPegasusBoots
;>     hJingle = 0x09
	ld a, $09
	ldh [hJingle], a
;>     wLinkPushedTimer = 0x10
	ld a, $10
	ld [wLinkPushedTimer], a
;>     GetVectorTowardsLink(slot, 0x14)                      # vector of speed $14 towards Link
	ld a, $14
	call GetVectorTowardsLink
;>     hLinkSpeedY = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;>     hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a

.noTouch
;> if wEntityPrivate3[slot] == 0:           # not yet in the middle of the room
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .release
;>     if landed & 0x80:
	ldh a, [hMultiPurposeG]
	and $80
	jr z, .move
;>         wEntitySpeedZ[slot] = 0x10       # hop again
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>         hJingle = 0x20
	ld a, $20
	ldh [hJingle], a

.move
;>     savedX = hLinkX                      # aim at the room centre instead of at Link
	ldh a, [hLinkX]
	push af
;>     hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;>     savedY = hLinkY
	ldh a, [hLinkY]
	push af
;>     hLinkY = 0x48
	ld a, $48
	ldh [hLinkY], a
;>     SetEntitySpeedTowardsLink(slot, 0x08)                      # speed 8 towards that point
	ld a, $08
	call SetEntitySpeedTowardsLink
;>@and     if (hActiveEntityX - hLinkX + 2) & 0xFF < 4 and (hActiveEntityY - hLinkY + 2) & 0xFF < 4:
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $02
	cp $04
	jr nc, .restore
;=@and
	ldh a, [hActiveEntityY]
	ld hl, hLinkY
	sub [hl]
	add $02
	cp $04
	jr nc, .restore
;>         wEntityPrivate3[slot] += 1       # arrived
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]

.restore
;>     hLinkY = savedY
	pop af
	ldh [hLinkY], a
;>     hLinkX = savedX
	pop af
	ldh [hLinkX], a
;>     UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04

.release
;> if wEntityTimer[slot] == 1:
	call GetEntityTimer
	cp $01
	jr nz, AnimateGenieBottle
;>     new, full = SpawnEntity(slot, 0x5C)                # the smoke cloud the Genie comes out of
	ld a, $5c
	call SpawnEntity
;>     wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = hMultiPurpose1 - 0x26
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $26
	ld [hl], a
;>     wEntityPrivate1[new] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityTimer[new] = 0x47
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $47
;>     hJingle = 0x06
	ld a, $06
	ldh [hJingle], a
;> AnimateGenieBottle(slot)                 # (falls through)

;@ def AnimateGenieBottle(slot: c)
;@ path: boss/genie
;@ Wobbles the bottle: picks its sprite variant from GenieBottleWobbleFrames, one step every 8 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
AnimateGenieBottle::
;>@v SetEntitySpriteVariant(slot, mem[GenieBottleWobbleFrames + ((hFrameCounter >> 3) & 3)])   # set the sprite variant
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
;=@v
	ld d, b
	ld hl, GenieBottleWobbleFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ def GenieBottleLiftable(slot: c)
;@ path: boss/genie
;@ Bottle state 2: the Genie is inside (or the bottle was just hit). It shakes for a while, then lies still;
;@ Link can lift it with the Power Bracelet (in either button slot, button held while touching it). When
;@ the timer is down to 1 the bottle starts hopping after Link (state 3).
;@ test: skip calls bank-3 collision code
GenieBottleLiftable::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
	jr z, .lift
;>     if t == 1:
	dec a
	jr nz, .shake
;>         wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>         return
	ret


.shake
;>     moving = wEntityZ[slot] != 0         # still in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
;>     if not moving:
	jr nz, .fly
;>         ClearEntitySpeed(slot)                  # stop
	call ClearEntitySpeed
;>         if wEntityTimer[slot] < 0x28:    # the last $28 frames: shake
	call GetEntityTimer
	cp $28
	jr nc, .physics
;>             moving = True
;>             shake = 0xF8 if hFrameCounter & 4 else 0x08     # left and right every 4 frames
	ld e, $08
	ldh a, [hFrameCounter]
	and $04
	jr z, .setShake
	ld e, $f8
.setShake
;>             wEntitySpeedX[slot] = shake
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e

.fly
;>     if moving:
;>         UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04

.physics
;>     EntityCheckWalls(slot)                      # walls and floor
	call EntityCheckWalls

.lift
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> BlockLinkAtEntity_04(slot)                       # Link cannot walk through it
	call BlockLinkAtEntity_04
;>@and2 if (hActiveEntityX - hLinkX + 0x10) & 0xFF < 0x20 and (hActiveEntityDrawY - hLinkY + 0x10) & 0xFF < 0x20:
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $10
	cp $20
	jr nc, .done
;=@and2
	ldh a, [hActiveEntityDrawY]
	ld hl, hLinkY
	sub [hl]
	add $10
	cp $20
	jr nc, .done
;>     ResetPegasusBoots()
	call ResetPegasusBoots
;>@bracelet     if (wItemB == 3 and hJoypadHeld & 0x20) or (wItemB != 3 and wItemA == 3 and hJoypadHeld & 0x10):   # Power Bracelet button held
	ld a, [wItemB]
	cp $03
	jr nz, .tryA
;=@bracelet
	ldh a, [hJoypadHeld]
	and $20
	jr nz, .tryLift
	jr .done
.tryA
;=@bracelet
	ld a, [wItemA]
	cp $03
	jr nz, .done
;=@bracelet
	ldh a, [hJoypadHeld]
	and $10
	jr z, .done
.tryLift
;>         if wLinkIsCarrying == 0:         # Link is not carrying anything yet
	ld a, [wLinkIsCarrying]
	and a
	jr nz, .done
;>             wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;>             wEntityStatus[slot] = 7      # lifted
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;>             mem[0xC490 + slot] = 0
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
;>             wLiftDirection = hLinkDirection
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
;>             hWaveSfx = 0x02
	ld hl, hWaveSfx
	ld [hl], $02
;>             wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08

.done
;> SetEntitySpriteVariant(slot, 0)                             # upright
	xor a
	call SetEntitySpriteVariant
	ret


;@ def GenieBottleHopTowardsLink(slot: c, landed)
;@ path: boss/genie
;@ Bottle state 3: hops after Link. A hit makes it jump away from Link and lie still (state 2,
;@ timer $C0) so it can be lifted.
;@ test: skip calls bank-3 collision code
GenieBottleHopTowardsLink::
;> if wEntityFlashTimer[slot] != 0:          # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .hop
;>     wEntityFlashTimer[slot] = 0
	ld [hl], b
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>     wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     GetVectorTowardsLink(slot, 0x08)                      # vector towards Link ...
	ld a, $08
	call GetVectorTowardsLink
;>     wEntitySpeedY[slot] = -hMultiPurpose0  # ... and fly the other way
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
;>     wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;>     return
	ret


.hop
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> wEntityPhysicsFlags[slot] = 0x01
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $01
;> wEntityHitboxFlags[slot] = 0x00
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $00
;> wEntityOptions1[slot] = 0x00             # options cleared for the collision checks only
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $00
;> EntityCheckHits(slot)                          # Link touching it, weapon hits
	call EntityCheckHits
;> wEntityOptions1[slot] = 0xD0
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $d0
;> if landed & 0x80:
	ldh a, [hMultiPurposeG]
	and $80
	jr z, .move
;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>     hJingle = 0x20
	ld a, $20
	ldh [hJingle], a
;>     SetEntitySpeedTowardsLink(slot, 0x0C)                      # next hop towards Link
	ld a, $0c
	call SetEntitySpeedTowardsLink

.move
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> return AnimateGenieBottle(slot)
	jp AnimateGenieBottle


;@ path: boss/genie
;@ Sprites of the bottle: 3 variants (upright, tilted left, tilted right) of 4 sprites, 16 bytes each.
;@ Each sprite: y offset, x offset (signed, from the entity position), tile, OAM attributes
;@ (bit 5 = x flip). Drawn by DrawGenieBottle.
GenieBottleSprites::
	db $f0, $00, $76, $00, $f0, $08, $76, $20, $00, $00, $78, $00, $00, $08, $78, $20
	db $f0, $00, $7a, $00, $f0, $08, $7c, $00, $00, $00, $7e, $00, $00, $08, $7e, $20
	db $f0, $00, $7c, $20, $f0, $08, $7a, $20, $00, $00, $7e, $00, $00, $08, $7e, $20
;@ path: boss/genie
;@ Shadow drawn under the bottle while it is in the air: one 8x16 sprite, tile $26, attributes 0.
GenieBottleShadowSprite::
	db $26, $00

;@ def DrawGenieBottle(slot: c)
;@ path: boss/genie
;@ Draws the bottle (4 sprites of GenieBottleSprites for its variant) and, while it is in the air, its
;@ shadow on the floor 10 pixels below its position.
;@ test: skip writes OAM through bank-0 sprite code
DrawGenieBottle::
;>@d DrawEntitySprites(GenieBottleSprites + (wEntitySpriteVariant[slot] << 4), 4)   # draw a list of 4 sprites
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@d
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, GenieBottleSprites
	add hl, de
;=@d
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)                             # those 4 OAM entries are used
	ld a, $04
	call ReserveOAMEntriesFar
;> if wEntityZ[slot] != 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hActiveEntityDrawY = hActiveEntityY + 10
	ldh a, [hActiveEntityY]
	add $0a
	ldh [hActiveEntityDrawY], a
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity8x16(slot, GenieBottleShadowSprite)   # one 8x16 sprite
	ld de, GenieBottleShadowSprite
	call DrawEntity8x16
;>     LoadEntityPosition(slot)                      # reload the entity's position into hActiveEntity*
	call LoadEntityPosition

.done
;> return
	ret


;@ def Genie(slot: c)
;@ path: boss/genie
;@ The Genie itself (piece 1). It floats around throwing flames and fireballs, then flies back into its
;@ bottle; once the bottle is broken it fights in the open (states 4 and 5). When its health runs out the
;@ entity code changes its status, and this handler then plays the death: it flashes, explodes and leaves
;@ a heart container.
;@ test: skip dispatches through jump tables into the whole boss
Genie::
;> DrawGenie(slot)
	call DrawGenie
;> if hActiveEntityStatus == 5:             # alive
;>     return GenieActive(slot)
	ldh a, [hActiveEntityStatus]
	cp $05
	jr z, GenieActive
;> wEntityFlashTimer[slot] = hFrameCounter   # defeated: keeps flashing
	ld hl, wEntityFlashTimer
	add hl, bc
	ldh a, [hFrameCounter]
	ld [hl], a
;> return GenieDeathStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/genie
;@ States of the Genie's death.
GenieDeathStates::
	dw GenieDeathStart
	dw GenieDeathWait
	dw GenieDeathExplode

;@ def GenieDeathStart(slot: bc)
;@ path: boss/genie
;@ Death state 0: wait $40 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GenieDeathStart::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def GenieDeathWait(slot: bc)
;@ path: boss/genie
;@ Death state 1: when the wait is over, explode for $A0 frames.
;@ test: slot = rand(0, 15)
GenieDeathWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xA0
	ld [hl], $a0
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def GenieDeathExplode(slot: c)
;@ path: boss/genie
;@ Death state 2: explosions around the Genie; at the end it turns into a heart container.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GenieDeathExplode::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return BossDropHeartContainer_04(slot)
	jp z, BossDropHeartContainer_04
;> BossDeathExplosion_04(wEntityTimer[slot])    # an explosion every 8 frames
	call BossDeathExplosion_04
	ret


;@ def GenieActive(slot: c)
;@ path: boss/genie
;@ The living Genie: shares its speed with the hand flames, hurts Link on touch (except in state 5)
;@ and runs its state.
;@ test: skip dispatches through a jump table
GenieActive::
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> wEntityWorkRAM = wEntitySpeedX[slot]         # the hand flames ride along with the Genie
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld [wEntityWorkRAM], a
;> wSceneVar1 = wEntitySpeedY[slot]             # ($D001)
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld [wSceneVar1], a
;> if hActiveEntityState != 5:
	ldh a, [hActiveEntityState]
	cp $05
	jr z, .states
;>     EntityCheckContactDamage(slot)                          # touching the Genie hurts Link
	call EntityCheckContactDamage

.states
;> return GenieStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/genie
;@ States of the Genie.
GenieStates::
	dw GenieTaunt
	dw GenieThrowFlames
	dw GenieReturnToBottle
	dw GenieEnterBottle
	dw GenieChaseLink
	dw GenieCircleRoom

;@ def GenieTaunt(slot: c)
;@ path: boss/genie
;@ State 0: when the Genie has come out of its smoke it speaks. If the bottle (its slot in wSceneVar2)
;@ still exists it says dialogue $52 and starts throwing (state 1); if the bottle is gone it says $53 and
;@ fights with 8 hit points (state 4).
;@ test: skip opens a dialogue
GenieTaunt::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer1[slot] = 0xFF
	call GetEntityTimer1
	ld [hl], $ff
;>     text = 0x52
;>@if     if wEntityStatus[wSceneVar2] == 0:       # the bottle has broken
	ld a, [wSceneVar2]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
;=@if
	and a
	ld a, $52
	jr nz, .say
;>         wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>         wEntityHealth[slot] = 8
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $08
;>         text = 0x53
	ld a, $53

.say
;>     OpenDialog(text)
	call OpenDialog

.done
;> return
	ret


;@ path: boss/genie
;@ Frames between two hand flames, indexed by the number of fireballs thrown so far (0-7); the last two
;@ bytes ($FF) are never read.
GenieFlameDelays::
	db $10, $14, $18, $20, $28, $30, $38, $40, $ff, $ff

;@ path: boss/genie
;@ X position at which the floating Genie turns around, by its direction (0 moving right: $60, 1 moving
;@ left: $40).
GenieTurnX::
	db $60, $40

;@ path: boss/genie
;@ Speed step of the floating Genie by direction (+1 / -1); also used for the vertical sway.
GenieAcceleration::
	db $01, $ff

;@ path: boss/genie
;@ Top speed of the floating Genie by direction (+8 / -8, 1/16 pixel per frame).
GenieMaxSpeed::
	db $08, $f8

;@ def GenieThrowFlames(slot: c)
;@ path: boss/genie
;@ State 1: the Genie sways left and right between x $40 and $60 and up and down, throws a hand flame
;@ after each delay of GenieFlameDelays and a fireball at Link every $20 frames. After 8 fireballs
;@ it heads back to the bottle (state 2).
;@ test: skip spawns entities
GenieThrowFlames::
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;>@if1 if hFrameCounter & 7 == 0 and wEntitySpeedX[slot] != mem[GenieMaxSpeed + dir]:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .turn
;=@if1
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;=@if1
	ld hl, GenieMaxSpeed
	add hl, de
	cp [hl]
	jr z, .turn
;>@add     wEntitySpeedX[slot] += mem[GenieAcceleration + dir]
	ld hl, GenieAcceleration
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
;=@add
	ld [hl], a

.turn
;> if hActiveEntityX == mem[GenieTurnX + dir]:
	ld hl, GenieTurnX
	add hl, de
	ldh a, [hActiveEntityX]
	cp [hl]
	jr nz, .sway
;>     wEntityDirection[slot] ^= 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

.sway
;> if hFrameCounter & 1 == 0:                   # vertical sway: wEntityPrivate2 = its direction
	ldh a, [hFrameCounter]
	and $01
	jr nz, .anim
;>     vdir = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
;>@sy     wEntitySpeedY[slot] += mem[GenieAcceleration + vdir]
	ld hl, GenieAcceleration
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
;=@sy
	ld [hl], a
;>     if wEntitySpeedY[slot] == mem[GenieMaxSpeed + vdir]:
	ld hl, GenieMaxSpeed
	add hl, de
	cp [hl]
	jr nz, .anim
;>         wEntityPrivate2[slot] ^= 1
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

.anim
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)          # floating frames 0 / 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .fireball
;>     thrown = wEntityPrivateCounter[slot]
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld e, a
;>     if thrown >= 8:
	cp $08
	jr c, .flame
;>         wEntityState[slot] += 1              # back to the bottle
	call IncrementEntityState
;>         wEntityTimer[slot] = 0x30
	pop hl
	ld [hl], $30
;>         return
	ret


.flame
;>     wEntityTimer[slot] = mem[GenieFlameDelays + thrown]
	ld d, b
	ld hl, GenieFlameDelays
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
;>     new, full = SpawnEntity(slot, 0x5C)
	ld a, $5c
	call SpawnEntity
;>     if not full:
	jr c, .fireball
;>         wEntityX[new] = hMultiPurpose0 - 0x0C
	ldh a, [hMultiPurpose0]
	sub $0c
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = hMultiPurpose1 - 0x14
	ldh a, [hMultiPurpose1]
	sub $14
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityPrivate1[new] = 3             # hand flame
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
;>         wEntitySpeedZ[new] = 0x20
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
;>         wEntitySpeedX[new] = 0x0C
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $0c
;>         wEntityPhysicsFlags[new] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42

.fireball
;> if wEntityTimer1[slot] == 0:
	call GetEntityTimer1
	jr nz, .pose
;>     wEntityTimer1[slot] = 0x20
	ld [hl], $20
;>     new, full = SpawnEntity(slot, 0x5C)
	ld a, $5c
	call SpawnEntity
;>     if not full:
	jr c, .pose
;>@hand         hand = wEntityPrivateCounter[slot] & 1   # throws with the left and the right hand in turn
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>         wEntityPrivateCounter[slot] += 1
	inc [hl]
;=@hand
	and $01
	ld c, a
;>@x         wEntityX[new] = hMultiPurpose0 + mem[GenieFireballOffsetX + hand]
	ld hl, GenieFireballOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@x
	ld [hl], a
;>         wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntitySpeedZ[new] = 0x24
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $24
;>         wEntityPrivate1[new] = 4             # fireball
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $04
;>         wEntityPhysicsFlags[new] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;>         SetEntitySpeedTowardsLink(0x1F, slot=new)            # aim it at Link, speed $1F
	push de
	pop bc
	ld a, $1f
	call SetEntitySpeedTowardsLink
	pop bc
;>         wEntityTimer2[slot] = 0x10           # throwing pose
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $10
;>         hNoiseSfx = 0x28
	ld a, $28
	ldh [hNoiseSfx], a

.pose
;> if wEntityTimer2[slot] != 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>@p     SetEntitySpriteVariant(slot, 2 if wEntityPrivateCounter[slot] & 1 == 0 else 3)   # arm raised, by hand
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $01
	ld a, $02
	jr z, .setPose
;=@p
	inc a
.setPose
	call SetEntitySpriteVariant

.done
;> return
	ret


;@ path: boss/genie
;@ X offset of a new fireball from the Genie, by the hand that throws it (-12 / +12 pixels).
GenieFireballOffsetX::
	db $f4, $0c

;@ def GenieReturnToBottle(slot: c)
;@ path: boss/genie
;@ State 2: flies at speed $10 to the point $20 pixels above the bottle; when it is within 3 pixels
;@ it goes on to state 3 with a timer of $10.
;@ test: skip calls bank-3 movement code
GenieReturnToBottle::
;> bottle = wSceneVar2
	ld a, [wSceneVar2]
	ld e, a
	ld d, b
;> savedX = hLinkX                              # aim at the bottle instead of at Link
	ldh a, [hLinkX]
	push af
;> hLinkX = wEntityX[bottle]
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;> savedY = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = wEntityY[bottle] - 0x20
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	sub $20
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(slot, 0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;>@near if (hActiveEntityX - hLinkX + 3) & 0xFF < 6 and (hActiveEntityDrawY - hLinkY + 3) & 0xFF < 6:
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, .restore
;=@near
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, .restore
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     wEntityState[slot] += 1
	call IncrementEntityState

.restore
;> hLinkY = savedY
	pop af
	ldh [hLinkY], a
;> hLinkX = savedX
	pop af
	ldh [hLinkX], a
	ret


;@ def GenieEnterBottle(slot: c)
;@ path: boss/genie
;@ State 3: at timer 4 a smoke cloud that shrinks into the bottle appears at the Genie (timer $C7: bit 7
;@ = shrinking); when the timer runs out the Genie is gone.
;@ test: skip spawns entities
GenieEnterBottle::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return DespawnEntity_04(slot)
	jp z, DespawnEntity_04
;> if t == 4:
	cp $04
	jr nz, .done
;>     new, _ = SpawnEntity(slot, 0x5C)                    # (no check for a full entity table)
	ld a, $5c
	call SpawnEntity
;>     wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[new] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityTimer[new] = 0xC7
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $c7
;>     hJingle = 0x1F
	ld a, $1f
	ldh [hJingle], a

.done
;> return
	ret


;@ def GenieChaseLink(slot: c)
;@ path: boss/genie
;@ State 4 (bottle broken): the Genie can be hit; it accelerates towards Link, one step of its speed
;@ every 4 frames. A hit (flash timer at 2) sends it into state 5 for $80 frames.
;@ test: skip calls bank-3 collision code
GenieChaseLink::
;> wEntityHitboxFlags[slot] = 0x0C
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $0c
;> wEntityOptions1[slot] = 0x81
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $81
;> if wEntityFlashTimer[slot] == 2:            # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $02
	jr nz, .chase
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     return
	ret


.chase
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, AnimateGenieArms
;>     GetVectorTowardsLink(slot, 0x10)                          # vector towards Link
	ld a, $10
	call GetVectorTowardsLink
;>@sx     wEntitySpeedX[slot] += -1 if (hMultiPurpose1 - wEntitySpeedX[slot]) & 0x80 else 1
	ld hl, wEntitySpeedX
	add hl, bc
	ldh a, [hMultiPurpose1]
	sub [hl]
	and $80
	jr z, .incX
;=@sx
	dec [hl]
	dec [hl]
.incX
	inc [hl]
;>@sy     wEntitySpeedY[slot] += -1 if (hMultiPurpose0 - wEntitySpeedY[slot]) & 0x80 else 1
	ld hl, wEntitySpeedY
	add hl, bc
	ldh a, [hMultiPurpose0]
	sub [hl]
	and $80
	jr z, .incY
;=@sy
	dec [hl]
	dec [hl]
.incY
	inc [hl]
;> AnimateGenieArms(slot)                       # (falls through)

;@ def AnimateGenieArms(slot: c)
;@ path: boss/genie
;@ Sprite variants 2 and 3 (arms swinging), switching every 16 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
AnimateGenieArms::
;>@r return SetEntitySpriteVariant(slot, 2 + ((hFrameCounter >> 4) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@r
	add $02
	jp SetEntitySpriteVariant


;@ def GenieCircleRoom(slot: c)
;@ path: boss/genie
;@ State 5, after a hit: for $80 frames the Genie spirals around the middle of the room ($50, $48) and
;@ is also drawn, every other frame, at the point mirrored through the middle (wEntityPrivate3 /
;@ wEntityPrivate4), so two Genies seem to circle. Then it reappears at one of the two places at random,
;@ throws a fireball at Link and chases him again (state 4).
;@ test: skip spawns entities
GenieCircleRoom::
;> wEntityPhysicsFlags[slot] = 0x41
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $41
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .circle
;>     wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>     wEntityPhysicsFlags[slot] = 0x01
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $01
;>     if GetRandomByte() & 1 == 0:                 # random: jump to the mirrored place
	call GetRandomByte
	and $01
	jr nz, .stop
;>         wEntityY[slot] = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>         wEntityX[slot] = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a

.stop
;>     ClearEntitySpeed(slot)                          # stop
	call ClearEntitySpeed
;>     wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
;>     new, full = SpawnEntity(slot, 0x5C)
	ld a, $5c
	call SpawnEntity
;>     if full:
;>         return
	jr c, .done
;>@hand     hand = wEntityPrivateCounter[slot] & 1
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;=@hand
	and $01
	ld c, a
;>@x     wEntityX[new] = hMultiPurpose0 + mem[GenieFireballOffsetX + hand]
	ld hl, GenieFireballOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@x
	ld [hl], a
;>     wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[new] = 0x24
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $24
;>     wEntityPrivate1[new] = 4                 # fireball
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $04
;>     wEntityPhysicsFlags[new] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;>     SetEntitySpeedTowardsLink(0x1F, slot=new)                # aim it at Link
	push de
	pop bc
	ld a, $1f
	call SetEntitySpeedTowardsLink
	pop bc
;>     hNoiseSfx = 0x28
	ld a, $28
	ldh [hNoiseSfx], a

.done
;>     return
	ret


.circle
;> savedX = hLinkX                              # measure from the room centre
	ldh a, [hLinkX]
	push af
;> hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;> savedY = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x48
	ld a, $48
	ldh [hLinkY], a
;> GetVectorTowardsLink(slot, 0x20)                              # vector towards the centre, speed $20
	ld a, $20
	call GetVectorTowardsLink
;> orbitY = -hMultiPurpose1                     # turned by 90 degrees: around the centre
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	push af
;> orbitX = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	push af
;> GetVectorTowardsLink(slot, 0x04)                              # plus a slight pull towards the centre
	ld a, $04
	call GetVectorTowardsLink
;> wEntitySpeedX[slot] = orbitX + hMultiPurpose1
	ld hl, hMultiPurpose1
	pop af
	add [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = orbitY + hMultiPurpose0
	ld hl, hMultiPurpose0
	pop af
	add [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> hLinkY = savedY
	pop af
	ldh [hLinkY], a
;> hLinkX = savedX
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> GenieSetMirrorPosition(slot)
	call GenieSetMirrorPosition
;> return AnimateGenieArms(slot)
	jp AnimateGenieArms


;@ def GenieSetMirrorPosition(slot: bc)
;@ path: boss/genie
;@ Stores the Genie's position mirrored through the room centre ($50, $48): wEntityPrivate3 =
;@ $90 - y, wEntityPrivate4 = $A0 - x.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GenieSetMirrorPosition::
;>@y wEntityPrivate3[slot] = (0x48 - (wEntityY[slot] - 0x48)) & 0xFF
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, a
	ld a, $48
;=@y
	sub e
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], a
;>@x wEntityPrivate4[slot] = (0x50 - (wEntityX[slot] - 0x50)) & 0xFF
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $50
	ld e, a
	ld a, $50
;=@x
	sub e
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], a
	ret


;@ path: boss/genie
;@ Sprites of the Genie: 4 variants of 10 sprites (40 bytes each), a block 5 sprites wide and 2 high
;@ (x offsets -12, -4, 4, 12, 20; y offsets -16 and 0). Each sprite: y offset, x offset, tile, OAM
;@ attributes (bit 5 = x flip). Variants: 0 and 1 floating (arms down, two poses), 2 right arm raised,
;@ 3 left arm raised. Drawn by DrawGenie.
GenieSprites::
	db $f0, $f4, $60, $00, $f0, $fc, $62, $00, $f0, $04, $64, $00, $f0, $0c, $62, $20
	db $f0, $14, $60, $20, $00, $f4, $66, $00, $00, $fc, $68, $00, $00, $04, $6a, $00
	db $00, $0c, $68, $20, $00, $14, $66, $20, $f0, $f4, $60, $00, $f0, $fc, $62, $00
	db $f0, $04, $64, $20, $f0, $0c, $62, $20, $f0, $14, $60, $20, $00, $f4, $66, $00
	db $00, $fc, $68, $00, $00, $04, $6a, $20, $00, $0c, $68, $20, $00, $14, $66, $20
	db $f0, $f4, $60, $00, $f0, $fc, $62, $00, $f0, $04, $64, $00, $f0, $0c, $6c, $00
	db $f0, $14, $6e, $00, $00, $f4, $66, $00, $00, $fc, $68, $00, $00, $04, $6a, $00
	db $00, $0c, $70, $00, $00, $14, $72, $00, $f0, $f4, $6e, $20, $f0, $fc, $6c, $20
	db $f0, $04, $64, $20, $f0, $0c, $62, $20, $f0, $14, $60, $20, $00, $f4, $72, $20
	db $00, $fc, $70, $20, $00, $04, $6a, $20, $00, $0c, $68, $20, $00, $14, $66, $20
;@ path: boss/genie
;@ The wisp of smoke under the Genie: one 8x16 sprite (tile, attributes) per variant; variant 0 tile $74,
;@ variant 1 the same tile flipped, swapped every 8 frames.
GenieTailSprites::
	db $74, $00, $74, $20

;@ def DrawGenie(slot: c)
;@ path: boss/genie
;@ Draws the Genie (10 sprites of GenieSprites) and the wisp of smoke 16 pixels below. In state 5 it is
;@ drawn every other frame at the mirrored position, so it seems to be in two places.
;@ test: skip writes OAM through bank-0 sprite code
DrawGenie::
;>@if if hActiveEntityState == 5 and hFrameCounter & 1 == 0:
	ldh a, [hActiveEntityState]
	cp $05
	jr nz, .draw
;=@if
	ldh a, [hFrameCounter]
	and $01
	jr nz, .draw
;>     hActiveEntityDrawY = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;>     hActiveEntityX = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityX], a

.draw
;>@d DrawEntitySprites(GenieSprites + wEntitySpriteVariant[slot] * 40, 10)   # 10 sprites
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	sla e
;=@d
	sla e
	sla e
	ld a, e
	sla e
	sla e
	add e
;=@d
	ld e, a
	ld hl, GenieSprites
	add hl, de
	ld c, $0a
	call DrawEntitySprites
;> ReserveOAMEntriesFar(10)
	ld a, $0a
	call ReserveOAMEntriesFar
;> hActiveEntityDrawY += 0x10
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hActiveEntityDrawY], a
;>@t hActiveEntitySpriteVariant = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@t
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity8x16(slot, GenieTailSprites)
	ld de, GenieTailSprites
	call DrawEntity8x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
	ret


;@ path: boss/genie
;@ Sprites of the smoke cloud: 7 variants of 8 sprites (32 bytes each); each sprite y offset, x offset,
;@ tile, OAM attributes (bits 5/6 = x/y flip). Variant 0 is a small puff on the floor, the later ones a
;@ column that rises and widens up to the full cloud (6). Drawn by DrawGenieSmoke.
GenieSmokeSprites::
	db $10, $00, $1e, $00, $10, $08, $1e, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $10, $00, $1e, $00, $10, $08, $1e, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $08, $00, $30, $00, $08, $08, $30, $60, $08, $00, $30, $00, $08, $08, $30, $60
	db $08, $00, $30, $00, $08, $08, $30, $60, $08, $00, $30, $00, $08, $08, $30, $60
	db $04, $00, $30, $00, $04, $08, $30, $60, $14, $00, $1e, $00, $14, $08, $1e, $60
	db $14, $00, $1e, $00, $14, $08, $1e, $60, $14, $00, $1e, $00, $14, $08, $1e, $60
	db $00, $00, $30, $00, $00, $08, $30, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $10, $00, $1e, $00, $10, $08, $1e, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $f2, $fa, $30, $00, $f2, $02, $30, $60, $f2, $06, $30, $00, $f2, $0e, $30, $60
	db $fe, $fa, $30, $00, $fe, $02, $30, $60, $fe, $06, $30, $00, $fe, $0e, $30, $60
	db $f0, $f8, $30, $40, $f0, $00, $30, $20, $f0, $08, $30, $40, $f0, $10, $30, $20
	db $00, $f8, $30, $40, $00, $00, $30, $20, $00, $08, $30, $40, $00, $10, $30, $20
	db $f0, $f8, $32, $00, $f0, $00, $32, $60, $f0, $08, $32, $00, $f0, $10, $32, $60
	db $00, $f8, $32, $00, $00, $00, $32, $60, $00, $08, $32, $00, $00, $10, $32, $60
;@ path: boss/genie
;@ Smoke variant for the cloud that lets the Genie out, indexed by timer / 8 (8 down to 0): it rises
;@ from the bottle to the full cloud (1 byte per step).
GenieSmokeOutFrames::
	db $06, $05, $04, $05, $04, $03, $02, $01, $00

;@ path: boss/genie
;@ Smoke variant for the cloud that takes the Genie back in, indexed by (timer & $7F) / 8 (8 down to 0):
;@ from the full cloud back to the small puff.
GenieSmokeInFrames::
	db $00, $01, $02, $03, $04, $05, $04
	db $05, $06

;@ def GenieSmoke(slot: c)
;@ path: boss/genie
;@ Piece 2, the smoke cloud. Timer with bit 7 set: it shrinks into the bottle and at the end puts the
;@ bottle into its hopping state 3. Bit 7 clear: it grows out of the bottle; at timer 6 the Genie
;@ appears in it (at least at y $14) with a timer of $40.
;@ test: skip spawns entities
GenieSmoke::
;> DrawGenieSmoke(slot)
	call DrawGenieSmoke
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t & 0x80:                                 # going into the bottle
	bit 7, a
	jr z, .out
;>     if t & 0x7F == 0:
	and $7f
	jr nz, .shrink
;>         wEntityState[wSceneVar2] = 3         # the bottle starts hopping after Link
	ld a, [wSceneVar2]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld [hl], $03
;>         return DespawnEntity_04(slot)
	jp DespawnEntity_04


.shrink
;>@s     return SetEntitySpriteVariant(slot, mem[GenieSmokeInFrames + ((t >> 3) & 0x0F)])
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@s
	ld hl, GenieSmokeInFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


.out
;> if t == 0:
	and a
;>     return DespawnEntity_04(slot)
	jp z, DespawnEntity_04
;> if t == 6:
	cp $06
	jr nz, .grow
;>     new, _ = SpawnEntity(slot, 0x5C)                    # the Genie (no check for a full entity table)
	ld a, $5c
	call SpawnEntity
;>     wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@y     wEntityY[new] = max(hMultiPurpose1, 0x14)
	ldh a, [hMultiPurpose1]
	cp $14
	jr nc, .setY
	ld a, $14
.setY
;=@y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[new] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>     wEntityTimer[new] = 0x40
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
;>     wEntityPhysicsFlags[new] = 0x01
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $01
;>     wEntityHitboxFlags[new] = 0x8C
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $8c

.grow
;>@g SetEntitySpriteVariant(slot, mem[GenieSmokeOutFrames + ((wEntityTimer[slot] >> 3) & 0x0F)])
	call GetEntityTimer
	rra
	rra
	rra
	and $0f
	ld e, a
;=@g
	ld d, b
	ld hl, GenieSmokeOutFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ def DrawGenieSmoke(slot: c)
;@ path: boss/genie
;@ Draws the smoke cloud: 8 sprites of GenieSmokeSprites for the current variant.
;@ test: skip writes OAM through bank-0 sprite code
DrawGenieSmoke::
;>@d DrawEntitySprites(GenieSmokeSprites + (hActiveEntitySpriteVariant << 5), 8)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
;=@d
	and $e0
	ld e, a
	ld d, b
	ld hl, GenieSmokeSprites
	add hl, de
	ld c, $08
;=@d
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
	ret


;@ path: boss/genie
;@ The flames and fireballs: a 16x16 entity of two 8x16 sprites, 4 bytes per variant (left tile and
;@ attributes, right tile and attributes). Variant 0 tile $34 with the right half mirrored, variant 1
;@ the same in the other palette (bit 4), so the flame flickers.
GenieFireballSprites::
	db $34, $00, $34, $20, $34, $10, $34, $30

;@ def GenieHandFlame(slot: c)
;@ path: boss/genie
;@ Piece 3: a flame the Genie juggles. It is thrown up from the Genie's hand and moves along with the
;@ Genie (its speed plus the Genie's speed from wEntityWorkRAM / wSceneVar1); after it comes down
;@ it flies off to the left for 8 frames and vanishes. It does not hurt Link.
;@ test: skip writes OAM through bank-0 sprite code
GenieHandFlame::
;> DrawEntity16x16(slot, GenieFireballSprites)             # draw the 16x16 flame
	ld de, GenieFireballSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)        # flicker
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> ownX = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedX[slot] += wEntityWorkRAM         # add the Genie's speed for this move
	ld a, [wEntityWorkRAM]
	add [hl]
	ld [hl], a
;> ownY = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedY[slot] += wSceneVar1
	ld a, [wSceneVar1]
	add [hl]
	ld [hl], a
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> wEntitySpeedY[slot] = ownY
	pop af
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = ownX
	pop af
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> if hActiveEntityState == 0:                  # in the air
	ldh a, [hActiveEntityState]
	and a
	jr nz, .flyOff
;>     AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;>     wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>     if wEntityZ[slot] & 0x80:                # came down
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
;>         wEntityZ[slot] = 0
	ld [hl], b
;>         wEntityState[slot] += 1
	call IncrementEntityState
;>         wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>         wEntitySpeedX[slot] = 0xE0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $e0

.done
;>     return
	ret


.flyOff
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     DespawnEntity_04(slot)
	call z, DespawnEntity_04
	ret


;@ def GenieFireball(slot: c)
;@ path: boss/genie
;@ Piece 4: a fireball thrown at Link in an arc; it hurts Link on touch and is gone when it lands.
;@ test: skip writes OAM through bank-0 sprite code
GenieFireball::
;> DrawEntity16x16(slot, GenieFireballSprites)
	ld de, GenieFireballSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> EntityCheckContactDamage(slot)                              # hurts Link on touch
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                    # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;>     return DespawnEntity_04(slot)
	jp nz, DespawnEntity_04

	ret


;@ path: boss/slime_eye
;@ X offset of the two halves of Slime Eye from its centre when it splits (-18 / +18 pixels).
SlimeEyeSplitOffsetX::
	db $ee, $12

;@ path: boss/slime_eye
;@ Horizontal speed of the two halves when they jump apart (-8 / +8).
SlimeEyeSplitSpeedX::
	db $f8, $08

;@ def SlimeEyeSplit(slot: c)
;@ path: boss/slime_eye
;@ Slime Eye splits in two: spawns two halves (entity $5B with wEntityPrivate5 = 1, 5 hit points each)
;@ that jump apart from its centre (hMultiPurpose0 / hMultiPurpose1), then removes the big eye.
;@ test: skip spawns entities
SlimeEyeSplit::
;>@loop for half in range(2):                   # counted in $FFE8
	xor a
	ldh [hMultiPurposeG], a

.loop
;>     new, _ = SpawnEntity(slot, 0x5B)                    # (no check for a full entity table)
	ld a, $5b
	call SpawnEntity
;>     wEntityPrivate5[new] = 1                 # a half
	ld hl, wEntityPrivate5
	add hl, de
	ld [hl], $01
;>@x     wEntityX[new] = hMultiPurpose0 + mem[SlimeEyeSplitOffsetX + half]
	push bc
	ldh a, [hMultiPurposeG]
	ld c, a
	ld hl, SlimeEyeSplitOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
;=@x
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[new] = mem[SlimeEyeSplitSpeedX + half]
	ld hl, SlimeEyeSplitSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[new] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityState[new] = 1
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;>     wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityHealth[new] = 5
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $05
	pop bc
;=@loop
	ldh a, [hMultiPurposeG]
	inc a
	ldh [hMultiPurposeG], a
	cp $02
	jr nz, .loop
;> return DespawnEntity_04(slot)
	jp DespawnEntity_04


;@ def SlimeEyeInit(slot: bc)
;@ path: boss/slime_eye
;@ Set-up of a new Slime Eye (entity $5B, from the entity init table in bank 3, through a bank-switch
;@ stub in bank 0): it starts high up in the ceiling (height $7E) with a timer of $A0.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
SlimeEyeInit::
;> wEntityZ[slot] = 0x7E
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $7e
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
	ret

;@ def SlimeEyeHandler(slot: c)
;@ path: boss/slime_eye
;@ Entity $5B: Slime Eye, boss of Key Cavern (level 3). It hangs in the ceiling while Gels drop, falls
;@ when Link dashes into a wall with the Pegasus Boots, stretches when hit, and splits into two halves
;@ (wEntityPrivate5 = 1) when its stretched eye is struck with a boots dash.
;@ test: skip dispatches through a jump table into the whole boss
SlimeEyeHandler::
;> ConfineLinkToArena()                                  # keep Link inside the boss arena
	call ConfineLinkToArena
;> StartBossMusic(slot)
	call StartBossMusic
;> SlimeEyePinLink(slot)
	call SlimeEyePinLink
;> return SlimeEyeParts[wEntityPrivate5[slot]](slot)
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/slime_eye
;@ Handler by wEntityPrivate5: 0 the whole Slime Eye, 1 one of its halves.
SlimeEyeParts::
	dw SlimeEye
	dw SlimeEyeHalf

;@ def SlimeEye(slot: c)
;@ path: boss/slime_eye
;@ The whole Slime Eye: its health is kept at $50 (it cannot be killed in one piece); runs its state.
;@ test: skip dispatches through a jump table
SlimeEye::
;> wEntityHealth[slot] = 0x50
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $50
;> return SlimeEyeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/slime_eye
;@ States of the whole Slime Eye.
SlimeEyeStates::
	dw SlimeEyeOnCeiling
	dw SlimeEyeFall
	dw SlimeEyeLanded
	dw SlimeEyeFight

;@ def SlimeEyeOnCeiling(slot: c)
;@ path: boss/slime_eye
;@ State 0, in the ceiling (not drawn): every $50 frames a Gel drops from the ceiling at a random place
;@ (x $40-$7F, y $30-$6F) while fewer than 2 Gels are about. When Link's dash into a wall shakes the
;@ room, Slime Eye falls (state 1).
;@ test: skip spawns entities
SlimeEyeOnCeiling::
;> if wBumpShakeTimer == 5:                     # Link dashed into a wall
	ld a, [wBumpShakeTimer]
	cp $05
	jr nz, .gels
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a

.gels
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     if wGelCount < 2:
	ld a, [wGelCount]
	cp $02
	jr nc, .done
;>         new, _ = SpawnEntity(slot, 0x1B)                # a Gel (no check for a full entity table)
	ld a, $1b
	call SpawnEntity
;>         wEntityX[new] = 0x40 + (GetRandomByte() & 0x3F)
	call GetRandomByte
	and $3f
	add $40
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = 0x30 + (GetRandomByte() & 0x3F)
	call GetRandomByte
	and $3f
	add $30
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityZ[new] = 0x70                 # falls from the ceiling
	ld hl, wEntityZ
	add hl, de
	ld [hl], $70

.done
;> return
	ret


;@ def SlimeEyeFall(slot: c)
;@ path: boss/slime_eye
;@ State 1: falls (speed growing to $A0 down). On landing the room shakes for $50 frames; Link, if he
;@ is on the ground, is pinned for $14 frames (wEntityDropTimer). Then state 2 with a timer of $40.
;@ test: skip writes OAM through bank-0 sprite code
SlimeEyeFall::
;> DrawSlimeEye(slot)
	call DrawSlimeEye
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> if wEntitySpeedZ[slot] != 0xA0:              # gravity up to the top falling speed
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	cp $a0
	jr z, .landed
;>     wEntitySpeedZ[slot] -= 2
	dec [hl]
	dec [hl]

.landed
;> if wEntityZ[slot] & 0x80:                    # reached the floor
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wBumpShakeTimer = 0x50                   # the room shakes ...
	ld a, $50
	ld [wBumpShakeTimer], a
;>     wBumpShakeAxis = 4                       # ... up and down
	ld a, $04
	ld [wBumpShakeAxis], a
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     PlayClinkNoise()
	call PlayClinkNoise
;>     if wIsLinkInTheAir == 0:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .next
;>         wEntityDropTimer[slot] = 0x14        # Link is pinned by the impact
	call GetEntityDropTimer
	ld [hl], $14

.next
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def SlimeEyeLanded(slot: c)
;@ path: boss/slime_eye
;@ State 2: sits still until the timer runs out; its body hurts Link on touch.
;@ test: skip calls bank-3 collision code
SlimeEyeLanded::
;> DrawSlimeEye(slot)
	call DrawSlimeEye
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .touch
;>     wEntityState[slot] += 1
	call IncrementEntityState

.touch
;> SetSlimeEyeHitbox(slot)
	call SetSlimeEyeHitbox
;> return EntityCheckContactDamage(slot)                       # touching it hurts Link
	jp EntityCheckContactDamage


;@ def SlimeEyeFight(slot: c)
;@ path: boss/slime_eye
;@ State 3: slides about in jerks (SlimeEyeMove). Each hit stretches it one step more (wEntityPrivate1,
;@ up to 4; it shrinks back one step every $28 frames). The eye in the middle has its own small hitbox
;@ (checked with $FFE8 = 0) and the body the stretched one ($FFE8 = 1). When the eye of the fully
;@ stretched Slime Eye is hit during a Pegasus Boots dash, the hit code starts wEntityTimer2 ($0C):
;@ Link is held while it tears apart (variant 6) and at 1 it splits in two.
;@ test: skip calls bank-3 collision code
SlimeEyeFight::
;> DrawSlimeEye(slot)
	call DrawSlimeEye
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> split = wEntityTimer2[slot]
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
;> if split != 0:
	and a
	jr z, .fight
;>     if split == 1:
	cp $01
;>         return SlimeEyeSplit(slot)
	jp z, SlimeEyeSplit
;>     hLinkInteractiveMotionBlocked = split    # Link cannot move meanwhile
	ldh [hLinkInteractiveMotionBlocked], a
;>     if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .tear
;>         hLinkY -= 1                          # Link is pushed upwards
	ld hl, hLinkY
	dec [hl]

.tear
;>     return SetEntitySpriteVariant(slot, 6)                      # tearing apart
	ld a, $06
	jp SetEntitySpriteVariant


.fight
;> SlimeEyeMove(slot)
	call SlimeEyeMove
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)        # wobble: variants 0 / 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if wEntityPrivate1[slot] != 0:               # stretched
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .hits
;>     SetEntitySpriteVariant(slot, wEntityPrivate1[slot] + 1)     # variants 2-5
	inc a
	call SetEntitySpriteVariant
;>     if wEntityTimer1[slot] == 0:
	call GetEntityTimer1
	jr nz, .hits
;>         wEntityTimer1[slot] = 0x28
	ld [hl], $28
;>         wEntityPrivate1[slot] -= 1           # shrinks back a step
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]

.hits
;> hMultiPurposeG = 0                      # ($FFE8) the eye is checked
	xor a
	ldh [hMultiPurposeG], a
;> SetSlimeEyeHitboxRecord(slot, 0x14)          # small box around the eye
	ld a, $14
	call SetSlimeEyeHitboxRecord
;> EntityCheckWeaponHits(slot)                              # hits from Link's weapons
	call EntityCheckWeaponHits
;>@if if wEntityFlashTimer[slot] | wEntityTimer2[slot] == 0:   # the eye was not hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	ld hl, wEntityTimer2
	add hl, bc
	or [hl]
;=@if
	jr nz, .restore
;>     SetSlimeEyeHitbox(slot)                  # the whole (stretched) body
	call SetSlimeEyeHitbox
;>     EntityCheckContactDamage(slot)                          # touching it hurts Link
	call EntityCheckContactDamage
;>     hMultiPurposeG = 1                  # ($FFE8) the body is checked
	ld a, $01
	ldh [hMultiPurposeG], a
;>     EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits

.restore
;> SetSlimeEyeHitboxRecord(slot, 0x14)
	ld a, $14
	call SetSlimeEyeHitboxRecord
;>@stretch if wEntityFlashTimer[slot] != 0 and hFrameCounter & 0x1F == 0:   # hit: stretch a step
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;=@stretch
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .done
;>     wEntityTimer1[slot] = 0x50
	call GetEntityTimer1
	ld [hl], $50
;>     if wEntityPrivate1[slot] != 4:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, .done
;>         wEntityPrivate1[slot] += 1
	inc [hl]

.done
;> return
	ret


;@ path: boss/slime_eye
;@ Hitboxes of Slime Eye, copied to wEntityHitbox (4 bytes: x offset, half width, y offset, half height,
;@ in pixels). Offsets $00-$10: the body at stretch 0-4 (half width $14-$18, half height $0C-$04);
;@ $14: the eye ($03 x $03 around (+8, +8)); $18: one of the halves (half size $0C).
SlimeEyeHitboxes::
	db $08, $14, $00, $0c, $08, $15, $00, $0b, $08, $16, $00, $08, $08, $17, $00, $06
	db $08, $18, $00, $04, $08, $03, $08, $03, $08, $0c, $02, $0c

;@ def SetSlimeEyeHitbox(slot: c)
;@ path: boss/slime_eye
;@ Gives Slime Eye the body hitbox of its current stretch (wEntityPrivate1).
;@ test: skip falls through into SetSlimeEyeHitboxRecord
SetSlimeEyeHitbox::
;> return SetSlimeEyeHitboxRecord(slot, wEntityPrivate1[slot] * 4)   # (falls through)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	sla a
	sla a

;@ def SetSlimeEyeHitboxRecord(slot: bc, offset: a)
;@ path: boss/slime_eye
;@ Copies the 4-byte record at `offset` of SlimeEyeHitboxes into the entity's wEntityHitbox entry.
;@ test: offset = rand(0, 6) * 4
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
SetSlimeEyeHitboxRecord::
;> src = SlimeEyeHitboxes + offset
	ld e, a
	ld d, b
	ld hl, SlimeEyeHitboxes
	add hl, de
	push hl
	pop de
;> dst = addr(wEntityHitbox) + slot * 4
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
;> copy(dst, src, 4)
	ld c, $04
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copy

;> return
	pop bc
	ret


;@ def SlimeEyeMove(slot: c)
;@ path: boss/slime_eye
;@ Slime Eye's movement, by wEntityPrivate3: 0 choose a slide, 1 slide.
;@ test: skip dispatches through a jump table
SlimeEyeMove::
;> return SlimeEyeMoveSteps[wEntityPrivate3[slot]](slot)
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/slime_eye
;@ Steps of Slime Eye's movement.
SlimeEyeMoveSteps::
	dw SlimeEyePickSlide
	dw SlimeEyeSlide

;@ path: boss/slime_eye
;@ Horizontal slide speed (signed, 1/16 pixel per frame) by quadrant * 4 + random 0-3. Quadrants:
;@ 0 upper left, 1 upper right, 2 lower left, 3 lower right of the room; the speeds point back towards
;@ the middle. 16 bytes.
SlimeEyeSlideSpeedX::
	db $10, $0c, $06, $02, $f0, $f4, $fa, $fe, $10, $0c, $06, $02, $f0, $f4, $fa, $fe
;@ path: boss/slime_eye
;@ Vertical slide speed, same index as SlimeEyeSlideSpeedX. 16 bytes.
SlimeEyeSlideSpeedY::
	db $02, $06, $0c, $10, $02, $06, $0c, $10, $fe, $fa, $f4, $f0, $fe, $fa, $f4, $f0

;@ def SlimeEyePickSlide(slot: c)
;@ path: boss/slime_eye
;@ After its pause, Slime Eye picks a slide towards the middle of the room ($50, $48) for $10-$2F
;@ frames, at one of four angles at random.
;@ test: skip calls bank-0 random number code
SlimeEyePickSlide::
;> if wEntityTimer[slot] != 0:
;>     return
	call GetEntityTimer
	and a
	jr nz, .done
;> wEntityTimer[slot] = 0x10 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;> quadrant = 1 if hActiveEntityX >= 0x50 else 0
	ld e, $00
	ldh a, [hActiveEntityX]
	cp $50
	jr c, .left
	inc e
.left
;> if hActiveEntityDrawY >= 0x48:
	ld d, $00
	ldh a, [hActiveEntityDrawY]
	cp $48
	jr c, .top
;>     quadrant += 2
	inc d
	inc d
.top
;>@i i = (quadrant << 2) | (GetRandomByte() & 3)
	ld a, d
	or e
	sla a
	sla a
	push af
	call GetRandomByte
;=@i
	and $03
	pop de
	or d
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[SlimeEyeSlideSpeedX + i]
	ld hl, SlimeEyeSlideSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[SlimeEyeSlideSpeedY + i]
	ld hl, SlimeEyeSlideSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.done
;> return
	ret


;@ def SlimeEyeSlide(slot: c)
;@ path: boss/slime_eye
;@ Slides in jerks (moving only 2 frames out of 16); when the slide is over, pauses $30 frames.
;@ test: skip calls bank-3 collision code
SlimeEyeSlide::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr z, .over
;>     if t & 0x0E == 0:
	and $0e
	jr nz, .done
;>         UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;>         EntityCheckWalls(slot)
	call EntityCheckWalls

.done
;>     return
	ret


.over
;> wEntityTimer[slot] = 0x30
	ld [hl], $30
;> wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
	ret


;@ path: boss/slime_eye
;@ Sprites of Slime Eye: 7 variants of 16 sprites (64 bytes each; y offset, x offset, tile, OAM
;@ attributes; tile $FF = sprite not used). 0 and 1: the slime with its eye (two wobble frames),
;@ 2-5: more and more stretched sideways (x offsets up to -24 / +32), 6: torn apart in the middle.
;@ Drawn by DrawSlimeEye.
SlimeEyeSprites::
	db $f0, $f0, $60, $00, $f0, $f8, $62, $00, $f0, $00, $70, $00, $f0, $08, $70, $20
	db $f0, $10, $62, $20, $f0, $18, $60, $20, $00, $f0, $64, $00, $00, $f8, $6e, $00
	db $00, $00, $72, $00, $00, $08, $72, $20, $00, $10, $6e, $20, $00, $18, $64, $20
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $f0, $68, $00, $f0, $f8, $6a, $00, $f0, $00, $7e, $00, $f0, $08, $7e, $20
	db $f0, $10, $6a, $20, $f0, $18, $68, $20, $00, $f0, $6c, $00, $00, $f8, $6e, $00
	db $00, $00, $72, $00, $00, $08, $72, $20, $00, $10, $6e, $20, $00, $18, $6c, $20
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $f0, $60, $00, $f0, $f8, $62, $00, $f0, $00, $62, $20, $f0, $08, $62, $00
	db $f0, $10, $62, $20, $f0, $18, $60, $20, $00, $f0, $64, $00, $00, $f8, $66, $00
	db $00, $00, $66, $20, $00, $08, $66, $00, $00, $10, $66, $20, $00, $18, $64, $20
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $ec, $60, $00, $f0, $f4, $62, $00, $f0, $fc, $62, $20, $f0, $04, $74, $00
	db $f0, $0c, $62, $00, $f0, $14, $62, $20, $f0, $1c, $60, $20, $00, $ec, $64, $00
	db $00, $f4, $66, $00, $00, $fc, $66, $20, $00, $04, $76, $00, $00, $0c, $66, $00
	db $00, $14, $66, $20, $00, $1c, $64, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $e8, $60, $00, $f0, $f0, $62, $00, $f0, $f8, $62, $20, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $62, $00, $f0, $18, $62, $20, $f0, $20, $60, $20
	db $00, $e8, $64, $00, $00, $f0, $66, $00, $00, $f8, $66, $20, $00, $00, $7a, $00
	db $00, $08, $7a, $20, $00, $10, $66, $00, $00, $18, $66, $20, $00, $20, $64, $20
	db $f0, $e8, $60, $00, $f0, $f0, $62, $00, $f0, $f8, $62, $20, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $62, $00, $f0, $18, $62, $20, $f0, $20, $60, $20
	db $00, $e8, $64, $00, $00, $f0, $66, $00, $00, $f8, $66, $20, $00, $00, $7c, $00
	db $00, $08, $7c, $20, $00, $10, $66, $00, $00, $18, $66, $20, $00, $20, $64, $20
	db $f0, $e6, $60, $00, $f0, $ee, $62, $00, $f0, $f6, $62, $20, $f0, $fe, $78, $00
	db $f0, $0a, $78, $20, $f0, $12, $62, $00, $f0, $1a, $62, $20, $f0, $22, $60, $20
	db $00, $e6, $64, $00, $00, $ee, $66, $00, $00, $f6, $66, $20, $00, $fe, $7c, $00
	db $00, $0a, $7c, $20, $00, $12, $66, $00, $00, $1a, $66, $20, $00, $22, $64, $20
;@ path: boss/slime_eye
;@ Shadow of the falling Slime Eye: 6 sprites (y offset, x offset, tile $26, attributes) in a row 12
;@ pixels below the drawing position.
SlimeEyeShadowSprites::
	db $0c, $f5, $26, $00, $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00
	db $0c, $0d, $26, $00, $0c, $13, $26, $00

;@ def DrawSlimeEye(slot: c)
;@ path: boss/slime_eye
;@ Draws Slime Eye (16 sprites of SlimeEyeSprites for its variant) and, while it is in the air, its
;@ shadow on the floor.
;@ test: skip writes OAM through bank-0 sprite code
DrawSlimeEye::
;>@d DrawEntitySprites(SlimeEyeSprites + wEntitySpriteVariant[slot] * 64, 16)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld d, b
	rla
	rl d
;=@d
	rla
	rl d
	rla
	rl d
	rla
	rl d
;=@d
	rla
	rl d
	rla
	rl d
	and $c0
	ld e, a
;=@d
	ld hl, SlimeEyeSprites
	add hl, de
	ld c, $10
	call DrawEntitySprites
;> ReserveOAMEntriesFar(16)
	ld a, $10
	call ReserveOAMEntriesFar
;> if wEntityZ[slot] != 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hActiveEntityDrawY = hActiveEntityY - 8
	ldh a, [hActiveEntityY]
	sub $08
	ldh [hActiveEntityDrawY], a
;>     DrawEntitySprites(SlimeEyeShadowSprites, 6)
	ld hl, SlimeEyeShadowSprites
	ld c, $06
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
;>     LoadEntityPosition(slot)
	call LoadEntityPosition

.done
	ret


;@ def SlimeEyeHalf(slot: c)
;@ path: boss/slime_eye
;@ One of the two halves Slime Eye splits into (5 hit points each). It hops about and, after its first
;@ hit, jumps out of sight and drops onto Link. When it is defeated it explodes; the last half to go
;@ leaves the heart container.
;@ test: skip dispatches through jump tables
SlimeEyeHalf::
;> DrawSlimeEyeHalf(slot)
	call DrawSlimeEyeHalf
;> if hActiveEntityStatus == 5:
;>     return SlimeEyeHalfActive(slot)
	ldh a, [hActiveEntityStatus]
	cp $05
	jp z, SlimeEyeHalfActive
;> wEntityFlashTimer[slot] = hFrameCounter      # defeated: keeps flashing
	ld hl, wEntityFlashTimer
	add hl, bc
	ldh a, [hFrameCounter]
	ld [hl], a
;> return SlimeEyeHalfDeathStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/slime_eye
;@ States of a defeated half.
SlimeEyeHalfDeathStates::
	dw SlimeEyeHalfDeathStart
	dw SlimeEyeHalfDeathWait
	dw SlimeEyeHalfDeathExplode

;@ def SlimeEyeHalfDeathStart(slot: bc)
;@ path: boss/slime_eye
;@ Death state 0: wait $40 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
SlimeEyeHalfDeathStart::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ def SlimeEyeHalfDeathWait(slot: bc)
;@ path: boss/slime_eye
;@ Death state 1: then explode for $A0 frames.
;@ test: slot = rand(0, 15)
SlimeEyeHalfDeathWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xA0
	ld [hl], $a0
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def SlimeEyeHalfDeathExplode(slot: c)
;@ path: boss/slime_eye
;@ Death state 2: explosions; at the end the half vanishes, or, if no other Slime Eye entity is left in
;@ the room, turns into the heart container.
;@ test: skip spawns entities
SlimeEyeHalfDeathExplode::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr nz, .explode
;>@exp     return BossDeathExplosion_04(wEntityTimer[slot])
;>@loop for other in range(15, -1, -1):
	ld e, $0f
	ld d, b

.loop
;>@if     if other != slot and wEntityStatus[other] != 0 and wEntityType[other] == 0x5B:
	ld a, c
	cp e
	jr z, .next
;=@if
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
;=@if
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $5b
	jr z, .vanish
;>@v         return DespawnEntity_04(slot)      # the other half is still there

.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .loop
;> return BossDropHeartContainer_04(slot)       # it was the last one
	jp BossDropHeartContainer_04


.vanish
;=@v
	jp DespawnEntity_04


.explode
;=@exp
	jp BossDeathExplosion_04


;@ def SlimeEyePinLink(slot: bc)
;@ path: boss/slime_eye
;@ While wEntityDropTimer runs (set when Slime Eye or a half lands hard), Link is frozen in his
;@ squashed pose ($6A).
;@ test: slot = rand(0, 15)
SlimeEyePinLink::
;> if wEntityDropTimer[slot] != 0:
	call GetEntityDropTimer
	jr z, .done
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     hLinkAnimationState = 0x6A               # squashed flat
	ld a, $6a
	ldh [hLinkAnimationState], a

.done
;> return
	ret


;@ def SlimeEyeHalfActive(slot: c)
;@ path: boss/slime_eye
;@ A living half. Its first hit only marks it (wEntityPrivate1 = 1); every later hit makes it jump out of
;@ sight (state 2) to come down on Link.
;@ test: skip dispatches through a jump table
SlimeEyeHalfActive::
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> if wEntityIgnoreHitsTimer[slot] == 2:        # just hit
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	cp $02
	jr nz, .states
;>     if wEntityPrivate1[slot] != 0:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .firstHit
;>         wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>         hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
;>         ClearEntitySpeed(slot)                      # stop
	call ClearEntitySpeed
	jr .states
;>     else:
.firstHit
;>         wEntityPrivate1[slot] = 1
	inc [hl]

.states
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> hMultiPurposeG = 0                      # ($FFE8) for the hit code
	xor a
	ldh [hMultiPurposeG], a
;> return SlimeEyeHalfStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/slime_eye
;@ States of a living half.
SlimeEyeHalfStates::
	dw SlimeEyeHalfPickHop
	dw SlimeEyeHalfHop
	dw SlimeEyeHalfRise
	dw SlimeEyeHalfDropOnLink

;@ path: boss/slime_eye
;@ Horizontal speed of a half's hop in each of 8 directions (0 right, then anticlockwise in steps of 45
;@ degrees, speed $10). 8 bytes.
SlimeEyeHalfHopSpeedX::
	db $10, $0c, $00, $f4, $f0, $f4, $00, $0c

;@ path: boss/slime_eye
;@ Vertical speed of a half's hop, same 8 directions as SlimeEyeHalfHopSpeedX. 8 bytes.
SlimeEyeHalfHopSpeedY::
	db $00, $0c, $10, $0c, $00, $f4, $f0, $f4

;@ def SlimeEyeHalfPickHop(slot: c)
;@ path: boss/slime_eye
;@ State 0, sitting: when its timer is over the half hops in a random one of 8 directions (one time in
;@ four straight at Link, speed $18), with an upward speed of 8-23.
;@ test: skip calls bank-3 collision code
SlimeEyeHalfPickHop::
;> SetSlimeEyeHitboxRecord(slot, 0x18)          # the hitbox of a half
	ld a, $18
	call SetSlimeEyeHitboxRecord
;> EntityCheckHits(slot)                              # touching it hurts Link; weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .pose
;>     dir = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[SlimeEyeHalfHopSpeedX + dir]
	ld hl, SlimeEyeHalfHopSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[SlimeEyeHalfHopSpeedY + dir]
	ld hl, SlimeEyeHalfHopSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     if GetRandomByte() & 3 == 0:
	call GetRandomByte
	and $03
	jr nz, .jump
;>         SetEntitySpeedTowardsLink(slot, 0x18)                      # straight at Link
	ld a, $18
	call SetEntitySpeedTowardsLink

.jump
;>     wEntitySpeedZ[slot] = 8 + (GetRandomByte() & 0x0F)
	call GetRandomByte
	and $0f
	ld hl, wEntitySpeedZ
	add hl, bc
	add $08
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState

.pose
;> return SetEntitySpriteVariant(slot, 0)
	ld a, b
	jp SetEntitySpriteVariant


;@ def SlimeEyeHalfHop(slot: c)
;@ path: boss/slime_eye
;@ State 1, in the air (also the drop onto Link, wEntityPrivate4 = 1, during which it cannot be hit).
;@ A hard landing (falling faster than $20) shakes the room and pins Link if he is on the ground; a
;@ soft one just thuds. Then it sits $20 frames (state 0).
;@ test: skip calls bank-3 collision code
SlimeEyeHalfHop::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	and a
	jr nz, .pose
;>     UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;>     EntityCheckWalls(slot)
	call EntityCheckWalls
;>     AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;>     wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>     SetSlimeEyeHitboxRecord(slot, 0x18)
	ld a, $18
	call SetSlimeEyeHitboxRecord
;>     EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;>     if wEntityPrivate4[slot] == 0:           # not dropping onto Link
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .land
;>         EntityCheckWeaponHits(slot)                      # weapon hits
	call EntityCheckWeaponHits
	xor a

.land
;>     if wEntityZ[slot] & 0x80:                # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .pose
;>         wEntityZ[slot] = 0
	ld [hl], b
;>         wEntityPrivate4[slot] = 0
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
;>         if (wEntitySpeedZ[slot] - 0xE0) & 0x80:   # hard landing
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sub $e0
	and $80
	jr z, .soft
;>             wBumpShakeTimer = 0x18
	ld a, $18
	ld [wBumpShakeTimer], a
;>             hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;>             if wIsLinkInTheAir == 0:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .soft
;>                 wEntityDropTimer[slot] = 0x0E    # Link is pinned
	call GetEntityDropTimer
	ld [hl], $0e
;>                 wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	jr .sit

.soft
;>@soft         else:
;>             speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;>             wEntitySpeedZ[slot] = 0
	ld [hl], b
;>             if speed < 0xF2:
	cp $f2
	jr nc, .sit
;>                 hJingle = 0x20
	ld a, $20
	ldh [hJingle], a

.sit
;>         wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>         wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20

.pose
;> return SetEntitySpriteVariant(slot, 1)
	ld a, $01
	jp SetEntitySpriteVariant


;@ def SlimeEyeHalfRise(slot: bc)
;@ path: boss/slime_eye
;@ State 2, after a hit: flies straight up out of sight (speed $60) up to height $70, then waits
;@ there (state 3, timer $30).
;@ test: slot = rand(0, 15)
SlimeEyeHalfRise::
;> wEntitySpeedZ[slot] = 0x60
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $60
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> if wEntityZ[slot] >= 0x70:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, .done
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def SlimeEyeHalfDropOnLink(slot: bc)
;@ path: boss/slime_eye
;@ State 3, out of sight (not drawn): when the timer is over it moves above Link and drops fast
;@ (speed $C0 down), back in state 1 as a drop (wEntityPrivate4 = 1).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
SlimeEyeHalfDropOnLink::
;> SetEntitySpriteVariant(slot, 0xFF)                              # hidden
	ld a, $ff
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x18
	ld [hl], $18
;>     wEntityPrivate4[slot] = 1
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], $01
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     wEntitySpeedZ[slot] = 0xC0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $c0
;>     wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>     wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a

.done
;> return
	ret


;@ path: boss/slime_eye
;@ Sprites of a half: 2 variants of 8 sprites (32 bytes each; y offset, x offset, tile, OAM attributes),
;@ a 32x32 blob. 0 sitting, 1 in the air. Drawn by DrawSlimeEyeHalf.
SlimeEyeHalfSprites::
	db $f0, $f8, $60, $00, $f0, $00, $62, $00, $f0, $08, $62, $20, $f0, $10, $60, $20
	db $00, $f8, $64, $00, $00, $00, $66, $00, $00, $08, $66, $20, $00, $10, $64, $20
	db $f0, $f8, $68, $00, $f0, $00, $6a, $00, $f0, $08, $6a, $20, $f0, $10, $68, $20
	db $00, $f8, $6c, $00, $00, $00, $66, $00, $00, $08, $66, $20, $00, $10, $6c, $20
;@ path: boss/slime_eye
;@ Shadow of a half in the air: 4 sprites of tile $26 in a row, 12 pixels below the drawing position.
SlimeEyeHalfShadowSprites::
	db $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00, $0c, $0d, $26, $00

;@ def DrawSlimeEyeHalf(slot: c)
;@ path: boss/slime_eye
;@ Draws a half (8 sprites of SlimeEyeHalfSprites) and, while it is visible and in the air, its shadow.
;@ test: skip writes OAM through bank-0 sprite code
DrawSlimeEyeHalf::
;>@d DrawEntitySprites(SlimeEyeHalfSprites + wEntitySpriteVariant[slot] * 32, 8)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld d, b
	rla
	rl d
;=@d
	rla
	rl d
	rla
	rl d
	rla
	rl d
;=@d
	rla
	rl d
	and $e0
	ld e, a
	ld hl, SlimeEyeHalfSprites
	add hl, de
;=@d
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
;>@if if wEntitySpriteVariant[slot] != 0xFF and wEntityZ[slot] != 0:
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .done
;=@if
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hActiveEntityDrawY = hActiveEntityY - 2
	ldh a, [hActiveEntityY]
	sub $02
	ldh [hActiveEntityDrawY], a
;>     DrawEntitySprites(SlimeEyeHalfShadowSprites, 4)
	ld hl, SlimeEyeHalfShadowSprites
	ld c, $04
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar

.done
;> return LoadEntityPosition(slot)
	jp LoadEntityPosition


;@ def FacadeInit(slot: bc)
;@ path: boss/facade
;@ Set-up of a new Facade (entity $5A, from the entity init table in bank 3, through a bank-switch
;@ stub in bank 0): timer $FF, hit immunity for 8 frames, $12 hit points, moved 8 pixels right and down
;@ (to the middle of its 2x2 tiles) and not drawn yet.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
FacadeInit::
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> wEntityIgnoreHitsTimer[slot] = 8
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $08
;> wEntityHealth[slot] = 0x12
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $12
;> AddEightAndHideEntity(slot, addr(wEntityX) + slot)
	ld hl, wEntityX
	add hl, bc
	call AddEightAndHideEntity
;> return AddEightAndHideEntity(slot, addr(wEntityY) + slot)   # (falls through)
	ld hl, wEntityY
	add hl, bc

;@ def AddEightAndHideEntity(slot: c, ptr: hl)
;@ path: boss/facade
;@ Adds 8 to the byte at `ptr` (a position) and sets the entity's sprite variant to $FF (not drawn).
;@ test: skip writes through a pointer into the entity tables
AddEightAndHideEntity::
;> mem[ptr] = (mem[ptr] + 8) & 0xFF
	ld a, [hl]
	add $08
	ld [hl], a
;> return SetEntitySpriteVariant(slot, 0xFF)
	ld a, $ff
	jp SetEntitySpriteVariant

;@ def FacadeHandler(slot: c)
;@ path: boss/facade
;@ Entity $5A: Facade, boss of Face Shrine (level 6), a face in the floor, and the things it throws.
;@ wEntityPrivate1: 0 the face, 1 a hole that opens in the floor, 2 a floor tile that flies at Link,
;@ 3 a pot that flies at Link.
;@ test: skip dispatches through a jump table into the whole boss
FacadeHandler::
;> return FacadeParts[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/facade
;@ Handler of each piece, indexed by wEntityPrivate1.
FacadeParts::
	dw Facade
	dw FacadeHole
	dw FacadeFlyingTile
	dw FacadePot

;@ def Facade(slot: c)
;@ path: boss/facade
;@ The face. When it is defeated, every other enemy in the room dies with it, it waits, explodes and
;@ leaves a heart container (death steps in wEntityPrivate4).
;@ test: skip dispatches through jump tables
Facade::
;> wScreenShakeX = 0
	xor a
	ld [wScreenShakeX], a
;> StartBossMusic(slot)
	call StartBossMusic
;> ConfineLinkToArena()                                  # keep Link inside the boss arena
	call ConfineLinkToArena
;> DrawFacade(slot)
	call DrawFacade
;> if hActiveEntityStatus == 5:
;>     return FacadeActive(slot)
	ldh a, [hActiveEntityStatus]
	cp $05
	jp z, FacadeActive
;> wEntityFlashTimer[slot] = hFrameCounter      # defeated: keeps flashing
	ld hl, wEntityFlashTimer
	add hl, bc
	ldh a, [hFrameCounter]
	ld [hl], a
;> return FacadeDeathStates[wEntityPrivate4[slot]](slot)
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/facade
;@ Steps of Facade's death, indexed by wEntityPrivate4.
FacadeDeathStates::
	dw FacadeDeathKillAll
	dw FacadeDeathWait
	dw FacadeDeathExplode

;@ def FacadeDeathKillAll(slot: bc)
;@ path: boss/facade
;@ Death step 0: every other active entity (status 5 or more) that is not flagged as indestructible
;@ (physics flag bit 7) starts dying (status 1, $1F frames); then wait $80 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
FacadeDeathKillAll::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>@loop for other in range(15, -1, -1):
	ld e, $0f
	ld d, b

.loop
;>@if     if other != slot and not wEntityPhysicsFlags[other] & 0x80 and wEntityStatus[other] >= 5:
	ld a, c
	cp e
	jr z, .next
;=@if
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $80
	jr nz, .next
;=@if
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr c, .next
;>         wEntityStatus[other] = 1             # dying
	ld [hl], $01
;>         wEntityDyingTimer[other] = 0x1F
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $1f
;>         wEntityPhysicsFlags[other] = (wEntityPhysicsFlags[other] & 0xF0) | 2   # 2 sprites
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $f0
	or $02
	ld [hl], a

.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .loop

.setEntityPrivate4
;> wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
	ret


;@ def FacadeDeathWait(slot: bc)
;@ path: boss/facade
;@ Death step 1: when the wait is over, explode for $FF frames.
;@ test: slot = rand(0, 15)
FacadeDeathWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;>     wEntityPrivate4[slot] += 1               # (the tail of FacadeDeathKillAll)
	jr FacadeDeathKillAll.setEntityPrivate4

.done
;> return
	ret


;@ def FacadeDeathExplode(slot: c)
;@ path: boss/facade
;@ Death step 2: explosions; at the end the face leaves a heart container.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
FacadeDeathExplode::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return BossDropHeartContainer_04(slot)
	jp z, BossDropHeartContainer_04
;> return BossDeathExplosion_04(wEntityTimer[slot])   # (falls through)

;@ def BossDeathExplosion_04(timer: a)
;@ path: entity/helpers
;@ Every 8 frames of the death timer `timer`: an explosion at a random spot within 16 pixels of the
;@ dying boss (moves hActiveEntityX / hActiveEntityDrawY by -16..+15 for it).
;@ test: skip spawns an explosion effect
BossDeathExplosion_04::
;> if timer & 7 != 0:
;>     return
	and $07
	jr nz, .done
;>@x hActiveEntityX += (GetRandomByte() & 0x1F) - 0x10
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityX
	add [hl]
;=@x
	ld [hl], a
;>@y hActiveEntityDrawY += (GetRandomByte() & 0x1F) - 0x10
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityDrawY
	add [hl]
;=@y
	ld [hl], a
;> SpawnExplosionAtEntity_04()
	call SpawnExplosionAtEntity_04

.done
	ret


;@ def FacadeActive(slot: c)
;@ path: boss/facade
;@ The living face: a hit starts its hurt animation (wEntityPrivate5 = $FF); runs its state.
;@ test: skip dispatches through a jump table
FacadeActive::
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> if wEntityFlashTimer[slot] != 0:            # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .states
;>     wEntityPrivate5[slot] = 0xFF
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], $ff

.states
;> wEntityPhysicsFlags[slot] = 0x08
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $08
;> return FacadeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/facade
;@ States of the living face.
FacadeStates::
	dw FacadeWait
	dw FacadeAwaken
	dw FacadeFight

;@ def FacadeWait(slot: bc)
;@ path: boss/facade
;@ State 0: waits for its timer (set to $FF on creation), then wakes up for $FF frames.
;@ test: slot = rand(0, 15)
FacadeWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ path: boss/facade
;@ Sprite variant of the waking face, indexed by timer / 8 (31 down to 0): closed (3), opening
;@ (2, 1, 0), blinking (1 / 0), then open (0). 32 bytes.
FacadeAwakenFrames::
	db $03, $03, $03, $03, $03, $02, $01, $00, $01, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ def FacadeAwaken(slot: c)
;@ path: boss/facade
;@ State 1: the face opens its eyes (FacadeAwakenFrames), then speaks (dialogue $B6) and starts the
;@ fight: first hole after $FF frames, first flying tile after $A0 frames.
;@ test: skip opens a dialogue
FacadeAwaken::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
	jr z, .speak
;>@v     return SetEntitySpriteVariant(slot, mem[FacadeAwakenFrames + ((t >> 3) & 0x1F)])
	rra
	rra
	rra
	and $1f
	ld e, a
	ld d, b
;=@v
	ld hl, FacadeAwakenFrames
	add hl, de
	ld a, [hl]
	jp SetEntitySpriteVariant


.speak
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer1[slot] = 0xA0                   # first flying tile
	call GetEntityTimer1
	ld [hl], $a0
;> wEntityDropTimer[slot] = 0xFF                # first hole
	call GetEntityDropTimer
	ld [hl], $ff
;> OpenDialog(0xB6)
	ld a, $b6
	call OpenDialog
	ret


;@ path: boss/facade
;@ Sprite variant of the fighting face by timer / 8 (3 down to 0) while its timer runs ($1F frames at
;@ random times): mouth movement 3, 2, 4, 2.
FacadeMouthFrames::
	db $03, $02, $04, $02

;@ path: boss/facade
;@ X position (pixels) of the 16 places where a hole can open, around the face. 16 bytes.
FacadeHoleX::
	db $28, $38, $48, $58, $68, $78, $28, $78, $28, $78, $28, $38
	db $48, $58, $68, $78

;@ path: boss/facade
;@ Y position of the 16 hole places (same index as FacadeHoleX). 16 bytes.
FacadeHoleY::
	db $30, $30, $30, $30, $30, $30, $40, $40, $50, $50, $60, $60
	db $60, $60, $60, $60

;@ path: boss/facade
;@ X position of the 20 floor tiles that fly at Link: the ring of floor tiles around the edge of the
;@ room. 20 bytes.
FacadeTileX::
	db $28, $38, $48, $58, $68, $78, $18, $88, $18, $88, $18, $88
	db $18, $88, $28, $38, $48, $58, $68, $78

;@ path: boss/facade
;@ Y position of the 20 flying floor tiles (same index as FacadeTileX). 20 bytes.
FacadeTileY::
	db $20, $20, $20, $20, $20, $20, $30, $30
	db $40, $40, $50, $50, $60, $60, $70, $70, $70, $70, $70, $70

;@ path: boss/facade
;@ Order in which the floor tiles fly (index into FacadeTileX / FacadeTileY), from both ends of the
;@ ring in turn. 20 bytes.
FacadeTileOrder::
	db $00, $13, $01, $12
	db $02, $11, $03, $10, $04, $0f, $05, $0e, $06, $0d, $07, $0c, $08, $0b, $09, $0a
;@ path: boss/facade
;@ X position of the four pots in the room corners (thrown in this order). 4 bytes.
FacadePotX::
	db $18, $88, $18, $88

;@ path: boss/facade
;@ Y position of the four corner pots. 4 bytes.
FacadePotY::
	db $20, $70, $70, $20

;@ path: boss/facade
;@ X offset of the screen while the face rumbles (wScreenShakeX), switching every 8 frames: 0 / -1.
FacadeRumbleOffsets::
	db $00, $ff

;@ def FacadeFight(slot: c)
;@ path: boss/facade
;@ State 2, the fight. The face rumbles and moves its mouth at random. Every $40 frames one of the 20
;@ floor tiles flies at Link (FacadeTileOrder); once 18 have flown, the four corner pots follow, one
;@ every $40 frames; once all 20 tiles and the 4 pots are done, holes open in the floor every $18-$27
;@ frames, never twice in a row at the same place. A hit plays the hurt animation (FacadeHurtFrames).
;@ wEntityPrivateCounter = tiles thrown, wEntityPrivate3 = pots thrown, wEntityPrivate2 = last hole.
;@ test: skip spawns entities
FacadeFight::
;>@if if hFrameCounter & 0x3F == 0 and GetRandomByte() & 1 == 0:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .rumble
;=@if
	call GetRandomByte
	and $01
	jr nz, .rumble
;>     wEntityTimer[slot] = 0x1F                # mouth movement
	call GetEntityTimer
	ld [hl], $1f

.rumble
;>@sh wScreenShakeX = mem[FacadeRumbleOffsets + ((hFrameCounter >> 3) & 1)]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld e, a
;=@sh
	ld d, b
	ld hl, FacadeRumbleOffsets
	add hl, de
	ld a, [hl]
	ld [wScreenShakeX], a
;> if wEntityDropTimer[slot] == 0:              # time for a hole
	call GetEntityDropTimer
	jr nz, .tile
;>     wEntityDropTimer[slot] = 0x18 + (GetRandomByte() & 0x0F)
	call GetRandomByte
	and $0f
	add $18
	ld [hl], a
;>@if2     if wEntityPrivateCounter[slot] >= 0x14 and wEntityPrivate3[slot] >= 4:   # tiles and pots used up
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $14
	jr c, .tile
;=@if2
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $04
	jr c, .tile
;>         new, full = SpawnEntity(slot, 0x5A)
	ld a, $5a
	call SpawnEntity
;>         if not full:
	jr c, .tile
;>             wEntityPrivate1[new] = 1         # a hole
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01

.pickHole
;>             while True:
;>                 spot = GetRandomByte() & 0x0F
	call GetRandomByte
	and $0f
;>                 if spot != wEntityPrivate2[slot]:   # not where the last one was
;>                     break
	ld hl, wEntityPrivate2
	add hl, bc
	cp [hl]
	jr z, .pickHole
;>             wEntityPrivate2[slot] = spot
	ld [hl], a
;>@hx             wEntityX[new] = mem[FacadeHoleX + spot]
	push bc
	ld c, a
	ld hl, FacadeHoleX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
;=@hx
	add hl, de
	ld [hl], a
;>             wEntityY[new] = mem[FacadeHoleY + spot]
	ld hl, FacadeHoleY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             wEntityTimer[new] = 0x7F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $7f
;>             wEntityPhysicsFlags[new] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;>             wEntityHitboxFlags[new] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
;>             wEntityOptions1[new] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
	pop bc

.tile
;> if wEntityTimer1[slot] == 0:                 # time for a flying tile
	call GetEntityTimer1
	jr nz, .pot
;>     wEntityTimer1[slot] = 0x40
	ld [hl], $40
;>     if wEntityPrivateCounter[slot] < 0x14:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $14
	jr nc, .pot
;>         new, full = SpawnEntity(slot, 0x5A)
	ld a, $5a
	call SpawnEntity
;>         if not full:
	jr c, .pot
;>             wEntityPrivate1[new] = 2         # a flying floor tile
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>             n = wEntityPrivateCounter[slot]
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld c, [hl]
;>             wEntityPrivateCounter[slot] += 1
	inc [hl]
;>             i = mem[FacadeTileOrder + n]
	ld hl, FacadeTileOrder
	add hl, bc
	ld c, [hl]
;>             wEntityX[new] = mem[FacadeTileX + i]
	ld hl, FacadeTileX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[new] = mem[FacadeTileY + i]
	ld hl, FacadeTileY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             wEntityPhysicsFlags[new] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;>             wEntityHitboxFlags[new] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
;>             wEntityOptions1[new] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
;>             wEntityHealthGroup[new] = 2
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], $02
	pop bc

.pot
;> if wEntityTimer2[slot] == 0:                 # time for a pot
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .anim
;>     wEntityTimer2[slot] = 0x40
	ld [hl], $40
;>@if3     if wEntityPrivate3[slot] < 4 and wEntityPrivateCounter[slot] >= 0x12:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $04
	jr nc, .anim
;=@if3
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $12
	jr c, .anim
;>         new, full = SpawnEntity(slot, 0x5A)
	ld a, $5a
	call SpawnEntity
;>         if not full:
	jr c, .anim
;>             wEntityPrivate1[new] = 3         # a pot
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
;>             n = wEntityPrivate3[slot]
	push bc
	ld hl, wEntityPrivate3
	add hl, bc
	ld c, [hl]
;>             wEntityPrivate3[slot] += 1
	inc [hl]
;>             wEntityX[new] = mem[FacadePotX + n]
	ld hl, FacadePotX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             hActiveEntityX = mem[FacadePotX + n]
	ldh [hActiveEntityX], a
;>             wEntityY[new] = mem[FacadePotY + n]
	ld hl, FacadePotY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             hActiveEntityY = mem[FacadePotY + n]
	ldh [hActiveEntityY], a
;>             wEntityPhysicsFlags[new] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;>             wEntityHitboxFlags[new] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
;>             wEntityOptions1[new] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
;>             wEntityHealthGroup[new] = 0x1B
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], $1b
;>             wEntitySpeedX[new] = 1                # probe the corner for the pot object
	push de
	pop bc
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $01
;>             EntityCheckWalls(new)
	call EntityCheckWalls
;>             if wEntityCollisions[new] == 0:  # the pot in that corner is already gone
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .potDone
;>                 DespawnEntity_04(new)
	call DespawnEntity_04

.potDone
	pop bc

.anim
;>@m SetEntitySpriteVariant(slot, mem[FacadeMouthFrames + ((wEntityTimer[slot] >> 3) & 3)])
	call GetEntityTimer
	rra
	rra
	rra
	and $03
	ld e, a
;=@m
	ld d, b
	ld hl, FacadeMouthFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> if wEntityFlashTimer[slot] != 0:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .hurt
;>     SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant

.hurt
;> if wEntityPrivate5[slot] != 0:               # hurt animation running
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     wEntityPrivate5[slot] -= 1
	dec [hl]
;>@hv     SetEntitySpriteVariant(slot, mem[FacadeHurtFrames + ((wEntityPrivate5[slot] >> 4) & 0x0F)])
	rra
	rra
	rra
	rra
	and $0f
	ld e, a
;=@hv
	ld d, b
	ld hl, FacadeHurtFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>     wEntityPhysicsFlags[slot] = 0x48
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $48

.done
;> return
	ret


;@ path: boss/facade
;@ Sprite variant during Facade's hurt animation, indexed by wEntityPrivate5 / 16 (15 down to 0): the
;@ face closes (2, 1, 0 ... read from the end), vanishes ($FF = not drawn) and comes back. 16 bytes.
FacadeHurtFrames::
	db $02, $01, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $01, $02
;@ path: boss/facade
;@ Sprites of the face: 5 variants of 8 sprites (32 bytes each; y offset, x offset, tile, OAM
;@ attributes): two rows of four 8x16 sprites (eyes on top, mouth below). Variants: 0 eyes open,
;@ 1 half open, 2 hurt, 3 eyes closed, 4 mouth open. Drawn by DrawFacade.
FacadeSprites::
	db $f8, $f0, $70, $00, $f8, $f8, $72, $00, $f8, $10, $72, $20, $f8, $18, $70, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20
	db $f8, $f0, $74, $00, $f8, $f8, $76, $00, $f8, $10, $76, $20, $f8, $18, $74, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20
	db $f8, $f0, $74, $00, $f8, $f8, $76, $00, $f8, $10, $76, $20, $f8, $18, $74, $20
	db $08, $f8, $60, $00, $08, $00, $62, $00, $08, $08, $62, $20, $08, $10, $60, $20
	db $f8, $f0, $78, $00, $f8, $f8, $7a, $00, $f8, $10, $7a, $20, $f8, $18, $78, $20
	db $08, $f8, $60, $00, $08, $00, $62, $00, $08, $08, $62, $20, $08, $10, $60, $20
	db $f8, $f0, $70, $00, $f8, $f8, $72, $00, $f8, $10, $72, $20, $f8, $18, $70, $20
	db $08, $f8, $60, $00, $08, $00, $62, $00, $08, $08, $62, $20, $08, $10, $60, $20

;@ def DrawFacade(slot: c)
;@ path: boss/facade
;@ Draws the face: 8 sprites of FacadeSprites for its variant.
;@ test: skip writes OAM through bank-0 sprite code
DrawFacade::
;>@d DrawEntitySprites(FacadeSprites + (wEntitySpriteVariant[slot] << 5), 8)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@d
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, FacadeSprites
;=@d
	add hl, de
	ld c, $08
	call DrawEntitySprites
	ret


;@ path: boss/facade
;@ Sprites of a hole: 4 variants of a 16x16 entity (left tile, attributes, right tile, attributes; the
;@ right half mirrored), from a small dent (0) to the open hole (3).
FacadeHoleSprites::
	db $68, $00, $68, $20, $6a, $00, $6a, $20, $6c, $00, $6c, $20, $6e, $00, $6e, $20
;@ path: boss/facade
;@ Variant of a hole by timer / 8 (15 down to 0, timer starts at $7F): opens, stays open (3), closes.
;@ 16 bytes.
FacadeHoleFrames::
	db $00, $01, $02, $03, $03, $03, $03, $03, $03, $02, $01, $00, $00, $00, $00, $00

;@ def FacadeHole(slot: c)
;@ path: boss/facade
;@ Piece 1, a hole in the floor. While it is fully open it pulls Link in when he is within 8 pixels and
;@ on the ground; within 3 pixels he falls in (Link motion 6, as into a pit of sinking sand).
;@ test: skip moves Link through bank-0 code
FacadeHole::
;> DrawEntity16x16(slot, FacadeHoleSprites)
	ld de, FacadeHoleSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return DespawnEntity_04(slot)
	jp z, DespawnEntity_04
;> if t == 0x50:
	cp $50
	jr nz, .anim
;>     hJingle = 0x40
	ld hl, hJingle
	ld [hl], $40

.anim
;>@v open = mem[FacadeHoleFrames + ((t >> 3) & 0x0F)]
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@v
	ld hl, FacadeHoleFrames
	add hl, de
	ld a, [hl]
;> SetEntitySpriteVariant(slot, open)
	call SetEntitySpriteVariant
;>@if if open == 3 and wLinkMotionState != 6 and hLinkPositionZ == 0:   # open, Link not falling, on the ground
	cp $03
	jr nz, .done
;=@if
	ld a, [wLinkMotionState]
	cp $06
	jr z, .done
;=@if
	ldh a, [hLinkPositionZ]
	and a
	jr nz, .done
;>@near     if (GetEntityXDistanceToLink_04(slot) + 8) & 0xFF < 0x10 and (GetEntityYDistanceToLink_04(slot) + 8) & 0xFF < 0x10:
	call GetEntityXDistanceToLink_04
	add $08
	cp $10
	jr nc, .done
;=@near
	call GetEntityYDistanceToLink_04
	add $08
	cp $10
	jr nc, .done
;>         GetVectorTowardsLink(slot, 0x0C)                      # vector towards Link ...
	ld a, $0c
	call GetVectorTowardsLink
;>         hLinkSpeedY = -hMultiPurpose0        # ... reversed: pull Link to the hole
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ldh [hLinkSpeedY], a
;>         hLinkSpeedX = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ldh [hLinkSpeedX], a
;>         ApplyLinkSpeed()
	push bc
	call ApplyLinkSpeed
	pop bc
;>@in         if (GetEntityXDistanceToLink_04(slot) + 3) & 0xFF < 6 and (GetEntityYDistanceToLink_04(slot) + 3) & 0xFF < 6:
	call GetEntityXDistanceToLink_04
	add $03
	cp $06
	jr nc, .done
;=@in
	call GetEntityYDistanceToLink_04
	add $03
	cp $06
	jr nc, .done
;>             hLinkX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;>             wLinkMotionState = 6             # falling into a hole
	ld a, $06
	ld [wLinkMotionState], a
;>             ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>             wLinkMotionCounter = 0
	ld [wLinkMotionCounter], a
;>             wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>             wHoleCollisionType = 0x50
	ld a, $50
	ld [wHoleCollisionType], a

.done
;> return
	ret


;@ path: boss/facade
;@ Sprites of a flying floor tile: 2 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes; right half mirrored): tiles $40 / $42, swapped every 8 frames.
FacadeTileSprites::
	db $40, $00, $40, $20, $42, $00, $42, $20

;@ path: boss/facade
;@ The same flying tile in map 1, which has the floor graphics at tiles $70 / $72.
FacadeTileSpritesMap1::
	db $70, $00, $70, $20, $72, $00, $72, $20

;@ def FacadeFlyingTile(slot: c)
;@ path: boss/facade
;@ Piece 2: a floor tile that lifts off, hovers buzzing and then flies straight at Link; it shatters
;@ when it hits a wall or is hit. Lifting off leaves floor where it was.
;@ test: skip dispatches through a jump table
FacadeFlyingTile::
;>@d DrawEntity16x16(slot, FacadeTileSpritesMap1 if hMapId == 1 else FacadeTileSprites)
	ld de, FacadeTileSprites
	ldh a, [hMapId]
	cp $01
	jr nz, .draw
	ld de, FacadeTileSpritesMap1
.draw
;=@d
	call DrawEntity16x16
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> if wEntityFlashTimer[slot] != 0:             # hit
;>     return ShatterFacadePiece(slot)
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, ShatterFacadePiece
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .states
;>     hJingle = 0x3F                           # buzzing
	ld a, $3f
	ldh [hJingle], a

.states
;> return FacadeFlyingTileStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/facade
;@ States of a flying floor tile.
FacadeFlyingTileStates::
	dw FacadeTileLiftOff
	dw FacadeTileRise
	dw FacadeTileFly

;@ def FacadeTileLiftOff(slot: c)
;@ path: boss/facade
;@ State 0: hover for $60 frames; put a room object where the tile was, chosen by wEntityPrivate4: 1
;@ object $AA, $10 object $1D, $20 object $AE, anything else (the Facade's tiles) the floor object $0D.
;@ test: skip queues background drawing
FacadeTileLiftOff::
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;> wEntityState[slot] += 1
	call IncrementEntityState
;> kind = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
;> if kind == 0x01:
;>     return PlaceObjectAAUnderEntity()
	cp $01
	jp z, PlaceObjectAAUnderEntity
;> if kind == 0x10:
;>     return PlaceObject1DUnderEntity()
	cp $10
	jp z, PlaceObject1DUnderEntity
;> if kind == 0x20:
;>     return PlaceObjectAEUnderEntity()
	cp $20
	jp z, PlaceObjectAEUnderEntity
;> return PlaceFloorUnderEntity()
	jp PlaceFloorUnderEntity


;@ def FacadeTileRise(slot: c)
;@ path: boss/facade
;@ State 1: during the first $30 frames the piece rises one pixel every 4 frames, then hovers; when the
;@ timer runs out it flies straight at Link at speed $18. Also used by the pots (FacadePotRise).
;@ test: skip calls bank-3 collision code
FacadeTileRise::
;> EntityCheckWeaponHits(slot)                              # weapon hits
	call EntityCheckWeaponHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr z, .launch
;>@a     if t >= 0x30 and t & 3 == 0:
	cp $30
	jr c, .done
	and $03
	jr nz, .rise
;>         wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

.rise
;>     return
	ret


.launch
;> wEntityState[slot] += 1
	call IncrementEntityState
;> SetEntitySpeedTowardsLink(slot, 0x18)                              # straight at Link
	ld a, $18
	call SetEntitySpeedTowardsLink

.done
;> return
	ret


;@ def FacadeTileFly(slot: c)
;@ path: boss/facade
;@ State 2: flies on; hurts Link on touch and shatters against a wall.
;@ test: skip calls bank-3 collision code
FacadeTileFly::
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)                              # walls
	call EntityCheckWalls
;> EntityCheckHits(slot)                              # touching Link, weapon hits
	call EntityCheckHits
;> if wEntityCollisions[slot] != 0:
;>     ShatterFacadePiece(slot)                 # (falls through)
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, ShatterFacadePiece.done

;@ def ShatterFacadePiece(slot: c)
;@ path: boss/facade
;@ The flying tile or pot breaks: shards, and the entity is removed.
;@ test: skip spawns an effect through bank 3
ShatterFacadePiece::
;> BreakIntoPiecesFar(slot)                                  # shards (removes the entity)
	call BreakIntoPiecesFar

.done
;> return
	ret


;@ path: boss/facade
;@ Sprite of a pot: one 16x16 variant (tile $F0 for both halves, the right half mirrored; palette
;@ bit 4 set).
FacadePotSprites::
	db $f0, $10, $f0, $30

;@ def FacadePot(slot: c)
;@ path: boss/facade
;@ Piece 3: one of the four corner pots. It lifts off like the floor tiles, flies at Link and shatters.
;@ test: skip dispatches through a jump table
FacadePot::
;> DrawEntity16x16(slot, FacadePotSprites)
	ld de, FacadePotSprites
	call DrawEntity16x16
;> if wEntityFlashTimer[slot] != 0:
;>     return ShatterFacadePiece(slot)
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, ShatterFacadePiece
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> return FacadePotStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/facade
;@ States of a flying pot.
FacadePotStates::
	dw FacadePotLiftOff
	dw FacadePotRise
	dw FacadePotFly

;@ def FacadePotLiftOff(slot: c)
;@ path: boss/facade
;@ State 0: the pot object in the corner becomes floor; hover for $60 frames.
;@ test: skip queues background drawing
FacadePotLiftOff::
;> PlaceFloorUnderPot()
	call PlaceFloorUnderPot
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
	ret


;@ def FacadePotRise(slot: c)
;@ path: boss/facade
;@ State 1 of a pot: the same as FacadeTileRise (rises, hovers, launches at Link at speed $18).
;@ test: skip calls bank-3 collision code
FacadePotRise::
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr z, .launch
;>@a     if t >= 0x30 and t & 3 == 0:
	cp $30
	jr c, .done
	and $03
	jr nz, .rise
;>         wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

.rise
;>     return
	ret


.launch
;> wEntityState[slot] += 1
	call IncrementEntityState
;> SetEntitySpeedTowardsLink(slot, 0x18)
	ld a, $18
	call SetEntitySpeedTowardsLink

.done
;> return
	ret


;@ def FacadePotFly(slot: c)
;@ path: boss/facade
;@ State 2 of a pot: flies on, hurts Link on touch, shatters against a wall.
;@ test: skip calls bank-3 collision code
FacadePotFly::
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityCollisions[slot] != 0:
;>     return ShatterFacadePiece(slot)
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jp nz, ShatterFacadePiece

	ret


;@ path: world/room_objects
;@ Background tiles of the floor object $0D (top left, bottom left, top right, bottom right), put where a
;@ flying floor tile lifted off. 4 bytes.
FloorObjectTiles::
	db $10, $12, $11, $13

;@ path: world/room_objects
;@ The same floor tiles, put where a pot lifted off. 4 bytes.
PotFloorObjectTiles::
	db $10, $12, $11, $13

;@ path: world/room_objects
;@ Background tiles of room object $AA (top left, bottom left, top right, bottom right). 4 bytes.
ObjectAATiles::
	db $14, $16, $15, $17

;@ path: world/room_objects
;@ Background tiles of room object $AE. 4 bytes.
ObjectAETiles::
	db $76, $77, $76, $77
;@ path: world/room_objects
;@ Background tiles of room object $1D. 4 bytes.
Object1DTiles::
	db $76, $49, $76, $49

;@ def PlaceObjectAAUnderEntity()
;@ path: world/room_objects
;@ Puts room object $AA (tiles ObjectAATiles) on the square under the entity.
;@ test: skip queues background drawing
PlaceObjectAAUnderEntity::
;> return PlaceRoomObjectUnderEntity(0xAA, ObjectAATiles)
	ld de, ObjectAATiles
	ld a, $aa
	jr PlaceRoomObjectUnderEntity

;@ def PlaceObjectAEUnderEntity()
;@ path: world/room_objects
;@ Puts room object $AE on the square under the entity.
;@ test: skip queues background drawing
PlaceObjectAEUnderEntity::
;> return PlaceRoomObjectUnderEntity(0xAE, ObjectAETiles)
	ld de, ObjectAETiles
	ld a, $ae
	jr PlaceRoomObjectUnderEntity

;@ def PlaceObject1DUnderEntity()
;@ path: world/room_objects
;@ Puts room object $1D on the square under the entity.
;@ test: skip queues background drawing
PlaceObject1DUnderEntity::
;> return PlaceRoomObjectUnderEntity(0x1D, Object1DTiles)
	ld de, Object1DTiles
	ld a, $1d
	jr PlaceRoomObjectUnderEntity

;@ def PlaceFloorUnderPot()
;@ path: world/room_objects
;@ Puts the floor object $0D where a pot stood.
;@ test: skip queues background drawing
PlaceFloorUnderPot::
;> return PlaceRoomObjectUnderEntity(0x0D, PotFloorObjectTiles)
	ld de, PotFloorObjectTiles
	ld a, $0d
	jr PlaceRoomObjectUnderEntity

;@ def PlaceFloorUnderEntity()
;@ path: world/room_objects
;@ Puts the floor object $0D on the square under the entity.
;@ test: skip queues background drawing
PlaceFloorUnderEntity::
;> return PlaceRoomObjectUnderEntity(0x0D, FloorObjectTiles)   # (falls through)
	ld de, FloorObjectTiles
	ld a, $0d

;@ def PlaceRoomObjectUnderEntity(object: a, tiles: de)
;@ path: world/room_objects
;@ Replaces the room object on the 16x16 square under the active entity (its position minus (7, 15)) by
;@ `object` in wRoomObjects and queues the drawing of its 4 tiles (`tiles`: top left, bottom left, top
;@ right, bottom right) as two vertical 2-tile draw commands for the next VBlank.
;@ test: skip queues background drawing through bank-0 code
PlaceRoomObjectUnderEntity::
;> hMultiPurpose0 = object
	ldh [hMultiPurpose0], a
	push de
;> hBGPosY = hActiveEntityY - 0x0F
	ldh a, [hActiveEntityY]
	sub $0f
	ldh [hBGPosY], a
;> hBGPosX = hActiveEntityX - 7
	ldh a, [hActiveEntityX]
	sub $07
	ldh [hBGPosX], a
;>@sq square = (hBGPosY & 0xF0) | (hBGPosX >> 4)  # row * 16 + column
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
;=@sq
	ld e, a
	ld d, $00
;> wRoomObjects[square] = object
	ld hl, wRoomObjects
	add hl, de
	ldh a, [hMultiPurpose0]
	ld [hl], a
;> GetBGAddress()                               # -> hBGAddrHigh / hBGAddrLow
	call GetBGAddress
;> cmd = addr(wDrawCommand) + wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize += 10
	add $0a
	ld [wDrawCommandsSize], a
	pop de
;> mem[cmd] = hBGAddrHigh                       # left column: 2 tiles downwards
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x81
	ld a, $81
	ld [hli], a
;> mem[cmd + 3] = mem[tiles]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 4] = mem[tiles + 1]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[cmd + 5] = hBGAddrHigh                   # right column
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 6] = (hBGAddrLow + 1) & 0xFF
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
;> mem[cmd + 10] = 0                            # end of the queue
	xor a
	ld [hl], a
	ret


;@ def MoldormInit(slot: c)
;@ path: boss/moldorm
;@ Set-up of a new Moldorm (entity $59, from the entity init table in bank 3, through a bank-switch stub
;@ in bank 0): clears the trail index ($D201) and the first $80 bytes of wEntityWorkRAM2 (its trail of
;@ y positions).
;@ test: slot = rand(0, 15)
MoldormInit::
;> wEntityScratch1 = 0                         # ($D201)
	xor a
	ld [wEntityScratch1], a
;> fill(addr(wEntityWorkRAM2), 0, 0x80)
	ld e, $80
	ld hl, wEntityWorkRAM2
.clear
	xor a
	ld [hli], a
	dec e
	jr nz, .clear

;> return
	ret


;@ path: boss/moldorm
;@ Head sprite variant of Moldorm by its direction / 2 (wEntityPrivate1 >> 1, 0-7; direction 0 =
;@ right, 4 = down, 8 = left, 12 = up). 8 bytes.
MoldormDirectionTable::
	db $06, $07, $00, $01, $02, $03, $04, $05

;@ def CheckLinkCollisionsIfInteractive_04(slot: c)
;@ path: entity/helpers
;@ Unless the game is frozen: Link touching the entity is hurt, Link's weapons hit it.
;@ test: skip calls bank-3 collision code
CheckLinkCollisionsIfInteractive_04::
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> return EntityCheckHits(slot)
	jp EntityCheckHits


;@ def MoldormHandler(slot: c)
;@ path: boss/moldorm
;@ Entity $59: Moldorm, boss of Tail Cave (level 1), a worm that crawls around the room. Its body is
;@ drawn from a trail of its past head positions (128 entries: x in wEntityWorkRAM, y in
;@ wEntityWorkRAM2, written at wEntityPrivateCounter); only the tail can be hurt. When it is beaten
;@ its segments burst one by one and the head explodes into a heart container.
;@ test: skip dispatches through a jump table into the whole boss
MoldormHandler::
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> CheckLinkCollisionsIfInteractive_04(slot)    # the head hurts Link
	call CheckLinkCollisionsIfInteractive_04
;> DrawMoldorm(slot)
	call DrawMoldorm
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> if wRoomTransitionState != 0:
;>     return MoldormInit(slot)                 # forget the trail
	ld a, [wRoomTransitionState]
	and a
	jp nz, MoldormInit
;> StartBossMusic(slot)
	call StartBossMusic
;> if hActiveEntityStatus == 5:
;>     return MoldormActive(slot)
	ldh a, [hActiveEntityStatus]
	cp $05
	jp z, MoldormActive
;> return MoldormDeathStates[hActiveEntityState](slot)   # defeated
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/moldorm
;@ States of Moldorm's death.
MoldormDeathStates::
	dw MoldormDeathStart
	dw MoldormDeathWait
	dw MoldormDeathBreakUp
	dw MoldormDeathExplodeHead

;@ def MoldormDeathStart(slot: bc)
;@ path: boss/moldorm
;@ Death state 0: flash, wait $60 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
MoldormDeathStart::
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def MoldormDeathWait(slot: bc)
;@ path: boss/moldorm
;@ Death state 1: when the wait is over, keep flashing for $FF more frames while it breaks up.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
MoldormDeathWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def MoldormDeathBreakUp(slot: c)
;@ path: boss/moldorm
;@ Death state 2: every 32 frames the last remaining piece (tail first) bursts: wEntityPrivate3 counts
;@ the pieces gone. After four, the head explodes (state 3, $30 frames).
;@ test: skip spawns an effect
MoldormDeathBreakUp::
;> if wEntityTimer[slot] & 0x1F != 0:
;>     return
	call GetEntityTimer
	and $1f
	jr nz, .done
;> if wEntityPrivate3[slot] != 4:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, .head
;>     wEntityPrivate3[slot] += 1
	inc [hl]
;>     SpawnExplosionAtEntity_04()
	call SpawnExplosionAtEntity_04

.done
;>     return
	ret


.head
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> return IncrementEntityState(slot)                       # next state
	jp IncrementEntityState


;@ path: boss/moldorm
;@ Offsets of the head explosions in a small circle: x offsets at +0 (8 bytes), y offsets at +8 (8
;@ bytes); signed pixels, indexed by (timer / 4) & 7.
MoldormExplosionCircle::
	db $00, $06, $08, $06, $00, $fa, $f8, $fa, $f8, $fa, $00, $06, $08, $06, $00, $fa

;@ def MoldormDeathExplodeHead(slot: c)
;@ path: boss/moldorm
;@ Death state 3: explosions every 4 frames going round the head; at timer $10 the head disappears
;@ (wEntityPrivate3 = 5); at the end a heart container appears.
;@ test: skip spawns an effect
MoldormDeathExplodeHead::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return BossDropHeartContainer_04(slot)
	jp z, BossDropHeartContainer_04
;> if t & 3 == 0:
	and $03
	jr nz, .done
;>     i = (t >> 2) & 7
	ld a, [hl]
	rra
	rra
	and $07
	ld e, a
	ld d, b
;>     hActiveEntityX += mem[MoldormExplosionCircle + i]
	ld hl, MoldormExplosionCircle
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY += mem[MoldormExplosionCircle + 8 + i]
	ld hl, MoldormExplosionCircle + 8
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;>     SpawnExplosionAtEntity_04()
	call SpawnExplosionAtEntity_04
;>     if wEntityTimer[slot] == 0x10:
	call GetEntityTimer
	cp $10
	jr nz, .done
;>         wEntityPrivate3[slot] = 5            # head gone
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], $05

.done
;> return
	ret


;@ def BossDropHeartContainer_04(slot: c)
;@ path: entity/helpers
;@ The beaten boss turns into a heart container (entity $36): spawned at its position, kept inside the
;@ room (x $18-$88, y $20-$70), at its height and hopping up (speed $10); the boss is removed.
;@ test: skip spawns an entity
BossDropHeartContainer_04::
;> new, _ = SpawnEntity(slot, 0x36)                        # (no check for a full entity table)
	ld a, $36
	call SpawnEntity
;>@x wEntityX[new] = min(max(hMultiPurpose0, 0x18), 0x88)
	ldh a, [hMultiPurpose0]
	cp $88
	jr c, .xMax
	ld a, $88
.xMax
;=@x
	cp $18
	jr nc, .xMin
	ld a, $18
.xMin
;=@x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@y wEntityY[new] = min(max(hMultiPurpose1, 0x20), 0x70)
	ldh a, [hMultiPurpose1]
	cp $70
	jr c, .yMax
	ld a, $70
.yMax
;=@y
	cp $20
	jr nc, .yMin
	ld a, $20
.yMin
;=@y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpeedZ[new] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;> wEntityZ[new] = hMultiPurpose3               # the boss's height
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;> hNoiseSfx = 0x1A
	ld hl, hNoiseSfx
	ld [hl], $1a
;> return DespawnEntity_04(slot)
	jp DespawnEntity_04


;@ def MoldormActive(slot: c)
;@ path: boss/moldorm
;@ The living Moldorm crawls one step per frame, two once it is down to its last hit point or while
;@ wEntityTimer2 runs (sound flag $D3D6 = 1 meanwhile). Its crawling noise ($1B) sounds every $10
;@ steps ($0B when fast), counted in $D201.
;@ test: skip calls bank-3 movement code
MoldormActive::
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> wSfxFastVariant = 0
	xor a
	ld [wSfxFastVariant], a
;> noiseEvery = 0x10
	ld e, $10
;>@fast if wEntityHealth[slot] < 2 or wEntityTimer2[slot] != 0:
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $02
	jr c, .fast
;=@fast
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .noise

.fast
;>     MoldormStep(slot)                        # an extra step
	call MoldormStep
;>     wSfxFastVariant = 1
	ld a, $01
	ld [wSfxFastVariant], a
;>     noiseEvery = 0x0B
	ld e, $0b

.noise
;> wEntityScratch1 += 1                        # ($D201) step counter
	ld hl, wEntityScratch1
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityScratch1 >= noiseEvery:
	cp e
	jr c, MoldormStep
;>     wEntityScratch1 = 0
	ld [hl], b
;>     hNoiseSfx = 0x1B
	ld a, $1b
	ldh [hNoiseSfx], a
;> return MoldormStep(slot)                     # (falls through)

;@ def MoldormStep(slot: c)
;@ path: boss/moldorm
;@ One step of Moldorm: writes the head position into the next entry of the trail, crawls (WormCrawl)
;@ and turns the head sprite to its direction.
;@ test: skip calls bank-3 movement code
MoldormStep::
;> wEntityPrivateCounter[slot] = (wEntityPrivateCounter[slot] + 1) & 0x7F
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $7f
	ld [hl], a
;> i = wEntityPrivateCounter[slot]
	ld e, a
	ld d, b
;> wEntityWorkRAM[i] = hActiveEntityX
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hActiveEntityX]
	ld [hl], a
;> wEntityWorkRAM2[i] = hActiveEntityDrawY
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
;> WormCrawl(slot)
	call WormCrawl
;>@v SetEntitySpriteVariant(slot, mem[MoldormDirectionTable + (wEntityPrivate1[slot] >> 1)])
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
	ld hl, MoldormDirectionTable
;=@v
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ path: boss/moldorm
;@ Sprites of Moldorm's head: 8 variants of 8 sprites (32 bytes each; y offset, x offset, tile, OAM
;@ attributes with x / y flip), a 32x32 head for each of 8 directions (see MoldormDirectionTable).
;@ Drawn by DrawMoldorm.
MoldormHeadSprites::
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6c, $00, $08, $00, $6e, $00, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $6c, $40, $f8, $00, $6e, $40, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6e, $60, $f8, $10, $6c, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6e, $20, $08, $10, $6c, $20



;@ path: boss/moldorm
;@ Sprites of Moldorm's body: 16x16 pieces (left tile, attributes, right tile, attributes; right half
;@ mirrored). 0 body segment, 1 smaller segment, 2 and 3 the tail (two frames).
MoldormSegmentSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20

;@ def DrawMoldorm(slot: c)
;@ path: boss/moldorm
;@ Draws the head (8 sprites) and, from the trail, the body segments $0C, $18 and $24 steps behind and
;@ the flickering tail $2E steps behind; pieces already burst (wEntityPrivate3) are left out. The tail
;@ is where Link's weapons are checked (it is the weak spot), while the entity is not flashing.
;@ test: skip writes OAM through bank-0 sprite code
DrawMoldorm::
;> if wEntityPrivate3[slot] >= 5:               # all gone
;>     return
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $05
	jp nc, .done
;> wEntityPhysicsFlags[slot] = 0x08             # 8 sprites for the head
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $08
;>@d DrawEntitySprites(MoldormHeadSprites + (wEntitySpriteVariant[slot] << 5), 8)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@d
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, MoldormHeadSprites
;=@d
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> wEntityPhysicsFlags[slot] = 0x02             # 2 sprites for each further piece
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $02
;> head = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> if wEntityPrivate3[slot] >= 4:
;>     return
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $04
	jp nc, .done
;> i = (head - 0x0C) & 0x7F                     # first segment
	ldh a, [hMultiPurpose0]
	sub $0c
	and $7f
	ld e, a
	ld d, b
;> hActiveEntityX = wEntityWorkRAM[i]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = wEntityWorkRAM2[i]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	ld a, $00
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, MoldormSegmentSprites)
	ld de, MoldormSegmentSprites
	call DrawEntity16x16
;> if wEntityPrivate3[slot] >= 3:
;>     return
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $03
	jp nc, .done
;> i = (head - 0x18) & 0x7F                     # second segment
	ldh a, [hMultiPurpose0]
	sub $18
	and $7f
	ld e, a
	ld d, b
;> hActiveEntityX = wEntityWorkRAM[i]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = wEntityWorkRAM2[i]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	ld a, $00
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, MoldormSegmentSprites)
	ld de, MoldormSegmentSprites
	call DrawEntity16x16
;> if wEntityPrivate3[slot] >= 2:
;>     return
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $02
	jr nc, .done
;> i = (head - 0x24) & 0x7F                     # small segment
	ldh a, [hMultiPurpose0]
	sub $24
	and $7f
	ld e, a
	ld d, b
;> hActiveEntityX = wEntityWorkRAM[i]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = wEntityWorkRAM2[i]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 1
	ld a, $01
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, MoldormSegmentSprites)
	ld de, MoldormSegmentSprites
	call DrawEntity16x16
;> if wEntityPrivate3[slot] != 0:
;>     return
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
;> i = (head - 0x2E) & 0x7F                     # the tail
	ldh a, [hMultiPurpose0]
	sub $2e
	and $7f
	ld e, a
	ld d, b
;> hActiveEntityX = wEntityWorkRAM[i]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = wEntityWorkRAM2[i]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;>@t hActiveEntitySpriteVariant = 2 + ((hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;=@t
	ldh [hActiveEntitySpriteVariant], a
;>@f hActiveEntityFlipAttribute ^= (hFrameCounter << 2) & 0x10   # palette flicker
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
;=@f
	ld [hl], a
;> DrawEntity16x16(slot, MoldormSegmentSprites)
	ld de, MoldormSegmentSprites
	call DrawEntity16x16
;> if wEntityFlashTimer[slot] == 0:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
;>     wEntityOptions1[slot] = 0x90             # the tail can be hit ...
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $90
;>     EntityCheckWeaponHits(slot)                          # ... by Link's weapons, here
	call EntityCheckWeaponHits
;>     wEntityOptions1[slot] = 0xD0
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $d0

.done
;> return
	ret


;@ def SpawnExplosionAtEntity_04()
;@ path: entity/helpers
;@ Unless the game is frozen: an explosion effect (transient effect 2) at hActiveEntityX /
;@ hActiveEntityDrawY, with noise $13.
;@ test: skip spawns a transient effect
SpawnExplosionAtEntity_04::
;> if ReturnIfGameFrozen_04(): return
	call ReturnIfGameFrozen_04
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                           # explosion
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret


;@ def MiniMoldormInit(slot: bc)
;@ path: enemy/mini_moldorm
;@ Set-up of a Mini Moldorm (entity $29; from the entity init table in bank 3, through a bank-switch
;@ stub in bank 0; also when it is hit or the screen scrolls): clears its 32-entry trail, which lies at
;@ wEntityWorkRAM / wEntityWorkRAM2 + wEntityLoadOrder * 32 (so several of them can share the area).
;@ test: wEntityLoadOrder[c] = rand(0, 7)
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
MiniMoldormInit::
;>@b base = wEntityLoadOrder[slot] << 5
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	ld d, b
;>@fx fill(addr(wEntityWorkRAM) + base, 0, 0x20)  # x trail
	ld hl, wEntityWorkRAM
	add hl, de
	push de
	ld e, $20
.clearX
;=@fx
	xor a
	ld [hli], a
	dec e
	ld a, e
	cp $00
	jr nz, .clearX
;>@fy fill(addr(wEntityWorkRAM2) + base, 0, 0x20) # y trail
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ld e, $20
.clearY
;=@fy
	xor a
	ld [hli], a
	dec e
	ld a, e
	cp $00
	jr nz, .clearY

;> return
	ret


;@ path: enemy/mini_moldorm
;@ Sprites of the Mini Moldorm: 10 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes; bit 5 x flip, bit 6 y flip). 0-7 the head in 8 directions (see WormDirectionVariants),
;@ 8 a body segment, 9 the tail. Drawn by DrawMiniMoldorm.
MiniMoldormSprites::
	db $70, $00, $70, $20, $70, $40, $70, $60, $72, $00, $74, $00, $74, $20, $72, $20
	db $76, $00, $78, $00, $78, $20, $76, $20, $76, $40, $78, $40, $78, $60, $76, $60
	db $7a, $00, $7a, $20, $7c, $00, $7c, $20

;@ path: enemy/mini_moldorm
;@ Head sprite variant (of MiniMoldormSprites) for each of the 16 crawling directions (wEntityPrivate1:
;@ 0 right, 4 down, 8 left, 12 up). 16 bytes.
WormDirectionVariants::
	db $03, $03, $05, $05, $00, $00, $04, $04
	db $02, $02, $06, $06, $01, $01, $07, $07

;@ path: enemy/mini_moldorm
;@ Speed for each of the 16 crawling directions (signed, 1/16 pixel per frame, magnitude $10): the
;@ y speed is entry [direction], the x speed entry [direction + 4]. 20 bytes. Used by WormCrawl for
;@ the Mini Moldorm and Moldorm.
WormDirectionSpeeds::
	db $00, $06, $0c, $0e, $10, $0e, $0c, $06
	db $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa, $00, $06, $0c, $0e

;@ def MiniMoldormHandler(slot: c)
;@ path: enemy/mini_moldorm
;@ Entity $29: Mini Moldorm, a small worm (head and two segments) that crawls in wavy lines and turns
;@ away from walls. It writes its head position into its own 32-entry trail every frame; its trail is
;@ cleared while it is hit or the screen scrolls.
;@ test: skip calls bank-3 movement code
MiniMoldormHandler::
;> DrawMiniMoldorm(slot)
	call DrawMiniMoldorm
;>@if if wRoomTransitionState != 0 or wEntityIgnoreHitsTimer[slot] != 0:
	ld a, [wRoomTransitionState]
	and a
	jr nz, .reset
;=@if
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .run
.reset
;>     MiniMoldormInit(slot)
	call MiniMoldormInit

.run
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> i = (wEntityPrivateCounter[slot] + 1) & 0x1F
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $1f
;> wEntityPrivateCounter[slot] = i
	ld [hl], a
	ldh [hMultiPurpose0], a
;>@b base = wEntityLoadOrder[slot] << 5
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	ld d, $00
	push de
;>@x wEntityWorkRAM[base + i] = hActiveEntityX
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	ld e, a
	add hl, de
	ldh a, [hActiveEntityX]
;=@x
	ld [hl], a
;>@y wEntityWorkRAM2[base + i] = hActiveEntityDrawY
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	ld e, a
	add hl, de
;=@y
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> EntityCheckHits(slot)                              # touching Link, weapon hits
	call EntityCheckHits
;> return WormCrawl(slot)                       # (falls through)

;@ def WormCrawl(slot: c)
;@ path: enemy/mini_moldorm
;@ Crawling of the Mini Moldorm and Moldorm. Direction (wEntityPrivate1, 0-15) turns by
;@ wEntityPrivate2 (+1 or -1) every 4 frames (6 for Moldorm); the turning sense changes at random every
;@ $10-$2F frames. On hitting a wall the worm heads straight away from it (and turns the other way half
;@ of the time). It does not move while it flashes from a hit.
;@ test: skip calls bank-3 movement code
WormCrawl::
;> if wEntityFlashTimer[slot] == 0:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .walls
;>     UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04

.walls
;> EntityCheckWalls(slot)                              # walls
	call EntityCheckWalls
;> walls = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
;> if walls != 0:
	and a
	jr z, .turn
;>     if walls & 1:                            # wall on the right: go left
;>         newDir = 8
	ld e, $08
	bit 0, a
	jr nz, .setDir
;>     elif walls & 2:                          # on the left: go right
;>         newDir = 0
	ld e, $00
	bit 1, a
	jr nz, .setDir
;>     elif walls & 4:                          # above: go down
;>         newDir = 4
	ld e, $04
	bit 2, a
	jr nz, .setDir
;>     else:                                    # below: go up
;>         newDir = 12
	ld e, $0c

.setDir
;>     wEntityPrivate1[slot] = newDir
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], e
;>     if GetRandomByte() & 1 == 0:
	call GetRandomByte
	rra
	jr c, .wallTimer
;>         wEntityPrivate2[slot] = -wEntityPrivate2[slot]   # turn the other way
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.wallTimer
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10

.turn
;> if wEntityTimer1[slot] == 0:                 # time to turn a step
	call GetEntityTimer1
	jr nz, .sense
;>     wEntityTimer1[slot] = 6 if hActiveEntityType == 0x59 else 4    # Moldorm turns slower
	ld [hl], $04
	ldh a, [hActiveEntityType]
	cp $59
	jr nz, .step
	ld [hl], $06
.step
;>@d     dir = (wEntityPrivate1[slot] + wEntityPrivate2[slot]) & 0x0F
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
;=@d
	and $0f
;>     wEntityPrivate1[slot] = dir
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>     SetEntitySpriteVariant(slot, mem[WormDirectionVariants + dir])
	ld hl, WormDirectionVariants
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>     wEntitySpeedY[slot] = mem[WormDirectionSpeeds + dir]
	ld hl, WormDirectionSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = mem[WormDirectionSpeeds + dir + 4]
	ld hl, WormDirectionSpeeds + 4
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

.sense
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x10 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;>     wEntityPrivate2[slot] = (GetRandomByte() & 2) - 1                # -1 or +1
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

.done
;> return
	ret


;@ def DrawMiniMoldorm(slot: c)
;@ path: enemy/mini_moldorm
;@ Draws the head and, from the trail, a body segment 9 steps behind and the tail 16 steps behind.
;@ test: skip writes OAM through bank-0 sprite code
DrawMiniMoldorm::
;> DrawEntity16x16(slot, MiniMoldormSprites)                # the head
	ld de, MiniMoldormSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> head = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>@b base = wEntityLoadOrder[slot] << 5
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	ld d, b
	push de
	push de
;> i = (head - 9) & 0x1F
;>@x1 hActiveEntityX = wEntityWorkRAM[base + i]
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	sub $09
	and $1f
	ld e, a
;=@x1
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>@y1 hActiveEntityDrawY = wEntityWorkRAM2[base + i]
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	sub $09
	and $1f
;=@y1
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 8               # segment
	ld a, $08
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, MiniMoldormSprites)
	ld de, MiniMoldormSprites
	call DrawEntity16x16
;> i = (head - 0x10) & 0x1F
;>@x2 hActiveEntityX = wEntityWorkRAM[base + i]
	pop de
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	sub $10
;=@x2
	and $1f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>@y2 hActiveEntityDrawY = wEntityWorkRAM2[base + i]
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	sub $10
	and $1f
;=@y2
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 9               # tail
	ld a, $09
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, MiniMoldormSprites)
	ld de, MiniMoldormSprites
	call DrawEntity16x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
	ret


;@ path: enemy/ghini
;@ Sprites of the Ghini: 2 variants (floating frames) of a 16x16 entity (left tile, attributes, right
;@ tile, attributes): tiles $58/$5A and $5C/$5E. Mirrored by FlipSpriteBySpeedX_04 when it flies right.
GhiniSprites::
	db $58, $00, $5a, $00, $5c, $00, $5e, $00

;@ path: enemy/ghini
;@ Horizontal cruising speed of a Ghini by its x direction (wEntityPrivate1: 0 right +12, 1 left -12).
GhiniTargetSpeedX::
	db $0c, $f4

;@ path: enemy/ghini
;@ Vertical cruising speed by its y direction (wEntityPrivate2: 0 down +8, 1 up -8).
GhiniTargetSpeedY::
	db $08, $f8

;@ def GiantGhiniHandler(slot: c)
;@ path: enemy/ghini
;@ Entity $11: the Giant Ghini of the graveyard (32x32). Behaves like the Ghini.
;@ test: skip calls bank-3 collision code
GiantGhiniHandler::
;> DrawGiantGhini(slot)
	call DrawGiantGhini
;> return GhiniCommon(slot)
	jr GhiniCommon

;@ def GhiniHandler(slot: c)
;@ path: enemy/ghini
;@ Entities $10 and $12: the Ghini, a ghost. $12 starts flying; $10 (like the Giant Ghini) starts
;@ hidden (state 1) and comes out of its grave when Link pushes against something next to it.
;@ test: skip calls bank-3 collision code
GhiniHandler::
;> FlipSpriteBySpeedX_04(slot)
	call FlipSpriteBySpeedX_04
;> DrawEntity16x16(slot, GhiniSprites)
	ld de, GhiniSprites
	call DrawEntity16x16
;> return GhiniCommon(slot)                     # (falls through)

;@ def GhiniCommon(slot: c)
;@ path: enemy/ghini
;@ Ghini behaviour. State 1, hidden: not drawn; when Link is within 16 pixels and pushing against a
;@ wall or object (wLinkCollisionFlags), it appears (state 0) and floats out harmlessly for $30
;@ frames (wEntityTimer2). State 0: floats at height $10 and drifts, its speed easing towards
;@ +-12 / +-8 in directions chosen at random (x every $20-$3F frames, y every $18-$27 frames) and
;@ turned back near the edges of the room (x $28 / $78, y $28 / $60). Touching it hurts Link.
;@ test: skip calls bank-3 collision code
GhiniCommon::
;> if hActiveEntityState != 0:                  # hidden
	ldh a, [hActiveEntityState]
	and a
	jr z, .visible
;>     SetEntitySpriteVariant(slot, 0xFF)
	ld a, $ff
	call SetEntitySpriteVariant
;>@near     if (GetEntityXDistanceToLink_04(slot) + 0x10) & 0xFF < 0x20 and (GetEntityYDistanceToLink_04(slot) + 0x10) & 0xFF < 0x20 and wLinkCollisionFlags != 0:
	call GetEntityXDistanceToLink_04
	add $10
	cp $20
	jr nc, .done
;=@near
	call GetEntityYDistanceToLink_04
	add $10
	cp $20
	jr nc, .done
;=@near
	ld a, [wLinkCollisionFlags]
	and a
	jr z, .done
;>         wEntityState[slot] = 0               # appears
	call IncrementEntityState
	ld [hl], b
;>         wEntityTimer2[slot] = 0x30
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $30

.done
;>     return
	ret


.visible
;>@v SetEntitySpriteVariant(slot, ((hFrameCounter >> 4) ^ slot) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	xor c
;=@v
	and $01
	call SetEntitySpriteVariant
;> if hFrameCounter & 0 != 0:                   # never true
	ldh a, [hFrameCounter]
	and $00
	jr z, .move
;>     SetEntitySpriteVariant(slot, 0xFF)
	ld a, $ff
	call SetEntitySpriteVariant

.move
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> return GhiniMove(slot)                       # falls through into it

;@ def GhiniMove(slot: c)
;@ path: enemy/ghini
;@ The movement part of GhiniCommon, after its hit checks; other banks run it through GhiniMoveFar. Moves
;@ the Ghini by its speed and height speed and lets it hover; once it is out of its grave it hurts Link on
;@ touch and drifts in random directions, turned back near the edges of the room.
;@ test: skip calls bank-3 collision code
GhiniMove::
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> GhiniHover(slot)
	call GhiniHover
;> if wEntityTimer2[slot] != 0:                 # still coming out
;>     return
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jp nz, .end
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .yDir
;>     wEntityTimer[slot] = 0x20 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;>     wEntityPrivate1[slot] = wEntityTimer[slot] & 1   # new x direction
	and $01
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a

.yDir
;> if wEntityTimer1[slot] == 0:
	call GetEntityTimer1
	jr nz, .edges
;>     wEntityTimer1[slot] = 0x18 + (GetRandomByte() & 0x0F)
	call GetRandomByte
	and $0f
	add $18
	ld [hl], a
;>     wEntityPrivate2[slot] = wEntityTimer1[slot] & 1  # new y direction
	and $01
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

.edges
;> if (hFrameCounter ^ slot) & 3 != 0:          # every 4 frames
;>     return
	ldh a, [hFrameCounter]
	xor c
	and $03
	jr nz, .end
;> if hActiveEntityX < 0x28:
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityX]
	cp $28
	jr nc, .notLeft
;>     wEntityPrivate1[slot] = 0                # turn right
	ld [hl], $00
;>     wEntityTimer[slot] = 0x20
	jr .xTimer
.notLeft
;> elif hActiveEntityX >= 0x78:
	cp $78
	jr c, .yEdges
;>     wEntityPrivate1[slot] = 1                # turn left
	ld [hl], $01
.xTimer
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20

.yEdges
;> if hActiveEntityDrawY < 0x28:
	ld hl, wEntityPrivate2
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp $28
	jr nc, .notTop
;>     wEntityPrivate2[slot] = 0                # turn down
	ld [hl], $00
;>     wEntityTimer1[slot] = 0x20
	jr .yTimer
.notTop
;> elif hActiveEntityDrawY >= 0x60:
	cp $60
	jr c, .ease
;>     wEntityPrivate2[slot] = 1                # turn up
	ld [hl], $01
.yTimer
;>     wEntityTimer1[slot] = 0x20
	call GetEntityTimer1
	ld [hl], $20

.ease
;>@ex wEntitySpeedX[slot] += 1 if (mem[GhiniTargetSpeedX + wEntityPrivate1[slot]] - wEntitySpeedX[slot]) & 0x80 == 0 else -1
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, GhiniTargetSpeedX
	add hl, de
;=@ex
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	and $80
	jr nz, .decX
;=@ex
	inc [hl]
	inc [hl]
.decX
	dec [hl]
;>@ey wEntitySpeedY[slot] += 1 if (mem[GhiniTargetSpeedY + wEntityPrivate2[slot]] - wEntitySpeedY[slot]) & 0x80 == 0 else -1
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, GhiniTargetSpeedY
	add hl, de
;=@ey
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	and $80
	jr nz, .decY
;=@ey
	inc [hl]
	inc [hl]
.decY
	dec [hl]

.end
;> return
	ret


;@ def GhiniHover(slot: bc)
;@ path: enemy/ghini
;@ Every 4 frames moves the Ghini's height one pixel towards $10 (up from below the floor too).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GhiniHover::
;> if hFrameCounter & 3 != 0:
;>     return
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;> z = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
;> if z == 0x10:
;>     return
	cp $10
	jr z, .done
;> if z & 0x80:                                 # below the floor
	bit 7, a
	jr z, .above
;>     wEntityZ[slot] += 1
	inc [hl]
;>     return
	jr .done
.above
;> if z < 0x10:
	cp $10
	jr nc, .lower
;>     wEntityZ[slot] += 1
	inc [hl]
;>     return
	ret

.lower
;> wEntityZ[slot] -= 1
	dec [hl]

.done
	ret


;@ path: enemy/ghini
;@ Sprites of the Giant Ghini: 4 variants of 8 sprites (32 bytes each; y offset, x offset, tile, OAM
;@ attributes), a 32x32 ghost. 0 and 1 the two floating frames facing left, 2 and 3 the same facing
;@ right (picked by DrawGiantGhini instead of flipping). Each sprite: y offset, x offset, tile,
;@ attributes.
GiantGhiniSprites::
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $68, $00, $08, $10, $6a, $00
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $6c, $00, $08, $08, $6e, $00, $08, $10, $6a, $00
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6a, $20, $08, $00, $68, $20, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6a, $20, $08, $00, $6e, $20, $08, $08, $6c, $20, $08, $10, $64, $20

;@ def DrawGiantGhini(slot: c)
;@ path: enemy/ghini
;@ Draws the Giant Ghini: when it flies right (FlipSpriteBySpeedX_04 set the x flip), the mirrored
;@ variants 2-3 are used instead of flipping each sprite (the flip bits are dropped).
;@ test: skip writes OAM through bank-0 sprite code
DrawGiantGhini::
;> FlipSpriteBySpeedX_04(slot)
	call FlipSpriteBySpeedX_04
;> mirrored = (hActiveEntityFlipAttribute << 1) & 0x40   # +2 variants when flipped
	ldh a, [hActiveEntityFlipAttribute]
	push af
	rla
	and $40
	ldh [hMultiPurpose0], a
;> hActiveEntityFlipAttribute &= 0x0F
	pop af
	and $0f
	ldh [hActiveEntityFlipAttribute], a
;>@d DrawEntitySprites(GiantGhiniSprites + ((wEntitySpriteVariant[slot] << 5) & 0xE0) + mirrored, 8)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@d
	rla
	rla
	and $e0
	ld hl, hMultiPurpose0
	add [hl]
	ld e, a
;=@d
	ld d, b
	ld hl, GiantGhiniSprites
	add hl, de
	ld c, $08
	call DrawEntitySprites
	ret


;@ path: enemy/pairodd
;@ Sprites of the Pairodd: 8 variants of a 16x16 entity (left tile, attributes, right tile, attributes;
;@ bit 5 = x flip). 0 and 1 standing (two frames), 2 squashed, 3 not drawn from this table (PairoddHandler
;@ draws it wide from variants 6 and 7), 4 a small puff, 5 empty (tiles $FF), 6 and 7 the left and right
;@ halves of the wide frame.
PairoddSprites::
	db $70, $00, $72, $00, $72, $20, $70, $20, $74, $00, $74, $20, $00, $00, $00, $00
	db $7a, $00, $7a, $20, $ff, $00, $ff, $00, $76, $00, $78, $00, $78, $20, $76, $20

;@ def PairoddHandler(slot: c)
;@ path: enemy/pairodd
;@ Entity $57: the Pairodd, which vanishes when Link comes near and reappears on the opposite side of
;@ the room (mirrored through its centre), then shoots a fireball at him.
;@ test: skip dispatches through a jump table
PairoddHandler::
;> if hActiveEntitySpriteVariant == 3:          # the wide frame: two 16x16 halves
	ldh a, [hActiveEntitySpriteVariant]
	cp $03
	jr nz, .normal
;>     hActiveEntityX -= 8
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hActiveEntityX], a
;>     hActiveEntitySpriteVariant = 6
	ld a, $06
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(slot, PairoddSprites)
	ld de, PairoddSprites
	call DrawEntity16x16
;>     hActiveEntityX += 0x10
	ldh a, [hActiveEntityX]
	add $10
	ldh [hActiveEntityX], a
;>     hActiveEntitySpriteVariant = 7
	ld a, $07
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(slot, PairoddSprites)
	ld de, PairoddSprites
	call DrawEntity16x16
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
	jr .run
;> else:
.normal
;>     DrawEntity16x16(slot, PairoddSprites)
	ld de, PairoddSprites
	call DrawEntity16x16

.run
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> return PairoddStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/pairodd
;@ States of the Pairodd.
PairoddStates::
	dw PairoddIdle
	dw PairoddVanish
	dw PairoddAppear

;@ def PairoddIdle(slot: c)
;@ path: enemy/pairodd
;@ State 0: stands; when its timer reaches $18 it shoots a fireball at Link. Once the timer is below
;@ $18, it vanishes ($20 frames, jingle $3C) as soon as Link comes within 32 pixels, unless it is
;@ flashing from a hit.
;@ test: skip spawns entities
PairoddIdle::
;> EntityCheckHits(slot)
	call EntityCheckHits
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0x18:
	cp $18
	jr nz, .checkTimer
;>     PairoddShoot(slot)
	call PairoddShoot
;>     return
	and a
.checkTimer
;> if t > 0x18:
;>     return
	jr nc, .done
;>@near if (GetEntityXDistanceToLink_04(slot) + 0x20) & 0xFF < 0x40 and (GetEntityYDistanceToLink_04(slot) + 0x20) & 0xFF < 0x40 and wEntityFlashTimer[slot] == 0:
	call GetEntityXDistanceToLink_04
	add $20
	cp $40
	jr nc, .done
;=@near
	call GetEntityYDistanceToLink_04
	add $20
	cp $40
	jr nc, .done
;=@near
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     hJingle = 0x3C
	ld a, $3c
	ldh [hJingle], a

.done
;> return
	ret


;@ path: enemy/pairodd
;@ Sprite variant while the Pairodd vanishes, by (timer / 8) & 3 for timer $17 down to 1: wide puff
;@ (4, 3, 2).
PairoddVanishFrames::
	db $04, $03, $02

;@ def PairoddVanish(slot: c)
;@ path: enemy/pairodd
;@ State 1: for the first 8 frames it can still be hit; then it shrinks away and, when the timer runs
;@ out, moves to the point mirrored through the room centre ($50, $48), hidden for $40 frames.
;@ test: skip calls bank-3 collision code
PairoddVanish::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t >= 0x18:
;>     return EntityCheckHits(slot)
	cp $18
	jp nc, EntityCheckHits
;> if t == 0:
	and a
	jr nz, .anim
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpriteVariant(slot, 0xFF)             # hidden
	ld a, $ff
	call SetEntitySpriteVariant
;>@y     wEntityY[slot] = (0x48 - (wEntityY[slot] - 0x48)) & 0xFF
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, a
	ld a, $48
;=@y
	sub e
	ld [hl], a
;>@x     wEntityX[slot] = (0x50 - (wEntityX[slot] - 0x50)) & 0xFF
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $50
	ld e, a
	ld a, $50
;=@x
	sub e
	ld [hl], a
;>     return
	ret


.anim
;>@v return SetEntitySpriteVariant(slot, mem[PairoddVanishFrames + ((t >> 3) & 3)])
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
;=@v
	ld hl, PairoddVanishFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ path: enemy/pairodd
;@ Sprite variant while the Pairodd reappears, by (timer / 8) & 3 for timer $17 down to 1 (2, 3, 4).
PairoddAppearFrames::
	db $02, $03, $04

;@ def PairoddAppear(slot: c)
;@ path: enemy/pairodd
;@ State 2: stays hidden while the timer is at $18 or more, then reappears (PairoddAppearAnimate); at
;@ the end back to state 0 with a timer of $30 (it shoots at $18).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
PairoddAppear::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t >= 0x18:
;>     return
	cp $18
	jr nc, PairoddAppearAnimate.done
;> if t != 0:
;>     return PairoddAppearAnimate(slot, t)
	and a
	jr nz, PairoddAppearAnimate
;> wEntityTimer[slot] = 0x30
	ld [hl], $30
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
	ret


;@ def PairoddShoot(slot: c)
;@ path: enemy/pairodd
;@ Shoots a Pairodd fireball (entity $58) from the Pairodd at Link, speed $18.
;@ test: skip spawns an entity
PairoddShoot::
;> new, full = SpawnEntity(slot, 0x58)
	ld a, $58
	call SpawnEntity
;> if full:
;>     return
	jr c, .done
;> wEntityX[new] = hMultiPurpose0
	ld hl, wEntityX
	add hl, de
	ldh a, [hMultiPurpose0]
	ld [hl], a
;> wEntityY[new] = hMultiPurpose1
	ld hl, wEntityY
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hl], a
;> SetEntitySpeedTowardsLink(0x18, slot=new)
	push bc
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
	pop bc

.done
;> return
	ret


;@ def PairoddAppearAnimate(slot: c, t: a)
;@ path: enemy/pairodd
;@ Sprite variant of the reappearing Pairodd from PairoddAppearFrames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
PairoddAppearAnimate::
;>@v SetEntitySpriteVariant(slot, mem[PairoddAppearFrames + ((t >> 3) & 3)])
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
;=@v
	ld hl, PairoddAppearFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant

.done
;> return
	ret


;@ path: enemy/pairodd
;@ Sprites of the Pairodd's fireball: 2 variants of a 16x16 entity (tiles $7C and $7E, right half
;@ mirrored).
PairoddProjectileSprites::
	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

;@ def PairoddProjectileHandler(slot: c)
;@ path: enemy/pairodd
;@ Entity $58: the Pairodd's fireball. Flies straight, hurts Link on touch, can be hit, and bursts when
;@ it hits a wall.
;@ test: skip calls bank-3 collision code
PairoddProjectileHandler::
;> DrawEntity16x16(slot, PairoddProjectileSprites)
	ld de, PairoddProjectileSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckObjectCollision(slot)
	call EntityCheckObjectCollision
;> EntityCheckTouchLink(slot)
	call EntityCheckTouchLink
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> if wEntityCollisions[slot] != 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     DespawnEntity_04(slot)
	call DespawnEntity_04
;>     PuffAtEntity_04(slot)                       # puff where it burst
	call PuffAtEntity_04

.done
;> return
	ret


;@ path: minigame/fishing
;@ Sprites of the fisherman in his house: 3 frames of 4 sprites in a row (16 bytes each; y offset, x
;@ offset, tile, attributes; x offsets -16, -8, 0, 8): +$00 and +$10 fishing (two frames), +$20
;@ talking. Drawn by PondFisherman.
PondFishermanSprites::
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $7c, $00, $00, $f8, $7e, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $74, $00, $00, $08, $76, $00
;@ path: minigame/fishing
;@ The item that drops to Link (16x16: tiles $9A / $9C, palette bit 4).
PondFishermanPrizeSprite::
	db $9a, $10, $9c, $10

;@ def PondFisherman(slot: c)
;@ path: minigame/fishing
;@ Entity $54: the fishing game. In the side-view pond (hIsSideScrolling) the same type plays the rod,
;@ the lure and the fish (FishingPond). In the fisherman's house it is the fisherman, who offers a go
;@ for 10 rupees. With wEntityPrivate4 set it is instead an item dropping down to Link, who then holds
;@ it up (end of a trading scene).
;@ test: skip dispatches through jump tables
PondFisherman::
;> if wEntityPrivate4[slot] != 0:               # an item dropping to Link
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr z, .fisherman
;>     hActiveEntityDrawY += 4
	ldh a, [hActiveEntityDrawY]
	add $04
	ldh [hActiveEntityDrawY], a
;>     DrawEntity16x16(slot, PondFishermanPrizeSprite)
	ld de, PondFishermanPrizeSprite
	call DrawEntity16x16
;>     UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;>     AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;>     wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;>     if wEntityZ[slot] & 0x80:                # landed in Link's hands
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .falling
;>         DespawnEntity_04(slot)
	call DespawnEntity_04
;>         wTradeSceneState = 0
	xor a
	ld [wTradeSceneState], a
;>         wLinkFrozen = 0
	ld [wLinkFrozen], a
;>         return SpawnHeldItemEntity()         # Link holds it up
	jp SpawnHeldItemEntity


.falling
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     return
	ret


.fisherman
;> if hIsSideScrolling != 0:
;>     return FishingPond(slot)
	ldh a, [hIsSideScrolling]
	and a
	jp nz, FishingPond
;> wEntityPhysicsFlags[slot] = 0x84
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $84
;> hMultiPurposeG = wEntityPrivate5[slot]  # ($FFE8)
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeG], a
;> if wDialogState != 0:
;>     frame = PondFishermanSprites + 0x20          # talking
	ld a, [wDialogState]
	and a
	ld hl, PondFishermanSprites + $20
	jr nz, .draw
;> else:
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
;>     frame = PondFishermanSprites if (wEntityPrivateCounter[slot] - 1) & 0x30 == 0 else PondFishermanSprites + 0x10
	ld hl, PondFishermanSprites
	and $30
	jr z, .draw
	ld hl, PondFishermanSprites + $10

.draw
;> DrawEntitySprites(frame, 4)
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
;> BlockLinkAtEntity_04(slot)
	call BlockLinkAtEntity_04
;> return PondFishermanStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: minigame/fishing
;@ States of the fisherman in his house.
PondFishermanStates::
	dw PondFishermanWaitForTalk
	dw PondFishermanOffer
	dw PondFishermanGoFishing

;@ def PondFishermanWaitForTalk(slot: c)
;@ path: minigame/fishing
;@ State 0: when Link talks to him (A in front of him), dialogue $45 (the offer).
;@ test: skip opens a dialogue
PondFishermanWaitForTalk::
;> if CanTalkToEntity_04(slot):
	call CanTalkToEntity_04
	jr nc, .done
;>     OpenDialog(0x45)
	ld a, $45
	call OpenDialog
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def PondFishermanOffer(slot: c)
;@ path: minigame/fishing
;@ State 1, after the offer: "no" gives dialogue $46; "yes" with at least 10 rupees takes them
;@ (dialogue $47) and goes on to state 2; too few rupees gives dialogue $4E.
;@ test: skip opens a dialogue
PondFishermanOffer::
;> if wDialogState != 0:
;>     return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer != 0:                       # no
	ld a, [wDialogAnswer]
	and a
	jr z, .yes
;>     wEntityState[slot] = 0
	ld [hl], b
;>     return OpenDialog(0x46)
	ld a, $46
	jp OpenDialog


.yes
;> if wRupeeCount >= 0x10:                      # 10 rupees (BCD)
	ld a, [wRupeeCountLow]
	sub $10
	ld a, [wRupeeCountHigh]
	sbc $00
	jr c, .poor
;>     wSubtractRupeeBufferLow = 0x0A           # pay 10
	ld a, $0a
	ld [wSubtractRupeeBufferLow], a
;>     OpenDialog(0x47)
	ld a, $47
	call OpenDialog

.done
;>     return
	ret


.poor
;> wEntityState[slot] = 0
	ld [hl], b
;> OpenDialog(0x4E)
	ld a, $4e
	call OpenDialog
	ret


;@ def PondFishermanGoFishing(slot: c)
;@ path: minigame/fishing
;@ State 2: when the dialogue is closed, clears the entities and warps to the fishing pond.
;@ test: skip starts a warp
PondFishermanGoFishing::
;> if wDialogState == 0:
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     ClearAllEntitySlots()                              # all entity slots free
	call ClearAllEntitySlots
;>     LeaveFishingGame()
	call LeaveFishingGame

.done
;> return
	ret


;@ path: minigame/fishing
;@ The fishing rod beside Link: 10 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes); drawn by FishingRod at Link's position plus FishingRodOffsetX/Y.
FishingRodSprites::
	db $58, $00, $5a, $00, $56, $20, $ff, $00, $5c, $00, $5e, $00, $58, $00, $5a, $00
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5c, $00, $5e, $00, $56, $00, $ff, $00
	db $5e, $20, $5c, $20, $58, $00, $5a, $00

;@ path: minigame/fishing
;@ Link's pose (hLinkAnimationState) for each rod variant. 10 bytes.
FishingLinkPoses::
	db $06, $16, $10, $10, $38, $38, $39, $39, $16, $38

;@ path: minigame/fishing
;@ X offset of the rod from Link for each rod variant (signed pixels). 10 bytes.
FishingRodOffsetX::
	db $f6, $00, $f1, $f0, $f0, $f0, $f0, $fe, $04, $f2

;@ path: minigame/fishing
;@ Y offset of the rod from Link for each rod variant. 10 bytes.
FishingRodOffsetY::
	db $00, $f0, $fa, $00, $00, $f8, $f8, $f8, $f2, $fe

;@ path: minigame/fishing
;@ X offset of the lure hanging from the rod tip, by rod variant (0-8). 9 bytes.
FishingLureOffsetX::
	db $e8, $00, $e0, $e8, $00, $00, $00, $00, $14

;@ path: minigame/fishing
;@ Y offset of the lure hanging from the rod tip, by rod variant (0-8). 9 bytes.
FishingLureOffsetY::
	db $10, $e0, $f8, $10, $00, $00, $00, $00, $f0

;@ def FishingPond(slot: c)
;@ path: minigame/fishing
;@ The fishing pond (side view): Link is held still; wEntityPrivate1 picks the piece: 0 the rod, 1 the
;@ lure, 2 a small fish, 3 a big fish.
;@ test: skip dispatches through a jump table
FishingPond::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> return FishingPondParts[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: minigame/fishing
;@ Pieces of the fishing pond, indexed by wEntityPrivate1, followed by the five fish placed at the
;@ start: for fish n = 1-5 (read at the table + n - 1): x, y, direction (0 right, 1 left), kind (2 small, 3
;@ big), first timer. Fish 5 (the first to be spawned, so it lands in slot $0F) is a big one and carries
;@ the piece of heart.
FishingPondParts::
	dw FishingRod
	dw FishingLure
	dw SmallFish
	dw BigFish

FishSpawnX:
	db $18, $58, $60, $18, $88
FishSpawnY:
	db $40, $4c, $34, $68, $50
FishSpawnDirection:
	db $01, $00, $00, $01, $00
FishSpawnKind:
	db $02, $02, $02, $03, $03
FishSpawnTimer:
	db $00, $3e, $1e, $10, $30

;@ def FishingRod(slot: c)
;@ path: minigame/fishing
;@ Piece 0, Link's rod (the fisherman entity of the pond room). On its first frame it places the five
;@ fish; then it draws the rod and Link's matching pose and runs the casting / result states.
;@ test: skip spawns entities and dispatches through a jump table
FishingRod::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityPrivate2[slot] == 0:               # first frame
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .rod
;>     wEntityPrivate2[slot] = 1
	inc [hl]
;>@loop     for n in range(5, 0, -1):
	push bc
	ld c, $05

.spawnFish
;>         fish, _ = SpawnEntity(slot, 0x54)             # (no check for a full entity table)
	ld a, $54
	call SpawnEntity
;>         wEntityX[fish] = mem[FishSpawnX + (n - 1)]
	ld hl, FishSpawnX - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[fish] = mem[FishSpawnY + (n - 1)]
	ld hl, FishSpawnY - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityDirection[fish] = mem[FishSpawnDirection + (n - 1)]
	ld hl, FishSpawnDirection - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;>         wEntityPrivate1[fish] = mem[FishSpawnKind + (n - 1)]
	ld hl, FishSpawnKind - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], a
;>         wEntityTimer[fish] = mem[FishSpawnTimer + (n - 1)]
	ld hl, FishSpawnTimer - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityTimer
	add hl, de
	ld [hl], a
;=@loop
	dec c
	jr nz, .spawnFish
;>     wSceneVar4 = 0                           # ($D004) bites so far
	xor a
	ld [wSceneVar4], a
	pop bc
;>     return
	ret


.rod
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
;> hLinkAnimationState = mem[FishingLinkPoses + v]
	ld hl, FishingLinkPoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;> hActiveEntityX = hLinkX + mem[FishingRodOffsetX + v]
	ld hl, FishingRodOffsetX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = hLinkY + mem[FishingRodOffsetY + v]
	ld hl, FishingRodOffsetY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(slot, FishingRodSprites)
	ld de, FishingRodSprites
	call DrawEntity16x16
;> return FishingRodStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: minigame/fishing
;@ States of the rod.
FishingRodStates::
	dw FishingRodWait
	dw FishingRodCast
	dw FishingRodIdle
	dw FishingRodAfterCatch
	dw FishingRodLeave
	dw FishingRodNoMoreFish
	dw FishingRodDone

;@ def FishingRodWait(slot: c)
;@ path: minigame/fishing
;@ State 0: the lure hangs from the rod tip; A or B (with no dialogue open) starts a cast of $23 frames.
;@ test: skip writes OAM through bank-0 sprite code
FishingRodWait::
;>@if if wDialogState == 0 and hJoypadPressed & 0x30:
	ld a, [wDialogState]
	and a
	jr nz, .draw
;=@if
	ldh a, [hJoypadPressed]
	and $30
	jr z, .draw
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x23
	call GetEntityTimer
	ld [hl], $23
;>     wSceneVar2 = 0                           # ($D002) no fish on the hook
	xor a
	ld [wSceneVar2], a

.draw
;> DrawFishingLureOnRod(9)
	ld a, $09
	call DrawFishingLureOnRod
	ret


;@ path: minigame/fishing
;@ Rod variant during the cast, by step (timer / 4: 8 down to 0), and 9 = rod at rest (variant 0).
;@ 10 bytes.
FishingCastFrames::
	db $01, $08, $08, $08, $08, $08, $01, $02, $03, $00

;@ def FishingRodCast(slot: c)
;@ path: minigame/fishing
;@ State 1: the casting swing; at its end the lure (piece 1) flies out from (x $78, y $18) to the left
;@ (speed -$1E, -$06).
;@ test: skip spawns an entity
FishingRodCast::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;>@sw if t != 0:
;>@sw     return DrawFishingLureOnRod((t >> 2) & 0x1F)
	jr nz, .swing
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntitySpriteVariant[0] = 2                  # the rod (in slot 0) points forward
	ld a, $02
	ld [wEntitySpriteVariant], a
;> lure, _ = SpawnEntity(slot, 0x54)                     # (no check for a full entity table)
	ld a, $54
	call SpawnEntity
;> wEntityX[lure] = 0x78
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
;> wEntityY[lure] = 0x18
	ld hl, wEntityY
	add hl, de
	ld [hl], $18
;> wEntitySpeedX[lure] = 0xE2
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $e2
;> wEntitySpeedY[lure] = 0xFA
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fa
;> wEntityPrivate1[lure] = 1                    # the lure
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntityTimer[lure] = 0x14
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $14
;> hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
	ret


.swing
;=@sw
	rra
	rra
	and $1f

;@ def DrawFishingLureOnRod(step: a)
;@ path: minigame/fishing
;@ Sets the rod's variant (slot 0) to FishingCastFrames[step] and draws the lure hanging from its tip.
;@ test: skip writes OAM through bank-0 sprite code
DrawFishingLureOnRod::
;> v = mem[FishingCastFrames + step]
	ld e, a
	ld d, b
	ld hl, FishingCastFrames
	add hl, de
	ld a, [hl]
;> wEntitySpriteVariant[0] = v
	ld [wEntitySpriteVariant], a
;>@x hActiveEntityX = hLinkX + mem[FishingLureOffsetX + v]
	ld e, a
	ld d, b
	ld hl, FishingLureOffsetX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
;=@x
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = hLinkY + mem[FishingLureOffsetY + v]
	ld hl, FishingLureOffsetY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(FishingLureSprites)
	ld de, FishingLureSprites
	call DrawEntity16x16
;> return LoadEntityPosition(slot)
	jp LoadEntityPosition


;@ def FishingRodIdle(slot: c)
;@ path: minigame/fishing
;@ State 2: nothing to do while the lure is out (the lure and fish drive the game).
;@ test: slot = rand(0, 15)
FishingRodIdle::
;> return
	ret


;@ def FishingRodAfterCatch(slot: c)
;@ path: minigame/fishing
;@ State 3, after a catch or a lost fish (the lure or fish set it and opened a dialogue asking to fish
;@ again). "No": dialogue $46, leave (state 4). "Yes": after 5 bites in this visit dialogue $4B and state
;@ 5; with 10 rupees pay them, dialogue $47, cast again (state 0); else dialogue $4E and leave.
;@ test: skip opens a dialogue
FishingRodAfterCatch::
;> if wDialogState != 0:
;>     return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> if wDialogAnswer != 0:                       # no
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
;>@n1     OpenDialog(0x46)
;>@n2     wEntityState[slot] += 1                  # leave (state 4)
;>     return
;> if wSceneVar4 >= 5:                          # the pond is fished out
	ld a, [wSceneVar4]
	cp $05
	jr c, .pay
;>     OpenDialog(0x4B)
	ld a, $4b
	call OpenDialog
;>     wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;>     return
	ret


.pay
;> if wRupeeCount < 0x10:                       # 10 rupees (BCD)
	ld a, [wRupeeCountLow]
	sub $10
	ld a, [wRupeeCountHigh]
	sbc $00
	jr c, .poor
;>@p1     OpenDialog(0x4E)
;>@p2     return IncrementEntityState(slot)        # leave (state 4)
;> wSubtractRupeeBufferLow = 0x0A
	ld a, $0a
	ld [wSubtractRupeeBufferLow], a
;> OpenDialog(0x47)
	ld a, $47
	call OpenDialog
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> return
	ret


.no
;=@n1
	ld a, $46
	call OpenDialog
;=@n2
	call IncrementEntityState

.done
	ret


.poor
;=@p1
	ld a, $4e
	call OpenDialog
;=@p2
	jp IncrementEntityState


;@ def FishingRodLeave(slot: c)
;@ path: minigame/fishing
;@ State 4: when the dialogue is closed, clears the entities and warps back.
;@ test: skip starts a warp
FishingRodLeave::
;> if wDialogState == 0:
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     ClearAllEntitySlots()
	call ClearAllEntitySlots
;>     LeaveFishingGame()
	call LeaveFishingGame

.done
;> return
	ret


;@ def FishingRodNoMoreFish(slot: c)
;@ path: minigame/fishing
;@ State 5, after "no more fish": goes on to leave (state 4) with dialogue $4C for the first answer,
;@ $46 for the other.
;@ test: skip opens a dialogue
FishingRodNoMoreFish::
;> if wDialogState != 0:
;>     return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .other
;>     OpenDialog(0x4C)
	ld a, $4c
	call OpenDialog
;>     return
	ret

;> else:
.other
;>     OpenDialog(0x46)
	ld a, $46
	call OpenDialog

.done
	ret


;@ def FishingRodDone(slot: c)
;@ path: minigame/fishing
;@ State 6: nothing.
;@ test: slot = rand(0, 15)
FishingRodDone::
;> return
	ret


;@ path: minigame/fishing
;@ Sprites of the lure: 5 variants of a 16x16 entity (left tile, attributes, right tile, attributes;
;@ bits 5 / 6 = x / y flip): 0 and 1 hanging (two frames), 2 sinking, 3 and 4 the same turned over.
FishingLureSprites::
	db $50, $00, $54, $00, $50, $00, $52, $00, $50, $40, $54, $00, $54, $40, $50, $40
	db $54, $60, $50, $60

;@ def FishingLure(slot: c)
;@ path: minigame/fishing
;@ Piece 1, the lure. It publishes its slot (wSceneVar3) and position (wEntityWorkRAM = x,
;@ wSceneVar1 = y) for the fish.
;@ test: skip dispatches through a jump table
FishingLure::
;> wSceneVar3 = slot                            # ($D003)
	ld a, c
	ld [wSceneVar3], a
;> DrawEntity16x16(slot, FishingLureSprites)
	ld de, FishingLureSprites
	call DrawEntity16x16
;> wEntityWorkRAM = hActiveEntityX              # ($D000)
	ldh a, [hActiveEntityX]
	ld [wEntityWorkRAM], a
;> wSceneVar1 = hActiveEntityY                  # ($D001)
	ldh a, [hActiveEntityY]
	ld [wSceneVar1], a
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> return FishingLureStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: minigame/fishing
;@ States of the lure.
FishingLureStates::
	dw FishingLureFly
	dw FishingLureInWater

;@ def FishingLureFly(slot: c)
;@ path: minigame/fishing
;@ State 0: the cast lure flies to the left in an arc. Holding Right brakes it (shorter cast). It
;@ splashes into the water at y $2A.
;@ test: skip spawns a transient effect
FishingLureFly::
;> AddEntitySpeedToPosX_04(slot)
	call AddEntitySpeedToPosX_04
;> AddEntitySpeedToPosY_04(slot)
	call AddEntitySpeedToPosY_04
;>@brake if hJoypadHeld & 1 and hFrameCounter & 1 == 0 and wEntitySpeedX[slot] != 0:   # Right held
	ldh a, [hJoypadHeld]
	and $01
	jr z, .noBrake
;=@brake
	ldh a, [hFrameCounter]
	and $01
	jr nz, .noBrake
;=@brake
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .noBrake
;>     wEntitySpeedX[slot] += 1                 # (the speed is negative)
	inc [hl]
;>     fall = True
	jr .fall
;> else:
.noBrake
;>     fall = wEntityTimer[slot] == 0           # after the first $14 frames
	call GetEntityTimer
	jr nz, .water

.fall
;> if fall:
;>@g     if hFrameCounter & 1 == 0 and wEntitySpeedY[slot] != 0x20:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .slow
;=@g
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $20
	jr z, .slow
;>         wEntitySpeedY[slot] += 1             # gravity
	inc [hl]

.slow
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	cp $03
	ld [hl], a
;>     if wEntityPrivateCounter[slot] == 3:     # every 3 frames
	jr nz, .water
;>         wEntityPrivateCounter[slot] = 0
	xor a
	ld [hl], a
;>         if wEntitySpeedX[slot] != 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .water
;>             wEntitySpeedX[slot] += 1         # air drag
	inc [hl]

.water
;> if wEntityY[slot] >= 0x2A:                   # reached the water
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $2a
	jr c, FishingSplash.done
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     FishingSplash()                          # (falls through)

;@ def FishingSplash()
;@ path: minigame/fishing
;@ A splash (transient effect 1) at the entity, with jingle $0E.
;@ test: skip spawns a transient effect
FishingSplash::
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> AddTransientVfx(1)
	ld a, $01
	call AddTransientVfx
;> hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a

.done
;> return
	ret


;@ def FishingLureInWater(slot: c)
;@ path: minigame/fishing
;@ State 1: the lure sinks slowly (its speed easing to 4 down and 0 sideways, every 8 frames). A or B
;@ reels it in towards the rod (speed 4, rod shown reeling); back at the rod with nothing on it the cast
;@ ends (the rod's state 3 and dialogue $48) and any biting fish lets go. Right or Up jerks the lure
;@ up (speed -6) once it is deep enough (y $30), at most every $50 frames. It lies on the pond floor
;@ (walls are checked downwards only).
;@ test: skip opens a dialogue and calls bank-3 collision code
FishingLureInWater::
;> wEntitySpriteVariant[0] = 0                  # the rod (slot 0): at rest ...
	ld hl, wEntitySpriteVariant
	ld [hl], $00
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr z, .noReel
;>     wEntitySpriteVariant[0] = 4              # ... reeling
	ld hl, wEntitySpriteVariant
	ld [hl], $04

.noReel
;> if wEntityTimer1[slot] != 0:
	call GetEntityTimer1
	jr z, .anim
;>     wEntitySpriteVariant[0] = 5              # ... jerked up
	ld hl, wEntitySpriteVariant
	ld [hl], $05

.anim
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .buttons
;>@sy     if wEntitySpeedY[slot] != 4:              # ease the sinking speed to 4
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sub $04
	jr z, .easeX
;=@sy
	and $80
	jr z, .decY
	inc [hl]
	inc [hl]
.decY
	dec [hl]
;>         wEntitySpeedY[slot] += 1 if wEntitySpeedY[slot] < 4 else -1

.easeX
;>@sx     if wEntitySpeedX[slot] != 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .buttons
;=@sx
	and $80
	jr z, .decX
	inc [hl]
	inc [hl]
.decX
	dec [hl]
;>         wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1

.buttons
;> if hJoypadPressed & 0x30:                    # A or B: reel in
	ldh a, [hJoypadPressed]
	and $30
	jr z, .jerk
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     savedX = hLinkX
	ldh a, [hLinkX]
	push af
;>     hLinkX -= 0x17                           # the rod tip
	sub $17
	ldh [hLinkX], a
;>     SetEntitySpeedTowardsLink(slot, 4)
	ld a, $04
	call SetEntitySpeedTowardsLink
;>     hLinkX = savedX
	pop af
	ldh [hLinkX], a
;>@back     if hActiveEntityDrawY < 0x25 and hActiveEntityX >= 0x70:   # back at the rod
	ldh a, [hActiveEntityDrawY]
	cp $25
	jr nc, .reelAnim
;=@back
	ldh a, [hActiveEntityX]
	cp $70
	jr c, .reelAnim
;>         wEntityState[0] = 3                  # the rod: ask to fish again
	ld hl, wEntityState
	ld [hl], $03
;>         OpenDialog(0x48)
	ld a, $48
	call OpenDialog
;>         DespawnEntity_04(slot)
	call DespawnEntity_04
;>@loop         for fish in range(15, -1, -1):
	ld e, $0f
	ld d, b

.letGo
;>@if             if wEntityStatus[fish] != 0 and wEntityPrivate1[fish] >= 2 and wEntityState[fish] >= 2:   # biting
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .nextFish
;=@if
	ld hl, wEntityPrivate1
	add hl, de
	ld a, [hl]
	cp $02
	jr c, .nextFish
;=@if
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $02
	jr c, .nextFish
;>                 wEntityState[fish] &= 1      # back to idle / swimming
	and $01
	ld [hl], a

.nextFish
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .letGo

.reelAnim
;>@r     return SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)   # (then the floor check below)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@r
	call SetEntitySpriteVariant
	jr .floor

.jerk
;>@j if hJoypadPressed & 0x05 and hActiveEntityDrawY >= 0x30 and wEntityTimer2[slot] == 0:   # Right / Up
	ldh a, [hJoypadPressed]
	and $05
	jr z, .floor
;=@j
	ldh a, [hActiveEntityDrawY]
	cp $30
	jr c, .floor
;=@j
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .floor
;>     wEntitySpeedY[slot] = 0xFA
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fa
;>     wEntityTimer2[slot] = 0x50
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $50
;>     wEntityTimer1[slot] = 0x10
	call GetEntityTimer1
	ld [hl], $10

.floor
;>@mv if hActiveEntityX != wEntityX[slot] or hActiveEntityY != wEntityY[slot]:   # it moved
	ldh a, [hActiveEntityX]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
	jr nz, .check
;=@mv
	ldh a, [hActiveEntityY]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jr z, .result
.check
;>     speedY = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
	push hl
;>     if speedY & 0x80:
	and $80
	jr z, .walls
;>         wEntitySpeedY[slot] = 0              # check downwards only
	ld [hl], b
.walls
;>     EntityCheckWalls(slot)
	call EntityCheckWalls
;>     wEntitySpeedY[slot] = speedY
	pop hl
	pop af
	ld [hl], a

.result
;> if wEntityCollisions[slot] != 0:             # lying on the floor
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .sinking
;>     SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant

.sinking
;> if not wEntitySpeedY[slot] & 0x80:           # sinking
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	rla
	jr c, .done
;>     SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant

.done
;> return
	ret



;@ path: minigame/fishing
;@ Sprites of the small fish: 8 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes; attribute $20 = x flip). 0 and 1 swim facing left (two tail frames), 2 and 3 the same with
;@ the mouth open; 4-7 are the same four facing right.
SmallFishSprites::
	db $4c, $00, $4a, $00, $4c, $00, $4e, $00, $48, $00, $4a, $00, $48, $00, $4e, $00
	db $4a, $20, $4c, $20, $4e, $20, $4c, $20, $4a, $20, $48, $20, $4e, $20, $48, $20

;@ def SmallFish(slot: c)
;@ path: minigame/fishing
;@ Piece 2, a small fish: drawn facing its direction, then the shared fish behaviour.
;@ test: skip dispatches through a jump table
SmallFish::
;> if wEntityDirection[slot] == 0:              # facing right: the flipped variants
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw
;>     hActiveEntitySpriteVariant += 4
	ldh a, [hActiveEntitySpriteVariant]
	add $04
	ldh [hActiveEntitySpriteVariant], a

.draw
;> DrawEntity16x16(slot, SmallFishSprites)
	ld de, SmallFishSprites
	call DrawEntity16x16
;> PondFishCommon(slot)                             # (falls through)

;@ def PondFishCommon(slot: c)
;@ path: minigame/fishing
;@ What small and big fish share: move with their speed, then run their state.
;@ test: skip dispatches through a jump table
PondFishCommon::
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> return PondFishStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: minigame/fishing
;@ States of a fish.
PondFishStates::
	dw PondFishIdle
	dw PondFishSwim
	dw PondFishBite
	dw PondFishTakeLure
	dw PondFishHooked
	dw PondFishCaught

;@ def PondFishIdle(slot: bc)
;@ path: minigame/fishing
;@ State 0: the fish drifts to a stop; when its timer runs out it turns round and swims for $30
;@ frames (state 1). A lure in front of it makes it bite. Big fish go to BigFishIdle.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
PondFishIdle::
;> PondFishCheckLure(slot)
	call PondFishCheckLure
;> if wEntityPrivate1[slot] == 3:               # a big fish
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
;>     return BigFishIdle(slot)
	jp z, BigFishIdle
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .drift
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityDirection[slot] ^= 1              # turn round
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
;>     wEntityState[slot] += 1                  # swim
	call IncrementEntityState

.drift
;>@if if hFrameCounter & 3 == 0 and wEntitySpeedX[slot] != 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .depth
;=@if
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .depth
;>@e     wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1   # slow down
	and $80
	jr z, .slower
	inc [hl]
	inc [hl]
.slower
;=@e
	dec [hl]

.depth
;> return PondFishSwim.depth(slot)                  # stay under the surface
	jr PondFishSwim.depth

;@ path: minigame/fishing
;@ Top swimming speed of a small fish by direction: $10 right, -$10 left. 2 bytes.
SmallFishSwimSpeed::
	db $10, $f0

;@ def PondFishSwim(slot: bc)
;@ path: minigame/fishing
;@ State 1: the fish speeds up to its swimming speed; after its timer it drifts again for $50 frames
;@ (state 0). A lure in front of it makes it bite. Fish never rise above y $34. Big fish go to
;@ BigFishSwim.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
PondFishSwim::
;> PondFishCheckLure(slot)
	call PondFishCheckLure
;> if wEntityPrivate1[slot] == 3:               # a big fish
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
;>     return BigFishSwim(slot)
	jp z, BigFishSwim
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .swim
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.swim
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .depth
;>@d     diff = wEntitySpeedX[slot] - mem[SmallFishSwimSpeed + wEntityDirection[slot]]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, wEntityDirection
	add hl, bc
;=@d
	ld e, [hl]
	ld d, $00
	ld hl, SmallFishSwimSpeed
	add hl, de
	sub [hl]
	pop hl
;>     if diff != 0:
	and a
	jr z, .depth
;>@e         wEntitySpeedX[slot] += 1 if diff & 0x80 else -1
	and $80
	jr z, .slower
	inc [hl]
	inc [hl]
.slower
;=@e
	dec [hl]

.depth
;> if wEntityY[slot] < 0x34:                    # too close to the surface
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $34
	jr nc, .done
;>     wEntityY[slot] += 1
	inc [hl]
;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b

.done
;> return
	ret


;@ path: minigame/fishing
;@ Where a biting fish aims, relative to the lure's x, by direction: -$0E facing right, +$14 facing
;@ left (so it stays on its own side). 2 bytes.
PondFishBiteOffsetX::
	db $f2, $14

;@ def PondFishBite(slot: bc)
;@ path: minigame/fishing
;@ State 2: the fish swims up beside the lure (speed 4) and nibbles at it until its timer runs out,
;@ then rushes at it (state 3).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
PondFishBite::
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .approach
;>     wEntityState[slot] += 1
	call IncrementEntityState

.approach
;> saved = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;>@x hLinkX = wEntityWorkRAM + mem[PondFishBiteOffsetX + wEntityDirection[slot]]   # the lure's x
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, PondFishBiteOffsetX
	add hl, de
;=@x
	ld a, [wEntityWorkRAM]
	add [hl]
	ldh [hLinkX], a
;> hLinkY = wSceneVar1                          # the lure's y
	ld a, [wSceneVar1]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(slot, 4)
	ld a, $04
	call SetEntitySpeedTowardsLink
;> hLinkX = saved[0]
;> hLinkY = saved[1]
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
;> return UpdateEntityPosWithSpeed_04(slot)
	jp UpdateEntityPosWithSpeed_04


;@ def PondFishTakeLure(slot: c)
;@ path: minigame/fishing
;@ State 3: mouth open, the fish rushes at the lure (speed $10); when it is within 8 pixels it swallows
;@ it: it stops, the lure entity is removed and the fish is hooked (state 4).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
PondFishTakeLure::
;>@v SetEntitySpriteVariant(slot, 2 + ((hFrameCounter >> 2) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	add $02
;=@v
	call SetEntitySpriteVariant
;> saved = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;> hLinkX = wEntityWorkRAM + 4                  # the lure
	ld a, [wEntityWorkRAM]
	add $04
	ldh [hLinkX], a
;> hLinkY = wSceneVar1
	ld a, [wSceneVar1]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(slot, 0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;> hLinkX = saved[0]
;> hLinkY = saved[1]
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> if abs(wEntityWorkRAM - hActiveEntityX) < 8:   # at the lure
	ld a, [wEntityWorkRAM]
	ld hl, hActiveEntityX
	sub [hl]
	add $08
	cp $10
	jr nc, .done
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityStatus[wSceneVar3] = 0            # the lure is gone
	ld a, [wSceneVar3]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b

.done
;> return
	ret


;@ path: minigame/fishing
;@ The lure in a hooked fish's mouth: one 8x16 sprite (tile $54, attributes 0).
HookedLureSprite::
	db $54, $00

;@ path: minigame/fishing
;@ x offset of the lure on a hooked fish, by direction: +8 facing right, -8 facing left. 2 bytes.
HookedLureOffsetX::
	db $08, $f8

;@ def PondFishHooked(slot: c)
;@ path: minigame/fishing
;@ State 4: the hooked fish (drawn with the lure in its mouth) pulls towards the far left (0, $59),
;@ adjusting its speed by 1 every 8 frames. Each A or B press reels it towards the rod (speed changed by
;@ 2, aimed at Link + (-$14, +8)) and bends the rod for $10 frames; a big fish ignores a press one time
;@ in four. Landed (above y $2C and right of x $74): it jumps out of the water (state 5, with a
;@ splash). Pulled out at the left (x < 3): it got away, dialogue $49 and the rod asks again.
;@ test: skip opens a dialogue
PondFishHooked::
;>@x hActiveEntityX += mem[HookedLureOffsetX + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, HookedLureOffsetX
	add hl, de
;=@x
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntitySpriteVariant = 0
	ld hl, hActiveEntitySpriteVariant
	ld [hl], b
;> DrawEntity8x16(slot, HookedLureSprite)
	ld de, HookedLureSprite
	call DrawEntity8x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if hFrameCounter & 7 == 0:                    # pull away
	ldh a, [hFrameCounter]
	and $07
	jr nz, .buttons
;>     saved = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;>     hLinkX = 0
;>     hLinkY = 0x59
	ld a, $00
	ldh [hLinkX], a
	ld a, $59
	ldh [hLinkY], a
;>     GetVectorTowardsLink(slot, 8)
	ld a, $08
	call GetVectorTowardsLink
;>@py     wEntitySpeedY[slot] += -1 if (hMultiPurpose0 - wEntitySpeedY[slot]) & 0x80 else 1
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	inc [hl]
	and $80
;=@py
	jr z, .pullX
	dec [hl]
	dec [hl]

.pullX
;>@px     wEntitySpeedX[slot] += -1 if (hMultiPurpose1 - wEntitySpeedX[slot]) & 0x80 else 1
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	inc [hl]
	and $80
;=@px
	jr z, .pulled
	dec [hl]
	dec [hl]

.pulled
;>     hLinkX = saved[0]
;>     hLinkY = saved[1]
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a

.buttons
;> if hJoypadPressed & 0x30:                    # A or B: reel
	ldh a, [hJoypadPressed]
	and $30
	jr z, .move
;>@big     if wEntityPrivate1[slot] == 3 and GetRandomByte() & 3 == 0:   # a big fish resists
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, .reel
;=@big
	call GetRandomByte
	and $03
;>         return move()                       # this press is ignored
	jr z, .move

.reel
;>     saved = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
;>     hLinkX -= 0x14
	sub $14
	ldh [hLinkX], a
	ldh a, [hLinkY]
	push af
;>     hLinkY += 8
	add $08
	ldh [hLinkY], a
;>     GetVectorTowardsLink(slot, 3)
	ld a, $03
	call GetVectorTowardsLink
;>@ry     wEntitySpeedY[slot] += -2 if (hMultiPurpose0 - wEntitySpeedY[slot]) & 0x80 else 2
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	inc [hl]
	inc [hl]
;=@ry
	and $80
	jr z, .reelX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]

.reelX
;>@rx     wEntitySpeedX[slot] += -2 if (hMultiPurpose1 - wEntitySpeedX[slot]) & 0x80 else 2
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	inc [hl]
	inc [hl]
;=@rx
	and $80
	jr z, .reeled
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]

.reeled
;>     hLinkX = saved[0]
;>     hLinkY = saved[1]
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
;>     wEntityTimer[slot] = 0x10                # the rod bends
	call GetEntityTimer
	ld [hl], $10

.move
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> if wEntitySpeedX[slot] != 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .rod
;>     wEntityDirection[slot] = wEntitySpeedX[slot] >> 7   # face where it moves (1 = left)
	rlca
	and $01
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

.rod
;> wEntitySpriteVariant[0] = 5                  # the rod, pulled
	ld hl, wEntitySpriteVariant
	ld [hl], $05
;>@if if wEntityTimer[slot] != 0 and hFrameCounter & 0x30:
	call GetEntityTimer
	jr z, .landed
;=@if
	ldh a, [hFrameCounter]
	and $30
	jr z, .landed
;>     wEntitySpriteVariant[0] = 7              # reeling against the fish
	ld hl, wEntitySpriteVariant
	ld [hl], $07

.landed
;>@l if hActiveEntityDrawY < 0x2C and hActiveEntityX >= 0x74:   # at the bank below the rod
	ldh a, [hActiveEntityDrawY]
	cp $2c
	jr nc, .escape
;=@l
	ldh a, [hActiveEntityX]
	cp $74
	jr c, .escape
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntitySpeedX[slot] = 5
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $05
;>     wEntitySpeedY[slot] = 0xF0               # jumps out
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
;>     return FishingSplash()
	jp FishingSplash

.escape
;> if hActiveEntityX < 3:                       # it got away
	ldh a, [hActiveEntityX]
	cp $03
	jr nc, .done
;>     wEntityState[0] = 3                      # the rod: ask to fish again
	ld hl, wEntityState
	ld [hl], $03
;>     OpenDialog(0x49)
	ld a, $49
	call OpenDialog
;>     return DespawnEntity_04(slot)
	jp DespawnEntity_04

.done
;> return
	ret


;@ def PondFishCaught(slot: c)
;@ path: minigame/fishing
;@ State 5: the landed fish flies up out of the water and falls back. When its fall speed reaches $0C
;@ the rod asks to fish again and the catch is paid: the big fish in slot $0F the first time gives the
;@ piece of heart (room flag bit 4, a new heart container with every fourth piece, dialogue $FE or $FF
;@ of table 1) and $20 rupees; another big fish gives $14 rupees (dialogue $4A), a small fish 5
;@ (dialogue $4D). Then the fish is removed.
;@ test: skip opens a dialogue
PondFishCaught::
;> wEntitySpriteVariant[0] = 1                  # the rod, raised
	ld hl, wEntitySpriteVariant
	ld [hl], $01
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> wEntitySpeedY[slot] += 1                     # gravity
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	nop
;> if wEntitySpeedY[slot] != 0x0C:
;>     return
	ld a, [hl]
	cp $0c
	jr nz, .done
;> wEntityState[0] = 3                          # the rod: ask to fish again
	ld hl, wEntityState
	ld [hl], $03
;>@h if slot == 0x0F and not hRoomStatus & 0x10:  # the piece-of-heart fish, not caught before
	ld a, c
	cp $0f
	jr nz, .fish
;=@h
	ldh a, [hRoomStatus]
	and $10
	jr nz, .fish
;>     hJingle = 1
	ld a, $01
	ldh [hJingle], a
;>@r     wRoomStatus[0x200 + hMapRoom] |= 0x10    # (second group of indoor rooms)
	ldh a, [hMapRoom]
	ld e, a
	ld d, $01
	ld hl, wRoomStatus + $100
	add hl, de
	ld a, [hl]
;=@r
	or $10
	ld [hl], a
;>     hRoomStatus = wRoomStatus[0x200 + hMapRoom]
	ldh [hRoomStatus], a
;>     wHeartPieces += 1
	ld a, [wHeartPieces]
	inc a
	ld [wHeartPieces], a
;>     if wHeartPieces == 4:
	cp $04
	jr nz, .piece
;>         wHeartPieces = 0
	xor a
	ld [wHeartPieces], a
;>         wAddHealthBuffer = 0x40              # refill 8 hearts
	ld hl, wAddHealthBuffer
	ld [hl], $40
;>         wMaxHearts += 1
	ld hl, wMaxHearts
	inc [hl]
;>         text = 0xFF
	ld a, $ff
	jr .heartText

;>     else:
.piece
;>         text = 0xFE
	ld a, $fe

.heartText
;>     OpenDialogTable1(text)
	call OpenDialogTable1
;>     wAddRupeeBufferLow = 0x20
	ld hl, wAddRupeeBufferLow
	ld [hl], $20
	jr .despawn

;> else:
.fish
;>@b     rupees, text = (0x14, 0x4A) if wEntityPrivate1[slot] == 3 else (5, 0x4D)   # big / small
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	ld e, $14
	ld a, $4a
;=@b
	jr z, .pay
	ld e, $05
	ld a, $4d

.pay
;>     wAddRupeeBufferLow = rupees
	ld hl, wAddRupeeBufferLow
	ld [hl], e
;>     OpenDialog(text)
	call OpenDialog

.despawn
;> DespawnEntity_04(slot)
	call DespawnEntity_04

.done
;> return
	ret


;@ path: minigame/fishing
;@ Sprites of the big fish, laid out like SmallFishSprites (tiles $40-$46): 0-3 facing left, 4-7
;@ facing right.
BigFishSprites::
	db $44, $00, $42, $00, $44, $00, $46, $00, $40, $00, $42, $00, $40, $00, $46, $00
	db $42, $20, $44, $20, $46, $20, $44, $20, $42, $20, $40, $20, $46, $20, $40, $20

;@ def BigFish(slot: c)
;@ path: minigame/fishing
;@ Piece 3, a big fish: drawn facing its direction, then the shared fish behaviour.
;@ test: skip dispatches through a jump table
BigFish::
;> if wEntityDirection[slot] == 0:              # facing right: the flipped variants
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw
;>     hActiveEntitySpriteVariant += 4
	ldh a, [hActiveEntitySpriteVariant]
	add $04
	ldh [hActiveEntitySpriteVariant], a

.draw
;> DrawEntity16x16(slot, BigFishSprites)
	ld de, BigFishSprites
	call DrawEntity16x16
;> return PondFishCommon(slot)
	jp PondFishCommon


;@ def BigFishIdle(slot: bc)
;@ path: minigame/fishing
;@ State 0 of a big fish: it drifts to a stop; after its timer it turns round and swims for $18
;@ frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BigFishIdle::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .drift
;>     wEntityTimer[slot] = 0x18
	ld [hl], $18
;>     wEntityDirection[slot] ^= 1              # turn round
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
;>     wEntityState[slot] += 1                  # swim
	call IncrementEntityState

.drift
;>@if if hFrameCounter & 3 == 0 and wEntitySpeedX[slot] != 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;=@if
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>@e     wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1   # slow down
	and $80
	jr z, .slower
	inc [hl]
	inc [hl]
.slower
;=@e
	dec [hl]

.done
;> return
	ret


;@ path: minigame/fishing
;@ Top swimming speed of a big fish by direction: 8 right, -8 left. 2 bytes.
BigFishSwimSpeed::
	db $08, $f8

;@ def BigFishSwim(slot: bc)
;@ path: minigame/fishing
;@ State 1 of a big fish: it speeds up to its (slower) swimming speed; after its timer it drifts again
;@ for $50 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BigFishSwim::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .swim
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.swim
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;>@d     diff = wEntitySpeedX[slot] - mem[BigFishSwimSpeed + wEntityDirection[slot]]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, wEntityDirection
	add hl, bc
;=@d
	ld e, [hl]
	ld d, $00
	ld hl, BigFishSwimSpeed
	add hl, de
	sub [hl]
	pop hl
;>     if diff != 0:
	and a
	jr z, .done
;>@e         wEntitySpeedX[slot] += 1 if diff & 0x80 else -1
	and $80
	jr z, .slower
	inc [hl]
	inc [hl]
.slower
;=@e
	dec [hl]

.done
;> return
	ret


;@ def PondFishCheckLure(slot: bc)
;@ path: minigame/fishing
;@ Makes the fish bite (state 2, for $30-$6F frames) when no other fish is biting, the lure is in the
;@ water, on the side the fish faces, within $18 pixels across and $10 up or down. Counts the bite in
;@ wSceneVar4.
;@ test: slot = rand(0, 15)
PondFishCheckLure::
;> if wSceneVar2 != 0: return                   # ($D002) a fish is already biting
	ld a, [wSceneVar2]
	and a
	jr nz, .done
;>@l if wEntityStatus[wSceneVar3] == 0 or wEntityState[wSceneVar3] == 0: return   # no lure in the water
	ld a, [wSceneVar3]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
;=@l
	and a
	jr z, .done
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
;=@l
	jr z, .done
;>@f if ((wEntityWorkRAM - hActiveEntityX) >> 6) & 1 != wEntityDirection[slot]: return   # behind it
	ld a, [wEntityWorkRAM]
	ld hl, hActiveEntityX
	sub [hl]
	rlca
	rlca
	and $01
;=@f
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr nz, .done
;> if abs(wEntityWorkRAM - hActiveEntityX) >= 0x18: return
	ld a, [wEntityWorkRAM]
	ld hl, hActiveEntityX
	sub [hl]
	add $18
	cp $30
	jr nc, .done
;> if abs(wSceneVar1 - hActiveEntityY) >= 0x10: return
	ld a, [wSceneVar1]
	ld hl, hActiveEntityY
	sub [hl]
	add $10
	cp $20
	jr nc, .done
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> wSceneVar2 += 1                              # biting
	ld hl, wSceneVar2
	inc [hl]
;> wSceneVar4 += 1                              # ($D004) bites this visit
	ld hl, wSceneVar4
	inc [hl]
;> wEntityTimer[slot] = 0x30 + (GetRandomByte() & 0x3F)
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a

.done
;> return
	ret


;@ def LeaveFishingGame()
;@ path: minigame/fishing
;@ Starts the warp out of the pond room, arriving at the tile Link stands on.
;@ test: skip starts a warp
LeaveFishingGame::
;> StartWarpFadeOutMusic()
	call StartWarpFadeOutMusic
;>@p wWarpDestPosition = ((hLinkY - 8) & 0xF0) | (hLinkX >> 4)
	ldh a, [hLinkX]
	swap a
	and $0f
	ld e, a
	ldh a, [hLinkY]
	sub $08
;=@p
	and $f0
	or e
	ld [wWarpDestPosition], a
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> return
	ret


;@ path: object/tractor-device
;@ Sprites of the tractor device: 2 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes; $20 = x flip), the two frames of its spinning (tiles $4C / $4E).
TractorDeviceSprites::
	db $4c, $00, $4c, $20, $4e, $00, $4e, $20

;@ path: object/tractor-device
;@ The same in map 1 (tiles $7C / $7E).
TractorDeviceSpritesAlt::
	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

;@ def TractorDevice(slot: c)
;@ path: object/tractor-device
;@ Entities $52 and $53, the tractor devices on the floor: in turns of $40 frames on and $10 off, $52
;@ sucks Link and the other entities in (and drops Link through it like a hole), $53 blows them away.
;@ test: skip dispatches through a jump table
TractorDevice::
;> wLinkPulledByDevice += 1
	ld hl, wLinkPulledByDevice
	inc [hl]
;> sprites = TractorDeviceSpritesAlt if hMapId == 1 else TractorDeviceSprites
	ld de, TractorDeviceSprites
	ldh a, [hMapId]
	cp $01
	jr nz, .draw
	ld de, TractorDeviceSpritesAlt

.draw
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> return TractorDeviceStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/tractor-device
;@ States of the tractor device.
TractorDeviceStates::
	dw TractorDeviceWork
	dw TractorDeviceRest

;@ path: object/tractor-device
;@ The directions Link turns through while he is sucked in (right, down, left, up), 4 bytes.
TractorSpinDirections::
	db $00, $03, $01, $02

;@ def TractorDeviceWork(slot: c)
;@ path: object/tractor-device
;@ State 0, the device working (until its drop timer runs out, then it rests $10 frames). While Link
;@ walks normally it moves him: $52 pulls him in at speed 8 and, once he is within 4 pixels and on the
;@ ground, drops him through (Link's falling motion 6); $53 pushes him away at speed $14. Link spins
;@ while he is pulled.
;@ test: skip moves Link through bank-0 and bank-2 code
TractorDeviceWork::
;> if GetEntityDropTimer(slot) == 0:
	call GetEntityDropTimer
	jr nz, .working
;>     wEntityDropTimer[slot] = 0x10
	ld [hl], $10
;>     wEntityState[slot] += 1                  # rest
	call IncrementEntityState
;>     return
	ret

.working
;> if wLinkMotionState != 0: return TractorDeviceRun(slot)   # Link busy (falling, ...)
	ld a, [wLinkMotionState]
	cp $00
	jp nz, TractorDeviceRun
;> saved_x = hLinkSpeedX
	ldh a, [hLinkSpeedX]
	push af
;> saved_y = hLinkSpeedY
	ldh a, [hLinkSpeedY]
	push af
;> pull = hActiveEntityType == 0x52             # else push
	ld e, $00
	ldh a, [hActiveEntityType]
	cp $52
;> speed = 8 if pull else 0x14
	ld a, $14
	jr nz, .vector
	inc e
	ld a, $08

.vector
;> GetVectorTowardsLink(slot, speed)                  # from the device to Link
	push de
	call GetVectorTowardsLink
	pop de
;> hLinkSpeedY = -hMultiPurpose0 if pull else hMultiPurpose0
	ldh a, [hMultiPurpose0]
	bit 0, e
	jr z, .setY
	cpl
	inc a
.setY
	ldh [hLinkSpeedY], a
;> hLinkSpeedX = -hMultiPurpose1 if pull else hMultiPurpose1
	ldh a, [hMultiPurpose1]
	bit 0, e
	jr z, .setX
	cpl
	inc a
.setX
	ldh [hLinkSpeedX], a
;> ApplyLinkSpeed()
	push bc
	call ApplyLinkSpeed
;> CheckLinkLeavesRoomFar()                                  # bank 2: Link against the walls
	call CheckLinkLeavesRoomFar
	pop bc
;> hLinkSpeedY = saved_y
	pop af
	ldh [hLinkSpeedY], a
;> hLinkSpeedX = saved_x
	pop af
	ldh [hLinkSpeedX], a
;> wLinkPushingTimer = 0
	xor a
	ld [wLinkPushingTimer], a
;> if not pull: return TractorDeviceRun(slot)
	ldh a, [hActiveEntityType]
	cp $52
	jp nz, TractorDeviceRun
;>@in if wIsLinkInTheAir == 0 and abs(GetEntityXDistanceToLink_04(slot)) < 4 and abs(GetEntityYDistanceToLink_04(slot)) < 4:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .spin
;=@in
	call GetEntityXDistanceToLink_04
	add $04
	cp $08
	jr nc, .spin
;=@in
	call GetEntityYDistanceToLink_04
	add $04
	cp $08
	jr nc, .spin
;>     hLinkX = hActiveEntityX                  # on the device
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;>     hLinkY = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hLinkY], a
;>     wLinkMotionState = 6                     # falling down a hole
	ld a, $06
	ld [wLinkMotionState], a
;>     wLinkMotionCounter = ResetSpinAttackAndDash()   # (returns 0)
	call ResetSpinAttackAndDash
	ld [wLinkMotionCounter], a
;>     wHoleCollisionType = 0xFF
	ld a, $ff
	ld [wHoleCollisionType], a
;>     hWaveSfx = 0x0C
	ld a, $0c
	ldh [hWaveSfx], a
;>     return
	ret

.spin
;>@s hLinkDirection = mem[TractorSpinDirections + ((hFrameCounter >> 3) & 3)]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
;=@s
	ld d, b
	ld hl, TractorSpinDirections
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a
;> TractorDeviceRun(slot)                       # (falls through)

;@ def TractorDeviceRun(slot: c)
;@ path: object/tractor-device
;@ Moves the other entities, animates the device and makes its whirring noise every $20 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TractorDeviceRun::
;> TractorDeviceMoveEntities(slot)
	call TractorDeviceMoveEntities
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .done
;>     hNoiseSfx = 0x1F
	ld a, $1f
	ldh [hNoiseSfx], a

.done
;> return
	ret


;@ def TractorDeviceRest(slot: c)
;@ path: object/tractor-device
;@ State 1, the device at rest; when its drop timer runs out it works again for $40 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TractorDeviceRest::
;> if GetEntityDropTimer(slot) == 0:
	call GetEntityDropTimer
	jr nz, .still
;>     wEntityDropTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.still
;> return SetEntitySpriteVariant(slot, 0)
	ld a, $00
	jp SetEntitySpriteVariant


;@ def TractorDeviceMoveEntities(slot: c)
;@ path: object/tractor-device
;@ Every other frame each other entity is moved one step at speed $10 towards the device ($52) or away
;@ from it ($53), against walls; one that reaches the device (within 2 pixels) disappears into it. Its
;@ own speed is kept.
;@ test: skip moves the other entities through bank-0 wall checks
TractorDeviceMoveEntities::
;>@loop for e in range(15, -1, -1):
	ld e, $0f
	ld d, b

.loop
	push de
;>@c     if e == slot or wEntityStatus[e] == 0: continue
	ld a, e
	cp c
	jp z, .next
;=@c
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jp z, .next
;>     LoadEntityPosition(slot)                 # the device's position in hActiveEntityX / Y
	call LoadEntityPosition
;>     select(e)                                # (the following works on e)
	push bc
	push de
	pop bc
;>     if (hFrameCounter ^ e) & 1: continue     # every other frame
	ldh a, [hFrameCounter]
	xor c
	and $01
	jr nz, .skip
;>     saved = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;>     hLinkX = hActiveEntityX  # aim at the device
;>     hLinkY = hActiveEntityY
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
	ldh a, [hActiveEntityY]
	ldh [hLinkY], a
;>@sv     savedSpeed = wEntitySpeedX[e], wEntitySpeedY[e]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntitySpeedY
	add hl, bc
;=@sv
	ld a, [hl]
	push af
;>     GetVectorTowardsLink(slot, 0x10)               # from e to the device
	ld a, $10
	call GetVectorTowardsLink
;>     pull = hActiveEntityType == 0x52
	ld e, $00
	ldh a, [hActiveEntityType]
	cp $52
	jr nz, .vecY
	inc e

.vecY
;>@y     wEntitySpeedY[e] = hMultiPurpose0 if pull else -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	bit 0, e
	jr nz, .setY
	cpl
	inc a
.setY
;=@y
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>@x     wEntitySpeedX[e] = hMultiPurpose1 if pull else -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	bit 0, e
	jr nz, .setX
	cpl
	inc a
.setX
;=@x
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     LoadEntityPosition(e)
	call LoadEntityPosition
;>     UpdateEntityPosWithSpeed_04(e)
	call UpdateEntityPosWithSpeed_04
;>     EntityCheckWalls(e)
	call EntityCheckWalls
;>@at     if abs(hActiveEntityX - hLinkX) < 2 and abs(hActiveEntityDrawY - hLinkY) < 2:   # in the device
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $02
	cp $04
	jr nc, .restore
;=@at
	ldh a, [hActiveEntityDrawY]
	ld hl, hLinkY
	sub [hl]
	add $02
	cp $04
	jr nc, .restore
;>         DespawnEntity_04(e)
	call DespawnEntity_04

.restore
;>@rs     wEntitySpeedY[e] = savedSpeed[0]
;>     wEntitySpeedX[e] = savedSpeed[1]
	pop af
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop af
	ld hl, wEntitySpeedX
;=@rs
	add hl, bc
	ld [hl], a
;>     hLinkY = saved[0]
;>     hLinkX = saved[1]
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a

.skip
	pop bc

.next
;=@loop
	pop de
	dec e
	ld a, e
	cp $ff
	jp nz, .loop
;> return
	ret


;@ def BallTrooper(slot: c)
;@ path: enemy/ball-and-chain-trooper
;@ Entity $51, the ball-and-chain trooper: walks up to Link swinging its iron ball, then hurls the ball
;@ at him on its chain and reels it back. In a dungeon it is gone once that dungeon's flag bit 0 is set;
;@ elsewhere (map $14 and up) it stays defeated by the room flag bit 4 and leaves entity $3C behind.
;@ test: skip dispatches through a jump table
BallTrooper::
;> if hMapId >= 0x14:
	ldh a, [hMapId]
	cp $14
	jr c, .dungeon
;>     if hRoomStatus & 0x10: return DespawnEntity_04(slot)   # already beaten
	ldh a, [hRoomStatus]
	and $10
	jp nz, DespawnEntity_04
;>     wEntityLoadOrder[slot] = 0xFF            # (the room flag remembers it instead)
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;>     wEntityDropType[slot] = 0x3C
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c
	jr .run

;> else:
.dungeon
;>@d     if wDungeonFlags[hMapId] & 1: return DespawnEntity_04(slot)
	ld e, a
	ld d, b
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	and $01
;=@d
	jp nz, DespawnEntity_04

.run
;> DrawBallTrooper(slot)
	call DrawBallTrooper
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> if ApplyRecoilIfNeeded_04(slot): return
	call ApplyRecoilIfNeeded_04
;> wEntityOptions1[slot] = 0
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $00
;> EntityCheckHits(slot)
	call EntityCheckHits
;> return BallTrooperStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/ball-and-chain-trooper
;@ States of the ball-and-chain trooper.
BallTrooperStates::
	dw BallTrooperApproach
	dw BallTrooperAim
	dw BallTrooperThrow

;@ def BallTrooperApproach(slot: c)
;@ path: enemy/ball-and-chain-trooper
;@ State 0: after its pause timer it walks towards Link (speed 4, re-aimed every 8 frames) until he is
;@ within $30 pixels both ways, then aims for $28 frames (state 1). The ball swings meanwhile.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BallTrooperApproach::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .swing
;>     if (hFrameCounter ^ slot) & 7 == 0:
	ldh a, [hFrameCounter]
	xor c
	and $07
	jr nz, .walk
;>         SetEntitySpeedTowardsLink(slot, 4)
	ld a, $04
	call SetEntitySpeedTowardsLink

.walk
;>     UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;>     EntityCheckWalls(slot)
	call EntityCheckWalls
;>@n     if abs(GetEntityXDistanceToLink_04(slot)) < 0x30 and abs(GetEntityYDistanceToLink_04(slot)) < 0x30:
	call GetEntityXDistanceToLink_04
	add $30
	cp $60
	jr nc, .swing
;=@n
	call GetEntityYDistanceToLink_04
	add $30
	cp $60
	jr nc, .swing
;>         wEntityTimer[slot] = 0x28
	call GetEntityTimer
	ld [hl], $28
;>         wEntityState[slot] += 1
	call IncrementEntityState

.done
;>         return
	ret

.swing
;> if hFrameCounter & 1: return
	ldh a, [hFrameCounter]
	and $01
	jr nz, .done
;> BallTrooperSwingBall(slot)                   # every other frame (falls through)

;@ def BallTrooperSwingBall(slot: bc)
;@ path: enemy/ball-and-chain-trooper
;@ Moves the swinging ball one step round its circle (wEntityPrivateCounter, 16 steps) and animates the
;@ trooper with it.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BallTrooperSwingBall::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@v SetEntitySpriteVariant(slot, (wEntityPrivateCounter[slot] >> 3) & 1)
	ld a, [hl]
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> return
	ret


;@ path: enemy/ball-and-chain-trooper
;@ The step of the swinging ball (0-15) at which the trooper lets go, by its direction (right, left,
;@ up, down). 4 bytes.
BallTrooperThrowAngles::
	db $04, $0c, $00, $08

;@ def BallTrooperAim(slot: bc)
;@ path: enemy/ball-and-chain-trooper
;@ State 1: swinging the ball every frame; after the timer it faces Link and lets go when the ball
;@ passes the angle for that direction: the ball flies out (speed $38, state 2).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BallTrooperAim::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .swing
;>     dir = GetEntityDirectionToLink_04(slot)
	call GetEntityDirectionToLink_04
;>     wEntityDirection[slot] = dir
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>@a     if wEntityPrivateCounter[slot] & 0x0F == mem[BallTrooperThrowAngles + dir]:
	ld d, b
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $0f
	ld hl, BallTrooperThrowAngles
;=@a
	add hl, de
	cp [hl]
	jr nz, .swing
;>         wEntityPrivate1[slot] = 0x38         # the ball's speed outwards
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $38
;>         wEntityPrivate4[slot] = 0            # its sideways drift
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
;>         wEntityState[slot] += 1
	call IncrementEntityState

.swing
;> return BallTrooperSwingBall(slot)
	jp BallTrooperSwingBall


;@ def BallTrooperThrow(slot: bc)
;@ path: enemy/ball-and-chain-trooper
;@ State 2: the ball's distance (wEntityPrivate3, with the fraction in wEntityPrivate2) grows by its
;@ speed, which falls by 2 each frame, so the ball flies out and comes back; it drifts sideways one pixel
;@ every 4 frames. When it is back the trooper pauses $10 frames (state 0), the ball swinging on from
;@ half a turn past the throw angle.
;@ test: slot = rand(0, 15)
BallTrooperThrow::
;> AddPrivate1SpeedToPrivate3_04(slot)
	call AddPrivate1SpeedToPrivate3_04
;> wEntityPrivate1[slot] -= 2
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
	dec [hl]
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .back
;>     wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]

.back
;>@b if wEntityPrivate3[slot] == 0 or wEntityPrivate3[slot] & 0x80:   # the ball is back
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr z, .caught
;=@b
	and $80
	jr z, .done

.caught
;>     wEntityPrivate3[slot] = 0
	ld [hl], b
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>@c     wEntityPrivateCounter[slot] = mem[BallTrooperThrowAngles + wEntityDirection[slot]] + 8
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, BallTrooperThrowAngles
	add hl, de
;=@c
	ld a, [hl]
	add $08
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], a

.done
;> return
	ret


;@ path: enemy/ball-and-chain-trooper
;@ Sprites of the trooper: 3 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes): 0 and 1 the trooper (two frames), 2 the iron ball (tile $78 and its mirror image).
BallTrooperSprites::
	db $70, $00, $72, $00, $74, $00, $76, $00, $78, $00, $78, $20

;@ path: enemy/ball-and-chain-trooper
;@ The circle of the swinging ball: 16 offsets, read for y at step n and for x at step n + 4 (a quarter
;@ turn later), 20 bytes.
BallTrooperBallCircle::
	db $0a, $06, $03, $01, $00, $01, $03, $06, $0a, $0e, $11, $13, $14, $13, $11, $0e
	db $0a, $06, $03, $01

;@ def DrawBallTrooper(slot: c)
;@ path: enemy/ball-and-chain-trooper
;@ Draws the trooper and its ball: swinging round the circle, or thrown (distance wEntityPrivate3 in its
;@ direction, drifting sideways by wEntityPrivate4). A thrown ball hits Link (and bounces off solid
;@ blocks) while it flies out, and a chain of three links (tile $24) is drawn from the trooper to it.
;@ test: skip writes OAM through bank-0 sprite code
DrawBallTrooper::
;> DrawEntity16x16(slot, BallTrooperSprites)          # the trooper
	ld de, BallTrooperSprites
	call DrawEntity16x16
;> d = wEntityPrivate3[slot]                    # how far the ball is thrown
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
;> if d != 0:
	jr z, .swinging
;>     back = 0                                 # (hMultiPurpose0) thrown left or up
	xor a
	ldh [hMultiPurpose0], a
;>     dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
;>     if dir < 2:                              # right / left
	bit 1, a
	jr nz, .vertical
;>@l         if dir == 1: back = 1; d = -d
	cp $01
	ld a, [hl]
	jr nz, .right
;=@l
	ld hl, hMultiPurpose0
	inc [hl]
	cpl
	inc a
.right
;>         hActiveEntityX += d
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;>@s         side = (~wEntityPrivate4[slot] & 0x0F) if back else wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ldh a, [hMultiPurpose0]
	and a
	ld a, [hl]
	jr z, .sideY
;=@s
	cpl
	and $0f
.sideY
;>         hActiveEntityDrawY += side - 0x0D
	ld hl, hActiveEntityDrawY
	add [hl]
	add $f3
	ld [hl], a
	jr .drawBall

;>     else:                                    # up / down
.vertical
;>@u         if dir == 2: back = 1; d = -d
	cp $02
	ld a, [hl]
	jr nz, .down
;=@u
	ld hl, hMultiPurpose0
	inc [hl]
	cpl
	inc a
.down
;>         hActiveEntityDrawY += d
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;>@t         side = wEntityPrivate4[slot] if back else (~wEntityPrivate4[slot] & 0x0F)
	ld hl, wEntityPrivate4
	add hl, bc
	ldh a, [hMultiPurpose0]
	and a
	ld a, [hl]
	jr nz, .sideX
;=@t
	cpl
	and $0f
.sideX
;>         hActiveEntityX += side - 8
	ld hl, hActiveEntityX
	add [hl]
	add $f8
	ld [hl], a
	jr .drawBall

;> else:                                        # swinging
.swinging
;>     n = wEntityPrivateCounter[slot] & 0x0F
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $0f
	ld e, a
	ld d, $00
;>     hActiveEntityDrawY += mem[BallTrooperBallCircle + n] - 0x10
	ld hl, BallTrooperBallCircle
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	add $f0
	ldh [hActiveEntityDrawY], a
;>     hActiveEntityX += mem[BallTrooperBallCircle + n + 4] - 0x0D
	ld hl, BallTrooperBallCircle + 4
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	add $f3
	ldh [hActiveEntityX], a

.drawBall
;> hActiveEntitySpriteVariant = 2
	ld a, $02
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, BallTrooperSprites)          # the ball
	ld de, BallTrooperSprites
	call DrawEntity16x16
;> if wEntityPrivate4[slot] == 0: return        # not thrown yet: no chain
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jp z, .done
;>@h if not wEntityPrivate1[slot] & 0x80 and wEntityTimer1[slot] == 0:   # flying out
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .chain
;=@h
	call GetEntityTimer1
	jr nz, .chain
;>     wEntityOptions1[slot] = 0x40             # the ball's hits
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $40
;>     EntityCheckHits(slot)
	call EntityCheckHits
;>     BallTrooperBallBounce(slot)
	call BallTrooperBallBounce

.chain
;>@sx stepX = (hActiveEntityX + 4 - wEntityX[slot]) >> 2   # (signed) a quarter of the way to the ball
	ldh a, [hActiveEntityX]
	add $04
	ld hl, wEntityX
	add hl, bc
	sub [hl]
	sra a
;=@sx
	sra a
;> hMultiPurpose0 = stepX
	ldh [hMultiPurpose0], a
;> hMultiPurpose2 = stepX
	ldh [hMultiPurpose2], a
;> stepY = (hActiveEntityDrawY - wEntityY[slot]) >> 2
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
	sra a
	sra a
;> hMultiPurpose1 = stepY
	ldh [hMultiPurpose1], a
;> hMultiPurpose3 = stepY
	ldh [hMultiPurpose3], a
;>@o oam = 0xC030 + wOAMNextIndex                # the next free OAM entry
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
	push hl
;=@o
	pop de
;> LoadEntityPosition(slot)                     # back to the trooper's position
	call LoadEntityPosition
;>@k for k in range(3, 0, -1):                  # three chain links
	ld a, $03

.link
	ldh [hMultiPurpose4], a
;>     oam.y = hActiveEntityDrawY + hMultiPurpose1
	ldh a, [hActiveEntityDrawY]
	ld hl, hMultiPurpose1
	add [hl]
	ld [de], a
	inc de
;>     oam.x = hActiveEntityX + hMultiPurpose0
	ldh a, [hActiveEntityX]
	ld hl, hMultiPurpose0
	add [hl]
	ld [de], a
	inc de
;>     oam.tile, oam.attr = 0x24, 0
	ld a, $24
	ld [de], a
	inc de
	ld a, $00
	ld [de], a
	inc de
;>     hMultiPurpose0 += stepX
	ldh a, [hMultiPurpose0]
	ld hl, hMultiPurpose2
	add [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 += stepY
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	add [hl]
	ldh [hMultiPurpose1], a
;=@k
	ldh a, [hMultiPurpose4]
	dec a
	jr nz, .link
;> ReserveOAMEntriesFar(3)
	ld a, $03
	call ReserveOAMEntriesFar

.done
;> return
	ret


;@ def BallTrooperBallBounce(slot: bc)
;@ path: enemy/ball-and-chain-trooper
;@ When the flying ball (at hActiveEntityX / DrawY) is over a solid block of the room, it bounces back:
;@ its speed is turned round, it stops hitting for 8 frames, and a puff and a clink mark the spot.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BallTrooperBallBounce::
;>@t square = ((hActiveEntityDrawY - 0x0C) & 0xF0) | (hActiveEntityX >> 4)
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose4], a
	swap a
	and $0f
	ld e, a
	ldh a, [hActiveEntityDrawY]
;=@t
	sub $10
	add $04
	ldh [hMultiPurpose5], a
	and $f0
	or e
	ld e, a
;>@o hRoomObjectType = wRoomObjects[square]
	ld d, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, de
	ld h, a
	ld a, [hl]
;=@o
	ldh [hRoomObjectType], a
;>@p if GetObjectPhysics(hRoomObjectType, wIsIndoor) == 1:   # solid
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
;=@p
	cp $00
	jr z, PuffAtEntity_04.done
	cp $01
	jr nz, PuffAtEntity_04.done
;>     wEntityPrivate1[slot] = -wEntityPrivate1[slot]   # fly back
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     wEntityTimer1[slot] = 8
	call GetEntityTimer1
	ld [hl], $08
;>     hJingle = 7
	ld a, $07
	ldh [hJingle], a
;>     PuffAtEntity_04()                        # (falls through)

;@ def PuffAtEntity_04()
;@ path: helpers/entity
;@ A small puff (transient effect 5) at the active entity's position.
;@ test: skip spawns a transient effect
PuffAtEntity_04::
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(5)
	ld a, $05
	call AddTransientVfx

.done
;> return
	ret


;@ path: enemy/beamos
;@ Sprites of the Beamos statue: 8 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes; $20 = x flip), one per position of its turning eye (variant = direction / 2).
BeamosSprites::
	db $70, $00, $70, $20, $78, $00, $7a, $00, $74, $00, $76, $00, $7c, $00, $7e, $00
	db $72, $00, $72, $20, $7e, $20, $7c, $20, $76, $20, $74, $20, $7a, $20, $78, $20
;@ path: enemy/beamos
;@ Speeds of the Beamos' invisible probe shots for its 16 directions: y speed at direction n, x speed at
;@ n + 4 (a quarter turn later), so direction 0 is straight down. 20 bytes.
BeamosProbeSpeeds::
	db $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa, $00, $06, $0c, $0e
	db $10, $0e, $0c, $06

;@ def Beamos(slot: c)
;@ path: enemy/beamos
;@ Entity $2A, the Beamos: a statue whose eye turns through 16 directions (one step every 8 frames),
;@ sending an invisible probe (another $2A, state 1) each step. When a probe touches Link, the statue
;@ flashes and $10 frames later fires its laser (entity $2B) at him. Its state 0 is the statue; any
;@ other state is a probe (BeamosProbe).
;@ test: skip spawns entities
Beamos::
;> if hActiveEntityState != 0: return BeamosProbe(slot)
	ldh a, [hActiveEntityState]
	and a
	jp nz, BeamosProbe
;> DrawEntity16x16(slot, BeamosSprites)
	ld de, BeamosSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:                                   # Link was spotted
	jr z, .turn
;>     if t != 0x10: return
	cp $10
	jr nz, .done
;>     laser, full = SpawnEntity(slot, 0x2B)
	ld a, $2b
	call SpawnEntity
;>     if full: return
	jr c, .done
;>     hNoiseSfx = 8
	ld a, $08
	ldh [hNoiseSfx], a
;>     wEntityX[laser] = hMultiPurpose0         # the statue's position and direction
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[laser] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityDirection[laser] = hMultiPurpose2
	ldh a, [hMultiPurpose2]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[laser] = wEntitySpeedX[slot]   # aimed at Link when he was spotted
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[laser] = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a

.done
;>     return
	ret

.turn
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] & 7: return
	and $07
	jr nz, .return
;> wEntityDirection[slot] = (wEntityDirection[slot] + 1) & 0x0F
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	and $0f
	ld [hl], a
;> wEntitySpriteVariant[slot] = wEntityDirection[slot] >> 1
	srl a
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;> probe, full = SpawnEntity(slot, 0x2A)
	ld a, $2a
	call SpawnEntity
;> if full: return
	jr c, .return
;> wEntityX[probe] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[probe] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityState[probe] = 1
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;> wEntityPrivate1[probe] = slot                # its statue
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], c
;> wEntityPhysicsFlags[probe] = 0xC0
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c0
;>@px wEntitySpeedX[probe] = mem[BeamosProbeSpeeds + hMultiPurpose2 + 4]   # the statue's direction
	push bc
	ldh a, [hMultiPurpose2]
	ld c, a
	ld hl, BeamosProbeSpeeds + 4
	add hl, bc
	ld a, [hl]
;=@px
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>@py wEntitySpeedY[probe] = mem[BeamosProbeSpeeds + hMultiPurpose2]
	ld hl, BeamosProbeSpeeds
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;=@py
	pop bc

.return
;> return
	ret


;@ def BeamosProbe(slot: bc)
;@ path: enemy/beamos
;@ An invisible probe of a Beamos: it flies straight on and vanishes at a block or the edge of the room.
;@ Reaching Link (within $10 pixels) it vanishes too and, unless Link is invincible or the statue is
;@ already firing, makes its statue (wEntityPrivate1) flash for $10 frames, aim at Link with speed $40
;@ and fire after $10 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
BeamosProbe::
;> EntityCheckObjectCollision(slot)
	call EntityCheckObjectCollision
;> if wEntityCollisions[slot] != 0: return DespawnEntity_04(slot)
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jp nz, DespawnEntity_04
;>@l if abs(hActiveEntityX - hLinkX) < 0x10 and abs(hActiveEntityY - hLinkY) < 0x10:   # at Link
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $10
	cp $20
	jr nc, .fly
;=@l
	ldh a, [hActiveEntityY]
	ld hl, hLinkY
	sub [hl]
	add $10
	cp $20
	jr nc, .fly
;>     DespawnEntity_04(slot)
	call DespawnEntity_04
;>     if wInvincibilityCounter != 0: return fly()
	ld a, [wInvincibilityCounter]
	and a
	jr nz, .fly
;>     statue = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>     if wEntityTimer[statue] != 0: return fly()   # already firing
	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	and a
	jr nz, .fly
;>     wEntityTimer[statue] = 0x20
	ld [hl], $20
;>     wEntityFlashTimer[statue] = 0x10
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $10
;>     SetEntitySpeedTowardsLink(statue, 0x40)
	push bc
	push de
	pop bc
	ld a, $40
	call SetEntitySpeedTowardsLink
	pop bc
;>     return
	ret

.fly
;>@x wEntityX[slot] += wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	add [hl]
;=@x
	ld [hl], a
;> if wEntityX[slot] >= 0x9C: return DespawnEntity_04(slot)
	cp $9c
	jp nc, DespawnEntity_04
;>@y wEntityY[slot] += wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	add [hl]
;=@y
	ld [hl], a
;> if wEntityY[slot] < 0x78: return
	cp $78
	ret c
;> DespawnEntity_04(slot)                       # (falls through)

;@ def DespawnEntity_04(slot: bc)
;@ path: helpers/entity
;@ Removes the entity (status 0).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
DespawnEntity_04::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
;> return
	ret


;@ def ApplyRecoilIfNeeded_04(slot: c)
;@ path: helpers/entity
;@ While the entity is knocked back (wEntityIgnoreHitsTimer running) it moves with its recoil speed
;@ (against walls unless option bit 5) instead of its own, and the caller's handler is cut short: this
;@ drops the caller's return address, so the return goes straight back to the caller's caller.
;@ test: skip pops the caller's return address
ApplyRecoilIfNeeded_04::
;> if wEntityIgnoreHitsTimer[slot] != 0:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     wEntityIgnoreHitsTimer[slot] -= 1
	dec a
	ld [hl], a
;>     AddPowerHitTrailVfx(slot)                          # bank 0: puffs of dust while knocked back
	call AddPowerHitTrailVfx
;>@s     saved = wEntitySpeedX[slot], wEntitySpeedY[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntitySpeedY
	add hl, bc
;=@s
	ld a, [hl]
	push af
;>     wEntitySpeedX[slot] = wEntityRecoilSpeedX[slot]
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = wEntityRecoilSpeedY[slot]
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;>     if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore
;>         EntityCheckWalls(slot)
	call EntityCheckWalls

.restore
;>@r     wEntitySpeedY[slot] = saved[0]
;>     wEntitySpeedX[slot] = saved[1]
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
;=@r
	pop af
	ld [hl], a
;>     drop_return_address()                    # return to the caller's caller
	pop af

.done
;> return
	ret


;@ def UpdateEntityPosWithSpeed_04(slot: c)
;@ path: helpers/entity
;@ Moves the entity by its x and y speeds (pixels per 16 frames, the fractions kept in the speed
;@ accumulators).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
UpdateEntityPosWithSpeed_04::
;> AddEntitySpeedToPosX_04(slot)
	call AddEntitySpeedToPosX_04
;> AddEntitySpeedToPosY_04(slot)                # (falls through)

;@ def AddEntitySpeedToPosY_04(slot: bc)
;@ path: helpers/entity
;@ Moves the entity by its y speed: the same as the x version on the arrays $10 bytes further on
;@ (wEntitySpeedY, wEntitySpeedYAcc, wEntityY).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
AddEntitySpeedToPosY_04::
;> AddEntitySpeedToPosX_04(slot + 0x10)
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPosX_04
	pop bc
;> return
	ret


;@ def AddEntitySpeedToPosX_04(slot: bc)
;@ path: helpers/entity
;@ Moves the entity by its x speed, a signed 4.4 fixed-point number: the low nibble goes into the
;@ fraction wEntitySpeedXAcc, the high nibble (sign-extended) plus the carry into wEntityX.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
AddEntitySpeedToPosX_04::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
;> if speed == 0: return
	jr z, AddSpeedWholePart_04.done
;>@f wEntitySpeedXAcc[slot] += (speed << 4) & 0xF0     # carry kept in d
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
;=@f
	ld [hl], a
	rl d
;> pos = wEntityX
	ld hl, wEntityX

AddSpeedWholePart_04:
;>@w pos[slot] += (speed >> 4, sign-extended) + carry
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive
	ld e, $f0
.positive
;=@w
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

.done
;> return
	ret


;@ def AddEntityZSpeedToPos_04(slot: bc)
;@ path: helpers/entity
;@ Moves the entity up or down by its z speed (fraction in wEntitySpeedZAcc, height in wEntityZ), as
;@ AddEntitySpeedToPosX_04.
;@ test: slot = rand(0, 15)
AddEntityZSpeedToPos_04::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and a
;> if speed == 0: return
	jr z, AddSpeedWholePart_04.done
;>@f wEntitySpeedZAcc[slot] += (speed << 4) & 0xF0
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
;=@f
	ld [hl], a
	rl d
;> return AddSpeedWholePart_04(wEntityZ)
	ld hl, wEntityZ
	jr AddSpeedWholePart_04

;@ def AddPrivate1SpeedToPrivate3_04(slot: bc)
;@ path: helpers/entity
;@ The same 4.4 fixed-point move for a private value: wEntityPrivate3 moves by the speed in
;@ wEntityPrivate1, its fraction kept in wEntityPrivate2.
;@ test: slot = rand(0, 15)
AddPrivate1SpeedToPrivate3_04::
;> speed = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;>@f wEntityPrivate2[slot] += (speed << 4) & 0xF0
	push af
	swap a
	and $f0
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
;=@f
	ld [hl], a
	rl d
;> return AddSpeedWholePart_04(wEntityPrivate3)
	ld hl, wEntityPrivate3
	jp AddSpeedWholePart_04


;@ def GetEntityXDistanceToLink_04(slot: bc) -> (a, d, e)
;@ path: helpers/entity
;@ a = d = hLinkX - wEntityX[slot]; e = the direction towards Link (0 right, 1 left).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GetEntityXDistanceToLink_04::
;> e = 0
	ld e, $00
;> d = hLinkX - wEntityX[slot]
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if d & 0x80: e = 1                           # Link is to the left
	bit 7, a
	jr z, .right
	inc e
.right
	ld d, a
;> return
	ret


;@ def GetEntityYDistanceToLink_04(slot: bc) -> (a, d, e)
;@ path: helpers/entity
;@ a = d = hLinkY - wEntityY[slot]; e = the direction towards Link (2 up, 3 down).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GetEntityYDistanceToLink_04::
;> e = 2
	ld e, $02
;> d = hLinkY - wEntityY[slot]
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if not d & 0x80: e = 3                       # Link is below
	bit 7, a
	jr nz, .up
	inc e
.up
	ld d, a
;> return
	ret


;@ def GetEntityDirectionToLink_04(slot: c) -> (a, e)
;@ path: helpers/entity
;@ The main direction from the entity to Link (0 right, 1 left, 2 up, 3 down): vertical when Link is
;@ at least as far away up or down as sideways.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
GetEntityDirectionToLink_04::
;>@dx dx = abs(GetEntityXDistanceToLink_04(slot))     # hMultiPurpose0 = the sideways direction
	call GetEntityXDistanceToLink_04
	ld a, e
	ldh [hMultiPurpose0], a
	ld a, d
	bit 7, a
	jr z, .dx
;=@dx
	cpl
	inc a
.dx
	push af
;>@dy dy = abs(GetEntityYDistanceToLink_04(slot))     # hMultiPurpose1 = the up/down direction
	call GetEntityYDistanceToLink_04
	ld a, e
	ldh [hMultiPurpose1], a
	ld a, d
	bit 7, a
	jr z, .dy
;=@dy
	cpl
	inc a
.dy
;>@e e = hMultiPurpose1 if dy >= dx else hMultiPurpose0
	pop de
	cp d
	jr nc, .vertical
;=@e
	ldh a, [hMultiPurpose0]
	jr .result
.vertical
	ldh a, [hMultiPurpose1]
.result
	ld e, a
;> return
	ret


;@ def TrendyGameOwner(slot: c)
;@ path: minigame/trendy-game
;@ Entity $4F, the Trendy Game: its owner (and, with wEntityPrivate1 set, the prizes). Once Marin has
;@ played here (room flag bit 4) the game runs as if she were not following Link.
;@ test: skip dispatches through a jump table
TrendyGameOwner::
;> saved = wIsMarinFollowingLink
	ld a, [wIsMarinFollowingLink]
	push af
;> if hRoomStatus & 0x10:                       # Marin has played already
	ldh a, [hRoomStatus]
	and $10
	jr z, .run
;>     wIsMarinFollowingLink = 0
	xor a
	ld [wIsMarinFollowingLink], a

.run
;> TrendyGame(slot)
	call TrendyGame
;> wIsMarinFollowingLink = saved
	pop af
	ld [wIsMarinFollowingLink], a
;> return
	ret


;@ def TrendyGame(slot: c)
;@ path: minigame/trendy-game
;@ The owner behind the counter (he faces Link and blocks him), the crane and the prize it carries, and
;@ the 13 states of a game. While Marin plays (state 3 on) Link cannot move.
;@ test: skip dispatches through a jump table
TrendyGame::
;> if wEntityPrivate1[slot] != 0: return TrendyPrize(slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, TrendyPrize
;> wSongShowTimer = slot                        # ($D210) the owner's slot, for the prizes
	ld a, c
	ld [wSongShowTimer], a
;> wItemButtonsDisabled = 2
	ld a, $02
	ld [wItemButtonsDisabled], a
;> if wEntityTimer1[slot] == 1:                 # $10 frames after a catch
	call GetEntityTimer1
	dec a
	jr nz, .draw
;>     hJingle = 0x19
	ld a, $19
	ldh [hJingle], a

.draw
;> if hActiveEntitySpriteVariant != 0xFF:       # (hidden while Marin hangs from the crane)
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	jr z, .crane
;>     if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .walk
;>         wEntityDirection[slot] = GetEntityDirectionToLink_04(slot)
	call GetEntityDirectionToLink_04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.walk
;>     AnimateEntityWalking_04(slot)
	call AnimateEntityWalking_04
;>     DrawEntity16x16(slot, ShopOwnerSprites)
	ld de, ShopOwnerSprites
	call DrawEntity16x16

.crane
;> DrawTrendyCrane()
	call DrawTrendyCrane
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> BlockLinkAtEntity_04(slot)
	call BlockLinkAtEntity_04
;> TrendyCraneCarryPrize(slot)
	call TrendyCraneCarryPrize
;>@m if hActiveEntityState >= 3 and wIsMarinFollowingLink:   # Marin is playing
	ldh a, [hActiveEntityState]
	cp $03
	jr c, .state
;=@m
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .state
;>     hLinkInteractiveMotionBlocked = 2
;>     wLinkFrozen = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a

.state
;> return TrendyGameStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: minigame/trendy-game
;@ States of the Trendy Game owner.
TrendyGameStates::
	dw TrendyGameSetup
	dw TrendyGameWaitForTalk
	dw TrendyGameAnswer
	dw TrendyCraneWaitRight
	dw TrendyCraneMoveRight
	dw TrendyCraneWaitUp
	dw TrendyCraneMoveUp
	dw TrendyCraneLower
	dw TrendyCraneGrab
	dw TrendyCraneRaise
	dw TrendyCraneReturn
	dw TrendyCraneRelease
	dw TrendyGameRoundOver

;@ path: minigame/trendy-game
;@ The six prizes placed at the start, by the slot each one gets (9-14, since free slots are taken from
;@ $0E down): x positions (6 bytes; the following tables are read the same way).
TrendyPrizeX::
	db $38, $58, $78, $58, $40, $70
;@ path: minigame/trendy-game
;@ y positions of the six prizes.
TrendyPrizeY::
	db $2e, $2e, $2e, $3e, $4e, $4e

;@ path: minigame/trendy-game
;@ Starting directions of the six prizes on the conveyor (0 left, 1 down, 2 right, 3 up, 4 still).
TrendyPrizeDirection::
	db $00, $00, $00, $04, $01, $02

;@ path: minigame/trendy-game
;@ Which prize each one is (sprite variant): 0 Yoshi Doll, 2 30 Rupees, 3 Magic Powder, 4 Shield, 5 a
;@ Heart.
TrendyPrizeVariant::
	db $05, $02, $02, $00, $03, $04

;@ path: minigame/trendy-game
;@ Physics flags of the six prizes.
TrendyPrizePhysics::
	db $81, $81, $81, $82, $81, $81

;@ def TrendyGameSetup(slot: c)
;@ path: minigame/trendy-game
;@ State 0: places the six prizes (entity $4F with wEntityPrivate1 = 1) and parks the crane at the top
;@ left (x $18, y $16), claw closed, both buttons lit. Remembers whether Link has a trade item yet (then
;@ the Yoshi Doll is not among the prizes).
;@ test: skip spawns entities
TrendyGameSetup::
;>@loop for n in range(6, 0, -1):
	ld e, $06
	ld d, $00

.spawn
	push de
;>     prize, full = SpawnEntityFromSlot(slot, 0x4F, last=0x0E)   # slots 14 down to 9
	ld a, $4f
	ld e, $0e
	call SpawnEntityFromSlot
;>     wEntityPrivate1[prize] = 1               # a prize
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>     wEntityX[prize] = mem[TrendyPrizeX + (prize - 9)]
	ld hl, TrendyPrizeX - 9
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[prize] = mem[TrendyPrizeY + (prize - 9)]
	ld hl, TrendyPrizeY - 9
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[prize] = mem[TrendyPrizeVariant + (prize - 9)]
	ld hl, TrendyPrizeVariant - 9
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>     wEntityPhysicsFlags[prize] = mem[TrendyPrizePhysics + (prize - 9)]
	ld hl, TrendyPrizePhysics - 9
	add hl, de
	ld a, [hl]
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], a
;>     wEntityDirection[prize] = mem[TrendyPrizeDirection + (prize - 9)]
	ld hl, TrendyPrizeDirection - 9
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;>     SetTrendyPrizeSpeed(prize, direction)
	push bc
	push de
	pop bc
	call SetTrendyPrizeSpeed
	pop bc
;=@loop
	pop de
	dec e
	jr nz, .spawn
;> wEntityScratch6 = 0                          # the crane's cable: the claw hangs at the top
	xor a
	ld [wEntityScratch6], a
;> wEntityScratch2 = 0x10  # ($D202 / $D203) both buttons lit (palette 1)
;> wEntityScratch3 = 0x10
	ld a, $10
	ld [wEntityScratch2], a
	ld [wEntityScratch3], a
;> wEntityScratch5 = 0x16                      # ($D205) the crane's y
	ld a, $16
	ld [wEntityScratch5], a
;> wEntityScratch4 = 0x18                            # ($D204) the crane's x
	ld a, $18
	ld [wEntityScratch4], a
;> wEntityWorkRAM3[0] = 0                       # ($D200) the crane's animation frame
	ld a, $00
	ld [wEntityWorkRAM3], a
;> wEntityScratch1 = 4                         # ($D201) the claw's variant: closed
	ld a, $04
	ld [wEntityScratch1], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityPrivate5[slot] = wTradeSequenceItem   # the doll is gone once Link trades
	ld a, [wTradeSequenceItem]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def TrendyGameWaitForTalk(slot: c)
;@ path: minigame/trendy-game
;@ State 1: when Link talks to the owner (or Marin, following him, walks him past x $6C: then the room
;@ remembers she played, wRoomStatus bit 4) the owner offers a game: "TRENDY GAME! One Play 10 Rs."
;@ ($3B), "Challenge Again?" ($3E) after a first game, Marin's "can I try this?" ($F7), or "We're
;@ closing up for today" ($40) once all prizes are won (5 when the doll is not among them).
;@ test: skip opens a dialogue
TrendyGameWaitForTalk::
;> if wLinkFrozen: return
	ld a, [wLinkFrozen]
	and a
	ret nz
;>@m if wIsMarinFollowingLink and hLinkX >= 0x6C:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .talk
;=@m
	ldh a, [hLinkX]
	cp $6c
	jr c, .talk
;>     wRoomStatus[0x2A0] |= 0x10               # (this room) Marin has played
	ld hl, wRoomStatus + $2a0
	set 4, [hl]
;>     hLinkX = 0x6B
	ld a, $6b
	ldh [hLinkX], a
	jr .offer

;> elif not CanTalkToEntityWide_04(slot): return
.talk
	call CanTalkToEntityWide_04
	jr nc, .done

.offer
;> wLinkWalkingFrameCount = 0
;> hLinkSpeedX = 0
	xor a
	ld [wLinkWalkingFrameCount], a
	ldh [hLinkSpeedX], a
;>@p prizes = 5 if wEntityPrivate5[slot] else 6
	ld e, $06
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	and a
	jr z, .count
;=@p
	dec e

.count
;> if wEntityPrivate4[slot] >= prizes:          # all won
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp e
	jr c, .ask
;>     return OpenDialog(0x40)
	ld a, $40
	call OpenDialog
	ret

.ask
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .owner
;>     text = 0xF7
	ld a, $f7
	jr .open

;> else:
.owner
;>@t     text = 0x3E if wEntityPrivate3[slot] else 0x3B   # played before?
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ld a, $3b
	jr z, .open
;=@t
	ld a, $3e

.open
;> OpenDialog(text)
	call OpenDialog
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def TrendyGameAnswer(slot: c)
;@ path: minigame/trendy-game
;@ State 2, the answer: "Play" (or Marin's insisting $F8 closing) with 10 rupees pays them and starts a
;@ game (dialogue $3C, the rules, the first time, then "Good Luck!" $3F); without the money "Sorry,
;@ kid!" ($34). "No" ends the talk, except that Marin asks again ($F8).
;@ test: skip opens a dialogue
TrendyGameAnswer::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wDialogState != 0: return
	ld a, [wDialogState]
	and a
	jr nz, TrendyGameBackToWait.done
;>@y if wDialogIndex == 0xF8 or wDialogAnswer == 0:   # yes
	ld a, [wDialogIndex]
	cp $f8
	jr z, .yes
;=@y
	ld a, [wDialogAnswer]
	cp $01
	jr nc, .no

.yes
;>     if wRupeeCount >= 0x10: return TrendyGameStart(slot)   # (BCD) 10 rupees
	ld a, [wRupeeCountLow]
	sub $10
	ld a, [wRupeeCountHigh]
	sbc $00
	jr nc, TrendyGameStart
;>     OpenDialog(0x34)                         # not enough
	ld a, $34
	call OpenDialog
;>     return TrendyGameBackToWait(slot)
	jr TrendyGameBackToWait

.no
;> if not wIsMarinFollowingLink: return TrendyGameBackToWait(slot)
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, TrendyGameBackToWait
;> return OpenDialog(0xF8)                      # Marin insists
	ld a, $f8
	jp OpenDialog


;@ def TrendyGameBackToWait(slot: bc)
;@ path: minigame/trendy-game
;@ Back to waiting for Link to talk (state 1).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyGameBackToWait::
;> wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01

.done
;> return
	ret


;@ def TrendyGameStart(slot: c)
;@ path: minigame/trendy-game
;@ Takes the 10 rupees and starts a game (state 3): the rules ($3C) the first time, else "Good Luck!"
;@ ($3F). When Marin plays, wIsMarinInAnimalVillage is set from wIsMarinFollowingLink.
;@ test: skip opens a dialogue
TrendyGameStart::
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .rules
;>     wIsMarinInAnimalVillage = wIsMarinFollowingLink
	ld [wIsMarinInAnimalVillage], a

.rules
;>@r first = wEntityPrivate3[slot] == 0; wEntityPrivate3[slot] = 1
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld [hl], $01
;=@r
	and a
;> OpenDialog(0x3C if first else 0x3F)
	ld a, $3c
	jr z, .text
	ld a, $3f
.text
	call OpenDialog
;> wSubtractRupeeBufferLow = 10
	ld a, $0a
	ld [wSubtractRupeeBufferLow], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> return
	ret


;@ def TrendyCraneWaitRight(slot: c)
;@ path: minigame/trendy-game
;@ State 3: the first button (B, moves the crane right) blinks. Link starts by holding B while he stands
;@ at it (x $20-$2F). Marin instead walks left to the buttons (speed -8, to x $28), turns, and starts
;@ by herself $18 frames later.
;@ test: skip moves Marin's entity
TrendyCraneWaitRight::
;>@f wEntityWorkRAM3[0] = (hFrameCounter >> 4) & 1   # the crane's frame
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@f
	ld [wEntityWorkRAM3], a
;> wEntityScratch3 = 0x10                       # second button lit
	ld a, $10
	ld [wEntityScratch3], a
;> wEntityScratch2 = hFrameCounter & 0x10          # ($D202) first button blinks
	ldh a, [hFrameCounter]
	and $10
	ld [wEntityScratch2], a
;> if wIsMarinFollowingLink:                    # Marin plays
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .link
;>     if GetEntityDropTimer(slot) != 0:
	call GetEntityDropTimer
	jr z, .walk
;>         if wEntityDropTimer[slot] == 1: TrendyCraneNextState(slot)   # start
	dec a
	jr nz, .wait
	call TrendyCraneNextState

.wait
;>         return
	ret

.walk
;>     if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>     marin = wSingingMarinSlot
	push bc
	ld a, [wSingingMarinSlot]
	ld c, a
;>     SetEntitySpriteVariant(marin, 5 if hFrameCounter & 0x10 else 4)   # walking left
	ldh a, [hFrameCounter]
	and $10
	ld a, $04
	jr z, .frame
	inc a
.frame
	call SetEntitySpriteVariant
;>     wEntitySpeedX[marin] = -8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f8
;>     AddEntitySpeedToPosX_04(marin)
	call AddEntitySpeedToPosX_04
;>     if wEntityX[marin] == 0x28:              # at the buttons
	ld hl, wEntityX
	add hl, bc
	pop bc
	ld a, [hl]
	cp $28
	jr nz, .done
;>         wEntityDropTimer[slot] = 0x18
	call GetEntityDropTimer
	ld [hl], $18
;>         wEntitySpriteVariant[marin] = 2
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $02
;>         TrendyGameTurnLink(1)                # Link looks left at her
	ld e, $01
	call TrendyGameTurnLink

.done
;>     return
	ret

.link
;>@b if hJoypadHeld & 0x20 and 0x20 <= hLinkX < 0x30:   # B held at the button
	ldh a, [hJoypadHeld]
	and $20
	jr z, TrendyCraneStartNoise.done
;=@b
	ldh a, [hLinkX]
	cp $20
	jr c, TrendyCraneStartNoise.done
	cp $30
	jr nc, TrendyCraneStartNoise.done
;>     TrendyCraneNextState(slot)               # (falls through)

;@ def TrendyCraneNextState(slot: bc)
;@ path: minigame/trendy-game
;@ Goes on to the next state with the crane's start noise.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyCraneNextState::
;> wEntityState[slot] += 1
	call IncrementEntityState
;> TrendyCraneStartNoise()                      # (falls through)

;@ def TrendyCraneStartNoise()
;@ path: minigame/trendy-game
;@ The crane's motor starts (noise effect $20).
TrendyCraneStartNoise::
;> hNoiseSfx = 0x20
	ld a, $20
	ldh [hNoiseSfx], a

.done
;> return
	ret


;@ def TrendyCraneMoveRight(slot: c)
;@ path: minigame/trendy-game
;@ State 4: while B is held (Marin: always) the crane moves right one pixel every 4 frames, up to
;@ x $88; letting go stops it (state 5, the motor's stop noise; Marin waits $10 frames).
;@ test: skip turns Link through bank-2 code
TrendyCraneMoveRight::
;> TrendyCraneAnimate()
	call TrendyCraneAnimate
;> wEntityScratch3 = 0x10
	ld a, $10
	ld [wEntityScratch3], a
;> wEntityScratch2 = hFrameCounter & 0x10          # first button blinks
	ldh a, [hFrameCounter]
	and $10
	ld [wEntityScratch2], a
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .link
;>     TrendyGameTurnLink(2)                    # up
	ld e, $02
	call TrendyGameTurnLink
	jr .move

.link
;> elif not hJoypadHeld & 0x20: return stop()
	ldh a, [hJoypadHeld]
	and $20
	jr z, .stop

.move
;> if hFrameCounter & 3: return
	ldh a, [hFrameCounter]
	and $03
	jr nz, TrendyCraneStopNoise.done
;> wEntityScratch4 += 1                              # ($D204) the crane's x
	ld a, [wEntityScratch4]
	inc a
	ld [wEntityScratch4], a
;> if wEntityScratch4 < 0x88: return
	cp $88
	jr c, TrendyCraneStopNoise.done

.stop
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, TrendyCraneStopNoise
;>     wEntityDropTimer[slot] = 0x10
	call GetEntityDropTimer
	ld [hl], $10
;> TrendyCraneStopNoise()                       # (falls through)

;@ def TrendyCraneStopNoise()
;@ path: minigame/trendy-game
;@ The crane's motor stops (noise effect $21).
TrendyCraneStopNoise::
;> hNoiseSfx = 0x21
	ld a, $21
	ldh [hNoiseSfx], a

.done
;> return
	ret


;@ def TrendyCraneAnimate()
;@ path: minigame/trendy-game
;@ Animates the crane (every 16 frames) and keeps Link still, facing up at the machine.
TrendyCraneAnimate::
;>@f wEntityWorkRAM3[0] = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@f
	ld [wEntityWorkRAM3], a
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> hLinkDirection = 2                           # up
	ld a, $02
	ldh [hLinkDirection], a
;> return
	ret


;@ def TrendyCraneWaitUp(slot: c)
;@ path: minigame/trendy-game
;@ State 5: the second button (A, moves the crane back) blinks; pressing A (Marin: after her wait)
;@ starts it (state 6).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyCraneWaitUp::
;> TrendyCraneAnimate()
	call TrendyCraneAnimate
;> wEntityScratch2 = 0x10
	ld a, $10
	ld [wEntityScratch2], a
;> wEntityScratch3 = hFrameCounter & 0x10       # second button blinks
	ldh a, [hFrameCounter]
	and $10
	ld [wEntityScratch3], a
;> if GetEntityDropTimer(slot) != 0: return
	call GetEntityDropTimer
	ret nz
;> if wIsMarinFollowingLink or hJoypadHeld & 0x10:   # A
	ld a, [wIsMarinFollowingLink]
	and a
	jr nz, .start
	ldh a, [hJoypadHeld]
	and $10
	jr z, .done

.start
;>     TrendyCraneStartNoise()
	call TrendyCraneStartNoise
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def TrendyCraneMoveUp(slot: c)
;@ path: minigame/trendy-game
;@ State 6: while A is held (Marin: always) the crane moves one pixel every 4 frames down the screen
;@ (towards the back of the machine), up to y $55; then it stops and lowers the claw (state 7, $60
;@ frames).
;@ test: skip turns Link through bank-2 code
TrendyCraneMoveUp::
;> TrendyCraneAnimate()
	call TrendyCraneAnimate
;> wEntityScratch2 = 0x10
	ld a, $10
	ld [wEntityScratch2], a
;> wEntityScratch3 = hFrameCounter & 0x10
	ldh a, [hFrameCounter]
	and $10
	ld [wEntityScratch3], a
;>@s if not wIsMarinFollowingLink and not hJoypadHeld & 0x10: return stop()
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .link
	jr .move
.link
;=@s
	ldh a, [hJoypadHeld]
	and $10
	jr z, .stop

.move
;> if hFrameCounter & 3: return
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;> wEntityScratch5 += 1                        # ($D205) the crane's y
	ld a, [wEntityScratch5]
	inc a
	ld [wEntityScratch5], a
;> if wEntityScratch5 < 0x55: return
	cp $55
	jr c, .done

.stop
;> wEntityState[slot] += 1
	call IncrementEntityState
;> TrendyCraneStopNoise()
	call TrendyCraneStopNoise
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;> TrendyGameTurnLink(0)                        # right
	ld e, $00
	call TrendyGameTurnLink

.done
;> return
	ret


;@ def TrendyCraneLower(slot: c)
;@ path: minigame/trendy-game
;@ State 7: the claw opens after $30 frames; when the timer runs out the cable lets it down one pixel
;@ every 4 frames to $0F, then it grabs (state 8, timer $FF).
;@ test: skip turns Link through bank-2 code
TrendyCraneLower::
;> wEntityWorkRAM3[0] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
;> wEntityScratch2 = 0x10
;> wEntityScratch3 = 0x10
	ld a, $10
	ld [wEntityScratch2], a
	ld [wEntityScratch3], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t < 0x30:
	cp $30
	jr nc, .lower
;>     wEntityScratch1 = 2                     # ($D201) the claw opens
	ld hl, wEntityScratch1
	ld [hl], $02

.lower
;> if t != 0 or hFrameCounter & 3: return
	and a
	jr nz, TrendyGameTurnLink.done
	ldh a, [hFrameCounter]
	and $03
	jr nz, TrendyGameTurnLink.done
;> wEntityScratch6 += 1                         # the cable gets longer
	ld a, [wEntityScratch6]
	inc a
	ld [wEntityScratch6], a
;> if wEntityScratch6 != 0x0F: return
	cp $0f
	jr nz, TrendyGameTurnLink.done
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> wEntityState[slot] += 1
	call IncrementEntityState
;> TrendyGameTurnLink(0)                        # (falls through)
	ld e, $00

;@ def TrendyGameTurnLink(direction: e)
;@ path: minigame/trendy-game
;@ When Marin plays, turns Link (watching her) to `direction` and updates his pose.
;@ test: skip calls bank-2 code
TrendyGameTurnLink::
;> if not wIsMarinFollowingLink: return
	ld a, [wIsMarinFollowingLink]
	and a
	ret z
;> hLinkDirection = direction
	ld a, e
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc

.done
;> return
	ret


;@ def TrendyCraneGrab(slot: bc)
;@ path: minigame/trendy-game
;@ State 8, timed by the timer from $FF: at $C8 the cable drops one pixel more ($10), at $A0 the claw
;@ half closes, at $50 it closes and grabs whatever is under it; at 0 the crane starts raising it
;@ (state 9).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyCraneGrab::
;> wEntityWorkRAM3[0] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0xC8: wEntityScratch6 = 0x10
	cp $c8
	jr nz, .halfClosed
	ld hl, wEntityScratch6
	ld [hl], $10

.halfClosed
;> if t == 0xA0: wEntityScratch1 = 3
	cp $a0
	jr nz, .closed
	ld hl, wEntityScratch1
	ld [hl], $03

.closed
;> if t == 0x50:
	cp $50
	jr nz, .up
;>     wEntityScratch1 = 4
	ld hl, wEntityScratch1
	ld [hl], $04
;>     return TrendyCraneGrabPrize(slot)
	call TrendyCraneGrabPrize
	ret

.up
;> if t == 0:
	and a
	jr nz, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     TrendyCraneStartNoise()
	call TrendyCraneStartNoise

.done
;> return
	ret


;@ def TrendyCraneRaise(slot: c)
;@ path: minigame/trendy-game
;@ State 9: the cable winds up one pixel every 4 frames; at the top the crane heads home (state 10).
;@ test: slot = rand(0, 15)
TrendyCraneRaise::
;> wEntityWorkRAM3[0] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
;> if hFrameCounter & 3: return
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;> wEntityScratch6 -= 1
	ld a, [wEntityScratch6]
	dec a
	ld [wEntityScratch6], a
;> if wEntityScratch6 == 0: wEntityState[slot] += 1
	jr nz, .done
	call IncrementEntityState

.done
;> return
	ret


;@ def TrendyCraneReturn(slot: c)
;@ path: minigame/trendy-game
;@ State 10: the crane travels back to its home (x $18, y $16) at speed 4. It moves through entity
;@ slot 1's position and speed arrays (wEntityX[1] / wEntityY[1]), so whatever is in that slot is
;@ overwritten. Home: it waits $C0 frames over the chute (state 11).
;@ test: skip borrows entity slot 1
TrendyCraneReturn::
;> wEntityWorkRAM3[0] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
;> saved = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x16  # aim at home
;> hLinkX = 0x18
	ld a, $16
	ldh [hLinkY], a
	ld a, $18
	ldh [hLinkX], a
;> wEntityX[1] = wEntityScratch4  # the crane's position
;> wEntityY[1] = wEntityScratch5
	ld a, [wEntityScratch4]
	ld [wEntityX + 1], a
	ld a, [wEntityScratch5]
	ld [wEntityY + 1], a
;> SetEntitySpeedTowardsLink(1, 4)               # for slot 1
	push bc
	ld c, $01
	ld a, $04
	call SetEntitySpeedTowardsLink
;> UpdateEntityPosWithSpeed_04(1)
	call UpdateEntityPosWithSpeed_04
;> wEntityScratch4 = wEntityX[1]
;> wEntityScratch5 = wEntityY[1]
	ld a, [wEntityX + 1]
	ld [wEntityScratch4], a
	ld a, [wEntityY + 1]
	ld [wEntityScratch5], a
	pop bc
;> hLinkY = saved[0]
;> hLinkX = saved[1]
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
;>@h if wEntityScratch4 == 0x18 and wEntityScratch5 == 0x16:   # home
	ld a, [wEntityScratch4]
	cp $18
	jr nz, .done
;=@h
	ld a, [wEntityScratch5]
	cp $16
	jr nz, .done
;>     wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     TrendyCraneStopNoise()
	call TrendyCraneStopNoise

.done
;> return
	ret


;@ def TrendyCraneRelease(slot: bc)
;@ path: minigame/trendy-game
;@ State 11: at timer $60 the claw opens and drops what it carries (wEntityPrivate2 = its slot + 1)
;@ down the chute (the prize's state 2; Marin's prize shows her variant 7). At 0 the claw closes and the
;@ round ends (state 12).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyCraneRelease::
;> wEntityWorkRAM3[0] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0x60:
	cp $60
	jr nz, .close
;>     wEntityScratch1 = 2                     # open
	ld hl, wEntityScratch1
	ld [hl], $02
;>     if wEntityPrivate2[slot] != 0:           # carrying something
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .return
;>         prize = wEntityPrivate2[slot] - 1; wEntityPrivate2[slot] = 0
	ld [hl], $00
	dec a
	ld e, a
	ld d, b
;>         wEntityState[prize] = 2              # falls
	ld hl, wEntityState
	add hl, de
	ld [hl], $02
;>         if wIsMarinFollowingLink: wEntitySpriteVariant[prize] = 7
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .return
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $07

.return
;>     return
	ret

.close
;> if t == 0:
	and a
	jr nz, .done
;>     wEntityScratch1 = 4                     # closed
	ld hl, wEntityScratch1
	ld [hl], $04
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
;> return
	ret


;@ def TrendyGameRoundOver(slot: c)
;@ path: minigame/trendy-game
;@ State 12: back to waiting for Link to talk.
;@ test: slot = rand(0, 15)
TrendyGameRoundOver::
;> TrendyGameBackToWait(slot)
	call TrendyGameBackToWait
;> return
	ret


;@ def TrendyCraneGrabPrize(slot: c)
;@ path: minigame/trendy-game
;@ The claw closes: when Marin plays, she takes the owner's place in it (the owner hides, variant $FF;
;@ a prize entity with her picture, variant 6, appears in the claw). Then the first waiting prize
;@ (state 0) within 4 pixels across and 6 up or down of the claw is caught: it is carried (state 1),
;@ wEntityPrivate2 = its slot + 1, the catch jingle comes $10 frames later, and the prizes won count
;@ goes up (it counts in slot 0's wEntityPrivate4, the owner's slot in this room).
;@ test: skip spawns an entity
TrendyCraneGrabPrize::
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .search
;>     SetEntitySpriteVariant(slot, 0xFF)             # the owner hides
	ld a, $ff
	call SetEntitySpriteVariant
;>     marin, full = SpawnEntity(slot, 0x4F)
	ld a, $4f
	call SpawnEntity
;>     wEntityX[marin] = wEntityScratch4
	ld a, [wEntityScratch4]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[marin] = wEntityScratch5 + 0x18
	ld a, [wEntityScratch5]
	add $18
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[marin] = 6
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $06
;>     wEntityPrivate1[marin] += 1              # a prize
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]

.search
;>@loop for e in range(15, -1, -1):
	ld e, $0f
	ld d, b

.loop
;>@a     if wEntityStatus[e] == 0 or wEntityState[e] != 0 or wEntityType[e] != 0x4F: continue
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
;=@a
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, .next
;=@a
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $4f
	jr nz, .next
;>@x     if abs(wEntityScratch4 - wEntityX[e]) >= 4: continue
	ld hl, wEntityX
	add hl, de
	ld a, [wEntityScratch4]
	sub [hl]
	add $04
	cp $08
;=@x
	jr nc, .next
;>@y     if abs(wEntityScratch5 + 0x18 - wEntityY[e]) >= 6: continue
	ld hl, wEntityY
	add hl, de
	ld a, [wEntityScratch5]
	add $18
	sub [hl]
	add $06
;=@y
	cp $0c
	jr nc, .next
;>     wEntityState[e] = 1                      # carried
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;>     wEntityPrivate2[slot] = e + 1
	ld a, e
	inc a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;>     wEntityTimer1[slot] = 0x10
	call GetEntityTimer1
	ld [hl], $10
;>     wEntityPrivate4[0] += 1
	ld hl, wEntityPrivate4
	inc [hl]
;>     return
	ret

.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .loop
;> return
	ret


;@ def TrendyCraneCarryPrize(slot: bc)
;@ path: minigame/trendy-game
;@ Keeps the caught prize under the claw: at the crane's x, y + $18, raised by the wound-up cable
;@ (z = $0E - wEntityScratch6).
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyCraneCarryPrize::
;> if wEntityPrivate2[slot] == 0: return
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;> prize = wEntityPrivate2[slot] - 1
	dec a
	ld e, a
	ld d, b
;> wEntityX[prize] = wEntityScratch4
	ld a, [wEntityScratch4]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[prize] = wEntityScratch5 + 0x18
	ld a, [wEntityScratch5]
	add $18
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>@z wEntityZ[prize] = 0x10 - wEntityScratch6 - 2
	ld a, $10
	ld hl, wEntityScratch6
	sub [hl]
	add $fe
	ld hl, wEntityZ
	add hl, de
;=@z
	ld [hl], a

.done
;> return
	ret


;@ path: minigame/trendy-game
;@ Sprites of the crane: 6 variants of a 16x16 entity (left tile, attributes, right tile, attributes;
;@ $20 = x flip): 0 and 1 the trolley (two frames), 2 the claw open, 3 half closed, 4 closed, 5 a piece
;@ of cable.
TrendyCraneSprites::
	db $76, $00, $78, $00, $78, $20, $76, $20, $70, $00, $70, $20, $72, $00, $70, $20
	db $72, $00, $72, $20, $7e, $00, $7e, $20

;@ path: minigame/trendy-game
;@ The claw's shadow on the floor (tile $26 twice), one 16x16 variant.
TrendyCraneShadowSprite::
	db $26, $00, $26, $00

;@ def DrawTrendyCrane()
;@ path: minigame/trendy-game
;@ Draws the crane: the claw (wEntityScratch1) at the end of the cable (wEntityScratch6 below the
;@ trolley), the trolley (frame wEntityWorkRAM3[0]) at (wEntityScratch4, wEntityScratch5), a cable piece
;@ when it is let down 8 or more, and every other frame the claw's shadow $20 below the trolley (its two
;@ halves pulled one pixel together). Then the two buttons go straight into the first four OAM entries
;@ ($C020): two 8x16 halves each at x $28 and $30, coloured by wEntityScratch2 and wEntityScratch3
;@ (palette 1 = lit).
;@ test: skip writes OAM through bank-0 sprite code
DrawTrendyCrane::
;> hActiveEntityX = wEntityScratch4
	ld a, [wEntityScratch4]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = wEntityScratch5 + wEntityScratch6 + 8   # the claw
	ld a, [wEntityScratch5]
	ld hl, wEntityScratch6
	add [hl]
	add $08
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = wEntityScratch1
	ld a, [wEntityScratch1]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(TrendyCraneSprites)
	ld de, TrendyCraneSprites
	call DrawEntity16x16
;> hActiveEntityX = wEntityScratch4  # the trolley
;> hActiveEntityDrawY = wEntityScratch5
	ld a, [wEntityScratch4]
	ldh [hActiveEntityX], a
	ld a, [wEntityScratch5]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = wEntityWorkRAM3[0]
	ld a, [wEntityWorkRAM3]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(TrendyCraneSprites)
	ld de, TrendyCraneSprites
	call DrawEntity16x16
;> if wEntityScratch6 >= 8:                     # let down far: a piece of cable
	ld a, [wEntityScratch6]
	cp $08
	jr c, .shadow
;>     hActiveEntityX = wEntityScratch4
	ld a, [wEntityScratch4]
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY = wEntityScratch5 + 0x10
	ld a, [wEntityScratch5]
	add $10
	ldh [hActiveEntityDrawY], a
;>     hActiveEntitySpriteVariant = 5
	ld a, $05
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(TrendyCraneSprites)
	ld de, TrendyCraneSprites
	call DrawEntity16x16

.shadow
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .buttons
;>     hActiveEntityX = wEntityScratch4
	ld a, [wEntityScratch4]
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY = wEntityScratch5 + 0x20
	ld a, [wEntityScratch5]
	add $20
	ldh [hActiveEntityDrawY], a
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     first = wOAMNextIndex
	ld de, TrendyCraneShadowSprite
	ld a, [wOAMNextIndex]
	push af
;>     DrawEntity16x16(TrendyCraneShadowSprite)
	call DrawEntity16x16
;>@n     oam[first].x += 1; oam[first + 1].x -= 1   # (OAM entries at $C030)
	pop af
	ld e, a
	ld d, b
	ld hl, wOAMBuffer + $31
	add hl, de
	inc [hl]
;=@n
	inc hl
	inc hl
	inc hl
	inc hl
	dec [hl]

.buttons
;> oam = 0xC020                                 # entries reserved for the buttons
	ld hl, wOAMBuffer + $20
;>@b0 oam[0] = 0x50, 0x28, 0x7A, wEntityScratch2   # first button, top half
	ld a, $50
	ld [hli], a
	ld a, $28
	ld [hli], a
;=@b0
	ld a, $7a
	ld [hli], a
	ld a, [wEntityScratch2]
	ld [hli], a
;>@b1 oam[1] = 0x60, 0x28, 0x3E, wEntityScratch2   # bottom half
	ld a, $60
	ld [hli], a
	ld a, $28
	ld [hli], a
;=@b1
	ld a, $3e
	ld [hli], a
	ld a, [wEntityScratch2]
	ld [hli], a
;>@b2 oam[2] = 0x50, 0x30, 0x7C, wEntityScratch3   # second button
	ld a, $50
	ld [hli], a
	ld a, $30
	ld [hli], a
;=@b2
	ld a, $7c
	ld [hli], a
	ld a, [wEntityScratch3]
	ld [hli], a
;>@b3 oam[3] = 0x60, 0x30, 0x3E, wEntityScratch3
	ld a, $60
	ld [hli], a
	ld a, $30
	ld [hli], a
;=@b3
	ld a, $3e
	ld [hli], a
	ld a, [wEntityScratch3]
	ld [hli], a
;> return
	ret


;@ path: minigame/trendy-game
;@ Sprites of the small prizes, one 8x16 sprite each (tile, attributes) by variant: 0 none, 1 $9E, 2
;@ the 30 Rupees, 3 the Magic Powder, 4 the Shield, 5 the Heart. 12 bytes.
TrendyPrizeSprites::
	db $ff, $ff, $9e, $10, $a6, $10, $8e, $10, $86, $10, $a8, $10

;@ path: minigame/trendy-game
;@ The Yoshi Doll, a 16x16 prize (variant 0).
TrendyYoshiDollSprite::
	db $9a, $10, $9c, $10
;@ path: minigame/trendy-game
;@ Marin hanging from the claw, two 16x16 pictures (the second mirrored); the code reads them as
;@ variants 6 and 7 of this table minus $18 / $14 bytes.
TrendyMarinSprites::
	db $6c, $00, $6e, $00, $6e, $20, $6c, $20

;@ def TrendyPrize(slot: c)
;@ path: minigame/trendy-game
;@ A prize of the Trendy Game (entity $4F with wEntityPrivate1 set), its kind in the sprite variant
;@ (TrendyPrizeVariant). The Yoshi Doll is gone once Link has a trade item, the Magic Powder while he
;@ carries the toadstool. Variants 6 and 7 are Marin caught by the crane (6 swinging, 7 still).
;@ test: skip dispatches through a jump table
TrendyPrize::
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v >= 6:                                   # Marin
	cp $06
	jr c, .item
;>@m     sprites = TrendyMarinSprites - 0x18 if v == 7 or hFrameCounter & 0x10 else TrendyMarinSprites - 0x14
	ld de, TrendyMarinSprites - $18
	cp $07
	jr z, .marin
	ldh a, [hFrameCounter]
	and $10
	jr nz, .marin
;=@m
	ld de, TrendyMarinSprites - $14

.marin
	jr .draw16

.item
;> elif v == 3:                                 # the Magic Powder
	cp $03
	jr nz, .doll
;>     if wHasToadstool: return DespawnEntity_04(slot)
	ld a, [wHasToadstool]
	and a
	jp nz, DespawnEntity_04
;>     return draw_small()
	jr .draw8

.doll
;> elif v == 0:                                 # the Yoshi Doll
	cp $00
	jr nz, .draw8
;>     if wTradeSequenceItem: return DespawnEntity_04(slot)
	ld a, [wTradeSequenceItem]
	and a
	jp nz, DespawnEntity_04
;>     sprites = TrendyYoshiDollSprite
	ld de, TrendyYoshiDollSprite

.draw16
;> DrawEntity16x16(slot, sprites)                     # (the big pictures)
	call DrawEntity16x16
	jr .run

.draw8
;> DrawEntity8x16(slot, TrendyPrizeSprites)          # (the small prizes)
	ld de, TrendyPrizeSprites
	call DrawEntity8x16

.run
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> return TrendyPrizeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: minigame/trendy-game
;@ States of a prize.
TrendyPrizeStates::
	dw TrendyPrizeConveyor
	dw TrendyPrizeCarried
	dw TrendyPrizeDropped
	dw TrendyPrizeOut
	dw TrendyPrizeMarinCaught
	dw TrendyPrizeFreeze

;@ def TrendyPrizeConveyor(slot: bc)
;@ path: minigame/trendy-game
;@ State 0: the prize rides the conveyor round the rectangle x $3A-$78, y $2E-$4E, turning at its
;@ corners.
;@ test: slot = rand(0, 15)
TrendyPrizeConveyor::
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> return TrendyPrizeConveyorTurns[wEntityDirection[slot]](slot)
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: minigame/trendy-game
;@ Corner checks by conveyor direction (0 left, 1 down, 2 right, 3 up, 4 still).
TrendyPrizeConveyorTurns::
	dw TrendyPrizeGoingLeft
	dw TrendyPrizeGoingDown
	dw TrendyPrizeGoingRight
	dw TrendyPrizeGoingUp
	dw TrendyPrizeStill

;@ def TrendyPrizeGoingLeft(slot: c)
;@ path: minigame/trendy-game
;@ Moving left: turns down at x $3A.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyPrizeGoingLeft::
;> if hActiveEntityX < 0x3A: return TrendyPrizeTurn(slot)
	ldh a, [hActiveEntityX]
	cp $3a
	jp c, TrendyPrizeTurn
;> TrendyPrizeStill(slot)                       # (falls through)

;@ def TrendyPrizeStill(slot: c)
;@ path: minigame/trendy-game
;@ Direction 4: a prize that does not move.
;@ test: slot = rand(0, 15)
TrendyPrizeStill::
;> return
	ret


;@ def TrendyPrizeGoingDown(slot: c)
;@ path: minigame/trendy-game
;@ Moving down: turns right at y $4E.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyPrizeGoingDown::
;> if hActiveEntityDrawY >= 0x4E: return TrendyPrizeTurn(slot)
	ldh a, [hActiveEntityDrawY]
	cp $4e
	jp nc, TrendyPrizeTurn
;> return
	ret


;@ def TrendyPrizeGoingRight(slot: c)
;@ path: minigame/trendy-game
;@ Moving right: turns up at x $78.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyPrizeGoingRight::
;> if hActiveEntityX >= 0x78: return TrendyPrizeTurn(slot)
	ldh a, [hActiveEntityX]
	cp $78
	jp nc, TrendyPrizeTurn
;> return
	ret


;@ def TrendyPrizeGoingUp(slot: c)
;@ path: minigame/trendy-game
;@ Moving up: turns left at y $2E.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyPrizeGoingUp::
;> if hActiveEntityDrawY < 0x2E: return TrendyPrizeTurn(slot)
	ldh a, [hActiveEntityDrawY]
	cp $2e
	jp c, TrendyPrizeTurn
;> return
	ret


;@ def TrendyPrizeCarried(slot: c)
;@ path: minigame/trendy-game
;@ State 1, hanging from the claw (the owner moves it); when Marin plays, Link turns away from it.
;@ test: skip turns Link through bank-2 code
TrendyPrizeCarried::
;> TrendyGameTurnLink(GetEntityDirectionToLink_04(slot) ^ 1)
	call GetEntityDirectionToLink_04
	ld a, e
	xor $01
	ld e, a
	call TrendyGameTurnLink
;> return
	ret


;@ def TrendyPrizeDropped(slot: bc)
;@ path: minigame/trendy-game
;@ State 2, dropped into the chute: it falls and bounces (the bounce halves each time; under 7 it stops,
;@ else a bounce jingle) while sliding down one pixel every 4 frames to y $56; there it drops out of the
;@ machine ($0A lower, $0A high, state 3).
;@ test: slot = rand(0, 15)
TrendyPrizeDropped::
;> if wIsMarinFollowingLink: hLinkInteractiveMotionBlocked = 2
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .fall
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a

.fall
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> wEntitySpeedZ[slot] -= 2                     # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                    # hit the floor
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .slide
;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntitySpeedZ[slot] = ~(wEntitySpeedZ[slot] >> 1)   # bounce at half speed
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
;>     if wEntitySpeedZ[slot] < 7: wEntitySpeedZ[slot] = 0
	cp $07
	jr nc, .bounce
	ld [hl], b
	jr .slide
.bounce
;>     else: hJingle = 9
	ld a, $09
	ldh [hJingle], a

.slide
;> if hFrameCounter & 3: return
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;> if wEntityY[slot] != 0x56:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $56
	jr z, .out
;>     wEntityY[slot] += 1
	inc a
	ld [hl], a

.done
;>     return
	ret

.out
;> wEntityY[slot] += 0x0A                       # out of the machine
	add $0a
	ld [hl], a
;> wEntityZ[slot] = 0x0A
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $0a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> return
	ret


;@ path: minigame/trendy-game
;@ What the owner says for each prize Link picks up, by variant: 0 the Yoshi Doll ($44, not used: the
;@ doll is handed over), 1 "Cough Cough" ($43), 2 30 Rupees ($42), 3 Magic Powder ($41), 4 Shield
;@ ($3D), 5 Heart ($2A).
TrendyPrizeTexts::
	db $44, $43, $42, $41, $3d, $2a

;@ def TrendyPrizeOut(slot: c)
;@ path: minigame/trendy-game
;@ State 3, out of the machine: it bounces to rest. Marin (variant 6 / 7) lands with "You're good! ...
;@ Pros aren't allowed in here!" ($F9, state 4). Link takes a prize by touching it (once per $18
;@ frames, using the owner's wEntityDyingTimer): the Yoshi Doll becomes his trade item (held up), the
;@ others give their text and effect: 30 rupees, 10 doses of Magic Powder (up to the maximum, with the
;@ powder item), the Shield, or a full heart refill.
;@ test: skip opens a dialogue and gives items
TrendyPrizeOut::
;> if wIsMarinFollowingLink: hLinkInteractiveMotionBlocked = 2
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .fall
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a

.fall
;> AddEntityZSpeedToPos_04(slot)
	call AddEntityZSpeedToPos_04
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if not wEntityZ[slot] & 0x80: return         # in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jp z, .done
;> wEntityZ[slot] = 0
	xor a
	ld [hl], a
;> wEntitySpeedZ[slot] = ~(wEntitySpeedZ[slot] >> 1)
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
;> if wEntitySpeedZ[slot] < 7: wEntitySpeedZ[slot] = 0
	cp $07
	jr nc, .landed
	xor a
	ld [hl], a

.landed
;> if hActiveEntitySpriteVariant >= 6:          # Marin
	ldh a, [hActiveEntitySpriteVariant]
	cp $06
	jr c, .touch
;>     OpenDialog(0xF9)
	ld a, $f9
	call OpenDialog
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.touch
;> if abs(hActiveEntityX - hLinkX) >= 7: return
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $07
	cp $0e
	ret nc
;> if abs(hActiveEntityDrawY - hLinkY) >= 5: return
	ldh a, [hActiveEntityDrawY]
	ld hl, hLinkY
	sub [hl]
	add $05
	cp $0a
	ret nc
;> owner = wSongShowTimer                     # ($D210) the owner's slot
	ld a, [wSongShowTimer]
	ld e, a
	ld d, b
;> if wEntityDyingTimer[owner] != 0: return     # just took one
	ld hl, wEntityDyingTimer
	add hl, de
	ld a, [hl]
	and a
	ret nz
;> wEntityDyingTimer[owner] = 0x18
	ld [hl], $18
;> if hActiveEntitySpriteVariant == 0:          # the Yoshi Doll
	ldh a, [hActiveEntitySpriteVariant]
	cp $00
	jr nz, .item
;>     wTradeSequenceItem = 1
	ld a, $01
	ld [wTradeSequenceItem], a
;>     SpawnHeldItemEntity()                    # Link holds it up
	call SpawnHeldItemEntity
;>     return DespawnEntity_04(slot)
	jp DespawnEntity_04

.item
;> DespawnEntity_04(slot)
	call DespawnEntity_04
;> hWaveSfx = 1
	ld hl, hWaveSfx
	ld [hl], $01
;>@t OpenDialog(mem[TrendyPrizeTexts + hActiveEntitySpriteVariant])
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, TrendyPrizeTexts
	add hl, de
	ld a, [hl]
;=@t
	call OpenDialog
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v == 1: return
	dec a
	jr nz, .rupees
	ret

.rupees
;> if v == 2:                                   # 30 rupees
	dec a
	jr nz, .powder
;>     wAddRupeeBufferLow += 30
	ld a, [wAddRupeeBufferLow]
	add $1e
	ld [wAddRupeeBufferLow], a
;>     return
	ret

.powder
;> if v == 3:                                   # Magic Powder
	dec a
	jr nz, .shield
;>     n = wMagicPowderCount
	ld hl, wMaxMagicPowder
	ld a, [wMagicPowderCount]
;>@p     if n < wMaxMagicPowder: n = min(n + 0x10, wMaxMagicPowder)   # (BCD) 10 more
	cp [hl]
	jr nc, .setPowder
	add $10
	daa
	cp [hl]
	jr c, .setPowder
;=@p
	ld a, [hl]
.setPowder
;>     wMagicPowderCount = n
	ld [wMagicPowderCount], a
;>     GiveInventoryItemFar(0x0C)                          # bank 3 GiveInventoryItem: the powder
	ld d, $0c
	call GiveInventoryItemFar
;>     hBGChangeRequest = 0x0B
	ld a, $0b
	ldh [hBGChangeRequest], a
;>     return
	ret

.shield
;> if v == 4:                                   # the Shield
	dec a
	jr nz, .heart
;>     return GiveInventoryItemFar(4)                      # GiveInventoryItem
	ld d, $04
	call GiveInventoryItemFar
	ret

.heart
;> wAddHealthBuffer = 0xFF                      # a full refill
	ld a, $ff
	ld [wAddHealthBuffer], a

.done
;> return
	ret


;@ def TrendyPrizeMarinCaught(slot: c)
;@ path: minigame/trendy-game
;@ State 4, after Marin's catch: Link stays frozen until the owner's words are over; then Marin stops
;@ waiting (wIsMarinInAnimalVillage = 0), $C1BC is set to $18 and the prize goes to state 5.
;@ test: slot = rand(0, 15)
TrendyPrizeMarinCaught::
;> hLinkInteractiveMotionBlocked = 2
;> wLinkFrozen = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
;> if wCanTalkToEntity != 0: return
	ld a, [wCanTalkToEntity]
	and a
	ret nz
;> wIsMarinInAnimalVillage = 0
	ld [wIsMarinInAnimalVillage], a
;> wScriptedWarpTimer = 0x18
	ld a, $18
	ld [wScriptedWarpTimer], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def TrendyPrizeFreeze(slot: c)
;@ path: minigame/trendy-game
;@ State 5: keeps Link frozen.
;@ test: slot = rand(0, 15)
TrendyPrizeFreeze::
;> hLinkInteractiveMotionBlocked = 2
;> wLinkFrozen = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
;> return
	ret


;@ path: minigame/trendy-game
;@ Conveyor speeds by direction: x speed at direction n (-4, 0, 4, 0, 0) and y speed at n + 5 (0, 4, 0,
;@ -4, 0); directions 0 left, 1 down, 2 right, 3 up, 4 still. 10 bytes.
TrendyPrizeSpeeds::
	db $fc, $00, $04, $00, $00, $00, $04, $00, $fc, $00

;@ def TrendyPrizeTurn(slot: bc)
;@ path: minigame/trendy-game
;@ At a corner of the conveyor: turns to the next direction (left, down, right, up) and sets the speed.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
TrendyPrizeTurn::
;> wEntityDirection[slot] = (wEntityDirection[slot] + 1) & 3
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
;> SetTrendyPrizeSpeed(slot, wEntityDirection[slot])   # (falls through)

;@ def SetTrendyPrizeSpeed(slot: bc, direction: a)
;@ path: minigame/trendy-game
;@ Sets the prize's speed for its conveyor direction.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $04
SetTrendyPrizeSpeed::
;>@x wEntitySpeedX[slot] = mem[TrendyPrizeSpeeds + direction]
	ld e, a
	ld d, b
	ld hl, TrendyPrizeSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
;=@x
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[TrendyPrizeSpeeds + direction + 5]
	ld hl, TrendyPrizeSpeeds + 5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def Entity4E(slot: c)
;@ path: npc/entity-4e
;@ Entity $4E: a figure drawn like the shop owner that turns to Link, blocks him and, talked to, says
;@ dialogue $39 ("It sounds like the castle gate opened!") during the first frames of a room
;@ (wRoomLoadCounter < 3), else $3A (the Trendy Game's offer).
;@ test: skip opens a dialogue
Entity4E::
;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .walk
;>     wEntityDirection[slot] = GetEntityDirectionToLink_04(slot)
	call GetEntityDirectionToLink_04
	ld a, e
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

.walk
;> AnimateEntityWalking_04(slot)
	call AnimateEntityWalking_04
;> DrawEntity16x16(slot, ShopOwnerSprites)
	ld de, ShopOwnerSprites
	call DrawEntity16x16
;> BlockLinkAtEntity_04(slot)
	call BlockLinkAtEntity_04
;> if CanTalkToEntity_04(slot):
	call CanTalkToEntity_04
	jr nc, .done
;>     OpenDialog(0x39 if wRoomLoadCounter < 3 else 0x3A)
	ld a, [wRoomLoadCounter]
	cp $03
	ld a, $39
	jr c, .text
	inc a
.text
	call OpenDialog

.done
;> return
	ret


;@ path: npc/shop-owner
;@ Sprites of the shop owner (also the Trendy Game owner and entity $4E): 8 variants of a 16x16 entity
;@ (left tile, attributes, right tile, attributes; $20 = x flip), two walking frames for each direction
;@ (variant = WalkingFrameByDirection_04[direction] + frame).
ShopOwnerSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

;@ def ShopOwner(slot: c)
;@ path: npc/shop-owner
;@ Entity $4D, the owner of the Mabe Village shop. He draws the shelf prices once, turns to Link (only
;@ now and then once Link has a sword, so he can sneak out), draws the shelf items and the one Link
;@ carries, blocks Link (until the punishment) and runs his states.
;@ test: skip dispatches through a jump table
ShopOwner::
;> if wItemButtonsDisabled == 0:
	ld a, [wItemButtonsDisabled]
	and a
	jr nz, .face
;>     wItemButtonsDisabled = 1
	ld a, $01
	ld [wItemButtonsDisabled], a
;>     ShopDrawPrices()
	call ShopDrawPrices

.face
;> if wSwordLevel == 0 or hFrameCounter & 0x5F == 0:
	ld a, [wSwordLevel]
	and a
	jr z, .turn
	ldh a, [hFrameCounter]
	and $5f
	jr nz, .walk

.turn
;>     wEntityDirection[slot] = GetEntityDirectionToLink_04(slot)
	call GetEntityDirectionToLink_04
	ld a, e
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

.walk
;> AnimateEntityWalking_04(slot)
	call AnimateEntityWalking_04
;> DrawEntity16x16(slot, ShopOwnerSprites)
	ld de, ShopOwnerSprites
	call DrawEntity16x16
;> ShopDrawShelfItems()
	call ShopDrawShelfItems
;> if hActiveEntityState < 4: BlockLinkAtEntity_04(slot)
	ldh a, [hActiveEntityState]
	cp $04
	jr nc, .state
	call BlockLinkAtEntity_04

.state
;> return ShopOwnerStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/shop-owner
;@ States of the shop owner.
ShopOwnerStates::
	dw ShopOwnerSetup
	dw ShopOwnerWaiting
	dw ShopOwnerAnswer
	dw ShopOwnerRefused
	dw ShopOwnerPunish
	dw ShopOwnerAfterPunish

;@ path: npc/shop-owner
;@ Draw commands that write the price under a shelf item, 11 bytes per item 1-6 (VRAM address high,
;@ low, count - 1, tiles): the price digits on one row and the rupee sign's row below. Items 7-9 have
;@ none (they are never on sale). 66 bytes and a 0.
ShopPriceCommands::
	db $98, $63, $02, $b2, $b0, $b0, $98, $a4, $01, $7f, $7f
	db $98, $67, $02, $b1, $b0, $7f, $98, $a8, $01, $0a, $b3
	db $98, $6a, $02, $7f, $b2, $b0, $98, $ac, $01, $ba, $b1
	db $98, $6e, $02, $b1, $b0, $7f, $98, $b0, $01, $0a, $09
	db $98, $63, $02, $b9, $b8, $b0, $98, $a4, $01, $7f, $7f
	db $98, $63, $02, $b1, $b0, $7f, $98, $a4, $01, $0a, $09
	db $00

;@ path: npc/shop-owner
;@ Draw commands that blank the price under each of the four shelf places once its item is picked up,
;@ 16 bytes per place (13 used: three runs of blank tiles $7F and the end mark).
ShopShelfClearCommands::
	db $98, $62, $43, $7f, $98, $83, $42, $7f, $98, $a3, $42, $7f, $00, $00, $00, $00
	db $98, $66, $43, $7f, $98, $87, $42, $7f, $98, $a7, $42, $7f, $00, $00, $00, $00
	db $98, $6a, $43, $7f, $98, $8b, $42, $7f, $98, $ab, $42, $7f, $00, $00, $00, $00
	db $98, $6e, $43, $7f, $98, $8f, $42, $7f, $98, $af, $42, $7f, $00, $00, $00, $00

;@ path: npc/shop-owner
;@ What is on the four shelf places, 4 bytes per set: 0 at first (shovel, three hearts, shield,
;@ nothing), 1 once the bombs are on sale (after the Bottle Grotto instrument), 2 once Link has the shovel
;@ (the bow replaces it), 3 once he has the bow (ten arrows instead). The fifth set (the never-sold
;@ items 7-10) is not used.
ShopShelfSets::
	db $01, $02, $03, $00
	db $01, $02, $03, $04
	db $05, $02, $03, $04
	db $06, $02, $03, $04
	db $07, $08, $09, $0a

;@ path: npc/shop-owner
;@ The owner's offer for items 1-9 (read at item - 1): $30 Deluxe Shovel 200 Rupees, $31 Three
;@ Hearts, $32 Shield, $33 Ten Bombs, $2C Bow & Arrow Set 980 Rupees, $2D 10 Arrows; item 7 $39, items
;@ 8 and 9 none. 9 bytes and a 0.
ShopItemTexts::
	db $30, $31, $32, $33, $2c, $2d, $39, $00, $00, $00

;@ path: npc/shop-owner
;@ Prices in BCD as Link must have them, by item (index 0 unused): high bytes ...
ShopPriceHigh::
	db $00, $02, $00, $00, $00, $09, $00, $00, $00

;@ path: npc/shop-owner
;@ ... and low bytes (item 1 200, 2 10, 3 20, 4 10, 5 980, 6 10; 7-9 free; item 9's byte is the
;@ first of ShopCostHigh).
ShopPriceLow::
	db $00, $00, $10, $20, $10, $80, $10, $00, $00

;@ path: npc/shop-owner
;@ The same prices as plain numbers, added to wSubtractRupeeBuffer when Link pays: high bytes ...
ShopCostHigh::
	db $00, $00, $00, $00, $00, $03, $00, $00, $00

;@ path: npc/shop-owner
;@ ... and low bytes ($C8 = 200, $0A = 10, $14 = 20, $3D4 = 980).
ShopCostLow::
	db $00, $c8, $0a, $14, $0a, $d4, $0a, $00, $00, $00

;@ def ShopOwnerSetup(slot: c)
;@ path: npc/shop-owner
;@ State 0. A thief coming back (wShopPunishThief) is walked up into the shop at the end of the room
;@ transition (to y $74) and gets "I wasn't kidding when I said pay! Now, you'll pay the ultimate
;@ price!!" ($38) with music $19 (state 4). Otherwise the shelves are filled: the set grows with the
;@ Bottle Grotto instrument (bombs), Link's shovel (the bow instead) and his bow (arrows instead;
;@ a shovel or bow given away in the boomerang trade counts as well); then the prices are drawn.
;@ test: skip opens a dialogue
ShopOwnerSetup::
;> if wShopPunishThief:
	ld a, [wShopPunishThief]
	and a
	jr z, .stock
;>     wEntityY[slot] = 0x40
;>     wEntityX[slot] = 0x50
	ld hl, wEntityY
	add hl, bc
	ld [hl], $40
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
;>     wEntityDirection[slot] = 3               # facing down
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
;>     hLinkInteractiveMotionBlocked = 2
;>     wLinkFrozen = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
;>     if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>         hLinkY -= 1                          # Link walks in
	ldh a, [hLinkY]
	sub $01
	ldh [hLinkY], a
;>         if hLinkY == 0x74:
	cp $74
	jr nz, .done
;>             OpenDialog(0x38)
	ld a, $38
	call OpenDialog
;>             wEntityState[slot] = 4
	ld hl, wEntityState
	add hl, bc
	ld [hl], $04
;>             wMusicTrackToPlay = 0x19
	ld a, $19
	ld [wMusicTrackToPlay], a

.done
;>     return
	ret

.stock
;> set = 0
	ld e, $00
	ld d, b
;> if wHasInstrument2 & 2: set = 4
	ld a, [wHasInstrument2]
	and $02
	jr z, .shovel
	ld e, $04

.shovel
;>@l for i in range(11, -1, -1):               # the 12 inventory places
	push bc
	ld hl, wItemB
	ld c, $0b

.findShovel
;>@s     if wBoomerangTradedItem == 0x0B or wItemB[i] == 0x0B: set = 8   # (the shovel)
	ld a, [wBoomerangTradedItem]
	cp $0b
	jr z, .hasShovel
	ld a, [hli]
	cp $0b
	jr nz, .nextShovel
.hasShovel
;=@s
	ld e, $08

.nextShovel
;=@l
	dec c
	ld a, c
	cp $ff
	jr nz, .findShovel
;>@m for i in range(11, -1, -1):
	ld hl, wItemB
	ld c, $0b

.findBow
;>@b     if wBoomerangTradedItem == 0x05 or wItemB[i] == 0x05: set = 12  # (the bow)
	ld a, [wBoomerangTradedItem]
	cp $05
	jr z, .hasBow
	ld a, [hli]
	cp $05
	jr nz, .nextBow
.hasBow
;=@b
	ld e, $0c

.nextBow
;=@m
	dec c
	ld a, c
	cp $ff
	jr nz, .findBow
;>@c wShopShelfItems[0:4] = ShopShelfSets[set:set + 4]
	ld hl, ShopShelfSets
	add hl, de
	ld de, wShopShelfItems
	ld c, $04

.copy
	ld a, [hli]
	ld [de], a
;=@c
	inc de
	dec c
	jr nz, .copy
	pop bc
;> wEntityState[slot] += 1
	call IncrementEntityState
;> ShopDrawPrices()
	call ShopDrawPrices
;> return
	ret


;@ def ShopDrawPrices()
;@ path: npc/shop-owner
;@ Queues the price of every item on the shelves as draw commands (one after the other in
;@ wDrawCommand).
;@ test: skip queues draw commands
ShopDrawPrices::
;> dest = wDrawCommand
	ld de, wDrawCommand
;>@l for item in wShopShelfItems:
	push bc
	ld hl, wShopShelfItems
	ld c, $04

.loop
	ld a, [hli]
;>     if item: dest = ShopCopyPriceCommand(item, dest)
	and a
	jr z, .next
	push hl
	call ShopCopyPriceCommand
	pop hl

.next
;=@l
	dec c
	jr nz, .loop
	pop bc
;> return
	ret


;@ path: npc/shop-owner
;@ The shelf place (0-3) Link stands at, by his x / 16. 10 bytes.
ShopShelfByX::
	db $00, $00, $00, $01, $01, $02, $02, $03, $03, $03

;@ def ShopOwnerWaiting(slot: c)
;@ path: npc/shop-owner
;@ State 1. Walking out with an item while the owner looks his way (left or down), Link is pushed back
;@ with "Hey! You! Stop! You gotta pay! Put it back!" ($2F). At the shelves (above y $48, facing up)
;@ A or B takes the item there (and blanks its price) or puts the carried item back on its own place.
;@ Talking to the owner: with an item, his offer for it (state 2); without, "Hey! Welcome!" ($2E).
;@ test: skip opens a dialogue
ShopOwnerWaiting::
;>@e if wShopItemCarried and wEntityDirection[slot] & 1 and wLinkMotionState == 0 and hLinkY >= 0x7B:
	ld a, [wShopItemCarried]
	and a
	jr z, .shelves
;=@e
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	jr z, .shelves
;=@e
	ld a, [wLinkMotionState]
	cp $00
	jr nz, .shelves
	ldh a, [hLinkY]
	cp $7b
	jr c, .shelves
;>     hLinkY -= 2                              # pushed back from the door
	sub $02
	ldh [hLinkY], a
;>     return OpenDialog(0x2F)
	ld a, $2f
	jp OpenDialog

.shelves
;>@s if hLinkY < 0x48 and hLinkDirection == 2 and hJoypadPressed & 0x30:   # at a shelf, A or B
	ldh a, [hLinkY]
	cp $48
	jr nc, .talk
;=@s
	ldh a, [hLinkDirection]
	cp $02
	jr nz, .talk
;=@s
	ldh a, [hJoypadPressed]
	and $30
	jr z, .talk
;>     if wShopItemCarried:
	ld a, [wShopItemCarried]
	and a
	jr z, .take
;>@p         if mem[ShopShelfByX + (hLinkX >> 4)] == wShopCarriedShelf:   # its own place
	ldh a, [hLinkX]
	add $00
	swap a
	and $0f
	ld e, a
	ld d, b
;=@p
	ld hl, ShopShelfByX
	add hl, de
	ld a, [wShopCarriedShelf]
	cp [hl]
	jr nz, .talk
;>             hJingle = 0x13
	ld a, $13
	ldh [hJingle], a
;>             return ShopPutItemBack(slot)
	jp ShopPutItemBack

.take
;>@t     shelf = mem[ShopShelfByX + (hLinkX >> 4)]
;>     wShopCarriedShelf = mem[ShopShelfByX + (hLinkX >> 4)]
	ldh a, [hLinkX]
	add $00
	swap a
	and $0f
	ld e, a
	ld d, b
;=@t
	ld hl, ShopShelfByX
	add hl, de
	ld a, [hl]
	ld [wShopCarriedShelf], a
;>@w     wShopItemCarried = wShopShelfItems[shelf]; wShopShelfItems[shelf] = 0
	ld e, a
	ld d, b
	ld hl, wShopShelfItems
	add hl, de
	ld a, [hl]
	ld [wShopItemCarried], a
;=@w
	ld [hl], b
;>     if wShopItemCarried: hJingle = 0x13
	and a
	jr z, .blank
	ld a, $13
	ldh [hJingle], a

.blank
;>@c     wDrawCommand[0:13] = ShopShelfClearCommands[shelf * 16:]   # blank its price
	push bc
	ld a, e
	swap a
	ld e, a
	ld hl, ShopShelfClearCommands
	add hl, de
;=@c
	ld de, wDrawCommand
	ld c, $0d

.copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
;=@c
	jr nz, .copy
	pop bc

.talk
;> if CanTalkToEntityWide_04(slot):
	call CanTalkToEntityWide_04
	jr nc, .done
;>     if wShopItemCarried:
	ld a, [wShopItemCarried]
	and a
	jr z, .welcome
;>@o         OpenDialog(mem[ShopItemTexts + (wShopItemCarried - 1)])
	dec a
	ld e, a
	ld d, b
	ld hl, ShopItemTexts
	add hl, de
	ld a, [hl]
;=@o
	call OpenDialog
;>         wEntityState[slot] += 1
	call IncrementEntityState
;>         return
	ret

.welcome
;>     else: OpenDialog(0x2E)
	ld a, $2e
	call OpenDialog

.done
;> return
	ret


;@ def ShopOwnerAnswer(slot: c)
;@ path: npc/shop-owner
;@ State 2: after the offer, "Buy" goes on to the purchase, the other answer puts the item back.
;@ test: skip opens a dialogue
ShopOwnerAnswer::
;> if wDialogState != 0: return
	ld a, [wDialogState]
	and a
	ret nz
;> if wDialogAnswer == 0: return ShopBuyItem(slot)
	ld a, [wDialogAnswer]
	cp $00
	jr z, ShopBuyItem
;> if wDialogAnswer == 2: return waiting()
	cp $02
	jr z, ShopPutItemBack.waiting
;> ShopPutItemBack(slot)                        # (falls through)

;@ def ShopPutItemBack(slot: c)
;@ path: npc/shop-owner
;@ Link's item goes back to its shelf place, its price is drawn again, and the owner waits (state 1).
;@ test: skip queues draw commands
ShopPutItemBack::
;>@b wShopShelfItems[wShopCarriedShelf] = wShopItemCarried
	ld a, [wShopCarriedShelf]
	ld e, a
	ld d, b
	ld hl, wShopShelfItems
	add hl, de
	ld a, [wShopItemCarried]
;=@b
	ld [hl], a
;> ShopCopyPriceCommand(wShopItemCarried, wDrawCommand)
	ld de, wDrawCommand
	call ShopCopyPriceCommand
;> wShopItemCarried = 0
	xor a
	ld [wShopItemCarried], a

.waiting
;> wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;> return
	ret


;@ def ShopCopyPriceCommand(item: a, dest: de) -> de
;@ path: npc/shop-owner
;@ Copies the item's 11-byte price command from ShopPriceCommands to dest and ends it with a 0 (dest is
;@ left on that 0, so a following command overwrites it).
ShopCopyPriceCommand::
;>@i hl = ShopPriceCommands + (item - 1) * 11
	push de
	dec a
	ld d, a
	sla a
	ld e, a
	sla a
;=@i
	sla a
	add e
	add d
	ld e, a
	ld d, b
	ld hl, ShopPriceCommands
;=@i
	add hl, de
	pop de
;>@c dest[0:11] = hl[0:11]
	push bc
	ld c, $0b

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@c
	dec c
	jr nz, .copy
;> dest[0] = 0
	xor a
	ld [de], a
	pop bc
;> return
	ret


;@ def ShopBuyItem(slot: c)
;@ path: npc/shop-owner
;@ "Buy": things Link cannot use get "Aye Caramba! ... trying to buy something you have no use for!"
;@ ($29): three hearts at full health, bombs or arrows already at their maximum, a second shield. Too
;@ few rupees: "Sorry, kid!" ($34). Both lead to state 3. Otherwise the price is taken (BCD check
;@ against ShopPrice, the plain amount from ShopCost into wSubtractRupeeBuffer), "Thanks a lot!" ($35),
;@ and the item is given.
;@ test: skip opens a dialogue and gives items
ShopBuyItem::
;> item = wShopItemCarried
	ld a, [wShopItemCarried]
	ld e, a
;> if item == 2:                                # three hearts
	cp $02
	jr nz, .bombs
;>     if wHealthIsFull: return useless()
	ld a, [wHealthIsFull]
	and a
	jr nz, .useless
;>     return pay()
	jr .pay

.bombs
;> if item == 4:                                # ten bombs
	cp $04
	jr nz, .arrows
;>@l     for i in range(12):
	ld hl, wItemB
	ld d, $0c

.findBombs
;>         if wItemB[i] == 2: return has_bombs()
	ld a, [hli]
	cp $02
	jr z, .hasBombs
;=@l
	dec d
	jr nz, .findBombs
;>     return pay()                            # (no bombs yet)
	jr .pay

.hasBombs
;>     if wBombCount >= wMaxBombs: return useless()
	ld a, [wBombCount]
	ld hl, wMaxBombs
	cp [hl]
	jr nc, .useless
;>     return pay()
	jr .pay

.arrows
;> if item == 6:                                # ten arrows
	cp $06
	jr nz, .shield
;>@m     for i in range(12):
	ld hl, wItemB
	ld d, $0c

.findBow
;>         if wItemB[i] == 5: return has_bow()
	ld a, [hli]
	cp $05
	jr z, .hasBow
;=@m
	dec d
	jr nz, .findBow
;>     return pay()
	jr .pay

.hasBow
;>     if wArrowCount >= wMaxArrows: return useless()
	ld a, [wArrowCount]
	ld hl, wMaxArrows
	cp [hl]
	jr nc, .useless
;>     return pay()
	jr .pay

.shield
;> if item == 3:                                # the shield
	cp $03
	jr nz, .pay
;>@n     for i in range(12):
	ld hl, wItemB
	ld d, $0c

.findShield
;>         if wItemB[i] == 4: return useless() # Link has one
	ld a, [hli]
	cp $04
	jr nz, .nextShield

.useless
;> text = 0x29
	ld a, $29
	jr .refuse

.nextShield
;=@n
	dec d
	jr nz, .findShield

.pay
;>@p price = mem[ShopPriceHigh + item] << 8 | mem[ShopPriceLow + item]
	ld d, b
	ld hl, ShopPriceHigh
	add hl, de
	ld a, [hl]
	ld hl, ShopPriceLow
	add hl, de
;=@p
	ld e, [hl]
	ld d, a
;> if wRupeeCount >= price: return buy()      # (BCD)
	ld a, [wRupeeCountLow]
	sub e
	ld a, [wRupeeCountHigh]
	sbc d
	jr nc, .buy
;> text = 0x34                                  # not enough rupees
	ld a, $34

.refuse
;> OpenDialog(text)
	call OpenDialog
;> wEntityState[slot] = 3
	ld hl, wEntityState
	add hl, bc
	ld [hl], $03
;> return
	ret

.buy
;> item = wShopItemCarried; wShopItemCarried = 0
	ld hl, wShopItemCarried
	ld a, [hl]
	push af
	ld [hl], $00
	ld e, a
	ld d, b
;>@s wSubtractRupeeBuffer += mem[ShopCostHigh + item] << 8 | mem[ShopCostLow + item]
	ld hl, ShopCostLow
	add hl, de
	ld a, [wSubtractRupeeBufferLow]
	add [hl]
	ld [wSubtractRupeeBufferLow], a
	rl a
;=@s
	ld hl, ShopCostHigh
	add hl, de
	rr a
	ld a, [wSubtractRupeeBufferHigh]
	adc [hl]
	ld [wSubtractRupeeBufferHigh], a
;> wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;> OpenDialog(0x35)
	pop af
	push af
	ld a, $35
	call OpenDialog
	pop af
;> ShopGiveItem(item)                           # (falls through)

;@ def ShopGiveItem(item: a)
;@ path: npc/shop-owner
;@ Gives a bought item through ShopGiveItemTable.
;@ test: skip gives items
ShopGiveItem::
;> return ShopGiveItemTable[item - 1]()
	dec a
	rst $00

;@ path: npc/shop-owner
;@ What each shop item gives (items 1-9).
ShopGiveItemTable::
	dw ShopGiveShovel
	dw ShopGiveHearts
	dw ShopGiveShield
	dw ShopGiveBombs
	dw ShopGiveBow
	dw ShopGiveArrows
	dw ShopGiveItem7
	dw ShopGiveItem8
	dw ShopGiveMedicine

;@ def ShopGiveBow()
;@ path: npc/shop-owner
;@ Item 5, the bow (inventory item 5) with 20 arrows.
;@ test: skip gives an item through bank 3
ShopGiveBow::
;> GiveInventoryItemFar(5)                                 # GiveInventoryItem in bank 3
	ld d, $05
	call GiveInventoryItemFar
;> wArrowCount = 0x20                           # (BCD) 20
	ld a, $20
	ld [wArrowCount], a
;> return
	ret


;@ def ShopGiveArrows()
;@ path: npc/shop-owner
;@ Item 6, ten arrows (BCD, at most 99).
ShopGiveArrows::
;> wArrowCount = min(wArrowCount + 10, 99)     # BCD
	ld a, [wArrowCount]
	add $0a
	daa
	jr nc, .set
	ld a, $99
.set
	ld [wArrowCount], a
;> return
	ret


;@ def ShopGiveItem7()
;@ path: npc/shop-owner
;@ Item 7 (never on sale): inventory item 9.
;@ test: skip gives an item through bank 3
ShopGiveItem7::
;> return GiveInventoryItemFar(9)
	ld d, $09
	call GiveInventoryItemFar
	ret


;@ def ShopGiveItem8()
;@ path: npc/shop-owner
;@ Item 8 (never on sale): adds 10 (BCD, at most 99) to $DB47.
ShopGiveItem8::
;> mem[0xDB47] = min(mem[0xDB47] + 10, 99)     # BCD
	ld a, [$db47]
	add $0a
	daa
	jr nc, .set
	ld a, $99
.set
	ld [$db47], a
;> return
	ret


;@ def ShopGiveMedicine()
;@ path: npc/shop-owner
;@ Item 9 (never on sale): one more medicine.
ShopGiveMedicine::
;> wMedicineCount += 1                          # BCD
	ld a, [wMedicineCount]
	add $01
	daa
	ld [wMedicineCount], a
;> return
	ret


;@ def ShopGiveShovel()
;@ path: npc/shop-owner
;@ Item 1, the shovel (inventory item $0B).
;@ test: skip gives an item through bank 3
ShopGiveShovel::
;> return GiveInventoryItemFar(0x0B)
	ld d, $0b
	call GiveInventoryItemFar
	ret


;@ def ShopGiveBombs()
;@ path: npc/shop-owner
;@ Item 4, ten bombs (BCD, at most 99) and the bombs item.
;@ test: skip gives an item through bank 3
ShopGiveBombs::
;> wBombCount = min(wBombCount + 10, 99)       # BCD
	ld a, [wBombCount]
	add $0a
	daa
	jr nc, .set
	ld a, $99
.set
	ld [wBombCount], a
;> return GiveInventoryItemFar(2)
	ld d, $02
	call GiveInventoryItemFar
	ret


;@ path: npc/shop-owner
;@ Code that nothing calls, kept as bytes: ten more arrows (BCD, at most 99) and inventory item $0C (the
;@ Magic Powder) - `ld a, [wArrowCount] / add $0a / daa / jr nc / ld a, $99 / ld [wArrowCount], a /
;@ ld d, $0c / call GiveInventoryItemFar / ret`. 19 bytes.
ShopUnusedArrowsAndPowder::
	db $fa, $45, $db, $c6, $0a, $27, $30, $02, $3e, $99, $ea, $45, $db, $16, $0c, $cd
	db $95, $3e, $c9

;@ def ShopGiveHearts()
;@ path: npc/shop-owner
;@ Item 2, three hearts of health.
ShopGiveHearts::
;> wAddHealthBuffer = 0x18
	ld a, $18
	ld [wAddHealthBuffer], a
;> return
	ret


;@ def ShopGiveShield()
;@ path: npc/shop-owner
;@ Item 3, the shield (inventory item 4).
;@ test: skip gives an item through bank 3
ShopGiveShield::
;> return GiveInventoryItemFar(4)
	ld d, $04
	call GiveInventoryItemFar
	ret


;@ def ShopOwnerRefused(slot: c)
;@ path: npc/shop-owner
;@ State 3, after "Aye Caramba" or "Sorry, kid": when the words are over, the item goes back.
;@ test: slot = rand(0, 15)
ShopOwnerRefused::
;> if wDialogState == 0: ShopPutItemBack(slot)
	ld a, [wDialogState]
	and a
	jr nz, .done
	call ShopPutItemBack

.done
;> return
	ret


;@ def ShopOwnerPunish(slot: c)
;@ path: npc/shop-owner
;@ State 4, the thief's punishment: after the owner's words a bolt (entity $CA) strikes from the owner
;@ ($C0 frames), Link loses his medicine and all his health.
;@ test: skip spawns an entity
ShopOwnerPunish::
;> if wDialogState != 0: return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> bolt, full = SpawnEntity(slot, 0xCA)
	ld a, $ca
	call SpawnEntity
;> hNoiseSfx = 0x26
	ld a, $26
	ldh [hNoiseSfx], a
;> wEntityX[bolt] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[bolt] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPrivate3[bolt] = 1
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
;> wEntityTimer[bolt] = 0xC0
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $c0
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wMedicineCount = 0                           # no second chance
	xor a
	ld [wMedicineCount], a
;> wSubtractHealthBuffer = 0xFF
	ld a, $ff
	ld [wSubtractHealthBuffer], a

.done
;> return
	ret


;@ def ShopOwnerAfterPunish(slot: c)
;@ path: npc/shop-owner
;@ State 5: Link frozen; when the timer is over and Link has no health left, the thief is forgiven
;@ (wShopPunishThief and wItemButtonsDisabled cleared) and the owner disappears.
;@ test: slot = rand(0, 15)
ShopOwnerAfterPunish::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot] != 0 or wHealth != 0: return
	call GetEntityTimer
	jr nz, .done
	ld a, [wHealth]
	and a
	jr nz, .done
;> wShopPunishThief = 0
;> wItemButtonsDisabled = 0
	ld [wShopPunishThief], a
	ld [wItemButtonsDisabled], a
;> return DespawnEntity_04(slot)
	jp DespawnEntity_04

.done
;> return
	ret


;@ path: npc/shop-owner
;@ x of the four shelf places 1-4. 4 bytes.
ShopShelfX::
	db $1d, $3d, $5d, $7d

;@ path: npc/shop-owner
;@ Shop items as one 8x16 sprite each (tile, attributes) by item - 1: shovel, three hearts, shield,
;@ bombs, bow, (arrows: drawn 16x16 instead), items 7, 8 and 9. 18 bytes.
ShopItemSprites::
	db $96, $10, $a8, $10, $86, $10, $80, $10, $88, $10, $ff, $ff, $90, $10, $ae, $10
	db $a0, $10

;@ path: npc/shop-owner
;@ The ten arrows, 16x16 (tile $2A flipped twice); the code reads it as variant 5 of the table 20
;@ bytes earlier.
ShopArrowsSprite::
	db $2a, $40, $2a, $60

;@ def ShopDrawShelfItems()
;@ path: npc/shop-owner
;@ Draws the items on the four shelf places (y $32, the hearts $2F) and the one Link carries.
;@ test: skip writes OAM through bank-0 sprite code
ShopDrawShelfItems::
;>@l for place in range(4, 0, -1):
	ld a, $04

.loop
	ldh [hMultiPurposeF], a
;>@i     item = wShopShelfItems[place - 1]
	ld e, a
	ld d, b
	ld hl, wShopShelfItems - 1
	add hl, de
	ld a, [hl]
	and a
;=@i
	jr z, .next
;>     hActiveEntitySpriteVariant = item - 1
	dec a
	ldh [hActiveEntitySpriteVariant], a
;>     hActiveEntityX = mem[ShopShelfX + (place - 1)]
	ld hl, ShopShelfX - 1
	ldh a, [hMultiPurposeF]
	ld e, a
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>@d     hActiveEntityDrawY = 0x2F if item == 2 else 0x32
	ld a, $32
	ldh [hActiveEntityDrawY], a
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr nz, .draw
	ld hl, hActiveEntityDrawY
;=@d
	ld [hl], $2f

.draw
;>     if item == 6: DrawEntity16x16(ShopArrowsSprite - 0x14)
	cp $05
	jr nz, .small
	ld de, ShopArrowsSprite - $14
	call DrawEntity16x16
	jr .next

.small
;>     else: DrawEntity8x16(ShopItemSprites)
	ld de, ShopItemSprites
	call DrawEntity8x16

.next
;=@l
	ldh a, [hMultiPurposeF]
	dec a
	jr nz, .loop
;> ShopDrawCarriedItem()
	call ShopDrawCarriedItem
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> return
	ret


;@ def ShopDrawCarriedItem()
;@ path: npc/shop-owner
;@ Draws the item Link carries above his head (he counts as carrying an object).
;@ test: skip writes OAM through bank-0 sprite code
ShopDrawCarriedItem::
;> if wShopItemCarried == 0: return
	ld a, [wShopItemCarried]
	and a
	jr z, .done
;> hActiveEntitySpriteVariant = wShopItemCarried - 1
	dec a
	ldh [hActiveEntitySpriteVariant], a
;> wIsCarryingLiftedObject = 1
	ld a, $01
	ld [wIsCarryingLiftedObject], a
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> hActiveEntityX = hLinkX
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = hLinkY - 0x0E
	ldh a, [hLinkY]
	sub $0e
	ldh [hActiveEntityDrawY], a
;> if wShopItemCarried == 6: return DrawEntity16x16(ShopArrowsSprite - 0x14)
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nz, .small
	ld de, ShopArrowsSprite - $14
	jp DrawEntity16x16

.small
;> DrawEntity8x16(ShopItemSprites)
	ld de, ShopItemSprites
	call DrawEntity8x16

.done
;> return
	ret


;@ def BlockLinkAtEntity_04(slot: c)
;@ path: helpers/entity
;@ Makes the entity solid: when Link touches it he is put back where he was and his dash stops, and a
;@ hookshot chain (entity 3) that is out goes back to its state 0.
;@ test: skip moves Link through bank-0 code
BlockLinkAtEntity_04::
;> if not EntityTouchesLink(slot): return
	call EntityTouchesLink
	jr nc, .done
;> RestoreLinkPosition()
	call RestoreLinkPosition
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> chain = wHookshotChainSlot                   # slot + 1, 0 = none
	ld a, [wHookshotChainSlot]
	and a
	jr z, .done
;>@c if wEntityType[chain - 1] == 3:            # the hookshot's chain
	ld e, a
	ld d, b
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
	cp $03
;=@c
	jr nz, .done
;>     wEntityState[chain - 1] = 0              # the chain starts over
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00

.done
;> return
	ret


;@ def CanTalkToEntityWide_04(slot: c) -> carry
;@ path: helpers/entity
;@ Like CanTalkToEntity_04 with a wider reach sideways (Link $20 to the left up to $10 to the right,
;@ $10 up or down), for people behind a counter; Link may also be in the air. Carry set when Link
;@ presses A to talk.
;@ test: slot = rand(0, 15)
CanTalkToEntityWide_04::
;> if not -0x20 <= hLinkX - hActiveEntityX < 0x10: return False
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $20
	cp $30
	jr nc, .no
;> if abs(hLinkY - hActiveEntityY) >= 0x10: return False
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $10
	cp $20
	jr nc, .no
;> if hLinkDirection != GetEntityDirectionToLink_04(slot) ^ 1: return False   # Link faces it
	call GetEntityDirectionToLink_04
	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, .no
;> wCanTalkToEntity = 1
	ld hl, wCanTalkToEntity
	ld [hl], $01
;> if wDialogState or wInventoryAppearing or wDialogCooldown: return False
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wDialogCooldown
	or [hl]
	jr nz, .no
;> if wWindowY != 0x80: return False            # the window is in use
	ld a, [wWindowY]
	cp $80
	jr nz, .no
;> if not hJoypadPressed & 0x10: return False   # A
	ldh a, [hJoypadPressed]
	and $10
	jr z, .no
;> return True
	scf
	ret

.no
;> return False
	and a
	ret


;@ def CanTalkToEntity_04(slot: c) -> carry
;@ path: helpers/entity
;@ Carry set when Link, on the ground, close by (less than $10 across and $14 up or down) and facing
;@ the entity, presses A while no dialogue, inventory or window is in the way; marks that Link can
;@ talk (wCanTalkToEntity = 1) as soon as he is near and facing it.
;@ test: slot = rand(0, 15)
CanTalkToEntity_04::
;>@b if wDialogState or wInventoryAppearing or wIsLinkInTheAir or wDialogCooldown: return False
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
	ld hl, wDialogCooldown
;=@b
	or [hl]
	jr nz, .no
;> if wWindowY != 0x80: return False
	ld a, [wWindowY]
	cp $80
	jr nz, .no
;> if abs(hLinkX - hActiveEntityX) >= 0x10: return False
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, .no
;> if abs(hLinkY - hActiveEntityY) >= 0x14: return False
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28
	jr nc, .no
;> if hLinkDirection != GetEntityDirectionToLink_04(slot) ^ 1: return False
	call GetEntityDirectionToLink_04
	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, .no
;> wCanTalkToEntity = 1
	ld hl, wCanTalkToEntity
	ld [hl], $01
;> if not hJoypadPressed & 0x10: return False
	ldh a, [hJoypadPressed]
	and $10
	jr z, .no
;> return True
	scf
	ret

.no
;> return False
	and a
	ret


;@ path: helpers/entity
;@ First walking variant of a person by direction (right, left, up, down); the frame (0 / 1) is added.
WalkingFrameByDirection_04::
	db $06, $04, $02, $00

;@ def AnimateEntityWalking_04(slot: bc)
;@ path: helpers/entity
;@ Sets a person's variant for its direction, stepping between two frames every 8 frames.
;@ test: slot = rand(0, 15)
AnimateEntityWalking_04::
;>@d first = mem[WalkingFrameByDirection_04 + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, WalkingFrameByDirection_04
	add hl, de
;=@d
	push hl
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@v return SetEntitySpriteVariant(slot, first | (wEntityPrivateCounter[slot] >> 3) & 1)
	ld a, [hl]
	rra
	rra
	rra
	pop hl
	and $01
;=@v
	or [hl]
	jp SetEntitySpriteVariant


;@ def CheckWallsBothWays_04(slot: bc)
;@ path: helpers/entity
;@ Nothing calls this. Checks the walls with the speed set to (+1, +1) and then (-1, -1), so all four
;@ sides are tested, keeps both results in wEntityCollisions and restores the speed.
;@ test: slot = rand(0, 15)
CheckWallsBothWays_04::
;>@s saved = wEntitySpeedX[slot], wEntitySpeedY[slot]; both = 1
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	ld hl, wEntitySpeedY
;=@s
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
;> EntityCheckWalls(slot)                       # right and down
	call EntityCheckWalls
;> first = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedX[slot] = -1
;> wEntitySpeedY[slot] = -1
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $ff
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $ff
;> EntityCheckWalls(slot)                       # left and up
	call EntityCheckWalls
;> wEntityCollisions[slot] |= first
	ld hl, wEntityCollisions
	add hl, bc
	pop af
	or [hl]
	ld [hl], a
;>@r wEntitySpeedY[slot] = saved[0]
;> wEntitySpeedX[slot] = saved[1]
	pop af
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop af
	ld hl, wEntitySpeedX
;=@r
	add hl, bc
	ld [hl], a
;> return
	ret

;@ path: enemy/bombite
;@ Sprites of the timer bombite: 6 variants of a 16x16 entity (left tile, attributes, right tile,
;@ attributes; $20 = x flip): 0 and 1 walking, 2-4 the countdown faces, 5 about to blow.
TimerBombiteSprites::
	db $7a, $20, $78, $20, $78, $00, $7a, $00, $7e, $00, $7e, $20, $70, $00, $72, $00
	db $74, $00, $76, $00, $7c, $00, $7c, $20

;@ path: enemy/bombite
;@ The same in map 7 (tiles $60-$6E).
TimerBombiteSpritesAlt::
	db $6a, $20, $68, $20, $68, $00, $6a, $00, $6e, $00, $6e, $20, $60, $00, $62, $00
	db $64, $00, $66, $00, $6c, $00, $6c, $20

;@ def TimerBombite(slot: c)
;@ path: enemy/bombite
;@ Entity $56, the timer bombite: walks about until it is hit, then its fuse burns ($6F frames,
;@ counting down on its face) while it follows Link, and it explodes. It flashes (palette) while its
;@ Timer1 runs.
;@ test: skip dispatches through a jump table
TimerBombite::
;> sprites = TimerBombiteSpritesAlt if hMapId == 7 else TimerBombiteSprites
	ld de, TimerBombiteSprites
	ldh a, [hMapId]
	cp $07
	jr nz, .flash
	ld de, TimerBombiteSpritesAlt

.flash
;>@f hActiveEntityFlipAttribute = (wEntityTimer1[slot] << 3) & 0x10   # flashing
	call GetEntityTimer1
	rla
	rla
	rla
	and $10
;=@f
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@h if wEntityIgnoreHitsTimer[slot] == 8 and hActiveEntityState == 0:   # just hit
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, .move
;=@h
	ldh a, [hActiveEntityState]
	and a
	jr nz, .move
;>     wEntityState[slot] += 1                  # the fuse is lit
	call IncrementEntityState
;>     wEntityDropTimer[slot] = 0x6F
	call GetEntityDropTimer
	ld [hl], $6f

.move
;> if ApplyRecoilIfNeeded_04(slot): return
	call ApplyRecoilIfNeeded_04
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> return TimerBombiteStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/bombite
;@ States of the timer bombite.
TimerBombiteStates::
	dw TimerBombiteWander
	dw TimerBombiteLit

;@ path: enemy/bombite
;@ Walking speeds of the timer bombite: x speed at direction n (8, -8, 0, 0), y speed at n + 4 (0, 0,
;@ -8, 0: it stands still in direction 3). 8 bytes.
TimerBombiteSpeeds::
	db $08, $f8, $00, $00, $00, $00, $f8, $00

;@ def TimerBombiteWander(slot: bc)
;@ path: enemy/bombite
;@ State 0: every $30-$4F frames it picks a direction from its new timer's low bits.
;@ test: slot = rand(0, 15)
TimerBombiteWander::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate
;>     wEntityTimer[slot] = 0x30 + (GetRandomByte() & 0x1F)
;>     t = 0x30 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;>@x     wEntitySpeedX[slot] = mem[TimerBombiteSpeeds + (t & 3)]
	and $03
	ld e, a
	ld d, b
	ld hl, TimerBombiteSpeeds
	add hl, de
	ld a, [hl]
;=@x
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[TimerBombiteSpeeds + ((t & 3) + 4)]
	ld hl, TimerBombiteSpeeds + 4
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.animate
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> return
	ret


;@ path: enemy/bombite
;@ The timer bombite's face by fuse left (drop timer / 16): about to blow (5) at the end, then the
;@ countdown 4, 3 and 2. 7 bytes.
TimerBombiteFuseFrames::
	db $05, $05, $04, $03, $02, $02, $02

;@ def TimerBombiteLit(slot: c)
;@ path: enemy/bombite
;@ State 1, the fuse burning: it runs after Link (speed $0E, re-aimed every 4 frames) and stops next to
;@ him (within $12 pixels). At fuse $18 it skips ahead to $0A and flashes for $30 frames; at 0 it
;@ explodes. A dash with the Pegasus Boots puts the fuse out (state 0).
;@ test: skip spawns a bomb blast
TimerBombiteLit::
;> if wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .chase
;>     wEntityState[slot] = 0
;>     return
	call IncrementEntityState
	ld [hl], b
	ret

.chase
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;>@n if abs(GetEntityXDistanceToLink_04(slot)) < 0x12 and abs(GetEntityYDistanceToLink_04(slot)) < 0x12: return stop()
	call GetEntityXDistanceToLink_04
	add $12
	cp $24
	jr nc, .follow
;=@n
	call GetEntityYDistanceToLink_04
	add $12
	cp $24
	jr c, .stop

.follow
;>@g if (hFrameCounter ^ slot) & 3 == 0: SetEntitySpeedTowardsLink(slot, 0x0E)
	ldh a, [hFrameCounter]
	xor c
	and $03
	jr nz, .fuseCheck
;=@g
	ld a, $0e
	call SetEntitySpeedTowardsLink

.fuseCheck
	jr .fuse

.stop
;> ClearEntitySpeed(slot)                       # stop: next to Link
	call ClearEntitySpeed

.fuse
;> fuse = wEntityDropTimer[slot]
	call GetEntityDropTimer
;> if fuse == 0: return BombiteExplode(slot)
	jp z, BombiteExplode
;> if fuse == 0x18:
	cp $18
	jr nz, .face
;>     wEntityDropTimer[slot] = 0x0A
	ld [hl], $0a
;>     wEntityTimer1[slot] = 0x30               # flash
	call GetEntityTimer1
	ld [hl], $30

.face
;>@v return SetEntitySpriteVariant(slot, mem[TimerBombiteFuseFrames + ((fuse >> 4) & 7)])
	rra
	rra
	rra
	rra
	and $07
	ld e, a
;=@v
	ld d, b
	ld hl, TimerBombiteFuseFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ path: enemy/bombite
;@ Sprites of the bouncing bombite: 2 walking variants of a 16x16 entity.
BouncingBombiteSprites::
	db $7a, $20, $78, $20, $78, $00, $7a, $00

;@ path: enemy/bombite
;@ The same in map 7.
BouncingBombiteSpritesAlt::
	db $6a, $20, $68, $20, $68, $00, $6a, $00
;@ path: enemy/bombite
;@ Speeds of the bouncing bombite by direction (right, left, up, down): x at n (8, -8, 0, 0), y at
;@ n + 4 (0, 0, -8, 8). 8 bytes.
BouncingBombiteSpeeds::
	db $08, $f8, $00, $00, $00, $00, $f8, $08

;@ def BouncingBombite(slot: c)
;@ path: enemy/bombite
;@ Entity $55, the bouncing bombite: walks about (towards Link one time in four); struck, it flies off
;@ bouncing from the walls and knocking into other enemies (state 2) and explodes when its timer runs
;@ out. It takes no hits while its Timer1 runs.
;@ test: skip dispatches through a jump table
BouncingBombite::
;> sprites = BouncingBombiteSpritesAlt if hMapId == 7 else BouncingBombiteSprites
	ld de, BouncingBombiteSprites
	ldh a, [hMapId]
	cp $07
	jr nz, .draw
	ld de, BouncingBombiteSpritesAlt

.draw
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> if ApplyRecoilIfNeeded_04(slot): return
	call ApplyRecoilIfNeeded_04
;> if wEntityTimer1[slot] == 0: EntityCheckHits(slot)
	call GetEntityTimer1
	jr nz, .move
	call EntityCheckHits

.move
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> return BouncingBombiteStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/bombite
;@ States of the bouncing bombite.
BouncingBombiteStates::
	dw BouncingBombiteWait
	dw BouncingBombiteTurn
	dw BouncingBombiteFlying

;@ def BouncingBombiteWait(slot: c)
;@ path: enemy/bombite
;@ State 0: walks on until its timer runs out.
;@ test: slot = rand(0, 15)
BouncingBombiteWait::
;> if wEntityTimer[slot] == 0: wEntityState[slot] += 1
	call GetEntityTimer
	jr nz, .animate
	call IncrementEntityState

.animate
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> return
	ret


;@ def BouncingBombiteTurn(slot: bc)
;@ path: enemy/bombite
;@ State 1: a new direction, towards Link one time in four, else at random, for $20-$2F frames (back to
;@ state 0).
;@ test: slot = rand(0, 15)
BouncingBombiteTurn::
;> if GetRandomByte() & 3 != 0:
	call GetRandomByte
	and $03
	jr z, .towardsLink
;>     dir = GetRandomByte() & 3
	call GetRandomByte
	and $03
	jr .speed

.towardsLink
;> else: dir = GetEntityDirectionToLink_04(slot)
	call GetEntityDirectionToLink_04

.speed
;>@x wEntitySpeedX[slot] = mem[BouncingBombiteSpeeds + dir]
	ld e, a
	ld d, b
	ld hl, BouncingBombiteSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
;=@x
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[BouncingBombiteSpeeds + dir + 4]
	ld hl, BouncingBombiteSpeeds + 4
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntityTimer[slot] = 0x20 + (GetRandomByte() & 0x0F)
	call GetEntityTimer
	call GetRandomByte
	and $0f
	add $20
	ld [hl], a
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> return
	ret


;@ def BouncingBombiteFlying(slot: c)
;@ path: enemy/bombite
;@ State 2, flying after a hit: it knocks into other enemies, bounces from walls (turning its x or y
;@ speed round, with a jingle) and explodes when the timer runs out.
;@ test: skip spawns a bomb blast
BouncingBombiteFlying::
;> EntityHitOtherEntities(slot)
	call EntityHitOtherEntities
;> if wEntityTimer[slot] == 0: return BombiteExplode(slot)
	call GetEntityTimer
	jr z, BombiteExplode
;> walls = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
;> if walls & 3: return bounce_x()                # left or right
	and $03
	jr nz, .bounceX
;> if walls & 0x0C: return bounce_y()             # up or down
	ld a, [hl]
	and $0c
	jr nz, .bounceY
;> return animate()
	jr .animate

.bounceX
;> wEntitySpeedX[slot] = -wEntitySpeedX[slot]     # bounce_x
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> return jingle()
	jr .jingle

.bounceY
;> wEntitySpeedY[slot] = -wEntitySpeedY[slot]     # bounce_y
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.jingle
;> hJingle = 9
	ld a, $09
	ldh [hJingle], a

.animate
;>@v return SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
	ret


;@ def BombiteExplode(slot: c)
;@ path: enemy/bombite
;@ The bombite blows up: a bomb blast takes its place.
;@ test: skip spawns a bomb blast
BombiteExplode::
;> SpawnBombiteBlast(slot)
	call SpawnBombiteBlast
;> DespawnEntity_04(slot)
	call DespawnEntity_04
;> return
	ret


;@ def SpawnBombiteBlast(slot: bc)
;@ path: enemy/bombite
;@ Spawns a bomb (entity 2) at the bombite that goes off at once (timer $17, wEntityPrivate4 = 1).
;@ test: skip spawns an entity
SpawnBombiteBlast::
;> bomb, full = SpawnEntity(slot, 2)
	ld a, $02
	call SpawnEntity
;> if full: return
	jr c, .done
;> PlayClinkNoise()
	call PlayClinkNoise
;> wEntityX[bomb] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[bomb] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityTimer[bomb] = 0x17
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
;> wEntityPrivate4[bomb] = 1                    # exploding
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01

.done
;> return
	ret


;@ path: enemy/leever
;@ Sprites of the Leever: 4 variants of a 16x16 entity (left tile, attributes, right tile mirrored): 0
;@ and 1 half out of the sand, 2 and 3 spinning above it.
LeeverSprites::
	db $56, $00, $56, $20, $54, $00, $54, $20, $52, $00, $52, $20, $50, $00, $50, $20

;@ def Leever(slot: c)
;@ path: enemy/leever
;@ Entity $0E, the Leever: it travels under the sand towards Link, comes up, chases him spinning, and
;@ burrows again (states 0-3, repeating).
;@ test: skip dispatches through a jump table
Leever::
;> DrawEntity16x16(slot, LeeverSprites)
	ld de, LeeverSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> if ApplyRecoilIfNeeded_04(slot): return
	call ApplyRecoilIfNeeded_04
;> UpdateEntityPosWithSpeed_04(slot)
	call UpdateEntityPosWithSpeed_04
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> return LeeverStates[hActiveEntityState & 3](slot)
	ldh a, [hActiveEntityState]
	and $03
	rst $00

;@ path: enemy/leever
;@ States of the Leever.
LeeverStates::
	dw LeeverUnderground
	dw LeeverEmerge
	dw LeeverChase
	dw LeeverBurrow

;@ def LeeverUnderground(slot: c)
;@ path: enemy/leever
;@ State 0: hidden, moving under the sand until the timer runs out; then it stops and comes up ($1F
;@ frames).
;@ test: slot = rand(0, 15)
LeeverUnderground::
;> SetEntitySpriteVariant(slot, 0xFF)                 # not drawn
	ld a, $ff
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x1F
	ld [hl], $1f
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed

.done
;> return
	ret


;@ path: enemy/leever
;@ Variant while it comes up, by timer / 16: 1 at the end, 0 first.
LeeverEmergeFrames::
	db $01, $00

;@ def LeeverEmerge(slot: c)
;@ path: enemy/leever
;@ State 1: rising out of the sand; then it chases Link for $70-$AF frames.
;@ test: slot = rand(0, 15)
LeeverEmerge::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .rising
;>     wEntityTimer[slot] = 0x70 + (GetRandomByte() & 0x3F)
	call GetRandomByte
	and $3f
	add $70
	ld [hl], a
;>     return IncrementEntityState(slot)
	call IncrementEntityState
	ret

.rising
;> return SetLeeverFrame(LeeverEmergeFrames, timer)   # (falls through)
	ld hl, LeeverEmergeFrames

;@ def SetLeeverFrame(table: hl, timer: a)
;@ path: enemy/leever
;@ Sets the variant from the table entry for timer / 16.
SetLeeverFrame::
;>@v SetEntitySpriteVariant(table[timer >> 4])
	srl a
	srl a
	srl a
	srl a
	ld e, a
	ld d, b
;=@v
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> return
	ret


;@ def LeeverChase(slot: c)
;@ path: enemy/leever
;@ State 2: above the sand, spinning, it re-aims at Link (speed 8) every 16 frames; after its timer it
;@ stops and burrows ($1F frames).
;@ test: slot = rand(0, 15)
LeeverChase::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .chase
;>     wEntityTimer[slot] = 0x1F
	ld [hl], $1f
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return ClearEntitySpeed(slot)
	call ClearEntitySpeed
	ret

.chase
;> f = hFrameCounter ^ slot
	ldh a, [hFrameCounter]
	xor c
	push af
;> if f & 0x0F == 0: SetEntitySpeedTowardsLink(slot, 8)
	and $0f
	jr nz, .spin
	ld a, $08
	call SetEntitySpeedTowardsLink

.spin
;>@v wEntitySpriteVariant[slot] = 2 + ((f >> 2) & 1)
	pop af
	srl a
	srl a
	and $01
	call SetEntitySpriteVariant
	inc [hl]
;=@v
	inc [hl]
;> return
	ret


;@ path: enemy/leever
;@ Variant while it burrows, by timer / 16: 0 at the end, 1 first.
LeeverBurrowFrames::
	db $00, $01

;@ def LeeverBurrow(slot: c)
;@ path: enemy/leever
;@ State 3: sinking into the sand; then it moves underground towards Link (speed 8) for $30-$4F frames
;@ (state 4, which is state 0 again).
;@ test: slot = rand(0, 15)
LeeverBurrow::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .sinking
;>     wEntityTimer[slot] = 0x30 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return SetEntitySpeedTowardsLink(slot, 8)
	ld a, $08
	call SetEntitySpeedTowardsLink
	ret

.sinking
;> return SetLeeverFrame(LeeverBurrowFrames, timer)
	ld hl, LeeverBurrowFrames
	jp SetLeeverFrame


;@ def FlipSpriteBySpeedX_04()
;@ path: helpers/entity
;@ Flips the entity's sprite horizontally (hActiveEntityFlipAttribute ^= $20) when it moves right or
;@ stands still.
FlipSpriteBySpeedX_04::
;>@f flip = 0 if wEntitySpeedX[slot] & 0x80 else 0x20
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	rl a
	ld a, $00
	jr c, .apply
;=@f
	ld a, $20

.apply
;> hActiveEntityFlipAttribute ^= flip
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [hl], a
;> return
	ret


;@ def ReturnIfNonInteractive_04()
;@ path: helpers/entity
;@ Cuts the calling handler short (drops its return address, so the return goes to the caller's
;@ caller) unless the active entity is in its normal state (status 5) and the game runs normally (see
;@ ReturnIfGameFrozen_04).
;@ test: skip pops the caller's return address
ReturnIfNonInteractive_04::
;> if hActiveEntityStatus != 5: return stop()
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, ReturnIfGameFrozen_04.stop
;> ReturnIfGameFrozen_04()                      # (falls through)

;@ def ReturnIfGameFrozen_04()
;@ path: helpers/entity
;@ Cuts the calling handler short while the game is frozen: in gameplay type 7, while Link shows an
;@ item, a dialogue is open, the inventory moves, or the room is changing.
;@ test: skip pops the caller's return address
ReturnIfGameFrozen_04::
;> if wGameplayType == 7: stop
	ld a, [wGameplayType]
	cp $07
	jr z, .stop
;>@f if wLinkShowItemPoseActive or wDialogState or wInventoryAppearing: stop
	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
;=@f
	jr nz, .stop
;> if wRoomTransitionState == 0: return
	ld a, [wRoomTransitionState]
	and a
	jr z, .done

.stop
;> drop_return_address()                      # the caller's handler ends here
	pop af

.done
;> return
	ret


;@ path: padding
;@ Unused space at the end of bank 4 ($FF bytes). 168 bytes.
Bank04Padding::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
