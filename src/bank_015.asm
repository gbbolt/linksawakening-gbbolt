; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $015", ROMX[$4000], BANK[$15]

;@ def ResetEntityVariables(slot: c)
;@ path: entity/engine
;@ Clears every per-entity variable of `slot` (speeds and their fractions, state, private
;@ variables, timers, height, direction, sprite variant, health, flags) so a freshly spawned entity
;@ starts clean; $C5D0 gets $FF. Called through bank 0 when an entity is created.
;@ test: slot = rand(0, 15)
ResetEntityVariables::
;> ClearEntitySpeed()                                # x and y speed = 0
	call ClearEntitySpeed
;> for array in (wEntitySpeedZAcc, wEntitySpeedXAcc, wEntitySpeedYAcc, wEntitySpeedZ, wEntityState,
;>               wEntityCollisions, wEntityPrivate1, wEntityPrivate2, wEntityPrivate3, wEntityPrivate4,
;>               wEntityPrivate5, wEntityTimer, wEntityTimer1, wEntityTimer2, wEntityZ, wEntityDirection):
;>@clr     array[slot] = 0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntitySpeedXAcc
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntitySpeedYAcc
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityState
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityCollisions
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityTimer1
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b
;=@clr
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], b
;> SetEntitySpriteVariant(0)                               # sprite variant 0
	xor a
	call SetEntitySpriteVariant
;> for array in (wEntityPrivateCounter, wEntityHealth, wEntityIgnoreHitsTimer, wEntityPosXHigh,
;>               wEntityPosYHigh, wEntityGroundStatus, wEntityDropTimer, wEntityDyingTimer):
;>@clr2     array[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityPosXHigh
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityPosYHigh
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityGroundStatus
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], b
;=@clr2
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], b
;> mem[0xC490 + slot] = 0
	ld hl, $c490
	add hl, bc
	ld [hl], b
;> wEntityFlashTimer[slot] = 0
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], b
;> wEntityDropType[slot] = 0
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], b
;> mem[0xC4F0 + slot] = 0
	ld hl, $c4f0
	add hl, bc
	ld [hl], b
;> mem[0xC5D0 + slot] = 0xFF
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff
	ret


;@ def CastleGateSwitchHandler(slot: c)
;@ path: object/castle_gate_switch
;@ Handler of entity $E7, the unseen watcher of the floor switch that opens Kanalet Castle's
;@ gate: once Link has pressed the switch, he is held still for $20 frames, then the screen
;@ shakes with a rumble for $30 frames, text $39 is shown and the room's event flag is set. With
;@ the flag already set (gate open) it removes itself at once.
;@ test: skip jumps through a table
CastleGateSwitchHandler::
;> if hRoomStatus & 0x20: return ClearEntityStatus_15(slot)   # already opened
	ldh a, [hRoomStatus]
	and $20
	jp nz, ClearEntityStatus_15
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> CastleGateSwitchStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/castle_gate_switch
;@ States of the castle gate switch watcher (rst $00 table indexed by its state).
CastleGateSwitchStates::
	dw CastleGateSwitchWait
	dw CastleGateSwitchPause
	dw CastleGateSwitchQuake

;@ def CastleGateSwitchWait(slot: c)
;@ path: object/castle_gate_switch
;@ State 0: waits until Link has pressed the floor switch, then holds him for $20 frames.
;@ test: skip calls routines in other banks
CastleGateSwitchWait::
;> if wFloorSwitchPressedTimer:
	ld a, [wFloorSwitchPressedTimer]
	and a
	jr z, .done
;>     IncrementEntityState()                            # next state
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20

.done
	ret


;@ def CastleGateSwitchPause(slot: c)
;@ path: object/castle_gate_switch
;@ State 1: Link stands frozen; after the pause the rumble starts ($30 frames).
;@ test: skip calls routines in other banks
CastleGateSwitchPause::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     hNoiseSfx = 0x11                       # rumble
	ld a, $11
	ldh [hNoiseSfx], a
;>     IncrementEntityState()                            # next state
	call IncrementEntityState

.done
	ret


;@ def CastleGateSwitchQuake(slot: c)
;@ path: object/castle_gate_switch
;@ State 2: the screen shakes sideways (one pixel left and right, switching every 4 frames);
;@ at the end Link is released, text $39 opens, the room flag is set and the watcher is removed.
;@ test: skip calls routines in other banks
CastleGateSwitchQuake::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shake
;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     wScreenShakeX = 0
	ld [wScreenShakeX], a
;>     OpenDialog(0x39)
	ld a, $39
	call OpenDialog
;>     SetRoomEventFlag_15()                  # the gate stays open
	call SetRoomEventFlag_15
;>     return ClearEntityStatus_15(slot)
	jp ClearEntityStatus_15


.shake
;> shake = 0xFF if t & 4 else 1
	ld e, $01
	and $04
	jr z, .shakeSet
	ld e, $ff

.shakeSet
;> wScreenShakeX = shake
	ld a, e
	ld [wScreenShakeX], a
	ret


;@ path: object/lever_block
;@ Sprite of the lever blocks (entities $46-$49) for RenderActiveEntitySpritesPair: one variant,
;@ 2 bytes per 8x16 half (tile, attributes): tiles $F8 and $FA, sprite palette 1.
LeverBlockSprites::
	db $f8, $10, $fa, $10

;@ def LeverBlockDownHandler(slot: c)
;@ path: object/lever_block
;@ Handler of entity $46, a solid block tied to the lever (entity $69). Left alone it creeps up to
;@ 16 pixels down from where it was placed, one pixel every 14 frames. Each frame Link pulls the
;@ lever further it moves one pixel back up every 10 frames with a grinding noise; while Link only
;@ holds the lever it stays put. Link cannot walk through it.
;@ test: skip jumps through a table
LeverBlockDownHandler::
;> DrawEntity16x16(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> hBGTilesRequestCopy = 0                    # (scratch here) set when the block rests at its end
	xor a
	ldh [hBGTilesRequestCopy], a
;> LeverBlockDownStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/lever_block
;@ States of the lever block $46 (rst $00 table indexed by its state).
LeverBlockDownStates::
	dw LeverBlockDownInit
	dw LeverBlockDownSlide

;@ def LeverBlockDownInit(slot: c)
;@ path: object/lever_block
;@ State 0: remembers the starting y (wEntityPrivate2) and the end y 16 pixels lower
;@ (wEntityPrivate1).
;@ test: skip calls routines in other banks
LeverBlockDownInit::
;> wEntityPrivate2[slot] = wEntityY[slot]     # start
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityPrivate1[slot] = u8(wEntityY[slot] + 0x10)   # end
	add $10
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> IncrementEntityState()                                # next state
	jp IncrementEntityState


;@ def LeverBlockDownSlide(slot: c)
;@ path: object/lever_block
;@ State 1: moves the block by the lever's state (see LeverBlockDownHandler) and keeps Link out.
;@ test: skip calls routines in other banks
LeverBlockDownSlide::
;> if hLeverPullState == 2: return PushLinkOutOfLeverBlock(slot)   # lever held: stay
	ldh a, [hLeverPullState]
	cp $02
	jr z, PushLinkOutOfLeverBlock
;> if hLeverPullState:                       # lever being pulled: back towards the start
	and a
	jr z, .forward
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] < 10: return
	ld a, [hl]
	cp $0a
	jr c, .done
;>     wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>     hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;>@ne     if wEntityY[slot] != wEntityPrivate2[slot]:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
;=@ne
	jr z, .done
;>         wEntityY[slot] -= 1
	dec [hl]

.done
;>     return                                 # (Link is not pushed out while it moves back)
	ret


.forward
;>@eq if wEntityY[slot] == wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
;=@eq
	jr z, .atEnd
;>@fw     hBGTilesRequestCopy += 1                # at the end
;> else:
;>     count = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;>     if count >= 0x0D:                       # every 14 frames
	cp $0d
	jr c, PushLinkOutOfLeverBlock
;>         wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>         wEntityY[slot] += 1
	ld hl, wEntityY
	add hl, bc
	inc [hl]
	jr PushLinkOutOfLeverBlock

.atEnd
;=@fw
	ld hl, hBGTilesRequestCopy
	inc [hl]
;> PushLinkOutOfLeverBlock(slot)              # falls through

;@ def PushLinkOutOfLeverBlock(slot: c)
;@ path: object/lever_block
;@ Makes a lever block solid: when Link overlaps it (closer than 12 pixels sideways and from 16
;@ above to 12 below), his dash and speed stop and he is put just outside the side he is on.
;@ A block resting at its end position does not push Link out on the side it moved to
;@ ($46 down: not below it, $47 up: not above it).
;@ test: skip calls routines in other banks
PushLinkOutOfLeverBlock::
;> LoadEntityPosition()                                # active position copies
	call LoadEntityPosition
;> _, dx = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;> if u8(dx + 12) >= 24: return
	add $0c
	cp $18
	jr nc, .done
;> _, dy = GetEntityYDistanceToLink_15(slot)
	call GetEntityYDistanceToLink_15
;> if u8(dy + 16) >= 28: return
	add $10
	cp $1c
	jr nc, .done
;> ResetPegasusBoots()                                # stop the Pegasus Boots
	call ResetPegasusBoots
;> StopLinkSpeed()                                # Link's speed = 0
	call StopLinkSpeed
;> side = GetEntityDirectionToLink_15(slot)
	call GetEntityDirectionToLink_15
;> if side == 0:                              # Link to the right
	ld a, e
	cp $00
	jr nz, .notRight
;>     hLinkX = u8(hActiveEntityX + 12)
	ldh a, [hActiveEntityX]
	add $0c
	ldh [hLinkX], a
	ret


.notRight
;> elif side == 1:                            # to the left
	cp $01
	jr nz, .notLeft
;>     hLinkX = u8(hActiveEntityX - 12)
	ldh a, [hActiveEntityX]
	add $f4
	ldh [hLinkX], a
	ret


.notLeft
;> elif side == 2:                            # above
	cp $02
	jr nz, .below
;>     if hActiveEntityType == 0x47 and hBGTilesRequestCopy: return
	ldh a, [hActiveEntityType]
	cp $47
	jr nz, .pushUp
	ldh a, [hBGTilesRequestCopy]
	and a
	ret nz

.pushUp
;>     hLinkY = u8(hActiveEntityDrawY - 16)
	ldh a, [hActiveEntityDrawY]
	add $f0
	ldh [hLinkY], a
	ret


.below
;> else:                                     # below
;>     if hActiveEntityType == 0x46 and hBGTilesRequestCopy: return
	ldh a, [hActiveEntityType]
	cp $46
	jr nz, .pushDown
	ldh a, [hBGTilesRequestCopy]
	and a
	ret nz

.pushDown
;>     hLinkY = u8(hActiveEntityDrawY + 12)
	ldh a, [hActiveEntityDrawY]
	add $0c
	ldh [hLinkY], a

.done
	ret


;@ def LeverBlockUpHandler(slot: c)
;@ path: object/lever_block
;@ Handler of entity $47: the lever block that creeps up to 16 pixels up (see
;@ LeverBlockDownHandler; pulling the lever moves it back down).
;@ test: skip jumps through a table
LeverBlockUpHandler::
;> DrawEntity16x16(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> hBGTilesRequestCopy = 0                    # (scratch here) set when the block rests at its end
	xor a
	ldh [hBGTilesRequestCopy], a
;> LeverBlockUpStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/lever_block
;@ States of the lever block $47 (rst $00 table indexed by its state).
LeverBlockUpStates::
	dw LeverBlockUpInit
	dw LeverBlockUpSlide

;@ def LeverBlockUpInit(slot: c)
;@ path: object/lever_block
;@ State 0: remembers the starting y (wEntityPrivate2) and the end y 16 pixels higher
;@ (wEntityPrivate1).
;@ test: skip calls routines in other banks
LeverBlockUpInit::
;> wEntityPrivate2[slot] = wEntityY[slot]     # start
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityPrivate1[slot] = u8(wEntityY[slot] - 0x10)   # end
	sub $10
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> IncrementEntityState()                                # next state
	jp IncrementEntityState


;@ def LeverBlockUpSlide(slot: c)
;@ path: object/lever_block
;@ State 1: moves the block by the lever's state and keeps Link out (as LeverBlockDownSlide,
;@ the other way round).
;@ test: skip calls routines in other banks
LeverBlockUpSlide::
;> if hLeverPullState == 2: return PushLinkOutOfLeverBlock(slot)   # lever held: stay
	ldh a, [hLeverPullState]
	cp $02
	jr z, .push
;> if hLeverPullState:                       # lever being pulled: back towards the start
	and a
	jr z, .forward
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] < 10: return
	ld a, [hl]
	cp $0a
	jr c, .done
;>     wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>     hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;>@ne     if wEntityY[slot] != wEntityPrivate2[slot]:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
;=@ne
	jr z, .done
;>         wEntityY[slot] += 1
	inc [hl]

.done
;>     return
	ret


.forward
;>@eq if wEntityY[slot] == wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
;=@eq
	jr z, .atEnd
;>@fw     hBGTilesRequestCopy += 1                # at the end
;> else:
;>     count = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;>     if count >= 0x0D:                       # every 14 frames
	cp $0d
	jr c, .push
;>         wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>         wEntityY[slot] -= 1
	ld hl, wEntityY
	add hl, bc
	dec [hl]
	jr .push

.atEnd
;=@fw
	ld hl, hBGTilesRequestCopy
	inc [hl]

.push
;> PushLinkOutOfLeverBlock(slot)
	call PushLinkOutOfLeverBlock
	ret


;@ def LeverBlockRightHandler(slot: c)
;@ path: object/lever_block
;@ Handler of entity $48: the lever block that creeps up to 16 pixels to the right (see
;@ LeverBlockDownHandler; pulling the lever moves it back left).
;@ test: skip jumps through a table
LeverBlockRightHandler::
;> DrawEntity16x16(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> hBGTilesRequestCopy = 0                    # (scratch here) set when the block rests at its end
	xor a
	ldh [hBGTilesRequestCopy], a
;> LeverBlockRightStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/lever_block
;@ States of the lever block $48 (rst $00 table indexed by its state).
LeverBlockRightStates::
	dw LeverBlockRightInit
	dw LeverBlockRightSlide

;@ def LeverBlockRightInit(slot: c)
;@ path: object/lever_block
;@ State 0: remembers the starting x (wEntityPrivate2) and the end x 16 pixels to the right
;@ (wEntityPrivate1).
;@ test: skip calls routines in other banks
LeverBlockRightInit::
;> wEntityPrivate2[slot] = wEntityX[slot]     # start
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityPrivate1[slot] = u8(wEntityX[slot] + 0x10)   # end
	add $10
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> IncrementEntityState()                                # next state
	jp IncrementEntityState


;@ def LeverBlockRightSlide(slot: c)
;@ path: object/lever_block
;@ State 1: moves the block by the lever's state and keeps Link out (as LeverBlockDownSlide,
;@ sideways).
;@ test: skip calls routines in other banks
LeverBlockRightSlide::
;> if hLeverPullState == 2: return PushLinkOutOfLeverBlock(slot)   # lever held: stay
	ldh a, [hLeverPullState]
	cp $02
	jr z, .push
;> if hLeverPullState:                       # lever being pulled: back towards the start
	and a
	jr z, .forward
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] < 10: return
	ld a, [hl]
	cp $0a
	jr c, .done
;>     wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>     hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;>@ne     if wEntityX[slot] != wEntityPrivate2[slot]:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
;=@ne
	jr z, .done
;>         wEntityX[slot] -= 1
	dec [hl]

.done
;>     return
	ret


.forward
;>@eq if wEntityX[slot] == wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
;=@eq
	jr z, .atEnd
;>@fw     hBGTilesRequestCopy += 1                # at the end
;> else:
;>     count = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;>     if count >= 0x0D:                       # every 14 frames
	cp $0d
	jr c, .push
;>         wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>         wEntityX[slot] += 1
	ld hl, wEntityX
	add hl, bc
	inc [hl]
	jr .push

.atEnd
;=@fw
	ld hl, hBGTilesRequestCopy
	inc [hl]

.push
;> PushLinkOutOfLeverBlock(slot)
	call PushLinkOutOfLeverBlock
	ret


;@ def LeverBlockLeftHandler(slot: c)
;@ path: object/lever_block
;@ Handler of entity $49: the lever block that creeps up to 16 pixels to the left (see
;@ LeverBlockDownHandler; pulling the lever moves it back right).
;@ test: skip jumps through a table
LeverBlockLeftHandler::
;> DrawEntity16x16(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> hBGTilesRequestCopy = 0                    # (scratch here) set when the block rests at its end
	xor a
	ldh [hBGTilesRequestCopy], a
;> LeverBlockLeftStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/lever_block
;@ States of the lever block $49 (rst $00 table indexed by its state).
LeverBlockLeftStates::
	dw LeverBlockLeftInit
	dw LeverBlockLeftSlide

;@ def LeverBlockLeftInit(slot: c)
;@ path: object/lever_block
;@ State 0: remembers the starting x (wEntityPrivate2) and the end x 16 pixels to the left
;@ (wEntityPrivate1).
;@ test: skip calls routines in other banks
LeverBlockLeftInit::
;> wEntityPrivate2[slot] = wEntityX[slot]     # start
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityPrivate1[slot] = u8(wEntityX[slot] - 0x10)   # end
	sub $10
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> IncrementEntityState()                                # next state
	jp IncrementEntityState


;@ def LeverBlockLeftSlide(slot: c)
;@ path: object/lever_block
;@ State 1: moves the block by the lever's state and keeps Link out (as LeverBlockDownSlide,
;@ sideways).
;@ test: skip calls routines in other banks
LeverBlockLeftSlide::
;> if hLeverPullState == 2: return PushLinkOutOfLeverBlock(slot)   # lever held: stay
	ldh a, [hLeverPullState]
	cp $02
	jr z, .push
;> if hLeverPullState:                       # lever being pulled: back towards the start
	and a
	jr z, .forward
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] < 10: return
	ld a, [hl]
	cp $0a
	jr c, .done
;>     wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>     hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;>@ne     if wEntityX[slot] != wEntityPrivate2[slot]:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
;=@ne
	jr z, .done
;>         wEntityX[slot] += 1
	inc [hl]

.done
;>     return
	ret


.forward
;>@eq if wEntityX[slot] == wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
;=@eq
	jr z, .atEnd
;>@fw     hBGTilesRequestCopy += 1                # at the end
;> else:
;>     count = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;>     if count >= 0x0D:                       # every 14 frames
	cp $0d
	jr c, .push
;>         wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>         wEntityX[slot] -= 1
	ld hl, wEntityX
	add hl, bc
	dec [hl]
	jr .push

.atEnd
;=@fw
	ld hl, hBGTilesRequestCopy
	inc [hl]

.push
;> PushLinkOutOfLeverBlock(slot)
	call PushLinkOutOfLeverBlock
	ret


;@ path: object/crystal_switch
;@ Sprite of the crystal switch for RenderActiveEntitySpritesPair: one variant, tile $58 drawn
;@ twice (left half plain, right half x-flipped); 2 bytes per half (tile, attributes).
CrystalSwitchSprites::
	db $58, $00, $58, $20

;@ def CrystalSwitchHandler(slot: c)
;@ path: object/crystal_switch
;@ Handler of entity $66, the crystal switch: it cannot be destroyed (health refilled every
;@ frame) and is solid. When a weapon hits it while no raise / lower animation runs, it starts
;@ one (wRaisedBlockStep = 1, the raised blocks swap), flashes for $18 frames and chimes.
;@ test: skip calls routines in other banks
CrystalSwitchHandler::
;> wEntityHealth[slot] = 0xFF                 # never breaks
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
;> hActiveEntityFlipAttribute = (wEntityTimer[slot] << 1) & 0x10   # palette flips while it flashes
	call GetEntityTimer
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(CrystalSwitchSprites)           # draw it
	ld de, CrystalSwitchSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()                                # count down the ignore-hits timer
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits()                                # weapons hit it
	call EntityCheckWeaponHits
;> CheckLinkBumpsEntity_15(slot)              # Link cannot walk through it
	call CheckLinkBumpsEntity_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> if wEntityFlashTimer[slot]:                # it was just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     wEntityFlashTimer[slot] = 0
	ld [hl], b
;>     if wRaisedBlockStep == 0:
	ld a, [wRaisedBlockStep]
	and a
	jr nz, .done
;>         wRaisedBlockStep = 1               # swap the raised blocks
	ld a, $01
	ld [wRaisedBlockStep], a
;>         wEntityTimer[slot] = 0x18          # flash
	call GetEntityTimer
	ld [hl], $18
;>         hWaveSfx = 0x0E
	ld a, $0e
	ldh [hWaveSfx], a

.done
	ret


;@ def BouldersHandler(slot: c)
;@ path: enemy/boulder
;@ Handler of entity $45, the falling boulders of the mountain slopes. The placed entity (state 0)
;@ is an invisible spawner: every 48-111 frames, if Link is below the top 24 pixels, it drops a
;@ new boulder (another $45 in state 1) at the top of the screen, at a random x of $18-$88 in
;@ steps of 16. The boulders themselves run BoulderBouncing.
;@ test: skip calls routines in other banks
BouldersHandler::
;> if hActiveEntityState: return BoulderBouncing(slot)
	ldh a, [hActiveEntityState]
	and a
	jp nz, BoulderBouncing
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, .done
;> wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x30   # next boulder in 48-111 frames
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
;> if hLinkY < 0x18: return
	ldh a, [hLinkY]
	cp $18
	ret c
;> new = SpawnEntity(0x45)                      # spawn a boulder
	ld a, $45
	call SpawnEntity
;> if new is None: return                    # no free slot
	ret c
;>@x wEntityX[new] = ((GetRandomByte() << 4) & 0x70) + 0x18
	call GetRandomByte
	rla
	rla
	rla
	rla
	and $70
;=@x
	add $18
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[new] = 0x10                       # top of the screen
	ld hl, wEntityY
	add hl, de
	ld [hl], $10
;> wEntityPhysicsFlags[new] = 0x12            # 2 sprites, with a shadow
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;> wEntityHitboxFlags[new] |= 0x80
	ld hl, wEntityHitboxFlags
	add hl, de
	set 7, [hl]
;> wEntityState[new] += 1                     # a falling boulder
	ld hl, wEntityState
	add hl, de
	inc [hl]

.done
	ret


;@ path: enemy/boulder
;@ Boulder sprites for RenderActiveEntitySpritesPair: 4 variants (0-3, the rolling animation),
;@ 4 bytes each = two 8x16 halves (tile, attributes): tiles $5C/$5E turned by x / y flips
;@ ($20 x flip, $40 y flip).
BoulderSprites::
	db $5c, $00, $5e, $00, $5e, $20, $5c, $20, $5e, $60, $5c, $60, $5c, $40, $5e, $40
;@ path: enemy/boulder
;@ X speed of a boulder after each bounce, one of 4 picked at random (signed, 1/16 pixel per
;@ frame): +12, -12, +5, -5.
BoulderBounceSpeedX::
	db $0c, $f4, $05, $fb

;@ path: enemy/boulder
;@ Y speed (downwards) of a boulder after each bounce, one of 4 picked at random: 8, 10, 6, 12.
BoulderBounceSpeedY::
	db $08, $0a, $06, $0c

;@ path: enemy/boulder
;@ Upward speed of a boulder's bounce, one of 4 picked at random: $18, $20, $1C, $28
;@ (gravity takes 2 per frame).
BoulderBounceSpeedZ::
	db $18, $20, $1c, $28

;@ def BoulderBouncing(slot: c)
;@ path: enemy/boulder
;@ A falling boulder (entity $45, state 1): rolls (animation every 8 frames), hurts Link on
;@ touch, and bounces down the screen; on each landing it picks a random new bounce from the
;@ BoulderBounce tables with a thud. It disappears once it leaves the screen at the right or
;@ the bottom.
;@ test: skip calls routines in other banks
BoulderBouncing::
;> DrawEntity16x16(BoulderSprites)                 # draw it
	ld de, BoulderSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()                                # count down the ignore-hits timer
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits()                                # contact with Link and his weapons
	call EntityCheckHits
;> SetEntitySpriteVariant((hFrameCounter >> 3) & 3)        # rolling animation
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # hit the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .onScreen
;>     wEntityZ[slot] = 0
	ld [hl], b
;>@sx     wEntitySpeedX[slot] = mem[BoulderBounceSpeedX + (GetRandomByte() & 3)]
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, BoulderBounceSpeedX
	add hl, de
;=@sx
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>@sy     wEntitySpeedY[slot] = mem[BoulderBounceSpeedY + (GetRandomByte() & 3)]
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, BoulderBounceSpeedY
	add hl, de
;=@sy
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>@sz     wEntitySpeedZ[slot] = mem[BoulderBounceSpeedZ + (GetRandomByte() & 3)]
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, BoulderBounceSpeedZ
	add hl, de
;=@sz
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
;>     hJingle = 0x20                         # thud
	ld a, $20
	ldh [hJingle], a

.onScreen
;> if hActiveEntityX >= 0xA8: return ClearEntityStatus_15(slot)
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_15
;> if hActiveEntityDrawY >= 0x84: return ClearEntityStatus_15(slot)
	ldh a, [hActiveEntityDrawY]
	cp $84
	jp nc, ClearEntityStatus_15
	ret


;@ def TalkingBonesHandler(slot: c)
;@ path: npc/talking_bones
;@ Handler of entity $44, bones that speak when Magic Powder is sprinkled on them: it looks for
;@ a powder cloud (entity 8, active, at timer value 8) within 8 pixels of itself and then shows
;@ text $92 in room $DF, elsewhere text $43 (only while $DB79 is 0). It draws nothing itself.
;@ test: skip calls routines in other banks
TalkingBonesHandler::
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> for other in range(15, -1, -1):
	ld e, $0f
	ld d, b

.next
;>@nx     if wEntityStatus[other] != 5: continue
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, .skip
;>@nx     if wEntityType[other] != 8: continue      # magic powder
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, .skip
;>@nx     if wEntityTimer[other] != 8: continue
	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, .skip
;>@nx     if u8(hActiveEntityX - wEntityX[other] + 8) >= 0x10: continue
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $08
	cp $10
;=@nx
	jr nc, .skip
;>@nx     if u8(hActiveEntityDrawY - wEntityY[other] + 8) >= 0x10: continue
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $08
	cp $10
;=@nx
	jr nc, .skip
;>     if hMapRoom == 0xDF:
	ldh a, [hMapRoom]
	cp $df
	ld a, $92
	jr z, .talk
;>         text = 0x92
;>     else:
;>         if mem[0xDB79]: return
	ld a, [wIsGhostFollowingLink]
	and a
	ret nz
;>         text = 0x43
	ld a, $43

.talk
;>     return OpenDialog(text)
	call OpenDialog
	ret


.skip
;=@nx
	dec e
	ld a, e
	cp $ff
	jr nz, .next
	ret


;@ def SeashellMansionTreesHandler(slot: c)
;@ path: npc/seashell_mansion_trees
;@ Handler of entity $43, an unseen spot by the trees near the Seashell Mansion: when Link faces
;@ it and presses A, text $12 is shown.
;@ test: skip calls routines in other banks
SeashellMansionTreesHandler::
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> if not CheckLinkTalksToEntity_15(): return
	call CheckLinkTalksToEntity_15
	ret nc
;> OpenDialog(0x12)
	ld a, $12
	call OpenDialog
	ret


;@ path: enemy/fish
;@ Leaping fish sprites for RenderActiveEntitySpritesPair: variants 0-4, 4 bytes each = two 8x16
;@ halves (tile, attributes). 0 blank (tile $FF), 1 rising left-facing ($54/$56), 2 falling
;@ left-facing ($58/$5A), 3 rising right-facing (x-flipped), 4 falling right-facing.
FishSpritesPair::
	db $ff, $00, $ff, $00, $54, $00, $56, $00, $58, $00, $5a, $00, $56, $20, $54, $20
	db $5a, $20, $58, $20

;@ path: enemy/fish
;@ Fish sprites seen under water, for RenderActiveEntitySprite (one 8x16 sprite, 2 bytes: tile,
;@ attributes), used as variants 5-8: 5 fin moving left ($5C), 6 moving right ($5C flipped),
;@ 7 and 8 tile $5E.
FishSpritesSingle::
	db $5c, $00, $5c, $20, $5e, $00, $5e, $00

;@ def FishHandler(slot: c)
;@ path: enemy/fish
;@ Handler of entity $CC, the fish that swims under the water surface and now and then leaps out
;@ in an arc (hurting Link it touches), with a splash at both ends of the jump. Variants below 5
;@ are drawn as 16x16 sprites, 5 and up as one 8x16 sprite.
;@ test: skip jumps through a table
FishHandler::
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v != 0xFF:                             # $FF = not drawn
	cp $ff
	jr z, .drawn
;>     if v >= 5:                             # under water: the small sprite
	cp $05
	jr c, .leaping
;>         hActiveEntitySpriteVariant = v - 5
	sub $05
	ldh [hActiveEntitySpriteVariant], a
;>         DrawEntity8x16(FishSpritesSingle)
	ld de, FishSpritesSingle
	call DrawEntity8x16
	jr .drawn

.leaping
;>     else:
;>         DrawEntity16x16(FishSpritesPair)
	ld de, FishSpritesPair
	call DrawEntity16x16

.drawn
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> FishStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/fish
;@ States of the fish (rst $00 table indexed by its state): 0 start, 1 swim, 2 leap.
FishStates::
	dw FishInit
	dw FishSwim
	dw FishLeap

;@ def FishInit(slot: c)
;@ path: enemy/fish
;@ State 0: starts swimming to the right; the first leap comes after 64-191 frames.
;@ test: skip calls routines in other banks
FishInit::
;> wEntitySpeedX[slot] = 8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
;> wEntityTimer[slot] = (GetRandomByte() & 0x7F) + 0x40
	call GetEntityTimer
	call GetRandomByte
	and $7f
	add $40
	ld [hl], a
;> IncrementEntityState()                                # next state
	jp IncrementEntityState


;@ def FishSwim(slot: c)
;@ path: enemy/fish
;@ State 1: swims under water (touching Link still hurts him). When the timer runs out it leaps:
;@ twice as fast sideways, upward speed $18, drawn with a shadow, with a splash.
;@ test: skip calls routines in other banks
FishSwim::
;> EntityCheckContactDamage()                                # hurts Link on touch
	call EntityCheckContactDamage
;> if wEntityTimer[slot]: return FishSwimTurn(slot)
	call GetEntityTimer
	jr nz, FishSwimTurn
;> wEntityPhysicsFlags[slot] = 0x12           # 2 sprites, with a shadow
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $12
;> wEntitySpeedZ[slot] = 0x18                 # leap
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;> IncrementEntityState()                                # next state
	call IncrementEntityState
;> wEntitySpeedX[slot] <<= 1
	ld hl, wEntitySpeedX
	add hl, bc
	sla [hl]
;> FishSplash()                               # falls through

;@ def FishSplash()
;@ path: enemy/fish
;@ A splash where the fish is: sound $0E and visual effect 1 at its drawn position.
;@ test: skip calls routines in other banks
FishSplash::
;> hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	add $00
	ldh [hMultiPurpose1], a
;> AddTransientVfx(1)                          # splash
	ld a, $01
	call AddTransientVfx
	ret


;@ def FishSwimTurn(slot: c)
;@ path: enemy/fish
;@ The rest of state 1 while the timer runs: turns around at walls and shows the fin sprite
;@ facing the way it swims (variant 5 left, 6 right).
;@ test: skip calls routines in other banks
FishSwimTurn::
;> if wEntityCollisions[slot] & 3:            # a wall on the left or right
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .turned
;>     wEntitySpeedX[slot] = u8(-wEntitySpeedX[slot])
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.turned
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
;> frame = 5 if speed & 0x80 else 6
	ld e, $06
	ld a, [hl]
	and $80
	jr z, .set
	ld e, $05

.set
;> SetEntitySpriteVariant(frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ path: unused
;@ A lone `ret` byte after FishSwimTurn that nothing reaches.
FishStrayRet::
	db $c9

;@ def FishLeap(slot: c)
;@ path: enemy/fish
;@ State 2: the fish flies in an arc (gravity 1 per frame) and hurts Link on touch, or is hit by
;@ his weapons. Rising and falling frames face the way it moves. Back in the water: splash, the
;@ next leap in 80-207 frames, half the speed, no shadow, back to state 1.
;@ test: skip calls routines in other banks
FishLeap::
;> EntityCheckHits()                                # contact with Link and his weapons
	call EntityCheckHits
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 1                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # back in the water
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .inAir
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     FishSplash()
	call FishSplash
;>     wEntityTimer[slot] = (GetRandomByte() & 0x7F) + 0x50
	call GetEntityTimer
	call GetRandomByte
	and $7f
	add $50
	ld [hl], a
;>     wEntitySpeedX[slot] = (wEntitySpeedX[slot] >> 1) | (wEntitySpeedX[slot] & 0x80)   # half speed, same sign
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
;>     wEntityPhysicsFlags[slot] = 0x52
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $52
;>     wEntityState[slot] = 1                 # swim
	call IncrementEntityState
	ld [hl], $01
	ret


.inAir
;> frame = 1                                  # facing left
	ld e, $01
;> if not wEntitySpeedX[slot] & 0x80:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .left
;>     frame = 3                              # facing right
	ld e, $03

.left
;> if wEntitySpeedZ[slot] & 0x80:             # falling
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .rising
;>     frame += 1
	inc e

.rising
;> SetEntitySpriteVariant(frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ path: boss/final_nightmare
;@ The column of light that appears after the final boss is beaten, for
;@ RenderActiveEntitySpritesRect: 5 rows from the bottom up, each two OAM entries of 4 bytes
;@ (y offset, x offset, tile, attributes): tiles $46 (left) and $7E (right), rows 16 pixels
;@ apart (y 0, -16, -32, -48, -64). The first (counter + 1) * 2 entries are drawn, so it grows.
FinalNightmareLightColumnSprites::
	db $00, $00, $46, $00, $00, $08, $7e, $00, $f0, $00, $46, $00, $f0, $08, $7e, $00
	db $e0, $00, $46, $00, $e0, $08, $7e, $00, $d0, $00, $46, $00, $d0, $08, $7e, $00
	db $c0, $00, $46, $00, $c0, $08, $7e, $00

;@ def FinalNightmareExit(slot: c)
;@ path: boss/final_nightmare
;@ What the final boss entity becomes once beaten (wEntityPrivate5 = 2): a column of light,
;@ text $D7, and when Link steps into the light he floats up out of the room and the credits
;@ start (wGameplayType 1).
;@ test: skip jumps through a table
FinalNightmareExit::
;> rows = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> DrawEntitySprites(FinalNightmareLightColumnSprites, (rows + 1) * 2)   # draw the column
	add $01
	sla a
	ld c, a
	ld hl, FinalNightmareLightColumnSprites
	call DrawEntitySprites
;> ReserveOAMEntriesFar(10)                              # reserve 10 OAM entries
	ld a, $0a
	call ReserveOAMEntriesFar
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> if wGameplayType == 1: return              # the credits already run
	ld a, [wGameplayType]
	cp $01
	ret z
;> FinalNightmareExitSteps[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare
;@ Steps of the end of the final boss room (rst $00 table indexed by the entity's state).
FinalNightmareExitSteps::
	dw FinalNightmareExitStart
	dw FinalNightmareExitTalk
	dw FinalNightmareExitWaitAway
	dw FinalNightmareExitWaitEnter
	dw FinalNightmareExitRise

;@ def FinalNightmareExitStart(slot: c)
;@ path: boss/final_nightmare
;@ Step 0: waits $C0 frames.
;@ test: skip calls routines in other banks
FinalNightmareExitStart::
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> IncrementEntityState()                                # next step
	jp IncrementEntityState


;@ def FinalNightmareExitTalk(slot: c)
;@ path: boss/final_nightmare
;@ Step 1: $80 frames in, text $D7 is shown; at the end of the wait the light appears at
;@ ($50, $30) with a burst and a chime.
;@ test: skip calls routines in other banks
FinalNightmareExitTalk::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0x40:
	cp $40
	jr nz, .notYet
;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     return OpenDialog(0xD7)
	ld a, $d7
	jp OpenDialog


.notYet
;> if t: return
	and a
	ret nz
;> hMultiPurpose0 = 0x4F
	ld a, $50
	dec a
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = 0x30
	ld a, $30
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                         # burst
	ld a, $02
	call AddTransientVfx
;> hJingle = 0x2F
	ld a, $2f
	ldh [hJingle], a
;> SetEntitySpriteVariant(0)
	ld a, $00
	call SetEntitySpriteVariant
;> IncrementEntityState()                                # next step
	jp IncrementEntityState


;@ def FinalNightmareExitWaitAway()
;@ path: boss/final_nightmare
;@ Step 2: waits until Link is not standing on the light's spot (within 8 pixels of ($50, $30)).
;@ test: skip calls routines in other banks
FinalNightmareExitWaitAway::
;>@in if -8 <= hLinkX - 0x50 < 8 and -8 <= hLinkY - 0x30 < 8: return
	ldh a, [hLinkX]
	sub $50
	add $08
	cp $10
	jr nc, .away
;=@in
	ldh a, [hLinkY]
	sub $30
	add $08
	cp $10
	jr nc, .away
	ret


.away
;> IncrementEntityState()                                # next step
	call IncrementEntityState
	ret


;@ def FinalNightmareExitWaitEnter(slot: c)
;@ path: boss/final_nightmare
;@ Step 3: waits until Link stands in the light (within 8 pixels of ($50, $30)) on the ground,
;@ then starts the rise from y $30.
;@ test: skip calls routines in other banks
FinalNightmareExitWaitEnter::
;> if not -8 <= hLinkX - 0x50 < 8: return
	ldh a, [hLinkX]
	sub $50
	add $08
	cp $10
	jr nc, .done
;> if not -8 <= hLinkY - 0x30 < 8: return
	ldh a, [hLinkY]
	sub $30
	add $08
	cp $10
	jr nc, .done
;> if wIsLinkInTheAir: return
	ld a, [wIsLinkInTheAir]
	and a
	ret nz
;> IncrementEntityState()                                # next step
	call IncrementEntityState
;> wEntityPrivate1[slot] = 0x30               # Link's y while he rises
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $30

.done
	ret


;@ def FinalNightmareExitRise(slot: c)
;@ path: boss/final_nightmare
;@ Step 4: Link, held in the light facing up and walking on the spot, floats up one pixel every 4
;@ frames while the column grows a row every 8 frames; above y $12 the credits begin.
;@ test: skip calls routines in other banks
FinalNightmareExitRise::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> hLinkY = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
;> hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;>@g if hFrameCounter & 7 == 0 and wEntityPrivateCounter[slot] != 4:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .grown
	ld hl, wEntityPrivateCounter
	add hl, bc
;=@g
	ld a, [hl]
	cp $04
	jr z, .grown
;>     wEntityPrivateCounter[slot] += 1       # one more row of light
	inc [hl]

.grown
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .pose
;>     wEntityPrivate1[slot] -= 1             # rise
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
;>     if wEntityPrivate1[slot] < 0x12:
	ld a, [hl]
	cp $12
	jr nc, .pose
;>         wGameplaySubtype = 0
	xor a
	ld [wGameplaySubtype], a
;>         wGameplayType = 1                  # the credits
	ld a, $01
	ld [wGameplayType], a
;>         return
	ret


.pose
;> hLinkDirection = 2                         # facing up
	ld a, $02
	ldh [hLinkDirection], a
;> wLinkWalkingFrameCount = hFrameCounter & 8
	ldh a, [hFrameCounter]
	and $08
	ld [wLinkWalkingFrameCount], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> wSwordAnimationState = 0
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
	ret


;@ def MoblinKingHandler(slot: c)
;@ path: boss/moblin_king
;@ Handler of entity $E4, the big Moblin chief in the Moblins' cave, present only while BowWow is
;@ held there. After a word with Link he hops around him keeping some distance and throws spears,
;@ now and then winds up and charges sideways; if he rams the wall he bounces back dazed (and is
;@ open to attack), if he rams Link he knocks him away and gloats. Uses wEntityState directly as
;@ its state (MoblinKingStates). Gravity 3 per frame.
;@ test: skip jumps through a table
MoblinKingHandler::
;> if wIsBowWowFollowingLink != 0x80: return ClearEntityStatus_15(slot)   # BowWow not in the cave
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp nz, ClearEntityStatus_15
;>@vr if wEntityDirection[slot] == 0 and hActiveEntitySpriteVariant < 0x0C:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw
	ldh a, [hActiveEntitySpriteVariant]
;=@vr
	cp $0c
	jr nc, .draw
;>     hActiveEntitySpriteVariant += 6        # facing right: the mirrored poses
	add $06
	ldh [hActiveEntitySpriteVariant], a

.draw
;> MoblinKingDraw(slot)
	call MoblinKingDraw
;> if hActiveEntityStatus == 1:               # beaten
	ldh a, [hActiveEntityStatus]
	cp $01
	jr nz, .alive
;>     MoblinKingSetBodyPose(0x0C)            # dazed pose
	ld a, $0c
	call MoblinKingSetBodyPose
;>     return BossDefeated_15(slot)
	jp BossDefeated_15


.alive
;> ConfineLinkToArena()                                # keep Link inside the arena
	call ConfineLinkToArena
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> EntityCheckHits()                                # contact with Link and his weapons
	call EntityCheckHits
;> wEntityOptions1[slot] |= 0x40
	ld hl, wEntityOptions1
	add hl, bc
	set 6, [hl]
;> wEntityPhysicsFlags[slot] &= ~0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 3                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80   # (scratch here) nonzero = he has landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, .states
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.states
;> MoblinKingStates[wEntityState[slot]]()
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/moblin_king
;@ States of the Moblin King (rst $00 table indexed by wEntityState): 0 start, 1 talk, 2 hop and
;@ throw, 3 wind up, 4 charge, 5 dazed after hitting the wall, 6 brake after a charge, 7 look
;@ around, 8 rammed Link (set by the collision code), 9 gloat.
MoblinKingStates::
	dw MoblinKingInit
	dw MoblinKingIntro
	dw MoblinKingHop
	dw MoblinKingWindUp
	dw MoblinKingCharge
	dw MoblinKingStunned
	dw MoblinKingSlowDown
	dw MoblinKingLookAround
	dw MoblinKingRamLink
	dw MoblinKingGloat

;@ def MoblinKingInit(slot: c)
;@ path: boss/moblin_king
;@ State 0: stands still for $20 frames, facing Link.
;@ test: skip calls routines in other banks
MoblinKingInit::
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wMoblinKingHeadFrame = 0
	xor a
	ld [wMoblinKingHeadFrame], a
;> SetEntitySpriteVariant(0)
	call SetEntitySpriteVariant
;> IncrementEntityState()                                # next state
	call IncrementEntityState
;> MoblinKingFaceLink(slot)                   # falls through

;@ def MoblinKingFaceLink(slot: c)
;@ path: boss/moblin_king
;@ Turns the Moblin King towards Link (wMoblinKingFacing and his direction: 0 right, 1 left).
;@ test: slot = rand(0, 15)
MoblinKingFaceLink::
;> side, _ = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;> wMoblinKingFacing = side
	ld a, e
	ld [wMoblinKingFacing], a
;> wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ret


;@ def MoblinKingIntro(slot: c)
;@ path: boss/moblin_king
;@ State 1: after the pause he speaks (text $191), then the fight begins: first throw after $30
;@ frames, option flags $84.
;@ test: skip calls routines in other banks
MoblinKingIntro::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, .done
;> OpenDialogTable1(0x91)                     # text $191
	ld a, $91
	call OpenDialogTable1
;> wDialogState &= ~0x80
	ld hl, wDialogState
	res 7, [hl]
;> IncrementEntityState()                                # next state
	call IncrementEntityState
;> wEntityDropTimer[slot] = 0x30              # hops before the first charge
	call GetEntityDropTimer
	ld [hl], $30
;> wEntityOptions1[slot] = 0x84
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $84
;> wMoblinKingHeadFrame = 1
	ld a, $01
	ld [wMoblinKingHeadFrame], a
;> SetEntitySpriteVariant(1)
	ld a, $01
	call SetEntitySpriteVariant
	ret


.done
	ret


;@ path: boss/moblin_king
;@ X offset of a thrown spear from the Moblin King, by his direction (0 right, 1 left): +8, -8.
MoblinKingSpearX::
	db $08, $f8

;@ path: boss/moblin_king
;@ Y offset of a thrown spear, by direction: -4, -4.
MoblinKingSpearY::
	db $fc, $fc

;@ path: boss/moblin_king
;@ X speed of a thrown spear, by direction: +$20, -$20 (1/16 pixel per frame).
MoblinKingSpearSpeedX::
	db $20, $e0

;@ path: boss/moblin_king
;@ Y speed of a thrown spear, by direction: 0, 0.
MoblinKingSpearSpeedY::
	db $00, $00

;@ path: boss/moblin_king
;@ Where the Moblin King hops to, relative to Link's x, by the side Link is on (0 right of him:
;@ 48 pixels short of Link; 1 left: 48 pixels beyond), so he keeps his distance.
MoblinKingHopAim::
	db $d0, $30

;@ def MoblinKingHop(slot: c)
;@ path: boss/moblin_king
;@ State 2: hops towards a spot 48 pixels to the side of Link (speed $0C, hop $10 each landing),
;@ bobbing his head and facing Link. Every 48-111 frames he throws a spear (entity $0C) at frame
;@ 12 of a $18-frame throw. When wEntityDropTimer runs out he goes on to the wind-up ($30 frames).
;@ test: skip calls routines in other banks
MoblinKingHop::
;> t = wEntityTimer1[slot]
	call GetEntityTimer1
;>@th if t:                                    # throwing
	jr z, .notThrowing
;>     if t == 0x0C:
	cp $0c
	jr nz, .throwPose
;>         spear = SpawnEntity(0x0C)            # sets hMultiPurpose0-2 to our x, y, direction
	ld a, $0c
	call SpawnEntity
;>         if spear is not None:
	jr c, .throwPose
;>             hNoiseSfx = 0x0A
	ld a, $0a
	ldh [hNoiseSfx], a
;>             d = hMultiPurpose2                 # direction
	push bc
	ldh a, [hMultiPurpose2]
	ld c, a
;>@sxp             wEntityX[spear] = u8(hMultiPurpose0 + mem[MoblinKingSpearX + d])
	ld hl, MoblinKingSpearX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@sxp
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@syp             wEntityY[spear] = u8(hMultiPurpose1 + mem[MoblinKingSpearY + d])
	ld hl, MoblinKingSpearY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;=@syp
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             wEntitySpeedX[spear] = mem[MoblinKingSpearSpeedX + d]
	ld hl, MoblinKingSpearSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>             wEntitySpeedY[spear] = mem[MoblinKingSpearSpeedY + d]
	ld hl, MoblinKingSpearSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>             wEntitySpriteVariant[spear] = d
	ldh a, [hMultiPurpose2]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>             wEntityDirection[spear] = d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	pop bc

.throwPose
;>@tp     SetEntitySpriteVariant(2 if wEntityTimer1[slot] >= 0x0C else 0)   # arm raised, then thrown
	call GetEntityTimer1
	ld e, $00
	cp $0c
	jr c, .poseSet
	ld e, $02

.poseSet
;=@tp
	ld a, e
	call SetEntitySpriteVariant
;>     ClearEntitySpeed()                            # stands still while throwing
	call ClearEntitySpeed
;>     return
	ret


.notThrowing
;> if wEntityDropTimer[slot] == 0:            # time for a charge
	call GetEntityDropTimer
	jr nz, .hop
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     ClearEntitySpeed()                            # stop
	call ClearEntitySpeed
;>     return IncrementEntityState()                     # next state: wind-up
	call IncrementEntityState
	ret


.hop
;> if hBGTilesRequestCopy:                    # on the ground: next hop
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .animate
;>     link_x = hLinkX
	ldh a, [hLinkX]
	push af
;>     side, _ = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;>     hLinkX = u8(hLinkX + mem[MoblinKingHopAim + side])   # aim beside Link
	ld d, b
	ld hl, MoblinKingHopAim
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hLinkX], a
;>     SetEntitySpeedTowardsLink(0x0C)                        # speed $0C towards that spot
	ld a, $0c
	call SetEntitySpeedTowardsLink
;>     hLinkX = link_x
	pop af
	ldh [hLinkX], a
;>     wEntitySpeedZ[slot] = 0x10             # hop
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

.animate
;> frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(frame)
	call SetEntitySpriteVariant
;> wMoblinKingHeadFrame = frame
	ld [wMoblinKingHeadFrame], a
;> MoblinKingFaceLink(slot)
	call MoblinKingFaceLink
;> if wEntityTimer2[slot] == 0:               # time for the next throw
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
;>     wEntityTimer2[slot] = (GetRandomByte() & 0x3F) + 0x30
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
;>     wEntityTimer1[slot] = 0x18             # throw
	call GetEntityTimer1
	ld [hl], $18

.done
	ret


;@ path: boss/moblin_king
;@ X speed of the Moblin King's charge by his direction (0 right, 1 left): +$28, -$28.
MoblinKingChargeSpeed::
	db $28, $d8

;@ def MoblinKingWindUp(slot: c)
;@ path: boss/moblin_king
;@ State 3: stamps on the spot (stamp sound every 8 frames, poses 2/3), then charges sideways in
;@ the direction he faces for up to $22 frames.
;@ test: skip calls routines in other banks
MoblinKingWindUp::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .stamp
;>     wEntityTimer[slot] = 0x22
	ld [hl], $22
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>@cs     wEntitySpeedX[slot] = mem[MoblinKingChargeSpeed + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, MoblinKingChargeSpeed
	add hl, de
;=@cs
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     return IncrementEntityState()                     # next state: charge
	call IncrementEntityState
	ret


.stamp
;> if t & 7 == 0:
	and $07
	jr nz, .noStamp
;>     hJingle = 0x09
	ld a, $09
	ldh [hJingle], a

.noStamp
;> ClearEntitySpeed()
	call ClearEntitySpeed
;>@wp SetEntitySpriteVariant(2 + ((hFrameCounter >> 3) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;=@wp
	call SetEntitySpriteVariant
	ret


;@ def MoblinKingCharge(slot: c)
;@ path: boss/moblin_king
;@ State 4: the charge. Hitting a wall shakes the screen with a crash: he bounces back at a
;@ quarter of his speed with a hop ($28) and is dazed for $60 frames (state 5). If the charge
;@ time runs out he brakes instead (state 6).
;@ test: skip calls routines in other banks
MoblinKingCharge::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .charging
;>     wEntityState[slot] += 2                # brake
	call IncrementEntityState
	call IncrementEntityState
	ret


.charging
;> if wEntityCollisions[slot] & 3:            # rammed a wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .runPose
;>     wBumpShakeAxis = 0                     # horizontal shake
	xor a
	ld [wBumpShakeAxis], a
;>     wBumpShakeTimer = 0x20
	ld a, $20
	ld [wBumpShakeTimer], a
;>     hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;>@bb     wEntitySpeedX[slot] = u8(-(((wEntitySpeedX[slot] ^ 0x80) - 0x80) >> 2))   # a quarter, reversed
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	sra [hl]
	ld a, [hl]
;=@bb
	cpl
	inc a
	ld [hl], a
;>     wEntitySpeedZ[slot] = 0x28
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $28
;>     IncrementEntityState()                            # next state: dazed
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60

.runPose
;> pose = 4 + ((hFrameCounter >> 2) & 1)     # running
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	add $04
;> MoblinKingSetBodyPose(pose)               # falls through

;@ def MoblinKingSetBodyPose(pose: a)
;@ path: boss/moblin_king
;@ Sets a whole-body pose of the Moblin King (sprite variant `pose`) and hides his separate head.
;@ test: skip calls routines in other banks
MoblinKingSetBodyPose::
;> SetEntitySpriteVariant(pose)
	call SetEntitySpriteVariant
;> wMoblinKingHeadFrame = 0xFF                # no separate head
	ld a, $ff
	ld [wMoblinKingHeadFrame], a
	ret


;@ path: boss/moblin_king
;@ Y offsets of the stars circling the dazed Moblin King's head, 8 steps of a loop (pixels).
MoblinKingStarY::
	db $00, $fe, $fd, $fe, $00, $02, $03, $02

;@ path: boss/moblin_king
;@ X offsets of the circling stars, 8 steps (pixels): 0 to 16 and back.
MoblinKingStarX::
	db $00, $04, $08, $0c, $10, $0c, $08, $04

;@ def MoblinKingStunned(slot: c)
;@ path: boss/moblin_king
;@ State 5: dazed after ramming the wall: while it lasts ($60 frames) he can be hurt, stands
;@ swaying (poses 12/13) and two stars circle over his head. Then he looks around ($40 frames).
;@ test: skip calls routines in other banks
MoblinKingStunned::
;> wEntityOptions1[slot] &= ~0x40
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
;> wEntityPhysicsFlags[slot] |= 0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 7, [hl]
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .dazed
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityState[slot] += 2                # look around
	call IncrementEntityState
	call IncrementEntityState
;>     wMoblinKingHeadFrame = 0
	ld a, $00
	ld [wMoblinKingHeadFrame], a
;>     return SetEntitySpriteVariant(0)
	jp SetEntitySpriteVariant


.dazed
;> if hBGTilesRequestCopy: ClearEntitySpeed()        # landed: stop sliding
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .pose
	call ClearEntitySpeed

.pose
;>@dp SetEntitySpriteVariant(0x0C + ((hFrameCounter >> 3) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $0c
;=@dp
	call SetEntitySpriteVariant
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, b
	ld hl, wOAMBuffer + $30
	add hl, de
;> MoblinKingDrawStars(oam, (hFrameCounter >> 3) & 7)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	call MoblinKingDrawStars
;> ReserveOAMEntriesFar(2)                               # reserve the 2 OAM entries
	ld a, $02
	jp ReserveOAMEntriesFar


;@ def MoblinKingDrawStars(oam: hl, step: a)
;@ path: boss/moblin_king
;@ Writes the two stars circling the dazed Moblin King into the OAM buffer at `oam`: one at
;@ `step` of the 8-step loop, the other half a loop further on.
;@ test: skip writes the OAM buffer
MoblinKingDrawStars::
;> oam = MoblinKingDrawStar(oam, step)
	call MoblinKingDrawStar
;> step = ((hFrameCounter >> 3) + 4) & 7       # the second star, opposite
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	add $04
	and $07
;> MoblinKingDrawStar(oam, step)              # falls through

;@ def MoblinKingDrawStar(oam: hl, step: a) -> hl
;@ path: boss/moblin_king
;@ Writes one star (tile $24) into the OAM buffer at `oam`, at step `step` (0-7) of the loop
;@ above the Moblin King's head; returns the next OAM entry.
;@ test: skip writes the OAM buffer
MoblinKingDrawStar::
;>@dy dy = mem[MoblinKingStarY + step]
	push bc
	push hl
	ld e, a
	ld d, $00
	ld hl, MoblinKingStarY
	add hl, de
;=@dy
	ld b, [hl]
;> dx = mem[MoblinKingStarX + step]
	ld hl, MoblinKingStarX
	add hl, de
	ld c, [hl]
	pop hl
;> mem[oam] = u8(hActiveEntityDrawY + dy - 10)
	ldh a, [hActiveEntityDrawY]
	add b
	add $f6
	ld [hli], a
;> mem[oam + 1] = u8(hActiveEntityX + dx - 4)
	ldh a, [hActiveEntityX]
	add c
	add $fc
	ld [hli], a
;> mem[oam + 2] = 0x24                        # star tile
	ld [hl], $24
	inc hl
;> mem[oam + 3] = 0
	ld [hl], $00
	inc hl
;> return oam + 4
	pop bc
	ret


;@ def MoblinKingSlowDown(slot: c)
;@ path: boss/moblin_king
;@ State 6: the charge ended without hitting the wall: he brakes by 2 per frame; once nearly
;@ stopped he looks around for $40 frames.
;@ test: skip calls routines in other banks
MoblinKingSlowDown::
;> if wEntitySpeedX[slot] & 0xFE == 0:        # (almost) stopped
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $fe
	jr nz, .brake
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     return IncrementEntityState()                     # next state: look around
	jp IncrementEntityState


.brake
;> if wEntitySpeedX[slot] & 0x80:             # moving left: towards 0 from below
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .slower
;>     wEntitySpeedX[slot] += 4
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

.slower
;> wEntitySpeedX[slot] -= 2
	dec [hl]
	dec [hl]
;> wMoblinKingHeadFrame = 0
	ld a, $00
	ld [wMoblinKingHeadFrame], a
;> SetEntitySpriteVariant(0)
	call SetEntitySpriteVariant
	ret


;@ def MoblinKingLookAround(slot: c)
;@ path: boss/moblin_king
;@ State 7: stands still turning his head left and right every 16 frames, then goes back to
;@ hopping (MoblinKingResumeHopping).
;@ test: skip calls routines in other banks
MoblinKingLookAround::
;> ClearEntitySpeed()
	call ClearEntitySpeed
;> if wEntityTimer[slot]: return MoblinKingTurnHead()
	call GetEntityTimer
	jr nz, MoblinKingTurnHead
;> MoblinKingResumeHopping(slot)              # falls through

;@ def MoblinKingResumeHopping(slot: c)
;@ path: boss/moblin_king
;@ Back to state 2 (hopping); the next charge comes after 32-63 frames of wEntityDropTimer.
;@ test: skip calls routines in other banks
MoblinKingResumeHopping::
;> wEntityDropTimer[slot] = (GetRandomByte() & 0x1F) + 0x20
	call GetEntityDropTimer
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
	ret


;@ def MoblinKingTurnHead()
;@ path: boss/moblin_king
;@ The rest of state 7 while it lasts: the Moblin King looks the other way every 16 frames.
;@ test: hFrameCounter = rand(0, 255)
MoblinKingTurnHead::
;>@tf wMoblinKingFacing = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@tf
	ld [wMoblinKingFacing], a
	ret


;@ def MoblinKingRamLink(slot: c)
;@ path: boss/moblin_king
;@ State 8, entered when his charge hits Link: Link is knocked away with the king's speed ($28
;@ frames), invincible for $40 frames and loses one heart; then the king gloats ($60 frames).
;@ test: skip calls routines in other banks
MoblinKingRamLink::
;> IncrementEntityState()                                # next state: gloat
	call IncrementEntityState
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;> hLinkSpeedX = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ldh [hLinkSpeedX], a
;> wLinkPushedTimer = 0x28
	ld a, $28
	ld [wLinkPushedTimer], a
;> wInvincibilityCounter = 0x40
	ld a, $40
	ld [wInvincibilityCounter], a
;> wSubtractHealthBuffer += 8                 # one heart
	ld a, [wSubtractHealthBuffer]
	add $08
	ld [wSubtractHealthBuffer], a
;> hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
	ret


;@ def MoblinKingGloat(slot: c)
;@ path: boss/moblin_king
;@ State 9: stands facing Link; for the last $40 frames he bobs (poses 0/1 every 32 frames).
;@ Then back to hopping.
;@ test: skip calls routines in other banks
MoblinKingGloat::
;> ClearEntitySpeed()
	call ClearEntitySpeed
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0: return MoblinKingResumeHopping(slot)
	jr nz, .gloat
	jp MoblinKingResumeHopping


.gloat
;>@gf frame = 0 if t >= 0x40 else (hFrameCounter >> 5) & 1
	cp $40
	ld a, $00
	jr nc, .pose
	ldh a, [hFrameCounter]
	rra
	rra
;=@gf
	rra
	rra
	rra
	and $01

.pose
;> SetEntitySpriteVariant(frame)
	call SetEntitySpriteVariant
;> wMoblinKingHeadFrame = frame
	ld [wMoblinKingHeadFrame], a
;> MoblinKingFaceLink(slot)
	call MoblinKingFaceLink
	ret


;@ path: boss/moblin_king
;@ The Moblin King's head for RenderActiveEntitySpritesRect: 4 entries (index wMoblinKingFacing
;@ * 2 + wMoblinKingHeadFrame), each 3 OAM entries of 4 bytes (y offset, x offset, tile,
;@ attributes): tiles $50/$52/$54 in a row 8 (frame 1: 9) pixels above the body; facing right
;@ they are x-flipped.
MoblinKingHeadSprites::
	db $f8, $fc, $54, $20, $f8, $04, $52, $20, $f8, $0c, $50, $20, $f7, $fc, $54, $20
	db $f7, $04, $52, $20, $f7, $0c, $50, $20, $f8, $fc, $50, $00, $f8, $04, $52, $00
	db $f8, $0c, $54, $00, $f7, $fc, $50, $00, $f7, $04, $52, $00, $f7, $0c, $54, $00
;@ path: boss/moblin_king
;@ The Moblin King's body for RenderActiveEntitySpritesRect: 14 poses (the sprite variant), each
;@ 3 OAM entries of 4 bytes (y offset, x offset, tile, attributes), a 24 pixel wide row.
;@ 0-1 standing (tiles $56-$5E), 2-3 stamping, 4-5 running ($70-$78), facing left; 6-11 the same
;@ facing right (x-flipped); 12-13 dazed ($7A-$7E).
MoblinKingBodySprites::
	db $00, $fc, $56, $00, $00, $04, $58, $00, $00, $0c, $5a, $00, $00, $fc, $5c, $00
	db $00, $04, $58, $00, $00, $0c, $5e, $00, $00, $fc, $5c, $00, $00, $04, $58, $00
	db $00, $0c, $5a, $00, $00, $fc, $56, $00, $00, $04, $58, $00, $00, $0c, $5e, $00
	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $74, $00, $01, $fc, $70, $00
	db $00, $04, $76, $00, $00, $0c, $78, $00, $00, $fc, $5a, $20, $00, $04, $58, $20
	db $00, $0c, $56, $20, $00, $fc, $5e, $20, $00, $04, $58, $20, $00, $0c, $5c, $20
	db $00, $fc, $5a, $20, $00, $04, $58, $20, $00, $0c, $5c, $20, $00, $fc, $5e, $20
	db $00, $04, $58, $20, $00, $0c, $56, $20, $00, $fc, $74, $20, $00, $04, $72, $20
	db $00, $0c, $70, $20, $00, $fc, $78, $20, $00, $04, $76, $20, $01, $0c, $70, $20
	db $00, $fc, $7a, $00, $00, $04, $7c, $00, $00, $0c, $7e, $00, $00, $fc, $7e, $20
	db $00, $04, $7c, $20, $00, $0c, $7a, $20

;@ path: boss/moblin_king
;@ The Moblin King's shadow while he is in the air: 3 OAM entries of 4 bytes (y offset, x
;@ offset, tile, attributes), shadow tile $26, 12 pixels below his ground position.
MoblinKingShadowSprites::
	db $0c, $ff, $26, $00, $0c, $04, $26, $00
	db $0c, $09, $26, $00

;@ def MoblinKingDraw(slot: c)
;@ path: boss/moblin_king
;@ Draws the Moblin King: his head (unless wMoblinKingHeadFrame is $FF), his body pose and,
;@ while he is in the air, his shadow at his ground position.
;@ test: skip calls routines in other banks
MoblinKingDraw::
;> if wMoblinKingHeadFrame != 0xFF:
	ld a, [wMoblinKingFacing]
	sla a
	ld e, a
	ld a, [wMoblinKingHeadFrame]
	cp $ff
	jr z, .body
;>     head = wMoblinKingFacing * 2 + wMoblinKingHeadFrame
	add e
;>@hd     DrawEntitySprites(MoblinKingHeadSprites + head * 12, 3)
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
;=@hd
	add e
	ld e, a
	ld d, b
	ld hl, MoblinKingHeadSprites
	add hl, de
;=@hd
	ld c, $03
	call DrawEntitySprites

.body
;>@bd DrawEntitySprites(MoblinKingBodySprites + hActiveEntitySpriteVariant * 12, 3)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
;=@bd
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, MoblinKingBodySprites
	add hl, de
;=@bd
	ld c, $03
	call DrawEntitySprites
;> if wEntityZ[slot]:                         # in the air: shadow
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hActiveEntityDrawY = hActiveEntityY    # on the ground
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;>     DrawEntitySprites(MoblinKingShadowSprites, 3)
	ld hl, MoblinKingShadowSprites
	ld c, $03
	call DrawEntitySprites
;>     LoadEntityPosition()                            # restore the active position copies
	call LoadEntityPosition

.done
	ret


;@ path: enemy/pokey
;@ Pokey with all three body parts, for RenderActiveEntitySpritesRect: 4 variants (the sway
;@ animation, picked by the frame counter), each 6 OAM entries of 4 bytes (y offset, x offset,
;@ tile, attributes): the head (tile $74, both halves, y -24) over two body parts (tile $76,
;@ y -12 and 0); the upper parts lean a pixel or two left and right.
PokeySpritesFull::
	db $e8, $fe, $74, $00, $e8, $06, $74, $20, $f4, $01, $76, $00, $f4, $09, $76, $20
	db $00, $00, $76, $00, $00, $08, $76, $20, $e8, $00, $74, $00, $e8, $08, $74, $20
	db $f4, $00, $76, $00, $f4, $08, $76, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $e8, $02, $74, $00, $e8, $0a, $74, $20, $f4, $ff, $76, $00, $f4, $07, $76, $20
	db $00, $00, $76, $00, $00, $08, $76, $20, $e8, $00, $74, $00, $e8, $08, $74, $20
	db $f4, $00, $76, $00, $f4, $08, $76, $20, $00, $00, $76, $00, $00, $08, $76, $20
;@ path: enemy/pokey
;@ Pokey after losing one body part: 4 sway variants, each 4 OAM entries of 4 bytes (y offset,
;@ x offset, tile, attributes): the head (tile $74, y -12) on one body part (tile $76, y 0).
PokeySpritesTwoParts::
	db $f4, $ff, $74, $00, $f4, $07, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $00, $74, $00, $f4, $08, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $01, $74, $00, $f4, $09, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $00, $74, $00, $f4, $08, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
;@ path: enemy/pokey
;@ Pokey reduced to its head: 4 sway variants, each 2 OAM entries of 4 bytes (y offset, x
;@ offset, tile, attributes), tile $74.
PokeySpritesHead::
	db $00, $ff, $74, $00, $00, $07, $74, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $00, $01, $74, $00, $00, $09, $74, $20, $00, $00, $74, $00, $00, $08, $74, $20
;@ path: enemy/pokey
;@ Pokey's walking speeds for 8 directions around a circle (signed, 1/16 pixel per frame). The
;@ y speed of direction d is PokeySpeedY[d], the x speed PokeySpeedX[d]; the two tables
;@ overlap (the y table runs on into the x table: y = -6, -4, 0, 4, 6, 4, 0, -4).
PokeySpeedY::
	db $fa, $fc

;@ path: enemy/pokey
;@ X speeds of Pokey's 8 directions: 0, 4, 6, 4, 0, -4, -6, -4 (see PokeySpeedY).
PokeySpeedX::
	db $00, $04, $06, $04, $00, $fc, $fa, $fc

;@ def PokeyHandler(slot: c)
;@ path: enemy/pokey
;@ Handler of entity $E3, Pokey, the cactus stack of the desert. It wanders in one of 8 random
;@ directions for 48-111 frames at a time. Each of the first two hits knocks off a body part:
;@ another $E3 (wEntityPrivate1 = 1, see PokeySegment) that flies away from Link; its health
;@ is refilled to 2 until both parts are gone. Then the head alone can be beaten.
;@ test: skip calls routines in other banks
PokeyHandler::
;> if wEntityPrivate1[slot]: return PokeySegment(slot)   # a flying body part
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, PokeySegment
;> PokeyDraw(slot)
	call PokeyDraw
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;>@lost if wEntityPrivateCounter[slot] < 2:    # body parts lost so far
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $02
	jr nc, .move
;>     wEntityHealth[slot] = 2
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $02
;>     if wEntityFlashTimer[slot] == 0x14:    # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $14
	jr nz, .move
;>         wEntityFlashTimer[slot] -= 1
	dec [hl]
;>         wEntityPrivateCounter[slot] += 1   # one part less
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>         part = SpawnEntity(0xE3)             # the knocked-off part
	ld a, $e3
	call SpawnEntity
;>         if part is not None:
	jr c, .move
;>             wEntityX[part] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[part] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             wEntityPrivate1[part] += 1         # a body part
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>             GetVectorTowardsLink(0x20)                    # vector from the part to Link
	push bc
	push de
	pop bc
	ld a, $20
	call GetVectorTowardsLink
;>             wEntitySpeedX[part] = u8(-hMultiPurpose1)   # away from Link
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>             wEntitySpeedY[part] = u8(-hMultiPurpose0)
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>             wEntityTimer[part] = 0x18          # harmless for $18 frames
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], $18
	pop bc

.move
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits()                                # contact with Link and his weapons
	call EntityCheckHits
;>@sw SetEntitySpriteVariant((hFrameCounter >> 3) & 3)        # sway
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	and $03
;=@sw
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:                # new direction
	call GetEntityTimer
	jr nz, .walk
;>     t = (GetRandomByte() & 0x3F) + 0x30
	call GetRandomByte
	and $3f
	add $30
;>     wEntityTimer[slot] = t
	ld [hl], a
;>     d = t & 7
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[PokeySpeedX + d]
	ld hl, PokeySpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[PokeySpeedY + d]
	ld hl, PokeySpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.walk
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
	ret


;@ def PokeyDraw(slot: c)
;@ path: enemy/pokey
;@ Draws Pokey with as many body parts as it has left (wEntityPrivateCounter = parts lost),
;@ and reserves the OAM entries beyond the first two.
;@ test: skip calls routines in other banks
PokeyDraw::
;> lost = wEntityPrivateCounter[slot]
	ld d, b
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> if lost == 0:
	and a
	jr nz, .lost
;>@full     DrawEntitySprites(PokeySpritesFull + hActiveEntitySpriteVariant * 24, 6)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld e, a
;=@full
	rla
	and $f0
	add e
	ld e, a
	ld hl, PokeySpritesFull
	add hl, de
;=@full
	ld c, $06
	call DrawEntitySprites
;>     return ReserveOAMEntriesFar(4)
	ld a, $04
	jp ReserveOAMEntriesFar


.lost
;> if lost != 2:
	cp $02
	jr z, .head
;>@two     DrawEntitySprites(PokeySpritesTwoParts + hActiveEntitySpriteVariant * 16, 4)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;=@two
	ld e, a
	ld hl, PokeySpritesTwoParts
	add hl, de
	ld c, $04
	call DrawEntitySprites
;>     return ReserveOAMEntriesFar(2)
	ld a, $02
	jp ReserveOAMEntriesFar


.head
;>@hd DrawEntitySprites(PokeySpritesHead + hActiveEntitySpriteVariant * 8, 2)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld e, a
;=@hd
	ld hl, PokeySpritesHead
	add hl, de
	ld c, $02
	jp DrawEntitySprites


;@ path: enemy/pokey
;@ A knocked-off Pokey body part for RenderActiveEntitySpritesPair: one variant, tile $76 and its
;@ mirror image (2 bytes per half: tile, attributes).
PokeySegmentSprites::
	db $76, $00, $76, $20

;@ def PokeySegment(slot: c)
;@ path: enemy/pokey
;@ A knocked-off Pokey body part: flies straight on, harmless for its first $18 frames, then
;@ hurts Link (and can be hit). It bounces off walls; at the third bounce it bursts.
;@ test: skip calls routines in other banks
PokeySegment::
;> DrawEntity16x16(PokeySegmentSprites)            # draw it
	ld de, PokeySegmentSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> if wEntityTimer[slot] == 0: EntityCheckHits()    # contact with Link and his weapons
	call GetEntityTimer
	jr nz, .fly
	call EntityCheckHits

.fly
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 3:            # a wall left or right
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .vertical
;>     if PokeySegmentBounce(wEntitySpeedX, slot): return   # burst
	ld hl, wEntitySpeedX
	call PokeySegmentBounce
	ret c

.vertical
;> if wEntityCollisions[slot] & 0x0C:         # a wall above or below
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, PokeySegmentBounce.noBurst
;>     PokeySegmentBounce(wEntitySpeedY, slot)   # falls through
	ld hl, wEntitySpeedY

;@ def PokeySegmentBounce(speeds: hl, slot: c) -> carry
;@ path: enemy/pokey
;@ Reverses the body part's speed in the array `speeds` (wEntitySpeedX or wEntitySpeedY) with a
;@ bump sound and counts the bounce; at the third one it bursts (explosion effect, sound $2F,
;@ removed) and returns carry.
;@ test: skip calls routines in other banks
PokeySegmentBounce::
;> mem[speeds + slot] = u8(-mem[speeds + slot])
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> hJingle = 0x09
	ld a, $09
	ldh [hJingle], a
;> wEntityPrivateCounter[slot] += 1           # bounces
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] < 3: return False
	cp $03
	jr c, .noBurst
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                         # explosion
	ld a, $02
	call AddTransientVfx
;> hJingle = 0x2F
	ld a, $2f
	ldh [hJingle], a
;> ClearEntityStatus_15(slot)
	call ClearEntityStatus_15
;> return True
	scf
	ret


.noBurst
	and a
	ret


;@ path: enemy/flame_shooter
;@ The flame shooter (a statue's mouth) for RenderActiveEntitySpritesPair: 2 variants, 4 bytes
;@ each (tile, attributes for both 8x16 halves): 0 idle (tile $70 mirrored), 1 firing ($72).
FlameShooterSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20

;@ def FlameShooterHandler(slot: c)
;@ path: enemy/flame_shooter
;@ Handler of entity $E2, the flame shooter. The placed entity spits a flame (another $E2 with
;@ wEntityPrivate1 = 1, see FlameShooterFlame) downwards every 16 frames, showing its firing
;@ frame for 8 frames.
;@ test: skip calls routines in other banks
FlameShooterHandler::
;> if wEntityPrivate1[slot]: return FlameShooterFlame(slot, wEntityPrivate1[slot])
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, FlameShooterFlame
;> DrawEntity16x16(FlameShooterSprites)            # draw it
	ld de, FlameShooterSprites
	call DrawEntity16x16
;>@fp SetEntitySpriteVariant(1 if wEntityTimer1[slot] else 0)   # firing frame
	call GetEntityTimer1
	ld e, $00
	and a
	jr z, .pose
	inc e

.pose
;=@fp
	ld a, e
	call SetEntitySpriteVariant
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] & 0x0F: return
	ld a, [hl]
	and $0f
	jr nz, .done
;> wEntityTimer1[slot] = 8
	call GetEntityTimer1
	ld [hl], $08
;> flame = SpawnEntity(0xE2)
	ld a, $e2
	call SpawnEntity
;> if flame is None: return
	ret c
;> hNoiseSfx = 0x12
	ld a, $12
	ldh [hNoiseSfx], a
;> wEntityX[flame] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[flame] = u8(hMultiPurpose1 + 4)
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $04
	ld [hl], a
;> wEntityPrivate1[flame] += 1                # a flame
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> wEntitySpeedY[flame] = 0x10               # downwards
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $10
;> wEntityTimer[flame] = 0x30                # lifetime
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $30

.done
	ret


;@ path: enemy/flame_shooter
;@ A flame for RenderActiveEntitySpritesPair: 3 variants (growing: 0 small $78, 1 $76, 2 big
;@ $74), 4 bytes each (tile, attributes for both mirrored 8x16 halves).
FlameSprites::
	db $78, $00, $78, $20, $76, $00, $76, $20, $74, $00, $74, $20

;@ path: enemy/flame_shooter
;@ A small flame (after a flame was split by the Mirror Shield): 2 variants of 4 bytes (tile,
;@ attributes per half): 0 tiles $7A/$7C, 1 the same mirrored.
SmallFlameSprites::
	db $7a, $00, $7c, $00
	db $7c, $20, $7a, $20

;@ path: enemy/flame_shooter
;@ X offsets of the two small flames from the split flame: -4, +4.
SmallFlameOffsetX::
	db $fc, $04

;@ path: enemy/flame_shooter
;@ X speeds of the two small flames: -12, +12 (1/16 pixel per frame).
SmallFlameSpeedX::
	db $f4, $0c

;@ def FlameShooterFlame(slot: c, kind: a)
;@ path: enemy/flame_shooter
;@ A flame (wEntityPrivate1 = 1) falling from the shooter: it flickers, grows at $20 and $10
;@ frames before its end and vanishes after $30 frames. When it touches Link, his invincibility
;@ is cut to $1F frames and he is pushed back. If Link blocks it with the Mirror Shield (the
;@ collision code then raises its state), it splits into two small flames flying apart.
;@ test: skip calls routines in other banks
FlameShooterFlame::
;> if kind == 2: return FlameShooterSmallFlame(slot)
	cp $02
	jp z, FlameShooterSmallFlame
;> hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10   # flicker
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(FlameSprites)                   # draw it
	ld de, FlameSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits()                                # weapons hit it
	call EntityCheckWeaponHits
;> before = wInvincibilityCounter
	ld a, [wInvincibilityCounter]
	push af
;> EntityTouchesLink()                                # touching Link hurts him
	call EntityTouchesLink
;>@hit if wInvincibilityCounter != before and wInvincibilityCounter >= 0x20:   # Link was just hit
	pop af
	ld e, a
	ld a, [wInvincibilityCounter]
	cp e
	jr z, .fall
	cp $20
;=@hit
	jr c, .fall
;>     wInvincibilityCounter = 0x1F
	ld a, $1f
	ld [wInvincibilityCounter], a
;>     GetVectorTowardsLink(0x30)                        # vector towards Link
	ld a, $30
	call GetVectorTowardsLink
;>     hLinkSpeedY = hMultiPurpose0           # push Link away vertically
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a

.fall
;> AddEntitySpeedToPosY_15(slot)
	call AddEntitySpeedToPosY_15
;> if hActiveEntityState:                     # blocked by the Mirror Shield: split
	ldh a, [hActiveEntityState]
	and a
	jr z, .burn
;>@sp     for i in range(2):
	xor a

.split
;>         hBGTilesRequestCopy = i            # (scratch here)
	ldh [hBGTilesRequestCopy], a
;>         small = SpawnEntity(0xE2)
	ld a, $e2
	call SpawnEntity
;>         if small is None: break
	jr c, .remove
;>         wEntityPrivate1[small] = 2         # a small flame
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>         wEntitySpriteVariant[small] = i
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>@sx         wEntityX[small] = u8(hMultiPurpose0 + mem[SmallFlameOffsetX + i])
	ld hl, SmallFlameOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@sx
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntitySpeedX[small] = mem[SmallFlameSpeedX + i]
	ld hl, SmallFlameSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntityY[small] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	add $00
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntitySpeedY[small] = 0x0C
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $0c
;>         wEntityTimer[small] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
	pop bc
;=@sp
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $02
	jr c, .split

.remove
;>     return ClearEntityStatus_15(slot)
	jp ClearEntityStatus_15


.burn
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0: return ClearEntityStatus_15(slot)   # burnt out
	jp z, ClearEntityStatus_15
;>@gr if (t == 0x10 or t == 0x20) and wEntitySpriteVariant[slot] != 2:
	ld hl, wEntitySpriteVariant
	add hl, bc
	cp $10
	jr z, .grow
	cp $20
	jr nz, .done

.grow
;=@gr
	ld a, [hl]
	cp $02
	jr z, .done
;>     wEntitySpriteVariant[slot] += 1        # grow
	inc [hl]

.done
	ret


;@ def FlameShooterSmallFlame(slot: c)
;@ path: enemy/flame_shooter
;@ A small flame from a split flame (wEntityPrivate1 = 2): flickers and flies on for $20 frames.
;@ test: skip calls routines in other banks
FlameShooterSmallFlame::
;> hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10   # flicker
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(SmallFlameSprites)              # draw it
	ld de, SmallFlameSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> if wEntityTimer[slot] == 0: return ClearEntityStatus_15(slot)
	call GetEntityTimer
	jp z, ClearEntityStatus_15
	ret


;@ path: enemy/stalfos_evasive
;@ Evasive Stalfos sprites for RenderActiveEntitySpritesPair: 3 variants, 4 bytes each (tile,
;@ attributes for the two 8x16 halves): 0-1 walking ($4A/$4C and its mirror image), 2 jumping
;@ ($4E mirrored).
EvasiveStalfosSprites::
	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

;@ path: enemy/stalfos_evasive
;@ Speeds an Evasive Stalfos picks from when it turns (1/16 pixel per frame): x speed from
;@ bytes 0-3 (0, 6, -6, -6); when that is 0 it walks vertically with a y speed from bytes 3-4
;@ (-6, 6).
EvasiveStalfosWalkSpeeds::
	db $00, $06, $fa, $fa
	db $06

;@ path: enemy/stalfos_evasive
;@ The bone an Evasive Stalfos throws, for RenderActiveEntitySpritesPair: 2 variants (the
;@ spin), 4 bytes each: tile $48 with different flips.
EvasiveStalfosBoneSprites::
	db $48, $00, $48, $60, $48, $40, $48, $20

;@ def EvasiveStalfosHandler(slot: c)
;@ path: enemy/stalfos_evasive
;@ Handler of entity $1E, the Stalfos that jumps away from Link's attacks. It walks about,
;@ turning at random; when Link presses A or B within 36 pixels it leaps away from him
;@ (state EvasiveStalfosDodgeJump) and, from dungeon 3 on, throws a bone at Link a moment after
;@ landing. A thrown bone is another $1E with wEntityPrivate1 = 1: it spins towards Link and
;@ breaks on walls, on hitting something, or leaves the screen.
;@ test: skip calls routines in other banks
EvasiveStalfosHandler::
;> if wEntityPrivate1[slot]:                  # a bone
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .stalfos
;>     DrawEntity16x16(EvasiveStalfosBoneSprites)  # draw it
	ld de, EvasiveStalfosBoneSprites
	call DrawEntity16x16
;>     ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;>     SetEntitySpriteVariant((hFrameCounter >> 3) & 1)    # spin
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;>     UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;>     EntityCheckWalls()                            # background collision
	call EntityCheckWalls
;>     broken = wEntityCollisions[slot]       # hit a wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>     if not broken:
	jp nz, .boneBreak
;>         EntityCheckHits()                        # contact with Link and his weapons
	call EntityCheckHits
;>         broken = wEntityIgnoreHitsTimer[slot]   # it hit something / was hit
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
;>     if broken:
	jr z, .boneFlies

.boneBreak
;>         hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;>         hJingle = 0x07
	ld a, $07
	ldh [hJingle], a
;>         AddTransientVfx(5)                  # the bone breaks apart
	ld a, $05
	call AddTransientVfx
;>         return ClearEntityStatus_15(slot)
	jp ClearEntityStatus_15


.boneFlies
;>     if hActiveEntityX >= 0xA8: return ClearEntityStatus_15(slot)
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_15
;>     if hActiveEntityDrawY >= 0x84: return ClearEntityStatus_15(slot)
	ldh a, [hActiveEntityDrawY]
	cp $84
	jp nc, ClearEntityStatus_15
;>     return
	ret


.stalfos
;> DrawEntity16x16(EvasiveStalfosSprites)          # draw it
	ld de, EvasiveStalfosSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> if wEntityTimer[slot] == 0: EntityCheckHits()    # contact (not right after it jumped)
	call GetEntityTimer
	jr nz, .throw
	call EntityCheckHits

.throw
;> if wEntityTimer1[slot] == 1:               # time to throw
	call GetEntityTimer1
	cp $01
	jr nz, .steps
;>     if hMapId < 3: return                  # no bones in the first dungeons
	ldh a, [hMapId]
	cp $03
	ret c
;>     bone = SpawnEntity(0x1E)
	ld a, $1e
	call SpawnEntity
;>     if bone is None: return
	ret c
;>     hNoiseSfx = 0x0A
	ld a, $0a
	ldh [hNoiseSfx], a
;>     wEntityIgnoreHitsTimer[bone] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], b
;>     wEntityPhysicsFlags[bone] |= 0x50
	ld hl, wEntityPhysicsFlags
	add hl, de
	set 6, [hl]
	set 4, [hl]
;>     wEntityOptions1[bone] |= 0x12
	ld hl, wEntityOptions1
	add hl, de
	set 1, [hl]
	set 4, [hl]
;>     wEntityX[bone] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[bone] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[bone] = hMultiPurpose3        # thrown from the Stalfos' height
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[bone] += 1             # a bone
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>     SetEntitySpeedTowardsLink(0x18)                        # the bone flies at Link, speed $18
	push bc
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
	pop bc

.steps
;> EvasiveStalfosSteps[wEntityPrivateCounter[slot]]()
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: enemy/stalfos_evasive
;@ Steps of the Evasive Stalfos (rst $00 table indexed by wEntityPrivateCounter): 0 walk,
;@ 1 dodge jump.
EvasiveStalfosSteps::
	dw EvasiveStalfosWalk
	dw EvasiveStalfosDodgeJump

;@ def EvasiveStalfosWalk(slot: c)
;@ path: enemy/stalfos_evasive
;@ Step 0: walks. If Link presses A or B within 36 pixels, it leaps away from him (upward speed
;@ $15, speed $12 away, jump sound). Against a wall it turns back (the high nibble of that speed
;@ is flipped, so 6 becomes -10 and -6 becomes 10); now and then (or when its state is set) it
;@ picks a new direction from EvasiveStalfosWalkSpeeds.
;@ test: skip calls routines in other banks
EvasiveStalfosWalk::
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;>@dodge if hJoypadPressed & 0x30:             # Link attacks (A or B)
	ldh a, [hJoypadPressed]
	and $30
	jr z, .walk
;>     _, dx = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;>     if u8(dx + 0x24) < 0x48:
	add $24
	cp $48
	jr nc, .walk
;>         _, dy = GetEntityYDistanceToLink_15(slot)
	call GetEntityYDistanceToLink_15
;>         if u8(dy + 0x24) < 0x48:           # Link is close: jump away
	add $24
	cp $48
	jr nc, .walk
;>             wEntityTimer[slot] = 8             # not harmful for 8 frames
	call GetEntityTimer
	ld [hl], $08
;>             wEntityTimer1[slot] = 0
	call GetEntityTimer1
	ld [hl], b
;>             wEntityPrivateCounter[slot] += 1   # dodge jump
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>             wEntitySpeedZ[slot] = 0x15
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $15
;>             hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
;>             GetVectorTowardsLink(0x12)                    # vector towards Link
	ld a, $12
	call GetVectorTowardsLink
;>             wEntitySpeedY[slot] = u8(-hMultiPurpose0)   # away from him
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>             wEntitySpeedX[slot] = u8(-hMultiPurpose1)
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>             wEntitySpriteVariant[slot] = 2     # jumping
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $02
;>             return
	ret


.walk
;> walls = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
;> if walls & 3:
	and $03
	jr nz, .turnX
;>@ty     wEntitySpeedX[slot] ^= 0xF0
;> elif walls & 0x0C:
	ld a, [hl]
	and $0c
	jr z, .turnDone
;>     wEntitySpeedY[slot] ^= 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jr .turnDone

.turnX
;=@ty
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a

.turnDone
;>@pick if wEntityState[slot] or GetRandomByte() & 0x2F == 0:   # sometimes: a new direction
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .pick
	call GetRandomByte
;=@pick
	and $2f
	jr nz, .animate

.pick
;>     wEntitySpeedY[slot] = 0
	xor a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>@px     wEntitySpeedX[slot] = mem[EvasiveStalfosWalkSpeeds + (GetRandomByte() & 3)]
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, EvasiveStalfosWalkSpeeds
	add hl, de
;=@px
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     if wEntitySpeedX[slot] == 0:           # walk vertically instead
	and a
	jr nz, .animate
;>@py         wEntitySpeedY[slot] = mem[EvasiveStalfosWalkSpeeds + 3 + (GetRandomByte() & 1)]
	call GetRandomByte
	and $01
	add $03
	ld e, a
	ld d, b
	ld hl, EvasiveStalfosWalkSpeeds
;=@py
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.animate
;> wEntityState[slot] = 0
	ld hl, wEntityState
	add hl, bc
	xor a
	ld [hl], a
;> SetEntitySpriteVariant((hFrameCounter >> 3) & 1)        # walking frames
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> return
	ret


;@ def EvasiveStalfosDodgeJump(slot: c)
;@ path: enemy/stalfos_evasive
;@ Step 1: the leap (gravity 1 per frame; walls checked with the ignore-hits timer briefly set
;@ to 1, then left at 0). On landing it walks on at speed (8, 8) and throws a bone 15 frames
;@ later (EvasiveStalfosHandler, when wEntityTimer1 reaches 1).
;@ test: skip calls routines in other banks
EvasiveStalfosDodgeJump::
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> wEntityIgnoreHitsTimer[slot] = 1
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	push hl
	ld [hl], $01
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> wEntityIgnoreHitsTimer[slot] = 0
	pop hl
	ld [hl], b
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 1                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     wEntitySpeedY[slot] = 8
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $08
;>     wEntitySpeedX[slot] = 8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
;>     wEntityPrivateCounter[slot] = 0        # walk
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
;>     wEntityTimer1[slot] = 0x10             # the bone comes at 1
	call GetEntityTimer1
	ld [hl], $10

.done
	ret


;@ path: boss/final_nightmare
;@ Entity tile sets of each form of the final boss (index wFinalNightmareForm), 2 bytes per form:
;@ the sets loaded into entity tile slots 2 and 3. Forms 0-1 $EA/$EB, 2 $EC/$ED, 3 $EE/$EF,
;@ 4 $F0/$F1, 5 $F2/$F3.
FinalNightmareFormTilesets::
	db $ea, $eb, $ea, $eb, $ec, $ed, $ee, $ef, $f0, $f1, $f2, $f3

;@ def LoadFinalNightmareFormTiles()
;@ path: boss/final_nightmare
;@ Requests the entity tiles of the final boss's current form (FinalNightmareFormTilesets) for
;@ entity tile slots 2 and 3; the VBlank handler copies them over the next frames.
;@ test: wFinalNightmareForm = rand(0, 5)
LoadFinalNightmareFormTiles::
;>@st sets = FinalNightmareFormTilesets + wFinalNightmareForm * 2
	ld a, [wFinalNightmareForm]
	rla
	and $fe
	ld e, a
	ld d, b
	ld hl, FinalNightmareFormTilesets
;=@st
	add hl, de
;> wLoadedEntityTilesets[2] = mem[sets]
	ld a, [hli]
	ld [wLoadedEntityTilesets + 2], a
;> wLoadedEntityTilesets[3] = mem[sets + 1]
	ld a, [hl]
	ld [wLoadedEntityTilesets + 3], a
;> hNeedsUpdatingEnemiesTiles = 1
	ld a, $01
	ldh [hNeedsUpdatingEnemiesTiles], a
;> wNeedsUpdatingNPCTiles = 1
	ld [wNeedsUpdatingNPCTiles], a
	ret


;@ def FinalNightmareHandler(slot: c)
;@ path: boss/final_nightmare
;@ Handler of entity $E6, the final boss: a shadow that takes six forms one after the other
;@ (wFinalNightmareForm: 0 it rises out of Link's shadow, 1 a giant gel, 2 Agahnim's shadow,
;@ 3 a Moldorm, 4 Ganon's shadow, 5 Lanmola / the last form). On the room's first frame it
;@ requests the tiles of the current form. Entities of the same type with wEntityPrivate5 = 1
;@ are pieces of the burst gel, with 2 the light that ends the fight.
;@ test: skip jumps through a table
FinalNightmareHandler::
;> if not wRoomTransitionState and not wRoomEntitySetupDone:
	ld a, [wRoomTransitionState]
	and a
	jr nz, .forms
	ld a, [wRoomEntitySetupDone]
	and a
	jr nz, .forms
;>     wRoomEntitySetupDone = 1
	inc a
	ld [wRoomEntitySetupDone], a
;>     LoadFinalNightmareFormTiles()
	call LoadFinalNightmareFormTiles

.forms
;> kind = wEntityPrivate5[slot]
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
;> if kind == 2: return FinalNightmareExit(slot)   # the light after the fight
	cp $02
	jp z, FinalNightmareExit
;> if kind: return NightmareGelPiece(slot)    # a piece of the burst gel
	and a
	jp nz, NightmareGelPiece
;> FinalNightmareForms[wFinalNightmareForm]()
	ld a, [wFinalNightmareForm]
	rst $00

;@ path: boss/final_nightmare
;@ Handler of each form of the final boss (rst $00 table indexed by wFinalNightmareForm).
FinalNightmareForms::
	dw NightmareIntro
	dw NightmareGel
	dw NightmareAgahnim
	dw NightmareMoldorm
	dw NightmareGanon
	dw Jump_15_6E4A

;@ def NightmareIntro(slot: c)
;@ path: boss/final_nightmare
;@ Form 0: the shadow rising out of Link's shadow at the start of the fight (states in
;@ NightmareIntroStates).
;@ test: skip jumps through a table
NightmareIntro::
;> NightmareIntroStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare
;@ States of the opening form (rst $00 table indexed by the entity's state).
NightmareIntroStates::
	dw NightmareIntroStart
	dw NightmareIntroWait
	dw NightmareIntroRise
	dw NightmareIntroSlow
	dw NightmareIntroGrow
	dw NightmareIntroPulse
	dw NightmareIntroShrink

;@ def NightmareIntroStart(slot: c)
;@ path: boss/final_nightmare
;@ State 0: once Link stands on the ground, the boss music starts, text $F5 is shown and the
;@ shadow takes Link's place; its trail of past positions (wEntityWorkRAM x, wEntityWorkRAM2 y,
;@ 128 each) is filled with that place and the boss variables are cleared.
;@ test: skip calls routines in other banks
NightmareIntroStart::
;> if wIsLinkInTheAir: return
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .done
;> wMusicTrackToPlay = 0x5D
	ld a, $5d
	ld [wMusicTrackToPlay], a
;> wRoomStatus[0x274] |= 0x40
	ld hl, wRoomStatus + $274
	set 6, [hl]
;> OpenDialog(0xF5)
	ld a, $f5
	call OpenDialog
;> wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;> wEntityX[slot] = hLinkX                    # out of Link's shadow
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> fill(wEntityWorkRAM, hLinkX, 0x80)         # the trail's x positions
	ld e, $80
	ld hl, wEntityWorkRAM

.fillX
	ld [hli], a
	dec e
	jr nz, .fillX
;> wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> fill(wEntityWorkRAM2, hLinkY, 0x80)        # and y positions
	ld e, $80
	ld hl, wEntityWorkRAM2

.fillY
	ld [hli], a
	dec e
	jr nz, .fillY
;> for addr in range(0xD21A, 0xD224):         # the boss variables
;>@clr     mem[addr] = 0
	xor a
	ld [wFinalNightmareHidden], a
;=@clr
	ld [wFinalNightmareTargetX], a
;=@clr
	ld [wFinalNightmareTargetY], a
;=@clr
	ld [wNightmareChargeFrame], a
;=@clr
	ld [wNightmareFacing], a
;=@clr
	ld [$d21f], a
;=@clr
	ld [wFinalNightmareHits], a
;=@clr
	ld [$d221], a
;=@clr
	ld [$d222], a
;=@clr
	ld [$d223], a
;> IncrementEntityState()
	call IncrementEntityState

.done
	ret


;@ def NightmareIntroWait(slot: c)
;@ path: boss/final_nightmare
;@ State 1: the shadow trail is drawn while the text runs; $30 frames before the end the fight
;@ music ($23) starts, at the end a jingle.
;@ test: skip calls routines in other banks
NightmareIntroWait::
;> DrawNightmareShadowTrail(slot)
	call DrawNightmareShadowTrail
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t: return NightmareIntroCueMusic(t)
	jr nz, NightmareIntroCueMusic
;> IncrementEntityState()
	call IncrementEntityState
;> PlayNightmareJingle()                      # falls through

;@ def PlayNightmareJingle()
;@ path: boss/final_nightmare
;@ Jingle $35, heard whenever the final boss changes shape.
;@ test: hJingle = 0
PlayNightmareJingle::
;> hJingle = 0x35
	ld a, $35
	ldh [hJingle], a
	ret


;@ def NightmareIntroCueMusic(t: a, timer: hl)
;@ path: boss/final_nightmare
;@ The rest of state 1 while it waits: when the timer `t` reaches $30, the fight music ($23)
;@ starts (the timer is stepped once more so it starts only once).
;@ test: skip works on the timer byte at hl
NightmareIntroCueMusic::
;> if t != 0x30: return
	cp $30
	jr nz, .done
;> mem[timer] -= 1
	dec [hl]
;> wMusicTrackToPlay = 0x23
	ld a, $23
	ld [wMusicTrackToPlay], a

.done
	ret


;@ def NightmareIntroRise(slot: c)
;@ path: boss/final_nightmare
;@ State 2: the shadow shoots upwards, faster every frame, until its speed reaches -24.
;@ test: skip calls routines in other banks
NightmareIntroRise::
;> DrawNightmareShadowTrail(slot)
	call DrawNightmareShadowTrail
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> wEntitySpeedY[slot] -= 1
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
;> if wEntitySpeedY[slot] == 0xE8:
	ld a, [hl]
	cp $e8
	jr nz, .move
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     IncrementEntityState()
	call IncrementEntityState

.move
;> AddEntitySpeedToPosY_15(slot)
	call AddEntitySpeedToPosY_15
	ret


;@ def NightmareIntroSlow(slot: c)
;@ path: boss/final_nightmare
;@ State 3: after 8 more frames it brakes by 1 per frame until it stops, then waits $80 frames.
;@ test: skip calls routines in other banks
NightmareIntroSlow::
;> DrawNightmareShadowTrail(slot)
	call DrawNightmareShadowTrail
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> AddEntitySpeedToPosY_15(slot)
	call AddEntitySpeedToPosY_15
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> wEntitySpeedY[slot] += 1
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> if wEntitySpeedY[slot] == 0:               # stopped
	jr nz, .done
;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     IncrementEntityState()
	call IncrementEntityState

.done
	ret


;@ def NightmareIntroGrow(slot: c)
;@ path: boss/final_nightmare
;@ State 4: the shadow grows one size every 8 frames up to body frame 5, then pulses for $C0
;@ frames.
;@ test: skip calls routines in other banks
NightmareIntroGrow::
;> DrawNightmareShadowTrail(slot)
	call DrawNightmareShadowTrail
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0 or t & 7: return
	jr z, .done
	and $07
	jr nz, .done
;> if wEntitySpriteVariant[slot] != 5:
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	cp $05
	jr z, .grown
;>     wEntitySpriteVariant[slot] += 1
	inc [hl]

.done
;>     return
	ret


.grown
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> IncrementEntityState()
	call IncrementEntityState
	ret


;@ path: boss/final_nightmare
;@ Body frames of the opening shadow while it pulses (one every 16 frames, 4 steps): 6, 5, 7,
;@ 5 (frames of NightmareShadowBodySprites).
NightmareShadowPulseFrames::
	db $06, $05, $07, $05

;@ def NightmareIntroPulse(slot: c)
;@ path: boss/final_nightmare
;@ State 5: the big shadow pulses (NightmareShadowPulseFrames), then shrinks for $2F frames.
;@ test: skip calls routines in other banks
NightmareIntroPulse::
;> DrawNightmareShadowBody(slot)
	call DrawNightmareShadowBody
;>@pf SetEntitySpriteVariant(mem[NightmareShadowPulseFrames + ((hFrameCounter >> 4) & 3)])
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $03
;=@pf
	ld e, a
	ld d, b
	ld hl, NightmareShadowPulseFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x2F
	ld [hl], $2f
;>     IncrementEntityState()
	call IncrementEntityState

.done
	ret


;@ path: boss/final_nightmare
;@ Body frames of the opening shadow while it shrinks, indexed by timer / 8 ($2F down to 0):
;@ 8, 0, 1, 2, 3, 4 - read backwards: from the big flat shape down to a dot.
NightmareShadowShrinkFrames::
	db $08, $00, $01, $02, $03, $04

;@ def NightmareIntroShrink(slot: c)
;@ path: boss/final_nightmare
;@ State 6: the shadow shrinks to a dot; then the next form, the giant gel, begins (state 0) and
;@ it becomes harmful to touch.
;@ test: skip calls routines in other banks
NightmareIntroShrink::
;> DrawNightmareShadowBody(slot)
	call DrawNightmareShadowBody
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shrink
;>     wFinalNightmareForm += 1               # the giant gel
	ld hl, wFinalNightmareForm
	inc [hl]
;>     SetEntitySpriteVariant(0)
	xor a
	call SetEntitySpriteVariant
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityPhysicsFlags[slot] &= ~0x80     # harmful to touch now
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
;>     return
	ret


.shrink
;>@sf SetEntitySpriteVariant(mem[NightmareShadowShrinkFrames + ((t >> 3) & 0x0F)])
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@sf
	ld hl, NightmareShadowShrinkFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ def NightmareGel(slot: c)
;@ path: boss/final_nightmare
;@ Form 1, the giant gel: it hops at Link. A sword hit makes it burst into 8 pieces and come
;@ back elsewhere; Magic Powder hurts it - after 3 powder hits it bursts for good and the next
;@ form follows. Now and then it sinks into the floor and reappears at another spot.
;@ test: skip jumps through a table
NightmareGel::
;> DrawNightmareGel()
	call DrawNightmareGel
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> NightmareGelStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare
;@ States of the giant gel (rst $00 table indexed by its state): 0 start, 1 crouch, 2 jump,
;@ 3 landed, 4 gone (after a burst), 5 transform into the next form, 6 burst (entered from the
;@ sword collision code), 7 hit by powder, 8 sink into the floor, 9 hidden.
NightmareGelStates::
	dw NightmareGelInit
	dw NightmareGelCrouch
	dw NightmareGelJump
	dw NightmareGelLanded
	dw NightmareGelWaitReappear
	dw NightmareGelTransform
	dw NightmareGelSplit
	dw NightmareGelPowdered
	dw NightmareGelSink
	dw NightmareGelHidden

;@ def NightmareGelInit(slot: c)
;@ path: boss/final_nightmare
;@ State 0: waits $80 frames, the hop counter cleared.
;@ test: skip calls routines in other banks
NightmareGelInit::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityPrivateCounter[slot] = 0            # hops
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
;> IncrementEntityState()
	jp IncrementEntityState


;@ def NightmareGelCrouch(slot: c)
;@ path: boss/final_nightmare
;@ State 1: after the wait the gel rises through its frames 0-3 (one every 8 frames), then jumps
;@ at Link (upward speed $28, speed 8 towards him).
;@ test: skip calls routines in other banks
NightmareGelCrouch::
;> if wEntityTimer[slot] or hFrameCounter & 7: return
	call GetEntityTimer
	jr nz, .done
	ldh a, [hFrameCounter]
	and $07
	jr nz, .done
;> wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]
;> if wEntitySpriteVariant[slot] == 3:
	ld a, [hl]
	cp $03
	jr nz, .done
;>     wEntitySpeedZ[slot] = 0x28
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $28
;>     SetEntitySpeedTowardsLink(0x08)
	ld a, $08
	call SetEntitySpeedTowardsLink
;>     IncrementEntityState()
	call IncrementEntityState

.done
	ret


;@ def NightmareGelJump(slot: c)
;@ path: boss/final_nightmare
;@ State 2: in the air (gravity 2, frame 3 low or 4 high). On every landing the hop counter
;@ goes up; after an even hop, at random, it sinks into the floor (state 8, $1F frames),
;@ otherwise it lands with a thud and squats for $30 frames (state 3).
;@ test: skip calls routines in other banks
NightmareGelJump::
;> CheckNightmareGelPowdered(slot)            # (ends this handler when powder hit it)
	call CheckNightmareGelPowdered
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()
	call EntityCheckWalls
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .pose
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>@sk     if wEntityPrivateCounter[slot] & 1 == 0 and GetRandomByte() & 1 == 0:
	and $01
	jr nz, .thud
	call GetRandomByte
	and $01
	jr nz, .thud
;>         wEntityTimer[slot] = 0x1F
	call GetEntityTimer
	ld [hl], $1f
;>         wEntityState[slot] = 8             # sink into the floor
	call IncrementEntityState
	ld [hl], $08
	jr .pose

.thud
;>     else:
;>         hJingle = 0x20
	ld a, $20
	ldh [hJingle], a
;>         wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         IncrementEntityState()             # landed
	call IncrementEntityState

.pose
;> frame = 3
	ld e, $03
;> if wEntityZ[slot] >= 0x0C: frame = 4       # high up: the round frame
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $0c
	jr c, .setPose
	inc e

.setPose
;> SetEntitySpriteVariant(frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def NightmareGelLanded(slot: c)
;@ path: boss/final_nightmare
;@ State 3: squats (frame 5) for a while, then jumps at Link again (speed $0C, upward $20,
;@ state 2).
;@ test: skip calls routines in other banks
NightmareGelLanded::
;> SetEntitySpriteVariant(5)                  # squashed
	ld a, $05
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .checks
;>     SetEntitySpeedTowardsLink(0x0C)
	ld a, $0c
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     wEntityState[slot] -= 1                # jump again (state 2)
	call IncrementEntityState
	dec [hl]
	dec [hl]

.checks
;> CheckNightmareGelPowdered(slot)
	call CheckNightmareGelPowdered
;> EntityCheckHits()
	call EntityCheckHits
	ret


;@ def NightmareGelWaitReappear(slot: c)
;@ path: boss/final_nightmare
;@ State 4: after a sword burst the gel is gone for $80 frames, then reappears at a random spot.
;@ test: skip calls routines in other banks
NightmareGelWaitReappear::
;> if wEntityTimer[slot] == 0: return NightmareGelReappear(slot)
	call GetEntityTimer
	jr nz, .done
	jp NightmareGelReappear


.done
	ret


;@ def PlayNightmareFormSfx()
;@ path: boss/final_nightmare
;@ Wave channel sound $23, played when a new form of the final boss shows itself the first time.
;@ test: hWaveSfx = 0
PlayNightmareFormSfx::
;> hWaveSfx = 0x23
	ld a, $23
	ldh [hWaveSfx], a
	ret


;@ def NightmareGelTransform(slot: c)
;@ path: boss/final_nightmare
;@ State 5: after the final burst the gel shrinks away (NightmareGelTransformAnim), then the next
;@ form begins.
;@ test: skip calls routines in other banks
NightmareGelTransform::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t: return NightmareGelTransformAnim(t)
	jr nz, NightmareGelTransformAnim
;> NightmareNextForm(slot)                    # falls through

;@ def NightmareNextForm(slot: c)
;@ path: boss/final_nightmare
;@ Switches the final boss to its next form: requests the form's tiles (into entity tile slots
;@ 2 and 3), clears the boss variables, puts it back on the ground, harmless and unseen (sprite
;@ variant $FF, wFinalNightmareHidden = 1) for $40 frames, in state 0.
;@ test: skip calls routines in other banks
NightmareNextForm::
;> wFinalNightmareForm += 1
	ld a, [wFinalNightmareForm]
	inc a
	ld [wFinalNightmareForm], a
;> LoadFinalNightmareFormTiles()
	call LoadFinalNightmareFormTiles
;> mem[0xD221] = 0
	xor a
	ld [$d221], a
;> mem[0xD222] = 0
	ld [$d222], a
;> mem[0xD223] = 0
	ld [$d223], a
;> wFinalNightmareHits = 0
	ld [wFinalNightmareHits], a
;> wEntityZ[slot] = 0
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b
;> wEntityPhysicsFlags[slot] = 0xC0           # harmless while it changes
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c0
;> wEntityTilesSlotA = 2
	ld a, $02
	ld [wEntityTilesSlotA], a
;> wEntityTilesSlotB = 3
	inc a
	ld [wEntityTilesSlotB], a
;> SetEntitySpriteVariant(0xFF)               # not drawn
	ld a, $ff
	call SetEntitySpriteVariant
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wFinalNightmareHidden = 1
	ld a, $01
	ld [wFinalNightmareHidden], a
	ret


;@ def NightmareGelTransformAnim(t: a)
;@ path: boss/final_nightmare
;@ The rest of state 5 while it lasts: in the last $18 frames the gel shrinks (frames 2, 1, 0),
;@ with the shape-change jingle at $17.
;@ test: skip calls routines in other banks
NightmareGelTransformAnim::
;> if t >= 0x18: return
	cp $18
	jr nc, .done
;> if t == 0x17: hJingle = 0x35
	cp $17
	jr nz, .frame
	ld hl, hJingle
	ld [hl], $35

.frame
;> SetEntitySpriteVariant((t >> 3) & 3)
	rra
	rra
	rra
	and $03
	call SetEntitySpriteVariant

.done
	ret


;@ path: boss/final_nightmare
;@ Gel frames while it sinks into the floor, indexed by timer / 8 ($1F down to 0): $FF (gone),
;@ 0, 1, 2 - read backwards: it shrinks away.
NightmareGelSinkFrames::
	db $ff, $00, $01, $02

;@ def NightmareGelSink(slot: c)
;@ path: boss/final_nightmare
;@ State 8: the gel sinks into the floor (NightmareGelSinkFrames), then stays hidden $80 frames.
;@ test: skip calls routines in other banks
NightmareGelSink::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .sink
;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     return IncrementEntityState()          # hidden
	jp IncrementEntityState


.sink
;>@sk SetEntitySpriteVariant(mem[NightmareGelSinkFrames + ((t >> 3) & 3)])
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
;=@sk
	ld hl, NightmareGelSinkFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ def NightmareGelHidden(slot: c)
;@ path: boss/final_nightmare
;@ State 9: hidden under the floor until the timer runs out, then NightmareGelReappear.
;@ test: skip calls routines in other banks
NightmareGelHidden::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, NightmareGelReappear.done
;> NightmareGelReappear(slot)                 # falls through

;@ def NightmareGelReappear(slot: c)
;@ path: boss/final_nightmare
;@ The gel comes back at one of 8 spots of the room (NightmareTeleportX / Y, picked at random)
;@ and crouches for the next jump (state 1).
;@ test: skip calls routines in other banks
NightmareGelReappear::
;> spot = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntityX[slot] = mem[NightmareTeleportX + spot]
	ld hl, NightmareTeleportX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = mem[NightmareTeleportY + spot]
	ld hl, NightmareTeleportY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01

.done
	ret


;@ path: boss/final_nightmare
;@ X offsets of the 8 gel pieces from the burst gel (all 0).
NightmareGelPieceOffsetX::
	db $00, $00, $00, $00, $00, $00, $00, $00

;@ path: boss/final_nightmare
;@ Y offsets of the 8 gel pieces (all 0).
NightmareGelPieceOffsetY::
	db $00, $00, $00, $00, $00, $00, $00, $00
;@ path: boss/final_nightmare
;@ Y speeds of the 8 gel pieces, flying out in 8 directions: 0, $18, $20, $18, 0, -$18, -$20,
;@ -$18 (the table runs on into NightmareGelPieceSpeedX).
NightmareGelPieceSpeedY::
	db $00, $18

;@ path: boss/final_nightmare
;@ X speeds of the 8 gel pieces: $20, $18, 0, -$18, -$20, -$18, 0, $18.
NightmareGelPieceSpeedX::
	db $20, $18, $00, $e8, $e0, $e8, $00, $18

;@ def NightmareGelSplit(slot: c)
;@ path: boss/final_nightmare
;@ State 6, entered when Link's sword strikes the gel: it vanishes, bursting into 8 pieces with
;@ a splash sound, and is gone for $80 frames (state 4).
;@ test: skip calls routines in other banks
NightmareGelSplit::
;> SetEntitySpriteVariant(0xFF)               # gone
	ld a, $ff
	call SetEntitySpriteVariant
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;> hWaveSfx = 0x21
	ld a, $21
	ldh [hWaveSfx], a
;> SpawnNightmareGelPieces()                  # falls through

;@ def SpawnNightmareGelPieces()
;@ path: boss/final_nightmare
;@ Spawns the 8 pieces of a burst gel (entity $E6 with wEntityPrivate5 = 1, see
;@ NightmareGelPiece) flying out in 8 directions from the boss's place and height, for $2F
;@ frames, harmless (physics $C2).
;@ test: skip calls routines in other banks
SpawnNightmareGelPieces::
;>@pc for i in range(8):
	xor a

.next
;>     hBGTilesRequestCopy = i                # (scratch here)
	ldh [hBGTilesRequestCopy], a
;>     piece = SpawnEntity(0xE6)
	ld a, $e6
	call SpawnEntity
;>     if piece is None: return
	ret c
;>@px     wEntityX[piece] = u8(hMultiPurpose0 + mem[NightmareGelPieceOffsetX + i])
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ldh a, [hMultiPurpose0]
	ld hl, NightmareGelPieceOffsetX
	add hl, bc
;=@px
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@py     wEntityY[piece] = u8(hMultiPurpose1 + mem[NightmareGelPieceOffsetY + i])
	ldh a, [hMultiPurpose1]
	ld hl, NightmareGelPieceOffsetY
	add hl, bc
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@py
	ld [hl], a
;>     wEntityZ[piece] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[piece] = mem[NightmareGelPieceSpeedX + i]
	ld hl, NightmareGelPieceSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[piece] = mem[NightmareGelPieceSpeedY + i]
	ld hl, NightmareGelPieceSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntityTimer[piece] = 0x2F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $2f
;>     wEntityPhysicsFlags[piece] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;>     wEntityPrivate5[piece] += 1            # a gel piece
	ld hl, wEntityPrivate5
	add hl, de
	inc [hl]
	pop bc
;=@pc
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $08
	jr nz, .next
	ret


;@ path: boss/final_nightmare
;@ Gel frames while it quivers after a powder hit, one every 2 frames: 5, 3, 4, 3.
NightmareGelWobbleFrames::
	db $05, $03, $04, $03

;@ def NightmareGelPowdered(slot: c)
;@ path: boss/final_nightmare
;@ State 7: hit by Magic Powder, the gel quivers ($80 frames) and drops to the ground. Then the
;@ powder hit is counted: under 3 it jumps on (state 2); at the third it bursts into pieces for
;@ good (frame 6, noise $37) and changes into the next form (state 5, $80 frames).
;@ test: skip calls routines in other banks
NightmareGelPowdered::
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # on the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .quiver
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.quiver
;> t = wEntityTimer[slot]
	call GetEntityTimer
;>@wq if t: return SetEntitySpriteVariant(mem[NightmareGelWobbleFrames + ((t >> 1) & 3)])
	jr z, .counted
	rra
	nop
	nop
	nop
	and $03
;=@wq
	ld e, a
	ld d, b
	ld hl, NightmareGelWobbleFrames
	add hl, de
	ld a, [hl]
	jp SetEntitySpriteVariant


.counted
;> wFinalNightmareHits += 1
	ld a, [wFinalNightmareHits]
	inc a
	ld [wFinalNightmareHits], a
;> if wFinalNightmareHits < 3:
	cp $03
	jr nc, .beaten
;>     wEntityState[slot] = 2                 # jump on
	call IncrementEntityState
	ld [hl], $02
;>     return
	ret


.beaten
;> SetEntitySpriteVariant(6)
	ld a, $06
	call SetEntitySpriteVariant
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityState[slot] = 5                     # transform
	call IncrementEntityState
	ld [hl], $05
;> NightmareBurstIntoPieces()                 # falls through

;@ def NightmareBurstIntoPieces()
;@ path: boss/final_nightmare
;@ Noise $37 and the 8 flying gel pieces (SpawnNightmareGelPieces).
;@ test: skip calls routines in other banks
NightmareBurstIntoPieces::
;> hNoiseSfx = 0x37
	ld a, $37
	ldh [hNoiseSfx], a
;> return SpawnNightmareGelPieces()
	jp SpawnNightmareGelPieces


;@ def CheckNightmareGelPowdered(slot: c)
;@ path: boss/final_nightmare
;@ Looks for a Magic Powder cloud (entity 8, active, at timer value 8) within 12 pixels of the
;@ gel. If one touches it, the gel flashes, two sounds play, it goes to state 7 for $80 frames
;@ and the calling handler ends for this frame.
;@ test: skip returns from its caller
CheckNightmareGelPowdered::
;> for other in range(15, -1, -1):
	ld e, $0f
	ld d, b

.next
;>@nx     if wEntityStatus[other] != 5: continue
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, .skip
;>@nx     if wEntityType[other] != 8: continue       # magic powder
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, .skip
;>@nx     if wEntityTimer[other] != 8: continue
	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, .skip
;>@nx     if u8(hActiveEntityX - wEntityX[other] + 12) >= 0x18: continue
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $0c
	cp $18
;=@nx
	jr nc, .skip
;>@nx     if u8(hActiveEntityDrawY - wEntityY[other] + 12) >= 0x18: continue
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
	cp $18
;=@nx
	jr nc, .skip
;>     wEntityFlashTimer[slot] = 0x14
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $14
;>     hWaveSfx = 0x07
	ld a, $07
	ldh [hWaveSfx], a
;>     hJingle = 0x37
	ld a, $37
	ldh [hJingle], a
;>     wEntityState[slot] = 7                 # powdered
	call IncrementEntityState
	ld [hl], $07
;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     return_from_caller()
	pop af
	ret


.skip
;=@nx
	dec e
	ld a, e
	cp $ff
	jr nz, .next
	ret


;@ path: boss/final_nightmare
;@ Gel piece sprites for RenderActiveEntitySpritesPair: 3 variants (shrinking: 0 $4E, 1 $4C,
;@ 2 $4A, each with its mirror image), 4 bytes each (tile, attributes per 8x16 half).
NightmareGelPieceSprites::
	db $4e, $00, $4e, $20, $4c, $00, $4c, $20, $4a, $00, $4a, $20

;@ path: boss/final_nightmare
;@ Frame of a flying gel piece by its timer / 8 (6 entries, the timer starts at $2F):
;@ 2, 2, 2, 1, 1, 0 - big at first, smaller towards the end.
NightmareGelPieceFrames::
	db $02, $02, $02, $01
	db $01, $00

;@ path: boss/final_nightmare
;@ Movement mask of a gel piece by its timer / 8: the piece moves only on frames where
;@ (frame counter & mask) is 0 - every frame at first, more and more rarely later
;@ ($0F, $07, $03, $01, 0, 0, read backwards).
NightmareGelPieceMoveMasks::
	db $0f, $07, $03, $01, $00, $00

;@ def NightmareGelPiece(slot: c)
;@ path: boss/final_nightmare
;@ A piece of the burst gel (entity $E6 with wEntityPrivate5 = 1): flies out, slowing down and
;@ shrinking, and vanishes after $2F frames.
;@ test: skip calls routines in other banks
NightmareGelPiece::
;> DrawEntity16x16(NightmareGelPieceSprites)       # draw it
	ld de, NightmareGelPieceSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0: return ClearEntityStatus_15(slot)
	jp z, ClearEntityStatus_15
;> step = (t >> 3) & 7
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;> SetEntitySpriteVariant(mem[NightmareGelPieceFrames + step])
	ld hl, NightmareGelPieceFrames
	add hl, de
	push de
	ld a, [hl]
	call SetEntitySpriteVariant
	pop de
;> if hFrameCounter & mem[NightmareGelPieceMoveMasks + step] == 0:
	ld hl, NightmareGelPieceMoveMasks
	add hl, de
	ldh a, [hFrameCounter]
	and [hl]
	jr nz, .done
;>     UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15

.done
	ret


;@ path: boss/final_nightmare
;@ The shapeless shadow (opening form) for RenderActiveEntitySpritesRect: 9 frames, each 8 OAM
;@ entries of 4 bytes (y offset, x offset, tile, attributes; unused entries use tile $FF).
;@ 0 dot ($4C), 1 small ($4E), 2-4 flat shapes growing from 32x16 ($7A/$7C, $76/$78, $72/$74,
;@ mirrored in four quarters), 5-7 the big pulsing shapes ($66-$6A, $60-$64, $6C-$70),
;@ 8 the smallest dot ($4A).
NightmareShadowBodySprites::
	db $00, $00, $4c, $00, $00, $08, $4c, $20, $00, $08, $ff, $20, $00, $10, $ff, $20
	db $00, $f8, $ff, $40, $00, $00, $ff, $40, $00, $08, $ff, $60, $00, $10, $ff, $60
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $00, $08, $ff, $20, $00, $10, $ff, $20
	db $00, $f8, $ff, $40, $00, $00, $ff, $40, $00, $08, $ff, $60, $00, $10, $ff, $60
	db $f8, $f8, $7a, $00, $f8, $00, $7c, $00, $f8, $08, $7c, $20, $f8, $10, $7a, $20
	db $08, $f8, $7a, $40, $08, $00, $7c, $40, $08, $08, $7c, $60, $08, $10, $7a, $60
	db $f8, $f8, $76, $00, $f8, $00, $78, $00, $f8, $08, $78, $20, $f8, $10, $76, $20
	db $08, $f8, $76, $40, $08, $00, $78, $40, $08, $08, $78, $60, $08, $10, $76, $60
	db $f8, $f8, $72, $00, $f8, $00, $74, $00, $f8, $08, $74, $20, $f8, $10, $72, $20
	db $08, $f8, $72, $40, $08, $00, $74, $40, $08, $08, $74, $60, $08, $10, $72, $60
	db $f8, $f8, $66, $00, $f8, $00, $68, $00, $f8, $08, $68, $20, $f8, $10, $66, $20
	db $08, $f8, $66, $40, $08, $00, $6a, $00, $08, $08, $6a, $20, $08, $10, $66, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $64, $00, $08, $08, $64, $20, $08, $10, $60, $60
	db $f8, $f8, $6c, $00, $f8, $00, $6e, $00, $f8, $08, $6e, $20, $f8, $10, $6c, $20
	db $08, $f8, $6c, $40, $08, $00, $70, $00, $08, $08, $70, $20, $08, $10, $6c, $60
	db $00, $00, $4a, $00, $00, $08, $4a, $20, $00, $08, $ff, $20, $00, $10, $ff, $20
	db $00, $f8, $ff, $40, $00, $00, $ff, $40, $00, $08, $ff, $60, $00, $10, $ff, $60
;@ path: boss/final_nightmare
;@ A copy in the opening shadow's trail, for RenderActiveEntitySpritesPair: tile $4C and its
;@ mirror image (2 bytes per half: tile, attributes).
NightmareTrailSprites::
	db $4c, $00, $4c, $20

;@ path: boss/final_nightmare
;@ The first copy of the trail: tile $48 and its mirror image.
NightmareTrailLeadSprites::
	db $48, $00, $48, $20

;@ path: boss/final_nightmare
;@ How many frames back each of the 8 trail copies lags behind the shadow: $28, $23, $1E,
;@ $19, $14, $0F, $0A, $05.
NightmareTrailDelays::
	db $28, $23, $1e, $19, $14, $0f, $0a, $05

;@ def DrawNightmareShadowTrail(slot: c)
;@ path: boss/final_nightmare
;@ Draws the opening shadow with its trail: 8 small copies at the places it was
;@ NightmareTrailDelays frames ago (from the 128-frame position history in wEntityWorkRAM /
;@ wEntityWorkRAM2; copies other than the first are left out while at the shadow's own
;@ height), then the shadow itself, and records the current position in the history.
;@ test: skip calls routines in other banks
DrawNightmareShadowTrail::
;> now = wEntityPrivateCounter[slot]          # position in the history
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
;>@cp for i in range(8):
	xor a

.copy
;>     hBGTilesRequestCopy = i                # (scratch here)
	ldh [hBGTilesRequestCopy], a
;>@pa     past = (now - mem[NightmareTrailDelays + i]) & 0x7F
	ld e, a
	ld d, b
	ld hl, NightmareTrailDelays
	add hl, de
	ldh a, [hMultiPurposeH]
	sub [hl]
;=@pa
	and $7f
	ld e, a
	ld d, b
;>     hActiveEntityX = wEntityWorkRAM[past]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY = wEntityWorkRAM2[past]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;>     sprites = NightmareTrailLeadSprites
	ld de, NightmareTrailLeadSprites
;>     if i != 0:
	ldh a, [hBGTilesRequestCopy]
	cp $00
	jr z, .draw
;>         if hActiveEntityDrawY == wEntityY[slot]: continue   # not risen yet
	ld hl, wEntityY
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr z, .nextCopy
;>         sprites = NightmareTrailSprites
	ld de, NightmareTrailSprites

.draw
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(sprites)
	call DrawEntity16x16
;>     ReserveOAMEntriesFar(2)                           # reserve its 2 OAM entries
	ld a, $02
	call ReserveOAMEntriesFar

.nextCopy
;=@cp
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $08
	jr nz, .copy
;> LoadEntityPosition()                                # back to the real position
	call LoadEntityPosition
;> DrawNightmareShadowBody(slot)
	call DrawNightmareShadowBody
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;>@hi i = wEntityPrivateCounter[slot] & 0x7F
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> wEntityPrivateCounter[slot] += 1
	inc [hl]
;=@hi
	and $7f
	ld e, a
	ld d, b
;> wEntityWorkRAM2[i] = hActiveEntityDrawY     # record where it is
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld [hl], a
;> wEntityWorkRAM[i] = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld hl, wEntityWorkRAM
	add hl, de
	ld [hl], a
	ret


;@ def DrawNightmareShadowBody(slot: c)
;@ path: boss/final_nightmare
;@ Draws the opening shadow's body: frame wEntitySpriteVariant of NightmareShadowBodySprites
;@ (8 OAM entries) and reserves them.
;@ test: skip calls routines in other banks
DrawNightmareShadowBody::
;>@bd DrawEntitySprites(NightmareShadowBodySprites + wEntitySpriteVariant[slot] * 32, 8)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@bd
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, NightmareShadowBodySprites
;=@bd
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
	ret


;@ path: boss/final_nightmare
;@ The giant gel (form 1) for RenderActiveEntitySpritesRect: 7 frames, each 4 OAM entries of
;@ 4 bytes (y offset, x offset, tile, attributes; tile $FF = unused entry). 0-2 growing from a
;@ dot ($4A, $4C, $4E), 3 standing tall ($5C over $5E), 4 round in the air ($44 in four
;@ mirrored quarters), 5 squashed flat ($40/$42/$40), 6 small ($48).
NightmareGelSprites::
	db $00, $00, $4a, $00, $00, $08, $4a, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $4c, $00, $00, $08, $4c, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $00, $00, $ff, $00, $00, $00, $ff, $20
	db $f0, $00, $5c, $00, $f0, $08, $5c, $20, $00, $00, $5e, $00, $00, $08, $5e, $20
	db $f0, $00, $44, $00, $f0, $08, $44, $20, $00, $00, $44, $40, $00, $08, $44, $60
	db $00, $fc, $40, $00, $00, $04, $42, $00, $00, $0c, $40, $20, $00, $00, $ff, $00
	db $00, $00, $48, $00, $00, $08, $48, $20, $00, $00, $ff, $00, $00, $00, $ff, $20

;@ def DrawNightmareGel()
;@ path: boss/final_nightmare
;@ Draws the gel in the frame hActiveEntitySpriteVariant (NightmareGelSprites, 4 OAM entries)
;@ and reserves them.
;@ test: skip calls routines in other banks
DrawNightmareGel::
;>@gd DrawEntitySprites(NightmareGelSprites + hActiveEntitySpriteVariant * 16, 4)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;=@gd
	ld e, a
	ld d, b
	ld hl, NightmareGelSprites
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
	ret


;@ def NightmareAgahnim(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Form 2 of the final boss: Agahnim's shadow. It appears at a spot, turns towards Link, charges
;@ an energy ball in its hand and throws it, then vanishes and glides as a dark blob to another
;@ spot. Only its own balls, struck back by Link's sword, can hurt it: four hits and it is
;@ beaten. Entities of the same kind with wEntityPrivate4 = 1 are its balls (AgahnimBall), with
;@ 2 an unused kind that draws nothing.
;@ test: skip jumps through a table
NightmareAgahnim::
;> kind = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
;> if kind == 2: return AgahnimUnusedKind(slot)
	cp $02
	jp z, AgahnimUnusedKind
;> if kind: return AgahnimBall(slot)          # an energy ball
	and a
	jp nz, AgahnimBall
;> wSmasherBallSlot = slot                    # (scratch here: the balls find the boss by it)
	ld a, c
	ld [wSmasherBallSlot], a
;> if not wFinalNightmareHidden: DrawNightmareAgahnim(slot)
	ld a, [wFinalNightmareHidden]
	and a
	jr nz, .update
	call DrawNightmareAgahnim

.update
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> NightmareAgahnimStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare/agahnim
;@ States of Agahnim's shadow (rst $00 table indexed by wEntityState): 0 glide to the top of the
;@ room, 1 appear, 2 watch Link, 3 charge and throw a ball, 4 vanish, 5 pick a new spot, 6 glide
;@ there (then back to 1), 7 beaten (spins), 8 shrink, 9 glide to the top and turn into the
;@ next form.
NightmareAgahnimStates::
	dw NightmareAgahnimCenter
	dw NightmareAgahnimAppear
	dw NightmareAgahnimWatch
	dw NightmareAgahnimCharge
	dw NightmareAgahnimVanish
	dw NightmareAgahnimPickSpot
	dw NightmareAgahnimGlide
	dw NightmareAgahnimDefeated
	dw NightmareAgahnimShrink
	dw NightmareAgahnimLeave

;@ def NightmareAgahnimCenter(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 0: as a dark blob, glides at speed $10 to the spot (X $50, Y $30) at the top of the
;@ room; when it is within 3 pixels it starts to appear there (state 1, timer $50).
;@ test: skip calls routines in other banks
NightmareAgahnimCenter::
;> SetEntitySpriteVariant(0)
	xor a
	call SetEntitySpriteVariant
;> DrawNightmareGel(slot)                     # the blob
	call DrawNightmareGel
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkX = 0x50                             # aim at the spot instead of Link
	ld a, $50
	ldh [hLinkX], a
;> hLinkY = 0x30
	ld a, $30
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>@g1 if abs(hActiveEntityDrawY - 0x30) <= 2 and abs(hActiveEntityX - 0x50) <= 2:
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;=@g1
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;>     wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;>     wEntityState[slot] = 1                 # appear
	call IncrementEntityState
	ld [hl], $01

.move
;> hLinkY = link_y
	pop af
	ldh [hLinkY], a
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
	ret


;@ path: boss/final_nightmare/agahnim
;@ Frame of the blob while Agahnim's shadow appears, by its timer / 8 (15 entries, the timer
;@ starts at $50 so only entries 0-9 are used): 4, 3, 2, 1, then 0 - the blob gathers.
AgahnimAppearFrames::
	db $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ def NightmareAgahnimAppear(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 1: the blob gathers (AgahnimAppearFrames); when the timer runs out Agahnim's shadow
;@ shows itself facing Link, 8 pixels higher, and watches him (state 2, timer $40). The first
;@ time it appears it plays the sound of a new form.
;@ test: skip calls routines in other banks
NightmareAgahnimAppear::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr z, .appear
;>@g2     hActiveEntitySpriteVariant = mem[AgahnimAppearFrames + ((t >> 3) & 0x0F)]
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@g2
	ld hl, AgahnimAppearFrames
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>     return DrawNightmareGel(slot)
	jp DrawNightmareGel

.appear
;> wFinalNightmareHidden = 0
	xor a
	ld [wFinalNightmareHidden], a
;> NightmareAgahnimFaceLink(slot)
	call NightmareAgahnimFaceLink
;> wEntityY[slot] -= 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> IncrementEntityState(slot)                 # watch Link
	call IncrementEntityState
;> if wEntityPrivate3[slot]: return           # already appeared once
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ret nz
;> wEntityPrivate3[slot] = 1
	inc [hl]
;> PlayNightmareFormSfx()
	call PlayNightmareFormSfx
	ret


;@ path: boss/final_nightmare/agahnim
;@ First sprite variant of Agahnim's shadow facing each direction (by direction 0 right, 1 left,
;@ 2 up, 3 down): $0F, $0A, $05, $00. Each direction has 5 frames: 0-3 charging (arms raised
;@ more and more), 4 after the throw.
AgahnimFacingBase::
	db $0f, $0a, $05, $00

;@ def NightmareAgahnimWatch(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 2: keeps turning towards Link until the timer runs out, then starts to charge a ball
;@ (state 3, timer $C0, wave sound $22).
;@ test: skip calls routines in other banks
NightmareAgahnimWatch::
;> if GetEntityTimer(slot): return NightmareAgahnimFaceLink(slot)   # keep turning
	call GetEntityTimer
	jr nz, NightmareAgahnimFaceLink
;> hWaveSfx = 0x22
	ld a, $22
	ldh [hWaveSfx], a
;> wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;> return IncrementEntityState(slot)          # charge
	jp IncrementEntityState


;@ def NightmareAgahnimFaceLink(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Turns Agahnim's shadow towards Link: stores the direction in wNightmareFacing, the first frame
;@ of that direction (AgahnimFacingBase) in wEntityDirection, and falls through into
;@ NightmareAgahnimSetFrame.
;@ test: skip calls routines in other banks
NightmareAgahnimFaceLink::
;> d = GetEntityDirectionToLink_15(slot)
	call GetEntityDirectionToLink_15
;> wNightmareFacing = d
	ld a, e
	ld [wNightmareFacing], a
;>@g3 wEntityDirection[slot] = mem[AgahnimFacingBase + d]
	ld d, b
	ld hl, AgahnimFacingBase
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
;=@g3
	ld [hl], a
;> NightmareAgahnimSetFrame(slot)             # falls through

;@ def NightmareAgahnimSetFrame(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Sets the frame of Agahnim's shadow: the first frame of its direction (wEntityDirection) plus
;@ the step in wEntityPrivate1.
;@ test: wEntityDirection[c] = rand(0, 15); wEntityPrivate1[c] = rand(0, 4)
NightmareAgahnimSetFrame::
;>@g4 SetEntitySpriteVariant(wEntityDirection[slot] + wEntityPrivate1[slot])
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
;=@g4
	call SetEntitySpriteVariant
	ret


;@ path: boss/final_nightmare/agahnim
;@ Four bytes 0, 1, 2, 3 that nothing reads.
AgahnimUnusedSteps::
	db $00, $01, $02, $03

;@ path: boss/final_nightmare/agahnim
;@ Frame + 1 of the ball charging in Agahnim's hand (wNightmareChargeFrame) by its timer / 16
;@ (16 entries; the timer counts down from $C0, so the ball shows up after 16 frames and grows:
;@ 1, then 2, then 3): 3 3 3 3, 2 2 2 2, 1 1 1 1, 0 0 0 0.
AgahnimChargeFrames::
	db $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01
	db $00, $00, $00, $00

;@ path: boss/final_nightmare/agahnim
;@ Where the thrown ball starts, relative to Agahnim's shadow, by direction (0 right, 1 left,
;@ 2 up, 3 down): x offsets $18, -$18, 0, 0.
AgahnimBallOffsetX::
	db $18, $e8, $00, $00

;@ path: boss/final_nightmare/agahnim
;@ The matching y offsets: 0, 0, -$10, 0.
AgahnimBallOffsetY::
	db $00, $00, $f0, $00

;@ def NightmareAgahnimCharge(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 3: raises its arms in a 4-step cycle while a ball grows in its hand; until the timer
;@ falls below $40 it turns to Link again every 32 frames. When the timer runs out it throws an
;@ energy ball (entity $E6 with wEntityPrivate4 = 1, speed $18 towards Link) from its hand and
;@ goes on to vanish (state 4, timer $50). After two hits, every second throw on average is a
;@ ball that bursts against the walls instead (ball state 3, timer $1C).
;@ test: skip calls routines in other banks
NightmareAgahnimCharge::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .charge
;>     wNightmareChargeFrame = 0
	ld [wNightmareChargeFrame], a
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     _, ball = SpawnEntity(0xE6)            # (no check for a free slot)
	ld a, $e6
	call SpawnEntity
;>     wEntityPrivate4[ball] += 1             # it is a ball
	ld hl, wEntityPrivate4
	add hl, de
	inc [hl]
;>@x     wEntityX[ball] = u8(hMultiPurpose0 + mem[AgahnimBallOffsetX + wNightmareFacing])
	push bc
	ld a, [wNightmareFacing]
	ld c, a
	ld hl, AgahnimBallOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
;=@x
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@g5     wEntityY[ball] = u8(hMultiPurpose1 + mem[AgahnimBallOffsetY + wNightmareFacing])
	ld hl, AgahnimBallOffsetY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@g5
	ld [hl], a
;>     wEntityPhysicsFlags[ball] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42
;>     wEntityHitboxFlags[ball] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], d
;>     hNoiseSfx = 0x38
	ld a, $38
	ldh [hNoiseSfx], a
;>@g6     if wFinalNightmareHits >= 2 and (hLinkX + hFrameCounter) & 1 == 0:
	ld a, [wFinalNightmareHits]
	cp $02
	jr c, .aim
	ldh a, [hLinkX]
	ld hl, hFrameCounter
	add [hl]
;=@g6
	and $01
	jr nz, .aim
;>         wEntityState[ball] = 3             # a ball that bursts at the walls
	ld hl, wEntityState
	add hl, de
	ld [hl], $03
;>         wEntityTimer[ball] = 0x1C
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $1c
;>         hNoiseSfx = 0x39
	ld a, $39
	ldh [hNoiseSfx], a

.aim
;>     SetEntitySpeedTowardsLink(ball, 0x18)
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
	pop bc
;>     return IncrementEntityState(slot)      # vanish
	jp IncrementEntityState

.charge
;>@g7 wEntityPrivate1[slot] = (t >> 3) & 3       # arm step
	rra
	rra
	rra
	and $03
	ld hl, wEntityPrivate1
	add hl, bc
;=@g7
	ld [hl], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;>@cf wNightmareChargeFrame = mem[AgahnimChargeFrames + ((t >> 4) & 0x0F)]
	rra
	rra
	rra
	rra
	and $0f
	ld e, a
;=@cf
	ld d, b
	ld hl, AgahnimChargeFrames
	add hl, de
	ld a, [hl]
	ld [wNightmareChargeFrame], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t < 0x40: return NightmareAgahnimSetFrame(slot)
	cp $40
	jp c, NightmareAgahnimSetFrame
;> if t & 0x1F == 0: return NightmareAgahnimFaceLink(slot)
	and $1f
	jp z, NightmareAgahnimFaceLink
;> return NightmareAgahnimSetFrame(slot)
	jp NightmareAgahnimSetFrame


;@ def NightmareAgahnimVanish(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 4: holds the throwing pose (step 4) until the timer runs out, then vanishes into a
;@ blob 8 pixels lower (jingle $35) and goes on to pick a new spot (state 5, timer $27).
;@ test: skip calls routines in other banks
NightmareAgahnimVanish::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .pose
;>     wEntityTimer[slot] = 0x27
	ld [hl], $27
;>     hJingle = 0x35
	ld a, $35
	ldh [hJingle], a
;>     wEntityY[slot] += 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
;>     wFinalNightmareHidden = 1
	ld a, $01
	ld [wFinalNightmareHidden], a
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.pose
;> wEntityPrivate1[slot] = 4                  # the throwing pose
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $04
;> NightmareAgahnimSetFrame(slot)
	call NightmareAgahnimSetFrame
	ret


;@ path: boss/final_nightmare
;@ The 8 spots the final boss can move to (picked at random): x positions $50, $28, $78, $18,
;@ $88, $38, $68, $50.
NightmareTeleportX::
	db $50, $28, $78, $18, $88, $38, $68, $50

;@ path: boss/final_nightmare
;@ The matching y positions: $30, $30, $30, $50, $50, $70, $70, $74.
NightmareTeleportY::
	db $30, $30, $30, $50, $50, $70, $70, $74
;@ path: boss/final_nightmare/agahnim
;@ Frame of the blob while Agahnim's shadow sinks away, by its timer / 8 (the timer starts at
;@ $27, so read backwards: 4, 3, 2, 1, 0).
AgahnimVanishFrames::
	db $00, $01, $02, $03, $04

;@ def NightmareAgahnimPickSpot(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 5: the blob sinks (AgahnimVanishFrames); when the timer runs out it picks one of the 8
;@ spots at random (NightmareTeleportX/Y) and glides there (state 6, timer $1F).
;@ test: skip calls routines in other banks
NightmareAgahnimPickSpot::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .sink
;>     i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wFinalNightmareTargetX = mem[NightmareTeleportX + i]
	ld hl, NightmareTeleportX
	add hl, de
	ld a, [hl]
	ld [wFinalNightmareTargetX], a
;>     wFinalNightmareTargetY = mem[NightmareTeleportY + i]
	ld hl, NightmareTeleportY
	add hl, de
	ld a, [hl]
	ld [wFinalNightmareTargetY], a
;>     wEntityTimer[slot] = 0x1F
	call GetEntityTimer
	ld [hl], $1f
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.sink
;>@g8 hActiveEntitySpriteVariant = mem[AgahnimVanishFrames + ((t >> 3) & 0x0F)]
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@g8
	ld hl, AgahnimVanishFrames
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> return DrawNightmareGel(slot)
	jp DrawNightmareGel


;@ path: boss/final_nightmare/agahnim
;@ Speed of the gliding blob by its timer / 4 (the timer counts down from $1F, so read
;@ backwards: it starts at 1 and speeds up to $18): $18, $14, $10, $0C, $08, $05, $02, $01.
AgahnimTeleportSpeeds::
	db $18, $14, $10, $0c, $08, $05, $02, $01

;@ def NightmareAgahnimGlide(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 6: the blob glides towards the picked spot, faster and faster (AgahnimTeleportSpeeds);
;@ within 3 pixels of it, it appears again (state 1, timer $50).
;@ test: skip calls routines in other banks
NightmareAgahnimGlide::
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawNightmareGel(slot)
	call DrawNightmareGel
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> hLinkX = wFinalNightmareTargetX             # aim at the spot instead of Link
	ld a, [wFinalNightmareTargetX]
	ldh [hLinkX], a
;> hLinkY = wFinalNightmareTargetY
	ld a, [wFinalNightmareTargetY]
	ldh [hLinkY], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;>@sp SetEntitySpeedTowardsLink(mem[AgahnimTeleportSpeeds + ((t >> 2) & 7)])
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, AgahnimTeleportSpeeds
;=@sp
	add hl, de
	ld a, [hl]
	call SetEntitySpeedTowardsLink
;>@g9 if abs(hActiveEntityDrawY - hLinkY) <= 2 and abs(hActiveEntityX - hLinkX) <= 2:
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;=@g9
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;>     wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;>     wEntityState[slot] = 1                 # appear
	call IncrementEntityState
	ld [hl], $01

.move
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;> hLinkY = link_y
	pop af
	ldh [hLinkY], a
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
	ret


;@ path: boss/final_nightmare/agahnim
;@ First frame of each direction in the order the beaten shadow spins through them: $00 (down),
;@ $0A (left), $0F (right), $05 (up).
AgahnimSpinFacings::
	db $00, $0a, $0f, $05

;@ def NightmareAgahnimDefeated(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 7 (set by the fourth ball that hits it, timer $C0): spins faster and faster - the spin
;@ speed in $D221 grows to $80, is added up in $D222, and every overflow turns it a quarter
;@ ($D223). When the timer runs out it bursts into pieces, hides, and goes on to shrink
;@ (state 8, timer $50).
;@ test: skip calls routines in other banks
NightmareAgahnimDefeated::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .spin
;>     NightmareBurstIntoPieces(slot)
	call NightmareBurstIntoPieces
;>     wFinalNightmareHidden = 1
	ld a, $01
	ld [wFinalNightmareHidden], a
;>     SetEntitySpriteVariant(6)
	ld a, $06
	call SetEntitySpriteVariant
;>     wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;>     IncrementEntityState(slot)
	call IncrementEntityState
	ret

.spin
;> if mem[0xD221] < 0x80: mem[0xD221] += 1    # spin faster
	ld a, [$d221]
	cp $80
	jr nc, .turn
	inc a
	ld [$d221], a

.turn
;> mem[0xD222], carry = add(mem[0xD222], mem[0xD221])
	ld a, [$d221]
	ld hl, $d222
	add [hl]
	ld [hl], a
;> if carry: mem[0xD223] += 1                 # a quarter turn
	jr nc, .face
	ld hl, $d223
	inc [hl]

.face
;>@g10 wEntityDirection[slot] = mem[AgahnimSpinFacings + (mem[0xD223] & 3)]
	ld a, [$d223]
	and $03
	ld e, a
	ld d, b
	ld hl, AgahnimSpinFacings
	add hl, de
;=@g10
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;> NightmareAgahnimSetFrame(slot)
	call NightmareAgahnimSetFrame
	ret


;@ def NightmareAgahnimShrink(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 8: the remains shrink (blob frames 2, 1, 0 during the last $18 frames, variant 6
;@ before); when the timer runs out the boss jingle plays and it glides off (state 9).
;@ test: skip calls routines in other banks
NightmareAgahnimShrink::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shrink
;>     PlayNightmareJingle()
	call PlayNightmareJingle
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.shrink
;>@g11 if t < 0x18: SetEntitySpriteVariant((t >> 3) & 3)
	cp $18
	jr nc, .draw
	rra
	rra
	rra
	and $03
;=@g11
	call SetEntitySpriteVariant

.draw
;> DrawNightmareGel(slot)
	call DrawNightmareGel
	ret


;@ def NightmareAgahnimLeave(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ State 9: glides to the top of the room (X $50, Y $30) at speed $10; there the next form
;@ begins (NightmareNextForm, timer $31, full health $FF, wEntityWorkRAM2 cleared for the next
;@ form's trail).
;@ test: skip calls routines in other banks
NightmareAgahnimLeave::
;> DrawNightmareGel(slot)
	call DrawNightmareGel
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;> hLinkY = 0x30
	ld a, $30
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>@g12 if abs(hActiveEntityDrawY - 0x30) <= 2 and abs(hActiveEntityX - 0x50) <= 2:
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;=@g12
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;>     NightmareNextForm(slot)
	call NightmareNextForm
;>     wEntityTimer[slot] = 0x31
	call GetEntityTimer
	ld [hl], $31
;>     wEntityHealth[slot] = 0xFF
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
;>     ClearNightmareWorkRAM2()
	call ClearNightmareWorkRAM2

.move
;> hLinkY = link_y
	pop af
	ldh [hLinkY], a
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
	ret


;@ def DrawNightmareAgahnim(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Draws Agahnim's shadow: the ball charging in its hand, its two hands, then the body.
;@ test: skip calls routines in other banks
DrawNightmareAgahnim::
;> DrawAgahnimChargeBall(slot)
	call DrawAgahnimChargeBall
;> DrawAgahnimHandA(slot)
	call DrawAgahnimHandA
;> DrawAgahnimHandB(slot)
	call DrawAgahnimHandB
;> DrawAgahnimBody(slot)
	call DrawAgahnimBody
	ret


;@ path: boss/final_nightmare/agahnim
;@ Hand sprites for RenderActiveEntitySpritesPair: 4 variants of 4 bytes (tile, attributes of
;@ the left and the right 8x16 half): 0 $6A/$6C, 1 the same mirrored, 2 $6A alone, 3 $6A
;@ mirrored alone (tile $FF = nothing).
AgahnimHandSprites::
	db $6a, $00, $6c, $00, $6c, $20, $6a, $20, $6a, $00, $ff, $ff, $6a, $20, $ff, $ff
;@ path: boss/final_nightmare/agahnim
;@ Hand frames 4 and 5 for RenderActiveEntitySpritesRect (the hand seen from the side): 2 OAM
;@ entries of 4 bytes each (y offset, x offset, tile, attributes): frame 4 $6A at (0, 0) and
;@ $7A at (8, 8); frame 5 the mirror image, $7A at (8, 0) and $6A at (0, 8).
AgahnimHandRectSprites::
	db $00, $00, $6a, $00, $08, $08, $7a, $00, $08, $00, $7a, $20, $00, $08, $6a, $20
;@ path: boss/final_nightmare/agahnim
;@ Frame of the first hand by the shadow's sprite variant (20 entries: 0-4 facing down, 5-9 up,
;@ 10-14 left, 15-19 right; in each direction 4 charging steps and the throw): frames 0-3 are
;@ AgahnimHandSprites variants, 4-5 AgahnimHandRectSprites frames.
AgahnimHandAFrames::
	db $00, $00, $00, $00, $02, $00, $00, $00, $00, $02, $04, $04, $04, $04, $04, $05
	db $05, $05, $05, $05

;@ path: boss/final_nightmare/agahnim
;@ X offset of the first hand from the shadow, by sprite variant (20 entries, signed).
AgahnimHandAX::
	db $f0, $f3, $f3, $f0, $f5, $f0, $f3, $f3, $f0, $f5, $f1, $f0
	db $f1, $f2, $f0, $0f, $10, $0f, $0e, $10

;@ path: boss/final_nightmare/agahnim
;@ Y offset of the first hand (added to the shadow's drawn y + 8), by sprite variant (20
;@ entries, signed).
AgahnimHandAY::
	db $ed, $ed, $f1, $f1, $fd, $ed, $ed, $f1
	db $f1, $fd, $f4, $f6, $f7, $f6, $f8, $f4, $f6, $f7, $f6, $f8

;@ path: boss/final_nightmare/agahnim
;@ Frame of the second hand by sprite variant (20 entries, as AgahnimHandAFrames).
AgahnimHandBFrames::
	db $01, $01, $01, $01
	db $03, $01, $01, $01, $01, $03, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03
;@ path: boss/final_nightmare/agahnim
;@ X offset of the second hand by sprite variant (20 entries, signed).
AgahnimHandBX::
	db $10, $0d, $0d, $10, $13, $10, $0d, $0d, $10, $13, $f5, $f6, $f5, $f4, $f3, $13
	db $12, $13, $14, $15

;@ path: boss/final_nightmare/agahnim
;@ Y offset of the second hand (added to the drawn y + 8) by sprite variant (20 entries, signed).
AgahnimHandBY::
	db $ed, $ed, $f1, $f1, $fd, $ed, $ed, $f1, $f1, $fd, $eb, $ec
	db $ed, $ec, $f2, $eb, $ec, $ed, $ec, $f2

;@ def DrawAgahnimHandB(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Draws the second hand of Agahnim's shadow: moves the draw position by AgahnimHandBX/BY for
;@ the current sprite variant and goes on into DrawAgahnimHandA's drawing part with the frame
;@ from AgahnimHandBFrames.
;@ test: skip calls routines in other banks
DrawAgahnimHandB::
;> v = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
;> hActiveEntityX = u8(hActiveEntityX + mem[AgahnimHandBX + v])
	ld hl, AgahnimHandBX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + 8 + mem[AgahnimHandBY + v])
	ld hl, AgahnimHandBY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add $08
	add [hl]
	ldh [hActiveEntityDrawY], a
;> return DrawAgahnimHandA.draw(mem[AgahnimHandBFrames + v])
	ld hl, AgahnimHandBFrames
	add hl, de
	jr DrawAgahnimHandA.draw

;@ def DrawAgahnimHandA(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Draws the first hand of Agahnim's shadow at its offset (AgahnimHandAX/AY) for the current
;@ sprite variant: frames 0-3 as a 16x16 pair, frames 4-5 as two loose 8x16 sprites; then
;@ reserves the 2 OAM entries and restores the draw position.
;@ test: skip calls routines in other banks
DrawAgahnimHandA::
;> v = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
;> hActiveEntityX = u8(hActiveEntityX + mem[AgahnimHandAX + v])
	ld hl, AgahnimHandAX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + 8 + mem[AgahnimHandAY + v])
	ld hl, AgahnimHandAY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add $08
	add [hl]
	ldh [hActiveEntityDrawY], a
;>@fa frame = mem[AgahnimHandAFrames + v]
	ld hl, AgahnimHandAFrames
	add hl, de

.draw
;=@fa
	ld a, [hl]
;> if frame < 4:
	cp $04
	jr nc, .side
;>     hActiveEntitySpriteVariant = frame
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(AgahnimHandSprites)
	ld de, AgahnimHandSprites
	call DrawEntity16x16
	jr .reserve

.side
;> else:
;>@sd     DrawEntitySprites(AgahnimHandRectSprites + (frame - 4) * 8, 2)
	sub $04
	rla
	rla
	rla
	and $f8
	ld e, a
;=@sd
	ld d, b
	ld hl, AgahnimHandRectSprites
	add hl, de
	ld c, $02
	call DrawEntitySprites

.reserve
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)                   # undo the offset
	call LoadEntityPosition
	ret


;@ path: boss/final_nightmare/agahnim
;@ Body of Agahnim's shadow for RenderActiveEntitySpritesRect: 14 frames of 32 bytes, each 8 OAM
;@ entries of 4 bytes (y offset, x offset, tile, attributes; tile $FF = nothing). Frames 0-4
;@ face down (head $60/$62, robe $6E/$64; the charging steps shift the sleeves by a pixel),
;@ 5-9 face up (back $66, $68), 10-11 face left and 12-13 face right with 4 sprites ($72-$78,
;@ mirrored for the right); the last frame of each direction is the throw.
AgahnimBodySprites::
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $05, $f8, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $05, $10, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $05, $f9, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $05, $0f, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $06, $f9, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $06, $0f, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $06, $f8, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $06, $10, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $62, $00, $fa, $08, $62, $20, $fa, $10, $60, $20
	db $08, $f8, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $08, $10, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $05, $f8, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $05, $10, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $05, $f9, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $05, $0f, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $06, $f9, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $06, $0f, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $06, $f8, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $06, $10, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $66, $00, $f8, $08, $66, $20, $f8, $10, $60, $20
	db $04, $f8, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $04, $10, $6e, $20
	db $f8, $fc, $72, $00, $f8, $04, $74, $00, $08, $00, $76, $00, $08, $08, $78, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fa, $fb, $72, $00, $fa, $03, $74, $00, $08, $00, $76, $00, $08, $08, $78, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $04, $74, $20, $f8, $0c, $72, $20, $08, $00, $78, $20, $08, $08, $76, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fa, $05, $74, $20, $fa, $0d, $72, $20, $08, $00, $78, $20, $08, $08, $76, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: boss/final_nightmare/agahnim
;@ Body frame (AgahnimBodySprites) by the shadow's sprite variant (20 entries): down 0-4, up
;@ 5-9, left 10 10 10 10 then 11 for the throw, right 12 12 12 12 then 13.
AgahnimBodyFrames::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0a, $0a, $0a, $0b, $0c
	db $0c, $0c, $0c, $0d

;@ def DrawAgahnimBody(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Draws the body of Agahnim's shadow (8 sprites of the frame AgahnimBodyFrames gives for the
;@ current sprite variant) and reserves 8 OAM entries.
;@ test: skip calls routines in other banks
DrawAgahnimBody::
;>@fr frame = mem[AgahnimBodyFrames + wEntitySpriteVariant[slot]]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, AgahnimBodyFrames
;=@fr
	add hl, de
	ld a, [hl]
;>@of offset = frame * 32
	ld d, $00
	ld e, a
	sla e
	rl d
	sla e
	rl d
;=@of
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
;> DrawEntitySprites(AgahnimBodySprites + offset, 8)
	ld hl, AgahnimBodySprites
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
	ret


;@ path: boss/final_nightmare/agahnim
;@ The ball charging in Agahnim's hand for RenderActiveEntitySpritesPair: 3 growing variants of
;@ 4 bytes (tile, attributes of each 8x16 half): 0 $1E (the right half flipped both ways),
;@ 1 $7C, 2 $7E (each with its mirror image).
AgahnimChargeSprites::
	db $1e, $00, $1e, $60, $7c, $00, $7c, $20, $7e, $00, $7e, $20

;@ path: boss/final_nightmare/agahnim
;@ X offset of the charging ball from the shadow by wNightmareFacing (0 right, 1 left, 2 up,
;@ 3 down): $14, -$14, 0, 0.
AgahnimChargeOffsetX::
	db $14, $ec, $00, $00
;@ path: boss/final_nightmare/agahnim
;@ The matching y offsets: 0, 0, -$10, 4.
AgahnimChargeOffsetY::
	db $00, $00, $f0, $04

;@ def DrawAgahnimChargeBall(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Draws the charging ball, keeping the shadow's own sprite attributes.
;@ test: skip calls routines in other banks
DrawAgahnimChargeBall::
;> flip = hActiveEntityFlipAttribute
	ldh a, [hActiveEntityFlipAttribute]
	push af
;> DrawAgahnimChargeBallSprite(slot)
	call DrawAgahnimChargeBallSprite
;> hActiveEntityFlipAttribute = flip
	pop af
	ldh [hActiveEntityFlipAttribute], a
	ret


;@ def DrawAgahnimChargeBallSprite(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ While a ball is charging (wNightmareChargeFrame), draws it in the hand on the side Agahnim's
;@ shadow faces, flickering between palettes and flipped every 8 frames.
;@ test: skip calls routines in other banks
DrawAgahnimChargeBallSprite::
;> if not wNightmareChargeFrame: return
	ld a, [wNightmareChargeFrame]
	and a
	ret z
;> hActiveEntitySpriteVariant = wNightmareChargeFrame - 1
	dec a
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityFlipAttribute = (hFrameCounter << 3) & 0x50   # flicker
	ldh a, [hFrameCounter]
	rla
	rla
	rla
	and $50
	ldh [hActiveEntityFlipAttribute], a
;> d = wNightmareFacing
	ld a, [wNightmareFacing]
	ld e, a
	ld d, b
;> hActiveEntityX = u8(hActiveEntityX + mem[AgahnimChargeOffsetX + d])
	ld hl, AgahnimChargeOffsetX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + mem[AgahnimChargeOffsetY + d])
	ld hl, AgahnimChargeOffsetY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(AgahnimChargeSprites)
	ld de, AgahnimChargeSprites
	call DrawEntity16x16
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)
	call LoadEntityPosition
	ret


;@ path: boss/final_nightmare/agahnim
;@ Sprites (tile, attributes per 8x16 half) only AgahnimUnusedKind points at: 0 $46 with its
;@ copy flipped both ways, 1 $70 alone.
AgahnimUnusedSprites::
	db $46, $00, $46, $60, $70, $00, $ff, $ff

;@ def AgahnimUnusedKind(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ The kind wEntityPrivate4 = 2 of the final boss in Agahnim's form, which nothing creates: it
;@ only loads AgahnimUnusedSprites and returns without drawing.
;@ test: skip does nothing
AgahnimUnusedKind::
;> return AgahnimUnusedSprites                # (left in de, never drawn)
	ld de, AgahnimUnusedSprites
	ret


;@ path: boss/final_nightmare/agahnim
;@ Energy ball sprites for RenderActiveEntitySpritesPair: 5 variants of 4 bytes (tile,
;@ attributes per 8x16 half): 0 the thrown ball $7E, 1 a big trail spark $7C, 2 a small spark
;@ $1E (right half flipped both ways), 3-4 the bursting ball $58 and $5A (each with its mirror
;@ image).
AgahnimBallSprites::
	db $7e, $00, $7e, $20, $7c, $00, $7c, $20, $1e, $00, $1e, $60, $58, $00, $58, $20
	db $5a, $00, $5a, $20

;@ def AgahnimBall(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ An energy ball of Agahnim's shadow (entity $E6, wEntityPrivate4 = 1), drawn flickering.
;@ States: 0 flying at Link, 1 struck back by the sword, 2 flying back (hurts the shadow),
;@ 3 a ball that bursts into four shots at the walls, 4 a fading spark of a ball's trail
;@ (blinks on every other frame, big for 8 frames then small, gone after $0F frames).
;@ test: skip jumps through a table
AgahnimBall::
;> hActiveEntityFlipAttribute = (hFrameCounter << 3) & 0x50   # flicker
	ldh a, [hFrameCounter]
	rla
	rla
	rla
	and $50
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(AgahnimBallSprites)
	ld de, AgahnimBallSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> if hActiveEntityState == 4:                # a spark
	ldh a, [hActiveEntityState]
	cp $04
	jr nz, .ball
;>     t = wEntityTimer1[slot]
	call GetEntityTimer1
;>     if t == 0: return ClearEntityStatus_15(slot)
	jp z, ClearEntityStatus_15
;>     if (t ^ slot) & 1 == 0: variant = 0xFF   # hidden on every other frame
	xor c
	bit 0, a
	ld e, $ff
	jr z, .setVariant
;>     elif GetEntityTimer1(slot) >= 8: variant = 1
	call GetEntityTimer1
	ld e, $01
	cp $08
	jr nc, .setVariant
;>     else: variant = 2
	ld e, $02

.setVariant
;>     SetEntitySpriteVariant(variant)
	ld a, e
	call SetEntitySpriteVariant
;>     return
	ret

.ball
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> AgahnimBallStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare/agahnim
;@ States of an energy ball (rst $00 table indexed by wEntityState; state 4, a spark, is handled
;@ before it): 0 fly, 1 struck back, 2 fly back, 3 burst at the walls.
AgahnimBallStates::
	dw AgahnimBallFly
	dw AgahnimBallReflected
	dw AgahnimBallReturn
	dw AgahnimSplitBall

;@ def AgahnimBallFly(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Ball state 0: flies at Link and can be struck by his sword (which sends it into state 1);
;@ leaves a trail and falls through into AgahnimBallTrail.
;@ test: skip calls routines in other banks
AgahnimBallFly::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> AgahnimBallTrail(slot)                     # falls through

;@ def AgahnimBallTrail(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Every 4th frame leaves a spark behind the ball (entity $E6, wEntityPrivate4 = 1, state 4,
;@ variant 1, timer1 $0F, physics flags $C2); the ball is removed when it hits a wall.
;@ test: skip calls routines in other banks
AgahnimBallTrail::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] & 3 == 0:
	and $03
	jr nz, .walls
;>     full, spark = SpawnEntity(0xE6)
	ld a, $e6
	call SpawnEntity
;>     if full: return
	ret c
;>     wEntityPhysicsFlags[spark] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;>     wEntityHitboxFlags[spark] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], d
;>     wEntityPrivate4[spark] += 1            # a ball's kind
	ld hl, wEntityPrivate4
	add hl, de
	inc [hl]
;>     wEntityX[spark] = hMultiPurpose0       # at the ball
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[spark] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityTimer1[spark] = 0x0F
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
;>     wEntitySpriteVariant[spark] = 1
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $01
;>     wEntityState[spark] = 4                # a spark
	ld hl, wEntityState
	add hl, de
	ld [hl], $04

.walls
;> if not wEntityCollisions[slot]: return
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;> return ClearEntityStatus_15(slot)          # hit a wall
	jp ClearEntityStatus_15

.done
	ret


;@ def AgahnimBallReflected(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Ball state 1, after Link's sword struck the ball: it flies straight back away from Link at
;@ speed $18 while Link is pushed back the other way for $10 frames; then state 2.
;@ test: skip calls routines in other banks
AgahnimBallReflected::
;> hNoiseSfx = 0x08
	ld a, $08
	ldh [hNoiseSfx], a
;> GetVectorTowardsLink(0x18)                 # into hMultiPurpose0 (y), hMultiPurpose1 (x)
	ld a, $18
	call GetVectorTowardsLink
;> hLinkSpeedY = hMultiPurpose0               # Link is knocked back
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;> wEntitySpeedY[slot] = u8(-hMultiPurpose0)  # the ball flies away from him
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
;> wEntitySpeedX[slot] = u8(-hMultiPurpose1)
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wLinkPushedTimer = 0x10
	ld a, $10
	ld [wLinkPushedTimer], a
;> IncrementEntityState(slot)
	call IncrementEntityState
	ret


;@ def AgahnimBallReturn(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Ball state 2: the struck ball flies on with its trail; if it comes within 16 pixels across
;@ and 12 down of the visible shadow (slot in wSmasherBallSlot) it vanishes and knocks the
;@ shadow back at twice its speed: the shadow flashes, ignores hits for $12 frames, and counts
;@ the hit in wFinalNightmareHits. The fourth hit beats it (state 7, timer $C0, jingle $36).
;@ test: skip calls routines in other banks
AgahnimBallReturn::
;> AgahnimBallTrail(slot)
	call AgahnimBallTrail
;> if wFinalNightmareHidden: return
	ld a, [wFinalNightmareHidden]
	and a
	ret nz
;> boss = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;>@x if not -16 <= hActiveEntityX - wEntityX[boss] < 16: return
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $10
	cp $20
;=@x
	jr nc, .done
;>@y if not -12 <= hActiveEntityDrawY - wEntityY[boss] < 12: return
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
	cp $18
;=@y
	jr nc, .done
;>@rx wEntityRecoilSpeedX[boss] = u8(wEntitySpeedX[slot] << 1)
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, wEntityRecoilSpeedX
	add hl, de
;=@rx
	ld [hl], a
;>@ry wEntityRecoilSpeedY[boss] = u8(wEntitySpeedY[slot] << 1)
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, wEntityRecoilSpeedY
	add hl, de
;=@ry
	ld [hl], a
;> wEntityIgnoreHitsTimer[boss] = 0x12
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], $12
;> ClearEntityStatus_15(slot)                 # the ball is gone
	call ClearEntityStatus_15
;> wFinalNightmareHits += 1
	ld a, [wFinalNightmareHits]
	inc a
	ld [wFinalNightmareHits], a
;> if wFinalNightmareHits >= 4:
	cp $04
	jr c, .flash
;>     wEntityState[boss] = 7                 # beaten
	ld hl, wEntityState
	add hl, de
	ld [hl], $07
;>     wEntityTimer[boss] = 0xC0
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $c0
;>     hJingle = 0x36
	ld a, $36
	ldh [hJingle], a

.flash
;> wEntityFlashTimer[boss] = 0x14
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $14
;> hWaveSfx = 0x07
	ld a, $07
	ldh [hWaveSfx], a

.done
	ret


;@ path: boss/final_nightmare/agahnim
;@ X speeds of the four shots a bursting ball sends out (diagonals): $20, $20, -$20, -$20.
AgahnimBallBurstSpeedX::
	db $20, $20, $e0, $e0

;@ path: boss/final_nightmare/agahnim
;@ The matching y speeds: $20, -$20, $20, -$20.
AgahnimBallBurstSpeedY::
	db $20, $e0, $20, $e0

;@ def AgahnimSplitBall(slot: c)
;@ path: boss/final_nightmare/agahnim
;@ Ball state 3: a ball that cannot be struck back. It hurts Link on contact, pulses between two
;@ frames every 8 frames, homes in on Link (speed $18, on every second frame while its $1C-frame
;@ timer runs), and when it hits a wall bursts into four shots (entity $7D) flying off
;@ diagonally (AgahnimBallBurstSpeedX/Y).
;@ test: skip calls routines in other banks
AgahnimSplitBall::
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;>@va SetEntitySpriteVariant(3 + ((hFrameCounter >> 3) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $03
;=@va
	call SetEntitySpriteVariant
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t and t & 1 == 0: SetEntitySpeedTowardsLink(0x18)
	jr z, .walls
	and $01
	jr nz, .walls
	ld a, $18
	call SetEntitySpeedTowardsLink

.walls
;> if not wEntityCollisions[slot]: return
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;> hNoiseSfx = 0x36
	ld a, $36
	ldh [hNoiseSfx], a
;>@lp for i in range(4):
	xor a

.shot
;>     hBGTilesRequestCopy = i                # (scratch here)
	ldh [hBGTilesRequestCopy], a
;>     full, shot = SpawnEntity(0x7D)
	ld a, $7d
	call SpawnEntity
;>     if full: break
	jr c, .gone
;>     wEntityX[shot] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[shot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[shot] += 1
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>     wEntityX[shot] = hMultiPurpose0        # (set a second time)
	push bc
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[shot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>@sx     wEntitySpeedX[shot] = mem[AgahnimBallBurstSpeedX + i]
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, AgahnimBallBurstSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
;=@sx
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[shot] = mem[AgahnimBallBurstSpeedY + i]
	ld hl, AgahnimBallBurstSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;=@lp
	pop bc
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $04
	jr nz, .shot

.gone
;> ClearEntityStatus_15(slot)                 # the ball is gone
	jp ClearEntityStatus_15

.done
	ret


;@ def ClearNightmareWorkRAM2()
;@ path: boss/final_nightmare
;@ Clears the first $80 bytes of wEntityWorkRAM2 (the final boss's trail history of y
;@ positions) before the next form.
;@ test: skip writes a RAM block
ClearNightmareWorkRAM2::
;>@cl fill(wEntityWorkRAM2, 0, 0x80)
	ld e, $80
	ld hl, wEntityWorkRAM2

.clear
;=@cl
	xor a
	ld [hli], a
	dec e
	jr nz, .clear
	ret


;@ path: boss/final_nightmare/moldorm
;@ Sprite variant of Moldorm's head by its direction (16 entries, 0 = right, then clockwise in
;@ steps of 22.5 degrees). NightmareMoldormMove sets it, but NightmareMoldormStep sets the
;@ variant again from NightmareMoldormBodyFrames right after.
NightmareMoldormDirFrames::
	db $03, $03, $05, $05, $00, $00, $04, $04, $02, $02, $06, $06, $01, $01, $07, $07
;@ path: boss/final_nightmare/moldorm
;@ Y speed of Moldorm by direction: 16 entries that run on into NightmareMoldormSpeedX (a sine
;@ table: 0, 6, $0C, $0E, $10, ... - 0 = right, 4 = down, 8 = left, 12 = up).
NightmareMoldormSpeedY::
	db $00, $06, $0c, $0e

;@ path: boss/final_nightmare/moldorm
;@ X speed of Moldorm by direction (16 entries, the cosine to NightmareMoldormSpeedY): $10, $0E,
;@ $0C, 6, 0, -6, -$0C, -$0E, -$10, -$0E, -$0C, -6, 0, 6, $0C, $0E.
NightmareMoldormSpeedX::
	db $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa
	db $00, $06, $0c, $0e

;@ path: boss/final_nightmare/moldorm
;@ Head frame (NightmareMoldormHeadSprites) by direction / 2 (8 entries): right 6, down-right 7,
;@ down 0, down-left 1, left 2, up-left 3, up 4, up-right 5.
NightmareMoldormBodyFrames::
	db $06, $07, $00, $01, $02, $03, $04, $05

;@ def NightmareCheckHitsIfActive(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ Checks the weapons hitting the final boss, unless the game is paused or in a cutscene.
;@ test: skip calls routines in other banks
NightmareCheckHitsIfActive::
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> return EntityCheckHits(slot)
	jp EntityCheckHits


;@ def NightmareMoldorm(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ Form 3 of the final boss: a giant Moldorm. Its head crawls around the room, turning in
;@ curves and bouncing off the walls, with three body segments and a tail following along its
;@ path. Only the tail can be hurt; 16 points of damage beat it.
;@ test: skip jumps through a table
NightmareMoldorm::
;> NightmareMoldormStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare/moldorm
;@ States of the Moldorm form (rst $00 table indexed by wEntityState): 0 take shape, 1 crawl,
;@ 2 dying (crawls on until the dying timer runs out), 3 vanish and turn into the next form.
NightmareMoldormStates::
	dw NightmareMoldormAppear
	dw NightmareMoldormActive
	dw NightmareMoldormDying
	dw NightmareMoldormVanish

;@ path: boss/final_nightmare/moldorm
;@ The shape the shadow takes between forms, for RenderActiveEntitySpritesRect: 4 frames of 24
;@ bytes, each 6 OAM entries of 4 bytes (y offset, x offset, tile, attributes; tile $FF =
;@ nothing). 0-2 a dot growing ($4A, $4C, $4E, each with its mirror image), 3 the coiled shape
;@ of 6 sprites ($78, $7A, $7C and their mirror images).
NightmareMoldormFormSprites::
	db $00, $00, $4a, $00, $00, $08, $4a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $4c, $00, $00, $08, $4c, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $f8, $78, $00, $f8, $00, $7a, $00
	db $f8, $08, $7a, $20, $00, $10, $78, $20, $08, $00, $7c, $00, $08, $08, $7c, $20
;@ path: boss/final_nightmare/moldorm
;@ Frame of NightmareMoldormFormSprites while the Moldorm takes shape, by its timer / 8 (the
;@ timer counts down from $31, so read backwards: the dot grows and coils up): 3, 3, 2, 1, 0,
;@ 0, 0, 0.
NightmareMoldormAppearFrames::
	db $03, $03, $02, $01, $00, $00, $00, $00

;@ def NightmareMoldormAppear(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ State 0: the shadow grows from a dot into the coiled Moldorm (NightmareMoldormAppearFrames);
;@ at timer $20 the sound of a new form plays; when the timer runs out it starts to crawl.
;@ test: skip calls routines in other banks
NightmareMoldormAppear::
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0: return IncrementEntityState(slot)
	jr nz, .shape
	jp IncrementEntityState

.shape
;> if t == 0x20:
	cp $20
	jr nz, .frame
;>     wEntityTimer[slot] -= 1                # (so the sound plays once)
	dec [hl]
;>     PlayNightmareFormSfx()
	call PlayNightmareFormSfx
	ld a, $20

.frame
;>@g1 frames = NightmareMoldormAppearFrames + ((t >> 3) & 7)
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;=@g1
	ld hl, NightmareMoldormAppearFrames

.draw
;>@of offset = mem[frames] * 24
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	and $f8
;=@of
	ld e, a
	rla
	and $f0
	add e
	ld e, a
;> DrawEntitySprites(NightmareMoldormFormSprites + offset, 6)
	ld hl, NightmareMoldormFormSprites
	add hl, de
	ld c, $06
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
	ret


;@ path: boss/final_nightmare/moldorm
;@ Frame of NightmareMoldormFormSprites while the beaten Moldorm vanishes, by its timer / 8 (the
;@ timer counts down from $1F, so only entries 0-3 are used: 1, 1, then the dot 0, 0).
NightmareMoldormVanishFrames::
	db $00, $00, $01, $01, $02, $02, $03, $03

;@ def NightmareMoldormVanish(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ State 3: the remains shrink to a dot (NightmareMoldormVanishFrames); when the timer runs out
;@ the next form begins with full health $FF and the hitbox and flags of Ganon's shadow
;@ (physics flags $40, hitbox flags $0A, options $90).
;@ test: skip calls routines in other banks
NightmareMoldormVanish::
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shrink
;>     NightmareNextForm(slot)
	call NightmareNextForm
;>     PlayNightmareJingle()
	call PlayNightmareJingle
;>     wEntityHealth[slot] = 0xFF
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
;>     wEntityPhysicsFlags[slot] = 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $40
;>     wEntityHitboxFlags[slot] = 0x0A
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $0a
;>     wEntityOptions1[slot] = 0x90
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $90
;>     LoadEntityHitbox(slot)
	call LoadEntityHitbox
;>     return
	ret

.shrink
;>@g2 frames = NightmareMoldormVanishFrames + ((t >> 3) & 7)
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;=@g2
	ld hl, NightmareMoldormVanishFrames
;> NightmareMoldormAppear.draw(frames)
	jr NightmareMoldormAppear.draw

;@ def NightmareMoldormDying(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ State 2: the beaten Moldorm crawls on (NightmareMoldormActive) until its dying timer runs
;@ out; then it bursts into pieces and vanishes (state 3, timer $1F).
;@ test: skip calls routines in other banks
NightmareMoldormDying::
;> if wEntityDyingTimer[slot]: return NightmareMoldormActive(slot)
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, NightmareMoldormActive
;> wEntityTimer[slot] = 0x1F
	call GetEntityTimer
	ld [hl], $1f
;> NightmareBurstIntoPieces(slot)
	call NightmareBurstIntoPieces
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def NightmareMoldormActive(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ State 1: checks weapon hits, draws the Moldorm and crawls one step. For a while after being
;@ hurt (wEntityTimer2) it crawls two steps a frame and its sounds play in their fast variant
;@ (wSfxFastVariant). Its crawling sound (jingle $38) plays every 12 frames, counted in
;@ wSmasherSlot.
;@ test: skip calls routines in other banks
NightmareMoldormActive::
;> NightmareCheckHitsIfActive(slot)
	call NightmareCheckHitsIfActive
;> DrawNightmareMoldorm(slot)
	call DrawNightmareMoldorm
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> wSfxFastVariant = 0
	xor a
	ld [wSfxFastVariant], a
;> period = 12
	ld e, $0c
;> if wEntityTimer2[slot]:                    # just hurt: hurry
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .sound
;>     NightmareMoldormStep(slot)             # an extra step
	call NightmareMoldormStep
;>     wSfxFastVariant = 1
	ld a, $01
	ld [wSfxFastVariant], a
;>     period = 12
	ld e, $0c

.sound
;> wSmasherSlot += 1                          # (scratch here: the sound counter)
	ld hl, wSmasherSlot
	ld a, [hl]
	inc a
	ld [hl], a
;> if wSmasherSlot >= period:
	cp e
	jr c, NightmareMoldormStep
;>     wSmasherSlot = 0
	ld [hl], b
;>     hJingle = 0x38
	ld a, $38
	ldh [hJingle], a
;> NightmareMoldormStep(slot)                 # falls through

;@ def NightmareMoldormStep(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ One step of the Moldorm: records the head's position in the 128-entry history
;@ (wEntityWorkRAM x, wEntityWorkRAM2 y, at wEntityPrivateCounter) the body follows, moves the
;@ head (NightmareMoldormMove) and picks the head frame for its direction.
;@ test: skip calls routines in other banks
NightmareMoldormStep::
;> i = (wEntityPrivateCounter[slot] + 1) & 0x7F
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $7f
;> wEntityPrivateCounter[slot] = i
	ld [hl], a
;> wEntityWorkRAM[i] = hActiveEntityX
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hActiveEntityX]
	ld [hl], a
;> wEntityWorkRAM2[i] = hActiveEntityDrawY
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
;> NightmareMoldormMove(slot)
	call NightmareMoldormMove
;>@hf SetEntitySpriteVariant(mem[NightmareMoldormBodyFrames + (wEntityPrivate1[slot] >> 1)])
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
	ld hl, NightmareMoldormBodyFrames
;=@hf
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ path: boss/final_nightmare/moldorm
;@ The Moldorm's head for RenderActiveEntitySpritesRect: 8 frames of 32 bytes, each 8 OAM
;@ entries of 4 bytes (y offset, x offset, tile, attributes) forming a 32x32 picture; frame 0
;@ faces down, then one frame per 45 degrees clockwise (1 down-left, 2 left, 3 up-left, 4 up,
;@ 5 up-right, 6 right, 7 down-right). The eyes ($64/$66, $68/$6A, $6C/$6E) sit on the side
;@ it faces; $60/$62 make up the rest.
NightmareMoldormHeadSprites::
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
;@ path: boss/final_nightmare/moldorm
;@ Body and tail of the Moldorm for RenderActiveEntitySpritesPair: 4 variants of 4 bytes (tile,
;@ attributes of each 8x16 half, each with its mirror image): 0 big segment $70, 1 smaller
;@ segment $72, 2-3 the tail $74 and $76.
NightmareMoldormTailSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20

;@ def DrawNightmareMoldorm(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ Draws the Moldorm: the head (8 sprites), then from the position history the body segments
;@ $0C, $18 and $24 steps back and the tail $2E steps back (wiggling every 8 frames and
;@ flickering palettes every 4). While it is alive and not flashing, the tail is where weapons
;@ hit it (EntityCheckWeaponHits at the tail's position); once its health falls below $F0 it is
;@ beaten (state 2, dying timer $50).
;@ test: skip calls routines in other banks
DrawNightmareMoldorm::
;> wEntityPhysicsFlags[slot] = 0x48           # while the head is drawn
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $48
;>@hd DrawEntitySprites(NightmareMoldormHeadSprites + wEntitySpriteVariant[slot] * 32, 8)
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@hd
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, NightmareMoldormHeadSprites
;=@hd
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> wEntityPhysicsFlags[slot] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $42
;> now = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> i = (now - 0x0C) & 0x7F                    # first segment
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
;> DrawEntity16x16(NightmareMoldormTailSprites)
	ld de, NightmareMoldormTailSprites
	call DrawEntity16x16
;> i = (now - 0x18) & 0x7F                    # second segment
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
;> DrawEntity16x16(NightmareMoldormTailSprites)
	ld de, NightmareMoldormTailSprites
	call DrawEntity16x16
;> i = (now - 0x24) & 0x7F                    # third, smaller segment
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
;> DrawEntity16x16(NightmareMoldormTailSprites)
	ld de, NightmareMoldormTailSprites
	call DrawEntity16x16
;> i = (now - 0x2E) & 0x7F                    # the tail
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
;>@tv hActiveEntitySpriteVariant = 2 + ((hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;=@tv
	ldh [hActiveEntitySpriteVariant], a
;>@fl hActiveEntityFlipAttribute ^= (hFrameCounter << 2) & 0x10   # palette flicker
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
;=@fl
	ld [hl], a
;> DrawEntity16x16(NightmareMoldormTailSprites)
	ld de, NightmareMoldormTailSprites
	call DrawEntity16x16
;> if hActiveEntityState >= 2: return         # already beaten
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .done
;> if wEntityFlashTimer[slot]: return
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
;> wEntityOptions1[slot] = 0x90
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $90
;> EntityCheckWeaponHits(slot)                # at the tail
	call EntityCheckWeaponHits
;> wEntityOptions1[slot] = 0xD0
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $d0
;> if wEntityHealth[slot] < 0xF0:
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nc, .done
;>     IncrementEntityState(slot)             # beaten
	call IncrementEntityState
;>     wEntityDyingTimer[slot] = 0x50
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $50

.done
	ret


;@ def NightmareMoldormMove(slot: c)
;@ path: boss/final_nightmare/moldorm
;@ Moves the Moldorm's head in curves: wEntityPrivate1 is its direction (0-15, 0 = right,
;@ clockwise), wEntityPrivate2 the turn (+1 or -1) added every 6 frames. Every $10-$2F frames
;@ it picks a new random turn; at a wall it faces straight away from it (and turns the other
;@ way half of the time). While beaten or flashing it stays in place.
;@ test: skip calls routines in other banks
NightmareMoldormMove::
;>@mv if hActiveEntityState < 2 and not wEntityFlashTimer[slot]:
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .walls
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
;=@mv
	and a
	jr nz, .walls
;>     UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15

.walls
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> walls = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
;> if walls:
	and a
	jr z, .turn
;>     if walls & 1: d = 8                    # right wall: face left
	ld e, $08
	bit 0, a
	jr nz, .bounce
;>     elif walls & 2: d = 0                  # left wall: face right
	ld e, $00
	bit 1, a
	jr nz, .bounce
;>     elif walls & 4: d = 4                  # wall above: face down
	ld e, $04
	bit 2, a
	jr nz, .bounce
;>     else: d = 12                           # wall below: face up
	ld e, $0c

.bounce
;>     wEntityPrivate1[slot] = d
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], e
;>     if not GetRandomByte() & 1:
	call GetRandomByte
	rra
	jr c, .wallTimer
;>         wEntityPrivate2[slot] = u8(-wEntityPrivate2[slot])   # turn the other way
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
;> if wEntityTimer1[slot] == 0:               # every 6 frames
	call GetEntityTimer1
	jr nz, .newTurn
;>     wEntityTimer1[slot] = 6
	ld [hl], $06
;>@dr     d = (wEntityPrivate1[slot] + wEntityPrivate2[slot]) & 0x0F
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
;=@dr
	and $0f
;>     wEntityPrivate1[slot] = d
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>     SetEntitySpriteVariant(mem[NightmareMoldormDirFrames + d])
	ld hl, NightmareMoldormDirFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>     wEntitySpeedY[slot] = mem[NightmareMoldormSpeedY + d]
	ld hl, NightmareMoldormSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = mem[NightmareMoldormSpeedX + d]
	ld hl, NightmareMoldormSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

.newTurn
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x10
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;>     turn = u8((GetRandomByte() & 2) - 1)   # +1 or -1
	call GetRandomByte
	and $02
	dec a
;>     wEntityPrivate2[slot] = turn
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

.done
	ret


;@ def NightmareGanon(slot: c)
;@ path: boss/final_nightmare/ganon
;@ Form 4 of the final boss: Ganon's shadow. It raises its trident, sends out six fire bats,
;@ throws the spinning trident at Link and glides to another spot while the trident flies back
;@ to it. Every weapon hit hurts it; after 24 points of damage it bursts, turns into a dark blob
;@ that chases Link, and once that is hit it moves on to the next form. Entities of the same
;@ kind with wEntityPrivate1 = 1 are its trident, 2 its fire bats, 3 the blob's trail.
;@ test: skip jumps through a table
NightmareGanon::
;> kind = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if kind == 3: return GanonBlobTrail(slot)
	cp $03
	jp z, GanonBlobTrail
;> if kind == 2: return GanonBat(slot)
	cp $02
	jp z, GanonBat
;> if kind: return GanonTrident(slot)
	and a
	jp nz, GanonTrident
;> if hActiveEntityState >= 2:                # states 0-1 draw themselves
	ldh a, [hActiveEntityState]
	cp $02
	jr c, .states
;>     if hActiveEntityState in (11, 12):     # the blob
	cp $0b
	jr z, .blob
	cp $0c
	jr nz, .ganon

.blob
;>         hActiveEntitySpriteVariant = 6
	ld a, $06
	ldh [hActiveEntitySpriteVariant], a
;>         DrawNightmareGel(slot)
	call DrawNightmareGel
	jr .update

.ganon
;>     else:
;>         DrawNightmareGanon(slot)
	call DrawNightmareGanon

.update
;>     ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;>     DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;>     if hActiveEntityState < 9:             # not beaten yet
	ldh a, [hActiveEntityState]
	cp $09
	jr nc, .states
;>         EntityCheckHits(slot)
	call EntityCheckHits
;>         if wEntityHealth[slot] < 0xE8:     # 24 points of damage
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $e8
	jr nc, .states
;>             wEntityState[slot] = 9         # beaten
	call IncrementEntityState
	ld [hl], $09
;>             hActiveEntityState = 9
	ld a, $09
	ldh [hActiveEntityState], a
;>             hWaveSfx = 0x10
	ld a, $10
	ldh [hWaveSfx], a
;>             wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>             wEntityFlashTimer[slot] = 0x80
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $80

.states
;> NightmareGanonStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/final_nightmare/ganon
;@ States of Ganon's shadow (rst $00 table indexed by wEntityState): 0 glide to the top of the
;@ room, 1 take shape, 2 wait, 3 raise the trident, 4 send out fire bats, 5 twirl and throw the
;@ trident, 6 pause, 7 glide to a new spot, 8 wait for the trident to come back (it sets state
;@ 3 again), 9 beaten, 10 turn into a blob, 11 the blob chases Link, 12 glide to the top,
;@ 13 shrink and turn into the next form.
NightmareGanonStates::
	dw NightmareGanonCenter
	dw NightmareGanonAppear
	dw NightmareGanonWait
	dw NightmareGanonRaiseTrident
	dw NightmareGanonSpawnBats
	dw NightmareGanonThrowTrident
	dw NightmareGanonAfterThrow
	dw NightmareGanonGlide
	dw NightmareGanonWaitTrident
	dw NightmareGanonDefeated
	dw NightmareGanonBecomeBlob
	dw NightmareGanonBlob
	dw NightmareGanonLeave
	dw NightmareGanonShrink

;@ path: boss/final_nightmare/ganon
;@ The shadow taking Ganon's shape, for RenderActiveEntitySpritesRect: 5 frames of 24 bytes,
;@ each 6 OAM entries of 4 bytes (y offset, x offset, tile, attributes; tile $FF = nothing).
;@ 0-2 a growing dot ($4A, $4C, $4E with mirror images), 3 a 16x32 shape ($5C over $5E),
;@ 4 Ganon's head and shoulders ($50, $52, $6E over $6A, $6C, $6A).
GanonFormSprites::
	db $00, $00, $4a, $00, $00, $08, $4a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $4c, $00, $00, $08, $4c, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $00, $5c, $00, $f0, $08, $5c, $20
	db $00, $00, $5e, $00, $00, $08, $5e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $fc, $6a, $00, $00, $04, $6c, $20, $00, $0c, $6a, $20, $f3, $fc, $50, $00
	db $f3, $04, $52, $00, $f3, $0c, $6e, $00

;@ def NightmareGanonCenter(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 0: as a blob (gel frame 0), glides at speed $10 to the top of the room (X $50, Y $30);
;@ within 3 pixels it takes shape (state 1, timer $60).
;@ test: skip calls routines in other banks
NightmareGanonCenter::
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> SetEntitySpriteVariant(0)
	call SetEntitySpriteVariant
;> DrawNightmareGel(slot)
	call DrawNightmareGel
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkX = 0x50                              # aim at the spot instead of Link
	ld a, $50
	ldh [hLinkX], a
;> hLinkY = 0x30
	ld a, $30
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>@ar if abs(hActiveEntityDrawY - 0x30) <= 2 and abs(hActiveEntityX - 0x50) <= 2:
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;=@ar
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;>     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;>     IncrementEntityState(slot)
	call IncrementEntityState

.move
;> hLinkY = link_y
	pop af
	ldh [hLinkY], a
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
	ret


;@ path: boss/final_nightmare/ganon
;@ Frame of GanonFormSprites while the shadow takes shape, by its timer / 8 (13 entries; the
;@ timer counts down from $60, so read backwards: the dot grows into Ganon's head): 4, 3, 2,
;@ 1, then 0.
GanonAppearFrames::
	db $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ def NightmareGanonAppear(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 1: the shadow takes Ganon's shape (GanonAppearFrames); when the timer runs out Ganon's
;@ shadow stands there 8 pixels higher (variant 4, no trident), the sound of a new form plays
;@ and it waits (state 2, timer 8).
;@ test: skip calls routines in other banks
NightmareGanonAppear::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shape
;>     wNightmareTridentFrame = 0
	ld [wNightmareTridentFrame], a
;>     wEntityY[slot] -= 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     SetEntitySpriteVariant(4)
	ld a, $04
	call SetEntitySpriteVariant
;>     PlayNightmareFormSfx()
	call PlayNightmareFormSfx
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.shape
;>@fr frame = mem[GanonAppearFrames + ((t >> 3) & 0x0F)]
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@fr
	ld hl, GanonAppearFrames
	add hl, de
	ld a, [hl]
;>@of offset = frame * 24
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
;=@of
	and $f0
	add e
	ld e, a
;> DrawEntitySprites(GanonFormSprites + offset, 6)
	ld hl, GanonFormSprites
	add hl, de
	ld c, $06
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
	ret


;@ def NightmareGanonWait(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 2: waits for the timer, then raises the trident (state 3, timer $7F).
;@ test: skip calls routines in other banks
NightmareGanonWait::
;> if GetEntityTimer(slot): return NightmareGanonWaitDone()
	call GetEntityTimer
	jr nz, NightmareGanonWaitDone
;> wEntityTimer[slot] = 0x7F
	ld [hl], $7f
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def NightmareGanonFaceLink(slot: c)
;@ path: boss/final_nightmare/ganon
;@ Turns Ganon's shadow towards Link's side: wNightmareFacing = 0 when he is to the right,
;@ 1 when he is to the left.
;@ test: slot = rand(0, 15)
NightmareGanonFaceLink::
;> side, _ = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;> wNightmareFacing = side
	ld a, e
	ld [wNightmareFacing], a
	ret


;@ def NightmareGanonWaitDone()
;@ path: boss/final_nightmare/ganon
;@ The return of NightmareGanonWait while its timer runs.
;@ test: skip only returns
NightmareGanonWaitDone::
;> return
	ret


;@ path: boss/final_nightmare/ganon
;@ Ganon's frame while he raises the trident, by timer / 4 (32 entries; the timer counts down
;@ from $7F, so read backwards): 0 (arms down) for the first half, then 4 (arms raised).
GanonRaiseFrames::
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;@ path: boss/final_nightmare/ganon
;@ wNightmareTridentFrame while he raises the trident, by timer / 4 (32 entries, read
;@ backwards): none for a while, then frames 7, 6, 1 as the trident appears and swings up, then
;@ 4 (held up) for the second half.
GanonRaiseTridentFrames::
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $02, $07, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ def NightmareGanonRaiseTrident(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 3: facing right, Ganon's shadow raises its trident (GanonRaiseFrames,
;@ GanonRaiseTridentFrames; the trident sits higher while held up), with a noise at timer $58
;@ (jingle $39) and $40 (noise $19). When the timer runs out it turns to Link and sends out fire
;@ bats (state 4, drop timer $4C).
;@ test: skip calls routines in other banks
NightmareGanonRaiseTrident::
;> wNightmareFacing = 0
	ld a, $00
	ld [wNightmareFacing], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .raise
;>     wEntityDropTimer[slot] = 0x4C          # (the bat timer)
	call GetEntityDropTimer
	ld [hl], $4c
;>     NightmareGanonFaceLink(slot)
	call NightmareGanonFaceLink
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.raise
;> if t == 0x40: hNoiseSfx = 0x19
	cp $40
	jr nz, .jingle
	ld hl, hNoiseSfx
	ld [hl], $19

.jingle
;> if t == 0x58: hJingle = 0x39
	cp $58
	jr nz, .frame
	ld hl, hJingle
	ld [hl], $39

.frame
;> i = (t >> 2) & 0x3F
	rra
	rra
	and $3f
	ld e, a
	ld d, b
;> wNightmareTridentFrame = mem[GanonRaiseTridentFrames + i]
	ld hl, GanonRaiseTridentFrames
	add hl, de
	ld a, [hl]
	ld [wNightmareTridentFrame], a
;> SetEntitySpriteVariant(mem[GanonRaiseFrames + i])
	ld hl, GanonRaiseFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> if wNightmareTridentFrame != 5:
	ld a, [wNightmareTridentFrame]
	cp $05
	jr z, .held
;>     wNightmareTridentX = -13
	ld a, $f3
	ld [wNightmareTridentX], a
;>     wNightmareTridentY = -16
	ld a, $f0
	ld [wNightmareTridentY], a
;>     return
	ret

.held
;> else:
;>     wNightmareTridentX = -8                # held up
	ld a, $f8
	ld [wNightmareTridentX], a
;>     wNightmareTridentY = -2
	ld a, $fe
	ld [wNightmareTridentY], a
	ret


;@ path: boss/final_nightmare/ganon
;@ wNightmareTridentFrame - 1 of the trident spinning in Ganon's hand when he faces right, by
;@ frame counter / 8: 3, 2, 1, 0.
GanonSpinFramesRight::
	db $03, $02, $01, $00

;@ path: boss/final_nightmare/ganon
;@ The same when he faces left: 0, 1, 2, 3.
GanonSpinFramesLeft::
	db $00, $01, $02, $03

;@ path: boss/final_nightmare/ganon
;@ Y offsets (signed, then 12 pixels higher) of the six fire bats around Ganon, by bat number
;@ (8 entries; facing right the order is reversed): -$18, 0, $18, $18, 0, -$18, -$18, 0.
GanonBatOffsetY::
	db $e8, $00, $18, $18, $00, $e8, $e8, $00
;@ path: boss/final_nightmare/ganon
;@ The matching x offsets (signed, added to the trident's x offset): $10, $18, $10, -$10, -$18,
;@ -$10, $10, $18.
GanonBatOffsetX::
	db $10, $18, $10, $f0, $e8, $f0, $10, $18

;@ def NightmareGanonSpawnBats(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 4: spins the trident in its hand (two-frame body animation) and every 32 frames sends
;@ out one of six fire bats (entity $E6 with wEntityPrivate1 = 2, timer $30) in a ring around
;@ itself, counted in $D221. When the drop timer runs out it twirls the trident (state 5, timer
;@ $30).
;@ test: skip calls routines in other banks
NightmareGanonSpawnBats::
;> if wEntityDropTimer[slot] == 0:
	call GetEntityDropTimer
	jr nz, .spin
;>     mem[0xD221] = 0                        # bats sent out
	ld [$d221], a
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.spin
;>@sx wNightmareTridentX = -11 if wNightmareFacing == 0 else 11
	ld a, [wNightmareFacing]
	and a
	ld a, $f5
	jr z, .setX
	ld a, $0b

.setX
;=@sx
	ld [wNightmareTridentX], a
;> wNightmareTridentY = -18
	ld a, $ee
	ld [wNightmareTridentY], a
;>@va SetEntitySpriteVariant((hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	and $01
;=@va
	call SetEntitySpriteVariant
;> spin = GanonSpinFramesRight if wNightmareFacing == 0 else GanonSpinFramesLeft
	ld a, [wNightmareFacing]
	and a
	ld hl, GanonSpinFramesRight
	jr z, .spinFrame
	ld hl, GanonSpinFramesLeft

.spinFrame
;>@tf wNightmareTridentFrame = mem[spin + ((hFrameCounter >> 3) & 3)] + 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	nop
;=@tf
	and $03
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	inc a
;=@tf
	ld [wNightmareTridentFrame], a
;> if hFrameCounter & 0x1F: return
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .done
;> if mem[0xD221] >= 6: return               # all six are out
	ld a, [$d221]
	cp $06
	jr nc, .done
;> full, bat = SpawnEntity(0xE6)
	ld a, $e6
	call SpawnEntity
;> if full: return
	ret c
;> wEntityTimer[bat] = 0x30
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $30
;> wEntityPrivate1[bat] = 2                   # a fire bat
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;> wEntityPhysicsFlags[bat] = 0x42
	push bc
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42
;> wEntityHitboxFlags[bat] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
;> LoadEntityHitbox(bat)
	push de
	push de
	pop bc
	call LoadEntityHitbox
	pop de
;> n = mem[0xD221] if wNightmareFacing else mem[0xD221] ^ 7
	ld a, [wNightmareFacing]
	and a
	ld a, [$d221]
	jr nz, .place
	xor $07

.place
;>@bx wEntityX[bat] = u8(wNightmareTridentX + mem[GanonBatOffsetX + n] + hMultiPurpose0)
	ld c, a
	ld hl, GanonBatOffsetX
	add hl, bc
	ld a, [wNightmareTridentX]
	add [hl]
	ld hl, hMultiPurpose0
;=@bx
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@by wEntityY[bat] = u8(mem[GanonBatOffsetY + n] - 12 + hMultiPurpose1)
	ld hl, GanonBatOffsetY
	add hl, bc
	ld a, [hl]
	sub $0c
	ld hl, hMultiPurpose1
	add [hl]
;=@by
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> mem[0xD221] += 1
	ld hl, $d221
	inc [hl]
	pop bc

.done
	ret


;@ path: boss/final_nightmare/ganon
;@ wNightmareTridentFrame - 1 of the trident twirling over Ganon's head before the throw, by
;@ frame counter / 8: $0B, $0A, 2, $0A.
GanonTwirlFrames::
	db $0b, $0a, $02, $0a

;@ def NightmareGanonThrowTrident(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 5: twirls the trident over its head (GanonTwirlFrames); when the timer runs out it
;@ throws it (entity $E6 with wEntityPrivate1 = 1, 8 pixels to the side it faces and 16 higher,
;@ speed $18 towards Link, timer $30, noise $27) and pauses (state 6, timer $40). Its frame is 2
;@ throughout.
;@ test: skip calls routines in other banks
NightmareGanonThrowTrident::
;>@sx wNightmareTridentX = -3 if wNightmareFacing == 0 else 3
	ld a, [wNightmareFacing]
	and a
	ld a, $fd
	jr z, .setX
	ld a, $03

.setX
;=@sx
	ld [wNightmareTridentX], a
;> wNightmareTridentY = -20
	ld a, $ec
	ld [wNightmareTridentY], a
;>@tw wNightmareTridentFrame = mem[GanonTwirlFrames + ((hFrameCounter >> 3) & 3)] + 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	nop
;=@tw
	and $03
	ld e, a
	ld d, b
	ld hl, GanonTwirlFrames
	add hl, de
	ld a, [hl]
;=@tw
	inc a
	ld [wNightmareTridentFrame], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wNightmareTridentFrame = 0             # it leaves his hand
	xor a
	ld [wNightmareTridentFrame], a
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     full, trident = SpawnEntity(0xE6)
	ld a, $e6
	call SpawnEntity
;>     if not full:
	jr c, .frame
;>         wEntityPrivate1[trident] += 1      # the trident
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>         wEntityY[trident] = u8(hMultiPurpose1 - 16)
	ldh a, [hMultiPurpose1]
	sub $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityDirection[trident] = wNightmareFacing
	ld a, [wNightmareFacing]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;>         dx = 8 if wNightmareFacing else -8
	and a
	ld a, $08
	jr nz, .placeX
	ld a, $f8

.placeX
;>         wEntityX[trident] = u8(hMultiPurpose0 + dx)
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityPhysicsFlags[trident] = 0x40
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $40
;>         wEntityHitboxFlags[trident] = 0x08
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $08
;>         LoadEntityHitbox(trident)
	push bc
	push de
	pop bc
	call LoadEntityHitbox
;>         SetEntitySpeedTowardsLink(trident, 0x18)
	ld a, $18
	call SetEntitySpeedTowardsLink
;>         wEntityTimer[trident] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         hNoiseSfx = 0x27
	ld a, $27
	ldh [hNoiseSfx], a
	pop bc

.frame
;> SetEntitySpriteVariant(2)
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ def NightmareGanonAfterThrow(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 6: holds frame 3 until the timer runs out, then picks one of 8 spots at random
;@ (wEntityPrivate2), plays the boss jingle and glides there (state 7, timer $1F).
;@ test: skip calls routines in other banks
NightmareGanonAfterThrow::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame
;>     wEntityTimer[slot] = 0x1F
	ld [hl], $1f
;>     wEntityPrivate2[slot] = GetRandomByte() & 7   # the spot
	call GetRandomByte
	and $07
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;>     PlayNightmareJingle()
	call PlayNightmareJingle
;>     IncrementEntityState(slot)
	call IncrementEntityState

.frame
;> SetEntitySpriteVariant(3)
	ld a, $03
	call SetEntitySpriteVariant
	ret


;@ path: boss/final_nightmare/ganon
;@ The 8 spots Ganon's shadow glides to after a throw (picked at random): x positions $28,
;@ $50, $78, $28, $78, $28, $50, $78.
GanonSpotX::
	db $28, $50, $78, $28, $78, $28, $50, $78

;@ path: boss/final_nightmare/ganon
;@ The matching y positions: $20, $28, $20, $30, $30, $50, $50, $50.
GanonSpotY::
	db $20, $28, $20, $30, $30, $50, $50, $50
;@ path: boss/final_nightmare/ganon
;@ Glide speed by timer / 2 (16 entries; the timer counts down from $1F, so read backwards: it
;@ starts at 2 and speeds up to $20): $20, $1E, ... $04, $02.
GanonGlideSpeeds::
	db $20, $1e, $1c, $1a, $18, $16, $14, $12, $10, $0e, $0c, $0a, $08, $06, $04, $02

;@ def NightmareGanonGlide(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 7: glides (frame 4) to the spot picked in wEntityPrivate2, faster and faster
;@ (GanonGlideSpeeds); within 3 pixels of it it waits for the trident (state 8).
;@ test: skip calls routines in other banks
NightmareGanonGlide::
;> SetEntitySpriteVariant(4)
	ld a, $04
	call SetEntitySpriteVariant
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> spot = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
;> hLinkX = mem[GanonSpotX + spot]            # aim at the spot instead of Link
	ld hl, GanonSpotX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;> hLinkY = mem[GanonSpotY + spot]
	ld hl, GanonSpotY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;>@sp SetEntitySpeedTowardsLink(mem[GanonGlideSpeeds + ((t >> 1) & 0x0F)])
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, GanonGlideSpeeds
	add hl, de
;=@sp
	ld a, [hl]
	call SetEntitySpeedTowardsLink
;>@ar if abs(hLinkX - hActiveEntityX) <= 2 and abs(hLinkY - hActiveEntityDrawY) <= 2:
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;=@ar
	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;>     IncrementEntityState(slot)
	call IncrementEntityState

.move
;> hLinkY = link_y
	pop af
	ldh [hLinkY], a
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
	ret


;@ def NightmareGanonWaitTrident(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 8: does nothing until the trident comes back to it (GanonTrident sets state 3).
;@ test: skip only returns
NightmareGanonWaitTrident::
;> return
	ret


;@ def NightmareGanonDefeated(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 9 (after 24 points of damage, timer $80, flashing): when the timer runs out it bursts
;@ into pieces, drops the trident and turns into a blob (state 10, timer $40).
;@ test: skip calls routines in other banks
NightmareGanonDefeated::
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, .done
;> wEntityTimer[slot] = 0x40
	ld [hl], $40
;> NightmareBurstIntoPieces(slot)
	call NightmareBurstIntoPieces
;> IncrementEntityState(slot)
	call IncrementEntityState
;> SetEntitySpriteVariant(0)
	ld a, $00
	call SetEntitySpriteVariant
;> wNightmareTridentFrame = 0
	xor a
	ld [wNightmareTridentFrame], a

.done
	ret


;@ def NightmareGanonBecomeBlob(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 10: shows the blob (gel frame 6) until the timer runs out, then clears physics flag
;@ bit 6, stops and starts chasing Link (state 11).
;@ test: skip calls routines in other banks
NightmareGanonBecomeBlob::
;> hActiveEntitySpriteVariant = 6
	ld a, $06
	ldh [hActiveEntitySpriteVariant], a
;> DrawNightmareGel(slot)
	call DrawNightmareGel
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	jr nz, .done
;> wEntityPhysicsFlags[slot] &= ~0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 6, [hl]
;> IncrementEntityState(slot)
	call IncrementEntityState
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed

.done
	ret


;@ def NightmareGanonBlob(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 11: the blob chases Link, steering its speed by 1 every other frame towards a speed of
;@ $18 aimed at him, and leaves a trail (entity $E6 with wEntityPrivate1 = 3) every 8 frames.
;@ Once a weapon hits it (it flashes) it splits into gel pieces, the music stops (wave sound
;@ $10), and it glides away (state 12, timer $80).
;@ test: skip calls routines in other banks
NightmareGanonBlob::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .hit
;>     GetVectorTowardsLink(0x18)             # into hMultiPurpose0 (y), hMultiPurpose1 (x)
	ld a, $18
	call GetVectorTowardsLink
;>@sy     wEntitySpeedY[slot] += -1 if hMultiPurpose0 - wEntitySpeedY[slot] < 0 else 1
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	sub [hl]
	bit 7, a
	jr z, .incY
	dec [hl]
;=@sy
	dec [hl]

.incY
;=@sy
	inc [hl]
;>@sx     wEntitySpeedX[slot] += -1 if hMultiPurpose1 - wEntitySpeedX[slot] < 0 else 1
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	sub [hl]
	bit 7, a
	jr z, .incX
	dec [hl]
;=@sx
	dec [hl]

.incX
;=@sx
	inc [hl]

.hit
;> if wEntityFlashTimer[slot]:                # hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .trail
;>     wEntityPhysicsFlags[slot] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     ResetSoundEngine()
	call ResetSoundEngine
;>     hWaveSfx = 0x10
	ld a, $10
	ldh [hWaveSfx], a
;>     SpawnNightmareGelPieces(slot)
	call SpawnNightmareGelPieces
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.trail
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] & 7: return
	and $07
	ret nz
;> full, trail = SpawnEntity(0xE6)
	ld a, $e6
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
;> wEntityPrivate1[trail] = 3                 # a trail blob
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
;> wEntityTimer[trail] = 0x1F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $1f
;> wEntityPhysicsFlags[trail] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;> wEntitySpriteVariant[trail] = 1
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $01
	ret


;@ def NightmareGanonLeave(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 12: after the timer (the boss jingle plays at its end) the blob glides at speed $0C to
;@ the top of the room (X $50, Y $30); there it shrinks (state 13, timer $5F).
;@ test: skip calls routines in other banks
NightmareGanonLeave::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 1:
	cp $01
	jr nz, .wait
;>     wEntityTimer[slot] = 0
	dec [hl]
;>     return PlayNightmareJingle()
	jp PlayNightmareJingle

.wait
;> if t: return
	and a
	ret nz
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkX = 0x50                              # aim at the spot instead of Link
	ld a, $50
	ldh [hLinkX], a
;> hLinkY = 0x30
	ld a, $30
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x0C)
	ld a, $0c
	call SetEntitySpeedTowardsLink
;>@ar if abs(hActiveEntityDrawY - 0x30) <= 2 and abs(hActiveEntityX - 0x50) <= 2:
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;=@ar
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, .move
;>     wEntityTimer[slot] = 0x5F
	call GetEntityTimer
	ld [hl], $5f
;>     IncrementEntityState(slot)
	call IncrementEntityState

.move
;> hLinkY = link_y
	pop af
	ldh [hLinkY], a
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
	ret


;@ path: boss/final_nightmare/ganon
;@ Gel frame of the shrinking blob by timer / 4 (the timer is held at $1F until it gets there,
;@ so read backwards): 2, 2, 1, 1, 1, 0, 0, 0.
GanonShrinkFrames::
	db $00, $00, $00, $01, $01, $01, $02, $02

;@ def NightmareGanonShrink(slot: c)
;@ path: boss/final_nightmare/ganon
;@ State 13: the blob shrinks (GanonShrinkFrames); when the timer runs out the last form begins:
;@ it stops, gets full health $FF, physics flags 0, options $C0, drop timer $90 and timer2 $3F,
;@ and $D223 is cleared.
;@ test: skip calls routines in other banks
NightmareGanonShrink::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shrink
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     NightmareNextForm(slot)
	call NightmareNextForm
;>     wEntityHealth[slot] = 0xFF
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
;>     wEntityPhysicsFlags[slot] = 0
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $00
;>     wEntityOptions1[slot] = 0xC0
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $c0
;>     wEntityDropTimer[slot] = 0x90
	call GetEntityDropTimer
	ld [hl], $90
;>     mem[0xD223] = 0
	xor a
	ld [$d223], a
;>     wEntityTimer2[slot] = 0x3F
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $3f
;>     return
	ret

.shrink
;> if t >= 0x20: t = 0x1F
	cp $20
	jr c, .frame
	ld a, $1f

.frame
;>@fr hActiveEntitySpriteVariant = mem[GanonShrinkFrames + ((t >> 2) & 7)]
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, GanonShrinkFrames
;=@fr
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> DrawNightmareGel(slot)
	call DrawNightmareGel
	ret


;@ def DrawNightmareGanon(slot: c)
;@ path: boss/final_nightmare/ganon
;@ Draws Ganon's shadow (states below 10, unless hidden by variant $FF): head and body, arms,
;@ then the trident. Facing left (wNightmareFacing = 1) uses variants 5-9 instead of 0-4.
;@ test: skip calls routines in other banks
DrawNightmareGanon::
;> if hActiveEntityState >= 10: return
	ldh a, [hActiveEntityState]
	cp $0a
	ret nc
;> if hActiveEntitySpriteVariant == 0xFF: return
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	ret z
;>@g1 if wNightmareFacing: hActiveEntitySpriteVariant += 5
	ld a, [wNightmareFacing]
	and a
	ldh a, [hActiveEntitySpriteVariant]
	jr z, .draw
	add $05

.draw
;=@g1
	ldh [hActiveEntitySpriteVariant], a
;> DrawGanonHead(slot)
	call DrawGanonHead
;> DrawGanonArms(slot)
	call DrawGanonArms
;> DrawGanonTrident(slot)
	call DrawGanonTrident
	ret


;@ path: boss/final_nightmare/ganon
;@ Ganon's head and body for RenderActiveEntitySpritesRect: 4 frames of 32 bytes, each 7 OAM
;@ entries of 4 bytes (y offset, x offset, tile, attributes) and 4 unused bytes: the head
;@ ($50, $52, $6E) over the body ($6A, $6C and their mirror images); frame 1 has the head 3
;@ pixels lower and 2 to the right, frames 2-3 are frames 0-1 with the head mirrored.
GanonHeadSprites::
	db $f8, $fc, $50, $00, $f8, $04, $52, $00, $f8, $0c, $6e, $00, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $fb, $fe, $50, $00, $fb, $06, $52, $00, $fb, $0e, $6e, $00, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $f8, $fc, $6e, $20, $f8, $04, $52, $20, $f8, $0c, $50, $20, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $fb, $fa, $6e, $20, $fb, $02, $52, $20, $fb, $0a, $50, $20, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
;@ path: boss/final_nightmare/ganon
;@ Head frame (GanonHeadSprites) by sprite variant (10 entries; 0-4 facing right, 5-9 facing
;@ left): 0, 0, 2, 1, 0, 2, 2, 0, 3, 2.
GanonHeadFrames::
	db $00, $00, $02, $01, $00, $02, $02, $00, $03, $02

;@ def DrawGanonHead(slot: c)
;@ path: boss/final_nightmare/ganon
;@ Draws the head and body of Ganon's shadow (7 sprites of the frame GanonHeadFrames gives for
;@ the sprite variant).
;@ test: skip calls routines in other banks
DrawGanonHead::
;>@hf frame = mem[GanonHeadFrames + hActiveEntitySpriteVariant]
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, GanonHeadFrames
	add hl, de
	ld a, [hl]
;>@of offset = (frame << 5) & 0x70
	rla
	rla
	rla
	rla
	rla
	and $70
;=@of
	ld e, a
;> DrawEntitySprites(GanonHeadSprites + offset, 7)
	ld hl, GanonHeadSprites
	add hl, de
	ld c, $07
	call DrawEntitySprites
;> ReserveOAMEntriesFar(7)
	ld a, $07
	call ReserveOAMEntriesFar
	ret


;@ path: boss/final_nightmare/ganon
;@ Ganon's arms for RenderActiveEntitySpritesRect, by sprite variant: 10 records of 12 bytes,
;@ each 3 OAM entries of 4 bytes (y offset, x offset, tile, attributes; tile $FF = nothing).
;@ Variants 0-4 face right (0-1 arms out with fists $60/$62 and hand $64, 2 arm raised, 3 both
;@ arms low $66, 4 hand up), 5-9 the same mirrored for facing left.
GanonArmSprites::
	db $f4, $f8, $64, $00, $fe, $11, $60, $00, $fe, $19, $62, $00, $f4, $f9, $64, $00
	db $fe, $11, $60, $00, $fe, $19, $62, $00, $f0, $00, $64, $20, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $10, $60, $00, $fb, $18, $62, $00
	db $00, $f8, $66, $00, $fe, $10, $66, $20, $ff, $ff, $ff, $ff, $f4, $10, $64, $20
	db $fe, $ef, $62, $20, $fe, $f7, $60, $20, $f4, $0f, $64, $20, $fe, $ef, $62, $20
	db $fe, $f7, $60, $20, $f0, $08, $64, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $fb, $f0, $62, $20, $fb, $f8, $60, $20, $fe, $f8, $66, $00
	db $00, $10, $66, $20, $ff, $ff, $ff, $ff

;@ def DrawGanonArms(slot: c)
;@ path: boss/final_nightmare/ganon
;@ Draws the arms of Ganon's shadow (3 sprites of GanonArmSprites for the sprite variant).
;@ test: skip calls routines in other banks
DrawGanonArms::
;>@of offset = hActiveEntitySpriteVariant * 12
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
;=@of
	and $f8
	add e
	ld e, a
	ld d, b
;> DrawEntitySprites(GanonArmSprites + offset, 3)
	ld hl, GanonArmSprites
	add hl, de
	ld c, $03
	call DrawEntitySprites
;> ReserveOAMEntriesFar(3)
	ld a, $03
	call ReserveOAMEntriesFar
	ret


;@ path: boss/final_nightmare/ganon
;@ The trident for RenderActiveEntitySpritesRect: 12 frames of 32 bytes, each up to 8 OAM
;@ entries of 4 bytes (y offset, x offset, tile, attributes; GanonTridentSpriteCounts says how
;@ many are drawn). Frame 0 upright (prongs $70, shaft $7C), 1 and 3 diagonal (head $7E, shaft
;@ $76/$78), 2 level ($72, $74, $7A), 4-11 the spinning trident at four angles, each in a far
;@ and a near version (shaft $76/$78 or $72/$74).
GanonTridentSprites::
	db $ec, $00, $70, $00, $ec, $08, $70, $20, $f4, $00, $7c, $00, $f4, $08, $7c, $20
	db $08, $00, $7c, $40, $08, $08, $7c, $60, $14, $00, $70, $40, $14, $08, $70, $60
	db $00, $00, $7e, $40, $00, $08, $7e, $20, $f3, $0d, $78, $20, $f3, $15, $76, $20
	db $0d, $f3, $76, $40, $0d, $fb, $78, $40, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $ec, $72, $00, $00, $f4, $74, $00, $00, $fc, $7a, $00, $00, $0c, $7a, $00
	db $00, $14, $74, $20, $00, $1c, $72, $20, $00, $00, $ff, $ff, $00, $00, $ff, $ff
	db $00, $00, $7e, $00, $00, $08, $7e, $60, $f3, $f3, $76, $00, $f3, $fb, $78, $00
	db $0d, $0d, $78, $60, $0d, $15, $76, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f1, $0f, $78, $20, $f1, $17, $76, $20, $0d, $f3, $76, $40, $0d, $fb, $78, $40
	db $00, $00, $ff, $ff, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f1, $f1, $76, $00, $f1, $f9, $78, $00, $0d, $0d, $78, $60, $0d, $15, $76, $60
	db $00, $00, $ff, $ff, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $08, $78, $20, $f8, $10, $76, $20, $08, $f8, $76, $40, $08, $00, $78, $40
	db $00, $00, $ff, $40, $00, $08, $ff, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fc, $04, $78, $20, $fc, $0c, $76, $20, $04, $fc, $76, $40, $04, $04, $78, $40
	db $00, $00, $ff, $40, $00, $08, $ff, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $f8, $76, $00, $f8, $00, $78, $00, $08, $08, $78, $60, $08, $10, $76, $60
	db $00, $00, $ff, $00, $00, $08, $ff, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fc, $fc, $76, $00, $fc, $04, $78, $00, $04, $04, $78, $60, $04, $0c, $76, $60
	db $00, $00, $ff, $00, $00, $08, $ff, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $f8, $72, $00, $00, $00, $74, $00, $00, $08, $74, $20, $00, $10, $72, $20
	db $00, $08, $ff, $ff, $00, $10, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff
	db $00, $fb, $72, $00, $00, $03, $74, $00, $00, $05, $74, $20, $00, $0d, $72, $20
	db $00, $fc, $ff, $ff, $00, $0c, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff
;@ path: boss/final_nightmare/ganon
;@ Number of OAM entries drawn for each trident frame (12 entries): 8, 6, 6, 6, then 4.
GanonTridentSpriteCounts::
	db $08, $06, $06, $06, $04, $04, $04, $04, $04, $04, $04, $04

;@ def DrawGanonTrident(slot: c)
;@ path: boss/final_nightmare/ganon
;@ If wNightmareTridentFrame is set, draws that trident frame offset by (wNightmareTridentX,
;@ wNightmareTridentY) from the entity, reserves its OAM entries and restores the draw
;@ position. The thrown trident uses it too, with no offset.
;@ test: skip calls routines in other banks
DrawGanonTrident::
;> if not wNightmareTridentFrame: return
	ld a, [wNightmareTridentFrame]
	and a
	ret z
;> hActiveEntityX = u8(hActiveEntityX + wNightmareTridentX)
	ld a, [wNightmareTridentX]
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + wNightmareTridentY)
	ld a, [wNightmareTridentY]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;> frame = wNightmareTridentFrame - 1
	ld a, [wNightmareTridentFrame]
	dec a
	ld e, a
	ld d, b
;> count = mem[GanonTridentSpriteCounts + frame]
	ld hl, GanonTridentSpriteCounts
	add hl, de
	ld c, [hl]
;>@of offset = frame * 32
	ld d, b
	sla e
	rl d
	sla e
	rl d
	sla e
;=@of
	rl d
	sla e
	rl d
	sla e
	rl d
	ld a, e
;=@of
	and $e0
	ld e, a
;> DrawEntitySprites(GanonTridentSprites + offset, count)
	ld hl, GanonTridentSprites
	add hl, de
	push bc
	call DrawEntitySprites
;> ReserveOAMEntriesFar(count)
	pop de
	ld a, e
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)
	call LoadEntityPosition
	ret


GanonTridentSpinRight::
	db $03, $02, $01, $00

GanonTridentSpinLeft::
	db $00, $01, $02, $03

GanonTrident::
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $09
	jp nc, ClearEntityStatus_15

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld hl, $6c76
	jr z, jr_015_6ca7

	ld hl, $6c7a

jr_015_6ca7:
	add hl, de
	ld a, [hl]
	inc a
	ld [wNightmareTridentFrame], a
	xor a
	ld [wNightmareTridentX], a
	ld [wNightmareTridentY], a
	call DrawGanonTrident
	xor a
	ld [wNightmareTridentFrame], a
	call ReturnIfNonInteractive_15
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_015_6cc8

	ld a, $3a
	ldh [hNoiseSfx], a

jr_015_6cc8:
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	call UpdateEntityPosWithSpeed_15
	call EntityCheckContactDamage
	call GetEntityTimer
	jr z, jr_015_6cd9

	ret


jr_015_6cd9:
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	sub $0c
	ldh [hLinkY], a
	ld a, $10
	call GetVectorTowardsLink
	ld hl, wEntitySpeedY
	add hl, bc
	ldh a, [hMultiPurpose0]
	sub [hl]
	and $80
	jr nz, jr_015_6d06

	inc [hl]
	inc [hl]

jr_015_6d06:
	dec [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ldh a, [hMultiPurpose1]
	sub [hl]
	and $80
	jr nz, jr_015_6d14

	inc [hl]
	inc [hl]

jr_015_6d14:
	dec [hl]
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6d46

	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6d46

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_6d46

	ld [hl], $03
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $4c
	call ClearEntityStatus_15

jr_015_6d46:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	ret


GanonTrailSprites::
	db $4a, $00, $4a, $20, $4c, $00, $4c, $20, $4e, $00, $4e, $20

GanonTrailFrames::
	db $00, $00, $01, $01

GanonBlobTrail::
	ld de, $6d4d
	call DrawEntity16x16
	call ReturnIfNonInteractive_15
	call GetEntityTimer
	jp z, ClearEntityStatus_15

	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $6d59
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


GanonBatSprites::
	db $1e, $00, $1e, $60, $34, $00, $34, $20, $54, $00, $54, $20, $56, $00, $56, $20

GanonBat::
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
	ld de, $6d7c
	call DrawEntity16x16
	call ReturnIfNonInteractive_15
	ldh a, [hActiveEntityState]
	rst $00

GanonBatStates::
	dw GanonBatSpark
	dw GanonBatFly

GanonBatSpark::
	call GetEntityTimer
	jr nz, jr_015_6dae

	ld [hl], $20
	jp IncrementEntityState


jr_015_6dae:
	ld e, $00
	cp $18
	jr nc, jr_015_6db6

	ld e, $01

jr_015_6db6:
	ld a, e
	call SetEntitySpriteVariant
	ret


GanonBatFly::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
	call SetEntitySpriteVariant
	call GetEntityTimer
	cp $01
	jr nz, jr_015_6dd7

	ld a, $28
	ldh [hNoiseSfx], a
	ld a, $30
	call SetEntitySpeedTowardsLink

jr_015_6dd7:
	ldh a, [hFrameCounter]
	xor c
	rra
	jr nc, jr_015_6de3

	call UpdateEntityPosWithSpeed_15
	call EntityCheckContactDamage

jr_015_6de3:
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_15

	ldh a, [hActiveEntityDrawY]
	cp $88
	jp nc, ClearEntityStatus_15

	ret


	db $01, $02, $03, $03, $03, $03, $02, $01, $20, $23, $26, $29, $2c, $2f, $32, $35
	db $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38
	db $20, $23, $26, $29, $2c, $2f, $32, $34, $34, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $34, $34, $34, $34, $28, $27, $26, $25, $24, $23, $22, $21
	db $20, $1f, $1e, $1d, $1c, $1b, $1a, $19, $18, $18, $18, $18, $18, $18, $18, $18
	db $03, $02, $01, $00, $00, $00, $00, $00

Jump_15_6E4A::
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_6e6e

	cp $10
	jr nz, jr_015_6e5c

	dec [hl]
	call PlayNightmareFormSfx
	ld a, $10

jr_015_6e5c:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6e42
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	call DrawNightmareGel
	ret


jr_015_6e6e:
	call Call_15_7070
	call ReturnIfNonInteractive_15
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_6E77::
	dw Jump_15_6E7D
	dw Jump_15_6FB9
	dw Jump_15_6FD6

Jump_15_6E7D::
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nc, jr_015_6eb3

	ld a, $03
	ld [wDelayedWaveSfxTimer], a
	ld a, $f6
	call OpenDialog
	ld a, $5e
	ld [wMusicTrackToPlay], a
	call GetEntityTimer
	ld [hl], $80
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $80
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
	call ResetSoundEngine
	call IncrementEntityState
	ret


jr_015_6eb3:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_015_6ecd

	ld a, [$d223]
	cp $04
	jr nc, jr_015_6ecd

	inc a
	ld [$d223], a
	cp $01
	jr nz, jr_015_6ecd

	ld hl, wMusicTrackToPlay
	ld [hl], $50

jr_015_6ecd:
	call DecrementEntityIgnoreHitsTimer
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cpl
	cp $17
	jr c, jr_015_6edc

	ld a, $17

jr_015_6edc:
	ld e, a
	ld d, b
	ld hl, $6dfa
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ld hl, $6e12
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	ld hl, $6e2a
	add hl, de
	ld a, [wSongShowTimer]
	inc a
	cp [hl]
	jr c, jr_015_6f02

	ld a, $3d
	ldh [hJingle], a
	xor a

jr_015_6f02:
	ld [wSongShowTimer], a
	ld a, $00
	call SetEntitySpriteVariant
	call GetEntityDropTimer
	jr nz, jr_015_6f23

	call GetRandomByte
	and $0f
	add $20
	ld [hl], a
	call GetRandomByte
	and $01
	jr nz, jr_015_6f23

	call GetEntityTimer1
	ld [hl], $7f

jr_015_6f23:
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
	call GetEntityTimer1
	jr z, jr_015_6f48

	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6df2
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	cp $03
	jr nz, jr_015_6f48

	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]

jr_015_6f48:
	call EntityCheckHits
	ld e, $0f
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $f8
	jr nc, jr_015_6f58

	ld e, $07

jr_015_6f58:
	ldh a, [hFrameCounter]
	and e
	jr nz, jr_015_6f88

	ldh a, [hLinkY]
	push af
	sub $20
	ldh [hLinkY], a
	ld a, $08
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_015_6f76

	inc [hl]
	inc [hl]

jr_015_6f76:
	dec [hl]
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_015_6f84

	inc [hl]
	inc [hl]

jr_015_6f84:
	dec [hl]
	pop af
	ldh [hLinkY], a

jr_015_6f88:
	call UpdateEntityPosWithSpeed_15
	call EntityCheckWalls
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_015_6fa3

	ld a, [$d221]
	inc a
	ld [$d221], a

jr_015_6fa3:
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_015_6fb8

	ld a, [$d222]
	dec a
	ld [$d222], a

jr_015_6fb8:
	ret


Jump_15_6FB9::
	call GetEntityTimer
	cp $02
	jr nz, jr_015_6fc5

	ld hl, wMusicTrackToPlay
	ld [hl], $5f

jr_015_6fc5:
	and a
	jr nz, jr_015_6fd5

	ld [hl], $80
	ld a, $3d
	ldh [hNoiseSfx], a
	ld a, $10
	ldh [hWaveSfx], a
	call IncrementEntityState

jr_015_6fd5:
	ret


Jump_15_6FD6::
	call GetEntityTimer
	and $0f
	jr nz, jr_015_700f

	ld a, [$d223]
	cp $00
	jr nz, jr_015_700b

	call PlayClinkNoise
	call SpawnNightmareGelPieces
	call ClearEntityStatus_15
	ld a, $e6
	call SpawnEntity
	ld hl, wEntityPrivate5
	add hl, de
	ld [hl], $02
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $ff
	ret


jr_015_700b:
	dec a
	ld [$d223], a

jr_015_700f:
	ret


	db $f0, $fc, $60, $00, $f0, $04, $62, $00, $f0, $0c, $60, $20, $f0, $fc, $64, $00
	db $f0, $04, $66, $00, $f0, $0c, $64, $20, $f0, $fc, $68, $00, $f0, $04, $6a, $00
	db $f0, $0c, $68, $20, $f0, $fc, $64, $00, $f0, $04, $66, $00, $f0, $0c, $64, $20
	db $00, $fc, $6c, $00, $00, $04, $6e, $00, $00, $0c, $6c, $20, $00, $fc, $70, $00
	db $00, $04, $72, $00, $00, $0c, $70, $20, $00, $fc, $74, $00, $00, $04, $76, $00
	db $00, $0c, $74, $20, $00, $fc, $78, $00, $00, $04, $7a, $00, $00, $0c, $78, $20

Call_15_7070::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $7010
	add hl, de
	ld c, $03
	call DrawEntitySprites
	ld a, $03
	call ReserveOAMEntriesFar
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $7040
	add hl, de
	ld c, $03
	call DrawEntitySprites
	ld a, $03
	call ReserveOAMEntriesFar
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push af
	push hl
	sub $08
	ld [hl], a
	call LoadEntityPosition
	call Call_15_7196
	pop hl
	pop af
	ld [hl], a
	call LoadEntityPosition
	ret


	db $d0, $d1, $d4, $d9, $df, $e6, $ee, $f7, $00, $09, $12, $1a, $21, $27, $2c, $2f
	db $30, $2f, $2c, $27, $21, $1a, $12, $09, $00, $f7, $ee, $e6, $df, $d9, $d4, $d1
	db $d0, $d1, $d4, $d9, $df, $e6, $ee, $f7, $da, $db, $dd, $e1, $e6, $eb, $f2, $f9
	db $00, $07, $0e, $15, $1a, $1f, $23, $25, $26, $25, $23, $1f, $1a, $15, $0e, $07
	db $00, $f9, $f2, $eb, $e6, $e1, $dd, $db, $da, $db, $dd, $e1, $e6, $eb, $f2, $f9
	db $e4, $e5, $e7, $e9, $ed, $f1, $f6, $fb, $00, $05, $0a, $0f, $13, $17, $19, $1b
	db $1c, $1b, $19, $17, $13, $0f, $0a, $05, $00, $fb, $f6, $f1, $ed, $e9, $e7, $e5
	db $e4, $e5, $e7, $e9, $ed, $f1, $f6, $fb, $ee, $ef, $f0, $f2, $f4, $f6, $fa, $fd
	db $00, $03, $06, $0a, $0c, $0e, $10, $11, $12, $11, $10, $0e, $0c, $0a, $06, $03
	db $00, $fd, $fa, $f6, $f4, $f2, $f0, $ef, $ee, $ef, $f0, $f2, $f4, $f6, $fa, $fd
	db $f8, $f9, $fa, $fb, $fb, $fc, $fd, $ff, $00, $01, $03, $04, $05, $05, $06, $07
	db $08, $07, $06, $05, $05, $04, $03, $01, $00, $ff, $fd, $fc, $fb, $fb, $fa, $f9
	db $f8, $f9, $fa, $fb, $fb, $fc, $fd, $ff, $4e, $00, $4e, $20, $4c, $00, $4c, $20
	db $7c, $00, $7c, $20

Call_15_7196::
	ld a, [$d223]
	cp $04
	jr c, jr_015_71bb

	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70ca
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $70c2
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $02
	call Call_15_72ED

jr_015_71bb:
	ld a, [$d223]
	cp $03
	jr c, jr_015_71e0

	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70f2
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $70ea
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $01
	call Call_15_72ED

jr_015_71e0:
	ld a, [$d223]
	cp $02
	jr c, jr_015_7205

	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $711a
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $7112
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $01
	call Call_15_72ED

jr_015_7205:
	ld a, [$d223]
	cp $01
	jr c, jr_015_7241

	ld a, [$d221]
	and $0f
	cp $07
	jr z, jr_015_721d

	cp $08
	jr z, jr_015_721d

	cp $09
	jr nz, jr_015_7223

jr_015_721d:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_015_7241

jr_015_7223:
	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $7142
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $713a
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $00
	call Call_15_72ED

jr_015_7241:
	ld a, [$d223]
	cp $04
	jr c, jr_015_7266

	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70ca
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $70c2
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $02
	call Call_15_72ED

jr_015_7266:
	ld a, [$d223]
	cp $03
	jr c, jr_015_728b

	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70f2
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $70ea
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $01
	call Call_15_72ED

jr_015_728b:
	ld a, [$d223]
	cp $02
	jr c, jr_015_72b0

	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $711a
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $7112
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $01
	call Call_15_72ED

jr_015_72b0:
	ld a, [$d223]
	cp $01
	jr c, jr_015_72ec

	ld a, [$d222]
	and $0f
	cp $07
	jr z, jr_015_72c8

	cp $08
	jr z, jr_015_72c8

	cp $09
	jr nz, jr_015_72ce

jr_015_72c8:
	ldh a, [hFrameCounter]
	and $01
	jr z, jr_015_72ec

jr_015_72ce:
	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $7142
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $713a
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $00
	call Call_15_72ED

jr_015_72ec:
	ret


Call_15_72ED::
	ldh [hActiveEntitySpriteVariant], a
	ld de, $718a
	call DrawEntity16x16
	ld a, $02
	call ReserveOAMEntriesFar
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_015_733b

	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_015_733b

	ld hl, wIsLinkInTheAir
	ld a, [wInvincibilityCounter]
	or [hl]
	jr nz, jr_015_733b

	ld a, $08
	ld [wSubtractHealthBuffer], a
	ld a, $20
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
	ld a, $10
	ld [wLinkPushedTimer], a
	ld a, $30
	ld [wInvincibilityCounter], a
	ld a, $03
	ldh [hWaveSfx], a

jr_015_733b:
	jp LoadEntityPosition


;@ path: enemy/sand_crab
;@ Sand crab sprites for RenderActiveEntitySpritesPair: 2 variants (walk frames), 4 bytes each
;@ (tile, attributes for both mirrored 8x16 halves): $58, $5A.
SandCrabSprites::
	db $58, $00, $58, $20, $5a, $00, $5a, $20

;@ path: enemy/sand_crab
;@ X speeds of the sand crab's 4 walking directions (1/16 pixel per frame): +16, -16, 0, 0 -
;@ fast sideways ...
SandCrabSpeedX::
	db $10, $f0, $00, $00

;@ path: enemy/sand_crab
;@ ... and Y speeds of the same 4 directions: 0, 0, -5, +5 - slow up and down.
SandCrabSpeedY::
	db $00, $00, $fb, $05

;@ def SandCrabHandler(slot: c)
;@ path: enemy/sand_crab
;@ Handler of entity $C6, the sand crab of the beach: scuttles fast sideways or slowly up and
;@ down, picking a new direction at random every 48-175 frames or when it walks into something.
;@ test: skip calls routines in other banks
SandCrabHandler::
;> DrawEntity16x16(SandCrabSprites)                # draw it
	ld de, SandCrabSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> EntityCheckHits()                                # contact with Link and his weapons
	call EntityCheckHits
;> SetEntitySpriteVariant((hFrameCounter >> 3) & 1)        # walk frames
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;>@nd if wEntityCollisions[slot] or wEntityTimer[slot] == 0:   # new direction
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .turn
	call GetEntityTimer
;=@nd
	jr nz, .done

.turn
;>     wEntityTimer[slot] = (GetRandomByte() & 0x7F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $7f
	add $30
	ld [hl], a
;>     d = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[SandCrabSpeedX + d]
	ld hl, SandCrabSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[SandCrabSpeedY + d]
	ld hl, SandCrabSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.done
;> return
	ret


;@ path: enemy/urchin
;@ Sea urchin sprites for RenderActiveEntitySpritesPair: 4 variants (the spines wobble: tiles
;@ $5C/$5E turned by flips), 4 bytes each (tile, attributes per 8x16 half).
UrchinSprites::
	db $5c, $00, $5e, $00, $5e, $20, $5c, $20, $5e, $60, $5c, $60, $5c, $40, $5e, $40
;@ path: enemy/urchin
;@ The same 4 variants with tiles $2C/$2E, used while the credits run (wGameplayType 1).
UrchinCreditsSprites::
	db $2c, $00, $2e, $00, $2e, $20, $2c, $20, $2e, $60, $2c, $60, $2c, $40, $2e, $40
;@ path: enemy/urchin
;@ X speed of a push by the side Link is on (0 right, 1 left, 2 above, 3 below): it moves away
;@ from him, 3/16 pixel per frame: -3, +3, 0, 0.
UrchinPushSpeedX::
	db $fd, $03, $00, $00

;@ path: enemy/urchin
;@ Y speed of a push by the side Link is on: 0, 0, +3, -3.
UrchinPushSpeedY::
	db $00, $00, $03, $fd

;@ def UrchinHandler(slot: c)
;@ path: enemy/urchin
;@ Handler of entity $C5, the sea urchin: it does not move by itself and hurts Link on touch,
;@ except while he holds up his shield towards it: then the touch is harmless (physics flag bit
;@ 7) and he pushes it slowly away (with a scraping sound). Weapons hurt it, but not while Link
;@ only holds the shield up.
;@ test: skip calls routines in other banks
UrchinHandler::
;> sprites = UrchinCreditsSprites if wGameplayType == 1 else UrchinSprites
	ld de, UrchinSprites
	ld a, [wGameplayType]
	cp $01
	jr nz, .draw
	ld de, UrchinCreditsSprites

.draw
;> DrawEntity16x16(sprites)                        # draw it
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;>@wb SetEntitySpriteVariant((hFrameCounter >> 4) & 3)        # wobble
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $03
;=@wb
	call SetEntitySpriteVariant
;> side = GetEntityDirectionToLink_15(slot)
	call GetEntityDirectionToLink_15
;> wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> wEntityPhysicsFlags[slot] &= ~0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
;>@sh if wIsUsingShield and hLinkDirection ^ 1 == side:   # shield held towards it
	ld a, [wIsUsingShield]
	and a
	jr z, .touch
	ldh a, [hLinkDirection]
	xor $01
	cp e
;=@sh
	jr nz, .touch
;>     wEntityPhysicsFlags[slot] |= 0x80      # harmless to touch
	set 7, [hl]

.touch
;> if EntityTouchesLink():                            # Link touches it
	call EntityTouchesLink
	jr nc, .weapons
;>     RestoreLinkPosition()
	call RestoreLinkPosition
;>     if not wEntityPhysicsFlags[slot] & 0x80: return   # it hurt him
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $80
	ret z
;>     d = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;>     wEntitySpeedX[slot] = mem[UrchinPushSpeedX + d]   # pushed away from Link
	ld hl, UrchinPushSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[UrchinPushSpeedY + d]
	ld hl, UrchinPushSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     hJingle = 0x3E
	ld a, $3e
	ldh [hJingle], a
;>     UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;>     wEntityIgnoreHitsTimer[slot] = 3
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $03
;>     EntityCheckWalls()                            # walls stop it
	call EntityCheckWalls
;>     wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b

.weapons
;> if wSwordAnimationStatePrev or not wIsUsingShield:
	ld a, [wSwordAnimationStatePrev]
	and a
	jr nz, .hit
	ld a, [wIsUsingShield]
	and a
	jr nz, .done

.hit
;>     EntityCheckWeaponHits()                            # weapons hit it
	call EntityCheckWeaponHits

.done
	ret


;@ path: object/rolling_bridge
;@ Y speed of the rolling bridge by its direction: 0 down +$30, 1 up -$30 (1/16 pixel per
;@ frame).
RollingBridgeSpeedY::
	db $30, $d0

;@ def RollingBridgeHandler(slot: c)
;@ path: object/rolling_bridge
;@ Handler of entity $68, the bridge that unrolls when the hookshot hits a rolled-up bridge
;@ (object $9F rolls down, $9E up). The invisible entity moves 3 pixels per frame and turns every
;@ 16x16 square it passes into bridge (object $9D), drawing it: the rolled end (tiles $08/$09,
;@ or $0A/$0B going up) in front of plain bridge (tiles $04/$05). It stops on the first square
;@ that is plain ground (no special physics), which gets a plain bridge piece.
;@ test: skip calls routines in other banks
RollingBridgeHandler::
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;>@sp wEntitySpeedY[slot] = mem[RollingBridgeSpeedY + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, RollingBridgeSpeedY
	add hl, de
;=@sp
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> AddEntitySpeedToPosY_15(slot)
	call AddEntitySpeedToPosY_15
;> EntityCheckWalls()                                # (also finds the object under it)
	call EntityCheckWalls
;>@gr if hRoomObjectType != 0x9D and GetObjectPhysics(hRoomObjectType, 1) == 0:   # plain ground
	ldh a, [hRoomObjectType]
	cp $9d
	jr z, .lay
	ld e, a
	ld d, $01
	call GetObjectPhysics
;=@gr
	and a
	jr nz, .lay
;>     ClearEntityStatus_15(slot)             # the last piece
	call ClearEntityStatus_15
;>     hActiveEntityStatus = wEntityStatus[slot]   # 0: draw the end piece plain
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityStatus], a

.lay
;> hBGPosX = u8(hActiveEntityX - 8)
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hBGPosX], a
;> column = hBGPosX >> 4
	swap a
	and $0f
	ld e, a
;> hBGPosY = u8(hActiveEntityDrawY + 4 - 0x10)
	ldh a, [hActiveEntityDrawY]
	add $04
	sub $10
	ldh [hBGPosY], a
;> square = (hBGPosY & 0xF0) | column
	and $f0
	or e
	ld e, a
	ld d, $00
;> wRoomObjects[square] = 0x9D               # bridge
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $9d
;> GetBGAddress()                             # hBGAddrHigh/Low of that square
	call GetBGAddress
;> cmd = wDrawCommand + wDrawCommandsSize     # queue two 2-tile columns
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize += 10
	add $0a
	ld [wDrawCommandsSize], a
	ld d, $00
	add hl, de
;> mem[cmd] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x81                        # 2 tiles downwards
	ld a, $81
	ld [hli], a
;>@dn if wEntityDirection[slot] == 0:            # unrolling downwards
	push hl
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	pop hl
	and a
;=@dn
	jr nz, .up
;>     mem[cmd + 3] = 4
	ld a, $04
	ld [hli], a
;>@t1     mem[cmd + 4] = 8 if hActiveEntityStatus else 4   # the rolled end below
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $08
	jr nz, .tile1
	ld a, $04

.tile1
;=@t1
	ld [hli], a
;>     mem[cmd + 5] = hBGAddrHigh             # the right-hand column
	ldh a, [hBGAddrHigh]
	ld [hli], a
;>     mem[cmd + 6] = hBGAddrLow + 1
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;>     mem[cmd + 7] = 0x81
	ld a, $81
	ld [hli], a
;>     mem[cmd + 8] = 5
	ld a, $05
	ld [hli], a
;>@t3     mem[cmd + 9] = 9 if hActiveEntityStatus else 5
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $09
	jr nz, .tile3
	ld a, $05

.tile3
;=@t3
	ld [hli], a
;>     mem[cmd + 10] = 0                      # end of the queue
	ld [hl], $00
	ret


.up
;> else:                                     # unrolling upwards
;>@t0     mem[cmd + 3] = 0x0A if hActiveEntityStatus else 4   # the rolled end above
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $0a
	jr nz, .tile0
	ld a, $04

.tile0
;=@t0
	ld [hli], a
;>     mem[cmd + 4] = 4
	ld a, $04
	ld [hli], a
;>     mem[cmd + 5] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;>     mem[cmd + 6] = hBGAddrLow + 1
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;>     mem[cmd + 7] = 0x81
	ld a, $81
	ld [hli], a
;>@t2     mem[cmd + 8] = 0x0B if hActiveEntityStatus else 5
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $0b
	jr nz, .tile2
	ld a, $05

.tile2
;=@t2
	ld [hli], a
;>     mem[cmd + 9] = 5
	ld a, $05
	ld [hli], a
;>     mem[cmd + 10] = 0
	ld [hl], $00
	ret


;@ def BeetleSpawnerHandler(slot: c)
;@ path: enemy/beetle_spawner
;@ Handler of entity $B2, a nest that lets small beetles crawl out. The placed entity is
;@ invisible: while Link is within 32 pixels it releases a beetle every 64 frames (another $B2
;@ with wEntityPrivate3 = 1, searched from slot 4 on) that heads for Link (see
;@ BeetleSpawnerBeetle).
;@ test: skip calls routines in other banks
BeetleSpawnerHandler::
;> if wEntityPrivate3[slot]: return BeetleSpawnerBeetle(slot)   # a beetle
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jp nz, BeetleSpawnerBeetle
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> _, dx = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;> if u8(dx + 0x20) >= 0x40: return           # Link too far
	add $20
	cp $40
	jr nc, .done
;> _, dy = GetEntityYDistanceToLink_15(slot)
	call GetEntityYDistanceToLink_15
;> if u8(dy + 0x20) >= 0x40: return
	add $20
	cp $40
	jr nc, .done
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] & 0x3F: return   # every 64 frames
	and $3f
	jr nz, .done
;> beetle = SpawnEntityFromSlot(0xB2, 4)               # a free slot from 4 on
	ld a, $b2
	ld e, $04
	call SpawnEntityFromSlot
;> if beetle is None: return
	jr c, .done
;> wEntityX[beetle] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[beetle] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPhysicsFlags[beetle] = 0x12         # 2 sprites, with a shadow
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;> wEntityPrivate3[beetle] = 1                # a beetle
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
;> wEntityTimer[beetle] = 0x18                # first turn
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $18
;> wEntityTimer1[beetle] = 0x20               # walls do not stop it yet
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $20
;> SetEntitySpeedTowardsLink(0x08)                            # the beetle crawls towards Link
	push bc
	push de
	pop bc
	ld a, $08
	call SetEntitySpeedTowardsLink
	pop bc

.done
;> return
	ret


;@ path: enemy/beetle_spawner
;@ X speed of a beetle's 4 crawling directions (1/16 pixel per frame): +8, -8, 0, 0.
BeetleSpeedX::
	db $08, $f8, $00, $00

;@ path: enemy/beetle_spawner
;@ Y speed of the same 4 directions: 0, 0, -8, +8.
BeetleSpeedY::
	db $00, $00, $f8, $08

;@ path: enemy/beetle_spawner
;@ Beetle sprites for RenderActiveEntitySpritesPair: 2 variants (crawl frames), 4 bytes each
;@ (tile, attributes per 8x16 half): $70/$72, then mirrored.
BeetleSprites::
	db $70, $00, $72, $00, $72, $20, $70, $20

;@ def BeetleSpawnerBeetle(slot: c)
;@ path: enemy/beetle_spawner
;@ A beetle from the nest: crawls (2 frames), passes through walls for its first $20 frames,
;@ hurts Link on touch, and turns to a random one of 4 directions every 32-63 frames.
;@ test: skip calls routines in other banks
BeetleSpawnerBeetle::
;> DrawEntity16x16(BeetleSprites)                  # draw it
	ld de, BeetleSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> SetEntitySpriteVariant((hFrameCounter >> 3) & 1)        # crawl
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> if wEntityTimer1[slot] == 0: EntityCheckWalls()   # walls, once out of the nest
	call GetEntityTimer1
	jr nz, .contact
	call EntityCheckWalls

.contact
;> EntityCheckHits()                                # contact with Link and his weapons
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x20
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;>     d = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[BeetleSpeedX + d]
	ld hl, BeetleSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[BeetleSpeedY + d]
	ld hl, BeetleSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.done
;> return
	ret


;@ path: unused
;@ Two bytes nothing reads ($3E, $00), in front of the laser beam's tables.
LaserBeamUnusedBytes::
	db $3e, $00

;@ path: enemy/laser_beam
;@ X speed Link gets when his shield blocks a laser beam, by his direction (0 right, 1 left,
;@ 2 up, 3 down): pushed back, -8, +8, 0, 0.
LaserBeamPushLinkX::
	db $f8, $08, $00, $00

;@ path: enemy/laser_beam
;@ Y speed Link gets when his shield blocks a laser beam, by his direction: 0, 0, +8, -8.
LaserBeamPushLinkY::
	db $00, $00, $08, $f8

;@ def LaserBeamHandler(slot: c)
;@ path: enemy/laser_beam
;@ Handler of entity $2B, a laser shot: it flies straight on leaving a trail (effect 6), hurts
;@ Link while not yet reflected, and ends in a spark (effect 5) when it hits something. If
;@ Link's shield blocked it (collision value 2), it is turned back along the axis Link faces,
;@ harmless to him from then on (state 2), and Link is pushed back for $10 frames.
;@ test: skip calls routines in other banks
LaserBeamHandler::
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> if hActiveEntityState == 0: EntityCheckTouchLink()    # hits Link
	ldh a, [hActiveEntityState]
	and a
	jr nz, .fly
	call EntityCheckTouchLink

.fly
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckObjectCollision()                                # what it ran into
	call EntityCheckObjectCollision
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .trail
;>     hMultiPurpose0 = hActiveEntityX
	push hl
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(5)                     # spark
	ld a, $05
	call AddTransientVfx
;>     if wEntityCollisions[slot] != 2: return ClearEntityStatus_15(slot)
	pop hl
	ld a, [hl]
	cp $02
	jp nz, ClearEntityStatus_15
;>     wEntityCollisions[slot] = 0            # blocked by the shield: reflect
	ld [hl], $00
;>     wEntityState[slot] = 2                 # harmless to Link now
	ld hl, wEntityState
	add hl, bc
	ld [hl], a
;>     speeds = wEntitySpeedY if hLinkDirection & 2 else wEntitySpeedX
	ldh a, [hLinkDirection]
	and $02
	jr nz, .vertical
	ld hl, wEntitySpeedX
	jr .reverse

.vertical
	ld hl, wEntitySpeedY

.reverse
;>     speeds[slot] = u8(-speeds[slot])       # back the way it came
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>     wLinkPushedTimer = 0x10
	ld a, $10
	ld [wLinkPushedTimer], a
;>     d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
;>     hLinkSpeedX = mem[LaserBeamPushLinkX + d]
	ld hl, LaserBeamPushLinkX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;>     hLinkSpeedY = mem[LaserBeamPushLinkY + d]
	ld hl, LaserBeamPushLinkY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
;>     return
	ret


.trail
;> hMultiPurpose0 = u8(hActiveEntityX + 4)
	ldh a, [hActiveEntityX]
	add $04
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hMultiPurpose1], a
;> effect = AddTransientVfx(6)                # trail
	ld a, $06
	call AddTransientVfx
;> mem[effect] = 0x10                         # it lasts $10 frames
	ld [hl], $10
	ret


;@ path: enemy/monkey
;@ The monkey in the tree, for RenderActiveEntitySpritesRect: 4 variants, each 3 OAM entries of
;@ 4 bytes (y offset, x offset, tile, attributes). 0 sitting ($74 mirrored; third entry blank
;@ tile $FF), 1 throwing with the arm up on the right ($7A at y -16, body $76/$78), 2 the same
;@ mirrored, 3 falling (upside down: $74 y-flipped).
MonkeySprites::
	db $00, $00, $74, $00, $00, $08, $74, $20, $00, $00, $ff, $00, $f0, $08, $7a, $00
	db $00, $00, $76, $00, $00, $08, $78, $00, $f0, $00, $7a, $20, $00, $00, $78, $20
	db $00, $08, $76, $20, $00, $00, $74, $40, $00, $08, $74, $60, $00, $00, $ff, $00

;@ def MonkeyHandler(slot: c)
;@ path: enemy/monkey
;@ Handler of entity $E0, the monkey sitting in a tree: it throws coconuts at Link (every 16th
;@ throw a bomb instead). If Link dashes into its tree with the Pegasus Boots, it tumbles down
;@ and runs off hopping. The coconuts are $E0 entities with wEntityPrivate1 = 1
;@ (MonkeyCoconut).
;@ test: skip calls routines in other banks
MonkeyHandler::
;> if wEntityPrivate1[slot]: return MonkeyCoconut(slot)   # a thrown coconut
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, MonkeyCoconut
;>@dr DrawEntitySprites(MonkeySprites + hActiveEntitySpriteVariant * 12, 3)
	ld hl, MonkeySprites
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
;=@dr
	rla
	add e
	ld e, a
	ld d, b
	add hl, de
;=@dr
	ld c, $03
	call DrawEntitySprites
;> DrawEntityShadow()                                # its shadow
	call DrawEntityShadow
;>@bump if hActiveEntityState < 2 and wBumpShakeTimer and wDashBumpFrames:   # Link dashed into a tree
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .states
	ld a, [wBumpShakeTimer]
	and a
	jr z, .states
;=@bump
	ld a, [wDashBumpFrames]
	and a
	jr z, .states
;>@nb     if -16 <= hActiveEntityX + 8 - wDashBumpX < 16 and -16 <= hActiveEntityY + 8 - wDashBumpY < 16:
	ldh a, [hActiveEntityX]
	add $08
	ld hl, wDashBumpX
	sub [hl]
	add $10
	cp $20
;=@nb
	jr nc, .states
;=@nb
	ldh a, [hActiveEntityY]
	add $08
	ld hl, wDashBumpY
	sub [hl]
	add $10
	cp $20
;=@nb
	jr nc, .states
;>         wEntityY[slot] += 0x18              # this monkey's tree: it falls
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $18
	ld [hl], a
;>         wEntityZ[slot] = 0x18               # from the same height
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $18
;>         wEntityState[slot] = 2              # falling
	call IncrementEntityState
	ld [hl], $02
;>         wEntitySpeedZ[slot] = 0x15
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $15
;>         wEntitySpeedY[slot] = 0x0C
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $0c
;>         wEntitySpeedX[slot] = 0xFA
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fa
;>         return
	ret


.states
;> MonkeyStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/monkey
;@ States of the monkey (rst $00 table indexed by its state): 0 start, 1 throw from the tree,
;@ 2 fall, 3 run away.
MonkeyStates::
	dw MonkeyInit
	dw MonkeyThrow
	dw MonkeyFall
	dw MonkeyRunAway

;@ def MonkeyInit(slot: c)
;@ path: enemy/monkey
;@ State 0: moves 8 pixels right (into its tree) and waits $80 frames.
;@ test: skip calls routines in other banks
MonkeyInit::
;> wEntityX[slot] += 8
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> IncrementEntityState()
	jp IncrementEntityState


;@ def MonkeyThrow(slot: c)
;@ path: enemy/monkey
;@ State 1: every $50 frames the monkey changes pose: sitting, throwing to the left, throwing to
;@ the right. With each throwing pose (then $28 frames until the next) it throws a coconut, or
;@ every 16th time a bomb (entity 2), in an arc down towards Link's side, lasting $60 frames.
;@ test: skip calls routines in other banks
MonkeyThrow::
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> if wEntityTimer[slot]: return
	call GetEntityTimer
	ret nz
;> wEntityTimer[slot] = 0x50
	ld [hl], $50
;> pose = wEntitySpriteVariant[slot] + 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
;> if pose == 3: pose = 0
	cp $03
	jr nz, .setPose
	xor a

.setPose
;> wEntitySpriteVariant[slot] = pose
	ld [hl], a
;> hActiveEntitySpriteVariant = pose
	ldh [hActiveEntitySpriteVariant], a
;> if pose == 0: return                       # sitting
	cp $00
	jr z, .done
;> wEntityTimer[slot] = 0x28
	call GetEntityTimer
	ld [hl], $28
;> wEntityPrivateCounter[slot] += 1           # throws
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> kind = 0xE0 if wEntityPrivateCounter[slot] & 0x0F else 2   # a coconut, now and then a bomb
	ld a, [hl]
	and $0f
	jr nz, .coconut
	ld a, $02
	jr .throw

.coconut
	ld a, $e0

.throw
;> nut = SpawnEntity(kind)
	call SpawnEntity
;> if nut is None: return
	ret c
;> wEntityX[nut] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@ny wEntityY[nut] = u8(hMultiPurpose1 - 0x0C + 0x18)   # the same height as the monkey
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $0c
	add $18
;=@ny
	ld [hl], a
;> wEntityZ[nut] = 0x18
	ld hl, wEntityZ
	add hl, de
	ld [hl], $18
;> wEntityPrivate1[nut] += 1                  # thrown
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> wEntitySpeedZ[nut] = 0x20
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
;>@sx wEntitySpeedX[nut] = 0xF8 if pose == 1 else 8
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	ld a, $f8
	jr z, .speedX
	ld a, $08

.speedX
;=@sx
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[nut] = 0x0C
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $0c
;> wEntityPhysicsFlags[nut] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;> wEntityOptions1[nut] |= 1
	ld hl, wEntityOptions1
	add hl, de
	set 0, [hl]
;> hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;> wEntityTimer[nut] = 0x60
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60
;> wEntityPrivate4[nut] = 1
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01

.done
	ret


;@ def MonkeyFall(slot: c)
;@ path: enemy/monkey
;@ State 2: the monkey tumbles out of the tree (upside-down pose, gravity 2); on landing it
;@ hops ($20) and runs away (state 3) with a hop sound.
;@ test: skip calls routines in other banks
MonkeyFall::
;> SetEntitySpriteVariant(3)                  # upside down
	ld a, $03
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if not wEntityZ[slot] & 0x80: return       # still falling
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, MonkeyHopSound.done
;> wEntityZ[slot] = 0
	ld [hl], b
;> wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;> ClearEntitySpeed()                                # stop
	call ClearEntitySpeed
;> IncrementEntityState()                     # run away
	call IncrementEntityState
;> MonkeyHopSound()                           # falls through

;@ def MonkeyHopSound()
;@ path: enemy/monkey
;@ The monkey's hop sound (wave channel $14).
;@ test: hWaveSfx = 0
MonkeyHopSound::
;> hWaveSfx = 0x14
	ld a, $14
	ldh [hWaveSfx], a

.done
	ret


;@ def MonkeyRunAway(slot: c)
;@ path: enemy/monkey
;@ State 3: the monkey runs off, hopping away from Link (each hop 8-23 high, speed $10), with a
;@ hop sound every 16 frames, until it leaves the screen.
;@ test: skip calls routines in other banks
MonkeyRunAway::
;> SetEntitySpriteVariant(0)
	ld a, $00
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # landed: next hop
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .offScreen
;>     wEntityZ[slot] = 1
	ld [hl], $01
;>     wEntitySpeedZ[slot] = (GetRandomByte() & 0x0F) + 8
	call GetRandomByte
	and $0f
	add $08
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
;>     GetVectorTowardsLink(0x10)                        # vector towards Link
	ld a, $10
	call GetVectorTowardsLink
;>     wEntitySpeedY[slot] = u8(-hMultiPurpose0)   # away from him
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = u8(-hMultiPurpose1)
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

.offScreen
;> if hActiveEntityX >= 0xA8: return ClearEntityStatus_15(slot)
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_15
;> if hActiveEntityDrawY >= 0x80: return ClearEntityStatus_15(slot)
	ldh a, [hActiveEntityDrawY]
	cp $80
	jp nc, ClearEntityStatus_15
;> if hFrameCounter & 0x0F == 0: return MonkeyHopSound()
	ldh a, [hFrameCounter]
	and $0f
	jr z, MonkeyHopSound
	ret


;@ path: enemy/monkey
;@ Coconut sprites for RenderActiveEntitySpritesPair: 2 variants (the spin), 4 bytes each
;@ (tile, attributes per 8x16 half): $7C/$7E, then mirrored.
CoconutSprites::
	db $7c, $00, $7e, $00, $7e, $20, $7c, $20

;@ path: enemy/monkey
;@ Bounce speeds of a coconut, 8 directions around a circle (1/16 pixel per frame). Direction d
;@ uses CoconutBounceSpeedY[d] and CoconutBounceSpeedX[d]; the y table runs on into the x
;@ table: y = 0, 12, 16, 12, 0, -12, -16, -12.
CoconutBounceSpeedY::
	db $00, $0c

;@ path: enemy/monkey
;@ X bounce speeds of the 8 directions: 16, 12, 0, -12, -16, -12, 0, 12 (see
;@ CoconutBounceSpeedY).
CoconutBounceSpeedX::
	db $10, $0c, $00, $f4, $f0, $f4
	db $00, $0c

;@ def MonkeyCoconut(slot: c)
;@ path: enemy/monkey
;@ A thrown coconut: spins, hurts Link on touch, falls with gravity 2 and bounces off the ground
;@ in a random direction (height 16-31); the fourth landing ends it.
;@ test: skip calls routines in other banks
MonkeyCoconut::
;> DrawEntity16x16(CoconutSprites)                 # draw it
	ld de, CoconutSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;>@spn SetEntitySpriteVariant((hFrameCounter >> 4) & 1)   # spin
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@spn
	call SetEntitySpriteVariant
;> EntityCheckHits()                               # contact with Link and his weapons
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # it hits the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = (GetRandomByte() & 0x0F) + 0x10
	call GetRandomByte
	and $0f
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
;>     d = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[CoconutBounceSpeedX + d]
	ld hl, CoconutBounceSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[CoconutBounceSpeedY + d]
	ld hl, CoconutBounceSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityPrivateCounter[slot] += 1       # bounces
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
;>     if wEntityPrivateCounter[slot] == 4: return ClearEntityStatus_15(slot)
	ld a, [hl]
	cp $04
	jp z, ClearEntityStatus_15
;>     hJingle = 0x09                         # bonk
	ld a, $09
	ldh [hJingle], a

.done
	ret


;@ path: enemy/rat
;@ Rat sprites for RenderActiveEntitySpritesPair: 4 variants, 4 bytes each (tile, attributes
;@ per 8x16 half): 0 hopping and 1 standing facing left ($50/$52, $54/$56), 2-3 the same
;@ facing right (mirrored).
RatSprites::
	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

;@ def RatHandler(slot: c)
;@ path: enemy/rat
;@ Handler of entity $E1, a small rat that hops about in random directions, stopping in between
;@ to look left and right. Gravity 2 per frame.
;@ test: skip jumps through a table
RatHandler::
;> if wEntityDirection[slot] == 0:            # facing right: the mirrored frames
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
;> DrawEntity16x16(RatSprites)                     # draw it
	ld de, RatSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> AddEntityZSpeedToPos_15(slot)
	call AddEntityZSpeedToPos_15
;> wEntitySpeedZ[slot] -= 2                   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80   # (scratch here) nonzero = on the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, .states
;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a

.states
;> RatStates[hActiveEntityState]()
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/rat
;@ States of the rat (rst $00 table indexed by its state): 0 pause, 1 hop.
RatStates::
	dw RatPause
	dw RatHop

;@ path: enemy/rat
;@ Hop speeds of the rat, one picked at random for x and one for y (1/16 pixel per frame):
;@ 2, 8, 12, 8, -2, -8, -12, -8. An x speed from the second half also turns it to the left.
RatSpeeds::
	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

;@ def RatPause(slot: c)
;@ path: enemy/rat
;@ State 0: stands still, turning its head every 32 frames; when the pause is over it picks a
;@ random speed for x (and facing) and for y and hops for 48-79 frames.
;@ test: skip calls routines in other banks
RatPause::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .look
;>     d = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[RatSpeeds + d]
	ld hl, RatSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntityDirection[slot] = d & 4         # 0 right, 4 = not right
	ld a, e
	and $04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>@ry     wEntitySpeedY[slot] = mem[RatSpeeds + (GetRandomByte() & 7)]
	call GetRandomByte
	and $07
	ld e, a
	ld hl, RatSpeeds
	add hl, de
	ld a, [hl]
;=@ry
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;>     return IncrementEntityState()          # hop
	jp IncrementEntityState


.look
;> SetEntitySpriteVariant(1)                  # standing
	ld a, $01
	call SetEntitySpriteVariant
;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .done
;>     wEntityDirection[slot] ^= 4            # turn the head
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a

.done
	ret


;@ def RatHop(slot: c)
;@ path: enemy/rat
;@ State 1: hops along (each landing: a new hop of 8 at once), until the hop time is over; then
;@ it pauses for $48 frames.
;@ test: skip calls routines in other banks
RatHop::
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> EntityCheckWalls()                                # background collision
	call EntityCheckWalls
;> if hBGTilesRequestCopy:                    # on the ground
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .pose
;>     if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .hop
;>         wEntityTimer[slot] = 0x48
	ld [hl], $48
;>         wEntityState[slot] = 0             # pause
	call IncrementEntityState
	ld [hl], b
;>         return
	ret


.hop
;>     wEntitySpeedZ[slot] = 8                # hop again
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;>     wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

.pose
;> SetEntitySpriteVariant(0)
	ld a, $00
	call SetEntitySpriteVariant
	ret


;@ path: entity/draw
;@ Start offsets in the entity OAM area tried when too many sprites are on screen
;@ (ReserveOAMEntries_15 picks one by frame counter + slot, 8 entries): 0, 8, $10 ... $38, i.e.
;@ entries 0, 2, 4 ... 14.
OAMFlickerStartOffsets_15::
	db $00, $08, $10, $18, $20, $28, $30, $38

;@ def ReserveEntityOAM_15(slot: c)
;@ path: entity/draw
;@ Hands out the OAM entries the entity in `slot` has just drawn: the low nibble of its physics
;@ flags says how many sprites its type uses. Called by the bank-0 sprite drawers after they wrote
;@ an entity's sprites.
;@ test: slot = rand(0, 15)
ReserveEntityOAM_15::
;> count = wEntityPhysicsFlags[slot] & 0x0F   # sprites this entity type draws
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $0f
;> ReserveOAMEntries_15(count)                # falls through

;@ def ReserveOAMEntries_15(count: a)
;@ path: entity/draw
;@ Moves the OAM write position past `count` sprites just written by an entity. Entities share
;@ the 24 entries from $C030 on; once more than that were handed out in this frame, the start
;@ position jumps to a place picked by the frame counter and the slot number, so that sprites
;@ that do not fit take turns (they flicker instead of one entity disappearing).
;@ test: count = rand(0, 8)
ReserveOAMEntries_15::
;> size = count * 4                            # 4 bytes per OAM entry
	sla a
	sla a
	ld e, a
;> index = wOAMNextIndex + size
	ld a, [wOAMNextIndex]
	add e
;> if index >= 0x60:                           # past the 24 entries of the entity area
	cp $60
	jr c, .noWrap
;>     index -= 0x60                           # wrap to its start
	sub $60

.noWrap
;> wOAMNextIndex = index
	ld [wOAMNextIndex], a
;> wOAMEntriesUsed = u8(wOAMEntriesUsed + size)
	ld a, [wOAMEntriesUsed]
	add e
	ld [wOAMEntriesUsed], a
;> if wOAMEntriesUsed >= 0x60:                 # too many sprites this frame: rotate the start
	cp $60
	jr c, .done
;>@pick     wOAMNextIndex = mem[OAMFlickerStartOffsets_15 + ((hFrameCounter + wActiveEntitySlot) & 7)]
	ldh a, [hFrameCounter]
	ld hl, wActiveEntitySlot
	add [hl]
	and $07
	ld e, a
	ld d, $00
;=@pick
	ld hl, OAMFlickerStartOffsets_15
	add hl, de
	ld a, [hl]
	ld [wOAMNextIndex], a

.done
;> return
	ret


;@ def DrawEntityShadow_15(slot: c)
;@ path: entity/draw
;@ Draws what goes under an entity after its own sprites: in shallow water (ground status 2) a
;@ ripple, in tall grass (ground status 3) grass blades over its feet, and while it is in the air
;@ (and its type asks for it with physics flag bit 4) a small round shadow on the ground, shown
;@ every other frame. Nothing for a dying entity (status 7) or in the side-view areas.
;@ Called from the bank-0 sprite drawers.
;@ test: skip calls routines in other banks
DrawEntityShadow_15::
;> if hActiveEntityStatus == 7: return          # dying
	ldh a, [hActiveEntityStatus]
	cp $07
	jr z, .done
;> ground = wEntityGroundStatus[slot]
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
;>@rp if ground == 2:                           # shallow water: a ripple
	cp $02
	jp z, .ripple
;>@rpa     if hActiveEntityType == 2:              # a bomb: drawn 2 pixels higher
;>@rpb         hActiveEntityDrawY -= 2
;>@rpc         DrawEntityWaterRipple_15()
;>@rpd         return LoadEntityPosition()                  # back to the real position copies
;>@rpe     return DrawEntityWaterRipple_15()
;> if ground == 3: return DrawEntityGrassOverlay_15(slot)
	cp $03
	jp z, DrawEntityGrassOverlay_15
;> if wEntityZ[slot] == 0: return               # on the ground: no shadow
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;> if hIsSideScrolling: return
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .done
;> if not wEntityPhysicsFlags[slot] & 0x10: return   # this type has no shadow
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $10
	jr z, .done
;> if (hFrameCounter ^ slot) & 1: return       # shown every other frame
	ldh a, [hFrameCounter]
	xor c
	and $01
	jr nz, .done
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld de, wOAMBuffer + $30
	add hl, de
;> mem[oam] = hActiveEntityY + 10             # at its ground position, not where it is drawn
	ldh a, [hActiveEntityY]
	add $0a
	ld [hli], a
;> mem[oam + 1] = hActiveEntityX + 4
	ldh a, [hActiveEntityX]
	add $04
	ld [hli], a
;> mem[oam + 2] = 0x26                         # shadow tile
	ld a, $26
	ld [hli], a
;> mem[oam + 3] = 0
	ld [hl], b
;> ReserveOAMEntries_15(1)
	ld a, $01
	call ReserveOAMEntries_15

.done
	ret


.ripple
;=@rpa
	ldh a, [hActiveEntityType]
	cp $02
	jr nz, DrawEntityWaterRipple_15
;=@rpb
	ld hl, hActiveEntityDrawY
	dec [hl]
	dec [hl]
;=@rpc
	call DrawEntityWaterRipple_15
;=@rpd
	jp LoadEntityPosition


;@ def DrawEntityWaterRipple_15()
;@ path: entity/draw
;@ Draws a water ripple (tile $1C, mirrored on the right half) across the feet of the entity being
;@ drawn, switching palette every 4 frames so it shimmers.
;@ test: skip writes the OAM buffer at a computed place
DrawEntityWaterRipple_15::
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld de, wOAMBuffer + $30
	add hl, de
;> attr = 0x10 if hFrameCounter & 4 else 0     # palette 1 on alternate 4-frame steps
	ld e, $00
	ldh a, [hFrameCounter]
	and $04
	jr z, .attrDone
	ld e, $10

.attrDone
;> mem[oam] = hActiveEntityDrawY + 11
	ldh a, [hActiveEntityDrawY]
	add $0b
	ld [hli], a
;> mem[oam + 1] = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld [hli], a
;> mem[oam + 2] = 0x1C
	ld a, $1c
	ld [hli], a
;> mem[oam + 3] = attr
	ld a, e
	ld [hli], a
;> mem[oam + 4] = hActiveEntityDrawY + 11
	ldh a, [hActiveEntityDrawY]
	add $0b
	ld [hli], a
;> mem[oam + 5] = hActiveEntityX + 8
	ldh a, [hActiveEntityX]
	add $08
	ld [hli], a
;> mem[oam + 6] = 0x1C
	ld a, $1c
	ld [hli], a
;> mem[oam + 7] = attr | 0x20                  # x-flipped right half
	ld a, e
	or $20
	ld [hli], a
;> ReserveOAMEntries_15(2)
	ld a, $02
	call ReserveOAMEntries_15
	ret


;@ def DrawEntityGrassOverlay_15(slot: c)
;@ path: entity/draw
;@ Draws tall-grass blades (tile $1A, two sprites) over the feet of the entity being drawn. While
;@ the entity moves, both halves flip with bit 3 of its private counter, so the grass sways.
;@ test: skip writes the OAM buffer at a computed place
DrawEntityGrassOverlay_15::
;> counter = wEntityPrivateCounter[slot]
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
;> moving = wEntitySpeedX[slot] | wEntitySpeedY[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
;> attr = 0
	ld c, b
;> if moving:
	or [hl]
	jr z, .attrDone
;>     attr = (counter << 2) & 0x20            # x flip from bit 3 of the counter
	ld a, e
	rla
	rla
	and $20
	ld c, a

.attrDone
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld de, wOAMBuffer + $30
	add hl, de
;> mem[oam] = hActiveEntityDrawY + 8
	ldh a, [hActiveEntityDrawY]
	add $08
	ld [hli], a
;> mem[oam + 1] = hActiveEntityX - 1
	ldh a, [hActiveEntityX]
	dec a
	ld [hli], a
;> mem[oam + 2] = 0x1A
	ld a, $1a
	ld [hli], a
;> mem[oam + 3] = attr
	ld a, c
	ld [hli], a
;> mem[oam + 4] = hActiveEntityDrawY + 8
	ldh a, [hActiveEntityDrawY]
	add $08
	ld [hli], a
;> mem[oam + 5] = hActiveEntityX + 7
	ldh a, [hActiveEntityX]
	add $07
	ld [hli], a
;> mem[oam + 6] = 0x1A
	ld a, $1a
	ld [hli], a
;> mem[oam + 7] = attr
	ld a, c
	ld [hl], a
;> ReserveOAMEntries_15(2)
	pop bc
	ld a, $02
	call ReserveOAMEntries_15
	ret


;@ def CheckLinkBumpsEntity_15(slot: c) -> (carry, a)
;@ path: entity/collision
;@ For solid characters and objects: if Link walks into the entity, he is put back where he came
;@ from, a hookshot chain on its way is set back to its first state and his Pegasus Boots dash stops. Returns carry
;@ set and in a whether Link was dashing.
;@ test: skip calls routines in other banks
CheckLinkBumpsEntity_15::
;>@nt if not EntityTouchesLink(): return False        # Link does not touch the entity
	call EntityTouchesLink
	jr nc, .noTouch
;> RestoreLinkPosition()                                # Link back to his previous position
	call RestoreLinkPosition
;> if wHookshotChainSlot:
	ld a, [wHookshotChainSlot]
	and a
	jr z, .chainDone
;>     chain = wHookshotChainSlot - 1
	ld e, a
	ld d, b
;>     if wEntityType[chain] == 3:            # the hookshot chain is out
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, .chainDone
;>         wEntityState[chain] = 0             # back to its first state
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00

.chainDone
;> dashing = wIsUsingPegasusBoots
	ld a, [wIsUsingPegasusBoots]
	ld e, a
;> ResetPegasusBoots()                                # stop the Pegasus Boots
	call ResetPegasusBoots
;> StopLinkSpeed()                                # and Link's speed
	call StopLinkSpeed
;> return True, dashing
	ld a, e
	scf
	ret


.noTouch
;=@nt
	and a
	ret


;@ path: entity/draw
;@ Unused: sprite variant per facing direction (right 6, left 4, up 2, down 0), read only by
;@ UnusedAnimateByDirection_15. One byte per direction 0-3.
DirectionSpriteVariants_15::
	db $06, $04, $02, $00

;@ def UnusedAnimateByDirection_15(slot: c)
;@ path: unused
;@ Unused walking animation: the sprite variant is the facing direction's entry of
;@ DirectionSpriteVariants_15 plus a frame bit that flips every 16 counts of the private counter.
;@ test: skip calls routines in other banks
UnusedAnimateByDirection_15::
;> base = mem[DirectionSpriteVariants_15 + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, DirectionSpriteVariants_15
	add hl, de
;> wEntityPrivateCounter[slot] += 1
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
;> SetEntitySpriteVariant(frame | base)                    # set the sprite variant
	pop hl
	and $01
	or [hl]
	jp SetEntitySpriteVariant

;@ def CheckLinkTalksToEntity_15() -> carry
;@ path: npc/talk
;@ For characters: returns carry when Link stands close in front of the entity, faces it and
;@ presses A, with no dialogue, inventory, jump or open window in the way. Being close and facing
;@ it sets wCanTalkToEntity, which keeps the A button from using an item.
;@ test: skip calls routines in other banks
CheckLinkTalksToEntity_15::
;>@no if not -20 <= hLinkY - hActiveEntityY < 20: return False
	ld e, b
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28
;=@no
	jr nc, .no
;> if not -16 <= hLinkX - hActiveEntityX < 16: return False
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, .no
;> side = GetEntityDirectionToLink_15()      # where Link is, seen from the entity
	inc e
	push de
	call GetEntityDirectionToLink_15
;> if hLinkDirection ^ 1 != side: return False   # Link must face the entity
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
	jr nz, .no
;> wCanTalkToEntity = 1
	ld hl, wCanTalkToEntity
	ld [hl], $01
;> busy = wDialogState | wInventoryAppearing | wIsLinkInTheAir
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
;> if busy or mem[0xC134]: return False
	ld hl, $c134
	or [hl]
	jr nz, .no
;> if wWindowY != 0x80: return False          # a window is shown
	ld a, [wWindowY]
	cp $80
	jr nz, .no
;> if not hJoypadPressed & 0x10: return False  # A not pressed
	ldh a, [hJoypadPressed]
	and $10
	jr z, .no
;> return True
	scf
	ret


.no
;=@no
	and a
	ret


;@ def ReturnIfNonInteractive_15()
;@ path: entity/engine
;@ Called first by an entity handler after it drew itself: ends the handler (returns from the
;@ caller) unless the entity is active (status 5) and the game runs normally.
;@ test: skip returns from its caller
ReturnIfNonInteractive_15::
;> if hActiveEntityStatus != 5: return_from_caller()
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, ReturnIfGameFrozen_15.stop
;> ReturnIfGameFrozen_15()                    # falls through

;@ def ReturnIfGameFrozen_15()
;@ path: entity/engine
;@ Ends the calling handler (returns from the caller) while the world stands still: game mode 7
;@ (the world map), a dialogue box, the flag at $C1A8, the inventory sliding, or a scroll to the
;@ next room.
;@ test: skip returns from its caller
ReturnIfGameFrozen_15::
;> if wGameplayType == 7: return_from_caller()
	ld a, [wGameplayType]
	cp $07
	jr z, .stop
;> if wDialogState or mem[0xC1A8] or wInventoryAppearing: return_from_caller()
	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, .stop
;> if wRoomTransitionState: return_from_caller()
	ld a, [wRoomTransitionState]
	and a
	jr z, .run

.stop
	pop af

.run
	ret


;@ def ApplyRecoilIfNeeded_15(slot: c)
;@ path: entity/engine
;@ While the entity is being knocked back after a hit (wEntityIgnoreHitsTimer running), moves it
;@ by its recoil speed instead of its own (stopped by walls unless option bit 5 says otherwise)
;@ and ends the calling handler for this frame.
;@ test: skip returns from its caller
ApplyRecoilIfNeeded_15::
;> if wEntityIgnoreHitsTimer[slot] == 0: return
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;> wEntityIgnoreHitsTimer[slot] -= 1
	dec a
	ld [hl], a
;> AddPowerHitTrailVfx()
	call AddPowerHitTrailVfx
;> speed_x = wEntitySpeedX[slot]               # keep its own speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
;> speed_y = wEntitySpeedY[slot]
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
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore
;>     EntityCheckWalls()                             # walls stop the recoil
	call EntityCheckWalls

.restore
;> wEntitySpeedY[slot] = speed_y
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
;> wEntitySpeedX[slot] = speed_x
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
;> return_from_caller()
	pop af

.done
	ret


;@ def UpdateEntityPosWithSpeed_15(slot: c)
;@ path: entity/engine
;@ Moves the entity by its x and y speeds (1/16 pixel units).
;@ test: slot = rand(0, 15)
UpdateEntityPosWithSpeed_15::
;> AddEntitySpeedToPosX_15(slot)
	call AddEntitySpeedToPosX_15
;> AddEntitySpeedToPosY_15(slot)              # falls through

;@ def AddEntitySpeedToPosY_15(slot: c)
;@ path: entity/engine
;@ Moves the entity by its y speed: the x routine run on the arrays 16 bytes further on
;@ (wEntitySpeedY, wEntitySpeedYAcc, wEntityY).
;@ test: slot = rand(0, 15)
AddEntitySpeedToPosY_15::
;> AddEntitySpeedToPosX_15(slot + 16)
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPosX_15
;> return
	pop bc
	ret


;@ def AddEntitySpeedToPosX_15(slot: c)
;@ path: entity/engine
;@ Moves the entity by its x speed: a signed number of 1/16 pixels; the fraction (low nibble)
;@ is added into wEntitySpeedXAcc and its carry moves the entity one more pixel.
;@ test: slot = rand(0, 31)
AddEntitySpeedToPosX_15::
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
;> wEntitySpeedXAcc[slot] = acc & 0xFF
	ld [hl], a
	rl d
	ld hl, wEntityX

.addToPos
;> sign = 0xF0 if speed & 0x80 else 0
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive
	ld e, $f0

.positive
;> pixels = (speed >> 4) | sign             # whole pixels, sign extended
	swap a
	and $0f
	or e
;> wEntityX[slot] = u8(wEntityX[slot] + pixels + (acc >> 8))
	rr d
	adc [hl]
	ld [hl], a

.done
	ret


;@ def AddEntityZSpeedToPos_15(slot: c)
;@ path: entity/engine
;@ Moves the entity up or down in height by its z speed (same 1/16 pixel units as
;@ AddEntitySpeedToPosX_15, whose tail it shares).
;@ test: slot = rand(0, 15)
AddEntityZSpeedToPos_15::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0: return
	and a
	jr z, AddEntitySpeedToPosX_15.done
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
;> pixels = (speed >> 4) | (0xF0 if speed & 0x80 else 0)
;> wEntityZ[slot] = u8(wEntityZ[slot] + pixels + (acc >> 8))   # (in AddEntitySpeedToPosX_15's tail)
	ld hl, wEntityZ
	jr AddEntitySpeedToPosX_15.addToPos

;@ def GetEntityXDistanceToLink_15(slot: c) -> (e, d)
;@ path: entity/engine
;@ Horizontal distance from the entity to Link: d = Link x - entity x (signed), e = 0 when Link
;@ is to the right (or level), 1 when he is to the left (the facing direction towards him).
;@ test: slot = rand(0, 15)
GetEntityXDistanceToLink_15::
;> side = 0                                   # right
	ld e, $00
;> dx = u8(hLinkX - wEntityX[slot])
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if dx & 0x80:                              # Link is to the left
	bit 7, a
	jr z, .done
;>     side = 1
	inc e

.done
;> return side, dx
	ld d, a
	ret


;@ def GetEntityYDistanceToLink_15(slot: c) -> (e, d)
;@ path: entity/engine
;@ Vertical distance from the entity to Link: d = Link y - entity y (signed), e = 2 when Link is
;@ above, 3 when he is below (or level) - the facing direction towards him.
;@ test: slot = rand(0, 15)
GetEntityYDistanceToLink_15::
;> side = 2                                   # up
	ld e, $02
;> dy = u8(hLinkY - wEntityY[slot])
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if not dy & 0x80:                          # Link is below
	bit 7, a
	jr nz, .done
;>     side = 3
	inc e

.done
;> return side, dy
	ld d, a
	ret


;@ def UnusedGetEntityDrawYDistanceToLink_15() -> (e, d)
;@ path: unused
;@ Unused variant of GetEntityYDistanceToLink_15 measured from where the entity is drawn
;@ (hActiveEntityDrawY, so its height counts).
;@ test: skip unused
UnusedGetEntityDrawYDistanceToLink_15::
;> side = 2
	ld e, $02
;> dy = u8(hLinkY - hActiveEntityDrawY)
	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
;> if not dy & 0x80:
	bit 7, a
	jr nz, .done
;>     side = 3
	inc e

.done
;> return side, dy
	ld d, a
	ret

;@ def GetEntityDirectionToLink_15(slot: c) -> e
;@ path: entity/engine
;@ The direction (0 right, 1 left, 2 up, 3 down) from the entity towards Link, along the axis on
;@ which he is farther away. Also leaves the horizontal side in hMultiPurpose0 and the vertical
;@ side in hMultiPurpose1.
;@ test: slot = rand(0, 15)
GetEntityDirectionToLink_15::
;> side_x, dx = GetEntityXDistanceToLink_15(slot)
	call GetEntityXDistanceToLink_15
;> hMultiPurpose0 = side_x
	ld a, e
	ldh [hMultiPurpose0], a
;> far_x = u8(-dx) if dx & 0x80 else dx
	ld a, d
	bit 7, a
	jr z, .xPositive
	cpl
	inc a

.xPositive
;> side_y, dy = GetEntityYDistanceToLink_15(slot)
	push af
	call GetEntityYDistanceToLink_15
;> hMultiPurpose1 = side_y
	ld a, e
	ldh [hMultiPurpose1], a
;> far_y = u8(-dy) if dy & 0x80 else dy
	ld a, d
	bit 7, a
	jr z, .yPositive
	cpl
	inc a

.yPositive
;> if far_y < far_x: return hMultiPurpose0   # mostly sideways
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


;@ def ClearEntityStatus_15(slot: c)
;@ path: entity/engine
;@ Removes the entity: its slot becomes free.
;@ test: slot = rand(0, 15)
ClearEntityStatus_15::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ def BossDefeated_15(slot: c)
;@ path: boss/defeat
;@ Run every frame by a defeated boss of this bank instead of its fight: the steps of
;@ BossDefeatSteps_15, chosen by wEntityPrivate2 (flash, then explode, then leave the reward).
;@ test: skip jumps through a table
BossDefeated_15::
;> BossDefeatSteps_15[wEntityPrivate2[slot]]()
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/defeat
;@ Steps of a boss's defeat (rst $00 table indexed by wEntityPrivate2).
BossDefeatSteps_15::
	dw BossDefeatStart_15
	dw BossDefeatFlash_15
	dw BossDefeatExplode_15

;@ def BossDefeatStart_15(slot: c)
;@ path: boss/defeat
;@ First defeat step: the boss flashes for $A0 frames.
;@ test: skip calls routines in other banks
BossDefeatStart_15::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> IncrementBossDefeatStep_15(slot)           # falls through

;@ def IncrementBossDefeatStep_15(slot: c)
;@ path: boss/defeat
;@ Goes on to the next step of the boss defeat.
;@ test: slot = rand(0, 15)
IncrementBossDefeatStep_15::
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


;@ def BossDefeatFlash_15(slot: c)
;@ path: boss/defeat
;@ Second defeat step: when the flashing time is over, $C0 more frames of flashing with
;@ explosions follow.
;@ test: skip calls routines in other banks
BossDefeatFlash_15::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     IncrementBossDefeatStep_15(slot)
	call IncrementBossDefeatStep_15

.done
	ret


;@ def BossDefeatExplode_15(slot: c)
;@ path: boss/defeat
;@ Last defeat step: explosions burst around the boss every 8 frames; at the end the
;@ boss-defeated sound plays and the entity is replaced by its reward (DefeatEntityWithDrop).
;@ test: skip calls routines in other banks
BossDefeatExplode_15::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .explode
;>     PlayClinkNoise()                             # boss defeated sound, screen shake
	call PlayClinkNoise
;>     return DefeatEntityWithDrop()                      # the boss dies and leaves its reward
	jp DefeatEntityWithDrop


.explode
;> RandomBossExplosion_15(t)
	call RandomBossExplosion_15
	ret


;@ def RandomBossExplosion_15(t: a)
;@ path: boss/defeat
;@ Every 8 frames (t = a countdown) an explosion bursts at a random place around the boss:
;@ up to 16 pixels left or right and 20 up or 12 down from where it is drawn.
;@ test: skip calls routines in other banks
RandomBossExplosion_15::
;> if t & 7: return
	and $07
	jr nz, .done
;>@hx hActiveEntityX = u8(hActiveEntityX + (GetRandomByte() & 0x1F) - 0x10)
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityX
	add [hl]
;=@hx
	ld [hl], a
;>@hy hActiveEntityDrawY = u8(hActiveEntityDrawY + (GetRandomByte() & 0x1F) - 0x14)
	call GetRandomByte
	and $1f
	sub $14
	ld e, a
	ld hl, hActiveEntityDrawY
	add [hl]
;=@hy
	ld [hl], a
;> SpawnExplosionAtEntity_15()
	call SpawnExplosionAtEntity_15

.done
	ret


;@ def SpawnExplosionAtEntity_15()
;@ path: boss/defeat
;@ Unless the game is frozen, puts an explosion effect (visual effect 2) where the entity is drawn
;@ and plays the explosion noise ($13).
;@ test: skip calls routines in other banks
SpawnExplosionAtEntity_15::
;> ReturnIfGameFrozen_15()
	call ReturnIfGameFrozen_15
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                               # add the explosion effect there
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret


;@ def UnusedSpawnType36Drop_15(slot: c)
;@ path: unused
;@ Unused: replaces the entity with an entity of type $36 at its place, which pops up out of it
;@ (in the side-view areas the speed is set on the old entity instead - a slip in the code).
;@ test: skip unused
UnusedSpawnType36Drop_15::
;> new = SpawnEntity(0x36)                      # spawn: hMultiPurpose0/1 = our position
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
	jr z, .topView
;>     wEntitySpeedY[slot] = 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jr .remove

.topView
;> else:
;>     wEntitySpeedZ[new] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityZ[new] = 8
	ld hl, wEntityZ
	add hl, de
	ld [hl], $08

.remove
;> ClearEntityStatus_15(slot)
	call ClearEntityStatus_15
;> hNoiseSfx = 0x1A
	ld hl, hNoiseSfx
	ld [hl], $1a
	ret

;@ def SetRoomEventFlag_15()
;@ path: world/rooms
;@ Sets bit 5 of the current room's status byte (event done - here: the boss or the puzzle of
;@ the room is finished, so it stays that way) and its copy hRoomStatus. Overworld rooms use
;@ the first 256 bytes of wRoomStatus, indoor maps $06-$19 the third block, other indoor maps
;@ the second.
;@ test: hMapRoom = rand(0, 255)
SetRoomEventFlag_15::
;> group = wIsIndoor
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
;> if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .groupDone
	cp $06
	jr c, .groupDone
;>     group += 1
	inc d

.groupDone
;> status = wRoomStatus[group * 256 + hMapRoom] | 0x20
	add hl, de
	ld a, [hl]
	or $20
;> wRoomStatus[group * 256 + hMapRoom] = status
	ld [hl], a
;> hRoomStatus = status
	ldh [hRoomStatus], a
	ret


;@ path: unused
;@ Unused end of the bank, filled with $FF.
Bank15Padding::
	ds $2ff, $ff
