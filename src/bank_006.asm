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
;> DrawEntity16x16(slot, RichardSprites)                # draw the current frame (two 8x16 sprites)
	ld de, RichardSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if hFrameCounter & 0x1F == 0:            # every 32 frames: face Link
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .walk
;>     wEntityDirection[slot] = GetEntityDirectionToLink_06(slot)
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.walk
;> SetWalkingFrame_06(slot)
	call SetWalkingFrame_06
;> if wEntityPrivate1[slot] == 0:           # 1 once he has moved out of the way
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .dispatch
;>     BlockLinkIfTouching_06(slot)
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
	ld [wRoomStatus + $2C7], a
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
;> ClearEntityStatus_06(slot)
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
;>     return ClearEntityStatus_06(slot)
	jp nz, ClearEntityStatus_06

;> wEntityDropType[slot] = 0x3C
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c
;> wEntityLoadOrder[slot] = 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;> DrawEntity16x16(slot, MadBomberSprites)
	ld de, MadBomberSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)                              # count down the no-hit timer
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
;> wEntityX[slot] = mem[MadBomberHoleX + hole]
	ld hl, MadBomberHoleX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = mem[MadBomberHoleY + hole]
	ld hl, MadBomberHoleY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x20) < 0x40:              # Link within 32 pixels horizontally
	add $20
	cp $40
	jr nc, .rise

;>     dy, side = GetEntityYDistanceToLink_06(slot)
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
;> EntityCheckHits(slot)                              # contact damage and weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr nz, ThrowBombTowardsLink.setEntitySpriteVariant
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
	jr nz, ThrowBombTowardsLink.return

;> new, full = SpawnEntity(slot, 0x02)                    # spawn a bomb; hMultiPurpose0/1 = our x / y
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

.return
;> return
	ret


.setEntitySpriteVariant
;=@v
	and $20
	ld a, $03
	jr nz, .setEntitySpriteVariant2

	inc a

.setEntitySpriteVariant2
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
;@ per frame) on its height; hMultiPurposeG (here a scratch byte) is $80 on the frame it lands.
;@ test: skip draws sprites and calls banked helpers
AntiKirbyHandler::
;> AntiKirbyDraw(slot)
	call AntiKirbyDraw
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 3                 # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot] & 0x80    # landed: fell below the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:
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

;>     ClearEntitySpeed(slot)                          # stop
	call ClearEntitySpeed
;>     if wEntityDropTimer[slot] == 0:
	call GetEntityDropTimer
	jr nz, .newHop

;>         dx, side = GetEntityXDistanceToLink_06(slot)
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
;> if hMultiPurposeG:                    # just landed: hop again
	ldh a, [hMultiPurposeG]
	and a
	jr z, .move
;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

.move
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)                               # walls
	call EntityCheckWalls
;> wEntitySpriteVariant[slot] = (wEntityDirection[slot] * 2) & 6     # mouth closed
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rla
	and $06
	call SetEntitySpriteVariant
;> EntityCheckHits(slot)                               # contact damage and weapon hits
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
;>         dx, xside = GetEntityXDistanceToLink_06(slot)      # 0 Link to the right, 1 left
	call GetEntityXDistanceToLink_06
	push de
;>         dy, yside = GetEntityYDistanceToLink_06(slot)      # 2 Link above, 3 below
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
;>     wEntitySpeedX[slot] = mem[AntiKirbySpeedX + direction]
	ld hl, AntiKirbySpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[AntiKirbySpeedY + direction]
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
;> EntityCheckWeaponHits(slot)                               # weapon hits (no contact damage)
	call EntityCheckWeaponHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, AntiKirbyStopInhaling.setAntiKirbyInhaling

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


.setAntiKirbyInhaling
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

;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> if wEntityDirection[slot] & 1 != side:     # Link behind it
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and $01
	cp e
;>     return AntiKirbyMouthOpenFrame(slot)
	jr nz, AntiKirbyMouthOpenFrame

;> dx, side = GetEntityXDistanceToLink_06(slot)
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
;> dy, side = GetEntityYDistanceToLink_06(slot)
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

;> GetVectorTowardsLink(slot, 8)                              # hMultiPurpose0/1 = y / x speed towards Link
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
;> CheckLinkLeavesRoomFar()                               # Link's wall collisions
	call CheckLinkLeavesRoomFar
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

;>@l     if hMultiPurposeG and wEntityPrivate1[slot] == 0:     # landed for the first time
	ldh a, [hMultiPurposeG]
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

;>     DrawEntity16x16(slot, AntiKirbySprites)
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
;>     DrawEntityShadow(slot)                           # finish the multi-sprite draw
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

;> wEntityScratch2 = slot
	ld a, c
	ld [wEntityScratch2], a
;> if wEntityPrivate3[slot] == 0:           # first frame: make the ball
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .ready

;>     wEntityPrivate3[slot] = 1
	inc [hl]
;>     ball, full = SpawnEntity(slot, 0x92)
	ld a, $92
	call SpawnEntity
;>     wEntityScratch1 = ball
	ld a, e
	ld [wEntityScratch1], a
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
;> StartBossMusic(slot)                              # miniboss music
	call StartBossMusic
;> if hActiveEntityStatus != 5:             # defeated
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return MinibossDefeated(slot)
	jp nz, MinibossDefeated

;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)                              # contact damage
	call EntityCheckHits
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 3
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot] & 0x80     # scratch: landed this frame
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:
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
;> ball = wEntityScratch1
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
;> if wEntityState[ball] != 0:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $00
	jr nz, .wander
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
;> SetEntitySpeedTowardsLink(slot, 0x10)                          # speed towards the ball
	ld a, $10
	call SetEntitySpeedTowardsLink
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>@n if u8(dx + 0x0C) < 0x18 and u8(GetEntityYDistanceToLink_06(slot)[0] + 0x0C) < 0x18:
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
	ld a, [wEntityScratch1]
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

.wander
;=@wander
	call IncrementEntityState
;=@hop

;@ def SmasherHopFrame(slot: bc) -> hl
;@ path: boss/smasher
;@ Gives the Smasher a new hop (height speed $10) each time he lands and shows his standing frame
;@ for his facing (0 right, 1 left). Returns hl pointing at his wEntitySpriteVariant byte.
;@ test: skip part of the Smasher's state machine
SmasherHopFrame::
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
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
;> ball = wEntityScratch1
	ld a, [wEntityScratch1]
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
;>     wEntitySpeedX[slot] = mem[SmasherWalkSpeedX + direction]
	ld hl, SmasherWalkSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[SmasherWalkSpeedY + direction]
	ld hl, SmasherWalkSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.move
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
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
;> ball = wEntityScratch1
	push bc
	ld c, a
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
;>@px wEntityX[ball] = hActiveEntityX + mem[SmasherLiftBallX + step]
	ldh a, [hActiveEntityX]
	ld hl, SmasherLiftBallX
	add hl, bc
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@px
	ld [hl], a
;>@pz wEntityZ[ball] = wEntityZ[slot] - mem[SmasherLiftBallZ + step]
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
;>     ball = wEntityScratch1
	ld a, [wEntityScratch1]
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
;> SetEntitySpeedTowardsLink(slot, 4)                             # creep towards Link
	ld a, $04
	call SetEntitySpeedTowardsLink
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> SmasherArmsUpFrame(slot)
	call SmasherArmsUpFrame
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
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
;> DrawEntityShadow(slot)
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
;@ landing check, hMultiPurposeG (scratch) = landed this frame.
;@ test: skip draws sprites and calls banked helpers
SmasherBallHandler::
;> wEntityPhysicsFlags[slot] = 0x92
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $92
;> mem[0xC5D0 + slot] = 0xFF
	ld hl, wEntityLedgeDirection
	add hl, bc
	ld [hl], $ff
;> DrawEntity16x16(slot, SmasherBallSprites)
	ld de, SmasherBallSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)                              # hits from Link's weapons
	call EntityCheckWeaponHits
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06(slot)
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
;> hMultiPurposeG = hMultiPurposeH & 0x80
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:                   # hit the floor
	jr z, .walls

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     bounce = ~(((wEntitySpeedZ[slot] ^ 0x80) - 0x80) >> 1) & 0xFF      # about half the fall speed, upwards
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
;>     wEntitySpeedX[slot] = ((wEntitySpeedX[slot] ^ 0x80) - 0x80) >> 2
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	sra [hl]
;>     wEntitySpeedY[slot] = ((wEntitySpeedY[slot] ^ 0x80) - 0x80) >> 2
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
	sra [hl]

.walls
;> EntityCheckWalls(slot)
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
	jr z, SmasherBallSlowDown.checkEntityTouchesLink

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
	jr z, .checkEntityTouchesLink

;>@s     speed[slot] += 1 if speed[slot] & 0x80 else -1
	and $80
	jr z, .dec

	inc [hl]
	inc [hl]

.dec
;=@s
	dec [hl]

.checkEntityTouchesLink
;> if not EntityTouchesLink(slot):                      # Link does not touch it
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
;> smasher = wEntityScratch2
	ld a, [wEntityScratch2]
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
;> wEntitySpeedX[slot] = ((-wEntitySpeedX[slot] ^ 0x80) - 0x80) >> 1      # bounce back at half speed
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
;> wEntitySpeedY[slot] = ((-wEntitySpeedY[slot] ^ 0x80) - 0x80) >> 1
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
;> EntityCheckContactDamage(slot)                              # contact damage to Link
	call EntityCheckContactDamage
;> wEntityPhysicsFlags[slot] = 0x92
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $92

SmasherBallBounce:
;> if not hMultiPurposeG:              # still in the air
	ldh a, [hMultiPurposeG]
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
;>     axis[slot] = ((-axis[slot] ^ 0x80) - 0x80) >> 1
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
;> DrawEntity16x16(slot, ThreeOfAKindSprites)
	ld de, ThreeOfAKindSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
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
;> EntityCheckHits(slot)                              # contact damage and weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     ClearEntitySpeed(slot)                          # stop
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
;>     ClearEntitySpeed(slot)
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
;> EntityCheckHits(slot)
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
;>     wEntitySpeedX[slot] = mem[ThreeOfAKindSpeedX + direction]
	ld hl, ThreeOfAKindSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[ThreeOfAKindSpeedY + direction]
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
;> hMultiPurposeG = result             # scratch
	ld a, e
	ldh [hMultiPurposeG], a
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
	ldh a, [hMultiPurposeG]
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
;> DrawEntity16x16(slot, StalfosSprites)
	ld de, StalfosSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)                              # contact damage and weapon hits
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

;>     SetEntitySpeedTowardsLink(slot, 8)                         # walk towards Link
	ld a, $08
	call SetEntitySpeedTowardsLink

.near
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x1C) < 0x38:
	add $1c
	cp $38
	jr nc, .move

;>     dy, side = GetEntityYDistanceToLink_06(slot)
	call GetEntityYDistanceToLink_06
;>     if u8(dy + 0x1C) < 0x38:
	add $1c
	cp $38
	jr nc, .move

;>         wEntitySpeedZ[slot] = 0x28          # leap
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $28
;>         SetEntitySpeedTowardsLink(slot, 0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>         wEntityState[slot] += 1
	call IncrementEntityState

.move
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> AddEntityZSpeedToPos_06(slot)
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
;>     ClearEntitySpeed(slot)                          # stop moving
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

;> AddEntityZSpeedToPos_06(slot)
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
;> StartBossMusic(slot)                              # miniboss music
	call StartBossMusic
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckContactDamage(slot)                              # contact damage
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_06(slot)
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

;>@t1         front = mem[CueBallFrontDirection + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, CueBallFrontDirection
	add hl, de
;=@t1
	ld a, [hl]
;>         if GetEntityDirectionToLink_06(slot) != front:     # Link is not in front of it
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
;>     EntityCheckWeaponHits(slot)                          # weapon hits
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
;>     ClearEntitySpeed(slot)
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
;> ClearEntitySpeed(slot)
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
;> wEntitySpeedX[slot] = mem[CueBallSpeedX + direction]
	ld hl, CueBallSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[CueBallSpeedY + direction]
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
;> wEntitySpriteVariant[slot] = mem[CueBallFrames + step]
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
;>     hMultiPurposeG = cloud          # scratch
	ldh [hMultiPurposeG], a
;>     dust, full = SpawnEntity(slot, 0x8E)
	ld a, $8e
	call SpawnEntity
;>     if full:
;>         return
	jr c, .done

;>@t6     i = wEntityDirection[slot] * 2 | cloud
	push bc
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, hMultiPurposeG
;=@t6
	or [hl]
	ld c, a
;>@t7     wEntityX[dust] = hMultiPurpose0 + mem[CueBallDustX + i]
	ld hl, CueBallDustX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@t7
	ld [hl], a
;>@t8     wEntityY[dust] = hMultiPurpose1 + mem[CueBallDustY + i]
	ld hl, CueBallDustY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@t8
	ld [hl], a
;>     wEntitySpeedX[dust] = mem[CueBallDustSpeedX + i]
	ld hl, CueBallDustSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[dust] = mem[CueBallDustSpeedY + i]
	ld hl, CueBallDustSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[dust] = mem[CueBallDustFrames + i]
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
	ldh a, [hMultiPurposeG]
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
;> ClearEntitySpeed(slot)                              # but no movement
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
;> DrawEntity16x16(slot, CueBallDustSprites)
	ld de, CueBallDustSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

;> if wEntityTimer[slot] == 6:
	cp $06
	jr nz, .done

;>     UpdateEntityPosWithSpeed_06(slot)
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
;> DrawEntity16x16(slot, LeverGateSprites)
	ld de, LeverGateSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()               # (leaves hl at wInventoryAppearing, which is 0)
	call ReturnIfNonInteractive_06
;> if hLeverPullState == 2:                  # lever held still: height checked as 0
	ldh a, [hLeverPullState]
	cp $02
;>     pass                                   # on at LeverGatePushLink, below
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
;>     pass                                   # on at LeverGateBlockLink, below
	jr z, .floor

;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .push

;>     wEntityZ[slot] -= 1
	dec [hl]

.push
;> if wEntityZ[slot] < 4 and EntityTouchesLink(slot):   # low and touching Link: shove him away
	ld a, [hl]
	cp $04
	jr nc, .end

	call EntityTouchesLink
	jr nc, .ret

;>     wLinkPushedTimer = 8
	ld a, $08
	ld [wLinkPushedTimer], a
;>     GetVectorTowardsLink(slot, 0x10)                       # hMultiPurpose0/1 = y / x speed towards Link
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
;> if EntityTouchesLink(slot):
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
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)                              # contact damage and weapon hits
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
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
	jr nz, HardhatBeetleAccelerate.return

;> GetVectorTowardsLink(slot, ((GetRandomByte() ^ slot) & 7) + 4)      # hMultiPurpose0/1 = y / x speed towards Link
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
	jr z, .return

;>@t1     speed[slot] += -1 if (target - speed[slot]) & 0x80 else 1
	bit 7, a
	jr z, .up

	dec [hl]
	jr .return

.up
;=@t1
	inc [hl]

.return
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
;>         return ClearEntityStatus_06(slot)
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
;>     DrawEntity16x16(slot, TileGlintSprites)
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
;> wEntityX[slot] = mem[TileGlintPathX + i]
	ld hl, TileGlintPathX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = mem[TileGlintPathY + i]
	ld hl, TileGlintPathY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> LoadEntityPosition(slot)                              # copy the position to hActiveEntityX/Y
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

;>     if EntityTouchesLink(slot):                      # the right one
	call EntityTouchesLink
	jr nc, .wrong

;>         if wEntityPrivateCounter[slot] == 4:      # the last square
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $04
	jr nz, .next

;>             ClearEntityStatus_06(slot)
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
;>             sparkle, full = SpawnEntity(slot, 0x8A)
	ld a, $8a
	call SpawnEntity
;>             if not full:
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
;> StartBossMusic(slot)                              # miniboss music
	call StartBossMusic
;> ApplyRecoilIfNeeded_06(slot)
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
;> EntityCheckHits(slot)                              # contact damage and weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr z, .setEntityPrivate3

;>     if wEntityTimer[slot] == 0x0A:
	cp $0a
	jr nz, .entityCheckWalls

;>         GetEntityDirectionToLink_06(slot)     # (result unused)
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, .entityCheckWalls

.entityCheckWalls
;>     EntityCheckWalls(slot)
	call EntityCheckWalls
;>     return
	ret


.setEntityPrivate3
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;> if wEntityPrivate3[slot] == 2:          # every second pause
	ld a, [hl]
	cp $02
	jr nz, .setEntityTimer

;>     wEntityPrivate3[slot] = 0
	ld [hl], b
;>     if GetRandomByte() & 1 == 0:
	call GetRandomByte
	and $01
	jr nz, .setEntityTimer

;>         wEntityState[slot] = 2           # wind up
	call IncrementEntityState
	ld [hl], $02
;>         wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         return
	ret


.setEntityTimer
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
	jr nz, .otherwise

;>     direction = GetEntityDirectionToLink_06(slot)
	call GetEntityDirectionToLink_06
	jr .setDirection

.otherwise
;> else:
;>     direction = GetRandomByte()
	call GetRandomByte

.setDirection
;> direction &= 3
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[HinoxSpeedX + direction]
	ld hl, HinoxSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[HinoxSpeedY + direction]
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
;> EntityCheckHits(slot)
	call EntityCheckHits
;>@t2 if wEntityCollisions[slot] & 0x0F or wEntityTimer[slot] == 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, .setEntityTimer

;=@t2
	call GetEntityTimer
	jr nz, .updateEntityPosWithSpeed

.setEntityTimer
;>     wEntityTimer[slot] = (GetRandomByte() & 0x0F) | 0x10
	call GetRandomByte
	and $0f
	or $10
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     ClearEntitySpeed(slot)                          # stop
	call ClearEntitySpeed

.updateEntityPosWithSpeed
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
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
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, HinoxRunFeet

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpeedTowardsLink(slot, 0x18)                      # charge at Link
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
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .updateEntityPosWithSpeed

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.updateEntityPosWithSpeed
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x18) < 0x30:
	add $18
	cp $30
	jr nc, .checkFrameCounter

;>     dy, side = GetEntityYDistanceToLink_06(slot)
	call GetEntityYDistanceToLink_06
;>@t4     if u8(dy + 0x18) < 0x30 and wLinkMotionState == 0:
	add $18
	cp $30
	jr nc, .checkFrameCounter

;=@t4
	ld a, [wLinkMotionState]
	cp $00
	jr nz, .checkFrameCounter

;>         wEntityState[slot] += 1          # grab Link
	call IncrementEntityState
;>         wEntityTimer[slot] = 0x4F
	call GetEntityTimer
	ld [hl], $4f
;>         hWaveSfx = 0x16
	ld a, $16
	ldh [hWaveSfx], a

.checkFrameCounter
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .hinoxRunFeet

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

.hinoxRunFeet
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
	jr nz, .checkEntityTimer

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


.checkEntityTimer
;> if wEntityTimer[slot] == 0x20:           # throw
	cp $20
	jr nz, .setEntitySpriteVariant

;>     hLinkSpeedY = 0x20
	ld a, $20
	ldh [hLinkSpeedY], a
;>@t5     hLinkSpeedX = 0xE0 if hLinkX >= 0x50 else 0x20
	ldh a, [hLinkX]
	cp $50
	ld a, $e0
	jr nc, .setLinkSpeedX

	ld a, $20

.setLinkSpeedX
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


.setEntitySpriteVariant
;>@t6 wEntitySpriteVariant[slot] = mem[HinoxHoldFrames + ((wEntityTimer[slot] >> 3) & 0x0F)]
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
	jr c, HinoxFreezeLink.return

;> i = ((wEntityTimer[slot] - 0x20) >> 2) & 0x0F
	sub $20
	rra
	rra
	and $0f
	ld e, a
	ld d, b
;> hLinkX = hActiveEntityX + mem[HinoxHoldLinkX + i]
	ld hl, HinoxHoldLinkX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hLinkX], a
;> hLinkPositionZ = mem[HinoxHoldLinkZ + i]
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

.return
	ret


;@ def HinoxThrowBomb(slot: bc)
;@ path: boss/hinox
;@ State 5, after a hit: raises a bomb (frame 1) and at timer $10 throws it at Link
;@ (ThrowBombTowardsLink), starting 12 pixels to its left at height 16; walks again when the
;@ timer runs out.
;@ test: skip spawns an entity
HinoxThrowBomb::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .setFrame

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


.setFrame
;> frame = 1 if wEntityTimer[slot] >= 0x10 else 0
	ld e, $00
	cp $10
	jr c, .checkEntityTimer

	inc e

.checkEntityTimer
;> if wEntityTimer[slot] == 0x10:
	cp $10
	jr nz, .setEntitySpriteVariant

;>     bomb, full = SpawnEntity(slot, 0x02)
	ld a, $02
	call SpawnEntity
;>     if not full:
	jr c, .setEntitySpriteVariant

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


.setEntitySpriteVariant
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
;@ area music returns, the entity is removed for good (DefeatEntityWithDrop) and, except for the Armos
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
;> IncrementEntityPrivate2_06(slot)
	call IncrementEntityPrivate2_06
	ret


;@ def MinibossDefeatedFlash(slot: bc)
;@ path: boss
;@ Step 1: when the flashing is over, keeps flashing while it explodes for 192 frames (step 2).
;@ test: skip bank-0 helper
MinibossDefeatedFlash::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .return

;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     IncrementEntityPrivate2_06(slot)
	call IncrementEntityPrivate2_06

.return
	ret


;@ def MinibossDefeatedExplode(slot: bc)
;@ path: boss
;@ Step 2: explosions (MinibossExplosions) until the timer runs out; then noise $1A, the area
;@ music again, the entity is removed and recorded as defeated (DefeatEntityWithDrop), and the room's
;@ beaten flag is set - not for the Armos Knight, and for the Hinox, Cue Ball and Smasher only
;@ on maps below 6.
;@ test: skip banked helpers
MinibossDefeatedExplode::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr nz, .minibossExplosions
;>@ex     return MinibossExplosions(wEntityTimer[slot])

;> hNoiseSfx = 0x1A
	ld a, $1a
	ldh [hNoiseSfx], a
;> SelectAreaMusicFar()
	call SelectAreaMusicFar
;> DefeatEntityWithDrop(slot)                              # remove it for good
	call DefeatEntityWithDrop
;> if hActiveEntityType == 0x88:            # the Armos Knight
	ldh a, [hActiveEntityType]
	cp $88
;>     return
	ret z

;>@t2 if hActiveEntityType in (0x89, 0x8E, 0x92) and hMapId >= 6:
	ldh a, [hActiveEntityType]
	cp $89
	jr z, .checkActiveEntityType

;=@t2
	cp $8e
	jr z, .checkActiveEntityType

	cp $92
	jr nz, .markMinibossBeaten

.checkActiveEntityType
;=@t2
	ldh a, [hMapId]
	cp $06
;>     return
	ret nc

.markMinibossBeaten
;> MarkMinibossBeaten()
	jp MarkMinibossBeaten


.minibossExplosions
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
;@ hMultiPurposeG = landed). While wEntityTimer1 runs Link is stunned (frozen in pose $6A).
;@ When its health drops below 8, and again below 4, a piece breaks off (entity $05, placed at
;@ its drawn height, with a small puff (effect 2) and noise $29). Then its state.
;@ test: skip spawns entities and calls banked helpers
ArmosKnightActive::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> StartBossMusic(slot)                              # miniboss music
	call StartBossMusic
;> EntityCheckWeaponHits(slot)                              # weapon hits
	call EntityCheckWeaponHits
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot] & 0x80      # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:
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
;>         piece, full = SpawnEntity(slot, 0x05)           # hMultiPurpose0/1/3 = our x / y / height
	ld a, $05
	call SpawnEntity
;>         if not full:
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
;>@p2             pass                                   # on at ArmosKnightPiece, below
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
;>         piece, full = SpawnEntity(slot, 0x05)
	ld a, $05
	call SpawnEntity
;>         if not full:
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
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x20) >= 0x40:
	add $20
	cp $40
;>     return
	jr nc, .done

;> dy, side = GetEntityYDistanceToLink_06(slot)
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
;> DecrementEntityIgnoreHitsTimer(slot)
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
;> DecrementEntityIgnoreHitsTimer(slot)
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
;> ApplyRecoilIfNeeded_06(slot)
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
;> if hMultiPurposeG:                  # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, .move

;>     wEntitySpeedZ[slot] = 0x0C
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c
;>@t4     SetEntitySpeedTowardsLink(slot, 8 if wEntityHealth[slot] >= 5 else 0x0C)
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
	ret


;@ def ArmosKnightLeap(slot: bc)
;@ path: boss/armos_knight
;@ State 4: flies on until the top of the leap (height speed 0 or 1), then stops there for 16
;@ frames (state 5).
;@ test: skip bank-0 helpers
ArmosKnightLeap::
;> ApplyRecoilIfNeeded_06(slot)
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
;>     ClearEntitySpeed(slot)                          # stop
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState

.move
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
	ret


;@ def ArmosKnightHang(slot: bc)
;@ path: boss/armos_knight
;@ State 5: hangs in the air (height speed 0) until the timer runs out, then falls at -$50
;@ (state 6).
;@ test: skip bank-0 helpers
ArmosKnightHang::
;> ApplyRecoilIfNeeded_06(slot)
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
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> if not hMultiPurposeG:              # still falling
	ldh a, [hMultiPurposeG]
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
;> ApplyRecoilIfNeeded_06(slot)
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
;> LoadEntityPosition(slot)
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
;>     IncrementEntityPrivate2_06(slot)
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
;>     key, full = SpawnEntity(slot, 0x30)
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
;>     ClearEntityStatus_06(slot)
	call ClearEntityStatus_06
;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>@p1     y = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
;>@p2     pass                                   # on at LanmolaPuff, below
	jr .puff

.segments
;> if wEntityTimer[slot] & 0x1F:
	and $1f
;>     return
	jr nz, .done

;>@t1 t = wEntityPrivateCounter[slot] - mem[LanmolaSegmentLag + wEntityPrivate4[slot]]     # where that segment is
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
;> StartBossMusic(slot)                              # boss music
	call StartBossMusic
;> if wEntityTimer1[slot] and wEntityTimer1[slot] & 0x0F == 0:
	call GetEntityTimer1
	jr z, .frame

	and $0f
	jr nz, .frame

;>     rock = 2
	ld a, $02

.rock
;>     while True:
;>         hMultiPurposeG = rock       # scratch
	ldh [hMultiPurposeG], a
;>         new, full = SpawnEntity(slot, 0x87)
	ld a, $87
	call SpawnEntity
;>         if full:
;>             break
	jr c, .frame

;>@t4         wEntitySpriteVariant[new] = rock & 2
	push bc
	ldh a, [hMultiPurposeG]
	ld c, a
	ld hl, wEntitySpriteVariant
	add hl, de
	and $02
;=@t4
	ld [hl], a
;>@t5         wEntityX[new] = wLanmolaHoleX + mem[LanmolaRockX + rock]
	ld a, [wLanmolaHoleX]
	ld hl, LanmolaRockX
	add hl, bc
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@t5
	ld [hl], a
;>         wEntitySpeedX[new] = mem[LanmolaRockSpeedX + rock]
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
	ldh a, [hMultiPurposeG]
	dec a
;>         if rock == 0:
;>             break
	jr nz, .rock

.frame
;> LanmolaHeadFrame(slot)
	call LanmolaHeadFrame
;> DecrementEntityIgnoreHitsTimer(slot)
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
;>@t6     wEntityX[slot] = mem[LanmolaHoleX + (GetRandomByte() & 7)]
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
;>@t7     wEntityY[slot] = mem[LanmolaHoleY + (GetRandomByte() & 7)]
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
;>     LoadEntityPosition(slot)
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
;>     SetEntitySpeedTowardsLink(slot, 8)
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> EntityCheckHits(slot)                              # contact damage and weapon hits
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> EntityCheckHits(slot)
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> if not wEntityZ[slot] & 0x80:            # above the sand
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .frame

;>     EntityCheckHits(slot)
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
;@ hMultiPurposeG and hMultiPurposeH are the loop counter and its end (scratch).
;@ test: skip draws sprites
LanmolaDraw::
;> if not wEntityZ[slot] & 0x80:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .segments

;>     DrawEntity16x16(slot, LanmolaSprites)           # the head
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
;>     hMultiPurposeG = i
	ldh [hMultiPurposeG], a
;>@t12     t = (hMultiPurpose0 - mem[LanmolaSegmentLag + i]) & 0xFF
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
	ldh a, [hMultiPurposeG]
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
;>         DrawEntity16x16(slot, LanmolaSprites)
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
	ldh a, [hMultiPurposeG]
	add e
	cp [hl]
	jr nz, .loop

;> LoadEntityPosition(slot)                              # the head's position again
	jp LoadEntityPosition


;@ def LanmolaHeadFrame(slot: bc)
;@ path: boss/desert_lanmola
;@ Points the head the way it moves: along the faster axis, frame 1 right / 0 left, or 2 down /
;@ 3 up.
;@ test: wEntitySpeedX[slot] = rng.randrange(256)
;@ test: wEntitySpeedY[slot] = rng.randrange(256)
;@ test: wCurrentBank = $06
LanmolaHeadFrame::
;> vx = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld d, a
;> ax = abs(((vx ^ 0x80) - 0x80))
	bit 7, a
	jr z, .absY

	cpl
	inc a

.absY
;>@ay ay = abs(((wEntitySpeedY[slot] ^ 0x80) - 0x80))
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
;> DrawEntity8x16(slot, LanmolaRockSprites)           # one 8x16 sprite
	ld de, LanmolaRockSprites
	call DrawEntity8x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> UpdateEntityPosWithSpeed_06(slot)
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

;>     ClearEntityStatus_06(slot)
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

;>     dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;>     wEntityDirection[slot] = side
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>     ClearEntitySpeed(slot)                          # stop
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
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot] & 0x80     # scratch: landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:
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
	jr nz, PoodleBark.return

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

.return
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
;>     wEntitySpeedX[slot] = mem[PoodleHopSpeeds + i]
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
;>@t3     wEntitySpeedY[slot] = mem[PoodleHopSpeeds + (GetRandomByte() & 7)]
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
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

;>     wEntityDirection[slot] = GetEntityDirectionToLink_06(slot)
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.walk
;> SetWalkingFrame_06(slot)
	call SetWalkingFrame_06
;> DrawEntity16x16(slot, MadamMeowMeowSprites)
	ld de, MadamMeowMeowSprites
	call DrawEntity16x16
;> if wIsBowWowFollowingLink == 0x80:       # dognapped: hop in despair
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jr nz, .act

;>     AddEntityZSpeedToPos_06(slot)
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
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;> LoadEntityPosition(slot)
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
;> BlockLinkIfTouching_06(slot)
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
;>         return ClearEntityStatus_06(slot)
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
;> DrawEntity16x16(slot, CrowSprites)
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
;> ApplyRecoilIfNeeded_06(slot)
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
;>     dx, side = GetEntityXDistanceToLink_06(slot)
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

;>     dy, side = GetEntityYDistanceToLink_06(slot)
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
;> EntityCheckHits(slot)
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
;> ClearEntitySpeed(slot)                              # no sideways movement
	call ClearEntitySpeed
;> wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;> AddEntityZSpeedToPos_06(slot)
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
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
;>     return IncrementEntityState(slot)
	jp z, IncrementEntityState

;> if wEntityTimer[slot] & 1:
	and $01
;>     return CrowFly(slot)
	jr nz, CrowFly

;> GetVectorTowardsLink(slot, 0x20)                          # hMultiPurpose0/1 = y / x speed towards Link
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
;> UpdateEntityPosWithSpeed_06(slot)
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
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .fly

;>     GetVectorTowardsLink(slot, 0x20)
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
;>     return ClearEntityStatus_06(slot)
	jp nc, ClearEntityStatus_06

;> if hActiveEntityX >= 0xA8:
	ldh a, [hActiveEntityX]
	cp $a8
;>     return ClearEntityStatus_06(slot)
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
;>     DrawEntity8x16(slot, CrazyTracyMedicineSprite)
	ld de, CrazyTracyMedicineSprite
	call DrawEntity8x16
;>     LoadEntityPosition(slot)
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
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> BlockLinkIfTouching_06(slot)
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
	jp nz, CrazyTracySayAndReset.return

;> if wDialogAnswer:                        # "no"
	ld a, [wDialogAnswer]
	and a
;>     return CrazyTracySayAndReset(slot, 0x1D)
	jr nz, CrazyTracySell.crazyTracySayAndReset

;>@t10 price = mem[CrazyTracyPriceHigh + wEntityPrivate1[slot]] << 8 | mem[CrazyTracyPriceLow + wEntityPrivate1[slot]]
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

;>     return CrazyTracySayAndReset(slot, 0x1B)
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
;> wSubtractRupeeBufferLow += mem[CrazyTracyChargeLow + i]       # (carry into the high byte)
	ld hl, CrazyTracyChargeLow
	add hl, de
	ld a, [wSubtractRupeeBufferLow]
	add [hl]
	ld [wSubtractRupeeBufferLow], a
	rl a
;> wSubtractRupeeBufferHigh += mem[CrazyTracyChargeHigh + i] + carry
	ld hl, CrazyTracyChargeHigh
	add hl, de
	rr a
	ld a, [wSubtractRupeeBufferHigh]
	adc [hl]
	ld [wSubtractRupeeBufferHigh], a
;> wMedicineCount += 1
	ld hl, wMedicineCount
	inc [hl]
;> CrazyTracySayAndReset(slot, 0x1A)
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


.crazyTracySayAndReset
;> CrazyTracySayAndReset(slot, 0x1D)
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

.return
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


;@ path: npc/village_kids
;@ The village kids' frames for the two-sprite renderer: 4 frames of 4 bytes (left tile,
;@ attributes, right tile, attributes; $20 mirrored): 0/1 facing down (tiles $70/$72, the second
;@ frame mirrored), 2/3 facing up (tiles $74/$76).
KidSprites::
	db $70, $00, $72, $00, $72, $20, $70, $20, $74, $00, $76, $00, $76, $20, $74, $20
;@ path: npc/village_kids
;@ The kids playing catch: 4 frames of 4 bytes - 0 standing, 1 throwing (tiles $78-$7E) facing
;@ right; 2/3 the same mirrored (frame = pose + wEntityDirection).
KidCatchSprites::
	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20
;@ path: npc/village_kids
;@ The ball the kids throw, for the one-sprite renderer: tile $3E.
KidBallSprite::
	db $3e, $00

;@ def KidCatchHandler(slot: bc)
;@ path: npc/village_kids
;@ Entities $71 and $72: the two Mabe Village kids who play catch, throwing a ball (entity $71
;@ with wEntityPrivate1 set) to each other. While Bow-Wow is dognapped (and not in the credits,
;@ wGameplayType 1) they instead tell Link the news: they play the alarm music ($0E) and the
;@ kid walks up to Link, who is frozen meanwhile; kid $71 says text $220.
;@ test: skip draws sprites and opens dialogues
KidCatchHandler::
;> if wEntityPrivate1[slot]:               # the ball
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .kid

;>     DrawEntity8x16(slot, KidBallSprite)
	ld de, KidBallSprite
	call DrawEntity8x16
;>     ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;>     UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;>     AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;>     wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;>     if wEntityTimer[slot] == 0:            # caught
	call GetEntityTimer
;>         return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

;>     return
	ret


.kid
;> if wIsBowWowFollowingLink != 0x80 or wGameplayType == 1:
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp nz, KidCatchPlay

	ld a, [wGameplayType]
	cp $01
;>     return KidCatchPlay(slot)
	jp z, KidCatchPlay

;> DrawEntity16x16(slot, KidSprites)              # Bow-Wow is gone: the news
	ld de, KidSprites
	call DrawEntity16x16
;> dy, side = GetEntityYDistanceToLink_06(slot)
	call GetEntityYDistanceToLink_06
;> face = ((side - 1) & 2) ^ 2              # 0 down, 2 up
	ld a, e
	dec a
	and $02
	xor $02
	ld e, a
;>@t1 wEntitySpriteVariant[slot] = face + (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add e
;=@t1
	call SetEntitySpriteVariant
;> KidNewsSteps[wEntityPrivate3[slot]](slot)
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: npc/village_kids
;@ The steps of the kids' "Bow-Wow was dognapped" news (wEntityPrivate3): 0 start, 1 run up to
;@ Link, 2 done.
KidNewsSteps::
	dw KidNewsStart
	dw KidNewsRunUp
	dw KidNewsDone

;@ def KidNewsStart(slot: bc)
;@ path: npc/village_kids
;@ Step 0: plays the alarm music ($0E, also as the area's music) and allows 48 frames to run
;@ up. KidNewsNextStep advances wEntityPrivate3.
;@ test: skip bank-0 helper
KidNewsStart::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> wEntityPrivate2[slot] = 0x30
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $30
;> wMusicTrackToPlay = 0x0E
	ld a, $0e
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrack = 0x0E
	ldh [hDefaultMusicTrack], a
;> hDefaultMusicTrackAlt = 0x0E
	ldh [hDefaultMusicTrackAlt], a

KidNewsNextStep:
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ret


;@ def KidNewsRunUp(slot: bc)
;@ path: npc/village_kids
;@ Step 1: the kid walks towards Link (speed 8; Link frozen) until it is level with him (within
;@ 32 pixels up / down) or 48 frames have passed; then, once the screen has faded in, kid $71
;@ says text $220. Step 2.
;@ test: skip moves through banked helpers
KidNewsRunUp::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> dy, side = GetEntityYDistanceToLink_06(slot)
	call GetEntityYDistanceToLink_06
;> if u8(dy + 0x20) >= 0x40:                # not level with Link yet
	add $20
	cp $40
	jr c, .arrived

;>     wEntityPrivate2[slot] -= 1
	ld hl, wEntityPrivate2
	add hl, bc
	dec [hl]
;>     if wEntityPrivate2[slot] != 0:
	jr nz, .run

;>@r1         SetEntitySpeedTowardsLink(slot, 8)
;>@r2         UpdateEntityPosWithSpeed_06(slot)
;>@r3         hLinkInteractiveMotionBlocked = 2
;>@r4         wLinkFrozen = 2
;>@r5         return

.arrived
;> if wTransitionSequenceCounter != 4:      # the screen is still fading in
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	ret nz

;> if hActiveEntityType == 0x71:
	ldh a, [hActiveEntityType]
	cp $71
	jr nz, .next

;>     OpenDialogTable2(0x20)
	ld a, $20
	call OpenDialogTable2

.next
;> KidNewsNextStep(slot)
	jp KidNewsNextStep


.run
;=@r1
	ld a, $08
	call SetEntitySpeedTowardsLink
;=@r2
	call UpdateEntityPosWithSpeed_06
;=@r3
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;=@r4
	ld [wLinkFrozen], a
;=@r5
	ret


;@ def KidNewsDone(slot: bc)
;@ path: npc/village_kids
;@ Step 2: the kid stands (blocking Link) and hops every 32 frames; talking to it repeats text
;@ $220.
;@ test: skip opens a dialogue
KidNewsDone::
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> hActiveEntityDrawY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> if ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
	jr nc, .hop

;>     OpenDialogTable2(0x20)
	ld a, $20
	call OpenDialogTable2

.hop
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>@t2 if wEntityZ[slot] == 0 or wEntityZ[slot] & 0x80:      # on the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .ground

;=@t2
	and $80
	jr z, .done

.ground
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .done

;>         wEntitySpeedZ[slot] = 0x10
	ld [hl], $10

.done
	ret


;@ def KidCatchPlay(slot: bc)
;@ path: npc/village_kids
;@ The kids' game of catch: drawn with KidCatchSprites (pose + facing), talk as the other kids
;@ (KidTalk), gravity 1 (scratch hMultiPurposeG = landed). Then its state.
;@ test: skip draws sprites and opens dialogues
KidCatchPlay::
;> hActiveEntitySpriteVariant |= wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	or [hl]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, KidCatchSprites)
	ld de, KidCatchSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> KidTalk(slot)
	call KidTalk
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG:
	jr z, .dispatch

;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a

.dispatch
;> KidCatchStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/village_kids
;@ The catch game's states: 0 waiting to throw, 1 thrown (waiting for the ball to come back).
KidCatchStates::
	dw KidCatchThrow
	dw KidCatchWait

;@ def KidCatchThrow(slot: bc)
;@ path: npc/village_kids
;@ State 0: when the timer runs out the kid throws (frame 1, 128 frames of state 1): the ball
;@ (entity $71 with wEntityPrivate1 = 1) starts at the kid, height speed $10, x speed $14 from
;@ kid $71 (to the right) or -$14 from kid $72, and is caught after 36 frames.
;@ test: skip spawns an entity
KidCatchThrow::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done

;> wEntityTimer[slot] = 0x80
	ld [hl], $80
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntitySpriteVariant[slot] = 1          # throwing
	ld a, $01
	call SetEntitySpriteVariant
;> ball, full = SpawnEntity(slot, 0x71)
	ld a, $71
	call SpawnEntity
;> if full:
;>     return
	jr c, .done

;> wEntityX[ball] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[ball] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPrivate1[ball] = 1                # it is the ball
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntitySpeedZ[ball] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>@t3 wEntitySpeedX[ball] = 0x14 if hActiveEntityType == 0x71 else 0xEC
	ldh a, [hActiveEntityType]
	cp $71
	ld a, $14
	jr z, .speed

	ld a, $ec

.speed
;=@t3
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntityTimer[ball] = 0x24
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $24

.done
	ret


;@ def KidCatchWait(slot: bc)
;@ path: npc/village_kids
;@ State 1: after the throw pose (32 frames) the kid stands; from timer $40 down it hops on
;@ each landing (height speed 8), excited for the ball. When the timer runs out: state 0 for 96
;@ frames.
;@ test: skip bank-0 helpers
KidCatchWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .wait

;>     wEntityTimer[slot] = 0x60
	ld [hl], $60
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret


.wait
;> if wEntityTimer[slot] < 0x60:
	cp $60
	jr nc, .done

;>     if wEntityTimer[slot] < 0x40 and hMultiPurposeG:
	cp $40
	jr nc, .stand

	ldh a, [hMultiPurposeG]
	and a
	jr z, .stand

;>         wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08

.stand
;>     wEntitySpriteVariant[slot] = 0
	xor a
	call SetEntitySpriteVariant

.done
	ret


;@ def KidHandler(slot: bc)
;@ path: npc/village_kids
;@ Entities $70 and $73: two Mabe Village kids who stand about (frame 0/1 every 16 frames) and
;@ give hints (KidTalk). In room $92 they only appear from trade item 7 on.
;@ test: skip draws sprites and opens dialogues
KidHandler::
;> if hMapRoom == 0x92 and wTradeSequenceItem < 7:
	ldh a, [hMapRoom]
	cp $92
	jr nz, .draw

	ld a, [wTradeSequenceItem]
	cp $07
;>     return ClearEntityStatus_06(slot)
	jp c, ClearEntityStatus_06

.draw
;> DrawEntity16x16(slot, KidSprites)
	ld de, KidSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;>@t4 wEntitySpriteVariant[slot] = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@t4
	call SetEntitySpriteVariant

;@ def KidTalk(slot: bc)
;@ path: npc/village_kids
;@ The village kids' talk (they block Link): text $123 while Marin waits in Animal Village, $121
;@ while she walks with Link, $120 in room $92 until the room flag $30 of overworld room $FD is
;@ set, $122 in room $83 once Link has the second instrument (until flag bit 4 of indoor room
;@ $2BE); otherwise one of four hints in turn (wKidHintIndex): texts $118-$11B, or - once
;@ wDungeonFlags bit 1 is set - each kid's own line $11C + (type - $70).
;@ test: skip opens dialogues
KidTalk::
;> hActiveEntityDrawY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> if not ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
;>     return
	jr nc, .done

;> if wIsMarinInAnimalVillage:
	ld a, [wIsMarinInAnimalVillage]
	and a
	jr z, .marin

;>     return OpenDialogTable1(0x23)
	ld a, $23
	jp OpenDialogTable1


.marin
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .room92

;>     return OpenDialogTable1(0x21)
	ld a, $21
	jp OpenDialogTable1


.room92
;> if hMapRoom == 0x92 and not wRoomStatus[0xFD] & 0x30:
	ldh a, [hMapRoom]
	cp $92
	jr nz, .shrine

	ld a, [wRoomStatus + $fd]
	and $30
	jr nz, .shrine

;>     return OpenDialogTable1(0x20)
	ld a, $20
	jp OpenDialogTable1


.shrine
;>@t5 if wHasInstrument2 & 2 and not wRoomStatus[0x2BE] & 0x10 and hMapRoom == 0x83:
	ld a, [wHasInstrument2]
	and $02
	jr z, .hint

	ld a, [wRoomStatus + $2be]
	and $10
	jr nz, .hint

;=@t5
	ldh a, [hMapRoom]
	cp $83
	jr nz, .hint

;>     return OpenDialogTable1(0x22)
	ld a, $22
	jp OpenDialogTable1


.hint
;> hint = wKidHintIndex
	ld hl, wKidHintIndex
	ld a, [hl]
	push af
;>@t6 wKidHintIndex = (hint + 1) & 3
	inc a
	cp $04
	jr nz, .store

	xor a

.store
;=@t6
	ld [hl], a
;> if not wDungeonFlags & 2:
	ld a, [wDungeonFlags]
	and $02
	jr nz, .ownLine

;>     return OpenDialogTable1(0x18 + hint)
	pop af
	add $18
	jp OpenDialogTable1


.ownLine
;> OpenDialogTable1(hActiveEntityType - 0x70 + 0x1C)
	pop af
	ldh a, [hActiveEntityType]
	sub $70
	add $1c
	call OpenDialogTable1

.done
	ret


;@ def GiantGopongaHandler(slot: bc)
;@ path: enemy/goponga_flower
;@ Entity $7C: the Giant Goponga Flower, a big plant (8 sprites) that sways for 192 frames, then
;@ opens its mouth and spits a shot (entity $7D, speed $0C at Link) at timer $4A. Solid to Link;
;@ only weapon hits count.
;@ test: skip draws sprites and calls banked helpers
GiantGopongaHandler::
;> GiantGopongaDraw(slot)
	call GiantGopongaDraw
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;> GiantGopongaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/goponga_flower
;@ The Giant Goponga Flower's states: 0 start, 1 sway, 2 open and shoot.
GiantGopongaStates::
	dw GiantGopongaInit
	dw GiantGopongaSway
	dw GiantGopongaShoot

;@ def GiantGopongaInit(slot: bc)
;@ path: enemy/goponga_flower
;@ State 0: sways for 192 frames (state 1).
;@ test: skip bank-0 helpers
GiantGopongaInit::
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ def GiantGopongaSway(slot: bc)
;@ path: enemy/goponga_flower
;@ State 1: sways (frames 0/1 every 16 frames); then opens its mouth for 80 frames (state 2).
;@ test: skip bank-0 helpers
GiantGopongaSway::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame

;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     wEntityState[slot] += 1
	call IncrementEntityState

.frame
;> frame = (wEntityTimer[slot] >> 4) & 1
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def GiantGopongaShoot(slot: bc)
;@ path: enemy/goponga_flower
;@ State 2: mouth open (frame 2); at timer $4A it spits a shot (entity $7D) at Link at speed $0C;
;@ back to state 0 when the timer runs out.
;@ test: skip spawns an entity
GiantGopongaShoot::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .shoot

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.shoot
;> if wEntityTimer[slot] == 0x4A:
	cp $4a
	jr nz, .frame

;>     shot, full = SpawnEntity(slot, 0x7D)
	ld a, $7d
	call SpawnEntity
;>     if not full:
	jr c, .frame

;>         wEntityX[shot] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[shot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         SetEntitySpeedTowardsLink(0x0C, slot=shot)
	push bc
	push de
	pop bc
	ld a, $0c
	call SetEntitySpeedTowardsLink
	pop bc

.frame
;> wEntitySpriteVariant[slot] = 2           # mouth open
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ path: enemy/goponga_flower
;@ The Giant Goponga Flower's 3 frames, 32 bytes each: 8 sprites (y offset, x offset, tile,
;@ attributes; $20 mirrored), a 32x32 plant of two rows of four 8x16 sprites. Frames 0 and 1
;@ (tiles $70-$76, frame 1 shifted a pixel inwards: the sway), frame 2 the open mouth (tiles
;@ $78-$7E).
GiantGopongaOAM::
	db $f8, $f8, $70, $00, $f8, $00, $72, $00, $f8, $08, $72, $20, $f8, $10, $70, $20
	db $08, $f8, $74, $00, $08, $00, $76, $00, $08, $08, $76, $20, $08, $10, $74, $20
	db $f9, $f9, $70, $00, $f9, $01, $72, $00, $f9, $07, $72, $20, $f9, $0f, $70, $20
	db $07, $f9, $74, $00, $07, $01, $76, $00, $07, $07, $76, $20, $07, $0f, $74, $20
	db $f8, $f8, $78, $00, $f8, $00, $7a, $00, $f8, $08, $7a, $20, $f8, $10, $78, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20

;@ def GiantGopongaDraw(slot: bc)
;@ path: enemy/goponga_flower
;@ Draws the Giant Goponga Flower's frame (8 sprites from GiantGopongaOAM) and claims them.
;@ test: skip draws sprites
GiantGopongaDraw::
;>@t7 DrawEntitySprites(GiantGopongaOAM + hActiveEntitySpriteVariant * 32, count=8)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
;=@t7
	and $e0
	ld e, a
	ld d, b
	ld hl, GiantGopongaOAM
	add hl, de
	ld c, $08
;=@t7
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
	ret


;@ path: enemy/goponga_flower
;@ The Goponga shot's frames for the two-sprite renderer: 0/1 the flying shot (tile $1E, turned
;@ around: plain + flipped both ways, flipped up + mirrored), 2/3 the burst (tiles $32 and $30,
;@ each with its mirror).
GopongaShotSprites::
	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $32, $00, $32, $20, $30, $00, $30, $20

;@ def GopongaShotHandler(slot: bc)
;@ path: enemy/goponga_flower
;@ Entity $7D: the shot the Giant Goponga Flower spits. Its health is held at $30 (it cannot be
;@ killed); a sword hit bursts it (16 frames, burst frames 2/3), and it is removed when it
;@ leaves the screen (CrowRemoveOffscreen). With wEntityPrivate1 set it flashes (palette bit
;@ every 4 frames).
;@ test: skip draws sprites and calls banked helpers
GopongaShotHandler::
;> wEntityHealth[slot] = 0x30
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $30
;> if wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .draw

;>     hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a

.draw
;> DrawEntity16x16(slot, GopongaShotSprites)
	ld de, GopongaShotSprites
	call DrawEntity16x16
;> if wEntityTimer[slot]:                   # bursting
	call GetEntityTimer
	jr z, .flying

;>     if wEntityTimer[slot] == 1:
	dec a
;>         return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

;>     return SetEntitySpriteVariant(slot, ((wEntityTimer[slot] - 1) >> 3) & 1 + 2)
	rra
	rra
	rra
	and $01
	add $02
	jp SetEntitySpriteVariant


.flying
;> if wEntityIgnoreHitsTimer[slot] >= 2:    # just hit: burst
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	cp $02
	jr c, .fly

;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     return
	ret


.fly
;> wEntityIgnoreHitsTimer[slot] = 0
	ld [hl], b
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> wEntitySpriteVariant[slot] = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> EntityCheckHits(slot)
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> CrowRemoveOffscreen(slot)
	jp CrowRemoveOffscreen


;@ path: enemy/goponga_flower
;@ The Goponga Flower's frames for the two-sprite renderer: tile $50 and its mirror (closed),
;@ tile $52 and its mirror (open).
GopongaFlowerSprites::
	db $50, $00, $50, $20, $52, $00, $52, $20

;@ def GopongaFlowerHandler(slot: bc)
;@ path: enemy/goponga_flower
;@ Entity $7E: the Goponga Flower, a plant that blocks Link and can only be cut by weapons; it
;@ opens and closes (frame 1 for three quarters of every 64 frames).
;@ test: skip draws sprites and calls banked helpers
GopongaFlowerHandler::
;> DrawEntity16x16(slot, GopongaFlowerSprites)
	ld de, GopongaFlowerSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;>@t8 wEntitySpriteVariant[slot] = 1 if hFrameCounter & 0x30 else 0
	ldh a, [hFrameCounter]
	ld e, b
	and $30
	jr z, .set

	inc e

.set
;=@t8
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def BlockLinkIfTouching_06(slot: bc)
;@ path: entity/helpers
;@ Makes the entity solid: when it touches Link, BlockLink_06.
;@ test: skip calls a banked collision check
BlockLinkIfTouching_06::
;> if not EntityTouchesLink(slot):
	call EntityTouchesLink
;>     return
	jr nc, BlockLink_06.return

;@ def BlockLink_06()
;@ path: entity/helpers
;@ Stops Link where he was before this frame's move (RestoreLinkPosition), ends a Pegasus Boots
;@ dash, and puts the hookshot chain (entity type 3), if it is out, back to its first state.
;@ test: skip bank-0 helpers
BlockLink_06::
;> RestoreLinkPosition()
	call RestoreLinkPosition
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> if wHookshotChainSlot:
	ld a, [wHookshotChainSlot]
	and a
	jr z, .return

;>     chain = wHookshotChainSlot - 1
	ld e, a
	ld d, b
;>     if wEntityType[chain] == 3:
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, .return

;>         wEntityState[chain] = 0
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00

.return
	ret


;@ path: entity/helpers
;@ First walking frame for each facing (0 right, 1 left, 2 up, 3 down), used by
;@ SetWalkingFrame_06: 6, 4, 2, 0 (the next frame is the second step).
WalkingFrameBase_06::
	db $06, $04, $02, $00

;@ def SetWalkingFrame_06(slot: bc)
;@ path: entity/helpers
;@ Walking animation of the characters: frame = WalkingFrameBase_06[facing] + step, the step
;@ switching every 16 frames of wEntityPrivateCounter (advanced here).
;@ test: slot = rng.randrange(16)
;@ test: wEntityDirection[slot] = rng.randrange(4)
;@ test: wCurrentBank = $06
SetWalkingFrame_06::
;> base = mem[WalkingFrameBase_06 + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, WalkingFrameBase_06
	add hl, de
;> wEntityPrivateCounter[slot] += 1
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@t1 step = (wEntityPrivateCounter[slot] >> 4) & 1
	ld a, [hl]
	rra
	rra
	rra
	rra
	pop hl
;=@t1
	and $01
;> SetEntitySpriteVariant(slot, step | mem[base])
	or [hl]
	jp SetEntitySpriteVariant


;@ def ShouldLinkTalkToEntity_06() -> carry
;@ path: entity/helpers
;@ Carry when Link talks to the character: he stands within 20 pixels above / below and 16
;@ to the side, faces it (except for the little dog, type $78), nothing else is going on (no
;@ text box, inventory, jump or dialog cooldown, window down) and A was just pressed. While he
;@ is in place, wCanTalkToEntity is set (so A talks instead of using an item).
;@ ShouldLinkTalkToEntityCheckX_06 is entered with carry clear when the caller's own up / down
;@ range check failed.
;@ test: skip calls a banked helper
ShouldLinkTalkToEntity_06::
;> found = 0
	ld e, b
;> return ShouldLinkTalkToEntityCheckX_06(u8(hLinkY - hActiveEntityY + 0x14) < 0x28)
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28

;@ def ShouldLinkTalkToEntityCheckX_06(near: carry) -> carry
;@ path: entity/helpers
;@ The rest of ShouldLinkTalkToEntity_06 (from the left / right check on).
;@ test: skip calls a banked helper
ShouldLinkTalkToEntityCheckX_06::
;> if not near:
	jr nc, .return
;>@n1     return False

;> if u8(hLinkX - hActiveEntityX + 0x10) >= 0x20:
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
;>     return False
	jr nc, .return

;> found = 1
	inc e
;> if hActiveEntityType != 0x78:             # the little dog can be talked to from any side
	ldh a, [hActiveEntityType]
	cp $78
	jr z, .inPlace

;>     if hLinkDirection ^ 1 != GetEntityDirectionToLink_06():      # Link must face it
	push de
	call GetEntityDirectionToLink_06
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
;>         return False
	jr nz, .return

.inPlace
;> wCanTalkToEntity = 1
	ld hl, wCanTalkToEntity
	ld [hl], $01
;>@t2 if wDialogState or wInventoryAppearing or wIsLinkInTheAir or wDialogCooldown:
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
	ld hl, wDialogCooldown
;=@t2
	or [hl]
;>     return False
	jr nz, .return

;> if wWindowY != 0x80:
	ld a, [wWindowY]
	cp $80
;>     return False
	jr nz, .return

;> return bool(hJoypadPressed & 0x10)       # A pressed
	ldh a, [hJoypadPressed]
	and $10
	jr z, .return

	scf
	ret


.return
;=@n1
	and a
	ret


;@ def ReturnIfNonInteractive_06()
;@ path: entity/helpers
;@ Returns from the calling handler as well (drops its return address) unless the entity is
;@ active (status 5) and the game runs normally: not in game mode 7, no item pose, text box or
;@ inventory, no room transition. ReturnIfGamePaused_06 skips the status check.
;@ test: skip returns from the caller
ReturnIfNonInteractive_06::
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return return_from_caller()
	jr nz, ReturnIfGamePaused_06.return

;@ def ReturnIfGamePaused_06()
;@ path: entity/helpers
;@ Returns from the calling handler as well while the game is paused for the entities (game mode
;@ 7, item pose, text box, inventory, room transition).
;@ test: skip returns from the caller
ReturnIfGamePaused_06::
;> if wGameplayType == 7:
	ld a, [wGameplayType]
	cp $07
;>     return return_from_caller()
	jr z, .return

;> if wLinkShowItemPoseActive or wDialogState or wInventoryAppearing:
	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
;>     return return_from_caller()
	jr nz, .return

;> if wRoomTransitionState == 0:
	ld a, [wRoomTransitionState]
	and a
;>     return
	jr z, .return2

.return
;> return_from_caller()
	pop af

.return2
	ret


;@ def ApplyRecoilIfNeeded_06(slot: bc)
;@ path: entity/helpers
;@ While the entity's knock-back runs (wEntityIgnoreHitsTimer, counted down here) it is pushed
;@ with its recoil speed (and stopped by walls unless option bit 5 is set) and the calling
;@ handler is skipped for this frame (its return address is dropped).
;@ test: skip returns from the caller
ApplyRecoilIfNeeded_06::
;> if wEntityIgnoreHitsTimer[slot] == 0:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, .return

;> wEntityIgnoreHitsTimer[slot] -= 1
	dec a
	ld [hl], a
;> AddPowerHitTrailVfx(slot)
	call AddPowerHitTrailVfx
;> sx = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
;> sy = wEntitySpeedY[slot]
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
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore

;>     EntityCheckWalls(slot)
	call EntityCheckWalls

.restore
;> wEntitySpeedY[slot] = sy
	ld hl, wEntitySpeedY
	add hl, bc
	pop af
	ld [hl], a
;> wEntitySpeedX[slot] = sx
	ld hl, wEntitySpeedX
	add hl, bc
	pop af
	ld [hl], a
;> return_from_caller()
	pop af

.return
	ret


;@ def UpdateEntityPosWithSpeed_06(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its x and y speeds (AddEntitySpeedToPos_06 for x, then with slot + 16,
;@ which reaches the y arrays).
;@ test: slot = rng.randrange(16)
UpdateEntityPosWithSpeed_06::
;> AddEntitySpeedToPos_06(slot)              # x
	call AddEntitySpeedToPos_06
;> AddEntitySpeedToPos_06(slot + 16)         # y: the y arrays follow the x arrays by 16
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPos_06
;> return
	pop bc
	ret


;@ def AddEntitySpeedToPos_06(slot: bc)
;@ path: entity/helpers
;@ Adds the speed (signed, 1/16 pixels per frame) to the position: the low nibble goes into the
;@ fraction accumulator (wEntitySpeedXAcc), its carry and the high nibble into wEntityX. Called
;@ with slot + 16 it works on the y arrays (wEntitySpeedY, wEntitySpeedYAcc, wEntityY).
;@ test: slot = rng.randrange(32)
AddEntitySpeedToPos_06::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> if speed == 0:
	and a
;>     return
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

.setStep
;>@t3 step = ((speed ^ 0x80) - 0x80) >> 4      # pos = wEntityX (or wEntityZ, from AddEntityZSpeedToPos_06)
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive

	ld e, $f0

.positive
;=@t3
	swap a
	and $0f
	or e
;> wEntityX[slot] = u8(wEntityX[slot] + step + (acc >> 8))      # wEntityZ when entered from AddEntityZSpeedToPos_06
	rr d
	adc [hl]
	ld [hl], a

.return
	ret


;@ def AddEntityZSpeedToPos_06(slot: bc)
;@ path: entity/helpers
;@ The same for the height: wEntitySpeedZ into wEntitySpeedZAcc and wEntityZ.
;@ test: slot = rng.randrange(16)
AddEntityZSpeedToPos_06::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0:
	and a
;>     return
	jr z, AddEntitySpeedToPos_06.return

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
;> wEntityZ[slot] = u8(wEntityZ[slot] + (((speed ^ 0x80) - 0x80) >> 4) + (acc >> 8))     # (shared tail)
	ld hl, wEntityZ
	jr AddEntitySpeedToPos_06.setStep

;@ def GetEntityXDistanceToLink_06(slot: bc) -> (a, e)
;@ path: entity/helpers
;@ Returns hLinkX - x (also in d) and the side Link is on: 0 right, 1 left.
;@ test: slot = rng.randrange(16)
GetEntityXDistanceToLink_06::
;> side = 0
	ld e, $00
;> dx = u8(hLinkX - wEntityX[slot])
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if dx & 0x80:
	bit 7, a
	jr z, .done

;>     side = 1
	inc e

.done
;> return dx, side
	ld d, a
	ret


;@ def GetEntityYDistanceToLink_06(slot: bc) -> (a, e)
;@ path: entity/helpers
;@ Returns hLinkY - y (also in d) and the side Link is on: 2 above, 3 below.
;@ test: slot = rng.randrange(16)
GetEntityYDistanceToLink_06::
;> side = 2
	ld e, $02
;> dy = u8(hLinkY - wEntityY[slot])
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if not dy & 0x80:
	bit 7, a
	jr nz, .done

;>     side = 3
	inc e

.done
;> return dy, side
	ld d, a
	ret


;@ def GetEntityDirectionToLink_06(slot: bc) -> e
;@ path: entity/helpers
;@ The direction (0 right, 1 left, 2 up, 3 down) of Link from the entity along the axis on which
;@ he is farther away (the vertical one on a tie). hMultiPurpose0 / 1 = the x / y side.
;@ test: slot = rng.randrange(16)
;@ test: wCurrentBank = $06
GetEntityDirectionToLink_06::
;> dx, side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> hMultiPurpose0 = side
	ld a, e
	ldh [hMultiPurpose0], a
;> ax = abs(((dx ^ 0x80) - 0x80))
	ld a, d
	bit 7, a
	jr z, .ax

	cpl
	inc a

.ax
;> dy, side = GetEntityYDistanceToLink_06(slot)
	push af
	call GetEntityYDistanceToLink_06
;> hMultiPurpose1 = side
	ld a, e
	ldh [hMultiPurpose1], a
;> ay = abs(((dy ^ 0x80) - 0x80))
	ld a, d
	bit 7, a
	jr z, .ay

	cpl
	inc a

.ay
;> if ay < ax:
	pop de
	cp d
	jr nc, .vertical

;>     return hMultiPurpose0
	ldh a, [hMultiPurpose0]
	jr .done

.vertical
;> return hMultiPurpose1
	ldh a, [hMultiPurpose1]

.done
	ld e, a
	ret


;@ def ClearEntityStatus_06(slot: bc)
;@ path: entity/helpers
;@ Frees the entity's slot (status 0).
;@ test: slot = rng.randrange(16)
ClearEntityStatus_06::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ path: enemy/wizrobe
;@ The Wizrobe's magic shot for the two-sprite renderer: 4 frames of 4 bytes (left tile,
;@ attributes, right tile, attributes): 0 flying left / 1 right (tiles $68/$6A), 2 down / 3 up
;@ (tile $6C, flipped).
WizrobeShotSprites::
	db $6a, $20, $68, $20, $68, $00, $6a, $00, $6c, $40, $6c, $60, $6c, $00, $6c, $20

;@ def WizrobeShotHandler(slot: bc)
;@ path: enemy/wizrobe
;@ Entity $22: the Wizrobe's magic shot. Flickers between the sprite palettes (every 4 frames),
;@ hurts Link on touch, flies straight and disappears when it hits anything in the room.
;@ test: skip draws sprites and calls banked helpers
WizrobeShotHandler::
;> hActiveEntityFlipAttribute = (hFrameCounter << 2) & 0x10
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(slot, WizrobeShotSprites)
	ld de, WizrobeShotSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> EntityCheckTouchLink(slot)
	call EntityCheckTouchLink
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckObjectCollision(slot)
	call EntityCheckObjectCollision
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;>     ClearEntityStatus_06(slot)
	call ClearEntityStatus_06

.done
	ret


;@ path: enemy/spark
;@ The Spark's frames for the two-sprite renderer, swapped every 2 frames: tile $5C and its
;@ mirror, in sprite palette 0, then palette 1.
SparkSprites::
	db $5c, $00, $5c, $20, $5c, $10, $5c, $30

;@ path: enemy/spark
;@ The Spark's y speed for each of its directions, index direction (0-3) + wEntityPrivate2 (0 or
;@ 4): 0, $10, 0, -$10 (right, down, left, up) and 0, -$10, 0, $10 (right, up, left, down).
SparkSpeedY::
	db $00, $10, $00, $f0, $00, $f0, $00, $10
;@ path: enemy/spark
;@ The Spark's x speed, same index: $10, 0, -$10, 0 for both sets.
SparkSpeedX::
	db $10, $00, $f0, $00, $10, $00, $f0, $00

;@ path: enemy/spark
;@ The wall bit (wEntityCollisions: 1 right, 2 left, 4 up, 8 down) ahead of the Spark for each
;@ direction, same index as SparkSpeedX.
SparkWallAhead::
	db $01, $08, $02, $04, $01, $04, $02, $08

;@ def SparkHandler(slot: bc)
;@ path: enemy/spark
;@ Entities $16 and $17: the Sparks, electric balls that run along the walls (one way round for
;@ wEntityPrivate2 = 0, the other for 4) at one pixel per frame and hurt Link on touch. With a
;@ wall ahead they turn one way (direction + 1); when they lose the wall (no wall at all) they
;@ run on for 3 more frames and turn the other way (direction - 1) round the corner. The wall
;@ check only reports walls (hWallCheckOnly).
;@ test: skip draws sprites and calls banked helpers
SparkHandler::
;> hWallCheckOnly = 1
	ld a, $01
	ldh [hWallCheckOnly], a
;> hActiveEntitySpriteVariant = (hFrameCounter >> 1) & 1
	ldh a, [hFrameCounter]
	rra
	and $01
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, SparkSprites)
	ld de, SparkSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> SparkProbeWalls(slot)
	call SparkProbeWalls
;>@t4 i = wEntityPrivate1[slot] + wEntityPrivate2[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate2
;=@t4
	add hl, bc
	add [hl]
	ld e, a
;>@t5 if wEntityCollisions[slot] & mem[SparkWallAhead + i]:      # a wall ahead: turn
	ld hl, SparkWallAhead
	add hl, de
	push hl
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
;=@t5
	pop hl
	and [hl]
	jr nz, .turn
;>@tn     wEntityPrivate1[slot] += 1
;>@tn2     wEntityPrivate1[slot] &= 3

;> elif wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .timer

;>     if wEntityCollisions[slot] & 0x0F == 0:     # no wall any more: round the corner soon
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, .speed

;>         wEntityTimer[slot] = 9
	call GetEntityTimer
	ld [hl], $09
	jr .speed

.turn
;=@tn
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
;=@tn2
	ld a, [hl]
	and $03
	ld [hl], a
	jr .speed

.timer
;> elif wEntityTimer[slot] == 6:
	cp $06
	jr nz, .speed

;>     wEntityPrivate1[slot] = (wEntityPrivate1[slot] - 1) & 3
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
	ld a, [hl]
	and $03
	ld [hl], a

.speed
;>@t6 i = wEntityPrivate1[slot] + wEntityPrivate2[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate2
;=@t6
	add hl, bc
	add [hl]
	ld e, a
;> wEntitySpeedY[slot] = mem[SparkSpeedY + i]
	ld hl, SparkSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>@t7 i = wEntityPrivate1[slot] + wEntityPrivate2[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate2
;=@t7
	add hl, bc
	add [hl]
	ld e, a
;> sx = mem[SparkSpeedX + i]
	ld hl, SparkSpeedX
	add hl, de
	ld a, [hl]
;> wEntitySpeedX[slot] = sx
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ret


;@ def SparkProbeWalls(slot: bc)
;@ path: enemy/spark
;@ Finds the walls on all four sides of the Spark: runs the wall check once with speeds +1/+1
;@ and once with -1/-1 and keeps both results in wEntityCollisions; its real speeds are put back.
;@ test: skip calls the banked wall check
SparkProbeWalls::
;> sx = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedX[slot] = 1
	ld [hl], $01
;> sy = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedY[slot] = 1
	ld [hl], $01
;> EntityCheckWalls(slot)                      # right and down
	call EntityCheckWalls
;> walls = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	push af
;> wEntitySpeedX[slot] = 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $ff
;> wEntitySpeedY[slot] = 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $ff
;> EntityCheckWalls(slot)                      # left and up
	call EntityCheckWalls
;> wEntityCollisions[slot] |= walls
	ld hl, wEntityCollisions
	add hl, bc
	pop af
	or [hl]
	ld [hl], a
;> wEntitySpeedY[slot] = sy
	pop af
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = sx
	pop af
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ret


;@ path: enemy/keese
;@ The Keese's two frames for the two-sprite renderer (4 bytes each: left tile, attributes,
;@ right tile, mirrored): wings up (tile $42), wings down (tile $40).
KeeseSprites::
	db $42, $00, $42, $20, $40, $00, $40, $20

;@ path: enemy/keese
;@ The same two frames with tiles $62 / $60, used on map $0A.
KeeseSpritesAlt::
	db $62, $00, $62, $20, $60, $00, $60, $20
;@ path: enemy/keese
;@ Speed by flight angle (16 angles, clockwise on screen from 0 = right): y speed = byte [angle],
;@ x speed = byte [angle + 4], so the 20 bytes are one sine period (0, 5, 10, 13, 14, 13, 10, 5,
;@ 0, -5, -10, -13, -14, -13, -10, -5) plus its first quarter repeated for the cosine.
KeeseSine::
	db $00, $05, $0a, $0d, $0e, $0d, $0a, $05, $00, $fb, $f6, $f3, $f2, $f3, $f6, $fb
	db $00, $05, $0a, $0d

;@ path: enemy/keese
;@ The angle the Keese takes off at for each direction of Link (0 right, 1 left, 2 up, 3 down):
;@ $0C up, $04 down, $08 left, $00 right, a quarter turn away from him, so that turning clockwise
;@ it curves towards him.
KeeseStartAngle::
	db $0c, $04, $08, $00

;@ def KeeseHandler(slot: bc)
;@ path: enemy/keese
;@ Entity $19: the Keese, a bat. State 0: it sits still until Link comes within 32 pixels on both
;@ axes, then takes off. State 1: it flies for 80 to 143 frames in a curve, turning one angle step
;@ every 10 frames (clockwise at first, now and then reversing at random), flapping its wings
;@ every 8 frames, and lands again for 32 frames.
;@ test: skip draws sprites and calls banked helpers
KeeseHandler::
;> sprites = KeeseSpritesAlt if hMapId == 0x0A else KeeseSprites
	ld de, KeeseSprites
	ldh a, [hMapId]
	cp $0a
	jr nz, .draw

	ld de, KeeseSpritesAlt

.draw
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)
	call EntityCheckHits
;> KeeseStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/keese
;@ Keese states: 0 KeeseRest, 1 KeeseFly.
KeeseStates::
	dw KeeseRest
	dw KeeseFly

;@ def KeeseRest(slot: bc)
;@ path: enemy/keese
;@ State 0: sitting. After its rest timer, when Link is within 32 pixels on both axes, it picks
;@ the start angle from Link's direction, a flight time of 80 to 143 frames and turn step +1, and
;@ takes off (state 1).
;@ test: skip bank-0 helpers
KeeseRest::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     pass                                   # on at the frame code at the end of KeeseFly
	jp nz, KeeseFly.setFrame

;> dx = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;> if u8(dx + 0x20) >= 0x40:
	add $20
	cp $40
;>     pass                                   # on at the frame code at the end of KeeseFly
	jp nc, KeeseFly.setFrame

;> dy = GetEntityYDistanceToLink_06(slot)
	call GetEntityYDistanceToLink_06
;> if u8(dy + 0x20) >= 0x40:
	add $20
	cp $40
;>     pass                                   # on at the frame code at the end of KeeseFly
	jp nc, KeeseFly.setFrame

;> angle = mem[KeeseStartAngle + GetEntityDirectionToLink_06(slot)]
	call GetEntityDirectionToLink_06
	ld d, $00
	ld hl, KeeseStartAngle
	add hl, de
	ld a, [hl]
;> wEntityPrivate1[slot] = angle
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wEntityTimer[slot] = 0x50 + GetRandomByte() & 0x3F
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $50
	ld [hl], a
;> wEntityPrivate2[slot] = 1                 # turn step
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $01
;> wEntityState[slot] += 1
	call IncrementEntityState
;> pass                                   # on at the frame code at the end of KeeseFly
	jp KeeseFly.setFrame


;@ def KeeseFly(slot: bc)
;@ path: enemy/keese
;@ State 1: flying. Moves (stopped by walls); when the flight timer runs out it lands for 32
;@ frames (state 0). Every 10 frames (wEntityPrivate3) the angle turns by the turn step and the
;@ speed is read from KeeseSine; then, 1 time in 32, a new random turn step (+1 or -1).
;@ The shared tail (KeeseFrame) sets the frame: wings still while sitting, flapping every 8 frames
;@ in flight.
;@ test: skip bank-0 helpers
KeeseFly::
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .setEntityPrivate3

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     pass                                   # on at the frame code at the end of KeeseFly
	jr .setFrame

.setEntityPrivate3
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;> if wEntityPrivate3[slot] < 10:
	ld a, [hl]
	cp $0a
;>     pass                                   # on at the frame code at the end of KeeseFly
	jr c, .setFrame

;> wEntityPrivate3[slot] = 0
	ld [hl], b
;>@t1 wEntityPrivate1[slot] = (wEntityPrivate1[slot] + wEntityPrivate2[slot]) & 0x0F
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
;=@t1
	and $0f
	ld [hl], a
;> angle = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;> wEntitySpeedY[slot] = mem[KeeseSine + angle]
	ld hl, KeeseSine
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = mem[KeeseSine + angle + 4]
	ld hl, KeeseSine + 4
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> if GetRandomByte() & 0x1F == 0:
	call GetRandomByte
	and $1f
	jr nz, .setFrame

;>     wEntityPrivate2[slot] = (GetRandomByte() & 2) - 1      # +1 or -1
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

.setFrame
;> frame = 0                    # KeeseFrame, the shared tail
;> if hActiveEntityState != 0:
	ldh a, [hActiveEntityState]
	and a
	jr z, .setEntitySpriteVariant

;>     frame = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, frame)
	jp SetEntitySpriteVariant


;@ def OwlEventHandler(slot: bc)
;@ path: npc/owl
;@ Entity $41: the owl, who flies in to give Link advice. Whether it shows up depends on the room:
;@ room $64 only once indoor room $1E3 has bit 6 and not after the fifth dungeon's instrument;
;@ room $AC only with room bit 4 set; room $41 waits for the Tail Key (and for its wEntityTimer1);
;@ room $EE needs the Angler Key; rooms $D2 and $36 the first dungeon's instrument ($36 also
;@ needs BowWow following and not the second instrument); room $08 leaves after the eighth
;@ instrument and waits for room $08 bit 4; room $9D needs the fifth instrument, room $06 waits
;@ for room $06 bit 4, room $B6 needs the third, rooms $17 / $9C the sixth and room $16 the
;@ second instrument. It blinks now and then.
;@ States: 0 OwlEventWait (start its music, flies in or, in rooms $16, $36 and $D2, sits there),
;@ 1 OwlEventFlyIn (glides down in front of Link), 2 OwlEventTalk (speaks once the screen is faded in),
;@ 3 OwlEventAfterTalk (marks the room done), 4 OwlEventFlyAway (rises and flies off, then the area music
;@ comes back).
;@ test: skip draws sprites, opens dialogs and calls banked helpers
OwlEventHandler::
;> wOwlSlot = slot
	ld a, c
	ld [wOwlSlot], a
;> if hMapRoom == 0x64:
	ldh a, [hMapRoom]
	cp $64
	jr nz, .checkMapRoom

;>     if not wRoomStatus[0x1E3] & 0x40:
	ld a, [wRoomStatus + $1e3]
	and $40
;>         return
	ret z

;>     if wDungeonFlags[4] & 2:
	ld a, [wDungeonFlags + 4]
	and $02
;>         return ClearEntityStatus_06(slot)
	jp nz, ClearEntityStatus_06

.checkMapRoom
;> if hMapRoom == 0xAC and not hRoomStatus & 0x10:
	ldh a, [hMapRoom]
	cp $ac
	jr nz, .checkMapRoom2

	ldh a, [hRoomStatus]
	and $10
;>     return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

.checkMapRoom2
;> if hMapRoom == 0x41:
	ldh a, [hMapRoom]
	cp $41
	jr nz, .checkMapRoom3

;>     if not wKeyItemFlags[0]:                # the Tail Key
	ld a, [wKeyItemFlags]
	and a
;>         return
	ret z

;>     if GetEntityTimer1(slot):
	call GetEntityTimer1
;>         return
	ret nz

.checkMapRoom3
;> if hMapRoom == 0xEE:
	ldh a, [hMapRoom]
	cp $ee
	jr nz, .checkMapRoom4

;>     need = wKeyItemFlags[1]                 # the Angler Key; then the check below
	ld a, [wKeyItemFlags + 1]
	and a
	jr .checkNeed

.checkMapRoom4
;> elif hMapRoom == 0xD2 or hMapRoom == 0x36:
	ldh a, [hMapRoom]
	cp $d2
	jr z, .setFlags

	cp $36
	jr nz, .checkMapRoom5

;>     if hMapRoom == 0x36 and wHasInstrument2:
	ld a, [wHasInstrument2]
	and a
;>         return ClearEntityStatus_06(slot)
	jp nz, ClearEntityStatus_06

;>     if hMapRoom == 0x36 and wIsBowWowFollowingLink != 1:
	ld a, [wIsBowWowFollowingLink]
	cp $01
;>         return ClearEntityStatus_06(slot)
	jp nz, ClearEntityStatus_06

.setFlags
;>     flags = wDungeonFlags[0]                # then the check below
	ld a, [wDungeonFlags]
	jr .setNeed

.checkMapRoom5
;> elif hMapRoom == 0x08:
	ldh a, [hMapRoom]
	cp $08
	jr nz, .checkMapRoom6

;>     if wDungeonFlags[7] & 2:
	ld a, [wDungeonFlags + 7]
	and $02
;>         return ClearEntityStatus_06(slot)
	jp nz, ClearEntityStatus_06

;>     if not wRoomStatus[0x08] & 0x10:
	ld a, [wRoomStatus + $08]
	and $10
;>         return
	ret z

	jr .checkMapRoom11

.checkMapRoom6
;> elif hMapRoom == 0x9D:
	cp $9d
	jr nz, .checkMapRoom7

;>     flags = wDungeonFlags[4]                # then the check below
	ld a, [wDungeonFlags + 4]
	jr .setNeed

.checkMapRoom7
;> elif hMapRoom == 0x06:
	cp $06
	jr nz, .checkMapRoom8

;>     if not wRoomStatus[0x06] & 0x10:
	ld a, [wRoomStatus + $06]
	and $10
;>         return
	ret z

	jr .checkMapRoom11

.checkMapRoom8
;> elif hMapRoom == 0xB6:
	cp $b6
	jr nz, .checkMapRoom9

;>     flags = wDungeonFlags[2]                # then the check below
	ld a, [wDungeonFlags + 2]
	jr .setNeed

.checkMapRoom9
;> elif hMapRoom == 0x17 or hMapRoom == 0x9C:
	cp $17
	jr z, .setFlags2

	cp $9c
	jr nz, .checkMapRoom10

.setFlags2
;>     flags = wDungeonFlags[5]                # then the check below
	ld a, [wDungeonFlags + 5]
	jr .setNeed

.checkMapRoom10
;> elif hMapRoom == 0x16:
	cp $16
	jr nz, .checkMapRoom11

;>     flags = wHasInstrument2
	ld a, [wHasInstrument2]

.setNeed
;>     need = flags & 2                       # the dungeon's instrument
	and $02

.checkNeed
;>     if not need:
;>         return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

.checkMapRoom11
;>@t1 if hMapRoom == 0xD2 or hMapRoom == 0x16 or hMapRoom == 0x36 or hActiveEntityState != 0:
	ldh a, [hMapRoom]
	cp $d2
	jr z, .owlEventDraw

	cp $16
	jr z, .owlEventDraw

;=@t1
	cp $36
	jr z, .owlEventDraw

	ldh a, [hActiveEntityState]
	cp $00
	jr z, .setFrame

.owlEventDraw
;>     OwlEventDraw(slot)
	call OwlEventDraw

.setFrame
;> frame = 1 if hFrameCounter & 0xB0 == 0 else 0     # blinks
	ldh a, [hFrameCounter]
	and $b0
	ld a, $00
	jr nz, .setEntitySpriteVariant

	inc a

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return
	ret nz

;> OwlEventStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/owl
;@ Owl states: 0 OwlEventWait, 1 OwlEventFlyIn, 2 OwlEventTalk, 3 OwlEventAfterTalk, 4 OwlEventFlyAway.
OwlEventStates::
	dw OwlEventWait
	dw OwlEventFlyIn
	dw OwlEventTalk
	dw OwlEventAfterTalk
	dw OwlEventFlyAway

;@ def OwlEventWait(slot: bc)
;@ path: npc/owl
;@ State 0. In room $F2 the area music becomes track $1D and the owl waits until Link walks down
;@ to y $44 within 24 pixels of x $58; elsewhere it leaves if Link has no sword yet. Then it keeps
;@ the area music (wEntityPrivate1) and plays the owl's theme (track $22). In rooms $16, $36 and
;@ $D2 it is already sitting there (state 2); elsewhere it starts 32 pixels up with speed (+$18,
;@ +$10) and flies in (state 1).
;@ test: skip bank-0 helpers
OwlEventWait::
;> if hMapRoom == 0xF2:
	ldh a, [hMapRoom]
	cp $f2
	jr nz, .checkSwordLevel

;>     hDefaultMusicTrack = 0x1D
	ld a, $1d
	ldh [hDefaultMusicTrack], a
;>     if hLinkY < 0x44:
	ldh a, [hLinkY]
	cp $44
;>         return
	ret c

;>     if u8(hLinkX - 0x58 + 0x18) >= 0x30:
	ldh a, [hLinkX]
	sub $58
	add $18
	cp $30
;>         return
	ret nc

	jr .setEntityPrivate1

.checkSwordLevel
;> elif not wSwordLevel:
	ld a, [wSwordLevel]
	and a
;>     return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

.setEntityPrivate1
;> wEntityPrivate1[slot] = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wMusicTrackToPlay = 0x22
	ld a, $22
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrack = 0x22
	ldh [hDefaultMusicTrack], a
;> hDefaultMusicTrackAlt = 0x22
	ldh [hDefaultMusicTrackAlt], a
;>@t2 if hMapRoom == 0x16 or hMapRoom == 0x36 or hMapRoom == 0xD2:
	ldh a, [hMapRoom]
	cp $16
	jr z, .setEntityState

	cp $36
	jr z, .setEntityState

;=@t2
	cp $d2
	jr nz, .setEntityZ

.setEntityState
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
	ret


.setEntityZ
;> wEntityZ[slot] = 0x20
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $20
;> wEntitySpeedX[slot] = 0x18
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $18
;> wEntitySpeedY[slot] = 0x10
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $10
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def OwlEventFlyIn(slot: bc)
;@ path: npc/owl
;@ State 1: Link turns to the owl and stands still while it flaps and sinks 1/4 pixel per frame,
;@ slowing down by one speed step every 4 frames; when it reaches the ground it talks (state 2).
;@ test: skip bank-0 helpers
OwlEventFlyIn::
;> hLinkDirection = GetEntityDirectionToLink_06(slot) ^ 1
	call GetEntityDirectionToLink_06
	ld a, e
	xor $01
	ldh [hLinkDirection], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkPoseLock = 5
	ld a, $05
	ld [wLinkPoseLock], a
;> OwlEventFlap()
	call OwlEventFlap
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> if wEntityZ[slot] == 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .setEntitySpeedZ

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret


.setEntitySpeedZ
;> wEntitySpeedZ[slot] = -4
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $fc
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> PlayPeriodicNoiseSfx()
	call PlayPeriodicNoiseSfx
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .return

;>     OwlEventStepSpeed(wEntitySpeedY, 0)
	ld a, $00
	ld hl, wEntitySpeedY
	call OwlEventStepSpeed
;>     OwlEventStepSpeed(wEntitySpeedX, 0)
	ld a, $00
	ld hl, wEntitySpeedX
	call OwlEventStepSpeed

.return
	ret


;@ def OwlEventTalk(slot: bc)
;@ path: npc/owl
;@ State 2: sits (solid for Link). As soon as the screen has faded in (and the debug toggle is
;@ off) it speaks: text $CD in room $06, otherwise the room's text (OpenRoomDialog), typed with
;@ sound $19; then state 3 with 16 frames.
;@ test: skip opens a dialog
OwlEventTalk::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> BlockLinkIfTouching_06(slot)
	call BlockLinkIfTouching_06
;> if wTransitionSequenceCounter != 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	ret nz

;> if wDebugToggle:
	ld a, [wDebugToggle]
	and a
;>     return
	ret nz

;> if hMapRoom == 0x06:
	ldh a, [hMapRoom]
	cp $06
	jr nz, .otherwise

;>     OpenDialog(0xCD)
	ld a, $cd
	call OpenDialog
	jr .setDialogSfx

.otherwise
;> else:
;>     OpenRoomDialog()
	call OpenRoomDialog

.setDialogSfx
;> wDialogSfx = 0x19
	ld a, $19
	ld [wDialogSfx], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
	ret


;@ def OwlEventAfterTalk(slot: bc)
;@ path: npc/owl
;@ State 3 (runs once the text box is closed): in room $06 the owl stays; elsewhere it flaps for
;@ 16 frames and flies away (state 4). Either way the room is marked (bit 5 of its wRoomStatus)
;@ so the owl does not come again.
;@ test: skip bank-0 helpers
OwlEventAfterTalk::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if hMapRoom != 0x06:
	ldh a, [hMapRoom]
	cp $06
	jr z, .setRoomStatus

;>     if wEntityTimer[slot]:
	call GetEntityTimer
;>         return OwlEventFlap()
	jr nz, OwlEventFlap

;>     wEntityState[slot] += 1
	call IncrementEntityState

.setRoomStatus
;>@t1 wRoomStatus[hMapRoom] |= 0x20
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld hl, wRoomStatus
	add hl, de
;=@t1
	set 5, [hl]
	ret


;@ def OwlEventFlap()
;@ path: npc/owl
;@ Holds Link still and shows the flapping frames: 0 and 2 (wings spread) every 8 frames.
;@ test: skip bank-0 helpers
OwlEventFlap::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> SetEntitySpriteVariant((hFrameCounter >> 2) & 2)
	ldh a, [hFrameCounter]
	rra
	rra
	and $02
	call SetEntitySpriteVariant
	ret


;@ def OwlEventFlyAway(slot: bc)
;@ path: npc/owl
;@ State 4: flaps and rises half a pixel per frame while it speeds up away from Link (every other
;@ frame one step towards the opposite of a speed-$20 vector to Link), with a wing sound every 8
;@ frames. Once it has left the screen (CrowRemoveOffscreen frees it) the area music it kept comes
;@ back (track $49 while a Piece of Power is active).
;@ test: skip bank-0 helpers
OwlEventFlyAway::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> OwlEventFlap()
	call OwlEventFlap
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> CrowRemoveOffscreen(slot)
	call CrowRemoveOffscreen
;> wEntitySpeedZ[slot] = 4
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $04
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> if wEntityStatus[slot] == 0:               # gone
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkFrameCounter

;>     wMusicTrackToPlay = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld [wMusicTrackToPlay], a
;>     hDefaultMusicTrack = wEntityPrivate1[slot]
	ldh [hDefaultMusicTrack], a
;>     if wActivePowerUp:
	ld a, [wActivePowerUp]
	and a
	jr z, .return

;>         wMusicTrackToPlay = 0x49
	ld a, $49
	ld [wMusicTrackToPlay], a
;>         hDefaultMusicTrackAlt = 0x49
	ldh [hDefaultMusicTrackAlt], a

.return
;>     return
	ret


.checkFrameCounter
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .checkFrameCounter2

;>     hNoiseSfx = 5
	ld a, $05
	ldh [hNoiseSfx], a

.checkFrameCounter2
;> if hFrameCounter & 1:
	ldh a, [hFrameCounter]
	and $01
;>     return
	jr nz, OwlEventStepSpeed.return

;> vy, vx = GetVectorTowardsLink(slot, 0x20)
	ld a, $20
	call GetVectorTowardsLink
;> OwlEventStepSpeed(wEntitySpeedY, -hMultiPurpose0)
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	call OwlEventStepSpeed
;> OwlEventStepSpeed(wEntitySpeedX, -hMultiPurpose1)      # (falls through)
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX

;@ def OwlEventStepSpeed(speeds: hl, target: a, slot: bc)
;@ path: npc/owl
;@ Moves speeds[slot] one step (1) towards the target value.
;@ test: skip pointer argument
OwlEventStepSpeed::
;> diff = target - speeds[slot]
	add hl, bc
	sub [hl]
;> if diff == 0:
;>     return
	jr z, .return

;> if diff & 0x80:
	bit 7, a
	jr z, .setSpeeds

;>     speeds[slot] -= 2                      # -1 together with the +1 below
	dec [hl]
	dec [hl]

.setSpeeds
;> speeds[slot] += 1
	inc [hl]

.return
	ret


;@ path: npc/owl
;@ The sitting owl for the two-sprite renderer, 4 bytes per frame (left tile, attributes, right
;@ tile, attributes): frame 0 eyes open (tile $78), frame 1 blinking (tile $7A); both halves
;@ mirrored.
OwlEventSprites::
	db $78, $00, $78, $20, $7a, $00, $7a, $20

;@ path: npc/owl
;@ The owl with spread wings (frames 2 and up): 4 sprites of y, x, tile, attributes relative to
;@ the entity: (0, -8, $7C), (0, 0, $7E), (0, 8, $7E mirrored), (0, 16, $7C mirrored).
OwlEventSpreadOAM::
	db $00, $f8, $7c, $00, $00, $00, $7e, $00
	db $00, $08, $7e, $20, $00, $10, $7c, $20

;@ def OwlEventDraw(slot: bc)
;@ path: npc/owl
;@ Draws the owl: frames 0 and 1 from OwlEventSprites, the wide frame from OwlEventSpreadOAM (4 sprites)
;@ with its shadow, except in room $08, where bit 4 of wEntityPhysicsFlags is cleared instead.
;@ test: skip draws sprites
OwlEventDraw::
;> if hActiveEntitySpriteVariant < 2:
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nc, .drawEntitySprites

;>     return DrawEntity16x16(slot, OwlEventSprites)
	ld de, OwlEventSprites
	jp DrawEntity16x16


.drawEntitySprites
;> DrawEntitySprites(OwlEventSpreadOAM, 4)
	ld hl, OwlEventSpreadOAM
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
;> if hMapRoom != 0x08:
	ldh a, [hMapRoom]
	cp $08
	jr z, .setEntityPhysicsFlags

;>     DrawEntityShadow(slot)
	call DrawEntityShadow
;>     return
	ret


.setEntityPhysicsFlags
;> wEntityPhysicsFlags[slot] &= ~0x10
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 4, [hl]
	ret


;@ path: npc/telephone
;@ The telephone for the two-sprite renderer: tiles $50 and $52 side by side (attributes 0).
TelephoneSprites::
	db $50, $00, $52, $00

;@ def TelephoneHandler(slot: bc)
;@ path: npc/telephone
;@ Entity $80: the telephone in the phone booths. When Link talks to it, Ulrira gives the hint
;@ for the first thing still missing on the way through the game: hint(t) opens text t (texts
;@ $1xx with OpenDialogTable1, $2xx with OpenDialogTable2) and marks that Link has phoned
;@ (bit 5 of wRoomStatus[$2A9]). In room $A9 the phone gets the Bucket Mouse instead (text $1FD).
;@ The checks, in order: first call ($141), first instrument ($146), BowWow kidnapped ($142),
;@ second instrument ($143), BowWow still on its chain ($244), Richard's quest ($144), trade item
;@ before the stick ($145), fewer than 5 golden leaves ($147), the 5th / 6th leaf ($148), third
;@ instrument ($149), Angler Key ($14A), fourth instrument ($240), with the ghost along: room
;@ $1E3 bit 6 ($14B), fifth instrument ($14C), Frog's Song of Soul ($245), sixth instrument
;@ ($14D), with the rooster along: Bird Key ($246), seventh instrument ($14E, or $241 with the
;@ rooster and the Bird Key), room $10 bits 4/5 ($14F), eighth instrument ($248), room $06
;@ bits 4/5 ($242), room $274 bit 6 ($243), Level-2 sword ($247), and at last $248.
;@ test: skip opens a dialog
TelephoneHandler::
;> hActiveEntityDrawY -= 5
	ldh a, [hActiveEntityDrawY]
	sub $05
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(slot, TelephoneSprites)
	ld de, TelephoneSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if not ShouldLinkTalkToEntity_06():
	call ShouldLinkTalkToEntity_06
;>     return
	ret nc

;> if hMapRoom == 0xA9: return OpenDialogTable1(0xFD)      # hint: text $1FD
	ld e, $fd
	ldh a, [hMapRoom]
	cp $a9
	jp z, .openDialogTable1

;> if not wRoomStatus[0x2A9] & 0x20: return OpenDialogTable1(0x41)      # hint: text $141
	ld e, $41
	ld a, [wRoomStatus + $2a9]
	and $20
	jp z, .openDialogTable1

;> if not wDungeonFlags[0] & 2: return OpenDialogTable1(0x46)      # hint: text $146
	ld e, $46
	ld a, [wDungeonFlags]
	and $02
	jp z, .openDialogTable1

;> if wIsBowWowFollowingLink == 0x80: return OpenDialogTable1(0x42)      # hint: text $142
	ld e, $42
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp z, .openDialogTable1

;> if not wHasInstrument2 & 2: return OpenDialogTable1(0x43)      # hint: text $143
	ld e, $43
	ld a, [wHasInstrument2]
	and $02
	jp z, .openDialogTable1

;> if wIsBowWowFollowingLink == 1: return OpenDialogTable2(0x44)      # hint: text $244
	ld e, $44
	ld a, [wIsBowWowFollowingLink]
	cp $01
	jp z, .openDialogTable2

;> if wRichardQuest != 2: return OpenDialogTable1(0x44)      # hint: text $144
	ld e, $44
	ld a, [wRichardQuest]
	cp $02
	jp nz, .openDialogTable1

;> if wTradeSequenceItem < 5: return OpenDialogTable1(0x45)      # hint: text $145
	ld e, $45
	ld a, [wTradeSequenceItem]
	cp $05
	jp c, .openDialogTable1

;> if wGoldenLeaves < 5: return OpenDialogTable1(0x47)      # hint: text $147
	ld e, $47
	ld a, [wGoldenLeaves]
	cp $05
	jp c, .openDialogTable1

;> if wGoldenLeaves == 5: return OpenDialogTable1(0x48)      # hint: text $148
	ld e, $48
	jp z, .openDialogTable1

;> if wGoldenLeaves != 6: return OpenDialogTable1(0x48)      # hint: text $148
	cp $06
	jp nz, .openDialogTable1

;> if not wDungeonFlags[2] & 2: return OpenDialogTable1(0x49)      # hint: text $149
	ld e, $49
	ld a, [wDungeonFlags + 2]
	and $02
	jp z, .openDialogTable1

;> if not wKeyItemFlags[1]: return OpenDialogTable1(0x4A)      # hint: text $14A          # the Angler Key
	ld e, $4a
	ld a, [wKeyItemFlags + 1]
	and a
	jp z, .openDialogTable1

;> if not wDungeonFlags[3] & 2: return OpenDialogTable2(0x40)      # hint: text $240
	ld e, $40
	ld a, [wDungeonFlags + 3]
	and $02
	jp z, .openDialogTable2

;> if wIsGhostFollowingLink:
	ld a, [wIsGhostFollowingLink]
	and a
	jr z, .checkDungeonFlags

;>     if not wRoomStatus[0x1E3] & 0x40: return OpenDialogTable1(0x4B)      # hint: text $14B
	ld e, $4b
	ld a, [wRoomStatus + $1e3]
	and $40
	jr z, .openDialogTable1

.checkDungeonFlags
;> if not wDungeonFlags[4] & 2: return OpenDialogTable1(0x4C)      # hint: text $14C
	ld e, $4c
	ld a, [wDungeonFlags + 4]
	and $02
	jr z, .openDialogTable1

;> if not wOcarinaSongFlags & 1: return OpenDialogTable2(0x45)      # hint: text $245    # Frog's Song of Soul
	ld e, $45
	ld a, [wOcarinaSongFlags]
	and $01
	jp z, .openDialogTable2

;> if not wDungeonFlags[5] & 2: return OpenDialogTable1(0x4D)      # hint: text $14D
	ld e, $4d
	ld a, [wDungeonFlags + 5]
	and $02
	jr z, .openDialogTable1

;> e = 0x4E
	ld e, $4e
;> if wIsRoosterFollowingLink:
	ld a, [wIsRoosterFollowingLink]
	and a
	jr z, .checkDungeon7Flags

;>     if not wKeyItemFlags[3]: return OpenDialogTable2(0x46)      # hint: text $246     # the Bird Key
	ld e, $46
	ld a, [wKeyItemFlags + 3]
	and a
	jp z, .openDialogTable2

;>     e = 0x41
	ld e, $41

.checkDungeon7Flags
;> if not wDungeon7Flags & 2:
	ld a, [wDungeon7Flags]
	and $02
	jr nz, .checkRoomStatus

;>     if e == 0x4E: return OpenDialogTable1(0x4E)      # hint: text $14E
	ld a, e
	cp $4e
	jr z, .openDialogTable1

;>     return OpenDialogTable2(0x41)      # hint: text $241
	jr .openDialogTable2

.checkRoomStatus
;> if not wRoomStatus[0x10] & 0x30: return OpenDialogTable1(0x4F)      # hint: text $14F
	ld e, $4f
	ld a, [wRoomStatus + $10]
	and $30
	jr z, .openDialogTable1

;> if not wDungeonFlags[7] & 2: return OpenDialogTable2(0x48)      # hint: text $248
	ld e, $48
	ld a, [wDungeonFlags + 7]
	and $02
	jr z, .openDialogTable2

;> if not wRoomStatus[0x06] & 0x30: return OpenDialogTable2(0x42)      # hint: text $242
	ld e, $42
	ld a, [wRoomStatus + $06]
	and $30
	jr z, .openDialogTable2

;> if not wRoomStatus[0x274] & 0x40: return OpenDialogTable2(0x43)      # hint: text $243
	ld e, $43
	ld a, [wRoomStatus + $274]
	and $40
	jr z, .openDialogTable2

;> if wSwordLevel < 2: return OpenDialogTable2(0x47)      # hint: text $247
	ld e, $47
	ld a, [wSwordLevel]
	cp $02
	jr c, .openDialogTable2

;> return OpenDialogTable2(0x48)      # hint: text $248
	ld e, $48
	jr .openDialogTable2

.openDialogTable1
;> OpenDialogTable1(e)                     # hint(): text $100 + e
	ld a, e
	call OpenDialogTable1
	jr .setRoomStatus

.openDialogTable2
;> OpenDialogTable2(e)                     # hint(): text $200 + e
	ld a, e
	call OpenDialogTable2

.setRoomStatus
;> wRoomStatus[0x2A9] |= 0x20               # Link has phoned
	ld hl, wRoomStatus + $2a9
	set 5, [hl]
	ret


;@ path: object/butterfly
;@ The butterfly for the one-sprite renderer (8x16), 2 bytes per frame (tile, attributes):
;@ tile $5E, then the same tile flipped upside down (wings beating).
ButterflySprites::
	db $5e, $00, $5e, $40

;@ path: object/butterfly
;@ Random jitter added to the butterfly's base speed, one of 8 picked at random:
;@ 4, -4, 3, -3, 2, -2, 5, -6.
ButterflySpeedJitter::
	db $04, $fc, $03, $fd, $02, $fe, $05, $fa

;@ def ButterflyHandler(slot: bc)
;@ path: object/butterfly
;@ Entity $6E: a butterfly. It flutters (wings beat every 8 frames) on a 64-frame cycle offset by
;@ its slot (kept in hActiveEntityState): every 32 frames it gets a new x speed and 16 frames
;@ later a new y speed, each its base speed plus a random jitter; every 64 frames the base
;@ speeds (wEntityPrivate1 / 2) are set to a speed-2 vector towards Link, or towards Marin while
;@ she sings.
;@ test: skip draws sprites and calls banked helpers
ButterflyHandler::
;> if hActiveEntitySpriteVariant == 1:
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr nz, .drawEntity8x16

;>     hActiveEntityDrawY -= 0
	ldh a, [hActiveEntityDrawY]
	sub $00
	ldh [hActiveEntityDrawY], a

.drawEntity8x16
;> DrawEntity8x16(slot, ButterflySprites)
	ld de, ButterflySprites
	call DrawEntity8x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;>@t1 t = u8(slot * 8 + hFrameCounter)
	ld a, c
	sla a
	sla a
	sla a
	ld hl, hFrameCounter
;=@t1
	add [hl]
;> hActiveEntityState = t
	ldh [hActiveEntityState], a
;> SetEntitySpriteVariant(slot, (t >> 3) & 1)
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> if t & 0x1F == 0:
	ldh a, [hActiveEntityState]
	and $1f
	jr nz, .checkT

;>@t2     jitter = mem[ButterflySpeedJitter + (GetRandomByte() & 7)]
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, ButterflySpeedJitter
	add hl, de
;=@t2
	ld a, [hl]
;>     wEntitySpeedX[slot] = u8(wEntityPrivate1[slot] + jitter)
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

.checkT
;> if (t + 0x10) & 0x1F == 0:
	ldh a, [hActiveEntityState]
	add $10
	and $1f
	jr nz, .checkT2

;>@t3     jitter = mem[ButterflySpeedJitter + (GetRandomByte() & 7)]
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, ButterflySpeedJitter
	add hl, de
;=@t3
	ld a, [hl]
;>     wEntitySpeedY[slot] = u8(wEntityPrivate2[slot] + jitter)
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.checkT2
;> if t & 0x3F:
	ldh a, [hActiveEntityState]
	and $3f
;>     return
	jr nz, .return

;> savedX = hLinkX
	ldh a, [hLinkX]
	push af
;> savedY = hLinkY
	ldh a, [hLinkY]
	push af
;> if wSingingMarinSlot != 0xFF:              # aim at Marin instead: put her place in hLinkX / Y
	ld a, [wSingingMarinSlot]
	cp $ff
	jr z, .getVectorTowardsLink

;>     hLinkX = wEntityX[wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;>     hLinkY = wEntityY[wSingingMarinSlot]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a

.getVectorTowardsLink
;> GetVectorTowardsLink(slot, 2)
	ld a, $02
	call GetVectorTowardsLink
;> hLinkY = savedY
	pop af
	ldh [hLinkY], a
;> hLinkX = savedX
	pop af
	ldh [hLinkX], a
;> wEntityPrivate2[slot] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityPrivate1[slot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a

.return
	ret


;@ def RollingBonesHandler(slot: bc)
;@ path: boss/rolling_bones
;@ Entity $81: Rolling Bones, the miniboss who pushes the spiked bar (entity $82) across the room.
;@ It keeps its slot in wEntityScratch2 for the bar. While alive: RollingBonesFight. When it is
;@ beaten it flashes and explodes (RollingBonesDyingSteps): 0 RollingBonesDyingStart,
;@ 1 RollingBonesDyingExplode.
;@ test: skip draws sprites and calls banked helpers
RollingBonesHandler::
;> wEntityScratch2 = slot
	ld a, c
	ld [wEntityScratch2], a
;> if hMapId == 7:
	ldh a, [hMapId]
	cp $07
	jr nz, .rollingBonesDraw

;>     hActiveEntityTileOffset = 0x10
	ld a, $10
	ldh [hActiveEntityTileOffset], a

.rollingBonesDraw
;> RollingBonesDraw(slot)
	call RollingBonesDraw
;> StartBossMusic(slot)
	call StartBossMusic
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> if hActiveEntityStatus == 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return RollingBonesFight(slot)
	jr z, RollingBonesFight

;> wEntityOptions1[slot] = 0x80
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $80
;> RollingBonesDyingSteps[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/rolling_bones
;@ Rolling Bones' dying steps (index wEntityPrivate1): 0 RollingBonesDyingStart,
;@ 1 RollingBonesDyingExplode.
RollingBonesDyingSteps::
	dw RollingBonesDyingStart
	dw RollingBonesDyingExplode

;@ def RollingBonesDyingStart(slot: bc)
;@ path: boss/rolling_bones
;@ Starts the end: 255 frames of flashing.
;@ test: slot = rng.randrange(16)
;@ test: wEntityPrivate1[slot] = 0
;@ test: wCurrentBank = $06
RollingBonesDyingStart::
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ret


;@ def RollingBonesDyingExplode(slot: bc)
;@ path: boss/rolling_bones
;@ Flashes for the rest of the timer, with explosions over it in the last 128 frames; then
;@ RollingBonesDefeated: the area music comes back, it is removed with its drop and (outside
;@ map 7) the room is marked beaten (MarkMinibossBeaten).
;@ test: skip bank-0 helpers
RollingBonesDyingExplode::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
;>     return RollingBonesDefeated()
	jp z, RollingBonesDefeated

;> wEntityFlashTimer[slot] = t
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;> if t < 0x80:
	cp $80
	jr nc, .return

;>     MinibossExplosions(t)
	call MinibossExplosions

.return
	ret


RollingBonesDefeated:
;> # RollingBonesDefeated:
;> SelectAreaMusicFar()
	call SelectAreaMusicFar
;> DefeatEntityWithDrop(slot)
	call DefeatEntityWithDrop
;> if hMapId == 7:
	ldh a, [hMapId]
	cp $07
;>     return
	ret z

;> MarkMinibossBeaten()                   # (falls through)

;@ def MarkMinibossBeaten()
;@ path: boss/common
;@ Marks the current room's miniboss as beaten: bit 5 of its wRoomStatus entry in the indoor
;@ groups ($D900 + room for the maps below 6 and from $1A on, $DA00 + room for maps 6 to $19).
;@ test: skip writes room status
MarkMinibossBeaten::
;> room = hMapRoom
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
;> if 6 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .setRoomStatus

	cp $06
	jr c, .setRoomStatus

;>     room += 0x100
	inc d

.setRoomStatus
;> wRoomStatus[0x100 + room] |= 0x20
	ld hl, wRoomStatus + $100
	add hl, de
	set 5, [hl]
	ret


;@ def RollingBonesFight(slot: bc)
;@ path: boss/rolling_bones
;@ The living Rolling Bones: takes hits (its health goes to hMultiPurposeH for the states), faces
;@ the way it moves (wEntityDirection 0 left, 3 right: the first frame of its group), falls with
;@ gravity 2 per frame and thuds (hJingle $20) when it lands hard; hMultiPurposeG is the
;@ "landed this frame" flag. States: 0 RollingBonesWalkToBar, 1 RollingBonesPushBar,
;@ 2 RollingBonesAfterPush, 3 RollingBonesHop.
;@ test: skip calls banked helpers
RollingBonesFight::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)
	call EntityCheckHits
;> hMultiPurposeH = wEntityHealth[slot]
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
;> if wEntitySpeedX[slot]:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .addEntityZSpeedToPos

;>@t1     wEntityDirection[slot] = 0 if wEntitySpeedX[slot] & 0x80 else 3
	ld e, $00
	and $80
	jr nz, .setT

	ld e, $03

.setT
;=@t1
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.addEntityZSpeedToPos
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	nop
	nop
;> landed = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;> hMultiPurposeG = landed
	ldh [hMultiPurposeG], a
;> if landed:
	jr z, .setRollingBonesStates

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     fall = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;>     wEntitySpeedZ[slot] = 0
	ld [hl], b
;>     if fall < 0xF2:                       # a hard landing
	cp $f2
	jr nc, .setRollingBonesStates

;>         hJingle = 0x20
	ld a, $20
	ldh [hJingle], a

.setRollingBonesStates
;> RollingBonesStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/rolling_bones
;@ Rolling Bones' states: 0 RollingBonesWalkToBar, 1 RollingBonesPushBar, 2 RollingBonesAfterPush,
;@ 3 RollingBonesHop.
RollingBonesStates::
	dw RollingBonesWalkToBar
	dw RollingBonesPushBar
	dw RollingBonesAfterPush
	dw RollingBonesHop

;@ def RollingBonesWalkToBar(slot: bc)
;@ path: boss/rolling_bones
;@ State 0: after its pause, hops towards the spiked bar at half a pixel per frame (frame 1, a
;@ small jump of speed $0C at every landing); within 16 pixels of it, it gets ready to push
;@ (24 frames, state 1).
;@ test: skip bank-0 helpers
RollingBonesWalkToBar::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return
	jr nz, .return

;>@t2 dx = u8(hActiveEntityX - wEntityX[wEntityScratch1])
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
;=@t2
	sub [hl]
;>@t3 wEntitySpeedX[slot] = 8 if dx & 0x80 else -8
	ld e, $08
	bit 7, a
	jr nz, .setEntitySpeedX

	ld e, $f8

.setEntitySpeedX
;=@t3
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> if u8(dx + 0x10) < 0x20:
	add $10
	cp $20
	jr nc, .addEntitySpeedToPos

;>     wEntityTimer[slot] = 0x18
	call GetEntityTimer
	ld [hl], $18
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret


.addEntitySpeedToPos
;> AddEntitySpeedToPos_06(slot)
	call AddEntitySpeedToPos_06
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, .setEntitySpriteVariant

;>     wEntitySpeedZ[slot] = 0x0C
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant

.return
	ret


;@ def RollingBonesPushBar(slot: bc)
;@ path: boss/rolling_bones
;@ State 1: after 24 frames it shoves the bar: the bar rolls at one pixel per frame the way Rolling
;@ Bones faces (bar state 1); then 32 frames (state 2), frame 0.
;@ test: skip bank-0 helpers
RollingBonesPushBar::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return
	jr nz, .return

;>@t1 push = 0x10 if wEntityDirection[slot] else -0x10
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $10
	jr nz, .setEntitySpeedX

;=@t1
	ld a, $f0

.setEntitySpeedX
;>@t4 wEntitySpeedX[wEntityScratch1] = push
	push af
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
	ld hl, wEntitySpeedX
	add hl, de
;=@t4
	pop af
	ld [hl], a
;> wEntityState[wEntityScratch1] = 1
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wEntityState[slot] += 1
	call IncrementEntityState
;> SetEntitySpriteVariant(slot, 0)
	ld a, $00
	call SetEntitySpriteVariant

.return
	ret


;@ def RollingBonesAfterPush(slot: bc)
;@ path: boss/rolling_bones
;@ State 2: waits 32 frames, then starts hopping (state 3).
;@ test: skip bank-0 helpers
RollingBonesAfterPush::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .return

;>     wEntityState[slot] += 1
	call IncrementEntityState

.return
	ret


;@ def RollingBonesHop(slot: bc)
;@ path: boss/rolling_bones
;@ State 3: big hops after the bar (frame 1 near the ground, 2 above 8 pixels). Each hop (when
;@ the timer reaches 1) has speed $10 sideways and up/down towards the middle of the room
;@ (y $50) and jump speed $19, or $14 and $16 once its health is below 5; after landing it waits
;@ 16 frames. On reaching a side wall it stops and walks to the bar again after 8 frames (state 0).
;@ test: skip bank-0 helpers
RollingBonesHop::
;>@t2 frame = 1 if wEntityZ[slot] < 8 else 2
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $08
	ld a, $01
	jr c, .setEntitySpriteVariant

;=@t2
	inc a

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 1:
	cp $01
;>     pass                                   # on at hop                               # below
	jr z, .setSpeed

;> if t != 0:
	cp $00
;>     return
	jp nz, .return

;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, .updateEntityPosWithSpeed

;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     return
	ret


.setSpeed
;> # hop:
;> speed = 0x10
	ld e, $10
;> wEntitySpeedZ[slot] = 0x19
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $19
;> if hMultiPurposeH < 5:                    # health
	ldh a, [hMultiPurposeH]
	cp $05
	jr nc, .setEntitySpeedX

;>     speed = 0x14
	ld e, $14
;>     wEntitySpeedZ[slot] = 0x16
	ld [hl], $16

.setEntitySpeedX
;>@t5 wEntitySpeedX[slot] = speed if wEntityDirection[slot] else -speed
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, e
	jr nz, .setEntitySpeedX2

;=@t5
	cpl
	inc a

.setEntitySpeedX2
;=@t5
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>@t6 wEntitySpeedY[slot] = speed if hActiveEntityDrawY < 0x50 else -speed
	ldh a, [hActiveEntityDrawY]
	cp $50
	ld a, e
	jr c, .setEntitySpeedY

	cpl
	inc a

.setEntitySpeedY
;=@t6
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.updateEntityPosWithSpeed
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 3:            # a side wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .return

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed

.return
	ret


;@ path: boss/rolling_bones
;@ Rolling Bones' frames for DrawEntitySprites: 6 frames of 4 sprites (y, x, tile, attributes;
;@ relative to the entity). Index = frame (0 standing, 1 low, 2 high in the air) + its facing
;@ (0 left, 3 right). Facing left: body tiles $60 / $62 / $64 (or $66 / $68 / $6A) at x -8, 0, 8
;@ and the bone ($6E) 16 pixels above at x 0 (x 6 in frame 2); facing right the same mirrored
;@ (body at x 0, 8, 16, bone at x 8 or 2).
RollingBonesOAM::
	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $f0, $00, $6e, $20
	db $00, $f8, $66, $00, $00, $00, $68, $00, $00, $08, $6a, $00, $f0, $00, $6e, $00
	db $00, $f8, $66, $00, $00, $00, $68, $00, $00, $08, $6a, $00, $f0, $06, $6e, $20
	db $00, $00, $64, $20, $00, $08, $62, $20, $00, $10, $60, $20, $f0, $08, $6e, $00
	db $00, $00, $6a, $20, $00, $08, $68, $20, $00, $10, $66, $20, $f0, $08, $6e, $20
	db $00, $00, $6a, $20, $00, $08, $68, $20, $00, $10, $66, $20, $f0, $02, $6e, $00

;@ def RollingBonesDraw(slot: bc)
;@ path: boss/rolling_bones
;@ Draws Rolling Bones (4 sprites from RollingBonesOAM) and, while it is in the air, on every
;@ other frame a two-sprite shadow (tile $26) 12 pixels below its position, written straight
;@ into the OAM buffer.
;@ test: skip draws sprites
RollingBonesDraw::
;>@t7 f = (hActiveEntitySpriteVariant + wEntityDirection[slot]) * 16
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	rla
	rla
;=@t7
	rla
	rla
	and $f0
	ld e, a
	ld d, b
;> DrawEntitySprites(RollingBonesOAM + f, 4)
	ld hl, RollingBonesOAM
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
;>@t8 if wEntityZ[slot] and hFrameCounter & 1 == 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .return

;=@t8
	ldh a, [hFrameCounter]
	and $01
	jr nz, .return

;>     oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, b
	ld hl, wOAMBuffer + $30
	add hl, de
;>     oam[0] = hActiveEntityY + 0x0C
	ldh a, [hActiveEntityY]
	add $0c
	ld [hli], a
;>     oam[1] = hActiveEntityX + 2
	ldh a, [hActiveEntityX]
	add $02
	ld [hli], a
;>     oam[2] = 0x26
	ld a, $26
	ld [hli], a
;>     oam[3] = 0
	ld a, $00
	ld [hli], a
;>     oam[4] = hActiveEntityY + 0x0C
	ldh a, [hActiveEntityY]
	add $0c
	ld [hli], a
;>     oam[5] = hActiveEntityX + 4
	ldh a, [hActiveEntityX]
	add $04
	ld [hli], a
;>     oam[6] = 0x26
	ld a, $26
	ld [hli], a
;>     oam[7] = 0
	ld a, $00
	ld [hli], a
;>     ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar

.return
	ret


;@ path: boss/rolling_bones
;@ One piece of the spiked bar for the two-sprite renderer: frame 0 tile $6C and its mirror,
;@ frame 1 the same flipped upside down (it rolls).
SpikedBarSprites::
	db $6c, $00, $6c, $20, $6c, $40, $6c, $60

;@ path: boss/rolling_bones
;@ Screen y of the bar piece that explodes next when the bar breaks up (index = pieces gone):
;@ $70, $60, $50, $40, $30, $20, from the bottom up.
SpikedBarBreakY::
	db $70, $60, $50, $40, $30, $20

;@ def SpikedBarHandler(slot: bc)
;@ path: boss/rolling_bones
;@ Entity $82: the spiked bar, a column of 6 pieces from y $20 to $70 that Rolling Bones rolls
;@ across the room (it keeps its slot in wEntityScratch1). It is gone if the room is already
;@ beaten. It hurts Link (unless he jumps over it) and rolls with its frames turning faster the
;@ faster it goes. States: 0 SpikedBarIdle, 1 SpikedBarRoll, 2 SpikedBarSlowDown. When Rolling
;@ Bones is gone it breaks up from the bottom, one piece every 3 frames, and is marked defeated.
;@ test: skip draws sprites and calls banked helpers
SpikedBarHandler::
;> if hMapId == 7:
	ldh a, [hMapId]
	cp $07
	jr nz, .checkRoomStatus

;>     hActiveEntityTileOffset = 0x10
	ld a, $10
	ldh [hActiveEntityTileOffset], a

.checkRoomStatus
;> if hRoomStatus & 0x20:
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus_06(slot)
	jp nz, ClearEntityStatus_06

;> wEntityScratch1 = slot
	ld a, c
	ld [wEntityScratch1], a
;> SpikedBarDraw(slot)
	call SpikedBarDraw
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> boss = wEntityStatus[wEntityScratch2]
	ld a, [wEntityScratch2]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
;> if boss == 1:
	cp $01
;>     return
	ret z

;> if boss != 0:
	and a
;>     pass                                   # on at alive                             # below
	jr nz, .decrementEntityIgnoreHitsTimer

;> if wEntityTimer[slot]:                    # Rolling Bones is gone: break up
	call GetEntityTimer
;>     return
	jr nz, .return

;> wEntityTimer[slot] = 3
	ld [hl], $03
;> hMultiPurpose0 = hActiveEntityX
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> piece = wEntityPrivate1[slot]
	ld e, [hl]
;> wEntityPrivate1[slot] += 1
	inc [hl]
;> if wEntityPrivate1[slot] == 6:
	ld a, [hl]
	cp $06
	jr nz, .setMultiPurpose1

;>     ClearEntityStatus_06(slot)
	call ClearEntityStatus_06
;>     bit = mem[RoomEntityBitMask2 + wEntityLoadOrder[slot]]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, RoomEntityBitMask2
	add hl, de
;>@t9     wRoomDefeatedEntityBits[hMapRoom] |= bit
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld a, [hl]
	ld hl, wRoomDefeatedEntityBits
	add hl, de
;=@t9
	or [hl]
	ld [hl], a

.setMultiPurpose1
;> hMultiPurpose1 = mem[SpikedBarBreakY + piece]
	ld d, b
	ld hl, SpikedBarBreakY
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> return AddExplosionAt()
	jp AddExplosionAt


.return
	ret


.decrementEntityIgnoreHitsTimer
;> # alive:
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> if not hLinkPositionZ:
	ldh a, [hLinkPositionZ]
	and a
	jr nz, .addEntitySpeedToPos

;>     EntityCheckHits(slot)
	call EntityCheckHits

.addEntitySpeedToPos
;> AddEntitySpeedToPos_06(slot)
	call AddEntitySpeedToPos_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntitySpeedX[slot]:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .setSpikedBarStates

;>     speed = abs(((wEntitySpeedX[slot] ^ 0x80) - 0x80))
	bit 7, a
	jr z, .setPeriod

	cpl
	inc a

.setPeriod
;>@t10     period = 4 if speed >= 8 else 8 if speed >= 4 else 0x10 if speed >= 2 else 0x20
	ld e, $04
	cp $08
	jr nc, .setPeriod2

	ld e, $08

.setPeriod2
;=@t10
	cp $04
	jr nc, .setPeriod3

	ld e, $10

.setPeriod3
;=@t10
	cp $02
	jr nc, .setFrame

	ld e, $20

.setFrame
;>     frame = 1 if hFrameCounter & period else 0
	ld d, b
	ldh a, [hFrameCounter]
	and e
	jr z, .setEntitySpriteVariant

	inc d

.setEntitySpriteVariant
;>     SetEntitySpriteVariant(slot, frame)
	ld a, d
	call SetEntitySpriteVariant

.setSpikedBarStates
;> SpikedBarStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/rolling_bones
;@ Spiked bar states: 0 SpikedBarIdle, 1 SpikedBarRoll, 2 SpikedBarSlowDown.
SpikedBarStates::
	dw SpikedBarIdle
	dw SpikedBarRoll
	dw SpikedBarSlowDown

;@ def SpikedBarIdle()
;@ path: boss/rolling_bones
;@ State 0: lies still until Rolling Bones pushes it.
;@ test: pass
SpikedBarIdle::
;> return
	ret


;@ def SpikedBarRoll(slot: bc)
;@ path: boss/rolling_bones
;@ State 1: rolling, with a rumble (wave sound $1A every 9 frames, counted in wSongShowTimer).
;@ When it hits a side wall it bounces back at half speed, the screen shakes sideways for 32
;@ frames with a crash (hJingle $0B), and it slows down (state 2).
;@ test: skip bank-0 helpers
SpikedBarRoll::
;> if wEntityCollisions[slot] & 3:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .setN

;>@t11     wEntitySpeedX[slot] = -(((wEntitySpeedX[slot] ^ 0x80) - 0x80) >> 1)
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	inc a
;=@t11
	ld [hl], a
;>     wBumpShakeTimer = 0x20
	ld a, $20
	ld [wBumpShakeTimer], a
;>     wBumpShakeAxis = 0
	xor a
	ld [wBumpShakeAxis], a
;>     hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;>     wEntityState[slot] += 1
	call IncrementEntityState

.setN
;> n = wSongShowTimer + 1
	ld a, [wSongShowTimer]
	inc a
;> if n >= 9:
	cp $09
	jr c, .setSongShowTimer

;>     hWaveSfx = 0x1A
	ld a, $1a
	ldh [hWaveSfx], a
;>     n = 0
	xor a

.setSongShowTimer
;> wSongShowTimer = n
	ld [wSongShowTimer], a
	ret


;@ def SpikedBarSlowDown(slot: bc)
;@ path: boss/rolling_bones
;@ State 2: every 8 frames its speed goes one step towards 0; when it stops it rests (state 0,
;@ 80 frames).
;@ test: skip bank-0 helpers
SpikedBarSlowDown::
;> if hFrameCounter & 7:
	ldh a, [hFrameCounter]
	and $07
;>     return
	jr nz, .return

;> if wEntitySpeedX[slot] == 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
;>     pass                                   # on at stop                              # below
	jr z, .setEntityState

;>@t12 wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1
	and $80
	jr z, .setEntitySpeedX

	inc [hl]
	inc [hl]

.setEntitySpeedX
;=@t12
	dec [hl]

.return
	ret


.setEntityState
;> # stop:
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
	ret


;@ path: boss/rolling_bones
;@ The bar's bottom end (the draw y where drawing stops) by the number of pieces gone
;@ (wEntityPrivate1): $80 (all 6 pieces), $70, $60, $50, $40, $30.
SpikedBarBottomY::
	db $80, $70, $60, $50, $40, $30

;@ def SpikedBarDraw(slot: bc)
;@ path: boss/rolling_bones
;@ Draws the bar as a column of pieces, 16 pixels apart, from screen y $20 down to its bottom end
;@ (SpikedBarBottomY), then reloads the entity's position.
;@ test: skip draws sprites
SpikedBarDraw::
;> hActiveEntityDrawY = 0x20
	ld a, $20
	ldh [hActiveEntityDrawY], a

.loop
;> while True:
;>     DrawEntity16x16(slot, SpikedBarSprites)
	ld de, SpikedBarSprites
	call DrawEntity16x16
;>     hActiveEntityDrawY += 0x10
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hActiveEntityDrawY], a
;>@t13     if hActiveEntityDrawY == mem[SpikedBarBottomY + wEntityPrivate1[slot]]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, SpikedBarBottomY
	add hl, de
;=@t13
	cp [hl]
;>         break
	jr nz, .loop

;> LoadEntityPosition(slot)
	call LoadEntityPosition
	ret


;@ def MinibossExplosions(timer: a)
;@ path: boss/common
;@ Explosions over a beaten miniboss: every 8 frames of its timer, one explosion (with its
;@ sound) at a random spot within about 16 pixels of it (AddExplosionAtEntity after moving the
;@ entity's draw position).
;@ test: skip adds a vfx
MinibossExplosions::
;> if timer & 7:
	and $07
;>     return
	jr nz, .return

;>@t14 hActiveEntityX += (GetRandomByte() & 0x1F) - 0x10
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityX
	add [hl]
;=@t14
	ld [hl], a
;>@t15 hActiveEntityDrawY += (GetRandomByte() & 0x1F) - 0x14
	call GetRandomByte
	and $1f
	sub $14
	ld e, a
	ld hl, hActiveEntityDrawY
	add [hl]
;=@t15
	ld [hl], a
;> AddExplosionAtEntity()
	call AddExplosionAtEntity

.return
	ret


;@ def AddExplosionAtEntity()
;@ path: boss/common
;@ An explosion (transient vfx 2, noise $13) at the active entity's draw position, unless the
;@ game is paused.
;@ test: skip adds a vfx
AddExplosionAtEntity::
;> ReturnIfGamePaused_06()
	call ReturnIfGamePaused_06
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddExplosionAt()                         # (falls through)

;@ def AddExplosionAt(x: hMultiPurpose0, y: hMultiPurpose1)
;@ path: boss/common
;@ An explosion (transient vfx 2) at hMultiPurpose0 / 1 with the explosion noise ($13).
;@ test: skip adds a vfx
AddExplosionAt::
;> AddTransientVfx(2)
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret

;@ path: unused
;@ Code kept as bytes (nothing calls it): ld a, $36 / call SpawnEntity / put the new entity at
;@ hMultiPurpose0 / 1 (wEntityX / wEntityY) / if hIsSideScrolling: wEntitySpeedY[this slot]
;@ = -$10, else the new entity gets wEntitySpeedZ $10 and wEntityZ 8 / ClearEntityStatus_06 /
;@ PlayClinkNoise / ret. It would turn the entity into entity $36 popping up.
UnusedSpawnEntity36::
	db $3e, $36, $cd, $01, $3c, $f0, $d7, $21, $00, $c2, $19, $77, $f0, $d8, $21, $10
	db $c2, $19, $77, $f0, $f9, $a7, $28, $08, $21, $50, $c2, $09, $36, $f0, $18, $0c
	db $21, $20, $c3, $19, $36, $10, $21, $10, $c3, $19, $36, $08, $cd, $e5, $65, $cd
	db $d7, $08, $c9

;@ def DreamShrineBedHandler(slot: bc)
;@ path: object/dream_shrine_bed
;@ Entity $83: the bed in the Dream Shrine. States: 0 DreamShrineBedWait (Link walks into it from
;@ the left and jumps in), 1 DreamShrineBedSleep (he falls asleep: the screen fades to white and
;@ the wave effect starts), 2 DreamShrineBedWarp (into the dream, room $CE).
;@ test: skip changes Link's state
DreamShrineBedHandler::
;> DreamShrineBedStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/dream_shrine_bed
;@ Dream Shrine bed states: 0 DreamShrineBedWait, 1 DreamShrineBedSleep, 2 DreamShrineBedWarp.
DreamShrineBedStates::
	dw DreamShrineBedWait
	dw DreamShrineBedSleep
	dw DreamShrineBedWarp

;@ def DreamShrineBedWait(slot: bc)
;@ path: object/dream_shrine_bed
;@ State 0: when Link stands right next to the bed (within 14 pixels sideways, 12 up / down),
;@ faces right and pushes against it, he jumps in (like jumping down a ledge: height speed $12,
;@ x speed $0C), the sleep music (track $1E) starts and the bed counts 160 frames (state 1).
;@ test: skip changes Link's state
DreamShrineBedWait::
;> if u8(GetEntityXDistanceToLink_06(slot) + 0x0E) >= 0x1C:
	call GetEntityXDistanceToLink_06
	add $0e
	cp $1c
;>     return
	jr nc, .return

;> if u8(GetEntityYDistanceToLink_06(slot) + 0x0C) >= 0x18:
	call GetEntityYDistanceToLink_06
	add $0c
	cp $18
;>     return
	jr nc, .return

;> if hLinkDirection != 0:                    # not facing right
	ldh a, [hLinkDirection]
	and a
;>     return
	jr nz, .return

;> if not wLinkCollisionFlags:               # not pushing against it
	ld a, [wLinkCollisionFlags]
	and a
;>     return
	jr z, .return

;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> hLinkPositionZ = 1
	ld a, $01
	ldh [hLinkPositionZ], a
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> hLinkSpeedZ = 0x12
	ld a, $12
	ldh [hLinkSpeedZ], a
;> hLinkSpeedX = 0x0C
	ld a, $0c
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;> hLinkDirection = 0
	ld a, $00
	ldh [hLinkDirection], a
;> wIsJumpingDownLedge = 1
	ld a, $01
	ld [wIsJumpingDownLedge], a
;> wMusicTrackToPlay = 0x1E
	ld a, $1e
	ld [wMusicTrackToPlay], a
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a

.return
	ret


;@ path: object/dream_shrine_bed
;@ The bed with Link for the two-sprite renderer, 4 bytes per frame (left tile, attributes, right
;@ tile, attributes): frame 0 tiles $50 / $52, frame 1 tiles $54 / $56.
DreamShrineBedSprites::
	db $50, $00, $52, $00, $54, $00, $56, $00

;@ path: object/dream_shrine_bed
;@ Background addresses (high byte first) where the room gets two tiles ($64, $65) while Link
;@ falls asleep, one every 16 frames: $9842, $9850, $9990, $9982.
DreamShrineBedTileAddrs::
	db $98, $42, $98, $50, $99, $90, $99, $82

;@ def DreamShrineBedSleep(slot: bc)
;@ path: object/dream_shrine_bed
;@ State 1, once Link has landed in the bed: Link lies in it (frame 1 for the first 32 frames,
;@ then 0). In the last 128 frames the screen fades one step to white every 32 frames and every
;@ 16 frames one of the 4 tile pairs (DreamShrineBedTileAddrs) is queued as a draw command
;@ (address, $01 = 2 tiles, $64, $65, end). When the timer runs out the wave effect starts
;@ (wTransitionGfx 1, palette step 8) and the bed goes to state 2.
;@ test: skip changes the screen
DreamShrineBedSleep::
;> if wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
;>     return
	jp nz, DreamShrineBedDraw.return

;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .checkT

;>     wTransitionGfx = 1
	ld a, $01
	ld [wTransitionGfx], a
;>     wTransitionGfxFrameCount = 0
	xor a
	ld [wTransitionGfxFrameCount], a
;>     wWavePaletteStep = 8
	ld a, $08
	ld [wWavePaletteStep], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     t = 0
	xor a

.checkT
;> if t < 0x80:
	push af
	cp $80
	jr nc, .setFrame

;>     if t & 0x1F == 0 and wTransitionSequenceCounter != 2:
	push af
	and $1f
	jr nz, .checkT2

	ld a, [wTransitionSequenceCounter]
	cp $02
	jr z, .checkT2

;>         wTransitionFrameCounter = 3
	ld a, $03
	ld [wTransitionFrameCounter], a
;>         FadePalettesToWhite()
	push bc
	call FadePalettesToWhite
	pop bc

.checkT2
;>@t1     if t & 0x0F == 0 and wEntityPrivate2[slot] != 4:
	pop af
	and $0f
	jr nz, .setFrame

	ld hl, wEntityPrivate2
	add hl, bc
;=@t1
	ld a, [hl]
	cp $04
	jr z, .setFrame

;>         cmd = wDrawCommand + wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, b
;>@t2         wDrawCommandsSize += 5
	add $05
	ld [wDrawCommandsSize], a
;=@t2
	ld hl, wDrawCommand
	add hl, de
	push hl
;>         addr = DreamShrineBedTileAddrs + wEntityPrivate2[slot] * 2
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
;>@t3         wEntityPrivate2[slot] += 1
	inc [hl]
;=@t3
	sla a
	ld e, a
	ld d, b
	ld hl, DreamShrineBedTileAddrs
	add hl, de
	push hl
;=@t3
	pop de
	pop hl
;>         cmd[0] = addr[0]
	ld a, [de]
	inc de
	ld [hli], a
;>         cmd[1] = addr[1]
	ld a, [de]
	ld [hli], a
;>         cmd[2] = 1                          # 2 tiles in a row
	ld a, $01
	ld [hli], a
;>         cmd[3] = 0x64
	ld a, $64
	ld [hli], a
;>         cmd[4] = 0x65
	ld a, $65
	ld [hli], a
;>         cmd[5] = 0                          # end
	ld [hl], b

.setFrame
;> frame = 1 if t >= 0x80 else 0
	pop af
	ld e, $00
	cp $80
	jr c, .dreamShrineBedDraw

	inc e

.dreamShrineBedDraw
;> DreamShrineBedDraw(frame)                 # (falls through)
	ld a, e

;@ def DreamShrineBedDraw(frame: a)
;@ path: object/dream_shrine_bed
;@ Draws the bed with the given frame at x $58, y $44 and keeps Link there, frozen and not drawn
;@ himself (hLinkAnimationState $FF): the bed sprite shows him.
;@ test: skip draws sprites
DreamShrineBedDraw::
;> hActiveEntitySpriteVariant = frame
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityX = 0x58
	ld a, $58
	ldh [hActiveEntityX], a
;> hLinkX = 0x58
	ldh [hLinkX], a
;> hActiveEntityDrawY = 0x44
	ld a, $44
	ldh [hActiveEntityDrawY], a
;> hLinkY = 0x44
	ldh [hLinkY], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hLinkAnimationState = 0xFF
	ld a, $ff
	ldh [hLinkAnimationState], a
;> DrawEntity16x16(DreamShrineBedSprites)
	ld de, DreamShrineBedSprites
	call DrawEntity16x16
;> LoadEntityPosition()
	call LoadEntityPosition

.return
	ret


;@ def DreamShrineBedWarp(slot: bc)
;@ path: object/dream_shrine_bed
;@ State 2: once the wave effect is over, Link is warped indoors (same map) to room $CE at x $50,
;@ y $7C (the dream) and the screen fades out; the bed entity is freed.
;@ test: skip starts a warp
DreamShrineBedWarp::
;> DreamShrineBedDraw(0)
	xor a
	call DreamShrineBedDraw
;> if wTransitionGfx:
	ld a, [wTransitionGfx]
	and a
;>     return
	jr nz, .return

;> hLinkAnimationState = 0
	xor a
	ldh [hLinkAnimationState], a
;> wWarpType = 1
	ld hl, wWarpType
	ld a, $01
	ld [hli], a
;> wWarpMap = hMapId
	ldh a, [hMapId]
	ld [hli], a
;> wWarpRoom = 0xCE
	ld a, $ce
	ld [hli], a
;> wWarpDestX = 0x50
	ld a, $50
	ld [hli], a
;> wWarpDestY = 0x7C
	ld a, $7c
	ld [hl], a
;> ClearEntityStatus_06(slot)
	call ClearEntityStatus_06
;> return StartScreenFadeOut()
	jp StartScreenFadeOut


.return
	ret


;@ path: npc/great_fairy
;@ The Great Fairy for DrawEntitySprites: 2 frames of 6 sprites (y, x, tile, attributes; relative
;@ to the entity), swapped every 8 frames. Both: top row (-16, -4 / 4 / 12) tiles $50, $52, $54;
;@ bottom row (0, -4 / 4 / 12) tiles $56, $58, $5A in frame 0 and $5C, $58, $5E in frame 1.
GreatFairySprites::
	db $f0, $fc, $50, $00, $f0, $04, $52, $00, $f0, $0c, $54, $00, $00, $fc, $56, $00
	db $00, $04, $58, $00, $00, $0c, $5a, $00, $f0, $fc, $50, $00, $f0, $04, $52, $00
	db $f0, $0c, $54, $00, $00, $fc, $5c, $00, $00, $04, $58, $00, $00, $0c, $5e, $00
;@ path: npc/great_fairy
;@ The little heart the fairy sends round Link, for the one-sprite renderer (8x16): tile $A8 in
;@ sprite palette 1. Frame index = wEntityScratch2, which the fairy sets to 0 or $FF (blinking).
FairyHeartSprite::
	db $a8, $10

;@ path: npc/great_fairy
;@ A heart's speed change per step (index = its turning direction, wEntityPrivate1 for x,
;@ wEntityPrivate2 for y): +1, -1.
FairyHeartAccel::
	db $01, $ff

;@ path: npc/great_fairy
;@ The speed at which a heart turns back (same index): +$18, -$18. Swinging between them in x and
;@ y makes the hearts circle.
FairyHeartTurnSpeed::
	db $18, $e8

;@ def GreatFairyHandler(slot: bc)
;@ path: npc/great_fairy
;@ Entity $84: the Great Fairy at the fountain, and (wEntityPrivate3 set) the hearts she sends
;@ circling: each heart, every other frame, speeds up in x and y by FairyHeartAccel and turns
;@ back at FairyHeartTurnSpeed; it disappears with the fairy. The fairy herself (GreatFairyBody)
;@ bobs up and down (height speed +2 / -2, switching every 64 frames) with her shadow. Her slot
;@ is kept in wEntityScratch1, the hearts' frame in wEntityScratch2.
;@ States: 0 GreatFairyWait, 1 GreatFairyHeal, 2 GreatFairyLeave.
;@ test: skip draws sprites and calls banked helpers
GreatFairyHandler::
;> if wEntityPrivate3[slot] == 0:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
;>     return GreatFairyBody()
	jp z, GreatFairyBody

;>@t4 if wEntityStatus[wEntityScratch1] == 0:      # the fairy is gone
	ld hl, wEntityStatus
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
;=@t4
	and a
;>     return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

;> hActiveEntitySpriteVariant = wEntityScratch2
	ld a, [wEntityScratch2]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity8x16(slot, FairyHeartSprite)
	ld de, FairyHeartSprite
	call DrawEntity8x16
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .updateEntityPosWithSpeed

;>     turn = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>@t5     wEntitySpeedX[slot] += mem[FairyHeartAccel + turn]
	ld hl, FairyHeartAccel
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
;=@t5
	ld [hl], a
;>     if wEntitySpeedX[slot] == mem[FairyHeartTurnSpeed + turn]:
	ld hl, FairyHeartTurnSpeed
	add hl, de
	cp [hl]
	jr nz, .setTurn

;>         wEntityPrivate1[slot] ^= 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

.setTurn
;>     turn = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
;>@t6     wEntitySpeedY[slot] += mem[FairyHeartAccel + turn]
	ld hl, FairyHeartAccel
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
;=@t6
	ld [hl], a
;>     if wEntitySpeedY[slot] == mem[FairyHeartTurnSpeed + turn]:
	ld hl, FairyHeartTurnSpeed
	add hl, de
	cp [hl]
	jr nz, .updateEntityPosWithSpeed

;>         wEntityPrivate2[slot] ^= 1
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

.updateEntityPosWithSpeed
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
	ret


GreatFairyBody:
;> frames = GreatFairySprites + 24 if hFrameCounter & 8 else GreatFairySprites      # GreatFairyBody
	ld hl, GreatFairySprites
	ldh a, [hFrameCounter]
	and $08
	jr z, .drawEntitySprites

	ld hl, GreatFairySprites + 24

.drawEntitySprites
;> DrawEntitySprites(frames, 6)
	ld c, $06
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
;> DrawEntityShadow(slot)
	call DrawEntityShadow
;> wEntityPrivateCounter[slot] += 1
	ld e, $fe
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@t7 wEntitySpeedZ[slot] = 2 if wEntityPrivateCounter[slot] & 0x40 else -2
	ld a, [hl]
	and $40
	jr z, .setEntitySpeedZ

	ld e, $02

.setEntitySpeedZ
;=@t7
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], e
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> GreatFairyStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/great_fairy
;@ Great Fairy states: 0 GreatFairyWait, 1 GreatFairyHeal, 2 GreatFairyLeave.
GreatFairyStates::
	dw GreatFairyWait
	dw GreatFairyHeal
	dw GreatFairyLeave

;@ def GreatFairyWait(slot: bc)
;@ path: npc/great_fairy
;@ State 0: hearts shown (wEntityScratch2 0), her slot noted. When Link steps within 8 pixels of
;@ (x $50, y $58) in front of her, she speaks (text $24) and heals for 72 frames (state 1).
;@ test: skip opens a dialog
GreatFairyWait::
;> wEntityScratch2 = 0
	xor a
	ld [wEntityScratch2], a
;> wEntityScratch1 = slot
	ld a, c
	ld [wEntityScratch1], a
;> if u8(hLinkX - 0x50 + 8) >= 0x10:
	ldh a, [hLinkX]
	sub $50
	add $08
	cp $10
;>     return
	jr nc, .return

;> if u8(hLinkY - 0x58 + 8) >= 0x10:
	ldh a, [hLinkY]
	sub $58
	add $08
	cp $10
;>     return
	jr nc, .return

;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityDropTimer[slot] = 0x48
	call GetEntityDropTimer
	ld [hl], $48
;> OpenDialog(0x24)
	ld a, $24
	call OpenDialog

.return
	ret


;@ def GreatFairyHeal(slot: bc)
;@ path: npc/great_fairy
;@ State 1, after her words (the drop timer runs while the text is open): Link is held still
;@ with a sparkling sound ($1A) while she sends up to 10 hearts, one every 19 frames, from 14
;@ pixels above her (x speed -$18); from the fourth heart on, Link gets half a heart every
;@ other frame. When the drop timer runs out: 72 frames more, a chime (hJingle $26), state 2.
;@ test: skip spawns entities
GreatFairyHeal::
;> if not GetEntityDropTimer(slot):
	call GetEntityDropTimer
	jr nz, .setLinkInteractiveMotionBlocked

;>     wEntityTimer[slot] = 0x48
	call GetEntityTimer
	ld [hl], $48
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     hJingle = 0x26
	ld a, $26
	ldh [hJingle], a
;>     return
	ret


.setLinkInteractiveMotionBlocked
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hJingle = 0x1A
	ld a, $1a
	ldh [hJingle], a
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if wEntityTimer2[slot] == 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkGetEntityTimer1

;>     wEntityTimer2[slot] = 1
	ld [hl], $01
;>     if wEntityPrivate1[slot] >= 4:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $04
	jr c, .checkGetEntityTimer1

;>         wAddHealthBuffer = 4
	ld a, $04
	ld [wAddHealthBuffer], a

.checkGetEntityTimer1
;> if GetEntityTimer1(slot):
	call GetEntityTimer1
;>     return
	jr nz, .return

;> wEntityTimer1[slot] = 0x13
	ld [hl], $13
;> if wEntityPrivate1[slot] == 10:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $0a
;>     return
	jr z, .return

;> wEntityPrivate1[slot] += 1
	inc [hl]
;> heart, full = SpawnEntity(slot, 0x84)
	ld a, $84
	call SpawnEntity
;> if full:
;>     return
	jr c, .return

;> wEntityPrivate3[heart] = 1
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
;> wEntityX[heart] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	add $00
	ld [hl], a
;> wEntityY[heart] = hMultiPurpose1 - 0x0E
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $0e
	ld [hl], a
;> wEntitySpeedX[heart] = -0x18
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $e8

.return
	ret


;@ def GreatFairyLeave(slot: bc)
;@ path: npc/great_fairy
;@ State 2: for 72 frames Link stays still and the hearts blink (wEntityScratch2 0 / $FF every 2
;@ frames); then the fairy is gone (and her hearts with her).
;@ test: skip bank-0 helpers
GreatFairyLeave::
;> if not GetEntityTimer(slot):
	call GetEntityTimer
;>     return ClearEntityStatus_06(slot)
	jp z, ClearEntityStatus_06

;> blink = 0xFF if hFrameCounter & 2 else 0
	ldh a, [hFrameCounter]
	and $02
	ld a, $00
	jr z, .setSmasherSlot

	ld a, $ff

.setSmasherSlot
;> wEntityScratch2 = blink
	ld [wEntityScratch2], a
;> SetEntitySpriteVariant(slot, blink)
	call SetEntitySpriteVariant
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


;@ path: npc/bird
;@ The little bird for the two-sprite renderer: 6 frames of 4 bytes (left tile, attributes, right
;@ tile, attributes). Index = frame (0 standing, 1 hopping, 2 flapping) + facing (0 left, 3
;@ right): tiles $68 / $6A, $64 / $66, $6C / $6E, then the same mirrored.
BirdSprites::
	db $68, $00, $6a, $00, $64, $00, $66, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20
	db $66, $20, $64, $20, $6e, $20, $6c, $20

;@ def BirdHandler(slot: bc)
;@ path: npc/bird
;@ Entity $85: a little bird that pecks about and hops around, and flies off when Link swings his
;@ sword near it. It faces the way it moves (wEntityDirection 0 left, 3 right, added to the
;@ frame). It only acts indoors. Gravity 1 per frame; hMultiPurposeG = landed this frame.
;@ States: 0 BirdPeck, 1 BirdHop, 2 BirdFlyAway.
;@ test: skip draws sprites and calls banked helpers
BirdHandler::
;> hActiveEntitySpriteVariant += wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	ldh [hActiveEntitySpriteVariant], a
;> if wEntitySpeedX[slot]:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .drawEntity16x16

;>@t1     wEntityDirection[slot] = 0 if wEntitySpeedX[slot] & 0x80 else 3
	and $80
	ld a, $00
	jr nz, .setEntityDirection

	ld a, $03

.setEntityDirection
;=@t1
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

.drawEntity16x16
;> DrawEntity16x16(slot, BirdSprites)
	ld de, BirdSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     return
	jp z, BirdCheckSword.return2

;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> landed = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;> hMultiPurposeG = landed
	ldh [hMultiPurposeG], a
;> if landed:
	jr z, .setBirdStates

;>     wEntityZ[slot] = 0
	ld [hl], b
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b

.setBirdStates
;> BirdStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/bird
;@ Bird states: 0 BirdPeck, 1 BirdHop, 2 BirdFlyAway.
BirdStates::
	dw BirdPeck
	dw BirdHop
	dw BirdFlyAway

;@ path: npc/bird
;@ The bird's hopping speeds, one picked at random for x and one for y: 2, 6, 8, 6 and -2, -6,
;@ -8, -6.
BirdHopSpeeds::
	db $02, $06, $08, $06, $fe, $fa, $f8, $fa

;@ def BirdPeck(slot: bc)
;@ path: npc/bird
;@ State 0: stands and pecks (frame 0 / 1 every 8 frames); after its timer it picks random
;@ speeds and hops about for 32 to 63 frames (state 1).
;@ test: skip bank-0 helpers
BirdPeck::
;> BirdCheckSword(slot)
	call BirdCheckSword
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return BirdFrame()
	jr nz, .birdFrame

;> e = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[BirdHopSpeeds + e]
	ld hl, BirdHopSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntityDirection[slot] = e & 4
	ld a, e
	and $04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>@t2 wEntitySpeedY[slot] = mem[BirdHopSpeeds + (GetRandomByte() & 7)]
	call GetRandomByte
	and $07
	ld e, a
	ld hl, BirdHopSpeeds
	add hl, de
;=@t2
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntityTimer[slot] = 0x20 + GetRandomByte() & 0x1F
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
;> wEntityState[slot] += 1
	call IncrementEntityState

.birdFrame
;> BirdFrame()
	jp BirdFrame


;@ def BirdHop(slot: bc)
;@ path: npc/bird
;@ State 1: moves (stopped by walls) in little hops: at every landing a new hop (height speed 8),
;@ until the timer has run out; then it rests for 48 frames (state 0). The shared tail
;@ (BirdFrame) sets frame 0 / 1 every 8 frames.
;@ test: skip bank-0 helpers
BirdHop::
;> BirdCheckSword(slot)
	call BirdCheckSword
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, BirdFrame.setEntitySpriteVariant

;>     if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .setEntitySpeedZ

;>         wEntityTimer[slot] = 0x30
	ld [hl], $30
;>         wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>         return
	ret


.setEntitySpeedZ
;>     wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;>     wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

BirdFrame:
.setEntitySpriteVariant
;>@t1 SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)      # BirdFrame
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;=@t1
	ret


;@ def BirdFlyAway(slot: bc)
;@ path: npc/bird
;@ State 2: flies off (stopped by walls), flapping (frames 0 / 2 every 2 frames), its fall slowed
;@ to half (height speed +1 every other frame); when it lands again it pecks (state 0).
;@ test: skip bank-0 helpers
BirdFlyAway::
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .checkBGTilesRequestCopy

;>     wEntitySpeedZ[slot] += 1
	ld hl, wEntitySpeedZ
	add hl, bc
	inc [hl]

.checkBGTilesRequestCopy
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, .setEntitySpriteVariant

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 1) & 2)
	ldh a, [hFrameCounter]
	rra
	and $02
	call SetEntitySpriteVariant
	ret


;@ def BirdCheckSword(slot: bc)
;@ path: npc/bird
;@ When Link swings his sword (swing state 2) within 24 pixels, the bird flies away from him:
;@ state 2, speed $10 away, height speed $0C; the calling state is then skipped (its return
;@ address is dropped).
;@ test: skip returns from the caller
BirdCheckSword::
;> if wSwordAnimationState != 2:
	ld a, [wSwordAnimationState]
	cp $02
;>     return
	jr nz, .return

;> if u8(GetEntityXDistanceToLink_06(slot) + 0x18) >= 0x30:
	call GetEntityXDistanceToLink_06
	add $18
	cp $30
;>     return
	jr nc, .return

;> if u8(GetEntityYDistanceToLink_06(slot) + 0x18) >= 0x30:
	call GetEntityYDistanceToLink_06
	add $18
	cp $30
;>     return
	jr nc, .return

;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> GetVectorTowardsLink(slot, 0x10)
	ld a, $10
	call GetVectorTowardsLink
;> wEntitySpeedY[slot] = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedZ[slot] = 0x0C
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $0c
;> return_from_caller()
	pop af

.return
	ret


.return2
	ret


;@ path: enemy/pols_voice
;@ Pols Voice for the two-sprite renderer: frame 0 tile $70 (jumping), frame 1 tile $72
;@ (crouching), each with its mirror.
PolsVoiceSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20

;@ def PolsVoiceHandler(slot: bc)
;@ path: enemy/pols_voice
;@ Entity $18: Pols Voice, the big-eared rabbit that hops about. Playing the Ballad of the Wind
;@ Fish on the ocarina kills it at once (status 1, dying timer $1F, explosion noise $13). Its
;@ wall check runs with wEntityIgnoreHitsTimer 1 (cleared afterwards). States alternate (state
;@ & 1): 0 PolsVoiceCrouch, 1 PolsVoiceJump.
;@ test: skip draws sprites and calls banked helpers
PolsVoiceHandler::
;>@t3 if wOcarinaSongState == 1 and wOcarinaSongFlags & 4 and wSelectedSong == 0 and hActiveEntityStatus != 1:
	ld a, [wOcarinaSongState]
	cp $01
	jr nz, .drawEntity16x16

	ld a, [wOcarinaSongFlags]
	and $04
	jr z, .drawEntity16x16

;=@t3
	ld a, [wSelectedSong]
	and a
	jr nz, .drawEntity16x16

	ldh a, [hActiveEntityStatus]
	cp $01
	jr z, .drawEntity16x16

;>     wEntityDyingTimer[slot] = 0x1F
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
;>     wEntityStatus[slot] = 1
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
;>     wEntityPhysicsFlags[slot] = 4
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $04
;>     hNoiseSfx = 0x13
	ld hl, hNoiseSfx
	ld [hl], $13
;>     return
	ret


.drawEntity16x16
;> DrawEntity16x16(slot, PolsVoiceSprites)
	ld de, PolsVoiceSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> wEntityIgnoreHitsTimer[slot] = 1
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $01
;> EntityCheckWalls(slot)
	push hl
	call EntityCheckWalls
	pop hl
;> wEntityIgnoreHitsTimer[slot] = 0
	ld [hl], b
;> EntityCheckHits(slot)
	call EntityCheckHits
;> PolsVoiceStates[hActiveEntityState & 1](slot)
	ldh a, [hActiveEntityState]
	and $01
	rst $00

;@ path: enemy/pols_voice
;@ Pols Voice states (by state & 1): 0 PolsVoiceCrouch, 1 PolsVoiceJump.
PolsVoiceStates::
	dw PolsVoiceCrouch
	dw PolsVoiceJump

;@ path: enemy/pols_voice
;@ Pols Voice's jump speeds in x, one of 6 picked at random (index 0-5): 8, 8, -8, -8, 4, -4.
PolsVoiceJumpSpeedX::
	db $08, $08, $f8, $f8, $04, $fc

;@ path: enemy/pols_voice
;@ The y speeds for the same index: -4, 4, -4, 4, 8, -8.
PolsVoiceJumpSpeedY::
	db $fc, $04, $fc, $04, $08, $f8

;@ def PolsVoiceCrouch(slot: bc)
;@ path: enemy/pols_voice
;@ Even state: crouches (frame 1) until its timer runs out, then jumps (height speed $10-$17):
;@ 2 times in 8 at Link (speed $0A), otherwise in one of the 6 random directions; frame 0.
;@ test: skip bank-0 helpers
PolsVoiceCrouch::
;> wEntitySpriteVariant[slot] = 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $01
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return
	jr nz, .return

;> wEntityState[slot] += 1
	call IncrementEntityState
;>@t4 wEntitySpeedZ[slot] = 0x10 + GetRandomByte() & 7
	call GetRandomByte
	and $07
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
;=@t4
	ld [hl], a
;> r = GetRandomByte() & 7
	call GetRandomByte
	and $07
;> if r >= 6:
	cp $06
	jr c, .otherwise

;>     SetEntitySpeedTowardsLink(slot, 0x0A)
	ld a, $0a
	call SetEntitySpeedTowardsLink
	jr .setEntitySpriteVariant

.otherwise
;> else:
;>@t5     wEntitySpeedX[slot] = mem[PolsVoiceJumpSpeedX + r]
	ld e, a
	ld d, b
	ld hl, PolsVoiceJumpSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
;=@t5
	add hl, bc
;=@t5
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[PolsVoiceJumpSpeedY + r]
	ld hl, PolsVoiceJumpSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant

.return
	ret


;@ def PolsVoiceJump(slot: bc)
;@ path: enemy/pols_voice
;@ Odd state: in the air, gravity 1 per frame; on landing it stops and crouches for 24 to 39
;@ frames (next state).
;@ test: skip bank-0 helpers
PolsVoiceJump::
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:                 # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .return

;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x18 + GetRandomByte() & 0x0F
	call GetEntityTimer
	call GetRandomByte
	and $0f
	add $18
	ld [hl], a
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed

.return
	ret


;@ path: enemy/armos
;@ The Armos statue for the two-sprite renderer: frame 0 tiles $60 / $62, frame 1 tiles $64 / $66.
ArmosSprites::
	db $60, $00, $62, $00, $64, $00, $66, $00

;@ def ArmosHandler(slot: bc)
;@ path: enemy/armos
;@ Entity $0F: Armos, a stone knight statue that comes alive when Link touches it. Only weapons
;@ can hit it; while it is still a statue (states 0 and 1) it blocks Link. hMultiPurposeG is
;@ the "Link touches it" flag. States: 0 ArmosStatue, 1 ArmosWakeUp, 2 ArmosWalk.
;@ test: skip draws sprites and calls banked helpers
ArmosHandler::
;> DrawEntity16x16(slot, ArmosSprites)
	ld de, ArmosSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> hMultiPurposeG = 0
	xor a
	ldh [hMultiPurposeG], a
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> if EntityTouchesLink(slot):
	call EntityTouchesLink
	jr nc, .updateEntityPosWithSpeed

;>     hMultiPurposeG = 1
	ld a, $01
	ldh [hMultiPurposeG], a
;>     if hActiveEntityState < 2:
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .updateEntityPosWithSpeed

;>         RestoreLinkPosition()
	call RestoreLinkPosition

.updateEntityPosWithSpeed
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> ArmosStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/armos
;@ Armos states: 0 ArmosStatue, 1 ArmosWakeUp, 2 ArmosWalk.
ArmosStates::
	dw ArmosStatue
	dw ArmosWakeUp
	dw ArmosWalk

;@ def ArmosStatue(slot: bc)
;@ path: enemy/armos
;@ State 0: a statue; when Link touches it, it wakes up: 48 frames of shaking with 24 frames of
;@ flashing (state 1).
;@ test: skip bank-0 helpers
ArmosStatue::
;> if not hMultiPurposeG:
	ldh a, [hMultiPurposeG]
	and a
;>     return
	jr z, .return

;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> wEntityFlashTimer[slot] = 0x18
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $18

.return
	ret


;@ def ArmosWakeUp(slot: bc)
;@ path: enemy/armos
;@ State 1: shakes from side to side (x speed +8 / -8, switching every 4 frames); then it becomes
;@ an enemy (bit 7 of its physics and hitbox flags and bit 6 of wEntityOptions1 cleared), stops
;@ and walks (state 2).
;@ test: skip bank-0 helpers
ArmosWakeUp::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .setEntitySpeedX

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
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     return
	ret


.setEntitySpeedX
;>@t6 wEntitySpeedX[slot] = -8 if t & 4 else 8
	ld e, $08
	and $04
	jr z, .setEntitySpeedX2

	ld e, $f8

.setEntitySpeedX2
;=@t6
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	ret


;@ path: enemy/armos
;@ Armos' walking speeds for 8 directions: y speed = byte [d], x speed = byte [d + 2]
;@ (d 0-7), so the 10 bytes are -8, -6, 0, 6, 8, 6, 0, -6 followed by its first two again.
ArmosWalkSpeeds::
	db $f8, $fa, $00, $06, $08, $06, $00, $fa, $f8, $fa

;@ def ArmosWalk(slot: bc)
;@ path: enemy/armos
;@ State 2: walks (stopped by walls) in one of 8 directions, a new one every 32 to 95 frames
;@ (direction = new timer & 7); frame 0 / 1 every 16 frames.
;@ test: skip bank-0 helpers
ArmosWalk::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .setEntitySpriteVariant

;>     t = 0x20 + GetRandomByte() & 0x3F
	call GetRandomByte
	and $3f
	add $20
;>     wEntityTimer[slot] = t
	ld [hl], a
;>     d = t & 7
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[ArmosWalkSpeeds + d + 2]
	ld hl, ArmosWalkSpeeds + 2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[ArmosWalkSpeeds + d]
	ld hl, ArmosWalkSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.setEntitySpriteVariant
;>@t7 SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@t7
	call SetEntitySpriteVariant
	ret


;@ path: enemy/spike_trap
;@ The spike trap for the two-sprite renderer: tile $50 and its mirror.
SpikeTrapSprites::
	db $50, $00, $50, $20

;@ path: enemy/spike_trap
;@ The trap's dash x speed by Link's side (0 right, 1 left): +$20, -$20 (2 more unused bytes).
SpikeTrapDashX::
	db $20, $e0, $00, $00

;@ path: enemy/spike_trap
;@ Its x speed going back, by the direction of the dash: -8, +8 (0 for up / down).
SpikeTrapReturnX::
	db $f8, $08, $00, $00

;@ path: enemy/spike_trap
;@ The dash y speed by Link's side (2 above, 3 below; indexes 0 and 1 unused): -$20, +$20.
SpikeTrapDashY::
	db $00, $00, $e0, $20
;@ path: enemy/spike_trap
;@ Its y speed going back, by the direction of the dash: 0 for right / left, +8 after up, -8
;@ after down.
SpikeTrapReturnY::
	db $00, $00, $08, $f8

;@ path: enemy/spike_trap
;@ Two bytes not used by the code: $30, $20.
SpikeTrapUnused::
	db $30, $20

;@ def SpikeTrapHandler(slot: bc)
;@ path: enemy/spike_trap
;@ Entity $27: the spike trap (blade trap). It cannot be hurt (hits only bounce off it) and its
;@ wall check only reports walls (hWallCheckOnly). States: 0 SpikeTrapInit, 1 SpikeTrapWait,
;@ 2 SpikeTrapDash, 3 SpikeTrapReturn.
;@ test: skip draws sprites and calls banked helpers
SpikeTrapHandler::
;> hWallCheckOnly = 1
	ld a, $01
	ldh [hWallCheckOnly], a
;> DrawEntity16x16(slot, SpikeTrapSprites)
	ld de, SpikeTrapSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits(slot)
	call EntityCheckHits
;> SpikeTrapStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/spike_trap
;@ Spike trap states: 0 SpikeTrapInit, 1 SpikeTrapWait, 2 SpikeTrapDash, 3 SpikeTrapReturn.
SpikeTrapStates::
	dw SpikeTrapInit
	dw SpikeTrapWait
	dw SpikeTrapDash
	dw SpikeTrapReturn

;@ def SpikeTrapInit(slot: bc)
;@ path: enemy/spike_trap
;@ State 0: remembers its home position (wEntityPrivate1 = x, wEntityPrivate2 = y) and waits.
;@ test: skip bank-0 helpers
SpikeTrapInit::
;> wEntityPrivate1[slot] = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wEntityPrivate2[slot] = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ def SpikeTrapWait(slot: bc)
;@ path: enemy/spike_trap
;@ State 1: after its pause, when Link comes in line with it (within 18 pixels on the other
;@ axis) it dashes at him: sideways at $20 for up to 24 frames, or up / down for up to 16. If a
;@ wall is right there it does not move; otherwise a whoosh (noise $0A) and state 2.
;@ test: skip bank-0 helpers
SpikeTrapWait::
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return
	jr nz, .return

;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> if u8(GetEntityYDistanceToLink_06(slot) + 0x12) < 0x24:
	call GetEntityYDistanceToLink_06
	add $12
	cp $24
	jr nc, .checkGetEntityXDistanceToLink

;>     side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;>@t2     wEntityDirection[slot] = side
	ld d, b
	ld hl, SpikeTrapDashX
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
;=@t2
	ld [hl], e
;>     wEntitySpeedX[slot] = mem[SpikeTrapDashX + side]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     time = 0x18
	ld e, $18
	jr .setEntityTimer

.checkGetEntityXDistanceToLink
;> elif u8(GetEntityXDistanceToLink_06(slot) + 0x12) >= 0x24:
	call GetEntityXDistanceToLink_06
	add $12
	cp $24
;>     return
	jr nc, .return

;> else:
;>     side = GetEntityYDistanceToLink_06(slot)
	call GetEntityYDistanceToLink_06
;>@t3     wEntityDirection[slot] = side
	ld d, b
	ld hl, SpikeTrapDashY
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
;=@t3
	ld [hl], e
;>     wEntitySpeedY[slot] = mem[SpikeTrapDashY + side]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     time = 0x10
	ld e, $10

.setEntityTimer
;> wEntityTimer[slot] = time
	call GetEntityTimer
	ld [hl], e
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 0x0F:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr z, .setNoiseSfx

;>     wEntityTimer[slot] = 0
	call GetEntityTimer
	ld [hl], b

.return
;>     return
	ret


.setNoiseSfx
;> hNoiseSfx = 0x0A
	ld a, $0a
	ldh [hNoiseSfx], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def SpikeTrapDash(slot: bc)
;@ path: enemy/spike_trap
;@ State 2: dashes until its time is up or it hits a wall; then a clank (hJingle 7), a pause of
;@ 32 frames and back home (state 3).
;@ test: skip bank-0 helpers
SpikeTrapDash::
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> if GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .entityCheckWalls
;>@w     EntityCheckWalls(slot)
;>@w2     if not wEntityCollisions[slot] & 0x0F:
;>@w3         return

.setJingle
;> hJingle = 7
	ld a, $07
	ldh [hJingle], a
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wEntityState[slot] += 1
	jp IncrementEntityState


.entityCheckWalls
;=@w
	call EntityCheckWalls
;=@w2
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
;=@w3
	jr nz, .setJingle

	ret


;@ def SpikeTrapReturn(slot: bc)
;@ path: enemy/spike_trap
;@ State 3: after the pause it slides back (8 per frame, SpikeTrapReturnX / Y by the dash
;@ direction) until it is home again; then it waits 32 frames (state 1).
;@ test: skip bank-0 helpers
SpikeTrapReturn::
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return
	jr nz, .return

;>@t8 wEntitySpeedX[slot] = mem[SpikeTrapReturnX + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, SpikeTrapReturnX
	add hl, de
;=@t8
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[SpikeTrapReturnY + wEntityDirection[slot]]
	ld hl, SpikeTrapReturnY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;>@t9 if wEntityX[slot] == wEntityPrivate1[slot] and wEntityY[slot] == wEntityPrivate2[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	cp [hl]
;=@t9
	jr nz, .return

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
;=@t9
	cp [hl]
	jr nz, .return

;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01

.return
	ret


;@ path: enemy/wizrobe
;@ The Wizrobe for the two-sprite renderer, 5 frames of 4 bytes (left tile, attributes, right
;@ tile, attributes): 0 appearing (tile $6E, mirrored), then by facing + 1: 1 right ($66 / $64
;@ mirrored), 2 left ($64 / $66), 3 up ($62 and its mirror), 4 down ($60 and its mirror).
WizrobeSprites::
	db $6e, $00, $6e, $20, $66, $20, $64, $20, $64, $00, $66, $00, $62, $00, $62, $20
	db $60, $00, $60, $20

;@ path: enemy/wizrobe
;@ Where the Wizrobe's shot starts, x offset by facing (0 right, 1 left, 2 up, 3 down): 8, -8,
;@ 0, 0.
WizrobeShotOffsetX::
	db $08, $f8, $00, $00

;@ path: enemy/wizrobe
;@ The shot's y offset by facing: 0, 0, -8, 8.
WizrobeShotOffsetY::
	db $00, $00, $f8, $08

;@ path: enemy/wizrobe
;@ The shot's x speed by facing: $20, -$20, 0, 0.
WizrobeShotSpeedX::
	db $20, $e0, $00, $00
;@ path: enemy/wizrobe
;@ The shot's y speed by facing: 0, 0, -$20, $20.
WizrobeShotSpeedY::
	db $00, $00, $e0, $20

;@ def WizrobeHandler(slot: bc)
;@ path: enemy/wizrobe
;@ Entity $21: the Wizrobe, a wizard that blinks into view, turns to Link, fires a magic shot
;@ (entity $22) and fades away again. It can only be hit while it attacks (physics flags 2;
;@ otherwise $42). wEntityPrivate1 is the fading direction: +1 appearing, -1 vanishing.
;@ States: 0 WizrobeHidden, 1 WizrobeFade, 2 WizrobeShown, 3 WizrobeAttack.
;@ test: skip draws sprites and calls banked helpers
WizrobeHandler::
;> DrawEntity16x16(slot, WizrobeSprites)
	ld de, WizrobeSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> WizrobeStates[wEntityState[slot]](slot)
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: enemy/wizrobe
;@ Wizrobe states: 0 WizrobeHidden, 1 WizrobeFade, 2 WizrobeShown, 3 WizrobeAttack.
WizrobeStates::
	dw WizrobeHidden
	dw WizrobeFade
	dw WizrobeShown
	dw WizrobeAttack

;@ def WizrobeHidden(slot: bc)
;@ path: enemy/wizrobe
;@ State 0: invisible until its timer runs out; then it starts to appear (state 1, fading +1,
;@ 32 frames).
;@ test: skip bank-0 helpers
WizrobeHidden::
;> if wEntityTimer[slot] == 0:
	ld hl, wEntityTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .next

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityPrivate1[slot] = 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $01
;>     wEntityTimer1[slot] = 0x20
	call GetEntityTimer1
	ld [hl], $20

.next
;> pass                                   # on at the hiding code in WizrobeFade          # frame $FF (not drawn), unhittable
	jr WizrobeFade.setEntitySpriteVariant

;@ def WizrobeFade(slot: bc)
;@ path: enemy/wizrobe
;@ State 1: blinks (shown every other 2 frames) while wEntityTimer1 runs; then it is shown
;@ (state 2) or hidden (state 0), by the fading direction, for 48 frames.
;@ test: skip bank-0 helpers
WizrobeFade::
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> if t == 0:
	jr nz, .checkT

;>@t1     wEntityState[slot] += wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	add [hl]
;=@t1
	ld [hl], a
;>     wEntityTimer[slot] = 0x30
	ld hl, wEntityTimer
	add hl, bc
	ld [hl], $30
;>     WizrobeSetUnhittable(slot)
	call WizrobeSetUnhittable
;>     return
	ret


.checkT
;> if t & 2 == 0:
	ld a, [hl]
	and $02
	jr nz, .setEntitySpriteVariant2

.setEntitySpriteVariant
;>     SetEntitySpriteVariant(slot, 0xFF)          # hide()
	ld a, $ff
	call SetEntitySpriteVariant
;>     WizrobeSetUnhittable(slot)
	call WizrobeSetUnhittable
;>     return
	ret


.setEntitySpriteVariant2
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> WizrobeSetUnhittable(slot)
	call WizrobeSetUnhittable
	ret


;@ def WizrobeShown(slot: bc)
;@ path: enemy/wizrobe
;@ State 2: visible (frame 0). Arms wEntityTimer1 with 24 frames; when they are over it either
;@ attacks (state 3) or, vanishing, blinks out (state 1, 32 frames).
;@ test: skip bank-0 helpers
WizrobeShown::
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> if t < 2:
	cp $02
	jr nc, .wizrobeSetUnhittable

;>     if t != 1:
	ld a, [hl]
	cp $01
	jr z, .setEntityState

;>         wEntityTimer1[slot] = 0x18
	ld [hl], $18
;>         WizrobeSetUnhittable(slot)
	call WizrobeSetUnhittable
;>         return
	ret


.setEntityState
;>@t2     wEntityState[slot] += wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	add [hl]
;=@t2
	ld [hl], a
;>     if wEntityState[slot] == 1:
	cp $01
	jr nz, .wizrobeSetUnhittable

;>         wEntityTimer1[slot] = 0x20
	call GetEntityTimer1
	ld [hl], $20

.wizrobeSetUnhittable
;> WizrobeSetUnhittable(slot)
	call WizrobeSetUnhittable
	ret


;@ def WizrobeAttack(slot: bc)
;@ path: enemy/wizrobe
;@ State 3: can be hit. Turns to Link (frame = facing + 1) for 64 frames (wEntityTimer1); at 40
;@ frames left it fires its shot from its front (WizrobeShotOffsetX / Y, speed $20); at the end
;@ it starts vanishing (fading -1, back to state 2).
;@ test: skip spawns an entity
WizrobeAttack::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> t = GetEntityTimer1(slot)
	call GetEntityTimer1
;> if t == 0x28:
	cp $28
;>     pass                                   # on at shoot                             # below
	jr z, .setShot

;> elif t < 2:
	cp $02
	jr nc, .setEntityPhysicsFlags

;>     if t != 1:
	ld a, [hl]
	cp $01
	jr z, .setEntityPrivate1

;>         wEntityTimer1[slot] = 0x40
	ld [hl], $40
;>         wEntityDirection[slot] = GetEntityDirectionToLink_06(slot)
	call GetEntityDirectionToLink_06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>         wEntitySpriteVariant[slot] = wEntityDirection[slot] + 1
	inc a
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;>         return
	ret


.setEntityPrivate1
;>     wEntityPrivate1[slot] = 0xFF            # vanish next
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $ff
;>     wEntityState[slot] -= 1
	ld hl, wEntityState
	add hl, bc
	dec [hl]
;>     return
	ret


.setShot
;> # shoot:
;> shot, full = SpawnEntity(slot, 0x22)
	ld a, $22
	call SpawnEntity
;> if not full:
	jr c, .setEntityPhysicsFlags

;>     d = hMultiPurpose2                     # the Wizrobe's facing
	push bc
	ldh a, [hMultiPurpose2]
;>     wEntityDirection[shot] = d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;>@t3     wEntityX[shot] = hMultiPurpose0 + mem[WizrobeShotOffsetX + d]
	ld c, a
	ld hl, WizrobeShotOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
;=@t3
	add hl, de
	ld [hl], a
;>@t4     wEntityY[shot] = hMultiPurpose1 + mem[WizrobeShotOffsetY + d]
	ld hl, WizrobeShotOffsetY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@t4
	ld [hl], a
;>     wEntitySpeedX[shot] = mem[WizrobeShotSpeedX + d]
	ld hl, WizrobeShotSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[shot] = mem[WizrobeShotSpeedY + d]
	ld hl, WizrobeShotSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[shot] = d
	pop bc
	ldh a, [hMultiPurpose2]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a

.setEntityPhysicsFlags
;> wEntityPhysicsFlags[slot] = 2               # hittable
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, $02
	ld [hl], a
	ret


;@ def WizrobeSetUnhittable(slot: bc)
;@ path: enemy/wizrobe
;@ Sets the Wizrobe's physics flags to $42 (attacks pass through it).
;@ test: slot = rng.randrange(16)
WizrobeSetUnhittable::
;> wEntityPhysicsFlags[slot] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $42
	ret


;@ path: item/instrument
;@ The sparkle burst around an instrument when Link warps out with it: 4 frames of 16 sprites
;@ (y, x, tile, attributes; relative to the instrument, 64 bytes each), shown in turn every 8
;@ frames. Frame 0: rays (tile $60 left / right at x -40 and +40, tile $62 above / below at
;@ y -40 and +40) and 4 diagonal sparkles (tile $6A) at y -16 / +16; frame 1: the rays at 24
;@ pixels, the rest blank (tile $FF); frame 2: corner sparkles (tile $68) at 32 pixels and small
;@ rays ($64 / $66) at 16; frame 3: the corner sparkles at 24 pixels, the rest blank.
InstrumentWarpEffectOAM::
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

;@ def DrawInstrumentWarpEffect()
;@ path: item/instrument
;@ Draws the instrument's sparkle burst (InstrumentWarpEffectOAM, frame = (hFrameCounter >> 3)
;@ & 3, 16 sprites). Called from bank 3 through DrawInstrumentWarpEffectFrom3.
;@ test: skip draws sprites
DrawInstrumentWarpEffect::
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> f = (hFrameCounter >> 3) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
;>@t5 offset = f * 64
	ld e, a
	ld d, b
	sla e
	rl d
	sla e
	rl d
;=@t5
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
;=@t5
	sla e
	rl d
;> DrawEntitySprites(InstrumentWarpEffectOAM + offset, 16)
	ld hl, InstrumentWarpEffectOAM
	add hl, de
	ld c, $10
	call DrawEntitySprites
;> ReserveOAMEntriesFar(16)
	ld a, $10
	call ReserveOAMEntriesFar
	ret


;@ path: enemy/anti_fairy
;@ The Anti-Fairy for the two-sprite renderer: tile $5A and its mirror, frame 0 in sprite palette
;@ 0, frame 1 in palette 1 (it flickers).
AntiFairySprites::
	db $5a, $00, $5a, $20, $5a, $10, $5a, $30

;@ def AntiFairyHandler(slot: bc)
;@ path: enemy/anti_fairy
;@ Entity $15: the Anti-Fairy (a skull in a ball of fire). It flies straight and bounces off the
;@ walls (x speed reversed at a side wall, else y speed at a top / bottom wall), flickering every
;@ 8 frames.
;@ test: skip draws sprites and calls banked helpers
AntiFairyHandler::
;> DrawEntity16x16(slot, AntiFairySprites)
	ld de, AntiFairySprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 3:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
;>@x     wEntitySpeedX[slot] = -wEntitySpeedX[slot]
	jr nz, .setEntitySpeedX

;> elif wEntityCollisions[slot] & 0x0C:
	ld a, [hl]
	and $0c
;>@y     wEntitySpeedY[slot] = -wEntitySpeedY[slot]
	jr nz, .setEntitySpeedY

	jr .setEntitySpriteVariant

.setEntitySpeedX
;=@x
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;=@y
	jr .setEntitySpriteVariant

.setEntitySpeedY
;=@y
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.setEntitySpriteVariant
;>@t1 SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;=@t1
	ret


;@ path: enemy/tektite
;@ The Tektite for the two-sprite renderer: frame 0 tile $58 (jumping), frame 1 tile $5A
;@ (crouching), each with its mirror.
TektiteSprites::
	db $58, $00, $58, $20, $5a, $00, $5a, $20

;@ path: enemy/tektite
;@ The Tektite's jump x speed for each of 4 diagonals: $10, -$10, $10, -$10.
TektiteJumpSpeedX::
	db $10, $f0, $10, $f0

;@ path: enemy/tektite
;@ The jump y speed for the same diagonals: $10, $10, -$10, -$10.
TektiteJumpSpeedY::
	db $10, $10, $f0, $f0

;@ def TektiteHandler(slot: bc)
;@ path: enemy/tektite
;@ Entity $0D: the Tektite, a spider that leaps about. State 0: in the air (gravity 1 per
;@ frame); on landing it stops and crouches (frame 1) for 16 to 79 frames (state 1). State 1:
;@ its legs twitch (frame 0 / 1 every 16 frames); when the wait is over at frame 0 it leaps
;@ (height speed $10-$17) diagonally at speed $10, or half the time at Link at speed $14.
;@ At walls: TektiteSideWallBounce / TektiteEndWallBounce (see there).
;@ test: skip draws sprites and calls banked helpers
TektiteHandler::
;> DrawEntity16x16(slot, TektiteSprites)
	ld de, TektiteSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> EntityCheckHits(slot)
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> p = addr(wEntityCollisions, slot)
	ld hl, wEntityCollisions
	add hl, bc
;> if mem[p] & 3:
	ld a, [hl]
	and $03
	jr z, .checkP

;>     p = TektiteSideWallBounce()             # leaves p = wEntitySpeedX
	call TektiteSideWallBounce

.checkP
;> if mem[p] & 0x0C:
	ld a, [hl]
	and $0c
	jr z, .checkActiveEntityState

;>     TektiteEndWallBounce(slot)
	call TektiteEndWallBounce

.checkActiveEntityState
;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, .setEntityPrivateCounter

;>     if wEntityZ[slot] & 0x80:              # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .addEntityZSpeedToPos

;>         wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>         ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>         wEntityState[slot] += 1
	ld hl, wEntityState
	add hl, bc
	inc [hl]
;>         wEntityTimer[slot] = 0x10 + GetRandomByte() & 0x3F
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $10
	ld [hl], a
;>         SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;>         return
	ret


.addEntityZSpeedToPos
;>     AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;>     wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;>     return
	ret


.setEntityPrivateCounter
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> frame = (wEntityPrivateCounter[slot] & 0x10) >> 4
	ld a, [hl]
	and $10
	srl a
	srl a
	srl a
	srl a
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> if frame:
	and a
;>     return
	jr nz, .return

;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return
	jr nz, .return

;>@t6 wEntitySpeedZ[slot] = 0x10 + GetRandomByte() & 7
	call GetRandomByte
	and $07
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
;=@t6
	ld [hl], a
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> d = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = mem[TektiteJumpSpeedX + d]
	ld hl, TektiteJumpSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = mem[TektiteJumpSpeedY + d]
	ld hl, TektiteJumpSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> if GetRandomByte() & 1:
	call GetRandomByte
	and $01
	jr z, .setEntityState

;>     SetEntitySpeedTowardsLink(slot, 0x14)
	ld a, $14
	call SetEntitySpeedTowardsLink

.setEntityState
;> wEntityState[slot] = 0
	ld hl, wEntityState
	add hl, bc
	xor a
	ld [hl], a
;> SetEntitySpriteVariant(slot, 0)
	call SetEntitySpriteVariant

.return
	ret


;@ def TektiteSideWallBounce() -> hl
;@ path: enemy/tektite
;@ Meant to bounce the Tektite back from a side wall, but it works on wEntitySpeedX without the
;@ slot offset, i.e. on slot 0's x speed: that becomes -x / 2. Returns hl = wEntitySpeedX.
;@ test: skip writes another slot
TektiteSideWallBounce::
;> p = wEntitySpeedX                         # slot 0
	ld hl, wEntitySpeedX
;> mem[p] = ((-mem[p] ^ 0x80) - 0x80) >> 1               # (shared tail)
	jr TektiteEndWallBounce.return

;@ def TektiteEndWallBounce(slot: bc)
;@ path: enemy/tektite
;@ At a top or bottom wall: the Tektite's x speed becomes -x / 2 (the y speed stays as it is).
;@ test: slot = rng.randrange(16)
;@ test: wEntitySpeedX[slot] = rng.randrange(256)
;@ test: wCurrentBank = $06
TektiteEndWallBounce::
;> p = addr(wEntitySpeedX, slot)
	ld hl, wEntitySpeedX
	add hl, bc

.return
;> mem[p] = ((-mem[p] ^ 0x80) - 0x80) >> 1
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a
	ret


;@ path: enemy/boo_buddy
;@ The Boo Buddy for the two-sprite renderer, 8 frames of 4 bytes: 0 / 1 facing right (tiles
;@ $62 / $60 and $66 / $64 mirrored), 2 / 3 facing left ($60 / $62, $64 / $66), 4 / 5 fleeing
;@ ($68, $6A with mirrors), 6 / 7 vanishing ($6E / $6C mirrored, $6C / $6E).
BooBuddySprites::
	db $62, $20, $60, $20, $66, $20, $64, $20, $60, $00, $62, $00, $64, $00, $66, $00
	db $68, $00, $68, $20, $6a, $00, $6a, $20, $6e, $20, $6c, $20, $6c, $00, $6e, $00

;@ def BooBuddyHandler(slot: bc)
;@ path: enemy/boo_buddy
;@ Entity $50: the Boo Buddy, a ghost. In the dark (wRoomEventCounter 0) it floats after Link
;@ and cannot be hurt; when Link swings his sword nearby it flickers out and reappears on the
;@ opposite side of the room. Once the room's torches are lit it flees from Link and dies from one
;@ hit. Removed when off screen. States: 0 BooBuddyHaunt, 1 BooBuddyFlee.
;@ test: skip draws sprites and calls banked helpers
BooBuddyHandler::
;> DrawEntity16x16(slot, BooBuddySprites)
	ld de, BooBuddySprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> CrowRemoveOffscreen(slot)
	call CrowRemoveOffscreen
;> BooBuddyStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/boo_buddy
;@ Boo Buddy states: 0 BooBuddyHaunt, 1 BooBuddyFlee.
BooBuddyStates::
	dw BooBuddyHaunt
	dw BooBuddyFlee

;@ def BooBuddyHaunt(slot: bc)
;@ path: enemy/boo_buddy
;@ State 0 (dark room). Normally it steers towards Link (speed 6-13, each axis 4 steps per frame
;@ towards it, BooBuddyStepSpeed), hurts him on touch and shows frames 0-3 (by Link's side,
;@ wings every 16 frames). When Link's sword swings (state 3) within 36 pixels it stops for 32
;@ frames, flickering (BooBuddyFlicker); at the end it jumps to the mirrored place
;@ (BooBuddyMirrorPosition) and flickers 32 more frames (wEntityTimer1). Lit torches: state 1.
;@ test: skip bank-0 helpers
BooBuddyHaunt::
;> if wRoomEventCounter:
	ld a, [wRoomEventCounter]
	and a
;>     return BooBuddyLightsOn()
	jp nz, BooBuddyLightsOn

;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     pass                                   # on at vanish                            # below
	jr nz, .clearEntitySpeed

;> if GetEntityTimer1(slot):
	call GetEntityTimer1
;>     pass                                   # on at appear                            # below
	jr nz, .clearEntitySpeed2

;> if wSwordAnimationState != 3:
	ld a, [wSwordAnimationState]
	cp $03
	jr z, .checkGetEntityXDistanceToLink

;>     GetVectorTowardsLink(slot, (GetRandomByte() ^ slot) & 7 + 6)
	call GetRandomByte
	xor c
	and $07
	add $06
	call GetVectorTowardsLink
;>     BooBuddyStepSpeed(wEntitySpeedY, hMultiPurpose0)
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	call BooBuddyStepSpeed
;>     BooBuddyStepSpeed(wEntitySpeedX, hMultiPurpose1)
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	call BooBuddyStepSpeed
;>     EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;>     pass                                   # on at walk_frame
	jr .setSide

.checkGetEntityXDistanceToLink
;> if u8(GetEntityXDistanceToLink_06(slot) + 0x24) >= 0x48:
	call GetEntityXDistanceToLink_06
	add $24
	cp $48
;>     pass                                   # on at walk_frame
	jr nc, .setSide

;> if u8(GetEntityYDistanceToLink_06(slot) + 0x24) >= 0x48:
	call GetEntityYDistanceToLink_06
	add $24
	cp $48
;>     pass                                   # on at walk_frame
	jr nc, .setSide

;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20

.clearEntitySpeed
;> # vanish:
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> BooBuddyFlicker(slot)
	call BooBuddyFlicker
;> if not wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, .return

;> BooBuddyMirrorPosition(slot)
	call BooBuddyMirrorPosition

.clearEntitySpeed2
;> # appear:
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> BooBuddyFlicker(slot)
	call BooBuddyFlicker
;> return
	ret


.setSide
;> # walk_frame:
;> side = GetEntityXDistanceToLink_06(slot)
	call GetEntityXDistanceToLink_06
;>@t7 SetEntitySpriteVariant(slot, side * 2 + (hFrameCounter >> 4) & 1)
	sla e
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
;=@t7
	and $01
	add e
	call SetEntitySpriteVariant

.return
	ret


BooBuddyLightsOn:
;> wEntityState[slot] = 1                    # BooBuddyLightsOn
	call IncrementEntityState
	ld [hl], $01
	ret


;@ def BooBuddyFlee(slot: bc)
;@ path: enemy/boo_buddy
;@ State 1 (torches lit): health 1, can be hit, flees from Link at speed 4 (frames 4 / 5 every 16
;@ frames). When the light goes out again: state 0.
;@ test: skip bank-0 helpers
BooBuddyFlee::
;> if not wRoomEventCounter:
	ld a, [wRoomEventCounter]
	and a
	jr z, .setEntityState
;>@d     wEntityState[slot] = 0
;>@r     return


;> wEntityHealth[slot] = 1
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $01
;> EntityCheckHits(slot)
	call EntityCheckHits
;> GetVectorTowardsLink(slot, 4)
	ld a, $04
	call GetVectorTowardsLink
;> wEntitySpeedY[slot] = -hMultiPurpose0
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = -hMultiPurpose1
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>@t8 wEntitySpriteVariant[slot] = 4 + (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@t8
	add $04
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	ret


.setEntityState
;=@d
	call IncrementEntityState
	ld [hl], b
;=@r
	ret


;@ def BooBuddyStepSpeed(speeds: hl, target: a, slot: bc)
;@ path: enemy/boo_buddy
;@ Moves speeds[slot] 4 steps towards the target value.
;@ test: skip pointer argument
BooBuddyStepSpeed::
;> diff = target - speeds[slot]
	add hl, bc
	sub [hl]
;> if diff == 0:
;>     return
	jr z, .return

;> if diff & 0x80:
	bit 7, a
	jr z, .otherwise

;>     speeds[slot] -= 4
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	jr .return

.otherwise
;> else:
;>     speeds[slot] += 4
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

.return
	ret


;@ def BooBuddyMirrorPosition(slot: bc)
;@ path: enemy/boo_buddy
;@ Puts the Boo Buddy at the opposite place of the room (mirrored around x $50, y $48) and
;@ starts 32 frames of flickering back in (wEntityTimer1).
;@ test: slot = rng.randrange(16)
;@ test: wEntityX[slot] = rng.randrange(256)
;@ test: wEntityY[slot] = rng.randrange(256)
;@ test: wCurrentBank = $06
BooBuddyMirrorPosition::
;> wEntityTimer1[slot] = 0x20
	call GetEntityTimer1
	ld [hl], $20
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $00
;>@t9 wEntityY[slot] = u8(0x48 - (wEntityY[slot] - 0x48))
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, a
	ld a, $48
;=@t9
	sub e
	ld [hl], a
;>@t10 wEntityX[slot] = u8(0x50 - (wEntityX[slot] - 0x50))
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $50
	ld e, a
	ld a, $50
;=@t10
	sub e
	ld [hl], a
	ret


;@ def BooBuddyFlicker(slot: bc)
;@ path: enemy/boo_buddy
;@ Shows the vanishing frame (6 or 7, by Link's side) every other 4 frames and nothing in
;@ between; wEntityPrivate1 = 1 on the frame its timer is 1 (time to move), else 0.
;@ test: skip bank-0 helpers
BooBuddyFlicker::
;> if (hFrameCounter >> 2) & 1:
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	jr z, .otherwise

;>@t11     frame = 6 + GetEntityXDistanceToLink_06(slot)      # by Link's side
	call GetEntityXDistanceToLink_06
	srl e
	jr c, .setFrame

	ld a, $06
	jr .setEntitySpriteVariant

.setFrame
;=@t11
	ld a, $07
	jr .setEntitySpriteVariant

.otherwise
;> else:
;>     frame = 0xFF
	ld a, $ff

.setEntitySpriteVariant
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;> if GetEntityTimer(slot) == 1:
	call GetEntityTimer
	cp $01
	jr nz, .return

;>     wEntityPrivate1[slot] = 1
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]

.return
	ret


;@ path: object/floating_item
;@ The floating items for the one-sprite renderer (8x16), 2 bytes each (tile, attributes; all in
;@ sprite palette 1), by kind 0-4: 0 rupee ($A6), 1 magic powder ($8E), 2 bomb ($80), 3 rupee
;@ ($A6), 4 heart ($A9).
FloatingItemSprites::
	db $a6, $10, $8e, $10, $80, $10, $a6, $10, $a9, $10

;@ path: object/floating_item
;@ Kind 5, the arrows, for the two-sprite renderer: tile $2A twice, flipped upside down (read as
;@ frame 5 of a 16x16 table starting 10 bytes before FloatingItemSprites).
FloatingItemArrowSprites::
	db $2a, $40, $2a, $60

;@ path: object/floating_item
;@ The two little wings that carry a floating item, for DrawEntitySprites: 2 frames (swapped
;@ every 8 frames) of 2 sprites (y, x, tile, attributes): tile $22 at x -4 and its mirror at x 12;
;@ in frame 1 both flipped upside down.
FloatingItemWingsOAM::
	db $00, $fc, $22, $00, $00, $0c, $22, $20, $00, $fc, $22, $40, $00, $0c, $22, $60

;@ path: object/floating_item
;@ Height of a floating item over 8 steps of 8 frames: 15, 15, 16, 17, 17, 17, 16, 15.
FloatingItemBob::
	db $0f, $0f, $10, $11, $11, $11, $10, $0f

;@ path: object/floating_item
;@ The same in side-view areas: 0, 0, 1, 2, 2, 2, 1, 0.
FloatingItemBobSideView::
	db $00, $00, $01, $02, $02, $02, $01, $00

;@ def FloatingItemHandler(slot: bc)
;@ path: object/floating_item
;@ Entity $86: an item carried by little wings, bobbing in the air (kind = sprite variant 0-5:
;@ rupees, magic powder, bombs, rupees, heart, arrows). On the overworld and in dungeons Link must
;@ jump to it (height 12 or more); in side-view areas touching is enough. Taking it plays wave
;@ sound 1 and gives FloatingItemRewards[kind].
;@ test: skip draws sprites and gives items
FloatingItemHandler::
;> bob = FloatingItemBobSideView if hIsSideScrolling else FloatingItemBob
	ld hl, FloatingItemBob
	ldh a, [hIsSideScrolling]
	and a
	jr z, .setEntityZ

	ld hl, FloatingItemBobSideView

.setEntityZ
;>@t1 wEntityZ[slot] = bob[(hFrameCounter >> 3) & 7]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
;=@t1
	ld d, b
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> if hActiveEntitySpriteVariant == 5:
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nz, .otherwise

;>     DrawEntity16x16(slot, FloatingItemSprites - 10)          # frame 5 = FloatingItemArrowSprites
	ld de, FloatingItemSprites - 10
	call DrawEntity16x16
	jr .drawEntitySprites

.otherwise
;> else:
;>     DrawEntity8x16(slot, FloatingItemSprites)
	ld de, FloatingItemSprites
	call DrawEntity8x16

.drawEntitySprites
;>@t2 DrawEntitySprites(FloatingItemWingsOAM + (hFrameCounter & 8), 2)
	ldh a, [hFrameCounter]
	and $08
	ld e, a
	ld d, b
	ld hl, FloatingItemWingsOAM
	add hl, de
;=@t2
	ld c, $02
	call DrawEntitySprites
;> ReserveOAMEntriesFar(1)
	ld a, $01
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> if not hIsSideScrolling and hLinkPositionZ < 0x0C:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .checkEntityTouchesLink

	ldh a, [hLinkPositionZ]
	cp $0c
;>     return
	jr c, FloatingItemRupees.return

.checkEntityTouchesLink
;> if not EntityTouchesLink(slot):
	call EntityTouchesLink
;>     return
	jr nc, FloatingItemRupees.return

;> DefeatEntity(slot)
	call DefeatEntity
;> ClearEntityStatus_06(slot)
	call ClearEntityStatus_06
;> hWaveSfx = 1
	ld a, $01
	ldh [hWaveSfx], a
;> FloatingItemRewards[hActiveEntitySpriteVariant]()
	ldh a, [hActiveEntitySpriteVariant]
	rst $00

;@ path: object/floating_item
;@ What each kind gives: 0 FloatingItemRupees, 1 FloatingItemMagicPowder, 2 FloatingItemBombs,
;@ 3 FloatingItemRupees, 4 FloatingItemHeart, 5 FloatingItemArrows.
FloatingItemRewards::
	dw FloatingItemRupees
	dw FloatingItemMagicPowder
	dw FloatingItemBombs
	dw FloatingItemRupees
	dw FloatingItemHeart
	dw FloatingItemArrows

;@ def FloatingItemHeart()
;@ path: object/floating_item
;@ Three hearts: 24 eighths more health to give (at most $FF in all).
;@ test: wAddHealthBuffer = rng.randrange(256)
FloatingItemHeart::
;>@t3 wAddHealthBuffer = min(wAddHealthBuffer + 0x18, 0xFF)
	ld a, [wAddHealthBuffer]
	add $18
	jr nc, .setAddHealthBuffer

	ld a, $ff

.setAddHealthBuffer
;=@t3
	ld [wAddHealthBuffer], a
	ret


;@ def FloatingItemArrows()
;@ path: object/floating_item
;@ Ten arrows (BCD, no limit check).
;@ test: wArrowCount = rng.randrange(0x90)
FloatingItemArrows::
;> wArrowCount = to_bcd((bcd_to_int(wArrowCount) + 10) % 100)
	ld a, [wArrowCount]
	add $10
	daa
	ld [wArrowCount], a
	ret


;@ def FloatingItemRupees()
;@ path: object/floating_item
;@ Ten rupees (added a little each frame).
;@ test: pass
FloatingItemRupees::
;> wAddRupeeBufferLow = 0x0A
	ld a, $0a
	ld [wAddRupeeBufferLow], a

.return
	ret


;@ def FloatingItemMagicPowder()
;@ path: object/floating_item
;@ Magic powder: Link gets the item (inventory item $0C) if he has none, the inventory is redrawn
;@ (hBGChangeRequest $0B) and 10 doses are added, up to wMaxMagicPowder.
;@ test: skip gives an item
FloatingItemMagicPowder::
;> GiveInventoryItemFar(0x0C)
	ld d, $0c
	call GiveInventoryItemFar
;> hBGChangeRequest = 0x0B
	ld a, $0b
	ldh [hBGChangeRequest], a
;> pass                                   # on at add_ten in FloatingItemBombs (count wMagicPowderCount, cap wMaxMagicPowder)
	ld hl, wMaxMagicPowder
	ld de, wMagicPowderCount
	jr FloatingItemBombs.checkCount

;@ def FloatingItemBombs()
;@ path: object/floating_item
;@ Ten bombs, up to wMaxBombs. The shared tail add_ten adds 10 (BCD) to the count at de, keeping it
;@ at most the capacity at hl, and does nothing when it is already full.
;@ test: wBombCount = rng.randrange(0x30)
;@ test: wMaxBombs = 0x30
FloatingItemBombs::
;> cap = addr(wMaxBombs)
	ld hl, wMaxBombs
;> count = addr(wBombCount)
	ld de, wBombCount

.checkCount
;> if mem[count] < mem[cap]:                 # add_ten
	ld a, [de]
	cp [hl]
	jr nc, .return2

;>     n = to_bcd((bcd_to_int(mem[count]) + 10) % 100)
	add $10
	daa
;>@t4     mem[count] = min(n, mem[cap])
	cp [hl]
	jr c, .return

	ld a, [hl]

.return
;=@t4
	ld [de], a

.return2
	ret


;@ path: enemy/gel
;@ The Gel for the one-sprite renderer (8x16): tile $56, frame 1 mirrored (it wobbles).
GelSprites::
	db $56, $00, $56, $20

;@ def GelHandler(slot: bc)
;@ path: enemy/gel
;@ Entity $1C: the Gel, a small blob that hops towards Link and can cling to him. Drawn small,
;@ then the common Gel / Zol code (GelZolCommon, in ZolHandler).
;@ test: skip draws sprites and calls banked helpers
GelHandler::
;> HideGelInTradeScene()
	call HideGelInTradeScene
;> DrawEntity8x16(slot, GelSprites)
	ld de, GelSprites
	call DrawEntity8x16
;> return GelZolCommon()
	jp GelZolCommon


;@ def HideGelInTradeScene()
;@ path: enemy/gel
;@ In rooms $97 and $98 of map $0A, once a trading-sequence scene has happened (wTradeSceneState),
;@ the Gel or Zol is not drawn (frame $FF).
;@ test: skip reads the active entity
HideGelInTradeScene::
;> if hMapId != 0x0A:
	ldh a, [hMapId]
	cp $0a
;>     return
	ret nz

;> if hMapRoom != 0x97 and hMapRoom != 0x98:
	ldh a, [hMapRoom]
	cp $97
	jr z, .checkTradeSceneState

	cp $98
;>     return
	ret nz

.checkTradeSceneState
;> if not wTradeSceneState:
	ld a, [wTradeSceneState]
	and a
;>     return
	ret z

;> hActiveEntitySpriteVariant = 0xFF
	ld a, $ff
	ldh [hActiveEntitySpriteVariant], a
	ret


;@ path: enemy/zol
;@ The Zol for the two-sprite renderer: frame 0 tile $52, frame 1 tile $54, each with its mirror.
ZolSprites::
	db $52, $00, $52, $20, $54, $00, $54, $20

;@ def ZolHandler(slot: bc)
;@ path: enemy/zol
;@ Entity $1B: the Zol, the big blob. When it is hit (flash timer at 8) it splits into two Gels:
;@ it becomes a Gel itself (type $1C, 4 pixels to the left) and spawns another 8 pixels to the
;@ right, both popping up (height speed $20) and keeping its place in the room's list.
;@ GelZolCommon, shared with the Gel: counts itself in wGelCount, falls with gravity 3 per frame
;@ (hMultiPurposeG = landed), wobbles (frame = state & 1, 8 frames at least), takes hits
;@ except while clinging (state 4) or dying. States: 0 GelRest, 1 GelHop, 2 GelShake, 3 GelLeap,
;@ 4 GelCling.
;@ test: skip draws sprites and calls banked helpers
ZolHandler::
;> HideGelInTradeScene()
	call HideGelInTradeScene
;> DrawEntity16x16(slot, ZolSprites)
	ld de, ZolSprites
	call DrawEntity16x16

GelZolCommon:
;> wGelCount += 1                           # GelZolCommon
	ld hl, wGelCount
	inc [hl]
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> AddEntityZSpeedToPos_06(slot)
	call AddEntityZSpeedToPos_06
;> wEntitySpeedZ[slot] -= 3
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;> hMultiPurposeG = landed
	ldh [hMultiPurposeG], a
;> if landed:
	jr z, .checkActiveEntityType

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.checkActiveEntityType
;>@t5 if hActiveEntityType == 0x1B and wEntityFlashTimer[slot] == 8:      # a Zol just hit
	ldh a, [hActiveEntityType]
	cp $1b
	jr nz, .applyRecoilIfNeeded

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
;=@t5
	cp $08
	jr nz, .applyRecoilIfNeeded

;>     wEntityFlashTimer[slot] = 0
	ld [hl], b
;>     order = wEntityLoadOrder[slot]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	push hl
	push af
;>     wEntityType[slot] = 0x1C
	ld hl, wEntityType
	add hl, bc
	ld [hl], $1c
;>     InitEntityPropertiesFar(slot)
	call InitEntityPropertiesFar
;>     wEntityLoadOrder[slot] = order
	pop af
	pop hl
	ld [hl], a
;>     wEntityX[slot] -= 4
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
;>     ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>     wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     gel, full = SpawnEntity(slot, 0x1C)
	ld a, $1c
	call SpawnEntity
;>     if not full:
	jr c, .applyRecoilIfNeeded

;>         wEntityLoadOrder[gel] = wEntityLoadOrder[slot]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	ld hl, wEntityLoadOrder
	add hl, de
	ld [hl], a
;>         wEntityX[gel] = hMultiPurpose0 + 8
	ldh a, [hMultiPurpose0]
	add $08
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[gel] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityZ[gel] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>         wEntitySpeedZ[gel] = 0x20
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20

.applyRecoilIfNeeded
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> if wEntityTimer2[slot] == 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkActiveEntityState

;>     frame = hActiveEntityState & 1
	ldh a, [hActiveEntityState]
	and $01
;>     wEntitySpriteVariant[slot] = frame
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;>     if frame == 1:
	dec a
	jr nz, .checkActiveEntityState

;>         wEntityTimer2[slot] = 8
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $08

.checkActiveEntityState
;>@t6 if hActiveEntityState != 4 and wEntityDyingTimer[slot] == 0:
	ldh a, [hActiveEntityState]
	cp $04
	jr z, .setGelStates

	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
;=@t6
	and a
	jr nz, .setGelStates

;>     EntityCheckHits(slot)
	call EntityCheckHits

.setGelStates
;> GelStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/gel
;@ Gel / Zol states: 0 GelRest, 1 GelHop, 2 GelShake, 3 GelLeap, 4 GelCling.
GelStates::
	dw GelRest
	dw GelHop
	dw GelShake
	dw GelLeap
	dw GelCling

;@ def GelHop(slot: bc)
;@ path: enemy/gel
;@ State 1: moves for its hop time; then stops for 16 frames and, 1 time in 16, gets ready for a
;@ big leap (state 2, 80 frames), else rests (state 0).
;@ test: skip bank-0 helpers
GelHop::
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return GelMove(slot)
	jr nz, GelMove

;> wEntityTimer[slot] = 0x10
	ld [hl], $10
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> if GetRandomByte() & 0x0F == 0:
	call GetRandomByte
	and $0f
	jr nz, .setEntityState

;>     wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;>     wEntityState[slot] += 1
	jp IncrementEntityState


.setEntityState
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> GelMove(slot)                                  # (falls through)

;@ def GelMove(slot: bc)
;@ path: enemy/gel
;@ Moves the blob; unless wEntityTimer1 runs, it is stopped by walls (the wall check runs with
;@ wEntityIgnoreHitsTimer 2, cleared afterwards).
;@ test: skip bank-0 helpers
GelMove::
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> if GetEntityTimer1(slot):
	call GetEntityTimer1
;>     return
	ret nz

;> wEntityIgnoreHitsTimer[slot] = 2
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $02
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ret


;@ def GelRest(slot: bc)
;@ path: enemy/gel
;@ State 0: drifts until its timer runs out, then hops towards Link (speed 4) for 7 frames
;@ (state 1).
;@ test: skip bank-0 helpers
GelRest::
;> GelMove(slot)
	call GelMove
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .return

;>     wEntityTimer[slot] = 7
	ld [hl], $07
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpeedTowardsLink(slot, 4)
	ld a, $04
	call SetEntitySpeedTowardsLink

.return
	ret


;@ def GelShake(slot: bc)
;@ path: enemy/gel
;@ State 2: shivers on the spot (x speed +8 / -8, switching every 4 frames); then leaps at Link
;@ (speed $10, height speed $20, state 3).
;@ test: skip bank-0 helpers
GelShake::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, .setEntitySpeedX

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpeedTowardsLink(slot, 0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     return
	ret


.setEntitySpeedX
;>@t7 wEntitySpeedX[slot] = -8 if GetEntityTimer(slot) & 4 else 8
	call GetEntityTimer
	ld hl, wEntitySpeedX
	add hl, bc
	and $04
	jr nz, .setEntitySpeedX2

	ld [hl], $08
;=@t7
	jr .setEntitySpeedY

.setEntitySpeedX2
;=@t7
	ld [hl], $f8

.setEntitySpeedY
;> wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;> return GelMove(slot)
	jp GelMove


;@ def GelLeap(slot: bc)
;@ path: enemy/gel
;@ State 3: in the air; when it lands it rests (state 0). If it lands on Link, the hit code makes
;@ it cling to him (state 4).
;@ test: skip bank-0 helpers
GelLeap::
;> GelMove(slot)
	call GelMove
;> if hMultiPurposeG:                   # landed
	ldh a, [hMultiPurposeG]
	and a
	jr z, .return

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.return
	ret


;@ def GelCling(slot: bc)
;@ path: enemy/gel
;@ State 4: stuck to Link, jiggling around him (x and y up to 4 pixels off, from the timer) at his
;@ height, slowing his walk animation. Every button press takes 4 frames off its timer. When the
;@ timer runs out it jumps off at speed $10 (height speed $20, state 3) and cannot hurt him for
;@ 48 frames (wEntityDyingTimer).
;@ test: skip changes Link's state
GelCling::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, .setEntityX

;>     wEntityDyingTimer[slot] = 0x30
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $30
;>     SetEntitySpeedTowardsLink(slot, 0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]
;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>     return
	ret


.setEntityX
;>@t8 wEntityX[slot] = hLinkX - ((t >> 1) & 7 - 4)
	push af
	rra
	and $07
	sub $04
	ld e, a
	ldh a, [hLinkX]
;=@t8
	sub e
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>@t9 wEntityY[slot] = hLinkY - ((t >> 2) & 7 - 4)
	pop af
	rra
	rra
	and $07
	sub $04
	ld e, a
;=@t9
	ldh a, [hLinkY]
	sub e
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> wLinkSlowAnimation = 1
	ld a, $01
	ld [wLinkSlowAnimation], a
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hJoypadPressed:
	ldh a, [hJoypadPressed]
	and a
	jr z, GelShakeOff.return

;>     GelShakeOff(slot)
	call GelShakeOff
;>     GelShakeOff(slot)
	call GelShakeOff
;>     GelShakeOff(slot)
	call GelShakeOff
;>     GelShakeOff(slot)                          # (falls through)

;@ def GelShakeOff(slot: bc)
;@ path: enemy/gel
;@ One frame off the clinging timer (if it is not 0 yet).
;@ test: slot = rng.randrange(16)
;@ test: wEntityTimer[slot] = rng.randrange(256)
;@ test: wCurrentBank = $06
GelShakeOff::
;> if GetEntityTimer(slot):
	call GetEntityTimer
	jr z, .return

;>     wEntityTimer[slot] -= 1
	dec [hl]

.return
	ret


;@ path: enemy/like_like
;@ The Like Like for the two-sprite renderer: frame 0 tile $7C, frame 1 tile $7E, each with its
;@ mirror.
LikeLikeSprites::
	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

;@ def LikeLikeHandler(slot: bc)
;@ path: enemy/like_like
;@ Entity $23: the Like Like, a tube-shaped blob that swallows Link (and eats his shield). States
;@ (wEntityPrivate3): 0 LikeLikeWalk, 1 LikeLikeSwallow.
;@ test: skip draws sprites and calls banked helpers
LikeLikeHandler::
;> DrawEntity16x16(slot, LikeLikeSprites)
	ld de, LikeLikeSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> ApplyRecoilIfNeeded_06(slot)
	call ApplyRecoilIfNeeded_06
;> LikeLikeStates[wEntityPrivate3[slot]](slot)
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: enemy/like_like
;@ Like Like states (wEntityPrivate3): 0 LikeLikeWalk, 1 LikeLikeSwallow.
LikeLikeStates::
	dw LikeLikeWalk
	dw LikeLikeSwallow

;@ def LikeLikeWalk(slot: bc)
;@ path: enemy/like_like
;@ State 0: walks like a Gibdo (GibdoWalk) and takes weapon hits; when it touches Link (and its
;@ drop timer, the cooldown after spitting him out, is over) it swallows him (state 1).
;@ test: skip bank-0 helpers
LikeLikeWalk::
;> if not GetEntityDropTimer(slot) and EntityCheckContactDamage(slot):
	call GetEntityDropTimer
	jr nz, .entityCheckWeaponHits

	call EntityCheckContactDamage
	jr nc, .entityCheckWeaponHits

;>     wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;>     wEntityPrivateCounter[slot] = 0           # button presses
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b

.entityCheckWeaponHits
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> return GibdoWalk(slot)
	jp GibdoWalk


;@ def LikeLikeSwallow(slot: bc)
;@ path: enemy/like_like
;@ State 1: Link is inside (not drawn, held at its place on the ground while he is in normal
;@ motion); it chews fast (two animation steps per frame). If a button is on the plain shield
;@ (item 4, shield level below 2), it eats it: the button is emptied and the level kept in
;@ wEntityPrivate1 (given back when it is defeated). 8 presses of A or B free Link; then it
;@ cannot swallow him for 21 frames.
;@ test: skip changes Link's state
LikeLikeSwallow::
;> if hJoypadPressed & 0x30:                  # A or B
	ldh a, [hJoypadPressed]
	and $30
	jr z, .setLinkAnimationState

;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] >= 8:
	ld a, [hl]
	cp $08
	jr c, .setLinkAnimationState

;>         wEntityDropTimer[slot] = 0x15
	call GetEntityDropTimer
	ld [hl], $15
;>         wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
;>         return
	ret


.setLinkAnimationState
;> hLinkAnimationState = 0xFF
	ld a, $ff
	ldh [hLinkAnimationState], a
;> if wEntityPrivate1[slot] == 0:               # no shield eaten yet
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .checkLinkMotionState

;>     for e, button in enumerate((wItemB, wItemA)):
	ld hl, wItemB
	ld e, b

.checkButton
;>         if mem[button] == 4:                 # the shield
	ld a, [hl]
	cp $04
	jr nz, .setBreak

;>             if wShieldLevel >= 2:
	ld a, [wShieldLevel]
	cp $02
;>                 break                        # the Mirror Shield cannot be eaten
	jr nc, .checkLinkMotionState

;>             mem[button] = 0
	ld [hl], b
;>             wEntityPrivate1[slot] = wShieldLevel
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [wShieldLevel]
	ld [hl], a
;>@t10             break
	jr .checkLinkMotionState

.setBreak
;=@t10
	inc hl
	inc e
	ld a, e
	cp $02
	jr nz, .checkButton

.checkLinkMotionState
;> if wLinkMotionState != 0:
	ld a, [wLinkMotionState]
	cp $00
;>     return
	ret nz

;> hLinkX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;> hLinkY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hLinkY], a
;> wIsLinkInTheAir = 0
	xor a
	ld [wIsLinkInTheAir], a
;> hLinkPositionZ = 0
	ldh [hLinkPositionZ], a
;> GibdoWalkFrame(slot)
	call GibdoWalkFrame
;> GibdoWalkFrame(slot)
	call GibdoWalkFrame
	ret


;@ path: enemy/gibdo
;@ The Gibdo for the two-sprite renderer: frame 0 tiles $74 / $76, frame 1 the same mirrored.
GibdoSprites::
	db $74, $00, $76, $00, $76, $20, $74, $20

;@ path: enemy/gibdo
;@ The same frames with tiles $44 / $46, used on map 7.
GibdoSpritesAlt::
	db $44, $00, $46, $00, $46, $20, $44, $20
;@ path: enemy/gibdo
;@ Walking speeds: x speed = one of bytes 0-3 (0, 8, -8, 0); when that is 0, the y speed is byte
;@ 4 or 5 (-8, 8).
GibdoWalkSpeeds::
	db $00, $08, $f8, $00, $f8, $08

;@ def GibdoHandler(slot: bc)
;@ path: enemy/gibdo
;@ Entity $1F: the Gibdo, a mummy that walks up / down / left / right at speed 8 (GibdoWalk).
;@ Burning it turns it into a Stalfos (see the burning code).
;@ test: skip draws sprites and calls banked helpers
GibdoHandler::
;> sprites = GibdoSpritesAlt if hMapId == 7 else GibdoSprites
	ld de, GibdoSprites
	ldh a, [hMapId]
	cp $07
	jr nz, .drawEntity16x16

	ld de, GibdoSpritesAlt

.drawEntity16x16
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive_06()
	call ReturnIfNonInteractive_06
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits(slot)
	call EntityCheckHits
;> GibdoWalk(slot)                                # (falls through)

;@ def GibdoWalk(slot: bc)
;@ path: enemy/gibdo
;@ The walk of the Gibdo and the Like Like: moves, turns back at walls (the speed's sign flipped
;@ with xor $F0), and picks a new direction from GibdoWalkSpeeds when wEntityState is set (the
;@ first time) or 1 time in 64 frames; then the walking frame.
;@ test: skip bank-0 helpers
GibdoWalk::
;> UpdateEntityPosWithSpeed_06(slot)
	call UpdateEntityPosWithSpeed_06
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 3:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
;>@x     wEntitySpeedX[slot] ^= 0xF0
	jr nz, .setEntitySpeedX

;> elif wEntityCollisions[slot] & 0x0C:
	ld a, [hl]
	and $0c
	jr z, .checkEntityState

;>     wEntitySpeedY[slot] ^= 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jr .checkEntityState

.setEntitySpeedX
;=@x
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a

.checkEntityState
;>@t11 if wEntityState[slot] or GetRandomByte() & 0x3F == 0:
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .setEntitySpeedY

;=@t11
	call GetRandomByte
	and $3f
	jr nz, .setEntityState

.setEntitySpeedY
;>     wEntitySpeedY[slot] = 0
	xor a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>@t12     wEntitySpeedX[slot] = mem[GibdoWalkSpeeds + (GetRandomByte() & 3)]
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, GibdoWalkSpeeds
	add hl, de
;=@t12
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     if wEntitySpeedX[slot] == 0:
	and a
	jr nz, .setEntityState

;>@t13         wEntitySpeedY[slot] = mem[GibdoWalkSpeeds + (4 + GetRandomByte() & 1)]
	call GetRandomByte
	and $01
	add $04
	ld e, a
	ld d, b
	ld hl, GibdoWalkSpeeds
;=@t13
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.setEntityState
;> wEntityState[slot] = 0
	ld hl, wEntityState
	add hl, bc
	xor a
	ld [hl], a
;> GibdoWalkFrame(slot)                           # (falls through)

;@ def GibdoWalkFrame(slot: bc)
;@ path: enemy/gibdo
;@ Walking frame: wEntityPrivate4 counts up, frame = (count >> 4) & 1.
;@ test: slot = rng.randrange(16)
;@ test: wEntityPrivate4[slot] = rng.randrange(256)
;@ test: wCurrentBank = $06
GibdoWalkFrame::
;> n = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
;> wEntityPrivate4[slot] += 1
	inc [hl]
;> return SetEntitySpriteVariant(slot, (n >> 4) & 1)
	rra
	rra
	rra
	rra
	and $01
	jp SetEntitySpriteVariant


;@ path: unused
;@ Unused end of bank 6: 18 bytes of $FF.
Bank06Padding::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff
