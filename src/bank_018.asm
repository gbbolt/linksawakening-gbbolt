; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $018", ROMX[$4000], BANK[$18]

;@ def MamuEntityHandler(slot: c)
;@ path: npc/mamu
;@ Entity $C3: Mamu, the singing frog in the cave of the Signpost Maze area, and his two backing
;@ frogs (the same entity type: the one standing at x = $48 is Mamu, the others are frogs, see
;@ MamuFrogHandler). For 300 rupees Mamu performs the Frog's Song of Soul and teaches it to
;@ Link's ocarina. The first frame in the room draws the stage layout (screen layout $14).
;@ test: skip runs a state machine with dialogues and sprite drawing
MamuEntityHandler::
;> if not wRoomEntitySetupDone:
	ld a, [wRoomEntitySetupDone]
	and a
	jr nz, .setupDone

;>     wRoomEntitySetupDone = 1
	inc a
	ld [wRoomEntitySetupDone], a
;>     wBGMapToLoad = 0x14         # the stage
	ld a, $14
	ld [wBGMapToLoad], a

.setupDone
;> if hActiveEntityX != 0x48:     # not Mamu: one of the backing frogs
	ldh a, [hActiveEntityX]
	cp $48
;>     return MamuFrogHandler(slot)
	jp nz, MamuFrogHandler

;> DrawMamu()
	call DrawMamu
;> PushLinkOutOfEntity_18(slot)   # Mamu is solid
	call PushLinkOutOfEntity_18
;> return MamuStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mamu
;@ Mamu's states (wEntityState), 2-byte code addresses: 0 MamuWaitForLink, 1 MamuAskToPlay,
;@ 2 MamuWaitBeforeSong, 3 MamuPerformSong, 4 MamuEndSong, 5 MamuTeachSong, 6 MamuFinish.
MamuStates::
	dw MamuWaitForLink
	dw MamuAskToPlay
	dw MamuWaitBeforeSong
	dw MamuPerformSong
	dw MamuEndSong
	dw MamuTeachSong
	dw MamuFinish

;@ def MamuWaitForLink(slot: c)
;@ path: npc/mamu
;@ State 0. Once Link knows the Frog's Song of Soul, talking to Mamu only gives his closing words
;@ (dialogue $E0). Before that, Link is stopped when he walks up to the line y = $4C in front of
;@ the stage: Mamu speaks to him - dialogue $DB when Link has no ocarina (item 9) on a button or in
;@ the inventory; dialogue $DC with the offer to sing for 300 rupees when he has (then state 1).
;@ test: skip opens dialogues
MamuWaitForLink::
;> mem[0xD201] = 0
	xor a
	ld [$d201], a
;> if wOcarinaSongFlags & 0x01:   # Frog's Song of Soul already learnt
	ld a, [wOcarinaSongFlags]
	and $01
	jr z, .notLearnt

;>     near = (hLinkY - hActiveEntityY + 0x28) & 0xFF < 0x50
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $28
	cp $50
;>     if not CheckLinkCanTalkX_18(near):
	call CheckLinkCanTalkX_18
;>         return MamuAnimate()
	jr nc, MamuAnimate

;>     return MamuSayAlreadyLearnt()
	jp MamuSayAlreadyLearnt

.notLearnt
;> if hLinkY >= 0x4C:             # Link has not come up to the stage yet
	ldh a, [hLinkY]
	cp $4c
;>     return MamuAnimate()
	jr nc, MamuAnimate

;> hLinkY = 0x4C                  # stop Link at the edge of the stage
	ld a, $4c
	ldh [hLinkY], a
;> Call_1495()                    # Link's speed to 0
	call Call_1495
;> ResetSpinAttackAndDash()                    # stop a sword charge or dash
	call ResetSpinAttackAndDash
;>@loop for i in range(12):        # the B and A items and the 10 inventory slots
	ld e, $0b
	ld hl, wItemB

.search
;>     if mem[0xDB00 + i] == 9:    # the ocarina
;>         break
	ld a, [hli]
	cp $09
	jr z, .hasOcarina

;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .search

;> else:                          # no ocarina
;>     MamuOpenDialog(0xDB)
	ld a, $db
	call MamuOpenDialog
;>     wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b
;>     return
	ret

.hasOcarina
;> MamuOpenDialog(0xDC)           # the offer: a song for 300 rupees
	ld a, $dc
	call MamuOpenDialog
;> Call_3B8D()                    # next state: MamuAskToPlay
	call Call_3B8D
;> MamuAnimate()                  # falls through

;@ def MamuAnimate()
;@ path: npc/mamu
;@ Mamu's idle animation: sprite variant 0 and 1, switching every 16 frames.
;@ test: skip sets the sprite variant through bank 0
MamuAnimate::
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> Call_3B87(v)                   # set the sprite variant
	call Call_3B87
	ret


;@ def MamuOpenDialog(dialog: a)
;@ path: npc/mamu
;@ Opens dialogue `dialog` (table 0) as if Link stood at y = $10, so the box is placed at the
;@ bottom of the screen, below the stage.
;@ test: skip opens a dialogue
MamuOpenDialog::
;> y = hLinkY
	ld e, a
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x10
	ld a, $10
	ldh [hLinkY], a
;> OpenDialog(dialog)
	ld a, e
	call OpenDialog
;> hLinkY = y
	pop af
	ldh [hLinkY], a
	ret


;@ def MamuAskToPlay(slot: c)
;@ path: npc/mamu
;@ State 1: waits for the answer to the offer. "No", or fewer than 300 rupees: dialogue $DE and
;@ back to state 0. "Yes": 300 rupees are taken, the music stops, the performance variables are
;@ reset and the alternating background (where the stage lights are drawn) is switched on; state
;@ 2 then waits $FF frames.
;@ test: skip opens dialogues
MamuAskToPlay::
;> MamuAnimate()
	call MamuAnimate
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> Call_3B8D()                    # next state
	call Call_3B8D
;>@cond if wDialogAnswer != 0 or wRupeeCountHigh < 3:   # "no", or not enough money
	ld a, [wDialogAnswer]
	and a
	jr z, .yes

.no
;>     wEntityState[slot] = 0
	ld [hl], b
;>     MamuOpenDialog(0xDE)
	ld a, $de
	call MamuOpenDialog
;>     return
	ret

.yes
;=@cond
	ld a, [wRupeeCountHigh]
	cp $03
	jr c, .no

;> wSubtractRupeeBufferLow += 0x2C   # 300 rupees to pay (0x012C)
	ld a, [wSubtractRupeeBufferLow]
	add $2c
	ld [wSubtractRupeeBufferLow], a
;> wSubtractRupeeBufferHigh += 0x01 + carry
	ld a, [wSubtractRupeeBufferHigh]
	adc $01
	ld [wSubtractRupeeBufferHigh], a
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> ResetSoundEngine()                    # stop the area music
	call ResetSoundEngine
;> ResetSongShow()
	call ResetSongShow
;> wAlternateBackgroundEnabled = 1
	ld a, $01
	ld [wAlternateBackgroundEnabled], a

.done
	ret

;@ def MamuWaitBeforeSong(slot: c)
;@ path: npc/mamu
;@ State 2: Link is frozen while the timer runs; then the song (music $35) starts, the frogs
;@ follow Mamu's dance (wSongShowPlaying) and the performance begins (state 3).
;@ test: skip runs the entity timer
MamuWaitBeforeSong::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .wait

;>     wMusicTrackToPlay = 0x35   # the Frog's Song of Soul performance
	ld a, $35
	ld [wMusicTrackToPlay], a
;>     wSongShowPlaying = 1
	ld a, $01
	ld [wSongShowPlaying], a
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.wait
	ret

;@ def MamuLightSmallLeft()
;@ path: npc/mamu
;@ Turns on the small stage light above the left frog (x $18, y $30).
;@ test: skip queues a background draw command
MamuLightSmallLeft::
;> hBGPosY = 0x30
	ld a, $30
	ldh [hBGPosY], a
;> hBGPosX = 0x18
	ld a, $18
	ldh [hBGPosX], a
;> return DrawLightSmall()
	jp DrawLightSmall

;@ def MamuLightSmallRight()
;@ path: npc/mamu
;@ Turns on the small stage light above the right frog (x $68, y $30).
;@ test: skip queues a background draw command
MamuLightSmallRight::
;> hBGPosY = 0x30
	ld a, $30
	ldh [hBGPosY], a
;> hBGPosX = 0x68
	ld a, $68
	ldh [hBGPosX], a
;> return DrawLightSmall()
	jp DrawLightSmall

;@ def MamuLightWideLeft()
;@ path: npc/mamu
;@ Turns on the left half of the big stage light above Mamu (x $38, y $08).
;@ test: skip queues a background draw command
MamuLightWideLeft::
;> hBGPosX = 0x38
	ld a, $38
	ldh [hBGPosX], a
;> hBGPosY = 0x08
	ld a, $08
	ldh [hBGPosY], a
;> return DrawLightWideLeftHalf()
	jp DrawLightWideLeftHalf

;@ def MamuLightWideRight()
;@ path: npc/mamu
;@ Turns on the right half of the big stage light above Mamu (columns 3-5 from x $38, y $08).
;@ test: skip queues a background draw command
MamuLightWideRight::
;> hBGPosX = 0x38
	ld a, $38
	ldh [hBGPosX], a
;> hBGPosY = 0x08
	ld a, $08
	ldh [hBGPosY], a
;> return DrawLightWideRightHalf()
	jp DrawLightWideRightHalf

	ret                             ; never reached

;@ path: npc/mamu
;@ Mamu's sprite variant (0-4, see MamuSpriteFrames) for each of the 58 steps of the dance
;@ (index wSongShowStep; a step lasts $1C frames). One byte per step. Read by MamuPerformSong.
MamuDanceFrames::
	db $03, $03, $03, $03, $03, $03, $03, $01
	db $02, $04, $03, $01, $02, $04, $03, $01, $02, $04, $03, $01, $02, $04, $03, $01
	db $02, $04, $03, $03, $03, $03, $03, $04, $03, $01, $02, $04, $03, $01, $02, $04
	db $03, $01, $02, $04, $03, $01, $02, $04, $03, $01, $02, $02, $02, $02, $02, $02
	db $02, $02

;@ path: npc/mamu
;@ Sprite variant of the frog in slot 1 (0-5, see DrawMamuFrog) for each of the 58 dance steps.
;@ One byte per step; MamuPerformSong writes it into wEntitySpriteVariant[1].
MamuDanceFrogFramesA::
	db $01, $01, $05, $05, $05, $05, $05, $05, $01, $01, $04, $01, $05, $01
	db $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $05
	db $05, $05, $01, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01
	db $05, $01, $04, $01, $05, $01, $04, $04, $04, $04, $04, $04

;@ path: npc/mamu
;@ Sprite variant of the frog in slot 2 (0-5, see DrawMamuFrog) for each of the 58 dance steps.
;@ One byte per step; MamuPerformSong writes it into wEntitySpriteVariant[2].
MamuDanceFrogFramesB::
	db $01, $01, $01, $01
	db $05, $05, $05, $05, $01, $01, $01, $01, $04, $01, $05, $01, $04, $01, $05, $01
	db $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $05, $01, $01, $01, $01
	db $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01
	db $05, $01, $04, $04, $04, $04

;@ def MamuPerformSong(slot: c)
;@ path: npc/mamu
;@ State 3: the performance. Link is frozen. On frames 0 and 1 the big light above Mamu turns on,
;@ on frames $38 and $70 the small lights above the frogs (all drawn into the alternate
;@ background, so they shimmer). Every $1C frames the dance goes one step on: Mamu's frame and
;@ both frogs' frames come from the three dance tables. At frame $0620 the song is over:
;@ dialogue $DD, the lights go off and state 4 follows.
;@ test: skip opens a dialogue and queues background draws
MamuPerformSong::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> if wSongShowTimer < 0x100:
	ld a, [wSongShowTimer + 1]
	and a
	jr nz, .count

;>     if wSongShowTimer == 0x00:
	ld a, [wSongShowTimer]
	cp $00
;>         MamuLightWideLeft()
	call z, MamuLightWideLeft
;>     if wSongShowTimer == 0x01:
	ld a, [wSongShowTimer]
	cp $01
;>         MamuLightWideRight()
	call z, MamuLightWideRight
;>     if wSongShowTimer == 0x38:
	ld a, [wSongShowTimer]
	cp $38
;>         MamuLightSmallLeft()
	call z, MamuLightSmallLeft
;>     if wSongShowTimer == 0x70:
	ld a, [wSongShowTimer]
	cp $70
;>         MamuLightSmallRight()
	call z, MamuLightSmallRight

.count
;>@inc wSongShowTimer += 1            # 16-bit
	ld a, [wSongShowTimer]
	add $01
	ld [wSongShowTimer], a
	ld e, a
	ld a, [wSongShowTimer + 1]
;=@inc
	adc $00
	ld [wSongShowTimer + 1], a
	ld d, a
;> if wSongShowTimer == 0x0620:   # the song is over
	cp $06
	jr nz, .dance

	ld a, e
	cp $20
	jr nz, .dance

;>     MamuOpenDialog(0xDD)
	ld a, $dd
	call MamuOpenDialog
;>     wAlternateBackgroundEnabled = 0   # lights off
	xor a
	ld [wAlternateBackgroundEnabled], a
;>     Call_3B8D()                # next state
	call Call_3B8D
;>     return
	ret

.dance
;> t = wSongShowStepTimer + 1
	ld a, [wSongShowStepTimer]
	inc a
;> if t == 0x1C:
	cp $1c
	jr nz, .setStepTimer

;>     wSongShowStep += 1
	ld a, [wSongShowStep]
	inc a
	ld [wSongShowStep], a
;>     t = 0
	xor a

.setStepTimer
;> wSongShowStepTimer = t
	ld [wSongShowStepTimer], a
;> step = wSongShowStep
	ld a, [wSongShowStep]
	ld e, a
	ld d, b
;> Call_3B87(MamuDanceFrames[step])   # Mamu's sprite variant
	ld hl, MamuDanceFrames
	add hl, de
	ld a, [hl]
	call Call_3B87
;> wEntitySpriteVariant[1] = MamuDanceFrogFramesA[step]
	ld hl, MamuDanceFrogFramesA
	add hl, de
	ld a, [hl]
	ld [wEntitySpriteVariant + 1], a
;> wEntitySpriteVariant[2] = MamuDanceFrogFramesB[step]
	ld hl, MamuDanceFrogFramesB
	add hl, de
	ld a, [hl]
	ld [wEntitySpriteVariant + 2], a
	ret

	ret                             ; never reached

;@ def MamuEndSong(slot: c)
;@ path: npc/mamu
;@ State 4: when the closing dialogue is gone, the frogs go back to their own animation, the
;@ teaching jingle (music $10) plays and state 5 runs for $70 frames.
;@ test: skip runs the entity timer
MamuEndSong::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .animate

;>     wSongShowPlaying = 0
	ld [wSongShowPlaying], a
;>     wEntityTimer[slot] = 0x70
	call GetEntityTimer
	ld [hl], $70
;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>     Call_3B8D()                # next state
	call Call_3B8D

.animate
;> return MamuAnimate()
	jp MamuAnimate

;@ def MamuTeachSong(slot: c)
;@ path: npc/mamu
;@ State 5: Link holds up what he learnt (pose $6C, SongLearntSprite above his head). With 8
;@ frames left, dialogue $DF says that he learnt the song; at the end the Frog's Song of Soul
;@ (song 2) is learnt and selected, and state 6 follows.
;@ test: skip runs the entity timer and draws sprites
MamuTeachSong::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .counting

;>     wSelectedSong = 2
	ld a, $02
	ld [wSelectedSong], a
;>     wOcarinaSongFlags |= 0x01  # Frog's Song of Soul
	ld hl, wOcarinaSongFlags
	set 0, [hl]
;>     Call_3B8D()                # next state
	call Call_3B8D
;>     return
	ret

.counting
;> if t == 8:
	cp $08
	jr nz, .holdUp

;>     wEntityTimer[slot] -= 1    # only once
	dec [hl]
;>     MamuOpenDialog(0xDF)
	ld a, $df
	call MamuOpenDialog

.holdUp
;> hLinkAnimationState = 0x6C     # Link holds something up
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hActiveEntityX = hLinkX
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = hLinkY - 12
	ldh a, [hLinkY]
	sub $0c
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	ld de, SongLearntSprite
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> Call_3CD0(SongLearntSprite)    # one sprite above Link's head
	call Call_3CD0
;> return MamuAnimate()
	jp MamuAnimate

;@ def MamuFinish(slot: c)
;@ path: npc/mamu
;@ State 6: once the dialogue is closed, Link is free again, Mamu goes back to state 0 and gives
;@ his closing words (dialogue $E0) - also shown whenever Link talks to him afterwards
;@ (MamuSayAlreadyLearnt).
;@ test: skip opens a dialogue
MamuFinish::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return MamuAnimate()
	jr nz, MamuSayAlreadyLearnt.animate

;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b

MamuSayAlreadyLearnt:
;> MamuOpenDialog(0xE0)
	ld a, $e0
	call MamuOpenDialog

.animate
;> return MamuAnimate()
	jp MamuAnimate


;@ path: npc/mamu
;@ Mamu's 5 sprite frames (variant 0-4), 32 bytes each: 8 entries of 4 bytes - y offset, x offset,
;@ tile, attributes ($20 = mirrored) - for 8x16 sprites in a 4 x 2 grid (32 x 32 pixels). All share
;@ the bottom row (tiles $68-$6E). Frame 0: top tiles $60-$66 (idle), 1: $70-$76, 2: $78-$7E,
;@ 3: frame 2 mirrored, 4: frame 1 mirrored. Drawn by DrawMamu.
MamuSpriteFrames::
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $70, $00, $00, $08, $72, $00, $00, $10, $74, $00, $00, $18, $76, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $78, $00, $00, $08, $7a, $00, $00, $10, $7c, $00, $00, $18, $7e, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $7e, $20, $00, $08, $7c, $20, $00, $10, $7a, $20, $00, $18, $78, $20
	db $10, $00, $6e, $20, $10, $08, $6c, $20, $10, $10, $6a, $20, $10, $18, $68, $20
	db $00, $00, $76, $20, $00, $08, $74, $20, $00, $10, $72, $20, $00, $18, $70, $20
	db $10, $00, $6e, $20, $10, $08, $6c, $20, $10, $10, $6a, $20, $10, $18, $68, $20

;@ def DrawMamu()
;@ path: npc/mamu
;@ Draws Mamu's current frame (8 sprites from MamuSpriteFrames) and claims the 4 OAM entries
;@ beyond the entity's usual 4.
;@ test: skip draws sprites
DrawMamu::
;>@fr frame = MamuSpriteFrames + hActiveEntitySpriteVariant * 32
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
;=@fr
	and $e0
	ld e, a
	ld d, b
	ld hl, MamuSpriteFrames
	add hl, de
;> Call_3D26(frame, 8)            # draw 8 sprites
	ld c, $08
	call Call_3D26
;> Call_3DD0(4)                   # claim 4 more OAM entries
	ld a, $04
	call Call_3DD0
	ret


;@ def MamuFrogHandler(slot: c)
;@ path: npc/mamu
;@ The two backing frogs (entity $C3 away from x = $48): they stand on the stage at y = $4A, are
;@ solid, and croak on their own (MamuFrogIdle) except during the song, when Mamu sets their
;@ frames.
;@ test: skip draws sprites
MamuFrogHandler::
;> wEntityY[slot] = 0x4A
	ld hl, wEntityY
	add hl, bc
	ld [hl], $4a
;> wEntityHitboxFlags[slot] = 0x98
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $98
;> Call_3B65(slot)                # hitbox from the flags
	call Call_3B65
;> DrawMamuFrog()
	call DrawMamuFrog
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> return MamuFrogStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mamu
;@ States of a backing frog (wEntityState): 0 MamuFrogInit, 1 MamuFrogIdle.
MamuFrogStates::
	dw MamuFrogInit
	dw MamuFrogIdle

;@ def MamuFrogInit(slot: c)
;@ path: npc/mamu
;@ State 0: starts the frog's animation counter at a random value (the frogs do not croak in step)
;@ and goes on to state 1 at once.
;@ test: c = rand(0, 15)
MamuFrogInit::
;> wEntityPrivateCounter[slot] = GetRandomByte()   # random byte
	call GetRandomByte
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], a
;> Call_3B8D()                    # next state
	call Call_3B8D
;> MamuFrogIdle(slot)             # falls through

;@ def MamuFrogIdle(slot: c)
;@ path: npc/mamu
;@ State 1: unless Mamu's song plays, the frog shows sprite variant 1, and variant 0 for 16 of
;@ every 64 frames of its counter.
;@ test: c = rand(0, 15)
MamuFrogIdle::
;> if wSongShowPlaying:
	ld a, [wSongShowPlaying]
	and a
;>     return
	jp nz, .done

;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> variant = 1 if wEntityPrivateCounter[slot] & 0x30 else 0
	ld a, [hl]
	ld e, $00
	and $30
	jr z, .set

	inc e

.set
;> Call_3B87(variant)
	ld a, e
	call Call_3B87
	ret

.done
	ret


;@ path: npc/mamu
;@ Sprite variants 0-3 of a backing frog drawn as two 8x16 sprites side by side: per variant the
;@ (tile, attributes) of the left and the right sprite ($20 = mirrored). 0: $58 + $58 mirrored,
;@ 1: $5A + $5A mirrored, 2: $5C, $5E, 3: variant 2 mirrored. Read by DrawMamuFrog.
FrogSpritePairs::
	db $58, $00, $58, $20, $5a, $00, $5a, $20, $5c, $00, $5e, $00, $5e, $20, $5c, $20
;@ path: npc/mamu
;@ Sprite variants 4 and 5 of a backing frog (stretched up, 16 x 32 pixels): 16 bytes each, 4
;@ entries of y offset, x offset, tile, attributes. 4: tiles $50 $52 (16 pixels up) over $54 $56;
;@ 5: the same mirrored. Read by DrawMamuFrog.
FrogSpriteFrames::
	db $f0, $00, $50, $00, $f0, $08, $52, $00, $00, $00, $54, $00, $00, $08, $56, $00
	db $f0, $00, $52, $20, $f0, $08, $50, $20, $00, $00, $56, $20, $00, $08, $54, $20

;@ def DrawMamuFrog()
;@ path: npc/mamu
;@ Draws a backing frog: variants 0-3 as a sprite pair (FrogSpritePairs), variants 4 and 5 as
;@ four sprites (FrogSpriteFrames).
;@ test: skip draws sprites
DrawMamuFrog::
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v < 4:
	cp $04
	jr nc, .tall

;>     return Call_3C3B(FrogSpritePairs)   # draw the pair of variant v
	ld de, FrogSpritePairs
	jp Call_3C3B

.tall
;>@fr frame = FrogSpriteFrames + (v - 4) * 16
	sub $04
	rla
	rla
	rla
	rla
;=@fr
	and $f0
	ld e, a
	ld d, b
	ld hl, FrogSpriteFrames
	add hl, de
;> Call_3D26(frame, 4)
	ld c, $04
	call Call_3D26
	ret


;@ def DrawLightWideLeftHalf()
;@ path: npc/mamu
;@ Queues the left half (columns 0-2) of the big 6 x 6 tile stage light at the background spot
;@ (hBGPosX, hBGPosY), 16 tile rows lower in the map: in the alternate background shown every
;@ other frame. Draw command: address (2 bytes), mode ($80 = going down, $40 = one tile repeated,
;@ low bits = count - 1), tiles. Column 0: $00 $04 $7F $7F $06 $0C, column 1: $01 $7F $7F $7F $7F
;@ $0D, column 2: $7F six times ($7F = no light).
;@ test: skip computes a VRAM address in bank 0
DrawLightWideLeftHalf::
;> GetBGAddress()                    # BG map address of (hBGPosX, hBGPosY) -> hBGAddrHigh/Low
	call GetBGAddress
;> wDrawCommandsSize = 0x1B
	ld a, $1b
	ld [wDrawCommandsSize], a
;> hi = hBGAddrHigh + 2           # 16 rows lower: the alternate background
	ld hl, wDrawCommand
	ldh a, [hBGAddrHigh]
	add $02
	ld e, a
;>@c0 wDrawCommand[0:9] = [hi, hBGAddrLow, 0x85, 0x00, 0x04, 0x7F, 0x7F, 0x06, 0x0C]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $85
	ld [hli], a
;=@c0
	ld a, $00
	ld [hli], a
	ld a, $04
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@c0
	ld a, $7f
	ld [hli], a
	ld a, $06
	ld [hli], a
	ld a, $0c
	ld [hli], a
;>@c1 wDrawCommand[9:18] = [hi, hBGAddrLow + 1, 0x85, 0x01, 0x7F, 0x7F, 0x7F, 0x7F, 0x0D]
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $01
	ld [hli], a
;=@c1
	ld a, $85
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@c1
	ld a, $7f
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@c1
	ld a, $0d
	ld [hli], a
;>@c2 wDrawCommand[18:22] = [hi, hBGAddrLow + 2, 0xC5, 0x7F]   # tile $7F six times down
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $02
	ld [hli], a
;=@c2
	ld a, $c5
	ld [hli], a
	ld a, $7f
	ld [hli], a
;> wDrawCommand[22] = 0           # end of the commands
	ld [hl], $00
	ret

;@ def DrawLightWideRightHalf()
;@ path: npc/mamu
;@ Queues the right half (columns 3-5) of the big stage light, like DrawLightWideLeftHalf.
;@ Column 3: $7F six times, column 4: $02 $7F $7F $7F $7F $0E, column 5: $03 $05 $7F $7F $07 $0F.
;@ test: skip computes a VRAM address in bank 0
DrawLightWideRightHalf::
;> GetBGAddress()                    # BG map address of (hBGPosX, hBGPosY) -> hBGAddrHigh/Low
	call GetBGAddress
;> wDrawCommandsSize = 0x1B
	ld a, $1b
	ld [wDrawCommandsSize], a
;> hi = hBGAddrHigh + 2
	ld hl, wDrawCommand
	ldh a, [hBGAddrHigh]
	add $02
	ld e, a
;>@c3 wDrawCommand[0:4] = [hi, hBGAddrLow + 3, 0xC5, 0x7F]
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $03
	ld [hli], a
;=@c3
	ld a, $c5
	ld [hli], a
	ld a, $7f
	ld [hli], a
;>@c4 wDrawCommand[4:13] = [hi, hBGAddrLow + 4, 0x85, 0x02, 0x7F, 0x7F, 0x7F, 0x7F, 0x0E]
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $04
	ld [hli], a
;=@c4
	ld a, $85
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@c4
	ld a, $7f
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@c4
	ld a, $0e
	ld [hli], a
;>@c5 wDrawCommand[13:22] = [hi, hBGAddrLow + 5, 0x85, 0x03, 0x05, 0x7F, 0x7F, 0x07, 0x0F]
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $05
	ld [hli], a
;=@c5
	ld a, $85
	ld [hli], a
	ld a, $03
	ld [hli], a
	ld a, $05
	ld [hli], a
;=@c5
	ld a, $7f
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $07
	ld [hli], a
;=@c5
	ld a, $0f
	ld [hli], a
;> wDrawCommand[22] = 0
	ld [hl], $00
	ret

;@ def DrawLightSmall()
;@ path: npc/mamu
;@ Queues a small 4 x 4 tile stage light at (hBGPosX, hBGPosY) in the alternate background, one
;@ command per column ($83 = 4 tiles going down): $00 $04 $06 $0C / $01 $7F $7F $0D /
;@ $02 $7F $7F $0E / $03 $05 $07 $0F.
;@ test: skip computes a VRAM address in bank 0
DrawLightSmall::
;> GetBGAddress()                    # BG map address of (hBGPosX, hBGPosY) -> hBGAddrHigh/Low
	call GetBGAddress
;> wDrawCommandsSize = 0x15
	ld a, $15
	ld [wDrawCommandsSize], a
;> hi = hBGAddrHigh + 2
	ld hl, wDrawCommand
	ldh a, [hBGAddrHigh]
	add $02
	ld e, a
;>@s0 wDrawCommand[0:7] = [hi, hBGAddrLow, 0x83, 0x00, 0x04, 0x06, 0x0C]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $83
	ld [hli], a
;=@s0
	ld a, $00
	ld [hli], a
	ld a, $04
	ld [hli], a
	ld a, $06
	ld [hli], a
;=@s0
	ld a, $0c
	ld [hli], a
;>@s1 wDrawCommand[7:14] = [hi, hBGAddrLow + 1, 0x83, 0x01, 0x7F, 0x7F, 0x0D]
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $01
	ld [hli], a
;=@s1
	ld a, $83
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@s1
	ld a, $7f
	ld [hli], a
	ld a, $0d
	ld [hli], a
;>@s2 wDrawCommand[14:21] = [hi, hBGAddrLow + 2, 0x83, 0x02, 0x7F, 0x7F, 0x0E]
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $02
	ld [hli], a
;=@s2
	ld a, $83
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, $7f
	ld [hli], a
;=@s2
	ld a, $7f
	ld [hli], a
	ld a, $0e
	ld [hli], a
;>@s3 wDrawCommand[21:28] = [hi, hBGAddrLow + 3, 0x83, 0x03, 0x05, 0x07, 0x0F]
	ld a, e
	ld [hli], a
	ldh a, [hBGAddrLow]
	add $03
	ld [hli], a
;=@s3
	ld a, $83
	ld [hli], a
	ld a, $03
	ld [hli], a
	ld a, $05
	ld [hli], a
;=@s3
	ld a, $07
	ld [hli], a
	ld a, $0f
	ld [hli], a
;> wDrawCommand[28] = 0
	ld [hl], $00
	ret

;@ def ManboEntityHandler(slot: c)
;@ path: npc/manbo
;@ Entity $C7: Manbo, the fish who dances in his pond, and the fishes of the pond (the same type:
;@ an entity drawn at y $50 or lower is a fish, see ManboFishHandler). Manbo teaches Link's
;@ ocarina Manbo's Mambo for free once Link has an ocarina. Manbo keeps y = $3E and is solid.
;@ test: skip runs a state machine with dialogues and sprite drawing
ManboEntityHandler::
;> if hActiveEntityDrawY >= 0x50:  # a fish in the pond
	ldh a, [hActiveEntityDrawY]
	cp $50
;>     return ManboFishHandler()
	jp nc, ManboFishHandler

;> wEntityY[slot] = 0x3E
	ld hl, wEntityY
	add hl, bc
	ld [hl], $3e
;> if wManboSplashTimer:
	ld a, [wManboSplashTimer]
	and a
	jr z, .splashDone

;>     wManboSplashTimer -= 1
	dec a
	ld [wManboSplashTimer], a

.splashDone
;> if wSongShowCountdown:
	ld a, [wSongShowCountdown]
	and a
	jr z, .countdownDone

;>     wSongShowCountdown -= 1
	dec a
	ld [wSongShowCountdown], a

.countdownDone
;> DrawManbo(slot)
	call DrawManbo
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> return ManboStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/manbo
;@ Manbo's states (wEntityState), 2-byte code addresses: 0 ManboWaitForLink, 1 ManboAskToPlay,
;@ 2 ManboStartSong, 3 ManboPerformSong, 4 ManboEndSong, 5 ManboTeachSong.
ManboStates::
	dw ManboWaitForLink
	dw ManboAskToPlay
	dw ManboStartSong
	dw ManboPerformSong
	dw ManboEndSong
	dw ManboTeachSong

;@ def ManboWaitForLink(slot: c)
;@ path: npc/manbo
;@ State 0. Once Link knows Manbo's Mambo, talking to Manbo gives dialogue $189. Before that,
;@ Link is stopped when he walks up to x = $30 and Manbo greets him (dialogue $185, state 1).
;@ test: skip opens dialogues
ManboWaitForLink::
;> if wOcarinaSongFlags & 0x02:   # Manbo's Mambo already learnt
	ld a, [wOcarinaSongFlags]
	and $02
	jr z, .notLearnt

;>     if not CheckLinkCanTalkTall_18():
	call CheckLinkCanTalkTall_18
;>         return ManboAnimate()
	jr nc, ManboAnimate

;>     OpenDialogTable1(0x89)     # dialogue $189
	ld a, $89
	call OpenDialogTable1
;>     return
	ret

.notLearnt
;> if hLinkX < 0x30:              # Link has not come close yet
	ldh a, [hLinkX]
	cp $30
;>     return ManboAnimate()
	jr c, ManboAnimate

;> hLinkX = 0x2F                  # stop Link in front of the pond
	ld a, $2f
	ldh [hLinkX], a
;> Call_1495()                    # Link's speed to 0
	call Call_1495
;> OpenDialogTable1(0x85)         # Manbo greets Link: dialogue $185
	ld a, $85
	call OpenDialogTable1
;> Call_3B8D()                    # next state: ManboAskToPlay
	call Call_3B8D
;> ManboAnimate()                 # falls through

;@ def ManboAnimate()
;@ path: npc/manbo
;@ Manbo's idle animation: sprite variant 0 and 1, switching every 8 frames.
;@ test: skip sets the sprite variant through bank 0
ManboAnimate::
;> v = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> Call_3B87(v)                   # set the sprite variant
	call Call_3B87
	ret


;@ def ManboAskToPlay(slot: c)
;@ path: npc/manbo
;@ State 1: after the question, "yes" with an ocarina (item 9 on a button or in the inventory)
;@ leads to dialogue $187 and state 2; "no", or no ocarina, to dialogue $18A and state 0.
;@ test: skip opens dialogues
ManboAskToPlay::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .refused

;>@loop     for i in range(12):    # the B and A items and the 10 inventory slots
	ld e, $0b
	ld hl, wItemB

.search
;>         if mem[0xDB00 + i] == 9:   # the ocarina
;>@has             Call_3B8D()            # next state: ManboStartSong
	ld a, [hli]
	cp $09
	jr z, .hasOcarina

;>@has2             return OpenDialogTable1(0x87)
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .search

.refused
;> wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b
;> OpenDialogTable1(0x8A)         # dialogue $18A
	ld a, $8a
	call OpenDialogTable1

.done
;> return
	ret

.hasOcarina
;=@has
	call Call_3B8D
;=@has2
	ld a, $87
	jp OpenDialogTable1


;@ def ManboStartSong(slot: c)
;@ path: npc/manbo
;@ State 2: when the dialogue is closed, Manbo's Mambo starts (music $30) and the dance begins
;@ (state 3) with the performance variables reset (ResetSongShow, also used by Mamu).
;@ test: skip starts music
ManboStartSong::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, ResetSongShow.done

;> wMusicTrackToPlay = 0x30
	ld a, $30
	ld [wMusicTrackToPlay], a
;> Call_3B8D()                    # next state
	call Call_3B8D
;> ResetSongShow()                # falls through

;@ def ResetSongShow()
;@ path: npc/song
;@ Clears the variables of a song performance (Mamu's song, Manbo's dance): the frame and step
;@ counters, the splash timer and the spare bytes.
ResetSongShow::
;> wSongShowTimer = 0             # 16-bit
	xor a
	ld [wSongShowTimer], a
	ld [wSongShowTimer + 1], a
;> wSongShowStepTimer = 0
	ld [wSongShowStepTimer], a
;> wSongShowStep = 0
	ld [wSongShowStep], a
;> wSongShowSpare = 0
	ld [wSongShowSpare], a
;> wManboSplashTimer = 0
	ld [wManboSplashTimer], a
;> wSongShowCountdown = 0
	ld [wSongShowCountdown], a

.done
	ret


;@ path: npc/manbo
;@ Variant of the splash sprite pair below Manbo (0 none, 1-4: ManboSplashPairs) for each of the
;@ 78 steps of the dance (index wSongShowStep, a step lasts $14 frames). One byte per step;
;@ ManboPerformSong copies it to wEntityPrivate1, which DrawManbo uses.
ManboSplashFrames::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00, $00, $00

;@ path: npc/manbo
;@ Manbo's sprite variant (0-2, ManboSpriteFrames) for each of the 78 dance steps. One byte
;@ per step, read by ManboPerformSong.
ManboDanceFrames::
	db $02, $01
	db $02, $01, $02, $01, $02, $01, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01
	db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $02, $02, $02, $02, $02, $02, $02

;@ path: npc/manbo
;@ Sprite variant of the pond fishes (1-6, see DrawManboFish; 0 = they use their own idle
;@ animation) for each of the 78 dance steps. One byte per step; ManboPerformSong puts it in
;@ wSongShowPlaying, which ManboFishHandler reads.
ManboFishDanceFrames::
	db $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $02, $03, $02, $03, $02, $03, $02, $03
	db $02, $03, $02, $02, $03, $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06
	db $05, $06, $05, $06, $05, $06, $04, $02, $03, $02, $03, $02, $03, $02, $03, $02
	db $03, $02, $03, $02, $04, $05, $04, $05, $03, $02, $03, $02, $03, $02, $03, $02
	db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

;@ def ManboPerformSong(slot: c)
;@ path: npc/manbo
;@ State 3: the dance. Link is frozen; every $14 frames the dance goes one step on, setting
;@ Manbo's frame, the splash below him and the fishes' frame from the three dance tables. At
;@ frame $00CC and at frame $05BE Manbo sprays water for $28 frames (wEntityTimer1; the second
;@ time the fishes join in with wManboSplashTimer). At frame $05F0 the dance ends (state 4,
;@ after $20 frames).
;@ test: skip runs the entity timers
ManboPerformSong::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;>@inc wSongShowTimer += 1        # 16-bit
	ld a, [wSongShowTimer]
	add $01
	ld [wSongShowTimer], a
	ld a, [wSongShowTimer + 1]
	adc $00
;=@inc
	ld [wSongShowTimer + 1], a
;> if wSongShowTimer == 0x05F0:   # the dance is over
	ld a, [wSongShowTimer + 1]
	cp $05
	jr nz, .dance

	ld a, [wSongShowTimer]
	cp $f0
	jr nz, .dance

;>     Call_3B8D()                # next state
	call Call_3B8D
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     return
	ret

.dance
;> t = wSongShowStepTimer + 1
	ld a, [wSongShowStepTimer]
	inc a
;> if t == 0x14:
	cp $14
	jr nz, .setStepTimer

;>     wSongShowStep += 1
	ld a, [wSongShowStep]
	inc a
	ld [wSongShowStep], a
;>     t = 0
	xor a

.setStepTimer
;> wSongShowStepTimer = t
	ld [wSongShowStepTimer], a
;> step = wSongShowStep
	ld a, [wSongShowStep]
	ld e, a
	ld d, b
;> Call_3B87(ManboDanceFrames[step])   # Manbo's sprite variant
	ld hl, ManboDanceFrames
	add hl, de
	ld a, [hl]
	call Call_3B87
;> wEntityPrivate1[slot] = ManboSplashFrames[step]
	ld hl, ManboSplashFrames
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wSongShowPlaying = ManboFishDanceFrames[step]   # the fishes' frame
	ld hl, ManboFishDanceFrames
	add hl, de
	ld a, [hl]
	ld [wSongShowPlaying], a
;> frame = wSongShowTimer
	ld a, [wSongShowTimer + 1]
	ld d, a
	ld a, [wSongShowTimer]
	ld e, a
;>@sp if frame in (0x00CC, 0x05BE):
	cp $cc
	jr nz, .notFirstSpray

	ld a, d
	cp $00
	jr z, .spray

.notFirstSpray
;=@sp
	ld a, e
	cp $be
	jr nz, .done

	ld a, d
	cp $05
;>@bs     if frame == 0x05BE:
;=@bs
	jr z, .bigSpray
;>@bs2         wManboSplashTimer = 0x28   # the fishes splash too
;>@t     wEntityTimer1[slot] = 0x28       # Manbo sprays water

.done
;=@sp
	ret

.bigSpray
;=@bs2
	ld a, $28
	ld [wManboSplashTimer], a
.spray
;=@t
	call GetEntityTimer1
	ld [hl], $28
	ret


;@ path: npc/manbo
;@ The water spray Manbo blows (and the fishes' splash): 3 entries of y offset, x offset, tile,
;@ attributes - tiles $40 $42 $44 in a row (24 x 16 pixels). Drawn by DrawManbo and
;@ DrawManboFish $18 pixels left of and $10 above the entity.
ManboWaterSpray::
	db $00, $00, $40, $00, $00, $08, $42, $00, $00, $10, $44, $00

;@ def ManboEndSong(slot: c)
;@ path: npc/manbo
;@ State 4: after the timer, the teaching jingle (music $10) plays and state 5 runs for $70
;@ frames. Link stays frozen.
;@ test: skip runs the entity timer
ManboEndSong::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .wait

;>     wEntityTimer[slot] = 0x70
	ld [hl], $70
;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>     Call_3B8D()                # next state
	call Call_3B8D

.wait
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ManboAnimate()
	call ManboAnimate
	ret


;@ path: npc/song
;@ The sprite above Link's head while he holds up a song he has just learnt (Mamu, Manbo): one
;@ (tile, attributes) pair - tile $90, attributes $10 (sprite palette 1). Drawn with Call_3CD0.
SongLearntSprite::
	db $90, $10

;@ def ManboTeachSong(slot: c)
;@ path: npc/manbo
;@ State 5: Link holds up what he learnt (pose $6C, SongLearntSprite above his head); with 8
;@ frames left, dialogue $188 says he learnt it; at the end Manbo's Mambo (song 1) is learnt and
;@ selected and Manbo goes back to state 0.
;@ test: skip runs the entity timer and draws sprites
ManboTeachSong::
;> ManboAnimate()
	call ManboAnimate
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .counting

;>     wSelectedSong = 1
	ld a, $01
	ld [wSelectedSong], a
;>     wOcarinaSongFlags |= 0x02  # Manbo's Mambo
	ld hl, wOcarinaSongFlags
	set 1, [hl]
;>     wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b
;>     return
	ret

.counting
;> if t == 8:
	cp $08
	jr nz, .holdUp

;>     wEntityTimer[slot] -= 1    # only once
	dec [hl]
;>     OpenDialogTable1(0x88)     # dialogue $188
	ld a, $88
	call OpenDialogTable1

.holdUp
;> hLinkAnimationState = 0x6C     # Link holds something up
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hActiveEntityX = hLinkX
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = hLinkY - 12
	ldh a, [hLinkY]
	sub $0c
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	ld de, SongLearntSprite
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> Call_3CD0(SongLearntSprite)    # one sprite above Link's head
	call Call_3CD0
	ret


;@ path: npc/manbo
;@ Manbo's 4 sprite frames (variant 0-3), 36 bytes each: 9 entries of y offset, x offset, tile,
;@ attributes ($40 = upside down) for 8x16 sprites, 32 x 40 pixels. Frame 0: head $50 $52 over
;@ $54 $56, fins $58 $5A $5C, tail $5E and $5E flipped; frame 1: lower body $4A $4C, fin $4E;
;@ frame 2: fins $60 $62; frame 3: top $46 $48 with $4A $4C, $60 $4E $62 (used while he sprays
;@ water). Drawn by DrawManbo.
ManboSpriteFrames::
	db $00, $00, $50, $00, $00, $08, $52, $00, $10, $00, $54, $00, $10, $08, $56, $00
	db $f8, $10, $58, $00, $08, $10, $5a, $00, $18, $10, $5c, $00, $00, $18, $5e, $00
	db $10, $18, $5e, $40, $00, $00, $50, $00, $00, $08, $52, $00, $10, $00, $4a, $00
	db $10, $08, $4c, $00, $f8, $10, $58, $00, $08, $10, $4e, $00, $18, $10, $5c, $00
	db $00, $18, $5e, $00, $10, $18, $5e, $40, $00, $00, $50, $00, $00, $08, $52, $00
	db $10, $00, $54, $00, $10, $08, $56, $00, $f8, $10, $60, $00, $08, $10, $5a, $00
	db $18, $10, $62, $00, $00, $18, $5e, $00, $10, $18, $5e, $40, $00, $00, $46, $00
	db $00, $08, $48, $00, $10, $00, $4a, $00, $10, $08, $4c, $00, $f8, $10, $60, $00
	db $08, $10, $4e, $00, $18, $10, $62, $00, $00, $18, $5e, $00, $10, $18, $5e, $40
;@ path: npc/manbo
;@ The splash pair drawn 3 pixels below Manbo's position, by variant (wEntityPrivate1): 2 x
;@ (tile, attributes). 0: tile $FF twice (nothing visible), 1: $64 $66, 2: upside down ($40),
;@ 3: turned round ($60), 4: mirrored ($20) - a four-frame swirl. Drawn by DrawManbo.
ManboSplashPairs::
	db $ff, $ff, $ff, $ff, $64, $00, $66, $00, $64, $40, $66, $40, $66, $60, $64, $60
	db $66, $20, $64, $20

;@ def DrawManbo(slot: c)
;@ path: npc/manbo
;@ Draws the splash pair below Manbo, Manbo himself (frame 3 while he sprays water, else his
;@ sprite variant; 9 sprites) and, while wEntityTimer1 runs, the water spray up and to his left.
;@ test: skip draws sprites
DrawManbo::
;> hActiveEntitySpriteVariant = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityDrawY += 3
	ldh a, [hActiveEntityDrawY]
	add $03
	ldh [hActiveEntityDrawY], a
;> Call_3C3B(ManboSplashPairs)    # draw the splash pair
	ld de, ManboSplashPairs
	call Call_3C3B
;> Call_3DD0(2)                   # claim 2 more OAM entries
	ld a, $02
	call Call_3DD0
;> Call_3DBA()                    # reload the position from the entity arrays
	call Call_3DBA
;> if wEntityTimer1[slot]:
	call GetEntityTimer1
	jr z, .ownFrame

;>     frame = 3                  # spraying water
	ld a, $03
	jr .draw

;> else:
;>     frame = wEntitySpriteVariant[slot]
.ownFrame
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]

.draw
;>@fr sprites = ManboSpriteFrames + frame * 36
	rla
	rla
	and $fc
	ld e, a
;=@fr
	rla
	rla
	rla
	and $e0
	add e
	ld e, a
;=@fr
	ld d, b
	ld hl, ManboSpriteFrames
	add hl, de
;> Call_3D26(sprites, 9)
	ld c, $09
	call Call_3D26
;> Call_3DD0(9)
	ld a, $09
	call Call_3DD0
;> if not wEntityTimer1[slot]:
	call GetEntityTimer1
;>     return
	ret z

;> hActiveEntityX -= 0x18
	ldh a, [hActiveEntityX]
	sub $18
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY -= 0x10
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;> Call_3D26(ManboWaterSpray, 3)
	ld hl, ManboWaterSpray
	ld c, $03
	call Call_3D26
;> Call_3DD0(3)
	ld a, $03
	call Call_3DD0
	ret


;@ path: npc/manbo
;@ Pond fish variant 0: 3 entries of y offset, x offset, tile, attributes - tiles $76 $78 $7A in
;@ a row (24 x 16 pixels, from x - 4). Drawn by DrawManboFish.
ManboFishFrame0::
	db $00, $fc, $76, $00, $00, $04, $78, $00, $00, $0c, $7a, $00

;@ path: npc/manbo
;@ Pond fish variant 1: tiles $7C $78 $7E in a row (as ManboFishFrame0, other fins).
ManboFishFrame1::
	db $00, $fc, $7c, $00
	db $00, $04, $78, $00, $00, $0c, $7e, $00

;@ path: npc/manbo
;@ Pond fish variants 2-8 as sprite pairs: 2 x (tile, attributes) per variant ($20 = mirrored).
;@ 2: $68 $6A, 3: $6C $6E, 4: $70 + $70 mirrored, 5: variant 2 mirrored, 6: variant 3 mirrored,
;@ 7: $72 $74 (jumping, while the fishes splash), 8: variant 7 mirrored. DrawManboFish indexes it
;@ from ManboFishPairs - 8, so variant 2 is the first entry.
ManboFishPairs::
	db $68, $00, $6a, $00, $6c, $00, $6e, $00
	db $70, $00, $70, $20, $6a, $20, $68, $20, $6e, $20, $6c, $20, $72, $00, $74, $00
	db $74, $20, $72, $20

;@ def ManboFishHandler()
;@ path: npc/manbo
;@ A fish of Manbo's pond (entity $C7 drawn at y $50 or lower): it wiggles (variant 0/1 every
;@ 16 frames) and during the dance takes its frame from wSongShowPlaying.
;@ test: skip draws sprites
ManboFishHandler::
;> DrawManboFish()
	call DrawManboFish
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> Call_3B87(v)                   # set the sprite variant
	call Call_3B87
;> if wSongShowPlaying:
	ld a, [wSongShowPlaying]
	and a
	jr z, .done

;>     Call_3B87(wSongShowPlaying)   # the dance frame
	call Call_3B87

.done
	ret


;@ def DrawManboFish()
;@ path: npc/manbo
;@ Draws a pond fish: during the big splash (wManboSplashTimer) first the water spray and then
;@ the fish as variant 7 (jumping); variants 0 and 1 are 3-sprite frames (ManboFishFrame0/1),
;@ 2 and more sprite pairs (ManboFishPairs).
;@ test: skip draws sprites
DrawManboFish::
;> if wManboSplashTimer:
	ld a, [wManboSplashTimer]
	and a
	jr z, .fish

;>     hActiveEntityX -= 0x18
	ldh a, [hActiveEntityX]
	sub $18
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY -= 0x10
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;>     Call_3D26(ManboWaterSpray, 3)
	ld hl, ManboWaterSpray
	ld c, $03
	call Call_3D26
;>     Call_3DD0(3)               # claim 3 more OAM entries
	ld a, $03
	call Call_3DD0
;>     Call_3DBA()                # reload the position
	call Call_3DBA
;>     hActiveEntitySpriteVariant = 7
	ld a, $07
	ldh [hActiveEntitySpriteVariant], a

.fish
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v < 2:
	cp $02
	jr nc, .pair

;>     frame = ManboFishFrame1 if v == 1 else ManboFishFrame0
	ld hl, ManboFishFrame0
	dec a
	jr nz, .draw3

	ld hl, ManboFishFrame1

.draw3
;>     Call_3D26(frame, 3)
	ld c, $03
	call Call_3D26
;>     return Call_3DD0(3)
	ld a, $03
	jp Call_3DD0

.pair
;> Call_3C3B(ManboFishPairs - 8)  # the pair of variant v
	ld de, ManboFishPairs - 8
	call Call_3C3B
;> return Call_3DD0(2)
	ld a, $02
	jp Call_3DD0

;@ path: object/mermaid_statue
;@ The mermaid statue: 4 entries of y offset, x offset, tile, attributes - tiles $70 $72 (16
;@ pixels up) over $74 $76, 16 x 32 pixels. Drawn by MermaidStatueEntityHandler.
MermaidStatueSprites::
	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00

;@ def MermaidStatueEntityHandler(slot: c)
;@ path: object/mermaid_statue
;@ Entity $CE: the mermaid statue in Martha's Bay. Link puts the mermaid's scale (trading item
;@ $0D) into it; it slides 16 pixels to the left, uncovering the way to the magnifying lens
;@ (the trading item becomes $0E), and stays moved (room event flag).
;@ test: skip runs a state machine with dialogues and sprite drawing
MermaidStatueEntityHandler::
;> Call_3D26(MermaidStatueSprites, 4)   # draw the 4 sprites
	ld hl, MermaidStatueSprites
	ld c, $04
	call Call_3D26
;> return MermaidStatueStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/mermaid_statue
;@ States of the mermaid statue (wEntityState): 0 MermaidStatueInit, 1 MermaidStatueWaitForScale,
;@ 2 MermaidStatueSlide.
MermaidStatueStates::
	dw MermaidStatueInit
	dw MermaidStatueWaitForScale
	dw MermaidStatueSlide

;@ def MermaidStatueInit(slot: c)
;@ path: object/mermaid_statue
;@ State 0: if the statue was already moved (room event done), it starts 16 pixels to the left.
;@ test: c = rand(0, 15)
MermaidStatueInit::
;> if hRoomStatus & 0x20:
	ldh a, [hRoomStatus]
	and $20
	jr z, .next

;>     wEntityX[slot] -= 0x10
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a

.next
;> Call_3B8D()                    # next state
	call Call_3B8D
	ret


;@ def MermaidStatueWaitForScale(slot: c)
;@ path: object/mermaid_statue
;@ State 1: the statue is solid. When Link talks to it (examines it) holding the mermaid's scale,
;@ the scale is put in: trading item $0E, a trade scene runs (wTradeSceneState), noise effect 4,
;@ the room event is marked done, dialogue $116 and the slide starts after $60 frames. Without
;@ the scale: dialogue $19C.
;@ test: skip opens dialogues
MermaidStatueWaitForScale::
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> if wTradeSceneState:
	ld a, [wTradeSceneState]
	and a
;>     return
	ret nz

;> if not CheckLinkCanTalk_18():
	call CheckLinkCanTalk_18
;>     return
	jr nc, .done

;> if wTradeSequenceItem == 0x0D: # the mermaid's scale
	ld a, [wTradeSequenceItem]
	cp $0d
	jr nz, .noScale

;>     wTradeSequenceItem = 0x0E  # the magnifying lens
	ld a, $0e
	ld [wTradeSequenceItem], a
;>     wTradeSceneState = 1
	ld a, $01
	ld [wTradeSceneState], a
;>     hNoiseSfx = 4
	ld a, $04
	ldh [hNoiseSfx], a
;>     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;>     MarkRoomEventDone_18()
	call MarkRoomEventDone_18
;>     OpenDialogTable1(0x16)     # dialogue $116
	ld a, $16
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

;> OpenDialogTable1(0x9C)         # dialogue $19C
.noScale
	ld a, $9c
	call OpenDialogTable1

.done
	ret


;@ def MermaidStatueSlide(slot: c)
;@ path: object/mermaid_statue
;@ State 2: Link is frozen while the timer runs; for its last $40 frames the statue slides left
;@ (speed -4, a quarter pixel per frame; noise effect $11 at the start). Then a jingle plays,
;@ Link is free and the statue goes back to state 1.
;@ test: skip runs the entity timer
MermaidStatueSlide::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .sliding

;>     wEntityState[slot] = 1
	call Call_3B8D
	ld [hl], $01
;>     hJingle = 2
	ld a, $02
	ldh [hJingle], a
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     return
	ret

.sliding
;> if t == 0x40:
	cp $40
	jr nz, .move

;>     hNoiseSfx = 0x11
	ld hl, hNoiseSfx
	ld [hl], $11

.move
;> if t < 0x40:
	jr nc, .done

;>     wEntitySpeedX[slot] = 0xFC # -4
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fc
;>     UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18

.done
	ret


;@ path: enemy/zora
;@ The Zora's sprite pairs by variant: 2 x (tile, attributes) ($20 mirrored, $40 upside down,
;@ $60 both). 0: tile $FF twice (nothing visible, under water), 1 and 2: ripples ($54 in
;@ different flips), 3: head out of the water ($56 + mirrored), 4: spitting ($52 + mirrored).
ZoraSpritePairs::
	db $ff, $ff, $ff, $ff, $54, $00, $54, $60, $54, $40, $54, $20, $56, $00, $56, $20
	db $52, $00, $52, $20

;@ def ZoraEntityHandler(slot: c)
;@ path: enemy/zora
;@ Entity $CB: the Zora, who surfaces at random spots of deep water, spits a fireball at Link
;@ and dives again.
;@ test: skip runs a state machine with sprite drawing
ZoraEntityHandler::
;> Call_3C3B(ZoraSpritePairs)     # draw the pair of the sprite variant
	ld de, ZoraSpritePairs
	call Call_3C3B
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> return ZoraStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/zora
;@ The Zora's states (wEntityState): 0 ZoraPickSpot, 1 ZoraWaitUnderwater, 2 ZoraRipple,
;@ 3 ZoraSurface.
ZoraStates::
	dw ZoraPickSpot
	dw ZoraWaitUnderwater
	dw ZoraRipple
	dw ZoraSurface

;@ def ZoraPickSpot(slot: c)
;@ path: enemy/zora
;@ State 0: under water (physics flag bit 6: not touchable), moves to one of 8 spots picked at
;@ random from the spot tables at $6352 (y) and $635A (x); when the room object there is deep
;@ water (type 7) it waits $40-$BF frames (state 1), otherwise it tries again next frame.
;@ test: skip reads the room objects through bank 0
ZoraPickSpot::
;> wEntityPhysicsFlags[slot] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
;> i = GetRandomByte() & 7           # random spot
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntityX[slot] = mem[0x635A + i]
	ld hl, $635a
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = mem[0x6352 + i]
	ld hl, $6352
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> Call_18_646E(slot)             # type of the room object under the entity -> hMultiPurpose3
	call Call_18_646E
;> if hMultiPurpose3 != 7:        # not deep water
	ldh a, [hMultiPurpose3]
	cp $07
	jr z, .water

;>     return
	ret

.water
;> wEntityTimer[slot] = (GetRandomByte() & 0x7F) | 0x40
	call GetEntityTimer
	call GetRandomByte
	and $7f
	or $40
	ld [hl], a
;> return Call_3B8D()             # next state
	jp Call_3B8D


;@ def ZoraWaitUnderwater(slot: c)
;@ path: enemy/zora
;@ State 1: waits under water, then shows ripples for $60 frames (state 2).
;@ test: c = rand(0, 15)
ZoraWaitUnderwater::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x60
	ld [hl], $60
;>     Call_3B8D()                # next state
	call Call_3B8D

.done
	ret


;@ def ZoraRipple(slot: c)
;@ path: enemy/zora
;@ State 2: ripples on the water (variants 1 and 2, switching every 4 frames); then the Zora
;@ comes up and can be hit (state 3, $60 frames).
;@ test: c = rand(0, 15)
ZoraRipple::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .ripple

;>     wEntityTimer[slot] = 0x60
	ld [hl], $60
;>     wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
;>     wEntityPhysicsFlags[slot] &= ~0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 6, [hl]
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.ripple
;> return Call_3B87(2 if t & 4 else 1)   # set the sprite variant
	and $04
	ld a, $01
	jr z, .set

	inc a

.set
	jp Call_3B87


;@ path: enemy/zora
;@ Height of the surfaced Zora (bobbing): 8 values in pixels, one per 8 frames of its counter
;@ (0 0 1 2 2 2 1 0). Read by ZoraSurface.
ZoraBobHeights::
	db $00, $00, $01, $02, $02, $02, $01, $00

;@ def ZoraSurface(slot: c)
;@ path: enemy/zora
;@ State 3: the Zora is out of the water, bobbing, and hurts Link on contact. With $30 frames
;@ left it spits a fireball (entity $7D) aimed at Link at speed $18; it shows its spitting frame
;@ (variant 4) from $50 down to $20 frames left. At the end it dives with a splash (transient
;@ effect 1, jingle $0E) and picks a new spot (state 0).
;@ test: skip spawns entities through bank 3
ZoraSurface::
;> i = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> wEntityPrivateCounter[slot] += 1
	inc [hl]
;>@z wEntityZ[slot] = ZoraBobHeights[(i >> 3) & 7]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;=@z
	ld hl, ZoraBobHeights
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> Call_3BB4()                    # collision with Link: hurts him
	call Call_3BB4
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .up

;>     wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b
;>     Call_3B87(0)               # sprite variant 0: nothing
	xor a
	call Call_3B87
;>     hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	add $00
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(1)         # splash
	ld a, $01
	call AddTransientVfx
;>     return
	ret

.up
;> if t == 0x30:
	cp $30
	jr nz, .pose

;>     ok, ball = Call_3C01(0x7D)  # spawn the fireball; position of the spawner in hMultiPurpose0/1
	ld a, $7d
	call Call_3C01
;>     if ok:
	jr c, .pose

;>         wEntityX[ball] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[ball] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityPrivate1[ball] += 1
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>         Call_3C25(ball, 0x18)  # aim it at Link with speed $18
	push bc
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

.pose
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> v = 4 if 0x20 <= t < 0x50 else 3
	ld e, $03
	cp $50
	jr nc, .set

	cp $20
	jr c, .set

	inc e

.set
;> return Call_3B87(v)
	ld a, e
	jp Call_3B87


;@ path: npc/christine
;@ Christine's 4 sprite frames (variant 0-3), 16 bytes each: 4 entries of y offset, x offset,
;@ tile, attributes ($20 mirrored) for 8x16 sprites, 16 x 32 pixels; the bottom row is always $74
;@ and $74 mirrored. 0: top $70 $72, 1: top mirrored, 2: top $78 $76 mirrored, 3: $76 $78 (2 and 3
;@ look at Link). Drawn by ChristineEntityHandler.
ChristineSpriteFrames::
	db $00, $00, $70, $00, $00, $08, $72, $00, $10, $00, $74, $00, $10, $08, $74, $20
	db $00, $00, $72, $20, $00, $08, $70, $20, $10, $00, $74, $00, $10, $08, $74, $20
	db $00, $00, $78, $20, $00, $08, $76, $20, $10, $00, $74, $00, $10, $08, $74, $20
	db $00, $00, $76, $00, $00, $08, $78, $00, $10, $00, $74, $00, $10, $08, $74, $20
;@ path: npc/christine
;@ The pair drawn on Christine's table once she has the hibiscus (trading item 9 or later):
;@ 2 x (tile, attributes) - $7A, $7C.
ChristineTableHibiscus::
	db $7a, $00, $7c, $00

;@ path: npc/christine
;@ The pair drawn on Christine's table before that: tile $7E and $7E mirrored.
ChristineTableEmpty::
	db $7e, $00, $7e, $20

;@ def ChristineEntityHandler(slot: c)
;@ path: npc/christine
;@ Entity $76: Christine the goat in Animal Village, who trades the hibiscus (trading item 8)
;@ for her letter (9). In room $A8 the same entity type is Mr. Write (MrWriteHandler). She is
;@ drawn 16 x 32 (4 sprites), looks at Link when he stands next to her, is solid, and a pair
;@ beside her shows what is on her table.
;@ test: skip runs a state machine with dialogues and sprite drawing
ChristineEntityHandler::
;>@draw Call_3D26(ChristineSpriteFrames + hActiveEntitySpriteVariant * 16, 4)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;=@draw
	ld e, a
	ld d, b
	ld hl, ChristineSpriteFrames
	add hl, de
	ld c, $04
	call Call_3D26
;> Call_3DD0(4)                   # claim 4 more OAM entries
	ld a, $04
	call Call_3DD0
;> v = hFrameCounter >> 5
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;> Call_3B87(v & 1)               # set the sprite variant
	and $01
	call Call_3B87
;> ey, dy = GetEntityYDistanceToLink_18(slot)
	call GetEntityYDistanceToLink_18
;> if (dy + 0x0C) & 0xFF < 0x18:  # Link at about her height
	add $0c
	cp $18
	jr nc, .solid

;>     ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;>     if (dx + 0x10) & 0xFF < 0x20:   # and next to her
	add $10
	cp $20
	jr nc, .solid

;>         Call_3B87(ex + 2)      # look to Link's side
	ld a, e
	add $02
	call Call_3B87

.solid
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> if hMapRoom == 0xA8:
	ldh a, [hMapRoom]
	cp $a8
;>     return MrWriteHandler(slot)
	jp z, MrWriteHandler

;> pair = ChristineTableHibiscus if wTradeSequenceItem >= 9 else ChristineTableEmpty
	ld de, ChristineTableHibiscus
	ld a, [wTradeSequenceItem]
	cp $09
	jr nc, .drawTable

	ld de, ChristineTableEmpty

.drawTable
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityX += 0x18
	ldh a, [hActiveEntityX]
	add $18
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY += 8
	ldh a, [hActiveEntityDrawY]
	add $08
	ldh [hActiveEntityDrawY], a
;> Call_3C3B(pair)
	call Call_3C3B
;> Call_3DBA()                    # reload the position
	call Call_3DBA
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> return ChristineStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/christine
;@ Christine's states (wEntityState): 0 ChristineWaitForTalk, 1 ChristineAnswer,
;@ 2 ChristineGiveLetter.
ChristineStates::
	dw ChristineWaitForTalk
	dw ChristineAnswer
	dw ChristineGiveLetter

;@ def ChristineWaitForTalk(slot: c)
;@ path: npc/christine
;@ State 0: talking to Christine gives dialogue $166 before Link has the hibiscus, $16B after the
;@ trade; with the hibiscus she asks for it (dialogue $167, state 1).
;@ test: skip opens dialogues
ChristineWaitForTalk::
;> if not CheckLinkCanTalkLow_18():
	call CheckLinkCanTalkLow_18
;>     return
	jr nc, .done

;> if wTradeSequenceItem == 8:    # the hibiscus
	ld a, [wTradeSequenceItem]
	cp $08
	jr nz, .other

;>     OpenDialogTable1(0x67)     # dialogue $167
	ld a, $67
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

;> OpenDialogTable1(0x66 if wTradeSequenceItem < 8 else 0x6B)
.other
	ld a, $66
	jr c, .open

	ld a, $6b

.open
	call OpenDialogTable1

.done
	ret


;@ def ChristineAnswer(slot: c)
;@ path: npc/christine
;@ State 1: "yes": dialogue $168 and state 2; "no": dialogue $169 and state 0.
;@ test: skip opens dialogues
ChristineAnswer::
;> if not wDialogState:           # (always: no state runs while a dialogue is open)
	ld a, [wDialogState]
	and a
	jr nz, .no

;>     Call_3B8D()                # next state
	call Call_3B8D
;>     if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>         return OpenDialogTable1(0x68)
	ld a, $68
	jp OpenDialogTable1

.no
;> wEntityState[slot] = 0
	ld [hl], b
;> return OpenDialogTable1(0x69)
	ld a, $69
	jp OpenDialogTable1


;@ def ChristineGiveLetter(slot: c)
;@ path: npc/christine
;@ State 2: after the dialogue Link gets the letter: it is shown over his head
;@ (SpawnHeldItemEntity), the trading item becomes 9 and the inventory icon is redrawn.
;@ test: skip spawns an entity
ChristineGiveLetter::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b
;> SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;> wTradeSequenceItem = 9         # the letter
	ld a, $09
	ld [wTradeSequenceItem], a
;> hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a

.done
	ret


;@ def MrWriteHandler(slot: c)
;@ path: npc/mr_write
;@ Entity $76 in room $A8: Mr. Write, who trades the letter (trading item 9) for the broom ($0A)
;@ after showing the picture of the letter's sender (game mode 8).
;@ test: skip runs a state machine with dialogues
MrWriteHandler::
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> return MrWriteStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mr_write
;@ Mr. Write's states (wEntityState): 0 MrWriteWaitForTalk, 1 MrWriteWaitDialog,
;@ 2 MrWriteShowPicture, 3 MrWriteAfterPicture, 4 MrWriteAnswer, 5 MrWriteDone.
MrWriteStates::
	dw MrWriteWaitForTalk
	dw MrWriteWaitDialog
	dw MrWriteShowPicture
	dw MrWriteAfterPicture
	dw MrWriteAnswer
	dw MrWriteDone

;@ def MrWriteWaitForTalk(slot: c)
;@ path: npc/mr_write
;@ State 0: with the letter, dialogue $134 and state 1; before it dialogue $133, after the trade
;@ $139.
;@ test: skip opens dialogues
MrWriteWaitForTalk::
;> if not CheckLinkCanTalkLow_18():
	call CheckLinkCanTalkLow_18
;>     return
	jr nc, .done

;> if wTradeSequenceItem == 9:    # the letter
	ld a, [wTradeSequenceItem]
	cp $09
	jr nz, .other

;>     OpenDialogTable1(0x34)     # dialogue $134
	ld a, $34
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

;> OpenDialogTable1(0x33 if wTradeSequenceItem < 9 else 0x39)
.other
	ld a, $33
	jr c, .open

	ld a, $39

.open
	call OpenDialogTable1

.done
	ret


;@ def MrWriteWaitDialog(slot: c)
;@ path: npc/mr_write
;@ State 1: goes on once the dialogue is closed.
;@ test: c = rand(0, 15)
MrWriteWaitDialog::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     Call_3B8D()                # next state
	call Call_3B8D
	ret

.done
	ret


;@ def MrWriteShowPicture(slot: c)
;@ path: npc/mr_write
;@ State 2: switches to game mode 8, the picture of the letter's sender.
;@ test: c = rand(0, 15)
MrWriteShowPicture::
;> Call_3B8D()                    # next state
	call Call_3B8D
;> StartGameplayType_18(8)        # falls through
	ld a, $08

;@ def StartGameplayType_18(mode: a)
;@ path: system/gamemode
;@ Switches to game mode `mode` at its first step, with the screen fade counters reset.
;@ test: a = rand(0, 15)
StartGameplayType_18::
;> wGameplayType = mode
	ld [wGameplayType], a
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> wGameplaySubtype = 0
	ld [wGameplaySubtype], a
	ret


;@ def MrWriteAfterPicture(slot: c)
;@ path: npc/mr_write
;@ State 3: back from the picture (fade finished, step 4) he asks for the letter (dialogue $135).
;@ test: c = rand(0, 15)
MrWriteAfterPicture::
;> if wTransitionSequenceCounter == 4 and not wDialogState:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done

	ld a, [wDialogState]
	and a
	jr nz, .done

;>     Call_3B8D()                # next state
	call Call_3B8D
;>     OpenDialogTable1(0x35)     # dialogue $135
	ld a, $35
	call OpenDialogTable1

.done
	ret


;@ def MrWriteAnswer(slot: c)
;@ path: npc/mr_write
;@ State 4: "yes": Link gets the broom (trading item $0A, shown over his head) and Mr. Write goes
;@ to state 5; "no": dialogue $137 and the question again.
;@ test: skip spawns an entity
MrWriteAnswer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> Call_3B8D()                    # next state
	call Call_3B8D
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>     wTradeSequenceItem = 0x0A  # the broom
	ld a, $0a
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     return
	ret

.no
;> wEntityState[slot] -= 1        # ask again
	dec [hl]
;> OpenDialogTable1(0x37)         # dialogue $137
	ld a, $37
	call OpenDialogTable1

.done
	ret


;@ def MrWriteDone(slot: c)
;@ path: npc/mr_write
;@ State 5: after the trade, talking to him gives dialogue $138.
;@ test: skip opens dialogues
MrWriteDone::
;> if CheckLinkCanTalkLow_18():
	call CheckLinkCanTalkLow_18
	jr nc, .done

;>     OpenDialogTable1(0x38)     # dialogue $138
	ld a, $38
	call OpenDialogTable1

.done
	ret


;@ path: npc/grandma_ulrira
;@ Grandma Ulrira's sprite pairs, first set (by variant): 2 x (tile, attributes) ($20 mirrored).
;@ 0: $62 $60 mirrored, 1: $66 $64 mirrored, 2: $6C $6E (shared with the second set). Drawn by
;@ GrandmaUlriraEntityHandler.
UlriraPairsA::
	db $62, $20, $60, $20, $66, $20, $64, $20, $6c, $00, $6e, $00

;@ path: npc/grandma_ulrira
;@ Grandma Ulrira's second set of pairs, used while she waits for a broom: 0: $68 $6A, 1: the
;@ same mirrored, 2: $6C $6E.
UlriraPairsB::
	db $68, $00, $6a, $00
	db $6a, $20, $68, $20, $6c, $00, $6e, $00

;@ path: npc/grandma_ulrira
;@ The broom she holds up after the trade: one pair (tile, attributes) - $9A, $9C in sprite
;@ palette 1. Drawn by UlriraSweep.
UlriraBroomSprite::
	db $9a, $10, $9c, $10

;@ def GrandmaUlriraEntityHandler(slot: c)
;@ path: npc/grandma_ulrira
;@ Entity $75: Grandma Ulrira, who trades the broom (trading item $0A) for the fishing hook
;@ ($0B). She only appears in room $B1, or in room $CD when bit 1 of $DB69 is set. Her pairs
;@ come from UlriraPairsB while she wants the broom (trading item $0A, or the $DB69 flag, before
;@ the trade) - then hBGTilesRequestCopy, borrowed as a scratch flag, is 1.
;@ test: skip runs a state machine with dialogues and sprite drawing
GrandmaUlriraEntityHandler::
;> if wEntityPrivate4[slot] == 0:  # first frame
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .placed

;>     wEntityPrivate4[slot] = 1
	inc [hl]
;>     room = 0xCD if mem[0xDB69] & 0x02 else 0xB1
	ld a, [$db69]
	ld d, $b1
	and $02
	jr z, .checkRoom

	ld d, $cd

.checkRoom
;>     if hMapRoom != room:
	ldh a, [hMapRoom]
	cp d
;>         return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

.placed
;> pairs = UlriraPairsA
	ld de, UlriraPairsA
;> hBGTilesRequestCopy = 0         # scratch: "wants the broom"
	xor a
	ldh [hBGTilesRequestCopy], a
;>@w if wTradeSequenceItem < 0x0B and (mem[0xDB69] & 0x02 or wTradeSequenceItem >= 0x0A):
	ld a, [wTradeSequenceItem]
	cp $0b
	jr nc, .draw

;=@w
	ld a, [$db69]
	and $02
	jr nz, .wants

;=@w
	ld a, [wTradeSequenceItem]
	cp $0a
	jr c, .draw

.wants
;>     hBGTilesRequestCopy = 1
	ld a, $01
	ldh [hBGTilesRequestCopy], a
;>     pairs = UlriraPairsB
	ld de, UlriraPairsB

.draw
;> Call_3C3B(pairs)               # draw the pair of the sprite variant
	call Call_3C3B
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> Call_3B87(v)                   # set the sprite variant
	call Call_3B87
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> return GrandmaUlriraStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/grandma_ulrira
;@ Grandma Ulrira's states (wEntityState): 0 UlriraWaitForTalk, 1 UlriraAnswer, 2 UlriraSweep,
;@ 3 UlriraGiveHook.
GrandmaUlriraStates::
	dw UlriraWaitForTalk
	dw UlriraAnswer
	dw UlriraSweep
	dw UlriraGiveHook

;@ def UlriraWaitForTalk(slot: c)
;@ path: npc/grandma_ulrira
;@ State 0: with Bow-Wow following Link she says dialogue $178. Otherwise: not wanting the broom,
;@ dialogue $15A (before the trade) or $15F (after); wanting it, $15B - or, when Link has the
;@ broom, the request $15C and state 1.
;@ test: skip opens dialogues
UlriraWaitForTalk::
;> if not CheckLinkCanTalk_18():
	call CheckLinkCanTalk_18
;>     return
	jr nc, .done

;> if wIsBowWowFollowingLink == 0x80:
	ld a, [wIsBowWowFollowingLink]
	cp $80
	ld a, $78
;>     return OpenDialogTable1(0x78)   # dialogue $178
	jr z, .open

;> if not hBGTilesRequestCopy:    # she does not want the broom
	ldh a, [hBGTilesRequestCopy]
	and a
	jr nz, .wants

;>     return OpenDialogTable1(0x5A if wTradeSequenceItem < 0x0B else 0x5F)
	ld a, [wTradeSequenceItem]
	cp $0b
	ld a, $5a
	jr c, .open

	ld a, $5f

.open
	jp OpenDialogTable1

.wants
;> if wTradeSequenceItem == 0x0A: # Link has the broom
	ld a, [wTradeSequenceItem]
	cp $0a
	jr nz, .noBroom

;>     OpenDialogTable1(0x5C)     # dialogue $15C
	ld a, $5c
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

;> OpenDialogTable1(0x5B)         # dialogue $15B
.noBroom
	ld a, $5b
	call OpenDialogTable1

.done
	ret


;@ def UlriraAnswer(slot: c)
;@ path: npc/grandma_ulrira
;@ State 1: "yes": a jingle, the trade scene starts and she sweeps for $80 frames (state 2);
;@ "no": dialogue $159 and state 0.
;@ test: skip opens a dialogue
UlriraAnswer::
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     hJingle = 1
	ld a, $01
	ldh [hJingle], a
;>     wTradeSceneState = 1
	ld [wTradeSceneState], a
;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     Call_3B8D()                # next state
	call Call_3B8D
;>     return
	ret

.no
;> OpenDialogTable1(0x59)         # dialogue $159
	ld a, $59
	call OpenDialogTable1
;> wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b
	ret


;@ def UlriraSweep(slot: c)
;@ path: npc/grandma_ulrira
;@ State 2: Link is frozen while she holds up the broom (UlriraBroomSprite above her, variant
;@ 2). At the end Link gets the fishing hook (trading item $0B), with dialogue $15D (state 3).
;@ test: skip draws sprites and opens a dialogue
UlriraSweep::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .holding

;>     wTradeSequenceItem = 0x0B  # the fishing hook
	ld a, $0b
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     OpenDialogTable1(0x5D)     # dialogue $15D
	ld a, $5d
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.holding
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityDrawY -= 0x0E
	ldh a, [hActiveEntityDrawY]
	sub $0e
	ldh [hActiveEntityDrawY], a
;> hActiveEntityX -= 4
	ldh a, [hActiveEntityX]
	sub $04
	ldh [hActiveEntityX], a
;> Call_3C3B(UlriraBroomSprite)
	ld de, UlriraBroomSprite
	call Call_3C3B
;> Call_3DBA()                    # reload the position
	call Call_3DBA
;> return Call_3B87(2)
	ld a, $02
	jp Call_3B87


;@ def UlriraGiveHook(slot: c)
;@ path: npc/grandma_ulrira
;@ State 3: after the dialogue the trade scene ends, Link is free, the hook is shown over his
;@ head (SpawnHeldItemEntity) and she goes back to state 0.
;@ test: skip spawns an entity
UlriraGiveHook::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     wTradeSceneState = 0
	ld [wTradeSceneState], a
;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>     wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b

.done
	ret


;@ path: npc/mamasha
;@ Mamasha's 2 sprite frames (variant 0-1), 12 bytes each: 3 entries of y offset, x offset, tile,
;@ attributes - tiles $60 $62 $64 / $66 $68 $6A in a row from x - 8 (24 x 16 pixels). Drawn by
;@ MamashaEntityHandler.
MamashaSpriteFrames::
	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $00, $f8, $66, $00
	db $00, $00, $68, $00, $00, $08, $6a, $00

;@ path: unused/bank18
;@ Four bytes after Mamasha's frames ($02, $00, $06, $04) that nothing reads.
MamashaUnusedBytes::
	db $02, $00, $06, $04

;@ def MamashaEntityHandler(slot: c)
;@ path: npc/mamasha
;@ Entity $74: Mamasha, the mother in Mabe Village, who trades the Yoshi doll (trading item 1)
;@ for the ribbon (2). Drawn as 3 sprites, solid.
;@ test: skip runs a state machine with dialogues and sprite drawing
MamashaEntityHandler::
;>@fr frame = MamashaSpriteFrames + hActiveEntitySpriteVariant * 12
	ldh a, [hActiveEntitySpriteVariant]
	sla a
	sla a
	ld e, a
	sla a
	add e
;=@fr
	ld e, a
	ld d, b
	ld hl, MamashaSpriteFrames
	add hl, de
;> Call_3D26(frame, 3)
	ld c, $03
	call Call_3D26
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> Call_3B87(v)                   # set the sprite variant
	call Call_3B87
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> return MamashaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mamasha
;@ Mamasha's states (wEntityState): 0 MamashaWaitForTalk, 1 MamashaAnswer, 2 MamashaGiveRibbon.
MamashaStates::
	dw MamashaWaitForTalk
	dw MamashaAnswer
	dw MamashaGiveRibbon

;@ def MamashaWaitForTalk(slot: c)
;@ path: npc/mamasha
;@ State 0: dialogue $12A before the trading sequence started, $12C with another trading item;
;@ with the Yoshi doll she asks for it (dialogue $12B, state 1).
;@ test: skip opens dialogues
MamashaWaitForTalk::
;> if not CheckLinkCanTalk_18():
	call CheckLinkCanTalk_18
;>     return
	jr nc, .done

;> dialog = 0x2A
	ld a, [wTradeSequenceItem]
	and a
	ld e, $2a
;> if wTradeSequenceItem != 0:
	jr z, .open

;>     dialog = 0x2C
	ld e, $2c
;>     if wTradeSequenceItem == 1:   # the Yoshi doll
	cp $01
	jr nz, .open

;>         Call_3B8D()            # next state
	call Call_3B8D
;>         dialog = 0x2B
	ld e, $2b

.open
;> OpenDialogTable1(dialog)
	ld a, e
	call OpenDialogTable1

.done
	ret


;@ def MamashaAnswer(slot: c)
;@ path: npc/mamasha
;@ State 1: "yes": the trading item becomes the ribbon (2), dialogue $128 and state 2; "no":
;@ dialogue $127 and state 0.
;@ test: skip opens dialogues
MamashaAnswer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     wTradeSequenceItem = 2     # the ribbon
	ld a, $02
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     OpenDialogTable1(0x28)     # dialogue $128
	ld a, $28
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.no
;> OpenDialogTable1(0x27)         # dialogue $127
	ld a, $27
	call OpenDialogTable1
;> wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b

.done
	ret


;@ def MamashaGiveRibbon(slot: c)
;@ path: npc/mamasha
;@ State 2: after the dialogue the ribbon is shown over Link's head and she goes back to state 0.
;@ test: skip spawns an entity
MamashaGiveRibbon::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>     wEntityState[slot] = 0
	call Call_3B8D
	ld [hl], b

.done
	ret


;@ def MadBatterEntityHandler(slot: c)
;@ path: npc/mad_batter
;@ Entity $CA: the Mad Batter. Sprinkling magic powder on his pot wakes him (state 1): he rises
;@ in a cloud, offers to "curse" Link - each of his three huts raises one capacity: magic powder
;@ to 40, bombs to 60, arrows to 60 - strikes with a lightning bolt and flies off; the room event
;@ is then done for good. A copy of the same type with wEntityPrivate3 = 1 is the lightning bolt
;@ (MadBatterBoltHandler).
;@ test: skip runs a state machine with dialogues and sprite drawing
MadBatterEntityHandler::
;> if wEntityPrivate3[slot]:      # the lightning bolt
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
;>     return MadBatterBoltHandler(slot)
	jp nz, MadBatterBoltHandler

;> if hRoomStatus & 0x20:         # already met here
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> return MadBatterStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mad_batter
;@ The Mad Batter's states (wEntityState): 0 MadBatterWaitForPowder, 1 MadBatterAppear,
;@ 2 MadBatterRise, 3 MadBatterPuff, 4 MadBatterGreet, 5 MadBatterChooseUpgrade,
;@ 6 MadBatterAnswer, 7 MadBatterCurse, 8 MadBatterLeave.
MadBatterStates::
	dw MadBatterWaitForPowder
	dw MadBatterAppear
	dw MadBatterRise
	dw MadBatterPuff
	dw MadBatterGreet
	dw MadBatterChooseUpgrade
	dw MadBatterAnswer
	dw MadBatterCurse
	dw MadBatterLeave

;@ def MadBatterWaitForPowder(slot: c)
;@ path: npc/mad_batter
;@ State 0: hidden in his pot until the magic powder reaches it (that sets state 1 from
;@ outside). Once all three capacities are at their new maximum he is gone for good.
;@ test: c = rand(0, 15); wMaxMagicPowder = rand(0x20, 0x40); wMaxBombs = rand(0x30, 0x60); wMaxArrows = rand(0x30, 0x60)
MadBatterWaitForPowder::
;> if wMaxMagicPowder == MadBatterMaxValues[0]:
	ld a, [wMaxMagicPowder]
	ld hl, MadBatterMaxValues
	cp [hl]
	jr nz, .done

;>     if wMaxBombs == MadBatterMaxValues[1]:
	inc hl
	ld a, [wMaxBombs]
	cp [hl]
	jr nz, .done

;>         if wMaxArrows == MadBatterMaxValues[2]:
	inc hl
	ld a, [wMaxArrows]
	cp [hl]
;>             return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

.done
	ret


;@ def MadBatterAppear(slot: c)
;@ path: npc/mad_batter
;@ State 1: a puff of smoke (transient effect 2) and jingle 6; he rises for $90 frames (state 2).
;@ test: skip adds a transient effect
MadBatterAppear::
;> wEntityTimer[slot] = 0x90
	call GetEntityTimer
	ld [hl], $90
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)
	ld a, $02
	call AddTransientVfx
;> hJingle = 6
	ld a, $06
	ldh [hJingle], a
;> Call_3B8D()                    # next state
	call Call_3B8D
	ret


;@ def MadBatterRise(slot: c)
;@ path: npc/mad_batter
;@ State 2: the pot (DrawMadBatterPot) rises in a zigzag: y speed -4, x speed +4 and -4
;@ switching every 16 frames. Then it waits $60 frames (state 3).
;@ test: skip draws sprites
MadBatterRise::
;> DrawMadBatterPot()
	call DrawMadBatterPot
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rise

;>     wEntityTimer[slot] = 0x60
	ld [hl], $60
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.rise
;> speed = 0x04 if (t - 8) & 0x10 else 0xFC
	ld e, $fc
	sub $08
	and $10
	jr z, .setSpeed

	ld e, $04

.setSpeed
;> wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> wEntitySpeedY[slot] = 0xFC     # up
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fc
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
	ret


;@ def MadBatterPuff(slot: c)
;@ path: npc/mad_batter
;@ State 3: after the wait a bomb (entity 2) that explodes at once (timer $20) bursts at his place
;@ - the puff out of which he appears - and he waits $48 frames (state 4).
;@ test: skip spawns an entity through bank 3
MadBatterPuff::
;> DrawMadBatterPot()
	call DrawMadBatterPot
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x48
	ld [hl], $48
;>     bomb = Call_3C01(2)        # spawner position in hMultiPurpose0/1
	ld a, $02
	call Call_3C01
;>     wEntityX[bomb] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[bomb] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityTimer[bomb] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
;>     Call_3B8D()                # next state
	call Call_3B8D

.done
	ret


;@ def MadBatterGreet(slot: c)
;@ path: npc/mad_batter
;@ State 4: when the timer runs out he speaks (dialogue $E1).
;@ test: skip opens a dialogue
MadBatterGreet::
;> DrawMadBatter()
	call DrawMadBatter
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     MadBatterOpenDialog(0xE1)
	ld a, $e1
	call MadBatterOpenDialog
;>     Call_3B8D()                # next state
	call Call_3B8D

.done
	ret


;@ path: npc/mad_batter
;@ The new maximum of each capacity the Mad Batter raises (index 0 magic powder, 1 bombs,
;@ 2 arrows): 40, 60, 60 (BCD-like decimal values $40, $60, $60). Compared with and written to
;@ wMaxMagicPowder + index.
MadBatterMaxValues::
	db $40, $60, $60

;@ path: npc/mad_batter
;@ Dialogue (table 0) offering each upgrade, by the same index: $E2 magic powder, $E3 bombs,
;@ $E4 arrows.
MadBatterUpgradeDialogs::
	db $e2, $e3, $e4

;@ def MadBatterChooseUpgrade(slot: c)
;@ path: npc/mad_batter
;@ State 5: after the greeting, offers the next capacity in turn (wEntityPrivate1 cycles
;@ 0, 1, 2) that is not raised yet; the chosen index is kept in wSmasherBallSlot (the shared
;@ work byte $D201).
;@ test: skip opens a dialogue
MadBatterChooseUpgrade::
;> DrawMadBatter()
	call DrawMadBatter
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;>@loop while True:
.next
;>     i = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, $00
;>     wSmasherBallSlot = i
	ld a, e
	ld [wSmasherBallSlot], a
;>     wEntityPrivate1[slot] = (i + 1) % 3
	inc a
	cp $03
	jr nz, .store

	xor a

.store
	ld [hl], a
;>     if MadBatterMaxValues[i] != mem[wMaxMagicPowder + i]:   # not raised yet
	ld hl, MadBatterMaxValues
	add hl, de
	ld a, [hl]
	ld hl, wMaxMagicPowder
	add hl, de
	cp [hl]
;>         break
;=@loop
	jr z, .next

;> MadBatterOpenDialog(MadBatterUpgradeDialogs[i])
	ld hl, MadBatterUpgradeDialogs
	add hl, de
	ld a, [hl]
	call MadBatterOpenDialog
;> Call_3B8D()                    # next state
	call Call_3B8D

.done
	ret


;@ def MadBatterAnswer(slot: c)
;@ path: npc/mad_batter
;@ State 6: "yes": the lightning bolt appears (a second Mad Batter entity with wEntityPrivate3 = 1
;@ and timer $C0, noise effect $26) and he waits $C0 frames (state 7). "No": back to state 4,
;@ where he offers the next capacity.
;@ test: skip spawns an entity through bank 3
MadBatterAnswer::
;> DrawMadBatter()
	call DrawMadBatter
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	ret nz

;> Call_3B8D()                    # next state
	call Call_3B8D
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     bolt = Call_3C01(0xCA)     # spawner position in hMultiPurpose0/1
	ld a, $ca
	call Call_3C01
;>     hNoiseSfx = 0x26
	ld a, $26
	ldh [hNoiseSfx], a
;>     wEntityX[bolt] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[bolt] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate3[bolt] = 1
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
;>     wEntityTimer[bolt] = 0xC0
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $c0
;>     wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;>     return
	ret

.no
;> wEntityState[slot] -= 2        # back to MadBatterGreet's dialogue choice
	dec [hl]
	dec [hl]
	ret


;@ def MadBatterCurse(slot: c)
;@ path: npc/mad_batter
;@ State 7: during the bolt he stands still (frame 0). Then dialogue $E5 and the capacity is
;@ raised: the new maximum, and the count filled up to it - for the magic powder also the powder
;@ itself (item $0C) is given, the toadstool taken away and the inventory icons redrawn.
;@ test: skip opens a dialogue and changes the inventory
MadBatterCurse::
;> Call_3D26(MadBatterFrame0, 3)
	ld hl, MadBatterFrame0
	ld c, $03
	call Call_3D26
;> FreezeLinkForMadBatter()
	call FreezeLinkForMadBatter
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return
	ret nz

;> Call_3DAF()                    # speeds to 0
	call Call_3DAF
;> MadBatterOpenDialog(0xE5)
	ld a, $e5
	call MadBatterOpenDialog
;> Call_3B8D()                    # next state
	call Call_3B8D
;> i = wSmasherBallSlot           # the chosen capacity
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;> new = MadBatterMaxValues[i]
	ld hl, MadBatterMaxValues
	add hl, de
	ld a, [hl]
;> mem[wMaxMagicPowder + i] = new
	ld hl, wMaxMagicPowder
	add hl, de
	ld [hl], a
	ld d, a
;> if i == 0:
	ld a, e
	and a
	jr nz, .notPowder

;>     wMagicPowderCount = new
	ld hl, wMagicPowderCount
	ld [hl], d
;>     Call_3E95(0x0C)            # give the magic powder (item $0C)
	ld d, $0c
	call Call_3E95
;>     wHasToadstool = 0
	xor a
	ld [wHasToadstool], a
;>     hBGChangeRequest = 0x0B
	ld a, $0b
	ldh [hBGChangeRequest], a
;>     return
	ret

.notPowder
;> elif i == 1:
	cp $01
	jr nz, .arrows

;>     wBombCount = new
	ld hl, wBombCount
	ld [hl], d
	ret

;> else:
;>     wArrowCount = new
.arrows
	ld hl, wArrowCount
	ld [hl], d
	ret


;@ def MadBatterLeave(slot: c)
;@ path: npc/mad_batter
;@ State 8: after the dialogue he flies up and away, faster and faster (y speed -3 each frame,
;@ jingle $3B at the start). Once he is above the screen the room event is marked done, Link is
;@ free and the entity is removed.
;@ test: skip draws sprites
MadBatterLeave::
;> DrawMadBatter()
	call DrawMadBatter
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> if wEntityPrivate4[slot] == 0:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .fly

;>     wEntityPrivate4[slot] = 1
	inc [hl]
;>     hJingle = 0x3B
	ld a, $3b
	ldh [hJingle], a

.fly
;> UpdateEntityYWithSpeed_18(slot)
	call UpdateEntityYWithSpeed_18
;> wEntitySpeedY[slot] -= 3
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> if hActiveEntityDrawY >= 0xF0: # gone above the top
	ldh a, [hActiveEntityDrawY]
	cp $f0
	jr c, .done

;>     MarkRoomEventDone_18()
	call MarkRoomEventDone_18
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     ClearEntityStatus_18(slot)
	call ClearEntityStatus_18

.done
	ret


;@ def MadBatterOpenDialog(dialog: a)
;@ path: npc/mad_batter
;@ Opens dialogue `dialog` (table 0) as if Link stood at y = $20, so the box goes to the bottom
;@ of the screen.
;@ test: skip opens a dialogue
MadBatterOpenDialog::
;> y = hLinkY
	ld e, a
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x20
	ld a, $20
	ldh [hLinkY], a
;> OpenDialog(dialog)
	ld a, e
	call OpenDialog
;> hLinkY = y
	pop af
	ldh [hLinkY], a
	ret


;@ path: npc/mad_batter
;@ The Mad Batter, frame 0: 3 entries of y offset, x offset, tile, attributes - $70, $72 and $70
;@ mirrored in a row from x - 4 (24 x 16 pixels). Drawn by DrawMadBatter and MadBatterCurse.
MadBatterFrame0::
	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $70, $20

;@ path: npc/mad_batter
;@ The Mad Batter, frame 1: $74, $76, $74 mirrored (wings down).
MadBatterFrame1::
	db $00, $fc, $74, $00
	db $00, $04, $76, $00, $00, $0c, $74, $20

;@ def DrawMadBatter()
;@ path: npc/mad_batter
;@ Draws the Mad Batter flapping (frame 0 and 1, switching every 8 frames) and keeps Link frozen
;@ (FreezeLinkForMadBatter).
;@ test: skip draws sprites
DrawMadBatter::
;> frame = MadBatterFrame1 if hFrameCounter & 8 else MadBatterFrame0
	ld hl, MadBatterFrame0
	ldh a, [hFrameCounter]
	and $08
	jr z, .draw

	ld hl, MadBatterFrame1

.draw
;> Call_3D26(frame, 3)
	ld c, $03
	call Call_3D26
;> return FreezeLinkForMadBatter()
	jr FreezeLinkForMadBatter

;@ path: npc/mad_batter
;@ The Mad Batter's pot as it rises: 2 variants of a sprite pair (tile, attributes) - $7E and $7E
;@ mirrored, then the same upside down ($40, $60).
MadBatterPotPairs::
	db $7e, $00, $7e, $20, $7e, $40, $7e, $60

;@ def DrawMadBatterPot()
;@ path: npc/mad_batter
;@ Draws the rising pot (variant 0/1 every 8 frames) and keeps Link frozen.
;@ test: skip draws sprites
DrawMadBatterPot::
;> hActiveEntitySpriteVariant = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	ldh [hActiveEntitySpriteVariant], a
;> Call_3C3B(MadBatterPotPairs)
	ld de, MadBatterPotPairs
	call Call_3C3B
;> FreezeLinkForMadBatter()       # falls through

;@ def FreezeLinkForMadBatter()
;@ path: npc/mad_batter
;@ Keeps Link frozen in a standing pose (pose 4) while the Mad Batter appears and talks.
FreezeLinkForMadBatter::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> hLinkAnimationState = 4
	ld a, $04
	ldh [hLinkAnimationState], a
;> wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
	ret


;@ def MadBatterBoltHandler(slot: c)
;@ path: npc/mad_batter
;@ The lightning bolt (a Mad Batter entity with wEntityPrivate3 = 1): drawn while its timer runs,
;@ with the background palette flashing between $E4 and $44 every 2 frames; then it is removed.
;@ test: skip draws sprites
MadBatterBoltHandler::
;> DrawMadBatterBolt()
	call DrawMadBatterBolt
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

;> wBGPalette = 0x44 if t & 2 else 0xE4
	bit 1, a
	ld a, $e4
	jr z, .set

	ld a, $44

.set
	ld [wBGPalette], a
	ret


;@ path: npc/mad_batter
;@ The lightning bolt, frame 0: 12 entries of y offset, x offset, tile, attributes, from the top
;@ ($7C pieces 16-32 pixels down, then two rows of $78 $7A spread 32 pixels wide at 48 and 64).
;@ The first entries are drawn first, so a shorter count (MadBatterBoltSpriteCounts) shows only
;@ the top. Drawn by DrawMadBatterBolt.
MadBatterBoltFrame0::
	db $10, $00, $7c, $00, $10, $08, $7c, $60, $20, $00, $7c, $00, $20, $08, $7c, $60
	db $30, $f8, $78, $00, $30, $00, $7a, $00, $30, $08, $7a, $20, $30, $10, $78, $20
	db $40, $f8, $78, $40, $40, $00, $7a, $40, $40, $08, $7a, $60, $40, $10, $78, $60
;@ path: npc/mad_batter
;@ The lightning bolt, frame 1: the same 12 entries in sprite palette 1 (attribute bit 4), so
;@ the bolt flickers.
MadBatterBoltFrame1::
	db $10, $00, $7c, $50, $10, $08, $7c, $30, $20, $00, $7c, $50, $20, $08, $7c, $30
	db $30, $f8, $78, $10, $30, $00, $7a, $10, $30, $08, $7a, $30, $30, $10, $78, $30
	db $40, $f8, $78, $50, $40, $00, $7a, $50, $40, $08, $7a, $70, $40, $10, $78, $70
;@ path: npc/mad_batter
;@ How many of the bolt's 12 sprites are drawn during its first 16 frames (timer $C0 down to
;@ $B0), one byte per 4 frames from the end: 12, 12, 4, 2 - so it grows downwards. Read by
;@ DrawMadBatterBolt.
MadBatterBoltSpriteCounts::
	db $0c, $0c, $04, $02

;@ def DrawMadBatterBolt(slot: c)
;@ path: npc/mad_batter
;@ Draws the lightning bolt 5 pixels higher than the entity: all 12 sprites, or fewer while it
;@ grows (MadBatterBoltSpriteCounts), switching between the two palettes every 4 frames.
;@ test: skip draws sprites
DrawMadBatterBolt::
;> hActiveEntityDrawY -= 5
	ldh a, [hActiveEntityDrawY]
	sub $05
	ldh [hActiveEntityDrawY], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> count = 12
	ld c, $0c
;> if t >= 0xB0:
	cp $b0
	jr c, .pick

;>@cnt     count = MadBatterBoltSpriteCounts[((t - 0xB0) >> 2) & 3]
	sub $b0
	rra
	rra
	and $03
	ld e, a
	ld d, b
;=@cnt
	ld hl, MadBatterBoltSpriteCounts
	add hl, de
	ld c, [hl]

.pick
;> frame = MadBatterBoltFrame1 if hFrameCounter & 4 else MadBatterBoltFrame0
	ld hl, MadBatterBoltFrame0
	ldh a, [hFrameCounter]
	and $04
	jr z, .draw

	ld hl, MadBatterBoltFrame1

.draw
;> Call_3D26(frame, count)
	call Call_3D26
;> Call_3DD0(4)                   # claim 4 more OAM entries
	ld a, $04
	call Call_3DD0
	ret


;@ path: link/ocarina
;@ The musical note: one (tile, attributes) pair for a single sprite - tile $0E, attributes 0.
;@ Drawn by MusicalNoteEntityHandler.
MusicalNoteSprite::
	db $0e, $00

;@ def MusicalNoteEntityHandler(slot: c)
;@ path: link/ocarina
;@ Entity $C9: a musical note that rises from Link while he plays the ocarina (spawned by the
;@ ocarina code in bank 2 with its speed). It sways: every other frame its x speed changes by
;@ +1 or -1, the direction turning every 16 frames of its counter; when the counter runs out it
;@ disappears.
;@ test: skip draws a sprite
MusicalNoteEntityHandler::
;> Call_3CD0(MusicalNoteSprite)   # draw one sprite
	ld de, MusicalNoteSprite
	call Call_3CD0
;> n = (wEntityPrivateCounter[slot] - 1) & 0xFF
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	dec a
;> wEntityPrivateCounter[slot] = n
	ld [hl], a
;> if n == 0:
;>     return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

;> step = 0xFF if n & 0x10 else 0x01
	bit 4, a
	ld e, $01
	jr z, .even

	ld e, $ff

.even
;> if not n & 1:
	bit 0, a
	jr nz, .move

;>     wEntitySpeedX[slot] += step
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a

.move
;> return UpdateEntityPosWithSpeed_18(slot)
	jp UpdateEntityPosWithSpeed_18


;@ path: npc/animal_village
;@ Sprite pairs of the Animal Village animal $D0, by variant: 2 x (tile, attributes) ($20
;@ mirrored). 0: $50 $52, 1: the same mirrored (facing down), 2: $54 $56, 3: mirrored (facing up).
AnimalSpritePairsD0::
	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20

;@ def AnimalD0EntityHandler(slot: c)
;@ path: npc/animal_village
;@ Entity $D0: an animal of Animal Village that is only there while Marin sings in the village.
;@ It turns towards Marin (down while she is lower on the screen, else up), sways every 32
;@ frames, is solid and talks (dialogue $196).
;@ test: skip draws sprites and opens a dialogue
AnimalD0EntityHandler::
;> RemoveUnlessMarinInVillage(slot)
	call RemoveUnlessMarinInVillage
;> Call_3C3B(AnimalSpritePairsD0)
	ld de, AnimalSpritePairsD0
	call Call_3C3B
;> marin = wSingingMarinSlot
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
;> marin_y = wEntityY[marin]
	ld hl, wEntityY
	add hl, de
;> e = 0 if hActiveEntityY < marin_y else 2   # look down / up at Marin
	ldh a, [hActiveEntityY]
	ld e, $00
	cp [hl]
	jr c, .face

	ld e, $02

.face
;> v = hFrameCounter >> 5
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;> Call_3B87((v & 1) + e)
	and $01
	add e
	call Call_3B87

AnimalTalkToLink:
;> PushLinkOutOfEntity_18(slot)   # (shared end of the animals $D0-$D2)
	call PushLinkOutOfEntity_18
;> if CheckLinkCanTalk_18():
	call CheckLinkCanTalk_18
	jr nc, .done

;>     OpenDialogTable1(0x96)     # dialogue $196
	ld a, $96
	call OpenDialogTable1

.done
	ret


;@ def RemoveUnlessMarinInVillage(slot: c)
;@ path: npc/animal_village
;@ The animals that listen to Marin exist only while she is in Animal Village: otherwise the
;@ entity is removed (its handler still finishes this frame).
;@ test: c = rand(0, 15)
RemoveUnlessMarinInVillage::
;> if not wIsMarinInAnimalVillage:
	ld a, [wIsMarinInAnimalVillage]
	and a
;>     return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

;> return
	ret nz

;@ path: npc/animal_village
;@ Sprite pairs of the animal $D1, by variant: 0: $74 $76, 1: $70 $72 (facing left), 2: $76 $74
;@ mirrored, 3: $72 $70 mirrored (facing right).
AnimalSpritePairsD1::
	db $74, $00, $76, $00, $70, $00, $72, $00, $76, $20, $74, $20, $72, $20, $70, $20

;@ def AnimalD1EntityHandler(slot: c)
;@ path: npc/animal_village
;@ Entity $D1: another animal listening to Marin in Animal Village; it turns left or right
;@ towards her, sways every 32 frames and talks like AnimalD0EntityHandler.
;@ test: skip draws sprites and opens a dialogue
AnimalD1EntityHandler::
;> RemoveUnlessMarinInVillage(slot)
	call RemoveUnlessMarinInVillage
;> Call_3C3B(AnimalSpritePairsD1)
	ld de, AnimalSpritePairsD1
	call Call_3C3B
;> marin = wSingingMarinSlot
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
;> marin_x = wEntityX[marin]
	ld hl, wEntityX
	add hl, de
;> e = 0 if hActiveEntityX >= marin_x else 2   # look left / right at Marin
	ldh a, [hActiveEntityX]
	ld e, $00
	cp [hl]
	jr nc, .face

	ld e, $02

.face
;> v = hFrameCounter >> 5
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;> Call_3B87((v & 1) + e)
	and $01
	add e
	call Call_3B87
;> return AnimalTalkToLink()
	jr AnimalTalkToLink

;@ path: npc/animal_village
;@ Sprite pairs of the animal $D3 for AnimateEntityByDirection_18 (two frames per facing):
;@ 0-1 down ($50 $52 and mirrored), 2-3 up ($54 $56 and mirrored), 4-5 left ($58 $5A twice),
;@ 6-7 right ($5A $58 mirrored twice).
AnimalSpritePairsD3::
	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20
	db $58, $00, $5a, $00, $58, $00, $5a, $00, $5a, $20, $58, $20, $5a, $20, $58, $20

;@ def AnimalD3EntityHandler(slot: c)
;@ path: npc/animal_village
;@ Entity $D3: an animal hopping about in Animal Village while Marin is not there. It turns to
;@ Link every 64 frames, hops every 32 frames, is solid and talks: dialogue $24A-$251 (table 2)
;@ - by place (indoors, room $CC, room $CD, elsewhere) plus 4 once bit 1 of $DB6A is set - or
;@ $252 while Marin follows Link.
;@ test: skip draws sprites and opens a dialogue
AnimalD3EntityHandler::
;> if wIsMarinInAnimalVillage:
	ld a, [wIsMarinInAnimalVillage]
	and a
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;> Call_3C3B(AnimalSpritePairsD3)
	ld de, AnimalSpritePairsD3
	call Call_3C3B
;> if hFrameCounter & 0x3F == 0:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .animate

;>     wEntityDirection[slot] = GetEntityDirectionToLink_18(slot)
	call GetEntityDirectionToLink_18
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

.animate
;> AnimateEntityByDirection_18(slot)
	call AnimateEntityByDirection_18
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> wEntitySpeedZ[slot] -= 2       # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> z = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
;> if z == 0 or z & 0x80:         # on (or below) the ground
	and a
	jr z, .ground

	and $80
	jr z, .airborne

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
	jr nz, .airborne

;>         wEntitySpeedZ[slot] = 0x0C   # hop
	ld [hl], $0c

.airborne
;> hActiveEntityDrawY = hActiveEntityY   # talk and collide at its ground position
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> Call_3DBA()                    # reload the position
	call Call_3DBA
;> if not CheckLinkCanTalk_18():
	call CheckLinkCanTalk_18
;>     return
	ret nc

;> e = 0                          # indoors
	ld e, $00
	ld a, [wIsIndoor]
	and a
;> if not wIsIndoor:
	jr nz, .flag

;>@room     e = 1 if hMapRoom == 0xCC else 2 if hMapRoom == 0xCD else 3
	inc e
	ldh a, [hMapRoom]
	cp $cc
	jr z, .flag

;=@room
	inc e
	cp $cd
	jr z, .flag

;=@room
	inc e

.flag
;> if mem[0xDB6A] & 0x02:
	ld a, [$db6a]
	and $02
	jr z, .open

;>     e += 4
	ld a, e
	add $04
	ld e, a

.open
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .alone

;>     return OpenDialogTable2(0x52)  # dialogue $252
	ld a, $52
	jp OpenDialogTable2

;> return OpenDialogTable2(0x4A + e)  # dialogue $24A + e
.alone
	ld a, e
	add $4a
	jp OpenDialogTable2


;@ path: npc/animal_village
;@ Sprite pairs of the animal $D2, by variant: 0: $78 $7A, 1: $7C $7E (facing left), 2: $7A $78
;@ mirrored, 3: $7E $7C mirrored (facing right).
AnimalSpritePairsD2::
	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20

;@ def AnimalD2EntityHandler(slot: c)
;@ path: npc/animal_village
;@ Entity $D2: a third animal listening to Marin, turning left or right towards her, like
;@ AnimalD1EntityHandler.
;@ test: skip draws sprites and opens a dialogue
AnimalD2EntityHandler::
;> RemoveUnlessMarinInVillage(slot)
	call RemoveUnlessMarinInVillage
;> Call_3C3B(AnimalSpritePairsD2)
	ld de, AnimalSpritePairsD2
	call Call_3C3B
;> marin = wSingingMarinSlot
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
;> marin_x = wEntityX[marin]
	ld hl, wEntityX
	add hl, de
;> e = 0 if hActiveEntityX >= marin_x else 2
	ldh a, [hActiveEntityX]
	ld e, $00
	cp [hl]
	jr nc, .face

	ld e, $02

.face
;> v = hFrameCounter >> 5
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;> Call_3B87((v & 1) + e)
	and $01
	add e
	call Call_3B87
;> return AnimalTalkToLink()
	jp AnimalTalkToLink


;@ path: npc/bunny
;@ Sprite pairs of the bunny who calls Marin away: 0-1 running right ($5A $58 / $5E $5C
;@ mirrored), 2-3 running left ($58 $5A / $5C $5E).
BunnySpritePairs::
	db $5a, $20, $58, $20, $5e, $20, $5c, $20, $58, $00, $5a, $00, $5c, $00, $5e, $00

;@ def BunnyCallingMarinEntityHandler(slot: c)
;@ path: npc/bunny
;@ Entity $C8: the bunny from Animal Village who, after the walrus is gone, runs in from the
;@ left, hops about, asks Marin to come and sing in the village and leads her away. Link is
;@ frozen all the time. hBGTilesRequestCopy is borrowed as a "just landed" flag for BunnyHop.
;@ test: skip runs a cutscene state machine
BunnyCallingMarinEntityHandler::
;> Call_3C3B(BunnySpritePairs)
	ld de, BunnySpritePairs
	call Call_3C3B
;> v = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> Call_3B87(v)                   # set the sprite variant
	call Call_3B87
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> wEntitySpeedZ[slot] -= 2       # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80   # landed
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
;> return BunnyStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/bunny
;@ The bunny's states (wEntityState): 0 BunnyRunIn, 1 BunnyGreet, 2 BunnyAsk,
;@ 3 BunnyLeaveWithMarin.
BunnyStates::
	dw BunnyRunIn
	dw BunnyGreet
	dw BunnyAsk
	dw BunnyLeaveWithMarin

;@ def BunnyRunIn(slot: c)
;@ path: npc/bunny
;@ State 0: after the start timer it runs right (speed $0C). At x $20 Marin and Link turn left
;@ to look at it; at x $48 it stops for $40 frames (state 1).
;@ test: skip updates Link's pose through another bank
BunnyRunIn::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return
	ret nz

;> wEntitySpeedX[slot] = 0x0C
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $0c
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> if hActiveEntityX == 0x20:
	ldh a, [hActiveEntityX]
	cp $20
	jr nz, .notTurn

;>     SetFollowerFacing(1)       # Marin looks left
	ld a, $01
	call SetFollowerFacing
;>     hLinkDirection = 1         # so does Link
	ld a, $01
	ldh [hLinkDirection], a
;>     UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;>     return
	ret

.notTurn
;> if hActiveEntityX == 0x48:
	cp $48
	ret nz

;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     return Call_3B8D()         # next state
	jp Call_3B8D


;@ def BunnyGreet(slot: c)
;@ path: npc/bunny
;@ State 1: after the pause it speaks (dialogue $1E3) and goes on to state 2; it keeps hopping.
;@ test: skip opens a dialogue
BunnyGreet::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, BunnyHop

;>     OpenDialogTable1(0xE3)     # dialogue $1E3
	ld a, $e3
	call OpenDialogTable1
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     Call_3B8D()                # next state
	call Call_3B8D
;> BunnyHop(slot)                 # falls through

;@ def BunnyHop(slot: c)
;@ path: npc/bunny
;@ Hops: after landing it waits on the ground for 9 frames (wEntityPrivate4 counts down), then
;@ jumps with height speed $12.
;@ test: c = rand(0, 15)
BunnyHop::
;> if hBGTilesRequestCopy:         # on the ground
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .done

;>     n = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
;>     wEntityPrivate4[slot] -= 1
	dec [hl]
;>     if n == 0:
	and a
	jr nz, .done

;>         wEntityPrivate4[slot] = 8
	ld [hl], $08
;>         wEntitySpeedZ[slot] = 0x12
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $12

.done
	ret


;@ def BunnyAsk(slot: c)
;@ path: npc/bunny
;@ State 2: Marin looks up and then right while the timer runs; then the bunny asks her to come
;@ along (dialogue $1E5, state 3).
;@ test: skip opens a dialogue
BunnyAsk::
;> BunnyHop(slot)
	call BunnyHop
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .look

;>     wEntityTimer[slot] = 0x10
	ld [hl], $10
;>     OpenDialogTable1(0xE5)     # dialogue $1E5
	ld a, $e5
	call OpenDialogTable1
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.look
;> SetFollowerFacing(2 if t >= 8 else 0)   # Marin looks up, then right
	ld e, $02
	cp $08
	jr nc, .set

	ld e, $00

.set
	ld a, e
	call SetFollowerFacing

;> return
.done
	ret


;@ def BunnyLeaveWithMarin(slot: c)
;@ path: npc/bunny
;@ State 3: Marin looks left and up; then she is marked as in Animal Village and both run off
;@ to the left (the bunny at speed -20 until x $E0, Marin at -12 with her walking frames). When
;@ Marin reaches x $F0 the bunny is removed, Marin no longer follows Link and Link is free.
;@ test: skip moves another entity
BunnyLeaveWithMarin::
;> BunnyHop(slot)
	call BunnyHop
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr z, .leave

;>     return SetFollowerFacing(1 if t < 8 else 2)
	ld e, $01
	cp $08
	jr c, .set

	ld e, $02

.set
	ld a, e
	jp SetFollowerFacing

.leave
;>@run Call_3B87(2 + ((hFrameCounter >> 3) & 1))   # running left
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;=@run
	call Call_3B87
;> wIsMarinInAnimalVillage = 1
	ld hl, wIsMarinInAnimalVillage
	ld [hl], $01
;> if hActiveEntityX & 0xFC != 0xE0:
	ldh a, [hActiveEntityX]
	and $fc
	cp $e0
	jr z, .marin

;>     wEntitySpeedX[slot] = 0xEC # -20
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $ec
;>     UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18

.marin
;> marin = wSingingMarinSlot
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
;> wEntitySpeedX[marin] = 0xF4    # -12
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $f4
;>@mv wEntitySpriteVariant[marin] = 4 + ((hFrameCounter >> 3) & 1)   # walking left
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $04
;=@mv
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>@mx UpdateEntityXWithSpeed_18(marin)
	push de
	push bc
	push de
	pop bc
	call UpdateEntityXWithSpeed_18
	pop bc
;=@mx
	pop de
;> if wEntityX[marin] == 0xF0:    # off the left edge
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	cp $f0
	jr nz, .done

;>     ClearEntityStatus_18(slot)
	call ClearEntityStatus_18
;>     wIsMarinFollowingLink = 0
	xor a
	ld [wIsMarinFollowingLink], a
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a

.done
	ret


;@ def LeverEntityHandler(slot: c)
;@ path: object/lever
;@ Entity $69: a pull handle hanging on a chain from the wall. Link cannot walk through it from
;@ below; standing right under it and holding the button of the Power Bracelet (item 3) he grabs
;@ it (pose $3A, facing up) and, holding down, pulls it down to y $50 - while it is pulled
;@ hLeverPullState is 1, while held 2, and the doors or blocks linked to it react to that. Let
;@ go, the handle slides back up to y $1B (state 0).
;@ test: skip reads the joypad and moves Link
LeverEntityHandler::
;> DrawLever(slot)
	call DrawLever
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if (hActiveEntityX - hLinkX + 4) & 0xFF < 8:   # Link right below the handle
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $04
	cp $08
	jr nc, .grab

;>     if hLinkY <= hActiveEntityDrawY + 4:
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	add $04
	sub [hl]
	jr c, .grab

;>         StopLinkAtEntity_18()  # he cannot pass through it
	call StopLinkAtEntity_18

.grab
;>@g if (hActiveEntityX - hLinkX + 6) & 0xFF < 0x0C and (hActiveEntityDrawY - hLinkY + 8) & 0xFF < 4:
	ld hl, hLinkX
	ldh a, [hActiveEntityX]
	sub [hl]
	add $06
	cp $0c
	jr nc, .release

;=@g
	ld hl, hLinkY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $08
	cp $04
	jr nc, .release

;>     if wItemB == 3:            # the Power Bracelet on B
	ld e, $20
	ld a, [wItemB]
	cp $03
;>         button = 0x20
	jr z, .check

;>     elif wItemA == 3:          # ... or on A
	ld e, $10
	ld a, [wItemA]
	cp $03
;>         button = 0x10
;>     else: return release()
	jr nz, .release

.check
;>     if not hJoypadHeld & button:
	ldh a, [hJoypadHeld]
	and e
;>         return release()
	jr z, .release

;>     hLeverPullState = 2        # held
	ld a, $02
	ldh [hLeverPullState], a
;>     hLinkAnimationState = 0x3A # pulling pose
	ld a, $3a
	ldh [hLinkAnimationState], a
;>     hLinkDirection = 2         # facing up
	ld a, $02
	ldh [hLinkDirection], a
;>     hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;>     ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>     hLinkX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;>     hLinkY = hActiveEntityDrawY + 8
	ldh a, [hActiveEntityDrawY]
	add $08
	ldh [hLinkY], a
;>     if hLinkY < 0x50 and hJoypadHeld & 0x08:   # holding down, not fully pulled
	cp $50
	jr nc, .stuck

	ldh a, [hJoypadHeld]
	and $08
	jr z, .stuck

;>         n = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;>         wEntityPrivateCounter[slot] += 1
	inc [hl]
;>         if n & 0x18:           # pulls in steps
	and $18
	jr z, .held

;>             hLinkAnimationState += 1
	ld hl, hLinkAnimationState
	inc [hl]
;>             wEntitySpeedY[slot] = 4
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $04
;>             UpdateEntityYWithSpeed_18(slot)   # the handle comes down
	call UpdateEntityYWithSpeed_18
;>             hLeverPullState = 1
	ld a, $01
	ldh [hLeverPullState], a

.held
;>         return
	ret

.stuck
;>     wEntityPrivateCounter[slot] = 8
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $08
;>     return
	ret

.release
;> if hActiveEntityDrawY >= 0x1B: # slide back up
	ldh a, [hActiveEntityDrawY]
	cp $1b
	jr c, .done

;>     wEntitySpeedY[slot] = 0xFD # -3
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fd
;>     UpdateEntityYWithSpeed_18(slot)
	call UpdateEntityYWithSpeed_18
;>     hLeverPullState = 0
	ld a, $00
	ldh [hLeverPullState], a

.done
	ret


;@ path: object/lever
;@ The handle, by variant: 2 x (tile, attributes) - 0: $44 and $44 mirrored, 1: $74 and $74
;@ mirrored (the look in dungeon map 1). Drawn by DrawLever.
LeverHandlePairs::
	db $44, $00, $44, $20, $74, $00, $74, $20

;@ path: object/lever
;@ One link of the chain above the handle, by variant: 0: $46 and $46 mirrored, 1: $76 and $76
;@ mirrored. DrawLever repeats it every 16 pixels.
LeverChainPairs::
	db $46, $00, $46, $20, $76, $00, $76, $20

;@ def DrawLever(slot: c)
;@ path: object/lever
;@ Draws the handle (variant 1 in dungeon map 1) and the chain from 4 pixels above its anchor
;@ (wEntityPrivate2) down to the handle, one link per 16 pixels.
;@ test: skip draws sprites
DrawLever::
;> if hMapId == 1:
	ldh a, [hMapId]
	cp $01
	jr nz, .draw

;>     hActiveEntitySpriteVariant = 1
	ldh [hActiveEntitySpriteVariant], a

.draw
;> Call_3C3B(LeverHandlePairs)
	ld de, LeverHandlePairs
	call Call_3C3B
;> top = (wEntityPrivate2[slot] - 4) & 0xFF
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	add $fc
;> if top >= 0xF0:
;>     return
	cp $f0
	ret nc

;> hActiveEntityDrawY = top
	ldh [hActiveEntityDrawY], a

.link
;>@chain while True:
;>     Call_3C3B(LeverChainPairs)
	ld de, LeverChainPairs
	call Call_3C3B
;>     hActiveEntityDrawY += 0x10
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hActiveEntityDrawY], a
;>     if hActiveEntityDrawY >= hActiveEntityY:
;>         break
	ld hl, hActiveEntityY
	cp [hl]
;=@chain
	jr c, .link

;> Call_3DBA()                    # reload the position
	call Call_3DBA
	ret


;@ path: npc/walrus
;@ The "Z" of the sleeping walrus, by variant: one (tile, attributes) pair each - 0: $24, 1: $3E.
;@ Drawn by WalrusSnoreHandler.
WalrusSnoreSprites::
	db $24, $00, $3e, $00

;@ def WalrusSnoreHandler(slot: c)
;@ path: npc/walrus
;@ A snore "Z" of the walrus (entity $C4 with wEntityPrivate1 set): it drifts up and to the left
;@ (moving every 4th frame; faster up during 32 of every 64 frames), shows its second look from
;@ $40 frames left (one step 4 pixels lower) and disappears when its timer runs out.
;@ test: skip draws a sprite
WalrusSnoreHandler::
;> Call_3CD0(WalrusSnoreSprites)
	ld de, WalrusSnoreSprites
	call Call_3CD0
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

;> v = 1
	ld e, $01
;> if t == 0x40:
	cp $40
	jr c, .set

	jr nz, .first

;>     wEntityY[slot] += 4
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $04
	ld [hl], a
	jr .set

;> elif t > 0x40:
;>     v = 0
.first
	dec e

.set
;> Call_3B87(v)
	ld a, e
	call Call_3B87
;>@sy wEntitySpeedY[slot] = 0xFC if wEntityTimer[slot] & 0x20 else 0xFE
	call GetEntityTimer
	ld e, $fe
	and $20
	jr z, .speed

	ld e, $fc

.speed
;=@sy
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], e
;> wEntitySpeedX[slot] = 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $ff
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	ret nz

;>     UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
	ret


;@ def WalrusEntityHandler(slot: c)
;@ path: npc/walrus
;@ Entity $C4: the walrus sleeping across the way to the Yarna Desert. It snores; when Marin
;@ follows Link and they come close, Marin offers to sing; her Ballad wakes it, it rolls over
;@ into the sea with a splash, and a bunny from Animal Village comes to fetch Marin. Once that
;@ is done (status of overworld room $FD bit 5) the entity is the walrus in the sea instead
;@ (WalrusInSeaHandler); with wEntityPrivate1 set it is one of its snore "Z"s.
;@ test: skip runs a cutscene state machine
WalrusEntityHandler::
;> if wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
;>     return WalrusSnoreHandler(slot)
	jp nz, WalrusSnoreHandler

;> if wRoomStatus[0xFD] & 0x20:   # the walrus has left the way
	ld a, [wRoomStatus + $fd]
	and $20
;>     return WalrusInSeaHandler(slot)
	jp nz, WalrusInSeaHandler

;> DrawWalrus(slot)
	call DrawWalrus
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> wEntitySpeedZ[slot] -= 1       # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:      # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .solid

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.solid
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> return WalrusStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/walrus
;@ The walrus's states (wEntityState): 0 WalrusSleep, 1 WalrusAskMarin, 2 WalrusListen,
;@ 3 WalrusWakeUp, 4 WalrusRoll, 5 WalrusLand, 6 WalrusGone, 7 WalrusCallBunny, 8 WalrusIdle.
WalrusStates::
	dw WalrusSleep
	dw WalrusAskMarin
	dw WalrusListen
	dw WalrusWakeUp
	dw WalrusRoll
	dw WalrusLand
	dw WalrusGone
	dw WalrusCallBunny
	dw WalrusIdle

;@ def WalrusSleep(slot: c)
;@ path: npc/walrus
;@ State 0: every 128 frames a snore "Z" rises (a walrus entity with wEntityPrivate1 = 1, timer
;@ $60, physics flags $C1, 8 pixels left and 2 lower). Without Marin, talking to it gives
;@ dialogue $1E0. With Marin following, when Link comes near (within 19 pixels sideways and 32
;@ up or down) he is stopped and, once he and Marin are on the ground, Marin asks whether she
;@ should sing (dialogue $1E1) and turns right.
;@ test: skip spawns entities and opens a dialogue
WalrusSleep::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] & 0x7F == 0:
	ld a, $7f
	and [hl]
	jr nz, .marin

;>     ok, z = Call_3C01(0xC4)    # spawn a snore; the walrus's position in hMultiPurpose0/1
	ld a, $c4
	call Call_3C01
;>     if ok:
	jr c, .marin

;>         wEntityX[z] = hMultiPurpose0 - 8
	ldh a, [hMultiPurpose0]
	sub $08
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[z] = hMultiPurpose1 + 2
	ldh a, [hMultiPurpose1]
	add $02
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityTimer[z] = 0x60
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60
;>         wEntityPhysicsFlags[z] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c1
;>         wEntityPrivate1[z] += 1    # it is a snore
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]

.marin
;> if not wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr nz, .withMarin

;>     if CheckLinkCanTalkTall_18():
	call CheckLinkCanTalkTall_18
	jr nc, .done

;>         OpenDialogTable1(0xE0) # dialogue $1E0
	ld a, $e0
	call OpenDialogTable1

.done
;>     return
	ret

.withMarin
;> ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> if (dx + 0x13) & 0xFF >= 0x26:
;>     return
	add $13
	cp $26
	ret nc

;> ey, dy = GetEntityYDistanceToLink_18(slot)
	call GetEntityYDistanceToLink_18
;> if (dy + 0x20) & 0xFF >= 0x40:
;>     return
	add $20
	cp $40
	ret nc

;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> Call_1495()                    # Link's speed to 0
	call Call_1495
;> if wIsLinkInTheAir:
;>     return
	ld a, [wIsLinkInTheAir]
	and a
	ret nz

;>@mz if wEntityZ[wSingingMarinSlot]: # Marin is in the air
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityZ
	add hl, de
;=@mz
	ld a, [hl]
	and a
;>     return
	ret nz

;> Call_3B8D()                    # next state
	call Call_3B8D
;> OpenDialogTable1(0xE1)         # dialogue $1E1: Marin offers to sing
	ld a, $e1
	call OpenDialogTable1
;> SetFollowerFacingRight()       # Marin turns to the walrus
	call SetFollowerFacingRight
	ret


;@ def WalrusAskMarin(slot: c)
;@ path: npc/walrus
;@ State 1: "yes": Marin sings the Ballad of the Wind Fish (music $2F, wMarinSinging) for $50
;@ frames of the drop timer (state 2); "no": dialogue $1E4 and the walrus stays in state 8
;@ (nothing more happens in this room).
;@ test: skip opens a dialogue
WalrusAskMarin::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> Call_3B8D()                    # next state
	call Call_3B8D
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     wMusicTrackToPlay = 0x2F
	ld a, $2f
	ld [wMusicTrackToPlay], a
;>     wMarinSinging = 0x2F
	ld [wMarinSinging], a
;>     wEntityDropTimer[slot] = 0x50
	call GetEntityDropTimer
	ld [hl], $50
;>     return
	ret

.no
;> wEntityState[slot] = 8
	ld [hl], $08
;> OpenDialogTable1(0xE4)         # dialogue $1E4
	ld a, $e4
	call OpenDialogTable1

.done
	ret


;@ def WalrusListen(slot: c)
;@ path: npc/walrus
;@ State 2: Link is frozen while Marin starts singing; the walrus stirs (variant 0 and 1, now and
;@ then a blink, frame 2 at the end). Then state 3 for $C0 frames.
;@ test: skip runs the drop timer
WalrusListen::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> t = wEntityDropTimer[slot]
	call GetEntityDropTimer
;> if t == 0:
	jr nz, .stir

;>     wEntityDropTimer[slot] = 0xC0
	ld [hl], $c0
;>     Call_3B8D()                # next state
	call Call_3B8D
;>     return
	ret

.stir
;>@v v = 0 if t >= 0x40 else 2 if t < 0x10 else 0 if t >= 0x3C or t in (0x20, 0x21, 0x22) else 1
	ld e, $00
	cp $40
	jr nc, .set

;=@v
	ld e, $02
	cp $10
	jr c, .set

;=@v
	ld e, $00
	cp $3c
	jr nc, .one

	cp $20
	jr z, .set

;=@v
	cp $21
	jr z, .set

	cp $22
	jr z, .set

.one
;=@v
	ld e, $01

.set
;> Call_3B87(v)
	ld a, e
	call Call_3B87
	ret


;@ path: npc/walrus
;@ The walrus's sprite variant while it wakes up: 96 bytes, one per 8 frames (index
;@ wEntityPrivate3), the pattern 1 2 1 2 1 1 2 2 repeated. Read by WalrusWakeUp.
WalrusWakeFrames::
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02

;@ def WalrusWakeUp(slot: c)
;@ path: npc/walrus
;@ State 3: while Marin sings the walrus wriggles (WalrusWakeFrames) and every 128 frames (up to
;@ step $60) hops with jingle $24; on frame 2 it groans (jingle $27 every 64 frames). In the air
;@ it shows variant 1 rising and 2 falling. At the end Marin stops, noise $11, variant 2 and
;@ state 4.
;@ test: skip runs the drop timer
WalrusWakeUp::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityDropTimer[slot] == 0:
	call GetEntityDropTimer
	jr nz, .wriggle

;>     wMarinSinging = 0
	ld [wMarinSinging], a
;>     hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     Call_3B87(2)
	ld a, $02
	call Call_3B87
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.wriggle
;> step = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	ld d, b
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .frame

;>     wEntityPrivate3[slot] += 1
	inc [hl]
;>     if wEntityPrivate3[slot] < 0x60 and wEntityPrivate3[slot] & 0x0F == 0:
	ld a, [hl]
	cp $60
	jr nc, .frame

	and $0f
	jr nz, .frame

;>         wEntitySpeedZ[slot] = 0x10   # hop
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>         hJingle = 0x24
	ld a, $24
	ldh [hJingle], a

.frame
;> v = WalrusWakeFrames[step]
	ld hl, WalrusWakeFrames
	add hl, de
	ld a, [hl]
;> if v == 2:
	cp $02
	jr nz, .set

;>     if hFrameCounter & 0x3F == 0:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .two

;>         hJingle = 0x27
	ld hl, hJingle
	ld [hl], $27

.two
	ld a, $02

.set
;> Call_3B87(v)
	call Call_3B87
;> if wEntityZ[slot]:             # in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;>@air     Call_3B87(1 if wEntitySpeedZ[slot] < -8 else 2)   # (signed)
	ld e, $01
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sub $f8
	and $80
;=@air
	jr nz, .air

	inc e

.air
	ld a, e
	call Call_3B87

.done
	ret


;@ def WalrusRoll(slot: c)
;@ path: npc/walrus
;@ State 4: every 16 frames the walrus rolls one frame further towards the sea (y + 4, variant +
;@ 1); after frame 3 it leaps (height $18, y + $18, jingle 8; state 5).
;@ test: c = rand(0, 15)
WalrusRoll::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x10
	ld [hl], $10
;>     wEntityY[slot] += 4
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $04
	ld [hl], a
;>     wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wEntitySpriteVariant[slot] == 4:
	cp $04
	jr nz, .done

;>         wEntityZ[slot] = 0x18
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $18
;>         wEntityY[slot] += 0x18
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $18
	ld [hl], a
;>         hJingle = 8
	ld a, $08
	ldh [hJingle], a
;>         Call_3B8D()            # next state
	call Call_3B8D

.done
	ret


;@ def WalrusLand(slot: c)
;@ path: npc/walrus
;@ State 5: when the walrus is down in the water, a splash (WalrusSplashes) and state 6 after 8
;@ frames.
;@ test: skip adds transient effects
WalrusLand::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityZ[slot]:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr nz, WalrusSplashes.done

;> Call_3B8D()                    # next state
	call Call_3B8D
;> wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;> WalrusSplashes()               # falls through

;@ def WalrusSplashes()
;@ path: npc/walrus
;@ Two splashes (transient effect 1) 16 pixels below the walrus, at its left and 16 pixels to
;@ the right, with noise effect $24.
;@ test: skip adds transient effects
WalrusSplashes::
;> hNoiseSfx = 0x24
	ld a, $24
	ldh [hNoiseSfx], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY + 0x10
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hMultiPurpose1], a
;> AddTransientVfx(1)
	ld a, $01
	call AddTransientVfx
;> hMultiPurpose0 = hActiveEntityX + 0x10
	ldh a, [hActiveEntityX]
	add $10
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY + 0x10
	ldh a, [hActiveEntityDrawY]
	add $10
	ldh [hMultiPurpose1], a
;> AddTransientVfx(1)
	ld a, $01
	call AddTransientVfx

.done
	ret


;@ def WalrusGone(slot: c)
;@ path: npc/walrus
;@ State 6: the walrus shows its diving frame (5) until the timer runs out; then it is gone
;@ (variant $FF), the area music comes back, Marin says dialogue $1E2 and she and Link turn down
;@ (state 7).
;@ test: skip updates Link's pose through another bank
WalrusGone::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return Call_3B87(5)
	jr nz, .diving

;> Call_3B8D()                    # next state
	call Call_3B8D
;> wMusicTrackToPlay = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	ld [wMusicTrackToPlay], a
;> Call_3B87(0xFF)                # not drawn any more
	ld a, $ff
	call Call_3B87
;> OpenDialogTable1(0xE2)         # dialogue $1E2
	ld a, $e2
	call OpenDialogTable1
;> SetFollowerFacing(3)           # Marin faces down
	ld a, $03
	call SetFollowerFacing
;> hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
	ret

.diving
	ld a, $05
	jp Call_3B87


;@ def WalrusCallBunny(slot: c)
;@ path: npc/walrus
;@ State 7: the bunny that calls Marin (entity $C8) is placed off the left edge (x $F8, y $48,
;@ timer $20); the walrus entity is removed and the room event marked done.
;@ test: skip spawns an entity through bank 3
WalrusCallBunny::
;> bunny = Call_3C01(0xC8)
	ld a, $c8
	call Call_3C01
;> wEntityX[bunny] = 0xF8
	ld hl, wEntityX
	add hl, de
	ld [hl], $f8
;> wEntityTimer[bunny] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
;> wEntityY[bunny] = 0x48
	ld hl, wEntityY
	add hl, de
	ld [hl], $48
;> ClearEntityStatus_18(slot)
	call ClearEntityStatus_18
;> MarkRoomEventDone_18()
	call MarkRoomEventDone_18
	ret


;@ def WalrusIdle()
;@ path: npc/walrus
;@ State 8: does nothing (after Link said no to Marin's song).
WalrusIdle::
;> return
	ret


;@ path: npc/walrus
;@ The walrus's 6 sprite frames (variant 0-5), 32 bytes each: 8 entries of y offset, x offset,
;@ tile, attributes ($40 upside down) for 8x16 sprites in a 4 x 2 grid (32 x 32 pixels).
;@ 0: asleep ($60-$66 over $68-$6E), 1: one eye open ($70), 2: head up ($72 $74, $76),
;@ 3: on its back ($78-$7E and the same upside down), 4: frame 0 upside down, 5: diving (the top
;@ row upside down at y $0E, the bottom row tile $FF = not visible). Drawn by DrawWalrus.
WalrusSpriteFrames::
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $60, $00, $00, $08, $70, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $72, $00, $00, $08, $74, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $76, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $78, $00, $00, $08, $7a, $00, $00, $10, $7c, $00, $00, $18, $7e, $00
	db $10, $00, $78, $40, $10, $08, $7a, $40, $10, $10, $7c, $40, $10, $18, $7e, $40
	db $00, $00, $68, $40, $00, $08, $6a, $40, $00, $10, $6c, $40, $00, $18, $6e, $40
	db $10, $00, $60, $40, $10, $08, $62, $40, $10, $10, $64, $40, $10, $18, $66, $40
	db $0e, $00, $68, $40, $0e, $08, $6a, $40, $0e, $10, $6c, $40, $0e, $18, $6e, $40
	db $10, $00, $ff, $40, $10, $08, $ff, $40, $10, $10, $ff, $40, $10, $18, $ff, $40
;@ path: npc/walrus
;@ The walrus's shadow while it is in the air: 4 entries of y offset, x offset, tile, attributes
;@ - tile $26 four times in a row, 23 pixels below its ground position.
WalrusShadowSprites::
	db $17, $03, $26, $00, $17, $09, $26, $00, $17, $0f, $26, $00, $17, $15, $26, $00

;@ def DrawWalrus(slot: c)
;@ path: npc/walrus
;@ Draws the walrus (8 sprites of its frame) and, while it is in the air, its shadow at its
;@ ground position.
;@ test: skip draws sprites
DrawWalrus::
;>@fr frame = WalrusSpriteFrames + hActiveEntitySpriteVariant * 32
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
;=@fr
	and $e0
	ld e, a
	ld d, b
	ld hl, WalrusSpriteFrames
	add hl, de
;> Call_3D26(frame, 8)
	ld c, $08
	call Call_3D26
;> if wEntityZ[slot] == 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
;>     return
	ret z

;> hActiveEntityDrawY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;> Call_3D26(WalrusShadowSprites, 4)
	ld hl, WalrusShadowSprites
	ld c, $04
	call Call_3D26
;> Call_3DD0(4)                   # claim 4 more OAM entries
	ld a, $04
	call Call_3DD0
;> Call_3DBA()                    # reload the position
	call Call_3DBA
	ret


;@ def WalrusInSeaHandler(slot: c)
;@ path: npc/walrus
;@ The walrus after the event, out in the sea at (x $80, y $68): when Link plays the Ballad of
;@ the Wind Fish (song 0) it comes up with a splash, says dialogue $1E6 and dives again for good.
;@ test: skip runs a state machine with dialogues
WalrusInSeaHandler::
;> DrawSwimmingWalrus(slot)
	call DrawSwimmingWalrus
;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return
	ret nz

;> return WalrusInSeaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/walrus
;@ States of the walrus in the sea: 0 WalrusInSeaInit, 1 WalrusInSeaWaitForSong,
;@ 2 WalrusInSeaSurface, 3 WalrusInSeaTalk.
WalrusInSeaStates::
	dw WalrusInSeaInit
	dw WalrusInSeaWaitForSong
	dw WalrusInSeaSurface
	dw WalrusInSeaTalk

;@ def WalrusInSeaInit(slot: c)
;@ path: npc/walrus
;@ State 0: places the walrus at (x $80, y $68) and waits $20 frames.
;@ test: c = rand(0, 15)
WalrusInSeaInit::
;> wEntityY[slot] = 0x68
	ld hl, wEntityY
	add hl, bc
	ld [hl], $68
;> wEntityX[slot] = 0x80
	ld hl, wEntityX
	add hl, bc
	ld [hl], $80
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> return Call_3B8D()             # next state
	jp Call_3B8D


;@ def WalrusInSeaWaitForSong(slot: c)
;@ path: npc/walrus
;@ State 1: waits for the Ballad of the Wind Fish (selected song 0, ocarina state $40); then a
;@ splash and state 2.
;@ test: skip adds transient effects
WalrusInSeaWaitForSong::
;>@s if wEntityTimer[slot] == 0 and wSelectedSong == 0 and wOcarinaSongState == 0x40:
	call GetEntityTimer
	jr nz, .done

	ld a, [wSelectedSong]
	cp $00
	jr nz, .done

;=@s
	ld a, [wOcarinaSongState]
	and a
	cp $40
	jr nz, .done

;>     Call_3B8D()                # next state
	call Call_3B8D
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     WalrusSplashes()
	call WalrusSplashes

.done
	ret


;@ def WalrusInSeaSurface(slot: c)
;@ path: npc/walrus
;@ State 2: the walrus rises (variant 2, then 1 for the last 16 frames); then state 3 for $C8
;@ frames.
;@ test: c = rand(0, 15)
WalrusInSeaSurface::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rise

;>     wEntityTimer[slot] = 0xC8
	ld [hl], $c8
;>     return Call_3B8D()         # next state
	jp Call_3B8D

.rise
;> Call_3B87(1 if t < 0x10 else 2)
	cp $10
	ld a, $01
	jr c, .set

	inc a

.set
	call Call_3B87
	ret


;@ def WalrusInSeaTalk(slot: c)
;@ path: npc/walrus
;@ State 3: with $80 frames left the walrus speaks (dialogue $1E6); it bobs with its mouth moving
;@ (wEntityPrivate5) until 32 frames are left, sinks (variant 1, then 2) and finally dives with
;@ a splash and is removed.
;@ test: skip opens a dialogue and adds transient effects
WalrusInSeaTalk::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .talk

;>     WalrusSplashes()
	call WalrusSplashes
;>     return ClearEntityStatus_18(slot)
	jp ClearEntityStatus_18

.talk
;> # (a leftover compare with $B0 that does nothing)
	cp $b0
	jr nz, .check

.check
;> if wEntityTimer[slot] == 0x80:
	call GetEntityTimer
	cp $80
	jr nz, .pose

;>     wEntityTimer[slot] -= 1    # only once
	dec [hl]
;>     OpenDialogTable1(0xE6)     # dialogue $1E6
	ld a, $e6
	call OpenDialogTable1

.pose
;> t = wEntityTimer[slot]
	call GetEntityTimer
;>@tv talking, v = (0, 2) if t < 0x10 else (0, 1) if t < 0x20 else (1, 1)
	ld d, $00
	cp $10
	ld e, $02
	jr c, .set

;=@tv
	dec e
	cp $20
	jr c, .set

	inc d

.set
;> wEntityPrivate5[slot] = talking
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], d
;> Call_3B87(v)
	ld a, e
	call Call_3B87
	ret


;@ path: npc/walrus
;@ The walrus in the sea, 3 frames of 20 bytes: 5 entries of y offset, x offset, tile, attributes
;@ (tile or y $FF = not drawn). 0: nothing visible, 1: head $70 $72 over $74 $76 $78 (mouth
;@ open, 24 x 32 pixels), 2: only the head top $7A $7C $7E in the water. Drawn by
;@ DrawSwimmingWalrus.
WalrusSwimFrames::
	db $ff, $04, $ff, $00, $ff, $0c, $ff, $00, $ff, $04, $ff, $00, $ff, $0c, $ff, $00
	db $ff, $14, $ff, $00, $fc, $04, $70, $00, $fc, $0c, $72, $00, $0c, $04, $74, $00
	db $0c, $0c, $76, $00, $0c, $14, $78, $00, $0c, $04, $7a, $00, $0c, $0c, $7c, $00
	db $0c, $14, $7e, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ path: npc/walrus
;@ Bobbing of the walrus in the sea: 8 y offsets in pixels (0 0 1 2 3 3 2 1), one per 16 frames.
;@ Read by DrawSwimmingWalrus.
WalrusBobOffsets::
	db $00, $00, $01, $02
	db $03, $03, $02, $01

;@ def DrawSwimmingWalrus(slot: c)
;@ path: npc/walrus
;@ Draws the walrus in the sea, bobbing (WalrusBobOffsets); while it talks (wEntityPrivate5) its
;@ frame switches between 1 and 2 every 64 frames.
;@ test: skip draws sprites
DrawSwimmingWalrus::
;>@bob hActiveEntityDrawY += WalrusBobOffsets[(hFrameCounter >> 4) & 7]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	nop
;=@bob
	nop
	and $07
	ld e, a
	ld d, b
	ld hl, WalrusBobOffsets
	add hl, de
;=@bob
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> if wEntityPrivate5[slot]:      # talking
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	and a
	jr z, .draw

;>@tk     hActiveEntitySpriteVariant = ((hFrameCounter >> 6) & 1) + 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;=@tk
	rra
	and $01
	inc a
	ldh [hActiveEntitySpriteVariant], a

.draw
;>@f frame = WalrusSwimFrames + hActiveEntitySpriteVariant * 20
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
;=@f
	rla
	and $f0
	add e
	ld e, a
	ld d, b
;=@f
	ld hl, WalrusSwimFrames
	add hl, de
;> return Call_3D26(frame, 5)
	ld c, $05
	jp Call_3D26


SetFollowerFacingRight::
	ld a, $00

SetFollowerFacing::
	ld e, $10
	ld hl, wFollowerTrailDir

jr_018_59bf:
	ld [hli], a
	dec e
	jr nz, jr_018_59bf

	ret


	db $42, $20, $40, $20, $40, $00, $42, $00, $44, $00, $46, $00, $46, $20, $44, $20
	db $48, $00, $4a, $00, $4c, $00, $4e, $00, $4a, $20, $48, $20, $4e, $20, $4c, $20
	db $50, $00, $52, $00, $54, $00, $54, $20, $52, $20, $50, $20, $06, $04, $02, $00

MarinFollowHandler::
	ld a, c
	ld [wSingingMarinSlot], a
	call GetEntityTimer
	jr z, jr_018_5a4b

	cp $10
	jr nz, jr_018_5a13

	dec [hl]
	ldh a, [hLinkY]
	push af
	ld a, $28
	ldh [hLinkY], a
	ld a, $1f
	call OpenDialog
	pop af
	ldh [hLinkY], a
	ld a, $0f

jr_018_5a13:
	cp $01
	jr nz, jr_018_5a24

	xor a
	ld [wLinkFrozen], a
	ld a, $31
	ld [wMusicTrackToPlay], a
	ld a, $05
	ldh [hDefaultMusicTrack], a

jr_018_5a24:
	xor a
	ld [wEntitySpriteVariant], a
	ld de, $59c4
	call Call_3C3B
	ld a, $6c
	ldh [hLinkAnimationState], a
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $03
	ldh [hLinkDirection], a
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ldh a, [hLinkY]
	sub $10
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ret


jr_018_5a4b:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, MarinFollowUpdate

	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, jr_018_5a8b

	inc [hl]
	call GetEntityTimer
	ld [hl], $70
	ld a, $10
	ld [wMusicTrackToPlay], a
	ld a, $ff
	ldh [hLastMusicTrack], a
	ldh a, [hLinkX]
	ld hl, wFollowerTrailX
	call FillFollowerTrail
	ldh a, [hLinkY]
	ld hl, wFollowerTrailY
	call FillFollowerTrail
	xor a
	ld hl, wFollowerTrailZ
	call FillFollowerTrail
	ldh a, [hLinkDirection]
	ld hl, wFollowerTrailDir

FillFollowerTrail::
	ld e, $10

jr_018_5a87:
	ld [hli], a
	dec e
	jr nz, jr_018_5a87

jr_018_5a8b:
	ret


	db $08, $08, $08, $09, $0a, $0a, $0a, $09, $08, $f8, $06, $01

MarinFollowUpdate::
	ld a, [wMarinSinging]
	and a
	jr z, jr_018_5af3

	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5a8c
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_018_5af3

	ld a, $c9
	call Call_3C01
	jr c, jr_018_5af3

	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $08
	ld [hl], a
	push bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
	and $01
	ld c, a
	ld hl, $5a94
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $5a96
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fc
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], $40
	pop bc

jr_018_5af3:
	ld de, $59c4
	call Call_3C3B
	ld a, [wInventoryAppearing]
	and a
	ret nz

	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_5b0f

	dec a
	jr nz, jr_018_5b0f

	dec [hl]
	ld a, $7a
	call OpenDialogTable2

jr_018_5b0f:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_5b6a

	cp $30
	jr nz, jr_018_5b55

	xor a
	ld [wLinkFrozen], a
	ldh a, [hLinkX]
	sub $58
	add $03
	cp $06
	jr nc, jr_018_5b33

	ldh a, [hLinkY]
	sub $50
	add $03
	cp $06
	jr c, jr_018_5b3b

jr_018_5b33:
	ld [hl], b
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1c
	ret


jr_018_5b3b:
	ld hl, hJingle
	ld [hl], $0b
	ld hl, hWaveSfx
	ld [hl], $03
	ld hl, wBumpShakeTimer
	ld [hl], $18
	ld hl, wBumpShakeAxis
	ld [hl], $04
	ld hl, hLinkX
	inc [hl]
	jr jr_018_5b61

jr_018_5b55:
	jr nc, jr_018_5b6a

	cp $10
	jr nz, jr_018_5b61

	dec [hl]
	ld a, $7b
	call OpenDialogTable2

jr_018_5b61:
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $6a
	ldh [hLinkAnimationState], a
	ret


jr_018_5b6a:
	ld a, [wIsMarinInAnimalVillage]
	ld hl, $c1bc
	or [hl]
	ret nz

	ld a, [wMarinReunion]
	and a
	jp z, MarinFollowLink

	call Call_3B9E
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	call ReturnIfNonInteractive_18
	ld a, [wMarinReunionTimer]
	and a
	jr z, jr_018_5b90

	dec a
	ld [wMarinReunionTimer], a

jr_018_5b90:
	ldh a, [hActiveEntityState]
	rst $00

MarinReunionStates::
	dw MarinReunionStart
	dw MarinReunionTurn
	dw MarinReunionWalk
	dw MarinReunionTalk
	dw MarinReunionEnd

MarinReunionStart::
	ld a, [wLinkMotionState]
	cp $03
	ret z

	ld a, $40
	ld [wMarinReunionTimer], a
	ld a, $0f
	ldh [hBGChangeRequest], a
	ld a, $01
	call Call_3B87
	jp Call_3B8D


MarinReunionTurn::
	ld a, [wMarinReunionTimer]
	and a
	jr nz, jr_018_5bd1

	ld a, $18
	ld [wMarinReunionTimer], a
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
	ld a, $04
	call Call_3B87
	ld a, $10
	ldh [hBGChangeRequest], a
	call Call_3B8D

jr_018_5bd1:
	ret


MarinReunionWalk::
	ld a, [wMarinReunionTimer]
	and a
	jr nz, jr_018_5c0a

	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f4
	call UpdateEntityXWithSpeed_18
	ldh a, [hFrameCounter]
	and $08
	ld e, $04
	jr z, jr_018_5bea

	inc e

jr_018_5bea:
	ld a, e
	call Call_3B87
	call GetEntityXDistanceToLink_18
	add $02
	cp $04
	ret nc

	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $02
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
	ld a, $10
	ld [wMarinReunionTimer], a
	call Call_3B8D

jr_018_5c0a:
	ret


MarinReunionTalk::
	ld a, [wMarinReunionTimer]
	and a
	jr nz, jr_018_5c3e

	ld a, [wMarinReunion]
	dec a
	ld e, a
	ld a, [wLowHealth]
	cp e
	jr z, jr_018_5c2c

	and a
	jr z, jr_018_5c2c

	ld e, $1c
	call GetRandomByte
	and $3f
	jr nz, jr_018_5c37

	ld e, $1e
	jr jr_018_5c37

jr_018_5c2c:
	ld e, $1b
	ld a, [$db47]
	cp $80
	jr nc, jr_018_5c37

	ld e, $1d

jr_018_5c37:
	ld a, e
	call OpenDialogTable2
	call Call_3B8D

jr_018_5c3e:
	ret


MarinReunionEnd::
	xor a
	ld [wMarinReunion], a
	ld [wLinkFrozen], a
	call Call_3B8D
	ld [hl], b
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $ff
	ldh a, [hActiveEntityX]
	ld hl, wFollowerTrailX
	call FillTrail16
	ld hl, wFollowerTrailY
	ldh a, [hActiveEntityDrawY]
	ld e, $10

jr_018_5c5f:
	ld [hli], a
	dec a
	dec e
	jr nz, jr_018_5c5f

	ld a, $02
	ld hl, wFollowerTrailDir

FillTrail16::
	ld e, $10

jr_018_5c6b:
	ld [hli], a
	dec e
	jr nz, jr_018_5c6b

	ret


MarinFollowLink::
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

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
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $59f0
	add hl, de
	push hl
	ld a, [wLinkWalkingFrameCount]
	rra
	rra
	rra
	pop hl
	and $01
	or [hl]
	call Call_3B87
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
	and $0f
	ld e, a
	ld d, b
	ld hl, wFollowerTrailX
	add hl, de
	ldh a, [hLinkPrevX]
	ld [hl], a
	ldh a, [hLinkPrevY]
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, wFollowerTrailY
	add hl, de
	ld [hl], a
	ld hl, wFollowerTrailDir
	add hl, de
	ldh a, [hLinkDirection]
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
	and $0f
	ld e, a
	ld d, b
	ld hl, wFollowerTrailZ
	add hl, de
	ldh a, [hLinkPositionZ]
	ld [hl], a
	ld a, [wLinkMotionState]
	cp $02
	jr z, jr_018_5cf0

	ld a, [wRoomTransitionState]
	and a
	jr nz, jr_018_5cf0

	ld a, [wDialogState]
	and a
	jr nz, jr_018_5cf5

	ld hl, hLinkSpeedX
	ldh a, [hLinkSpeedY]
	or [hl]
	jr z, jr_018_5cf5

jr_018_5cf0:
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]

jr_018_5cf5:
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ldh a, [hBGTilesRequestCopy]
	inc a
	and $0f
	ld e, a
	ld d, b
	ld hl, wFollowerTrailX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, wFollowerTrailY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ld hl, wFollowerTrailDir
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurposeH]
	inc a
	and $0f
	ld e, a
	ld d, b
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wFollowerTrailZ
	add hl, de
	ld e, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], e
	call GetEntityTimer1
	ld hl, wRoomTransitionState
	or [hl]
	jr nz, jr_018_5d83

	pop af
	cp e
	jr z, jr_018_5d80

	and a
	jr z, jr_018_5d75

	ld a, e
	and a
	jr nz, jr_018_5d80

	call Call_3B9E
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $02
	ret z

	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	dec a
	cp $02
	jr c, jr_018_5d64

	ld a, $07
	ldh [hNoiseSfx], a
	ret


jr_018_5d64:
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ld a, $0e
	ldh [hJingle], a
	ld a, $0c
	jp AddTransientVfx


jr_018_5d75:
	ld a, e
	cp $08
	ld a, $08
	jr nc, jr_018_5d7e

	ld a, $24

jr_018_5d7e:
	ldh [hJingle], a

jr_018_5d80:
	jp Call_3B9E


jr_018_5d83:
	pop af
	ret


	db $00, $01, $ff, $00, $10, $f0

TextDebuggerEntityHandler::
	call ReturnIfNonInteractive_18
	ld a, $01
	ldh [hAnimatedTilesGroup], a
	inc a
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ldh a, [hJoypadPressed]
	and $03
	ld e, a
	ld d, b
	ld hl, $5d85
	add hl, de
	ld a, [wDebugDialogIndex]
	push af
	add [hl]
	and $0f
	ld e, a
	pop af
	and $f0
	or e
	ld [wDebugDialogIndex], a
	ldh a, [hJoypadPressed]
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5d88
	add hl, de
	ld a, [wDebugDialogIndex]
	add [hl]
	ld [wDebugDialogIndex], a
	ld a, [wDialogState]
	and a
	jr nz, jr_018_5de2

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_018_5dd6

	ld a, [wDebugDialogIndex]
	jp OpenDialog


jr_018_5dd6:
	ldh a, [hJoypadPressed]
	and $20
	jr z, jr_018_5de2

	ld a, [wDebugDialogIndex]
	jp OpenDialogTable1


jr_018_5de2:
	ldh a, [hJoypadPressed]
	and $40
	jr z, jr_018_5dee

	ld a, [wDebugDialogIndex]
	jp OpenDialogTable2


jr_018_5dee:
	ret


SkyScrollEntityHandler::
	call ReturnIfNonInteractive_18
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_018_5dfc

	ld hl, wScrollXOffset
	inc [hl]

jr_018_5dfc:
	ret


	db $5e, $00, $5e, $20, $00, $f8, $50, $00, $00, $00, $52, $00, $00, $08, $54, $00
	db $00, $10, $56, $00

MuralHandler::
	ld hl, $5e01
	ld c, $04
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_5E21::
	dw Jump_18_5E27
	dw Jump_18_5E30
	dw Jump_18_5E4B

Jump_18_5E27::
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
	jp Call_3B8D


Jump_18_5E30::
	call ReturnIfNonInteractive_18
	call GetEntityTimer
	ret nz

	call CheckLinkCanTalk_18
	ret nc

	ld a, [wBGPalette]
	cp $e4
	jr nz, jr_018_5e45

	jp Call_3B8D


jr_018_5e45:
	ld a, $e6
	call OpenDialog
	ret


Jump_18_5E4B::
	call ReturnIfNonInteractive_18
	ld a, [wDialogState]
	and a
	jr nz, jr_018_5e67

	ld a, $0a
	call StartGameplayType_18
	call GetEntityTimer
	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	ld hl, $d8ac
	set 4, [hl]

jr_018_5e67:
	ret


Call_18_5E68::
	ldh a, [hMapId]
	cp $16
	jp z, MuralHandler

	ldh a, [hActiveEntityDrawY]
	add $01
	ldh [hActiveEntityDrawY], a
	ld de, $5dfd
	call Call_3C3B
	call PushLinkOutOfEntity_18
	call ReturnIfNonInteractive_18
	call CheckLinkCanTalk_18
	jr nc, jr_018_5e95

	ld a, [wDungeonHasStoneBeak]
	and a
	ld a, $10
	jr z, jr_018_5e92

	ldh a, [hMapId]
	add $08

jr_018_5e92:
	call OpenDialogTable1

jr_018_5e95:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_18_5EB6::
	ld a, [wDungeon7Flags]
	and $02
	jp z, ClearEntityStatus_18

	ld a, [wIsRoosterFollowingLink]
	and a
	jp nz, ClearEntityStatus_18

	ldh a, [hRoomStatus]
	and $10
	jp nz, ClearEntityStatus_18

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_60dd

	ld a, c
	ld [wSingingMarinSlot], a
	ld de, $5e96
	call Call_3C3B
	call AnimateEntityByDirection_18
	call UpdateEntityZWithSpeed_18
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	ldh [hBGTilesRequestCopy], a
	jr z, jr_018_5ef9

	and $80
	jr z, jr_018_5eff

jr_018_5ef9:
	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_018_5eff:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_5F02::
	dw Jump_18_5F22
	dw Jump_18_5F54
	dw Jump_18_5F62
	dw Jump_18_5F7C
	dw Jump_18_5FAD
	dw Jump_18_5FD1
	dw Jump_18_5FE3
	dw Jump_18_5FFA
	dw Jump_18_6012
	dw Jump_18_6035
	dw Jump_18_603D
	dw Jump_18_6059
	dw Jump_18_607B

Call_18_5F1C::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	ret


Jump_18_5F22::
	call Call_18_5F3F
	call ReturnIfNonInteractive_18
	call GetEntityXDistanceToLink_18
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ldh a, [hLinkX]
	cp $90
	jr nc, jr_018_5f3e

	ld a, $35
	call OpenDialogTable2
	call Call_3B8D

jr_018_5f3e:
	ret


Call_18_5F3F::
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_018_5f47

	and $80
	ret z

jr_018_5f47:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, jr_018_5f53

	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

jr_018_5f53:
	ret


Jump_18_5F54::
	call Call_18_5F3F
	call ReturnIfNonInteractive_18
	ld a, $36
	call OpenDialogTable2
	jp Call_3B8D


Jump_18_5F62::
	call Call_18_5F3F
	call ReturnIfNonInteractive_18
	call GetEntityXDistanceToLink_18
	add $08
	cp $10
	ret nc

	call GetEntityYDistanceToLink_18
	add $10
	cp $20
	ret nc

	call Call_3B8D
	ret


Jump_18_5F7C::
	call Call_18_5F1C
	call ReturnIfNonInteractive_18
	call GetEntityXDistanceToLink_18
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	ld a, [wHookshotInUse]
	and a
	jr z, jr_018_5fa1

	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	add $10
	ld [hl], a
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ret


jr_018_5fa1:
	xor a
	ld [wItemUsePoseTimer], a
	call GetEntityTimer
	ld [hl], $10
	jp Call_3B8D


Jump_18_5FAD::
	call Call_18_5F1C
	call ReturnIfNonInteractive_18
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ld a, $00
	ldh [hLinkDirection], a
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
	call GetEntityTimer
	jr nz, jr_018_5fd0

	ld a, $37
	call OpenDialogTable2
	call Call_3B8D

jr_018_5fd0:
	ret


Jump_18_5FD1::
	call Call_18_5F1C
	call ReturnIfNonInteractive_18
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $38
	call OpenDialogTable2
	jp Call_3B8D


Jump_18_5FE3::
	call Call_18_5F1C
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call ReturnIfNonInteractive_18
	ld a, $39
	call OpenDialogTable2
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
	jp Call_3B8D


Jump_18_5FFA::
	call Call_18_5F1C
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call ReturnIfNonInteractive_18
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $a0
	jr nz, jr_018_6011

	jp Call_3B8D


jr_018_6011:
	ret


Jump_18_6012::
	call Call_18_5F1C
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call ReturnIfNonInteractive_18
	ld a, $c2
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $12
	ld hl, wEntityY
	add hl, de
	ld [hl], $88
	ld hl, wEntityPrivate2
	add hl, de
	inc [hl]
	jp Call_3B8D


Jump_18_6035::
	call Call_18_5F1C
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


Jump_18_603D::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ldh a, [hActiveEntityDrawY]
	cp $3e
	jr c, jr_018_604a

	jp Call_3B8D


jr_018_604a:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $06
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
	jp UpdateEntityYWithSpeed_18


Jump_18_6059::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fa
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
	call UpdateEntityXWithSpeed_18
	ldh a, [hActiveEntityX]
	cp $18
	jr nc, jr_018_607a

	call GetEntityTimer
	ld [hl], $60
	call Call_3B8D

jr_018_607a:
	ret


Jump_18_607B::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	jr z, jr_018_608b

	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
	ret


jr_018_608b:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f4
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
	call UpdateEntityXWithSpeed_18
	ldh a, [hActiveEntityX]
	cp $f0
	jr nz, jr_018_60af

	xor a
	ld [wLinkFrozen], a
	ld hl, $d808
	set 4, [hl]
	ld a, [hl]
	ldh [hRoomStatus], a
	jp ClearEntityStatus_18


jr_018_60af:
	call GetEntityXDistanceToLink_18
	ld a, e
	xor $01
	ldh [hLinkDirection], a
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
	ret


	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5a, $20, $58, $20, $5e, $20, $5c, $20

Jump_018_60dd:
	ld de, $60bd
	call Call_3C3B
	call AnimateEntityByDirection_18
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_60E9::
	dw Jump_18_60F1
	dw Jump_18_6123
	dw Jump_18_6139
	dw Jump_18_615D

Jump_18_60F1::
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f4
	call UpdateEntityYWithSpeed_18
	ldh a, [hActiveEntityDrawY]
	cp $70
	jr nc, jr_018_6122

	ld a, $3b
	call OpenDialogTable2
	ld a, $03
	ldh [hLinkDirection], a
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $03
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
	call Call_3B8D

jr_018_6122:
	ret


Jump_18_6123::
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $03
	call ReturnIfNonInteractive_18
	ld a, $3a
	call OpenDialogTable2
	jp Call_3B8D


Jump_18_6139::
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $03
	ld a, [wDialogCharIndex]
	cp $22
	jr c, jr_018_614d

	ld [hl], $01

jr_018_614d:
	call ReturnIfNonInteractive_18
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	inc [hl]
	jp Call_3B8D


Jump_18_615D::
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f8
	call UpdateEntityXWithSpeed_18
	ldh a, [hActiveEntityX]
	cp $e0
	jr nz, jr_018_6175

	call ClearEntityStatus_18

jr_018_6175:
	ret


Call_18_6176::
	ld a, [wIsMarinFollowingLink]
	and a
	jp nz, MarinFollowHandler

	ld a, [wIsMarinInAnimalVillage]
	and a
	ret nz

	ld a, [$d8fd]
	and $20
	jp nz, ClearEntityStatus_18

	ld a, [wTradeSequenceItem]
	cp $07
	jp c, ClearEntityStatus_18

	ld de, $5e96
	call Call_3C3B
	ld a, [wRoomTransitionState]
	and a
	ret nz

	call PushLinkOutOfEntity_18
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_61A3::
	dw Jump_18_61B1
	dw Jump_18_61BE
	dw Jump_18_61DB
	dw Jump_18_61FB
	dw Jump_18_622E
	dw Jump_18_623D
	dw Jump_18_6252

Jump_18_61B1::
	ld a, $4d
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrack], a
	ldh [hDefaultMusicTrackAlt], a
	call Call_3B8D
	ret


Jump_18_61BE::
	ld a, [wDialogState]
	and a
	jr nz, jr_018_61da

	call GetEntityYDistanceToLink_18
	add $14
	cp $28
	jr nc, jr_018_61da

	ld a, $01
	ld [wLinkFrozen], a
	call GetEntityTimer
	ld [hl], $18
	call Call_3B8D

jr_018_61da:
	ret


Jump_18_61DB::
	ld a, [wDialogState]
	and a
	jr nz, jr_018_61fa

	call GetEntityTimer
	jr nz, jr_018_61ee

	ld a, $d5
	call OpenDialogTable1
	call Call_3B8D

jr_018_61ee:
	ld e, $02
	cp $0c
	jr c, jr_018_61f6

	ld e, $04

jr_018_61f6:
	ld a, e
	call Call_3B87

jr_018_61fa:
	ret


Jump_18_61FB::
	ld a, [wDialogState]
	and a
	jr nz, jr_018_622d

	call Call_3B8D
	ld a, [wDialogAnswer]
	and a
	jr nz, jr_018_6224

	ld [hl], $06
	xor a
	ld [wTransitionSequenceCounter], a
	ld [wTransitionFrameCounter], a
	ld [wActivePowerUp], a
	ld [wGameplaySubtype], a
	ld a, $09
	ld [wGameplayType], a
	ld a, $4e
	ld [wMusicTrackToPlay], a
	ret


jr_018_6224:
	xor a
	ld [wLinkFrozen], a
	ld a, $d6
	call OpenDialogTable1

jr_018_622d:
	ret


Jump_18_622E::
	ld a, [wDialogState]
	and a
	jr nz, jr_018_623c

	call GetEntityTimer
	ld [hl], $60
	call Call_3B8D

jr_018_623c:
	ret


Jump_18_623D::
	call GetEntityTimer
	jr nz, jr_018_6245

	call Call_3B8D

jr_018_6245:
	ld e, $00
	cp $54
	jr c, jr_018_624d

	ld e, $04

jr_018_624d:
	ld a, e
	call Call_3B87
	ret


Jump_18_6252::
	ret


	db $65, $64, $54, $52, $22, $22, $32, $37, $37, $37, $57, $56, $26, $21, $c4, $c5
	db $d5, $d4, $c4, $c5, $d5, $d5, $c5, $c4, $c4, $c5, $d5, $d4, $ab, $a9, $ac, $aa
	db $ab, $a9, $ab, $aa, $ac, $a9, $ab, $a9, $ac, $ae

Call_18_627D::
	call ReturnIfNonInteractive_18
	ldh a, [hMapRoom]
	cp $b4
	jr nz, jr_018_628d

	xor a
	ld [$d472], a
	ld [$d473], a

jr_018_628d:
	ld a, [$d473]
	and a
	jr z, jr_018_62df

	ld a, [$d472]
	ld e, a
	ld d, b
	ld hl, $6253
	add hl, de
	ld a, [$d473]
	cp [hl]
	jr nz, jr_018_62cf

	ld hl, $6261
	add hl, de
	ldh a, [hMapRoom]
	cp [hl]
	jr nz, jr_018_62cf

	xor a
	ld [$d473], a
	ld a, [$d472]
	inc a
	ld [$d472], a
	cp $0e
	jr nz, jr_018_62c7

	xor a
	ld [$d472], a
	ld a, $02
	ldh [hJingle], a
	push de
	call Call_18_62E0
	pop de

jr_018_62c7:
	ld hl, $626f
	add hl, de
	ld a, [hl]
	jp OpenDialogTable1


jr_018_62cf:
	xor a
	ld [$d472], a
	ld [$d473], a
	ld a, $1d
	ldh [hJingle], a
	ld a, $ad
	call OpenDialogTable1

jr_018_62df:
	ret


Call_18_62E0::
	ld hl, $d739
	ld [hl], $c6
	ld a, $28
	ld [wWarpDestPosition], a
	ld a, $20
	ldh [hBGPosY], a
	add $10
	ldh [hMultiPurpose1], a
	ld a, $80
	ldh [hBGPosX], a
	add $08
	ldh [hMultiPurpose0], a
	ld a, $02
	call AddTransientVfx
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
	ld a, $68
	ld [hli], a
	ld a, $77
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $69
	ld [hli], a
	ld a, $4b
	ld [hli], a
	ld [hl], $00
	ld a, $01
	ldh [hStairsState], a
	ldh a, [hBGPosY]
	and $f0
	add $10
	ldh [hStairsY], a
	ldh a, [hBGPosX]
	and $f0
	add $08
	ldh [hStairsX], a
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, wRoomStatus
	add hl, de
	set 4, [hl]
	ret


	db $10, $20, $30, $40, $50, $60, $70, $80, $18, $28, $38, $48, $58, $68, $78, $88

Call_18_6362::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_63e3

	call ReturnIfNonInteractive_18
	call GetEntityTimer
	jr nz, jr_018_63ce

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $635a
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, $6352
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	call Call_18_646E
	ldh a, [hMultiPurpose3]
	cp $00
	jr z, jr_018_63a0

	cp $06
	jr z, jr_018_63a0

	cp $09
	jr z, jr_018_63a0

	ret


jr_018_63a0:
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $40
	ld [hl], a
	ld a, $bf
	ld e, $05
	call Call_3C13
	jr c, jr_018_63ce

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
	ld hl, wEntityPhysicsFlags
	add hl, de
	res 6, [hl]

jr_018_63ce:
	ret


	db $ff, $ff, $ff, $ff, $6c, $00, $6c, $20, $68, $00, $6a, $00, $60, $00, $62, $00
	db $64, $00, $66, $00

Jump_018_63e3:
	ld de, $63cf
	call Call_3C3B
	call ReturnIfNonInteractive_18
	call ApplyRecoilIfNeeded_18
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_63F2::
	dw Jump_18_63FA
	dw Jump_18_6403
	dw Jump_18_6429
	dw Jump_18_645C

Jump_18_63FA::
	call GetEntityTimer
	ld [hl], $30
	call Call_3B8D
	ret


Jump_18_6403::
	call GetEntityTimer
	jr nz, jr_018_641d

	call GetRandomByte
	and $3f
	add $70
	ld [hl], a
	call GetRandomByte
	and $07
	add $05
	call Call_3C25
	call Call_3B8D

jr_018_641d:
	ld e, $01
	cp $18
	jr nc, jr_018_6424

	inc e

jr_018_6424:
	ld a, e
	call Call_3B87
	ret


Jump_18_6429::
	call UpdateEntityPosWithSpeed_18
	call Call_3B9E
	call Call_3BB4
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_018_6440

	call GetEntityTimer
	jr nz, jr_018_644e

jr_018_6440:
	call GetEntityTimer
	ld [hl], $30
	call Call_3B8D
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]

jr_018_644e:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	add $03
	call Call_3B87
	ret


Jump_18_645C::
	call GetEntityTimer
	jp z, ClearEntityStatus_18

	ld e, $01
	cp $18
	jr c, jr_018_6469

	inc e

jr_018_6469:
	ld a, e
	call Call_3B87
	ret


Call_18_646E::
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
	call GetObjectPhysics
	ldh [hMultiPurpose3], a
	ret


	db $ec, $14

Call_18_64A7::
	call Call_18_68C6
	ldh a, [hActiveEntityStatus]
	cp $01
	jp z, BossDeathSequence_18

	call ReturnIfNonInteractive_18
	call Call_3F12
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_64c5

	inc [hl]
	call GetEntityDropTimer
	ld [hl], $20

jr_018_64c5:
	call GetEntityTimer1
	jr z, jr_018_64e5

	ld a, [wLinkPushedTimer]
	and a
	cp $01
	jr nz, jr_018_64d7

	ld hl, hJingle
	ld [hl], $33

jr_018_64d7:
	and a
	jr nz, jr_018_64e5

	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld a, $6a
	ldh [hLinkAnimationState], a
	call Call_18_6990

jr_018_64e5:
	call ApplyRecoilIfNeeded_18
	call Call_3BE0
	ld a, [wLinkPushedTimer]
	and a
	jr nz, jr_018_64f4

	call Call_3BB4

jr_018_64f4:
	call UpdateEntityPosWithSpeed_18
	call Call_3B9E
	call UpdateEntityZWithSpeed_18
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
	and a
	jr z, jr_018_6519

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	call Call_3DAF

jr_018_6519:
	call Call_18_65AB
	call GetEntityXDistanceToLink_18
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	call GetEntityYDistanceToLink_18
	cp $00
	jr z, jr_018_6536

	ld d, b
	ld hl, $64a3
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_018_6536:
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_018_6563

	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
	call GetRandomByte
	and $0f
	sub $08
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call GetEntityXDistanceToLink_18
	add $28
	cp $50
	jr c, jr_018_6563

	ld a, $08
	call Call_3C30
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a

jr_018_6563:
	call Call_18_6572
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Call_18_6572::
	call GetEntityTimer1
	jr z, jr_018_657b

	ld a, $03
	jr jr_018_6594

jr_018_657b:
	call GetEntityDropTimer
	jr nz, jr_018_65aa

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, jr_018_658e

	inc [hl]
	ld a, $01
	jr jr_018_6594

jr_018_658e:
	call GetRandomByte
	and $03
	inc a

Jump_018_6594:
jr_018_6594:
	ld [wEvilEagleAttack], a
	cp $01
	jr nz, jr_018_659f

	ld a, $0a
	ldh [hNoiseSfx], a

jr_018_659f:
	call GetEntityTimer
	ld [hl], $00
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $00

jr_018_65aa:
	ret


Call_18_65AB::
	ld a, [wEvilEagleAttack]
	and a
	ret z

	pop de
	dec a
	rst $00

JumpTable_18_65B3::
	dw Jump_18_65C8
	dw Jump_18_661F
	dw Jump_18_66A9
	dw Jump_18_65C8

	db $01, $01, $01, $02, $02, $03, $03, $03, $03, $03, $02, $02, $01

Jump_18_65C8::
	call GetEntityTimer
	jr nz, jr_018_65e7

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $0d
	jp z, Jump_018_65e8

	inc [hl]
	ld e, a
	ld d, b
	ld hl, $65bb
	add hl, de
	ld a, [hl]
	call Call_3B87
	call GetEntityTimer
	ld [hl], $01

jr_018_65e7:
	ret


Jump_018_65e8:
	call GetRandomByte
	and $03
	jp z, Jump_018_6706

	ld a, $01
	jp Jump_018_6594


	db $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $07, $08, $08, $08
	db $08, $08, $07, $06, $01, $08, $10, $08, $08, $02, $00, $00, $00, $fc, $f8, $f0
	db $f8, $e0, $90, $a0, $00, $00, $00, $00, $00, $00

Jump_18_661F::
	call GetEntityTimer
	jr nz, jr_018_6654

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $15
	jp z, Jump_018_6706

	inc [hl]
	ld e, a
	ld d, b
	ld hl, $65f5
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $660a
	add hl, de
	ld e, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_664a

	ld a, e
	cpl
	inc a
	ld e, a

jr_018_664a:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	call GetEntityTimer
	ld [hl], $03

jr_018_6654:
	ret


	db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $09, $09, $0a, $0a, $0b, $0b, $0c, $0c
	db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $0d, $0e, $0f, $10, $11, $11, $11, $01, $0c, $0c, $0c, $0c, $0c, $0c
	db $0c, $0c, $08, $08, $08, $08, $08, $08, $08, $08, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $e0, $d0, $c0, $c0, $e0
	db $f0, $00, $00, $00

Jump_18_66A9::
	call GetEntityTimer
	jr nz, jr_018_6705

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $2a
	jp z, Jump_018_6706

	ld e, a
	cp $28
	jr nz, jr_018_66c4

	ld a, [wLinkMotionState]
	cp $0a
	jr z, jr_018_66c5

jr_018_66c4:
	inc [hl]

jr_018_66c5:
	ld d, b
	ld hl, $6655
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $667f
	add hl, de
	ld e, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_66df

	ld a, e
	cpl
	inc a
	ld e, a

jr_018_66df:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	call GetEntityTimer1
	jr z, jr_018_6700

	call GetEntityXDistanceToLink_18
	add $30
	cp $60
	jr c, jr_018_6700

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $18
	jr nc, jr_018_6700

	ld a, $10
	call Call_3C25

jr_018_6700:
	call GetEntityTimer
	ld [hl], $03

jr_018_6705:
	ret


Jump_018_6706:
	xor a
	ld [wEvilEagleAttack], a
	call GetEntityDropTimer
	call GetRandomByte
	and $0f
	add $0c
	ld [hl], a
	ret


	db $00, $f8, $6c, $00, $00, $00, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $ff, $f8, $6c, $00, $ff, $00, $6e, $00
	db $00, $00, $64, $00, $00, $08, $66, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $00, $f8, $6e, $20, $00, $00, $6c, $20, $00, $00, $60, $00, $00, $08, $62, $00
	db $fd, $f8, $6c, $00, $fd, $00, $6e, $00, $fd, $f0, $6c, $00, $fd, $f8, $6e, $00
	db $00, $f8, $6e, $20, $00, $00, $6c, $20, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $6e, $20, $00, $08, $6c, $20, $00, $00, $64, $00, $00, $08, $66, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $fd, $08, $6e, $20, $fd, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $00, $f8, $6c, $00, $00, $00, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $f0, $6c, $00, $00, $f8, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $e8, $6c, $00, $00, $f0, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $f8, $10, $6c, $00, $f8, $18, $6e, $00
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $f0, $08, $6c, $00, $f0, $10, $6e, $00, $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $fc, $08, $6e, $20, $fc, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $00, $10, $6e, $20, $00, $18, $6c, $20, $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $04, $08, $6e, $20, $04, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $08, $00, $6c, $00, $08, $08, $6e, $00, $00, $00, $64, $00, $00, $08, $66, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $08, $f8, $6c, $00, $08, $00, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $05, $f0, $6c, $00, $05, $f8, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $f4, $f0, $6e, $20, $f4, $f8, $6c, $20
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $00, $ff, $00, $00, $00, $ff, $00

Call_18_68C6::
	ld a, $80
	ld [$d5c0], a
	ld [$d5c2], a
	ldh a, [hActiveEntitySpriteVariant]
	sla a
	sla a
	ld d, b
	sla a
	ld e, a
	rl d
	sla a
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	xor a
	ldh [hBGTilesRequestCopy], a
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_68f7

	inc a
	ldh [hBGTilesRequestCopy], a
	ld hl, hActiveEntityFlipAttribute
	set 5, [hl]

jr_018_68f7:
	ld hl, $6716
	add hl, de
	ld c, $06
	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	pop hl
	ld a, c
	ldh [hMultiPurpose0], a
	ld a, [wActiveEntitySlot]
	ld c, a
	call Call_3D87
	ldh a, [hMultiPurpose0]
	ld c, a

jr_018_6918:
	ld a, [$d5c2]
	cp $80
	jr nz, jr_018_6925

	ld a, [hl]
	add $08
	ld [$d5c2], a

jr_018_6925:
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ld [de], a
	inc hl
	inc de
	push bc
	ld a, [wScreenShakeX]
	ld c, a
	ld b, [hl]
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_018_693c

	ld a, b
	cpl
	inc a
	add $08
	ld b, a

jr_018_693c:
	ld a, [$d5c0]
	cp $80
	jr nz, jr_018_694e

	ldh a, [hBGTilesRequestCopy]
	and a
	ld a, b
	jr nz, jr_018_694b

	add $08

jr_018_694b:
	ld [$d5c0], a

jr_018_694e:
	ldh a, [hActiveEntityX]
	add b
	sub c
	ld [de], a
	inc hl
	inc de
	pop bc
	ld a, [hli]
	ld [de], a
	cp $ff
	jr nz, jr_018_6960

	dec de
	xor a
	ld [de], a
	inc de

jr_018_6960:
	inc de
	ldh a, [hActiveEntityFlipAttribute]
	xor [hl]
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, jr_018_6918

	ld a, $08
	ld [$d5c1], a
	ld a, $04
	ld [$d5c3], a
	ld a, [wActiveEntitySlot]
	ld c, a
	ld a, $06
	call Call_3DD0
	jp Call_3D19


	db $00, $fe, $fd, $fe, $00, $02, $03, $02, $00, $04, $08, $0c, $10, $0c, $08, $04

Call_18_6990::
	ld hl, $c010
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	push af
	and $07
	call Call_18_69A3
	pop af
	add $04
	and $07

Call_18_69A3::
	push bc
	push hl
	ld e, a
	ld d, $00
	ld hl, $6980
	add hl, de
	ld b, [hl]
	ld hl, $6988
	add hl, de
	ld c, [hl]
	pop hl
	ldh a, [hLinkY]
	add b
	add $f6
	ld [hli], a
	ldh a, [hLinkX]
	add c
	add $fc
	ld [hli], a
	ld [hl], $24
	inc hl
	ld [hl], $00
	inc hl
	pop bc
	ret


Call_18_69C7::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_018_6eed

	and a
	jp nz, Jump_018_6f3e

	ldh a, [hActiveEntityStatus]
	cp $01
	jr nz, jr_018_6a3c

	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx
	ld a, $0c
	ldh [hBGTilesRequestCopy], a
	call Call_18_69FC
	ld a, $f4
	ldh [hBGTilesRequestCopy], a
	call Call_18_69FC
	call Call_3F88
	jp ClearEntityStatus_18


Call_18_69FC::
	ld a, $bd
	call Call_3C01
	jr c, jr_018_6a3b

	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	ld hl, wEntityLoadOrder
	add hl, de
	ld [hl], a
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
	ld [hl], $01
	ldh a, [hBGTilesRequestCopy]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $01

jr_018_6a3b:
	ret


jr_018_6a3c:
	call Call_18_6EC9
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	cp [hl]
	jr z, jr_018_6a56

	ldh a, [hActiveEntityX]
	cp $98
	jp nc, ClearEntityStatus_18

	ldh a, [hActiveEntityDrawY]
	cp $70
	jp nc, ClearEntityStatus_18

jr_018_6a56:
	call ReturnIfNonInteractive_18
	call ApplyRecoilIfNeeded_18
	call UpdateEntityPosWithSpeed_18
	call UpdateEntityZWithSpeed_18
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_6A65::
	dw Jump_18_6A75
	dw Jump_18_6A96
	dw Jump_18_6B68
	dw Jump_18_6BA9
	dw Jump_18_6CB9
	dw Jump_18_6CE5
	dw Jump_18_6D36
	dw Jump_18_6D4F

Jump_18_6A75::
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $03
	call GetEntityTimer
	ld [hl], $c0
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], $80
	call Call_3DAF
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
	jp Call_3B8D


	db $08, $f8, $08, $f8

Jump_18_6A96::
	call Call_18_6E08
	call GetEntityXDistanceToLink_18
	add $1c
	cp $38
	jr nc, jr_018_6acd

	call GetEntityDrawYDistanceToLink_18
	add $20
	cp $40
	jr nc, jr_018_6acd

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
	call Call_3B8D
	ld [hl], $03
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $ff

jr_018_6acd:
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_6ae0

	call Call_3B8D
	ld [hl], $02
	call GetEntityTimer
	ld [hl], $20
	ret


jr_018_6ae0:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub $28
	jr z, jr_018_6afb

	ld e, $08
	and $80
	jr nz, jr_018_6af6

	ld e, $f8

jr_018_6af6:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], e

jr_018_6afb:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_018_6b16

	ld e, a
	ld d, b
	ld hl, $6a93
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $00

jr_018_6b16:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $03
	jr z, jr_018_6b33

	ld e, a
	ld d, b
	ld hl, $6a91
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $00

jr_018_6b33:
	call GetEntityTimer
	jr nz, jr_018_6b46

	call GetRandomByte
	and $7f
	add $40
	ld [hl], a
	ld hl, wEntityTimer1
	add hl, bc
	ld [hl], $10

jr_018_6b46:
	ld hl, wEntityTimer1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6b5a

	cp $08
	jr nz, jr_018_6b55

	call Call_18_6D65

jr_018_6b55:
	ld a, $02
	jp Call_3B87


jr_018_6b5a:
	call Call_18_6E25

Jump_018_6b5d:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_18_6B68::
	call GetEntityTimer
	jr nz, jr_018_6ba0

	call Call_3B8D
	ld [hl], $03
	ldh a, [hLinkY]
	push af
	sub $14
	ldh [hLinkY], a
	ld a, $20
	call Call_3C25
	pop af
	ldh [hLinkY], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $ec
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], $30
	call GetRandomByte
	and $03
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	and a
	jr nz, jr_018_6b9f

	call GetEntityTimer
	ld [hl], $10

jr_018_6b9f:
	ret


jr_018_6ba0:
	call Call_18_6CA0
	ld a, $02
	call Call_3B87
	ret


Jump_18_6BA9::
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_018_6bf4

	call GetEntityXDistanceToLink_18
	add $18
	cp $30
	jr nc, jr_018_6bf4

	call GetEntityDrawYDistanceToLink_18
	add $18
	cp $30
	jr nc, jr_018_6bf4

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_6bf4

	ld a, [wSwordAnimationState]
	and a
	jr z, jr_018_6bf4

	ld a, $20
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
	call GetEntityTimer
	ld [hl], $0b
	call Call_3B8D
	ld [hl], $06
	ret


jr_018_6bf4:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_018_6c05

	and a
	jr nz, jr_018_6c30

	call GetEntityTimer
	jr nz, jr_018_6c30

jr_018_6c05:
	ld a, $20
	call Call_3C30
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_018_6c1b

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_018_6c1b:
	dec [hl]
	dec [hl]
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_018_6c2e

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_018_6c2e:
	dec [hl]
	dec [hl]

jr_018_6c30:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $40
	jr c, jr_018_6c45

	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_018_6c45

	ld [hl], b
	jr jr_018_6c55

jr_018_6c45:
	ld hl, wEntitySpeedZ
	add hl, bc
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_018_6c50

	inc [hl]

jr_018_6c50:
	ld a, [hl]
	and $80
	jr nz, Call_18_6C85

jr_018_6c55:
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6c6d

	ldh a, [hActiveEntityX]
	cp $a8
	jr nc, jr_018_6c6d

	ldh a, [hActiveEntityDrawY]
	cp $90
	jr c, Call_18_6C85

	cp $c0
	jr nc, Call_18_6C85

jr_018_6c6d:
	call Call_3B8D
	ld [hl], $04
	call Call_18_6CA0
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $20
	ld [hl], a
	ld a, $ff
	jp Call_3B87


Call_18_6C85::
	call Call_3BB4
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6c9a

	call Call_3DAF
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $ff
	ret


jr_018_6c9a:
	call Call_18_6E25
	jp Jump_018_6b5d


Call_18_6CA0::
	call Call_3DAF
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ret


	db $00, $00, $d0, $d0, $40, $40, $80, $80, $08, $98, $38, $78, $f8, $a8, $f8, $a8

Jump_18_6CB9::
	call GetEntityTimer
	jr nz, jr_018_6ce4

	ld hl, wEntityZ
	add hl, bc
	ld [hl], $28
	call Call_3B8D
	ld [hl], $05
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $6ca9
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ld hl, $6cb1
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a

jr_018_6ce4:
	ret


Jump_18_6CE5::
	ld a, $08
	call Call_3C25
	ldh a, [hActiveEntityX]
	cp $09
	jr c, jr_018_6d1f

	cp $97
	jr nc, jr_018_6d1f

	ldh a, [hActiveEntityDrawY]
	cp $20
	jr c, jr_018_6d1f

	cp $70
	jr nc, jr_018_6d1f

	call Call_3B8D
	ld [hl], $01
	ld hl, wEntityDropTimer
	add hl, bc
	call GetRandomByte
	and $3f
	add $20
	ld [hl], a
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

jr_018_6d1f:
	jp Jump_018_6b5d


	db $00, $09, $12, $15, $18, $15, $12, $09, $00, $f7, $ee, $eb, $e8, $eb, $ee, $f7
	db $00, $09, $12, $15

Jump_18_6D36::
	call GetEntityTimer
	jr nz, jr_018_6d45

	ld [hl], $20
	call Call_3B8D
	ld [hl], $07
	jp Call_18_6CA0


jr_018_6d45:
	cp $08
	jr c, jr_018_6d4c

	call Call_18_6C85

jr_018_6d4c:
	jp Jump_018_6b5d


Jump_18_6D4F::
	call GetEntityTimer
	jr nz, jr_018_6d60

	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $ff
	call Call_3B8D
	ld [hl], $03
	ret


jr_018_6d60:
	cp $08
	jp nz, Jump_018_6e03

Call_18_6D65::
	ld a, $0d
	ldh [hNoiseSfx], a
	ldh a, [hLinkY]
	push af
	sub $08
	ldh [hLinkY], a
	ld a, $1f
	call Call_3C30
	pop af
	ldh [hLinkY], a
	call Call_18_7B1B
	and $0f
	ldh [hBGTilesRequestCopy], a
	ld e, $00
	call Call_18_6D86
	ld e, $01

Call_18_6D86::
	ldh a, [hBGTilesRequestCopy]
	add e
	and $0f
	ldh [hBGTilesRequestCopy], a
	ld e, $0f
	ld d, b

jr_018_6d90:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_018_6dab

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $bd
	jr nz, jr_018_6dab

	ld hl, wEntityPrivate1
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_018_6dab

	inc b

jr_018_6dab:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_6d90

	ld a, b
	ld b, $00
	cp $03
	jr nc, jr_018_6e02

	ld a, $bd
	call Call_3C01
	jr c, jr_018_6e02

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	sub [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $02
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $4c
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, $6d26
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $6d22
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
	pop bc

jr_018_6e02:
	ret


Jump_018_6e03:
	ld a, $02
	jp Call_3B87


Call_18_6E08::
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $28
	ld [hl], a
	ldh a, [hActiveEntityY]
	sub $28
	ldh [hActiveEntityY], a
	call Call_3B9E
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $28
	ld [hl], a
	call Call_3DBA
	ret


Call_18_6E25::
	ld e, $0f

jr_018_6e27:
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_018_6e9e

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $03
	jr z, jr_018_6e42

	cp $00
	jr z, jr_018_6e42

	cp $02
	jr nz, jr_018_6e9e

jr_018_6e42:
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $18
	cp $30
	jr nc, jr_018_6e9e

	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $20
	cp $40
	jr nc, jr_018_6e9e

	ldh a, [hLinkY]
	push af
	ldh a, [hLinkX]
	push af
	ld a, [hl]
	ldh [hLinkY], a
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
	push de
	ld a, $20
	call Call_3C30
	pop de
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	jr nz, jr_018_6e7b

	ld a, $20

jr_018_6e7b:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	jr nz, jr_018_6e88

	ld a, $20

jr_018_6e88:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	pop af
	ldh [hLinkX], a
	pop af
	ldh [hLinkY], a
	call Call_3B8D
	ld [hl], $03
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $01

jr_018_6e9e:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_6e27

	ret


	db $00, $fc, $60, $00, $00, $04, $62, $00, $00, $0c, $60, $20, $00, $fc, $64, $00
	db $00, $04, $66, $00, $00, $0c, $64, $20, $00, $fc, $68, $00, $00, $04, $6a, $00
	db $00, $0c, $68, $20

Call_18_6EC9::
	ldh a, [hActiveEntitySpriteVariant]
	cp $ff
	ret z

	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $6ea5
	add hl, de
	ld c, $03
	call Call_3D26
	jp Call_3D19


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20

Jump_018_6eed:
	ld de, $6ee5
	call Call_3C3B
	call ReturnIfNonInteractive_18
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BEB
	call Call_3BBF
	jr c, jr_018_6f1f

	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6f22

	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx

jr_018_6f1f:
	jp ClearEntityStatus_18


jr_018_6f22:
	call UpdateEntityPosWithSpeed_18
	call GetEntityTimer
	ret nz

	call Call_3B9E
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jp nz, ClearEntityStatus_18

	ret


	db $6c, $00, $6c, $20, $6e, $00, $6e, $20

Jump_018_6f3e:
	ld de, $6f36
	call Call_3C3B
	call ReturnIfNonInteractive_18
	call ApplyRecoilIfNeeded_18
	call UpdateEntityPosWithSpeed_18
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_018_6f63

	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub $10
	jr z, jr_018_6f63

	and $80
	jr z, jr_018_6f62

	inc [hl]
	inc [hl]

jr_018_6f62:
	dec [hl]

jr_018_6f63:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_6F70::
	dw Jump_18_6F76
	dw Jump_18_6F84
	dw Jump_18_6F94

Jump_18_6F76::
	call GetEntityTimer
	jr nz, jr_018_6f83

	ld [hl], $20
	call Call_3DAF
	call Call_3B8D

jr_018_6f83:
	ret


Jump_18_6F84::
	call GetEntityTimer
	jr nz, jr_018_6f93

	ld [hl], $20
	ld a, $20
	call Call_3C25
	call Call_3B8D

jr_018_6f93:
	ret


Jump_18_6F94::
	call Call_3BB4
	call GetEntityTimer
	ret nz

	call Call_3B9E
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jp nz, ClearEntityStatus_18

	ret


Call_18_6FA8::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_7166

	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
	call Call_18_7144
	call Call_380E
	call Call_3F12
	call ReturnIfNonInteractive_18
	ld a, [wRoomEventDone]
	and a
	jr z, jr_018_6ffa

	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_6fda

	inc [hl]
	ld a, $25
	call OpenDialog
	jp MarkRoomEventDone_18


jr_018_6fda:
	cp $01
	jr nz, jr_018_6fe3

	ld a, $3f
	ldh [hNoiseSfx], a
	inc [hl]

jr_018_6fe3:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
	call UpdateEntityZWithSpeed_18
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $78
	ret c

	call SelectAreaMusicFar
	jp ClearEntityStatus_18


jr_018_6ffa:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_6FFD::
	dw Jump_18_700B
	dw Jump_18_7013
	dw Jump_18_702B
	dw Jump_18_7067
	dw Jump_18_70DC
	dw Jump_18_70F8
	dw Jump_18_710C

Jump_18_700B::
	ld a, $07
	ld [wEvilEagleAttack], a
	jp Call_3B8D


Jump_18_7013::
	call GetEntityTimer
	ld [hl], $80
	xor a
	ld [wSmasherBallSlot], a
	ld [wSmasherSlot], a
	ld a, [wEvilEagleAttack]
	inc a
	and $07
	ld [wEvilEagleAttack], a
	jp Call_3B8D


Jump_18_702B::
	call GetEntityTimer
	jr nz, jr_018_705a

	ld [hl], $ff
	ld hl, wEntityOptions1
	add hl, bc
	res 1, [hl]
	ld e, $0f
	ld d, b

jr_018_703b:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $bc
	jr nz, jr_018_7051

	ld hl, wEntityPrivate1
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_018_7051

	ld hl, wEntityStatus
	add hl, de
	ld [hl], b

jr_018_7051:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_703b

	jp Call_3B8D


jr_018_705a:
	ret


	db $78, $68, $58, $48, $38, $28, $00, $00, $00, $00, $00, $00

Jump_18_7067::
	call GetEntityTimer
	jr nz, jr_018_7076

	ld hl, wEntityOptions1
	add hl, bc
	set 1, [hl]
	call Call_3B8D
	xor a

jr_018_7076:
	and $1f
	jr nz, Call_18_70CF

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $06
	jr nc, Call_18_70CF

	ld a, $bc
	call Call_3C01
	jr c, Call_18_70CF

	ld a, $31
	ldh [hJingle], a
	ld hl, wEntityPrivateCounter
	add hl, bc
	push bc
	ld c, [hl]
	inc [hl]
	ld hl, $705b
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $7061
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityZ
	add hl, de
	ld [hl], $1c
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], c
	ld hl, wEntityOptions1
	add hl, de
	ld a, [hl]
	and $7b
	ld [hl], a
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $01
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityPhysicsFlags
	add hl, de
	set 6, [hl]
	pop bc

Call_18_70CF::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_18_70DC::
	ld a, [wSmasherBallSlot]
	cp $06
	jr nz, jr_018_70f4

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	xor a
	ld [wSmasherBallSlot], a
	call GetEntityTimer
	ld [hl], $40
	call Call_3B8D

jr_018_70f4:
	call Call_18_70CF
	ret


Jump_18_70F8::
	call GetEntityTimer
	jr nz, jr_018_710b

	ld a, $ff
	ld [wSmasherBallSlot], a
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], $40
	call Call_3B8D

jr_018_710b:
	ret


Jump_18_710C::
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7119

	call Call_3B8D
	ld [hl], $01

jr_018_7119:
	ld a, $02
	call Call_3B87
	ret


	db $c9, $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $00, $f8, $66
	db $00, $00, $00, $62, $00, $00, $08, $64, $00, $10, $00, $68, $00, $00, $00, $62
	db $00, $00, $08, $64, $00

Call_18_7144::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $7120
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $01
	jp Call_3DD0


	db $6e, $00, $6e, $20, $6e, $40, $6e, $60

Jump_018_7166:
	ld de, $715e
	call Call_3C3B
	call ReturnIfNonInteractive_18
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_7175::
	dw Jump_18_71DF
	dw Jump_18_724C
	dw Jump_18_7269
	dw Jump_18_728C
	dw Jump_18_72B9

	db $28, $38, $48, $58, $68, $78, $38, $68, $48, $58, $48, $58, $18, $88, $28, $78
	db $60, $40, $28, $78, $78, $28, $60, $40, $28, $78, $28, $78, $50, $50, $38, $68
	db $50, $50, $38, $68, $38, $68, $38, $68, $38, $68, $28, $78, $38, $48, $68, $58
	db $20, $30, $40, $40, $30, $20, $60, $60, $50, $70, $70, $50, $38, $38, $58, $58
	db $70, $70, $30, $30, $70, $70, $50, $50, $30, $70, $70, $30, $30, $70, $40, $60
	db $70, $30, $60, $40, $30, $30, $50, $50, $70, $70, $40, $40, $50, $40, $50, $40

Jump_18_71DF::
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, [wEvilEagleAttack]
	rla
	and $fe
	ld e, a
	rla
	and $fc
	add e
	ld hl, wEntityPrivateCounter
	add hl, bc
	add [hl]
	ld e, a
	ld d, b
	ld hl, $717f
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
	ld hl, $71af
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
	ldh a, [hFrameCounter]
	xor c
	and $03
	jr nz, jr_018_7211

	ld a, $10
	call Call_3C25

jr_018_7211:
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_018_7230

	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_018_7230

	ld hl, wSmasherBallSlot
	inc [hl]
	call Call_3B8D

jr_018_7230:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a

Call_18_7236::
	call UpdateEntityPosWithSpeed_18

Jump_018_7239:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $04, $0c, $14, $1c, $24, $2c, $34, $3c

Jump_18_724C::
	ld a, [wSmasherBallSlot]
	cp $ff
	jr nz, jr_018_7266

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7244
	add hl, de
	ld a, [hl]
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], a
	call Call_3B8D

jr_018_7266:
	jp Jump_018_7239


Jump_18_7269::
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7289

	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 6, [hl]
	ld a, $20
	call Call_3C25
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $f4
	ld a, $31
	ldh [hJingle], a
	call Call_3B8D

jr_018_7289:
	jp Jump_018_7239


Jump_18_728C::
	call Call_3BB4
	call Call_18_7236
	call UpdateEntityZWithSpeed_18
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_018_72a5

	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	cp $0c
	jr z, jr_018_72a5

	inc [hl]

jr_018_72a5:
	ldh a, [hActiveEntityDrawY]
	cp $88
	jr nc, jr_018_72b0

	ldh a, [hActiveEntityX]
	cp $a8
	ret c

jr_018_72b0:
	call Call_3B8D
	ld a, $ff
	call Call_3B87
	ret


Jump_18_72B9::
	ret


	db $7a, $10, $7e, $30, $7a, $30, $7e, $10, $7c, $10, $7c, $30

Call_18_72C6::
	ldh a, [hRoomStatus]
	and $20
	jp nz, ClearEntityStatus_18

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_72f5

	ld de, $72ba
	call Call_3CD0
	call ReturnIfNonInteractive_18
	call UpdateEntityPosWithSpeed_18
	call UpdateEntityZWithSpeed_18
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, ClearEntityStatus_18

	ret


jr_018_72f5:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7301

	ld a, $07
	ldh [hActiveEntitySpriteVariant], a

jr_018_7301:
	call Call_18_763B
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_018_7328

	ld a, [wSelectedSong]
	cp $02
	jr nz, jr_018_7328

	ld a, [wOcarinaSongState]
	and a
	jr z, jr_018_7328

	call Call_3B8D
	ld hl, wEntityOptions1
	add hl, bc
	set 7, [hl]
	set 2, [hl]
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $10
	ret


jr_018_7328:
	ldh a, [hActiveEntityStatus]
	cp $05
	jr z, jr_018_7343

	call BossDeathSequence_18
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7342

	ld hl, $d810
	set 5, [hl]
	ld a, $02
	ldh [hJingle], a

jr_018_7342:
	ret


jr_018_7343:
	call ReturnIfNonInteractive_18
	call DecrementEntityIgnoreHitsTimer
	call Call_3BEB
	ldh a, [hActiveEntityState]
	cp $05
	jr nc, jr_018_7357

	call PushLinkOutOfEntity_18
	jr jr_018_735a

jr_018_7357:
	call Call_3BBF

jr_018_735a:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_735D::
	dw Jump_18_7375
	dw Jump_18_7376
	dw Jump_18_7389
	dw Jump_18_73D3
	dw Jump_18_7442
	dw Jump_18_7464
	dw Jump_18_748F
	dw Jump_18_74A0
	dw Jump_18_74B7
	dw Jump_18_74EC
	dw Jump_18_7508
	dw Jump_18_751C

Jump_18_7375::
	ret


Jump_18_7376::
	call GetEntityTimer
	ld [hl], $80
	ld a, $39
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrack], a
	ldh [hDefaultMusicTrackAlt], a
	ldh [hLastMusicTrack], a
	jp Call_3B8D


Jump_18_7389::
	ldh a, [hActiveEntityX]
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], a
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate3
	add hl, bc
	sub $14
	ld [hl], a
	call GetEntityTimer
	jr nz, jr_018_73a4

	ld [hl], $ff
	call Call_3B8D
	ret


jr_018_73a4:
	ld e, $08
	and $04
	jr z, jr_018_73ac

	ld e, $f8

jr_018_73ac:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	call UpdateEntityXWithSpeed_18
	ret


	db $f8, $08, $10, $00, $00, $08, $f0, $00, $f0, $00, $f0, $f0, $f8, $08, $08, $f8
	db $f8, $08, $fc, $02, $fc, $02, $fc, $fc, $10, $10, $10, $10, $10, $10

Jump_18_73D3::
	call GetEntityTimer
	jr nz, jr_018_73de

	ld [hl], $80
	call Call_3B8D
	ret


jr_018_73de:
	and $1f
	jr nz, jr_018_7441

	ldh a, [hActiveEntitySpriteVariant]
	cp $06
	jr z, jr_018_7436

	ld a, $13
	ldh [hNoiseSfx], a
	ld a, $7f
	call Call_3C01
	push bc
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
	ld hl, $73b5
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $73bb
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, $73c1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $73c7
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	ld hl, $73cd
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], a
	pop bc

jr_018_7436:
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	cp $07
	jr z, jr_018_7441

	inc a
	ld [hl], a

jr_018_7441:
	ret


Jump_18_7442::
	call GetEntityTimer
	jr nz, jr_018_744c

	ld [hl], $80
	jp Call_3B8D


jr_018_744c:
	ld e, $07
	cp $60
	jr nc, jr_018_745e

	cp $40
	jr nc, jr_018_745f

	cp $30
	jr c, jr_018_745e

	cp $20
	jr c, jr_018_745f

jr_018_745e:
	inc e

jr_018_745f:
	ld a, e
	call Call_3B87
	ret


Jump_18_7464::
	call GetEntityTimer
	jr nz, jr_018_7485

	ld [hl], $40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
	call Call_3B8D
	ldh a, [hActiveEntityX]
	ld [wSmasherBallSlot], a
	ldh a, [hActiveEntityDrawY]
	ld [wSmasherSlot], a
	ret


jr_018_7485:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $04
	call UpdateEntityYWithSpeed_18
	ret


Jump_18_748F::
	call GetEntityTimer
	jr nz, jr_018_749f

	ld [hl], $20
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
	call Call_3B8D

jr_018_749f:
	ret


Jump_18_74A0::
	call GetEntityTimer
	jr nz, jr_018_74b3

	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $08
	ld [hl], a
	call Call_3B8D

jr_018_74b3:
	call UpdateEntityXWithSpeed_18
	ret


Jump_18_74B7::
	call GetEntityTimer
	jr nz, jr_018_74eb

	ld hl, wEntityPrivate5
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr c, jr_018_74d9

	call GetRandomByte
	and $01
	jr nz, jr_018_74d9

	call Call_3B8D
	ld a, $09
	ld [hl], a
	call GetEntityTimer
	ld [hl], $20
	ret


jr_018_74d9:
	call GetEntityTimer
	ld [hl], $40
	call Call_3B8D
	dec [hl]
	dec [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_018_74eb:
	ret


Jump_18_74EC::
	call GetEntityTimer
	jr nz, jr_018_7507

	ld [hl], $20
	ld a, $18
	call Call_3C25
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	bit 7, [hl]
	jr z, jr_018_7504

	cpl
	inc a
	ld [hl], a

jr_018_7504:
	call Call_3B8D

jr_018_7507:
	ret


Jump_18_7508::
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7515

	call GetEntityTimer
	jr nz, jr_018_7518

jr_018_7515:
	call Call_3B8D

jr_018_7518:
	call UpdateEntityPosWithSpeed_18
	ret


Jump_18_751C::
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
	ld a, [wSmasherBallSlot]
	ldh [hLinkX], a
	ld a, [wSmasherSlot]
	ldh [hLinkY], a
	ld a, $08
	call Call_3C25
	ld a, [wSmasherBallSlot]
	ld hl, hActiveEntityX
	sub [hl]
	add $01
	cp $02
	jr nc, jr_018_7555

	ld a, [wSmasherSlot]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $01
	cp $02
	jr nc, jr_018_7555

	call Call_3B8D
	ld [hl], $06
	call GetEntityTimer
	ld [hl], $20

jr_018_7555:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call UpdateEntityPosWithSpeed_18
	ret


	db $f0, $f8, $7a, $10, $f0, $00, $7c, $10, $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $7e, $30, $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $7a, $30, $00, $00, $7e, $10, $00, $08, $7e, $30
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10, $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $74, $20, $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $70, $20, $00, $00, $7e, $10, $00, $08, $74, $20
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10, $f0, $08, $7c, $30, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20, $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $7c, $30, $f0, $10, $70, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $f0, $f8, $70, $00, $f0, $00, $78, $00, $f0, $08, $78, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20, $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $70, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $f0, $f8, $70, $00, $f0, $00, $72, $00, $f0, $08, $72, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20, $76, $00, $76, $20

Call_18_763B::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	add e
	ld e, a
	ld d, b
	ld hl, $755f
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ldh a, [hActiveEntityStatus]
	cp $01
	jr z, jr_018_7662

	ldh a, [hActiveEntityState]
	cp $05
	jp c, Jump_018_76f7

jr_018_7662:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
	ldh a, [hActiveEntityX]
	sub [hl]
	sra a
	ldh [hMultiPurposeA], a
	sra a
	ldh [hMultiPurposeB], a
	sra a
	ldh [hMultiPurposeC], a
	sra a
	ldh [hMultiPurposeD], a
	sra a
	ldh [hMultiPurposeE], a
	sra a
	ldh [hMultiPurposeF], a
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
	ldh a, [hActiveEntityDrawY]
	sub $20
	cp [hl]
	jr c, jr_018_76f7

	ldh [hActiveEntityDrawY], a
	xor a
	ldh [hActiveEntitySpriteVariant], a
	ld hl, hMultiPurposeA

jr_018_769a:
	ldh a, [hBGTilesRequestCopy]
	add [hl]
	ldh [hActiveEntityX], a
	inc hl
	push hl
	ld de, $7637
	call Call_3C3B
	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_018_76e8

	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_018_76e8

	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	ld e, a
	add $0c
	cp $18
	jr nc, jr_018_76e8

	ld a, e
	ld e, $20
	and $80
	jr z, jr_018_76cf

	ld e, $e0

jr_018_76cf:
	ld a, e
	ldh [hLinkSpeedX], a
	xor a
	ldh [hLinkSpeedY], a
	ld a, $18
	ld [wLinkPushedTimer], a
	ld a, $10
	ld [wInvincibilityCounter], a
	ld a, $08
	ld [wSubtractHealthBuffer], a
	ld a, $03
	ldh [hWaveSfx], a

jr_018_76e8:
	pop hl
	ldh a, [hMultiPurposeH]
	ld e, a
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
	sub e
	and $80
	jr z, jr_018_769a

Jump_018_76f7:
jr_018_76f7:
	call Call_3DBA
	ret


	db $62, $00, $64, $00, $60, $00, $60, $20, $64, $20, $62, $20, $66, $00, $68, $00
	db $60, $00, $60, $20, $68, $20, $66, $20, $6c, $00, $6e, $00, $6a, $00, $6a, $20
	db $6e, $20, $6c, $20, $00, $01, $02, $01, $03, $04, $05, $04, $06, $07, $08, $07

Call_18_772B::
	ld de, $76fb
	call Call_3C3B
	call ReturnIfNonInteractive_18
	call ApplyRecoilIfNeeded_18
	call Call_3BB4
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_773D::
	dw Jump_18_774B
	dw Jump_18_77A5

	db $fa, $fc, $00, $04, $06, $04, $00, $fc, $fa, $fc

Jump_18_774B::
	call GetEntityTimer
	jr nz, jr_018_7770

	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $7743
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $7741
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_018_7770:
	call UpdateEntityPosWithSpeed_18
	call Call_3B9E
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, $771f
	and a
	jr z, Call_18_7796

	call CheckLinkCanTalk_18
	jr nc, jr_018_7793

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and $03
	add $7c
	inc [hl]
	call OpenDialogTable2

jr_018_7793:
	ld hl, $7727

Call_18_7796::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_18_77A5::
	call GetEntityTimer
	jr nz, jr_018_77af

	call Call_3B8D
	ld [hl], b
	ret


jr_018_77af:
	ld hl, $7723
	call Call_18_7796
	ret


	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $70, $20, $00, $fc, $74, $00
	db $00, $04, $72, $00, $00, $0c, $74, $20, $00, $fc, $76, $00, $00, $04, $72, $00
	db $00, $0c, $76, $20, $00, $fc, $74, $00, $00, $04, $72, $00, $00, $0c, $74, $20
	db $10, $11, $12, $11

Call_18_77EA::
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
	ld hl, $77b6
	add hl, de
	ld c, $03
	call Call_3D26
	call ReturnIfNonInteractive_18
	call Call_3D19
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $77e6
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
	call ApplyRecoilIfNeeded_18
	call UpdateEntityPosWithSpeed_18
	call Call_3B9E
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_18_7828::
	dw Jump_18_7838
	dw Jump_18_790B
	dw Jump_18_791C

	db $f8, $fa, $00, $06, $08, $06, $00, $fa, $f8, $fa

Jump_18_7838::
	call GetEntityTimer
	jr nz, jr_018_786f

	call GetRandomByte
	and $1f
	add $20
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $7830
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $782e
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $07
	jr nz, jr_018_786c

	ld a, $0a
	call Call_3C25

jr_018_786c:
	call Call_3B8D

Jump_018_786f:
jr_018_786f:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $7f
	jr nz, jr_018_78ba

	ld a, $02
	call Call_3C01
	jr c, jr_018_78ba

	ld hl, wEntityOptions1
	add hl, de
	res 0, [hl]
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
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $08
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
	push bc
	push de
	pop bc
	ld a, $10
	call Call_3C25
	pop bc
	ld a, $08
	ldh [hJingle], a

jr_018_78ba:
	call GetEntityDirectionToLink_18
	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, jr_018_78fe

	call GetEntityXDistanceToLink_18
	add $20
	cp $40
	jr nc, jr_018_78fe

	call GetEntityDrawYDistanceToLink_18
	add $20
	cp $40
	jr nc, jr_018_78fe

	ld a, [wSwordAnimationState]
	and a
	jr z, jr_018_78fe

	call Call_3B8D
	ld [hl], $02
	call GetEntityTimer
	ld [hl], $12
	ld a, $20
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
	ret


jr_018_78fe:
	call Call_3BB4

Jump_018_7901:
	ldh a, [hFrameCounter]
	rra
	rra
	and $03
	call Call_3B87
	ret


Jump_18_790B::
	call GetEntityTimer
	jr nz, jr_018_7919

	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	call Call_3DAF

jr_018_7919:
	jp Jump_018_786f


Jump_18_791C::
	call GetEntityTimer
	jr nz, jr_018_7925

	call Call_3B8D
	ld [hl], b

jr_018_7925:
	jp Jump_018_7901


	db $6c, $74, $6d, $75, $64, $74, $65, $75

Call_18_7930::
	call Call_18_7A8A
	call ReturnIfNonInteractive_18
	ldh a, [hActiveEntityState]
	and a
	jp nz, Jump_018_7a02

	call GetEntityTimer
	jp z, Jump_018_79eb

	cp $07
	jp nz, Jump_018_79ee

	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $07
	sub $08
	and $f0
	ldh [hBGPosX], a
	swap a
	ld hl, wEntityY
	add hl, bc
	ld c, a
	ld a, [hl]
	add $07
	sub $10
	and $f0
	ldh [hBGPosY], a
	or c
	ld c, a
	ld b, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	push bc
	pop de
	ld h, a
	pop bc
	ld a, [hl]
	ldh [hRoomObjectType], a
	cp $d3
	jr z, jr_018_797d

	cp $5c
	jr nz, jr_018_7999

jr_018_797d:
	ld a, [wIsIndoor]
	and a
	jr nz, jr_018_7999

	call RemoveRoomObject
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx
	ld a, $2f
	ldh [hJingle], a
	jr jr_018_79eb

jr_018_7999:
	ld a, [wIsIndoor]
	and a
	jp z, Jump_018_79ee

	ldh a, [hRoomObjectType]
	cp $ab
	jr nz, jr_018_7a01

	ld [hl], $ac
	ld d, h
	ld e, l
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], d
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], e
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
	call GetEntityDropTimer
	ld [hl], $80
	ld hl, wEntityX
	add hl, bc
	ldh a, [hBGPosX]
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	ldh a, [hBGPosY]
	ld [hl], a
	ld hl, $c1a2
	inc [hl]
	ld a, [$c3cd]
	and a
	jr z, jr_018_79dc

	sub $04
	ld [$c3cd], a

jr_018_79dc:
	call GetEntityTimer
	ld [hl], b
	ld a, $12
	ldh [hNoiseSfx], a
	ld de, $7928
	push de
	jp Jump_018_7aa7


Jump_018_79eb:
jr_018_79eb:
	jp ClearEntityStatus_18


Jump_018_79ee:
	cp $10
	jr nc, jr_018_7a01

	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ld a, $09
	ld [wProjectileWeaponType], a
	call Call_3BF6

jr_018_7a01:
	ret


Jump_018_7a02:
	call GetEntityDropTimer
	jr nz, jr_018_7a41

	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hBGPosX], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hBGPosY], a
	ld hl, wEntityPrivate1
	add hl, bc
	ld d, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld a, $ab
	ld [de], a
	call ClearEntityStatus_18
	ldh a, [hMapRoom]
	cp $74
	ret z

	ld hl, $c1a2
	dec [hl]
	ld a, [$c3cd]
	cp $0c
	jr nc, jr_018_7a3a

	add $04
	ld [$c3cd], a

jr_018_7a3a:
	ld de, $792c
	push de
	jp Jump_018_7aa7


jr_018_7a41:
	ret


	db $06, $fe, $24, $00, $03, $04, $24, $10, $05, $0a, $24, $00, $05, $fe, $24, $10
	db $02, $04, $24, $00, $04, $0a, $24, $10, $03, $ff, $24, $00, $01, $04, $24, $10
	db $02, $09, $24, $00, $01, $00, $24, $10, $ff, $04, $24, $00, $00, $06, $24, $10
	db $00, $01, $24, $00, $fe, $03, $24, $10, $ff, $05, $24, $00, $ff, $01, $24, $10
	db $fd, $03, $24, $00, $fe, $05, $24, $10

Call_18_7A8A::
	call GetEntityTimer
	jr z, jr_018_7aa6

	rra
	rra
	and $07
	sla a
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $7a42
	add hl, de
	ld c, $03
	call Call_3D26

jr_018_7aa6:
	ret


Jump_018_7aa7:
	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0a
	ld [wDrawCommandsSize], a
	pop de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	xor a
	ld [hl], a
	ret


	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

Call_18_7B1B::
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
	jr z, jr_018_7b36

	cpl
	inc a

jr_018_7b36:
	ld d, a
	ldh a, [hMultiPurpose0]
	bit 7, a
	jr z, jr_018_7b3f

	cpl
	inc a

jr_018_7b3f:
	cp d
	jr nc, jr_018_7b4f

	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $7adb
	add hl, de
	ld a, [hl]
	ret


jr_018_7b4f:
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $7afb
	add hl, de
	ld a, [hl]
	ret


	db $11, $10, $0f, $0e

Call_18_7B61::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wHookshotInUse], a
	ld [$c1c6], a
	ld a, c
	inc a
	ld [wHookshotChainSlot], a
	xor a
	call ResetSpinAttackAndDash
	ld [wLinkPushedTimer], a
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $7b5d
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
	call Call_18_7C40
	call ReturnIfNonInteractive_18
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_018_7b93

	ld a, $0b
	ldh [hNoiseSfx], a

jr_018_7b93:
	ldh a, [hActiveEntityState]
	and a
	jr z, jr_018_7bb0

	ld a, $30
	call Call_3C30
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ldh [hLinkSpeedX], a
	push bc
	call ApplyLinkSpeed
	pop bc
	jr jr_018_7bbd

jr_018_7bb0:
	call UpdateEntityPosWithSpeed_18
	call GetEntityTimer
	jr nz, jr_018_7bcb

	ld a, $30
	call Call_3C25

jr_018_7bbd:
	call Call_3BD5
	jr nc, jr_018_7c25

	xor a
	ld [$c1c6], a
	call ClearEntityStatus_18
	jr jr_018_7c25

jr_018_7bcb:
	ld a, $06
	ld [wProjectileWeaponType], a
	call Call_3BF6
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7c26

	call Call_3B9E
	ld a, [wIsIndoor]
	and a
	jr z, jr_018_7c25

	call Call_18_646E
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7c25

	ld e, $9e
	bit 7, a
	jr nz, jr_018_7bf7

	ld e, $9f

jr_018_7bf7:
	ldh a, [hRoomObjectType]
	cp e
	jr nz, jr_018_7c25

	ld a, $68
	call Call_3C01
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
	ldh a, [hRoomObjectType]
	cp $9e
	ld a, $00
	jr z, jr_018_7c1c

	inc a

jr_018_7c1c:
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	call GetEntityTimer
	ld [hl], b

jr_018_7c25:
	ret


jr_018_7c26:
	call GetEntityTimer
	ld [hl], b
	ld a, $07
	ldh [hJingle], a
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $05
	call AddTransientVfx
	ret


	db $36, $00, $36, $20

Call_18_7C40::
	ld de, $7c3c
	call Call_3C3B
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	sra a
	sra a
	ldh [hMultiPurpose0], a
	ldh [hMultiPurpose2], a
	ldh a, [hActiveEntityY]
	ld hl, hLinkY
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
	ld a, $03

jr_018_7c70:
	ldh [hMultiPurpose4], a
	ld hl, hFrameCounter
	xor [hl]
	and $01
	jr nz, jr_018_7c81

	ldh a, [hLinkY]
	ld hl, hMultiPurpose1
	add [hl]
	ld [de], a

jr_018_7c81:
	inc de
	ldh a, [hLinkX]
	ld hl, hMultiPurpose0
	add [hl]
	add $04
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
	jr nz, jr_018_7c70

	ld a, $03
	call Call_3DD0
	ret


;@ def PushLinkOutOfEntity_18(slot: c) -> carry
;@ path: entity/helpers
;@ Makes the entity solid: when Link touches it, Link is put back where he stood last frame
;@ (StopLinkAtEntity_18) and carry is returned; otherwise no carry.
;@ test: skip calls the bank 3 collision check
PushLinkOutOfEntity_18::
;> if not Call_3BD5():            # Link's hitbox does not touch the entity
	call Call_3BD5
;>     return False
	jr nc, StopLinkAtEntity_18.notTouching
;> return StopLinkAtEntity_18()   # falls through

;@ def StopLinkAtEntity_18() -> carry
;@ path: entity/helpers
;@ Link bumped into a solid character: he goes back to his position of the last frame, a Pegasus
;@ Boots dash stops, and a hookshot chain that is out (entity type 3) is reset to its first state.
;@ Always returns carry.
;@ test: skip calls bank 0 routines with their own state
StopLinkAtEntity_18::
;> RestoreLinkPosition()                    # Link back to his previous position
	call RestoreLinkPosition
;> ResetPegasusBoots()                    # stop a dash
	call ResetPegasusBoots
;> chain = wHookshotChainSlot     # slot + 1, 0 = none
	ld a, [wHookshotChainSlot]
	and a
;> if chain:
	jr z, .touching

;>     chain_type = wEntityType[chain - 1]
	ld e, a
	ld d, b
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
;>     if chain_type == 3:
	cp $03
	jr nz, .touching

;>         wEntityState[chain - 1] = 0
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00
;> return True
.touching
	scf
	ret

;>@nt return False
.notTouching
;=@nt
	and a
	ret


;@ path: entity/helpers
;@ First sprite variant of a two-frame walking animation for each facing direction
;@ (index wEntityDirection: 0 right, 1 left, 2 up, 3 down). One byte each: 6, 4, 2, 0.
;@ Read by AnimateEntityByDirection_18.
DirectionSpriteVariants_18::
	db $06, $04, $02, $00

;@ def AnimateEntityByDirection_18(slot: c)
;@ path: entity/helpers
;@ Walking animation of a character: the sprite variant is the first frame of its facing direction
;@ (DirectionSpriteVariants_18) plus 0 or 1, switching every 16 frames of its own counter.
;@ test: c = rand(0, 15); wEntityDirection[c] = rand(0, 3)
AnimateEntityByDirection_18::
;> dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;> base = DirectionSpriteVariants_18[dir]
	ld hl, DirectionSpriteVariants_18
	add hl, de
	push hl
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> step = wEntityPrivateCounter[slot] >> 4
	ld a, [hl]
	rra
	rra
	rra
	rra
;> Call_3B87(base | (step & 1))   # set the sprite variant
	pop hl
	and $01
	or [hl]
	jp Call_3B87


;@ def CheckLinkCanTalkTall_18() -> carry
;@ path: entity/helpers
;@ Talk check for a tall character: Link from 24 pixels above to 31 below the entity, then
;@ CheckLinkCanTalkX_18. Carry = Link starts talking to it this frame.
;@ test: skip reads the joypad and the dialogue state together
CheckLinkCanTalkTall_18::
;> e = 0
	ld e, b
;> near = (hLinkY - hActiveEntityY + 0x18) & 0xFF < 0x38
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $18
	cp $38
;> return CheckLinkCanTalkX_18(near)
	jr CheckLinkCanTalkX_18

;@ def CheckLinkCanTalkLow_18(e: e) -> carry
;@ path: entity/helpers
;@ Talk check with a tall window reaching further below: Link from 20 pixels above to 35 below
;@ the entity, then CheckLinkCanTalkX_18.
;@ test: skip reads the joypad and the dialogue state together
CheckLinkCanTalkLow_18::
;> near = (hLinkY - hActiveEntityY + 0x14) & 0xFF < 0x38
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $38
;> return CheckLinkCanTalkX_18(near)
	jr CheckLinkCanTalkX_18

;@ def CheckLinkCanTalk_18() -> carry
;@ path: entity/helpers
;@ Talk check for a normal 16-pixel character: Link from 20 pixels above to 19 below the entity,
;@ then CheckLinkCanTalkX_18.
;@ test: skip reads the joypad and the dialogue state together
CheckLinkCanTalk_18::
;> e = 0
	ld e, b
;> near = (hLinkY - hActiveEntityY + 0x14) & 0xFF < 0x28
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28
;> return CheckLinkCanTalkX_18(near)  # falls through

;@ def CheckLinkCanTalkX_18(near: carry) -> carry
;@ path: entity/helpers
;@ Second half of the talk checks: when Link is vertically near (carry in), within 16 pixels
;@ horizontally and facing the entity (any facing for entity type $C4), marks wCanTalkToEntity
;@ (so the A button talks instead of using an item) and returns carry when A was just pressed
;@ while no dialogue, inventory, jump or dialogue cooldown is active and the window is hidden.
;@ test: skip reads the joypad and the dialogue state together
CheckLinkCanTalkX_18::
;> if not near:
;>     return False
	jr nc, .no

;> if (hLinkX - hActiveEntityX + 0x10) & 0xFF >= 0x20:
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
;>     return False
	jr nc, .no

;> e += 1
	inc e
;> if hActiveEntityType != 0xC4:
	ldh a, [hActiveEntityType]
	cp $c4
	jr z, .facing

;>     toward = GetEntityDirectionToLink_18()
	push de
	call GetEntityDirectionToLink_18
;>     if hLinkDirection ^ 1 != toward:   # Link must face the entity
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
;>         return False
	jr nz, .no

;> wCanTalkToEntity = 1
.facing
	ld hl, wCanTalkToEntity
	ld [hl], $01
;> busy = wDialogState | wInventoryAppearing
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
;> busy |= wIsLinkInTheAir | wDialogCooldown
	ld hl, wIsLinkInTheAir
	or [hl]
	ld hl, wDialogCooldown
	or [hl]
;> if busy:
;>     return False
	jr nz, .no

;> if wWindowY != 0x80:           # the window (inventory / box) is on screen
	ld a, [wWindowY]
	cp $80
;>     return False
	jr nz, .no

;> if hJoypadPressed & 0x10:      # A pressed
	ldh a, [hJoypadPressed]
	and $10
	jr z, .no

;>     return True
	scf
	ret

;> return False
.no
	and a
	ret


;@ def ReturnIfNonInteractive_18()
;@ path: entity/helpers
;@ Called at the start of an entity's update: unless the entity is active (status 5) and the
;@ game runs normally (ReturnIfPaused_18), it drops its caller's return address, so the handler
;@ ends for this frame.
;@ test: skip returns from its caller (pops the return address)
ReturnIfNonInteractive_18::
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return_from_caller()      # pops the caller's return address
	jr nz, ReturnIfPaused_18.exitCaller
;> ReturnIfPaused_18()           # falls through

;@ def ReturnIfPaused_18()
;@ path: entity/helpers
;@ Ends the calling handler for this frame (drops its return address) while the map screen is up
;@ (game mode 7), a dialogue box is open, the inventory slides in or out, or the room scrolls to
;@ the next one.
;@ test: skip returns from its caller (pops the return address)
ReturnIfPaused_18::
;> if wGameplayType == 7:
	ld a, [wGameplayType]
	cp $07
;>@exit     return_from_caller()   # pops the caller's return address
	jr z, .exitCaller

;> if mem[0xC1A8] or wDialogState or wInventoryAppearing:
	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
;>     return_from_caller()
	jr nz, .exitCaller

;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return_from_caller()
	jr z, .done

.exitCaller
;=@exit
	pop af
.done
;> return
	ret


;@ def ApplyRecoilIfNeeded_18(slot: c)
;@ path: entity/helpers
;@ While the entity's knockback timer runs, moves it one step with its knockback speed instead of
;@ its own speed (stopping at walls unless option bit 5 says otherwise) and ends the calling
;@ handler for this frame.
;@ test: skip returns from its caller (pops the return address)
ApplyRecoilIfNeeded_18::
;> if wEntityIgnoreHitsTimer[slot] == 0:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, .done

;> wEntityIgnoreHitsTimer[slot] -= 1
	dec a
	ld [hl], a
;> Call_3EB8()
	call Call_3EB8
;> speed_x = wEntitySpeedX[slot]
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
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore

;>     Call_3B9E()               # stop at walls
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


;@ def UpdateEntityPosWithSpeed_18(slot: c)
;@ path: entity/helpers
;@ Moves the entity by its speed: x by wEntitySpeedX, then y by wEntitySpeedY (the y arrays lie
;@ 16 bytes after the x arrays, so the same routine runs with slot + 16).
;@ test: c = rand(0, 15)
UpdateEntityPosWithSpeed_18::
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> UpdateEntityYWithSpeed_18(slot)   # falls through

;@ def UpdateEntityYWithSpeed_18(slot: c)
;@ path: entity/helpers
;@ Moves the entity vertically by wEntitySpeedY (UpdateEntityXWithSpeed_18 on slot + 16, where
;@ the y arrays lie).
;@ test: c = rand(0, 15)
UpdateEntityYWithSpeed_18::
;> UpdateEntityXWithSpeed_18(slot + 16)
	push bc
	ld a, c
	add $10
	ld c, a
	call UpdateEntityXWithSpeed_18
;> return
	pop bc
	ret


;@ def UpdateEntityXWithSpeed_18(slot: c)
;@ path: entity/helpers
;@ Adds the entity's x speed to its x position. The speed is signed in 1/16 pixels per frame:
;@ the low nibble goes into the fraction byte wEntitySpeedXAcc (its carry counts as one more
;@ pixel), the high nibble (sign-extended) is added to wEntityX.
;@ test: c = rand(0, 31)
UpdateEntityXWithSpeed_18::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
;> if speed == 0:
;>     return
	jr z, .done

;> acc = wEntitySpeedXAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
;> wEntitySpeedXAcc[slot] = acc & 0xFF
	add [hl]
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
;> wEntityX[slot] = (wEntityX[slot] + ((speed >> 4) | sign) + (acc >> 8)) & 0xFF
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

;> return
.done
	ret


;@ def UpdateEntityZWithSpeed_18(slot: c)
;@ path: entity/helpers
;@ Adds the entity's height speed wEntitySpeedZ to its height wEntityZ, the same way as
;@ UpdateEntityXWithSpeed_18 (1/16 pixels, fraction in wEntitySpeedZAcc).
;@ test: c = rand(0, 15)
UpdateEntityZWithSpeed_18::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and a
;> if speed == 0:
;>     return
	jr z, UpdateEntityXWithSpeed_18.done

;> acc = wEntitySpeedZAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
;> wEntitySpeedZAcc[slot] = acc & 0xFF
	add [hl]
	ld [hl], a
	rl d
;> sign = 0xF0 if speed & 0x80 else 0
;> wEntityZ[slot] = (wEntityZ[slot] + ((speed >> 4) | sign) + (acc >> 8)) & 0xFF
	ld hl, wEntityZ
	jr UpdateEntityXWithSpeed_18.addWhole

;@ def GetEntityXDistanceToLink_18(slot: c) -> (e, d)
;@ path: entity/helpers
;@ Horizontal distance from the entity to Link: d = hLinkX - wEntityX (signed), e = the direction
;@ in which Link is (0 right, 1 left).
;@ test: c = rand(0, 15)
GetEntityXDistanceToLink_18::
;> e = 0
	ld e, $00
;> d = (hLinkX - wEntityX[slot]) & 0xFF
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if d & 0x80:                   # Link is to the left
	bit 7, a
	jr z, .done

;>     e = 1
	inc e

.done
	ld d, a
;> return e, d
	ret


;@ def GetEntityYDistanceToLink_18(slot: c) -> (e, d)
;@ path: entity/helpers
;@ Vertical distance from the entity to Link: d = hLinkY - wEntityY (signed), e = the direction
;@ in which Link is (2 up, 3 down).
;@ test: c = rand(0, 15)
GetEntityYDistanceToLink_18::
;> e = 2
	ld e, $02
;> d = (hLinkY - wEntityY[slot]) & 0xFF
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if not d & 0x80:               # Link is below
	bit 7, a
	jr nz, .done

;>     e = 3
	inc e

.done
	ld d, a
;> return e, d
	ret


;@ def GetEntityDrawYDistanceToLink_18() -> (e, d)
;@ path: entity/helpers
;@ Like GetEntityYDistanceToLink_18, measured from where the entity is drawn
;@ (hActiveEntityDrawY, its y minus its height): d = hLinkY - hActiveEntityDrawY, e = 2 up / 3 down.
GetEntityDrawYDistanceToLink_18::
;> e = 2
	ld e, $02
;> d = (hLinkY - hActiveEntityDrawY) & 0xFF
	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
;> if not d & 0x80:
	bit 7, a
	jr nz, .done

;>     e = 3
	inc e

.done
	ld d, a
;> return e, d
	ret


;@ def GetEntityDirectionToLink_18(slot: c) -> e
;@ path: entity/helpers
;@ Direction in which Link is seen from the entity, along the axis where he is farther away:
;@ 0 right, 1 left, 2 up, 3 down (the x direction when both distances are equal or y is smaller).
;@ test: c = rand(0, 15)
GetEntityDirectionToLink_18::
;> ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> hMultiPurpose0 = ex
	ld a, e
	ldh [hMultiPurpose0], a
;> adx = abs(signed(dx))
	ld a, d
	bit 7, a
	jr z, .xPositive

	cpl
	inc a

.xPositive
;> ey, dy = GetEntityYDistanceToLink_18(slot)
	push af
	call GetEntityYDistanceToLink_18
;> hMultiPurpose1 = ey
	ld a, e
	ldh [hMultiPurpose1], a
;> ady = abs(signed(dy))
	ld a, d
	bit 7, a
	jr z, .yPositive

	cpl
	inc a

.yPositive
;> if ady < adx:
	pop de
	cp d
	jr nc, .vertical

;>     return hMultiPurpose0      # horizontal direction
	ldh a, [hMultiPurpose0]
	jr .done

;> return hMultiPurpose1          # vertical direction
.vertical
	ldh a, [hMultiPurpose1]

.done
	ld e, a
	ret


;@ def ClearEntityStatus_18(slot: c)
;@ path: entity/helpers
;@ Removes the entity: its slot status becomes 0 (free).
;@ test: c = rand(0, 15)
ClearEntityStatus_18::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ def BossDeathSequence_18(slot: c)
;@ path: boss/death
;@ Runs while a defeated boss dies; wEntityPrivate2 is the step: 0 start flashing, 1 keep
;@ flashing, 2 explosions and then the end of the fight (BossDeathSteps_18).
;@ test: skip dispatches through a jump table
BossDeathSequence_18::
;> return BossDeathSteps_18[wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/death
;@ Steps of BossDeathSequence_18, by wEntityPrivate2 (2-byte code addresses).
BossDeathSteps_18::
	dw BossDeathStart_18
	dw BossDeathFlash_18
	dw BossDeathExplode_18

;@ def BossDeathStart_18(slot: c)
;@ path: boss/death
;@ Step 0: the boss starts flashing for $A0 frames.
;@ test: c = rand(0, 15)
BossDeathStart_18::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> BossDeathNextStep_18(slot)     # falls through

;@ def BossDeathNextStep_18(slot: c)
;@ path: boss/death
;@ Goes on to the next step of the boss death (wEntityPrivate2 + 1).
;@ test: c = rand(0, 15)
BossDeathNextStep_18::
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


;@ def BossDeathFlash_18(slot: c)
;@ path: boss/death
;@ Step 1: when the timer runs out, flashes on for another $C0 frames and goes on to the
;@ explosions.
;@ test: c = rand(0, 15)
BossDeathFlash_18::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     BossDeathNextStep_18(slot)
	call BossDeathNextStep_18

.done
	ret


;@ def BossDeathExplode_18(slot: c)
;@ path: boss/death
;@ Step 2: explosions burst around the boss every 8 frames; when the timer runs out the fight
;@ ends: a sound plays, the room's event is marked done (the boss stays beaten) and the boss
;@ is replaced by its reward (Call_3F7A).
;@ test: skip spawns entities through other banks
BossDeathExplode_18::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .exploding

;>     PlayClinkNoise()                # sound and short screen effect
	call PlayClinkNoise
;>     SelectAreaMusicFar()
	call SelectAreaMusicFar
;>     MarkRoomEventDone_18()
	call MarkRoomEventDone_18
;>     return Call_3F7A(slot)
	jp Call_3F7A

;> BossDeathRandomExplosion_18(t)
.exploding
	call BossDeathRandomExplosion_18
	ret


;@ def BossDeathRandomExplosion_18(t: a)
;@ path: boss/death
;@ Every 8 frames of the timer `t`: an explosion puff at a random spot around the boss
;@ (x -16..+15, drawn y -20..+11).
;@ test: skip spawns entities through other banks
BossDeathRandomExplosion_18::
;> if t & 7 == 0:
	and $07
	jr nz, .done

;>     dx = (GetRandomByte() & 0x1F) - 0x10          # random byte
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
;>     hActiveEntityX = (hActiveEntityX + dx) & 0xFF
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;>     dy = (GetRandomByte() & 0x1F) - 0x14
	call GetRandomByte
	and $1f
	sub $14
	ld e, a
;>     hActiveEntityDrawY = (hActiveEntityDrawY + dy) & 0xFF
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;>     SpawnExplosionPuff_18()
	call SpawnExplosionPuff_18

.done
	ret


;@ def SpawnExplosionPuff_18()
;@ path: entity/helpers
;@ Unless the game is paused, puts an explosion effect (transient effect 2) where the entity
;@ is drawn and plays noise effect $13.
;@ test: skip returns from its caller when paused; spawns an effect
SpawnExplosionPuff_18::
;> ReturnIfPaused_18()
	call ReturnIfPaused_18
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                   # transient effect at (hMultiPurpose0, hMultiPurpose1)
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret


;@ def UnusedSpawnHeartContainer_18(slot: c)
;@ path: unused/bank18
;@ Not called from anywhere. Would spawn a heart container (entity $36) at (hMultiPurpose0,
;@ hMultiPurpose1) - in side view with an upward speed (given to the own slot, not the new one),
;@ elsewhere popping up from height 8 - remove the calling entity and play noise effect $1A.
;@ test: skip spawns an entity through bank 3
UnusedSpawnHeartContainer_18::
;> new = Call_3C01(0x36)          # spawn an entity, its slot in de
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
	jr z, .topDown

;>     wEntitySpeedY[slot] = 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jr .remove

;> else:
;>     wEntitySpeedZ[new] = 0x10
.topDown
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityZ[new] = 8
	ld hl, wEntityZ
	add hl, de
	ld [hl], $08

;> ClearEntityStatus_18(slot)
.remove
	call ClearEntityStatus_18
;> hNoiseSfx = 0x1A
	ld hl, hNoiseSfx
	ld [hl], $1a
	ret

;@ def MarkRoomEventDone_18()
;@ path: world/rooms
;@ Sets bit 5 (event done) in the current room's status byte and in hRoomStatus. The room's
;@ byte is wRoomStatus[wIsIndoor * 256 + hMapRoom]; maps $06-$19 use the next group of 256.
;@ test: hMapRoom = rand(0, 255); wIsIndoor = rand(0, 1)
MarkRoomEventDone_18::
;> group = wIsIndoor
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
;> if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .mark

	cp $06
	jr c, .mark

;>     group += 1
	inc d

.mark
;> wRoomStatus[group * 256 + hMapRoom] |= 0x20
	add hl, de
	ld a, [hl]
	or $20
	ld [hl], a
;> hRoomStatus = wRoomStatus[group * 256 + hMapRoom]
	ldh [hRoomStatus], a
	ret


;@ path: unused/bank18
;@ The rest of bank $18 ($7F48-$7FFF): unused, filled with $FF.
Bank18FreeSpace::
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
