; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $019", ROMX[$4000], BANK[$19]

;@ path: object/liftable_statue
;@ Sprites of the liftable statue (entity $9D), drawn by LiftableStatueHandler with DrawEntitySprites: four 8x16
;@ OAM entries of 4 bytes each - y offset, x offset (from the entity position), tile, attributes. A 16x32
;@ statue: top half tile $48 (left) and $48 mirrored (attribute $20 = x flip), bottom half $4A and $4A
;@ mirrored.
LiftableStatueSprites::
	db $f0, $00, $48, $00, $f0, $08, $48, $20, $00, $00, $4a, $00, $00, $08, $4a, $20
;@ path: object/liftable_statue
;@ The same statue drawn with tiles $78 / $7A, used on indoor map 1 (that dungeon's tile set keeps the statue
;@ there). Same format as LiftableStatueSprites.
LiftableStatueSpritesMap1::
	db $f0, $00, $78, $00, $f0, $08, $78, $20, $00, $00, $7a, $00, $00, $08, $7a, $20
;@ path: object/liftable_statue
;@ Sprite of one statue shard: one 8x16 OAM entry (tile $16, attributes 0), for DrawEntity8x16.
StatueShardSprite::
	db $16, $00

;@ def LiftableStatueHandler(slot: bc)
;@ path: object/liftable_statue
;@ Entity $9D: a heavy statue that Link can lift with the level-2 Power Bracelet and throw; it shatters where it
;@ lands. The same type is used for the six shards it breaks into (wEntityPrivate1 = 1): they fly apart,
;@ fall and disappear. States: 0 standing (LiftableStatueIdle), 1-2 carried / thrown (LiftableStatueThrown);
;@ while Link holds it the entity status is 7 (lifted) and the engine moves it.
;@ test: skip draws sprites and calls routines in other banks
LiftableStatueHandler::
;> if wEntityPrivate1[slot]:                # a shard
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .statue
;>     DrawEntity8x16(slot, StatueShardSprite)        # draw it
	ld de, StatueShardSprite
	call DrawEntity8x16
;>     ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;>     UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;>     AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;>     wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 2)   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>     if wEntityZ[slot] & 0x80: return ClearEntityStatus_19(slot)   # below the ground: gone
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, ClearEntityStatus_19
;>     return
	ret

.statue
;> sprites = LiftableStatueSpritesMap1 if hMapId == 1 else LiftableStatueSprites
	ld hl, LiftableStatueSprites
	ldh a, [hMapId]
	cp $01
	jr nz, .draw
	ld hl, LiftableStatueSpritesMap1
.draw
;> DrawEntitySprites(sprites, 4)                    # draw the 4 OAM entries
	ld c, $04
	call DrawEntitySprites
;> DrawEntityShadow(slot)                              # (bank $15)
	call DrawEntityShadow
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer(slot)                              # count down wEntityIgnoreHitsTimer
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)                              # react to Link's weapons (bank 3)
	call EntityCheckWeaponHits
;> return LiftableStatueStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/liftable_statue
;@ State routines of the liftable statue, indexed by its state: 0 standing, 1 and 2 carried / thrown.
LiftableStatueStates::
	dw LiftableStatueIdle
	dw LiftableStatueThrown
	dw LiftableStatueThrown

;@ def LiftableStatueIdle(slot: bc)
;@ path: object/liftable_statue
;@ The statue stands still and blocks Link. When Link is close (16 pixels left / right, 32 above, 16 below),
;@ has the Power Bracelet on a button and holds that button, he grabs it; pulling away from it (the
;@ direction pad held opposite to his facing) counts pulls. With the level-2 bracelet, 8 frames of pulling
;@ (3 with a Piece of Power) lift it: state 2, entity status 7 (carried).
;@ test: skip calls routines in other banks
LiftableStatueIdle::
;> EntityCheckWalls(slot)                              # background collision (bank 3)
	call EntityCheckWalls
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 0x10) >= 0x20: return LiftableStatueResetPulls(slot)
	add $10
	cp $20
	jp nc, LiftableStatueResetPulls
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 0x20) >= 0x30: return LiftableStatueResetPulls(slot)
	add $20
	cp $30
	jp nc, LiftableStatueResetPulls
;> if wItemUsePoseTimer: return LiftableStatueResetPulls(slot)      # Link is busy (swinging his sword, ...)
	ld a, [wItemUsePoseTimer]
	and a
	jp nz, LiftableStatueResetPulls
;> if wItemB == 0x03:                       # Power Bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .tryA
;>     if not hJoypadHeld & 0x20: return LiftableStatueResetPulls(slot)
	ldh a, [hJoypadHeld]
	and $20
	jr nz, .grab
	jr LiftableStatueResetPulls
.tryA
;> elif wItemA == 0x03:                     # on A
	ld a, [wItemA]
	cp $03
	jr nz, LiftableStatueResetPulls
;>     if not hJoypadHeld & 0x10: return LiftableStatueResetPulls(slot)
	ldh a, [hJoypadHeld]
	and $10
	jr z, LiftableStatueResetPulls
;> else:
;>     return LiftableStatueResetPulls(slot)
.grab
;> if wLinkIsCarrying: return LiftableStatueResetPulls(slot)
	ld a, [wLinkIsCarrying]
	and a
	jr nz, LiftableStatueResetPulls
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkIsCarrying = 1
	ld [wLinkIsCarrying], a
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;> hLinkAnimationState = mem[LiftPullPoses + d]    # Link's grabbing pose
	ld hl, LiftPullPoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;> if not hJoypadHeld & mem[LiftPullButtons + d]: return LiftableStatueResetPulls(slot)   # not pulling back
	ld hl, LiftPullButtons
	add hl, de
	ldh a, [hJoypadHeld]
	and [hl]
	jr z, LiftableStatueResetPulls
;> wLinkSpriteDX = mem[LiftPullSpriteDX + d]            # Link's pulling pose offsets
	ld hl, LiftPullSpriteDX
	add hl, de
	ld a, [hl]
	ld [wLinkSpriteDX], a
;> wLinkSpriteDY = mem[LiftPullSpriteDY + d]
	ld hl, LiftPullSpriteDY
	add hl, de
	ld a, [hl]
	ld [wLinkSpriteDY], a
;> hLinkAnimationState += 1                 # the pulling pose
	ld hl, hLinkAnimationState
	inc [hl]
;> if wPowerBraceletLevel != 2: return LiftableStatueResetPulls(slot)   # too heavy
	ld a, [wPowerBraceletLevel]
	cp $02
	jr nz, LiftableStatueResetPulls
;> needed = 3 if wActivePowerUp else 8
	ld e, $08
	ld a, [wActivePowerUp]
	and a
	jr z, .count
	ld e, $03
.count
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] < needed: return
	ld a, [hl]
	cp e
	jr c, LiftableStatueResetPulls.return
;> wEntityState[slot] = 2                   # lifted
	call IncrementEntityState
	ld [hl], $02
;> wEntityStatus[slot] = 7                  # carried by Link
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;> wEntityLiftStep[slot] = 0
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
;> wLiftDirection = hLinkDirection
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
;> wEntityTimer[slot] = 2
	call GetEntityTimer
	ld [hl], $02
;> hWaveSfx = 2                             # lifting sound
	ld hl, hWaveSfx
	ld [hl], $02
;> return LiftableStatueResetPulls(slot)

;@ def LiftableStatueResetPulls(slot: bc)
;@ path: object/liftable_statue
;@ The pull count starts again (Link let go, is out of reach, or just lifted the statue). The `ret` after it
;@ is the plain exit of LiftableStatueIdle.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $19
LiftableStatueResetPulls::
;> wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	ret

.return
;> return
	ret


;@ def LiftableStatueThrown(slot: bc)
;@ path: object/liftable_statue
;@ After Link throws it the statue flies with its speed and falls (gravity 2 per frame). When it hits a wall
;@ or the ground it shatters. In rooms whose event is triggered by throwing (wRoomEvent trigger $0B) the
;@ event fires when one of two tiles ($C50D, $C503) it touched is in the range $35-$3C.
;@ test: skip calls routines in other banks
LiftableStatueThrown::
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;> EntityCheckWalls(slot)                              # background collision
	call EntityCheckWalls
;> wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 2)
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if not wEntityCollisions[slot] & 0x0F:   # no wall hit
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, .shatter
;>     if not wEntityZ[slot] & 0x80: return  # still in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
.shatter
;> ShatterLiftableStatue(slot)
	call ShatterLiftableStatue
;> if (wRoomEvent & 0x1F) != 0x0B: return
	ld a, [wRoomEvent]
	and $1f
	cp $0b
	jr nz, .done
;> if 0x35 <= wEntityWallObjectY < 0x3D: return TriggerRoomEvent()   # the room's event happens (chime)
	ld a, [wEntityWallObjectY]
	cp $35
	jr c, .second
	cp $3d
	jr c, .solved
.second
;> if 0x35 <= wEntityWallObjectX < 0x3D:
	ld a, [wEntityWallObjectX]
	cp $35
	jr c, .done
	cp $3d
	jr nc, .done
.solved
;>     TriggerRoomEvent()                          # the room's event happens (chime)
	call TriggerRoomEvent
.done
	ret


;@ path: object/liftable_statue
;@ X offsets (pixels, from the statue's position) of the six shards made by ShatterLiftableStatue, one byte per
;@ shard: two columns 8 pixels apart.
StatueShardOffsetX::
	db $00, $08, $00, $08, $00, $08

;@ path: object/liftable_statue
;@ Y offsets of the six shards (signed pixels): rows at -8, 0 and +8.
StatueShardOffsetY::
	db $f8, $f8, $00, $00, $08, $08

;@ path: object/liftable_statue
;@ Starting x speed of each shard (signed, 1/16 pixel per frame): -4, 5, -6, 6, -5, 4 - left column flies left,
;@ right column right.
StatueShardSpeedX::
	db $fc, $05, $fa, $06
	db $fb, $04

;@ path: object/liftable_statue
;@ Starting y speed of each shard (signed, 1/16 pixel per frame): -4, -8, -2, -1, 3, 2.
StatueShardSpeedY::
	db $fc, $f8, $fe, $ff, $03, $02

;@ path: object/liftable_statue
;@ Starting upward speed of each shard (1/16 pixel per frame; gravity takes 2 per frame): $12-$18.
StatueShardSpeedZ::
	db $18, $14, $13, $16, $12, $14

;@ def ShatterLiftableStatue(slot: bc)
;@ path: object/liftable_statue
;@ Breaks the statue: up to six shard entities (type $9D with wEntityPrivate1 = 1) at its position plus the
;@ StatueShard* offsets and speeds, a crash sound, two dust clouds, and the statue is removed.
;@ test: skip spawns entities
ShatterLiftableStatue::
;>@loop for i in range(6):                 # (i kept in hMultiPurposeG)
	ld a, $00
.loop
	ldh [hMultiPurposeG], a
;>     shard, full = SpawnEntity(slot, 0x9D)        # new entity; the statue's x, y, z are left in hMultiPurpose0/1/3
	ld a, $9d
	call SpawnEntity
;>     if full: break                       # no free slot
	jr c, .effects
;>     wEntityPrivate1[shard] += 1          # mark it as a shard
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>     wEntityPhysicsFlags[shard] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c1
;>     offsetX = mem[StatueShardOffsetX + i]
	push bc
	ldh a, [hMultiPurposeG]
	ld c, a
	ld hl, StatueShardOffsetX
	add hl, bc
;>     wEntityX[shard] = u8(hMultiPurpose0 + offsetX)
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     offsetY = mem[StatueShardOffsetY + i]
	ld hl, StatueShardOffsetY
	add hl, bc
;>     wEntityY[shard] = u8(hMultiPurpose1 + offsetY)
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[shard] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[shard] = mem[StatueShardSpeedX + i]
	ld hl, StatueShardSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[shard] = mem[StatueShardSpeedY + i]
	ld hl, StatueShardSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[shard] = mem[StatueShardSpeedZ + i]
	ld hl, StatueShardSpeedZ
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], a
;=@loop
	pop bc
	ldh a, [hMultiPurposeG]
	inc a
	cp $06
	jr nz, .loop

.effects
;> hNoiseSfx = 0x29                         # crash
	ld a, $29
	ldh [hNoiseSfx], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                             # dust cloud effect
	ld a, $02
	call AddTransientVfx
;> hMultiPurpose1 = u8(hActiveEntityDrawY - 0x10)
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                             # a second one 16 pixels higher
	ld a, $02
	call AddTransientVfx
;> return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19

	; (WarpDestinationRooms of the warp handler follows)

;@ path: object/warp
;@ Destination rooms of the dungeon warps, read by WarpTransportLink: 2 bytes per dungeon, indexed by hMapId * 2
;@ (dungeons 0-7). A dungeon has its warp in two rooms (by the entrance and deep inside); stepping in from the
;@ first room leads to the second, from anywhere else to the first.
;@   dungeon 0: $17 / $11    dungeon 1: $36 / $28    dungeon 2: $45 / $52    dungeon 3: $7A / $64
;@   dungeon 4: $93 / $A1    dungeon 5: $C5 / $D4    dungeon 6: $28 / $0E    dungeon 7: $3F / $5D
WarpDestinationRooms::
	db $17, $11, $36, $28, $45, $52, $7a, $64, $93, $a1, $c5, $d4, $28, $0e, $3f, $5d

;@ def WarpHandler(slot: bc)
;@ path: object/warp
;@ Entity $61, the warp swirl. In a dungeon it only works once the dungeon's warp is open (wDungeonFlags
;@ bit 0): it plays its tune when it appears, waits until Link has stepped off it, then sends him to the other
;@ warp room of the dungeon when he steps onto its centre (WarpStates). On the overworld it is only a ring of
;@ sparkles - except in room $CE, where it is a hole that drops Link into room $F8 of indoor map $1F.
;@ test: skip draws sprites and calls routines in other banks
WarpHandler::
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr nz, .indoors
;>     if hMapRoom != 0xCE: return DrawOverworldWarpSparkles(slot)
	ldh a, [hMapRoom]
	cp $ce
	jp nz, DrawOverworldWarpSparkles
;>     ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;>     if wIsLinkInTheAir: return
	ld a, [wIsLinkInTheAir]
	and a
	ret nz
;>     if u8(hLinkX - 0x50 + 3) >= 6: return     # Link within 3 pixels of x $50
	ldh a, [hLinkX]
	sub $50
	add $03
	cp $06
	ret nc
;>     if u8(hLinkY - 0x46 + 4) >= 8: return     # and 4 pixels of y $46
	ldh a, [hLinkY]
	sub $46
	add $04
	cp $08
	ret nc
;>     wWarpType = 1                        # indoors
	ld a, $01
	ld [wWarpType], a
;>     wWarpMap = 0x1F
	ld a, $1f
	ld [wWarpMap], a
;>     wWarpRoom = 0xF8
	ld a, $f8
	ld [wWarpRoom], a
;>     wWarpDestX = 0x50
	ld a, $50
	ld [wWarpDestX], a
;>     hLinkX = 0x50                        # Link snaps to the hole's centre
	ldh [hLinkX], a
;>     wWarpDestY = 0x48
	ld a, $48
	ld [wWarpDestY], a
;>     hLinkY = 0x48
	ldh [hLinkY], a
;>     wWarpDestPosition = 0x45
	ld a, $45
	ld [wWarpDestPosition], a
;>     wLinkMotionState = 6                 # falling into a hole
	ld a, $06
	ld [wLinkMotionState], a
;>     wLinkMotionCounter = ResetSpinAttackAndDash()      # (stops the spin attack; returns 0)
	call ResetSpinAttackAndDash
	ld [wLinkMotionCounter], a
;>     wHoleCollisionType = 0x51
	ld a, $51
	ld [wHoleCollisionType], a
;>     hWaveSfx = 0x0C                      # falling sound
	ld a, $0c
	ldh [hWaveSfx], a
;>     return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19

.indoors
;> wNoEventJingle = 1
	ld a, $01
	ld [wNoEventJingle], a
;> flags = wDungeonFlags[hMapId]
	ldh a, [hMapId]
	ld e, a
	ld d, b
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
;> if not flags & 1: return                 # this dungeon's warp is not open yet
	and $01
	jp z, WarpWaitForLink.return
;> DrawWarp(slot)
	call DrawWarp
;> return WarpStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/warp
;@ State routines of a dungeon warp, indexed by its state: 0 appear, 1 wait until Link has left it, 2 wait for
;@ Link, 3 carry Link away.
WarpStates::
	dw WarpAppear
	dw WarpWaitForLinkToLeave
	dw WarpWaitForLink
	dw WarpTransportLink

;@ def WarpAppear(slot: bc)
;@ path: object/warp
;@ Warp state 0: plays the warp's tune (music $1B) and goes on to the next state.
;@ test: skip calls a bank-0 routine
WarpAppear::
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wMusicTrackToPlay = 0x1B
	ld a, $1b
	ld [wMusicTrackToPlay], a
	ret


;@ def WarpWaitForLinkToLeave(slot: bc)
;@ path: object/warp
;@ Warp state 1: Link arrives standing on the warp; it only becomes active once he is more than 4 pixels away
;@ from its centre.
;@ test: skip calls a bank-0 routine
WarpWaitForLinkToLeave::
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 4) < 8:
	add $04
	cp $08
	jr nc, .left
;>     dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;>     if u8(dy + 4) < 8: return            # still on it
	add $04
	cp $08
	jr c, .done
.left
;> wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def WarpWaitForLink(slot: bc)
;@ path: object/warp
;@ Warp state 2: when Link (on the ground) is within 3 pixels of the centre, the warp takes him: $50 frames of
;@ spinning, with jingle $1C.
;@ test: skip calls a bank-0 routine
WarpWaitForLink::
;> if hLinkPositionZ: return               # jumping over it
	ldh a, [hLinkPositionZ]
	and a
	jr nz, .return
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 3) >= 6: return
	add $03
	cp $06
	jr nc, .return
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 3) >= 6: return
	add $03
	cp $06
	jr nc, .return
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wHookshotOut = 0x20
	ld a, $20
	ld [wHookshotOut], a
;> wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;> hJingle = 0x1C
	ld a, $1c
	ldh [hJingle], a

.return
	ret


;@ path: object/warp
;@ Background palettes (rBGP values) of the fade to white while the warp spins Link, read by WarpTransportLink:
;@ 16 bytes, indexed by wEntityPrivate4 (0-$0C, counting up during the last $40 frames) + frame & 3:
;@ $E4 (normal), $94, $54, $00 (white), four of each.
WarpFadePalettes::
	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $54, $54, $54, $54, $00, $00, $00, $00
;@ path: object/warp
;@ Link's facing direction while he spins in the warp: 4 bytes, one per 8 frames - right, down, left, up.
WarpSpinDirections::
	db $00, $03, $01, $02

;@ def WarpTransportLink(slot: bc)
;@ path: object/warp
;@ Warp state 3: Link is held on the warp's centre and spins while the screen fades to white; when the timer
;@ ends the warp record is filled in (same dungeon, the other warp room, Link at x $50, y $48 - $28 in room $64)
;@ and the warp starts.
;@ test: skip calls routines in other banks
WarpTransportLink::
;> ResetSpinAttackAndDash()                              # stop the spin attack and the dash (a = 0)
	call ResetSpinAttackAndDash
;> wSubtractHealthBuffer = 0
	ld [wSubtractHealthBuffer], a
;> wInvincibilityCounter = 0
	ld [wInvincibilityCounter], a
;> wLinkPushedTimer = 0
	ld [wLinkPushedTimer], a
;> wSwordAnimationState = 0
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> wOcarinaSongState = 0
	ld [wOcarinaSongState], a
;> wLinkShowItemPose = 0
	ld [wLinkShowItemPose], a
;> wLinkFrozen = 1
	inc a
	ld [wLinkFrozen], a
;> hLinkX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;> hLinkY = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hLinkY], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:                               # spinning done: warp
	jr nz, .spin
;>     wWarpType = 1
	ld hl, wWarpType
	ld a, $01
	ld [hli], a
;>     wWarpMap = hMapId
	ldh a, [hMapId]
	ld [hli], a
;>     wWarpDestX = 0x50
	inc hl
	ld a, $50
	ld [hli], a
;>     i = hMapId * 2
	push hl
	ldh a, [hMapId]
	ld e, a
	sla e
	ld d, $00
;>     pair = WarpDestinationRooms + i
	ld hl, WarpDestinationRooms
	add hl, de
;>     wWarpRoom = mem[pair + 1] if hMapRoom == mem[pair] else mem[pair]
	ldh a, [hMapRoom]
	cp [hl]
	jr nz, .room
	inc hl
.room
	ld a, [hl]
	ld [wWarpRoom], a
;>     wWarpDestY = 0x28 if wWarpRoom == 0x64 else 0x48
	pop hl
	cp $64
	ld a, $48
	jr nz, .setY
	ld a, $28
.setY
	ld [hl], a
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     ClearEntityStatus_19(slot)
	call ClearEntityStatus_19
;>     return StartScreenFadeOut()                   # start the warp (wLinkMotionState = 3)
	jp StartScreenFadeOut

.spin
;> hLinkInteractiveMotionBlocked = 1
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $01
;> step = (hFrameCounter >> 3) & 3
	push af
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
;> hLinkDirection = mem[WarpSpinDirections + step]
	ld e, a
	ld d, b
	ld hl, WarpSpinDirections
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()                              # update Link's sprite
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;> fade = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
;> if t < 0x40:                             # the last $40 frames: fade to white
	pop af
	cp $40
	jr nc, .palette
;>     if not t & 3 and fade != 0x0C:      # a step every 4 frames, up to step $0C
	and $03
	jr nz, .palette
	ld a, [hl]
	cp $0c
	jr z, .palette
;>         wEntityPrivate4[slot] += 1
	inc [hl]
.palette
;> i = (hFrameCounter & 3) + wEntityPrivate4[slot]
	ldh a, [hFrameCounter]
	and $03
	add [hl]
	ld e, a
	ld d, b
;> wBGPalette = mem[WarpFadePalettes + i]
	ld hl, WarpFadePalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ret


;@ path: object/warp
;@ The warp swirl in the middle of a dungeon warp, drawn by DrawWarp with DrawEntity16x16: 2 sprite variants of two
;@ 8x16 OAM entries (tile, attributes each), alternating every 8 frames. Both use tile $1E, flipped
;@ differently ($60 / $40 / $20 = x+y flip / y flip / x flip) so the swirl seems to turn.
WarpSprite::
	db $1e, $00, $1e, $60, $1e, $40, $1e, $20

;@ path: object/warp
;@ Y offsets (signed pixels) of the four little sprites circling a dungeon warp: an 8-step circle of radius 8,
;@ read by DrawWarpOrbitSprite at WarpOrbitOffsetY + step (step 0-7). The table runs on into
;@ WarpOrbitOffsetX (the same circle two steps later, i.e. the cosine), so only these two bytes are its own.
WarpOrbitOffsetY::
	db $f8, $fa

;@ path: object/warp
;@ X offsets of the circling sprites (8 steps: 0, 6, 8, 6, 0, -6, -8, -6); its first six bytes are also
;@ steps 2-7 of WarpOrbitOffsetY.
WarpOrbitOffsetX::
	db $00, $06, $08, $06, $00, $fa
	db $f8, $fa

;@ path: object/warp
;@ Sprite of one circling particle: an 8x16 OAM entry (tile $24, attributes 0), twice (the two sprite
;@ variants look the same).
WarpOrbitSprite::
	db $24, $00, $24, $00

;@ def DrawWarp(slot: bc)
;@ path: object/warp
;@ Draws a dungeon warp: the turning swirl (WarpSprite) and four particles circling it.
;@ test: skip draws sprites
DrawWarp::
;> wEntityPhysicsFlags[slot] = 0xC2         # 2 OAM entries for the swirl
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
;> hActiveEntitySpriteVariant = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, WarpSprite)
	ld de, WarpSprite
	call DrawEntity16x16
;> wEntityPhysicsFlags[slot] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
;> for phase in range(0, 8, 2):
	xor a
.loop
	ldh [hMultiPurposeG], a
;>     DrawWarpOrbitSprite(phase)
	ld e, a
	call DrawWarpOrbitSprite
	ldh a, [hMultiPurposeG]
	add $02
	and $07
	jr nz, .loop
;> return
	ret


;@ def DrawWarpOrbitSprite(phase: e)
;@ path: object/warp
;@ Draws one circling particle at step (hFrameCounter / 8 + phase) & 7 of the circle around the warp. The
;@ offsets are added to the active entity position, so the four particles are drawn around the previous one's
;@ place - LoadEntityPosition reloads the entity's position after each.
;@ test: skip draws sprites
DrawWarpOrbitSprite::
;> step = (hFrameCounter >> 3) + phase
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	add e
;> step &= 7
	and $07
	ld e, a
	ld d, b
;> hActiveEntityX = u8(hActiveEntityX + mem[WarpOrbitOffsetX + step])
	ld hl, WarpOrbitOffsetX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + mem[WarpOrbitOffsetY + step])
	ld hl, WarpOrbitOffsetY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> DrawEntity8x16(WarpOrbitSprite)
	ld de, WarpOrbitSprite
	call DrawEntity8x16
;> LoadEntityPosition()                              # back to the entity's own position
	call LoadEntityPosition
	ret


;@ path: object/warp
;@ Y offsets of the sparkles of an overworld warp: a smaller 8-step circle (radius 6), read at
;@ OverworldSparkleOffsetY + step; like WarpOrbitOffsetY it runs on into the x table.
OverworldSparkleOffsetY::
	db $fa, $fc

;@ path: object/warp
;@ X offsets of the overworld sparkles (8 steps: 0, 4, 6, 4, 0, -4, -6, -4).
OverworldSparkleOffsetX::
	db $00, $04, $06, $04, $00, $fc, $fa, $fc

;@ path: object/warp
;@ Sprite of one overworld sparkle: an 8x16 OAM entry (tile $3E, attributes 0).
OverworldSparkleSprite::
	db $3e, $00

;@ def DrawOverworldWarpSparkles(slot: bc)
;@ path: object/warp
;@ An overworld warp: four sparkles circling its centre, flashing between the two sprite palettes every
;@ 4 frames.
;@ test: skip draws sprites
DrawOverworldWarpSparkles::
;> wEntityPhysicsFlags[slot] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
;> hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10   # palette 0 / 1
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> hMultiPurposeE = hActiveEntityX          # the centre
	ldh a, [hActiveEntityX]
	ldh [hMultiPurposeE], a
;> hMultiPurposeF = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurposeF], a
;> for phase in range(0, 8, 2):
	xor a
.loop
	ldh [hMultiPurposeG], a
;>     DrawOverworldWarpSparkle(phase)
	ld e, a
	call DrawOverworldWarpSparkle
	ldh a, [hMultiPurposeG]
	add $02
	and $07
	jr nz, .loop
;> return
	ret


;@ def DrawOverworldWarpSparkle(phase: e)
;@ path: object/warp
;@ Draws one sparkle at step (hFrameCounter / 8 + phase) & 7 of the circle around the centre kept in
;@ hMultiPurposeE / hMultiPurposeF (4 pixels lower).
;@ test: skip draws sprites
DrawOverworldWarpSparkle::
;> step = (hFrameCounter >> 3) + phase
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	add e
;> step &= 7
	and $07
	ld e, a
	ld d, b
;> hActiveEntityX = u8(hMultiPurposeE + mem[OverworldSparkleOffsetX + step])
	ld hl, OverworldSparkleOffsetX
	add hl, de
	ldh a, [hMultiPurposeE]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hMultiPurposeF + mem[OverworldSparkleOffsetY + step] + 4)
	ld hl, OverworldSparkleOffsetY
	add hl, de
	ldh a, [hMultiPurposeF]
	add [hl]
	add $04
	ldh [hActiveEntityDrawY], a
;> DrawEntity8x16(OverworldSparkleSprite)
	ld de, OverworldSparkleSprite
	call DrawEntity8x16
	ret

	; (the boomerang's sprites follow)
;@ path: item/boomerang
;@ Sprites of the spinning boomerang, drawn by BoomerangHandler with DrawEntity16x16: 4 variants of two 8x16 OAM
;@ entries (tile, attributes each; $FF $FF = no sprite), the variant advancing every 4 frames. Palette 1
;@ ($10) throughout: 0 = tile $38 and its mirror ($30), 1 = the diagonal tile $A4 alone (left half),
;@ 2 = tile $38 flipped upside down ($50 / $70), 3 = $A4 mirrored (right half).
BoomerangSprites::
	db $38, $10, $38, $30, $a4, $10, $ff, $ff, $38, $50, $38, $70, $ff, $ff, $a4, $30

;@ def BoomerangHandler(slot: bc)
;@ path: item/boomerang
;@ Entity $01, the boomerang Link throws. It spins, hits enemies as weapon kind 8, cuts grass and bushes on the
;@ overworld, flies out until its timer runs out or it hits a wall, then homes back to Link and vanishes when
;@ he catches it (BoomerangStates).
;@ test: skip draws sprites and calls routines in other banks
BoomerangHandler::
;> wActiveProjectileCount = 1
	ld a, $01
	ld [wActiveProjectileCount], a
;> DrawEntity16x16(slot, BoomerangSprites)
	ld de, BoomerangSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> PlayPeriodicNoiseSfx()                              # whirring sound
	call PlayPeriodicNoiseSfx
;> if not hFrameCounter & 3:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .hit
;>     wEntitySpriteVariant[slot] = (wEntitySpriteVariant[slot] + 1) & 3   # spin
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
.hit
;> wProjectileWeaponType = 8
	ld a, $08
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities(slot)                              # hit enemies it touches (bank 3)
	call EntityHitOtherEntities
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckObjectCollision(slot)                              # wall collision (bank 3)
	call EntityCheckObjectCollision
;> BoomerangCutGrass(slot)
	call BoomerangCutGrass
;> return BoomerangStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: item/boomerang
;@ State routines of the boomerang: 0 flying out, 1 coming back.
BoomerangStates::
	dw BoomerangFlyOut
	dw BoomerangReturn

;@ def BoomerangFlyOut(slot: bc)
;@ path: item/boomerang
;@ The boomerang flies straight on until its timer (set by the thrower) runs out - a wall hit ends the timer at
;@ once, with a spark and jingle 7. Then it turns towards Link.
;@ test: skip calls routines in other banks
BoomerangFlyOut::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .flying
;>     SetEntitySpeedTowardsLink(slot, 8)                         # aim at Link with speed 8 (bank 3)
	ld a, $08
	call SetEntitySpeedTowardsLink
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.flying
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     wEntityTimer[slot] = 0               # turn back next frame
	call GetEntityTimer
	ld [hl], b
;>     SpawnProjectileHitEffect()
	call SpawnProjectileHitEffect
;>     hJingle = 7                          # "clink"
	ld a, $07
	ldh [hJingle], a
.done
	ret


;@ def BoomerangReturn(slot: bc)
;@ path: item/boomerang
;@ The boomerang homes in on Link, re-aiming every 4 frames at speed $20, and disappears when it reaches him.
;@ test: skip calls routines in other banks
BoomerangReturn::
;> if not hFrameCounter & 3:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .catch
;>     SetEntitySpeedTowardsLink(slot, 0x20)                      # aim at Link, speed $20
	ld a, $20
	call SetEntitySpeedTowardsLink
.catch
;> if EntityCheckContactDamage(slot):                          # touching Link (bank 3)
	call EntityCheckContactDamage
	jr nc, .done
;>     ClearEntityStatus_19(slot)           # caught
	call ClearEntityStatus_19
.done
	ret


;@ def BoomerangCutGrass(slot: bc)
;@ path: item/boomerang
;@ On the overworld, when the room object the boomerang touches (hRoomObjectType) is a bush ($5C) or tall grass
;@ ($D3), the object is removed, leaves fly (visual effect 8) and noise $13 plays; the boomerang flies on.
;@ test: skip calls routines in other banks
BoomerangCutGrass::
;> if wIsIndoor: return
	ld a, [wIsIndoor]
	and a
	ret nz
;> if hRoomObjectType != 0xD3 and hRoomObjectType != 0x5C: return
	ldh a, [hRoomObjectType]
	cp $d3
	jr z, .cut
	cp $5c
	ret nz
.cut
;> wEntityCollisions[slot] = 0              # it does not count as a wall
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], b
;> RemoveRoomObject(hMultiPurposeH)         # the object's position in the room
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, b
	call RemoveRoomObject
;> hMultiPurpose0 = u8(hBGPosX + 8)
	ldh a, [hBGPosX]
	add $08
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = u8(hBGPosY + 0x10)
	ldh a, [hBGPosY]
	add $10
	ldh [hMultiPurpose1], a
;> AddTransientVfx(8)                             # leaves effect
	ld a, $08
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret


;@ path: item/sword
;@ Sprites of the sword beam (fired by the sword at full health), drawn by DrawSwordBeam with DrawEntitySprites:
;@ 4 variants of 8 bytes, chosen by the sprite variant the spawner sets; each variant is two OAM entries of
;@ y offset, x offset, tile, attributes ($FF entries are unused):
;@   0: tiles $08 and $06 mirrored ($20) - flying left     1: tiles $06, $08 - flying right
;@   2: tile $04 upside down ($40), x +4 - flying down      3: tile $04, x +4 - flying up
SwordBeamSprites::
	db $00, $00, $08, $20, $00, $08, $06, $20, $00, $00, $06, $00, $00, $08, $08, $00
	db $00, $04, $04, $40, $ff, $ff, $ff, $ff, $00, $04, $04, $00, $ff, $ff, $ff, $ff
;@ path: item/sword
;@ X offset (signed pixels) of a new sword beam from Link's position, by Link's direction: right 0, left 0,
;@ up -4, down +4.
SwordBeamOffsetX::
	db $00, $00, $fc, $04

;@ path: item/sword
;@ Y offset of a new sword beam from Link's position, by Link's direction: right 1, left 1, up 0, down 0.
SwordBeamOffsetY::
	db $01, $01, $00, $00

;@ def SwordBeamHandler(slot: bc)
;@ path: item/sword
;@ Entity $DF, the beam the sword shoots. On its first frame it moves to Link's position (plus the offsets for
;@ his direction), doubles the speed it was given, flashes and plays jingle $3B. Then it flies straight,
;@ hits enemies as weapon kind 1, leaves a trail (visual effect $0D every 4 frames) and bursts at the first
;@ wall.
;@ test: skip draws sprites and calls routines in other banks
SwordBeamHandler::
;> wActiveProjectileCount += 1
	ld hl, wActiveProjectileCount
	inc [hl]
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .flying
;>     d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
;>     offX = mem[SwordBeamOffsetX + d]
	ld hl, SwordBeamOffsetX
	add hl, de
;>     wEntityX[slot] = u8(hLinkX + offX)
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>     offY = mem[SwordBeamOffsetY + d]
	ld hl, SwordBeamOffsetY
	add hl, de
;>     wEntityY[slot] = u8(hLinkY + offY)
	ldh a, [hLinkY]
	add [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = u8(wEntitySpeedX[slot] << 1)
	ld hl, wEntitySpeedX
	add hl, bc
	sla [hl]
;>     wEntitySpeedY[slot] = u8(wEntitySpeedY[slot] << 1)
	ld hl, wEntitySpeedY
	add hl, bc
	sla [hl]
;>     wEntityFlashTimer[slot] = 0xFF       # flashes all its life
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     hJingle = 0x3B
	ld a, $3b
	ldh [hJingle], a
;>     return IncrementEntityState(slot)                   # wEntityState += 1
	jp IncrementEntityState

.flying
;> DrawSwordBeam()
	call DrawSwordBeam
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> wProjectileWeaponType = 1
	ld a, $01
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities(slot)                              # hit enemies (bank 3)
	call EntityHitOtherEntities
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckObjectCollision(slot)                              # wall collision
	call EntityCheckObjectCollision
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .burst
;>@burst     ClearEntityStatus_19(slot)
;>@burst     return SpawnProjectileHitEffect()
;> if (hFrameCounter + 1) & 3: return
	ldh a, [hFrameCounter]
	inc a
	and $03
	jr nz, .done
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> fx = AddTransientVfx(0x0D)                     # trail effect
	ld a, $0d
	call AddTransientVfx
;> mem[0xC520 + fx] = 8                     # the effect's timer
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $08
;> mem[0xC590 + fx] = hActiveEntitySpriteVariant   # same direction as the beam
	ldh a, [hActiveEntitySpriteVariant]
	ld hl, wVfxDirection
	add hl, de
	ld [hl], a
.done
	ret

.burst
;=@burst
	call ClearEntityStatus_19

;@ def SpawnProjectileHitEffect()
;@ path: item/sword
;@ A spark (visual effect 5) where the projectile is drawn, 3 pixels lower: the boomerang or a sword beam
;@ hitting a wall.
;@ test: skip calls a bank-0 routine
SpawnProjectileHitEffect::
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = u8(hActiveEntityDrawY + 3)
	ldh a, [hActiveEntityDrawY]
	add $03
	ldh [hMultiPurpose1], a
;> AddTransientVfx(5)
	ld a, $05
	call AddTransientVfx
	ret


;@ def DrawSwordBeam()
;@ path: item/sword
;@ Draws the sword beam: the two OAM entries of SwordBeamSprites for its sprite variant.
;@ test: skip draws sprites
DrawSwordBeam::
;> i = hActiveEntitySpriteVariant * 8
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld e, a
;> DrawEntitySprites(SwordBeamSprites + i, 2)       # 2 OAM entries
	ld d, b
	ld hl, SwordBeamSprites
	add hl, de
	ld c, $02
	call DrawEntitySprites
	ret


;@ path: npc/goriya
;@ Sprites of the Goriya who trades the boomerang, drawn with DrawEntity16x16: 8 variants of two 8x16 OAM entries
;@ (tile, attributes; $20 = x flip). Variants 0-1 walking down (tiles $60/$62), 2-3 up ($64/$66), 4-5 left
;@ ($68-$6E), 6-7 right (the left frames mirrored) - the order SetWalkingSpriteVariant_19 uses.
GoriyaSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

;@ def GoriyaHandler(slot: bc)
;@ path: npc/goriya
;@ Entity $8F on indoor map $1F: the Goriya in his cave, who swaps his boomerang for the item on Link's B
;@ button (and later swaps it back). He only appears while the trading-sequence item is the magnifying lens
;@ ($0E). He stands at x $50, turns towards Link every 64 frames and blocks him. States (GoriyaStates):
;@ 0 wait to be talked to, 1 answer to "trade?", 2 show the item Link got, 3 answer to "trade back?".
;@ test: skip draws sprites and opens dialogues
GoriyaHandler::
;> wEntityPhysicsFlags[slot] |= 0xC0
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
	set 7, [hl]
;> if wTradeSequenceItem != 0x0E: return ClearEntityStatus_19(slot)
	ld a, [wTradeSequenceItem]
	cp $0e
	jp nz, ClearEntityStatus_19
;> wEntityX[slot] = 0x50
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
;> DrawEntity16x16(slot, GoriyaSprites)
	ld de, GoriyaSprites
	call DrawEntity16x16
;> SetWalkingSpriteVariant_19(slot)
	call SetWalkingSpriteVariant_19
;> if not hFrameCounter & 0x3F:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .solid
;>     wEntityDirection[slot] = GetEntityDirectionToLink_19(slot)
	call GetEntityDirectionToLink_19
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
.solid
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> return GoriyaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/goriya
;@ State routines of the boomerang Goriya: 0 wait for Link, 1 trade answer, 2 show the new item, 3 trade-back
;@ answer.
GoriyaStates::
	dw GoriyaWaitForTalk
	dw GoriyaTradeAnswer
	dw GoriyaShowItem
	dw GoriyaTradeBackAnswer

;@ def GoriyaWaitForTalk(slot: bc)
;@ path: npc/goriya
;@ When Link talks to him (from up to 38 pixels above or below), the Goriya offers his boomerang (dialogue
;@ $21) - or, once he holds Link's item, offers to swap back (dialogue $25, state 3).
;@ test: skip opens dialogues
GoriyaWaitForTalk::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> inRange = u8(hLinkY - hActiveEntityY + 0x26) < 0x4C
	ld e, b
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $26
	cp $4c
;> if not ShouldLinkTalkToEntityInRange_19(slot, inRange): return
	call ShouldLinkTalkToEntityInRange_19
	ret nc
;> if wBoomerangTradedItem == 0 or wBoomerangTradedItem == 0x0D:   # no trade going on
	ld a, [wBoomerangTradedItem]
	cp $00
	jr z, .offer
	cp $0d
	jr nz, .offerBack
.offer
;>     OpenDialogTable2(0x21)               # "trade your item for my boomerang?"
	ld a, $21
	call OpenDialogTable2
;>     wEntityState[slot] += 1
	call IncrementEntityState
	ret
;> else:
.offerBack
;>     OpenDialogTable2(0x25)               # "swap back?"
	ld a, $25
	call OpenDialogTable2
;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
	ret


;@ def GoriyaTradeAnswer(slot: bc)
;@ path: npc/goriya
;@ After the offer: on "yes", the item on Link's B button goes to the Goriya and Link gets the boomerang ($0D)
;@ there, with the item fanfare (music $10) and state 2. Items he will not take - sword, bombs, Power
;@ Bracelet, shield, bow, ocarina, magic powder, or an empty button - give dialogue $27; "no" gives $23.
;@ test: skip opens dialogues
GoriyaTradeAnswer::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> wEntityState[slot] += 1                  # state 2 (show the item)
	call IncrementEntityState
;> if wDialogAnswer != 0 or wItemB == 0:    # said no / nothing to give
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
	ld a, [wItemB]
	and a
	jr z, .no
;>@no     wEntityState[slot] = 0
;>@no     return OpenDialogTable2(0x23)
;> refused = wItemB in (0x01, 0x04, 0x03)  # sword, shield, Power Bracelet
	cp $01
	jr z, .refuse
	cp $04
	jr z, .refuse
	cp $03
	jr z, .refuse
;> refused = refused or wItemB in (0x02, 0x09, 0x0C)   # bombs, ocarina, magic powder
	cp $02
	jr z, .refuse
	cp $09
	jr z, .refuse
	cp $0c
	jr z, .refuse
;> if refused or wItemB == 0x05:           # bow
	cp $05
	jr z, .refuse
;>@refuse     wEntityState[slot] = 0
;>@refuse     return OpenDialogTable2(0x27)  # "I don't want that"
;> wBoomerangTradedItem = wItemB
	ld [wBoomerangTradedItem], a
;> wItemB = 0x0D                            # the boomerang
	ld a, $0d
	ld [wItemB], a
;> wEntityPrivate1[slot] = 0x0D             # the item to show
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wMusicTrackToPlay = 0x10                 # item fanfare
	ld a, $10
	ld [wMusicTrackToPlay], a
	ret

.no
;=@no
	ld [hl], b
	ld a, $23
	call OpenDialogTable2
	ret

.refuse
;=@refuse
	ld [hl], b
	ld a, $27
	call OpenDialogTable2
	ret


;@ def GoriyaTradeBackAnswer(slot: bc)
;@ path: npc/goriya
;@ After the trade-back offer: on "yes" the boomerang's inventory slot gets Link's old item back (the
;@ Goriya keeps nothing; wBoomerangTradedItem becomes $0D), with the fanfare and state 2; "no" gives
;@ dialogue $23 and state 0.
;@ test: skip opens dialogues
GoriyaTradeBackAnswer::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> if wDialogAnswer:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
;>@no     wEntityState[slot] = 0
;>@no     return OpenDialogTable2(0x23)
;> i = 0
	ld hl, wItemB
	ld de, $0000
.find
;> while mem[wItemB + i] != 0x0D:           # find the boomerang among the 12 inventory slots
	ld a, [hl]
	cp $0d
	jr z, .found
;>     i += 1
	inc hl
	inc e
;>     if i == 12: break
	ld a, e
	cp $0c
	jr nz, .find
.found
;> mem[wItemB + i] = wBoomerangTradedItem
	ld a, [wBoomerangTradedItem]
	ld [hl], a
;> wEntityPrivate1[slot] = wBoomerangTradedItem
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wBoomerangTradedItem = 0x0D
	ld a, $0d
	ld [wBoomerangTradedItem], a
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
	ret

.no
;=@no
	ld [hl], b
	ld a, $23
	call OpenDialogTable2
	ret


;@ path: npc/goriya
;@ Sprite of each inventory item as Link holds it up after a trade, indexed by the item number (wEntityPrivate1):
;@ 14 entries of (tile, attributes), all palette 1 ($10): $00 none, $01 sword $84, $02 bombs $80, $03 Power
;@ Bracelet $82, $04 shield $86, $05 bow $88, $06 hookshot $8A, $07 magic rod $8C, $08 Pegasus Boots $98,
;@ $09 ocarina $90, $0A Roc's Feather $92, $0B shovel $96, $0C magic powder $8E, $0D boomerang $A4.
GoriyaItemSprites::
	db $00, $10, $84, $10, $80, $10, $82, $10, $86, $10, $88, $10, $8a, $10, $8c, $10
	db $98, $10, $90, $10, $92, $10, $96, $10, $8e, $10, $a4, $10

;@ def GoriyaShowItem(slot: bc)
;@ path: npc/goriya
;@ Link holds the item he got up over his head (Link pose $6C, frozen) while the timer runs; 8 frames before the
;@ end the matching dialogue opens ($24 for the boomerang, $26 for the item given back). Then back to state 0.
;@ test: skip draws sprites and opens dialogues
GoriyaShowItem::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .show
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
	ret
.show
;> if t == 8:
	cp $08
	jr nz, .draw
;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     item = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;>     OpenDialogTable2(0x24 if item == 0x0D else 0x26)
	cp $0d
	ld a, $24
	jr z, .open
	ld a, $26
.open
	call OpenDialogTable2
.draw
;> hActiveEntityX = hLinkX                  # the item over Link's head
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hLinkY - 0x0C)
	ldh a, [hLinkY]
	sub $0c
	ldh [hActiveEntityDrawY], a
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> hLinkAnimationState = 0x6C               # holding something up
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> hActiveEntitySpriteVariant = wEntityPrivate1[slot]   # the item number
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity8x16(slot, GoriyaItemSprites)
	ld de, GoriyaItemSprites
	call DrawEntity8x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
	ret


;@ path: enemy/masked_mimic
;@ Sprites of the Masked Mimic, drawn with DrawEntity16x16: 8 variants of two 8x16 OAM entries (tile, attributes;
;@ $20 = x flip), variant = direction * 2 + walking frame: 0-1 facing right (tiles $68-$6E mirrored), 2-3 left
;@ ($68-$6E), 4-5 up ($64/$66), 6-7 down ($60/$62).
MaskedMimicSprites::
	db $6a, $20, $68, $20, $6e, $20, $6c, $20, $68, $00, $6a, $00, $6c, $00, $6e, $00
	db $64, $00, $66, $00, $66, $20, $64, $20, $60, $00, $62, $00, $62, $20, $60, $20
;@ path: enemy/masked_mimic
;@ Speeds of the Masked Mimic mirroring Link's direction pad (signed, 1/16 pixel per frame). X speed at
;@ MaskedMimicSpeeds + (pad & 3): none 0, right -12, left +12, both 0. Y speed at MaskedMimicSpeeds + 3 +
;@ ((pad >> 2) & 3): none 0, up +12, down -12 (the last entry, both, is never used).
MaskedMimicSpeeds::
	db $00, $f4, $0c, $00, $0c, $f4

;@ def MaskedMimicHandler(slot: bc)
;@ path: enemy/masked_mimic
;@ Entity $8F: the Masked Mimic (Shy Guy), which copies Link's moves mirrored - it walks the opposite way of
;@ the direction pad and always faces Link. It is protected (option bit 6) except when its back is towards
;@ Link. On indoor map $1F the same type is the boomerang Goriya (GoriyaHandler).
;@ test: skip draws sprites and calls routines in other banks
MaskedMimicHandler::
;> if hMapId == 0x1F: return GoriyaHandler(slot)
	ldh a, [hMapId]
	cp $1f
	jp z, GoriyaHandler
;> DrawEntity16x16(slot, MaskedMimicSprites)
	ld de, MaskedMimicSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> ApplyRecoilIfNeeded_19(slot)
	call ApplyRecoilIfNeeded_19
;> wEntityOptions1[slot] = 0x48             # shielded
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $48
;> toLink = GetEntityDirectionToLink_19(slot)
	call GetEntityDirectionToLink_19
;> if wEntityDirection[slot] ^ 1 == toLink:   # its back is to Link
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	cp e
	jr nz, .collide
;>     wEntityOptions1[slot] = 0x08         # can be hurt
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $08
.collide
;> EntityCheckHits(slot)                              # touch damage / weapon hits (bank 3)
	call EntityCheckHits
;> if wLinkCollisionFlags: return           # Link is blocked by a wall: the mimic stands too
	ld a, [wLinkCollisionFlags]
	and a
	jr nz, .done
;> pad = hJoypadHeld & 0x0F
	ldh a, [hJoypadHeld]
	and $0f
;> if pad == 0: return
	jr z, .done
;> speedX = mem[MaskedMimicSpeeds + (pad & 3)]
	and $03
	ld e, a
	ld d, b
	ld hl, MaskedMimicSpeeds
	add hl, de
	ld a, [hl]
;> wEntitySpeedX[slot] = speedX
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> i = (hJoypadHeld >> 2) & 3
	ldh a, [hJoypadHeld]
	rra
	rra
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedY[slot] = mem[MaskedMimicSpeeds + 3 + i]
	ld hl, MaskedMimicSpeeds + 3
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls(slot)                              # walls
	call EntityCheckWalls
;> wEntityDirection[slot] = hLinkDirection ^ 1   # face Link
	ldh a, [hLinkDirection]
	xor $01
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> base = (wEntityDirection[slot] << 1) & 6
	rla
	and $06
	ld e, a
;> wEntityPrivateCounter[slot] = u8(wEntityPrivateCounter[slot] + 1)
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> frame = (wEntityPrivateCounter[slot] >> 4) & 1
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, base | frame)                  # wEntitySpriteVariant
	or e
	call SetEntitySpriteVariant
.done
	ret

	; (the warp records of entity $97 follow)
;@ path: object/side_view_warp
;@ Warp record used by StartSideViewWarp when Link is left of x $30: 5 bytes copied to wWarpType..wWarpDestY -
;@ kind 2 (side view), map $11, room $C0, Link at x $30, y $14.
SideViewWarpLeft::
	db $02, $11, $c0, $30, $14

;@ path: object/side_view_warp
;@ Warp record for Link at x $30 or more: side view, map $11, room $C1, x $50, y $14.
SideViewWarpRight::
	db $02, $11, $c1, $50, $14

;@ path: object/side_view_warp
;@ Warp record used in room $EA: side view, map $0F, room $F5, x $94, y $52.
SideViewWarpRoomEA::
	db $02, $0f, $f5, $94, $52

;@ def SideViewWarpTriggerHandler(slot: bc)
;@ path: object/side_view_warp
;@ Entity $97: an invisible warp spot. When Link is in motion state 1 with its step under way within 12 pixels
;@ of it, the spot holds him for 16 frames ($10 on its timer) and then warps him into a side-view room
;@ (StartSideViewWarp).
;@ test: skip starts a warp
SideViewWarpTriggerHandler::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr z, .watch
;>     if t == 1:
	cp $01
	jr nz, .hold
;>         wSavedLinkMotionState = wLinkMotionState
	ld a, [wLinkMotionState]
	ld [wSavedLinkMotionState], a
;>         StartSideViewWarp(slot)
	call StartSideViewWarp
.hold
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     wLinkFrozen = 2
	ld [wLinkFrozen], a
;>     wLinkSpriteDY = 4
	ld a, $04
	ld [wLinkSpriteDY], a
;>     return
	ret

.watch
;> if wLinkMotionState != 1 or not hLinkMotionStep: return
	ld a, [wLinkMotionState]
	cp $01
	jr nz, .done
	ldh a, [hLinkMotionStep]
	and a
	jr z, .done
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 0x0C) >= 0x18: return
	add $0c
	cp $18
	jr nc, .done
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 0x0C) >= 0x18: return
	add $0c
	cp $18
	jr nc, .done
;> wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
.done
	ret


;@ def StartSideViewWarp(slot: bc)
;@ path: object/side_view_warp
;@ Copies the matching side-view warp record into wWarpType..wWarpDestY (SideViewWarpRoomEA in room $EA,
;@ otherwise SideViewWarpLeft / SideViewWarpRight by Link's x), removes the trigger, stores Link's tile
;@ position in wWarpDestPosition and starts the fade-out.
;@ test: skip starts a warp
StartSideViewWarp::
;> if hMapRoom == 0xEA: record = SideViewWarpRoomEA
	ld de, SideViewWarpRoomEA
	ldh a, [hMapRoom]
	cp $ea
	jr z, .copy
;> elif hLinkX < 0x30: record = SideViewWarpLeft
	ld de, SideViewWarpLeft
	ldh a, [hLinkX]
	cp $30
	jr c, .copy
;> else: record = SideViewWarpRight
	ld de, SideViewWarpRight
.copy
;> for i in range(5):
	ld hl, wWarpType
	push bc
	ld c, $05
.loop
;>     mem[wWarpType + i] = mem[record + i]
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
;> ClearEntityStatus_19(slot)
	pop bc
	call ClearEntityStatus_19
;> column = hLinkX >> 4
	ldh a, [hLinkX]
	swap a
	and $0f
	ld e, a
;> wWarpDestPosition = (u8(hLinkY - 8) & 0xF0) | column
	ldh a, [hLinkY]
	sub $08
	and $f0
	or e
	ld [wWarpDestPosition], a
;> return StartWarpFadeOutMusic()
	jp StartWarpFadeOutMusic


;@ path: npc/dog
;@ Sprites of the dog, drawn with DrawEntity16x16: 4 variants of two 8x16 OAM entries (tile, attributes): 0 and 1 =
;@ facing left (tiles $58/$5A, $58/$5C - the two leg frames), 2 and 3 = the same mirrored ($20), facing right.
DogSprites::
	db $58, $00, $5a, $00, $58, $00, $5c, $00, $5a, $20, $58, $20, $5c, $20, $58, $20

;@ def DogHandler(slot: bc)
;@ path: npc/dog
;@ Entity $6F, a village dog. It cannot be hurt (its health is refilled every frame), hops about at random and
;@ barks when Link talks to it (dialogue $20). Hit with the sword it gets angry and leaps at Link. While Marin
;@ sings in Animal Village it just faces her and hops in time (and says dialogue $96 of table 1).
;@ States (DogStates): 0 idle, 1 hopping, 2 about to leap, 3 leaping at Link.
;@ test: skip draws sprites and calls routines in other banks
DogHandler::
;> wEntityHealth[slot] = 0x4C
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $4c
;> if wEntityDirection[slot] == 0:          # facing right: the mirrored sprites
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw
;>     hActiveEntitySpriteVariant += 2
	ldh a, [hActiveEntitySpriteVariant]
	add $02
	ldh [hActiveEntitySpriteVariant], a
.draw
;> DrawEntity16x16(slot, DogSprites)
	ld de, DogSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;> wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 2)   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80             # kept in hMultiPurposeG for the states
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if landed:
	jr z, .marin
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.marin
;> if wMarinSinging:
	ld a, [wMarinSinging]
	and a
	jr z, .weapons
;>     wEntityPhysicsFlags[slot] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
;>     marinX = wEntityX[wSingingMarinSlot]
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
;>     marinOnRight = hActiveEntityX < marinX
	ldh a, [hActiveEntityX]
	ld e, $00
	cp [hl]
	jr c, .face
	inc e
.face
;>     wEntityDirection[slot] = 0 if marinOnRight else 1   # face Marin
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>     if not hFrameCounter & 0x3F:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .animate
;>         wEntitySpeedZ[slot] = 0x0C       # a little hop
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c
.animate
;>     AnimateDog()
	call AnimateDog
	jr .angry
;> else:
.weapons
;>     EntityCheckWeaponHits(slot)                          # react to Link's weapons (bank 3)
	call EntityCheckWeaponHits
.angry
;> flash = wEntityFlashTimer[slot]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
;> if flash == 8:                           # just hit
	and a
	jr z, .talk
	cp $08
	jr nz, .talk
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld a, $02
	ld [hl], a
;>     hActiveEntityState = 2
	ldh [hActiveEntityState], a
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
.talk
;> if hActiveEntityState < 2 and ShouldLinkTalkToEntity_19(slot):
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .states
	call ShouldLinkTalkToEntity_19
	jr nc, .states
;>     if wMarinSinging:
	ld a, [wMarinSinging]
	and a
	ld a, $20
	jr z, .bark
;>         OpenDialogTable1(0x96)
	ld a, $96
	call OpenDialogTable1
	jr .states
;>     else:
.bark
;>         OpenDialog(0x20)                 # woof
	call OpenDialog
.states
;> if wMarinSinging: return
	ld a, [wMarinSinging]
	and a
	ret nz
;> return DogStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/dog
;@ State routines of the dog: 0 idle, 1 hopping, 2 about to leap at Link, 3 leaping.
DogStates::
	dw DogIdle
	dw DogHop
	dw DogGetAngry
	dw DogLunge

;@ path: npc/dog
;@ Speeds of the dog's hops (signed, 1/16 pixel per frame), picked at random (index 0-7) for x and,
;@ independently, for y: 2, 8, 12, 8, -2, -8, -12, -8. An x index of 4-7 also turns the dog left.
DogHopSpeeds::
	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

;@ def DogIdle(slot: bc)
;@ path: npc/dog
;@ Dog state 0: stands still until its timer runs out, then picks a random hop direction and a random hopping
;@ time of $30-$4F frames.
;@ test: skip uses the random number generator
DogIdle::
;> SetEntitySpriteVariant(slot, 0)                             # sprite variant 0
	xor a
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate
;>     i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[DogHopSpeeds + i]
	ld hl, DogHopSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntityDirection[slot] = i & 4       # 0 = right, 4 = left
	ld a, e
	and $04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>     j = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
;>     wEntitySpeedY[slot] = mem[DogHopSpeeds + j]
	ld hl, DogHopSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
.animate
;> return AnimateDog()
	jp AnimateDog


;@ def DogHop(slot: bc)
;@ path: npc/dog
;@ Dog state 1: moves with its speed, hopping again (upward speed 8) each time it lands while the timer runs;
;@ at the end it rests $30 frames (state 0).
;@ test: skip calls routines in other banks
DogHop::
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls(slot)                              # walls
	call EntityCheckWalls
;> if not hMultiPurposeG: return AnimateDog()   # still in the air
	ldh a, [hMultiPurposeG]
	and a
	jr z, AnimateDog
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .hopAgain
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret
.hopAgain
;> wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;> wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]
;> return AnimateDog()

;@ def AnimateDog()
;@ path: npc/dog
;@ The dog's two-frame animation: sprite variant (hFrameCounter >> 3) & 1.
;@ test: skip calls a bank-0 routine
AnimateDog::
;> frame = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(frame)                         # sprite variant
	call SetEntitySpriteVariant
	ret


;@ def DogGetAngry(slot: bc)
;@ path: npc/dog
;@ Dog state 2 (after being hit): fast animation for $10 frames, then it leaps at Link - aimed at him with speed
;@ $24, upward speed $18, facing him.
;@ test: skip calls routines in other banks
DogGetAngry::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpeedTowardsLink(slot, 0x24)                      # aim at Link
	ld a, $24
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[slot] = 0x18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;>     _, toLink = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;>     wEntityDirection[slot] = toLink
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	ld [hl], a
.animate
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


;@ def DogLunge(slot: bc)
;@ path: npc/dog
;@ Dog state 3: the leap. While in the air it bites Link if it touches him (the collision check runs with
;@ physics flags $52, then $92 again); on landing it rests for $20 frames (state 0).
;@ test: skip calls routines in other banks
DogLunge::
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> wEntityPhysicsFlags[slot] = 0x52
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $52
;> EntityCheckContactDamage(slot)                              # touching Link: he gets hurt (bank 3)
	call EntityCheckContactDamage
;> wEntityPhysicsFlags[slot] = 0x92
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $92
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, .done
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
.done
	ret


;@ path: event/egg_song
;@ Where the eight instruments appear around the Wind Fish's egg when Link plays the Ballad of the Wind Fish on
;@ top of Mt. Tamaranch: x positions (pixels; 8 is added) for instruments 0-7 (one per dungeon), read by
;@ SpawnEggSongInstrument. Together with InstrumentSpawnY they form a ring.
InstrumentSpawnX::
	db $60, $78, $78, $60, $40, $28, $28, $40

;@ path: event/egg_song
;@ Y positions of the eight instruments around the egg (instrument 0-7).
InstrumentSpawnY::
	db $20, $38, $58, $78, $78, $58, $38, $20

;@ def EggSongEventHandler(slot: bc)
;@ path: event/egg_song
;@ Entity $DE in front of the Wind Fish's egg. When Link plays the Ballad of the Wind Fish there, the
;@ instruments he has won appear one by one around him and play the ballad with him; with all eight the egg
;@ shakes and breaks open (bit 4 of overworld room 6's status). The same type is used for the instruments
;@ (wEntityPrivate1 = 1, EggSongInstrument) and the egg shards (2, EggShard).
;@ States (EggSongEventStates): 0 wait for the ballad, 1 pause, 2 summon instruments, 3 instruments play,
;@ 4 done.
;@ test: skip dispatches through a jump table
EggSongEventHandler::
;> kind = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if kind: return EggSongInstrument(slot, kind)
	and a
	jp nz, EggSongInstrument
;> wSongListenerSlot = slot
	ld a, c
	ld [wSongListenerSlot], a
;> if hRoomStatus & 0x10: return ClearEntityStatus_19(slot)   # the egg is already open
	ldh a, [hRoomStatus]
	and $10
	jp nz, ClearEntityStatus_19
;> return EggSongEventStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: event/egg_song
;@ State routines of the egg event: 0 wait for the ballad, 1 pause, 2 summon instruments, 3 play, 4 done.
EggSongEventStates::
	dw EggSongWaitForBallad
	dw EggSongPause
	dw EggSongSummonInstruments
	dw EggSongPlayInstruments
	dw EggSongDone

;@ def EggSongWaitForBallad(slot: bc)
;@ path: event/egg_song
;@ Waits until Link, who knows the Ballad of the Wind Fish, has just played it (song 0); then the music stops and
;@ after $30 frames the instruments come.
;@ test: skip calls the sound engine
EggSongWaitForBallad::
;> if not wOcarinaSongFlags & 0x04: return  # ballad not learnt
	ld a, [wOcarinaSongFlags]
	and $04
	ret z
;> if wSelectedSong != 0: return
	ld a, [wSelectedSong]
	cp $00
	ret nz
;> if wOcarinaSongState != 1: return        # not just played
	ld a, [wOcarinaSongState]
	cp $01
	ret nz
;> ResetSoundEngine()
	call ResetSoundEngine
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> wOcarinaEndEffect = 0
	xor a
	ld [wOcarinaEndEffect], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def EggSongPause(slot: bc)
;@ path: event/egg_song
;@ State 1: Link stands frozen until the timer runs out.
;@ test: skip calls a bank-0 routine
EggSongPause::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def EggSongSummonInstruments(slot: bc)
;@ path: event/egg_song
;@ State 2: every $20 frames the next instrument (0-7) appears, if Link has it; after the eighth, $40 frames
;@ pass before they play.
;@ test: skip spawns entities
EggSongSummonInstruments::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> i = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> wEntityPrivateCounter[slot] = i + 1
	inc [hl]
;> if i == 8:
	cp $08
	jr nz, .spawn
;>     wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     return IncrementEntityState(slot)                   # next state
	jp IncrementEntityState
.spawn
;> SpawnEggSongInstrument(slot, i)
	call SpawnEggSongInstrument
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
	ret


;@ def EggSongPlayInstruments(slot: bc)
;@ path: event/egg_song
;@ State 3: when the timer runs out the instruments play the ballad: music $41 plus the number of instruments of
;@ dungeons 3-8 Link has in a row (each one adds a part). The listening entity type is set to the same number,
;@ the ocarina song is marked as answered ($FF).
;@ test: skip starts music
EggSongPlayInstruments::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, .done
;> track = 0x41
	ld e, $41
	ld hl, wDungeonFlags + 2
.count
;> for d in range(2, 8):
;>     if not wDungeonFlags[d] & 0x02: break   # instrument missing
	ld a, [hli]
	and $02
	jr z, .play
;>     track += 1
	inc e
	ld a, e
	cp $47
	jr nz, .count
.play
;> wMusicTrackToPlay = track
	ld a, e
	ld [wMusicTrackToPlay], a
;> wSongListenerType = track
	ld [wSongListenerType], a
;> wOcarinaSongState = 0xFF
	ld a, $ff
	ld [wOcarinaSongState], a
;> wSongShowTimer = 0
	xor a
	ld [wSongShowTimer], a
;> mem[0xD211] = 0
	ld [wSongShowTimer + 1], a
;> wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def EggSongDone(slot: bc)
;@ path: event/egg_song
;@ State 4: nothing more to do (the instruments take over).
;@ test: slot = rand(0, 15)
EggSongDone::
;> return
	ret


;@ def SpawnEggSongInstrument(slot: bc, i: a)
;@ path: event/egg_song
;@ Makes instrument `i` (0-7) appear at its place on the ring around the egg, with a sound - if Link won it
;@ (bit 1 of wDungeonFlags[i]). The instrument is an entity $DE with wEntityPrivate1 = 1 and sprite variant i.
;@ test: skip spawns an entity
SpawnEggSongInstrument::
;> flags = wDungeonFlags[i]                 # (i kept in hMultiPurposeG)
	ldh [hMultiPurposeG], a
	ld e, a
	ld d, b
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
;> if not flags & 0x02: return              # Link does not have it
	and $02
	jr z, .done
;> new, full = SpawnEntity(slot, 0xDE)
	ld a, $de
	call SpawnEntity
;> if full: return
	ret c
;> hNoiseSfx = 0x2B
	ld a, $2b
	ldh [hNoiseSfx], a
;> spawnX = mem[InstrumentSpawnX + i]
	push bc
	ldh a, [hMultiPurposeG]
	ld c, a
	ld hl, InstrumentSpawnX
	add hl, bc
	ld a, [hl]
;> wEntityX[new] = spawnX + 8
	ld hl, wEntityX
	add hl, de
	add $08
	ld [hl], a
;> wEntityY[new] = mem[InstrumentSpawnY + i]
	ld hl, InstrumentSpawnY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntitySpriteVariant[new] = i
	ld a, c
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;> wEntityPrivate1[new] += 1                # an instrument
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
	pop bc
.done
	ret


;@ path: event/egg_song
;@ Sprites of the eight instruments, drawn with DrawEntity16x16: 8 variants (one per instrument, dungeon order) of two
;@ 8x16 OAM entries (tile, attributes): tiles $50/$52, $54/$56, ... $6C/$6E.
InstrumentSprites::
	db $50, $00, $52, $00, $54, $00, $56, $00, $58, $00, $5a, $00, $5c, $00, $5e, $00
	db $60, $00, $62, $00, $64, $00, $66, $00, $68, $00, $6a, $00, $6c, $00, $6e, $00

;@ def EggSongInstrument(slot: bc, kind: a)
;@ path: event/egg_song
;@ An instrument around the egg (kind 1; kind 2 is an egg shard). While the ballad plays the instruments flash
;@ in turn. When the song has ended (wOcarinaEndEffect = 3) they vanish - except the eighth (variant 7), which
;@ checks that Link has all eight instruments: then the egg shakes for $A0 frames (state 1) and breaks open:
;@ two egg objects become an opening ($C1 / $CB), the background is redrawn there, jingle $23, eight shards fly.
;@ test: skip draws sprites and changes the background
EggSongInstrument::
;> if kind == 2: return EggShard(slot)
	cp $02
	jp z, EggShard
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .shake
;>     if wOcarinaEndEffect != 3:           # still playing
	ld a, [wOcarinaEndEffect]
	cp $03
	jr z, .songOver
;>         phase = (hFrameCounter >> 3) ^ hActiveEntitySpriteVariant
	ld hl, hActiveEntitySpriteVariant
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	xor [hl]
;>         if not phase & 3: return        # its turn to blink off
	and $03
	ret z
;>         return DrawEntity16x16(slot, InstrumentSprites)
	ld de, InstrumentSprites
	call DrawEntity16x16
	ret
.songOver
;>     if hActiveEntitySpriteVariant != 7: return ClearEntityStatus_19(slot)
	ldh a, [hActiveEntitySpriteVariant]
	cp $07
	jp nz, ClearEntityStatus_19
;>@chk     for d in range(8):
	ld e, $08
	ld hl, wDungeonFlags
.check
;>         if not wDungeonFlags[d] & 0x02:   # an instrument is missing
	ld a, [hli]
	and $02
	jr z, .missing
;>@missing             wOcarinaEndEffect = 0
;>@missing             return ClearEntityStatus_19(slot)
;=@chk
	dec e
	jr nz, .check
;>     if hRoomStatus & 0x10: return ClearEntityStatus_19(slot)
	ldh a, [hRoomStatus]
	and $10
	jp nz, ClearEntityStatus_19
;>     wEntityTimer[slot] = 0xA0            # the egg shakes
	call GetEntityTimer
	ld [hl], $a0
;>     wEntityState[slot] += 1
	call IncrementEntityState
	ret

.missing
;=@missing
	xor a
	ld [wOcarinaEndEffect], a
	jp ClearEntityStatus_19

.shake
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr nz, .shaking
;>@shaking     wScreenShakeX = 0xFF if t & 4 else 1   # shake left / right every 4 frames
;>@shakeEnd     return
;> wScreenShakeX = 0
	ld [wScreenShakeX], a
;> wOcarinaEndEffect = 0
	ld [wOcarinaEndEffect], a
;> wRoomObjects[0x25] = 0xC1                       # the egg opens: two of the room's objects change
	ld a, $c1
	ld [wRoomObjects + $25], a
;> wRoomObjects[0x35] = 0xCB
	ld a, $cb
	ld [wRoomObjects + $35], a
;> hBGPosX = 0x50
	ld a, $50
	ldh [hBGPosX], a
;> hBGPosY = 0x20
	ld a, $20
	ldh [hBGPosY], a
;> GetBGAddress()                           # -> hBGAddrHigh / hBGAddrLow
	call GetBGAddress
;> n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize = n + 7               # (two commands are written; only one counted - the
	add $07
	ld [wDrawCommandsSize], a
;> cmd = wDrawCommand + n                   # second one runs on, ended by the 0 after it)
	ld d, $00
	add hl, de
;> mem[cmd + 0] = hBGAddrHigh               # command 1: 4 tiles down from the address
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x83                      # vertical, 4 tiles
	ld a, $83
	ld [hli], a
;> mem[cmd + 3] = 0x7F; mem[cmd + 4] = 0x0F   # the tiles, top to bottom
	ld a, $7f
	ld [hli], a
	ld a, $0f
	ld [hli], a
;> mem[cmd + 5] = 0x7E; mem[cmd + 6] = 0x1F
	ld a, $7e
	ld [hli], a
	ld a, $1f
	ld [hli], a
;> mem[cmd + 7] = hBGAddrHigh               # command 2: the column to the right
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 8] = u8(hBGAddrLow + 1)
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;> mem[cmd + 9] = 0x83
	ld a, $83
	ld [hli], a
;> mem[cmd + 10] = 0x7F; mem[cmd + 11] = 0x0F
	ld a, $7f
	ld [hli], a
	ld a, $0f
	ld [hli], a
;> mem[cmd + 12] = 0x7E; mem[cmd + 13] = 0x1F
	ld a, $7e
	ld [hli], a
	ld a, $1f
	ld [hli], a
;> mem[cmd + 14] = 0                        # end of the list
	ld [hl], b
;> ResetSoundEngine()
	call ResetSoundEngine
;> hJingle = 0x23
	ld a, $23
	ldh [hJingle], a
;> SpawnEggShards(slot)
	call SpawnEggShards
;> PlayClinkNoise()
	call PlayClinkNoise
;> return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19

.shaking
;=@shaking
	ld e, $01
	and $04
	jr z, .shakeSet
	ld e, $ff
.shakeSet
	ld a, e
	ld [wScreenShakeX], a
;=@shakeEnd
	ret


;@ path: event/egg_song
;@ Sprite of an egg shard: 4 variants of one 8x16 OAM entry, all tile $16 with different flips ($00, $20 x,
;@ $60 x+y, $40 y). The shards keep variant 0.
EggShardSprite::
	db $16, $00, $16, $20, $16, $60, $16, $40

;@ def EggShard(slot: bc)
;@ path: event/egg_song
;@ A shard of the Wind Fish's egg: flies with its speed, falling (y speed + 1 per frame), while Link stays frozen.
;@ When its timer runs out the egg is marked open (overworld room 6, status bit 4) and the shard disappears.
;@ test: skip draws sprites
EggShard::
;> DrawEntity8x16(slot, EggShardSprite)
	ld de, EggShardSprite
	call DrawEntity8x16
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> wEntitySpeedY[slot] = u8(wEntitySpeedY[slot] + 1)
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> wLinkFrozen = wEntityTimer[slot]
	call GetEntityTimer
	ld [wLinkFrozen], a
;> if wEntityTimer[slot]:
	jr z, .landed
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     return
	ret
.landed
;> wRoomStatus[6] |= 0x10                   # the egg is open
	ld hl, wRoomStatus + 6
	set 4, [hl]
;> hRoomStatus = wRoomStatus[6]
	ld a, [hl]
	ldh [hRoomStatus], a
;> return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19


;@ path: event/egg_song
;@ X offsets of the eight egg shards from x $54 (pixels; 0, 4 or 8), read by SpawnEggShards.
EggShardOffsetX::
	db $00, $04, $08, $00, $08, $00, $04, $08

;@ path: event/egg_song
;@ Y offsets of the eight egg shards from y $3C (pixels; 0, 4 or 8).
EggShardOffsetY::
	db $00, $00, $00, $04, $04, $08, $08, $08
;@ path: event/egg_song
;@ Starting x speeds of the eight shards (signed, 1/16 pixel per frame): -16, -4, 16, -16, 16, -16, 4, 16.
EggShardSpeedX::
	db $f0, $fc, $10, $f0, $10, $f0, $04, $10

;@ path: event/egg_song
;@ Starting y speeds of the eight shards before 8 is subtracted (signed): -16, -24, -16, -8, -8, 8, 12, 8 -
;@ so they burst upwards and then fall.
EggShardSpeedY::
	db $f0, $e8, $f0, $f8, $f8, $08, $0c, $08

;@ def SpawnEggShards(slot: bc)
;@ path: event/egg_song
;@ Eight egg shards (entity $DE, wEntityPrivate1 = 2) burst from the egg at (x $54, y $3C) plus the
;@ EggShard* offsets and speeds, each with a random life of $30-$4F frames.
;@ test: skip spawns entities
SpawnEggShards::
;>@loop for i in range(8):
	xor a
.loop
	ldh [hMultiPurposeG], a
;>     new, full = SpawnEntity(slot, 0xDE)
	ld a, $de
	call SpawnEntity
;>     if full: return
	ret c
;>     wEntityPrivate1[new] = 2             # a shard
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityTimer[new] = (GetRandomByte() & 0x1F) + 0x30
	call GetRandomByte
	and $1f
	add $30
	ld hl, wEntityTimer
	add hl, de
	ld [hl], a
;>     offX = mem[EggShardOffsetX + i]
	push bc
	ldh a, [hMultiPurposeG]
	ld c, a
	ld hl, EggShardOffsetX
	add hl, bc
	ld a, [hl]
;>     wEntityX[new] = offX + 0x54
	ld hl, wEntityX
	add hl, de
	add $54
	ld [hl], a
;>     offY = mem[EggShardOffsetY + i]
	ld hl, EggShardOffsetY
	add hl, bc
	ld a, [hl]
;>     wEntityY[new] = offY + 0x3C
	ld hl, wEntityY
	add hl, de
	add $3c
	ld [hl], a
;>     wEntitySpeedX[new] = mem[EggShardSpeedX + i]
	ld hl, EggShardSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     speedY = mem[EggShardSpeedY + i]
	ld hl, EggShardSpeedY
	add hl, bc
	ld a, [hl]
;>     wEntitySpeedY[new] = u8(speedY - 8)
	ld hl, wEntitySpeedY
	add hl, de
	sub $08
	ld [hl], a
;=@loop
	pop bc
	ldh a, [hMultiPurposeG]
	inc a
	cp $08
	jr nz, .loop
	ret

	; (the book's sprites follow)
;@ path: npc/library_book
;@ Sprites of a library book: BookSprites + 0 is the closed book (one 8x16 OAM entry, tile $58) drawn with
;@ DrawEntity8x16; the open book is drawn with DrawEntity16x16 from BookSprites - 2 as variant 1, i.e. the pair at
;@ BookSprites + 2: tile $5A and the same mirrored ($20).
BookSprites::
	db $58, $00, $5a, $00, $5a, $20

;@ def BookHandler(slot: bc)
;@ path: npc/library_book
;@ Entity $DD, a book on a shelf of the library. Link reads it by talking to it; which book it is follows from
;@ where it stands (BookDialogs). After the first page Link may read on: one book opens the map screen, and the
;@ book with the secret, readable only with the magnifying lens, gives one of four hints chosen at random once.
;@ States (BookStates): 0 waiting, 1 being read.
;@ test: skip draws sprites and opens dialogues
BookHandler::
;> if hActiveEntitySpriteVariant:           # open
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, .closed
;>     DrawEntity16x16(slot, BookSprites - 2)
	ld de, BookSprites - 2
	call DrawEntity16x16
	jr .states
;> else:
.closed
;>     DrawEntity8x16(slot, BookSprites)
	ld de, BookSprites
	call DrawEntity8x16
.states
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> return BookStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/library_book
;@ State routines of a library book: 0 waiting for Link, 1 being read.
BookStates::
	dw BookWaitForReader
	dw BookReading

;@ path: npc/library_book
;@ First dialogue (table 2) of each library book, indexed by its place: column group (x < $20: 0, < $40: 1,
;@ < $70: 2, else 3) + 4 for the lower shelves (y >= $40). The second page is the number + 1. Values $02, $04,
;@ $06, $00 (upper shelves), $0A, $08, $0C (its next page is the map book), $0D (the secret book).
BookDialogs::
	db $02, $04, $06, $00, $0a, $08, $0c, $0d

;@ def BookWaitForReader(slot: bc)
;@ path: npc/library_book
;@ Book state 0: closed. When Link reads it, the book opens and shows its first page.
;@ test: skip opens dialogues
BookWaitForReader::
;> if wGameplayType != 7: wMapScreenFromBook = 0   # back from the map screen
	ld a, [wGameplayType]
	cp $07
	jr z, .closed
	xor a
	ld [wMapScreenFromBook], a
.closed
;> SetEntitySpriteVariant(slot, 0)                             # closed
	xor a
	call SetEntitySpriteVariant
;> if not ShouldLinkTalkToEntity_19(slot): return
	call ShouldLinkTalkToEntity_19
	ret nc
;> column = 0
	ld e, $00
;> if hActiveEntityX >= 0x20: column += 1
	ldh a, [hActiveEntityX]
	cp $20
	jr c, .row
	inc e
;> if hActiveEntityX >= 0x40: column += 1
	cp $40
	jr c, .row
	inc e
;> if hActiveEntityX >= 0x70: column += 1
	cp $70
	jr c, .row
	inc e
.row
;> book = column + (4 if hActiveEntityY >= 0x40 else 0)
	ldh a, [hActiveEntityY]
	cp $40
	jr c, .lookup
	ld a, e
	add $04
	ld e, a
.lookup
;> dialog = mem[BookDialogs + book]
	ld d, b
	ld hl, BookDialogs
	add hl, de
	ld a, [hl]
;> wEntityPrivate1[slot] = dialog
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> OpenDialogTable2(dialog)
	call OpenDialogTable2
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def BookReading(slot: bc)
;@ path: npc/library_book
;@ Book state 1: open while the dialogue runs. Afterwards, if Link chose to read on, the next page follows:
;@ page $0D opens the map screen (game mode 7); the secret book's page $0E, with the magnifying lens, becomes
;@ one of the hints $17-$1A, the same one every time once drawn (room status bit 5 marks it).
;@ test: skip opens dialogues and the map screen
BookReading::
;> SetEntitySpriteVariant(slot, 1)                             # open
	ld a, $01
	call SetEntitySpriteVariant
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	ret nz
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>@stop if wDialogAnswer: return SetEntitySpriteVariant(slot, 0)   # stop reading: closed again
	ld a, [wDialogAnswer]
	and a
	jr nz, .stop
;> page = wEntityPrivate1[slot] + 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc a
	ld e, a
;> if page == 0x0E and wTradeSequenceItem == 0x0E:   # the secret book, read with the magnifying lens
	cp $0e
	jr nz, .page
	ld a, [wTradeSequenceItem]
	cp $0e
	jr nz, .page
;>     if not hRoomStatus & 0x20:           # first time: draw the hint
	ldh a, [hRoomStatus]
	and $20
	jr nz, .hint
;>         MarkRoomEventDone_19()
	call MarkRoomEventDone_19
;>         wFaceShrineHint = (GetRandomByte() << 3) & 0x18
	call GetRandomByte
	rla
	rla
	rla
	and $18
	ld [wFaceShrineHint], a
.hint
;>     hint = (wFaceShrineHint >> 3) & 3
	ld a, [wFaceShrineHint]
	rra
	rra
	rra
	and $03
;>     page = 0x17 + hint
	add $17
	ld e, a
.page
;> if page == 0x0D:                         # the map book
	ld a, e
	cp $0d
	jr nz, .open
;>     wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>     wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>     wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>     wGameplayType = 7                    # map screen
	ld a, $07
	ld [wGameplayType], a
;>     wMapScreenFromBook = 1
	ld a, $01
	ld [wMapScreenFromBook], a
;>     return
	ret
.open
;> return OpenDialogTable2(page)
	call OpenDialogTable2
	ret

.stop
;=@stop
	xor a
	jp SetEntitySpriteVariant


;@ def RoosterGraveEvent(slot: bc)
;@ path: event/flying_rooster
;@ Entity $DC in the indoor rooms $E4 / $F4: the Flying Rooster's grave. When Link plays the Frog's Song of Soul
;@ there, a spirit swoops down onto the grave, the grave bursts and the rooster comes back to life and joins
;@ Link (entity $D5 follows him). Once done (room status bit 5) the grave is gone. The same type with
;@ wEntityPrivate1 set is the spirit and its trail (RoosterGraveSpirit).
;@ States (RoosterGraveStates): 0 wait for the song, 1 the spirit flies, 2 burst, 3 the rooster stands up,
;@ 4 it joins Link.
;@ test: skip dispatches through a jump table
RoosterGraveEvent::
;> if hRoomStatus & 0x20: return ClearEntityStatus_19(slot)   # already revived
	ldh a, [hRoomStatus]
	and $20
	jp nz, ClearEntityStatus_19
;> if wEntityPrivate1[slot]: return RoosterGraveSpirit(slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, RoosterGraveSpirit
;> return RoosterGraveStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: event/flying_rooster
;@ State routines of the rooster's grave: 0 wait for the Frog's Song of Soul, 1 the spirit is flying (the grave
;@ just stays), 2 burst, 3 the rooster is revived, 4 it joins Link.
RoosterGraveStates::
	dw RoosterGraveWaitForSong
	dw DrawRoosterGrave
	dw RoosterGraveBurst
	dw RoosterGraveRevived
	dw RoosterGraveJoinLink

;@ path: event/flying_rooster
;@ Sprite of the grave (the rooster's remains): two 8x16 OAM entries, tiles $60 and $62, for DrawEntity16x16.
RoosterGraveSprites::
	db $60, $00, $62, $00

;@ def RoosterGraveWaitForSong(slot: bc)
;@ path: event/flying_rooster
;@ Grave state 0: the grave (at x $50) blocks Link. When he has just played the Frog's Song of Soul (song 2,
;@ learnt = bit 0), the spirit appears above the top of the screen (x $94, y $D8), music $55 plays.
;@ test: skip spawns an entity
RoosterGraveWaitForSong::
;> wEntityScratch1 = slot                  # (a shared slot variable: the spirit finds the grave here)
	ld a, c
	ld [wEntityScratch1], a
;> wEntityX[slot] = 0x50
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
;> DrawRoosterGrave(slot)
	call DrawRoosterGrave
;> if not wOcarinaSongFlags & 0x01: return  # song not learnt
	ld a, [wOcarinaSongFlags]
	and $01
	ret z
;> if wOcarinaSongState != 1: return
	ld a, [wOcarinaSongState]
	cp $01
	ret nz
;> if wSelectedSong != 2: return
	ld a, [wSelectedSong]
	cp $02
	ret nz
;> spirit, _ = SpawnEntity(slot, 0xDC)
	ld a, $dc
	call SpawnEntity
;> wEntityX[spirit] = 0x94
	ld hl, wEntityX
	add hl, de
	ld [hl], $94
;> wEntityY[spirit] = 0xD8                  # above the screen
	ld hl, wEntityY
	add hl, de
	ld [hl], $d8
;> wEntityPrivate1[spirit] += 1
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> wEntityPhysicsFlags[spirit] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c1
;> wMusicTrackToPlay = 0x55
	ld a, $55
	ld [wMusicTrackToPlay], a
;> return IncrementEntityState(slot)                       # next state
	jp IncrementEntityState

	db $c9                                  ; a stray `ret` nothing reaches

;@ def DrawRoosterGrave(slot: bc)
;@ path: event/flying_rooster
;@ Draws the grave and keeps Link out of it (also grave state 1, while the spirit flies).
;@ test: skip draws sprites
DrawRoosterGrave::
;> DrawEntity16x16(slot, RoosterGraveSprites)
	ld de, RoosterGraveSprites
	call DrawEntity16x16
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
	ret


;@ def RoosterGraveBurst(slot: bc)
;@ path: event/flying_rooster
;@ Grave state 2 (set by the spirit when it lands, with $80 frames of flashing): Link is frozen; when the timer
;@ runs out a bomb (entity $02) with a $20-frame fuse is put on the grave and the rooster's revival begins
;@ ($A0 frames).
;@ test: skip spawns an entity
RoosterGraveBurst::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawRoosterGrave(slot)
	call DrawRoosterGrave
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xA0
	ld [hl], $a0
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     bomb, _ = SpawnEntity(slot, 0x02)
	ld a, $02
	call SpawnEntity
;>     wEntityX[bomb] = hMultiPurpose0      # on the grave
	ld hl, wEntityX
	add hl, de
	ldh a, [hMultiPurpose0]
	ld [hl], a
;>     wEntityY[bomb] = hMultiPurpose1
	ld hl, wEntityY
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hl], a
;>     wEntityTimer[bomb] = 0x20            # short fuse
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
.done
	ret


;@ path: event/flying_rooster
;@ The revived rooster standing on the grave, for DrawEntitySprites: three OAM entries (y, x, tile, attributes) -
;@ tile $64 at (-16, 0), $66 at (0, 0), $68 at (0, 8).
RoosterRevivedSprites::
	db $f0, $00, $64, $00, $00, $00, $66, $00, $00, $08, $68, $00

;@ def RoosterGraveRevived(slot: bc)
;@ path: event/flying_rooster
;@ Grave state 3: the rooster stands there; at $70 frames left the item fanfare plays (music $10), at the end
;@ it speaks (RoosterGraveAskToFollow).
;@ test: skip draws sprites
RoosterGraveRevived::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawEntitySprites(RoosterRevivedSprites, 3)
	ld hl, RoosterRevivedSprites
	ld c, $03
	call DrawEntitySprites
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0: return RoosterGraveAskToFollow(slot)
	jp z, RoosterGraveAskToFollow
;> if t == 0x70:
	cp $70
	jr nz, .done
;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
.done
	ret


;@ def RoosterGraveAskToFollow(slot: bc)
;@ path: event/flying_rooster
;@ Opens the rooster's dialogue ($6D of table 1) with the box at the bottom of the screen (Link's y is set to $10
;@ for the box placement and restored), then the next state.
;@ test: skip opens a dialogue
RoosterGraveAskToFollow::
;> savedY = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x10                            # so the box goes to the bottom
	ld a, $10
	ldh [hLinkY], a
;> OpenDialogTable1(0x6D)
	ld a, $6d
	call OpenDialogTable1
;> hLinkY = savedY
	pop af
	ldh [hLinkY], a
;> return IncrementEntityState(slot)                       # wEntityState += 1
	jp IncrementEntityState


;@ def RoosterGraveJoinLink(slot: bc)
;@ path: event/flying_rooster
;@ Grave state 4: once the dialogue is closed the rooster (entity $D5, which then follows Link) takes the
;@ grave's place, wIsRoosterFollowingLink is set and the room is marked done.
;@ test: skip spawns an entity
RoosterGraveJoinLink::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawEntitySprites(RoosterRevivedSprites, 3)
	ld hl, RoosterRevivedSprites
	ld c, $03
	call DrawEntitySprites
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> rooster, _ = SpawnEntity(slot, 0xD5)
	ld a, $d5
	call SpawnEntity
;> wEntityX[rooster] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[rooster] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wIsRoosterFollowingLink = 1
	ld a, $01
	ld [wIsRoosterFollowingLink], a
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> MarkRoomEventDone_19()
	call MarkRoomEventDone_19
;> return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19
.done
	ret


;@ path: event/flying_rooster
;@ Sprites of the rooster's spirit, for DrawEntity8x16: 3 variants of one 8x16 OAM entry - $6A (variant 0, the
;@ spirit itself), $6C and $6E (variants 1 and 2, its trail, chosen by age through RoosterSpiritTrailFrames).
RoosterSpiritSprites::
	db $6a, $00, $6c, $00, $6e, $00

;@ path: event/flying_rooster
;@ Sprite variant of a spirit trail copy by its age, indexed by (timer >> 3) & 3: 2, 2, 1, 1 - a copy shrinks as
;@ its $1F-frame life runs down.
RoosterSpiritTrailFrames::
	db $02, $02, $01, $01

;@ path: event/flying_rooster
;@ The spirit's flight: one direction per 8 frames (104 bytes; steps 0-$48 are used), each a value 0-$0C in
;@ sixteenths of a circle (0 right, 4 down, 8 left, $0C up), turned into speeds by RoosterSpiritSpeedX/Y. It
;@ comes down from above the screen, makes two loops and settles onto the grave.
RoosterSpiritPath::
	db $04, $04, $04, $04, $04, $04
	db $04, $04, $05, $06, $07, $08, $07, $06, $05, $04, $04, $04, $03, $02, $01, $00
	db $01, $02, $03, $04, $05, $06, $07, $08, $08, $08, $09, $0a, $0b, $0c, $0c, $0c
	db $0b, $0a, $09, $08, $07, $06, $05, $04, $05, $06, $07, $08, $09, $0a, $0b, $0b
	db $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01, $00, $01, $02, $03, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04

;@ path: event/flying_rooster
;@ Y speed of the spirit for each direction 0-$0F (signed, 1/16 pixel per frame) - a sine: 0, 3, 6, 7, 8, ...
;@ Only these first four bytes are its own; it runs on into RoosterSpiritSpeedX (which is the same curve
;@ four steps earlier, the cosine).
RoosterSpiritSpeedY::
	db $00, $03, $06, $07

;@ path: event/flying_rooster
;@ X speed of the spirit for each direction 0-$0F: 8, 7, 6, 3, 0, -3, -6, -7, -8, -7, -6, -3, 0, 3, 6, 7.
RoosterSpiritSpeedX::
	db $08, $07, $06, $03, $00, $fd, $fa, $f9, $f8, $f9
	db $fa, $fd, $00, $03, $06, $07

;@ def RoosterGraveSpirit(slot: bc)
;@ path: event/flying_rooster
;@ The rooster's spirit (entity $DC with wEntityPrivate1 = 1), flickering between the two sprite palettes. The
;@ spirit itself (no timer) follows RoosterSpiritPath, leaving a trail copy every 8 frames; at the end of the
;@ path it sets the grave flashing and on to state 2, and vanishes. A trail copy (timer $1F) only shrinks and
;@ disappears.
;@ test: skip draws sprites and spawns entities
RoosterGraveSpirit::
;> hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity8x16(slot, RoosterSpiritSprites)
	ld de, RoosterSpiritSprites
	call DrawEntity8x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:                                    # a trail copy
	jr z, .spirit
;>     if t == 1: return ClearEntityStatus_19(slot)
	cp $01
	jp z, ClearEntityStatus_19
;>     age = (t >> 3) & 3
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
;>     return SetEntitySpriteVariant(slot, mem[RoosterSpiritTrailFrames + age])
	ld hl, RoosterSpiritTrailFrames
	add hl, de
	ld a, [hl]
	jp SetEntitySpriteVariant

.spirit
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> wEntityPrivateCounter[slot] = u8(wEntityPrivateCounter[slot] + 1)
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if not wEntityPrivateCounter[slot] & 7:
	and $07
	jr nz, .fly
;>     wEntityPrivate2[slot] += 1           # next step of the path
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
;>     if wEntityPrivate2[slot] == 0x49:    # landed on the grave
	ld a, [hl]
	cp $49
	jr nz, .fly
;>         grave = wEntityScratch1
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
;>         wEntityState[grave] += 1
	ld hl, wEntityState
	add hl, de
	inc [hl]
;>         wEntityFlashTimer[grave] = 0x40
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $40
;>         wEntityTimer[grave] = 0x80
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $80
;>         return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19

.fly
;> direction = mem[RoosterSpiritPath + wEntityPrivate2[slot]]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, RoosterSpiritPath
	add hl, de
;> speedX = mem[RoosterSpiritSpeedX + direction]
	ld e, [hl]
	ld hl, RoosterSpiritSpeedX
	add hl, de
	ld a, [hl]
;> wEntitySpeedX[slot] = speedX
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[RoosterSpiritSpeedY + direction]
	ld hl, RoosterSpiritSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> if wEntityPrivateCounter[slot] & 7: return
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $07
	jr nz, .done
;> trail, full = SpawnEntity(slot, 0xDC)            # leave a trail copy
	ld a, $dc
	call SpawnEntity
;> if full: return
	ret c
;> wEntityX[trail] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[trail] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPrivate1[trail] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntityTimer[trail] = 0x1F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $1f
.done
	ret


;@ path: event/flying_rooster
;@ Sprites of the Flying Rooster at home, for DrawEntity16x16: 12 variants of two 8x16 OAM entries (tile, attributes;
;@ $20 = x flip). 0-1: tiles $60-$66 standing, facing left (two frames), 2-3: the same facing right; 4-7:
;@ tiles $68-$6E, the body while flying (left / right, two frames); 8-11: tiles $70-$76, the flapping wings
;@ drawn 16 pixels above the flying body (read from RoosterSprites + $20).
RoosterSprites::
	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $20, $60, $20, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
	db $70, $00, $72, $00, $74, $00, $76, $00, $72, $20, $70, $20, $76, $20, $74, $20
;@ path: event/flying_rooster
;@ X offset of the little entity the walking rooster makes in front of its beak, by facing: left -14, right +14.
RoosterPeckOffsetX::
	db $f2, $0e

;@ def RoosterIndoors(slot: bc)
;@ path: event/flying_rooster
;@ Entity $DC in its other indoor rooms: the Flying Rooster at home (music $57 on the first frame). Once
;@ dungeon 7 has been cleared (wDungeon7Flags) it flies around the room (RoosterFlyingIndoors); before that it
;@ walks on the spot, turning now and then, makes an entity $08 in front of its beak every 64 frames, blocks
;@ Link and talks (dialogue $8B of table 1, $8C while the rooster follows Link).
;@ test: skip draws sprites and spawns entities
RoosterIndoors::
;> wEntityPhysicsFlags[slot] = 0xD2
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $d2
;> DrawEntity16x16(slot, RoosterSprites)
	ld de, RoosterSprites
	call DrawEntity16x16
;> if not wEntityPrivate3[slot]:            # first frame
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .flying
;>     wEntityPrivate3[slot] += 1
	inc [hl]
;>     wMusicTrackToPlay = 0x57
	ld a, $57
	ld [wMusicTrackToPlay], a
.flying
;> if wDungeon7Flags: return RoosterFlyingIndoors(slot)
	ld a, [wDungeon7Flags]
	and a
	jp nz, RoosterFlyingIndoors
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> if not hFrameCounter & 0x7F:
	ldh a, [hFrameCounter]
	and $7f
	jr nz, .animate
;>     wEntityDirection[slot] = GetRandomByte() & 2   # 0 left, 2 right
	call GetRandomByte
	and $02
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
.animate
;> frame = 1 if hFrameCounter & 0x30 else 0
	ldh a, [hFrameCounter]
	ld e, $00
	and $30
	jr z, .setSprite
	inc e
.setSprite
;> SetEntitySpriteVariant(slot, wEntityDirection[slot] + frame)
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	add [hl]
	call SetEntitySpriteVariant
;> if (hFrameCounter & 0x3F) == 0x0F:
	ldh a, [hFrameCounter]
	and $3f
	cp $0f
	jr nz, .talk
;>     new, full = SpawnEntity(slot, 0x08)
	ld a, $08
	call SpawnEntity
;>     if full: return
	jr c, .done
;>     offset = mem[RoosterPeckOffsetX + (wEntityDirection[slot] >> 1)]
	push bc
	ld hl, wEntityDirection
	add hl, bc
	ld c, [hl]
	srl c
	ld hl, RoosterPeckOffsetX
;>     wEntityX[new] = u8(hMultiPurpose0 + offset)
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityTimer[new] = 0x17
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
;>     wEntityPrivate4[new] += 1
	ld hl, wEntityPrivate4
	add hl, de
	inc [hl]
	pop bc
.done
;>     return
	ret

.talk
;> if ShouldLinkTalkToEntity_19(slot):
	call ShouldLinkTalkToEntity_19
	jr nc, .return
;>     OpenDialogTable1(0x8C if wIsRoosterFollowingLink else 0x8B)
	ld a, [wIsRoosterFollowingLink]
	and a
	ld a, $8b
	jr z, .open
	ld a, $8c
.open
	call OpenDialogTable1
.return
;> return
	ret


;@ path: event/flying_rooster
;@ Height (pixels; 3 is subtracted) of the rooster flying in its house, by (hFrameCounter >> 3) & 7: a gentle
;@ bob between $0D and $10.
RoosterFlyHeights::
	db $10, $11, $12, $13, $13, $12, $11, $10

;@ path: event/flying_rooster
;@ Y speeds of a new flight direction (signed, 1/16 pixel per frame), index 0-7 chosen at random: 0, 9, 2, 9,
;@ 0, -9, -2, -9 (indexes 0-7 run on into RoosterFlySpeedX: only these are listed here).
RoosterFlySpeedY::
	db $00, $09, $02, $09, $00, $f7, $fe, $f7
;@ path: event/flying_rooster
;@ X speeds of a new flight direction, same index: 12, 9, 10, -9, -12, -9, -10, 9.
RoosterFlySpeedX::
	db $0c, $09, $0a, $f7, $f4, $f7, $f6, $09

;@ path: event/flying_rooster
;@ When the flying rooster moves: it moves on the frames where hFrameCounter & mask == 0, mask indexed by
;@ (hFrameCounter >> 3) & 7: 3, 1, 0, 0, 0, 0, 1, 3 - slow, fast, slow in a 64-frame cycle.
RoosterFlyMoveMasks::
	db $03, $01, $00, $00, $00, $00, $01, $03

;@ def RoosterFlyingIndoors(slot: bc)
;@ path: event/flying_rooster
;@ The rooster flying about its house (after dungeon 7): it bobs at a height of 13-16 pixels, flaps (two
;@ stacked sprite pairs), changes to a random direction now and then, bounces off the walls and speaks
;@ (dialogue $8D of table 1, at most every $80 frames) when Link comes close.
;@ test: skip draws sprites and opens dialogues
RoosterFlyingIndoors::
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .fly
;>     wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, bc
	ld [hl], $50
;>     wEntityState[slot] += 1
	call IncrementEntityState
.fly
;> facing = 0                               # left
	ld e, $00
;> if not wEntitySpeedX[slot] & 0x80: facing = 2   # flying right
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .face
	ld e, $02
.face
;> wEntityDirection[slot] = facing
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> i = (hFrameCounter >> 3) & 7
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
;> bob = mem[RoosterFlyHeights + i]
	ld d, b
	ld hl, RoosterFlyHeights
	add hl, de
	ld a, [hl]
;> wEntityZ[slot] = bob - 3
	sub $03
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> if hFrameCounter & 0x20: wing = 4
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hFrameCounter]
	and $20
	ld a, $04
	jr nz, .lower
;> else: wing = 5
	ld a, $05
.lower
;> SetEntitySpriteVariant(slot, facing + wing)                 # the lower pair (drawn from the next frame on)
	add [hl]
	call SetEntitySpriteVariant
;> hActiveEntityDrawY = u8(hActiveEntityDrawY - 0x10)
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;> frame = (hFrameCounter >> 2) & 1
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
;> hActiveEntitySpriteVariant = facing + frame   # the upper pair
	add [hl]
	ldh [hActiveEntitySpriteVariant], a
;> wEntityPhysicsFlags[slot] &= ~0x10
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 4, [hl]
;> DrawEntity16x16(slot, RoosterSprites + 0x20)         # variants 8-11: the wings, tiles $70-$76
	ld de, RoosterSprites + $20
	call DrawEntity16x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if not hFrameCounter & 0x3F and not GetRandomByte() & 1:   # now and then
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .move
	call GetRandomByte
	and $01
	jr nz, .move
;>     i = GetRandomByte() & 7              # a new direction
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[RoosterFlySpeedX + i]
	ld hl, RoosterFlySpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[RoosterFlySpeedY + i]
	ld hl, RoosterFlySpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
.move
;> i = hFrameCounter >> 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	nop
;> mask = mem[RoosterFlyMoveMasks + (i & 7)]
	and $07
	ld e, a
	ld d, b
	ld hl, RoosterFlyMoveMasks
	add hl, de
;> if hFrameCounter & mask == 0: UpdateEntityPosWithSpeed_19(slot)
	ldh a, [hFrameCounter]
	and [hl]
	call z, UpdateEntityPosWithSpeed_19
;> EntityCheckWalls(slot)                              # walls
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 0x03:       # hit a side wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .vertical
;>     wEntitySpeedX[slot] = u8(-wEntitySpeedX[slot])
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.vertical
;> if wEntityCollisions[slot] & 0x0C:       # hit the top or bottom wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, .near
;>     wEntitySpeedY[slot] = u8(-wEntitySpeedY[slot])
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.near
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 0x12) >= 0x24: return
	add $12
	cp $24
	ret nc
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 0x10) >= 0x20: return
	add $10
	cp $20
	ret nc
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> wEntityTimer[slot] = 0x80
	ld [hl], $80
;> OpenDialogTable1(0x8D)
	ld a, $8d
	call OpenDialogTable1
	ret


;@ path: event/flying_rooster
;@ Sprite of the weathervane in Mabe Village (the rooster statue on its pedestal) while it slides, for
;@ DrawEntitySprites: four OAM entries (y, x, tile, attributes) - tiles $78 / $7A on top (y -16), $7C / $7E below.
WeathervaneSprites::
	db $f0, $00, $78, $00, $f0, $08, $7a, $00, $00, $00, $7c, $00, $00, $08, $7e, $00

;@ def FlyingRoosterEventsHandler(slot: bc)
;@ path: event/flying_rooster
;@ Entity $DC, the events of the Flying Rooster. Indoors in rooms $E4 and $F4 it is the rooster's grave
;@ (RoosterGraveEvent), in other indoor rooms the rooster at home (RoosterIndoors). On the overworld it is the
;@ weathervane, which Link can push aside with the level-2 Power Bracelet to open the stairs to the grave
;@ (WeathervaneStates: 0 wait for the push, 1 slide); afterwards (room status bit 5) it is gone.
;@ test: skip dispatches through a jump table
FlyingRoosterEventsHandler::
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .outdoors
;>     if hMapRoom == 0xE4 or hMapRoom == 0xF4: return RoosterGraveEvent(slot)
	ldh a, [hMapRoom]
	cp $e4
	jp z, RoosterGraveEvent
	cp $f4
	jp z, RoosterGraveEvent
;>     return RoosterIndoors(slot)
	jp RoosterIndoors
.outdoors
;> if hRoomStatus & 0x20: return ClearEntityStatus_19(slot)   # already pushed aside
	ldh a, [hRoomStatus]
	and $20
	jp nz, ClearEntityStatus_19
;> return WeathervaneStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: event/flying_rooster
;@ State routines of the weathervane: 0 wait for Link to push it, 1 slide away.
WeathervaneStates::
	dw WeathervaneWaitForPush
	dw WeathervaneSlide

;@ def WeathervaneWaitForPush(slot: bc)
;@ path: event/flying_rooster
;@ Weathervane state 0: with the level-2 Power Bracelet, Link pushing it upwards from right below (within 8
;@ pixels sideways, 16 up or down) for $18 frames moves it: the room objects under it change ($0C, $C6), the
;@ background there is redrawn (two columns of four tiles at x $50, y $30), noise $11, and it slides ($40
;@ frames).
;@ test: skip changes the background
WeathervaneWaitForPush::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if wPowerBraceletLevel < 2: return
	ld a, [wPowerBraceletLevel]
	cp $02
	ret c
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> pushing = u8(dx + 8) < 0x10
	add $08
	cp $10
	jr nc, .reset
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> pushing = pushing and u8(dy + 0x10) < 0x20
	add $10
	cp $20
	jr nc, .reset
;> pushing = pushing and wLinkCollisionFlags and hLinkDirection == 2   # walking into it, facing up
	ld a, [wLinkCollisionFlags]
	and a
	jr z, .reset
	ldh a, [hLinkDirection]
	cp $02
	jr nz, .reset
;> if not pushing:
;>@reset     wEntityPrivateCounter[slot] = 0   # start counting again
;>@reset     return
;> wEntityPrivateCounter[slot] = u8(wEntityPrivateCounter[slot] + 1)
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] != 0x18: return
	cp $18
	ret nz
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wRoomObjects[0x35] = 0x0C                       # the room objects under the weathervane
	ld hl, wRoomObjects + $35
	ld [hl], $0c
;> wRoomObjects[0x45] = 0xC6
	ld hl, wRoomObjects + $45
	ld [hl], $c6
;> hBGPosX = 0x50
	ld a, $50
	ldh [hBGPosX], a
;> hBGPosY = 0x30
	ld a, $30
	ldh [hBGPosY], a
;> GetBGAddress()
	call GetBGAddress
;> n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize = n + 0x0E             # two 7-byte commands
	add $0e
	ld [wDrawCommandsSize], a
;> cmd = wDrawCommand + n
	ld d, $00
	add hl, de
;> mem[cmd + 0] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x83                      # 4 tiles downwards
	ld a, $83
	ld [hli], a
;> mem[cmd + 3] = 0x0F; mem[cmd + 4] = 0x0F
	ld a, $0f
	ld [hli], a
	ld a, $0f
	ld [hli], a
;> mem[cmd + 5] = 0x68; mem[cmd + 6] = 0x77
	ld a, $68
	ld [hli], a
	ld a, $77
	ld [hli], a
;> mem[cmd + 7] = hBGAddrHigh               # the right-hand column
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 8] = u8(hBGAddrLow + 1)
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;> mem[cmd + 9] = 0x83
	ld a, $83
	ld [hli], a
;> mem[cmd + 10] = 0x0F; mem[cmd + 11] = 0x0F
	ld a, $0f
	ld [hli], a
	ld a, $0f
	ld [hli], a
;> mem[cmd + 12] = 0x69; mem[cmd + 13] = 0x4B
	ld a, $69
	ld [hli], a
	ld a, $4b
	ld [hli], a
;> mem[cmd + 14] = 0                        # end of the list
	ld [hl], b
;> hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> return WeathervaneSlide(slot)
	jr WeathervaneSlide

.reset
;=@reset
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	ret


;@ def WeathervaneSlide(slot: bc)
;@ path: event/flying_rooster
;@ Weathervane state 1: it slides up (y speed -4) for $40 frames while Link is frozen; then the stairs are
;@ uncovered - room objects $91 / $5E, the background redrawn at x $50, y $20 - jingle $23 plays and the event is
;@ marked done.
;@ test: skip changes the background
WeathervaneSlide::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawEntitySprites(WeathervaneSprites, 4)
	ld hl, WeathervaneSprites
	ld c, $04
	call DrawEntitySprites
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr nz, .slide
;>@slide     wEntitySpeedY[slot] = 0xFC
;>@slide     return UpdateEntityYPosWithSpeed_19(slot)
;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> wRoomObjects[0x25] = 0x91                       # the uncovered stairs
	ld hl, wRoomObjects + $25
	ld [hl], $91
;> wRoomObjects[0x35] = 0x5E
	ld hl, wRoomObjects + $35
	ld [hl], $5e
;> hBGPosX = 0x50
	ld a, $50
	ldh [hBGPosX], a
;> hBGPosY = 0x20
	ld a, $20
	ldh [hBGPosY], a
;> GetBGAddress()
	call GetBGAddress
;> n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize = n + 0x0E
	add $0e
	ld [wDrawCommandsSize], a
;> cmd = wDrawCommand + n
	ld d, $00
	add hl, de
;> mem[cmd + 0] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x83
	ld a, $83
	ld [hli], a
;> mem[cmd + 3] = 0x00; mem[cmd + 4] = 0x10
	ld a, $00
	ld [hli], a
	ld a, $10
	ld [hli], a
;> mem[cmd + 5] = 0x02; mem[cmd + 6] = 0x12
	ld a, $02
	ld [hli], a
	ld a, $12
	ld [hli], a
;> mem[cmd + 7] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 8] = u8(hBGAddrLow + 1)
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;> mem[cmd + 9] = 0x83
	ld a, $83
	ld [hli], a
;> mem[cmd + 10] = 0x6C; mem[cmd + 11] = 0x6D
	ld a, $6c
	ld [hli], a
	ld a, $6d
	ld [hli], a
;> mem[cmd + 12] = 0x03; mem[cmd + 13] = 0x13
	ld a, $03
	ld [hli], a
	ld a, $13
	ld [hli], a
;> mem[cmd + 14] = 0
	ld [hl], b
;> hJingle = 0x23
	ld a, $23
	ldh [hJingle], a
;> MarkRoomEventDone_19()
	call MarkRoomEventDone_19
;> return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19

.slide
;=@slide
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fc
	call UpdateEntityYPosWithSpeed_19
	ret

	; (the giant bubble's sprites follow)
;@ path: enemy/giant_bubble
;@ Sprites of the Giant Bubble, drawn by GiantBubbleHandler with DrawEntitySprites: eight OAM entries
;@ (y offset, x offset, tile, attributes) making a 32x32 ball - the top row tiles $60 $62 $62 $60 (the right
;@ half mirrored, $20), the bottom row the same upside down ($40 / $60). hActiveEntityTileOffset (0, 4 or 8)
;@ is added to the tiles to animate it.
GiantBubbleSprites::
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
;@ path: enemy/giant_bubble
;@ Tile offset of the Giant Bubble's animation, indexed by (hFrameCounter >> 4) & 3: 0, 4, 8, 4 (tiles $60/$62,
;@ $64/$66, $68/$6A).
GiantBubbleTileOffsets::
	db $00, $04, $08, $04

;@ def GiantBubbleHandler(slot: bc)
;@ path: enemy/giant_bubble
;@ Entity $DB, the Giant Bubble of the side-view passages: a big wobbling ball flickering between the two
;@ palettes that drifts with its speed, bounces off every wall and hurts Link on contact.
;@ test: skip draws sprites and calls routines in other banks
GiantBubbleHandler::
;> hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10   # palette flicker
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> i = (hFrameCounter >> 4) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $03
;> hActiveEntityTileOffset = mem[GiantBubbleTileOffsets + i]
	ld e, a
	ld d, b
	ld hl, GiantBubbleTileOffsets
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityTileOffset], a
;> DrawEntitySprites(GiantBubbleSprites, 8)
	ld hl, GiantBubbleSprites
	ld c, $08
	call DrawEntitySprites
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 0x03:       # a side wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .vertical
;>     wEntitySpeedX[slot] = u8(-wEntitySpeedX[slot])
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.vertical
;> if wEntityCollisions[slot] & 0x0C:       # floor or ceiling
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, .done
;>     wEntitySpeedY[slot] = u8(-wEntitySpeedY[slot])
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.done
;> return
	ret


;@ path: enemy/podoboo
;@ Sprites of the Podoboo (lava fireball), for DrawEntity16x16: 4 variants of two 8x16 OAM entries, all tile $7A
;@ (right half mirrored): 0-1 upside down ($40 / $60) for the way up, 2-3 upright for the way down; the odd
;@ variants use palette 1 ($10), so the ball flickers.
PodobooSprites::
	db $7a, $40, $7a, $60, $7a, $50, $7a, $70, $7a, $00, $7a, $20, $7a, $10, $7a, $30

;@ def PodobooHandler(slot: bc)
;@ path: enemy/podoboo
;@ Entity $DA, the Podoboo: a fireball that leaps out of the lava, falls back and splashes, again and again.
;@ No more than two are in the air at a time. The same type is used for its flame trail (wEntityPrivate1 = 1)
;@ and the lava splash drops (2), both in PodobooFlame. States (PodobooStates): 0 pick a waiting time, 1 wait,
;@ 2 in the air.
;@ test: skip dispatches through a jump table
PodobooHandler::
;> kind = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if kind: return PodobooFlame(slot, kind)
	and a
	jp nz, PodobooFlame
;> return PodobooStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/podoboo
;@ State routines of the Podoboo: 0 pick a waiting time, 1 wait in the lava, 2 leap.
PodobooStates::
	dw PodobooWait
	dw PodobooLeap
	dw PodobooFly

;@ def PodobooWait(slot: bc)
;@ path: enemy/podoboo
;@ Podoboo state 0: waits a random $30-$6F frames in the lava.
;@ test: skip uses the random number generator
PodobooWait::
;> wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ path: enemy/podoboo
;@ X offsets (signed pixels) of the two lava drops of a splash, from the Podoboo's position: drop 0 -1, drop 1 +1.
PodobooSplashOffsetX::
	db $ff, $01

;@ path: enemy/podoboo
;@ X speeds of the two lava drops (signed, 1/16 pixel per frame): -3 and +3.
PodobooSplashSpeedX::
	db $fd, $03

;@ path: enemy/podoboo
;@ Y speeds of the two lava drops: -12 each (they jump up, then fall).
PodobooSplashSpeedY::
	db $f4, $f4

;@ def PodobooLeap(slot: bc)
;@ path: enemy/podoboo
;@ Podoboo state 1: when the wait is over and fewer than two Podoboos were in the air last frame, it leaps
;@ (y speed -$30) with a splash.
;@ test: skip spawns entities
PodobooLeap::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, SpawnPodobooSplash.return
;> if wPodobooCountPrev >= 2: return
	ld a, [wPodobooCountPrev]
	cp $02
	ret nc
;> wEntitySpeedY[slot] = 0xD0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $d0
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return SpawnPodobooSplash(slot)

;@ def SpawnPodobooSplash(slot: bc)
;@ path: enemy/podoboo
;@ Two lava drops (entity $DA, wEntityPrivate1 = 2) jump out of the lava where the Podoboo is, one to each side
;@ (PodobooSplash* tables).
;@ test: skip spawns entities
SpawnPodobooSplash::
;>@loop for i in (1, 0):                  # (i kept in hMultiPurposeH)
	ld a, $01
.loop
	ldh [hMultiPurposeH], a
;>     drop, full = SpawnEntity(slot, 0xDA)       # the Podoboo's x / y are left in hMultiPurpose0 / 1
	ld a, $da
	call SpawnEntity
;>     if full: return
	ret c
;>     wEntityY[drop] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[drop] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     offset = mem[PodobooSplashOffsetX + i]
	push bc
	ldh a, [hMultiPurposeH]
	ld c, a
	ld hl, PodobooSplashOffsetX
	add hl, bc
;>     wEntityX[drop] = u8(hMultiPurpose0 + offset)
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[drop] = mem[PodobooSplashSpeedX + i]
	ld hl, PodobooSplashSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[drop] = mem[PodobooSplashSpeedY + i]
	ld hl, PodobooSplashSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;=@loop
	pop bc
	ldh a, [hMultiPurposeH]
	dec a
	cp $ff
	jr nz, .loop
;> return
	ret

.return
	ret


;@ def PodobooFly(slot: bc)
;@ path: enemy/podoboo
;@ Podoboo state 2: flies up and falls back (gravity 1 per frame), hurting Link on contact, upside down on the
;@ way up. Back at y $70 it splashes and waits again. Every 16 frames it leaves a flame (entity $DA,
;@ wEntityPrivate1 = 1, $18 frames).
;@ test: skip draws sprites and spawns entities
PodobooFly::
;> wPodobooCount += 1
	ld hl, wPodobooCount
	inc [hl]
;> DrawEntity16x16(slot, PodobooSprites)
	ld de, PodobooSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> wEntitySpeedY[slot] = u8(wEntitySpeedY[slot] + 1)   # gravity
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> base = 0 if wEntitySpeedY[slot] & 0x80 else 2      # rising: upside down
	ld e, $00
	ld a, [hl]
	and $80
	jr nz, .sprite
	ld e, $02
.sprite
;> SetEntitySpriteVariant(slot, base + ((hFrameCounter >> 2) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant
;> if wEntityY[slot] >= 0x70:               # back in the lava
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, .trail
;>     wEntityY[slot] = 0x70
	ld [hl], $70
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     SpawnPodobooSplash(slot)
	call SpawnPodobooSplash
.trail
;> if (hFrameCounter ^ slot) & 0x0F: return # every 16 frames
	ldh a, [hFrameCounter]
	xor c
	and $0f
	ret nz
;> flame, full = SpawnEntity(slot, 0xDA)
	ld a, $da
	call SpawnEntity
;> if full: return
	ret c
;> wEntityX[flame] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[flame] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityTimer[flame] = 0x18
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $18
;> wEntityPrivate1[flame] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntitySpriteVariant[flame] = (hActiveEntitySpriteVariant << 1) & 4   # 0 rising, 4 falling
	ldh a, [hActiveEntitySpriteVariant]
	rla
	and $04
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;> return
	ret


;@ path: enemy/podoboo
;@ Sprites of the Podoboo's flame trail and lava drops, for DrawEntity16x16: 8 variants of two 8x16 OAM entries (right
;@ half mirrored). 0-3 upside down: tile $7C (big flame), $7C palette 1, $7E (small), $7E palette 1; 4-7 the same
;@ upright. A trail flame starts at 0 (rising) or 4 (falling), alternates palettes and turns small for its last
;@ 8 frames. The lava drops use PodobooFlameSprites + $18, i.e. variants 6-7 (small, upright).
PodobooFlameSprites::
	db $7c, $40, $7c, $60, $7c, $50, $7c, $70, $7e, $40, $7e, $60, $7e, $50, $7e, $70
	db $7c, $00, $7c, $20, $7c, $10, $7c, $30, $7e, $00, $7e, $20, $7e, $10, $7e, $30

;@ def PodobooFlame(slot: bc, kind: a)
;@ path: enemy/podoboo
;@ A Podoboo's flame trail (kind 1): drawn every other frame, flickering, shrinking for its last 8 frames and
;@ gone when its timer ends. A lava drop (kind 2): flies with its speed and falls (gravity 1 per frame), gone
;@ once its y speed has reached $10.
;@ test: skip draws sprites
PodobooFlame::
;> if kind == 2:                            # a lava drop
	cp $02
	jr z, .drop
;>@drop     DrawEntity16x16(slot, PodobooFlameSprites + 0x18)
;>@drop2     SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
;>@drop3     UpdateEntityPosWithSpeed_19(slot)
;>@drop4     wEntitySpeedY[slot] = u8(wEntitySpeedY[slot] + 1)
;>@drop5     if wEntitySpeedY[slot] == 0x10: ClearEntityStatus_19(slot)
;>@drop6     return
;> if not (hFrameCounter ^ slot) & 1:       # every other frame
	ldh a, [hFrameCounter]
	xor c
	rra
	jr c, .timer
;>     flicker = (hFrameCounter >> 2) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	ld e, a
;>     hActiveEntitySpriteVariant += flicker   # the palette-1 variant every 4 frames
	ldh a, [hActiveEntitySpriteVariant]
	add e
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(slot, PodobooFlameSprites)
	ld de, PodobooFlameSprites
	call DrawEntity16x16
.timer
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0: return ClearEntityStatus_19(slot)
	jp z, ClearEntityStatus_19
;> if t == 8:
	cp $08
	jr nz, .done
;>     wEntitySpriteVariant[slot] += 2      # the small flame
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]
	inc [hl]
.done
	ret

.drop
;=@drop
	ld de, PodobooFlameSprites + $18
	call DrawEntity16x16
;=@drop2
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;=@drop3
	call UpdateEntityPosWithSpeed_19
;=@drop4
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;=@drop5
	ld a, [hl]
	cp $10
	jr nz, .dropDone
	call ClearEntityStatus_19
.dropDone
;=@drop6
	ret

	; (the falling block's sprites follow)
;@ path: enemy/thwomp
;@ Sprites of the rammable falling block, drawn by RammableBlockHandler with DrawEntitySprites: eight OAM entries
;@ (y offset, x offset, tile, attributes) making a 32x32 block - top row tiles $50 $52 $52 $50, bottom row $54
;@ $56 $56 $54 (the right halves mirrored, $20). With sprite variant 1 hActiveEntityTileOffset is 8, giving
;@ tiles $58-$5E (the cracked look after Link rammed it).
RammableBlockSprites::
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20
	db $10, $00, $54, $00, $10, $08, $56, $00, $10, $10, $56, $20, $10, $18, $54, $20

;@ def RammableBlockHandler(slot: bc)
;@ path: enemy/thwomp
;@ Entity $D9 (side view): a big stone block hanging in the air. When Link dashes into it with the Pegasus Boots
;@ he bounces back, the block cracks and drops to the floor with a crash that shakes the screen; afterwards it
;@ is a platform Link can stand on. States (RammableBlockStates): 0 wait to be rammed, 1 fall, 2 landed.
;@ test: skip draws sprites and calls routines in other banks
RammableBlockHandler::
;> hActiveEntityTileOffset = 8 if hActiveEntitySpriteVariant else 0
	ldh a, [hActiveEntitySpriteVariant]
	and a
	ld a, $00
	jr z, .offset
	ld a, $08
.offset
	ldh [hActiveEntityTileOffset], a
;> DrawEntitySprites(RammableBlockSprites, 8)
	ld hl, RammableBlockSprites
	ld c, $08
	call DrawEntitySprites
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> return RammableBlockStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/thwomp
;@ State routines of the rammable block: 0 wait to be rammed, 1 fall, 2 landed (a platform).
RammableBlockStates::
	dw RammableBlockWaitForRam
	dw RammableBlockFall
	dw RammableBlockLanded

;@ def RammableBlockWaitForRam(slot: bc)
;@ path: enemy/thwomp
;@ Block state 0: solid. If Link runs into it while dashing, the dash ends and he bounces back (a quarter of his
;@ speed reversed, upward speed -24); the block cracks (variant 1), jingle $0B, and falls after $20 frames.
;@ test: skip calls routines in other banks
RammableBlockWaitForRam::
;> touched, dashing = PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> if not touched or not dashing: return
	ret nc
	and a
	ret z
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> hLinkSpeedX = u8(-s8(hLinkSpeedX) >> 2)  # bounce back at a quarter of the speed (s8 = signed value)
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = 0xE8
	ld a, $e8
	ldh [hLinkSpeedY], a
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> SetEntitySpriteVariant(slot, 1)                # cracked
	ld a, $01
	call SetEntitySpriteVariant
;> hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def RammableBlockFall(slot: bc)
;@ path: enemy/thwomp
;@ Block state 1: after the timer (jingle 8 on its last frame) the block falls, speeding up by 3 per frame up to
;@ $70; the floor is checked 16 pixels lower (its bottom). On landing: clink, $30 frames of screen shake, state 2.
;@ test: skip calls routines in other banks
RammableBlockFall::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 1: hJingle = 8
	cp $01
	jr nz, .wait
	ld hl, hJingle
	ld [hl], $08
.wait
;> if t: return
	and a
	ret nz
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> v = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> if v < 0x70: wEntitySpeedY[slot] = v + 3   # gravity
	cp $70
	jr nc, .fast
	add $03
	ld [hl], a
.fast
;> wEntityY[slot] += 0x10                   # check the floor at the block's bottom
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
;> hActiveEntityY += 0x10
	ldh a, [hActiveEntityY]
	add $10
	ldh [hActiveEntityY], a
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> wEntityY[slot] -= 0x10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
;> hActiveEntityY -= 0x10
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hActiveEntityY], a
;> if wEntityCollisions[slot]:              # landed
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     PlayClinkNoise()
	call PlayClinkNoise
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     wBumpShakeTimer = 0x30
	ld a, $30
	ld [wBumpShakeTimer], a
;>     wBumpShakeAxis = 4
	ld a, $04
	ld [wBumpShakeAxis], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
.done
	ret


;@ def RammableBlockLanded(slot: bc)
;@ path: enemy/thwomp
;@ Block state 2: lies on the floor as a platform.
;@ test: skip calls routines in other banks
RammableBlockLanded::
;> SideViewBlockLinkCollision(slot)
	call SideViewBlockLinkCollision
	ret


;@ path: entity/helpers
;@ Direction (0-$0F, sixteenths of a circle: 0 right, 4 down, 8 left, $0C up) of a vector that is closer to
;@ horizontal (|y| < |x|), read by GetDirectionFromVector: 4 rows of 8, row = quadrant (bit 0 = y negative,
;@ bit 1 = x negative), column = |y| / 4.
DirectionFromShallowVector::
	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
;@ path: entity/helpers
;@ Direction of a vector that is closer to vertical (|y| >= |x|): same layout, column = |x| / 4.
DirectionFromSteepVector::
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

;@ def GetDirectionFromVector() -> a
;@ path: entity/helpers
;@ Turns the vector in hMultiPurpose0 (y) / hMultiPurpose1 (x), as GetVectorTowardsLink leaves it (components up
;@ to 31), into one of 16 directions (0 right, 4 down, 8 left, $0C up).
;@ test: wCurrentBank = $19
GetDirectionFromVector::
;> quadrant = (hMultiPurpose0 >> 7)       # y negative
	ldh a, [hMultiPurpose0]
	rlca
	and $01
	ld e, a
;> quadrant |= (hMultiPurpose1 >> 7) << 1  # x negative
	ldh a, [hMultiPurpose1]
	rlca
	rla
	and $02
	or e
;> row = quadrant * 8
	rla
	rla
	rla
	and $18
	ld h, a
;> ax = (0x100 - hMultiPurpose1) & 0xFF if hMultiPurpose1 & 0x80 else hMultiPurpose1
	ldh a, [hMultiPurpose1]
	bit 7, a
	jr z, .xPositive
	cpl
	inc a
.xPositive
	ld d, a
;> ay = (0x100 - hMultiPurpose0) & 0xFF if hMultiPurpose0 & 0x80 else hMultiPurpose0
	ldh a, [hMultiPurpose0]
	bit 7, a
	jr z, .yPositive
	cpl
	inc a
.yPositive
;> if ay < ax:
	cp d
	jr nc, .steep
;>     i = row + (ay >> 2)
	sra a
	sra a
	add h
	ld e, a
	ld d, b
;>     return mem[DirectionFromShallowVector + i]
	ld hl, DirectionFromShallowVector
	add hl, de
	ld a, [hl]
	ret
.steep
;> i = row + (ax >> 2)
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
;> return mem[DirectionFromSteepVector + i]
	ld hl, DirectionFromSteepVector
	add hl, de
	ld a, [hl]
	ret


;@ path: enemy/thwimp
;@ Sprites of the Thwimp, for DrawEntity16x16: variant 0 = tile $5A and its mirror (eyes shut), 1 = tile $58 and
;@ its mirror (awake).
ThwimpSprites::
	db $5a, $00, $5a, $20, $58, $00, $58, $20

;@ def ThwimpHandler(slot: bc)
;@ path: enemy/thwimp
;@ Entity $D7, the Thwimp (side view): a small stone block on the ceiling. It opens its eyes when Link is within
;@ 40 pixels sideways, drops when he is within 24, hits the floor with a thud, waits $30 frames and climbs back
;@ to where it started. States (ThwimpStates): 0 remember the start, 1 wait, 2 fall, 3 rise.
;@ test: skip draws sprites and calls routines in other banks
ThwimpHandler::
;> DrawEntity16x16(slot, ThwimpSprites)
	ld de, ThwimpSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits(slot)
	call EntityCheckHits
;> SetEntitySpriteVariant(slot, 0)                # eyes shut unless a state opens them
	xor a
	call SetEntitySpriteVariant
;> return ThwimpStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/thwimp
;@ State routines of the Thwimp: 0 remember the start height, 1 wait for Link, 2 fall, 3 climb back.
ThwimpStates::
	dw ThwimpInit
	dw ThwimpWait
	dw ThwimpFall
	dw ThwimpRise

;@ def ThwimpInit(slot: bc)
;@ path: enemy/thwimp
;@ Thwimp state 0: remembers its drawn y (its resting height) in wEntityPrivate1, then waits.
;@ test: skip calls routines in other banks
ThwimpInit::
;> wEntityPrivate1[slot] = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return ThwimpWait(slot)

;@ def ThwimpWait(slot: bc)
;@ path: enemy/thwimp
;@ Thwimp state 1: once its timer is over it watches Link: within 40 pixels sideways its eyes open, within 24 it
;@ stops and drops after 8 frames.
;@ test: skip calls routines in other banks
ThwimpWait::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
	ld e, a
;> if u8(dx + 0x28) >= 0x50: return
	add $28
	cp $50
	jr nc, .done
;> SetEntitySpriteVariant(slot, 1)                # eyes open
	ld a, $01
	call SetEntitySpriteVariant
;> if u8(dx + 0x18) >= 0x30: return
	ld a, e
	add $18
	cp $30
	jr nc, .done
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;> IncrementEntityState(slot)
	call IncrementEntityState
.done
	ret


;@ def ThwimpFall(slot: bc)
;@ path: enemy/thwimp
;@ Thwimp state 2: eyes open; after the timer (jingle 8 on its last frame) it falls, speeding up by 3 per frame up
;@ to $70. Hitting the floor: jingle 9, $30 frames of rest.
;@ test: skip calls routines in other banks
ThwimpFall::
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 1: hJingle = 8
	cp $01
	jr nz, .wait
	ld hl, hJingle
	ld [hl], $08
.wait
;> if t: return
	and a
	ret nz
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> v = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> if v < 0x70: wEntitySpeedY[slot] = v + 3   # gravity
	cp $70
	jr nc, .fast
	add $03
	ld [hl], a
.fast
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hJingle = 9                          # thud
	ld a, $09
	ldh [hJingle], a
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     IncrementEntityState(slot)
	call IncrementEntityState
.done
	ret


;@ def ThwimpRise(slot: bc)
;@ path: enemy/thwimp
;@ Thwimp state 3: after its rest it climbs (y speed -8) until it is back at its resting height, then waits again
;@ (state 0, $20 frames).
;@ test: skip calls routines in other banks
ThwimpRise::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> if hActiveEntityDrawY == wEntityPrivate1[slot]:   # back up
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr nz, .climb
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     return
	ret
.climb
;> wEntitySpeedY[slot] = 0xF8
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f8
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
	ret


;@ path: enemy/thwomp
;@ Sprites of the Thwomp's body, for DrawEntitySprites: eight OAM entries (y offset, x offset, tile, attributes)
;@ making a 32x32 block - tiles $70 $72 $72 $70 on top, $74 $76 $76 $74 below (right halves mirrored).
ThwompSprites::
	db $00, $00, $70, $00, $00, $08, $72, $00, $00, $10, $72, $20, $00, $18, $70, $20
	db $10, $00, $74, $00, $10, $08, $76, $00, $10, $10, $76, $20, $10, $18, $74, $20
;@ path: enemy/thwomp
;@ The Thwomp's eyes, drawn over the middle of its face with DrawEntity16x16: 9 variants of two OAM entries (tile,
;@ attributes; $FF = none). 0 = no eyes (shut, while it drops), 1-8 = looking in the eight directions (tiles
;@ $6C-$7E, partly mirrored): 1 up-left, 2 up, 3 up-right, 4 right, 5 down-right, 6 down, 7 down-left, 8 left.
ThwompFaceSprites::
	db $ff, $00, $ff, $00, $6e, $00, $7e, $00, $7a, $00, $7a, $20, $7e, $20, $6e, $20
	db $7e, $20, $7c, $20, $7e, $20, $6c, $20, $78, $00, $78, $20, $6c, $00, $7e, $00
	db $7c, $00, $7e, $00

;@ path: enemy/thwomp
;@ Eye variant (ThwompFaceSprites) for each of the eight directions towards Link (direction 0-7: right,
;@ down-right, down, down-left, left, up-left, up, up-right): 4, 5, 6, 7, 8, 1, 2, 3.
ThwompEyeVariants::
	db $04, $05, $06, $07, $08, $01, $02, $03

;@ def ThwompHandler(slot: bc)
;@ path: enemy/thwomp
;@ Entity $D8, the Thwomp (side view): a big stone face on the ceiling whose eyes follow Link. When he comes
;@ within about 24 pixels of being under it, it shuts its eyes and drops, shakes the screen on landing, rests
;@ $30 frames and climbs back. Link can stand on it; touching its sides pushes him off. States (ThwompStates):
;@ 0 remember the start, 1 watch, 2 drop, 3 rise.
;@ test: skip draws sprites and calls routines in other banks
ThwompHandler::
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + 8)   # the eyes sit in the middle
	ldh a, [hActiveEntityDrawY]
	add $08
	ldh [hActiveEntityDrawY], a
;> hActiveEntityX = u8(hActiveEntityX + 8)
	ldh a, [hActiveEntityX]
	add $08
	ldh [hActiveEntityX], a
;> DrawEntity16x16(slot, ThwompFaceSprites)
	ld de, ThwompFaceSprites
	call DrawEntity16x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> DrawEntitySprites(ThwompSprites, 8)
	ld hl, ThwompSprites
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> SideViewBlockLinkCollision(slot)
	call SideViewBlockLinkCollision
;> return ThwompStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/thwomp
;@ State routines of the Thwomp: 0 remember the start height, 1 watch Link, 2 drop, 3 climb back.
ThwompStates::
	dw ThwompInit
	dw ThwompWait
	dw ThwompFall
	dw ThwompRise

;@ def ThwompInit(slot: bc)
;@ path: enemy/thwomp
;@ Thwomp state 0: remembers its resting height (drawn y) in wEntityPrivate1.
;@ test: skip calls routines in other banks
ThwompInit::
;> wEntityPrivate1[slot] = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return ThwompWait(slot)

;@ def ThwompWait(slot: bc)
;@ path: enemy/thwomp
;@ Thwomp state 1: when Link is within 24 pixels of its middle sideways, it shuts its eyes (variant 0), stops,
;@ plays jingle 8 and drops; otherwise, every 8 frames, its eyes turn towards him.
;@ test: skip calls routines in other banks
ThwompWait::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> dx = u8(dx - 8)                          # from the middle of the 32-pixel face
	add $f8
	ld e, a
;> far = u8(dx + 0x28) >= 0x50
	add $28
	cp $50
	jr nc, .look
;> if not far and u8(dx + 0x18) < 0x30:
	ld a, e
	add $18
	cp $30
	jr nc, .look
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     hJingle = 8
	ld a, $08
	ldh [hJingle], a
;>     SetEntitySpriteVariant(slot, 0)            # eyes shut
	ld a, $00
	call SetEntitySpriteVariant
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     return
	ret
.look
;> if hFrameCounter & 7: return
	ldh a, [hFrameCounter]
	and $07
	jr nz, .done
;> GetVectorTowardsLink(slot, 0x1F)
	ld a, $1f
	call GetVectorTowardsLink
;> dir8 = (GetDirectionFromVector() >> 1) & 7
	call GetDirectionFromVector
	rra
	and $07
	ld e, a
	ld d, b
;> SetEntitySpriteVariant(slot, mem[ThwompEyeVariants + dir8])
	ld hl, ThwompEyeVariants
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
.done
	ret


;@ def ThwompFall(slot: bc)
;@ path: enemy/thwomp
;@ Thwomp state 2: falls, speeding up by 3 per frame up to $70, with the floor checked at its bottom (16 pixels
;@ lower). On landing: clink, $30 frames of screen shake, rest $30 frames.
;@ test: skip calls routines in other banks
ThwompFall::
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> v = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> if v < 0x70: wEntitySpeedY[slot] = v + 3   # gravity
	cp $70
	jr nc, .fast
	add $03
	ld [hl], a
.fast
;> wEntityY[slot] += 0x10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
;> hActiveEntityY += 0x10
	ldh a, [hActiveEntityY]
	add $10
	ldh [hActiveEntityY], a
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> wEntityY[slot] -= 0x10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
;> hActiveEntityY -= 0x10
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hActiveEntityY], a
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     PlayClinkNoise()
	call PlayClinkNoise
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     wBumpShakeTimer = 0x30
	ld a, $30
	ld [wBumpShakeTimer], a
;>     wBumpShakeAxis = 4
	ld a, $04
	ld [wBumpShakeAxis], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
.done
	ret


;@ def ThwompRise(slot: bc)
;@ path: enemy/thwomp
;@ Thwomp state 3: after its rest it climbs (y speed -8) back to its resting height, then watches again (state 1,
;@ $20 frames).
;@ test: skip calls routines in other banks
ThwompRise::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> if hActiveEntityDrawY == wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr nz, .climb
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     return
	ret
.climb
;> wEntitySpeedY[slot] = 0xF8
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f8
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
	ret


;@ def SideViewBlockLinkCollision(slot: bc)
;@ path: enemy/thwomp
;@ Link touching a Thwomp or a landed block: from above (more than 8 pixels higher) and falling, he lands on top
;@ of it (16 pixels above its y) and rides it (wLinkOnPlatform); from the side or below he is bounced away
;@ (speed $10 away from it).
;@ test: skip calls routines in other banks
SideViewBlockLinkCollision::
;> if not EntityTouchesLink(slot): return
	call EntityTouchesLink
	ret nc
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if not u8(dy + 8) & 0x80:                # not above it
	add $08
	bit 7, a
	jr nz, .top
;>     BounceLinkBack()
	call BounceLinkBack
;>     GetVectorTowardsLink(slot, 0x10)
	ld a, $10
	call GetVectorTowardsLink
;>     hLinkSpeedY = hMultiPurpose0         # pushed away from the block
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;>     hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
;>     return
	ret
.top
;> if hLinkSpeedY & 0x80: return            # jumping up through
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, .done
;> hLinkY = u8(wEntityY[slot] - 0x10)       # stand on it
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [hLinkY], a
;> hLinkSpeedY = 2
	ld a, $02
	ldh [hLinkSpeedY], a
;> wLinkOnPlatform = 1
	ld a, $01
	ld [wLinkOnPlatform], a
.done
	ret


;@ path: object/side_view_pot
;@ Sprite of the pot of the side-view rooms, for DrawEntity16x16: tile $5E and its mirror.
SideViewPotSprite::
	db $5e, $00, $5e, $20

;@ def SideViewPotHandler(slot: bc)
;@ path: object/side_view_pot
;@ Entity $D6, a pot in a side-view room: Link can stand on it, is pushed aside when he walks into it, and can
;@ lift it with the Power Bracelet and throw it; it breaks where it hits something. States (SideViewPotStates):
;@ 0 standing, 1-2 carried / thrown.
;@ test: skip draws sprites and calls routines in other banks
SideViewPotHandler::
;> DrawEntity16x16(slot, SideViewPotSprite)
	ld de, SideViewPotSprite
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> return SideViewPotStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/side_view_pot
;@ State routines of the side-view pot: 0 standing, 1 and 2 thrown.
SideViewPotStates::
	dw SideViewPotIdle
	dw SideViewPotThrown
	dw SideViewPotThrown

;@ def SideViewPotIdle(slot: bc)
;@ path: object/side_view_pot
;@ Pot state 0. Touching it level with it (within 3 pixels up or down) pushes Link sideways; coming down on it
;@ he stands on top. Within 18 pixels, with the Power Bracelet on a button pressed and nothing in his hands,
;@ he lifts it: status 7 (carried), state 2.
;@ test: skip calls routines in other banks
SideViewPotIdle::
;> if EntityTouchesLink(slot):
	call EntityTouchesLink
	jr nc, .lift
;>     dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
	ld e, a
;>     if u8(dy + 3) < 6: PushLinkSidewaysFromPot(slot)   # level with it
	add $03
	cp $06
	jr nc, .top
	call PushLinkSidewaysFromPot
.top
;>     if not hLinkSpeedY & 0x80:           # coming down
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, .lift
;>         dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;>         if u8(dy + 8) & 0x80:            # above it
	add $08
	bit 7, a
	jr z, .lift
;>             hLinkY = u8(wEntityY[slot] - 0x10)
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [hLinkY], a
;>             hLinkSpeedY = 2
	ld a, $02
	ldh [hLinkSpeedY], a
;>             wLinkOnPlatform = 1
	ld a, $01
	ld [wLinkOnPlatform], a
.lift
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 0x12) >= 0x24: return
	add $12
	cp $24
	ret nc
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 0x12) >= 0x24: return
	add $12
	cp $24
	ret nc
;> if wItemUsePoseTimer: return
	ld a, [wItemUsePoseTimer]
	and a
	ret nz
;> if wItemB == 0x03:                       # Power Bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .tryA
;>     if not hJoypadPressed & 0x20: return
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .grab
	ret
.tryA
;> elif wItemA == 0x03:
	ld a, [wItemA]
	cp $03
	ret nz
;>     if not hJoypadPressed & 0x10: return
	ldh a, [hJoypadPressed]
	and $10
	ret z
;> else:
;>     return
.grab
;> if wLinkIsCarrying: return
	ld a, [wLinkIsCarrying]
	and a
	ret nz
;> wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;> wEntityStatus[slot] = 7                  # carried
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;> wEntityLiftStep[slot] = 0
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
;> wEntityTimer[slot] = 2
	call GetEntityTimer
	ld [hl], $02
;> hWaveSfx = 2
	ld hl, hWaveSfx
	ld [hl], $02
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> wLiftDirection = hLinkDirection
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
	ret


;@ def SideViewPotThrown(slot: bc)
;@ path: object/side_view_pot
;@ The thrown pot flies with its speed, falling (y speed + 2 per frame while below $40), and breaks at the first
;@ wall or floor.
;@ test: skip calls routines in other banks
SideViewPotThrown::
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> v = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> if v & 0x80 or v < 0x40: wEntitySpeedY[slot] = u8(v + 2)
	bit 7, a
	jr nz, .accelerate
	cp $40
	jr nc, .walls
.accelerate
	inc [hl]
	inc [hl]
.walls
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     BreakIntoPiecesFar(slot)                          # the pot breaks (bank 3)
	call BreakIntoPiecesFar
;>     ClearEntityStatus_19(slot)
	call ClearEntityStatus_19
.done
	ret


;@ def PushLinkSidewaysFromPot(slot: bc)
;@ path: object/side_view_pot
;@ Link walking into the side of the pot: his dash stops and he is pushed away from it (x speed +/-$10 for
;@ 2 frames); in the air he is just put back to last frame's x.
;@ test: skip calls routines in other banks
PushLinkSidewaysFromPot::
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> if not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .air
;>     wLinkPushedTimer = 2
	ld a, $02
	ld [wLinkPushedTimer], a
;>     _, side = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;>     hLinkSpeedX = 0x10 if side == 0 else 0xF0   # away from the pot
	ld a, e
	and a
	ld a, $10
	jr z, .push
	ld a, $f0
.push
	ldh [hLinkSpeedX], a
;>     return
	ret
.air
;> hLinkX = hLinkPrevX
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
	ret


;@ path: event/flying_rooster
;@ Sprites of the flying rooster that follows Link (entity $D5), for DrawEntity16x16: 8 variants of two OAM
;@ entries (tile, attributes). 0/1 facing right (tiles $40-$46 mirrored, $20), 2/3 facing left (same tiles
;@ unmirrored), 4/5 facing up (tiles $4C / $4E, each drawn twice with the right half mirrored), 6/7 facing down
;@ (tiles $48 / $4A the same way). The second variant of each pair has the wings up.
RoosterCompanionSprites::
	db $42, $20, $40, $20, $46, $20, $44, $20, $40, $00, $42, $00, $44, $00, $46, $00
	db $4c, $00, $4c, $20, $4e, $00, $4e, $20, $48, $00, $48, $20, $4a, $00, $4a, $20

;@ def RoosterCompanionHandler(slot: bc)
;@ path: event/flying_rooster
;@ Entity $D5: the revived flying rooster following Link (removed when wIsRoosterFollowingLink is clear). It
;@ belongs to every room Link enters. On the ground it hops (upward speed $10, $20 while Link jumps or dashes)
;@ and chases Link (speed $0C, $20 while he dashes) until it is within 18 pixels of him; then Link can lift it
;@ with the Power Bracelet (RoosterCompanionNearLink) and fly with it (RoosterCompanionCarried, entity status
;@ 7). States: 0 follow Link, 1 thrown (RoosterCompanionBrake, until it lands). While Link is in motion state 1
;@ the rooster hovers (RoosterCompanionHover) instead of hopping.
;@ test: skip draws sprites and calls routines in other banks
RoosterCompanionHandler::
;> if not wIsRoosterFollowingLink: return ClearEntityStatus_19(slot)
	ld a, [wIsRoosterFollowingLink]
	and a
	jp z, ClearEntityStatus_19
;> wEntityRoom[slot] = hMapRoom             # stays in whatever room Link is in
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
;> wEntityPosXHigh[slot] = 0
	ld hl, wEntityPosXHigh
	add hl, bc
	ld [hl], b
;> wEntityPosYHigh[slot] = 0
	ld hl, wEntityPosYHigh
	add hl, bc
	ld [hl], b
;> DrawEntity16x16(slot, RoosterCompanionSprites)
	ld de, RoosterCompanionSprites
	call DrawEntity16x16
;> if hActiveEntityStatus == 7: return RoosterCompanionCarried(slot)   # held up by Link
	ldh a, [hActiveEntityStatus]
	cp $07
	jp z, RoosterCompanionCarried
;> if wLinkMotionState == 1:
	ld a, [wLinkMotionState]
	cp $01
	jr nz, .fall
;>     RoosterCompanionHover(slot)
	call RoosterCompanionHover
;>     landed = True
	jr .resetState
.fall
;> else:
;>     AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;>     wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 1)   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;>     landed = wEntityZ[slot] & 0x80          # dropped below the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;>     if landed:
	jr z, .interact
;>         wEntityZ[slot] = 0
	ld [hl], b
;>         wEntitySpeedZ[slot] = 0x10           # the next hop
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>         if wIsLinkInTheAir or wIsUsingPegasusBoots:
	ld a, [wIsLinkInTheAir]
	ld e, a
	ld a, [wIsUsingPegasusBoots]
	or e
	jr z, .resetState
;>             wEntitySpeedZ[slot] = 0x20
	ld [hl], $20
.resetState
;> if landed:
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.interact
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if hActiveEntityState != 0: return RoosterCompanionBrake(slot)
	ldh a, [hActiveEntityState]
	and a
	jr nz, RoosterCompanionBrake
;> base = GetEntityDirectionToLink_19(slot) * 2
	call GetEntityDirectionToLink_19
	sla e
;> flap = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, base + flap)
	add e
	call SetEntitySpriteVariant
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 0x12) < 0x24:
	add $12
	cp $24
	jr nc, .far
;>     dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;>     if u8(dy + 0x12) < 0x24: return RoosterCompanionNearLink(slot)
	add $12
	cp $24
	jr c, RoosterCompanionNearLink
.far
;> if not hFrameCounter & 7:                # re-aim every 8 frames
	ldh a, [hFrameCounter]
	and $07
	jr nz, RoosterCompanionMove
;>     speed = 0x20 if wIsUsingPegasusBoots else 0x0C
	ld a, [wIsUsingPegasusBoots]
	and a
	ld a, $0c
	jr z, .speed
	ld a, $20
.speed
;>     z = wEntityZ[slot]                    # aim as if on the ground
	ld e, a
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	push af
	push hl
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     SetEntitySpeedTowardsLink(slot, speed)
	ld a, e
	call SetEntitySpeedTowardsLink
;>     wEntityZ[slot] = z
	pop hl
	pop af
	ld [hl], a
;> return RoosterCompanionMove(slot)

;@ def RoosterCompanionMove(slot: bc)
;@ path: event/flying_rooster
;@ Moves the rooster by its speed and stops it at walls.
;@ test: skip calls routines in other banks
RoosterCompanionMove::
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> return EntityCheckWalls(slot)
	jp EntityCheckWalls


;@ def RoosterCompanionBrake(slot: bc)
;@ path: event/flying_rooster
;@ Rooster state 1 (thrown or dropped by Link): its x and y speeds move one step towards zero each frame (a speed
;@ of 0 becomes -1 and swings back), until it lands and the handler sets state 0 again.
;@ test: skip calls routines in other banks
RoosterCompanionBrake::
;> v = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> if v & 0x80: wEntitySpeedX[slot] = u8(v + 2)
	and $80
	jr z, .slowX
	inc [hl]
	inc [hl]
.slowX
;> wEntitySpeedX[slot] = u8(wEntitySpeedX[slot] - 1)
	dec [hl]
;> v = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> if v & 0x80: wEntitySpeedY[slot] = u8(v + 2)
	and $80
	jr z, .slowY
	inc [hl]
	inc [hl]
.slowY
;> wEntitySpeedY[slot] = u8(wEntitySpeedY[slot] - 1)
	dec [hl]
;> return RoosterCompanionMove(slot)
	jr RoosterCompanionMove

;@ def RoosterCompanionNearLink(slot: bc)
;@ path: event/flying_rooster
;@ The rooster is next to Link: it stops. If Link touches it, is not in an item pose, has the Power Bracelet on
;@ the B or A button and presses that button, while walking normally (motion state 0 or 1) and carrying
;@ nothing, he lifts it: entity status 7 (carried), lift animation from step 0, timer 2, wave sound 2, state 1,
;@ and Link is lifted 2 pixels into the air.
;@ test: skip calls routines in other banks
RoosterCompanionNearLink::
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> if not EntityTouchesLink(slot): return
	call EntityTouchesLink
	ret nc
;> if wItemUsePoseTimer: return
	ld a, [wItemUsePoseTimer]
	and a
	ret nz
;> if wItemB == 3:                          # Power Bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .buttonA
;>     if not hJoypadPressed & 0x20: return
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .lift
	ret
.buttonA
;> else:
;>     if wItemA != 3: return
	ld a, [wItemA]
	cp $03
	ret nz
;>     if not hJoypadPressed & 0x10: return
	ldh a, [hJoypadPressed]
	and $10
	ret z
.lift
;> if wLinkMotionState >= 2: return
	ld a, [wLinkMotionState]
	cp $02
	ret nc
;> if wLinkIsCarrying: return
	ld a, [wLinkIsCarrying]
	and a
	ret nz
;> wLinkMotionState = 0
	ld [wLinkMotionState], a
;> wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;> wEntityStatus[slot] = 7                  # carried
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;> wEntityLiftStep[slot] = 0
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
;> wEntityTimer[slot] = 2
	call GetEntityTimer
	ld [hl], $02
;> hWaveSfx = 2
	ld hl, hWaveSfx
	ld [hl], $02
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> hLinkPositionZ = 2
	ld a, $02
	ldh [hLinkPositionZ], a
;> wIsLinkInTheAir = 2
	ld [wIsLinkInTheAir], a
;> return
	ret


;@ path: event/flying_rooster
;@ Heights (wEntityZ) the hovering rooster drifts towards, one byte per step of (hFrameCounter >> 3) & 7: 6, 7, 8,
;@ 9, 9, 8, 7, 6 pixels - a slow bob.
RoosterHoverHeights::
	db $06, $07, $08, $09, $09, $08, $07, $06

;@ def RoosterCompanionHover(slot: bc)
;@ path: event/flying_rooster
;@ The rooster floats: no vertical speed, and on every second frame its height moves one pixel towards the
;@ current entry of RoosterHoverHeights.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $19
RoosterCompanionHover::
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;> i = (hFrameCounter >> 3) & 7
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
;> target = mem[RoosterHoverHeights + i]
	ld d, b
	ld hl, RoosterHoverHeights
	add hl, de
	ld e, [hl]
;> diff = u8(wEntityZ[slot] - target)
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub e
;> if diff == 0 or hFrameCounter & 1: return
	ret z
	ld e, a
	ldh a, [hFrameCounter]
	and $01
	ret nz
;> if diff & 0x80: wEntityZ[slot] += 2      # below the target: net +1
	ld a, e
	and $80
	jr z, .down
	inc [hl]
	inc [hl]
.down
;> wEntityZ[slot] -= 1
	dec [hl]
;> return
	ret


;@ path: event/flying_rooster
;@ Facing direction while Link flies with the rooster, indexed by the d-pad bits of hJoypadHeld (bit 0 right,
;@ 1 left, 2 up, 3 down): 0 right, 1 left, 2 up, 3 down, $0F = keep the current direction (nothing or a
;@ diagonal held). It has 11 entries; the indices 11-15 (opposite directions held together) read the first
;@ bytes of RoosterCarryHeights.
RoosterPadDirections::
	db $0f, $00, $01, $0f, $02, $0f, $0f, $0f, $03, $0f, $0f

;@ path: event/flying_rooster
;@ Heights (hLinkPositionZ) Link drifts towards while he flies with the rooster, one byte per step of
;@ (hFrameCounter >> 2) & 7: 20, 20, 21, 22, 23, 23, 22, 21 pixels.
RoosterCarryHeights::
	db $14, $14, $15, $16, $17, $17, $16, $15

;@ def RoosterCompanionCarried(slot: bc)
;@ path: event/flying_rooster
;@ Rooster entity status 7 (held up by Link): Link flies. The rooster faces Link's direction and flaps; Link
;@ stays in the air with no vertical speed, and every 4 frames his height moves one pixel towards
;@ RoosterCarryHeights. The d-pad turns him (RoosterPadDirections); a hit in bits 0-1 of wLinkCollisionFlags
;@ stops his y speed, bits 2-3 his x speed. The wing noise repeats.
;@ test: skip calls routines in other banks
RoosterCompanionCarried::
;> base = (hLinkDirection * 2) & 6
	ldh a, [hLinkDirection]
	rla
	and $06
	ld e, a
;> flap = (hFrameCounter >> 2) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, base + flap)
	add e
	call SetEntitySpriteVariant
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> hLinkSpeedZ = 0
	xor a
	ldh [hLinkSpeedZ], a
;> if not hFrameCounter & 3:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .steer
;>     i = (hFrameCounter >> 2) & 7
	ldh a, [hFrameCounter]
	rra
	rra
	and $07
	ld e, a
	ld d, b
;>     target = mem[RoosterCarryHeights + i]
	ld hl, RoosterCarryHeights
	add hl, de
	ld e, [hl]
;>     diff = u8(hLinkPositionZ - target)
	ld hl, hLinkPositionZ
	ld a, [hl]
	sub e
;>     if diff:
	jr z, .steer
;>         if diff & 0x80: hLinkPositionZ += 2   # below the target: net +1
	and $80
	jr z, .down
	inc [hl]
	inc [hl]
.down
;>         hLinkPositionZ -= 1
	dec [hl]
.steer
;> d = mem[RoosterPadDirections + (hJoypadHeld & 0x0F)]
	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, b
	ld hl, RoosterPadDirections
	add hl, de
;> if d != 0x0F:
	ld a, [hl]
	cp $0f
	jr z, .walls
;>     hLinkDirection = d
	ldh [hLinkDirection], a
;>     wLiftDirection = d
	ld [wLiftDirection], a
.walls
;> if wLinkCollisionFlags & 0x03: hLinkSpeedY = 0
	ld a, [wLinkCollisionFlags]
	and $03
	jr z, .sides
	xor a
	ldh [hLinkSpeedY], a
.sides
;> if wLinkCollisionFlags & 0x0C: hLinkSpeedX = 0
	ld a, [wLinkCollisionFlags]
	and $0c
	jr z, .noise
	xor a
	ldh [hLinkSpeedX], a
.noise
;> PlayPeriodicNoiseSfx()
	call PlayPeriodicNoiseSfx
;> return
	ret


;@ path: npc/richard
;@ Sprites of Richard's frogs (entity $96), for DrawEntity16x16: 8 variants of two OAM entries (tile,
;@ attributes). 0 sitting / 1 jumping seen from behind (tiles $64 / $66, right half mirrored), 2 / 3 seen from
;@ the front ($60 / $62), 4 / 5 facing left ($68 $6A / $6C $6E), 6 / 7 facing right (the same tiles mirrored).
FrogSprites::
	db $64, $00, $64, $20, $66, $00, $66, $20, $60, $00, $60, $20, $62, $00, $62, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

;@ def FrogHandler(slot: bc)
;@ path: npc/richard
;@ Entity $96: one of the frogs hopping around Richard's villa. It falls with gravity 2 and lands on the
;@ ground; between hops it sits for a random time and then jumps in one of 8 random directions. States
;@ (FrogStates): 0 sit, 1 hop.
;@ test: skip draws sprites and calls routines in other banks
FrogHandler::
;> DrawEntity16x16(slot, FrogSprites)
	ld de, FrogSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 2)    # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot] & 0x80          # used as "landed" flag
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:
	jr z, .state
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.state
;> return FrogStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/richard
;@ State routines of Richard's frog: 0 sit, 1 hop.
FrogStates::
	dw FrogSit
	dw FrogHop

;@ path: npc/richard
;@ X speeds of the 8 hop directions (up, right, down, left, up-right, down-right, down-left, up-left): 0, 16, 0,
;@ -16, 12, 12, -12, -12.
FrogHopSpeedX::
	db $00, $10, $00, $f0, $0c, $0c, $f4, $f4

;@ path: npc/richard
;@ Y speeds of the same 8 hop directions: -16, 0, 16, 0, -12, 12, 12, -12.
FrogHopSpeedY::
	db $f0, $00, $10, $00, $f4, $0c, $0c, $f4
;@ path: npc/richard
;@ Facing (sitting sprite variant, the jumping one is +1) for each of the 8 hop directions: 0 seen from behind,
;@ 6 right, 2 seen from the front, 4 left - diagonals use the up / down view by their vertical part.
FrogHopDirections::
	db $00, $06, $02, $04, $00, $06, $02, $04

;@ def FrogSit(slot: bc)
;@ path: npc/richard
;@ Frog state 0: sits until its timer runs out, then jumps: upward speed $10-$1F, x / y speed and facing from a
;@ random one of the 8 hop directions, state 1.
;@ test: skip uses random numbers
FrogSit::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .draw
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wEntitySpeedZ[slot] = (GetRandomByte() & 0x1F) | 0x10
	call GetRandomByte
	and $1f
	or $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
;>     i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[FrogHopSpeedX + i]
	ld hl, FrogHopSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[FrogHopSpeedY + i]
	ld hl, FrogHopSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityDirection[slot] = mem[FrogHopDirections + i]
	ld hl, FrogHopDirections
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
.draw
;> SetEntitySpriteVariant(slot, wEntityDirection[slot])
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	call SetEntitySpriteVariant
;> return
	ret


;@ def FrogHop(slot: bc)
;@ path: npc/richard
;@ Frog state 1: in the air with the jumping sprite. On landing it waits $10-$2F frames, stops and goes back to
;@ state 0.
;@ test: skip uses random numbers
FrogHop::
;> if hMultiPurposeG:                  # landed this frame
	ldh a, [hMultiPurposeG]
	and a
	jr z, .air
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x10
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret
.air
;> SetEntitySpriteVariant(slot, wEntityDirection[slot] + 1)
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	call SetEntitySpriteVariant
;> return
	ret


;@ path: link/motion
;@ Warp-hole ring on the overworld: one byte per overworld room, the room of the next warp hole ($01 -> $2C,
;@ $2C -> $EC, $EC -> $95, $95 -> $01); all other entries are 0. WarpHoleRiseUp follows it from the current
;@ room until it reaches a room Link has visited (bit 7 of wRoomStatus).
WarpHoleNextRoom::
	db $00, $2c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ec, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $95, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ def LinkMotionWarpHoleRise()
;@ path: link/motion
;@ Link motion state 9, entered when Link falls into one of the four overworld warp holes (rooms $01, $2C, $EC,
;@ $95): he cannot move, and the steps (WarpHoleRiseSteps, by hLinkMotionStep) wait, spin him, and lift him up
;@ until he is warped to the next warp hole he has visited.
;@ test: skip runs Link's motion
LinkMotionWarpHoleRise::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 1
	ld [wLinkFrozen], a
;> StopLinkSpeed()
	call StopLinkSpeed
;> return WarpHoleRiseSteps[hLinkMotionStep]()
	ldh a, [hLinkMotionStep]
	rst $00

;@ path: link/motion
;@ Steps of motion state 9: 0 wait, 1 spin, 2 spin and rise.
WarpHoleRiseSteps::
	dw WarpHoleRiseWait
	dw WarpHoleRiseSpin
	dw WarpHoleRiseUp

;@ def WarpHoleRiseWait()
;@ path: link/motion
;@ Step 0: waits until hLinkCountdown has run out, then step 1 with jingle $25.
;@ test: skip runs Link's motion
WarpHoleRiseWait::
;> if hLinkCountdown: return
	ldh a, [hLinkCountdown]
	and a
	jr nz, .done
;> hLinkMotionStep = 1
	ld a, $01
	ldh [hLinkMotionStep], a
;> hJingle = 0x25
	ld a, $25
	ldh [hJingle], a
.done
;> return
	ret

;@ path: link/motion
;@ Facing directions Link turns through while he spins in the warp hole, one per 4 frames: right, down, left,
;@ up (0, 3, 1, 2).
WarpHoleSpinDirections::
	db $00, $03, $01, $02

;@ def WarpHoleRiseSpin()
;@ path: link/motion
;@ Step 1: Link spins until hLinkCountdown has run out again, then step 2.
;@ test: skip runs Link's motion
WarpHoleRiseSpin::
;> if hLinkCountdown: return SpinLinkInWarpHole()
	ldh a, [hLinkCountdown]
	and a
	jr nz, SpinLinkInWarpHole
;> hLinkMotionStep = 2
	ld a, $02
	ldh [hLinkMotionStep], a
;> return
	ret

;@ def SpinLinkInWarpHole()
;@ path: link/motion
;@ Turns Link to WarpHoleSpinDirections[(hFrameCounter >> 2) & 3] and updates his animation.
;@ test: skip calls routines in other banks
SpinLinkInWarpHole::
;> i = (hFrameCounter >> 2) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	and $03
	ld e, a
	ld d, $00
;> hLinkDirection = mem[WarpHoleSpinDirections + i]
	ld hl, WarpHoleSpinDirections
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()
	call UpdateLinkAnimationStateFar
;> return
	ret

;@ def WarpHoleRiseUp()
;@ path: link/motion
;@ Step 2: Link keeps spinning and rises 4 pixels per frame. At height $78 the warp starts: the destination is
;@ the next room along WarpHoleNextRoom that Link has visited; he arrives on the overworld at x $68, y $70 (also
;@ spinning, wIsSpinningInHole), with the music fade-out.
;@ test: skip starts a warp
WarpHoleRiseUp::
;> SpinLinkInWarpHole()
	call SpinLinkInWarpHole
;> hLinkPositionZ = u8(hLinkPositionZ + 4)
	ldh a, [hLinkPositionZ]
	add $04
	ldh [hLinkPositionZ], a
;> if hLinkPositionZ < 0x78: return
	cp $78
	jr c, .done
;> wWarpTimer = hLinkPositionZ
	ld [wWarpTimer], a
;> room = hMapRoom
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
.next
;> room = mem[WarpHoleNextRoom + room]
	ld hl, WarpHoleNextRoom
	add hl, de
	ld e, [hl]
;> while not wRoomStatus[room] & 0x80:      # skip warp holes not visited yet
;>     room = mem[WarpHoleNextRoom + room]
	ld hl, wRoomStatus
	add hl, de
	ld a, [hl]
	and $80
	jr z, .next
;> wWarpRoom = room
	ld a, e
	ld [wWarpRoom], a
;> wWarpType = 0                            # overworld
	xor a
	ld [wWarpType], a
;> wWarpMap = 0
	ld [wWarpMap], a
;> wWarpDestY = 0x70
	ld a, $70
	ld [wWarpDestY], a
;> hLinkY = 0x70
	ldh [hLinkY], a
;> wWarpDestX = 0x68
	ld a, $68
	ld [wWarpDestX], a
;> hLinkX = 0x68
	ldh [hLinkX], a
;> wIsSpinningInHole = 0x68
	ld [wIsSpinningInHole], a
;> wWarpDestPosition = 0x66
	ld a, $66
	ld [wWarpDestPosition], a
;> StartWarpFadeOutMusic()
	call StartWarpFadeOutMusic
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
.done
;> return
	ret

;@ path: npc/ghost
;@ Sprites of the ghost following Link (entity $D4), for DrawEntity16x16: 6 variants of two OAM entries (tile,
;@ attributes). 0 / 1 facing right (tiles $40-$46 mirrored, $20), 2 / 3 facing left (unmirrored), 4 / 5 facing
;@ up (tiles $48 $4A / $4C $4E). The second variant of each pair is the other animation frame.
GhostSprites::
	db $42, $20, $40, $20, $46, $20, $44, $20, $40, $00, $42, $00, $44, $00, $46, $00
	db $48, $00, $4a, $00, $4c, $00, $4e, $00

;@ path: npc/ghost
;@ Floating heights of the ghost, one byte per step of (hFrameCounter >> 3) & 7; it is drawn at the value minus
;@ 4 (12 to 15 pixels above the ground).
GhostBobHeights::
	db $10, $11, $12, $13, $13, $12, $11, $10

;@ def GhostHandler(slot: bc)
;@ path: npc/ghost
;@ Entity $D4: the ghost that follows Link (removed unless wIsGhostFollowingLink is 1). It belongs to every room
;@ Link enters, is drawn only on every second frame (see-through) and floats with GhostBobHeights. In state 0
;@ it drifts after Link (speed 8, $18 while he dashes, re-aimed every 4 frames) whenever he is more than 24
;@ pixels away. Then the part of its story runs: inside its house (GhostInHouse), on the way there
;@ (GhostLookForHouse), and after the house - at its grave in room $64 (GhostGraveStates: 0 wait for Link,
;@ 1 fly to the grave, 2 sink into it) or chatting anywhere else (GhostChatter).
;@ test: skip draws sprites and calls routines in other banks
GhostHandler::
;> if wIsGhostFollowingLink != 1: return ClearEntityStatus_19(slot)
	ld a, [wIsGhostFollowingLink]
	cp $01
	jp nz, ClearEntityStatus_19
;> wEntityRoom[slot] = hMapRoom             # stays in whatever room Link is in
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
;> wEntityPosXHigh[slot] = 0
	ld hl, wEntityPosXHigh
	add hl, bc
	ld [hl], b
;> wEntityPosYHigh[slot] = 0
	ld hl, wEntityPosYHigh
	add hl, bc
	ld [hl], b
;> if not (hFrameCounter ^ slot) & 1:       # every second frame
	ldh a, [hFrameCounter]
	xor c
	and $01
	jr nz, .bob
;>     DrawEntity16x16(slot, GhostSprites)
	ld de, GhostSprites
	call DrawEntity16x16
.bob
;> if not wEntityPrivate2[slot]:            # set once it settles on its grave
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .follow
;>     i = (hFrameCounter >> 3) & 7
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
;>     h = mem[GhostBobHeights + i]
	ld d, b
	ld hl, GhostBobHeights
	add hl, de
	ld a, [hl]
;>     wEntityZ[slot] = u8(h - 4)
	sub $04
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
.follow
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .stage
;>     up = GetEntityDirectionToLink_19(slot) == 2   # Link is above it
	call GetEntityDirectionToLink_19
	ld a, e
	cp $02
;>     base = 4
	ld e, $04
;>     if not up:
	jr z, .frame
;>         base = GetLinkXDistance_19(slot)[1] * 2
	call GetLinkXDistance_19
	sla e
.frame
;>     flap = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;>     SetEntitySpriteVariant(slot, base + flap)
	add e
	call SetEntitySpriteVariant
;>     dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;>     far = u8(dx + 0x18) >= 0x30
	add $18
	cp $30
;>     if not far:
	jr nc, .far
;>         y = hLinkY
	ldh a, [hLinkY]
	push af
;>         hLinkY = u8(y + 0x0C)             # measured 12 pixels below Link
	add $0c
	ldh [hLinkY], a
;>         dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
	ld e, a
;>         hLinkY = y
	pop af
	ldh [hLinkY], a
;>         far = u8(dy + 0x18) >= 0x30
	ld a, e
	add $18
	cp $30
;>     if far:
	jr c, .stage
.far
;>         if not hFrameCounter & 3:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .move
;>             SetEntitySpeedTowardsLink(slot, 0x18 if wIsUsingPegasusBoots else 0x08)
	ld a, [wIsUsingPegasusBoots]
	and a
	ld a, $08
	jr z, .speed
	ld a, $18
.speed
	call SetEntitySpeedTowardsLink
.move
;>         UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
.stage
;> if wIsIndoor: return GhostInHouse(slot)
	ld a, [wIsIndoor]
	and a
	jp nz, GhostInHouse
;> if not wGhostSawHouse: return GhostLookForHouse(slot)
	ld a, [wGhostSawHouse]
	and a
	jp z, GhostLookForHouse
;> if hMapRoom != 0x64: return GhostChatter(slot)
	ldh a, [hMapRoom]
	cp $64
	jp nz, GhostChatter
;> return GhostGraveStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/ghost
;@ State routines of the ghost at its grave (room $64): 0 wait for Link, 1 fly to the grave, 2 sink into it.
GhostGraveStates::
	dw GhostGraveWait
	dw GhostFlyToGrave
	dw GhostSinkIntoGrave

;@ def GhostGraveWait(slot: bc)
;@ path: npc/ghost
;@ Grave state 0: when Link comes to the top-left part of the room (x below $3C, y below $7A) he is frozen and
;@ the ghost moves on to state 1.
;@ test: skip calls routines in other banks
GhostGraveWait::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if hLinkX >= 0x3C: return
	ldh a, [hLinkX]
	cp $3c
	ret nc
;> if hLinkY >= 0x7A: return
	ldh a, [hLinkY]
	cp $7a
	ret nc
;> wLinkFrozen = hLinkY
	ld [wLinkFrozen], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def GhostFlyToGrave(slot: bc)
;@ path: npc/ghost
;@ Grave state 1: the ghost flies (speed 8) to its grave at x $28, y $60 (Link's position is swapped for that
;@ point while aiming). Within 3 pixels across and 12 down it says its farewell (dialog $16 of table 2, jingle
;@ $2D), stops bobbing (wEntityPrivate2) and goes to state 2.
;@ test: skip calls routines in other banks
GhostFlyToGrave::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> y = hLinkY
	ldh a, [hLinkY]
	push af
;> x = hLinkX
	ldh a, [hLinkX]
	push af
;> hLinkY = u8(0x60 - wEntityZ[slot])      # aim at the grave
	ld hl, wEntityZ
	add hl, bc
	ld a, $60
	sub [hl]
	ldh [hLinkY], a
;> hLinkX = 0x28
	ld a, $28
	ldh [hLinkX], a
;> SetEntitySpeedTowardsLink(slot, 8)
	ld a, $08
	call SetEntitySpeedTowardsLink
;> dx, side = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
	push af
;> wEntityDirection[slot] = side * 2
	ld a, e
	sla a
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	pop af
;> if u8(dx + 3) < 6:
	add $03
	cp $06
	jr nc, .away
;>     dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;>     if u8(dy + 0x0C) < 0x18:
	add $0c
	cp $18
	jr nc, .away
;>         hLinkX = x
	pop af
	ldh [hLinkX], a
;>         hLinkY = y
	pop af
	ldh [hLinkY], a
;>         OpenDialogTable2(0x16)
	ld a, $16
	call OpenDialogTable2
;>         hJingle = 0x2D
	ld a, $2d
	ldh [hJingle], a
;>         IncrementEntityState(slot)
	call IncrementEntityState
;>         wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
;>         return
	ret
.away
;> hLinkX = x
	pop af
	ldh [hLinkX], a
;> hLinkY = y
	pop af
	ldh [hLinkY], a
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> AnimateGhost(slot)
	call AnimateGhost
;> return
	ret


;@ def GhostSinkIntoGrave(slot: bc)
;@ path: npc/ghost
;@ Grave state 2: the ghost sinks one pixel per frame. At height 0 it is gone: it no longer follows Link,
;@ wGhostSawHouse is cleared, Link can move again, and bit 6 is set in the status of indoor room $E3 of the
;@ first indoor group (wRoomStatus + $1E3, the ghost's house).
;@ test: skip calls routines in other banks
GhostSinkIntoGrave::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> wEntityZ[slot] -= 1
	ld hl, wEntityZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] == 0:
	jr nz, .sink
;>     wIsGhostFollowingLink = 0
	xor a
	ld [wIsGhostFollowingLink], a
;>     wGhostSawHouse = 0
	ld [wGhostSawHouse], a
;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     wRoomStatus[0x1E3] |= 0x40
	ld hl, wRoomStatus + $1E3
	set 6, [hl]
;>     return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19
.sink
;> AnimateGhost(slot)
	call AnimateGhost
;> return
	ret


;@ def GhostLookForHouse(slot: bc)
;@ path: npc/ghost
;@ Before it has seen its house: in room $F6, when Link comes to the lower left (y $40 or more, x below $78), the
;@ ghost speaks once (dialog $13 of table 2, jingle $2D). In other rooms it chats (GhostChatter).
;@ test: skip calls routines in other banks
GhostLookForHouse::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if wEntityPrivate3[slot]: return          # already spoke
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ret nz
;> if hMapRoom != 0xF6: return GhostChatter(slot)
	ldh a, [hMapRoom]
	cp $f6
	jp nz, GhostChatter
;> if hLinkY < 0x40: return
	ldh a, [hLinkY]
	cp $40
	ret c
;> if hLinkX >= 0x78: return
	ldh a, [hLinkX]
	cp $78
	ret nc
;> wEntityPrivate3[slot] += 1
	inc [hl]
;> hJingle = 0x2D
	ld a, $2d
	ldh [hJingle], a
;> OpenDialogTable2(0x13)
	ld a, $13
	call OpenDialogTable2
;> return
	ret


;@ def GhostChatter(slot: bc)
;@ path: npc/ghost
;@ Now and then the ghost says something (once, wEntityPrivate3): only when the room transition is done
;@ (wTransitionSequenceCounter 4), on even frames when its countdown wEntityPrivate4 reaches 0 (every 512
;@ frames), with a chance of 1 in 4 and not while Marin sings. Jingle $2D and dialog $11 of table 2 before the
;@ house, $10 after it.
;@ test: skip uses random numbers
GhostChatter::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if wEntityPrivate3[slot]: return
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ret nz
;> if wTransitionSequenceCounter != 4: return
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz
;> if hFrameCounter & 1: return
	ldh a, [hFrameCounter]
	and $01
	ret nz
;> wEntityPrivate4[slot] = u8(wEntityPrivate4[slot] - 1)
	ld hl, wEntityPrivate4
	add hl, bc
	dec [hl]
;> if wEntityPrivate4[slot]: return
	ret nz
;> if (GetRandomByte() & 3) | wMarinSinging: return
	call GetRandomByte
	and $03
	ld hl, wMarinSinging
	or [hl]
	ret nz
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;> hJingle = 0x2D
	ld a, $2d
	ldh [hJingle], a
;> return OpenDialogTable2(0x10 if wGhostSawHouse else 0x11)
	ld a, [wGhostSawHouse]
	and a
	ld a, $11
	jr z, .open
	ld a, $10
.open
	jp OpenDialogTable2


;@ def GhostInHouse(slot: bc)
;@ path: npc/ghost
;@ Indoors the ghost only acts in its house (map $1E, room $E3) and only once (until the room's event bit 5 is
;@ set): Link is frozen while the scene of GhostHouseStates plays - 0 pause, 1 / 2 four flights through the
;@ room, 3 speak, 4 leave, 5 done.
;@ test: skip calls routines in other banks
GhostInHouse::
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if hMapId != 0x1E: return
	ldh a, [hMapId]
	cp $1e
	ret nz
;> if hMapRoom != 0xE3: return
	ldh a, [hMapRoom]
	cp $e3
	ret nz
;> if hRoomStatus & 0x20: return
	ldh a, [hRoomStatus]
	and $20
	ret nz
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> return GhostHouseStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/ghost
;@ State routines of the ghost's scene in its house: 0 pause, 1 start a flight, 2 fly, 3 speak, 4 leave, 5 done.
GhostHouseStates::
	dw GhostHouseInit
	dw GhostHouseStartMove
	dw GhostHouseMove
	dw GhostHouseSpeak
	dw GhostHouseLeave
	dw GhostHouseDone

;@ def GhostHouseInit(slot: bc)
;@ path: npc/ghost
;@ House state 0: a pause of $40 frames before the next flight.
;@ test: skip calls routines in other banks
GhostHouseInit::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ path: npc/ghost
;@ Lengths in frames of the ghost's four flights through its house (indexed by wEntityPrivateCounter): $60,
;@ $28, $28, $68.
GhostHouseMoveTimes::
	db $60, $28, $28, $68

;@ path: npc/ghost
;@ X speeds of the four flights: 0, -8, -4, 8.
GhostHouseMoveSpeedX::
	db $00, $f8, $fc, $08

;@ path: npc/ghost
;@ Y speeds of the four flights: -8, -4, -8, 2.
GhostHouseMoveSpeedY::
	db $f8, $fc, $f8, $02

;@ path: npc/ghost
;@ Facing during the four flights (sprite pair of GhostSprites): 4 up, 2 left, 4 up, 0 right.
GhostHouseMoveDirections::
	db $04, $02, $04, $00

;@ def GhostHouseStartMove(slot: bc)
;@ path: npc/ghost
;@ House state 1: after the pause, flight number wEntityPrivateCounter starts with its length, speeds and facing.
;@ test: skip calls routines in other banks
GhostHouseStartMove::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .animate
;>     i = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
;>     wEntityTimer[slot] = mem[GhostHouseMoveTimes + i]
	ld hl, GhostHouseMoveTimes
	add hl, de
	ld a, [hl]
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = mem[GhostHouseMoveSpeedX + i]
	ld hl, GhostHouseMoveSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[GhostHouseMoveSpeedY + i]
	ld hl, GhostHouseMoveSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityDirection[slot] = mem[GhostHouseMoveDirections + i]
	ld hl, GhostHouseMoveDirections
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
.animate
;> return AnimateGhost(slot)
	jr AnimateGhost

;@ def GhostHouseMove(slot: bc)
;@ path: npc/ghost
;@ House state 2: the ghost flies. When the flight is over (timer then $50) the flight count goes up; after the
;@ fourth flight it goes on to state 3, otherwise back to state 0.
;@ test: skip calls routines in other banks
GhostHouseMove::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .move
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wEntityPrivateCounter[slot] != 4:
	cp $04
	jr z, .move
;>         wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.move
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> return AnimateGhost(slot)

;@ def AnimateGhost(slot: bc)
;@ path: npc/ghost
;@ Sprite variant = wEntityDirection + (hFrameCounter >> 4) & 1: the facing pair, switching frames every 16
;@ frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $19
AnimateGhost::
;> base = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
;> flap = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, base + flap)
	add e
	call SetEntitySpriteVariant
;> return
	ret


;@ def GhostHouseSpeak(slot: bc)
;@ path: npc/ghost
;@ House state 3: after $50 frames the ghost speaks (dialog $14 of table 2; Link's y is set to $10 while the
;@ dialog opens, so the box appears at the bottom), then waits another $50 frames in state 4.
;@ test: skip calls routines in other banks
GhostHouseSpeak::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .animate
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     y = hLinkY
	ldh a, [hLinkY]
	push af
;>     hLinkY = 0x10
	ld a, $10
	ldh [hLinkY], a
;>     OpenDialogTable2(0x14)
	ld a, $14
	call OpenDialogTable2
;>     hLinkY = y
	pop af
	ldh [hLinkY], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
.animate
;> return AnimateGhost(slot)
	jp AnimateGhost


;@ def GhostHouseLeave(slot: bc)
;@ path: npc/ghost
;@ House state 4: the ghost drifts down and to the left (y speed 10, x speed -4, facing left); when the timer
;@ runs out it says dialog $15 of table 2 and goes to state 5.
;@ test: skip calls routines in other banks
GhostHouseLeave::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .drift
;>     OpenDialogTable2(0x15)
	ld a, $15
	call OpenDialogTable2
;>     IncrementEntityState(slot)
	call IncrementEntityState
.drift
;> wEntitySpeedY[slot] = 0x0A
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $0a
;> wEntitySpeedX[slot] = 0xFC
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fc
;> wEntityDirection[slot] = 2
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> return AnimateGhost(slot)
	jp AnimateGhost
;> return                                   # never reached
	ret

;@ def GhostHouseDone(slot: bc)
;@ path: npc/ghost
;@ House state 5 (after the dialog): the ghost has seen its house (wGhostSawHouse = 1, the room's event is
;@ marked done), it disappears and Link is warped out with a fade-out.
;@ test: skip starts a warp
GhostHouseDone::
;> wGhostSawHouse = 1
	ld a, $01
	ld [wGhostSawHouse], a
;> MarkRoomEventDone_19()
	call MarkRoomEventDone_19
;> ClearEntityStatus_19(slot)
	call ClearEntityStatus_19
;> return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise


;@ path: event/keyhole
;@ A single 0 byte in front of BirdKeyFrame1Left. DrawBirdKeyColumns looks at the byte before each byte it
;@ copies (a byte after $98 is the low byte of a BG address); this one keeps the first block's first byte from
;@ being taken for such a byte.
BirdKeyColumnsLeadByte::
	db $00

;@ path: event/keyhole
;@ Bird Key keyhole, animation frame 1, BG columns 6-8: four background draw commands of 13 bytes each (BG
;@ address high, low, mode $89 = vertical, 10 tiles; then the 10 tiles from row 0 down). Column 6: $00 $04
;@ repeated, ending in $10; column 7: $01 $11 repeated; column 8 (written twice): $07 $06 repeated.
BirdKeyFrame1Left::
	db $98, $06, $89, $00, $04, $00, $04, $00, $04, $00, $04, $00, $10
	db $98, $07, $89, $01, $11, $01, $11, $01, $11, $01, $11, $01, $11
	db $98, $08, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $98, $08, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06

;@ path: event/keyhole
;@ Frame 1, columns 9-11 (same command format): column 9 $06 $07 repeated, column 10 $07 $06, column 11 (written
;@ twice) $06 $07.
BirdKeyFrame1Middle::
	db $98, $09, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07
	db $98, $0a, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $98, $0b, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07
	db $98, $0b, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07

;@ path: event/keyhole
;@ Frame 1, columns 12-15 (same command format): column 12 $07 $06 repeated, column 13 $06 $07, column 14 $02 $12,
;@ column 15 $03 $05 repeated, ending in $13.
BirdKeyFrame1Right::
	db $98, $0c, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $98, $0d, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07
	db $98, $0e, $89, $02, $12, $02, $12, $02, $12, $02, $12, $02, $12
	db $98, $0f, $89, $03, $05, $03, $05, $03, $05, $03, $05, $03, $13

;@ path: event/keyhole
;@ Frame 0, columns 6-8: the same commands with every tile pair swapped - column 6 $04 $00 ending in $14,
;@ column 7 $11 $01, column 8 (twice) $06 $07.
BirdKeyFrame0Left::
	db $98, $06, $89, $04, $00, $04, $00, $04, $00, $04, $00, $04, $14
	db $98, $07, $89, $11, $01, $11, $01, $11, $01, $11, $01, $11, $01
	db $98, $08, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07
	db $98, $08, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07

;@ path: event/keyhole
;@ Frame 0, columns 9-11: column 9 $07 $06, column 10 $06 $07, column 11 (twice) $07 $06.
BirdKeyFrame0Middle::
	db $98, $09, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $98, $0a, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07
	db $98, $0b, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $98, $0b, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06

;@ path: event/keyhole
;@ Frame 0, columns 12-15: column 12 $06 $07, column 13 $07 $06, column 14 $12 $02, column 15 $05 $03 ending in
;@ $15.
BirdKeyFrame0Right::
	db $98, $0c, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07
	db $98, $0d, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $98, $0e, $89, $12, $02, $12, $02, $12, $02, $12, $02, $12, $02
	db $98, $0f, $89, $05, $03, $05, $03, $05, $03, $05, $03, $05, $15

;@ path: event/keyhole
;@ The two frames of columns 6-8, picked by bit 0 of wEntityPrivate1: frame 0, frame 1.
BirdKeyLeftColumns::
	dw BirdKeyFrame0Left
	dw BirdKeyFrame1Left

;@ path: event/keyhole
;@ The two frames of columns 9-11.
BirdKeyMiddleColumns::
	dw BirdKeyFrame0Middle
	dw BirdKeyFrame1Middle

;@ path: event/keyhole
;@ The two frames of columns 12-15.
BirdKeyRightColumns::
	dw BirdKeyFrame0Right
	dw BirdKeyFrame1Right

;@ def BirdKeyEvent(slot: bc)
;@ path: event/keyhole
;@ Keyhole scene for the Bird Key (overworld room $0E, entity $28 spawned with wEntityPrivate2 set): Link is
;@ frozen while the ground rumbles, the area at BG columns 6-15 is redrawn 12 times between two frames
;@ (one round = left, middle, right block, $18 frames apart) while two groups of sprites move along
;@ (DrawBirdKeyPieces), and finally an entrance opens. States (BirdKeyEventStates): 0 start, 1 rumble, 2 wait,
;@ 3-5 draw the three column blocks, 6 done.
;@ test: skip draws sprites and calls routines in other banks
BirdKeyEvent::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawBirdKeyPieces(slot)
	call DrawBirdKeyPieces
;> return BirdKeyEventStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: event/keyhole
;@ State routines of the Bird Key scene: 0 start, 1 rumble, 2 wait, 3 draw columns 6-8, 4 draw columns 9-11,
;@ 5 draw columns 12-15 and count the round, 6 done.
BirdKeyEventStates::
	dw BirdKeyEventStart
	dw BirdKeyEventRumble
	dw BirdKeyEventWait
	dw BirdKeyEventDrawLeft
	dw BirdKeyEventDrawMiddle
	dw BirdKeyEventDrawRight
	dw BirdKeyEventDone

;@ def BirdKeyEventStart(slot: bc)
;@ path: event/keyhole
;@ State 0: stops the music and starts the rumble ($FF frames).
;@ test: skip calls routines in other banks
BirdKeyEventStart::
;> ResetSoundEngine()
	call ResetSoundEngine
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return BirdKeyEventRumble(slot)

;@ def BirdKeyEventRumble(slot: bc)
;@ path: event/keyhole
;@ State 1, timer counting down from $FF: until $A0 the sprite variant blinks between 0 and $FF every 16 frames;
;@ at $A0 noise $1D starts, and from then on the screen shakes sideways (x scroll +1 / -2, switching every
;@ 4 frames). At 0 the shaking stops, jingle $2E plays and state 2 follows.
;@ test: skip calls routines in other banks
BirdKeyEventRumble::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .running
;>     wScreenShakeX = 0
	ld [wScreenShakeX], a
;>     SetEntitySpriteVariant(slot, 0)
	call SetEntitySpriteVariant
;>     hJingle = 0x2E
	ld a, $2e
	ldh [hJingle], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     return
	ret
.running
;> if t == 0xA0:
	cp $a0
	jr nz, .check
;>     hNoiseSfx = 0x1D
	ld a, $1d
	ldh [hNoiseSfx], a
;>     t = 0x1D                             # the register now holds the sound number
.check
;> if t >= 0xA0:
	jr c, .shake
;>     return SetEntitySpriteVariant(slot, 0xFF if t & 0x10 else 0)
	and $10
	ld a, $00
	jr z, .variant
	ld a, $ff
.variant
	call SetEntitySpriteVariant
	ret
.shake
;> wScreenShakeX = 0xFE if t & 4 else 1
	ld e, $01
	and $04
	jr z, .shift
	ld e, $fe
.shift
	ld a, e
	ld [wScreenShakeX], a
;> return
	ret


;@ def BirdKeyEventWait(slot: bc)
;@ path: event/keyhole
;@ State 2: waits for the timer, then the next round of drawing (state 3).
;@ test: skip calls routines in other banks
BirdKeyEventWait::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	and a
	jr nz, .wait
;>     IncrementEntityState(slot)
	call IncrementEntityState
.wait
;> return
	ret


;@ def BirdKeyEventDrawLeft(slot: bc)
;@ path: event/keyhole
;@ State 3: queues columns 6-8 of the current frame.
;@ test: skip calls routines in other banks
BirdKeyEventDrawLeft::
;> return DrawBirdKeyColumns(slot, BirdKeyLeftColumns)
	ld hl, BirdKeyLeftColumns
	jr DrawBirdKeyColumns

;@ def BirdKeyEventDrawMiddle(slot: bc)
;@ path: event/keyhole
;@ State 4: queues columns 9-11 of the current frame.
;@ test: skip calls routines in other banks
BirdKeyEventDrawMiddle::
;> return DrawBirdKeyColumns(slot, BirdKeyMiddleColumns)
	ld hl, BirdKeyMiddleColumns

;@ def DrawBirdKeyColumns(slot: bc, table: hl)
;@ path: event/keyhole
;@ Copies the 52-byte block of draw commands for frame (wEntityPrivate1 & 1) from the two-pointer table into
;@ wDrawCommand and ends the list. When hBaseScrollX is not 0 every BG address low byte (a byte after $98) is
;@ moved 12 columns right. Then the next state.
;@ test: skip writes the background draw queue
DrawBirdKeyColumns::
;> frame = wEntityPrivate1[slot] & 1
	push bc
	push hl
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> p = table + frame * 2
	rla
	and $02
	ld e, a
	ld d, b
	pop hl
	add hl, de
;> src = mem[p] | (mem[p + 1] << 8)
	ld a, [hli]
	ld d, [hl]
	ld e, a
;> dst = wDrawCommand
	ld c, $34
	ld hl, wDrawCommand
;> for _ in range(0x34):
.copy
;>     address_low = mem[src - 1] == 0x98
	dec de
	ld a, [de]
	inc de
	cp $98
;>     v = mem[src]
	ld a, [de]
;>     if address_low and hBaseScrollX:
	jr nz, .store
	ldh a, [hBaseScrollX]
	and a
	ld a, [de]
	jr z, .store
;>         v = u8(v + 0x0C)
	add $0c
.store
;>     src += 1
	inc de
;>     mem[dst] = v
;>     dst += 1
	ld [hli], a
	dec c
	jr nz, .copy
;> mem[dst] = 0                             # end of the list
	ld [hl], $00
;> IncrementEntityState(slot)
	pop bc
	call IncrementEntityState
;> return
	ret


;@ def BirdKeyEventDrawRight(slot: bc)
;@ path: event/keyhole
;@ State 5: queues columns 12-15, switches to the other frame and counts the round. After 12 rounds the music
;@ that played before resumes and the scene ends (state 6); otherwise it waits $18 frames (state 2).
;@ test: skip writes the background draw queue
BirdKeyEventDrawRight::
;> DrawBirdKeyColumns(slot, BirdKeyRightColumns)
	ld hl, BirdKeyRightColumns
	call DrawBirdKeyColumns
;> wEntityTimer[slot] = 0x18
	call GetEntityTimer
	ld [hl], $18
;> wEntityPrivate1[slot] += 1               # other frame
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] == 0x0C:
	cp $0c
	jr nz, .again
;>     wMusicTrackToPlay = hLastMusicTrack
	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a
;>     return
	ret
.again
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> return
	ret


;@ def BirdKeyEventDone(slot: bc)
;@ path: event/keyhole
;@ State 6: the room's event is marked done (status bits 5 and 4), the shaking stops, Link can move, jingle 2.
;@ The room objects of column 5 become an entrance: row 2 $E1, rows 3 and 4 $77, and their tiles are drawn
;@ (DrawBirdKeyEntrance). The entity is removed.
;@ test: skip writes the background draw queue
BirdKeyEventDone::
;> MarkRoomEventDone_19()
	call MarkRoomEventDone_19
;> wRoomStatus[hMapRoom] |= 0x10            # hl still points at the room's status byte
	set 4, [hl]
;> wScreenShakeX = 0
	xor a
	ld [wScreenShakeX], a
;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> hJingle = 2
	ld a, $02
	ldh [hJingle], a
;> wRoomObjects[0x25] = 0xE1
	ld a, $e1
	ld [wRoomObjects + $25], a
;> wRoomObjects[0x35] = 0x77
	ld a, $77
	ld [wRoomObjects + $35], a
;> wRoomObjects[0x45] = 0x77
	ld a, $77
	ld [wRoomObjects + $45], a
;> DrawBirdKeyEntrance(slot)
	call DrawBirdKeyEntrance
;> return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19


;@ path: event/keyhole
;@ Tiles of the opened entrance: four background draw commands (BG address high, low, mode, tiles; mode $87 =
;@ vertical 8 tiles, $81 = vertical 2 tiles). Column 10 from row 2: $0C $1C $64 $66 $0F $0F $0F $0F; column 11:
;@ $0D $1D $65 $67 $1F $1F $1F $1F; column 9 rows 2-3: $0B $1B; column 12 rows 2-3: $0E $1E. 32 bytes.
BirdKeyEntranceTiles::
	db $98, $4a, $87, $0c, $1c, $64, $66, $0f, $0f, $0f, $0f
	db $98, $4b, $87, $0d, $1d, $65, $67, $1f, $1f, $1f, $1f
	db $98, $49, $81, $0b, $1b
	db $98, $4c, $81, $0e, $1e
;@ path: event/keyhole
;@ The same commands 12 columns further right (columns 22, 23, 21, 24), used when hBaseScrollX is not 0.
BirdKeyEntranceTilesScrolled::
	db $98, $56, $87, $0c, $1c, $64, $66, $0f, $0f, $0f, $0f
	db $98, $57, $87, $0d, $1d, $65, $67, $1f, $1f, $1f, $1f
	db $98, $55, $81, $0b, $1b
	db $98, $58, $81, $0e, $1e

;@ def DrawBirdKeyEntrance()
;@ path: event/keyhole
;@ Queues the 32 bytes of BirdKeyEntranceTiles (or BirdKeyEntranceTilesScrolled when hBaseScrollX is not 0) in
;@ wDrawCommand and ends the list.
;@ test: skip writes the background draw queue
DrawBirdKeyEntrance::
;> wDrawCommandsSize = 0x20
	ld a, $20
	ld [wDrawCommandsSize], a
;> dst = wDrawCommand
	ld hl, wDrawCommand
;> src = BirdKeyEntranceTilesScrolled if hBaseScrollX else BirdKeyEntranceTiles
	ld de, BirdKeyEntranceTiles
	ldh a, [hBaseScrollX]
	and a
	jr z, .copy
	ld de, BirdKeyEntranceTilesScrolled
.copy
;> for _ in range(0x20):
	push bc
	ld c, $20
.loop
;>     mem[dst] = mem[src]
	ld a, [de]
	inc de
	ld [hli], a
;>     src += 1; dst += 1
	dec c
	jr nz, .loop
;> mem[dst] = 0                             # end of the list
	pop bc
	ld [hl], b
;> return
	ret


;@ path: event/keyhole
;@ X positions of sprite group A for each round of the Bird Key scene (index wEntityPrivateCounter, 0-12).
BirdKeyPieceAX::
	db $50, $5c, $68, $70, $7a, $7e, $58, $32, $38, $38, $40, $44, $50

;@ path: event/keyhole
;@ Y positions (drawn y) of sprite group A for each round.
BirdKeyPieceAY::
	db $20, $20, $20, $20, $20, $1f, $1e, $1f, $20, $20, $20, $20, $20

;@ path: event/keyhole
;@ Frame (in BirdKeyPieceASprites) of group A for each round.
BirdKeyPieceAFrames::
	db $03, $03, $04, $04, $05, $05, $06, $01, $01, $02, $02, $03, $03

;@ path: event/keyhole
;@ X positions of sprite group B for each round ($C0 = off the screen for the first 7 rounds).
BirdKeyPieceBX::
	db $c0, $c0, $c0, $c0, $c0, $c0, $c0, $38, $3a, $3b, $44, $4c, $58

;@ path: event/keyhole
;@ Y positions (drawn y) of sprite group B for each round ($FF while it is hidden).
BirdKeyPieceBY::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $2f, $30, $30, $30, $30, $30

;@ path: event/keyhole
;@ Frame (in BirdKeyPieceBSprites) of group B for each round.
BirdKeyPieceBFrames::
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $04

;@ path: event/keyhole
;@ Sprite group A, for DrawEntitySprites: 7 frames of 4 OAM entries (y offset, x offset, tile, attributes; tile
;@ $FF = unused entry), a row of 8x16 sprites. Frame 0: tile $70; 1: $72 $74; 2: $76 $78 $7A; 3: $7C $7E and
;@ the same two mirrored ($20); 4: $7A $78 $76 mirrored; 5: $74 $72 mirrored; 6: tile $70 mirrored at x +$30
;@ and $70 at x -$28.
BirdKeyPieceASprites::
	db $00, $00, $70, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $72, $00, $00, $08, $74, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $76, $00, $00, $08, $78, $00, $00, $10, $7a, $00, $00, $00, $ff, $00
	db $00, $00, $7c, $00, $00, $08, $7e, $00, $00, $10, $7e, $20, $00, $18, $7c, $20
	db $00, $00, $7a, $20, $00, $08, $78, $20, $00, $10, $76, $20, $00, $00, $ff, $00
	db $00, $00, $74, $20, $00, $08, $72, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $30, $70, $20, $00, $d8, $70, $00, $00, $00, $ff, $00, $00, $00, $ff, $00

;@ path: event/keyhole
;@ Sprite group B, for DrawEntitySprites: 5 frames of 6 OAM entries (y offset, x offset, tile, attributes),
;@ columns of three 8x16 sprites (palette bit $10 on the top one). Frame 0: $60 over $62 $62; 1: $64 over $66
;@ $66; 2-4: two columns $68 over $6A $6A, the right one mirrored ($20), at x +2 / +5, +1 / +7 and 0 / +8.
BirdKeyPieceBSprites::
	db $00, $00, $60, $10, $10, $00, $62, $00, $20, $00, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $64, $10, $10, $00, $66, $00, $20, $00, $66, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $02, $68, $10, $10, $02, $6a, $00, $20, $02, $6a, $00
	db $00, $05, $68, $30, $10, $05, $6a, $20, $20, $05, $6a, $20
	db $00, $01, $68, $10, $10, $01, $6a, $00, $20, $01, $6a, $00
	db $00, $07, $68, $30, $10, $07, $6a, $20, $20, $07, $6a, $20
	db $00, $00, $68, $10, $10, $00, $6a, $00, $20, $00, $6a, $00
	db $00, $08, $68, $30, $10, $08, $6a, $20, $20, $08, $6a, $20

;@ def DrawBirdKeyPieces(slot: bc)
;@ path: event/keyhole
;@ Draws the two sprite groups of the Bird Key scene at the position and frame of the current round
;@ (wEntityPrivateCounter): group A with 4 entries, group B with 6.
;@ test: skip draws sprites
DrawBirdKeyPieces::
;> i = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
;> hActiveEntityX = mem[BirdKeyPieceAX + i]
	ld hl, BirdKeyPieceAX
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = mem[BirdKeyPieceAY + i]
	ld hl, BirdKeyPieceAY
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> frame = mem[BirdKeyPieceAFrames + i]
	ld hl, BirdKeyPieceAFrames
	add hl, de
	ld a, [hl]
;> offset = frame * 16
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
;> DrawEntitySprites(BirdKeyPieceASprites + offset, 4)
	ld d, b
	ld hl, BirdKeyPieceASprites
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> i = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
;> hActiveEntityX = mem[BirdKeyPieceBX + i]
	ld hl, BirdKeyPieceBX
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = mem[BirdKeyPieceBY + i]
	ld hl, BirdKeyPieceBY
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> frame = mem[BirdKeyPieceBFrames + i]
	ld hl, BirdKeyPieceBFrames
	add hl, de
	ld a, [hl]
;> offset = frame * 8
	rla
	rla
	rla
	and $f8
	ld e, a
;> offset = u8(offset + offset * 2)         # frame * 24
	rla
	and $f0
	add e
	ld e, a
;> DrawEntitySprites(BirdKeyPieceBSprites + offset, 6)
	ld d, b
	ld hl, BirdKeyPieceBSprites
	add hl, de
	ld c, $06
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: event/keyhole
;@ Face Key keyhole, step 0 of the upper half: four background draw commands of 13 bytes each (BG address high,
;@ low, mode $09 = horizontal, 10 tiles; then the tiles), for rows 0-3 from column 2. Rows 0 and 1: $55 $56
;@ repeated; row 2: $0C $0D repeated; row 3: $0E $0F repeated.
FaceKeyTop0::
	db $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $98, $22, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $98, $42, $09, $0c, $0d, $0c, $0d, $0c, $0d, $0c, $0d, $0c, $0d
	db $98, $62, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f

;@ path: event/keyhole
;@ Upper half, step 1 (same format, rows 0-3): $55 $56, $55 $56, $0E $0F, $0F $0E.
FaceKeyTop1::
	db $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $98, $22, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $98, $42, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $62, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e

;@ path: event/keyhole
;@ Upper half, step 2 (rows 0-3): $55 $56, $0E $0F, $0F $0E, $0E $0F.
FaceKeyTop2::
	db $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56
	db $98, $22, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $42, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $62, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f

;@ path: event/keyhole
;@ Upper half, step 3 (rows 0-3): $0E $0F, $0F $0E, $0E $0F, $0F $0E.
FaceKeyTop3::
	db $98, $02, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $22, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $42, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $62, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
;@ path: event/keyhole
;@ Lower half, step 0 (same format, rows 4-7 from column 2): row 4 $0F $0E $0F $0F $0F $0E $0F $0E $0F $0E;
;@ row 5 $0E $0F repeated; row 6 $0F $0E repeated; row 7 ten $1E.
FaceKeyBottom0::
	db $98, $82, $09, $0f, $0e, $0f, $0f, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $a2, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $c2, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $e2, $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e

;@ path: event/keyhole
;@ Lower half, step 1 (rows 4-7): $0E $0F repeated; $0F $0E repeated; ten $1E; $09 $08 $18 $09 $7E $7E $09 $08
;@ $18 $09.
FaceKeyBottom1::
	db $98, $82, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $a2, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $c2, $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
	db $98, $e2, $09, $09, $08, $18, $09, $7e, $7e, $09, $08, $18, $09

;@ path: event/keyhole
;@ Lower half, step 2 (rows 4-7): $0E $0F repeated; ten $1E; $09 $08 $18 $09 $7E $7E $09 $08 $18 $09; $09 $04
;@ $05 $09 $7E $7E $09 $04 $05 $09.
FaceKeyBottom2::
	db $98, $82, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $98, $a2, $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
	db $98, $c2, $09, $09, $08, $18, $09, $7e, $7e, $09, $08, $18, $09
	db $98, $e2, $09, $09, $04, $05, $09, $7e, $7e, $09, $04, $05, $09

;@ path: event/keyhole
;@ Lower half, step 3 (rows 4-7): ten $1E; $09 $08 $18 $09 $7E $7E $09 $08 $18 $09; $09 $04 $05 $09 $7E $7E $09
;@ $04 $05 $09; $19 $14 $15 $19 $1F $1F $19 $14 $15 $19.
FaceKeyBottom3::
	db $98, $82, $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
	db $98, $a2, $09, $09, $08, $18, $09, $7e, $7e, $09, $08, $18, $09
	db $98, $c2, $09, $09, $04, $05, $09, $7e, $7e, $09, $04, $05, $09
	db $98, $e2, $09, $19, $14, $15, $19, $1f, $1f, $19, $14, $15, $19
;@ path: event/keyhole
;@ The upper-half blocks for steps 0-3 (index wEntityPrivate1).
FaceKeyTopRows::
	dw FaceKeyTop0
	dw FaceKeyTop1
	dw FaceKeyTop2
	dw FaceKeyTop3

;@ path: event/keyhole
;@ The lower-half blocks for steps 0-3.
FaceKeyBottomRows::
	dw FaceKeyBottom0
	dw FaceKeyBottom1
	dw FaceKeyBottom2
	dw FaceKeyBottom3

;@ def KeyholeEvent(slot: bc)
;@ path: event/keyhole
;@ Entity $28 spawned by a keyhole (wEntityPrivate2 set) plays the scene of the key: room $0E the Bird Key
;@ (BirdKeyEvent), otherwise the Face Key (room $8C). Face Key scene: Link is frozen, the ground rumbles and
;@ dust rises, and in four steps the area at BG rows 0-7, columns 2-11 is redrawn (upper half, then lower
;@ half, with a rumble of $30 frames between steps) until a staircase lies open. States (FaceKeyEventStates):
;@ 0 start, 1 rumble, 2 draw the upper half, 3 draw the lower half.
;@ test: skip calls routines in other banks
KeyholeEvent::
;> if hMapRoom == 0x0E: return BirdKeyEvent(slot)
	ldh a, [hMapRoom]
	cp $0e
	jp z, BirdKeyEvent
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> return FaceKeyEventStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: event/keyhole
;@ State routines of the Face Key scene: 0 start, 1 rumble, 2 draw the upper half, 3 draw the lower half.
FaceKeyEventStates::
	dw FaceKeyEventStart
	dw FaceKeyEventRumble
	dw FaceKeyEventDrawTop
	dw FaceKeyEventDrawBottom

;@ def FaceKeyEventStart(slot: bc)
;@ path: event/keyhole
;@ State 0: noise 4 and a rumble of $AC frames (both timers).
;@ test: skip calls routines in other banks
FaceKeyEventStart::
;> hNoiseSfx = 4
	ld a, $04
	ldh [hNoiseSfx], a
;> wEntityTimer[slot] = 0xAC
	call GetEntityTimer
	ld [hl], $ac
;> wEntityTimer1[slot] = 0xAC
	call GetEntityTimer1
	ld [hl], $ac
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return FaceKeyEventRumble(slot)

;@ def FaceKeyEventRumble(slot: bc)
;@ path: event/keyhole
;@ State 1: the screen shakes sideways (x scroll +1 / -2, switching every 4 frames). At timer $A0 noise $2E
;@ plays; at 0 jingle $2F and the next drawing step (state 2). Once wEntityTimer1 has run out, a dust cloud
;@ may rise (SpawnFaceKeyDust).
;@ test: skip calls routines in other banks
FaceKeyEventRumble::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0xA0: hNoiseSfx = 0x2E
	cp $a0
	jr nz, .check
	ld hl, hNoiseSfx
	ld [hl], $2e
.check
;> if t == 0:
	and a
	jr nz, .shake
;>     hJingle = 0x2F
	ld a, $2f
	ldh [hJingle], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     t = 0x2F                             # the register still holds the jingle number
.shake
;> wScreenShakeX = 0xFE if t & 4 else 1
	ld e, $01
	and $04
	jr z, .shift
	ld e, $fe
.shift
	ld a, e
	ld [wScreenShakeX], a
;> if GetEntityTimer1(slot): return
	call GetEntityTimer1
	ret nz
;> return SpawnFaceKeyDust(slot)
	jp SpawnFaceKeyDust


;@ def FaceKeyEventDrawTop(slot: bc)
;@ path: event/keyhole
;@ State 2: queues the upper-half block of step wEntityPrivate1 (with every $98 byte turned into $9A when
;@ hBaseScrollY is not 0, the lower BG half). After the last step the music that played before resumes.
;@ test: skip writes the background draw queue
FaceKeyEventDrawTop::
;> step = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	push af
;> p = FaceKeyTopRows + (step * 2 & 6)
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, FaceKeyTopRows
	add hl, de
;> src = mem[p] | (mem[p + 1] << 8)
	ld a, [hli]
	ld d, [hl]
	ld e, a
;> dst = wDrawCommand
	push bc
	ld c, $34
	ld hl, wDrawCommand
;> for _ in range(0x34):
.copy
;>     v = mem[src]
	ld a, [de]
;>     if v == 0x98 and hBaseScrollY:
	cp $98
	jr nz, .store
	ldh a, [hBaseScrollY]
	and a
	ld a, $98
	jr z, .store
;>         v = 0x9A
	ld a, $9a
.store
;>     src += 1
	inc de
;>     mem[dst] = v
;>     dst += 1
	ld [hli], a
	dec c
	jr nz, .copy
;> mem[dst] = 0                             # end of the list
	ld [hl], $00
;> if step == 3:
	pop bc
	pop af
	cp $03
	jr nz, .next
;>     wMusicTrackToPlay = hLastMusicTrack
	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a
.next
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def FaceKeyEventDrawBottom(slot: bc)
;@ path: event/keyhole
;@ State 3: queues the lower-half block of step wEntityPrivate1 (same $98 -> $9A rule) and counts the step.
;@ After step 3 the room objects become the open staircase (rows 0-1 columns 1-5 $B3; row 2 $AD $B1 $E7 $AD
;@ $B1; row 3 $AE $B2 $E3 $AE $B2), the room's event is marked done (status bits 5 and 4), the shaking stops,
;@ Link can move, jingle 2, and the entity is removed. Otherwise: rumble again for $30 frames (state 1).
;@ test: skip writes the background draw queue
FaceKeyEventDrawBottom::
;> step = wEntityPrivate1[slot]
	push bc
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> p = FaceKeyBottomRows + (step * 2 & 6)
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, FaceKeyBottomRows
	add hl, de
;> src = mem[p] | (mem[p + 1] << 8)
	ld a, [hli]
	ld d, [hl]
	ld e, a
;> dst = wDrawCommand
	ld c, $34
	ld hl, wDrawCommand
;> for _ in range(0x34):
.copy
;>     v = mem[src]
	ld a, [de]
;>     if v == 0x98 and hBaseScrollY:
	cp $98
	jr nz, .store
	ldh a, [hBaseScrollY]
	and a
	ld a, $98
	jr z, .store
;>         v = 0x9A
	ld a, $9a
.store
;>     src += 1
	inc de
;>     mem[dst] = v
;>     dst += 1
	ld [hli], a
	dec c
	jr nz, .copy
;> mem[dst] = 0                             # end of the list
	ld [hl], $00
	pop bc
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivate1[slot] == 4:
	cp $04
	jr nz, .again
;>     wRoomObjects[0x01:0x03] = [0xB3, 0xB3]
	ld hl, wRoomObjects + $01
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
;>     wRoomObjects[0x03:0x06] = [0xB3, 0xB3, 0xB3]
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
;>     wRoomObjects[0x11:0x13] = [0xB3, 0xB3]
	ld hl, wRoomObjects + $11
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
;>     wRoomObjects[0x13:0x16] = [0xB3, 0xB3, 0xB3]
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
;>     wRoomObjects[0x21:0x23] = [0xAD, 0xB1]
	ld hl, wRoomObjects + $21
	ld a, $ad
	ld [hli], a
	ld a, $b1
	ld [hli], a
;>     wRoomObjects[0x23:0x26] = [0xE7, 0xAD, 0xB1]
	ld a, $e7
	ld [hli], a
	ld a, $ad
	ld [hli], a
	ld a, $b1
	ld [hli], a
;>     wRoomObjects[0x31:0x33] = [0xAE, 0xB2]
	ld hl, wRoomObjects + $31
	ld a, $ae
	ld [hli], a
	ld a, $b2
	ld [hli], a
;>     wRoomObjects[0x33:0x36] = [0xE3, 0xAE, 0xB2]
	ld a, $e3
	ld [hli], a
	ld a, $ae
	ld [hli], a
	ld a, $b2
	ld [hli], a
;>     MarkRoomEventDone_19()
	call MarkRoomEventDone_19
;>     wRoomStatus[hMapRoom] |= 0x10        # hl still points at the room's status byte
	set 4, [hl]
;>     wScreenShakeX = 0
	xor a
	ld [wScreenShakeX], a
;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     hJingle = 2
	ld a, $02
	ldh [hJingle], a
;>     return ClearEntityStatus_19(slot)
	jp ClearEntityStatus_19
.again
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> return
	ret


;@ path: event/keyhole
;@ X positions where the dust clouds of the Face Key scene rise (one picked at random): $18, $58, $28, $48, $38,
;@ $20, $50, $40.
FaceKeyDustX::
	db $18, $58, $28, $48, $38, $20, $50, $40

;@ def SpawnFaceKeyDust(slot: bc)
;@ path: event/keyhole
;@ Every 4 frames: a dust cloud (entity $A7 with wEntityPrivate1 = 1, the pillar's dust puff) at a random x of
;@ FaceKeyDustX and a random y $47-$4E, timer $10.
;@ test: skip uses random numbers
SpawnFaceKeyDust::
;> if hFrameCounter & 3: return
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;> new, failed = SpawnEntity(slot, 0xA7)
	ld a, $a7
	call SpawnEntity
;> if failed: return
	jr c, .done
;> i = GetRandomByte() & 7
	push bc
	call GetRandomByte
	and $07
	ld c, a
;> wEntityX[new] = mem[FaceKeyDustX + i]
	ld hl, FaceKeyDustX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[new] = (GetRandomByte() & 7) + 0x47
	call GetRandomByte
	and $07
	add $47
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPhysicsFlags[new] = 0xC2
	pop bc
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;> wEntityTimer[new] = 0x10
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $10
;> wEntityPrivate1[new] = 1                 # dust puff
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
.done
;> return
	ret


;@ path: enemy/mimic
;@ Sprites of the Mimic (entity $28), for DrawEntity16x16: 8 variants of two OAM entries (tile, attributes).
;@ 0 / 1 facing down (tiles $60 $62, the second frame mirrored), 2 / 3 facing up ($64 $66 the same way), 4 / 5
;@ facing left ($68 $6A / $6C $6E), 6 / 7 facing right (the same tiles mirrored).
MimicSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
;@ path: enemy/mimic
;@ The Mimic's speeds against Link's d-pad: -16, 16. MimicHandler reads it from one byte before (the last byte of
;@ MimicSprites, $20) with index 1 = this first byte; index 3 (both directions on an axis held) reads the
;@ following code byte ($21).
MimicSpeeds::
	db $f0, $10

;@ def MimicHandler(slot: bc)
;@ path: enemy/mimic
;@ Entity $28, the Mimic: it copies Link's movements in reverse - while Link holds right it walks left at speed
;@ 16 and so on (left / right take priority over up / down), and it stops when Link is blocked or lets go. It
;@ can only be hurt like other enemies (EntityCheckHits). It is not drawn in rooms $97 / $98 of map $0A while a
;@ trade scene is running (wTradeSceneState). Spawned by a keyhole (wEntityPrivate2 set) it plays the key's
;@ scene instead (KeyholeEvent).
;@ test: skip draws sprites and calls routines in other banks
MimicHandler::
;> if wEntityPrivate2[slot]: return KeyholeEvent(slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jp nz, KeyholeEvent
;> hidden = False
;> if hMapId == 0x0A:
	ldh a, [hMapId]
	cp $0a
	jr nz, .draw
;>     room = hMapRoom
	ldh a, [hMapRoom]
;>     if room == 0x97 or room == 0x98:
	cp $97
	jr z, .scene
	cp $98
	jr nz, .draw
.scene
;>         hidden = wTradeSceneState != 0
	ld a, [wTradeSceneState]
	and a
	jr nz, .act
.draw
;> if not hidden: DrawEntity16x16(slot, MimicSprites)
	ld de, MimicSprites
	call DrawEntity16x16
.act
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> ApplyRecoilIfNeeded_19(slot)
	call ApplyRecoilIfNeeded_19
;> EntityCheckHits(slot)
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wLinkCollisionFlags: return ClearEntitySpeed(slot)   # Link is blocked
	ld a, [wLinkCollisionFlags]
	and a
	jr nz, .stop
;> h = hJoypadHeld & 3
	ldh a, [hJoypadHeld]
	and $03
;> if h:
	jr z, .vertical
;>     v = mem[MimicSpeeds - 1 + h]          # right -> -16, left -> 16
	ld e, a
	ld d, b
	ld hl, MimicSpeeds - 1
	add hl, de
	ld a, [hl]
;>     wEntitySpeedX[slot] = v
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;>     base = (h & 2) + 4                     # 4 facing left, 6 facing right
	ld a, e
	and $02
	add $04
	ld e, a
;>     flap = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;>     return SetEntitySpriteVariant(slot, base + flap)
	add e
	jp SetEntitySpriteVariant
.vertical
;> if not hJoypadHeld & 0x0F: return ClearEntitySpeed(slot)
	ldh a, [hJoypadHeld]
	and $0f
	jr z, .stop
;> i = ~(hJoypadHeld >> 2) & 3             # up -> 2, down -> 1, both -> 0
	rra
	rra
	cpl
	and $03
;> v = mem[MimicSpeeds - 1 + i]             # up -> 16, down -> -16
	ld e, a
	ld d, b
	ld hl, MimicSpeeds - 1
	add hl, de
	ld a, [hl]
;> wEntitySpeedY[slot] = v
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
;> j = (i - 1) ^ 1                          # 0 up held, 1 down held, -2 both
	ld a, e
	dec a
	xor $01
;> base = {0: 0, 1: 2, -2: 0xFD}[j]          # 0 facing down, 2 facing up
	sra a
	rla
	rla
	ld e, a
;> flap = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> return SetEntitySpriteVariant(slot, base + flap)
	add e
	jp SetEntitySpriteVariant
.stop
;> return ClearEntitySpeed(slot)
	jp ClearEntitySpeed


;@ path: enemy/cheep_cheep
;@ Sprites of the Cheep Cheeps (entities $AA-$AC), for DrawEntity16x16: 4 variants of two OAM entries (tile,
;@ attributes). 0 / 1 swimming right (tiles $60 $62 / $64 $66), 2 / 3 swimming left (the same tiles mirrored).
CheepCheepSprites::
	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $20, $60, $20, $66, $20, $64, $20

;@ def CheepCheepHandler(slot: bc)
;@ path: enemy/cheep_cheep
;@ Entities $AA and $AB, the swimming Cheep Cheeps of the side-view underwater rooms: $AA swims back and forth
;@ sideways, $AB up and down (speed 8). They face their x direction and flap their fins every 8 frames; Link's
;@ weapons can hit them. States (CheepCheepStates): 0 start, 1 swim, 2 stop and turn.
;@ test: skip draws sprites and calls routines in other banks
CheepCheepHandler::
;> DrawEntity16x16(slot, CheepCheepSprites)
	ld de, CheepCheepSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> v = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> left = 2 if v & 0x80 else 0
	rlca
	rlca
	and $02
	ld e, a
;> flap = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, left | flap)
	or e
	call SetEntitySpriteVariant
;> EntityCheckHits(slot)
	call EntityCheckHits
;> return CheepCheepStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/cheep_cheep
;@ State routines of the swimming Cheep Cheeps: 0 start, 1 swim, 2 stop and turn.
CheepCheepStates::
	dw CheepCheepInit
	dw CheepCheepSwim
	dw CheepCheepTurn

;@ def CheepCheepInit(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 0: speed 8 to the right ($AA) or downwards ($AB), then the first swim.
;@ test: skip calls routines in other banks
CheepCheepInit::
;> speed = wEntitySpeedX if hActiveEntityType == 0xAA else wEntitySpeedY
	ld hl, wEntitySpeedX
	ldh a, [hActiveEntityType]
	cp $aa
	jr z, .set
	ld hl, wEntitySpeedY
.set
;> speed[slot] = 8
	add hl, bc
	ld [hl], $08
;> return CheepCheepStartSwim(slot)

;@ def CheepCheepStartSwim(slot: bc)
;@ path: enemy/cheep_cheep
;@ Starts a swim of $80 frames ($AA) or $60 frames ($AB) in state 1.
;@ test: skip calls routines in other banks
CheepCheepStartSwim::
;> t = 0x80 if hActiveEntityType == 0xAA else 0x60
	ld e, $80
	ldh a, [hActiveEntityType]
	cp $aa
	jr z, .timer
	ld e, $60
.timer
;> wEntityTimer[slot] = t
	call GetEntityTimer
	ld [hl], e
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> return
	ret


;@ def CheepCheepSwim(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 1: swims; when the timer runs out it stops for $28 frames (state 2).
;@ test: skip calls routines in other banks
CheepCheepSwim::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .move
;>     wEntityTimer[slot] = 0x28
	ld [hl], $28
;>     IncrementEntityState(slot)
	call IncrementEntityState
.move
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> return
	ret


;@ def CheepCheepTurn(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 2: waits in place, then turns round (both speeds negated) and swims again.
;@ test: skip calls routines in other banks
CheepCheepTurn::
;> if GetEntityTimer(slot): return
	call GetEntityTimer
	jr nz, .wait
;> wEntitySpeedX[slot] = u8(-wEntitySpeedX[slot])
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> wEntitySpeedY[slot] = u8(-wEntitySpeedY[slot])
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> return CheepCheepStartSwim(slot)
	jp CheepCheepStartSwim
.wait
;> return
	ret


;@ def JumpingCheepCheepHandler(slot: bc)
;@ path: enemy/cheep_cheep
;@ Entity $AC, the Cheep Cheep that leaps out of the water: it swims sideways below the surface (turning at
;@ random times), then jumps out with a splash, falls back and swims again. In state 5 it is drawn upside down
;@ and the fin animation and hit check are skipped. States (JumpingCheepCheepStates): 0 start, 1 new swim,
;@ 2 swim, 3 leap, 4 fall back in, 5 sink away upside down.
;@ test: skip draws sprites and calls routines in other banks
JumpingCheepCheepHandler::
;> if hActiveEntityState == 5: hActiveEntityFlipAttribute |= 0x40    # upside down
	ldh a, [hActiveEntityState]
	cp $05
	jr nz, .draw
	ldh a, [hActiveEntityFlipAttribute]
	or $40
	ldh [hActiveEntityFlipAttribute], a
.draw
;> DrawEntity16x16(slot, CheepCheepSprites)
	ld de, CheepCheepSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> v = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> left = 2 if v & 0x80 else 0
	rlca
	rlca
	and $02
	ld e, a
;> ApplyRecoilIfNeeded_19(slot)
	call ApplyRecoilIfNeeded_19
;> if hActiveEntityState == 5: return RunJumpingCheepCheepState(slot)
	ldh a, [hActiveEntityState]
	cp $05
	jr z, RunJumpingCheepCheepState
;> flap = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, left | flap)
	or e
	call SetEntitySpriteVariant
;> RunJumpingCheepCheepState(slot)
	call RunJumpingCheepCheepState
;> EntityCheckHits(slot)
	call EntityCheckHits
;> return
	ret


;@ def RunJumpingCheepCheepState(slot: bc)
;@ path: enemy/cheep_cheep
;@ Runs the jumping Cheep Cheep's current state routine.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $19
RunJumpingCheepCheepState::
;> return JumpingCheepCheepStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/cheep_cheep
;@ State routines of the jumping Cheep Cheep: 0 start, 1 new swim, 2 swim, 3 leap, 4 fall back in, 5 sink away.
JumpingCheepCheepStates::
	dw JumpingCheepCheepInit
	dw JumpingCheepCheepStartSwim
	dw JumpingCheepCheepSwim
	dw JumpingCheepCheepLeap
	dw JumpingCheepCheepFall
	dw JumpingCheepCheepDefeated

;@ def JumpingCheepCheepInit(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 0: wEntityDyingTimer = 3, and its starting y is kept in wEntityPrivate1 (the depth it returns to).
;@ test: skip calls routines in other banks
JumpingCheepCheepInit::
;> wEntityDyingTimer[slot] = 3
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $03
;> wEntityPrivate1[slot] = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def JumpingCheepCheepStartSwim(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 1: swims for $30-$AF frames, left or right at speed 12 (random).
;@ test: skip uses random numbers
JumpingCheepCheepStartSwim::
;> wEntityTimer[slot] = (GetRandomByte() & 0x7F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $7f
	add $30
	ld [hl], a
;> s = 0x0C if GetRandomByte() & 1 else 0xF4
	call GetRandomByte
	ld e, $f4
	and $01
	jr z, .speed
	ld e, $0c
.speed
;> wEntitySpeedX[slot] = s
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def JumpingCheepCheepSwim(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 2: swims and turns round whenever wEntityTimer1 runs out (again after $10-$3F frames). When the swim
;@ is over it leaps: upward speed -44, a splash 8 pixels above it, jingle $24, state 3.
;@ test: skip uses random numbers
JumpingCheepCheepSwim::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .swim
;>     wEntitySpeedY[slot] = 0xD4
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $d4
;>     SpawnWaterSplash(u8(hActiveEntityDrawY - 8))
	ldh a, [hActiveEntityDrawY]
	sub $08
	call SpawnWaterSplash
;>     hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
;>     return IncrementEntityState(slot)
	jp IncrementEntityState
.swim
;> if not GetEntityTimer1(slot):
	call GetEntityTimer1
	jr nz, .move
;>     wEntityTimer1[slot] = (GetRandomByte() & 0x3F) | 0x10
	call GetRandomByte
	and $3f
	or $10
	ld [hl], a
;>     wEntitySpeedX[slot] = u8(-wEntitySpeedX[slot])
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.move
;> AddEntitySpeedToPos_19(slot)
	call AddEntitySpeedToPos_19
;> return EntityCheckWalls(slot)
	jp EntityCheckWalls


;@ def JumpingCheepCheepLeap(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 3: flies up and comes down (gravity 1 per frame); once the falling speed reaches $18, state 4.
;@ test: skip calls routines in other banks
JumpingCheepCheepLeap::
;> if GetEntityTimer(slot): return
	call GetEntityTimer
	jr nz, .done
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> JumpingCheepCheepCheckWalls(slot)
	call JumpingCheepCheepCheckWalls
;> wEntitySpeedY[slot] += 1
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> if wEntitySpeedY[slot] == 0x18: IncrementEntityState(slot)
	ld a, [hl]
	cp $18
	jr nz, .done
	call IncrementEntityState
.done
;> return
	ret


;@ def JumpingCheepCheepFall(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 4: falls at speed $18 until it is below its starting depth (wEntityPrivate1), then swims again
;@ (state 1).
;@ test: skip calls routines in other banks
JumpingCheepCheepFall::
;> depth = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if depth < wEntityY[slot]:
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jr nc, .fall
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     return
	ret
.fall
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> return JumpingCheepCheepCheckWalls(slot)

;@ def JumpingCheepCheepCheckWalls(slot: bc)
;@ path: enemy/cheep_cheep
;@ EntityCheckWalls with bit 0 of the entity's wEntityOptions1 set for the duration of the check.
;@ test: skip calls routines in other banks
JumpingCheepCheepCheckWalls::
;> wEntityOptions1[slot] |= 0x01
	ld hl, wEntityOptions1
	add hl, bc
	set 0, [hl]
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> wEntityOptions1[slot] &= ~0x01
	ld hl, wEntityOptions1
	add hl, bc
	res 0, [hl]
;> return
	ret


;@ def JumpingCheepCheepDefeated(slot: bc)
;@ path: enemy/cheep_cheep
;@ State 5 (no code here sets it): drawn upside down, physics flags bits 7 and 6 set, it falls with gravity 1
;@ (speed 6 while wEntityGroundStatus is set); walls are checked while it is above drawn y $70, and it is
;@ removed below $88.
;@ test: skip calls routines in other banks
JumpingCheepCheepDefeated::
;> wEntityPhysicsFlags[slot] |= 0xC0
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 7, [hl]
	set 6, [hl]
;> wEntitySpeedY[slot] += 1
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> ground = wEntityGroundStatus[slot]
	push hl
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	pop hl
;> if ground: wEntitySpeedY[slot] = 6
	and a
	jr z, .move
	ld [hl], $06
.move
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> if hActiveEntityDrawY < 0x70: return JumpingCheepCheepCheckWalls(slot)
	ldh a, [hActiveEntityDrawY]
	cp $70
	jr c, JumpingCheepCheepCheckWalls
;> if hActiveEntityDrawY >= 0x88: return ClearEntityStatus_19(slot)
	cp $88
	jp nc, ClearEntityStatus_19
;> return
	ret


;@ def UnusedSplashAtEntityY()
;@ path: unused/entity
;@ A second entry in front of SpawnWaterSplash that nothing calls: a splash at the entity's drawn y.
UnusedSplashAtEntityY::
;> return SpawnWaterSplash(hActiveEntityDrawY)
	ldh a, [hActiveEntityDrawY]

;@ def SpawnWaterSplash(y: a)
;@ path: enemy/cheep_cheep
;@ A splash (transient effect 1) at y and the entity's x, with jingle $0E.
;@ test: skip calls routines in other banks
SpawnWaterSplash::
;> hMultiPurpose1 = y
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
;> return
	ret


;@ path: npc/sale
;@ Sprite of the bananas Sale throws up into the air, for DrawEntity16x16: one variant of two OAM entries
;@ (tile, attributes): tiles $9A and $9C with palette bit $10.
SaleBananaSprite::
	db $9a, $10, $9c, $10

;@ def SaleBanana(slot: bc)
;@ path: npc/sale
;@ The bananas thrown by Sale (entity $CD with wEntityPrivate1 set): they fly up and fall with gravity 1 and
;@ disappear when they drop below the floor.
;@ test: skip draws sprites and calls routines in other banks
SaleBanana::
;> DrawEntity16x16(slot, SaleBananaSprite)
	ld de, SaleBananaSprite
	call DrawEntity16x16
;> AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;> wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 1)
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80: return ClearEntityStatus_19(slot)
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, ClearEntityStatus_19
;> return
	ret


;@ def SaleHandler(slot: bc)
;@ path: npc/sale
;@ Sale, the alligator in his house (indoor room $FE), who swaps bananas for dog food: Link hands over the dog
;@ food, Sale throws bananas into the air, gobbles up the food and Link gets the bananas (trade item 4).
;@ States (SaleStates): 0 wait for Link, 1 answer to the offer, 2 throw the bananas, 3 eat.
;@ test: skip draws sprites and calls routines in other banks
SaleHandler::
;> if wEntityPrivate1[slot]: return SaleBanana(slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, SaleBanana
;> DrawSale(slot)
	call DrawSale
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> return SaleStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/sale
;@ State routines of Sale: 0 wait for Link, 1 answer to the offer, 2 throw the bananas, 3 eat.
SaleStates::
	dw SaleWaitForTalk
	dw SaleTradeAnswer
	dw SaleThrowBananas
	dw SaleEatDogFood

;@ def SaleWaitForTalk(slot: bc)
;@ path: npc/sale
;@ Sale state 0: he sways (variants 0 / 1, every 16 frames). Spoken to he says dialog $CD of table 1 once the
;@ trade is done (room event bit 5), $CC when bit 5 of wRoomStatus + $2FE is set, $C6 when Link has no dog
;@ food (trade item 3); with the dog food he asks for it (dialog $C7) and waits for the answer (state 1).
;@ test: skip calls routines in other banks
SaleWaitForTalk::
;> if ShouldLinkTalkToEntity_19(slot):
	call ShouldLinkTalkToEntity_19
	jr nc, .sway
;>     if hRoomStatus & 0x20: d = 0xCD
	ld e, $cd
	ldh a, [hRoomStatus]
	and $20
	jr nz, .open
;>     elif wRoomStatus[0x2FE] & 0x20: d = 0xCC
	ld e, $cc
	ld a, [wRoomStatus + $2FE]
	and $20
	jr nz, .open
;>     elif wTradeSequenceItem != 3: d = 0xC6
	ld e, $c6
	ld a, [wTradeSequenceItem]
	cp $03
	jr nz, .open
;>     else:
;>         OpenDialogTable1(0xC7)
	ld a, $c7
	call OpenDialogTable1
;>         return IncrementEntityState(slot)
	jp IncrementEntityState
.open
;>     OpenDialogTable1(d)
	ld a, e
	call OpenDialogTable1
.sway
;> f = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
;> return
	ret


;@ def SaleTradeAnswer(slot: bc)
;@ path: npc/sale
;@ Sale state 1: after the question, "no" gets dialog $C9 of table 1 and state 0; "yes" gets dialog $C8 and
;@ state 2.
;@ test: skip calls routines in other banks
SaleTradeAnswer::
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> IncrementEntityState(slot)
	call IncrementEntityState
;> if wDialogAnswer:
	ld a, [wDialogAnswer]
	and a
	jr z, .yes
;>     wEntityState[slot] = 0
	ld [hl], b
;>     return OpenDialogTable1(0xC9)
	ld a, $c9
	jp OpenDialogTable1
.yes
;> OpenDialogTable1(0xC8)
	ld a, $c8
	call OpenDialogTable1
.done
;> return
	ret


;@ def SaleThrowBananas(slot: bc)
;@ path: npc/sale
;@ Sale state 2: when the dialog is closed he throws bananas up (a new entity $CD with wEntityPrivate1 = 1, 2
;@ pixels left of him, upward speed $20, physics flags $C2), jingle $24, and starts eating ($C0 frames).
;@ test: skip calls routines in other banks
SaleThrowBananas::
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	jr nz, .done
;> new, _ = SpawnEntity(slot, 0xCD)
	ld a, $cd
	call SpawnEntity
;> wEntityX[new] = u8(hMultiPurpose0 - 2)
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	sub $02
	ld [hl], a
;> wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPrivate1[new] = 1                 # bananas
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntitySpeedZ[new] = 0x20
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
;> wEntityPhysicsFlags[new] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;> hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> IncrementEntityState(slot)
	call IncrementEntityState
.done
;> return
	ret


;@ path: npc/sale
;@ Sale's chewing animation (sprite variants), one per step of (hFrameCounter >> 3) & 3: 0, 1, 2, 1.
SaleChewFrames::
	db $00, $01, $02, $01

;@ def SaleEatDogFood(slot: bc)
;@ path: npc/sale
;@ Sale state 3 (Link frozen): for the first $40 frames he holds his mouth open (variant 3), then chews; at
;@ timer 8 he says dialog $CA of table 1. At the end Link gets the bananas: trade item 4, BG change request $0D,
;@ the item is shown in his hands, and Sale is back in state 0.
;@ test: skip calls routines in other banks
SaleEatDogFood::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .eating
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     wTradeSequenceItem = 4                # the bananas
	ld a, $04
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret
.eating
;> if t >= 0x80: return SetEntitySpriteVariant(slot, 3)
	cp $80
	jr c, .chew
	ld a, $03
	jp SetEntitySpriteVariant
.chew
;> if t == 8:
	cp $08
	jr nz, .animate
;>     wEntityTimer[slot] = 7
	dec [hl]
;>     OpenDialogTable1(0xCA)
	ld a, $ca
	call OpenDialogTable1
.animate
;> i = (hFrameCounter >> 3) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
;> SetEntitySpriteVariant(slot, mem[SaleChewFrames + i])
	ld d, b
	ld hl, SaleChewFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> return
	ret


;@ path: npc/sale
;@ Sale's sprites, for DrawEntitySprites: 4 variants of 32 bytes, each 7 OAM entries (y offset, x offset, tile,
;@ attributes; an entry of $FF bytes is unused) plus 4 unused $FF bytes. A 24x32 alligator: 0 tiles $50 $52 $54
;@ over $56 $58 $5A; 1 $50 $52 $5C over $56 $58 $5E, and $60 at x +$18; 2 $62 $64 $66 over $68 $58 $5E $60;
;@ 3 $6A $6C $6E over $68 $58 $5E $60 (mouth open).
SaleSprites::
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $54, $00, $10, $00, $56, $00
	db $10, $08, $58, $00, $10, $10, $5a, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $5c, $00, $10, $00, $56, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $18, $60, $00, $ff, $ff, $ff, $ff
	db $00, $00, $62, $00, $00, $08, $64, $00, $00, $10, $66, $00, $10, $00, $68, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $10, $60, $00, $ff, $ff, $ff, $ff
	db $00, $00, $6a, $00, $00, $08, $6c, $00, $00, $10, $6e, $00, $10, $00, $68, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $10, $60, $00, $ff, $ff, $ff, $ff
;@ path: npc/sale
;@ The pile of bananas in Sale's house, for DrawEntitySprites: 8 OAM entries (y offset, x offset, tile,
;@ attributes), four bunches of tiles $74 $76 in a 32x32 square. The last two entries (the top-left bunch) are
;@ left out once Link has the bananas.
BananaPileSprites::
	db $10, $00, $74, $00, $10, $08, $76, $00, $10, $10, $74, $00, $10, $18, $76, $00
	db $00, $10, $74, $00, $00, $18, $76, $00, $00, $00, $74, $00, $00, $08, $76, $00

;@ def DrawSale(slot: bc)
;@ path: npc/sale
;@ Draws Sale (7 entries of his variant, 3 pixels to the right) and the banana pile at x $78, drawn y $5C (8
;@ entries, 6 when Link has the bananas).
;@ test: skip draws sprites
DrawSale::
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> offset = (v << 5) & 0xE0
	rla
	rla
	rla
	rla
	rla
	and $e0
;> sprites = SaleSprites + offset
	ld e, a
	ld d, b
	ld hl, SaleSprites
	add hl, de
;> hActiveEntityX = u8(hActiveEntityX + 3)
	ldh a, [hActiveEntityX]
	add $03
	ldh [hActiveEntityX], a
;> DrawEntitySprites(sprites, 7)
	ld c, $07
	call DrawEntitySprites
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> hActiveEntityX = 0x78
	ld a, $78
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = 0x5C
	ld a, $5c
	ldh [hActiveEntityDrawY], a
;> n = 8
	ld hl, BananaPileSprites
	ld c, $08
;> if wTradeSequenceItem == 4: n = 6
	ld a, [wTradeSequenceItem]
	cp $04
	jr nz, .pile
	dec c
	dec c
.pile
;> DrawEntitySprites(BananaPileSprites, n)
	call DrawEntitySprites
;> ReserveOAMEntriesFar(3)
	ld a, $03
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> return
	ret


;@ path: npc/sale
;@ What entity $CD looks like outdoors, for DrawEntitySprites: 3 OAM entries (y offset, x offset, tile,
;@ attributes) in a row at y +8 - tiles $70, $72 and $70 mirrored.
SaleOutdoorSprites::
	db $08, $04, $70, $00, $08, $0c, $72, $00, $08, $14, $70, $20

;@ def BananasSchuleSaleHandler(slot: bc)
;@ path: npc/sale
;@ Entity $CD. Outdoors it is only a picture (SaleOutdoorSprites, physics flags $C3). Indoors in room $FE it
;@ is Sale (SaleHandler); elsewhere it is Schule Donavitch, the painter, at his easel - or, left of x $30, the
;@ hippo he paints (SchuleHippo). On its first frame Schule moves to y $48 and 4 pixels left and places the
;@ hippo (a second entity $CD at $28, $28 with wEntityPrivate1 = 1 and timer $40). Standing at the picture
;@ (x $68, y $50) facing up and pressing A shows it on its own screen (game mode 8). States (SchuleStates):
;@ 0 first frame, 1 wait for Link, 2 talk.
;@ test: skip draws sprites and calls routines in other banks
BananasSchuleSaleHandler::
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr nz, .indoor
;>     wEntityPhysicsFlags[slot] = 0xC3
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c3
;>     return DrawEntitySprites(SaleOutdoorSprites, 3)
	ld hl, SaleOutdoorSprites
	ld c, $03
	jp DrawEntitySprites
.indoor
;> if hMapRoom == 0xFE: return SaleHandler(slot)
	ldh a, [hMapRoom]
	cp $fe
	jp z, SaleHandler
;> if hActiveEntityX < 0x30: return SchuleHippo(slot)
	ldh a, [hActiveEntityX]
	cp $30
	jp c, SchuleHippo
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .run
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wEntityY[slot] = 0x48
	ld hl, wEntityY
	add hl, bc
	ld [hl], $48
;>     wEntityX[slot] -= 4
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
;>     new, _ = SpawnEntity(slot, 0xCD)            # the hippo
	ld a, $cd
	call SpawnEntity
;>     wEntityX[new] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;>     wEntityY[new] = 0x28
	ld hl, wEntityY
	add hl, de
	ld [hl], $28
;>     wEntityPrivate1[new] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>     wEntityTimer[new] = 0x40
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
.run
;> DrawSchule(slot)
	call DrawSchule
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> return SchuleStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/schule
;@ State routines of Schule Donavitch: 0 first frame (nothing), 1 wait for Link, 2 talk.
SchuleStates::
	dw SchuleIdle
	dw SchuleWaitForTalk
	dw SchuleTalking

;@ def SchuleIdle(slot: bc)
;@ path: npc/schule
;@ State 0: nothing (the handler has just set things up).
;@ test: slot = rand(0, 15)
SchuleIdle::
;> return
	ret


;@ def SchuleWaitForTalk(slot: bc)
;@ path: npc/schule
;@ State 1: Schule paints (variants 0 / 1, switching every 32 frames). Spoken to he says dialog $D8 of table 0
;@ if Link holds the magnifying lens (trade item $0E), otherwise $9B of table 1 (bit 7 of wDialogState set),
;@ and talks (state 2).
;@ test: skip calls routines in other banks
SchuleWaitForTalk::
;> if GetEntityDropTimer(slot): return
	call GetEntityDropTimer
	ret nz
;> if ShouldLinkTalkToEntity_19(slot):
	call ShouldLinkTalkToEntity_19
	jr nc, .paint
;>     if wTradeSequenceItem == 0x0E:
	ld a, [wTradeSequenceItem]
	cp $0e
	jr nz, .normal
;>         OpenDialog(0xD8)
	ld a, $d8
	call OpenDialog
	jr .talk
.normal
;>     else:
;>         OpenDialogTable1(0x9B)
	ld a, $9b
	call OpenDialogTable1
.talk
;>     wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
;>     IncrementEntityState(slot)
	call IncrementEntityState
.paint
;> v = 1 if hFrameCounter & 0x20 else 0
	ldh a, [hFrameCounter]
	ld e, $00
	and $20
	jr z, .variant
	inc e
.variant
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
;> return
	ret


;@ def SchuleTalking(slot: bc)
;@ path: npc/schule
;@ State 2: Schule faces Link (variant 2 when Link is to the right, 3 to the left) until the dialog is closed,
;@ then state 1.
;@ test: skip calls routines in other banks
SchuleTalking::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .face
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
.face
;> dx, side = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> SetEntitySpriteVariant(slot, side + 2)
	ld a, e
	add $02
	call SetEntitySpriteVariant
;> return
	ret


;@ path: npc/schule
;@ Schule's sprites, for DrawEntitySprites: 4 variants of 5 OAM entries (y offset, x offset, tile, attributes).
;@ 0 painting: $5A $5C $5E over $60 $62; 1 the same mirrored ($20); 2 facing right: $50 (at x +$10), $54 $52
;@ over $58 $56, mirrored; 3 facing left: $50 (at x -8), $52 $54 over $56 $58.
SchuleSprites::
	db $f8, $f8, $5a, $00, $f8, $00, $5c, $00, $f8, $08, $5e, $00, $08, $00, $60, $00
	db $08, $08, $62, $00
	db $f8, $10, $5a, $20, $f8, $00, $5e, $20, $f8, $08, $5c, $20, $08, $00, $62, $20
	db $08, $08, $60, $20
	db $00, $10, $50, $20, $f8, $00, $54, $20, $f8, $08, $52, $20, $08, $00, $58, $20
	db $08, $08, $56, $20
	db $00, $f8, $50, $00, $f8, $00, $52, $00, $f8, $08, $54, $00, $08, $00, $56, $00
	db $08, $08, $58, $00
;@ path: npc/schule
;@ Schule's easel, for DrawEntitySprites: 4 OAM entries (y offset, x offset, tile, attributes) - tile $76 over
;@ $78, each with a mirrored right half.
SchuleEaselSprites::
	db $f0, $00, $76, $00, $f0, $08, $76, $20, $00, $00, $78, $00, $00, $08, $78, $20

;@ def DrawSchule(slot: bc)
;@ path: npc/schule
;@ Draws Schule (his variant, 4 pixels right) and his easel 16 pixels further right, keeps Link out of him, and
;@ starts the picture screen (game mode 8) when Link stands at x $64-$6B, y $4C-$53 facing up and presses A
;@ (and the drop timer is 0; it is set to 8).
;@ test: skip draws sprites and changes the game mode
DrawSchule::
;> o4 = (hActiveEntitySpriteVariant << 2) & 0xFC
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
;> offset = o4 + ((o4 << 2) & 0xF0)          # variant * 20
	rla
	rla
	and $f0
	add e
	ld e, a
	ld d, b
;> sprites = SchuleSprites + offset
	ld hl, SchuleSprites
	add hl, de
;> hActiveEntityX = u8(hActiveEntityX + 4)
	ldh a, [hActiveEntityX]
	add $04
	ldh [hActiveEntityX], a
;> DrawEntitySprites(sprites, 5)
	ld c, $05
	call DrawEntitySprites
;> hActiveEntityX = u8(hActiveEntityX + 0x10)
	ldh a, [hActiveEntityX]
	add $10
	ldh [hActiveEntityX], a
;> DrawEntitySprites(SchuleEaselSprites, 4)
	ld hl, SchuleEaselSprites
	ld c, $04
	call DrawEntitySprites
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> if u8(hLinkX - 0x68 + 4) < 8:
	ldh a, [hLinkX]
	sub $68
	add $04
	cp $08
	jr nc, .done
;>     if u8(hLinkY - 0x50 + 4) < 8:
	ldh a, [hLinkY]
	sub $50
	add $04
	cp $08
	jr nc, .done
;>         if hLinkDirection == 2:
	ldh a, [hLinkDirection]
	cp $02
	jr nz, .done
;>             if CheckTalkButtonPressed_19():
	call CheckTalkButtonPressed_19
	jr nc, .done
;>                 if not GetEntityDropTimer(slot):
	call GetEntityDropTimer
	jr nz, .done
;>                     wGameplayType = 8      # the picture screen
	ld a, $08
	ld [wGameplayType], a
;>                     wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>                     wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>                     wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>                     wEntityDropTimer[slot] = 8
	call GetEntityDropTimer
	ld [hl], $08
.done
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> return
	ret


;@ def SchuleHippo(slot: bc)
;@ path: npc/schule
;@ The hippo posing for Schule (entity $CD left of x $30). While its timer runs it shows variant 0; otherwise it
;@ wiggles (two frames, every 8 frames) and turns towards Link when he is within 18 pixels. Spoken to it says
;@ dialog $FA of table 0, and on every second talk now and then $AF (1 in 64) or $FB (1 in 8 of the rest).
;@ test: skip uses random numbers
SchuleHippo::
;> if GetEntityTimer(slot): hActiveEntitySpriteVariant = 0
	call GetEntityTimer
	jr z, .draw
	ld a, $00
	ldh [hActiveEntitySpriteVariant], a
.draw
;> DrawHippo(slot)
	call DrawHippo
;> PushLinkOutOfEntity_19(slot)
	call PushLinkOutOfEntity_19
;> t = hFrameCounter >> 3
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
;> SetEntitySpriteVariant(slot, wEntityDirection[slot] + 1 + (t & 1))
	and $01
	inc a
	add [hl]
	call SetEntitySpriteVariant
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 0x13) < 0x26:
	add $13
	cp $26
	jr nc, .talk
;>     dx, side = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;>     if u8(dx + 0x13) < 0x26:
	add $13
	cp $26
	jr nc, .talk
;>         wEntityDirection[slot] = side * 2
	ld a, e
	sla a
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
.talk
;> if ShouldLinkTalkToEntity_19(slot):
	call ShouldLinkTalkToEntity_19
	jr nc, .done
;>     n = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] = u8(n + 1)
	inc [hl]
;>     if n & 1 and not GetRandomByte() & 0x3F: d = 0xAF
	and $01
	jr z, .usual
	ld e, $af
	call GetRandomByte
	and $3f
	jr z, .open
;>     elif n & 1 and not GetRandomByte() & 7: d = 0xFB
	ld e, $fb
	call GetRandomByte
	and $07
	jr z, .open
.usual
;>     else: d = 0xFA
	ld e, $fa
.open
;>     OpenDialog(d)
	ld a, e
	call OpenDialog
.done
;> return
	ret


;@ path: npc/schule
;@ The hippo's sprites, for DrawEntitySprites: 5 variants of 5 OAM entries (y offset, x offset, tile,
;@ attributes; $FF = unused). 0 sitting: $64 $66 over $68 $6A; 1 / 2 turned one way: $6C $6E over $72 $74 (1)
;@ or $7C $74 (2), with $70 (1) or $7A (2) at x -8; 3 / 4 the same mirrored, the extra tile at x +$10.
HippoSprites::
	db $f4, $00, $64, $00, $f4, $08, $66, $00, $04, $00, $68, $00, $04, $08, $6a, $00
	db $ff, $ff, $ff, $ff
	db $04, $f8, $70, $00, $f4, $00, $6c, $00, $f4, $08, $6e, $00, $04, $00, $72, $00
	db $04, $08, $74, $00
	db $04, $f8, $7a, $00, $f4, $00, $6c, $00, $f4, $08, $6e, $00, $04, $00, $7c, $00
	db $04, $08, $74, $00
	db $04, $10, $70, $20, $f4, $00, $6e, $20, $f4, $08, $6c, $20, $04, $00, $74, $20
	db $04, $08, $72, $20
	db $04, $10, $7a, $20, $f4, $00, $6e, $20, $f4, $08, $6c, $20, $04, $00, $74, $20
	db $04, $08, $7c, $20

;@ def DrawHippo(slot: bc)
;@ path: npc/schule
;@ Draws the 5 entries of the hippo's current variant.
;@ test: skip draws sprites
DrawHippo::
;> o4 = (hActiveEntitySpriteVariant << 2) & 0xFC
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
;> offset = o4 + ((o4 << 2) & 0xF0)          # variant * 20
	rla
	rla
	and $f0
	add e
	ld e, a
	ld d, b
;> DrawEntitySprites(HippoSprites + offset, 5)
	ld hl, HippoSprites
	add hl, de
	ld c, $05
	call DrawEntitySprites
;> return
	ret


;@ path: npc/seashell_mansion
;@ Target height of the Seashell Mansion's meter for each seashell count, indexed by wSeashells (BCD, $00-$28):
;@ 41 bytes. Counts 0-9: $00 $06 $0C $13 $19 $20 $26 $2C $33 $39; 10-19: $40 $43 ... $58 $5C (steps of 3,
;@ then 4); 20-28: $60. The six bytes after each decade (the non-BCD indices $x A-$x F) are 0.
SeashellMeterHeights::
	db $00, $06, $0c, $13, $19, $20, $26, $2c, $33, $39, $00, $00, $00, $00, $00, $00
	db $40, $43, $46, $49, $4c, $4f, $52, $55, $58, $5c, $00, $00, $00, $00, $00, $00
	db $60, $60, $60, $60, $60, $60, $60, $60, $60

;@ def SeashellMansionHandler(slot: bc)
;@ path: npc/seashell_mansion
;@ Entity $CF, the Seashell Mansion. wEntityPrivate1 picks the part: 1 the sword appearing (MansionSwordHandler),
;@ 2 a bonus seashell (MansionBonusShell), 0 the meter: Link walks behind the pillar at x $20-$37 (his sprite
;@ halves get the behind-background bit), and with at least one seashell the meter (DrawSeashellMeter) rises to
;@ SeashellMeterHeights[wSeashells] when Link steps in. States (SeashellMansionStates): 0 wait for Link,
;@ 1 wait until he lands, 2 fill the meter, 3 check for a reward, 4 the sword, 5 done, 6 bonus shell, 7 done.
;@ test: skip draws sprites and calls routines in other banks
SeashellMansionHandler::
;> part = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if part == 2: return MansionBonusShell(slot)
	cp $02
	jp z, MansionBonusShell
;> if part: return MansionSwordHandler(slot)
	and a
	jp nz, MansionSwordHandler
;> if 0x20 <= hLinkX < 0x38:
	ldh a, [hLinkX]
	cp $38
	jr nc, .meter
	cp $20
	jr c, .meter
;>     wLinkOAMAttrRight |= 0x80            # behind the pillar
	ld hl, wLinkOAMAttrRight
	set 7, [hl]
;>     if hLinkX >= 0x24: wLinkOAMAttrLeft |= 0x80
	cp $24
	jr c, .meter
	ld hl, wLinkOAMAttrLeft
	set 7, [hl]
.meter
;> if not wSeashells: return
	ld a, [wSeashells]
	and a
	ret z
;> hMultiPurposeG = mem[SeashellMeterHeights + wSeashells]   # the meter's target
	ld e, a
	ld d, b
	ld hl, SeashellMeterHeights
	add hl, de
	ld a, [hl]
	ldh [hMultiPurposeG], a
;> DrawSeashellMeter(slot)                  # (a = hRoomStatus & 0x10 is loaded but not used)
	ldh a, [hRoomStatus]
	and $10
	call DrawSeashellMeter
;> return SeashellMansionStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/seashell_mansion
;@ State routines of the Seashell Mansion's meter: 0 wait for Link, 1 wait until he lands, 2 fill the meter,
;@ 3 check for a reward, 4 the sword, 5 done, 6 bonus shell, 7 done.
SeashellMansionStates::
	dw MansionWaitForLink
	dw MansionWaitForLanding
	dw MansionFillMeter
	dw MansionCheckReward
	dw MansionSpawnSword
	dw MansionDone
	dw MansionSpawnBonusShell
	dw MansionBonusDone

;@ def MansionWaitForLink(slot: bc)
;@ path: npc/seashell_mansion
;@ State 0: when Link has walked in to x $3C he is stopped (speed, spin attack and dash) and the meter starts
;@ after $58 frames (state 1).
;@ test: skip calls routines in other banks
MansionWaitForLink::
;> if hLinkX < 0x3C: return
	ldh a, [hLinkX]
	cp $3c
	jr c, .done
;> StopLinkSpeed()
	call StopLinkSpeed
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> IncrementEntityState(slot)
	call IncrementEntityState
;> wEntityTimer[slot] = 0x58
	call GetEntityTimer
	ld [hl], $58
.done
;> return
	ret


;@ def MansionWaitForLanding(slot: bc)
;@ path: npc/seashell_mansion
;@ State 1: Link is frozen; once he is on the ground, state 2.
;@ test: skip calls routines in other banks
MansionWaitForLanding::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> if not wIsLinkInTheAir: return IncrementEntityState(slot)
	ld a, [wIsLinkInTheAir]
	and a
	jp z, IncrementEntityState
;> return
	ret


;@ def MansionFillMeter(slot: bc)
;@ path: npc/seashell_mansion
;@ State 2: after the timer the meter (height in wEntityPrivateCounter) rises: on every 4th frame, with a
;@ chance of 1 in 2, by a sixteenth of the remaining distance (at least 1), with wave sound 6. Once it is past
;@ the target it is set to the target and state 3 follows.
;@ test: skip uses random numbers
MansionFillMeter::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if GetEntityTimer(slot): return
	call GetEntityTimer
	ret nz
;> left = hMultiPurposeG - wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ldh a, [hMultiPurposeG]
	sub [hl]
;> if left < 0:
	jr nc, .rise
;>     wEntityPrivateCounter[slot] = hMultiPurposeG
	ldh a, [hMultiPurposeG]
	ld [hl], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     return
	ret
.rise
;> if not hFrameCounter & 3:
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;>     if not GetRandomByte() & 1:
	call GetRandomByte
	and $01
	jr nz, .done
;>         step = (left >> 4) & 0x0F
	ld a, e
	rra
	rra
	rra
	rra
	and $0f
;>         if not step: step = 1
	and a
	jr nz, .add
	ld a, $01
.add
;>         wEntityPrivateCounter[slot] += step
	add [hl]
	ld [hl], a
;>         hWaveSfx = 6
	ld a, $06
	ldh [hWaveSfx], a
.done
;> return
	ret


;@ def MansionCheckReward(slot: bc)
;@ path: npc/seashell_mansion
;@ State 3 (Link frozen): with 20 seashells or more the sword comes ($40 frames, state 4): the hidden passage
;@ opens (OpenMansionPassage), the meter is no longer drawn (wEntityPrivate2) and music $56 plays. With exactly
;@ 5 or 10 shells, if that bonus (bit 5 / bit 6 of the mansion's room status, wRoomStatus + $2E9) has not been
;@ given yet: jingle $23 and a bonus shell (state 6). Otherwise jingle $1D and state 5.
;@ test: skip calls routines in other banks
MansionCheckReward::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> if wSeashells < 0x20: return MansionCheckBonus(slot, wSeashells)
	ld a, [wSeashells]
	cp $20
	jr c, MansionCheckBonus
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> IncrementEntityState(slot)
	call IncrementEntityState
;> OpenMansionPassage()
	call OpenMansionPassage
;> wEntityPrivate2[slot] = 1                # the meter is no longer drawn
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $01
;> wMusicTrackToPlay = 0x56
	ld a, $56
	ld [wMusicTrackToPlay], a
;> return MansionReleaseLink(slot)

;@ def MansionReleaseLink(slot: bc)
;@ path: npc/seashell_mansion
;@ Link can move again; wEntityTimer1 = $3F (the sparkles at the top of the meter).
;@ test: skip calls routines in other banks
MansionReleaseLink::
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> wEntityTimer1[slot] = 0x3F
	call GetEntityTimer1
	ld [hl], $3f
;> return
	ret


;@ def MansionCheckBonus(slot: bc, shells: a)
;@ path: npc/seashell_mansion
;@ Fewer than 20 seashells: with exactly 5 or 10, if that bonus (bit 5 / bit 6 of the mansion's room status,
;@ wRoomStatus + $2E9) has not been given yet, jingle $23 and a bonus shell (state 6). Otherwise jingle $1D,
;@ state 5, and Link can move again.
;@ test: skip calls routines in other banks
MansionCheckBonus::
;> status = wRoomStatus + 0x2E9
	ld hl, wRoomStatus + $2E9
;> if shells == 0x05:
	cp $05
	jr nz, .ten
;>     if not mem[status] & 0x20:
	bit 5, [hl]
	jr nz, .nothing
;>         wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
;>         hJingle = 0x23
	ld a, $23
	ldh [hJingle], a
;>         return MansionReleaseLink(slot)
	jp MansionReleaseLink
.ten
;> elif shells == 0x10:
	cp $10
	jr nz, .nothing
;>     if not mem[status] & 0x40:
	bit 6, [hl]
	jr nz, .nothing
;>         wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
;>         hJingle = 0x23
	ld a, $23
	ldh [hJingle], a
;>         return MansionReleaseLink(slot)
	jp MansionReleaseLink
.nothing
;> hJingle = 0x1D
	ld a, $1d
	ldh [hJingle], a
;> wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> return
	ret


;@ def MansionSpawnSword(slot: bc)
;@ path: npc/seashell_mansion
;@ State 4 (Link frozen): jingle $23 at timer $3E; at 0 the sword's entity appears (a new $CF with
;@ wEntityPrivate1 = 1 at x $50, y $48, timer $4F) and state 5.
;@ test: skip calls routines in other banks
MansionSpawnSword::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0x3E: hJingle = 0x23
	cp $3e
	jr nz, .check
	ld hl, hJingle
	ld [hl], $23
.check
;> if t: return
	and a
	jr nz, .done
;> new, _ = SpawnEntity(slot, 0xCF)
	ld a, $cf
	call SpawnEntity
;> wEntityX[new] = 0x50
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
;> wEntityY[new] = 0x48
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
;> wEntityPrivate1[new] = 1                 # the sword
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntityTimer[new] = 0x4F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $4f
;> IncrementEntityState(slot)
	call IncrementEntityState
.done
;> return
	ret


;@ def MansionDone(slot: bc)
;@ path: npc/seashell_mansion
;@ State 5: nothing more to do.
;@ test: slot = rand(0, 15)
MansionDone::
;> return
	ret


;@ def MansionSpawnBonusShell(slot: bc)
;@ path: npc/seashell_mansion
;@ State 6: when wEntityTimer1 has run out, a bonus seashell (a new $CF with wEntityPrivate1 = 2 at x $50, y $48,
;@ timer $14) and a bomb (entity $02, timer $20) at the same place appear; state 7.
;@ test: skip calls routines in other banks
MansionSpawnBonusShell::
;> if GetEntityTimer1(slot): return
	call GetEntityTimer1
	jr nz, .done
;> IncrementEntityState(slot)
	call IncrementEntityState
;> new, _ = SpawnEntity(slot, 0xCF)
	ld a, $cf
	call SpawnEntity
;> wEntityX[new] = 0x50
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
;> wEntityY[new] = 0x48
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
;> wEntityPrivate1[new] = 2                 # the bonus seashell
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;> wEntityTimer[new] = 0x14
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $14
;> bomb, _ = SpawnEntity(slot, 0x02)
	ld a, $02
	call SpawnEntity
;> wEntityX[bomb] = 0x50
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
;> wEntityY[bomb] = 0x48
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
;> wEntityTimer[bomb] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
.done
;> return
	ret


;@ def MansionBonusDone(slot: bc)
;@ path: npc/seashell_mansion
;@ State 7: nothing more to do.
;@ test: slot = rand(0, 15)
MansionBonusDone::
;> return
	ret


;@ path: npc/seashell_mansion
;@ One 16x16 piece of the Seashell Mansion's meter, for DrawEntity16x16: two OAM entries (tile, attributes) -
;@ tile $50 and the same mirrored.
MansionMeterSprite::
	db $50, $00, $50, $20

;@ path: npc/seashell_mansion
;@ Sparkles, for DrawEntity16x16: 4 variants of two OAM entries (tile, attributes). 0 tile $3C, 1 tile $3A
;@ (each with a mirrored right half), 2 tile $1E with the right half flipped both ways ($60), 3 the same in
;@ palette 1 ($10 / $70).
MansionSparkleSprites::
	db $3c, $00, $3c, $20, $3a, $00, $3a, $20, $1e, $00, $1e, $60, $1e, $10, $1e, $70

;@ def DrawSeashellMeter(slot: bc)
;@ path: npc/seashell_mansion
;@ Unless wEntityPrivate2 is set: draws the meter at x $88 as a column of MansionMeterSprite pieces from drawn y
;@ $80 - height (wEntityPrivateCounter) down to $80 (plus one at $80). While wEntityTimer1 runs, sparkles
;@ (variant (timer1 >> 3) & 3) flank its top at x $78 and $98.
;@ test: skip draws sprites
DrawSeashellMeter::
;> if not wEntityPrivate2[slot]:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .sparkles
;>     hActiveEntityX = 0x88
	ld a, $88
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY = 0x80
	ld a, $80
	ldh [hActiveEntityDrawY], a
;>     DrawEntity16x16(slot, MansionMeterSprite)
	ld de, MansionMeterSprite
	call DrawEntity16x16
;>     h = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld e, a
;>     hActiveEntityDrawY = u8(0x80 - h)     # top of the column
	ld a, $80
	sub e
	ldh [hActiveEntityDrawY], a
.piece
;>     while True:
;>         DrawEntity16x16(slot, MansionMeterSprite)
	ld de, MansionMeterSprite
	call DrawEntity16x16
;>         hActiveEntityDrawY = u8(hActiveEntityDrawY + 0x10)
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hActiveEntityDrawY], a
;>         if hActiveEntityDrawY >= 0x80: break
	cp $80
	jr c, .piece
.sparkles
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> if t:
	jr z, .done
;>     hActiveEntitySpriteVariant = (t >> 3) & 3
	rra
	rra
	rra
	and $03
	ldh [hActiveEntitySpriteVariant], a
;>     h = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld e, a
;>     hActiveEntityDrawY = u8(0x80 - h)
	ld a, $80
	sub e
	ldh [hActiveEntityDrawY], a
;>     hActiveEntityX = 0x78
	ld a, $78
	ldh [hActiveEntityX], a
;>     DrawEntity16x16(slot, MansionSparkleSprites)
	ld de, MansionSparkleSprites
	call DrawEntity16x16
;>     hActiveEntityX = 0x98
	ld a, $98
	ldh [hActiveEntityX], a
;>     DrawEntity16x16(slot, MansionSparkleSprites)
	ld de, MansionSparkleSprites
	call DrawEntity16x16
.done
;> return
	ret


;@ path: npc/seashell_mansion
;@ Light around the sword while it appears, for DrawEntitySprites: 4 frames of 12 OAM entries (y offset, x
;@ offset, tile, attributes), 48 bytes each; every entry is tile $7C, flipped in different ways (attributes $00,
;@ $20, $40, $60), spread over 80 pixels in height.
SwordGlowSprites::
	db $d8, $e8, $7c, $40, $d8, $f0, $7c, $20, $e8, $e8, $7c, $00, $e8, $f0, $7c, $60
	db $f8, $f8, $7c, $00, $f8, $00, $7c, $60, $08, $08, $7c, $00, $08, $10, $7c, $60
	db $18, $18, $7c, $00, $18, $20, $7c, $60, $28, $18, $7c, $40, $28, $20, $7c, $20
	db $d8, $f8, $7c, $00, $d8, $00, $7c, $60, $e8, $08, $7c, $00, $e8, $10, $7c, $60
	db $f8, $08, $7c, $40, $f8, $10, $7c, $20, $08, $f8, $7c, $40, $08, $00, $7c, $20
	db $18, $f8, $7c, $00, $18, $00, $7c, $60, $28, $08, $7c, $00, $28, $10, $7c, $60
	db $d8, $08, $7c, $40, $d8, $10, $7c, $20, $e8, $f8, $7c, $40, $e8, $00, $7c, $20
	db $f8, $f8, $7c, $00, $f8, $00, $7c, $60, $08, $08, $7c, $00, $08, $10, $7c, $60
	db $18, $08, $7c, $40, $18, $10, $7c, $20, $28, $f8, $7c, $40, $28, $00, $7c, $20
	db $d8, $18, $7c, $00, $d8, $20, $7c, $60, $e8, $18, $7c, $40, $e8, $20, $7c, $20
	db $f8, $08, $7c, $40, $f8, $10, $7c, $20, $08, $f8, $7c, $40, $08, $00, $7c, $20
	db $18, $e8, $7c, $40, $18, $f0, $7c, $20, $28, $e8, $7c, $00, $28, $f0, $7c, $60

;@ def MansionSwordHandler(slot: bc)
;@ path: npc/seashell_mansion
;@ The Seashell Mansion's reward (entity $CF with wEntityPrivate1 = 1): sparkles, a flashing light with the
;@ screen flickering, an emblem that shrinks into the sword, the sword falls and bounces, and when Link
;@ touches it he holds it up - sword level 2, full health, the seashells are used up. States
;@ (MansionSwordStates): 0 sparkle, 1 start the light, 2 light, 3 shrink, 4 fall, 5 wait for Link, 6 Link
;@ gets it, 7 wait for the dialog.
;@ test: skip draws sprites and calls routines in other banks
MansionSwordHandler::
;> return MansionSwordStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/seashell_mansion
;@ State routines of the Seashell Mansion's sword: 0 sparkle, 1 start the light, 2 light, 3 shrink, 4 fall,
;@ 5 wait for Link, 6 Link gets it, 7 wait for the dialog.
MansionSwordStates::
	dw MansionSwordSparkle
	dw MansionSwordGlowStart
	dw MansionSwordGlow
	dw MansionSwordShrink
	dw MansionSwordDrop
	dw MansionSwordWaitForLink
	dw MansionSwordGet
	dw MansionSwordShowOff

;@ def MansionSwordSparkle(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 0 (Link frozen): from timer $4F down to $30 a sparkle (MansionSparkleSprites, frame by the
;@ timer); after a pause the light starts ($A0 frames, state 1).
;@ test: skip draws sprites
MansionSwordSparkle::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t:
	jr z, .start
;>     if t < 0x30: return
	cp $30
	ret c
;>     hActiveEntitySpriteVariant = ((t - 0x30) >> 3) & 3
	sub $30
	rra
	rra
	rra
	and $03
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(slot, MansionSparkleSprites)
	ld de, MansionSparkleSprites
	call DrawEntity16x16
;>     return
	ret
.start
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def MansionSwordGlowStart(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 1 (Link frozen): the light; when the timer runs out, wave sound $1E and state 2 for $FF frames.
;@ test: skip draws sprites
MansionSwordGlowStart::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> if GetEntityTimer(slot): return DrawSwordGlow(slot)
	call GetEntityTimer
	jr nz, DrawSwordGlow
;> wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;> hWaveSfx = 0x1E
	ld a, $1e
	ldh [hWaveSfx], a
;> IncrementEntityState(slot)
	call IncrementEntityState
;> return DrawSwordGlow(slot)

;@ def DrawSwordGlow(slot: bc)
;@ path: npc/seashell_mansion
;@ The light: the background palette flickers between $E4 and $84 (every 4 frames of the timer); every 8 frames
;@ noise $33 and a random frame 0-3; the entity flashes (wEntityFlashTimer = hFrameCounter); draws the 12
;@ entries of SwordGlowSprites.
;@ test: skip draws sprites
DrawSwordGlow::
;> p = 0x84 if GetEntityTimer(slot) & 4 else 0xE4
	call GetEntityTimer
	and $04
	ld e, $e4
	jr z, .palette
	ld e, $84
.palette
;> wBGPalette = p
	ld a, e
	ld [wBGPalette], a
;> if not hFrameCounter & 7:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .flash
;>     hNoiseSfx = 0x33
	ld a, $33
	ldh [hNoiseSfx], a
;>     SetEntitySpriteVariant(slot, GetRandomByte() & 3)
	call GetRandomByte
	and $03
	call SetEntitySpriteVariant
.flash
;> wEntityFlashTimer[slot] = hFrameCounter
	ldh a, [hFrameCounter]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;> v16 = (hActiveEntitySpriteVariant << 4) & 0xF0
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;> offset = v16 + ((v16 << 1) & 0xE0)        # frame * 48
	ld e, a
	rla
	and $e0
	add e
	ld e, a
	ld d, b
;> DrawEntitySprites(SwordGlowSprites + offset, 12)
	ld hl, SwordGlowSprites
	add hl, de
	ld c, $0c
	call DrawEntitySprites
;> ReserveOAMEntriesFar(10)
	ld a, $0a
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: npc/seashell_mansion
;@ A glint where the sword will be, for DrawEntity16x16: two OAM entries (tile, attributes) - tile $7A and the
;@ same mirrored.
SwordAppearSprite::
	db $7a, $00, $7a, $20

;@ def MansionSwordGlow(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 2 (Link frozen): the light goes on; until timer $50 a glint (SwordAppearSprite), then the large
;@ emblem (frame 4 of SwordEmblemSprites). At 0 the emblem starts to shrink ($28 frames on the drop timer,
;@ state 3).
;@ test: skip draws sprites
MansionSwordGlow::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawSwordGlow(slot)
	call DrawSwordGlow
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .running
;>     wEntityDropTimer[slot] = 0x28
	call GetEntityDropTimer
	ld [hl], $28
;>     return IncrementEntityState(slot)
	jp IncrementEntityState
.running
;> if t < 0x50:
	cp $50
	jr nc, .glint
;>     DrawEntitySprites(SwordEmblemSprites + 4 * 0x20, 8)
	ld hl, SwordEmblemSprites + 4 * $20
	ld c, $08
	call DrawEntitySprites
;>     return ReserveOAMEntriesFar(6)
	ld a, $06
	jp ReserveOAMEntriesFar
.glint
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, SwordAppearSprite)
	ld de, SwordAppearSprite
	call DrawEntity16x16
;> return
	ret


;@ path: npc/seashell_mansion
;@ The emblem the sword forms from, for DrawEntitySprites: 5 frames of 8 OAM entries (y offset, x offset, tile,
;@ attributes), 32 bytes each, from small to large. 0: tile $6E over $70 (16 wide, each entry twice); 1: $68
;@ $6A over $6C; 2: $62 $64 over $66; 3: $5A $5C over $5E $60; 4: $56 $58 over the same flipped vertically.
;@ Right halves are mirrored ($20).
SwordEmblemSprites::
	db $f8, $00, $6e, $00, $f8, $08, $6e, $20, $f8, $00, $6e, $00, $f8, $08, $6e, $20
	db $08, $00, $70, $00, $08, $08, $70, $20, $08, $00, $70, $00, $08, $08, $70, $20
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $00, $6c, $00, $08, $08, $6c, $20
	db $f8, $f8, $62, $00, $f8, $00, $64, $00, $f8, $08, $64, $20, $f8, $10, $62, $20
	db $08, $00, $66, $00, $08, $08, $66, $20, $08, $00, $66, $00, $08, $08, $66, $20
	db $f8, $f8, $5a, $00, $f8, $00, $5c, $00, $f8, $08, $5c, $20, $f8, $10, $5a, $20
	db $08, $f8, $5e, $00, $08, $00, $60, $00, $08, $08, $60, $20, $08, $10, $5e, $20
	db $f8, $f8, $56, $00, $f8, $00, $58, $00, $f8, $08, $58, $20, $f8, $10, $56, $20
	db $08, $f8, $56, $40, $08, $00, $58, $40, $08, $08, $58, $60, $08, $10, $56, $60

;@ def MansionSwordShrink(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 3 (Link frozen, the entity flashing): the emblem shrinks with the drop timer (frame
;@ min((timer >> 2) & 15, 4)); at 0, state 4.
;@ test: skip draws sprites
MansionSwordShrink::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> wEntityFlashTimer[slot] = (hFrameCounter & 0x0F) | 0x20
	ldh a, [hFrameCounter]
	and $0f
	or $20
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;> d = GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if not d: return IncrementEntityState(slot)
	jr nz, .shrink
	jp IncrementEntityState
.shrink
;> frame = min((d >> 2) & 0x0F, 4)
	rra
	rra
	and $0f
	cp $04
	jr c, .frame
	ld a, $04
.frame
;> offset = (frame << 5) & 0xE0
	rla
	rla
	rla
	rla
	rla
	and $e0
;> DrawEntitySprites(SwordEmblemSprites + offset, 8)
	ld e, a
	ld d, b
	ld hl, SwordEmblemSprites
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
;> return
	ret


;@ def MansionSwordDrop(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 4 (Link frozen): the sword falls (gravity 1) to y $70 and bounces (noise $17, speed halved and
;@ reversed) until it lands slower than 4 - then state 5.
;@ test: skip draws sprites
MansionSwordDrop::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> DrawSword(slot)
	call DrawSword
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> wEntitySpeedY[slot] += 1
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> if not wEntitySpeedY[slot] & 0x80:       # falling
	ld a, [hl]
	and $80
	jr nz, .done
;>     if wEntityY[slot] >= 0x70:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, .done
;>         wEntityY[slot] = 0x70
	ld [hl], $70
;>         hNoiseSfx = 0x17
	ld a, $17
	ldh [hNoiseSfx], a
;>         v = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;>         if v < 4: return IncrementEntityState(slot)
	cp $04
	jp c, IncrementEntityState
;>         wEntitySpeedY[slot] = u8(-v >> 1)  # bounce
	cpl
	inc a
	sra a
	ld [hl], a
.done
;> return
	ret


;@ def MansionSwordWaitForLink(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 5: Link can move; when he touches the sword, music $0F plays and state 6 runs for $FF frames.
;@ test: skip draws sprites
MansionSwordWaitForLink::
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> DrawSword(slot)
	call DrawSword
;> if EntityTouchesLink(slot):
	call EntityTouchesLink
	jr nc, .done
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wMusicTrackToPlay = 0x0F
	ld a, $0f
	ld [wMusicTrackToPlay], a
;>     wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
.done
;> return
	ret


;@ def MansionSwordGet(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 6: Link holds the sword up (pose $6B, facing down, sword above his head with its rays) while the
;@ palette flickers every 8 frames. At the end: music $10, dialog $9F, the mansion's room status (wRoomStatus +
;@ $2E9 and hRoomStatus) gets bit 4, wSwordLevel 2, health refilled ($FF into wAddHealthBuffer), wSeashells
;@ 0, Link can move, state 7.
;@ test: skip draws sprites and calls routines in other banks
MansionSwordGet::
;> p = 0x84 if GetEntityTimer(slot) & 8 else 0xE4
	call GetEntityTimer
	and $08
	ld e, $e4
	jr z, .palette
	ld e, $84
.palette
;> wBGPalette = p
	ld a, e
	ld [wBGPalette], a
;> if not GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .hold
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>     OpenDialog(0x9F)
	ld a, $9f
	call OpenDialog
;>     status = wRoomStatus[0x2E9] | 0x10
	ld a, [wRoomStatus + $2E9]
	or $10
;>     wRoomStatus[0x2E9] = status
	ld [wRoomStatus + $2E9], a
;>     hRoomStatus = status
	ldh [hRoomStatus], a
;>     wSwordLevel = 2
	ld a, $02
	ld [wSwordLevel], a
;>     wAddHealthBuffer = 0xFF
	ld a, $ff
	ld [wAddHealthBuffer], a
;>     wSeashells = 0
	xor a
	ld [wSeashells], a
;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
.hold
;> wEntityX[slot] = u8(hLinkX - 4)
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub $04
	ld [hl], a
;> wEntityY[slot] = u8(hLinkY - 0x13)
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub $13
	ld [hl], a
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> hLinkAnimationState = 0x6B               # holding something up
	ld a, $6b
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
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
;> DrawSwordRays()
	call DrawSwordRays
;> DrawSwordHeld()
	call DrawSwordHeld
;> return
	ret


;@ def MansionSwordShowOff(slot: bc)
;@ path: npc/seashell_mansion
;@ Sword state 7: the sword stays above Link until the dialog is closed, then it is removed.
;@ test: skip draws sprites
MansionSwordShowOff::
;> DrawSwordHeld()
	call DrawSwordHeld
;> if not wDialogState: ClearEntityStatus_19(slot)
	ld a, [wDialogState]
	and a
	jr nz, .done
	call ClearEntityStatus_19
.done
;> return
	ret


;@ path: npc/seashell_mansion
;@ Rays around the raised sword, frame 0, for DrawEntitySprites: 12 OAM entries (y offset, x offset, tile,
;@ attributes) of tiles $72-$78.
SwordRays0::
	db $00, $04, $72, $00, $e0, $04, $72, $00, $00, $f0, $78, $20, $00, $f8, $78, $40
	db $00, $10, $78, $60, $00, $18, $78, $00, $f0, $e8, $76, $20, $f0, $f0, $76, $40
	db $f0, $18, $76, $60, $f0, $20, $76, $00, $e8, $f4, $74, $20, $e8, $14, $74, $00
;@ path: npc/seashell_mansion
;@ Rays, frame 1: 14 entries (same format), further out.
SwordRays1::
	db $f8, $04, $72, $00, $d8, $04, $72, $00, $fc, $e8, $78, $20, $fc, $f0, $78, $40
	db $fc, $18, $78, $60, $fc, $20, $78, $00, $e8, $e0, $76, $20, $e8, $e8, $76, $40
	db $e8, $20, $76, $60, $e8, $28, $76, $00, $e0, $f0, $74, $20, $e0, $18, $74, $00
	db $00, $00, $74, $20, $00, $08, $74, $00

;@ path: npc/seashell_mansion
;@ Rays, frame 2: 18 entries (same format), furthest out.
SwordRays2::
	db $f0, $04, $72, $00, $d0, $04, $72, $00, $f8, $e0, $78, $20, $f8, $e8, $78, $40
	db $f8, $20, $78, $60, $f8, $28, $78, $00, $e0, $d8, $76, $20, $e0, $e0, $76, $40
	db $e0, $28, $76, $60, $e0, $30, $76, $00, $d8, $ec, $74, $20, $d8, $1c, $74, $00
	db $f8, $fc, $74, $20, $f8, $0c, $74, $00, $00, $f8, $76, $20, $00, $00, $76, $40
	db $00, $08, $76, $60, $00, $10, $76, $00
;@ path: npc/seashell_mansion
;@ Rays, frame 3: 17 entries (same format).
SwordRays3::
	db $e4, $04, $72, $00, $00, $f8, $78, $20, $00, $00, $78, $40, $00, $08, $78, $60
	db $00, $10, $78, $00, $f4, $f0, $76, $20, $f4, $f8, $76, $40, $f4, $10, $76, $60
	db $f4, $18, $76, $00, $ec, $f8, $74, $20, $ec, $10, $74, $00, $f0, $d8, $78, $20
	db $f0, $e0, $78, $40, $f0, $28, $78, $60, $f0, $30, $78, $00, $cc, $e8, $74, $20
	db $cc, $20, $74, $00

;@ path: npc/seashell_mansion
;@ The four ray frames, indexed by (hFrameCounter >> 2) & 3.
SwordRaySets::
	dw SwordRays0
	dw SwordRays1
	dw SwordRays2
	dw SwordRays3

;@ path: npc/seashell_mansion
;@ Number of OAM entries in each ray frame: 12, 14, 18, 17.
SwordRayCounts::
	db $0c, $0e, $12, $11

;@ def DrawSwordRays()
;@ path: npc/seashell_mansion
;@ Draws ray frame (hFrameCounter >> 2) & 3 around the raised sword.
;@ test: skip draws sprites
DrawSwordRays::
;> hActiveEntityDrawY = u8(hActiveEntityDrawY - 0)
	ldh a, [hActiveEntityDrawY]
	sub $00
	ldh [hActiveEntityDrawY], a
;> t = hFrameCounter >> 2
	ldh a, [hFrameCounter]
	rra
	rra
	nop
	push af
;> n = mem[SwordRayCounts + (t & 3)]
	and $03
	ld e, a
	ld d, b
	ld hl, SwordRayCounts
	add hl, de
	ld c, [hl]
;> p = SwordRaySets + (t & 3) * 2
	pop af
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, SwordRaySets
;> sprites = mem[p] | (mem[p + 1] << 8)
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> DrawEntitySprites(sprites, n)
	call DrawEntitySprites
;> ReserveOAMEntriesFar(0x10)
	ld a, $10
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: npc/seashell_mansion
;@ The bonus seashell, for DrawEntity16x16: two OAM entries (tile, attributes) - tile $7E and the same mirrored.
MansionSeashellSprite::
	db $7e, $00, $7e, $20

;@ def MansionBonusShell(slot: bc)
;@ path: npc/seashell_mansion
;@ A bonus seashell (entity $CF with wEntityPrivate1 = 2): after its timer it drops (gravity 1) to y $70 and
;@ stays there. When Link touches it: wave sound 1, it is gone, the mansion's room status gets bit 5 (at 5
;@ shells) or bit 6 (otherwise), wSeashells goes up by one (BCD) and dialog $EF opens.
;@ test: skip draws sprites
MansionBonusShell::
;> if GetEntityTimer(slot): return
	call GetEntityTimer
	ret nz
;> DrawEntity16x16(slot, MansionSeashellSprite)
	ld de, MansionSeashellSprite
	call DrawEntity16x16
;> UpdateEntityYPosWithSpeed_19(slot)
	call UpdateEntityYPosWithSpeed_19
;> wEntitySpeedY[slot] += 1
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> if not wEntitySpeedY[slot] & 0x80:
	ld a, [hl]
	and $80
	jr nz, .done
;>     if wEntityY[slot] >= 0x70:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, .done
;>         wEntityY[slot] = 0x70
	ld [hl], $70
;>         wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;>         if EntityTouchesLink(slot):
	call EntityTouchesLink
	jr nc, .done
;>             hWaveSfx = 1
	ld a, $01
	ldh [hWaveSfx], a
;>             ClearEntityStatus_19(slot)
	call ClearEntityStatus_19
;>             status = wRoomStatus + 0x2E9
	ld hl, wRoomStatus + $2E9
;>             if wSeashells == 5: mem[status] |= 0x20
	ld a, [wSeashells]
	cp $05
	jr nz, .ten
	set 5, [hl]
	jr .count
.ten
;>             else: mem[status] |= 0x40
	set 6, [hl]
.count
;>             wSeashells = bcd_add(wSeashells, 1)
	add $01
	daa
	ld [wSeashells], a
;>             OpenDialog(0xEF)
	ld a, $ef
	call OpenDialog
.done
;> return
	ret


;@ path: npc/seashell_mansion
;@ The falling sword, for DrawEntitySprites: 4 OAM entries (y offset, x offset, tile, attributes) - tile $52
;@ over $54, right halves mirrored.
SwordSprites::
	db $f8, $00, $52, $00, $f8, $08, $52, $20, $08, $00, $54, $00, $08, $08, $54, $20
;@ path: npc/seashell_mansion
;@ The sword held up by Link: the same picture flipped vertically ($54 over $52, attributes $40 / $60).
SwordHeldSprites::
	db $f8, $00, $54, $40, $f8, $08, $54, $60, $08, $00, $52, $40, $08, $08, $52, $60

;@ def DrawSwordHeld()
;@ path: npc/seashell_mansion
;@ Draws SwordHeldSprites.
;@ test: skip draws sprites
DrawSwordHeld::
;> return DrawMansionSwordSprites(SwordHeldSprites)
	ld hl, SwordHeldSprites
	jr DrawMansionSwordSprites

;@ def DrawSword()
;@ path: npc/seashell_mansion
;@ Draws SwordSprites.
;@ test: skip draws sprites
DrawSword::
;> return DrawMansionSwordSprites(SwordSprites)
	ld hl, SwordSprites

;@ def DrawMansionSwordSprites(sprites: hl)
;@ path: npc/seashell_mansion
;@ Draws 4 OAM entries from sprites and reserves 2 entries.
;@ test: skip draws sprites
DrawMansionSwordSprites::
;> DrawEntitySprites(sprites, 4)
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: npc/seashell_mansion
;@ Tiles of the passage that opens in the mansion: background draw commands (BG address high, low, mode $8D =
;@ vertical 14 tiles, tiles). Column 16 from row 2: $6C $6E repeated; column 17: $6D $6F repeated; then the end
;@ byte 0. 35 bytes.
MansionPassageTiles::
	db $98, $50, $8d, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c
	db $6e, $98, $51, $8d, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f
	db $6d, $6f, $00

;@ def OpenMansionPassage()
;@ path: npc/seashell_mansion
;@ Queues MansionPassageTiles and makes room objects of column 8, rows 1-7, $89.
;@ test: skip writes the background draw queue
OpenMansionPassage::
;> wDrawCommandsSize = 0x22
	push bc
	ld c, $23
	ld a, $22
	ld [wDrawCommandsSize], a
;> dst = wDrawCommand
	ld hl, wDrawCommand
;> src = MansionPassageTiles
	ld de, MansionPassageTiles
;> for _ in range(0x23):
.copy
;>     mem[dst] = mem[src]
	ld a, [de]
	inc de
	ld [hli], a
;>     src += 1; dst += 1
	dec c
	jr nz, .copy
;> wRoomObjects[0x18] = 0x89
	pop bc
	ld a, $89
	ld [wRoomObjects + $18], a
;> wRoomObjects[0x28] = 0x89
	ld [wRoomObjects + $28], a
;> wRoomObjects[0x38] = 0x89
	ld [wRoomObjects + $38], a
;> wRoomObjects[0x48] = 0x89
	ld [wRoomObjects + $48], a
;> wRoomObjects[0x58] = 0x89
	ld [wRoomObjects + $58], a
;> wRoomObjects[0x68] = 0x89
	ld [wRoomObjects + $68], a
;> wRoomObjects[0x78] = 0x89
	ld [wRoomObjects + $78], a
;> return
	ret


;@ path: entity/engine
;@ X shift per frame of a room scroll, indexed by wRoomTransitionDirection (0 right, 1 left, 2 up, 3 down):
;@ -4, +4, 0, 0 (everything on the old screen slides the other way).
EntityScrollShiftX::
	db $fc, $04, $00, $00

;@ path: entity/engine
;@ High byte of the x shift (the sign extension): $FF, 0, 0, 0.
EntityScrollShiftXHigh::
	db $ff, $00, $00, $00

;@ path: entity/engine
;@ Y shift per frame of a room scroll by direction: 0, 0, +4, -4.
EntityScrollShiftY::
	db $00, $00, $04, $fc

;@ path: entity/engine
;@ High byte of the y shift: 0, 0, 0, $FF.
EntityScrollShiftYHigh::
	db $00, $00, $00, $ff
;@ path: entity/engine
;@ How far back in the Lanmola's position history (wEntityWorkRAM / wEntityWorkRAM2, indexed from its
;@ wEntityPrivateCounter) its 6 body segments are: $0C, $18, $24, $30, $3C, $48.
LanmolaTrailOffsets::
	db $0c, $18, $24, $30, $3c, $48

;@ def MoveEntityWithRoomScroll(slot: bc)
;@ path: entity/engine
;@ During a room scroll (wRoomTransitionState 3 or more) moves the entity by the scroll's shift (16-bit, with
;@ wEntityPosXHigh / wEntityPosYHigh), together with what some entities remember of their positions: Turtle
;@ Rock's head ($7F, wEntityPrivate4 / wEntityPrivate3), the Lanmola's ($87) position history unless
;@ wEntityPrivate3 is 2, the trail Marin ($C1) walks along while she follows Link, Bow-Wow's ($6D) chain links
;@ (not on every 8th frame while he follows Link) and, for $6D, the lever ($69) and the pincer ($B0), the
;@ position in wEntityPrivate1 / wEntityPrivate2. Ends in RemoveEntityLeftBehind.
;@ test: skip runs during a room scroll
MoveEntityWithRoomScroll::
;> if wRoomTransitionState < 3: return
	ld a, [wRoomTransitionState]
	cp $03
	jr nc, .scrolling
	ret
.scrolling
;> d = wRoomTransitionDirection
	ld a, [wRoomTransitionDirection]
	ld e, a
	ld d, $00
;> hMultiPurpose0 = mem[EntityScrollShiftX + d]
	ld hl, EntityScrollShiftX
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = mem[EntityScrollShiftXHigh + d]
	ld hl, EntityScrollShiftXHigh
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose2 = mem[EntityScrollShiftY + d]
	ld hl, EntityScrollShiftY
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = mem[EntityScrollShiftYHigh + d]
	ld hl, EntityScrollShiftYHigh
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose3], a
;> s = wEntityX[slot] + hMultiPurpose0
	ld hl, wEntityX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	rl d
;> wEntityX[slot] = u8(s)
	ld [hl], a
;> wEntityPosXHigh[slot] = u8(wEntityPosXHigh[slot] + hMultiPurpose1 + (s >> 8))
	ld hl, wEntityPosXHigh
	add hl, bc
	ldh a, [hMultiPurpose1]
	rr d
	adc [hl]
	ld [hl], a
;> s = wEntityY[slot] + hMultiPurpose2
	ld hl, wEntityY
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	rl d
;> wEntityY[slot] = u8(s)
	ld [hl], a
;> wEntityPosYHigh[slot] = u8(wEntityPosYHigh[slot] + hMultiPurpose3 + (s >> 8))
	ld hl, wEntityPosYHigh
	add hl, bc
	ldh a, [hMultiPurpose3]
	rr d
	adc [hl]
	ld [hl], a
;> t = hActiveEntityType
	ldh a, [hActiveEntityType]
;> if t == 0x7F:                            # Turtle Rock's head
	cp $7f
	jr nz, .lanmola
;>     wEntityPrivate4[slot] = u8(wEntityPrivate4[slot] + hMultiPurpose0)
	ld hl, wEntityPrivate4
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
;>     wEntityPrivate3[slot] = u8(wEntityPrivate3[slot] + hMultiPurpose2)
	ld hl, wEntityPrivate3
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a
;>     return RemoveEntityLeftBehind(slot)
	jp RemoveEntityLeftBehind
.lanmola
;> if t == 0x87:                            # Lanmola
	cp $87
	jr nz, .marin
;>     if wEntityPrivate3[slot] == 2: return RemoveEntityLeftBehind(slot)
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, RemoveEntityLeftBehind
;>     hMultiPurposeF = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeF], a
;>     for i in range(6, 0, -1):
	ld a, $06
.trail
;>         hMultiPurposeG = i
	ldh [hMultiPurposeG], a
;>         offset = mem[LanmolaTrailOffsets + (i - 1)]
	ld e, a
	ld d, b
	ld hl, LanmolaTrailOffsets - 1
	add hl, de
	push hl
;>         j = u8(hMultiPurposeF - offset)
	ldh a, [hMultiPurposeF]
	sub [hl]
	ld e, a
	ld d, b
;>         wEntityWorkRAM[j] = u8(wEntityWorkRAM[j] + hMultiPurpose0)
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
;>         j = u8(hMultiPurposeF - offset)
	ldh a, [hMultiPurposeF]
	pop hl
	sub [hl]
	ld e, a
	ld d, b
;>         wEntityWorkRAM2[j] = u8(wEntityWorkRAM2[j] + hMultiPurpose2)
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a
;>         pass                             # next i
	ldh a, [hMultiPurposeG]
	dec a
	jr nz, .trail
;>     t = 0                                # the loop leaves 0, so no case below matches
.marin
;> if t == 0xC1:                            # Marin
	cp $c1
	jr nz, .others
;>     if not wIsMarinFollowingLink: return RemoveEntityLeftBehind(slot)
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, RemoveEntityLeftBehind
;>     for k in range(16):
	ld e, $10
	ld hl, wFollowerTrailX
.trailX
;>         wFollowerTrailX[k] = u8(wFollowerTrailX[k] + hMultiPurpose0)
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hli], a
	dec e
	jr nz, .trailX
;>     for k in range(16):
	ld e, $10
	ld hl, wFollowerTrailY
.trailY
;>         wFollowerTrailY[k] = u8(wFollowerTrailY[k] + hMultiPurpose2)
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hli], a
	dec e
	jr nz, .trailY
;>     return RemoveEntityLeftBehind(slot)
	jr RemoveEntityLeftBehind
.others
;> if t != 0x69 and t != 0xB0:              # not the lever or the pincer
	cp $69
	jr z, .home
	cp $b0
	jr z, .home
;>     if t != 0x6D: return RemoveEntityLeftBehind(slot)   # $6D is Bow-Wow
	cp $6d
	jr nz, RemoveEntityLeftBehind
;>     if wIsBowWowFollowingLink == 1 and not hFrameCounter & 7: return RemoveEntityLeftBehind(slot)
	ld a, [wIsBowWowFollowingLink]
	cp $01
	jr nz, .chain
	ldh a, [hFrameCounter]
	and $07
	jr z, RemoveEntityLeftBehind
.chain
;>     for k in range(6):
	ld e, $06
	ld hl, wEntityWorkRAM2
.chainX
;>         wEntityWorkRAM2[k] = u8(wEntityWorkRAM2[k] + hMultiPurpose0)   # chain link x
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hli], a
	dec e
	jr nz, .chainX
;>     for k in range(6):
	ld e, $06
	ld hl, wSegmentY
.chainY
;>         wSegmentY[k] = u8(wSegmentY[k] + hMultiPurpose2)               # chain link y
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hli], a
	dec e
	jr nz, .chainY
.home
;> wEntityPrivate1[slot] = u8(wEntityPrivate1[slot] + hMultiPurpose0)
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
;> wEntityPrivate2[slot] = u8(wEntityPrivate2[slot] + hMultiPurpose2)
	ld hl, wEntityPrivate2
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a
;> return RemoveEntityLeftBehind(slot)

;@ def RemoveEntityLeftBehind(slot: bc)
;@ path: entity/engine
;@ An entity that belongs to another room (wEntityRoom is not hMapRoom) and is off the screen (x $A0 or more,
;@ or y outside $10-$87) is removed - except entity $A7.
;@ test: skip runs during a room scroll
RemoveEntityLeftBehind::
;> if hMapRoom != wEntityRoom[slot]:
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	cp [hl]
	jr z, .done
;>     off = wEntityX[slot] >= 0xA0
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	cp $a0
	jr nc, .off
;>     if not off: off = u8(wEntityY[slot] - 0x10) >= 0x78
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	cp $78
	jr c, .done
.off
;>     if off and hActiveEntityType != 0xA7:
	ldh a, [hActiveEntityType]
	cp $a7
	ret z
;>         wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
.done
;> return
	ret


;@ def AnimateScrollingFloorTiles()
;@ path: gfx/animation
;@ Runs before the entities each frame. While the room has scrolling-floor objects (wScrollingFloorCount) and
;@ no dialog is open, one of the four floor tiles in the RAM buffer at $DCC0 moves by one pixel, a different
;@ one each frame (hFrameCounter & 3): down, up, left, right.
;@ test: skip changes tile data in RAM
AnimateScrollingFloorTiles::
;> if not wScrollingFloorCount: return
	ld a, [wScrollingFloorCount]
	and a
	jr z, ScrollFloorTileDown.done
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	jr nz, ScrollFloorTileDown.done
;> return ScrollingFloorTileSteps[hFrameCounter & 3]()
	ldh a, [hFrameCounter]
	and $03
	rst $00

;@ path: gfx/animation
;@ The four scrolling-floor steps, by hFrameCounter & 3: tile 0 down, tile 1 up, tile 2 left, tile 3 right.
ScrollingFloorTileSteps::
	dw ScrollFloorTileDown
	dw ScrollFloorTileUp
	dw ScrollFloorTileLeft
	dw ScrollFloorTileRight

;@ def ScrollFloorTileDown()
;@ path: gfx/animation
;@ Tile 0 ($DCC0-$DCCF, 8 rows of 2 bytes) moves down one pixel row; the bottom row wraps to the top.
;@ test: skip changes tile data in RAM
ScrollFloorTileDown::
;> src = 0xDCCF
	ld hl, $dccf
;> dst = 0xDCCF
	ld de, $dccf
;> hi = mem[src]; src -= 1
	ld a, [hld]
	push af
;> lo = mem[src]; src -= 1
	ld a, [hld]
	push af
;> for _ in range(7):
	ld c, $07
.row
;>     mem[dst] = mem[src]; src -= 1; dst -= 1
	ld a, [hld]
	ld [de], a
	dec de
;>     mem[dst] = mem[src]; src -= 1; dst -= 1
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .row
;> mem[0xDCC1] = hi
	pop hl
	pop bc
	ld a, b
	ld [de], a
	dec de
;> mem[0xDCC0] = lo
	ld a, h
	ld [de], a
.done
;> return
	ret


;@ def ScrollFloorTileUp()
;@ path: gfx/animation
;@ Tile 1 ($DCD0-$DCDF) moves up one pixel row; the top row wraps to the bottom.
;@ test: skip changes tile data in RAM
ScrollFloorTileUp::
;> src = 0xDCD0
	ld hl, $dcd0
;> dst = 0xDCD0
	ld de, $dcd0
;> lo = mem[src]; src += 1
	ld a, [hli]
	push af
;> hi = mem[src]; src += 1
	ld a, [hli]
	push af
;> for _ in range(7):
	ld c, $07
.row
;>     mem[dst] = mem[src]; src += 1; dst += 1
	ld a, [hli]
	ld [de], a
	inc de
;>     mem[dst] = mem[src]; src += 1; dst += 1
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .row
;> mem[0xDCDE] = lo
	pop hl
	pop bc
	ld a, b
	ld [de], a
	inc de
;> mem[0xDCDF] = hi
	ld a, h
	ld [de], a
;> return
	ret


;@ def ScrollFloorTileLeft()
;@ path: gfx/animation
;@ Tile 2 ($DCE0-$DCEF): every byte rotated left, so the picture moves one pixel left and wraps.
;@ test: skip changes tile data in RAM
ScrollFloorTileLeft::
;> for p in range(0xDCE0, 0xDCF0):
	ld hl, $dce0
	ld e, $10
.byte
;>     mem[p] = u8(mem[p] << 1 | mem[p] >> 7)
	rlc [hl]
	inc hl
	dec e
	jr nz, .byte
;> return
	ret


;@ def ScrollFloorTileRight()
;@ path: gfx/animation
;@ Tile 3 ($DCF0-$DCFF): every byte rotated right, so the picture moves one pixel right and wraps.
;@ test: skip changes tile data in RAM
ScrollFloorTileRight::
;> for p in range(0xDCF0, 0xDD00):
	ld hl, $dcf0
	ld e, $10
.byte
;>     mem[p] = u8(mem[p] >> 1 | (mem[p] & 1) << 7)
	rrc [hl]
	inc hl
	dec e
	jr nz, .byte
;> return
	ret


;@ path: object/liftable
;@ Pieces of a thrown object that breaks (DrawShatterPieces, variants other than $FF and 1), for
;@ DrawEntitySprites: 4 frames of 4 OAM entries (y offset, x offset, tile, attributes), 16 bytes each; all
;@ tile $16, moving apart from frame to frame.
ShatterPiecesTile16::
	db $fd, $fc, $16, $00, $fc, $0c, $16, $00, $0e, $fb, $16, $00, $0c, $0d, $16, $00
	db $fb, $fd, $16, $00, $fa, $0b, $16, $00, $0b, $fc, $16, $00, $09, $0c, $16, $00
	db $fd, $fe, $16, $00, $fc, $0a, $16, $00, $0b, $fd, $16, $00, $08, $0a, $16, $00
	db $ff, $00, $16, $00, $00, $08, $16, $00, $0a, $ff, $16, $00, $08, $09, $16, $00
;@ path: object/liftable
;@ Pieces for sprite variants $FF and 1: 8 frames of 4 OAM entries (same format), all tile $28 with various
;@ flips. DrawShatterPieces reads them in reverse order of its step.
ShatterPiecesTile28::
	db $02, $fc, $28, $00, $fb, $04, $28, $60, $05, $06, $28, $00, $01, $0a, $28, $20
	db $01, $ff, $28, $00, $f9, $04, $28, $60, $08, $06, $28, $00, $02, $07, $28, $20
	db $00, $00, $28, $20, $f8, $02, $28, $60, $04, $04, $28, $20, $0a, $07, $28, $20
	db $fe, $01, $28, $20, $04, $01, $28, $60, $04, $05, $28, $20, $0c, $07, $28, $20
	db $fd, $00, $28, $20, $04, $fe, $28, $60, $08, $08, $28, $20, $0e, $09, $28, $20
	db $fc, $ff, $28, $00, $04, $fa, $28, $40, $08, $09, $28, $20, $0f, $0a, $28, $00
	db $fb, $fe, $28, $00, $03, $f9, $28, $40, $08, $0c, $28, $00, $11, $0b, $28, $00
	db $fa, $fd, $28, $00, $01, $f7, $28, $40, $09, $0d, $28, $00, $0f, $0c, $28, $00

;@ def DrawShatterPieces(slot: bc, step: hMultiPurpose0)
;@ path: object/liftable
;@ Draws the pieces of a broken thrown object (called from bank 0's ShatterThrownObject). Sprite variants other
;@ than $FF and 1: frame (step & $0C) / 4 of ShatterPiecesTile16. Variant $FF is set to 0 and then drawn only on
;@ every second frame (by slot); variants $FF and 1 use frame 7 - (step & $1C) / 4 of ShatterPiecesTile28.
;@ test: skip draws sprites
DrawShatterPieces::
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v != 0xFF and v != 1:
	cp $ff
	jr z, .large
	cp $01
	jr z, .large
;>     offset = (hMultiPurpose0 & 0x0C) * 4
	ldh a, [hMultiPurpose0]
	and $0c
	sla a
	sla a
	ld e, a
;>     return DrawEntitySprites(ShatterPiecesTile16 + offset, 4)
	ld d, b
	ld hl, ShatterPiecesTile16
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ret
.large
;> if v == 0xFF:
	inc a
	jr nz, .draw
;>     hActiveEntitySpriteVariant = 0
	ldh [hActiveEntitySpriteVariant], a
;>     if (hFrameCounter ^ slot) & 1: return
	ldh a, [hFrameCounter]
	xor c
	rra
	ret c
.draw
;> offset = ((hMultiPurpose0 & 0x1C) ^ 0x1C) * 4
	ldh a, [hMultiPurpose0]
	and $1c
	xor $1c
	sla a
	sla a
	ld e, a
;> DrawEntitySprites(ShatterPiecesTile28 + offset, 4)
	ld d, b
	ld hl, ShatterPiecesTile28
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> return
	ret


;@ def PushLinkOutOfEntity_19(slot: bc) -> (a, carry)
;@ path: entity/helpers
;@ Makes the entity solid: if Link touches it, he is put back where he stood last frame, a hookshot chain
;@ that is out is reset to its first state, the Pegasus-boots dash ends and Link's speed is zeroed. Returns carry if Link
;@ touched it, with a = whether Link was dashing.
;@ test: skip calls the bank-3 collision check
PushLinkOutOfEntity_19::
;> if not EntityTouchesLink(slot):                      # does Link overlap the entity?
	call EntityTouchesLink
	jr nc, .noContact
;>@nc     return 0, False
;> RestoreLinkPosition()                              # Link back to last frame's position
	call RestoreLinkPosition
;> held = wHookshotChainSlot                # slot + 1 of the hookshot chain, 0 = none
	ld a, [wHookshotChainSlot]
	and a
	jr z, .stopDash
;> chain = held - 1
	ld e, a
	ld d, b
;> if held and wEntityType[chain] == 0x03:
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, .stopDash
;>     wEntityState[chain] = 0              # the chain goes back to its first state
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00

.stopDash
;> dashing = wIsUsingPegasusBoots
	ld a, [wIsUsingPegasusBoots]
	ld e, a
;> ResetPegasusBoots()                              # stop the Pegasus-boots dash
	call ResetPegasusBoots
;> StopLinkSpeed()                              # Link's speed = 0
	call StopLinkSpeed
;> return dashing, True
	ld a, e
	scf
	ret

.noContact
;=@nc
	and a
	ret


;@ path: entity/helpers
;@ Sprite variant of the first walking frame for each facing direction, read by SetWalkingSpriteVariant_19.
;@ 4 bytes, indexed by wEntityDirection (0 right, 1 left, 2 up, 3 down): $06, $04, $02, $00. The second
;@ frame is the value + 1.
EntityWalkSpriteBase_19::
	db $06, $04, $02, $00

;@ def SetWalkingSpriteVariant_19(slot: bc)
;@ path: entity/helpers
;@ Two-frame walking animation of a character: the sprite variant for its facing direction, switching
;@ frames every 16 calls (counted in wEntityPrivateCounter).
;@ test: skip calls a bank-0 routine
SetWalkingSpriteVariant_19::
;> base = mem[EntityWalkSpriteBase_19 + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, EntityWalkSpriteBase_19
	add hl, de
;> wEntityPrivateCounter[slot] = u8(wEntityPrivateCounter[slot] + 1)
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> frame = (wEntityPrivateCounter[slot] >> 4) & 1
	ld a, [hl]
	rra
	rra
	rra
	rra
	pop hl
;> return SetEntitySpriteVariant(slot, base | frame)           # wEntitySpriteVariant = a
	and $01
	or [hl]
	jp SetEntitySpriteVariant


;@ def ShouldLinkTalkToEntity_19(slot: bc) -> carry
;@ path: entity/helpers
;@ True (carry) when Link stands next to the character (within 20 pixels up or down, 16 left or right),
;@ faces it and presses A while nothing else is going on. Other entry points: ShouldLinkTalkToEntityInRange_19
;@ (the caller did the vertical test) and CheckTalkButtonPressed_19 (no position test).
;@ test: skip falls through into two other entry points
ShouldLinkTalkToEntity_19::
;> inRange = u8(hLinkY - hActiveEntityY + 0x14) < 0x28
	ld e, b
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28
;> return ShouldLinkTalkToEntityInRange_19(slot, inRange)

;@ def ShouldLinkTalkToEntityInRange_19(slot: bc, inRange: carry) -> carry
;@ path: entity/helpers
;@ The rest of ShouldLinkTalkToEntity_19, entered with carry set when the caller found Link inside its
;@ vertical range: Link must also be within 16 pixels horizontally and face the entity.
;@ test: skip falls through into CheckTalkButtonPressed_19
ShouldLinkTalkToEntityInRange_19::
;> if not inRange: return False
	jr nc, CheckTalkButtonPressed_19.return
;> if u8(hLinkX - hActiveEntityX + 0x10) >= 0x20: return False
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, CheckTalkButtonPressed_19.return
;> toLink = GetEntityDirectionToLink_19(slot)
	inc e
	push de
	call GetEntityDirectionToLink_19
;> if (hLinkDirection ^ 1) != toLink: return False   # Link must face the entity
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
	jr nz, CheckTalkButtonPressed_19.return
;> return CheckTalkButtonPressed_19()

;@ def CheckTalkButtonPressed_19() -> carry
;@ path: entity/helpers
;@ Shows that Link can talk here (wCanTalkToEntity = 1) and returns carry when A was pressed this frame,
;@ unless a dialogue box is open or has just closed, the inventory is moving, Link is in the air or the
;@ window is not in its resting place (wWindowY = $80).
CheckTalkButtonPressed_19::
;> wCanTalkToEntity = 1
	ld hl, wCanTalkToEntity
	ld [hl], $01
;> busy = wDialogState | wInventoryAppearing | wIsLinkInTheAir
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
;> if busy or wDialogCooldown: return False
	ld hl, wDialogCooldown
	or [hl]
	jr nz, .return
;> if wWindowY != 0x80: return False
	ld a, [wWindowY]
	cp $80
	jr nz, .return
;> if not hJoypadPressed & 0x10: return False   # A button
	ldh a, [hJoypadPressed]
	and $10
	jr z, .return
;> return True
	scf
	ret

.return
;> return False                            # (the exit of every failed check above)
	and a
	ret


;@ def ReturnIfNonInteractive_19()
;@ path: entity/helpers
;@ Called at the top of an entity's state code: returns from the caller (the rest of the handler is skipped)
;@ unless the entity is in its normal state (status 5) and the game is running normally - not on the map
;@ screen (game mode 7), with no dialogue box, no inventory moving and no room transition.
;@ test: skip drops the caller's return address
ReturnIfNonInteractive_19::
;> if hActiveEntityStatus != 5: return_from_caller()
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, .skip
;> if wGameplayType == 7: return_from_caller()        # map screen
	ld a, [wGameplayType]
	cp $07
	jr z, .skip
;> if wDialogState or wLinkShowItemPoseActive or wInventoryAppearing: return_from_caller()
	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, .skip
;> if wRoomTransitionState: return_from_caller()
	ld a, [wRoomTransitionState]
	and a
	jr z, .done

.skip
	pop af

.done
	ret


;@ def ApplyRecoilIfNeeded_19(slot: bc)
;@ path: entity/helpers
;@ While the entity is being knocked back after a hit (wEntityIgnoreHitsTimer running) it moves with its
;@ recoil speed instead of its own (bouncing off walls unless option bit 5 is set), and the caller's
;@ return address is dropped so the rest of the handler is skipped this frame.
;@ test: skip drops the caller's return address
ApplyRecoilIfNeeded_19::
;> if wEntityIgnoreHitsTimer[slot] == 0: return
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;> wEntityIgnoreHitsTimer[slot] -= 1
	dec a
	ld [hl], a
;> AddPowerHitTrailVfx(slot)
	call AddPowerHitTrailVfx
;> savedX = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
;> savedY = wEntitySpeedY[slot]
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
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore
;>     EntityCheckWalls(slot)                          # collide with walls
	call EntityCheckWalls

.restore
;> wEntitySpeedY[slot] = savedY
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
;> wEntitySpeedX[slot] = savedX
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
;> return_from_caller()
	pop af

.done
	ret


;@ def UpdateEntityPosWithSpeed_19(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its x and y speeds (in 1/16 pixels per frame).
;@ test: skip needs a real entity slot (0-15); random slots run into unmapped memory
UpdateEntityPosWithSpeed_19::
;> AddEntitySpeedToPos_19(slot)             # x
	call AddEntitySpeedToPos_19
;> UpdateEntityYPosWithSpeed_19(slot)

;@ def UpdateEntityYPosWithSpeed_19(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its y speed: the y arrays lie 16 bytes after the x arrays, so the x routine runs on
;@ slot + 16.
;@ test: skip needs a real entity slot (0-15); random slots run into unmapped memory
UpdateEntityYPosWithSpeed_19::
;> AddEntitySpeedToPos_19(slot + 16)
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPos_19
;> return
	pop bc
	ret


;@ def AddEntitySpeedToPos_19(slot: bc)
;@ path: entity/helpers
;@ Adds the entity's x speed to its x position. The speed is signed 4.4 fixed point: the high nibble is whole
;@ pixels, the low nibble sixteenths, which collect in wEntitySpeedXAcc and carry over into the position.
;@ Called with slot + 16 it does the same for y.
;@ test: skip needs a real entity slot (0-15); random slots run into unmapped memory
AddEntitySpeedToPos_19::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> if speed == 0: return
	and a
	jr z, .done
;> acc = wEntitySpeedXAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
;> wEntitySpeedXAcc[slot] = u8(acc)
	ld [hl], a
	rl d
	ld hl, wEntityX

.addWhole
;> sign = 0xF0 if speed & 0x80 else 0
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive
	ld e, $f0
.positive
;> whole = (speed >> 4) | sign             # the pixel part, sign-extended
	swap a
	and $0f
	or e
;> wEntityX[slot] = u8(wEntityX[slot] + whole + (acc >> 8))
	rr d
	adc [hl]
	ld [hl], a

.done
	ret


;@ def AddEntityZSpeedToPos_19(slot: bc)
;@ path: entity/helpers
;@ Adds the entity's height speed to its height (wEntityZ), the same way AddEntitySpeedToPos_19 does for x
;@ (it ends in that routine's code).
;@ test: skip needs a real entity slot (0-15); random slots run into unmapped memory
AddEntityZSpeedToPos_19::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0: return
	and a
	jr z, AddEntitySpeedToPos_19.done
;> acc = wEntitySpeedZAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
;> wEntitySpeedZAcc[slot] = u8(acc)
	ld [hl], a
	rl d
;> whole = (speed >> 4) | (0xF0 if speed & 0x80 else 0)   # (in AddEntitySpeedToPos_19's code)
;> wEntityZ[slot] = u8(wEntityZ[slot] + whole + (acc >> 8))
	ld hl, wEntityZ
	jr AddEntitySpeedToPos_19.addWhole

;@ def GetLinkXDistance_19(slot: bc) -> (d, e)
;@ path: entity/helpers
;@ d = Link's x minus the entity's x (signed), e = the direction towards Link on that axis (0 right,
;@ 1 left).
;@ test: slot = rand(0, 15)
GetLinkXDistance_19::
;> dx = u8(hLinkX - wEntityX[slot])
	ld e, $00
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> return dx, (1 if dx & 0x80 else 0)
	bit 7, a
	jr z, .right
	inc e
.right
	ld d, a
	ret


;@ def GetLinkYDistance_19(slot: bc) -> (d, e)
;@ path: entity/helpers
;@ d = Link's y minus the entity's y (signed), e = the direction towards Link on that axis (2 up, 3 down).
;@ test: slot = rand(0, 15)
GetLinkYDistance_19::
;> dy = u8(hLinkY - wEntityY[slot])
	ld e, $02
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> return dy, (2 if dy & 0x80 else 3)
	bit 7, a
	jr nz, .up
	inc e
.up
	ld d, a
	ret


;@ def UnusedLinkDrawYDifference_19() -> (d, e)
;@ path: unused/entity
;@ Like GetLinkYDistance_19 but measured from the entity's drawn y (hActiveEntityDrawY). Nothing calls it.
UnusedLinkDrawYDifference_19::
;> dy = u8(hLinkY - hActiveEntityDrawY)
	ld e, $02
	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
;> return dy, (2 if dy & 0x80 else 3)
	bit 7, a
	jr nz, .up
	inc e
.up
	ld d, a
	ret

;@ def GetEntityDirectionToLink_19(slot: bc) -> e
;@ path: entity/helpers
;@ Direction from the entity towards Link along the axis on which he is farther away (0 right, 1 left,
;@ 2 up, 3 down). The horizontal and vertical directions are left in hMultiPurpose0 and hMultiPurpose1.
;@ test: slot = rand(0, 15)
GetEntityDirectionToLink_19::
;> dx, horizontal = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> hMultiPurpose0 = horizontal
	ld a, e
	ldh [hMultiPurpose0], a
;> ax = (0x100 - dx) & 0xFF if dx & 0x80 else dx
	ld a, d
	bit 7, a
	jr z, .xPositive
	cpl
	inc a
.xPositive
;> dy, vertical = GetLinkYDistance_19(slot)
	push af
	call GetLinkYDistance_19
;> hMultiPurpose1 = vertical
	ld a, e
	ldh [hMultiPurpose1], a
;> ay = (0x100 - dy) & 0xFF if dy & 0x80 else dy
	ld a, d
	bit 7, a
	jr z, .yPositive
	cpl
	inc a
.yPositive
;> if ay < ax: return hMultiPurpose0
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


;@ def ClearEntityStatus_19(slot: bc)
;@ path: entity/helpers
;@ Removes the entity: its slot becomes free.
;@ test: skip needs a real entity slot (0-15); random slots run into unmapped memory
ClearEntityStatus_19::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ def UnusedBossDeathSequence_19(slot: bc)
;@ path: unused/entity
;@ A copy of the standard boss death sequence (flashing, then explosions all over the boss, then the
;@ defeat): dispatches on wEntityPrivate2. Nothing in this bank uses it.
;@ test: skip dispatches through a jump table
UnusedBossDeathSequence_19::
;> return [UnusedBossDeathStart_19, UnusedBossDeathFlash_19, UnusedBossDeathExplode_19][wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00
	dw UnusedBossDeathStart_19
	dw UnusedBossDeathFlash_19
	dw UnusedBossDeathExplode_19

;@ def UnusedBossDeathStart_19(slot: bc)
;@ path: unused/entity
;@ Death step 0: the boss flashes for $A0 frames. (Its last three instructions, at +$0B, are also called as
;@ "next step".)
;@ test: skip needs a real entity slot (0-15); random slots run into unmapped memory
UnusedBossDeathStart_19::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret

;@ def UnusedBossDeathFlash_19(slot: bc)
;@ path: unused/entity
;@ Death step 1: when the timer runs out, $C0 more frames of flashing and the next step.
;@ test: skip calls into the middle of another routine
UnusedBossDeathFlash_19::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .wait
;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     wEntityPrivate2[slot] += 1
	call UnusedBossDeathStart_19 + $0B
.wait
	ret

;@ def UnusedBossDeathExplode_19(slot: bc)
;@ path: unused/entity
;@ Death step 2: explosions while the timer runs; at the end the screen shakes and the boss is defeated.
;@ test: skip calls routines in other banks
UnusedBossDeathExplode_19::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .explode
;>     PlayClinkNoise()                          # explosion sound, shake the screen
	call PlayClinkNoise
;>     SelectAreaMusicFar()
	call SelectAreaMusicFar
;>     return DefeatEntityWithDrop(slot)                   # the boss is defeated (bank 3)
	jp DefeatEntityWithDrop
.explode
;> UnusedBossDeathExplosions_19(t)
	call UnusedBossDeathExplosions_19
	ret
;@ def UnusedBossDeathExplosions_19(t: a)
;@ path: unused/entity
;@ Every 8th frame: an explosion cloud at a random place on the boss (up to 16 pixels left or right,
;@ 20 up or 12 down of its centre).
;@ test: skip calls the random number generator
UnusedBossDeathExplosions_19::
;> if t & 7: return
	and $07
	jr nz, .done
;> dx = (GetRandomByte() & 0x1F) - 0x10
	call GetRandomByte
	and $1f
	sub $10
;> hActiveEntityX = u8(hActiveEntityX + dx)
	ld e, a
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;> dy = (GetRandomByte() & 0x1F) - 0x14
	call GetRandomByte
	and $1f
	sub $14
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + dy)
	ld e, a
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;> UnusedSpawnExplosionCloud_19()
	call UnusedSpawnExplosionCloud_19
.done
	ret

;@ def UnusedSpawnExplosionCloud_19()
;@ path: unused/entity
;@ An explosion cloud effect (visual effect 2) where the entity is drawn, with noise sound $13; nothing
;@ happens while the game is paused (map screen, dialogue, room transition).
;@ test: skip enters ReturnIfNonInteractive_19 in the middle
UnusedSpawnExplosionCloud_19::
;> ReturnIfNonInteractive_19_afterStatusCheck()   # drops our caller when the game is paused
	call ReturnIfNonInteractive_19 + 6
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                             # start visual effect 2 there
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret

;@ def UnusedSpawnHeartContainer_19(slot: bc)
;@ path: unused/entity
;@ Replaces the boss with a heart container (entity $36) dropping from 8 pixels high; in side-view rooms
;@ it is meant to hop up instead, but the speed is written to the boss's own slot (bc), not the new one.
;@ test: skip spawns an entity
UnusedSpawnHeartContainer_19::
;> new, full = SpawnEntity(slot, 0x36)                    # spawn a heart container, slot in de
	ld a, $36
	call SpawnEntity
;> wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .topDown
;>     wEntitySpeedY[slot] = 0xF0           # (slot, not new)
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jr .done
;> else:
.topDown
;>     wEntitySpeedZ[new] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityZ[new] = 8
	ld hl, wEntityZ
	add hl, de
	ld [hl], $08
.done
;> ClearEntityStatus_19(slot)
	call ClearEntityStatus_19
;> hNoiseSfx = 0x1A
	ld hl, hNoiseSfx
	ld [hl], $1a
	ret

;@ def MarkRoomEventDone_19()
;@ path: entity/helpers
;@ Sets bit 5 in the current room's status byte (and in hRoomStatus), so the room's one-time event does not
;@ happen again. Indoor maps $06-$19 use the second group of 256 indoor rooms.
;@ test: wCurrentBank = $19
MarkRoomEventDone_19::
;> group = wIsIndoor
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
;> if 0x06 <= hMapId < 0x1A: group += 1
	ldh a, [hMapId]
	cp $1a
	jr nc, .add
	cp $06
	jr c, .add
	inc d
.add
;> p = wRoomStatus + group * 256 + hMapRoom
	add hl, de
;> mem[p] |= 0x20
	ld a, [hl]
	or $20
	ld [hl], a
;> hRoomStatus = mem[p]
	ldh [hRoomStatus], a
	ret

	; the rest of the bank is unused ($FF filler, 1405 bytes)
	ds 1405, $ff
