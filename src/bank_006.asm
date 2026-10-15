; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

;@ path: npc/richard
;@ Richard's sprite frames, read by RichardHandler through the two-sprite renderer (DrawEntity16x16).
;@ 8 frames of 4 bytes: left 8x16 sprite (tile, attributes), right sprite (tile, attributes); attribute
;@ $20 = mirrored. Frames 0-1 walking down, 2-3 walking up (the same tiles $50-$56), 4-5 walking left
;@ (tiles $58-$5E), 6-7 walking right (the left frames mirrored). The frame is picked by SetWalkingFrame_06.
RichardSprites::
	db $50, $00, $52, $00, $54, $00, $56, $00, $50, $00, $52, $00, $54, $00, $56, $00
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5a, $20, $58, $20, $5e, $20, $5c, $20

;@ def RichardHandler(slot: bc)
;@ path: npc/richard
;@ Entity $95: Richard in his villa, who wants the five golden leaves from Kanalet Castle. He is
;@ always drawn at y $21, turns towards Link every 32 frames and walks on the spot; until he has
;@ stepped aside he blocks Link like a wall. Then runs his state (RichardStates).
;@ test: skip draws sprites and calls banked helpers
RichardHandler::
;> hActiveEntityDrawY = 0x21               # always drawn at the same height on screen
	ld a, $21
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(RichardSprites)                # draw the current frame (two 8x16 sprites)
	ld de, RichardSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if hFrameCounter & 0x1F == 0:            # every 32 frames: face Link
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .walk
;>     wEntityDirection[slot] = GetEntityDirectionToLink_06()
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.walk
;> SetWalkingFrame_06()
	call SetWalkingFrame_06
;> if wEntityPrivate1[slot] == 0:           # 1 once he has moved out of the way
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .dispatch
;>     BlockLinkIfTouching_06()
	call BlockLinkIfTouching_06

.dispatch
;> RichardStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/richard
;@ Richard's states: 0 setup, 1 waiting to be talked to, 2 answer to his question, 3 stepping aside,
;@ 4 out of the way (the passage behind him is open).
RichardStates::
	dw RichardSetup
	dw RichardWaitTalk
	dw RichardAnswer
	dw RichardStepAside
	dw RichardAside

;@ def RichardSetup(slot: bc)
;@ path: npc/richard
;@ State 0: goes on to state 1; if the golden leaves were handed over before (6 or more, $FF once
;@ given), Richard stands aside at x $58 right away (state 4).
;@ test: skip part of a state machine (bank-0 helper)
RichardSetup::
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wGoldenLeaves < 6:
	ld a, [wGoldenLeaves]
	cp $06
;>     return
	ret c

;> wEntityState[slot] = 4
	ld [hl], $04
;> wEntityX[slot] = 0x58
	ld hl, wEntityX
	add hl, bc
	ld [hl], $58
	ret


;@ def RichardWaitTalk(slot: bc)
;@ path: npc/richard
;@ State 1: when Link talks to him. With Bow-Wow along he only says text $12D. The first time
;@ (room flag bit 4 not set yet, or no leaves) he asks for the golden leaves (text $13A, a yes/no
;@ question answered in state 2) and starts that part of the quest (wRichardQuest at least 2).
;@ With 1-4 leaves he says text $13F; with 5 he takes them (wGoldenLeaves = $FF), says text $13D,
;@ requests the room change 9 (the opened passage) and steps aside (state 3, 32 frames).
;@ test: skip opens dialogues
RichardWaitTalk::
;> if not ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
;>     return
	jr nc, .done

;> if wIsBowWowFollowingLink:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr z, .noDog
;>     OpenDialogTable1(0x2D)
	ld e, $2d
	jp .say


.noDog
;> if not (hRoomStatus & 0x10) or wGoldenLeaves == 0:
	ldh a, [hRoomStatus]
	and $10
	jr z, .firstTalk

	ld a, [wGoldenLeaves]
	and a
	jr nz, .haveLeaves

.firstTalk
;>     hRoomStatus |= 0x10              # remember that he has asked
	ldh a, [hRoomStatus]
	or $10
	ldh [hRoomStatus], a
;>     wRoomStatus[0x2C7] = hRoomStatus
	ld [$dac7], a
;>     OpenDialogTable1(0x3A)                  # asks for the golden leaves
	ld a, $3a
	call OpenDialogTable1
;>     if wRichardQuest < 2:
	ld a, [wRichardQuest]
	cp $02
	jr nc, .next
;>         wRichardQuest = 2
	ld a, $02
	ld [wRichardQuest], a

.next
;>     wEntityState[slot] += 1          # state 2: his answer
	jp IncrementEntityState


.haveLeaves
;> elif wGoldenLeaves < 5:
	ld e, $3f
	cp $05
;>     OpenDialogTable1(0x3F)                  # not enough leaves yet
	jr c, .say

;> else:
;>     wEntityState[slot] = 3          # step aside
	call IncrementEntityState
	ld [hl], $03
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityPrivate1[slot] = 1       # no longer blocks Link
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $01
;>     wGoldenLeaves = 0xFF            # the leaves are handed over
	ld a, $ff
	ld [wGoldenLeaves], a
;>     hBGChangeRequest = 9            # open the passage
	ld a, $09
	ldh [hBGChangeRequest], a
;>@say     OpenDialogTable1(0x3D)             # thanks him and opens the way
	ld e, $3d

.say
;=@say
	ld a, e
	call OpenDialogTable1

.done
	ret


;@ def RichardAnswer(slot: bc)
;@ path: npc/richard
;@ State 2: replies to the answer of his question (text $13B for the first choice, $13C for the
;@ second) and goes back to state 1.
;@ test: skip opens a dialogue
RichardAnswer::
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
;>     text = 0x3B
	ld a, $3b
	jr z, .say
;> else:
;>     text = 0x3C
	ld a, $3c

.say
;> OpenDialogTable1(text)
	call OpenDialogTable1
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
	ret


;@ def RichardStepAside(slot: bc)
;@ path: npc/richard
;@ State 3: walks left at speed -8 (half a pixel per frame) for 32 frames, then state 4.
;@ test: skip part of a state machine (bank-0 helper)
RichardStepAside::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .move
;>     wEntityState[slot] += 1
	call IncrementEntityState

.move
;> wEntitySpeedX[slot] = -8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f8
;> AddEntitySpeedToPos_06(slot)              # x only
	call AddEntitySpeedToPos_06
	ret


;@ def RichardAside(slot: bc)
;@ path: npc/richard
;@ State 4: talking gives text $13E (leaf count 6) or $13D. When Link walks into the opened passage
;@ (x $76-$79, y $1B-$24) he is warped indoors: map $11, room $D8, arriving at x $88, y $70.
;@ test: skip opens a dialogue / starts a warp
RichardAside::
;> if ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
	jr nc, .warpCheck
;>@say     OpenDialogTable1(0x3E if wGoldenLeaves == 6 else 0x3D)
	ld a, [wGoldenLeaves]
	cp $06
	ld a, $3e
	jr z, .say

	ld a, $3d

.say
;=@say
	call OpenDialogTable1

.warpCheck
;> if (hLinkX - 0x78 + 2) & 0xFF >= 4:
	ldh a, [hLinkX]
	sub $78
	add $02
	cp $04
;>     return
	jr nc, .done

;> if (hLinkY - 0x20 + 5) & 0xFF >= 10:
	ldh a, [hLinkY]
	sub $20
	add $05
	cp $0a
;>     return
	jr nc, .done

;> wWarpType = 1                            # indoors
	ld hl, wWarpType
	ld a, $01
	ld [hli], a
;> wWarpMap = 0x11
	ld a, $11
	ld [hli], a
;> wWarpRoom = 0xD8
	ld a, $d8
	ld [hli], a
;> wWarpDestX = 0x88
	ld a, $88
	ld [hli], a
;> wWarpDestY = 0x70
	ld a, $70
	ld [hli], a
;> ClearEntityStatus_06()
	call ClearEntityStatus_06
;> StartWarpFadeOutWithNoise()                               # start the warp
	jp StartWarpFadeOutWithNoise


.done
	ret


;@ path: enemy/mad_bomber
;@ The Mad Bomber's sprite frames for the two-sprite renderer (DrawEntity16x16): 5 frames of 4 bytes, left
;@ 8x16 sprite (tile, attributes) then right sprite (tile, attributes; $20 = mirrored).
;@ 0 = hidden (blank tile $FF), 1 = top of the head ($70 + mirror), 2 = head ($72 + mirror),
;@ 3 and 4 = out of the hole, throwing ($74/$76 and the same mirrored).
MadBomberSprites::
	db $ff, $00, $ff, $20, $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $76, $00
	db $76, $20, $74, $20

;@ path: enemy/mad_bomber
;@ X positions (pixels) of the 8 holes the Mad Bomber can pop out of; MadBomberHoleY has the y of each.
MadBomberHoleX::
	db $28, $38, $58, $58, $78, $88, $28, $88

;@ path: enemy/mad_bomber
;@ Y positions (pixels) of the 8 holes, same order as MadBomberHoleX.
MadBomberHoleY::
	db $40, $70, $20, $50, $70, $40, $40, $40

;@ def MadBomberHandler(slot: bc)
;@ path: enemy/mad_bomber
;@ Entity $93: the Mad Bomber, who pops out of one of 8 holes away from Link, throws a bomb at him
;@ and ducks again. Gone for good once the room's event flag (bit 4) is set. It leaves entity $3C
;@ behind when defeated and is never marked as defeated in the room's list (it always comes back).
;@ test: skip draws sprites and calls banked helpers
MadBomberHandler::
;> if hRoomStatus & 0x10:
	ldh a, [hRoomStatus]
	and $10
;>     return ClearEntityStatus_06()
	jp nz, ClearEntityStatus_06

;> wEntityDropType[slot] = 0x3C
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c
;> wEntityLoadOrder[slot] = 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;> DrawEntity16x16(MadBomberSprites)
	ld de, MadBomberSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer()                              # count down the no-hit timer
	call DecrementEntityIgnoreHitsTimer
;> MadBomberStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/mad_bomber
;@ The Mad Bomber's states: 0 hidden (wait 64 frames), 1 choose a hole, 2 rise, 3 throw, 4 duck.
MadBomberStates::
	dw MadBomberInit
	dw MadBomberPickHole
	dw MadBomberRise
	dw MadBomberThrow
	dw MadBomberDuck

;@ def MadBomberInit(slot: bc)
;@ path: enemy/mad_bomber
;@ State 0: stays hidden for 64 frames (state 1).
;@ test: skip part of a state machine (bank-0 helper)
MadBomberInit::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ def MadBomberPickHole(slot: bc)
;@ path: enemy/mad_bomber
;@ State 1: when the timer has run out, moves to a random hole (MadBomberHoleX/Y). If that hole is
;@ at least 32 pixels away from Link on one axis it rises there (24 frames, state 2); otherwise it
;@ tries another hole next frame.
;@ test: skip uses the random generator and bank-0 helpers
MadBomberPickHole::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done

;> hole = GetRandomByte() & 7                   # random hole
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntityX[slot] = MadBomberHoleX[hole]
	ld hl, MadBomberHoleX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = MadBomberHoleY[hole]
	ld hl, MadBomberHoleY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x20) < 0x40:              # Link within 32 pixels horizontally
	add $20
	cp $40
	jr nc, .rise

;>     dy, side = GetEntityYDistanceToLink_06()
	call GetEntityYDistanceToLink_06
;>     if u8(dy + 0x20) < 0x40:           # ... and vertically: too close, try again
	add $20
	cp $40
;>         return
	jr c, .done

.rise
;> wEntityTimer[slot] = 0x18
	call GetEntityTimer
	ld [hl], $18
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def MadBomberRise(slot: bc)
;@ path: enemy/mad_bomber
;@ State 2: shows the top of the head (frame 1) for 12 frames, then the head (frame 2); after 24
;@ frames it is out (state 3, 48 frames).
;@ test: skip part of a state machine (bank-0 helper)
MadBomberRise::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .rising
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityState[slot] += 1
	jp IncrementEntityState


.rising
;>@v wEntitySpriteVariant[slot] = 1 if wEntityTimer[slot] >= 0x0C else 2
	cp $0c
	ld a, $01
	jr nc, .set

	inc a

.set
;=@v
	call SetEntitySpriteVariant
	ret


;@ def MadBomberThrow(slot: bc)
;@ path: enemy/mad_bomber
;@ State 3: out of the hole for 48 frames, where Link's sword can hit it (EntityCheckHits); frames 3 and
;@ 4 alternate every 32 frames. Then it ducks (state 4, 16 frames) and, unless it is flashing from
;@ a hit, throws a bomb (entity $02): the bomb starts at its position, 4 pixels up, flies in an arc
;@ (height speed $18) towards Link at speed $10 and explodes after 64 frames.
;@ ThrowBombTowardsLink, the second half, is also used by the Hinox.
;@ test: skip spawns an entity (banked helpers)
MadBomberThrow::
;> EntityCheckHits()                              # contact damage and weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr nz, jr_006_4222
;>@v     wEntitySpriteVariant[slot] = 3 if wEntityTimer[slot] & 0x20 else 4
;>@r     return

;> wEntityTimer[slot] = 0x10
	ld [hl], $10
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wEntityFlashTimer[slot] != 0:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr nz, jr_006_4221

;> new = SpawnEntity(0x02)                    # spawn a bomb; hMultiPurpose0/1 = our x / y
	ld a, $02
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
;> wEntityZ[new] = 4
	ld hl, wEntityZ
	add hl, de
	ld [hl], $04

ThrowBombTowardsLink:
;> wEntitySpeedZ[new] = 0x18
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $18
;> wEntityTimer[new] = 0x40                 # fuse
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
;> wEntityPrivate4[new] = 1                 # thrown by an enemy
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
;> SetEntitySpeedTowardsLink(0x10, slot=new)                # aim the bomb at Link
	push bc
	push de
	pop bc
	ld a, $10
	call SetEntitySpeedTowardsLink
	pop bc
;> hJingle = 0x08
	ld a, $08
	ldh [hJingle], a

jr_006_4221:
;> return
	ret


jr_006_4222:
;=@v
	and $20
	ld a, $03
	jr nz, jr_006_4229

	inc a

jr_006_4229:
;=@v
	call SetEntitySpriteVariant
;=@r
	ret


;@ def MadBomberDuck(slot: bc)
;@ path: enemy/mad_bomber
;@ State 4: shows frame 2 for 8 frames, then frame 1; after 16 frames it is hidden again
;@ (frame $FF, state 0).
;@ test: skip part of a state machine (bank-0 helper)
MadBomberDuck::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .ducking

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntitySpriteVariant[slot] = 0xFF        # not drawn
	ld a, $ff
	call SetEntitySpriteVariant
	ret


.ducking
;>@v wEntitySpriteVariant[slot] = 1 if wEntityTimer[slot] < 8 else 2
	cp $08
	ld a, $01
	jr c, .set

	inc a

.set
;=@v
	call SetEntitySpriteVariant
	ret


;@ def AntiKirbyHandler(slot: bc)
;@ path: enemy/anti_kirby
;@ Entity $91: the Anti-Kirby, a puffball that hops around diagonally and inhales Link when he is
;@ in front of it, swallows him and spits him out (taking 2 eighths of a heart). Runs gravity (3
;@ per frame) on its height; hBGTilesRequestCopy (here a scratch byte) is $80 on the frame it lands.
;@ test: skip draws sprites and calls banked helpers
AntiKirbyHandler::
;> AntiKirbyDraw(slot)
	call AntiKirbyDraw
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 3                 # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80    # landed: fell below the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, .dispatch

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.dispatch
;> AntiKirbyStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/anti_kirby
;@ The Anti-Kirby's states: 0 hop, 1 choose a new direction, 2 inhale, 3 Link swallowed,
;@ 4 recover after spitting him out.
AntiKirbyStates::
	dw AntiKirbyHop
	dw AntiKirbyPickDirection
	dw AntiKirbyInhale
	dw AntiKirbySwallowed
	dw AntiKirbyRecover

;@ def AntiKirbyHop(slot: bc)
;@ path: enemy/anti_kirby
;@ State 0: hops in its direction until the timer runs out. Then it stops; if its inhale cooldown
;@ (wEntityDropTimer) is over and Link is on the side it faces, it starts inhaling (state 2, 255
;@ frames); otherwise it hops on for 16-47 frames in a new direction (state 1).
;@ AntiKirbyHopMove, shared with state 1: a new hop (height speed $10) each time it lands, move,
;@ wall collisions, the facing frame, and contact damage / weapon hits.
;@ test: skip uses banked helpers
AntiKirbyHop::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, AntiKirbyHopMove

;>     ClearEntitySpeed()                          # stop
	call ClearEntitySpeed
;>     if wEntityDropTimer[slot] == 0:
	call GetEntityDropTimer
	jr nz, .newHop

;>         dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;>         if wEntityDirection[slot] & 1 == side:     # Link is in front of it
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	cp e
	jr nz, .newHop

;>             wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>             wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;>             hNoiseSfx = 0x3B                # inhaling sound
	ld a, $3b
	ldh [hNoiseSfx], a
;>             return
	ret


.newHop
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x10
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState

AntiKirbyHopMove:
;> if hBGTilesRequestCopy:                    # just landed: hop again
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .move
;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()                               # walls
	call EntityCheckWalls
;> wEntitySpriteVariant[slot] = (wEntityDirection[slot] * 2) & 6     # mouth closed
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rla
	and $06
	call SetEntitySpriteVariant
;> EntityCheckHits()                               # contact damage and weapon hits
	call EntityCheckHits
	ret


;@ path: enemy/anti_kirby
;@ Horizontal speed of the Anti-Kirby's four diagonal directions (1/16 pixel per frame):
;@ 0 up-right, 1 up-left, 2 down-right, 3 down-left. AntiKirbySpeedY holds the vertical speeds.
AntiKirbySpeedX::
	db $08, $f8, $08, $f8

;@ path: enemy/anti_kirby
;@ Vertical speed of the four diagonal directions (see AntiKirbySpeedX).
AntiKirbySpeedY::
	db $f8, $f8, $08, $08

;@ def AntiKirbyPickDirection(slot: bc)
;@ path: enemy/anti_kirby
;@ State 1: hops on (AntiKirbyHopMove); when the timer runs out it sets a hop of 32-63 frames
;@ (state 0) in a new diagonal direction: random half of the time, otherwise the diagonal towards
;@ Link.
;@ test: skip uses the random generator and banked helpers
AntiKirbyPickDirection::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .move

;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x20
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     r = GetRandomByte()
	call GetRandomByte
;>     if r & 4:
	bit 2, a
	jr z, .towardsLink
;>         direction = r & 3
	and $03
	jr .set

.towardsLink
;>     else:
;>         dx, xside = GetEntityXDistanceToLink_06()      # 0 Link to the right, 1 left
	call GetEntityXDistanceToLink_06
	push de
;>         dy, yside = GetEntityYDistanceToLink_06()      # 2 Link above, 3 below
	call GetEntityYDistanceToLink_06
	ld a, e
;>         direction = ((yside & 3) - 2) * 2 | xside
	and $03
	dec a
	dec a
	sla a
	pop de
	or e

.set
;>     wEntityDirection[slot] = direction
	ld e, a
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ld d, b
;>     wEntitySpeedX[slot] = AntiKirbySpeedX[direction]
	ld hl, AntiKirbySpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = AntiKirbySpeedY[direction]
	ld hl, AntiKirbySpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.move
;> AntiKirbyHopMove(slot)
	jp AntiKirbyHopMove


;@ def AntiKirbyInhale(slot: bc)
;@ path: enemy/anti_kirby
;@ State 2: floats up to height 12 (a pixel every 4 frames) with its mouth open and sucks Link
;@ in: while Link is visible, on the side it faces, within 64 pixels horizontally and 48
;@ vertically (from its drawn height), Link is moved towards it at speed 8. If Link gets within 4
;@ pixels he is swallowed (state 3, 128 frames). When the timer runs out (AntiKirbyStopInhaling,
;@ also used by state 4) it goes back to hopping and waits 8-39 frames before it may inhale again.
;@ test: skip moves Link through banked helpers
AntiKirbyInhale::
;> EntityCheckWeaponHits()                               # weapon hits (no contact damage)
	call EntityCheckWeaponHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_006_4339

AntiKirbyStopInhaling:
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityDropTimer[slot] = (GetRandomByte() & 0x1F) + 8      # inhale cooldown
	call GetEntityDropTimer
	call GetRandomByte
	and $1f
	add $08
	ld [hl], a
;>     return
	ret


jr_006_4339:
;> wAntiKirbyInhaling = 1
	ld a, $01
	ld [wAntiKirbyInhaling], a
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>@fz if hFrameCounter & 3 == 0 and wEntityZ[slot] != 0x0C:     # float to height 12
	ldh a, [hFrameCounter]
	and $03
	jr nz, .pull

;=@fz
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub $0c
	jr z, .pull

;>@z     wEntityZ[slot] += 1 if wEntityZ[slot] < 0x0C else -1
	and $80
	jr z, .down

	inc [hl]
	inc [hl]

.down
;=@z
	dec [hl]

.pull
;> if hLinkAnimationState == 0xFF:           # Link not drawn
	ldh a, [hLinkAnimationState]
	cp $ff
;>     return AntiKirbyMouthOpenFrame(slot)
	jr z, AntiKirbyMouthOpenFrame

;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> if wEntityDirection[slot] & 1 != side:     # Link behind it
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	cp e
;>     return AntiKirbyMouthOpenFrame(slot)
	jr nz, AntiKirbyMouthOpenFrame

;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x40) >= 0x80:
	add $40
	cp $80
;>     return AntiKirbyMouthOpenFrame(slot)
	jr nc, AntiKirbyMouthOpenFrame

;> y = wEntityY[slot]                        # measure from where it is drawn
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push hl
	push af
;> wEntityY[slot] = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
;> dy, side = GetEntityYDistanceToLink_06()
	call GetEntityYDistanceToLink_06
	ld e, a
;> wEntityY[slot] = y
	pop af
	pop hl
	ld [hl], a
;> if u8(dy + 0x30) >= 0x60:
	ld a, e
	add $30
	cp $60
;>     return AntiKirbyMouthOpenFrame(slot)
	jr nc, AntiKirbyMouthOpenFrame

;> GetVectorTowardsLink(8)                              # hMultiPurpose0/1 = y / x speed towards Link
	ld a, $08
	call GetVectorTowardsLink
;> hLinkSpeedY = u8(-hMultiPurpose0)         # pull Link towards it
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ldh [hLinkSpeedY], a
;> hLinkSpeedX = u8(-hMultiPurpose1)
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ldh [hLinkSpeedX], a
;> ApplyLinkSpeed()
	push bc
	call ApplyLinkSpeed
;> Call_3E49()                               # Link's wall collisions
	call Call_3E49
	pop bc
;>@near if u8(hLinkX - hActiveEntityX + 4) < 8 and u8(hLinkY - hActiveEntityDrawY + 4) < 8:
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $04
	cp $08
	jr nc, AntiKirbyMouthOpenFrame

;=@near
	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $04
	cp $08
	jr nc, AntiKirbyMouthOpenFrame

;>     wEntityTimer[slot] = 0x80             # swallowed
	call GetEntityTimer
	ld [hl], $80
;>     wEntityState[slot] += 1
	call IncrementEntityState

AntiKirbyMouthOpenFrame:
;> frame = (wEntityDirection[slot] * 2) & 6 | 1         # mouth open
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rla
	and $06
	or $01
;> wEntitySpriteVariant[slot] = frame
	call SetEntitySpriteVariant
	ret


;@ def AntiKirbySwallowed(slot: bc)
;@ path: enemy/anti_kirby
;@ State 3: Link is inside: he is hidden and frozen while the puffed-up Anti-Kirby (frames 8-11)
;@ lands and makes one small hop. When the timer runs out it spits him out forwards (x speed
;@ $18 or -$18, height speed $10, in the air), he takes 2 eighths of a heart and is invincible
;@ for 32 frames; state 4 for 12 frames.
;@ test: skip part of a state machine (bank-0 helper)
AntiKirbySwallowed::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr z, .spit

;>@l     if hBGTilesRequestCopy and wEntityPrivate1[slot] == 0:     # landed for the first time
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .frame
;=@l

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .frame

;>         wEntityPrivate1[slot] = 1
	inc [hl]
;>         wEntitySpeedZ[slot] = 0x0C
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c
;>         hJingle = 0x09
	ld a, $09
	ldh [hJingle], a

.frame
;>     wEntitySpriteVariant[slot] = wEntityDirection[slot] + 8     # puffed up
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	add $08
	call SetEntitySpriteVariant
;>     hLinkAnimationState = 0xFF            # Link is not drawn
	ld a, $ff
	ldh [hLinkAnimationState], a
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     return
	ret


.spit
;> wEntityTimer[slot] = 0x0C
	ld [hl], $0c
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;> hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;>@sx hLinkSpeedX = 0x18 if wEntityDirection[slot] & 1 == 0 else 0xE8     # the way it faces
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
;=@sx
	ld a, $18
	jr z, .setX

	ld a, $e8

.setX
;=@sx
	ldh [hLinkSpeedX], a
;> hLinkSpeedZ = 0x10
	ld a, $10
	ldh [hLinkSpeedZ], a
;> wInvincibilityCounter = 0x20
	ld a, $20
	ld [wInvincibilityCounter], a
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> wSubtractHealthBuffer = 2
	ld a, $02
	ld [wSubtractHealthBuffer], a
;> hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def AntiKirbyRecover(slot: bc)
;@ path: enemy/anti_kirby
;@ State 4: keeps its mouth open and its height for 12 frames, then stops inhaling
;@ (AntiKirbyStopInhaling: back to hopping with a cooldown).
;@ test: skip part of a state machine
AntiKirbyRecover::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return AntiKirbyStopInhaling(slot)
	jp z, AntiKirbyStopInhaling

;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;> AntiKirbyMouthOpenFrame(slot)
	jp AntiKirbyMouthOpenFrame


;@ path: enemy/anti_kirby
;@ The Anti-Kirby's frames for the two-sprite renderer: 8 frames of 4 bytes (left sprite tile,
;@ attributes, right sprite tile, attributes; $20 = mirrored). Frame = direction * 2 + mouth
;@ (0 closed, 1 open): directions 0 and 2 face right (tiles $60/$62 mouth closed, $66/$68 open,
;@ mirrored), 1 and 3 face left.
AntiKirbySprites::
	db $62, $20, $60, $20, $68, $20, $66, $20, $60, $00, $62, $00, $66, $00, $68, $00
	db $62, $20, $60, $20, $68, $20, $66, $20, $60, $00, $62, $00, $66, $00, $68, $00
;@ path: enemy/anti_kirby
;@ The puffed-up Anti-Kirby with Link inside (frames 8-11): 4 entries of 3 sprites, each sprite
;@ 4 bytes (y offset, x offset, tile, attributes) from the entity position, drawn by DrawEntitySprites.
;@ Entries 0 and 2 face right (tiles $62 $6A $64 mirrored), 1 and 3 face left.
AntiKirbyPuffedOAM::
	db $00, $fc, $62, $20, $00, $04, $6a, $20, $00, $0c, $64, $20, $00, $fc, $64, $00
	db $00, $04, $6a, $00, $00, $0c, $62, $00, $00, $fc, $62, $20, $00, $04, $6a, $20
	db $00, $0c, $64, $20, $00, $fc, $64, $00, $00, $04, $6a, $00, $00, $0c, $62, $00
;@ path: enemy/anti_kirby
;@ The air drawn in front of the inhaling Anti-Kirby: 4 entries of 3 sprites (y offset, x offset,
;@ tile, attributes; tile $24 = puff, $FF = unused). Entry = facing left * 2 + animation step
;@ (every 8 frames): 0/1 to its right (x +$0E..+$18), 2/3 to its left (x -6..-16).
AntiKirbyWindOAM::
	db $00, $0e, $24, $00, $f8, $18, $24, $00, $08, $18, $24, $00, $fe, $13, $24, $00
	db $03, $13, $24, $00, $03, $13, $ff, $00, $00, $fa, $24, $00, $f8, $f0, $24, $00
	db $08, $f0, $24, $00, $fe, $f5, $24, $00, $03, $f5, $24, $00, $03, $f5, $ff, $00

;@ def AntiKirbyDraw(slot: bc)
;@ path: enemy/anti_kirby
;@ Draws the Anti-Kirby: frames 0-7 with the two-sprite renderer, plus the inhaled air while it
;@ inhales (state 2); frames 8-11 (Link inside) as 3 sprites from AntiKirbyPuffedOAM.
;@ test: skip draws sprites
AntiKirbyDraw::
;> if hActiveEntitySpriteVariant < 8:
	ldh a, [hActiveEntitySpriteVariant]
	cp $08
	jr nc, .puffed

;>     DrawEntity16x16(AntiKirbySprites)
	ld de, AntiKirbySprites
	call DrawEntity16x16
;>     if hActiveEntityState != 2:
	ldh a, [hActiveEntityState]
	cp $02
;>         return
	jr nz, .done

;>     side = (wEntityDirection[slot] & 1) * 2       # 2 = facing left
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rla
	and $02
	ld e, a
;>     step = side | (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	or e
;>@w     DrawEntitySprites(AntiKirbyWindOAM + step * 12, count=3)
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
;=@w
	add e
	ld e, a
	ld d, b
	ld hl, AntiKirbyWindOAM
	add hl, de
	ld c, $03
;=@w
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(3)                          # claim the 3 OAM entries
	ld a, $03
	call ReserveOAMEntriesFar

.done
	ret


.puffed
;> else:
;>@p     DrawEntitySprites(AntiKirbyPuffedOAM + (hActiveEntitySpriteVariant - 8) * 12, count=3)
	sub $08
	rla
	rla
	and $fc
	ld e, a
	sla a
;=@p
	add e
	ld e, a
	ld d, b
	ld hl, AntiKirbyPuffedOAM
	add hl, de
	ld c, $03
;=@p
	call DrawEntitySprites
;>     DrawEntityShadow()                           # finish the multi-sprite draw
	jp DrawEntityShadow


;@ def SmasherHandler(slot: bc)
;@ path: boss/smasher
;@ Entity $92: the Smasher, the miniboss who throws an iron ball. The ball is a second entity $92
;@ (wEntityPrivate4 = 1), spawned on the first frame 48 pixels right of and 16 below the Smasher,
;@ and handled by SmasherBallHandler. The Smasher walks to the ball, lifts it over his head and
;@ throws it at Link; he can only be hurt by Link throwing the ball back at him (2 hits per
;@ throw, see SmasherBallThrownByLink). Starts the miniboss music; gravity 3 per frame.
;@ test: skip draws sprites, spawns an entity, banked helpers
SmasherHandler::
;> if wEntityPrivate4[slot]:                # this is the ball
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
;>     return SmasherBallHandler(slot)
	jp nz, SmasherBallHandler

;> wSmasherSlot = slot
	ld a, c
	ld [wSmasherSlot], a
;> if wEntityPrivate3[slot] == 0:           # first frame: make the ball
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .ready

;>     wEntityPrivate3[slot] = 1
	inc [hl]
;>     ball = SpawnEntity(0x92)
	ld a, $92
	call SpawnEntity
;>     wSmasherBallSlot = ball
	ld a, e
	ld [wSmasherBallSlot], a
;>     wEntityY[ball] = hMultiPurpose1 + 0x10
	ldh a, [hMultiPurpose1]
	add $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityX[ball] = hMultiPurpose0 + 0x30
	ldh a, [hMultiPurpose0]
	add $30
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityPrivate4[ball] += 1          # marks it as the ball
	ld hl, wEntityPrivate4
	add hl, de
	inc [hl]

.ready
;> SmasherDraw(slot)
	call SmasherDraw
;> Call_3F12()                              # miniboss music
	call Call_3F12
;> if hActiveEntityStatus != 5:             # defeated
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return MinibossDefeated(slot)
	jp nz, MinibossDefeated

;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits()                              # contact damage
	call EntityCheckHits
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 3
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80     # scratch: landed this frame
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, .dispatch

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.dispatch
;> SmasherStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/smasher
;@ The Smasher's states: 0 walk to the ball, 1 wander while the ball is away, 2 lift the ball,
;@ 3 hold it over his head, 4 after the throw.
SmasherStates::
	dw SmasherFetchBall
	dw SmasherWander
	dw SmasherLiftBall
	dw SmasherHoldBall
	dw SmasherAfterThrow

;@ def SmasherFetchBall(slot: bc)
;@ path: boss/smasher
;@ State 0: while the ball lies on the floor, walks to it at speed $10 (by aiming at it as if it
;@ were Link). Within 12 pixels he picks it up: state 2, ball state 1 (carried), 31 frames. If
;@ the ball is not lying there (Link has it, or it flies), state 1.
;@ test: skip moves through banked helpers
SmasherFetchBall::
;> ball = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;> if wEntityState[ball] != 0:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $00
	jr nz, jr_006_45f4
;>@wander     wEntityState[slot] += 1
;>@hop     return SmasherHopFrame(slot)        # (runs on into it)

;> x = hLinkX                               # aim at the ball instead of Link
	ldh a, [hLinkX]
	push af
;> y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkX = wEntityX[ball]
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;> hLinkY = wEntityY[ball]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x10)                          # speed towards the ball
	ld a, $10
	call SetEntitySpeedTowardsLink
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>@n if u8(dx + 0x0C) < 0x18 and u8(GetEntityYDistanceToLink_06()[0] + 0x0C) < 0x18:
	add $0c
	cp $18
	jr nc, .restore

;=@n
	call GetEntityYDistanceToLink_06
	add $0c
	cp $18
	jr nc, .restore

;>     wEntityState[slot] = 2               # lift it
	call IncrementEntityState
	ld [hl], $02
;>     wEntityState[ball] = 1               # carried by the Smasher
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;>     wEntityTimer[slot] = 0x1F
	call GetEntityTimer
	ld [hl], $1f
;>     hWaveSfx = 0x1C
	ld a, $1c
	ldh [hWaveSfx], a

.restore
;> hLinkY = y
	pop af
	ldh [hLinkY], a
;> hLinkX = x
	pop af
	ldh [hLinkX], a
;> SmasherHopFrame(slot)
	jr SmasherHopFrame

jr_006_45f4:
;=@wander
	call IncrementEntityState
;=@hop

;@ def SmasherHopFrame(slot: bc) -> hl
;@ path: boss/smasher
;@ Gives the Smasher a new hop (height speed $10) each time he lands and shows his standing frame
;@ for his facing (0 right, 1 left). Returns hl pointing at his wEntitySpriteVariant byte.
;@ test: skip part of the Smasher's state machine
SmasherHopFrame::
;> if hBGTilesRequestCopy:                   # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .frame

;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

.frame
;> wEntitySpriteVariant[slot] = wEntityDirection[slot] & 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	call SetEntitySpriteVariant
	ret


;@ path: boss/smasher
;@ Horizontal speed of the Smasher's four wandering directions (1/16 pixel per frame; same order
;@ as SmasherWalkSpeedY): $0C, -$0C, $0C, -$0C.
SmasherWalkSpeedX::
	db $0c, $f4, $0c, $f4

;@ path: boss/smasher
;@ Vertical speed of the four wandering directions: -4, -4, 4, 4 (with SmasherWalkSpeedX: up-right,
;@ up-left, down-right, down-left, mostly sideways).
SmasherWalkSpeedY::
	db $fc, $fc, $04, $04

;@ def SmasherWander(slot: bc)
;@ path: boss/smasher
;@ State 1: while the ball is away, hops about in a random diagonal direction, changing every
;@ 16-47 frames; his feet move every 8 frames (frames 2/3). Back to state 0 as soon as the ball
;@ lies on the floor again.
;@ test: skip uses the random generator and banked helpers
SmasherWander::
;> ball = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;> if wEntityState[ball] == 0:              # the ball lies on the floor
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $00
	jr nz, .wander

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.wander
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .move

;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x10
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;>     direction = wEntityTimer[slot] & 3
	and $03
;>     wEntityDirection[slot] = direction
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = SmasherWalkSpeedX[direction]
	ld hl, SmasherWalkSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = SmasherWalkSpeedY[direction]
	ld hl, SmasherWalkSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> SmasherHopFrame(slot)
	call SmasherHopFrame
;> if hFrameCounter & 8:
	ldh a, [hFrameCounter]
	and $08
	jr z, .done

;>     wEntitySpriteVariant[slot] += 2       # step frame
	inc [hl]
	inc [hl]

.done
	ret


;@ path: boss/smasher
;@ X offset (pixels) of the ball from the Smasher during the lift, indexed by step (0-7, counting
;@ down as he lifts) + 8 when he faces left: 0..14 in front of him to the right, 0..-14 to the left.
SmasherLiftBallX::
	db $00, $02, $04, $06, $08, $0a, $0c, $0e, $00, $fe, $fc, $fa, $f8, $f6, $f4, $f2
;@ path: boss/smasher
;@ Height of the ball above the Smasher during the lift, stored negated (-16 .. -2), same index as
;@ SmasherLiftBallX: step 0 (the end) holds it 16 pixels up, step 7 (the start) 2 pixels up.
SmasherLiftBallZ::
	db $f0, $f1, $f2, $f4, $f6, $f8, $fa, $fe, $f0, $f1, $f2, $f4, $f6, $f8, $fa, $fe

;@ def SmasherLiftBall(slot: bc)
;@ path: boss/smasher
;@ State 2: raises the ball from in front of him to over his head in 8 steps of 4 frames
;@ (SmasherLiftBallX/Z), then holds it (state 3, 32 frames).
;@ test: skip part of a state machine (bank-0 helper)
SmasherLiftBall::
;>@lf left = (wEntityDirection[slot] & 1) * 8
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	rla
	rla
;=@lf
	rla
	and $08
	ld e, a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .lift

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
	ret


.lift
;> SmasherPlaceBall(slot, (wEntityTimer[slot] >> 2) & 7 | left)
	rra
	rra
	and $07
	or e

;@ def SmasherPlaceBall(slot: bc, step: a)
;@ path: boss/smasher
;@ Puts the ball at lift step `step` (SmasherLiftBallX/Z): x = Smasher x + offset, height = his
;@ height + the lift height, y = his y + 2. Goes on into SmasherArmsUpFrame.
;@ test: skip part of the Smasher's state machine
SmasherPlaceBall::
;> ball = wSmasherBallSlot
	push bc
	ld c, a
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;>@px wEntityX[ball] = hActiveEntityX + SmasherLiftBallX[step]
	ldh a, [hActiveEntityX]
	ld hl, SmasherLiftBallX
	add hl, bc
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@px
	ld [hl], a
;>@pz wEntityZ[ball] = wEntityZ[slot] - SmasherLiftBallZ[step]
	ld hl, SmasherLiftBallZ
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	pop bc
;=@pz
	ld hl, wEntityZ
	add hl, bc
	add [hl]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>@py wEntityY[ball] = wEntityY[slot] + 2
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $02
	ld hl, wEntityY
	add hl, de
;=@py
	ld [hl], a

;@ def SmasherArmsUpFrame(slot: bc)
;@ path: boss/smasher
;@ Shows the Smasher with his arms raised (frame 2 facing right, 3 facing left).
;@ test: skip bank-0 helper
SmasherArmsUpFrame::
;> frame = wEntityDirection[slot] & 1 | 2
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	or $02
;> wEntitySpriteVariant[slot] = frame
	call SetEntitySpriteVariant
	ret


;@ def SmasherHoldBall(slot: bc)
;@ path: boss/smasher
;@ State 3: holds the ball over his head and edges towards Link (speed 4) for 32 frames, then
;@ throws it: the ball (state 4) flies at Link at speed $20 in an arc (height speed $18) while
;@ the Smasher jumps (height speed $20); state 4, 32 frames.
;@ test: skip moves through banked helpers
SmasherHoldBall::
;> SmasherPlaceBall(slot, 0)                # over his head
	xor a
	call SmasherPlaceBall
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .hold

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     ball = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;>     wEntityState[ball] = 4               # thrown by the Smasher
	ld hl, wEntityState
	add hl, de
	ld [hl], $04
;>     SetEntitySpeedTowardsLink(0x20, slot=ball)           # aim the ball at Link
	push bc
	push de
	pop bc
	ld a, $20
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[ball] = 0x18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
	pop bc
;>     wEntitySpeedZ[slot] = 0x20           # he jumps as he throws
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret


.hold
;> SmasherHopFrame(slot)
	call SmasherHopFrame
;> SetEntitySpeedTowardsLink(4)                             # creep towards Link
	ld a, $04
	call SetEntitySpeedTowardsLink
;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> SmasherArmsUpFrame(slot)
	call SmasherArmsUpFrame
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
	ret


;@ def SmasherAfterThrow(slot: bc)
;@ path: boss/smasher
;@ State 4: stands (frame 0/1) for 32 frames after the throw, then goes for the ball again.
;@ test: skip part of a state machine (bank-0 helper)
SmasherAfterThrow::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.frame
;> wEntitySpriteVariant[slot] = wEntityDirection[slot] & 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	call SetEntitySpriteVariant
	ret


;@ path: boss/smasher
;@ The Smasher's body: 4 frames of 4 sprites, 16 bytes each, every sprite y offset, x offset,
;@ tile, attributes ($20 mirrored), drawn by SmasherDraw. A row of three 8x16 sprites (x -4, 4,
;@ 12) plus tile $6C 16 pixels higher. Frame 0 standing facing right (tiles $64 $62 $60 mirrored),
;@ 1 standing facing left ($60 $62 $64), 2 arms up facing right ($6A $68 $66 mirrored), 3 arms
;@ up facing left ($66 $68 $6A); frames 2/3 are also his walking step.
SmasherOAM::
	db $00, $fc, $64, $20, $00, $04, $62, $20, $00, $0c, $60, $20, $f0, $fc, $6c, $20
	db $00, $fc, $60, $00, $00, $04, $62, $00, $00, $0c, $64, $00, $f0, $0c, $6c, $00
	db $00, $fc, $6a, $20, $00, $04, $68, $20, $00, $0c, $66, $20, $f0, $fc, $6c, $00
	db $00, $fc, $66, $00, $00, $04, $68, $00, $00, $0c, $6a, $00, $f0, $0c, $6c, $20

;@ def SmasherDraw(slot: bc)
;@ path: boss/smasher
;@ Draws the Smasher's current frame from SmasherOAM (4 sprites).
;@ test: skip draws sprites
SmasherDraw::
;>@d DrawEntitySprites(SmasherOAM + hActiveEntitySpriteVariant * 16, count=4)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;=@d
	ld e, a
	ld d, b
	ld hl, SmasherOAM
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> DrawEntityShadow()
	jp DrawEntityShadow


;@ path: boss/smasher
;@ The iron ball for the two-sprite renderer: one frame, tile $6E and the same tile mirrored.
SmasherBallSprites::
	db $6e, $00, $6e, $20

;@ def SmasherBallHandler(slot: bc)
;@ path: boss/smasher
;@ The Smasher's iron ball (entity $92 with wEntityPrivate4 set). It can be lifted by Link like
;@ a pot; gravity 2, it bounces when it lands hard (half the fall speed back, the bounce sound
;@ from 7 up) and loses 3/4 of its speed with every bounce. hMultiPurposeH = its height before the
;@ landing check, hBGTilesRequestCopy (scratch) = landed this frame.
;@ test: skip draws sprites and calls banked helpers
SmasherBallHandler::
;> wEntityPhysicsFlags[slot] = 0x92
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $92
;> mem[0xC5D0 + slot] = 0xFF
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff
;> DrawEntity16x16(SmasherBallSprites)
	ld de, SmasherBallSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits()                              # hits from Link's weapons
	call EntityCheckWeaponHits
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hMultiPurposeH = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
;> hBGTilesRequestCopy = hMultiPurposeH & 0x80
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:                   # hit the floor
	jr z, .walls

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     bounce = ~(signed(wEntitySpeedZ[slot]) >> 1) & 0xFF      # about half the fall speed, upwards
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
;>     if bounce < 7:
	cp $07
	jr nc, .bounce

;>         bounce = 0
	xor a
	jr .setBounce

.bounce
;>     else:
;>         hJingle = 0x09
	ld a, $09
	ldh [hJingle], a

.setBounce
;>     wEntitySpeedZ[slot] = bounce
	ld [hl], a
;>     wEntitySpeedX[slot] = signed(wEntitySpeedX[slot]) >> 2
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	sra [hl]
;>     wEntitySpeedY[slot] = signed(wEntitySpeedY[slot]) >> 2
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
	sra [hl]

.walls
;> EntityCheckWalls()
	call EntityCheckWalls
;> SmasherBallStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/smasher
;@ The ball's states: 0 lying (Link may lift it), 1 carried by the Smasher, 2 lifted by Link,
;@ 3 thrown by Link, 4 thrown by the Smasher.
SmasherBallStates::
	dw SmasherBallLying
	dw SmasherBallCarried
	dw SmasherBallLifted
	dw SmasherBallThrownByLink
	dw SmasherBallThrownBySmasher

;@ def SmasherBallLying(slot: bc)
;@ path: boss/smasher
;@ State 0: on the floor the ball slows down by 1 per frame on each axis. Link lifts it when he
;@ touches it with the Power Bracelet on B (B pressed) or A (A pressed), is not busy using an
;@ item and carries nothing: state 2, entity status 7 (carried by Link).
;@ test: skip bank-0 helpers
SmasherBallLying::
;> if (hMultiPurposeH - 1) & 0x80:          # on the floor
	ldh a, [hMultiPurposeH]
	dec a
	and $80
	jr z, jr_006_481e

;>     SmasherBallSlowDown(slot, wEntitySpeedY)
	ld hl, wEntitySpeedY
	call SmasherBallSlowDown
;>     SmasherBallSlowDown(slot, wEntitySpeedX)
	ld hl, wEntitySpeedX

;@ def SmasherBallSlowDown(slot: bc, speed: hl)
;@ path: boss/smasher
;@ Brings one speed of the ball (the array `speed`) 1 closer to 0, then checks whether Link
;@ lifts it (also reached directly when the ball is in the air).
;@ test: skip bank-0 helpers
SmasherBallSlowDown::
;> if speed[slot] != 0:
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_481e

;>@s     speed[slot] += 1 if speed[slot] & 0x80 else -1
	and $80
	jr z, .dec

	inc [hl]
	inc [hl]

.dec
;=@s
	dec [hl]

jr_006_481e:
;> if not EntityTouchesLink():                      # Link does not touch it
	call EntityTouchesLink
;>     return
	jr nc, .done

;> if wItemUsePoseTimer:
	ld a, [wItemUsePoseTimer]
	and a
;>     return
	jr nz, .done

;> if wItemB == 3:                          # Power Bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .itemA

;>     if not hJoypadPressed & 0x20:
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .lift

;>         return
	jr .done

.itemA
;> elif wItemA != 3 or not hJoypadPressed & 0x10:
	ld a, [wItemA]
	cp $03
	jr nz, .done

	ldh a, [hJoypadPressed]
	and $10
;>     return
	jr z, .done

.lift
;> if wLinkIsCarrying:
	ld a, [wLinkIsCarrying]
	and a
;>     return
	jr nz, .done

;> wEntityState[slot] = 2
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
;> hWaveSfx = 2
	ld hl, hWaveSfx
	ld [hl], $02

.done
	ret


;@ def SmasherBallCarried(slot: bc)
;@ path: boss/smasher
;@ State 1: carried by the Smasher, who positions it; nothing to do.
;@ test: skip does nothing
SmasherBallCarried::
;> return
	ret


;@ def SmasherBallLifted(slot: bc)
;@ path: boss/smasher
;@ State 2: lifted by Link (the carried-object code moves it); nothing to do.
;@ test: skip does nothing
SmasherBallLifted::
;> return
	ret


;@ def SmasherBallThrownByLink(slot: bc)
;@ path: boss/smasher
;@ State 3: thrown by Link. If it hits the Smasher (within 12 pixels of him, measured from its
;@ drawn height) he flashes for 32 frames, can't be hit for 16, is knocked back with the ball's
;@ speed and loses 2 health; the ball bounces back at half speed (state 0). When his health runs
;@ out both are destroyed (status 1, dying). Then the landing / wall bounce of SmasherBallBounce.
;@ test: skip bank-0 helpers
SmasherBallThrownByLink::
;> smasher = wSmasherSlot
	ld a, [wSmasherSlot]
	ld e, a
	ld d, b
;> if u8(hActiveEntityX - wEntityX[smasher] + 0x0C) >= 0x18:
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $0c
	cp $18
;>     return SmasherBallBounce(slot)
	jp nc, .miss

;> if u8(hActiveEntityDrawY - wEntityY[smasher] + 0x0C) >= 0x18:
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
	cp $18
;>     return SmasherBallBounce(slot)
	jr nc, .miss

;> wEntityIgnoreHitsTimer[smasher] = 0x10
	ld hl, wEntityIgnoreHitsTimer
	add hl, de
	ld [hl], $10
;> wEntityFlashTimer[smasher] = 0x20
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $20
;>@rx wEntityRecoilSpeedX[smasher] = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, wEntityRecoilSpeedX
	add hl, de
;=@rx
	ld [hl], a
;> wEntitySpeedX[slot] = signed(-wEntitySpeedX[slot]) >> 1      # bounce back at half speed
	pop hl
	cpl
	inc a
	sra a
	ld [hl], a
;>@ry wEntityRecoilSpeedY[smasher] = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, wEntityRecoilSpeedY
	add hl, de
;=@ry
	ld [hl], a
;> wEntitySpeedY[slot] = signed(-wEntitySpeedY[slot]) >> 1
	pop hl
	cpl
	inc a
	sra a
	ld [hl], a
;> hWaveSfx = 0x07
	ld a, $07
	ldh [hWaveSfx], a
;> wEntityHealth[smasher] -= 2
	ld hl, wEntityHealth
	add hl, de
	ld a, [hl]
	sub $02
	ld [hl], a
;> if (wEntityHealth[smasher] - 1) & 0x80:  # health used up
	dec a
	and $80
	jr z, .hit

;>     wEntityStatus[smasher] = 1           # dying
	ld hl, wEntityStatus
	add hl, de
	ld [hl], $01
;>     wEntityStatus[slot] = 1
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
;>     wEntityDyingTimer[slot] = 0x1F
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
;>     wEntityPhysicsFlags[slot] = 4
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	ld [hl], $04
;>     wEntityOptions1[slot] &= ~0x80
	ld hl, wEntityOptions1
	add hl, bc
	res 7, [hl]
;>     hWaveSfx = 0x10
	ld a, $10
	ldh [hWaveSfx], a

.hit
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.miss
;> SmasherBallBounce(slot)
	jr SmasherBallBounce

;@ def SmasherBallThrownBySmasher(slot: bc)
;@ path: boss/smasher
;@ State 4: thrown by the Smasher; it hurts Link on contact (EntityCheckContactDamage, checked with physics flags
;@ $12, then $92 again). SmasherBallBounce: once it lands it lies there (state 0); if it hits a
;@ wall first it bounces off it at half speed and also stops flying (state 0).
;@ test: skip bank-0 helpers
SmasherBallThrownBySmasher::
;> wEntityPhysicsFlags[slot] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $12
;> EntityCheckContactDamage()                              # contact damage to Link
	call EntityCheckContactDamage
;> wEntityPhysicsFlags[slot] = 0x92
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $92

SmasherBallBounce:
;> if not hBGTilesRequestCopy:              # still in the air
	ldh a, [hBGTilesRequestCopy]
	and a
	jr nz, .stop

;>     if wEntityCollisions[slot] == 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>         return
	jr z, .done

;>     axis = wEntitySpeedX if wEntityCollisions[slot] & 3 else wEntitySpeedY
	and $03
	jr z, .vertical

	ld hl, wEntitySpeedX
	jr .reverse

.vertical
	ld hl, wEntitySpeedY

.reverse
;>     axis[slot] = signed(-axis[slot]) >> 1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a

.stop
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.done
	ret


;@ path: enemy/three_of_a_kind
;@ Three-of-a-Kind card frames for the two-sprite renderer: 8 frames of 4 bytes (left sprite tile,
;@ attributes, right sprite tile, attributes; $20 = mirrored). Frame = symbol * 2 + animation step:
;@ symbol 0 tiles $74/$76, symbol 1 $70/$72, symbol 2 $78/$7A, symbol 3 $7C/$7E; the second step
;@ shows the same card mirrored.
ThreeOfAKindSprites::
	db $74, $00, $76, $00, $76, $20, $74, $20, $70, $00, $72, $00, $72, $20, $70, $20
	db $78, $00, $7a, $00, $7a, $20, $78, $20, $7c, $00, $7e, $00, $7e, $20, $7c, $20

;@ def ThreeOfAKindHandler(slot: bc)
;@ path: enemy/three_of_a_kind
;@ Entity $90: Three-of-a-Kind, a card that keeps changing its symbol (wEntityDirection is the
;@ symbol, 0-3). A sword hit freezes the card on its symbol; once all three cards of the room are
;@ frozen, they vanish together if they show the same symbol, else they all start again. Their
;@ health is reset to $20 every frame, so normal damage never kills them.
;@ test: skip draws sprites and calls banked helpers
ThreeOfAKindHandler::
;> wEntityHealth[slot] = 0x20
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $20
;> DrawEntity16x16(ThreeOfAKindSprites)
	ld de, ThreeOfAKindSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> ThreeOfAKindStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/three_of_a_kind
;@ The card's states: 0 moving, 1 pausing, 2 frozen by a hit.
ThreeOfAKindStates::
	dw ThreeOfAKindMove
	dw ThreeOfAKindPause
	dw ThreeOfAKindFrozen

;@ def ThreeOfAKindMove(slot: bc)
;@ path: enemy/three_of_a_kind
;@ State 0: moves until the timer runs out, then stops for 32 frames (state 1); animates.
;@ ThreeOfAKindCycleSymbol (also used by state 1): the symbol advances every 16 frames, the frame
;@ is symbol * 2 + step; a hit (no-hit timer running) freezes the card: state 2, 64 frames.
;@ test: skip bank-0 helpers
ThreeOfAKindMove::
;> EntityCheckHits()                              # contact damage and weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     ClearEntitySpeed()                          # stop
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState

.animate
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]

ThreeOfAKindCycleSymbol:
;> if hFrameCounter & 0x0F == 0:
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .frame

;>     wEntityDirection[slot] = (wEntityDirection[slot] + 1) & 3     # next symbol
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

.frame
;>@f frame = wEntityDirection[slot] * 2 | (wEntityPrivateCounter[slot] >> 3) & 1
	ld e, [hl]
	sla e
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	rra
;=@f
	rra
	rra
	and $01
	or e
;> wEntitySpriteVariant[slot] = frame
	call SetEntitySpriteVariant
;> if wEntityIgnoreHitsTimer[slot]:          # just hit by the sword
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;>     wEntityState[slot] = 2               # frozen
	call IncrementEntityState
	ld [hl], $02
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     ClearEntitySpeed()
	call ClearEntitySpeed

.done
	ret


;@ path: enemy/three_of_a_kind
;@ Horizontal speed of the card's four move directions (1/16 pixel per frame): right $0C, left
;@ -$0C, up 0, down 0. ThreeOfAKindSpeedY has the vertical speeds.
ThreeOfAKindSpeedX::
	db $0c, $f4, $00, $00

;@ path: enemy/three_of_a_kind
;@ Vertical speed of the four move directions: 0, 0, up -$0C, down $0C.
ThreeOfAKindSpeedY::
	db $00, $00, $f4, $0c

;@ def ThreeOfAKindPause(slot: bc)
;@ path: enemy/three_of_a_kind
;@ State 1: stands still (the symbol keeps changing); when the timer runs out it moves for 32-63
;@ frames in a random direction (state 0).
;@ test: skip uses the random generator and banked helpers
ThreeOfAKindPause::
;> EntityCheckHits()
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .cycle

;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x20
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     direction = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = ThreeOfAKindSpeedX[direction]
	ld hl, ThreeOfAKindSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = ThreeOfAKindSpeedY[direction]
	ld hl, ThreeOfAKindSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.cycle
;> ThreeOfAKindCycleSymbol(slot)
	jr ThreeOfAKindCycleSymbol

;@ def ThreeOfAKindFrozen(slot: bc)
;@ path: enemy/three_of_a_kind
;@ State 2: frozen on its symbol for 64 frames. The first card of the room's list (load order 0)
;@ judges: when exactly three cards are frozen with their timers run out, it compares their
;@ symbols (collected in hMultiPurpose2..4). All the same: every card disappears (status 1,
;@ dying), dropping a heart (entity $2D) for symbol 0, rupees ($2E) for symbol 1 and nothing
;@ ($FF) for 2 and 3, with jingle 2 for a prize; otherwise all cards go back to state 0.
;@ test: skip scans all entity slots
ThreeOfAKindFrozen::
;> if wEntityLoadOrder[slot] != 0:         # only the first card judges
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jp nz, .done

;> hMultiPurpose0 = 0                       # count the frozen cards
	ldh [hMultiPurpose0], a
	ld e, $0f
	ld d, b

.count
;>@l1 for other in range(15, -1, -1):
;>@i1     if wEntityStatus[other] and wEntityType[other] == 0x90 and wEntityState[other] == 2 and wEntityTimer[other] == 0:
;=@i1
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .nextCount

;=@i1
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $90
	jr nz, .nextCount

;=@i1
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, .nextCount

;=@i1
	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	and a
	jr nz, .nextCount

;>         hMultiPurpose0 += 1
	ldh a, [hMultiPurpose0]
	inc a
	ldh [hMultiPurpose0], a

.nextCount
;=@l1
	dec e
	ld a, e
	cp $ff
	jr nz, .count

;> if hMultiPurpose0 != 3:
	ldh a, [hMultiPurpose0]
	cp $03
;>     return
	jp nz, .done

;> n = 0                                    # collect the symbols in hMultiPurpose2, 3, 4
	push bc
	ld c, b
	ld e, $0f
	ld d, b

.collect
;>@l2 for other in range(15, -1, -1):
;>@i2     if wEntityStatus[other] and wEntityType[other] == 0x90:
;=@i2
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .nextCollect

;=@i2
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $90
	jr nz, .nextCollect

;>         mem[hMultiPurpose2 + n] = wEntityDirection[other]
	ld hl, wEntityDirection
	add hl, de
	ld a, [hl]
	ld hl, hMultiPurpose2
	add hl, bc
	ld [hl], a
;>         n += 1
	inc bc

.nextCollect
;=@l2
	dec e
	ld a, e
	cp $ff
	jr nz, .collect

;=@l2
	pop bc
;> PlayNoAmmoSound()                              # sound
	call PlayNoAmmoSound
;> result = 0                               # 0 = no match: start again
	ld e, $00
;>@m if hMultiPurpose2 == hMultiPurpose3 == hMultiPurpose4:
	ldh a, [hMultiPurpose2]
	ld hl, hMultiPurpose3
	cp [hl]
	jr nz, .apply

;=@m
	inc hl
	cp [hl]
	jr nz, .apply

;>     result = 0xFF                        # a match, no prize
	ld e, $ff
;>     if hMultiPurpose2 < 2:
	cp $02
	jr nc, .apply

;>         hJingle = 0x02
	ld hl, hJingle
	ld [hl], $02
;>         result = 0x2D if hMultiPurpose2 == 0 else 0x2E      # heart or rupees
	ld e, $2d
	cp $01
	jr nz, .apply

	ld e, $2e

.apply
;> hBGTilesRequestCopy = result             # scratch
	ld a, e
	ldh [hBGTilesRequestCopy], a
	ld e, $0f
	ld d, b

.loop
;>@l3 for other in range(15, -1, -1):
;>@i3     if wEntityStatus[other] and wEntityType[other] == 0x90:
;=@i3
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

;=@i3
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $90
	jr nz, .next

;>         if not result:
	ldh a, [hBGTilesRequestCopy]
	and a
	jr nz, .vanish

;>             wEntityState[other] = 0
	ld hl, wEntityState
	add hl, de
	ld [hl], d
	jr .next

.vanish
;>         else:
;>             wEntityDropType[other] = result
	ld hl, wEntityDropType
	add hl, de
	ld [hl], a
;>             wEntityDyingTimer[other] = 0x1F
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $1f
;>             wEntityStatus[other] = 1             # dying
	ld hl, wEntityStatus
	add hl, de
	ld [hl], $01
;>             wEntityPhysicsFlags[other] = 4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $04
;>             hNoiseSfx = 0x13
	ld hl, hNoiseSfx
	ld [hl], $13

.next
;=@l3
	dec e
	ld a, e
	cp $ff
	jr nz, .loop

.done
	ret


;@ path: enemy/stalfos
;@ The jumping Stalfos' frames for the two-sprite renderer: 3 frames of 4 bytes (left tile,
;@ attributes, right tile, attributes; $20 mirrored): 0 and 1 walking (tiles $4A/$4C and the
;@ same mirrored), 2 jumping (tile $4E and its mirror).
StalfosSprites::
	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

;@ def StalfosHandler(slot: bc)
;@ path: enemy/stalfos
;@ Entity $1A: the Stalfos that walks up to Link and leaps at him: it jumps when Link is within
;@ 28 pixels, hangs in the air for a moment and slams down on the spot, raising dust.
;@ test: skip draws sprites and calls banked helpers
StalfosHandler::
;> DrawEntity16x16(StalfosSprites)
	ld de, StalfosSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits()                              # contact damage and weapon hits
	call EntityCheckHits
;> StalfosStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/stalfos
;@ The jumping Stalfos' states: 0 wait, 1 walk towards Link, 2 jump, 3 hang and slam down.
StalfosStates::
	dw StalfosWait
	dw StalfosApproach
	dw StalfosJump
	dw StalfosSlam

;@ def StalfosWait(slot: bc)
;@ path: enemy/stalfos
;@ State 0: stands until its timer runs out (32 frames after a landing), then walks (state 1).
;@ test: skip bank-0 helpers
StalfosWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def StalfosApproach(slot: bc)
;@ path: enemy/stalfos
;@ State 1: walks towards Link at speed 8 (re-aimed every 4 frames, staggered by slot). When Link
;@ is within 28 pixels on both axes it leaps at him: height speed $28, speed $10 towards him,
;@ state 2. Walking frames 0/1 every 4 frames.
;@ test: skip moves through banked helpers
StalfosApproach::
;> if (hFrameCounter ^ slot) & 3 == 0:
	ldh a, [hFrameCounter]
	xor c
	and $03
	jr nz, .near

;>     SetEntitySpeedTowardsLink(8)                         # walk towards Link
	ld a, $08
	call SetEntitySpeedTowardsLink

.near
;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x1C) < 0x38:
	add $1c
	cp $38
	jr nc, .move

;>     dy, side = GetEntityYDistanceToLink_06()
	call GetEntityYDistanceToLink_06
;>     if u8(dy + 0x1C) < 0x38:
	add $1c
	cp $38
	jr nc, .move

;>         wEntitySpeedZ[slot] = 0x28          # leap
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $28
;>         SetEntitySpeedTowardsLink(0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>         wEntityState[slot] += 1
	call IncrementEntityState

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntitySpriteVariant[slot] = (hFrameCounter >> 2) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


;@ def StalfosJump(slot: bc)
;@ path: enemy/stalfos
;@ State 2: flies towards Link, rising with gravity 2 per frame. At the top of the leap (height
;@ speed 0 or 1) it stops in the air for 16 frames, ready to slam down at height speed -$40
;@ (state 3). Frame 2.
;@ test: skip bank-0 helpers
StalfosJump::
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntitySpeedZ[slot] < 2:             # top of the leap
	ld a, [hl]
	cp $02
	jr nc, .frame

;>     wEntitySpeedZ[slot] = 0xC0
	ld [hl], $c0
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     ClearEntitySpeed()                          # stop moving
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState

.frame
;> wEntitySpriteVariant[slot] = 2
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ def StalfosSlam(slot: bc)
;@ path: enemy/stalfos
;@ State 3: hangs in the air until the timer runs out, then drops straight down. On the ground
;@ it waits 32 frames (state 0); a hard landing (falling faster than -$30) makes the impact
;@ effect of AddClinkVfx (effect 5 with jingle 7) just below it.
;@ test: skip bank-0 helpers
StalfosSlam::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done

;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> if wEntityZ[slot] != 0 and not wEntityZ[slot] & 0x80:   # still in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .landed

	and $80
;>     return
	jr z, .done

.landed
;> wEntityZ[slot] = 0
	ld [hl], b
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> fall = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> wEntitySpeedZ[slot] = 0
	ld [hl], b
;> if fall & 0x80 and fall < 0xD0:          # a hard landing
	bit 7, a
	jr z, .done

	cp $d0
	jr nc, .done

;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityDrawY + 12
	ldh a, [hActiveEntityDrawY]
	add $0c
	ldh [hMultiPurpose1], a
;>     AddClinkVfx()                          # impact effect
	call AddClinkVfx

.done
	ret


;@ path: enemy/cue_ball
;@ For each of the Cue Ball's directions (0 right, 1 down, 2 left, 3 up), the value
;@ GetEntityDirectionToLink_06 gives when Link is in front of it (0 right, 3 below, 1 left, 2 above).
CueBallFrontDirection::
	db $00, $03, $01, $02

;@ def CueBallHandler(slot: bc)
;@ path: boss/cue_ball
;@ Entity $8E: the Cue Ball miniboss, a big ball (8 sprites) that rolls around the room and
;@ turns at the edges of its area. It can only be hurt from behind or the sides: while it rolls
;@ (state 0) with Link in front, its options are $84 instead of $C4 (bit 6 cleared - the hit is
;@ blocked). Entity $8E with wEntityPrivate1 set is the dust it throws up (CueBallDustHandler).
;@ Health 8.
;@ test: skip draws sprites and calls banked helpers
CueBallHandler::
;> if wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
;>     return CueBallDustHandler(slot)
	jp nz, CueBallDustHandler

;> if wEntityPrivate3[slot] == 0:           # first frame
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .run

;>     wEntityPrivate3[slot] = 1
	inc [hl]
;>     wEntityHealth[slot] = 8
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $08
;>     wEntityPrivate4[slot] = 1            # turn clockwise
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], $01

.run
;> ConfineLinkToArena()                              # keep Link out of the doorway
	call ConfineLinkToArena
;> CueBallDraw(slot)
	call CueBallDraw
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return MinibossDefeated(slot)
	jp nz, MinibossDefeated

;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> Call_3F12()                              # miniboss music
	call Call_3F12
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckContactDamage()                              # contact damage
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> if not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .dispatch

;>     wEntityOptions1[slot] = 0xC4
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $c4
;>     if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .hits

;>@t1         front = CueBallFrontDirection[wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, CueBallFrontDirection
	add hl, de
;=@t1
	ld a, [hl]
;>         if GetEntityDirectionToLink_06() != front:     # Link is not in front of it
	push af
	call GetEntityDirectionToLink_06
	pop af
	cp e
	jr z, .hits

;>             wEntityOptions1[slot] = 0x84
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $84

.hits
;>     EntityCheckWeaponHits()                          # weapon hits
	call EntityCheckWeaponHits

.dispatch
;> CueBallStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/cue_ball
;@ The Cue Ball's states: 0 roll, 1 spin after a hit.
CueBallStates::
	dw CueBallRoll
	dw CueBallSpin

;@ path: boss/cue_ball
;@ Horizontal rolling speed for the directions 0 right, 1 down, 2 left, 3 up ($14 = 1.25 pixels
;@ per frame); CueBallSpeedY has the vertical ones.
CueBallSpeedX::
	db $14, $00, $ec, $00

;@ path: boss/cue_ball
;@ Vertical rolling speed for the directions 0 right, 1 down, 2 left, 3 up.
CueBallSpeedY::
	db $00, $14, $00, $ec

;@ path: boss/cue_ball
;@ The Cue Ball's frame (CueBallOAM entry) for direction * 2 + rolling step (every 8 frames).
CueBallFrames::
	db $06, $07, $00, $01, $04, $05, $02, $03
;@ path: boss/cue_ball
;@ X offsets of the two dust clouds thrown up behind the rolling Cue Ball, index direction * 2 +
;@ cloud (0, 1); the other CueBallDust tables use the same index.
CueBallDustX::
	db $10, $10, $f4, $0c, $f0, $f0, $f4, $0c

;@ path: boss/cue_ball
;@ Y offsets of the two dust clouds (index direction * 2 + cloud).
CueBallDustY::
	db $f4, $0c, $10, $10, $f4, $0c, $f0, $f0
;@ path: boss/cue_ball
;@ Horizontal speed of the dust clouds ($80 / $7F: one jump of 8 pixels, made once).
CueBallDustSpeedX::
	db $80, $80, $80, $7f, $7f, $7f, $80, $7f

;@ path: boss/cue_ball
;@ Vertical speed of the dust clouds.
CueBallDustSpeedY::
	db $80, $7f, $80, $80, $80, $7f, $7f, $7f
;@ path: boss/cue_ball
;@ Frame of each dust cloud (CueBallDustSprites: 0 plain, 1 mirrored, 2 flipped, 3 both).
CueBallDustFrames::
	db $00, $02, $00, $01, $01, $03, $02, $03

;@ def CueBallRoll(slot: bc)
;@ path: boss/cue_ball
;@ State 0: rolls on (CueBallCheckBounds). After a hit (flashing) it spins for 88 frames (state 1),
;@ remembering its direction, and half the time reverses its turning sense (wEntityPrivate4 = +1
;@ or -1). When it stopped at an edge, the frame before its pause ends it turns by
;@ wEntityPrivate4 and rolls on.
;@ test: skip bank-0 helpers
CueBallRoll::
;> if wEntityFlashTimer[slot]:              # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .rolling

;>     CueBallCheckBounds(slot)
	call CueBallCheckBounds
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityPrivate5[slot] = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
;>     wEntityTimer[slot] = 0x58
	call GetEntityTimer
	ld [hl], $58
;>     if GetRandomByte() & 1 == 0:
	call GetRandomByte
	and $01
	jr nz, .stop

;>         wEntityPrivate4[slot] = u8(-wEntityPrivate4[slot])     # turn the other way
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.stop
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     return
	ret


.rolling
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return CueBallCheckBounds(slot)
	jr z, CueBallCheckBounds

;> if wEntityTimer[slot] == 1:              # pause at the edge over
	cp $01
;>     return CueBallTurn(slot)
	jr z, CueBallTurn

	ret


;@ def CueBallCheckBounds(slot: bc)
;@ path: boss/cue_ball
;@ Keeps the Cue Ball inside its area (x $20-$7F, y $28-$67): outside it, it is put back where
;@ it was this frame, stops and pauses for 21 frames; inside, it rolls on (CueBallMove).
;@ test: skip part of a state machine
CueBallCheckBounds::
;>@t2 if not 0x20 <= wEntityX[slot] < 0x80:
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	cp $20
	jr c, .backX

;=@t2
	cp $80
	jr nc, .backX
;>@bx     wEntityX[slot] = hActiveEntityX

;>@t3 elif not 0x28 <= wEntityY[slot] < 0x68:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $28
	jr c, .backY

;=@t3
	cp $68
;>@by     wEntityY[slot] = hActiveEntityY
;> else:
;>     return CueBallMove(slot)
	jr c, CueBallMove

.backY
;=@by
	ldh a, [hActiveEntityY]
	ld [hl], a
	jr .pause

.backX
;=@bx
	ldh a, [hActiveEntityX]
	ld [hl], a

.pause
;> wEntityTimer[slot] = 0x15
	call GetEntityTimer
	ld [hl], $15
;> ClearEntitySpeed()
	call ClearEntitySpeed
;> return
	ret


;@ def CueBallTurn(slot: bc)
;@ path: boss/cue_ball
;@ Turns the Cue Ball by wEntityPrivate4 (+1 clockwise, -1 the other way) and rolls on
;@ (runs into CueBallMove).
;@ test: skip part of a state machine
CueBallTurn::
;>@t4 wEntityDirection[slot] = (wEntityDirection[slot] + wEntityPrivate4[slot]) & 3
	ld hl, wEntityPrivate4
	add hl, bc
	ld e, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
;=@t4
	add e
	and $03
	ld [hl], a

;@ def CueBallMove(slot: bc)
;@ path: boss/cue_ball
;@ Sets the rolling speed for the Cue Ball's direction and its frame (CueBallFrames); every 16
;@ frames a rumble (noise $2F) and two dust clouds behind it: entity $8E with wEntityPrivate1 = 1,
;@ placed, moved and drawn after the CueBallDust tables, gone after 12 frames.
;@ test: skip spawns entities
CueBallMove::
;> direction = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = CueBallSpeedX[direction]
	ld hl, CueBallSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = CueBallSpeedY[direction]
	ld hl, CueBallSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>@t5 step = (direction * 2 | (hFrameCounter >> 3) & 1) & 7
	sla e
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;=@t5
	or e
	and $07
;> wEntitySpriteVariant[slot] = CueBallFrames[step]
	ld e, a
	ld d, b
	ld hl, CueBallFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> if hFrameCounter & 0x0F:
	ldh a, [hFrameCounter]
	and $0f
;>     return
	jr nz, .done

;> hNoiseSfx = 0x2F
	ld a, $2f
	ldh [hNoiseSfx], a
;> cloud = 1
	ld a, $01

.cloud
;> while True:
;>     hBGTilesRequestCopy = cloud          # scratch
	ldh [hBGTilesRequestCopy], a
;>     dust = SpawnEntity(0x8E)
	ld a, $8e
	call SpawnEntity
;>     if dust is None:
;>         return
	jr c, .done

;>@t6     i = wEntityDirection[slot] * 2 | cloud
	push bc
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, hBGTilesRequestCopy
;=@t6
	or [hl]
	ld c, a
;>@t7     wEntityX[dust] = hMultiPurpose0 + CueBallDustX[i]
	ld hl, CueBallDustX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@t7
	ld [hl], a
;>@t8     wEntityY[dust] = hMultiPurpose1 + CueBallDustY[i]
	ld hl, CueBallDustY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@t8
	ld [hl], a
;>     wEntitySpeedX[dust] = CueBallDustSpeedX[i]
	ld hl, CueBallDustSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[dust] = CueBallDustSpeedY[i]
	ld hl, CueBallDustSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[dust] = CueBallDustFrames[i]
	ld hl, CueBallDustFrames
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[dust] = 1            # it is dust
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>     wEntityPhysicsFlags[dust] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;>     wEntityOptions1[dust] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
;>     wEntityTimer[dust] = 0x0C
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $0c
	pop bc
;>     cloud -= 1
	ldh a, [hBGTilesRequestCopy]
	dec a
;>     if cloud < 0:
;>         break
	cp $ff
	jr nz, .cloud

.done
	ret


;@ def CueBallSpin(slot: bc)
;@ path: boss/cue_ball
;@ State 1: after a hit it spins on the spot (direction +1 every 4 frames) until the timer runs
;@ out, then rolls off the way it came from (the old direction reversed), state 0.
;@ test: skip part of a state machine
CueBallSpin::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .spin

;>@t9     wEntityDirection[slot] = wEntityPrivate5[slot] ^ 2       # reverse
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	xor $02
	ld hl, wEntityDirection
	add hl, bc
;=@t9
	ld [hl], a
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


.spin
;> if wEntityTimer[slot] & 3 == 0:
	and $03
	jr nz, .show

;>     wEntityDirection[slot] = (wEntityDirection[slot] + 1) & 3
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

.show
;> CueBallMove(slot)                        # frame (and dust)
	call CueBallMove
;> ClearEntitySpeed()                              # but no movement
	call ClearEntitySpeed
	ret


;@ path: boss/cue_ball
;@ The Cue Ball's 8 frames, 32 bytes each: 8 sprites of 4 bytes (y offset, x offset, tile,
;@ attributes; $20 mirrored, $40 flipped, $60 both), a 32x32 ball of two rows (y -8 and +8) of
;@ four 8x16 sprites (x -8, 0, 8, 16) built from tiles $60-$6A. Chosen by CueBallFrames.
CueBallOAM::
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $fa, $f8, $60, $00, $fa, $00, $62, $00, $fa, $08, $62, $20, $fa, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $06, $f8, $60, $40, $06, $00, $62, $40, $06, $08, $62, $60, $06, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $06, $62, $20, $f8, $0e, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $06, $62, $60, $08, $0e, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60
	db $f8, $fa, $60, $00, $f8, $02, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $fa, $60, $40, $08, $02, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60

;@ def CueBallDraw(slot: bc)
;@ path: boss/cue_ball
;@ Draws the Cue Ball's current frame from CueBallOAM (8 sprites).
;@ test: skip draws sprites
CueBallDraw::
;>@t10 DrawEntitySprites(CueBallOAM + hActiveEntitySpriteVariant * 32, count=8)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
;=@t10
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, CueBallOAM
	add hl, de
;=@t10
	ld c, $08
	call DrawEntitySprites
	ret


;@ path: boss/cue_ball
;@ The Cue Ball's dust cloud for the two-sprite renderer: 4 frames of 4 bytes (tiles $6C/$6E):
;@ 0 plain, 1 mirrored, 2 flipped upside down, 3 both.
CueBallDustSprites::
	db $6c, $00, $6e, $00, $6e, $20, $6c, $20, $6c, $40, $6e, $40, $6e, $60, $6c, $60

;@ def CueBallDustHandler(slot: bc)
;@ path: boss/cue_ball
;@ A dust cloud from the rolling Cue Ball (entity $8E with wEntityPrivate1 set): makes its one
;@ jump (8 pixels) when its timer reaches 6 and disappears when it runs out.
;@ test: skip draws sprites
CueBallDustHandler::
;> DrawEntity16x16(CueBallDustSprites)
	ld de, CueBallDustSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return ClearEntityStatus_06()
	jp z, ClearEntityStatus_06

;> if wEntityTimer[slot] == 6:
	cp $06
	jr nz, .done

;>     UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06

.done
	ret


;@ path: object/lever_gate
;@ The lever-operated gate's frame for the two-sprite renderer: tiles $F8 and $FA, sprite
;@ palette 1 (attribute $10).
LeverGateSprites::
	db $f8, $10, $fa, $10

;@ def LeverGateShiftXHandler(slot: bc)
;@ path: object/lever_gate
;@ Entity $8C: a gate worked by the lever Link pulls (hLeverPullState). On its first frame it
;@ moves 8 pixels right (to sit between two squares) and starts at height 16. LeverGateUpdate,
;@ shared with entity $8D: while the lever is being pulled the gate rises a pixel every 10
;@ frames (noise $11) up to height 32; when the lever is let go it sinks a pixel every 16
;@ frames. Below height 4 it shoves Link away (speed $10 for 8 frames), on the floor it blocks
;@ him like a wall. While the lever is held still (state 2) it does not move.
;@ test: skip draws sprites and moves Link
LeverGateShiftXHandler::
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, LeverGateUpdate

;>     wEntityX[slot] += 8
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
;>     wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;>     wEntityState[slot] += 1
;>     return
	jp IncrementEntityState


LeverGateUpdate:
;> DrawEntity16x16(LeverGateSprites)
	ld de, LeverGateSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()               # (leaves hl at wInventoryAppearing, which is 0)
	call ReturnIfNonInteractive_06
;> if hLeverPullState == 2:                  # lever held still: height checked as 0
	ldh a, [hLeverPullState]
	cp $02
;>     return LeverGatePushLink(slot)
	jr z, .push

;> if hLeverPullState:                       # being pulled: rise
	and a
	jr z, .sink

;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] == 10:
	ld a, [hl]
	cp $0a
	jr nz, .done

;>         wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>         hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;>         if wEntityZ[slot] < 0x20:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, .done

;>             wEntityZ[slot] += 1
	inc [hl]

.done
;>     return
	ret


.sink
;> if wEntityZ[slot] == 0:                   # down: a wall
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
;>     return LeverGateBlockLink(slot)
	jr z, .floor

;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .push

;>     wEntityZ[slot] -= 1
	dec [hl]

.push
;> if wEntityZ[slot] < 4 and EntityTouchesLink():   # low and touching Link: shove him away
	ld a, [hl]
	cp $04
	jr nc, .end

	call EntityTouchesLink
	jr nc, .ret

;>     wLinkPushedTimer = 8
	ld a, $08
	ld [wLinkPushedTimer], a
;>     GetVectorTowardsLink(0x10)                       # hMultiPurpose0/1 = y / x speed towards Link
	ld a, $10
	call GetVectorTowardsLink
;>     hLinkSpeedY = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;>     hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a

.end
;> return
	ret


.floor
;> if EntityTouchesLink():
	call EntityTouchesLink
	jr nc, .ret

;>     BlockLink_06()
	call BlockLink_06

.ret
	ret


;@ def LeverGateShiftYHandler(slot: bc)
;@ path: object/lever_gate
;@ Entity $8D: the same lever gate, moved 8 pixels down on its first frame (see
;@ LeverGateShiftXHandler).
;@ test: skip draws sprites and moves Link
LeverGateShiftYHandler::
;> if hActiveEntityState != 0:
	ldh a, [hActiveEntityState]
	and a
;>     return LeverGateUpdate(slot)
	jp nz, LeverGateUpdate

;> wEntityY[slot] += 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
;> wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ path: enemy/hardhat_beetle
;@ The Hardhat Beetle's frames for the two-sprite renderer: 2 frames of 4 bytes (tile $44 and
;@ its mirror, tile $46 and its mirror).
HardhatBeetleSprites::
	db $44, $00, $44, $20, $46, $00, $46, $20

;@ path: enemy/hardhat_beetle
;@ The Hardhat Beetle's frames on map $0A (tiles $64 and $66, each with its mirror).
HardhatBeetleSpritesAlt::
	db $64, $00, $64, $20, $66, $00, $66, $20

;@ def HardhatBeetleHandler(slot: bc)
;@ path: enemy/hardhat_beetle
;@ Entity $20: the Hardhat Beetle, which slides after Link with inertia: every 4 frames
;@ (staggered by slot) it picks a random speed 4-11 towards Link and moves its x and y speed one
;@ step closer to it; a speed into a wall is cut to 0. The sword only knocks it back.
;@ test: skip draws sprites and calls banked helpers
HardhatBeetleHandler::
;> sprites = HardhatBeetleSpritesAlt if hMapId == 0x0A else HardhatBeetleSprites
	ld de, HardhatBeetleSprites
	ldh a, [hMapId]
	cp $0a
	jr nz, .draw

	ld de, HardhatBeetleSpritesAlt

.draw
;> DrawEntity16x16(sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits()                              # contact damage and weapon hits
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntitySpriteVariant[slot] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> if (hFrameCounter ^ slot) & 3:
	ldh a, [hFrameCounter]
	xor c
	and $03
;>     return
	jr nz, jr_006_4fd0

;> GetVectorTowardsLink(((GetRandomByte() ^ slot) & 7) + 4)      # hMultiPurpose0/1 = y / x speed towards Link
	call GetRandomByte
	xor c
	and $07
	add $04
	call GetVectorTowardsLink
;> HardhatBeetleAccelerate(slot, wEntitySpeedY, hMultiPurpose0)
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	call HardhatBeetleAccelerate
;> if wEntityCollisions[slot] & 0x0C:        # wall above / below
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, .x

;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b

.x
;> HardhatBeetleAccelerate(slot, wEntitySpeedX, hMultiPurpose1)
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	call HardhatBeetleAccelerate
;> if wEntityCollisions[slot] & 0x03:        # wall to the right / left
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .done

;>     wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b

.done
	ret


;@ def HardhatBeetleAccelerate(slot: bc, speed: hl, target: a)
;@ path: enemy/hardhat_beetle
;@ Moves one speed of the beetle (the array `speed`) one step towards `target`.
;@ test: skip pointer argument
HardhatBeetleAccelerate::
;> if target != speed[slot]:
	add hl, bc
	sub [hl]
	jr z, jr_006_4fd0

;>@t1     speed[slot] += -1 if (target - speed[slot]) & 0x80 else 1
	bit 7, a
	jr z, .up

	dec [hl]
	jr jr_006_4fd0

.up
;=@t1
	inc [hl]

jr_006_4fd0:
	ret


;@ path: object/tile_glint
;@ The glint's frames for the two-sprite renderer, cycled every 4 frames: 0 nothing (blank tile
;@ $FF), 1 small glint (tile $3A and its mirror), 2 and 3 big glint (tile $3C and its mirror).
TileGlintSprites::
	db $ff, $00, $ff, $20, $3a, $00, $3a, $20, $3c, $00, $3c, $20, $3c, $00, $3c, $20
;@ path: object/tile_glint
;@ X positions (pixels) of the five squares of the glinting path, 4 paths of 5 (index
;@ hRandomPattern * 5 + step); TileGlintPathY has the y positions.
;@ Path 0: $58 $78 $78 $28 $28; 1: $28 $78 $58 $28 $78; 2: $28 $78 $28 $78 $58; 3: $58 $28 $78 $28 $78.
TileGlintPathX::
	db $58, $78, $78, $28, $28, $28, $78, $58, $28, $78, $28, $78, $28, $78, $58, $58
	db $28, $78, $28, $78

;@ path: object/tile_glint
;@ Y positions of the glinting path's squares, same index as TileGlintPathX.
;@ Path 0: $40 $30 $50 $50 $30; 1: $30 $50 $40 $50 $30; 2: $50 $50 $30 $30 $40; 3: $40 $50 $30 $30 $50.
TileGlintPathY::
	db $40, $30, $50, $50, $30, $30, $50, $40, $50, $30, $50, $50
	db $30, $30, $40, $40, $50, $30, $30, $50

;@ path: object/tile_glint
;@ The sparkle shown when Link steps on the right square: 4 frames of 4 sprites (y offset, x
;@ offset, tile $3A, attributes), the sparks flying apart from 16 to 6 pixels of the centre as
;@ the timer runs down (frame = (timer >> 2) & 3).
TileGlintSparkleOAM::
	db $f2, $00, $3a, $00, $f2, $08, $3a, $20
	db $0e, $00, $3a, $00, $0e, $08, $3a, $20, $f6, $0a, $3a, $00, $f6, $12, $3a, $20
	db $0a, $f6, $3a, $00, $0a, $fe, $3a, $20, $00, $0e, $3a, $00, $00, $16, $3a, $20
	db $00, $f2, $3a, $00, $00, $fa, $3a, $20, $0a, $0a, $3a, $00, $0a, $12, $3a, $20
	db $f6, $f6, $3a, $00, $f6, $fe, $3a, $20

;@ def TileGlintHandler(slot: bc)
;@ path: object/tile_glint
;@ Entities $8A (glinting) and $8B (invisible): a path of five floor squares (one of four layouts,
;@ hRandomPattern) that Link must step on in order. The entity sits on the next square of the
;@ path (step in wEntityPrivateCounter). Each time Link steps onto a square of object $8D: if it
;@ is the right one, a sparkle (entity $8A in state 1, 24 frames) and jingle $13 mark it and the
;@ next square is next; after the fifth the room's event triggers (TriggerRoomEvent). A wrong
;@ square starts the path again. State 1 is the sparkle itself.
;@ test: skip draws sprites and spawns entities
TileGlintHandler::
;> if hActiveEntityState != 0:              # a sparkle
	ldh a, [hActiveEntityState]
	and a
	jr z, .glint

;>     if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>         return ClearEntityStatus_06()
	jp z, ClearEntityStatus_06

;>@t2     DrawEntitySprites(TileGlintSparkleOAM + (wEntityTimer[slot] * 4 & 0x30), count=4)
	rla
	rla
	and $30
	ld e, a
	ld d, b
	ld hl, TileGlintSparkleOAM
;=@t2
	add hl, de
	ld c, $04
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;>     return
	ret


.glint
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if hActiveEntityType == 0x8A:            # the visible kind
	ldh a, [hActiveEntityType]
	cp $8a
	jr nz, .place

;>     wEntitySpriteVariant[slot] = (hFrameCounter >> 2) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	and $03
	call SetEntitySpriteVariant
;>     DrawEntity16x16(TileGlintSprites)
	ld de, TileGlintSprites
	call DrawEntity16x16

.place
;>@t3 i = hRandomPattern * 5 + wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ldh a, [hRandomPattern]
	ld e, a
	sla a
	sla a
;=@t3
	add e
	add [hl]
	ld e, a
	ld d, b
;> wEntityX[slot] = TileGlintPathX[i]
	ld hl, TileGlintPathX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = TileGlintPathY[i]
	ld hl, TileGlintPathY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> LoadEntityPosition()                              # copy the position to hActiveEntityX/Y
	call LoadEntityPosition
;>@t4 if hObjectUnderLink != wEntityPrivate1[slot] and hObjectUnderLink == 0x8D:   # stepped onto a path square
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hObjectUnderLink]
	cp [hl]
	jr z, .remember

;=@t4
	cp $8d
	jr nz, .remember

;>     if EntityTouchesLink():                      # the right one
	call EntityTouchesLink
	jr nc, .wrong

;>         if wEntityPrivateCounter[slot] == 4:      # the last square
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $04
	jr nz, .next

;>             ClearEntityStatus_06()
	call ClearEntityStatus_06
;>             TriggerRoomEvent()
	call TriggerRoomEvent
	jr .remember

.next
;>         else:
;>             wEntityPrivateCounter[slot] += 1
	inc [hl]
;>             hJingle = 0x13
	ld a, $13
	ldh [hJingle], a
;>             sparkle = SpawnEntity(0x8A)
	ld a, $8a
	call SpawnEntity
;>             if sparkle is not None:
	jr c, .spawned

;>                 wEntityX[sparkle] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>                 wEntityY[sparkle] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>                 wEntityState[sparkle] += 1     # a sparkle
	push bc
	push de
	pop bc
	call IncrementEntityState
;>                 wEntityTimer[sparkle] = 0x18
	call GetEntityTimer
	ld [hl], $18
	pop bc

.spawned
	jr .remember

.wrong
;>     else:
;>         wEntityPrivateCounter[slot] = 0      # start the path again
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b

.remember
;> wEntityPrivate1[slot] = hObjectUnderLink
	ldh a, [hObjectUnderLink]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ret


;@ path: boss/hinox
;@ Horizontal walking speed of the Hinox for the directions 0 right, 1 left, 2 up, 3 down
;@ (1/16 pixel per frame); HinoxSpeedY has the vertical speeds.
HinoxSpeedX::
	db $08, $f8, $00, $00

;@ path: boss/hinox
;@ Vertical walking speed of the Hinox for the directions 0 right, 1 left, 2 up, 3 down.
HinoxSpeedY::
	db $00, $00, $f8, $08

;@ def HinoxHandler(slot: bc)
;@ path: boss/hinox
;@ Entity $89: the Hinox, a big one-eyed miniboss that walks about, charges at Link, grabs him
;@ and throws him (8 eighths = 1 heart of damage), and throws a bomb when it is hit. While
;@ wEntityTimer1 runs (Link was just thrown) Link stays frozen in his thrown pose.
;@ test: skip draws sprites and calls banked helpers
HinoxHandler::
;> HinoxDraw(slot)
	call HinoxDraw
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return MinibossDefeated(slot)
	jp nz, MinibossDefeated

;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> Call_3F12()                              # miniboss music
	call Call_3F12
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> if wEntityTimer1[slot]:
	call GetEntityTimer1
	jr z, .hit

;>     HinoxFreezeLink()
	call HinoxFreezeLink

.hit
;>@t1 if hActiveEntityState < 4 and wEntityFlashTimer[slot] == 3:     # just hit: throw a bomb
	ldh a, [hActiveEntityState]
	cp $04
	jr nc, .dispatch

;=@t1
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, .dispatch

;>     wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     return
	ret


.dispatch
;> HinoxStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/hinox
;@ The Hinox's states: 0 walk, 1 pause, 2 wind up, 3 charge, 4 hold and throw Link, 5 throw a bomb.
HinoxStates::
	dw HinoxWalk
	dw HinoxPause
	dw HinoxWindUp
	dw HinoxCharge
	dw HinoxHoldLink
	dw HinoxThrowBomb

;@ def HinoxPause(slot: bc)
;@ path: boss/hinox
;@ State 1: stands until the timer runs out (a check of its facing at timer 10 has no effect).
;@ Then, every second pause, it may (half the time) wind up for a charge (state 2, 48 frames);
;@ otherwise it walks for 32-63 frames (state 0): every fourth walk towards Link, the others
;@ in a random direction.
;@ test: skip uses the random generator and banked helpers
HinoxPause::
;> EntityCheckHits()                              # contact damage and weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr z, jr_006_516a

;>     if wEntityTimer[slot] == 0x0A:
	cp $0a
	jr nz, jr_006_5166

;>         GetEntityDirectionToLink_06()     # (result unused)
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, jr_006_5166

jr_006_5166:
;>     EntityCheckWalls()
	call EntityCheckWalls
;>     return
	ret


jr_006_516a:
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;> if wEntityPrivate3[slot] == 2:          # every second pause
	ld a, [hl]
	cp $02
	jr nz, jr_006_5187

;>     wEntityPrivate3[slot] = 0
	ld [hl], b
;>     if GetRandomByte() & 1 == 0:
	call GetRandomByte
	and $01
	jr nz, jr_006_5187

;>         wEntityState[slot] = 2           # wind up
	call IncrementEntityState
	ld [hl], $02
;>         wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         return
	ret


jr_006_5187:
;> wEntityTimer[slot] = (GetRandomByte() & 0x1F) | 0x20
	call GetEntityTimer
	call GetRandomByte
	and $1f
	or $20
	ld [hl], a
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wEntityPrivate1[slot] = (wEntityPrivate1[slot] + 1) & 3
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
;> if wEntityPrivate1[slot] == 0:
	cp $00
	jr nz, jr_006_51a8

;>     direction = GetEntityDirectionToLink_06()
	call GetEntityDirectionToLink_06
	jr jr_006_51ab

jr_006_51a8:
;> else:
;>     direction = GetRandomByte()
	call GetRandomByte

jr_006_51ab:
;> direction &= 3
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = HinoxSpeedX[direction]
	ld hl, HinoxSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = HinoxSpeedY[direction]
	ld hl, HinoxSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def HinoxWalk(slot: bc)
;@ path: boss/hinox
;@ State 0: walks until the timer runs out or it bumps into a wall, then stops for 16-31 frames
;@ (state 1).
;@ test: skip uses the random generator and banked helpers
HinoxWalk::
;> EntityCheckHits()
	call EntityCheckHits
;>@t2 if wEntityCollisions[slot] & 0x0F or wEntityTimer[slot] == 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_006_51d5

;=@t2
	call GetEntityTimer
	jr nz, jr_006_51e3

jr_006_51d5:
;>     wEntityTimer[slot] = (GetRandomByte() & 0x0F) | 0x10
	call GetRandomByte
	and $0f
	or $10
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     ClearEntitySpeed()                          # stop
	call ClearEntitySpeed

jr_006_51e3:
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls

;@ def HinoxStepFrame(slot: bc)
;@ path: boss/hinox
;@ Advances the Hinox's step counter and shows walking frame 0 or 1 (every 16 counts).
;@ test: skip bank-0 helper
HinoxStepFrame::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@t3 wEntitySpriteVariant[slot] = (wEntityPrivateCounter[slot] >> 4) & 1
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $01
;=@t3
	call SetEntitySpriteVariant
	ret


;@ def HinoxWindUp(slot: bc)
;@ path: boss/hinox
;@ State 2: stamps on the spot (feet twice as fast, jingle $20 every 16 frames), then charges at
;@ Link at speed $18 for 32 frames (state 3). HinoxRunFeet is the stamping part, shared with
;@ state 3.
;@ test: skip moves through banked helpers
HinoxWindUp::
;> EntityCheckHits()
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, HinoxRunFeet

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpeedTowardsLink(0x18)                      # charge at Link
	ld a, $18
	call SetEntitySpeedTowardsLink

HinoxRunFeet:
;> HinoxStepFrame(slot)
	call HinoxStepFrame
;> HinoxStepFrame(slot)
	call HinoxStepFrame
;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .done

;>     hJingle = 0x20
	ld a, $20
	ldh [hJingle], a

.done
	ret


;@ def HinoxCharge(slot: bc)
;@ path: boss/hinox
;@ State 3: charges for 32 frames (then walks again, state 0), raising dust (effect $0B under it
;@ every 8 frames). If Link is within 24 pixels and free to move, it grabs him: state 4 for 79
;@ frames, wave sound $16.
;@ test: skip moves through banked helpers
HinoxCharge::
;> EntityCheckHits()
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_006_5228

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

jr_006_5228:
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x18) < 0x30:
	add $18
	cp $30
	jr nc, jr_006_5253

;>     dy, side = GetEntityYDistanceToLink_06()
	call GetEntityYDistanceToLink_06
;>@t4     if u8(dy + 0x18) < 0x30 and wLinkMotionState == 0:
	add $18
	cp $30
	jr nc, jr_006_5253

;=@t4
	ld a, [wLinkMotionState]
	cp $00
	jr nz, jr_006_5253

;>         wEntityState[slot] += 1          # grab Link
	call IncrementEntityState
;>         wEntityTimer[slot] = 0x4F
	call GetEntityTimer
	ld [hl], $4f
;>         hWaveSfx = 0x16
	ld a, $16
	ldh [hWaveSfx], a

jr_006_5253:
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_006_5268

;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityDrawY + 10
	ldh a, [hActiveEntityDrawY]
	add $0a
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(0x0B)                 # dust
	ld a, $0b
	call AddTransientVfx

jr_006_5268:
;> HinoxRunFeet(slot)
	jr HinoxRunFeet

;@ path: boss/hinox
;@ The Hinox's walking frame (0 or 1) while it holds Link, index (timer >> 3) for timer $4F-$00.
HinoxHoldFrames::
	db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00

;@ path: boss/hinox
;@ X offset of Link from the Hinox while he is lifted, index ((timer - $20) >> 2), 11 at the grab
;@ down to 0: from 0 (in front of it) to -17.
HinoxHoldLinkX::
	db $ef, $ef, $ef, $ef, $ef, $ef
	db $ef, $ef, $f3, $f7, $fb, $00

;@ path: boss/hinox
;@ Link's height while he is lifted, same index as HinoxHoldLinkX: from 0 up to 21 pixels.
HinoxHoldLinkZ::
	db $15, $15, $15, $15, $15, $14, $14, $14, $10, $08
	db $04, $00

;@ def HinoxHoldLink(slot: bc)
;@ path: boss/hinox
;@ State 4: lifts Link over its head (HinoxHoldLinkX/Z, Link frozen) and at timer $20 throws him
;@ towards the middle of the room (x speed $20 or -$20, y speed $20, height speed $10): one
;@ heart of damage, Link frozen in flight for 80 frames (wEntityTimer1). Walks again when the
;@ timer runs out.
;@ test: skip moves Link
HinoxHoldLink::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_006_5296

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


jr_006_5296:
;> if wEntityTimer[slot] == 0x20:           # throw
	cp $20
	jr nz, jr_006_52ca

;>     hLinkSpeedY = 0x20
	ld a, $20
	ldh [hLinkSpeedY], a
;>@t5     hLinkSpeedX = 0xE0 if hLinkX >= 0x50 else 0x20
	ldh a, [hLinkX]
	cp $50
	ld a, $e0
	jr nc, jr_006_52a8

	ld a, $20

jr_006_52a8:
;=@t5
	ldh [hLinkSpeedX], a
;>     hLinkSpeedZ = 0x10
	ld a, $10
	ldh [hLinkSpeedZ], a
;>     wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;>     wSubtractHealthBuffer = 8             # one heart
	ld a, $08
	ld [wSubtractHealthBuffer], a
;>     hLinkX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;>     hLinkY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hLinkY], a
;>     wEntityTimer1[slot] = 0x50
	call GetEntityTimer1
	ld [hl], $50
;>     return
	ret


jr_006_52ca:
;>@t6 wEntitySpriteVariant[slot] = HinoxHoldFrames[(wEntityTimer[slot] >> 3) & 0x0F]
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;=@t6
	ld hl, HinoxHoldFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] < 0x20:
	call GetEntityTimer
	cp $20
;>     return
	jr c, jr_006_530c

;> i = ((wEntityTimer[slot] - 0x20) >> 2) & 0x0F
	sub $20
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;> hLinkX = hActiveEntityX + HinoxHoldLinkX[i]
	ld hl, HinoxHoldLinkX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hLinkX], a
;> hLinkPositionZ = HinoxHoldLinkZ[i]
	ld hl, HinoxHoldLinkZ
	add hl, de
	ld a, [hl]
	ldh [hLinkPositionZ], a
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> hLinkY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hLinkY], a

;@ def HinoxFreezeLink()
;@ path: boss/hinox
;@ Holds Link still in his "being thrown" pose ($6A) for this frame.
;@ test: skip writes HRAM pose only
HinoxFreezeLink::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> hLinkAnimationState = 0x6A
	ld a, $6a
	ldh [hLinkAnimationState], a
;> wLinkFrozen = 0x6A
	ld [wLinkFrozen], a

jr_006_530c:
	ret


;@ def HinoxThrowBomb(slot: bc)
;@ path: boss/hinox
;@ State 5, after a hit: raises a bomb (frame 1) and at timer $10 throws it at Link
;@ (ThrowBombTowardsLink), starting 12 pixels to its left at height 16; walks again when the
;@ timer runs out.
;@ test: skip spawns an entity
HinoxThrowBomb::
;> EntityCheckHits()
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_006_531a

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


jr_006_531a:
;> frame = 1 if wEntityTimer[slot] >= 0x10 else 0
	ld e, $00
	cp $10
	jr c, jr_006_5321

	inc e

jr_006_5321:
;> if wEntityTimer[slot] == 0x10:
	cp $10
	jr nz, jr_006_5347

;>     bomb = SpawnEntity(0x02)
	ld a, $02
	call SpawnEntity
;>     if bomb is not None:
	jr c, jr_006_5347

;>         wEntityX[bomb] = hMultiPurpose0 - 12
	ldh a, [hMultiPurpose0]
	sub $0c
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[bomb] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	sub $00
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityZ[bomb] = 0x10
	ld hl, wEntityZ
	add hl, de
	ld [hl], $10
;>         return ThrowBombTowardsLink(bomb)
	jp ThrowBombTowardsLink


jr_006_5347:
;> wEntitySpriteVariant[slot] = frame
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ path: boss/hinox
;@ The Hinox's 2 frames, 32 bytes each: 8 sprites of 4 bytes (y offset, x offset, tile,
;@ attributes): a 32x32 body of two rows (y -12 and +4) of four 8x16 sprites (x -8..16), tiles
;@ $60-$6E; frame 1 is frame 0 mirrored (the walking step).
HinoxOAM::
	db $f4, $f8, $60, $00, $f4, $00, $62, $00, $f4, $08, $64, $00, $f4, $10, $66, $00
	db $04, $f8, $68, $00, $04, $00, $6a, $00, $04, $08, $6c, $00, $04, $10, $6e, $00
	db $f4, $f8, $66, $20, $f4, $00, $64, $20, $f4, $08, $62, $20, $f4, $10, $60, $20
	db $04, $f8, $6e, $20, $04, $00, $6c, $20, $04, $08, $6a, $20, $04, $10, $68, $20

;@ def HinoxDraw(slot: bc)
;@ path: boss/hinox
;@ Draws the Hinox's current frame from HinoxOAM (8 sprites).
;@ test: skip draws sprites
HinoxDraw::
;>@t7 DrawEntitySprites(HinoxOAM + hActiveEntitySpriteVariant * 32, count=8)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
;=@t7
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, HinoxOAM
	add hl, de
;=@t7
	ld c, $08
	call DrawEntitySprites
	ret


;@ def ArmosKnightHandler(slot: bc)
;@ path: boss/armos_knight
;@ Entity $88: the Armos Knight, a giant statue miniboss that wakes when Link comes near, hops
;@ after him and leaps up to slam down (shaking the screen and stunning Link if he is on the
;@ ground). It leaves the key drop (entity $30) and is never marked as defeated in the room's
;@ list. Below 8 health it shows its damaged frames (2, below 4: 3). Once it is not active any
;@ more (status 5), MinibossDefeated runs - the death sequence shared by the minibosses of this
;@ bank, stepped by wEntityPrivate2: flash for 160 frames, then explode for 192 frames, then the
;@ area music returns, the entity is removed for good (Call_3F7A) and, except for the Armos
;@ Knight (and for the Hinox, Cue Ball and Smasher from map 6 on), the room's beaten flag is set
;@ (MarkMinibossBeaten).
;@ test: skip draws sprites and calls banked helpers
ArmosKnightHandler::
;> wEntityLoadOrder[slot] = 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;> wEntityDropType[slot] = 0x30             # the key drop
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $30
;> if wEntityHealth[slot] < 8:              # damaged
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $08
	jr nc, .draw

;>@t1     wEntitySpriteVariant[slot] = 2 if wEntityHealth[slot] >= 4 else 3
	ld e, $02
	cp $04
	jr nc, .set

	ld e, $03

.set
;=@t1
	ld a, e
	call SetEntitySpriteVariant

.draw
;> ArmosKnightDraw(slot)
	call ArmosKnightDraw
;> if hActiveEntityStatus == 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return ArmosKnightActive(slot)
	jr z, ArmosKnightActive

MinibossDefeated:
;> MinibossDefeatedSteps[wEntityPrivate2[slot]](slot)      # MinibossDefeated: the death sequence
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss
;@ The steps of the minibosses' death sequence (wEntityPrivate2): 0 start flashing, 1 flash,
;@ 2 explode and finish, 3 done.
MinibossDefeatedSteps::
	dw MinibossDefeatedStart
	dw MinibossDefeatedFlash
	dw MinibossDefeatedExplode
	dw MinibossDefeatedDone

;@ def MinibossDefeatedStart(slot: bc)
;@ path: boss
;@ Step 0 of the death sequence: flashes for 160 frames.
;@ test: skip bank-0 helper
MinibossDefeatedStart::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> IncrementEntityPrivate2_06()
	call IncrementEntityPrivate2_06
	ret


;@ def MinibossDefeatedFlash(slot: bc)
;@ path: boss
;@ Step 1: when the flashing is over, keeps flashing while it explodes for 192 frames (step 2).
;@ test: skip bank-0 helper
MinibossDefeatedFlash::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_006_53f8

;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     IncrementEntityPrivate2_06()
	call IncrementEntityPrivate2_06

jr_006_53f8:
	ret


;@ def MinibossDefeatedExplode(slot: bc)
;@ path: boss
;@ Step 2: explosions (MinibossExplosions) until the timer runs out; then noise $1A, the area
;@ music again, the entity is removed and recorded as defeated (Call_3F7A), and the room's
;@ beaten flag is set - not for the Armos Knight, and for the Hinox, Cue Ball and Smasher only
;@ on maps below 6.
;@ test: skip banked helpers
MinibossDefeatedExplode::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr nz, jr_006_5423
;>@ex     return MinibossExplosions(wEntityTimer[slot])

;> hNoiseSfx = 0x1A
	ld a, $1a
	ldh [hNoiseSfx], a
;> SelectAreaMusicFar()
	call SelectAreaMusicFar
;> Call_3F7A()                              # remove it for good
	call Call_3F7A
;> if hActiveEntityType == 0x88:            # the Armos Knight
	ldh a, [hActiveEntityType]
	cp $88
;>     return
	ret z

;>@t2 if hActiveEntityType in (0x89, 0x8E, 0x92) and hMapId >= 6:
	ldh a, [hActiveEntityType]
	cp $89
	jr z, jr_006_541b

;=@t2
	cp $8e
	jr z, jr_006_541b

	cp $92
	jr nz, jr_006_5420

jr_006_541b:
;=@t2
	ldh a, [hMapId]
	cp $06
;>     return
	ret nc

jr_006_5420:
;> MarkMinibossBeaten()
	jp MarkMinibossBeaten


jr_006_5423:
;=@ex
	call MinibossExplosions
	ret


;@ def MinibossDefeatedDone(slot: bc)
;@ path: boss
;@ Step 3: nothing left to do.
;@ test: skip does nothing
MinibossDefeatedDone::
;> return
	ret


;@ def ArmosKnightActive(slot: bc)
;@ path: boss/armos_knight
;@ The living Armos Knight: miniboss music, weapon hits, solid to Link, gravity 2 (scratch
;@ hBGTilesRequestCopy = landed). While wEntityTimer1 runs Link is stunned (frozen in pose $6A).
;@ When its health drops below 8, and again below 4, a piece breaks off (entity $05, placed at
;@ its drawn height, with a small puff (effect 2) and noise $29). Then its state.
;@ test: skip spawns entities and calls banked helpers
ArmosKnightActive::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> Call_3F12()                              # miniboss music
	call Call_3F12
;> EntityCheckWeaponHits()                              # weapon hits
	call EntityCheckWeaponHits
;> BlockLinkIfTouching_06()
	call BlockLinkIfTouching_06
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80      # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, .stun

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.stun
;> if wEntityTimer1[slot]:                  # Link is stunned
	call GetEntityTimer1
	jr z, .health

;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     hLinkAnimationState = 0x6A
	ld a, $6a
	ldh [hLinkAnimationState], a

.health
;> health = wEntityHealth[slot]
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
;> changed = health != wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	cp [hl]
;> wEntityPrivate1[slot] = health
	ld [hl], a
;> if not changed or health >= 8:
	jp z, .dispatch

	cp $08
;>     pass
	jr nc, .dispatch

;> elif health < 4:
	cp $04
	jr nc, .first

;>     if wEntityPrivateCounter[slot] < 2:     # second piece
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $02
	jr nc, .dispatch

;>         wEntityPrivateCounter[slot] += 1
	inc [hl]
;>         piece = SpawnEntity(0x05)           # hMultiPurpose0/1/3 = our x / y / height
	ld a, $05
	call SpawnEntity
;>         if piece is not None:
	jr c, .dispatch

;>             wEntityX[piece] = hMultiPurpose0 - 1
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	dec a
	ld [hl], a
;>             hMultiPurpose0 = wEntityX[piece]
	ldh [hMultiPurpose0], a
;>@y2             y = hMultiPurpose1 - hMultiPurpose3 - 0x10
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	sub [hl]
	ld hl, wEntityY
	add hl, de
	sub $10
;>@p2             ArmosKnightPiece(piece, y)
	jr .place

.first
;> else:
;>     if wEntityPrivateCounter[slot] < 1:     # first piece
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $01
	jr nc, .dispatch

;>         wEntityPrivateCounter[slot] += 1
	inc [hl]
;>         piece = SpawnEntity(0x05)
	ld a, $05
	call SpawnEntity
;>         if piece is not None:
	jr c, .dispatch

;>             wEntityX[piece] = hMultiPurpose0 + 7
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	add $07
	ld [hl], a
;>             hMultiPurpose0 = wEntityX[piece]
	ldh [hMultiPurpose0], a
;>             y = hMultiPurpose1 - hMultiPurpose3
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	sub [hl]
	ld hl, wEntityY
	add hl, de

.place
;>             # ArmosKnightPiece (shared by both pieces):
;>             wEntityY[piece] = y
	ld [hl], a
;>             hMultiPurpose1 = y
	ldh [hMultiPurpose1], a
;>             wEntityTimer1[piece] = 0x0F
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
;>             wEntityPhysicsFlags[piece] = 0xC4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4
;>             AddTransientVfx(2)            # a puff
	ld a, $02
	call AddTransientVfx
;>             hNoiseSfx = 0x29
	ld a, $29
	ldh [hNoiseSfx], a

.dispatch
;> ArmosKnightStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/armos_knight
;@ The Armos Knight's states: 0 dormant statue, 1 waking, 2 shaking, 3 hopping after Link,
;@ 4 big leap, 5 hanging in the air, 6 slamming down, 7 recovering.
ArmosKnightStates::
	dw ArmosKnightDormant
	dw ArmosKnightWake
	dw ArmosKnightShake
	dw ArmosKnightHop
	dw ArmosKnightLeap
	dw ArmosKnightHang
	dw ArmosKnightSlam
	dw ArmosKnightRecover

;@ def ArmosKnightDormant(slot: bc)
;@ path: boss/armos_knight
;@ State 0: a statue until Link comes within 32 pixels; then it wakes (state 1, 48 frames).
;@ test: skip bank-0 helpers
ArmosKnightDormant::
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x20) >= 0x40:
	add $20
	cp $40
;>     return
	jr nc, .done

;> dy, side = GetEntityYDistanceToLink_06()
	call GetEntityYDistanceToLink_06
;> if u8(dy + 0x20) >= 0x40:
	add $20
	cp $40
;>     return
	jr nc, .done

;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30

.done
	ret


;@ def ArmosKnightWake(slot: bc)
;@ path: boss/armos_knight
;@ State 1: flickers between frames 0 and 1 (every 4 frames) while it wakes, then shakes for
;@ 128 frames (state 2).
;@ test: skip bank-0 helpers
ArmosKnightWake::
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame

;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     wEntityState[slot] += 1
	call IncrementEntityState

.frame
;> wEntitySpriteVariant[slot] = (wEntityTimer[slot] >> 2) & 1
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


;@ def ArmosKnightShake(slot: bc)
;@ path: boss/armos_knight
;@ State 2: shakes from side to side (x speed +8 / -8, switching every 4 frames). When the timer
;@ runs out it becomes vulnerable and solid (physics bit 7, hitbox bit 7 and option bit 6
;@ cleared) and hops after Link for 80 frames (state 3).
;@ test: skip bank-0 helpers
ArmosKnightShake::
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .shake

;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityPhysicsFlags[slot] &= ~0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
;>     wEntityHitboxFlags[slot] &= ~0x80
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
;>     wEntityOptions1[slot] &= ~0x40
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
;>     return
	ret


.shake
;>@t3 wEntitySpeedX[slot] = 0xF8 if wEntityTimer[slot] & 4 else 0x08
	ld e, $08
	and $04
	jr z, .set

	ld e, $f8

.set
;=@t3
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> AddEntitySpeedToPos_06(slot)              # x only
	call AddEntitySpeedToPos_06
	ret


;@ def ArmosKnightHop(slot: bc)
;@ path: boss/armos_knight
;@ State 3: hops after Link - a small hop (height speed $0C, jingle $20) on each landing, aimed
;@ at Link at speed 8, or $0C below 5 health. When the timer runs out it makes a big leap
;@ (height speed $30, jingle $24, state 4).
;@ test: skip moves through banked helpers
ArmosKnightHop::
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .hop

;>     wEntitySpeedZ[slot] = 0x30
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $30
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
;>     return
	ret


.hop
;> if hBGTilesRequestCopy:                  # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .move

;>     wEntitySpeedZ[slot] = 0x0C
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c
;>@t4     SetEntitySpeedTowardsLink(8 if wEntityHealth[slot] >= 5 else 0x0C)
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $05
;=@t4
	ld a, $08
	jr nc, .aim

	ld a, $0c

.aim
;=@t4
	call SetEntitySpeedTowardsLink
;>     hJingle = 0x20
	ld a, $20
	ldh [hJingle], a

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
	ret


;@ def ArmosKnightLeap(slot: bc)
;@ path: boss/armos_knight
;@ State 4: flies on until the top of the leap (height speed 0 or 1), then stops there for 16
;@ frames (state 5).
;@ test: skip bank-0 helpers
ArmosKnightLeap::
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> if wEntitySpeedZ[slot] & 0xFE == 0:       # top of the leap
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and $fe
	jr nz, .move

;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     ClearEntitySpeed()                          # stop
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
	ret


;@ def ArmosKnightHang(slot: bc)
;@ path: boss/armos_knight
;@ State 5: hangs in the air (height speed 0) until the timer runs out, then falls at -$50
;@ (state 6).
;@ test: skip bank-0 helpers
ArmosKnightHang::
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     wEntitySpeedZ[slot] = 0
	ld a, $00
	jr nz, .set

;> else:
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>@s     wEntitySpeedZ[slot] = 0xB0
	ld a, $b0

.set
;=@s
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	ret


;@ def ArmosKnightSlam(slot: bc)
;@ path: boss/armos_knight
;@ State 6: when it hits the ground the screen shakes for 48 frames (wBumpShakeTimer, axis 4),
;@ jingle $0B, and Link is stunned for 64 frames unless he is in the air; then state 7
;@ (48 frames).
;@ test: skip bank-0 helpers
ArmosKnightSlam::
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> if not hBGTilesRequestCopy:              # still falling
	ldh a, [hBGTilesRequestCopy]
	and a
;>     return
	jr z, .done

;> wBumpShakeTimer = 0x30
	ld a, $30
	ld [wBumpShakeTimer], a
;> wBumpShakeAxis = 4
	ld a, $04
	ld [wBumpShakeAxis], a
;> hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> if not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .next

;>     wEntityTimer1[slot] = 0x40           # Link stunned
	call GetEntityTimer1
	ld [hl], $40

.next
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def ArmosKnightRecover(slot: bc)
;@ path: boss/armos_knight
;@ State 7: stands until the timer runs out, then shakes again (state 2).
;@ test: skip bank-0 helpers
ArmosKnightRecover::
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02

.done
	ret


;@ path: boss/armos_knight
;@ The Armos Knight's 4 frames, 32 bytes each: 8 sprites of 4 bytes (y offset, x offset, tile,
;@ attributes; $20 mirrored), two rows (y -12 and +4) of four 8x16 sprites (x -8..16). Frames 0
;@ and 1 are the intact statue (tiles $70-$7A; frame 1 with tile $78 in the top middle), 2 and
;@ 3 the damaged knight (lower half $74/$76 mirrored; frame 3 with top tiles $7C/$7E).
ArmosKnightOAM::
	db $f4, $f8, $70, $00, $f4, $00, $72, $00, $f4, $08, $72, $20, $f4, $10, $70, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $7a, $00, $04, $10, $7a, $20
	db $f4, $f8, $70, $00, $f4, $00, $78, $00, $f4, $08, $78, $20, $f4, $10, $70, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $7a, $00, $04, $10, $7a, $20
	db $f4, $f8, $70, $00, $f4, $00, $72, $00, $f4, $08, $72, $20, $f4, $10, $70, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $76, $20, $04, $10, $74, $20
	db $f4, $f8, $7c, $00, $f4, $00, $7e, $00, $f4, $08, $7e, $20, $f4, $10, $7c, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $76, $20, $04, $10, $74, $20
;@ path: boss/armos_knight
;@ The Armos Knight's shadow while it is in the air: 4 sprites (y offset, x offset, tile $26,
;@ attributes) in a row 12 pixels below its ground position.
ArmosKnightShadowOAM::
	db $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00, $0c, $0d, $26, $00

;@ def ArmosKnightDraw(slot: bc)
;@ path: boss/armos_knight
;@ Draws the Armos Knight's frame (8 sprites from ArmosKnightOAM) and, while it is off the
;@ ground, its shadow on the ground; then copies its position to hActiveEntityX/Y again.
;@ test: skip draws sprites
ArmosKnightDraw::
;>@t5 DrawEntitySprites(ArmosKnightOAM + hActiveEntitySpriteVariant * 32, count=8)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
;=@t5
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, ArmosKnightOAM
	add hl, de
;=@t5
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)                             # claim 4 more OAM entries
	ld a, $04
	call ReserveOAMEntriesFar
;> if wEntityZ[slot] != 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;>     hActiveEntityDrawY = hActiveEntityY  # the shadow is on the ground
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;>     DrawEntitySprites(ArmosKnightShadowOAM, count=4)
	ld hl, ArmosKnightShadowOAM
	ld c, $04
	call DrawEntitySprites

.done
;> LoadEntityPosition()
	jp LoadEntityPosition


;@ path: boss/desert_lanmola
;@ X offset from the hole of the two sand rocks the Desert Lanmola throws up, read with the
;@ rock number 1-2 as index: rock 1 +4, rock 2 -4 (the $FC is the first byte of
;@ LanmolaRockSpeedX). Byte 0 is not used.
LanmolaRockX::
	db $00, $04

;@ path: boss/desert_lanmola
;@ Horizontal speed of the two sand rocks, index rock 1-2: +8 and -8 (the first byte doubles as
;@ rock 2's x offset in LanmolaRockX).
LanmolaRockSpeedX::
	db $fc, $08, $f8

;@ def LanmolaHandler(slot: bc)
;@ path: boss/desert_lanmola
;@ Entity $87: the Desert Lanmola, a sand worm of a head and 6 body segments that bursts out of
;@ the sand, flies an arc and dives back in. The segments follow the head's path: every frame
;@ its position and height go into a 256-entry trail (wEntityWorkRAM / wEntityWorkRAM2 /
;@ wEntityWorkRAM3, index wEntityPrivateCounter), and segment i is drawn where the head was
;@ LanmolaSegmentLag[i] frames ago (a height with bit 7 set = under the sand, not drawn).
;@ Entity $87 with wEntityPrivate3 = 2 is a sand rock (LanmolaRockHandler). On the first frame:
;@ boss music, height $FF, 80 frames underground and the whole height trail set to "under".
;@ When defeated (status 1) it flashes, then its segments burst one by one from the tail (a puff
;@ every 32 frames) and it leaves entity $30 (the key drop) behind.
;@ test: skip draws sprites and calls banked helpers
LanmolaHandler::
;> if wEntityPrivate3[slot] == 2:           # a sand rock
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	cp $02
;>     return LanmolaRockHandler(slot)
	jp z, LanmolaRockHandler

;> if wEntityPrivate3[slot] == 0:           # first frame
	cp $00
	jr nz, .run

;>     wEntityPrivate3[slot] = 1
	inc [hl]
;>     hDefaultMusicTrack = 0x50            # boss music
	ld a, $50
	ldh [hDefaultMusicTrack], a
;>     wEntityZ[slot] = 0xFF                # under the sand
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $ff
;>     wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;>@t3     fill(wEntityWorkRAM3, 0xFF, 256)     # the whole trail is under the sand
	ld e, $00
	ld a, $ff
	ld hl, wEntityWorkRAM3

.fill
;=@t3
	ld [hli], a
	dec e
	jr nz, .fill

.run
;> LanmolaDraw(slot)
	call LanmolaDraw
;> if hActiveEntityStatus != 1:             # not dying
	ldh a, [hActiveEntityStatus]
	cp $01
;>     return LanmolaActive(slot)
	jp nz, LanmolaActive

;> LanmolaDefeatSteps[wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/desert_lanmola
;@ Steps of the Desert Lanmola's defeat (wEntityPrivate2): 0 start flashing, 1 flash, 2 burst
;@ the segments, 3 done.
LanmolaDefeatSteps::
	dw LanmolaDefeatStart
	dw LanmolaDefeatWait
	dw LanmolaDefeatBurst
	dw LanmolaDefeatDone

;@ def LanmolaDefeatStart(slot: bc)
;@ path: boss/desert_lanmola
;@ Defeat step 0: flashes for 96 frames (runs into IncrementEntityPrivate2_06).
;@ test: skip bank-0 helper
LanmolaDefeatStart::
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60

;@ def IncrementEntityPrivate2_06(slot: bc)
;@ path: entity/helpers
;@ Advances the entity's wEntityPrivate2 by one (the step counter of the death sequences).
;@ test: slot = rng.randrange(16)
IncrementEntityPrivate2_06::
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


;@ def LanmolaDefeatWait(slot: bc)
;@ path: boss/desert_lanmola
;@ Defeat step 1: when the flashing is over, sets 207 frames for the segments to burst, 5 of
;@ them to go (wEntityPrivate4), step 2.
;@ test: skip bank-0 helper
LanmolaDefeatWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0xCF
	ld [hl], $cf
;>     IncrementEntityPrivate2_06()
	call IncrementEntityPrivate2_06
;>     wEntityPrivate4[slot] = 5
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], $05

.done
	ret


;@ def LanmolaDefeatBurst(slot: bc)
;@ path: boss/desert_lanmola
;@ Defeat step 2: every 32 frames the next segment from the tail (wEntityPrivate4 counts down)
;@ that is above the sand bursts: its trail height becomes $FF and a puff (effect 2, noise $13)
;@ appears there. When the timer runs out the head goes too: the area music returns, the key
;@ drop (entity $30, frame 2) pops up from the head (height speed $10) and the Lanmola is gone.
;@ test: skip spawns an entity
LanmolaDefeatBurst::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .segments

;>     SelectAreaMusicFar()
	call SelectAreaMusicFar
;>     key = SpawnEntity(0x30)
	ld a, $30
	call SpawnEntity
;>     wEntityX[key] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[key] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[key] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[key] = 2
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $02
;>     wEntitySpeedZ[key] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityTimer1[key] = 0x10
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $10
;>     ClearEntityStatus_06()
	call ClearEntityStatus_06
;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>@p1     y = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
;>@p2     return LanmolaPuff(y)
	jr .puff

.segments
;> if wEntityTimer[slot] & 0x1F:
	and $1f
;>     return
	jr nz, .done

;>@t1 t = wEntityPrivateCounter[slot] - LanmolaSegmentLag[wEntityPrivate4[slot]]     # where that segment is
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate4
	add hl, bc
	ld e, [hl]
;>@t2 wEntityPrivate4[slot] -= 1
	dec [hl]
;=@t1
	ld d, b
	ld hl, LanmolaSegmentLag
	add hl, de
	sub [hl]
	ld e, a
	ld d, b
;> hMultiPurpose0 = wEntityWorkRAM[t]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> if wEntityWorkRAM3[t] & 0x80:            # already under the sand
	ld hl, wEntityWorkRAM3
	add hl, de
	ld a, [hl]
	and $80
;>     return
	jr nz, .done

;> y = wEntityWorkRAM2[t] - wEntityWorkRAM3[t]
	push hl
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	pop hl
	sub [hl]
;> wEntityWorkRAM3[t] = 0xFF                # the segment is gone
	ld [hl], $ff

.puff
;> # LanmolaPuff:
;> hMultiPurpose1 = y
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a

.done
	ret


;@ def LanmolaDefeatDone(slot: bc)
;@ path: boss/desert_lanmola
;@ Defeat step 3: nothing left to do.
;@ test: skip does nothing
LanmolaDefeatDone::
;> return
	ret


;@ def LanmolaActive(slot: bc)
;@ path: boss/desert_lanmola
;@ The living Desert Lanmola: boss music; while wEntityTimer1 runs (just after it came out or
;@ when it dives) two sand rocks spurt from the hole every 16 frames (entity $87, wEntityPrivate3
;@ = 2, flying up and sideways, LanmolaRockX / LanmolaRockSpeedX). Its head frame follows its
;@ speed; out of the sand (state 2 on) it records its trail. Then its state.
;@ test: skip spawns entities and calls banked helpers
LanmolaActive::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> Call_3F12()                              # boss music
	call Call_3F12
;> if wEntityTimer1[slot] and wEntityTimer1[slot] & 0x0F == 0:
	call GetEntityTimer1
	jr z, .frame

	and $0f
	jr nz, .frame

;>     rock = 2
	ld a, $02

.rock
;>     while True:
;>         hBGTilesRequestCopy = rock       # scratch
	ldh [hBGTilesRequestCopy], a
;>         new = SpawnEntity(0x87)
	ld a, $87
	call SpawnEntity
;>         if new is None:
;>             break
	jr c, .frame

;>@t4         wEntitySpriteVariant[new] = rock & 2
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, wEntitySpriteVariant
	add hl, de
	and $02
;=@t4
	ld [hl], a
;>@t5         wEntityX[new] = wLanmolaHoleX + LanmolaRockX[rock]
	ld a, [wLanmolaHoleX]
	ld hl, LanmolaRockX
	add hl, bc
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@t5
	ld [hl], a
;>         wEntitySpeedX[new] = LanmolaRockSpeedX[rock]
	ld hl, LanmolaRockSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = wLanmolaHoleY
	ld a, [wLanmolaHoleY]
	add $00
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntitySpeedY[new] = 0xF0        # flies up
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $f0
;>         wEntityPrivate3[new] = 2         # a rock
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $02
;>         wEntityPhysicsFlags[new] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c1
	pop bc
;>         rock -= 1
	ldh a, [hBGTilesRequestCopy]
	dec a
;>         if rock == 0:
;>             break
	jr nz, .rock

.frame
;> LanmolaHeadFrame(slot)
	call LanmolaHeadFrame
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> if hActiveEntityState >= 2:              # out of the sand: record the trail
	ldh a, [hActiveEntityState]
	cp $02
	jr c, .dispatch

;>     t = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>     wEntityPrivateCounter[slot] = (t + 1) & 0xFF
	inc [hl]
	and $ff
	ld e, a
	ld d, b
;>     wEntityWorkRAM[t] = hActiveEntityX
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hActiveEntityX]
	ld [hl], a
;>     wEntityWorkRAM2[t] = hActiveEntityY
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hActiveEntityY]
	ld [hl], a
;>     wEntityWorkRAM3[t] = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ld hl, wEntityWorkRAM3
	add hl, de
	ld [hl], a

.dispatch
;> LanmolaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/desert_lanmola
;@ The Desert Lanmola's states: 0 under the sand, 1 the sand stirs, 2 rising out, 3 flying,
;@ 4 diving back in. The sixth entry points at LanmolaSprites (data) and is never used.
LanmolaStates::
	dw LanmolaUnderground
	dw LanmolaEmerge
	dw LanmolaRise
	dw LanmolaFly
	dw LanmolaDive
	dw LanmolaSprites

;@ path: boss/desert_lanmola
;@ X positions (pixels) where the Desert Lanmola may come out of the sand, one picked at random
;@ (with a random LanmolaHoleY).
LanmolaHoleX::
	db $28, $38, $48, $58, $68, $78, $88, $28

;@ path: boss/desert_lanmola
;@ Y positions where the Desert Lanmola may come out of the sand.
LanmolaHoleY::
	db $30, $40, $50, $60, $70, $30, $40, $50

;@ def LanmolaUnderground(slot: bc)
;@ path: boss/desert_lanmola
;@ State 0: waits under the sand; then moves to a random spot (LanmolaHoleX / LanmolaHoleY),
;@ height 0, and the sand starts to stir there (state 1, 24 frames).
;@ test: skip uses the random generator
LanmolaUnderground::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x18
	call GetEntityTimer
	ld [hl], $18
;>@t6     wEntityX[slot] = LanmolaHoleX[GetRandomByte() & 7]
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, LanmolaHoleX
;=@t6
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>@t7     wEntityY[slot] = LanmolaHoleY[GetRandomByte() & 7]
	call GetRandomByte
	and $07
	ld e, a
	ld hl, LanmolaHoleY
	add hl, de
	ld a, [hl]
;=@t7
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>     wEntityZ[slot] = 0
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b
;>     LoadEntityPosition()
	call LoadEntityPosition
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def LanmolaEmerge(slot: bc)
;@ path: boss/desert_lanmola
;@ State 1: the sand stirs (mound frames 5/6, every 16 frames). Then the Lanmola bursts out:
;@ aimed at the middle of the room ($58, $50) at speed 8, height speed 8, the hole remembered
;@ for the rocks, which spurt for 97 frames (wEntityTimer1); state 2 for 32 frames.
;@ test: skip moves through banked helpers
LanmolaEmerge::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     x = hLinkX                           # aim at the middle of the room
	ldh a, [hLinkX]
	push af
;>     y = hLinkY
	ldh a, [hLinkY]
	push af
;>     hLinkX = 0x58
	ld a, $58
	ldh [hLinkX], a
;>     hLinkY = 0x50
	ld a, $50
	ldh [hLinkY], a
;>     SetEntitySpeedTowardsLink(8)
	ld a, $08
	call SetEntitySpeedTowardsLink
;>     hLinkY = y
	pop af
	ldh [hLinkY], a
;>     hLinkX = x
	pop af
	ldh [hLinkX], a
;>     wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;>     wLanmolaHoleX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld [wLanmolaHoleX], a
;>     wLanmolaHoleY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld [wLanmolaHoleY], a
;>     wEntityTimer1[slot] = 0x61           # sand rocks
	call GetEntityTimer1
	ld [hl], $61
;>     wEntityState[slot] += 1
	call IncrementEntityState

.frame
;>@t8 wEntitySpriteVariant[slot] = (hFrameCounter >> 4) & 1 + 5     # stirring sand
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@t8
	add $05
	call SetEntitySpriteVariant
	ret


;@ def LanmolaRise(slot: bc)
;@ path: boss/desert_lanmola
;@ State 2: rises out of the sand; then flies for 32-63 frames (state 3), its bobbing counter at
;@ $20.
;@ test: skip uses the random generator and banked helpers
LanmolaRise::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .move

;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x20
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;>     wEntityPrivate1[slot] = 0x20
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> EntityCheckHits()                              # contact damage and weapon hits
	call EntityCheckHits
	ret


;@ def LanmolaFly(slot: bc)
;@ path: boss/desert_lanmola
;@ State 3: flies on, bobbing: every second frame its height speed changes by 1, rising for 32
;@ steps and sinking for 32 (bit 5 of wEntityPrivate1). Then it dives (state 4, 128 frames).
;@ test: skip bank-0 helpers
LanmolaFly::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .bob

;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     wEntityState[slot] += 1
	call IncrementEntityState

.bob
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld a, [hl]
;> if wEntityPrivate1[slot] & 1 == 0:
	bit 0, a
	jr nz, .move

;>@t9     wEntitySpeedZ[slot] += -1 if wEntityPrivate1[slot] & 0x20 else 1
	ld hl, wEntitySpeedZ
	add hl, bc
	and $20
	jr nz, .down

	inc [hl]
	inc [hl]

.down
;=@t9
	dec [hl]

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> EntityCheckHits()
	call EntityCheckHits
	ret


;@ def LanmolaDive(slot: bc)
;@ path: boss/desert_lanmola
;@ State 4: falls (height speed down to -13) and slows down (speeds 1 closer to 0 every 8
;@ frames) until it is under the sand. At timer $78 the dive point becomes the hole: sand rocks
;@ for 96 frames, noise $23. It can only be hit while above the sand. Frame 2. Then 96 frames
;@ underground (state 0).
;@ test: skip bank-0 helpers
LanmolaDive::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .diving

;>     wEntityTimer[slot] = 0x60
	ld [hl], $60
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


.diving
;> if wEntityTimer[slot] == 0x78:
	cp $78
	jr nz, .fall

;>     wLanmolaHoleX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld [wLanmolaHoleX], a
;>     wLanmolaHoleY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld [wLanmolaHoleY], a
;>     wEntityTimer1[slot] = 0x60
	call GetEntityTimer1
	ld [hl], $60
;>     hNoiseSfx = 0x23
	ld a, $23
	ldh [hNoiseSfx], a

.fall
;> if not (wEntitySpeedZ[slot] - 0xF4) & 0x80:     # not yet at -13
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sub $f4
	and $80
	jr nz, .slow

;>     wEntitySpeedZ[slot] -= 1
	dec [hl]

.slow
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .move

;>     if wEntitySpeedX[slot] != 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .slowY

;>@t10         wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1
	and $80
	jr z, .decX

	inc [hl]
	inc [hl]

.decX
;=@t10
	dec [hl]

.slowY
;>     if wEntitySpeedY[slot] != 0:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, .move

;>@t11         wEntitySpeedY[slot] += 1 if wEntitySpeedY[slot] & 0x80 else -1
	and $80
	jr z, .decY

	inc [hl]
	inc [hl]

.decY
;=@t11
	dec [hl]

.move
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> if not wEntityZ[slot] & 0x80:            # above the sand
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .frame

;>     EntityCheckHits()
	call EntityCheckHits

.frame
;> wEntitySpriteVariant[slot] = 2
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ path: boss/desert_lanmola
;@ The Desert Lanmola's frames for the two-sprite renderer: 9 frames of 4 bytes (left tile,
;@ attributes, right tile, attributes; $20 mirrored, $40 flipped, $60 both). Head: 0 facing
;@ left (tiles $72/$74), 1 facing right (mirrored), 2 facing down (tile $70 twice), 3 facing up
;@ (flipped). 4 a body segment (tile $76), 5 and 6 the stirring sand (tile $7A), 7 and 8 the tail
;@ (tile $78).
LanmolaSprites::
	db $72, $00, $74, $00, $74, $20, $72, $20, $70, $00, $70, $20, $70, $40, $70, $60
	db $76, $00, $76, $20, $7a, $00, $7a, $60, $7a, $40, $7a, $20, $78, $00, $78, $60
	db $78, $40, $78, $20

;@ path: boss/desert_lanmola
;@ How many frames each of the 6 body segments trails behind the head (12, 24, ... 72): segment i
;@ is drawn at trail entry wEntityPrivateCounter - LanmolaSegmentLag[i]; segment 5 is the tail.
LanmolaSegmentLag::
	db $0c, $18, $24, $30, $3c, $48

;@ def LanmolaDraw(slot: bc)
;@ path: boss/desert_lanmola
;@ Draws the Desert Lanmola: the head (if above the sand) and the 6 trailing segments, each from
;@ its place in the trail (body frame 4, the tail frames 7/8 every 8 frames), skipping those
;@ under the sand. The segments are drawn front to back on odd frames and back to front on even
;@ ones, so they flicker evenly when sprites run short. Then puts the head's position back.
;@ hBGTilesRequestCopy and hMultiPurposeH are the loop counter and its end (scratch).
;@ test: skip draws sprites
LanmolaDraw::
;> if not wEntityZ[slot] & 0x80:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .segments

;>     DrawEntity16x16(LanmolaSprites)           # the head
	ld de, LanmolaSprites
	call DrawEntity16x16

.segments
;> hMultiPurpose0 = wEntityPrivateCounter[slot]      # newest trail entry
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> if hFrameCounter & 1:
	ldh a, [hFrameCounter]
	and $01
	jr z, .backwards

;>     hMultiPurposeH = 6                   # segments 0 .. 5
	ld a, $06
	ldh [hMultiPurposeH], a
;>     i = 0
	ld a, $00
	jr .loop

.backwards
;> else:
;>     hMultiPurposeH = 0xFF                # segments 5 .. 0
	ld a, $ff
	ldh [hMultiPurposeH], a
;>     i = 5
	ld a, $05

.loop
;> while True:
;>     hBGTilesRequestCopy = i
	ldh [hBGTilesRequestCopy], a
;>@t12     t = (hMultiPurpose0 - LanmolaSegmentLag[i]) & 0xFF
	ld e, a
	ld d, b
	ld hl, LanmolaSegmentLag
	add hl, de
	ldh a, [hMultiPurpose0]
	sub [hl]
;=@t12
	and $ff
	ld e, a
	ld d, $00
;>     hActiveEntityX = wEntityWorkRAM[t]
	ld hl, wEntityWorkRAM
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>     hActiveEntityY = wEntityWorkRAM2[t]
	ld hl, wEntityWorkRAM2
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityY], a
;>     hActiveEntityDrawY = hActiveEntityY - wEntityWorkRAM3[t]
	ld hl, wEntityWorkRAM3
	add hl, de
	sub [hl]
	ldh [hActiveEntityDrawY], a
;>     if not wEntityWorkRAM3[t] & 0x80:    # above the sand
	ld a, [hl]
	and $80
	jr nz, .next

;>         if i == 5:
	ldh a, [hBGTilesRequestCopy]
	cp $05
;>             hActiveEntitySpriteVariant = 4
	ld a, $04
	jr nz, .draw

;>         else:
;>@t13             hActiveEntitySpriteVariant = (hFrameCounter >> 3) & 1 + 7     # the tail
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $07

.draw
;=@t13
	ldh [hActiveEntitySpriteVariant], a
;>         DrawEntity16x16(LanmolaSprites)
	ld de, LanmolaSprites
	call DrawEntity16x16

.next
;>     i += -1 if hFrameCounter & 1 == 0 else 1
	ld e, $ff
	ldh a, [hFrameCounter]
	and $01
	jr z, .step

	ld e, $01

.step
;>     if i == hMultiPurposeH:
;>         break
	ld hl, hMultiPurposeH
	ldh a, [hBGTilesRequestCopy]
	add e
	cp [hl]
	jr nz, .loop

;> LoadEntityPosition()                              # the head's position again
	jp LoadEntityPosition


;@ def LanmolaHeadFrame(slot: bc)
;@ path: boss/desert_lanmola
;@ Points the head the way it moves: along the faster axis, frame 1 right / 0 left, or 2 down /
;@ 3 up.
;@ test: wEntitySpeedX[slot] = rng.randrange(256)
;@ test: wEntitySpeedY[slot] = rng.randrange(256)
LanmolaHeadFrame::
;> vx = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld d, a
;> ax = abs(signed(vx))
	bit 7, a
	jr z, .absY

	cpl
	inc a

.absY
;>@ay ay = abs(signed(wEntitySpeedY[slot]))
	ld e, a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;=@ay
	bit 7, a
	jr z, .compare

	cpl
	inc a

.compare
;> if ay < ax:
	cp e
	jr nc, .vertical

;>     frame = 0 if vx & 0x80 else 1
	bit 7, d
	jr nz, .left

	ld a, $01
	jr .set

.left
	ld a, $00
	jr .set

.vertical
;> else:
;>     frame = 3 if wEntitySpeedY[slot] & 0x80 else 2
	bit 7, [hl]
	jr nz, .up

	ld a, $02
	jr .set

.up
	ld a, $03

.set
;> wEntitySpriteVariant[slot] = frame
	call SetEntitySpriteVariant
	ret


;@ path: boss/desert_lanmola
;@ The sand rock's frames for the one-sprite renderer (DrawEntity8x16): 4 frames of 2 bytes (tile,
;@ attributes): tile $7C mirrored, $7E mirrored, $7C, $7E. A rock starts on frame 0 or 2 and
;@ turns to the next one at the top of its flight.
LanmolaRockSprites::
	db $7c, $20, $7e, $20, $7c, $00, $7e, $00

;@ def LanmolaRockHandler(slot: bc)
;@ path: boss/desert_lanmola
;@ A sand rock thrown up from the Desert Lanmola's hole (entity $87 with wEntityPrivate3 = 2):
;@ flies up and falls back (y speed +1 per frame from -16); at the top it changes frame, and it
;@ vanishes when its speed reaches +16.
;@ test: skip draws sprites
LanmolaRockHandler::
;> DrawEntity8x16(LanmolaRockSprites)           # one 8x16 sprite
	ld de, LanmolaRockSprites
	call DrawEntity8x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> wEntitySpeedY[slot] += 1
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
;> if wEntitySpeedY[slot] == 0:             # top of the flight
	ld a, [hl]
	and a
	jr nz, .check

;>     wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]

.check
;> if wEntitySpeedY[slot] == 0x10:
	cp $10
	jr nz, .done

;>     ClearEntityStatus_06()
	call ClearEntityStatus_06

.done
	ret


;@ path: npc/poodle
;@ The little dog's frames for the two-sprite renderer: 8 frames of 4 bytes (left tile,
;@ attributes, right tile, attributes; $20 mirrored). 0/1 facing left (tiles $70-$76: mouth shut /
;@ open or step), 2/3 the same facing right (mirrored), 4-7 the same four with tiles $00-$06
;@ (used while wGameplayType is 1).
PoodleSprites::
	db $70, $00, $72, $00, $74, $00, $76, $00, $72, $20, $70, $20, $76, $20, $74, $20
	db $00, $00, $02, $00, $04, $00, $06, $00, $02, $20, $00, $20, $06, $20, $04, $20
;@ path: npc/poodle
;@ The little dog wearing the ribbon: same 8 frames as PoodleSprites with tiles $78-$7E and
;@ $10-$16.
PoodleRibbonSprites::
	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20
	db $10, $00, $12, $00, $14, $00, $16, $00, $12, $20, $10, $20, $16, $20, $14, $20

;@ def PoodleHandler(slot: bc)
;@ path: npc/poodle
;@ Entity $78: a little dog that hops about. It can be talked to from any side. The one in room
;@ $B2 is part of the trading sequence: it longs for jewellery (text $180); when Link has the
;@ ribbon (trade item 2) it asks for it (text $181, a question) and swaps it for dog food (trade
;@ item 3); from then on (or with wEntityPrivate1 set) it wears the ribbon. Other dogs say text
;@ $023. While a text box is open (other than $182) it faces Link and its mouth moves with the
;@ text. Gravity 2.
;@ test: skip draws sprites and opens dialogues
PoodleHandler::
;> if wDialogState and wDialogIndex != 0x82:      # talking: face Link and bark along
	ld a, [wDialogState]
	and a
	jr z, .facing

	ld a, [wDialogIndex]
	cp $82
	jr z, .facing

;>     dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;>     wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>     ClearEntitySpeed()                          # stop
	call ClearEntitySpeed
;>@t1     hActiveEntitySpriteVariant = 1 if wDialogCharIndex & 6 else 0
	ld a, [wDialogCharIndex]
	ld e, $00
	and $06
	jr z, .mouth

	inc e

.mouth
;=@t1
	ld a, e
	ldh [hActiveEntitySpriteVariant], a

.facing
;> if wEntityDirection[slot] == 0:          # facing right: the mirrored frames
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .sprites

;>     hActiveEntitySpriteVariant += 2
	ldh a, [hActiveEntitySpriteVariant]
	add $02
	ldh [hActiveEntitySpriteVariant], a

.sprites
;> sprites = PoodleSprites
	ld de, PoodleSprites
;>@t2 if wEntityPrivate1[slot] or (hMapRoom == 0xB2 and wTradeSequenceItem >= 3):
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .ribbon

;=@t2
	ldh a, [hMapRoom]
	cp $b2
	jr nz, .draw

	ld a, [wTradeSequenceItem]
	cp $03
	jr c, .draw

.ribbon
;>     sprites = PoodleRibbonSprites
	ld de, PoodleRibbonSprites

.draw
;> if wGameplayType == 1:
	ld a, [wGameplayType]
	cp $01
	jr nz, .render

;>     hActiveEntitySpriteVariant += 4
	ldh a, [hActiveEntitySpriteVariant]
	add $04
	ldh [hActiveEntitySpriteVariant], a

.render
;> DrawEntity16x16(sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80     # scratch: landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, .talk

;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a

.talk
;> if hActiveEntityState < 2 and ShouldLinkTalkToEntity_06():
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .dispatch

	call ShouldLinkTalkToEntity_06
	jr nc, .dispatch

;>     if hMapRoom == 0xB2:
	ld e, $23
	ldh a, [hMapRoom]
	cp $b2
	jr nz, .otherDog

;>         text = 0x80
	ld e, $80
;>         if wTradeSequenceItem == 2:        # Link has the ribbon
	ld a, [wTradeSequenceItem]
	cp $02
	jr nz, .say

;>             wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>             text = 0x81                  # the ribbon question
	ld e, $81

.say
;>         OpenDialogTable1(text)
	ld a, e
	call OpenDialogTable1
;>         return PoodleBark()
	jp PoodleBark


.otherDog
;>     else:
;>         OpenDialog(0x23)
	ld a, e
	call OpenDialog
;>         PoodleBark()
	call PoodleBark

.dispatch
;> PoodleStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/poodle
;@ The little dog's states: 0 rest, 1 hop about, 2 wait for the answer about the ribbon, 3 give
;@ the dog food.
PoodleStates::
	dw PoodleRest
	dw PoodleHop
	dw PoodleTradeAnswer
	dw PoodleGiveItem

;@ def PoodleTradeAnswer(slot: bc)
;@ path: npc/poodle
;@ State 2: when the question box closes - first answer: Link gets the dog food (trade item 3,
;@ background change $0D), text $183, state 3; second answer: text $184 ("You are the worst!"),
;@ state 0.
;@ test: skip opens dialogues
PoodleTradeAnswer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_006_5ba7

;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     wTradeSequenceItem = 3               # dog food
	ld a, $03
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     OpenDialogTable1(0x83)
	ld a, $83
	call OpenDialogTable1
;>     PoodleBark()
	call PoodleBark
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret


.no
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> OpenDialogTable1(0x84)
	ld a, $84
	call OpenDialogTable1

;@ def PoodleBark()
;@ path: npc/poodle
;@ The dog's bark (wave sound $18).
;@ test: skip writes a sound request only
PoodleBark::
;> hWaveSfx = 0x18
	ld a, $18
	ldh [hWaveSfx], a

jr_006_5ba7:
	ret


;@ def PoodleGiveItem(slot: bc)
;@ path: npc/poodle
;@ State 3: when the text box closes, Link holds up the new item (SpawnHeldItemEntity); state 0.
;@ test: skip spawns an entity
PoodleGiveItem::
;> if wDialogState == 0:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.done
	ret


;@ path: npc/poodle
;@ Random hop speeds of the little dog (1/16 pixel per frame), picked at random for x and for y:
;@ 2, 8, 12, 8 (indices 0-3, facing right) and -2, -8, -12, -8 (4-7, facing left).
PoodleHopSpeeds::
	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

;@ def PoodleRest(slot: bc)
;@ path: npc/poodle
;@ State 0: sits (frame 0) until the timer runs out, then hops off for 48-79 frames (state 1)
;@ with random speeds from PoodleHopSpeeds, facing the way its x speed goes.
;@ test: skip uses the random generator
PoodleRest::
;> wEntitySpriteVariant[slot] = 0
	xor a
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame

;>     i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = PoodleHopSpeeds[i]
	ld hl, PoodleHopSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntityDirection[slot] = i & 4       # 0 right, 4 left
	ld a, e
	and $04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>@t3     wEntitySpeedY[slot] = PoodleHopSpeeds[GetRandomByte() & 7]
	call GetRandomByte
	and $07
	ld e, a
	ld hl, PoodleHopSpeeds
	add hl, de
	ld a, [hl]
;=@t3
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

.frame
;> PoodleStepFrame(slot)
	jp PoodleStepFrame


;@ def PoodleHop(slot: bc)
;@ path: npc/poodle
;@ State 1: moves along in little hops (height speed 8 on each landing) until the timer runs out
;@ on a landing; then rests for 48 frames (state 0). PoodleStepFrame: frame 0/1 every 8 frames.
;@ test: skip bank-0 helpers
PoodleHop::
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls()
	call EntityCheckWalls
;> if hBGTilesRequestCopy:                   # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, PoodleStepFrame

;>     if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .hop

;>         wEntityTimer[slot] = 0x30
	ld [hl], $30
;>         wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>         return
	ret


.hop
;>     wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;>     wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

PoodleStepFrame:
;> wEntitySpriteVariant[slot] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> return
	ret


;@ path: npc/madam_meowmeow
;@ Madam MeowMeow's frames for the two-sprite renderer: 8 frames of 4 bytes (left tile,
;@ attributes, right tile, attributes; $20 mirrored), chosen by SetWalkingFrame_06: 0/1 facing
;@ down (tiles $60/$62), 2/3 facing up ($64/$66), 4/5 facing left ($68-$6E), 6/7 facing right.
MadamMeowMeowSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

;@ def MadamMeowMeowHandler(slot: bc)
;@ path: npc/madam_meowmeow
;@ Entity $79: Madam MeowMeow, Bow-Wow's owner. She turns to Link every 32 frames and blocks him.
;@ While Bow-Wow is dognapped (wIsBowWowFollowingLink = $80) she hops up and down every 64
;@ frames in despair (text $131). With Bow-Wow along: text $132 - or, once Link has the second
;@ dungeon's instrument, Bow-Wow goes home (state 0), text $12F, and 16 frames later Link's
;@ hearts are refilled (wAddHealthBuffer = $FF). Otherwise text $130. Her texts open with bit 7
;@ of wDialogState set.
;@ test: skip draws sprites and opens dialogues
MadamMeowMeowHandler::
;> if wEntityTimer[slot] == 1:
	call GetEntityTimer
	cp $01
	jr nz, .face

;>     wEntityTimer[slot] = 0
	ld [hl], b
;>     wAddHealthBuffer = 0xFF               # refill Link's hearts
	ld a, $ff
	ld [wAddHealthBuffer], a

.face
;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .walk

;>     wEntityDirection[slot] = GetEntityDirectionToLink_06()
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.walk
;> SetWalkingFrame_06()
	call SetWalkingFrame_06
;> DrawEntity16x16(MadamMeowMeowSprites)
	ld de, MadamMeowMeowSprites
	call DrawEntity16x16
;> if wIsBowWowFollowingLink == 0x80:       # dognapped: hop in despair
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jr nz, .act

;>     AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;>     wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>@fl     if wEntityZ[slot] == 0 or wEntityZ[slot] & 0x80:      # on the floor
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .floor
;=@fl

	and $80
	jr z, .act

.floor
;>         wEntityZ[slot] = 0
	ld [hl], b
;>         wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>         if hFrameCounter & 0x3F == 0:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .act

;>             wEntitySpeedZ[slot] = 0x10
	ld [hl], $10

.act
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> hActiveEntityDrawY = hActiveEntityY     # block Link at her feet
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;> BlockLinkIfTouching_06()
	call BlockLinkIfTouching_06
;> LoadEntityPosition()
	call LoadEntityPosition
;> if not ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
;>     return
	jr nc, .done

;> text = 0x30
	ld e, $30
;> if wHasInstrument2 & 2 and wIsBowWowFollowingLink == 1:       # Bow-Wow comes home
	ld a, [wHasInstrument2]
	and $02
	jr z, .other

	ld a, [wIsBowWowFollowingLink]
	cp $01
	jr nz, .other

;>     wIsBowWowFollowingLink = 0
	xor a
	ld [wIsBowWowFollowingLink], a
;>     wEntityTimer[slot] = 0x10            # then refill Link's hearts
	call GetEntityTimer
	ld [hl], $10
;>     text = 0x2F
	ld e, $2f
	jr .say

.other
;> elif wIsBowWowFollowingLink:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr z, .say

;>     text = 0x31 if wIsBowWowFollowingLink != 1 else 0x32
	ld e, $31
	cp $01
	jr nz, .say

	ld e, $32

.say
;> MadamMeowMeowSay(text)
	ld a, e
	call MadamMeowMeowSay

.done
	ret


;@ def MadamMeowMeowSay(text: e)
;@ path: npc/madam_meowmeow
;@ Opens text $100 + `text` with bit 7 of wDialogState set.
;@ test: skip opens a dialogue
MadamMeowMeowSay::
;> OpenDialogTable1(text)
	ld a, e
	call OpenDialogTable1
;> wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
	ret


;@ def UlriraHandler(slot: bc)
;@ path: npc/ulrira
;@ Entity $77: Grandpa Ulrira, too shy to talk face to face (text $140: "Please call..."). His
;@ two frames alternate every 32 frames; he blocks Link. Talking to him the first time sets
;@ wRichardQuest to 1.
;@ test: skip draws sprites and opens a dialogue
UlriraHandler::
;> UlriraDraw(slot)
	call UlriraDraw
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;>@t4 wEntitySpriteVariant[slot] = (hFrameCounter >> 5) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;=@t4
	and $01
	call SetEntitySpriteVariant
;> BlockLinkIfTouching_06()
	call BlockLinkIfTouching_06
;> if ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
	jr nc, .done

;>     if wRichardQuest == 0:
	ld a, [wRichardQuest]
	and a
	jr nz, .say

;>         wRichardQuest = 1
	ld a, $01
	ld [wRichardQuest], a

.say
;>     OpenDialogTable1(0x40)
	ld a, $40
	call OpenDialogTable1

.done
	ret


;@ path: npc/ulrira
;@ Grandpa Ulrira's 2 frames for UlriraDraw, 16 bytes each: 4 sprites (y offset, x offset, tile,
;@ attributes), a 16x32 figure: tiles $70/$72 over $74/$76 (frame 0) and $78/$7A over $7C/$7E
;@ (frame 1).
UlriraOAM::
	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $f0, $00, $78, $00, $f0, $08, $7a, $00, $00, $00, $7c, $00, $00, $08, $7e, $00

;@ def UlriraDraw(slot: bc)
;@ path: npc/ulrira
;@ Draws Grandpa Ulrira's frame (4 sprites from UlriraOAM) and claims 4 OAM entries.
;@ test: skip draws sprites
UlriraDraw::
;>@t5 DrawEntitySprites(UlriraOAM + hActiveEntitySpriteVariant * 16, count=4)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;=@t5
	ld e, a
	ld d, b
	ld hl, UlriraOAM
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
	ret


;@ path: enemy/crow
;@ The crow's frames for the two-sprite renderer: 4 frames of 4 bytes (left tile, attributes,
;@ right tile, attributes; $20 mirrored): 0/1 facing left (tiles $50/$52 and $54/$56, wings up /
;@ down), 2/3 the same facing right.
CrowSprites::
	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

;@ def CrowHandler(slot: bc)
;@ path: enemy/crow
;@ Entity $7A: the crow. It sits (4 pixels higher than placed) until Link comes close, then flies
;@ up and swoops at him, and finally flies off and vanishes off screen. The one in room $58
;@ (gone for good once the room's flag bit 4 is set) only starts when a rock Link threw flies
;@ past it; it drops entity $3C and is not remembered in the room's list.
;@ test: skip draws sprites and calls banked helpers
CrowHandler::
;> if hMapRoom == 0x58:
	ldh a, [hMapRoom]
	cp $58
	jr nz, .frame

;>     if hRoomStatus & 0x10:
	ldh a, [hRoomStatus]
	and $10
;>         return ClearEntityStatus_06()
	jp nz, ClearEntityStatus_06

;>     wEntityLoadOrder[slot] = 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;>     wEntityDropType[slot] = 0x3C
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c

.frame
;> if wEntityDirection[slot] == 0:          # facing right: mirrored frames
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
;> DrawEntity16x16(CrowSprites)
	ld de, CrowSprites
	call DrawEntity16x16
;> if hActiveEntityState == 0:              # first frame
	ldh a, [hActiveEntityState]
	and a
	jr nz, .run

;>     wEntityY[slot] -= 4
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     hActiveEntityState = wEntityState[slot]
	ld a, [hl]
	ldh [hActiveEntityState], a

.run
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06()
	call ApplyRecoilIfNeeded_06
;> CrowStates[hActiveEntityState - 1](slot)
	ldh a, [hActiveEntityState]
	dec a
	rst $00

;@ path: enemy/crow
;@ The crow's states 1-4: perched, taking off, swooping at Link, flying away.
CrowStates::
	dw CrowPerched
	dw CrowTakeOff
	dw CrowSwoop
	dw CrowFlee

;@ def CrowPerched(slot: bc)
;@ path: enemy/crow
;@ State 1: sits. In room $58 it takes off when the liftable object Link handled last (entity $05,
;@ a rock) is flying (wEntityTimer1 running) within 16 pixels across and 40 up / down of it;
;@ elsewhere it faces Link and takes off when he is within 24 pixels across and 48 up / down.
;@ Taking off: physics flags $12, 34 frames, state 2.
;@ test: skip bank-0 helpers
CrowPerched::
;> if hMapRoom == 0x58:
	ldh a, [hMapRoom]
	cp $58
	jr nz, .link

;>     rock = wLiftableObjectSlot
	ld a, [wLiftableObjectSlot]
	ld e, a
	ld d, b
;>@t1     if wEntityStatus[rock] == 0 or wEntityType[rock] != 0x05 or wEntityTimer1[rock] == 0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .done

;=@t1
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, .done

;=@t1
	ld hl, wEntityTimer1
	add hl, de
	ld a, [hl]
	and a
;>         return
	jr z, .done

;>     if u8(hActiveEntityX - wEntityX[rock] + 0x10) >= 0x20:
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $10
	cp $20
;>         return
	jr nc, .done

;>     if u8(hActiveEntityDrawY - wEntityY[rock] + 0x28) >= 0x50:
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $28
	cp $50
;>         return
	jr nc, .done

	jr .takeOff

.link
;> else:
;>     dx, side = GetEntityXDistanceToLink_06()
	call GetEntityXDistanceToLink_06
;>     wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>     if u8(dx + 0x18) >= 0x30:
	add $18
	cp $30
;>         return
	jr nc, .done

;>     dy, side = GetEntityYDistanceToLink_06()
	call GetEntityYDistanceToLink_06
;>     if u8(dy + 0x30) >= 0x60:
	add $30
	cp $60
;>         return
	jr nc, .done

.takeOff
;> wEntityPhysicsFlags[slot] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $12
;> wEntityTimer[slot] = 0x22
	call GetEntityTimer
	ld [hl], $22
;> wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def CrowTakeOff(slot: bc)
;@ path: enemy/crow
;@ State 2: rises straight up (height speed 8), flapping; after 34 frames it swoops (state 3,
;@ 48 frames).
;@ test: skip bank-0 helpers
CrowTakeOff::
;> EntityCheckHits()
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .rise

;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityState[slot] += 1
;>     return
	jp IncrementEntityState


.rise
;> ClearEntitySpeed()                              # no sideways movement
	call ClearEntitySpeed
;> wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;> AddEntityZSpeedToPos_06()
	call AddEntityZSpeedToPos_06
;> CrowFlapFrame(slot)
	jr CrowFlapFrame

;@ def CrowSwoop(slot: bc)
;@ path: enemy/crow
;@ State 3: on even frames turns its speed one step towards a speed of $20 at Link (both axes),
;@ facing the way it flies; flies (CrowFly). When the timer runs out it flies away (state 4).
;@ CrowFly moves it and flaps (CrowFlapFrame: the wing sound, frame = bit 3 of the byte the move
;@ left hl at - its y position, or its height when taking off).
;@ test: skip moves through banked helpers
CrowSwoop::
;> EntityCheckHits()
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return IncrementEntityState()
	jp z, IncrementEntityState

;> if wEntityTimer[slot] & 1:
	and $01
;>     return CrowFly(slot)
	jr nz, CrowFly

;> GetVectorTowardsLink(0x20)                          # hMultiPurpose0/1 = y / x speed towards Link
	ld a, $20
	call GetVectorTowardsLink
;>@t2 wEntitySpeedY[slot] += 1 if not (hMultiPurpose0 - wEntitySpeedY[slot]) & 0x80 else -1
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	and $80
	jr nz, .decY

;=@t2
	inc [hl]
	inc [hl]

.decY
;=@t2
	dec [hl]
;>@t3 wEntitySpeedX[slot] += 1 if not (hMultiPurpose1 - wEntitySpeedX[slot]) & 0x80 else -1
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	and $80
	jr nz, .decX

;=@t3
	inc [hl]
	inc [hl]

.decX
;=@t3
	dec [hl]
;>@t4 wEntityDirection[slot] = wEntitySpeedX[slot] & 0x80      # 0 = flying right
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	ld hl, wEntityDirection
	add hl, bc
;=@t4
	ld [hl], a

;@ def CrowFly(slot: bc)
;@ path: enemy/crow
;@ Moves the crow and flaps its wings (see CrowSwoop).
;@ test: skip part of the crow's state machine
CrowFly::
;> UpdateEntityPosWithSpeed_06()
	call UpdateEntityPosWithSpeed_06
;> CrowFlapSound()
	call CrowFlapSound

CrowFlapFrame:
;> CrowFlapSound()
	call CrowFlapSound
;> wEntitySpriteVariant[slot] = (mem[hl] >> 3) & 1       # hl as the move left it
	ld a, [hl]
	rra
	rra
	rra
	and $01
	jp SetEntitySpriteVariant


;@ def CrowFlapSound()
;@ path: enemy/crow
;@ The crow's wing beat (PlayPeriodicNoiseSfx).
;@ test: skip writes a sound request only
CrowFlapSound::
;> PlayPeriodicNoiseSfx()
	call PlayPeriodicNoiseSfx
	ret


;@ def CrowFlee(slot: bc)
;@ path: enemy/crow
;@ State 4: every 4 frames turns its speed one step towards a speed of $20 away from Link, flies
;@ and disappears once it is off the screen (CrowRemoveOffscreen: drawn y $88 or more, or x $A8
;@ or more).
;@ test: skip moves through banked helpers
CrowFlee::
;> EntityCheckHits()
	call EntityCheckHits
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .fly

;>     GetVectorTowardsLink(0x20)
	ld a, $20
	call GetVectorTowardsLink
;>@t5     wEntitySpeedY[slot] += 1 if not (u8(-hMultiPurpose0) - wEntitySpeedY[slot]) & 0x80 else -1
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
;=@t5
	and $80
	jr nz, .decY

	inc [hl]
	inc [hl]

.decY
;=@t5
	dec [hl]
;>@t6     wEntitySpeedX[slot] += 1 if not (u8(-hMultiPurpose1) - wEntitySpeedX[slot]) & 0x80 else -1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
;=@t6
	and $80
	jr nz, .decX

	inc [hl]
	inc [hl]

.decX
;=@t6
	dec [hl]
;>@t7     wEntityDirection[slot] = wEntitySpeedX[slot] & 0x80
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	ld hl, wEntityDirection
	add hl, bc
;=@t7
	ld [hl], a

.fly
;> CrowFly(slot)
	call CrowFly

;@ def CrowRemoveOffscreen(slot: bc)
;@ path: enemy/crow
;@ Removes the entity once it has left the screen (drawn y $88 or more, x $A8 or more; the
;@ positions wrap, so this also covers the top and left edges). Also used by the Goponga
;@ flower's shots.
;@ test: skip bank-0 helper
CrowRemoveOffscreen::
;> if hActiveEntityDrawY >= 0x88:
	ldh a, [hActiveEntityDrawY]
	cp $88
;>     return ClearEntityStatus_06()
	jp nc, ClearEntityStatus_06

;> if hActiveEntityX >= 0xA8:
	ldh a, [hActiveEntityX]
	cp $a8
;>     return ClearEntityStatus_06()
	jp nc, ClearEntityStatus_06

	ret


;@ path: npc/crazy_tracy
;@ Crazy Tracy's 3 frames for CrazyTracyHandler, 16 bytes each: 4 sprites (y offset, x offset,
;@ tile, attributes; $20 mirrored), a 16x32 figure (tiles $60-$6A): 0 looking left, 1 looking
;@ ahead, 2 looking right (frame 0 mirrored). Chosen by Link's x position.
CrazyTracyOAM::
	db $f8, $00, $64, $00, $f8, $08, $66, $00, $08, $00, $68, $00, $08, $08, $6a, $00
	db $f8, $00, $60, $00, $f8, $08, $62, $00, $08, $00, $68, $00, $08, $08, $6a, $00
	db $f8, $00, $66, $20, $f8, $08, $64, $20, $08, $00, $6a, $20, $08, $08, $68, $20
;@ path: npc/crazy_tracy
;@ The bottle of secret medicine Link holds up after buying it, for the one-sprite renderer:
;@ tile $A0, sprite palette 1.
CrazyTracyMedicineSprite::
	db $a0, $10

;@ def CrazyTracyHandler(slot: bc)
;@ path: npc/crazy_tracy
;@ Entity $7B: Crazy Tracy, who sells the secret medicine across her counter (Link can talk to
;@ her from up to 40 pixels above or below). While her timer runs (after a sale) Link holds the
;@ bottle up over his head (pose $6C, facing down, sword reset). She looks towards Link's side
;@ of the room (frame by his x: below $30, below $60, else).
;@ test: skip draws sprites and opens dialogues
CrazyTracyHandler::
;> if wEntityTimer[slot]:                   # Link shows the medicine
	call GetEntityTimer
	jr z, .look

;>     hActiveEntityX = hLinkX
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY = wLinkDrawY - 0x10
	ld a, [wLinkDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;>     hLinkAnimationState = 0x6C            # holding an item up
	ld a, $6c
	ldh [hLinkAnimationState], a
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
;>     wSwordAnimationState = 0
	xor a
	ld [wSwordAnimationState], a
;>     wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;>     wSwordCharge = 0
	ld [wSwordCharge], a
;>     wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
;>     DrawEntity8x16(CrazyTracyMedicineSprite)
	ld de, CrazyTracyMedicineSprite
	call DrawEntity8x16
;>     LoadEntityPosition()
	call LoadEntityPosition

.look
;>@fr frame = 0 if hLinkX < 0x30 else 1 if hLinkX < 0x60 else 2
	ld e, $00
	ldh a, [hLinkX]
	cp $30
	jr c, .set
;=@fr

	ld e, $01
	cp $60
	jr c, .set

	ld e, $02

.set
;> hActiveEntitySpriteVariant = frame
	ld a, e
	ldh [hActiveEntitySpriteVariant], a
;>@dy hActiveEntityDrawY -= 4
;>@d DrawEntitySprites(CrazyTracyOAM + frame * 16, count=4)
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
;=@d
	ld d, b
	ld hl, CrazyTracyOAM
	add hl, de
;=@dy
	ldh a, [hActiveEntityDrawY]
	sub $04
	ldh [hActiveEntityDrawY], a
;=@d
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
;> LoadEntityPosition()
	call LoadEntityPosition
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> BlockLinkIfTouching_06()
	call BlockLinkIfTouching_06
;> CrazyTracyStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/crazy_tracy
;@ Crazy Tracy's states: 0 greet, 1 offer the medicine, 2 the answer, 3 the eighth sale, 4 after
;@ a sale.
CrazyTracyStates::
	dw CrazyTracyGreet
	dw CrazyTracyOffer
	dw CrazyTracyAnswer
	dw CrazyTracyEighthSale
	dw CrazyTracyAfterSale

;@ def CrazyTracyCanTalk() -> carry
;@ path: npc/crazy_tracy
;@ ShouldLinkTalkToEntity_06 with a taller reach: Link may be up to 40 pixels above or below
;@ her (across the counter).
;@ test: skip bank-0 helpers
CrazyTracyCanTalk::
;>@t8 return ShouldLinkTalkToEntityCheckX_06(u8(hLinkY - hActiveEntityY + 0x28) < 0x50)
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $28
	cp $50
	call ShouldLinkTalkToEntityCheckX_06
;=@t8
	ret


;@ def CrazyTracyGreet(slot: bc)
;@ path: npc/crazy_tracy
;@ State 0: when Link talks to her she says text $017 and picks the price: $28 rupees when
;@ wKillCounter is even, $42 when odd (wEntityPrivate1 = 0 / 1), or 7 rupees ($+2) for the eighth
;@ bottle (wTracyMedicineSales = 7). State 1.
;@ test: skip opens a dialogue
CrazyTracyGreet::
;> if CrazyTracyCanTalk():
	call CrazyTracyCanTalk
	jr nc, .done

;>     OpenDialog(0x17)
	ld a, $17
	call OpenDialog
;>     wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
;>     wEntityPrivate1[slot] = wKillCounter & 1       # which price
	ld a, [wKillCounter]
	and $01
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;>     if wTracyMedicineSales == 7:
	ld a, [wTracyMedicineSales]
	cp $07
	jr nz, .next

;>         wEntityPrivate1[slot] += 2         # the cheap eighth bottle
	inc [hl]
	inc [hl]

.next
;>     wEntityState[slot] += 1
	call IncrementEntityState

.done
	ret


;@ def CrazyTracyOffer(slot: bc)
;@ path: npc/crazy_tracy
;@ State 1: talked to again - if Link already has the medicine, text $01C; otherwise she offers
;@ it (text $018 or $019, a question, by the price) and waits for the answer (state 2).
;@ test: skip opens a dialogue
CrazyTracyOffer::
;> if not CrazyTracyCanTalk():
	call CrazyTracyCanTalk
;>     return
	ret nc

;> if wMedicineCount == 0:
	ld a, [wMedicineCount]
	and a
	jr nz, .haveOne

;>@t9     OpenDialog(0x18 if wEntityPrivate1[slot] & 1 == 0 else 0x19)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and $01
	ld a, $18
	jr z, .say

;=@t9
	ld a, $19

.say
;=@t9
	call OpenDialog
;>     wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
;>     wEntityState[slot] += 1
;>     return
	jp IncrementEntityState


.haveOne
;> OpenDialog(0x1C)
	ld a, $1c
	call OpenDialog
;> wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
	ret


;@ path: npc/crazy_tracy
;@ Low byte of the price Crazy Tracy checks against Link's rupees (BCD, like wRupeeCountLow),
;@ index wEntityPrivate1: 0 = 28 rupees, 1 = 42, 2 and 3 = 7 (the eighth bottle).
CrazyTracyPriceLow::
	db $28, $42, $07, $07

;@ path: npc/crazy_tracy
;@ High byte (BCD) of each price: always 0.
CrazyTracyPriceHigh::
	db $00, $00, $00, $00

;@ path: npc/crazy_tracy
;@ The same prices as binary numbers, added to wSubtractRupeeBuffer: 28, 42, 7, 7 (low bytes).
CrazyTracyChargeLow::
	db $1c, $2a, $07, $07

;@ path: npc/crazy_tracy
;@ High bytes of CrazyTracyChargeLow: always 0.
CrazyTracyChargeHigh::
	db $00, $00, $00, $00

;@ def CrazyTracyAnswer(slot: bc)
;@ path: npc/crazy_tracy
;@ State 2: when the question box closes - "no": text $01D, state 0. "Yes" without enough
;@ rupees: text $01B, state 0. Otherwise the sale counter goes up (0-7); on the eighth sale she
;@ first says text $01E (state 3), else the sale happens now (CrazyTracySell): the price goes
;@ into wSubtractRupeeBuffer, Link gets a medicine, text $01A, jingle 1, and for 32 frames he
;@ holds the bottle up (state 4).
;@ test: skip opens dialogues
CrazyTracyAnswer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jp nz, Jump_006_606f

;> if wDialogAnswer:                        # "no"
	ld a, [wDialogAnswer]
	and a
;>     return CrazyTracySayAndReset(0x1D)
	jr nz, jr_006_6061

;>@t10 price = CrazyTracyPriceHigh[wEntityPrivate1[slot]] << 8 | CrazyTracyPriceLow[wEntityPrivate1[slot]]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, CrazyTracyPriceHigh
	add hl, de
;=@t10
	ld a, [hl]
	ld hl, CrazyTracyPriceLow
	add hl, de
	ld e, [hl]
	ld d, a
;> if (wRupeeCountHigh << 8 | wRupeeCountLow) < price:      # not enough rupees
	ld a, [wRupeeCountLow]
	sub e
	ld a, [wRupeeCountHigh]
	sbc d
	jr nc, .enough

;>     return CrazyTracySayAndReset(0x1B)
	ld a, $1b
	jr CrazyTracySayAndReset

.enough
;> wTracyMedicineSales = (wTracyMedicineSales + 1) & 7
	ld a, [wTracyMedicineSales]
	inc a
	and $07
	ld [wTracyMedicineSales], a
;> if wTracyMedicineSales == 0:              # the eighth sale
	jr nz, CrazyTracySell

;>     OpenDialog(0x1E)
	ld a, $1e
	call OpenDialog
;>     wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
;>     wEntityState[slot] += 1
;>     return
	jp IncrementEntityState


CrazyTracySell:
;> i = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;> wSubtractRupeeBufferLow += CrazyTracyChargeLow[i]       # (carry into the high byte)
	ld hl, CrazyTracyChargeLow
	add hl, de
	ld a, [wSubtractRupeeBufferLow]
	add [hl]
	ld [wSubtractRupeeBufferLow], a
	rl a
;> wSubtractRupeeBufferHigh += CrazyTracyChargeHigh[i] + carry
	ld hl, CrazyTracyChargeHigh
	add hl, de
	rr a
	ld a, [wSubtractRupeeBufferHigh]
	adc [hl]
	ld [wSubtractRupeeBufferHigh], a
;> wMedicineCount += 1
	ld hl, wMedicineCount
	inc [hl]
;> CrazyTracySayAndReset(0x1A)
	ld a, $1a
	call CrazyTracySayAndReset
;> wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;> wEntityTimer[slot] = 0x20                 # Link holds the bottle up
	call GetEntityTimer
	ld [hl], $20
;> hJingle = 0x01
	ld a, $01
	ldh [hJingle], a
	ret


jr_006_6061:
;> CrazyTracySayAndReset(0x1D)
	ld a, $1d

;@ def CrazyTracySayAndReset(slot: bc, text: a)
;@ path: npc/crazy_tracy
;@ Opens text `text` (with bit 7 of wDialogState) and puts Crazy Tracy back to state 0.
;@ test: skip opens a dialogue
CrazyTracySayAndReset::
;> OpenDialog(text)
	call OpenDialog
;> wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

Jump_006_606f:
	ret


;@ def CrazyTracyEighthSale(slot: bc)
;@ path: npc/crazy_tracy
;@ State 3: once text $01E has closed, makes the sale (CrazyTracySell).
;@ test: skip part of a state machine
CrazyTracyEighthSale::
;> if wDialogState == 0:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     return CrazyTracySell(slot)
	jr CrazyTracySell

.done
	ret


;@ def CrazyTracyAfterSale(slot: bc)
;@ path: npc/crazy_tracy
;@ State 4: Link stays frozen; when the timer has run out and the text box is closed, she
;@ fills his hearts if they are not full (wAddHealthBuffer = $FF, text $19A "bonus
;@ treatment"); state 0.
;@ test: skip opens a dialogue
CrazyTracyAfterSale::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return
	ret nz

;> if wDialogState == 0:
	ld a, [wDialogState]
	and a
	jr nz, .freeze

;>     if not wHealthIsFull:
	ld a, [wHealthIsFull]
	and a
	jr nz, .reset

;>         wAddHealthBuffer = 0xFF
	ld a, $ff
	ld [wAddHealthBuffer], a
;>         OpenDialogTable1(0x9A)
	ld a, $9a
	call OpenDialogTable1
;>         wDialogState |= 0x80
	ld hl, wDialogState
	set 7, [hl]

.reset
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.freeze
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


	db $70, $00, $72, $00, $72, $20, $70, $20, $74, $00, $76, $00, $76, $20, $74, $20
	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20
	db $3e, $00

Call_06_60C3::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_60e6

	ld de, $60c1
	call DrawEntity8x16
	call ReturnIfNonInteractive_06
	call UpdateEntityPosWithSpeed_06
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	call GetEntityTimer
	jp z, ClearEntityStatus_06

	ret


jr_006_60e6:
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp nz, Jump_006_61a8

	ld a, [wGameplayType]
	cp $01
	jp z, Jump_006_61a8

	ld de, $60a1
	call DrawEntity16x16
	call GetEntityYDistanceToLink_06
	ld a, e
	dec a
	and $02
	xor $02
	ld e, a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_6117::
	dw Jump_06_611D
	dw Jump_06_6135
	dw Jump_06_616C

Jump_06_611D::
	call ReturnIfNonInteractive_06
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $30
	ld a, $0e
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrack], a
	ldh [hDefaultMusicTrackAlt], a

Jump_006_612f:
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ret


Jump_06_6135::
	call ReturnIfNonInteractive_06
	call GetEntityYDistanceToLink_06
	add $20
	cp $40
	jr c, jr_006_6148

	ld hl, wEntityPrivate2
	add hl, bc
	dec [hl]
	jr nz, jr_006_615c

jr_006_6148:
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

	ldh a, [hActiveEntityType]
	cp $71
	jr nz, jr_006_6159

	ld a, $20
	call OpenDialogTable2

jr_006_6159:
	jp Jump_006_612f


jr_006_615c:
	ld a, $08
	call SetEntitySpeedTowardsLink
	call UpdateEntityPosWithSpeed_06
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ret


Jump_06_616C::
	xor a
	ld [wLinkFrozen], a
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
	call BlockLinkIfTouching_06
	call LoadEntityPosition
	call ShouldLinkTalkToEntity_06
	jr nc, jr_006_6184

	ld a, $20
	call OpenDialogTable2

jr_006_6184:
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6199

	and $80
	jr z, jr_006_61a7

jr_006_6199:
	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_006_61a7

	ld [hl], $10

jr_006_61a7:
	ret


Jump_006_61a8:
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	or [hl]
	ldh [hActiveEntitySpriteVariant], a
	ld de, $60b1
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call Call_06_626A
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_006_61d7

	xor a
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a

jr_006_61d7:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_61DA::
	dw Jump_06_61DE
	dw Jump_06_6224

Jump_06_61DE::
	call GetEntityTimer
	jr nz, jr_006_6223

	ld [hl], $80
	call IncrementEntityState
	ld a, $01
	call SetEntitySpriteVariant
	ld a, $71
	call SpawnEntity
	jr c, jr_006_6223

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
	ld [hl], $01
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
	ldh a, [hActiveEntityType]
	cp $71
	ld a, $14
	jr z, jr_006_6218

	ld a, $ec

jr_006_6218:
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $24

jr_006_6223:
	ret


Jump_06_6224::
	call GetEntityTimer
	jr nz, jr_006_6230

	ld [hl], $60
	call IncrementEntityState
	ld [hl], b
	ret


jr_006_6230:
	cp $60
	jr nc, jr_006_6247

	cp $40
	jr nc, jr_006_6243

	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_6243

	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08

jr_006_6243:
	xor a
	call SetEntitySpriteVariant

jr_006_6247:
	ret


Call_06_6248::
	ldh a, [hMapRoom]
	cp $92
	jr nz, jr_006_6256

	ld a, [wTradeSequenceItem]
	cp $07
	jp c, ClearEntityStatus_06

jr_006_6256:
	ld de, $60a1
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant

Call_06_626A::
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
	call BlockLinkIfTouching_06
	call LoadEntityPosition
	call ShouldLinkTalkToEntity_06
	jr nc, jr_006_62dd

	ld a, [wIsMarinInAnimalVillage]
	and a
	jr z, jr_006_6284

	ld a, $23
	jp OpenDialogTable1


jr_006_6284:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_006_628f

	ld a, $21
	jp OpenDialogTable1


jr_006_628f:
	ldh a, [hMapRoom]
	cp $92
	jr nz, jr_006_62a1

	ld a, [$d8fd]
	and $30
	jr nz, jr_006_62a1

	ld a, $20
	jp OpenDialogTable1


jr_006_62a1:
	ld a, [wHasInstrument2]
	and $02
	jr z, jr_006_62ba

	ld a, [$dabe]
	and $10
	jr nz, jr_006_62ba

	ldh a, [hMapRoom]
	cp $83
	jr nz, jr_006_62ba

	ld a, $22
	jp OpenDialogTable1


jr_006_62ba:
	ld hl, $db7e
	ld a, [hl]
	push af
	inc a
	cp $04
	jr nz, jr_006_62c5

	xor a

jr_006_62c5:
	ld [hl], a
	ld a, [wDungeonFlags]
	and $02
	jr nz, jr_006_62d3

	pop af
	add $18
	jp OpenDialogTable1


jr_006_62d3:
	pop af
	ldh a, [hActiveEntityType]
	sub $70
	add $1c
	call OpenDialogTable1

jr_006_62dd:
	ret


Call_06_62DE::
	call Call_06_63A3
	call ReturnIfNonInteractive_06
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckWeaponHits
	call BlockLinkIfTouching_06
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_62F0::
	dw Jump_06_62F6
	dw Jump_06_62FE
	dw Jump_06_6312

Jump_06_62F6::
	call GetEntityTimer
	ld [hl], $c0
	jp IncrementEntityState


Jump_06_62FE::
	call GetEntityTimer
	jr nz, jr_006_6308

	ld [hl], $50
	call IncrementEntityState

jr_006_6308:
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_06_6312::
	call GetEntityTimer
	jr nz, jr_006_631b

	call IncrementEntityState
	ld [hl], b

jr_006_631b:
	cp $4a
	jr nz, jr_006_633d

	ld a, $7d
	call SpawnEntity
	jr c, jr_006_633d

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	push bc
	push de
	pop bc
	ld a, $0c
	call SetEntitySpeedTowardsLink
	pop bc

jr_006_633d:
	ld a, $02
	call SetEntitySpriteVariant
	ret


	db $f8, $f8, $70, $00, $f8, $00, $72, $00, $f8, $08, $72, $20, $f8, $10, $70, $20
	db $08, $f8, $74, $00, $08, $00, $76, $00, $08, $08, $76, $20, $08, $10, $74, $20
	db $f9, $f9, $70, $00, $f9, $01, $72, $00, $f9, $07, $72, $20, $f9, $0f, $70, $20
	db $07, $f9, $74, $00, $07, $01, $76, $00, $07, $07, $76, $20, $07, $0f, $74, $20
	db $f8, $f8, $78, $00, $f8, $00, $7a, $00, $f8, $08, $7a, $20, $f8, $10, $78, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20

Call_06_63A3::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6343
	add hl, de
	ld c, $08
	call DrawEntitySprites
	ld a, $08
	call ReserveOAMEntriesFar
	ret


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $32, $00, $32, $20, $30, $00, $30, $20

Call_06_63CD::
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $30
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_63e3

	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a

jr_006_63e3:
	ld de, $63bd
	call DrawEntity16x16
	call GetEntityTimer
	jr z, jr_006_63fc

	dec a
	jp z, ClearEntityStatus_06

	rra
	rra
	rra
	and $01
	add $02
	jp SetEntitySpriteVariant


jr_006_63fc:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	cp $02
	jr c, jr_006_640b

	call GetEntityTimer
	ld [hl], $10
	ret


jr_006_640b:
	ld [hl], b
	call ReturnIfNonInteractive_06
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call EntityCheckHits
	call UpdateEntityPosWithSpeed_06
	jp CrowRemoveOffscreen


	db $50, $00, $50, $20, $52, $00, $52, $20

Call_06_642A::
	ld de, $6422
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckWeaponHits
	call BlockLinkIfTouching_06
	ldh a, [hFrameCounter]
	ld e, b
	and $30
	jr z, jr_006_6444

	inc e

jr_006_6444:
	ld a, e
	call SetEntitySpriteVariant
	ret


BlockLinkIfTouching_06::
	call EntityTouchesLink
	jr nc, jr_006_646b

BlockLink_06::
	call RestoreLinkPosition
	call ResetPegasusBoots
	ld a, [wHookshotChainSlot]
	and a
	jr z, jr_006_646b

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_006_646b

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_006_646b:
	ret


	db $06, $04, $02, $00

SetWalkingFrame_06::
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $646c
	add hl, de
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	rra
	pop hl
	and $01
	or [hl]
	jp SetEntitySpriteVariant


ShouldLinkTalkToEntity_06::
	ld e, b
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28

ShouldLinkTalkToEntityCheckX_06::
	jr nc, jr_006_64dd

	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_006_64dd

	inc e
	ldh a, [hActiveEntityType]
	cp $78
	jr z, jr_006_64b8

	push de
	call GetEntityDirectionToLink_06
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
	jr nz, jr_006_64dd

jr_006_64b8:
	ld hl, wCanTalkToEntity
	ld [hl], $01
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
	ld hl, wDialogCooldown
	or [hl]
	jr nz, jr_006_64dd

	ld a, [wWindowY]
	cp $80
	jr nz, jr_006_64dd

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_006_64dd

	scf
	ret


jr_006_64dd:
	and a
	ret


ReturnIfNonInteractive_06::
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, jr_006_64ff

ReturnIfGamePaused_06::
	ld a, [wGameplayType]
	cp $07
	jr z, jr_006_64ff

	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, jr_006_64ff

	ld a, [wRoomTransitionState]
	and a
	jr z, jr_006_6500

jr_006_64ff:
	pop af

jr_006_6500:
	ret


ApplyRecoilIfNeeded_06::
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_654a

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
	call UpdateEntityPosWithSpeed_06
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_006_653d

	call EntityCheckWalls

jr_006_653d:
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_006_654a:
	ret


UpdateEntityPosWithSpeed_06::
	call AddEntitySpeedToPos_06
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPos_06
	pop bc
	ret


AddEntitySpeedToPos_06::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6583

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityX

jr_006_6570:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_006_657a

	ld e, $f0

jr_006_657a:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_006_6583:
	ret


AddEntityZSpeedToPos_06::
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6583

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityZ
	jr jr_006_6570

GetEntityXDistanceToLink_06::
	ld e, $00
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_006_65ac

	inc e

jr_006_65ac:
	ld d, a
	ret


GetEntityYDistanceToLink_06::
	ld e, $02
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_006_65bc

	inc e

jr_006_65bc:
	ld d, a
	ret


GetEntityDirectionToLink_06::
	call GetEntityXDistanceToLink_06
	ld a, e
	ldh [hMultiPurpose0], a
	ld a, d
	bit 7, a
	jr z, jr_006_65cb

	cpl
	inc a

jr_006_65cb:
	push af
	call GetEntityYDistanceToLink_06
	ld a, e
	ldh [hMultiPurpose1], a
	ld a, d
	bit 7, a
	jr z, jr_006_65d9

	cpl
	inc a

jr_006_65d9:
	pop de
	cp d
	jr nc, jr_006_65e1

	ldh a, [hMultiPurpose0]
	jr jr_006_65e3

jr_006_65e1:
	ldh a, [hMultiPurpose1]

jr_006_65e3:
	ld e, a
	ret


ClearEntityStatus_06::
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


	db $6a, $20, $68, $20, $68, $00, $6a, $00, $6c, $40, $6c, $60, $6c, $00, $6c, $20

Call_06_65FB::
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
	ld de, $65eb
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call EntityCheckTouchLink
	call UpdateEntityPosWithSpeed_06
	call EntityCheckObjectCollision
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6620

	call ClearEntityStatus_06

jr_006_6620:
	ret


	db $5c, $00, $5c, $20, $5c, $10, $5c, $30, $00, $10, $00, $f0, $00, $f0, $00, $10
	db $10, $00, $f0, $00, $10, $00, $f0, $00, $01, $08, $02, $04, $01, $04, $02, $08

Call_06_6641::
	ld a, $01
	ldh [$ffbe], a
	ldh a, [hFrameCounter]
	rra
	and $01
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6621
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call EntityCheckContactDamage
	call UpdateEntityPosWithSpeed_06
	call Call_06_66D8
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld e, a
	ld hl, $6639
	add hl, de
	push hl
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	pop hl
	and [hl]
	jr nz, jr_006_6691

	call GetEntityTimer
	jr nz, jr_006_669c

	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_006_66a9

	call GetEntityTimer
	ld [hl], $09
	jr jr_006_66a9

jr_006_6691:
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $03
	ld [hl], a
	jr jr_006_66a9

jr_006_669c:
	cp $06
	jr nz, jr_006_66a9

	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
	ld a, [hl]
	and $03
	ld [hl], a

jr_006_66a9:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld e, a
	ld hl, $6629
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld e, a
	ld hl, $6631
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ret


Call_06_66D8::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $ff
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $ff
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	pop af
	or [hl]
	ld [hl], a
	pop af
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop af
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ret


	db $42, $00, $42, $20, $40, $00, $40, $20, $62, $00, $62, $20, $60, $00, $60, $20
	db $00, $05, $0a, $0d, $0e, $0d, $0a, $05, $00, $fb, $f6, $f3, $f2, $f3, $f6, $fb
	db $00, $05, $0a, $0d, $0c, $04, $08, $00

Call_06_673C::
	ld de, $6714
	ldh a, [hMapId]
	cp $0a
	jr nz, jr_006_6748

	ld de, $671c

jr_006_6748:
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_6757::
	dw Jump_06_675B
	dw Jump_06_679B

Jump_06_675B::
	call GetEntityTimer
	jp nz, Jump_006_67f2

	call GetEntityXDistanceToLink_06
	add $20
	cp $40
	jp nc, Jump_006_67f2

	call GetEntityYDistanceToLink_06
	add $20
	cp $40
	jp nc, Jump_006_67f2

	call GetEntityDirectionToLink_06
	ld d, $00
	ld hl, $6738
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $50
	ld [hl], a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $01
	call IncrementEntityState
	jp Jump_006_67f2


Jump_06_679B::
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	call GetEntityTimer
	jr nz, jr_006_67ae

	ld [hl], $20
	call IncrementEntityState
	ld [hl], b
	jr jr_006_67f2

jr_006_67ae:
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr c, jr_006_67f2

	ld [hl], b
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
	ld hl, $6724
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $6728
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $1f
	jr nz, jr_006_67f2

	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

Jump_006_67f2:
jr_006_67f2:
	ldh a, [hActiveEntityState]
	and a
	jr z, jr_006_67fe

	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01

jr_006_67fe:
	jp SetEntitySpriteVariant


Call_06_6801::
	ld a, c
	ld [$c501], a
	ldh a, [hMapRoom]
	cp $64
	jr nz, jr_006_6819

	ld a, [$d9e3]
	and $40
	ret z

	ld a, [$db69]
	and $02
	jp nz, ClearEntityStatus_06

jr_006_6819:
	ldh a, [hMapRoom]
	cp $ac
	jr nz, jr_006_6826

	ldh a, [hRoomStatus]
	and $10
	jp z, ClearEntityStatus_06

jr_006_6826:
	ldh a, [hMapRoom]
	cp $41
	jr nz, jr_006_6835

	ld a, [wKeyItemFlags]
	and a
	ret z

	call GetEntityTimer1
	ret nz

jr_006_6835:
	ldh a, [hMapRoom]
	cp $ee
	jr nz, jr_006_6841

	ld a, [$db12]
	and a
	jr jr_006_68a9

jr_006_6841:
	ldh a, [hMapRoom]
	cp $d2
	jr z, jr_006_685a

	cp $36
	jr nz, jr_006_685f

	ld a, [wHasInstrument2]
	and a
	jp nz, ClearEntityStatus_06

	ld a, [wIsBowWowFollowingLink]
	cp $01
	jp nz, ClearEntityStatus_06

jr_006_685a:
	ld a, [wDungeonFlags]
	jr jr_006_68a7

jr_006_685f:
	ldh a, [hMapRoom]
	cp $08
	jr nz, jr_006_6875

	ld a, [$db6c]
	and $02
	jp nz, ClearEntityStatus_06

	ld a, [$d808]
	and $10
	ret z

	jr jr_006_68ac

jr_006_6875:
	cp $9d
	jr nz, jr_006_687e

	ld a, [$db69]
	jr jr_006_68a7

jr_006_687e:
	cp $06
	jr nz, jr_006_688a

	ld a, [$d806]
	and $10
	ret z

	jr jr_006_68ac

jr_006_688a:
	cp $b6
	jr nz, jr_006_6893

	ld a, [$db67]
	jr jr_006_68a7

jr_006_6893:
	cp $17
	jr z, jr_006_689b

	cp $9c
	jr nz, jr_006_68a0

jr_006_689b:
	ld a, [$db6a]
	jr jr_006_68a7

jr_006_68a0:
	cp $16
	jr nz, jr_006_68ac

	ld a, [wHasInstrument2]

jr_006_68a7:
	and $02

jr_006_68a9:
	jp z, ClearEntityStatus_06

jr_006_68ac:
	ldh a, [hMapRoom]
	cp $d2
	jr z, jr_006_68c0

	cp $16
	jr z, jr_006_68c0

	cp $36
	jr z, jr_006_68c0

	ldh a, [hActiveEntityState]
	cp $00
	jr z, jr_006_68c3

jr_006_68c0:
	call Call_06_6A5A

jr_006_68c3:
	ldh a, [hFrameCounter]
	and $b0
	ld a, $00
	jr nz, jr_006_68cc

	inc a

jr_006_68cc:
	call SetEntitySpriteVariant
	ld a, [wRoomTransitionState]
	and a
	ret nz

	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_68D7::
	dw Jump_06_68E1
	dw Jump_06_693C
	dw Jump_06_6982
	dw Jump_06_69B1
	dw Jump_06_69DB

Jump_06_68E1::
	ldh a, [hMapRoom]
	cp $f2
	jr nz, jr_006_68fb

	ld a, $1d
	ldh [hDefaultMusicTrack], a
	ldh a, [hLinkY]
	cp $44
	ret c

	ldh a, [hLinkX]
	sub $58
	add $18
	cp $30
	ret nc

	jr jr_006_6902

jr_006_68fb:
	ld a, [wSwordLevel]
	and a
	jp z, ClearEntityStatus_06

jr_006_6902:
	ldh a, [hDefaultMusicTrack]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ld a, $22
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrack], a
	ldh [hDefaultMusicTrackAlt], a
	ldh a, [hMapRoom]
	cp $16
	jr z, jr_006_6920

	cp $36
	jr z, jr_006_6920

	cp $d2
	jr nz, jr_006_6926

jr_006_6920:
	call IncrementEntityState
	ld [hl], $02
	ret


jr_006_6926:
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $20
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $18
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $10
	call IncrementEntityState
	ret


Jump_06_693C::
	call GetEntityDirectionToLink_06
	ld a, e
	xor $01
	ldh [hLinkDirection], a
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $05
	ld [wLinkPoseLock], a
	call Call_06_69CD
	call UpdateEntityPosWithSpeed_06
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_695f

	call IncrementEntityState
	ret


jr_006_695f:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $fc
	call AddEntityZSpeedToPos_06
	call PlayPeriodicNoiseSfx
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_006_6981

	ld a, $00
	ld hl, wEntitySpeedY
	call Call_06_6A36
	ld a, $00
	ld hl, wEntitySpeedX
	call Call_06_6A36

jr_006_6981:
	ret


Jump_06_6982::
	call ReturnIfNonInteractive_06
	call BlockLinkIfTouching_06
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

	ld a, [wDebugToggle]
	and a
	ret nz

	ldh a, [hMapRoom]
	cp $06
	jr nz, jr_006_69a0

	ld a, $cd
	call OpenDialog
	jr jr_006_69a3

jr_006_69a0:
	call OpenRoomDialog

jr_006_69a3:
	ld a, $19
	ld [wDialogSfx], a
	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $10
	ret


Jump_06_69B1::
	call ReturnIfNonInteractive_06
	ldh a, [hMapRoom]
	cp $06
	jr z, jr_006_69c2

	call GetEntityTimer
	jr nz, Call_06_69CD

	call IncrementEntityState

jr_006_69c2:
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld hl, wRoomStatus
	add hl, de
	set 5, [hl]
	ret


Call_06_69CD::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ldh a, [hFrameCounter]
	rra
	rra
	and $02
	call SetEntitySpriteVariant
	ret


Jump_06_69DB::
	call ReturnIfNonInteractive_06
	call Call_06_69CD
	call UpdateEntityPosWithSpeed_06
	call CrowRemoveOffscreen
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $04
	call AddEntityZSpeedToPos_06
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_6a10

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrack], a
	ld a, [wActivePowerUp]
	and a
	jr z, jr_006_6a0f

	ld a, $49
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrackAlt], a

jr_006_6a0f:
	ret


jr_006_6a10:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_006_6a1a

	ld a, $05
	ldh [hNoiseSfx], a

jr_006_6a1a:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_006_6a41

	ld a, $20
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	call Call_06_6A36
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX

Call_06_6A36::
	add hl, bc
	sub [hl]
	jr z, jr_006_6a41

	bit 7, a
	jr z, jr_006_6a40

	dec [hl]
	dec [hl]

jr_006_6a40:
	inc [hl]

jr_006_6a41:
	ret


	db $78, $00, $78, $20, $7a, $00, $7a, $20, $00, $f8, $7c, $00, $00, $00, $7e, $00
	db $00, $08, $7e, $20, $00, $10, $7c, $20

Call_06_6A5A::
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nc, jr_006_6a66

	ld de, $6a42
	jp DrawEntity16x16


jr_006_6a66:
	ld hl, $6a4a
	ld c, $04
	call DrawEntitySprites
	ld a, $04
	call ReserveOAMEntriesFar
	ldh a, [hMapRoom]
	cp $08
	jr z, jr_006_6a7d

	call DrawEntityShadow
	ret


jr_006_6a7d:
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 4, [hl]
	ret


	db $50, $00, $52, $00

Call_06_6A88::
	ldh a, [hActiveEntityDrawY]
	sub $05
	ldh [hActiveEntityDrawY], a
	ld de, $6a84
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ShouldLinkTalkToEntity_06
	ret nc

	ld e, $fd
	ldh a, [hMapRoom]
	cp $a9
	jp z, Jump_006_6b98

	ld e, $41
	ld a, [$daa9]
	and $20
	jp z, Jump_006_6b98

	ld e, $46
	ld a, [wDungeonFlags]
	and $02
	jp z, Jump_006_6b98

	ld e, $42
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp z, Jump_006_6b98

	ld e, $43
	ld a, [wHasInstrument2]
	and $02
	jp z, Jump_006_6b98

	ld e, $44
	ld a, [wIsBowWowFollowingLink]
	cp $01
	jp z, Jump_006_6b9e

	ld e, $44
	ld a, [wRichardQuest]
	cp $02
	jp nz, Jump_006_6b98

	ld e, $45
	ld a, [wTradeSequenceItem]
	cp $05
	jp c, Jump_006_6b98

	ld e, $47
	ld a, [wGoldenLeaves]
	cp $05
	jp c, Jump_006_6b98

	ld e, $48
	jp z, Jump_006_6b98

	cp $06
	jp nz, Jump_006_6b98

	ld e, $49
	ld a, [$db67]
	and $02
	jp z, Jump_006_6b98

	ld e, $4a
	ld a, [$db12]
	and a
	jp z, Jump_006_6b98

	ld e, $40
	ld a, [$db68]
	and $02
	jp z, Jump_006_6b9e

	ld a, [wIsGhostFollowingLink]
	and a
	jr z, jr_006_6b2a

	ld e, $4b
	ld a, [$d9e3]
	and $40
	jr z, jr_006_6b98

jr_006_6b2a:
	ld e, $4c
	ld a, [$db69]
	and $02
	jr z, jr_006_6b98

	ld e, $45
	ld a, [wOcarinaSongFlags]
	and $01
	jp z, Jump_006_6b9e

	ld e, $4d
	ld a, [$db6a]
	and $02
	jr z, jr_006_6b98

	ld e, $4e
	ld a, [wIsRoosterFollowingLink]
	and a
	jr z, jr_006_6b59

	ld e, $46
	ld a, [$db14]
	and a
	jp z, Jump_006_6b9e

	ld e, $41

jr_006_6b59:
	ld a, [wDungeon7Flags]
	and $02
	jr nz, jr_006_6b67

	ld a, e
	cp $4e
	jr z, jr_006_6b98

	jr jr_006_6b9e

jr_006_6b67:
	ld e, $4f
	ld a, [$d810]
	and $30
	jr z, jr_006_6b98

	ld e, $48
	ld a, [$db6c]
	and $02
	jr z, jr_006_6b9e

	ld e, $42
	ld a, [$d806]
	and $30
	jr z, jr_006_6b9e

	ld e, $43
	ld a, [$da74]
	and $40
	jr z, jr_006_6b9e

	ld e, $47
	ld a, [wSwordLevel]
	cp $02
	jr c, jr_006_6b9e

	ld e, $48
	jr jr_006_6b9e

Jump_006_6b98:
jr_006_6b98:
	ld a, e
	call OpenDialogTable1
	jr jr_006_6ba2

Jump_006_6b9e:
jr_006_6b9e:
	ld a, e
	call OpenDialogTable2

jr_006_6ba2:
	ld hl, $daa9
	set 5, [hl]
	ret


	db $5e, $00, $5e, $40, $04, $fc, $03, $fd, $02, $fe, $05, $fa

Call_06_6BB4::
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr nz, jr_006_6bc0

	ldh a, [hActiveEntityDrawY]
	sub $00
	ldh [hActiveEntityDrawY], a

jr_006_6bc0:
	ld de, $6ba8
	call DrawEntity8x16
	call ReturnIfNonInteractive_06
	ld a, c
	sla a
	sla a
	sla a
	ld hl, hFrameCounter
	add [hl]
	ldh [hActiveEntityState], a
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call UpdateEntityPosWithSpeed_06
	ldh a, [hActiveEntityState]
	and $1f
	jr nz, jr_006_6bfd

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $6bac
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

jr_006_6bfd:
	ldh a, [hActiveEntityState]
	add $10
	and $1f
	jr nz, jr_006_6c1b

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $6bac
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_006_6c1b:
	ldh a, [hActiveEntityState]
	and $3f
	jr nz, jr_006_6c57

	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, [wSingingMarinSlot]
	cp $ff
	jr z, jr_006_6c3e

	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a

jr_006_6c3e:
	ld a, $02
	call GetVectorTowardsLink
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	ldh a, [hMultiPurpose0]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a

jr_006_6c57:
	ret


Call_06_6C58::
	ld a, c
	ld [wSmasherSlot], a
	ldh a, [hMapId]
	cp $07
	jr nz, jr_006_6c66

	ld a, $10
	ldh [hActiveEntityTileOffset], a

jr_006_6c66:
	call Call_06_6E6C
	call Call_3F12
	call ConfineLinkToArena
	ldh a, [hActiveEntityStatus]
	cp $05
	jr z, jr_006_6cca

	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $80
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_6C81::
	dw Jump_06_6C85
	dw Jump_06_6C96

Jump_06_6C85::
	call GetEntityTimer
	ld [hl], $ff
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ret


Jump_06_6C96::
	call GetEntityTimer
	jp z, Jump_006_6ca9

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
	cp $80
	jr nc, jr_006_6ca8

	call MinibossExplosions

jr_006_6ca8:
	ret


Jump_006_6ca9:
	call SelectAreaMusicFar
	call Call_3F7A
	ldh a, [hMapId]
	cp $07
	ret z

MarkMinibossBeaten:
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_006_6cc3

	cp $06
	jr c, jr_006_6cc3

	inc d

jr_006_6cc3:
	ld hl, $d900
	add hl, de
	set 5, [hl]
	ret


jr_006_6cca:
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call EntityCheckHits
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6cef

	ld e, $00
	and $80
	jr nz, jr_006_6cea

	ld e, $03

jr_006_6cea:
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

jr_006_6cef:
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	nop
	nop
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_006_6d14

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	ld [hl], b
	cp $f2
	jr nc, jr_006_6d14

	ld a, $20
	ldh [hJingle], a

jr_006_6d14:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_6D17::
	dw Jump_06_6D1F
	dw Jump_06_6D60
	dw Jump_06_6D91
	dw Jump_06_6D9A

Jump_06_6D1F::
	call GetEntityTimer
	jr nz, jr_006_6d5f

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	ld e, $08
	bit 7, a
	jr nz, jr_006_6d38

	ld e, $f8

jr_006_6d38:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	add $10
	cp $20
	jr nc, jr_006_6d4c

	call GetEntityTimer
	ld [hl], $18
	call IncrementEntityState
	ret


jr_006_6d4c:
	call AddEntitySpeedToPos_06
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_6d5a

	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c

jr_006_6d5a:
	ld a, $01
	call SetEntitySpriteVariant

jr_006_6d5f:
	ret


Jump_06_6D60::
	call GetEntityTimer
	jr nz, jr_006_6d90

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $10
	jr nz, jr_006_6d71

	ld a, $f0

jr_006_6d71:
	push af
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntitySpeedX
	add hl, de
	pop af
	ld [hl], a
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
	call GetEntityTimer
	ld [hl], $20
	call IncrementEntityState
	ld a, $00
	call SetEntitySpriteVariant

jr_006_6d90:
	ret


Jump_06_6D91::
	call GetEntityTimer
	jr nz, jr_006_6d99

	call IncrementEntityState

jr_006_6d99:
	ret


Jump_06_6D9A::
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $08
	ld a, $01
	jr c, jr_006_6da6

	inc a

jr_006_6da6:
	call SetEntitySpriteVariant
	call GetEntityTimer
	cp $01
	jr z, jr_006_6dc0

	cp $00
	jp nz, Jump_006_6e0b

	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_6df0

	call GetEntityTimer
	ld [hl], $10
	ret


jr_006_6dc0:
	ld e, $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $19
	ldh a, [hMultiPurposeH]
	cp $05
	jr nc, jr_006_6dd2

	ld e, $14
	ld [hl], $16

jr_006_6dd2:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, e
	jr nz, jr_006_6ddd

	cpl
	inc a

jr_006_6ddd:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ldh a, [hActiveEntityDrawY]
	cp $50
	ld a, e
	jr c, jr_006_6deb

	cpl
	inc a

jr_006_6deb:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_006_6df0:
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_6e0b

	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer
	ld [hl], $08
	call ClearEntitySpeed

Jump_006_6e0b:
jr_006_6e0b:
	ret


	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $f0, $00, $6e, $20
	db $00, $f8, $66, $00, $00, $00, $68, $00, $00, $08, $6a, $00, $f0, $00, $6e, $00
	db $00, $f8, $66, $00, $00, $00, $68, $00, $00, $08, $6a, $00, $f0, $06, $6e, $20
	db $00, $00, $64, $20, $00, $08, $62, $20, $00, $10, $60, $20, $f0, $08, $6e, $00
	db $00, $00, $6a, $20, $00, $08, $68, $20, $00, $10, $66, $20, $f0, $08, $6e, $20
	db $00, $00, $6a, $20, $00, $08, $68, $20, $00, $10, $66, $20, $f0, $02, $6e, $00

Call_06_6E6C::
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $6e0c
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ld a, $04
	call ReserveOAMEntriesFar
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6ec5

	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_006_6ec5

	ld a, [wOAMNextIndex]
	ld e, a
	ld d, b
	ld hl, $c030
	add hl, de
	ldh a, [hActiveEntityY]
	add $0c
	ld [hli], a
	ldh a, [hActiveEntityX]
	add $02
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld a, $00
	ld [hli], a
	ldh a, [hActiveEntityY]
	add $0c
	ld [hli], a
	ldh a, [hActiveEntityX]
	add $04
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $02
	call ReserveOAMEntriesFar

jr_006_6ec5:
	ret


	db $6c, $00, $6c, $20, $6c, $40, $6c, $60, $70, $60, $50, $40, $30, $20

Call_06_6ED4::
	ldh a, [hMapId]
	cp $07
	jr nz, jr_006_6ede

	ld a, $10
	ldh [hActiveEntityTileOffset], a

jr_006_6ede:
	ldh a, [hRoomStatus]
	and $20
	jp nz, ClearEntityStatus_06

	ld a, c
	ld [wSmasherBallSlot], a
	call Call_06_6FDB
	call ReturnIfNonInteractive_06
	ld a, [wSmasherSlot]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $01
	ret z

	and a
	jr nz, jr_006_6f39

	call GetEntityTimer
	jr nz, jr_006_6f38

	ld [hl], $03
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ld e, [hl]
	inc [hl]
	ld a, [hl]
	cp $06
	jr nz, jr_006_6f2d

	call ClearEntityStatus_06
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $3f72
	add hl, de
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld a, [hl]
	ld hl, wRoomDefeatedEntityBits
	add hl, de
	or [hl]
	ld [hl], a

jr_006_6f2d:
	ld d, b
	ld hl, $6ece
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
	jp Jump_006_7029


jr_006_6f38:
	ret


jr_006_6f39:
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hLinkPositionZ]
	and a
	jr nz, jr_006_6f44

	call EntityCheckHits

jr_006_6f44:
	call AddEntitySpeedToPos_06
	call EntityCheckWalls
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6f77

	bit 7, a
	jr z, jr_006_6f58

	cpl
	inc a

jr_006_6f58:
	ld e, $04
	cp $08
	jr nc, jr_006_6f60

	ld e, $08

jr_006_6f60:
	cp $04
	jr nc, jr_006_6f66

	ld e, $10

jr_006_6f66:
	cp $02
	jr nc, jr_006_6f6c

	ld e, $20

jr_006_6f6c:
	ld d, b
	ldh a, [hFrameCounter]
	and e
	jr z, jr_006_6f73

	inc d

jr_006_6f73:
	ld a, d
	call SetEntitySpriteVariant

jr_006_6f77:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_6F7A::
	dw Jump_06_6F80
	dw Jump_06_6F81
	dw Jump_06_6FB5

Jump_06_6F80::
	ret


Jump_06_6F81::
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_6fa4

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	inc a
	ld [hl], a
	ld a, $20
	ld [wBumpShakeTimer], a
	xor a
	ld [wBumpShakeAxis], a
	ld a, $0b
	ldh [hJingle], a
	call IncrementEntityState

jr_006_6fa4:
	ld a, [wSongShowTimer]
	inc a
	cp $09
	jr c, jr_006_6fb1

	ld a, $1a
	ldh [hWaveSfx], a
	xor a

jr_006_6fb1:
	ld [wSongShowTimer], a
	ret


Jump_06_6FB5::
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_006_6fca

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6fcb

	and $80
	jr z, jr_006_6fc9

	inc [hl]
	inc [hl]

jr_006_6fc9:
	dec [hl]

jr_006_6fca:
	ret


jr_006_6fcb:
	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer
	ld [hl], $50
	ret


	db $80, $70, $60, $50, $40, $30

Call_06_6FDB::
	ld a, $20
	ldh [hActiveEntityDrawY], a

jr_006_6fdf:
	ld de, $6ec6
	call DrawEntity16x16
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hActiveEntityDrawY], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6fd5
	add hl, de
	cp [hl]
	jr nz, jr_006_6fdf

	call LoadEntityPosition
	ret


MinibossExplosions::
	and $07
	jr nz, jr_006_701d

	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
	call GetRandomByte
	and $1f
	sub $14
	ld e, a
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	call Call_06_701E

jr_006_701d:
	ret


Call_06_701E::
	call ReturnIfGamePaused_06
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a

Jump_006_7029:
	ld a, $02
	call AddTransientVfx
	ld a, $13
	ldh [hNoiseSfx], a
	ret


	db $3e, $36, $cd, $01, $3c, $f0, $d7, $21, $00, $c2, $19, $77, $f0, $d8, $21, $10
	db $c2, $19, $77, $f0, $f9, $a7, $28, $08, $21, $50, $c2, $09, $36, $f0, $18, $0c
	db $21, $20, $c3, $19, $36, $10, $21, $10, $c3, $19, $36, $08, $cd, $e5, $65, $cd
	db $d7, $08, $c9

Call_06_7066::
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_7069::
	dw Jump_06_706F
	dw Jump_06_70CE
	dw Jump_06_716D

Jump_06_706F::
	call GetEntityXDistanceToLink_06
	add $0e
	cp $1c
	jr nc, jr_006_70bd

	call GetEntityYDistanceToLink_06
	add $0c
	cp $18
	jr nc, jr_006_70bd

	ldh a, [hLinkDirection]
	and a
	jr nz, jr_006_70bd

	ld a, [wLinkCollisionFlags]
	and a
	jr z, jr_006_70bd

	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $a0
	ld a, $01
	ldh [hLinkPositionZ], a
	ld a, $02
	ld [wIsLinkInTheAir], a
	ld a, $12
	ldh [hLinkSpeedZ], a
	ld a, $0c
	ldh [hLinkSpeedX], a
	xor a
	ldh [hLinkSpeedY], a
	ld a, $00
	ldh [hLinkDirection], a
	ld a, $01
	ld [wIsJumpingDownLedge], a
	ld a, $1e
	ld [wMusicTrackToPlay], a
	xor a
	ld [wTransitionSequenceCounter], a
	ld [wTransitionFrameCounter], a

jr_006_70bd:
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $98, $42, $98, $50, $99, $90, $99, $82

Jump_06_70CE::
	ld a, [wIsLinkInTheAir]
	and a
	jp nz, Jump_006_716c

	call GetEntityTimer
	jr nz, jr_006_70ec

	ld a, $01
	ld [wTransitionGfx], a
	xor a
	ld [wTransitionGfxFrameCount], a
	ld a, $08
	ld [wWavePaletteStep], a
	call IncrementEntityState
	xor a

jr_006_70ec:
	push af
	cp $80
	jr nc, jr_006_7144

	push af
	and $1f
	jr nz, jr_006_7107

	ld a, [wTransitionSequenceCounter]
	cp $02
	jr z, jr_006_7107

	ld a, $03
	ld [wTransitionFrameCounter], a
	push bc
	call FadePalettesToWhite
	pop bc

jr_006_7107:
	pop af
	and $0f
	jr nz, jr_006_7144

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_006_7144

	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, b
	add $05
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, de
	push hl
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	inc [hl]
	sla a
	ld e, a
	ld d, b
	ld hl, $70c6
	add hl, de
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, $64
	ld [hli], a
	ld a, $65
	ld [hli], a
	ld [hl], b

jr_006_7144:
	pop af
	ld e, $00
	cp $80
	jr c, jr_006_714c

	inc e

jr_006_714c:
	ld a, e

Call_06_714D::
	ldh [hActiveEntitySpriteVariant], a
	ld a, $58
	ldh [hActiveEntityX], a
	ldh [hLinkX], a
	ld a, $44
	ldh [hActiveEntityDrawY], a
	ldh [hLinkY], a
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $ff
	ldh [hLinkAnimationState], a
	ld de, $70be
	call DrawEntity16x16
	call LoadEntityPosition

Jump_006_716c:
	ret


Jump_06_716D::
	xor a
	call Call_06_714D
	ld a, [wTransitionGfx]
	and a
	jr nz, jr_006_7192

	xor a
	ldh [hLinkAnimationState], a
	ld hl, wWarpType
	ld a, $01
	ld [hli], a
	ldh a, [hMapId]
	ld [hli], a
	ld a, $ce
	ld [hli], a
	ld a, $50
	ld [hli], a
	ld a, $7c
	ld [hl], a
	call ClearEntityStatus_06
	jp StartScreenFadeOut


jr_006_7192:
	ret


	db $f0, $fc, $50, $00, $f0, $04, $52, $00, $f0, $0c, $54, $00, $00, $fc, $56, $00
	db $00, $04, $58, $00, $00, $0c, $5a, $00, $f0, $fc, $50, $00, $f0, $04, $52, $00
	db $f0, $0c, $54, $00, $00, $fc, $5c, $00, $00, $04, $58, $00, $00, $0c, $5e, $00
	db $a8, $10, $01, $ff, $18, $e8

Call_06_71C9::
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_006_7235

	ld hl, wEntityStatus
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	and a
	jp z, ClearEntityStatus_06

	ld a, [wSmasherSlot]
	ldh [hActiveEntitySpriteVariant], a
	ld de, $71c3
	call DrawEntity8x16
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_006_7231

	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $71c5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $71c7
	add hl, de
	cp [hl]
	jr nz, jr_006_7211

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_006_7211:
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $71c5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $71c7
	add hl, de
	cp [hl]
	jr nz, jr_006_7231

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_006_7231:
	call UpdateEntityPosWithSpeed_06
	ret


Jump_006_7235:
	ld hl, $7193
	ldh a, [hFrameCounter]
	and $08
	jr z, jr_006_7241

	ld hl, $71ab

jr_006_7241:
	ld c, $06
	call DrawEntitySprites
	ld a, $06
	call ReserveOAMEntriesFar
	call DrawEntityShadow
	ld e, $fe
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $40
	jr z, jr_006_725c

	ld e, $02

jr_006_725c:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], e
	call AddEntityZSpeedToPos_06
	call ReturnIfNonInteractive_06
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_726A::
	dw Jump_06_7270
	dw Jump_06_729A
	dw Jump_06_7306

Jump_06_7270::
	xor a
	ld [wSmasherSlot], a
	ld a, c
	ld [wSmasherBallSlot], a
	ldh a, [hLinkX]
	sub $50
	add $08
	cp $10
	jr nc, jr_006_7299

	ldh a, [hLinkY]
	sub $58
	add $08
	cp $10
	jr nc, jr_006_7299

	call IncrementEntityState
	call GetEntityDropTimer
	ld [hl], $48
	ld a, $24
	call OpenDialog

jr_006_7299:
	ret


Jump_06_729A::
	call GetEntityDropTimer
	jr nz, jr_006_72ac

	call GetEntityTimer
	ld [hl], $48
	call IncrementEntityState
	ld a, $26
	ldh [hJingle], a
	ret


jr_006_72ac:
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $1a
	ldh [hJingle], a
	call ReturnIfNonInteractive_06
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_72cf

	ld [hl], $01
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $04
	jr c, jr_006_72cf

	ld a, $04
	ld [wAddHealthBuffer], a

jr_006_72cf:
	call GetEntityTimer1
	jr nz, jr_006_7305

	ld [hl], $13
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $0a
	jr z, jr_006_7305

	inc [hl]
	ld a, $84
	call SpawnEntity
	jr c, jr_006_7305

	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	add $00
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $0e
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $e8

jr_006_7305:
	ret


Jump_06_7306::
	call GetEntityTimer
	jp z, ClearEntityStatus_06

	ldh a, [hFrameCounter]
	and $02
	ld a, $00
	jr z, jr_006_7316

	ld a, $ff

jr_006_7316:
	ld [wSmasherSlot], a
	call SetEntitySpriteVariant
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


	db $68, $00, $6a, $00, $64, $00, $66, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20
	db $66, $20, $64, $20, $6e, $20, $6c, $20

Call_06_7339::
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	ldh [hActiveEntitySpriteVariant], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_7357

	and $80
	ld a, $00
	jr nz, jr_006_7352

	ld a, $03

jr_006_7352:
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_006_7357:
	ld de, $7321
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	ld a, [wIsIndoor]
	and a
	jp z, Jump_006_7467

	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_006_7380

	ld [hl], b
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b

jr_006_7380:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_7383::
	dw Jump_06_7391
	dw Jump_06_73D7
	dw Jump_06_7407

	db $02, $06, $08, $06, $fe, $fa, $f8, $fa

Jump_06_7391::
	call Call_06_742A
	xor a
	call SetEntitySpriteVariant
	call GetEntityTimer
	jr nz, jr_006_73d4

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $7389
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
	ld hl, $7389
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
	call IncrementEntityState

jr_006_73d4:
	jp Jump_006_73fc


Jump_06_73D7::
	call Call_06_742A
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_73fc

	call GetEntityTimer
	jr nz, jr_006_73f1

	ld [hl], $30
	call IncrementEntityState
	ld [hl], b
	ret


jr_006_73f1:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

Jump_006_73fc:
jr_006_73fc:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_06_7407::
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_006_7418

	ld hl, wEntitySpeedZ
	add hl, bc
	inc [hl]

jr_006_7418:
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_7421

	call IncrementEntityState
	ld [hl], b

jr_006_7421:
	ldh a, [hFrameCounter]
	rra
	and $02
	call SetEntitySpriteVariant
	ret


Call_06_742A::
	ld a, [wSwordAnimationState]
	cp $02
	jr nz, jr_006_7466

	call GetEntityXDistanceToLink_06
	add $18
	cp $30
	jr nc, jr_006_7466

	call GetEntityYDistanceToLink_06
	add $18
	cp $30
	jr nc, jr_006_7466

	call IncrementEntityState
	ld [hl], $02
	ld a, $10
	call GetVectorTowardsLink
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
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c
	pop af

jr_006_7466:
	ret


Jump_006_7467:
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20

Call_06_7470::
	ld a, [wOcarinaSongState]
	cp $01
	jr nz, jr_006_74a2

	ld a, [wOcarinaSongFlags]
	and $04
	jr z, jr_006_74a2

	ld a, [wSelectedSong]
	and a
	jr nz, jr_006_74a2

	ldh a, [hActiveEntityStatus]
	cp $01
	jr z, jr_006_74a2

	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $04
	ld hl, hNoiseSfx
	ld [hl], $13
	ret


jr_006_74a2:
	ld de, $7468
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call UpdateEntityPosWithSpeed_06
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $01
	push hl
	call EntityCheckWalls
	pop hl
	ld [hl], b
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	and $01
	rst $00

JumpTable_06_74C5::
	dw Jump_06_74D5
	dw Jump_06_751A

	db $08, $08, $f8, $f8, $04, $fc, $fc, $04, $fc, $04, $08, $f8

Jump_06_74D5::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $01
	call GetEntityTimer
	jr nz, jr_006_7519

	call IncrementEntityState
	call GetRandomByte
	and $07
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $07
	cp $06
	jr c, jr_006_74ff

	ld a, $0a
	call SetEntitySpeedTowardsLink
	jr jr_006_7515

jr_006_74ff:
	ld e, a
	ld d, b
	ld hl, $74c9
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $74cf
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_006_7515:
	xor a
	call SetEntitySpriteVariant

jr_006_7519:
	ret


Jump_06_751A::
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_006_753e

	xor a
	ld [hl], a
	call IncrementEntityState
	call GetEntityTimer
	call GetRandomByte
	and $0f
	add $18
	ld [hl], a
	call ClearEntitySpeed

jr_006_753e:
	ret


	db $60, $00, $62, $00, $64, $00, $66, $00

Call_06_7547::
	ld de, $753f
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	xor a
	ldh [hBGTilesRequestCopy], a
	call EntityCheckWeaponHits
	call EntityTouchesLink
	jr nc, jr_006_756b

	ld a, $01
	ldh [hBGTilesRequestCopy], a
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, jr_006_756b

	call RestoreLinkPosition

jr_006_756b:
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_7574::
	dw Jump_06_757A
	dw Jump_06_758E
	dw Jump_06_75C4

Jump_06_757A::
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_758d

	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $30
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $18

jr_006_758d:
	ret


Jump_06_758E::
	call GetEntityTimer
	jr nz, jr_006_75ac

	call IncrementEntityState
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
	call ClearEntitySpeed
	ret


jr_006_75ac:
	ld e, $08
	and $04
	jr z, jr_006_75b4

	ld e, $f8

jr_006_75b4:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	ret


	db $f8, $fa, $00, $06, $08, $06, $00, $fa, $f8, $fa

Jump_06_75C4::
	call GetEntityTimer
	jr nz, jr_006_75e9

	call GetRandomByte
	and $3f
	add $20
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $75bc
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $75ba
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_006_75e9:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


	db $50, $00, $50, $20, $20, $e0, $00, $00, $f8, $08, $00, $00, $00, $00, $e0, $20
	db $00, $00, $08, $f8, $30, $20

Call_06_760B::
	ld a, $01
	ldh [$ffbe], a
	ld de, $75f5
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_7621::
	dw Jump_06_7629
	dw Jump_06_763A
	dw Jump_06_769D
	dw Jump_06_76BE

Jump_06_7629::
	ldh a, [hActiveEntityX]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	jp IncrementEntityState


Jump_06_763A::
	call GetEntityTimer
	jr nz, jr_006_7694

	call ClearEntitySpeed
	call GetEntityYDistanceToLink_06
	add $12
	cp $24
	jr nc, jr_006_7662

	call GetEntityXDistanceToLink_06
	ld d, b
	ld hl, $75f9
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld e, $18
	jr jr_006_7680

jr_006_7662:
	call GetEntityXDistanceToLink_06
	add $12
	cp $24
	jr nc, jr_006_7694

	call GetEntityYDistanceToLink_06
	ld d, b
	ld hl, $7601
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld e, $10

jr_006_7680:
	call GetEntityTimer
	ld [hl], e
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr z, jr_006_7695

	call GetEntityTimer
	ld [hl], b

jr_006_7694:
	ret


jr_006_7695:
	ld a, $0a
	ldh [hNoiseSfx], a
	call IncrementEntityState
	ret


Jump_06_769D::
	call UpdateEntityPosWithSpeed_06
	call GetEntityTimer
	jr nz, jr_006_76b1

jr_006_76a5:
	ld a, $07
	ldh [hJingle], a
	call GetEntityTimer
	ld [hl], $20
	jp IncrementEntityState


jr_006_76b1:
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_006_76a5

	ret


Jump_06_76BE::
	call GetEntityTimer
	jr nz, jr_006_7702

	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $75fd
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $7605
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call UpdateEntityPosWithSpeed_06
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
	jr nz, jr_006_7702

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jr nz, jr_006_7702

	call GetEntityTimer
	ld [hl], $20
	call IncrementEntityState
	ld [hl], $01

jr_006_7702:
	ret


	db $6e, $00, $6e, $20, $66, $20, $64, $20, $64, $00, $66, $00, $62, $00, $62, $20
	db $60, $00, $60, $20, $08, $f8, $00, $00, $00, $00, $f8, $08, $20, $e0, $00, $00
	db $00, $00, $e0, $20

Call_06_7727::
	ld de, $7703
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_773F::
	dw Jump_06_7747
	dw Jump_06_775F
	dw Jump_06_778F
	dw Jump_06_77BD

Jump_06_7747::
	ld hl, wEntityTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_775d

	call IncrementEntityState
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $01
	call GetEntityTimer1
	ld [hl], $20

jr_006_775d:
	jr jr_006_777e

Jump_06_775F::
	call GetEntityTimer1
	jr nz, jr_006_7779

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], $30
	call Call_06_7839
	ret


jr_006_7779:
	ld a, [hl]
	and $02
	jr nz, jr_006_7787

jr_006_777e:
	ld a, $ff
	call SetEntitySpriteVariant
	call Call_06_7839
	ret


jr_006_7787:
	xor a
	call SetEntitySpriteVariant
	call Call_06_7839
	ret


Jump_06_778F::
	xor a
	call SetEntitySpriteVariant
	call GetEntityTimer1
	cp $02
	jr nc, jr_006_77b9

	ld a, [hl]
	cp $01
	jr z, jr_006_77a5

	ld [hl], $18
	call Call_06_7839
	ret


jr_006_77a5:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	add [hl]
	ld [hl], a
	cp $01
	jr nz, jr_006_77b9

	call GetEntityTimer1
	ld [hl], $20

jr_006_77b9:
	call Call_06_7839
	ret


Jump_06_77BD::
	call EntityCheckHits
	call GetEntityTimer1
	cp $28
	jr z, jr_006_77ed

	cp $02
	jr nc, jr_006_7831

	ld a, [hl]
	cp $01
	jr z, jr_006_77e1

	ld [hl], $40
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	inc a
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	ret


jr_006_77e1:
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $ff
	ld hl, wEntityState
	add hl, bc
	dec [hl]
	ret


jr_006_77ed:
	ld a, $22
	call SpawnEntity
	jr c, jr_006_7831

	push bc
	ldh a, [hMultiPurpose2]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	ld c, a
	ld hl, $7717
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $771b
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, $771f
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $7723
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	pop bc
	ldh a, [hMultiPurpose2]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a

jr_006_7831:
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, $02
	ld [hl], a
	ret


Call_06_7839::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $42
	ret


	db $00, $d8, $60, $00, $00, $e0, $60, $20, $00, $28, $60, $00, $00, $30, $60, $20
	db $d8, $00, $62, $00, $d8, $08, $62, $20, $28, $00, $62, $00, $28, $08, $62, $20
	db $f0, $f0, $6a, $00, $f0, $f8, $6a, $60, $f0, $10, $6a, $40, $f0, $18, $6a, $20
	db $10, $f0, $6a, $40, $10, $f8, $6a, $20, $10, $10, $6a, $00, $10, $18, $6a, $60
	db $00, $e8, $60, $00, $00, $f0, $60, $20, $00, $18, $60, $00, $00, $20, $60, $20
	db $e8, $00, $62, $00, $e8, $08, $62, $20, $18, $00, $62, $00, $18, $08, $62, $20
	db $f0, $f0, $ff, $00, $f0, $f8, $ff, $00, $f0, $10, $ff, $00, $f0, $18, $ff, $00
	db $10, $f0, $ff, $00, $10, $f8, $ff, $00, $10, $10, $ff, $00, $10, $18, $ff, $00
	db $e0, $e0, $68, $00, $e0, $e8, $68, $60, $20, $e0, $68, $40, $20, $e8, $68, $20
	db $e0, $20, $68, $40, $e0, $28, $68, $20, $20, $20, $68, $00, $20, $28, $68, $60
	db $00, $f0, $64, $00, $00, $f8, $64, $20, $f0, $00, $66, $00, $f0, $08, $66, $20
	db $00, $10, $64, $00, $00, $18, $64, $20, $10, $00, $66, $00, $10, $08, $66, $20
	db $e8, $e8, $68, $00, $e8, $f0, $68, $60, $18, $e8, $68, $40, $18, $f0, $68, $20
	db $e8, $18, $68, $40, $e8, $20, $68, $20, $18, $18, $68, $00, $18, $20, $68, $60
	db $00, $f0, $ff, $00, $00, $f8, $ff, $20, $f0, $00, $ff, $00, $f0, $08, $ff, $20
	db $00, $10, $ff, $00, $00, $18, $ff, $20, $10, $00, $ff, $00, $10, $08, $ff, $20

Call_06_7940::
	call ReturnIfNonInteractive_06
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
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
	sla e
	rl d
	ld hl, $7840
	add hl, de
	ld c, $10
	call DrawEntitySprites
	ld a, $10
	call ReserveOAMEntriesFar
	ret


	db $5a, $00, $5a, $20, $5a, $10, $5a, $30

Call_06_797B::
	ld de, $7973
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call EntityCheckHits
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_006_79a0

	ld a, [hl]
	and $0c
	jr nz, jr_006_79aa

	jr jr_006_79b2

jr_006_79a0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jr jr_006_79b2

jr_006_79aa:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_006_79b2:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


	db $58, $00, $58, $20, $5a, $00, $5a, $20, $10, $f0, $10, $f0, $10, $10, $f0, $f0

Call_06_79CD::
	ld de, $79bd
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call EntityCheckHits
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_79ee

	call Call_06_7A83

jr_006_79ee:
	ld a, [hl]
	and $0c
	jr z, jr_006_79f6

	call Call_06_7A88

jr_006_79f6:
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_006_7a28

	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_006_7a1f

	xor a
	ld [hl], a
	call ClearEntitySpeed
	ld hl, wEntityState
	add hl, bc
	inc [hl]
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $10
	ld [hl], a
	ld a, $01
	call SetEntitySpriteVariant
	ret


jr_006_7a1f:
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ret


jr_006_7a28:
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $10
	srl a
	srl a
	srl a
	srl a
	call SetEntitySpriteVariant
	and a
	jr nz, jr_006_7a82

	call GetEntityTimer
	jr nz, jr_006_7a82

	call GetRandomByte
	and $07
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	call AddEntityZSpeedToPos_06
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $79c5
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $79c9
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $01
	jr z, jr_006_7a79

	ld a, $14
	call SetEntitySpeedTowardsLink

jr_006_7a79:
	ld hl, wEntityState
	add hl, bc
	xor a
	ld [hl], a
	call SetEntitySpriteVariant

jr_006_7a82:
	ret


Call_06_7A83::
	ld hl, wEntitySpeedX
	jr jr_006_7a8c

Call_06_7A88::
	ld hl, wEntitySpeedX
	add hl, bc

jr_006_7a8c:
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a
	ret


	db $62, $20, $60, $20, $66, $20, $64, $20, $60, $00, $62, $00, $64, $00, $66, $00
	db $68, $00, $68, $20, $6a, $00, $6a, $20, $6e, $20, $6c, $20, $6c, $00, $6e, $00

Call_06_7AB3::
	ld de, $7a93
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	call UpdateEntityPosWithSpeed_06
	call CrowRemoveOffscreen
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_7AC8::
	dw Jump_06_7ACC
	dw Jump_06_7B4B

Jump_06_7ACC::
	ld a, [wRoomEventCounter]
	and a
	jp nz, Jump_006_7b45

	call GetEntityTimer
	jr nz, jr_006_7b1b

	call GetEntityTimer1
	jr nz, jr_006_7b2c

	ld a, [wSwordAnimationState]
	cp $03
	jr z, jr_006_7b04

	call GetRandomByte
	xor c
	and $07
	add $06
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	call Call_06_7B86
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	call Call_06_7B86
	call EntityCheckContactDamage
	jr jr_006_7b33

jr_006_7b04:
	call GetEntityXDistanceToLink_06
	add $24
	cp $48
	jr nc, jr_006_7b33

	call GetEntityYDistanceToLink_06
	add $24
	cp $48
	jr nc, jr_006_7b33

	call GetEntityTimer
	ld [hl], $20

jr_006_7b1b:
	call ClearEntitySpeed
	call Call_06_7BBD
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_7b44

	call Call_06_7B99

jr_006_7b2c:
	call ClearEntitySpeed
	call Call_06_7BBD
	ret


jr_006_7b33:
	call GetEntityXDistanceToLink_06
	sla e
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	add e
	call SetEntitySpriteVariant

jr_006_7b44:
	ret


Jump_006_7b45:
	call IncrementEntityState
	ld [hl], $01
	ret


Jump_06_7B4B::
	ld a, [wRoomEventCounter]
	and a
	jr z, jr_006_7b81

	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $01
	call EntityCheckHits
	ld a, $04
	call GetVectorTowardsLink
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
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	add $04
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	ret


jr_006_7b81:
	call IncrementEntityState
	ld [hl], b
	ret


Call_06_7B86::
	add hl, bc
	sub [hl]
	jr z, jr_006_7b98

	bit 7, a
	jr z, jr_006_7b94

	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	jr jr_006_7b98

jr_006_7b94:
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_006_7b98:
	ret


Call_06_7B99::
	call GetEntityTimer1
	ld [hl], $20
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $00
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


Call_06_7BBD::
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	jr z, jr_006_7bd4

	call GetEntityXDistanceToLink_06
	srl e
	jr c, jr_006_7bd0

	ld a, $06
	jr jr_006_7bd6

jr_006_7bd0:
	ld a, $07
	jr jr_006_7bd6

jr_006_7bd4:
	ld a, $ff

jr_006_7bd6:
	call SetEntitySpriteVariant
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
	call GetEntityTimer
	cp $01
	jr nz, jr_006_7bea

	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]

jr_006_7bea:
	ret


	db $a6, $10, $8e, $10, $80, $10, $a6, $10, $a9, $10, $2a, $40, $2a, $60, $00, $fc
	db $22, $00, $00, $0c, $22, $20, $00, $fc, $22, $40, $00, $0c, $22, $60, $0f, $0f
	db $10, $11, $11, $11, $10, $0f, $00, $00, $01, $02, $02, $02, $01, $00

Call_06_7C19::
	ld hl, $7c09
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_006_7c24

	ld hl, $7c11

jr_006_7c24:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nz, jr_006_7c42

	ld de, $7be1
	call DrawEntity16x16
	jr jr_006_7c48

jr_006_7c42:
	ld de, $7beb
	call DrawEntity8x16

jr_006_7c48:
	ldh a, [hFrameCounter]
	and $08
	ld e, a
	ld d, b
	ld hl, $7bf9
	add hl, de
	ld c, $02
	call DrawEntitySprites
	ld a, $01
	call ReserveOAMEntriesFar
	call LoadEntityPosition
	call ReturnIfNonInteractive_06
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_006_7c6d

	ldh a, [hLinkPositionZ]
	cp $0c
	jr c, jr_006_7ca7

jr_006_7c6d:
	call EntityTouchesLink
	jr nc, jr_006_7ca7

	call Call_3F88
	call ClearEntityStatus_06
	ld a, $01
	ldh [hWaveSfx], a
	ldh a, [hActiveEntitySpriteVariant]
	rst $00

JumpTable_06_7C7F::
	dw Jump_06_7CA2
	dw Jump_06_7CA8
	dw Jump_06_7CB9
	dw Jump_06_7CA2
	dw Jump_06_7C8B
	dw Jump_06_7C98

Jump_06_7C8B::
	ld a, [wAddHealthBuffer]
	add $18
	jr nc, jr_006_7c94

	ld a, $ff

jr_006_7c94:
	ld [wAddHealthBuffer], a
	ret


Jump_06_7C98::
	ld a, [wArrowCount]
	add $10
	daa
	ld [wArrowCount], a
	ret


Jump_06_7CA2::
	ld a, $0a
	ld [wAddRupeeBufferLow], a

jr_006_7ca7:
	ret


Jump_06_7CA8::
	ld d, $0c
	call Call_3E95
	ld a, $0b
	ldh [hBGChangeRequest], a
	ld hl, wMaxMagicPowder
	ld de, wMagicPowderCount
	jr jr_006_7cbf

Jump_06_7CB9::
	ld hl, wMaxBombs
	ld de, wBombCount

jr_006_7cbf:
	ld a, [de]
	cp [hl]
	jr nc, jr_006_7ccb

	add $10
	daa
	cp [hl]
	jr c, jr_006_7cca

	ld a, [hl]

jr_006_7cca:
	ld [de], a

jr_006_7ccb:
	ret


	db $56, $00, $56, $20

Call_06_7CD0::
	call Call_06_7CDC
	ld de, $7ccc
	call DrawEntity8x16
	jp Jump_006_7d05


Call_06_7CDC::
	ldh a, [hMapId]
	cp $0a
	ret nz

	ldh a, [hMapRoom]
	cp $97
	jr z, jr_006_7cea

	cp $98
	ret nz

jr_006_7cea:
	ld a, [wTradeSceneState]
	and a
	ret z

	ld a, $ff
	ldh [hActiveEntitySpriteVariant], a
	ret


	db $52, $00, $52, $20, $54, $00, $54, $20

Call_06_7CFC::
	call Call_06_7CDC
	ld de, $7cf4
	call DrawEntity16x16

Jump_006_7d05:
	ld hl, wGelCount
	inc [hl]
	call ReturnIfNonInteractive_06
	call AddEntityZSpeedToPos_06
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_006_7d27

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_006_7d27:
	ldh a, [hActiveEntityType]
	cp $1b
	jr nz, jr_006_7d8e

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_006_7d8e

	ld [hl], b
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	push hl
	push af
	ld hl, wEntityType
	add hl, bc
	ld [hl], $1c
	call InitEntityPropertiesFar
	pop af
	pop hl
	ld [hl], a
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	call ClearEntitySpeed
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	ld a, $1c
	call SpawnEntity
	jr c, jr_006_7d8e

	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	ld hl, wEntityLoadOrder
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose0]
	add $08
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
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20

jr_006_7d8e:
	call ApplyRecoilIfNeeded_06
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7dab

	ldh a, [hActiveEntityState]
	and $01
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	dec a
	jr nz, jr_006_7dab

	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $08

jr_006_7dab:
	ldh a, [hActiveEntityState]
	cp $04
	jr z, jr_006_7dbc

	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7dbc

	call EntityCheckHits

jr_006_7dbc:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_06_7DBF::
	dw Jump_06_7DFC
	dw Jump_06_7DC9
	dw Jump_06_7E0F
	dw Jump_06_7E3C
	dw Jump_06_7E49

Jump_06_7DC9::
	call GetEntityTimer
	jr nz, Call_06_7DE6

	ld [hl], $10
	call ClearEntitySpeed
	call GetRandomByte
	and $0f
	jr nz, jr_006_7de2

	call GetEntityTimer
	ld [hl], $50
	jp IncrementEntityState


jr_006_7de2:
	call IncrementEntityState
	ld [hl], b

Call_06_7DE6::
	call UpdateEntityPosWithSpeed_06
	call GetEntityTimer1
	ret nz

	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $02
	call EntityCheckWalls
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ret


Jump_06_7DFC::
	call Call_06_7DE6
	call GetEntityTimer
	jr nz, jr_006_7e0e

	ld [hl], $07
	call IncrementEntityState
	ld a, $04
	call SetEntitySpeedTowardsLink

jr_006_7e0e:
	ret


Jump_06_7E0F::
	call GetEntityTimer
	jr nz, jr_006_7e23

	call IncrementEntityState
	ld a, $10
	call SetEntitySpeedTowardsLink
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	ret


jr_006_7e23:
	call GetEntityTimer
	ld hl, wEntitySpeedX
	add hl, bc
	and $04
	jr nz, jr_006_7e32

	ld [hl], $08
	jr jr_006_7e34

jr_006_7e32:
	ld [hl], $f8

jr_006_7e34:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	jp Call_06_7DE6


Jump_06_7E3C::
	call Call_06_7DE6
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_006_7e48

	call IncrementEntityState
	ld [hl], b

jr_006_7e48:
	ret


Jump_06_7E49::
	call GetEntityTimer
	jr nz, jr_006_7e6a

	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $30
	ld a, $10
	call SetEntitySpeedTowardsLink
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	ld hl, wEntityZ
	add hl, bc
	inc [hl]
	call IncrementEntityState
	ld [hl], $03
	ret


jr_006_7e6a:
	push af
	rra
	and $07
	sub $04
	ld e, a
	ldh a, [hLinkX]
	sub e
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	pop af
	rra
	rra
	and $07
	sub $04
	ld e, a
	ldh a, [hLinkY]
	sub e
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
	ld a, $01
	ld [wLinkSlowAnimation], a
	call EntityCheckWalls
	ldh a, [hJoypadPressed]
	and a
	jr z, jr_006_7eac

	call Call_06_7EA6
	call Call_06_7EA6
	call Call_06_7EA6

Call_06_7EA6::
	call GetEntityTimer
	jr z, jr_006_7eac

	dec [hl]

jr_006_7eac:
	ret


	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

Call_06_7EB5::
	ld de, $7ead
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call ApplyRecoilIfNeeded_06
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_7EC7::
	dw Jump_06_7ECB
	dw Jump_06_7EE5

Jump_06_7ECB::
	call GetEntityDropTimer
	jr nz, jr_006_7edf

	call EntityCheckContactDamage
	jr nc, jr_006_7edf

	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b

jr_006_7edf:
	call EntityCheckWeaponHits
	jp Jump_006_7f77


Jump_06_7EE5::
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_006_7f00

	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $08
	jr c, jr_006_7f00

	call GetEntityDropTimer
	ld [hl], $15
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
	ret


jr_006_7f00:
	ld a, $ff
	ldh [hLinkAnimationState], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7f2e

	ld hl, wItemB
	ld e, b

jr_006_7f10:
	ld a, [hl]
	cp $04
	jr nz, jr_006_7f27

	ld a, [wShieldLevel]
	cp $02
	jr nc, jr_006_7f2e

	ld [hl], b
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [wShieldLevel]
	ld [hl], a
	jr jr_006_7f2e

jr_006_7f27:
	inc hl
	inc e
	ld a, e
	cp $02
	jr nz, jr_006_7f10

jr_006_7f2e:
	ld a, [wLinkMotionState]
	cp $00
	ret nz

	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
	ldh a, [hActiveEntityY]
	ldh [hLinkY], a
	xor a
	ld [wIsLinkInTheAir], a
	ldh [hLinkPositionZ], a
	call Call_06_7FDF
	call Call_06_7FDF
	ret


	db $74, $00, $76, $00, $76, $20, $74, $20, $44, $00, $46, $00, $46, $20, $44, $20
	db $00, $08, $f8, $00, $f8, $08

Call_06_7F5F::
	ld de, $7f49
	ldh a, [hMapId]
	cp $07
	jr nz, jr_006_7f6b

	ld de, $7f51

jr_006_7f6b:
	call DrawEntity16x16
	call ReturnIfNonInteractive_06
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckHits

Jump_006_7f77:
	call UpdateEntityPosWithSpeed_06
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_006_7f95

	ld a, [hl]
	and $0c
	jr z, jr_006_7f9d

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jr jr_006_7f9d

jr_006_7f95:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a

jr_006_7f9d:
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7fac

	call GetRandomByte
	and $3f
	jr nz, jr_006_7fd9

jr_006_7fac:
	xor a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $7f59
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	and a
	jr nz, jr_006_7fd9

	call GetRandomByte
	and $01
	add $04
	ld e, a
	ld d, b
	ld hl, $7f59
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_006_7fd9:
	ld hl, wEntityState
	add hl, bc
	xor a
	ld [hl], a

Call_06_7FDF::
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	inc [hl]
	rra
	rra
	rra
	rra
	and $01
	jp SetEntitySpriteVariant


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff
