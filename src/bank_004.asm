; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

;@ def GenieInit(slot: c)
;@ path: boss/genie
;@ Set-up of a new Genie (entity $5C, from the entity init table in bank 3, through a bank-switch stub
;@ in bank 0): moves it 8 pixels to the right, so the bottle stands in the middle of its two tiles.
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
;> Call_3F12()
	call Call_3F12
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
;>     new = SpawnEntity(0x5C)              # spawn a smoke cloud (no check for a full entity table)
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
;>     Call_3E64()                        # shards of the bottle, removes it
	call Call_3E64
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
	ldh [hBGTilesRequestCopy], a
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

;@ def GenieBottleWaitForLink(slot: c)
;@ path: boss/genie
;@ Bottle state 0: waits until Link has walked into the upper part of the room (y below $70).
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
;>     GetVectorTowardsLink(0x14)                      # vector of speed $14 towards Link
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
	ldh a, [hBGTilesRequestCopy]
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
;>     SetEntitySpeedTowardsLink(0x08)                      # speed 8 towards that point
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
;>     new = SpawnEntity(0x5C)                # the smoke cloud the Genie comes out of
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
AnimateGenieBottle::
;>@v SetEntitySpriteVariant(GenieBottleWobbleFrames[(hFrameCounter >> 3) & 3])   # set the sprite variant
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
;> SetEntitySpriteVariant(0)                             # upright
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
;>     GetVectorTowardsLink(0x08)                      # vector towards Link ...
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
	ldh a, [hBGTilesRequestCopy]
	and $80
	jr z, .move
;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>     hJingle = 0x20
	ld a, $20
	ldh [hJingle], a
;>     SetEntitySpeedTowardsLink(0x0C)                      # next hop towards Link
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
;>     DrawEntity8x16(GenieBottleShadowSprite)   # one 8x16 sprite
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

;@ def GenieDeathStart(slot: c)
;@ path: boss/genie
;@ Death state 0: wait $40 frames.
GenieDeathStart::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def GenieDeathWait(slot: c)
;@ path: boss/genie
;@ Death state 1: when the wait is over, explode for $A0 frames.
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
;>@if1 if hFrameCounter & 7 == 0 and wEntitySpeedX[slot] != GenieMaxSpeed[dir]:
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
;>@add     wEntitySpeedX[slot] += GenieAcceleration[dir]
	ld hl, GenieAcceleration
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
;=@add
	ld [hl], a

.turn
;> if hActiveEntityX == GenieTurnX[dir]:
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
;>@sy     wEntitySpeedY[slot] += GenieAcceleration[vdir]
	ld hl, GenieAcceleration
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
;=@sy
	ld [hl], a
;>     if wEntitySpeedY[slot] == GenieMaxSpeed[vdir]:
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
;>@v SetEntitySpriteVariant((hFrameCounter >> 4) & 1)          # floating frames 0 / 1
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
;>     wEntityTimer[slot] = GenieFlameDelays[thrown]
	ld d, b
	ld hl, GenieFlameDelays
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
;>     new = SpawnEntity(0x5C)
	ld a, $5c
	call SpawnEntity
;>     if new is not None:
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
;>     new = SpawnEntity(0x5C)
	ld a, $5c
	call SpawnEntity
;>     if new is not None:
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
;>@x         wEntityX[new] = hMultiPurpose0 + GenieFireballOffsetX[hand]
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
;>@p     SetEntitySpriteVariant(2 if wEntityPrivateCounter[slot] & 1 == 0 else 3)   # arm raised, by hand
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
;> SetEntitySpeedTowardsLink(0x10)
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
;>     new = SpawnEntity(0x5C)                    # (no check for a full entity table)
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
;>     GetVectorTowardsLink(0x10)                          # vector towards Link
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
AnimateGenieArms::
;>@r return SetEntitySpriteVariant(2 + ((hFrameCounter >> 4) & 1))
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
;>     new = SpawnEntity(0x5C)
	ld a, $5c
	call SpawnEntity
;>     if new is None:
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
;>@x     wEntityX[new] = hMultiPurpose0 + GenieFireballOffsetX[hand]
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
;> GetVectorTowardsLink(0x20)                              # vector towards the centre, speed $20
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
;> GetVectorTowardsLink(0x04)                              # plus a slight pull towards the centre
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


;@ def GenieSetMirrorPosition(slot: c)
;@ path: boss/genie
;@ Stores the Genie's position mirrored through the room centre ($50, $48): wEntityPrivate3 =
;@ $90 - y, wEntityPrivate4 = $A0 - x.
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
;> DrawEntity8x16(GenieTailSprites)
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
;>@s     return SetEntitySpriteVariant(GenieSmokeInFrames[(t >> 3) & 0x0F])
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
;>     new = SpawnEntity(0x5C)                    # the Genie (no check for a full entity table)
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
;>@g SetEntitySpriteVariant(GenieSmokeOutFrames[(wEntityTimer[slot] >> 3) & 0x0F])
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
;> DrawEntity16x16(GenieFireballSprites)             # draw the 16x16 flame
	ld de, GenieFireballSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@v SetEntitySpriteVariant((hFrameCounter >> 3) & 1)        # flicker
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
;> DrawEntity16x16(GenieFireballSprites)
	ld de, GenieFireballSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;>@v SetEntitySpriteVariant((hFrameCounter >> 3) & 1)
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
	ldh [hBGTilesRequestCopy], a

.loop
;>     new = SpawnEntity(0x5B)                    # (no check for a full entity table)
	ld a, $5b
	call SpawnEntity
;>     wEntityPrivate5[new] = 1                 # a half
	ld hl, wEntityPrivate5
	add hl, de
	ld [hl], $01
;>@x     wEntityX[new] = hMultiPurpose0 + SlimeEyeSplitOffsetX[half]
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, SlimeEyeSplitOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
;=@x
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[new] = SlimeEyeSplitSpeedX[half]
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
	ldh a, [hBGTilesRequestCopy]
	inc a
	ldh [hBGTilesRequestCopy], a
	cp $02
	jr nz, .loop
;> return DespawnEntity_04(slot)
	jp DespawnEntity_04


;@ def SlimeEyeInit(slot: c)
;@ path: boss/slime_eye
;@ Set-up of a new Slime Eye (entity $5B, from the entity init table in bank 3, through a bank-switch
;@ stub in bank 0): it starts high up in the ceiling (height $7E) with a timer of $A0.
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
;> Call_3F12()
	call Call_3F12
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
;>         new = SpawnEntity(0x1B)                # a Gel (no check for a full entity table)
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
;>     return SetEntitySpriteVariant(6)                      # tearing apart
	ld a, $06
	jp SetEntitySpriteVariant


.fight
;> SlimeEyeMove(slot)
	call SlimeEyeMove
;>@v SetEntitySpriteVariant((hFrameCounter >> 4) & 1)        # wobble: variants 0 / 1
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
;>     SetEntitySpriteVariant(wEntityPrivate1[slot] + 1)     # variants 2-5
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
;> hBGTilesRequestCopy = 0                      # ($FFE8) the eye is checked
	xor a
	ldh [hBGTilesRequestCopy], a
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
;>     hBGTilesRequestCopy = 1                  # ($FFE8) the body is checked
	ld a, $01
	ldh [hBGTilesRequestCopy], a
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

;@ def SetSlimeEyeHitboxRecord(slot: c, offset: a)
;@ path: boss/slime_eye
;@ Copies the 4-byte record at `offset` of SlimeEyeHitboxes into the entity's wEntityHitbox entry.
;@ test: offset = rand(0, 6) * 4
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
;> wEntitySpeedX[slot] = SlimeEyeSlideSpeedX[i]
	ld hl, SlimeEyeSlideSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = SlimeEyeSlideSpeedY[i]
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

;@ def SlimeEyeHalfDeathStart(slot: c)
;@ path: boss/slime_eye
;@ Death state 0: wait $40 frames.
SlimeEyeHalfDeathStart::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ def SlimeEyeHalfDeathWait(slot: c)
;@ path: boss/slime_eye
;@ Death state 1: then explode for $A0 frames.
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


;@ def SlimeEyePinLink(slot: c)
;@ path: boss/slime_eye
;@ While wEntityDropTimer runs (set when Slime Eye or a half lands hard), Link is frozen in his
;@ squashed pose ($6A).
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
;> hBGTilesRequestCopy = 0                      # ($FFE8) for the hit code
	xor a
	ldh [hBGTilesRequestCopy], a
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
;>     wEntitySpeedX[slot] = SlimeEyeHalfHopSpeedX[dir]
	ld hl, SlimeEyeHalfHopSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = SlimeEyeHalfHopSpeedY[dir]
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
;>         SetEntitySpeedTowardsLink(0x18)                      # straight at Link
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
;> return SetEntitySpriteVariant(0)
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
;> return SetEntitySpriteVariant(1)
	ld a, $01
	jp SetEntitySpriteVariant


;@ def SlimeEyeHalfRise(slot: c)
;@ path: boss/slime_eye
;@ State 2, after a hit: flies straight up out of sight (speed $60) up to height $70, then waits
;@ there (state 3, timer $30).
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


;@ def SlimeEyeHalfDropOnLink(slot: c)
;@ path: boss/slime_eye
;@ State 3, out of sight (not drawn): when the timer is over it moves above Link and drops fast
;@ (speed $C0 down), back in state 1 as a drop (wEntityPrivate4 = 1).
SlimeEyeHalfDropOnLink::
;> SetEntitySpriteVariant(0xFF)                              # hidden
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


;@ def FacadeInit(slot: c)
;@ path: boss/facade
;@ Set-up of a new Facade (entity $5A, from the entity init table in bank 3, through a bank-switch
;@ stub in bank 0): timer $FF, hit immunity for 8 frames, $12 hit points, moved 8 pixels right and down
;@ (to the middle of its 2x2 tiles) and not drawn yet.
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
;> return SetEntitySpriteVariant(0xFF)
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
;> Call_3F12()
	call Call_3F12
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

;@ def FacadeDeathKillAll(slot: c)
;@ path: boss/facade
;@ Death step 0: every other active entity (status 5 or more) that is not flagged as indestructible
;@ (physics flag bit 7) starts dying (status 1, $1F frames); then wait $80 frames.
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

jr_004_50dd:
;> wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
	ret


;@ def FacadeDeathWait(slot: c)
;@ path: boss/facade
;@ Death step 1: when the wait is over, explode for $FF frames.
FacadeDeathWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;>     wEntityPrivate4[slot] += 1               # (the tail of FacadeDeathKillAll)
	jr jr_004_50dd

.done
;> return
	ret


;@ def FacadeDeathExplode(slot: c)
;@ path: boss/facade
;@ Death step 2: explosions; at the end the face leaves a heart container.
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

;@ def FacadeWait(slot: c)
;@ path: boss/facade
;@ State 0: waits for its timer (set to $FF on creation), then wakes up for $FF frames.
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
;>@v     return SetEntitySpriteVariant(FacadeAwakenFrames[(t >> 3) & 0x1F])
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
;>@sh wScreenShakeX = FacadeRumbleOffsets[(hFrameCounter >> 3) & 1]
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
;>         new = SpawnEntity(0x5A)
	ld a, $5a
	call SpawnEntity
;>         if new is not None:
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
;>@hx             wEntityX[new] = FacadeHoleX[spot]
	push bc
	ld c, a
	ld hl, FacadeHoleX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
;=@hx
	add hl, de
	ld [hl], a
;>             wEntityY[new] = FacadeHoleY[spot]
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
;>         new = SpawnEntity(0x5A)
	ld a, $5a
	call SpawnEntity
;>         if new is not None:
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
;>             i = FacadeTileOrder[n]
	ld hl, FacadeTileOrder
	add hl, bc
	ld c, [hl]
;>             wEntityX[new] = FacadeTileX[i]
	ld hl, FacadeTileX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[new] = FacadeTileY[i]
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
;>         new = SpawnEntity(0x5A)
	ld a, $5a
	call SpawnEntity
;>         if new is not None:
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
;>             wEntityX[new] = FacadePotX[n]
	ld hl, FacadePotX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             hActiveEntityX = FacadePotX[n]
	ldh [hActiveEntityX], a
;>             wEntityY[new] = FacadePotY[n]
	ld hl, FacadePotY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             hActiveEntityY = FacadePotY[n]
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
;>@m SetEntitySpriteVariant(FacadeMouthFrames[(wEntityTimer[slot] >> 3) & 3])
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
;>     SetEntitySpriteVariant(2)
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
;>@hv     SetEntitySpriteVariant(FacadeHurtFrames[(wEntityPrivate5[slot] >> 4) & 0x0F])
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
;> DrawEntity16x16(FacadeHoleSprites)
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
;>@v open = FacadeHoleFrames[(t >> 3) & 0x0F]
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
;> SetEntitySpriteVariant(open)
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
;>@near     if (GetEntityXDistanceToLink_04() + 8) & 0xFF < 0x10 and (GetEntityYDistanceToLink_04() + 8) & 0xFF < 0x10:
	call GetEntityXDistanceToLink_04
	add $08
	cp $10
	jr nc, .done
;=@near
	call GetEntityYDistanceToLink_04
	add $08
	cp $10
	jr nc, .done
;>         GetVectorTowardsLink(0x0C)                      # vector towards Link ...
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
;>@in         if (GetEntityXDistanceToLink_04() + 3) & 0xFF < 6 and (GetEntityYDistanceToLink_04() + 3) & 0xFF < 6:
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
;>@d DrawEntity16x16(FacadeTileSpritesMap1 if hMapId == 1 else FacadeTileSprites)
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
;>@v SetEntitySpriteVariant((hFrameCounter >> 3) & 1)
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
;> SetEntitySpeedTowardsLink(0x18)                              # straight at Link
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
;> Call_3E64()                                  # shards (removes the entity)
	call Call_3E64

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
;> DrawEntity16x16(FacadePotSprites)
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
;> SetEntitySpeedTowardsLink(0x18)
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
MoldormInit::
;> wSmasherBallSlot = 0                         # ($D201)
	xor a
	ld [wSmasherBallSlot], a
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
;> Call_3F12()
	call Call_3F12
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

;@ def MoldormDeathStart(slot: c)
;@ path: boss/moldorm
;@ Death state 0: flash, wait $60 frames.
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


;@ def MoldormDeathWait(slot: c)
;@ path: boss/moldorm
;@ Death state 1: when the wait is over, keep flashing for $FF more frames while it breaks up.
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
;>     hActiveEntityX += MoldormExplosionCircle[i]
	ld hl, MoldormExplosionCircle
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY += MoldormExplosionCircle[8 + i]
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
;> new = SpawnEntity(0x36)                        # (no check for a full entity table)
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
;> mem[0xD3D6] = 0
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
;>     mem[0xD3D6] = 1
	ld a, $01
	ld [wSfxFastVariant], a
;>     noiseEvery = 0x0B
	ld e, $0b

.noise
;> wSmasherBallSlot += 1                        # ($D201) step counter
	ld hl, wSmasherBallSlot
	ld a, [hl]
	inc a
	ld [hl], a
;> if wSmasherBallSlot >= noiseEvery:
	cp e
	jr c, MoldormStep
;>     wSmasherBallSlot = 0
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
;>@v SetEntitySpriteVariant(MoldormDirectionTable[wEntityPrivate1[slot] >> 1])
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
;> DrawEntity16x16(MoldormSegmentSprites)
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
;> DrawEntity16x16(MoldormSegmentSprites)
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
;> DrawEntity16x16(MoldormSegmentSprites)
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
;> DrawEntity16x16(MoldormSegmentSprites)
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


;@ def MiniMoldormInit(slot: c)
;@ path: enemy/mini_moldorm
;@ Set-up of a Mini Moldorm (entity $29; from the entity init table in bank 3, through a bank-switch
;@ stub in bank 0; also when it is hit or the screen scrolls): clears its 32-entry trail, which lies at
;@ wEntityWorkRAM / wEntityWorkRAM2 + wEntityLoadOrder * 32 (so several of them can share the area).
;@ test: wEntityLoadOrder[c] = rand(0, 7)
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
;>     SetEntitySpriteVariant(WormDirectionVariants[dir])
	ld hl, WormDirectionVariants
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>     wEntitySpeedY[slot] = WormDirectionSpeeds[dir]
	ld hl, WormDirectionSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = WormDirectionSpeeds[dir + 4]
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
;> DrawEntity16x16(MiniMoldormSprites)                # the head
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
;> DrawEntity16x16(MiniMoldormSprites)
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
;> DrawEntity16x16(MiniMoldormSprites)
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
;> DrawEntity16x16(GhiniSprites)
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
;>     SetEntitySpriteVariant(0xFF)
	ld a, $ff
	call SetEntitySpriteVariant
;>@near     if (GetEntityXDistanceToLink_04() + 0x10) & 0xFF < 0x20 and (GetEntityYDistanceToLink_04() + 0x10) & 0xFF < 0x20 and wLinkCollisionFlags != 0:
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
;>@v SetEntitySpriteVariant(((hFrameCounter >> 4) ^ slot) & 1)
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
;>     SetEntitySpriteVariant(0xFF)
	ld a, $ff
	call SetEntitySpriteVariant

.move
;> if ReturnIfNonInteractive_04(): return
	call ReturnIfNonInteractive_04
;> ApplyRecoilIfNeeded_04(slot)
	call ApplyRecoilIfNeeded_04
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
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
;>@ex wEntitySpeedX[slot] += 1 if (GhiniTargetSpeedX[wEntityPrivate1[slot]] - wEntitySpeedX[slot]) & 0x80 == 0 else -1
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
;>@ey wEntitySpeedY[slot] += 1 if (GhiniTargetSpeedY[wEntityPrivate2[slot]] - wEntitySpeedY[slot]) & 0x80 == 0 else -1
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


;@ def GhiniHover(slot: c)
;@ path: enemy/ghini
;@ Every 4 frames moves the Ghini's height one pixel towards $10 (up from below the floor too).
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


PairoddSprites::
	db $70, $00, $72, $00, $72, $20, $70, $20, $74, $00, $74, $20, $00, $00, $00, $00
	db $7a, $00, $7a, $20, $ff, $00, $ff, $00, $76, $00, $78, $00, $78, $20, $76, $20

PairoddHandler::
	ldh a, [hActiveEntitySpriteVariant]
	cp $03
	jr nz, jr_004_5e14

	ldh a, [hActiveEntityX]
	sub $08
	ldh [hActiveEntityX], a
	ld a, $06
	ldh [hActiveEntitySpriteVariant], a
	ld de, $5dc9
	call DrawEntity16x16
	ldh a, [hActiveEntityX]
	add $10
	ldh [hActiveEntityX], a
	ld a, $07
	ldh [hActiveEntitySpriteVariant], a
	ld de, $5dc9
	call DrawEntity16x16
	call LoadEntityPosition
	jr jr_004_5e1a

jr_004_5e14:
	ld de, $5dc9
	call DrawEntity16x16

jr_004_5e1a:
	call ReturnIfNonInteractive_04
	call ApplyRecoilIfNeeded_04
	ldh a, [hActiveEntityState]
	rst $00

PairoddStates::
	dw PairoddIdle
	dw PairoddVanish
	dw PairoddAppear

PairoddIdle::
	call EntityCheckHits
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call GetEntityTimer
	cp $18
	jr nz, jr_004_5e42

	call PairoddShoot
	and a

jr_004_5e42:
	jr nc, jr_004_5e6a

	call GetEntityXDistanceToLink_04
	add $20
	cp $40
	jr nc, jr_004_5e6a

	call GetEntityYDistanceToLink_04
	add $20
	cp $40
	jr nc, jr_004_5e6a

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5e6a

	call GetEntityTimer
	ld [hl], $20
	call IncrementEntityState
	ld a, $3c
	ldh [hJingle], a

jr_004_5e6a:
	ret


PairoddVanishFrames::
	db $04, $03, $02

PairoddVanish::
	call GetEntityTimer
	cp $18
	jp nc, EntityCheckHits

	and a
	jr nz, jr_004_5e9c

	ld [hl], $40
	call IncrementEntityState
	ld a, $ff
	call SetEntitySpriteVariant
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, a
	ld a, $48
	sub e
	ld [hl], a
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $50
	ld e, a
	ld a, $50
	sub e
	ld [hl], a
	ret


jr_004_5e9c:
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5e6b
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


PairoddAppearFrames::
	db $02, $03, $04

PairoddAppear::
	call GetEntityTimer
	cp $18
	jr nc, jr_004_5eee

	and a
	jr nz, PairoddAppearAnimate

	ld [hl], $30
	call IncrementEntityState
	ld [hl], b
	ret


PairoddShoot::
	ld a, $58
	call SpawnEntity
	jr c, jr_004_5ede

	ld hl, wEntityX
	add hl, de
	ldh a, [hMultiPurpose0]
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hl], a
	push bc
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
	pop bc

jr_004_5ede:
	ret


PairoddAppearAnimate::
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5eac
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant

jr_004_5eee:
	ret


PairoddProjectileSprites::
	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

PairoddProjectileHandler::
	ld de, $5eef
	call DrawEntity16x16
	call ReturnIfNonInteractive_04
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call UpdateEntityPosWithSpeed_04
	call EntityCheckObjectCollision
	call EntityCheckTouchLink
	call EntityCheckWeaponHits
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5f24

	call DespawnEntity_04
	call Call_04_6BF2

jr_004_5f24:
	ret


	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $7c, $00, $00, $f8, $7e, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $9a, $10, $9c, $10

Call_04_5F59::
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5f93

	ldh a, [hActiveEntityDrawY]
	add $04
	ldh [hActiveEntityDrawY], a
	ld de, $5f55
	call DrawEntity16x16
	call UpdateEntityPosWithSpeed_04
	call AddEntityZSpeedToPos_04
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_5f8e

	call DespawnEntity_04
	xor a
	ld [wTradeSceneState], a
	ld [wLinkFrozen], a
	jp SpawnHeldItemEntity


jr_004_5f8e:
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


jr_004_5f93:
	ldh a, [hIsSideScrolling]
	and a
	jp nz, Jump_004_607b

	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $84
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
	ld a, [wDialogState]
	and a
	ld hl, $5f45
	jr nz, jr_004_5fbf

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld hl, $5f25
	and $30
	jr z, jr_004_5fbf

	ld hl, $5f35

jr_004_5fbf:
	ld c, $04
	call DrawEntitySprites
	ld a, $04
	call ReserveOAMEntriesFar
	call BlockLinkAtEntity_04
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_5FCF::
	dw Jump_04_5FD5
	dw Jump_04_5FE3
	dw Jump_04_6016

Jump_04_5FD5::
	call CanTalkToEntity_04
	jr nc, jr_004_5fe2

	ld a, $45
	call OpenDialog
	call IncrementEntityState

jr_004_5fe2:
	ret


Jump_04_5FE3::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_600e

	call IncrementEntityState
	ld a, [wDialogAnswer]
	and a
	jr z, jr_004_5ff8

	ld [hl], b
	ld a, $46
	jp OpenDialog


jr_004_5ff8:
	ld a, [wRupeeCountLow]
	sub $10
	ld a, [wRupeeCountHigh]
	sbc $00
	jr c, jr_004_600f

	ld a, $0a
	ld [wSubtractRupeeBufferLow], a
	ld a, $47
	call OpenDialog

jr_004_600e:
	ret


jr_004_600f:
	ld [hl], b
	ld a, $4e
	call OpenDialog
	ret


Jump_04_6016::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_6022

	call Call_3EAD
	call Call_04_67C6

jr_004_6022:
	ret


	db $58, $00, $5a, $00, $56, $20, $ff, $00, $5c, $00, $5e, $00, $58, $00, $5a, $00
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5c, $00, $5e, $00, $56, $00, $ff, $00
	db $5e, $20, $5c, $20, $58, $00, $5a, $00, $06, $16, $10, $10, $38, $38, $39, $39
	db $16, $38, $f6, $00, $f1, $f0, $f0, $f0, $f0, $fe, $04, $f2, $00, $f0, $fa, $00
	db $00, $f8, $f8, $f8, $f2, $fe, $e8, $00, $e0, $e8, $00, $00, $00, $00, $14, $10
	db $e0, $f8, $10, $00, $00, $00, $00, $f0

Jump_004_607b:
	ld a, $01
	ld [wLinkFrozen], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_6086::
	dw Jump_04_60A7
	dw Jump_04_6246
	dw Jump_04_6401
	dw Jump_04_66EC

	db $18, $58
	db $60, $18, $88, $40, $4c, $34, $68, $50, $01, $00, $00, $01, $00, $02, $02, $02
	db $03, $03, $00, $3e, $1e, $10, $30

Jump_04_60A7::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_60f7

	inc [hl]
	push bc
	ld c, $05

jr_004_60b7:
	ld a, $54
	call SpawnEntity
	ld hl, $608d
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $6092
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, $6097
	add hl, bc
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	ld hl, $609c
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], a
	ld hl, $60a1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityTimer
	add hl, de
	ld [hl], a
	dec c
	jr nz, jr_004_60b7

	xor a
	ld [wSceneVar4], a
	pop bc
	ret


jr_004_60f7:
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, $604b
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
	ld hl, $6055
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $605f
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld de, $6023
	call DrawEntity16x16
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_611D::
	dw Jump_04_612B
	dw Jump_04_6153
	dw Jump_04_61BC
	dw Jump_04_61BD
	dw Jump_04_6207
	dw Jump_04_6214
	dw Jump_04_6231

Jump_04_612B::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_6143

	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_004_6143

	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $23
	xor a
	ld [wSceneVar2], a

jr_004_6143:
	ld a, $09
	call Call_04_6192
	ret


	db $01, $08, $08, $08, $08, $08, $01, $02, $03, $00

Jump_04_6153::
	call GetEntityTimer
	jr nz, jr_004_618e

	call IncrementEntityState
	ld a, $02
	ld [wEntitySpriteVariant], a
	ld a, $54
	call SpawnEntity
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
	ld hl, wEntityY
	add hl, de
	ld [hl], $18
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $e2
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fa
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $14
	ld a, $08
	ldh [hJingle], a
	ret


jr_004_618e:
	rra
	rra
	and $1f

Call_04_6192::
	ld e, a
	ld d, b
	ld hl, $6149
	add hl, de
	ld a, [hl]
	ld [wEntitySpriteVariant], a
	ld e, a
	ld d, b
	ld hl, $6069
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $6072
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	xor a
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6232
	call DrawEntity16x16
	jp LoadEntityPosition


Jump_04_61BC::
	ret


Jump_04_61BD::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_61fe

	ld a, [wDialogAnswer]
	and a
	jr nz, jr_004_61f6

	ld a, [wSceneVar4]
	cp $05
	jr c, jr_004_61db

	ld a, $4b
	call OpenDialog
	call IncrementEntityState
	ld [hl], $05
	ret


jr_004_61db:
	ld a, [wRupeeCountLow]
	sub $10
	ld a, [wRupeeCountHigh]
	sbc $00
	jr c, jr_004_61ff

	ld a, $0a
	ld [wSubtractRupeeBufferLow], a
	ld a, $47
	call OpenDialog
	call IncrementEntityState
	ld [hl], b
	ret


jr_004_61f6:
	ld a, $46
	call OpenDialog
	call IncrementEntityState

jr_004_61fe:
	ret


jr_004_61ff:
	ld a, $4e
	call OpenDialog
	jp IncrementEntityState


Jump_04_6207::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_6213

	call Call_3EAD
	call Call_04_67C6

jr_004_6213:
	ret


Jump_04_6214::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_6230

	call IncrementEntityState
	ld [hl], $04
	ld a, [wDialogAnswer]
	and a
	jr nz, jr_004_622b

	ld a, $4c
	call OpenDialog
	ret


jr_004_622b:
	ld a, $46
	call OpenDialog

jr_004_6230:
	ret


Jump_04_6231::
	ret


	db $50, $00, $54, $00, $50, $00, $52, $00, $50, $40, $54, $00, $54, $40, $50, $40
	db $54, $60, $50, $60

Jump_04_6246::
	ld a, c
	ld [wSceneVar3], a
	ld de, $6232
	call DrawEntity16x16
	ldh a, [hActiveEntityX]
	ld [wEntityWorkRAM], a
	ldh a, [hActiveEntityY]
	ld [wSceneVar1], a
	call ReturnIfNonInteractive_04
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_6260::
	dw Jump_04_6264
	dw Jump_04_62CD

Jump_04_6264::
	call AddEntitySpeedToPosX_04
	call AddEntitySpeedToPosY_04
	ldh a, [hJoypadHeld]
	and $01
	jr z, jr_004_6281

	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_004_6281

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6281

	inc [hl]
	jr jr_004_6286

jr_004_6281:
	call GetEntityTimer
	jr nz, jr_004_62ac

jr_004_6286:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_004_6296

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $20
	jr z, jr_004_6296

	inc [hl]

jr_004_6296:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	cp $03
	ld [hl], a
	jr nz, jr_004_62ac

	xor a
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_62ac

	inc [hl]

jr_004_62ac:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $2a
	jr c, jr_004_62cc

	call ClearEntitySpeed
	call IncrementEntityState

Jump_004_62bb:
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ld a, $01
	call AddTransientVfx
	ld a, $0e
	ldh [hJingle], a

jr_004_62cc:
	ret


Jump_04_62CD::
	ld hl, wEntitySpriteVariant
	ld [hl], $00
	call GetEntityTimer
	jr z, jr_004_62dc

	ld hl, wEntitySpriteVariant
	ld [hl], $04

jr_004_62dc:
	call GetEntityTimer1
	jr z, jr_004_62e6

	ld hl, wEntitySpriteVariant
	ld [hl], $05

jr_004_62e6:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call UpdateEntityPosWithSpeed_04
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_004_6319

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sub $04
	jr z, jr_004_630a

	and $80
	jr z, jr_004_6309

	inc [hl]
	inc [hl]

jr_004_6309:
	dec [hl]

jr_004_630a:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6319

	and $80
	jr z, jr_004_6318

	inc [hl]
	inc [hl]

jr_004_6318:
	dec [hl]

jr_004_6319:
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_004_637e

	call GetEntityTimer
	ld [hl], $08
	ldh a, [hLinkX]
	push af
	sub $17
	ldh [hLinkX], a
	ld a, $04
	call SetEntitySpeedTowardsLink
	pop af
	ldh [hLinkX], a
	ldh a, [hActiveEntityDrawY]
	cp $25
	jr nc, jr_004_6372

	ldh a, [hActiveEntityX]
	cp $70
	jr c, jr_004_6372

	ld hl, wEntityState
	ld [hl], $03
	ld a, $48
	call OpenDialog
	call DespawnEntity_04
	ld e, $0f
	ld d, b

jr_004_634f:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_636c

	ld hl, wEntityPrivate1
	add hl, de
	ld a, [hl]
	cp $02
	jr c, jr_004_636c

	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $02
	jr c, jr_004_636c

	and $01
	ld [hl], a

jr_004_636c:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_004_634f

jr_004_6372:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	jr jr_004_63a3

jr_004_637e:
	ldh a, [hJoypadPressed]
	and $05
	jr z, jr_004_63a3

	ldh a, [hActiveEntityDrawY]
	cp $30
	jr c, jr_004_63a3

	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_63a3

	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fa

Jump_04_6398::
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $50
	call GetEntityTimer1
	ld [hl], $10

jr_004_63a3:
	ldh a, [hActiveEntityX]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
	jr nz, jr_004_63b5

	ldh a, [hActiveEntityY]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jr z, jr_004_63c7

jr_004_63b5:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
	push hl
	and $80
	jr z, jr_004_63c1

	ld [hl], b

jr_004_63c1:
	call EntityCheckWalls
	pop hl
	pop af
	ld [hl], a

jr_004_63c7:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_63d3

	xor a
	call SetEntitySpriteVariant

jr_004_63d3:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	rla
	jr c, jr_004_63e0

	ld a, $02
	call SetEntitySpriteVariant

jr_004_63e0:
	ret


	db $4c, $00, $4a, $00, $4c, $00, $4e, $00, $48, $00, $4a, $00, $48, $00, $4e, $00
	db $4a, $20, $4c, $20, $4e, $20, $4c, $20, $4a, $20, $48, $20, $4e, $20, $48, $20

Jump_04_6401::
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_640f

	ldh a, [hActiveEntitySpriteVariant]
	add $04
	ldh [hActiveEntitySpriteVariant], a

jr_004_640f:
	ld de, $63e1
	call DrawEntity16x16

Jump_004_6415:
	call ReturnIfNonInteractive_04
	call UpdateEntityPosWithSpeed_04
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_641E::
	dw Jump_04_642A
	dw Jump_04_6462
	dw Jump_04_64B9
	dw Jump_04_64F4
	dw Jump_04_6541
	dw Jump_04_6652

Jump_04_642A::
	call Call_04_6766
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Jump_004_6703

	call GetEntityTimer
	jr nz, jr_004_6449

	ld [hl], $30
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call IncrementEntityState

jr_004_6449:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_645e

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_645e

	and $80
	jr z, jr_004_645d

	inc [hl]
	inc [hl]

jr_004_645d:
	dec [hl]

jr_004_645e:
	jr jr_004_64a7

	db $10, $f0

Jump_04_6462::
	call Call_04_6766
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Jump_004_672d

	call GetEntityTimer
	jr nz, jr_004_647a

	ld [hl], $50
	call IncrementEntityState
	ld [hl], b

jr_004_647a:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_64a7

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, $6460
	add hl, de
	sub [hl]
	pop hl
	and a
	jr z, jr_004_64a7

	and $80
	jr z, jr_004_64a6

	inc [hl]
	inc [hl]

jr_004_64a6:
	dec [hl]

jr_004_64a7:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $34
	jr nc, jr_004_64b6

	inc [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b

jr_004_64b6:
	ret


	db $f2, $14

Jump_04_64B9::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call GetEntityTimer
	jr nz, jr_004_64cb

	call IncrementEntityState

jr_004_64cb:
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $64b7
	add hl, de
	ld a, [wEntityWorkRAM]
	add [hl]
	ldh [hLinkX], a
	ld a, [wSceneVar1]
	ldh [hLinkY], a
	ld a, $04
	call SetEntitySpeedTowardsLink
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	jp UpdateEntityPosWithSpeed_04


Jump_04_64F4::
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	add $02
	call SetEntitySpriteVariant
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, [wEntityWorkRAM]
	add $04
	ldh [hLinkX], a
	ld a, [wSceneVar1]
	ldh [hLinkY], a
	ld a, $10
	call SetEntitySpeedTowardsLink
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_04
	ld a, [wEntityWorkRAM]
	ld hl, hActiveEntityX
	sub [hl]
	add $08
	cp $10
	jr nc, jr_004_653c

	call ClearEntitySpeed
	call IncrementEntityState
	ld a, [wSceneVar3]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b

jr_004_653c:
	ret


	db $54, $00, $08, $f8

Jump_04_6541::
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $653f
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, hActiveEntitySpriteVariant
	ld [hl], b
	ld de, $653d
	call DrawEntity8x16
	call LoadEntityPosition
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_004_65a2

	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, $00
	ldh [hLinkX], a
	ld a, $59
	ldh [hLinkY], a
	ld a, $08
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	inc [hl]
	and $80
	jr z, jr_004_658e

	dec [hl]
	dec [hl]

jr_004_658e:
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	inc [hl]
	and $80
	jr z, jr_004_659c

	dec [hl]
	dec [hl]

jr_004_659c:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a

jr_004_65a2:
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_004_65f8

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_004_65b8

	call GetRandomByte
	and $03
	jr z, jr_004_65f8

jr_004_65b8:
	ldh a, [hLinkX]
	push af
	sub $14
	ldh [hLinkX], a
	ldh a, [hLinkY]
	push af
	add $08
	ldh [hLinkY], a
	ld a, $03
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	inc [hl]
	inc [hl]
	and $80
	jr z, jr_004_65dc

	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]

jr_004_65dc:
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	inc [hl]
	inc [hl]
	and $80
	jr z, jr_004_65ed

	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]

jr_004_65ed:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call GetEntityTimer
	ld [hl], $10

jr_004_65f8:
	call UpdateEntityPosWithSpeed_04
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_660b

	rlca
	and $01
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_004_660b:
	ld hl, wEntitySpriteVariant
	ld [hl], $05
	call GetEntityTimer
	jr z, jr_004_6620

	ldh a, [hFrameCounter]
	and $30
	jr z, jr_004_6620

	ld hl, wEntitySpriteVariant
	ld [hl], $07

jr_004_6620:
	ldh a, [hActiveEntityDrawY]
	cp $2c
	jr nc, jr_004_663e

	ldh a, [hActiveEntityX]
	cp $74
	jr c, jr_004_663e

	call IncrementEntityState
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $05
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jp Jump_004_62bb


jr_004_663e:
	ldh a, [hActiveEntityX]
	cp $03
	jr nc, jr_004_6651

	ld hl, wEntityState
	ld [hl], $03
	ld a, $49
	call OpenDialog
	jp DespawnEntity_04


jr_004_6651:
	ret


Jump_04_6652::
	ld hl, wEntitySpriteVariant
	ld [hl], $01
	call UpdateEntityPosWithSpeed_04
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	nop
	ld a, [hl]
	cp $0c
	jr nz, jr_004_66cb

	ld hl, wEntityState
	ld [hl], $03
	ld a, c
	cp $0f
	jr nz, jr_004_66b0

	ldh a, [hRoomStatus]
	and $10
	jr nz, jr_004_66b0

	ld a, $01
	ldh [hJingle], a
	ldh a, [hMapRoom]
	ld e, a
	ld d, $01
	ld hl, $d900
	add hl, de
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [hRoomStatus], a
	ld a, [wHeartPieces]
	inc a
	ld [wHeartPieces], a
	cp $04
	jr nz, jr_004_66a4

	xor a
	ld [wHeartPieces], a
	ld hl, wAddHealthBuffer
	ld [hl], $40
	ld hl, wMaxHearts
	inc [hl]
	ld a, $ff
	jr jr_004_66a6

jr_004_66a4:
	ld a, $fe

jr_004_66a6:
	call OpenDialogTable1
	ld hl, wAddRupeeBufferLow
	ld [hl], $20
	jr jr_004_66c8

jr_004_66b0:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	ld e, $14
	ld a, $4a
	jr z, jr_004_66c1

	ld e, $05
	ld a, $4d

jr_004_66c1:
	ld hl, wAddRupeeBufferLow
	ld [hl], e
	call OpenDialog

jr_004_66c8:
	call DespawnEntity_04

jr_004_66cb:
	ret


	db $44, $00, $42, $00, $44, $00, $46, $00, $40, $00, $42, $00, $40, $00, $46, $00
	db $42, $20, $44, $20, $46, $20, $44, $20, $42, $20, $40, $20, $46, $20, $40, $20

Jump_04_66EC::
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_66fa

	ldh a, [hActiveEntitySpriteVariant]
	add $04
	ldh [hActiveEntitySpriteVariant], a

jr_004_66fa:
	ld de, $66cc
	call DrawEntity16x16
	jp Jump_004_6415


Jump_004_6703:
	call GetEntityTimer
	jr nz, jr_004_6715

	ld [hl], $18
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call IncrementEntityState

jr_004_6715:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_672a

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_672a

	and $80
	jr z, jr_004_6729

	inc [hl]
	inc [hl]

jr_004_6729:
	dec [hl]

jr_004_672a:
	ret


	db $08, $f8

Jump_004_672d:
	call GetEntityTimer
	jr nz, jr_004_6738

	ld [hl], $50
	call IncrementEntityState
	ld [hl], b

jr_004_6738:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_6765

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, $672b
	add hl, de
	sub [hl]
	pop hl
	and a
	jr z, jr_004_6765

	and $80
	jr z, jr_004_6764

	inc [hl]
	inc [hl]

jr_004_6764:
	dec [hl]

jr_004_6765:
	ret


Call_04_6766::
	ld a, [wSceneVar2]
	and a
	jr nz, jr_004_67c5

	ld a, [wSceneVar3]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_67c5

	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_67c5

	ld a, [wEntityWorkRAM]
	ld hl, hActiveEntityX
	sub [hl]
	rlca
	rlca
	and $01
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr nz, jr_004_67c5

	ld a, [wEntityWorkRAM]
	ld hl, hActiveEntityX
	sub [hl]
	add $18
	cp $30
	jr nc, jr_004_67c5

	ld a, [wSceneVar1]
	ld hl, hActiveEntityY
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_67c5

	call IncrementEntityState
	ld [hl], $02
	ld hl, wSceneVar2
	inc [hl]
	ld hl, wSceneVar4
	inc [hl]
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a

jr_004_67c5:
	ret


Call_04_67C6::
	call StartWarpFadeOutMusic
	ldh a, [hLinkX]
	swap a
	and $0f
	ld e, a
	ldh a, [hLinkY]
	sub $08
	and $f0
	or e
	ld [wWarpDestPosition], a
	xor a
	ld [wLinkFrozen], a
	ret


	db $4c, $00, $4c, $20, $4e, $00, $4e, $20, $7c, $00, $7c, $20, $7e, $00, $7e, $20

Call_04_67EF::
	ld hl, $d45e
	inc [hl]
	ld de, $67df
	ldh a, [hMapId]
	cp $01
	jr nz, jr_004_67ff

	ld de, $67e7

jr_004_67ff:
	call DrawEntity16x16
	call ReturnIfNonInteractive_04
	call EntityCheckWeaponHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_680B::
	dw Jump_04_6813
	dw Jump_04_68C9

	db $00, $03, $01, $02

Jump_04_6813::
	call GetEntityDropTimer
	jr nz, jr_004_681e

	ld [hl], $10
	call IncrementEntityState
	ret


jr_004_681e:
	ld a, [wLinkMotionState]
	cp $00
	jp nz, Jump_004_68b0

	ldh a, [hLinkSpeedX]
	push af
	ldh a, [hLinkSpeedY]
	push af
	ld e, $00
	ldh a, [hActiveEntityType]
	cp $52
	ld a, $14
	jr nz, jr_004_6839

	inc e
	ld a, $08

jr_004_6839:
	push de
	call GetVectorTowardsLink
	pop de
	ldh a, [hMultiPurpose0]
	bit 0, e
	jr z, jr_004_6846

	cpl
	inc a

jr_004_6846:
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	bit 0, e
	jr z, jr_004_6850

	cpl
	inc a

jr_004_6850:
	ldh [hLinkSpeedX], a
	push bc
	call ApplyLinkSpeed
	call Call_3E49
	pop bc
	pop af
	ldh [hLinkSpeedY], a
	pop af
	ldh [hLinkSpeedX], a
	xor a
	ld [wLinkPushingTimer], a
	ldh a, [hActiveEntityType]
	cp $52
	jp nz, Jump_004_68b0

	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_004_68a0

	call GetEntityXDistanceToLink_04
	add $04
	cp $08
	jr nc, jr_004_68a0

	call GetEntityYDistanceToLink_04
	add $04
	cp $08
	jr nc, jr_004_68a0

	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
	ldh a, [hActiveEntityDrawY]
	ldh [hLinkY], a
	ld a, $06
	ld [wLinkMotionState], a
	call ResetSpinAttackAndDash
	ld [wLinkMotionCounter], a
	ld a, $ff
	ld [wHoleCollisionType], a
	ld a, $0c
	ldh [hWaveSfx], a
	ret


jr_004_68a0:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $680f
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a

Jump_004_68b0:
	call Call_04_68D9
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_004_68c8

	ld a, $1f
	ldh [hNoiseSfx], a

jr_004_68c8:
	ret


Jump_04_68C9::
	call GetEntityDropTimer
	jr nz, jr_004_68d4

	ld [hl], $40
	call IncrementEntityState
	ld [hl], b

jr_004_68d4:
	ld a, $00
	jp SetEntitySpriteVariant


Call_04_68D9::
	ld e, $0f
	ld d, b

Jump_004_68dc:
	push de
	ld a, e
	cp c
	jp z, Jump_004_6971

	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jp z, Jump_004_6971

	call LoadEntityPosition
	push bc
	push de
	pop bc
	ldh a, [hFrameCounter]
	xor c
	and $01
	jr nz, jr_004_6970

	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
	ldh a, [hActiveEntityY]
	ldh [hLinkY], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
	ld a, $10
	call GetVectorTowardsLink
	ld e, $00
	ldh a, [hActiveEntityType]
	cp $52
	jr nz, jr_004_6920

	inc e

jr_004_6920:
	ldh a, [hMultiPurpose0]
	bit 0, e
	jr nz, jr_004_6928

	cpl
	inc a

jr_004_6928:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	bit 0, e
	jr nz, jr_004_6935

	cpl
	inc a

jr_004_6935:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call LoadEntityPosition
	call UpdateEntityPosWithSpeed_04
	call EntityCheckWalls
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $02
	cp $04
	jr nc, jr_004_695e

	ldh a, [hActiveEntityDrawY]
	ld hl, hLinkY
	sub [hl]
	add $02
	cp $04
	jr nc, jr_004_695e

	call DespawnEntity_04

jr_004_695e:
	pop af
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop af
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a

jr_004_6970:
	pop bc

Jump_004_6971:
	pop de
	dec e
	ld a, e
	cp $ff
	jp nz, Jump_004_68dc

	ret


Call_04_697A::
	ldh a, [hMapId]
	cp $14
	jr c, jr_004_6995

	ldh a, [hRoomStatus]
	and $10
	jp nz, DespawnEntity_04

	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c
	jr jr_004_69a1

jr_004_6995:
	ld e, a
	ld d, b
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	and $01
	jp nz, DespawnEntity_04

jr_004_69a1:
	call Call_04_6A94
	call LoadEntityPosition
	call ReturnIfNonInteractive_04
	call ApplyRecoilIfNeeded_04
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $00
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_69B9::
	dw Jump_04_69BF
	dw Jump_04_6A0A
	dw Jump_04_6A37

Jump_04_69BF::
	call GetEntityTimer
	jr nz, jr_004_69f1

	ldh a, [hFrameCounter]
	xor c
	and $07
	jr nz, jr_004_69d0

	ld a, $04
	call SetEntitySpeedTowardsLink

jr_004_69d0:
	call UpdateEntityPosWithSpeed_04
	call EntityCheckWalls
	call GetEntityXDistanceToLink_04
	add $30
	cp $60
	jr nc, jr_004_69f1

	call GetEntityYDistanceToLink_04
	add $30
	cp $60
	jr nc, jr_004_69f1

	call GetEntityTimer
	ld [hl], $28
	call IncrementEntityState

jr_004_69f0:
	ret


jr_004_69f1:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_004_69f0

Jump_004_69f7:
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


	db $04, $0c, $00, $08

Jump_04_6A0A::
	call GetEntityTimer
	jr nz, jr_004_6a34

	call GetEntityDirectionToLink_04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ld d, b
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $0f
	ld hl, $6a06
	add hl, de
	cp [hl]
	jr nz, jr_004_6a34

	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $38
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
	call IncrementEntityState

jr_004_6a34:
	jp Jump_004_69f7


Jump_04_6A37::
	call AddPrivate1SpeedToPrivate3_04
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
	dec [hl]
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_6a4b

	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]

jr_004_6a4b:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6a57

	and $80
	jr z, jr_004_6a73

jr_004_6a57:
	ld [hl], b
	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer
	ld [hl], $10
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6a06
	add hl, de
	ld a, [hl]
	add $08
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], a

jr_004_6a73:
	ret


	db $70, $00, $72, $00, $74, $00, $76, $00, $78, $00, $78, $20, $0a, $06, $03, $01
	db $00, $01, $03, $06, $0a, $0e, $11, $13, $14, $13, $11, $0e, $0a, $06, $03, $01

Call_04_6A94::
	ld de, $6a74
	call DrawEntity16x16
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6afe

	xor a
	ldh [hMultiPurpose0], a
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
	bit 1, a
	jr nz, jr_004_6ad8

	cp $01
	ld a, [hl]
	jr nz, jr_004_6abd

	ld hl, hMultiPurpose0
	inc [hl]
	cpl
	inc a

jr_004_6abd:
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
	ld hl, wEntityPrivate4
	add hl, bc
	ldh a, [hMultiPurpose0]
	and a
	ld a, [hl]
	jr z, jr_004_6acf

	cpl
	and $0f

jr_004_6acf:
	ld hl, hActiveEntityDrawY
	add [hl]
	add $f3
	ld [hl], a
	jr jr_004_6b1e

jr_004_6ad8:
	cp $02
	ld a, [hl]
	jr nz, jr_004_6ae3

	ld hl, hMultiPurpose0
	inc [hl]
	cpl
	inc a

jr_004_6ae3:
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld hl, wEntityPrivate4
	add hl, bc
	ldh a, [hMultiPurpose0]
	and a
	ld a, [hl]
	jr nz, jr_004_6af5

	cpl
	and $0f

jr_004_6af5:
	ld hl, hActiveEntityX
	add [hl]
	add $f8
	ld [hl], a
	jr jr_004_6b1e

jr_004_6afe:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $6a80
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	add $f0
	ldh [hActiveEntityDrawY], a
	ld hl, $6a84
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	add $f3
	ldh [hActiveEntityX], a

jr_004_6b1e:
	ld a, $02
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6a74
	call DrawEntity16x16
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_004_6bb0

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_004_6b4b

	call GetEntityTimer1
	jr nz, jr_004_6b4b

	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $40
	call EntityCheckHits
	call Call_04_6BB1

jr_004_6b4b:
	ldh a, [hActiveEntityX]
	add $04
	ld hl, wEntityX
	add hl, bc
	sub [hl]
	sra a
	sra a
	ldh [hMultiPurpose0], a
	ldh [hMultiPurpose2], a
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
	sra a
	sra a
	ldh [hMultiPurpose1], a
	ldh [hMultiPurpose3], a
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	call LoadEntityPosition
	ld a, $03

jr_004_6b7c:
	ldh [hMultiPurpose4], a
	ldh a, [hActiveEntityDrawY]
	ld hl, hMultiPurpose1
	add [hl]
	ld [de], a
	inc de
	ldh a, [hActiveEntityX]
	ld hl, hMultiPurpose0
	add [hl]
	ld [de], a
	inc de
	ld a, $24
	ld [de], a
	inc de
	ld a, $00
	ld [de], a
	inc de
	ldh a, [hMultiPurpose0]
	ld hl, hMultiPurpose2
	add [hl]
	ldh [hMultiPurpose0], a
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	add [hl]
	ldh [hMultiPurpose1], a
	ldh a, [hMultiPurpose4]
	dec a
	jr nz, jr_004_6b7c

	ld a, $03
	call ReserveOAMEntriesFar

Jump_004_6bb0:
	ret


Call_04_6BB1::
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose4], a
	swap a
	and $0f
	ld e, a
	ldh a, [hActiveEntityDrawY]
	sub $10
	add $04
	ldh [hMultiPurpose5], a
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, de
	ld h, a
	ld a, [hl]
	ldh [hRoomObjectType], a
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	cp $00
	jr z, jr_004_6bff

	cp $01
	jr nz, jr_004_6bff

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call GetEntityTimer1
	ld [hl], $08
	ld a, $07
	ldh [hJingle], a

Call_04_6BF2::
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $05
	call AddTransientVfx

jr_004_6bff:
	ret


	db $70, $00, $70, $20, $78, $00, $7a, $00, $74, $00, $76, $00, $7c, $00, $7e, $00
	db $72, $00, $72, $20, $7e, $20, $7c, $20, $76, $20, $74, $20, $7a, $20, $78, $20
	db $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa, $00, $06, $0c, $0e
	db $10, $0e, $0c, $06

Call_04_6C34::
	ldh a, [hActiveEntityState]
	and a
	jp nz, Jump_004_6ce2

	ld de, $6c00
	call DrawEntity16x16
	call ReturnIfNonInteractive_04
	call EntityCheckContactDamage
	call EntityCheckWalls
	call GetEntityTimer
	jr z, jr_004_6c87

	cp $10
	jr nz, jr_004_6c86

	ld a, $2b
	call SpawnEntity
	jr c, jr_004_6c86

	ld a, $08
	ldh [hNoiseSfx], a
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose2]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
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

jr_004_6c86:
	ret


jr_004_6c87:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $07
	jr nz, jr_004_6ce1

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	and $0f
	ld [hl], a
	srl a
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	ld a, $2a
	call SpawnEntity
	jr c, jr_004_6ce1

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], c
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c0
	push bc
	ldh a, [hMultiPurpose2]
	ld c, a
	ld hl, $6c24
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $6c20
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	pop bc

jr_004_6ce1:
	ret


Jump_004_6ce2:
	call EntityCheckObjectCollision
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jp nz, DespawnEntity_04

	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_6d2f

	ldh a, [hActiveEntityY]
	ld hl, hLinkY
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_6d2f

	call DespawnEntity_04
	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_004_6d2f

	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_004_6d2f

	ld [hl], $20
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $10
	push bc
	push de
	pop bc
	ld a, $40
	call SetEntitySpeedTowardsLink
	pop bc
	ret


jr_004_6d2f:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	add [hl]
	ld [hl], a
	cp $9c
	jp nc, DespawnEntity_04

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	add [hl]
	ld [hl], a
	cp $78
	ret c

DespawnEntity_04::
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


ApplyRecoilIfNeeded_04::
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6d9c

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
	call UpdateEntityPosWithSpeed_04
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_004_6d8f

	call EntityCheckWalls

jr_004_6d8f:
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_004_6d9c:
	ret


UpdateEntityPosWithSpeed_04::
	call AddEntitySpeedToPosX_04

AddEntitySpeedToPosY_04::
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPosX_04
	pop bc
	ret


AddEntitySpeedToPosX_04::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6dd5

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityX

Jump_004_6dc2:
jr_004_6dc2:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_004_6dcc

	ld e, $f0

jr_004_6dcc:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_004_6dd5:
	ret


AddEntityZSpeedToPos_04::
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6dd5

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityZ
	jr jr_004_6dc2

AddPrivate1SpeedToPrivate3_04::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	push af
	swap a
	and $f0
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityPrivate3
	jp Jump_004_6dc2


GetEntityXDistanceToLink_04::
	ld e, $00
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_004_6e16

	inc e

jr_004_6e16:
	ld d, a
	ret


GetEntityYDistanceToLink_04::
	ld e, $02
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_004_6e26

	inc e

jr_004_6e26:
	ld d, a
	ret


GetEntityDirectionToLink_04::
	call GetEntityXDistanceToLink_04
	ld a, e
	ldh [hMultiPurpose0], a
	ld a, d
	bit 7, a
	jr z, jr_004_6e35

	cpl
	inc a

jr_004_6e35:
	push af
	call GetEntityYDistanceToLink_04
	ld a, e
	ldh [hMultiPurpose1], a
	ld a, d
	bit 7, a
	jr z, jr_004_6e43

	cpl
	inc a

jr_004_6e43:
	pop de
	cp d
	jr nc, jr_004_6e4b

	ldh a, [hMultiPurpose0]
	jr jr_004_6e4d

jr_004_6e4b:
	ldh a, [hMultiPurpose1]

jr_004_6e4d:
	ld e, a
	ret


Call_04_6E4F::
	ld a, [wIsMarinFollowingLink]
	push af
	ldh a, [hRoomStatus]
	and $10
	jr z, jr_004_6e5d

	xor a
	ld [wIsMarinFollowingLink], a

jr_004_6e5d:
	call Call_04_6E65
	pop af
	ld [wIsMarinFollowingLink], a
	ret


Call_04_6E65::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_004_7440

	ld a, c
	ld [wSongShowTimer], a
	ld a, $02
	ld [$c50a], a
	call GetEntityTimer1
	dec a
	jr nz, jr_004_6e81

	ld a, $19
	ldh [hJingle], a

jr_004_6e81:
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	jr z, jr_004_6e9d

	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_004_6e94

	call GetEntityDirectionToLink_04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

jr_004_6e94:
	call AnimateEntityWalking_04
	ld de, $7662
	call DrawEntity16x16

jr_004_6e9d:
	call Call_04_7377
	call LoadEntityPosition
	call BlockLinkAtEntity_04
	call Call_04_7330
	ldh a, [hActiveEntityState]
	cp $03
	jr c, jr_004_6ebc

	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_6ebc

	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a

jr_004_6ebc:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_6EBF::
	dw Jump_04_6EF7
	dw Jump_04_6F72
	dw Jump_04_6FCF
	dw Jump_04_702F
	dw Jump_04_70AD
	dw Jump_04_7107
	dw Jump_04_712D
	dw Jump_04_716C
	dw Jump_04_71B6
	dw Jump_04_71EC
	dw Jump_04_7209
	dw Jump_04_7265
	dw Jump_04_72A7

	db $38, $58, $78, $58, $40, $70
	db $2e, $2e, $2e, $3e, $4e, $4e, $00, $00, $00, $04, $01, $02, $05, $02, $02, $00
	db $03, $04, $81, $81, $81, $82, $81, $81

Jump_04_6EF7::
	ld e, $06
	ld d, $00

jr_004_6efb:
	push de
	ld a, $4f
	ld e, $0e
	call SpawnEntityFromSlot
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, $6ed0
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $6ed6
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, $6ee2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
	ld hl, $6ee8
	add hl, de
	ld a, [hl]
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], a
	ld hl, $6edc
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	push bc
	push de
	pop bc
	call Call_04_761D
	pop bc
	pop de
	dec e
	jr nz, jr_004_6efb

	xor a
	ld [$d206], a
	ld a, $10
	ld [wSmasherSlot], a
	ld [$d203], a
	ld a, $16
	ld [wEvilEagleAttack], a
	ld a, $18
	ld [wTarinSlot], a
	ld a, $00
	ld [wEntityWorkRAM3], a
	ld a, $04
	ld [wSmasherBallSlot], a
	call IncrementEntityState
	ld a, [wTradeSequenceItem]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
	ret


Jump_04_6F72::
	ld a, [wLinkFrozen]
	and a
	ret nz

	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_6f8e

	ldh a, [hLinkX]
	cp $6c
	jr c, jr_004_6f8e

	ld hl, $daa0
	set 4, [hl]
	ld a, $6b
	ldh [hLinkX], a
	jr jr_004_6f93

jr_004_6f8e:
	call CanTalkToEntityWide_04
	jr nc, jr_004_6fce

jr_004_6f93:
	xor a
	ld [wLinkWalkingFrameCount], a
	ldh [hLinkSpeedX], a
	ld e, $06
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6fa4

	dec e

jr_004_6fa4:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp e
	jr c, jr_004_6fb2

	ld a, $40
	call OpenDialog
	ret


jr_004_6fb2:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_6fbc

	ld a, $f7
	jr jr_004_6fc8

jr_004_6fbc:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ld a, $3b
	jr z, jr_004_6fc8

	ld a, $3e

jr_004_6fc8:
	call OpenDialog
	call IncrementEntityState

jr_004_6fce:
	ret


Jump_04_6FCF::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, [wDialogState]
	and a
	jr nz, jr_004_700b

	ld a, [wDialogIndex]
	cp $f8
	jr z, jr_004_6fe7

	ld a, [wDialogAnswer]
	cp $01
	jr nc, jr_004_6ffa

jr_004_6fe7:
	ld a, [wRupeeCountLow]
	sub $10
	ld a, [wRupeeCountHigh]
	sbc $00
	jr nc, jr_004_700c

	ld a, $34
	call OpenDialog
	jr Call_04_7005

jr_004_6ffa:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, Call_04_7005

	ld a, $f8
	jp OpenDialog


Call_04_7005::
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01

jr_004_700b:
	ret


jr_004_700c:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_7015

	ld [wIsMarinInAnimalVillage], a

jr_004_7015:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld [hl], $01
	and a
	ld a, $3c
	jr z, jr_004_7023

	ld a, $3f

jr_004_7023:
	call OpenDialog
	ld a, $0a
	ld [wSubtractRupeeBufferLow], a
	call IncrementEntityState
	ret


Jump_04_702F::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	ld a, $10
	ld [$d203], a
	ldh a, [hFrameCounter]
	and $10
	ld [wSmasherSlot], a
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_7095

	call GetEntityDropTimer
	jr z, jr_004_7058

	dec a
	jr nz, jr_004_7057

	call Call_04_70A5

jr_004_7057:
	ret


jr_004_7058:
	call ReturnIfNonInteractive_04
	push bc
	ld a, [wSingingMarinSlot]
	ld c, a
	ldh a, [hFrameCounter]
	and $10
	ld a, $04
	jr z, jr_004_7069

	inc a

jr_004_7069:
	call SetEntitySpriteVariant
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f8
	call AddEntitySpeedToPosX_04
	ld hl, wEntityX
	add hl, bc
	pop bc
	ld a, [hl]
	cp $28
	jr nz, jr_004_7094

	call GetEntityDropTimer
	ld [hl], $18
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $02
	ld e, $01
	call Call_04_71A8

jr_004_7094:
	ret


jr_004_7095:
	ldh a, [hJoypadHeld]
	and $20
	jr z, jr_004_70ac

	ldh a, [hLinkX]
	cp $20
	jr c, jr_004_70ac

	cp $30
	jr nc, jr_004_70ac

Call_04_70A5::
	call IncrementEntityState

Call_04_70A8::
	ld a, $20
	ldh [hNoiseSfx], a

jr_004_70ac:
	ret


Jump_04_70AD::
	call Call_04_70F3
	ld a, $10
	ld [$d203], a
	ldh a, [hFrameCounter]
	and $10
	ld [wSmasherSlot], a
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_70c9

	ld e, $02
	call Call_04_71A8
	jr jr_004_70cf

jr_004_70c9:
	ldh a, [hJoypadHeld]
	and $20
	jr z, jr_004_70e0

jr_004_70cf:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_70f2

	ld a, [wTarinSlot]
	inc a
	ld [wTarinSlot], a
	cp $88
	jr c, jr_004_70f2

jr_004_70e0:
	call IncrementEntityState
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, Call_04_70EE

	call GetEntityDropTimer
	ld [hl], $10

Call_04_70EE::
	ld a, $21
	ldh [hNoiseSfx], a

jr_004_70f2:
	ret


Call_04_70F3::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $02
	ldh [hLinkDirection], a
	ret


Jump_04_7107::
	call Call_04_70F3
	ld a, $10
	ld [wSmasherSlot], a
	ldh a, [hFrameCounter]
	and $10
	ld [$d203], a
	call GetEntityDropTimer
	ret nz

	ld a, [wIsMarinFollowingLink]
	and a
	jr nz, jr_004_7126

	ldh a, [hJoypadHeld]
	and $10
	jr z, jr_004_712c

jr_004_7126:
	call Call_04_70A8
	call IncrementEntityState

jr_004_712c:
	ret


Jump_04_712D::
	call Call_04_70F3
	ld a, $10
	ld [wSmasherSlot], a
	ldh a, [hFrameCounter]
	and $10
	ld [$d203], a
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_7144

	jr jr_004_714a

jr_004_7144:
	ldh a, [hJoypadHeld]
	and $10
	jr z, jr_004_715b

jr_004_714a:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_716b

	ld a, [wEvilEagleAttack]
	inc a
	ld [wEvilEagleAttack], a
	cp $55
	jr c, jr_004_716b

jr_004_715b:
	call IncrementEntityState
	call Call_04_70EE
	call GetEntityTimer
	ld [hl], $60
	ld e, $00
	call Call_04_71A8

jr_004_716b:
	ret


Jump_04_716C::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	ld a, $10
	ld [wSmasherSlot], a
	ld [$d203], a
	call GetEntityTimer
	cp $30
	jr nc, jr_004_718a

	ld hl, wSmasherBallSlot
	ld [hl], $02

jr_004_718a:
	and a
	jr nz, jr_004_71b5

	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_71b5

	ld a, [$d206]
	inc a
	ld [$d206], a
	cp $0f
	jr nz, jr_004_71b5

	call GetEntityTimer
	ld [hl], $ff
	call IncrementEntityState
	ld e, $00

Call_04_71A8::
	ld a, [wIsMarinFollowingLink]
	and a
	ret z

	ld a, e
	ldh [hLinkDirection], a
	push bc
	call UpdateLinkAnimationStateFar
	pop bc

jr_004_71b5:
	ret


Jump_04_71B6::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	call GetEntityTimer
	cp $c8
	jr nz, jr_004_71cc

	ld hl, $d206
	ld [hl], $10

jr_004_71cc:
	cp $a0
	jr nz, jr_004_71d5

	ld hl, wSmasherBallSlot
	ld [hl], $03

jr_004_71d5:
	cp $50
	jr nz, jr_004_71e2

	ld hl, wSmasherBallSlot
	ld [hl], $04
	call Call_04_72AB
	ret


jr_004_71e2:
	and a
	jr nz, jr_004_71eb

	call IncrementEntityState
	call Call_04_70A8

jr_004_71eb:
	ret


Jump_04_71EC::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_7208

	ld a, [$d206]
	dec a
	ld [$d206], a
	jr nz, jr_004_7208

	call IncrementEntityState

jr_004_7208:
	ret


Jump_04_7209::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, $16
	ldh [hLinkY], a
	ld a, $18
	ldh [hLinkX], a
	ld a, [wTarinSlot]
	ld [$c201], a
	ld a, [wEvilEagleAttack]
	ld [$c211], a
	push bc
	ld c, $01
	ld a, $04
	call SetEntitySpeedTowardsLink
	call UpdateEntityPosWithSpeed_04
	ld a, [$c201]
	ld [wTarinSlot], a
	ld a, [$c211]
	ld [wEvilEagleAttack], a
	pop bc
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	ld a, [wTarinSlot]
	cp $18
	jr nz, jr_004_7264

	ld a, [wEvilEagleAttack]
	cp $16
	jr nz, jr_004_7264

	call GetEntityTimer
	ld [hl], $c0
	call IncrementEntityState
	call Call_04_70EE

jr_004_7264:
	ret


Jump_04_7265::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ld [wEntityWorkRAM3], a
	call GetEntityTimer
	cp $60
	jr nz, jr_004_729b

	ld hl, wSmasherBallSlot
	ld [hl], $02
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_729a

	ld [hl], $00
	dec a
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld [hl], $02
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_729a

	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $07

jr_004_729a:
	ret


jr_004_729b:
	and a
	jr nz, jr_004_72a6

	ld hl, wSmasherBallSlot
	ld [hl], $04
	call IncrementEntityState

jr_004_72a6:
	ret


Jump_04_72A7::
	call Call_04_7005
	ret


Call_04_72AB::
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_72d8

	ld a, $ff
	call SetEntitySpriteVariant
	ld a, $4f
	call SpawnEntity
	ld a, [wTarinSlot]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld a, [wEvilEagleAttack]
	add $18
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $06
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]

jr_004_72d8:
	ld e, $0f
	ld d, b

jr_004_72db:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_7329

	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_004_7329

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $4f
	jr nz, jr_004_7329

	ld hl, wEntityX
	add hl, de
	ld a, [wTarinSlot]
	sub [hl]
	add $04
	cp $08
	jr nc, jr_004_7329

	ld hl, wEntityY
	add hl, de
	ld a, [wEvilEagleAttack]
	add $18
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_004_7329

	ld hl, wEntityState
	add hl, de
	ld [hl], $01
	ld a, e
	inc a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	call GetEntityTimer1
	ld [hl], $10
	ld hl, wEntityPrivate4
	inc [hl]
	ret


jr_004_7329:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_004_72db

	ret


Call_04_7330::
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_735a

	dec a
	ld e, a
	ld d, b
	ld a, [wTarinSlot]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld a, [wEvilEagleAttack]
	add $18
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld a, $10
	ld hl, $d206
	sub [hl]
	add $fe
	ld hl, wEntityZ
	add hl, de
	ld [hl], a

jr_004_735a:
	ret


	db $76, $00, $78, $00, $78, $20, $76, $20, $70, $00, $70, $20, $72, $00, $70, $20
	db $72, $00, $72, $20, $7e, $00, $7e, $20, $26, $00, $26, $00

Call_04_7377::
	ld a, [wTarinSlot]
	ldh [hActiveEntityX], a
	ld a, [wEvilEagleAttack]
	ld hl, $d206
	add [hl]
	add $08
	ldh [hActiveEntityDrawY], a
	ld a, [wSmasherBallSlot]
	ldh [hActiveEntitySpriteVariant], a
	ld de, $735b
	call DrawEntity16x16
	ld a, [wTarinSlot]
	ldh [hActiveEntityX], a
	ld a, [wEvilEagleAttack]
	ldh [hActiveEntityDrawY], a
	ld a, [wEntityWorkRAM3]
	ldh [hActiveEntitySpriteVariant], a
	ld de, $735b
	call DrawEntity16x16
	ld a, [$d206]
	cp $08
	jr c, jr_004_73c4

	ld a, [wTarinSlot]
	ldh [hActiveEntityX], a
	ld a, [wEvilEagleAttack]
	add $10
	ldh [hActiveEntityDrawY], a
	ld a, $05
	ldh [hActiveEntitySpriteVariant], a
	ld de, $735b
	call DrawEntity16x16

jr_004_73c4:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_004_73f0

	ld a, [wTarinSlot]
	ldh [hActiveEntityX], a
	ld a, [wEvilEagleAttack]
	add $20
	ldh [hActiveEntityDrawY], a
	xor a
	ldh [hActiveEntitySpriteVariant], a
	ld de, $7373
	ld a, [wOAMNextIndex]
	push af
	call DrawEntity16x16
	pop af
	ld e, a
	ld d, b
	ld hl, $c031
	add hl, de
	inc [hl]
	inc hl
	inc hl
	inc hl
	inc hl
	dec [hl]

jr_004_73f0:
	ld hl, $c020
	ld a, $50
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld a, $7a
	ld [hli], a
	ld a, [wSmasherSlot]
	ld [hli], a
	ld a, $60
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld a, $3e
	ld [hli], a
	ld a, [wSmasherSlot]
	ld [hli], a
	ld a, $50
	ld [hli], a
	ld a, $30
	ld [hli], a
	ld a, $7c
	ld [hli], a
	ld a, [$d203]
	ld [hli], a
	ld a, $60
	ld [hli], a
	ld a, $30
	ld [hli], a
	ld a, $3e
	ld [hli], a
	ld a, [$d203]
	ld [hli], a
	ret


	db $ff, $ff, $9e, $10, $a6, $10, $8e, $10, $86, $10, $a8, $10, $9a, $10, $9c, $10
	db $6c, $00, $6e, $00, $6e, $20, $6c, $20

Jump_004_7440:
	ldh a, [hActiveEntitySpriteVariant]
	cp $06
	jr c, jr_004_7458

	ld de, $7420
	cp $07
	jr z, jr_004_7456

	ldh a, [hFrameCounter]
	and $10
	jr nz, jr_004_7456

	ld de, $7424

jr_004_7456:
	jr jr_004_7473

jr_004_7458:
	cp $03
	jr nz, jr_004_7465

	ld a, [wHasToadstool]
	and a
	jp nz, DespawnEntity_04

	jr jr_004_7478

jr_004_7465:
	cp $00
	jr nz, jr_004_7478

	ld a, [wTradeSequenceItem]
	and a
	jp nz, DespawnEntity_04

	ld de, $7434

jr_004_7473:
	call DrawEntity16x16
	jr jr_004_747e

jr_004_7478:
	ld de, $7428
	call DrawEntity8x16

jr_004_747e:
	call ReturnIfNonInteractive_04
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_7484::
	dw Jump_04_7490
	dw Jump_04_74C3
	dw Jump_04_74CE
	dw Jump_04_7525
	dw Jump_04_75EB
	dw Jump_04_7602

Jump_04_7490::
	call UpdateEntityPosWithSpeed_04
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_7499::
	dw Jump_04_74A3
	dw Jump_04_74AB
	dw Jump_04_74B3
	dw Jump_04_74BB
	dw Jump_04_74AA

Jump_04_74A3::
	ldh a, [hActiveEntityX]
	cp $3a
	jp c, Jump_004_7614

Jump_04_74AA::
	ret


Jump_04_74AB::
	ldh a, [hActiveEntityDrawY]
	cp $4e
	jp nc, Jump_004_7614

	ret


Jump_04_74B3::
	ldh a, [hActiveEntityX]
	cp $78
	jp nc, Jump_004_7614

	ret


Jump_04_74BB::
	ldh a, [hActiveEntityDrawY]
	cp $2e
	jp c, Jump_004_7614

	ret


Jump_04_74C3::
	call GetEntityDirectionToLink_04
	ld a, e
	xor $01
	ld e, a
	call Call_04_71A8
	ret


Jump_04_74CE::
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_74d8

	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a

jr_004_74d8:
	call AddEntityZSpeedToPos_04
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_7500

	xor a
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
	cp $07
	jr nc, jr_004_74fc

	ld [hl], b
	jr jr_004_7500

jr_004_74fc:
	ld a, $09
	ldh [hJingle], a

jr_004_7500:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_004_7511

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $56
	jr z, jr_004_7512

	inc a
	ld [hl], a

jr_004_7511:
	ret


jr_004_7512:
	add $0a
	ld [hl], a
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $0a
	call IncrementEntityState
	ret


	db $44, $43, $42, $41, $3d, $2a

Jump_04_7525::
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_004_752f

	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a

jr_004_752f:
	call AddEntityZSpeedToPos_04
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jp z, Jump_004_75ea

	xor a
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
	cp $07
	jr nc, jr_004_7553

	xor a
	ld [hl], a

jr_004_7553:
	ldh a, [hActiveEntitySpriteVariant]
	cp $06
	jr c, jr_004_7561

	ld a, $f9
	call OpenDialog
	jp IncrementEntityState


jr_004_7561:
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	add $07
	cp $0e
	ret nc

	ldh a, [hActiveEntityDrawY]
	ld hl, hLinkY
	sub [hl]
	add $05
	cp $0a
	ret nc

	ld a, [wSongShowTimer]
	ld e, a
	ld d, b
	ld hl, wEntityDyingTimer
	add hl, de
	ld a, [hl]
	and a
	ret nz

	ld [hl], $18
	ldh a, [hActiveEntitySpriteVariant]
	cp $00
	jr nz, jr_004_7596

	ld a, $01
	ld [wTradeSequenceItem], a
	call SpawnHeldItemEntity
	jp DespawnEntity_04


jr_004_7596:
	call DespawnEntity_04
	ld hl, hWaveSfx
	ld [hl], $01
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, $751f
	add hl, de
	ld a, [hl]
	call OpenDialog
	ldh a, [hActiveEntitySpriteVariant]
	dec a
	jr nz, jr_004_75b0

	ret


jr_004_75b0:
	dec a
	jr nz, jr_004_75bc

	ld a, [wAddRupeeBufferLow]
	add $1e
	ld [wAddRupeeBufferLow], a
	ret


jr_004_75bc:
	dec a
	jr nz, jr_004_75dc

	ld hl, wMaxMagicPowder
	ld a, [wMagicPowderCount]
	cp [hl]
	jr nc, jr_004_75cf

	add $10
	daa
	cp [hl]
	jr c, jr_004_75cf

	ld a, [hl]

jr_004_75cf:
	ld [wMagicPowderCount], a
	ld d, $0c
	call Call_3E95
	ld a, $0b
	ldh [hBGChangeRequest], a
	ret


jr_004_75dc:
	dec a
	jr nz, jr_004_75e5

	ld d, $04
	call Call_3E95
	ret


jr_004_75e5:
	ld a, $ff
	ld [wAddHealthBuffer], a

Jump_004_75ea:
	ret


Jump_04_75EB::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ld a, [wCanTalkToEntity]
	and a
	ret nz

	ld [wIsMarinInAnimalVillage], a
	ld a, $18
	ld [$c1bc], a
	jp IncrementEntityState


Jump_04_7602::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ret


	db $fc, $00, $04, $00, $00, $00, $04, $00, $fc, $00

Jump_004_7614:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

Call_04_761D::
	ld e, a
	ld d, b
	ld hl, $760a
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $760f
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ret


Call_04_7634::
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_004_7643

	call GetEntityDirectionToLink_04
	ld a, e
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_004_7643:
	call AnimateEntityWalking_04
	ld de, $7662
	call DrawEntity16x16
	call BlockLinkAtEntity_04
	call CanTalkToEntity_04
	jr nc, jr_004_7661

	ld a, [wRoomLoadCounter]
	cp $03
	ld a, $39
	jr c, jr_004_765e

	inc a

jr_004_765e:
	call OpenDialog

jr_004_7661:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_04_7682::
	ld a, [$c50a]
	and a
	jr nz, jr_004_7690

	ld a, $01
	ld [$c50a], a
	call Call_04_7826

jr_004_7690:
	ld a, [wSwordLevel]
	and a
	jr z, jr_004_769c

	ldh a, [hFrameCounter]
	and $5f
	jr nz, jr_004_76a5

jr_004_769c:
	call GetEntityDirectionToLink_04
	ld a, e
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_004_76a5:
	call AnimateEntityWalking_04
	ld de, $7662
	call DrawEntity16x16
	call Call_04_7AF5
	ldh a, [hActiveEntityState]
	cp $04
	jr nc, jr_004_76ba

	call BlockLinkAtEntity_04

jr_004_76ba:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_76BD::
	dw Jump_04_778F
	dw Jump_04_7847
	dw Jump_04_78F8
	dw Jump_04_7A7D
	dw Jump_04_7A87
	dw Jump_04_7AC2
	dw Jump_04_6398

	db $02, $b2, $b0, $b0, $98, $a4, $01, $7f, $7f, $98, $67, $02, $b1, $b0, $7f, $98
	db $a8, $01, $0a, $b3, $98, $6a, $02, $7f, $b2, $b0, $98, $ac, $01, $ba, $b1, $98
	db $6e, $02, $b1, $b0, $7f, $98, $b0, $01, $0a, $09, $98, $63, $02, $b9, $b8, $b0
	db $98, $a4, $01, $7f, $7f, $98, $63, $02, $b1, $b0, $7f, $98, $a4, $01, $0a, $09
	db $00, $98, $62, $43, $7f, $98, $83, $42, $7f, $98, $a3, $42, $7f, $00, $00, $00
	db $00, $98, $66, $43, $7f, $98, $87, $42, $7f, $98, $a7, $42, $7f, $00, $00, $00
	db $00, $98, $6a, $43, $7f, $98, $8b, $42, $7f, $98, $ab, $42, $7f, $00, $00, $00
	db $00, $98, $6e, $43, $7f, $98, $8f, $42, $7f, $98, $af, $42, $7f, $00, $00, $00
	db $00, $01, $02, $03, $00, $01, $02, $03, $04, $05, $02, $03, $04, $06, $02, $03
	db $04, $07, $08, $09, $0a, $30, $31, $32, $33, $2c, $2d, $39, $00, $00, $00, $00
	db $02, $00, $00, $00, $09, $00, $00, $00, $00, $00, $10, $20, $10, $80, $10, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $c8, $0a, $14, $0a, $d4
	db $0a, $00, $00, $00

Jump_04_778F::
	ld a, [$db46]
	and a
	jr z, jr_004_77d0

	ld hl, wEntityY
	add hl, bc
	ld [hl], $40
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, jr_004_77cf

	ldh a, [hLinkY]
	sub $01
	ldh [hLinkY], a
	cp $74
	jr nz, jr_004_77cf

	ld a, $38
	call OpenDialog
	ld hl, wEntityState
	add hl, bc
	ld [hl], $04
	ld a, $19
	ld [wMusicTrackToPlay], a

jr_004_77cf:
	ret


jr_004_77d0:
	ld e, $00
	ld d, b
	ld a, [wHasInstrument2]
	and $02
	jr z, jr_004_77dc

	ld e, $04

jr_004_77dc:
	push bc
	ld hl, wItemB
	ld c, $0b

jr_004_77e2:
	ld a, [wBoomerangTradedItem]
	cp $0b
	jr z, jr_004_77ee

	ld a, [hli]
	cp $0b
	jr nz, jr_004_77f0

jr_004_77ee:
	ld e, $08

jr_004_77f0:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_004_77e2

	ld hl, wItemB
	ld c, $0b

jr_004_77fb:
	ld a, [wBoomerangTradedItem]
	cp $05
	jr z, jr_004_7807

	ld a, [hli]
	cp $05
	jr nz, jr_004_7809

jr_004_7807:
	ld e, $0c

jr_004_7809:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_004_77fb

	ld hl, $774c
	add hl, de
	ld de, $c505
	ld c, $04

jr_004_7818:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_004_7818

	pop bc
	call IncrementEntityState
	call Call_04_7826
	ret


Call_04_7826::
	ld de, wDrawCommand
	push bc
	ld hl, $c505
	ld c, $04

jr_004_782f:
	ld a, [hli]
	and a
	jr z, jr_004_7838

	push hl
	call Call_04_7926
	pop hl

jr_004_7838:
	dec c
	jr nz, jr_004_782f

	pop bc
	ret


	db $00, $00, $00, $01, $01, $02, $02, $03, $03, $03

Jump_04_7847::
	ld a, [wShopItemCarried]
	and a
	jr z, jr_004_786c

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	jr z, jr_004_786c

	ld a, [wLinkMotionState]
	cp $00
	jr nz, jr_004_786c

	ldh a, [hLinkY]
	cp $7b
	jr c, jr_004_786c

	sub $02
	ldh [hLinkY], a
	ld a, $2f
	jp OpenDialog


jr_004_786c:
	ldh a, [hLinkY]
	cp $48
	jr nc, jr_004_78d8

	ldh a, [hLinkDirection]
	cp $02
	jr nz, jr_004_78d8

	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_004_78d8

	ld a, [wShopItemCarried]
	and a
	jr z, jr_004_789f

	ldh a, [hLinkX]
	add $00
	swap a
	and $0f
	ld e, a
	ld d, b
	ld hl, $783d
	add hl, de
	ld a, [$c50b]
	cp [hl]
	jr nz, jr_004_78d8

	ld a, $13
	ldh [hJingle], a
	jp Call_04_7908


jr_004_789f:
	ldh a, [hLinkX]
	add $00
	swap a
	and $0f
	ld e, a
	ld d, b
	ld hl, $783d
	add hl, de
	ld a, [hl]
	ld [$c50b], a
	ld e, a
	ld d, b
	ld hl, $c505
	add hl, de
	ld a, [hl]
	ld [wShopItemCarried], a
	ld [hl], b
	and a
	jr z, jr_004_78c3

	ld a, $13
	ldh [hJingle], a

jr_004_78c3:
	push bc
	ld a, e
	swap a
	ld e, a
	ld hl, $770c
	add hl, de
	ld de, wDrawCommand
	ld c, $0d

jr_004_78d1:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_004_78d1

	pop bc

jr_004_78d8:
	call CanTalkToEntityWide_04
	jr nc, jr_004_78f7

	ld a, [wShopItemCarried]
	and a
	jr z, jr_004_78f2

	dec a
	ld e, a
	ld d, b
	ld hl, $7760
	add hl, de
	ld a, [hl]
	call OpenDialog
	call IncrementEntityState
	ret


jr_004_78f2:
	ld a, $2e
	call OpenDialog

jr_004_78f7:
	ret


Jump_04_78F8::
	ld a, [wDialogState]
	and a
	ret nz

	ld a, [wDialogAnswer]
	cp $00
	jr z, jr_004_7946

	cp $02
	jr z, jr_004_791f

Call_04_7908::
	ld a, [$c50b]
	ld e, a
	ld d, b
	ld hl, $c505
	add hl, de
	ld a, [wShopItemCarried]
	ld [hl], a
	ld de, wDrawCommand
	call Call_04_7926
	xor a
	ld [wShopItemCarried], a

jr_004_791f:
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
	ret


Call_04_7926::
	push de
	dec a
	ld d, a
	sla a
	ld e, a
	sla a
	sla a
	add e
	add d
	ld e, a
	ld d, b
	ld hl, $76c9
	add hl, de
	pop de
	push bc
	ld c, $0b

jr_004_793c:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_004_793c

	xor a
	ld [de], a
	pop bc
	ret


jr_004_7946:
	ld a, [wShopItemCarried]
	ld e, a
	cp $02
	jr nz, jr_004_7956

	ld a, [wHealthIsFull]
	and a
	jr nz, jr_004_79a0

	jr jr_004_79a7

jr_004_7956:
	cp $04
	jr nz, jr_004_7974

	ld hl, wItemB
	ld d, $0c

jr_004_795f:
	ld a, [hli]
	cp $02
	jr z, jr_004_7969

	dec d
	jr nz, jr_004_795f

	jr jr_004_79a7

jr_004_7969:
	ld a, [wBombCount]
	ld hl, wMaxBombs
	cp [hl]
	jr nc, jr_004_79a0

	jr jr_004_79a7

jr_004_7974:
	cp $06
	jr nz, jr_004_7992

	ld hl, wItemB
	ld d, $0c

jr_004_797d:
	ld a, [hli]
	cp $05
	jr z, jr_004_7987

	dec d
	jr nz, jr_004_797d

	jr jr_004_79a7

jr_004_7987:
	ld a, [wArrowCount]
	ld hl, wMaxArrows
	cp [hl]
	jr nc, jr_004_79a0

	jr jr_004_79a7

jr_004_7992:
	cp $03
	jr nz, jr_004_79a7

	ld hl, wItemB
	ld d, $0c

jr_004_799b:
	ld a, [hli]
	cp $04
	jr nz, jr_004_79a4

jr_004_79a0:
	ld a, $29
	jr jr_004_79bf

jr_004_79a4:
	dec d
	jr nz, jr_004_799b

jr_004_79a7:
	ld d, b
	ld hl, $776a
	add hl, de
	ld a, [hl]
	ld hl, $7773
	add hl, de
	ld e, [hl]
	ld d, a
	ld a, [wRupeeCountLow]
	sub e
	ld a, [wRupeeCountHigh]
	sbc d
	jr nc, jr_004_79c9

	ld a, $34

jr_004_79bf:
	call OpenDialog
	ld hl, wEntityState
	add hl, bc
	ld [hl], $03
	ret


jr_004_79c9:
	ld hl, wShopItemCarried
	ld a, [hl]
	push af
	ld [hl], $00
	ld e, a
	ld d, b
	ld hl, $7785
	add hl, de
	ld a, [wSubtractRupeeBufferLow]
	add [hl]
	ld [wSubtractRupeeBufferLow], a
	rl a
	ld hl, $777c
	add hl, de
	rr a
	ld a, [wSubtractRupeeBufferHigh]
	adc [hl]
	ld [wSubtractRupeeBufferHigh], a
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
	pop af
	push af
	ld a, $35
	call OpenDialog
	pop af

Call_04_79FA::
	dec a
	rst $00

JumpTable_04_79FC::
	dw Jump_04_7A45
	dw Jump_04_7A71
	dw Jump_04_7A77
	dw Jump_04_7A4B
	dw Jump_04_7A0E
	dw Jump_04_7A19
	dw Jump_04_7A27
	dw Jump_04_7A2D
	dw Jump_04_7A3B

Jump_04_7A0E::
	ld d, $05
	call Call_3E95
	ld a, $20
	ld [wArrowCount], a
	ret


Jump_04_7A19::
	ld a, [wArrowCount]
	add $0a
	daa
	jr nc, jr_004_7a23

	ld a, $99

jr_004_7a23:
	ld [wArrowCount], a
	ret


Jump_04_7A27::
	ld d, $09
	call Call_3E95
	ret


Jump_04_7A2D::
	ld a, [$db47]
	add $0a
	daa
	jr nc, jr_004_7a37

	ld a, $99

jr_004_7a37:
	ld [$db47], a
	ret


Jump_04_7A3B::
	ld a, [wMedicineCount]
	add $01
	daa
	ld [wMedicineCount], a
	ret


Jump_04_7A45::
	ld d, $0b
	call Call_3E95
	ret


Jump_04_7A4B::
	ld a, [wBombCount]
	add $0a
	daa
	jr nc, jr_004_7a55

	ld a, $99

jr_004_7a55:
	ld [wBombCount], a
	ld d, $02
	call Call_3E95
	ret


	db $fa, $45, $db, $c6, $0a, $27, $30, $02, $3e, $99, $ea, $45, $db, $16, $0c, $cd
	db $95, $3e, $c9

Jump_04_7A71::
	ld a, $18
	ld [wAddHealthBuffer], a
	ret


Jump_04_7A77::
	ld d, $04
	call Call_3E95
	ret


Jump_04_7A7D::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_7a86

	call Call_04_7908

jr_004_7a86:
	ret


Jump_04_7A87::
	ld a, [wDialogState]
	and a
	jr nz, jr_004_7ac1

	ld a, $ca
	call SpawnEntity
	ld a, $26
	ldh [hNoiseSfx], a
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $c0
	call GetEntityTimer
	ld [hl], $c0
	call IncrementEntityState
	xor a
	ld [wMedicineCount], a
	ld a, $ff
	ld [wSubtractHealthBuffer], a

jr_004_7ac1:
	ret


Jump_04_7AC2::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	jr nz, jr_004_7ada

	ld a, [wHealth]
	and a
	jr nz, jr_004_7ada

	ld [$db46], a
	ld [$c50a], a
	jp DespawnEntity_04


jr_004_7ada:
	ret


	db $1d, $3d, $5d, $7d, $96, $10, $a8, $10, $86, $10, $80, $10, $88, $10, $ff, $ff
	db $90, $10, $ae, $10, $a0, $10, $2a, $40, $2a, $60

Call_04_7AF5::
	ld a, $04

jr_004_7af7:
	ldh [hMultiPurposeF], a
	ld e, a
	ld d, b
	ld hl, $c504
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_7b31

	dec a
	ldh [hActiveEntitySpriteVariant], a
	ld hl, $7ada
	ldh a, [hMultiPurposeF]
	ld e, a
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld a, $32
	ldh [hActiveEntityDrawY], a
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr nz, jr_004_7b1f

	ld hl, hActiveEntityDrawY
	ld [hl], $2f

jr_004_7b1f:
	cp $05
	jr nz, jr_004_7b2b

	ld de, $7add
	call DrawEntity16x16
	jr jr_004_7b31

jr_004_7b2b:
	ld de, $7adf
	call DrawEntity8x16

jr_004_7b31:
	ldh a, [hMultiPurposeF]
	dec a
	jr nz, jr_004_7af7

	call Call_04_7B3D
	call LoadEntityPosition
	ret


Call_04_7B3D::
	ld a, [wShopItemCarried]
	and a
	jr z, jr_004_7b6a

	dec a
	ldh [hActiveEntitySpriteVariant], a
	ld a, $01
	ld [wIsCarryingLiftedObject], a
	call ResetSpinAttackAndDash
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
	ldh a, [hLinkY]
	sub $0e
	ldh [hActiveEntityDrawY], a
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nz, jr_004_7b64

	ld de, $7add
	jp DrawEntity16x16


jr_004_7b64:
	ld de, $7adf
	call DrawEntity8x16

jr_004_7b6a:
	ret


BlockLinkAtEntity_04::
	call EntityTouchesLink
	jr nc, jr_004_7b8d

	call RestoreLinkPosition
	call ResetPegasusBoots
	ld a, [wHookshotChainSlot]
	and a
	jr z, jr_004_7b8d

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_004_7b8d

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_004_7b8d:
	ret


CanTalkToEntityWide_04::
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $20
	cp $30
	jr nc, jr_004_7bd1

	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_7bd1

	call GetEntityDirectionToLink_04
	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, jr_004_7bd1

	ld hl, wCanTalkToEntity
	ld [hl], $01
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wDialogCooldown
	or [hl]
	jr nz, jr_004_7bd1

	ld a, [wWindowY]
	cp $80
	jr nz, jr_004_7bd1

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_004_7bd1

	scf
	ret


jr_004_7bd1:
	and a
	ret


CanTalkToEntity_04::
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
	ld hl, wDialogCooldown
	or [hl]
	jr nz, jr_004_7c1a

	ld a, [wWindowY]
	cp $80
	jr nz, jr_004_7c1a

	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_7c1a

	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28
	jr nc, jr_004_7c1a

	call GetEntityDirectionToLink_04
	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, jr_004_7c1a

	ld hl, wCanTalkToEntity
	ld [hl], $01
	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_004_7c1a

	scf
	ret


jr_004_7c1a:
	and a
	ret


	db $06, $04, $02, $00

AnimateEntityWalking_04::
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7c1c
	add hl, de
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	pop hl
	and $01
	or [hl]
	jp SetEntitySpriteVariant


	db $21, $40, $c2, $09, $7e, $f5, $36, $01, $21, $50, $c2, $09, $7e, $f5, $36, $01
	db $cd, $9e, $3b, $21, $a0, $c2, $09, $7e, $f5, $21, $40, $c2, $09, $36, $ff, $21
	db $50, $c2, $09, $36, $ff, $cd, $9e, $3b, $21, $a0, $c2, $09, $f1, $b6, $77, $f1
	db $21, $50, $c2, $09, $77, $f1, $21, $40, $c2, $09, $77, $c9, $7a, $20, $78, $20
	db $78, $00, $7a, $00, $7e, $00, $7e, $20, $70, $00, $72, $00, $74, $00, $76, $00
	db $7c, $00, $7c, $20, $6a, $20, $68, $20, $68, $00, $6a, $00, $6e, $00, $6e, $20
	db $60, $00, $62, $00, $64, $00, $66, $00, $6c, $00, $6c, $20

Call_04_7CA7::
	ld de, $7c77
	ldh a, [hMapId]
	cp $07
	jr nz, jr_004_7cb3

	ld de, $7c8f

jr_004_7cb3:
	call GetEntityTimer1
	rla
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
	call DrawEntity16x16
	call ReturnIfNonInteractive_04
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_004_7cd9

	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_004_7cd9

	call IncrementEntityState
	call GetEntityDropTimer
	ld [hl], $6f

jr_004_7cd9:
	call ApplyRecoilIfNeeded_04
	call UpdateEntityPosWithSpeed_04
	call EntityCheckWalls
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_7CE5::
	dw Jump_04_7CF1
	dw Jump_04_7D2C

	db $08, $f8, $00, $00, $00, $00, $f8, $00

Jump_04_7CF1::
	call EntityCheckHits
	call GetEntityTimer
	jr nz, jr_004_7d19

	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	and $03
	ld e, a
	ld d, b
	ld hl, $7ce9
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $7ced
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_004_7d19:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


	db $05, $05, $04, $03, $02, $02, $02

Jump_04_7D2C::
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_004_7d37

	call IncrementEntityState
	ld [hl], b
	ret


jr_004_7d37:
	call EntityCheckWeaponHits
	call GetEntityXDistanceToLink_04
	add $12
	cp $24
	jr nc, jr_004_7d4c

	call GetEntityYDistanceToLink_04
	add $12
	cp $24
	jr c, jr_004_7d5a

jr_004_7d4c:
	ldh a, [hFrameCounter]
	xor c
	and $03
	jr nz, jr_004_7d58

	ld a, $0e
	call SetEntitySpeedTowardsLink

jr_004_7d58:
	jr jr_004_7d5d

jr_004_7d5a:
	call ClearEntitySpeed

jr_004_7d5d:
	call GetEntityDropTimer
	jp z, Jump_004_7e46

	cp $18
	jr nz, jr_004_7d6e

	ld [hl], $0a
	call GetEntityTimer1
	ld [hl], $30

jr_004_7d6e:
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $7d25
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


	db $7a, $20, $78, $20, $78, $00, $7a, $00, $6a, $20, $68, $20, $68, $00, $6a, $00
	db $08, $f8, $00, $00, $00, $00, $f8, $08

Call_04_7D97::
	ld de, $7d7f
	ldh a, [hMapId]
	cp $07
	jr nz, jr_004_7da3

	ld de, $7d87

jr_004_7da3:
	call DrawEntity16x16
	call ReturnIfNonInteractive_04
	call ApplyRecoilIfNeeded_04
	call GetEntityTimer1
	jr nz, jr_004_7db4

	call EntityCheckHits

jr_004_7db4:
	call UpdateEntityPosWithSpeed_04
	call EntityCheckWalls
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_04_7DBD::
	dw Jump_04_7DC3
	dw Jump_04_7DD7
	dw Jump_04_7E0E

Jump_04_7DC3::
	call GetEntityTimer
	jr nz, jr_004_7dcb

	call IncrementEntityState

jr_004_7dcb:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_04_7DD7::
	call GetRandomByte
	and $03
	jr z, jr_004_7de5

	call GetRandomByte
	and $03
	jr jr_004_7de8

jr_004_7de5:
	call GetEntityDirectionToLink_04

jr_004_7de8:
	ld e, a
	ld d, b
	ld hl, $7d8f
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $7d93
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	call GetRandomByte
	and $0f
	add $20
	ld [hl], a
	call IncrementEntityState
	ld [hl], b
	ret


Jump_04_7E0E::
	call EntityHitOtherEntities
	call GetEntityTimer
	jr z, jr_004_7e46

	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_004_7e26

	ld a, [hl]
	and $0c
	jr nz, jr_004_7e30

	jr jr_004_7e3c

jr_004_7e26:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jr jr_004_7e38

jr_004_7e30:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_004_7e38:
	ld a, $09
	ldh [hJingle], a

jr_004_7e3c:
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_004_7e46:
jr_004_7e46:
	call Call_04_7E4D
	call DespawnEntity_04
	ret


Call_04_7E4D::
	ld a, $02
	call SpawnEntity
	jr c, jr_004_7e71

	call PlayClinkNoise
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
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01

jr_004_7e71:
	ret


	db $56, $00, $56, $20, $54, $00, $54, $20, $52, $00, $52, $20, $50, $00, $50, $20

Call_04_7E82::
	ld de, $7e72
	call DrawEntity16x16
	call ReturnIfNonInteractive_04
	call ApplyRecoilIfNeeded_04
	call UpdateEntityPosWithSpeed_04
	call EntityCheckWalls
	ldh a, [hActiveEntityState]
	and $03
	rst $00

JumpTable_04_7E99::
	dw Jump_04_7EA1
	dw Jump_04_7EB6
	dw Jump_04_7EDA
	dw Jump_04_7F07

Jump_04_7EA1::
	ld a, $ff
	call SetEntitySpriteVariant
	call GetEntityTimer
	jr nz, jr_004_7eb3

	ld [hl], $1f
	call IncrementEntityState
	call ClearEntitySpeed

jr_004_7eb3:
	ret


	db $01, $00

Jump_04_7EB6::
	call GetEntityTimer
	jr nz, jr_004_7ec7

	call GetRandomByte
	and $3f
	add $70
	ld [hl], a
	call IncrementEntityState
	ret


jr_004_7ec7:
	ld hl, $7eb4

Jump_004_7eca:
	srl a
	srl a
	srl a
	srl a
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


Jump_04_7EDA::
	call EntityCheckHits
	call GetEntityTimer
	jr nz, jr_004_7eeb

	ld [hl], $1f
	call IncrementEntityState
	call ClearEntitySpeed
	ret


jr_004_7eeb:
	ldh a, [hFrameCounter]
	xor c
	push af
	and $0f
	jr nz, jr_004_7ef8

	ld a, $08
	call SetEntitySpeedTowardsLink

jr_004_7ef8:
	pop af
	srl a
	srl a
	and $01
	call SetEntitySpriteVariant
	inc [hl]
	inc [hl]
	ret


	db $00, $01

Jump_04_7F07::
	call GetEntityTimer
	jr nz, jr_004_7f1d

	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	call IncrementEntityState
	ld a, $08
	call SetEntitySpeedTowardsLink
	ret


jr_004_7f1d:
	ld hl, $7f05
	jp Jump_004_7eca


FlipSpriteBySpeedX_04::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	rl a
	ld a, $00
	jr c, jr_004_7f30

	ld a, $20

jr_004_7f30:
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [hl], a
	ret


ReturnIfNonInteractive_04::
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, jr_004_7f56

ReturnIfGameFrozen_04::
	ld a, [wGameplayType]
	cp $07
	jr z, jr_004_7f56

	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, jr_004_7f56

	ld a, [wRoomTransitionState]
	and a
	jr z, jr_004_7f57

jr_004_7f56:
	pop af

jr_004_7f57:
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
