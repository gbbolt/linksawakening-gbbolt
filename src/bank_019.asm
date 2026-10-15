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
;>     DrawEntity8x16(StatueShardSprite)        # draw it
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
;> DrawEntityShadow()                              # (bank $15)
	call DrawEntityShadow
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer()                              # count down wEntityIgnoreHitsTimer
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits()                              # react to Link's weapons (bank 3)
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
;> EntityCheckWalls()                              # background collision (bank 3)
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
;> if mem[0xC19B]: return LiftableStatueResetPulls(slot)      # Link is busy (swinging his sword, ...)
	ld a, [$c19b]
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
;> hLinkAnimationState = mem[0x1E63 + d]    # Link's grabbing pose
	ld hl, $1e63
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;> if not hJoypadHeld & mem[0x1E67 + d]: return LiftableStatueResetPulls(slot)   # not pulling back
	ld hl, $1e67
	add hl, de
	ldh a, [hJoypadHeld]
	and [hl]
	jr z, LiftableStatueResetPulls
;> mem[0xC13C] = mem[0x1E6B + d]            # Link's pulling pose offsets
	ld hl, $1e6b
	add hl, de
	ld a, [hl]
	ld [$c13c], a
;> mem[0xC13B] = mem[0x1E6F + d]
	ld hl, $1e6f
	add hl, de
	ld a, [hl]
	ld [$c13b], a
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
	jr c, jr_019_4122
;> wEntityState[slot] = 2                   # lifted
	call IncrementEntityState
	ld [hl], $02
;> wEntityStatus[slot] = 7                  # carried by Link
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;> mem[0xC490 + slot] = 0
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
LiftableStatueResetPulls::
;> wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	ret

jr_019_4122:
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
;> EntityCheckWalls()                              # background collision
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
;> if wRoomEvent & 0x1F != 0x0B: return
	ld a, [wRoomEvent]
	and $1f
	cp $0b
	jr nz, .done
;> if 0x35 <= mem[0xC50D] < 0x3D: return TriggerRoomEvent()   # the room's event happens (chime)
	ld a, [$c50d]
	cp $35
	jr c, .second
	cp $3d
	jr c, .solved
.second
;> if 0x35 <= mem[0xC503] < 0x3D:
	ld a, [$c503]
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
;>@loop for i in range(6):                 # (i kept in hBGTilesRequestCopy)
	ld a, $00
.loop
	ldh [hBGTilesRequestCopy], a
;>     shard, full = SpawnEntity(0x9D)        # new entity; the statue's x, y, z are left in hMultiPurpose0/1/3
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
;>     offsetX = StatueShardOffsetX[i]
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, StatueShardOffsetX
	add hl, bc
;>     wEntityX[shard] = u8(hMultiPurpose0 + offsetX)
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     offsetY = StatueShardOffsetY[i]
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
;>     wEntitySpeedX[shard] = StatueShardSpeedX[i]
	ld hl, StatueShardSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[shard] = StatueShardSpeedY[i]
	ld hl, StatueShardSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[shard] = StatueShardSpeedZ[i]
	ld hl, StatueShardSpeedZ
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], a
;=@loop
	pop bc
	ldh a, [hBGTilesRequestCopy]
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
;> mem[0xC19D] = 1
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
	jp z, Jump_019_42de
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
	jr nz, Jump_019_42de
;> dx, _ = GetLinkXDistance_19(slot)
	call GetLinkXDistance_19
;> if u8(dx + 3) >= 6: return
	add $03
	cp $06
	jr nc, Jump_019_42de
;> dy, _ = GetLinkYDistance_19(slot)
	call GetLinkYDistance_19
;> if u8(dy + 3) >= 6: return
	add $03
	cp $06
	jr nc, Jump_019_42de
;> wEntityState[slot] += 1
	call IncrementEntityState
;> mem[0xC1C6] = 0x20
	ld a, $20
	ld [wHookshotOut], a
;> wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;> hJingle = 0x1C
	ld a, $1c
	ldh [hJingle], a

Jump_019_42de:
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
;> mem[0xC1A9] = 0
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
;> hLinkDirection = WarpSpinDirections[step]
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
;>     if t & 3 == 0 and fade != 0x0C:      # a step every 4 frames, up to step $0C
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
;> wBGPalette = WarpFadePalettes[i]
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
;> DrawEntity16x16(WarpSprite)
	ld de, WarpSprite
	call DrawEntity16x16
;> wEntityPhysicsFlags[slot] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
;> for phase in range(0, 8, 2):
	xor a
.loop
	ldh [hBGTilesRequestCopy], a
;>     DrawWarpOrbitSprite(phase)
	ld e, a
	call DrawWarpOrbitSprite
	ldh a, [hBGTilesRequestCopy]
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
;> hActiveEntityX = u8(hActiveEntityX + WarpOrbitOffsetX[step])
	ld hl, WarpOrbitOffsetX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + WarpOrbitOffsetY[step])
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
	ldh [hBGTilesRequestCopy], a
;>     DrawOverworldWarpSparkle(phase)
	ld e, a
	call DrawOverworldWarpSparkle
	ldh a, [hBGTilesRequestCopy]
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
;> hActiveEntityX = u8(hMultiPurposeE + OverworldSparkleOffsetX[step])
	ld hl, OverworldSparkleOffsetX
	add hl, de
	ldh a, [hMultiPurposeE]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hMultiPurposeF + OverworldSparkleOffsetY[step] + 4)
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
;> DrawEntity16x16(BoomerangSprites)
	ld de, BoomerangSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> PlayPeriodicNoiseSfx()                              # whirring sound
	call PlayPeriodicNoiseSfx
;> if hFrameCounter & 3 == 0:
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
;> EntityHitOtherEntities()                              # hit enemies it touches (bank 3)
	call EntityHitOtherEntities
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckObjectCollision()                              # wall collision (bank 3)
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
;>     SetEntitySpeedTowardsLink(8)                         # aim at Link with speed 8 (bank 3)
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
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .catch
;>     SetEntitySpeedTowardsLink(0x20)                      # aim at Link, speed $20
	ld a, $20
	call SetEntitySpeedTowardsLink
.catch
;> if EntityCheckContactDamage():                          # touching Link (bank 3)
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
;>     offX = SwordBeamOffsetX[d]
	ld hl, SwordBeamOffsetX
	add hl, de
;>     wEntityX[slot] = u8(hLinkX + offX)
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>     offY = SwordBeamOffsetY[d]
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
;>     return IncrementEntityState()                   # wEntityState += 1
	jp IncrementEntityState

.flying
;> DrawSwordBeam()
	call DrawSwordBeam
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> wProjectileWeaponType = 1
	ld a, $01
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities()                              # hit enemies (bank 3)
	call EntityHitOtherEntities
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckObjectCollision()                              # wall collision
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
	ld hl, $c520
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
;> DrawEntity16x16(GoriyaSprites)
	ld de, GoriyaSprites
	call DrawEntity16x16
;> SetWalkingSpriteVariant_19(slot)
	call SetWalkingSpriteVariant_19
;> if hFrameCounter & 0x3F == 0:
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
;> DrawEntity8x16(GoriyaItemSprites)
	ld de, GoriyaItemSprites
	call DrawEntity8x16
;> LoadEntityPosition()
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
;> DrawEntity16x16(MaskedMimicSprites)
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
;> EntityCheckHits()                              # touch damage / weapon hits (bank 3)
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
;> speedX = MaskedMimicSpeeds[pad & 3]
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
;> wEntitySpeedY[slot] = MaskedMimicSpeeds[3 + i]
	ld hl, MaskedMimicSpeeds + 3
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls()                              # walls
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
;> SetEntitySpriteVariant(base | frame)                  # wEntitySpriteVariant
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
;> DrawEntity16x16(DogSprites)
	ld de, DogSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> AddEntityZSpeedToPos_19(slot)
	call AddEntityZSpeedToPos_19
;> wEntitySpeedZ[slot] = u8(wEntitySpeedZ[slot] - 2)   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80             # kept in hBGTilesRequestCopy for the states
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
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
;>     if hFrameCounter & 0x3F == 0:
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
;>     EntityCheckWeaponHits()                          # react to Link's weapons (bank 3)
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
;> SetEntitySpriteVariant(0)                             # sprite variant 0
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
;>     wEntitySpeedX[slot] = DogHopSpeeds[i]
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
;>     wEntitySpeedY[slot] = DogHopSpeeds[j]
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
;> EntityCheckWalls()                              # walls
	call EntityCheckWalls
;> if not hBGTilesRequestCopy: return AnimateDog()   # still in the air
	ldh a, [hBGTilesRequestCopy]
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
;>     SetEntitySpeedTowardsLink(0x24)                      # aim at Link
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
;> SetEntitySpriteVariant((hFrameCounter >> 2) & 1)
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
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntityPhysicsFlags[slot] = 0x52
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $52
;> EntityCheckContactDamage()                              # touching Link: he gets hurt (bank 3)
	call EntityCheckContactDamage
;> wEntityPhysicsFlags[slot] = 0x92
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $92
;> if hBGTilesRequestCopy:                   # landed
	ldh a, [hBGTilesRequestCopy]
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
;>     return IncrementEntityState()                   # next state
	jp IncrementEntityState
.spawn
;> SpawnEggSongInstrument(i)
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
	ld [$d211], a
;> wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def EggSongDone(slot: bc)
;@ path: event/egg_song
;@ State 4: nothing more to do (the instruments take over).
EggSongDone::
;> return
	ret


;@ def SpawnEggSongInstrument(i: a)
;@ path: event/egg_song
;@ Makes instrument `i` (0-7) appear at its place on the ring around the egg, with a sound - if Link won it
;@ (bit 1 of wDungeonFlags[i]). The instrument is an entity $DE with wEntityPrivate1 = 1 and sprite variant i.
;@ test: skip spawns an entity
SpawnEggSongInstrument::
;> flags = wDungeonFlags[i]                 # (i kept in hBGTilesRequestCopy)
	ldh [hBGTilesRequestCopy], a
	ld e, a
	ld d, b
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
;> if not flags & 0x02: return              # Link does not have it
	and $02
	jr z, .done
;> new, full = SpawnEntity(0xDE)
	ld a, $de
	call SpawnEntity
;> if full: return
	ret c
;> hNoiseSfx = 0x2B
	ld a, $2b
	ldh [hNoiseSfx], a
;> spawnX = InstrumentSpawnX[i]
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, InstrumentSpawnX
	add hl, bc
	ld a, [hl]
;> wEntityX[new] = spawnX + 8
	ld hl, wEntityX
	add hl, de
	add $08
	ld [hl], a
;> wEntityY[new] = InstrumentSpawnY[i]
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
;>         if phase & 3 == 0: return        # its turn to blink off
	and $03
	ret z
;>         return DrawEntity16x16(InstrumentSprites)
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
;> mem[0xD736] = 0xC1                       # the egg opens: two of the room's objects change
	ld a, $c1
	ld [$d736], a
;> mem[0xD746] = 0xCB
	ld a, $cb
	ld [$d746], a
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
;> SpawnEggShards()
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
;> DrawEntity8x16(EggShardSprite)
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

;@ def SpawnEggShards()
;@ path: event/egg_song
;@ Eight egg shards (entity $DE, wEntityPrivate1 = 2) burst from the egg at (x $54, y $3C) plus the
;@ EggShard* offsets and speeds, each with a random life of $30-$4F frames.
;@ test: skip spawns entities
SpawnEggShards::
;>@loop for i in range(8):
	xor a
.loop
	ldh [hBGTilesRequestCopy], a
;>     new, full = SpawnEntity(0xDE)
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
;>     offX = EggShardOffsetX[i]
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, EggShardOffsetX
	add hl, bc
	ld a, [hl]
;>     wEntityX[new] = offX + 0x54
	ld hl, wEntityX
	add hl, de
	add $54
	ld [hl], a
;>     offY = EggShardOffsetY[i]
	ld hl, EggShardOffsetY
	add hl, bc
	ld a, [hl]
;>     wEntityY[new] = offY + 0x3C
	ld hl, wEntityY
	add hl, de
	add $3c
	ld [hl], a
;>     wEntitySpeedX[new] = EggShardSpeedX[i]
	ld hl, EggShardSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     speedY = EggShardSpeedY[i]
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
	ldh a, [hBGTilesRequestCopy]
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
;>     DrawEntity16x16(BookSprites - 2)
	ld de, BookSprites - 2
	call DrawEntity16x16
	jr .states
;> else:
.closed
;>     DrawEntity8x16(BookSprites)
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
;> SetEntitySpriteVariant(0)                             # closed
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
;> dialog = BookDialogs[book]
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
;> SetEntitySpriteVariant(1)                             # open
	ld a, $01
	call SetEntitySpriteVariant
;> if wDialogState: return
	ld a, [wDialogState]
	and a
	ret nz
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>@stop if wDialogAnswer: return SetEntitySpriteVariant(0)   # stop reading: closed again
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
;> wSmasherBallSlot = slot                  # (a shared slot variable: the spirit finds the grave here)
	ld a, c
	ld [wSmasherBallSlot], a
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
;> spirit, _ = SpawnEntity(0xDC)
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
;> return IncrementEntityState()                       # next state
	jp IncrementEntityState

	db $c9                                  ; a stray `ret` nothing reaches

;@ def DrawRoosterGrave(slot: bc)
;@ path: event/flying_rooster
;@ Draws the grave and keeps Link out of it (also grave state 1, while the spirit flies).
;@ test: skip draws sprites
DrawRoosterGrave::
;> DrawEntity16x16(RoosterGraveSprites)
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
;>     bomb, _ = SpawnEntity(0x02)
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
;> return IncrementEntityState()                       # wEntityState += 1
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
;> rooster, _ = SpawnEntity(0xD5)
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
;> DrawEntity8x16(RoosterSpiritSprites)
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
;>     return SetEntitySpriteVariant(RoosterSpiritTrailFrames[age])
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
;> if wEntityPrivateCounter[slot] & 7 == 0:
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
;>         grave = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
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
;> direction = RoosterSpiritPath[wEntityPrivate2[slot]]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, RoosterSpiritPath
	add hl, de
;> speedX = RoosterSpiritSpeedX[direction]
	ld e, [hl]
	ld hl, RoosterSpiritSpeedX
	add hl, de
	ld a, [hl]
;> wEntitySpeedX[slot] = speedX
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = RoosterSpiritSpeedY[direction]
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
;> trail, full = SpawnEntity(0xDC)            # leave a trail copy
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
;> DrawEntity16x16(RoosterSprites)
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
;> if hFrameCounter & 0x7F == 0:
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
;> SetEntitySpriteVariant(wEntityDirection[slot] + frame)
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	add [hl]
	call SetEntitySpriteVariant
;> if hFrameCounter & 0x3F == 0x0F:
	ldh a, [hFrameCounter]
	and $3f
	cp $0f
	jr nz, .talk
;>     new, full = SpawnEntity(0x08)
	ld a, $08
	call SpawnEntity
;>     if full: return
	jr c, .done
;>     offset = RoosterPeckOffsetX[wEntityDirection[slot] >> 1]
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
;> bob = RoosterFlyHeights[i]
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
;> SetEntitySpriteVariant(facing + wing)                 # the lower pair (drawn from the next frame on)
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
;> DrawEntity16x16(RoosterSprites + 0x20)         # variants 8-11: the wings, tiles $70-$76
	ld de, RoosterSprites + $20
	call DrawEntity16x16
;> LoadEntityPosition()
	call LoadEntityPosition
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> if hFrameCounter & 0x3F == 0 and GetRandomByte() & 1 == 0:   # now and then
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
;>     wEntitySpeedX[slot] = RoosterFlySpeedX[i]
	ld hl, RoosterFlySpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = RoosterFlySpeedY[i]
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
;> mask = RoosterFlyMoveMasks[i & 7]
	and $07
	ld e, a
	ld d, b
	ld hl, RoosterFlyMoveMasks
	add hl, de
;> if hFrameCounter & mask == 0: UpdateEntityPosWithSpeed_19(slot)
	ldh a, [hFrameCounter]
	and [hl]
	call z, UpdateEntityPosWithSpeed_19
;> EntityCheckWalls()                              # walls
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
;> mem[0xD746] = 0x0C                       # the room objects under the weathervane
	ld hl, $d746
	ld [hl], $0c
;> mem[0xD756] = 0xC6
	ld hl, $d756
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
;> mem[0xD736] = 0x91                       # the uncovered stairs
	ld hl, $d736
	ld [hl], $91
;> mem[0xD746] = 0x5E
	ld hl, $d746
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
;> hActiveEntityTileOffset = GiantBubbleTileOffsets[i]
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
;> EntityCheckContactDamage()
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_19(slot)
	call UpdateEntityPosWithSpeed_19
;> EntityCheckWalls()
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
;> return IncrementEntityState()
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
	jr nz, jr_019_53c2
;> if wPodobooCountPrev >= 2: return
	ld a, [wPodobooCountPrev]
	cp $02
	ret nc
;> wEntitySpeedY[slot] = 0xD0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $d0
;> IncrementEntityState()
	call IncrementEntityState
;> return SpawnPodobooSplash()

;@ def SpawnPodobooSplash()
;@ path: enemy/podoboo
;@ Two lava drops (entity $DA, wEntityPrivate1 = 2) jump out of the lava where the Podoboo is, one to each side
;@ (PodobooSplash* tables).
;@ test: skip spawns entities
SpawnPodobooSplash::
;>@loop for i in (1, 0):                  # (i kept in hMultiPurposeH)
	ld a, $01
.loop
	ldh [hMultiPurposeH], a
;>     drop, full = SpawnEntity(0xDA)       # the Podoboo's x / y are left in hMultiPurpose0 / 1
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
;>     offset = PodobooSplashOffsetX[i]
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
;>     wEntitySpeedX[drop] = PodobooSplashSpeedX[i]
	ld hl, PodobooSplashSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[drop] = PodobooSplashSpeedY[i]
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

jr_019_53c2:
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
;> DrawEntity16x16(PodobooSprites)
	ld de, PodobooSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_19()
	call ReturnIfNonInteractive_19
;> EntityCheckContactDamage()
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
;> SetEntitySpriteVariant(base + ((hFrameCounter >> 2) & 1))
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
;>     SpawnPodobooSplash()
	call SpawnPodobooSplash
.trail
;> if (hFrameCounter ^ slot) & 0x0F: return # every 16 frames
	ldh a, [hFrameCounter]
	xor c
	and $0f
	ret nz
;> flame, full = SpawnEntity(0xDA)
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
;>@drop     DrawEntity16x16(PodobooFlameSprites + 0x18)
;>@drop2     SetEntitySpriteVariant((hFrameCounter >> 2) & 1)
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
;>     DrawEntity16x16(PodobooFlameSprites)
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
RammableBlockSprites::
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20
	db $10, $00, $54, $00, $10, $08, $56, $00, $10, $10, $56, $20, $10, $18, $54, $20

RammableBlockHandler::
	ldh a, [hActiveEntitySpriteVariant]
	and a
	ld a, $00
	jr z, jr_019_54ca

	ld a, $08

jr_019_54ca:
	ldh [hActiveEntityTileOffset], a
	ld hl, $54a1
	ld c, $08
	call DrawEntitySprites
	call ReturnIfNonInteractive_19
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	rst $00

RammableBlockStates::
	dw RammableBlockWaitForRam
	dw RammableBlockFall
	dw RammableBlockLanded

RammableBlockWaitForRam::
	call PushLinkOutOfEntity_19
	ret nc

	and a
	ret z

	call ResetSpinAttackAndDash
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedX], a
	ld a, $e8
	ldh [hLinkSpeedY], a
	call GetEntityTimer
	ld [hl], $20
	ld a, $01
	call SetEntitySpriteVariant
	ld a, $0b
	ldh [hJingle], a
	jp IncrementEntityState


RammableBlockFall::
	call GetEntityTimer
	cp $01
	jr nz, jr_019_5517

	ld hl, hJingle
	ld [hl], $08

jr_019_5517:
	and a
	ret nz

	call UpdateEntityYPosWithSpeed_19
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_019_5528

	add $03
	ld [hl], a

jr_019_5528:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	ldh a, [hActiveEntityY]
	add $10
	ldh [hActiveEntityY], a
	call EntityCheckWalls
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hActiveEntityY], a
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_5564

	call PlayClinkNoise
	call GetEntityTimer
	ld [hl], $30
	ld a, $30
	ld [wBumpShakeTimer], a
	ld a, $04
	ld [wBumpShakeAxis], a
	call IncrementEntityState

jr_019_5564:
	ret


RammableBlockLanded::
	call SideViewBlockLinkCollision
	ret


DirectionFromShallowVector::
	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
DirectionFromSteepVector::
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

GetDirectionFromVector::
	ldh a, [hMultiPurpose0]
	rlca
	and $01
	ld e, a
	ldh a, [hMultiPurpose1]
	rlca
	rla
	and $02
	or e
	rla
	rla
	rla
	and $18
	ld h, a
	ldh a, [hMultiPurpose1]
	bit 7, a
	jr z, jr_019_55c4

	cpl
	inc a

jr_019_55c4:
	ld d, a
	ldh a, [hMultiPurpose0]
	bit 7, a
	jr z, jr_019_55cd

	cpl
	inc a

jr_019_55cd:
	cp d
	jr nc, jr_019_55dd

	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $5569
	add hl, de
	ld a, [hl]
	ret


jr_019_55dd:
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $5589
	add hl, de
	ld a, [hl]
	ret


ThwimpSprites::
	db $5a, $00, $5a, $20, $58, $00, $58, $20

ThwimpHandler::
	ld de, $55eb
	call DrawEntity16x16
	call ReturnIfNonInteractive_19
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckHits
	xor a
	call SetEntitySpriteVariant
	ldh a, [hActiveEntityState]
	rst $00

ThwimpStates::
	dw ThwimpInit
	dw ThwimpWait
	dw ThwimpFall
	dw ThwimpRise

ThwimpInit::
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	call IncrementEntityState

ThwimpWait::
	call GetEntityTimer
	ret nz

	call GetLinkXDistance_19
	ld e, a
	add $28
	cp $50
	jr nc, jr_019_5640

	ld a, $01
	call SetEntitySpriteVariant
	ld a, e
	add $18
	cp $30
	jr nc, jr_019_5640

	call ClearEntitySpeed
	call GetEntityTimer
	ld [hl], $08
	call IncrementEntityState

jr_019_5640:
	ret


ThwimpFall::
	ld a, $01
	call SetEntitySpriteVariant
	call GetEntityTimer
	cp $01
	jr nz, jr_019_5652

	ld hl, hJingle
	ld [hl], $08

jr_019_5652:
	and a
	ret nz

	call UpdateEntityYPosWithSpeed_19
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_019_5663

	add $03
	ld [hl], a

jr_019_5663:
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_567a

	ld a, $09
	ldh [hJingle], a
	call GetEntityTimer
	ld [hl], $30
	call IncrementEntityState

jr_019_567a:
	ret


ThwimpRise::
	call GetEntityTimer
	ret nz

	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr nz, jr_019_5692

	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer
	ld [hl], $20
	ret


jr_019_5692:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f8
	call UpdateEntityYPosWithSpeed_19
	ret


ThwompSprites::
	db $00, $00, $70, $00, $00, $08, $72, $00, $00, $10, $72, $20, $00, $18, $70, $20
	db $10, $00, $74, $00, $10, $08, $76, $00, $10, $10, $76, $20, $10, $18, $74, $20
ThwompFaceSprites::
	db $ff, $00, $ff, $00, $6e, $00, $7e, $00, $7a, $00, $7a, $20, $7e, $20, $6e, $20
	db $7e, $20, $7c, $20, $7e, $20, $6c, $20, $78, $00, $78, $20, $6c, $00, $7e, $00
	db $7c, $00, $7e, $00

ThwompEyeVariants::
	db $04, $05, $06, $07, $08, $01, $02, $03

ThwompHandler::
	ldh a, [hActiveEntityDrawY]
	add $08
	ldh [hActiveEntityDrawY], a
	ldh a, [hActiveEntityX]
	add $08
	ldh [hActiveEntityX], a
	ld de, $56bc
	call DrawEntity16x16
	call LoadEntityPosition
	ld hl, $569c
	ld c, $08
	call DrawEntitySprites
	ld a, $06
	call ReserveOAMEntriesFar
	call ReturnIfNonInteractive_19
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckWeaponHits
	call SideViewBlockLinkCollision
	ldh a, [hActiveEntityState]
	rst $00

ThwompStates::
	dw ThwompInit
	dw ThwompWait
	dw ThwompFall
	dw ThwompRise

ThwompInit::
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	call IncrementEntityState

ThwompWait::
	call GetEntityTimer
	ret nz

	call GetLinkXDistance_19
	add $f8
	ld e, a
	add $28
	cp $50
	jr nc, jr_019_5752

	ld a, e
	add $18
	cp $30
	jr nc, jr_019_5752

	call ClearEntitySpeed
	ld a, $08
	ldh [hJingle], a
	ld a, $00
	call SetEntitySpriteVariant
	call IncrementEntityState
	ret


jr_019_5752:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_019_576d

	ld a, $1f
	call GetVectorTowardsLink
	call GetDirectionFromVector
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $56e0
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant

jr_019_576d:
	ret


ThwompFall::
	call UpdateEntityYPosWithSpeed_19
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_019_577d

	add $03
	ld [hl], a

jr_019_577d:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	ldh a, [hActiveEntityY]
	add $10
	ldh [hActiveEntityY], a
	call EntityCheckWalls
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hActiveEntityY], a
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_57b9

	call PlayClinkNoise
	call GetEntityTimer
	ld [hl], $30
	ld a, $30
	ld [wBumpShakeTimer], a
	ld a, $04
	ld [wBumpShakeAxis], a
	call IncrementEntityState

jr_019_57b9:
	ret


ThwompRise::
	call GetEntityTimer
	ret nz

	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr nz, jr_019_57d2

	call IncrementEntityState
	ld [hl], $01
	call GetEntityTimer
	ld [hl], $20
	ret


jr_019_57d2:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f8
	call UpdateEntityYPosWithSpeed_19
	ret


SideViewBlockLinkCollision::
	call EntityTouchesLink
	ret nc

	call GetLinkYDistance_19
	add $08
	bit 7, a
	jr nz, jr_019_57fa

	call BounceLinkBack
	ld a, $10
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
	ret


jr_019_57fa:
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, jr_019_5812

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [hLinkY], a
	ld a, $02
	ldh [hLinkSpeedY], a
	ld a, $01
	ld [wLinkOnPlatform], a

jr_019_5812:
	ret


SideViewPotSprite::
	db $5e, $00, $5e, $20

SideViewPotHandler::
	ld de, $5813
	call DrawEntity16x16
	call ReturnIfNonInteractive_19
	ldh a, [hActiveEntityState]
	rst $00

SideViewPotStates::
	dw SideViewPotIdle
	dw SideViewPotThrown
	dw SideViewPotThrown

SideViewPotIdle::
	call EntityTouchesLink
	jr nc, jr_019_585c

	call GetLinkYDistance_19
	ld e, a
	add $03
	cp $06
	jr nc, jr_019_583b

	call PushLinkSidewaysFromPot

jr_019_583b:
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, jr_019_585c

	call GetLinkYDistance_19
	add $08
	bit 7, a
	jr z, jr_019_585c

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [hLinkY], a
	ld a, $02
	ldh [hLinkSpeedY], a
	ld a, $01
	ld [wLinkOnPlatform], a

jr_019_585c:
	call GetLinkXDistance_19
	add $12
	cp $24
	ret nc

	call GetLinkYDistance_19
	add $12
	cp $24
	ret nc

	ld a, [wItemUsePoseTimer]
	and a
	ret nz

	ld a, [wItemB]
	cp $03
	jr nz, jr_019_587f

	ldh a, [hJoypadPressed]
	and $20
	jr nz, jr_019_588a

	ret


jr_019_587f:
	ld a, [wItemA]
	cp $03
	ret nz

	ldh a, [hJoypadPressed]
	and $10
	ret z

jr_019_588a:
	ld a, [wLinkIsCarrying]
	and a
	ret nz

	inc a
	ld [wLinkIsCarrying], a
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
	call GetEntityTimer
	ld [hl], $02
	ld hl, hWaveSfx
	ld [hl], $02
	call IncrementEntityState
	ld [hl], $02
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
	ret


SideViewPotThrown::
	call UpdateEntityPosWithSpeed_19
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, jr_019_58c3

	cp $40
	jr nc, jr_019_58c5

jr_019_58c3:
	inc [hl]
	inc [hl]

jr_019_58c5:
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_58d6

	call Call_3E64
	call ClearEntityStatus_19

jr_019_58d6:
	ret


PushLinkSidewaysFromPot::
	call ResetPegasusBoots
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_019_58f3

	ld a, $02
	ld [wLinkPushedTimer], a
	call GetLinkXDistance_19
	ld a, e
	and a
	ld a, $10
	jr z, jr_019_58f0

	ld a, $f0

jr_019_58f0:
	ldh [hLinkSpeedX], a
	ret


jr_019_58f3:
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
	ret


RoosterCompanionSprites::
	db $42, $20, $40, $20, $46, $20, $44, $20, $40, $00, $42, $00, $44, $00, $46, $00
	db $4c, $00, $4c, $20, $4e, $00, $4e, $20, $48, $00, $48, $20, $4a, $00, $4a, $20

Call_19_5918::
	ld a, [wIsRoosterFollowingLink]
	and a
	jp z, ClearEntityStatus_19

	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
	ld hl, wEntityPosXHigh
	add hl, bc
	ld [hl], b
	ld hl, wEntityPosYHigh
	add hl, bc
	ld [hl], b
	ld de, $58f8
	call DrawEntity16x16
	ldh a, [hActiveEntityStatus]
	cp $07
	jp z, Jump_019_5a78

	ld a, [wLinkMotionState]
	cp $01
	jr nz, jr_019_5949

	call Call_19_5A3C
	jr jr_019_596d

jr_019_5949:
	call AddEntityZSpeedToPos_19
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_5971

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
	ld a, [wIsLinkInTheAir]
	ld e, a
	ld a, [wIsUsingPegasusBoots]
	or e
	jr z, jr_019_596d

	ld [hl], $20

jr_019_596d:
	call IncrementEntityState
	ld [hl], b

jr_019_5971:
	call ReturnIfNonInteractive_19
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_019_59c1

	call GetEntityDirectionToLink_19
	sla e
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant
	call GetLinkXDistance_19
	add $12
	cp $24
	jr nc, jr_019_599b

	call GetLinkYDistance_19
	add $12
	cp $24
	jr c, jr_019_59db

jr_019_599b:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_019_59bb

	ld a, [wIsUsingPegasusBoots]
	and a
	ld a, $0c
	jr z, jr_019_59ab

	ld a, $20

jr_019_59ab:
	ld e, a
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	push af
	push hl
	ld [hl], b
	ld a, e
	call SetEntitySpeedTowardsLink
	pop hl
	pop af
	ld [hl], a

jr_019_59bb:
	call UpdateEntityPosWithSpeed_19
	jp EntityCheckWalls


jr_019_59c1:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_59cc

	inc [hl]
	inc [hl]

jr_019_59cc:
	dec [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_59d8

	inc [hl]
	inc [hl]

jr_019_59d8:
	dec [hl]
	jr jr_019_59bb

jr_019_59db:
	call ClearEntitySpeed
	call EntityTouchesLink
	ret nc

	ld a, [wItemUsePoseTimer]
	and a
	ret nz

	ld a, [wItemB]
	cp $03
	jr nz, jr_019_59f5

	ldh a, [hJoypadPressed]
	and $20
	jr nz, jr_019_5a00

	ret


jr_019_59f5:
	ld a, [wItemA]
	cp $03
	ret nz

	ldh a, [hJoypadPressed]
	and $10
	ret z

jr_019_5a00:
	ld a, [wLinkMotionState]
	cp $02
	ret nc

	ld a, [wLinkIsCarrying]
	and a
	ret nz

	ld [wLinkMotionState], a
	inc a
	ld [wLinkIsCarrying], a
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
	call GetEntityTimer
	ld [hl], $02
	ld hl, hWaveSfx
	ld [hl], $02
	call IncrementEntityState
	ld [hl], $01
	ld a, $02
	ldh [hLinkPositionZ], a
	ld [wIsLinkInTheAir], a
	ret


RoosterHoverHeights::
	db $06, $07, $08, $09, $09, $08, $07, $06

Call_19_5A3C::
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5a34
	add hl, de
	ld e, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub e
	ret z

	ld e, a
	ldh a, [hFrameCounter]
	and $01
	ret nz

	ld a, e
	and $80
	jr z, jr_019_5a63

	inc [hl]
	inc [hl]

jr_019_5a63:
	dec [hl]
	ret


RoosterPadDirections::
	db $0f, $00, $01, $0f, $02, $0f, $0f, $0f, $03, $0f, $0f

RoosterCarryHeights::
	db $14, $14, $15, $16, $17
	db $17, $16, $15

Jump_019_5a78:
	ldh a, [hLinkDirection]
	rla
	and $06
	ld e, a
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant
	ld a, $02
	ld [wIsLinkInTheAir], a
	xor a
	ldh [hLinkSpeedZ], a
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_019_5ab1

	ldh a, [hFrameCounter]
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5a70
	add hl, de
	ld e, [hl]
	ld hl, hLinkPositionZ
	ld a, [hl]
	sub e
	jr z, jr_019_5ab1

	and $80
	jr z, jr_019_5ab0

	inc [hl]
	inc [hl]

jr_019_5ab0:
	dec [hl]

jr_019_5ab1:
	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, b
	ld hl, $5a65
	add hl, de
	ld a, [hl]
	cp $0f
	jr z, jr_019_5ac5

	ldh [hLinkDirection], a
	ld [wLiftDirection], a

jr_019_5ac5:
	ld a, [wLinkCollisionFlags]
	and $03
	jr z, jr_019_5acf

	xor a
	ldh [hLinkSpeedY], a

jr_019_5acf:
	ld a, [wLinkCollisionFlags]
	and $0c
	jr z, jr_019_5ad9

	xor a
	ldh [hLinkSpeedX], a

jr_019_5ad9:
	call PlayPeriodicNoiseSfx
	ret


FrogSprites::
	db $64, $00, $64, $20, $66, $00, $66, $20, $60, $00, $60, $20, $62, $00, $62, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_19_5AFD::
	ld de, $5add
	call DrawEntity16x16
	call ReturnIfNonInteractive_19
	call UpdateEntityPosWithSpeed_19
	call AddEntityZSpeedToPos_19
	call EntityCheckWalls
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_019_5b26

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_019_5b26:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_5B29::
	dw Jump_19_5B45
	dw Jump_19_5B87

FrogHopSpeedX::
	db $00, $10, $00, $f0, $0c, $0c, $f4, $f4

FrogHopSpeedY::
	db $f0, $00, $10, $00, $f4, $0c, $0c, $f4
FrogHopDirections::
	db $00, $06, $02, $04, $00, $06, $02, $04

Jump_19_5B45::
	call GetEntityTimer
	jr nz, jr_019_5b7e

	call IncrementEntityState
	call GetRandomByte
	and $1f
	or $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $5b2d
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $5b35
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $5b3d
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_019_5b7e:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


Jump_19_5B87::
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_019_5b9f

	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
	call ClearEntitySpeed
	call IncrementEntityState
	ld [hl], b
	ret


jr_019_5b9f:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	call SetEntitySpriteVariant
	ret


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
LinkMotionWarpHoleRise::
	db $3e, $01, $e0, $a1, $ea, $67, $c1, $cd, $95, $14, $f0, $9c, $c7

WarpHoleRiseSteps::
	db $bc, $5c, $ce
	db $5c, $ec, $5c

WarpHoleRiseWait::
	db $f0, $b7, $a7, $20, $08, $3e, $01, $e0, $9c, $3e, $25, $e0, $f2
	db $c9

WarpHoleSpinDirections::
	db $00, $03, $01, $02

WarpHoleRiseSpin::
	db $f0, $b7, $a7, $20, $05, $3e, $02, $e0, $9c, $c9

SpinLinkInWarpHole::
	db $f0
	db $e7, $1f, $1f, $e6, $03, $5f, $16, $00, $21, $ca, $5c, $19, $7e, $e0, $9e, $cd
	db $7c, $08, $c9

WarpHoleRiseUp::
	db $cd, $d8, $5c, $f0, $a2, $c6, $04, $e0, $a2, $fe, $78, $38, $3e
	db $ea, $c8, $db, $f0, $f6, $5f, $16, $00, $21, $a9, $5b, $19, $5e, $21, $00, $d8
	db $19, $7e, $e6, $80, $28, $f2, $7b, $ea, $03, $d4, $af, $ea, $01, $d4, $ea, $02
	db $d4, $3e, $70, $ea, $05, $d4, $e0, $99, $3e, $68, $ea, $04, $d4, $e0, $98, $ea
	db $75, $d4, $3e, $66, $ea, $16, $d4, $cd, $0f, $09, $af, $ea, $67, $c1, $c9

GhostSprites::
	db $42
	db $20, $40, $20, $46, $20, $44, $20, $40, $00, $42, $00, $44, $00, $46, $00, $48
	db $00, $4a, $00, $4c, $00, $4e, $00

GhostBobHeights::
	db $10, $11, $12, $13, $13, $12, $11, $10

Call_19_5D58::
	ld a, [wIsGhostFollowingLink]
	cp $01
	jp nz, ClearEntityStatus_19

	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
	ld hl, wEntityPosXHigh
	add hl, bc
	ld [hl], b
	ld hl, wEntityPosYHigh
	add hl, bc
	ld [hl], b
	ldh a, [hFrameCounter]
	xor c
	and $01
	jr nz, jr_019_5d7e

	ld de, $5d38
	call DrawEntity16x16

jr_019_5d7e:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_5d9b

	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5d50
	add hl, de
	ld a, [hl]
	sub $04
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a

jr_019_5d9b:
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_019_5def

	call GetEntityDirectionToLink_19
	ld a, e
	cp $02
	ld e, $04
	jr z, jr_019_5daf

	call GetLinkXDistance_19
	sla e

jr_019_5daf:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant
	call GetLinkXDistance_19
	add $18
	cp $30
	jr nc, jr_019_5dd9

	ldh a, [hLinkY]
	push af
	add $0c
	ldh [hLinkY], a
	call GetLinkYDistance_19
	ld e, a
	pop af
	ldh [hLinkY], a
	ld a, e
	add $18
	cp $30
	jr c, jr_019_5def

jr_019_5dd9:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_019_5dec

	ld a, [wIsUsingPegasusBoots]
	and a
	ld a, $08
	jr z, jr_019_5de9

	ld a, $18

jr_019_5de9:
	call SetEntitySpeedTowardsLink

jr_019_5dec:
	call UpdateEntityPosWithSpeed_19

jr_019_5def:
	ld a, [wIsIndoor]
	and a
	jp nz, Jump_019_5f02

	ld a, [$db7a]
	and a
	jp z, Jump_019_5ea1

	ldh a, [hMapRoom]
	cp $64
	jp nz, Jump_019_5ec7

	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_5E07::
	dw Jump_19_5E0D
	dw Jump_19_5E20
	dw Jump_19_5E7D

Jump_19_5E0D::
	call ReturnIfNonInteractive_19
	ldh a, [hLinkX]
	cp $3c
	ret nc

	ldh a, [hLinkY]
	cp $7a
	ret nc

	ld [wLinkFrozen], a
	jp IncrementEntityState


Jump_19_5E20::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ldh a, [hLinkY]
	push af
	ldh a, [hLinkX]
	push af
	ld hl, wEntityZ
	add hl, bc
	ld a, $60
	sub [hl]
	ldh [hLinkY], a
	ld a, $28
	ldh [hLinkX], a
	ld a, $08
	call SetEntitySpeedTowardsLink
	call GetLinkXDistance_19
	push af
	ld a, e
	sla a
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	pop af
	add $03
	cp $06
	jr nc, jr_019_5e70

	call GetLinkYDistance_19
	add $0c
	cp $18
	jr nc, jr_019_5e70

	pop af
	ldh [hLinkX], a
	pop af
	ldh [hLinkY], a
	ld a, $16
	call OpenDialogTable2
	ld a, $2d
	ldh [hJingle], a
	call IncrementEntityState
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


jr_019_5e70:
	pop af
	ldh [hLinkX], a
	pop af
	ldh [hLinkY], a
	call UpdateEntityPosWithSpeed_19
	call Call_19_5F96
	ret


Jump_19_5E7D::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call ReturnIfNonInteractive_19
	ld hl, wEntityZ
	add hl, bc
	dec [hl]
	jr nz, jr_019_5e9d

	xor a
	ld [wIsGhostFollowingLink], a
	ld [$db7a], a
	ld [wLinkFrozen], a
	ld hl, $d9e3
	set 6, [hl]
	jp ClearEntityStatus_19


jr_019_5e9d:
	call Call_19_5F96
	ret


Jump_019_5ea1:
	call ReturnIfNonInteractive_19
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ldh a, [hMapRoom]
	cp $f6
	jp nz, Jump_019_5ec7

	ldh a, [hLinkY]
	cp $40
	ret c

	ldh a, [hLinkX]
	cp $78
	ret nc

	inc [hl]
	ld a, $2d
	ldh [hJingle], a
	ld a, $13
	call OpenDialogTable2
	ret


Jump_019_5ec7:
	call ReturnIfNonInteractive_19
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

	ldh a, [hFrameCounter]
	and $01
	ret nz

	ld hl, wEntityPrivate4
	add hl, bc
	dec [hl]
	ret nz

	call GetRandomByte
	and $03
	ld hl, wMarinSinging
	or [hl]
	ret nz

	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ld a, $2d
	ldh [hJingle], a
	ld a, [$db7a]
	and a
	ld a, $11
	jr z, jr_019_5eff

	ld a, $10

jr_019_5eff:
	jp OpenDialogTable2


Jump_019_5f02:
	call ReturnIfNonInteractive_19
	ldh a, [hMapId]
	cp $1e
	ret nz

	ldh a, [hMapRoom]
	cp $e3
	ret nz

	ldh a, [hRoomStatus]
	and $20
	ret nz

	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_5F1E::
	dw Jump_19_5F2A
	dw Jump_19_5F42
	dw Jump_19_5F7A
	dw Jump_19_5FA8
	dw Jump_19_5FC4
	dw Jump_19_5FEA

Jump_19_5F2A::
	call GetEntityTimer
	ld [hl], $40
	jp IncrementEntityState


	db $60, $28, $28, $68, $00, $f8, $fc, $08, $f8, $fc, $f8, $02, $04, $02, $04, $00

Jump_19_5F42::
	call GetEntityTimer
	jr nz, jr_019_5f78

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5f32
	add hl, de
	ld a, [hl]
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], a
	ld hl, $5f36
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $5f3a
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $5f3e
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	call IncrementEntityState

jr_019_5f78:
	jr Call_19_5F96

Jump_19_5F7A::
	call GetEntityTimer
	jr nz, jr_019_5f93

	ld [hl], $50
	call IncrementEntityState
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr z, jr_019_5f93

	call IncrementEntityState
	ld [hl], b

jr_019_5f93:
	call UpdateEntityPosWithSpeed_19

Call_19_5F96::
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant
	ret


Jump_19_5FA8::
	call GetEntityTimer
	jr nz, jr_019_5fc1

	ld [hl], $50
	ldh a, [hLinkY]
	push af
	ld a, $10
	ldh [hLinkY], a
	ld a, $14
	call OpenDialogTable2
	pop af
	ldh [hLinkY], a
	call IncrementEntityState

jr_019_5fc1:
	jp Call_19_5F96


Jump_19_5FC4::
	call GetEntityTimer
	jr nz, jr_019_5fd1

	ld a, $15
	call OpenDialogTable2
	call IncrementEntityState

jr_019_5fd1:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $0a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fc
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
	call UpdateEntityPosWithSpeed_19
	jp Call_19_5F96


	db $c9

Jump_19_5FEA::
	ld a, $01
	ld [$db7a], a
	call MarkRoomEventDone_19
	call ClearEntityStatus_19
	jp StartWarpFadeOutWithNoise


	db $00, $98, $06, $89, $00, $04, $00, $04, $00, $04, $00, $04, $00, $10, $98, $07
	db $89, $01, $11, $01, $11, $01, $11, $01, $11, $01, $11, $98, $08, $89, $07, $06
	db $07, $06, $07, $06, $07, $06, $07, $06, $98, $08, $89, $07, $06, $07, $06, $07
	db $06, $07, $06, $07, $06, $98, $09, $89, $06, $07, $06, $07, $06, $07, $06, $07
	db $06, $07, $98, $0a, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06, $98
	db $0b, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07, $98, $0b, $89, $06
	db $07, $06, $07, $06, $07, $06, $07, $06, $07, $98, $0c, $89, $07, $06, $07, $06
	db $07, $06, $07, $06, $07, $06, $98, $0d, $89, $06, $07, $06, $07, $06, $07, $06
	db $07, $06, $07, $98, $0e, $89, $02, $12, $02, $12, $02, $12, $02, $12, $02, $12
	db $98, $0f, $89, $03, $05, $03, $05, $03, $05, $03, $05, $03, $13, $98, $06, $89
	db $04, $00, $04, $00, $04, $00, $04, $00, $04, $14, $98, $07, $89, $11, $01, $11
	db $01, $11, $01, $11, $01, $11, $01, $98, $08, $89, $06, $07, $06, $07, $06, $07
	db $06, $07, $06, $07, $98, $08, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $07, $98, $09, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06, $98, $0a
	db $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07, $98, $0b, $89, $07, $06
	db $07, $06, $07, $06, $07, $06, $07, $06, $98, $0b, $89, $07, $06, $07, $06, $07
	db $06, $07, $06, $07, $06, $98, $0c, $89, $06, $07, $06, $07, $06, $07, $06, $07
	db $06, $07, $98, $0d, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06, $98
	db $0e, $89, $12, $02, $12, $02, $12, $02, $12, $02, $12, $02, $98, $0f, $89, $05
	db $03, $05, $03, $05, $03, $05, $03, $05, $15, $95, $60, $f9, $5f, $c9, $60, $2d
	db $60, $fd, $60, $61, $60

Jump_019_613d:
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call Call_19_63BE
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_614A::
	dw Jump_19_6158
	dw Jump_19_6163
	dw Jump_19_6199
	dw Jump_19_61A3
	dw Jump_19_61A8
	dw Jump_19_61DD
	dw Jump_19_6204

Jump_19_6158::
	call ResetSoundEngine
	call GetEntityTimer
	ld [hl], $ff
	call IncrementEntityState

Jump_19_6163::
	call GetEntityTimer
	jr nz, jr_019_6176

	ld [wScreenShakeX], a
	call SetEntitySpriteVariant
	ld a, $2e
	ldh [hJingle], a
	call IncrementEntityState
	ret


jr_019_6176:
	cp $a0
	jr nz, jr_019_617e

	ld a, $1d
	ldh [hNoiseSfx], a

jr_019_617e:
	jr c, jr_019_618c

	and $10
	ld a, $00
	jr z, jr_019_6188

	ld a, $ff

jr_019_6188:
	call SetEntitySpriteVariant
	ret


jr_019_618c:
	ld e, $01
	and $04
	jr z, jr_019_6194

	ld e, $fe

jr_019_6194:
	ld a, e
	ld [wScreenShakeX], a
	ret


Jump_19_6199::
	call GetEntityTimer
	and a
	jr nz, jr_019_61a2

	call IncrementEntityState

jr_019_61a2:
	ret


Jump_19_61A3::
	ld hl, $6131
	jr Call_19_61AB

Jump_19_61A8::
	ld hl, $6135

Call_19_61AB::
	push bc
	push hl
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rla
	and $02
	ld e, a
	ld d, b
	pop hl
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld c, $34
	ld hl, wDrawCommand

jr_019_61c1:
	dec de
	ld a, [de]
	inc de
	cp $98
	ld a, [de]
	jr nz, jr_019_61d1

	ldh a, [hBaseScrollX]
	and a
	ld a, [de]
	jr z, jr_019_61d1

	add $0c

jr_019_61d1:
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_61c1

	ld [hl], $00
	pop bc
	call IncrementEntityState
	ret


Jump_19_61DD::
	ld hl, $6139
	call Call_19_61AB
	call GetEntityTimer
	ld [hl], $18
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $0c
	jr nz, jr_019_61fe

	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a
	ret


jr_019_61fe:
	call IncrementEntityState
	ld [hl], $02
	ret


Jump_19_6204::
	call MarkRoomEventDone_19
	set 4, [hl]
	xor a
	ld [wScreenShakeX], a
	ld [wLinkFrozen], a
	ld a, $02
	ldh [hJingle], a
	ld a, $e1
	ld [$d736], a
	ld a, $77
	ld [$d746], a
	ld a, $77
	ld [$d756], a
	call Call_19_6269
	jp ClearEntityStatus_19


	db $98, $4a, $87, $0c, $1c, $64, $66, $0f, $0f, $0f, $0f, $98, $4b, $87, $0d, $1d
	db $65, $67, $1f, $1f, $1f, $1f, $98, $49, $81, $0b, $1b, $98, $4c, $81, $0e, $1e
	db $98, $56, $87, $0c, $1c, $64, $66, $0f, $0f, $0f, $0f, $98, $57, $87, $0d, $1d
	db $65, $67, $1f, $1f, $1f, $1f, $98, $55, $81, $0b, $1b, $98, $58, $81, $0e, $1e

Call_19_6269::
	ld a, $20
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	ld de, $6229
	ldh a, [hBaseScrollX]
	and a
	jr z, jr_019_627c

	ld de, $6249

jr_019_627c:
	push bc
	ld c, $20

jr_019_627f:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_627f

	pop bc
	ld [hl], b
	ret


	db $50, $5c, $68, $70, $7a, $7e, $58, $32, $38, $38, $40, $44, $50, $20, $20, $20
	db $20, $20, $1f, $1e, $1f, $20, $20, $20, $20, $20, $03, $03, $04, $04, $05, $05
	db $06, $01, $01, $02, $02, $03, $03, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $38, $3a
	db $3b, $44, $4c, $58, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $2f, $30, $30, $30, $30
	db $30, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $04, $00, $00
	db $70, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00
	db $72, $00, $00, $08, $74, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00
	db $76, $00, $00, $08, $78, $00, $00, $10, $7a, $00, $00, $00, $ff, $00, $00, $00
	db $7c, $00, $00, $08, $7e, $00, $00, $10, $7e, $20, $00, $18, $7c, $20, $00, $00
	db $7a, $20, $00, $08, $78, $20, $00, $10, $76, $20, $00, $00, $ff, $00, $00, $00
	db $74, $20, $00, $08, $72, $20, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $30
	db $70, $20, $00, $d8, $70, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00
	db $60, $10, $10, $00, $62, $00, $20, $00, $62, $00, $00, $00, $ff, $00, $00, $00
	db $ff, $00, $00, $00, $ff, $00, $00, $00, $64, $10, $10, $00, $66, $00, $20, $00
	db $66, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $02
	db $68, $10, $10, $02, $6a, $00, $20, $02, $6a, $00, $00, $05, $68, $30, $10, $05
	db $6a, $20, $20, $05, $6a, $20, $00, $01, $68, $10, $10, $01, $6a, $00, $20, $01
	db $6a, $00, $00, $07, $68, $30, $10, $07, $6a, $20, $20, $07, $6a, $20, $00, $00
	db $68, $10, $10, $00, $6a, $00, $20, $00, $6a, $00, $00, $08, $68, $30, $10, $08
	db $6a, $20, $20, $08, $6a, $20

Call_19_63BE::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6288
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, $6295
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, $62a2
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $62d6
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ld a, $02
	call ReserveOAMEntriesFar
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $62af
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, $62bc
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, $62c9
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	and $f0
	add e
	ld e, a
	ld d, b
	ld hl, $6346
	add hl, de
	ld c, $06
	call DrawEntitySprites
	ld a, $04
	call ReserveOAMEntriesFar
	ret


	db $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56, $98, $22, $09
	db $55, $56, $55, $56, $55, $56, $55, $56, $55, $56, $98, $42, $09, $0c, $0d, $0c
	db $0d, $0c, $0d, $0c, $0d, $0c, $0d, $98, $62, $09, $0e, $0f, $0e, $0f, $0e, $0f
	db $0e, $0f, $0e, $0f, $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55
	db $56, $98, $22, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56, $98, $42
	db $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $62, $09, $0f, $0e
	db $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98, $02, $09, $55, $56, $55, $56, $55
	db $56, $55, $56, $55, $56, $98, $22, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $0e, $0f, $98, $42, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98
	db $62, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $02, $09, $0e
	db $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $22, $09, $0f, $0e, $0f, $0e
	db $0f, $0e, $0f, $0e, $0f, $0e, $98, $42, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $0f, $0e, $0f, $98, $62, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $82, $09, $0f, $0e, $0f, $0f, $0f, $0e, $0f, $0e, $0f, $0e, $98, $a2, $09
	db $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $c2, $09, $0f, $0e, $0f
	db $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98, $e2, $09, $1e, $1e, $1e, $1e, $1e, $1e
	db $1e, $1e, $1e, $1e, $98, $82, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $0f, $98, $a2, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98, $c2
	db $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $98, $e2, $09, $09, $08
	db $18, $09, $7e, $7e, $09, $08, $18, $09, $98, $82, $09, $0e, $0f, $0e, $0f, $0e
	db $0f, $0e, $0f, $0e, $0f, $98, $a2, $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
	db $1e, $1e, $98, $c2, $09, $09, $08, $18, $09, $7e, $7e, $09, $08, $18, $09, $98
	db $e2, $09, $09, $04, $05, $09, $7e, $7e, $09, $04, $05, $09, $98, $82, $09, $1e
	db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $98, $a2, $09, $09, $08, $18, $09
	db $7e, $7e, $09, $08, $18, $09, $98, $c2, $09, $09, $04, $05, $09, $7e, $7e, $09
	db $04, $05, $09, $98, $e2, $09, $19, $14, $15, $19, $1f, $1f, $19, $14, $15, $19
	db $21, $64, $55, $64, $89, $64, $bd, $64, $f1, $64, $25, $65, $59, $65, $8d, $65

Jump_019_65d1:
	ldh a, [hMapRoom]
	cp $0e
	jp z, Jump_019_613d

	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_65E2::
	dw Jump_19_65EA
	dw Jump_19_65FB
	dw Jump_19_6624
	dw Jump_19_665F

Jump_19_65EA::
	ld a, $04
	ldh [hNoiseSfx], a
	call GetEntityTimer
	ld [hl], $ac
	call GetEntityTimer1
	ld [hl], $ac
	call IncrementEntityState

Jump_19_65FB::
	call GetEntityTimer
	cp $a0
	jr nz, jr_019_6607

	ld hl, hNoiseSfx
	ld [hl], $2e

jr_019_6607:
	and a
	jr nz, jr_019_6611

	ld a, $2f
	ldh [hJingle], a
	call IncrementEntityState

jr_019_6611:
	ld e, $01
	and $04
	jr z, jr_019_6619

	ld e, $fe

jr_019_6619:
	ld a, e
	ld [wScreenShakeX], a
	call GetEntityTimer1
	ret nz

	jp Jump_019_6705


Jump_19_6624::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	push af
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, $65c1
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	push bc
	ld c, $34
	ld hl, wDrawCommand

jr_019_663c:
	ld a, [de]
	cp $98
	jr nz, jr_019_664a

	ldh a, [hBaseScrollY]
	and a
	ld a, $98
	jr z, jr_019_664a

	ld a, $9a

jr_019_664a:
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_663c

	ld [hl], $00
	pop bc
	pop af
	cp $03
	jr nz, jr_019_665c

	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a

jr_019_665c:
	jp IncrementEntityState


Jump_19_665F::
	push bc
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, $65c9
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld c, $34
	ld hl, wDrawCommand

jr_019_6676:
	ld a, [de]
	cp $98
	jr nz, jr_019_6684

	ldh a, [hBaseScrollY]
	and a
	ld a, $98
	jr z, jr_019_6684

	ld a, $9a

jr_019_6684:
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_6676

	ld [hl], $00
	pop bc
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr nz, jr_019_66f2

	ld hl, $d712
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld hl, $d722
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld hl, $d732
	ld a, $ad
	ld [hli], a
	ld a, $b1
	ld [hli], a
	ld a, $e7
	ld [hli], a
	ld a, $ad
	ld [hli], a
	ld a, $b1
	ld [hli], a
	ld hl, $d742
	ld a, $ae
	ld [hli], a
	ld a, $b2
	ld [hli], a
	ld a, $e3
	ld [hli], a
	ld a, $ae
	ld [hli], a
	ld a, $b2
	ld [hli], a
	call MarkRoomEventDone_19
	set 4, [hl]
	xor a
	ld [wScreenShakeX], a
	ld [wLinkFrozen], a
	ld a, $02
	ldh [hJingle], a
	jp ClearEntityStatus_19


jr_019_66f2:
	call IncrementEntityState
	ld [hl], $01
	call GetEntityTimer
	ld [hl], $30
	ret


	db $18, $58, $28, $48, $38, $20, $50, $40

Jump_019_6705:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_019_6742

	ld a, $a7
	call SpawnEntity
	jr c, jr_019_6742

	push bc
	call GetRandomByte
	and $07
	ld c, a
	ld hl, $66fd
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	call GetRandomByte
	and $07
	add $47
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	pop bc
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $10
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01

jr_019_6742:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
	db $f0, $10

Call_19_6765::
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_65d1

	ldh a, [hMapId]
	cp $0a
	jr nz, jr_019_6784

	ldh a, [hMapRoom]
	cp $97
	jr z, jr_019_677e

	cp $98
	jr nz, jr_019_6784

jr_019_677e:
	ld a, [wTradeSceneState]
	and a
	jr nz, jr_019_678a

jr_019_6784:
	ld de, $6743
	call DrawEntity16x16

jr_019_678a:
	call ReturnIfNonInteractive_19
	call ApplyRecoilIfNeeded_19
	call EntityCheckHits
	call UpdateEntityPosWithSpeed_19
	call EntityCheckWalls
	ld a, [wLinkCollisionFlags]
	and a
	jr nz, jr_019_67f7

	ldh a, [hJoypadHeld]
	and $03
	jr z, jr_019_67c7

	ld e, a
	ld d, b
	ld hl, $6762
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	ld a, e
	and $02
	add $04
	ld e, a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add e
	jp SetEntitySpriteVariant


jr_019_67c7:
	ldh a, [hJoypadHeld]
	and $0f
	jr z, jr_019_67f7

	rra
	rra
	cpl
	and $03
	ld e, a
	ld d, b
	ld hl, $6762
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
	ld a, e
	dec a
	xor $01
	sra a
	rla
	rla
	ld e, a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add e
	jp SetEntitySpriteVariant


jr_019_67f7:
	jp ClearEntitySpeed


	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $20, $60, $20, $66, $20, $64, $20

Call_19_680A::
	ld de, $67fa
	call DrawEntity16x16
	call ReturnIfNonInteractive_19
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	and $02
	ld e, a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	or e
	call SetEntitySpriteVariant
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_682E::
	dw Jump_19_6834
	dw Jump_19_6857
	dw Jump_19_6865

Jump_19_6834::
	ld hl, wEntitySpeedX
	ldh a, [hActiveEntityType]
	cp $aa
	jr z, jr_019_6840

	ld hl, wEntitySpeedY

jr_019_6840:
	add hl, bc
	ld [hl], $08

Jump_019_6843:
	ld e, $80
	ldh a, [hActiveEntityType]
	cp $aa
	jr z, jr_019_684d

	ld e, $60

jr_019_684d:
	call GetEntityTimer
	ld [hl], e
	call IncrementEntityState
	ld [hl], $01
	ret


Jump_19_6857::
	call GetEntityTimer
	jr nz, jr_019_6861

	ld [hl], $28
	call IncrementEntityState

jr_019_6861:
	call UpdateEntityPosWithSpeed_19
	ret


Jump_19_6865::
	call GetEntityTimer
	jr nz, jr_019_687d

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
	jp Jump_019_6843


jr_019_687d:
	ret


Call_19_687E::
	ldh a, [hActiveEntityState]
	cp $05
	jr nz, jr_019_688a

	ldh a, [hActiveEntityFlipAttribute]
	or $40
	ldh [hActiveEntityFlipAttribute], a

jr_019_688a:
	ld de, $67fa
	call DrawEntity16x16
	call ReturnIfNonInteractive_19
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	and $02
	ld e, a
	call ApplyRecoilIfNeeded_19
	ldh a, [hActiveEntityState]
	cp $05
	jr z, Call_19_68B8

	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	or e
	call SetEntitySpriteVariant
	call Call_19_68B8
	call EntityCheckHits
	ret


Call_19_68B8::
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_68BB::
	dw Jump_19_68C7
	dw Jump_19_68D7
	dw Jump_19_68F5
	dw Jump_19_6929
	dw Jump_19_6942
	dw Jump_19_6967

Jump_19_68C7::
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $03
	ldh a, [hActiveEntityY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	jp IncrementEntityState


Jump_19_68D7::
	call GetEntityTimer
	call GetRandomByte
	and $7f
	add $30
	ld [hl], a
	call GetRandomByte
	ld e, $f4
	and $01
	jr z, jr_019_68ed

	ld e, $0c

jr_019_68ed:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	jp IncrementEntityState


Jump_19_68F5::
	call GetEntityTimer
	jr nz, jr_019_690e

	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $d4
	ldh a, [hActiveEntityDrawY]
	sub $08
	call Call_19_6991
	ld a, $24
	ldh [hJingle], a
	jp IncrementEntityState


jr_019_690e:
	call GetEntityTimer1
	jr nz, jr_019_6923

	call GetRandomByte
	and $3f
	or $10
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_019_6923:
	call AddEntitySpeedToPos_19
	jp EntityCheckWalls


Jump_19_6929::
	call GetEntityTimer
	jr nz, jr_019_6941

	call UpdateEntityYPosWithSpeed_19
	call Call_19_6957
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $18
	jr nz, jr_019_6941

	call IncrementEntityState

jr_019_6941:
	ret


Jump_19_6942::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jr nc, jr_019_6954

	call IncrementEntityState
	ld [hl], $01
	ret


jr_019_6954:
	call UpdateEntityYPosWithSpeed_19

Call_19_6957::
	ld hl, wEntityOptions1
	add hl, bc
	set 0, [hl]
	call EntityCheckWalls
	ld hl, wEntityOptions1
	add hl, bc
	res 0, [hl]
	ret


Jump_19_6967::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 7, [hl]
	set 6, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	push hl
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, jr_019_6980

	ld [hl], $06

jr_019_6980:
	call UpdateEntityYPosWithSpeed_19
	ldh a, [hActiveEntityDrawY]
	cp $70
	jr c, Call_19_6957

	cp $88
	jp nc, ClearEntityStatus_19

	ret


	db $f0, $ec

Call_19_6991::
	ldh [hMultiPurpose1], a
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ld a, $01
	call AddTransientVfx
	ld a, $0e
	ldh [hJingle], a
	ret


	db $9a, $10, $9c, $10

Jump_019_69a5:
	ld de, $69a1
	call DrawEntity16x16
	call AddEntityZSpeedToPos_19
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, ClearEntityStatus_19

	ret


Jump_019_69be:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_69a5

	call Call_19_6B4E
	call PushLinkOutOfEntity_19
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_69D0::
	dw Jump_19_69D8
	dw Jump_19_6A0F
	dw Jump_19_6A2A
	dw Jump_19_6A68

Jump_19_69D8::
	call ShouldLinkTalkToEntity_19
	jr nc, jr_019_6a03

	ld e, $cd
	ldh a, [hRoomStatus]
	and $20
	jr nz, jr_019_69ff

	ld e, $cc
	ld a, [$dafe]
	and $20
	jr nz, jr_019_69ff

	ld e, $c6
	ld a, [wTradeSequenceItem]
	cp $03
	jr nz, jr_019_69ff

	ld a, $c7
	call OpenDialogTable1
	jp IncrementEntityState


jr_019_69ff:
	ld a, e
	call OpenDialogTable1

jr_019_6a03:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_19_6A0F::
	ld a, [wDialogState]
	and a
	jr nz, jr_019_6a29

	call IncrementEntityState
	ld a, [wDialogAnswer]
	and a
	jr z, jr_019_6a24

	ld [hl], b
	ld a, $c9
	jp OpenDialogTable1


jr_019_6a24:
	ld a, $c8
	call OpenDialogTable1

jr_019_6a29:
	ret


Jump_19_6A2A::
	ld a, [wDialogState]
	and a
	jr nz, jr_019_6a63

	ld a, $cd
	call SpawnEntity
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	sub $02
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
	ld a, $24
	ldh [hJingle], a
	call GetEntityTimer
	ld [hl], $c0
	call IncrementEntityState

jr_019_6a63:
	ret


	db $00, $01, $02, $01

Jump_19_6A68::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call GetEntityTimer
	jr nz, jr_019_6a89

	xor a
	ld [wLinkFrozen], a
	ld a, $04
	ld [wTradeSequenceItem], a
	ld a, $0d
	ldh [hBGChangeRequest], a
	call SpawnHeldItemEntity
	call IncrementEntityState
	ld [hl], b
	ret


jr_019_6a89:
	cp $80
	jr c, jr_019_6a92

	ld a, $03
	jp SetEntitySpriteVariant


jr_019_6a92:
	cp $08
	jr nz, jr_019_6a9c

	dec [hl]
	ld a, $ca
	call OpenDialogTable1

jr_019_6a9c:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $6a64
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $54, $00, $10, $00, $56, $00
	db $10, $08, $58, $00, $10, $10, $5a, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $5c, $00, $10, $00, $56, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $18, $60, $00, $ff, $ff, $ff, $ff
	db $00, $00, $62, $00, $00, $08, $64, $00, $00, $10, $66, $00, $10, $00, $68, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $10, $60, $00, $ff, $ff, $ff, $ff
	db $00, $00, $6a, $00, $00, $08, $6c, $00, $00, $10, $6e, $00, $10, $00, $68, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $10, $60, $00, $ff, $ff, $ff, $ff
	db $10, $00, $74, $00, $10, $08, $76, $00, $10, $10, $74, $00, $10, $18, $76, $00
	db $00, $10, $74, $00, $00, $18, $76, $00, $00, $00, $74, $00, $00, $08, $76, $00

Call_19_6B4E::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6aae
	add hl, de
	ldh a, [hActiveEntityX]
	add $03
	ldh [hActiveEntityX], a
	ld c, $07
	call DrawEntitySprites
	ld a, $02
	call ReserveOAMEntriesFar
	ld a, $78
	ldh [hActiveEntityX], a
	ld a, $5c
	ldh [hActiveEntityDrawY], a
	ld hl, $6b2e
	ld c, $08
	ld a, [wTradeSequenceItem]
	cp $04
	jr nz, jr_019_6b83

	dec c
	dec c

jr_019_6b83:
	call DrawEntitySprites
	ld a, $03
	call ReserveOAMEntriesFar
	call LoadEntityPosition
	ret


	db $08, $04, $70, $00, $08, $0c, $72, $00, $08, $14, $70, $20

Call_19_6B9B::
	ld a, [wIsIndoor]
	and a
	jr nz, jr_019_6baf

	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c3
	ld hl, $6b8f
	ld c, $03
	jp DrawEntitySprites


jr_019_6baf:
	ldh a, [hMapRoom]
	cp $fe
	jp z, Jump_019_69be

	ldh a, [hActiveEntityX]
	cp $30
	jp c, Jump_019_6d11

	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_019_6bf0

	call IncrementEntityState
	ld hl, wEntityY
	add hl, bc
	ld [hl], $48
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	ld a, $cd
	call SpawnEntity
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
	ld hl, wEntityY
	add hl, de
	ld [hl], $28
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40

jr_019_6bf0:
	call Call_19_6CA7
	call PushLinkOutOfEntity_19
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_6BF9::
	dw Jump_19_6BFF
	dw Jump_19_6C00
	dw Jump_19_6C32

Jump_19_6BFF::
	ret


Jump_19_6C00::
	call GetEntityDropTimer
	ret nz

	call ShouldLinkTalkToEntity_19
	jr nc, jr_019_6c24

	ld a, [wTradeSequenceItem]
	cp $0e
	jr nz, jr_019_6c17

	ld a, $d8
	call OpenDialog
	jr jr_019_6c1c

jr_019_6c17:
	ld a, $9b
	call OpenDialogTable1

jr_019_6c1c:
	ld hl, wDialogState
	set 7, [hl]
	call IncrementEntityState

jr_019_6c24:
	ldh a, [hFrameCounter]
	ld e, $00
	and $20
	jr z, jr_019_6c2d

	inc e

jr_019_6c2d:
	ld a, e
	call SetEntitySpriteVariant
	ret


Jump_19_6C32::
	ld a, [wDialogState]
	and a
	jr nz, jr_019_6c3d

	call IncrementEntityState
	ld [hl], $01

jr_019_6c3d:
	call GetLinkXDistance_19
	ld a, e
	add $02
	call SetEntitySpriteVariant
	ret


	db $f8, $f8, $5a, $00, $f8, $00, $5c, $00, $f8, $08, $5e, $00, $08, $00, $60, $00
	db $08, $08, $62, $00, $f8, $10, $5a, $20, $f8, $00, $5e, $20, $f8, $08, $5c, $20
	db $08, $00, $62, $20, $08, $08, $60, $20, $00, $10, $50, $20, $f8, $00, $54, $20
	db $f8, $08, $52, $20, $08, $00, $58, $20, $08, $08, $56, $20, $00, $f8, $50, $00
	db $f8, $00, $52, $00, $f8, $08, $54, $00, $08, $00, $56, $00, $08, $08, $58, $00
	db $f0, $00, $76, $00, $f0, $08, $76, $20, $00, $00, $78, $00, $00, $08, $78, $20

Call_19_6CA7::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
	rla
	and $f0
	add e
	ld e, a
	ld d, b
	ld hl, $6c47
	add hl, de
	ldh a, [hActiveEntityX]
	add $04
	ldh [hActiveEntityX], a
	ld c, $05
	call DrawEntitySprites
	ldh a, [hActiveEntityX]
	add $10
	ldh [hActiveEntityX], a
	ld hl, $6c97
	ld c, $04
	call DrawEntitySprites
	call PushLinkOutOfEntity_19
	ldh a, [hLinkX]
	sub $68
	add $04
	cp $08
	jr nc, jr_019_6d0d

	ldh a, [hLinkY]
	sub $50
	add $04
	cp $08
	jr nc, jr_019_6d0d

	ldh a, [hLinkDirection]
	cp $02
	jr nz, jr_019_6d0d

	call CheckTalkButtonPressed_19
	jr nc, jr_019_6d0d

	call GetEntityDropTimer
	jr nz, jr_019_6d0d

	ld a, $08
	ld [wGameplayType], a
	xor a
	ld [wTransitionSequenceCounter], a
	ld [wTransitionFrameCounter], a
	ld [wGameplaySubtype], a
	call GetEntityDropTimer
	ld [hl], $08

jr_019_6d0d:
	call LoadEntityPosition
	ret


Jump_019_6d11:
	call GetEntityTimer
	jr z, jr_019_6d1a

	ld a, $00
	ldh [hActiveEntitySpriteVariant], a

jr_019_6d1a:
	call Call_19_6DD6
	call PushLinkOutOfEntity_19
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	inc a
	add [hl]
	call SetEntitySpriteVariant
	call GetLinkYDistance_19
	add $13
	cp $26
	jr nc, jr_019_6d4a

	call GetLinkXDistance_19
	add $13
	cp $26
	jr nc, jr_019_6d4a

	ld a, e
	sla a
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_019_6d4a:
	call ShouldLinkTalkToEntity_19
	jr nc, jr_019_6d71

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $01
	jr z, jr_019_6d6b

	ld e, $af
	call GetRandomByte
	and $3f
	jr z, jr_019_6d6d

	ld e, $fb
	call GetRandomByte
	and $07
	jr z, jr_019_6d6d

jr_019_6d6b:
	ld e, $fa

jr_019_6d6d:
	ld a, e
	call OpenDialog

jr_019_6d71:
	ret


	db $f4, $00, $64, $00, $f4, $08, $66, $00, $04, $00, $68, $00, $04, $08, $6a, $00
	db $ff, $ff, $ff, $ff, $04, $f8, $70, $00, $f4, $00, $6c, $00, $f4, $08, $6e, $00
	db $04, $00, $72, $00, $04, $08, $74, $00, $04, $f8, $7a, $00, $f4, $00, $6c, $00
	db $f4, $08, $6e, $00, $04, $00, $7c, $00, $04, $08, $74, $00, $04, $10, $70, $20
	db $f4, $00, $6e, $20, $f4, $08, $6c, $20, $04, $00, $74, $20, $04, $08, $72, $20
	db $04, $10, $7a, $20, $f4, $00, $6e, $20, $f4, $08, $6c, $20, $04, $00, $74, $20
	db $04, $08, $7c, $20

Call_19_6DD6::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
	rla
	and $f0
	add e
	ld e, a
	ld d, b
	ld hl, $6d72
	add hl, de
	ld c, $05
	call DrawEntitySprites
	ret


	db $00, $06, $0c, $13, $19, $20, $26, $2c, $33, $39, $00, $00, $00, $00, $00, $00
	db $40, $43, $46, $49, $4c, $4f, $52, $55, $58, $5c, $00, $00, $00, $00, $00, $00
	db $60, $60, $60, $60, $60, $60, $60, $60, $60

Call_19_6E17::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_019_747b

	and a
	jp nz, Jump_019_70ce

	ldh a, [hLinkX]
	cp $38
	jr nc, jr_019_6e3d

	cp $20
	jr c, jr_019_6e3d

	ld hl, wLinkOAMAttrRight
	set 7, [hl]
	cp $24
	jr c, jr_019_6e3d

	ld hl, wLinkOAMAttrLeft
	set 7, [hl]

jr_019_6e3d:
	ld a, [wSeashells]
	and a
	ret z

	ld e, a
	ld d, b
	ld hl, $6dee
	add hl, de
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
	ldh a, [hRoomStatus]
	and $10
	call Call_19_6FB1
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_6E55::
	dw Jump_19_6E65
	dw Jump_19_6E7A
	dw Jump_19_6E87
	dw Jump_19_6EC0
	dw Jump_19_6F27
	dw Jump_19_6F5E
	dw Jump_19_6F5F
	dw Jump_19_6F9C

Jump_19_6E65::
	ldh a, [hLinkX]
	cp $3c
	jr c, jr_019_6e79

	call StopLinkSpeed
	call ResetSpinAttackAndDash
	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $58

jr_019_6e79:
	ret


Jump_19_6E7A::
	ld a, $01
	ld [wLinkFrozen], a
	ld a, [wIsLinkInTheAir]
	and a
	jp z, IncrementEntityState

	ret


Jump_19_6E87::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	ret nz

	ld hl, wEntityPrivateCounter
	add hl, bc
	ldh a, [hBGTilesRequestCopy]
	sub [hl]
	jr nc, jr_019_6e9f

	ldh a, [hBGTilesRequestCopy]
	ld [hl], a
	call IncrementEntityState
	ret


jr_019_6e9f:
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_019_6ebf

	call GetRandomByte
	and $01
	jr nz, jr_019_6ebf

	ld a, e
	rra
	rra
	rra
	rra
	and $0f
	and a
	jr nz, jr_019_6eb9

	ld a, $01

jr_019_6eb9:
	add [hl]
	ld [hl], a
	ld a, $06
	ldh [hWaveSfx], a

jr_019_6ebf:
	ret


Jump_19_6EC0::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ld a, [wSeashells]
	cp $20
	jr c, jr_019_6eee

	call GetEntityTimer
	ld [hl], $40
	call IncrementEntityState
	call Call_19_7520
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $01
	ld a, $56
	ld [wMusicTrackToPlay], a

Jump_019_6ee4:
	xor a
	ld [wLinkFrozen], a
	call GetEntityTimer1
	ld [hl], $3f
	ret


jr_019_6eee:
	ld hl, $dae9
	cp $05
	jr nz, jr_019_6f05

	bit 5, [hl]
	jr nz, jr_019_6f19

	call IncrementEntityState
	ld [hl], $06
	ld a, $23
	ldh [hJingle], a
	jp Jump_019_6ee4


jr_019_6f05:
	cp $10
	jr nz, jr_019_6f19

	bit 6, [hl]
	jr nz, jr_019_6f19

	call IncrementEntityState
	ld [hl], $06
	ld a, $23
	ldh [hJingle], a
	jp Jump_019_6ee4


jr_019_6f19:
	ld a, $1d
	ldh [hJingle], a
	call IncrementEntityState
	ld [hl], $05
	xor a
	ld [wLinkFrozen], a
	ret


Jump_19_6F27::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call GetEntityTimer
	cp $3e
	jr nz, jr_019_6f3a

	ld hl, hJingle
	ld [hl], $23

jr_019_6f3a:
	and a
	jr nz, jr_019_6f5d

	ld a, $cf
	call SpawnEntity
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $4f
	call IncrementEntityState

jr_019_6f5d:
	ret


Jump_19_6F5E::
	ret


Jump_19_6F5F::
	call GetEntityTimer1
	jr nz, jr_019_6f9b

	call IncrementEntityState
	ld a, $cf
	call SpawnEntity
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $14
	ld a, $02
	call SpawnEntity
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20

jr_019_6f9b:
	ret


Jump_19_6F9C::
	ret


	db $50, $00, $50, $20, $3c, $00, $3c, $20, $3a, $00, $3a, $20, $1e, $00, $1e, $60
	db $1e, $10, $1e, $70

Call_19_6FB1::
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_6fe2

	ld a, $88
	ldh [hActiveEntityX], a
	ld a, $80
	ldh [hActiveEntityDrawY], a
	ld de, $6f9d
	call DrawEntity16x16
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld e, a
	ld a, $80
	sub e
	ldh [hActiveEntityDrawY], a

jr_019_6fd2:
	ld de, $6f9d
	call DrawEntity16x16
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hActiveEntityDrawY], a
	cp $80
	jr c, jr_019_6fd2

jr_019_6fe2:
	call GetEntityTimer1
	jr z, jr_019_700d

	rra
	rra
	rra
	and $03
	ldh [hActiveEntitySpriteVariant], a
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld e, a
	ld a, $80
	sub e
	ldh [hActiveEntityDrawY], a
	ld a, $78
	ldh [hActiveEntityX], a
	ld de, $6fa1
	call DrawEntity16x16
	ld a, $98
	ldh [hActiveEntityX], a
	ld de, $6fa1
	call DrawEntity16x16

jr_019_700d:
	ret


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

Jump_019_70ce:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_19_70D1::
	dw Jump_19_70E1
	dw Jump_19_7108
	dw Jump_19_7167
	dw Jump_19_7239
	dw Jump_19_7275
	dw Jump_19_72AB
	dw Jump_19_72C5
	dw Jump_19_733F

Jump_19_70E1::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call GetEntityTimer
	jr z, jr_019_7100

	cp $30
	ret c

	sub $30
	rra
	rra
	rra
	and $03
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6fa1
	call DrawEntity16x16
	ret


jr_019_7100:
	call GetEntityTimer
	ld [hl], $a0
	jp IncrementEntityState


Jump_19_7108::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call GetEntityTimer
	jr nz, Call_19_711D

	ld [hl], $ff
	ld a, $1e
	ldh [hWaveSfx], a
	call IncrementEntityState

Call_19_711D::
	call GetEntityTimer
	and $04
	ld e, $e4
	jr z, jr_019_7128

	ld e, $84

jr_019_7128:
	ld a, e
	ld [wBGPalette], a
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_019_713e

	ld a, $33
	ldh [hNoiseSfx], a
	call GetRandomByte
	and $03
	call SetEntitySpriteVariant

jr_019_713e:
	ldh a, [hFrameCounter]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	rla
	and $e0
	add e
	ld e, a
	ld d, b
	ld hl, $700e
	add hl, de
	ld c, $0c
	call DrawEntitySprites
	ld a, $0a
	call ReserveOAMEntriesFar
	ret


	db $7a, $00, $7a, $20

Jump_19_7167::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call Call_19_711D
	call GetEntityTimer
	jr nz, jr_019_717e

	call GetEntityDropTimer
	ld [hl], $28
	jp IncrementEntityState


jr_019_717e:
	cp $50
	jr nc, jr_019_718f

	ld hl, $7219
	ld c, $08
	call DrawEntitySprites
	ld a, $06
	jp ReserveOAMEntriesFar


jr_019_718f:
	xor a
	ldh [hActiveEntitySpriteVariant], a
	ld de, $7163
	call DrawEntity16x16
	ret


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

Jump_19_7239::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ldh a, [hFrameCounter]
	and $0f
	or $20
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
	call GetEntityDropTimer
	jr nz, jr_019_7253

	jp IncrementEntityState


jr_019_7253:
	rra
	rra
	and $0f
	cp $04
	jr c, jr_019_725d

	ld a, $04

jr_019_725d:
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $7199
	add hl, de
	ld c, $08
	call DrawEntitySprites
	ld a, $06
	call ReserveOAMEntriesFar
	ret


Jump_19_7275::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call Call_19_74EF
	call UpdateEntityYPosWithSpeed_19
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $80
	jr nz, jr_019_72aa

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, jr_019_72aa

	ld [hl], $70
	ld a, $17
	ldh [hNoiseSfx], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $04
	jp c, IncrementEntityState

	cpl
	inc a
	sra a
	ld [hl], a

jr_019_72aa:
	ret


Jump_19_72AB::
	xor a
	ld [wLinkFrozen], a
	call Call_19_74EF
	call EntityTouchesLink
	jr nc, jr_019_72c4

	call IncrementEntityState
	ld a, $0f
	ld [wMusicTrackToPlay], a
	call GetEntityTimer
	ld [hl], $ff

jr_019_72c4:
	ret


Jump_19_72C5::
	call GetEntityTimer
	and $08
	ld e, $e4
	jr z, jr_019_72d0

	ld e, $84

jr_019_72d0:
	ld a, e
	ld [wBGPalette], a
	call GetEntityTimer
	jr nz, jr_019_7303

	ld [hl], $20
	ld a, $10
	ld [wMusicTrackToPlay], a
	ld a, $9f
	call OpenDialog
	ld a, [$dae9]
	or $10
	ld [$dae9], a
	ldh [hRoomStatus], a
	ld a, $02
	ld [wSwordLevel], a
	ld a, $ff
	ld [wAddHealthBuffer], a
	xor a
	ld [wSeashells], a
	ld [wLinkFrozen], a
	call IncrementEntityState

jr_019_7303:
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub $04
	ld [hl], a
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub $13
	ld [hl], a
	call LoadEntityPosition
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
	ld a, $6b
	ldh [hLinkAnimationState], a
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $03
	ldh [hLinkDirection], a
	xor a
	ld [wSwordAnimationState], a
	ld [wSwordAnimationStatePrev], a
	ld [wSwordCharge], a
	ld [wSpinAttackTimer], a
	call Call_19_744C
	call Call_19_74EA
	ret


Jump_19_733F::
	call Call_19_74EA
	ld a, [wDialogState]
	and a
	jr nz, jr_019_734b

	call ClearEntityStatus_19

jr_019_734b:
	ret


	db $00, $04, $72, $00, $e0, $04, $72, $00, $00, $f0, $78, $20, $00, $f8, $78, $40
	db $00, $10, $78, $60, $00, $18, $78, $00, $f0, $e8, $76, $20, $f0, $f0, $76, $40
	db $f0, $18, $76, $60, $f0, $20, $76, $00, $e8, $f4, $74, $20, $e8, $14, $74, $00
	db $f8, $04, $72, $00, $d8, $04, $72, $00, $fc, $e8, $78, $20, $fc, $f0, $78, $40
	db $fc, $18, $78, $60, $fc, $20, $78, $00, $e8, $e0, $76, $20, $e8, $e8, $76, $40
	db $e8, $20, $76, $60, $e8, $28, $76, $00, $e0, $f0, $74, $20, $e0, $18, $74, $00
	db $00, $00, $74, $20, $00, $08, $74, $00, $f0, $04, $72, $00, $d0, $04, $72, $00
	db $f8, $e0, $78, $20, $f8, $e8, $78, $40, $f8, $20, $78, $60, $f8, $28, $78, $00
	db $e0, $d8, $76, $20, $e0, $e0, $76, $40, $e0, $28, $76, $60, $e0, $30, $76, $00
	db $d8, $ec, $74, $20, $d8, $1c, $74, $00, $f8, $fc, $74, $20, $f8, $0c, $74, $00
	db $00, $f8, $76, $20, $00, $00, $76, $40, $00, $08, $76, $60, $00, $10, $76, $00
	db $e4, $04, $72, $00, $00, $f8, $78, $20, $00, $00, $78, $40, $00, $08, $78, $60
	db $00, $10, $78, $00, $f4, $f0, $76, $20, $f4, $f8, $76, $40, $f4, $10, $76, $60
	db $f4, $18, $76, $00, $ec, $f8, $74, $20, $ec, $10, $74, $00, $f0, $d8, $78, $20
	db $f0, $e0, $78, $40, $f0, $28, $78, $60, $f0, $30, $78, $00, $cc, $e8, $74, $20
	db $cc, $20, $74, $00, $4c, $73, $7c, $73, $b4, $73, $fc, $73, $0c, $0e, $12, $11

Call_19_744C::
	ldh a, [hActiveEntityDrawY]
	sub $00
	ldh [hActiveEntityDrawY], a
	ldh a, [hFrameCounter]
	rra
	rra
	nop
	push af
	and $03
	ld e, a
	ld d, b
	ld hl, $7448
	add hl, de
	ld c, [hl]
	pop af
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, $7440
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawEntitySprites
	ld a, $10
	call ReserveOAMEntriesFar
	ret


	db $7e, $00, $7e, $20

Jump_019_747b:
	call GetEntityTimer
	ret nz

	ld de, $7477
	call DrawEntity16x16
	call UpdateEntityYPosWithSpeed_19
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $80
	jr nz, jr_019_74c9

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, jr_019_74c9

	ld [hl], $70
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	call EntityTouchesLink
	jr nc, jr_019_74c9

	ld a, $01
	ldh [hWaveSfx], a
	call ClearEntityStatus_19
	ld hl, $dae9
	ld a, [wSeashells]
	cp $05
	jr nz, jr_019_74bc

	set 5, [hl]
	jr jr_019_74be

jr_019_74bc:
	set 6, [hl]

jr_019_74be:
	add $01
	daa
	ld [wSeashells], a
	ld a, $ef
	call OpenDialog

jr_019_74c9:
	ret


	db $f8, $00, $52, $00, $f8, $08, $52, $20, $08, $00, $54, $00, $08, $08, $54, $20
	db $f8, $00, $54, $40, $f8, $08, $54, $60, $08, $00, $52, $40, $08, $08, $52, $60

Call_19_74EA::
	ld hl, $74da
	jr jr_019_74f2

Call_19_74EF::
	ld hl, $74ca

jr_019_74f2:
	ld c, $04
	call DrawEntitySprites
	ld a, $02
	call ReserveOAMEntriesFar
	ret


	db $98, $50, $8d, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c
	db $6e, $98, $51, $8d, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f
	db $6d, $6f, $00

Call_19_7520::
	push bc
	ld c, $23
	ld a, $22
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	ld de, $74fd

jr_019_752e:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_752e

	pop bc
	ld a, $89
	ld [$d729], a
	ld [$d739], a
	ld [$d749], a
	ld [$d759], a
	ld [$d769], a
	ld [$d779], a
	ld [$d789], a
	ret


	db $fc, $04, $00, $00, $ff, $00, $00, $00, $00, $00, $04, $fc, $00, $00, $00, $ff
	db $0c, $18, $24, $30, $3c, $48

Call_19_7563::
	ld a, [wRoomTransitionState]
	cp $03
	jr nc, jr_019_756b

	ret


jr_019_756b:
	ld a, [wRoomTransitionDirection]
	ld e, a
	ld d, $00
	ld hl, $754d
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld hl, $7551
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
	ld hl, $7555
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose2], a
	ld hl, $7559
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose3], a
	ld hl, wEntityX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	rl d
	ld [hl], a
	ld hl, wEntityPosXHigh
	add hl, bc
	ldh a, [hMultiPurpose1]
	rr d
	adc [hl]
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	rl d
	ld [hl], a
	ld hl, wEntityPosYHigh
	add hl, bc
	ldh a, [hMultiPurpose3]
	rr d
	adc [hl]
	ld [hl], a
	ldh a, [hActiveEntityType]
	cp $7f
	jr nz, jr_019_75ce

	ld hl, wEntityPrivate4
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
	ld hl, wEntityPrivate3
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a
	jp Jump_019_7673


jr_019_75ce:
	cp $87
	jr nz, jr_019_760e

	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_019_7673

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeF], a
	ld a, $06

jr_019_75e5:
	ldh [hBGTilesRequestCopy], a
	ld e, a
	ld d, b
	ld hl, $755c
	add hl, de
	push hl
	ldh a, [hMultiPurposeF]
	sub [hl]
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
	ldh a, [hMultiPurposeF]
	pop hl
	sub [hl]
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a
	ldh a, [hBGTilesRequestCopy]
	dec a
	jr nz, jr_019_75e5

jr_019_760e:
	cp $c1
	jr nz, jr_019_7632

	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_019_7673

	ld e, $10
	ld hl, wFollowerTrailX

jr_019_761d:
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_761d

	ld e, $10
	ld hl, wFollowerTrailY

jr_019_7629:
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_7629

	jr jr_019_7673

jr_019_7632:
	cp $69
	jr z, jr_019_7663

	cp $b0
	jr z, jr_019_7663

	cp $6d
	jr nz, jr_019_7673

	ld a, [wIsBowWowFollowingLink]
	cp $01
	jr nz, jr_019_764b

	ldh a, [hFrameCounter]
	and $07
	jr z, jr_019_7673

jr_019_764b:
	ld e, $06
	ld hl, wEntityWorkRAM2

jr_019_7650:
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_7650

	ld e, $06
	ld hl, wSegmentY

jr_019_765c:
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_765c

jr_019_7663:
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
	ld hl, wEntityPrivate2
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a

Jump_019_7673:
jr_019_7673:
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	cp [hl]
	jr z, jr_019_769a

	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	cp $a0
	jr nc, jr_019_7690

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	cp $78
	jr c, jr_019_769a

jr_019_7690:
	ldh a, [hActiveEntityType]
	cp $a7
	ret z

	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b

jr_019_769a:
	ret


Call_19_769B::
	ld a, [$c1a5]
	and a
	jr z, jr_019_76d0

	ld a, [wDialogState]
	and a
	jr nz, jr_019_76d0

	ldh a, [hFrameCounter]
	and $03
	rst $00

JumpTable_19_76AC::
	dw Jump_19_76B4
	dw Jump_19_76D1
	dw Jump_19_76EE
	dw Jump_19_76FA

Jump_19_76B4::
	ld hl, $dccf
	ld de, $dccf
	ld a, [hld]
	push af
	ld a, [hld]
	push af
	ld c, $07

jr_019_76c0:
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, jr_019_76c0

	pop hl
	pop bc
	ld a, b
	ld [de], a
	dec de
	ld a, h
	ld [de], a

jr_019_76d0:
	ret


Jump_19_76D1::
	ld hl, $dcd0
	ld de, $dcd0
	ld a, [hli]
	push af
	ld a, [hli]
	push af
	ld c, $07

jr_019_76dd:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_019_76dd

	pop hl
	pop bc
	ld a, b
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ret


Jump_19_76EE::
	ld hl, $dce0
	ld e, $10

jr_019_76f3:
	rlc [hl]
	inc hl
	dec e
	jr nz, jr_019_76f3

	ret


Jump_19_76FA::
	ld hl, $dcf0
	ld e, $10

jr_019_76ff:
	rrc [hl]
	inc hl
	dec e
	jr nz, jr_019_76ff

	ret


	db $fd, $fc, $16, $00, $fc, $0c, $16, $00, $0e, $fb, $16, $00, $0c, $0d, $16, $00
	db $fb, $fd, $16, $00, $fa, $0b, $16, $00, $0b, $fc, $16, $00, $09, $0c, $16, $00
	db $fd, $fe, $16, $00, $fc, $0a, $16, $00, $0b, $fd, $16, $00, $08, $0a, $16, $00
	db $ff, $00, $16, $00, $00, $08, $16, $00, $0a, $ff, $16, $00, $08, $09, $16, $00
	db $02, $fc, $28, $00, $fb, $04, $28, $60, $05, $06, $28, $00, $01, $0a, $28, $20
	db $01, $ff, $28, $00, $f9, $04, $28, $60, $08, $06, $28, $00, $02, $07, $28, $20
	db $00, $00, $28, $20, $f8, $02, $28, $60, $04, $04, $28, $20, $0a, $07, $28, $20
	db $fe, $01, $28, $20, $04, $01, $28, $60, $04, $05, $28, $20, $0c, $07, $28, $20
	db $fd, $00, $28, $20, $04, $fe, $28, $60, $08, $08, $28, $20, $0e, $09, $28, $20
	db $fc, $ff, $28, $00, $04, $fa, $28, $40, $08, $09, $28, $20, $0f, $0a, $28, $00
	db $fb, $fe, $28, $00, $03, $f9, $28, $40, $08, $0c, $28, $00, $11, $0b, $28, $00
	db $fa, $fd, $28, $00, $01, $f7, $28, $40, $09, $0d, $28, $00, $0f, $0c, $28, $00

Call_19_77C6::
	ldh a, [hActiveEntitySpriteVariant]
	cp $ff
	jr z, jr_019_77e4

	cp $01
	jr z, jr_019_77e4

	ldh a, [hMultiPurpose0]
	and $0c
	sla a
	sla a
	ld e, a
	ld d, b
	ld hl, $7706
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ret


jr_019_77e4:
	inc a
	jr nz, jr_019_77ee

	ldh [hActiveEntitySpriteVariant], a
	ldh a, [hFrameCounter]
	xor c
	rra
	ret c

jr_019_77ee:
	ldh a, [hMultiPurpose0]
	and $1c
	xor $1c
	sla a
	sla a
	ld e, a
	ld d, b
	ld hl, $7746
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ret


;@ def PushLinkOutOfEntity_19(slot: bc) -> (a, carry)
;@ path: entity/helpers
;@ Makes the entity solid: if Link touches it, he is put back where he stood last frame, a hookshot chain
;@ that is out is reset to its first state, the Pegasus-boots dash ends and Link's speed is zeroed. Returns carry if Link
;@ touched it, with a = whether Link was dashing.
;@ test: skip calls the bank-3 collision check
PushLinkOutOfEntity_19::
;> if not EntityTouchesLink():                      # does Link overlap the entity?
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
;> base = EntityWalkSpriteBase_19[wEntityDirection[slot]]
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
;> return SetEntitySpriteVariant(base | frame)           # wEntitySpriteVariant = a
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
	jr nc, jr_019_789d
;> if u8(hLinkX - hActiveEntityX + 0x10) >= 0x20: return False
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_019_789d
;> toLink = GetEntityDirectionToLink_19(slot)
	inc e
	push de
	call GetEntityDirectionToLink_19
;> if (hLinkDirection ^ 1) != toLink: return False   # Link must face the entity
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
	jr nz, jr_019_789d
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
	jr nz, jr_019_789d
;> if wWindowY != 0x80: return False
	ld a, [wWindowY]
	cp $80
	jr nz, jr_019_789d
;> if not hJoypadPressed & 0x10: return False   # A button
	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_019_789d
;> return True
	scf
	ret

jr_019_789d:
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
;> if wDialogState or mem[0xC1A8] or wInventoryAppearing: return_from_caller()
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
;> Call_3EB8()
	call Call_3EB8
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
;>     EntityCheckWalls()                          # collide with walls
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
UpdateEntityPosWithSpeed_19::
;> AddEntitySpeedToPos_19(slot)             # x
	call AddEntitySpeedToPos_19
;> UpdateEntityYPosWithSpeed_19(slot)

;@ def UpdateEntityYPosWithSpeed_19(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its y speed: the y arrays lie 16 bytes after the x arrays, so the x routine runs on
;@ slot + 16.
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
;>     return Call_3F7A()                   # the boss is defeated (bank 3)
	jp Call_3F7A
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
;> new = SpawnEntity(0x36)                    # spawn a heart container, slot in de
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
;> wRoomStatus[group * 256 + hMapRoom] |= 0x20
	add hl, de
	ld a, [hl]
	or $20
	ld [hl], a
;> hRoomStatus = wRoomStatus[group * 256 + hMapRoom]
	ldh [hRoomStatus], a
	ret

	; the rest of the bank is unused ($FF filler, 1405 bytes)
	ds 1405, $ff
