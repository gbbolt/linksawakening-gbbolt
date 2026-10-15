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
;> Call_3DAF()                                # x and y speed = 0
	call Call_3DAF
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
;> Call_3B87(0)                               # sprite variant 0
	xor a
	call Call_3B87
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
;>     Call_3B8D()                            # next state
	call Call_3B8D
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
;>     Call_3B8D()                            # next state
	call Call_3B8D

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
;> Call_3C3B(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call Call_3C3B
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
;> Call_3B8D()                                # next state
	jp Call_3B8D


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
;> Call_3DBA()                                # active position copies
	call Call_3DBA
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
;> Call_1495()                                # Link's speed = 0
	call Call_1495
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
;> Call_3C3B(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call Call_3C3B
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
;> Call_3B8D()                                # next state
	jp Call_3B8D


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
;> Call_3C3B(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call Call_3C3B
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
;> Call_3B8D()                                # next state
	jp Call_3B8D


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
;> Call_3C3B(LeverBlockSprites)              # draw it
	ld de, LeverBlockSprites
	call Call_3C3B
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
;> Call_3B8D()                                # next state
	jp Call_3B8D


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
;> Call_3C3B(CrystalSwitchSprites)           # draw it
	ld de, CrystalSwitchSprites
	call Call_3C3B
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()                                # count down the ignore-hits timer
	call DecrementEntityIgnoreHitsTimer
;> Call_3BEB()                                # weapons hit it
	call Call_3BEB
;> CheckLinkBumpsEntity_15(slot)              # Link cannot walk through it
	call CheckLinkBumpsEntity_15
;> Call_3B9E()                                # background collision
	call Call_3B9E
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
;> new = Call_3C01(0x45)                      # spawn a boulder
	ld a, $45
	call Call_3C01
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
;> Call_3C3B(BoulderSprites)                 # draw it
	ld de, BoulderSprites
	call Call_3C3B
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()                                # count down the ignore-hits timer
	call DecrementEntityIgnoreHitsTimer
;> Call_3BB4()                                # contact with Link and his weapons
	call Call_3BB4
;> Call_3B87((hFrameCounter >> 3) & 3)        # rolling animation
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	call Call_3B87
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
;>         Call_3CD0(FishSpritesSingle)
	ld de, FishSpritesSingle
	call Call_3CD0
	jr .drawn

.leaping
;>     else:
;>         Call_3C3B(FishSpritesPair)
	ld de, FishSpritesPair
	call Call_3C3B

.drawn
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> Call_3B9E()                                # background collision
	call Call_3B9E
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
;> Call_3B8D()                                # next state
	jp Call_3B8D


;@ def FishSwim(slot: c)
;@ path: enemy/fish
;@ State 1: swims under water (touching Link still hurts him). When the timer runs out it leaps:
;@ twice as fast sideways, upward speed $18, drawn with a shadow, with a splash.
;@ test: skip calls routines in other banks
FishSwim::
;> Call_3BBF()                                # hurts Link on touch
	call Call_3BBF
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
;> Call_3B8D()                                # next state
	call Call_3B8D
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
;> Call_3B87(frame)
	ld a, e
	call Call_3B87
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
;> Call_3BB4()                                # contact with Link and his weapons
	call Call_3BB4
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
	call Call_3B8D
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
;> Call_3B87(frame)
	ld a, e
	call Call_3B87
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
;> Call_3D26(FinalNightmareLightColumnSprites, (rows + 1) * 2)   # draw the column
	add $01
	sla a
	ld c, a
	ld hl, FinalNightmareLightColumnSprites
	call Call_3D26
;> Call_3DD0(10)                              # reserve 10 OAM entries
	ld a, $0a
	call Call_3DD0
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
;> Call_3B8D()                                # next step
	jp Call_3B8D


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
;> Call_3B87(0)
	ld a, $00
	call Call_3B87
;> Call_3B8D()                                # next step
	jp Call_3B8D


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
;> Call_3B8D()                                # next step
	call Call_3B8D
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
;> Call_3B8D()                                # next step
	call Call_3B8D
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
;> Call_380E()                                # keep Link inside the arena
	call Call_380E
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> Call_3BB4()                                # contact with Link and his weapons
	call Call_3BB4
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
;> Call_3B9E()                                # background collision
	call Call_3B9E
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
;> Call_3B87(0)
	call Call_3B87
;> Call_3B8D()                                # next state
	call Call_3B8D
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
;> Call_3B8D()                                # next state
	call Call_3B8D
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
;> Call_3B87(1)
	ld a, $01
	call Call_3B87
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
;>         spear = Call_3C01(0x0C)            # sets hMultiPurpose0-2 to our x, y, direction
	ld a, $0c
	call Call_3C01
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
;>@tp     Call_3B87(2 if wEntityTimer1[slot] >= 0x0C else 0)   # arm raised, then thrown
	call GetEntityTimer1
	ld e, $00
	cp $0c
	jr c, .poseSet
	ld e, $02

.poseSet
;=@tp
	ld a, e
	call Call_3B87
;>     Call_3DAF()                            # stands still while throwing
	call Call_3DAF
;>     return
	ret


.notThrowing
;> if wEntityDropTimer[slot] == 0:            # time for a charge
	call GetEntityDropTimer
	jr nz, .hop
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     Call_3DAF()                            # stop
	call Call_3DAF
;>     return Call_3B8D()                     # next state: wind-up
	call Call_3B8D
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
;>     Call_3C25(0x0C)                        # speed $0C towards that spot
	ld a, $0c
	call Call_3C25
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
;> Call_3B87(frame)
	call Call_3B87
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
;>     Call_3DAF()
	call Call_3DAF
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
;>     return Call_3B8D()                     # next state: charge
	call Call_3B8D
	ret


.stamp
;> if t & 7 == 0:
	and $07
	jr nz, .noStamp
;>     hJingle = 0x09
	ld a, $09
	ldh [hJingle], a

.noStamp
;> Call_3DAF()
	call Call_3DAF
;>@wp Call_3B87(2 + ((hFrameCounter >> 3) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;=@wp
	call Call_3B87
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
	call Call_3B8D
	call Call_3B8D
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
;>     Call_3B8D()                            # next state: dazed
	call Call_3B8D
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
;> Call_3B87(pose)
	call Call_3B87
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
	call Call_3B8D
	call Call_3B8D
;>     wMoblinKingHeadFrame = 0
	ld a, $00
	ld [wMoblinKingHeadFrame], a
;>     return Call_3B87(0)
	jp Call_3B87


.dazed
;> if hBGTilesRequestCopy: Call_3DAF()        # landed: stop sliding
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .pose
	call Call_3DAF

.pose
;>@dp Call_3B87(0x0C + ((hFrameCounter >> 3) & 1))
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $0c
;=@dp
	call Call_3B87
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
;> Call_3DD0(2)                               # reserve the 2 OAM entries
	ld a, $02
	jp Call_3DD0


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
;>     Call_3DAF()
	call Call_3DAF
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     return Call_3B8D()                     # next state: look around
	jp Call_3B8D


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
;> Call_3B87(0)
	call Call_3B87
	ret


;@ def MoblinKingLookAround(slot: c)
;@ path: boss/moblin_king
;@ State 7: stands still turning his head left and right every 16 frames, then goes back to
;@ hopping (MoblinKingResumeHopping).
;@ test: skip calls routines in other banks
MoblinKingLookAround::
;> Call_3DAF()
	call Call_3DAF
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
	call Call_3B8D
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
;> Call_3B8D()                                # next state: gloat
	call Call_3B8D
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
;> Call_3DAF()
	call Call_3DAF
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
;> Call_3B87(frame)
	call Call_3B87
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
;>@hd     Call_3D26(MoblinKingHeadSprites + head * 12, 3)
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
	call Call_3D26

.body
;>@bd Call_3D26(MoblinKingBodySprites + hActiveEntitySpriteVariant * 12, 3)
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
	call Call_3D26
;> if wEntityZ[slot]:                         # in the air: shadow
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hActiveEntityDrawY = hActiveEntityY    # on the ground
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;>     Call_3D26(MoblinKingShadowSprites, 3)
	ld hl, MoblinKingShadowSprites
	ld c, $03
	call Call_3D26
;>     Call_3DBA()                            # restore the active position copies
	call Call_3DBA

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
;>         part = Call_3C01(0xE3)             # the knocked-off part
	ld a, $e3
	call Call_3C01
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
;>             Call_3C30(0x20)                    # vector from the part to Link
	push bc
	push de
	pop bc
	ld a, $20
	call Call_3C30
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
;> Call_3BB4()                                # contact with Link and his weapons
	call Call_3BB4
;>@sw Call_3B87((hFrameCounter >> 3) & 3)        # sway
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	and $03
;=@sw
	call Call_3B87
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
;> Call_3B9E()                                # background collision
	call Call_3B9E
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
;>@full     Call_3D26(PokeySpritesFull + hActiveEntitySpriteVariant * 24, 6)
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
	call Call_3D26
;>     return Call_3DD0(4)
	ld a, $04
	jp Call_3DD0


.lost
;> if lost != 2:
	cp $02
	jr z, .head
;>@two     Call_3D26(PokeySpritesTwoParts + hActiveEntitySpriteVariant * 16, 4)
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
	call Call_3D26
;>     return Call_3DD0(2)
	ld a, $02
	jp Call_3DD0


.head
;>@hd Call_3D26(PokeySpritesHead + hActiveEntitySpriteVariant * 8, 2)
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
	jp Call_3D26


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
;> Call_3C3B(PokeySegmentSprites)            # draw it
	ld de, PokeySegmentSprites
	call Call_3C3B
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> ApplyRecoilIfNeeded_15(slot)
	call ApplyRecoilIfNeeded_15
;> if wEntityTimer[slot] == 0: Call_3BB4()    # contact with Link and his weapons
	call GetEntityTimer
	jr nz, .fly
	call Call_3BB4

.fly
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> Call_3B9E()                                # background collision
	call Call_3B9E
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
;> Call_3C3B(FlameShooterSprites)            # draw it
	ld de, FlameShooterSprites
	call Call_3C3B
;>@fp Call_3B87(1 if wEntityTimer1[slot] else 0)   # firing frame
	call GetEntityTimer1
	ld e, $00
	and a
	jr z, .pose
	inc e

.pose
;=@fp
	ld a, e
	call Call_3B87
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
;> flame = Call_3C01(0xE2)
	ld a, $e2
	call Call_3C01
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
;> Call_3C3B(FlameSprites)                   # draw it
	ld de, FlameSprites
	call Call_3C3B
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> Call_3BEB()                                # weapons hit it
	call Call_3BEB
;> before = wInvincibilityCounter
	ld a, [wInvincibilityCounter]
	push af
;> Call_3BD5()                                # touching Link hurts him
	call Call_3BD5
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
;>     Call_3C30(0x30)                        # vector towards Link
	ld a, $30
	call Call_3C30
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
;>         small = Call_3C01(0xE2)
	ld a, $e2
	call Call_3C01
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
;> Call_3C3B(SmallFlameSprites)              # draw it
	ld de, SmallFlameSprites
	call Call_3C3B
;> ReturnIfNonInteractive_15()
	call ReturnIfNonInteractive_15
;> UpdateEntityPosWithSpeed_15(slot)
	call UpdateEntityPosWithSpeed_15
;> if wEntityTimer[slot] == 0: return ClearEntityStatus_15(slot)
	call GetEntityTimer
	jp z, ClearEntityStatus_15
	ret


EvasiveStalfosSprites::
	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

EvasiveStalfosWalkSpeeds::
	db $00, $06, $fa, $fa
	db $06

EvasiveStalfosBoneSprites::
	db $48, $00, $48, $60, $48, $40, $48, $20

EvasiveStalfosHandler::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_4f03

	ld de, $4ea3
	call Call_3C3B
	call ReturnIfNonInteractive_15
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jp nz, EvasiveStalfosBoneBreak

	call Call_3BB4
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_4ef4

EvasiveStalfosBoneBreak:
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $07
	ldh [hJingle], a
	ld a, $05
	call AddTransientVfx
	jp ClearEntityStatus_15


jr_015_4ef4:
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_15

	ldh a, [hActiveEntityDrawY]
	cp $84
	jp nc, ClearEntityStatus_15

	ret


jr_015_4f03:
	ld de, $4e92
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call ApplyRecoilIfNeeded_15
	call GetEntityTimer
	jr nz, jr_015_4f17

	call Call_3BB4

jr_015_4f17:
	call GetEntityTimer1
	cp $01
	jr nz, jr_015_4f65

	ldh a, [hMapId]
	cp $03
	ret c

	ld a, $1e
	call Call_3C01
	ret c

	ld a, $0a
	ldh [hNoiseSfx], a
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], b
	ld hl, wEntityPhysicsFlags
	add hl, de
	set 6, [hl]
	set 4, [hl]
	ld hl, wEntityOptions1
	add hl, de
	set 1, [hl]
	set 4, [hl]
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
	push bc
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_015_4f65:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	rst $00

EvasiveStalfosSteps::
	dw EvasiveStalfosWalk
	dw EvasiveStalfosDodgeJump

EvasiveStalfosWalk::
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_015_4fc3

	call GetEntityXDistanceToLink_15
	add $24
	cp $48
	jr nc, jr_015_4fc3

	call GetEntityYDistanceToLink_15
	add $24
	cp $48
	jr nc, jr_015_4fc3

	call GetEntityTimer
	ld [hl], $08
	call GetEntityTimer1
	ld [hl], b
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $15
	ld a, $24
	ldh [hJingle], a
	ld a, $12
	call Call_3C30
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
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $02
	ret


jr_015_4fc3:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_015_4fdb

	ld a, [hl]
	and $0c
	jr z, jr_015_4fe3

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jr jr_015_4fe3

jr_015_4fdb:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a

jr_015_4fe3:
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_4ff2

	call GetRandomByte
	and $2f
	jr nz, jr_015_501f

jr_015_4ff2:
	xor a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $4e9e
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	and a
	jr nz, jr_015_501f

	call GetRandomByte
	and $01
	add $03
	ld e, a
	ld d, b
	ld hl, $4e9e
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_015_501f:
	ld hl, wEntityState
	add hl, bc
	xor a
	ld [hl], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


EvasiveStalfosDodgeJump::
	call UpdateEntityPosWithSpeed_15
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	push hl
	ld [hl], $01
	call Call_3B9E
	pop hl
	ld [hl], b
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_506d

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $08
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	call GetEntityTimer1
	ld [hl], $10

jr_015_506d:
	ret


FinalNightmareFormTilesets::
	db $ea, $eb, $ea, $eb, $ec, $ed, $ee, $ef, $f0, $f1, $f2, $f3

LoadFinalNightmareFormTiles::
	ld a, [wFinalNightmareForm]
	rla
	and $fe
	ld e, a
	ld d, b
	ld hl, $506e
	add hl, de
	ld a, [hli]
	ld [$c195], a
	ld a, [hl]
	ld [$c196], a
	ld a, $01
	ldh [hNeedsUpdatingEnemiesTiles], a
	ld [wNeedsUpdatingNPCTiles], a
	ret


Call_15_5096::
	ld a, [wRoomTransitionState]
	and a
	jr nz, jr_015_50a9

	ld a, [wRoomEntitySetupDone]
	and a
	jr nz, jr_015_50a9

	inc a
	ld [wRoomEntitySetupDone], a
	call LoadFinalNightmareFormTiles

jr_015_50a9:
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, FinalNightmareExit

	and a
	jp nz, Jump_015_54d0

	ld a, [wFinalNightmareForm]
	rst $00

JumpTable_15_50BB::
	dw Jump_15_50C7
	dw Jump_15_51FE
	dw Jump_15_5741
	dw Jump_15_5FE4
	dw Jump_15_63D8
	dw Jump_15_6E4A

Jump_15_50C7::
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_50CA::
	dw Jump_15_50D8
	dw Jump_15_5135
	dw Jump_15_5150
	dw Jump_15_516C
	dw Jump_15_5189
	dw Jump_15_51AD
	dw Jump_15_51D3

Jump_15_50D8::
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_015_5134

	ld a, $5d
	ld [wMusicTrackToPlay], a
	ld hl, $da74
	set 6, [hl]
	ld a, $f5
	call OpenDialog
	call GetEntityTimer
	ld [hl], $50
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld e, $80
	ld hl, wEntityWorkRAM

jr_015_50fe:
	ld [hli], a
	dec e
	jr nz, jr_015_50fe

	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ld e, $80
	ld hl, wEntityWorkRAM2

jr_015_510e:
	ld [hli], a
	dec e
	jr nz, jr_015_510e

	xor a
	ld [$d21a], a
	ld [$d21b], a
	ld [$d21c], a
	ld [$d21d], a
	ld [$d21e], a
	ld [$d21f], a
	ld [$d220], a
	ld [$d221], a
	ld [$d222], a
	ld [$d223], a
	call Call_3B8D

jr_015_5134:
	ret


Jump_15_5135::
	call Call_15_562D
	call GetEntityTimer
	jr nz, jr_015_5145

	call Call_3B8D

Call_15_5140::
	ld a, $35
	ldh [hJingle], a
	ret


jr_015_5145:
	cp $30
	jr nz, jr_015_514f

	dec [hl]
	ld a, $23
	ld [wMusicTrackToPlay], a

jr_015_514f:
	ret


Jump_15_5150::
	call Call_15_562D
	call ReturnIfNonInteractive_15
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
	ld a, [hl]
	cp $e8
	jr nz, jr_015_5168

	call GetEntityTimer
	ld [hl], $08
	call Call_3B8D

jr_015_5168:
	call AddEntitySpeedToPosY_15
	ret


Jump_15_516C::
	call Call_15_562D
	call ReturnIfNonInteractive_15
	call AddEntitySpeedToPosY_15
	call GetEntityTimer
	ret nz

	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	jr nz, jr_015_5188

	call GetEntityTimer
	ld [hl], $80
	call Call_3B8D

jr_015_5188:
	ret


Jump_15_5189::
	call Call_15_562D
	call GetEntityTimer
	jr z, jr_015_519f

	and $07
	jr nz, jr_015_519f

	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	cp $05
	jr z, jr_015_51a0

	inc [hl]

jr_015_519f:
	ret


jr_015_51a0:
	call GetEntityTimer
	ld [hl], $c0
	call Call_3B8D
	ret


	db $06, $05, $07, $05

Jump_15_51AD::
	call Call_15_569B
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $51a9
	add hl, de
	ld a, [hl]
	call Call_3B87
	call GetEntityTimer
	jr nz, jr_015_51cc

	ld [hl], $2f
	call Call_3B8D

jr_015_51cc:
	ret


	db $08, $00, $01, $02, $03, $04

Jump_15_51D3::
	call Call_15_569B
	call GetEntityTimer
	jr nz, jr_015_51ee

	ld hl, wFinalNightmareForm
	inc [hl]
	xor a
	call Call_3B87
	call Call_3B8D
	ld [hl], b
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
	ret


jr_015_51ee:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $51cd
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_15_51FE::
	call Call_15_5728
	call ReturnIfNonInteractive_15
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_520A::
	dw Jump_15_521E
	dw Jump_15_522B
	dw Jump_15_524F
	dw Jump_15_52AE
	dw Jump_15_52CF
	dw Jump_15_52DD
	dw Jump_15_539A
	dw Jump_15_540B
	dw Jump_15_5340
	dw Jump_15_535A

Jump_15_521E::
	call GetEntityTimer
	ld [hl], $80
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	jp Call_3B8D


Jump_15_522B::
	call GetEntityTimer
	jr nz, jr_015_524e

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_015_524e

	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, jr_015_524e

	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $28
	ld a, $08
	call Call_3C25
	call Call_3B8D

jr_015_524e:
	ret


Jump_15_524F::
	call Call_15_545F
	call Call_3BB4
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_529d

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $01
	jr nz, jr_015_5291

	call GetRandomByte
	and $01
	jr nz, jr_015_5291

	call GetEntityTimer
	ld [hl], $1f
	call Call_3B8D
	ld [hl], $08
	jr jr_015_529d

jr_015_5291:
	ld a, $20
	ldh [hJingle], a
	call GetEntityTimer
	ld [hl], $30
	call Call_3B8D

jr_015_529d:
	ld e, $03
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $0c
	jr c, jr_015_52a9

	inc e

jr_015_52a9:
	ld a, e
	call Call_3B87
	ret


Jump_15_52AE::
	ld a, $05
	call Call_3B87
	call GetEntityTimer
	jr nz, jr_015_52c8

	ld a, $0c
	call Call_3C25
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	call Call_3B8D
	dec [hl]
	dec [hl]

jr_015_52c8:
	call Call_15_545F
	call Call_3BB4
	ret


Jump_15_52CF::
	call GetEntityTimer
	jr nz, jr_015_52d7

	jp Jump_015_535f


jr_015_52d7:
	ret


Call_15_52D8::
	ld a, $23
	ldh [hWaveSfx], a
	ret


Jump_15_52DD::
	call GetEntityTimer
	jr nz, jr_015_5326

Call_15_52E2::
	ld a, [wFinalNightmareForm]
	inc a
	ld [wFinalNightmareForm], a
	call LoadFinalNightmareFormTiles
	xor a
	ld [$d221], a
	ld [$d222], a
	ld [$d223], a
	ld [$d220], a
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c0
	ld a, $02
	ld [wEntityTilesSlotA], a
	inc a
	ld [wEntityTilesSlotB], a
	ld a, $ff
	call Call_3B87
	call GetEntityTimer
	ld [hl], $40
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
	call Call_3B8D
	ld [hl], b
	ld a, $01
	ld [$d21a], a
	ret


jr_015_5326:
	cp $18
	jr nc, jr_015_533b

	cp $17
	jr nz, jr_015_5333

	ld hl, hJingle
	ld [hl], $35

jr_015_5333:
	rra
	rra
	rra
	and $03
	call Call_3B87

jr_015_533b:
	ret


	db $ff, $00, $01, $02

Jump_15_5340::
	call GetEntityTimer
	jr nz, jr_015_534a

	ld [hl], $80
	jp Call_3B8D


jr_015_534a:
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $533c
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_15_535A::
	call GetEntityTimer
	jr nz, jr_015_537f

Jump_015_535f:
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $5913
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, $591b
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ld [hl], $01

jr_015_537f:
	ret


	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $18, $20, $18, $00, $e8, $e0, $e8, $00, $18

Jump_15_539A::
	ld a, $ff
	call Call_3B87
	call GetEntityTimer
	ld [hl], $80
	call Call_3B8D
	ld [hl], $04
	ld a, $21
	ldh [hWaveSfx], a

Call_15_53AD::
	xor a

jr_015_53ae:
	ldh [hBGTilesRequestCopy], a
	ld a, $e6
	call Call_3C01
	ret c

	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ldh a, [hMultiPurpose0]
	ld hl, $5380
	add hl, bc
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, $5388
	add hl, bc
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
	ld hl, $5392
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $5390
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $2f
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
	ld hl, wEntityPrivate5
	add hl, de
	inc [hl]
	pop bc
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $08
	jr nz, jr_015_53ae

	ret


	db $05, $03, $04, $03

Jump_15_540B::
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_5423

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_015_5423:
	call GetEntityTimer
	jr z, jr_015_5438

	rra
	nop
	nop
	nop
	and $03
	ld e, a
	ld d, b
	ld hl, $5407
	add hl, de
	ld a, [hl]
	jp Call_3B87


jr_015_5438:
	ld a, [$d220]
	inc a
	ld [$d220], a
	cp $03
	jr nc, jr_015_5449

	call Call_3B8D
	ld [hl], $02
	ret


jr_015_5449:
	ld a, $06
	call Call_3B87
	call GetEntityTimer
	ld [hl], $80
	call Call_3B8D
	ld [hl], $05

Call_15_5458::
	ld a, $37
	ldh [hNoiseSfx], a
	jp Call_15_53AD


Call_15_545F::
	ld e, $0f
	ld d, b

jr_015_5462:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_015_54b1

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_54b1

	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_54b1

	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_015_54b1

	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_015_54b1

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $14
	ld a, $07
	ldh [hWaveSfx], a
	ld a, $37
	ldh [hJingle], a
	call Call_3B8D
	ld [hl], $07
	call GetEntityTimer
	ld [hl], $80
	pop af
	ret


jr_015_54b1:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_015_5462

	ret


	db $4e, $00, $4e, $20, $4c, $00, $4c, $20, $4a, $00, $4a, $20, $02, $02, $02, $01
	db $01, $00, $0f, $07, $03, $01, $00, $00

Jump_015_54d0:
	ld de, $54b8
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call GetEntityTimer
	jp z, ClearEntityStatus_15

	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $54c4
	add hl, de
	push de
	ld a, [hl]
	call Call_3B87
	pop de
	ld hl, $54ca
	add hl, de
	ldh a, [hFrameCounter]
	and [hl]
	jr nz, jr_015_54fc

	call UpdateEntityPosWithSpeed_15

jr_015_54fc:
	ret


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
	db $4c, $00, $4c, $20, $48, $00, $48, $20, $28, $23, $1e, $19, $14, $0f, $0a, $05

Call_15_562D::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
	xor a

jr_015_5635:
	ldh [hBGTilesRequestCopy], a
	ld e, a
	ld d, b
	ld hl, $5625
	add hl, de
	ldh a, [hMultiPurposeH]
	sub [hl]
	and $7f
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld de, $5621
	ldh a, [hBGTilesRequestCopy]
	cp $00
	jr z, jr_015_5667

	ld hl, wEntityY
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr z, jr_015_5672

	ld de, $561d

jr_015_5667:
	xor a
	ldh [hActiveEntitySpriteVariant], a
	call Call_3C3B
	ld a, $02
	call Call_3DD0

jr_015_5672:
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $08
	jr nz, jr_015_5635

	call Call_3DBA
	call Call_15_569B
	call ReturnIfNonInteractive_15
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $7f
	ld e, a
	ld d, b
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld [hl], a
	ldh a, [hActiveEntityX]
	ld hl, wEntityWorkRAM
	add hl, de
	ld [hl], a
	ret


Call_15_569B::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $54fd
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $00, $00, $4a, $00, $00, $08, $4a, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $4c, $00, $00, $08, $4c, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $00, $00, $ff, $00, $00, $00, $ff, $20
	db $f0, $00, $5c, $00, $f0, $08, $5c, $20, $00, $00, $5e, $00, $00, $08, $5e, $20
	db $f0, $00, $44, $00, $f0, $08, $44, $20, $00, $00, $44, $40, $00, $08, $44, $60
	db $00, $fc, $40, $00, $00, $04, $42, $00, $00, $0c, $40, $20, $00, $00, $ff, $00
	db $00, $00, $48, $00, $00, $08, $48, $20, $00, $00, $ff, $00, $00, $00, $ff, $20

Call_15_5728::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $56b8
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ret


Jump_15_5741::
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_015_5de0

	and a
	jp nz, Jump_015_5df8

	ld a, c
	ld [wSmasherBallSlot], a
	ld a, [$d21a]
	and a
	jr nz, jr_015_575c

	call Call_15_5A6E

jr_015_575c:
	call ReturnIfNonInteractive_15
	call ApplyRecoilIfNeeded_15
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_5765::
	dw Jump_15_5779
	dw Jump_15_57CE
	dw Jump_15_580B
	dw Jump_15_5855
	dw Jump_15_58EE
	dw Jump_15_5928
	dw Jump_15_5965
	dw Jump_15_59BC
	dw Jump_15_5A0A
	dw Jump_15_5A25

Jump_15_5779::
	xor a
	call Call_3B87
	call Call_15_5728
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, $50
	ldh [hLinkX], a
	ld a, $30
	ldh [hLinkY], a
	ld a, $10
	call Call_3C25
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_57b5

	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_57b5

	call GetEntityTimer
	ld [hl], $50
	call Call_3B8D
	ld [hl], $01

jr_015_57b5:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_15
	ret


	db $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_15_57CE::
	call GetEntityTimer
	jr z, jr_015_57e4

	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $57bf
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	jp Call_15_5728


jr_015_57e4:
	xor a
	ld [$d21a], a
	call Call_15_5819
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	call GetEntityTimer
	ld [hl], $40
	call Call_3B8D
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	inc [hl]
	call Call_15_52D8
	ret


	db $0f, $0a, $05, $00

Jump_15_580B::
	call GetEntityTimer
	jr nz, Call_15_5819

	ld a, $22
	ldh [hWaveSfx], a
	ld [hl], $c0
	jp Call_3B8D


Call_15_5819::
	call GetEntityDirectionToLink_15
	ld a, e
	ld [$d21e], a
	ld d, b
	ld hl, $5807
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

Call_15_582B::
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
	call Call_3B87
	ret


	db $00, $01, $02, $03, $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01
	db $00, $00, $00, $00, $18, $e8, $00, $00, $00, $00, $f0, $00

Jump_15_5855::
	call GetEntityTimer
	jr nz, jr_015_58c1

	ld [$d21d], a
	ld [hl], $50
	ld a, $e6
	call Call_3C01
	ld hl, wEntityPrivate4
	add hl, de
	inc [hl]
	push bc
	ld a, [$d21e]
	ld c, a
	ld hl, $584d
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $5851
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], d
	ld a, $38
	ldh [hNoiseSfx], a
	ld a, [$d220]
	cp $02
	jr c, jr_015_58b6

	ldh a, [hLinkX]
	ld hl, hFrameCounter
	add [hl]
	and $01
	jr nz, jr_015_58b6

	ld hl, wEntityState
	add hl, de
	ld [hl], $03
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $1c
	ld a, $39
	ldh [hNoiseSfx], a

jr_015_58b6:
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc
	jp Call_3B8D


jr_015_58c1:
	rra
	rra
	rra
	and $03
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	rra
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $583d
	add hl, de
	ld a, [hl]
	ld [$d21d], a
	call GetEntityTimer
	cp $40
	jp c, Call_15_582B

	and $1f
	jp z, Call_15_5819

	jp Call_15_582B


Jump_15_58EE::
	call GetEntityTimer
	jr nz, jr_015_5909

	ld [hl], $27
	ld a, $35
	ldh [hJingle], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ld a, $01
	ld [$d21a], a
	jp Call_3B8D


jr_015_5909:
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $04
	call Call_15_582B
	ret


	db $50, $28, $78, $18, $88, $38, $68, $50, $30, $30, $30, $50, $50, $70, $70, $74
	db $00, $01, $02, $03, $04

Jump_15_5928::
	call GetEntityTimer
	jr nz, jr_015_594c

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $5913
	add hl, de
	ld a, [hl]
	ld [$d21b], a
	ld hl, $591b
	add hl, de
	ld a, [hl]
	ld [$d21c], a
	call GetEntityTimer
	ld [hl], $1f
	jp Call_3B8D


jr_015_594c:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $5923
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	jp Call_15_5728


	db $18, $14, $10, $0c, $08, $05, $02, $01

Jump_15_5965::
	xor a
	ldh [hActiveEntitySpriteVariant], a
	call Call_15_5728
	ldh a, [hLinkY]
	push af
	ldh a, [hLinkX]
	push af
	ld a, [$d21b]
	ldh [hLinkX], a
	ld a, [$d21c]
	ldh [hLinkY], a
	call GetEntityTimer
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $595d
	add hl, de
	ld a, [hl]
	call Call_3C25
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_59ae

	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_59ae

	call GetEntityTimer
	ld [hl], $50
	call Call_3B8D
	ld [hl], $01

jr_015_59ae:
	pop af
	ldh [hLinkX], a
	pop af
	ldh [hLinkY], a
	call UpdateEntityPosWithSpeed_15
	ret


	db $00, $0a, $0f, $05

Jump_15_59BC::
	call GetEntityTimer
	jr nz, jr_015_59d7

	call Call_15_5458
	ld a, $01
	ld [$d21a], a
	ld a, $06
	call Call_3B87
	call GetEntityTimer
	ld [hl], $50
	call Call_3B8D
	ret


jr_015_59d7:
	ld a, [$d221]
	cp $80
	jr nc, jr_015_59e2

	inc a
	ld [$d221], a

jr_015_59e2:
	ld a, [$d221]
	ld hl, $d222
	add [hl]
	ld [hl], a
	jr nc, jr_015_59f0

	ld hl, $d223
	inc [hl]

jr_015_59f0:
	ld a, [$d223]
	and $03
	ld e, a
	ld d, b
	ld hl, $59b8
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
	call Call_15_582B
	ret


Jump_15_5A0A::
	call GetEntityTimer
	jr nz, jr_015_5a15

	call Call_15_5140
	jp Call_3B8D


jr_015_5a15:
	cp $18
	jr nc, jr_015_5a21

	rra
	rra
	rra
	and $03
	call Call_3B87

jr_015_5a21:
	call Call_15_5728
	ret


Jump_15_5A25::
	call Call_15_5728
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, $50
	ldh [hLinkX], a
	ld a, $30
	ldh [hLinkY], a
	ld a, $10
	call Call_3C25
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_5a64

	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_5a64

	call Call_15_52E2
	call GetEntityTimer
	ld [hl], $31
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
	call Call_15_5FA7

jr_015_5a64:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_15
	ret


Call_15_5A6E::
	call Call_15_5D97
	call Call_15_5B34
	call Call_15_5B13
	call Call_15_5D51
	ret


	db $6a, $00, $6c, $00, $6c, $20, $6a, $20, $6a, $00, $ff, $ff, $6a, $20, $ff, $ff
	db $00, $00, $6a, $00, $08, $08, $7a, $00, $08, $00, $7a, $20, $00, $08, $6a, $20
	db $00, $00, $00, $00, $02, $00, $00, $00, $00, $02, $04, $04, $04, $04, $04, $05
	db $05, $05, $05, $05, $f0, $f3, $f3, $f0, $f5, $f0, $f3, $f3, $f0, $f5, $f1, $f0
	db $f1, $f2, $f0, $0f, $10, $0f, $0e, $10, $ed, $ed, $f1, $f1, $fd, $ed, $ed, $f1
	db $f1, $fd, $f4, $f6, $f7, $f6, $f8, $f4, $f6, $f7, $f6, $f8, $01, $01, $01, $01
	db $03, $01, $01, $01, $01, $03, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03
	db $10, $0d, $0d, $10, $13, $10, $0d, $0d, $10, $13, $f5, $f6, $f5, $f4, $f3, $13
	db $12, $13, $14, $15, $ed, $ed, $f1, $f1, $fd, $ed, $ed, $f1, $f1, $fd, $eb, $ec
	db $ed, $ec, $f2, $eb, $ec, $ed, $ec, $f2

Call_15_5B13::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $5aeb
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $5aff
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add $08
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, $5ad7
	add hl, de
	jr jr_015_5b53

Call_15_5B34::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $5aaf
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $5ac3
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add $08
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, $5a9b
	add hl, de

jr_015_5b53:
	ld a, [hl]
	cp $04
	jr nc, jr_015_5b62

	ldh [hActiveEntitySpriteVariant], a
	ld de, $5a7b
	call Call_3C3B
	jr jr_015_5b74

jr_015_5b62:
	sub $04
	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
	ld hl, $5a8b
	add hl, de
	ld c, $02
	call Call_3D26

jr_015_5b74:
	ld a, $02
	call Call_3DD0
	call Call_3DBA
	ret


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
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0a, $0a, $0a, $0b, $0c
	db $0c, $0c, $0c, $0d

Call_15_5D51::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $5d3d
	add hl, de
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, $5b7d
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $1e, $00, $1e, $60, $7c, $00, $7c, $20, $7e, $00, $7e, $20, $14, $ec, $00, $00
	db $00, $00, $f0, $04

Call_15_5D97::
	ldh a, [hActiveEntityFlipAttribute]
	push af
	call Call_15_5DA1
	pop af
	ldh [hActiveEntityFlipAttribute], a
	ret


Call_15_5DA1::
	ld a, [$d21d]
	and a
	ret z

	dec a
	ldh [hActiveEntitySpriteVariant], a
	ldh a, [hFrameCounter]
	rla
	rla
	rla
	and $50
	ldh [hActiveEntityFlipAttribute], a
	ld a, [$d21e]
	ld e, a
	ld d, b
	ld hl, $5d8f
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hActiveEntityX], a
	ld hl, $5d93
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld de, $5d83
	call Call_3C3B
	ld a, $02
	call Call_3DD0
	call Call_3DBA
	ret


	db $46, $00, $46, $60, $70, $00, $ff, $ff

Jump_015_5de0:
	ld de, $5dd8
	ret


	db $7e, $00, $7e, $20, $7c, $00, $7c, $20, $1e, $00, $1e, $60, $58, $00, $58, $20
	db $5a, $00, $5a, $20

Jump_015_5df8:
	ldh a, [hFrameCounter]
	rla
	rla
	rla
	and $50
	ldh [hActiveEntityFlipAttribute], a
	ld de, $5de4
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	cp $04
	jr nz, jr_015_5e30

	call GetEntityTimer1
	jp z, ClearEntityStatus_15

	xor c
	bit 0, a
	ld e, $ff
	jr z, jr_015_5e2b

	call GetEntityTimer1
	ld e, $01
	cp $08
	jr nc, jr_015_5e2b

	ld e, $02

jr_015_5e2b:
	ld a, e
	call Call_3B87
	ret


jr_015_5e30:
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_5E39::
	dw Jump_15_5E41
	dw Jump_15_5E91
	dw Jump_15_5EB9
	dw Jump_15_5F2F

Jump_15_5E41::
	call Call_3BB4

Call_15_5E44::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $03
	jr nz, jr_015_5e85

	ld a, $e6
	call Call_3C01
	ret c

	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], d
	ld hl, wEntityPrivate4
	add hl, de
	inc [hl]
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $01
	ld hl, wEntityState
	add hl, de
	ld [hl], $04

jr_015_5e85:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_5e90

	jp ClearEntityStatus_15


jr_015_5e90:
	ret


Jump_15_5E91::
	ld a, $08
	ldh [hNoiseSfx], a
	ld a, $18
	call Call_3C30
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld a, $10
	ld [wLinkPushedTimer], a
	call Call_3B8D
	ret


Jump_15_5EB9::
	call Call_15_5E44
	ld a, [$d21a]
	and a
	ret nz

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_5f26

	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_015_5f26

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, wEntityRecoilSpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, wEntityRecoilSpeedY
	add hl, de
	ld [hl], a
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], $12
	call ClearEntityStatus_15
	ld a, [$d220]
	inc a
	ld [$d220], a
	cp $04
	jr c, jr_015_5f1c

	ld hl, wEntityState
	add hl, de
	ld [hl], $07
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $c0
	ld a, $36
	ldh [hJingle], a

jr_015_5f1c:
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $14
	ld a, $07
	ldh [hWaveSfx], a

jr_015_5f26:
	ret


	db $20, $20, $e0, $e0, $20, $e0, $20, $e0

Jump_15_5F2F::
	call Call_3BBF
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $03
	call Call_3B87
	call GetEntityTimer
	jr z, jr_015_5f4c

	and $01
	jr nz, jr_015_5f4c

	ld a, $18
	call Call_3C25

jr_015_5f4c:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_5fa6

	ld a, $36
	ldh [hNoiseSfx], a
	xor a

jr_015_5f59:
	ldh [hBGTilesRequestCopy], a
	ld a, $7d
	call Call_3C01
	jr c, jr_015_5fa3

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
	push bc
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, $5f27
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $5f2b
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	pop bc
	ldh a, [hBGTilesRequestCopy]
	inc a
	cp $04
	jr nz, jr_015_5f59

jr_015_5fa3:
	jp ClearEntityStatus_15


jr_015_5fa6:
	ret


Call_15_5FA7::
	ld e, $80
	ld hl, wEntityWorkRAM2

jr_015_5fac:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_015_5fac

	ret


	db $03, $03, $05, $05, $00, $00, $04, $04, $02, $02, $06, $06, $01, $01, $07, $07
	db $00, $06, $0c, $0e, $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa
	db $00, $06, $0c, $0e, $06, $07, $00, $01, $02, $03, $04, $05

Call_15_5FDE::
	call ReturnIfNonInteractive_15
	jp Call_3BB4


Jump_15_5FE4::
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_5FE7::
	dw Jump_15_6057
	dw Jump_15_60E3
	dw Jump_15_60D0
	dw Jump_15_609A

	db $00, $00, $4a, $00, $00, $08, $4a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $4c, $00, $00, $08, $4c, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $f8, $78, $00, $f8, $00, $7a, $00
	db $f8, $08, $7a, $20, $00, $10, $78, $20, $08, $00, $7c, $00, $08, $08, $7c, $20
	db $03, $03, $02, $01, $00, $00, $00, $00

Jump_15_6057::
	xor a
	ldh [hActiveEntitySpriteVariant], a
	call GetEntityTimer
	jr nz, jr_015_6062

	jp Call_3B8D


jr_015_6062:
	cp $20
	jr nz, jr_015_606c

	dec [hl]
	call Call_15_52D8
	ld a, $20

jr_015_606c:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $604f

jr_015_6076:
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
	ld hl, $5fef
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ret


	db $00, $00, $01, $01, $02, $02, $03, $03

Jump_15_609A::
	xor a
	ldh [hActiveEntitySpriteVariant], a
	call GetEntityTimer
	jr nz, jr_015_60c4

	call Call_15_52E2
	call Call_15_5140
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $40
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $0a
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $90
	call Call_3B65
	ret


jr_015_60c4:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6092
	jr jr_015_6076

Jump_15_60D0::
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, Jump_15_60E3

	call GetEntityTimer
	ld [hl], $1f
	call Call_15_5458
	jp Call_3B8D


Jump_15_60E3::
	call Call_15_5FDE
	call Call_15_6255
	call DecrementEntityIgnoreHitsTimer
	call Call_3DBA
	call ReturnIfNonInteractive_15
	xor a
	ld [$d3d6], a
	ld e, $0c
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_610a

	call Call_15_6118
	ld a, $01
	ld [$d3d6], a
	ld e, $0c

jr_015_610a:
	ld hl, wSmasherSlot
	ld a, [hl]
	inc a
	ld [hl], a
	cp e
	jr c, Call_15_6118

	ld [hl], b
	ld a, $38
	ldh [hJingle], a

Call_15_6118::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $7f
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hActiveEntityX]
	ld [hl], a
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
	call Call_15_6341
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
	ld hl, $5fd6
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


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
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20

Call_15_6255::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $48
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6145
	add hl, de
	ld c, $08
	call Call_3D26
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $42
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ldh a, [hMultiPurpose0]
	sub $0c
	and $7f
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $00
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6245
	call Call_3C3B
	ldh a, [hMultiPurpose0]
	sub $18
	and $7f
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $00
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6245
	call Call_3C3B
	ldh a, [hMultiPurpose0]
	sub $24
	and $7f
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld a, $01
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6245
	call Call_3C3B
	ldh a, [hMultiPurpose0]
	sub $2e
	and $7f
	ld e, a
	ld d, b
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
	ldh [hActiveEntitySpriteVariant], a
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [hl], a
	ld de, $6245
	call Call_3C3B
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, jr_015_6340

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_6340

	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $90
	call Call_3BEB
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $d0
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nc, jr_015_6340

	call Call_3B8D
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $50

jr_015_6340:
	ret


Call_15_6341::
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, jr_015_6352

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_6352

	call UpdateEntityPosWithSpeed_15

jr_015_6352:
	call Call_3B9E
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_6389

	ld e, $08
	bit 0, a
	jr nz, jr_015_6371

	ld e, $00
	bit 1, a
	jr nz, jr_015_6371

	ld e, $04
	bit 2, a
	jr nz, jr_015_6371

	ld e, $0c

jr_015_6371:
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], e
	call GetRandomByte
	rra
	jr c, jr_015_6384

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_015_6384:
	call GetEntityTimer
	ld [hl], $10

jr_015_6389:
	call GetEntityTimer1
	jr nz, jr_015_63bf

	ld [hl], $06
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
	and $0f
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5fb2
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $5fc2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $5fc6
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

jr_015_63bf:
	call GetEntityTimer
	jr nz, jr_015_63d7

	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

jr_015_63d7:
	ret


Jump_15_63D8::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Jump_015_6d5d

	cp $02
	jp z, Jump_015_6d8c

	and a
	jp nz, Jump_015_6c7e

	ldh a, [hActiveEntityState]
	cp $02
	jr c, jr_015_6435

	cp $0b
	jr z, jr_015_63f9

	cp $0c
	jr nz, jr_015_6402

jr_015_63f9:
	ld a, $06
	ldh [hActiveEntitySpriteVariant], a
	call Call_15_5728
	jr jr_015_6405

jr_015_6402:
	call Call_15_6943

jr_015_6405:
	call ReturnIfNonInteractive_15
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	cp $09
	jr nc, jr_015_6435

	call Call_3BB4
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $e8
	jr nc, jr_015_6435

	call Call_3B8D
	ld [hl], $09
	ld a, $09
	ldh [hActiveEntityState], a
	ld a, $10
	ldh [hWaveSfx], a
	call GetEntityTimer
	ld [hl], $80
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $80

jr_015_6435:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_6438::
	dw Jump_15_64CC
	dw Jump_15_651F
	dw Jump_15_6565
	dw Jump_15_65B8
	dw Jump_15_662A
	dw Jump_15_66DE
	dw Jump_15_6766
	dw Jump_15_67A3
	dw Jump_15_67F7
	dw Jump_15_67F8
	dw Jump_15_680F
	dw Jump_15_6828
	dw Jump_15_68AD
	dw Jump_15_68FF

	db $00, $00, $4a, $00, $00, $08, $4a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $4c, $00, $00, $08, $4c, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $00, $5c, $00, $f0, $08, $5c, $20
	db $00, $00, $5e, $00, $00, $08, $5e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $fc, $6a, $00, $00, $04, $6c, $20, $00, $0c, $6a, $20, $f3, $fc, $50, $00
	db $f3, $04, $52, $00, $f3, $0c, $6e, $00

Jump_15_64CC::
	xor a
	ldh [hActiveEntitySpriteVariant], a
	call Call_3B87
	call Call_15_5728
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, $50
	ldh [hLinkX], a
	ld a, $30
	ldh [hLinkY], a
	ld a, $10
	call Call_3C25
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6508

	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6508

	call GetEntityTimer
	ld [hl], $60
	call Call_3B8D

jr_015_6508:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_15
	ret


	db $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_15_651F::
	call GetEntityTimer
	jr nz, jr_015_653f

	ld [$d224], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	call GetEntityTimer
	ld [hl], $08
	ld a, $04
	call Call_3B87
	call Call_15_52D8
	jp Call_3B8D


jr_015_653f:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $6512
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
	ld hl, $6454
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ret


Jump_15_6565::
	call GetEntityTimer
	jr nz, jr_015_6577

	ld [hl], $7f
	jp Call_3B8D


Call_15_656F::
	call GetEntityXDistanceToLink_15
	ld a, e
	ld [$d21e], a
	ret


jr_015_6577:
	ret


	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $02, $07, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_15_65B8::
	ld a, $00
	ld [$d21e], a
	call GetEntityTimer
	jr nz, jr_015_65cd

	call GetEntityDropTimer
	ld [hl], $4c
	call Call_15_656F
	jp Call_3B8D


jr_015_65cd:
	cp $40
	jr nz, jr_015_65d6

	ld hl, hNoiseSfx
	ld [hl], $19

jr_015_65d6:
	cp $58
	jr nz, jr_015_65df

	ld hl, hJingle
	ld [hl], $39

jr_015_65df:
	rra
	rra
	and $3f
	ld e, a
	ld d, b
	ld hl, $6598
	add hl, de
	ld a, [hl]
	ld [$d224], a
	ld hl, $6578
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld a, [$d224]
	cp $05
	jr z, jr_015_6607

	ld a, $f3
	ld [$d225], a
	ld a, $f0
	ld [$d226], a
	ret


jr_015_6607:
	ld a, $f8
	ld [$d225], a
	ld a, $fe
	ld [$d226], a
	ret


	db $03, $02, $01, $00, $00, $01, $02, $03, $e8, $00, $18, $18, $00, $e8, $e8, $00
	db $10, $18, $10, $f0, $e8, $f0, $10, $18

Jump_15_662A::
	call GetEntityDropTimer
	jr nz, jr_015_663a

	ld [$d221], a
	call GetEntityTimer
	ld [hl], $30
	jp Call_3B8D


jr_015_663a:
	ld a, [$d21e]
	and a
	ld a, $f5
	jr z, jr_015_6644

	ld a, $0b

jr_015_6644:
	ld [$d225], a
	ld a, $ee
	ld [$d226], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	and $01
	call Call_3B87
	ld a, [$d21e]
	and a
	ld hl, $6612
	jr z, jr_015_6663

	ld hl, $6616

jr_015_6663:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	nop
	and $03
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	inc a
	ld [$d224], a
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_015_66d9

	ld a, [$d221]
	cp $06
	jr nc, jr_015_66d9

	ld a, $e6
	call Call_3C01
	ret c

	ld hl, wEntityTimer
	add hl, de
	ld [hl], $30
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	push bc
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
	push de
	push de
	pop bc
	call Call_3B65
	pop de
	ld a, [$d21e]
	and a
	ld a, [$d221]
	jr nz, jr_015_66b2

	xor $07

jr_015_66b2:
	ld c, a
	ld hl, $6622
	add hl, bc
	ld a, [$d225]
	add [hl]
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $661a
	add hl, bc
	ld a, [hl]
	sub $0c
	ld hl, hMultiPurpose1
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, $d221
	inc [hl]
	pop bc

jr_015_66d9:
	ret


	db $0b, $0a, $02, $0a

Jump_15_66DE::
	ld a, [$d21e]
	and a
	ld a, $fd
	jr z, jr_015_66e8

	ld a, $03

jr_015_66e8:
	ld [$d225], a
	ld a, $ec
	ld [$d226], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	nop
	and $03
	ld e, a
	ld d, b
	ld hl, $66da
	add hl, de
	ld a, [hl]
	inc a
	ld [$d224], a
	call GetEntityTimer
	jr nz, jr_015_6760

	ld [hl], $40
	xor a
	ld [$d224], a
	call Call_3B8D
	ld a, $e6
	call Call_3C01
	jr c, jr_015_6760

	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
	ldh a, [hMultiPurpose1]
	sub $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld a, [$d21e]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	and a
	ld a, $08
	jr nz, jr_015_6736

	ld a, $f8

jr_015_6736:
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $40
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $08
	push bc
	push de
	pop bc
	call Call_3B65
	ld a, $18
	call Call_3C25
	call GetEntityTimer
	ld [hl], $30
	ld a, $27
	ldh [hNoiseSfx], a
	pop bc

jr_015_6760:
	ld a, $02
	call Call_3B87
	ret


Jump_15_6766::
	call GetEntityTimer
	jr nz, jr_015_677d

	ld [hl], $1f
	call GetRandomByte
	and $07
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	call Call_15_5140
	call Call_3B8D

jr_015_677d:
	ld a, $03
	call Call_3B87
	ret


	db $28, $50, $78, $28, $78, $28, $50, $78, $20, $28, $20, $30, $30, $50, $50, $50
	db $20, $1e, $1c, $1a, $18, $16, $14, $12, $10, $0e, $0c, $0a, $08, $06, $04, $02

Jump_15_67A3::
	ld a, $04
	call Call_3B87
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6783
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
	ld hl, $678b
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
	call GetEntityTimer
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $6793
	add hl, de
	ld a, [hl]
	call Call_3C25
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_67ed

	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_67ed

	call Call_3B8D

jr_015_67ed:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_15
	ret


Jump_15_67F7::
	ret


Jump_15_67F8::
	call GetEntityTimer
	jr nz, jr_015_680e

	ld [hl], $40
	call Call_15_5458
	call Call_3B8D
	ld a, $00
	call Call_3B87
	xor a
	ld [$d224], a

jr_015_680e:
	ret


Jump_15_680F::
	ld a, $06
	ldh [hActiveEntitySpriteVariant], a
	call Call_15_5728
	call GetEntityTimer
	jr nz, jr_015_6827

	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 6, [hl]
	call Call_3B8D
	call Call_3DAF

jr_015_6827:
	ret


Jump_15_6828::
	call Call_3BB4
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_015_6856

	ld a, $18
	call Call_3C30
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	sub [hl]
	bit 7, a
	jr z, jr_015_6848

	dec [hl]
	dec [hl]

jr_015_6848:
	inc [hl]
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	sub [hl]
	bit 7, a
	jr z, jr_015_6855

	dec [hl]
	dec [hl]

jr_015_6855:
	inc [hl]

jr_015_6856:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_6876

	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
	call GetEntityTimer
	ld [hl], $80
	call ResetSoundEngine
	ld a, $10
	ldh [hWaveSfx], a
	call Call_15_53AD
	jp Call_3B8D


jr_015_6876:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $07
	ret nz

	ld a, $e6
	call Call_3C01
	ret c

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $1f
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $01
	ret


Jump_15_68AD::
	call GetEntityTimer
	cp $01
	jr nz, jr_015_68b8

	dec [hl]
	jp Call_15_5140


jr_015_68b8:
	and a
	ret nz

	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, $50
	ldh [hLinkX], a
	ld a, $30
	ldh [hLinkY], a
	ld a, $0c
	call Call_3C25
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_68ed

	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_68ed

	call GetEntityTimer
	ld [hl], $5f
	call Call_3B8D

jr_015_68ed:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_15
	ret


	db $00, $00, $00, $01, $01, $01, $02, $02

Jump_15_68FF::
	call GetEntityTimer
	jr nz, jr_015_692c

	call Call_3DAF
	call Call_15_52E2
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $00
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $c0
	call GetEntityDropTimer
	ld [hl], $90
	xor a
	ld [$d223], a
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $3f
	ret


jr_015_692c:
	cp $20
	jr c, jr_015_6932

	ld a, $1f

jr_015_6932:
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $68f7
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	call Call_15_5728
	ret


Call_15_6943::
	ldh a, [hActiveEntityState]
	cp $0a
	ret nc

	ldh a, [hActiveEntitySpriteVariant]
	inc a
	ret z

	ld a, [$d21e]
	and a
	ldh a, [hActiveEntitySpriteVariant]
	jr z, jr_015_6956

	add $05

jr_015_6956:
	ldh [hActiveEntitySpriteVariant], a
	call Call_15_69EC
	call Call_15_6A84
	call Call_15_6C2C
	ret


	db $f8, $fc, $50, $00, $f8, $04, $52, $00, $f8, $0c, $6e, $00, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $fb, $fe, $50, $00, $fb, $06, $52, $00, $fb, $0e, $6e, $00, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $f8, $fc, $6e, $20, $f8, $04, $52, $20, $f8, $0c, $50, $20, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $fb, $fa, $6e, $20, $fb, $02, $52, $20, $fb, $0a, $50, $20, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $00, $00, $02, $01, $00, $02, $02, $00, $03, $02

Call_15_69EC::
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, $69e2
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $70
	ld e, a
	ld hl, $6962
	add hl, de
	ld c, $07
	call Call_3D26
	ld a, $07
	call Call_3DD0
	ret


	db $f4, $f8, $64, $00, $fe, $11, $60, $00, $fe, $19, $62, $00, $f4, $f9, $64, $00
	db $fe, $11, $60, $00, $fe, $19, $62, $00, $f0, $00, $64, $20, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $10, $60, $00, $fb, $18, $62, $00
	db $00, $f8, $66, $00, $fe, $10, $66, $20, $ff, $ff, $ff, $ff, $f4, $10, $64, $20
	db $fe, $ef, $62, $20, $fe, $f7, $60, $20, $f4, $0f, $64, $20, $fe, $ef, $62, $20
	db $fe, $f7, $60, $20, $f0, $08, $64, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $fb, $f0, $62, $20, $fb, $f8, $60, $20, $fe, $f8, $66, $00
	db $00, $10, $66, $20, $ff, $ff, $ff, $ff

Call_15_6A84::
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
	ld hl, $6a0c
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0
	ret


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
	db $08, $06, $06, $06, $04, $04, $04, $04, $04, $04, $04, $04

Call_15_6C2C::
	ld a, [$d224]
	and a
	ret z

	ld a, [$d225]
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
	ld a, [$d226]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld a, [$d224]
	dec a
	ld e, a
	ld d, b
	ld hl, $6c20
	add hl, de
	ld c, [hl]
	ld d, b
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld a, e
	and $e0
	ld e, a
	ld hl, $6aa0
	add hl, de
	push bc
	call Call_3D26
	pop de
	ld a, e
	call Call_3DD0
	call Call_3DBA
	ret


	db $03, $02, $01, $00, $00, $01, $02, $03

Jump_015_6c7e:
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
	ld [$d224], a
	xor a
	ld [$d225], a
	ld [$d226], a
	call Call_15_6C2C
	xor a
	ld [$d224], a
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
	call Call_3BBF
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
	call Call_3C30
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


	db $4a, $00, $4a, $20, $4c, $00, $4c, $20, $4e, $00, $4e, $20, $00, $00, $01, $01

Jump_015_6d5d:
	ld de, $6d4d
	call Call_3C3B
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
	call Call_3B87
	ret


	db $1e, $00, $1e, $60, $34, $00, $34, $20, $54, $00, $54, $20, $56, $00, $56, $20

Jump_015_6d8c:
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
	ld de, $6d7c
	call Call_3C3B
	call ReturnIfNonInteractive_15
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_6DA0::
	dw Jump_15_6DA4
	dw Jump_15_6DBB

Jump_15_6DA4::
	call GetEntityTimer
	jr nz, jr_015_6dae

	ld [hl], $20
	jp Call_3B8D


jr_015_6dae:
	ld e, $00
	cp $18
	jr nc, jr_015_6db6

	ld e, $01

jr_015_6db6:
	ld a, e
	call Call_3B87
	ret


Jump_15_6DBB::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	call GetEntityTimer
	cp $01
	jr nz, jr_015_6dd7

	ld a, $28
	ldh [hNoiseSfx], a
	ld a, $30
	call Call_3C25

jr_015_6dd7:
	ldh a, [hFrameCounter]
	xor c
	rra
	jr nc, jr_015_6de3

	call UpdateEntityPosWithSpeed_15
	call Call_3BBF

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
	call Call_15_52D8
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
	call Call_15_5728
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
	ld [$c5a7], a
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
	call Call_3B8D
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
	call Call_3B87
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
	call Call_3B87
	cp $03
	jr nz, jr_015_6f48

	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]

jr_015_6f48:
	call Call_3BB4
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
	call Call_3C30
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
	call Call_3B9E
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
	call Call_3B8D

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
	call Call_15_53AD
	call ClearEntityStatus_15
	ld a, $e6
	call Call_3C01
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
	call Call_3D26
	ld a, $03
	call Call_3DD0
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
	call Call_3D26
	ld a, $03
	call Call_3DD0
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push af
	push hl
	sub $08
	ld [hl], a
	call Call_3DBA
	call Call_15_7196
	pop hl
	pop af
	ld [hl], a
	call Call_3DBA
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
	call Call_3C3B
	ld a, $02
	call Call_3DD0
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
	call Call_3C30
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
	jp Call_3DBA


	db $58, $00, $58, $20, $5a, $00, $5a, $20, $10, $f0, $00, $00, $00, $00, $fb, $05

Call_15_734E::
	ld de, $733e
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call ApplyRecoilIfNeeded_15
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	call Call_3BB4
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_737a

	call GetEntityTimer
	jr nz, jr_015_73a0

jr_015_737a:
	call GetEntityTimer
	call GetRandomByte
	and $7f
	add $30
	ld [hl], a
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $7346
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $734a
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_015_73a0:
	ret


	db $5c, $00, $5e, $00, $5e, $20, $5c, $20, $5e, $60, $5c, $60, $5c, $40, $5e, $40
	db $2c, $00, $2e, $00, $2e, $20, $2c, $20, $2e, $60, $2c, $60, $2c, $40, $2e, $40
	db $fd, $03, $00, $00, $00, $00, $03, $fd

Call_15_73C9::
	ld de, $73a1
	ld a, [wGameplayType]
	cp $01
	jr nz, jr_015_73d6

	ld de, $73b1

jr_015_73d6:
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call ApplyRecoilIfNeeded_15
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $03
	call Call_3B87
	call GetEntityDirectionToLink_15
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
	ld a, [wIsUsingShield]
	and a
	jr z, jr_015_7407

	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, jr_015_7407

	set 7, [hl]

jr_015_7407:
	call Call_3BD5
	jr nc, jr_015_7446

	call RestoreLinkPosition
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $80
	ret z

	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $73c1
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $73c5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld a, $3e
	ldh [hJingle], a
	call UpdateEntityPosWithSpeed_15
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $03
	call Call_3B9E
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b

jr_015_7446:
	ld a, [wSwordAnimationStatePrev]
	and a
	jr nz, jr_015_7452

	ld a, [wIsUsingShield]
	and a
	jr nz, jr_015_7455

jr_015_7452:
	call Call_3BEB

jr_015_7455:
	ret


	db $30, $d0

Call_15_7458::
	call ReturnIfNonInteractive_15
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7456
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call AddEntitySpeedToPosY_15
	call Call_3B9E
	ldh a, [hRoomObjectType]
	cp $9d
	jr z, jr_015_748a

	ld e, a
	ld d, $01
	call GetObjectPhysics
	and a
	jr nz, jr_015_748a

	call ClearEntityStatus_15
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityStatus], a

jr_015_748a:
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hBGPosX], a
	swap a
	and $0f
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add $04
	sub $10
	ldh [hBGPosY], a
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $9d
	call GetBGAddress
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
	add $0a
	ld [wDrawCommandsSize], a
	ld d, $00
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
	push hl
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr nz, jr_015_74f5

	ld a, $04
	ld [hli], a
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $08
	jr nz, jr_015_74da

	ld a, $04

jr_015_74da:
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $05
	ld [hli], a
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $09
	jr nz, jr_015_74f1

	ld a, $05

jr_015_74f1:
	ld [hli], a
	ld [hl], $00
	ret


jr_015_74f5:
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $0a
	jr nz, jr_015_74fe

	ld a, $04

jr_015_74fe:
	ld [hli], a
	ld a, $04
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ldh a, [hActiveEntityStatus]
	and a
	ld a, $0b
	jr nz, jr_015_7515

	ld a, $05

jr_015_7515:
	ld [hli], a
	ld a, $05
	ld [hli], a
	ld [hl], $00
	ret


Call_15_751C::
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_758e

	call ReturnIfNonInteractive_15
	call GetEntityXDistanceToLink_15
	add $20
	cp $40
	jr nc, jr_015_757d

	call GetEntityYDistanceToLink_15
	add $20
	cp $40
	jr nc, jr_015_757d

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $3f
	jr nz, jr_015_757d

	ld a, $b2
	ld e, $04
	call Call_3C13
	jr c, jr_015_757d

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $18
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $20
	push bc
	push de
	pop bc
	ld a, $08
	call Call_3C25
	pop bc

jr_015_757d:
	ret


	db $08, $f8, $00, $00, $00, $00, $f8, $08, $70, $00, $72, $00, $72, $20, $70, $20

Jump_015_758e:
	ld de, $7586
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call ApplyRecoilIfNeeded_15
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call UpdateEntityPosWithSpeed_15
	call GetEntityTimer1
	jr nz, jr_015_75af

	call Call_3B9E

jr_015_75af:
	call Call_3BB4
	call GetEntityTimer
	jr nz, jr_015_75da

	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $757e
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $7582
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_015_75da:
	ret


	db $3e, $00, $f8, $08, $00, $00, $00, $00, $08, $f8

Call_15_75E5::
	call ReturnIfNonInteractive_15
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_015_75f0

	call Call_3BCA

jr_015_75f0:
	call UpdateEntityPosWithSpeed_15
	call Call_3BA9
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_7648

	push hl
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityY]
	ldh [hMultiPurpose1], a
	ld a, $05
	call AddTransientVfx
	pop hl
	ld a, [hl]
	cp $02
	jp nz, ClearEntityStatus_15

	ld [hl], $00
	ld hl, wEntityState
	add hl, bc
	ld [hl], a
	ldh a, [hLinkDirection]
	and $02
	jr nz, jr_015_7625

	ld hl, wEntitySpeedX
	jr jr_015_7628

jr_015_7625:
	ld hl, wEntitySpeedY

jr_015_7628:
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call ResetSpinAttackAndDash
	ld a, $10
	ld [wLinkPushedTimer], a
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $75dd
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $75e1
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	ret


jr_015_7648:
	ldh a, [hActiveEntityX]
	add $04
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityY]
	ldh [hMultiPurpose1], a
	ld a, $06
	call AddTransientVfx
	ld [hl], $10
	ret


	db $00, $00, $74, $00, $00, $08, $74, $20, $00, $00, $ff, $00, $f0, $08, $7a, $00
	db $00, $00, $76, $00, $00, $08, $78, $00, $f0, $00, $7a, $20, $00, $00, $78, $20
	db $00, $08, $76, $20, $00, $00, $74, $40, $00, $08, $74, $60, $00, $00, $ff, $00

Call_15_768A::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_7834

	ld hl, $765a
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
	add e
	ld e, a
	ld d, b
	add hl, de
	ld c, $03
	call Call_3D26
	call Call_3D19
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, jr_015_76fe

	ld a, [wBumpShakeTimer]
	and a
	jr z, jr_015_76fe

	ld a, [$c178]
	and a
	jr z, jr_015_76fe

	ldh a, [hActiveEntityX]
	add $08
	ld hl, $c179
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_76fe

	ldh a, [hActiveEntityY]
	add $08
	ld hl, $c17a
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_76fe

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $18
	ld [hl], a
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $18
	call Call_3B8D
	ld [hl], $02
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $15
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $0c
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fa
	ret


jr_015_76fe:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_7701::
	dw Jump_15_7709
	dw Jump_15_7719
	dw Jump_15_77A2
	dw Jump_15_77CE

Jump_15_7709::
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	call GetEntityTimer
	ld [hl], $80
	jp Call_3B8D


Jump_15_7719::
	call ReturnIfNonInteractive_15
	call GetEntityTimer
	ret nz

	ld [hl], $50
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	cp $03
	jr nz, jr_015_772d

	xor a

jr_015_772d:
	ld [hl], a
	ldh [hActiveEntitySpriteVariant], a
	cp $00
	jr z, jr_015_77a1

	call GetEntityTimer
	ld [hl], $28
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $0f
	jr nz, jr_015_7747

	ld a, $02
	jr jr_015_7749

jr_015_7747:
	ld a, $e0

jr_015_7749:
	call Call_3C01
	ret c

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $0c
	add $18
	ld [hl], a
	ld hl, wEntityZ
	add hl, de
	ld [hl], $18
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	ld a, $f8
	jr z, jr_015_777a

	ld a, $08

jr_015_777a:
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $0c
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
	ld hl, wEntityOptions1
	add hl, de
	set 0, [hl]
	ld a, $08
	ldh [hJingle], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01

jr_015_77a1:
	ret


Jump_15_77A2::
	ld a, $03
	call Call_3B87
	call UpdateEntityPosWithSpeed_15
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_77cd

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	call Call_3DAF
	call Call_3B8D

jr_015_77c9:
	ld a, $14
	ldh [hWaveSfx], a

jr_015_77cd:
	ret


Jump_15_77CE::
	ld a, $00
	call Call_3B87
	call UpdateEntityPosWithSpeed_15
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_780d

	ld [hl], $01
	call GetRandomByte
	and $0f
	add $08
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	ld a, $10
	call Call_3C30
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

jr_015_780d:
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_15

	ldh a, [hActiveEntityDrawY]
	cp $80
	jp nc, ClearEntityStatus_15

	ldh a, [hFrameCounter]
	and $0f
	jr z, jr_015_77c9

	ret


	db $7c, $00, $7e, $00, $7e, $20, $7c, $20, $00, $0c, $10, $0c, $00, $f4, $f0, $f4
	db $00, $0c

Jump_015_7834:
	ld de, $7822
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call ApplyRecoilIfNeeded_15
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BB4
	call UpdateEntityPosWithSpeed_15
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_789b

	ld [hl], b
	call GetRandomByte
	and $0f
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $782c
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $782a
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld a, [hl]
	cp $04
	jp z, ClearEntityStatus_15

	ld a, $09
	ldh [hJingle], a

jr_015_789b:
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

Call_15_78AC::
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_78ba

	ldh a, [hActiveEntitySpriteVariant]
	add $02
	ldh [hActiveEntitySpriteVariant], a

jr_015_78ba:
	ld de, $789c
	call Call_3C3B
	call ReturnIfNonInteractive_15
	call AddEntityZSpeedToPos_15
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_015_78de

	xor a
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a

jr_015_78de:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_15_78E1::
	dw Jump_15_78ED
	dw Jump_15_793D

	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

Jump_15_78ED::
	call GetEntityTimer
	jr nz, jr_015_7929

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $78e5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld a, e
	and $04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $07
	ld e, a
	ld hl, $78e5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	jp Call_3B8D


jr_015_7929:
	ld a, $01
	call Call_3B87
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_015_793c

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a

jr_015_793c:
	ret


Jump_15_793D::
	call UpdateEntityPosWithSpeed_15
	call Call_3B9E
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_015_795f

	call GetEntityTimer
	jr nz, jr_015_7954

	ld [hl], $48
	call Call_3B8D
	ld [hl], b
	ret


jr_015_7954:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

jr_015_795f:
	ld a, $00
	call Call_3B87
	ret


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
;>@rpd         return Call_3DBA()                  # back to the real position copies
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
	jp Call_3DBA


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
;>@nt if not Call_3BD5(): return False        # Link does not touch the entity
	call Call_3BD5
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
;> Call_1495()                                # and Link's speed
	call Call_1495
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
;> Call_3B87(frame | base)                    # set the sprite variant
	pop hl
	and $01
	or [hl]
	jp Call_3B87

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
;> Call_3EB8()
	call Call_3EB8
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
;>     Call_3B9E()                             # walls stop the recoil
	call Call_3B9E

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
;@ boss-defeated sound plays and the entity is replaced by its reward (Call_3F7A).
;@ test: skip calls routines in other banks
BossDefeatExplode_15::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .explode
;>     PlayClinkNoise()                             # boss defeated sound, screen shake
	call PlayClinkNoise
;>     return Call_3F7A()                      # the boss dies and leaves its reward
	jp Call_3F7A


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
;> new = Call_3C01(0x36)                      # spawn: hMultiPurpose0/1 = our position
	ld a, $36
	call Call_3C01
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
