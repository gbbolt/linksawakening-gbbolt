; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $018", ROMX[$4000], BANK[$18]

;@ def MamuEntityHandler(slot: bc)
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

;@ def MamuWaitForLink(slot: bc)
;@ path: npc/mamu
;@ State 0. Once Link knows the Frog's Song of Soul, talking to Mamu only gives his closing words
;@ (dialogue $E0). Before that, Link is stopped when he walks up to the line y = $4C in front of
;@ the stage: Mamu speaks to him - dialogue $DB when Link has no ocarina (item 9) on a button or in
;@ the inventory; dialogue $DC with the offer to sing for 300 rupees when he has (then state 1).
;@ test: skip opens dialogues
MamuWaitForLink::
;> wEntityScratch1 = 0
	xor a
	ld [wEntityScratch1], a
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
;> StopLinkSpeed()                    # Link's speed to 0
	call StopLinkSpeed
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
	call IncrementEntityState
	ld [hl], b
;>     return
	ret

.hasOcarina
;> MamuOpenDialog(0xDC)           # the offer: a song for 300 rupees
	ld a, $dc
	call MamuOpenDialog
;> IncrementEntityState(slot)                    # next state: MamuAskToPlay
	call IncrementEntityState
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
;> SetEntitySpriteVariant(slot, v)                   # set the sprite variant
	call SetEntitySpriteVariant
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


;@ def MamuAskToPlay(slot: bc)
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

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
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

;@ def MamuWaitBeforeSong(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

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

;@ def MamuPerformSong(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
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
;> SetEntitySpriteVariant(slot, mem[MamuDanceFrames + step])   # Mamu's sprite variant
	ld hl, MamuDanceFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> wEntitySpriteVariant[1] = mem[MamuDanceFrogFramesA + step]
	ld hl, MamuDanceFrogFramesA
	add hl, de
	ld a, [hl]
	ld [wEntitySpriteVariant + 1], a
;> wEntitySpriteVariant[2] = mem[MamuDanceFrogFramesB + step]
	ld hl, MamuDanceFrogFramesB
	add hl, de
	ld a, [hl]
	ld [wEntitySpriteVariant + 2], a
	ret

	ret                             ; never reached

;@ def MamuEndSong(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.animate
;> return MamuAnimate()
	jp MamuAnimate

;@ def MamuTeachSong(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
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
;> DrawEntity8x16(slot, SongLearntSprite)    # one sprite above Link's head
	call DrawEntity8x16
;> return MamuAnimate()
	jp MamuAnimate

;@ def MamuFinish(slot: bc)
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
	call IncrementEntityState
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
;> DrawEntitySprites(frame, 8)            # draw 8 sprites
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)                   # claim 4 more OAM entries
	ld a, $04
	call ReserveOAMEntriesFar
	ret


;@ def MamuFrogHandler(slot: bc)
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
;> LoadEntityHitbox(slot)                # hitbox from the flags
	call LoadEntityHitbox
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

;@ def MamuFrogInit(slot: bc)
;@ path: npc/mamu
;@ State 0: starts the frog's animation counter at a random value (the frogs do not croak in step)
;@ and goes on to state 1 at once.
;@ test: slot = rand(0, 15)
MamuFrogInit::
;> wEntityPrivateCounter[slot] = GetRandomByte()   # random byte
	call GetRandomByte
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], a
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
;> MamuFrogIdle(slot)             # falls through

;@ def MamuFrogIdle(slot: bc)
;@ path: npc/mamu
;@ State 1: unless Mamu's song plays, the frog shows sprite variant 1, and variant 0 for 16 of
;@ every 64 frames of its counter.
;@ test: slot = rand(0, 15)
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
;> SetEntitySpriteVariant(slot, variant)
	ld a, e
	call SetEntitySpriteVariant
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

;>     return DrawEntity16x16(FrogSpritePairs)   # draw the pair of variant v
	ld de, FrogSpritePairs
	jp DrawEntity16x16

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
;> DrawEntitySprites(frame, 4)
	ld c, $04
	call DrawEntitySprites
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

;@ def ManboEntityHandler(slot: bc)
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

;@ def ManboWaitForLink(slot: bc)
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
;> StopLinkSpeed()                    # Link's speed to 0
	call StopLinkSpeed
;> OpenDialogTable1(0x85)         # Manbo greets Link: dialogue $185
	ld a, $85
	call OpenDialogTable1
;> IncrementEntityState(slot)                    # next state: ManboAskToPlay
	call IncrementEntityState
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
;> SetEntitySpriteVariant(slot, v)                   # set the sprite variant
	call SetEntitySpriteVariant
	ret


;@ def ManboAskToPlay(slot: bc)
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
;>@has             IncrementEntityState(slot)            # next state: ManboStartSong
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
	call IncrementEntityState
	ld [hl], b
;> OpenDialogTable1(0x8A)         # dialogue $18A
	ld a, $8a
	call OpenDialogTable1

.done
;> return
	ret

.hasOcarina
;=@has
	call IncrementEntityState
;=@has2
	ld a, $87
	jp OpenDialogTable1


;@ def ManboStartSong(slot: bc)
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
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
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

;@ def ManboPerformSong(slot: bc)
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

;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
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
;> SetEntitySpriteVariant(slot, mem[ManboDanceFrames + step])   # Manbo's sprite variant
	ld hl, ManboDanceFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> wEntityPrivate1[slot] = mem[ManboSplashFrames + step]
	ld hl, ManboSplashFrames
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wSongShowPlaying = mem[ManboFishDanceFrames + step]   # the fishes' frame
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

;@ def ManboEndSong(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.wait
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ManboAnimate()
	call ManboAnimate
	ret


;@ path: npc/song
;@ The sprite above Link's head while he holds up a song he has just learnt (Mamu, Manbo): one
;@ (tile, attributes) pair - tile $90, attributes $10 (sprite palette 1). Drawn with DrawEntity8x16.
SongLearntSprite::
	db $90, $10

;@ def ManboTeachSong(slot: bc)
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
	call IncrementEntityState
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
;> DrawEntity8x16(slot, SongLearntSprite)    # one sprite above Link's head
	call DrawEntity8x16
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

;@ def DrawManbo(slot: bc)
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
;> DrawEntity16x16(slot, ManboSplashPairs)    # draw the splash pair
	ld de, ManboSplashPairs
	call DrawEntity16x16
;> ReserveOAMEntriesFar(2)                   # claim 2 more OAM entries
	ld a, $02
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)                    # reload the position from the entity arrays
	call LoadEntityPosition
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
;> DrawEntitySprites(sprites, 9)
	ld c, $09
	call DrawEntitySprites
;> ReserveOAMEntriesFar(9)
	ld a, $09
	call ReserveOAMEntriesFar
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
;> DrawEntitySprites(ManboWaterSpray, 3)
	ld hl, ManboWaterSpray
	ld c, $03
	call DrawEntitySprites
;> ReserveOAMEntriesFar(3)
	ld a, $03
	call ReserveOAMEntriesFar
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
;> SetEntitySpriteVariant(slot, v)                   # set the sprite variant
	call SetEntitySpriteVariant
;> if wSongShowPlaying:
	ld a, [wSongShowPlaying]
	and a
	jr z, .done

;>     SetEntitySpriteVariant(slot, wSongShowPlaying)   # the dance frame
	call SetEntitySpriteVariant

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
;>     DrawEntitySprites(ManboWaterSpray, 3)
	ld hl, ManboWaterSpray
	ld c, $03
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(3)               # claim 3 more OAM entries
	ld a, $03
	call ReserveOAMEntriesFar
;>     LoadEntityPosition()                # reload the position
	call LoadEntityPosition
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
;>     DrawEntitySprites(frame, 3)
	ld c, $03
	call DrawEntitySprites
;>     return ReserveOAMEntriesFar(3)
	ld a, $03
	jp ReserveOAMEntriesFar

.pair
;> DrawEntity16x16(ManboFishPairs - 8)  # the pair of variant v
	ld de, ManboFishPairs - 8
	call DrawEntity16x16
;> return ReserveOAMEntriesFar(2)
	ld a, $02
	jp ReserveOAMEntriesFar

;@ path: object/mermaid_statue
;@ The mermaid statue: 4 entries of y offset, x offset, tile, attributes - tiles $70 $72 (16
;@ pixels up) over $74 $76, 16 x 32 pixels. Drawn by MermaidStatueEntityHandler.
MermaidStatueSprites::
	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00

;@ def MermaidStatueEntityHandler(slot: bc)
;@ path: object/mermaid_statue
;@ Entity $CE: the mermaid statue in Martha's Bay. Link puts the mermaid's scale (trading item
;@ $0D) into it; it slides 16 pixels to the left, uncovering the way to the magnifying lens
;@ (the trading item becomes $0E), and stays moved (room event flag).
;@ test: skip runs a state machine with dialogues and sprite drawing
MermaidStatueEntityHandler::
;> DrawEntitySprites(MermaidStatueSprites, 4)   # draw the 4 sprites
	ld hl, MermaidStatueSprites
	ld c, $04
	call DrawEntitySprites
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

;@ def MermaidStatueInit(slot: bc)
;@ path: object/mermaid_statue
;@ State 0: if the statue was already moved (room event done), it starts 16 pixels to the left.
;@ test: slot = rand(0, 15)
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
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
	ret


;@ def MermaidStatueWaitForScale(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

;> OpenDialogTable1(0x9C)         # dialogue $19C
.noScale
	ld a, $9c
	call OpenDialogTable1

.done
	ret


;@ def MermaidStatueSlide(slot: bc)
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
	call IncrementEntityState
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

;@ def ZoraEntityHandler(slot: bc)
;@ path: enemy/zora
;@ Entity $CB: the Zora, who surfaces at random spots of deep water, spits a fireball at Link
;@ and dives again.
;@ test: skip runs a state machine with sprite drawing
ZoraEntityHandler::
;> DrawEntity16x16(slot, ZoraSpritePairs)     # draw the pair of the sprite variant
	ld de, ZoraSpritePairs
	call DrawEntity16x16
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

;@ def ZoraPickSpot(slot: bc)
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
;> wEntityX[slot] = mem[EmergeSpotsX + i]
	ld hl, EmergeSpotsX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = mem[EmergeSpotsY + i]
	ld hl, EmergeSpotsY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> GetObjectUnderEntity_18(slot)             # type of the room object under the entity -> hMultiPurpose3
	call GetObjectUnderEntity_18
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
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def ZoraWaitUnderwater(slot: bc)
;@ path: enemy/zora
;@ State 1: waits under water, then shows ripples for $60 frames (state 2).
;@ test: slot = rand(0, 15)
ZoraWaitUnderwater::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x60
	ld [hl], $60
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def ZoraRipple(slot: bc)
;@ path: enemy/zora
;@ State 2: ripples on the water (variants 1 and 2, switching every 4 frames); then the Zora
;@ comes up and can be hit (state 3, $60 frames).
;@ test: slot = rand(0, 15)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

.ripple
;> return SetEntitySpriteVariant(slot, 2 if t & 4 else 1)   # set the sprite variant
	and $04
	ld a, $01
	jr z, .set

	inc a

.set
	jp SetEntitySpriteVariant


;@ path: enemy/zora
;@ Height of the surfaced Zora (bobbing): 8 values in pixels, one per 8 frames of its counter
;@ (0 0 1 2 2 2 1 0). Read by ZoraSurface.
ZoraBobHeights::
	db $00, $00, $01, $02, $02, $02, $01, $00

;@ def ZoraSurface(slot: bc)
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
;>@z wEntityZ[slot] = mem[ZoraBobHeights + ((i >> 3) & 7)]
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
;> EntityCheckHits(slot)                    # collision with Link: hurts him
	call EntityCheckHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .up

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     SetEntitySpriteVariant(slot, 0)               # sprite variant 0: nothing
	xor a
	call SetEntitySpriteVariant
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

;>     ball, failed = SpawnEntity(slot, 0x7D)  # spawn the fireball; position of the spawner in hMultiPurpose0/1
	ld a, $7d
	call SpawnEntity
;>     if not failed:
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
;>         SetEntitySpeedTowardsLink(slot, ball, 0x18)  # aim it at Link with speed $18
	push bc
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
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
;> return SetEntitySpriteVariant(slot, v)
	ld a, e
	jp SetEntitySpriteVariant


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

;@ def ChristineEntityHandler(slot: bc)
;@ path: npc/christine
;@ Entity $76: Christine the goat in Animal Village, who trades the hibiscus (trading item 8)
;@ for her letter (9). In room $A8 the same entity type is Mr. Write (MrWriteHandler). She is
;@ drawn 16 x 32 (4 sprites), looks at Link when he stands next to her, is solid, and a pair
;@ beside her shows what is on her table.
;@ test: skip runs a state machine with dialogues and sprite drawing
ChristineEntityHandler::
;>@draw DrawEntitySprites(ChristineSpriteFrames + hActiveEntitySpriteVariant * 16, 4)
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
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)                   # claim 4 more OAM entries
	ld a, $04
	call ReserveOAMEntriesFar
;> v = hFrameCounter >> 5
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
;> SetEntitySpriteVariant(slot, v & 1)               # set the sprite variant
	and $01
	call SetEntitySpriteVariant
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

;>         SetEntitySpriteVariant(slot, ex + 2)      # look to Link's side
	ld a, e
	add $02
	call SetEntitySpriteVariant

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
;> DrawEntity16x16(slot, pair)
	call DrawEntity16x16
;> LoadEntityPosition(slot)                    # reload the position
	call LoadEntityPosition
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

;@ def ChristineWaitForTalk(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

;> OpenDialogTable1(0x66 if wTradeSequenceItem < 8 else 0x6B)
.other
	ld a, $66
	jr c, .open

	ld a, $6b

.open
	call OpenDialogTable1

.done
	ret


;@ def ChristineAnswer(slot: bc)
;@ path: npc/christine
;@ State 1: "yes": dialogue $168 and state 2; "no": dialogue $169 and state 0.
;@ test: skip opens dialogues
ChristineAnswer::
;> if not wDialogState:           # (always: no state runs while a dialogue is open)
	ld a, [wDialogState]
	and a
	jr nz, .no

;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
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


;@ def ChristineGiveLetter(slot: bc)
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
	call IncrementEntityState
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


;@ def MrWriteHandler(slot: bc)
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

;@ def MrWriteWaitForTalk(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

;> OpenDialogTable1(0x33 if wTradeSequenceItem < 9 else 0x39)
.other
	ld a, $33
	jr c, .open

	ld a, $39

.open
	call OpenDialogTable1

.done
	ret


;@ def MrWriteWaitDialog(slot: bc)
;@ path: npc/mr_write
;@ State 1: goes on once the dialogue is closed.
;@ test: slot = rand(0, 15)
MrWriteWaitDialog::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
	ret

.done
	ret


;@ def MrWriteShowPicture(slot: bc)
;@ path: npc/mr_write
;@ State 2: switches to game mode 8, the picture of the letter's sender.
;@ test: slot = rand(0, 15)
MrWriteShowPicture::
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
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


;@ def MrWriteAfterPicture(slot: bc)
;@ path: npc/mr_write
;@ State 3: back from the picture (fade finished, step 4) he asks for the letter (dialogue $135).
;@ test: slot = rand(0, 15)
MrWriteAfterPicture::
;> if wTransitionSequenceCounter == 4 and not wDialogState:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done

	ld a, [wDialogState]
	and a
	jr nz, .done

;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
;>     OpenDialogTable1(0x35)     # dialogue $135
	ld a, $35
	call OpenDialogTable1

.done
	ret


;@ def MrWriteAnswer(slot: bc)
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

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
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


;@ def MrWriteDone(slot: bc)
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

;@ def GrandmaUlriraEntityHandler(slot: bc)
;@ path: npc/grandma_ulrira
;@ Entity $75: Grandma Ulrira, who trades the broom (trading item $0A) for the fishing hook
;@ ($0B). She only appears in room $B1, or in room $CD when bit 1 of $DB69 is set. Her pairs
;@ come from UlriraPairsB while she wants the broom (trading item $0A, or the $DB69 flag, before
;@ the trade) - then hMultiPurposeG, borrowed as a scratch flag, is 1.
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
;>     room = 0xCD if wDungeonFlags[4] & 0x02 else 0xB1
	ld a, [wDungeonFlags + 4]
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
;> hMultiPurposeG = 0         # scratch: "wants the broom"
	xor a
	ldh [hMultiPurposeG], a
;>@w if wTradeSequenceItem < 0x0B and (wDungeonFlags[4] & 0x02 or wTradeSequenceItem >= 0x0A):
	ld a, [wTradeSequenceItem]
	cp $0b
	jr nc, .draw

;=@w
	ld a, [wDungeonFlags + 4]
	and $02
	jr nz, .wants

;=@w
	ld a, [wTradeSequenceItem]
	cp $0a
	jr c, .draw

.wants
;>     hMultiPurposeG = 1
	ld a, $01
	ldh [hMultiPurposeG], a
;>     pairs = UlriraPairsB
	ld de, UlriraPairsB

.draw
;> DrawEntity16x16(slot, pairs)               # draw the pair of the sprite variant
	call DrawEntity16x16
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)                   # set the sprite variant
	call SetEntitySpriteVariant
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

;@ def UlriraWaitForTalk(slot: bc)
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

;> if not hMultiPurposeG:    # she does not want the broom
	ldh a, [hMultiPurposeG]
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

;> OpenDialogTable1(0x5B)         # dialogue $15B
.noBroom
	ld a, $5b
	call OpenDialogTable1

.done
	ret


;@ def UlriraAnswer(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
;>     return
	ret

.no
;> OpenDialogTable1(0x59)         # dialogue $159
	ld a, $59
	call OpenDialogTable1
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
	ret


;@ def UlriraSweep(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

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
;> DrawEntity16x16(slot, UlriraBroomSprite)
	ld de, UlriraBroomSprite
	call DrawEntity16x16
;> LoadEntityPosition(slot)                    # reload the position
	call LoadEntityPosition
;> return SetEntitySpriteVariant(slot, 2)
	ld a, $02
	jp SetEntitySpriteVariant


;@ def UlriraGiveHook(slot: bc)
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
	call IncrementEntityState
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

;@ def MamashaEntityHandler(slot: bc)
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
;> DrawEntitySprites(frame, 3)
	ld c, $03
	call DrawEntitySprites
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)                   # set the sprite variant
	call SetEntitySpriteVariant
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

;@ def MamashaWaitForTalk(slot: bc)
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

;>         IncrementEntityState(slot)            # next state
	call IncrementEntityState
;>         dialog = 0x2B
	ld e, $2b

.open
;> OpenDialogTable1(dialog)
	ld a, e
	call OpenDialogTable1

.done
	ret


;@ def MamashaAnswer(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

.no
;> OpenDialogTable1(0x27)         # dialogue $127
	ld a, $27
	call OpenDialogTable1
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.done
	ret


;@ def MamashaGiveRibbon(slot: bc)
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
	call IncrementEntityState
	ld [hl], b

.done
	ret


;@ def MadBatterEntityHandler(slot: bc)
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

;> DecrementEntityIgnoreHitsTimer(slot)
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

;@ def MadBatterWaitForPowder(slot: bc)
;@ path: npc/mad_batter
;@ State 0: hidden in his pot until the magic powder reaches it (that sets state 1 from
;@ outside). Once all three capacities are at their new maximum he is gone for good.
;@ test: skip reads a ROM table
MadBatterWaitForPowder::
;> if wMaxMagicPowder == mem[MadBatterMaxValues + 0]:
	ld a, [wMaxMagicPowder]
	ld hl, MadBatterMaxValues
	cp [hl]
	jr nz, .done

;>     if wMaxBombs == mem[MadBatterMaxValues + 1]:
	inc hl
	ld a, [wMaxBombs]
	cp [hl]
	jr nz, .done

;>         if wMaxArrows == mem[MadBatterMaxValues + 2]:
	inc hl
	ld a, [wMaxArrows]
	cp [hl]
;>             return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

.done
	ret


;@ def MadBatterAppear(slot: bc)
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
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
	ret


;@ def MadBatterRise(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

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


;@ def MadBatterPuff(slot: bc)
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
;>     bomb, full = SpawnEntity(slot, 2)        # spawner position in hMultiPurpose0/1
	ld a, $02
	call SpawnEntity
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def MadBatterGreet(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

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

;@ def MadBatterChooseUpgrade(slot: bc)
;@ path: npc/mad_batter
;@ State 5: after the greeting, offers the next capacity in turn (wEntityPrivate1 cycles
;@ 0, 1, 2) that is not raised yet; the chosen index is kept in wEntityScratch1 (the shared
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
;>     wEntityScratch1 = i
	ld a, e
	ld [wEntityScratch1], a
;>     wEntityPrivate1[slot] = (i + 1) % 3
	inc a
	cp $03
	jr nz, .store

	xor a

.store
	ld [hl], a
;>     if mem[MadBatterMaxValues + i] != mem[wMaxMagicPowder + i]:   # not raised yet
	ld hl, MadBatterMaxValues
	add hl, de
	ld a, [hl]
	ld hl, wMaxMagicPowder
	add hl, de
	cp [hl]
;>         break
;=@loop
	jr z, .next

;> MadBatterOpenDialog(mem[MadBatterUpgradeDialogs + i])
	ld hl, MadBatterUpgradeDialogs
	add hl, de
	ld a, [hl]
	call MadBatterOpenDialog
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState

.done
	ret


;@ def MadBatterAnswer(slot: bc)
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

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     bolt, full = SpawnEntity(slot, 0xCA)     # spawner position in hMultiPurpose0/1
	ld a, $ca
	call SpawnEntity
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


;@ def MadBatterCurse(slot: bc)
;@ path: npc/mad_batter
;@ State 7: during the bolt he stands still (frame 0). Then dialogue $E5 and the capacity is
;@ raised: the new maximum, and the count filled up to it - for the magic powder also the powder
;@ itself (item $0C) is given, the toadstool taken away and the inventory icons redrawn.
;@ test: skip opens a dialogue and changes the inventory
MadBatterCurse::
;> DrawEntitySprites(MadBatterFrame0, 3)
	ld hl, MadBatterFrame0
	ld c, $03
	call DrawEntitySprites
;> FreezeLinkForMadBatter()
	call FreezeLinkForMadBatter
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return
	ret nz

;> ClearEntitySpeed(slot)                    # speeds to 0
	call ClearEntitySpeed
;> MadBatterOpenDialog(0xE5)
	ld a, $e5
	call MadBatterOpenDialog
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
;> i = wEntityScratch1           # the chosen capacity
	ld a, [wEntityScratch1]
	ld e, a
	ld d, b
;> new = mem[MadBatterMaxValues + i]
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
;>     GiveInventoryItemFar(0x0C)            # give the magic powder (item $0C)
	ld d, $0c
	call GiveInventoryItemFar
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


;@ def MadBatterLeave(slot: bc)
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
;> DrawEntitySprites(frame, 3)
	ld c, $03
	call DrawEntitySprites
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
;> DrawEntity16x16(MadBatterPotPairs)
	ld de, MadBatterPotPairs
	call DrawEntity16x16
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


;@ def MadBatterBoltHandler(slot: bc)
;@ path: npc/mad_batter
;@ The lightning bolt (a Mad Batter entity with wEntityPrivate3 = 1): drawn while its timer runs,
;@ with the background palette flashing between $E4 and $44 every 2 frames; then it is removed.
;@ test: skip draws sprites
MadBatterBoltHandler::
;> DrawMadBatterBolt(slot)
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

;@ def DrawMadBatterBolt(slot: bc)
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

;>@cnt     count = mem[MadBatterBoltSpriteCounts + (((t - 0xB0) >> 2) & 3)]
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
;> DrawEntitySprites(frame, count)
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)                   # claim 4 more OAM entries
	ld a, $04
	call ReserveOAMEntriesFar
	ret


;@ path: link/ocarina
;@ The musical note: one (tile, attributes) pair for a single sprite - tile $0E, attributes 0.
;@ Drawn by MusicalNoteEntityHandler.
MusicalNoteSprite::
	db $0e, $00

;@ def MusicalNoteEntityHandler(slot: bc)
;@ path: link/ocarina
;@ Entity $C9: a musical note that rises from Link while he plays the ocarina (spawned by the
;@ ocarina code in bank 2 with its speed). It sways: every other frame its x speed changes by
;@ +1 or -1, the direction turning every 16 frames of its counter; when the counter runs out it
;@ disappears.
;@ test: skip draws a sprite
MusicalNoteEntityHandler::
;> DrawEntity8x16(slot, MusicalNoteSprite)   # draw one sprite
	ld de, MusicalNoteSprite
	call DrawEntity8x16
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

;@ def AnimalD0EntityHandler(slot: bc)
;@ path: npc/animal_village
;@ Entity $D0: an animal of Animal Village that is only there while Marin sings in the village.
;@ It turns towards Marin (down while she is lower on the screen, else up), sways every 32
;@ frames, is solid and talks (dialogue $196).
;@ test: skip draws sprites and opens a dialogue
AnimalD0EntityHandler::
;> RemoveUnlessMarinInVillage(slot)
	call RemoveUnlessMarinInVillage
;> DrawEntity16x16(slot, AnimalSpritePairsD0)
	ld de, AnimalSpritePairsD0
	call DrawEntity16x16
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
;> SetEntitySpriteVariant(slot, (v & 1) + e)
	and $01
	add e
	call SetEntitySpriteVariant

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


;@ def RemoveUnlessMarinInVillage(slot: bc)
;@ path: npc/animal_village
;@ The animals that listen to Marin exist only while she is in Animal Village: otherwise the
;@ entity is removed (its handler still finishes this frame).
;@ test: slot = rand(0, 15)
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

;@ def AnimalD1EntityHandler(slot: bc)
;@ path: npc/animal_village
;@ Entity $D1: another animal listening to Marin in Animal Village; it turns left or right
;@ towards her, sways every 32 frames and talks like AnimalD0EntityHandler.
;@ test: skip draws sprites and opens a dialogue
AnimalD1EntityHandler::
;> RemoveUnlessMarinInVillage(slot)
	call RemoveUnlessMarinInVillage
;> DrawEntity16x16(slot, AnimalSpritePairsD1)
	ld de, AnimalSpritePairsD1
	call DrawEntity16x16
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
;> SetEntitySpriteVariant(slot, (v & 1) + e)
	and $01
	add e
	call SetEntitySpriteVariant
;> return AnimalTalkToLink()
	jr AnimalTalkToLink

;@ path: npc/animal_village
;@ Sprite pairs of the animal $D3 for AnimateEntityByDirection_18 (two frames per facing):
;@ 0-1 down ($50 $52 and mirrored), 2-3 up ($54 $56 and mirrored), 4-5 left ($58 $5A twice),
;@ 6-7 right ($5A $58 mirrored twice).
AnimalSpritePairsD3::
	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20
	db $58, $00, $5a, $00, $58, $00, $5a, $00, $5a, $20, $58, $20, $5a, $20, $58, $20

;@ def AnimalD3EntityHandler(slot: bc)
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

;> DrawEntity16x16(slot, AnimalSpritePairsD3)
	ld de, AnimalSpritePairsD3
	call DrawEntity16x16
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
;> LoadEntityPosition(slot)                    # reload the position
	call LoadEntityPosition
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
;> if wDungeonFlags[5] & 0x02:
	ld a, [wDungeonFlags + 5]
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

;@ def AnimalD2EntityHandler(slot: bc)
;@ path: npc/animal_village
;@ Entity $D2: a third animal listening to Marin, turning left or right towards her, like
;@ AnimalD1EntityHandler.
;@ test: skip draws sprites and opens a dialogue
AnimalD2EntityHandler::
;> RemoveUnlessMarinInVillage(slot)
	call RemoveUnlessMarinInVillage
;> DrawEntity16x16(slot, AnimalSpritePairsD2)
	ld de, AnimalSpritePairsD2
	call DrawEntity16x16
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
;> SetEntitySpriteVariant(slot, (v & 1) + e)
	and $01
	add e
	call SetEntitySpriteVariant
;> return AnimalTalkToLink()
	jp AnimalTalkToLink


;@ path: npc/bunny
;@ Sprite pairs of the bunny who calls Marin away: 0-1 running right ($5A $58 / $5E $5C
;@ mirrored), 2-3 running left ($58 $5A / $5C $5E).
BunnySpritePairs::
	db $5a, $20, $58, $20, $5e, $20, $5c, $20, $58, $00, $5a, $00, $5c, $00, $5e, $00

;@ def BunnyCallingMarinEntityHandler(slot: bc)
;@ path: npc/bunny
;@ Entity $C8: the bunny from Animal Village who, after the walrus is gone, runs in from the
;@ left, hops about, asks Marin to come and sing in the village and leads her away. Link is
;@ frozen all the time. hMultiPurposeG is borrowed as a "just landed" flag for BunnyHop.
;@ test: skip runs a cutscene state machine
BunnyCallingMarinEntityHandler::
;> DrawEntity16x16(slot, BunnySpritePairs)
	ld de, BunnySpritePairs
	call DrawEntity16x16
;> v = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)                   # set the sprite variant
	call SetEntitySpriteVariant
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
;> hMultiPurposeG = wEntityZ[slot] & 0x80   # landed
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

;@ def BunnyRunIn(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState


;@ def BunnyGreet(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
;> BunnyHop(slot)                 # falls through

;@ def BunnyHop(slot: bc)
;@ path: npc/bunny
;@ Hops: after landing it waits on the ground for 9 frames (wEntityPrivate4 counts down), then
;@ jumps with height speed $12.
;@ test: slot = rand(0, 15)
BunnyHop::
;> if hMultiPurposeG:         # on the ground
	ldh a, [hMultiPurposeG]
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


;@ def BunnyAsk(slot: bc)
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
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

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


;@ def BunnyLeaveWithMarin(slot: bc)
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
;>@run SetEntitySpriteVariant(slot, 2 + ((hFrameCounter >> 3) & 1))   # running left
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;=@run
	call SetEntitySpriteVariant
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


;@ def LeverEntityHandler(slot: bc)
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

;@ def DrawLever(slot: bc)
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
;> DrawEntity16x16(slot, LeverHandlePairs)
	ld de, LeverHandlePairs
	call DrawEntity16x16
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
;>     DrawEntity16x16(slot, LeverChainPairs)
	ld de, LeverChainPairs
	call DrawEntity16x16
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

;> LoadEntityPosition(slot)                    # reload the position
	call LoadEntityPosition
	ret


;@ path: npc/walrus
;@ The "Z" of the sleeping walrus, by variant: one (tile, attributes) pair each - 0: $24, 1: $3E.
;@ Drawn by WalrusSnoreHandler.
WalrusSnoreSprites::
	db $24, $00, $3e, $00

;@ def WalrusSnoreHandler(slot: bc)
;@ path: npc/walrus
;@ A snore "Z" of the walrus (entity $C4 with wEntityPrivate1 set): it drifts up and to the left
;@ (moving every 4th frame; faster up during 32 of every 64 frames), shows its second look from
;@ $40 frames left (one step 4 pixels lower) and disappears when its timer runs out.
;@ test: skip draws a sprite
WalrusSnoreHandler::
;> DrawEntity8x16(slot, WalrusSnoreSprites)
	ld de, WalrusSnoreSprites
	call DrawEntity8x16
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
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
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


;@ def WalrusEntityHandler(slot: bc)
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

;@ def WalrusSleep(slot: bc)
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

;>     z, failed = SpawnEntity(slot, 0xC4)    # spawn a snore; the walrus's position in hMultiPurpose0/1
	ld a, $c4
	call SpawnEntity
;>     if not failed:
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
;> StopLinkSpeed()                    # Link's speed to 0
	call StopLinkSpeed
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

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
;> OpenDialogTable1(0xE1)         # dialogue $1E1: Marin offers to sing
	ld a, $e1
	call OpenDialogTable1
;> SetFollowerFacingRight()       # Marin turns to the walrus
	call SetFollowerFacingRight
	ret


;@ def WalrusAskMarin(slot: bc)
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

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
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


;@ def WalrusListen(slot: bc)
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
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
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
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
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

;@ def WalrusWakeUp(slot: bc)
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
;>     SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

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
;> v = mem[WalrusWakeFrames + step]
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
;> SetEntitySpriteVariant(slot, v)
	call SetEntitySpriteVariant
;> if wEntityZ[slot]:             # in the air
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;>@air     SetEntitySpriteVariant(slot, 1 if wEntitySpeedZ[slot] < -8 else 2)   # (signed)
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
	call SetEntitySpriteVariant

.done
	ret


;@ def WalrusRoll(slot: bc)
;@ path: npc/walrus
;@ State 4: every 16 frames the walrus rolls one frame further towards the sea (y + 4, variant +
;@ 1); after frame 3 it leaps (height $18, y + $18, jingle 8; state 5).
;@ test: slot = rand(0, 15)
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
;>         IncrementEntityState(slot)            # next state
	call IncrementEntityState

.done
	ret


;@ def WalrusLand(slot: bc)
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

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
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


;@ def WalrusGone(slot: bc)
;@ path: npc/walrus
;@ State 6: the walrus shows its diving frame (5) until the timer runs out; then it is gone
;@ (variant $FF), the area music comes back, Marin says dialogue $1E2 and she and Link turn down
;@ (state 7).
;@ test: skip updates Link's pose through another bank
WalrusGone::
;> if wEntityTimer[slot]:
	call GetEntityTimer
;>     return SetEntitySpriteVariant(slot, 5)
	jr nz, .diving

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
;> wMusicTrackToPlay = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	ld [wMusicTrackToPlay], a
;> SetEntitySpriteVariant(slot, 0xFF)                # not drawn any more
	ld a, $ff
	call SetEntitySpriteVariant
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
	jp SetEntitySpriteVariant


;@ def WalrusCallBunny(slot: bc)
;@ path: npc/walrus
;@ State 7: the bunny that calls Marin (entity $C8) is placed off the left edge (x $F8, y $48,
;@ timer $20); the walrus entity is removed and the room event marked done.
;@ test: skip spawns an entity through bank 3
WalrusCallBunny::
;> bunny, full = SpawnEntity(slot, 0xC8)
	ld a, $c8
	call SpawnEntity
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

;@ def DrawWalrus(slot: bc)
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
;> DrawEntitySprites(frame, 8)
	ld c, $08
	call DrawEntitySprites
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
;> DrawEntitySprites(WalrusShadowSprites, 4)
	ld hl, WalrusShadowSprites
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)                   # claim 4 more OAM entries
	ld a, $04
	call ReserveOAMEntriesFar
;> LoadEntityPosition(slot)                    # reload the position
	call LoadEntityPosition
	ret


;@ def WalrusInSeaHandler(slot: bc)
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

;@ def WalrusInSeaInit(slot: bc)
;@ path: npc/walrus
;@ State 0: places the walrus at (x $80, y $68) and waits $20 frames.
;@ test: slot = rand(0, 15)
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
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def WalrusInSeaWaitForSong(slot: bc)
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

;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     WalrusSplashes()
	call WalrusSplashes

.done
	ret


;@ def WalrusInSeaSurface(slot: bc)
;@ path: npc/walrus
;@ State 2: the walrus rises (variant 2, then 1 for the last 16 frames); then state 3 for $C8
;@ frames.
;@ test: slot = rand(0, 15)
WalrusInSeaSurface::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rise

;>     wEntityTimer[slot] = 0xC8
	ld [hl], $c8
;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

.rise
;> SetEntitySpriteVariant(slot, 1 if t < 0x10 else 2)
	cp $10
	ld a, $01
	jr c, .set

	inc a

.set
	call SetEntitySpriteVariant
	ret


;@ def WalrusInSeaTalk(slot: bc)
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
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
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

;@ def DrawSwimmingWalrus(slot: bc)
;@ path: npc/walrus
;@ Draws the walrus in the sea, bobbing (WalrusBobOffsets); while it talks (wEntityPrivate5) its
;@ frame switches between 1 and 2 every 64 frames.
;@ test: skip draws sprites
DrawSwimmingWalrus::
;>@bob hActiveEntityDrawY += mem[WalrusBobOffsets + ((hFrameCounter >> 4) & 7)]
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
;> return DrawEntitySprites(frame, 5)
	ld c, $05
	jp DrawEntitySprites


;@ def SetFollowerFacingRight()
;@ path: npc/marin
;@ Makes the follower (Marin) face right: SetFollowerFacing(0).
SetFollowerFacingRight::
;> SetFollowerFacing(0)           # falls through
	ld a, $00

;@ def SetFollowerFacing(direction: a)
;@ path: npc/marin
;@ Fills all 16 entries of wFollowerTrailDir with `direction`, so the follower (Marin) turns and
;@ keeps facing that way (0 right, 1 left, 2 up, 3 down).
;@ test: a = rand(0, 3)
SetFollowerFacing::
;> for i in range(16):
;>     wFollowerTrailDir[i] = direction
	ld e, $10
	ld hl, wFollowerTrailDir

.fill
	ld [hli], a
	dec e
	jr nz, .fill

	ret


;@ path: npc/marin
;@ Marin's sprite pairs, by variant: 2 x (tile, attributes) ($20 mirrored). 0-1 facing down
;@ ($42 $40 mirrored / $40 $42), 2-3 up ($44 $46 / mirrored), 4-5 left ($48 $4A / $4C $4E),
;@ 6-7 right (mirrored), 8-10 singing ($50 $52, $54 + mirrored, $52 $50 mirrored).
MarinSpritePairs::
	db $42, $20, $40, $20, $40, $00, $42, $00, $44, $00, $46, $00, $46, $20, $44, $20
	db $48, $00, $4a, $00, $4c, $00, $4e, $00, $4a, $20, $48, $20, $4e, $20, $4c, $20
	db $50, $00, $52, $00, $54, $00, $54, $20, $52, $20, $50, $20

;@ path: npc/marin
;@ First walking variant of Marin for each facing direction (index wEntityDirection: 0 right,
;@ 1 left, 2 up, 3 down): 6, 4, 2, 0. Read by MarinFollowLink.
MarinDirectionVariants::
	db $06, $04, $02, $00

;@ def MarinFollowHandler(slot: bc)
;@ path: npc/marin
;@ Entity $C1 (Marin) while she follows Link. First the moment she joins: for the timer Link
;@ holds her up like a found treasure (pose $6C, Marin drawn 16 pixels above his head); at 16
;@ frames left dialogue $01F, at 1 the follow music ($31) starts. After the screen fade (step
;@ 4) the follower trail is filled with Link's position and she goes on in MarinFollowUpdate.
;@ test: skip runs Marin's follower logic with dialogues
MarinFollowHandler::
;> wSingingMarinSlot = slot
	ld a, c
	ld [wSingingMarinSlot], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:                     # Link holds her up
	jr z, .afterJoin

;>     if t == 0x10:
	cp $10
	jr nz, .notText

;>         wEntityTimer[slot] -= 1    # only once
	dec [hl]
;>         y = hLinkY
	ldh a, [hLinkY]
	push af
;>         hLinkY = 0x28          # box at the bottom
	ld a, $28
	ldh [hLinkY], a
;>         OpenDialog(0x1F)       # Marin joins
	ld a, $1f
	call OpenDialog
;>         hLinkY = y
	pop af
	ldh [hLinkY], a
;>         t = 0x0F
	ld a, $0f

.notText
;>     if t == 1:
	cp $01
	jr nz, .pose

;>         wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>         wMusicTrackToPlay = 0x31
	ld a, $31
	ld [wMusicTrackToPlay], a
;>         hDefaultMusicTrack = 5
	ld a, $05
	ldh [hDefaultMusicTrack], a

.pose
;>     wEntitySpriteVariant[0] = 0    # (the variant of slot 0)
	xor a
	ld [wEntitySpriteVariant], a
;>     DrawEntity16x16(slot, MarinSpritePairs)
	ld de, MarinSpritePairs
	call DrawEntity16x16
;>     hLinkAnimationState = 0x6C # holding her up
	ld a, $6c
	ldh [hLinkAnimationState], a
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
;>     wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>     wEntityY[slot] = hLinkY - 0x10
	ldh a, [hLinkY]
	sub $10
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>     return
	ret

.afterJoin
;> if wEntityPrivate4[slot]:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
;>     return MarinFollowUpdate(slot)
	jr nz, MarinFollowUpdate

;> if wTransitionSequenceCounter != 4:   # the fade is not finished
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	jr nz, FillFollowerTrail.done

;> wEntityPrivate4[slot] = 1
	inc [hl]
;> wEntityTimer[slot] = 0x70
	call GetEntityTimer
	ld [hl], $70
;> wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;> hLastMusicTrack = 0xFF
	ld a, $ff
	ldh [hLastMusicTrack], a
;> FillFollowerTrail(wFollowerTrailX, hLinkX)
	ldh a, [hLinkX]
	ld hl, wFollowerTrailX
	call FillFollowerTrail
;> FillFollowerTrail(wFollowerTrailY, hLinkY)
	ldh a, [hLinkY]
	ld hl, wFollowerTrailY
	call FillFollowerTrail
;> FillFollowerTrail(wFollowerTrailZ, 0)
	xor a
	ld hl, wFollowerTrailZ
	call FillFollowerTrail
;> FillFollowerTrail(wFollowerTrailDir, hLinkDirection)   # falls through
	ldh a, [hLinkDirection]
	ld hl, wFollowerTrailDir

;@ def FillFollowerTrail(table: hl, value: a)
;@ path: npc/marin
;@ Writes `value` into the 16 bytes at `table` (one of the follower trail arrays).
;@ test: table = 0xD155; a = rand(0, 255)
FillFollowerTrail::
;> for i in range(16):
;>     mem[table + i] = value
	ld e, $10

.fill
	ld [hli], a
	dec e
	jr nz, .fill

.done
	ret


;@ path: npc/marin
;@ Marin's sprite variant while she sings (8 entries, one per 16 frames): 8 8 8 9 10 10 10 9.
;@ Read by MarinFollowUpdate.
MarinFollowSingFrames::
	db $08, $08, $08, $09, $0a, $0a, $0a, $09

;@ path: npc/marin
;@ X offset of a new musical note from Marin, by (frame >> 5) & 1: +8, -8.
FollowNoteOffsetsX::
	db $08, $f8

;@ path: npc/marin
;@ X speed of a new musical note, by the same index: 6, 1.
FollowNoteSpeedsX::
	db $06, $01

;@ def MarinFollowUpdate(slot: bc)
;@ path: npc/marin
;@ Marin following Link, every frame. While she sings (wMarinSinging) she shows her singing
;@ frames and every 32 frames a musical note (entity $C9) rises from her. Then: a short comment
;@ when wEntityDyingTimer runs out (dialogue $27A), the scene of wEntityTimer2 (Link pushed at
;@ (x $58, y $50): a bump with a shake and dialogue $27B, otherwise wEntityDyingTimer = $1C),
;@ the walk back to Link after wMarinReunion (MarinReunionStates), and normally
;@ MarinFollowLink. Nothing of that while she is in Animal Village or wScriptedWarpTimer runs.
;@ test: skip runs Marin's follower logic with dialogues
MarinFollowUpdate::
;> if wMarinSinging:
	ld a, [wMarinSinging]
	and a
	jr z, .draw

;>@sing     hActiveEntitySpriteVariant = mem[MarinFollowSingFrames + ((hFrameCounter >> 4) & 7)]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $07
;=@sing
	ld e, a
	ld d, b
	ld hl, MarinFollowSingFrames
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>     if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .draw

;>         note, failed = SpawnEntity(slot, 0xC9)   # a musical note; Marin's position in hMultiPurpose0/1
	ld a, $c9
	call SpawnEntity
;>         if not failed:
	jr c, .draw

;>             wEntityY[note] = hMultiPurpose1 - 8
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $08
	ld [hl], a
;>@k             k = (hFrameCounter >> 5) & 1
	push bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
;=@k
	rra
	and $01
	ld c, a
;>@nx             wEntityX[note] = hMultiPurpose0 + mem[FollowNoteOffsetsX + k]
	ld hl, FollowNoteOffsetsX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@nx
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntitySpeedX[note] = mem[FollowNoteSpeedsX + k]
	ld hl, FollowNoteSpeedsX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>             wEntitySpeedY[note] = 0xFC
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fc
;>             wEntityPrivateCounter[note] = 0x40   # its life time
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], $40
	pop bc

.draw
;> DrawEntity16x16(slot, MarinSpritePairs)
	ld de, MarinSpritePairs
	call DrawEntity16x16
;> if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
;>     return
	ret nz

;>@dy if wEntityDyingTimer[slot] == 1:
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .timer2

;=@dy
	dec a
	jr nz, .timer2

;>     wEntityDyingTimer[slot] = 0
	dec [hl]
;>     OpenDialogTable2(0x7A)     # dialogue $27A
	ld a, $7a
	call OpenDialogTable2

.timer2
;> t = wEntityTimer2[slot]
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
;>@t2 if 0 < t <= 0x30:
	jr z, .normal

;>     if t == 0x30:
	cp $30
	jr nz, .notStart

;>         wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>@spot         if not ((hLinkX - 0x58 + 3) & 0xFF < 6 and (hLinkY - 0x50 + 3) & 0xFF < 6):
	ldh a, [hLinkX]
	sub $58
	add $03
	cp $06
	jr nc, .away

;=@spot
	ldh a, [hLinkY]
	sub $50
	add $03
	cp $06
	jr c, .bump

.away
;>             wEntityTimer2[slot] = 0
	ld [hl], b
;>             wEntityDyingTimer[slot] = 0x1C
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1c
;>             return
	ret

.bump
;>         hJingle = 0x0B
	ld hl, hJingle
	ld [hl], $0b
;>         hWaveSfx = 3
	ld hl, hWaveSfx
	ld [hl], $03
;>         wBumpShakeTimer = 0x18
	ld hl, wBumpShakeTimer
	ld [hl], $18
;>         wBumpShakeAxis = 4
	ld hl, wBumpShakeAxis
	ld [hl], $04
;>         hLinkX += 1
	ld hl, hLinkX
	inc [hl]
	jr .holdLink

.notStart
;=@t2
	jr nc, .normal

;>     elif t == 0x10:
	cp $10
	jr nz, .holdLink

;>         wEntityTimer2[slot] -= 1
	dec [hl]
;>         OpenDialogTable2(0x7B) # dialogue $27B
	ld a, $7b
	call OpenDialogTable2

.holdLink
;>     hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>     hLinkAnimationState = 0x6A
	ld a, $6a
	ldh [hLinkAnimationState], a
;>     return
	ret

.normal
;> if wIsMarinInAnimalVillage or wScriptedWarpTimer:
	ld a, [wIsMarinInAnimalVillage]
	ld hl, wScriptedWarpTimer
	or [hl]
;>     return
	ret nz

;> if not wMarinReunion:
	ld a, [wMarinReunion]
	and a
;>     return MarinFollowLink(slot)
	jp z, MarinFollowLink

;> EntityCheckWalls(slot)                    # stop at walls
	call EntityCheckWalls
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if wMarinReunionTimer:
	ld a, [wMarinReunionTimer]
	and a
	jr z, .dispatch

;>     wMarinReunionTimer -= 1
	dec a
	ld [wMarinReunionTimer], a

.dispatch
;> return MarinReunionStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/marin
;@ Steps of Marin's walk back to Link after wMarinReunion is set (wEntityState):
;@ 0 MarinReunionStart, 1 MarinReunionTurn, 2 MarinReunionWalk, 3 MarinReunionTalk,
;@ 4 MarinReunionEnd.
MarinReunionStates::
	dw MarinReunionStart
	dw MarinReunionTurn
	dw MarinReunionWalk
	dw MarinReunionTalk
	dw MarinReunionEnd

;@ def MarinReunionStart(slot: bc)
;@ path: npc/marin
;@ Step 0: once Link is no longer fading out (motion state 3), a background change ($0F), Marin
;@ shows variant 1 and waits $40 frames.
;@ test: slot = rand(0, 15)
MarinReunionStart::
;> if wLinkMotionState == 3:
;>     return
	ld a, [wLinkMotionState]
	cp $03
	ret z

;> wMarinReunionTimer = 0x40
	ld a, $40
	ld [wMarinReunionTimer], a
;> hBGChangeRequest = 0x0F
	ld a, $0f
	ldh [hBGChangeRequest], a
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;> return IncrementEntityState(slot)             # next step
	jp IncrementEntityState


;@ def MarinReunionTurn(slot: bc)
;@ path: npc/marin
;@ Step 1: after the wait she turns left (direction 1, variant 4), background change $10, and
;@ waits $18 frames.
;@ test: slot = rand(0, 15)
MarinReunionTurn::
;> if not wMarinReunionTimer:
	ld a, [wMarinReunionTimer]
	and a
	jr nz, .done

;>     wMarinReunionTimer = 0x18
	ld a, $18
	ld [wMarinReunionTimer], a
;>     wEntityDirection[slot] = 1
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
;>     SetEntitySpriteVariant(slot, 4)
	ld a, $04
	call SetEntitySpriteVariant
;>     hBGChangeRequest = 0x10
	ld a, $10
	ldh [hBGChangeRequest], a
;>     IncrementEntityState(slot)                # next step
	call IncrementEntityState

.done
	ret


;@ def MarinReunionWalk(slot: bc)
;@ path: npc/marin
;@ Step 2: she walks left (speed -12, variants 4/5) until she is within 2 pixels of Link's x;
;@ then she faces up (variant 2) and waits $10 frames.
;@ test: slot = rand(0, 15)
MarinReunionWalk::
;> if wMarinReunionTimer:
	ld a, [wMarinReunionTimer]
	and a
;>     return
	jr nz, .done

;> wEntitySpeedX[slot] = 0xF4     # -12
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f4
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> v = 5 if hFrameCounter & 8 else 4
	ldh a, [hFrameCounter]
	and $08
	ld e, $04
	jr z, .set

	inc e

.set
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
;> ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> if (dx + 2) & 0xFF >= 4:
;>     return
	add $02
	cp $04
	ret nc

;> wEntitySpriteVariant[slot] = 2
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $02
;> wEntityDirection[slot] = 2
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
;> wMarinReunionTimer = 0x10
	ld a, $10
	ld [wMarinReunionTimer], a
;> IncrementEntityState(slot)                    # next step
	call IncrementEntityState

.done
	ret


;@ def MarinReunionTalk(slot: bc)
;@ path: npc/marin
;@ Step 3: she speaks (table 2): when wLowHealth equals wMarinReunion - 1 or is 0, dialogue
;@ $21B, or $21D while $DB47 is below $80; otherwise $21C, or $21E one time in 64.
;@ test: skip opens a dialogue
MarinReunionTalk::
;> if wMarinReunionTimer:
	ld a, [wMarinReunionTimer]
	and a
;>     return
	jr nz, .done

;>@c if wLowHealth != wMarinReunion - 1 and wLowHealth != 0:
	ld a, [wMarinReunion]
	dec a
	ld e, a
	ld a, [wLowHealth]
	cp e
	jr z, .same

;=@c
	and a
	jr z, .same

;>     e = 0x1E if GetRandomByte() & 0x3F == 0 else 0x1C
	ld e, $1c
	call GetRandomByte
	and $3f
	jr nz, .open

	ld e, $1e
	jr .open

.same
;> else:
;>     e = 0x1B if mem[0xDB47] >= 0x80 else 0x1D
	ld e, $1b
	ld a, [$db47]
	cp $80
	jr nc, .open

	ld e, $1d

.open
;> OpenDialogTable2(e)
	ld a, e
	call OpenDialogTable2
;> IncrementEntityState(slot)                    # next step
	call IncrementEntityState

.done
	ret


;@ def MarinReunionEnd(slot: bc)
;@ path: npc/marin
;@ Step 4: the walk is over: wMarinReunion is cleared, Link is free, the follower trail starts
;@ at Marin (her x; her drawn y, one pixel less per entry; facing up) and her trail counter is $FF.
;@ test: slot = rand(0, 15); hActiveEntityDrawY = rand(0x10, 0x80)
MarinReunionEnd::
;> wMarinReunion = 0
	xor a
	ld [wMarinReunion], a
;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wEntityPrivateCounter[slot] = 0xFF
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $ff
;> FillTrail16(wFollowerTrailX, hActiveEntityX)
	ldh a, [hActiveEntityX]
	ld hl, wFollowerTrailX
	call FillTrail16
;> y = hActiveEntityDrawY
	ld hl, wFollowerTrailY
	ldh a, [hActiveEntityDrawY]
	ld e, $10

.y
;> for i in range(16):
;>     wFollowerTrailY[i] = (y - i) & 0xFF
	ld [hli], a
	dec a
	dec e
	jr nz, .y

;> FillTrail16(wFollowerTrailDir, 2)   # falls through
	ld a, $02
	ld hl, wFollowerTrailDir

;@ def FillTrail16(table: hl, value: a)
;@ path: npc/marin
;@ Writes `value` into the 16 bytes at `table` (a second copy of FillFollowerTrail).
;@ test: table = 0xD155; a = rand(0, 255)
FillTrail16::
;> for i in range(16):
;>     mem[table + i] = value
	ld e, $10

.fill
	ld [hli], a
	dec e
	jr nz, .fill

	ret


;@ def MarinFollowLink(slot: bc)
;@ path: npc/marin
;@ Marin walking behind Link. After the room's fade-in she is kept in this room; Link's
;@ previous position, direction and height go into the follower trail at her counter, and she
;@ takes the trail entry one step later - so she walks 15 steps behind him. Her counter moves
;@ on while Link walks (or in motion state 2, or while the room scrolls); her height has its own
;@ counter (wEntityPrivate1, every frame). Landing after a jump makes a thud (noise 7), or a
;@ splash in water / grass (effect $0C, jingle $0E); taking off a jingle (8 high, $24 low).
;@ test: skip runs Marin's follower logic
MarinFollowLink::
;> if wTransitionSequenceCounter != 4:
;>     return
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

;> wEntityRoom[slot] = hMapRoom
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
;>@base base = mem[MarinDirectionVariants + wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, MarinDirectionVariants
	add hl, de
;=@base
	push hl
;>@walk SetEntitySpriteVariant(slot, base | ((wLinkWalkingFrameCount >> 3) & 1))   # walk in step with Link
	ld a, [wLinkWalkingFrameCount]
	rra
	rra
	rra
	pop hl
;=@walk
	and $01
	or [hl]
	call SetEntitySpriteVariant
;> i = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeG], a
;>@tx wFollowerTrailX[i & 0x0F] = hLinkPrevX
	and $0f
	ld e, a
	ld d, b
	ld hl, wFollowerTrailX
	add hl, de
;=@tx
	ldh a, [hLinkPrevX]
	ld [hl], a
;> wFollowerTrailY[i & 0x0F] = hLinkPrevY + wLinkSpriteDY
	ldh a, [hLinkPrevY]
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, wFollowerTrailY
	add hl, de
	ld [hl], a
;> wFollowerTrailDir[i & 0x0F] = hLinkDirection
	ld hl, wFollowerTrailDir
	add hl, de
	ldh a, [hLinkDirection]
	ld [hl], a
;> k = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
;>@tz wFollowerTrailZ[k & 0x0F] = hLinkPositionZ
	and $0f
	ld e, a
	ld d, b
	ld hl, wFollowerTrailZ
	add hl, de
;=@tz
	ldh a, [hLinkPositionZ]
	ld [hl], a
;>@adv if wLinkMotionState == 2 or wRoomTransitionState or (not wDialogState and (hLinkSpeedX or hLinkSpeedY)):
	ld a, [wLinkMotionState]
	cp $02
	jr z, .advance

	ld a, [wRoomTransitionState]
	and a
	jr nz, .advance

;=@adv
	ld a, [wDialogState]
	and a
	jr nz, .height

	ld hl, hLinkSpeedX
	ldh a, [hLinkSpeedY]
;=@adv
	or [hl]
	jr z, .height

.advance
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]

.height
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
;> j = (i + 1) & 0x0F
	ldh a, [hMultiPurposeG]
	inc a
	and $0f
	ld e, a
	ld d, b
;> wEntityX[slot] = wFollowerTrailX[j]
	ld hl, wFollowerTrailX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = wFollowerTrailY[j]
	ld hl, wFollowerTrailY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityDirection[slot] = wFollowerTrailDir[j]
	ld hl, wFollowerTrailDir
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> j = (k + 1) & 0x0F
	ldh a, [hMultiPurposeH]
	inc a
	and $0f
	ld e, a
	ld d, b
;> old = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	push af
;> new = wFollowerTrailZ[j]
	ld hl, wFollowerTrailZ
	add hl, de
	ld e, [hl]
;> wEntityZ[slot] = new
	ld hl, wEntityZ
	add hl, bc
	ld [hl], e
;> if wEntityTimer1[slot] or wRoomTransitionState:
	call GetEntityTimer1
	ld hl, wRoomTransitionState
	or [hl]
;>@pr     return
	jr nz, .popReturn

;> if old == new:
	pop af
	cp e
;>     return EntityCheckWalls(slot)         # stop at walls
	jr z, .walls

;> if old == 0:                   # takes off
;>@to     hJingle = 8 if new >= 8 else 0x24
	and a
	jr z, .takeOff

;>@w     return EntityCheckWalls(slot)

;> if new != 0:
	ld a, e
	and a
;>     return EntityCheckWalls(slot)
	jr nz, .walls

;> EntityCheckWalls(slot)                    # landed
	call EntityCheckWalls
;> if wEntityStatus[slot] == 2:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $02
;>     return
	ret z

;> if wEntityGroundStatus[slot] - 1 >= 2:   # (unsigned) plain ground
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	dec a
	cp $02
	jr c, .splash

;>     hNoiseSfx = 7
	ld a, $07
	ldh [hNoiseSfx], a
;>     return
	ret

.splash
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;> return AddTransientVfx(0x0C)   # splash in water / grass
	ld a, $0c
	jp AddTransientVfx

.takeOff
;=@to
	ld a, e
	cp $08
	ld a, $08
	jr nc, .jingle

	ld a, $24

.jingle
;=@to
	ldh [hJingle], a

.walls
;=@w
	jp EntityCheckWalls

.popReturn
;=@pr
	pop af
	ret


;@ path: npc/marin
;@ Steps of the text debugger: x of the dialogue number by (hJoypadPressed & 3): +0, +1, -1;
;@ then (from the fourth byte) the y step by ((hJoypadPressed >> 2) & 3): 0, +$10, -$10. Both
;@ lookups overlap (the fourth byte, 0, belongs to both).
TextDebuggerSteps::
	db $00, $01, $ff, $00, $10, $f0

;@ def TextDebuggerEntityHandler(slot: bc)
;@ path: unused/text_debugger
;@ Entity $6B: a text debugger left in the game. Link is frozen; right/left change the low
;@ digit of wDebugDialogIndex, up/down the high digit; A opens that dialogue from table 0,
;@ B from table 1, Select from table 2.
;@ test: skip reads the joypad and opens dialogues
TextDebuggerEntityHandler::
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> hAnimatedTilesGroup = 1
	ld a, $01
	ldh [hAnimatedTilesGroup], a
;> hLinkInteractiveMotionBlocked = 2
	inc a
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> step = mem[TextDebuggerSteps + (hJoypadPressed & 3)]
	ldh a, [hJoypadPressed]
	and $03
	ld e, a
	ld d, b
	ld hl, TextDebuggerSteps
	add hl, de
;>@lo wDebugDialogIndex = (wDebugDialogIndex & 0xF0) | ((wDebugDialogIndex + step) & 0x0F)
	ld a, [wDebugDialogIndex]
	push af
	add [hl]
	and $0f
	ld e, a
	pop af
;=@lo
	and $f0
	or e
	ld [wDebugDialogIndex], a
;>@st step = mem[TextDebuggerSteps + (3 + ((hJoypadPressed >> 2) & 3))]
	ldh a, [hJoypadPressed]
	rra
	rra
	and $03
	ld e, a
	ld d, b
;=@st
	ld hl, TextDebuggerSteps + 3
	add hl, de
;> wDebugDialogIndex = (wDebugDialogIndex + step) & 0xFF
	ld a, [wDebugDialogIndex]
	add [hl]
	ld [wDebugDialogIndex], a
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .select

;>     if hJoypadPressed & 0x10:  # A
	ldh a, [hJoypadPressed]
	and $10
	jr z, .notA

;>         return OpenDialog(wDebugDialogIndex)
	ld a, [wDebugDialogIndex]
	jp OpenDialog

.notA
;>     if hJoypadPressed & 0x20:  # B
	ldh a, [hJoypadPressed]
	and $20
	jr z, .select

;>         return OpenDialogTable1(wDebugDialogIndex)
	ld a, [wDebugDialogIndex]
	jp OpenDialogTable1

.select
;> if hJoypadPressed & 0x40:      # Select
	ldh a, [hJoypadPressed]
	and $40
	jr z, .done

;>     return OpenDialogTable2(wDebugDialogIndex)
	ld a, [wDebugDialogIndex]
	jp OpenDialogTable2

.done
	ret


;@ def SkyScrollEntityHandler()
;@ path: world/scroll
;@ Entity $64: scrolls the background one pixel to the right every 4 frames (wScrollXOffset),
;@ for rooms whose picture drifts (clouds, ...).
;@ test: skip returns from its caller when paused
SkyScrollEntityHandler::
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done

;>     wScrollXOffset += 1
	ld hl, wScrollXOffset
	inc [hl]

.done
	ret


;@ path: object/owl_statue
;@ The owl statue: one sprite pair (tile, attributes) - $5E and $5E mirrored. Drawn by
;@ OwlStatueEntityHandler.
OwlStatueSpritePair::
	db $5e, $00, $5e, $20

;@ path: object/mural
;@ The mural (owl statue type in map $16): 4 entries of y offset, x offset, tile, attributes -
;@ tiles $50 $52 $54 $56 in a row from x - 8 (32 x 16 pixels). Drawn by MuralHandler.
MuralSprites::
	db $00, $f8, $50, $00, $00, $00, $52, $00, $00, $08, $54, $00
	db $00, $10, $56, $00

;@ def MuralHandler(slot: bc)
;@ path: object/mural
;@ Entity $42 in map $16: the wall mural. Reading it (when the room is lit, background palette
;@ $E4) shows the mural screen (game mode $0A); in the dark it is too dark to read (dialogue $0E6).
;@ test: skip runs a state machine with sprite drawing
MuralHandler::
;> DrawEntitySprites(MuralSprites, 4)
	ld hl, MuralSprites
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(2)                   # claim 2 more OAM entries
	ld a, $02
	call ReserveOAMEntriesFar
;> return MuralStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/mural
;@ The mural's states (wEntityState): 0 MuralInit, 1 MuralWaitForRead, 2 MuralShow.
MuralStates::
	dw MuralInit
	dw MuralWaitForRead
	dw MuralShow

;@ def MuralInit(slot: bc)
;@ path: object/mural
;@ State 0: places the mural at x $50.
;@ test: slot = rand(0, 15)
MuralInit::
;> wEntityX[slot] = 0x50
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def MuralWaitForRead(slot: bc)
;@ path: object/mural
;@ State 1: when Link reads the mural: in the lit room (palette $E4) state 2, otherwise
;@ dialogue $0E6.
;@ test: skip opens a dialogue
MuralWaitForRead::
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	ret nz

;> if not CheckLinkCanTalk_18():
;>     return
	call CheckLinkCanTalk_18
	ret nc

;> if wBGPalette == 0xE4:
	ld a, [wBGPalette]
	cp $e4
	jr nz, .dark

;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

.dark
;> OpenDialog(0xE6)               # too dark
	ld a, $e6
	call OpenDialog
	ret


;@ def MuralShow(slot: bc)
;@ path: object/mural
;@ State 2: after the dialogue, switches to the mural screen (game mode $0A), notes that the
;@ mural was seen (bit 4 of overworld room $AC's status) and goes back to state 0.
;@ test: slot = rand(0, 15)
MuralShow::
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> StartGameplayType_18(0x0A)
	ld a, $0a
	call StartGameplayType_18
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wRoomStatus[0xAC] |= 0x10
	ld hl, wRoomStatus + $ac
	set 4, [hl]

.done
	ret


;@ def OwlStatueEntityHandler(slot: bc)
;@ path: object/owl_statue
;@ Entity $42: an owl statue in a dungeon (in map $16 it is the mural, MuralHandler). It is
;@ solid; read without the dungeon's stone beak it says dialogue $110, with it the hint of the
;@ dungeon, dialogue $108 + map number.
;@ test: skip opens a dialogue
OwlStatueEntityHandler::
;> if hMapId == 0x16:
	ldh a, [hMapId]
	cp $16
;>     return MuralHandler(slot)
	jp z, MuralHandler

;> hActiveEntityDrawY += 1
	ldh a, [hActiveEntityDrawY]
	add $01
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(slot, OwlStatueSpritePair)
	ld de, OwlStatueSpritePair
	call DrawEntity16x16
;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if CheckLinkCanTalk_18():
	call CheckLinkCanTalk_18
	jr nc, .done

;>     dialog = 0x10 if not wDungeonHasStoneBeak else hMapId + 8
	ld a, [wDungeonHasStoneBeak]
	and a
	ld a, $10
	jr z, .open

	ldh a, [hMapId]
	add $08

.open
;>     OpenDialogTable1(dialog)   # dialogue $1xx
	call OpenDialogTable1

.done
	ret


;@ path: npc/marin
;@ Marin's sprite pairs for AnimateEntityByDirection_18 (two frames per facing; $20 mirrored):
;@ 0-1 down ($60 $62 and mirrored), 2-3 up ($64 $66 and mirrored), 4-5 left ($68 $6A, $6C
;@ $6E), 6-7 right (the same mirrored). Used by MarinCompanionEntityHandler and MarinSceneEntityHandler.
MarinPairs::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

;@ def MarinSceneEntityHandler(slot: bc)
;@ path: npc/marin
;@ Entity $C2: a scene with Marin (she sets wSingingMarinSlot): only while bit 1 of
;@ wDungeon7Flags is set, the rooster does not follow Link and the room's bit 4 is clear. She
;@ talks to Link (dialogues $235-$239, table 2), is pulled along when Link uses the hookshot,
;@ then a visitor (a second entity $C2 with wEntityPrivate2 = 1, MarinSceneVisitor) comes and
;@ she walks off to the left; at the end bit 4 of overworld room $08 is set for good. She hops
;@ now and then (gravity 2; hMultiPurposeG is borrowed for her height).
;@ test: skip runs a cutscene state machine
MarinSceneEntityHandler::
;> if not wDungeon7Flags & 0x02:
	ld a, [wDungeon7Flags]
	and $02
;>     return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

;> if wIsRoosterFollowingLink:
	ld a, [wIsRoosterFollowingLink]
	and a
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;> if hRoomStatus & 0x10:         # the scene is over
	ldh a, [hRoomStatus]
	and $10
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;> if wEntityPrivate2[slot]:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
;>     return MarinSceneVisitor(slot)
	jp nz, MarinSceneVisitor

;> wSingingMarinSlot = slot
	ld a, c
	ld [wSingingMarinSlot], a
;> DrawEntity16x16(slot, MarinPairs)
	ld de, MarinPairs
	call DrawEntity16x16
;> AnimateEntityByDirection_18(slot)
	call AnimateEntityByDirection_18
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> wEntitySpeedZ[slot] -= 2       # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hMultiPurposeG = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	ldh [hMultiPurposeG], a
;> if hMultiPurposeG == 0 or hMultiPurposeG & 0x80:   # on the ground
	jr z, .ground

	and $80
	jr z, .dispatch

.ground
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

.dispatch
;> return MarinSceneStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/marin
;@ States of Marin's scene (wEntityState): 0 MarinSceneWait, 1 MarinSceneTalk1,
;@ 2 MarinSceneWaitForLink, 3 MarinSceneHookshot, 4 MarinSceneTalk2, 5 MarinSceneTalk3,
;@ 6 MarinSceneTalk4, 7 MarinScenePause, 8 MarinSceneCallVisitor, 9 MarinSceneWaitForVisitor,
;@ 10 MarinSceneWalkDown, 11 MarinSceneWalkLeft, 12 MarinSceneLeave.
MarinSceneStates::
	dw MarinSceneWait
	dw MarinSceneTalk1
	dw MarinSceneWaitForLink
	dw MarinSceneHookshot
	dw MarinSceneTalk2
	dw MarinSceneTalk3
	dw MarinSceneTalk4
	dw MarinScenePause
	dw MarinSceneCallVisitor
	dw MarinSceneWaitForVisitor
	dw MarinSceneWalkDown
	dw MarinSceneWalkLeft
	dw MarinSceneLeave

;@ def ResetEntityCounter_18(slot: bc)
;@ path: entity/helpers
;@ Sets wEntityPrivateCounter to 0 (holds a walking animation on its first frame).
;@ test: slot = rand(0, 15)
ResetEntityCounter_18::
;> wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
	ret


;@ def MarinSceneWait(slot: bc)
;@ path: npc/marin
;@ State 0: Marin hops and looks at Link; when he comes left of x $90 she calls him
;@ (dialogue $235).
;@ test: skip opens a dialogue
MarinSceneWait::
;> MarinSceneHop(slot)
	call MarinSceneHop
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> wEntityDirection[slot] = GetEntityXDistanceToLink_18(slot)[0]   # face Link
	call GetEntityXDistanceToLink_18
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> if hLinkX < 0x90:
	ldh a, [hLinkX]
	cp $90
	jr nc, .done

;>     OpenDialogTable2(0x35)     # dialogue $235
	ld a, $35
	call OpenDialogTable2
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def MarinSceneHop(slot: bc)
;@ path: npc/marin
;@ On the ground (hMultiPurposeG 0 or negative), Marin hops (height speed $10) every 64
;@ frames.
;@ test: slot = rand(0, 15)
MarinSceneHop::
;> if hMultiPurposeG and not hMultiPurposeG & 0x80:   # in the air
	ldh a, [hMultiPurposeG]
	and a
	jr z, .ground

	and $80
;>     return
	ret z

.ground
;> if hFrameCounter & 0x3F == 0:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .done

;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

.done
	ret


;@ def MarinSceneTalk1(slot: bc)
;@ path: npc/marin
;@ State 1: dialogue $236 (after the first one).
;@ test: skip opens a dialogue
MarinSceneTalk1::
;> MarinSceneHop(slot)
	call MarinSceneHop
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> OpenDialogTable2(0x36)         # dialogue $236
	ld a, $36
	call OpenDialogTable2
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def MarinSceneWaitForLink(slot: bc)
;@ path: npc/marin
;@ State 2: waits until Link is close (within 8 pixels sideways and 16 up or down).
;@ test: skip returns from its caller when paused
MarinSceneWaitForLink::
;> MarinSceneHop(slot)
	call MarinSceneHop
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> if (dx + 8) & 0xFF >= 0x10:
;>     return
	add $08
	cp $10
	ret nc

;> ey, dy = GetEntityYDistanceToLink_18(slot)
	call GetEntityYDistanceToLink_18
;> if (dy + 0x10) & 0xFF >= 0x20:
;>     return
	add $10
	cp $20
	ret nc

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
	ret


;@ def MarinSceneHookshot(slot: bc)
;@ path: npc/marin
;@ State 3: Marin faces Link; while the hookshot is in use she is carried along 16 pixels right
;@ of him. When it is over Link's item pose ends and she waits $10 frames (state 4).
;@ test: skip returns from its caller when paused
MarinSceneHookshot::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> wEntityDirection[slot] = GetEntityXDistanceToLink_18(slot)[0]
	call GetEntityXDistanceToLink_18
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> if wHookshotInUse:
	ld a, [wHookshotInUse]
	and a
	jr z, .over

;>     wEntityX[slot] = hLinkX + 0x10
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	add $10
	ld [hl], a
;>     wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>     return
	ret

.over
;> wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
;> wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def MarinSceneTalk2(slot: bc)
;@ path: npc/marin
;@ State 4: Link is frozen and faces right; after the timer, dialogue $237.
;@ test: skip updates Link's pose through another bank
MarinSceneTalk2::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> hLinkDirection = 0
	ld a, $00
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     OpenDialogTable2(0x37)     # dialogue $237
	ld a, $37
	call OpenDialogTable2
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def MarinSceneTalk3(slot: bc)
;@ path: npc/marin
;@ State 5: dialogue $238.
;@ test: skip opens a dialogue
MarinSceneTalk3::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> OpenDialogTable2(0x38)         # dialogue $238
	ld a, $38
	call OpenDialogTable2
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def MarinSceneTalk4(slot: bc)
;@ path: npc/marin
;@ State 6: dialogue $239, and the pause counter wEntityPrivate1 starts at 0.
;@ test: skip opens a dialogue
MarinSceneTalk4::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> OpenDialogTable2(0x39)         # dialogue $239
	ld a, $39
	call OpenDialogTable2
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def MarinScenePause(slot: bc)
;@ path: npc/marin
;@ State 7: a pause of $A0 frames.
;@ test: skip returns from its caller when paused
MarinScenePause::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
;> if wEntityPrivate1[slot] == 0xA0:
	ld a, [hl]
	cp $a0
	jr nz, .done

;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

.done
	ret


;@ def MarinSceneCallVisitor(slot: bc)
;@ path: npc/marin
;@ State 8: the visitor appears at the bottom left (a new entity $C2 at x $12, y $88 with
;@ wEntityPrivate2 = 1).
;@ test: skip spawns an entity through bank 3
MarinSceneCallVisitor::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> visitor, full = SpawnEntity(slot, 0xC2)
	ld a, $c2
	call SpawnEntity
;> wEntityX[visitor] = 0x12
	ld hl, wEntityX
	add hl, de
	ld [hl], $12
;> wEntityY[visitor] = 0x88
	ld hl, wEntityY
	add hl, de
	ld [hl], $88
;> wEntityPrivate2[visitor] += 1  # it is the visitor
	ld hl, wEntityPrivate2
	add hl, de
	inc [hl]
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def MarinSceneWaitForVisitor(slot: bc)
;@ path: npc/marin
;@ State 9: Marin stands still; the visitor moves her on to state 10 (VisitorSendMarin).
;@ test: slot = rand(0, 15)
MarinSceneWaitForVisitor::
;> ResetEntityCounter_18(slot)
	call ResetEntityCounter_18
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


;@ def MarinSceneWalkDown(slot: bc)
;@ path: npc/marin
;@ State 10: she walks down (speed 6) to y $3E.
;@ test: slot = rand(0, 15)
MarinSceneWalkDown::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if hActiveEntityDrawY >= 0x3E:
	ldh a, [hActiveEntityDrawY]
	cp $3e
	jr c, .walk

;>     return IncrementEntityState(slot)         # next state
	jp IncrementEntityState

.walk
;> wEntitySpeedY[slot] = 6
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $06
;> wEntityDirection[slot] = 3
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
;> return UpdateEntityYWithSpeed_18(slot)
	jp UpdateEntityYWithSpeed_18


;@ def MarinSceneWalkLeft(slot: bc)
;@ path: npc/marin
;@ State 11: she walks left (speed -6) until x $18, then stops for $60 frames.
;@ test: slot = rand(0, 15)
MarinSceneWalkLeft::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wEntitySpeedX[slot] = 0xFA     # -6
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fa
;> wEntityDirection[slot] = 1
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> if hActiveEntityX < 0x18:
	ldh a, [hActiveEntityX]
	cp $18
	jr nc, .done

;>     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def MarinSceneLeave(slot: bc)
;@ path: npc/marin
;@ State 12: she looks up while the timer runs, then walks off to the left (speed -12) with Link
;@ watching her; at x $F0 Link is free, bit 4 of overworld room $08 is set (the scene does not
;@ come again) and she is removed.
;@ test: skip updates Link's pose through another bank
MarinSceneLeave::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot]:
	call GetEntityTimer
	jr z, .walk

;>     wEntityDirection[slot] = 2
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
;>     return
	ret

.walk
;> wEntitySpeedX[slot] = 0xF4     # -12
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f4
;> wEntityDirection[slot] = 1
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> if hActiveEntityX == 0xF0:
	ldh a, [hActiveEntityX]
	cp $f0
	jr nz, .watch

;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     wRoomStatus[0x08] |= 0x10
	ld hl, wRoomStatus + $08
	set 4, [hl]
;>     hRoomStatus = wRoomStatus[0x08]
	ld a, [hl]
	ldh [hRoomStatus], a
;>     return ClearEntityStatus_18(slot)
	jp ClearEntityStatus_18

.watch
;> ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> hLinkDirection = ex ^ 1        # Link looks at her
	ld a, e
	xor $01
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
	ret


;@ path: npc/marin
;@ The visitor's sprite pairs for AnimateEntityByDirection_18: 0-1 down ($50 $52 and
;@ mirrored), 2-3 up ($54 $56 and mirrored), 4-5 left ($58 $5A, $5C $5E), 6-7 right (mirrored).
MarinSceneVisitorPairs::
	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5a, $20, $58, $20, $5e, $20, $5c, $20

;@ def MarinSceneVisitor(slot: bc)
;@ path: npc/marin
;@ The visitor in Marin's scene (entity $C2 with wEntityPrivate2 set): it walks up from the
;@ bottom, speaks (dialogues $23B and $23A, table 2) with Marin and Link looking at it, sends
;@ Marin on (her state 10) and walks off to the left.
;@ test: skip runs a cutscene state machine
MarinSceneVisitor::
;> DrawEntity16x16(slot, MarinSceneVisitorPairs)
	ld de, MarinSceneVisitorPairs
	call DrawEntity16x16
;> AnimateEntityByDirection_18(slot)
	call AnimateEntityByDirection_18
;> return MarinSceneVisitorStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/marin
;@ The visitor's states: 0 VisitorWalkUp, 1 VisitorTalk, 2 VisitorSendMarin, 3 VisitorLeave.
MarinSceneVisitorStates::
	dw VisitorWalkUp
	dw VisitorTalk
	dw VisitorSendMarin
	dw VisitorLeave

;@ def VisitorWalkUp(slot: bc)
;@ path: npc/marin
;@ State 0: walks up (speed -12) to y $70; then dialogue $23B and Link and Marin turn down to it.
;@ test: skip updates Link's pose through another bank
VisitorWalkUp::
;> wEntityDirection[slot] = 2
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $02
;> wEntitySpeedY[slot] = 0xF4     # -12
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f4
;> UpdateEntityYWithSpeed_18(slot)
	call UpdateEntityYWithSpeed_18
;> if hActiveEntityDrawY < 0x70:
	ldh a, [hActiveEntityDrawY]
	cp $70
	jr nc, .done

;>     OpenDialogTable2(0x3B)     # dialogue $23B
	ld a, $3b
	call OpenDialogTable2
;>     hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
;>     wEntityDirection[wSingingMarinSlot] = 3
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $03
;>     UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def VisitorTalk(slot: bc)
;@ path: npc/marin
;@ State 1: Marin keeps looking down; dialogue $23A.
;@ test: skip opens a dialogue
VisitorTalk::
;> wEntityDirection[wSingingMarinSlot] = 3
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $03
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> OpenDialogTable2(0x3A)         # dialogue $23A
	ld a, $3a
	call OpenDialogTable2
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def VisitorSendMarin(slot: bc)
;@ path: npc/marin
;@ State 2: Marin looks down, and left once the dialogue has reached character $22; after the
;@ dialogue Marin goes on to her next state and the visitor to state 3.
;@ test: skip returns from its caller when paused
VisitorSendMarin::
;>@dir wEntityDirection[wSingingMarinSlot] = 1 if wDialogCharIndex >= 0x22 else 3
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $03
;=@dir
	ld a, [wDialogCharIndex]
	cp $22
	jr c, .wait

	ld [hl], $01

.wait
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> wEntityState[wSingingMarinSlot] += 1
	ld a, [wSingingMarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	inc [hl]
;> return IncrementEntityState(slot)             # next state
	jp IncrementEntityState


;@ def VisitorLeave(slot: bc)
;@ path: npc/marin
;@ State 3: walks left (speed -8) and is removed at x $E0.
;@ test: slot = rand(0, 15)
VisitorLeave::
;> wEntityDirection[slot] = 1
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
;> wEntitySpeedX[slot] = 0xF8     # -8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $f8
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> if hActiveEntityX == 0xE0:
	ldh a, [hActiveEntityX]
	cp $e0
	jr nz, .done

;>     ClearEntityStatus_18(slot)
	call ClearEntityStatus_18

.done
	ret


;@ def MarinCompanionEntityHandler(slot: bc)
;@ path: npc/marin
;@ Entity $C1: Marin. While she follows Link, MarinFollowHandler; while she is in Animal Village
;@ this entity does nothing. Otherwise she is at the beach (Toronbo Shores) - only once the
;@ trading sequence has reached item 7 and while the walrus is still there - and asks Link to
;@ sit with her (dialogue $1D5): "yes" starts the beach scene (game mode 9, music $4E).
;@ test: skip runs a state machine with dialogues
MarinCompanionEntityHandler::
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
;>     return MarinFollowHandler(slot)
	jp nz, MarinFollowHandler

;> if wIsMarinInAnimalVillage:
	ld a, [wIsMarinInAnimalVillage]
	and a
;>     return
	ret nz

;> if wRoomStatus[0xFD] & 0x20:   # the walrus is gone
	ld a, [wRoomStatus + $fd]
	and $20
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;> if wTradeSequenceItem < 7:
	ld a, [wTradeSequenceItem]
	cp $07
;>     return ClearEntityStatus_18(slot)
	jp c, ClearEntityStatus_18

;> DrawEntity16x16(slot, MarinPairs)
	ld de, MarinPairs
	call DrawEntity16x16
;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return
	ret nz

;> PushLinkOutOfEntity_18(slot)
	call PushLinkOutOfEntity_18
;> return MarinBeachStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/marin
;@ Marin's states at the beach: 0 MarinBeachMusic, 1 MarinBeachWaitForLink, 2 MarinBeachTurn,
;@ 3 MarinBeachAnswer, 4 MarinBeachRefused, 5 MarinBeachLookAway, 6 MarinBeachIdle.
MarinBeachStates::
	dw MarinBeachMusic
	dw MarinBeachWaitForLink
	dw MarinBeachTurn
	dw MarinBeachAnswer
	dw MarinBeachRefused
	dw MarinBeachLookAway
	dw MarinBeachIdle

;@ def MarinBeachMusic(slot: bc)
;@ path: npc/marin
;@ State 0: her music ($4D) plays and becomes the room's music.
;@ test: slot = rand(0, 15)
MarinBeachMusic::
;> wMusicTrackToPlay = 0x4D
	ld a, $4d
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrack = 0x4D
	ldh [hDefaultMusicTrack], a
;> hDefaultMusicTrackAlt = 0x4D
	ldh [hDefaultMusicTrackAlt], a
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
	ret


;@ def MarinBeachWaitForLink(slot: bc)
;@ path: npc/marin
;@ State 1: when Link comes to her height (within 20 pixels), he stops and she turns to him
;@ ($18 frames).
;@ test: skip runs the entity timer
MarinBeachWaitForLink::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> ey, dy = GetEntityYDistanceToLink_18(slot)
	call GetEntityYDistanceToLink_18
;> if (dy + 0x14) & 0xFF < 0x28:
	add $14
	cp $28
	jr nc, .done

;>     wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;>     wEntityTimer[slot] = 0x18
	call GetEntityTimer
	ld [hl], $18
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def MarinBeachTurn(slot: bc)
;@ path: npc/marin
;@ State 2: she turns (variant 4, then 2 for the last 12 frames) and asks (dialogue $1D5).
;@ test: skip opens a dialogue
MarinBeachTurn::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .turn

;>     OpenDialogTable1(0xD5)     # dialogue $1D5
	ld a, $d5
	call OpenDialogTable1
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.turn
;> v = 2 if t < 0x0C else 4
	ld e, $02
	cp $0c
	jr c, .set

	ld e, $04

.set
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant

.done
	ret


;@ def MarinBeachAnswer(slot: bc)
;@ path: npc/marin
;@ State 3: "yes": the beach scene (game mode 9, music $4E; she waits in state 6). "No": Link is
;@ free again, dialogue $1D6 (state 4).
;@ test: skip opens a dialogue and changes the game mode
MarinBeachAnswer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no

;>     wEntityState[slot] = 6
	ld [hl], $06
;>     wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>     wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>     wActivePowerUp = 0
	ld [wActivePowerUp], a
;>     wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>     wGameplayType = 9          # the scene with Marin on the beach
	ld a, $09
	ld [wGameplayType], a
;>     wMusicTrackToPlay = 0x4E
	ld a, $4e
	ld [wMusicTrackToPlay], a
;>     return
	ret

.no
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;> OpenDialogTable1(0xD6)         # dialogue $1D6
	ld a, $d6
	call OpenDialogTable1

.done
	ret


;@ def MarinBeachRefused(slot: bc)
;@ path: npc/marin
;@ State 4: after the dialogue she looks away for $60 frames.
;@ test: slot = rand(0, 15)
MarinBeachRefused::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.done
	ret


;@ def MarinBeachLookAway(slot: bc)
;@ path: npc/marin
;@ State 5: variant 4 for the first frames, then 0 (looking out to sea), and state 6 at the end.
;@ test: slot = rand(0, 15)
MarinBeachLookAway::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .look

;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.look
;> v = 0 if t < 0x54 else 4
	ld e, $00
	cp $54
	jr c, .set

	ld e, $04

.set
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def MarinBeachIdle()
;@ path: npc/marin
;@ State 6: does nothing.
MarinBeachIdle::
;> return
	ret


;@ path: npc/signpost_maze
;@ The signpost maze: for each of its 14 steps the position of the sign Link must read (row
;@ nibble, column nibble, as in wSignpostReadPos). One byte per step; read by
;@ SignpostMazeEntityHandler together with SignpostMazeRooms and SignpostMazeDialogs.
SignpostMazeSigns::
	db $65, $64, $54, $52, $22, $22, $32, $37, $37, $37, $57, $56, $26, $21

;@ path: npc/signpost_maze
;@ The room of each step's sign (overworld rooms $C4, $C5, $D4, $D5).
SignpostMazeRooms::
	db $c4, $c5
	db $d5, $d4, $c4, $c5, $d5, $d5, $c5, $c4, $c4, $c5, $d5, $d4

;@ path: npc/signpost_maze
;@ The dialogue (table 1, $1A9-$1AE) each step's sign shows when it is the right one - the
;@ direction to the next sign.
SignpostMazeDialogs::
	db $ab, $a9, $ac, $aa
	db $ab, $a9, $ab, $aa, $ac, $a9, $ab, $a9, $ac, $ae

;@ def SignpostMazeEntityHandler(slot: bc)
;@ path: npc/signpost_maze
;@ Entity $C0: the referee of the signpost maze. Every sign Link reads leaves its position in
;@ wSignpostReadPos; if it is the sign of the current step in the right room, the maze goes one
;@ step on and the sign shows its direction (SignpostMazeDialogs); after all 14 steps a jingle
;@ plays and stairs appear (SignpostMazeOpenStairs). A wrong sign starts the maze over (jingle
;@ $1D, dialogue $1AD); in room $B4 it always starts over.
;@ test: skip opens dialogues
SignpostMazeEntityHandler::
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if hMapRoom == 0xB4:           # the start of the maze
	ldh a, [hMapRoom]
	cp $b4
	jr nz, .check

;>     wSignpostMazeStep = 0
	xor a
	ld [wSignpostMazeStep], a
;>     wSignpostReadPos = 0
	ld [wSignpostReadPos], a

.check
;> if not wSignpostReadPos:       # no sign read
	ld a, [wSignpostReadPos]
	and a
;>     return
	jr z, .done

;> i = wSignpostMazeStep
	ld a, [wSignpostMazeStep]
	ld e, a
	ld d, b
;>@ok if wSignpostReadPos == mem[SignpostMazeSigns + i] and hMapRoom == mem[SignpostMazeRooms + i]:
	ld hl, SignpostMazeSigns
	add hl, de
	ld a, [wSignpostReadPos]
	cp [hl]
	jr nz, .wrong

;=@ok
	ld hl, SignpostMazeRooms
	add hl, de
	ldh a, [hMapRoom]
	cp [hl]
	jr nz, .wrong

;>     wSignpostReadPos = 0
	xor a
	ld [wSignpostReadPos], a
;>     wSignpostMazeStep += 1
	ld a, [wSignpostMazeStep]
	inc a
	ld [wSignpostMazeStep], a
;>     if wSignpostMazeStep == 14:   # solved
	cp $0e
	jr nz, .direction

;>         wSignpostMazeStep = 0
	xor a
	ld [wSignpostMazeStep], a
;>         hJingle = 2
	ld a, $02
	ldh [hJingle], a
;>         SignpostMazeOpenStairs()
	push de
	call SignpostMazeOpenStairs
	pop de

.direction
;>     return OpenDialogTable1(mem[SignpostMazeDialogs + i])
	ld hl, SignpostMazeDialogs
	add hl, de
	ld a, [hl]
	jp OpenDialogTable1

.wrong
;> wSignpostMazeStep = 0
	xor a
	ld [wSignpostMazeStep], a
;> wSignpostReadPos = 0
	ld [wSignpostReadPos], a
;> hJingle = 0x1D
	ld a, $1d
	ldh [hJingle], a
;> OpenDialogTable1(0xAD)         # dialogue $1AD: start again
	ld a, $ad
	call OpenDialogTable1

.done
	ret


;@ def SignpostMazeOpenStairs()
;@ path: npc/signpost_maze
;@ The reward of the signpost maze: the room object at row 2, column 8 becomes stairs ($C6, the
;@ warp arrives at position $28), a puff of smoke, the two stair tiles drawn ($68 $77 / $69 $4B,
;@ two 2-tile columns), the staircase armed (hStairsState 1 at x $88, y $30) and bit 4 of the
;@ room's status set, so the stairs stay.
;@ test: skip queues background draws and adds an effect
SignpostMazeOpenStairs::
;> wRoomObjects[0x28] = 0xC6      # stairs
	ld hl, wRoomObjects + $28
	ld [hl], $c6
;> wWarpDestPosition = 0x28
	ld a, $28
	ld [wWarpDestPosition], a
;> hBGPosY = 0x20
	ld a, $20
	ldh [hBGPosY], a
;> hMultiPurpose1 = 0x30
	add $10
	ldh [hMultiPurpose1], a
;> hBGPosX = 0x80
	ld a, $80
	ldh [hBGPosX], a
;> hMultiPurpose0 = 0x88
	add $08
	ldh [hMultiPurpose0], a
;> AddTransientVfx(2)             # smoke
	ld a, $02
	call AddTransientVfx
;> GetBGAddress()                 # -> hBGAddrHigh/Low
	call GetBGAddress
;> n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize = n + 0x0A
	add $0a
	ld [wDrawCommandsSize], a
	ld d, $00
	add hl, de
;>@cmd wDrawCommand[n:n + 11] = [hBGAddrHigh, hBGAddrLow, 0x81, 0x68, 0x77, hBGAddrHigh, hBGAddrLow + 1, 0x81, 0x69, 0x4B, 0]
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
;=@cmd
	ld a, $68
	ld [hli], a
	ld a, $77
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
;=@cmd
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
;=@cmd
	ld a, $69
	ld [hli], a
	ld a, $4b
	ld [hli], a
	ld [hl], $00
;> hStairsState = 1
	ld a, $01
	ldh [hStairsState], a
;> hStairsY = (hBGPosY & 0xF0) + 0x10
	ldh a, [hBGPosY]
	and $f0
	add $10
	ldh [hStairsY], a
;> hStairsX = (hBGPosX & 0xF0) + 8
	ldh a, [hBGPosX]
	and $f0
	add $08
	ldh [hStairsX], a
;> room = hMapRoom
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
;> wRoomStatus[room] |= 0x10
	ld hl, wRoomStatus
	add hl, de
	set 4, [hl]
	ret


;@ path: entity/helpers
;@ Y positions of the 8 spots where the Zora and the zombies may come up: $10-$80 in steps of
;@ $10. Index 0-7 picked at random, paired with EmergeSpotsX.
EmergeSpotsY::
	db $10, $20, $30, $40, $50, $60, $70, $80

;@ path: entity/helpers
;@ X positions of the 8 spots: $18-$88 in steps of $10.
EmergeSpotsX::
	db $18, $28, $38, $48, $58, $68, $78, $88

;@ def ZombieEntityHandler(slot: bc)
;@ path: enemy/zombie
;@ Entity $BF: the zombies. The entity placed in the room is a spawner (wEntityPrivate1 = 0): when
;@ its timer runs out it jumps to a random spot (EmergeSpotsX/Y) and, if the ground there is of
;@ type 0, 6 or 9, waits $40-$7F frames and lets a zombie (up to 5 of them) rise there
;@ (ZombieHandler).
;@ test: skip spawns entities through bank 3
ZombieEntityHandler::
;> if wEntityPrivate1[slot]:      # a zombie
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
;>     return ZombieHandler(slot)
	jp nz, ZombieHandler

;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .done

;> i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntityX[slot] = mem[EmergeSpotsX + i]
	ld hl, EmergeSpotsX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = mem[EmergeSpotsY + i]
	ld hl, EmergeSpotsY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> GetObjectUnderEntity_18(slot)  # ground type -> hMultiPurpose3
	call GetObjectUnderEntity_18
;>@g if hMultiPurpose3 not in (0x00, 0x06, 0x09):
	ldh a, [hMultiPurpose3]
	cp $00
	jr z, .spawn

;=@g
	cp $06
	jr z, .spawn

	cp $09
	jr z, .spawn

;>     return
	ret

.spawn
;> wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x40
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $40
	ld [hl], a
;> z, failed = SpawnEntityFromSlot(slot, 0xBF, 5)     # a new zombie unless 5 are out; position in hMultiPurpose0/1
	ld a, $bf
	ld e, $05
	call SpawnEntityFromSlot
;> if not failed:
	jr c, .done

;>     wEntityX[z] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[z] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[z] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>     wEntityPhysicsFlags[z] &= ~0x40
	ld hl, wEntityPhysicsFlags
	add hl, de
	res 6, [hl]

.done
	ret


;@ path: enemy/zombie
;@ A zombie's sprite pairs by variant: 2 x (tile, attributes). 0: nothing ($FF), 1: $6C and
;@ mirrored (head in the ground), 2: $68 $6A (half out), 3: $60 $62 and 4: $64 $66 (walking).
;@ Drawn by ZombieHandler.
ZombiePairs::
	db $ff, $ff, $ff, $ff, $6c, $00, $6c, $20, $68, $00, $6a, $00, $60, $00, $62, $00
	db $64, $00, $66, $00

;@ def ZombieHandler(slot: bc)
;@ path: enemy/zombie
;@ A zombie (entity $BF with wEntityPrivate1 = 1): it rises from the ground, walks straight at
;@ Link for a while and sinks back.
;@ test: skip runs a state machine with sprite drawing
ZombieHandler::
;> DrawEntity16x16(slot, ZombiePairs)
	ld de, ZombiePairs
	call DrawEntity16x16
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> return ZombieStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/zombie
;@ A zombie's states (wEntityState): 0 ZombieInit, 1 ZombieRise, 2 ZombieWalk, 3 ZombieSink.
ZombieStates::
	dw ZombieInit
	dw ZombieRise
	dw ZombieWalk
	dw ZombieSink

;@ def ZombieInit(slot: bc)
;@ path: enemy/zombie
;@ State 0: rising takes $30 frames.
;@ test: slot = rand(0, 15)
ZombieInit::
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> IncrementEntityState(slot)                    # next state
	call IncrementEntityState
	ret


;@ def ZombieRise(slot: bc)
;@ path: enemy/zombie
;@ State 1: it comes out of the ground (variant 1, then 2 for the last $18 frames); then it walks
;@ at Link for $70-$AF frames with a random speed of 5-12.
;@ test: skip aims at Link through bank 3
ZombieRise::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rising

;>     wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x70
	call GetRandomByte
	and $3f
	add $70
	ld [hl], a
;>     SetEntitySpeedTowardsLink(slot, (GetRandomByte() & 7) + 5)   # speed towards Link
	call GetRandomByte
	and $07
	add $05
	call SetEntitySpeedTowardsLink
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState

.rising
;> v = 1 if t >= 0x18 else 2
	ld e, $01
	cp $18
	jr nc, .set

	inc e

.set
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def ZombieWalk(slot: bc)
;@ path: enemy/zombie
;@ State 2: walks (variants 3 and 4 every 16 frames), stops at walls, hurts Link on contact. When
;@ it bumps into a wall or its time is up it sinks for $30 frames (state 3) and cannot be hit.
;@ test: skip runs collisions through bank 3
ZombieWalk::
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> EntityCheckWalls(slot)                    # stop at walls
	call EntityCheckWalls
;> EntityCheckHits(slot)                    # hurts Link
	call EntityCheckHits
;>@s if wEntityCollisions[slot] & 0x0F or wEntityTimer[slot] == 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, .sink

;=@s
	call GetEntityTimer
	jr nz, .walk

.sink
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     IncrementEntityState(slot)                # next state
	call IncrementEntityState
;>     wEntityPhysicsFlags[slot] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]

.walk
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v + 3)
	add $03
	call SetEntitySpriteVariant
	ret


;@ def ZombieSink(slot: bc)
;@ path: enemy/zombie
;@ State 3: it sinks (variant 2, then 1 for the last $18 frames) and is removed.
;@ test: slot = rand(0, 15)
ZombieSink::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return ClearEntityStatus_18(slot)
	jp z, ClearEntityStatus_18

;> v = 1 if t < 0x18 else 2
	ld e, $01
	cp $18
	jr c, .set

	inc e

.set
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def GetObjectUnderEntity_18(slot: bc) -> a
;@ path: entity/helpers
;@ The room object under the entity's feet (x - 1, y - 7): its square in wRoomObjects (row from
;@ the y high nibble, column from the x high nibble). Leaves x - 1 / y - 7 in hMultiPurpose4/5,
;@ the square's pixel position in hBGPosX/hBGPosY, the object in hRoomObjectType and its physics
;@ type (GetObjectPhysics) in hMultiPurpose3 and a.
;@ test: skip GetObjectPhysics reads its table from another bank
GetObjectUnderEntity_18::
;> x = (wEntityX[slot] - 1) & 0xFF
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
;> y = (wEntityY[slot] - 7) & 0xFF
	swap a
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
;> square = (y & 0xF0) | (x >> 4)
	or c
	ld c, a
	ld b, $00
;>@obj hRoomObjectType = wRoomObjects[square]   # (the low byte only: no carry into the high byte)
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	ld h, a
	pop bc
;=@obj
	ld a, [hl]
	ldh [hRoomObjectType], a
;> hMultiPurpose3 = GetObjectPhysics(wIsIndoor << 8 | hRoomObjectType)
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	ldh [hMultiPurpose3], a
	ret


;@ path: boss/blaino
;@ Blaino's vertical speed towards Link by GetEntityYDistanceToLink_18's direction: 2 (Link
;@ above) -20, 3 (below) +20. BlainoEntityHandler indexes it from BlainoSpeedsY - 2.
BlainoSpeedsY::
	db $ec, $14

;@ def BlainoEntityHandler(slot: bc)
;@ path: boss/blaino
;@ Entity $BE: Blaino, the boxing mini-boss. Between attacks he hops after Link (a hop of speed
;@ $10 each time he lands, sideways at random, and drawn closer when Link is $28 or more away)
;@ and follows him up and down; touching him hurts. His fists block Link's sword (the clash box,
;@ see DrawBlaino). His attacks (wEntityScratch5 1-4, BlainoRunAttack): the jab, the dash
;@ punch and the windmill punch that knocks Link out of the room. While wEntityTimer1 runs, Link
;@ is dazed: frozen in pose $6A with stars circling his head (jingle $33 once).
;@ test: skip runs a boss with sprite drawing and collisions
BlainoEntityHandler::
;> DrawBlaino(slot)
	call DrawBlaino
;> if hActiveEntityStatus == 1:   # beaten
	ldh a, [hActiveEntityStatus]
	cp $01
;>     return BossDeathSequence_18(slot)
	jp z, BossDeathSequence_18

;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> StartBossMusic(slot)                    # the boss music once its delay is over
	call StartBossMusic
;> if not wEntityPrivate1[slot]:  # first frame: the first attack after $20 frames
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .started

;>     wEntityPrivate1[slot] = 1
	inc [hl]
;>     wEntityDropTimer[slot] = 0x20
	call GetEntityDropTimer
	ld [hl], $20

.started
;> if wEntityTimer1[slot]:        # Link is dazed
	call GetEntityTimer1
	jr z, .move

;>     if wLinkPushedTimer == 1:
	ld a, [wLinkPushedTimer]
	and a
	cp $01
	jr nz, .sliding

;>         hJingle = 0x33
	ld hl, hJingle
	ld [hl], $33

.sliding
;>     if wLinkPushedTimer == 0:  # he has stopped sliding
	and a
	jr nz, .move

;>         hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;>         hLinkAnimationState = 0x6A
	ld a, $6a
	ldh [hLinkAnimationState], a
;>         DrawDizzyStars()
	call DrawDizzyStars

.move
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> EntityCheckSwordClash(slot)                    # Link's sword against the clash box
	call EntityCheckSwordClash
;> if wLinkPushedTimer == 0:
	ld a, [wLinkPushedTimer]
	and a
	jr nz, .hop

;>     EntityCheckHits(slot)                # touching him hurts Link
	call EntityCheckHits

.hop
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> EntityCheckWalls(slot)                    # stop at walls
	call EntityCheckWalls
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> wEntitySpeedZ[slot] -= 3       # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80 # fell below the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hMultiPurposeG], a
;> if landed:
	and a
	jr z, .attack

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     ClearEntitySpeed(slot)                # x and y speed to 0
	call ClearEntitySpeed

.attack
;> BlainoRunAttack(slot)          # during an attack: runs it and returns from here
	call BlainoRunAttack
;> dx, e = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> wEntityDirection[slot] = e
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> dy, e = GetEntityYDistanceToLink_18(slot)
	call GetEntityYDistanceToLink_18
;> if dy != 0:
	cp $00
	jr z, .landed

;>     speed = mem[BlainoSpeedsY + (e - 2)]
	ld d, b
	ld hl, BlainoSpeedsY - 2
	add hl, de
	ld a, [hl]
;>     wEntitySpeedY[slot] = speed
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.landed
;> if landed:                     # the next hop
	ldh a, [hMultiPurposeG]
	and a
	jr z, .pick

;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>     wEntitySpeedX[slot] = (GetRandomByte() & 0x0F) - 8
	call GetRandomByte
	and $0f
	sub $08
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     if (dx + 0x28) & 0xFF >= 0x50:   # Link $28 or more away
	call GetEntityXDistanceToLink_18
	add $28
	cp $50
	jr c, .pick

;>         GetVectorTowardsLink(slot, 8)           # speed 8 towards Link: x part in hMultiPurpose1
	ld a, $08
	call GetVectorTowardsLink
;>         wEntitySpeedX[slot] += hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a

.pick
;> BlainoPickAttack(slot)
	call BlainoPickAttack
;> v = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)                   # the guard stance, variants 0 and 1
	call SetEntitySpriteVariant
	ret


;@ def BlainoPickAttack(slot: bc)
;@ path: boss/blaino
;@ Starts Blaino's next attack: the windmill punch (3) at once while Link is dazed; otherwise when
;@ wEntityDropTimer runs out - a jab (1) for the first 4 attacks, then one of 1-4 at random. A jab
;@ plays noise $0A. The attack's step counter (wEntityPrivateCounter) and timer start at 0.
;@ test: skip starts attacks with sounds
BlainoPickAttack::
;> if wEntityTimer1[slot]:        # Link dazed
	call GetEntityTimer1
	jr z, .notDazed

;>     attack = 3
	ld a, $03
	jr .setAttack

.notDazed
;> elif wEntityDropTimer[slot]:
;>     return
	call GetEntityDropTimer
	jr nz, .done

;> elif wEntityPrivate1[slot] < 5:   # the first attacks are jabs
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, .random

;>     wEntityPrivate1[slot] += 1
	inc [hl]
;>     attack = 1
	ld a, $01
	jr .setAttack

.random
;> else:
;>     attack = (GetRandomByte() & 3) + 1
	call GetRandomByte
	and $03
	inc a

.setAttack
;> wEntityScratch5 = attack      # Blaino's current attack
	ld [wEntityScratch5], a
;> if attack == 1:
	cp $01
	jr nz, .reset

;>     hNoiseSfx = 0x0A
	ld a, $0a
	ldh [hNoiseSfx], a

.reset
;> wEntityTimer[slot] = 0
	call GetEntityTimer
	ld [hl], $00
;> wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $00

.done
	ret


;@ def BlainoRunAttack(slot: bc)
;@ path: boss/blaino
;@ Runs Blaino's current attack (wEntityScratch5, 0 = none) and then returns straight from
;@ BlainoEntityHandler (its return address is dropped), so no hopping or aiming meanwhile.
;@ test: skip drops its caller's return address
BlainoRunAttack::
;> attack = wEntityScratch5
	ld a, [wEntityScratch5]
	and a
;> if attack == 0:
;>     return
	ret z

;> drop_caller_return()
	pop de
;> return BlainoAttacks[attack - 1](slot)
	dec a
	rst $00

;@ path: boss/blaino
;@ Blaino's attacks by wEntityScratch5 - 1: 1 BlainoJab, 2 BlainoDashPunch, 3 BlainoWindmillPunch,
;@ 4 BlainoJab again (so jabs come up twice as often at random).
BlainoAttacks::
	dw BlainoJab
	dw BlainoDashPunch
	dw BlainoWindmillPunch
	dw BlainoJab

;@ path: boss/blaino
;@ The jab: one sprite variant per frame for 13 frames (arm drawn back, punch, back again).
BlainoJabFrames::
	db $01, $01, $01, $02, $02, $03, $03, $03, $03, $03, $02, $02, $01

;@ def BlainoJab(slot: bc)
;@ path: boss/blaino
;@ Attack 1 (and 4): plays BlainoJabFrames one frame each. Afterwards he jabs again 3 times in 4,
;@ otherwise the attack ends (BlainoEndAttack).
;@ test: skip sets the sprite variant through bank 0
BlainoJab::
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .wait

;> step = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> if step != 13:
	cp $0d
	jp z, .next

;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;>     SetEntitySpriteVariant(slot, mem[BlainoJabFrames + step])
	ld e, a
	ld d, b
	ld hl, BlainoJabFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>     wEntityTimer[slot] = 1
	call GetEntityTimer
	ld [hl], $01

.wait
;>     return
	ret

.next
;> if GetRandomByte() & 3 == 0:
	call GetRandomByte
	and $03
;>     return BlainoEndAttack(slot)
	jp z, BlainoEndAttack

;> return BlainoPickAttack.setAttack(1)   # another jab
	ld a, $01
	jp BlainoPickAttack.setAttack


;@ path: boss/blaino
;@ The dash punch, 21 steps of 3 frames: the sprite variant of each step (4 crouch, 5 held,
;@ 6-8 the lunge with the fist out, back to 1).
BlainoDashFrames::
	db $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $07, $08, $08, $08
	db $08, $08, $07, $06, $01

;@ path: boss/blaino
;@ The dash punch's x speed of each step, signed, for Link on the left (negated when he is on the
;@ right): a step back (+), a pause, then the lunge at him (-4 ... -112), then a stop.
BlainoDashSpeeds::
	db $08, $10, $08, $08, $02, $00, $00, $00, $fc, $f8, $f0, $f8, $e0, $90, $a0, $00
	db $00, $00, $00, $00, $00

;@ def BlainoDashPunch(slot: bc)
;@ path: boss/blaino
;@ Attack 2: every 3 frames the next step of BlainoDashFrames / BlainoDashSpeeds (the speed
;@ mirrored towards Link's side); after 21 steps the attack ends.
;@ test: skip sets the sprite variant through bank 0
BlainoDashPunch::
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .wait

;> step = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> if step == 21:
	cp $15
;>     return BlainoEndAttack(slot)
	jp z, BlainoEndAttack

;> wEntityPrivateCounter[slot] += 1
	inc [hl]
;> SetEntitySpriteVariant(slot, mem[BlainoDashFrames + step])
	ld e, a
	ld d, b
	ld hl, BlainoDashFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> speed = mem[BlainoDashSpeeds + step]
	ld hl, BlainoDashSpeeds
	add hl, de
	ld e, [hl]
;> if wEntityDirection[slot] == 0:   # Link on the right
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .set

;>     speed = -speed & 0xFF
	ld a, e
	cpl
	inc a
	ld e, a

.set
;> wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> wEntityTimer[slot] = 3
	call GetEntityTimer
	ld [hl], $03

.wait
	ret


;@ path: boss/blaino
;@ The windmill punch, 42 steps of 3 frames: the sprite variant of each step (9-12 the arm swinging
;@ round, 4 times over, then 9 held, 13-17 the big punch, back to 1).
BlainoPunchFrames::
	db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $09, $09, $0a, $0a, $0b, $0b, $0c, $0c
	db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $0d, $0e, $0f, $10, $11, $11, $11, $01

;@ path: boss/blaino
;@ The windmill punch's x speed of each step, signed, for Link on the left (negated when he is on
;@ the right): backing off (+12, +8) while winding up, still, then the lunge (-16 ... -64) with
;@ the punch.
BlainoPunchSpeeds::
	db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $08, $08, $08, $08, $08, $08, $08, $08
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $f0, $e0, $d0, $c0, $c0, $e0, $f0, $00, $00, $00

;@ def BlainoWindmillPunch(slot: bc)
;@ path: boss/blaino
;@ Attack 3: every 3 frames the next step of BlainoPunchFrames / BlainoPunchSpeeds. At step $28 it
;@ holds while Link is in motion state $0A (flung away by the punch). While Link is dazed and $30
;@ or more away, the first $18 steps also home in on him at speed $10. After 42 steps the attack
;@ ends.
;@ test: skip sets the sprite variant through bank 0
BlainoWindmillPunch::
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .wait

;> step = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> if step == 42:
	cp $2a
;>     return BlainoEndAttack(slot)
	jp z, BlainoEndAttack

;> if step != 0x28 or wLinkMotionState != 0x0A:
	ld e, a
	cp $28
	jr nz, .advance

	ld a, [wLinkMotionState]
	cp $0a
	jr z, .frame

.advance
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]

.frame
;> SetEntitySpriteVariant(slot, mem[BlainoPunchFrames + step])
	ld d, b
	ld hl, BlainoPunchFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> speed = mem[BlainoPunchSpeeds + step]
	ld hl, BlainoPunchSpeeds
	add hl, de
	ld e, [hl]
;> if wEntityDirection[slot] == 0:   # Link on the right
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .set

;>     speed = -speed & 0xFF
	ld a, e
	cpl
	inc a
	ld e, a

.set
;> wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;>@home if wEntityTimer1[slot] and (dx + 0x30) & 0xFF >= 0x60 and wEntityPrivateCounter[slot] < 0x18:
	call GetEntityTimer1
	jr z, .next

;=@home
	call GetEntityXDistanceToLink_18
	add $30
	cp $60
	jr c, .next

;=@home
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $18
	jr nc, .next

;>     SetEntitySpeedTowardsLink(slot, 0x10)            # straight at Link
	ld a, $10
	call SetEntitySpeedTowardsLink

.next
;> wEntityTimer[slot] = 3
	call GetEntityTimer
	ld [hl], $03

.wait
	ret


;@ def BlainoEndAttack(slot: bc)
;@ path: boss/blaino
;@ Ends Blaino's attack; the next one comes after $0C-$1B frames (wEntityDropTimer).
;@ test: skip runs the entity drop timer
BlainoEndAttack::
;> wEntityScratch5 = 0
	xor a
	ld [wEntityScratch5], a
;> wEntityDropTimer[slot] = (GetRandomByte() & 0x0F) + 0x0C
	call GetEntityDropTimer
	call GetRandomByte
	and $0f
	add $0c
	ld [hl], a
	ret


;@ path: boss/blaino
;@ Blaino's 18 sprite frames by sprite variant, 24 bytes each: 6 sprites of (dy, dx, tile,
;@ attributes), facing left (DrawBlaino mirrors them when Link is on the right). Tiles $6C/$6E
;@ are the boxing gloves (the first sprite is the fist that blocks the sword), $60/$62, $64/$66
;@ and $68/$6A his body; tile $FF hides that sprite. 0-1 guard, 1-3 jab, 4-8 dash punch, 9-12
;@ arm swinging round, 13-17 the windmill punch.
BlainoSprites::
	; 0
	db $00, $f8, $6c, $00, $00, $00, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 1
	db $ff, $f8, $6c, $00, $ff, $00, $6e, $00
	db $00, $00, $64, $00, $00, $08, $66, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 2
	db $00, $f8, $6e, $20, $00, $00, $6c, $20
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $fd, $f8, $6c, $00, $fd, $00, $6e, $00
	; 3
	db $fd, $f0, $6c, $00, $fd, $f8, $6e, $00
	db $00, $f8, $6e, $20, $00, $00, $6c, $20
	db $00, $00, $60, $00, $00, $08, $62, $00
	; 4
	db $00, $00, $6e, $20, $00, $08, $6c, $20
	db $00, $00, $64, $00, $00, $08, $66, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 5
	db $fd, $08, $6e, $20, $fd, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 6
	db $00, $f8, $6c, $00, $00, $00, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00
	; 7
	db $00, $f0, $6c, $00, $00, $f8, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00
	; 8
	db $00, $e8, $6c, $00, $00, $f0, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00
	; 9
	db $f8, $10, $6c, $00, $f8, $18, $6e, $00
	db $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 10
	db $f0, $08, $6c, $00, $f0, $10, $6e, $00
	db $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 11
	db $fc, $08, $6e, $20, $fc, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 12
	db $00, $10, $6e, $20, $00, $18, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 13
	db $04, $08, $6e, $20, $04, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	; 14
	db $08, $00, $6c, $00, $08, $08, $6e, $00
	db $00, $00, $64, $00, $00, $08, $66, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00
	; 15
	db $08, $f8, $6c, $00, $08, $00, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00
	; 16
	db $05, $f0, $6c, $00, $05, $f8, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00
	; 17
	db $f4, $f0, $6e, $20, $f4, $f8, $6c, $20
	db $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00

;@ def DrawBlaino(slot: bc)
;@ path: boss/blaino
;@ Draws Blaino's frame (BlainoSprites[hActiveEntitySpriteVariant], 6 sprites), mirrored with
;@ x flip when Link is on the right, shifted by the screen shake; a sprite with tile $FF is moved
;@ off screen (y = 0). The first sprite - the leading fist - also becomes the sword clash box
;@ (wClashBoxX/Y, half size 8 x 4). Then the shadow.
;@ test: skip writes OAM through bank 0
DrawBlaino::
;> wClashBoxX = 0x80              # not set yet
	ld a, $80
	ld [wClashBoxX], a
;> wClashBoxY = 0x80
	ld [wClashBoxY], a
;>@frame frame = hActiveEntitySpriteVariant * 24
	ldh a, [hActiveEntitySpriteVariant]
	sla a
	sla a
	ld d, b
	sla a
	ld e, a
;=@frame
	rl d
	sla a
	rl d
	add e
	ld e, a
	ld a, d
;=@frame
	adc $00
	ld d, a
;> mirror = 0
	xor a
	ldh [hMultiPurposeG], a
;> if wEntityDirection[slot] == 0:   # Link on the right
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw

;>     mirror = 1
	inc a
	ldh [hMultiPurposeG], a
;>     hActiveEntityFlipAttribute |= 0x20
	ld hl, hActiveEntityFlipAttribute
	set 5, [hl]

.draw
;> src = BlainoSprites + frame
	ld hl, BlainoSprites
	add hl, de
	ld c, $06
;>@oam oam = wOAMBuffer + wOAMNextIndex
	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
;=@oam
	push hl
	pop de
	pop hl
;>@vis SkipDrawIfOffscreen(slot)                # off screen during a room transition: returns from DrawBlaino
	ld a, c
	ldh [hMultiPurpose0], a
	ld a, [wActiveEntitySlot]
	ld c, a
	call SkipDrawIfOffscreen
;=@vis
	ldh a, [hMultiPurpose0]
	ld c, a

.loop
;>@loop for dy, dx, tile, attr in src[0:6]:
;>     if wClashBoxY == 0x80:
	ld a, [wClashBoxY]
	cp $80
	jr nz, .y

;>         wClashBoxY = dy + 8
	ld a, [hl]
	add $08
	ld [wClashBoxY], a

.y
;>     oam.y = hActiveEntityDrawY + dy
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ld [de], a
	inc hl
	inc de
;>     shake = wScreenShakeX
	push bc
	ld a, [wScreenShakeX]
	ld c, a
	ld b, [hl]
;>     if mirror:
	ldh a, [hMultiPurposeG]
	and a
	jr z, .box

;>         dx = (8 - dx) & 0xFF
	ld a, b
	cpl
	inc a
	add $08
	ld b, a

.box
;>     if wClashBoxX == 0x80:
	ld a, [wClashBoxX]
	cp $80
	jr nz, .x

;>         wClashBoxX = dx if mirror else dx + 8
	ldh a, [hMultiPurposeG]
	and a
	ld a, b
	jr nz, .setBoxX

	add $08

.setBoxX
	ld [wClashBoxX], a

.x
;>     oam.x = hActiveEntityX + dx - wScreenShakeX
	ldh a, [hActiveEntityX]
	add b
	sub c
	ld [de], a
	inc hl
	inc de
;>     oam.tile = tile
	pop bc
	ld a, [hli]
	ld [de], a
;>     if tile == 0xFF:
	cp $ff
	jr nz, .attr

;>         oam.y = 0              # hidden
	dec de
	xor a
	ld [de], a
	inc de

.attr
;>     oam.attr = hActiveEntityFlipAttribute ^ attr
	inc de
	ldh a, [hActiveEntityFlipAttribute]
	xor [hl]
	inc hl
	ld [de], a
	inc de
;=@loop
	dec c
	jr nz, .loop

;> wClashBoxHalfWidth = 8
	ld a, $08
	ld [wClashBoxHalfWidth], a
;> wClashBoxHalfHeight = 4
	ld a, $04
	ld [wClashBoxHalfHeight], a
;> ReserveOAMEntriesFar(6)                   # claim the 6 OAM entries
	ld a, [wActiveEntitySlot]
	ld c, a
	ld a, $06
	call ReserveOAMEntriesFar
;> return DrawEntityShadow(slot)             # the shadow
	jp DrawEntityShadow


;@ path: boss/blaino
;@ The y offsets of the 8 positions of a dizzy star circling Link's head (0, -2, -3, -2, 0, 2,
;@ 3, 2), one every 8 frames.
DizzyStarOffsetsY::
	db $00, $fe, $fd, $fe, $00, $02, $03, $02

;@ path: boss/blaino
;@ The matching x offsets (0, 4, 8, 12, 16, 12, 8, 4): together an ellipse.
DizzyStarOffsetsX::
	db $00, $04, $08, $0c, $10, $0c, $08, $04

;@ def DrawDizzyStars()
;@ path: boss/blaino
;@ Two stars (tile $24) circling Link's head on opposite sides of the ellipse, in OAM entries 4
;@ and 5.
;@ test: skip writes OAM
DrawDizzyStars::
;> oam = wOAMBuffer + 0x10
	ld hl, wOAMBuffer + $10
;> p = hFrameCounter >> 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
;> DrawDizzyStar(p & 7)
	push af
	and $07
	call DrawDizzyStar
;> DrawDizzyStar((p + 4) & 7)     # falls through
	pop af
	add $04
	and $07

;@ def DrawDizzyStar(pos: a, oam: hl)
;@ path: boss/blaino
;@ One dizzy star at position `pos` (0-7) of DizzyStarOffsetsY/X, written to the OAM entry at hl
;@ (hl moves on to the next entry).
;@ test: skip writes OAM
DrawDizzyStar::
;>@y oam.y = hLinkY + mem[DizzyStarOffsetsY + pos] - 10
	push bc
	push hl
	ld e, a
	ld d, $00
	ld hl, DizzyStarOffsetsY
	add hl, de
;=@y
	ld b, [hl]
;> dx = mem[DizzyStarOffsetsX + pos]
	ld hl, DizzyStarOffsetsX
	add hl, de
	ld c, [hl]
	pop hl
;=@y
	ldh a, [hLinkY]
	add b
	add $f6
	ld [hli], a
;> oam.x = hLinkX + dx - 4
	ldh a, [hLinkX]
	add c
	add $fc
	ld [hli], a
;> oam.tile = 0x24
	ld [hl], $24
	inc hl
;> oam.attr = 0
	ld [hl], $00
	inc hl
	pop bc
	ret


;@ def VireEntityHandler(slot: bc)
;@ path: boss/vire
;@ Entity $BD: Vire, the winged demon mini-boss, and what he leaves behind. wEntityPrivate1 tells
;@ which: 0 Vire himself, 1 one of the two bats he splits into when beaten (VireBatHandler),
;@ 2 one of his fireballs (VireFireballHandler). Beaten (status 1), Vire bursts in a puff and
;@ splits into two bats flying off left and right; his defeat is counted (DefeatEntity).
;@ test: skip spawns entities and adds an effect
VireEntityHandler::
;> kind = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if kind == 2:
	cp $02
;>     return VireFireballHandler(slot)
	jp z, VireFireballHandler

;> if kind != 0:
	and a
;>     return VireBatHandler(slot)
	jp nz, VireBatHandler

;> if hActiveEntityStatus != 1:   # alive
	ldh a, [hActiveEntityStatus]
	cp $01
;>     return VireMain(slot)
	jr nz, VireMain

;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)             # a puff of smoke
	ld a, $02
	call AddTransientVfx
;> hMultiPurposeG = 0x0C     # speed of the first bat
	ld a, $0c
	ldh [hMultiPurposeG], a
;> VireSpawnBat(slot)
	call VireSpawnBat
;> hMultiPurposeG = 0xF4     # the second flies the other way
	ld a, $f4
	ldh [hMultiPurposeG], a
;> VireSpawnBat(slot)
	call VireSpawnBat
;> DefeatEntity(slot)                    # counts the defeat
	call DefeatEntity
;> return ClearEntityStatus_18(slot)
	jp ClearEntityStatus_18


;@ def VireSpawnBat(slot: bc)
;@ path: boss/vire
;@ Spawns one of Vire's bats (entity $BD, wEntityPrivate1 = 1) at hMultiPurpose0/1, height
;@ hMultiPurpose3, x speed hMultiPurposeG, 1 health, waiting $20 frames; it shares Vire's
;@ load order (so it counts as part of him).
;@ test: skip spawns an entity
VireSpawnBat::
;> bat, failed = SpawnEntity(slot, 0xBD)
	ld a, $bd
	call SpawnEntity
;> if not failed:
	jr c, .done

;>     wEntityLoadOrder[bat] = wEntityLoadOrder[slot]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	ld hl, wEntityLoadOrder
	add hl, de
	ld [hl], a
;>     wEntityX[bat] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[bat] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[bat] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[bat] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>     wEntitySpeedX[bat] = hMultiPurposeG
	ldh a, [hMultiPurposeG]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntityTimer[bat] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
;>     wEntityHealth[bat] = 1
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $01

.done
	ret


;@ def VireMain(slot: bc)
;@ path: boss/vire
;@ Vire alive: draws him; when he has followed Link into another room he is removed once he is
;@ off its edges (x >= $98 or y >= $70). Then his flight (both speeds and height) and his state.
;@ test: skip runs a state machine with sprite drawing
VireMain::
;> DrawVire(slot)
	call DrawVire
;> if hMapRoom != wEntityRoom[slot]:
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	cp [hl]
	jr z, .update

;>     if hActiveEntityX >= 0x98:
	ldh a, [hActiveEntityX]
	cp $98
;>         return ClearEntityStatus_18(slot)
	jp nc, ClearEntityStatus_18

;>     if hActiveEntityDrawY >= 0x70:
	ldh a, [hActiveEntityDrawY]
	cp $70
;>         return ClearEntityStatus_18(slot)
	jp nc, ClearEntityStatus_18

.update
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> return VireStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/vire
;@ Vire's states (wEntityState): 0 VireInit, 1 VireFly, 2 VireDiveStart, 3 VireSwoop,
;@ 4 VireWaitHidden, 5 VireReturn, 6 VireHit, 7 VireBreatheFire.
VireStates::
	dw VireInit
	dw VireFly
	dw VireDiveStart
	dw VireSwoop
	dw VireWaitHidden
	dw VireReturn
	dw VireHit
	dw VireBreatheFire

;@ def VireInit(slot: bc)
;@ path: boss/vire
;@ State 0: 3 health; he starts flying to the right (x speed 8); the first dive comes after $80
;@ frames (wEntityDropTimer), the first fire after $C0.
;@ test: slot = rand(0, 15)
VireInit::
;> wEntityHealth[slot] = 3
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $03
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> wEntityDropTimer[slot] = 0x80
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], $80
;> ClearEntitySpeed(slot)                    # x and y speed to 0
	call ClearEntitySpeed
;> wEntitySpeedX[slot] = 8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ path: boss/vire
;@ Vire's new speed after bumping into a wall while flying (VireFly): +8, -8. A side wall (collision
;@ bits 0-1 = 1 or 2) gives the y speed VireWallSpeeds[bits + 1], a wall above or below (bits
;@ 2-3) the x speed VireWallSpeeds[bits - 1]; the other speed becomes 0.
VireWallSpeeds::
	db $08, $f8, $08, $f8

;@ def VireFly(slot: bc)
;@ path: boss/vire
;@ State 1: he flies about at height $28, turning along the walls, wings flapping. Every $40-$BF
;@ frames he opens his mouth for $10 frames and breathes two fireballs halfway. He dodges Link's
;@ arrows, bombs and hookshot (VireDodge). If Link comes close (within $1C sideways, $20 up or
;@ down) he flees (state 3, speed $10 away); when wEntityDropTimer runs out he dives (state 2,
;@ after $20 frames).
;@ test: skip runs collisions and spawns entities
VireFly::
;> VireCheckWalls(slot)
	call VireCheckWalls
;>@near if (dx + 0x1C) & 0xFF < 0x38 and (dy + 0x20) & 0xFF < 0x40:   # Link close
	call GetEntityXDistanceToLink_18
	add $1c
	cp $38
	jr nc, .dive

;=@near
	call GetEntityDrawYDistanceToLink_18
	add $20
	cp $40
	jr nc, .dive

;>     GetVectorTowardsLink(slot, 0x10)            # speed $10 towards Link -> hMultiPurpose0/1
	ld a, $10
	call GetVectorTowardsLink
;>     wEntitySpeedY[slot] = -hMultiPurpose0 & 0xFF   # away from him
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = -hMultiPurpose1 & 0xFF
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>     wEntityPrivate2[slot] = 0xFF   # fleeing
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $ff

.dive
;> if wEntityDropTimer[slot] == 0:
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .fly

;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     return
	ret

.fly
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;> z = wEntityZ[slot] - 0x28
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub $28
;> if z != 0:                     # back to height $28
	jr z, .walls

;>     dz = 8 if z < 0 else -8
	ld e, $08
	and $80
	jr nz, .setZ

	ld e, $f8

.setZ
;>     wEntitySpeedZ[slot] = dz
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], e

.walls
;> side = wEntityCollisions[slot] & 3
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
;> if side:
	jr z, .floor

;>@sy     wEntitySpeedY[slot] = mem[VireWallSpeeds + side + 1]
	ld e, a
	ld d, b
	ld hl, VireWallSpeeds + 1
	add hl, de
	ld a, [hl]
;=@sy
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $00

.floor
;> ends = (wEntityCollisions[slot] >> 2) & 3
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $03
;> if ends:
	jr z, .fire

;>@sx     wEntitySpeedX[slot] = mem[VireWallSpeeds + (ends - 1)]
	ld e, a
	ld d, b
	ld hl, VireWallSpeeds - 1
	add hl, de
	ld a, [hl]
;=@sx
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $00

.fire
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .mouth

;>     wEntityTimer[slot] = (GetRandomByte() & 0x7F) + 0x40
	call GetRandomByte
	and $7f
	add $40
	ld [hl], a
;>     wEntityTimer1[slot] = 0x10 # mouth open
	ld hl, wEntityTimer1
	add hl, bc
	ld [hl], $10

.mouth
;> t = wEntityTimer1[slot]
	ld hl, wEntityTimer1
	add hl, bc
	ld a, [hl]
;> if t:
	and a
	jr z, .dodge

;>     if t == 8:
	cp $08
	jr nz, .open

;>         VireShootFireballs(slot)
	call VireShootFireballs

.open
;>     return SetEntitySpriteVariant(slot, 2)   # mouth open
	ld a, $02
	jp SetEntitySpriteVariant

.dodge
;> VireDodge(slot)                # falls through
	call VireDodge

;@ def VireAnimate()
;@ path: boss/vire
;@ Vire's wings flap: sprite variant 0 and 1, switching every 8 frames.
;@ test: skip sets the sprite variant through bank 0
VireAnimate::
;> v = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)
	call SetEntitySpriteVariant
	ret


;@ def VireDiveStart(slot: bc)
;@ path: boss/vire
;@ State 2: he hovers with his mouth open for the timer, then dives at Link (speed $20, aimed $14
;@ above him, dropping at speed -20) for at most $30 frames (state 3). wEntityPrivate2 picks how
;@ he pulls out of it: 0 (1 in 4) after $10 frames, 1-3 not before he is up again.
;@ test: skip aims at Link through bank 3
VireDiveStart::
;> if wEntityTimer[slot]:
	call GetEntityTimer
	jr nz, .hover

;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>     y = hLinkY
	ldh a, [hLinkY]
	push af
;>     hLinkY = y - 0x14
	sub $14
	ldh [hLinkY], a
;>     SetEntitySpeedTowardsLink(slot, 0x20)            # aim
	ld a, $20
	call SetEntitySpeedTowardsLink
;>     hLinkY = y
	pop af
	ldh [hLinkY], a
;>     wEntitySpeedZ[slot] = -20 & 0xFF
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $ec
;>     wEntityDropTimer[slot] = 0x30
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], $30
;>     wEntityPrivate2[slot] = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;>     if wEntityPrivate2[slot] == 0:
	and a
	jr nz, .done

;>         wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10

.done
;>     return
	ret

.hover
;> VireStop(slot)
	call VireStop
;> SetEntitySpriteVariant(slot, 2)      # mouth open
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ def VireSwoop(slot: bc)
;@ path: boss/vire
;@ State 3: the dive and the climb back. A sword swing while he is close (within $18) and not
;@ just hit makes him spring back (speed $20, state 6). Fleeing (wEntityPrivate2 $FF), or after
;@ the dive time (wEntityPrivate2 0 and the timer out), he steers away from Link (by 2 per frame
;@ and axis). He climbs back (Z speed +1 every other frame) up to height $40; touching him hurts
;@ meanwhile. When wEntityDropTimer runs out, or he has left the room downwards, he hides
;@ (state 4, invisible, $20-$5F frames).
;@ test: skip aims at Link through bank 3
VireSwoop::
;>@sw if wEntityPrivate2[slot] != 0xFF and (dx + 0x18) & 0xFF < 0x30 and (dy + 0x18) & 0xFF < 0x30 and not wEntityFlashTimer[slot] and wSwordAnimationState:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .steer

;=@sw
	call GetEntityXDistanceToLink_18
	add $18
	cp $30
	jr nc, .steer

;=@sw
	call GetEntityDrawYDistanceToLink_18
	add $18
	cp $30
	jr nc, .steer

;=@sw
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .steer

;=@sw
	ld a, [wSwordAnimationState]
	and a
	jr z, .steer

;>     GetVectorTowardsLink(slot, 0x20)
	ld a, $20
	call GetVectorTowardsLink
;>     wEntitySpeedY[slot] = -hMultiPurpose0 & 0xFF   # away from Link
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = -hMultiPurpose1 & 0xFF
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntityTimer[slot] = 0x0B
	call GetEntityTimer
	ld [hl], $0b
;>     wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
;>     return
	ret

.steer
;>@st if wEntityPrivate2[slot] == 0xFF or (wEntityPrivate2[slot] == 0 and wEntityTimer[slot] == 0):
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .away

;=@st
	and a
	jr nz, .climb

	call GetEntityTimer
	jr nz, .climb

.away
;>     GetVectorTowardsLink(slot, 0x20)
	ld a, $20
	call GetVectorTowardsLink
;>     target = -hMultiPurpose0 & 0xFF
	ldh a, [hMultiPurpose0]
	cpl
	inc a
;>@ay     wEntitySpeedY[slot] += 2 if (target - wEntitySpeedY[slot]) & 0x80 == 0 else -2
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	and $80
	jr nz, .downY

;=@ay
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

.downY
;=@ay
	dec [hl]
	dec [hl]
;>     target = -hMultiPurpose1 & 0xFF
	ldh a, [hMultiPurpose1]
	cpl
	inc a
;>@ax     wEntitySpeedX[slot] += 2 if (target - wEntitySpeedX[slot]) & 0x80 == 0 else -2
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	and $80
	jr nz, .downX

;=@ax
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

.downX
;=@ax
	dec [hl]
	dec [hl]

.climb
;>@hi if wEntityZ[slot] >= 0x40 and wEntitySpeedZ[slot] & 0x80 == 0:   # high enough
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $40
	jr c, .rise

;=@hi
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .rise

;>     wEntitySpeedZ[slot] = 0
	ld [hl], b
	jr .leave

.rise
;> else:
;>     if hFrameCounter & 1 == 0:
	ld hl, wEntitySpeedZ
	add hl, bc
	ldh a, [hFrameCounter]
	and $01
	jr nz, .checkZ

;>         wEntitySpeedZ[slot] += 1
	inc [hl]

.checkZ
;>     if wEntitySpeedZ[slot] & 0x80:   # still going down
	ld a, [hl]
	and $80
;>         return VireTouchLink(slot)
	jr nz, VireTouchLink

.leave
;>@lv if wEntityDropTimer[slot] and hActiveEntityX < 0xA8 and not 0x90 <= hActiveEntityDrawY < 0xC0: return VireTouchLink(slot)
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .hide

;=@lv
	ldh a, [hActiveEntityX]
	cp $a8
	jr nc, .hide

;=@lv
	ldh a, [hActiveEntityDrawY]
	cp $90
	jr c, VireTouchLink

	cp $c0
	jr nc, VireTouchLink

.hide
;> wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;> VireStop(slot)
	call VireStop
;> wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x20
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $20
	ld [hl], a
;> return SetEntitySpriteVariant(slot, 0xFF)   # invisible
	ld a, $ff
	jp SetEntitySpriteVariant


;@ def VireTouchLink(slot: bc)
;@ path: boss/vire
;@ Touching Vire hurts Link. If Link's hit has just landed (wEntityFlashTimer) he stops and
;@ flees (wEntityPrivate2 = $FF); otherwise he keeps dodging and flapping.
;@ test: skip runs collisions through bank 3
VireTouchLink::
;> EntityCheckHits(slot)                    # hurts Link
	call EntityCheckHits
;> if wEntityFlashTimer[slot]:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .dodge

;>     ClearEntitySpeed(slot)                # x and y speed to 0
	call ClearEntitySpeed
;>     wEntityPrivate2[slot] = 0xFF
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $ff
;>     return
	ret

.dodge
;> VireDodge(slot)
	call VireDodge
;> return VireAnimate()
	jp VireAnimate


;@ def VireStop(slot: bc)
;@ path: boss/vire
;@ Vire stops: x, y and Z speed 0.
;@ test: slot = rand(0, 15)
VireStop::
;> ClearEntitySpeed(slot)                    # x and y speed to 0
	call ClearEntitySpeed
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ret


;@ path: boss/vire
;@ The y positions of the 8 places just outside the room from which Vire flies back in (index
;@ 0-7 at random, paired with VireReappearX): the top ($00), the bottom ($D0, wrapped round) and
;@ the sides ($40, $80).
VireReappearY::
	db $00, $00, $d0, $d0, $40, $40, $80, $80

;@ path: boss/vire
;@ The matching x positions: $08, $98, $38, $78 (top and bottom) and $F8, $A8 (left and right
;@ outside).
VireReappearX::
	db $08, $98, $38, $78, $f8, $a8, $f8, $a8

;@ def VireWaitHidden(slot: bc)
;@ path: boss/vire
;@ State 4: hidden; when the timer runs out he appears at a random place outside the room
;@ (VireReappearY/X) at height $28 and flies back in (state 5).
;@ test: slot = rand(0, 15)
VireWaitHidden::
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .done

;> wEntityZ[slot] = 0x28
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $28
;> wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;> i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntityY[slot] = mem[VireReappearY + i]
	ld hl, VireReappearY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityX[slot] = mem[VireReappearX + i]
	ld hl, VireReappearX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a

.done
;> return
	ret


;@ def VireReturn(slot: bc)
;@ path: boss/vire
;@ State 5: he flies at Link (speed 8) until he is well inside the room (x $09-$96, y $20-$6F);
;@ then he turns round (both speeds negated) and flies about again (state 1), the next dive
;@ after $20-$5F frames.
;@ test: skip aims at Link through bank 3
VireReturn::
;> SetEntitySpeedTowardsLink(slot, 8)                   # aim at Link
	ld a, $08
	call SetEntitySpeedTowardsLink
;>@in if 0x09 <= hActiveEntityX < 0x97 and 0x20 <= hActiveEntityDrawY < 0x70:
	ldh a, [hActiveEntityX]
	cp $09
	jr c, .flap

	cp $97
	jr nc, .flap

;=@in
	ldh a, [hActiveEntityDrawY]
	cp $20
	jr c, .flap

	cp $70
	jr nc, .flap

;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     wEntityDropTimer[slot] = (GetRandomByte() & 0x3F) + 0x20
	ld hl, wEntityDropTimer
	add hl, bc
	call GetRandomByte
	and $3f
	add $20
	ld [hl], a
;>     wEntitySpeedX[slot] = -wEntitySpeedX[slot] & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     wEntitySpeedY[slot] = -wEntitySpeedY[slot] & 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.flap
;> return VireAnimate()
	jp VireAnimate


;@ path: boss/vire
;@ Speed of Vire's fireballs by direction 0-15 (a circle of radius $18, as GetSpeedDirection16_18
;@ counts directions): the y speed is VireFireballSpeeds[d], the x speed VireFireballSpeeds[d + 4]
;@ (hence the 4 repeated bytes at the end).
VireFireballSpeeds::
	db $00, $09, $12, $15, $18, $15, $12, $09, $00, $f7, $ee, $eb, $e8, $eb, $ee, $f7
	db $00, $09, $12, $15

;@ def VireHit(slot: bc)
;@ path: boss/vire
;@ State 6: springing back from Link's sword (touching him still hurts for the first frames);
;@ then he stops and breathes fire (state 7, $20 frames).
;@ test: skip runs collisions through bank 3
VireHit::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .moving

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] = 7
	call IncrementEntityState
	ld [hl], $07
;>     return VireStop(slot)
	jp VireStop

.moving
;> if t >= 8:
	cp $08
	jr c, .flap

;>     VireTouchLink(slot)
	call VireTouchLink

.flap
;> return VireAnimate()
	jp VireAnimate


;@ def VireBreatheFire(slot: bc)
;@ path: boss/vire
;@ State 7: mouth open; at 8 frames before the end he breathes two fireballs. Then he flees
;@ (state 3 with wEntityPrivate2 = $FF).
;@ test: skip spawns entities
VireBreatheFire::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .breathe

;>     wEntityPrivate2[slot] = 0xFF
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $ff
;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>     return
	ret

.breathe
;> if t != 8:
	cp $08
;>     return VireOpenMouth()
	jp nz, VireOpenMouth

;> VireShootFireballs(slot)       # falls through

;@ def VireShootFireballs(slot: bc)
;@ path: boss/vire
;@ Vire breathes fire (noise $0D): two fireballs in neighbouring directions of the 16, aimed at
;@ a point 8 pixels above Link.
;@ test: skip spawns entities
VireShootFireballs::
;> hNoiseSfx = 0x0D
	ld a, $0d
	ldh [hNoiseSfx], a
;> y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = y - 8
	sub $08
	ldh [hLinkY], a
;> GetVectorTowardsLink(slot, 0x1F)                # speed towards that point -> hMultiPurpose0/1
	ld a, $1f
	call GetVectorTowardsLink
;> hLinkY = y
	pop af
	ldh [hLinkY], a
;> hMultiPurposeG = GetSpeedDirection16_18() & 0x0F
	call GetSpeedDirection16_18
	and $0f
	ldh [hMultiPurposeG], a
;> VireShootFireball(slot, 0)
	ld e, $00
	call VireShootFireball
;> VireShootFireball(slot, 1)           # falls through: the next direction
	ld e, $01

;@ def VireShootFireball(slot: bc, turn: e)
;@ path: boss/vire
;@ Turns the fireball direction (hMultiPurposeG) by `turn` and, unless 3 fireballs are
;@ already out, spawns one (entity $BD, wEntityPrivate1 = 2) at the spawner's position raised by
;@ hMultiPurpose3, speed VireFireballSpeeds by that direction, physics flags 2, $4C in its health
;@ byte, $20 frames before it checks walls.
;@ test: skip spawns an entity
VireShootFireball::
;> hMultiPurposeG = (hMultiPurposeG + turn) & 0x0F
	ldh a, [hMultiPurposeG]
	add e
	and $0f
	ldh [hMultiPurposeG], a
;> n = 0
	ld e, $0f
	ld d, b

.count
;>@cnt for i in range(15, -1, -1):
;>     if wEntityStatus[i] and wEntityType[i] == 0xBD and wEntityPrivate1[i] == 2:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

;=@cnt
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $bd
	jr nz, .next

;=@cnt
	ld hl, wEntityPrivate1
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, .next

;>         n += 1
	inc b

.next
;=@cnt
	dec e
	ld a, e
	cp $ff
	jr nz, .count

;> if n >= 3:
	ld a, b
	ld b, $00
	cp $03
;>     return
	jr nc, .done

;> f, failed = SpawnEntity(slot, 0xBD)        # spawner position in hMultiPurpose0/1
	ld a, $bd
	call SpawnEntity
;> if not failed:
	jr c, .done

;>     wEntityX[f] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[f] = hMultiPurpose1 - hMultiPurpose3
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	sub [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[f] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityPhysicsFlags[f] = 2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $02
;>     wEntityHealth[f] = 0x4C
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $4c
;>     d = hMultiPurposeG
	push bc
	ldh a, [hMultiPurposeG]
	ld c, a
;>     wEntitySpeedX[f] = mem[VireFireballSpeeds + d + 4]
	ld hl, VireFireballSpeeds + 4
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[f] = mem[VireFireballSpeeds + d]
	ld hl, VireFireballSpeeds
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntityTimer[f] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
	pop bc

.done
	ret


;@ def VireOpenMouth()
;@ path: boss/vire
;@ Sprite variant 2: Vire with his mouth open.
;@ test: skip sets the sprite variant through bank 0
VireOpenMouth::
;> return SetEntitySpriteVariant(slot, 2)
	ld a, $02
	jp SetEntitySpriteVariant


;@ def VireCheckWalls(slot: bc)
;@ path: boss/vire
;@ Wall collisions for Vire at the height he is drawn (y - $28, his flying height) rather than
;@ at his shadow.
;@ test: skip runs collisions through bank 0
VireCheckWalls::
;> wEntityY[slot] -= 0x28
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $28
	ld [hl], a
;> hActiveEntityY -= 0x28
	ldh a, [hActiveEntityY]
	sub $28
	ldh [hActiveEntityY], a
;> EntityCheckWalls(slot)                    # walls -> wEntityCollisions
	call EntityCheckWalls
;> wEntityY[slot] += 0x28
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $28
	ld [hl], a
;> LoadEntityPosition(slot)                    # reload hActiveEntityX/Y
	call LoadEntityPosition
	ret


;@ def VireDodge(slot: bc)
;@ path: boss/vire
;@ Vire dodges: for each active (status 5) arrow, bomb or hookshot (types 0, 2, 3) within $18
;@ sideways and $20 up or down, he darts away from it at speed $20 (an axis speed of 0 becomes
;@ $20) and goes to state 3 with wEntityPrivate2 = 1.
;@ test: skip aims through bank 3
VireDodge::
;>@loop for i in range(15, -1, -1):
	ld e, $0f

.loop
;>@obj     if wEntityStatus[i] == 5 and wEntityType[i] in (3, 0, 2):
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, .next

;=@obj
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $03
	jr z, .near

;=@obj
	cp $00
	jr z, .near

	cp $02
	jr nz, .next

.near
;>@near         if (hActiveEntityX - wEntityX[i] + 0x18) & 0xFF < 0x30 and (hActiveEntityDrawY - wEntityY[i] + 0x20) & 0xFF < 0x40:
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $18
	cp $30
;=@near
	jr nc, .next

;=@near
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $20
	cp $40
;=@near
	jr nc, .next

;>             ly, lx = hLinkY, hLinkX
	ldh a, [hLinkY]
	push af
	ldh a, [hLinkX]
	push af
;>             hLinkY = wEntityY[i]   # aim at the object instead of Link
	ld a, [hl]
	ldh [hLinkY], a
;>             hLinkX = wEntityX[i]
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;>             GetVectorTowardsLink(slot, 0x20)
	push de
	ld a, $20
	call GetVectorTowardsLink
	pop de
;>@vx             wEntitySpeedX[slot] = (-hMultiPurpose1 & 0xFF) or 0x20
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	jr nz, .setX

	ld a, $20

.setX
;=@vx
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>@vy             wEntitySpeedY[slot] = (-hMultiPurpose0 & 0xFF) or 0x20
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	jr nz, .setY

	ld a, $20

.setY
;=@vy
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>             hLinkX = lx
	pop af
	ldh [hLinkX], a
;>             hLinkY = ly
	pop af
	ldh [hLinkY], a
;>             wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>             wEntityPrivate2[slot] = 1
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $01

.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .loop

	ret


;@ path: boss/vire
;@ Vire's 3 sprite frames by sprite variant, 12 bytes each: 3 sprites of (dy, dx, tile,
;@ attributes) - left wing, body, the left wing mirrored as the right one. 0 tiles $60 $62,
;@ 1 $64 $66 (wings flapped), 2 $68 $6A (mouth open).
VireSprites::
	db $00, $fc, $60, $00, $00, $04, $62, $00, $00, $0c, $60, $20
	db $00, $fc, $64, $00, $00, $04, $66, $00, $00, $0c, $64, $20
	db $00, $fc, $68, $00, $00, $04, $6a, $00, $00, $0c, $68, $20

;@ def DrawVire(slot: bc)
;@ path: boss/vire
;@ Draws Vire's frame (VireSprites[hActiveEntitySpriteVariant], 3 sprites) and his shadow;
;@ nothing for variant $FF.
;@ test: skip writes OAM through bank 0
DrawVire::
;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v == 0xFF:
	cp $ff
;>     return
	ret z

;>@ofs src = VireSprites + v * 12
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
;=@ofs
	add e
	ld e, a
	ld d, b
	ld hl, VireSprites
	add hl, de
;> DrawEntitySprites(src, 3)              # 3 sprites
	ld c, $03
	call DrawEntitySprites
;> return DrawEntityShadow(slot)             # the shadow
	jp DrawEntityShadow


;@ path: boss/vire
;@ A fireball's sprite pairs by variant: 2 x (tile, attributes), tile $1E. 0: plain and flipped
;@ both ways, 1: flipped up-down and left-right - so it seems to spin.
VireFireballPairs::
	db $1e, $00, $1e, $60, $1e, $40, $1e, $20

;@ def VireFireballHandler(slot: bc)
;@ path: boss/vire
;@ One of Vire's fireballs (entity $BD with wEntityPrivate1 = 2): flies straight on, spinning.
;@ Link's sword puts it out in a puff; it also vanishes when it hits Link, or a wall once its
;@ first $20 frames are over.
;@ test: skip runs collisions through bank 3
VireFireballHandler::
;> DrawEntity16x16(slot, VireFireballPairs)
	ld de, VireFireballPairs
	call DrawEntity16x16
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> EntityCheckWeaponHits(slot)                    # Link's sword hits it?
	call EntityCheckWeaponHits
;> if EntityCheckContactDamage(slot):                # it hits Link
	call EntityCheckContactDamage
;>     return ClearEntityStatus_18(slot)
	jr c, .remove

;> if wEntityIgnoreHitsTimer[slot]:   # struck by the sword
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .fly

;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(2)         # a puff
	ld a, $02
	call AddTransientVfx

.remove
;>     return ClearEntityStatus_18(slot)
	jp ClearEntityStatus_18

.fly
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	ret nz

;> EntityCheckWalls(slot)                    # walls
	call EntityCheckWalls
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

	ret


;@ path: boss/vire
;@ A bat's sprite pairs by variant: 2 x (tile, attributes), the tile and its mirror image.
;@ 0: $6C, 1: $6E (wings flapped).
VireBatPairs::
	db $6c, $00, $6c, $20, $6e, $00, $6e, $20

;@ def VireBatHandler(slot: bc)
;@ path: boss/vire
;@ One of the two bats Vire splits into (entity $BD with wEntityPrivate1 = 1): it flutters at
;@ height $10 (moving 1 towards it every 4 frames), wings flapping every 8 frames.
;@ test: skip runs a state machine with sprite drawing
VireBatHandler::
;> DrawEntity16x16(slot, VireBatPairs)
	ld de, VireBatPairs
	call DrawEntity16x16
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .flap

;>     z = wEntityZ[slot] - 0x10
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	sub $10
;>     if z != 0:
	jr z, .flap

;>@z         wEntityZ[slot] += 1 if z < 0 else -1
	and $80
	jr z, .down

	inc [hl]
	inc [hl]

.down
;=@z
	dec [hl]

.flap
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> return VireBatStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/vire
;@ A bat's states (wEntityState): 0 VireBatWait, 1 VireBatAim, 2 VireBatFly.
VireBatStates::
	dw VireBatWait
	dw VireBatAim
	dw VireBatFly

;@ def VireBatWait(slot: bc)
;@ path: boss/vire
;@ State 0: drifts out of Vire for its timer, then stops for $20 frames.
;@ test: slot = rand(0, 15)
VireBatWait::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     ClearEntitySpeed(slot)                # x and y speed to 0
	call ClearEntitySpeed
;>     IncrementEntityState(slot)
	call IncrementEntityState

.done
	ret


;@ def VireBatAim(slot: bc)
;@ path: boss/vire
;@ State 1: after its pause it shoots at Link (speed $20).
;@ test: skip aims at Link through bank 3
VireBatAim::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     SetEntitySpeedTowardsLink(slot, 0x20)            # straight at Link
	ld a, $20
	call SetEntitySpeedTowardsLink
;>     IncrementEntityState(slot)
	call IncrementEntityState

.done
	ret


;@ def VireBatFly(slot: bc)
;@ path: boss/vire
;@ State 2: flies on, hurting Link on contact; after $20 frames it is removed when it hits a
;@ wall.
;@ test: skip runs collisions through bank 3
VireBatFly::
;> EntityCheckHits(slot)                    # hurts Link
	call EntityCheckHits
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	ret nz

;> EntityCheckWalls(slot)                    # walls
	call EntityCheckWalls
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

	ret


;@ def GrimCreeperEntityHandler(slot: bc)
;@ path: boss/grim_creeper
;@ Entity $BC: the Grim Creeper, the mini-boss who conducts a squad of six bats (the same entity
;@ type with wEntityPrivate1 = 1, GrimCreeperBatHandler). He keeps Link in the arena and cannot
;@ be hurt himself; he calls the bats one by one, sends them into one of 8 formations
;@ (wEntityScratch5 is the formation number here, 0-7 in turn) and lets them dive at Link one
;@ after the other. Once the room's event is done (the bats are beaten) he speaks (dialogue $025),
;@ then flies up and away (noise $3F) and the area music returns.
;@ test: skip runs a mini-boss with dialogues and spawns
GrimCreeperEntityHandler::
;> if wEntityPrivate1[slot]:      # one of the bats
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
;>     return GrimCreeperBatHandler(slot)
	jp nz, GrimCreeperBatHandler

;> wEntityPhysicsFlags[slot] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
;> DrawGrimCreeperFight()
	call DrawGrimCreeperFight
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> StartBossMusic(slot)                    # the boss music once its delay is over
	call StartBossMusic
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if not wRoomEventDone:
	ld a, [wRoomEventDone]
	and a
;>     return GrimCreeperFightStates[hActiveEntityState](slot)
	jr z, .states

;> step = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
;> if step == 0:
	and a
	jr nz, .leave

;>     wEntityPrivate3[slot] = 1
	inc [hl]
;>     OpenDialog(0x25)
	ld a, $25
	call OpenDialog
;>     return MarkRoomEventDone_18()
	jp MarkRoomEventDone_18

.leave
;> if step == 1:
	cp $01
	jr nz, .rise

;>     hNoiseSfx = 0x3F
	ld a, $3f
	ldh [hNoiseSfx], a
;>     wEntityPrivate3[slot] = 2
	inc [hl]

.rise
;> wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;> if wEntityZ[slot] < 0x78:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $78
;>     return
	ret c

;> SelectAreaMusicFar()
	call SelectAreaMusicFar
;> return ClearEntityStatus_18(slot)
	jp ClearEntityStatus_18

.states
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/grim_creeper
;@ The Grim Creeper's states (wEntityState): 0 GrimCreeperInit, 1 GrimCreeperNextFormation,
;@ 2 GrimCreeperClearBats, 3 GrimCreeperSummon, 4 GrimCreeperWaitFormation, 5 GrimCreeperSignal,
;@ 6 GrimCreeperWaitAttack (then back to 1).
GrimCreeperFightStates::
	dw GrimCreeperInit
	dw GrimCreeperNextFormation
	dw GrimCreeperClearBats
	dw GrimCreeperSummon
	dw GrimCreeperWaitFormation
	dw GrimCreeperSignal
	dw GrimCreeperWaitAttack

;@ def GrimCreeperInit()
;@ path: boss/grim_creeper
;@ State 0: formation 7, so the first one is 0.
;@ test: skip runs the entity state
GrimCreeperInit::
;> wEntityScratch5 = 7           # the formation number
	ld a, $07
	ld [wEntityScratch5], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def GrimCreeperNextFormation(slot: bc)
;@ path: boss/grim_creeper
;@ State 1: the next formation (0-7 in turn); the bats in place (wEntityScratch1) and
;@ wEntityScratch2 back to 0; $80 frames until the bats are cleared away.
;@ test: skip runs the entity state
GrimCreeperNextFormation::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityScratch1 = 0           # bats in place
	xor a
	ld [wEntityScratch1], a
;> wEntityScratch2 = 0
	ld [wEntityScratch2], a
;> wEntityScratch5 = (wEntityScratch5 + 1) & 7
	ld a, [wEntityScratch5]
	inc a
	and $07
	ld [wEntityScratch5], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def GrimCreeperClearBats(slot: bc)
;@ path: boss/grim_creeper
;@ State 2: when the timer runs out, every bat still about is removed, bit 1 of his
;@ wEntityOptions1 is cleared and the summoning takes $FF frames (state 3).
;@ test: skip runs the entity state
GrimCreeperClearBats::
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .done

;> wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;> wEntityOptions1[slot] &= ~0x02
	ld hl, wEntityOptions1
	add hl, bc
	res 1, [hl]
;>@loop for i in range(15, -1, -1):
	ld e, $0f
	ld d, b

.loop
;>@bat     if wEntityType[i] == 0xBC and wEntityPrivate1[i]:   # a bat
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $bc
	jr nz, .next

;=@bat
	ld hl, wEntityPrivate1
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

;>         wEntityStatus[i] = 0
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b

.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .loop

;> return IncrementEntityState(slot)
	jp IncrementEntityState

.done
	ret


;@ path: boss/grim_creeper
;@ Where the six bats appear (index = order of the call, 0-5): x $78, $68, $58, $48, $38,
;@ $28, all in a row...
GrimCreeperBatStartX::
	db $78, $68, $58, $48, $38, $28

;@ path: boss/grim_creeper
;@ ...at y 0 (the top of the room).
GrimCreeperBatStartY::
	db $00, $00, $00, $00, $00, $00

;@ def GrimCreeperSummon(slot: bc)
;@ path: boss/grim_creeper
;@ State 3: every $20 frames of the timer he calls a bat (jingle $31), up to 6: it appears at
;@ GrimCreeperBatStartX/Y at height $1C, numbered by wEntityPrivateCounter, with 1 health. At
;@ the end bit 1 of his wEntityOptions1 is set again. He conducts meanwhile.
;@ test: skip spawns entities
GrimCreeperSummon::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .call

;>     wEntityOptions1[slot] |= 0x02
	ld hl, wEntityOptions1
	add hl, bc
	set 1, [hl]
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     t = 0
	xor a

.call
;> if t & 0x1F:
;>     return GrimCreeperConduct()
	and $1f
	jr nz, GrimCreeperConduct

;> k = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> if k >= 6:
	cp $06
;>     return GrimCreeperConduct()
	jr nc, GrimCreeperConduct

;> bat, failed = SpawnEntity(slot, 0xBC)
	ld a, $bc
	call SpawnEntity
;> if failed:
;>     return GrimCreeperConduct()
	jr c, GrimCreeperConduct

;> hJingle = 0x31
	ld a, $31
	ldh [hJingle], a
;> wEntityPrivateCounter[slot] = k + 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	push bc
	ld c, [hl]
	inc [hl]
;> wEntityX[bat] = mem[GrimCreeperBatStartX + k]
	ld hl, GrimCreeperBatStartX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[bat] = mem[GrimCreeperBatStartY + k]
	ld hl, GrimCreeperBatStartY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityZ[bat] = 0x1C
	ld hl, wEntityZ
	add hl, de
	ld [hl], $1c
;> wEntityPrivateCounter[bat] = k
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], c
;> wEntityOptions1[bat] &= 0x7B
	ld hl, wEntityOptions1
	add hl, de
	ld a, [hl]
	and $7b
	ld [hl], a
;> wEntityHealth[bat] = 1
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $01
;> wEntityPrivate1[bat] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntityPhysicsFlags[bat] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, de
	set 6, [hl]
	pop bc
;> GrimCreeperConduct()           # falls through

;@ def GrimCreeperConduct()
;@ path: boss/grim_creeper
;@ The Grim Creeper waves his baton: sprite variant 0 and 1, switching every 32 frames.
;@ test: skip sets the sprite variant through bank 0
GrimCreeperConduct::
;>@v v = (hFrameCounter >> 5) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
;=@v
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)
	call SetEntitySpriteVariant
	ret


;@ def GrimCreeperWaitFormation(slot: bc)
;@ path: boss/grim_creeper
;@ State 4: conducts until all six bats are in their places (wEntityScratch1 = 6); then $40
;@ frames to the signal.
;@ test: skip sets the sprite variant through bank 0
GrimCreeperWaitFormation::
;> if wEntityScratch1 == 6:      # all in place
	ld a, [wEntityScratch1]
	cp $06
	jr nz, .conduct

;>     wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
;>     wEntityScratch1 = 0
	xor a
	ld [wEntityScratch1], a
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     IncrementEntityState(slot)
	call IncrementEntityState

.conduct
;> GrimCreeperConduct()
	call GrimCreeperConduct
	ret


;@ def GrimCreeperSignal(slot: bc)
;@ path: boss/grim_creeper
;@ State 5: when the timer runs out he gives the signal (wEntityScratch1 = $FF): the bats start
;@ their dives; the next formation comes $40 frames later.
;@ test: skip runs the entity state
GrimCreeperSignal::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityScratch1 = 0xFF    # attack!
	ld a, $ff
	ld [wEntityScratch1], a
;>     wEntityDropTimer[slot] = 0x40
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], $40
;>     IncrementEntityState(slot)
	call IncrementEntityState

.done
	ret


;@ def GrimCreeperWaitAttack(slot: bc)
;@ path: boss/grim_creeper
;@ State 6: baton raised (variant 2) while wEntityDropTimer runs; then the next formation (state
;@ 1). Ends with a second, never reached ret.
;@ test: skip sets the sprite variant through bank 0
GrimCreeperWaitAttack::
;> if wEntityDropTimer[slot] == 0:
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .raised

;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01

.raised
;> SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
;> return
	ret

	ret

;@ path: boss/grim_creeper
;@ The Grim Creeper's 3 sprite frames by sprite variant, 12 bytes each: 3 sprites of (dy, dx,
;@ tile, attributes) - his arm and baton ($60, $66 or $68 below), his body $62 $64.
;@ 0 and 1 conducting, 2 baton lowered.
GrimCreeperFightSprites::
	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00
	db $00, $f8, $66, $00, $00, $00, $62, $00, $00, $08, $64, $00
	db $10, $00, $68, $00, $00, $00, $62, $00, $00, $08, $64, $00

;@ def DrawGrimCreeperFight()
;@ path: boss/grim_creeper
;@ Draws the Grim Creeper's frame (GrimCreeperFightSprites[hActiveEntitySpriteVariant], 3 sprites)
;@ and claims one more OAM entry.
;@ test: skip writes OAM through bank 0
DrawGrimCreeperFight::
;>@ofs src = GrimCreeperFightSprites + hActiveEntitySpriteVariant * 12
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	sla a
;=@ofs
	add e
	ld e, a
	ld d, b
	ld hl, GrimCreeperFightSprites
	add hl, de
;> DrawEntitySprites(src, 3)              # 3 sprites
	ld c, $03
	call DrawEntitySprites
;> return ReserveOAMEntriesFar(1)
	ld a, $01
	jp ReserveOAMEntriesFar


;@ path: boss/grim_creeper
;@ A bat's sprite pairs by variant: 2 x (tile, attributes), tile $6E and its mirror image;
;@ variant 1 flipped upside down (the wings beating).
GrimCreeperBatPairs::
	db $6e, $00, $6e, $20, $6e, $40, $6e, $60

;@ def GrimCreeperBatHandler(slot: bc)
;@ path: boss/grim_creeper
;@ One of the Grim Creeper's six bats (entity $BC with wEntityPrivate1 = 1, its number 0-5 in
;@ wEntityPrivateCounter).
;@ test: skip runs a state machine with sprite drawing
GrimCreeperBatHandler::
;> DrawEntity16x16(slot, GrimCreeperBatPairs)
	ld de, GrimCreeperBatPairs
	call DrawEntity16x16
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> return GrimCreeperFightBatStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/grim_creeper
;@ A bat's states (wEntityState): 0 GrimCreeperBatFlyToPlace, 1 GrimCreeperBatWaitSignal,
;@ 2 GrimCreeperBatWaitTurn, 3 GrimCreeperBatDive, 4 GrimCreeperBatGone.
GrimCreeperFightBatStates::
	dw GrimCreeperBatFlyToPlace
	dw GrimCreeperBatWaitSignal
	dw GrimCreeperBatWaitTurn
	dw GrimCreeperBatDive
	dw GrimCreeperBatGone

;@ path: boss/grim_creeper
;@ The x positions of the bats in the 8 formations: 6 bytes per formation (wEntityScratch5),
;@ one per bat by its number (wEntityPrivateCounter); the y positions are in
;@ GrimCreeperFormationY. Formation 0, for instance, is a V.
GrimCreeperFormationX::
	db $28, $38, $48, $58, $68, $78
	db $38, $68, $48, $58, $48, $58
	db $18, $88, $28, $78, $60, $40
	db $28, $78, $78, $28, $60, $40
	db $28, $78, $28, $78, $50, $50
	db $38, $68, $50, $50, $38, $68
	db $38, $68, $38, $68, $38, $68
	db $28, $78, $38, $48, $68, $58
;@ path: boss/grim_creeper
;@ The y positions of the bats in the 8 formations, laid out like GrimCreeperFormationX.
GrimCreeperFormationY::
	db $20, $30, $40, $40, $30, $20
	db $60, $60, $50, $70, $70, $50
	db $38, $38, $58, $58, $70, $70
	db $30, $30, $70, $70, $50, $50
	db $30, $70, $70, $30, $30, $70
	db $40, $60, $70, $30, $60, $40
	db $30, $30, $50, $50, $70, $70
	db $40, $40, $50, $40, $50, $40

;@ def GrimCreeperBatFlyToPlace(slot: bc)
;@ path: boss/grim_creeper
;@ State 0: the bat flies to its place in the current formation (every 4th frame it aims at it
;@ at speed $10, by pretending Link stands there); within 2 pixels it counts itself in
;@ (wEntityScratch1 + 1) and waits.
;@ test: skip aims through bank 3
GrimCreeperBatFlyToPlace::
;> lx, ly = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;>@i i = wEntityScratch5 * 6 + wEntityPrivateCounter[slot]
	ld a, [wEntityScratch5]
	rla
	and $fe
	ld e, a
	rla
	and $fc
;=@i
	add e
	ld hl, wEntityPrivateCounter
	add hl, bc
	add [hl]
	ld e, a
	ld d, b
;> hLinkX = mem[GrimCreeperFormationX + i]   # the target
	ld hl, GrimCreeperFormationX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;> hLinkY = mem[GrimCreeperFormationY + i]
	ld hl, GrimCreeperFormationY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
;> if (hFrameCounter ^ slot) & 3 == 0:
	ldh a, [hFrameCounter]
	xor c
	and $03
	jr nz, .check

;>     SetEntitySpeedTowardsLink(slot, 0x10)
	ld a, $10
	call SetEntitySpeedTowardsLink

.check
;>@in if (hLinkX - hActiveEntityX + 3) & 0xFF < 6 and (hLinkY - hActiveEntityDrawY + 3) & 0xFF < 6:
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	add $03
	cp $06
	jr nc, .restore

;=@in
	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $03
	cp $06
	jr nc, .restore

;>     wEntityScratch1 += 1      # in place
	ld hl, wEntityScratch1
	inc [hl]
;>     IncrementEntityState(slot)
	call IncrementEntityState

.restore
;> hLinkY = ly
	pop af
	ldh [hLinkY], a
;> hLinkX = lx
	pop af
	ldh [hLinkX], a
;> GrimCreeperBatMove(slot)       # falls through

;@ def GrimCreeperBatMove(slot: bc)
;@ path: boss/grim_creeper
;@ Moves the bat by its speed and flaps its wings.
;@ test: skip sets the sprite variant through bank 0
GrimCreeperBatMove::
;> UpdateEntityPosWithSpeed_18(slot)   # falls through
	call UpdateEntityPosWithSpeed_18

;@ def GrimCreeperBatAnimate()
;@ path: boss/grim_creeper
;@ A bat's wings: sprite variant 0 and 1, switching every 8 frames.
;@ test: skip sets the sprite variant through bank 0
GrimCreeperBatAnimate::
;> v = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, v)
	call SetEntitySpriteVariant
	ret


;@ path: boss/grim_creeper
;@ How long each bat (by its number) waits after the signal before it dives: 4, 12, 20, ... 60
;@ frames, one after the other. 8 entries, only 6 bats.
GrimCreeperBatDelays::
	db $04, $0c, $14, $1c, $24, $2c, $34, $3c

;@ def GrimCreeperBatWaitSignal(slot: bc)
;@ path: boss/grim_creeper
;@ State 1: hovers in place until the Grim Creeper's signal (wEntityScratch1 = $FF); then its
;@ delay from GrimCreeperBatDelays.
;@ test: skip sets the sprite variant through bank 0
GrimCreeperBatWaitSignal::
;> if wEntityScratch1 == 0xFF:
	ld a, [wEntityScratch1]
	cp $ff
	jr nz, .flap

;>@d     wEntityDropTimer[slot] = mem[GrimCreeperBatDelays + wEntityPrivateCounter[slot]]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, GrimCreeperBatDelays
	add hl, de
;=@d
	ld a, [hl]
	ld hl, wEntityDropTimer
	add hl, bc
	ld [hl], a
;>     IncrementEntityState(slot)
	call IncrementEntityState

.flap
;> return GrimCreeperBatAnimate()
	jp GrimCreeperBatAnimate


;@ def GrimCreeperBatWaitTurn(slot: bc)
;@ path: boss/grim_creeper
;@ State 2: when its delay is over the bat dives at Link: speed $20, rising speed -12 (it drops
;@ from its height), jingle $31; from now on it can hit and be hit.
;@ test: skip aims at Link through bank 3
GrimCreeperBatWaitTurn::
;> if wEntityDropTimer[slot] == 0:
	ld hl, wEntityDropTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .flap

;>     wEntityPhysicsFlags[slot] &= ~0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 6, [hl]
;>     SetEntitySpeedTowardsLink(slot, 0x20)
	ld a, $20
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[slot] = -12 & 0xFF
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $f4
;>     hJingle = 0x31
	ld a, $31
	ldh [hJingle], a
;>     IncrementEntityState(slot)
	call IncrementEntityState

.flap
;> return GrimCreeperBatAnimate()
	jp GrimCreeperBatAnimate


;@ def GrimCreeperBatDive(slot: bc)
;@ path: boss/grim_creeper
;@ State 3: the dive, straight on; the drop slows into a climb (Z speed + 1 every 4 frames, up
;@ to +12). Once it is off the bottom (y $88) or the right edge (x $A8) it is gone (invisible,
;@ state 4).
;@ test: skip runs collisions through bank 3
GrimCreeperBatDive::
;> EntityCheckHits(slot)
	call EntityCheckHits
;> GrimCreeperBatMove(slot)
	call GrimCreeperBatMove
;> UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;>@z if hFrameCounter & 3 == 0 and wEntitySpeedZ[slot] != 0x0C:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .edge

	ld hl, wEntitySpeedZ
	add hl, bc
;=@z
	ld a, [hl]
	cp $0c
	jr z, .edge

;>     wEntitySpeedZ[slot] += 1
	inc [hl]

.edge
;> if hActiveEntityDrawY < 0x88 and hActiveEntityX < 0xA8:
	ldh a, [hActiveEntityDrawY]
	cp $88
	jr nc, .gone

	ldh a, [hActiveEntityX]
	cp $a8
;>     return
	ret c

.gone
;> IncrementEntityState(slot)
	call IncrementEntityState
;> SetEntitySpriteVariant(slot, 0xFF)   # invisible
	ld a, $ff
	call SetEntitySpriteVariant
	ret


;@ def GrimCreeperBatGone()
;@ path: boss/grim_creeper
;@ State 4: the bat has flown off; it waits to be removed when the next formation is called.
GrimCreeperBatGone::
;> return
	ret


;@ path: boss/turtle_rock
;@ The rubble the Turtle Rock throws off as it breaks out: one sprite of (tile, attributes) per
;@ sprite variant 0-5 - tiles $7A, $7E, $7C with palette 1, some mirrored.
TurtleRockRubbleSprites::
	db $7a, $10, $7e, $30, $7a, $30, $7e, $10, $7c, $10, $7c, $30

;@ def TurtleRockEntityHandler(slot: bc)
;@ path: boss/turtle_rock
;@ Entity $7F: the Turtle Rock, the stone turtle head guarding the entrance of the eighth
;@ dungeon, and the rubble it throws off (wEntityPrivate1 not 0). Gone for good once beaten (room
;@ status bit 5). It sleeps until Link plays the Frog's Song of Soul: then it wakes (16 health),
;@ breaks out of the rock and attacks with its long neck. Until it stretches out (states 0-4) it
;@ is a solid block; afterwards touching it hurts. Beaten, it sets bit 5 of overworld room $10's
;@ status and the secret jingle plays.
;@ test: skip runs a boss with sprite drawing
TurtleRockEntityHandler::
;> if hRoomStatus & 0x20:         # already beaten
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;> if wEntityPrivate1[slot]:      # a piece of rubble
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .head

;>     DrawEntity8x16(slot, TurtleRockRubbleSprites)
	ld de, TurtleRockRubbleSprites
	call DrawEntity8x16
;>     ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;>     UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;>     UpdateEntityZWithSpeed_18(slot)
	call UpdateEntityZWithSpeed_18
;>     wEntitySpeedZ[slot] -= 2   # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>     if wEntityZ[slot] & 0x80:  # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;>         return ClearEntityStatus_18(slot)
	jp nz, ClearEntityStatus_18

;>     return
	ret

.head
;> if wEntityFlashTimer[slot]:    # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .draw

;>     hActiveEntitySpriteVariant = 7
	ld a, $07
	ldh [hActiveEntitySpriteVariant], a

.draw
;> DrawTurtleRock(slot)
	call DrawTurtleRock
;>@song if hActiveEntityState == 0 and wSelectedSong == 2 and wOcarinaSongState:   # the Frog's Song of Soul
	ldh a, [hActiveEntityState]
	and a
	jr nz, .alive

;=@song
	ld a, [wSelectedSong]
	cp $02
	jr nz, .alive

;=@song
	ld a, [wOcarinaSongState]
	and a
	jr z, .alive

;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wEntityOptions1[slot] |= 0x84
	ld hl, wEntityOptions1
	add hl, bc
	set 7, [hl]
	set 2, [hl]
;>     wEntityHealth[slot] = 0x10
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $10
;>     return
	ret

.alive
;> if hActiveEntityStatus != 5:   # beaten
	ldh a, [hActiveEntityStatus]
	cp $05
	jr z, .active

;>     BossDeathSequence_18(slot)
	call BossDeathSequence_18
;>     if wEntityStatus[slot] == 0:   # gone
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done

;>         wRoomStatus[0x10] |= 0x20
	ld hl, wRoomStatus + $10
	set 5, [hl]
;>         hJingle = 2
	ld a, $02
	ldh [hJingle], a

.done
;>     return
	ret

.active
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;> if hActiveEntityState < 5:
	ldh a, [hActiveEntityState]
	cp $05
	jr nc, .neck

;>     PushLinkOutOfEntity_18(slot)   # still a block of rock
	call PushLinkOutOfEntity_18
	jr .states

.neck
;> else:
;>     EntityCheckContactDamage(slot)
	call EntityCheckContactDamage

.states
;> return TurtleRockStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/turtle_rock
;@ The Turtle Rock's states (wEntityState): 0 TurtleRockAsleep, 1 TurtleRockWake,
;@ 2 TurtleRockShake, 3 TurtleRockBreakOut, 4 TurtleRockRoar, 5 TurtleRockStretchOut,
;@ 6 TurtleRockStartSway, 7 TurtleRockSway, 8 TurtleRockTurn, 9 TurtleRockAim,
;@ 10 TurtleRockLunge, 11 TurtleRockPullBack.
TurtleRockStates::
	dw TurtleRockAsleep
	dw TurtleRockWake
	dw TurtleRockShake
	dw TurtleRockBreakOut
	dw TurtleRockRoar
	dw TurtleRockStretchOut
	dw TurtleRockStartSway
	dw TurtleRockSway
	dw TurtleRockTurn
	dw TurtleRockAim
	dw TurtleRockLunge
	dw TurtleRockPullBack

;@ def TurtleRockAsleep()
;@ path: boss/turtle_rock
;@ State 0: asleep; TurtleRockEntityHandler wakes it at the Frog's Song of Soul.
TurtleRockAsleep::
;> return
	ret


;@ def TurtleRockWake(slot: bc)
;@ path: boss/turtle_rock
;@ State 1: the boss music ($39) starts, also as the room's music from now on; it shakes for
;@ $80 frames.
;@ test: skip runs the entity state
TurtleRockWake::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wMusicTrackToPlay = 0x39
	ld a, $39
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrack = 0x39
	ldh [hDefaultMusicTrack], a
;> hDefaultMusicTrackAlt = 0x39
	ldh [hDefaultMusicTrackAlt], a
;> hLastMusicTrack = 0x39
	ldh [hLastMusicTrack], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def TurtleRockShake(slot: bc)
;@ path: boss/turtle_rock
;@ State 2: remembers where its neck starts (wEntityPrivate4 = x, wEntityPrivate3 = y - $14) and
;@ shakes from side to side (x speed 8 / -8, turning every 4 frames) for the timer.
;@ test: skip runs the entity timer
TurtleRockShake::
;> wEntityPrivate4[slot] = hActiveEntityX   # the neck's base
	ldh a, [hActiveEntityX]
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], a
;> wEntityPrivate3[slot] = hActiveEntityDrawY - 0x14
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate3
	add hl, bc
	sub $14
	ld [hl], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shake

;>     wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     return
	ret

.shake
;> speed = 8 if t & 4 == 0 else -8
	ld e, $08
	and $04
	jr z, .set

	ld e, $f8

.set
;> wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
	ret


;@ path: boss/turtle_rock
;@ The six pieces of rubble, by number 0-5 (= the head's sprite variant when it is thrown off):
;@ x offset from the head...
TurtleRockRubbleOffsetsX::
	db $f8, $08, $10, $00, $00, $08

;@ path: boss/turtle_rock
;@ ...y offset...
TurtleRockRubbleOffsetsY::
	db $f0, $00, $f0, $00, $f0, $f0

;@ path: boss/turtle_rock
;@ ...x speed...
TurtleRockRubbleSpeedsX::
	db $f8, $08, $08, $f8, $f8, $08

;@ path: boss/turtle_rock
;@ ...y speed...
TurtleRockRubbleSpeedsY::
	db $fc, $02, $fc, $02, $fc, $fc

;@ path: boss/turtle_rock
;@ ...and rising speed (all $10; also stored in the piece's wEntityPrivate1, marking it as
;@ rubble).
TurtleRockRubbleSpeedsZ::
	db $10, $10, $10, $10, $10, $10

;@ def TurtleRockBreakOut(slot: bc)
;@ path: boss/turtle_rock
;@ State 3: every $20 frames a piece of rubble flies off (noise $13) and the head shows one stage
;@ further out of the rock (sprite variant + 1, up to 7). After the timer it roars (state 4,
;@ $80 frames).
;@ test: skip spawns entities
TurtleRockBreakOut::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .breaking

;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     return
	ret

.breaking
;> if t & 0x1F:
;>     return
	and $1f
	jr nz, .done

;> v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if v != 6:
	cp $06
	jr z, .stage

;>     hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
;>     r, failed = SpawnEntity(slot, 0x7F)   # (r is used even if none was free)
	ld a, $7f
	call SpawnEntity
;>     wEntitySpriteVariant[r] = v
	push bc
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>@x     wEntityX[r] = hMultiPurpose0 +mem[TurtleRockRubbleOffsetsX + v]
	ld hl, TurtleRockRubbleOffsetsX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@y     wEntityY[r] = hMultiPurpose1 +mem[TurtleRockRubbleOffsetsY + v]
	ld hl, TurtleRockRubbleOffsetsY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;=@y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntitySpeedX[r] = mem[TurtleRockRubbleSpeedsX + v]
	ld hl, TurtleRockRubbleSpeedsX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[r] = mem[TurtleRockRubbleSpeedsY + v]
	ld hl, TurtleRockRubbleSpeedsY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[r] = mem[TurtleRockRubbleSpeedsZ + v]
	ld hl, TurtleRockRubbleSpeedsZ
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[r] = mem[TurtleRockRubbleSpeedsZ + v]   # rubble
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], a
	pop bc

.stage
;> if wEntitySpriteVariant[slot] != 7:
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	cp $07
	jr z, .done

;>     wEntitySpriteVariant[slot] += 1
	inc a
	ld [hl], a

.done
	ret


;@ def TurtleRockRoar(slot: bc)
;@ path: boss/turtle_rock
;@ State 4: it opens and shuts its mouth (variant 8 open, 7 shut: timer $60+ open, $40-$5F shut,
;@ $30-$3F open, $20-$2F shut, below $20 open); then it stretches out (state 5, $80 frames).
;@ test: skip sets the sprite variant through bank 0
TurtleRockRoar::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .roar

;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.roar
;>@v v = 7 if 0x40 <= t < 0x60 or 0x20 <= t < 0x30 else 8
	ld e, $07
	cp $60
	jr nc, .open

	cp $40
	jr nc, .set

;=@v
	cp $30
	jr c, .open

	cp $20
	jr c, .set

.open
;=@v
	inc e

.set
;> SetEntitySpriteVariant(slot, v)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def TurtleRockStretchOut(slot: bc)
;@ path: boss/turtle_rock
;@ State 5: the head moves down out of the rock on its neck (y speed 4) for the timer; then the
;@ fight proper: physics flag bit 7 and wEntityOptions1 bit 6 cleared, the head's home position
;@ kept in wEntityScratch1 (x) / wEntityScratch2 (y), $40 frames before it sways.
;@ test: skip runs the entity timer
TurtleRockStretchOut::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .stretch

;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityPhysicsFlags[slot] &= ~0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
;>     wEntityOptions1[slot] &= ~0x40
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wEntityScratch1 = hActiveEntityX   # home position
	ldh a, [hActiveEntityX]
	ld [wEntityScratch1], a
;>     wEntityScratch2 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld [wEntityScratch2], a
;>     return
	ret

.stretch
;> wEntitySpeedY[slot] = 4
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $04
;> UpdateEntityYWithSpeed_18(slot)
	call UpdateEntityYWithSpeed_18
	ret


;@ def TurtleRockStartSway(slot: bc)
;@ path: boss/turtle_rock
;@ State 6: after the timer the head starts swaying to the right (x speed 8) for $20 frames.
;@ test: skip runs the entity timer
TurtleRockStartSway::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntitySpeedX[slot] = 8
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $08
;>     IncrementEntityState(slot)
	call IncrementEntityState

.done
	ret


;@ def TurtleRockSway(slot: bc)
;@ path: boss/turtle_rock
;@ State 7: sways sideways for the timer, then pauses $08-$27 frames (state 8).
;@ test: skip runs the entity timer
TurtleRockSway::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .move

;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 8
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $08
	ld [hl], a
;>     IncrementEntityState(slot)
	call IncrementEntityState

.move
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
	ret


;@ def TurtleRockTurn(slot: bc)
;@ path: boss/turtle_rock
;@ State 8: after the pause, from the third sway on (wEntityPrivate5 counts them) one time in two
;@ it lunges (state 9, $20 frames); otherwise it sways back the other way for $40 frames (state
;@ 7).
;@ test: skip runs the entity timer
TurtleRockTurn::
;> if wEntityTimer[slot]:
;>     return
	call GetEntityTimer
	jr nz, .done

;> wEntityPrivate5[slot] += 1
	ld hl, wEntityPrivate5
	add hl, bc
	inc [hl]
;>@lunge if wEntityPrivate5[slot] >= 3 and GetRandomByte() & 1 == 0:
	ld a, [hl]
	cp $03
	jr c, .back

;=@lunge
	call GetRandomByte
	and $01
	jr nz, .back

;>     wEntityState[slot] = 9
	call IncrementEntityState
	ld a, $09
	ld [hl], a
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     return
	ret

.back
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityState[slot] = 7
	call IncrementEntityState
	dec [hl]
	dec [hl]
;> wEntitySpeedX[slot] = -wEntitySpeedX[slot] & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

.done
;> return
	ret


;@ def TurtleRockAim(slot: bc)
;@ path: boss/turtle_rock
;@ State 9: after the timer it aims at Link (speed $18, always downwards) and lunges for $20
;@ frames (state 10).
;@ test: skip aims at Link through bank 3
TurtleRockAim::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     SetEntitySpeedTowardsLink(slot, 0x18)
	ld a, $18
	call SetEntitySpeedTowardsLink
;>     if wEntitySpeedY[slot] & 0x80:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	bit 7, [hl]
	jr z, .go

;>         wEntitySpeedY[slot] = -wEntitySpeedY[slot] & 0xFF
	cpl
	inc a
	ld [hl], a

.go
;>     IncrementEntityState(slot)
	call IncrementEntityState

.done
	ret


;@ def TurtleRockLunge(slot: bc)
;@ path: boss/turtle_rock
;@ State 10: the lunge, until the timer runs out or it is hit; then it pulls back (state 11).
;@ test: skip runs the entity timer
TurtleRockLunge::
;>@end if wEntityFlashTimer[slot] or wEntityTimer[slot] == 0:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .back

;=@end
	call GetEntityTimer
	jr nz, .move

.back
;>     IncrementEntityState(slot)
	call IncrementEntityState

.move
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
	ret


;@ def TurtleRockPullBack(slot: bc)
;@ path: boss/turtle_rock
;@ State 11: the head goes back to its home position (wEntityScratch1 / wEntityScratch2) at speed
;@ 8; there it waits $20 frames and sways again (state 6).
;@ test: skip aims through bank 3
TurtleRockPullBack::
;> lx, ly = hLinkX, hLinkY
	ldh a, [hLinkX]
	push af
	ldh a, [hLinkY]
	push af
;> hLinkX = wEntityScratch1      # aim at home instead of Link
	ld a, [wEntityScratch1]
	ldh [hLinkX], a
;> hLinkY = wEntityScratch2
	ld a, [wEntityScratch2]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(slot, 8)
	ld a, $08
	call SetEntitySpeedTowardsLink
;>@home if (wEntityScratch1 - hActiveEntityX + 1) & 0xFF < 2 and (wEntityScratch2 - hActiveEntityDrawY + 1) & 0xFF < 2:
	ld a, [wEntityScratch1]
	ld hl, hActiveEntityX
	sub [hl]
	add $01
	cp $02
	jr nc, .restore

;=@home
	ld a, [wEntityScratch2]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $01
	cp $02
	jr nc, .restore

;>     wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20

.restore
;> hLinkY = ly
	pop af
	ldh [hLinkY], a
;> hLinkX = lx
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
	ret


;@ path: boss/turtle_rock
;@ The Turtle Rock's head in 9 sprite frames by sprite variant, 24 bytes each: 6 sprites of (dy,
;@ dx, tile, attributes), 4 across on top and 2 below. 0-6 the head breaking out of the rock step
;@ by step, 7 mouth shut (also shown while hit), 8 mouth open.
TurtleRockSprites::
	; 0
	db $f0, $f8, $7a, $10, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $7e, $30
	; 1
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $7e, $30
	; 2
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $74, $20
	; 3
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $70, $20
	db $00, $00, $7e, $10, $00, $08, $74, $20
	; 4
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20
	; 5
	db $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $7c, $30, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20
	; 6
	db $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20
	; 7
	db $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20
	; 8
	db $f0, $f8, $70, $00, $f0, $00, $72, $00
	db $f0, $08, $72, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20

;@ path: boss/turtle_rock
;@ One segment of the Turtle Rock's neck: 2 x (tile, attributes), tile $76 and its mirror image.
TurtleRockNeckPair::
	db $76, $00, $76, $20

;@ def DrawTurtleRock(slot: bc)
;@ path: boss/turtle_rock
;@ Draws the head (TurtleRockSprites[hActiveEntitySpriteVariant], 6 sprites). Once it is out
;@ (state 5 on, or while it dies) also the neck: segments every $10 pixels from $20 above the
;@ head up to its base (wEntityPrivate4 = x, wEntityPrivate3 = y), each pulled towards the base
;@ by half the remaining x distance (dx/2, dx/4 ... dx/64). A neck segment touching Link (within
;@ $0C) knocks him sideways (speed $20, $18 frames), costs 8 health (one heart) and makes him
;@ invincible for $10 frames.
;@ test: skip writes OAM through bank 0
DrawTurtleRock::
;>@ofs src = TurtleRockSprites + hActiveEntitySpriteVariant * 24
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld e, a
;=@ofs
	rla
	add e
	ld e, a
	ld d, b
	ld hl, TurtleRockSprites
	add hl, de
;> DrawEntitySprites(src, 6)
	ld c, $06
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)                   # claim the 6 OAM entries
	ld a, $06
	call ReserveOAMEntriesFar
;> if hActiveEntityStatus != 1 and hActiveEntityState < 5:   # no neck yet
	ldh a, [hActiveEntityStatus]
	cp $01
	jr z, .neck

	ldh a, [hActiveEntityState]
	cp $05
;>     return LoadEntityPosition(slot)
	jp c, .done

.neck
;> baseX = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeG], a
;> d = hActiveEntityX - baseX
	ldh a, [hActiveEntityX]
	sub [hl]
;>@sh shifts = [d >> 1, d >> 2, d >> 3, d >> 4, d >> 5, d >> 6]   # signed, in hMultiPurposeA-F
	sra a
	ldh [hMultiPurposeA], a
	sra a
	ldh [hMultiPurposeB], a
	sra a
	ldh [hMultiPurposeC], a
;=@sh
	sra a
	ldh [hMultiPurposeD], a
	sra a
	ldh [hMultiPurposeE], a
	sra a
	ldh [hMultiPurposeF], a
;> baseY = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
;> y = hActiveEntityDrawY - 0x20
	ldh a, [hActiveEntityDrawY]
	sub $20
;> if y < baseY:
	cp [hl]
;>     return LoadEntityPosition(slot)
	jr c, .done

;> hActiveEntityDrawY = y
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> k = 0
	ld hl, hMultiPurposeA

.segment
;>@seg while True:
;>     hActiveEntityX = baseX + shifts[k]
	ldh a, [hMultiPurposeG]
	add [hl]
	ldh [hActiveEntityX], a
	inc hl
;>     DrawEntity16x16(slot, TurtleRockNeckPair)
	push hl
	ld de, TurtleRockNeckPair
	call DrawEntity16x16
;>@hit     if not wInvincibilityCounter and (hLinkY - hActiveEntityDrawY + 0x0C) & 0xFF < 0x18 and (hLinkX - hActiveEntityX + 0x0C) & 0xFF < 0x18:
	ld a, [wInvincibilityCounter]
	and a
	jr nz, .next

;=@hit
	ld hl, hActiveEntityDrawY
	ldh a, [hLinkY]
	sub [hl]
	add $0c
	cp $18
	jr nc, .next

;=@hit
	ld hl, hActiveEntityX
	ldh a, [hLinkX]
	sub [hl]
	ld e, a
	add $0c
	cp $18
;=@hit
	jr nc, .next

;>         push = 0x20 if hLinkX >= hActiveEntityX else -0x20
	ld a, e
	ld e, $20
	and $80
	jr z, .push

	ld e, $e0

.push
;>         hLinkSpeedX = push & 0xFF
	ld a, e
	ldh [hLinkSpeedX], a
;>         hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;>         wLinkPushedTimer = 0x18
	ld a, $18
	ld [wLinkPushedTimer], a
;>         wInvincibilityCounter = 0x10
	ld a, $10
	ld [wInvincibilityCounter], a
;>         wSubtractHealthBuffer = 8
	ld a, $08
	ld [wSubtractHealthBuffer], a
;>         hWaveSfx = 3
	ld a, $03
	ldh [hWaveSfx], a

.next
;>     k += 1
	pop hl
;>     hActiveEntityDrawY -= 0x10
	ldh a, [hMultiPurposeH]
	ld e, a
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;>     if (hActiveEntityDrawY - baseY) & 0x80:   # past the base
;>         break
	sub e
	and $80
;=@seg
	jr z, .segment

.done
;> LoadEntityPosition(slot)                    # back to the real position copies
	call LoadEntityPosition
	ret


;@ path: enemy/buzz_blob
;@ The Buzz Blob's sprite pairs by sprite variant: 2 x (tile, attributes). 0-2 the blob
;@ wobbling ($62 $64, $60 and mirror, the first pair mirrored), 3-5 the same with $66 $68 (electric
;@ charge), 6-8 the Cukeman ($6C $6E, $6A and mirror, mirrored).
BuzzBlobPairs::
	db $62, $00, $64, $00, $60, $00, $60, $20, $64, $20, $62, $20
	db $66, $00, $68, $00, $60, $00, $60, $20, $68, $20, $66, $20
	db $6c, $00, $6e, $00, $6a, $00, $6a, $20, $6e, $20, $6c, $20

;@ path: enemy/buzz_blob
;@ The Buzz Blob's 4-step animation: sprite variants 0 1 2 1 (every 8 frames).
BuzzBlobFrames::
	db $00, $01, $02, $01

;@ path: enemy/buzz_blob
;@ The animation while it is charged: variants 3 4 5 4.
BuzzBlobShockFrames::
	db $03, $04, $05, $04

;@ path: enemy/buzz_blob
;@ The Cukeman's animation: variants 6 7 8 7.
CukemanFrames::
	db $06, $07, $08, $07

;@ def BuzzBlobEntityHandler(slot: bc)
;@ path: enemy/buzz_blob
;@ Entity $B9: the Buzz Blob, which wanders about and hurts on contact. With wEntityPrivate1 set
;@ (sprinkled with Magic Powder) it is a Cukeman, who also talks: dialogues $27C-$27F in turn
;@ ("Hey Mon!" ...).
;@ test: skip runs a state machine with sprite drawing
BuzzBlobEntityHandler::
;> DrawEntity16x16(slot, BuzzBlobPairs)
	ld de, BuzzBlobPairs
	call DrawEntity16x16
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> EntityCheckHits(slot)
	call EntityCheckHits
;> return BuzzBlobStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/buzz_blob
;@ The Buzz Blob's states (wEntityState): 0 BuzzBlobWander, 1 BuzzBlobShock.
BuzzBlobStates::
	dw BuzzBlobWander
	dw BuzzBlobShock

;@ path: enemy/buzz_blob
;@ The Buzz Blob's slow speeds in 8 directions (a circle of radius 6): the y speed is
;@ BuzzBlobSpeeds[d], the x speed BuzzBlobSpeeds[d + 2], d = 0-7.
BuzzBlobSpeeds::
	db $fa, $fc, $00, $04, $06, $04, $00, $fc, $fa, $fc

;@ def BuzzBlobWander(slot: bc)
;@ path: enemy/buzz_blob
;@ State 0: every $30-$6F frames a new random direction (BuzzBlobSpeeds); it moves and stops at
;@ walls. A Cukeman speaks when Link talks to it.
;@ test: skip opens dialogues and sets the sprite variant
BuzzBlobWander::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .move

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
;>     wEntitySpeedX[slot] = mem[BuzzBlobSpeeds + d + 2]
	ld hl, BuzzBlobSpeeds + 2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[BuzzBlobSpeeds + d]
	ld hl, BuzzBlobSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

.move
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> frames = BuzzBlobFrames
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, BuzzBlobFrames
;> if not wEntityPrivate1[slot]:  # a Buzz Blob
	and a
;>     return BuzzBlobAnimate(frames)
	jr z, BuzzBlobAnimate

;> if CheckLinkCanTalk_18():      # a Cukeman
	call CheckLinkCanTalk_18
	jr nc, .cukeman

;>@talk     OpenDialogTable2(0x7C + (wEntityPrivate2[slot] & 3))   # dialogue $27C-$27F
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and $03
	add $7c
;=@talk
	inc [hl]
	call OpenDialogTable2

.cukeman
;> BuzzBlobAnimate(CukemanFrames)   # falls through
	ld hl, CukemanFrames

;@ def BuzzBlobAnimate(frames: hl)
;@ path: enemy/buzz_blob
;@ Sets the sprite variant from a 4-step animation table, one step every 8 frames.
;@ test: skip sets the sprite variant through bank 0
BuzzBlobAnimate::
;> i = (hFrameCounter >> 3) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
;> SetEntitySpriteVariant(slot, frames[i])
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ def BuzzBlobShock(slot: bc)
;@ path: enemy/buzz_blob
;@ State 1: charged with electricity (after being struck) for the timer, BuzzBlobShockFrames;
;@ then it wanders again.
;@ test: skip sets the sprite variant through bank 0
BuzzBlobShock::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .charged

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret

.charged
;> BuzzBlobAnimate(BuzzBlobShockFrames)
	ld hl, BuzzBlobShockFrames
	call BuzzBlobAnimate
	ret


;@ path: enemy/bomber
;@ The Bomber's 4 sprite frames by sprite variant, 12 bytes each: 3 sprites of (dy, dx, tile,
;@ attributes) - left wing, body $72, the left wing mirrored. Wing tiles $70, $74, $76, $74: the
;@ wings beating.
BomberSprites::
	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $70, $20
	db $00, $fc, $74, $00, $00, $04, $72, $00, $00, $0c, $74, $20
	db $00, $fc, $76, $00, $00, $04, $72, $00, $00, $0c, $76, $20
	db $00, $fc, $74, $00, $00, $04, $72, $00, $00, $0c, $74, $20
;@ path: enemy/bomber
;@ The Bomber's flying height, bobbing: $10 $11 $12 $11, one step every 8 frames.
BomberHeights::
	db $10, $11, $12, $11

;@ def BomberEntityHandler(slot: bc)
;@ path: enemy/bomber
;@ Entity $BA: the Bomber, the winged enemy that flies about and drops bombs on Link (one every
;@ $80 frames). When Link swings his sword at it from close by while facing it, it darts away.
;@ test: skip runs a state machine with sprite drawing
BomberEntityHandler::
;>@ofs src = BomberSprites + hActiveEntitySpriteVariant * 12
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
;=@ofs
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, BomberSprites
	add hl, de
;> DrawEntitySprites(src, 3)
	ld c, $03
	call DrawEntitySprites
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> DrawEntityShadow(slot)                    # the shadow
	call DrawEntityShadow
;>@z wEntityZ[slot] = mem[BomberHeights + ((wEntityPrivateCounter[slot] >> 3) & 3)]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
;=@z
	and $03
	ld e, a
	ld d, b
	ld hl, BomberHeights
	add hl, de
	ld a, [hl]
;=@z
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> ApplyRecoilIfNeeded_18(slot)
	call ApplyRecoilIfNeeded_18
;> UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> return BomberStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/bomber
;@ The Bomber's states (wEntityState): 0 BomberHover, 1 BomberFly, 2 BomberDodge.
BomberStates::
	dw BomberHover
	dw BomberFly
	dw BomberDodge

;@ path: enemy/bomber
;@ The Bomber's speeds in 8 directions (a circle of radius 8): the y speed is BomberSpeeds[d],
;@ the x speed BomberSpeeds[d + 2], d = 0-7.
BomberSpeeds::
	db $f8, $fa, $00, $06, $08, $06, $00, $fa, $f8, $fa

;@ def BomberHover(slot: bc)
;@ path: enemy/bomber
;@ State 0: hovers for the timer; then flies off for $20-$3F frames in a random direction
;@ (BomberSpeeds) - every 8th time straight at Link (speed $0A) - state 1.
;@ test: skip aims at Link through bank 3
BomberHover::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, BomberAct

;>     t = (GetRandomByte() & 0x1F) + 0x20
	call GetRandomByte
	and $1f
	add $20
;>     wEntityTimer[slot] = t
	ld [hl], a
;>     d = t & 7
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = mem[BomberSpeeds + d + 2]
	ld hl, BomberSpeeds + 2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = mem[BomberSpeeds + d]
	ld hl, BomberSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
;>     if wEntityPrivate1[slot] & 7 == 0:
	ld a, [hl]
	and $07
	jr nz, .fly

;>         SetEntitySpeedTowardsLink(slot, 0x0A)
	ld a, $0a
	call SetEntitySpeedTowardsLink

.fly
;>     IncrementEntityState(slot)
	call IncrementEntityState
;> BomberAct(slot)                # falls through

;@ def BomberAct(slot: bc)
;@ path: enemy/bomber
;@ What the Bomber does every frame: counts wEntityPrivateCounter (its bobbing) and every $80
;@ frames drops a bomb (entity 2, jingle 8) - at its own position and height, falling at speed 8,
;@ a $40-frame fuse, thrown towards Link at speed $10, wEntityPrivate4 = 1 (an enemy's bomb).
;@ If Link faces it within $20 while swinging his sword, it darts away from him (speed $20,
;@ state 2 for $12 frames); otherwise touching it hurts. Then it flaps its wings.
;@ test: skip spawns entities
BomberAct::
;> n = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> wEntityPrivateCounter[slot] = n + 1
	inc [hl]
;>@bomb if n & 0x7F == 0 and not SpawnEntity(slot, 2)[1]:   # a bomb, slot b
	and $7f
	jr nz, .sword

	ld a, $02
	call SpawnEntity
	jr c, .sword

;>     wEntityOptions1[b] &= ~0x01
	ld hl, wEntityOptions1
	add hl, de
	res 0, [hl]
;>     wEntityX[b] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[b] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[b] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[b] = 8
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $08
;>     wEntityTimer[b] = 0x40     # the fuse
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
;>     wEntityPrivate4[b] = 1
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
;>     SetEntitySpeedTowardsLink(slot, 0x10)   # for the bomb's slot
	push bc
	push de
	pop bc
	ld a, $10
	call SetEntitySpeedTowardsLink
	pop bc
;>     hJingle = 8
	ld a, $08
	ldh [hJingle], a

.sword
;>@sw if hLinkDirection ^ 1 == GetEntityDirectionToLink_18(slot) and (dx + 0x20) & 0xFF < 0x40 and (dy + 0x20) & 0xFF < 0x40 and wSwordAnimationState:
	call GetEntityDirectionToLink_18
	ldh a, [hLinkDirection]
	xor $01
	cp e
	jr nz, .touch

;=@sw
	call GetEntityXDistanceToLink_18
	add $20
	cp $40
	jr nc, .touch

;=@sw
	call GetEntityDrawYDistanceToLink_18
	add $20
	cp $40
	jr nc, .touch

;=@sw
	ld a, [wSwordAnimationState]
	and a
	jr z, .touch

;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>     wEntityTimer[slot] = 0x12
	call GetEntityTimer
	ld [hl], $12
;>     GetVectorTowardsLink(slot, 0x20)
	ld a, $20
	call GetVectorTowardsLink
;>     wEntitySpeedY[slot] = -hMultiPurpose0 & 0xFF   # away from Link
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = -hMultiPurpose1 & 0xFF
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     return
	ret

.touch
;> EntityCheckHits(slot)
	call EntityCheckHits
;> BomberAnimate()                # falls through

;@ def BomberAnimate()
;@ path: enemy/bomber
;@ The Bomber's wings: sprite variants 0-3, one step every 4 frames.
;@ test: skip sets the sprite variant through bank 0
BomberAnimate::
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 3)
	ldh a, [hFrameCounter]
	rra
	rra
	and $03
	call SetEntitySpriteVariant
	ret


;@ def BomberFly(slot: bc)
;@ path: enemy/bomber
;@ State 1: flies on for the timer; then it stops and hovers for $20 frames (state 0).
;@ test: skip spawns entities
BomberFly::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .act

;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     ClearEntitySpeed(slot)                # x and y speed to 0
	call ClearEntitySpeed

.act
;> return BomberAct(slot)
	jp BomberAct


;@ def BomberDodge(slot: bc)
;@ path: enemy/bomber
;@ State 2: darting away from Link's sword for the timer; then it hovers again.
;@ test: skip sets the sprite variant through bank 0
BomberDodge::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .flap

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

.flap
;> return BomberAnimate()
	jp BomberAnimate


;@ path: item/magic_powder
;@ The two tile columns (top, bottom) drawn for a torch that has just been lit: $6C $74 and $6D
;@ $75. Used by DrawTorchTiles.
LitTorchTiles::
	db $6c, $74, $6d, $75

;@ path: item/magic_powder
;@ The tile columns of an unlit torch: $64 $74 and $65 $75.
UnlitTorchTiles::
	db $64, $74, $65, $75

;@ def MagicPowderEntityHandler(slot: bc)
;@ path: item/magic_powder
;@ Entity $08: a sprinkle of Magic Powder. While its cloud lasts (the timer) it works on enemies
;@ (weapon type 9) during the last $0F frames, unless wEntityPrivate4 is set. At timer 7 it acts
;@ on the room object below it: outdoors objects $D3 and $5C vanish in a puff of smoke (jingle
;@ $2F); indoors an unlit torch ($AB) is lit ($AC, noise $12): the entity then stays as the
;@ torch's flame keeper (state 1) and puts it out again after $80 frames (MagicPowderEntityHandler
;@ .torch). Each lit torch counts in wRoomEventCounter and lightens the room (wRoomDarkness).
;@ test: skip changes room objects and queues background draws
MagicPowderEntityHandler::
;> DrawMagicPowder(slot)
	call DrawMagicPowder
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if hActiveEntityState != 0:    # keeping a torch lit
	ldh a, [hActiveEntityState]
	and a
;>     return MagicPowderEntityHandler.torch(slot)
	jp nz, .torch

;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return ClearEntityStatus_18(slot)
	jp z, .remove

;> if t != 7:
	cp $07
;>     return MagicPowderEntityHandler.hit(t)
	jp nz, .hit

;>@sq square = ((wEntityY[slot] - 9) & 0xF0) | (((wEntityX[slot] - 1) & 0xF0) >> 4)   # the object below
	push bc
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $07
	sub $08
;=@sq
	and $f0
	ldh [hBGPosX], a
	swap a
	ld hl, wEntityY
	add hl, bc
	ld c, a
;=@sq
	ld a, [hl]
	add $07
	sub $10
	and $f0
	ldh [hBGPosY], a
	or c
;=@sq
	ld c, a
	ld b, $00
;>@obj hRoomObjectType = wRoomObjects[square]   # (only the low byte is added)
	ld hl, wRoomObjects
	ld a, h
	add hl, bc
	push bc
	pop de
	ld h, a
;=@obj
	pop bc
	ld a, [hl]
	ldh [hRoomObjectType], a
;>@out if hRoomObjectType in (0xD3, 0x5C) and not wIsIndoor:
	cp $d3
	jr z, .outdoors

	cp $5c
	jr nz, .torchCheck

.outdoors
;=@out
	ld a, [wIsIndoor]
	and a
	jr nz, .torchCheck

;>     RemoveRoomObject()
	call RemoveRoomObject
;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(2)         # a puff of smoke
	ld a, $02
	call AddTransientVfx
;>     hJingle = 0x2F
	ld a, $2f
	ldh [hJingle], a
;>     return ClearEntityStatus_18(slot)
	jr .remove

.torchCheck
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     return MagicPowderEntityHandler.hit(0)
	jp z, .hit

;> if hRoomObjectType != 0xAB:    # not an unlit torch
	ldh a, [hRoomObjectType]
	cp $ab
;>     return
	jr nz, .done

;> wRoomObjects[square] = 0xAC    # lit
	ld [hl], $ac
;> wEntityPrivate1[slot] = high(addr)   # where the torch is
	ld d, h
	ld e, l
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], d
;> wEntityPrivate2[slot] = low(addr)
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], e
;> wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;> wEntityDropTimer[slot] = 0x80  # how long it burns
	call GetEntityDropTimer
	ld [hl], $80
;> wEntityX[slot] = hBGPosX
	ld hl, wEntityX
	add hl, bc
	ldh a, [hBGPosX]
	ld [hl], a
;> wEntityY[slot] = hBGPosY
	ld hl, wEntityY
	add hl, bc
	ldh a, [hBGPosY]
	ld [hl], a
;> wRoomEventCounter += 1
	ld hl, wRoomEventCounter
	inc [hl]
;> if wRoomDarkness:
	ld a, [wRoomDarkness]
	and a
	jr z, .lit

;>     wRoomDarkness -= 4
	sub $04
	ld [wRoomDarkness], a

.lit
;> wEntityTimer[slot] = 0
	call GetEntityTimer
	ld [hl], b
;> hNoiseSfx = 0x12
	ld a, $12
	ldh [hNoiseSfx], a
;> return DrawTorchTiles(LitTorchTiles)
	ld de, LitTorchTiles
	push de
	jp DrawTorchTiles

.remove
	jp ClearEntityStatus_18

.hit
;> # .hit(t):
;>@h if t < 0x10 and not wEntityPrivate4[slot]:
	cp $10
	jr nc, .done

;=@h
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	ret nz

;>     wProjectileWeaponType = 9  # magic powder
	ld a, $09
	ld [wProjectileWeaponType], a
;>     EntityHitOtherEntities(slot)
	call EntityHitOtherEntities

.done
;> return
	ret

.torch
;> # .torch:
;> if wEntityDropTimer[slot]:     # still burning
;>     return
	call GetEntityDropTimer
	jr nz, .burning

;> hBGPosX = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hBGPosX], a
;> hBGPosY = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hBGPosY], a
;> addr = wEntityPrivate1[slot] << 8 | wEntityPrivate2[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld d, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
;> mem[addr] = 0xAB              # the torch goes out
	ld a, $ab
	ld [de], a
;> ClearEntityStatus_18(slot)
	call ClearEntityStatus_18
;> if hMapRoom == 0x74:
	ldh a, [hMapRoom]
	cp $74
;>     return
	ret z

;> wRoomEventCounter -= 1
	ld hl, wRoomEventCounter
	dec [hl]
;> if wRoomDarkness < 0x0C:
	ld a, [wRoomDarkness]
	cp $0c
	jr nc, .out

;>     wRoomDarkness += 4
	add $04
	ld [wRoomDarkness], a

.out
;> return DrawTorchTiles(UnlitTorchTiles)
	ld de, UnlitTorchTiles
	push de
	jp DrawTorchTiles

.burning
	ret


;@ path: item/magic_powder
;@ The Magic Powder cloud in 6 sprite frames, 12 bytes each: 3 sprites of (dy, dx, tile,
;@ attributes), all tile $24 (a sparkle) in palettes 0 and 1. The frame is (timer >> 2) & 7.
MagicPowderSprites::
	db $06, $fe, $24, $00, $03, $04, $24, $10, $05, $0a, $24, $00
	db $05, $fe, $24, $10, $02, $04, $24, $00, $04, $0a, $24, $10
	db $03, $ff, $24, $00, $01, $04, $24, $10, $02, $09, $24, $00
	db $01, $00, $24, $10, $ff, $04, $24, $00, $00, $06, $24, $10
	db $00, $01, $24, $00, $fe, $03, $24, $10, $ff, $05, $24, $00
	db $ff, $01, $24, $10, $fd, $03, $24, $00, $fe, $05, $24, $10

;@ def DrawMagicPowder(slot: bc)
;@ path: item/magic_powder
;@ Draws the powder cloud while the timer runs: frame (timer >> 2) & 7 of MagicPowderSprites.
;@ test: skip writes OAM through bank 0
DrawMagicPowder::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr z, .done

;>@f     src = MagicPowderSprites + ((t >> 2) & 7) * 12
	rra
	rra
	and $07
	sla a
	sla a
	ld e, a
;=@f
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, MagicPowderSprites
	add hl, de
;>     DrawEntitySprites(src, 3)
	ld c, $03
	call DrawEntitySprites

.done
	ret


;@ def DrawTorchTiles(tiles: stack)
;@ path: item/magic_powder
;@ Queues the draw of a torch's 2 x 2 tiles at the square hBGPosX/hBGPosY: two vertical
;@ columns of 2 tiles (draw mode $81) from the 4-byte table whose address the caller pushed.
;@ test: skip queues background draws
DrawTorchTiles::
;> GetBGAddress()                 # -> hBGAddrHigh/Low
	call GetBGAddress
;> n = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize = n + 0x0A
	add $0a
	ld [wDrawCommandsSize], a
;>@cmd wDrawCommand[n:n + 11] = [hBGAddrHigh, hBGAddrLow, 0x81, tiles[0], tiles[1], hBGAddrHigh, hBGAddrLow + 1, 0x81, tiles[2], tiles[3], 0]
	pop de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
;=@cmd
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
;=@cmd
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;=@cmd
	ld a, $81
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
;=@cmd
	ld [hli], a
	xor a
	ld [hl], a
	ret


;@ path: entity/helpers
;@ GetSpeedDirection16_18 for a mostly horizontal speed (|y| < |x|): the direction 0-15 (0 right,
;@ 4 down, 8 left, 12 up) by quadrant (8 bytes each: y+ x+, y- x+, y+ x-, y- x-) and |y| / 4.
Direction16Flat_18::
	db $00, $00, $01, $01, $01, $02, $02, $02
	db $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06
	db $08, $08, $09, $09, $09, $0a, $0a, $0a
;@ path: entity/helpers
;@ The same for a mostly vertical speed (|y| >= |x|), by quadrant and |x| / 4.
Direction16Steep_18::
	db $04, $04, $03, $03, $03, $02, $02, $02
	db $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06
	db $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

;@ def GetSpeedDirection16_18() -> a
;@ path: entity/helpers
;@ Which of 16 directions (0 right, 4 down, 8 left, 12 up) the speed vector hMultiPurpose1 (x) /
;@ hMultiPurpose0 (y) points to, as left by GetVectorTowardsLink. Speeds up to $1F.
;@ test: skip reads its input from HRAM
GetSpeedDirection16_18::
;>@q q = ((hMultiPurpose1 >> 7) << 1 | (hMultiPurpose0 >> 7)) * 8   # the quadrant
	ldh a, [hMultiPurpose0]
	rlca
	and $01
	ld e, a
	ldh a, [hMultiPurpose1]
	rlca
;=@q
	rla
	and $02
	or e
	rla
	rla
	rla
;=@q
	and $18
	ld h, a
;> ax = abs(hMultiPurpose1)
	ldh a, [hMultiPurpose1]
	bit 7, a
	jr z, .absX

	cpl
	inc a

.absX
;> ay = abs(hMultiPurpose0)
	ld d, a
	ldh a, [hMultiPurpose0]
	bit 7, a
	jr z, .absY

	cpl
	inc a

.absY
;> if ay < ax:
	cp d
	jr nc, .steep

;>@flat     return mem[Direction16Flat_18 + ((ay >> 2) + q)]
	sra a
	sra a
	add h
	ld e, a
	ld d, b
;=@flat
	ld hl, Direction16Flat_18
	add hl, de
	ld a, [hl]
	ret

.steep
;>@steep return mem[Direction16Steep_18 + ((ax >> 2) + q)]
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
;=@steep
	ld hl, Direction16Steep_18
	add hl, de
	ld a, [hl]
	ret


;@ path: item/hookshot
;@ Link's pose while the hookshot is out, by his direction (right, left, up, down): animation
;@ states $11, $10, $0F, $0E.
HookshotLinkPoses::
	db $11, $10, $0f, $0e

;@ def HookshotEntityHandler(slot: bc)
;@ path: item/hookshot
;@ Entity $03: the hookshot. While it is out Link stands still in his hookshot pose and the chain
;@ is drawn (DrawHookshotChain, noise $0B every 4 frames). State 0: it flies out for its timer,
;@ hitting enemies (weapon type 6); a wall makes it clink (jingle 7, effect 5) and turn back;
;@ indoors objects $9E (flying up) and $9F (flying down) make it spawn entity $68 there (facing 0
;@ or 1) and turn back. When the timer is out it flies back to Link (speed $30). In state 1 (it has
;@ caught hold of something) it pulls Link to itself at speed $30. It is gone once it touches
;@ Link.
;@ test: skip moves Link and spawns entities
HookshotEntityHandler::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wHookshotInUse = 2
	ld [wHookshotInUse], a
;> wHookshotOut = 2
	ld [wHookshotOut], a
;> wHookshotChainSlot = slot + 1
	ld a, c
	inc a
	ld [wHookshotChainSlot], a
;> ResetSpinAttackAndDash()
	xor a
	call ResetSpinAttackAndDash
;> wLinkPushedTimer = 0
	ld [wLinkPushedTimer], a
;>@pose hLinkAnimationState = mem[HookshotLinkPoses + hLinkDirection]
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, HookshotLinkPoses
	add hl, de
	ld a, [hl]
;=@pose
	ldh [hLinkAnimationState], a
;> DrawHookshotChain()
	call DrawHookshotChain
;> ReturnIfNonInteractive_18()
	call ReturnIfNonInteractive_18
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .state

;>     hNoiseSfx = 0x0B
	ld a, $0b
	ldh [hNoiseSfx], a

.state
;> if hActiveEntityState != 0:    # hooked: pull Link
	ldh a, [hActiveEntityState]
	and a
	jr z, .flying

;>     GetVectorTowardsLink(slot, 0x30)
	ld a, $30
	call GetVectorTowardsLink
;>     hLinkSpeedY = -hMultiPurpose0 & 0xFF   # from Link to the hook
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ldh [hLinkSpeedY], a
;>     hLinkSpeedX = -hMultiPurpose1 & 0xFF
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ldh [hLinkSpeedX], a
;>     ApplyLinkSpeed()
	push bc
	call ApplyLinkSpeed
	pop bc
	jr .back

.flying
;> else:
;>     UpdateEntityPosWithSpeed_18(slot)
	call UpdateEntityPosWithSpeed_18
;>     if wEntityTimer[slot]:
;>         return HookshotEntityHandler.out(slot)
	call GetEntityTimer
	jr nz, .out

;>     SetEntitySpeedTowardsLink(slot, 0x30)   # on its way back
	ld a, $30
	call SetEntitySpeedTowardsLink

.back
;> if EntityTouchesLink(slot):        # back at Link
	call EntityTouchesLink
	jr nc, .done

;>     wHookshotOut = 0
	xor a
	ld [wHookshotOut], a
;>     ClearEntityStatus_18(slot)
	call ClearEntityStatus_18
;> return
	jr .done

.out
;> # .out:
;> wProjectileWeaponType = 6      # the hookshot
	ld a, $06
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities(slot)
	call EntityHitOtherEntities
;> if wEntityCollisions[slot]:    # hit a wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>     return HookshotEntityHandler.clink()
	jr nz, .clink

;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     return
	jr z, .done

;> GetObjectUnderEntity_18(slot)
	call GetObjectUnderEntity_18
;> sy = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> if sy == 0:
	and a
;>     return
	jr z, .done

;> target = 0x9E if sy & 0x80 else 0x9F
	ld e, $9e
	bit 7, a
	jr nz, .check

	ld e, $9f

.check
;> if hRoomObjectType != target:
	ldh a, [hRoomObjectType]
	cp e
;>     return
	jr nz, .done

;> n, failed = SpawnEntity(slot, 0x68)
	ld a, $68
	call SpawnEntity
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
;>@dir wEntityDirection[n] = 0 if hRoomObjectType == 0x9E else 1
	ldh a, [hRoomObjectType]
	cp $9e
	ld a, $00
	jr z, .dir

	inc a

.dir
;=@dir
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;> wEntityTimer[slot] = 0         # turn back
	call GetEntityTimer
	ld [hl], b

.done
	ret

.clink
;> # .clink:
;> wEntityTimer[slot] = 0         # turn back
	call GetEntityTimer
	ld [hl], b
;> hJingle = 7
	ld a, $07
	ldh [hJingle], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(5)
	ld a, $05
	call AddTransientVfx
	ret


;@ path: item/hookshot
;@ The hook's sprite pair: tile $36 and its mirror image.
HookshotPair::
	db $36, $00, $36, $20

;@ def DrawHookshotChain()
;@ path: item/hookshot
;@ Draws the hook (HookshotPair) and 3 chain links (tile $24) between Link and the hook, at 1/4,
;@ 2/4 and 3/4 of the way. Each link's y is only written on every other frame (links 1 and 3,
;@ then link 2), so the chain flickers.
;@ test: skip writes OAM
DrawHookshotChain::
;> DrawEntity16x16(HookshotPair)
	ld de, HookshotPair
	call DrawEntity16x16
;>@sx stepX = (hActiveEntityX - hLinkX) >> 2   # signed; in hMultiPurpose2 (hMultiPurpose0 sums up)
	ldh a, [hActiveEntityX]
	ld hl, hLinkX
	sub [hl]
	sra a
	sra a
	ldh [hMultiPurpose0], a
;=@sx
	ldh [hMultiPurpose2], a
;>@sy stepY = (hActiveEntityY - hLinkY) >> 2   # in hMultiPurpose3 (hMultiPurpose1 sums up)
	ldh a, [hActiveEntityY]
	ld hl, hLinkY
	sub [hl]
	sra a
	sra a
	ldh [hMultiPurpose1], a
;=@sy
	ldh [hMultiPurpose3], a
;>@oam oam = wOAMBuffer + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
;=@oam
	push hl
	pop de
;>@loop for k in (3, 2, 1):
	ld a, $03

.loop
;>     if (k ^ hFrameCounter) & 1 == 0:
	ldh [hMultiPurpose4], a
	ld hl, hFrameCounter
	xor [hl]
	and $01
	jr nz, .x

;>         oam.y = hLinkY + hMultiPurpose1
	ldh a, [hLinkY]
	ld hl, hMultiPurpose1
	add [hl]
	ld [de], a

.x
;>     oam.x = hLinkX + hMultiPurpose0 + 4
	inc de
	ldh a, [hLinkX]
	ld hl, hMultiPurpose0
	add [hl]
	add $04
	ld [de], a
;>     oam.tile = 0x24
	inc de
	ld a, $24
	ld [de], a
	inc de
;>     oam.attr = 0
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
;=@loop
	ldh a, [hMultiPurpose4]
	dec a
	jr nz, .loop

;> ReserveOAMEntriesFar(3)
	ld a, $03
	call ReserveOAMEntriesFar
	ret


;@ def PushLinkOutOfEntity_18(slot: bc) -> carry
;@ path: entity/helpers
;@ Makes the entity solid: when Link touches it, Link is put back where he stood last frame
;@ (StopLinkAtEntity_18) and carry is returned; otherwise no carry.
;@ test: skip calls the bank 3 collision check
PushLinkOutOfEntity_18::
;> if not EntityTouchesLink(slot):            # Link's hitbox does not touch the entity
	call EntityTouchesLink
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

;@ def AnimateEntityByDirection_18(slot: bc)
;@ path: entity/helpers
;@ Walking animation of a character: the sprite variant is the first frame of its facing direction
;@ (DirectionSpriteVariants_18) plus 0 or 1, switching every 16 frames of its own counter.
;@ test: skip reads a ROM table
AnimateEntityByDirection_18::
;> dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;> base = mem[DirectionSpriteVariants_18 + dir]
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
;> SetEntitySpriteVariant(slot, base | (step & 1))   # set the sprite variant
	pop hl
	and $01
	or [hl]
	jp SetEntitySpriteVariant


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

;> if wLinkShowItemPoseActive or wDialogState or wInventoryAppearing:
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


;@ def ApplyRecoilIfNeeded_18(slot: bc)
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
;> AddPowerHitTrailVfx(slot)
	call AddPowerHitTrailVfx
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

;>     EntityCheckWalls(slot)               # stop at walls
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


;@ def UpdateEntityPosWithSpeed_18(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its speed: x by wEntitySpeedX, then y by wEntitySpeedY (the y arrays lie
;@ 16 bytes after the x arrays, so the same routine runs with slot + 16).
;@ test: slot = rand(0, 15)
UpdateEntityPosWithSpeed_18::
;> UpdateEntityXWithSpeed_18(slot)
	call UpdateEntityXWithSpeed_18
;> UpdateEntityYWithSpeed_18(slot)   # falls through

;@ def UpdateEntityYWithSpeed_18(slot: bc)
;@ path: entity/helpers
;@ Moves the entity vertically by wEntitySpeedY (UpdateEntityXWithSpeed_18 on slot + 16, where
;@ the y arrays lie).
;@ test: slot = rand(0, 15)
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


;@ def UpdateEntityXWithSpeed_18(slot: bc)
;@ path: entity/helpers
;@ Adds the entity's x speed to its x position. The speed is signed in 1/16 pixels per frame:
;@ the low nibble goes into the fraction byte wEntitySpeedXAcc (its carry counts as one more
;@ pixel), the high nibble (sign-extended) is added to wEntityX.
;@ test: slot = rand(0, 15)
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


;@ def UpdateEntityZWithSpeed_18(slot: bc)
;@ path: entity/helpers
;@ Adds the entity's height speed wEntitySpeedZ to its height wEntityZ, the same way as
;@ UpdateEntityXWithSpeed_18 (1/16 pixels, fraction in wEntitySpeedZAcc).
;@ test: slot = rand(0, 15)
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

;@ def GetEntityXDistanceToLink_18(slot: bc) -> (e, d)
;@ path: entity/helpers
;@ Horizontal distance from the entity to Link: d = hLinkX - wEntityX (signed), e = the direction
;@ in which Link is (0 right, 1 left).
;@ test: slot = rand(0, 15)
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


;@ def GetEntityYDistanceToLink_18(slot: bc) -> (e, d)
;@ path: entity/helpers
;@ Vertical distance from the entity to Link: d = hLinkY - wEntityY (signed), e = the direction
;@ in which Link is (2 up, 3 down).
;@ test: slot = rand(0, 15)
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


;@ def GetEntityDirectionToLink_18(slot: bc) -> e
;@ path: entity/helpers
;@ Direction in which Link is seen from the entity, along the axis where he is farther away:
;@ 0 right, 1 left, 2 up, 3 down (the x direction when both distances are equal or y is smaller).
;@ test: slot = rand(0, 15)
GetEntityDirectionToLink_18::
;> ex, dx = GetEntityXDistanceToLink_18(slot)
	call GetEntityXDistanceToLink_18
;> hMultiPurpose0 = ex
	ld a, e
	ldh [hMultiPurpose0], a
;> adx = (dx if dx < 0x80 else 0x100 - dx)
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
;> ady = (dy if dy < 0x80 else 0x100 - dy)
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


;@ def ClearEntityStatus_18(slot: bc)
;@ path: entity/helpers
;@ Removes the entity: its slot status becomes 0 (free).
;@ test: slot = rand(0, 15)
ClearEntityStatus_18::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ def BossDeathSequence_18(slot: bc)
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

;@ def BossDeathStart_18(slot: bc)
;@ path: boss/death
;@ Step 0: the boss starts flashing for $A0 frames.
;@ test: slot = rand(0, 15)
BossDeathStart_18::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> BossDeathNextStep_18(slot)     # falls through

;@ def BossDeathNextStep_18(slot: bc)
;@ path: boss/death
;@ Goes on to the next step of the boss death (wEntityPrivate2 + 1).
;@ test: slot = rand(0, 15)
BossDeathNextStep_18::
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


;@ def BossDeathFlash_18(slot: bc)
;@ path: boss/death
;@ Step 1: when the timer runs out, flashes on for another $C0 frames and goes on to the
;@ explosions.
;@ test: slot = rand(0, 15)
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


;@ def BossDeathExplode_18(slot: bc)
;@ path: boss/death
;@ Step 2: explosions burst around the boss every 8 frames; when the timer runs out the fight
;@ ends: a sound plays, the room's event is marked done (the boss stays beaten) and the boss
;@ is replaced by its reward (DefeatEntityWithDrop).
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
;>     return DefeatEntityWithDrop(slot)
	jp DefeatEntityWithDrop

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


;@ def UnusedSpawnHeartContainer_18(slot: bc)
;@ path: unused/bank18
;@ Not called from anywhere. Would spawn a heart container (entity $36) at (hMultiPurpose0,
;@ hMultiPurpose1) - in side view with an upward speed (given to the own slot, not the new one),
;@ elsewhere popping up from height 8 - remove the calling entity and play noise effect $1A.
;@ test: skip spawns an entity through bank 3
UnusedSpawnHeartContainer_18::
;> new, full = SpawnEntity(slot, 0x36)          # spawn an entity, its slot in de
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
